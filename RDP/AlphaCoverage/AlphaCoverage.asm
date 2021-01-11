// Tests alpha coverage in TEXRECT
// Author: Lemmy with original sources from Peter Lemon's test sources
arch n64.cpu
endian msb
output "AlphaCoverage.N64", create
fill 1052672 // Set ROM Size

origin $00000000
base $80000000 // Entry Point Of Code
include "LIB/N64.INC" // Include N64 Definitions
include "LIB/N64_HEADER.ASM" // Include 64 Byte Header & Vector Table
insert "LIB/N64_BOOTCODE.BIN" // Include 4032 Byte Boot Code
constant screenWidth(640)
constant screenHeight(480)

macro DrawTestPattern(left, top, othermode) {
  // Draw a fillrect on the left, before the other rectangles
  Set_Other_Modes CYCLE_TYPE_1_CYCLE|BI_LERP_0|BI_LERP_1|B_M2A_0_1|FORCE_BLEND|IMAGE_READ_EN|Z_SOURCE_SEL|Z_COMPARE_EN|Z_UPDATE_EN|ATOMIC_PRIM
  Set_Prim_Depth 2000,0
  Set_Prim_Color 0, 0, 0x7F1F7FFF
  SetCombineMode1(A_1, B_0, C_0, D_PrimColor, AA_1, BA_0, CA_0, DA_1)
  Fill_Rectangle ({left}+15)<<2,({top}+46)<<2, ({left})<<2,({top})<<2

  Set_Prim_Depth 1000,0

  SetCombineMode1(A_1, B_0, C_0, D_Tex0Color, AA_1, BA_0, CA_0, DA_Tex0Alpha)

  // Want to see how pixels get discarded. Both for drawing themselves and for z-buffer
  // Draw rectangle (1 cycle)
  Set_Other_Modes {othermode}
  Texture_Rectangle ({left}+2+(4*8))<<2,({top}+2+(3*8))<<2, 0, ({left}+2)<<2,({top}+2)<<2, 0<<5,0<<5, 1<<7,1<<7
  Sync_Pipe
  Sync_Load
  Sync_Tile

  // Draw rectangle (1 cycle with filtering)
  Set_Other_Modes {othermode}|SAMPLE_TYPE
  Texture_Rectangle (({left})+6+(3*8))<<2,(({top}+28+(2*8)))<<2, 0,  ({left}+6)<<2,({top}+28)<<2, 0<<5,0<<5, 1<<7,1<<7
  Sync_Pipe
  Sync_Load
  Sync_Tile

  // Draw a fillrect on the right
  Set_Other_Modes CYCLE_TYPE_1_CYCLE|BI_LERP_0|BI_LERP_1|B_M2A_0_1|FORCE_BLEND|IMAGE_READ_EN|Z_SOURCE_SEL|Z_COMPARE_EN|Z_UPDATE_EN|ATOMIC_PRIM
  Set_Prim_Depth 2000,0
  Set_Prim_Color 0, 0, 0x1F7F7FFF
  SetCombineMode1(A_1, B_0, C_0, D_PrimColor, AA_1, BA_0, CA_0, DA_1)
  Fill_Rectangle (({left})+21+15)<<2,({top}+46)<<2, ({left}+21)<<2,({top})<<2

}

macro DrawRow(left, top, blend) {
  constant {#}tilewidth(38)
  DrawTestPattern({left} + {#}tilewidth * 0, {top}, CYCLE_TYPE_1_CYCLE|BI_LERP_0|BI_LERP_1|{blend}|IMAGE_READ_EN|ATOMIC_PRIM|Z_SOURCE_SEL|Z_COMPARE_EN|Z_UPDATE_EN)
  DrawTestPattern({left} + {#}tilewidth * 1, {top}, CYCLE_TYPE_1_CYCLE|BI_LERP_0|BI_LERP_1|{blend}|IMAGE_READ_EN|ATOMIC_PRIM|Z_SOURCE_SEL|Z_COMPARE_EN|Z_UPDATE_EN|CVG_TIMES_ALPHA)
  DrawTestPattern({left} + {#}tilewidth * 2, {top}, CYCLE_TYPE_1_CYCLE|BI_LERP_0|BI_LERP_1|{blend}|IMAGE_READ_EN|ATOMIC_PRIM|Z_SOURCE_SEL|Z_COMPARE_EN|Z_UPDATE_EN|COLOR_ON_CVG)
  DrawTestPattern({left} + {#}tilewidth * 3, {top}, CYCLE_TYPE_1_CYCLE|BI_LERP_0|BI_LERP_1|{blend}|IMAGE_READ_EN|ATOMIC_PRIM|Z_SOURCE_SEL|Z_COMPARE_EN|Z_UPDATE_EN|COLOR_ON_CVG|CVG_TIMES_ALPHA)
  DrawTestPattern({left} + {#}tilewidth * 4, {top}, CYCLE_TYPE_1_CYCLE|BI_LERP_0|BI_LERP_1|{blend}|IMAGE_READ_EN|ATOMIC_PRIM|Z_SOURCE_SEL|Z_COMPARE_EN|Z_UPDATE_EN|ALPHA_CVG_SELECT)
  DrawTestPattern({left} + {#}tilewidth * 5, {top}, CYCLE_TYPE_1_CYCLE|BI_LERP_0|BI_LERP_1|{blend}|IMAGE_READ_EN|ATOMIC_PRIM|Z_SOURCE_SEL|Z_COMPARE_EN|Z_UPDATE_EN|ALPHA_CVG_SELECT|CVG_TIMES_ALPHA)
  DrawTestPattern({left} + {#}tilewidth * 6, {top}, CYCLE_TYPE_1_CYCLE|BI_LERP_0|BI_LERP_1|{blend}|IMAGE_READ_EN|ATOMIC_PRIM|Z_SOURCE_SEL|Z_COMPARE_EN|Z_UPDATE_EN|ALPHA_CVG_SELECT|COLOR_ON_CVG)
  DrawTestPattern({left} + {#}tilewidth * 7, {top}, CYCLE_TYPE_1_CYCLE|BI_LERP_0|BI_LERP_1|{blend}|IMAGE_READ_EN|ATOMIC_PRIM|Z_SOURCE_SEL|Z_COMPARE_EN|Z_UPDATE_EN|ALPHA_CVG_SELECT|COLOR_ON_CVG|CVG_TIMES_ALPHA)
}

macro DrawQuarter(left, top, cvg) {
  // CombineAlpha * CombineColor + (1 - CombineAlpha) * CombineColor
  DrawRow({left}, {top} + rowHeight * 0, {cvg})

  // CombineAlpha * CombineColor + (1 - CombineAlpha) * MemoryColor
  DrawRow({left}, {top} + rowHeight * 1, {cvg}|B_M2A_0_1)

  // (CombineAlpha * CombineColor + MemoryAlpha * CombineColor) / (CombineAlpha + MemoryAlpha)
  DrawRow({left}, {top} + rowHeight * 2, {cvg}|B_M2B_0_1)

  // (CombineAlpha * CombineColor + MemoryAlpha * MemoryColor) / (CombineAlpha + MemoryAlpha)
  DrawRow({left}, {top} + rowHeight * 3, {cvg}|B_M2A_0_1|B_M2B_0_1)
}

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

  // Clear depth buffer
  Set_Z_Image $00200000
  Set_Color_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,screenWidth-1, $00200000
  Set_Fill_Color $FFFCFFFC
  Fill_Rectangle (screenWidth-1)<<2,(screenHeight-1)<<2, 0<<2,0<<2

  // Clear color image
  Set_Color_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,screenWidth-1, $00100000
  Set_Fill_Color $49CF49CF
  Fill_Rectangle (screenWidth-1)<<2,(screenHeight-1)<<2, 0<<2,0<<2

  // Load texture
  Sync_Pipe
  Sync_Load
  Sync_Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,3, Texture4x3x16b
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,2, $000>>3, 0,0, 0,0,0,0, 0,0,0,0
  Sync_Tile
  Load_Tile 0<<2,0<<2, 0, 3<<2, 2<<2
  Sync_Pipe
  Sync_Load
  Sync_Tile
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,2, $000 >> 3, 0,0, 0,0,0,0, 0,0,0,0
  Set_Tile_Size 0<<2, 0<<2, 0, 3<<2, 2<<2

  constant rowHeight(50)

  DrawQuarter(10, 14, 0)
  DrawQuarter(10, 240, ANTIALIAS_EN)
  DrawQuarter(320, 14, FORCE_BLEND)
  DrawQuarter(320, 240, FORCE_BLEND|ANTIALIAS_EN)


  Sync_Full
RDPBufferEnd:

  align(8)
Texture4x3x16b:
  dh $FFFE,$FFFE,$FFFE,$FFFE
  dh $FFFE,$F001,$F001,$FFFE
  dh $FFFE,$FFFE,$FFFE,$FFFE
