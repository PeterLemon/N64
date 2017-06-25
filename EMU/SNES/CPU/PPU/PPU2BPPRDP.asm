align(8) // Align 64-Bit
RDPBG2BPPBuffer:
arch n64.rdp
// Load Palette
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,1-1, N64TLUT2BPP // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 1, N64TLUT DRAM ADDRESS
  Set_Tile 0,0,0, $100, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: TMEM Address $100, Tile 0
  Load_Tlut 0<<2,0<<2, 0, 127<<2,0<<2 // Load Tlut: SL 0.0,TL 0.0, Tile 0, SH 127.0,TH 0.0
  Sync_Tile // Sync Tile

// BG Column 0..32 / Row 0..28
RDPSNESTILE2BPP:
  define y(0)
  while {y} < 29 {
    define x(0)
    while {x} < 33 {
      Sync_Tile // Sync Tile
      Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,4-1, N64TILE2BPP+(32*(({y}*32)+{x})) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 4, Tile DRAM ADDRESS
      Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,1, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0, Palette Number
      Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load Tile: SL,TL, Tile, SH,TH
      Texture_Rectangle_Flip (40+({x}*8))<<2,(16+({y}*8))<<2, 0, (32+({x}*8))<<2,(8+({y}*8))<<2, 0<<5,7<<5, 1<<10,-1<<10 // Texture Rectangle Flip: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

      evaluate x({x} + 1)
    }
    evaluate y({y} + 1)
  }

  Sync_Full // Ensure Entire Scene Is Fully Drawn
RDPBG2BPPBufferEnd: