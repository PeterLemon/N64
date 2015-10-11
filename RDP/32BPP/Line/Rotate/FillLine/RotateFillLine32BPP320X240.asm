// N64 'Bare Metal' 32BPP 320x240 Rotate Fill Line RDP Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "RotateFillLine32BPP320X240.N64", create
fill 1052672 // Set ROM Size

origin $00000000
base $80000000 // Entry Point Of Code
include "LIB\N64.INC" // Include N64 Definitions
include "LIB\N64_HEADER.ASM" // Include 64 Byte Header & Vector Table
insert "LIB\N64_BOOTCODE.BIN" // Include 4032 Byte Boot Code

macro LoadXYZ() { // Load X,Y,Z
  lwc1 f16,0(a0) // F16 = X
  addi a0,4
  lwc1 f17,0(a0) // F17 = Y
  addi a0,4
  lwc1 f18,0(a0) // F18 = Z
  addi a0,4
  Calc3D()
}

macro Calc3D() { // Calculate X,Y,Z 3D
  mul.s f19,f4,f16 // XCalc = (Matrix3D[0] * X) + (Matrix3D[1] * Y) + (Matrix3D[2] * Z) + Matrix3D[3]
  mul.s f22,f5,f17
  add.s f19,f22
  mul.s f22,f6,f18
  add.s f19,f22
  add.s f19,f7
  mul.s f20,f8,f16 // YCalc = (Matrix3D[4] * X) + (Matrix3D[5] * Y) + (Matrix3D[6] * Z) + Matrix3D[7]
  mul.s f22,f9,f17
  add.s f20,f22
  mul.s f22,f10,f18
  add.s f20,f22
  add.s f20,f11
  mul.s f21,f12,f16 // ZCalc = (Matrix3D[8] * X) + (Matrix3D[9] * Y) + (Matrix3D[10] * Z) + Matrix3D[11]
  mul.s f22,f13,f17
  add.s f21,f22
  mul.s f22,f14,f18
  add.s f21,f22
  add.s f21,f15
  Calc2D()
}

macro Calc2D() { // Calculate X,Y 2D
  la a2,HALF_SCREEN_X // A2 = HALF SCREEN X Data Offset
  lwc1 f16,0(a2) // F16 = HALF SCREEN X
  lwc1 f17,4(a2) // F17 = HALF SCREEN Y

  c.le.s f21,f0 // IF (Z <= 0.0) Do Not Divide By Zero
  bc1t +
  nop // Delay Slot

  lwc1 f18,8(a2) // F17 = FOV
  div.s f22,f21,f18 // F22 = Z / FOV

  div.s f19,f22 // X = X / Z + (ScreenX / 2)
  add.s f19,f16

  div.s f20,f22 // Y = (ScreenY / 2) - Y / Z 
  sub.s f20,f17,f20

  swc1 f19,0(a1)
  addi a1,4
  swc1 f20,0(a1)
  addi a1,4

  b ++
  nop // Delay Slot

  +
  swc1 f16,0(a1)
  addi a1,4
  swc1 f17,0(a1)
  addi a1,4
  +
}

macro XRotCalc(x, precalc) { // Return X Rotation
  la a0,{x}   // Load X Rotate Value
  lw t0,0(a0) // T0 = X Rotate Value
  la a0,{precalc} // A0 = Pre Calculated Rotation Values
  sll t0,4        // T0 *= 16
  add t0,a0       // T0 = Correct Rotate Pre Calculated X Value (* 16)
  lwc1 f9,0(t0)  // F9  =  XC
  lwc1 f10,4(t0) // F10 = -XS
  lwc1 f13,8(t0) // F13 =  XS
  lwc1 f14,0(t0) // F14 =  XC
}

macro YRotCalc(y, precalc) { // Return Y Rotation
  la a0,{y}   // Load Y Rotate Value
  lw t0,0(a0) // T0 = Y Rotate Value
  la a0,{precalc} // A0 = Pre Calculated Rotation Values
  sll t0,4        // T0 *= 16
  add t0,a0       // T0 = Correct Rotate Pre Calculated Y Value (* 16)
  lwc1 f4,0(t0)  // F4  =  YC
  lwc1 f12,4(t0) // F12 = -YS
  lwc1 f6,8(t0)  // F6  =  YS
  lwc1 f14,0(t0) // F14 =  YC
}

macro ZRotCalc(z, precalc) { // Return Z Rotation
  la a0,{z}   // Load Z Rotate Value
  lw t0,0(a0) // T0 = Z Rotate Value
  la a0,{precalc} // A0 = Pre Calculated Rotation Values
  sll t0,4        // T0 *= 16
  add t0,a0       // T0 = Correct Rotate Pre Calculated Z Value (* 16)
  lwc1 f4,0(t0) // F4 =  ZC
  lwc1 f5,4(t0) // F5 = -ZS
  lwc1 f8,8(t0) // F8 =  ZS
  lwc1 f9,0(t0) // F9 =  ZC
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
  lwc1 f9,0(t0)    // F9  =  XC
  lwc1 f13,4(t0)   // F13 = -XS
  lwc1 f10,8(t0)   // F10 =  XS
  lwc1 f6,12(t0)   // F6  = -XC
  lwc1 f4,0(t1)    // F4  =  YC
  lwc1 f12,8(t1)   // F12 =  YS
  mul.s f5,f10,f12 // F5  =  XS * YS
  mul.s f6,f12     // F6  = -XC * YS
  mul.s f13,f4     // F13 = -XS * YC
  mul.s f14,f9,f4  // F14 =  XC * YC
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
  lwc1 f14,0(t0)   // F14 =  XC
  lwc1 f10,8(t0)   // F10 =  XS
  lwc1 f4,0(t1)    // F4  =  ZC
  lwc1 f8,4(t1)    // F8  = -ZS
  lwc1 f5,8(t1)    // F5  =  ZS
  lwc1 f13,12(t1)  // F13 = -ZC
  mul.s f8,f14     // F8  =  XC * -ZS
  mul.s f9,f14,f4  // F9  = -XC * ZC
  mul.s f12,f10,f5 // F12 = -XS * ZS
  mul.s f13,f10    // F13 =  XS * -ZC
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
  lwc1 f14,0(t0)   // F14 =  YC
  lwc1 f12,8(t0)   // F12 =  YS
  lwc1 f9,0(t1)    // F9  =  ZC
  lwc1 f8,4(t1)    // F8  = -ZS
  lwc1 f5,8(t1)    // F5  =  ZS
  lwc1 f6,12(t1)   // F6  = -ZC
  mul.s f4,f14,f9  // F4  =  YC * ZC
  mul.s f6,f12     // F6  =  YS * -ZC
  mul.s f8,f14     // F8  =  YC * -ZS
  mul.s f10,f12,f5 // F10 =  YS * ZS
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
  lwc1 f5,0(t0)     // F4  =  XC
  lwc1 f8,4(t0)     // F7  = -XS
  lwc1 f10,8(t0)    // F9  =  XS
  lwc1 f6,12(t0)    // F5  = -XC
  lwc1 f14,0(t1)    // F13 =  YC
  lwc1 f16,8(t1)    // F15 =  YS TEMP
  lwc1 f12,0(t2)    // F11 =  ZC
  lwc1 f13,8(t2)    // F12 =  ZS
  mul.s f9,f8,f14   // F8  = -XS * YC
  mul.s f8,f9,f12   // F7  = -XS * YC * ZC
  mul.s f17,f5,f13  // F16 =  XC * ZS TEMP
  sub.s f8,f17      // F7  =(-XS * YC * ZC) - (XC * ZS)
  mul.s f9,f13      // F8  = -XS * YC * ZS
  mul.s f17,f5,f12  // F16 =  XC * ZC
  add.s f9,f17      // F8  =(-XS * YC * ZS) + (XC * ZC)
  mul.s f5,f14      // F4  =  XC * YC
  mul.s f4,f5,f12   // F3  =  XC * YC * ZC
  mul.s f17,f10,f13 // F16 =  XS * ZS TEMP
  sub.s f4,f17      // F3  = (XC * YC * ZC) - (XS * ZS)
  mul.s f5,f13      // F4  =  XC * YC * ZS
  mul.s f17,f10,f12 // F16 =  XS * ZC
  add.s f5,f17      // F4  = (XC * YC * ZS) + (XS * ZC)
  mul.s f6,f16      // F5  = -XC * YS
  mul.s f10,f16     // F9  =  XS * YS
  mul.s f12,f16     // F11 =  ZC * YS
  mul.s f13,f16     // F12 =  ZS * YS
}

Start:
  include "LIB\N64_GFX.INC" // Include Graphics Macros
  N64_INIT() // Run N64 Initialisation Routine

  ScreenNTSC(320, 240, BPP32, $A0100000) // Screen NTSC: 320x240, 32BPP, DRAM Origin $A0100000

  la a0,MULT // A0 = Float Multipy Data Offset
  lwc1 f0,0(a0) // F0 = 0.0 (Divide By Zero Check)
  lwc1 f1,4(a0) // F1 = 4.0 (Fixed Point S.11.2)
  lwc1 f2,8(a0) // F2 = 65536.0 (Fixed Point S.15.16)
  lwc1 f3,12(a0) // F3 = 1.0 (Float Increment)

  la a0,Matrix3D // A0 = Float Matrix 3D Data Offset
  lwc1 f4,0(a0)   // F4  = Matrix3D[0]
  lwc1 f5,4(a0)   // F5  = Matrix3D[1]
  lwc1 f6,8(a0)   // F6  = Matrix3D[2]
  lwc1 f7,12(a0)  // F7  = Matrix3D[3]
  lwc1 f8,16(a0)  // F8  = Matrix3D[4]
  lwc1 f9,20(a0)  // F9  = Matrix3D[5]
  lwc1 f10,24(a0) // F10 = Matrix3D[6]
  lwc1 f11,28(a0) // F11 = Matrix3D[7]
  lwc1 f12,32(a0) // F12 = Matrix3D[8]
  lwc1 f13,36(a0) // F13 = Matrix3D[9]
  lwc1 f14,40(a0) // F14 = Matrix3D[10]
  lwc1 f15,44(a0) // F15 = Matrix3D[11]

Loop:
  WaitScanline($200) // Wait For Scanline To Reach Vertical Blank

  DPC(RDPBuffer, RDPBufferEnd) // Run DPC Command Buffer: Start Address, End Address

  la a0,XRot // A0 = X Rotation Data Offset

  lw t0,0(a0)  // Load X Rotation Value
  addi t0,1    // X Rotation += 1
  andi t0,1023 // X Rotation &= 1023
  sw t0,0(a0)  // Store X Rotation Value

  lw t0,4(a0)  // Load Y Rotation Value
  addi t0,1    // Y Rotation += 1
  andi t0,1023 // Y Rotation &= 1023
  sw t0,4(a0)  // Store Y Rotation Value

  lw t0,8(a0)  // Load Z Rotation Value
  addi t0,1    // Z Rotation += 1
  andi t0,1023 // Z Rotation &= 1023
  sw t0,8(a0)  // Store Z Rotation Value

  //XRotCalc(XRot, SinCos1024) // X Rotate Line
  //YRotCalc(YRot, SinCos1024) // Y Rotate Line
  ZRotCalc(ZRot, SinCos1024) // Z Rotate Line
  //XYRotCalc(XRot, YRot, SinCos1024) // XY Rotate Line
  //XZRotCalc(XRot, ZRot, SinCos1024) // XZ Rotate Line
  //YZRotCalc(YRot, ZRot, SinCos1024) // YZ Rotate Line
  //XYZRotCalc(XRot, YRot, ZRot, SinCos1024) // XYZ Rotate Line

  la a0,LineObj // A0 = 3D Line Object Data Offset
  la a1,LINE    // A1 = 2D Line Data Offset
  LoadXYZ() // Load 3D Transformed Line Coordinate 0 To 2D Line Data Offset
  LoadXYZ() // Load 3D Transformed Line Coordinate 1 To 2D Line Data Offset


  la a0,LINE // A0 = Float Line Data Offset

  // PASS1 Sort Y Coordinate 0 & 1
  lwc1 f16,4(a0)  // F16 = Line Y0
  lwc1 f17,12(a0) // F17 = Line Y1
  c.lt.s f16,f17 // IF (Y0 < Y1) Swap Line Coordinates 0 & 1
  bc1f PASS1End  // ELSE No Swap
  nop // Delay Slot
  lwc1 f18,0(a0)  // F18 = X0
  lwc1 f19,8(a0)  // F19 = X1
  swc1 f19,0(a0)  // X0 = X1
  swc1 f17,4(a0)  // Y0 = Y1
  swc1 f18,8(a0)  // X1 = X0
  swc1 f16,12(a0) // Y1 = Y0
  PASS1End:

  // PASS2 Sort X Coordinate 0 & 1
  lwc1 f16,4(a0)  // F16 = Line Y0
  lwc1 f17,12(a0) // F17 = Line Y1
  c.eq.s f16,f17 // IF (Y0 == Y1) Swap Line Coordinates 0 & 1
  bc1f PASS2End  // ELSE No Swap
  nop // Delay Slot
  lwc1 f18,0(a0) // F18 = X0
  lwc1 f19,8(a0) // F19 = X1
  c.lt.s f18,f19 // IF (X0 < X1) Swap Line Coordinates 0 & 1
  bc1f PASS2End // ELSE No Swap
  nop // Delay Slot
  swc1 f19,0(a0)  // X0 = X1
  swc1 f17,4(a0)  // Y0 = Y1
  swc1 f18,8(a0)  // X1 = X0
  swc1 f16,12(a0) // Y1 = Y0
  PASS2End:


  lwc1 f16,0(a0)  // F16 = Line X0 (XL)
  lwc1 f17,4(a0)  // F17 = Line Y0 (YL)
  lwc1 f18,8(a0)  // F18 = Line X1 (XH)
  lwc1 f19,12(a0) // F19 = Line Y1 (YH)
  mov.s f20,f0 // F20 = 0.0 (DxDy)

  la a0,$A0000000|(FillLine&$3FFFFF) // A0 = RDP Fill Line RAM Offset


  Vertical:
  c.eq.s f16,f18 // IF (XL == XH) // Vertical Line (|)
  bc1f Horizontal
  nop // Delay Slot
  add.s f16,f3 // XL += 1
  j StoreRDP
  nop // Delay Slot

  Horizontal:
  c.eq.s f17,f19 // IF (YL == YH) // Horizontal Line (-)
  bc1f DxDyCalc
  nop // Delay Slot
  add.s f17,f3 // YL += 1
  j StoreRDP
  nop // Delay Slot

  DxDyCalc:
  sub.s f20,f16,f18 // DxDy = (XL - XH) / (YL - YH)
  sub.s f21,f17,f19
  div.s f20,f21 // F8 = DxDy
  abs.s f21,f20 // F9 = abs(DxDy)

  c.lt.s f21,f3 // IF abs(DxDy) < 1 (Lines With X Distance < 1)
  bc1f LeftRight
  nop // Delay Slot
  add.s f16,f18,f3 // XL = XH + 1
  j StoreRDP
  nop // Delay Slot

  LeftRight:
  add.s f16,f18,f21 // ELSE XL = XH + abs(DxDy)


  StoreRDP:
  mul.s f21,f17,f1 // Convert To S.11.2
  cvt.w.s f21 // F21 = YL
  mfc1 t0,f21 // T0 = YL
  andi t0,$3FFF // T0 &= S.11.2
  sh t0,2(a0) // Store RDP Command (WORD 0 HI)

  mul.s f21,f19,f1 // Convert To S.11.2
  cvt.w.s f21 // F21 = YM
  mfc1 t0,f21 // T0 = YM
  andi t0,$3FFF // T0 &= S.11.2
  dsll t1,t0,16 // T1 = YM
  or t0,t1 // T0 = YM,YH
  sw t0,4(a0) // Store RDP Command (WORD 0 LO)

  mul.s f21,f16,f2 // Convert To S.15.16
  cvt.w.s f21 // F21 = XL
  mfc1 t0,f21 // T0 = XL
  sw t0,8(a0) // Store RDP Command (WORD 1 HI)

  mul.s f21,f20,f2 // Convert To S.15.16
  cvt.w.s f21 // F21 = DxDy
  mfc1 t0,f21 // T0 = DxDy
  sw t0,12(a0) // Store RDP Command (WORD 1 LO)
  sw t0,20(a0) // Store RDP Command (WORD 2 LO)

  mul.s f21,f18,f2 // Convert To S.15.16
  cvt.w.s f21 // F21 = XH
  mfc1 t0,f21 // T0 = XH
  sw t0,16(a0) // Store RDP Command (WORD 2 HI)


  j Loop
  nop // Delay Slot

align(8) // Align 64-Bit
RDPBuffer:
arch n64.rdp
  Set_Scissor 0<<2,0<<2, 0,0, 320<<2,240<<2 // Set Scissor: XH 0.0,YH 0.0, Scissor Field Enable Off,Field Off, XL 320.0,YL 240.0
  Set_Other_Modes CYCLE_TYPE_FILL // Set Other Modes
  Set_Color_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_32B,320-1, $00100000 // Set Color Image: FORMAT RGBA,SIZE 32B,WIDTH 320, DRAM ADDRESS $00100000
  Set_Fill_Color $FFFF00FF // Set Fill Color: PACKED COLOR 32B R8G8B8A8 Pixel
  Fill_Rectangle 319<<2,239<<2, 0<<2,0<<2 // Fill Rectangle: XL 319.0,YL 239.0, XH 0.0,YH 0.0

  Set_Other_Modes SAMPLE_TYPE|BI_LERP_0|ALPHA_DITHER_SEL_NO_DITHER|B_M1A_0_2 // Set Other Modes
  Set_Combine_Mode $0,$00, 0,0, $1,$01, $0,$F, 1,0, 0,0,0, 7,7,7 // Set Combine Mode: SubA RGB0,MulRGB0, SubA Alpha0,MulAlpha0, SubA RGB1,MulRGB1, SubB RGB0,SubB RGB1, SubA Alpha1,MulAlpha1, AddRGB0,SubB Alpha0,AddAlpha0, AddRGB1,SubB Alpha1,AddAlpha1

  Sync_Pipe // Stall Pipeline, Until Preceeding Primitives Completely Finish
  Set_Blend_Color $FF0000FF // Set Blend Color: R 255,G 0,B 0,A 255 (Red)
  FillLine:
    Fill_Triangle 1,0,0, 0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0 // Dir,Level,Tile, YL,YM,YH, XL,DxLDy, XH,DxHDy, XM,DxMDy

  Sync_Full // Ensure Entire Scene Is Fully Drawn
RDPBufferEnd:

MULT: // Float Multipy Data
  float32     0.0 // (Divide By Zero Check)
  float32     4.0 // Multiply (Fixed Point S.11.2)
  float32 65536.0 // Multiply (Fixed Point S.15.16)
  float32     1.0 // Increment Float

LINE: // Float 2D Line Data
  float32 0.0, 0.0 // Line X0, Y0
  float32 0.0, 0.0 // Line X1, Y1

Matrix3D: // Float Matrix 3D Data
  //        X,   Y,   Z,    T
  float32 1.0, 0.0, 0.0,  0.0 // X
  float32 0.0, 1.0, 0.0,  0.0 // Y
  float32 0.0, 0.0, 1.0, 15.0 // Z

XRot:
  dd 120 // X Rotation Value (0..1023)
YRot:
  dd 360 // Y Rotation Value (0..1023)
ZRot:
  dd 200 // Z Rotation Value (0..1023)

// Setup 3D
HALF_SCREEN_X:
  float32 160.0
HALF_SCREEN_Y:
  float32 120.0
FOV:
  float32 160.0

include "objects.asm" // Object Data
include "sincos1024.asm" // Pre Calculated Matrix Sin Cos Rotation Values