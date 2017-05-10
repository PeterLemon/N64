align(8) // Align 64-Bit
N64TLUT:
  fill 512 // Generates 512 Bytes Containing $00

align(8) // Align 64-Bit
N64TILE:
  fill 65536*2 // Generates 65536*2 Bytes Containing $00

align(8) // Align 64-Bit
RSPPALData:
base $0000 // Set Base Of RSP Data Object To Zero

// Uses Whole Vector For 1st 8 Colors To Preserve SNES Palette Color 0 Alpha
// Uses Element 9 To OR Vector By Scalar $0001 For Other Colors
AlphaOR:
  dh $0000, $0001, $0001, $0001, $0001, $0001, $0001, $0001
  // 1 * $0000, 7 * $0001 (OR Alpha 1 Bit) (1st 8 Colors)
  // $0001 (OR Alpha 1 Bit) (Other Colors) (e9)

// Uses Elements 8..12 To AND Vector By Scalar
ANDByte:
  dh $00FF, $FF00, $001F, $03E0, $7C00, $0000, $0000, $0000
  // $00FF (AND Lo Byte) (e8)
  // $FF00 (AND Hi Byte) (e9)
  // $001F (AND Red   5 Bits) (e10)
  // $03E0 (AND Green 5 Bits) (e11)
  // $7C00 (AND Blue  5 Bits) (e12)

// Uses Elements 8..11 To Multiply Vector By Scalar For Pseudo Vector Shifts
PALShift:
  dh $0100, $0800, $0002, $0080
  // $0100 (Left Shift Using Multiply: << 8), (Right Shift Using Multiply: >> 8) (Big-Endian Convert) (e8)
  // $0800 (Left Shift Using Multiply: << 11) (Red) (e9)
  // $0002 (Left Shift Using Multiply: << 1)  (Green) (e10)
  // $0080 (Right Shift Using Multiply: >> 9) (Blue) (e11)

align(8) // Align 64-Bit
base RSPPALData+pc() // Set End Of RSP Data Object
RSPPALDataEnd:


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
ANDNibble:
  dh $000F, $0F00
  // $000F (AND Lo Nibble) (e8)
  // $0F00 (AND Hi Nibble) (e9)

align(8) // Align 64-Bit
base RSPSHIFTData+pc() // Set End Of RSP Data Object
RSPSHIFTDataEnd:


align(8) // Align 64-Bit
RSPPALCode:
arch n64.rsp
base $0000 // Set Base Of RSP Code Object To Zero

RSPPALStart:
// Load Static Palette Data
  lli a0,0 // A0 = Shift Start Offset
  la a1,RSPPALData // A1 = Aligned DRAM Physical RAM Offset ($00000000..$007FFFFF 8MB)
  li t0,(RSPPALDataEnd-RSPPALData)-1 // T0 = Length Of DMA Transfer In Bytes - 1

  mtc0 a0,c0 // Store Memory Offset To SP Memory Address Register ($A4040000)
  mtc0 a1,c1 // Store RAM Offset To SP DRAM Address Register ($A4040004)
  mtc0 t0,c2 // Store DMA Length To SP Read Length Register ($A4040008)

  PALDATADMAREADBusy:
    mfc0 t0,c4 // T0 = RSP Status Register ($A4040010)
    andi t0,RSP_BSY|RSP_FUL // AND RSP Status Status With $C (Bit 2 = DMA Is Busy, Bit 3 = DMA Is Full)
    bnez t0,PALDATADMAREADBusy // IF TRUE DMA Is Busy
    nop // Delay Slot

  lqv v0[e0],AlphaOR(r0)  // V0 = 1 * $0000, 7 * $0001 (OR Alpha 1 Bit) (128-Bit Quad)
  lqv v1[e0],ANDByte(r0)  // V1 = AND Lo/Hi/Red/Green/Blue Bytes (128-Bit Quad)
  ldv v2[e0],PALShift(r0) // V2 = Shift Using Multiply: Red/Green/Blue (64-Bit Double)

// Decode Colors
  lli a0,0 // A0 = Palette Start Offset
  la a1,N64TLUT // A1 = Aligned DRAM Physical RAM Offset ($00000000..$007FFFFF 8MB)
  la a2,CGRAM // A2 = Aligned DRAM Physical RAM Offset ($00000000..$007FFFFF 8MB)

  lli t0,511 // T0 = Length Of DMA Transfer In Bytes - 1
  lli t1,30 // T1 = Color Counter

  mtc0 a0,c0 // Store Memory Offset To SP Memory Address Register ($A4040000)
  mtc0 a2,c1 // Store RAM Offset To SP DRAM Address Register ($A4040004)
  mtc0 t0,c2 // Store DMA Length To SP Read Length Register ($A4040008)

  PALDMAREADBusy:
    mfc0 t0,c4 // T0 = RSP Status Register ($A4040010)
    andi t0,RSP_BSY|RSP_FUL // AND RSP Status Status With $C (Bit 2 = DMA Is Busy, Bit 3 = DMA Is Full)
    bnez t0,PALDMAREADBusy // IF TRUE DMA Is Busy
    nop // Delay Slot

// Vector Grab 1st 8 Colors:
  lqv v3[e0],0(a0) // V3 = Palette Colors 0..7

  vand v4,v3,v1[e8] // V4 = Lo Byte Color 0..7 (& $00FF)
  vand v5,v3,v1[e9] // V5 = Hi Byte Color 0..7 (& $FF00)
  vmudn v4,v2[e8]   // V4 = Lo Byte Color 0..7 << 8
  vmudl v5,v2[e8]   // V5 = Hi Byte Color 0..7 >> 8
  vor v4,v5[e0]     // V4 = Color 0..7 Big-Endian

  vand v5,v4,v1[e10] // V5 = RED 5 Bits, Color 0..7 (& $001F)
  vmudn v5,v2[e9]    // V5 = RED 5 Bits, Color 0..7 << 11

  vand v6,v4,v1[e11] // V6 = GREEN 5 Bits, Color 0..7 (& $03E0)
  vmudn v6,v2[e10]   // V6 = GREEN 5 Bits, Color 0..7 << 1
  vor v5,v6[e0]      // V5 = RED,GREEN 10 Bits, Color 0..7

  vand v6,v4,v1[e12] // V6 = BLUE 5 Bits, Color 0..7 (& $7C00)
  vmudl v6,v2[e11]   // V6 = BLUE 5 Bits, Color 0..7 >> 9
  vor v5,v6[e0]      // V5 = RED,GREEN,BLUE 15 Bits, Color 0..7
  vor v5,v0[e0]      // V5 = RED,GREEN,BLUE,ALPHA 16 Bits, Color 0..7

// Store Colors 0..7:
  sqv v5[e0],0(a0) // Palette Colors 0..8 = V5 Quad


LoopColors:
// Vector Grab Next 8 Colors:
  addi a0,16
  lqv v3[e0],0(a0) // V3 = Palette Colors 0..7

  vand v4,v3,v1[e8] // V4 = Lo Byte Color 0..7 (& $00FF)
  vand v5,v3,v1[e9] // V5 = Hi Byte Color 0..7 (& $FF00)
  vmudn v4,v2[e8]   // V4 = Lo Byte Color 0..7 << 8
  vmudl v5,v2[e8]   // V5 = Hi Byte Color 0..7 >> 8
  vor v4,v5[e0]     // V4 = Color 0..7 Big-Endian

  vand v5,v4,v1[e10] // V5 = RED 5 Bits, Color 0..7 (& $001F)
  vmudn v5,v2[e9]    // V5 = RED 5 Bits, Color 0..7 << 11

  vand v6,v4,v1[e11] // V6 = GREEN 5 Bits, Color 0..7 (& $03E0)
  vmudn v6,v2[e10]   // V6 = GREEN 5 Bits, Color 0..7 << 1
  vor v5,v6[e0]      // V5 = RED,GREEN 10 Bits, Color 0..7

  vand v6,v4,v1[e12] // V6 = BLUE 5 Bits, Color 0..7 (& $7C00)
  vmudl v6,v2[e11]   // V6 = BLUE 5 Bits, Color 0..7 >> 9
  vor v5,v6[e0]      // V5 = RED,GREEN,BLUE 15 Bits, Color 0..7
  vor v5,v0[e9]      // V5 = RED,GREEN,BLUE,ALPHA 16 Bits, Color 0..7

// Store Colors 0..7:
  sqv v5[e0],0(a0) // Palette Colors 0..8 = V5 Quad

  bnez t1,LoopColors // IF (Tile Counter != 0) Loop Colors
  subi t1,1 // Decrement Color Counter (Delay Slot)


  lli a0,0 // A0 = SP Memory Address Offset DMEM ($A4000000..$A4001FFF 8KB)
  lli t0,511 // T0 = Length Of DMA Transfer In Bytes - 1

  mtc0 a0,c0 // Store Memory Offset To SP Memory Address Register ($A4040000)
  mtc0 a1,c1 // Store RAM Offset To SP DRAM Address Register ($A4040004)
  mtc0 t0,c3 // Store DMA Length To SP Write Length Register ($A404000C)

  PALDMAWRITEBusy:
    mfc0 t0,c4 // T0 = RSP Status Register ($A4040010)
    andi t0,RSP_BSY|RSP_FUL // AND RSP Status Status With $C (Bit 2 = DMA Is Busy, Bit 3 = DMA Is Full)
    bnez t0,PALDMAWRITEBusy // IF TRUE DMA Is Busy
    nop // Delay Slot


  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
align(8) // Align 64-Bit
base RSPPALCode+pc() // Set End Of RSP Code Object
RSPPALCodeEnd:


align(8) // Align 64-Bit
RSPTILECode:
arch n64.rsp
base $0000 // Set Base Of RSP Code Object To Zero

RSPTILEStart:
// Load Static Shift Data
  lli a0,0 // A0 = Shift Start Offset
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
  llv v2[e0],ANDNibble(r0) // V2 = $000F (AND Lo Nibble), $0F00 (AND Hi Nibble) (32-Bit Long)

// Decode Tiles
  lli t2,1 // T2 = Tile Block Counter
  lli t3,3 // T3 = Tile Block Repeat Counter
  lli a0,0 // A0 = Tile Start Offset
  la a1,N64TILE // A1 = Aligned DRAM Physical RAM Offset ($00000000..$007FFFFF 8MB)
  la a2,VRAM // A2 = Aligned DRAM Physical RAM Offset ($00000000..$007FFFFF 8MB)

LoopTileBlocks:
  // Uses DMA To Copy 4096 Bytes To DMEM, For 2BPPSNES->4BPPN64
  lli t0,4095 // T0 = Length Of DMA Transfer In Bytes - 1
  lli t1,127 // T1 = Tile Counter

  mtc0 a0,c0 // Store Memory Offset To SP Memory Address Register ($A4040000)
  mtc0 a2,c1 // Store RAM Offset To SP DRAM Address Register ($A4040004)
  mtc0 t0,c2 // Store DMA Length To SP Read Length Register ($A4040008)

  TILEDMAREADBusy:
    mfc0 t0,c4 // T0 = RSP Status Register ($A4040010)
    andi t0,RSP_BSY|RSP_FUL // AND RSP Status Status With $C (Bit 2 = DMA Is Busy, Bit 3 = DMA Is Full)
    bnez t0,TILEDMAREADBusy // IF TRUE DMA Is Busy
    nop // Delay Slot

LoopTiles:
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
  addi a0,8
  suv v6[e0],0(a0) // Tile Row 1 = V6 Unsigned Bytes

// Pack Column 0,1 Nibbles:
  subi a0,8
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
  addi a0,8
  suv v6[e0],0(a0) // Tile Row 3 = V6 Unsigned Bytes

// Pack Column 2,3 Nibbles:
  subi a0,8
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
  addi a0,8
  suv v6[e0],0(a0) // Tile Row 5 = V6 Unsigned Bytes

// Pack Column 4,5 Nibbles:
  subi a0,8
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
  addi a0,8
  suv v6[e0],0(a0) // Tile Row 7 = V6 Unsigned Bytes

// Pack Column 6,7 Nibbles:
  subi a0,8
  lqv v4[e0],0(a0) // V4 = Column 6,7
  vand v5,v4,v2[e9] // V5 = Nibble Of Column 0 (& $0F00)
  vand v6,v4,v2[e8] // V6 = Nibble Of Column 1 (& $000F)
  vmudn v5,v0[e11]  // V5 = Nibble Of Column 6 << 3
  vmudn v6,v0[e15]  // V6 = Nibble Of Column 7 << 7
  vor v10,v5,v6[e0] // V10 = Packed Column 6,7 Byte


// Store Tile:
  suv v7[e0],0(a0)  // Tile Row 0,1 = V7 Unsigned Bytes
  addi a0,8
  suv v8[e0],0(a0)  // Tile Row 2,3 = V8 Unsigned Bytes
  addi a0,8
  suv v9[e0],0(a0)  // Tile Row 4,5 = V9 Unsigned Bytes
  addi a0,8
  suv v10[e0],0(a0) // Tile Row 6,7 = V10 Unsigned Bytes

  addi a0,8 // A0 = Next SNES Tile Offset

  bnez t1,LoopTiles // IF (Tile Counter != 0) Loop Tiles
  subi t1,1 // Decrement Tile Counter (Delay Slot)


  lli a0,0 // A0 = SP Memory Address Offset DMEM ($A4000000..$A4001FFF 8KB)
  // Uses DMA & Stride To Copy 128 Tiles (4096 Bytes) To RDRAM, 32 Bytes Per Tile, Followed by 32 Bytes Stride, For 2BPPSNES->4BPPN64
  li t0,(31 | (127<<12) | (32<<20)) // T0 = Length Of DMA Transfer In Bytes - 1, DMA Line Count - 1, Line Skip/Stride

  mtc0 a0,c0 // Store Memory Offset To SP Memory Address Register ($A4040000)
  mtc0 a1,c1 // Store RAM Offset To SP DRAM Address Register ($A4040004)
  mtc0 t0,c3 // Store DMA Length To SP Write Length Register ($A404000C)

  TILEDMAWRITEBusy:
    mfc0 t0,c4 // T0 = RSP Status Register ($A4040010)
    andi t0,RSP_BSY|RSP_FUL // AND RSP Status Status With $C (Bit 2 = DMA Is Busy, Bit 3 = DMA Is Full)
    bnez t0,TILEDMAWRITEBusy // IF TRUE DMA Is Busy
    nop // Delay Slot

  addi a1,32 // A1 = Next N64  Tile Offset
  addi a2,16 // A2 = Next SNES Tile Offset

  bnez t2,LoopTileBlocks // IF (Tile Block Counter != 0) Loop Tile Blocks
  subi t2,1 // Decrement Tile Block Counter (Delay Slot)


  lli t2,1 // T2 = Tile Block Counter
  lli a0,0 // A0 = Tile Start Offset
  addiu a1,8192-64 // A1 = Next N64  Tile Offset
  addiu a2,4096-32 // A2 = Next SNES Tile Offset

  bnez t3,LoopTileBlocks // IF (Tile Block Repeat Counter != 0) Loop Tile Blocks
  subi t3,1 // Decrement Tile Block Repeat Counter (Delay Slot)

  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
align(8) // Align 64-Bit
base RSPTILECode+pc() // Set End Of RSP Code Object
RSPTILECodeEnd:


align(8) // Align 64-Bit
RDPBuffer:
arch n64.rdp
  Set_Scissor 32<<2,8<<2, 0,0, 288<<2,232<<2 // Set Scissor: XH 32.0,YH 8.0, Scissor Field Enable Off,Field Off, XL 288.0,YL 232.0
  Set_Other_Modes CYCLE_TYPE_FILL // Set Other Modes
  Set_Color_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,320-1, $00100000 // Set Color Image: FORMAT RGBA,SIZE 16B,WIDTH 320, DRAM ADDRESS $00100000

RDPSNESCLEARCOL:
  Set_Fill_Color $00010001 // Set Fill Color: PACKED COLOR 16B R5G5B5A1 Pixels
  Fill_Rectangle 319<<2,239<<2, 0<<2,0<<2 // Fill Rectangle: XL 319.0,YL 239.0, XH 0.0,YH 0.0

  Set_Other_Modes EN_TLUT|SAMPLE_TYPE|BI_LERP_0|ALPHA_DITHER_SEL_NO_DITHER|B_M2A_0_1|FORCE_BLEND|IMAGE_READ_EN // Set Other Modes
  Set_Combine_Mode $0,$00, 0,0, $1,$01, $0,$F, 1,0, 0,0,0, 7,7,7 // Set Combine Mode: SubA RGB0,MulRGB0, SubA Alpha0,MulAlpha0, SubA RGB1,MulRGB1, SubB RGB0,SubB RGB1, SubA Alpha1,MulAlpha1, AddRGB0,SubB Alpha0,AddAlpha0, AddRGB1,SubB Alpha1,AddAlpha1

  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,1-1, N64TLUT // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 1, N64TLUT DRAM ADDRESS
  Set_Tile 0,0,0, $100, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: TMEM Address $100, Tile 0
  Load_Tlut 0<<2,0<<2, 0, 255<<2,0<<2 // Load Tlut: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 0.0
  Sync_Tile // Sync Tile

// BG Column 0..31 / Row 0..27
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,1, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0

RDPSNESTILE:

  define y(0)
  while {y} < 28 {
    define x(0)
    while {x} < 32 {
      Sync_Tile // Sync Tile
      Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,4-1, N64TILE+(32*(({y}*32)+{x})) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 4, Tile DRAM ADDRESS
      Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load Tile: SL,TL, Tile, SH,TH
      Texture_Rectangle_Flip (40+({x}*8))<<2,(16+({y}*8))<<2, 0, (32+({x}*8))<<2,(8+({y}*8))<<2, 0<<5,7<<5, 1<<10,-1<<10 // Texture Rectangle Flip: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

      evaluate x({x} + 1)
    }
    evaluate y({y} + 1)
  }

  Sync_Full // Ensure Entire Scene Is Fully Drawn
RDPBufferEnd: