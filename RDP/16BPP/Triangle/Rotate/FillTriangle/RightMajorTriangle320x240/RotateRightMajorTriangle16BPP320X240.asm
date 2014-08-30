; N64 'Bare Metal' 16BPP 320x240 Rotate Right Major Fill Triangle RDP Demo by krom (Peter Lemon):

  include LIB\N64.INC ; Include N64 Definitions
  dcb 2097152,$00 ; Set ROM Size
  org $80000000 ; Entry Point Of Code
  include LIB\N64_HEADER.ASM  ; Include 64 Byte Header & Vector Table
  incbin LIB\N64_BOOTCODE.BIN ; Include 4032 Byte Boot Code

LoadXYZ: macro ; Load X,Y,Z
  lwc1 f15,0(t0) ; F15 = X
  addi t0,4
  lwc1 f16,0(t0) ; F16 = Y
  addi t0,4
  lwc1 f17,0(t0) ; F17 = Z
  addi t0,4
  Calc3D
  endm

Calc3D: macro ; Calculate X,Y,Z 3D
  mul.s f18,f3,f15 ; XCalc = (Matrix3D[0] * X) + (Matrix3D[1] * Y) + (Matrix3D[2] * Z) + Matrix3D[3]
  mul.s f21,f4,f16
  add.s f18,f21
  mul.s f21,f5,f17
  add.s f18,f21
  add.s f18,f6
  mul.s f19,f7,f15 ; YCalc = (Matrix3D[4] * X) + (Matrix3D[5] * Y) + (Matrix3D[6] * Z) + Matrix3D[7]
  mul.s f21,f8,f16
  add.s f19,f21
  mul.s f21,f9,f17
  add.s f19,f21
  add.s f19,f10
  mul.s f20,f11,f15 ; ZCalc = (Matrix3D[8] * X) + (Matrix3D[9] * Y) + (Matrix3D[10] * Z) + Matrix3D[11]
  mul.s f21,f12,f16
  add.s f20,f21
  mul.s f21,f13,f17
  add.s f20,f21
  add.s f20,f14
  Calc2D
  endm

Calc2D: macro ; Calculate X,Y 2D
  la t2,HALF_SCREEN_X ; T2 = HALF SCREEN X Data Offset
  lwc1 f15,0(t2) ; F15 = HALF SCREEN X
  lwc1 f16,4(t2) ; F16 = HALF SCREEN Y

  c.le.s f20,f0 ; IF (Z <= 0.0) Do Not Divide By Zero
  bc1t ZeroZ\@
  nop ; Delay Slot

  lwc1 f17,8(t2) ; F17 = FOV
  div.s f21,f20,f17 ; F21 = Z / FOV

  div.s f18,f21 ; X = X / Z + (ScreenX / 2)
  add.s f18,f15

  div.s f19,f21 ; Y = (ScreenY / 2) - Y / Z 
  sub.s f19,f16,f19

  swc1 f18,0(t1)
  addi t1,4
  swc1 f19,0(t1)
  addi t1,4

  b Calc2DEnd\@
  nop ; Delay Slot

  ZeroZ\@:
  swc1 f15,0(t1)
  addi t1,4
  swc1 f16,0(t1)
  addi t1,4
  Calc2DEnd\@:
  endm

XRotCalc: macro x, precalc ; Return X Rotation
  la t0,x     ; Load X Rotate Value
  lw t0,0(t0) ; T0 = X Rotate Value
  la t1,precalc ; T1 = Pre Calculated Rotation Values
  sll t0,4      ; T0 *= 16
  add t0,t1     ; T0 = Correct Rotate Pre Calculated X Value (* 16)
  lwc1 f8,0(t0)  ; F8  =  XC
  lwc1 f9,4(t0)  ; F9  = -XS
  lwc1 f12,8(t0) ; F12 =  XS
  lwc1 f13,0(t0) ; F13 =  XC
  endm

YRotCalc: macro y, precalc ; Return Y Rotation
  la t0,y     ; Load Y Rotate Value
  lw t0,0(t0) ; T0 = Y Rotate Value
  la t1,precalc ; T1 = Pre Calculated Rotation Values
  sll t0,4      ; T0 *= 16
  add t0,t1     ; T0 = Correct Rotate Pre Calculated Y Value (* 16)
  lwc1 f3,0(t0)  ; F3  =  YC
  lwc1 f11,4(t0) ; F11 = -YS
  lwc1 f5,8(t0)  ; F5  =  YS
  lwc1 f13,0(t0) ; F13 =  YC
  endm

ZRotCalc: macro z, precalc ; Return Z Rotation
  la t0,z     ; Load Z Rotate Value
  lw t0,0(t0) ; T0 = Z Rotate Value
  la t1,precalc ; T1 = Pre Calculated Rotation Values
  sll t0,4      ; T0 *= 16
  add t0,t1     ; T0 = Correct Rotate Pre Calculated Z Value (* 16)
  lwc1 f3,0(t0) ; F3 =  ZC
  lwc1 f4,4(t0) ; F4 = -ZS
  lwc1 f7,8(t0) ; F7 =  ZS
  lwc1 f8,0(t0) ; F8 =  ZC
  endm

XYRotCalc: macro x, y, precalc ; Return XY Rotation
  la t0,x     ; Load X Rotate Value
  lw t0,0(t0) ; T0 = X Rotate Value
  la t1,y     ; Load Y Rotate Value
  lw t1,0(t1) ; T1 = Y Rotate Value
  la t2,precalc ; T2 = Pre Calculated Rotation Values
  sll t0,4      ; T0 *= 16
  add t0,t2     ; T0 = Correct Rotate Pre Calculated X Value (* 16)
  sll t1,4      ; T1 *= 16
  add t1,t2     ; T1 = Correct Rotate Pre Calculated Y Value (* 16)
  lwc1 f8,0(t0)   ; F8  =  XC
  lwc1 f12,4(t0)  ; F12 = -XS
  lwc1 f9,8(t0)   ; F9  =  XS
  lwc1 f5,12(t0)  ; F5  = -XC
  lwc1 f3,0(t1)   ; F3  =  YC
  lwc1 f11,8(t1)  ; F11 =  YS
  mul.s f4,f9,f11 ; F4  =  XS * YS
  mul.s f5,f11    ; F5  = -XC * YS
  mul.s f12,f3    ; F12 = -XS * YC
  mul.s f13,f8,f3 ; S24 =  XC * YC
  endm

XZRotCalc: macro x, z, precalc ; Return XZ Rotation
  la t0,x     ; Load X Rotate Value
  lw t0,0(t0) ; T0 = X Rotate Value
  la t1,z     ; Load Z Rotate Value
  lw t1,0(t1) ; T1 = Z Rotate Value
  la t2,precalc ; T2 = Pre Calculated Rotation Values
  sll t0,4      ; T0 *= 16
  add t0,t2     ; T0 = Correct Rotate Pre Calculated X Value (* 16)
  sll t1,4      ; T1 *= 16
  add t1,t2     ; T1 = Correct Rotate Pre Calculated Z Value (* 16)
  lwc1 f13,0(t0)  ; F13 =  XC
  lwc1 f9,8(t0)   ; F9  =  XS
  lwc1 f3,0(t1)   ; F3  =  ZC
  lwc1 f7,4(t1)   ; F7  = -ZS
  lwc1 f4,8(t1)   ; F4  =  ZS
  lwc1 f12,12(t1) ; F12 = -ZC
  mul.s f7,f13    ; F7  =  XC * -ZS
  mul.s f8,f13,f3 ; F8  = -XC * ZC
  mul.s f11,f9,f4 ; F11 = -XS * ZS
  mul.s f12,f9    ; F12 =  XS * -ZC
  endm

YZRotCalc: macro y, z, precalc ; Return YZ Rotation
  la t0,y     ; Load Y Rotate Value
  lw t0,0(t0) ; T0 = Y Rotate Value
  la t1,z     ; Load Z Rotate Value
  lw t1,0(t1) ; T1 = Z Rotate Value
  la t2,precalc ; T2 = Pre Calculated Rotation Values
  sll t0,4      ; T0 *= 16
  add t0,t2     ; T0 = Correct Rotate Pre Calculated Y Value (* 16)
  sll t1,4      ; T1 *= 16
  add t1,t2     ; T1 = Correct Rotate Pre Calculated Z Value (* 16)
  lwc1 f13,0(t0)  ; F13 =  YC
  lwc1 f11,8(t0)  ; F11 =  YS
  lwc1 f8,0(t1)   ; F8  =  ZC
  lwc1 f7,4(t1)   ; F7  = -ZS
  lwc1 f4,8(t1)   ; F4  =  ZS
  lwc1 f5,12(t1)  ; F5  = -ZC
  mul.s f3,f13,f8 ; F3  =  YC * ZC
  mul.s f5,f11    ; F5  =  YS * -ZC
  mul.s f7,f13    ; F7  =  YC * -ZS
  mul.s f9,f11,f4 ; F9  =  YS * ZS
  endm

XYZRotCalc: macro x, y, z, precalc ; Return XYZ Rotation
  la t0,x     ; Load X Rotate Value
  lw t0,0(t0) ; T0 = X Rotate Value
  la t1,y     ; Load Y Rotate Value
  lw t1,0(t1) ; T1 = Y Rotate Value
  la t2,z     ; Load Z Rotate Value
  lw t2,0(t2) ; T2 = Z Rotate Value
  la t3,precalc ; T3 = Pre Calculated Rotation Values
  sll t0,4      ; T0 *= 16
  add t0,t3     ; T0 = Correct Rotate Pre Calculated Y Value (* 16)
  sll t1,4      ; T1 *= 16
  add t1,t3     ; T1 = Correct Rotate Pre Calculated Y Value (* 16)
  sll t2,4      ; T2 *= 16
  add t2,t3     ; T2 = Correct Rotate Pre Calculated Z Value (* 16)
  lwc1 f4,0(t0)    ; F4  =  XC
  lwc1 f7,4(t0)    ; F7  = -XS
  lwc1 f9,8(t0)    ; F9  =  XS
  lwc1 f5,12(t0)   ; F5  = -XC
  lwc1 f13,0(t1)   ; F13 =  YC
  lwc1 f15,8(t1)   ; F15 =  YS TEMP
  lwc1 f11,0(t2)   ; F11 =  ZC
  lwc1 f12,8(t2)   ; F12 =  ZS
  mul.s f8,f7,f13  ; F8  = -XS * YC
  mul.s f7,f8,f11  ; F7  = -XS * YC * ZC
  mul.s f16,f4,f12 ; F16 =  XC * ZS TEMP
  sub.s f7,f16     ; F7  =(-XS * YC * ZC) - (XC * ZS)
  mul.s f8,f12     ; F8  = -XS * YC * ZS
  mul.s f16,f4,f11 ; F16 =  XC * ZC
  add.s f8,f16     ; F8  =(-XS * YC * ZS) + (XC * ZC)
  mul.s f4,f13     ; F4  =  XC * YC
  mul.s f3,f4,f11  ; F3  =  XC * YC * ZC
  mul.s f16,f9,f12 ; F16 =  XS * ZS TEMP
  sub.s f3,f16     ; F3  = (XC * YC * ZC) - (XS * ZS)
  mul.s f4,f12     ; F4  =  XC * YC * ZS
  mul.s f16,f9,f11 ; F16 =  XS * ZC
  add.s f4,f16     ; F4  =(XC * YC * ZS) + (XS * ZC)
  mul.s f5,f15     ; F5  = -XC * YS
  mul.s f9,f15     ; F9  =  XS * YS
  mul.s f11,f15    ; F11 =  ZC * YS
  mul.s f12,f15    ; F12 =  ZS * YS
  endm

Start:
  include LIB\N64_INIT.ASM ; Include Initialisation Routine
  include LIB\N64_GFX.INC  ; Include Graphics Macros

  ScreenNTSC 320,240, BPP16, $A0100000 ; Screen NTSC: 320x240, 16BPP, DRAM Origin $A0100000

  la t0,MULT ; T0 = Float Multipy Data Offset
  lwc1 f0,0(t0) ; F0 = 0.0 (Divide By Zero Check)
  lwc1 f1,4(t0) ; F1 = 4.0 (Fixed Point S.11.2)
  lwc1 f2,8(t0) ; F2 = 65536.0 (Fixed Point S.15.16)

  la t0,Matrix3D ; T0 = Float Matrix 3D Data Offset
  lwc1 f3,0(t0)   ; F3  = Matrix3D[0]
  lwc1 f4,4(t0)   ; F4  = Matrix3D[1]
  lwc1 f5,8(t0)   ; F5  = Matrix3D[2]
  lwc1 f6,12(t0)  ; F6  = Matrix3D[3]
  lwc1 f7,16(t0)  ; F7  = Matrix3D[4]
  lwc1 f8,20(t0)  ; F8  = Matrix3D[5]
  lwc1 f9,24(t0)  ; F9  = Matrix3D[6]
  lwc1 f10,28(t0) ; F10 = Matrix3D[7]
  lwc1 f11,32(t0) ; F11 = Matrix3D[8]
  lwc1 f12,36(t0) ; F12 = Matrix3D[9]
  lwc1 f13,40(t0) ; F13 = Matrix3D[10]
  lwc1 f14,44(t0) ; F14 = Matrix3D[11]

Loop:
  WaitScanline $200 ; Wait For Scanline To Reach Vertical Blank

  DPC RDPBuffer,RDPBufferEnd ; Run DPC Command Buffer: Start Address, End Address

  la t0,XRot ; T0 = X Rotation Data Offset

  lw t1,0(t0)  ; Load X Rotation Value
  add t1,1     ; X Rotation += 1
  andi t1,1023 ; X Rotation &= 1023
  sw t1,0(t0)  ; Store X Rotation Value

  lw t1,4(t0)  ; Load Y Rotation Value
  add t1,1     ; Y Rotation += 1
  andi t1,1023 ; Y Rotation &= 1023
  sw t1,4(t0)  ; Store Y Rotation Value

  lw t1,8(t0)  ; Load Z Rotation Value
  add t1,1     ; Z Rotation += 1
  andi t1,1023 ; Z Rotation &= 1023
  sw t1,8(t0)  ; Store Z Rotation Value

  ;XRotCalc XRot, SinCos1024 ; X Rotate Triangle
  ;YRotCalc YRot, SinCos1024 ; Y Rotate Triangle
  ;ZRotCalc ZRot, SinCos1024 ; Z Rotate Triangle
  ;XYRotCalc XRot, YRot, SinCos1024 ; XY Rotate Triangle
  ;XZRotCalc XRot, ZRot, SinCos1024 ; XZ Rotate Triangle
  ;YZRotCalc YRot, ZRot, SinCos1024 ; YZ Rotate Triangle
  XYZRotCalc XRot, YRot, ZRot, SinCos1024 ; XYZ Rotate Triangle

  la t0,TriObj ; T0 = 3D Triangle Object Data Offset
  la t1,TRI    ; T1 = 2D Triangle Data Offset
  LoadXYZ ; Load 3D Transformed Triangle Coordinate 0 To 2D Triangle Data Offset
  LoadXYZ ; Load 3D Transformed Triangle Coordinate 1 To 2D Triangle Data Offset
  LoadXYZ ; Load 3D Transformed Triangle Coordinate 2 To 2D Triangle Data Offset


  la t0,TRI ; T0 = Float Triangle Data Offset

  ; PASS1 Sort Coordinate 0 & 1
  lwc1 f15,4(t0)  ; F15 = Triangle Y0
  lwc1 f16,12(t0) ; F16 = Triangle Y1
  c.le.s f15,f16  ; IF (Y0 <= Y1) Swap Triangle Coordinates 0 & 1
  bc1f PASS101    ; ELSE No Swap
  nop ; Delay Slot
  lwc1 f17,0(t0)  ; F17 = X0
  lwc1 f18,8(t0)  ; F18 = X1
  swc1 f18,0(t0)  ; X0 = X1
  swc1 f16,4(t0)  ; Y0 = Y1
  swc1 f17,8(t0)  ; X1 = X0
  swc1 f15,12(t0) ; Y1 = Y0
  PASS101:

  ; PASS1 Sort Coordinate 1 & 2
  lwc1 f15,12(t0) ; F15 = Triangle Y1
  lwc1 f16,20(t0) ; F16 = Triangle Y2
  c.le.s f15,f16  ; IF (Y1 <= Y2) Swap Triangle Coordinates 1 & 2
  bc1f PASS112    ; ELSE No Swap
  nop ; Delay Slot
  lwc1 f17,8(t0)  ; F17 = X1
  lwc1 f18,16(t0) ; F18 = X2
  swc1 f18,8(t0)  ; X1 = X2
  swc1 f16,12(t0) ; Y1 = Y2
  swc1 f17,16(t0) ; X2 = X1
  swc1 f15,20(t0) ; Y2 = Y1
  PASS112:

  ; PASS1 Sort Coordinate 2 & 0
  lwc1 f15,4(t0)  ; F15 = Triangle Y0
  lwc1 f16,20(t0) ; F16 = Triangle Y2
  c.le.s f15,f16  ; IF (Y0 <= Y2) Swap Triangle Coordinates 0 & 2
  bc1f PASS120    ; ELSE No Swap
  nop ; Delay Slot
  lwc1 f17,0(t0)  ; F17 = X0
  lwc1 f18,16(t0) ; F18 = X2
  swc1 f18,0(t0)  ; X0 = X2
  swc1 f16,4(t0)  ; Y0 = Y2
  swc1 f17,16(t0) ; X2 = X0
  swc1 f15,20(t0) ; Y2 = Y0
  PASS120:

  ; PASS1 Sort Coordinate 0 & 1
  lwc1 f15,4(t0)  ; F15 = Triangle Y0
  lwc1 f16,12(t0) ; F16 = Triangle Y1
  c.le.s f15,f16  ; IF (Y0 <= Y1) Swap Triangle Coordinates 0 & 1
  bc1f PASS101B   ; ELSE No Swap
  nop ; Delay Slot
  lwc1 f17,0(t0)  ; F17 = X0
  lwc1 f18,8(t0)  ; F18 = X1
  swc1 f18,0(t0)  ; X0 = X1
  swc1 f16,4(t0)  ; Y0 = Y1
  swc1 f17,8(t0)  ; X1 = X0
  swc1 f15,12(t0) ; Y1 = Y0
  PASS101B:


  ; PASS2 Sort Coordinate 0 & 1
  lwc1 f15,4(t0)  ; F15 = Triangle Y0
  lwc1 f16,12(t0) ; F16 = Triangle Y1
  c.eq.s f15,f16  ; IF (Y0 == Y1) Swap Triangle Coordinates 0 & 1
  bc1f PASS201    ; ELSE No Swap
  nop ; Delay Slot
  lwc1 f17,0(t0)  ; F17 = Triangle X0
  lwc1 f18,8(t0)  ; F18 = Triangle X1
  c.le.s f18,f17  ; IF (X0 >= X1) Swap Triangle Coordinates 0 & 1
  bc1f PASS201    ; ELSE No Swap
  nop ; Delay Slot
  swc1 f18,0(t0)  ; X0 = X1
  swc1 f16,4(t0)  ; Y0 = Y1
  swc1 f17,8(t0)  ; X1 = X0
  swc1 f15,12(t0) ; Y1 = Y0
  PASS201:

  ; PASS2 Sort Coordinate 1 & 2
  lwc1 f15,12(t0) ; F15 = Triangle Y1
  lwc1 f16,20(t0) ; F16 = Triangle Y2
  c.eq.s f15,f16  ; IF (Y1 == Y2) Swap Triangle Coordinates 1 & 2
  bc1f PASS212    ; ELSE No Swap
  nop ; Delay Slot
  lwc1 f17,8(t0)  ; F17 = X1
  lwc1 f18,16(t0) ; F18 = X2
  c.le.s f17,f18  ; IF (X1 <= X2) Swap Triangle Coordinates 1 & 2
  bc1f PASS212    ; ELSE No Swap
  nop ; Delay Slot
  swc1 f18,8(t0)  ; X1 = X2
  swc1 f16,12(t0) ; Y1 = Y2
  swc1 f17,16(t0) ; X2 = X1
  swc1 f15,20(t0) ; Y2 = Y1
  PASS212:


  lwc1 f15,0(t0)  ; F15 = Triangle X0
  lwc1 f16,4(t0)  ; F16 = Triangle Y0 (YL)
  lwc1 f17,8(t0)  ; F17 = Triangle X1 (XL)
  lwc1 f18,12(t0) ; F18 = Triangle Y1 (YM)
  lwc1 f19,16(t0) ; F19 = Triangle X2 (XH/XM)
  lwc1 f20,20(t0) ; F20 = Triangle Y2 (YH)

  la t0,$A0000000|(FillTri&$3FFFFF) ; T0 = RDP Fill Triangle RAM Offset


  lui t1,$0800 ; T1 = Fill Triangle RDP Command (WORD 0)
  c.le.s f17,f15 ; IF (X1 <= X0) DIR = 0 (Left Major Triangle)
  bc1t DIR       ; ELSE DIR = 1 (Right Major Triangle)
  lui t2,$0000 ; T2 = DIR 0
  lui t2,$0080 ; T2 = DIR 1
  DIR:
  or t1,t2
  c.le.s f17,f19 ; IF (X1 <= X2) DIR = 0 (Left Major Triangle)
  bc1t DIRB      ; ELSE DIR = 1 (Right Major Triangle)
  lui t2,$0000 ; T2 = DIR 0
  lui t2,$0080 ; T2 = DIR 1
  DIRB:
  or t1,t2

  mul.s f21,f16,f1 ; Convert To S.11.2
  cvt.w.s f21 ; F21 = YL
  mfc1 t2,f21 ; T2 = YL
  andi t2,$3FFF ; T2 &= S.11.2
  or t1,t2
  sw t1,0(t0) ; Store RDP Command (WORD 0 HI)

  mul.s f21,f18,f1 ; Convert To S.11.2
  cvt.w.s f21 ; F21 = YM
  mfc1 t1,f21 ; T1 = YM
  andi t1,$3FFF ; T1 &= S.11.2
  dsll t1,16 ; T1 = YM

  mul.s f21,f20,f1 ; Convert To S.11.2
  cvt.w.s f21 ; F21 = YH
  mfc1 t2,f21 ; T2 = YH
  andi t2,$3FFF ; T2 &= S.11.2
  or t1,t2
  sw t1,4(t0) ; Store RDP Command (WORD 0 LO)


  mul.s f21,f17,f2 ; Convert To S.15.16
  cvt.w.s f21 ; F21 = XL
  mfc1 t1,f21 ; T1 = XL
  sw t1,8(t0) ; Store RDP Command (WORD 1 HI)

  sub.s f22,f16,f18
  c.eq.s f22,f0 ; IF ((Y0 - Y1) == 0) DxLDy = 0.0 
  bc1t DXLDY    ; ELSE DxLDy = (X0 - X1) / (Y0 - Y1)
  andi t1,0 ; T1 = DxLDy 0.0

  sub.s f21,f15,f17
  div.s f21,f22 ; F21 = DxLDy
  mul.s f21,f2  ; Convert To S.15.16
  cvt.w.s f21 ; F21 = DxLDy
  mfc1 t1,f21 ; T1 = DxLDy
  DXLDY:
  sw t1,12(t0) ; Store RDP Command (WORD 1 LO)


  mul.s f21,f19,f2 ; Convert To S.15.16
  cvt.w.s f21 ; F21 = XH
  mfc1 t1,f21 ; T1 = XH
  sw t1,16(t0) ; Store RDP Command (WORD 2 HI) 

  sub.s f22,f16,f20
  c.eq.s f22,f0 ; IF ((Y0 - Y2) == 0) DxHDy = 0.0 
  bc1t DXHDY    ; ELSE DxHDy = (X0 - X2) / (Y0 - Y2)
  andi t2,0 ; T2 = DxHDy 0.0

  sub.s f21,f15,f19
  div.s f21,f22 ; F21 = DxHDy
  mul.s f21,f2  ; Convert To S.15.16
  cvt.w.s f21 ; F21 = DxHDy
  mfc1 t2,f21 ; T2 = DxHDy
  DXHDY:
  sw t2,20(t0) ; Store RDP Command (WORD 2 LO)


  sw t1,24(t0) ; Store RDP Command (WORD 3 HI) T1 = XM (Uses Previous XH)

  sub.s f22,f18,f20
  c.eq.s f22,f0 ; IF ((Y1 - Y2) == 0) DxMDy = 0.0 
  bc1t DXMDY    ; ELSE DxMDy = (X1 - X2) / (Y1 - Y2)
  andi t1,0 ; T1 = DxMDy 0.0

  sub.s f21,f17,f19
  div.s f21,f22 ; F21 = DxMDy
  mul.s f21,f2  ; Convert To S.15.16
  cvt.w.s f21 ; F21 = DxMDy
  mfc1 t1,f21 ; T1 = DxMDy
  DXMDY:
  sw t1,28(t0) ; Store RDP Command (WORD 3 LO)

  j Loop
  nop ; Delay Slot

  align 8 ; Align 64-bit
RDPBuffer:
  Set_Scissor 0<<2,0<<2, 320<<2,240<<2, 0 ; Set Scissor: XH 0.0, YH 0.0, XL 320.0, YL 240.0, Scissor Field Enable Off
  Set_Other_Modes CYCLE_TYPE_FILL, 0 ; Set Other Modes
  Set_Color_Image SIZE_OF_PIXEL_16B|(320-1), $00100000 ; Set Color Image: SIZE 16B, WIDTH 320, DRAM ADDRESS $00100000
  Set_Fill_Color $FF01FF01 ; Set Fill Color: PACKED COLOR 16B R5G5B5A1 Pixels
  Fill_Rectangle 319<<2,239<<2, 0<<2,0<<2 ; Fill Rectangle: XL 319.0, YL 239.0, XH 0.0, YH 0.0

  Set_Other_Modes SAMPLE_TYPE|BI_LERP_0|ALPHA_DITHER_SEL_NO_DITHER, B_M1A_0_2 ; Set Other Modes
  Set_Combine_Mode $0, $00, 0, 0, $1, $01, $0, $F, 1, 0, 0, 0, 0, 7, 7, 7 ; Set Combine Mode: SubA RGB0, MulRGB0, SubA Alpha0, MulAlpha0, SubA RGB1, MulRGB1, SubB RGB0, SubB RGB1, SubA Alpha1, MulAlpha1, AddRGB0, SubB Alpha0, AddAlpha0, AddRGB1, SubB Alpha1, AddAlpha1

  Sync_Pipe ; Stall Pipeline, Until Preceeding Primitives Completely Finish
  Set_Blend_Color $FF0000FF ; Set Blend Color: R 255, G 0, B 0, A 255 (Red)
  FillTri:
    Fill_Triangle 0, 0, 0, 0,0,0, 0,0, 0,0, 0,0, 0,0, 0,0, 0,0 ; Dir, Level, Tile, YL, YM, YH, XL, DxLDy, XH, DxHDy, XM, DxMDy

  Sync_Full ; Ensure Entire Scene Is Fully Drawn
RDPBufferEnd:

MULT: ; Float Multipy Data
  IEEE32     0.0 ; (Divide By Zero Check)
  IEEE32     4.0 ; Multiply (Fixed Point S.11.2)
  IEEE32 65536.0 ; Multiply (Fixed Point S.15.16)

TRI: ; Float 2D Triangle Data
  IEEE32 0.0, 0.0 ; Triangle X0, Y0
  IEEE32 0.0, 0.0 ; Triangle X1, Y1
  IEEE32 0.0, 0.0 ; Triangle X2, Y2

Matrix3D: ; Float Matrix 3D Data
  ;        X,   Y,   Z,    T
  IEEE32 1.0, 0.0, 0.0,  0.0 ; X
  IEEE32 0.0, 1.0, 0.0,  0.0 ; Y
  IEEE32 0.0, 0.0, 1.0, 15.0 ; Z

XRot: dw 120 ; X Rotation Value (0..1023)
YRot: dw 360 ; Y Rotation Value (0..1023)
ZRot: dw 200 ; Z Rotation Value (0..1023)

; Setup 3D
HALF_SCREEN_X: IEEE32 160.0
HALF_SCREEN_Y: IEEE32 120.0
FOV:           IEEE32 160.0

  include objects.asm ; Object Data
  include sincos1024.asm ; Pre Calculated Matrix Sin Cos Rotation Values