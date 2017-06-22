//------------
// PPU Macros
//------------
macro PPUBGMAPBASE(bg) { // SNES BGX Tile Map Base Address
  la a0,{bg}SC // A0 = BGXSC
  lbu t0,0(a0) // T0 = BGXSC Byte
  andi t0,$7C  // T0 &= $7C (VRAM 64KB Mirror)
  sll t0,9     // T0 = BG Tile Map Base Address
  la a0,VRAM   // A0 = VRAM
  addu a0,t0   // A0 = VRAM + BG Tile Map Base Address
}

macro PPUBG1TILEBASE(tile) { // SNES BG1 Tile Data Base Address
  la a1,BG12NBA // A1 = BG12NBA
  lbu t0,0(a1)  // T0 = BG12NBA Byte
  andi t0,$07   // T0 &= $07 (VRAM 64KB Mirror)
  sll t0,13     // T0 = BG1 Tile Data Base Address
  la a1,{tile}  // A1 = N64 Tile
  addu a1,t0    // A1 = N64 Tile + BG1 Tile Data Base Address
}

macro PPUBG2TILEBASE(tile) { // SNES BG2 Tile Data Base Address
  la a1,BG12NBA // A1 = BG12NBA
  lbu t0,0(a1)  // T0 = BG12NBA Byte
  andi t0,$70   // T0 &= $70 (VRAM 64KB Mirror)
  sll t0,9      // T0 = BG2 Tile Data Base Address
  la a1,{tile}  // A1 = N64 Tile
  addu a1,t0    // A1 = N64 Tile + BG2 Tile Data Base Address
}

macro PPUBG3TILEBASE(tile) { // SNES BG3 Tile Data Base Address
  la a1,BG34NBA // A1 = BG34NBA
  lbu t0,0(a1)  // T0 = BG34NBA Byte
  andi t0,$07   // T0 &= $07 (VRAM 64KB Mirror)
  sll t0,13     // T0 = BG3 Tile Data Base Address
  la a1,{tile}  // A1 = N64 Tile
  addu a1,t0    // A1 = N64 Tile + BG3 Tile Data Base Address
}

macro PPUBG4TILEBASE(tile) { // SNES BG4 Tile Data Base Address
  la a1,BG34NBA // A1 = BG34NBA
  lbu t0,0(a1)  // T0 = BG34NBA Byte
  andi t0,$70   // T0 &= $70 (VRAM 64KB Mirror)
  sll t0,9      // T0 = BG4 Tile Data Base Address
  la a1,{tile}  // A1 = N64 Tile
  addu a1,t0    // A1 = N64 Tile + BG4 Tile Data Base Address
}

macro PPU8x8BGMAP2BPP(bg) { // Convert SNES 2BPP Tile Map To RDP List
  la a2,$A0000000|((RDPSNESTILE2BPP+12)&$3FFFFFF) // A2 = N64 RDP SNES Tile Map Address
  la a3,{bg}HOFS // A3 = BGXHOFS
  lhu t0,0(a3)   // T0 = BGXHOFS Word
  andi t0,$1FF   // T0 &= $1FF (BG 8x8 Tiles Map X 512)
  andi k0,t0,7   // K0 = BGXHOFS & 7
  srl t0,3       // T0 = BGXHOFS >> 3
  la a3,{bg}VOFS // A3 = BGXVOFS
  lhu t1,0(a3)   // T1 = BGXVOFS Word
  andi t1,$1FF   // T0 &= $1FF (BG 8x8 Tiles Map Y 512)
  andi k1,t1,7   // K1 = BGXVOFS & 7
  srl t1,3       // T1 = BGXVOFS >> 3
  ori t2,r0,32   // T2 = 32 (SCREENMAPX)
  ori t3,r0,28   // T3 = 28 (SCREENMAPY)
  ori t4,r0,64   // T4 = 64

  la a3,{bg}SC   // A3 = BGXSC
  lbu t6,0(a3)   // T6 = BGXSC Byte
  andi t5,t6,1   // T5 = BGXSC & 1 (SCREENSIZE: 0=32x32, 1=64x32, 2=32x64, 3=64x64)
  beqz t5,{#}PPU8x8BGMAP2BPPXSIZE32
  or t5,r0       // T5 = 0 (Delay Slot)
  ori t5,r0,$400 // T5 = $400 (32*32) (SCREENSIZEX)
  {#}PPU8x8BGMAP2BPPXSIZE32:
  andi t6,2      // T6 = BGXSC & 2 (SCREENSIZE: 0=32x32, 1=64x32, 2=32x64, 3=64x64)
  beqz t6,{#}PPU8x8BGMAP2BPPYSIZE32
  or t6,r0       // T6 = 0 (Delay Slot)
  beqz t5,{#}PPU8x8BGMAP2BPPYSIZE32 // IF (SCREENSIZEX == 0) SCREENSIZEY = $20, ELSE SCREENSIZEY = $40
  ori t6,r0,$20  // T6 = $20 ((32*32*1)/32) (SCREENSIZEY) (Delay Slot)
  ori t6,r0,$40  // T6 = $40 ((32*32*2)/32) (SCREENSIZEY)
  {#}PPU8x8BGMAP2BPPYSIZE32:

  ori t7,r0,0    // T7 = 0 (Y)
  {#}PPU8x8BGMAP2BPPLoopY:
    ori t8,r0,0  // T8 = 0 (X)
    {#}PPU8x8BGMAP2BPPLoopX:
      addu t9,t7,t1 // BGTILE = BGMAP[(((Y+(BGXVOFS>>3))&$1F)<<5) + ((X+(BGXHOFS>>3))&$1F)])
      bge t9,t4,{#}PPU8x8BGMAP2BPPYSkip // IF (Y+(BGXVOFS>>3) >= 64) Y Skip
      andi a3,t9,$1F // A3 = T9 & $1F (Delay Slot)
      blt t9,t2,{#}PPU8x8BGMAP2BPPYSkip // IF (Y+(BGXVOFS>>3) < 32) Y Skip
      nop           // Delay Slot
      addu a3,t6    // ELSE A3 += SCREENSIZEY 0:64
      {#}PPU8x8BGMAP2BPPYSkip:
      sll t9,a3,5   // T9 = (((Y+(BGXVOFS>>3))&$1F)<<5)

      addu a3,t8,t0
      bge a3,t4,{#}PPU8x8BGMAP2BPPXSkip // IF (X+(BGXHOFS>>3) >= 64) X Skip
      andi gp,a3,$1F // GP = A3 & $1F (Delay Slot)
      blt a3,t2,{#}PPU8x8BGMAP2BPPXSkip // IF (X+(BGXHOFS>>3) < 32) X Skip
      nop           // Delay Slot
      addu gp,t5    // ELSE GP += SCREENSIZEX 0:1024 (32*32)
      {#}PPU8x8BGMAP2BPPXSkip:
      addu t9,gp    // T9 = (((Y+(BGXVOFS>>3))&$1F)<<5) + ((X+(BGXHOFS>>3))&$1F)
      sll t9,1      // T9 <<= 1

      addu t9,a0
      lbu a3,0(t9)  // A3 = SNES Tile Map # Lo Byte
      lbu t9,1(t9)  // T9 = SNES Tile Map # Hi Byte
      sll t9,8      // T9 <<= 8
      or t9,a3      // T9 |= A3

      // BG Tile X/Y Flip
      srl a3,t9,14  // A3 = X/Y Flip (Bit0: X-Flip, Bit1: Y-Flip)
      sll a3,3      // A3 *= 8 (PPU Tile Flip RDP Data Offset)
      la gp,PPUTileFlipRDP // GP = PPU Tile Flip RDP Data
      addu a3,gp    // A3 += GP
      ld a3,0(a3)   // A3 = PPU Tile Flip RDP Data Double
      sd a3,20(a2)

      // BG Tile Map
      andi t9,$3FF  // T9 &= $3FF 
      sll t9,5      // T9 *= 32 (2BPP/4BPP)
      addu t9,a1    // T9 += N64 Tile Address
      sw t9,0(a2)   // Store SNES Tile Map # To N64 RDP SNES Tile Map

      ori t9,r0,40  // XLYL = $25000000 + (((40-(BGXHOFS&7))+(X<<3))<<14) + (((16-(BGXVOFS&7))+(Y<<3))<<2)
      subu t9,k0
      sll a3,t8,3
      addu t9,a3
      sll t9,14
      lui a3,$2500
      or t9,a3      // T9 = $25000000 + (((40-(BGXHOFS&7))+(X<<3))<<14)
      ori a3,r0,16
      subu a3,k1
      sll gp,t7,3
      addu a3,gp
      sll a3,2
      addu t9,a3    // T9 = $25000000 + (((40-(BGXHOFS&7))+(X<<3))<<14) + (((16-(BGXVOFS&7))+(Y<<3))<<2)
      sw t9,12(a2)

      ori t9,r0,32  // XHYH = (((32-(BGXHOFS&7))+(X<<3))<<14) + (((8-(BGXVOFS&7))+(Y<<3))<<2)
      subu t9,k0
      sll a3,t8,3
      addu t9,a3
      sll t9,14     // T9 = (((32-(BGXHOFS&7))+(X<<3))<<14)
      ori a3,r0,8
      subu a3,k1
      sll gp,t7,3
      addu a3,gp
      sll a3,2
      addu t9,a3    // T9 = (((32-(BGXHOFS&7))+(X<<3))<<14) + (((8-(BGXVOFS&7))+(Y<<3))<<2)
      sw t9,16(a2)

      addiu a2,40   // A2 += 40
      bne t8,t2,{#}PPU8x8BGMAP2BPPLoopX // IF (X != SCREENMAPX) Map Loop X
      addiu t8,1 // Increment X (Delay Slot)
      bne t7,t3,{#}PPU8x8BGMAP2BPPLoopY // IF (Y != SCREENMAPY) Map Loop Y
      addiu t7,1 // Increment Y (Delay Slot)
}

macro PPU8x8BGMAP4BPP(bg) { // Convert SNES 4BPP Tile Map To RDP List
  la a2,$A0000000|((RDPSNESTILE4BPP+12)&$3FFFFFF) // A2 = N64 RDP SNES Tile Map Address
  la a3,{bg}HOFS // A3 = BGXHOFS
  lhu t0,0(a3)   // T0 = BGXHOFS Word
  andi t0,$1FF   // T0 &= $1FF (BG 8x8 Tiles Map X 512)
  andi k0,t0,7   // K0 = BGXHOFS & 7
  srl t0,3       // T0 = BGXHOFS >> 3
  la a3,{bg}VOFS // A3 = BGXVOFS
  lhu t1,0(a3)   // T1 = BGXVOFS Word
  andi t1,$1FF   // T0 &= $1FF (BG 8x8 Tiles Map Y 512)
  andi k1,t1,7   // K1 = BGXVOFS & 7
  srl t1,3       // T1 = BGXVOFS >> 3
  ori t2,r0,32   // T2 = 32 (SCREENMAPX)
  ori t3,r0,28   // T3 = 28 (SCREENMAPY)
  ori t4,r0,64   // T4 = 64

  la a3,{bg}SC   // A3 = BGXSC
  lbu t6,0(a3)   // T6 = BGXSC Byte
  andi t5,t6,1   // T5 = BGXSC & 1 (SCREENSIZE: 0=32x32, 1=64x32, 2=32x64, 3=64x64)
  beqz t5,{#}PPU8x8BGMAP4BPPXSIZE32
  or t5,r0       // T5 = 0 (Delay Slot)
  ori t5,r0,$400 // T5 = $400 (32*32) (SCREENSIZEX)
  {#}PPU8x8BGMAP4BPPXSIZE32:
  andi t6,2      // T6 = BGXSC & 2 (SCREENSIZE: 0=32x32, 1=64x32, 2=32x64, 3=64x64)
  beqz t6,{#}PPU8x8BGMAP4BPPYSIZE32
  or t6,r0       // T6 = 0 (Delay Slot)
  beqz t5,{#}PPU8x8BGMAP4BPPYSIZE32 // IF (SCREENSIZEX == 0) SCREENSIZEY = $20, ELSE SCREENSIZEY = $40
  ori t6,r0,$20  // T6 = $20 ((32*32*1)/32) (SCREENSIZEY) (Delay Slot)
  ori t6,r0,$40  // T6 = $40 ((32*32*2)/32) (SCREENSIZEY)
  {#}PPU8x8BGMAP4BPPYSIZE32:

  ori t7,r0,0    // T7 = 0 (Y)
  {#}PPU8x8BGMAP4BPPLoopY:
    ori t8,r0,0  // T8 = 0 (X)
    {#}PPU8x8BGMAP4BPPLoopX:
      addu t9,t7,t1 // BGTILE = BGMAP[(((Y+(BGXVOFS>>3))&$1F)<<5) + ((X+(BGXHOFS>>3))&$1F)])
      bge t9,t4,{#}PPU8x8BGMAP4BPPYSkip // IF (Y+(BGXVOFS>>3) >= 64) Y Skip
      andi a3,t9,$1F // A3 = T9 & $1F (Delay Slot)
      blt t9,t2,{#}PPU8x8BGMAP4BPPYSkip // IF (Y+(BGXVOFS>>3) < 32) Y Skip
      nop           // Delay Slot
      addu a3,t6    // ELSE A3 += SCREENSIZEY 0:64
      {#}PPU8x8BGMAP4BPPYSkip:
      sll t9,a3,5   // T9 = (((Y+(BGXVOFS>>3))&$1F)<<5)

      addu a3,t8,t0
      bge a3,t4,{#}PPU8x8BGMAP4BPPXSkip // IF (X+(BGXHOFS>>3) >= 64) X Skip
      andi gp,a3,$1F // GP = A3 & $1F (Delay Slot)
      blt a3,t2,{#}PPU8x8BGMAP4BPPXSkip // IF (X+(BGXHOFS>>3) < 32) X Skip
      nop           // Delay Slot
      addu gp,t5    // ELSE GP += SCREENSIZEX 0:1024 (32*32)
      {#}PPU8x8BGMAP4BPPXSkip:
      addu t9,gp    // T9 = (((Y+(BGXVOFS>>3))&$1F)<<5) + ((X+(BGXHOFS>>3))&$1F)
      sll t9,1      // T9 <<= 1

      addu t9,a0
      lbu a3,0(t9)  // A3 = SNES Tile Map # Lo Byte
      lbu t9,1(t9)  // T9 = SNES Tile Map # Hi Byte
      sll t9,8      // T9 <<= 8
      or t9,a3      // T9 |= A3

      // BG Tile X/Y Flip
      srl a3,t9,14  // A3 = X/Y Flip (Bit0: X-Flip, Bit1: Y-Flip)
      sll a3,3      // A3 *= 8 (PPU Tile Flip RDP Data Offset)
      la gp,PPUTileFlipRDP // GP = PPU Tile Flip RDP Data
      addu a3,gp    // A3 += GP
      ld a3,0(a3)   // A3 = PPU Tile Flip RDP Data Double
      sd a3,20(a2)

      // BG Tile Map
      andi t9,$3FF  // T9 &= $3FF 
      sll t9,5      // T9 *= 32 (2BPP/4BPP)
      addu t9,a1    // T9 += N64 Tile Address
      sw t9,0(a2)   // Store SNES Tile Map # To N64 RDP SNES Tile Map

      ori t9,r0,40  // XLYL = $25000000 + (((40-(BGXHOFS&7))+(X<<3))<<14) + (((16-(BGXVOFS&7))+(Y<<3))<<2)
      subu t9,k0
      sll a3,t8,3
      addu t9,a3
      sll t9,14
      lui a3,$2500
      or t9,a3      // T9 = $25000000 + (((40-(BGXHOFS&7))+(X<<3))<<14)
      ori a3,r0,16
      subu a3,k1
      sll gp,t7,3
      addu a3,gp
      sll a3,2
      addu t9,a3    // T9 = $25000000 + (((40-(BGXHOFS&7))+(X<<3))<<14) + (((16-(BGXVOFS&7))+(Y<<3))<<2)
      sw t9,12(a2)

      ori t9,r0,32  // XHYH = (((32-(BGXHOFS&7))+(X<<3))<<14) + (((8-(BGXVOFS&7))+(Y<<3))<<2)
      subu t9,k0
      sll a3,t8,3
      addu t9,a3
      sll t9,14     // T9 = (((32-(BGXHOFS&7))+(X<<3))<<14)
      ori a3,r0,8
      subu a3,k1
      sll gp,t7,3
      addu a3,gp
      sll a3,2
      addu t9,a3    // T9 = (((32-(BGXHOFS&7))+(X<<3))<<14) + (((8-(BGXVOFS&7))+(Y<<3))<<2)
      sw t9,16(a2)

      addiu a2,40   // A2 += 40
      bne t8,t2,{#}PPU8x8BGMAP4BPPLoopX // IF (X != SCREENMAPX) Map Loop X
      addiu t8,1 // Increment X (Delay Slot)
      bne t7,t3,{#}PPU8x8BGMAP4BPPLoopY // IF (Y != SCREENMAPY) Map Loop Y
      addiu t7,1 // Increment Y (Delay Slot)
}

macro PPU8x8BGMAP8BPP(bg) { // Convert SNES 8BPP Tile Map To RDP List
  la a2,$A0000000|((RDPSNESTILE8BPP+12)&$3FFFFFF) // A2 = N64 RDP SNES Tile Map Address
  la a3,{bg}HOFS // A3 = BGXHOFS
  lhu t0,0(a3)   // T0 = BGXHOFS Word
  andi t0,$1FF   // T0 &= $1FF (BG 8x8 Tiles Map X 512)
  andi k0,t0,7   // K0 = BGXHOFS & 7
  srl t0,3       // T0 = BGXHOFS >> 3
  la a3,{bg}VOFS // A3 = BGXVOFS
  lhu t1,0(a3)   // T1 = BGXVOFS Word
  andi t1,$1FF   // T0 &= $1FF (BG 8x8 Tiles Map Y 512)
  andi k1,t1,7   // K1 = BGXVOFS & 7
  srl t1,3       // T1 = BGXVOFS >> 3
  ori t2,r0,32   // T2 = 32 (SCREENMAPX)
  ori t3,r0,28   // T3 = 28 (SCREENMAPY)
  ori t4,r0,64   // T4 = 64

  la a3,{bg}SC   // A3 = BGXSC
  lbu t6,0(a3)   // T6 = BGXSC Byte
  andi t5,t6,1   // T5 = BGXSC & 1 (SCREENSIZE: 0=32x32, 1=64x32, 2=32x64, 3=64x64)
  beqz t5,{#}PPU8x8BGMAP8BPPXSIZE32
  or t5,r0       // T5 = 0 (Delay Slot)
  ori t5,r0,$400 // T5 = $400 (32*32) (SCREENSIZEX)
  {#}PPU8x8BGMAP8BPPXSIZE32:
  andi t6,2      // T6 = BGXSC & 2 (SCREENSIZE: 0=32x32, 1=64x32, 2=32x64, 3=64x64)
  beqz t6,{#}PPU8x8BGMAP8BPPYSIZE32
  or t6,r0       // T6 = 0 (Delay Slot)
  beqz t5,{#}PPU8x8BGMAP8BPPYSIZE32 // IF (SCREENSIZEX == 0) SCREENSIZEY = $20, ELSE SCREENSIZEY = $40
  ori t6,r0,$20  // T6 = $20 ((32*32*1)/32) (SCREENSIZEY) (Delay Slot)
  ori t6,r0,$40  // T6 = $40 ((32*32*2)/32) (SCREENSIZEY)
  {#}PPU8x8BGMAP8BPPYSIZE32:

  ori t7,r0,0    // T7 = 0 (Y)
  {#}PPU8x8BGMAP8BPPLoopY:
    ori t8,r0,0  // T8 = 0 (X)
    {#}PPU8x8BGMAP8BPPLoopX:
      addu t9,t7,t1 // BGTILE = BGMAP[(((Y+(BGXVOFS>>3))&$1F)<<5) + ((X+(BGXHOFS>>3))&$1F)])
      bge t9,t4,{#}PPU8x8BGMAP8BPPYSkip // IF (Y+(BGXVOFS>>3) >= 64) Y Skip
      andi a3,t9,$1F // A3 = T9 & $1F (Delay Slot)
      blt t9,t2,{#}PPU8x8BGMAP8BPPYSkip // IF (Y+(BGXVOFS>>3) < 32) Y Skip
      nop           // Delay Slot
      addu a3,t6    // ELSE A3 += SCREENSIZEY 0:64
      {#}PPU8x8BGMAP8BPPYSkip:
      sll t9,a3,5   // T9 = (((Y+(BGXVOFS>>3))&$1F)<<5)

      addu a3,t8,t0
      bge a3,t4,{#}PPU8x8BGMAP8BPPXSkip // IF (X+(BGXHOFS>>3) >= 64) X Skip
      andi gp,a3,$1F // GP = A3 & $1F (Delay Slot)
      blt a3,t2,{#}PPU8x8BGMAP8BPPXSkip // IF (X+(BGXHOFS>>3) < 32) X Skip
      nop           // Delay Slot
      addu gp,t5    // ELSE GP += SCREENSIZEX 0:1024 (32*32)
      {#}PPU8x8BGMAP8BPPXSkip:
      addu t9,gp    // T9 = (((Y+(BGXVOFS>>3))&$1F)<<5) + ((X+(BGXHOFS>>3))&$1F)
      sll t9,1      // T9 <<= 1

      addu t9,a0
      lbu a3,0(t9)  // A3 = SNES Tile Map # Lo Byte
      lbu t9,1(t9)  // T9 = SNES Tile Map # Hi Byte
      sll t9,8      // T9 <<= 8
      or t9,a3      // T9 |= A3

      // BG Tile X/Y Flip
      srl a3,t9,14  // A3 = X/Y Flip (Bit0: X-Flip, Bit1: Y-Flip)
      sll a3,3      // A3 *= 8 (PPU Tile Flip RDP Data Offset)
      la gp,PPUTileFlipRDP // GP = PPU Tile Flip RDP Data
      addu a3,gp    // A3 += GP
      ld a3,0(a3)   // A3 = PPU Tile Flip RDP Data Double
      sd a3,20(a2)

      // BG Tile Map
      andi t9,$3FF  // T9 &= $3FF 
      sll t9,6      // T9 *= 64 (8BPP)
      addu t9,a1    // T9 += N64 Tile Address
      sw t9,0(a2)   // Store SNES Tile Map # To N64 RDP SNES Tile Map

      ori t9,r0,40  // XLYL = $25000000 + (((40-(BGXHOFS&7))+(X<<3))<<14) + (((16-(BGXVOFS&7))+(Y<<3))<<2)
      subu t9,k0
      sll a3,t8,3
      addu t9,a3
      sll t9,14
      lui a3,$2500
      or t9,a3      // T9 = $25000000 + (((40-(BGXHOFS&7))+(X<<3))<<14)
      ori a3,r0,16
      subu a3,k1
      sll gp,t7,3
      addu a3,gp
      sll a3,2
      addu t9,a3    // T9 = $25000000 + (((40-(BGXHOFS&7))+(X<<3))<<14) + (((16-(BGXVOFS&7))+(Y<<3))<<2)
      sw t9,12(a2)

      ori t9,r0,32  // XHYH = (((32-(BGXHOFS&7))+(X<<3))<<14) + (((8-(BGXVOFS&7))+(Y<<3))<<2)
      subu t9,k0
      sll a3,t8,3
      addu t9,a3
      sll t9,14     // T9 = (((32-(BGXHOFS&7))+(X<<3))<<14)
      ori a3,r0,8
      subu a3,k1
      sll gp,t7,3
      addu a3,gp
      sll a3,2
      addu t9,a3    // T9 = (((32-(BGXHOFS&7))+(X<<3))<<14) + (((8-(BGXVOFS&7))+(Y<<3))<<2)
      sw t9,16(a2)

      addiu a2,40   // A2 += 40
      bne t8,t2,{#}PPU8x8BGMAP8BPPLoopX // IF (X != SCREENMAPX) Map Loop X
      addiu t8,1 // Increment X (Delay Slot)
      bne t7,t3,{#}PPU8x8BGMAP8BPPLoopY // IF (Y != SCREENMAPY) Map Loop Y
      addiu t7,1 // Increment Y (Delay Slot)
}

// Flush Data Cache: Index Writeback Invalidate
la a0,$80000000    // A0 = Cache Start
la a1,$80002000-16 // A1 = Cache End
LoopCache:
  cache $0|1,0(a0) // Data Cache: Index Writeback Invalidate
  bne a0,a1,LoopCache
  addiu a0,16 // Address += Data Line Size (Delay Slot)


// Copy SNES Clear Color To RDP List
la a0,N64TLUT // A0 = N64 TLUT Address
lhu t0,0(a0)  // T0 = TLUT Color 0
la a0,RDPSNESCLEARCOL+4 // A0 = N64 RDP SNES Clear Color Address
sh t0,0(a0)   // Store Color 0 To RDP Fill Color Hi
sh t0,2(a0)   // Store Color 0 To RDP Fill Color Lo

// Copy SNES Brightness Level RGBA Color To RDP List
la a0,INIDISP // A0 = INIDISP Address
lbu t0,0(a0)  // T0 = INIDISP
andi t0,$0F   // T0 = INIDISP: Master Brightness
sll t0,2      // T0 *= 4
la a0,PPURDPSNESBRIGHTNESS // A0 = N64 PPU RDP SNES BRIGHTNESS Address
addu a0,t0    // A0 += T0
lw t0,0(a0)   // T0 = N64 PPU RDP SNES BRIGHTNESS RGBA Word
la a0,RDPSNESBRIGHTNESS+4 // A0 = N64 RDP SNES Brightness Level RGBA Color Address
sw t0,0(a0)   // Store N64 PPU RDP SNES BRIGHTNESS RGBA Word To RDP List


WaitScanline($1D8) // Wait For Scanline To Reach Vertical Blank

// Run RDP Palette & Screen Setup
DPC(RDPPALBuffer, RDPPALBufferEnd) // Run DPC Command Buffer: Start Address, End Address


// Detect Mode
la a0,BGMODE // A0 = BGMODE
lbu t0,0(a0) // T0 = BGMODE Byte
andi t0,7    // T0 &= 7 (Mode Bits 0..2)

andi t1,r0 // T1 = 0
beq t0,t1,PPUMODE0 // IF (BGMODE == 0) PPUMODE0
addiu t1,1 // T1 = 1 (Delay Slot)
beq t0,t1,PPUMODE1 // IF (BGMODE == 1) PPUMODE1
addiu t1,1 // T1 = 2 (Delay Slot)
beq t0,t1,PPUMODE2 // IF (BGMODE == 2) PPUMODE2
addiu t1,1 // T1 = 3 (Delay Slot)
beq t0,t1,PPUMODE3 // IF (BGMODE == 3) PPUMODE3
addiu t1,1 // T1 = 4 (Delay Slot)
beq t0,t1,PPUMODE4 // IF (BGMODE == 4) PPUMODE4
addiu t1,1 // T1 = 5 (Delay Slot)
beq t0,t1,PPUMODE5 // IF (BGMODE == 5) PPUMODE5
addiu t1,1 // T1 = 6 (Delay Slot)
beq t0,t1,PPUMODE6 // IF (BGMODE == 6) PPUMODE6
addiu t1,1 // T1 = 7 (Delay Slot)
beq t0,t1,PPUMODE7 // IF (BGMODE == 7) PPUMODE7
nop // Delay Slot
b PPUEND // ELSE PPUEND
nop // Delay Slot


PPUMODE0: // BGMODE: Mode 0
  la a0,TM     // A0 = TM
  lbu t0,0(a0) // T0 = TM Byte
  andi t0,1    // T0 = TM BG1 Enable Bit
  beqz t0,PPUMODE0BG2 // IF (TM:BG1 == 0) PPUMODE0BG2
  nop // Delay Slot
PPUBGMAPBASE(BG1) // A0 = SNES BG1 Tile Map Base Address
PPUBG1TILEBASE(N64TILE2BPP) // A1 = SNES BG1 Tile Data Base Address
PPU8x8BGMAP2BPP(BG1) // Convert SNES 2BPP 8x8 BG Tile Map To RDP List
DPC(RDPBG2BPPBuffer, RDPBG2BPPBufferEnd) // Run DPC Command Buffer: Start Address, End Address

PPUMODE0BG2:
  la a0,TM     // A0 = TM
  lbu t0,0(a0) // T0 = TM Byte
  andi t0,2    // T0 = TM BG2 Enable Bit
  beqz t0,PPUMODE0BG3 // IF (TM:BG2 == 0) PPUMODE0BG3
  nop // Delay Slot
PPUBGMAPBASE(BG2) // A0 = SNES BG2 Tile Map Base Address
PPUBG2TILEBASE(N64TILE2BPP) // A1 = SNES BG2 Tile Data Base Address
PPU8x8BGMAP2BPP(BG2) // Convert SNES 2BPP 8x8 BG Tile Map To RDP List
DPC(RDPBG2BPPBuffer, RDPBG2BPPBufferEnd) // Run DPC Command Buffer: Start Address, End Address

PPUMODE0BG3:
  la a0,TM     // A0 = TM
  lbu t0,0(a0) // T0 = TM Byte
  andi t0,4    // T0 = TM BG3 Enable Bit
  beqz t0,PPUMODE0BG4 // IF (TM:BG3 == 0) PPUMODE0BG4
  nop // Delay Slot
PPUBGMAPBASE(BG3) // A0 = SNES BG3 Tile Map Base Address
PPUBG3TILEBASE(N64TILE2BPP) // A1 = SNES BG3 Tile Data Base Address
PPU8x8BGMAP2BPP(BG3) // Convert SNES 2BPP 8x8 BG Tile Map To RDP List
DPC(RDPBG2BPPBuffer, RDPBG2BPPBufferEnd) // Run DPC Command Buffer: Start Address, End Address

PPUMODE0BG4:
  la a0,TM     // A0 = TM
  lbu t0,0(a0) // T0 = TM Byte
  andi t0,8    // T0 = TM BG4 Enable Bit
  beqz t0,PPUEND // IF (TM:BG4 == 0) PPUEND
  nop // Delay Slot
PPUBGMAPBASE(BG4) // A0 = SNES BG4 Tile Map Base Address
PPUBG4TILEBASE(N64TILE2BPP) // A1 = SNES BG4 Tile Data Base Address
PPU8x8BGMAP2BPP(BG4) // Convert SNES 2BPP 8x8 BG Tile Map To RDP List
DPC(RDPBG2BPPBuffer, RDPBG2BPPBufferEnd) // Run DPC Command Buffer: Start Address, End Address

b PPUEND
nop // Delay Slot


PPUMODE1: // BGMODE: Mode 1
b PPUEND
nop // Delay Slot


PPUMODE2: // BGMODE: Mode 2
b PPUEND
nop // Delay Slot


PPUMODE3: // BGMODE: Mode 3
  la a0,TM     // A0 = TM
  lbu t0,0(a0) // T0 = TM Byte
  andi t0,1    // T0 = TM BG1 Enable Bit
  beqz t0,PPUMODE3BG2 // IF (TM:BG1 == 0) PPUMODE3BG2
  nop // Delay Slot
PPUBGMAPBASE(BG1) // A0 = SNES BG1 Tile Map Base Address
PPUBG1TILEBASE(N64TILE8BPP) // A1 = SNES BG1 Tile Data Base Address
PPU8x8BGMAP8BPP(BG1) // Convert SNES 8BPP 8x8 Tile Map To RDP List
DPC(RDPBG8BPPBuffer, RDPBG8BPPBufferEnd) // Run DPC Command Buffer: Start Address, End Address

PPUMODE3BG2:
  la a0,TM     // A0 = TM
  lbu t0,0(a0) // T0 = TM Byte
  andi t0,2    // T0 = TM BG2 Enable Bit
  beqz t0,PPUEND // IF (TM:BG2 == 0) PPUEND
  nop // Delay Slot
PPUBGMAPBASE(BG2) // A0 = SNES BG2 Tile Map Base Address
PPUBG2TILEBASE(N64TILE4BPP) // A1 = SNES BG2 Tile Data Base Address
PPU8x8BGMAP4BPP(BG2) // Convert SNES 4BPP 8x8 Tile Map To RDP List
DPC(RDPBG4BPPBuffer, RDPBG4BPPBufferEnd) // Run DPC Command Buffer: Start Address, End Address

b PPUEND
nop // Delay Slot


PPUMODE4: // BGMODE: Mode 4
b PPUEND
nop // Delay Slot


PPUMODE5: // BGMODE: Mode 5
b PPUEND
nop // Delay Slot


PPUMODE6: // BGMODE: Mode 6
b PPUEND
nop // Delay Slot


PPUMODE7: // BGMODE: Mode 7
b PPUEND
nop // Delay Slot


PPUEND:

  // Wait For RSP To Compute
  lui a0,SP_BASE // A0 = SP Base Register ($A4040000)
  lw t0,SP_STATUS(a0) // T0 = RSP Status
  andi t0,RSP_HLT // RSP Status &= RSP Halt Flag
  beqz t0,SkipRSP // IF (RSP Halt Flag == 0) Skip RSP
  nop // Delay Slot

  // Convert SNES Palette To N64 TLUT & Convert SNES 2BPP/4BPP/8BPP 8x8 Tiles To N64 Linear Textures
  // Load RSP Code To IMEM
  DMASPRD(RSPTILEXBPPCode, RSPTILEXBPPCodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  lui a0,SP_BASE // A0 = SP Base Register ($A4040000)
  TILEXBPPCodeDMABusy:
    lw t0,SP_STATUS(a0) // T0 = Word From SP Status Register ($A4040010)
    andi t0,$C // AND RSP Status Status With $C (Bit 2 = DMA Is Busy, Bit 3 = DMA Is Full)
    bnez t0,TILEXBPPCodeDMABusy // IF TRUE DMA Is Busy
    nop // Delay Slot

  // Set RSP Program Counter
  lui a0,SP_PC_BASE // A0 = SP PC Base Register ($A4080000)
  lli t0,RSPTILEXBPPStart // T0 = RSP Program Counter Set To Start Of RSP Code
  sw t0,SP_PC(a0) // Store RSP Program Counter To SP PC Register ($A4080000)

  // Set RSP Status (Start Execution)
  lui a0,SP_BASE // A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB // T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) // Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  SkipRSP: