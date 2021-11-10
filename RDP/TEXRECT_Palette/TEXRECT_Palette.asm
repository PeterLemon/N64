// Test drawing with palette: 4, 8, 16 and 32 bit. The palette is first loaded via LoadBLOCK then drawn in various bit depths
// Written by Lemmy with plenty of stuff copied from krom
arch n64.cpu
endian msb
output "TEXRECT_Palette.N64", create
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
  Set_Combine_Mode 8,16,7,7,  8,16,8,8,  7,7,1,7,  6,1,7,6   // Color=Tex0Color, Alpha=1

  // Load texture (4 bit)
  Sync_Pipe
  Sync_Load
  Sync_Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,1, texture4
  Set_Tile IMAGE_DATA_FORMAT_I,SIZE_OF_PIXEL_16B,0, $000>>3, 0,0, 0,0,0,0, 0,0,0,0
  Load_Block 0<<2,0<<2, 0, 7, 0

  // Load palette
  Sync_Pipe
  Sync_Load
  Sync_Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,1, palette
  Set_Tile IMAGE_DATA_FORMAT_I,SIZE_OF_PIXEL_8B,0, $800>>3, 0,0, 0,0,0,0, 0,0,0,0
  Load_Block 0<<2,0<<2, 0, 16*16-1, 0

  Set_Other_Modes CYCLE_TYPE_1_CYCLE|BI_LERP_0|BI_LERP_1|EN_TLUT

  // draw 4 bit rgba, palette=0
  Sync_Pipe
  Sync_Load
  Sync_Tile
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_4B,4, $000 >> 3, 0,0, 0,0,0,0, 0,0,0,0
  Set_Tile_Size 0<<2, 0<<2, 0, 15<<2, 0<<2
  Texture_Rectangle (8+256)<<2,(8+4)<<2, 0, 8<<2,8<<2, 0<<5,0<<5, 1<<6,1<<6

  // draw 4 bit rgba, palette=1
  Sync_Pipe
  Sync_Load
  Sync_Tile
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_4B,4, $000 >> 3, 0,1, 0,0,1,0, 0,0,0,0
  Set_Tile_Size 0<<2, 0<<2, 0, 15<<2, 0<<2
  Texture_Rectangle (8+256)<<2,(16+4)<<2, 0, 8<<2,16<<2, 0<<5,0<<5, 1<<6,1<<6

  Sync_Pipe
  Sync_Load
  Sync_Tile
  Set_Other_Modes CYCLE_TYPE_1_CYCLE|BI_LERP_0|BI_LERP_1|EN_TLUT|TLUT_TYPE

  // draw 4 bit ia, palette=0
  Sync_Pipe
  Sync_Load
  Sync_Tile
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_4B,4, $000 >> 3, 0,0, 0,0,0,0, 0,0,0,0
  Set_Tile_Size 0<<2, 0<<2, 0, 15<<2, 0<<2
  Texture_Rectangle (8+256)<<2,(24+4)<<2, 0, 8<<2,24<<2, 0<<5,0<<5, 1<<6,1<<6

  // draw 4 bit ia, palette=1
  Sync_Pipe
  Sync_Load
  Sync_Tile
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_4B,4, $000 >> 3, 0,1, 0,0,1,0, 0,0,0,0
  Set_Tile_Size 0<<2, 0<<2, 0, 15<<2, 0<<2
  Texture_Rectangle (8+256)<<2,(32+4)<<2, 0, 8<<2,32<<2, 0<<5,0<<5, 1<<6,1<<6


  // Load texture (8 bit)
  Sync_Pipe
  Sync_Load
  Sync_Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,1, texture8
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,0, $000>>3, 0,0, 0,0,0,0, 0,0,0,0
  Load_Block 0<<2,0<<2, 0, 31, 0

  // draw 8 bit rgba, palette=0
  Sync_Pipe
  Sync_Load
  Sync_Tile
  Set_Other_Modes CYCLE_TYPE_1_CYCLE|BI_LERP_0|BI_LERP_1|EN_TLUT
  Sync_Pipe
  Sync_Load
  Sync_Tile
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,4, $000 >> 3, 0,0, 0,0,0,0, 0,0,0,0
  Set_Tile_Size 0<<2, 0<<2, 0, 15<<2, 0<<2
  Texture_Rectangle (8+256)<<2,(64+4)<<2, 0, 8<<2,64<<2, 0<<5,0<<5, 1<<6,1<<6

  // draw 8 bit ia, palette=0
  Sync_Pipe
  Sync_Load
  Sync_Tile
  Set_Other_Modes CYCLE_TYPE_1_CYCLE|BI_LERP_0|BI_LERP_1|EN_TLUT|TLUT_TYPE
  Sync_Pipe
  Sync_Load
  Sync_Tile
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,4, $000 >> 3, 0,0, 0,0,0,0, 0,0,0,0
  Set_Tile_Size 0<<2, 0<<2, 0, 15<<2, 0<<2
  Texture_Rectangle (8+256)<<2,(72+4)<<2, 0, 8<<2,72<<2, 0<<5,0<<5, 1<<6,1<<6

  // Load texture (16 bit)
  Sync_Pipe
  Sync_Load
  Sync_Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,1, texture16
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,0, $000>>3, 0,0, 0,0,0,0, 0,0,0,0
  Load_Block 0<<2,0<<2, 0, 31, 0

  // draw 16 bit rgba, palette=0
  Sync_Pipe
  Sync_Load
  Sync_Tile
  Set_Other_Modes CYCLE_TYPE_1_CYCLE|BI_LERP_0|BI_LERP_1|EN_TLUT
  Sync_Pipe
  Sync_Load
  Sync_Tile
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,4, $000 >> 3, 0,0, 0,0,0,0, 0,0,0,0
  Set_Tile_Size 0<<2, 0<<2, 0, 15<<2, 0<<2
  Texture_Rectangle (8+256)<<2,(96+4)<<2, 0, 8<<2,96<<2, 0<<5,0<<5, 1<<6,1<<6

  // draw 16 bit ia, palette=0
  Sync_Pipe
  Sync_Load
  Sync_Tile
  Set_Other_Modes CYCLE_TYPE_1_CYCLE|BI_LERP_0|BI_LERP_1|EN_TLUT|TLUT_TYPE
  Sync_Pipe
  Sync_Load
  Sync_Tile
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,4, $000 >> 3, 0,0, 0,0,0,0, 0,0,0,0
  Set_Tile_Size 0<<2, 0<<2, 0, 15<<2, 0<<2
  Texture_Rectangle (8+256)<<2,(104+4)<<2, 0, 8<<2,104<<2, 0<<5,0<<5, 1<<6,1<<6

  // draw 16 bit rgba, palette=0 (every second pixel will be black, as half of the texture is expected in the upper half of tmem, which we don't emulate)
  Sync_Pipe
  Sync_Load
  Sync_Tile
  Set_Other_Modes CYCLE_TYPE_1_CYCLE|BI_LERP_0|BI_LERP_1|EN_TLUT
  Sync_Pipe
  Sync_Load
  Sync_Tile
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_32B,4, $000 >> 3, 0,0, 0,0,0,0, 0,0,0,0
  Set_Tile_Size 0<<2, 0<<2, 0, 15<<2, 0<<2
  Texture_Rectangle (8+256)<<2,(128+4)<<2, 0, 8<<2,128<<2, 0<<5,0<<5, 1<<6,1<<6

  // draw 16 bit ia, palette=0
  Sync_Pipe
  Sync_Load
  Sync_Tile
  Set_Other_Modes CYCLE_TYPE_1_CYCLE|BI_LERP_0|BI_LERP_1|EN_TLUT|TLUT_TYPE
  Sync_Pipe
  Sync_Load
  Sync_Tile
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_32B,4, $000 >> 3, 0,0, 0,0,0,0, 0,0,0,0
  Set_Tile_Size 0<<2, 0<<2, 0, 15<<2, 0<<2
  Texture_Rectangle (8+256)<<2,(136+4)<<2, 0, 8<<2,136<<2, 0<<5,0<<5, 1<<6,1<<6


  Sync_Full
