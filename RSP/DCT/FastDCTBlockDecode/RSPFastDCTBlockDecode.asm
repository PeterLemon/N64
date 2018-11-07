// N64 'Bare Metal' RSP Fast DCT Block Decode Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "RSPFastDCTBlockDecode.N64", create
fill 1052672 // Set ROM Size

origin $00000000
base $80000000 // Entry Point Of Code
include "LIB/N64.INC" // Include N64 Definitions
include "LIB/N64_HEADER.ASM" // Include 64 Byte Header & Vector Table
insert "LIB/N64_BOOTCODE.BIN" // Include 4032 Byte Boot Code

Start:
  include "LIB/N64_GFX.INC" // Include Graphics Macros
  include "LIB/N64_RSP.INC" // Include RSP Macros
  N64_INIT() // Run N64 Initialisation Routine

  ScreenNTSC(320, 240, BPP32, $A0100000) // Screen NTSC: 320x240, 32BPP, DRAM Origin $A0100000

  WaitScanline($200) // Wait For Scanline To Reach Vertical Blank

  // Load RSP Code To IMEM
  DMASPRD(RSPCode, RSPCodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  DMASPRD(RSPData, RSPDataEnd, SP_DMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  SetSPPC(RSPStart) // Set RSP Program Counter: Start Address
  StartSP() // Start RSP Execution: RSP Status = Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break

Loop:
  j Loop
  nop // Delay Slot

align(8) // Align 64-Bit
RSPCode:
arch n64.rsp
base $0000 // Set Base Of RSP Code Object To Zero

RSPStart:
// Decode DCT 8x8 Block Using IDCT

  // Load Fixed Point Signed Fractions LUT
  lqv v0[e0],FIX_LUT(r0)    // V0 = Look Up Table 0..7  (128-Bit Quad)
  lqv v1[e0],FIX_LUT+16(r0) // V1 = Look Up Table 8..15 (128-Bit Quad)

  la a0,DCT // A0 = DCT 8x8 Matrix DMEM Address

  // Fast IDCT Block Decode
  // Pass 1: Process Columns From Input, Store Into Work Array.

  // Even part: Reverse The Even Part Of The Forward DCT. The Rotator Is SQRT(2)*C(-6).
  lqv v2[e0],$20(a0) // V2 = Z2 = DCT[CTR + 8*2]
  lqv v3[e0],$60(a0) // V3 = Z3 = DCT[CTR + 8*6]

  vadd v4,v2,v3[e0] // Z1 = (Z2 + Z3) * 0.541196100
  vmulf v4,v0[e10] // V4 = Z1

  vmulf v5,v3,v0[e15] // TMP2 = Z1 + (Z3 * -1.847759065)
  vsub v5,v3[e0]
  vadd v3,v5,v4[e0] // V3 = TMP2

  vmulf v6,v2,v0[e11] // TMP3 = Z1 + (Z2 * 0.765366865)
  vadd v2,v6,v4[e0] // V2 = TMP3

  lqv v6[e0],$00(a0) // V6 = Z2 = DCT[CTR + 8*0]
  lqv v7[e0],$40(a0) // V7 = Z3 = DCT[CTR + 8*4]

  vadd v4,v6,v7[e0] // V4 = TMP0 = Z2 + Z3
  vsub v5,v6,v7[e0] // V5 = TMP1 = Z2 - Z3

  vadd v6,v4,v2[e0] // V6 = TMP10 = TMP0 + TMP3
  vadd v7,v5,v3[e0] // V7 = TMP11 = TMP1 + TMP2
  vsub v8,v5,v3[e0] // V8 = TMP12 = TMP1 - TMP2
  vsub v9,v4,v2[e0] // V9 = TMP13 = TMP0 - TMP3

  // Odd Part Per Figure 8; The Matrix Is Unitary And Hence Its Transpose Is Its Inverse.
  lqv v2[e0],$70(a0) // V2 = TMP0 = DCT[CTR + 8*7]
  lqv v3[e0],$50(a0) // V3 = TMP1 = DCT[CTR + 8*5]
  lqv v4[e0],$30(a0) // V4 = TMP2 = DCT[CTR + 8*3]
  lqv v5[e0],$10(a0) // V5 = TMP3 = DCT[CTR + 8*1]

  vadd v12,v2,v4[e0] // V12 = Z3 = TMP0 + TMP2
  vadd v13,v3,v5[e0] // R13 = Z4 = TMP1 + TMP3

  vadd v14,v12,v13[e0] // Z5 = (Z3 + Z4) * 1.175875602 # SQRT(2) * C3
  vmulf v10,v14,v0[e13]
  vadd v14,v10[e0] // V14 = Z5
  
  vmulf v10,v12,v1[e8] // Z3 *= -1.961570560 # SQRT(2) * (-C3-C5)
  vsub v12,v10,v12[e0] // V12 = Z3

  vmulf v13,v0[e9] // V13 = Z4 *= -0.390180644 # SQRT(2) * (C5-C3)

  vadd v12,v14[e0] // V12 = Z3 += Z5
  vadd v13,v14[e0] // V13 = Z4 += Z5

  vadd v10,v2,v5[e0] // V10 = Z1 = TMP0 + TMP3
  vadd v11,v3,v4[e0] // V11 = Z2 = TMP1 + TMP2

  vmulf v10,v0[e12] // V10 = Z1 *= -0.899976223 # SQRT(2) * (C7-C3)

  vmulf v14,v11,v1[e10] // Z2 *= -2.562915447 # SQRT(2) * (-C1-C3)
  vsub v14,v11[e0]
  vsub v11,v14,v11[e0] // V11 = Z2

  vmulf v2,v0[e8] // V2 = TMP0 *= 0.298631336 # SQRT(2) * (-C1+C3+C5-C7)

  vmulf v14,v3,v1[e9] // TMP1 *= 2.053119869 # SQRT(2) * (C1+C3-C5+C7)
  vadd v14,v3[e0]
  vadd v3,v14,v3[e0] // V3 = TMP1

  vmulf v14,v4,v1[e11] // TMP2 *= 3.072711026 # SQRT(2) * ( C1+C3+C5-C7)
  vadd v14,v4[e0]
  vadd v14,v4[e0]
  vadd v4,v14,v4[e0] // V4 = TMP2

  vmulf v14,v5,v0[e14] // TMP3 *= 1.501321110 # SQRT(2) * ( C1+C3-C5-C7)
  vadd v5,v14,v5[e0] // V5 = TMP3

  vadd v2,v10[e0] // TMP0 += Z1 + Z3
  vadd v2,v12[e0] // V2 = TMP0
  vadd v3,v11[e0] // TMP1 += Z2 + Z4
  vadd v3,v13[e0] // V3 = TMP1
  vadd v4,v11[e0] // TMP2 += Z2 + Z3
  vadd v4,v12[e0] // V4 = TMP2
  vadd v5,v10[e0] // TMP3 += Z1 + Z4
  vadd v5,v13[e0] // V5 = TMP3

  // Final Output Stage: Inputs Are TMP10..TMP13, TMP0..TMP3
  vadd v16,v6,v5[e0] // DCT[CTR + 8*0] = TMP10 + TMP3
  vadd v17,v7,v4[e0] // DCT[CTR + 8*1] = TMP11 + TMP2
  vadd v18,v8,v3[e0] // DCT[CTR + 8*2] = TMP12 + TMP1
  vadd v19,v9,v2[e0] // DCT[CTR + 8*3] = TMP13 + TMP0
  vsub v20,v9,v2[e0] // DCT[CTR + 8*4] = TMP13 - TMP0
  vsub v21,v8,v3[e0] // DCT[CTR + 8*5] = TMP12 - TMP1
  vsub v22,v7,v4[e0] // DCT[CTR + 8*6] = TMP11 - TMP2
  vsub v23,v6,v5[e0] // DCT[CTR + 8*7] = TMP10 - TMP3


  // Store Transposed Matrix From Row Ordered Vector Register Block (V16 = Block Base Register)
  stv v16[e0],$00(a0)  // Store 1st Element Diagonals From Vector Register Block
  stv v16[e2],$10(a0)  // Store 2nd Element Diagonals From Vector Register Block
  stv v16[e4],$20(a0)  // Store 3rd Element Diagonals From Vector Register Block
  stv v16[e6],$30(a0)  // Store 4th Element Diagonals From Vector Register Block
  stv v16[e8],$40(a0)  // Store 5th Element Diagonals From Vector Register Block
  stv v16[e10],$50(a0) // Store 6th Element Diagonals From Vector Register Block
  stv v16[e12],$60(a0) // Store 7th Element Diagonals From Vector Register Block
  stv v16[e14],$70(a0) // Store 8th Element Diagonals From Vector Register Block 

  ltv v16[e14],$10(a0) // Load 8th Element Diagonals To Vector Register Block
  ltv v16[e12],$20(a0) // Load 7th Element Diagonals To Vector Register Block
  ltv v16[e10],$30(a0) // Load 6th Element Diagonals To Vector Register Block
  ltv v16[e8],$40(a0)  // Load 5th Element Diagonals To Vector Register Block
  ltv v16[e6],$50(a0)  // Load 4th Element Diagonals To Vector Register Block
  ltv v16[e4],$60(a0)  // Load 3rd Element Diagonals To Vector Register Block
  ltv v16[e2],$70(a0)  // Load 2nd Element Diagonals To Vector Register Block

  sqv v16[e0],$00(a0) // Store 1st Row From Transposed Matrix Vector Register Block
  sqv v17[e0],$10(a0) // Store 2nd Row From Transposed Matrix Vector Register Block
  sqv v18[e0],$20(a0) // Store 3rd Row From Transposed Matrix Vector Register Block
  sqv v19[e0],$30(a0) // Store 4th Row From Transposed Matrix Vector Register Block
  sqv v20[e0],$40(a0) // Store 5th Row From Transposed Matrix Vector Register Block
  sqv v21[e0],$50(a0) // Store 6th Row From Transposed Matrix Vector Register Block
  sqv v22[e0],$60(a0) // Store 7th Row From Transposed Matrix Vector Register Block
  sqv v23[e0],$70(a0) // Store 8th Row From Transposed Matrix Vector Register Block


  // Pass 2: Process Rows From Work Array, Store Into Output Array.

  // Even part: Reverse The Even Part Of The Forward DCT. The Rotator Is SQRT(2)*C(-6).
  lqv v2[e0],$20(a0) // V2 = Z2 = DCT[CTR*8 + 2]
  lqv v3[e0],$60(a0) // V3 = Z3 = DCT[CTR*8 + 6]

  vadd v4,v2,v3[e0] // Z1 = (Z2 + Z3) * 0.541196100
  vmulf v4,v0[e10] // V4 = Z1

  vmulf v5,v3,v0[e15] // TMP2 = Z1 + (Z3 * -1.847759065)
  vsub v5,v3[e0]
  vadd v3,v5,v4[e0] // V3 = TMP2

  vmulf v6,v2,v0[e11] // TMP3 = Z1 + (Z2 * 0.765366865)
  vadd v2,v6,v4[e0] // V2 = TMP3

  lqv v6[e0],$00(a0) // V6 = Z2 = DCT[CTR*8 + 0]
  lqv v7[e0],$40(a0) // V7 = Z3 = DCT[CTR*8 + 4]

  vadd v4,v6,v7[e0] // V4 = TMP0 = Z2 + Z3
  vsub v5,v6,v7[e0] // V5 = TMP1 = Z2 - Z3

  vadd v6,v4,v2[e0] // V6 = TMP10 = TMP0 + TMP3
  vadd v7,v5,v3[e0] // V7 = TMP11 = TMP1 + TMP2
  vsub v8,v5,v3[e0] // V8 = TMP12 = TMP1 - TMP2
  vsub v9,v4,v2[e0] // V9 = TMP13 = TMP0 - TMP3

  // Odd Part Per Figure 8; The Matrix Is Unitary And Hence Its Transpose Is Its Inverse.
  lqv v2[e0],$70(a0) // V2 = TMP0 = DCT[CTR*8 + 7]
  lqv v3[e0],$50(a0) // V3 = TMP1 = DCT[CTR*8 + 5]
  lqv v4[e0],$30(a0) // V4 = TMP2 = DCT[CTR*8 + 3]
  lqv v5[e0],$10(a0) // V5 = TMP3 = DCT[CTR*8 + 1]

  vadd v12,v2,v4[e0] // V12 = Z3 = TMP0 + TMP2
  vadd v13,v3,v5[e0] // R13 = Z4 = TMP1 + TMP3

  vadd v14,v12,v13[e0] // Z5 = (Z3 + Z4) * 1.175875602 # SQRT(2) * C3
  vmulf v10,v14,v0[e13]
  vadd v14,v10[e0] // V14 = Z5
  
  vmulf v10,v12,v1[e8] // Z3 *= -1.961570560 # SQRT(2) * (-C3-C5)
  vsub v12,v10,v12[e0] // V12 = Z3

  vmulf v13,v0[e9] // V13 = Z4 *= -0.390180644 # SQRT(2) * (C5-C3)

  vadd v12,v14[e0] // V12 = Z3 += Z5
  vadd v13,v14[e0] // V13 = Z4 += Z5

  vadd v10,v2,v5[e0] // V10 = Z1 = TMP0 + TMP3
  vadd v11,v3,v4[e0] // V11 = Z2 = TMP1 + TMP2

  vmulf v10,v0[e12] // V10 = Z1 *= -0.899976223 # SQRT(2) * (C7-C3)

  vmulf v14,v11,v1[e10] // Z2 *= -2.562915447 # SQRT(2) * (-C1-C3)
  vsub v14,v11[e0]
  vsub v11,v14,v11[e0] // V11 = Z2

  vmulf v2,v0[e8] // V2 = TMP0 *= 0.298631336 # SQRT(2) * (-C1+C3+C5-C7)

  vmulf v14,v3,v1[e9] // TMP1 *= 2.053119869 # SQRT(2) * (C1+C3-C5+C7)
  vadd v14,v3[e0]
  vadd v3,v14,v3[e0] // V3 = TMP1

  vmulf v14,v4,v1[e11] // TMP2 *= 3.072711026 # SQRT(2) * ( C1+C3+C5-C7)
  vadd v14,v4[e0]
  vadd v14,v4[e0]
  vadd v4,v14,v4[e0] // V4 = TMP2

  vmulf v14,v5,v0[e14] // TMP3 *= 1.501321110 # SQRT(2) * ( C1+C3-C5-C7)
  vadd v5,v14,v5[e0] // V5 = TMP3

  vadd v2,v10[e0] // TMP0 += Z1 + Z3
  vadd v2,v12[e0] // V2 = TMP0
  vadd v3,v11[e0] // TMP1 += Z2 + Z4
  vadd v3,v13[e0] // V3 = TMP1
  vadd v4,v11[e0] // TMP2 += Z2 + Z3
  vadd v4,v12[e0] // V4 = TMP2
  vadd v5,v10[e0] // TMP3 += Z1 + Z4
  vadd v5,v13[e0] // V5 = TMP3

  // Final Output Stage: Inputs Are TMP10..TMP13, TMP0..TMP3
  vadd v16,v6,v5[e0] // DCT[CTR*8 + 0] = (TMP10 + TMP3) * 0.125
  vmulu v16,v1[e12]  // Produce Unsigned Result For RGB Pixels
  vadd v17,v7,v4[e0] // DCT[CTR*8 + 1] = (TMP11 + TMP2) * 0.125
  vmulu v17,v1[e12]  // Produce Unsigned Result For RGB Pixels
  vadd v18,v8,v3[e0] // DCT[CTR*8 + 2] = (TMP12 + TMP1) * 0.125
  vmulu v18,v1[e12]  // Produce Unsigned Result For RGB Pixels
  vadd v19,v9,v2[e0] // DCT[CTR*8 + 3] = (TMP13 + TMP0) * 0.125
  vmulu v19,v1[e12]  // Produce Unsigned Result For RGB Pixels
  vsub v20,v9,v2[e0] // DCT[CTR*8 + 4] = (TMP13 - TMP0) * 0.125
  vmulu v20,v1[e12]  // Produce Unsigned Result For RGB Pixels
  vsub v21,v8,v3[e0] // DCT[CTR*8 + 5] = (TMP12 - TMP1) * 0.125
  vmulu v21,v1[e12]  // Produce Unsigned Result For RGB Pixels
  vsub v22,v7,v4[e0] // DCT[CTR*8 + 6] = (TMP11 - TMP2) * 0.125
  vmulu v22,v1[e12]  // Produce Unsigned Result For RGB Pixels
  vsub v23,v6,v5[e0] // DCT[CTR*8 + 7] = (TMP10 - TMP3) * 0.125
  vmulu v23,v1[e12]  // Produce Unsigned Result For RGB Pixels

  // Store Transposed Matrix From Row Ordered Vector Register Block (V16 = Block Base Register)
  stv v16[e0],$00(a0)  // Store 1st Element Diagonals From Vector Register Block
  stv v16[e2],$10(a0)  // Store 2nd Element Diagonals From Vector Register Block
  stv v16[e4],$20(a0)  // Store 3rd Element Diagonals From Vector Register Block
  stv v16[e6],$30(a0)  // Store 4th Element Diagonals From Vector Register Block
  stv v16[e8],$40(a0)  // Store 5th Element Diagonals From Vector Register Block
  stv v16[e10],$50(a0) // Store 6th Element Diagonals From Vector Register Block
  stv v16[e12],$60(a0) // Store 7th Element Diagonals From Vector Register Block
  stv v16[e14],$70(a0) // Store 8th Element Diagonals From Vector Register Block 

  ltv v16[e14],$10(a0) // Load 8th Element Diagonals To Vector Register Block
  ltv v16[e12],$20(a0) // Load 7th Element Diagonals To Vector Register Block
  ltv v16[e10],$30(a0) // Load 6th Element Diagonals To Vector Register Block
  ltv v16[e8],$40(a0)  // Load 5th Element Diagonals To Vector Register Block
  ltv v16[e6],$50(a0)  // Load 4th Element Diagonals To Vector Register Block
  ltv v16[e4],$60(a0)  // Load 3rd Element Diagonals To Vector Register Block
  ltv v16[e2],$70(a0)  // Load 2nd Element Diagonals To Vector Register Block

  sqv v16[e0],$00(a0) // Store 1st Row From Transposed Matrix Vector Register Block
  sqv v17[e0],$10(a0) // Store 2nd Row From Transposed Matrix Vector Register Block
  sqv v18[e0],$20(a0) // Store 3rd Row From Transposed Matrix Vector Register Block
  sqv v19[e0],$30(a0) // Store 4th Row From Transposed Matrix Vector Register Block
  sqv v20[e0],$40(a0) // Store 5th Row From Transposed Matrix Vector Register Block
  sqv v21[e0],$50(a0) // Store 6th Row From Transposed Matrix Vector Register Block
  sqv v22[e0],$60(a0) // Store 7th Row From Transposed Matrix Vector Register Block
  sqv v23[e0],$70(a0) // Store 8th Row From Transposed Matrix Vector Register Block


  // Load RGB Tile Pixel Multipliers
  lqv v2[e0],RGBTilePixelA(r0) // V2 = Store Pixel 1 & 5 (128-Bit Quad)
  lqv v3[e0],RGBTilePixelB(r0) // V3 = Store Pixel 2 & 6 (128-Bit Quad)
  lqv v4[e0],RGBTilePixelC(r0) // V4 = Store Pixel 3 & 7 (128-Bit Quad)
  lqv v5[e0],RGBTilePixelD(r0) // V5 = Store Pixel 4 & 8 (128-Bit Quad)

  // Output 8x8 Block Of Pixel Values To RGB Tile
  la a0,RGBTile // A0 = RGB Tile DMEM Address

  // Row 0: Double Up Element Byte Values (X += X << 8)
  vmudn v6,v16,v1[e13] // V6 = V16 << 8
  vadd v6,v16[e0] // V6 = 8 Double Pixels

  vmudn v7,v2,v6[e8]
  vmudn v8,v3,v6[e9]
  vadd v7,v8[e0]
  vmudn v8,v4,v6[e10]
  vadd v7,v8[e0]
  vmudn v8,v5,v6[e11]
  vadd v7,v8[e0] // V7 = 32-Bit Pixels 1..4
  sqv v7[e0],$00(a0) // Store 32-Bit RGBA Values

  vmudn v7,v2,v6[e12]
  vmudn v8,v3,v6[e13]
  vadd v7,v8[e0]
  vmudn v8,v4,v6[e14]
  vadd v7,v8[e0]
  vmudn v8,v5,v6[e15]
  vadd v7,v8[e0] // V7 = 32-Bit Pixels 5..8
  sqv v7[e0],$10(a0) // Store 32-Bit RGBA Values

  // Row 1: Double Up Element Byte Values (X += X << 8)
  vmudn v6,v17,v1[e13] // V6 = V17 << 8
  vadd v6,v17[e0] // V6 = 8 Double Pixels

  vmudn v7,v2,v6[e8]
  vmudn v8,v3,v6[e9]
  vadd v7,v8[e0]
  vmudn v8,v4,v6[e10]
  vadd v7,v8[e0]
  vmudn v8,v5,v6[e11]
  vadd v7,v8[e0] // V7 = 32-Bit Pixels 1..4
  sqv v7[e0],$20(a0) // Store 32-Bit RGBA Values

  vmudn v7,v2,v6[e12]
  vmudn v8,v3,v6[e13]
  vadd v7,v8[e0]
  vmudn v8,v4,v6[e14]
  vadd v7,v8[e0]
  vmudn v8,v5,v6[e15]
  vadd v7,v8[e0] // V7 = 32-Bit Pixels 5..8
  sqv v7[e0],$30(a0) // Store 32-Bit RGBA Values

  // Row 2: Double Up Element Byte Values (X += X << 8)
  vmudn v6,v18,v1[e13] // V6 = V18 << 8
  vadd v6,v18[e0] // V6 = 8 Double Pixels

  vmudn v7,v2,v6[e8]
  vmudn v8,v3,v6[e9]
  vadd v7,v8[e0]
  vmudn v8,v4,v6[e10]
  vadd v7,v8[e0]
  vmudn v8,v5,v6[e11]
  vadd v7,v8[e0] // V7 = 32-Bit Pixels 1..4
  sqv v7[e0],$40(a0) // Store 32-Bit RGBA Values

  vmudn v7,v2,v6[e12]
  vmudn v8,v3,v6[e13]
  vadd v7,v8[e0]
  vmudn v8,v4,v6[e14]
  vadd v7,v8[e0]
  vmudn v8,v5,v6[e15]
  vadd v7,v8[e0] // V7 = 32-Bit Pixels 5..8
  sqv v7[e0],$50(a0) // Store 32-Bit RGBA Values

  // Row 3: Double Up Element Byte Values (X += X << 8)
  vmudn v6,v19,v1[e13] // V6 = V19 << 8
  vadd v6,v19[e0] // V6 = 8 Double Pixels

  vmudn v7,v2,v6[e8]
  vmudn v8,v3,v6[e9]
  vadd v7,v8[e0]
  vmudn v8,v4,v6[e10]
  vadd v7,v8[e0]
  vmudn v8,v5,v6[e11]
  vadd v7,v8[e0] // V7 = 32-Bit Pixels 1..4
  sqv v7[e0],$60(a0) // Store 32-Bit RGBA Values

  vmudn v7,v2,v6[e12]
  vmudn v8,v3,v6[e13]
  vadd v7,v8[e0]
  vmudn v8,v4,v6[e14]
  vadd v7,v8[e0]
  vmudn v8,v5,v6[e15]
  vadd v7,v8[e0] // V7 = 32-Bit Pixels 5..8
  sqv v7[e0],$70(a0) // Store 32-Bit RGBA Values

  // Row 4: Double Up Element Byte Values (X += X << 8)
  vmudn v6,v20,v1[e13] // V6 = V20 << 8
  vadd v6,v20[e0] // V6 = 8 Double Pixels

  vmudn v7,v2,v6[e8]
  vmudn v8,v3,v6[e9]
  vadd v7,v8[e0]
  vmudn v8,v4,v6[e10]
  vadd v7,v8[e0]
  vmudn v8,v5,v6[e11]
  vadd v7,v8[e0] // V7 = 32-Bit Pixels 1..4
  sqv v7[e0],$80(a0) // Store 32-Bit RGBA Values

  vmudn v7,v2,v6[e12]
  vmudn v8,v3,v6[e13]
  vadd v7,v8[e0]
  vmudn v8,v4,v6[e14]
  vadd v7,v8[e0]
  vmudn v8,v5,v6[e15]
  vadd v7,v8[e0] // V7 = 32-Bit Pixels 5..8
  sqv v7[e0],$90(a0) // Store 32-Bit RGBA Values

  // Row 5: Double Up Element Byte Values (X += X << 8)
  vmudn v6,v21,v1[e13] // V6 = V21 << 8
  vadd v6,v21[e0] // V6 = 8 Double Pixels

  vmudn v7,v2,v6[e8]
  vmudn v8,v3,v6[e9]
  vadd v7,v8[e0]
  vmudn v8,v4,v6[e10]
  vadd v7,v8[e0]
  vmudn v8,v5,v6[e11]
  vadd v7,v8[e0] // V7 = 32-Bit Pixels 1..4
  sqv v7[e0],$A0(a0) // Store 32-Bit RGBA Values

  vmudn v7,v2,v6[e12]
  vmudn v8,v3,v6[e13]
  vadd v7,v8[e0]
  vmudn v8,v4,v6[e14]
  vadd v7,v8[e0]
  vmudn v8,v5,v6[e15]
  vadd v7,v8[e0] // V7 = 32-Bit Pixels 5..8
  sqv v7[e0],$B0(a0) // Store 32-Bit RGBA Values

  // Row 6: Double Up Element Byte Values (X += X << 8)
  vmudn v6,v22,v1[e13] // V6 = V22 << 8
  vadd v6,v22[e0] // V6 = 8 Double Pixels

  vmudn v7,v2,v6[e8]
  vmudn v8,v3,v6[e9]
  vadd v7,v8[e0]
  vmudn v8,v4,v6[e10]
  vadd v7,v8[e0]
  vmudn v8,v5,v6[e11]
  vadd v7,v8[e0] // V7 = 32-Bit Pixels 1..4
  sqv v7[e0],$C0(a0) // Store 32-Bit RGBA Values

  vmudn v7,v2,v6[e12]
  vmudn v8,v3,v6[e13]
  vadd v7,v8[e0]
  vmudn v8,v4,v6[e14]
  vadd v7,v8[e0]
  vmudn v8,v5,v6[e15]
  vadd v7,v8[e0] // V7 = 32-Bit Pixels 5..8
  sqv v7[e0],$D0(a0) // Store 32-Bit RGBA Values

  // Row 7: Double Up Element Byte Values (X += X << 8)
  vmudn v6,v23,v1[e13] // V6 = V23 << 8
  vadd v6,v23[e0] // V6 = 8 Double Pixels

  vmudn v7,v2,v6[e8]
  vmudn v8,v3,v6[e9]
  vadd v7,v8[e0]
  vmudn v8,v4,v6[e10]
  vadd v7,v8[e0]
  vmudn v8,v5,v6[e11]
  vadd v7,v8[e0] // V7 = 32-Bit Pixels 1..4
  sqv v7[e0],$E0(a0) // Store 32-Bit RGBA Values

  vmudn v7,v2,v6[e12]
  vmudn v8,v3,v6[e13]
  vadd v7,v8[e0]
  vmudn v8,v4,v6[e14]
  vadd v7,v8[e0]
  vmudn v8,v5,v6[e15]
  vadd v7,v8[e0] // V7 = 32-Bit Pixels 5..8
  sqv v7[e0],$F0(a0) // Store 32-Bit RGBA Values


// DMA & Stride RGB Tile To VI RAM
  li t0,((8*4)-1) | (7<<12) | (((320-8)*4)<<20) // T0 = Length Of DMA Transfer In Bytes - 1, DMA Line Count - 1, Line Skip/Stride
  lli a0,SP_DMEM // A0 = SP Memory Address Offset DMEM $000 ($A4000000..$A4001FFF 8KB)
  la a1,$100000 | ((320*4)*104)+(144*4) // A1 = Aligned DRAM Physical RAM Offset ($00000000..$007FFFFF 8MB)
  
  mtc0 a0,c0 // Store Memory Offset To SP Memory Address Register ($A4040000)
  mtc0 a1,c1 // Store RAM Offset To SP DRAM Address Register ($A4040004)
  mtc0 t0,c3 // Store DMA Length To SP Write Length Register ($A404000C)

  break // Set SP Status Halt, Broke & Check For Interrupt
align(8) // Align 64-Bit
base RSPCode+pc() // Set End Of RSP Code Object
RSPCodeEnd:

align(8) // Align 64-Bit
RSPData:
base $0000 // Set Base Of RSP Data Object To Zero

RGBTile:
  dw $FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF
  dw $FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF
  dw $FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF
  dw $FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF
  dw $FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF
  dw $FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF
  dw $FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF
  dw $FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF

DCT:
  //dh 700,0,0,0,0,0,0,0 // We Apply The IDCT To A Matrix, Only Containing A DC Value Of 700.
  //dh 0,0,0,0,0,0,0,0   // It Will Produce A Grey Colored Square.
  //dh 0,0,0,0,0,0,0,0
  //dh 0,0,0,0,0,0,0,0
  //dh 0,0,0,0,0,0,0,0
  //dh 0,0,0,0,0,0,0,0
  //dh 0,0,0,0,0,0,0,0
  //dh 0,0,0,0,0,0,0,0

  //dh 700,100,0,0,0,0,0,0 // Now Let's Add An AC Value Of 100, At The 1st Position
  //dh 0,0,0,0,0,0,0,0     // It Will Produce A Bar Diagram With A Curve Like A Half Cosine Line.
  //dh 0,0,0,0,0,0,0,0     // It Is Said It Has A Frequency Of 1 In X-Direction.
  //dh 0,0,0,0,0,0,0,0
  //dh 0,0,0,0,0,0,0,0
  //dh 0,0,0,0,0,0,0,0
  //dh 0,0,0,0,0,0,0,0
  //dh 0,0,0,0,0,0,0,0

  //dh 700,0,100,0,0,0,0,0 // What Happens If We Place The AC Value Of 100 At The Next Position?
  //dh 0,0,0,0,0,0,0,0     // The Shape Of The Bar Diagram Shows A Cosine Line, Too.
  //dh 0,0,0,0,0,0,0,0     // But Now We See A Full Period.
  //dh 0,0,0,0,0,0,0,0     // The Frequency Is Twice As High As In The Previous Example.
  //dh 0,0,0,0,0,0,0,0
  //dh 0,0,0,0,0,0,0,0
  //dh 0,0,0,0,0,0,0,0
  //dh 0,0,0,0,0,0,0,0

  //dh 700,100,100,0,0,0,0,0 // But What Happens If We Place Both AC Values?
  //dh 0,0,0,0,0,0,0,0       // The Shape Of The Bar Diagram Is A Mix Of Both The 1st & 2nd Cosines.
  //dh 0,0,0,0,0,0,0,0       // The Resulting AC Value Is Simply An Addition Of The Cosine Lines.
  //dh 0,0,0,0,0,0,0,0
  //dh 0,0,0,0,0,0,0,0
  //dh 0,0,0,0,0,0,0,0
  //dh 0,0,0,0,0,0,0,0
  //dh 0,0,0,0,0,0,0,0

  //dh 700,100,100,0,0,0,0,0 // Now Let's Add An AC Value At The Other Direction.
  //dh 200,0,0,0,0,0,0,0     // Now The Values Vary In Y Direction, Too. The Principle Is:
  //dh 0,0,0,0,0,0,0,0       // The Higher The Index Of The AC Value The Greater The Frequency Is.
  //dh 0,0,0,0,0,0,0,0
  //dh 0,0,0,0,0,0,0,0
  //dh 0,0,0,0,0,0,0,0
  //dh 0,0,0,0,0,0,0,0
  //dh 0,0,0,0,0,0,0,0

  //dh 950,0,0,0,0,0,0,0 // Placing An AC Value At The Opposite Side Of The DC Value.
  //dh 0,0,0,0,0,0,0,0   // The Highest Possible Frequency Of 8 Is Applied In Both X- & Y- Direction.
  //dh 0,0,0,0,0,0,0,0   // Because Of The High Frequency The Neighbouring Values Differ Numerously.
  //dh 0,0,0,0,0,0,0,0   // The Picture Shows A Checker-Like Appearance.
  //dh 0,0,0,0,0,0,0,0
  //dh 0,0,0,0,0,0,0,0
  //dh 0,0,0,0,0,0,0,0
  //dh 0,0,0,0,0,0,0,500

  dh 600,0,-261,0,-200,0,-108,0
  dh -106,0,-196,0,256,0,196,0
  dh -185,0,100,0,185,0,-241,0
  dh 217,0,-166,0,90,0,-166,0
  dh 0,0,0,0,0,0,0,0
  dh -145,0,111,0,-60,0,111,0
  dh 77,0,-41,0,-77,0,100,0
  dh 21,0,39,0,-51,0,-39,0

FIX_LUT: // Signed Fractions (S1.15) (Float * 32768)
  dh 9786   //  0.298631336 FIX( 0.298631336) Vector Register A[0]
  dh -12785 // -0.390180644 FIX(-0.390180644) Vector Register A[1]
  dh 17734  //  0.541196100 FIX( 0.541196100) Vector Register A[2]
  dh 25080  //  0.765366865 FIX( 0.765366865) Vector Register A[3]
  dh -29490 // -0.899976223 FIX(-0.899976223) Vector Register A[4]
  dh 5763   //  0.175875602 FIX( 1.175875602) Vector Register A[5]
  dh 16427  //  0.501321110 FIX( 1.501321110) Vector Register A[6]
  dh -27779 // -0.847759065 FIX(-1.847759065) Vector Register A[7]

  dh -31509 // -0.961570560 FIX(-1.961570560) Vector Register B[0]
  dh 1741   //  0.053119869 FIX( 2.053119869) Vector Register B[1]
  dh -18446 // -0.562915447 FIX(-2.562915447) Vector Register B[2]
  dh 2383   //  0.072711026 FIX( 3.072711026) Vector Register B[3]
  dh 4096   //  0.125       FIX( 0.125)       Vector Register B[4]
  dh $0100  // Left Shift Using Multiply: << 8
  dh 0 // Zero Padding Vector Register B[6]
  dh 0 // Zero Padding Vector Register B[7]

RGBTilePixelA: // Used To Store Pixel 1 & 5
  dh 1,1,0,0,0,0,0,0
RGBTilePixelB: // Used To Store Pixel 2 & 6
  dh 0,0,1,1,0,0,0,0
RGBTilePixelC: // Used To Store Pixel 3 & 7
  dh 0,0,0,0,1,1,0,0
RGBTilePixelD: // Used To Store Pixel 4 & 8
  dh 0,0,0,0,0,0,1,1

align(8) // Align 64-Bit
base RSPData+pc() // Set End Of RSP Data Object
RSPDataEnd: