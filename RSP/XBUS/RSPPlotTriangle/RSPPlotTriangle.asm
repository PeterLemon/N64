// N64 'Bare Metal' RSP Plot Triangle Test by krom (Peter Lemon):
arch n64.cpu
endian msb
output "RSPPlotTriangle.N64", create
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

  SetXBUS() // RDP Status: Set XBUS (Switch To RSP DMEM For RDP Commands)

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
// Load 8 Triangles 3 X Points Into 3 Vectors
  lqv v0[e0],TriX1(r0) // V0 = 1st X Point Of 8 Triangles ($000)
  lqv v1[e0],TriX2(r0) // V1 = 2nd X Point Of 8 Triangles ($010)
  lqv v2[e0],TriX3(r0) // V2 = 3rd X Point Of 8 Triangles ($020)

// Load 8 Triangles 3 Y Points Into 3 Vectors
  lqv v3[e0],TriY1(r0) // V3 = 1st Y Point Of 8 Triangles ($030)
  lqv v4[e0],TriY2(r0) // V4 = 2nd Y Point Of 8 Triangles ($040)
  lqv v5[e0],TriY3(r0) // V5 = 3rd Y Point Of 8 Triangles ($050)

  vsub v31,v31[e0] // Store Zero To V31

// Calculate Triangle Coefficiants
  // Sort Of Parallel X Elements Within 3 Vectors (Uses Vector Merge To Sort Y Elements Within 3 Vectors)
  vge v6,v0,v1[e0] // VGE TMP1,  MIN, MID
  vmrg v8,v3,v4[e0]

  vlt v10,v0,v1[e0] // VLT  MIN,  MIN, MID
  vmrg v3,v3,v4[e0]

  vge v7,v10,v2[e0] // VGE TMP2,  MIN, MAX
  vmrg v9,v3,v5[e0]

  vlt v10,v10,v2[e0] // VLT  MIN,  MIN, MAX
  vmrg v3,v3,v5[e0]

  vge v2,v6,v7[e0] // VGE  MAX, TMP1, TMP2
  vmrg v5,v8,v9[e0]

  vlt v11,v6,v7[e0] // VLT  MID, TMP1, TMP2
  vmrg v4,v8,v9[e0]

  // Sort Of Parallel Y Elements Within 3 Vectors (Uses Vector Merge To Sort X Elements Within 3 Vectors)
  vge v6,v3,v4[e0] // VGE TMP1,  MIN, MID
  vmrg v8,v10,v11[e0]

  vlt v3,v3,v4[e0] // VLT  MIN,  MIN, MID
  vmrg v10,v10,v11[e0]

  vge v7,v3,v5[e0] // VGE TMP2,  MIN, MAX
  vmrg v9,v10,v2[e0]

  vlt v3,v3,v5[e0] // VLT  MIN,  MIN, MAX
  vmrg v10,v10,v2[e0]

  vge v5,v6,v7[e0] // VGE  MAX, TMP1, TMP2
  vmrg v2,v8,v9[e0]

  vlt v4,v6,v7[e0] // VLT  MID, TMP1, TMP2
  vmrg v11,v8,v9[e0]

  // IF Coordinate 0 & 1 Share Same Y: Sort By X Coordinates (Lowest To Highest)
  vlt v6,v3,v4[e0] // VLT TMP1, MIN, MID
  vmrg v0,v10,v11[e0]

  vge v6,v3,v4[e0] // VGE TMP1, MIN, MID
  vmrg v1,v10,v11[e0]

  // V0 = MIN XH, V1=MID XM, V2=MAX XL
  // V3 = MIN YH, V4=MID YM, V5=MAX YL


  // DxLDy = (XL-XM) / (YL-YM)
  vsub v6,v2,v1[e0] // V6 = XL-XM
  vsub v7,v5,v4[e0] // V7 = YL-YM

  vne v8,v5,v4[e0] // IF (YL-YM) == 0, Merge Zero Data, For Zero Result (Divide by Zero)
  vmrg v6,v6,v7[e0]

  vrcp v8[e0],v7[e0]   // Result Fraction (Zero), Source Integer (YL-YM 1)
  vrcph v7[e0],v31[e0] // Result Integer, Source Fraction (Zero)

  vrcp v8[e0],v7[e1]   // Result Fraction (Zero), Source Integer (YL-YM 2)
  vrcph v7[e1],v31[e0] // Result Integer, Source Fraction (Zero)

  vrcp v8[e0],v7[e2]   // Result Fraction (Zero), Source Integer (YL-YM 3)
  vrcph v7[e2],v31[e0] // Result Integer, Source Fraction (Zero)

  vrcp v8[e0],v7[e3]   // Result Fraction (Zero), Source Integer (YL-YM 4)
  vrcph v7[e3],v31[e0] // Result Integer, Source Fraction (Zero)

  vrcp v8[e0],v7[e4]   // Result Fraction (Zero), Source Integer (YL-YM 5)
  vrcph v7[e4],v31[e0] // Result Integer, Source Fraction (Zero)

  vrcp v8[e0],v7[e5]   // Result Fraction (Zero), Source Integer (YL-YM 6)
  vrcph v7[e5],v31[e0] // Result Integer, Source Fraction (Zero)

  vrcp v8[e0],v7[e6]   // Result Fraction (Zero), Source Integer (YL-YM 7)
  vrcph v7[e6],v31[e0] // Result Integer, Source Fraction (Zero)

  vrcp v8[e0],v7[e7]   // Result Fraction (Zero), Source Integer (YL-YM 8)
  vrcph v7[e7],v31[e0] // Result Integer, Source Fraction (Zero)

  vadd v7,v7[e0] // Multiply Reciprocal Numbers By 2.0, To Use With Double Multiply Of Signed Integer By Unsigned Fraction
  vmudm v6,v6,v7[e0]   // Result Signed Integer, Source Signed Integer, Source Unsigned Fraction (Reciprocal)
  vmadn v7,v31,v31[e0] // Result Unsigned Fraction, Zero, Zero

  // V6 = DxLDy Integer  (Tri1=e0, Tri2=e1, Tri3=e2, Tri4=e3, Tri5=e4, Tri6=e5, Tri7=e6, Tri8=e7)
  // V7 = DxLDy Fraction (Tri1=e0, Tri2=e1, Tri3=e2, Tri4=e3, Tri5=e4, Tri6=e5, Tri7=e6, Tri8=e7)


  // DxMDy = (XM-XH) / (YM-YH)
  vsub v8,v1,v0[e0] // V8 = XM-XH
  vsub v9,v4,v3[e0] // V9 = YM-YH

  vne v10,v4,v3[e0] // IF (YM-YH) == 0, Merge Zero Data, For Zero Result (Divide by Zero)
  vmrg v8,v8,v9[e0]

  vrcp v10[e0],v9[e0]  // Result Fraction (Zero), Source Integer (YM-YH 1)
  vrcph v9[e0],v31[e0] // Result Integer, Source Fraction (Zero)

  vrcp v10[e0],v9[e1]  // Result Fraction (Zero), Source Integer (YM-YH 2)
  vrcph v9[e1],v31[e0] // Result Integer, Source Fraction (Zero)

  vrcp v10[e0],v9[e2]  // Result Fraction (Zero), Source Integer (YM-YH 3)
  vrcph v9[e2],v31[e0] // Result Integer, Source Fraction (Zero)

  vrcp v10[e0],v9[e3]  // Result Fraction (Zero), Source Integer (YM-YH 4)
  vrcph v9[e3],v31[e0] // Result Integer, Source Fraction (Zero)

  vrcp v10[e0],v9[e4]  // Result Fraction (Zero), Source Integer (YM-YH 5)
  vrcph v9[e4],v31[e0] // Result Integer, Source Fraction (Zero)

  vrcp v10[e0],v9[e5]  // Result Fraction (Zero), Source Integer (YM-YH 6)
  vrcph v9[e5],v31[e0] // Result Integer, Source Fraction (Zero)

  vrcp v10[e0],v9[e6]  // Result Fraction (Zero), Source Integer (YM-YH 7)
  vrcph v9[e6],v31[e0] // Result Integer, Source Fraction (Zero)

  vrcp v10[e0],v9[e7]  // Result Fraction (Zero), Source Integer (YM-YH 8)
  vrcph v9[e7],v31[e0] // Result Integer, Source Fraction (Zero)

  vadd v9,v9[e0] // Multiply Reciprocal Numbers By 2.0, To Use With Double Multiply Of Signed Integer By Unsigned Fraction
  vmudm v8,v8,v9[e0]   // Result Signed Integer, Source Signed Integer, Source Unsigned Fraction (Reciprocal)
  vmadn v9,v31,v31[e0] // Result Unsigned Fraction, Zero, Zero

  // V8 = DxMDy Integer  (Tri1=e0, Tri2=e1, Tri3=e2, Tri4=e3, Tri5=e4, Tri6=e5, Tri7=e6, Tri8=e7)
  // V9 = DxMDy Fraction (Tri1=e0, Tri2=e1, Tri3=e2, Tri4=e3, Tri5=e4, Tri6=e5, Tri7=e6, Tri8=e7)


  // DxHDy = (XL-XH) / (YL-YH)
  vsub v10,v2,v0[e0] // V10 = XL-XH
  vsub v11,v5,v3[e0] // V11 = YL-YH

  vne v12,v5,v3[e0] // IF (YL-YH) == 0, Merge Zero Data, For Zero Result (Divide by Zero)
  vmrg v10,v10,v11[e0]

  vrcp v12[e0],v11[e0]  // Result Fraction (Zero), Source Integer (YL-YH 1)
  vrcph v11[e0],v31[e0] // Result Integer, Source Fraction (Zero)

  vrcp v12[e0],v11[e1]  // Result Fraction (Zero), Source Integer (YL-YH 2)
  vrcph v11[e1],v31[e0] // Result Integer, Source Fraction (Zero)

  vrcp v12[e0],v11[e2]  // Result Fraction (Zero), Source Integer (YL-YH 3)
  vrcph v11[e2],v31[e0] // Result Integer, Source Fraction (Zero)

  vrcp v12[e0],v11[e3]  // Result Fraction (Zero), Source Integer (YL-YH 4)
  vrcph v11[e3],v31[e0] // Result Integer, Source Fraction (Zero)

  vrcp v12[e0],v11[e4]  // Result Fraction (Zero), Source Integer (YL-YH 5)
  vrcph v11[e4],v31[e0] // Result Integer, Source Fraction (Zero)

  vrcp v12[e0],v11[e5]  // Result Fraction (Zero), Source Integer (YL-YH 6)
  vrcph v11[e5],v31[e0] // Result Integer, Source Fraction (Zero)

  vrcp v12[e0],v11[e6]  // Result Fraction (Zero), Source Integer (YL-YH 7)
  vrcph v11[e6],v31[e0] // Result Integer, Source Fraction (Zero)

  vrcp v12[e0],v11[e7]  // Result Fraction (Zero), Source Integer (YL-YH 8)
  vrcph v11[e7],v31[e0] // Result Integer, Source Fraction (Zero)

  vadd v11,v11[e0] // Multiply Reciprocal Numbers By 2.0, To Use With Double Multiply Of Signed Integer By Unsigned Fraction
  vmudm v10,v10,v11[e0] // Result Signed Integer, Source Signed Integer, Source Unsigned Fraction (Reciprocal)
  vmadn v11,v31,v31[e0] // Result Unsigned Fraction, Zero, Zero

  // V10 = DxHDy Integer  (Tri1=e0, Tri2=e1, Tri3=e2, Tri4=e3, Tri5=e4, Tri6=e5, Tri7=e6, Tri8=e7)
  // V11 = DxHDy Fraction (Tri1=e0, Tri2=e1, Tri3=e2, Tri4=e3, Tri5=e4, Tri6=e5, Tri7=e6, Tri8=e7)


// Calculate Left/Right Major Triangle Direction
  lqv v12[e0],DirLeftMajor(r0)  // V12 = Direction  Left Major 8 Triangles
  lqv v13[e0],DirRightMajor(r0) // V13 = Direction Right Major 8 Triangles
  vlt v14,v8,v10[e0] // IF (DxMDy Integer < DxHDy Integer), Direction = Left Major, ELSE Direction = Right Major
  vmrg v12,v12,v13[e0] // V12 = Direction Left/Right Major 8 Triangles


// Store Results To RDP Data
  // Multiply YH,YM,YL Values by 4.0 (<< = 2) For 11.2 Result
  // Load Shift Left/Right Vectors
  lqv v13[e0],ShiftLeftRightA(r0) // V13 = Left Shift Using Multiply: << 0..7,  Right Shift Using Multiply: >> 16..9 (128-Bit Quad)
  vmudn v3,v13[e10] // YH <<= 2
  vmudn v4,v13[e10] // YM <<= 2
  vmudn v5,v13[e10] // YL <<= 2


  la a0,RDPTriangle1
  ssv v12[e0],0(a0) // Store Triangle 1: Direction Left/Right Major

  ssv v5[e0],2(a0) // Store Triangle 1: YL Integer
  ssv v4[e0],4(a0) // Store Triangle 1: YM Integer
  ssv v3[e0],6(a0) // Store Triangle 1: YH Integer

  ssv v1[e0],8(a0)  // Store Triangle 1: XL Integer
  ssv v6[e0],12(a0) // Store Triangle 1: DxLDy Integer
  ssv v7[e0],14(a0) // Store Triangle 1: DxLDy Fraction

  ssv v0[e0],16(a0)  // Store Triangle 1: XH Integer
  ssv v10[e0],20(a0) // Store Triangle 1: DxHDy Integer
  ssv v11[e0],22(a0) // Store Triangle 1: DxHDy Fraction

  ssv v0[e0],24(a0) // Store Triangle 1: XM Integer
  ssv v8[e0],28(a0) // Store Triangle 1: DxMDy Integer
  ssv v9[e0],30(a0) // Store Triangle 1: DxMDy Fraction


  la a0,RDPTriangle2
  ssv v12[e2],0(a0) // Store Triangle 2: Direction Left/Right Major

  ssv v5[e2],2(a0) // Store Triangle 2: YL Integer
  ssv v4[e2],4(a0) // Store Triangle 2: YM Integer
  ssv v3[e2],6(a0) // Store Triangle 2: YH Integer

  ssv v1[e2],8(a0)  // Store Triangle 2: XL Integer
  ssv v6[e2],12(a0) // Store Triangle 2: DxLDy Integer
  ssv v7[e2],14(a0) // Store Triangle 2: DxLDy Fraction

  ssv v0[e2],16(a0)  // Store Triangle 2: XH Integer
  ssv v10[e2],20(a0) // Store Triangle 2: DxHDy Integer
  ssv v11[e2],22(a0) // Store Triangle 2: DxHDy Fraction

  ssv v0[e2],24(a0) // Store Triangle 2: XM Integer
  ssv v8[e2],28(a0) // Store Triangle 2: DxMDy Integer
  ssv v9[e2],30(a0) // Store Triangle 2: DxMDy Fraction


  la a0,RDPTriangle3
  ssv v12[e4],0(a0) // Store Triangle 3: Direction Left/Right Major

  ssv v5[e4],2(a0) // Store Triangle 3: YL Integer
  ssv v4[e4],4(a0) // Store Triangle 3: YM Integer
  ssv v3[e4],6(a0) // Store Triangle 3: YH Integer

  ssv v1[e4],8(a0)  // Store Triangle 3: XL Integer
  ssv v6[e4],12(a0) // Store Triangle 3: DxLDy Integer
  ssv v7[e4],14(a0) // Store Triangle 3: DxLDy Fraction

  ssv v0[e4],16(a0)  // Store Triangle 3: XH Integer
  ssv v10[e4],20(a0) // Store Triangle 3: DxHDy Integer
  ssv v11[e4],22(a0) // Store Triangle 3: DxHDy Fraction

  ssv v0[e4],24(a0) // Store Triangle 3: XM Integer
  ssv v8[e4],28(a0) // Store Triangle 3: DxMDy Integer
  ssv v9[e4],30(a0) // Store Triangle 3: DxMDy Fraction


  la a0,RDPTriangle4
  ssv v12[e6],0(a0) // Store Triangle 4: Direction Left/Right Major

  ssv v5[e6],2(a0) // Store Triangle 4: YL Integer
  ssv v4[e6],4(a0) // Store Triangle 4: YM Integer
  ssv v3[e6],6(a0) // Store Triangle 4: YH Integer

  ssv v1[e6],8(a0)  // Store Triangle 4: XL Integer
  ssv v6[e6],12(a0) // Store Triangle 4: DxLDy Integer
  ssv v7[e6],14(a0) // Store Triangle 4: DxLDy Fraction

  ssv v0[e6],16(a0)  // Store Triangle 4: XH Integer
  ssv v10[e6],20(a0) // Store Triangle 4: DxHDy Integer
  ssv v11[e6],22(a0) // Store Triangle 4: DxHDy Fraction

  ssv v0[e6],24(a0) // Store Triangle 4: XM Integer
  ssv v8[e6],28(a0) // Store Triangle 4: DxMDy Integer
  ssv v9[e6],30(a0) // Store Triangle 4: DxMDy Fraction


  la a0,RDPTriangle5
  ssv v12[e8],0(a0) // Store Triangle 5: Direction Left/Right Major

  ssv v5[e8],2(a0) // Store Triangle 5: YL Integer
  ssv v4[e8],4(a0) // Store Triangle 5: YM Integer
  ssv v3[e8],6(a0) // Store Triangle 5: YH Integer

  ssv v1[e8],8(a0)  // Store Triangle 5: XL Integer
  ssv v6[e8],12(a0) // Store Triangle 5: DxLDy Integer
  ssv v7[e8],14(a0) // Store Triangle 5: DxLDy Fraction

  ssv v0[e8],16(a0)  // Store Triangle 5: XH Integer
  ssv v10[e8],20(a0) // Store Triangle 5: DxHDy Integer
  ssv v11[e8],22(a0) // Store Triangle 5: DxHDy Fraction

  ssv v0[e8],24(a0) // Store Triangle 5: XM Integer
  ssv v8[e8],28(a0) // Store Triangle 5: DxMDy Integer
  ssv v9[e8],30(a0) // Store Triangle 5: DxMDy Fraction


  la a0,RDPTriangle6
  ssv v12[e10],0(a0) // Store Triangle 6: Direction Left/Right Major

  ssv v5[e10],2(a0) // Store Triangle 6: YL Integer
  ssv v4[e10],4(a0) // Store Triangle 6: YM Integer
  ssv v3[e10],6(a0) // Store Triangle 6: YH Integer

  ssv v1[e10],8(a0)  // Store Triangle 6: XL Integer
  ssv v6[e10],12(a0) // Store Triangle 6: DxLDy Integer
  ssv v7[e10],14(a0) // Store Triangle 6: DxLDy Fraction

  ssv v0[e10],16(a0)  // Store Triangle 6: XH Integer
  ssv v10[e10],20(a0) // Store Triangle 6: DxHDy Integer
  ssv v11[e10],22(a0) // Store Triangle 6: DxHDy Fraction

  ssv v0[e10],24(a0) // Store Triangle 6: XM Integer
  ssv v8[e10],28(a0) // Store Triangle 6: DxMDy Integer
  ssv v9[e10],30(a0) // Store Triangle 6: DxMDy Fraction


  la a0,RDPTriangle7
  ssv v12[e12],0(a0) // Store Triangle 7: Direction Left/Right Major

  ssv v5[e12],2(a0) // Store Triangle 7: YL Integer
  ssv v4[e12],4(a0) // Store Triangle 7: YM Integer
  ssv v3[e12],6(a0) // Store Triangle 7: YH Integer

  ssv v1[e12],8(a0)  // Store Triangle 7: XL Integer
  ssv v6[e12],12(a0) // Store Triangle 7: DxLDy Integer
  ssv v7[e12],14(a0) // Store Triangle 7: DxLDy Fraction

  ssv v0[e12],16(a0)  // Store Triangle 7: XH Integer
  ssv v10[e12],20(a0) // Store Triangle 7: DxHDy Integer
  ssv v11[e12],22(a0) // Store Triangle 7: DxHDy Fraction

  ssv v0[e12],24(a0) // Store Triangle 7: XM Integer
  ssv v8[e12],28(a0) // Store Triangle 7: DxMDy Integer
  ssv v9[e12],30(a0) // Store Triangle 7: DxMDy Fraction


  la a0,RDPTriangle8
  ssv v12[e14],0(a0) // Store Triangle 8: Direction Left/Right Major

  ssv v5[e14],2(a0) // Store Triangle 8: YL Integer
  ssv v4[e14],4(a0) // Store Triangle 8: YM Integer
  ssv v3[e14],6(a0) // Store Triangle 8: YH Integer

  ssv v1[e14],8(a0)  // Store Triangle 8: XL Integer
  ssv v6[e14],12(a0) // Store Triangle 8: DxLDy Integer
  ssv v7[e14],14(a0) // Store Triangle 8: DxLDy Fraction

  ssv v0[e14],16(a0)  // Store Triangle 8: XH Integer
  ssv v10[e14],20(a0) // Store Triangle 8: DxHDy Integer
  ssv v11[e14],22(a0) // Store Triangle 8: DxHDy Fraction

  ssv v0[e14],24(a0) // Store Triangle 8: XM Integer
  ssv v8[e14],28(a0) // Store Triangle 8: DxMDy Integer
  ssv v9[e14],30(a0) // Store Triangle 8: DxMDy Fraction


  RSPDPC(RDPBuffer, RDPBufferEnd) // Run DPC Command Buffer: Start, End

  break // Set SP Status Halt, Broke & Check For Interrupt
align(8) // Align 64-Bit
base RSPCode+pc() // Set End Of RSP Code Object
RSPCodeEnd:


align(8) // Align 64-Bit
RSPData:
base $0000 // Set Base Of RSP Data Object To Zero

// Unsorted X's Of 8 Triangles (Column Order)
TriX1: // 1st X Point Of 8 Triangles
  dh 75, 150, 225, 300, 75, 150, 175, 300 // Tri1X1, Tri2X1, Tri3X1, Tri4X1, Tri5X1, Tri6X1, Tri7X1, Tri8X1
TriX2: // 2nd X Point Of 8 Triangles
  dh 25, 150, 175, 250, 25, 100, 225, 275 // Tri1X2, Tri2X2, Tri3X2, Tri4X2, Tri5X2, Tri6X2, Tri7X2, Tri8X2
TriX3: // 3rd X Point Of 8 Triangles
  dh 25, 100, 225, 250, 25, 125, 225, 250 // Tri1X3, Tri2X3, Tri3X3, Tri4X3, Tri5X3, Tri6X3, Tri7X3, Tri8X3

// Unsorted (Matching X's) Y's Of 8 Triangles (Column Order)
TriY1: // 1st Y Point Of 8 Triangles
  dh  50,  50, 100, 100, 175, 150, 175, 200 // Tri1Y1, Tri2Y1, Tri3Y1, Tri4Y1, Tri5Y1, Tri6Y1, Tri7Y1, Tri8Y1
TriY2: // 2nd Y Point Of 8 Triangles
  dh 100, 100, 100, 100, 150, 150, 150, 150 // Tri1Y2, Tri2Y2, Tri3Y2, Tri4Y2, Tri5Y2, Tri6Y2, Tri7Y2, Tri8Y2
TriY3: // 3rd Y Point Of 8 Triangles
  dh  50,  50,  50,  50, 200, 200, 200, 200 // Tri1Y3, Tri2Y3, Tri3Y3, Tri4Y3, Tri5Y3, Tri6Y3, Tri7Y3, Tri8Y3

// Left/Right Major Triangle Direction
DirLeftMajor: // Direction Left Major 8 Triangles
  dh $0800, $0800, $0800, $0800, $0800, $0800, $0800, $0800 // Tri1, Tri2, Tri3, Tri4, Tri5, Tri6, Tri7, Tri8
DirRightMajor: // Direction Right Major 8 Triangles
  dh $0880, $0880, $0880, $0880, $0880, $0880, $0880, $0880 // Tri1, Tri2, Tri3, Tri4, Tri5, Tri6, Tri7, Tri8

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
RDPBuffer:
arch n64.rdp
  Set_Scissor 0<<2,0<<2, 0,0, 320<<2,240<<2 // Set Scissor: XH 0.0,YH 0.0, Scissor Field Enable Off,Field Off, XL 320.0,YL 240.0
  Set_Other_Modes CYCLE_TYPE_FILL // Set Other Modes
  Set_Color_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,320-1, $00100000 // Set Color Image: FORMAT RGBA,SIZE 16B,WIDTH 320, DRAM ADDRESS $00100000
  Set_Fill_Color $00010001 // Set Fill Color: PACKED COLOR 16B R5G5B5A1 Pixels
  Fill_Rectangle 319<<2,239<<2, 0<<2,0<<2 // Fill Rectangle: XL 319.0,YL 239.0, XH 0.0,YH 0.0

  Set_Other_Modes SAMPLE_TYPE|BI_LERP_0|ALPHA_DITHER_SEL_NO_DITHER|B_M1A_0_2 // Set Other Modes
  Set_Combine_Mode $0,$00, 0,0, $6,$01, $0,$F, 1,0, 0,0,0, 7,7,7 // Set Combine Mode: SubA RGB0,MulRGB0, SubA Alpha0,MulAlpha0, SubA RGB1,MulRGB1, SubB RGB0,SubB RGB1, SubA Alpha1,MulAlpha1, AddRGB0,SubB Alpha0,AddAlpha0, AddRGB1,SubB Alpha1,AddAlpha1

  Sync_Pipe // Stall Pipeline, Until Preceeding Primitives Completely Finish
  Set_Blend_Color $FF0000FF // Set Blend Color: R 255,G 0,B 0,A 255 (Red)
RDPTriangle1:
  Fill_Triangle 0,0,0, 0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0 // Dir 1,Level 0,Tile 0, YL 100.0,YM 50.0,YH 50.0, XL 75.0,DxLDy -1.0, XH 25.0,DxHDy 0.0, XM 25.0,DxMDy 0.0

  Sync_Pipe // Stall Pipeline, Until Preceeding Primitives Completely Finish
  Set_Blend_Color $00FF00FF // Set Blend Color: R 0,G 255,B 0,A 255 (Green)
RDPTriangle2:
  Fill_Triangle 0,0,0, 0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0 // Dir 1,Level 0,Tile 0, YL 100.0,YM 50.0,YH 50.0, XL 150.0,DxLDy 0.0, XH 100.0,DxHDy 1.0, XM 100.0,DxMDy 0.0

  Sync_Pipe // Stall Pipeline, Until Preceeding Primitives Completely Finish
  Set_Blend_Color $0000FFFF // Set Blend Color: R 0,G 0,B 255,A 255 (Blue)
RDPTriangle3:
  Fill_Triangle 0,0,0, 0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0 // Dir 1,Level 0,Tile 0, YL 100.0,YM 100.0,YH 50.0, XL 225.0,DxLDy 0.0, XH 225.0,DxHDy -1.0, XM 225.0,DxMDy 0.0

  Sync_Pipe // Stall Pipeline, Until Preceeding Primitives Completely Finish
  Set_Blend_Color $FFFFFFFF // Set Blend Color: R 255,G 255,B 255,A 255 (White)
