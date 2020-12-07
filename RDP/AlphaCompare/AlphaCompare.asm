// Tests alpha compare in TEXRECT (Alpha testing without blending. For both RGBA16 & RGBA32)
// Author: Lemmy with original sources from Peter Lemon's test sources
arch n64.cpu
endian msb
output "AlphaCompare.N64", create
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

Loop:
  WaitScanline($200) // Wait For Scanline To Reach Vertical Blank

  DPC(RDPBuffer, RDPBufferEnd) // Run DPC Command Buffer: Start, End

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

  // Load 32 bit texture
  Sync_Pipe
  Sync_Load
  Sync_Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_32B,1, Texture16x1x32b
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_32B,2, $000>>3, 0,0, 0,0,0,0, 0,0,0,0
  Load_Block 0<<2,0<<2, 0, 15, 0
  Sync_Pipe
  Sync_Load
  Sync_Tile

  // Load 16 bit texture
  Sync_Pipe
  Sync_Load
  Sync_Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,1, Texture16x1x16b
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,2, $100>>3, 0,0, 0,0,0,0, 0,0,0,0
  Load_Block 0<<2,0<<2, 0, 15, 0
  Sync_Pipe
  Sync_Load
  Sync_Tile

  // Draw opaque for reference 32 bit
  Set_Combine_Mode 8,16,7,7,  8,16,8,8,  7,7,1,7,  6,1,7,6   // Color=Tex0Color, Alpha=1
  Set_Other_Modes CYCLE_TYPE_1_CYCLE|BI_LERP_0|BI_LERP_1
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_32B,4, $000 >> 3, 0,0, 0,0,0,0, 0,0,0,0
  Set_Tile_Size 0<<2, 0<<2, 0, 15<<2, 0<<2
  Texture_Rectangle (16*4+8)<<2,(8+4)<<2, 0, 8<<2,8<<2, 0<<5,0<<5, 1<<8,1<<8
  Sync_Pipe
  Sync_Load
  Sync_Tile

  // Draw opaque for reference 16 bit
  Set_Combine_Mode 8,16,7,7,  8,16,8,8,  7,7,1,7,  6,1,7,6   // Color=Tex0Color, Alpha=1
  Set_Other_Modes CYCLE_TYPE_1_CYCLE|BI_LERP_0|BI_LERP_1
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,4, $100 >> 3, 0,0, 0,0,0,0, 0,0,0,0
  Set_Tile_Size 0<<2, 0<<2, 0, 15<<2, 0<<2
  Texture_Rectangle (16*4+80)<<2,(8+4)<<2, 0, 80<<2,8<<2, 0<<5,0<<5, 1<<8,1<<8
  Sync_Pipe
  Sync_Load
  Sync_Tile

  // Draw with transparency 32 bit
  Set_Combine_Mode 8,16,7,7,  8,16,8,8,  7,7,1,7,  1,1,7,1   // Color=Tex0Color, Alpha=Tex0Alpha
  Set_Other_Modes CYCLE_TYPE_1_CYCLE|BI_LERP_0|BI_LERP_1|B_M2A_0_1|FORCE_BLEND|IMAGE_READ_EN
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_32B,4, $000 >> 3, 0,0, 0,0,0,0, 0,0,0,0
  Set_Tile_Size 0<<2, 0<<2, 0, 15<<2, 0<<2
  Texture_Rectangle (16*4+8)<<2,(16+4)<<2, 0, 8<<2,16<<2, 0<<5,0<<5, 1<<8,1<<8
  Sync_Pipe
  Sync_Load
  Sync_Tile

  // Draw with transparency 16 bit
  Set_Combine_Mode 8,16,7,7,  8,16,8,8,  7,7,1,7,  1,1,7,1   // Color=Tex0Color, Alpha=Tex0Alpha
  Set_Other_Modes CYCLE_TYPE_1_CYCLE|BI_LERP_0|BI_LERP_1|B_M2A_0_1|FORCE_BLEND|IMAGE_READ_EN
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,4, $100 >> 3, 0,0, 0,0,0,0, 0,0,0,0
  Set_Tile_Size 0<<2, 0<<2, 0, 15<<2, 0<<2
  Texture_Rectangle (16*4+80)<<2,(16+4)<<2, 0, 80<<2,16<<2, 0<<5,0<<5, 1<<8,1<<8
  Sync_Pipe
  Sync_Load
  Sync_Tile

  // Draw with alpha disabled in the blender, but with alphaCompare on and blendColor=0 (32 bit)
  Set_Blend_Color $00000000
  Set_Combine_Mode 8,16,7,7,  8,16,8,8,  7,7,1,7,  1,1,7,1   // Color=Tex0Color, Alpha=Tex0Alpha
  Set_Other_Modes CYCLE_TYPE_1_CYCLE|BI_LERP_0|BI_LERP_1|ALPHA_COMPARE_EN
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_32B,4, $000 >> 3, 0,0, 0,0,0,0, 0,0,0,0
  Set_Tile_Size 0<<2, 0<<2, 0, 15<<2, 0<<2
  Texture_Rectangle (16*4+8)<<2,(24+4)<<2, 0, 8<<2,24<<2, 0<<5,0<<5, 1<<8,1<<8
  Sync_Pipe
  Sync_Load
  Sync_Tile

  // Draw with alpha disabled in the blender, but with alphaCompare on and blendColor=0 (16 bit)
  Set_Blend_Color $00000000
  Set_Combine_Mode 8,16,7,7,  8,16,8,8,  7,7,1,7,  1,1,7,1   // Color=Tex0Color, Alpha=Tex0Alpha
  Set_Other_Modes CYCLE_TYPE_1_CYCLE|BI_LERP_0|BI_LERP_1|ALPHA_COMPARE_EN
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,4, $100 >> 3, 0,0, 0,0,0,0, 0,0,0,0
  Set_Tile_Size 0<<2, 0<<2, 0, 15<<2, 0<<2
  Texture_Rectangle (16*4+80)<<2,(24+4)<<2, 0, 80<<2,24<<2, 0<<5,0<<5, 1<<8,1<<8
  Sync_Pipe
  Sync_Load
  Sync_Tile

  // Draw with alpha disabled in the blender, but with alphaCompare on and blendColor=01 (32 bit)
  Set_Blend_Color $00000001
  Set_Combine_Mode 8,16,7,7,  8,16,8,8,  7,7,1,7,  1,1,7,1   // Color=Tex0Color, Alpha=Tex0Alpha
  Set_Other_Modes CYCLE_TYPE_1_CYCLE|BI_LERP_0|BI_LERP_1|ALPHA_COMPARE_EN
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_32B,4, $000 >> 3, 0,0, 0,0,0,0, 0,0,0,0
  Set_Tile_Size 0<<2, 0<<2, 0, 15<<2, 0<<2
  Texture_Rectangle (16*4+8)<<2,(32+4)<<2, 0, 8<<2,32<<2, 0<<5,0<<5, 1<<8,1<<8
  Sync_Pipe
  Sync_Load
  Sync_Tile

  // Draw with alpha disabled in the blender, but with alphaCompare on and blendColor=01 (32 bit)
  Set_Blend_Color $00000001
  Set_Combine_Mode 8,16,7,7,  8,16,8,8,  7,7,1,7,  1,1,7,1   // Color=Tex0Color, Alpha=Tex0Alpha
  Set_Other_Modes CYCLE_TYPE_1_CYCLE|BI_LERP_0|BI_LERP_1|ALPHA_COMPARE_EN
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,4, $100 >> 3, 0,0, 0,0,0,0, 0,0,0,0
  Set_Tile_Size 0<<2, 0<<2, 0, 15<<2, 0<<2
  Texture_Rectangle (16*4+80)<<2,(32+4)<<2, 0, 80<<2,32<<2, 0<<5,0<<5, 1<<8,1<<8
  Sync_Pipe
  Sync_Load
  Sync_Tile

  // Draw with alpha disabled in the blender, but with alphaCompare on and blendColor=02 (32 bit)
  Set_Blend_Color $00000002
  Set_Combine_Mode 8,16,7,7,  8,16,8,8,  7,7,1,7,  1,1,7,1   // Color=Tex0Color, Alpha=Tex0Alpha
  Set_Other_Modes CYCLE_TYPE_1_CYCLE|BI_LERP_0|BI_LERP_1|ALPHA_COMPARE_EN
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_32B,4, $000 >> 3, 0,0, 0,0,0,0, 0,0,0,0
  Set_Tile_Size 0<<2, 0<<2, 0, 15<<2, 0<<2
  Texture_Rectangle (16*4+8)<<2,(40+4)<<2, 0, 8<<2,40<<2, 0<<5,0<<5, 1<<8,1<<8
  Sync_Pipe
  Sync_Load
  Sync_Tile

  // Draw with alpha disabled in the blender, but with alphaCompare on and blendColor=02 (32 bit)
  Set_Blend_Color $00000002
  Set_Combine_Mode 8,16,7,7,  8,16,8,8,  7,7,1,7,  1,1,7,1   // Color=Tex0Color, Alpha=Tex0Alpha
  Set_Other_Modes CYCLE_TYPE_1_CYCLE|BI_LERP_0|BI_LERP_1|ALPHA_COMPARE_EN
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,4, $100 >> 3, 0,0, 0,0,0,0, 0,0,0,0
  Set_Tile_Size 0<<2, 0<<2, 0, 15<<2, 0<<2
  Texture_Rectangle (16*4+80)<<2,(40+4)<<2, 0, 80<<2,40<<2, 0<<5,0<<5, 1<<8,1<<8
  Sync_Pipe
  Sync_Load
  Sync_Tile

  // Draw with alpha disabled in the blender, but with alphaCompare on and blendColor=03 (32 bit)
  Set_Blend_Color $00000003
  Set_Combine_Mode 8,16,7,7,  8,16,8,8,  7,7,1,7,  1,1,7,1   // Color=Tex0Color, Alpha=Tex0Alpha
  Set_Other_Modes CYCLE_TYPE_1_CYCLE|BI_LERP_0|BI_LERP_1|ALPHA_COMPARE_EN
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_32B,4, $000 >> 3, 0,0, 0,0,0,0, 0,0,0,0
  Set_Tile_Size 0<<2, 0<<2, 0, 15<<2, 0<<2
  Texture_Rectangle (16*4+8)<<2,(48+4)<<2, 0, 8<<2,48<<2, 0<<5,0<<5, 1<<8,1<<8
  Sync_Pipe
  Sync_Load
  Sync_Tile

  // Draw with alpha disabled in the blender, but with alphaCompare on and blendColor=03 (32 bit)
  Set_Blend_Color $00000003
  Set_Combine_Mode 8,16,7,7,  8,16,8,8,  7,7,1,7,  1,1,7,1   // Color=Tex0Color, Alpha=Tex0Alpha
  Set_Other_Modes CYCLE_TYPE_1_CYCLE|BI_LERP_0|BI_LERP_1|ALPHA_COMPARE_EN
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,4, $100 >> 3, 0,0, 0,0,0,0, 0,0,0,0
  Set_Tile_Size 0<<2, 0<<2, 0, 15<<2, 0<<2
  Texture_Rectangle (16*4+80)<<2,(48+4)<<2, 0, 80<<2,48<<2, 0<<5,0<<5, 1<<8,1<<8
  Sync_Pipe
  Sync_Load
  Sync_Tile

  // Draw with alpha disabled in the blender, but with alphaCompare on and blendColor=04 (32 bit)
  Set_Blend_Color $00000004
  Set_Combine_Mode 8,16,7,7,  8,16,8,8,  7,7,1,7,  1,1,7,1   // Color=Tex0Color, Alpha=Tex0Alpha
  Set_Other_Modes CYCLE_TYPE_1_CYCLE|BI_LERP_0|BI_LERP_1|ALPHA_COMPARE_EN
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_32B,4, $000 >> 3, 0,0, 0,0,0,0, 0,0,0,0
  Set_Tile_Size 0<<2, 0<<2, 0, 15<<2, 0<<2
  Texture_Rectangle (16*4+8)<<2,(56+4)<<2, 0, 8<<2,56<<2, 0<<5,0<<5, 1<<8,1<<8
  Sync_Pipe
  Sync_Load
  Sync_Tile

  // Draw with alpha disabled in the blender, but with alphaCompare on and blendColor=04 (16 bit)
  Set_Blend_Color $00000004
  Set_Combine_Mode 8,16,7,7,  8,16,8,8,  7,7,1,7,  1,1,7,1   // Color=Tex0Color, Alpha=Tex0Alpha
  Set_Other_Modes CYCLE_TYPE_1_CYCLE|BI_LERP_0|BI_LERP_1|ALPHA_COMPARE_EN
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,4, $100 >> 3, 0,0, 0,0,0,0, 0,0,0,0
  Set_Tile_Size 0<<2, 0<<2, 0, 15<<2, 0<<2
  Texture_Rectangle (16*4+80)<<2,(56+4)<<2, 0, 80<<2,56<<2, 0<<5,0<<5, 1<<8,1<<8
  Sync_Pipe
  Sync_Load
  Sync_Tile

  // Draw with alpha disabled in the blender, but with alphaCompare on and blendColor=05 (32 bit)
  Set_Blend_Color $00000005
  Set_Combine_Mode 8,16,7,7,  8,16,8,8,  7,7,1,7,  1,1,7,1   // Color=Tex0Color, Alpha=Tex0Alpha
  Set_Other_Modes CYCLE_TYPE_1_CYCLE|BI_LERP_0|BI_LERP_1|ALPHA_COMPARE_EN
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_32B,4, $000 >> 3, 0,0, 0,0,0,0, 0,0,0,0
  Set_Tile_Size 0<<2, 0<<2, 0, 15<<2, 0<<2
  Texture_Rectangle (16*4+8)<<2,(64+4)<<2, 0, 8<<2,64<<2, 0<<5,0<<5, 1<<8,1<<8
  Sync_Pipe
  Sync_Load
  Sync_Tile

  // Draw with alpha disabled in the blender, but with alphaCompare on and blendColor=05 (16 bit)
  Set_Blend_Color $00000005
  Set_Combine_Mode 8,16,7,7,  8,16,8,8,  7,7,1,7,  1,1,7,1   // Color=Tex0Color, Alpha=Tex0Alpha
  Set_Other_Modes CYCLE_TYPE_1_CYCLE|BI_LERP_0|BI_LERP_1|ALPHA_COMPARE_EN
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,4, $100 >> 3, 0,0, 0,0,0,0, 0,0,0,0
  Set_Tile_Size 0<<2, 0<<2, 0, 15<<2, 0<<2
  Texture_Rectangle (16*4+80)<<2,(64+4)<<2, 0, 80<<2,64<<2, 0<<5,0<<5, 1<<8,1<<8
  Sync_Pipe
  Sync_Load
  Sync_Tile

  // Draw with alpha disabled in the blender, but with alphaCompare on and blendColor=06 (32 bit)
  Set_Blend_Color $00000006
  Set_Combine_Mode 8,16,7,7,  8,16,8,8,  7,7,1,7,  1,1,7,1   // Color=Tex0Color, Alpha=Tex0Alpha
  Set_Other_Modes CYCLE_TYPE_1_CYCLE|BI_LERP_0|BI_LERP_1|ALPHA_COMPARE_EN
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_32B,4, $000 >> 3, 0,0, 0,0,0,0, 0,0,0,0
  Set_Tile_Size 0<<2, 0<<2, 0, 15<<2, 0<<2
  Texture_Rectangle (16*4+8)<<2,(72+4)<<2, 0, 8<<2,72<<2, 0<<5,0<<5, 1<<8,1<<8
  Sync_Pipe
  Sync_Load
  Sync_Tile

  // Draw with alpha disabled in the blender, but with alphaCompare on and blendColor=06 (16 bit)
  Set_Blend_Color $00000006
  Set_Combine_Mode 8,16,7,7,  8,16,8,8,  7,7,1,7,  1,1,7,1   // Color=Tex0Color, Alpha=Tex0Alpha
  Set_Other_Modes CYCLE_TYPE_1_CYCLE|BI_LERP_0|BI_LERP_1|ALPHA_COMPARE_EN
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,4, $100 >> 3, 0,0, 0,0,0,0, 0,0,0,0
  Set_Tile_Size 0<<2, 0<<2, 0, 15<<2, 0<<2
  Texture_Rectangle (16*4+80)<<2,(72+4)<<2, 0, 80<<2,72<<2, 0<<5,0<<5, 1<<8,1<<8
  Sync_Pipe
  Sync_Load
  Sync_Tile


  // Draw with alpha disabled in the blender, but with alphaCompare on and blendColor=07(32 bit)
  Set_Blend_Color $00000007
  Set_Combine_Mode 8,16,7,7,  8,16,8,8,  7,7,1,7,  1,1,7,1   // Color=Tex0Color, Alpha=Tex0Alpha
  Set_Other_Modes CYCLE_TYPE_1_CYCLE|BI_LERP_0|BI_LERP_1|ALPHA_COMPARE_EN
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_32B,4, $000 >> 3, 0,0, 0,0,0,0, 0,0,0,0
  Set_Tile_Size 0<<2, 0<<2, 0, 15<<2, 0<<2
  Texture_Rectangle (16*4+8)<<2,(80+4)<<2, 0, 8<<2,80<<2, 0<<5,0<<5, 1<<8,1<<8
  Sync_Pipe
  Sync_Load
  Sync_Tile

  // Draw with alpha disabled in the blender, but with alphaCompare on and blendColor=07 (16 bit)
  Set_Blend_Color $00000007
  Set_Combine_Mode 8,16,7,7,  8,16,8,8,  7,7,1,7,  1,1,7,1   // Color=Tex0Color, Alpha=Tex0Alpha
  Set_Other_Modes CYCLE_TYPE_1_CYCLE|BI_LERP_0|BI_LERP_1|ALPHA_COMPARE_EN
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,4, $100 >> 3, 0,0, 0,0,0,0, 0,0,0,0
  Set_Tile_Size 0<<2, 0<<2, 0, 15<<2, 0<<2
  Texture_Rectangle (16*4+80)<<2,(80+4)<<2, 0, 80<<2,80<<2, 0<<5,0<<5, 1<<8,1<<8
  Sync_Pipe
  Sync_Load
  Sync_Tile

  // Draw with alpha disabled in the blender, but with alphaCompare on and blendColor=08 (32 bit)
  Set_Blend_Color $00000008
  Set_Combine_Mode 8,16,7,7,  8,16,8,8,  7,7,1,7,  1,1,7,1   // Color=Tex0Color, Alpha=Tex0Alpha
  Set_Other_Modes CYCLE_TYPE_1_CYCLE|BI_LERP_0|BI_LERP_1|ALPHA_COMPARE_EN
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_32B,4, $000 >> 3, 0,0, 0,0,0,0, 0,0,0,0
  Set_Tile_Size 0<<2, 0<<2, 0, 15<<2, 0<<2
  Texture_Rectangle (16*4+8)<<2,(88+4)<<2, 0, 8<<2,88<<2, 0<<5,0<<5, 1<<8,1<<8
  Sync_Pipe
  Sync_Load
  Sync_Tile

  // Draw with alpha disabled in the blender, but with alphaCompare on and blendColor=08 (32 bit)
  Set_Blend_Color $00000008
  Set_Combine_Mode 8,16,7,7,  8,16,8,8,  7,7,1,7,  1,1,7,1   // Color=Tex0Color, Alpha=Tex0Alpha
  Set_Other_Modes CYCLE_TYPE_1_CYCLE|BI_LERP_0|BI_LERP_1|ALPHA_COMPARE_EN
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,4, $100 >> 3, 0,0, 0,0,0,0, 0,0,0,0
  Set_Tile_Size 0<<2, 0<<2, 0, 15<<2, 0<<2
  Texture_Rectangle (16*4+80)<<2,(88+4)<<2, 0, 80<<2,88<<2, 0<<5,0<<5, 1<<8,1<<8
  Sync_Pipe
  Sync_Load
  Sync_Tile

  // Draw with alpha disabled in the blender, but with alphaCompare on and blendColor=09 (32 bit)
  Set_Blend_Color $00000009
  Set_Combine_Mode 8,16,7,7,  8,16,8,8,  7,7,1,7,  1,1,7,1   // Color=Tex0Color, Alpha=Tex0Alpha
  Set_Other_Modes CYCLE_TYPE_1_CYCLE|BI_LERP_0|BI_LERP_1|ALPHA_COMPARE_EN
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_32B,4, $000 >> 3, 0,0, 0,0,0,0, 0,0,0,0
  Set_Tile_Size 0<<2, 0<<2, 0, 15<<2, 0<<2
  Texture_Rectangle (16*4+8)<<2,(96+4)<<2, 0, 8<<2,96<<2, 0<<5,0<<5, 1<<8,1<<8
  Sync_Pipe
  Sync_Load
  Sync_Tile

  // Draw with alpha disabled in the blender, but with alphaCompare on and blendColor=09 (16 bit)
  Set_Blend_Color $00000009
  Set_Combine_Mode 8,16,7,7,  8,16,8,8,  7,7,1,7,  1,1,7,1   // Color=Tex0Color, Alpha=Tex0Alpha
  Set_Other_Modes CYCLE_TYPE_1_CYCLE|BI_LERP_0|BI_LERP_1|ALPHA_COMPARE_EN
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,4, $100 >> 3, 0,0, 0,0,0,0, 0,0,0,0
  Set_Tile_Size 0<<2, 0<<2, 0, 15<<2, 0<<2
  Texture_Rectangle (16*4+80)<<2,(96+4)<<2, 0, 80<<2,96<<2, 0<<5,0<<5, 1<<8,1<<8
  Sync_Pipe
  Sync_Load
  Sync_Tile

  // Draw with alpha disabled in the blender, but with alphaCompare on and blendColor=0A (32 bit)
  Set_Blend_Color $0000000A
  Set_Combine_Mode 8,16,7,7,  8,16,8,8,  7,7,1,7,  1,1,7,1   // Color=Tex0Color, Alpha=Tex0Alpha
  Set_Other_Modes CYCLE_TYPE_1_CYCLE|BI_LERP_0|BI_LERP_1|ALPHA_COMPARE_EN
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_32B,4, $000 >> 3, 0,0, 0,0,0,0, 0,0,0,0
  Set_Tile_Size 0<<2, 0<<2, 0, 15<<2, 0<<2
  Texture_Rectangle (16*4+8)<<2,(104+4)<<2, 0, 8<<2,104<<2, 0<<5,0<<5, 1<<8,1<<8
  Sync_Pipe
  Sync_Load
  Sync_Tile

  // Draw with alpha disabled in the blender, but with alphaCompare on and blendColor=0A (16 bit)
  Set_Blend_Color $0000000A
  Set_Combine_Mode 8,16,7,7,  8,16,8,8,  7,7,1,7,  1,1,7,1   // Color=Tex0Color, Alpha=Tex0Alpha
  Set_Other_Modes CYCLE_TYPE_1_CYCLE|BI_LERP_0|BI_LERP_1|ALPHA_COMPARE_EN
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,4, $100 >> 3, 0,0, 0,0,0,0, 0,0,0,0
  Set_Tile_Size 0<<2, 0<<2, 0, 15<<2, 0<<2
  Texture_Rectangle (16*4+80)<<2,(104+4)<<2, 0, 80<<2,104<<2, 0<<5,0<<5, 1<<8,1<<8
  Sync_Pipe
  Sync_Load
  Sync_Tile

  // Draw with alpha disabled in the blender, but with alphaCompare on and blendColor=0B (32 bit)
  Set_Blend_Color $0000000B
  Set_Combine_Mode 8,16,7,7,  8,16,8,8,  7,7,1,7,  1,1,7,1   // Color=Tex0Color, Alpha=Tex0Alpha
  Set_Other_Modes CYCLE_TYPE_1_CYCLE|BI_LERP_0|BI_LERP_1|ALPHA_COMPARE_EN
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_32B,4, $000 >> 3, 0,0, 0,0,0,0, 0,0,0,0
  Set_Tile_Size 0<<2, 0<<2, 0, 15<<2, 0<<2
  Texture_Rectangle (16*4+8)<<2,(112+4)<<2, 0, 8<<2,112<<2, 0<<5,0<<5, 1<<8,1<<8
  Sync_Pipe
  Sync_Load
  Sync_Tile

  // Draw with alpha disabled in the blender, but with alphaCompare on and blendColor=0B (16 bit)
  Set_Blend_Color $0000000B
  Set_Combine_Mode 8,16,7,7,  8,16,8,8,  7,7,1,7,  1,1,7,1   // Color=Tex0Color, Alpha=Tex0Alpha
  Set_Other_Modes CYCLE_TYPE_1_CYCLE|BI_LERP_0|BI_LERP_1|ALPHA_COMPARE_EN
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,4, $100 >> 3, 0,0, 0,0,0,0, 0,0,0,0
  Set_Tile_Size 0<<2, 0<<2, 0, 15<<2, 0<<2
  Texture_Rectangle (16*4+80)<<2,(112+4)<<2, 0, 80<<2,112<<2, 0<<5,0<<5, 1<<8,1<<8
  Sync_Pipe
  Sync_Load
  Sync_Tile

  // Draw with alpha disabled in the blender, but with alphaCompare on and blendColor=FF (32 bit)
  Set_Blend_Color $000000FF
  Set_Combine_Mode 8,16,7,7,  8,16,8,8,  7,7,1,7,  1,1,7,1   // Color=Tex0Color, Alpha=Tex0Alpha
  Set_Other_Modes CYCLE_TYPE_1_CYCLE|BI_LERP_0|BI_LERP_1|ALPHA_COMPARE_EN
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_32B,4, $000 >> 3, 0,0, 0,0,0,0, 0,0,0,0
  Set_Tile_Size 0<<2, 0<<2, 0, 15<<2, 0<<2
  Texture_Rectangle (16*4+8)<<2,(120+4)<<2, 0, 8<<2,120<<2, 0<<5,0<<5, 1<<8,1<<8
  Sync_Pipe
  Sync_Load
  Sync_Tile

  // Draw with alpha disabled in the blender, but with alphaCompare on and blendColor=FF (16 bit)
  Set_Blend_Color $000000FF
  Set_Combine_Mode 8,16,7,7,  8,16,8,8,  7,7,1,7,  1,1,7,1   // Color=Tex0Color, Alpha=Tex0Alpha
  Set_Other_Modes CYCLE_TYPE_1_CYCLE|BI_LERP_0|BI_LERP_1|ALPHA_COMPARE_EN
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,4, $100 >> 3, 0,0, 0,0,0,0, 0,0,0,0
  Set_Tile_Size 0<<2, 0<<2, 0, 15<<2, 0<<2
  Texture_Rectangle (16*4+80)<<2,(120+4)<<2, 0, 80<<2,120<<2, 0<<5,0<<5, 1<<8,1<<8
  Sync_Pipe
  Sync_Load
  Sync_Tile

  // Draw with alpha disabled in the blender, but with alphaCompare on against noise (32 bit)
  Set_Blend_Color $000000FF
  Set_Combine_Mode 8,16,7,7,  8,16,8,8,  7,7,1,7,  1,1,7,1   // Color=Tex0Color, Alpha=Tex0Alpha
  Set_Other_Modes CYCLE_TYPE_1_CYCLE|BI_LERP_0|BI_LERP_1|ALPHA_COMPARE_EN|DITHER_ALPHA_EN
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_32B,4, $000 >> 3, 0,0, 0,0,0,0, 0,0,0,0
  Set_Tile_Size 0<<2, 0<<2, 0, 15<<2, 0<<2
  Texture_Rectangle (16*4+8)<<2,(128+4)<<2, 0, 8<<2,128<<2, 0<<5,0<<5, 1<<8,1<<8
  Sync_Pipe
  Sync_Load
  Sync_Tile

  // Draw with alpha disabled in the blender, but with alphaCompare on against noise (16 bit)
  Set_Blend_Color $000000FF
  Set_Combine_Mode 8,16,7,7,  8,16,8,8,  7,7,1,7,  1,1,7,1   // Color=Tex0Color, Alpha=Tex0Alpha
  Set_Other_Modes CYCLE_TYPE_1_CYCLE|BI_LERP_0|BI_LERP_1|ALPHA_COMPARE_EN|DITHER_ALPHA_EN
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,4, $100 >> 3, 0,0, 0,0,0,0, 0,0,0,0
  Set_Tile_Size 0<<2, 0<<2, 0, 15<<2, 0<<2
  Texture_Rectangle (16*4+80)<<2,(128+4)<<2, 0, 80<<2,128<<2, 0<<5,0<<5, 1<<8,1<<8
  Sync_Pipe
  Sync_Load
  Sync_Tile


  Sync_Full
RDPBufferEnd:

align(8)
Texture16x1x32b:
  dw $FF000000,$FFFF0001,$00FF0002,$0000FF03,$FF000004,$FFFF0005,$00FF0006,$0000FF07,$FF000008,$FFFF0009,$00FF000A,$0000FF49,$FF000050,$FFFF0051,$00FF00FE,$0000FFFF

align(8)
Texture16x1x16b:
  dh $FF0E,$FF0E,$FF0E,$FF0E,$FF0E,$FF0E,$FF0E,$F0FF,$F0FF,$F0FF,$F0FF,$F0FF,$F0FF,$F0FF,$F0FF,$F0FF
