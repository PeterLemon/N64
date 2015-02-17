; N64 'Bare Metal' CP1 32BPP 320x240 Julia Fractal Input Demo by krom (Peter Lemon):
; A = Zoom In
; B = Zoom Out
; R = Iteration Up
; L = Iteration Down
; DPad = X/Y Translation
; Analog = CX/CY Julia Settings
; Start = Reset All Settings

  include LIB\N64.INC ; Include N64 Definitions
  dcb 1052672,$00 ; Set ROM Size
  org $80000000 ; Entry Point Of Code
  include LIB\N64_HEADER.ASM  ; Include 64 Byte Header & Vector Table
  incbin LIB\N64_BOOTCODE.BIN ; Include 4032 Byte Boot Code

Start:
  include LIB\N64_GFX.INC ; Include Graphics Macros
  include LIB\N64_INPUT.INC ; Include Input Macros
  N64_INIT ; Run N64 Initialisation Routine

  ScreenNTSC 320, 240, BPP32, $A0100000 ; Screen NTSC: 320x240, 32BPP, DRAM Origin $A0100000

  la a0,DATA ; A0 = Double Data Offset
  ldc1 f0,0(a0) ; F0 = X%
  ldc1 f1,8(a0) ; F1 = Y%
  ldc1 f2,0(a0) ; F2 = SX
  ldc1 f3,8(a0) ; F3 = SY
  ldc1 f4,16(a0) ; F4 = XMax
  ldc1 f5,24(a0) ; F5 = YMax
  ldc1 f6,32(a0) ; F6 = XMin
  ldc1 f7,40(a0) ; F7 = YMin
  ldc1 f8,48(a0) ; F8 = RMax
  ldc1 f9,56(a0) ; F9 = 1.0
  ldc1 f16,64(a0) ; F16 = 0.0
  ldc1 f17,72(a0) ; F17 = X/Y TRANSLATE/ZOOM ANIM
  ldc1 f18,80(a0) ; F18 = CX/CY ANIM

  div.d f21,f9,f2 ; F21 = (1.0 / SX)
  div.d f22,f9,f3 ; F22 = (1.0 / SY)

  mov.d f12,f16 ; F12 = CX (0.0)
  mov.d f13,f16 ; F13 = CY (0.0)

  li t8,25 ; T8 = Iterations
  li t9,$231AF900 ; T9 = Multiply Colour

  InitController PIF1 ; Initialize Controller

Refresh:
  ReadController PIF2 ; T0 = Controller Buttons, T1 = Analog X, T2 = Analog Y

  sub.d f19,f4,f6 ; F19 = (XMAX - XMIN) / SX
  div.d f19,f2
  mul.d f19,f17

  andi t3,t0,JOY_START ; Test JOY START
  beqz t3,Iteration_Up
  nop ; Delay Slot
  la a0,DATA ; A0 = Double Data Offset
  ldc1 f4,16(a0) ; F4 = XMax
  ldc1 f5,24(a0) ; F5 = YMax
  ldc1 f6,32(a0) ; F6 = XMin
  ldc1 f7,40(a0) ; F7 = YMin

  mov.d f12,f16 ; F12 = CX (0.0)
  mov.d f13,f16 ; F13 = CY (0.0)

  li t8,25 ; T8 = Iterations

Iteration_Up:
  andi t3,t0,JOY_R ; Test JOY R
  beqz t3,Iteration_Down
  nop ; Delay Slot
  addi t8,1
  andi t8,$FF

Iteration_Down:
  andi t3,t0,JOY_L ; Test JOY L
  beqz t3,Up
  nop ; Delay Slot
  subi t8,1
  andi t8,$FF

Up:
  andi t3,t0,JOY_UP ; Test JOY UP
  beqz t3,Down
  nop ; Delay Slot
  add.d f5,f19
  add.d f7,f19

Down:
  andi t3,t0,JOY_DOWN ; Test JOY DOWN
  beqz t3,Left
  nop ; Delay Slot
  sub.d f5,f19
  sub.d f7,f19

Left:
  andi t3,t0,JOY_LEFT ; Test JOY LEFT
  beqz t3,Right
  nop ; Delay Slot
  add.d f4,f19
  add.d f6,f19

Right:
  andi t3,t0,JOY_RIGHT ; Test JOY RIGHT
  beqz t3,Zoom_In
  nop ; Delay Slot
  sub.d f4,f19
  sub.d f6,f19

Zoom_In:
  andi t3,t0,JOY_A ; Test JOY A
  beqz t3,Zoom_Out
  nop ; Delay Slot
  sub.d f4,f19
  add.d f6,f19
  sub.d f5,f19
  add.d f7,f19

Zoom_Out:
  andi t3,t0,JOY_B ; Test JOY B
  beqz t3,Analog
  nop ; Delay Slot
  add.d f4,f19
  sub.d f6,f19
  add.d f5,f19
  sub.d f7,f19

Analog:
  li t3,$FFFFFFF0
  and t1,t3 ; X Dead Zone
  and t2,t3 ; Y Dead Zone

  mtc1 t1,f20
  cvt.d.w f20
  mul.d f20,f19
  mul.d f20,f18
  add.d f12,f20

  mtc1 t2,f20
  cvt.d.w f20
  mul.d f20,f19
  mul.d f20,f18
  add.d f13,f20

  sub.d f19,f4,f6 ; F19 = XMax - XMin
  sub.d f20,f5,f7 ; F20 = YMax - YMin

  li a0,($A0100000+(320*240*4)-4) ; A0 = Frame Buffer Pointer Last Pixel
  mov.d f1,f3 ; F1 = Y%
  LoopY:
    mov.d f0,f2 ; F0 = X%
    LoopX:
      mul.d f10,f0,f19 ; ZX = XMin + ((X% * (XMax - XMin)) * (1.0 / SX))
      mul.d f10,f21
      add.d f10,f6 ; F10 = ZX

      mul.d f11,f1,f20 ; ZY = YMin + ((Y% * (YMax - YMin)) * (1.0 / SY))
      mul.d f11,f22
      add.d f11,f7 ; F11 = ZY

      move t1,t8 ; T1 = IT (Iterations)
      Iterate:
        mul.d f14,f10,f10 ; XN = ((ZX * ZX) - (ZY * ZY)) + CX
        mul.d f15,f11,f11
        sub.d f14,f15
        add.d f14,f12 ; F14 = XN

        mul.d f15,f10,f11 ; YN = (2 * ZX * ZY) + CY
        add.d f15,f15
        add.d f15,f13 ; F15 = YN

        mov.d f10,f14 ; Copy XN & YN To ZX & ZY For Next Iteration
        mov.d f11,f15

        mul.d f14,f10,f10 ; R = (XN * XN) + (YN * YN)
        mul.d f15,f11,f11
        add.d f14,f15 ; F14 = R

        c.le.d f14,f8 ; IF (R > 4) Plot
        bc1f Plot ; Branch On FP False
        nop ; Delay Slot

        bnez t1,Iterate ; IF (IT != 0) Iterate
        subi t1,1 ; IT = IT - 1

      Plot:
        mul t1,t1,t9 ; Set The Colour To RGBA 32 bit
        sw t1,0(a0) ; Store Pixel Colour To Frame Buffer

        sub.d f0,f9 ; Decrement X%
        c.eq.d f0,f16
        bc1f LoopX ; IF (X% != 0) LoopX
        subi a0,4 ; Sub 4 To RDRAM Offset

        sub.d f1,f9 ; Decrement Y%
        c.eq.d f1,f16
        bc1f LoopY ; IF (Y% != 0) LoopY
        nop ; Delay Slot

      j Refresh
      nop ; Delay Slot

  align 8 ; Align 64-Bit
DATA:
  IEEE64 320.0 ; SCREEN X
  IEEE64 240.0 ; SCREEN Y
  IEEE64   2.0 ; XMAX
  IEEE64   2.0 ; YMAX
  IEEE64  -2.0 ; XMIN
  IEEE64  -2.0 ; YMIN
  IEEE64   4.0 ; RMAX
  IEEE64   1.0 ; ONE
  IEEE64   0.0 ; ZERO
  IEEE64  10.0 ; X/Y TRANSLATE/ZOOM ANIM
  IEEE64   0.01 ; CX/CY ANIM

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
  dcb 64,0 ; Generate 64 Bytes Containing $00