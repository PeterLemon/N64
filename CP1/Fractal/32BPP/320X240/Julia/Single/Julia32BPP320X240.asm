; N64 'Bare Metal' CP1 32BPP 320x240 Julia Fractal Animation Demo by krom (Peter Lemon):
  include LIB\N64.INC ; Include N64 Definitions
  dcb 1052672,$00 ; Set ROM Size
  org $80000000 ; Entry Point Of Code
  include LIB\N64_HEADER.ASM  ; Include 64 Byte Header & Vector Table
  incbin LIB\N64_BOOTCODE.BIN ; Include 4032 Byte Boot Code

Start:
  include LIB\N64_GFX.INC ; Include Graphics Macros
  N64_INIT ; Run N64 Initialisation Routine

  ScreenNTSC 320, 240, BPP32, $A0100000 ; Screen NTSC: 320x240, 32BPP, DRAM Origin $A0100000

  la a0,DATA ; A0 = Double Data Offset
  lwc1 f0,0(a0) ; F0 = X%
  lwc1 f1,4(a0) ; F1 = Y%
  lwc1 f2,0(a0) ; F2 = SX
  lwc1 f3,4(a0) ; F3 = SY
  lwc1 f4,8(a0) ; F4 = XMax
  lwc1 f5,12(a0) ; F5 = YMax
  lwc1 f6,16(a0) ; F6 = XMin
  lwc1 f7,20(a0) ; F7 = YMin
  lwc1 f8,24(a0) ; F8 = RMax
  lwc1 f9,28(a0) ; F9 = 1.0
  lwc1 f16,32(a0) ; F16 = 0.0
  lwc1 f17,36(a0) ; F17 = ANIM

  sub.s f18,f4,f6 ; F18 = XMax - XMin
  sub.s f19,f5,f7 ; F19 = YMax - YMin
  div.s f20,f9,f2 ; F20 = (1.0 / SX)
  div.s f21,f9,f3 ; F21 = (1.0 / SY)

  mov.s f12,f9 ; F12 = CX (1.0)
  mov.s f13,f7 ; F13 = CY (-2.0)

  li t0,$231AF900 ; T0 = Multiply Colour

Refresh:
  lui a0,$A010 ; A0 = Frame Buffer Pointer
  li a1,($A0100000+(320*240*4)-4) ; A1 = Frame Buffer Pointer Last Pixel
  mov.s f1,f3 ; F1 = Y%
  LoopY:
    mov.s f0,f2 ; F0 = X%
    LoopX:
      mul.s f10,f0,f18 ; ZX = XMin + ((X% * (XMax - XMin)) * (1.0 / SX))
      mul.s f10,f20
      add.s f10,f6 ; F10 = ZX

      mul.s f11,f1,f19 ; ZY = YMin + ((Y% * (YMax - YMin)) * (1.0 / SY))
      mul.s f11,f21
      add.s f11,f7 ; F11 = ZY

      li t1,192 ; T1 = IT (Iterations)
      Iterate:
        mul.s f14,f10,f10 ; XN = ((ZX * ZX) - (ZY * ZY)) + CX
        mul.s f15,f11,f11
        sub.s f14,f15
        add.s f14,f12 ; F14 = XN

        mul.s f15,f10,f11 ; YN = (2 * ZX * ZY) + CY
        add.s f15,f15
        add.s f15,f13 ; F15 = YN

        mov.s f10,f14 ; Copy XN & YN To ZX & ZY For Next Iteration
        mov.s f11,f15

        mul.s f14,f10,f10 ; R = (XN * XN) + (YN * YN)
        mul.s f15,f11,f11
        add.s f14,f15 ; F14 = R

        c.le.s f14,f8 ; IF (R > 4) Plot
        bc1f Plot ; Branch On FP False
        nop ; Delay Slot

        bnez t1,Iterate ; IF (IT != 0) Iterate
        subi t1,1 ; IT = IT - 1

      Plot:
        mul t1,t1,t0 ; Set The Colour To RGBA 32 bit
        sw t1,0(a0) ; Store Pixel Colour To Frame Buffer (Top)
        sw t1,0(a1) ; Store Pixel Colour To Frame Buffer (Bottom)

        sub.s f0,f9 ; Decrement X%
        addi a0,4 ; Add 4 To RDRAM Offset (Top)
        c.eq.s f0,f16
        bc1f LoopX ; IF (X% != 0) LoopX
        subi a1,4 ; Sub 4 To RDRAM Offset (Bottom)

        blt a0,a1,LoopY ; IF (Y% != 0) LoopY
        sub.s f1,f9 ; Decrement Y%

      sub.s f12,f17 ; Change Julia Settings
	add.s f13,f17
      j Refresh
      nop ; Delay Slot

  align 8 ; Align 64-Bit
DATA:
  IEEE32 320.0 ; SCREEN X
  IEEE32 240.0 ; SCREEN Y
  IEEE32   3.0 ; XMAX
  IEEE32   2.0 ; YMAX
  IEEE32  -3.0 ; XMIN
  IEEE32  -2.0 ; YMIN
  IEEE32   4.0 ; RMAX
  IEEE32   1.0 ; ONE
  IEEE32   0.0 ; ZERO
  IEEE32   0.001 ; ANIM