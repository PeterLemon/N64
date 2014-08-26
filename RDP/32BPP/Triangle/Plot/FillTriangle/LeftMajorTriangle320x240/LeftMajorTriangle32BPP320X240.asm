; N64 'Bare Metal' 32BPP 320x240 Left Major Fill Triangle RDP Demo by krom (Peter Lemon):

  include LIB\N64.INC ; Include N64 Definitions
  dcb 2097152,$00 ; Set ROM Size
  org $80000000 ; Entry Point Of Code
  include LIB\N64_HEADER.ASM  ; Include 64 Byte Header & Vector Table
  incbin LIB\N64_BOOTCODE.BIN ; Include 4032 Byte Boot Code

Start:
  include LIB\N64_INIT.ASM ; Include Initialisation Routine
  include LIB\N64_GFX.INC  ; Include Graphics Macros

  ScreenNTSC 320,240, BPP32, $A0100000 ; Screen NTSC: 320x240, 32BPP, DRAM Origin $A0100000

  la t0,MULT ; T0 = Float Multipy Data Offset
  lwc1 f0,0(t0) ; F0 = 0.0 (Divide By Zero Check)
  lwc1 f1,4(t0) ; F1 = 4.0 (Fixed Point S.11.2)
  lwc1 f2,8(t0) ; F2 = 65536.0 (Fixed Point S.15.16)


Loop:
  WaitScanline $200 ; Wait For Scanline To Reach Vertical Blank

  DPC RDPBuffer,RDPBufferEnd ; Run DPC Command Buffer: Start Address, End Address

  la t0,TRI ; T0 = Float Triangle Data Offset


  ; PASS1 Sort Coordinate 0 & 1
  lwc1 f3,4(t0)  ; F3 = Triangle Y0
  lwc1 f4,12(t0) ; F4 = Triangle Y1
  c.le.s f3,f4 ; IF (Y0 <= Y1) Swap Triangle Coordinates 0 & 1
  bc1f PASS101 ; ELSE No Swap
  nop ; Delay Slot
  lwc1 f5,0(t0)  ; F5 = X0
  lwc1 f6,8(t0)  ; F6 = X1
  swc1 f6,0(t0)  ; X0 = X1
  swc1 f4,4(t0)  ; Y0 = Y1
  swc1 f5,8(t0)  ; X1 = X0
  swc1 f3,12(t0) ; Y1 = Y0
  PASS101:

  ; PASS1 Sort Coordinate 1 & 2
  lwc1 f3,12(t0) ; F3 = Triangle Y1
  lwc1 f4,20(t0) ; F4 = Triangle Y2
  c.le.s f3,f4 ; IF (Y1 <= Y2) Swap Triangle Coordinates 1 & 2
  bc1f PASS112 ; ELSE No Swap
  nop ; Delay Slot
  lwc1 f5,8(t0)  ; F5 = X1
  lwc1 f6,16(t0) ; F6 = X2
  swc1 f6,8(t0)  ; X1 = X2
  swc1 f4,12(t0) ; Y1 = Y2
  swc1 f5,16(t0) ; X2 = X1
  swc1 f3,20(t0) ; Y2 = Y1
  PASS112:

  ; PASS1 Sort Coordinate 2 & 0
  lwc1 f3,4(t0)  ; F3 = Triangle Y0
  lwc1 f4,20(t0) ; F4 = Triangle Y2
  c.le.s f3,f4 ; IF (Y0 <= Y2) Swap Triangle Coordinates 0 & 2
  bc1f PASS120 ; ELSE No Swap
  nop ; Delay Slot
  lwc1 f5,0(t0)  ; F5 = X0
  lwc1 f6,16(t0) ; F6 = X2
  swc1 f6,0(t0)  ; X0 = X2
  swc1 f4,4(t0)  ; Y0 = Y2
  swc1 f5,16(t0) ; X2 = X0
  swc1 f3,20(t0) ; Y2 = Y0
  PASS120:

  ; PASS1 Sort Coordinate 0 & 1
  lwc1 f3,4(t0)  ; F3 = Triangle Y0
  lwc1 f4,12(t0) ; F4 = Triangle Y1
  c.le.s f3,f4  ; IF (Y0 <= Y1) Swap Triangle Coordinates 0 & 1
  bc1f PASS101B ; ELSE No Swap
  nop ; Delay Slot
  lwc1 f5,0(t0)  ; F5 = X0
  lwc1 f6,8(t0)  ; F6 = X1
  swc1 f6,0(t0)  ; X0 = X1
  swc1 f4,4(t0)  ; Y0 = Y1
  swc1 f5,8(t0)  ; X1 = X0
  swc1 f3,12(t0) ; Y1 = Y0
  PASS101B:


  ; PASS2 Sort Coordinate 0 & 1
  lwc1 f3,4(t0)  ; F3 = Triangle Y0
  lwc1 f4,12(t0) ; F4 = Triangle Y1
  c.eq.s f3,f4 ; IF (Y0 == Y1) Swap Triangle Coordinates 0 & 1
  bc1f PASS201 ; ELSE No Swap
  nop ; Delay Slot
  lwc1 f5,0(t0) ; F5 = Triangle X0
  lwc1 f6,8(t0) ; F6 = Triangle X1
  c.le.s f5,f6 ; IF (X0 <= X1) Swap Triangle Coordinates 0 & 1
  bc1f PASS201 ; ELSE No Swap
  nop ; Delay Slot
  swc1 f6,0(t0)  ; X0 = X1
  swc1 f4,4(t0)  ; Y0 = Y1
  swc1 f5,8(t0)  ; X1 = X0
  swc1 f3,12(t0) ; Y1 = Y0
  PASS201:

  ; PASS2 Sort Coordinate 1 & 2
  lwc1 f3,12(t0) ; F3 = Triangle Y1
  lwc1 f4,20(t0) ; F4 = Triangle Y2
  c.eq.s f3,f4 ; IF (Y1 == Y2) Swap Triangle Coordinates 1 & 2
  bc1f PASS212 ; ELSE No Swap
  nop ; Delay Slot
  lwc1 f5,8(t0)  ; F5 = X1
  lwc1 f6,16(t0) ; F6 = X2
  c.le.s f6,f5 ; IF (X1 >= X2) Swap Triangle Coordinates 1 & 2
  bc1f PASS212 ; ELSE No Swap
  nop ; Delay Slot
  swc1 f6,8(t0)  ; X1 = X2
  swc1 f4,12(t0) ; Y1 = Y2
  swc1 f5,16(t0) ; X2 = X1
  swc1 f3,20(t0) ; Y2 = Y1
  PASS212:


  lwc1 f3,0(t0)  ; F3 = Triangle X0
  lwc1 f4,4(t0)  ; F4 = Triangle Y0 (YL)
  lwc1 f5,8(t0)  ; F5 = Triangle X1 (XL)
  lwc1 f6,12(t0) ; F6 = Triangle Y1 (YM)
  lwc1 f7,16(t0) ; F7 = Triangle X2 (XH/XM)
  lwc1 f8,20(t0) ; F8 = Triangle Y2 (YH)

  la t0,$A0000000|(FillTri&$3FFFFF) ; T0 = Fill Rect RAM Offset


  lui t1,$0800 ; T1 = Fill Triangle RDP Command (WORD 0)
  c.le.s f5,f7 ; IF (X1 <= X2) DIR = 0 (Left Major Triangle)
  bc1t DIR     ; ELSE DIR = 1 (Right Major Triangle)
  lui t2,$0000 ; T2 = DIR 0
  lui t2,$0080 ; T2 = DIR 1
  DIR:
  or t1,t2

  mul.s f9,f4,f1 ; Convert To S.11.2
  cvt.w.s f9 ; F9 = YL
  mfc1 t2,f9 ; T2 = YL
  andi t2,$3FFF ; T2 &= S.11.2
  or t1,t2
  sw t1,0(t0) ; Store RDP Command (WORD 0 HI)

  mul.s f9,f6,f1 ; Convert To S.11.2
  cvt.w.s f9 ; F9 = YM
  mfc1 t1,f9 ; T1 = YM
  andi t1,$3FFF ; T1 &= S.11.2
  dsll t1,16 ; T1 = YM

  mul.s f9,f8,f1 ; Convert To S.11.2
  cvt.w.s f9 ; F9 = YH
  mfc1 t2,f9 ; T2 = YH
  andi t2,$3FFF ; T2 &= S.11.2
  or t1,t2
  sw t1,4(t0) ; Store RDP Command (WORD 0 LO)


  mul.s f9,f5,f2 ; Convert To S.15.16
  cvt.w.s f9 ; F9 = XL
  mfc1 t1,f9 ; T1 = XL
  sw t1,8(t0) ; Store RDP Command (WORD 1 HI)

  sub.s f10,f6,f4
  c.eq.s f10,f0 ; IF ((Y1 - Y0) == 0) DxLDy = 0.0 
  bc1t DXLDY    ; ELSE DxLDy = (X1 - X0) / (Y1 - Y0)
  andi t1,0 ; T1 = DxLDy 0.0

  sub.s f9,f5,f3
  div.s f9,f10 ; F9 = DxLDy
  mul.s f9,f2  ; Convert To S.15.16
  cvt.w.s f9 ; F9 = DxLDy
  mfc1 t1,f9 ; T1 = DxLDy
  DXLDY:
  sw t1,12(t0) ; Store RDP Command (WORD 1 LO)


  mul.s f9,f7,f2 ; Convert To S.15.16
  cvt.w.s f9 ; F9 = XH
  mfc1 t1,f9 ; T1 = XH
  sw t1,16(t0) ; Store RDP Command (WORD 2 HI) 

  sub.s f10,f8,f4
  c.eq.s f10,f0 ; IF ((Y2 - Y0) == 0) DxHDy = 0.0 
  bc1t DXHDY    ; ELSE DxHDy = (X2 - X0) / (Y2 - Y0)
  andi t2,0 ; T2 = DxHDy 0.0

  sub.s f9,f7,f3
  div.s f9,f10 ; F9 = DxHDy
  mul.s f9,f2  ; Convert To S.15.16
  cvt.w.s f9 ; F9 = DxHDy
  mfc1 t2,f9 ; T2 = DxHDy
  DXHDY:
  sw t2,20(t0) ; Store RDP Command (WORD 2 LO)


  sw t1,24(t0) ; Store RDP Command (WORD 3 HI) T1 = XM (Uses Previous XH)

  sub.s f10,f8,f6
  c.eq.s f10,f0 ; IF ((Y2 - Y1) == 0) DxMDy = 0.0 
  bc1t DXMDY    ; ELSE DxMDy = (X2 - X1) / (Y2 - Y1)
  andi t1,0 ; T1 = DxMDy 0.0

  sub.s f9,f7,f5
  div.s f9,f10 ; F9 = DxMDy
  mul.s f9,f2  ; Convert To S.15.16
  cvt.w.s f9 ; F9 = DxMDy
  mfc1 t1,f9 ; T1 = DxMDy
  DXMDY:
  sw t1,28(t0) ; Store RDP Command (WORD 3 LO)

  j Loop
  nop ; Delay Slot

  align 8 ; Align 64-bit
RDPBuffer:
  Set_Scissor 0<<2,0<<2, 320<<2,240<<2, 0 ; Set Scissor: XH 0.0, YH 0.0, XL 320.0, YL 240.0, Scissor Field Enable Off
  Set_Other_Modes CYCLE_TYPE_FILL, 0 ; Set Other Modes
  Set_Color_Image SIZE_OF_PIXEL_32B|(320-1), $00100000 ; Set Color Image: SIZE 32B, WIDTH 320, DRAM ADDRESS $00100000
  Set_Fill_Color $FFFF00FF ; Set Fill Color: PACKED COLOR 32B R8G8B8A8 Pixel
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
  IEEE32     0.0 ; Multiply (Divide By Zero Check)
  IEEE32     4.0 ; Multiply (Fixed Point S.11.2)
  IEEE32 65536.0 ; Multiply (Fixed Point S.15.16)

TRI: ; Float 2D Triangle Data
;  IEEE32 25.0,  50.0 ; Triangle X0, Y0
;  IEEE32 25.0, 100.0 ; Triangle X1, Y1
;  IEEE32 75.0,  50.0 ; Triangle X2, Y2

;  IEEE32 100.0,  50.0 ; Triangle X0, Y0
;  IEEE32 150.0, 100.0 ; Triangle X1, Y1
;  IEEE32 150.0,  50.0 ; Triangle X2, Y2

;  IEEE32 225.0,  50.0 ; Triangle X0, Y0
;  IEEE32 175.0, 100.0 ; Triangle X1, Y1
;  IEEE32 225.0, 100.0 ; Triangle X2, Y2

;  IEEE32 250.0,  50.0 ; Triangle X0, Y0
;  IEEE32 250.0, 100.0 ; Triangle X1, Y1
;  IEEE32 300.0, 100.0 ; Triangle X2, Y2

;  IEEE32  25.0, 150.0 ; Triangle X0, Y0
;  IEEE32  25.0, 200.0 ; Triangle X1, Y1
;  IEEE32  75.0, 175.0 ; Triangle X2, Y2

;  IEEE32 100.0, 150.0 ; Triangle X0, Y0
;  IEEE32 125.0, 200.0 ; Triangle X1, Y1
;  IEEE32 150.0, 150.0 ; Triangle X2, Y2

;  IEEE32 225.0, 150.0 ; Triangle X0, Y0
;  IEEE32 225.0, 200.0 ; Triangle X1, Y1
;  IEEE32 175.0, 175.0 ; Triangle X2, Y2

  IEEE32 275.0, 150.0 ; Triangle X0, Y0
  IEEE32 250.0, 200.0 ; Triangle X1, Y1
  IEEE32 300.0, 200.0 ; Triangle X2, Y2