macro LoadXYZ() { // Load X,Y,Z
  lwc1 f15,0(a0) // F15 = X
  addi a0,4
  lwc1 f16,0(a0) // F16 = Y
  addi a0,4
  lwc1 f17,0(a0) // F17 = Z
  addi a0,4
  Calc3D()
}

macro Calc3D() { // Calculate X,Y,Z 3D
  mul.s f18,f3,f15 // XCalc = (Matrix3D[0] * X) + (Matrix3D[1] * Y) + (Matrix3D[2] * Z) + Matrix3D[3]
  mul.s f21,f4,f16
  add.s f18,f21
  mul.s f21,f5,f17
  add.s f18,f21
  add.s f18,f6
  mul.s f19,f7,f15 // YCalc = (Matrix3D[4] * X) + (Matrix3D[5] * Y) + (Matrix3D[6] * Z) + Matrix3D[7]
  mul.s f21,f8,f16
  add.s f19,f21
  mul.s f21,f9,f17
  add.s f19,f21
  add.s f19,f10
  mul.s f20,f11,f15 // ZCalc = (Matrix3D[8] * X) + (Matrix3D[9] * Y) + (Matrix3D[10] * Z) + Matrix3D[11]
  mul.s f21,f12,f16
  add.s f20,f21
  mul.s f21,f13,f17
  add.s f20,f21
  add.s f20,f14
  Calc2D()
}

macro Calc2D() { // Calculate X,Y 2D
  la t0,HALF_SCREEN_X // T0 = HALF SCREEN X Data Offset
  lwc1 f15,0(t0) // F15 = HALF SCREEN X
  lwc1 f16,4(t0) // F16 = HALF SCREEN Y

  c.le.s f20,f0 // IF (Z <= 0.0) Do Not Divide By Zero
  bc1t {#}ZeroZ
  nop // Delay Slot

  lwc1 f17,8(t0) // F17 = FOV
  div.s f21,f20,f17 // F21 = Z / FOV

  div.s f18,f21 // X = X / Z + (ScreenX / 2)
  add.s f18,f15

  div.s f19,f21 // Y = (ScreenY / 2) - Y / Z 
  sub.s f19,f16,f19

  // Convert To Int then Back To Float (Round Numbers)
  round.w.s f18
  round.w.s f19
  cvt.s.w f18
  cvt.s.w f19

  swc1 f18,0(a3)
  addi a3,4
  swc1 f19,0(a3)
  addi a3,4

  b {#}Calc2DEnd
  nop // Delay Slot

  {#}ZeroZ:
  swc1 f15,0(a3)
  addi a3,4
  swc1 f16,0(a3)
  addi a3,4
  {#}Calc2DEnd:
}

macro PolyWinding() { // Test Polygon Winding Direction
  lwc1 f15,0(a3)  // F15 = Triangle X0
  lwc1 f16,4(a3)  // F16 = Triangle Y0 (YL)
  lwc1 f17,8(a3)  // F17 = Triangle X1 (XL)
  lwc1 f18,12(a3) // F18 = Triangle Y1 (YM)
  lwc1 f19,16(a3) // F19 = Triangle X2 (XH/XM)
  lwc1 f20,20(a3) // F20 = Triangle Y2 (YH)

  mul.s f21,f15,f18 // F21 = X0*Y1
  mul.s f22,f17,f16 // F22 = X1*Y0
  sub.s f21,f22 // F21 = X0*Y1 - X1*Y0
  
  mul.s f22,f17,f20 // F22 = X1*Y2
  mul.s f23,f19,f18 // F23 = X2*Y1
  sub.s f22,f23 // F22 = X1*Y2 - X2*Y1
  add.s f21,f22 // F21 = (X0*Y1 - X1*Y0) + (X1*Y2 - X2*Y1)

  mul.s f22,f19,f16 // F22 = X2*Y0
  mul.s f23,f15,f20 // F23 = X0*Y2
  sub.s f22,f23 // F22 = X2*Y0 - X0*Y2
  add.s f21,f22 // F21 = (X0*Y1 - X1*Y0) + (X1*Y2 - X2*Y1) + (X2*Y0 - X0*Y2)
}

macro FillTriHead() { // Fill Triangle Header
  // Store RDP Triangle Buffer
  lui t0,$2700 // T0 = Sync Pipe RDP Command
  sw t0,0(a2)

  lui t0,$3900 // T0 = Set Blend Color RDP Command
  sw t0,8(a2)  // Store RDP Command (WORD 0 HI) (Triangle Color)
  lw t0,0(a0)  // T0 = Triangle Color
  sw t0,12(a2) // Store RDP Command (WORD 0 LO) (Triangle Color)
  addi a2,16 // A2 += 16
}

macro LeftMajorTri() { // Left Major Triangle Calculation
  // PASS1 Sort Coordinate 0 & 1
  lwc1 f15,4(a3)  // F15 = Triangle Y0
  lwc1 f16,12(a3) // F16 = Triangle Y1
  c.le.s f15,f16  // IF (Y0 <= Y1) Swap Triangle Coordinates 0 & 1
  bc1f {#}PASS101 // ELSE No Swap
  nop // Delay Slot
  lwc1 f17,0(a3)  // F17 = X0
  lwc1 f18,8(a3)  // F18 = X1
  swc1 f18,0(a3)  // X0 = X1
  swc1 f16,4(a3)  // Y0 = Y1
  swc1 f17,8(a3)  // X1 = X0
  swc1 f15,12(a3) // Y1 = Y0
  {#}PASS101:

  // PASS1 Sort Coordinate 1 & 2
  lwc1 f15,12(a3) // F15 = Triangle Y1
  lwc1 f16,20(a3) // F16 = Triangle Y2
  c.le.s f15,f16  // IF (Y1 <= Y2) Swap Triangle Coordinates 1 & 2
  bc1f {#}PASS112 // ELSE No Swap
  nop // Delay Slot
  lwc1 f17,8(a3)  // F17 = X1
  lwc1 f18,16(a3) // F18 = X2
  swc1 f18,8(a3)  // X1 = X2
  swc1 f16,12(a3) // Y1 = Y2
  swc1 f17,16(a3) // X2 = X1
  swc1 f15,20(a3) // Y2 = Y1
  {#}PASS112:

  // PASS1 Sort Coordinate 2 & 0
  lwc1 f15,4(a3)  // F15 = Triangle Y0
  lwc1 f16,20(a3) // F16 = Triangle Y2
  c.le.s f15,f16  // IF (Y0 <= Y2) Swap Triangle Coordinates 0 & 2
  bc1f {#}PASS120 // ELSE No Swap
  nop // Delay Slot
  lwc1 f17,0(a3)  // F17 = X0
  lwc1 f18,16(a3) // F18 = X2
  swc1 f18,0(a3)  // X0 = X2
  swc1 f16,4(a3)  // Y0 = Y2
  swc1 f17,16(a3) // X2 = X0
  swc1 f15,20(a3) // Y2 = Y0
  {#}PASS120:

  // PASS1 Sort Coordinate 0 & 1
  lwc1 f15,4(a3)  // F15 = Triangle Y0
  lwc1 f16,12(a3) // F16 = Triangle Y1
  c.le.s f15,f16  // IF (Y0 <= Y1) Swap Triangle Coordinates 0 & 1
  bc1f {#}PASS101B // ELSE No Swap
  nop // Delay Slot
  lwc1 f17,0(a3)  // F17 = X0
  lwc1 f18,8(a3)  // F18 = X1
  swc1 f18,0(a3)  // X0 = X1
  swc1 f16,4(a3)  // Y0 = Y1
  swc1 f17,8(a3)  // X1 = X0
  swc1 f15,12(a3) // Y1 = Y0
  {#}PASS101B:

  // PASS2 Sort Coordinate 0 & 1
  lwc1 f15,4(a3)  // F15 = Triangle Y0
  lwc1 f16,12(a3) // F16 = Triangle Y1
  c.eq.s f15,f16  // IF (Y0 == Y1) Swap Triangle Coordinates 0 & 1
  bc1f {#}PASS201 // ELSE No Swap
  nop // Delay Slot
  lwc1 f17,0(a3)  // F17 = Triangle X0
  lwc1 f18,8(a3)  // F18 = Triangle X1
  c.le.s f17,f18  // IF (X0 <= X1) Swap Triangle Coordinates 0 & 1
  bc1f {#}PASS201 // ELSE No Swap
  nop // Delay Slot
  swc1 f18,0(a3)  // X0 = X1
  swc1 f16,4(a3)  // Y0 = Y1
  swc1 f17,8(a3)  // X1 = X0
  swc1 f15,12(a3) // Y1 = Y0
  {#}PASS201:

  // PASS2 Sort Coordinate 1 & 2
  lwc1 f15,12(a3) // F15 = Triangle Y1
  lwc1 f16,20(a3) // F16 = Triangle Y2
  c.eq.s f15,f16  // IF (Y1 == Y2) Swap Triangle Coordinates 1 & 2
  bc1f {#}PASS212 // ELSE No Swap
  nop // Delay Slot
  lwc1 f17,8(a3)  // F17 = X1
  lwc1 f18,16(a3) // F18 = X2
  c.le.s f18,f17  // IF (X1 >= X2) Swap Triangle Coordinates 1 & 2
  bc1f {#}PASS212 // ELSE No Swap
  nop // Delay Slot
  swc1 f18,8(a3)  // X1 = X2
  swc1 f16,12(a3) // Y1 = Y2
  swc1 f17,16(a3) // X2 = X1
  swc1 f15,20(a3) // Y2 = Y1
  {#}PASS212:


  // Store RDP Triangle Buffer
  PolyWinding() // Run Polygon Winding Test
  c.le.s f21,f0 // IF (Triangle Winding == Clockwise) DIR = 0 (Left Major Triangle)
  bc1f {#}DIR // ELSE DIR = 1 (Right Major Triangle)
  lui t3,$0800 // T3 = DIR 0
  lui t3,$0880 // T3 = DIR 1
  {#}DIR:


  mul.s f21,f16,f1 // Convert To S.11.2
  cvt.w.s f21 // F21 = YL
  mfc1 t4,f21 // T4 = YL
  andi t4,$3FFF // T4 &= S.11.2
  or t3,t4
  sw t3,0(a2) // Store RDP Command (WORD 0 HI)

  mul.s f21,f18,f1 // Convert To S.11.2
  cvt.w.s f21 // F21 = YM
  mfc1 t3,f21 // T3 = YM
  andi t3,$3FFF // T3 &= S.11.2
  dsll t3,16 // T3 = YM

  mul.s f21,f20,f1 // Convert To S.11.2
  cvt.w.s f21 // F21 = YH
  mfc1 t4,f21 // T4 = YH
  andi t4,$3FFF // T4 &= S.11.2
  or t3,t4
  sw t3,4(a2) // Store RDP Command (WORD 0 LO)


  mul.s f21,f17,f2 // Convert To S.15.16
  cvt.w.s f21 // F21 = XL
  mfc1 t3,f21 // T3 = XL
  sw t3,8(a2) // Store RDP Command (WORD 1 HI)

  sub.s f22,f18,f16
  c.eq.s f22,f0 // IF ((Y1 - Y0) == 0) DxLDy = 0.0 
  bc1t {#}DXLDY // ELSE DxLDy = (X1 - X0) / (Y1 - Y0)
  andi t3,0 // T3 = DxLDy 0.0

  sub.s f21,f17,f15
  div.s f21,f22 // F21 = DxLDy
  mul.s f21,f2  // Convert To S.15.16
  cvt.w.s f21 // F21 = DxLDy
  mfc1 t3,f21 // T3 = DxLDy
  {#}DXLDY:
  sw t3,12(a2) // Store RDP Command (WORD 1 LO)


  mul.s f21,f19,f2 // Convert To S.15.16
  cvt.w.s f21 // F21 = XH
  mfc1 t3,f21 // T3 = XH
  sw t3,16(a2) // Store RDP Command (WORD 2 HI) 

  sub.s f22,f20,f16
  c.eq.s f22,f0 // IF ((Y2 - Y0) == 0) DxHDy = 0.0 
  bc1t {#}DXHDY // ELSE DxHDy = (X2 - X0) / (Y2 - Y0)
  andi t4,0 // T4 = DxHDy 0.0

  sub.s f21,f19,f15
  div.s f21,f22 // F21 = DxHDy
  mul.s f21,f2  // Convert To S.15.16
  cvt.w.s f21 // F21 = DxHDy
  mfc1 t4,f21 // T4 = DxHDy
  {#}DXHDY:
  sw t4,20(a2) // Store RDP Command (WORD 2 LO)


  sw t3,24(a2) // Store RDP Command (WORD 3 HI) T3 = XM (Uses Previous XH)
  sub.s f22,f20,f18
  c.eq.s f22,f0 // IF ((Y2 - Y1) == 0) DxMDy = 0.0 
  bc1t {#}DXMDY // ELSE DxMDy = (X2 - X1) / (Y2 - Y1)
  andi t3,0 // T3 = DxMDy 0.0

  sub.s f21,f19,f17
  div.s f21,f22 // F21 = DxMDy
  mul.s f21,f2  // Convert To S.15.16
  cvt.w.s f21 // F21 = DxMDy
  mfc1 t3,f21 // T3 = DxMDy
  {#}DXMDY:
  sw t3,28(a2) // Store RDP Command (WORD 3 LO)
  addi a2,32 // A2 += 32
}

macro RightMajorTri() { // Right Major Triangle Calculation
  // PASS1 Sort Coordinate 0 & 1
  lwc1 f15,4(a3)  // F15 = Triangle Y0
  lwc1 f16,12(a3) // F16 = Triangle Y1
  c.le.s f15,f16  // IF (Y0 <= Y1) Swap Triangle Coordinates 0 & 1
  bc1f {#}PASS101 // ELSE No Swap
  nop // Delay Slot
  lwc1 f17,0(a3)  // F17 = X0
  lwc1 f18,8(a3)  // F18 = X1
  swc1 f18,0(a3)  // X0 = X1
  swc1 f16,4(a3)  // Y0 = Y1
  swc1 f17,8(a3)  // X1 = X0
  swc1 f15,12(a3) // Y1 = Y0
  {#}PASS101:

  // PASS1 Sort Coordinate 1 & 2
  lwc1 f15,12(a3) // F15 = Triangle Y1
  lwc1 f16,20(a3) // F16 = Triangle Y2
  c.le.s f15,f16  // IF (Y1 <= Y2) Swap Triangle Coordinates 1 & 2
  bc1f {#}PASS112 // ELSE No Swap
  nop // Delay Slot
  lwc1 f17,8(a3)  // F17 = X1
  lwc1 f18,16(a3) // F18 = X2
  swc1 f18,8(a3)  // X1 = X2
  swc1 f16,12(a3) // Y1 = Y2
  swc1 f17,16(a3) // X2 = X1
  swc1 f15,20(a3) // Y2 = Y1
  {#}PASS112:

  // PASS1 Sort Coordinate 2 & 0
  lwc1 f15,4(a3)  // F15 = Triangle Y0
  lwc1 f16,20(a3) // F16 = Triangle Y2
  c.le.s f15,f16  // IF (Y0 <= Y2) Swap Triangle Coordinates 0 & 2
  bc1f {#}PASS120 // ELSE No Swap
  nop // Delay Slot
  lwc1 f17,0(a3)  // F17 = X0
  lwc1 f18,16(a3) // F18 = X2
  swc1 f18,0(a3)  // X0 = X2
  swc1 f16,4(a3)  // Y0 = Y2
  swc1 f17,16(a3) // X2 = X0
  swc1 f15,20(a3) // Y2 = Y0
  {#}PASS120:

  // PASS1 Sort Coordinate 0 & 1
  lwc1 f15,4(a3)  // F15 = Triangle Y0
  lwc1 f16,12(a3) // F16 = Triangle Y1
  c.le.s f15,f16  // IF (Y0 <= Y1) Swap Triangle Coordinates 0 & 1
  bc1f {#}PASS101B // ELSE No Swap
  nop // Delay Slot
  lwc1 f17,0(a3)  // F17 = X0
  lwc1 f18,8(a3)  // F18 = X1
  swc1 f18,0(a3)  // X0 = X1
  swc1 f16,4(a3)  // Y0 = Y1
  swc1 f17,8(a3)  // X1 = X0
  swc1 f15,12(a3) // Y1 = Y0
  {#}PASS101B:

  // PASS2 Sort Coordinate 0 & 1
  lwc1 f15,4(a3)  // F15 = Triangle Y0
  lwc1 f16,12(a3) // F16 = Triangle Y1
  c.eq.s f15,f16  // IF (Y0 == Y1) Swap Triangle Coordinates 0 & 1
  bc1f {#}PASS201 // ELSE No Swap
  nop // Delay Slot
  lwc1 f17,0(a3)  // F17 = Triangle X0
  lwc1 f18,8(a3)  // F18 = Triangle X1
  c.le.s f18,f17  // IF (X0 >= X1) Swap Triangle Coordinates 0 & 1
  bc1f {#}PASS201 // ELSE No Swap
  nop // Delay Slot
  swc1 f18,0(a3)  // X0 = X1
  swc1 f16,4(a3)  // Y0 = Y1
  swc1 f17,8(a3)  // X1 = X0
  swc1 f15,12(a3) // Y1 = Y0
  {#}PASS201:

  // PASS2 Sort Coordinate 1 & 2
  lwc1 f15,12(a3) // F15 = Triangle Y1
  lwc1 f16,20(a3) // F16 = Triangle Y2
  c.eq.s f15,f16  // IF (Y1 == Y2) Swap Triangle Coordinates 1 & 2
  bc1f {#}PASS212 // ELSE No Swap
  nop // Delay Slot
  lwc1 f17,8(a3)  // F17 = X1
  lwc1 f18,16(a3) // F18 = X2
  c.le.s f17,f18  // IF (X1 <= X2) Swap Triangle Coordinates 1 & 2
  bc1f {#}PASS212 // ELSE No Swap
  nop // Delay Slot
  swc1 f18,8(a3)  // X1 = X2
  swc1 f16,12(a3) // Y1 = Y2
  swc1 f17,16(a3) // X2 = X1
  swc1 f15,20(a3) // Y2 = Y1
  {#}PASS212:


  // Store RDP Triangle Buffer
  PolyWinding() // Run Polygon Winding Test
  c.le.s f21,f0 // IF (Triangle Winding == Clockwise) DIR = 0 (Left Major Triangle)
  bc1f {#}DIR // ELSE DIR = 1 (Right Major Triangle)
  lui t3,$0800 // T3 = DIR 0
  lui t3,$0880 // T3 = DIR 1
  {#}DIR:


  mul.s f21,f16,f1 // Convert To S.11.2
  cvt.w.s f21 // F21 = YL
  mfc1 t4,f21 // T4 = YL
  andi t4,$3FFF // T4 &= S.11.2
  or t3,t4
  sw t3,0(a2) // Store RDP Command (WORD 0 HI)

  mul.s f21,f18,f1 // Convert To S.11.2
  cvt.w.s f21 // F21 = YM
  mfc1 t3,f21 // T3 = YM
  andi t3,$3FFF // T3 &= S.11.2
  dsll t3,16 // T3 = YM

  mul.s f21,f20,f1 // Convert To S.11.2
  cvt.w.s f21 // F21 = YH
  mfc1 t4,f21 // T4 = YH
  andi t4,$3FFF // T4 &= S.11.2
  or t3,t4
  sw t3,4(a2) // Store RDP Command (WORD 0 LO)


  mul.s f21,f17,f2 // Convert To S.15.16
  cvt.w.s f21 // F21 = XL
  mfc1 t3,f21 // T3 = XL
  sw t3,8(a2) // Store RDP Command (WORD 1 HI)

  sub.s f22,f16,f18
  c.eq.s f22,f0 // IF ((Y0 - Y1) == 0) DxLDy = 0.0 
  bc1t {#}DXLDY // ELSE DxLDy = (X0 - X1) / (Y0 - Y1)
  andi t3,0 // T3 = DxLDy 0.0

  sub.s f21,f15,f17
  div.s f21,f22 // F21 = DxLDy
  mul.s f21,f2  // Convert To S.15.16
  cvt.w.s f21 // F21 = DxLDy
  mfc1 t3,f21 // T3 = DxLDy
  {#}DXLDY:
  sw t3,12(a2) // Store RDP Command (WORD 1 LO)


  mul.s f21,f19,f2 // Convert To S.15.16
  cvt.w.s f21 // F21 = XH
  mfc1 t3,f21 // T3 = XH
  sw t3,16(a2) // Store RDP Command (WORD 2 HI) 

  sub.s f22,f16,f20
  c.eq.s f22,f0 // IF ((Y0 - Y2) == 0) DxHDy = 0.0 
  bc1t {#}DXHDY // ELSE DxHDy = (X0 - X2) / (Y0 - Y2)
  andi t4,0 // T4 = DxHDy 0.0

  sub.s f21,f15,f19
  div.s f21,f22 // F21 = DxHDy
  mul.s f21,f2  // Convert To S.15.16
  cvt.w.s f21 // F21 = DxHDy
  mfc1 t4,f21 // T4 = DxHDy
  {#}DXHDY:
  sw t4,20(a2) // Store RDP Command (WORD 2 LO)


  sw t3,24(a2) // Store RDP Command (WORD 3 HI) T3 = XM (Uses Previous XH)
  sub.s f22,f18,f20
  c.eq.s f22,f0 // IF ((Y1 - Y2) == 0) DxMDy = 0.0 
  bc1t {#}DXMDY // ELSE DxMDy = (X1 - X2) / (Y1 - Y2)
  andi t3,0 // T3 = DxMDy 0.0

  sub.s f21,f17,f19
  div.s f21,f22 // F21 = DxMDy
  mul.s f21,f2  // Convert To S.15.16
  cvt.w.s f21 // F21 = DxMDy
  mfc1 t3,f21 // T3 = DxMDy
  {#}DXMDY:
  sw t3,28(a2) // Store RDP Command (WORD 3 LO)
  addi a2,32 // A2 += 32
}

macro FillTriLeft(start, end) { // Fill Triangle, Left Major
  la a0,{start} // A0 = 3D Triangle Object Data Start Offset
  la a1,{end}   // A1 = 3D Triangle Object Data End Offset
  {#}LoopTris:
    la a3,TRI // A3 = 2D Triangle Float Data Start Offset
    LoadXYZ() // Load 3D Transformed Triangle Coordinate 0 To 2D Triangle Data Offset
    LoadXYZ() // Load 3D Transformed Triangle Coordinate 1 To 2D Triangle Data Offset
    LoadXYZ() // Load 3D Transformed Triangle Coordinate 2 To 2D Triangle Data Offset

    subi a3,24 // A3 = 2D Triangle Float Data Start Offset
    FillTriHead() // Fill Triangle Header
    LeftMajorTri() // Run Left Major Triangle Calculation
    addi a0,4 // A0 += 4
    bne a0,a1,{#}LoopTris // Loop Triangles In Object Data
    nop // Delay Slot
}

macro FillTriLeftCullBack(start, end) { // Fill Triangle, Left Major, Back Face Culling
  la a0,{start} // A0 = 3D Triangle Object Data Start Offset
  la a1,{end}   // A1 = 3D Triangle Object Data End Offset
  {#}LoopTris:
    la a3,TRI // A3 = 2D Triangle Float Data Start Offset
    LoadXYZ() // Load 3D Transformed Triangle Coordinate 0 To 2D Triangle Data Offset
    LoadXYZ() // Load 3D Transformed Triangle Coordinate 1 To 2D Triangle Data Offset
    LoadXYZ() // Load 3D Transformed Triangle Coordinate 2 To 2D Triangle Data Offset

    // Polygon Back Face Culling
    subi a3,24 // A3 = 2D Triangle Float Data Start Offset
    PolyWinding() // Run Polygon Winding Test
    c.le.s f21,f0 // IF (Triangle Winding == Clockwise) Draw Polygon
    bc1t {#}SkipPoly // ELSE Skip Polygon
    nop // Delay Slot

    FillTriHead() // Fill Triangle Header
    LeftMajorTri() // Run Left Major Triangle Calculation

    {#}SkipPoly:
      addi a0,4 // A0 += 4
      bne a0,a1,{#}LoopTris // Loop Triangles In Object Data
      nop // Delay Slot
}

macro FillTriLeftCullFront(start, end) { // Fill Triangle, Left Major, Front Face Culling
  la a0,{start} // A0 = 3D Triangle Object Data Start Offset
  la a1,{end}   // A1 = 3D Triangle Object Data End Offset
  {#}LoopTris:
    la a3,TRI // A3 = 2D Triangle Float Data Start Offset
    LoadXYZ() // Load 3D Transformed Triangle Coordinate 0 To 2D Triangle Data Offset
    LoadXYZ() // Load 3D Transformed Triangle Coordinate 1 To 2D Triangle Data Offset
    LoadXYZ() // Load 3D Transformed Triangle Coordinate 2 To 2D Triangle Data Offset

    // Polygon Front Face Culling
    subi a3,24 // A3 = 2D Triangle Float Data Start Offset
    PolyWinding() // Run Polygon Winding Test
    c.le.s f21,f0 // IF (Triangle Winding == Anti-Clockwise) Draw Polygon
    bc1f {#}SkipPoly // ELSE Skip Polygon
    nop // Delay Slot

    FillTriHead()  // Fill Triangle Header
    LeftMajorTri() // Run Left Major Triangle Calculation

    {#}SkipPoly:
      addi a0,4 // A0 += 4
      bne a0,a1,{#}LoopTris // Loop Triangles In Object Data
      nop // Delay Slot
}

macro FillTriRight(start, end) { // Fill Triangle, Left Major
  la a0,{start} // A0 = 3D Triangle Object Data Start Offset
  la a1,{end}   // A1 = 3D Triangle Object Data End Offset
  {#}LoopTris:
    la a3,TRI // A3 = 2D Triangle Float Data Start Offset
    LoadXYZ() // Load 3D Transformed Triangle Coordinate 0 To 2D Triangle Data Offset
    LoadXYZ() // Load 3D Transformed Triangle Coordinate 1 To 2D Triangle Data Offset
    LoadXYZ() // Load 3D Transformed Triangle Coordinate 2 To 2D Triangle Data Offset

    subi a3,24 // A3 = 2D Triangle Float Data Start Offset
    FillTriHead() // Fill Triangle Header
    RightMajorTri() // Run Right Major Triangle Calculation
    addi a0,4 // A0 += 4
    bne a0,a1,{#}LoopTris // Loop Triangles In Object Data
    nop // Delay Slot
}

macro FillTriRightCullBack(start, end) { // Fill Triangle, Right Major, Back Face Culling
  la a0,{start} // A0 = 3D Triangle Object Data Start Offset
  la a1,{end}   // A1 = 3D Triangle Object Data End Offset
  {#}LoopTris:
    la a3,TRI // A3 = 2D Triangle Float Data Start Offset
    LoadXYZ() // Load 3D Transformed Triangle Coordinate 0 To 2D Triangle Data Offset
    LoadXYZ() // Load 3D Transformed Triangle Coordinate 1 To 2D Triangle Data Offset
    LoadXYZ() // Load 3D Transformed Triangle Coordinate 2 To 2D Triangle Data Offset

    // Polygon Back Face Culling
    subi a3,24 // A3 = 2D Triangle Float Data Start Offset
    PolyWinding() // Run Polygon Winding Test
    c.le.s f21,f0 // IF (Triangle Winding == Clockwise) Draw Polygon
    bc1t {#}SkipPoly // ELSE Skip Polygon
    nop // Delay Slot

    FillTriHead() // Fill Triangle Header
    RightMajorTri() // Run Right Major Triangle Calculation

    {#}SkipPoly:
      addi a0,4 // A0 += 4
      bne a0,a1,{#}LoopTris // Loop Triangles In Object Data
      nop // Delay Slot
}

macro FillTriRightCullFront(start, end) { // Fill Triangle, Right Major, Front Face Culling
  la a0,{start} // A0 = 3D Triangle Object Data Start Offset
  la a1,{end}   // A1 = 3D Triangle Object Data End Offset
  {#}LoopTris:
    la a3,TRI // A3 = 2D Triangle Float Data Start Offset
    LoadXYZ() // Load 3D Transformed Triangle Coordinate 0 To 2D Triangle Data Offset
    LoadXYZ() // Load 3D Transformed Triangle Coordinate 1 To 2D Triangle Data Offset
    LoadXYZ() // Load 3D Transformed Triangle Coordinate 2 To 2D Triangle Data Offset

    // Polygon Front Face Culling
    subi a3,24 // A3 = 2D Triangle Float Data Start Offset
    PolyWinding() // Run Polygon Winding Test
    c.le.s f21,f0 // IF (Triangle Winding == Anti-Clockwise) Draw Polygon
    bc1f {#}SkipPoly // ELSE Skip Polygon
    nop // Delay Slot

    FillTriHead() // Fill Triangle Header
    RightMajorTri() // Run Right Major Triangle Calculation

    {#}SkipPoly:
      addi a0,4 // A0 += 4
      bne a0,a1,{#}LoopTris // Loop Triangles In Object Data
      nop // Delay Slot
}

macro XPos(x) { // Object X Translation
  la a0,{x} // Load X Translation Value
  lwc1 f6,0(a0) //  F6 = Matrix3D[3] (Translation X)
}

macro YPos(y) { // Object Y Translation
  la a0,{y} // Load Y Translation Value
  lwc1 f10,0(a0) // F10 = Matrix3D[7] (Translation Y)
}

macro ZPos(z) { // Object Z Translation
  la a0,{z} // Load Z Translation Value
  lwc1 f14,0(a0) // F14 = Matrix3D[11] (Translation Z)
}

macro XYZPos(xyz) { // Object X, Y, Z Translation
  la a0,{xyz} // Load X, Y, Z Translation Value
  lwc1 f6,0(a0)  //  F6 = Matrix3D[3]  (Translation X)
  lwc1 f10,4(a0) // F10 = Matrix3D[7]  (Translation Y)
  lwc1 f14,8(a0) // F14 = Matrix3D[11] (Translation Z)
}

macro XRotCalc(x, precalc) { // Return X Rotation
  la a0,{x}   // Load X Rotate Value
  lw t0,0(a0) // T0 = X Rotate Value
  la a0,{precalc} // A0 = Pre Calculated Rotation Values
  sll t0,4        // T0 *= 16
  add t0,a0       // T0 = Correct Rotate Pre Calculated X Value (* 16)
  lwc1 f8,0(t0)  // F8  =  XC
  lwc1 f9,4(t0)  // F9  = -XS
  lwc1 f12,8(t0) // F12 =  XS
  lwc1 f13,0(t0) // F13 =  XC
}

macro YRotCalc(y, precalc) { // Return Y Rotation
  la a0,{y}   // Load Y Rotate Value
  lw t0,0(a0) // T0 = Y Rotate Value
  la a0,{precalc} // A0 = Pre Calculated Rotation Values
  sll t0,4        // T0 *= 16
  add t0,a0       // T0 = Correct Rotate Pre Calculated Y Value (* 16)
  lwc1 f3,0(t0)  // F3  =  YC
  lwc1 f11,4(t0) // F11 = -YS
  lwc1 f5,8(t0)  // F5  =  YS
  lwc1 f13,0(t0) // F13 =  YC
}

macro ZRotCalc(z, precalc) { // Return Z Rotation
  la a0,{z}   // Load Z Rotate Value
  lw t0,0(a0) // T0 = Z Rotate Value
  la a0,{precalc} // A0 = Pre Calculated Rotation Values
  sll t0,4        // T0 *= 16
  add t0,a0       // T0 = Correct Rotate Pre Calculated Z Value (* 16)
  lwc1 f3,0(t0) // F3 =  ZC
  lwc1 f4,4(t0) // F4 = -ZS
  lwc1 f7,8(t0) // F7 =  ZS
  lwc1 f8,0(t0) // F8 =  ZC
}

macro XYRotCalc(x, y, precalc) { // Return XY Rotation
  la a0,{x}   // Load X Rotate Value
  lw t0,0(a0) // T0 = X Rotate Value
  la a0,{y}   // Load Y Rotate Value
  lw t1,0(a0) // T1 = Y Rotate Value
  la a0,{precalc} // A0 = Pre Calculated Rotation Values
  sll t0,4        // T0 *= 16
  add t0,a0       // T0 = Correct Rotate Pre Calculated X Value (* 16)
  sll t1,4        // T1 *= 16
  add t1,a0       // T1 = Correct Rotate Pre Calculated Y Value (* 16)
  lwc1 f8,0(t0)   // F8  =  XC
  lwc1 f12,4(t0)  // F12 = -XS
  lwc1 f9,8(t0)   // F9  =  XS
  lwc1 f5,12(t0)  // F5  = -XC
  lwc1 f3,0(t1)   // F3  =  YC
  lwc1 f11,8(t1)  // F11 =  YS
  mul.s f4,f9,f11 // F4  =  XS * YS
  mul.s f5,f11    // F5  = -XC * YS
  mul.s f12,f3    // F12 = -XS * YC
  mul.s f13,f8,f3 // S24 =  XC * YC
}

macro XZRotCalc(x, z, precalc) { // Return XZ Rotation
  la a0,{x}   // Load X Rotate Value
  lw t0,0(a0) // T0 = X Rotate Value
  la a0,{z}   // Load Z Rotate Value
  lw t1,0(a0) // T1 = Z Rotate Value
  la a0,{precalc} // A0 = Pre Calculated Rotation Values
  sll t0,4        // T0 *= 16
  add t0,a0       // T0 = Correct Rotate Pre Calculated X Value (* 16)
  sll t1,4        // T1 *= 16
  add t1,a0       // T1 = Correct Rotate Pre Calculated Z Value (* 16)
  lwc1 f13,0(t0)  // F13 =  XC
  lwc1 f9,8(t0)   // F9  =  XS
  lwc1 f3,0(t1)   // F3  =  ZC
  lwc1 f7,4(t1)   // F7  = -ZS
  lwc1 f4,8(t1)   // F4  =  ZS
  lwc1 f12,12(t1) // F12 = -ZC
  mul.s f7,f13    // F7  =  XC * -ZS
  mul.s f8,f13,f3 // F8  = -XC * ZC
  mul.s f11,f9,f4 // F11 = -XS * ZS
  mul.s f12,f9    // F12 =  XS * -ZC
}

macro YZRotCalc(y, z, precalc) { // Return YZ Rotation
  la a0,{y}   // Load Y Rotate Value
  lw t0,0(a0) // T0 = Y Rotate Value
  la a0,{z}   // Load Z Rotate Value
  lw t1,0(a0) // T1 = Z Rotate Value
  la a0,{precalc} // A0 = Pre Calculated Rotation Values
  sll t0,4        // T0 *= 16
  add t0,a0       // T0 = Correct Rotate Pre Calculated Y Value (* 16)
  sll t1,4        // T1 *= 16
  add t1,a0       // T1 = Correct Rotate Pre Calculated Z Value (* 16)
  lwc1 f13,0(t0)  // F13 =  YC
  lwc1 f11,8(t0)  // F11 =  YS
  lwc1 f8,0(t1)   // F8  =  ZC
  lwc1 f7,4(t1)   // F7  = -ZS
  lwc1 f4,8(t1)   // F4  =  ZS
  lwc1 f5,12(t1)  // F5  = -ZC
  mul.s f3,f13,f8 // F3  =  YC * ZC
  mul.s f5,f11    // F5  =  YS * -ZC
  mul.s f7,f13    // F7  =  YC * -ZS
  mul.s f9,f11,f4 // F9  =  YS * ZS
}

macro XYZRotCalc(x, y, z, precalc) { // Return XYZ Rotation
  la a0,{x}   // Load X Rotate Value
  lw t0,0(a0) // T0 = X Rotate Value
  la a0,{y}   // Load Y Rotate Value
  lw t1,0(a0) // T1 = Y Rotate Value
  la a0,{z}   // Load Z Rotate Value
  lw t2,0(a0) // T2 = Z Rotate Value
  la a0,{precalc} // A0 = Pre Calculated Rotation Values
  sll t0,4        // T0 *= 16
  add t0,a0       // T0 = Correct Rotate Pre Calculated Y Value (* 16)
  sll t1,4        // T1 *= 16
  add t1,a0       // T1 = Correct Rotate Pre Calculated Y Value (* 16)
  sll t2,4        // T2 *= 16
  add t2,a0       // T2 = Correct Rotate Pre Calculated Z Value (* 16)
  lwc1 f4,0(t0)    // F4  =  XC
  lwc1 f7,4(t0)    // F7  = -XS
  lwc1 f9,8(t0)    // F9  =  XS
  lwc1 f5,12(t0)   // F5  = -XC
  lwc1 f13,0(t1)   // F13 =  YC
  lwc1 f15,8(t1)   // F15 =  YS TEMP
  lwc1 f11,0(t2)   // F11 =  ZC
  lwc1 f12,8(t2)   // F12 =  ZS
  mul.s f8,f7,f13  // F8  = -XS * YC
  mul.s f7,f8,f11  // F7  = -XS * YC * ZC
  mul.s f16,f4,f12 // F16 =  XC * ZS TEMP
  sub.s f7,f16     // F7  =(-XS * YC * ZC) - (XC * ZS)
  mul.s f8,f12     // F8  = -XS * YC * ZS
  mul.s f16,f4,f11 // F16 =  XC * ZC
  add.s f8,f16     // F8  =(-XS * YC * ZS) + (XC * ZC)
  mul.s f4,f13     // F4  =  XC * YC
  mul.s f3,f4,f11  // F3  =  XC * YC * ZC
  mul.s f16,f9,f12 // F16 =  XS * ZS TEMP
  sub.s f3,f16     // F3  = (XC * YC * ZC) - (XS * ZS)
  mul.s f4,f12     // F4  =  XC * YC * ZS
  mul.s f16,f9,f11 // F16 =  XS * ZC
  add.s f4,f16     // F4  = (XC * YC * ZS) + (XS * ZC)
  mul.s f5,f15     // F5  = -XC * YS
  mul.s f9,f15     // F9  =  XS * YS
  mul.s f11,f15    // F11 =  ZC * YS
  mul.s f12,f15    // F12 =  ZS * YS
}