; N64 'Bare Metal' Input CPU Demo by krom (Peter Lemon):

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

  lui t0,$A010 ; T0 = VRAM Start Offset
  addi t1,t0,((320*240*4)-4) ; T1 = VRAM End Offset
  li t2,$000000FF ; T2 = Black
ClearScreen:
  sw t2,0(t0)
  bne t0,t1,ClearScreen
  addi t0,4 ; Delay Slot

  li t3,($A0100000+(120*320*4)+(160*4))
  
  InitController PIF1 ; Initialize Controller

Loop:
  WaitScanline $200 ; Wait For Scanline To Reach Vertical Blank
  ReadController PIF2 ; T0 = Controller Buttons, T1 = Analog X, T2 = Analog Y

  andi t1,t0,JOY_UP ; Test JOY UP
  beqz t1,Down
  nop ; Delay Slot
  subi t3,(320*4)

Down:
  andi t1,t0,JOY_DOWN ; Test JOY DOWN
  beqz t1,Left
  nop ; Delay Slot
  addi t3,(320*4)

Left:
  andi t1,t0,JOY_LEFT ; Test JOY LEFT
  beqz t1,Right
  nop ; Delay Slot
  subi t3,4

Right:
  andi t1,t0,JOY_RIGHT ; Test JOY RIGHT
  beqz t1,Render
  nop ; Delay Slot
  addi t3,4

Render:
  li t1,$FFFFFFFF
  sw t1,0(t3)

  j Loop
  nop ; Delay Slot

  align 8 ; Align 64-bit
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