align(8) // Align 64-Bit
N64TLUT:
  fill 512 // Generates 512 Bytes Containing $00


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
RDPPALBuffer:
arch n64.rdp
  Set_Scissor 32<<2,8<<2, 0,0, 288<<2,232<<2 // Set Scissor: XH 32.0,YH 8.0, Scissor Field Enable Off,Field Off, XL 288.0,YL 232.0
  Set_Other_Modes CYCLE_TYPE_FILL // Set Other Modes
  Set_Color_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,320-1, $00100000 // Set Color Image: FORMAT RGBA,SIZE 16B,WIDTH 320, DRAM ADDRESS $00100000

RDPSNESCLEARCOL:
  Set_Fill_Color $00010001 // Set Fill Color: PACKED COLOR 16B R5G5B5A1 Pixels
  Fill_Rectangle 287<<2,231<<2, 32<<2,8<<2 // Fill Rectangle: XL 287.0,YL 231.0, XH 32.0,YH 8.0

  Set_Other_Modes EN_TLUT|SAMPLE_TYPE|BI_LERP_0|ALPHA_DITHER_SEL_NO_DITHER|RGB_DITHER_SEL_NO_DITHER|B_M2A_0_1|FORCE_BLEND|IMAGE_READ_EN // Set Other Modes
  Set_Combine_Mode $0,$00, 0,0, $1,$01, $0,$F, 1,0, 0,0,0, 7,7,7 // Set Combine Mode: SubA RGB0,MulRGB0, SubA Alpha0,MulAlpha0, SubA RGB1,MulRGB1, SubB RGB0,SubB RGB1, SubA Alpha1,MulAlpha1, AddRGB0,SubB Alpha0,AddAlpha0, AddRGB1,SubB Alpha1,AddAlpha1

  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,1-1, N64TLUT // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 1, N64TLUT DRAM ADDRESS
  Set_Tile 0,0,0, $100, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: TMEM Address $100, Tile 0
  Load_Tlut 0<<2,0<<2, 0, 255<<2,0<<2 // Load Tlut: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 0.0
  Sync_Tile // Sync Tile
RDPPALBufferEnd: