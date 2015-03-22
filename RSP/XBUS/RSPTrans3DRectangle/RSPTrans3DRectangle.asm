; N64 'Bare Metal' RSP Transform 3D Rectangle Test by krom (Peter Lemon):
  include LIB\N64.INC ; Include N64 Definitions
  dcb 1052672,$00 ; Set ROM Size
  org $80000000 ; Entry Point Of Code
  include LIB\N64_HEADER.ASM  ; Include 64 Byte Header & Vector Table
  incbin LIB\N64_BOOTCODE.BIN ; Include 4032 Byte Boot Code

Start:
  include LIB\N64_GFX.INC ; Include Graphics Macros
  include LIB\N64_RSP.INC ; Include RSP Macros
  N64_INIT ; Run N64 Initialisation Routine

  ScreenNTSC 320, 240, BPP16, $A0100000 ; Screen NTSC: 320x240, 16BPP, DRAM Origin = $A0100000

  ; Switch to RSP DMEM for RDP Commands
  lui a0,DPC_BASE ; A0 = Reality Display Processer Control Interface Base Register ($A4100000)
  li t0,$00000002 ; T0 = DP Status To Use RSP DMEM (Set XBUS DMEM DMA)
  sw t0,DPC_STATUS(a0) ; Store DP Status To DP Status Register ($A410000C)

  ; Load RSP Code To IMEM
  DMASPRD RSPCode, RSPCodeEND, SP_IMEM ; DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  ; Load RSP Data To DMEM
  DMASPRD RSPData, RSPDataEND, SP_DMEM ; DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  ; Set RSP Program Counter
  lui a0,SP_PC_BASE ; A0 = SP PC Base Register ($A4080000)
  li t0,$0000 ; T0 = RSP Program Counter Set To Zero (Start Of RSP Code)
  sw t0,SP_PC(a0) ; Store RSP Program Counter To SP PC Register ($A4080000)

  ; Set RSP Status (Start Execution)
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB ; T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) ; Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

Loop:
  j Loop
  nop ; Delay Slot

  align 8 ; Align 64-Bit
RSPCode:
  obj $0000 ; Set Base Of RSP Code Object To Zero

; Load Point X,Y,Z
  lqv v00,(e0),$00,(0) ; V0 = Point X ($000)
  lqv v01,(e0),$01,(0) ; V1 = Point Y ($010)
  lqv v02,(e0),$02,(0) ; V2 = Point Z ($020)

; Load Camera
  lqv v03,(e0),$03,(0) ; V3 = Screen X / 2 ($030)
  lqv v04,(e0),$04,(0) ; V4 = Screen Y / 2 ($040)
  lqv v05,(e0),$05,(0) ; V5 = FOV ($050)

; Load Matrix
  lqv v20,(e0),$06,(0) ; V20 = Row 0 X ($060)
  lqv v21,(e0),$07,(0) ; V21 = Row 0 Y ($070)
  lqv v22,(e0),$08,(0) ; V22 = Row 0 Z ($080)
  lqv v23,(e0),$09,(0) ; V23 = Row 0 T ($090)

  lqv v24,(e0),$0A,(0) ; V24 = Row 1 X ($0A0)
  lqv v25,(e0),$0B,(0) ; V25 = Row 1 Y ($0B0)
  lqv v26,(e0),$0C,(0) ; V26 = Row 1 Z ($0C0)
  lqv v27,(e0),$0D,(0) ; V27 = Row 1 T ($0D0)

  lqv v28,(e0),$0E,(0) ; V28 = Row 2 X ($0E0)
  lqv v29,(e0),$0F,(0) ; V29 = Row 2 Y ($0F0)
  lqv v30,(e0),$10,(0) ; V30 = Row 2 Z ($100)
  lqv v31,(e0),$11,(0) ; V31 = Row 2 T ($110)

; Calculate X,Y,Z 3D
  vmudh v06,v00,v20,(e0) ; X = (Matrix[0] * X) + (Matrix[1] * Y) + (Matrix[2] * Z) + Matrix[3]
  vmadh v06,v01,v21,(e0)
  vmadh v06,v02,v22,(e0)
  vadd v06,v00,v23,(e0)

  vmudh v07,v00,v24,(e0) ; Y = (Matrix[4] * X) + (Matrix[5] * Y) + (Matrix[6] * Z) + Matrix[7]
  vmadh v07,v01,v25,(e0)
  vmadh v07,v02,v26,(e0)
  vadd v07,v01,v27,(e0)

  vmudh v08,v00,v28,(e0) ; Z = (Matrix[8] * X) + (Matrix[9] * Y) + (Matrix[10] * Z) + Matrix[11]
  vmadh v08,v01,v29,(e0)
  vmadh v08,v02,v30,(e0)
  vadd v08,v02,v31,(e0)

; Store Rectangle Z Coords To DMEM
  vsub v09,v08,v08,(e0) ; V9 = Negative Z
  vsub v09,v09,v08,(e0)
  sqv v09,(e0),$02,(0) ; DMEM $002 = Point Z

; Calculate X,Y 2D
  vmudh v08,v08,v05,(e0) ; V8 = Z / FOV

  vmulf v06,v06,v08,(e0) ; X = X / Z + (ScreenX / 2)
  vadd v06,v06,v03,(e0)

  vmulf v07,v07,v08,(e0) ; Y = (ScreenY / 2) - Y / Z
  vsub v07,v04,v07,(e0)

; Store Rectangle X,Y Coords To DMEM
  sqv v06,(e0),$00,(0) ; DMEM $000 = Point X
  sqv v07,(e0),$01,(0) ; DMEM $010 = Point Y


  la a0,PointX ; A0 = X Vector DMEM Offset
  la a1,RectangleZ ; A1 = RDP Rectangle XY DMEM Offset
  li t4,7 ; T4 = Point Count

LoopPoint:
  lhu t0,$0000(a0) ; T0 = Point X
  lhu t1,$0010(a0) ; T1 = Point Y
  lhu t2,$0020(a0) ; T2 = Point Z

  sh t2,$0004(a1) ; Store Primitive Z Depth

  sll t2,t0,12
  add t2,t1 ; T2 = XL,YL
  li t3,$36000000
  add t2,t3 ; T2 = Rectangle 1st Word
  sw t2,$0008(a1) ; Store 1st Word
  
  subi t0,2<<2 ; T0 = XH
  subi t1,2<<2 ; T0 = YH
  sll t2,t0,12
  add t2,t1 ; T2 = XH,YH (Rectangle 2nd Word)
  sw t2,$000C(a1) ; Store 2nd Word

  addi a0,2 ; X Vector DMEM Offset += 2
  addi a1,24 ; RDP Rectangle0XY DMEM Offset += 24
  bnez t4,LoopPoint ; IF (Point Count != 0) LoopPoint
  subi t4,1 ; Decrement Point Count (Delay Slot)


  RSPDPC RDPBuffer, RDPBufferEnd ; Run DPC Command Buffer: Start, End

  break $0000 ; Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
  align 8 ; Align 64-Bit
  objend ; Set End Of RSP Code Object
RSPCodeEND:

  align 8 ; Align 64-Bit
RSPData:
  obj $0000 ; Set Base Of RSP Data Object To Zero

PointX:
  dh -20<<2, 20<<2, -20<<2,  20<<2, -20<<2,  20<<2, -20<<2,  20<<2 ; 8 * Point X (10.2)
PointY:
  dh  20<<2, 20<<2, -20<<2, -20<<2,  20<<2,  20<<2, -20<<2, -20<<2 ; 8 * Point Y (10.2)
PointZ:
  dh  20<<2, 20<<2,  20<<2,  20<<2, -20<<2, -20<<2, -20<<2, -20<<2 ; 8 * Point Z (10.2)

HALF_SCREEN_X:
  dh 160<<2, 160<<2, 160<<2, 160<<2, 160<<2, 160<<2, 160<<2, 160<<2 ; 8 * Screen X / 2 (10.2)
HALF_SCREEN_Y:
  dh 120<<2, 120<<2, 120<<2, 120<<2, 120<<2, 120<<2, 120<<2, 120<<2 ; 8 * Screen Y / 2 (10.2)

FOV:
  dh 80, 80, 80, 80, 80, 80, 80, 80 ; 8 * FOV (Signed Fraction)

Matrix:
  dh 1<<2, 1<<2, 1<<2, 1<<2, 1<<2, 1<<2, 1<<2, 1<<2 ; Row 0 X (10.2) (X)
  dh 0<<2, 0<<2, 0<<2, 0<<2, 0<<2, 0<<2, 0<<2, 0<<2 ; Row 0 Y (10.2)
  dh 0<<2, 0<<2, 0<<2, 0<<2, 0<<2, 0<<2, 0<<2, 0<<2 ; Row 0 Z (10.2)
  dh 0<<2, 0<<2, 0<<2, 0<<2, 0<<2, 0<<2, 0<<2, 0<<2 ; Row 0 T (10.2)

  dh 0<<2, 0<<2, 0<<2, 0<<2, 0<<2, 0<<2, 0<<2, 0<<2 ; Row 1 X (10.2) (Y)
  dh 1<<2, 1<<2, 1<<2, 1<<2, 1<<2, 1<<2, 1<<2, 1<<2 ; Row 1 Y (10.2)
  dh 0<<2, 0<<2, 0<<2, 0<<2, 0<<2, 0<<2, 0<<2, 0<<2 ; Row 1 Z (10.2)
  dh 0<<2, 0<<2, 0<<2, 0<<2, 0<<2, 0<<2, 0<<2, 0<<2 ; Row 1 T (10.2)

  dh 0<<2, 0<<2, 0<<2, 0<<2, 0<<2, 0<<2, 0<<2, 0<<2 ; Row 2 X (10.2) (Z)
  dh 0<<2, 0<<2, 0<<2, 0<<2, 0<<2, 0<<2, 0<<2, 0<<2 ; Row 2 Y (10.2)
  dh 1<<2, 1<<2, 1<<2, 1<<2, 1<<2, 1<<2, 1<<2, 1<<2 ; Row 2 Z (10.2)
  dh 100<<2, 100<<2, 100<<2, 100<<2, 100<<2, 100<<2, 100<<2, 100<<2 ; Row 2 T (10.2)

RDPBuffer:
  Set_Scissor 0<<2,0<<2, 320<<2,240<<2, 0 ; Set Scissor: XH 0.0, YH 0.0, XL 320.0, YL 240.0, Scissor Field Enable Off
  Set_Other_Modes CYCLE_TYPE_FILL, 0 ; Set Other Modes
  Set_Z_Image $00200000 ; Set Z Image: DRAM ADDRESS $00200000
  Set_Color_Image SIZE_OF_PIXEL_16B|(320-1), $00200000 ; Set Color Image: SIZE 16B, WIDTH 320, DRAM ADDRESS $00200000
  Set_Fill_Color $FFFFFFFF ; Set Fill Color: PACKED COLOR 16B R5G5B5A1 Pixels (Clear ZBuffer)
  Fill_Rectangle 319<<2,239<<2, 0<<2,0<<2 ; Fill Rectangle: XL 319.0, YL 239.0, XH 0.0, YH 0.0

  Sync_Pipe ; Stall Pipeline, Until Preceeding Primitives Completely Finish
  Set_Color_Image SIZE_OF_PIXEL_16B|(320-1), $00100000 ; Set Color Image: SIZE 16B, WIDTH 320, DRAM ADDRESS $00100000
  Set_Fill_Color $00010001 ; Set Fill Color: PACKED COLOR 16B R5G5B5A1 Pixels
  Fill_Rectangle 319<<2,239<<2, 0<<2,0<<2 ; Fill Rectangle: XL 319.0, YL 239.0, XH 0.0, YH 0.0

  Set_Other_Modes SAMPLE_TYPE|BI_LERP_0|ALPHA_DITHER_SEL_NO_DITHER, B_M1A_0_2|IMAGE_READ_EN|Z_SOURCE_SEL|Z_COMPARE_EN|Z_UPDATE_EN ; Set Other Modes
  Set_Combine_Mode $0, $00, 0, 0, $1, $01, $0, $F, 1, 0, 0, 0, 0, 7, 7, 7 ; Set Combine Mode: SubA RGB0, MulRGB0, SubA Alpha0, MulAlpha0, SubA RGB1, MulRGB1, SubB RGB0, SubB RGB1, SubA Alpha1, MulAlpha1, AddRGB0, SubB Alpha0, AddAlpha0, AddRGB1, SubB Alpha1, AddAlpha1

  Set_Blend_Color $FF0000FF ; Set Blend Color: R 255, G 0, B 0, A 255
RectangleZ:
  Set_Prim_Depth 0,0 ; Set Primitive Depth: PRIMITIVE Z, PRIMITIVE DELTA Z
RectangleXY:
  Fill_Rectangle 0,0, 0,0 ; Fill Rectangle: XL,YL, XH,YH

  Set_Blend_Color $00FF00FF ; Set Blend Color: R 0, G 255, B 0, A 255
  Set_Prim_Depth 0,0 ; Set Primitive Depth: PRIMITIVE Z, PRIMITIVE DELTA Z
  Fill_Rectangle 0,0, 0,0 ; Fill Rectangle: XL,YL, XH,YH

  Set_Blend_Color $0000FFFF ; Set Blend Color: R 0, G 0, B 255, A 255
  Set_Prim_Depth 0,0 ; Set Primitive Depth: PRIMITIVE Z, PRIMITIVE DELTA Z
  Fill_Rectangle 0,0, 0,0 ; Fill Rectangle: XL,YL, XH,YH

  Set_Blend_Color $FFFFFFFF ; Set Blend Color: R 255, G 255, B 255, A 255
  Set_Prim_Depth 0,0 ; Set Primitive Depth: PRIMITIVE Z, PRIMITIVE DELTA Z
  Fill_Rectangle 0,0, 0,0 ; Fill Rectangle: XL,YL, XH,YH

  Set_Blend_Color $800000FF ; Set Blend Color: R 128, G 0, B 0, A 255
  Set_Prim_Depth 0,0 ; Set Primitive Depth: PRIMITIVE Z, PRIMITIVE DELTA Z
  Fill_Rectangle 0,0, 0,0 ; Fill Rectangle: XL,YL, XH,YH

  Set_Blend_Color $008000FF ; Set Blend Color: R 0, G 128, B 0, A 255
  Set_Prim_Depth 0,0 ; Set Primitive Depth: PRIMITIVE Z, PRIMITIVE DELTA Z
  Fill_Rectangle 0,0, 0,0 ; Fill Rectangle: XL,YL, XH,YH

  Set_Blend_Color $000080FF ; Set Blend Color: R 0, G 0, B 128, A 255
  Set_Prim_Depth 0,0 ; Set Primitive Depth: PRIMITIVE Z, PRIMITIVE DELTA Z
  Fill_Rectangle 0,0, 0,0 ; Fill Rectangle: XL,YL, XH,YH

  Set_Blend_Color $808080FF ; Set Blend Color: R 128, G 128, B 128, A 255
  Set_Prim_Depth 0,0 ; Set Primitive Depth: PRIMITIVE Z, PRIMITIVE DELTA Z
  Fill_Rectangle 0,0, 0,0 ; Fill Rectangle: XL,YL, XH,YH

  Sync_Full ; Ensure Entire Scene Is Fully Drawn
RDPBufferEnd:

  align 8 ; Align 64-Bit
  objend ; Set End Of RSP Data Object
RSPDataEnd: