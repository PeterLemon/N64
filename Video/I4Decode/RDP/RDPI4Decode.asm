// N64 'Bare Metal' 32BPP 320x240 RDP I4 Decode Frame Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "RDPI4Decode.N64", create
fill 1052672 // Set ROM Size

origin $00000000
base $80000000 // Entry Point Of Code
include "LIB\N64.INC" // Include N64 Definitions
include "LIB\N64_HEADER.ASM" // Include 64 Byte Header & Vector Table
insert "LIB\N64_BOOTCODE.BIN" // Include 4032 Byte Boot Code

Start:
  include "LIB\N64_GFX.INC" // Include Graphics Macros
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
  Set_Color_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_32B,320-1, $00100000 // Set Color Image: FORMAT RGBA,SIZE 32B,WIDTH 320, DRAM ADDRESS $00100000

  Set_Other_Modes SAMPLE_TYPE|BI_LERP_0|ALPHA_DITHER_SEL_NO_DITHER|B_M2A_0_1 // Set Other Modes
  Set_Combine_Mode $0,$00, 0,0, $1,$01, $0,$F, 1,0, 0,0,0, 7,7,7 // Set Combine Mode: SubA RGB0,MulRGB0, SubA Alpha0,MulAlpha0, SubA RGB1,MulRGB1, SubB RGB0,SubB RGB1, SubA Alpha1,MulAlpha1, AddRGB0,SubB Alpha0,AddAlpha0, AddRGB1,SubB Alpha1,AddAlpha1

  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,80-1, I4 // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 80, DRAM ADDRESS I Tile 0
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 319<<2,19<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 19.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_I,SIZE_OF_PIXEL_4B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT I,SIZE 4B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Texture_Rectangle 320<<2,20<<2, 0, 0<<2,0<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 20.0, Tile 0, XH 0.0,YH 0.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,80-1, I4+(160*20) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 80, DRAM ADDRESS I Tile 1
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 319<<2,19<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 19.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_I,SIZE_OF_PIXEL_4B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT I,SIZE 4B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Texture_Rectangle 320<<2,40<<2, 0, 0<<2,20<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 40.0, Tile 0, XH 0.0,YH 20.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,80-1, I4+((160*20)*2) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 80, DRAM ADDRESS I Tile 2
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 319<<2,19<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 19.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_I,SIZE_OF_PIXEL_4B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT I,SIZE 4B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Texture_Rectangle 320<<2,60<<2, 0, 0<<2,40<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 60.0, Tile 0, XH 0.0,YH 40.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,80-1, I4+((160*20)*3) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 80, DRAM ADDRESS I Tile 3
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 319<<2,19<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 19.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_I,SIZE_OF_PIXEL_4B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT I,SIZE 4B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Texture_Rectangle 320<<2,80<<2, 0, 0<<2,60<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 80.0, Tile 0, XH 0.0,YH 60.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,80-1, I4+((160*20)*4) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 80, DRAM ADDRESS I Tile 4
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 319<<2,19<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 19.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_I,SIZE_OF_PIXEL_4B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT I,SIZE 4B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Texture_Rectangle 320<<2,100<<2, 0, 0<<2,80<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 100.0, Tile 0, XH 0.0,YH 80.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,80-1, I4+((160*20)*5) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 80, DRAM ADDRESS I Tile 5
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 319<<2,19<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 19.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_I,SIZE_OF_PIXEL_4B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT I,SIZE 4B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Texture_Rectangle 320<<2,120<<2, 0, 0<<2,100<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 120.0, Tile 0, XH 0.0,YH 100.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,80-1, I4+((160*20)*6) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 80, DRAM ADDRESS I Tile 6
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 319<<2,19<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 19.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_I,SIZE_OF_PIXEL_4B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT I,SIZE 4B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Texture_Rectangle 320<<2,140<<2, 0, 0<<2,120<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 140.0, Tile 0, XH 0.0,YH 120.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,80-1, I4+((160*20)*7) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 80, DRAM ADDRESS I Tile 7
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 319<<2,19<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 19.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_I,SIZE_OF_PIXEL_4B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT I,SIZE 4B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Texture_Rectangle 320<<2,160<<2, 0, 0<<2,140<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 160.0, Tile 0, XH 0.0,YH 140.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,80-1, I4+((160*20)*8) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 80, DRAM ADDRESS I Tile 8
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 319<<2,19<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 19.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_I,SIZE_OF_PIXEL_4B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT I,SIZE 4B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Texture_Rectangle 320<<2,180<<2, 0, 0<<2,160<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 180.0, Tile 0, XH 0.0,YH 160.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,80-1, I4+((160*20)*9) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 80, DRAM ADDRESS I Tile 9
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 319<<2,19<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 19.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_I,SIZE_OF_PIXEL_4B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT I,SIZE 4B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Texture_Rectangle 320<<2,200<<2, 0, 0<<2,180<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 200.0, Tile 0, XH 0.0,YH 180.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,80-1, I4+((160*20)*10) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 80, DRAM ADDRESS I Tile 10
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 319<<2,19<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 19.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_I,SIZE_OF_PIXEL_4B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT I,SIZE 4B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Texture_Rectangle 320<<2,220<<2, 0, 0<<2,200<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 220.0, Tile 0, XH 0.0,YH 200.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,80-1, I4+((160*20)*11) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 80, DRAM ADDRESS I Tile 11
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 319<<2,19<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 19.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_I,SIZE_OF_PIXEL_4B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT I,SIZE 4B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Texture_Rectangle 320<<2,240<<2, 0, 0<<2,220<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 240.0, Tile 0, XH 0.0,YH 220.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Full // Ensure Entire Scene Is Fully Drawn
RDPBufferEnd:

insert I4, "frame.i4"