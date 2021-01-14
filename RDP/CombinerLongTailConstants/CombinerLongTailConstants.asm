// Tests lesser used combiner fields using TEXRECT: PrimLodFraction, K4, K5, KeyScale, KeyCenter
arch n64.cpu
endian msb
output "CombinerLongTailConstants.N64", create
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

  macro DrawRectangle(variable left, variable top, variable width, variable height, variable scale) {
    Texture_Rectangle (left + width)<<2,(top + height)<<2, 0, (left)<<2,(top)<<2, 0<<5,0<<5, 1<<(scale),1<<(scale)
  }

  macro DrawPrimitiveLodTiles(variable left, variable top) {
    variable index(0)
    while (index <= 255) {
      Set_Prim_Color 0, index, 0x7F7F7FFF
      DrawRectangle(left + index * 2, top, 2, 32, 7)
      variable index(index+1)
    }
  }

  macro DrawConvertK5Tiles(variable left, variable top) {
    variable index(0)
    while (index <= 511) {
      Set_Convert 0, 0, 0, 0, 0, index
      DrawRectangle(left + index * 1, top, 1, 32, 7)
      variable index(index+1)
    }
  }

  macro DrawConvertK4Tiles(variable left, variable top) {
    variable index(0)
    while (index <= 511) {
      Set_Convert 0, 0, 0, 0, index, 0
      DrawRectangle(left + index * 1, top, 1, 32, 7)
      variable index(index+1)
    }
  }

  macro DrawKeyScaleTiles(variable left, variable top) {
    variable index(0)
    while (index <= 255) {
      Set_Key_GB 0, 0, 0, 0, 0, 0
      Set_Key_R 0, 0, index
      DrawRectangle(left + index * 2, top, 2, 8, 7)

      Set_Key_R 0, 0, 0
      Set_Key_GB 0, 0, 0, index, 0, 0
      DrawRectangle(left + index * 2, top + 8, 2, 8, 7)

      Set_Key_GB 0, 0, 0, 0, 0, index
      DrawRectangle(left + index * 2, top + 16, 2, 8, 7)

      Set_Key_GB 0, 0, 0, index, 0, index
      Set_Key_R 0, 0, index
      DrawRectangle(left + index * 2, top + 24, 2, 8, 7)

      variable index(index+1)
    }
  }

  macro DrawKeyCenterTiles(variable left, variable top) {
    variable index(0)
    while (index <= 255) {
      Set_Key_GB 0, 0, 0, 0, 0, 0
      Set_Key_R 0, index, 0
      DrawRectangle(left + index * 2, top, 2, 8, 7)

      Set_Key_R 0, 0, 0
      Set_Key_GB 0, 0, index, 0, 0, 0
      DrawRectangle(left + index * 2, top + 8, 2, 8, 7)

      Set_Key_GB 0, 0, 0, 0, index, 0
      DrawRectangle(left + index * 2, top + 16, 2, 8, 7)

      Set_Key_GB 0, 0, index, 0, index, 0
      Set_Key_R 0, index, 0
      DrawRectangle(left + index * 2, top + 24, 2, 8, 7)

      variable index(index+1)
    }
  }

  Set_Other_Modes CYCLE_TYPE_2_CYCLE|BI_LERP_0|BI_LERP_1|B_M2A_0_1|FORCE_BLEND|IMAGE_READ_EN|ATOMIC_PRIM

  SetCombineMode2(A_0, B_0, C_0, D_0, AA_1, BA_0, CA_0, DA_1, A_1, B_0, C_PrimLODFrac, D_0, AA_1, BA_0, CA_0, DA_1)
  DrawPrimitiveLodTiles(16, 16 + 34 * 0)

  SetCombineMode2(A_0, B_0, C_0, D_0, AA_1, BA_0, CA_0, DA_1, A_1, B_0, C_ConvertK5, D_0, AA_1, BA_0, CA_0, DA_1)
  DrawConvertK5Tiles(16, 16 + 34 * 2)

  // Scale with 1.0
  Set_Prim_Color 0, 0, 0xFFFFFFFF
  SetCombineMode2(A_0, B_0, C_0, D_0, AA_1, BA_0, CA_0, DA_1, A_PrimColor, B_0, C_ConvertK5, D_0, AA_1, BA_0, CA_0, DA_1)
  DrawConvertK5Tiles(16, 16 + 34 * 3)

  // Scale with 0.75. Reason is that the pattern here will look different depending on whether K5 is 9 bit signed or unsigned
  Set_Prim_Color 0, 0, 0xAFAFAFAF
  SetCombineMode2(A_0, B_0, C_0, D_0, AA_1, BA_0, CA_0, DA_1, A_PrimColor, B_0, C_ConvertK5, D_0, AA_1, BA_0, CA_0, DA_1)
  DrawConvertK5Tiles(16, 16 + 34 * 4)

  Set_Prim_Color 0, 0, 0x00FFFFFF
  SetCombineMode2(A_1, B_ConvertK4, C_PrimAlpha, D_0, AA_1, BA_0, CA_0, DA_1, A_0, B_0, C_0, D_CombinedColor, AA_1, BA_0, CA_0, DA_1)
  DrawConvertK4Tiles(16, 16 + 34 * 6)

  SetCombineMode2(A_1, B_0, C_KeyScale, D_0, AA_1, BA_0, CA_0, DA_1, A_0, B_0, C_0, D_CombinedColor, AA_1, BA_0, CA_0, DA_1)
  DrawKeyScaleTiles(16, 16 + 34 * 8)

  SetCombineMode2(A_1, B_KeyCenter, C_PrimAlpha, D_0, AA_1, BA_0, CA_0, DA_1, A_1, B_CombinedColor, C_PrimAlpha, D_0, AA_1, BA_0, CA_0, DA_1)
  DrawKeyCenterTiles(16, 16 + 34 * 10)

  // TODO: B_KeyCenter

  Sync_Full
RDPBufferEnd:
