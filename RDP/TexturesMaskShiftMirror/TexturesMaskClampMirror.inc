// Tests texture mask_t & clamp/shift/mirror
// Author: Lemmy with original sources from Peter Lemon's test sources
arch n64.cpu
endian msb
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
  // ***************************************************************************************
  // ** Initialize and clear screen                                                       **
  // ***************************************************************************************
  Set_Scissor 0<<2,0<<2, 0,0, 320<<2,240<<2 // Set Scissor: XH 0.0,YH 0.0, Scissor Field Enable Off,Field Off, XL 320.0,YL 240.0
  Set_Other_Modes CYCLE_TYPE_FILL // Set Other Modes
  Set_Color_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,320-1, $00100000 // Set Color Image: FORMAT RGBA,SIZE 16B,WIDTH 320, DRAM ADDRESS $00100000
  Set_Fill_Color $39CF39CF // Set Fill Color: PACKED COLOR 16B R5G5B5A1 Pixels
  Fill_Rectangle 319<<2,239<<2, 0<<2,0<<2 // Fill Rectangle: XL 319.0,YL 239.0, XH 0.0,YH 0.0
  Set_Combine_Mode 8,16,7,7,  8,16,8,8,  7,7,1,7,  6,1,7,6   // Color=Tex0Color, Alpha=1


  // ***************************************************************************************
  // ** Load test texture                                                                 **
  // ***************************************************************************************
  Sync_Pipe
  Sync_Load
  Sync_Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,1, Texture12x8x16b
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,0, $000>>3, 0,0, 0,0,0,0, 0,0,0,0
  Load_Block 0<<2,0<<2, 0, 96, 0



  macro Rectangle(variable mask_t, variable clamp_t, variable mirror_t, variable left, variable top) {
    variable right(left + 40)
    variable bottom(top + 40)

    Set_Other_Modes CYCLE_TYPE_1_CYCLE|BI_LERP_0|BI_LERP_1
    Sync_Pipe
    Sync_Load
    Sync_Tile
    Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,3, $000 >> 3, 0,0, clamp_t,mirror_t,mask_t,shift_t, 0,0,0,0
    Set_Tile_Size 0<<2, tile_size_ult<<2, 0, 11<<2, tile_size_lrt<<2
    Texture_Rectangle right<<2,bottom<<2, 0, left<<2,top<<2, -14<<5,-14<<5, 1<<10,1<<10
  }

  macro Column(variable mask_t, variable left) {
    Rectangle(mask_t, 0, 0, left, 16)
    Rectangle(mask_t, 0, 1, left, 16 + 44)
    Rectangle(mask_t, 1, 0, left, 16 + 44 * 2)
    Rectangle(mask_t, 1, 1, left, 16 + 44 * 3)
  }

  variable columnIndex(0)
  while columnIndex <= 6 {
    Column(columnIndex, 10 + 44 * columnIndex)
    
    variable columnIndex(columnIndex + 1)
  }

  Sync_Full
RDPBufferEnd:

align(8) // Align 64-Bit
Texture16x8x32b: // 512 bytes
// When loading 32 bit RGBA, the lower 16 bits of each color go into the other half of TMEM
align(8) // Align 64-Bit
Texture12x8x16b: // 256 bytes
  dh $0001,$F801,$F801,$F801,$F801,$F801,$F801,$F801,$F801,$F801,$F801,$07C1
  dh $FFFF,$FFFF,$F801,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$003F,$FFFF,$FFFF
  dh $F801,$FFFF,$FFFF,$FFFF,$FFFF,$0001,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$003F
  dh $FFFF,$FFFF,$F801,$FFFF,$0001,$FFFF,$0001,$0001,$FFFF,$003F,$FFFF,$FFFF
  dh $F801,$FFFF,$FFFF,$0001,$0001,$0001,$0001,$0001,$FFFF,$FFFF,$FFFF,$003F
  dh $0001,$0001,$F801,$FFFF,$0001,$0001,$0001,$0001,$FFFF,$003F,$0001,$FFFF
  dh $F801,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$003F
  dh $003F,$003F,$F83F,$003F,$003F,$003F,$003F,$003F,$003F,$7FFF,$003F,$003F
