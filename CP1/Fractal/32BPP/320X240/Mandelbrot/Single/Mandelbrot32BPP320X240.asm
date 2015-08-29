// N64 'Bare Metal' CP1 32BPP 320x240 Mandelbrot Fractal Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "Mandelbrot32BPP320X240.N64", create
fill 1052672 // Set ROM Size

origin $00000000
base $80000000 // Entry Point Of Code
include "LIB\N64.INC" // Include N64 Definitions
include "LIB\N64_HEADER.ASM" // Include 64 Byte Header & Vector Table
insert "LIB\N64_BOOTCODE.BIN" // Include 4032 Byte Boot Code

Start:
  include "LIB\N64_GFX.INC" // Include Graphics Macros
  N64_INIT() // Run N64 Initialisation Routine

  ScreenNTSC(320, 240, BPP32, $A0100000) // Screen NTSC: 320x240, 32BPP, DRAM Origin $A0100000

  la a0,DATA // A0 = Double Data Offset
  lwc1 f0,0(a0) // F0 = X%
  lwc1 f1,4(a0) // F1 = Y%
  lwc1 f2,0(a0) // F2 = SX
  lwc1 f3,4(a0) // F3 = SY
  lwc1 f4,8(a0) // F4 = XMax
  lwc1 f5,12(a0) // F5 = YMax
  lwc1 f6,16(a0) // F6 = XMin
  lwc1 f7,20(a0) // F7 = YMin
  lwc1 f8,24(a0) // F8 = RMax
  lwc1 f9,28(a0) // F9 = 1.0
  lwc1 f16,32(a0) // F16 = 0.0

  sub.s f17,f4,f6 // F17 = XMax - XMin
  sub.s f18,f5,f7 // F18 = YMax - YMin
  div.s f19,f9,f2 // F19 = (1.0 / SX)
  div.s f20,f9,f3 // F20 = (1.0 / SY)

  li a0,$A0100000+((320*240*4)-4) // A0 = Frame Buffer Pointer Last Pixel
  li t0,$231AF900 // T0 = Multiply Colour

LoopY:
  mov.s f0,f2 // F0 = X%
  LoopX: 
    mul.s f10,f0,f17 // CX = XMin + ((X% * (XMax - XMin)) * (1.0 / SX))
    mul.s f10,f19
    add.s f10,f6 // F10 = CX

    mul.s f11,f1,f18 // CY = YMin + ((Y% * (YMax - YMin)) * (1.0 / SY))
    mul.s f11,f20
    add.s f11,f7 // F11 = CY

    lli t1,192 // T1 = IT (Iterations)
    sub.s f12,f12 // F12 = ZX
    sub.s f13,f13 // F13 = ZY

    Iterate:
      mul.s f14,f12,f12 // XN = ((ZX * ZX) - (ZY * ZY)) + CX
      mul.s f15,f13,f13
      sub.s f14,f15
      add.s f14,f10 // F14 = XN

      mul.s f15,f12,f13 // YN = (2 * ZX * ZY) + CY
      add.s f15,f15
      add.s f15,f11 // F15 = YN

      mov.s f12,f14 // Copy XN & YN To ZX & ZY For Next Iteration
      mov.s f13,f15

      mul.s f14,f12,f12 // R = (XN * XN) + (YN * YN)
      mul.s f15,f13,f13
      add.s f14,f15 // F14 = R

      c.le.s f14,f8 // IF (R > 4) Plot
      bc1f Plot // Branch On FP False
      nop // Delay Slot

      bnez t1,Iterate // IF (IT != 0) Iterate
      subi t1,1 // IT = IT - 1

    Plot:
      mul t1,t0 // Set The Colour To RGBA 32 bit
      sw t1,0(a0) // Store Pixel Colour To Frame Buffer

      sub.s f0,f9 // Decrement X%
      c.eq.s f0,f16
      bc1f LoopX // IF (X% != 0) LoopX
      subi a0,4 // Sub 4 To RDRAM Offset

      sub.s f1,f9 // Decrement Y%
      c.eq.s f1,f16
      bc1f LoopY // IF (Y% != 0) LoopY
      nop // Delay Slot

Loop:
  j Loop
  nop // Delay Slot

align(8) // Align 64-Bit
DATA:
  float32 320.0 // SCREEN X
  float32 240.0 // SCREEN Y
  float32   1.0 // XMAX
  float32   1.0 // YMAX
  float32  -2.0 // XMIN
  float32  -1.0 // YMIN
  float32   4.0 // RMAX
  float32   1.0 // ONE
  float32   0.0 // ZERO