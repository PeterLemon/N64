// Tests texture coordinates in TEXRECT (Renders a texture REALLY zoomed in to show how the 3-point interpolation works)
// Author: Lemmy with original sources from Peter Lemon's test sources
arch n64.cpu
endian msb
output "TextureCoordinates.N64", create
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

  // Load 32 bit texture
  Sync_Pipe
  Sync_Load
  Sync_Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,1, Texture16x8x16b
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,2, $000>>3, 0,0, 0,0,0,0, 0,0,0,0
  Sync_Tile
  Load_Block 0<<2,0<<2, 0, (16*8-1), 0
  Sync_Pipe
  Sync_Load
  Sync_Tile

  // Draw rectangle
  Set_Combine_Mode 8,16,7,7,  8,16,8,8,  7,7,1,7,  6,1,7,6   // Color=Tex0Color, Alpha=1
  Set_Other_Modes CYCLE_TYPE_1_CYCLE|BI_LERP_0|BI_LERP_1
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,4, $000 >> 3, 0,0, 0,0,0,0, 0,0,0,0
  Set_Tile_Size 0<<2, 0<<2, 0, 15<<2, 7<<2
  Sync_Tile
  Texture_Rectangle (16+128)<<2,(16+64)<<2, 0, 16<<2,16<<2, 0<<5,0<<5, 1<<7,1<<7
  Sync_Pipe
  Sync_Load
  Sync_Tile

  // Draw rectangle with filtering
  Set_Combine_Mode 8,16,7,7,  8,16,8,8,  7,7,1,7,  6,1,7,6   // Color=Tex0Color, Alpha=1
  Set_Other_Modes CYCLE_TYPE_1_CYCLE|BI_LERP_0|BI_LERP_1|SAMPLE_TYPE
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,4, $000 >> 3, 0,0, 0,0,0,0, 0,0,0,0
  Set_Tile_Size 0<<2, 0<<2, 0, 15<<2, 7<<2
  Sync_Tile
  Texture_Rectangle (16+120)<<2,(84+56)<<2, 0, 16<<2,84<<2, 0<<5,0<<5, 1<<7,1<<7
  Sync_Pipe
  Sync_Load
  Sync_Tile

  // Draw rectangle (COPY MODE)
  Set_Combine_Mode 8,16,7,7,  8,16,8,8,  7,7,1,7,  6,1,7,6   // Color=Tex0Color, Alpha=1
  Set_Other_Modes CYCLE_TYPE_COPY|BI_LERP_0|BI_LERP_1
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,4, $000 >> 3, 0,0, 0,0,0,0, 0,0,0,0
  Set_Tile_Size 0<<2, 0<<2, 0, 15<<2, 7<<2
  Sync_Tile
  Texture_Rectangle (16+16 - 1)<<2,(152+8 - 1)<<2, 0, 16<<2,152<<2, 0<<5,0<<5, $1000,$400
  Sync_Pipe
  Sync_Load
  Sync_Tile

  // Draw rectangle (COPY MODE)
  Set_Combine_Mode 8,16,7,7,  8,16,8,8,  7,7,1,7,  6,1,7,6   // Color=Tex0Color, Alpha=1
  Set_Other_Modes CYCLE_TYPE_COPY|BI_LERP_0|BI_LERP_1|SAMPLE_TYPE
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,4, $000 >> 3, 0,0, 0,0,0,0, 0,0,0,0
  Set_Tile_Size 0<<2, 0<<2, 0, 15<<2, 7<<2
  Sync_Tile
  Texture_Rectangle (36+16 - 1)<<2,(152+8 - 1)<<2, 0, 36<<2,152<<2, 0<<5,0<<5, $1000,$400
  Sync_Pipe
  Sync_Load
  Sync_Tile

  // Draw rectangle (COPY MODE)
  Set_Combine_Mode 8,16,7,7,  8,16,8,8,  7,7,1,7,  6,1,7,6   // Color=Tex0Color, Alpha=1
  Set_Other_Modes CYCLE_TYPE_COPY|BI_LERP_0|BI_LERP_1
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,4, $000 >> 3, 0,0, 0,0,0,0, 0,0,0,0
  Set_Tile_Size 0<<2, 0<<2, 0, 15<<2, 7<<2
  Sync_Tile
  Texture_Rectangle (56+16 - 1)<<2,(152+32 - 1)<<2, 0, 56<<2,152<<2, 0<<5,0<<5, $1000,$100
  Sync_Pipe
  Sync_Load
  Sync_Tile

  // Draw rectangle (COPY MODE)
  Set_Combine_Mode 8,16,7,7,  8,16,8,8,  7,7,1,7,  6,1,7,6   // Color=Tex0Color, Alpha=1
  Set_Other_Modes CYCLE_TYPE_COPY|BI_LERP_0|BI_LERP_1|SAMPLE_TYPE
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,4, $000 >> 3, 0,0, 0,0,0,0, 0,0,0,0
  Set_Tile_Size 0<<2, 0<<2, 0, 15<<2, 7<<2
  Sync_Tile
  Texture_Rectangle (76+16 - 1)<<2,(152+32 - 1)<<2, 0, 76<<2,152<<2, 0<<5,0<<5, $1000,$100
  Sync_Pipe
  Sync_Load
  Sync_Tile

  // Draw rectangle
  Set_Combine_Mode 8,16,7,7,  8,16,8,8,  7,7,1,7,  6,1,7,6   // Color=Tex0Color, Alpha=1
  Set_Other_Modes CYCLE_TYPE_1_CYCLE|BI_LERP_0|BI_LERP_1
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,4, $000 >> 3, 0,0, 0,0,0,0, 0,0,0,0
  Set_Tile_Size 0<<2, 0<<2, 0, 15<<2, 7<<2
  Sync_Tile
  Texture_Rectangle (16+132+112)<<2,(16+48)<<2, 0, (16+132)<<2,16<<2, 1<<5,1<<5, 1<<7,1<<7
  Sync_Pipe
  Sync_Load
  Sync_Tile

  // Draw rectangle with filtering
  Set_Combine_Mode 8,16,7,7,  8,16,8,8,  7,7,1,7,  6,1,7,6   // Color=Tex0Color, Alpha=1
  Set_Other_Modes CYCLE_TYPE_1_CYCLE|BI_LERP_0|BI_LERP_1|SAMPLE_TYPE
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,4, $000 >> 3, 0,0, 0,0,0,0, 0,0,0,0
  Set_Tile_Size 0<<2, 0<<2, 0, 15<<2, 7<<2
  Sync_Tile
  Texture_Rectangle (16+132+104)<<2,(68+40)<<2, 0, (16+132)<<2,68<<2, 1<<5,1<<5, 1<<7,1<<7
  Sync_Pipe
  Sync_Load
  Sync_Tile

  // Draw rectangle with filtering and mid-texel
  Set_Combine_Mode 8,16,7,7,  8,16,8,8,  7,7,1,7,  6,1,7,6   // Color=Tex0Color, Alpha=1
  Set_Other_Modes CYCLE_TYPE_1_CYCLE|BI_LERP_0|BI_LERP_1|SAMPLE_TYPE|MID_TEXEL
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,4, $000 >> 3, 0,0, 0,0,0,0, 0,0,0,0
  Set_Tile_Size 0<<2, 0<<2, 0, 15<<2, 7<<2
  Sync_Tile
  Texture_Rectangle (16+132+104)<<2,(88+64)<<2, 0, (16+132)<<2,112<<2, 1<<5,1<<5, 1<<7,1<<7
  Sync_Pipe
  Sync_Load
  Sync_Tile

  // Draw rectangle (COPY MODE)
  Set_Combine_Mode 8,16,7,7,  8,16,8,8,  7,7,1,7,  6,1,7,6   // Color=Tex0Color, Alpha=1
  Set_Other_Modes CYCLE_TYPE_COPY|BI_LERP_0|BI_LERP_1
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,4, $000 >> 3, 0,0, 0,0,0,0, 0,0,0,0
  Set_Tile_Size 0<<2, 0<<2, 0, 15<<2, 7<<2
  Sync_Tile
  Texture_Rectangle (16+132+14 - 1)<<2,(160+6 - 1)<<2, 0, (16+132)<<2,160<<2, 1<<5,1<<5, $1000,$400
  Sync_Pipe
  Sync_Load
  Sync_Tile

  // Draw rectangle (COPY MODE)
  Set_Combine_Mode 8,16,7,7,  8,16,8,8,  7,7,1,7,  6,1,7,6   // Color=Tex0Color, Alpha=1
  Set_Other_Modes CYCLE_TYPE_COPY|BI_LERP_0|BI_LERP_1|SAMPLE_TYPE
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,4, $000 >> 3, 0,0, 0,0,0,0, 0,0,0,0
  Set_Tile_Size 0<<2, 0<<2, 0, 15<<2, 7<<2
  Sync_Tile
  Texture_Rectangle (16+132+34 - 1)<<2,(160+6 - 1)<<2, 0, (16+132+20)<<2,160<<2, 1<<5,1<<5, $1000,$400
  Sync_Pipe
  Sync_Load
  Sync_Tile

  // Draw rectangle (COPY MODE)
  Set_Combine_Mode 8,16,7,7,  8,16,8,8,  7,7,1,7,  6,1,7,6   // Color=Tex0Color, Alpha=1
  Set_Other_Modes CYCLE_TYPE_COPY|BI_LERP_0|BI_LERP_1
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,4, $000 >> 3, 0,0, 0,0,0,0, 0,0,0,0
  Set_Tile_Size 0<<2, 0<<2, 0, 15<<2, 7<<2
  Sync_Tile
  Texture_Rectangle (16+132+54 - 1)<<2,(160+24 - 1)<<2, 0, (16+132+40)<<2,160<<2, 1<<5,1<<5, $1000,$100
  Sync_Pipe
  Sync_Load
  Sync_Tile

  // Draw rectangle (COPY MODE)
  Set_Combine_Mode 8,16,7,7,  8,16,8,8,  7,7,1,7,  6,1,7,6   // Color=Tex0Color, Alpha=1
  Set_Other_Modes CYCLE_TYPE_COPY|BI_LERP_0|BI_LERP_1|SAMPLE_TYPE
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,4, $000 >> 3, 0,0, 0,0,0,0, 0,0,0,0
  Set_Tile_Size 0<<2, 0<<2, 0, 15<<2, 7<<2
  Sync_Tile
  Texture_Rectangle (16+132+74 - 1)<<2,(160+24 - 1)<<2, 0, (16+132+60)<<2,160<<2, 1<<5,1<<5, $1000,$100
  Sync_Pipe
  Sync_Load
  Sync_Tile


  Sync_Full
RDPBufferEnd:

  align(8)
Texture16x8x16b:
  dh $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
  dh $0000,$0000,$FFFF,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$FFFF,$0000,$0000
  dh $FFFF,$0000,$07FF,$F800,$F800,$F800,$F800,$F800,$F800,$F800,$F800,$F800,$F800,$07FF,$0000,$FFFF
  dh $F800,$0000,$FFFF,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$FFFF,$0000,$F800
  dh $FFFF,$0000,$F800,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$F800,$0000,$FFFF
  dh $07FF,$F800,$FFFF,$0000,$F800,$F800,$F800,$F800,$F800,$F800,$F800,$F800,$0000,$FFFF,$F800,$07FF
  dh $FFFF,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$FFFF
  dh $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
