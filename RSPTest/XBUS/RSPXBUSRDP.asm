; N64 'Bare Metal' RSP XBUS RDP Test Demo by krom (Peter Lemon):
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

  RSPDPC RDPBuffer, RDPBufferEnd ; Run DPC Command Buffer: Start, End

  break $0000 ; Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
  align 8 ; Align 64-Bit
  objend ; Set End Of RSP Code Object
RSPCodeEND:

  align 8 ; Align 64-Bit
RSPData:
  obj $0000 ; Set Base Of RSP Data Object To Zero

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
  Set_Prim_Depth 50,0 ; Set Primitive Depth: PRIMITIVE Z 50, PRIMITIVE DELTA Z 0
  Fill_Rectangle 144<<2,144<<2, 16<<2,32<<2 ; Fill Rectangle: XL 144.0, YL 144.0, XH 16.0, YH 32.0

  Sync_Pipe ; Stall Pipeline, Until Preceeding Primitives Completely Finish
  Set_Blend_Color $FFFFFFFF ; Set Blend Color: R 255, G 255, B 255, A 255
  Set_Prim_Depth 100,0 ; Set Primitive Depth: PRIMITIVE Z 100, PRIMITIVE DELTA Z 0
  Fill_Rectangle 88<<2,224<<2, 72<<2,16<<2 ; Fill Rectangle: XL 88.0, YL 224.0, XH 72.0, YH 16.0


  Sync_Pipe ; Stall Pipeline, Until Preceeding Primitives Completely Finish
  Set_Blend_Color $FF0000FF ; Set Blend Color: R 255, G 0, B 0, A 255
  Set_Prim_Depth 100,0 ; Set Primitive Depth: PRIMITIVE Z 100, PRIMITIVE DELTA Z 0
  Fill_Rectangle 304<<2,144<<2, 176<<2,32<<2 ; Fill Rectangle: XL 304.0, YL 144.0, XH 176.0, YH 32.0

  Sync_Pipe ; Stall Pipeline, Until Preceeding Primitives Completely Finish
  Set_Blend_Color $FFFFFFFF ; Set Blend Color: R 255, G 255, B 255, A 255
  Set_Prim_Depth 50,0 ; Set Primitive Depth: PRIMITIVE Z 50, PRIMITIVE DELTA Z 0
  Fill_Rectangle 248<<2,224<<2, 232<<2,16<<2 ; Fill Rectangle: XL 248.0, YL 224.0, XH 232.0, YH 16.0

  Sync_Full ; Ensure Entire Scene Is Fully Drawn
RDPBufferEnd:

  align 8 ; Align 64-Bit
  objend ; Set End Of RSP Data Object
RSPDataEnd: