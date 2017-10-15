// N64 'Bare Metal' RSP Transform 3D Rectangle Test by krom (Peter Lemon):
arch n64.cpu
endian msb
output "RSPTrans3DRectangle.N64", create
fill 1052672 // Set ROM Size

origin $00000000
base $80000000 // Entry Point Of Code
include "LIB/N64.INC" // Include N64 Definitions
include "LIB/N64_HEADER.ASM" // Include 64 Byte Header & Vector Table
insert "LIB/N64_BOOTCODE.BIN" // Include 4032 Byte Boot Code

Start:
  include "LIB/N64_GFX.INC" // Include Graphics Macros
  include "LIB/N64_RSP.INC" // Include RSP Macros
  include "LIB/N64_INPUT.INC" // Include Input Macros
  N64_INIT() // Run N64 Initialisation Routine

  ScreenNTSC(320, 240, BPP16, $A0100000) // Screen NTSC: 320x240, 16BPP, DRAM Origin $A0100000

  InitController(PIF1) // Initialize Controller

  // Switch to RSP DMEM for RDP Commands
  lui a0,DPC_BASE // A0 = Reality Display Processer Control Interface Base Register ($A4100000)
  lli t0,SET_XBS // T0 = DP Status To Use RSP DMEM (Set XBUS DMEM DMA)
  sw t0,DPC_STATUS(a0) // Store DP Status To DP Status Register ($A410000C)

Loop:
  WaitScanline($1E0) // Wait For Scanline To Reach Vertical Start
  WaitScanline($1E2) // Wait For Scanline To Reach Vertical Blank

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


  // Flush Data Cache: Index Writeback Invalidate
  la a1,$80000000    // A1 = Cache Start
  la a2,$80002000-16 // A2 = Cache End
  LoopCache:
    cache $0|1,0(a1) // Data Cache: Index Writeback Invalidate
    bne a1,a2,LoopCache
    addiu a1,16 // Address += Data Line Size (Delay Slot)

  ReadController(PIF2) // T0 = Controller Buttons, T1 = Analog X, T2 = Analog Y

  la a0,RSPData+MatrixRow01XYZT

Up: // Translate Y
  andi t3,t0,JOY_UP // Test JOY UP
  beqz t3,Down
  nop // Delay Slot
  lh t4,14(a0)
  subi t4,64
  sh t4,14(a0)

Down: // Translate Y
  andi t3,t0,JOY_DOWN // Test JOY DOWN
  beqz t3,Left
  nop // Delay Slot
  lh t4,14(a0)
  addi t4,64
  sh t4,14(a0)

Left: // Translate X
  andi t3,t0,JOY_LEFT // Test JOY LEFT
  beqz t3,Right
  nop // Delay Slot
  lh t4,6(a0)
  subi t4,64
  sh t4,6(a0)

Right: // Translate X
  andi t3,t0,JOY_RIGHT // Test JOY RIGHT
  beqz t3,A_Button
  nop // Delay Slot
  lh t4,6(a0)
  addi t4,64
  sh t4,6(a0)

A_Button: // Translate Z
  andi t3,t0,JOY_A // Test JOY A
  beqz t3,B_Button
  nop // Delay Slot
  lh t4,22(a0)
  subi t4,64
  sh t4,22(a0)

B_Button: // Translate Z
  andi t3,t0,JOY_B // Test JOY B
  beqz t3,ControlEnd
  nop // Delay Slot
  lh t4,22(a0)
  addi t4,64
  sh t4,22(a0)

ControlEnd:

  j Loop
  nop // Delay Slot

align(8) // Align 64-Bit
RSPCode:
arch n64.rsp
base $0000 // Set Base Of RSP Code Object To Zero

RSPStart:
// Load Point X,Y,Z
  lqv v0[e0],PointX(r0) // V0 = Point X ($000)
  lqv v1[e0],PointY(r0) // V1 = Point Y ($010)
  lqv v2[e0],PointZ(r0) // V2 = Point Z ($020)

// Load Camera
  lqv v3[e0],HALF_SCREEN_XY_FOV(r0) // V3 = Screen X / 2, Screen Y / 2, FOV ($030)

// Load Matrix
  lqv v4[e0],MatrixRow01XYZT(r0) // V4 = Row 0,1 XYZT ($040)
  lqv v5[e0],MatrixRow23XYZT(r0) // V5 = Row 2,3 XYZT ($050)

// Calculate X,Y,Z 3D
  vmudh v6,v0,v4[e8] // X = (Matrix[0] * X) + (Matrix[1] * Y) + (Matrix[2] * Z) + Matrix[3]
  vmadh v6,v1,v4[e9]
  vmadh v6,v2,v4[e10]
  vadd v6,v4[e11]

  vmudh v7,v0,v4[e12] // Y = (Matrix[4] * X) + (Matrix[5] * Y) + (Matrix[6] * Z) + Matrix[7]
  vmadh v7,v1,v4[e13]
  vmadh v7,v2,v4[e14]
  vadd v7,v4[e15]

  vmudh v8,v0,v5[e8] // Z = (Matrix[8] * X) + (Matrix[9] * Y) + (Matrix[10] * Z) + Matrix[11]
  vmadh v8,v1,v5[e9]
  vmadh v8,v2,v5[e10]
  vadd v8,v5[e11]

// Store Rectangle Z Coords To DMEM
  sqv v8[e0],PointZ(r0) // DMEM $020 = Point Z

// Calculate X,Y 2D
  vmulf v8,v3[e10] // V8 = Z / FOV

  vrcp v3[e3],v8[e0] // Result Fraction (Zero), Source Integer (Z0)
  vrcph v9[e0],v3[e3] // Result Integer, Source Fraction (Zero)

  vrcp v3[e3],v8[e1] // Result Fraction (Zero), Source Integer (Z1)
  vrcph v9[e1],v3[e3] // Result Integer, Source Fraction (Zero)

  vrcp v3[e3],v8[e2] // Result Fraction (Zero), Source Integer (Z2)
  vrcph v9[e2],v3[e3] // Result Integer, Source Fraction (Zero)

  vrcp v3[e3],v8[e3] // Result Fraction (Zero), Source Integer (Z3)
  vrcph v9[e3],v3[e3] // Result Integer, Source Fraction (Zero)

  vrcp v3[e3],v8[e4] // Result Fraction (Zero), Source Integer (Z4)
  vrcph v9[e4],v3[e3] // Result Integer, Source Fraction (Zero)

  vrcp v3[e3],v8[e5] // Result Fraction (Zero), Source Integer (Z5)
  vrcph v9[e5],v3[e3] // Result Integer, Source Fraction (Zero)

  vrcp v3[e3],v8[e6] // Result Fraction (Zero), Source Integer (Z6)
  vrcph v9[e6],v3[e3] // Result Integer, Source Fraction (Zero)

  vrcp v3[e3],v8[e7] // Result Fraction (Zero), Source Integer (Z7)
  vrcph v9[e7],v3[e3] // Result Integer, Source Fraction (Zero)

  vmulf v6,v9[e0] // X = X / Z + (ScreenX / 2)
  vadd v6,v3[e8]

  vmulf v7,v9[e0] // Y = Y / Z + (ScreenY / 2)
  vadd v7,v3[e9]

// Store Rectangle X,Y Coords To DMEM
  sqv v6[e0],PointX(r0) // DMEM $000 = Point X
  sqv v7[e0],PointY(r0) // DMEM $010 = Point Y

  lli a0,PointX // A0 = X Vector DMEM Offset
  lli a1,RectangleZ // A1 = RDP Rectangle XY DMEM Offset
  lli t4,7 // T4 = Point Count

LoopPoint:
  lhu t0,PointX(a0) // T0 = Point X
  sll t0,2 // Convert To Rectangle Fixed Point 10.2 Format
  lhu t1,PointY(a0) // T1 = Point Y
  sll t1,2 // Convert To Rectangle Fixed Point 10.2 Format
  lhu t2,PointZ(a0) // T2 = Point Z

  sh t2,$0004(a1) // Store Primitive Z Depth

  sll t2,t0,12
  add t2,t1 // T2 = XL,YL
  lui t3,$3600
  add t2,t3 // T2 = Rectangle 1st Word
  sw t2,$0008(a1) // Store 1st Word
  
  subi t0,2<<2 // T0 = XH
  subi t1,2<<2 // T0 = YH
  sll t2,t0,12
  add t2,t1 // T2 = XH,YH (Rectangle 2nd Word)
  sw t2,$000C(a1) // Store 2nd Word

  addi a0,2 // X Vector DMEM Offset += 2
  addi a1,24 // RDP Rectangle0XY DMEM Offset += 24
  bnez t4,LoopPoint // IF (Point Count != 0) LoopPoint
  subi t4,1 // Decrement Point Count (Delay Slot)


  RSPDPC(RDPBuffer, RDPBufferEnd) // Run DPC Command Buffer: Start, End

  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
align(8) // Align 64-Bit
base RSPCode+pc() // Set End Of RSP Code Object
RSPCodeEnd:

align(8) // Align 64-Bit
RSPData:
base $0000 // Set Base Of RSP Data Object To Zero

PointX:
  dh -1000,  1000, -1000,  1000, -1000, 1000, -1000,  1000 // 8 * Point X (S15) (Signed Integer)
PointY:
  dh  1000,  1000, -1000, -1000,  1000, 1000, -1000, -1000 // 8 * Point Y (S15) (Signed Integer)
PointZ:
  dh -1000, -1000, -1000, -1000,  1000, 1000,  1000,  1000 // 8 * Point Z (S15) (Signed Integer)

HALF_SCREEN_XY_FOV:
  dh 160, 120, 400, 0, 0, 0, 0, 0 // Screen X / 2 (S15) (Signed Integer), Screen Y / 2 (S15) (Signed Integer), FOV (Signed Fraction), Zero Const

MatrixRow01XYZT:
  dh 1,0,0,0 // Row 0 X,Y,Z,T (S15) (Signed Integer) (X)
  dh 0,1,0,0 // Row 1 X,Y,Z,T (S15) (Signed Integer) (Y)
MatrixRow23XYZT:
  dh 0,0,1,4000 // Row 2 X,Y,Z,T (S15) (Signed Integer) (Z)
  dh 0,0,0,1 // Row 3 X,Y,Z,T (S15) (Signed Integer) (T)

align(8) // Align 64-Bit
RDPBuffer:
arch n64.rdp
  Set_Scissor 0<<2,0<<2, 0,0, 320<<2,240<<2 // Set Scissor: XH 0.0,YH 0.0, Scissor Field Enable Off,Field Off, XL 320.0,YL 240.0
  Set_Other_Modes CYCLE_TYPE_FILL // Set Other Modes
  Set_Z_Image $00200000 // Set Z Image: DRAM ADDRESS $00200000
  Set_Color_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,320-1, $00200000 // Set Color Image: FORMAT RGBA,SIZE 16B,WIDTH 320, DRAM ADDRESS $00200000
  Set_Fill_Color $FFFFFFFF // Set Fill Color: PACKED COLOR 16B R5G5B5A1 Pixels (Clear ZBuffer)
  Fill_Rectangle 319<<2,239<<2, 0<<2,0<<2 // Fill Rectangle: XL 319.0,YL 239.0, XH 0.0,YH 0.0

  Sync_Pipe // Stall Pipeline, Until Preceeding Primitives Completely Finish
  Set_Color_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,320-1, $00100000 // Set Color Image: FORMAT RGBA,SIZE 16B,WIDTH 320, DRAM ADDRESS $00100000
  Set_Fill_Color $00010001 // Set Fill Color: PACKED COLOR 16B R5G5B5A1 Pixels
  Fill_Rectangle 319<<2,239<<2, 0<<2,0<<2 // Fill Rectangle: XL 319.0,YL 239.0, XH 0.0,YH 0.0

  Set_Other_Modes SAMPLE_TYPE|BI_LERP_0|ALPHA_DITHER_SEL_NO_DITHER|B_M1A_0_2|IMAGE_READ_EN|Z_SOURCE_SEL|Z_COMPARE_EN|Z_UPDATE_EN // Set Other Modes
  Set_Combine_Mode $0,$00, 0,0, $1,$01, $0,$F, 1,0, 0,0,0, 7,7,7 // Set Combine Mode: SubA RGB0,MulRGB0, SubA Alpha0,MulAlpha0, SubA RGB1,MulRGB1, SubB RGB0,SubB RGB1, SubA Alpha1,MulAlpha1, AddRGB0,SubB Alpha0,AddAlpha0, AddRGB1,SubB Alpha1,AddAlpha1

  Set_Blend_Color $FF0000FF // Set Blend Color: R 255,G 0,B 0,A 255
RectangleZ:
  Set_Prim_Depth 0,0 // Set Primitive Depth: PRIMITIVE Z,PRIMITIVE DELTA Z
RectangleXY:
  Fill_Rectangle 0,0, 0,0 // Fill Rectangle: XL,YL, XH,YH

  Set_Blend_Color $00FF00FF // Set Blend Color: R 0,G 255,B 0,A 255
  Set_Prim_Depth 0,0 // Set Primitive Depth: PRIMITIVE Z,PRIMITIVE DELTA Z
  Fill_Rectangle 0,0, 0,0 // Fill Rectangle: XL,YL, XH,YH

  Set_Blend_Color $0000FFFF // Set Blend Color: R 0,G 0,B 255,A 255
  Set_Prim_Depth 0,0 // Set Primitive Depth: PRIMITIVE Z,PRIMITIVE DELTA Z
  Fill_Rectangle 0,0, 0,0 // Fill Rectangle: XL,YL, XH,YH

  Set_Blend_Color $FFFFFFFF // Set Blend Color: R 255,G 255,B 255,A 255
  Set_Prim_Depth 0,0 // Set Primitive Depth: PRIMITIVE Z,PRIMITIVE DELTA Z
  Fill_Rectangle 0,0, 0,0 // Fill Rectangle: XL,YL, XH,YH

  Set_Blend_Color $800000FF // Set Blend Color: R 128,G 0,B 0,A 255
  Set_Prim_Depth 0,0 // Set Primitive Depth: PRIMITIVE Z,PRIMITIVE DELTA Z
  Fill_Rectangle 0,0, 0,0 // Fill Rectangle: XL,YL, XH,YH

  Set_Blend_Color $008000FF // Set Blend Color: R 0,G 128,B 0,A 255
  Set_Prim_Depth 0,0 // Set Primitive Depth: PRIMITIVE Z,PRIMITIVE DELTA Z
  Fill_Rectangle 0,0, 0,0 // Fill Rectangle: XL,YL, XH,YH

  Set_Blend_Color $000080FF // Set Blend Color: R 0,G 0,B 128,A 255
  Set_Prim_Depth 0,0 // Set Primitive Depth: PRIMITIVE Z,PRIMITIVE DELTA Z
  Fill_Rectangle 0,0, 0,0 // Fill Rectangle: XL,YL, XH,YH

  Set_Blend_Color $808080FF // Set Blend Color: R 128,G 128,B 128,A 255
  Set_Prim_Depth 0,0 // Set Primitive Depth: PRIMITIVE Z,PRIMITIVE DELTA Z
  Fill_Rectangle 0,0, 0,0 // Fill Rectangle: XL,YL, XH,YH

  Sync_Full // Ensure Entire Scene Is Fully Drawn
RDPBufferEnd:

align(8) // Align 64-Bit
base RSPData+pc() // Set End Of RSP Data Object
RSPDataEnd:

PIF1:
  dw $FF010401,0
  dw 0,0
  dw 0,0
  dw 0,0
  dw $FE000000,0
  dw 0,0
  dw 0,0
  dw 0,1

PIF2:
  fill 64 // Generate 64 Bytes Containing $00