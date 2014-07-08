; N64 'Bare Metal' CP1 32BPP 640x480 Julia Fractal Animation Demo by krom (Peter Lemon):

  include LIB\N64.INC ; Include N64 Definitions
  dcb 2097152,$00 ; Set ROM Size
  org $80000000 ; Entry Point Of Code
  include LIB\N64_HEADER.ASM  ; Include 64 Byte Header & Vector Table
  incbin LIB\N64_BOOTCODE.BIN ; Include 4032 Byte Boot Code

Start:
  include LIB\N64_INIT.ASM ; Include Initialisation Routine
  include LIB\N64_GFX.INC  ; Include Graphics Macros

  ScreenNTSC 640,480, BPP32|INTERLACE|AA_MODE_2, $A0100000 ; Screen NTSC: 640x480, 32BPP, DRAM Origin $A0100000

  la t1,DATA ; Load Double Data Offset
  ldc1 f0,0(t1) ; F0 = X%
  ldc1 f2,0(t1) ; F2 = SX
  ldc1 f1,8(t1) ; F1 = Y%
  ldc1 f3,8(t1) ; F3 = SY
  ldc1 f4,16(t1) ; F4 = XMax
  ldc1 f5,24(t1) ; F5 = YMax
  ldc1 f6,32(t1) ; F6 = XMin
  ldc1 f7,40(t1) ; F7 = YMin
  ldc1 f8,48(t1) ; F8 = RMax
  ldc1 f9,56(t1) ; F9 = 1.0
  ldc1 f16,64(t1) ; F16 = 0.0
  ldc1 f17,72(t1) ; F17 = ANIM

  mov.d f12,f9 ; F12 = CX (1.0)
  mov.d f13,f7 ; F13 = CY (-2.0)

  li t7,$231AF900 ; T7 = Multiply Colour

Refresh:
  lui t0,$A010    ; T0 = Frame Buffer Pointer
  li t2,($A0100000+(640*480*4)-4) ; T2 = Frame Buffer Pointer Last Pixel
  mov.d f1,f3 ; F1 = Y%
  LoopY:
    mov.d f0,f2 ; F0 = X%
    LoopX:
      sub.d f10,f4,f6 ; ZX = XMin + ((X% * (XMax - XMin)) / SX)
      mul.d f10,f0
      div.d f10,f2
      add.d f10,f6 ; F10 = ZX

      sub.d f11,f5,f7 ; ZY = YMin + ((Y% * (YMax - YMin)) / SY)
      mul.d f11,f1
      div.d f11,f3
      add.d f11,f7 ; F11 = ZY

      li t1,192 ; T1 = IT (Iterations)
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

        c.le.d f14,f8 ; IF R > 4 THEN GOTO Plot
        bc1f Plot ; Branch On FP False
        nop ; Delay Slot

        bnez t1,Iterate ; IF IT != 0 THEN GOTO Iterate
        sub t1,t1,1 ; IT = IT - 1

      Plot:
        mul t1,t1,t7 ; Set The Colour To RGBA 32 bit
        sw t1,0(t0) ; Store Pixel Colour To Frame Buffer (Top)
        sw t1,0(t2) ; Store Pixel Colour To Frame Buffer (Bottom)

        sub.d f0,f9 ; Decrement X%
        add t0,t0,4 ; Add 4 To RDRAM Offset (Top)
        c.eq.d f0,f16
        bc1f LoopX ; IF X% != 0 LoopX
        sub t2,t2,4 ; Sub 4 To RDRAM Offset (Bottom)

        sub.d f1,f9 ; Decrement Y%
        blt t0,t2,LoopY ; IF Y% != 0 LoopY
        nop ; Delay Slot

       sub.d f12,f17 ; Change Julia Settings
	 add.d f13,f17
       j Refresh
       nop ; Delay Slot

  align 8 ; Align 64-bit
DATA:
  IEEE64 640.0 ; SCREEN X
  IEEE64 480.0 ; SCREEN Y
  IEEE64   3.0 ; XMAX
  IEEE64   2.0 ; YMAX
  IEEE64  -3.0 ; XMIN
  IEEE64  -2.0 ; YMIN
  IEEE64   4.0 ; RMAX
  IEEE64   1.0 ; ONE
  IEEE64   0.0 ; ZERO
  IEEE64   0.001 ; ANIM