RDPTriangle4:
  Fill_Triangle 0,0,0, 0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0 // Dir 1,Level 0,Tile 0, YL 100.0,YM 100.0,YH 50.0, XL 300.0,DxLDy 0.0, XH 250.0,DxHDy 0.0, XM 250.0,DxMDy 1.0

  Sync_Pipe // Stall Pipeline, Until Preceeding Primitives Completely Finish
  Set_Blend_Color $FF0000FF // Set Blend Color: R 255,G 0,B 0,A 255 (Red)
RDPTriangle5:
  Fill_Triangle 0,0,0, 0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0 // Dir 1,Level 0,Tile 0, YL 200.0,YM 175.0,YH 150.0, XL 75.0,DxLDy -2.0, XH 25.0,DxHDy 0.0, XM 25.0,DxMDy 2.0

  Sync_Pipe // Stall Pipeline, Until Preceeding Primitives Completely Finish
  Set_Blend_Color $00FF00FF // Set Blend Color: R 0,G 255,B 0,A 255 (Green)
RDPTriangle6:
  Fill_Triangle 0,0,0, 0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0 // Dir 1,Level 0,Tile 0, YL 200.0,YM 150.0,YH 150.0, XL 150.0,DxLDy -0.5, XH 100.0,DxHDy 0.5, XM 100.0,DxMDy 0.0

  Sync_Pipe // Stall Pipeline, Until Preceeding Primitives Completely Finish
  Set_Blend_Color $0000FFFF // Set Blend Color: R 0,G 0,B 255,A 255 (Blue)
RDPTriangle7:
  Fill_Triangle 0,0,0, 0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0 // Dir 0,Level 0,Tile 0, YL 200.0,YM 175.0,YH 150.0, XL 175.0,DxLDy 2.0, XH 225.0,DxHDy 0.0, XM 225.0,DxMDy -2.0

  Sync_Pipe // Stall Pipeline, Until Preceeding Primitives Completely Finish
  Set_Blend_Color $FFFFFFFF // Set Blend Color: R 255,G 255,B 255,A 255 (White)
RDPTriangle8:
  Fill_Triangle 0,0,0, 0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0 // Dir 1,Level 0,Tile 0, YL 200.0,YM 200.0,YH 150.0, XL 300.0,DxLDy 0.0, XH 275.0,DxHDy -0.5, XM 275.0,DxMDy 0.5

  Sync_Full // Ensure Entire Scene Is Fully Drawn
RDPBufferEnd:

align(8) // Align 64-Bit
base RSPData+pc() // Set End Of RSP Data Object
RSPDataEnd: