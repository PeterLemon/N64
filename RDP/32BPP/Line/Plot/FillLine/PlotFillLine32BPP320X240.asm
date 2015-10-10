// N64 'Bare Metal' 32BPP 320x240 Plot Line RDP Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "PlotFillLine32BPP320X240.N64", create
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

  la a0,MULT // A0 = Float Multipy Data Offset
  lwc1 f0,0(a0) // F0 = 0.0 (Divide By Zero Check)
  lwc1 f1,4(a0) // F1 = 4.0 (Fixed Point S.11.2)
  lwc1 f2,8(a0) // F2 = 65536.0 (Fixed Point S.15.16)
  lwc1 f3,12(a0) // F3 = 1.0 (Float Increment)

Loop:
  WaitScanline($200) // Wait For Scanline To Reach Vertical Blank

  DPC(RDPBuffer, RDPBufferEnd) // Run DPC Command Buffer: Start Address, End Address

  la a0,LINE // A0 = Float Line Data Offset


  // PASS1 Sort Y Coordinate 0 & 1
  lwc1 f4,4(a0)  // F4 = Line Y0
  lwc1 f5,12(a0) // F5 = Line Y1
  c.lt.s f4,f5  // IF (Y0 < Y1) Swap Line Coordinates 0 & 1
  bc1f PASS1End // ELSE No Swap
  nop // Delay Slot
  lwc1 f6,0(a0)  // F6 = X0
  lwc1 f7,8(a0)  // F7 = X1
  swc1 f7,0(a0)  // X0 = X1
  swc1 f5,4(a0)  // Y0 = Y1
  swc1 f6,8(a0)  // X1 = X0
  swc1 f4,12(a0) // Y1 = Y0
  PASS1End:

  // PASS2 Sort X Coordinate 0 & 1
  lwc1 f4,4(a0)  // F4 = Line Y0
  lwc1 f5,12(a0) // F5 = Line Y1
  c.eq.s f4,f5  // IF (Y0 == Y1) Swap Line Coordinates 0 & 1
  bc1f PASS2End // ELSE No Swap
  nop // Delay Slot
  lwc1 f6,0(a0) // F6 = X0
  lwc1 f7,8(a0) // F7 = X1
  c.lt.s f6,f7 // IF (X0 < X1) Swap Line Coordinates 0 & 1
  bc1f PASS2End // ELSE No Swap
  nop // Delay Slot
  swc1 f7,0(a0)  // X0 = X1
  swc1 f5,4(a0)  // Y0 = Y1
  swc1 f6,8(a0)  // X1 = X0
  swc1 f4,12(a0) // Y1 = Y0
  PASS2End:


  lwc1 f4,0(a0)  // F4 = Line X0 (XL)
  lwc1 f5,4(a0)  // F5 = Line Y0 (YL)
  lwc1 f6,8(a0)  // F6 = Line X1 (XH)
  lwc1 f7,12(a0) // F7 = Line Y1 (YH)
  mov.s f8,f0 // F8 = 0.0 (DxDy)


  la a0,$A0000000|(FillLine&$3FFFFF) // A0 = Fill Line RAM Offset


  Vertical:
  c.eq.s f4,f6 // IF (XL == XH) // Vertical Line (|)
  bc1f Horizontal
  nop // Delay Slot
  add.s f4,f3 // XL += 1
  j StoreRDP
  nop // Delay Slot

  Horizontal:
  c.eq.s f5,f7 // IF (YL == YH) // Horizontal Line (-)
  bc1f DxDyCalc
  nop // Delay Slot
  add.s f5,f3 // YL += 1
  j StoreRDP
  nop // Delay Slot

  DxDyCalc:
  sub.s f8,f4,f6 // DxDy = (XL - XH) / (YL - YH)
  sub.s f9,f5,f7
  div.s f8,f9 // F8 = DxDy
  abs.s f9,f8 // F9 = abs(DxDy)

  c.lt.s f9,f3 // IF abs(DxDy) < 1 (Lines With X Distance < 1)
  bc1f LeftRight
  nop // Delay Slot
  add.s f4,f6,f3 // XL = XH + 1
  j StoreRDP
  nop // Delay Slot

  LeftRight:
  add.s f4,f6,f9 // ELSE XL = XH + abs(DxDy)


  StoreRDP:
  mul.s f9,f5,f1 // Convert To S.11.2
  cvt.w.s f9 // F9 = YL
  mfc1 t0,f9 // T0 = YL
  andi t0,$3FFF // T0 &= S.11.2
  sh t0,2(a0) // Store RDP Command (WORD 0 HI)

  mul.s f9,f7,f1 // Convert To S.11.2
  cvt.w.s f9 // F9 = YM
  mfc1 t0,f9 // T0 = YM
  andi t0,$3FFF // T0 &= S.11.2
  dsll t1,t0,16 // T1 = YM
  or t0,t1 // T0 = YM,YH
  sw t0,4(a0) // Store RDP Command (WORD 0 LO)

  mul.s f9,f4,f2 // Convert To S.15.16
  cvt.w.s f9 // F9 = XL
  mfc1 t0,f9 // T0 = XL
  sw t0,8(a0) // Store RDP Command (WORD 1 HI)

  mul.s f9,f8,f2 // Convert To S.15.16
  cvt.w.s f9 // F9 = DxDy
  mfc1 t0,f9 // T0 = DxDy
  sw t0,12(a0) // Store RDP Command (WORD 1 LO)
  sw t0,20(a0) // Store RDP Command (WORD 2 LO)

  mul.s f9,f6,f2 // Convert To S.15.16
  cvt.w.s f9 // F9 = XH
  mfc1 t0,f9 // T0 = XH
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
  float32     0.0 // Multiply (Divide By Zero Check)
  float32     4.0 // Multiply (Fixed Point S.11.2)
  float32 65536.0 // Multiply (Fixed Point S.15.16)
  float32     1.0 // Increment Float

LINE: // Float 2D Line Data
//float32  75.0,  50.0 // Line X0, Y0
//float32  25.0, 100.0 // Line X1, Y1

//float32 100.0,  50.0 // Line X0, Y0
//float32 150.0, 100.0 // Line X1, Y1

//float32 175.0,  50.0 // Line X0, Y0
//float32 175.0, 100.0 // Line X1, Y1

//float32 250.0, 100.0 // Line X0, Y0
//float32 300.0, 100.0 // Line X1, Y1

//float32  25.0, 150.0 // Line X0, Y0
//float32  75.0, 175.0 // Line X1, Y1

//float32 150.0, 150.0 // Line X0, Y0
//float32 125.0, 200.0 // Line X1, Y1

//float32 225.0, 150.0 // Line X0, Y0
//float32 175.0, 175.0 // Line X1, Y1

float32 275.0, 150.0 // Line X0, Y0
float32 300.0, 200.0 // Line X1, Y1