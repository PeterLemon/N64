align(8) // Align 64-Bit
N64TLUT: // N64 TLUT
  fill 8 // Generates 8 Bytes Containing $00

align(8) // Align 64-Bit
N64TILE: // GB 2BPP Tiles -> N64 4BPP Linear Texture
  fill 65536*2 // Generates 65536*2 Bytes Containing $00


align(8) // Align 64-Bit
RSPSHIFTData:
base $0000 // Set Base Of RSP Data Object To Zero

// Uses Elements 8..15 To Multiply Vector By Scalar For Pseudo Vector Shifts
ShiftLeftRightA:
  dh $0001, $0002, $0004, $0008, $0010, $0020, $0040, $0080
  // $0001 (Left Shift Using Multiply: << 0),  (Right Shift Using Multiply: >> 16) (e8)
  // $0002 (Left Shift Using Multiply: << 1),  (Right Shift Using Multiply: >> 15) (e9)
  // $0004 (Left Shift Using Multiply: << 2),  (Right Shift Using Multiply: >> 14) (e10)
  // $0008 (Left Shift Using Multiply: << 3),  (Right Shift Using Multiply: >> 13) (e11)
  // $0010 (Left Shift Using Multiply: << 4),  (Right Shift Using Multiply: >> 12) (e12)
  // $0020 (Left Shift Using Multiply: << 5),  (Right Shift Using Multiply: >> 11) (e13)
  // $0040 (Left Shift Using Multiply: << 6),  (Right Shift Using Multiply: >> 10) (e14)
  // $0080 (Left Shift Using Multiply: << 7),  (Right Shift Using Multiply: >> 9)  (e15)
ShiftLeftRightB:
  dh $0100, $0200, $0400, $0800, $1000, $2000, $4000, $8000
  // $0100 (Left Shift Using Multiply: << 8),  (Right Shift Using Multiply: >> 8) (e8)
  // $0200 (Left Shift Using Multiply: << 9),  (Right Shift Using Multiply: >> 7) (e9)
  // $0400 (Left Shift Using Multiply: << 10), (Right Shift Using Multiply: >> 6) (e10)
  // $0800 (Left Shift Using Multiply: << 11), (Right Shift Using Multiply: >> 5) (e11)
  // $1000 (Left Shift Using Multiply: << 12), (Right Shift Using Multiply: >> 4) (e12)
  // $2000 (Left Shift Using Multiply: << 13), (Right Shift Using Multiply: >> 3) (e13)
  // $4000 (Left Shift Using Multiply: << 14), (Right Shift Using Multiply: >> 2) (e14)
  // $8000 (Left Shift Using Multiply: << 15), (Right Shift Using Multiply: >> 1) (e15)

// Uses Elements 8..9 To AND Lo/Hi Nibbles
ANDNibbleByte:
  dh $000F, $0F00, $00FF, $FF00, $0000, $0000, $0000, $0000
  // $000F (AND Lo Nibble) (e8)
  // $0F00 (AND Hi Nibble) (e9)
  // $00FF (AND Lo Byte) (e10)
  // $FF00 (AND Hi Byte) (e11)

align(8) // Align 64-Bit
base RSPSHIFTData+pc() // Set End Of RSP Data Object
RSPSHIFTDataEnd:

align(8) // Align 64-Bit
RSPTILEXBPPCode:
arch n64.rsp
base $0000 // Set Base Of RSP Code Object To Zero

RSPTILEXBPPStart:
// Load Static Shift Data
  ori a0,r0,0 // A0 = Shift Start Offset
  la a1,RSPSHIFTData // A1 = Aligned DRAM Physical RAM Offset ($00000000..$007FFFFF 8MB)
  li t0,(RSPSHIFTDataEnd-RSPSHIFTData)-1 // T0 = Length Of DMA Transfer In Bytes - 1

  mtc0 a0,c0 // Store Memory Offset To SP Memory Address Register ($A4040000)
  mtc0 a1,c1 // Store RAM Offset To SP DRAM Address Register ($A4040004)
  mtc0 t0,c2 // Store DMA Length To SP Read Length Register ($A4040008)

  SHIFTDMAREADBusy:
    mfc0 t0,c4 // T0 = RSP Status Register ($A4040010)
    andi t0,RSP_BSY|RSP_FUL // AND RSP Status Status With $C (Bit 2 = DMA Is Busy, Bit 3 = DMA Is Full)
    bnez t0,SHIFTDMAREADBusy // IF TRUE DMA Is Busy
    nop // Delay Slot

  lqv v0[e0],ShiftLeftRightA(r0) // V0 = Left Shift Using Multiply: << 0..7,  Right Shift Using Multiply: >> 16..9 (128-Bit Quad)
  lqv v1[e0],ShiftLeftRightB(r0) // V1 = Left Shift Using Multiply: << 8..15, Right Shift Using Multiply: >> 8..1  (128-Bit Quad)
  lqv v2[e0],ANDNibbleByte(r0)   // V2 = $000F, $0F00 (AND Lo/Hi Nibble), $00FF, $FF00 (AND Lo/Hi Byte), $001F, $03E0, $7C00 (AND R/G/B 5 Bits) (128-Bit Quad)

//-------------------
// Decode 2BPP Tiles
//-------------------
  ori t2,r0,1 // T2 = Tile Block Counter
  ori a0,r0,0 // A0 = Tile Start Offset
  la a1,N64TILE // A1 = Aligned DRAM Physical RAM Offset ($00000000..$007FFFFF 8MB)
  la a2,MEM_MAP+CHAR_RAM // A2 = Aligned DRAM Physical RAM Offset ($00000000..$007FFFFF 8MB)

LoopTile2BPPBlocks:
  // Uses DMA To Copy 4096 Bytes To DMEM, For 2BPPGB->4BPPN64
  ori t0,r0,4095 // T0 = Length Of DMA Transfer In Bytes - 1
  ori t1,r0,127 // T1 = Tile Counter

  mtc0 a0,c0 // Store Memory Offset To SP Memory Address Register ($A4040000)
  mtc0 a2,c1 // Store RAM Offset To SP DRAM Address Register ($A4040004)
  mtc0 t0,c2 // Store DMA Length To SP Read Length Register ($A4040008)

  TILEDMAREAD2BPPBusy:
    mfc0 t0,c4 // T0 = RSP Status Register ($A4040010)
    andi t0,RSP_BSY|RSP_FUL // AND RSP Status Status With $C (Bit 2 = DMA Is Busy, Bit 3 = DMA Is Full)
    bnez t0,TILEDMAREAD2BPPBusy // IF TRUE DMA Is Busy
    nop // Delay Slot

LoopTiles2BPP:
  lqv v3[e0],0(a0) // V3 = Tile BitPlane 0,1 Row 0..7

// Vector Grab Column 0:
  vand v4,v3,v1[e8] // V4 = bp0 Of r0..r7 (& $0100)
  vand v5,v3,v0[e8] // V5 = bp1 Of r0..r7 (& $0001)
  vmudl v4,v1[e15]  // V4 = bp0 Of r0..r7 >> 1
  vmudn v5,v1[e8]   // V5 = bp1 Of r0..r7 << 8
  vor v6,v4,v5[e0]  // V6 = bp0/bp1 Of r0..r7 In Unsigned Byte (%00000011)

// Store Column 0:
  suv v6[e0],0(a0) // Tile Row 0 = V6 Unsigned Bytes


// Vector Grab Column 1:
  vand v4,v3,v1[e9] // V4 = bp0 Of r0..r7 (& $0200)
  vand v5,v3,v0[e9] // V5 = bp1 Of r0..r7 (& $0002)
  vmudl v4,v1[e14]  // V4 = bp0 Of r0..r7 >> 2
  vmudn v5,v0[e15]  // V5 = bp1 Of r0..r7 << 7
  vor v6,v4,v5[e0]  // V6 = bp0/bp1 Of r0..r7 In Unsigned Byte (%00000011)

// Store Column 1:
  addiu a0,8
  suv v6[e0],0(a0) // Tile Row 1 = V6 Unsigned Bytes

// Pack Column 0,1 Nibbles:
  subiu a0,8
  lqv v4[e0],0(a0) // V4 = Column 0,1
  vand v5,v4,v2[e9] // V5 = Nibble Of Column 0 (& $0F00)
  vand v6,v4,v2[e8] // V6 = Nibble Of Column 1 (& $000F)
  vmudn v5,v0[e11]  // V5 = Nibble Of Column 0 << 3
  vmudn v6,v0[e15]  // V6 = Nibble Of Column 1 << 7
  vor v7,v5,v6[e0]  // V7 = Packed Column 0,1 Byte


// Vector Grab Column 2:
  vand v4,v3,v1[e10] // V4 = bp0 Of r0..r7 (& $0400)
  vand v5,v3,v0[e10] // V5 = bp1 Of r0..r7 (& $0004)
  vmudl v4,v1[e13]   // V4 = bp0 Of r0..r7 >> 3
  vmudn v5,v0[e14]   // V5 = bp1 Of r0..r7 << 6
  vor v6,v4,v5[e0]   // V6 = bp0/bp1 Of r0..r7 In Unsigned Byte (%00000011)

// Store Column 2:
  suv v6[e0],0(a0) // Tile Row 2 = V6 Unsigned Bytes


// Vector Grab Column 3:
  vand v4,v3,v1[e11] // V4 = bp0 Of r0..r7 (& $0800)
  vand v5,v3,v0[e11] // V5 = bp1 Of r0..r7 (& $0008)
  vmudl v4,v1[e12]   // V4 = bp0 Of r0..r7 >> 4
  vmudn v5,v0[e13]   // V5 = bp1 Of r0..r7 << 5
  vor v6,v4,v5[e0]   // V6 = bp0/bp1 Of r0..r7 In Unsigned Byte (%00000011)

// Store Column 3:
  addiu a0,8
  suv v6[e0],0(a0) // Tile Row 3 = V6 Unsigned Bytes

// Pack Column 2,3 Nibbles:
  subiu a0,8
  lqv v4[e0],0(a0) // V4 = Column 2,3
  vand v5,v4,v2[e9] // V5 = Nibble Of Column 0 (& $0F00)
  vand v6,v4,v2[e8] // V6 = Nibble Of Column 1 (& $000F)
  vmudn v5,v0[e11]  // V5 = Nibble Of Column 2 << 3
  vmudn v6,v0[e15]  // V6 = Nibble Of Column 3 << 7
  vor v8,v5,v6[e0]  // V8 = Packed Column 2,3 Byte


// Vector Grab Column 4:
  vand v4,v3,v1[e12] // V4 = bp0 Of r0..r7 (& $1000)
  vand v5,v3,v0[e12] // V5 = bp1 Of r0..r7 (& $0010)
  vmudl v4,v1[e11]   // V4 = bp0 Of r0..r7 >> 5
  vmudn v5,v0[e12]   // V5 = bp1 Of r0..r7 << 4
  vor v6,v4,v5[e0]   // V6 = bp0/bp1 Of r0..r7 In Unsigned Byte (%00000011)

// Store Column 4:
  suv v6[e0],0(a0) // Tile Row 4 = V6 Unsigned Bytes


// Vector Grab Column 5:
  vand v4,v3,v1[e13] // V4 = bp0 Of r0..r7 (& $2000)
  vand v5,v3,v0[e13] // V5 = bp1 Of r0..r7 (& $0020)
  vmudl v4,v1[e10]   // V4 = bp0 Of r0..r7 >> 6
  vmudn v5,v0[e11]   // V5 = bp1 Of r0..r7 << 3
  vor v6,v4,v5[e0]   // V6 = bp0/bp1 Of r0..r7 In Unsigned Byte (%00000011)

// Store Column 5:
  addiu a0,8
  suv v6[e0],0(a0) // Tile Row 5 = V6 Unsigned Bytes

// Pack Column 4,5 Nibbles:
  subiu a0,8
  lqv v4[e0],0(a0) // V4 = Column 4,5
  vand v5,v4,v2[e9] // V5 = Nibble Of Column 0 (& $0F00)
  vand v6,v4,v2[e8] // V6 = Nibble Of Column 1 (& $000F)
  vmudn v5,v0[e11]  // V5 = Nibble Of Column 4 << 3
  vmudn v6,v0[e15]  // V6 = Nibble Of Column 5 << 7
  vor v9,v5,v6[e0]  // V9 = Packed Column 4,5 Byte


// Vector Grab Column 6:
  vand v4,v3,v1[e14] // V4 = bp0 Of r0..r7 (& $4000)
  vand v5,v3,v0[e14] // V5 = bp1 Of r0..r7 (& $0040)
  vmudl v4,v1[e9]    // V4 = bp0 Of r0..r7 >> 7
  vmudn v5,v0[e10]   // V5 = bp1 Of r0..r7 << 2
  vor v6,v4,v5[e0]   // V6 = bp0/bp1 Of r0..r7 In Unsigned Byte (%00000011)

// Store Column 6:
  suv v6[e0],0(a0) // Tile Row 6 = V6 Unsigned Bytes


// Vector Grab Column 7:
  vand v4,v3,v1[e15] // V4 = bp0 Of r0..r7 (& $8000)
  vand v5,v3,v0[e15] // V5 = bp1 Of r0..r7 (& $0080)
  vmudl v4,v1[e8]    // V4 = bp0 Of r0..r7 >> 8
  vmudn v5,v0[e9]    // V5 = bp1 Of r0..r7 << 1
  vor v6,v4,v5[e0]   // V6 = bp0/bp1 Of r0..r7 In Unsigned Byte (%00000011)

// Store Column 7:
  addiu a0,8
  suv v6[e0],0(a0) // Tile Row 7 = V6 Unsigned Bytes

// Pack Column 6,7 Nibbles:
  subiu a0,8
  lqv v4[e0],0(a0) // V4 = Column 6,7
  vand v5,v4,v2[e9] // V5 = Nibble Of Column 0 (& $0F00)
  vand v6,v4,v2[e8] // V6 = Nibble Of Column 1 (& $000F)
  vmudn v5,v0[e11]  // V5 = Nibble Of Column 6 << 3
  vmudn v6,v0[e15]  // V6 = Nibble Of Column 7 << 7
  vor v10,v5,v6[e0] // V10 = Packed Column 6,7 Byte


// Store Tile:
  suv v7[e0],0(a0)  // Tile Row 0,1 = V7 Unsigned Bytes
  addiu a0,8
  suv v8[e0],0(a0)  // Tile Row 2,3 = V8 Unsigned Bytes
  addiu a0,8
  suv v9[e0],0(a0)  // Tile Row 4,5 = V9 Unsigned Bytes
  addiu a0,8
  suv v10[e0],0(a0) // Tile Row 6,7 = V10 Unsigned Bytes

  addiu a0,8 // A0 = Next GB Tile Offset

  bnez t1,LoopTiles2BPP // IF (Tile Counter != 0) Loop Tiles
  subiu t1,1 // Decrement Tile Counter (Delay Slot)


  ori a0,r0,0 // A0 = SP Memory Address Offset DMEM ($A4000000..$A4001FFF 8KB)
  // Uses DMA & Stride To Copy 128 Tiles (4096 Bytes) To RDRAM, 32 Bytes Per Tile, Followed by 32 Bytes Stride, For 2BPPGB->4BPPN64
  li t0,(31 | (127<<12) | (32<<20)) // T0 = Length Of DMA Transfer In Bytes - 1, DMA Line Count - 1, Line Skip/Stride

  mtc0 a0,c0 // Store Memory Offset To SP Memory Address Register ($A4040000)
  mtc0 a1,c1 // Store RAM Offset To SP DRAM Address Register ($A4040004)
  mtc0 t0,c3 // Store DMA Length To SP Write Length Register ($A404000C)

  TILEDMAWRITE2BPPBusy:
    mfc0 t0,c4 // T0 = RSP Status Register ($A4040010)
    andi t0,RSP_BSY|RSP_FUL // AND RSP Status Status With $C (Bit 2 = DMA Is Busy, Bit 3 = DMA Is Full)
    bnez t0,TILEDMAWRITE2BPPBusy // IF TRUE DMA Is Busy
    nop // Delay Slot

  addiu a1,32 // A1 = Next N64  Tile Offset
  addiu a2,16 // A2 = Next GB Tile Offset

  bnez t2,LoopTile2BPPBlocks // IF (Tile Block Counter != 0) Loop Tile Blocks
  subiu t2,1 // Decrement Tile Block Counter (Delay Slot)


  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
align(8) // Align 64-Bit
base RSPTILEXBPPCode+pc() // Set End Of RSP Code Object
RSPTILEXBPPCodeEnd: