; N64 'Bare Metal' CPU Doubleword Shift Right Arithmetic Variable (0..63) Test Demo by krom (Peter Lemon):
  include LIB\N64.INC ; Include N64 Definitions
  dcb 1052672,$00 ; Set ROM Size
  org $80000000 ; Entry Point Of Code
  include LIB\N64_HEADER.ASM  ; Include 64 Byte Header & Vector Table
  incbin LIB\N64_BOOTCODE.BIN ; Include 4032 Byte Boot Code

PrintString: macro vram, xpos, ypos, fontfile, string, length ; Print Text String To VRAM Using Font At X,Y Position
  lui a0,vram ; A0 = Frame Buffer Pointer
  addi a0,((xpos*4)+((640*ypos)*4)) ; Place text at XY Position
  la a1,fontfile ; A1 = Characters
  la a2,string ; A2 = Text Offset
  li t0,length ; T0 = Number of Text Characters to Print
  DrawChars\@:
    li t1,7 ; T1 = Character X Pixel Counter
    li t2,7 ; T2 = Character Y Pixel Counter

    lb t3,0(a2) ; T3 = Next Text Character
    addi a2,1

    sll t3,8 ; Add Shift to Correct Position in Font (* 256)
    add t3,a1

    DrawCharX\@:
      lw t4,0(t3) ; Load Font Text Character Pixel
      addi t3,4
      sw t4,0(a0) ; Store Font Text Character Pixel into Frame Buffer
      addi a0,4

      bnez t1,DrawCharX\@ ; IF Character X Pixel Counter != 0 GOTO DrawCharX
      subi t1,1 ; Decrement Character X Pixel Counter

      addi a0,$9E0 ; Jump down 1 Scanline, Jump back 1 Char ((SCREEN_X * 4) - (CHAR_X * 4))
      li t1,7 ; Reset Character X Pixel Counter
      bnez t2,DrawCharX\@ ; IF Character Y Pixel Counter != 0 GOTO DrawCharX
      subi t2,1 ; Decrement Character Y Pixel Counter

    subi a0,$4FE0 ; ((SCREEN_X * 4) * CHAR_Y) - CHAR_X * 4
    bnez t0,DrawChars\@ ; Continue to Print Characters
    subi t0,1 ; Subtract Number of Text Characters to Print
    endm

PrintValue: macro vram, xpos, ypos, fontfile, value, length ; Print HEX Chars To VRAM Using Font At X,Y Position
  lui a0,vram ; A0 = Frame Buffer Pointer
  addi a0,((xpos*4)+((640*ypos)*4)) ; Place text at XY Position
  la a1,fontfile ; A1 = Characters
  la a2,value ; A2 = Value Offset
  li t0,length ; T0 = Number of HEX Chars to Print
  DrawHEXChars\@:
    li t1,7 ; T1 = Character X Pixel Counter
    li t2,7 ; T2 = Character Y Pixel Counter

    lb t3,0(a2) ; T3 = Next 2 HEX Chars
    addi a2,1

    srl t4,t3,4 ; T4 = 2nd Nibble
    andi t4,$F
    subi t5,t4,9
    bgtz t5,HEXLetters\@
    addi t4,$30 ; Delay Slot
    j HEXEnd\@
    nop ; Delay Slot

    HEXLetters\@:
    addi t4,7
    HEXEnd\@:

    sll t4,8 ; Add Shift to Correct Position in Font (* 256)
    add t4,a1

    DrawHEXCharX\@:
      lw t5,0(t4) ; Load Font Text Character Pixel
      addi t4,4
      sw t5,0(a0) ; Store Font Text Character Pixel into Frame Buffer
      addi a0,4

      bnez t1,DrawHEXCharX\@ ; IF Character X Pixel Counter != 0 GOTO DrawCharX
      subi t1,1 ; Decrement Character X Pixel Counter

      addi a0,$9E0 ; Jump down 1 Scanline, Jump back 1 Char ((SCREEN_X * 4) - (CHAR_X * 4))
      li t1,7 ; Reset Character X Pixel Counter
      bnez t2,DrawHEXCharX\@ ; IF Character Y Pixel Counter != 0 GOTO DrawCharX
      subi t2,1 ; Decrement Character Y Pixel Counter

    subi a0,$4FE0 ; ((SCREEN_X * 4) * CHAR_Y) - CHAR_X * 4

    li t2,7 ; Reset Character Y Pixel Counter

    andi t4,t3,$F ; T4 = 1st Nibble
    subi t5,t4,9
    bgtz t5,HEXLettersB\@
    addi t4,$30 ; Delay Slot
    j HEXEndB\@
    nop ; Delay Slot

    HEXLettersB\@:
    addi t4,7
    HEXEndB\@:

    sll t4,8 ; Add Shift to Correct Position in Font (* 256)
    add t4,a1

    DrawHEXCharXB\@:
      lw t5,0(t4) ; Load Font Text Character Pixel
      addi t4,4
      sw t5,0(a0) ; Store Font Text Character Pixel into Frame Buffer
      addi a0,4

      bnez t1,DrawHEXCharXB\@ ; IF Character X Pixel Counter != 0 GOTO DrawCharX
      subi t1,1 ; Decrement Character X Pixel Counter

      addi a0,$9E0 ; Jump down 1 Scanline, Jump back 1 Char ((SCREEN_X * 4) - (CHAR_X * 4))
      li t1,7 ; Reset Character X Pixel Counter
      bnez t2,DrawHEXCharXB\@ ; IF Character Y Pixel Counter != 0 GOTO DrawCharX
      subi t2,1 ; Decrement Character Y Pixel Counter

    subi a0,$4FE0 ; ((SCREEN_X * 4) * CHAR_Y) - CHAR_X * 4

    bnez t0,DrawHEXChars\@ ; Continue to Print Characters
    subi t0,1 ; Subtract Number of Text Characters to Print
    endm

Start:
  include LIB\N64_GFX.INC ; Include Graphics Macros
  N64_INIT ; Run N64 Initialisation Routine

  ScreenNTSC 640, 480, BPP32|INTERLACE|AA_MODE_2, $A0100000 ; Screen NTSC: 640x480, 32BPP, Interlace, Reample Only, DRAM Origin = $A0100000

  lui a0,$A010 ; A0 = VRAM Start Offset
  addi a1,a0,((640*480*4)-4) ; A1 = VRAM End Offset
  li t0,$000000FF ; T0 = Black
ClearScreen:
  sw t0,0(a0)
  bne a0,a1,ClearScreen
  addi a0,4 ; Delay Slot


  PrintString $A010,88,8,FontRed,RTHEX,7 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,232,8,FontRed,RSDEC,11 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,384,8,FontRed,RDHEX,7 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,528,8,FontRed,TEST,10 ; Print Text String To VRAM Using Font At X,Y Position


  PrintString $A010,0,16,FontBlack,PAGEBREAK,79 ; Print Text String To VRAM Using Font At X,Y Position


  PrintString $A010,8,24,FontRed,DSRAV,4 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,1     ; T1 = Shift Amount
  dsrav t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,24,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,24,FontBlack,VALUELONG,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,24,FontBlack,TEXTLONG0,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,24,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,24,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG      ; A0 = Long Data Offset
  ld t0,0(a0)       ; T0 = Long Data
  la a0,DSRAVCHECK0 ; A0 = Long Check Data Offset
  ld t1,0(a0)       ; T1 = Long Check Data
  beq t0,t1,DSRAVPASS0 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,24,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND0
  nop ; Delay Slot
  DSRAVPASS0:
  PrintString $A010,528,24,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND0:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,3     ; T1 = Shift Amount
  dsrav t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,32,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,32,FontBlack,VALUELONG,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,32,FontBlack,TEXTLONG1,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,32,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,32,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG      ; A0 = Long Data Offset
  ld t0,0(a0)       ; T0 = Long Data
  la a0,DSRAVCHECK1 ; A0 = Long Check Data Offset
  ld t1,0(a0)       ; T1 = Long Check Data
  beq t0,t1,DSRAVPASS1 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,32,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND1
  nop ; Delay Slot
  DSRAVPASS1:
  PrintString $A010,528,32,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND1:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,5     ; T1 = Shift Amount
  dsrav t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,40,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,40,FontBlack,VALUELONG,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,40,FontBlack,TEXTLONG2,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,40,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,40,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG      ; A0 = Long Data Offset
  ld t0,0(a0)       ; T0 = Long Data
  la a0,DSRAVCHECK2 ; A0 = Long Check Data Offset
  ld t1,0(a0)       ; T1 = Long Check Data
  beq t0,t1,DSRAVPASS2 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,40,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND2
  nop ; Delay Slot
  DSRAVPASS2:
  PrintString $A010,528,40,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND2:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,7     ; T1 = Shift Amount
  dsrav t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,48,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,48,FontBlack,VALUELONG,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,48,FontBlack,TEXTLONG3,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,48,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,48,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG      ; A0 = Long Data Offset
  ld t0,0(a0)       ; T0 = Long Data
  la a0,DSRAVCHECK3 ; A0 = Long Check Data Offset
  ld t1,0(a0)       ; T1 = Long Check Data
  beq t0,t1,DSRAVPASS3 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,48,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND3
  nop ; Delay Slot
  DSRAVPASS3:
  PrintString $A010,528,48,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND3:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,9     ; T1 = Shift Amount
  dsrav t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,56,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,56,FontBlack,VALUELONG,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,56,FontBlack,TEXTLONG4,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,56,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,56,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG      ; A0 = Long Data Offset
  ld t0,0(a0)       ; T0 = Long Data
  la a0,DSRAVCHECK4 ; A0 = Long Check Data Offset
  ld t1,0(a0)       ; T1 = Long Check Data
  beq t0,t1,DSRAVPASS4 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,56,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND4
  nop ; Delay Slot
  DSRAVPASS4:
  PrintString $A010,528,56,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND4:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,11    ; T1 = Shift Amount
  dsrav t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,64,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,64,FontBlack,VALUELONG,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,64,FontBlack,TEXTLONG5,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,64,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,64,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG      ; A0 = Long Data Offset
  ld t0,0(a0)       ; T0 = Long Data
  la a0,DSRAVCHECK5 ; A0 = Long Check Data Offset
  ld t1,0(a0)       ; T1 = Long Check Data
  beq t0,t1,DSRAVPASS5 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,64,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND5
  nop ; Delay Slot
  DSRAVPASS5:
  PrintString $A010,528,64,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND5:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,13    ; T1 = Shift Amount
  dsrav t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,72,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,72,FontBlack,VALUELONG,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,72,FontBlack,TEXTLONG6,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,72,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,72,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG      ; A0 = Long Data Offset
  ld t0,0(a0)       ; T0 = Long Data
  la a0,DSRAVCHECK6 ; A0 = Long Check Data Offset
  ld t1,0(a0)       ; T1 = Long Check Data
  beq t0,t1,DSRAVPASS6 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,72,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND6
  nop ; Delay Slot
  DSRAVPASS6:
  PrintString $A010,528,72,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND6:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,15    ; T1 = Shift Amount
  dsrav t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,80,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,80,FontBlack,VALUELONG,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,80,FontBlack,TEXTLONG7,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,80,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,80,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG      ; A0 = Long Data Offset
  ld t0,0(a0)       ; T0 = Long Data
  la a0,DSRAVCHECK7 ; A0 = Long Check Data Offset
  ld t1,0(a0)       ; T1 = Long Check Data
  beq t0,t1,DSRAVPASS7 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,80,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND7
  nop ; Delay Slot
  DSRAVPASS7:
  PrintString $A010,528,80,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND7:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,17    ; T1 = Shift Amount
  dsrav t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,88,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,88,FontBlack,VALUELONG,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,88,FontBlack,TEXTLONG8,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,88,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,88,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG      ; A0 = Long Data Offset
  ld t0,0(a0)       ; T0 = Long Data
  la a0,DSRAVCHECK8 ; A0 = Long Check Data Offset
  ld t1,0(a0)       ; T1 = Long Check Data
  beq t0,t1,DSRAVPASS8 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,88,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND8
  nop ; Delay Slot
  DSRAVPASS8:
  PrintString $A010,528,88,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND8:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,19    ; T1 = Shift Amount
  dsrav t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,96,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,96,FontBlack,VALUELONG,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,96,FontBlack,TEXTLONG9,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,96,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,96,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG      ; A0 = Long Data Offset
  ld t0,0(a0)       ; T0 = Long Data
  la a0,DSRAVCHECK9 ; A0 = Long Check Data Offset
  ld t1,0(a0)       ; T1 = Long Check Data
  beq t0,t1,DSRAVPASS9 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,96,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND9
  nop ; Delay Slot
  DSRAVPASS9:
  PrintString $A010,528,96,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND9:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,21    ; T1 = Shift Amount
  dsrav t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,104,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,104,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,104,FontBlack,TEXTLONG10,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,104,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,104,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,DSRAVCHECK10 ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,DSRAVPASS10 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,104,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND10
  nop ; Delay Slot
  DSRAVPASS10:
  PrintString $A010,528,104,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND10:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,23    ; T1 = Shift Amount
  dsrav t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,112,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,112,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,112,FontBlack,TEXTLONG11,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,112,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,112,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,DSRAVCHECK11 ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,DSRAVPASS11 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,112,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND11
  nop ; Delay Slot
  DSRAVPASS11:
  PrintString $A010,528,112,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND11:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,25    ; T1 = Shift Amount
  dsrav t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,120,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,120,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,120,FontBlack,TEXTLONG12,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,120,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,120,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,DSRAVCHECK12 ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,DSRAVPASS12 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,120,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND12
  nop ; Delay Slot
  DSRAVPASS12:
  PrintString $A010,528,120,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND12:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,27    ; T1 = Shift Amount
  dsrav t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,128,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,128,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,128,FontBlack,TEXTLONG13,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,128,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,128,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,DSRAVCHECK13 ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,DSRAVPASS13 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,128,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND13
  nop ; Delay Slot
  DSRAVPASS13:
  PrintString $A010,528,128,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND13:

  la a0,VALUELONG ; T0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,29    ; T1 = Shift Amount
  dsrav t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; T1 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,136,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,136,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,136,FontBlack,TEXTLONG14,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,136,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,136,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,DSRAVCHECK14 ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,DSRAVPASS14 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,136,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND14
  nop ; Delay Slot
  DSRAVPASS14:
  PrintString $A010,528,136,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND14:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,31    ; T1 = Shift Amount
  dsrav t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,144,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,144,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,144,FontBlack,TEXTLONG15,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,144,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,144,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,DSRAVCHECK15 ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,DSRAVPASS15 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,144,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND15
  nop ; Delay Slot
  DSRAVPASS15:
  PrintString $A010,528,144,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND15:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,33    ; T1 = Shift Amount
  dsrav t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,152,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,152,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,152,FontBlack,TEXTLONG16,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,152,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,152,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDLONG       ; T0 = Long Data Offset
  ld t1,0(t0)        ; T1 = Long Data
  la t0,DSRAVCHECK16 ; T0 = Long Check Data Offset
  ld t2,0(t0)        ; T2 = Long Check Data
  beq t1,t2,DSRAVPASS16 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,152,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND16
  nop ; Delay Slot
  DSRAVPASS16:
  PrintString $A010,528,152,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND16:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,35    ; T1 = Shift Amount
  dsrav t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,160,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,160,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,160,FontBlack,TEXTLONG17,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,160,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,160,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDLONG       ; T0 = Long Data Offset
  ld t1,0(t0)        ; T1 = Long Data
  la t0,DSRAVCHECK17 ; T0 = Long Check Data Offset
  ld t2,0(t0)        ; T2 = Long Check Data
  beq t1,t2,DSRAVPASS17 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,160,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND17
  nop ; Delay Slot
  DSRAVPASS17:
  PrintString $A010,528,160,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND17:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,37    ; T1 = Shift Amount
  dsrav t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,168,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,168,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,168,FontBlack,TEXTLONG18,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,168,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,168,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,DSRAVCHECK18 ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,DSRAVPASS18 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,168,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND18
  nop ; Delay Slot
  DSRAVPASS18:
  PrintString $A010,528,168,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND18:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,39    ; T1 = Shift Amount
  dsrav t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,176,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,176,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,176,FontBlack,TEXTLONG19,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,176,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,176,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,DSRAVCHECK19 ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,DSRAVPASS19 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,176,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND19
  nop ; Delay Slot
  DSRAVPASS19:
  PrintString $A010,528,176,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND19:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,41    ; T1 = Shift Amount
  dsrav t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,184,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,184,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,184,FontBlack,TEXTLONG20,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,184,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,184,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,DSRAVCHECK20 ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,DSRAVPASS20 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,184,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND20
  nop ; Delay Slot
  DSRAVPASS20:
  PrintString $A010,528,184,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND20:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,43    ; T1 = Shift Amount
  dsrav t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,192,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,192,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,192,FontBlack,TEXTLONG21,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,192,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,192,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,DSRAVCHECK21 ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,DSRAVPASS21 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,192,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND21
  nop ; Delay Slot
  DSRAVPASS21:
  PrintString $A010,528,192,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND21:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,45    ; T1 = Shift Amount
  dsrav t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,200,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,200,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,200,FontBlack,TEXTLONG22,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,200,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,200,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,DSRAVCHECK22 ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,DSRAVPASS22 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,200,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND22
  nop ; Delay Slot
  DSRAVPASS22:
  PrintString $A010,528,200,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND22:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,47    ; T1 = Shift Amount
  dsrav t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,208,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,208,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,208,FontBlack,TEXTLONG23,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,208,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,208,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,DSRAVCHECK23 ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,DSRAVPASS23 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,208,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND23
  nop ; Delay Slot
  DSRAVPASS23:
  PrintString $A010,528,208,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND23:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,49    ; T1 = Shift Amount
  dsrav t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,216,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,216,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,216,FontBlack,TEXTLONG24,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,216,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,216,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,DSRAVCHECK24 ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,DSRAVPASS24 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,216,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND24
  nop ; Delay Slot
  DSRAVPASS24:
  PrintString $A010,528,216,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND24:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,51    ; T1 = Shift Amount
  dsrav t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,224,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,224,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,224,FontBlack,TEXTLONG25,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,224,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,224,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,DSRAVCHECK25 ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,DSRAVPASS25 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,224,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND25
  nop ; Delay Slot
  DSRAVPASS25:
  PrintString $A010,528,224,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND25:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,53    ; T1 = Shift Amount
  dsrav t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,232,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,232,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,232,FontBlack,TEXTLONG26,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,232,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,232,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,DSRAVCHECK26 ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,DSRAVPASS26 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,232,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND26
  nop ; Delay Slot
  DSRAVPASS26:
  PrintString $A010,528,232,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND26:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,55    ; T1 = Shift Amount
  dsrav t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,240,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,240,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,240,FontBlack,TEXTLONG27,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,240,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,240,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,DSRAVCHECK27 ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,DSRAVPASS27 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,240,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND27
  nop ; Delay Slot
  DSRAVPASS27:
  PrintString $A010,528,240,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND27:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,57    ; T1 = Shift Amount
  dsrav t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,248,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,248,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,248,FontBlack,TEXTLONG28,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,248,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,248,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,DSRAVCHECK28 ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,DSRAVPASS28 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,248,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND28
  nop ; Delay Slot
  DSRAVPASS28:
  PrintString $A010,528,248,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND28:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,59    ; T1 = Shift Amount
  dsrav t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,256,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,256,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,256,FontBlack,TEXTLONG29,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,256,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,256,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,DSRAVCHECK29 ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,DSRAVPASS29 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,256,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND29
  nop ; Delay Slot
  DSRAVPASS29:
  PrintString $A010,528,256,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND29:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,61    ; T1 = Shift Amount
  dsrav t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,264,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,264,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,264,FontBlack,TEXTLONG30,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,264,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,264,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,DSRAVCHECK30 ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,DSRAVPASS30 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,264,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND30
  nop ; Delay Slot
  DSRAVPASS30:
  PrintString $A010,528,264,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND30:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,63    ; T1 = Shift Amount
  dsrav t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,272,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,272,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,272,FontBlack,TEXTLONG31,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,272,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,272,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,DSRAVCHECK31 ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,DSRAVPASS31 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,272,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND31
  nop ; Delay Slot
  DSRAVPASS31:
  PrintString $A010,528,272,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND31:


  PrintString $A010,0,280,FontBlack,PAGEBREAK,79 ; Print Text String To VRAM Using Font At X,Y Position


Loop:
  WaitScanline $1E0 ; Wait For Scanline To Reach Vertical Blank
  WaitScanline $1E2

  li t0,$00000800 ; Even Field
  sw t0,VI_Y_SCALE(a0)

  WaitScanline $1E0 ; Wait For Scanline To Reach Vertical Blank
  WaitScanline $1E2

  li t0,$02000800 ; Odd Field
  sw t0,VI_Y_SCALE(a0)

  j Loop
  nop ; Delay Slot

DSRAV: db "DSRAV"

RDHEX: db "RD (Hex)"
RTHEX: db "RT (Hex)"
RSDEC: db "RS (Decimal)"
TEST: db "Test Result"
FAIL: db "FAIL"
PASS: db "PASS"

DOLLAR: db "$"

TEXTLONG0: db "1"
TEXTLONG1: db "3"
TEXTLONG2: db "5"
TEXTLONG3: db "7"
TEXTLONG4: db "9"
TEXTLONG5: db "11"
TEXTLONG6: db "13"
TEXTLONG7: db "15"
TEXTLONG8: db "17"
TEXTLONG9: db "19"
TEXTLONG10: db "21"
TEXTLONG11: db "23"
TEXTLONG12: db "25"
TEXTLONG13: db "27"
TEXTLONG14: db "29"
TEXTLONG15: db "31"
TEXTLONG16: db "33"
TEXTLONG17: db "35"
TEXTLONG18: db "37"
TEXTLONG19: db "39"
TEXTLONG20: db "41"
TEXTLONG21: db "43"
TEXTLONG22: db "45"
TEXTLONG23: db "47"
TEXTLONG24: db "49"
TEXTLONG25: db "51"
TEXTLONG26: db "53"
TEXTLONG27: db "55"
TEXTLONG28: db "57"
TEXTLONG29: db "59"
TEXTLONG30: db "61"
TEXTLONG31: db "63"

PAGEBREAK: db "--------------------------------------------------------------------------------"

  align 8 ; Align 64-Bit
VALUELONG: data -123456789123456789

DSRAVCHECK0:  data $FF24B25A2997D075
DSRAVCHECK1:  data $FFC92C968A65F41D
DSRAVCHECK2:  data $FFF24B25A2997D07
DSRAVCHECK3:  data $FFFC92C968A65F41
DSRAVCHECK4:  data $FFFF24B25A2997D0
DSRAVCHECK5:  data $FFFFC92C968A65F4
DSRAVCHECK6:  data $FFFFF24B25A2997D
DSRAVCHECK7:  data $FFFFFC92C968A65F
DSRAVCHECK8:  data $FFFFFF24B25A2997
DSRAVCHECK9:  data $FFFFFFC92C968A65
DSRAVCHECK10: data $FFFFFFF24B25A299
DSRAVCHECK11: data $FFFFFFFC92C968A6
DSRAVCHECK12: data $FFFFFFFF24B25A29
DSRAVCHECK13: data $FFFFFFFFC92C968A
DSRAVCHECK14: data $FFFFFFFFF24B25A2
DSRAVCHECK15: data $FFFFFFFFFC92C968
DSRAVCHECK16: data $FFFFFFFFFF24B25A
DSRAVCHECK17: data $FFFFFFFFFFC92C96
DSRAVCHECK18: data $FFFFFFFFFFF24B25
DSRAVCHECK19: data $FFFFFFFFFFFC92C9
DSRAVCHECK20: data $FFFFFFFFFFFF24B2
DSRAVCHECK21: data $FFFFFFFFFFFFC92C
DSRAVCHECK22: data $FFFFFFFFFFFFF24B
DSRAVCHECK23: data $FFFFFFFFFFFFFC92
DSRAVCHECK24: data $FFFFFFFFFFFFFF24
DSRAVCHECK25: data $FFFFFFFFFFFFFFC9
DSRAVCHECK26: data $FFFFFFFFFFFFFFF2
DSRAVCHECK27: data $FFFFFFFFFFFFFFFC
DSRAVCHECK28: data $FFFFFFFFFFFFFFFF
DSRAVCHECK29: data $FFFFFFFFFFFFFFFF
DSRAVCHECK30: data $FFFFFFFFFFFFFFFF
DSRAVCHECK31: data $FFFFFFFFFFFFFFFF

RDLONG: data 0

FontBlack: incbin FontBlack8x8.bin
FontGreen: incbin FontGreen8x8.bin
FontRed: incbin FontRed8x8.bin