; N64 'Bare Metal' CPU Signed Doubleword Multiplication Test Demo by krom (Peter Lemon):
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


  PrintString $A010,88,8,FontRed,RSRTHEX,10 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,232,8,FontRed,RSRTDEC,14 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,384,8,FontRed,LOHIHEX,10 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,528,8,FontRed,TEST,10 ; Print Text String To VRAM Using Font At X,Y Position


  PrintString $A010,0,16,FontBlack,PAGEBREAK,79 ; Print Text String To VRAM Using Font At X,Y Position


  PrintString $A010,8,24,FontRed,DMULT,4 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,VALUELONGA ; A0 = Long Data Offset
  ld t0,0(a0)      ; T0 = Long Data
  la a0,VALUELONGB ; A0 = Long Data Offset
  ld t1,0(a0)      ; T1 = Long Data
  dmult t0,t1 ; HI/LO = Test Long Data
  mflo t0 ; T0 = LO
  la a0,LOLONG ; A0 = LOLONG Offset
  sd t0,0(a0)  ; LOLONG = Long Data
  mfhi t0 ; T0 = HI
  la a0,HILONG ; A0 = HILONG Offset
  sd t0,0(a0)  ; HILONG = Long Data
  PrintString $A010,80,24,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,24,FontBlack,VALUELONGA,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,24,FontBlack,TEXTLONGA,0  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,24,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,24,FontBlack,LOLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,80,32,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,32,FontBlack,VALUELONGB,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,232,32,FontBlack,TEXTLONGB,16 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,32,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,32,FontBlack,HILONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,LOLONG        ; A0 = Long Data Offset
  ld t0,0(a0)         ; T0 = Long Data
  la a0,DMULTLOCHECKA ; A0 = Long Check Data Offset
  ld t1,0(a0)         ; T1 = Long Check Data
  beq t0,t1,DMULTLOPASSA ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,24,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DMULTENDA
  nop ; Delay Slot
  DMULTLOPASSA:
  PrintString $A010,528,24,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,HILONG        ; A0 = Long Data Offset
  ld t0,0(a0)         ; T0 = Long Data
  la a0,DMULTHICHECKA ; A0 = Long Check Data Offset
  ld t1,0(a0)         ; T1 = Long Check Data
  beq t0,t1,DMULTHIPASSA ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,32,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DMULTENDA
  nop ; Delay Slot
  DMULTHIPASSA:
  PrintString $A010,528,32,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DMULTENDA:

  la a0,VALUELONGB ; A0 = Long Data Offset
  ld t0,0(a0)      ; T0 = Long Data
  la a0,VALUELONGC ; A0 = Long Data Offset
  ld t1,0(a0)      ; T1 = Long Data
  dmult t0,t1 ; HI/LO = Test Long Data
  mflo t0 ; T0 = LO
  la a0,LOLONG ; A0 = LOLONG Offset
  sd t0,0(a0)  ; LOLONG = Long Data
  mfhi t0 ; T0 = HI
  la a0,HILONG ; A0 = HILONG Offset
  sd t0,0(a0)  ; HILONG = Long Data
  PrintString $A010,80,48,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,48,FontBlack,VALUELONGB,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,232,48,FontBlack,TEXTLONGB,16 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,48,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,48,FontBlack,LOLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,80,56,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,56,FontBlack,VALUELONGC,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,56,FontBlack,TEXTLONGC,9  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,56,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,56,FontBlack,HILONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,LOLONG        ; A0 = Long Data Offset
  ld t0,0(a0)         ; T0 = Long Data
  la a0,DMULTLOCHECKB ; A0 = Long Check Data Offset
  ld t1,0(a0)         ; T1 = Long Check Data
  beq t0,t1,DMULTLOPASSB ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,48,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DMULTENDB
  nop ; Delay Slot
  DMULTLOPASSB:
  PrintString $A010,528,48,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,HILONG        ; A0 = Long Data Offset
  ld t0,0(a0)         ; T0 = Long Data
  la a0,DMULTHICHECKB ; A0 = Long Check Data Offset
  ld t1,0(a0)         ; T1 = Long Check Data
  beq t0,t1,DMULTHIPASSB ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,56,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DMULTENDB
  nop ; Delay Slot
  DMULTHIPASSB:
  PrintString $A010,528,56,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DMULTENDB:

  la a0,VALUELONGC ; A0 = Long Data Offset
  ld t0,0(a0)      ; T0 = Long Data
  la a0,VALUELONGD ; A0 = Long Data Offset
  ld t1,0(a0)      ; T1 = Long Data
  dmult t0,t1 ; HI/LO = Test Long Data
  mflo t0 ; T0 = LO
  la a0,LOLONG ; A0 = LOLONG Offset
  sd t0,0(a0)  ; LOLONG = Long Data
  mfhi t0 ; T0 = HI
  la a0,HILONG ; A0 = HILONG Offset
  sd t0,0(a0)  ; HILONG = Long Data
  PrintString $A010,80,72,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,72,FontBlack,VALUELONGC,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,72,FontBlack,TEXTLONGC,9  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,72,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,72,FontBlack,LOLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,80,80,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,80,FontBlack,VALUELONGD,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,232,80,FontBlack,TEXTLONGD,16 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,80,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,80,FontBlack,HILONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,LOLONG        ; A0 = Long Data Offset
  ld t0,0(a0)         ; T0 = Long Data
  la a0,DMULTLOCHECKC ; A0 = Long Check Data Offset
  ld t1,0(a0)         ; T1 = Long Check Data
  beq t0,t1,DMULTLOPASSC ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,72,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DMULTENDC
  nop ; Delay Slot
  DMULTLOPASSC:
  PrintString $A010,528,72,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,HILONG        ; A0 = Long Data Offset
  ld t0,0(a0)         ; T0 = Long Data
  la a0,DMULTHICHECKC ; A0 = Long Check Data Offset
  ld t1,0(a0)         ; T1 = Long Check Data
  beq t0,t1,DMULTHIPASSC ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,80,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DMULTENDC
  nop ; Delay Slot
  DMULTHIPASSC:
  PrintString $A010,528,80,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DMULTENDC:

  la a0,VALUELONGD ; A0 = Long Data Offset
  ld t0,0(a0)      ; T0 = Long Data
  la a0,VALUELONGE ; A0 = Long Data Offset
  ld t1,0(a0)      ; T1 = Long Data
  dmult t0,t1 ; HI/LO = Test Long Data
  mflo t0 ; T0 = LO
  la a0,LOLONG ; A0 = LOLONG Offset
  sd t0,0(a0)  ; LOLONG = Long Data
  mfhi t0 ; T0 = HI
  la a0,HILONG ; A0 = HILONG Offset
  sd t0,0(a0)  ; HILONG = Long Data
  PrintString $A010,80,96,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,96,FontBlack,VALUELONGD,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,232,96,FontBlack,TEXTLONGD,16  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,96,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,96,FontBlack,LOLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,80,104,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,104,FontBlack,VALUELONGE,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,224,104,FontBlack,TEXTLONGE,17 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,104,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,104,FontBlack,HILONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,LOLONG        ; A0 = Long Data Offset
  ld t0,0(a0)         ; T0 = Long Data
  la a0,DMULTLOCHECKD ; A0 = Long Check Data Offset
  ld t1,0(a0)         ; T1 = Long Check Data
  beq t0,t1,DMULTLOPASSD ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,96,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DMULTENDD
  nop ; Delay Slot
  DMULTLOPASSD:
  PrintString $A010,528,96,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,HILONG        ; A0 = Long Data Offset
  ld t0,0(a0)         ; T0 = Long Data
  la a0,DMULTHICHECKD ; A0 = Long Check Data Offset
  ld t1,0(a0)         ; T1 = Long Check Data
  beq t0,t1,DMULTHIPASSD ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,104,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DMULTENDD
  nop ; Delay Slot
  DMULTHIPASSD:
  PrintString $A010,528,104,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DMULTENDD:

  la a0,VALUELONGE ; A0 = Long Data Offset
  ld t0,0(a0)      ; T0 = Long Data
  la a0,VALUELONGF ; A0 = Long Data Offset
  ld t1,0(a0)      ; T1 = Long Data
  dmult t0,t1 ; HI/LO = Test Long Data
  mflo t0 ; T0 = LO
  la a0,LOLONG ; A0 = LOLONG Offset
  sd t0,0(a0)  ; LOLONG = Long Data
  mfhi t0 ; T0 = HI
  la a0,HILONG ; A0 = HILONG Offset
  sd t0,0(a0)  ; HILONG = Long Data
  PrintString $A010,80,120,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,120,FontBlack,VALUELONGE,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,224,120,FontBlack,TEXTLONGE,17 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,120,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,120,FontBlack,LOLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,80,128,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,128,FontBlack,VALUELONGF,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,280,128,FontBlack,TEXTLONGF,10 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,128,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,128,FontBlack,HILONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,LOLONG        ; A0 = Long Data Offset
  ld t0,0(a0)         ; T0 = Long Data
  la a0,DMULTLOCHECKE ; A0 = Long Check Data Offset
  ld t1,0(a0)         ; T1 = Long Check Data
  beq t0,t1,DMULTLOPASSE ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,120,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DMULTENDE
  nop ; Delay Slot
  DMULTLOPASSE:
  PrintString $A010,528,120,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,HILONG        ; A0 = Long Data Offset
  ld t0,0(a0)         ; T0 = Long Data
  la a0,DMULTHICHECKE ; A0 = Long Check Data Offset
  ld t1,0(a0)         ; T1 = Long Check Data
  beq t0,t1,DMULTHIPASSE ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,128,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DMULTENDE
  nop ; Delay Slot
  DMULTHIPASSE:
  PrintString $A010,528,128,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DMULTENDE:

  la a0,VALUELONGF ; A0 = Long Data Offset
  ld t0,0(a0)      ; T0 = Long Data
  la a0,VALUELONGG ; A0 = Long Data Offset
  ld t1,0(a0)      ; T1 = Long Data
  dmult t0,t1 ; HI/LO = Test Long Data
  mflo t0 ; T0 = LO
  la a0,LOLONG ; A0 = LOLONG Offset
  sd t0,0(a0)  ; LOLONG = Long Data
  mfhi t0 ; T0 = HI
  la a0,HILONG ; A0 = HILONG Offset
  sd t0,0(a0)  ; HILONG = Long Data
  PrintString $A010,80,144,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,144,FontBlack,VALUELONGF,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,280,144,FontBlack,TEXTLONGF,10 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,144,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,144,FontBlack,LOLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,80,152,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,152,FontBlack,VALUELONGG,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,224,152,FontBlack,TEXTLONGG,17 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,152,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,152,FontBlack,HILONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,LOLONG        ; A0 = Long Data Offset
  ld t0,0(a0)         ; T0 = Long Data
  la a0,DMULTLOCHECKF ; A0 = Long Check Data Offset
  ld t1,0(a0)         ; T1 = Long Check Data
  beq t0,t1,DMULTLOPASSF ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,144,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DMULTENDF
  nop ; Delay Slot
  DMULTLOPASSF:
  PrintString $A010,528,144,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,HILONG        ; A0 = Long Data Offset
  ld t0,0(a0)         ; T0 = Long Data
  la a0,DMULTHICHECKF ; A0 = Long Check Data Offset
  ld t1,0(a0)         ; T1 = Long Check Data
  beq t0,t1,DMULTHIPASSF ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,152,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DMULTENDF
  nop ; Delay Slot
  DMULTHIPASSF:
  PrintString $A010,528,152,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DMULTENDF:

  la a0,VALUELONGA ; A0 = Long Data Offset
  ld t0,0(a0)      ; T0 = Long Data
  la a0,VALUELONGG ; A0 = Long Data Offset
  ld t1,0(a0)      ; T1 = Long Data
  dmult t0,t1 ; HI/LO = Test Long Data
  mflo t0 ; T0 = LO
  la a0,LOLONG ; A0 = LOLONG Offset
  sd t0,0(a0)  ; LOLONG = Long Data
  mfhi t0 ; T0 = HI
  la a0,HILONG ; A0 = HILONG Offset
  sd t0,0(a0)  ; HILONG = Long Data
  PrintString $A010,80,168,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,168,FontBlack,VALUELONGA,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,168,FontBlack,TEXTLONGA,0  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,168,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,168,FontBlack,HILONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,80,176,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,176,FontBlack,VALUELONGG,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,224,176,FontBlack,TEXTLONGG,17 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,176,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,176,FontBlack,HILONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,LOLONG        ; A0 = Long Data Offset
  ld t0,0(a0)         ; T0 = Long Data
  la a0,DMULTLOCHECKG ; A0 = Long Check Data Offset
  ld t1,0(a0)         ; T1 = Long Check Data
  beq t0,t1,DMULTLOPASSG ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,168,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DMULTENDG
  nop ; Delay Slot
  DMULTLOPASSG:
  PrintString $A010,528,168,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,HILONG        ; A0 = Long Data Offset
  ld t0,0(a0)         ; T0 = Long Data
  la a0,DMULTHICHECKG ; A0 = Long Check Data Offset
  ld t1,0(a0)         ; T1 = Long Check Data
  beq t0,t1,DMULTHIPASSG ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,176,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DMULTENDG
  nop ; Delay Slot
  DMULTHIPASSG:
  PrintString $A010,528,176,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DMULTENDG:


  PrintString $A010,0,184,FontBlack,PAGEBREAK,79 ; Print Text String To VRAM Using Font At X,Y Position


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

DMULT: db "DMULT"

LOHIHEX: db "LO/HI (Hex)"
RSRTHEX: db "RS/RT (Hex)"
RSRTDEC: db "RS/RT (Decimal)"
TEST: db "Test Result"
FAIL: db "FAIL"
PASS: db "PASS"

DOLLAR: db "$"

TEXTLONGA: db "0"
TEXTLONGB: db "12345678967891234"
TEXTLONGC: db "1234567895"
TEXTLONGD: db "12345678912345678"
TEXTLONGE: db "-12345678912345678"
TEXTLONGF: db "-1234567895"
TEXTLONGG: db "-12345678967891234"

PAGEBREAK: db "--------------------------------------------------------------------------------"

  align 8 ; Align 64-Bit
VALUELONGA: data 0
VALUELONGB: data 12345678967891234
VALUELONGC: data 1234567895
VALUELONGD: data 12345678912345678
VALUELONGE: data -12345678912345678
VALUELONGF: data -1234567895
VALUELONGG: data -12345678967891234

DMULTLOCHECKA: data $0000000000000000
DMULTHICHECKA: data $0000000000000000
DMULTLOCHECKB: data $A5C5654A8807338E
DMULTHICHECKB: data $00000000000C9B87
DMULTLOCHECKC: data $A4D1C4E8FCE09782
DMULTHICHECKC: data $00000000000C9B87
DMULTLOCHECKD: data $5135FDBC8869803C
DMULTHICHECKD: data $FFFFF87C3E07477E
DMULTLOCHECKE: data $A4D1C4E8FCE09782
DMULTHICHECKE: data $00000000000C9B87
DMULTLOCHECKF: data $A5C5654A8807338E
DMULTHICHECKF: data $00000000000C9B87
DMULTLOCHECKG: data $0000000000000000
DMULTHICHECKG: data $0000000000000000

LOLONG: data 0
HILONG: data 0

FontBlack: incbin FontBlack8x8.bin
FontGreen: incbin FontGreen8x8.bin
FontRed: incbin FontRed8x8.bin