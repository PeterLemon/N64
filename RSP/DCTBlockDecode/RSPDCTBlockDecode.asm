// N64 'Bare Metal' RSP DCT Block Decode Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "RSPDCTBlockDecode.N64", create
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

  // Load RSP Code To IMEM
  DMASPRD(RSPCode, RSPCodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  // Load RSP Data To DMEM
  DMASPRD(RSPData, RSPDataEnd, SP_DMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

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
// Decode DCT 8x8 Block Using IDCT

  // Load COS/PI Look Up Table: COS Look Up Table Row 0 = 1.0 (128-Bit Quad) (Not Needed, Vector Multiply By 1.0)
                              // 1.0  COS Look Up Table Row 0 (*= 1.0)
  lqv v0[e0],COSLUT>>4(r0)    // V0 = COS Look Up Table Row 1 (128-Bit Quad)
  lqv v1[e0],COSLUT+16>>4(r0) // V1 = COS Look Up Table Row 2 (128-Bit Quad)
  lqv v2[e0],COSLUT+32>>4(r0) // V2 = COS Look Up Table Row 3 (128-Bit Quad)
  lqv v3[e0],COSLUT+48>>4(r0) // V3 = COS Look Up Table Row 4 (128-Bit Quad)
  lqv v4[e0],COSLUT+64>>4(r0) // V4 = COS Look Up Table Row 5 (128-Bit Quad)
  lqv v5[e0],COSLUT+80>>4(r0) // V5 = COS Look Up Table Row 6 (128-Bit Quad)
  lqv v6[e0],COSLUT+96>>4(r0) // V6 = COS Look Up Table Row 7 (128-Bit Quad)

  // Load C Look Up Table
  lqv v7[e0],CLUT>>4(r0)    // V7 = C Look Up Table Row 0    (128-Bit Quad)
  lqv v8[e0],CLUT+16>>4(r0) // V8 = C Look Up Table Row 1..7 (128-Bit Quad) (Row 1..7 Are The Same, Vector Multiply By 0.5)
  lqv v9[e0],CLUT+32>>4(r0) // V9 = C Look Up Table Row 1..7 (128-Bit Quad) (Row 1..7 Are The Same, Vector Multiply By 0.25)

  lqv v30[e0],ShiftLeftRightA>>4(r0) // V30 = Left Shift Using Multiply: << 0..7,  Right Shift Using Multiply: >> 16..9 (128-Bit Quad)
  lqv v31[e0],ShiftLeftRightB>>4(r0) // V31 = Left Shift Using Multiply: << 8..15, Right Shift Using Multiply: >> 8..1  (128-Bit Quad)


  la a0,DCT8x8 // A0 = DCT 8x8 Matrix DMEM Address

  // Load DCT Row
  lqv v10[e0],0(a0)  // V10 = DCT Row (128-Bit Quad)
  vmudn v10,v30[e12] // V10 <<= 4 (Fixed Point Precision)
  
  // Compute IDCT Row 0 (These 1st Calculations Are Used By All IDCT Rows)
  vmudl v11,v7,v10[e8] // V11 = IDCT Row: DCT[u0,v0] * C[u0]
  vmudl v11,v7[e0]     // V11 *= C[v0]
                       // V11 *= COS[Row 0] (*= 1)
                       // V11 *= COS[Row 0] (*= 1)

  vmudl v19,v8,v10[e9] // V19 = IDCT Row: += DCT[u1,v0] * C[u1]
  vmudl v19,v7[e0]     // V19 *= C[v0]
  vmulf v19,v0[e0]     // V19 *= COS[Row 1]
                       // V19 *= COS[Row 0] (*= 1)
  vadd v11,v19[e0]     // V11 += V19

  vmudl v19,v8,v10[e10] // V19 = IDCT Row: += DCT[u2,v0] * C[u2]
  vmudl v19,v7[e0]      // V19 *= C[v0]
  vmulf v19,v1[e0]      // V19 *= COS[Row 2]
                        // V19 *= COS[Row 0] (*= 1)
  vadd v11,v19[e0]      // V11 += V19

  vmudl v19,v8,v10[e11] // V19 = IDCT Row: += DCT[u3,v0] * C[u3]
  vmudl v19,v7[e0]      // V19 *= C[v0]
  vmulf v19,v2[e0]      // V19 *= COS[Row 3]
                        // V19 *= COS[Row 0] (*= 1)
  vadd v11,v19[e0]      // V11 += V19

  vmudl v19,v8,v10[e12] // V19 = IDCT Row: += DCT[u4,v0] * C[u4]
  vmudl v19,v7[e0]      // V19 *= C[v0]
  vmulf v19,v3[e0]      // V19 *= COS[Row 4]
                        // V19 *= COS[Row 0] (*= 1)
  vadd v11,v19[e0]      // V11 += V19

  vmudl v19,v8,v10[e13] // V19 = IDCT Row: += DCT[u5,v0] * C[u5]
  vmudl v19,v7[e0]      // V19 *= C[v0]
  vmulf v19,v4[e0]      // V19 *= COS[Row 5]
                        // V19 *= COS[Row 0] (*= 1)
  vadd v11,v19[e0]      // V11 += V19

  vmudl v19,v8,v10[e14] // V19 = IDCT Row: += DCT[u6,v0] * C[u6]
  vmudl v19,v7[e0]      // V19 *= C[v0]
  vmulf v19,v5[e0]      // V19 *= COS[Row 6]
                        // V19 *= COS[Row 0] (*= 1)
  vadd v11,v19[e0]      // V11 += V19

  vmudl v19,v8,v10[e15] // V19 = IDCT Row: += DCT[u7,v0] * C[u7]
  vmudl v19,v7[e0]      // V19 *= C[v0]
  vmulf v19,v6[e0]      // V19 *= COS[Row 7]
                        // V19 *= COS[Row 0] (*= 1)
  vadd v11,v19[e0]      // V11 += V19


  // V11 = IDCT Base Row 0 Data
  vmudn v12,v11,v30[e8] // V12 = V11 (Row 1)
  vmudn v13,v11,v30[e8] // V13 = V11 (Row 2)
  vmudn v14,v11,v30[e8] // V14 = V11 (Row 3)
  vmudn v15,v11,v30[e8] // V15 = V11 (Row 4)
  vmudn v16,v11,v30[e8] // V16 = V11 (Row 5)
  vmudn v17,v11,v30[e8] // V17 = V11 (Row 6)
  vmudn v18,v11,v30[e8] // V18 = V11 (Row 7)


  li t0,6 // T0 = Row Count
  
  IDCTLoopRow:
  // Load DCT Row
  addiu a0,16 // DCT 8x8 Matrix DMEM Address += 16
  lqv v10[e0],0(a0)  // V10 = DCT Row (128-Bit Quad)
  vmudn v10,v30[e12] // V10 <<= 4 (More Fixed Point Precision)

  vmudl v19,v7,v10[e8]  // V19 = IDCT Row: DCT[u0,v1] * C[u0]
  vmudl v19,v8[e0]      // V19 *= C[v1]
                        // V19 *= COS[Row 0] (*= 1)
                        // V19 *= COS[Row 0] (*= 1)
  vadd v11,v19[e0]      // V11 += V19
  vmulf v20,v19,v0[e9]  // V20 = V19 * COS[Row 1]
  vadd v12,v20[e0]      // V12 += V20
  vmulf v20,v19,v0[e10] // V20 = V19 * COS[Row 2]
  vadd v13,v20[e0]      // V13 += V20
  vmulf v20,v19,v0[e11] // V20 = V19 * COS[Row 3]
  vadd v14,v20[e0]      // V14 += V20
  vmulf v20,v19,v0[e12] // V20 = V19 * COS[Row 4]
  vadd v15,v20[e0]      // V15 += V20
  vmulf v20,v19,v0[e13] // V20 = V19 * COS[Row 5]
  vadd v16,v20[e0]      // V16 += V20
  vmulf v20,v19,v0[e14] // V20 = V19 * COS[Row 6]
  vadd v17,v20[e0]      // V17 += V20
  vmulf v20,v19,v0[e15] // V20 = V19 * COS[Row 7]
  vadd v18,v20[e0]      // V18 += V20

  vmudl v19,v9,v10[e9]  // V19 = IDCT Row: += DCT[u1,v1] * C[u1,v1]
  vmulf v19,v0[e0]      // V19 *= COS[Row 1]
                        // V19 *= COS[Row 0] (*= 1)
  vadd v11,v19[e0]      // V11 += V19
  vmulf v20,v19,v0[e9]  // V20 = V19 * COS[Row 1]
  vadd v12,v20[e0]      // V12 += V20
  vmulf v20,v19,v0[e10] // V20 = V19 * COS[Row 2]
  vadd v13,v20[e0]      // V13 += V20
  vmulf v20,v19,v0[e11] // V20 = V19 * COS[Row 3]
  vadd v14,v20[e0]      // V14 += V20
  vmulf v20,v19,v0[e12] // V20 = V19 * COS[Row 4]
  vadd v15,v20[e0]      // V15 += V20
  vmulf v20,v19,v0[e13] // V20 = V19 * COS[Row 5]
  vadd v16,v20[e0]      // V16 += V20
  vmulf v20,v19,v0[e14] // V20 = V19 * COS[Row 6]
  vadd v17,v20[e0]      // V17 += V20
  vmulf v20,v19,v0[e15] // V20 = V19 * COS[Row 7]
  vadd v18,v20[e0]      // V18 += V20

  vmudl v19,v9,v10[e10] // V19 = IDCT Row: += DCT[u2,v1] * C[u2,v1]
  vmulf v19,v1[e0]      // V19 *= COS[Row 2]
                        // V19 *= COS[Row 0] (*= 1)
  vadd v11,v19[e0]      // V11 += V19
  vmulf v20,v19,v0[e9]  // V20 = V19 * COS[Row 1]
  vadd v12,v20[e0]      // V12 += V20
  vmulf v20,v19,v0[e10] // V20 = V19 * COS[Row 2]
  vadd v13,v20[e0]      // V13 += V20
  vmulf v20,v19,v0[e11] // V20 = V19 * COS[Row 3]
  vadd v14,v20[e0]      // V14 += V20
  vmulf v20,v19,v0[e12] // V20 = V19 * COS[Row 4]
  vadd v15,v20[e0]      // V15 += V20
  vmulf v20,v19,v0[e13] // V20 = V19 * COS[Row 5]
  vadd v16,v20[e0]      // V16 += V20
  vmulf v20,v19,v0[e14] // V20 = V19 * COS[Row 6]
  vadd v17,v20[e0]      // V17 += V20
  vmulf v20,v19,v0[e15] // V20 = V19 * COS[Row 7]
  vadd v18,v20[e0]      // V18 += V20

  vmudl v19,v9,v10[e11] // V19 = IDCT Row: += DCT[u3,v1] * C[u3,v1]
  vmulf v19,v2[e0]      // V19 *= COS[Row 3]
                        // V19 *= COS[Row 0] (*= 1)
  vadd v11,v19[e0]      // V11 += V19
  vmulf v20,v19,v0[e9]  // V20 = V19 * COS[Row 1]
  vadd v12,v20[e0]      // V12 += V20
  vmulf v20,v19,v0[e10] // V20 = V19 * COS[Row 2]
  vadd v13,v20[e0]      // V13 += V20
  vmulf v20,v19,v0[e11] // V20 = V19 * COS[Row 3]
  vadd v14,v20[e0]      // V14 += V20
  vmulf v20,v19,v0[e12] // V20 = V19 * COS[Row 4]
  vadd v15,v20[e0]      // V15 += V20
  vmulf v20,v19,v0[e13] // V20 = V19 * COS[Row 5]
  vadd v16,v20[e0]      // V16 += V20
  vmulf v20,v19,v0[e14] // V20 = V19 * COS[Row 6]
  vadd v17,v20[e0]      // V17 += V20
  vmulf v20,v19,v0[e15] // V20 = V19 * COS[Row 7]
  vadd v18,v20[e0]      // V18 += V20

  vmudl v19,v9,v10[e12] // V19 = IDCT Row: += DCT[u4,v1] * C[u4,v1]
  vmulf v19,v3[e0]      // V19 *= COS[Row 4]
                        // V19 *= COS[Row 0] (*= 1)
  vadd v11,v19[e0]      // V11 += V19
  vmulf v20,v19,v0[e9]  // V20 = V19 * COS[Row 1]
  vadd v12,v20[e0]      // V12 += V20
  vmulf v20,v19,v0[e10] // V20 = V19 * COS[Row 2]
  vadd v13,v20[e0]      // V13 += V20
  vmulf v20,v19,v0[e11] // V20 = V19 * COS[Row 3]
  vadd v14,v20[e0]      // V14 += V20
  vmulf v20,v19,v0[e12] // V20 = V19 * COS[Row 4]
  vadd v15,v20[e0]      // V15 += V20
  vmulf v20,v19,v0[e13] // V20 = V19 * COS[Row 5]
  vadd v16,v20[e0]      // V16 += V20
  vmulf v20,v19,v0[e14] // V20 = V19 * COS[Row 6]
  vadd v17,v20[e0]      // V17 += V20
  vmulf v20,v19,v0[e15] // V20 = V19 * COS[Row 7]
  vadd v18,v20[e0]      // V18 += V20

  vmudl v19,v9,v10[e13] // V19 = IDCT Row: += DCT[u5,v1] * C[u5,v1]
  vmulf v19,v4[e0]      // V19 *= COS[Row 5]
                        // V19 *= COS[Row 0] (*= 1)
  vadd v11,v19[e0]      // V11 += V19
  vmulf v20,v19,v0[e9]  // V20 = V19 * COS[Row 1]
  vadd v12,v20[e0]      // V12 += V20
  vmulf v20,v19,v0[e10] // V20 = V19 * COS[Row 2]
  vadd v13,v20[e0]      // V13 += V20
  vmulf v20,v19,v0[e11] // V20 = V19 * COS[Row 3]
  vadd v14,v20[e0]      // V14 += V20
  vmulf v20,v19,v0[e12] // V20 = V19 * COS[Row 4]
  vadd v15,v20[e0]      // V15 += V20
  vmulf v20,v19,v0[e13] // V20 = V19 * COS[Row 5]
  vadd v16,v20[e0]      // V16 += V20
  vmulf v20,v19,v0[e14] // V20 = V19 * COS[Row 6]
  vadd v17,v20[e0]      // V17 += V20
  vmulf v20,v19,v0[e15] // V20 = V19 * COS[Row 7]
  vadd v18,v20[e0]      // V18 += V20

  vmudl v19,v9,v10[e14] // V19 = IDCT Row: += DCT[u6,v1] * C[u6,v1]
  vmulf v19,v5[e0]      // V19 *= COS[Row 6]
                        // V19 *= COS[Row 0] (*= 1)
  vadd v11,v19[e0]      // V11 += V19
  vmulf v20,v19,v0[e9]  // V20 = V19 * COS[Row 1]
  vadd v12,v20[e0]      // V12 += V20
  vmulf v20,v19,v0[e10] // V20 = V19 * COS[Row 2]
  vadd v13,v20[e0]      // V13 += V20
  vmulf v20,v19,v0[e11] // V20 = V19 * COS[Row 3]
  vadd v14,v20[e0]      // V14 += V20
  vmulf v20,v19,v0[e12] // V20 = V19 * COS[Row 4]
  vadd v15,v20[e0]      // V15 += V20
  vmulf v20,v19,v0[e13] // V20 = V19 * COS[Row 5]
  vadd v16,v20[e0]      // V16 += V20
  vmulf v20,v19,v0[e14] // V20 = V19 * COS[Row 6]
  vadd v17,v20[e0]      // V17 += V20
  vmulf v20,v19,v0[e15] // V20 = V19 * COS[Row 7]
  vadd v18,v20[e0]      // V18 += V20

  vmudl v19,v9,v10[e15] // V19 = IDCT Row: += DCT[u7,v1] * C[u7,v1]
  vmulf v19,v6[e0]      // V19 *= COS[Row 7]
                        // V19 *= COS[Row 0] (*= 1)
  vadd v11,v19[e0]      // V11 += V19
  vmulf v20,v19,v0[e9]  // V20 = V19 * COS[Row 1]
  vadd v12,v20[e0]      // V12 += V20
  vmulf v20,v19,v0[e10] // V20 = V19 * COS[Row 2]
  vadd v13,v20[e0]      // V13 += V20
  vmulf v20,v19,v0[e11] // V20 = V19 * COS[Row 3]
  vadd v14,v20[e0]      // V14 += V20
  vmulf v20,v19,v0[e12] // V20 = V19 * COS[Row 4]
  vadd v15,v20[e0]      // V15 += V20
  vmulf v20,v19,v0[e13] // V20 = V19 * COS[Row 5]
  vadd v16,v20[e0]      // V16 += V20
  vmulf v20,v19,v0[e14] // V20 = V19 * COS[Row 6]
  vadd v17,v20[e0]      // V17 += V20
  vmulf v20,v19,v0[e15] // V20 = V19 * COS[Row 7]
  vadd v18,v20[e0]      // V18 += V20

  bnez t0,IDCTLoopRow // IF (Row Count != 0) IDCT Loop Row
  subiu t0,1 // Row Count--


  vmudl v11,v31[e12] // V11 >>= 4 (Fixed Point Precision)
  vmudl v12,v31[e12] // V12 >>= 4 (Fixed Point Precision)
  vmudl v13,v31[e12] // V13 >>= 4 (Fixed Point Precision)
  vmudl v14,v31[e12] // V14 >>= 4 (Fixed Point Precision)
  vmudl v15,v31[e12] // V15 >>= 4 (Fixed Point Precision)
  vmudl v16,v31[e12] // V16 >>= 4 (Fixed Point Precision)
  vmudl v17,v31[e12] // V17 >>= 4 (Fixed Point Precision)
  vmudl v18,v31[e12] // V18 >>= 4 (Fixed Point Precision)
  // V11 = IDCT Row 0
  // V12 = IDCT Row 1
  // V13 = IDCT Row 2
  // V14 = IDCT Row 3
  // V15 = IDCT Row 4
  // V16 = IDCT Row 5
  // V17 = IDCT Row 6
  // V18 = IDCT Row 7


// DMA & Stride RGB Tile To VI RAM
  li t0,((8*4)-1) | (7<<12) | (((320-8)*4)<<20) // T0 = Length Of DMA Transfer In Bytes - 1, DMA Line Count - 1, Line Skip/Stride
  lli a0,SP_DMEM // A0 = SP Memory Address Offset DMEM $000 ($A4000000..$A4001FFF 8KB)
  la a1,$100000 | ((320*4)*104)+(144*4) // A1 = Aligned DRAM Physical RAM Offset ($00000000..$007FFFFF 8MB)
  
  mtc0 a0,c0 // Store Memory Offset To SP Memory Address Register ($A4040000)
  mtc0 a1,c1 // Store RAM Offset To SP DRAM Address Register ($A4040004)
  mtc0 t0,c3 // Store DMA Length To SP Write Length Register ($A404000C)

  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
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

DCT8x8:
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

  dh 700,100,100,0,0,0,0,0 // Now Let's Add An AC Value At The Other Direction.
  dh 200,0,0,0,0,0,0,0     // Now The Values Vary In Y Direction, Too. The Principle Is:
  dh 0,0,0,0,0,0,0,0       // The Higher The Index Of The AC Value The Greater The Frequency Is.
  dh 0,0,0,0,0,0,0,0
  dh 0,0,0,0,0,0,0,0
  dh 0,0,0,0,0,0,0,0
  dh 0,0,0,0,0,0,0,0
  dh 0,0,0,0,0,0,0,0

  //dh 950,0,0,0,0,0,0,0 // Placing An AC Value At The Opposite Side Of The DC Value.
  //dh 0,0,0,0,0,0,0,0   // The Highest Possible Frequency Of 8 Is Applied In Both X- & Y- Direction.
  //dh 0,0,0,0,0,0,0,0   // Because Of The High Frequency The Neighbouring Values Differ Numerously.
  //dh 0,0,0,0,0,0,0,0   // The Picture Shows A Checker-Like Appearance.
  //dh 0,0,0,0,0,0,0,0
  //dh 0,0,0,0,0,0,0,0
  //dh 0,0,0,0,0,0,0,0
  //dh 0,0,0,0,0,0,0,500

CLUT: // C Look Up Table (/2 Applied) Unsigned Fraction (U0.16) (Float / 65536)
  dh 23170,23170,23170,23170,23170,23170,23170,23170 // 1/(2*sqrt(2)),1/(2*sqrt(2)),1/(2*sqrt(2)),1/(2*sqrt(2)),1/(2*sqrt(2)),1/(2*sqrt(2)),1/(2*sqrt(2)),1/(2*sqrt(2))
  dh 32768,32768,32768,32768,32768,32768,32768,32768 // 0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5
  dh 16384,16384,16384,16384,16384,16384,16384,16384 // 0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25

COSLUT: // COS Look Up Table Signed Fraction (S1.15) (Float / 32768)
  dh 32138,27246,18205,6393,-6393,-18205,-27246,-32138
  dh 30274,12540,-12540,-30274,-30274,-12540,12540,30274
  dh 27246,-6393,-32138,-18205,18205,32138,6393,-27246
  dh 23170,-23170,-23170,23170,23170,-23170,-23170,23170
  dh 18205,-32138,6393,27246,-27246,-6393,32138,-18205
  dh 12540,-30274,30274,-12540,-12540,30274,-30274,12540
  dh 6393,-18205,27246,-32138,32138,-27246,18205,-6393

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

align(8) // Align 64-Bit
base RSPData+pc() // Set End Of RSP Data Object
RSPDataEnd: