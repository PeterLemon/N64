// N64 'Bare Metal' CP1 32BPP 640x480 Mandelbrot Fractal Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "Mandelbrot32BPP640X480.N64", create
fill 1052672 // Set ROM Size

origin $00000000
base $80000000 // Entry Point Of Code
include "LIB/N64.INC" // Include N64 Definitions
include "LIB/N64_HEADER.ASM" // Include 64 Byte Header & Vector Table
insert "LIB/N64_BOOTCODE.BIN" // Include 4032 Byte Boot Code

Start:
  include "LIB/N64_GFX.INC" // Include Graphics Macros
  N64_INIT() // Run N64 Initialisation Routine

  ScreenNTSC(640, 480, BPP32|INTERLACE|AA_MODE_2, $A0100000) // Screen NTSC: 640x480, 32BPP, Interlace, Resample Only, DRAM Origin $A0100000

  la a0,DATA // A0 = Double Data Offset
  ldc1 f0,0(a0) // F0 = X%
  ldc1 f1,8(a0) // F1 = Y%
  ldc1 f2,0(a0) // F2 = SX
  ldc1 f3,8(a0) // F3 = SY
  ldc1 f4,16(a0) // F4 = XMax
  ldc1 f5,24(a0) // F5 = YMax
  ldc1 f6,32(a0) // F6 = XMin
  ldc1 f7,40(a0) // F7 = YMin
  ldc1 f8,48(a0) // F8 = RMax
  ldc1 f9,56(a0) // F9 = 1.0
  ldc1 f16,64(a0) // F16 = 0.0

  sub.d f17,f4,f6 // F17 = XMax - XMin
  sub.d f18,f5,f7 // F18 = YMax - YMin
  div.d f19,f9,f2 // F19 = (1.0 / SX)
  div.d f20,f9,f3 // F20 = (1.0 / SY)

  li a0,$A0100000+((640*480*4)-4) // A0 = Frame Buffer Pointer Last Pixel
  li t0,$231AF900 // T0 = Multiply Colour

LoopY:
  mov.d f0,f2 // F0 = X%
  LoopX:
    mul.d f10,f0,f17 // CX = XMin + ((X% * (XMax - XMin)) * (1.0 / SX))
    mul.d f10,f19
    add.d f10,f6 // F10 = CX

    mul.d f11,f1,f18 // CY = YMin + ((Y% * (YMax - YMin)) * (1.0 / SY))
    mul.d f11,f20
    add.d f11,f7 // F11 = CY

    lli t1,192 // T1 = IT (Iterations)
    sub.d f12,f12 // F12 = ZX
    sub.d f13,f13 // F13 = ZY

    Iterate:
      mul.d f14,f12,f12 // XN = ((ZX * ZX) - (ZY * ZY)) + CX
      mul.d f15,f13,f13
      sub.d f14,f15
      add.d f14,f10 // F14 = XN

      mul.d f15,f12,f13 // YN = (2 * ZX * ZY) + CY
      add.d f15,f15
      add.d f15,f11 // F15 = YN

      mov.d f12,f14 // Copy XN & YN To ZX & ZY For Next Iteration
      mov.d f13,f15

      mul.d f14,f12,f12 // R = (XN * XN) + (YN * YN)
      mul.d f15,f13,f13
      add.d f14,f15 // F14 = R

      c.le.d f14,f8 // IF (R > 4) Plot
      bc1f Plot // Branch On FP False
      nop // Delay Slot

      bnez t1,Iterate // IF (IT != 0) Iterate
      subi t1,1 // IT = IT - 1

    Plot:
      mul t1,t0 // Set The Colour To RGBA 32 bit
      sw t1,0(a0) // Store Pixel Colour To Frame Buffer

      sub.d f0,f9 // Decrement X%
      c.eq.d f0,f16
      bc1f LoopX // IF (X% != 0) LoopX
      subi a0,4 // Sub 4 To RDRAM Offset

      sub.d f1,f9 // Decrement Y%
      c.eq.d f1,f16
      bc1f LoopY // IF (Y% != 0) LoopY
      nop // Delay Slot

Loop:
  j Loop
  nop // Delay Slot

align(8) // Align 64-Bit
DATA:
  float64 640.0 // SCREEN X
  float64 480.0 // SCREEN Y
  float64   1.0 // XMAX
  float64   1.0 // YMAX
  float64  -2.0 // XMIN
  float64  -1.0 // YMIN
  float64   4.0 // RMAX
  float64   1.0 // ONE
  float64   0.0 // ZERO