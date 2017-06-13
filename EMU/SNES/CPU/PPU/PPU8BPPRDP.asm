align(8) // Align 64-Bit
N64TILE8BPP:
  fill 65536 // Generates 65536 Bytes Containing $00

align(8) // Align 64-Bit
RSPTILE8BPPCode:
arch n64.rsp
base $0000 // Set Base Of RSP Code Object To Zero

RSPTILE8BPPStart:
// Load Static Shift Data
  lli a0,0 // A0 = Shift Start Offset
  la a1,RSPSHIFTData // A1 = Aligned DRAM Physical RAM Offset ($00000000..$007FFFFF 8MB)
  li t0,(RSPSHIFTDataEnd-RSPSHIFTData)-1 // T0 = Length Of DMA Transfer In Bytes - 1

  mtc0 a0,c0 // Store Memory Offset To SP Memory Address Register ($A4040000)
  mtc0 a1,c1 // Store RAM Offset To SP DRAM Address Register ($A4040004)
  mtc0 t0,c2 // Store DMA Length To SP Read Length Register ($A4040008)

  SHIFTDMAREAD8BPPBusy:
    mfc0 t0,c4 // T0 = RSP Status Register ($A4040010)
    andi t0,RSP_BSY|RSP_FUL // AND RSP Status Status With $C (Bit 2 = DMA Is Busy, Bit 3 = DMA Is Full)
    bnez t0,SHIFTDMAREAD8BPPBusy // IF TRUE DMA Is Busy
    nop // Delay Slot

  lqv v0[e0],ShiftLeftRightA(r0) // V0 = Left Shift Using Multiply: << 0..7,  Right Shift Using Multiply: >> 16..9 (128-Bit Quad)
  lqv v1[e0],ShiftLeftRightB(r0) // V1 = Left Shift Using Multiply: << 8..15, Right Shift Using Multiply: >> 8..1  (128-Bit Quad)

// Decode Tiles
  lli t2,15 // T2 = Tile Block Counter
  lli a0,0 // A0 = Tile Start Offset
  la a1,N64TILE8BPP // A1 = Aligned DRAM Physical RAM Offset ($00000000..$007FFFFF 8MB)
  la a2,VRAM // A2 = Aligned DRAM Physical RAM Offset ($00000000..$007FFFFF 8MB)

LoopTile8BPPBlocks:
  // Uses DMA To Copy 4096 Bytes To DMEM, For 8BPPSNES->8BPPN64
  lli t0,4095 // T0 = Length Of DMA Transfer In Bytes - 1
  lli t1,63 // T1 = Tile Counter

  mtc0 a0,c0 // Store Memory Offset To SP Memory Address Register ($A4040000)
  mtc0 a2,c1 // Store RAM Offset To SP DRAM Address Register ($A4040004)
  mtc0 t0,c2 // Store DMA Length To SP Read Length Register ($A4040008)

  TILEDMAREAD8BPPBusy:
    mfc0 t0,c4 // T0 = RSP Status Register ($A4040010)
    andi t0,RSP_BSY|RSP_FUL // AND RSP Status Status With $C (Bit 2 = DMA Is Busy, Bit 3 = DMA Is Full)
    bnez t0,TILEDMAREAD8BPPBusy // IF TRUE DMA Is Busy
    nop // Delay Slot

LoopTiles8BPP:
  lqv v2[e0],$00(a0) // V2 = Tile BitPlane 0,1 Row 0..7
  lqv v3[e0],$10(a0) // V3 = Tile BitPlane 2,3 Row 0..7
  lqv v4[e0],$20(a0) // V4 = Tile BitPlane 4,5 Row 0..7
  lqv v5[e0],$30(a0) // V5 = Tile BitPlane 6,7 Row 0..7

// Vector Grab Column 0:
  vand v6,v2,v1[e8] // V6 = bp0 Of r0..r7 (& $0100)
  vand v7,v2,v0[e8] // V7 = bp1 Of r0..r7 (& $0001)
  vmudl v6,v1[e15]  // V6 = bp0 Of r0..r7 >> 1
  vmudn v7,v1[e8]   // V7 = bp1 Of r0..r7 << 8
  vor v8,v6,v7[e0]  // V8 = bp0/bp1 Of r0..r7 In Unsigned Byte (%00000011)

  vand v6,v3,v1[e8] // V6 = bp2 Of r0..r7 (& $0100)
  vand v7,v3,v0[e8] // V7 = bp3 Of r0..r7 (& $0001)
  vmudn v6,v0[e9]   // V6 = bp2 Of r0..r7 << 1
  vmudn v7,v1[e10]  // V7 = bp3 Of r0..r7 << 10
  vor v8,v6[e0]     // V8 = bp0/bp1/bp2 Of r0..r7 In Unsigned Byte
  vor v8,v7[e0]     // V8 = bp0/bp1/bp2/bp3 Of r0..r7 In Unsigned Byte (%00001111)

  vand v6,v4,v1[e8] // V6 = bp4 Of r0..r7 (& $0100)
  vand v7,v4,v0[e8] // V7 = bp5 Of r0..r7 (& $0001)
  vmudn v6,v0[e11]  // V6 = bp4 Of r0..r7 << 3
  vmudn v7,v1[e12]  // V7 = bp5 Of r0..r7 << 12
  vor v8,v6[e0]     // V8 = bp0/bp1/bp2/bp3/bp4 Of r0..r7 In Unsigned Byte
  vor v8,v7[e0]     // V8 = bp0/bp1/bp2/bp3/bp4/bp5 Of r0..r7 In Unsigned Byte (%00111111)

  vand v6,v5,v1[e8] // V6 = bp6 Of r0..r7 (& $0100)
  vand v7,v5,v0[e8] // V7 = bp7 Of r0..r7 (& $0001)
  vmudn v6,v0[e13]  // V6 = bp6 Of r0..r7 << 5
  vmudn v7,v1[e14]  // V7 = bp7 Of r0..r7 << 14
  vor v8,v6[e0]     // V8 = bp0/bp1/bp2/bp3/bp4/bp5/bp6 Of r0..r7 In Unsigned Byte
  vor v8,v7[e0]     // V8 = bp0/bp1/bp2/bp3/bp4/bp5/bp6/bp7 Of r0..r7 In Unsigned Byte (%11111111)

// Store Column 0:
  suv v8[e0],0(a0) // Tile Row 0 = V8 Unsigned Bytes


// Vector Grab Column 1:
  vand v6,v2,v1[e9] // V6 = bp0 Of r0..r7 (& $0200)
  vand v7,v2,v0[e9] // V7 = bp1 Of r0..r7 (& $0002)
  vmudl v6,v1[e14]  // V6 = bp0 Of r0..r7 >> 2
  vmudn v7,v0[e15]  // V7 = bp1 Of r0..r7 << 7
  vor v8,v6,v7[e0]  // V8 = bp0/bp1 Of r0..r7 In Unsigned Byte (%00000011)

  vand v6,v3,v1[e9] // V6 = bp2 Of r0..r7 (& $0200)
  vand v7,v3,v0[e9] // V7 = bp3 Of r0..r7 (& $0002)
  vmudn v7,v1[e9]   // V7 = bp3 Of r0..r7 << 9
  vor v8,v6[e0]     // V8 = bp0/bp1/bp2 Of r0..r7 In Unsigned Byte
  vor v8,v7[e0]     // V8 = bp0/bp1/bp2/bp3 Of r0..r7 In Unsigned Byte (%00001111)

  vand v6,v4,v1[e9] // V6 = bp4 Of r0..r7 (& $0200)
  vand v7,v4,v0[e9] // V7 = bp5 Of r0..r7 (& $0002)
  vmudn v6,v0[e10]  // V6 = bp4 Of r0..r7 << 2
  vmudn v7,v1[e11]  // V7 = bp5 Of r0..r7 << 11
  vor v8,v6[e0]     // V8 = bp0/bp1/bp2/bp3/bp4 Of r0..r7 In Unsigned Byte
  vor v8,v7[e0]     // V8 = bp0/bp1/bp2/bp3/bp4/bp5 Of r0..r7 In Unsigned Byte (%00111111)

  vand v6,v5,v1[e9] // V6 = bp6 Of r0..r7 (& $0200)
  vand v7,v5,v0[e9] // V7 = bp7 Of r0..r7 (& $0002)
  vmudn v6,v0[e12]  // V6 = bp6 Of r0..r7 << 4
  vmudn v7,v1[e13]  // V7 = bp7 Of r0..r7 << 13
  vor v8,v6[e0]     // V8 = bp0/bp1/bp2/bp3/bp4/bp5/bp6 Of r0..r7 In Unsigned Byte
  vor v8,v7[e0]     // V8 = bp0/bp1/bp2/bp3/bp4/bp5/bp6/bp7 Of r0..r7 In Unsigned Byte (%11111111)

// Store Column 1:
  addi a0,8
  suv v8[e0],0(a0) // Tile Row 1 = V8 Unsigned Bytes


// Vector Grab Column 2:
  vand v6,v2,v1[e10] // V6 = bp0 Of r0..r7 (& $0400)
  vand v7,v2,v0[e10] // V7 = bp1 Of r0..r7 (& $0004)
  vmudl v6,v1[e13]   // V6 = bp0 Of r0..r7 >> 3
  vmudn v7,v0[e14]   // V7 = bp1 Of r0..r7 << 6
  vor v8,v6,v7[e0]   // V8 = bp0/bp1 Of r0..r7 In Unsigned Byte (%00000011)

  vand v6,v3,v1[e10] // V6 = bp2 Of r0..r7 (& $0400)
  vand v7,v3,v0[e10] // V7 = bp3 Of r0..r7 (& $0004)
  vmudl v6,v1[e15]   // V6 = bp2 Of r0..r7 >> 1
  vmudn v7,v1[e8]    // V7 = bp3 Of r0..r7 << 8
  vor v8,v6[e0]      // V8 = bp0/bp1/bp2 Of r0..r7 In Unsigned Byte
  vor v8,v7[e0]      // V8 = bp0/bp1/bp2/bp3 Of r0..r7 In Unsigned Byte (%00001111)

  vand v6,v4,v1[e10] // V6 = bp4 Of r0..r7 (& $0400)
  vand v7,v4,v0[e10] // V7 = bp5 Of r0..r7 (& $0004)
  vmudn v6,v0[e9]    // V6 = bp4 Of r0..r7 << 1
  vmudn v7,v1[e10]   // V7 = bp5 Of r0..r7 << 10
  vor v8,v6[e0]      // V8 = bp0/bp1/bp2/bp3/bp4 Of r0..r7 In Unsigned Byte
  vor v8,v7[e0]      // V8 = bp0/bp1/bp2/bp3/bp4/bp5 Of r0..r7 In Unsigned Byte (%00111111)

  vand v6,v5,v1[e10] // V6 = bp6 Of r0..r7 (& $0400)
  vand v7,v5,v0[e10] // V7 = bp7 Of r0..r7 (& $0004)
  vmudn v6,v0[e11]   // V6 = bp6 Of r0..r7 << 3
  vmudn v7,v1[e12]   // V7 = bp7 Of r0..r7 << 12
  vor v8,v6[e0]      // V8 = bp0/bp1/bp2/bp3/bp4/bp5/bp6 Of r0..r7 In Unsigned Byte
  vor v8,v7[e0]      // V8 = bp0/bp1/bp2/bp3/bp4/bp5/bp6/bp7 Of r0..r7 In Unsigned Byte (%11111111)

// Store Column 2:
  addi a0,8
  suv v8[e0],0(a0) // Tile Row 2 = V8 Unsigned Bytes


// Vector Grab Column 3:
  vand v6,v2,v1[e11] // V6 = bp0 Of r0..r7 (& $0800)
  vand v7,v2,v0[e11] // V7 = bp1 Of r0..r7 (& $0008)
  vmudl v6,v1[e12]   // V6 = bp0 Of r0..r7 >> 4
  vmudn v7,v0[e13]   // V7 = bp1 Of r0..r7 << 5
  vor v8,v6,v7[e0]   // V8 = bp0/bp1 Of r0..r7 In Unsigned Byte (%00000011)

  vand v6,v3,v1[e11] // V6 = bp2 Of r0..r7 (& $0800)
  vand v7,v3,v0[e11] // V7 = bp3 Of r0..r7 (& $0008)
  vmudl v6,v1[e14]   // V6 = bp2 Of r0..r7 >> 2
  vmudn v7,v0[e15]   // V7 = bp3 Of r0..r7 << 7
  vor v8,v6[e0]      // V8 = bp0/bp1/bp2 Of r0..r7 In Unsigned Byte
  vor v8,v7[e0]      // V8 = bp0/bp1/bp2/bp3 Of r0..r7 In Unsigned Byte (%00001111)

  vand v6,v4,v1[e11] // V6 = bp4 Of r0..r7 (& $0800)
  vand v7,v4,v0[e11] // V7 = bp5 Of r0..r7 (& $0008)
  vmudn v7,v1[e9]    // V7 = bp5 Of r0..r7 << 9
  vor v8,v6[e0]      // V8 = bp0/bp1/bp2/bp3/bp4 Of r0..r7 In Unsigned Byte
  vor v8,v7[e0]      // V8 = bp0/bp1/bp2/bp3/bp4/bp5 Of r0..r7 In Unsigned Byte (%00111111)

  vand v6,v5,v1[e11] // V6 = bp6 Of r0..r7 (& $0800)
  vand v7,v5,v0[e11] // V7 = bp7 Of r0..r7 (& $0008)
  vmudn v6,v0[e10]   // V6 = bp6 Of r0..r7 << 2
  vmudn v7,v1[e11]   // V7 = bp7 Of r0..r7 << 11
  vor v8,v6[e0]      // V8 = bp0/bp1/bp2/bp3/bp4/bp5/bp6 Of r0..r7 In Unsigned Byte
  vor v8,v7[e0]      // V8 = bp0/bp1/bp2/bp3/bp4/bp5/bp6/bp7 Of r0..r7 In Unsigned Byte (%11111111)

// Store Column 3:
  addi a0,8
  suv v8[e0],0(a0) // Tile Row 3 = V8 Unsigned Bytes


// Vector Grab Column 4:
  vand v6,v2,v1[e12] // V6 = bp0 Of r0..r7 (& $1000)
  vand v7,v2,v0[e12] // V7 = bp1 Of r0..r7 (& $0010)
  vmudl v6,v1[e11]   // V6 = bp0 Of r0..r7 >> 5
  vmudn v7,v0[e12]   // V7 = bp1 Of r0..r7 << 4
  vor v8,v6,v7[e0]   // V8 = bp0/bp1 Of r0..r7 In Unsigned Byte (%00000011)

  vand v6,v3,v1[e12] // V6 = bp2 Of r0..r7 (& $1000)
  vand v7,v3,v0[e12] // V7 = bp3 Of r0..r7 (& $0010)
  vmudl v6,v1[e13]   // V6 = bp2 Of r0..r7 >> 3
  vmudn v7,v0[e14]   // V7 = bp3 Of r0..r7 << 6
  vor v8,v6[e0]      // V8 = bp0/bp1/bp2 Of r0..r7 In Unsigned Byte
  vor v8,v7[e0]      // V8 = bp0/bp1/bp2/bp3 Of r0..r7 In Unsigned Byte (%00001111)

  vand v6,v4,v1[e12] // V6 = bp4 Of r0..r7 (& $1000)
  vand v7,v4,v0[e12] // V7 = bp5 Of r0..r7 (& $0010)
  vmudl v6,v1[e15]   // V6 = bp4 Of r0..r7 >> 1
  vmudn v7,v1[e8]    // V7 = bp5 Of r0..r7 << 8
  vor v8,v6[e0]      // V8 = bp0/bp1/bp2/bp3/bp4 Of r0..r7 In Unsigned Byte
  vor v8,v7[e0]      // V8 = bp0/bp1/bp2/bp3/bp4/bp5 Of r0..r7 In Unsigned Byte (%00111111)

  vand v6,v5,v1[e12] // V6 = bp6 Of r0..r7 (& $1000)
  vand v7,v5,v0[e12] // V7 = bp7 Of r0..r7 (& $0010)
  vmudn v6,v0[e9]    // V6 = bp6 Of r0..r7 << 1
  vmudn v7,v1[e10]   // V7 = bp7 Of r0..r7 << 10
  vor v8,v6[e0]      // V8 = bp0/bp1/bp2/bp3/bp4/bp5/bp6 Of r0..r7 In Unsigned Byte
  vor v8,v7[e0]      // V8 = bp0/bp1/bp2/bp3/bp4/bp5/bp6/bp7 Of r0..r7 In Unsigned Byte (%11111111)

// Store Column 4:
  addi a0,8
  suv v8[e0],0(a0) // Tile Row 4 = V8 Unsigned Bytes


// Vector Grab Column 5:
  vand v6,v2,v1[e13] // V6 = bp0 Of r0..r7 (& $2000)
  vand v7,v2,v0[e13] // V7 = bp1 Of r0..r7 (& $0020)
  vmudl v6,v1[e10]   // V6 = bp0 Of r0..r7 >> 6
  vmudn v7,v0[e11]   // V7 = bp1 Of r0..r7 << 3
  vor v8,v6,v7[e0]   // V8 = bp0/bp1 Of r0..r7 In Unsigned Byte (%00000011)

  vand v6,v3,v1[e13] // V6 = bp2 Of r0..r7 (& $2000)
  vand v7,v3,v0[e13] // V7 = bp3 Of r0..r7 (& $0020)
  vmudl v6,v1[e12]   // V6 = bp2 Of r0..r7 >> 4
  vmudn v7,v0[e13]   // V7 = bp3 Of r0..r7 << 5
  vor v8,v6[e0]      // V8 = bp0/bp1/bp2 Of r0..r7 In Unsigned Byte
  vor v8,v7[e0]      // V8 = bp0/bp1/bp2/bp3 Of r0..r7 In Unsigned Byte (%00001111)

  vand v6,v4,v1[e13] // V6 = bp4 Of r0..r7 (& $2000)
  vand v7,v4,v0[e13] // V7 = bp5 Of r0..r7 (& $0020)
  vmudl v6,v1[e14]   // V6 = bp4 Of r0..r7 >> 2
  vmudn v7,v0[e15]   // V7 = bp5 Of r0..r7 << 7
  vor v8,v6[e0]      // V8 = bp0/bp1/bp2/bp3/bp4 Of r0..r7 In Unsigned Byte
  vor v8,v7[e0]      // V8 = bp0/bp1/bp2/bp3/bp4/bp5 Of r0..r7 In Unsigned Byte (%00111111)

  vand v6,v5,v1[e13] // V6 = bp6 Of r0..r7 (& $2000)
  vand v7,v5,v0[e13] // V7 = bp7 Of r0..r7 (& $0020)
  vmudn v7,v1[e9]    // V7 = bp7 Of r0..r7 << 9
  vor v8,v6[e0]      // V8 = bp0/bp1/bp2/bp3/bp4/bp5/bp6 Of r0..r7 In Unsigned Byte
  vor v8,v7[e0]      // V8 = bp0/bp1/bp2/bp3/bp4/bp5/bp6/bp7 Of r0..r7 In Unsigned Byte (%11111111)

// Store Column 5:
  addi a0,8
  suv v8[e0],0(a0) // Tile Row 5 = V8 Unsigned Bytes


// Vector Grab Column 6:
  vand v6,v2,v1[e14] // V6 = bp0 Of r0..r7 (& $4000)
  vand v7,v2,v0[e14] // V7 = bp1 Of r0..r7 (& $0040)
  vmudl v6,v1[e9]    // V6 = bp0 Of r0..r7 >> 7
  vmudn v7,v0[e10]   // V7 = bp1 Of r0..r7 << 2
  vor v8,v6,v7[e0]   // V8 = bp0/bp1 Of r0..r7 In Unsigned Byte (%00000011)

  vand v6,v3,v1[e14] // V6 = bp2 Of r0..r7 (& $4000)
  vand v7,v3,v0[e14] // V7 = bp3 Of r0..r7 (& $0040)
  vmudl v6,v1[e11]   // V6 = bp2 Of r0..r7 >> 5
  vmudn v7,v0[e12]   // V7 = bp3 Of r0..r7 << 4
  vor v8,v6[e0]      // V8 = bp0/bp1/bp2 Of r0..r7 In Unsigned Byte
  vor v8,v7[e0]      // V8 = bp0/bp1/bp2/bp3 Of r0..r7 In Unsigned Byte (%00001111)

  vand v6,v4,v1[e14] // V6 = bp4 Of r0..r7 (& $4000)
  vand v7,v4,v0[e14] // V7 = bp5 Of r0..r7 (& $0040)
  vmudl v6,v1[e13]   // V6 = bp4 Of r0..r7 >> 3
  vmudn v7,v0[e14]   // V7 = bp5 Of r0..r7 << 6
  vor v8,v6[e0]      // V8 = bp0/bp1/bp2/bp3/bp4 Of r0..r7 In Unsigned Byte
  vor v8,v7[e0]      // V8 = bp0/bp1/bp2/bp3/bp4/bp5 Of r0..r7 In Unsigned Byte (%00111111)

  vand v6,v5,v1[e14] // V6 = bp6 Of r0..r7 (& $4000)
  vand v7,v5,v0[e14] // V7 = bp7 Of r0..r7 (& $0040)
  vmudl v6,v1[e15]   // V6 = bp6 Of r0..r7 >> 1
  vmudn v7,v1[e8]    // V7 = bp7 Of r0..r7 << 8
  vor v8,v6[e0]      // V8 = bp0/bp1/bp2/bp3/bp4/bp5/bp6 Of r0..r7 In Unsigned Byte
  vor v8,v7[e0]      // V8 = bp0/bp1/bp2/bp3/bp4/bp5/bp6/bp7 Of r0..r7 In Unsigned Byte (%11111111)

// Store Column 6:
  addi a0,8
  suv v8[e0],0(a0) // Tile Row 6 = V8 Unsigned Bytes


// Vector Grab Column 7:
  vand v6,v2,v1[e15] // V6 = bp0 Of r0..r7 (& $8000)
  vand v7,v2,v0[e15] // V7 = bp1 Of r0..r7 (& $0080)
  vmudl v6,v1[e8]    // V6 = bp0 Of r0..r7 >> 8
  vmudn v7,v0[e9]    // V7 = bp1 Of r0..r7 << 1
  vor v8,v6,v7[e0]   // V8 = bp0/bp1 Of r0..r7 In Unsigned Byte (%00000011)

  vand v6,v3,v1[e15] // V6 = bp2 Of r0..r7 (& $8000)
  vand v7,v3,v0[e15] // V7 = bp3 Of r0..r7 (& $0080)
  vmudl v6,v1[e10]   // V6 = bp2 Of r0..r7 >> 6
  vmudn v7,v0[e11]   // V7 = bp3 Of r0..r7 << 3
  vor v8,v6[e0]      // V8 = bp0/bp1/bp2 Of r0..r7 In Unsigned Byte
  vor v8,v7[e0]      // V8 = bp0/bp1/bp2/bp3 Of r0..r7 In Unsigned Byte (%00001111)

  vand v6,v4,v1[e15] // V6 = bp4 Of r0..r7 (& $8000)
  vand v7,v4,v0[e15] // V7 = bp5 Of r0..r7 (& $0080)
  vmudl v6,v1[e12]   // V6 = bp4 Of r0..r7 >> 4
  vmudn v7,v0[e13]   // V7 = bp5 Of r0..r7 << 5
  vor v8,v6[e0]      // V8 = bp0/bp1/bp2/bp3/bp4 Of r0..r7 In Unsigned Byte
  vor v8,v7[e0]      // V8 = bp0/bp1/bp2/bp3/bp4/bp5 Of r0..r7 In Unsigned Byte (%00111111)

  vand v6,v5,v1[e15] // V6 = bp6 Of r0..r7 (& $8000)
  vand v7,v5,v0[e15] // V7 = bp7 Of r0..r7 (& $0080)
  vmudl v6,v1[e14]   // V6 = bp6 Of r0..r7 >> 2
  vmudn v7,v0[e15]   // V7 = bp7 Of r0..r7 << 7
  vor v8,v6[e0]      // V8 = bp0/bp1/bp2/bp3/bp4/bp5/bp6 Of r0..r7 In Unsigned Byte
  vor v8,v7[e0]      // V8 = bp0/bp1/bp2/bp3/bp4/bp5/bp6/bp7 Of r0..r7 In Unsigned Byte (%11111111)

// Store Column 7:
  addi a0,8
  suv v8[e0],0(a0) // Tile Row 7 = V8 Unsigned Bytes


  addi a0,8 // A0 = Next SNES Tile Offset

  bnez t1,LoopTiles8BPP // IF (Tile Counter != 0) Loop Tiles
  subi t1,1 // Decrement Tile Counter (Delay Slot)


  lli a0,0 // A0 = SP Memory Address Offset DMEM ($A4000000..$A4001FFF 8KB)
  lli t0,4095 // T0 = Length Of DMA Transfer In Bytes - 1

  mtc0 a0,c0 // Store Memory Offset To SP Memory Address Register ($A4040000)
  mtc0 a1,c1 // Store RAM Offset To SP DRAM Address Register ($A4040004)
  mtc0 t0,c3 // Store DMA Length To SP Write Length Register ($A404000C)

  TILEDMAWRITE8BPPBusy:
    mfc0 t0,c4 // T0 = RSP Status Register ($A4040010)
    andi t0,RSP_BSY|RSP_FUL // AND RSP Status Status With $C (Bit 2 = DMA Is Busy, Bit 3 = DMA Is Full)
    bnez t0,TILEDMAWRITE8BPPBusy // IF TRUE DMA Is Busy
    nop // Delay Slot

  addi a1,4096 // A1 = Next N64  Tile Offset
  addi a2,4096 // A2 = Next SNES Tile Offset

  bnez t2,LoopTile8BPPBlocks // IF (Tile Block Counter != 0) Loop Tile Blocks
  subi t2,1 // Decrement Tile Block Counter (Delay Slot)

  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
align(8) // Align 64-Bit
base RSPTILE8BPPCode+pc() // Set End Of RSP Code Object
RSPTILE8BPPCodeEnd:


align(8) // Align 64-Bit
RDPBG8BPPBuffer:
arch n64.rdp
// BG Column 0..32 / Row 0..28
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0

RDPSNESTILE8BPP:

  define y(0)
  while {y} < 29 {
    define x(0)
    while {x} < 33 {
      Sync_Tile // Sync Tile
      Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, N64TILE8BPP+(64*(({y}*32)+{x})) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Tile DRAM ADDRESS
      Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load Tile: SL,TL, Tile, SH,TH
      Texture_Rectangle_Flip (40+({x}*8))<<2,(16+({y}*8))<<2, 0, (32+({x}*8))<<2,(8+({y}*8))<<2, 0<<5,7<<5, 1<<10,-1<<10 // Texture Rectangle Flip: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

      evaluate x({x} + 1)
    }
    evaluate y({y} + 1)
  }

  Sync_Full // Ensure Entire Scene Is Fully Drawn
RDPBG8BPPBufferEnd: