align(4) // Align 32-Bit
PPURDPSNESBRIGHTNESS: // SNES Brightness Level RDP RGBA Color Data
  dw $00000000 // SNES Brightness Level: 0
  dw $111111FF // SNES Brightness Level: 1
  dw $222222FF // SNES Brightness Level: 2
  dw $333333FF // SNES Brightness Level: 3
  dw $444444FF // SNES Brightness Level: 4
  dw $555555FF // SNES Brightness Level: 5
  dw $666666FF // SNES Brightness Level: 6
  dw $777777FF // SNES Brightness Level: 7
  dw $888888FF // SNES Brightness Level: 8
  dw $999999FF // SNES Brightness Level: 9
  dw $AAAAAAFF // SNES Brightness Level: 10
  dw $BBBBBBFF // SNES Brightness Level: 11
  dw $CCCCCCFF // SNES Brightness Level: 12
  dw $DDDDDDFF // SNES Brightness Level: 13
  dw $EEEEEEFF // SNES Brightness Level: 14
  dw $FFFFFFFF // SNES Brightness Level: 15

align(8) // Align 64-Bit
RDPPALBuffer:
arch n64.rdp
  Set_Scissor 32<<2,8<<2, 0,0, 288<<2,232<<2 // Set Scissor: XH 32.0,YH 8.0, Scissor Field Enable Off,Field Off, XL 288.0,YL 232.0
  Set_Other_Modes CYCLE_TYPE_FILL // Set Other Modes
  Set_Color_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,320-1, $00100000 // Set Color Image: FORMAT RGBA,SIZE 16B,WIDTH 320, DRAM ADDRESS $00100000

RDPSNESCLEARCOL:
  Set_Fill_Color $00010001 // Set Fill Color: PACKED COLOR 16B R5G5B5A1 Pixels
  Fill_Rectangle 287<<2,231<<2, 32<<2,8<<2 // Fill Rectangle: XL 287.0,YL 231.0, XH 32.0,YH 8.0

  Set_Other_Modes EN_TLUT|SAMPLE_TYPE|BI_LERP_0|ALPHA_DITHER_SEL_NO_DITHER|RGB_DITHER_SEL_NO_DITHER|B_M2A_0_1|FORCE_BLEND|IMAGE_READ_EN // Set Other Modes
  Set_Combine_Mode $0,$00, 0,0, $3,$01, $0,$F, 1,0, 0,0,0, 7,7,7 // Set Combine Mode: SubA RGB0,MulRGB0, SubA Alpha0,MulAlpha0, SubA RGB1,MulRGB1, SubB RGB0,SubB RGB1, SubA Alpha1,MulAlpha1, AddRGB0,SubB Alpha0,AddAlpha0, AddRGB1,SubB Alpha1,AddAlpha1

RDPSNESBRIGHTNESS:
  Set_Prim_Color 0,0, $FFFFFFFF // Set The Primitive Color: MinLev,LevFrac, RGB

  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,1-1, N64TLUT // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 1, N64TLUT DRAM ADDRESS
  Set_Tile 0,0,0, $100, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: TMEM Address $100, Tile 0
  Load_Tlut 0<<2,0<<2, 0, 255<<2,0<<2 // Load Tlut: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 0.0
  Sync_Tile // Sync Tile
RDPPALBufferEnd: