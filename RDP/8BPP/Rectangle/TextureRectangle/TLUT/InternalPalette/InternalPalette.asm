// N64 'Bare Metal' 8BPP 320x240 Copy Texture Rectangle TLUT RGBA8B RDP Internal Palette Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "InternalPalette.N64", create
fill 1052672 // Set ROM Size

origin $00000000
base $80000000 // Entry Point Of Code
include "LIB/N64.INC" // Include N64 Definitions
include "LIB/N64_HEADER.ASM" // Include 64 Byte Header & Vector Table
insert "LIB/N64_BOOTCODE.BIN" // Include 4032 Byte Boot Code

Start:
  include "LIB/N64_GFX.INC" // Include Graphics Macros
  N64_INIT() // Run N64 Initialisation Routine

  ScreenNTSC(160, 240, BPP16|AA_MODE_2, $A0100000) // Screen NTSC: 160x240, 16BPP, Resample Only, DRAM Origin $A0100000

  WaitScanline($200) // Wait For Scanline To Reach Vertical Blank

  DPC(RDPBuffer, RDPBufferEnd) // Run DPC Command Buffer: Start Address, End Address

Loop:
  j Loop
  nop // Delay Slot

align(8) // Align 64-Bit
RDPBuffer:
arch n64.rdp
  Set_Scissor 0<<2,0<<2, 0,0, 320<<2,240<<2 // Set Scissor: XH 0.0,YH 0.0, Scissor Field Enable Off,Field Off, XL 320.0,YL 240.0
  Set_Other_Modes CYCLE_TYPE_FILL // Set Other Modes
  Set_Color_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,320-1, $00100000 // Set Color Image: FORMAT COLOR INDX,SIZE 8B,WIDTH 320, DRAM ADDRESS $00100000
  Set_Fill_Color $FF01FF01 // Set Fill Color: PACKED COLOR 16B R5G5B5A1 Pixels
  Fill_Rectangle 319<<2,239<<2, 0<<2,0<<2 // Fill Rectangle: XL 319.0,YL 239.0, XH 0.0,YH 0.0

  Set_Other_Modes CYCLE_TYPE_COPY|EN_TLUT|ALPHA_COMPARE_EN // Set Other Modes

  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,1-1, Tlut // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 1, Tlut DRAM ADDRESS
  Set_Tile 0,0,0, $100, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: TMEM Address $100, Tile 0
  Load_Tlut 0<<2,0<<2, 0, 255<<2,0<<2 // Load Tlut: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 0.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture000 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture000 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 39<<2,7<<2, 0, 32<<2,0<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture001 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture001 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 55<<2,7<<2, 0, 48<<2,0<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture002 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture002 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 71<<2,7<<2, 0, 64<<2,0<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture003 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture003 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 87<<2,7<<2, 0, 80<<2,0<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture004 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture004 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 103<<2,7<<2, 0, 96<<2,0<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture005 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture005 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 119<<2,7<<2, 0, 112<<2,0<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture006 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture006 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 135<<2,7<<2, 0, 128<<2,0<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture007 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture007 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 151<<2,7<<2, 0, 144<<2,0<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture008 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture008 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 167<<2,7<<2, 0, 160<<2,0<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture009 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture009 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 183<<2,7<<2, 0, 176<<2,0<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture010 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture010 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 199<<2,7<<2, 0, 192<<2,0<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture011 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture011 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 215<<2,7<<2, 0, 208<<2,0<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture012 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture012 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 231<<2,7<<2, 0, 224<<2,0<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture013 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture013 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 247<<2,7<<2, 0, 240<<2,0<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture014 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture014 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 263<<2,7<<2, 0, 256<<2,0<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture015 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture015 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 279<<2,7<<2, 0, 272<<2,0<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY


  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture016 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture016 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 39<<2,22<<2, 0, 32<<2,15<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture017 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture017 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 55<<2,22<<2, 0, 48<<2,15<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture018 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture018 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 71<<2,22<<2, 0, 64<<2,15<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture019 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture019 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 87<<2,22<<2, 0, 80<<2,15<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture020 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture020 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 103<<2,22<<2, 0, 96<<2,15<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture021 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture021 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 119<<2,22<<2, 0, 112<<2,15<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture022 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture022 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 135<<2,22<<2, 0, 128<<2,15<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture023 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture023 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 151<<2,22<<2, 0, 144<<2,15<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture024 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture024 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 167<<2,22<<2, 0, 160<<2,15<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture025 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture025 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 183<<2,22<<2, 0, 176<<2,15<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture026 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture026 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 199<<2,22<<2, 0, 192<<2,15<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture027 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture027 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 215<<2,22<<2, 0, 208<<2,15<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture028 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture028 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 231<<2,22<<2, 0, 224<<2,15<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture029 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture029 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 247<<2,22<<2, 0, 240<<2,15<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture030 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture030 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 263<<2,22<<2, 0, 256<<2,15<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture031 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture031 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 279<<2,22<<2, 0, 272<<2,15<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY


  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture032 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture032 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 39<<2,37<<2, 0, 32<<2,30<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture033 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture033 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 55<<2,37<<2, 0, 48<<2,30<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture034 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture034 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 71<<2,37<<2, 0, 64<<2,30<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture035 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture035 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 87<<2,37<<2, 0, 80<<2,30<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture036 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture036 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 103<<2,37<<2, 0, 96<<2,30<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture037 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture037 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 119<<2,37<<2, 0, 112<<2,30<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture038 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture038 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 135<<2,37<<2, 0, 128<<2,30<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture039 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture039 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 151<<2,37<<2, 0, 144<<2,30<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture040 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture040 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 167<<2,37<<2, 0, 160<<2,30<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture041 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture041 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 183<<2,37<<2, 0, 176<<2,30<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture042 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture042 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 199<<2,37<<2, 0, 192<<2,30<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture043 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture043 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 215<<2,37<<2, 0, 208<<2,30<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture044 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture044 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 231<<2,37<<2, 0, 224<<2,30<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture045 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture045 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 247<<2,37<<2, 0, 240<<2,30<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture046 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture046 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 263<<2,37<<2, 0, 256<<2,30<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture047 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture047 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 279<<2,37<<2, 0, 272<<2,30<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY


  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture048 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture048 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 39<<2,52<<2, 0, 32<<2,45<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture049 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture049 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 55<<2,52<<2, 0, 48<<2,45<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture050 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture050 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 71<<2,52<<2, 0, 64<<2,45<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture051 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture051 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 87<<2,52<<2, 0, 80<<2,45<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture052 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture052 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 103<<2,52<<2, 0, 96<<2,45<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture053 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture053 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 119<<2,52<<2, 0, 112<<2,45<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture054 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture054 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 135<<2,52<<2, 0, 128<<2,45<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture055 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture055 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 151<<2,52<<2, 0, 144<<2,45<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture056 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture056 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 167<<2,52<<2, 0, 160<<2,45<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture057 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture057 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 183<<2,52<<2, 0, 176<<2,45<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture058 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture058 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 199<<2,52<<2, 0, 192<<2,45<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture059 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture059 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 215<<2,52<<2, 0, 208<<2,45<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture060 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture060 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 231<<2,52<<2, 0, 224<<2,45<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture061 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture061 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 247<<2,52<<2, 0, 240<<2,45<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture062 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture062 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 263<<2,52<<2, 0, 256<<2,45<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture063 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture063 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 279<<2,52<<2, 0, 272<<2,45<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY


  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture064 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture064 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 39<<2,67<<2, 0, 32<<2,60<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture065 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture065 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 55<<2,67<<2, 0, 48<<2,60<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture066 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture066 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 71<<2,67<<2, 0, 64<<2,60<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture067 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture067 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 87<<2,67<<2, 0, 80<<2,60<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture068 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture068 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 103<<2,67<<2, 0, 96<<2,60<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture069 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture069 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 119<<2,67<<2, 0, 112<<2,60<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture070 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture070 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 135<<2,67<<2, 0, 128<<2,60<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture071 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture071 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 151<<2,67<<2, 0, 144<<2,60<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture072 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture072 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 167<<2,67<<2, 0, 160<<2,60<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture073 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture073 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 183<<2,67<<2, 0, 176<<2,60<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture074 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture074 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 199<<2,67<<2, 0, 192<<2,60<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture075 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture075 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 215<<2,67<<2, 0, 208<<2,60<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture076 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture076 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 231<<2,67<<2, 0, 224<<2,60<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture077 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture077 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 247<<2,67<<2, 0, 240<<2,60<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture078 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture078 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 263<<2,67<<2, 0, 256<<2,60<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture079 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture079 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 279<<2,67<<2, 0, 272<<2,60<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY


  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture080 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture080 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 39<<2,82<<2, 0, 32<<2,75<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture081 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture081 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 55<<2,82<<2, 0, 48<<2,75<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture082 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture082 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 71<<2,82<<2, 0, 64<<2,75<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture083 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture083 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 87<<2,82<<2, 0, 80<<2,75<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture084 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture084 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 103<<2,82<<2, 0, 96<<2,75<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture085 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture085 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 119<<2,82<<2, 0, 112<<2,75<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture086 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture086 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 135<<2,82<<2, 0, 128<<2,75<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture087 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture087 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 151<<2,82<<2, 0, 144<<2,75<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture088 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture088 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 167<<2,82<<2, 0, 160<<2,75<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture089 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture089 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 183<<2,82<<2, 0, 176<<2,75<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture090 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture090 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 199<<2,82<<2, 0, 192<<2,75<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture091 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture091 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 215<<2,82<<2, 0, 208<<2,75<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture092 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture092 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 231<<2,82<<2, 0, 224<<2,75<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture093 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture093 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 247<<2,82<<2, 0, 240<<2,75<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture094 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture094 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 263<<2,82<<2, 0, 256<<2,75<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture095 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture095 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 279<<2,82<<2, 0, 272<<2,75<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY


  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture096 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture096 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 39<<2,97<<2, 0, 32<<2,90<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture097 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture097 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 55<<2,97<<2, 0, 48<<2,90<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture098 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture098 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 71<<2,97<<2, 0, 64<<2,90<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture099 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture099 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 87<<2,97<<2, 0, 80<<2,90<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture100 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture100 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 103<<2,97<<2, 0, 96<<2,90<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture101 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture101 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 119<<2,97<<2, 0, 112<<2,90<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture102 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture102 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 135<<2,97<<2, 0, 128<<2,90<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture103 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture103 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 151<<2,97<<2, 0, 144<<2,90<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture104 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture104 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 167<<2,97<<2, 0, 160<<2,90<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture105 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture105 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 183<<2,97<<2, 0, 176<<2,90<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture106 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture106 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 199<<2,97<<2, 0, 192<<2,90<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture107 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture107 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 215<<2,97<<2, 0, 208<<2,90<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture108 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture108 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 231<<2,97<<2, 0, 224<<2,90<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture109 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture109 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 247<<2,97<<2, 0, 240<<2,90<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture110 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture110 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 263<<2,97<<2, 0, 256<<2,90<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture111 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture111 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 279<<2,97<<2, 0, 272<<2,90<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY


  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture112 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture112 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 39<<2,112<<2, 0, 32<<2,105<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture113 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture113 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 55<<2,112<<2, 0, 48<<2,105<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture114 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture114 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 71<<2,112<<2, 0, 64<<2,105<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture115 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture115 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 87<<2,112<<2, 0, 80<<2,105<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture116 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture116 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 103<<2,112<<2, 0, 96<<2,105<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture117 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture117 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 119<<2,112<<2, 0, 112<<2,105<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture118 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture118 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 135<<2,112<<2, 0, 128<<2,105<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture119 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture119 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 151<<2,112<<2, 0, 144<<2,105<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture120 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture120 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 167<<2,112<<2, 0, 160<<2,105<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture121 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture121 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 183<<2,112<<2, 0, 176<<2,105<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture122 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture122 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 199<<2,112<<2, 0, 192<<2,105<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture123 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture123 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 215<<2,112<<2, 0, 208<<2,105<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture124 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture124 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 231<<2,112<<2, 0, 224<<2,105<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture125 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture125 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 247<<2,112<<2, 0, 240<<2,105<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture126 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture126 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 263<<2,112<<2, 0, 256<<2,105<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture127 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture127 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 279<<2,112<<2, 0, 272<<2,105<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY


  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture128 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture128 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 39<<2,127<<2, 0, 32<<2,120<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture129 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture129 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 55<<2,127<<2, 0, 48<<2,120<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture130 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture130 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 71<<2,127<<2, 0, 64<<2,120<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture131 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture131 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 87<<2,127<<2, 0, 80<<2,120<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture132 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture132 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 103<<2,127<<2, 0, 96<<2,120<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture133 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture133 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 119<<2,127<<2, 0, 112<<2,120<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture134 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture134 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 135<<2,127<<2, 0, 128<<2,120<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture135 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture135 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 151<<2,127<<2, 0, 144<<2,120<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture136 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture136 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 167<<2,127<<2, 0, 160<<2,120<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture137 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture137 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 183<<2,127<<2, 0, 176<<2,120<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture138 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture138 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 199<<2,127<<2, 0, 192<<2,120<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture139 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture139 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 215<<2,127<<2, 0, 208<<2,120<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture140 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture140 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 231<<2,127<<2, 0, 224<<2,120<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture141 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture141 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 247<<2,127<<2, 0, 240<<2,120<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture142 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture142 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 263<<2,127<<2, 0, 256<<2,120<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture143 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture143 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 279<<2,127<<2, 0, 272<<2,120<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY


  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture144 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture144 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 39<<2,142<<2, 0, 32<<2,135<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture145 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture145 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 55<<2,142<<2, 0, 48<<2,135<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture146 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture146 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 71<<2,142<<2, 0, 64<<2,135<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture147 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture147 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 87<<2,142<<2, 0, 80<<2,135<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture148 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture148 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 103<<2,142<<2, 0, 96<<2,135<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture149 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture149 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 119<<2,142<<2, 0, 112<<2,135<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture150 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture150 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 135<<2,142<<2, 0, 128<<2,135<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture151 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture151 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 151<<2,142<<2, 0, 144<<2,135<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture152 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture152 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 167<<2,142<<2, 0, 160<<2,135<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture153 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture153 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 183<<2,142<<2, 0, 176<<2,135<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture154 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture154 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 199<<2,142<<2, 0, 192<<2,135<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture155 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture155 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 215<<2,142<<2, 0, 208<<2,135<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture156 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture156 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 231<<2,142<<2, 0, 224<<2,135<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture157 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture157 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 247<<2,142<<2, 0, 240<<2,135<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture158 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture158 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 263<<2,142<<2, 0, 256<<2,135<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture159 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture159 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 279<<2,142<<2, 0, 272<<2,135<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY


  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture160 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture160 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 39<<2,157<<2, 0, 32<<2,150<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture161 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture161 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 55<<2,157<<2, 0, 48<<2,150<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture162 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture162 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 71<<2,157<<2, 0, 64<<2,150<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture163 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture163 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 87<<2,157<<2, 0, 80<<2,150<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture164 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture164 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 103<<2,157<<2, 0, 96<<2,150<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture165 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture165 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 119<<2,157<<2, 0, 112<<2,150<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture166 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture166 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 135<<2,157<<2, 0, 128<<2,150<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture167 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture167 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 151<<2,157<<2, 0, 144<<2,150<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture168 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture168 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 167<<2,157<<2, 0, 160<<2,150<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture169 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture169 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 183<<2,157<<2, 0, 176<<2,150<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture170 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture170 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 199<<2,157<<2, 0, 192<<2,150<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture171 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture171 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 215<<2,157<<2, 0, 208<<2,150<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture172 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture172 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 231<<2,157<<2, 0, 224<<2,150<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture173 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture173 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 247<<2,157<<2, 0, 240<<2,150<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture174 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture174 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 263<<2,157<<2, 0, 256<<2,150<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture175 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture175 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 279<<2,157<<2, 0, 272<<2,150<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY


  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture176 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture176 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 39<<2,172<<2, 0, 32<<2,165<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture177 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture177 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 55<<2,172<<2, 0, 48<<2,165<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture178 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture178 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 71<<2,172<<2, 0, 64<<2,165<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture179 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture179 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 87<<2,172<<2, 0, 80<<2,165<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture180 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture180 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 103<<2,172<<2, 0, 96<<2,165<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture181 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture181 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 119<<2,172<<2, 0, 112<<2,165<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture182 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture182 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 135<<2,172<<2, 0, 128<<2,165<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture183 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture183 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 151<<2,172<<2, 0, 144<<2,165<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture184 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture184 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 167<<2,172<<2, 0, 160<<2,165<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture185 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture185 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 183<<2,172<<2, 0, 176<<2,165<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture186 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture186 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 199<<2,172<<2, 0, 192<<2,165<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture187 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture187 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 215<<2,172<<2, 0, 208<<2,165<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture188 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture188 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 231<<2,172<<2, 0, 224<<2,165<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture189 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture189 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 247<<2,172<<2, 0, 240<<2,165<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture190 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture190 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 263<<2,172<<2, 0, 256<<2,165<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture191 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture191 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 279<<2,172<<2, 0, 272<<2,165<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY


  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture192 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture192 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 39<<2,187<<2, 0, 32<<2,180<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture193 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture193 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 55<<2,187<<2, 0, 48<<2,180<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture194 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture194 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 71<<2,187<<2, 0, 64<<2,180<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture195 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture195 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 87<<2,187<<2, 0, 80<<2,180<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture196 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture196 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 103<<2,187<<2, 0, 96<<2,180<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture197 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture197 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 119<<2,187<<2, 0, 112<<2,180<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture198 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture198 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 135<<2,187<<2, 0, 128<<2,180<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture199 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture199 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 151<<2,187<<2, 0, 144<<2,180<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture200 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture200 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 167<<2,187<<2, 0, 160<<2,180<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture201 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture201 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 183<<2,187<<2, 0, 176<<2,180<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture202 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture202 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 199<<2,187<<2, 0, 192<<2,180<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture203 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture203 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 215<<2,187<<2, 0, 208<<2,180<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture204 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture204 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 231<<2,187<<2, 0, 224<<2,180<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture205 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture205 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 247<<2,187<<2, 0, 240<<2,180<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture206 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture206 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 263<<2,187<<2, 0, 256<<2,180<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture207 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture207 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 279<<2,187<<2, 0, 272<<2,180<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY


  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture208 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture208 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 39<<2,202<<2, 0, 32<<2,195<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture209 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture209 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 55<<2,202<<2, 0, 48<<2,195<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture210 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture210 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 71<<2,202<<2, 0, 64<<2,195<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture211 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture211 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 87<<2,202<<2, 0, 80<<2,195<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture212 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture212 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 103<<2,202<<2, 0, 96<<2,195<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture213 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture213 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 119<<2,202<<2, 0, 112<<2,195<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture214 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture214 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 135<<2,202<<2, 0, 128<<2,195<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture215 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture215 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 151<<2,202<<2, 0, 144<<2,195<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture216 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture216 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 167<<2,202<<2, 0, 160<<2,195<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture217 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture217 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 183<<2,202<<2, 0, 176<<2,195<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture218 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture218 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 199<<2,202<<2, 0, 192<<2,195<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture219 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture219 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 215<<2,202<<2, 0, 208<<2,195<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture220 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture220 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 231<<2,202<<2, 0, 224<<2,195<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture221 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture221 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 247<<2,202<<2, 0, 240<<2,195<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture222 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture222 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 263<<2,202<<2, 0, 256<<2,195<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture223 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture223 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 279<<2,202<<2, 0, 272<<2,195<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY


  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture224 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture224 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 39<<2,217<<2, 0, 32<<2,210<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture225 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture225 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 55<<2,217<<2, 0, 48<<2,210<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture226 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture226 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 71<<2,217<<2, 0, 64<<2,210<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture227 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture227 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 87<<2,217<<2, 0, 80<<2,210<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture228 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture228 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 103<<2,217<<2, 0, 96<<2,210<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture229 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture229 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 119<<2,217<<2, 0, 112<<2,210<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture230 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture230 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 135<<2,217<<2, 0, 128<<2,210<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture231 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture231 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 151<<2,217<<2, 0, 144<<2,210<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture232 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture232 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 167<<2,217<<2, 0, 160<<2,210<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture233 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture233 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 183<<2,217<<2, 0, 176<<2,210<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture234 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture234 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 199<<2,217<<2, 0, 192<<2,210<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture235 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture235 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 215<<2,217<<2, 0, 208<<2,210<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture236 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture236 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 231<<2,217<<2, 0, 224<<2,210<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture237 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture237 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 247<<2,217<<2, 0, 240<<2,210<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture238 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture238 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 263<<2,217<<2, 0, 256<<2,210<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture239 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture239 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 279<<2,217<<2, 0, 272<<2,210<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY


  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture240 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture240 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 39<<2,232<<2, 0, 32<<2,225<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture241 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture241 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 55<<2,232<<2, 0, 48<<2,225<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture242 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture242 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 71<<2,232<<2, 0, 64<<2,225<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture243 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture243 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 87<<2,232<<2, 0, 80<<2,225<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture244 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture244 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 103<<2,232<<2, 0, 96<<2,225<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture245 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture245 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 119<<2,232<<2, 0, 112<<2,225<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture246 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture246 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 135<<2,232<<2, 0, 128<<2,225<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture247 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture247 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 151<<2,232<<2, 0, 144<<2,225<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture248 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture248 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 167<<2,232<<2, 0, 160<<2,225<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture249 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture249 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 183<<2,232<<2, 0, 176<<2,225<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture250 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture250 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 199<<2,232<<2, 0, 192<<2,225<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture251 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture251 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 215<<2,232<<2, 0, 208<<2,225<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture252 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture252 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 231<<2,232<<2, 0, 224<<2,225<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture253 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture253 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 247<<2,232<<2, 0, 240<<2,225<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture254 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture254 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 263<<2,232<<2, 0, 256<<2,225<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, Texture255 // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Texture255 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1,$000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Texture_Rectangle 279<<2,232<<2, 0, 272<<2,225<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

  Sync_Full // Ensure Entire Scene Is Fully Drawn
RDPBufferEnd:

Texture000:
  db $00,$00,$00,$00,$00,$00,$00,$00 // 8x8x8B = 64 Bytes
  db $00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00

Texture001:
  db $01,$01,$01,$01,$01,$01,$01,$01 // 8x8x8B = 64 Bytes
  db $01,$01,$01,$01,$01,$01,$01,$01
  db $01,$01,$01,$01,$01,$01,$01,$01
  db $01,$01,$01,$01,$01,$01,$01,$01
  db $01,$01,$01,$01,$01,$01,$01,$01
  db $01,$01,$01,$01,$01,$01,$01,$01
  db $01,$01,$01,$01,$01,$01,$01,$01
  db $01,$01,$01,$01,$01,$01,$01,$01

Texture002:
  db $02,$02,$02,$02,$02,$02,$02,$02 // 8x8x8B = 64 Bytes
  db $02,$02,$02,$02,$02,$02,$02,$02
  db $02,$02,$02,$02,$02,$02,$02,$02
  db $02,$02,$02,$02,$02,$02,$02,$02
  db $02,$02,$02,$02,$02,$02,$02,$02
  db $02,$02,$02,$02,$02,$02,$02,$02
  db $02,$02,$02,$02,$02,$02,$02,$02
  db $02,$02,$02,$02,$02,$02,$02,$02

Texture003:
  db $03,$03,$03,$03,$03,$03,$03,$03 // 8x8x8B = 64 Bytes
  db $03,$03,$03,$03,$03,$03,$03,$03
  db $03,$03,$03,$03,$03,$03,$03,$03
  db $03,$03,$03,$03,$03,$03,$03,$03
  db $03,$03,$03,$03,$03,$03,$03,$03
  db $03,$03,$03,$03,$03,$03,$03,$03
  db $03,$03,$03,$03,$03,$03,$03,$03
  db $03,$03,$03,$03,$03,$03,$03,$03

Texture004:
  db $04,$04,$04,$04,$04,$04,$04,$04 // 8x8x8B = 64 Bytes
  db $04,$04,$04,$04,$04,$04,$04,$04
  db $04,$04,$04,$04,$04,$04,$04,$04
  db $04,$04,$04,$04,$04,$04,$04,$04
  db $04,$04,$04,$04,$04,$04,$04,$04
  db $04,$04,$04,$04,$04,$04,$04,$04
  db $04,$04,$04,$04,$04,$04,$04,$04
  db $04,$04,$04,$04,$04,$04,$04,$04

Texture005:
  db $05,$05,$05,$05,$05,$05,$05,$05 // 8x8x8B = 64 Bytes
  db $05,$05,$05,$05,$05,$05,$05,$05
  db $05,$05,$05,$05,$05,$05,$05,$05
  db $05,$05,$05,$05,$05,$05,$05,$05
  db $05,$05,$05,$05,$05,$05,$05,$05
  db $05,$05,$05,$05,$05,$05,$05,$05
  db $05,$05,$05,$05,$05,$05,$05,$05
  db $05,$05,$05,$05,$05,$05,$05,$05

Texture006:
  db $06,$06,$06,$06,$06,$06,$06,$06 // 8x8x8B = 64 Bytes
  db $06,$06,$06,$06,$06,$06,$06,$06
  db $06,$06,$06,$06,$06,$06,$06,$06
  db $06,$06,$06,$06,$06,$06,$06,$06
  db $06,$06,$06,$06,$06,$06,$06,$06
  db $06,$06,$06,$06,$06,$06,$06,$06
  db $06,$06,$06,$06,$06,$06,$06,$06
  db $06,$06,$06,$06,$06,$06,$06,$06

Texture007:
  db $07,$07,$07,$07,$07,$07,$07,$07 // 8x8x8B = 64 Bytes
  db $07,$07,$07,$07,$07,$07,$07,$07
  db $07,$07,$07,$07,$07,$07,$07,$07
  db $07,$07,$07,$07,$07,$07,$07,$07
  db $07,$07,$07,$07,$07,$07,$07,$07
  db $07,$07,$07,$07,$07,$07,$07,$07
  db $07,$07,$07,$07,$07,$07,$07,$07
  db $07,$07,$07,$07,$07,$07,$07,$07

Texture008:
  db $08,$08,$08,$08,$08,$08,$08,$08 // 8x8x8B = 64 Bytes
  db $08,$08,$08,$08,$08,$08,$08,$08
  db $08,$08,$08,$08,$08,$08,$08,$08
  db $08,$08,$08,$08,$08,$08,$08,$08
  db $08,$08,$08,$08,$08,$08,$08,$08
  db $08,$08,$08,$08,$08,$08,$08,$08
  db $08,$08,$08,$08,$08,$08,$08,$08
  db $08,$08,$08,$08,$08,$08,$08,$08

Texture009:
  db $09,$09,$09,$09,$09,$09,$09,$09 // 8x8x8B = 64 Bytes
  db $09,$09,$09,$09,$09,$09,$09,$09
  db $09,$09,$09,$09,$09,$09,$09,$09
  db $09,$09,$09,$09,$09,$09,$09,$09
  db $09,$09,$09,$09,$09,$09,$09,$09
  db $09,$09,$09,$09,$09,$09,$09,$09
  db $09,$09,$09,$09,$09,$09,$09,$09
  db $09,$09,$09,$09,$09,$09,$09,$09

Texture010:
  db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A // 8x8x8B = 64 Bytes
  db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
  db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
  db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
  db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
  db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
  db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
  db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A

Texture011:
  db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B // 8x8x8B = 64 Bytes
  db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
  db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
  db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
  db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
  db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
  db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
  db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B

Texture012:
  db $0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C // 8x8x8B = 64 Bytes
  db $0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C
  db $0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C
  db $0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C
  db $0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C
  db $0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C
  db $0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C
  db $0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C

Texture013:
  db $0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D // 8x8x8B = 64 Bytes
  db $0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D
  db $0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D
  db $0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D
  db $0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D
  db $0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D
  db $0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D
  db $0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D

Texture014:
  db $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E // 8x8x8B = 64 Bytes
  db $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
  db $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
  db $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
  db $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
  db $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
  db $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
  db $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E

Texture015:
  db $0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F // 8x8x8B = 64 Bytes
  db $0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F
  db $0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F
  db $0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F
  db $0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F
  db $0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F
  db $0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F
  db $0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F

Texture016:
  db $10,$10,$10,$10,$10,$10,$10,$10 // 8x8x8B = 64 Bytes
  db $10,$10,$10,$10,$10,$10,$10,$10
  db $10,$10,$10,$10,$10,$10,$10,$10
  db $10,$10,$10,$10,$10,$10,$10,$10
  db $10,$10,$10,$10,$10,$10,$10,$10
  db $10,$10,$10,$10,$10,$10,$10,$10
  db $10,$10,$10,$10,$10,$10,$10,$10
  db $10,$10,$10,$10,$10,$10,$10,$10

Texture017:
  db $11,$11,$11,$11,$11,$11,$11,$11 // 8x8x8B = 64 Bytes
  db $11,$11,$11,$11,$11,$11,$11,$11
  db $11,$11,$11,$11,$11,$11,$11,$11
  db $11,$11,$11,$11,$11,$11,$11,$11
  db $11,$11,$11,$11,$11,$11,$11,$11
  db $11,$11,$11,$11,$11,$11,$11,$11
  db $11,$11,$11,$11,$11,$11,$11,$11
  db $11,$11,$11,$11,$11,$11,$11,$11

Texture018:
  db $12,$12,$12,$12,$12,$12,$12,$12 // 8x8x8B = 64 Bytes
  db $12,$12,$12,$12,$12,$12,$12,$12
  db $12,$12,$12,$12,$12,$12,$12,$12
  db $12,$12,$12,$12,$12,$12,$12,$12
  db $12,$12,$12,$12,$12,$12,$12,$12
  db $12,$12,$12,$12,$12,$12,$12,$12
  db $12,$12,$12,$12,$12,$12,$12,$12
  db $12,$12,$12,$12,$12,$12,$12,$12

Texture019:
  db $13,$13,$13,$13,$13,$13,$13,$13 // 8x8x8B = 64 Bytes
  db $13,$13,$13,$13,$13,$13,$13,$13
  db $13,$13,$13,$13,$13,$13,$13,$13
  db $13,$13,$13,$13,$13,$13,$13,$13
  db $13,$13,$13,$13,$13,$13,$13,$13
  db $13,$13,$13,$13,$13,$13,$13,$13
  db $13,$13,$13,$13,$13,$13,$13,$13
  db $13,$13,$13,$13,$13,$13,$13,$13

Texture020:
  db $14,$14,$14,$14,$14,$14,$14,$14 // 8x8x8B = 64 Bytes
  db $14,$14,$14,$14,$14,$14,$14,$14
  db $14,$14,$14,$14,$14,$14,$14,$14
  db $14,$14,$14,$14,$14,$14,$14,$14
  db $14,$14,$14,$14,$14,$14,$14,$14
  db $14,$14,$14,$14,$14,$14,$14,$14
  db $14,$14,$14,$14,$14,$14,$14,$14
  db $14,$14,$14,$14,$14,$14,$14,$14

Texture021:
  db $15,$15,$15,$15,$15,$15,$15,$15 // 8x8x8B = 64 Bytes
  db $15,$15,$15,$15,$15,$15,$15,$15
  db $15,$15,$15,$15,$15,$15,$15,$15
  db $15,$15,$15,$15,$15,$15,$15,$15
  db $15,$15,$15,$15,$15,$15,$15,$15
  db $15,$15,$15,$15,$15,$15,$15,$15
  db $15,$15,$15,$15,$15,$15,$15,$15
  db $15,$15,$15,$15,$15,$15,$15,$15

Texture022:
  db $16,$16,$16,$16,$16,$16,$16,$16 // 8x8x8B = 64 Bytes
  db $16,$16,$16,$16,$16,$16,$16,$16
  db $16,$16,$16,$16,$16,$16,$16,$16
  db $16,$16,$16,$16,$16,$16,$16,$16
  db $16,$16,$16,$16,$16,$16,$16,$16
  db $16,$16,$16,$16,$16,$16,$16,$16
  db $16,$16,$16,$16,$16,$16,$16,$16
  db $16,$16,$16,$16,$16,$16,$16,$16

Texture023:
  db $17,$17,$17,$17,$17,$17,$17,$17 // 8x8x8B = 64 Bytes
  db $17,$17,$17,$17,$17,$17,$17,$17
  db $17,$17,$17,$17,$17,$17,$17,$17
  db $17,$17,$17,$17,$17,$17,$17,$17
  db $17,$17,$17,$17,$17,$17,$17,$17
  db $17,$17,$17,$17,$17,$17,$17,$17
  db $17,$17,$17,$17,$17,$17,$17,$17
  db $17,$17,$17,$17,$17,$17,$17,$17

Texture024:
  db $18,$18,$18,$18,$18,$18,$18,$18 // 8x8x8B = 64 Bytes
  db $18,$18,$18,$18,$18,$18,$18,$18
  db $18,$18,$18,$18,$18,$18,$18,$18
  db $18,$18,$18,$18,$18,$18,$18,$18
  db $18,$18,$18,$18,$18,$18,$18,$18
  db $18,$18,$18,$18,$18,$18,$18,$18
  db $18,$18,$18,$18,$18,$18,$18,$18
  db $18,$18,$18,$18,$18,$18,$18,$18

Texture025:
  db $19,$19,$19,$19,$19,$19,$19,$19 // 8x8x8B = 64 Bytes
  db $19,$19,$19,$19,$19,$19,$19,$19
  db $19,$19,$19,$19,$19,$19,$19,$19
  db $19,$19,$19,$19,$19,$19,$19,$19
  db $19,$19,$19,$19,$19,$19,$19,$19
  db $19,$19,$19,$19,$19,$19,$19,$19
  db $19,$19,$19,$19,$19,$19,$19,$19
  db $19,$19,$19,$19,$19,$19,$19,$19

Texture026:
  db $1A,$1A,$1A,$1A,$1A,$1A,$1A,$1A // 8x8x8B = 64 Bytes
  db $1A,$1A,$1A,$1A,$1A,$1A,$1A,$1A
  db $1A,$1A,$1A,$1A,$1A,$1A,$1A,$1A
  db $1A,$1A,$1A,$1A,$1A,$1A,$1A,$1A
  db $1A,$1A,$1A,$1A,$1A,$1A,$1A,$1A
  db $1A,$1A,$1A,$1A,$1A,$1A,$1A,$1A
  db $1A,$1A,$1A,$1A,$1A,$1A,$1A,$1A
  db $1A,$1A,$1A,$1A,$1A,$1A,$1A,$1A

Texture027:
  db $1B,$1B,$1B,$1B,$1B,$1B,$1B,$1B // 8x8x8B = 64 Bytes
  db $1B,$1B,$1B,$1B,$1B,$1B,$1B,$1B
  db $1B,$1B,$1B,$1B,$1B,$1B,$1B,$1B
  db $1B,$1B,$1B,$1B,$1B,$1B,$1B,$1B
  db $1B,$1B,$1B,$1B,$1B,$1B,$1B,$1B
  db $1B,$1B,$1B,$1B,$1B,$1B,$1B,$1B
  db $1B,$1B,$1B,$1B,$1B,$1B,$1B,$1B
  db $1B,$1B,$1B,$1B,$1B,$1B,$1B,$1B

Texture028:
  db $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C // 8x8x8B = 64 Bytes
  db $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C
  db $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C
  db $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C
  db $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C
  db $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C
  db $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C
  db $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C

Texture029:
  db $1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D // 8x8x8B = 64 Bytes
  db $1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D
  db $1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D
  db $1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D
  db $1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D
  db $1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D
  db $1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D
  db $1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D

Texture030:
  db $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E // 8x8x8B = 64 Bytes
  db $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E
  db $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E
  db $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E
  db $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E
  db $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E
  db $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E
  db $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E

Texture031:
  db $1F,$1F,$1F,$1F,$1F,$1F,$1F,$1F // 8x8x8B = 64 Bytes
  db $1F,$1F,$1F,$1F,$1F,$1F,$1F,$1F
  db $1F,$1F,$1F,$1F,$1F,$1F,$1F,$1F
  db $1F,$1F,$1F,$1F,$1F,$1F,$1F,$1F
  db $1F,$1F,$1F,$1F,$1F,$1F,$1F,$1F
  db $1F,$1F,$1F,$1F,$1F,$1F,$1F,$1F
  db $1F,$1F,$1F,$1F,$1F,$1F,$1F,$1F
  db $1F,$1F,$1F,$1F,$1F,$1F,$1F,$1F

Texture032:
  db $20,$20,$20,$20,$20,$20,$20,$20 // 8x8x8B = 64 Bytes
  db $20,$20,$20,$20,$20,$20,$20,$20
  db $20,$20,$20,$20,$20,$20,$20,$20
  db $20,$20,$20,$20,$20,$20,$20,$20
  db $20,$20,$20,$20,$20,$20,$20,$20
  db $20,$20,$20,$20,$20,$20,$20,$20
  db $20,$20,$20,$20,$20,$20,$20,$20
  db $20,$20,$20,$20,$20,$20,$20,$20

Texture033:
  db $21,$21,$21,$21,$21,$21,$21,$21 // 8x8x8B = 64 Bytes
  db $21,$21,$21,$21,$21,$21,$21,$21
  db $21,$21,$21,$21,$21,$21,$21,$21
  db $21,$21,$21,$21,$21,$21,$21,$21
  db $21,$21,$21,$21,$21,$21,$21,$21
  db $21,$21,$21,$21,$21,$21,$21,$21
  db $21,$21,$21,$21,$21,$21,$21,$21
  db $21,$21,$21,$21,$21,$21,$21,$21

Texture034:
  db $22,$22,$22,$22,$22,$22,$22,$22 // 8x8x8B = 64 Bytes
  db $22,$22,$22,$22,$22,$22,$22,$22
  db $22,$22,$22,$22,$22,$22,$22,$22
  db $22,$22,$22,$22,$22,$22,$22,$22
  db $22,$22,$22,$22,$22,$22,$22,$22
  db $22,$22,$22,$22,$22,$22,$22,$22
  db $22,$22,$22,$22,$22,$22,$22,$22
  db $22,$22,$22,$22,$22,$22,$22,$22

Texture035:
  db $23,$23,$23,$23,$23,$23,$23,$23 // 8x8x8B = 64 Bytes
  db $23,$23,$23,$23,$23,$23,$23,$23
  db $23,$23,$23,$23,$23,$23,$23,$23
  db $23,$23,$23,$23,$23,$23,$23,$23
  db $23,$23,$23,$23,$23,$23,$23,$23
  db $23,$23,$23,$23,$23,$23,$23,$23
  db $23,$23,$23,$23,$23,$23,$23,$23
  db $23,$23,$23,$23,$23,$23,$23,$23

Texture036:
  db $24,$24,$24,$24,$24,$24,$24,$24 // 8x8x8B = 64 Bytes
  db $24,$24,$24,$24,$24,$24,$24,$24
  db $24,$24,$24,$24,$24,$24,$24,$24
  db $24,$24,$24,$24,$24,$24,$24,$24
  db $24,$24,$24,$24,$24,$24,$24,$24
  db $24,$24,$24,$24,$24,$24,$24,$24
  db $24,$24,$24,$24,$24,$24,$24,$24
  db $24,$24,$24,$24,$24,$24,$24,$24

Texture037:
  db $25,$25,$25,$25,$25,$25,$25,$25 // 8x8x8B = 64 Bytes
  db $25,$25,$25,$25,$25,$25,$25,$25
  db $25,$25,$25,$25,$25,$25,$25,$25
  db $25,$25,$25,$25,$25,$25,$25,$25
  db $25,$25,$25,$25,$25,$25,$25,$25
  db $25,$25,$25,$25,$25,$25,$25,$25
  db $25,$25,$25,$25,$25,$25,$25,$25
  db $25,$25,$25,$25,$25,$25,$25,$25

Texture038:
  db $26,$26,$26,$26,$26,$26,$26,$26 // 8x8x8B = 64 Bytes
  db $26,$26,$26,$26,$26,$26,$26,$26
  db $26,$26,$26,$26,$26,$26,$26,$26
  db $26,$26,$26,$26,$26,$26,$26,$26
  db $26,$26,$26,$26,$26,$26,$26,$26
  db $26,$26,$26,$26,$26,$26,$26,$26
  db $26,$26,$26,$26,$26,$26,$26,$26
  db $26,$26,$26,$26,$26,$26,$26,$26

Texture039:
  db $27,$27,$27,$27,$27,$27,$27,$27 // 8x8x8B = 64 Bytes
  db $27,$27,$27,$27,$27,$27,$27,$27
  db $27,$27,$27,$27,$27,$27,$27,$27
  db $27,$27,$27,$27,$27,$27,$27,$27
  db $27,$27,$27,$27,$27,$27,$27,$27
  db $27,$27,$27,$27,$27,$27,$27,$27
  db $27,$27,$27,$27,$27,$27,$27,$27
  db $27,$27,$27,$27,$27,$27,$27,$27

Texture040:
  db $28,$28,$28,$28,$28,$28,$28,$28 // 8x8x8B = 64 Bytes
  db $28,$28,$28,$28,$28,$28,$28,$28
  db $28,$28,$28,$28,$28,$28,$28,$28
  db $28,$28,$28,$28,$28,$28,$28,$28
  db $28,$28,$28,$28,$28,$28,$28,$28
  db $28,$28,$28,$28,$28,$28,$28,$28
  db $28,$28,$28,$28,$28,$28,$28,$28
  db $28,$28,$28,$28,$28,$28,$28,$28

Texture041:
  db $29,$29,$29,$29,$29,$29,$29,$29 // 8x8x8B = 64 Bytes
  db $29,$29,$29,$29,$29,$29,$29,$29
  db $29,$29,$29,$29,$29,$29,$29,$29
  db $29,$29,$29,$29,$29,$29,$29,$29
  db $29,$29,$29,$29,$29,$29,$29,$29
  db $29,$29,$29,$29,$29,$29,$29,$29
  db $29,$29,$29,$29,$29,$29,$29,$29
  db $29,$29,$29,$29,$29,$29,$29,$29

Texture042:
  db $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A // 8x8x8B = 64 Bytes
  db $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A
  db $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A
  db $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A
  db $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A
  db $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A
  db $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A
  db $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A

Texture043:
  db $2B,$2B,$2B,$2B,$2B,$2B,$2B,$2B // 8x8x8B = 64 Bytes
  db $2B,$2B,$2B,$2B,$2B,$2B,$2B,$2B
  db $2B,$2B,$2B,$2B,$2B,$2B,$2B,$2B
  db $2B,$2B,$2B,$2B,$2B,$2B,$2B,$2B
  db $2B,$2B,$2B,$2B,$2B,$2B,$2B,$2B
  db $2B,$2B,$2B,$2B,$2B,$2B,$2B,$2B
  db $2B,$2B,$2B,$2B,$2B,$2B,$2B,$2B
  db $2B,$2B,$2B,$2B,$2B,$2B,$2B,$2B

Texture044:
  db $2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C // 8x8x8B = 64 Bytes
  db $2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C
  db $2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C
  db $2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C
  db $2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C
  db $2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C
  db $2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C
  db $2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C

Texture045:
  db $2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D // 8x8x8B = 64 Bytes
  db $2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D
  db $2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D
  db $2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D
  db $2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D
  db $2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D
  db $2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D
  db $2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D

Texture046:
  db $2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E // 8x8x8B = 64 Bytes
  db $2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E
  db $2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E
  db $2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E
  db $2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E
  db $2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E
  db $2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E
  db $2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E

Texture047:
  db $2F,$2F,$2F,$2F,$2F,$2F,$2F,$2F // 8x8x8B = 64 Bytes
  db $2F,$2F,$2F,$2F,$2F,$2F,$2F,$2F
  db $2F,$2F,$2F,$2F,$2F,$2F,$2F,$2F
  db $2F,$2F,$2F,$2F,$2F,$2F,$2F,$2F
  db $2F,$2F,$2F,$2F,$2F,$2F,$2F,$2F
  db $2F,$2F,$2F,$2F,$2F,$2F,$2F,$2F
  db $2F,$2F,$2F,$2F,$2F,$2F,$2F,$2F
  db $2F,$2F,$2F,$2F,$2F,$2F,$2F,$2F

Texture048:
  db $30,$30,$30,$30,$30,$30,$30,$30 // 8x8x8B = 64 Bytes
  db $30,$30,$30,$30,$30,$30,$30,$30
  db $30,$30,$30,$30,$30,$30,$30,$30
  db $30,$30,$30,$30,$30,$30,$30,$30
  db $30,$30,$30,$30,$30,$30,$30,$30
  db $30,$30,$30,$30,$30,$30,$30,$30
  db $30,$30,$30,$30,$30,$30,$30,$30
  db $30,$30,$30,$30,$30,$30,$30,$30

Texture049:
  db $31,$31,$31,$31,$31,$31,$31,$31 // 8x8x8B = 64 Bytes
  db $31,$31,$31,$31,$31,$31,$31,$31
  db $31,$31,$31,$31,$31,$31,$31,$31
  db $31,$31,$31,$31,$31,$31,$31,$31
  db $31,$31,$31,$31,$31,$31,$31,$31
  db $31,$31,$31,$31,$31,$31,$31,$31
  db $31,$31,$31,$31,$31,$31,$31,$31
  db $31,$31,$31,$31,$31,$31,$31,$31

Texture050:
  db $32,$32,$32,$32,$32,$32,$32,$32 // 8x8x8B = 64 Bytes
  db $32,$32,$32,$32,$32,$32,$32,$32
  db $32,$32,$32,$32,$32,$32,$32,$32
  db $32,$32,$32,$32,$32,$32,$32,$32
  db $32,$32,$32,$32,$32,$32,$32,$32
  db $32,$32,$32,$32,$32,$32,$32,$32
  db $32,$32,$32,$32,$32,$32,$32,$32
  db $32,$32,$32,$32,$32,$32,$32,$32

Texture051:
  db $33,$33,$33,$33,$33,$33,$33,$33 // 8x8x8B = 64 Bytes
  db $33,$33,$33,$33,$33,$33,$33,$33
  db $33,$33,$33,$33,$33,$33,$33,$33
  db $33,$33,$33,$33,$33,$33,$33,$33
  db $33,$33,$33,$33,$33,$33,$33,$33
  db $33,$33,$33,$33,$33,$33,$33,$33
  db $33,$33,$33,$33,$33,$33,$33,$33
  db $33,$33,$33,$33,$33,$33,$33,$33

Texture052:
  db $34,$34,$34,$34,$34,$34,$34,$34 // 8x8x8B = 64 Bytes
  db $34,$34,$34,$34,$34,$34,$34,$34
  db $34,$34,$34,$34,$34,$34,$34,$34
  db $34,$34,$34,$34,$34,$34,$34,$34
  db $34,$34,$34,$34,$34,$34,$34,$34
  db $34,$34,$34,$34,$34,$34,$34,$34
  db $34,$34,$34,$34,$34,$34,$34,$34
  db $34,$34,$34,$34,$34,$34,$34,$34

Texture053:
  db $35,$35,$35,$35,$35,$35,$35,$35 // 8x8x8B = 64 Bytes
  db $35,$35,$35,$35,$35,$35,$35,$35
  db $35,$35,$35,$35,$35,$35,$35,$35
  db $35,$35,$35,$35,$35,$35,$35,$35
  db $35,$35,$35,$35,$35,$35,$35,$35
  db $35,$35,$35,$35,$35,$35,$35,$35
  db $35,$35,$35,$35,$35,$35,$35,$35
  db $35,$35,$35,$35,$35,$35,$35,$35

Texture054:
  db $36,$36,$36,$36,$36,$36,$36,$36 // 8x8x8B = 64 Bytes
  db $36,$36,$36,$36,$36,$36,$36,$36
  db $36,$36,$36,$36,$36,$36,$36,$36
  db $36,$36,$36,$36,$36,$36,$36,$36
  db $36,$36,$36,$36,$36,$36,$36,$36
  db $36,$36,$36,$36,$36,$36,$36,$36
  db $36,$36,$36,$36,$36,$36,$36,$36
  db $36,$36,$36,$36,$36,$36,$36,$36

Texture055:
  db $37,$37,$37,$37,$37,$37,$37,$37 // 8x8x8B = 64 Bytes
  db $37,$37,$37,$37,$37,$37,$37,$37
  db $37,$37,$37,$37,$37,$37,$37,$37
  db $37,$37,$37,$37,$37,$37,$37,$37
  db $37,$37,$37,$37,$37,$37,$37,$37
  db $37,$37,$37,$37,$37,$37,$37,$37
  db $37,$37,$37,$37,$37,$37,$37,$37
  db $37,$37,$37,$37,$37,$37,$37,$37

Texture056:
  db $38,$38,$38,$38,$38,$38,$38,$38 // 8x8x8B = 64 Bytes
  db $38,$38,$38,$38,$38,$38,$38,$38
  db $38,$38,$38,$38,$38,$38,$38,$38
  db $38,$38,$38,$38,$38,$38,$38,$38
  db $38,$38,$38,$38,$38,$38,$38,$38
  db $38,$38,$38,$38,$38,$38,$38,$38
  db $38,$38,$38,$38,$38,$38,$38,$38
  db $38,$38,$38,$38,$38,$38,$38,$38

Texture057:
  db $39,$39,$39,$39,$39,$39,$39,$39 // 8x8x8B = 64 Bytes
  db $39,$39,$39,$39,$39,$39,$39,$39
  db $39,$39,$39,$39,$39,$39,$39,$39
  db $39,$39,$39,$39,$39,$39,$39,$39
  db $39,$39,$39,$39,$39,$39,$39,$39
  db $39,$39,$39,$39,$39,$39,$39,$39
  db $39,$39,$39,$39,$39,$39,$39,$39
  db $39,$39,$39,$39,$39,$39,$39,$39

Texture058:
  db $3A,$3A,$3A,$3A,$3A,$3A,$3A,$3A // 8x8x8B = 64 Bytes
  db $3A,$3A,$3A,$3A,$3A,$3A,$3A,$3A
  db $3A,$3A,$3A,$3A,$3A,$3A,$3A,$3A
  db $3A,$3A,$3A,$3A,$3A,$3A,$3A,$3A
  db $3A,$3A,$3A,$3A,$3A,$3A,$3A,$3A
  db $3A,$3A,$3A,$3A,$3A,$3A,$3A,$3A
  db $3A,$3A,$3A,$3A,$3A,$3A,$3A,$3A
  db $3A,$3A,$3A,$3A,$3A,$3A,$3A,$3A

Texture059:
  db $3B,$3B,$3B,$3B,$3B,$3B,$3B,$3B // 8x8x8B = 64 Bytes
  db $3B,$3B,$3B,$3B,$3B,$3B,$3B,$3B
  db $3B,$3B,$3B,$3B,$3B,$3B,$3B,$3B
  db $3B,$3B,$3B,$3B,$3B,$3B,$3B,$3B
  db $3B,$3B,$3B,$3B,$3B,$3B,$3B,$3B
  db $3B,$3B,$3B,$3B,$3B,$3B,$3B,$3B
  db $3B,$3B,$3B,$3B,$3B,$3B,$3B,$3B
  db $3B,$3B,$3B,$3B,$3B,$3B,$3B,$3B

Texture060:
  db $3C,$3C,$3C,$3C,$3C,$3C,$3C,$3C // 8x8x8B = 64 Bytes
  db $3C,$3C,$3C,$3C,$3C,$3C,$3C,$3C
  db $3C,$3C,$3C,$3C,$3C,$3C,$3C,$3C
  db $3C,$3C,$3C,$3C,$3C,$3C,$3C,$3C
  db $3C,$3C,$3C,$3C,$3C,$3C,$3C,$3C
  db $3C,$3C,$3C,$3C,$3C,$3C,$3C,$3C
  db $3C,$3C,$3C,$3C,$3C,$3C,$3C,$3C
  db $3C,$3C,$3C,$3C,$3C,$3C,$3C,$3C

Texture061:
  db $3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D // 8x8x8B = 64 Bytes
  db $3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D
  db $3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D
  db $3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D
  db $3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D
  db $3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D
  db $3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D
  db $3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D

Texture062:
  db $3E,$3E,$3E,$3E,$3E,$3E,$3E,$3E // 8x8x8B = 64 Bytes
  db $3E,$3E,$3E,$3E,$3E,$3E,$3E,$3E
  db $3E,$3E,$3E,$3E,$3E,$3E,$3E,$3E
  db $3E,$3E,$3E,$3E,$3E,$3E,$3E,$3E
  db $3E,$3E,$3E,$3E,$3E,$3E,$3E,$3E
  db $3E,$3E,$3E,$3E,$3E,$3E,$3E,$3E
  db $3E,$3E,$3E,$3E,$3E,$3E,$3E,$3E
  db $3E,$3E,$3E,$3E,$3E,$3E,$3E,$3E

Texture063:
  db $3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F // 8x8x8B = 64 Bytes
  db $3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F
  db $3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F
  db $3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F
  db $3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F
  db $3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F
  db $3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F
  db $3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F

Texture064:
  db $40,$40,$40,$40,$40,$40,$40,$40 // 8x8x8B = 64 Bytes
  db $40,$40,$40,$40,$40,$40,$40,$40
  db $40,$40,$40,$40,$40,$40,$40,$40
  db $40,$40,$40,$40,$40,$40,$40,$40
  db $40,$40,$40,$40,$40,$40,$40,$40
  db $40,$40,$40,$40,$40,$40,$40,$40
  db $40,$40,$40,$40,$40,$40,$40,$40
  db $40,$40,$40,$40,$40,$40,$40,$40

Texture065:
  db $41,$41,$41,$41,$41,$41,$41,$41 // 8x8x8B = 64 Bytes
  db $41,$41,$41,$41,$41,$41,$41,$41
  db $41,$41,$41,$41,$41,$41,$41,$41
  db $41,$41,$41,$41,$41,$41,$41,$41
  db $41,$41,$41,$41,$41,$41,$41,$41
  db $41,$41,$41,$41,$41,$41,$41,$41
  db $41,$41,$41,$41,$41,$41,$41,$41
  db $41,$41,$41,$41,$41,$41,$41,$41

Texture066:
  db $42,$42,$42,$42,$42,$42,$42,$42 // 8x8x8B = 64 Bytes
  db $42,$42,$42,$42,$42,$42,$42,$42
  db $42,$42,$42,$42,$42,$42,$42,$42
  db $42,$42,$42,$42,$42,$42,$42,$42
  db $42,$42,$42,$42,$42,$42,$42,$42
  db $42,$42,$42,$42,$42,$42,$42,$42
  db $42,$42,$42,$42,$42,$42,$42,$42
  db $42,$42,$42,$42,$42,$42,$42,$42

Texture067:
  db $43,$43,$43,$43,$43,$43,$43,$43 // 8x8x8B = 64 Bytes
  db $43,$43,$43,$43,$43,$43,$43,$43
  db $43,$43,$43,$43,$43,$43,$43,$43
  db $43,$43,$43,$43,$43,$43,$43,$43
  db $43,$43,$43,$43,$43,$43,$43,$43
  db $43,$43,$43,$43,$43,$43,$43,$43
  db $43,$43,$43,$43,$43,$43,$43,$43
  db $43,$43,$43,$43,$43,$43,$43,$43

Texture068:
  db $44,$44,$44,$44,$44,$44,$44,$44 // 8x8x8B = 64 Bytes
  db $44,$44,$44,$44,$44,$44,$44,$44
  db $44,$44,$44,$44,$44,$44,$44,$44
  db $44,$44,$44,$44,$44,$44,$44,$44
  db $44,$44,$44,$44,$44,$44,$44,$44
  db $44,$44,$44,$44,$44,$44,$44,$44
  db $44,$44,$44,$44,$44,$44,$44,$44
  db $44,$44,$44,$44,$44,$44,$44,$44

Texture069:
  db $45,$45,$45,$45,$45,$45,$45,$45 // 8x8x8B = 64 Bytes
  db $45,$45,$45,$45,$45,$45,$45,$45
  db $45,$45,$45,$45,$45,$45,$45,$45
  db $45,$45,$45,$45,$45,$45,$45,$45
  db $45,$45,$45,$45,$45,$45,$45,$45
  db $45,$45,$45,$45,$45,$45,$45,$45
  db $45,$45,$45,$45,$45,$45,$45,$45
  db $45,$45,$45,$45,$45,$45,$45,$45

Texture070:
  db $46,$46,$46,$46,$46,$46,$46,$46 // 8x8x8B = 64 Bytes
  db $46,$46,$46,$46,$46,$46,$46,$46
  db $46,$46,$46,$46,$46,$46,$46,$46
  db $46,$46,$46,$46,$46,$46,$46,$46
  db $46,$46,$46,$46,$46,$46,$46,$46
  db $46,$46,$46,$46,$46,$46,$46,$46
  db $46,$46,$46,$46,$46,$46,$46,$46
  db $46,$46,$46,$46,$46,$46,$46,$46

Texture071:
  db $47,$47,$47,$47,$47,$47,$47,$47 // 8x8x8B = 64 Bytes
  db $47,$47,$47,$47,$47,$47,$47,$47
  db $47,$47,$47,$47,$47,$47,$47,$47
  db $47,$47,$47,$47,$47,$47,$47,$47
  db $47,$47,$47,$47,$47,$47,$47,$47
  db $47,$47,$47,$47,$47,$47,$47,$47
  db $47,$47,$47,$47,$47,$47,$47,$47
  db $47,$47,$47,$47,$47,$47,$47,$47

Texture072:
  db $48,$48,$48,$48,$48,$48,$48,$48 // 8x8x8B = 64 Bytes
  db $48,$48,$48,$48,$48,$48,$48,$48
  db $48,$48,$48,$48,$48,$48,$48,$48
  db $48,$48,$48,$48,$48,$48,$48,$48
  db $48,$48,$48,$48,$48,$48,$48,$48
  db $48,$48,$48,$48,$48,$48,$48,$48
  db $48,$48,$48,$48,$48,$48,$48,$48
  db $48,$48,$48,$48,$48,$48,$48,$48

Texture073:
  db $49,$49,$49,$49,$49,$49,$49,$49 // 8x8x8B = 64 Bytes
  db $49,$49,$49,$49,$49,$49,$49,$49
  db $49,$49,$49,$49,$49,$49,$49,$49
  db $49,$49,$49,$49,$49,$49,$49,$49
  db $49,$49,$49,$49,$49,$49,$49,$49
  db $49,$49,$49,$49,$49,$49,$49,$49
  db $49,$49,$49,$49,$49,$49,$49,$49
  db $49,$49,$49,$49,$49,$49,$49,$49

Texture074:
  db $4A,$4A,$4A,$4A,$4A,$4A,$4A,$4A // 8x8x8B = 64 Bytes
  db $4A,$4A,$4A,$4A,$4A,$4A,$4A,$4A
  db $4A,$4A,$4A,$4A,$4A,$4A,$4A,$4A
  db $4A,$4A,$4A,$4A,$4A,$4A,$4A,$4A
  db $4A,$4A,$4A,$4A,$4A,$4A,$4A,$4A
  db $4A,$4A,$4A,$4A,$4A,$4A,$4A,$4A
  db $4A,$4A,$4A,$4A,$4A,$4A,$4A,$4A
  db $4A,$4A,$4A,$4A,$4A,$4A,$4A,$4A

Texture075:
  db $4B,$4B,$4B,$4B,$4B,$4B,$4B,$4B // 8x8x8B = 64 Bytes
  db $4B,$4B,$4B,$4B,$4B,$4B,$4B,$4B
  db $4B,$4B,$4B,$4B,$4B,$4B,$4B,$4B
  db $4B,$4B,$4B,$4B,$4B,$4B,$4B,$4B
  db $4B,$4B,$4B,$4B,$4B,$4B,$4B,$4B
  db $4B,$4B,$4B,$4B,$4B,$4B,$4B,$4B
  db $4B,$4B,$4B,$4B,$4B,$4B,$4B,$4B
  db $4B,$4B,$4B,$4B,$4B,$4B,$4B,$4B

Texture076:
  db $4C,$4C,$4C,$4C,$4C,$4C,$4C,$4C // 8x8x8B = 64 Bytes
  db $4C,$4C,$4C,$4C,$4C,$4C,$4C,$4C
  db $4C,$4C,$4C,$4C,$4C,$4C,$4C,$4C
  db $4C,$4C,$4C,$4C,$4C,$4C,$4C,$4C
  db $4C,$4C,$4C,$4C,$4C,$4C,$4C,$4C
  db $4C,$4C,$4C,$4C,$4C,$4C,$4C,$4C
  db $4C,$4C,$4C,$4C,$4C,$4C,$4C,$4C
  db $4C,$4C,$4C,$4C,$4C,$4C,$4C,$4C

Texture077:
  db $4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D // 8x8x8B = 64 Bytes
  db $4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D
  db $4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D
  db $4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D
  db $4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D
  db $4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D
  db $4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D
  db $4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D

Texture078:
  db $4E,$4E,$4E,$4E,$4E,$4E,$4E,$4E // 8x8x8B = 64 Bytes
  db $4E,$4E,$4E,$4E,$4E,$4E,$4E,$4E
  db $4E,$4E,$4E,$4E,$4E,$4E,$4E,$4E
  db $4E,$4E,$4E,$4E,$4E,$4E,$4E,$4E
  db $4E,$4E,$4E,$4E,$4E,$4E,$4E,$4E
  db $4E,$4E,$4E,$4E,$4E,$4E,$4E,$4E
  db $4E,$4E,$4E,$4E,$4E,$4E,$4E,$4E
  db $4E,$4E,$4E,$4E,$4E,$4E,$4E,$4E

Texture079:
  db $4F,$4F,$4F,$4F,$4F,$4F,$4F,$4F // 8x8x8B = 64 Bytes
  db $4F,$4F,$4F,$4F,$4F,$4F,$4F,$4F
  db $4F,$4F,$4F,$4F,$4F,$4F,$4F,$4F
  db $4F,$4F,$4F,$4F,$4F,$4F,$4F,$4F
  db $4F,$4F,$4F,$4F,$4F,$4F,$4F,$4F
  db $4F,$4F,$4F,$4F,$4F,$4F,$4F,$4F
  db $4F,$4F,$4F,$4F,$4F,$4F,$4F,$4F
  db $4F,$4F,$4F,$4F,$4F,$4F,$4F,$4F

Texture080:
  db $50,$50,$50,$50,$50,$50,$50,$50 // 8x8x8B = 64 Bytes
  db $50,$50,$50,$50,$50,$50,$50,$50
  db $50,$50,$50,$50,$50,$50,$50,$50
  db $50,$50,$50,$50,$50,$50,$50,$50
  db $50,$50,$50,$50,$50,$50,$50,$50
  db $50,$50,$50,$50,$50,$50,$50,$50
  db $50,$50,$50,$50,$50,$50,$50,$50
  db $50,$50,$50,$50,$50,$50,$50,$50

Texture081:
  db $51,$51,$51,$51,$51,$51,$51,$51 // 8x8x8B = 64 Bytes
  db $51,$51,$51,$51,$51,$51,$51,$51
  db $51,$51,$51,$51,$51,$51,$51,$51
  db $51,$51,$51,$51,$51,$51,$51,$51
  db $51,$51,$51,$51,$51,$51,$51,$51
  db $51,$51,$51,$51,$51,$51,$51,$51
  db $51,$51,$51,$51,$51,$51,$51,$51
  db $51,$51,$51,$51,$51,$51,$51,$51

Texture082:
  db $52,$52,$52,$52,$52,$52,$52,$52 // 8x8x8B = 64 Bytes
  db $52,$52,$52,$52,$52,$52,$52,$52
  db $52,$52,$52,$52,$52,$52,$52,$52
  db $52,$52,$52,$52,$52,$52,$52,$52
  db $52,$52,$52,$52,$52,$52,$52,$52
  db $52,$52,$52,$52,$52,$52,$52,$52
  db $52,$52,$52,$52,$52,$52,$52,$52
  db $52,$52,$52,$52,$52,$52,$52,$52

Texture083:
  db $53,$53,$53,$53,$53,$53,$53,$53 // 8x8x8B = 64 Bytes
  db $53,$53,$53,$53,$53,$53,$53,$53
  db $53,$53,$53,$53,$53,$53,$53,$53
  db $53,$53,$53,$53,$53,$53,$53,$53
  db $53,$53,$53,$53,$53,$53,$53,$53
  db $53,$53,$53,$53,$53,$53,$53,$53
  db $53,$53,$53,$53,$53,$53,$53,$53
  db $53,$53,$53,$53,$53,$53,$53,$53

Texture084:
  db $54,$54,$54,$54,$54,$54,$54,$54 // 8x8x8B = 64 Bytes
  db $54,$54,$54,$54,$54,$54,$54,$54
  db $54,$54,$54,$54,$54,$54,$54,$54
  db $54,$54,$54,$54,$54,$54,$54,$54
  db $54,$54,$54,$54,$54,$54,$54,$54
  db $54,$54,$54,$54,$54,$54,$54,$54
  db $54,$54,$54,$54,$54,$54,$54,$54
  db $54,$54,$54,$54,$54,$54,$54,$54

Texture085:
  db $55,$55,$55,$55,$55,$55,$55,$55 // 8x8x8B = 64 Bytes
  db $55,$55,$55,$55,$55,$55,$55,$55
  db $55,$55,$55,$55,$55,$55,$55,$55
  db $55,$55,$55,$55,$55,$55,$55,$55
  db $55,$55,$55,$55,$55,$55,$55,$55
  db $55,$55,$55,$55,$55,$55,$55,$55
  db $55,$55,$55,$55,$55,$55,$55,$55
  db $55,$55,$55,$55,$55,$55,$55,$55

Texture086:
  db $56,$56,$56,$56,$56,$56,$56,$56 // 8x8x8B = 64 Bytes
  db $56,$56,$56,$56,$56,$56,$56,$56
  db $56,$56,$56,$56,$56,$56,$56,$56
  db $56,$56,$56,$56,$56,$56,$56,$56
  db $56,$56,$56,$56,$56,$56,$56,$56
  db $56,$56,$56,$56,$56,$56,$56,$56
  db $56,$56,$56,$56,$56,$56,$56,$56
  db $56,$56,$56,$56,$56,$56,$56,$56

Texture087:
  db $57,$57,$57,$57,$57,$57,$57,$57 // 8x8x8B = 64 Bytes
  db $57,$57,$57,$57,$57,$57,$57,$57
  db $57,$57,$57,$57,$57,$57,$57,$57
  db $57,$57,$57,$57,$57,$57,$57,$57
  db $57,$57,$57,$57,$57,$57,$57,$57
  db $57,$57,$57,$57,$57,$57,$57,$57
  db $57,$57,$57,$57,$57,$57,$57,$57
  db $57,$57,$57,$57,$57,$57,$57,$57

Texture088:
  db $58,$58,$58,$58,$58,$58,$58,$58 // 8x8x8B = 64 Bytes
  db $58,$58,$58,$58,$58,$58,$58,$58
  db $58,$58,$58,$58,$58,$58,$58,$58
  db $58,$58,$58,$58,$58,$58,$58,$58
  db $58,$58,$58,$58,$58,$58,$58,$58
  db $58,$58,$58,$58,$58,$58,$58,$58
  db $58,$58,$58,$58,$58,$58,$58,$58
  db $58,$58,$58,$58,$58,$58,$58,$58

Texture089:
  db $59,$59,$59,$59,$59,$59,$59,$59 // 8x8x8B = 64 Bytes
  db $59,$59,$59,$59,$59,$59,$59,$59
  db $59,$59,$59,$59,$59,$59,$59,$59
  db $59,$59,$59,$59,$59,$59,$59,$59
  db $59,$59,$59,$59,$59,$59,$59,$59
  db $59,$59,$59,$59,$59,$59,$59,$59
  db $59,$59,$59,$59,$59,$59,$59,$59
  db $59,$59,$59,$59,$59,$59,$59,$59

Texture090:
  db $5A,$5A,$5A,$5A,$5A,$5A,$5A,$5A // 8x8x8B = 64 Bytes
  db $5A,$5A,$5A,$5A,$5A,$5A,$5A,$5A
  db $5A,$5A,$5A,$5A,$5A,$5A,$5A,$5A
  db $5A,$5A,$5A,$5A,$5A,$5A,$5A,$5A
  db $5A,$5A,$5A,$5A,$5A,$5A,$5A,$5A
  db $5A,$5A,$5A,$5A,$5A,$5A,$5A,$5A
  db $5A,$5A,$5A,$5A,$5A,$5A,$5A,$5A
  db $5A,$5A,$5A,$5A,$5A,$5A,$5A,$5A

Texture091:
  db $5B,$5B,$5B,$5B,$5B,$5B,$5B,$5B // 8x8x8B = 64 Bytes
  db $5B,$5B,$5B,$5B,$5B,$5B,$5B,$5B
  db $5B,$5B,$5B,$5B,$5B,$5B,$5B,$5B
  db $5B,$5B,$5B,$5B,$5B,$5B,$5B,$5B
  db $5B,$5B,$5B,$5B,$5B,$5B,$5B,$5B
  db $5B,$5B,$5B,$5B,$5B,$5B,$5B,$5B
  db $5B,$5B,$5B,$5B,$5B,$5B,$5B,$5B
  db $5B,$5B,$5B,$5B,$5B,$5B,$5B,$5B

Texture092:
  db $5C,$5C,$5C,$5C,$5C,$5C,$5C,$5C // 8x8x8B = 64 Bytes
  db $5C,$5C,$5C,$5C,$5C,$5C,$5C,$5C
  db $5C,$5C,$5C,$5C,$5C,$5C,$5C,$5C
  db $5C,$5C,$5C,$5C,$5C,$5C,$5C,$5C
  db $5C,$5C,$5C,$5C,$5C,$5C,$5C,$5C
  db $5C,$5C,$5C,$5C,$5C,$5C,$5C,$5C
  db $5C,$5C,$5C,$5C,$5C,$5C,$5C,$5C
  db $5C,$5C,$5C,$5C,$5C,$5C,$5C,$5C

Texture093:
  db $5D,$5D,$5D,$5D,$5D,$5D,$5D,$5D // 8x8x8B = 64 Bytes
  db $5D,$5D,$5D,$5D,$5D,$5D,$5D,$5D
  db $5D,$5D,$5D,$5D,$5D,$5D,$5D,$5D
  db $5D,$5D,$5D,$5D,$5D,$5D,$5D,$5D
  db $5D,$5D,$5D,$5D,$5D,$5D,$5D,$5D
  db $5D,$5D,$5D,$5D,$5D,$5D,$5D,$5D
  db $5D,$5D,$5D,$5D,$5D,$5D,$5D,$5D
  db $5D,$5D,$5D,$5D,$5D,$5D,$5D,$5D

Texture094:
  db $5E,$5E,$5E,$5E,$5E,$5E,$5E,$5E // 8x8x8B = 64 Bytes
  db $5E,$5E,$5E,$5E,$5E,$5E,$5E,$5E
  db $5E,$5E,$5E,$5E,$5E,$5E,$5E,$5E
  db $5E,$5E,$5E,$5E,$5E,$5E,$5E,$5E
  db $5E,$5E,$5E,$5E,$5E,$5E,$5E,$5E
  db $5E,$5E,$5E,$5E,$5E,$5E,$5E,$5E
  db $5E,$5E,$5E,$5E,$5E,$5E,$5E,$5E
  db $5E,$5E,$5E,$5E,$5E,$5E,$5E,$5E

Texture095:
  db $5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F // 8x8x8B = 64 Bytes
  db $5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F
  db $5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F
  db $5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F
  db $5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F
  db $5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F
  db $5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F
  db $5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F

Texture096:
  db $60,$60,$60,$60,$60,$60,$60,$60 // 8x8x8B = 64 Bytes
  db $60,$60,$60,$60,$60,$60,$60,$60
  db $60,$60,$60,$60,$60,$60,$60,$60
  db $60,$60,$60,$60,$60,$60,$60,$60
  db $60,$60,$60,$60,$60,$60,$60,$60
  db $60,$60,$60,$60,$60,$60,$60,$60
  db $60,$60,$60,$60,$60,$60,$60,$60
  db $60,$60,$60,$60,$60,$60,$60,$60

Texture097:
  db $61,$61,$61,$61,$61,$61,$61,$61 // 8x8x8B = 64 Bytes
  db $61,$61,$61,$61,$61,$61,$61,$61
  db $61,$61,$61,$61,$61,$61,$61,$61
  db $61,$61,$61,$61,$61,$61,$61,$61
  db $61,$61,$61,$61,$61,$61,$61,$61
  db $61,$61,$61,$61,$61,$61,$61,$61
  db $61,$61,$61,$61,$61,$61,$61,$61
  db $61,$61,$61,$61,$61,$61,$61,$61

Texture098:
  db $62,$62,$62,$62,$62,$62,$62,$62 // 8x8x8B = 64 Bytes
  db $62,$62,$62,$62,$62,$62,$62,$62
  db $62,$62,$62,$62,$62,$62,$62,$62
  db $62,$62,$62,$62,$62,$62,$62,$62
  db $62,$62,$62,$62,$62,$62,$62,$62
  db $62,$62,$62,$62,$62,$62,$62,$62
  db $62,$62,$62,$62,$62,$62,$62,$62
  db $62,$62,$62,$62,$62,$62,$62,$62

Texture099:
  db $63,$63,$63,$63,$63,$63,$63,$63 // 8x8x8B = 64 Bytes
  db $63,$63,$63,$63,$63,$63,$63,$63
  db $63,$63,$63,$63,$63,$63,$63,$63
  db $63,$63,$63,$63,$63,$63,$63,$63
  db $63,$63,$63,$63,$63,$63,$63,$63
  db $63,$63,$63,$63,$63,$63,$63,$63
  db $63,$63,$63,$63,$63,$63,$63,$63
  db $63,$63,$63,$63,$63,$63,$63,$63

Texture100:
  db $64,$64,$64,$64,$64,$64,$64,$64 // 8x8x8B = 64 Bytes
  db $64,$64,$64,$64,$64,$64,$64,$64
  db $64,$64,$64,$64,$64,$64,$64,$64
  db $64,$64,$64,$64,$64,$64,$64,$64
  db $64,$64,$64,$64,$64,$64,$64,$64
  db $64,$64,$64,$64,$64,$64,$64,$64
  db $64,$64,$64,$64,$64,$64,$64,$64
  db $64,$64,$64,$64,$64,$64,$64,$64

Texture101:
  db $65,$65,$65,$65,$65,$65,$65,$65 // 8x8x8B = 64 Bytes
  db $65,$65,$65,$65,$65,$65,$65,$65
  db $65,$65,$65,$65,$65,$65,$65,$65
  db $65,$65,$65,$65,$65,$65,$65,$65
  db $65,$65,$65,$65,$65,$65,$65,$65
  db $65,$65,$65,$65,$65,$65,$65,$65
  db $65,$65,$65,$65,$65,$65,$65,$65
  db $65,$65,$65,$65,$65,$65,$65,$65

Texture102:
  db $66,$66,$66,$66,$66,$66,$66,$66 // 8x8x8B = 64 Bytes
  db $66,$66,$66,$66,$66,$66,$66,$66
  db $66,$66,$66,$66,$66,$66,$66,$66
  db $66,$66,$66,$66,$66,$66,$66,$66
  db $66,$66,$66,$66,$66,$66,$66,$66
  db $66,$66,$66,$66,$66,$66,$66,$66
  db $66,$66,$66,$66,$66,$66,$66,$66
  db $66,$66,$66,$66,$66,$66,$66,$66

Texture103:
  db $67,$67,$67,$67,$67,$67,$67,$67 // 8x8x8B = 64 Bytes
  db $67,$67,$67,$67,$67,$67,$67,$67
  db $67,$67,$67,$67,$67,$67,$67,$67
  db $67,$67,$67,$67,$67,$67,$67,$67
  db $67,$67,$67,$67,$67,$67,$67,$67
  db $67,$67,$67,$67,$67,$67,$67,$67
  db $67,$67,$67,$67,$67,$67,$67,$67
  db $67,$67,$67,$67,$67,$67,$67,$67

Texture104:
  db $68,$68,$68,$68,$68,$68,$68,$68 // 8x8x8B = 64 Bytes
  db $68,$68,$68,$68,$68,$68,$68,$68
  db $68,$68,$68,$68,$68,$68,$68,$68
  db $68,$68,$68,$68,$68,$68,$68,$68
  db $68,$68,$68,$68,$68,$68,$68,$68
  db $68,$68,$68,$68,$68,$68,$68,$68
  db $68,$68,$68,$68,$68,$68,$68,$68
  db $68,$68,$68,$68,$68,$68,$68,$68

Texture105:
  db $69,$69,$69,$69,$69,$69,$69,$69 // 8x8x8B = 64 Bytes
  db $69,$69,$69,$69,$69,$69,$69,$69
  db $69,$69,$69,$69,$69,$69,$69,$69
  db $69,$69,$69,$69,$69,$69,$69,$69
  db $69,$69,$69,$69,$69,$69,$69,$69
  db $69,$69,$69,$69,$69,$69,$69,$69
  db $69,$69,$69,$69,$69,$69,$69,$69
  db $69,$69,$69,$69,$69,$69,$69,$69

Texture106:
  db $6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A // 8x8x8B = 64 Bytes
  db $6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A
  db $6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A
  db $6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A
  db $6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A
  db $6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A
  db $6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A
  db $6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A

Texture107:
  db $6B,$6B,$6B,$6B,$6B,$6B,$6B,$6B // 8x8x8B = 64 Bytes
  db $6B,$6B,$6B,$6B,$6B,$6B,$6B,$6B
  db $6B,$6B,$6B,$6B,$6B,$6B,$6B,$6B
  db $6B,$6B,$6B,$6B,$6B,$6B,$6B,$6B
  db $6B,$6B,$6B,$6B,$6B,$6B,$6B,$6B
  db $6B,$6B,$6B,$6B,$6B,$6B,$6B,$6B
  db $6B,$6B,$6B,$6B,$6B,$6B,$6B,$6B
  db $6B,$6B,$6B,$6B,$6B,$6B,$6B,$6B

Texture108:
  db $6C,$6C,$6C,$6C,$6C,$6C,$6C,$6C // 8x8x8B = 64 Bytes
  db $6C,$6C,$6C,$6C,$6C,$6C,$6C,$6C
  db $6C,$6C,$6C,$6C,$6C,$6C,$6C,$6C
  db $6C,$6C,$6C,$6C,$6C,$6C,$6C,$6C
  db $6C,$6C,$6C,$6C,$6C,$6C,$6C,$6C
  db $6C,$6C,$6C,$6C,$6C,$6C,$6C,$6C
  db $6C,$6C,$6C,$6C,$6C,$6C,$6C,$6C
  db $6C,$6C,$6C,$6C,$6C,$6C,$6C,$6C

Texture109:
  db $6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D // 8x8x8B = 64 Bytes
  db $6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D
  db $6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D
  db $6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D
  db $6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D
  db $6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D
  db $6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D
  db $6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D

Texture110:
  db $6E,$6E,$6E,$6E,$6E,$6E,$6E,$6E // 8x8x8B = 64 Bytes
  db $6E,$6E,$6E,$6E,$6E,$6E,$6E,$6E
  db $6E,$6E,$6E,$6E,$6E,$6E,$6E,$6E
  db $6E,$6E,$6E,$6E,$6E,$6E,$6E,$6E
  db $6E,$6E,$6E,$6E,$6E,$6E,$6E,$6E
  db $6E,$6E,$6E,$6E,$6E,$6E,$6E,$6E
  db $6E,$6E,$6E,$6E,$6E,$6E,$6E,$6E
  db $6E,$6E,$6E,$6E,$6E,$6E,$6E,$6E

Texture111:
  db $6F,$6F,$6F,$6F,$6F,$6F,$6F,$6F // 8x8x8B = 64 Bytes
  db $6F,$6F,$6F,$6F,$6F,$6F,$6F,$6F
  db $6F,$6F,$6F,$6F,$6F,$6F,$6F,$6F
  db $6F,$6F,$6F,$6F,$6F,$6F,$6F,$6F
  db $6F,$6F,$6F,$6F,$6F,$6F,$6F,$6F
  db $6F,$6F,$6F,$6F,$6F,$6F,$6F,$6F
  db $6F,$6F,$6F,$6F,$6F,$6F,$6F,$6F
  db $6F,$6F,$6F,$6F,$6F,$6F,$6F,$6F

Texture112:
  db $70,$70,$70,$70,$70,$70,$70,$70 // 8x8x8B = 64 Bytes
  db $70,$70,$70,$70,$70,$70,$70,$70
  db $70,$70,$70,$70,$70,$70,$70,$70
  db $70,$70,$70,$70,$70,$70,$70,$70
  db $70,$70,$70,$70,$70,$70,$70,$70
  db $70,$70,$70,$70,$70,$70,$70,$70
  db $70,$70,$70,$70,$70,$70,$70,$70
  db $70,$70,$70,$70,$70,$70,$70,$70

Texture113:
  db $71,$71,$71,$71,$71,$71,$71,$71 // 8x8x8B = 64 Bytes
  db $71,$71,$71,$71,$71,$71,$71,$71
  db $71,$71,$71,$71,$71,$71,$71,$71
  db $71,$71,$71,$71,$71,$71,$71,$71
  db $71,$71,$71,$71,$71,$71,$71,$71
  db $71,$71,$71,$71,$71,$71,$71,$71
  db $71,$71,$71,$71,$71,$71,$71,$71
  db $71,$71,$71,$71,$71,$71,$71,$71

Texture114:
  db $72,$72,$72,$72,$72,$72,$72,$72 // 8x8x8B = 64 Bytes
  db $72,$72,$72,$72,$72,$72,$72,$72
  db $72,$72,$72,$72,$72,$72,$72,$72
  db $72,$72,$72,$72,$72,$72,$72,$72
  db $72,$72,$72,$72,$72,$72,$72,$72
  db $72,$72,$72,$72,$72,$72,$72,$72
  db $72,$72,$72,$72,$72,$72,$72,$72
  db $72,$72,$72,$72,$72,$72,$72,$72

Texture115:
  db $73,$73,$73,$73,$73,$73,$73,$73 // 8x8x8B = 64 Bytes
  db $73,$73,$73,$73,$73,$73,$73,$73
  db $73,$73,$73,$73,$73,$73,$73,$73
  db $73,$73,$73,$73,$73,$73,$73,$73
  db $73,$73,$73,$73,$73,$73,$73,$73
  db $73,$73,$73,$73,$73,$73,$73,$73
  db $73,$73,$73,$73,$73,$73,$73,$73
  db $73,$73,$73,$73,$73,$73,$73,$73

Texture116:
  db $74,$74,$74,$74,$74,$74,$74,$74 // 8x8x8B = 64 Bytes
  db $74,$74,$74,$74,$74,$74,$74,$74
  db $74,$74,$74,$74,$74,$74,$74,$74
  db $74,$74,$74,$74,$74,$74,$74,$74
  db $74,$74,$74,$74,$74,$74,$74,$74
  db $74,$74,$74,$74,$74,$74,$74,$74
  db $74,$74,$74,$74,$74,$74,$74,$74
  db $74,$74,$74,$74,$74,$74,$74,$74

Texture117:
  db $75,$75,$75,$75,$75,$75,$75,$75 // 8x8x8B = 64 Bytes
  db $75,$75,$75,$75,$75,$75,$75,$75
  db $75,$75,$75,$75,$75,$75,$75,$75
  db $75,$75,$75,$75,$75,$75,$75,$75
  db $75,$75,$75,$75,$75,$75,$75,$75
  db $75,$75,$75,$75,$75,$75,$75,$75
  db $75,$75,$75,$75,$75,$75,$75,$75
  db $75,$75,$75,$75,$75,$75,$75,$75

Texture118:
  db $76,$76,$76,$76,$76,$76,$76,$76 // 8x8x8B = 64 Bytes
  db $76,$76,$76,$76,$76,$76,$76,$76
  db $76,$76,$76,$76,$76,$76,$76,$76
  db $76,$76,$76,$76,$76,$76,$76,$76
  db $76,$76,$76,$76,$76,$76,$76,$76
  db $76,$76,$76,$76,$76,$76,$76,$76
  db $76,$76,$76,$76,$76,$76,$76,$76
  db $76,$76,$76,$76,$76,$76,$76,$76

Texture119:
  db $77,$77,$77,$77,$77,$77,$77,$77 // 8x8x8B = 64 Bytes
  db $77,$77,$77,$77,$77,$77,$77,$77
  db $77,$77,$77,$77,$77,$77,$77,$77
  db $77,$77,$77,$77,$77,$77,$77,$77
  db $77,$77,$77,$77,$77,$77,$77,$77
  db $77,$77,$77,$77,$77,$77,$77,$77
  db $77,$77,$77,$77,$77,$77,$77,$77
  db $77,$77,$77,$77,$77,$77,$77,$77

Texture120:
  db $78,$78,$78,$78,$78,$78,$78,$78 // 8x8x8B = 64 Bytes
  db $78,$78,$78,$78,$78,$78,$78,$78
  db $78,$78,$78,$78,$78,$78,$78,$78
  db $78,$78,$78,$78,$78,$78,$78,$78
  db $78,$78,$78,$78,$78,$78,$78,$78
  db $78,$78,$78,$78,$78,$78,$78,$78
  db $78,$78,$78,$78,$78,$78,$78,$78
  db $78,$78,$78,$78,$78,$78,$78,$78

Texture121:
  db $79,$79,$79,$79,$79,$79,$79,$79 // 8x8x8B = 64 Bytes
  db $79,$79,$79,$79,$79,$79,$79,$79
  db $79,$79,$79,$79,$79,$79,$79,$79
  db $79,$79,$79,$79,$79,$79,$79,$79
  db $79,$79,$79,$79,$79,$79,$79,$79
  db $79,$79,$79,$79,$79,$79,$79,$79
  db $79,$79,$79,$79,$79,$79,$79,$79
  db $79,$79,$79,$79,$79,$79,$79,$79

Texture122:
  db $7A,$7A,$7A,$7A,$7A,$7A,$7A,$7A // 8x8x8B = 64 Bytes
  db $7A,$7A,$7A,$7A,$7A,$7A,$7A,$7A
  db $7A,$7A,$7A,$7A,$7A,$7A,$7A,$7A
  db $7A,$7A,$7A,$7A,$7A,$7A,$7A,$7A
  db $7A,$7A,$7A,$7A,$7A,$7A,$7A,$7A
  db $7A,$7A,$7A,$7A,$7A,$7A,$7A,$7A
  db $7A,$7A,$7A,$7A,$7A,$7A,$7A,$7A
  db $7A,$7A,$7A,$7A,$7A,$7A,$7A,$7A

Texture123:
  db $7B,$7B,$7B,$7B,$7B,$7B,$7B,$7B // 8x8x8B = 64 Bytes
  db $7B,$7B,$7B,$7B,$7B,$7B,$7B,$7B
  db $7B,$7B,$7B,$7B,$7B,$7B,$7B,$7B
  db $7B,$7B,$7B,$7B,$7B,$7B,$7B,$7B
  db $7B,$7B,$7B,$7B,$7B,$7B,$7B,$7B
  db $7B,$7B,$7B,$7B,$7B,$7B,$7B,$7B
  db $7B,$7B,$7B,$7B,$7B,$7B,$7B,$7B
  db $7B,$7B,$7B,$7B,$7B,$7B,$7B,$7B

Texture124:
  db $7C,$7C,$7C,$7C,$7C,$7C,$7C,$7C // 8x8x8B = 64 Bytes
  db $7C,$7C,$7C,$7C,$7C,$7C,$7C,$7C
  db $7C,$7C,$7C,$7C,$7C,$7C,$7C,$7C
  db $7C,$7C,$7C,$7C,$7C,$7C,$7C,$7C
  db $7C,$7C,$7C,$7C,$7C,$7C,$7C,$7C
  db $7C,$7C,$7C,$7C,$7C,$7C,$7C,$7C
  db $7C,$7C,$7C,$7C,$7C,$7C,$7C,$7C
  db $7C,$7C,$7C,$7C,$7C,$7C,$7C,$7C

Texture125:
  db $7D,$7D,$7D,$7D,$7D,$7D,$7D,$7D // 8x8x8B = 64 Bytes
  db $7D,$7D,$7D,$7D,$7D,$7D,$7D,$7D
  db $7D,$7D,$7D,$7D,$7D,$7D,$7D,$7D
  db $7D,$7D,$7D,$7D,$7D,$7D,$7D,$7D
  db $7D,$7D,$7D,$7D,$7D,$7D,$7D,$7D
  db $7D,$7D,$7D,$7D,$7D,$7D,$7D,$7D
  db $7D,$7D,$7D,$7D,$7D,$7D,$7D,$7D
  db $7D,$7D,$7D,$7D,$7D,$7D,$7D,$7D

Texture126:
  db $7E,$7E,$7E,$7E,$7E,$7E,$7E,$7E // 8x8x8B = 64 Bytes
  db $7E,$7E,$7E,$7E,$7E,$7E,$7E,$7E
  db $7E,$7E,$7E,$7E,$7E,$7E,$7E,$7E
  db $7E,$7E,$7E,$7E,$7E,$7E,$7E,$7E
  db $7E,$7E,$7E,$7E,$7E,$7E,$7E,$7E
  db $7E,$7E,$7E,$7E,$7E,$7E,$7E,$7E
  db $7E,$7E,$7E,$7E,$7E,$7E,$7E,$7E
  db $7E,$7E,$7E,$7E,$7E,$7E,$7E,$7E

Texture127:
  db $7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F // 8x8x8B = 64 Bytes
  db $7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F
  db $7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F
  db $7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F
  db $7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F
  db $7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F
  db $7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F
  db $7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F

Texture128:
  db $80,$80,$80,$80,$80,$80,$80,$80 // 8x8x8B = 64 Bytes
  db $80,$80,$80,$80,$80,$80,$80,$80
  db $80,$80,$80,$80,$80,$80,$80,$80
  db $80,$80,$80,$80,$80,$80,$80,$80
  db $80,$80,$80,$80,$80,$80,$80,$80
  db $80,$80,$80,$80,$80,$80,$80,$80
  db $80,$80,$80,$80,$80,$80,$80,$80
  db $80,$80,$80,$80,$80,$80,$80,$80

Texture129:
  db $81,$81,$81,$81,$81,$81,$81,$81 // 8x8x8B = 64 Bytes
  db $81,$81,$81,$81,$81,$81,$81,$81
  db $81,$81,$81,$81,$81,$81,$81,$81
  db $81,$81,$81,$81,$81,$81,$81,$81
  db $81,$81,$81,$81,$81,$81,$81,$81
  db $81,$81,$81,$81,$81,$81,$81,$81
  db $81,$81,$81,$81,$81,$81,$81,$81
  db $81,$81,$81,$81,$81,$81,$81,$81

Texture130:
  db $82,$82,$82,$82,$82,$82,$82,$82 // 8x8x8B = 64 Bytes
  db $82,$82,$82,$82,$82,$82,$82,$82
  db $82,$82,$82,$82,$82,$82,$82,$82
  db $82,$82,$82,$82,$82,$82,$82,$82
  db $82,$82,$82,$82,$82,$82,$82,$82
  db $82,$82,$82,$82,$82,$82,$82,$82
  db $82,$82,$82,$82,$82,$82,$82,$82
  db $82,$82,$82,$82,$82,$82,$82,$82

Texture131:
  db $83,$83,$83,$83,$83,$83,$83,$83 // 8x8x8B = 64 Bytes
  db $83,$83,$83,$83,$83,$83,$83,$83
  db $83,$83,$83,$83,$83,$83,$83,$83
  db $83,$83,$83,$83,$83,$83,$83,$83
  db $83,$83,$83,$83,$83,$83,$83,$83
  db $83,$83,$83,$83,$83,$83,$83,$83
  db $83,$83,$83,$83,$83,$83,$83,$83
  db $83,$83,$83,$83,$83,$83,$83,$83

Texture132:
  db $84,$84,$84,$84,$84,$84,$84,$84 // 8x8x8B = 64 Bytes
  db $84,$84,$84,$84,$84,$84,$84,$84
  db $84,$84,$84,$84,$84,$84,$84,$84
  db $84,$84,$84,$84,$84,$84,$84,$84
  db $84,$84,$84,$84,$84,$84,$84,$84
  db $84,$84,$84,$84,$84,$84,$84,$84
  db $84,$84,$84,$84,$84,$84,$84,$84
  db $84,$84,$84,$84,$84,$84,$84,$84

Texture133:
  db $85,$85,$85,$85,$85,$85,$85,$85 // 8x8x8B = 64 Bytes
  db $85,$85,$85,$85,$85,$85,$85,$85
  db $85,$85,$85,$85,$85,$85,$85,$85
  db $85,$85,$85,$85,$85,$85,$85,$85
  db $85,$85,$85,$85,$85,$85,$85,$85
  db $85,$85,$85,$85,$85,$85,$85,$85
  db $85,$85,$85,$85,$85,$85,$85,$85
  db $85,$85,$85,$85,$85,$85,$85,$85

Texture134:
  db $86,$86,$86,$86,$86,$86,$86,$86 // 8x8x8B = 64 Bytes
  db $86,$86,$86,$86,$86,$86,$86,$86
  db $86,$86,$86,$86,$86,$86,$86,$86
  db $86,$86,$86,$86,$86,$86,$86,$86
  db $86,$86,$86,$86,$86,$86,$86,$86
  db $86,$86,$86,$86,$86,$86,$86,$86
  db $86,$86,$86,$86,$86,$86,$86,$86
  db $86,$86,$86,$86,$86,$86,$86,$86

Texture135:
  db $87,$87,$87,$87,$87,$87,$87,$87 // 8x8x8B = 64 Bytes
  db $87,$87,$87,$87,$87,$87,$87,$87
  db $87,$87,$87,$87,$87,$87,$87,$87
  db $87,$87,$87,$87,$87,$87,$87,$87
  db $87,$87,$87,$87,$87,$87,$87,$87
  db $87,$87,$87,$87,$87,$87,$87,$87
  db $87,$87,$87,$87,$87,$87,$87,$87
  db $87,$87,$87,$87,$87,$87,$87,$87

Texture136:
  db $88,$88,$88,$88,$88,$88,$88,$88 // 8x8x8B = 64 Bytes
  db $88,$88,$88,$88,$88,$88,$88,$88
  db $88,$88,$88,$88,$88,$88,$88,$88
  db $88,$88,$88,$88,$88,$88,$88,$88
  db $88,$88,$88,$88,$88,$88,$88,$88
  db $88,$88,$88,$88,$88,$88,$88,$88
  db $88,$88,$88,$88,$88,$88,$88,$88
  db $88,$88,$88,$88,$88,$88,$88,$88

Texture137:
  db $89,$89,$89,$89,$89,$89,$89,$89 // 8x8x8B = 64 Bytes
  db $89,$89,$89,$89,$89,$89,$89,$89
  db $89,$89,$89,$89,$89,$89,$89,$89
  db $89,$89,$89,$89,$89,$89,$89,$89
  db $89,$89,$89,$89,$89,$89,$89,$89
  db $89,$89,$89,$89,$89,$89,$89,$89
  db $89,$89,$89,$89,$89,$89,$89,$89
  db $89,$89,$89,$89,$89,$89,$89,$89

Texture138:
  db $8A,$8A,$8A,$8A,$8A,$8A,$8A,$8A // 8x8x8B = 64 Bytes
  db $8A,$8A,$8A,$8A,$8A,$8A,$8A,$8A
  db $8A,$8A,$8A,$8A,$8A,$8A,$8A,$8A
  db $8A,$8A,$8A,$8A,$8A,$8A,$8A,$8A
  db $8A,$8A,$8A,$8A,$8A,$8A,$8A,$8A
  db $8A,$8A,$8A,$8A,$8A,$8A,$8A,$8A
  db $8A,$8A,$8A,$8A,$8A,$8A,$8A,$8A
  db $8A,$8A,$8A,$8A,$8A,$8A,$8A,$8A

Texture139:
  db $8B,$8B,$8B,$8B,$8B,$8B,$8B,$8B // 8x8x8B = 64 Bytes
  db $8B,$8B,$8B,$8B,$8B,$8B,$8B,$8B
  db $8B,$8B,$8B,$8B,$8B,$8B,$8B,$8B
  db $8B,$8B,$8B,$8B,$8B,$8B,$8B,$8B
  db $8B,$8B,$8B,$8B,$8B,$8B,$8B,$8B
  db $8B,$8B,$8B,$8B,$8B,$8B,$8B,$8B
  db $8B,$8B,$8B,$8B,$8B,$8B,$8B,$8B
  db $8B,$8B,$8B,$8B,$8B,$8B,$8B,$8B

Texture140:
  db $8C,$8C,$8C,$8C,$8C,$8C,$8C,$8C // 8x8x8B = 64 Bytes
  db $8C,$8C,$8C,$8C,$8C,$8C,$8C,$8C
  db $8C,$8C,$8C,$8C,$8C,$8C,$8C,$8C
  db $8C,$8C,$8C,$8C,$8C,$8C,$8C,$8C
  db $8C,$8C,$8C,$8C,$8C,$8C,$8C,$8C
  db $8C,$8C,$8C,$8C,$8C,$8C,$8C,$8C
  db $8C,$8C,$8C,$8C,$8C,$8C,$8C,$8C
  db $8C,$8C,$8C,$8C,$8C,$8C,$8C,$8C

Texture141:
  db $8D,$8D,$8D,$8D,$8D,$8D,$8D,$8D // 8x8x8B = 64 Bytes
  db $8D,$8D,$8D,$8D,$8D,$8D,$8D,$8D
  db $8D,$8D,$8D,$8D,$8D,$8D,$8D,$8D
  db $8D,$8D,$8D,$8D,$8D,$8D,$8D,$8D
  db $8D,$8D,$8D,$8D,$8D,$8D,$8D,$8D
  db $8D,$8D,$8D,$8D,$8D,$8D,$8D,$8D
  db $8D,$8D,$8D,$8D,$8D,$8D,$8D,$8D
  db $8D,$8D,$8D,$8D,$8D,$8D,$8D,$8D

Texture142:
  db $8E,$8E,$8E,$8E,$8E,$8E,$8E,$8E // 8x8x8B = 64 Bytes
  db $8E,$8E,$8E,$8E,$8E,$8E,$8E,$8E
  db $8E,$8E,$8E,$8E,$8E,$8E,$8E,$8E
  db $8E,$8E,$8E,$8E,$8E,$8E,$8E,$8E
  db $8E,$8E,$8E,$8E,$8E,$8E,$8E,$8E
  db $8E,$8E,$8E,$8E,$8E,$8E,$8E,$8E
  db $8E,$8E,$8E,$8E,$8E,$8E,$8E,$8E
  db $8E,$8E,$8E,$8E,$8E,$8E,$8E,$8E

Texture143:
  db $8F,$8F,$8F,$8F,$8F,$8F,$8F,$8F // 8x8x8B = 64 Bytes
  db $8F,$8F,$8F,$8F,$8F,$8F,$8F,$8F
  db $8F,$8F,$8F,$8F,$8F,$8F,$8F,$8F
  db $8F,$8F,$8F,$8F,$8F,$8F,$8F,$8F
  db $8F,$8F,$8F,$8F,$8F,$8F,$8F,$8F
  db $8F,$8F,$8F,$8F,$8F,$8F,$8F,$8F
  db $8F,$8F,$8F,$8F,$8F,$8F,$8F,$8F
  db $8F,$8F,$8F,$8F,$8F,$8F,$8F,$8F

Texture144:
  db $90,$90,$90,$90,$90,$90,$90,$90 // 8x8x8B = 64 Bytes
  db $90,$90,$90,$90,$90,$90,$90,$90
  db $90,$90,$90,$90,$90,$90,$90,$90
  db $90,$90,$90,$90,$90,$90,$90,$90
  db $90,$90,$90,$90,$90,$90,$90,$90
  db $90,$90,$90,$90,$90,$90,$90,$90
  db $90,$90,$90,$90,$90,$90,$90,$90
  db $90,$90,$90,$90,$90,$90,$90,$90

Texture145:
  db $91,$91,$91,$91,$91,$91,$91,$91 // 8x8x8B = 64 Bytes
  db $91,$91,$91,$91,$91,$91,$91,$91
  db $91,$91,$91,$91,$91,$91,$91,$91
  db $91,$91,$91,$91,$91,$91,$91,$91
  db $91,$91,$91,$91,$91,$91,$91,$91
  db $91,$91,$91,$91,$91,$91,$91,$91
  db $91,$91,$91,$91,$91,$91,$91,$91
  db $91,$91,$91,$91,$91,$91,$91,$91

Texture146:
  db $92,$92,$92,$92,$92,$92,$92,$92 // 8x8x8B = 64 Bytes
  db $92,$92,$92,$92,$92,$92,$92,$92
  db $92,$92,$92,$92,$92,$92,$92,$92
  db $92,$92,$92,$92,$92,$92,$92,$92
  db $92,$92,$92,$92,$92,$92,$92,$92
  db $92,$92,$92,$92,$92,$92,$92,$92
  db $92,$92,$92,$92,$92,$92,$92,$92
  db $92,$92,$92,$92,$92,$92,$92,$92

Texture147:
  db $93,$93,$93,$93,$93,$93,$93,$93 // 8x8x8B = 64 Bytes
  db $93,$93,$93,$93,$93,$93,$93,$93
  db $93,$93,$93,$93,$93,$93,$93,$93
  db $93,$93,$93,$93,$93,$93,$93,$93
  db $93,$93,$93,$93,$93,$93,$93,$93
  db $93,$93,$93,$93,$93,$93,$93,$93
  db $93,$93,$93,$93,$93,$93,$93,$93
  db $93,$93,$93,$93,$93,$93,$93,$93

Texture148:
  db $94,$94,$94,$94,$94,$94,$94,$94 // 8x8x8B = 64 Bytes
  db $94,$94,$94,$94,$94,$94,$94,$94
  db $94,$94,$94,$94,$94,$94,$94,$94
  db $94,$94,$94,$94,$94,$94,$94,$94
  db $94,$94,$94,$94,$94,$94,$94,$94
  db $94,$94,$94,$94,$94,$94,$94,$94
  db $94,$94,$94,$94,$94,$94,$94,$94
  db $94,$94,$94,$94,$94,$94,$94,$94

Texture149:
  db $95,$95,$95,$95,$95,$95,$95,$95 // 8x8x8B = 64 Bytes
  db $95,$95,$95,$95,$95,$95,$95,$95
  db $95,$95,$95,$95,$95,$95,$95,$95
  db $95,$95,$95,$95,$95,$95,$95,$95
  db $95,$95,$95,$95,$95,$95,$95,$95
  db $95,$95,$95,$95,$95,$95,$95,$95
  db $95,$95,$95,$95,$95,$95,$95,$95
  db $95,$95,$95,$95,$95,$95,$95,$95

Texture150:
  db $96,$96,$96,$96,$96,$96,$96,$96 // 8x8x8B = 64 Bytes
  db $96,$96,$96,$96,$96,$96,$96,$96
  db $96,$96,$96,$96,$96,$96,$96,$96
  db $96,$96,$96,$96,$96,$96,$96,$96
  db $96,$96,$96,$96,$96,$96,$96,$96
  db $96,$96,$96,$96,$96,$96,$96,$96
  db $96,$96,$96,$96,$96,$96,$96,$96
  db $96,$96,$96,$96,$96,$96,$96,$96

Texture151:
  db $97,$97,$97,$97,$97,$97,$97,$97 // 8x8x8B = 64 Bytes
  db $97,$97,$97,$97,$97,$97,$97,$97
  db $97,$97,$97,$97,$97,$97,$97,$97
  db $97,$97,$97,$97,$97,$97,$97,$97
  db $97,$97,$97,$97,$97,$97,$97,$97
  db $97,$97,$97,$97,$97,$97,$97,$97
  db $97,$97,$97,$97,$97,$97,$97,$97
  db $97,$97,$97,$97,$97,$97,$97,$97

Texture152:
  db $98,$98,$98,$98,$98,$98,$98,$98 // 8x8x8B = 64 Bytes
  db $98,$98,$98,$98,$98,$98,$98,$98
  db $98,$98,$98,$98,$98,$98,$98,$98
  db $98,$98,$98,$98,$98,$98,$98,$98
  db $98,$98,$98,$98,$98,$98,$98,$98
  db $98,$98,$98,$98,$98,$98,$98,$98
  db $98,$98,$98,$98,$98,$98,$98,$98
  db $98,$98,$98,$98,$98,$98,$98,$98

Texture153:
  db $99,$99,$99,$99,$99,$99,$99,$99 // 8x8x8B = 64 Bytes
  db $99,$99,$99,$99,$99,$99,$99,$99
  db $99,$99,$99,$99,$99,$99,$99,$99
  db $99,$99,$99,$99,$99,$99,$99,$99
  db $99,$99,$99,$99,$99,$99,$99,$99
  db $99,$99,$99,$99,$99,$99,$99,$99
  db $99,$99,$99,$99,$99,$99,$99,$99
  db $99,$99,$99,$99,$99,$99,$99,$99

Texture154:
  db $9A,$9A,$9A,$9A,$9A,$9A,$9A,$9A // 8x8x8B = 64 Bytes
  db $9A,$9A,$9A,$9A,$9A,$9A,$9A,$9A
  db $9A,$9A,$9A,$9A,$9A,$9A,$9A,$9A
  db $9A,$9A,$9A,$9A,$9A,$9A,$9A,$9A
  db $9A,$9A,$9A,$9A,$9A,$9A,$9A,$9A
  db $9A,$9A,$9A,$9A,$9A,$9A,$9A,$9A
  db $9A,$9A,$9A,$9A,$9A,$9A,$9A,$9A
  db $9A,$9A,$9A,$9A,$9A,$9A,$9A,$9A

Texture155:
  db $9B,$9B,$9B,$9B,$9B,$9B,$9B,$9B // 8x8x8B = 64 Bytes
  db $9B,$9B,$9B,$9B,$9B,$9B,$9B,$9B
  db $9B,$9B,$9B,$9B,$9B,$9B,$9B,$9B
  db $9B,$9B,$9B,$9B,$9B,$9B,$9B,$9B
  db $9B,$9B,$9B,$9B,$9B,$9B,$9B,$9B
  db $9B,$9B,$9B,$9B,$9B,$9B,$9B,$9B
  db $9B,$9B,$9B,$9B,$9B,$9B,$9B,$9B
  db $9B,$9B,$9B,$9B,$9B,$9B,$9B,$9B

Texture156:
  db $9C,$9C,$9C,$9C,$9C,$9C,$9C,$9C // 8x8x8B = 64 Bytes
  db $9C,$9C,$9C,$9C,$9C,$9C,$9C,$9C
  db $9C,$9C,$9C,$9C,$9C,$9C,$9C,$9C
  db $9C,$9C,$9C,$9C,$9C,$9C,$9C,$9C
  db $9C,$9C,$9C,$9C,$9C,$9C,$9C,$9C
  db $9C,$9C,$9C,$9C,$9C,$9C,$9C,$9C
  db $9C,$9C,$9C,$9C,$9C,$9C,$9C,$9C
  db $9C,$9C,$9C,$9C,$9C,$9C,$9C,$9C

Texture157:
  db $9D,$9D,$9D,$9D,$9D,$9D,$9D,$9D // 8x8x8B = 64 Bytes
  db $9D,$9D,$9D,$9D,$9D,$9D,$9D,$9D
  db $9D,$9D,$9D,$9D,$9D,$9D,$9D,$9D
  db $9D,$9D,$9D,$9D,$9D,$9D,$9D,$9D
  db $9D,$9D,$9D,$9D,$9D,$9D,$9D,$9D
  db $9D,$9D,$9D,$9D,$9D,$9D,$9D,$9D
  db $9D,$9D,$9D,$9D,$9D,$9D,$9D,$9D
  db $9D,$9D,$9D,$9D,$9D,$9D,$9D,$9D

Texture158:
  db $9E,$9E,$9E,$9E,$9E,$9E,$9E,$9E // 8x8x8B = 64 Bytes
  db $9E,$9E,$9E,$9E,$9E,$9E,$9E,$9E
  db $9E,$9E,$9E,$9E,$9E,$9E,$9E,$9E
  db $9E,$9E,$9E,$9E,$9E,$9E,$9E,$9E
  db $9E,$9E,$9E,$9E,$9E,$9E,$9E,$9E
  db $9E,$9E,$9E,$9E,$9E,$9E,$9E,$9E
  db $9E,$9E,$9E,$9E,$9E,$9E,$9E,$9E
  db $9E,$9E,$9E,$9E,$9E,$9E,$9E,$9E

Texture159:
  db $9F,$9F,$9F,$9F,$9F,$9F,$9F,$9F // 8x8x8B = 64 Bytes
  db $9F,$9F,$9F,$9F,$9F,$9F,$9F,$9F
  db $9F,$9F,$9F,$9F,$9F,$9F,$9F,$9F
  db $9F,$9F,$9F,$9F,$9F,$9F,$9F,$9F
  db $9F,$9F,$9F,$9F,$9F,$9F,$9F,$9F
  db $9F,$9F,$9F,$9F,$9F,$9F,$9F,$9F
  db $9F,$9F,$9F,$9F,$9F,$9F,$9F,$9F
  db $9F,$9F,$9F,$9F,$9F,$9F,$9F,$9F

Texture160:
  db $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0 // 8x8x8B = 64 Bytes
  db $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
  db $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
  db $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
  db $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
  db $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
  db $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
  db $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0

Texture161:
  db $A1,$A1,$A1,$A1,$A1,$A1,$A1,$A1 // 8x8x8B = 64 Bytes
  db $A1,$A1,$A1,$A1,$A1,$A1,$A1,$A1
  db $A1,$A1,$A1,$A1,$A1,$A1,$A1,$A1
  db $A1,$A1,$A1,$A1,$A1,$A1,$A1,$A1
  db $A1,$A1,$A1,$A1,$A1,$A1,$A1,$A1
  db $A1,$A1,$A1,$A1,$A1,$A1,$A1,$A1
  db $A1,$A1,$A1,$A1,$A1,$A1,$A1,$A1
  db $A1,$A1,$A1,$A1,$A1,$A1,$A1,$A1

Texture162:
  db $A2,$A2,$A2,$A2,$A2,$A2,$A2,$A2 // 8x8x8B = 64 Bytes
  db $A2,$A2,$A2,$A2,$A2,$A2,$A2,$A2
  db $A2,$A2,$A2,$A2,$A2,$A2,$A2,$A2
  db $A2,$A2,$A2,$A2,$A2,$A2,$A2,$A2
  db $A2,$A2,$A2,$A2,$A2,$A2,$A2,$A2
  db $A2,$A2,$A2,$A2,$A2,$A2,$A2,$A2
  db $A2,$A2,$A2,$A2,$A2,$A2,$A2,$A2
  db $A2,$A2,$A2,$A2,$A2,$A2,$A2,$A2

Texture163:
  db $A3,$A3,$A3,$A3,$A3,$A3,$A3,$A3 // 8x8x8B = 64 Bytes
  db $A3,$A3,$A3,$A3,$A3,$A3,$A3,$A3
  db $A3,$A3,$A3,$A3,$A3,$A3,$A3,$A3
  db $A3,$A3,$A3,$A3,$A3,$A3,$A3,$A3
  db $A3,$A3,$A3,$A3,$A3,$A3,$A3,$A3
  db $A3,$A3,$A3,$A3,$A3,$A3,$A3,$A3
  db $A3,$A3,$A3,$A3,$A3,$A3,$A3,$A3
  db $A3,$A3,$A3,$A3,$A3,$A3,$A3,$A3

Texture164:
  db $A4,$A4,$A4,$A4,$A4,$A4,$A4,$A4 // 8x8x8B = 64 Bytes
  db $A4,$A4,$A4,$A4,$A4,$A4,$A4,$A4
  db $A4,$A4,$A4,$A4,$A4,$A4,$A4,$A4
  db $A4,$A4,$A4,$A4,$A4,$A4,$A4,$A4
  db $A4,$A4,$A4,$A4,$A4,$A4,$A4,$A4
  db $A4,$A4,$A4,$A4,$A4,$A4,$A4,$A4
  db $A4,$A4,$A4,$A4,$A4,$A4,$A4,$A4
  db $A4,$A4,$A4,$A4,$A4,$A4,$A4,$A4

Texture165:
  db $A5,$A5,$A5,$A5,$A5,$A5,$A5,$A5 // 8x8x8B = 64 Bytes
  db $A5,$A5,$A5,$A5,$A5,$A5,$A5,$A5
  db $A5,$A5,$A5,$A5,$A5,$A5,$A5,$A5
  db $A5,$A5,$A5,$A5,$A5,$A5,$A5,$A5
  db $A5,$A5,$A5,$A5,$A5,$A5,$A5,$A5
  db $A5,$A5,$A5,$A5,$A5,$A5,$A5,$A5
  db $A5,$A5,$A5,$A5,$A5,$A5,$A5,$A5
  db $A5,$A5,$A5,$A5,$A5,$A5,$A5,$A5

Texture166:
  db $A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6 // 8x8x8B = 64 Bytes
  db $A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6
  db $A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6
  db $A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6
  db $A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6
  db $A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6
  db $A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6
  db $A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6

Texture167:
  db $A7,$A7,$A7,$A7,$A7,$A7,$A7,$A7 // 8x8x8B = 64 Bytes
  db $A7,$A7,$A7,$A7,$A7,$A7,$A7,$A7
  db $A7,$A7,$A7,$A7,$A7,$A7,$A7,$A7
  db $A7,$A7,$A7,$A7,$A7,$A7,$A7,$A7
  db $A7,$A7,$A7,$A7,$A7,$A7,$A7,$A7
  db $A7,$A7,$A7,$A7,$A7,$A7,$A7,$A7
  db $A7,$A7,$A7,$A7,$A7,$A7,$A7,$A7
  db $A7,$A7,$A7,$A7,$A7,$A7,$A7,$A7

Texture168:
  db $A8,$A8,$A8,$A8,$A8,$A8,$A8,$A8 // 8x8x8B = 64 Bytes
  db $A8,$A8,$A8,$A8,$A8,$A8,$A8,$A8
  db $A8,$A8,$A8,$A8,$A8,$A8,$A8,$A8
  db $A8,$A8,$A8,$A8,$A8,$A8,$A8,$A8
  db $A8,$A8,$A8,$A8,$A8,$A8,$A8,$A8
  db $A8,$A8,$A8,$A8,$A8,$A8,$A8,$A8
  db $A8,$A8,$A8,$A8,$A8,$A8,$A8,$A8
  db $A8,$A8,$A8,$A8,$A8,$A8,$A8,$A8

Texture169:
  db $A9,$A9,$A9,$A9,$A9,$A9,$A9,$A9 // 8x8x8B = 64 Bytes
  db $A9,$A9,$A9,$A9,$A9,$A9,$A9,$A9
  db $A9,$A9,$A9,$A9,$A9,$A9,$A9,$A9
  db $A9,$A9,$A9,$A9,$A9,$A9,$A9,$A9
  db $A9,$A9,$A9,$A9,$A9,$A9,$A9,$A9
  db $A9,$A9,$A9,$A9,$A9,$A9,$A9,$A9
  db $A9,$A9,$A9,$A9,$A9,$A9,$A9,$A9
  db $A9,$A9,$A9,$A9,$A9,$A9,$A9,$A9

Texture170:
  db $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA // 8x8x8B = 64 Bytes
  db $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
  db $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
  db $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
  db $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
  db $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
  db $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
  db $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA

Texture171:
  db $AB,$AB,$AB,$AB,$AB,$AB,$AB,$AB // 8x8x8B = 64 Bytes
  db $AB,$AB,$AB,$AB,$AB,$AB,$AB,$AB
  db $AB,$AB,$AB,$AB,$AB,$AB,$AB,$AB
  db $AB,$AB,$AB,$AB,$AB,$AB,$AB,$AB
  db $AB,$AB,$AB,$AB,$AB,$AB,$AB,$AB
  db $AB,$AB,$AB,$AB,$AB,$AB,$AB,$AB
  db $AB,$AB,$AB,$AB,$AB,$AB,$AB,$AB
  db $AB,$AB,$AB,$AB,$AB,$AB,$AB,$AB

Texture172:
  db $AC,$AC,$AC,$AC,$AC,$AC,$AC,$AC // 8x8x8B = 64 Bytes
  db $AC,$AC,$AC,$AC,$AC,$AC,$AC,$AC
  db $AC,$AC,$AC,$AC,$AC,$AC,$AC,$AC
  db $AC,$AC,$AC,$AC,$AC,$AC,$AC,$AC
  db $AC,$AC,$AC,$AC,$AC,$AC,$AC,$AC
  db $AC,$AC,$AC,$AC,$AC,$AC,$AC,$AC
  db $AC,$AC,$AC,$AC,$AC,$AC,$AC,$AC
  db $AC,$AC,$AC,$AC,$AC,$AC,$AC,$AC

Texture173:
  db $AD,$AD,$AD,$AD,$AD,$AD,$AD,$AD // 8x8x8B = 64 Bytes
  db $AD,$AD,$AD,$AD,$AD,$AD,$AD,$AD
  db $AD,$AD,$AD,$AD,$AD,$AD,$AD,$AD
  db $AD,$AD,$AD,$AD,$AD,$AD,$AD,$AD
  db $AD,$AD,$AD,$AD,$AD,$AD,$AD,$AD
  db $AD,$AD,$AD,$AD,$AD,$AD,$AD,$AD
  db $AD,$AD,$AD,$AD,$AD,$AD,$AD,$AD
  db $AD,$AD,$AD,$AD,$AD,$AD,$AD,$AD

Texture174:
  db $AE,$AE,$AE,$AE,$AE,$AE,$AE,$AE // 8x8x8B = 64 Bytes
  db $AE,$AE,$AE,$AE,$AE,$AE,$AE,$AE
  db $AE,$AE,$AE,$AE,$AE,$AE,$AE,$AE
  db $AE,$AE,$AE,$AE,$AE,$AE,$AE,$AE
  db $AE,$AE,$AE,$AE,$AE,$AE,$AE,$AE
  db $AE,$AE,$AE,$AE,$AE,$AE,$AE,$AE
  db $AE,$AE,$AE,$AE,$AE,$AE,$AE,$AE
  db $AE,$AE,$AE,$AE,$AE,$AE,$AE,$AE

Texture175:
  db $AF,$AF,$AF,$AF,$AF,$AF,$AF,$AF // 8x8x8B = 64 Bytes
  db $AF,$AF,$AF,$AF,$AF,$AF,$AF,$AF
  db $AF,$AF,$AF,$AF,$AF,$AF,$AF,$AF
  db $AF,$AF,$AF,$AF,$AF,$AF,$AF,$AF
  db $AF,$AF,$AF,$AF,$AF,$AF,$AF,$AF
  db $AF,$AF,$AF,$AF,$AF,$AF,$AF,$AF
  db $AF,$AF,$AF,$AF,$AF,$AF,$AF,$AF
  db $AF,$AF,$AF,$AF,$AF,$AF,$AF,$AF

Texture176:
  db $B0,$B0,$B0,$B0,$B0,$B0,$B0,$B0 // 8x8x8B = 64 Bytes
  db $B0,$B0,$B0,$B0,$B0,$B0,$B0,$B0
  db $B0,$B0,$B0,$B0,$B0,$B0,$B0,$B0
  db $B0,$B0,$B0,$B0,$B0,$B0,$B0,$B0
  db $B0,$B0,$B0,$B0,$B0,$B0,$B0,$B0
  db $B0,$B0,$B0,$B0,$B0,$B0,$B0,$B0
  db $B0,$B0,$B0,$B0,$B0,$B0,$B0,$B0
  db $B0,$B0,$B0,$B0,$B0,$B0,$B0,$B0

Texture177:
  db $B1,$B1,$B1,$B1,$B1,$B1,$B1,$B1 // 8x8x8B = 64 Bytes
  db $B1,$B1,$B1,$B1,$B1,$B1,$B1,$B1
  db $B1,$B1,$B1,$B1,$B1,$B1,$B1,$B1
  db $B1,$B1,$B1,$B1,$B1,$B1,$B1,$B1
  db $B1,$B1,$B1,$B1,$B1,$B1,$B1,$B1
  db $B1,$B1,$B1,$B1,$B1,$B1,$B1,$B1
  db $B1,$B1,$B1,$B1,$B1,$B1,$B1,$B1
  db $B1,$B1,$B1,$B1,$B1,$B1,$B1,$B1

Texture178:
  db $B2,$B2,$B2,$B2,$B2,$B2,$B2,$B2 // 8x8x8B = 64 Bytes
  db $B2,$B2,$B2,$B2,$B2,$B2,$B2,$B2
  db $B2,$B2,$B2,$B2,$B2,$B2,$B2,$B2
  db $B2,$B2,$B2,$B2,$B2,$B2,$B2,$B2
  db $B2,$B2,$B2,$B2,$B2,$B2,$B2,$B2
  db $B2,$B2,$B2,$B2,$B2,$B2,$B2,$B2
  db $B2,$B2,$B2,$B2,$B2,$B2,$B2,$B2
  db $B2,$B2,$B2,$B2,$B2,$B2,$B2,$B2

Texture179:
  db $B3,$B3,$B3,$B3,$B3,$B3,$B3,$B3 // 8x8x8B = 64 Bytes
  db $B3,$B3,$B3,$B3,$B3,$B3,$B3,$B3
  db $B3,$B3,$B3,$B3,$B3,$B3,$B3,$B3
  db $B3,$B3,$B3,$B3,$B3,$B3,$B3,$B3
  db $B3,$B3,$B3,$B3,$B3,$B3,$B3,$B3
  db $B3,$B3,$B3,$B3,$B3,$B3,$B3,$B3
  db $B3,$B3,$B3,$B3,$B3,$B3,$B3,$B3
  db $B3,$B3,$B3,$B3,$B3,$B3,$B3,$B3

Texture180:
  db $B4,$B4,$B4,$B4,$B4,$B4,$B4,$B4 // 8x8x8B = 64 Bytes
  db $B4,$B4,$B4,$B4,$B4,$B4,$B4,$B4
  db $B4,$B4,$B4,$B4,$B4,$B4,$B4,$B4
  db $B4,$B4,$B4,$B4,$B4,$B4,$B4,$B4
  db $B4,$B4,$B4,$B4,$B4,$B4,$B4,$B4
  db $B4,$B4,$B4,$B4,$B4,$B4,$B4,$B4
  db $B4,$B4,$B4,$B4,$B4,$B4,$B4,$B4
  db $B4,$B4,$B4,$B4,$B4,$B4,$B4,$B4

Texture181:
  db $B5,$B5,$B5,$B5,$B5,$B5,$B5,$B5 // 8x8x8B = 64 Bytes
  db $B5,$B5,$B5,$B5,$B5,$B5,$B5,$B5
  db $B5,$B5,$B5,$B5,$B5,$B5,$B5,$B5
  db $B5,$B5,$B5,$B5,$B5,$B5,$B5,$B5
  db $B5,$B5,$B5,$B5,$B5,$B5,$B5,$B5
  db $B5,$B5,$B5,$B5,$B5,$B5,$B5,$B5
  db $B5,$B5,$B5,$B5,$B5,$B5,$B5,$B5
  db $B5,$B5,$B5,$B5,$B5,$B5,$B5,$B5

Texture182:
  db $B6,$B6,$B6,$B6,$B6,$B6,$B6,$B6 // 8x8x8B = 64 Bytes
  db $B6,$B6,$B6,$B6,$B6,$B6,$B6,$B6
  db $B6,$B6,$B6,$B6,$B6,$B6,$B6,$B6
  db $B6,$B6,$B6,$B6,$B6,$B6,$B6,$B6
  db $B6,$B6,$B6,$B6,$B6,$B6,$B6,$B6
  db $B6,$B6,$B6,$B6,$B6,$B6,$B6,$B6
  db $B6,$B6,$B6,$B6,$B6,$B6,$B6,$B6
  db $B6,$B6,$B6,$B6,$B6,$B6,$B6,$B6

Texture183:
  db $B7,$B7,$B7,$B7,$B7,$B7,$B7,$B7 // 8x8x8B = 64 Bytes
  db $B7,$B7,$B7,$B7,$B7,$B7,$B7,$B7
  db $B7,$B7,$B7,$B7,$B7,$B7,$B7,$B7
  db $B7,$B7,$B7,$B7,$B7,$B7,$B7,$B7
  db $B7,$B7,$B7,$B7,$B7,$B7,$B7,$B7
  db $B7,$B7,$B7,$B7,$B7,$B7,$B7,$B7
  db $B7,$B7,$B7,$B7,$B7,$B7,$B7,$B7
  db $B7,$B7,$B7,$B7,$B7,$B7,$B7,$B7

Texture184:
  db $B8,$B8,$B8,$B8,$B8,$B8,$B8,$B8 // 8x8x8B = 64 Bytes
  db $B8,$B8,$B8,$B8,$B8,$B8,$B8,$B8
  db $B8,$B8,$B8,$B8,$B8,$B8,$B8,$B8
  db $B8,$B8,$B8,$B8,$B8,$B8,$B8,$B8
  db $B8,$B8,$B8,$B8,$B8,$B8,$B8,$B8
  db $B8,$B8,$B8,$B8,$B8,$B8,$B8,$B8
  db $B8,$B8,$B8,$B8,$B8,$B8,$B8,$B8
  db $B8,$B8,$B8,$B8,$B8,$B8,$B8,$B8

Texture185:
  db $B9,$B9,$B9,$B9,$B9,$B9,$B9,$B9 // 8x8x8B = 64 Bytes
  db $B9,$B9,$B9,$B9,$B9,$B9,$B9,$B9
  db $B9,$B9,$B9,$B9,$B9,$B9,$B9,$B9
  db $B9,$B9,$B9,$B9,$B9,$B9,$B9,$B9
  db $B9,$B9,$B9,$B9,$B9,$B9,$B9,$B9
  db $B9,$B9,$B9,$B9,$B9,$B9,$B9,$B9
  db $B9,$B9,$B9,$B9,$B9,$B9,$B9,$B9
  db $B9,$B9,$B9,$B9,$B9,$B9,$B9,$B9

Texture186:
  db $BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA // 8x8x8B = 64 Bytes
  db $BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA
  db $BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA
  db $BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA
  db $BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA
  db $BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA
  db $BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA
  db $BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA

Texture187:
  db $BB,$BB,$BB,$BB,$BB,$BB,$BB,$BB // 8x8x8B = 64 Bytes
  db $BB,$BB,$BB,$BB,$BB,$BB,$BB,$BB
  db $BB,$BB,$BB,$BB,$BB,$BB,$BB,$BB
  db $BB,$BB,$BB,$BB,$BB,$BB,$BB,$BB
  db $BB,$BB,$BB,$BB,$BB,$BB,$BB,$BB
  db $BB,$BB,$BB,$BB,$BB,$BB,$BB,$BB
  db $BB,$BB,$BB,$BB,$BB,$BB,$BB,$BB
  db $BB,$BB,$BB,$BB,$BB,$BB,$BB,$BB

Texture188:
  db $BC,$BC,$BC,$BC,$BC,$BC,$BC,$BC // 8x8x8B = 64 Bytes
  db $BC,$BC,$BC,$BC,$BC,$BC,$BC,$BC
  db $BC,$BC,$BC,$BC,$BC,$BC,$BC,$BC
  db $BC,$BC,$BC,$BC,$BC,$BC,$BC,$BC
  db $BC,$BC,$BC,$BC,$BC,$BC,$BC,$BC
  db $BC,$BC,$BC,$BC,$BC,$BC,$BC,$BC
  db $BC,$BC,$BC,$BC,$BC,$BC,$BC,$BC
  db $BC,$BC,$BC,$BC,$BC,$BC,$BC,$BC

Texture189:
  db $BD,$BD,$BD,$BD,$BD,$BD,$BD,$BD // 8x8x8B = 64 Bytes
  db $BD,$BD,$BD,$BD,$BD,$BD,$BD,$BD
  db $BD,$BD,$BD,$BD,$BD,$BD,$BD,$BD
  db $BD,$BD,$BD,$BD,$BD,$BD,$BD,$BD
  db $BD,$BD,$BD,$BD,$BD,$BD,$BD,$BD
  db $BD,$BD,$BD,$BD,$BD,$BD,$BD,$BD
  db $BD,$BD,$BD,$BD,$BD,$BD,$BD,$BD
  db $BD,$BD,$BD,$BD,$BD,$BD,$BD,$BD

Texture190:
  db $BE,$BE,$BE,$BE,$BE,$BE,$BE,$BE // 8x8x8B = 64 Bytes
  db $BE,$BE,$BE,$BE,$BE,$BE,$BE,$BE
  db $BE,$BE,$BE,$BE,$BE,$BE,$BE,$BE
  db $BE,$BE,$BE,$BE,$BE,$BE,$BE,$BE
  db $BE,$BE,$BE,$BE,$BE,$BE,$BE,$BE
  db $BE,$BE,$BE,$BE,$BE,$BE,$BE,$BE
  db $BE,$BE,$BE,$BE,$BE,$BE,$BE,$BE
  db $BE,$BE,$BE,$BE,$BE,$BE,$BE,$BE

Texture191:
  db $BF,$BF,$BF,$BF,$BF,$BF,$BF,$BF // 8x8x8B = 64 Bytes
  db $BF,$BF,$BF,$BF,$BF,$BF,$BF,$BF
  db $BF,$BF,$BF,$BF,$BF,$BF,$BF,$BF
  db $BF,$BF,$BF,$BF,$BF,$BF,$BF,$BF
  db $BF,$BF,$BF,$BF,$BF,$BF,$BF,$BF
  db $BF,$BF,$BF,$BF,$BF,$BF,$BF,$BF
  db $BF,$BF,$BF,$BF,$BF,$BF,$BF,$BF
  db $BF,$BF,$BF,$BF,$BF,$BF,$BF,$BF

Texture192:
  db $C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0 // 8x8x8B = 64 Bytes
  db $C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0
  db $C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0
  db $C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0
  db $C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0
  db $C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0
  db $C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0
  db $C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0

Texture193:
  db $C1,$C1,$C1,$C1,$C1,$C1,$C1,$C1 // 8x8x8B = 64 Bytes
  db $C1,$C1,$C1,$C1,$C1,$C1,$C1,$C1
  db $C1,$C1,$C1,$C1,$C1,$C1,$C1,$C1
  db $C1,$C1,$C1,$C1,$C1,$C1,$C1,$C1
  db $C1,$C1,$C1,$C1,$C1,$C1,$C1,$C1
  db $C1,$C1,$C1,$C1,$C1,$C1,$C1,$C1
  db $C1,$C1,$C1,$C1,$C1,$C1,$C1,$C1
  db $C1,$C1,$C1,$C1,$C1,$C1,$C1,$C1

Texture194:
  db $C2,$C2,$C2,$C2,$C2,$C2,$C2,$C2 // 8x8x8B = 64 Bytes
  db $C2,$C2,$C2,$C2,$C2,$C2,$C2,$C2
  db $C2,$C2,$C2,$C2,$C2,$C2,$C2,$C2
  db $C2,$C2,$C2,$C2,$C2,$C2,$C2,$C2
  db $C2,$C2,$C2,$C2,$C2,$C2,$C2,$C2
  db $C2,$C2,$C2,$C2,$C2,$C2,$C2,$C2
  db $C2,$C2,$C2,$C2,$C2,$C2,$C2,$C2
  db $C2,$C2,$C2,$C2,$C2,$C2,$C2,$C2

Texture195:
  db $C3,$C3,$C3,$C3,$C3,$C3,$C3,$C3 // 8x8x8B = 64 Bytes
  db $C3,$C3,$C3,$C3,$C3,$C3,$C3,$C3
  db $C3,$C3,$C3,$C3,$C3,$C3,$C3,$C3
  db $C3,$C3,$C3,$C3,$C3,$C3,$C3,$C3
  db $C3,$C3,$C3,$C3,$C3,$C3,$C3,$C3
  db $C3,$C3,$C3,$C3,$C3,$C3,$C3,$C3
  db $C3,$C3,$C3,$C3,$C3,$C3,$C3,$C3
  db $C3,$C3,$C3,$C3,$C3,$C3,$C3,$C3

Texture196:
  db $C4,$C4,$C4,$C4,$C4,$C4,$C4,$C4 // 8x8x8B = 64 Bytes
  db $C4,$C4,$C4,$C4,$C4,$C4,$C4,$C4
  db $C4,$C4,$C4,$C4,$C4,$C4,$C4,$C4
  db $C4,$C4,$C4,$C4,$C4,$C4,$C4,$C4
  db $C4,$C4,$C4,$C4,$C4,$C4,$C4,$C4
  db $C4,$C4,$C4,$C4,$C4,$C4,$C4,$C4
  db $C4,$C4,$C4,$C4,$C4,$C4,$C4,$C4
  db $C4,$C4,$C4,$C4,$C4,$C4,$C4,$C4

Texture197:
  db $C5,$C5,$C5,$C5,$C5,$C5,$C5,$C5 // 8x8x8B = 64 Bytes
  db $C5,$C5,$C5,$C5,$C5,$C5,$C5,$C5
  db $C5,$C5,$C5,$C5,$C5,$C5,$C5,$C5
  db $C5,$C5,$C5,$C5,$C5,$C5,$C5,$C5
  db $C5,$C5,$C5,$C5,$C5,$C5,$C5,$C5
  db $C5,$C5,$C5,$C5,$C5,$C5,$C5,$C5
  db $C5,$C5,$C5,$C5,$C5,$C5,$C5,$C5
  db $C5,$C5,$C5,$C5,$C5,$C5,$C5,$C5

Texture198:
  db $C6,$C6,$C6,$C6,$C6,$C6,$C6,$C6 // 8x8x8B = 64 Bytes
  db $C6,$C6,$C6,$C6,$C6,$C6,$C6,$C6
  db $C6,$C6,$C6,$C6,$C6,$C6,$C6,$C6
  db $C6,$C6,$C6,$C6,$C6,$C6,$C6,$C6
  db $C6,$C6,$C6,$C6,$C6,$C6,$C6,$C6
  db $C6,$C6,$C6,$C6,$C6,$C6,$C6,$C6
  db $C6,$C6,$C6,$C6,$C6,$C6,$C6,$C6
  db $C6,$C6,$C6,$C6,$C6,$C6,$C6,$C6

Texture199:
  db $C7,$C7,$C7,$C7,$C7,$C7,$C7,$C7 // 8x8x8B = 64 Bytes
  db $C7,$C7,$C7,$C7,$C7,$C7,$C7,$C7
  db $C7,$C7,$C7,$C7,$C7,$C7,$C7,$C7
  db $C7,$C7,$C7,$C7,$C7,$C7,$C7,$C7
  db $C7,$C7,$C7,$C7,$C7,$C7,$C7,$C7
  db $C7,$C7,$C7,$C7,$C7,$C7,$C7,$C7
  db $C7,$C7,$C7,$C7,$C7,$C7,$C7,$C7
  db $C7,$C7,$C7,$C7,$C7,$C7,$C7,$C7

Texture200:
  db $C8,$C8,$C8,$C8,$C8,$C8,$C8,$C8 // 8x8x8B = 64 Bytes
  db $C8,$C8,$C8,$C8,$C8,$C8,$C8,$C8
  db $C8,$C8,$C8,$C8,$C8,$C8,$C8,$C8
  db $C8,$C8,$C8,$C8,$C8,$C8,$C8,$C8
  db $C8,$C8,$C8,$C8,$C8,$C8,$C8,$C8
  db $C8,$C8,$C8,$C8,$C8,$C8,$C8,$C8
  db $C8,$C8,$C8,$C8,$C8,$C8,$C8,$C8
  db $C8,$C8,$C8,$C8,$C8,$C8,$C8,$C8

Texture201:
  db $C9,$C9,$C9,$C9,$C9,$C9,$C9,$C9 // 8x8x8B = 64 Bytes
  db $C9,$C9,$C9,$C9,$C9,$C9,$C9,$C9
  db $C9,$C9,$C9,$C9,$C9,$C9,$C9,$C9
  db $C9,$C9,$C9,$C9,$C9,$C9,$C9,$C9
  db $C9,$C9,$C9,$C9,$C9,$C9,$C9,$C9
  db $C9,$C9,$C9,$C9,$C9,$C9,$C9,$C9
  db $C9,$C9,$C9,$C9,$C9,$C9,$C9,$C9
  db $C9,$C9,$C9,$C9,$C9,$C9,$C9,$C9

Texture202:
  db $CA,$CA,$CA,$CA,$CA,$CA,$CA,$CA // 8x8x8B = 64 Bytes
  db $CA,$CA,$CA,$CA,$CA,$CA,$CA,$CA
  db $CA,$CA,$CA,$CA,$CA,$CA,$CA,$CA
  db $CA,$CA,$CA,$CA,$CA,$CA,$CA,$CA
  db $CA,$CA,$CA,$CA,$CA,$CA,$CA,$CA
  db $CA,$CA,$CA,$CA,$CA,$CA,$CA,$CA
  db $CA,$CA,$CA,$CA,$CA,$CA,$CA,$CA
  db $CA,$CA,$CA,$CA,$CA,$CA,$CA,$CA

Texture203:
  db $CB,$CB,$CB,$CB,$CB,$CB,$CB,$CB // 8x8x8B = 64 Bytes
  db $CB,$CB,$CB,$CB,$CB,$CB,$CB,$CB
  db $CB,$CB,$CB,$CB,$CB,$CB,$CB,$CB
  db $CB,$CB,$CB,$CB,$CB,$CB,$CB,$CB
  db $CB,$CB,$CB,$CB,$CB,$CB,$CB,$CB
  db $CB,$CB,$CB,$CB,$CB,$CB,$CB,$CB
  db $CB,$CB,$CB,$CB,$CB,$CB,$CB,$CB
  db $CB,$CB,$CB,$CB,$CB,$CB,$CB,$CB

Texture204:
  db $CC,$CC,$CC,$CC,$CC,$CC,$CC,$CC // 8x8x8B = 64 Bytes
  db $CC,$CC,$CC,$CC,$CC,$CC,$CC,$CC
  db $CC,$CC,$CC,$CC,$CC,$CC,$CC,$CC
  db $CC,$CC,$CC,$CC,$CC,$CC,$CC,$CC
  db $CC,$CC,$CC,$CC,$CC,$CC,$CC,$CC
  db $CC,$CC,$CC,$CC,$CC,$CC,$CC,$CC
  db $CC,$CC,$CC,$CC,$CC,$CC,$CC,$CC
  db $CC,$CC,$CC,$CC,$CC,$CC,$CC,$CC

Texture205:
  db $CD,$CD,$CD,$CD,$CD,$CD,$CD,$CD // 8x8x8B = 64 Bytes
  db $CD,$CD,$CD,$CD,$CD,$CD,$CD,$CD
  db $CD,$CD,$CD,$CD,$CD,$CD,$CD,$CD
  db $CD,$CD,$CD,$CD,$CD,$CD,$CD,$CD
  db $CD,$CD,$CD,$CD,$CD,$CD,$CD,$CD
  db $CD,$CD,$CD,$CD,$CD,$CD,$CD,$CD
  db $CD,$CD,$CD,$CD,$CD,$CD,$CD,$CD
  db $CD,$CD,$CD,$CD,$CD,$CD,$CD,$CD

Texture206:
  db $CE,$CE,$CE,$CE,$CE,$CE,$CE,$CE // 8x8x8B = 64 Bytes
  db $CE,$CE,$CE,$CE,$CE,$CE,$CE,$CE
  db $CE,$CE,$CE,$CE,$CE,$CE,$CE,$CE
  db $CE,$CE,$CE,$CE,$CE,$CE,$CE,$CE
  db $CE,$CE,$CE,$CE,$CE,$CE,$CE,$CE
  db $CE,$CE,$CE,$CE,$CE,$CE,$CE,$CE
  db $CE,$CE,$CE,$CE,$CE,$CE,$CE,$CE
  db $CE,$CE,$CE,$CE,$CE,$CE,$CE,$CE

Texture207:
  db $CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF // 8x8x8B = 64 Bytes
  db $CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF
  db $CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF
  db $CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF
  db $CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF
  db $CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF
  db $CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF
  db $CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF

Texture208:
  db $D0,$D0,$D0,$D0,$D0,$D0,$D0,$D0 // 8x8x8B = 64 Bytes
  db $D0,$D0,$D0,$D0,$D0,$D0,$D0,$D0
  db $D0,$D0,$D0,$D0,$D0,$D0,$D0,$D0
  db $D0,$D0,$D0,$D0,$D0,$D0,$D0,$D0
  db $D0,$D0,$D0,$D0,$D0,$D0,$D0,$D0
  db $D0,$D0,$D0,$D0,$D0,$D0,$D0,$D0
  db $D0,$D0,$D0,$D0,$D0,$D0,$D0,$D0
  db $D0,$D0,$D0,$D0,$D0,$D0,$D0,$D0

Texture209:
  db $D1,$D1,$D1,$D1,$D1,$D1,$D1,$D1 // 8x8x8B = 64 Bytes
  db $D1,$D1,$D1,$D1,$D1,$D1,$D1,$D1
  db $D1,$D1,$D1,$D1,$D1,$D1,$D1,$D1
  db $D1,$D1,$D1,$D1,$D1,$D1,$D1,$D1
  db $D1,$D1,$D1,$D1,$D1,$D1,$D1,$D1
  db $D1,$D1,$D1,$D1,$D1,$D1,$D1,$D1
  db $D1,$D1,$D1,$D1,$D1,$D1,$D1,$D1
  db $D1,$D1,$D1,$D1,$D1,$D1,$D1,$D1

Texture210:
  db $D2,$D2,$D2,$D2,$D2,$D2,$D2,$D2 // 8x8x8B = 64 Bytes
  db $D2,$D2,$D2,$D2,$D2,$D2,$D2,$D2
  db $D2,$D2,$D2,$D2,$D2,$D2,$D2,$D2
  db $D2,$D2,$D2,$D2,$D2,$D2,$D2,$D2
  db $D2,$D2,$D2,$D2,$D2,$D2,$D2,$D2
  db $D2,$D2,$D2,$D2,$D2,$D2,$D2,$D2
  db $D2,$D2,$D2,$D2,$D2,$D2,$D2,$D2
  db $D2,$D2,$D2,$D2,$D2,$D2,$D2,$D2

Texture211:
  db $D3,$D3,$D3,$D3,$D3,$D3,$D3,$D3 // 8x8x8B = 64 Bytes
  db $D3,$D3,$D3,$D3,$D3,$D3,$D3,$D3
  db $D3,$D3,$D3,$D3,$D3,$D3,$D3,$D3
  db $D3,$D3,$D3,$D3,$D3,$D3,$D3,$D3
  db $D3,$D3,$D3,$D3,$D3,$D3,$D3,$D3
  db $D3,$D3,$D3,$D3,$D3,$D3,$D3,$D3
  db $D3,$D3,$D3,$D3,$D3,$D3,$D3,$D3
  db $D3,$D3,$D3,$D3,$D3,$D3,$D3,$D3

Texture212:
  db $D4,$D4,$D4,$D4,$D4,$D4,$D4,$D4 // 8x8x8B = 64 Bytes
  db $D4,$D4,$D4,$D4,$D4,$D4,$D4,$D4
  db $D4,$D4,$D4,$D4,$D4,$D4,$D4,$D4
  db $D4,$D4,$D4,$D4,$D4,$D4,$D4,$D4
  db $D4,$D4,$D4,$D4,$D4,$D4,$D4,$D4
  db $D4,$D4,$D4,$D4,$D4,$D4,$D4,$D4
  db $D4,$D4,$D4,$D4,$D4,$D4,$D4,$D4
  db $D4,$D4,$D4,$D4,$D4,$D4,$D4,$D4

Texture213:
  db $D5,$D5,$D5,$D5,$D5,$D5,$D5,$D5 // 8x8x8B = 64 Bytes
  db $D5,$D5,$D5,$D5,$D5,$D5,$D5,$D5
  db $D5,$D5,$D5,$D5,$D5,$D5,$D5,$D5
  db $D5,$D5,$D5,$D5,$D5,$D5,$D5,$D5
  db $D5,$D5,$D5,$D5,$D5,$D5,$D5,$D5
  db $D5,$D5,$D5,$D5,$D5,$D5,$D5,$D5
  db $D5,$D5,$D5,$D5,$D5,$D5,$D5,$D5
  db $D5,$D5,$D5,$D5,$D5,$D5,$D5,$D5

Texture214:
  db $D6,$D6,$D6,$D6,$D6,$D6,$D6,$D6 // 8x8x8B = 64 Bytes
  db $D6,$D6,$D6,$D6,$D6,$D6,$D6,$D6
  db $D6,$D6,$D6,$D6,$D6,$D6,$D6,$D6
  db $D6,$D6,$D6,$D6,$D6,$D6,$D6,$D6
  db $D6,$D6,$D6,$D6,$D6,$D6,$D6,$D6
  db $D6,$D6,$D6,$D6,$D6,$D6,$D6,$D6
  db $D6,$D6,$D6,$D6,$D6,$D6,$D6,$D6
  db $D6,$D6,$D6,$D6,$D6,$D6,$D6,$D6

Texture215:
  db $D7,$D7,$D7,$D7,$D7,$D7,$D7,$D7 // 8x8x8B = 64 Bytes
  db $D7,$D7,$D7,$D7,$D7,$D7,$D7,$D7
  db $D7,$D7,$D7,$D7,$D7,$D7,$D7,$D7
  db $D7,$D7,$D7,$D7,$D7,$D7,$D7,$D7
  db $D7,$D7,$D7,$D7,$D7,$D7,$D7,$D7
  db $D7,$D7,$D7,$D7,$D7,$D7,$D7,$D7
  db $D7,$D7,$D7,$D7,$D7,$D7,$D7,$D7
  db $D7,$D7,$D7,$D7,$D7,$D7,$D7,$D7

Texture216:
  db $D8,$D8,$D8,$D8,$D8,$D8,$D8,$D8 // 8x8x8B = 64 Bytes
  db $D8,$D8,$D8,$D8,$D8,$D8,$D8,$D8
  db $D8,$D8,$D8,$D8,$D8,$D8,$D8,$D8
  db $D8,$D8,$D8,$D8,$D8,$D8,$D8,$D8
  db $D8,$D8,$D8,$D8,$D8,$D8,$D8,$D8
  db $D8,$D8,$D8,$D8,$D8,$D8,$D8,$D8
  db $D8,$D8,$D8,$D8,$D8,$D8,$D8,$D8
  db $D8,$D8,$D8,$D8,$D8,$D8,$D8,$D8

Texture217:
  db $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 // 8x8x8B = 64 Bytes
  db $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9
  db $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9
  db $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9
  db $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9
  db $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9
  db $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9
  db $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9

Texture218:
  db $DA,$DA,$DA,$DA,$DA,$DA,$DA,$DA // 8x8x8B = 64 Bytes
  db $DA,$DA,$DA,$DA,$DA,$DA,$DA,$DA
  db $DA,$DA,$DA,$DA,$DA,$DA,$DA,$DA
  db $DA,$DA,$DA,$DA,$DA,$DA,$DA,$DA
  db $DA,$DA,$DA,$DA,$DA,$DA,$DA,$DA
  db $DA,$DA,$DA,$DA,$DA,$DA,$DA,$DA
  db $DA,$DA,$DA,$DA,$DA,$DA,$DA,$DA
  db $DA,$DA,$DA,$DA,$DA,$DA,$DA,$DA

Texture219:
  db $DB,$DB,$DB,$DB,$DB,$DB,$DB,$DB // 8x8x8B = 64 Bytes
  db $DB,$DB,$DB,$DB,$DB,$DB,$DB,$DB
  db $DB,$DB,$DB,$DB,$DB,$DB,$DB,$DB
  db $DB,$DB,$DB,$DB,$DB,$DB,$DB,$DB
  db $DB,$DB,$DB,$DB,$DB,$DB,$DB,$DB
  db $DB,$DB,$DB,$DB,$DB,$DB,$DB,$DB
  db $DB,$DB,$DB,$DB,$DB,$DB,$DB,$DB
  db $DB,$DB,$DB,$DB,$DB,$DB,$DB,$DB

Texture220:
  db $DC,$DC,$DC,$DC,$DC,$DC,$DC,$DC // 8x8x8B = 64 Bytes
  db $DC,$DC,$DC,$DC,$DC,$DC,$DC,$DC
  db $DC,$DC,$DC,$DC,$DC,$DC,$DC,$DC
  db $DC,$DC,$DC,$DC,$DC,$DC,$DC,$DC
  db $DC,$DC,$DC,$DC,$DC,$DC,$DC,$DC
  db $DC,$DC,$DC,$DC,$DC,$DC,$DC,$DC
  db $DC,$DC,$DC,$DC,$DC,$DC,$DC,$DC
  db $DC,$DC,$DC,$DC,$DC,$DC,$DC,$DC

Texture221:
  db $DD,$DD,$DD,$DD,$DD,$DD,$DD,$DD // 8x8x8B = 64 Bytes
  db $DD,$DD,$DD,$DD,$DD,$DD,$DD,$DD
  db $DD,$DD,$DD,$DD,$DD,$DD,$DD,$DD
  db $DD,$DD,$DD,$DD,$DD,$DD,$DD,$DD
  db $DD,$DD,$DD,$DD,$DD,$DD,$DD,$DD
  db $DD,$DD,$DD,$DD,$DD,$DD,$DD,$DD
  db $DD,$DD,$DD,$DD,$DD,$DD,$DD,$DD
  db $DD,$DD,$DD,$DD,$DD,$DD,$DD,$DD

Texture222:
  db $DE,$DE,$DE,$DE,$DE,$DE,$DE,$DE // 8x8x8B = 64 Bytes
  db $DE,$DE,$DE,$DE,$DE,$DE,$DE,$DE
  db $DE,$DE,$DE,$DE,$DE,$DE,$DE,$DE
  db $DE,$DE,$DE,$DE,$DE,$DE,$DE,$DE
  db $DE,$DE,$DE,$DE,$DE,$DE,$DE,$DE
  db $DE,$DE,$DE,$DE,$DE,$DE,$DE,$DE
  db $DE,$DE,$DE,$DE,$DE,$DE,$DE,$DE
  db $DE,$DE,$DE,$DE,$DE,$DE,$DE,$DE

Texture223:
  db $DF,$DF,$DF,$DF,$DF,$DF,$DF,$DF // 8x8x8B = 64 Bytes
  db $DF,$DF,$DF,$DF,$DF,$DF,$DF,$DF
  db $DF,$DF,$DF,$DF,$DF,$DF,$DF,$DF
  db $DF,$DF,$DF,$DF,$DF,$DF,$DF,$DF
  db $DF,$DF,$DF,$DF,$DF,$DF,$DF,$DF
  db $DF,$DF,$DF,$DF,$DF,$DF,$DF,$DF
  db $DF,$DF,$DF,$DF,$DF,$DF,$DF,$DF
  db $DF,$DF,$DF,$DF,$DF,$DF,$DF,$DF

Texture224:
  db $E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0 // 8x8x8B = 64 Bytes
  db $E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0
  db $E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0
  db $E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0
  db $E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0
  db $E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0
  db $E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0
  db $E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0

Texture225:
  db $E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1 // 8x8x8B = 64 Bytes
  db $E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1
  db $E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1
  db $E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1
  db $E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1
  db $E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1
  db $E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1
  db $E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1

Texture226:
  db $E2,$E2,$E2,$E2,$E2,$E2,$E2,$E2 // 8x8x8B = 64 Bytes
  db $E2,$E2,$E2,$E2,$E2,$E2,$E2,$E2
  db $E2,$E2,$E2,$E2,$E2,$E2,$E2,$E2
  db $E2,$E2,$E2,$E2,$E2,$E2,$E2,$E2
  db $E2,$E2,$E2,$E2,$E2,$E2,$E2,$E2
  db $E2,$E2,$E2,$E2,$E2,$E2,$E2,$E2
  db $E2,$E2,$E2,$E2,$E2,$E2,$E2,$E2
  db $E2,$E2,$E2,$E2,$E2,$E2,$E2,$E2

Texture227:
  db $E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3 // 8x8x8B = 64 Bytes
  db $E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3
  db $E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3
  db $E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3
  db $E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3
  db $E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3
  db $E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3
  db $E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3

Texture228:
  db $E4,$E4,$E4,$E4,$E4,$E4,$E4,$E4 // 8x8x8B = 64 Bytes
  db $E4,$E4,$E4,$E4,$E4,$E4,$E4,$E4
  db $E4,$E4,$E4,$E4,$E4,$E4,$E4,$E4
  db $E4,$E4,$E4,$E4,$E4,$E4,$E4,$E4
  db $E4,$E4,$E4,$E4,$E4,$E4,$E4,$E4
  db $E4,$E4,$E4,$E4,$E4,$E4,$E4,$E4
  db $E4,$E4,$E4,$E4,$E4,$E4,$E4,$E4
  db $E4,$E4,$E4,$E4,$E4,$E4,$E4,$E4

Texture229:
  db $E5,$E5,$E5,$E5,$E5,$E5,$E5,$E5 // 8x8x8B = 64 Bytes
  db $E5,$E5,$E5,$E5,$E5,$E5,$E5,$E5
  db $E5,$E5,$E5,$E5,$E5,$E5,$E5,$E5
  db $E5,$E5,$E5,$E5,$E5,$E5,$E5,$E5
  db $E5,$E5,$E5,$E5,$E5,$E5,$E5,$E5
  db $E5,$E5,$E5,$E5,$E5,$E5,$E5,$E5
  db $E5,$E5,$E5,$E5,$E5,$E5,$E5,$E5
  db $E5,$E5,$E5,$E5,$E5,$E5,$E5,$E5

Texture230:
  db $E6,$E6,$E6,$E6,$E6,$E6,$E6,$E6 // 8x8x8B = 64 Bytes
  db $E6,$E6,$E6,$E6,$E6,$E6,$E6,$E6
  db $E6,$E6,$E6,$E6,$E6,$E6,$E6,$E6
  db $E6,$E6,$E6,$E6,$E6,$E6,$E6,$E6
  db $E6,$E6,$E6,$E6,$E6,$E6,$E6,$E6
  db $E6,$E6,$E6,$E6,$E6,$E6,$E6,$E6
  db $E6,$E6,$E6,$E6,$E6,$E6,$E6,$E6
  db $E6,$E6,$E6,$E6,$E6,$E6,$E6,$E6

Texture231:
  db $E7,$E7,$E7,$E7,$E7,$E7,$E7,$E7 // 8x8x8B = 64 Bytes
  db $E7,$E7,$E7,$E7,$E7,$E7,$E7,$E7
  db $E7,$E7,$E7,$E7,$E7,$E7,$E7,$E7
  db $E7,$E7,$E7,$E7,$E7,$E7,$E7,$E7
  db $E7,$E7,$E7,$E7,$E7,$E7,$E7,$E7
  db $E7,$E7,$E7,$E7,$E7,$E7,$E7,$E7
  db $E7,$E7,$E7,$E7,$E7,$E7,$E7,$E7
  db $E7,$E7,$E7,$E7,$E7,$E7,$E7,$E7

Texture232:
  db $E8,$E8,$E8,$E8,$E8,$E8,$E8,$E8 // 8x8x8B = 64 Bytes
  db $E8,$E8,$E8,$E8,$E8,$E8,$E8,$E8
  db $E8,$E8,$E8,$E8,$E8,$E8,$E8,$E8
  db $E8,$E8,$E8,$E8,$E8,$E8,$E8,$E8
  db $E8,$E8,$E8,$E8,$E8,$E8,$E8,$E8
  db $E8,$E8,$E8,$E8,$E8,$E8,$E8,$E8
  db $E8,$E8,$E8,$E8,$E8,$E8,$E8,$E8
  db $E8,$E8,$E8,$E8,$E8,$E8,$E8,$E8

Texture233:
  db $E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9 // 8x8x8B = 64 Bytes
  db $E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9
  db $E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9
  db $E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9
  db $E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9
  db $E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9
  db $E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9
  db $E9,$E9,$E9,$E9,$E9,$E9,$E9,$E9

Texture234:
  db $EA,$EA,$EA,$EA,$EA,$EA,$EA,$EA // 8x8x8B = 64 Bytes
  db $EA,$EA,$EA,$EA,$EA,$EA,$EA,$EA
  db $EA,$EA,$EA,$EA,$EA,$EA,$EA,$EA
  db $EA,$EA,$EA,$EA,$EA,$EA,$EA,$EA
  db $EA,$EA,$EA,$EA,$EA,$EA,$EA,$EA
  db $EA,$EA,$EA,$EA,$EA,$EA,$EA,$EA
  db $EA,$EA,$EA,$EA,$EA,$EA,$EA,$EA
  db $EA,$EA,$EA,$EA,$EA,$EA,$EA,$EA

Texture235:
  db $EB,$EB,$EB,$EB,$EB,$EB,$EB,$EB // 8x8x8B = 64 Bytes
  db $EB,$EB,$EB,$EB,$EB,$EB,$EB,$EB
  db $EB,$EB,$EB,$EB,$EB,$EB,$EB,$EB
  db $EB,$EB,$EB,$EB,$EB,$EB,$EB,$EB
  db $EB,$EB,$EB,$EB,$EB,$EB,$EB,$EB
  db $EB,$EB,$EB,$EB,$EB,$EB,$EB,$EB
  db $EB,$EB,$EB,$EB,$EB,$EB,$EB,$EB
  db $EB,$EB,$EB,$EB,$EB,$EB,$EB,$EB

Texture236:
  db $EC,$EC,$EC,$EC,$EC,$EC,$EC,$EC // 8x8x8B = 64 Bytes
  db $EC,$EC,$EC,$EC,$EC,$EC,$EC,$EC
  db $EC,$EC,$EC,$EC,$EC,$EC,$EC,$EC
  db $EC,$EC,$EC,$EC,$EC,$EC,$EC,$EC
  db $EC,$EC,$EC,$EC,$EC,$EC,$EC,$EC
  db $EC,$EC,$EC,$EC,$EC,$EC,$EC,$EC
  db $EC,$EC,$EC,$EC,$EC,$EC,$EC,$EC
  db $EC,$EC,$EC,$EC,$EC,$EC,$EC,$EC

Texture237:
  db $ED,$ED,$ED,$ED,$ED,$ED,$ED,$ED // 8x8x8B = 64 Bytes
  db $ED,$ED,$ED,$ED,$ED,$ED,$ED,$ED
  db $ED,$ED,$ED,$ED,$ED,$ED,$ED,$ED
  db $ED,$ED,$ED,$ED,$ED,$ED,$ED,$ED
  db $ED,$ED,$ED,$ED,$ED,$ED,$ED,$ED
  db $ED,$ED,$ED,$ED,$ED,$ED,$ED,$ED
  db $ED,$ED,$ED,$ED,$ED,$ED,$ED,$ED
  db $ED,$ED,$ED,$ED,$ED,$ED,$ED,$ED

Texture238:
  db $EE,$EE,$EE,$EE,$EE,$EE,$EE,$EE // 8x8x8B = 64 Bytes
  db $EE,$EE,$EE,$EE,$EE,$EE,$EE,$EE
  db $EE,$EE,$EE,$EE,$EE,$EE,$EE,$EE
  db $EE,$EE,$EE,$EE,$EE,$EE,$EE,$EE
  db $EE,$EE,$EE,$EE,$EE,$EE,$EE,$EE
  db $EE,$EE,$EE,$EE,$EE,$EE,$EE,$EE
  db $EE,$EE,$EE,$EE,$EE,$EE,$EE,$EE
  db $EE,$EE,$EE,$EE,$EE,$EE,$EE,$EE

Texture239:
  db $EF,$EF,$EF,$EF,$EF,$EF,$EF,$EF // 8x8x8B = 64 Bytes
  db $EF,$EF,$EF,$EF,$EF,$EF,$EF,$EF
  db $EF,$EF,$EF,$EF,$EF,$EF,$EF,$EF
  db $EF,$EF,$EF,$EF,$EF,$EF,$EF,$EF
  db $EF,$EF,$EF,$EF,$EF,$EF,$EF,$EF
  db $EF,$EF,$EF,$EF,$EF,$EF,$EF,$EF
  db $EF,$EF,$EF,$EF,$EF,$EF,$EF,$EF
  db $EF,$EF,$EF,$EF,$EF,$EF,$EF,$EF

Texture240:
  db $F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0 // 8x8x8B = 64 Bytes
  db $F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
  db $F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
  db $F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
  db $F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
  db $F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
  db $F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
  db $F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0

Texture241:
  db $F1,$F1,$F1,$F1,$F1,$F1,$F1,$F1 // 8x8x8B = 64 Bytes
  db $F1,$F1,$F1,$F1,$F1,$F1,$F1,$F1
  db $F1,$F1,$F1,$F1,$F1,$F1,$F1,$F1
  db $F1,$F1,$F1,$F1,$F1,$F1,$F1,$F1
  db $F1,$F1,$F1,$F1,$F1,$F1,$F1,$F1
  db $F1,$F1,$F1,$F1,$F1,$F1,$F1,$F1
  db $F1,$F1,$F1,$F1,$F1,$F1,$F1,$F1
  db $F1,$F1,$F1,$F1,$F1,$F1,$F1,$F1

Texture242:
  db $F2,$F2,$F2,$F2,$F2,$F2,$F2,$F2 // 8x8x8B = 64 Bytes
  db $F2,$F2,$F2,$F2,$F2,$F2,$F2,$F2
  db $F2,$F2,$F2,$F2,$F2,$F2,$F2,$F2
  db $F2,$F2,$F2,$F2,$F2,$F2,$F2,$F2
  db $F2,$F2,$F2,$F2,$F2,$F2,$F2,$F2
  db $F2,$F2,$F2,$F2,$F2,$F2,$F2,$F2
  db $F2,$F2,$F2,$F2,$F2,$F2,$F2,$F2
  db $F2,$F2,$F2,$F2,$F2,$F2,$F2,$F2

Texture243:
  db $F3,$F3,$F3,$F3,$F3,$F3,$F3,$F3 // 8x8x8B = 64 Bytes
  db $F3,$F3,$F3,$F3,$F3,$F3,$F3,$F3
  db $F3,$F3,$F3,$F3,$F3,$F3,$F3,$F3
  db $F3,$F3,$F3,$F3,$F3,$F3,$F3,$F3
  db $F3,$F3,$F3,$F3,$F3,$F3,$F3,$F3
  db $F3,$F3,$F3,$F3,$F3,$F3,$F3,$F3
  db $F3,$F3,$F3,$F3,$F3,$F3,$F3,$F3
  db $F3,$F3,$F3,$F3,$F3,$F3,$F3,$F3

Texture244:
  db $F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4 // 8x8x8B = 64 Bytes
  db $F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4
  db $F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4
  db $F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4
  db $F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4
  db $F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4
  db $F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4
  db $F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4

Texture245:
  db $F5,$F5,$F5,$F5,$F5,$F5,$F5,$F5 // 8x8x8B = 64 Bytes
  db $F5,$F5,$F5,$F5,$F5,$F5,$F5,$F5
  db $F5,$F5,$F5,$F5,$F5,$F5,$F5,$F5
  db $F5,$F5,$F5,$F5,$F5,$F5,$F5,$F5
  db $F5,$F5,$F5,$F5,$F5,$F5,$F5,$F5
  db $F5,$F5,$F5,$F5,$F5,$F5,$F5,$F5
  db $F5,$F5,$F5,$F5,$F5,$F5,$F5,$F5
  db $F5,$F5,$F5,$F5,$F5,$F5,$F5,$F5

Texture246:
  db $F6,$F6,$F6,$F6,$F6,$F6,$F6,$F6 // 8x8x8B = 64 Bytes
  db $F6,$F6,$F6,$F6,$F6,$F6,$F6,$F6
  db $F6,$F6,$F6,$F6,$F6,$F6,$F6,$F6
  db $F6,$F6,$F6,$F6,$F6,$F6,$F6,$F6
  db $F6,$F6,$F6,$F6,$F6,$F6,$F6,$F6
  db $F6,$F6,$F6,$F6,$F6,$F6,$F6,$F6
  db $F6,$F6,$F6,$F6,$F6,$F6,$F6,$F6
  db $F6,$F6,$F6,$F6,$F6,$F6,$F6,$F6

Texture247:
  db $F7,$F7,$F7,$F7,$F7,$F7,$F7,$F7 // 8x8x8B = 64 Bytes
  db $F7,$F7,$F7,$F7,$F7,$F7,$F7,$F7
  db $F7,$F7,$F7,$F7,$F7,$F7,$F7,$F7
  db $F7,$F7,$F7,$F7,$F7,$F7,$F7,$F7
  db $F7,$F7,$F7,$F7,$F7,$F7,$F7,$F7
  db $F7,$F7,$F7,$F7,$F7,$F7,$F7,$F7
  db $F7,$F7,$F7,$F7,$F7,$F7,$F7,$F7
  db $F7,$F7,$F7,$F7,$F7,$F7,$F7,$F7

Texture248:
  db $F8,$F8,$F8,$F8,$F8,$F8,$F8,$F8 // 8x8x8B = 64 Bytes
  db $F8,$F8,$F8,$F8,$F8,$F8,$F8,$F8
  db $F8,$F8,$F8,$F8,$F8,$F8,$F8,$F8
  db $F8,$F8,$F8,$F8,$F8,$F8,$F8,$F8
  db $F8,$F8,$F8,$F8,$F8,$F8,$F8,$F8
  db $F8,$F8,$F8,$F8,$F8,$F8,$F8,$F8
  db $F8,$F8,$F8,$F8,$F8,$F8,$F8,$F8
  db $F8,$F8,$F8,$F8,$F8,$F8,$F8,$F8

Texture249:
  db $F9,$F9,$F9,$F9,$F9,$F9,$F9,$F9 // 8x8x8B = 64 Bytes
  db $F9,$F9,$F9,$F9,$F9,$F9,$F9,$F9
  db $F9,$F9,$F9,$F9,$F9,$F9,$F9,$F9
  db $F9,$F9,$F9,$F9,$F9,$F9,$F9,$F9
  db $F9,$F9,$F9,$F9,$F9,$F9,$F9,$F9
  db $F9,$F9,$F9,$F9,$F9,$F9,$F9,$F9
  db $F9,$F9,$F9,$F9,$F9,$F9,$F9,$F9
  db $F9,$F9,$F9,$F9,$F9,$F9,$F9,$F9

Texture250:
  db $FA,$FA,$FA,$FA,$FA,$FA,$FA,$FA // 8x8x8B = 64 Bytes
  db $FA,$FA,$FA,$FA,$FA,$FA,$FA,$FA
  db $FA,$FA,$FA,$FA,$FA,$FA,$FA,$FA
  db $FA,$FA,$FA,$FA,$FA,$FA,$FA,$FA
  db $FA,$FA,$FA,$FA,$FA,$FA,$FA,$FA
  db $FA,$FA,$FA,$FA,$FA,$FA,$FA,$FA
  db $FA,$FA,$FA,$FA,$FA,$FA,$FA,$FA
  db $FA,$FA,$FA,$FA,$FA,$FA,$FA,$FA

Texture251:
  db $FB,$FB,$FB,$FB,$FB,$FB,$FB,$FB // 8x8x8B = 64 Bytes
  db $FB,$FB,$FB,$FB,$FB,$FB,$FB,$FB
  db $FB,$FB,$FB,$FB,$FB,$FB,$FB,$FB
  db $FB,$FB,$FB,$FB,$FB,$FB,$FB,$FB
  db $FB,$FB,$FB,$FB,$FB,$FB,$FB,$FB
  db $FB,$FB,$FB,$FB,$FB,$FB,$FB,$FB
  db $FB,$FB,$FB,$FB,$FB,$FB,$FB,$FB
  db $FB,$FB,$FB,$FB,$FB,$FB,$FB,$FB

Texture252:
  db $FC,$FC,$FC,$FC,$FC,$FC,$FC,$FC // 8x8x8B = 64 Bytes
  db $FC,$FC,$FC,$FC,$FC,$FC,$FC,$FC
  db $FC,$FC,$FC,$FC,$FC,$FC,$FC,$FC
  db $FC,$FC,$FC,$FC,$FC,$FC,$FC,$FC
  db $FC,$FC,$FC,$FC,$FC,$FC,$FC,$FC
  db $FC,$FC,$FC,$FC,$FC,$FC,$FC,$FC
  db $FC,$FC,$FC,$FC,$FC,$FC,$FC,$FC
  db $FC,$FC,$FC,$FC,$FC,$FC,$FC,$FC

Texture253:
  db $FD,$FD,$FD,$FD,$FD,$FD,$FD,$FD // 8x8x8B = 64 Bytes
  db $FD,$FD,$FD,$FD,$FD,$FD,$FD,$FD
  db $FD,$FD,$FD,$FD,$FD,$FD,$FD,$FD
  db $FD,$FD,$FD,$FD,$FD,$FD,$FD,$FD
  db $FD,$FD,$FD,$FD,$FD,$FD,$FD,$FD
  db $FD,$FD,$FD,$FD,$FD,$FD,$FD,$FD
  db $FD,$FD,$FD,$FD,$FD,$FD,$FD,$FD
  db $FD,$FD,$FD,$FD,$FD,$FD,$FD,$FD

Texture254:
  db $FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE // 8x8x8B = 64 Bytes
  db $FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE
  db $FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE
  db $FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE
  db $FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE
  db $FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE
  db $FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE
  db $FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE

Texture255:
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF // 8x8x8B = 64 Bytes
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF

Tlut:
  dw $0000,$0100,$0200,$0300,$0400,$0500,$0600,$0700,$0800,$0900,$0A00,$0B00,$0C00,$0D00,$0E00,$0F00 // 256x16B = 512 Bytes
  dw $1000,$1100,$1200,$1300,$1400,$1500,$1600,$1700,$1800,$1900,$1A00,$1B00,$1C00,$1D00,$1E00,$1F00
  dw $2000,$2100,$2200,$2300,$2400,$2500,$2600,$2700,$2800,$2900,$2A00,$2B00,$2C00,$2D00,$2E00,$2F00
  dw $3000,$3100,$3200,$3300,$3400,$3500,$3600,$3700,$3800,$3900,$3A00,$3B00,$3C00,$3D00,$3E00,$3F00
  dw $4000,$4100,$4200,$4300,$4400,$4500,$4600,$4700,$4800,$4900,$4A00,$4B00,$4C00,$4D00,$4E00,$4F00
  dw $5000,$5100,$5200,$5300,$5400,$5500,$5600,$5700,$5800,$5900,$5A00,$5B00,$5C00,$5D00,$5E00,$5F00
  dw $6000,$6100,$6200,$6300,$6400,$6500,$6600,$6700,$6800,$6900,$6A00,$6B00,$6C00,$6D00,$6E00,$6F00
  dw $7000,$7100,$7200,$7300,$7400,$7500,$7600,$7700,$7800,$7900,$7A00,$7B00,$7C00,$7D00,$7E00,$7F00
  dw $8000,$8100,$8200,$8300,$8400,$8500,$8600,$8700,$8800,$8900,$8A00,$8B00,$8C00,$8D00,$8E00,$8F00
  dw $9000,$9100,$9200,$9300,$9400,$9500,$9600,$9700,$9800,$9900,$9A00,$9B00,$9C00,$9D00,$9E00,$9F00
  dw $A000,$A100,$A200,$A300,$A400,$A500,$A600,$A700,$A800,$A900,$AA00,$AB00,$AC00,$AD00,$AE00,$AF00
  dw $B000,$B100,$B200,$B300,$B400,$B500,$B600,$B700,$B800,$B900,$BA00,$BB00,$BC00,$BD00,$BE00,$BF00
  dw $C000,$C100,$C200,$C300,$C400,$C500,$C600,$C700,$C800,$C900,$CA00,$CB00,$CC00,$CD00,$CE00,$CF00
  dw $D000,$D100,$D200,$D300,$D400,$D500,$D600,$D700,$D800,$D900,$DA00,$DB00,$DC00,$DD00,$DE00,$DF00
  dw $E000,$E100,$E200,$E300,$E400,$E500,$E600,$E700,$E800,$E900,$EA00,$EB00,$EC00,$ED00,$EE00,$EF00
  dw $F000,$F100,$F200,$F300,$F400,$F500,$F600,$F700,$F800,$F900,$FA00,$FB00,$FC00,$FD00,$FE00,$FF00