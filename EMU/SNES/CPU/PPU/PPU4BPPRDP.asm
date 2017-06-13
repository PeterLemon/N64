align(8) // Align 64-Bit
N64TILE4BPP:
  fill 65536 // Generates 65536 Bytes Containing $00

align(8) // Align 64-Bit
RSPTILE4BPPCode:
arch n64.rsp
base $0000 // Set Base Of RSP Code Object To Zero

RSPTILE4BPPStart:
// Load Static Shift Data
  lli a0,0 // A0 = Shift Start Offset
  la a1,RSPSHIFTData // A1 = Aligned DRAM Physical RAM Offset ($00000000..$007FFFFF 8MB)
  li t0,(RSPSHIFTDataEnd-RSPSHIFTData)-1 // T0 = Length Of DMA Transfer In Bytes - 1

  mtc0 a0,c0 // Store Memory Offset To SP Memory Address Register ($A4040000)
  mtc0 a1,c1 // Store RAM Offset To SP DRAM Address Register ($A4040004)
  mtc0 t0,c2 // Store DMA Length To SP Read Length Register ($A4040008)

  SHIFTDMAREAD4BPPBusy:
    mfc0 t0,c4 // T0 = RSP Status Register ($A4040010)
    andi t0,RSP_BSY|RSP_FUL // AND RSP Status Status With $C (Bit 2 = DMA Is Busy, Bit 3 = DMA Is Full)
    bnez t0,SHIFTDMAREAD4BPPBusy // IF TRUE DMA Is Busy
    nop // Delay Slot

  lqv v0[e0],ShiftLeftRightA(r0) // V0 = Left Shift Using Multiply: << 0..7,  Right Shift Using Multiply: >> 16..9 (128-Bit Quad)
  lqv v1[e0],ShiftLeftRightB(r0) // V1 = Left Shift Using Multiply: << 8..15, Right Shift Using Multiply: >> 8..1  (128-Bit Quad)
  llv v2[e0],ANDNibble(r0) // V2 = $000F (AND Lo Nibble), $0F00 (AND Hi Nibble) (32-Bit Long)

// Decode Tiles
  lli t2,15 // T2 = Tile Block Counter
  lli a0,0 // A0 = Tile Start Offset
  la a1,N64TILE4BPP // A1 = Aligned DRAM Physical RAM Offset ($00000000..$007FFFFF 8MB)
  la a2,VRAM // A2 = Aligned DRAM Physical RAM Offset ($00000000..$007FFFFF 8MB)

LoopTile4BPPBlocks:
  // Uses DMA To Copy 4096 Bytes To DMEM, For 4BPPSNES->4BPPN64
  lli t0,4095 // T0 = Length Of DMA Transfer In Bytes - 1
  lli t1,127 // T1 = Tile Counter

  mtc0 a0,c0 // Store Memory Offset To SP Memory Address Register ($A4040000)
  mtc0 a2,c1 // Store RAM Offset To SP DRAM Address Register ($A4040004)
  mtc0 t0,c2 // Store DMA Length To SP Read Length Register ($A4040008)

  TILEDMAREAD4BPPBusy:
    mfc0 t0,c4 // T0 = RSP Status Register ($A4040010)
    andi t0,RSP_BSY|RSP_FUL // AND RSP Status Status With $C (Bit 2 = DMA Is Busy, Bit 3 = DMA Is Full)
    bnez t0,TILEDMAREAD4BPPBusy // IF TRUE DMA Is Busy
    nop // Delay Slot

LoopTiles4BPP:
  lqv v3[e0],$00(a0) // V3 = Tile BitPlane 0,1 Row 0..7
  lqv v4[e0],$10(a0) // V4 = Tile BitPlane 2,3 Row 0..7

// Vector Grab Column 0:
  vand v5,v3,v1[e8] // V5 = bp0 Of r0..r7 (& $0100)
  vand v6,v3,v0[e8] // V6 = bp1 Of r0..r7 (& $0001)
  vmudl v5,v1[e15]  // V5 = bp0 Of r0..r7 >> 1
  vmudn v6,v1[e8]   // V6 = bp1 Of r0..r7 << 8
  vor v7,v5,v6[e0]  // V7 = bp0/bp1 Of r0..r7 In Unsigned Byte (%00000011)

  vand v5,v4,v1[e8] // V5 = bp2 Of r0..r7 (& $0100)
  vand v6,v4,v0[e8] // V6 = bp3 Of r0..r7 (& $0001)
  vmudn v5,v0[e9]   // V5 = bp2 Of r0..r7 << 1
  vmudn v6,v1[e10]  // V6 = bp3 Of r0..r7 << 10
  vor v7,v5[e0]     // V7 = bp0/bp1/bp2 Of r0..r7 In Unsigned Byte
  vor v7,v6[e0]     // V7 = bp0/bp1/bp2/bp3 Of r0..r7 In Unsigned Byte (%00001111)

// Store Column 0:
  suv v7[e0],0(a0) // Tile Row 0 = V7 Unsigned Bytes


// Vector Grab Column 1:
  vand v5,v3,v1[e9] // V5 = bp0 Of r0..r7 (& $0200)
  vand v6,v3,v0[e9] // V6 = bp1 Of r0..r7 (& $0002)
  vmudl v5,v1[e14]  // V5 = bp0 Of r0..r7 >> 2
  vmudn v6,v0[e15]  // V6 = bp1 Of r0..r7 << 7
  vor v7,v5,v6[e0]  // V7 = bp0/bp1 Of r0..r7 In Unsigned Byte (%00000011)

  vand v5,v4,v1[e9] // V5 = bp2 Of r0..r7 (& $0200)
  vand v6,v4,v0[e9] // V6 = bp3 Of r0..r7 (& $0002)
  vmudn v6,v1[e9]   // V6 = bp3 Of r0..r7 << 9
  vor v7,v5[e0]     // V7 = bp0/bp1/bp2 Of r0..r7 In Unsigned Byte
  vor v7,v6[e0]     // V7 = bp0/bp1/bp2/bp3 Of r0..r7 In Unsigned Byte (%00001111)

// Store Column 1:
  addi a0,8
  suv v7[e0],0(a0) // Tile Row 1 = V7 Unsigned Bytes

// Pack Column 0,1 Nibbles:
  subi a0,8
  lqv v5[e0],0(a0)  // V5 = Column 0,1
  vand v6,v5,v2[e9] // V6 = Nibble Of Column 0 (& $0F00)
  vand v7,v5,v2[e8] // V7 = Nibble Of Column 1 (& $000F)
  vmudn v6,v0[e11]  // V6 = Nibble Of Column 0 << 3
  vmudn v7,v0[e15]  // V7 = Nibble Of Column 1 << 7
  vor v8,v6,v7[e0]  // V8 = Packed Column 0,1 Byte


// Vector Grab Column 2:
  vand v5,v3,v1[e10] // V5 = bp0 Of r0..r7 (& $0400)
  vand v6,v3,v0[e10] // V6 = bp1 Of r0..r7 (& $0004)
  vmudl v5,v1[e13]   // V5 = bp0 Of r0..r7 >> 3
  vmudn v6,v0[e14]   // V6 = bp1 Of r0..r7 << 6
  vor v7,v5,v6[e0]   // V7 = bp0/bp1 Of r0..r7 In Unsigned Byte (%00000011)

  vand v5,v4,v1[e10] // V5 = bp2 Of r0..r7 (& $0400)
  vand v6,v4,v0[e10] // V6 = bp3 Of r0..r7 (& $0004)
  vmudl v5,v1[e15]   // V5 = bp2 Of r0..r7 >> 1
  vmudn v6,v1[e8]    // V6 = bp3 Of r0..r7 << 8
  vor v7,v5[e0]      // V7 = bp0/bp1/bp2 Of r0..r7 In Unsigned Byte
  vor v7,v6[e0]      // V7 = bp0/bp1/bp2/bp3 Of r0..r7 In Unsigned Byte (%00001111)

// Store Column 2:
  suv v7[e0],0(a0) // Tile Row 2 = V7 Unsigned Bytes


// Vector Grab Column 3:
  vand v5,v3,v1[e11] // V5 = bp0 Of r0..r7 (& $0800)
  vand v6,v3,v0[e11] // V6 = bp1 Of r0..r7 (& $0008)
  vmudl v5,v1[e12]   // V5 = bp0 Of r0..r7 >> 4
  vmudn v6,v0[e13]   // V6 = bp1 Of r0..r7 << 5
  vor v7,v5,v6[e0]   // V7 = bp0/bp1 Of r0..r7 In Unsigned Byte (%00000011)

  vand v5,v4,v1[e11] // V5 = bp2 Of r0..r7 (& $0800)
  vand v6,v4,v0[e11] // V6 = bp3 Of r0..r7 (& $0008)
  vmudl v5,v1[e14]   // V5 = bp2 Of r0..r7 >> 2
  vmudn v6,v0[e15]   // V6 = bp3 Of r0..r7 << 7
  vor v7,v5[e0]      // V7 = bp0/bp1/bp2 Of r0..r7 In Unsigned Byte
  vor v7,v6[e0]      // V7 = bp0/bp1/bp2/bp3 Of r0..r7 In Unsigned Byte (%00001111)

// Store Column 3:
  addi a0,8
  suv v7[e0],0(a0) // Tile Row 3 = V7 Unsigned Bytes

// Pack Column 2,3 Nibbles:
  subi a0,8
  lqv v5[e0],0(a0)  // V5 = Column 2,3
  vand v6,v5,v2[e9] // V6 = Nibble Of Column 0 (& $0F00)
  vand v7,v5,v2[e8] // V7 = Nibble Of Column 1 (& $000F)
  vmudn v6,v0[e11]  // V6 = Nibble Of Column 2 << 3
  vmudn v7,v0[e15]  // V7 = Nibble Of Column 3 << 7
  vor v9,v6,v7[e0]  // V9 = Packed Column 2,3 Byte


// Vector Grab Column 4:
  vand v5,v3,v1[e12] // V5 = bp0 Of r0..r7 (& $1000)
  vand v6,v3,v0[e12] // V6 = bp1 Of r0..r7 (& $0010)
  vmudl v5,v1[e11]   // V5 = bp0 Of r0..r7 >> 5
  vmudn v6,v0[e12]   // V6 = bp1 Of r0..r7 << 4
  vor v7,v5,v6[e0]   // V7 = bp0/bp1 Of r0..r7 In Unsigned Byte (%00000011)

  vand v5,v4,v1[e12] // V5 = bp2 Of r0..r7 (& $1000)
  vand v6,v4,v0[e12] // V6 = bp3 Of r0..r7 (& $0010)
  vmudl v5,v1[e13]   // V5 = bp2 Of r0..r7 >> 3
  vmudn v6,v0[e14]   // V6 = bp3 Of r0..r7 << 6
  vor v7,v5[e0]      // V7 = bp0/bp1/bp2 Of r0..r7 In Unsigned Byte
  vor v7,v6[e0]      // V7 = bp0/bp1/bp2/bp3 Of r0..r7 In Unsigned Byte (%00001111)

// Store Column 4:
  suv v7[e0],0(a0) // Tile Row 4 = V7 Unsigned Bytes


// Vector Grab Column 5:
  vand v5,v3,v1[e13] // V5 = bp0 Of r0..r7 (& $2000)
  vand v6,v3,v0[e13] // V6 = bp1 Of r0..r7 (& $0020)
  vmudl v5,v1[e10]   // V5 = bp0 Of r0..r7 >> 6
  vmudn v6,v0[e11]   // V6 = bp1 Of r0..r7 << 3
  vor v7,v5,v6[e0]   // V7 = bp0/bp1 Of r0..r7 In Unsigned Byte (%00000011)

  vand v5,v4,v1[e13] // V5 = bp2 Of r0..r7 (& $2000)
  vand v6,v4,v0[e13] // V6 = bp3 Of r0..r7 (& $0020)
  vmudl v5,v1[e12]   // V5 = bp2 Of r0..r7 >> 4
  vmudn v6,v0[e13]   // V6 = bp3 Of r0..r7 << 5
  vor v7,v5[e0]      // V7 = bp0/bp1/bp2 Of r0..r7 In Unsigned Byte
  vor v7,v6[e0]      // V7 = bp0/bp1/bp2/bp3 Of r0..r7 In Unsigned Byte (%00001111)

// Store Column 5:
  addi a0,8
  suv v7[e0],0(a0) // Tile Row 5 = V7 Unsigned Bytes

// Pack Column 4,5 Nibbles:
  subi a0,8
  lqv v5[e0],0(a0)  // V5 = Column 4,5
  vand v6,v5,v2[e9] // V6 = Nibble Of Column 0 (& $0F00)
  vand v7,v5,v2[e8] // V7 = Nibble Of Column 1 (& $000F)
  vmudn v6,v0[e11]  // V6 = Nibble Of Column 4 << 3
  vmudn v7,v0[e15]  // V7 = Nibble Of Column 5 << 7
  vor v10,v6,v7[e0] // V10 = Packed Column 4,5 Byte


// Vector Grab Column 6:
  vand v5,v3,v1[e14] // V5 = bp0 Of r0..r7 (& $4000)
  vand v6,v3,v0[e14] // V6 = bp1 Of r0..r7 (& $0040)
  vmudl v5,v1[e9]    // V5 = bp0 Of r0..r7 >> 7
  vmudn v6,v0[e10]   // V6 = bp1 Of r0..r7 << 2
  vor v7,v5,v6[e0]   // V7 = bp0/bp1 Of r0..r7 In Unsigned Byte (%00000011)

  vand v5,v4,v1[e14] // V5 = bp2 Of r0..r7 (& $4000)
  vand v6,v4,v0[e14] // V6 = bp3 Of r0..r7 (& $0040)
  vmudl v5,v1[e11]   // V5 = bp2 Of r0..r7 >> 5
  vmudn v6,v0[e12]   // V6 = bp3 Of r0..r7 << 4
  vor v7,v5[e0]      // V7 = bp0/bp1/bp2 Of r0..r7 In Unsigned Byte
  vor v7,v6[e0]      // V7 = bp0/bp1/bp2/bp3 Of r0..r7 In Unsigned Byte (%00001111)

// Store Column 6:
  suv v7[e0],0(a0) // Tile Row 6 = V7 Unsigned Bytes


// Vector Grab Column 7:
  vand v5,v3,v1[e15] // V5 = bp0 Of r0..r7 (& $8000)
  vand v6,v3,v0[e15] // V6 = bp1 Of r0..r7 (& $0080)
  vmudl v5,v1[e8]    // V5 = bp0 Of r0..r7 >> 8
  vmudn v6,v0[e9]    // V6 = bp1 Of r0..r7 << 1
  vor v7,v5,v6[e0]   // V7 = bp0/bp1 Of r0..r7 In Unsigned Byte (%00000011)

  vand v5,v4,v1[e15] // V5 = bp2 Of r0..r7 (& $8000)
  vand v6,v4,v0[e15] // V6 = bp3 Of r0..r7 (& $0080)
  vmudl v5,v1[e10]   // V5 = bp2 Of r0..r7 >> 6
  vmudn v6,v0[e11]   // V6 = bp3 Of r0..r7 << 3
  vor v7,v5[e0]      // V7 = bp0/bp1/bp2 Of r0..r7 In Unsigned Byte
  vor v7,v6[e0]      // V7 = bp0/bp1/bp2/bp3 Of r0..r7 In Unsigned Byte (%00001111)

// Store Column 7:
  addi a0,8
  suv v7[e0],0(a0) // Tile Row 7 = V7 Unsigned Bytes

// Pack Column 6,7 Nibbles:
  subi a0,8
  lqv v5[e0],0(a0)  // V5 = Column 6,7
  vand v6,v5,v2[e9] // V6 = Nibble Of Column 0 (& $0F00)
  vand v7,v5,v2[e8] // V7 = Nibble Of Column 1 (& $000F)
  vmudn v6,v0[e11]  // V6 = Nibble Of Column 6 << 3
  vmudn v7,v0[e15]  // V7 = Nibble Of Column 7 << 7
  vor v11,v6,v7[e0] // V11 = Packed Column 6,7 Byte


// Store Tile:
  suv v8[e0],0(a0)  // Tile Row 0,1 = V8 Unsigned Bytes
  addi a0,8
  suv v9[e0],0(a0)  // Tile Row 2,3 = V9 Unsigned Bytes
  addi a0,8
  suv v10[e0],0(a0) // Tile Row 4,5 = V10 Unsigned Bytes
  addi a0,8
  suv v11[e0],0(a0) // Tile Row 6,7 = V11 Unsigned Bytes

  addi a0,8 // A0 = Next SNES Tile Offset

  bnez t1,LoopTiles4BPP // IF (Tile Counter != 0) Loop Tiles
  subi t1,1 // Decrement Tile Counter (Delay Slot)


  lli a0,0 // A0 = SP Memory Address Offset DMEM ($A4000000..$A4001FFF 8KB)
  lli t0,4095 // T0 = Length Of DMA Transfer In Bytes - 1

  mtc0 a0,c0 // Store Memory Offset To SP Memory Address Register ($A4040000)
  mtc0 a1,c1 // Store RAM Offset To SP DRAM Address Register ($A4040004)
  mtc0 t0,c3 // Store DMA Length To SP Write Length Register ($A404000C)

  TILEDMAWRITE4BPPBusy:
    mfc0 t0,c4 // T0 = RSP Status Register ($A4040010)
    andi t0,RSP_BSY|RSP_FUL // AND RSP Status Status With $C (Bit 2 = DMA Is Busy, Bit 3 = DMA Is Full)
    bnez t0,TILEDMAWRITE4BPPBusy // IF TRUE DMA Is Busy
    nop // Delay Slot

  addi a1,4096 // A1 = Next N64  Tile Offset
  addi a2,4096 // A2 = Next SNES Tile Offset

  bnez t2,LoopTile4BPPBlocks // IF (Tile Block Counter != 0) Loop Tile Blocks
  subi t2,1 // Decrement Tile Block Counter (Delay Slot)

  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
align(8) // Align 64-Bit
base RSPTILE4BPPCode+pc() // Set End Of RSP Code Object
RSPTILE4BPPCodeEnd:


align(8) // Align 64-Bit
RDPBG4BPPBuffer:
arch n64.rdp
// BG Column 0..32 / Row 0..28
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,1, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0

RDPSNESTILE4BPP:

  define y(0)
  while {y} < 29 {
    define x(0)
    while {x} < 33 {
      Sync_Tile // Sync Tile
      Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,4-1, N64TILE4BPP+(32*(({y}*32)+{x})) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 4, Tile DRAM ADDRESS
      Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load Tile: SL,TL, Tile, SH,TH
      Texture_Rectangle_Flip (40+({x}*8))<<2,(16+({y}*8))<<2, 0, (32+({x}*8))<<2,(8+({y}*8))<<2, 0<<5,7<<5, 1<<10,-1<<10 // Texture Rectangle Flip: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

      evaluate x({x} + 1)
    }
    evaluate y({y} + 1)
  }

  Sync_Full // Ensure Entire Scene Is Fully Drawn
RDPBG4BPPBufferEnd: