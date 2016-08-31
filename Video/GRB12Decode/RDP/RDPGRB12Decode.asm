// N64 'Bare Metal' 32BPP 320x240 RDP GRB 12-Bit Decode Frame Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "RDPGRB12Decode.N64", create
fill 1052672 // Set ROM Size

origin $00000000
base $80000000 // Entry Point Of Code
include "LIB/N64.INC" // Include N64 Definitions
include "LIB/N64_HEADER.ASM" // Include 64 Byte Header & Vector Table
insert "LIB/N64_BOOTCODE.BIN" // Include 4032 Byte Boot Code

Start:
  include "LIB/N64_GFX.INC" // Include Graphics Macros
  N64_INIT() // Run N64 Initialisation Routine

  ScreenNTSC(320, 240, BPP32, $A0100000) // Screen NTSC: 320x240, 32BPP, DRAM Origin $A0100000

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
  Set_Color_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_32B,320-1, $00100000 // Set Color Image: FORMAT RGBA,SIZE 32B,WIDTH 320, DRAM ADDRESS $00100000
  Set_Fill_Color $000000FF // Set Fill Color: PACKED COLOR 32B R8G8B8A8 Pixel
  Fill_Rectangle 319<<2,239<<2, 0<<2,0<<2 // Fill Rectangle: XL 319.0,YL 239.0, XH 0.0,YH 0.0

  Set_Other_Modes EN_TLUT|SAMPLE_TYPE|BI_LERP_0|ALPHA_DITHER_SEL_NO_DITHER|B_M2B_0_2|B_M2A_0_1|FORCE_BLEND|IMAGE_READ_EN // Set Other Modes
  Set_Combine_Mode $0,$00, 0,0, $1,$07, $0,$F, 1,0, 0,0,0, 7,7,7 // Set Combine Mode: SubA RGB0,MulRGB0, SubA Alpha0,MulAlpha0, SubA RGB1,MulRGB1, SubB RGB0,SubB RGB1, SubA Alpha1,MulAlpha1, AddRGB0,SubB Alpha0,AddAlpha0, AddRGB1,SubB Alpha1,AddAlpha1

  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,1-1, TLUT // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 1, DRAM ADDRESS TLUT
  Set_Tile 0,0,0, $130, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: TMEM Address $130, Tile 0
  Load_Tlut 0<<2,0<<2, 0, 47<<2,0<<2 // Load Tlut: SL 0.0,TL 0.0, Tile 0, SH 47.0,TH 0.0
  Sync_Load // Sync Load

  // Green Tiles
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,80-1, GRB // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 80, DRAM ADDRESS I Tile 0
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 319<<2,11<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 11.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,20, $000, 0,PALETTE_3, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0,Palette 3
  Texture_Rectangle 320<<2,12<<2, 0, 0<<2,0<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 12.0, Tile 0, XH 0.0,YH 0.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,80-1, GRB+(160*12) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 80, DRAM ADDRESS G Tile 1
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 319<<2,11<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 11.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,20, $000, 0,PALETTE_3, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0,Palette 3
  Texture_Rectangle 320<<2,24<<2, 0, 0<<2,12<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 24.0, Tile 0, XH 0.0,YH 12.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,80-1, GRB+((160*12)*2) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 80, DRAM ADDRESS G Tile 2
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 319<<2,11<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 11.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,20, $000, 0,PALETTE_3, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0,Palette 3
  Texture_Rectangle 320<<2,36<<2, 0, 0<<2,24<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 36.0, Tile 0, XH 0.0,YH 24.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,80-1, GRB+((160*12)*3) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 80, DRAM ADDRESS G Tile 3
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 319<<2,11<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 11.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,20, $000, 0,PALETTE_3, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0,Palette 3
  Texture_Rectangle 320<<2,48<<2, 0, 0<<2,36<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 48.0, Tile 0, XH 0.0,YH 36.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,80-1, GRB+((160*12)*4) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 80, DRAM ADDRESS G Tile 4
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 319<<2,11<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 11.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,20, $000, 0,PALETTE_3, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0,Palette 3
  Texture_Rectangle 320<<2,60<<2, 0, 0<<2,48<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 60.0, Tile 0, XH 0.0,YH 48.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,80-1, GRB+((160*12)*5) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 80, DRAM ADDRESS G Tile 5
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 319<<2,11<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 11.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,20, $000, 0,PALETTE_3, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0,Palette 3
  Texture_Rectangle 320<<2,72<<2, 0, 0<<2,60<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 72.0, Tile 0, XH 0.0,YH 60.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,80-1, GRB+((160*12)*6) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 80, DRAM ADDRESS G Tile 6
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 319<<2,11<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 11.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,20, $000, 0,PALETTE_3, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0,Palette 3
  Texture_Rectangle 320<<2,84<<2, 0, 0<<2,72<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 84.0, Tile 0, XH 0.0,YH 72.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,80-1, GRB+((160*12)*7) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 80, DRAM ADDRESS G Tile 7
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 319<<2,11<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 11.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,20, $000, 0,PALETTE_3, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0,Palette 3
  Texture_Rectangle 320<<2,96<<2, 0, 0<<2,84<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 96.0, Tile 0, XH 0.0,YH 84.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,80-1, GRB+((160*12)*8) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 80, DRAM ADDRESS G Tile 8
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 319<<2,11<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 11.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,20, $000, 0,PALETTE_3, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0,Palette 3
  Texture_Rectangle 320<<2,108<<2, 0, 0<<2,96<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 108.0, Tile 0, XH 0.0,YH 96.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,80-1, GRB+((160*12)*9) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 80, DRAM ADDRESS G Tile 9
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 319<<2,11<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 11.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,20, $000, 0,PALETTE_3, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0,Palette 3
  Texture_Rectangle 320<<2,120<<2, 0, 0<<2,108<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 120.0, Tile 0, XH 0.0,YH 108.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,80-1, GRB+((160*12)*10) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 80, DRAM ADDRESS G Tile 10
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 319<<2,11<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 11.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,20, $000, 0,PALETTE_3, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0,Palette 3
  Texture_Rectangle 320<<2,132<<2, 0, 0<<2,120<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 132.0, Tile 0, XH 0.0,YH 120.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,80-1, GRB+((160*12)*11) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 80, DRAM ADDRESS G Tile 11
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 319<<2,11<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 11.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,20, $000, 0,PALETTE_3, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0,Palette 3
  Texture_Rectangle 320<<2,144<<2, 0, 0<<2,132<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 144.0, Tile 0, XH 0.0,YH 132.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,80-1, GRB+((160*12)*12) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 80, DRAM ADDRESS G Tile 11
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 319<<2,11<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 11.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,20, $000, 0,PALETTE_3, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0,Palette 3
  Texture_Rectangle 320<<2,156<<2, 0, 0<<2,144<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 156.0, Tile 0, XH 0.0,YH 144.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,80-1, GRB+((160*12)*13) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 80, DRAM ADDRESS G Tile 13
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 319<<2,11<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 11.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,20, $000, 0,PALETTE_3, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0,Palette 3
  Texture_Rectangle 320<<2,168<<2, 0, 0<<2,156<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 168.0, Tile 0, XH 0.0,YH 156.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,80-1, GRB+((160*12)*14) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 80, DRAM ADDRESS G Tile 14
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 319<<2,11<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 11.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,20, $000, 0,PALETTE_3, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0,Palette 3
  Texture_Rectangle 320<<2,180<<2, 0, 0<<2,168<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 180.0, Tile 0, XH 0.0,YH 168.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,80-1, GRB+((160*12)*15) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 80, DRAM ADDRESS G Tile 15
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 319<<2,11<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 11.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,20, $000, 0,PALETTE_3, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0,Palette 3
  Texture_Rectangle 320<<2,192<<2, 0, 0<<2,180<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 192.0, Tile 0, XH 0.0,YH 180.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,80-1, GRB+((160*12)*16) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 80, DRAM ADDRESS G Tile 16
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 319<<2,11<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 11.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,20, $000, 0,PALETTE_3, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0,Palette 3
  Texture_Rectangle 320<<2,204<<2, 0, 0<<2,192<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 204.0, Tile 0, XH 0.0,YH 192.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,80-1, GRB+((160*12)*17) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 80, DRAM ADDRESS G Tile 17
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 319<<2,11<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 11.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,20, $000, 0,PALETTE_3, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0,Palette 3
  Texture_Rectangle 320<<2,216<<2, 0, 0<<2,204<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 216.0, Tile 0, XH 0.0,YH 204.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,80-1, GRB+((160*12)*18) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 80, DRAM ADDRESS G Tile 18
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 319<<2,11<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 11.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,20, $000, 0,PALETTE_3, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0,Palette 3
  Texture_Rectangle 320<<2,228<<2, 0, 0<<2,216<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 228.0, Tile 0, XH 0.0,YH 216.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,80-1, GRB+((160*12)*19) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 80, DRAM ADDRESS G Tile 19
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 319<<2,11<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 11.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,20, $000, 0,PALETTE_3, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0,Palette 3
  Texture_Rectangle 320<<2,240<<2, 0, 0<<2,228<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 240.0, Tile 0, XH 0.0,YH 228.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  // Red Tiles
  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,40-1, GRB+((160*12)*20) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 40, DRAM ADDRESS R Tile 0
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,10, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 10 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 159<<2,23<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 159.0,TH 23.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,10, $000, 0,PALETTE_4, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 10 (64bit Words), TMEM Address $000, Tile 0,Palette 4
  Texture_Rectangle 320<<2,48<<2, 0, 0<<2,0<<2, 0<<5,0<<5, $200,$200 // Texture Rectangle: XL 320.0,YL 48.0, Tile 0, XH 0.0,YH 0.0, S 0.0,T 0.0, DSDX 0.5,DTDY 0.5

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,40-1, GRB+((160*12)*20)+(80*24) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 40, DRAM ADDRESS R Tile 1
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,10, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 10 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 159<<2,23<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 159.0,TH 23.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,10, $000, 0,PALETTE_4, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 10 (64bit Words), TMEM Address $000, Tile 0,Palette 4
  Texture_Rectangle 320<<2,96<<2, 0, 0<<2,48<<2, 0<<5,0<<5, $200,$200 // Texture Rectangle: XL 320.0,YL 96.0, Tile 0, XH 0.0,YH 48.0, S 0.0,T 0.0, DSDX 0.5,DTDY 0.5

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,40-1, GRB+((160*12)*20)+((80*24)*2) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 40, DRAM ADDRESS R Tile 2
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,10, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 10 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 159<<2,23<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 159.0,TH 23.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,10, $000, 0,PALETTE_4, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 10 (64bit Words), TMEM Address $000, Tile 0,Palette 4
  Texture_Rectangle 320<<2,144<<2, 0, 0<<2,96<<2, 0<<5,0<<5, $200,$200 // Texture Rectangle: XL 320.0,YL 144.0, Tile 0, XH 0.0,YH 96.0, S 0.0,T 0.0, DSDX 0.5,DTDY 0.5

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,40-1, GRB+((160*12)*20)+((80*24)*3) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 40, DRAM ADDRESS R Tile 3
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,10, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 10 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 159<<2,23<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 159.0,TH 23.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,10, $000, 0,PALETTE_4, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 10 (64bit Words), TMEM Address $000, Tile 0,Palette 4
  Texture_Rectangle 320<<2,192<<2, 0, 0<<2,144<<2, 0<<5,0<<5, $200,$200 // Texture Rectangle: XL 320.0,YL 192.0, Tile 0, XH 0.0,YH 144.0, S 0.0,T 0.0, DSDX 0.5,DTDY 0.5

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,40-1, GRB+((160*12)*20)+((80*24)*4) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 40, DRAM ADDRESS R Tile 4
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,10, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 10 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 159<<2,23<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 159.0,TH 23.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,10, $000, 0,PALETTE_4, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 10 (64bit Words), TMEM Address $000, Tile 0,Palette 4
  Texture_Rectangle 320<<2,240<<2, 0, 0<<2,192<<2, 0<<5,0<<5, $200,$200 // Texture Rectangle: XL 320.0,YL 240.0, Tile 0, XH 0.0,YH 192.0, S 0.0,T 0.0, DSDX 0.5,DTDY 0.5

  // Blue Tiles
  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,20-1, GRB+((160*12)*20)+((80*24)*5) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 20, DRAM ADDRESS B Tile 0
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,5, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 5 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 79<<2,59<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 79.0,TH 59.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,5, $000, 0,PALETTE_5, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 5 (64bit Words), TMEM Address $000, Tile 0,Palette 5
  Texture_Rectangle 320<<2,120<<2, 0, 0<<2,0<<2, 0<<5,0<<5, $100,$100 // Texture Rectangle: XL 320.0,YL 120.0, Tile 0, XH 0.0,YH 0.0, S 0.0,T 0.0, DSDX 0.25,DTDY 0.25

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,20-1, GRB+((160*12)*20)+((80*24)*5)+(40*30) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 20, DRAM ADDRESS B Tile 1
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,5, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 5 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 79<<2,59<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 79.0,TH 59.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,5, $000, 0,PALETTE_5, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 5 (64bit Words), TMEM Address $000, Tile 0,Palette 5
  Texture_Rectangle 320<<2,240<<2, 0, 0<<2,120<<2, 0<<5,0<<5, $100,$100 // Texture Rectangle: XL 320.0,YL 240.0, Tile 0, XH 0.0,YH 120.0, S 0.0,T 0.0, DSDX 0.25,DTDY 0.25

  Sync_Full // Ensure Entire Scene Is Fully Drawn
RDPBufferEnd:

insert GRB, "frame.grb"

TLUT: // 16x16Bx3 = 96 Bytes
  // Green Channel Palette 3
  dh $0041, $00C1, $0141, $01C1, $0241, $02C1, $0341, $03C1, $0441, $04C1, $0541, $05C1, $0641, $06C1, $0741, $07C1 // 16x16B = 32 Bytes

  // Red Channel Palette 4
  dh $0801, $1801, $2801, $3801, $4801, $5801, $6801, $7801, $8801, $9801, $A801, $B801, $C801, $D801, $E801, $F801 // 16x16B = 32 Bytes

  // Blue Channel Palette 5
  dh $0003, $0007, $000B, $000F, $0013, $0017, $001B, $001F, $0023, $0027, $002B, $002F, $0033, $0037, $003B, $003F // 16x16B = 32 Bytes