RDPBufferEnd:


align(8)
texture4:
  db 0+(1<<4), 2+(3<<4), 4+(5<<4), 6+(7<<4), 8+(9<<4), 10+(11<<4), 12+(13<<4), 14+(15<<4)

align(8)
texture8:
  db 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15

align(8)
texture16:
  dh 0, 1, 2, 3, 4, 5, 6, 7, 1 << 8, 2 << 8, 3 << 8, 4 << 8, 5 << 8, 6 << 8, 7 << 8, 8 << 8

align(8)
texture32:
  dw 1, 2, 4, 5
  dw 1 << 8, 2 << 8, 4 << 8, 5 << 8
  dw 1 << 16, 2 << 16, 4 << 16, 5 << 16
  dw 1 << 24, 2 << 24, 4 << 24, 5 << 24

align(8)
palette:
  dh 1|( 0<<1)|( 0<<6)|( 0<<11)
  dh 1|( 0<<1)|( 0<<6)|( 0<<11)
  dh 1|( 0<<1)|( 0<<6)|( 0<<11)
  dh 1|( 0<<1)|( 0<<6)|( 0<<11)
  dh 1|( 4<<1)|( 4<<6)|( 4<<11)
  dh 1|( 4<<1)|( 4<<6)|( 4<<11)
  dh 1|( 4<<1)|( 4<<6)|( 4<<11)
  dh 1|( 4<<1)|( 4<<6)|( 4<<11)
  dh 1|( 8<<1)|( 8<<6)|( 8<<11)
  dh 1|( 8<<1)|( 8<<6)|( 8<<11)
  dh 1|( 8<<1)|( 8<<6)|( 8<<11)
  dh 1|( 8<<1)|( 8<<6)|( 8<<11)
  dh 1|(31<<1)|(31<<6)|(31<<11)
  dh 1|(31<<1)|(31<<6)|(31<<11)
  dh 1|(31<<1)|(31<<6)|(31<<11)
  dh 1|(31<<1)|(31<<6)|(31<<11)
  // offset 32 bytes
  dh 1|(31<<1)|( 0<<6)|( 0<<11)
  dh 1|(31<<1)|( 0<<6)|( 0<<11)
  dh 1|(31<<1)|( 0<<6)|( 0<<11)
  dh 1|(31<<1)|( 0<<6)|( 0<<11)
  dh 1|(11<<1)|( 4<<6)|( 4<<11)
  dh 1|(11<<1)|( 4<<6)|( 4<<11)
  dh 1|(11<<1)|( 4<<6)|( 4<<11)
  dh 1|(11<<1)|( 4<<6)|( 4<<11)
  dh 1|( 7<<1)|( 8<<6)|( 8<<11)
  dh 1|( 7<<1)|( 8<<6)|( 8<<11)
  dh 1|( 7<<1)|( 8<<6)|( 8<<11)
  dh 1|( 7<<1)|( 8<<6)|( 8<<11)
  dh 1|( 0<<1)|(31<<6)|(15<<11)
  dh 1|( 0<<1)|(31<<6)|(15<<11)
  dh 1|( 0<<1)|(31<<6)|(15<<11)
  dh 1|( 0<<1)|(31<<6)|(15<<11)
  // offset 64 bytes
  dh 1|(15<<1)|(15<<6)|( 0<<11)
  dh 1|(15<<1)|(15<<6)|( 0<<11)
  dh 1|(15<<1)|(15<<6)|( 0<<11)
  dh 1|(15<<1)|(15<<6)|( 0<<11)
  dh 1|(11<<1)|(11<<6)|( 4<<11)
  dh 1|(11<<1)|(11<<6)|( 4<<11)
  dh 1|(11<<1)|(11<<6)|( 4<<11)
  dh 1|(11<<1)|(11<<6)|( 4<<11)
  dh 1|( 7<<1)|( 7<<6)|( 8<<11)
  dh 1|( 7<<1)|( 7<<6)|( 8<<11)
  dh 1|( 7<<1)|( 7<<6)|( 8<<11)
  dh 1|( 7<<1)|( 7<<6)|( 8<<11)
  dh 1|( 3<<1)|( 3<<6)|(31<<11)
  dh 1|( 3<<1)|( 3<<6)|(31<<11)
  dh 1|( 3<<1)|( 3<<6)|(31<<11)
  dh 1|( 3<<1)|( 3<<6)|(31<<11)
  // offset 96 bytes
  dh 1|(15<<1)|(15<<6)|(15<<11)
  dh 1|(15<<1)|(15<<6)|(15<<11)
  dh 1|(15<<1)|(15<<6)|(15<<11)
  dh 1|(15<<1)|(15<<6)|(15<<11)
  dh 1|(11<<1)|(11<<6)|(11<<11)
  dh 1|(11<<1)|(11<<6)|(11<<11)
  dh 1|(11<<1)|(11<<6)|(11<<11)
  dh 1|(11<<1)|(11<<6)|(11<<11)
  dh 1|( 7<<1)|( 7<<6)|( 7<<11)
  dh 1|( 7<<1)|( 7<<6)|( 7<<11)
  dh 1|( 7<<1)|( 7<<6)|( 7<<11)
  dh 1|( 7<<1)|( 7<<6)|( 7<<11)
  dh 1|( 0<<1)|( 0<<6)|( 0<<11)
  dh 1|( 0<<1)|( 0<<6)|( 0<<11)
  dh 1|( 0<<1)|( 0<<6)|( 0<<11)
  dh 1|( 0<<1)|( 0<<6)|( 0<<11)
  // offset 128 bytes
  dh 1|(31<<1)|( 0<<6)|(31<<11)
  dh 1|(31<<1)|( 0<<6)|(31<<11)
  dh 1|(31<<1)|( 0<<6)|(31<<11)
  dh 1|(31<<1)|( 0<<6)|(31<<11)
  dh 1|(11<<1)|( 4<<6)|(11<<11)
  dh 1|(11<<1)|( 4<<6)|(11<<11)
  dh 1|(11<<1)|( 4<<6)|(11<<11)
  dh 1|(11<<1)|( 4<<6)|(11<<11)
  dh 1|( 7<<1)|( 8<<6)|( 7<<11)
  dh 1|( 7<<1)|( 8<<6)|( 7<<11)
  dh 1|( 7<<1)|( 8<<6)|( 7<<11)
  dh 1|( 7<<1)|( 8<<6)|( 7<<11)
  dh 1|( 0<<1)|(15<<6)|( 0<<11)
  dh 1|( 0<<1)|(15<<6)|( 0<<11)
  dh 1|( 0<<1)|(15<<6)|( 0<<11)
  dh 1|( 0<<1)|(15<<6)|( 0<<11)
  // offset 160 bytes
  dh 1|( 0<<1)|( 0<<6)|(15<<11)
  dh 1|( 0<<1)|( 0<<6)|(15<<11)
  dh 1|( 0<<1)|( 0<<6)|(15<<11)
  dh 1|( 0<<1)|( 0<<6)|(15<<11)
  dh 1|( 4<<1)|( 4<<6)|(11<<11)
  dh 1|( 4<<1)|( 4<<6)|(11<<11)
  dh 1|( 4<<1)|( 4<<6)|(11<<11)
  dh 1|( 4<<1)|( 4<<6)|(11<<11)
  dh 1|( 8<<1)|( 8<<6)|( 7<<11)
  dh 1|( 8<<1)|( 8<<6)|( 7<<11)
  dh 1|( 8<<1)|( 8<<6)|( 7<<11)
  dh 1|( 8<<1)|( 8<<6)|( 7<<11)
  dh 1|(15<<1)|(15<<6)|( 0<<11)
  dh 1|(15<<1)|(15<<6)|( 0<<11)
  dh 1|(15<<1)|(15<<6)|( 0<<11)
  dh 1|(15<<1)|(15<<6)|( 0<<11)
  // offset 192 bytes
  dh 1|( 0<<1)|(31<<6)|(31<<11)
  dh 1|( 0<<1)|(31<<6)|(31<<11)
  dh 1|( 0<<1)|(31<<6)|(31<<11)
  dh 1|( 0<<1)|(31<<6)|(31<<11)
  dh 1|( 4<<1)|(11<<6)|(11<<11)
  dh 1|( 4<<1)|(11<<6)|(11<<11)
  dh 1|( 4<<1)|(11<<6)|(11<<11)
  dh 1|( 4<<1)|(11<<6)|(11<<11)
  dh 1|( 8<<1)|( 7<<6)|( 7<<11)
  dh 1|( 8<<1)|( 7<<6)|( 7<<11)
  dh 1|( 8<<1)|( 7<<6)|( 7<<11)
  dh 1|( 8<<1)|( 7<<6)|( 7<<11)
  dh 1|(31<<1)|( 0<<6)|( 0<<11)
  dh 1|(31<<1)|( 0<<6)|( 0<<11)
  dh 1|(31<<1)|( 0<<6)|( 0<<11)
  dh 1|(31<<1)|( 0<<6)|( 0<<11)
  // offset 224 bytes
  dh 1|( 0<<1)|(31<<6)|( 0<<11)
  dh 1|( 0<<1)|(31<<6)|( 0<<11)
  dh 1|( 0<<1)|(31<<6)|( 0<<11)
  dh 1|( 0<<1)|(31<<6)|( 0<<11)
  dh 1|( 4<<1)|(11<<6)|( 4<<11)
  dh 1|( 4<<1)|(11<<6)|( 4<<11)
  dh 1|( 4<<1)|(11<<6)|( 4<<11)
  dh 1|( 4<<1)|(11<<6)|( 4<<11)
  dh 1|( 8<<1)|( 7<<6)|( 8<<11)
  dh 1|( 8<<1)|( 7<<6)|( 8<<11)
  dh 1|( 8<<1)|( 7<<6)|( 8<<11)
  dh 1|( 8<<1)|( 7<<6)|( 8<<11)
  dh 1|(31<<1)|( 0<<6)|(31<<11)
  dh 1|(31<<1)|( 0<<6)|(31<<11)
  dh 1|(31<<1)|( 0<<6)|(31<<11)
  dh 1|(31<<1)|( 0<<6)|(31<<11)
