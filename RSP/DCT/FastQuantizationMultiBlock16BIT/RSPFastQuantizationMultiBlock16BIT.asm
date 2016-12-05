// N64 'Bare Metal' RSP Fast Quantization Multi Block GFX 16-Bit Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "RSPFastQuantizationMultiBlock16BIT.N64", create
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

  ScreenNTSC(320, 240, BPP16, $A0100000) // Screen NTSC: 320x240, 16BPP, DRAM Origin $A0100000

  WaitScanline($200) // Wait For Scanline To Reach Vertical Blank

  // Load RSP Code To IMEM
  DMASPRD(RSPCode, RSPCodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  lui a0,SP_BASE // A0 = SP Base Register ($A4040000)
  RSPCodeDMABusy:
    lw t0,SP_STATUS(a0) // T0 = Word From SP Status Register ($A4040010)
    andi t0,$C // AND RSP Status Status With $C (Bit 2 = DMA Is Busy, Bit 3 = DMA Is Full)
    bnez t0,RSPCodeDMABusy // IF TRUE DMA Is Busy
    nop // Delay Slot

  // Load RSP Data To DMEM
  DMASPRD(RSPData, RSPDataEnd, SP_DMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  lui a0,SP_BASE // A0 = SP Base Register ($A4040000)
  RSPDataDMABusy:
    lw t0,SP_STATUS(a0) // T0 = Word From SP Status Register ($A4040010)
    andi t0,$C // AND RSP Status Status With $C (Bit 2 = DMA Is Busy, Bit 3 = DMA Is Full)
    bnez t0,RSPDataDMABusy // IF TRUE DMA Is Busy
    nop // Delay Slot

  // Set RSP Program Counter
  lui a0,SP_PC_BASE // A0 = SP PC Base Register ($A4080000)
  lli t0,RSPStart // T0 = RSP Program Counter Set To Start Of RSP Code
  sw t0,SP_PC(a0) // Store RSP Program Counter To SP PC Register ($A4080000)

  // Set RSP Status (Start Execution)
  lui a0,SP_BASE // A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB // T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) // Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

Loop:
  j Loop
  nop // Delay Slot

align(8) // Align 64-Bit
RSPCode:
arch n64.rsp
base $0000 // Set Base Of RSP Code Object To Zero

RSPStart:
// Load Fixed Point Signed Fractions LUT
  lqv v0[e0],FIX_LUT(r0)    // V0 = Look Up Table 0..7  (128-Bit Quad)
  lqv v1[e0],FIX_LUT+16(r0) // V1 = Look Up Table 8..15 (128-Bit Quad)

// Load Integer Quantization LUT
  lqv v24[e0],Q(r0)     // V24 = JPEG Standard Quantization Row 1
  lqv v25[e0],Q+16(r0)  // V25 = JPEG Standard Quantization Row 2
  lqv v26[e0],Q+32(r0)  // V26 = JPEG Standard Quantization Row 3
  lqv v27[e0],Q+48(r0)  // V27 = JPEG Standard Quantization Row 4
  lqv v28[e0],Q+64(r0)  // V28 = JPEG Standard Quantization Row 5
  lqv v29[e0],Q+80(r0)  // V29 = JPEG Standard Quantization Row 6
  lqv v30[e0],Q+96(r0)  // V30 = JPEG Standard Quantization Row 7
  lqv v31[e0],Q+112(r0) // V31 = JPEG Standard Quantization Row 8

lui a1,$0010 // A1 = Aligned DRAM Physical RAM Offset ($00000000..$007FFFFF 8MB)
la a2,DCTQBLOCKS // A2 = Aligned DRAM Physical RAM Offset ($00000000..$007FFFFF 8MB)

// DCT Block Decode (Inverse Quantization)
  ori s1,r0,(240/8)-1 // S1 = Row Block Count -1
  ori s2,r0,(320/8)-1 // S2 = Column Block Count -1

LoopDMA:
  lui a0,$0000 // A0 = DCTQ 8x8 Matrix DMEM Address

// DMA 4096 Bytes Of DCTQBlocks
  ori t0,r0,4095 // T0 = Length Of DMA Transfer In Bytes - 1
  mtc0 r0,c0 // Store Memory Offset To SP Memory Address Register ($A4040000)
  mtc0 a2,c1 // Store RAM Offset To SP DRAM Address Register ($A4040004)
  mtc0 t0,c2 // Store DMA Length To SP Read Length Register ($A4040008)

  DATADMAREADBusy:
    mfc0 t0,c4 // T0 = RSP Status Register ($A4040010)
    andi t0,RSP_BSY|RSP_FUL // AND RSP Status Status With $C (Bit 2 = DMA Is Busy, Bit 3 = DMA Is Full)
    bnez t0,DATADMAREADBusy // IF TRUE DMA Is Busy
    nop // Delay Slot

  addiu a2,4096 // DCTQBLOCKS += 4096


  ori s0,r0,31 // S0 = DMEM Block Count -1

LoopBlocks:
  lqv v2[e0],$00(a0) // V2 = DCTQ Row 1
  lqv v3[e0],$10(a0) // V3 = DCTQ Row 2
  lqv v4[e0],$20(a0) // V4 = DCTQ Row 3
  lqv v5[e0],$30(a0) // V5 = DCTQ Row 4
  lqv v6[e0],$40(a0) // V6 = DCTQ Row 5
  lqv v7[e0],$50(a0) // V7 = DCTQ Row 6
  lqv v8[e0],$60(a0) // V8 = DCTQ Row 7
  lqv v9[e0],$70(a0) // V9 = DCTQ Row 8
  
  vmudn v2,v24[e0] // DCTQ *= Q Row 1
  vmudn v3,v25[e0] // DCTQ *= Q Row 2
  vmudn v4,v26[e0] // DCTQ *= Q Row 3
  vmudn v5,v27[e0] // DCTQ *= Q Row 4
  vmudn v6,v28[e0] // DCTQ *= Q Row 5
  vmudn v7,v29[e0] // DCTQ *= Q Row 6
  vmudn v8,v30[e0] // DCTQ *= Q Row 7
  vmudn v9,v31[e0] // DCTQ *= Q Row 8

  sqv v2[e0],$00(a0) // DCTQ Row 1 = V2
  sqv v3[e0],$10(a0) // DCTQ Row 2 = V3
  sqv v4[e0],$20(a0) // DCTQ Row 3 = V4
  sqv v5[e0],$30(a0) // DCTQ Row 4 = V5
  sqv v6[e0],$40(a0) // DCTQ Row 5 = V6
  sqv v7[e0],$50(a0) // DCTQ Row 6 = V7
  sqv v8[e0],$60(a0) // DCTQ Row 7 = V8
  sqv v9[e0],$70(a0) // DCTQ Row 8 = V9

// Decode DCT 8x8 Block Using IDCT
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


// Output 8x8 Block Of Pixel Values To RGB Tile
  // Row 0:
  vmudl v16,v1[e15] // V16 >>= 3 (8-Bit -> 5-Bit)
  vmudn v16,v1[e13] // V16 <<= 1 (5-Bit Blue)
  vmudn v2,v16,v1[e14] // V2 = V16 << 5 (5-Bit Green)
  vadd v16,v2[e0] // V16 += V2
  vmudn v2,v1[e14] // V2 <<= 5 (5-Bit Red)
  vadd v16,v2[e0] // V16 += V2
  sqv v16[e0],$00(a0) // Store 16-Bit RGBA Values

  // Row 1:
  vmudl v17,v1[e15] // V17 >>= 3 (8-Bit -> 5-Bit)
  vmudn v17,v1[e13] // V17 <<= 1 (5-Bit Blue)
  vmudn v2,v17,v1[e14] // V2 = V17 << 5 (5-Bit Green)
  vadd v17,v2[e0] // V17 += V2
  vmudn v2,v1[e14] // V2 <<= 5 (5-Bit Red)
  vadd v17,v2[e0] // V17 += V2
  sqv v17[e0],$10(a0) // Store 16-Bit RGBA Values

  // Row 2:
  vmudl v18,v1[e15] // V18 >>= 3 (8-Bit -> 5-Bit)
  vmudn v18,v1[e13] // V18 <<= 1 (5-Bit Blue)
  vmudn v2,v18,v1[e14] // V2 = V18 << 5 (5-Bit Green)
  vadd v18,v2[e0] // V18 += V2
  vmudn v2,v1[e14] // V2 <<= 5 (5-Bit Red)
  vadd v18,v2[e0] // V18 += V2
  sqv v18[e0],$20(a0) // Store 16-Bit RGBA Values

  // Row 3:
  vmudl v19,v1[e15] // V19 >>= 3 (8-Bit -> 5-Bit)
  vmudn v19,v1[e13] // V19 <<= 1 (5-Bit Blue)
  vmudn v2,v19,v1[e14] // V2 = V19 << 5 (5-Bit Green)
  vadd v19,v2[e0] // V19 += V2
  vmudn v2,v1[e14] // V2 <<= 5 (5-Bit Red)
  vadd v19,v2[e0] // V19 += V2
  sqv v19[e0],$30(a0) // Store 16-Bit RGBA Values

  // Row 4:
  vmudl v20,v1[e15] // V20 >>= 3 (8-Bit -> 5-Bit)
  vmudn v20,v1[e13] // V20 <<= 1 (5-Bit Blue)
  vmudn v2,v20,v1[e14] // V2 = V20 << 5 (5-Bit Green)
  vadd v20,v2[e0] // V20 += V2
  vmudn v2,v1[e14] // V2 <<= 5 (5-Bit Red)
  vadd v20,v2[e0] // V20 += V2
  sqv v20[e0],$40(a0) // Store 16-Bit RGBA Values

  // Row 5:
  vmudl v21,v1[e15] // V21 >>= 3 (8-Bit -> 5-Bit)
  vmudn v21,v1[e13] // V21 <<= 1 (5-Bit Blue)
  vmudn v2,v21,v1[e14] // V2 = V21 << 5 (5-Bit Green)
  vadd v21,v2[e0] // V21 += V2
  vmudn v2,v1[e14] // V2 <<= 5 (5-Bit Red)
  vadd v21,v2[e0] // V21 += V2
  sqv v21[e0],$50(a0) // Store 16-Bit RGBA Values

  // Row 6:
  vmudl v22,v1[e15] // V22 >>= 3 (8-Bit -> 5-Bit)
  vmudn v22,v1[e13] // V22 <<= 1 (5-Bit Blue)
  vmudn v2,v22,v1[e14] // V2 = V22 << 5 (5-Bit Green)
  vadd v22,v2[e0] // V22 += V2
  vmudn v2,v1[e14] // V2 <<= 5 (5-Bit Red)
  vadd v22,v2[e0] // V22 += V2
  sqv v22[e0],$60(a0) // Store 16-Bit RGBA Values

  // Row 7:
  vmudl v23,v1[e15] // V23 >>= 3 (8-Bit -> 5-Bit)
  vmudn v23,v1[e13] // V23 <<= 1 (5-Bit Blue)
  vmudn v2,v23,v1[e14] // V2 = V23 << 5 (5-Bit Green)
  vadd v23,v2[e0] // V23 += V2
  vmudn v2,v1[e14] // V2 <<= 5 (5-Bit Red)
  vadd v23,v2[e0] // V23 += V2
  sqv v23[e0],$70(a0) // Store 16-Bit RGBA Values


// DMA & Stride RGB Tile To VI RAM
  li t0,((8*2)-1) | (7<<12) | (((320-8)*2)<<20) // T0 = Length Of DMA Transfer In Bytes - 1, DMA Line Count - 1, Line Skip/Stride
  mtc0 a0,c0 // Store Memory Offset To SP Memory Address Register ($A4040000)
  mtc0 a1,c1 // Store RAM Offset To SP DRAM Address Register ($A4040004)
  mtc0 t0,c3 // Store DMA Length To SP Write Length Register ($A404000C)


  bnez s2,ContinueRow // IF (Column Count != 0) Continue Row
  subiu s2,1 // Column Count-- (Delay Slot)
  ori s2,r0,(320/8)-1 // S2 = Column Block Count -1
  addiu a1,320*7*2 // A1 += 7 Scanlines

  bnez s1,ContinueRow // IF (Row Count != 0) Continue Row
  subiu s1,1 // Row Count-- (Delay Slot)

  ContinueRow:
    beqz s1,Finished // IF (Row Count == 0) Finished
    nop // Delay Slot

  addiu a0,128 // A0 += Block Size
  addiu a1,16 // A1 += Block Width

  bnez s0,LoopBlocks // IF (DMEM Block Count != 0) Loop Blocks
  subiu s0,1 // DMEM Block Count-- (Delay Slot)

  b LoopDMA
    nop // Delay Slot

  Finished:
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
align(8) // Align 64-Bit
base RSPCode+pc() // Set End Of RSP Code Object
RSPCodeEnd:

align(8) // Align 64-Bit
RSPData:
base $0000 // Set Base Of RSP Data Object To Zero

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
  dh $0002  //  Left Shift Using Multiply: << 1 Vector Register B[5]
  dh $0020  //  Left Shift Using Multiply: << 5 Vector Register B[6]
  dh $2000  // Right Shift Using Multiply: >> 3 Vector Register B[7]

//Q: // JPEG Standard Quantization 8x8 Result Matrix (Quality = 10)
//  dh 80,55,50,80,120,200,255,255
//  dh 60,60,70,95,130,255,255,255
//  dh 70,65,80,120,200,255,255,255
//  dh 70,85,110,145,255,255,255,255
//  dh 90,110,185,255,255,255,255,255
//  dh 120,175,255,255,255,255,255,255
//  dh 245,255,255,255,255,255,255,255
//  dh 255,255,255,255,255,255,255,255

//Q: // JPEG Standard Quantization 8x8 Result Matrix (Quality = 50)
//  dh 16,11,10,16,24,40,51,61
//  dh 12,12,14,19,26,58,60,55
//  dh 14,13,16,24,40,57,69,56
//  dh 14,17,22,29,51,87,80,62
//  dh 18,22,37,56,68,109,103,77
//  dh 24,35,55,64,81,104,113,92
//  dh 49,64,78,87,103,121,120,101
//  dh 72,92,95,98,112,100,103,99

Q: // JPEG Standard Quantization 8x8 Result Matrix (Quality = 90)
  dh 3,2,2,3,5,8,10,12
  dh 2,2,3,4,5,12,12,11
  dh 3,3,3,5,8,11,14,11
  dh 3,3,4,6,10,17,16,12
  dh 4,4,7,11,14,22,21,15
  dh 5,7,11,13,16,21,23,18
  dh 10,13,16,17,21,24,24,20
  dh 14,18,19,20,22,20,21,20

align(8) // Align 64-Bit
base RSPData+pc() // Set End Of RSP Data Object
RSPDataEnd:

DCTQBLOCKS: // DCT Quantization 8x8 Matrix Blocks (Signed 16-Bit)
  //insert "frame10.dct" // Frame Quality = 10
  //insert "frame50.dct" // Frame Quality = 50
  insert "frame90.dct" // Frame Quality = 90