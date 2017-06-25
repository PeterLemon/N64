align(8) // Align 64-Bit
N64TLUT8BPP: // N64 TLUT 8BPP (Alpha = 0 On 1st Color Of 256 Color Pallete)
  fill 512 // Generates 512 Bytes Containing $00
N64TLUT4BPP: // N64 TLUT 4BPP (Alpha = 0 On 1st Color Of 16 Color Palette)
  fill 512 // Generates 512 Bytes Containing $00
N64TLUT2BPP: // N64 TLUT 2BPP (Alpha = 0 On 1st Color Of 4 Color Palette, Padded for use with TLUT)
  fill 1024 // Generates 1024 Bytes Containing $00

align(8) // Align 64-Bit
N64TILE2BPP: // SNES 2BPP Tiles -> N64 4BPP Linear Texture
  fill 65536*2 // Generates 65536*2 Bytes Containing $00

align(8) // Align 64-Bit
N64TILE4BPP: // SNES 4BPP Tiles -> N64 4BPP Linear Texture
  fill 65536 // Generates 65536 Bytes Containing $00

align(8) // Align 64-Bit
N64TILE8BPP: // SNES 8BPP Tiles -> N64 8BPP Linear Texture
  fill 65536 // Generates 65536 Bytes Containing $00

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
  dh $000F, $0F00, $00FF, $FF00, $001F, $03E0, $7C00, $0000
  // $000F (AND Lo Nibble) (e8)
  // $0F00 (AND Hi Nibble) (e9)
  // $00FF (AND Lo Byte) (e10)
  // $FF00 (AND Hi Byte) (e11)
  // $001F (AND Red   5 Bits) (e12)
  // $03E0 (AND Green 5 Bits) (e13)
  // $7C00 (AND Blue  5 Bits) (e14)

AlphaAND2BPP: // 8BPP TLUT -> 2BPP TLUT
  dh $FFFE, $FFFF, $FFFF, $FFFF, $FFFE, $FFFF, $FFFF, $FFFF
  // 1 * $FFFE, 3 * $FFFF, 1 * $FFFE, 3 * $FFFF (AND Alpha 1 Bit)

AlphaAND4BPP: // 8BPP TLUT -> 4BPP TLUT
  dh $FFFE, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF
  // 1 * $FFFE, 7 * $FFFF (AND Alpha 1 Bit)

// Uses Whole Vector For 1st 8 Colors To Preserve SNES Palette Color 0 Alpha
// Uses Element 9 To OR Vector By Scalar $0001 For Other Colors
AlphaOR:
  dh $0000, $0001, $0001, $0001, $0001, $0001, $0001, $0001
  // 1 * $0000, 7 * $0001 (OR Alpha 1 Bit) (1st 8 Colors)
  // $0001 (OR Alpha 1 Bit) (Other Colors) (e9)

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
  lqv v29[e0],AlphaAND2BPP(r0)   // V29 = 1 * $FFFE, 3 * $FFFF, 1 * $FFFE, 3 * $FFFF (AND Alpha 1 Bit) (128-Bit Quad)
  lqv v30[e0],AlphaAND4BPP(r0)   // V30 = 1 * $FFFE, 7 * $FFFF (AND Alpha 1 Bit) (128-Bit Quad)
  lqv v31[e0],AlphaOR(r0)        // V31 = 1 * $0000, 7 * $0001 (OR Alpha 1 Bit) (128-Bit Quad)


//--------------------
// Decode 8BPP Colors
//--------------------
  ori a0,r0,0 // A0 = 8BPP Palette Start Offset
  la a1,CGRAM // A1 = Aligned DRAM Physical RAM Offset ($00000000..$007FFFFF 8MB)
  ori t0,r0,511 // T0 = Length Of DMA Transfer In Bytes - 1

  mtc0 a0,c0 // Store Memory Offset To SP Memory Address Register ($A4040000)
  mtc0 a1,c1 // Store RAM Offset To SP DRAM Address Register ($A4040004)
  mtc0 t0,c2 // Store DMA Length To SP Read Length Register ($A4040008)

  PAL8BPPDMAREADBusy:
    mfc0 t0,c4 // T0 = RSP Status Register ($A4040010)
    andi t0,RSP_BSY|RSP_FUL // AND RSP Status Status With $C (Bit 2 = DMA Is Busy, Bit 3 = DMA Is Full)
    bnez t0,PAL8BPPDMAREADBusy // IF TRUE DMA Is Busy
    nop // Delay Slot

  ori t0,r0,30 // T0 = Color Counter

  // Vector Grab 1st 8 Colors:
  lqv v3[e0],0(a0) // V3 = Palette Colors 0..7

  vand v4,v3,v2[e10] // V4 = Lo Byte Color 0..7 (& $00FF)
  vand v5,v3,v2[e11] // V5 = Hi Byte Color 0..7 (& $FF00)
  vmudn v4,v1[e8]    // V4 = Lo Byte Color 0..7 << 8
  vmudl v5,v1[e8]    // V5 = Hi Byte Color 0..7 >> 8
  vor v4,v5[e0]      // V4 = Color 0..7 Big-Endian

  vand v5,v4,v2[e12] // V5 = RED 5 Bits, Color 0..7 (& $001F)
  vmudn v5,v1[e11]   // V5 = RED 5 Bits, Color 0..7 << 11

  vand v6,v4,v2[e13] // V6 = GREEN 5 Bits, Color 0..7 (& $03E0)
  vmudn v6,v0[e9]    // V6 = GREEN 5 Bits, Color 0..7 << 1
  vor v5,v6[e0]      // V5 = RED,GREEN 10 Bits, Color 0..7

  vand v6,v4,v2[e14] // V6 = BLUE 5 Bits, Color 0..7 (& $7C00)
  vmudl v6,v0[e15]   // V6 = BLUE 5 Bits, Color 0..7 >> 9
  vor v5,v6[e0]      // V5 = RED,GREEN,BLUE 15 Bits, Color 0..7
  vor v5,v31[e0]     // V5 = RED,GREEN,BLUE,ALPHA 16 Bits, Color 0..7

  // Store Colors 0..7:
  sqv v5[e0],0(a0) // Palette Colors 0..7 = V5 Quad

Loop8BPPColors:
  // Vector Grab Next 8 Colors:
  addiu a0,16
  lqv v3[e0],0(a0) // V3 = Palette Colors 0..7

  vand v4,v3,v2[e10] // V4 = Lo Byte Color 0..7 (& $00FF)
  vand v5,v3,v2[e11] // V5 = Hi Byte Color 0..7 (& $FF00)
  vmudn v4,v1[e8]    // V4 = Lo Byte Color 0..7 << 8
  vmudl v5,v1[e8]    // V5 = Hi Byte Color 0..7 >> 8
  vor v4,v5[e0]      // V4 = Color 0..7 Big-Endian

  vand v5,v4,v2[e12] // V5 = RED 5 Bits, Color 0..7 (& $001F)
  vmudn v5,v1[e11]   // V5 = RED 5 Bits, Color 0..7 << 11

  vand v6,v4,v2[e13] // V6 = GREEN 5 Bits, Color 0..7 (& $03E0)
  vmudn v6,v0[e9]    // V6 = GREEN 5 Bits, Color 0..7 << 1
  vor v5,v6[e0]      // V5 = RED,GREEN 10 Bits, Color 0..7

  vand v6,v4,v2[e14] // V6 = BLUE 5 Bits, Color 0..7 (& $7C00)
  vmudl v6,v0[e15]   // V6 = BLUE 5 Bits, Color 0..7 >> 9
  vor v5,v6[e0]      // V5 = RED,GREEN,BLUE 15 Bits, Color 0..7
  vor v5,v31[e9]     // V5 = RED,GREEN,BLUE,ALPHA 16 Bits, Color 0..7

  // Store Colors 0..7:
  sqv v5[e0],0(a0) // Palette Colors 0..7 = V5 Quad

  bnez t0,Loop8BPPColors // IF (Tile Counter != 0) Loop Colors
  subiu t0,1 // Decrement Color Counter (Delay Slot)


//--------------------
// Decode 4BPP Colors
//--------------------
  ori a0,r0,0 // A0 = 8BPP Palette Start Offset
  ori t0,r0,15 // T0 = Color Counter

Loop4BPPColors:
  // Vector Grab 1st 8 Colors:
  lqv v3[e0],0(a0) // V3 = Palette Colors 0..7
  vand v3,v30[e0]  // V3 = RED,GREEN,BLUE,ALPHA 16 Bits, Color 0..7

  // Store Colors 0..7:
  sqv v3[e0],512(a0) // Palette Colors 0..7 = V3 Quad

  // Vector Grab Next 8 Colors:
  lqv v3[e0],16(a0) // V3 = Palette Colors 0..7

  // Store Colors 0..7:
  sqv v3[e0],528(a0) // Palette Colors 0..7 = V3 Quad

  addiu a0,32
  bnez t0,Loop4BPPColors // IF (Tile Counter != 0) Loop Colors
  subiu t0,1 // Decrement Color Counter (Delay Slot)


//--------------------
// Decode 2BPP Colors
//--------------------
  ori a0,r0,512 // A0 = 4BPP Palette Start Offset
  ori t0,r0,15 // T0 = Color Counter

Loop2BPPColors:
  // Vector Grab 8 Colors:
  lqv v3[e0],0(a0) // V3 = Palette Colors 0..7
  vand v3,v29[e0]  // V3 = RED,GREEN,BLUE,ALPHA 16 Bits, Color 0..7

  // Store Colors 0..7:
  sqv v3[e0],512(a0) // Palette Colors 0..7 = V3 Quad

  addiu a0,16
  bnez t0,Loop2BPPColors // IF (Tile Counter != 0) Loop Colors
  subiu t0,1 // Decrement Color Counter (Delay Slot)


  // DMA 8BPP & 4BPP TLUT
  ori a0,r0,0 // A0 = SP Memory Address Offset DMEM ($A4000000..$A4001FFF 8KB)
  la a1,N64TLUT8BPP // A1 = Aligned DRAM Physical RAM Offset ($00000000..$007FFFFF 8MB)
  ori t0,r0,1023 // T0 = Length Of DMA Transfer In Bytes - 1

  mtc0 a0,c0 // Store Memory Offset To SP Memory Address Register ($A4040000)
  mtc0 a1,c1 // Store RAM Offset To SP DRAM Address Register ($A4040004)
  mtc0 t0,c3 // Store DMA Length To SP Write Length Register ($A404000C)

  PALDMAWRITEBusy:
    mfc0 t0,c4 // T0 = RSP Status Register ($A4040010)
    andi t0,RSP_BSY|RSP_FUL // AND RSP Status Status With $C (Bit 2 = DMA Is Busy, Bit 3 = DMA Is Full)
    bnez t0,PALDMAWRITEBusy // IF TRUE DMA Is Busy
    nop // Delay Slot

  // DMA With Stride 2BPP TLUT
  ori a0,r0,1024 // A0 = SP Memory Address Offset DMEM ($A4000000..$A4001FFF 8KB)
  la a1,N64TLUT2BPP // A1 = Aligned DRAM Physical RAM Offset ($00000000..$007FFFFF 8MB)
  li t0,(7 | (31<<12) | (24<<20)) // T0 = Length Of DMA Transfer In Bytes - 1, DMA Line Count - 1, Line Skip/Stride

  mtc0 a0,c0 // Store Memory Offset To SP Memory Address Register ($A4040000)
  mtc0 a1,c1 // Store RAM Offset To SP DRAM Address Register ($A4040004)
  mtc0 t0,c3 // Store DMA Length To SP Write Length Register ($A404000C)

  PAL2BPPDMAWRITEBusy:
    mfc0 t0,c4 // T0 = RSP Status Register ($A4040010)
    andi t0,RSP_BSY|RSP_FUL // AND RSP Status Status With $C (Bit 2 = DMA Is Busy, Bit 3 = DMA Is Full)
    bnez t0,PAL2BPPDMAWRITEBusy // IF TRUE DMA Is Busy
    nop // Delay Slot


//-------------------
// Decode 2BPP Tiles
//-------------------
  ori t2,r0,1 // T2 = Tile Block Counter
  ori t3,r0,3 // T3 = Tile Block Repeat Counter
  ori a0,r0,0 // A0 = Tile Start Offset
  la a1,N64TILE2BPP // A1 = Aligned DRAM Physical RAM Offset ($00000000..$007FFFFF 8MB)
  la a2,VRAM // A2 = Aligned DRAM Physical RAM Offset ($00000000..$007FFFFF 8MB)

LoopTile2BPPBlocks:
  // Uses DMA To Copy 4096 Bytes To DMEM, For 2BPPSNES->4BPPN64
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

  addiu a0,8 // A0 = Next SNES Tile Offset

  bnez t1,LoopTiles2BPP // IF (Tile Counter != 0) Loop Tiles
  subiu t1,1 // Decrement Tile Counter (Delay Slot)


  ori a0,r0,0 // A0 = SP Memory Address Offset DMEM ($A4000000..$A4001FFF 8KB)
  // Uses DMA & Stride To Copy 128 Tiles (4096 Bytes) To RDRAM, 32 Bytes Per Tile, Followed by 32 Bytes Stride, For 2BPPSNES->4BPPN64
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
  addiu a2,16 // A2 = Next SNES Tile Offset

  bnez t2,LoopTile2BPPBlocks // IF (Tile Block Counter != 0) Loop Tile Blocks
  subiu t2,1 // Decrement Tile Block Counter (Delay Slot)


  ori t2,r0,1 // T2 = Tile Block Counter
  ori a0,r0,0 // A0 = Tile Start Offset
  addiu a1,8192-64 // A1 = Next N64  Tile Offset
  addiu a2,4096-32 // A2 = Next SNES Tile Offset

  bnez t3,LoopTile2BPPBlocks // IF (Tile Block Repeat Counter != 0) Loop Tile Blocks
  subiu t3,1 // Decrement Tile Block Repeat Counter (Delay Slot)


//-------------------
// Decode 4BPP Tiles
//-------------------
  ori t2,r0,15 // T2 = Tile Block Counter
  ori a0,r0,0 // A0 = Tile Start Offset
  la a1,N64TILE4BPP // A1 = Aligned DRAM Physical RAM Offset ($00000000..$007FFFFF 8MB)
  la a2,VRAM // A2 = Aligned DRAM Physical RAM Offset ($00000000..$007FFFFF 8MB)

LoopTile4BPPBlocks:
  // Uses DMA To Copy 4096 Bytes To DMEM, For 4BPPSNES->4BPPN64
  ori t0,r0,4095 // T0 = Length Of DMA Transfer In Bytes - 1
  ori t1,r0,127 // T1 = Tile Counter

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
  addiu a0,8
  suv v7[e0],0(a0) // Tile Row 1 = V7 Unsigned Bytes

// Pack Column 0,1 Nibbles:
  subiu a0,8
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
  addiu a0,8
  suv v7[e0],0(a0) // Tile Row 3 = V7 Unsigned Bytes

// Pack Column 2,3 Nibbles:
  subiu a0,8
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
  addiu a0,8
  suv v7[e0],0(a0) // Tile Row 5 = V7 Unsigned Bytes

// Pack Column 4,5 Nibbles:
  subiu a0,8
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
  addiu a0,8
  suv v7[e0],0(a0) // Tile Row 7 = V7 Unsigned Bytes

// Pack Column 6,7 Nibbles:
  subiu a0,8
  lqv v5[e0],0(a0)  // V5 = Column 6,7
  vand v6,v5,v2[e9] // V6 = Nibble Of Column 0 (& $0F00)
  vand v7,v5,v2[e8] // V7 = Nibble Of Column 1 (& $000F)
  vmudn v6,v0[e11]  // V6 = Nibble Of Column 6 << 3
  vmudn v7,v0[e15]  // V7 = Nibble Of Column 7 << 7
  vor v11,v6,v7[e0] // V11 = Packed Column 6,7 Byte


// Store Tile:
  suv v8[e0],0(a0)  // Tile Row 0,1 = V8 Unsigned Bytes
  addiu a0,8
  suv v9[e0],0(a0)  // Tile Row 2,3 = V9 Unsigned Bytes
  addiu a0,8
  suv v10[e0],0(a0) // Tile Row 4,5 = V10 Unsigned Bytes
  addiu a0,8
  suv v11[e0],0(a0) // Tile Row 6,7 = V11 Unsigned Bytes

  addiu a0,8 // A0 = Next SNES Tile Offset

  bnez t1,LoopTiles4BPP // IF (Tile Counter != 0) Loop Tiles
  subiu t1,1 // Decrement Tile Counter (Delay Slot)


  ori a0,r0,0 // A0 = SP Memory Address Offset DMEM ($A4000000..$A4001FFF 8KB)
  ori t0,r0,4095 // T0 = Length Of DMA Transfer In Bytes - 1

  mtc0 a0,c0 // Store Memory Offset To SP Memory Address Register ($A4040000)
  mtc0 a1,c1 // Store RAM Offset To SP DRAM Address Register ($A4040004)
  mtc0 t0,c3 // Store DMA Length To SP Write Length Register ($A404000C)

  TILEDMAWRITE4BPPBusy:
    mfc0 t0,c4 // T0 = RSP Status Register ($A4040010)
    andi t0,RSP_BSY|RSP_FUL // AND RSP Status Status With $C (Bit 2 = DMA Is Busy, Bit 3 = DMA Is Full)
    bnez t0,TILEDMAWRITE4BPPBusy // IF TRUE DMA Is Busy
    nop // Delay Slot

  addiu a1,4096 // A1 = Next N64  Tile Offset
  addiu a2,4096 // A2 = Next SNES Tile Offset

  bnez t2,LoopTile4BPPBlocks // IF (Tile Block Counter != 0) Loop Tile Blocks
  subiu t2,1 // Decrement Tile Block Counter (Delay Slot)


//-------------------
// Decode 8BPP Tiles
//-------------------
  ori t2,r0,15 // T2 = Tile Block Counter
  ori a0,r0,0 // A0 = Tile Start Offset
  la a1,N64TILE8BPP // A1 = Aligned DRAM Physical RAM Offset ($00000000..$007FFFFF 8MB)
  la a2,VRAM // A2 = Aligned DRAM Physical RAM Offset ($00000000..$007FFFFF 8MB)

LoopTile8BPPBlocks:
  // Uses DMA To Copy 4096 Bytes To DMEM, For 8BPPSNES->8BPPN64
  ori t0,r0,4095 // T0 = Length Of DMA Transfer In Bytes - 1
  ori t1,r0,63 // T1 = Tile Counter

  mtc0 a0,c0 // Store Memory Offset To SP Memory Address Register ($A4040000)
  mtc0 a2,c1 // Store RAM Offset To SP DRAM Address Register ($A4040004)
  mtc0 t0,c2 // Store DMA Length To SP Read Length Register ($A4040008)

  TILEDMAREAD8BPPBusy:
    mfc0 t0,c4 // T0 = RSP Status Register ($A4040010)
    andi t0,RSP_BSY|RSP_FUL // AND RSP Status Status With $C (Bit 2 = DMA Is Busy, Bit 3 = DMA Is Full)
    bnez t0,TILEDMAREAD8BPPBusy // IF TRUE DMA Is Busy
    nop // Delay Slot

LoopTiles8BPP:
  lqv v3[e0],$00(a0) // V3 = Tile BitPlane 0,1 Row 0..7
  lqv v4[e0],$10(a0) // V4 = Tile BitPlane 2,3 Row 0..7
  lqv v5[e0],$20(a0) // V5 = Tile BitPlane 4,5 Row 0..7
  lqv v6[e0],$30(a0) // V6 = Tile BitPlane 6,7 Row 0..7

// Vector Grab Column 0:
  vand v7,v3,v1[e8] // V7 = bp0 Of r0..r7 (& $0100)
  vand v8,v3,v0[e8] // V8 = bp1 Of r0..r7 (& $0001)
  vmudl v7,v1[e15]  // V7 = bp0 Of r0..r7 >> 1
  vmudn v8,v1[e8]   // V8 = bp1 Of r0..r7 << 8
  vor v9,v7,v8[e0]  // V9 = bp0/bp1 Of r0..r7 In Unsigned Byte (%00000011)

  vand v7,v4,v1[e8] // V7 = bp2 Of r0..r7 (& $0100)
  vand v8,v4,v0[e8] // V8 = bp3 Of r0..r7 (& $0001)
  vmudn v7,v0[e9]   // V7 = bp2 Of r0..r7 << 1
  vmudn v8,v1[e10]  // V8 = bp3 Of r0..r7 << 10
  vor v9,v7[e0]     // V9 = bp0/bp1/bp2 Of r0..r7 In Unsigned Byte
  vor v9,v8[e0]     // V9 = bp0/bp1/bp2/bp3 Of r0..r7 In Unsigned Byte (%00001111)

  vand v7,v5,v1[e8] // V7 = bp4 Of r0..r7 (& $0100)
  vand v8,v5,v0[e8] // V8 = bp5 Of r0..r7 (& $0001)
  vmudn v7,v0[e11]  // V7 = bp4 Of r0..r7 << 3
  vmudn v8,v1[e12]  // V8 = bp5 Of r0..r7 << 12
  vor v9,v7[e0]     // V9 = bp0/bp1/bp2/bp3/bp4 Of r0..r7 In Unsigned Byte
  vor v9,v8[e0]     // V9 = bp0/bp1/bp2/bp3/bp4/bp5 Of r0..r7 In Unsigned Byte (%00111111)

  vand v7,v6,v1[e8] // V7 = bp6 Of r0..r7 (& $0100)
  vand v8,v6,v0[e8] // V8 = bp7 Of r0..r7 (& $0001)
  vmudn v7,v0[e13]  // V7 = bp6 Of r0..r7 << 5
  vmudn v8,v1[e14]  // V8 = bp7 Of r0..r7 << 14
  vor v9,v7[e0]     // V9 = bp0/bp1/bp2/bp3/bp4/bp5/bp6 Of r0..r7 In Unsigned Byte
  vor v9,v8[e0]     // V9 = bp0/bp1/bp2/bp3/bp4/bp5/bp6/bp7 Of r0..r7 In Unsigned Byte (%11111111)

// Store Column 0:
  suv v9[e0],0(a0) // Tile Row 0 = V8 Unsigned Bytes


// Vector Grab Column 1:
  vand v7,v3,v1[e9] // V7 = bp0 Of r0..r7 (& $0200)
  vand v8,v3,v0[e9] // V8 = bp1 Of r0..r7 (& $0002)
  vmudl v7,v1[e14]  // V7 = bp0 Of r0..r7 >> 2
  vmudn v8,v0[e15]  // V8 = bp1 Of r0..r7 << 7
  vor v9,v7,v8[e0]  // V9 = bp0/bp1 Of r0..r7 In Unsigned Byte (%00000011)

  vand v7,v4,v1[e9] // V7 = bp2 Of r0..r7 (& $0200)
  vand v8,v4,v0[e9] // V8 = bp3 Of r0..r7 (& $0002)
  vmudn v8,v1[e9]   // V8 = bp3 Of r0..r7 << 9
  vor v9,v7[e0]     // V9 = bp0/bp1/bp2 Of r0..r7 In Unsigned Byte
  vor v9,v8[e0]     // V9 = bp0/bp1/bp2/bp3 Of r0..r7 In Unsigned Byte (%00001111)

  vand v7,v5,v1[e9] // V7 = bp4 Of r0..r7 (& $0200)
  vand v8,v5,v0[e9] // V8 = bp5 Of r0..r7 (& $0002)
  vmudn v7,v0[e10]  // V7 = bp4 Of r0..r7 << 2
  vmudn v8,v1[e11]  // V8 = bp5 Of r0..r7 << 11
  vor v9,v7[e0]     // V9 = bp0/bp1/bp2/bp3/bp4 Of r0..r7 In Unsigned Byte
  vor v9,v8[e0]     // V9 = bp0/bp1/bp2/bp3/bp4/bp5 Of r0..r7 In Unsigned Byte (%00111111)

  vand v7,v6,v1[e9] // V7 = bp6 Of r0..r7 (& $0200)
  vand v8,v6,v0[e9] // V8 = bp7 Of r0..r7 (& $0002)
  vmudn v7,v0[e12]  // V7 = bp6 Of r0..r7 << 4
  vmudn v8,v1[e13]  // V8 = bp7 Of r0..r7 << 13
  vor v9,v7[e0]     // V9 = bp0/bp1/bp2/bp3/bp4/bp5/bp6 Of r0..r7 In Unsigned Byte
  vor v9,v8[e0]     // V9 = bp0/bp1/bp2/bp3/bp4/bp5/bp6/bp7 Of r0..r7 In Unsigned Byte (%11111111)

// Store Column 1:
  addiu a0,8
  suv v9[e0],0(a0) // Tile Row 1 = V8 Unsigned Bytes


// Vector Grab Column 2:
  vand v7,v3,v1[e10] // V7 = bp0 Of r0..r7 (& $0400)
  vand v8,v3,v0[e10] // V8 = bp1 Of r0..r7 (& $0004)
  vmudl v7,v1[e13]   // V7 = bp0 Of r0..r7 >> 3
  vmudn v8,v0[e14]   // V8 = bp1 Of r0..r7 << 6
  vor v9,v7,v8[e0]   // V9 = bp0/bp1 Of r0..r7 In Unsigned Byte (%00000011)

  vand v7,v4,v1[e10] // V7 = bp2 Of r0..r7 (& $0400)
  vand v8,v4,v0[e10] // V8 = bp3 Of r0..r7 (& $0004)
  vmudl v7,v1[e15]   // V7 = bp2 Of r0..r7 >> 1
  vmudn v8,v1[e8]    // V8 = bp3 Of r0..r7 << 8
  vor v9,v7[e0]      // V9 = bp0/bp1/bp2 Of r0..r7 In Unsigned Byte
  vor v9,v8[e0]      // V9 = bp0/bp1/bp2/bp3 Of r0..r7 In Unsigned Byte (%00001111)

  vand v7,v5,v1[e10] // V7 = bp4 Of r0..r7 (& $0400)
  vand v8,v5,v0[e10] // V8 = bp5 Of r0..r7 (& $0004)
  vmudn v7,v0[e9]    // V7 = bp4 Of r0..r7 << 1
  vmudn v8,v1[e10]   // V8 = bp5 Of r0..r7 << 10
  vor v9,v7[e0]      // V9 = bp0/bp1/bp2/bp3/bp4 Of r0..r7 In Unsigned Byte
  vor v9,v8[e0]      // V9 = bp0/bp1/bp2/bp3/bp4/bp5 Of r0..r7 In Unsigned Byte (%00111111)

  vand v7,v6,v1[e10] // V7 = bp6 Of r0..r7 (& $0400)
  vand v8,v6,v0[e10] // V8 = bp7 Of r0..r7 (& $0004)
  vmudn v7,v0[e11]   // V7 = bp6 Of r0..r7 << 3
  vmudn v8,v1[e12]   // V8 = bp7 Of r0..r7 << 12
  vor v9,v7[e0]      // V9 = bp0/bp1/bp2/bp3/bp4/bp5/bp6 Of r0..r7 In Unsigned Byte
  vor v9,v8[e0]      // V9 = bp0/bp1/bp2/bp3/bp4/bp5/bp6/bp7 Of r0..r7 In Unsigned Byte (%11111111)

// Store Column 2:
  addiu a0,8
  suv v9[e0],0(a0) // Tile Row 2 = V8 Unsigned Bytes


// Vector Grab Column 3:
  vand v7,v3,v1[e11] // V7 = bp0 Of r0..r7 (& $0800)
  vand v8,v3,v0[e11] // V8 = bp1 Of r0..r7 (& $0008)
  vmudl v7,v1[e12]   // V7 = bp0 Of r0..r7 >> 4
  vmudn v8,v0[e13]   // V8 = bp1 Of r0..r7 << 5
  vor v9,v7,v8[e0]   // V9 = bp0/bp1 Of r0..r7 In Unsigned Byte (%00000011)

  vand v7,v4,v1[e11] // V7 = bp2 Of r0..r7 (& $0800)
  vand v8,v4,v0[e11] // V8 = bp3 Of r0..r7 (& $0008)
  vmudl v7,v1[e14]   // V7 = bp2 Of r0..r7 >> 2
  vmudn v8,v0[e15]   // V8 = bp3 Of r0..r7 << 7
  vor v9,v7[e0]      // V9 = bp0/bp1/bp2 Of r0..r7 In Unsigned Byte
  vor v9,v8[e0]      // V9 = bp0/bp1/bp2/bp3 Of r0..r7 In Unsigned Byte (%00001111)

  vand v7,v5,v1[e11] // V7 = bp4 Of r0..r7 (& $0800)
  vand v8,v5,v0[e11] // V8 = bp5 Of r0..r7 (& $0008)
  vmudn v8,v1[e9]    // V8 = bp5 Of r0..r7 << 9
  vor v9,v7[e0]      // V9 = bp0/bp1/bp2/bp3/bp4 Of r0..r7 In Unsigned Byte
  vor v9,v8[e0]      // V9 = bp0/bp1/bp2/bp3/bp4/bp5 Of r0..r7 In Unsigned Byte (%00111111)

  vand v7,v6,v1[e11] // V7 = bp6 Of r0..r7 (& $0800)
  vand v8,v6,v0[e11] // V8 = bp7 Of r0..r7 (& $0008)
  vmudn v7,v0[e10]   // V7 = bp6 Of r0..r7 << 2
  vmudn v8,v1[e11]   // V8 = bp7 Of r0..r7 << 11
  vor v9,v7[e0]      // V9 = bp0/bp1/bp2/bp3/bp4/bp5/bp6 Of r0..r7 In Unsigned Byte
  vor v9,v8[e0]      // V9 = bp0/bp1/bp2/bp3/bp4/bp5/bp6/bp7 Of r0..r7 In Unsigned Byte (%11111111)

// Store Column 3:
  addiu a0,8
  suv v9[e0],0(a0) // Tile Row 3 = V8 Unsigned Bytes


// Vector Grab Column 4:
  vand v7,v3,v1[e12] // V7 = bp0 Of r0..r7 (& $1000)
  vand v8,v3,v0[e12] // V8 = bp1 Of r0..r7 (& $0010)
  vmudl v7,v1[e11]   // V7 = bp0 Of r0..r7 >> 5
  vmudn v8,v0[e12]   // V8 = bp1 Of r0..r7 << 4
  vor v9,v7,v8[e0]   // V9 = bp0/bp1 Of r0..r7 In Unsigned Byte (%00000011)

  vand v7,v4,v1[e12] // V7 = bp2 Of r0..r7 (& $1000)
  vand v8,v4,v0[e12] // V8 = bp3 Of r0..r7 (& $0010)
  vmudl v7,v1[e13]   // V7 = bp2 Of r0..r7 >> 3
  vmudn v8,v0[e14]   // V8 = bp3 Of r0..r7 << 6
  vor v9,v7[e0]      // V9 = bp0/bp1/bp2 Of r0..r7 In Unsigned Byte
  vor v9,v8[e0]      // V9 = bp0/bp1/bp2/bp3 Of r0..r7 In Unsigned Byte (%00001111)

  vand v7,v5,v1[e12] // V7 = bp4 Of r0..r7 (& $1000)
  vand v8,v5,v0[e12] // V8 = bp5 Of r0..r7 (& $0010)
  vmudl v7,v1[e15]   // V7 = bp4 Of r0..r7 >> 1
  vmudn v8,v1[e8]    // V8 = bp5 Of r0..r7 << 8
  vor v9,v7[e0]      // V9 = bp0/bp1/bp2/bp3/bp4 Of r0..r7 In Unsigned Byte
  vor v9,v8[e0]      // V9 = bp0/bp1/bp2/bp3/bp4/bp5 Of r0..r7 In Unsigned Byte (%00111111)

  vand v7,v6,v1[e12] // V7 = bp6 Of r0..r7 (& $1000)
  vand v8,v6,v0[e12] // V8 = bp7 Of r0..r7 (& $0010)
  vmudn v7,v0[e9]    // V7 = bp6 Of r0..r7 << 1
  vmudn v8,v1[e10]   // V8 = bp7 Of r0..r7 << 10
  vor v9,v7[e0]      // V9 = bp0/bp1/bp2/bp3/bp4/bp5/bp6 Of r0..r7 In Unsigned Byte
  vor v9,v8[e0]      // V9 = bp0/bp1/bp2/bp3/bp4/bp5/bp6/bp7 Of r0..r7 In Unsigned Byte (%11111111)

// Store Column 4:
  addiu a0,8
  suv v9[e0],0(a0) // Tile Row 4 = V8 Unsigned Bytes


// Vector Grab Column 5:
  vand v7,v3,v1[e13] // V7 = bp0 Of r0..r7 (& $2000)
  vand v8,v3,v0[e13] // V8 = bp1 Of r0..r7 (& $0020)
  vmudl v7,v1[e10]   // V7 = bp0 Of r0..r7 >> 6
  vmudn v8,v0[e11]   // V8 = bp1 Of r0..r7 << 3
  vor v9,v7,v8[e0]   // V9 = bp0/bp1 Of r0..r7 In Unsigned Byte (%00000011)

  vand v7,v4,v1[e13] // V7 = bp2 Of r0..r7 (& $2000)
  vand v8,v4,v0[e13] // V8 = bp3 Of r0..r7 (& $0020)
  vmudl v7,v1[e12]   // V7 = bp2 Of r0..r7 >> 4
  vmudn v8,v0[e13]   // V8 = bp3 Of r0..r7 << 5
  vor v9,v7[e0]      // V9 = bp0/bp1/bp2 Of r0..r7 In Unsigned Byte
  vor v9,v8[e0]      // V9 = bp0/bp1/bp2/bp3 Of r0..r7 In Unsigned Byte (%00001111)

  vand v7,v5,v1[e13] // V7 = bp4 Of r0..r7 (& $2000)
  vand v8,v5,v0[e13] // V8 = bp5 Of r0..r7 (& $0020)
  vmudl v7,v1[e14]   // V7 = bp4 Of r0..r7 >> 2
  vmudn v8,v0[e15]   // V8 = bp5 Of r0..r7 << 7
  vor v9,v7[e0]      // V9 = bp0/bp1/bp2/bp3/bp4 Of r0..r7 In Unsigned Byte
  vor v9,v8[e0]      // V9 = bp0/bp1/bp2/bp3/bp4/bp5 Of r0..r7 In Unsigned Byte (%00111111)

  vand v7,v6,v1[e13] // V7 = bp6 Of r0..r7 (& $2000)
  vand v8,v6,v0[e13] // V8 = bp7 Of r0..r7 (& $0020)
  vmudn v8,v1[e9]    // V8 = bp7 Of r0..r7 << 9
  vor v9,v7[e0]      // V9 = bp0/bp1/bp2/bp3/bp4/bp5/bp6 Of r0..r7 In Unsigned Byte
  vor v9,v8[e0]      // V9 = bp0/bp1/bp2/bp3/bp4/bp5/bp6/bp7 Of r0..r7 In Unsigned Byte (%11111111)

// Store Column 5:
  addiu a0,8
  suv v9[e0],0(a0) // Tile Row 5 = V8 Unsigned Bytes


// Vector Grab Column 6:
  vand v7,v3,v1[e14] // V7 = bp0 Of r0..r7 (& $4000)
  vand v8,v3,v0[e14] // V8 = bp1 Of r0..r7 (& $0040)
  vmudl v7,v1[e9]    // V7 = bp0 Of r0..r7 >> 7
  vmudn v8,v0[e10]   // V8 = bp1 Of r0..r7 << 2
  vor v9,v7,v8[e0]   // V9 = bp0/bp1 Of r0..r7 In Unsigned Byte (%00000011)

  vand v7,v4,v1[e14] // V7 = bp2 Of r0..r7 (& $4000)
  vand v8,v4,v0[e14] // V8 = bp3 Of r0..r7 (& $0040)
  vmudl v7,v1[e11]   // V7 = bp2 Of r0..r7 >> 5
  vmudn v8,v0[e12]   // V8 = bp3 Of r0..r7 << 4
  vor v9,v7[e0]      // V9 = bp0/bp1/bp2 Of r0..r7 In Unsigned Byte
  vor v9,v8[e0]      // V9 = bp0/bp1/bp2/bp3 Of r0..r7 In Unsigned Byte (%00001111)

  vand v7,v5,v1[e14] // V7 = bp4 Of r0..r7 (& $4000)
  vand v8,v5,v0[e14] // V8 = bp5 Of r0..r7 (& $0040)
  vmudl v7,v1[e13]   // V7 = bp4 Of r0..r7 >> 3
  vmudn v8,v0[e14]   // V8 = bp5 Of r0..r7 << 6
  vor v9,v7[e0]      // V9 = bp0/bp1/bp2/bp3/bp4 Of r0..r7 In Unsigned Byte
  vor v9,v8[e0]      // V9 = bp0/bp1/bp2/bp3/bp4/bp5 Of r0..r7 In Unsigned Byte (%00111111)

  vand v7,v6,v1[e14] // V7 = bp6 Of r0..r7 (& $4000)
  vand v8,v6,v0[e14] // V8 = bp7 Of r0..r7 (& $0040)
  vmudl v7,v1[e15]   // V7 = bp6 Of r0..r7 >> 1
  vmudn v8,v1[e8]    // V8 = bp7 Of r0..r7 << 8
  vor v9,v7[e0]      // V9 = bp0/bp1/bp2/bp3/bp4/bp5/bp6 Of r0..r7 In Unsigned Byte
  vor v9,v8[e0]      // V9 = bp0/bp1/bp2/bp3/bp4/bp5/bp6/bp7 Of r0..r7 In Unsigned Byte (%11111111)

// Store Column 6:
  addiu a0,8
  suv v9[e0],0(a0) // Tile Row 6 = V8 Unsigned Bytes


// Vector Grab Column 7:
  vand v7,v3,v1[e15] // V7 = bp0 Of r0..r7 (& $8000)
  vand v8,v3,v0[e15] // V8 = bp1 Of r0..r7 (& $0080)
  vmudl v7,v1[e8]    // V7 = bp0 Of r0..r7 >> 8
  vmudn v8,v0[e9]    // V8 = bp1 Of r0..r7 << 1
  vor v9,v7,v8[e0]   // V9 = bp0/bp1 Of r0..r7 In Unsigned Byte (%00000011)

  vand v7,v4,v1[e15] // V7 = bp2 Of r0..r7 (& $8000)
  vand v8,v4,v0[e15] // V8 = bp3 Of r0..r7 (& $0080)
  vmudl v7,v1[e10]   // V7 = bp2 Of r0..r7 >> 6
  vmudn v8,v0[e11]   // V8 = bp3 Of r0..r7 << 3
  vor v9,v7[e0]      // V9 = bp0/bp1/bp2 Of r0..r7 In Unsigned Byte
  vor v9,v8[e0]      // V9 = bp0/bp1/bp2/bp3 Of r0..r7 In Unsigned Byte (%00001111)

  vand v7,v5,v1[e15] // V7 = bp4 Of r0..r7 (& $8000)
  vand v8,v5,v0[e15] // V8 = bp5 Of r0..r7 (& $0080)
  vmudl v7,v1[e12]   // V7 = bp4 Of r0..r7 >> 4
  vmudn v8,v0[e13]   // V8 = bp5 Of r0..r7 << 5
  vor v9,v7[e0]      // V9 = bp0/bp1/bp2/bp3/bp4 Of r0..r7 In Unsigned Byte
  vor v9,v8[e0]      // V9 = bp0/bp1/bp2/bp3/bp4/bp5 Of r0..r7 In Unsigned Byte (%00111111)

  vand v7,v6,v1[e15] // V7 = bp6 Of r0..r7 (& $8000)
  vand v8,v6,v0[e15] // V8 = bp7 Of r0..r7 (& $0080)
  vmudl v7,v1[e14]   // V7 = bp6 Of r0..r7 >> 2
  vmudn v8,v0[e15]   // V8 = bp7 Of r0..r7 << 7
  vor v9,v7[e0]      // V9 = bp0/bp1/bp2/bp3/bp4/bp5/bp6 Of r0..r7 In Unsigned Byte
  vor v9,v8[e0]      // V9 = bp0/bp1/bp2/bp3/bp4/bp5/bp6/bp7 Of r0..r7 In Unsigned Byte (%11111111)

// Store Column 7:
  addiu a0,8
  suv v9[e0],0(a0) // Tile Row 7 = V8 Unsigned Bytes


  addiu a0,8 // A0 = Next SNES Tile Offset

  bnez t1,LoopTiles8BPP // IF (Tile Counter != 0) Loop Tiles
  subiu t1,1 // Decrement Tile Counter (Delay Slot)


  ori a0,r0,0 // A0 = SP Memory Address Offset DMEM ($A4000000..$A4001FFF 8KB)
  ori t0,r0,4095 // T0 = Length Of DMA Transfer In Bytes - 1

  mtc0 a0,c0 // Store Memory Offset To SP Memory Address Register ($A4040000)
  mtc0 a1,c1 // Store RAM Offset To SP DRAM Address Register ($A4040004)
  mtc0 t0,c3 // Store DMA Length To SP Write Length Register ($A404000C)

  TILEDMAWRITE8BPPBusy:
    mfc0 t0,c4 // T0 = RSP Status Register ($A4040010)
    andi t0,RSP_BSY|RSP_FUL // AND RSP Status Status With $C (Bit 2 = DMA Is Busy, Bit 3 = DMA Is Full)
    bnez t0,TILEDMAWRITE8BPPBusy // IF TRUE DMA Is Busy
    nop // Delay Slot

  addiu a1,4096 // A1 = Next N64  Tile Offset
  addiu a2,4096 // A2 = Next SNES Tile Offset

  bnez t2,LoopTile8BPPBlocks // IF (Tile Block Counter != 0) Loop Tile Blocks
  subiu t2,1 // Decrement Tile Block Counter (Delay Slot)


  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
align(8) // Align 64-Bit
base RSPTILEXBPPCode+pc() // Set End Of RSP Code Object
RSPTILEXBPPCodeEnd: