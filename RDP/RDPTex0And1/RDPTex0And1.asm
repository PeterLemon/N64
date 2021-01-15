// Tests what Tex0Color/Tex1Color mean during the first and second cycle (hint: second cycle is inverted)
arch n64.cpu
endian msb
output "RDPTex0And1.N64", create
fill 1052672 // Set ROM Size

origin $00000000
base $80000000 // Entry Point Of Code
include "LIB/N64.INC" // Include N64 Definitions
include "LIB/N64_HEADER.ASM" // Include 64 Byte Header & Vector Table
insert "LIB/N64_BOOTCODE.BIN" // Include 4032 Byte Boot Code
constant screenWidth(640)
constant screenHeight(480)

Start:
  include "LIB/N64_GFX.INC" // Include Graphics Macros
  N64_INIT() // Run N64 Initialisation Routine

  ScreenNTSC(screenWidth, screenHeight, BPP16|AA_MODE_2, $A0100000)

  WaitScanline($200) // Wait For Scanline To Reach Vertical Blank


  DPC(RDPBuffer, RDPBufferEnd) // Run DPC Command Buffer: Start, End

Loop:
  j Loop
  nop // Delay Slot

align(8) // Align 64-Bit
RDPBuffer:
arch n64.rdp
  Set_Scissor 0<<2,0<<2, 0,0, screenWidth<<2,screenHeight<<2
  Set_Other_Modes CYCLE_TYPE_FILL

  // Clear color image
  Set_Color_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,screenWidth-1, $00100000
  Set_Fill_Color $49CF49CF
  Fill_Rectangle (screenWidth-1)<<2,(screenHeight-1)<<2, 0<<2,0<<2

  macro LoadTile(tile_index, data, tmem_address, width, height) {
    Sync_Pipe
    Sync_Load
    Sync_Tile
    Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B, ({width})-1, {data}
    Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,2, ({tmem_address})>>3,{tile_index}, 0,0,0,0, 0,0,0,0,0
    Sync_Tile
    Load_Tile 0<<2,0<<2, {tile_index}, (({width})-1)<<2, (({height})-1)<<2
    Sync_Pipe
    Sync_Load
    Sync_Tile
    Set_Tile_Size 0<<2, 0<<2, {tile_index}, (({width})-1)<<2, (({height})-1)<<2
  }

  LoadTile(0, MIP0, 0x80 * 0, 8, 8)
  LoadTile(1, MIP1, 0x80 * 1, 8, 8)
  LoadTile(2, MIP2, 0x80 * 2, 8, 8)
  LoadTile(3, MIP3, 0x80 * 3, 8, 8)


  macro DrawRectangle(left, top, size, scale, primlod) {
    Set_Prim_Color 0, {primlod}, 0x7F7F7FFF
    Texture_Rectangle ({left} + {size})<<2,({top} + {size})<<2, 0, ({left})<<2,({top})<<2, 0<<5,0<<5, 1<<({scale}),1<<({scale})
  }

  macro DrawTiles(left, top) {
    DrawRectangle(({left}) + 34 * 0, {top}, 32, 8, 0)
    DrawRectangle(({left}) + 34 * 1, {top}, 32, 8, 64)
    DrawRectangle(({left}) + 34 * 2, {top}, 32, 8, 128)
    DrawRectangle(({left}) + 34 * 3, {top}, 32, 8, 192)
    DrawRectangle(({left}) + 34 * 4, {top}, 32, 8, 255)
  }

  macro DrawTripple(left, top, mode) {
    SetCombineMode1(A_Tex1Color, B_Tex0Color, C_PrimLODFrac, D_Tex0Color, AA_1, BA_0, CA_0, DA_1)
    Set_Other_Modes CYCLE_TYPE_1_CYCLE|BI_LERP_0|BI_LERP_1|B_M2A_0_1|FORCE_BLEND|IMAGE_READ_EN|ATOMIC_PRIM|{mode}
    DrawTiles({left}, ({top}) + 34 * 0)

    SetCombineMode2(A_0, B_0, C_0, D_0, AA_1, BA_0, CA_0, DA_1, A_Tex1Color, B_Tex0Color, C_PrimLODFrac, D_Tex0Color, AA_1, BA_0, CA_0, DA_1)
    Set_Other_Modes CYCLE_TYPE_2_CYCLE|BI_LERP_0|BI_LERP_1|B_M2A_0_1|FORCE_BLEND|IMAGE_READ_EN|ATOMIC_PRIM|{mode}
    DrawTiles({left}, ({top}) + 34 * 1)

    SetCombineMode2(A_Tex1Color, B_Tex0Color, C_PrimLODFrac, D_Tex0Color, AA_1, BA_0, CA_0, DA_1, A_0, B_0, C_0, D_CombinedColor, AA_1, BA_0, CA_0, DA_1)
    Set_Other_Modes CYCLE_TYPE_2_CYCLE|BI_LERP_0|BI_LERP_1|B_M2A_0_1|FORCE_BLEND|IMAGE_READ_EN|ATOMIC_PRIM|{mode}
    DrawTiles({left}, ({top}) + 34 * 2)
  }

  DrawTripple(16, 16, 0)
  DrawTripple(216, 16, SHARPEN_TEX_EN)
  DrawTripple(16, 150, DETAIL_TEX_EN)
  DrawTripple(216, 150, DETAIL_TEX_EN|SHARPEN_TEX_EN)

  Sync_Full
RDPBufferEnd:

align(8)
MIP0:
  dh $0001,$0001,$0001,$F001,$F001,$0001,$0001,$0001
  dh $0001,$0001,$F001,$0001,$0001,$F001,$0001,$0001
  dh $0001,$F001,$0001,$0001,$0001,$0001,$F001,$0001
  dh $0001,$F001,$0001,$0001,$0001,$0001,$F001,$0001
  dh $0001,$F001,$0001,$0001,$0001,$0001,$F001,$0001
  dh $0001,$F001,$0001,$0001,$0001,$0001,$F001,$0001
  dh $0001,$0001,$F001,$0001,$0001,$F001,$0001,$0001
  dh $0001,$0001,$0001,$F001,$F001,$0001,$0001,$0001

align(8)
MIP1:
  dh $0001,$0001,$0001,$0F01,$0001,$0001,$0001,$0001
  dh $0001,$0001,$0F01,$0F01,$0001,$0001,$0001,$0001
  dh $0001,$0F01,$0001,$0F01,$0001,$0001,$0001,$0001
  dh $0001,$0001,$0001,$0F01,$0001,$0001,$0001,$0001
  dh $0001,$0001,$0001,$0F01,$0001,$0001,$0001,$0001
  dh $0001,$0001,$0001,$0F01,$0001,$0001,$0001,$0001
  dh $0001,$0001,$0001,$0F01,$0001,$0001,$0001,$0001
  dh $0001,$0001,$0001,$0F01,$0001,$0001,$0001,$0001

align(8)
MIP2:
  dh $0001,$0001,$00F1,$00F1,$0001,$0001,$0001,$0001
  dh $0001,$00F1,$0001,$0001,$00F1,$0001,$0001,$0001
  dh $0001,$0001,$0001,$0001,$00F1,$0001,$0001,$0001
  dh $0001,$0001,$00F1,$00F1,$0001,$0001,$0001,$0001
  dh $0001,$00F1,$0001,$0001,$0001,$0001,$0001,$0001
  dh $0001,$00F1,$0001,$0001,$0001,$0001,$0001,$0001
  dh $0001,$00F1,$00F1,$00F1,$00F1,$0001,$0001,$0001
  dh $0001,$0001,$0001,$0001,$0001,$0001,$0001,$0001

align(8)
MIP3:
  dh $0001,$0001,$FFFF,$FFFF,$0001,$0001,$0001,$0001
  dh $0001,$FFFF,$0001,$0001,$FFFF,$0001,$0001,$0001
  dh $0001,$0001,$0001,$0001,$FFFF,$0001,$0001,$0001
  dh $0001,$0001,$0001,$FFFF,$0001,$0001,$0001,$0001
  dh $0001,$0001,$0001,$0001,$FFFF,$0001,$0001,$0001
  dh $0001,$0001,$0001,$0001,$FFFF,$0001,$0001,$0001
  dh $0001,$FFFF,$0001,$0001,$FFFF,$0001,$0001,$0001
  dh $0001,$0001,$FFFF,$FFFF,$0001,$0001,$0001,$0001

