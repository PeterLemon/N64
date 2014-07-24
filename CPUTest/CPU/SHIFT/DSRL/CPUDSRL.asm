; N64 'Bare Metal' CPU Doubleword Shift Right Logical (0..31) Test Demo by krom (Peter Lemon):

PrintString: macro vram,xpos,ypos,fontfile,string,length ; Print Text String To VRAM Using Font At X,Y Position
  lui t0,vram ; T0 = Frame Buffer Pointer
  addi t0,((xpos*4)+((640*ypos)*4)) ; Place text at XY Position
  la t1,fontfile ; T1 = Characters
  la t2,string ; T2 = Text Offset
  li t3,length ; T3 = Number of Text Characters to Print
  DrawChars\@:
    li t4,7 ; T4 = Character X Pixel Counter
    li t5,7 ; T5 = Character Y Pixel Counter

    lb t6,0(t2) ; T6 = Next Text Character
    addi t2,1

    sll t6,8 ; Add Shift to Correct Position in Font (* 256)
    add t6,t1

    DrawCharX\@:
      lw t7,0(t6) ; Load Font Text Character Pixel
      addi t6,4
      sw t7,0(t0) ; Store Font Text Character Pixel into Frame Buffer
      addi t0,4

      bnez t4,DrawCharX\@ ; IF Character X Pixel Counter != 0 GOTO DrawCharX
      subi t4,1 ; Decrement Character X Pixel Counter

      addi t0,$9E0 ; Jump down 1 Scanline, Jump back 1 Char ((SCREEN_X * 4) - (CHAR_X * 4))
      li t4,7 ; Reset Character X Pixel Counter
      bnez t5,DrawCharX\@ ; IF Character Y Pixel Counter != 0 GOTO DrawCharX
      subi t5,1 ; Decrement Character Y Pixel Counter

    subi t0,$4FE0 ; ((SCREEN_X * 4) * CHAR_Y) - CHAR_X * 4
    bnez t3,DrawChars\@ ; Continue to Print Characters
    subi t3,1 ; Subtract Number of Text Characters to Print
    endm

PrintValue: macro vram,xpos,ypos,fontfile,value,length ; Print HEX Chars To VRAM Using Font At X,Y Position
  lui t0,vram ; T0 = Frame Buffer Pointer
  addi t0,((xpos*4)+((640*ypos)*4)) ; Place text at XY Position
  la t1,fontfile ; T1 = Characters
  la t2,value ; T2 = Value Offset
  li t3,length ; T3 = Number of HEX Chars to Print
  DrawHEXChars\@:
    li t4,7 ; T4 = Character X Pixel Counter
    li t5,7 ; T5 = Character Y Pixel Counter

    lb t6,0(t2) ; T6 = Next 2 HEX Chars
    addi t2,1

    srl t7,t6,4 ; T7 = 2nd Nibble
    andi t7,$F
    subi t8,t7,9
    bgtz t8,HEXLetters\@
    addi t7,$30 ; Delay Slot
    j HEXEnd\@
    nop ; Delay Slot

    HEXLetters\@:
    addi t7,7
    HEXEnd\@:

    sll t7,8 ; Add Shift to Correct Position in Font (* 256)
    add t7,t1

    DrawHEXCharX\@:
      lw t8,0(t7) ; Load Font Text Character Pixel
      addi t7,4
      sw t8,0(t0) ; Store Font Text Character Pixel into Frame Buffer
      addi t0,4

      bnez t4,DrawHEXCharX\@ ; IF Character X Pixel Counter != 0 GOTO DrawCharX
      subi t4,1 ; Decrement Character X Pixel Counter

      addi t0,$9E0 ; Jump down 1 Scanline, Jump back 1 Char ((SCREEN_X * 4) - (CHAR_X * 4))
      li t4,7 ; Reset Character X Pixel Counter
      bnez t5,DrawHEXCharX\@ ; IF Character Y Pixel Counter != 0 GOTO DrawCharX
      subi t5,1 ; Decrement Character Y Pixel Counter

    subi t0,$4FE0 ; ((SCREEN_X * 4) * CHAR_Y) - CHAR_X * 4

    li t5,7 ; Reset Character Y Pixel Counter

    andi t7,t6,$F ; T7 = 1st Nibble
    subi t8,t7,9
    bgtz t8,HEXLettersB\@
    addi t7,$30 ; Delay Slot
    j HEXEndB\@
    nop ; Delay Slot

    HEXLettersB\@:
    addi t7,7
    HEXEndB\@:

    sll t7,8 ; Add Shift to Correct Position in Font (* 256)
    add t7,t1

    DrawHEXCharXB\@:
      lw t8,0(t7) ; Load Font Text Character Pixel
      addi t7,4
      sw t8,0(t0) ; Store Font Text Character Pixel into Frame Buffer
      addi t0,4

      bnez t4,DrawHEXCharXB\@ ; IF Character X Pixel Counter != 0 GOTO DrawCharX
      subi t4,1 ; Decrement Character X Pixel Counter

      addi t0,$9E0 ; Jump down 1 Scanline, Jump back 1 Char ((SCREEN_X * 4) - (CHAR_X * 4))
      li t4,7 ; Reset Character X Pixel Counter
      bnez t5,DrawHEXCharXB\@ ; IF Character Y Pixel Counter != 0 GOTO DrawCharX
      subi t5,1 ; Decrement Character Y Pixel Counter

    subi t0,$4FE0 ; ((SCREEN_X * 4) * CHAR_Y) - CHAR_X * 4

    bnez t3,DrawHEXChars\@ ; Continue to Print Characters
    subi t3,1 ; Subtract Number of Text Characters to Print
    endm

  include LIB\N64.INC ; Include N64 Definitions
  dcb 2097152,$00 ; Set ROM Size
  org $80000000 ; Entry Point Of Code
  include LIB\N64_HEADER.ASM  ; Include 64 Byte Header & Vector Table
  incbin LIB\N64_BOOTCODE.BIN ; Include 4032 Byte Boot Code

Start:
  include LIB\N64_INIT.ASM ; Include Initialisation Routine
  include LIB\N64_GFX.INC  ; Include Graphics Macros

  ScreenNTSC 640,480, BPP32|INTERLACE|AA_MODE_2, $A0100000 ; Screen NTSC: 640x480, 32BPP, Interlace, Reample Only, DRAM Origin = $A0100000

  lui t0,$A010 ; T0 = VRAM Start Offset
  addi t1,t0,((640*480*4)-4) ; T1 = VRAM End Offset
  li t2,$000000FF ; T2 = Black
ClearScreen:
  sw t2,0(t0)
  bne t0,t1,ClearScreen
  addi t0,4 ; Delay Slot




  PrintString $A010,88,8,FontRed,RTHEX,7 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,232,8,FontRed,SADEC,11 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,384,8,FontRed,RDHEX,7 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,528,8,FontRed,TEST,10 ; Print Text String To VRAM Using Font At X,Y Position


  PrintString $A010,0,16,FontBlack,PAGEBREAK,79 ; Print Text String To VRAM Using Font At X,Y Position


  PrintString $A010,8,24,FontRed,DSRL,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,VALUELONG ; T0 = Long Data Offset
  ld t0,0(t0)     ; T0 = Long Data
  dsrl t0,0 ; T0 = Test Long Data
  la t1,RDLONG ; T1 = RDLONG Offset
  sd t0,0(t1)  ; RDLONG = Long Data
  PrintString $A010,80,24,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,24,FontBlack,VALUELONG,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,24,FontBlack,TEXTLONG0,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,24,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,24,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDLONG     ; T0 = Long Data Offset
  ld t1,0(t0)      ; T1 = Long Data
  la t0,DSRLCHECK0 ; T0 = Long Check Data Offset
  ld t2,0(t0)      ; T2 = Long Check Data
  beq t1,t2,DSRLPASS0 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,24,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRLEND0
  nop ; Delay Slot
  DSRLPASS0:
  PrintString $A010,528,24,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRLEND0:

  la t0,VALUELONG ; T0 = Long Data Offset
  ld t0,0(t0)     ; T0 = Long Data
  dsrl t0,1 ; T0 = Test Long Data
  la t1,RDLONG ; T1 = RDLONG Offset
  sd t0,0(t1)  ; RDLONG = Long Data
  PrintString $A010,80,32,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,32,FontBlack,VALUELONG,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,32,FontBlack,TEXTLONG1,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,32,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,32,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDLONG     ; T0 = Long Data Offset
  ld t1,0(t0)      ; T1 = Long Data
  la t0,DSRLCHECK1 ; T0 = Long Check Data Offset
  ld t2,0(t0)      ; T2 = Long Check Data
  beq t1,t2,DSRLPASS1 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,32,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRLEND1
  nop ; Delay Slot
  DSRLPASS1:
  PrintString $A010,528,32,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRLEND1:

  la t0,VALUELONG ; T0 = Long Data Offset
  ld t0,0(t0)     ; T0 = Long Data
  dsrl t0,2 ; T0 = Test Long Data
  la t1,RDLONG ; T1 = RDLONG Offset
  sd t0,0(t1)  ; RDLONG = Long Data
  PrintString $A010,80,40,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,40,FontBlack,VALUELONG,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,40,FontBlack,TEXTLONG2,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,40,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,40,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDLONG     ; T0 = Long Data Offset
  ld t1,0(t0)      ; T1 = Long Data
  la t0,DSRLCHECK2 ; T0 = Long Check Data Offset
  ld t2,0(t0)      ; T2 = Long Check Data
  beq t1,t2,DSRLPASS2 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,40,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRLEND2
  nop ; Delay Slot
  DSRLPASS2:
  PrintString $A010,528,40,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRLEND2:

  la t0,VALUELONG ; T0 = Long Data Offset
  ld t0,0(t0)     ; T0 = Long Data
  dsrl t0,3 ; T0 = Test Long Data
  la t1,RDLONG ; T1 = RDLONG Offset
  sd t0,0(t1)  ; RDLONG = Long Data
  PrintString $A010,80,48,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,48,FontBlack,VALUELONG,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,48,FontBlack,TEXTLONG3,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,48,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,48,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDLONG     ; T0 = Long Data Offset
  ld t1,0(t0)      ; T1 = Long Data
  la t0,DSRLCHECK3 ; T0 = Long Check Data Offset
  ld t2,0(t0)      ; T2 = Long Check Data
  beq t1,t2,DSRLPASS3 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,48,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRLEND3
  nop ; Delay Slot
  DSRLPASS3:
  PrintString $A010,528,48,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRLEND3:

  la t0,VALUELONG ; T0 = Long Data Offset
  ld t0,0(t0)     ; T0 = Long Data
  dsrl t0,4 ; T0 = Test Long Data
  la t1,RDLONG ; T1 = RDLONG Offset
  sd t0,0(t1)  ; RDLONG = Long Data
  PrintString $A010,80,56,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,56,FontBlack,VALUELONG,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,56,FontBlack,TEXTLONG4,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,56,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,56,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDLONG     ; T0 = Long Data Offset
  ld t1,0(t0)      ; T1 = Long Data
  la t0,DSRLCHECK4 ; T0 = Long Check Data Offset
  ld t2,0(t0)      ; T2 = Long Check Data
  beq t1,t2,DSRLPASS4 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,56,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRLEND4
  nop ; Delay Slot
  DSRLPASS4:
  PrintString $A010,528,56,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRLEND4:

  la t0,VALUELONG ; T0 = Long Data Offset
  ld t0,0(t0)     ; T0 = Long Data
  dsrl t0,5 ; T0 = Test Long Data
  la t1,RDLONG ; T1 = RDLONG Offset
  sd t0,0(t1)  ; RDLONG = Long Data
  PrintString $A010,80,64,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,64,FontBlack,VALUELONG,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,64,FontBlack,TEXTLONG5,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,64,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,64,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDLONG     ; T0 = Long Data Offset
  ld t1,0(t0)      ; T1 = Long Data
  la t0,DSRLCHECK5 ; T0 = Long Check Data Offset
  ld t2,0(t0)      ; T2 = Long Check Data
  beq t1,t2,DSRLPASS5 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,64,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRLEND5
  nop ; Delay Slot
  DSRLPASS5:
  PrintString $A010,528,64,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRLEND5:

  la t0,VALUELONG ; T0 = Long Data Offset
  ld t0,0(t0)     ; T0 = Long Data
  dsrl t0,6 ; T0 = Test Long Data
  la t1,RDLONG ; T1 = RDLONG Offset
  sd t0,0(t1)  ; RDLONG = Long Data
  PrintString $A010,80,72,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,72,FontBlack,VALUELONG,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,72,FontBlack,TEXTLONG6,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,72,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,72,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDLONG     ; T0 = Long Data Offset
  ld t1,0(t0)      ; T1 = Long Data
  la t0,DSRLCHECK6 ; T0 = Long Check Data Offset
  ld t2,0(t0)      ; T2 = Long Check Data
  beq t1,t2,DSRLPASS6 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,72,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRLEND6
  nop ; Delay Slot
  DSRLPASS6:
  PrintString $A010,528,72,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRLEND6:

  la t0,VALUELONG ; T0 = Long Data Offset
  ld t0,0(t0)     ; T0 = Long Data
  dsrl t0,7 ; T0 = Test Long Data
  la t1,RDLONG ; T1 = RDLONG Offset
  sd t0,0(t1)  ; RDLONG = Long Data
  PrintString $A010,80,80,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,80,FontBlack,VALUELONG,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,80,FontBlack,TEXTLONG7,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,80,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,80,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDLONG     ; T0 = Long Data Offset
  ld t1,0(t0)      ; T1 = Long Data
  la t0,DSRLCHECK7 ; T0 = Long Check Data Offset
  ld t2,0(t0)      ; T2 = Long Check Data
  beq t1,t2,DSRLPASS7 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,80,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRLEND7
  nop ; Delay Slot
  DSRLPASS7:
  PrintString $A010,528,80,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRLEND7:

  la t0,VALUELONG ; T0 = Long Data Offset
  ld t0,0(t0)     ; T0 = Long Data
  dsrl t0,8 ; T0 = Test Long Data
  la t1,RDLONG ; T1 = RDLONG Offset
  sd t0,0(t1)  ; RDLONG = Long Data
  PrintString $A010,80,88,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,88,FontBlack,VALUELONG,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,88,FontBlack,TEXTLONG8,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,88,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,88,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDLONG     ; T0 = Long Data Offset
  ld t1,0(t0)      ; T1 = Long Data
  la t0,DSRLCHECK8 ; T0 = Long Check Data Offset
  ld t2,0(t0)      ; T2 = Long Check Data
  beq t1,t2,DSRLPASS8 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,88,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRLEND8
  nop ; Delay Slot
  DSRLPASS8:
  PrintString $A010,528,88,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRLEND8:

  la t0,VALUELONG ; T0 = Long Data Offset
  ld t0,0(t0)     ; T0 = Long Data
  dsrl t0,9 ; T0 = Test Long Data
  la t1,RDLONG ; T1 = RDLONG Offset
  sd t0,0(t1)  ; RDLONG = Long Data
  PrintString $A010,80,96,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,96,FontBlack,VALUELONG,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,96,FontBlack,TEXTLONG9,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,96,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,96,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDLONG     ; T0 = Long Data Offset
  ld t1,0(t0)      ; T1 = Long Data
  la t0,DSRLCHECK9 ; T0 = Long Check Data Offset
  ld t2,0(t0)      ; T2 = Long Check Data
  beq t1,t2,DSRLPASS9 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,96,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRLEND9
  nop ; Delay Slot
  DSRLPASS9:
  PrintString $A010,528,96,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRLEND9:

  la t0,VALUELONG ; T0 = Long Data Offset
  ld t0,0(t0)     ; T0 = Long Data
  dsrl t0,10 ; T0 = Test Long Data
  la t1,RDLONG ; T1 = RDLONG Offset
  sd t0,0(t1)  ; RDLONG = Long Data
  PrintString $A010,80,104,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,104,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,104,FontBlack,TEXTLONG10,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,104,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,104,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDLONG      ; T0 = Long Data Offset
  ld t1,0(t0)       ; T1 = Long Data
  la t0,DSRLCHECK10 ; T0 = Long Check Data Offset
  ld t2,0(t0)       ; T2 = Long Check Data
  beq t1,t2,DSRLPASS10 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,104,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRLEND10
  nop ; Delay Slot
  DSRLPASS10:
  PrintString $A010,528,104,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRLEND10:

  la t0,VALUELONG ; T0 = Long Data Offset
  ld t0,0(t0)     ; T0 = Long Data
  dsrl t0,11 ; T0 = Test Long Data
  la t1,RDLONG ; T1 = RDLONG Offset
  sd t0,0(t1)  ; RDLONG = Long Data
  PrintString $A010,80,112,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,112,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,112,FontBlack,TEXTLONG11,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,112,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,112,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDLONG      ; T0 = Long Data Offset
  ld t1,0(t0)       ; T1 = Long Data
  la t0,DSRLCHECK11 ; T0 = Long Check Data Offset
  ld t2,0(t0)       ; T2 = Long Check Data
  beq t1,t2,DSRLPASS11 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,112,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRLEND11
  nop ; Delay Slot
  DSRLPASS11:
  PrintString $A010,528,112,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRLEND11:

  la t0,VALUELONG ; T0 = Long Data Offset
  ld t0,0(t0)     ; T0 = Long Data
  dsrl t0,12 ; T0 = Test Long Data
  la t1,RDLONG ; T1 = RDLONG Offset
  sd t0,0(t1)  ; RDLONG = Long Data
  PrintString $A010,80,120,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,120,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,120,FontBlack,TEXTLONG12,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,120,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,120,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDLONG      ; T0 = Long Data Offset
  ld t1,0(t0)       ; T1 = Long Data
  la t0,DSRLCHECK12 ; T0 = Long Check Data Offset
  ld t2,0(t0)       ; T2 = Long Check Data
  beq t1,t2,DSRLPASS12 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,120,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRLEND12
  nop ; Delay Slot
  DSRLPASS12:
  PrintString $A010,528,120,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRLEND12:

  la t0,VALUELONG ; T0 = Long Data Offset
  ld t0,0(t0)     ; T0 = Long Data
  dsrl t0,13 ; T0 = Test Long Data
  la t1,RDLONG ; T1 = RDLONG Offset
  sd t0,0(t1)  ; RDLONG = Long Data
  PrintString $A010,80,128,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,128,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,128,FontBlack,TEXTLONG13,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,128,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,128,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDLONG      ; T0 = Long Data Offset
  ld t1,0(t0)       ; T1 = Long Data
  la t0,DSRLCHECK13 ; T0 = Long Check Data Offset
  ld t2,0(t0)       ; T2 = Long Check Data
  beq t1,t2,DSRLPASS13 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,128,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRLEND13
  nop ; Delay Slot
  DSRLPASS13:
  PrintString $A010,528,128,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRLEND13:

  la t0,VALUELONG ; T0 = Long Data Offset
  ld t0,0(t0)     ; T0 = Long Data
  dsrl t0,14 ; T0 = Test Long Data
  la t1,RDLONG ; T1 = RDLONG Offset
  sd t0,0(t1)  ; RDLONG = Long Data
  PrintString $A010,80,136,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,136,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,136,FontBlack,TEXTLONG14,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,136,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,136,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDLONG      ; T0 = Long Data Offset
  ld t1,0(t0)       ; T1 = Long Data
  la t0,DSRLCHECK14 ; T0 = Long Check Data Offset
  ld t2,0(t0)       ; T2 = Long Check Data
  beq t1,t2,DSRLPASS14 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,136,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRLEND14
  nop ; Delay Slot
  DSRLPASS14:
  PrintString $A010,528,136,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRLEND14:

  la t0,VALUELONG ; T0 = Long Data Offset
  ld t0,0(t0)     ; T0 = Long Data
  dsrl t0,15 ; T0 = Test Long Data
  la t1,RDLONG ; T1 = RDLONG Offset
  sd t0,0(t1)  ; RDLONG = Long Data
  PrintString $A010,80,144,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,144,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,144,FontBlack,TEXTLONG15,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,144,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,144,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDLONG      ; T0 = Long Data Offset
  ld t1,0(t0)       ; T1 = Long Data
  la t0,DSRLCHECK15 ; T0 = Long Check Data Offset
  ld t2,0(t0)       ; T2 = Long Check Data
  beq t1,t2,DSRLPASS15 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,144,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRLEND15
  nop ; Delay Slot
  DSRLPASS15:
  PrintString $A010,528,144,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRLEND15:

  la t0,VALUELONG ; T0 = Long Data Offset
  ld t0,0(t0)     ; T0 = Long Data
  dsrl t0,16 ; T0 = Test Long Data
  la t1,RDLONG ; T1 = RDLONG Offset
  sd t0,0(t1)  ; RDLONG = Long Data
  PrintString $A010,80,152,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,152,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,152,FontBlack,TEXTLONG16,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,152,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,152,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDLONG      ; T0 = Long Data Offset
  ld t1,0(t0)       ; T1 = Long Data
  la t0,DSRLCHECK16 ; T0 = Long Check Data Offset
  ld t2,0(t0)       ; T2 = Long Check Data
  beq t1,t2,DSRLPASS16 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,152,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRLEND16
  nop ; Delay Slot
  DSRLPASS16:
  PrintString $A010,528,152,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRLEND16:

  la t0,VALUELONG ; T0 = Long Data Offset
  ld t0,0(t0)     ; T0 = Long Data
  dsrl t0,17 ; T0 = Test Long Data
  la t1,RDLONG ; T1 = RDLONG Offset
  sd t0,0(t1)  ; RDLONG = Long Data
  PrintString $A010,80,160,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,160,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,160,FontBlack,TEXTLONG17,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,160,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,160,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDLONG      ; T0 = Long Data Offset
  ld t1,0(t0)       ; T1 = Long Data
  la t0,DSRLCHECK17 ; T0 = Long Check Data Offset
  ld t2,0(t0)       ; T2 = Long Check Data
  beq t1,t2,DSRLPASS17 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,160,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRLEND17
  nop ; Delay Slot
  DSRLPASS17:
  PrintString $A010,528,160,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRLEND17:

  la t0,VALUELONG ; T0 = Long Data Offset
  ld t0,0(t0)     ; T0 = Long Data
  dsrl t0,18 ; T0 = Test Long Data
  la t1,RDLONG ; T1 = RDLONG Offset
  sd t0,0(t1)  ; RDLONG = Long Data
  PrintString $A010,80,168,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,168,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,168,FontBlack,TEXTLONG18,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,168,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,168,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDLONG      ; T0 = Long Data Offset
  ld t1,0(t0)       ; T1 = Long Data
  la t0,DSRLCHECK18 ; T0 = Long Check Data Offset
  ld t2,0(t0)       ; T2 = Long Check Data
  beq t1,t2,DSRLPASS18 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,168,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRLEND18
  nop ; Delay Slot
  DSRLPASS18:
  PrintString $A010,528,168,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRLEND18:

  la t0,VALUELONG ; T0 = Long Data Offset
  ld t0,0(t0)     ; T0 = Long Data
  dsrl t0,19 ; T0 = Test Long Data
  la t1,RDLONG ; T1 = RDLONG Offset
  sd t0,0(t1)  ; RDLONG = Long Data
  PrintString $A010,80,176,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,176,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,176,FontBlack,TEXTLONG19,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,176,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,176,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDLONG      ; T0 = Long Data Offset
  ld t1,0(t0)       ; T1 = Long Data
  la t0,DSRLCHECK19 ; T0 = Long Check Data Offset
  ld t2,0(t0)       ; T2 = Long Check Data
  beq t1,t2,DSRLPASS19 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,176,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRLEND19
  nop ; Delay Slot
  DSRLPASS19:
  PrintString $A010,528,176,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRLEND19:

  la t0,VALUELONG ; T0 = Long Data Offset
  ld t0,0(t0)     ; T0 = Long Data
  dsrl t0,20 ; T0 = Test Long Data
  la t1,RDLONG ; T1 = RDLONG Offset
  sd t0,0(t1)  ; RDLONG = Long Data
  PrintString $A010,80,184,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,184,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,184,FontBlack,TEXTLONG20,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,184,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,184,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDLONG      ; T0 = Long Data Offset
  ld t1,0(t0)       ; T1 = Long Data
  la t0,DSRLCHECK20 ; T0 = Long Check Data Offset
  ld t2,0(t0)       ; T2 = Long Check Data
  beq t1,t2,DSRLPASS20 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,184,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRLEND20
  nop ; Delay Slot
  DSRLPASS20:
  PrintString $A010,528,184,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRLEND20:

  la t0,VALUELONG ; T0 = Long Data Offset
  ld t0,0(t0)     ; T0 = Long Data
  dsrl t0,21 ; T0 = Test Long Data
  la t1,RDLONG ; T1 = RDLONG Offset
  sd t0,0(t1)  ; RDLONG = Long Data
  PrintString $A010,80,192,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,192,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,192,FontBlack,TEXTLONG21,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,192,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,192,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDLONG      ; T0 = Long Data Offset
  ld t1,0(t0)       ; T1 = Long Data
  la t0,DSRLCHECK21 ; T0 = Long Check Data Offset
  ld t2,0(t0)       ; T2 = Long Check Data
  beq t1,t2,DSRLPASS21 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,192,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRLEND21
  nop ; Delay Slot
  DSRLPASS21:
  PrintString $A010,528,192,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRLEND21:

  la t0,VALUELONG ; T0 = Long Data Offset
  ld t0,0(t0)     ; T0 = Long Data
  dsrl t0,22 ; T0 = Test Long Data
  la t1,RDLONG ; T1 = RDLONG Offset
  sd t0,0(t1)  ; RDLONG = Long Data
  PrintString $A010,80,200,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,200,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,200,FontBlack,TEXTLONG22,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,200,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,200,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDLONG      ; T0 = Long Data Offset
  ld t1,0(t0)       ; T1 = Long Data
  la t0,DSRLCHECK22 ; T0 = Long Check Data Offset
  ld t2,0(t0)       ; T2 = Long Check Data
  beq t1,t2,DSRLPASS22 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,200,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRLEND22
  nop ; Delay Slot
  DSRLPASS22:
  PrintString $A010,528,200,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRLEND22:

  la t0,VALUELONG ; T0 = Long Data Offset
  ld t0,0(t0)     ; T0 = Long Data
  dsrl t0,23 ; T0 = Test Long Data
  la t1,RDLONG ; T1 = RDLONG Offset
  sd t0,0(t1)  ; RDLONG = Long Data
  PrintString $A010,80,208,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,208,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,208,FontBlack,TEXTLONG23,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,208,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,208,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDLONG      ; T0 = Long Data Offset
  ld t1,0(t0)       ; T1 = Long Data
  la t0,DSRLCHECK23 ; T0 = Long Check Data Offset
  ld t2,0(t0)       ; T2 = Long Check Data
  beq t1,t2,DSRLPASS23 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,208,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRLEND23
  nop ; Delay Slot
  DSRLPASS23:
  PrintString $A010,528,208,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRLEND23:

  la t0,VALUELONG ; T0 = Long Data Offset
  ld t0,0(t0)     ; T0 = Long Data
  dsrl t0,24 ; T0 = Test Long Data
  la t1,RDLONG ; T1 = RDLONG Offset
  sd t0,0(t1)  ; RDLONG = Long Data
  PrintString $A010,80,216,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,216,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,216,FontBlack,TEXTLONG24,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,216,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,216,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDLONG      ; T0 = Long Data Offset
  ld t1,0(t0)       ; T1 = Long Data
  la t0,DSRLCHECK24 ; T0 = Long Check Data Offset
  ld t2,0(t0)       ; T2 = Long Check Data
  beq t1,t2,DSRLPASS24 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,216,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRLEND24
  nop ; Delay Slot
  DSRLPASS24:
  PrintString $A010,528,216,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRLEND24:

  la t0,VALUELONG ; T0 = Long Data Offset
  ld t0,0(t0)     ; T0 = Long Data
  dsrl t0,25 ; T0 = Test Long Data
  la t1,RDLONG ; T1 = RDLONG Offset
  sd t0,0(t1)  ; RDLONG = Long Data
  PrintString $A010,80,224,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,224,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,224,FontBlack,TEXTLONG25,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,224,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,224,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDLONG      ; T0 = Long Data Offset
  ld t1,0(t0)       ; T1 = Long Data
  la t0,DSRLCHECK25 ; T0 = Long Check Data Offset
  ld t2,0(t0)       ; T2 = Long Check Data
  beq t1,t2,DSRLPASS25 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,224,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRLEND25
  nop ; Delay Slot
  DSRLPASS25:
  PrintString $A010,528,224,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRLEND25:

  la t0,VALUELONG ; T0 = Long Data Offset
  ld t0,0(t0)     ; T0 = Long Data
  dsrl t0,26 ; T0 = Test Long Data
  la t1,RDLONG ; T1 = RDLONG Offset
  sd t0,0(t1)  ; RDLONG = Long Data
  PrintString $A010,80,232,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,232,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,232,FontBlack,TEXTLONG26,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,232,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,232,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDLONG      ; T0 = Long Data Offset
  ld t1,0(t0)       ; T1 = Long Data
  la t0,DSRLCHECK26 ; T0 = Long Check Data Offset
  ld t2,0(t0)       ; T2 = Long Check Data
  beq t1,t2,DSRLPASS26 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,232,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRLEND26
  nop ; Delay Slot
  DSRLPASS26:
  PrintString $A010,528,232,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRLEND26:

  la t0,VALUELONG ; T0 = Long Data Offset
  ld t0,0(t0)     ; T0 = Long Data
  dsrl t0,27 ; T0 = Test Long Data
  la t1,RDLONG ; T1 = RDLONG Offset
  sd t0,0(t1)  ; RDLONG = Long Data
  PrintString $A010,80,240,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,240,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,240,FontBlack,TEXTLONG27,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,240,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,240,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDLONG      ; T0 = Long Data Offset
  ld t1,0(t0)       ; T1 = Long Data
  la t0,DSRLCHECK27 ; T0 = Long Check Data Offset
  ld t2,0(t0)       ; T2 = Long Check Data
  beq t1,t2,DSRLPASS27 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,240,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRLEND27
  nop ; Delay Slot
  DSRLPASS27:
  PrintString $A010,528,240,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRLEND27:

  la t0,VALUELONG ; T0 = Long Data Offset
  ld t0,0(t0)     ; T0 = Long Data
  dsrl t0,28 ; T0 = Test Long Data
  la t1,RDLONG ; T1 = RDLONG Offset
  sd t0,0(t1)  ; RDLONG = Long Data
  PrintString $A010,80,248,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,248,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,248,FontBlack,TEXTLONG28,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,248,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,248,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDLONG      ; T0 = Long Data Offset
  ld t1,0(t0)       ; T1 = Long Data
  la t0,DSRLCHECK28 ; T0 = Long Check Data Offset
  ld t2,0(t0)       ; T2 = Long Check Data
  beq t1,t2,DSRLPASS28 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,248,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRLEND28
  nop ; Delay Slot
  DSRLPASS28:
  PrintString $A010,528,248,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRLEND28:

  la t0,VALUELONG ; T0 = Long Data Offset
  ld t0,0(t0)     ; T0 = Long Data
  dsrl t0,29 ; T0 = Test Long Data
  la t1,RDLONG ; T1 = RDLONG Offset
  sd t0,0(t1)  ; RDLONG = Long Data
  PrintString $A010,80,256,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,256,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,256,FontBlack,TEXTLONG29,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,256,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,256,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDLONG      ; T0 = Long Data Offset
  ld t1,0(t0)       ; T1 = Long Data
  la t0,DSRLCHECK29 ; T0 = Long Check Data Offset
  ld t2,0(t0)       ; T2 = Long Check Data
  beq t1,t2,DSRLPASS29 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,256,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRLEND29
  nop ; Delay Slot
  DSRLPASS29:
  PrintString $A010,528,256,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRLEND29:

  la t0,VALUELONG ; T0 = Long Data Offset
  ld t0,0(t0)     ; T0 = Long Data
  dsrl t0,30 ; T0 = Test Long Data
  la t1,RDLONG ; T1 = RDLONG Offset
  sd t0,0(t1)  ; RDLONG = Long Data
  PrintString $A010,80,264,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,264,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,264,FontBlack,TEXTLONG30,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,264,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,264,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDLONG      ; T0 = Long Data Offset
  ld t1,0(t0)       ; T1 = Long Data
  la t0,DSRLCHECK30 ; T0 = Long Check Data Offset
  ld t2,0(t0)       ; T2 = Long Check Data
  beq t1,t2,DSRLPASS30 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,264,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRLEND30
  nop ; Delay Slot
  DSRLPASS30:
  PrintString $A010,528,264,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRLEND30:

  la t0,VALUELONG ; T0 = Long Data Offset
  ld t0,0(t0)     ; T0 = Long Data
  dsrl t0,31 ; T0 = Test Long Data
  la t1,RDLONG ; T1 = RDLONG Offset
  sd t0,0(t1)  ; RDLONG = Long Data
  PrintString $A010,80,272,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,272,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,272,FontBlack,TEXTLONG31,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,272,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,272,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDLONG      ; T0 = Long Data Offset
  ld t1,0(t0)       ; T1 = Long Data
  la t0,DSRLCHECK31 ; T0 = Long Check Data Offset
  ld t2,0(t0)       ; T2 = Long Check Data
  beq t1,t2,DSRLPASS31 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,272,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRLEND31
  nop ; Delay Slot
  DSRLPASS31:
  PrintString $A010,528,272,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRLEND31:


  PrintString $A010,0,280,FontBlack,PAGEBREAK,79 ; Print Text String To VRAM Using Font At X,Y Position


  lui t0,VI_BASE ; Load VI Base Register
Loop:
  WaitScanline $200 ; Wait For Scanline To Reach Vertical Blank
  WaitScanline $202

  li t1,$00000800 ; Even Field
  sw t1,VI_Y_SCALE(t0)

  WaitScanline $200 ; Wait For Scanline To Reach Vertical Blank
  WaitScanline $202

  li t1,$02000800 ; Odd Field
  sw t1,VI_Y_SCALE(t0)

  j Loop
  nop ; Delay Slot

DSRL: db "DSRL"

RDHEX: db "RD (Hex)"
RTHEX: db "RT (Hex)"
SADEC: db "SA (Decimal)"
TEST: db "Test Result"
FAIL: db "FAIL"
PASS: db "PASS"

DOLLAR: db "$"

TEXTLONG0: db "0"
TEXTLONG1: db "1"
TEXTLONG2: db "2"
TEXTLONG3: db "3"
TEXTLONG4: db "4"
TEXTLONG5: db "5"
TEXTLONG6: db "6"
TEXTLONG7: db "7"
TEXTLONG8: db "8"
TEXTLONG9: db "9"
TEXTLONG10: db "10"
TEXTLONG11: db "11"
TEXTLONG12: db "12"
TEXTLONG13: db "13"
TEXTLONG14: db "14"
TEXTLONG15: db "15"
TEXTLONG16: db "16"
TEXTLONG17: db "17"
TEXTLONG18: db "18"
TEXTLONG19: db "19"
TEXTLONG20: db "20"
TEXTLONG21: db "21"
TEXTLONG22: db "22"
TEXTLONG23: db "23"
TEXTLONG24: db "24"
TEXTLONG25: db "25"
TEXTLONG26: db "26"
TEXTLONG27: db "27"
TEXTLONG28: db "28"
TEXTLONG29: db "29"
TEXTLONG30: db "30"
TEXTLONG31: db "31"

PAGEBREAK: db "--------------------------------------------------------------------------------"

  align 8 ; Align 64-bit
VALUELONG: data -123456789123456789

DSRLCHECK0:  data $FE4964B4532FA0EB
DSRLCHECK1:  data $7F24B25A2997D075
DSRLCHECK2:  data $3F92592D14CBE83A
DSRLCHECK3:  data $1FC92C968A65F41D
DSRLCHECK4:  data $0FE4964B4532FA0E
DSRLCHECK5:  data $07F24B25A2997D07
DSRLCHECK6:  data $03F92592D14CBE83
DSRLCHECK7:  data $01FC92C968A65F41
DSRLCHECK8:  data $00FE4964B4532FA0
DSRLCHECK9:  data $007F24B25A2997D0
DSRLCHECK10: data $003F92592D14CBE8
DSRLCHECK11: data $001FC92C968A65F4
DSRLCHECK12: data $000FE4964B4532FA
DSRLCHECK13: data $0007F24B25A2997D
DSRLCHECK14: data $0003F92592D14CBE
DSRLCHECK15: data $0001FC92C968A65F
DSRLCHECK16: data $0000FE4964B4532F
DSRLCHECK17: data $00007F24B25A2997
DSRLCHECK18: data $00003F92592D14CB
DSRLCHECK19: data $00001FC92C968A65
DSRLCHECK20: data $00000FE4964B4532
DSRLCHECK21: data $000007F24B25A299
DSRLCHECK22: data $000003F92592D14C
DSRLCHECK23: data $000001FC92C968A6
DSRLCHECK24: data $000000FE4964B453
DSRLCHECK25: data $0000007F24B25A29
DSRLCHECK26: data $0000003F92592D14
DSRLCHECK27: data $0000001FC92C968A
DSRLCHECK28: data $0000000FE4964B45
DSRLCHECK29: data $00000007F24B25A2
DSRLCHECK30: data $00000003F92592D1
DSRLCHECK31: data $00000001FC92C968

RDLONG: data 0

FontBlack: incbin FontBlack8x8.bin
FontGreen: incbin FontGreen8x8.bin
FontRed: incbin FontRed8x8.bin