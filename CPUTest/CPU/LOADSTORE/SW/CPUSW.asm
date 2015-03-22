; N64 'Bare Metal' CPU Store Word Test Demo by krom (Peter Lemon):
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
  PrintString $A010,232,8,FontRed,RTDEC,11 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,384,8,FontRed,WORDHEX,9 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,528,8,FontRed,TEST,10 ; Print Text String To VRAM Using Font At X,Y Position


  PrintString $A010,0,16,FontBlack,PAGEBREAK,79 ; Print Text String To VRAM Using Font At X,Y Position


  PrintString $A010,8,24,FontRed,SW,1 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,VALUELONGA ; A0 = Long Data Offset
  ld t0,0(a0) ; T0 = Test Long Data
  la a0,WORD  ; A0 = WORD Offset
  sw t0,0(a0) ; WORD = Word Data
  PrintString $A010,80,24,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,24,FontBlack,VALUELONGA,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,24,FontBlack,TEXTLONGA,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,24,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,24,FontBlack,WORD,3   ; Print Text String To VRAM Using Font At X,Y Position
  la a0,WORD     ; A0 = Word Data Offset
  lw t0,0(a0)    ; T0 = Word Data
  la a0,SWCHECKA ; A0 = Word Check Data Offset
  lw t1,0(a0)    ; T1 = Word Check Data
  beq t0,t1,SWPASSA ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,24,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SWENDA
  nop ; Delay Slot
  SWPASSA:
  PrintString $A010,528,24,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SWENDA:

  la a0,VALUELONGB ; A0 = Long Data Offset
  ld t0,0(a0) ; T0 = Test Long Data
  la a0,WORD  ; A0 = RTWORD Offset
  sw t0,0(a0) ; WORD = Word Data
  PrintString $A010,80,32,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,32,FontBlack,VALUELONGB,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,296,32,FontBlack,TEXTLONGB,8 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,32,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,32,FontBlack,WORD,3   ; Print Text String To VRAM Using Font At X,Y Position
  la a0,WORD     ; A0 = Word Data Offset
  lw t0,0(a0)    ; T0 = Word Data
  la a0,SWCHECKB ; A0 = Word Check Data Offset
  lw t1,0(a0)    ; T1 = Word Check Data
  beq t0,t1,SWPASSB ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,32,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SWENDB
  nop ; Delay Slot
  SWPASSB:
  PrintString $A010,528,32,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SWENDB:

  la a0,VALUELONGC ; A0 = Long Data Offset
  ld t0,0(a0) ; T0 = Test Long Data
  la a0,WORD  ; A0 = WORD Offset
  sw t0,0(a0) ; WORD = Word Data
  PrintString $A010,80,40,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,40,FontBlack,VALUELONGC,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,320,40,FontBlack,TEXTLONGC,5 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,40,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,40,FontBlack,WORD,3   ; Print Text String To VRAM Using Font At X,Y Position
  la a0,WORD     ; A0 = Word Data Offset
  lw t0,0(a0)    ; T0 = Word Data
  la a0,SWCHECKC ; A0 = Word Check Data Offset
  lw t1,0(a0)    ; T1 = Word Check Data
  beq t0,t1,SWPASSC ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,40,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SWENDC
  nop ; Delay Slot
  SWPASSC:
  PrintString $A010,528,40,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SWENDC:

  la a0,VALUELONGD ; A0 = Long Data Offset
  ld t0,0(a0) ; T0 = Test Long Data
  la a0,WORD  ; A0 = WORD Offset
  sw t0,0(a0) ; WORD = Word Data
  PrintString $A010,80,48,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,48,FontBlack,VALUELONGD,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,296,48,FontBlack,TEXTLONGD,8 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,48,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,48,FontBlack,WORD,3   ; Print Text String To VRAM Using Font At X,Y Position
  la a0,WORD     ; A0 = Word Data Offset
  lw t0,0(a0)    ; T0 = Word Data
  la a0,SWCHECKD ; A0 = Word Check Data Offset
  lw t1,0(a0)    ; T1 = Word Check Data
  beq t0,t1,SWPASSD ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,48,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SWENDD
  nop ; Delay Slot
  SWPASSD:
  PrintString $A010,528,48,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SWENDD:

  la a0,VALUELONGE ; A0 = Long Data Offset
  ld t0,0(a0) ; T0 = Test Long Data
  la a0,WORD  ; A0 = WORD Offset
  sw t0,0(a0) ; WORD = Word Data
  PrintString $A010,80,56,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,56,FontBlack,VALUELONGE,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,56,FontBlack,TEXTLONGE,9 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,56,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,56,FontBlack,WORD,3   ; Print Text String To VRAM Using Font At X,Y Position
  la a0,WORD     ; A0 = Word Data Offset
  lw t0,0(a0)    ; T0 = Word Data
  la a0,SWCHECKE ; A0 = Word Check Data Offset
  lw t1,0(a0)    ; T1 = Word Check Data
  beq t0,t1,SWPASSE ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,56,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SWENDE
  nop ; Delay Slot
  SWPASSE:
  PrintString $A010,528,56,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SWENDE:

  la a0,VALUELONGF ; A0 = Long Data Offset
  ld t0,0(a0) ; T0 = Test Long Data
  la a0,WORD  ; A0 = WORD Offset
  sw t0,0(a0) ; WORD = Word Data
  PrintString $A010,80,64,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,64,FontBlack,VALUELONGF,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,312,64,FontBlack,TEXTLONGF,6 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,64,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,64,FontBlack,WORD,3   ; Print Text String To VRAM Using Font At X,Y Position
  la a0,WORD     ; A0 = Word Data Offset
  lw t0,0(a0)    ; T0 = Word Data
  la a0,SWCHECKF ; A0 = Word Check Data Offset
  lw t1,0(a0)    ; T1 = Word Check Data
  beq t0,t1,SWPASSF ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,64,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SWENDF
  nop ; Delay Slot
  SWPASSF:
  PrintString $A010,528,64,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SWENDF:

  la a0,VALUELONGG ; A0 = Long Data Offset
  ld t0,0(a0) ; T0 = Test Long Data
  la a0,WORD  ; A0 = WORD Offset
  sw t0,0(a0) ; WORD = Word Data
  PrintString $A010,80,72,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,72,FontBlack,VALUELONGG,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,72,FontBlack,TEXTLONGG,9 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,72,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,72,FontBlack,WORD,3   ; Print Text String To VRAM Using Font At X,Y Position
  la a0,WORD     ; A0 = Word Data Offset
  lw t0,0(a0)    ; T0 = Word Data
  la a0,SWCHECKG ; A0 = Word Check Data Offset
  lw t1,0(a0)    ; T1 = Word Check Data
  beq t0,t1,SWPASSG ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,72,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SWENDG
  nop ; Delay Slot
  SWPASSG:
  PrintString $A010,528,72,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SWENDG:


  PrintString $A010,8,88,FontRed,SWL,2 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,VALUELONGA ; A0 = Long Data Offset
  ld t0,0(a0)  ; T0 = Test Long Data
  la a0,WORD   ; A0 = WORD Offset
  swl t0,0(a0) ; WORD = Word Data
  PrintString $A010,80,88,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,88,FontBlack,VALUELONGA,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,88,FontBlack,TEXTLONGA,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,88,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,88,FontBlack,WORD,3   ; Print Text String To VRAM Using Font At X,Y Position
  la a0,WORD      ; A0 = Word Data Offset
  lw t0,0(a0)     ; T0 = Word Data
  la a0,SWLCHECKA ; A0 = Word Check Data Offset
  lw t1,0(a0)     ; T1 = Word Check Data
  beq t0,t1,SWLPASSA ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,88,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SWLENDA
  nop ; Delay Slot
  SWLPASSA:
  PrintString $A010,528,88,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SWLENDA:

  la a0,VALUELONGB ; A0 = Long Data Offset
  ld t0,0(a0)  ; T0 = Test Long Data
  la a0,WORD   ; A0 = WORD Offset
  swl t0,0(a0) ; WORD = Word Data
  PrintString $A010,80,96,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,96,FontBlack,VALUELONGB,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,296,96,FontBlack,TEXTLONGB,8 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,96,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,96,FontBlack,WORD,3   ; Print Text String To VRAM Using Font At X,Y Position
  la a0,WORD      ; A0 = Word Data Offset
  lw t0,0(a0)     ; T0 = Word Data
  la a0,SWLCHECKB ; A0 = Word Check Data Offset
  lw t1,0(a0)     ; T1 = Word Check Data
  beq t0,t1,SWLPASSB ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,96,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SWLENDB
  nop ; Delay Slot
  SWLPASSB:
  PrintString $A010,528,96,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SWLENDB:

  la a0,VALUELONGC ; A0 = Long Data Offset
  ld t0,0(a0)  ; T0 = Test Long Data
  la a0,WORD   ; A0 = WORD Offset
  swl t0,0(a0) ; WORD = Word Data
  PrintString $A010,80,104,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,104,FontBlack,VALUELONGC,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,320,104,FontBlack,TEXTLONGC,5 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,104,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,104,FontBlack,WORD,3   ; Print Text String To VRAM Using Font At X,Y Position
  la a0,WORD      ; A0 = Word Data Offset
  lw t0,0(a0)     ; T0 = Word Data
  la a0,SWLCHECKC ; A0 = Word Check Data Offset
  lw t1,0(a0)     ; T1 = Word Check Data
  beq t0,t1,SWLPASSC ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,104,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SWLENDC
  nop ; Delay Slot
  SWLPASSC:
  PrintString $A010,528,104,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SWLENDC:

  la a0,VALUELONGD ; A0 = Long Data Offset
  ld t0,0(a0)  ; T0 = Test Long Data
  la a0,WORD   ; A0 = WORD Offset
  swl t0,0(a0) ; WORD = Word Data
  PrintString $A010,80,112,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,112,FontBlack,VALUELONGD,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,296,112,FontBlack,TEXTLONGD,8 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,112,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,112,FontBlack,WORD,3   ; Print Text String To VRAM Using Font At X,Y Position
  la a0,WORD      ; A0 = Word Data Offset
  lw t0,0(a0)     ; T0 = Word Data
  la a0,SWLCHECKD ; A0 = Word Check Data Offset
  lw t1,0(a0)     ; T1 = Word Check Data
  beq t0,t1,SWLPASSD ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,112,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SWLENDD
  nop ; Delay Slot
  SWLPASSD:
  PrintString $A010,528,112,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SWLENDD:

  la a0,VALUELONGE ; A0 = Long Data Offset
  ld t0,0(a0)  ; T0 = Test Long Data
  la a0,WORD   ; A0 = WORD Offset
  swl t0,0(a0) ; WORD = Word Data
  PrintString $A010,80,120,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,120,FontBlack,VALUELONGE,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,120,FontBlack,TEXTLONGE,9 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,120,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,120,FontBlack,WORD,3   ; Print Text String To VRAM Using Font At X,Y Position
  la a0,WORD      ; A0 = Word Data Offset
  lw t0,0(a0)     ; T0 = Word Data
  la a0,SWLCHECKE ; A0 = Word Check Data Offset
  lw t1,0(a0)     ; T1 = Word Check Data
  beq t0,t1,SWLPASSE ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,120,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SWLENDE
  nop ; Delay Slot
  SWLPASSE:
  PrintString $A010,528,120,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SWLENDE:

  la a0,VALUELONGF ; A0 = Long Data Offset
  ld t0,0(a0)  ; T0 = Test Long Data
  la a0,WORD   ; A0 = WORD Offset
  swl t0,0(a0) ; WORD = Word Data
  PrintString $A010,80,128,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,128,FontBlack,VALUELONGF,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,312,128,FontBlack,TEXTLONGF,6 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,128,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,128,FontBlack,WORD,3   ; Print Text String To VRAM Using Font At X,Y Position
  la a0,WORD      ; A0 = Word Data Offset
  lw t0,0(a0)     ; T0 = Word Data
  la a0,SWLCHECKF ; A0 = Word Check Data Offset
  lw t1,0(a0)     ; T1 = Word Check Data
  beq t0,t1,SWLPASSF ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,128,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SWLENDF
  nop ; Delay Slot
  SWLPASSF:
  PrintString $A010,528,128,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SWLENDF:

  la a0,VALUELONGG ; A0 = Long Data Offset
  ld t0,0(a0)  ; T0 = Test Long Data
  la a0,WORD   ; A0 = WORD Offset
  swl t0,0(a0) ; WORD = Word Data
  PrintString $A010,80,136,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,136,FontBlack,VALUELONGG,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,136,FontBlack,TEXTLONGG,9 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,136,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,136,FontBlack,WORD,3   ; Print Text String To VRAM Using Font At X,Y Position
  la a0,WORD      ; A0 = Word Data Offset
  lw t0,0(a0)     ; T0 = Word Data
  la a0,SWLCHECKG ; A0 = Word Check Data Offset
  lw t1,0(a0)     ; T1 = Word Check Data
  beq t0,t1,SWLPASSG ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,136,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SWLENDG
  nop ; Delay Slot
  SWLPASSG:
  PrintString $A010,528,136,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SWLENDG:


  PrintString $A010,8,152,FontRed,SWR,2 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,VALUELONGA ; A0 = Long Data Offset
  ld t0,0(a0)  ; T0 = Test Long Data
  la a0,WORD   ; A0 = WORD Offset
  swr t0,0(a0) ; WORD = Word Data
  PrintString $A010,80,152,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,152,FontBlack,VALUELONGA,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,152,FontBlack,TEXTLONGA,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,152,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,152,FontBlack,WORD,3   ; Print Text String To VRAM Using Font At X,Y Position
  la a0,WORD      ; A0 = Word Data Offset
  lw t0,0(a0)     ; T0 = Word Data
  la a0,SWRCHECKA ; A0 = Word Check Data Offset
  lw t1,0(a0)     ; T1 = Word Check Data
  beq t0,t1,SWRPASSA ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,152,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SWRENDA
  nop ; Delay Slot
  SWRPASSA:
  PrintString $A010,528,152,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SWRENDA:

  la a0,VALUELONGB ; A0 = Long Data Offset
  ld t0,0(a0)  ; T0 = Test Long Data
  la a0,WORD   ; A0 = WORD Offset
  swr t0,0(a0) ; WORD = Word Data
  PrintString $A010,80,160,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,160,FontBlack,VALUELONGB,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,296,160,FontBlack,TEXTLONGB,8 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,160,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,160,FontBlack,WORD,3   ; Print Text String To VRAM Using Font At X,Y Position
  la a0,WORD      ; A0 = Word Data Offset
  lw t0,0(a0)     ; T0 = Word Data
  la a0,SWRCHECKB ; A0 = Word Check Data Offset
  lw t1,0(a0)     ; T1 = Word Check Data
  beq t0,t1,SWRPASSB ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,160,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SWRENDB
  nop ; Delay Slot
  SWRPASSB:
  PrintString $A010,528,160,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SWRENDB:

  la a0,VALUELONGC ; A0 = Long Data Offset
  ld t0,0(a0)  ; T0 = Test Long Data
  la a0,WORD   ; A0 = WORD Offset
  swr t0,0(a0) ; WORD = Word Data
  PrintString $A010,80,168,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,168,FontBlack,VALUELONGC,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,320,168,FontBlack,TEXTLONGC,5 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,168,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,168,FontBlack,WORD,3   ; Print Text String To VRAM Using Font At X,Y Position
  la a0,WORD      ; A0 = Word Data Offset
  lw t0,0(a0)     ; T0 = Word Data
  la a0,SWRCHECKC ; A0 = Word Check Data Offset
  lw t1,0(a0)     ; T1 = Word Check Data
  beq t0,t1,SWRPASSC ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,168,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SWRENDC
  nop ; Delay Slot
  SWRPASSC:
  PrintString $A010,528,168,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SWRENDC:

  la a0,VALUELONGD ; A0 = Long Data Offset
  ld t0,0(a0)  ; T0 = Test Long Data
  la a0,WORD   ; A0 = WORD Offset
  swr t0,0(a0) ; WORD = Word Data
  PrintString $A010,80,176,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,176,FontBlack,VALUELONGD,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,296,176,FontBlack,TEXTLONGD,8 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,176,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,176,FontBlack,WORD,3   ; Print Text String To VRAM Using Font At X,Y Position
  la a0,WORD      ; A0 = Word Data Offset
  lw t0,0(a0)     ; T0 = Word Data
  la a0,SWRCHECKD ; A0 = Word Check Data Offset
  lw t1,0(a0)     ; T1 = Word Check Data
  beq t0,t1,SWRPASSD ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,176,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SWRENDD
  nop ; Delay Slot
  SWRPASSD:
  PrintString $A010,528,176,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SWRENDD:

  la a0,VALUELONGE ; A0 = Long Data Offset
  ld t0,0(a0)  ; T0 = Test Long Data
  la a0,WORD   ; A0 = WORD Offset
  swr t0,0(a0) ; WORD = Word Data
  PrintString $A010,80,184,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,184,FontBlack,VALUELONGE,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,184,FontBlack,TEXTLONGE,9 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,184,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,184,FontBlack,WORD,3   ; Print Text String To VRAM Using Font At X,Y Position
  la a0,WORD      ; A0 = Word Data Offset
  lw t0,0(a0)     ; T0 = Word Data
  la a0,SWRCHECKE ; A0 = Word Check Data Offset
  lw t1,0(a0)     ; T1 = Word Check Data
  beq t0,t1,SWRPASSE ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,184,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SWRENDE
  nop ; Delay Slot
  SWRPASSE:
  PrintString $A010,528,184,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SWRENDE:

  la a0,VALUELONGF ; A0 = Long Data Offset
  ld t0,0(a0)  ; T0 = Test Long Data
  la a0,WORD   ; A0 = WORD Offset
  swr t0,0(a0) ; WORD = Word Data
  PrintString $A010,80,192,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,192,FontBlack,VALUELONGF,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,312,192,FontBlack,TEXTLONGF,6 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,192,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,192,FontBlack,WORD,3   ; Print Text String To VRAM Using Font At X,Y Position
  la a0,WORD      ; A0 = Word Data Offset
  lw t0,0(a0)     ; T0 = Word Data
  la a0,SWRCHECKF ; A0 = Word Check Data Offset
  lw t1,0(a0)     ; T1 = Word Check Data
  beq t0,t1,SWRPASSF ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,192,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SWRENDF
  nop ; Delay Slot
  SWRPASSF:
  PrintString $A010,528,192,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SWRENDF:

  la a0,VALUELONGG ; A0 = Long Data Offset
  ld t0,0(a0)  ; T0 = Test Long Data
  la a0,WORD   ; A0 = WORD Offset
  swr t0,0(a0) ; WORD = Word Data
  PrintString $A010,80,200,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,200,FontBlack,VALUELONGG,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,200,FontBlack,TEXTLONGG,9 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,200,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,200,FontBlack,WORD,3   ; Print Text String To VRAM Using Font At X,Y Position
  la a0,WORD      ; A0 = Word Data Offset
  lw t0,0(a0)     ; T0 = Word Data
  la a0,SWRCHECKG ; A0 = Word Check Data Offset
  lw t1,0(a0)     ; T1 = Word Check Data
  beq t0,t1,SWRPASSG ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,200,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SWRENDG
  nop ; Delay Slot
  SWRPASSG:
  PrintString $A010,528,200,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SWRENDG:


  PrintString $A010,0,208,FontBlack,PAGEBREAK,79 ; Print Text String To VRAM Using Font At X,Y Position


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

SW: db "SW"
SWL: db "SWL"
SWR: db "SWR"
SWU: db "SWU"

WORDHEX: db "WORD (Hex)"
RTHEX: db "RT (Hex)"
RTDEC: db "RT (Decimal)"
TEST: db "Test Result"
FAIL: db "FAIL"
PASS: db "PASS"

DOLLAR: db "$"

TEXTLONGA: db "0"
TEXTLONGB: db "123456789"
TEXTLONGC: db "123456"
TEXTLONGD: db "123451234"
TEXTLONGE: db "-123451234"
TEXTLONGF: db "-123456"
TEXTLONGG: db "-123456789"

PAGEBREAK: db "--------------------------------------------------------------------------------"

  align 8 ; Align 64-Bit
VALUELONGA: data 0
VALUELONGB: data 123456789
VALUELONGC: data 123456
VALUELONGD: data 123451234
VALUELONGE: data -123451234
VALUELONGF: data -123456
VALUELONGG: data -123456789

SWCHECKA: dw $00000000
SWCHECKB: dw $075BCD15
SWCHECKC: dw $0001E240
SWCHECKD: dw $075BB762
SWCHECKE: dw $F8A4489E
SWCHECKF: dw $FFFE1DC0
SWCHECKG: dw $F8A432EB

SWLCHECKA: dw $00000000
SWLCHECKB: dw $075BCD15
SWLCHECKC: dw $0001E240
SWLCHECKD: dw $075BB762
SWLCHECKE: dw $F8A4489E
SWLCHECKF: dw $FFFE1DC0
SWLCHECKG: dw $F8A432EB

SWRCHECKA: dw $00A432EB
SWRCHECKB: dw $15A432EB
SWRCHECKC: dw $40A432EB
SWRCHECKD: dw $62A432EB
SWRCHECKE: dw $9EA432EB
SWRCHECKF: dw $C0A432EB
SWRCHECKG: dw $EBA432EB

WORD: dw 0

FontBlack: incbin FontBlack8x8.bin
FontGreen: incbin FontGreen8x8.bin
FontRed: incbin FontRed8x8.bin