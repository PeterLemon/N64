// N64 'Bare Metal' RSP Transform 2D Rectangle Test by krom (Peter Lemon):
arch n64.cpu
endian msb
output "RSPTrans2DRectangle.N64", create
fill 1052672 // Set ROM Size

origin $00000000
base $80000000 // Entry Point Of Code
include "LIB/N64.INC" // Include N64 Definitions
include "LIB/N64_HEADER.ASM" // Include 64 Byte Header & Vector Table
insert "LIB/N64_BOOTCODE.BIN" // Include 4032 Byte Boot Code

Start:
  include "LIB/N64_GFX.INC" // Include Graphics Macros
  include "LIB/N64_RSP.INC" // Include RSP Macros
  N64_INIT() // Run N64 Initialisation Routine

  ScreenNTSC(320, 240, BPP16, $A0100000) // Screen NTSC: 320x240, 16BPP, DRAM Origin $A0100000

  SetXBUS() // RDP Status: Set XBUS (Switch To RSP DMEM For RDP Commands)

  // Load RSP Code To IMEM
  DMASPRD(RSPCode, RSPCodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  DMASPRD(RSPData, RSPDataEnd, SP_DMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  SetSPPC(RSPStart) // Set RSP Program Counter: Start Address
  StartSP() // Start RSP Execution: RSP Status = Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break

Loop:
  j Loop
  nop // Delay Slot

align(8) // Align 64-Bit
RSPCode:
arch n64.rsp
base $0000 // Set Base Of RSP Code Object To Zero

RSPStart:
// Load Point X,Y
  lqv v0[e0],PointX(r0) // V0 = Point X ($000)
  lqv v1[e0],PointY(r0) // V1 = Point Y ($010)

// Calculate X,Y 2D
  lqv v2[e0],HALF_SCREEN_XY(r0) // V2 = Screen X / 2, Screen Y / 2 ($020)
 
  vadd v0,v2[e8] // X = X + (ScreenX / 2)
  vadd v1,v2[e9] // Y = Y + (ScreenY / 2)

// Store Rectangle Coords To DMEM
  sqv v0[e0],PointX(r0) // DMEM $000 = Point X
  sqv v1[e0],PointY(r0) // DMEM $010 = Point Y


  lli a0,PointX // A0 = X Vector DMEM Offset
  lli a1,RectangleXY // A1 = RDP Rectangle XY DMEM Offset
  lli t4,7 // T4 = Point Count

LoopPoint:
  lhu t0,PointX(a0) // T0 = Point X
  lhu t1,PointY(a0) // T1 = Point Y

  sll t2,t0,12
  add t2,t1 // T2 = XL,YL
  lui t3,$3600
  add t2,t3 // T2 = Rectangle 1st Word
  sw t2,$0000(a1) // Store 1st Word
  
  subi t0,2<<2 // T0 = XH
  subi t1,2<<2 // T0 = YH
  sll t2,t0,12
  add t2,t1 // T2 = XH,YH (Rectangle 2nd Word)
  sw t2,$0004(a1) // Store 2nd Word

  addi a0,2 // X Vector DMEM Offset += 2
  addi a1,16 // RDP Rectangle0XY DMEM Offset += 16
  bnez t4,LoopPoint // IF (Point Count != 0) LoopPoint
  subi t4,1 // Decrement Point Count (Delay Slot)


  RSPDPC(RDPBuffer, RDPBufferEnd) // Run DPC Command Buffer: Start, End

  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
align(8) // Align 64-Bit
base RSPCode+pc() // Set End Of RSP Code Object
RSPCodeEnd:

align(8) // Align 64-Bit
RSPData:
base $0000 // Set Base Of RSP Data Object To Zero

PointX:
  dh -10<<2, 10<<2, -10<<2,  10<<2, -20<<2,  20<<2, -20<<2,  20<<2 // 8 * Point X (10.2)
PointY:
  dh  10<<2, 10<<2, -10<<2, -10<<2,  20<<2,  20<<2, -20<<2, -20<<2 // 8 * Point Y (10.2)

HALF_SCREEN_XY:
  dh 160<<2, 120<<2, 0, 0, 0, 0, 0, 0 // Screen X / 2 (10.2), Screen Y / 2 (10.2)

align(8) // Align 64-Bit
RDPBuffer:
arch n64.rdp
  Set_Scissor 0<<2,0<<2, 0,0, 320<<2,240<<2 // Set Scissor: XH 0.0,YH 0.0, Scissor Field Enable Off,Field Off, XL 320.0,YL 240.0
  Set_Other_Modes CYCLE_TYPE_FILL // Set Other Modes
  Set_Z_Image $00200000 // Set Z Image: DRAM ADDRESS $00200000
  Set_Color_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,320-1, $00200000 // Set Color Image: FORMAT RGBA,SIZE 16B,WIDTH 320, DRAM ADDRESS $00200000
  Set_Fill_Color $FFFFFFFF // Set Fill Color: PACKED COLOR 16B R5G5B5A1 Pixels (Clear ZBuffer)
  Fill_Rectangle 319<<2,239<<2, 0<<2,0<<2 // Fill Rectangle: XL 319.0,YL 239.0, XH 0.0,YH 0.0

  Sync_Pipe // Stall Pipeline, Until Preceeding Primitives Completely Finish
  Set_Color_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,320-1, $00100000 // Set Color Image: FORMAT RGBA,SIZE 16B,WIDTH 320, DRAM ADDRESS $00100000
  Set_Fill_Color $00010001 // Set Fill Color: PACKED COLOR 16B R5G5B5A1 Pixels
  Fill_Rectangle 319<<2,239<<2, 0<<2,0<<2 // Fill Rectangle: XL 319.0,YL 239.0, XH 0.0,YH 0.0

  Set_Other_Modes SAMPLE_TYPE|BI_LERP_0|ALPHA_DITHER_SEL_NO_DITHER|B_M1A_0_2|IMAGE_READ_EN|Z_SOURCE_SEL|Z_COMPARE_EN|Z_UPDATE_EN // Set Other Modes
  Set_Combine_Mode $0,$00, 0,0, $1,$01, $0,$F, 1,0, 0,0,0, 7,7,7 // Set Combine Mode: SubA RGB0,MulRGB0, SubA Alpha0,MulAlpha0, SubA RGB1,MulRGB1, SubB RGB0,SubB RGB1, SubA Alpha1,MulAlpha1, AddRGB0,SubB Alpha0,AddAlpha0, AddRGB1,SubB Alpha1,AddAlpha1

  Set_Blend_Color $FFFFFFFF // Set Blend Color: R 255,G 255,B 255,A 255

RectangleZ:
  Set_Prim_Depth 50<<2,0 // Set Primitive Depth: PRIMITIVE Z 50,PRIMITIVE DELTA Z 0
RectangleXY:
  Fill_Rectangle 0,0, 0,0 // Fill Rectangle: XL,YL, XH,YH

  Set_Prim_Depth 50<<2,0 // Set Primitive Depth: PRIMITIVE Z 50,PRIMITIVE DELTA Z 0
  Fill_Rectangle 0,0, 0,0 // Fill Rectangle: XL,YL, XH,YH

  Set_Prim_Depth 50<<2,0 // Set Primitive Depth: PRIMITIVE Z 50,PRIMITIVE DELTA Z 0
  Fill_Rectangle 0,0, 0,0 // Fill Rectangle: XL,YL, XH,YH

  Set_Prim_Depth 50<<2,0 // Set Primitive Depth: PRIMITIVE Z 50,PRIMITIVE DELTA Z 0
  Fill_Rectangle 0,0, 0,0 // Fill Rectangle: XL,YL, XH,YH

  Set_Prim_Depth 50<<2,0 // Set Primitive Depth: PRIMITIVE Z 50,PRIMITIVE DELTA Z 0
  Fill_Rectangle 0,0, 0,0 // Fill Rectangle: XL,YL, XH,YH

  Set_Prim_Depth 50<<2,0 // Set Primitive Depth: PRIMITIVE Z 50,PRIMITIVE DELTA Z 0
  Fill_Rectangle 0,0, 0,0 // Fill Rectangle: XL,YL, XH,YH

  Set_Prim_Depth 50<<2,0 // Set Primitive Depth: PRIMITIVE Z 50,PRIMITIVE DELTA Z 0
  Fill_Rectangle 0,0, 0,0 // Fill Rectangle: XL,YL, XH,YH

  Set_Prim_Depth 50<<2,0 // Set Primitive Depth: PRIMITIVE Z 50,PRIMITIVE DELTA Z 0
  Fill_Rectangle 0,0, 0,0 // Fill Rectangle: XL,YL, XH,YH

  Sync_Full // Ensure Entire Scene Is Fully Drawn
RDPBufferEnd:

align(8) // Align 64-Bit
base RSPData+pc() // Set End Of RSP Data Object
RSPDataEnd: