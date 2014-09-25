; N64 'Bare Metal' 32BPP 320x240 Cube Fill Triangle RDP Demo by krom (Peter Lemon):

  include LIB\N64.INC ; Include N64 Definitions
  dcb 2097152,$00 ; Set ROM Size
  org $80000000 ; Entry Point Of Code
  include LIB\N64_HEADER.ASM  ; Include 64 Byte Header & Vector Table
  incbin LIB\N64_BOOTCODE.BIN ; Include 4032 Byte Boot Code

Start:
  include LIB\N64_INIT.ASM ; Include Initialisation Routine
  include LIB\N64_GFX.INC  ; Include Graphics Macros
  include LIB\N64_3DCP1.INC ; Include 3D CP1 Macros

  ScreenNTSC 320,240, BPP32, $A0100000 ; Screen NTSC: 320x240, 32BPP, DRAM Origin $A0100000

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
  WaitScanline $1E0 ; Wait For Scanline To Reach Vertical Blank
  la t2,$A0000000|(RDPTri&$3FFFFF) ; T2 = RDP Triangle Buffer Offset

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

  ;XRotCalc XRot, SinCos1024 ; X Rotate
  ;YRotCalc YRot, SinCos1024 ; Y Rotate
  ;ZRotCalc ZRot, SinCos1024 ; Z Rotate
  ;XYRotCalc XRot, YRot, SinCos1024 ; XY Rotate
  ;XZRotCalc XRot, ZRot, SinCos1024 ; XZ Rotate
  ;YZRotCalc YRot, ZRot, SinCos1024 ; YZ Rotate
  XYZRotCalc XRot, YRot, ZRot, SinCos1024 ; XYZ Rotate

  XYZPos CubeAPos ; Translate Cube A
  FillTriLeft CubeTri, CubeTriEnd  ; Load Object, Fill Triangle, Left Major: Start Address, End Address

  XYZPos CubeBPos ; Translate Cube B
  FillTriLeftCullBack CubeTri, CubeTriEnd  ; Load Object, Fill Triangle, Left Major, Back Face Culling: Start Address, End Address

  XYZPos CubeCPos ; Translate Cube C
  FillTriLeftCullFront CubeTri, CubeTriEnd ; Load Object, Fill Triangle, Left Major, Front Face Culling: Start Address, End Address

  XYZPos CubeDPos ; Translate Cube D
  FillTriRight CubeTri, CubeTriEnd  ; Load Object, Fill Triangle, Right Major: Start Address, End Address

  XYZPos CubeEPos ; Translate Cube E
  FillTriRightCullBack CubeTri, CubeTriEnd  ; Load Object, Fill Triangle, Right Major, Back Face Culling: Start Address, End Address

  XYZPos CubeFPos ; Translate Cube F
  FillTriRightCullFront CubeTri, CubeTriEnd ; Load Object, Fill Triangle, Right Major, Front Face Culling: Start Address, End Address

  ; Run Generated RDP Command List
  lui t0,DPC_BASE ; Reality Display Processer Control Interface
  la t1,$A0000000|(RDPBuffer&$3FFFFF) ; Set DPC Command Start Address
  sw t1,DPC_START(t0) ; Store DPC Command Start Address To DP Start Reg
  sw t2,DPC_END(t0) ; Store DPC Command End Address To DP End Reg

  j Loop
  nop ; Delay Slot

  align 4 ; Align 32-bit
MULT: ; Float Multipy Data
  IEEE32     0.0 ; (Divide By Zero Check)
  IEEE32     4.0 ; Multiply (Fixed Point S.11.2)
  IEEE32 65536.0 ; Multiply (Fixed Point S.15.16)

TRI: ; Float 2D Triangle Data
  IEEE32 0.0, 0.0 ; Triangle X0, Y0
  IEEE32 0.0, 0.0 ; Triangle X1, Y1
  IEEE32 0.0, 0.0 ; Triangle X2, Y2

Matrix3D: ; Float Matrix 3D Data
  ;        X,   Y,   Z,   T
  IEEE32 1.0, 0.0, 0.0, 0.0 ; X
  IEEE32 0.0, 1.0, 0.0, 0.0 ; Y
  IEEE32 0.0, 0.0, 1.0, 0.0 ; Z

XRot: dw 0 ; X Rotation Value (0..1023)
YRot: dw 0 ; Y Rotation Value (0..1023)
ZRot: dw 0 ; Z Rotation Value (0..1023)

; Setup 3D
HALF_SCREEN_X: IEEE32 160.0
HALF_SCREEN_Y: IEEE32 120.0
FOV:           IEEE32 160.0

  include objects.asm ; Object Data
  include scene.asm ; Scene Data
  include sincos1024.asm ; Pre Calculated Matrix Sin Cos Rotation Values

  align 8 ; Align 64-bit
RDPBuffer:
  Set_Scissor 0<<2,0<<2, 320<<2,240<<2, 0 ; Set Scissor: XH 0.0, YH 0.0, XL 320.0, YL 240.0, Scissor Field Enable Off
  Set_Other_Modes CYCLE_TYPE_FILL, 0 ; Set Other Modes
  Set_Color_Image SIZE_OF_PIXEL_32B|(320-1), $00100000 ; Set Color Image: SIZE 32B, WIDTH 320, DRAM ADDRESS $00100000
  Set_Fill_Color $FFFF00FF ; Set Fill Color: PACKED COLOR 32B R8G8B8A8 Pixel
  Fill_Rectangle 319<<2,239<<2, 0<<2,0<<2 ; Fill Rectangle: XL 319.0, YL 239.0, XH 0.0, YH 0.0

  Set_Other_Modes SAMPLE_TYPE|BI_LERP_0|ALPHA_DITHER_SEL_NO_DITHER, B_M1A_0_2 ; Set Other Modes
  Set_Combine_Mode $0, $00, 0, 0, $1, $01, $0, $F, 1, 0, 0, 0, 0, 7, 7, 7 ; Set Combine Mode: SubA RGB0, MulRGB0, SubA Alpha0, MulAlpha0, SubA RGB1, MulRGB1, SubB RGB0, SubB RGB1, SubA Alpha1, MulAlpha1, AddRGB0, SubB Alpha0, AddAlpha0, AddRGB1, SubB Alpha1, AddAlpha1

  RDPTri: ; RDP Triangle Buffer