; N64 'Bare Metal' Input RDP Demo by krom (Peter Lemon):

  include LIB\N64.INC ; Include N64 Definitions
  include LIB\N64_INPUT.INC ; Include Input Macros
  include LIB\N64_GFX.INC ; Include Graphics Macros
  dcb 2097152,$00 ; Set ROM Size
  org $80000000 ; Entry Point Of Code
  include LIB\N64_HEADER.ASM  ; Include 64 Byte Header & Vector Table
  incbin LIB\N64_BOOTCODE.BIN ; Include 4032 Byte Boot Code

Start:
  include LIB\N64_INIT.ASM ; Include Initialisation Routine

  ScreenNTSC 320,240, BPP32, $A0100000 ; Screen NTSC: 320x240, 32BPP, DRAM Origin $A0100000

  li t6,160 ; T6 = X Position (1/2 Screen X)
  li t7,120 ; T7 = Y Position (1/2 Screen Y)

  InitController PIF1 ; Initialize Controller

Loop:
  WaitScanline $200 ; Wait For Scanline To Reach Vertical Blank

  DPC RDPBuffer,RDPBufferEnd ; Run DPC Command Buffer: Start, End

  ReadController PIF2 ; T0 = Controller Buttons, T1 = Analog X, T2 = Analog Y

  li t1,8
  beq t7,t1,Down ; IF(Y = 0) GOTO Down
  
  andi t1,t0,JOY_UP ; Test JOY UP
  beq t1,r0,Down
  nop ; Delay Slot
  subi t7,1

Down:
  li t1,232
  beq t7,t1,Left ; IF(Y = 232) GOTO Left

  andi t1,t0,JOY_DOWN ; Test JOY DOWN
  beq t1,r0,Left
  nop ; Delay Slot
  addi t7,1

Left:
  li t1,8
  beq t6,t1,Right ; IF(X = 8) GOTO Right

  andi t1,t0,JOY_LEFT ; Test JOY LEFT
  beq t1,r0,Right
  nop ; Delay Slot
  subi t6,1

Right:
  li t1,312
  beq t6,t1,Render ; IF(X = 312) GOTO Render

  andi t1,t0,JOY_RIGHT ; Test JOY RIGHT
  beq t1,r0,Render
  nop ; Delay Slot
  addi t6,1

Render:
  la t0,$A0000000|(FillRect&$3FFFFF) ; T0 = Fill Rect RAM Offset
  addi t1,t6,7 ; T1 = XL
  addi t2,t7,7 ; T2 = YL
  subi t3,t6,8 ; T3 = XH
  subi t4,t7,8 ; T4 = YH
  sll t1,14
  sll t2,2
  sll t3,14
  sll t4,2

  lui t5,$3600 ; T5 = Fill Rect RDP Command
  or t5,t1
  or t5,t2
  sw t5,0(t0) ; Store 1st Word
  or t3,t4
  sw t3,4(t0) ; Store 2nd Word

  j Loop
  nop ; Delay Slot

  align 8 ; Align 64-bit
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