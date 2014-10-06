; N64 'Bare Metal' CPU Doubleword Shift Left Logical Variable (0..63) Test Demo by krom (Peter Lemon):
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


  PrintString $A010,8,24,FontRed,DSLLV,4 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,1     ; T1 = Shift Amount
  dsllv t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,24,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,24,FontBlack,VALUELONG,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,24,FontBlack,TEXTLONG0,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,24,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,24,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG      ; A0 = Long Data Offset
  ld t0,0(a0)       ; T0 = Long Data
  la a0,DSLLVCHECK0 ; A0 = Long Check Data Offset
  ld t1,0(a0)       ; T1 = Long Check Data
  beq t0,t1,DSLLVPASS0 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,24,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSLLVEND0
  nop ; Delay Slot
  DSLLVPASS0:
  PrintString $A010,528,24,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSLLVEND0:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,3     ; T1 = Shift Amount
  dsllv t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,32,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,32,FontBlack,VALUELONG,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,32,FontBlack,TEXTLONG1,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,32,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,32,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG      ; A0 = Long Data Offset
  ld t0,0(a0)       ; T0 = Long Data
  la a0,DSLLVCHECK1 ; A0 = Long Check Data Offset
  ld t1,0(a0)       ; T1 = Long Check Data
  beq t0,t1,DSLLVPASS1 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,32,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSLLVEND1
  nop ; Delay Slot
  DSLLVPASS1:
  PrintString $A010,528,32,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSLLVEND1:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,5     ; T1 = Shift Amount
  dsllv t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,40,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,40,FontBlack,VALUELONG,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,40,FontBlack,TEXTLONG2,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,40,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,40,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG      ; A0 = Long Data Offset
  ld t0,0(a0)       ; T0 = Long Data
  la a0,DSLLVCHECK2 ; A0 = Long Check Data Offset
  ld t1,0(a0)       ; T1 = Long Check Data
  beq t0,t1,DSLLVPASS2 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,40,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSLLVEND2
  nop ; Delay Slot
  DSLLVPASS2:
  PrintString $A010,528,40,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSLLVEND2:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,7     ; T1 = Shift Amount
  dsllv t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,48,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,48,FontBlack,VALUELONG,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,48,FontBlack,TEXTLONG3,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,48,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,48,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG      ; A0 = Long Data Offset
  ld t0,0(a0)       ; T0 = Long Data
  la a0,DSLLVCHECK3 ; A0 = Long Check Data Offset
  ld t1,0(a0)       ; T1 = Long Check Data
  beq t0,t1,DSLLVPASS3 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,48,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSLLVEND3
  nop ; Delay Slot
  DSLLVPASS3:
  PrintString $A010,528,48,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSLLVEND3:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,9     ; T1 = Shift Amount
  dsllv t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,56,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,56,FontBlack,VALUELONG,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,56,FontBlack,TEXTLONG4,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,56,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,56,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG      ; A0 = Long Data Offset
  ld t0,0(a0)       ; T0 = Long Data
  la a0,DSLLVCHECK4 ; A0 = Long Check Data Offset
  ld t1,0(a0)       ; T1 = Long Check Data
  beq t0,t1,DSLLVPASS4 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,56,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSLLVEND4
  nop ; Delay Slot
  DSLLVPASS4:
  PrintString $A010,528,56,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSLLVEND4:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,11    ; T1 = Shift Amount
  dsllv t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,64,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,64,FontBlack,VALUELONG,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,64,FontBlack,TEXTLONG5,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,64,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,64,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG      ; A0 = Long Data Offset
  ld t0,0(a0)       ; T0 = Long Data
  la a0,DSLLVCHECK5 ; A0 = Long Check Data Offset
  ld t1,0(a0)       ; T1 = Long Check Data
  beq t0,t1,DSLLVPASS5 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,64,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSLLVEND5
  nop ; Delay Slot
  DSLLVPASS5:
  PrintString $A010,528,64,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSLLVEND5:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,13    ; T1 = Shift Amount
  dsllv t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,72,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,72,FontBlack,VALUELONG,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,72,FontBlack,TEXTLONG6,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,72,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,72,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG      ; A0 = Long Data Offset
  ld t0,0(a0)       ; T0 = Long Data
  la a0,DSLLVCHECK6 ; A0 = Long Check Data Offset
  ld t1,0(a0)       ; T1 = Long Check Data
  beq t0,t1,DSLLVPASS6 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,72,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSLLVEND6
  nop ; Delay Slot
  DSLLVPASS6:
  PrintString $A010,528,72,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSLLVEND6:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,15    ; T1 = Shift Amount
  dsllv t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,80,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,80,FontBlack,VALUELONG,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,80,FontBlack,TEXTLONG7,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,80,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,80,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG      ; A0 = Long Data Offset
  ld t0,0(a0)       ; T0 = Long Data
  la a0,DSLLVCHECK7 ; A0 = Long Check Data Offset
  ld t1,0(a0)       ; T1 = Long Check Data
  beq t0,t1,DSLLVPASS7 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,80,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSLLVEND7
  nop ; Delay Slot
  DSLLVPASS7:
  PrintString $A010,528,80,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSLLVEND7:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,17    ; T1 = Shift Amount
  dsllv t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,88,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,88,FontBlack,VALUELONG,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,88,FontBlack,TEXTLONG8,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,88,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,88,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG      ; A0 = Long Data Offset
  ld t0,0(a0)       ; T0 = Long Data
  la a0,DSLLVCHECK8 ; A0 = Long Check Data Offset
  ld t1,0(a0)       ; T1 = Long Check Data
  beq t0,t1,DSLLVPASS8 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,88,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSLLVEND8
  nop ; Delay Slot
  DSLLVPASS8:
  PrintString $A010,528,88,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSLLVEND8:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,19    ; T1 = Shift Amount
  dsllv t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,96,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,96,FontBlack,VALUELONG,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,96,FontBlack,TEXTLONG9,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,96,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,96,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG      ; A0 = Long Data Offset
  ld t0,0(a0)       ; T0 = Long Data
  la a0,DSLLVCHECK9 ; A0 = Long Check Data Offset
  ld t1,0(a0)       ; T1 = Long Check Data
  beq t0,t1,DSLLVPASS9 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,96,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSLLVEND9
  nop ; Delay Slot
  DSLLVPASS9:
  PrintString $A010,528,96,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSLLVEND9:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,21    ; T1 = Shift Amount
  dsllv t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,104,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,104,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,104,FontBlack,TEXTLONG10,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,104,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,104,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,DSLLVCHECK10 ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,DSLLVPASS10 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,104,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSLLVEND10
  nop ; Delay Slot
  DSLLVPASS10:
  PrintString $A010,528,104,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSLLVEND10:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,23    ; T1 = Shift Amount
  dsllv t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,112,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,112,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,112,FontBlack,TEXTLONG11,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,112,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,112,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,DSLLVCHECK11 ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,DSLLVPASS11 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,112,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSLLVEND11
  nop ; Delay Slot
  DSLLVPASS11:
  PrintString $A010,528,112,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSLLVEND11:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,25    ; T1 = Shift Amount
  dsllv t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,120,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,120,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,120,FontBlack,TEXTLONG12,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,120,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,120,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,DSLLVCHECK12 ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,DSLLVPASS12 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,120,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSLLVEND12
  nop ; Delay Slot
  DSLLVPASS12:
  PrintString $A010,528,120,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSLLVEND12:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,27    ; T1 = Shift Amount
  dsllv t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,128,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,128,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,128,FontBlack,TEXTLONG13,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,128,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,128,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,DSLLVCHECK13 ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,DSLLVPASS13 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,128,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSLLVEND13
  nop ; Delay Slot
  DSLLVPASS13:
  PrintString $A010,528,128,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSLLVEND13:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,29    ; T1 = Shift Amount
  dsllv t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,136,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,136,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,136,FontBlack,TEXTLONG14,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,136,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,136,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,DSLLVCHECK14 ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,DSLLVPASS14 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,136,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSLLVEND14
  nop ; Delay Slot
  DSLLVPASS14:
  PrintString $A010,528,136,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSLLVEND14:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,31    ; T1 = Shift Amount
  dsllv t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,144,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,144,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,144,FontBlack,TEXTLONG15,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,144,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,144,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,DSLLVCHECK15 ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,DSLLVPASS15 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,144,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSLLVEND15
  nop ; Delay Slot
  DSLLVPASS15:
  PrintString $A010,528,144,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSLLVEND15:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,33    ; T1 = Shift Amount
  dsllv t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,152,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,152,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,152,FontBlack,TEXTLONG16,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,152,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,152,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,DSLLVCHECK16 ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,DSLLVPASS16 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,152,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSLLVEND16
  nop ; Delay Slot
  DSLLVPASS16:
  PrintString $A010,528,152,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSLLVEND16:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,35    ; T1 = Shift Amount
  dsllv t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,160,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,160,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,160,FontBlack,TEXTLONG17,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,160,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,160,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,DSLLVCHECK17 ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,DSLLVPASS17 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,160,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSLLVEND17
  nop ; Delay Slot
  DSLLVPASS17:
  PrintString $A010,528,160,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSLLVEND17:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,37    ; T1 = Shift Amount
  dsllv t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,168,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,168,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,168,FontBlack,TEXTLONG18,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,168,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,168,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,DSLLVCHECK18 ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,DSLLVPASS18 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,168,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSLLVEND18
  nop ; Delay Slot
  DSLLVPASS18:
  PrintString $A010,528,168,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSLLVEND18:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,39    ; T1 = Shift Amount
  dsllv t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,176,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,176,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,176,FontBlack,TEXTLONG19,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,176,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,176,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,DSLLVCHECK19 ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,DSLLVPASS19 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,176,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSLLVEND19
  nop ; Delay Slot
  DSLLVPASS19:
  PrintString $A010,528,176,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSLLVEND19:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,41    ; T1 = Shift Amount
  dsllv t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,184,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,184,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,184,FontBlack,TEXTLONG20,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,184,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,184,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,DSLLVCHECK20 ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,DSLLVPASS20 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,184,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSLLVEND20
  nop ; Delay Slot
  DSLLVPASS20:
  PrintString $A010,528,184,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSLLVEND20:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,43    ; T1 = Shift Amount
  dsllv t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,192,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,192,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,192,FontBlack,TEXTLONG21,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,192,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,192,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,DSLLVCHECK21 ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,DSLLVPASS21 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,192,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSLLVEND21
  nop ; Delay Slot
  DSLLVPASS21:
  PrintString $A010,528,192,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSLLVEND21:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,45    ; T1 = Shift Amount
  dsllv t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,200,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,200,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,200,FontBlack,TEXTLONG22,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,200,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,200,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,DSLLVCHECK22 ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,DSLLVPASS22 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,200,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSLLVEND22
  nop ; Delay Slot
  DSLLVPASS22:
  PrintString $A010,528,200,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSLLVEND22:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,47    ; T1 = Shift Amount
  dsllv t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,208,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,208,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,208,FontBlack,TEXTLONG23,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,208,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,208,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,DSLLVCHECK23 ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,DSLLVPASS23 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,208,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSLLVEND23
  nop ; Delay Slot
  DSLLVPASS23:
  PrintString $A010,528,208,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSLLVEND23:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,49    ; T1 = Shift Amount
  dsllv t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,216,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,216,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,216,FontBlack,TEXTLONG24,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,216,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,216,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,DSLLVCHECK24 ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,DSLLVPASS24 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,216,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSLLVEND24
  nop ; Delay Slot
  DSLLVPASS24:
  PrintString $A010,528,216,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSLLVEND24:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,51    ; T1 = Shift Amount
  dsllv t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,224,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,224,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,224,FontBlack,TEXTLONG25,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,224,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,224,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,DSLLVCHECK25 ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,DSLLVPASS25 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,224,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSLLVEND25
  nop ; Delay Slot
  DSLLVPASS25:
  PrintString $A010,528,224,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSLLVEND25:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,53    ; T1 = Shift Amount
  dsllv t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,232,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,232,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,232,FontBlack,TEXTLONG26,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,232,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,232,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,DSLLVCHECK26 ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,DSLLVPASS26 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,232,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSLLVEND26
  nop ; Delay Slot
  DSLLVPASS26:
  PrintString $A010,528,232,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSLLVEND26:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,55    ; T1 = Shift Amount
  dsllv t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,240,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,240,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,240,FontBlack,TEXTLONG27,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,240,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,240,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,DSLLVCHECK27 ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,DSLLVPASS27 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,240,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSLLVEND27
  nop ; Delay Slot
  DSLLVPASS27:
  PrintString $A010,528,240,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSLLVEND27:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,57    ; T1 = Shift Amount
  dsllv t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,248,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,248,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,248,FontBlack,TEXTLONG28,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,248,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,248,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,DSLLVCHECK28 ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,DSLLVPASS28 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,248,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSLLVEND28
  nop ; Delay Slot
  DSLLVPASS28:
  PrintString $A010,528,248,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSLLVEND28:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,59    ; T1 = Shift Amount
  dsllv t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,256,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,256,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,256,FontBlack,TEXTLONG29,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,256,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,256,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,DSLLVCHECK29 ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,DSLLVPASS29 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,256,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSLLVEND29
  nop ; Delay Slot
  DSLLVPASS29:
  PrintString $A010,528,256,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSLLVEND29:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,61    ; T1 = Shift Amount
  dsllv t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,264,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,264,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,264,FontBlack,TEXTLONG30,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,264,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,264,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,DSLLVCHECK30 ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,DSLLVPASS30 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,264,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSLLVEND30
  nop ; Delay Slot
  DSLLVPASS30:
  PrintString $A010,528,264,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSLLVEND30:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  li t1,63    ; T1 = Shift Amount
  dsllv t0,t1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,272,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,272,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,272,FontBlack,TEXTLONG31,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,272,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,272,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,DSLLVCHECK31 ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,DSLLVPASS31 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,272,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSLLVEND31
  nop ; Delay Slot
  DSLLVPASS31:
  PrintString $A010,528,272,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSLLVEND31:


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

DSLLV: db "DSLLV"

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

DSLLVCHECK0:  data $FC92C968A65F41D6
DSLLVCHECK1:  data $F24B25A2997D0758
DSLLVCHECK2:  data $C92C968A65F41D60
DSLLVCHECK3:  data $24B25A2997D07580
DSLLVCHECK4:  data $92C968A65F41D600
DSLLVCHECK5:  data $4B25A2997D075800
DSLLVCHECK6:  data $2C968A65F41D6000
DSLLVCHECK7:  data $B25A2997D0758000
DSLLVCHECK8:  data $C968A65F41D60000
DSLLVCHECK9:  data $25A2997D07580000
DSLLVCHECK10: data $968A65F41D600000
DSLLVCHECK11: data $5A2997D075800000
DSLLVCHECK12: data $68A65F41D6000000
DSLLVCHECK13: data $A2997D0758000000
DSLLVCHECK14: data $8A65F41D60000000
DSLLVCHECK15: data $2997D07580000000
DSLLVCHECK16: data $A65F41D600000000
DSLLVCHECK17: data $997D075800000000
DSLLVCHECK18: data $65F41D6000000000
DSLLVCHECK19: data $97D0758000000000
DSLLVCHECK20: data $5F41D60000000000
DSLLVCHECK21: data $7D07580000000000
DSLLVCHECK22: data $F41D600000000000
DSLLVCHECK23: data $D075800000000000
DSLLVCHECK24: data $41D6000000000000
DSLLVCHECK25: data $0758000000000000
DSLLVCHECK26: data $1D60000000000000
DSLLVCHECK27: data $7580000000000000
DSLLVCHECK28: data $D600000000000000
DSLLVCHECK29: data $5800000000000000
DSLLVCHECK30: data $6000000000000000
DSLLVCHECK31: data $8000000000000000

RDLONG: data 0

FontBlack: incbin FontBlack8x8.bin
FontGreen: incbin FontGreen8x8.bin
FontRed: incbin FontRed8x8.bin