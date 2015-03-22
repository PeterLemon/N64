; N64 'Bare Metal' CPU Doubleword Shift Right Logical + 32 (32..63) Test Demo by krom (Peter Lemon):
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

  ScreenNTSC 640, 480, BPP32|INTERLACE|AA_MODE_2, $A0100000 ; Screen NTSC: 640x480, 32BPP, Interlace, Resample Only, DRAM Origin = $A0100000

  lui a0,$A010 ; A0 = VRAM Start Offset
  addi a1,a0,((640*480*4)-4) ; A1 = VRAM End Offset
  li t0,$000000FF ; T0 = Black
ClearScreen:
  sw t0,0(a0)
  bne a0,a1,ClearScreen
  addi a0,4 ; Delay Slot


  PrintString $A010,88,8,FontRed,RTHEX,7 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,232,8,FontRed,SA32DEC,16 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,384,8,FontRed,RDHEX,7 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,528,8,FontRed,TEST,10 ; Print Text String To VRAM Using Font At X,Y Position


  PrintString $A010,0,16,FontBlack,PAGEBREAK,79 ; Print Text String To VRAM Using Font At X,Y Position


  PrintString $A010,8,24,FontRed,DSRL32,5 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  dsrl32 t0,0 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,24,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,24,FontBlack,VALUELONG,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,24,FontBlack,TEXTLONG0,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,24,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,24,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,DSRL32CHECK0 ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,DSRL32PASS0 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,24,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRL32END0
  nop ; Delay Slot
  DSRL32PASS0:
  PrintString $A010,528,24,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRL32END0:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  dsrl32 t0,1 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,32,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,32,FontBlack,VALUELONG,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,32,FontBlack,TEXTLONG1,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,32,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,32,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,DSRL32CHECK1 ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,DSRL32PASS1 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,32,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRL32END1
  nop ; Delay Slot
  DSRL32PASS1:
  PrintString $A010,528,32,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRL32END1:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  dsrl32 t0,2 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,40,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,40,FontBlack,VALUELONG,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,40,FontBlack,TEXTLONG2,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,40,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,40,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDLONG       ; T0 = Long Data Offset
  ld t1,0(t0)        ; T1 = Long Data
  la t0,DSRL32CHECK2 ; T0 = Long Check Data Offset
  ld t2,0(t0)        ; T2 = Long Check Data
  beq t1,t2,DSRL32PASS2 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,40,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRL32END2
  nop ; Delay Slot
  DSRL32PASS2:
  PrintString $A010,528,40,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRL32END2:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  dsrl32 t0,3 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,48,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,48,FontBlack,VALUELONG,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,48,FontBlack,TEXTLONG3,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,48,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,48,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,DSRL32CHECK3 ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,DSRL32PASS3 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,48,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRL32END3
  nop ; Delay Slot
  DSRL32PASS3:
  PrintString $A010,528,48,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRL32END3:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  dsrl32 t0,4 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,56,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,56,FontBlack,VALUELONG,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,56,FontBlack,TEXTLONG4,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,56,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,56,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,DSRL32CHECK4 ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,DSRL32PASS4 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,56,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRL32END4
  nop ; Delay Slot
  DSRL32PASS4:
  PrintString $A010,528,56,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRL32END4:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  dsrl32 t0,5 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,64,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,64,FontBlack,VALUELONG,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,64,FontBlack,TEXTLONG5,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,64,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,64,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,DSRL32CHECK5 ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,DSRL32PASS5 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,64,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRL32END5
  nop ; Delay Slot
  DSRL32PASS5:
  PrintString $A010,528,64,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRL32END5:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  dsrl32 t0,6 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,72,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,72,FontBlack,VALUELONG,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,72,FontBlack,TEXTLONG6,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,72,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,72,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,DSRL32CHECK6 ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,DSRL32PASS6 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,72,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRL32END6
  nop ; Delay Slot
  DSRL32PASS6:
  PrintString $A010,528,72,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRL32END6:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  dsrl32 t0,7 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,80,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,80,FontBlack,VALUELONG,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,80,FontBlack,TEXTLONG7,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,80,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,80,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,DSRL32CHECK7 ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,DSRL32PASS7 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,80,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRL32END7
  nop ; Delay Slot
  DSRL32PASS7:
  PrintString $A010,528,80,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRL32END7:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  dsrl32 t0,8 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,88,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,88,FontBlack,VALUELONG,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,88,FontBlack,TEXTLONG8,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,88,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,88,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,DSRL32CHECK8 ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,DSRL32PASS8 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,88,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRL32END8
  nop ; Delay Slot
  DSRL32PASS8:
  PrintString $A010,528,88,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRL32END8:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  dsrl32 t0,9 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,96,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,96,FontBlack,VALUELONG,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,96,FontBlack,TEXTLONG9,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,96,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,96,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,DSRL32CHECK9 ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,DSRL32PASS9 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,96,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRL32END9
  nop ; Delay Slot
  DSRL32PASS9:
  PrintString $A010,528,96,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRL32END9:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  dsrl32 t0,10 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,104,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,104,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,104,FontBlack,TEXTLONG10,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,104,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,104,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG        ; A0 = Long Data Offset
  ld t0,0(a0)         ; T0 = Long Data
  la a0,DSRL32CHECK10 ; A0 = Long Check Data Offset
  ld t1,0(a0)         ; T1 = Long Check Data
  beq t0,t1,DSRL32PASS10 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,104,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRL32END10
  nop ; Delay Slot
  DSRL32PASS10:
  PrintString $A010,528,104,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRL32END10:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  dsrl32 t0,11 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,112,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,112,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,112,FontBlack,TEXTLONG11,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,112,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,112,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG        ; A0 = Long Data Offset
  ld t0,0(a0)         ; T0 = Long Data
  la a0,DSRL32CHECK11 ; A0 = Long Check Data Offset
  ld t1,0(a0)         ; T1 = Long Check Data
  beq t0,t1,DSRL32PASS11 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,112,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRL32END11
  nop ; Delay Slot
  DSRL32PASS11:
  PrintString $A010,528,112,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRL32END11:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  dsrl32 t0,12 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,120,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,120,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,120,FontBlack,TEXTLONG12,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,120,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,120,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG        ; A0 = Long Data Offset
  ld t0,0(a0)         ; T0 = Long Data
  la a0,DSRL32CHECK12 ; A0 = Long Check Data Offset
  ld t1,0(a0)         ; T1 = Long Check Data
  beq t0,t1,DSRL32PASS12 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,120,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRL32END12
  nop ; Delay Slot
  DSRL32PASS12:
  PrintString $A010,528,120,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRL32END12:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  dsrl32 t0,13 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,128,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,128,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,128,FontBlack,TEXTLONG13,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,128,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,128,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG        ; A0 = Long Data Offset
  ld t0,0(a0)         ; T0 = Long Data
  la a0,DSRL32CHECK13 ; A0 = Long Check Data Offset
  ld t1,0(a0)         ; T1 = Long Check Data
  beq t0,t1,DSRL32PASS13 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,128,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRL32END13
  nop ; Delay Slot
  DSRL32PASS13:
  PrintString $A010,528,128,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRL32END13:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  dsrl32 t0,14 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,136,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,136,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,136,FontBlack,TEXTLONG14,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,136,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,136,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG        ; A0 = Long Data Offset
  ld t0,0(a0)         ; T0 = Long Data
  la a0,DSRL32CHECK14 ; A0 = Long Check Data Offset
  ld t1,0(a0)         ; T1 = Long Check Data
  beq t0,t1,DSRL32PASS14 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,136,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRL32END14
  nop ; Delay Slot
  DSRL32PASS14:
  PrintString $A010,528,136,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRL32END14:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  dsrl32 t0,15 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,144,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,144,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,144,FontBlack,TEXTLONG15,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,144,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,144,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG        ; A0 = Long Data Offset
  ld t0,0(a0)         ; T0 = Long Data
  la a0,DSRL32CHECK15 ; A0 = Long Check Data Offset
  ld t1,0(a0)         ; T1 = Long Check Data
  beq t0,t1,DSRL32PASS15 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,144,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRL32END15
  nop ; Delay Slot
  DSRL32PASS15:
  PrintString $A010,528,144,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRL32END15:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  dsrl32 t0,16 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,152,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,152,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,152,FontBlack,TEXTLONG16,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,152,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,152,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG        ; A0 = Long Data Offset
  ld t0,0(a0)         ; T0 = Long Data
  la a0,DSRL32CHECK16 ; A0 = Long Check Data Offset
  ld t1,0(a0)         ; T1 = Long Check Data
  beq t0,t1,DSRL32PASS16 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,152,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRL32END16
  nop ; Delay Slot
  DSRL32PASS16:
  PrintString $A010,528,152,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRL32END16:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  dsrl32 t0,17 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,160,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,160,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,160,FontBlack,TEXTLONG17,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,160,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,160,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG        ; A0 = Long Data Offset
  ld t0,0(a0)         ; T0 = Long Data
  la a0,DSRL32CHECK17 ; A0 = Long Check Data Offset
  ld t1,0(a0)         ; T1 = Long Check Data
  beq t0,t1,DSRL32PASS17 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,160,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRL32END17
  nop ; Delay Slot
  DSRL32PASS17:
  PrintString $A010,528,160,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRL32END17:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  dsrl32 t0,18 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,168,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,168,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,168,FontBlack,TEXTLONG18,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,168,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,168,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG        ; A0 = Long Data Offset
  ld t0,0(a0)         ; T0 = Long Data
  la a0,DSRL32CHECK18 ; A0 = Long Check Data Offset
  ld t1,0(a0)         ; T1 = Long Check Data
  beq t0,t1,DSRL32PASS18 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,168,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRL32END18
  nop ; Delay Slot
  DSRL32PASS18:
  PrintString $A010,528,168,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRL32END18:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  dsrl32 t0,19 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,176,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,176,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,176,FontBlack,TEXTLONG19,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,176,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,176,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG        ; A0 = Long Data Offset
  ld t0,0(a0)         ; T0 = Long Data
  la a0,DSRL32CHECK19 ; A0 = Long Check Data Offset
  ld t1,0(a0)         ; T1 = Long Check Data
  beq t0,t1,DSRL32PASS19 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,176,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRL32END19
  nop ; Delay Slot
  DSRL32PASS19:
  PrintString $A010,528,176,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRL32END19:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  dsrl32 t0,20 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,184,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,184,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,184,FontBlack,TEXTLONG20,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,184,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,184,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG        ; A0 = Long Data Offset
  ld t0,0(a0)         ; T0 = Long Data
  la a0,DSRL32CHECK20 ; A0 = Long Check Data Offset
  ld t1,0(a0)         ; T1 = Long Check Data
  beq t0,t1,DSRL32PASS20 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,184,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRL32END20
  nop ; Delay Slot
  DSRL32PASS20:
  PrintString $A010,528,184,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRL32END20:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  dsrl32 t0,21 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,192,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,192,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,192,FontBlack,TEXTLONG21,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,192,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,192,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG        ; A0 = Long Data Offset
  ld t0,0(a0)         ; T0 = Long Data
  la a0,DSRL32CHECK21 ; A0 = Long Check Data Offset
  ld t1,0(a0)         ; T1 = Long Check Data
  beq t0,t1,DSRL32PASS21 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,192,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRL32END21
  nop ; Delay Slot
  DSRL32PASS21:
  PrintString $A010,528,192,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRL32END21:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  dsrl32 t0,22 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,200,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,200,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,200,FontBlack,TEXTLONG22,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,200,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,200,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG        ; A0 = Long Data Offset
  ld t0,0(a0)         ; T0 = Long Data
  la a0,DSRL32CHECK22 ; A0 = Long Check Data Offset
  ld t1,0(a0)         ; T1 = Long Check Data
  beq t0,t1,DSRL32PASS22 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,200,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRL32END22
  nop ; Delay Slot
  DSRL32PASS22:
  PrintString $A010,528,200,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRL32END22:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  dsrl32 t0,23 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,208,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,208,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,208,FontBlack,TEXTLONG23,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,208,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,208,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG        ; A0 = Long Data Offset
  ld t0,0(a0)         ; T0 = Long Data
  la a0,DSRL32CHECK23 ; A0 = Long Check Data Offset
  ld t1,0(a0)         ; T1 = Long Check Data
  beq t0,t1,DSRL32PASS23 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,208,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRL32END23
  nop ; Delay Slot
  DSRL32PASS23:
  PrintString $A010,528,208,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRL32END23:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  dsrl32 t0,24 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,216,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,216,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,216,FontBlack,TEXTLONG24,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,216,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,216,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG        ; A0 = Long Data Offset
  ld t0,0(a0)         ; T0 = Long Data
  la a0,DSRL32CHECK24 ; A0 = Long Check Data Offset
  ld t1,0(a0)         ; T1 = Long Check Data
  beq t0,t1,DSRL32PASS24 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,216,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRL32END24
  nop ; Delay Slot
  DSRL32PASS24:
  PrintString $A010,528,216,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRL32END24:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  dsrl32 t0,25 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,224,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,224,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,224,FontBlack,TEXTLONG25,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,224,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,224,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG        ; A0 = Long Data Offset
  ld t0,0(a0)         ; T0 = Long Data
  la a0,DSRL32CHECK25 ; A0 = Long Check Data Offset
  ld t1,0(a0)         ; T1 = Long Check Data
  beq t0,t1,DSRL32PASS25 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,224,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRL32END25
  nop ; Delay Slot
  DSRL32PASS25:
  PrintString $A010,528,224,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRL32END25:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  dsrl32 t0,26 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,232,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,232,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,232,FontBlack,TEXTLONG26,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,232,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,232,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG        ; A0 = Long Data Offset
  ld t0,0(a0)         ; T0 = Long Data
  la a0,DSRL32CHECK26 ; A0 = Long Check Data Offset
  ld t1,0(a0)         ; T1 = Long Check Data
  beq t0,t1,DSRL32PASS26 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,232,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRL32END26
  nop ; Delay Slot
  DSRL32PASS26:
  PrintString $A010,528,232,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRL32END26:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  dsrl32 t0,27 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,240,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,240,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,240,FontBlack,TEXTLONG27,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,240,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,240,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG        ; A0 = Long Data Offset
  ld t0,0(a0)         ; T0 = Long Data
  la a0,DSRL32CHECK27 ; A0 = Long Check Data Offset
  ld t1,0(a0)         ; T1 = Long Check Data
  beq t0,t1,DSRL32PASS27 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,240,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRL32END27
  nop ; Delay Slot
  DSRL32PASS27:
  PrintString $A010,528,240,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRL32END27:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  dsrl32 t0,28 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,248,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,248,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,248,FontBlack,TEXTLONG28,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,248,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,248,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG        ; A0 = Long Data Offset
  ld t0,0(a0)         ; T0 = Long Data
  la a0,DSRL32CHECK28 ; A0 = Long Check Data Offset
  ld t1,0(a0)         ; T1 = Long Check Data
  beq t0,t1,DSRL32PASS28 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,248,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRL32END28
  nop ; Delay Slot
  DSRL32PASS28:
  PrintString $A010,528,248,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRL32END28:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  dsrl32 t0,29 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,256,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,256,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,256,FontBlack,TEXTLONG29,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,256,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,256,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG        ; A0 = Long Data Offset
  ld t0,0(a0)         ; T0 = Long Data
  la a0,DSRL32CHECK29 ; A0 = Long Check Data Offset
  ld t1,0(a0)         ; T1 = Long Check Data
  beq t0,t1,DSRL32PASS29 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,256,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRL32END29
  nop ; Delay Slot
  DSRL32PASS29:
  PrintString $A010,528,256,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRL32END29:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  dsrl32 t0,30 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,264,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,264,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,264,FontBlack,TEXTLONG30,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,264,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,264,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG        ; A0 = Long Data Offset
  ld t0,0(a0)         ; T0 = Long Data
  la a0,DSRL32CHECK30 ; A0 = Long Check Data Offset
  ld t1,0(a0)         ; T1 = Long Check Data
  beq t0,t1,DSRL32PASS30 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,264,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRL32END30
  nop ; Delay Slot
  DSRL32PASS30:
  PrintString $A010,528,264,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRL32END30:

  la a0,VALUELONG ; A0 = Long Data Offset
  ld t0,0(a0)     ; T0 = Long Data
  dsrl32 t0,31 ; T0 = Test Long Data
  la a0,RDLONG ; A0 = RDLONG Offset
  sd t0,0(a0)  ; RDLONG = Long Data
  PrintString $A010,80,272,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,272,FontBlack,VALUELONG,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,272,FontBlack,TEXTLONG31,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,272,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,272,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG        ; A0 = Long Data Offset
  ld t0,0(a0)         ; T0 = Long Data
  la a0,DSRL32CHECK31 ; A0 = Long Check Data Offset
  ld t1,0(a0)         ; T1 = Long Check Data
  beq t0,t1,DSRL32PASS31 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,272,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DSRL32END31
  nop ; Delay Slot
  DSRL32PASS31:
  PrintString $A010,528,272,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DSRL32END31:


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

DSRL32: db "DSRL32"

RDHEX: db "RD (Hex)"
RTHEX: db "RT (Hex)"
SA32DEC: db "SA + 32 (Decimal)"
TEST: db "Test Result"
FAIL: db "FAIL"
PASS: db "PASS"

DOLLAR: db "$"

TEXTLONG0: db "32"
TEXTLONG1: db "33"
TEXTLONG2: db "34"
TEXTLONG3: db "35"
TEXTLONG4: db "36"
TEXTLONG5: db "37"
TEXTLONG6: db "38"
TEXTLONG7: db "39"
TEXTLONG8: db "40"
TEXTLONG9: db "41"
TEXTLONG10: db "42"
TEXTLONG11: db "43"
TEXTLONG12: db "44"
TEXTLONG13: db "45"
TEXTLONG14: db "46"
TEXTLONG15: db "47"
TEXTLONG16: db "48"
TEXTLONG17: db "49"
TEXTLONG18: db "50"
TEXTLONG19: db "51"
TEXTLONG20: db "52"
TEXTLONG21: db "53"
TEXTLONG22: db "54"
TEXTLONG23: db "55"
TEXTLONG24: db "56"
TEXTLONG25: db "57"
TEXTLONG26: db "58"
TEXTLONG27: db "59"
TEXTLONG28: db "60"
TEXTLONG29: db "61"
TEXTLONG30: db "62"
TEXTLONG31: db "63"

PAGEBREAK: db "--------------------------------------------------------------------------------"

  align 8 ; Align 64-Bit
VALUELONG: data -123456789123456789

DSRL32CHECK0:  data $00000000FE4964B4
DSRL32CHECK1:  data $000000007F24B25A
DSRL32CHECK2:  data $000000003F92592D
DSRL32CHECK3:  data $000000001FC92C96
DSRL32CHECK4:  data $000000000FE4964B
DSRL32CHECK5:  data $0000000007F24B25
DSRL32CHECK6:  data $0000000003F92592
DSRL32CHECK7:  data $0000000001FC92C9
DSRL32CHECK8:  data $0000000000FE4964
DSRL32CHECK9:  data $00000000007F24B2
DSRL32CHECK10: data $00000000003F9259
DSRL32CHECK11: data $00000000001FC92C
DSRL32CHECK12: data $00000000000FE496
DSRL32CHECK13: data $000000000007F24B
DSRL32CHECK14: data $000000000003F925
DSRL32CHECK15: data $000000000001FC92
DSRL32CHECK16: data $000000000000FE49
DSRL32CHECK17: data $0000000000007F24
DSRL32CHECK18: data $0000000000003F92
DSRL32CHECK19: data $0000000000001FC9
DSRL32CHECK20: data $0000000000000FE4
DSRL32CHECK21: data $00000000000007F2
DSRL32CHECK22: data $00000000000003F9
DSRL32CHECK23: data $00000000000001FC
DSRL32CHECK24: data $00000000000000FE
DSRL32CHECK25: data $000000000000007F
DSRL32CHECK26: data $000000000000003F
DSRL32CHECK27: data $000000000000001F
DSRL32CHECK28: data $000000000000000F
DSRL32CHECK29: data $0000000000000007
DSRL32CHECK30: data $0000000000000003
DSRL32CHECK31: data $0000000000000001

RDLONG: data 0

FontBlack: incbin FontBlack8x8.bin
FontGreen: incbin FontGreen8x8.bin
FontRed: incbin FontRed8x8.bin