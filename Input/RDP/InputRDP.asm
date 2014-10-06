; N64 'Bare Metal' Input RDP Demo by krom (Peter Lemon):
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

  li t5,160 ; T5 = X Position (1/2 Screen X)
  li t6,120 ; T6 = Y Position (1/2 Screen Y)

  la a3,$A0000000|(FillRect&$3FFFFF) ; A0 = Fill Rect RAM Offset

  InitController PIF1 ; Initialize Controller

Loop:
  WaitScanline $200 ; Wait For Scanline To Reach Vertical Blank

  DPC RDPBuffer, RDPBufferEnd ; Run DPC Command Buffer: Start, End

  ReadController PIF2 ; T0 = Controller Buttons, T1 = Analog X, T2 = Analog Y

  li t3,8
  beq t6,t3,Down ; IF (Y = 0) Down (Screen Edge Collision)
  andi t3,t0,JOY_UP ; Test JOY UP
  beqz t3,Down
  nop ; Delay Slot
  subi t6,1

Down:
  li t3,232
  beq t6,t3,Left ; IF (Y = 232) Left (Screen Edge Collision)
  andi t3,t0,JOY_DOWN ; Test JOY DOWN
  beqz t3,Left
  nop ; Delay Slot
  addi t6,1

Left:
  li t3,8
  beq t5,t3,Right ; IF (X = 8) Right (Screen Edge Collision)
  andi t3,t0,JOY_LEFT ; Test JOY LEFT
  beqz t3,Right
  nop ; Delay Slot
  subi t5,1

Right:
  li t3,312
  beq t5,t3,Render ; IF (X = 312) Render (Screen Edge Collision)
  andi t3,t0,JOY_RIGHT ; Test JOY RIGHT
  beqz t3,Render
  nop ; Delay Slot
  addi t5,1

Render:
  addi t0,t5,7 ; T0 = XL
  addi t1,t6,7 ; T1 = YL
  subi t2,t5,8 ; T2 = XH
  subi t3,t6,8 ; T3 = YH
  dsll32 t0,14
  dsll32 t1,2
  dsll t2,14
  dsll t3,2

  lui t4,$3600 ; T4 = Fill Rect RDP Command
  dsll32 t4,0
  or t4,t0
  or t4,t1
  or t4,t2
  or t4,t3
  sd t4,0(a3) ; Store RDP Command

  j Loop
  nop ; Delay Slot

  align 8 ; Align 64-Bit
RDPBuffer:
  Set_Scissor 0<<2,0<<2, 320<<2,240<<2, 0 ; Set Scissor: XH 0.0, YH 0.0, XL 320.0, YL 240.0, Scissor Field Enable Off
  Set_Other_Modes CYCLE_TYPE_FILL, 0 ; Set Other Modes
  Set_Color_Image SIZE_OF_PIXEL_32B|(320-1), $00100000 ; Set Color Image: SIZE 32B, WIDTH 320, DRAM ADDRESS $00100000
  Set_Fill_Color $FFFF00FF ; Set Fill Color: PACKED COLOR 32B R8G8B8A8 Pixel
  Fill_Rectangle 319<<2,239<<2, 0<<2,0<<2 ; Fill Rectangle: XL 319.0, YL 239.0, XH 0.0, YH 0.0

  Set_Fill_Color $FF0000FF ; Set Fill Color: PACKED COLOR 32B R8G8B8A8 Pixel
  FillRect:
    Fill_Rectangle 167<<2,127<<2, 152<<2,112<<2 ; Fill Rectangle: XL 167.0, YL 127.0, XH 152.0, YH 112.0

  Sync_Full ; Ensure Entire Scene Is Fully Drawn
RDPBufferEnd:

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