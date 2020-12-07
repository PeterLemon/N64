// Tests combiner overflow in TEXRECT e.g Tex0+Tex1+PrimColor. What happens on overflow (>1?) or underflow (<0)
// Author: Lemmy with original sources from Peter Lemon's test sources
arch n64.cpu
endian msb
output "CombinerOverflow.N64", create
fill 1052672 // Set ROM Size

origin $00000000
base $80000000 // Entry Point Of Code
include "LIB/N64.INC" // Include N64 Definitions
include "LIB/N64_HEADER.ASM" // Include 64 Byte Header & Vector Table
insert "LIB/N64_BOOTCODE.BIN" // Include 4032 Byte Boot Code

Start:
  include "LIB/N64_GFX.INC" // Include Graphics Macros
  N64_INIT() // Run N64 Initialisation Routine

  ScreenNTSC(320, 240, BPP16|AA_MODE_2, $A0100000) // Screen NTSC: 320x240, 16BPP, Resample Only, DRAM Origin $A0100000

  WaitScanline($200) // Wait For Scanline To Reach Vertical Blank

  DPC(RDPBuffer, RDPBufferEnd) // Run DPC Command Buffer: Start, End

Loop:
  j Loop
  nop // Delay Slot

align(8) // Align 64-Bit
RDPBuffer:
arch n64.rdp
  Set_Scissor 0<<2,0<<2, 0,0, 320<<2,240<<2 // Set Scissor: XH 0.0,YH 0.0, Scissor Field Enable Off,Field Off, XL 320.0,YL 240.0
  Set_Other_Modes CYCLE_TYPE_FILL // Set Other Modes
  Set_Color_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,320-1, $00100000 // Set Color Image: FORMAT RGBA,SIZE 16B,WIDTH 320, DRAM ADDRESS $00100000
  Set_Fill_Color $39CF39CF // Set Fill Color: PACKED COLOR 16B R5G5B5A1 Pixels
  Fill_Rectangle 319<<2,239<<2, 0<<2,0<<2 // Fill Rectangle: XL 319.0,YL 239.0, XH 0.0,YH 0.0

  macro LoadTexture(variable texture) {
    Sync_Pipe
    Sync_Load
    Sync_Tile
    Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_32B,1, texture
    Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_32B,2, $000>>3, 0,0, 0,0,0,0, 0,0,0,0
    Load_Block 0<<2,0<<2, 0, 255, 0
    Sync_Pipe
    Sync_Load
    Sync_Tile
  }

  macro Draw(variable envColor, variable left, variable top) {
    Set_Env_Color envColor
    Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_32B,4, $000 >> 3, 0,0, 0,0,0,0, 0,0,0,0
    Set_Tile_Size 0<<2, 0<<2, 0, 15<<2, 15<<2
    Texture_Rectangle (16*4+left)<<2,(16*4+top)<<2, 0, left<<2,top<<2, 0<<5,0<<5, 1<<8,1<<8
    Sync_Pipe
    Sync_Load
    Sync_Tile
  }

  Set_Other_Modes CYCLE_TYPE_1_CYCLE|BI_LERP_0|BI_LERP_1|B_M2A_0_1|FORCE_BLEND|IMAGE_READ_EN

  Set_Prim_Color 0,0,0

  // First row: Test overflow: Left is texture unchanged, next adds 1 to alpha, next adds 1 to red, next adds 1 to green. No room for blue
  // First cycle:  Color=(1-0)*EnvColor+Tex0Color,     Alpha=(1-0)*EnvAlpha+Tex0Alpha
  // Second cycle: Color=(0-0)*0+CombinedColor, Alpha=(0-PrimAlpha)*EnvAlpha+CombinedColor
  SetCombineMode1(A_1, B_0, C_EnvColor, D_Tex0Color, AA_1, BA_0, CA_EnvAlpha, DA_Tex0Alpha)

  LoadTexture(AlphaGradient16x16x32b)
  Draw($00000000, 10, 10)
  Draw($000000FF, 80, 10)

  LoadTexture(RedGradient16x16x32b)
  Draw($00000000, 160, 10)
  Draw($FF000000, 230, 10)

  Set_Other_Modes CYCLE_TYPE_2_CYCLE|BI_LERP_0|BI_LERP_1|B_M2A_0_1|FORCE_BLEND|IMAGE_READ_EN

  // Second row (left textures): The second stage removes the value from before. This tells us if the clamping happens at each cycle or once in total
  // First cycle:  Color=(1-0)*EnvColor+Tex0Color,             Alpha=(1-0)*EnvAlpha+Tex0Alpha
  // Second cycle: Color=(0-PrimColor)*EnvColor+CombinedColor, Alpha=(0-PrimAlpha)*EnvAlpha+CombinedColor
  Set_Prim_Color 0,0,$FFFFFFFF

  SetCombineMode2(A_1, B_0, C_EnvColor, D_Tex0Color, AA_1, BA_0, CA_EnvAlpha, DA_Tex0Alpha, A_0, B_PrimColor, C_EnvColor, D_CombinedColor, AA_0, BA_PrimAlpha, CA_EnvAlpha, DA_CombinedAlpha)

  LoadTexture(AlphaGradient16x16x32b)
  Draw($000000FF, 10, 80)

  LoadTexture(RedGradient16x16x32b)
  Draw($FF000000, 160, 80)

  // Second row (right textures): Going negative (0.0 to -2.0)
  // First cycle:  Color=(0-0)*0+Tex0Color,     Alpha=(1-0)*Tex0Alpha+Tex0Alpha
  // Second cycle: Color=(0-0)*0+CombinedColor, Alpha=(0-CombinedAlpha)*EnvAlpha+0

  SetCombineMode2(A_0, B_0, C_0, D_Tex0Color, AA_1, BA_0, CA_Tex0Alpha, DA_Tex0Alpha, A_0, B_0, C_0, D_CombinedColor, AA_0, BA_CombinedAlpha, CA_EnvAlpha, DA_0)

  LoadTexture(AlphaGradient16x16x32b)
  Draw($000000FF, 80, 80)

  // First cycle:  Color=(1-0)*Tex0Color+Tex0Color,      Alpha=(0-0)*0+1
  // Second cycle: Color=(0-CombinedColor)*PrimColor+0,  Alpha=(0-0)*0+1
  SetCombineMode2(A_1, B_0, C_Tex0Color, D_Tex0Color, AA_0, BA_0, CA_0, DA_1, A_0, B_CombinedColor, C_PrimColor, D_0, AA_0, BA_0, CA_0, DA_1)

  LoadTexture(RedGradient16x16x32b)
  Draw($FF000000, 230, 80)

  // Third row (left textures): Get to range 2..3
  // First cycle:  Color=(1-0)*EnvColor+Tex0Color,           Alpha=(1-0)*EnvAlpha+Tex0Alpha
  // Second cycle: Color=(1-0)*CombinedColor+EnvColor,       Alpha=(CombinedAlpha-0)*PrimAlpha+EnvAlpha
  SetCombineMode2(A_1, B_0, C_EnvColor, D_Tex0Color, AA_1, BA_0, CA_EnvAlpha, DA_Tex0Alpha, A_1, B_0, C_CombinedColor, D_EnvColor, AA_CombinedAlpha, BA_0, CA_PrimAlpha, DA_EnvAlpha)

  LoadTexture(AlphaGradient16x16x32b)
  Draw($000000FF, 10, 150)

  LoadTexture(RedGradient16x16x32b)
  Draw($FF000000, 160, 150)

  // Third row (right textures): Get to range 2..4, which is as high as possible
  // First cycle:  Color=(1-0)*0+Tex0Color,                  Alpha=(1-0)*EnvAlpha+Tex0Alpha
  // Second cycle: Color=(1-0)*0+CombinedColor               Alpha=(CombinedAlpha-0)*PrimAlpha+CombinedAlpha
  SetCombineMode2(A_1, B_0, C_0, D_Tex0Color, AA_1, BA_0, CA_EnvAlpha, DA_Tex0Alpha, A_1, B_0, C_0, D_CombinedColor, AA_CombinedAlpha, BA_0, CA_PrimAlpha, DA_CombinedAlpha)

  LoadTexture(AlphaGradient16x16x32b)
  Draw($000000FF, 80, 150)

  // First cycle:  Color=(1-0)*EnvColor+Tex0Color,           Alpha=(0-0)*0+1
  // Second cycle: Color=(1-0)*CombinedColor+CombinedColor,  Alpha=(0-0)*0+1
  SetCombineMode2(A_1, B_0, C_EnvColor, D_Tex0Color, AA_0, BA_0, CA_0, DA_1, A_1, B_0, C_CombinedColor, D_CombinedColor, AA_0, BA_0, CA_0, DA_1)
  LoadTexture(RedGradient16x16x32b)
  Draw($FF000000, 230, 150)

  Sync_Full
RDPBufferEnd:

align(8)
AlphaGradient16x16x32b:
dw $0000ff00, $00ff0001, $00ffff02, $ff000003, $ff00ff04, $ffff0005, $ffffff06, $0000ff07, $00ff0008, $00ffff09, $ff00000a, $ff00ff0b, $ffff000c, $ffffff0d, $0000ff0e, $00ff000f
dw $ff00ff12, $ffff0013, $00ffff10, $ff000011, $00ff0016, $00ffff17, $ffffff14, $0000ff15, $ffff001a, $ffffff1b, $ff000018, $ff00ff19, $00ffff1e, $ff00001f, $0000ff1c, $00ff001d
dw $ff00ff20, $ffff0021, $ffffff22, $0000ff23, $00ff0024, $00ffff25, $ff000026, $ff00ff27, $ffff0028, $ffffff29, $0000ff2a, $00ff002b, $00ffff2c, $ff00002d, $ff00ff2e, $ffff002f
dw $00ff0032, $00ffff33, $ffffff30, $0000ff31, $ffff0036, $ffffff37, $ff000034, $ff00ff35, $00ffff3a, $ff00003b, $0000ff38, $00ff0039, $ffffff3e, $0000ff3f, $ff00ff3c, $ffff003d
dw $00ff0040, $00ffff41, $ff000042, $ff00ff43, $ffff0044, $ffffff45, $0000ff46, $00ff0047, $00ffff48, $ff000049, $ff00ff4a, $ffff004b, $ffffff4c, $0000ff4d, $00ff004e, $00ffff4f
dw $ffff0052, $ffffff53, $ff000050, $ff00ff51, $00ffff56, $ff000057, $0000ff54, $00ff0055, $ffffff5a, $0000ff5b, $ff00ff58, $ffff0059, $ff00005e, $ff00ff5f, $00ff005c, $00ffff5d
dw $ffff0060, $ffffff61, $0000ff62, $00ff0063, $00ffff64, $ff000065, $ff00ff66, $ffff0067, $ffffff68, $0000ff69, $00ff006a, $00ffff6b, $ff00006c, $ff00ff6d, $ffff006e, $ffffff6f
dw $00ffff72, $ff000073, $0000ff70, $00ff0071, $ffffff76, $0000ff77, $ff00ff74, $ffff0075, $ff00007a, $ff00ff7b, $00ff0078, $00ffff79, $0000ff7e, $00ff007f, $ffff007c, $ffffff7d
dw $00ffff80, $ff000081, $ff00ff82, $ffff0083, $ffffff84, $0000ff85, $00ff0086, $00ffff87, $ff000088, $ff00ff89, $ffff008a, $ffffff8b, $0000ff8c, $00ff008d, $00ffff8e, $ff00008f
dw $ffffff92, $0000ff93, $ff00ff90, $ffff0091, $ff000096, $ff00ff97, $00ff0094, $00ffff95, $0000ff9a, $00ff009b, $ffff0098, $ffffff99, $ff00ff9e, $ffff009f, $00ffff9c, $ff00009d
dw $ffffffa0, $0000ffa1, $00ff00a2, $00ffffa3, $ff0000a4, $ff00ffa5, $ffff00a6, $ffffffa7, $0000ffa8, $00ff00a9, $00ffffaa, $ff0000ab, $ff00ffac, $ffff00ad, $ffffffae, $0000ffaf
dw $ff0000b2, $ff00ffb3, $00ff00b0, $00ffffb1, $0000ffb6, $00ff00b7, $ffff00b4, $ffffffb5, $ff00ffba, $ffff00bb, $00ffffb8, $ff0000b9, $00ff00be, $00ffffbf, $ffffffbc, $0000ffbd
dw $ff0000c0, $ff00ffc1, $ffff00c2, $ffffffc3, $0000ffc4, $00ff00c5, $00ffffc6, $ff0000c7, $ff00ffc8, $ffff00c9, $ffffffca, $0000ffcb, $00ff00cc, $00ffffcd, $ff0000ce, $ff00ffcf
dw $0000ffd2, $00ff00d3, $ffff00d0, $ffffffd1, $ff00ffd6, $ffff00d7, $00ffffd4, $ff0000d5, $00ff00da, $00ffffdb, $ffffffd8, $0000ffd9, $ffff00de, $ffffffdf, $ff0000dc, $ff00ffdd
dw $0000ffe0, $00ff00e1, $00ffffe2, $ff0000e3, $ff00ffe4, $ffff00e5, $ffffffe6, $0000ffe7, $00ff00e8, $00ffffe9, $ff0000ea, $ff00ffeb, $ffff00ec, $ffffffed, $0000ffee, $00ff00ef
dw $ff00fff2, $ffff00f3, $00fffff0, $ff0000f1, $00ff00f6, $00fffff7, $fffffff4, $0000fff5, $ffff00fa, $fffffffb, $ff0000f8, $ff00fff9, $00fffffe, $ff0000ff, $0000fffc, $00ff00fd
align(8)
RedGradient16x16x32b:
dw $008000ff, $010000ff, $028000ff, $030000ff, $048000ff, $050000ff, $068000ff, $070000ff, $088000ff, $090000ff, $0a8000ff, $0b0000ff, $0c8000ff, $0d0000ff, $0e8000ff, $0f0000ff
dw $128000ff, $130000ff, $108000ff, $110000ff, $168000ff, $170000ff, $148000ff, $150000ff, $1a8000ff, $1b0000ff, $188000ff, $190000ff, $1e8000ff, $1f0000ff, $1c8000ff, $1d0000ff
dw $208000ff, $210000ff, $228000ff, $230000ff, $248000ff, $250000ff, $268000ff, $270000ff, $288000ff, $290000ff, $2a8000ff, $2b0000ff, $2c8000ff, $2d0000ff, $2e8000ff, $2f0000ff
dw $328000ff, $330000ff, $308000ff, $310000ff, $368000ff, $370000ff, $348000ff, $350000ff, $3a8000ff, $3b0000ff, $388000ff, $390000ff, $3e8000ff, $3f0000ff, $3c8000ff, $3d0000ff
dw $408000ff, $410000ff, $428000ff, $430000ff, $448000ff, $450000ff, $468000ff, $470000ff, $488000ff, $490000ff, $4a8000ff, $4b0000ff, $4c8000ff, $4d0000ff, $4e8000ff, $4f0000ff
dw $528000ff, $530000ff, $508000ff, $510000ff, $568000ff, $570000ff, $548000ff, $550000ff, $5a8000ff, $5b0000ff, $588000ff, $590000ff, $5e8000ff, $5f0000ff, $5c8000ff, $5d0000ff
dw $608000ff, $610000ff, $628000ff, $630000ff, $648000ff, $650000ff, $668000ff, $670000ff, $688000ff, $690000ff, $6a8000ff, $6b0000ff, $6c8000ff, $6d0000ff, $6e8000ff, $6f0000ff
dw $728000ff, $730000ff, $708000ff, $710000ff, $768000ff, $770000ff, $748000ff, $750000ff, $7a8000ff, $7b0000ff, $788000ff, $790000ff, $7e8000ff, $7f0000ff, $7c8000ff, $7d0000ff
dw $808000ff, $810000ff, $828000ff, $830000ff, $848000ff, $850000ff, $868000ff, $870000ff, $888000ff, $890000ff, $8a8000ff, $8b0000ff, $8c8000ff, $8d0000ff, $8e8000ff, $8f0000ff
dw $928000ff, $930000ff, $908000ff, $910000ff, $968000ff, $970000ff, $948000ff, $950000ff, $9a8000ff, $9b0000ff, $988000ff, $990000ff, $9e8000ff, $9f0000ff, $9c8000ff, $9d0000ff
dw $a08000ff, $a10000ff, $a28000ff, $a30000ff, $a48000ff, $a50000ff, $a68000ff, $a70000ff, $a88000ff, $a90000ff, $aa8000ff, $ab0000ff, $ac8000ff, $ad0000ff, $ae8000ff, $af0000ff
dw $b28000ff, $b30000ff, $b08000ff, $b10000ff, $b68000ff, $b70000ff, $b48000ff, $b50000ff, $ba8000ff, $bb0000ff, $b88000ff, $b90000ff, $be8000ff, $bf0000ff, $bc8000ff, $bd0000ff
dw $c08000ff, $c10000ff, $c28000ff, $c30000ff, $c48000ff, $c50000ff, $c68000ff, $c70000ff, $c88000ff, $c90000ff, $ca8000ff, $cb0000ff, $cc8000ff, $cd0000ff, $ce8000ff, $cf0000ff
dw $d28000ff, $d30000ff, $d08000ff, $d10000ff, $d68000ff, $d70000ff, $d48000ff, $d50000ff, $da8000ff, $db0000ff, $d88000ff, $d90000ff, $de8000ff, $df0000ff, $dc8000ff, $dd0000ff
dw $e08000ff, $e10000ff, $e28000ff, $e30000ff, $e48000ff, $e50000ff, $e68000ff, $e70000ff, $e88000ff, $e90000ff, $ea8000ff, $eb0000ff, $ec8000ff, $ed0000ff, $ee8000ff, $ef0000ff
dw $f28000ff, $f30000ff, $f08000ff, $f10000ff, $f68000ff, $f70000ff, $f48000ff, $f50000ff, $fa8000ff, $fb0000ff, $f88000ff, $f90000ff, $fe8000ff, $ff0000ff, $fc8000ff, $fd0000ff