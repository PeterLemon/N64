; N64 'Bare Metal' 32BPP 320x240 CPU GRB Decode Frame Demo by krom (Peter Lemon):
  include LIB\N64.INC ; Include N64 Definitions
  dcb 1052672,$00 ; Set ROM Size
  org $80000000 ; Entry Point Of Code
  include LIB\N64_HEADER.ASM  ; Include 64 Byte Header & Vector Table
  incbin LIB\N64_BOOTCODE.BIN ; Include 4032 Byte Boot Code

Start:
  include LIB\N64_GFX.INC  ; Include Graphics Macros
  N64_INIT ; Run N64 Initialisation Routine

  ScreenNTSC 320, 240, BPP32, $A0100000 ; Screen NTSC: 320x240, 32BPP, DRAM Origin $A0100000

  SCREEN_X: equ 320
  SCREEN_Y: equ 240

  lui a0,$A010 ; A0 = VRAM Start Offset
  addi a1,a0,((SCREEN_X*SCREEN_Y*4)-4) ; A1 = VRAM End Offset
  li t0,$000000FF ; T0 = Black
ClearScreen:
  sw t0,0(a0)
  bne a0,a1,ClearScreen
  addi a0,4 ; Delay Slot

  lui a0,$A010 ; A0 = VI Frame Buffer DRAM Origin
DecodeGRB:
  la a1,grb ; A1 = G Offset
  la a2,(grb+(SCREEN_X*SCREEN_Y)) ; A2 = R Offset
  la a3,(grb+(SCREEN_X*SCREEN_Y))+(SCREEN_X*SCREEN_Y/4) ; A3 = B Offset

  addi t0,a0,1 ; T0 = VI Frame Buffer G Byte
  LoopG: ; Loop Green Pixels (1:1)
    lbu t1,0(a1) ; Load G Byte
    addi a1,1 ; G Offset++
    sb t1,0(t0) ; Store G Byte
    bne a1,a2,LoopG ; IF (G Offset != R Offset) Loop G
    addi t0,4 ; VI Frame Buffer G Byte += 4 (Delay Slot)

  lui t0,$A010 ; T0 = VI Frame Buffer R Byte
  li t1,((SCREEN_X/2)-1) ; T1 = (SCREEN_X / 2) - 1
  LoopR: ; Loop Red Pixels (1:4)
    lbu t2,0(a2) ; Load R Byte
    addi a2,1 ; R Offset++
    sb t2,0(t0) ; Store Pixel 1,1
    sb t2,4(t0) ; Store Pixel 1,2
    sb t2,(SCREEN_X*4)(t0) ; Store Pixel 2,1
    sb t2,((SCREEN_X*4)+4)(t0) ; Store Pixel 2,2

    bnez t1,SkipR
    subi t1,1 ; Delay Slot
    li t1,((SCREEN_X/2)-1) ; T1 = (SCREEN_X / 2) - 1
    addi t0,(SCREEN_X*4)
    SkipR:

    bne a2,a3,LoopR ; IF (R Offset != R Offset) Loop R
    addi t0,8 ; VI Frame Buffer R Byte += 8 (Delay Slot)

  addi t0,a0,2 ; T0 = VI Frame Buffer B Byte
  li t1,((SCREEN_X/4)-1) ; T1 = (SCREEN_X / 4) - 1
  addi t2,a3,(SCREEN_X*SCREEN_Y/16) ; T2 = B End Offset
  LoopB: ; Loop Blue Pixels (1:16)
    lbu t3,0(a3) ; Load B Byte
    addi a3,1 ; R Offset++
    sb t3,0(t0) ; Store Pixel 1,1
    sb t3,4(t0) ; Store Pixel 1,2
    sb t3,8(t0) ; Store Pixel 1,3
    sb t3,12(t0) ; Store Pixel 1,4
    sb t3,(SCREEN_X*4)(t0) ; Store Pixel 2,1 
    sb t3,((SCREEN_X*4)+4)(t0) ; Store Pixel 2,2
    sb t3,((SCREEN_X*4)+8)(t0) ; Store Pixel 2,3
    sb t3,((SCREEN_X*4)+12)(t0) ; Store Pixel 2,4
    sb t3,(SCREEN_X*8)(t0) ; Store Pixel 3,1
    sb t3,((SCREEN_X*8)+4)(t0) ; Store Pixel 3,2
    sb t3,((SCREEN_X*8)+8)(t0) ; Store Pixel 3,3
    sb t3,((SCREEN_X*8)+12)(t0) ; Store Pixel 3,4
    sb t3,(SCREEN_X*12)(t0) ; Store Pixel 4,1
    sb t3,((SCREEN_X*12)+4)(t0) ; Store Pixel 4,2
    sb t3,((SCREEN_X*12)+8)(t0) ; Store Pixel 4,3
    sb t3,((SCREEN_X*12)+12)(t0) ; Store Pixel 4,4

    bnez t1,SkipB
    subi t1,1 ; Delay Slot
    li t1,((SCREEN_X/4)-1) ; T1 = (SCREEN_X / 4) - 1
    addi t0,(SCREEN_X*12)
    SkipB:

    bne a3,t2,LoopB ; IF(B Offset != B End Offset) Loop B
    addi t0,16 ; VI Frame Buffer B Byte += 16 (Delay Slot)

Loop:
  j Loop
  nop ; Delay Slot

grb:
  incbin frame.grb