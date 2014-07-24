; N64 'Bare Metal' CPU Word Shift Left Logical (0..31) Test Demo by krom (Peter Lemon):

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


  PrintString $A010,8,24,FontRed,SLL,2 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  sll t0,0 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,24,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,24,FontBlack,VALUEWORD,3  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,24,FontBlack,TEXTWORD0,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,24,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,24,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD    ; T0 = Word Data Offset
  lw t1,0(t0)     ; T1 = Word Data
  la t0,SLLCHECK0 ; T0 = Word Check Data Offset
  lw t2,0(t0)     ; T2 = Word Check Data
  beq t1,t2,SLLPASS0 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,24,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SLLEND0
  nop ; Delay Slot
  SLLPASS0:
  PrintString $A010,528,24,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SLLEND0:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  sll t0,1 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,32,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,32,FontBlack,VALUEWORD,3  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,32,FontBlack,TEXTWORD1,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,32,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,32,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD    ; T0 = Word Data Offset
  lw t1,0(t0)     ; T1 = Word Data
  la t0,SLLCHECK1 ; T0 = Word Check Data Offset
  lw t2,0(t0)     ; T2 = Word Check Data
  beq t1,t2,SLLPASS1 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,32,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SLLEND1
  nop ; Delay Slot
  SLLPASS1:
  PrintString $A010,528,32,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SLLEND1:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  sll t0,2 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,40,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,40,FontBlack,VALUEWORD,3  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,40,FontBlack,TEXTWORD2,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,40,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,40,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD    ; T0 = Word Data Offset
  lw t1,0(t0)     ; T1 = Word Data
  la t0,SLLCHECK2 ; T0 = Word Check Data Offset
  lw t2,0(t0)     ; T2 = Word Check Data
  beq t1,t2,SLLPASS2 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,40,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SLLEND2
  nop ; Delay Slot
  SLLPASS2:
  PrintString $A010,528,40,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SLLEND2:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  sll t0,3 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,48,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,48,FontBlack,VALUEWORD,3  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,48,FontBlack,TEXTWORD3,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,48,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,48,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD    ; T0 = Word Data Offset
  lw t1,0(t0)     ; T1 = Word Data
  la t0,SLLCHECK3 ; T0 = Word Check Data Offset
  lw t2,0(t0)     ; T2 = Word Check Data
  beq t1,t2,SLLPASS3 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,48,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SLLEND3
  nop ; Delay Slot
  SLLPASS3:
  PrintString $A010,528,48,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SLLEND3:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  sll t0,4 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,56,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,56,FontBlack,VALUEWORD,3  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,56,FontBlack,TEXTWORD4,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,56,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,56,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD    ; T0 = Word Data Offset
  lw t1,0(t0)     ; T1 = Word Data
  la t0,SLLCHECK4 ; T0 = Word Check Data Offset
  lw t2,0(t0)     ; T2 = Word Check Data
  beq t1,t2,SLLPASS4 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,56,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SLLEND4
  nop ; Delay Slot
  SLLPASS4:
  PrintString $A010,528,56,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SLLEND4:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  sll t0,5 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,64,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,64,FontBlack,VALUEWORD,3  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,64,FontBlack,TEXTWORD5,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,64,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,64,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD    ; T0 = Word Data Offset
  lw t1,0(t0)     ; T1 = Word Data
  la t0,SLLCHECK5 ; T0 = Word Check Data Offset
  lw t2,0(t0)     ; T2 = Word Check Data
  beq t1,t2,SLLPASS5 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,64,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SLLEND5
  nop ; Delay Slot
  SLLPASS5:
  PrintString $A010,528,64,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SLLEND5:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  sll t0,6 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,72,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,72,FontBlack,VALUEWORD,3  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,72,FontBlack,TEXTWORD6,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,72,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,72,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD    ; T0 = Word Data Offset
  lw t1,0(t0)     ; T1 = Word Data
  la t0,SLLCHECK6 ; T0 = Word Check Data Offset
  lw t2,0(t0)     ; T2 = Word Check Data
  beq t1,t2,SLLPASS6 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,72,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SLLEND6
  nop ; Delay Slot
  SLLPASS6:
  PrintString $A010,528,72,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SLLEND6:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  sll t0,7 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,80,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,80,FontBlack,VALUEWORD,3  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,80,FontBlack,TEXTWORD7,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,80,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,80,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD    ; T0 = Word Data Offset
  lw t1,0(t0)     ; T1 = Word Data
  la t0,SLLCHECK7 ; T0 = Word Check Data Offset
  lw t2,0(t0)     ; T2 = Word Check Data
  beq t1,t2,SLLPASS7 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,80,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SLLEND7
  nop ; Delay Slot
  SLLPASS7:
  PrintString $A010,528,80,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SLLEND7:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  sll t0,8 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,88,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,88,FontBlack,VALUEWORD,3  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,88,FontBlack,TEXTWORD8,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,88,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,88,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD    ; T0 = Word Data Offset
  lw t1,0(t0)     ; T1 = Word Data
  la t0,SLLCHECK8 ; T0 = Word Check Data Offset
  lw t2,0(t0)     ; T2 = Word Check Data
  beq t1,t2,SLLPASS8 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,88,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SLLEND8
  nop ; Delay Slot
  SLLPASS8:
  PrintString $A010,528,88,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SLLEND8:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  sll t0,9 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,96,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,96,FontBlack,VALUEWORD,3  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,96,FontBlack,TEXTWORD9,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,96,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,96,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD    ; T0 = Word Data Offset
  lw t1,0(t0)     ; T1 = Word Data
  la t0,SLLCHECK9 ; T0 = Word Check Data Offset
  lw t2,0(t0)     ; T2 = Word Check Data
  beq t1,t2,SLLPASS9 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,96,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SLLEND9
  nop ; Delay Slot
  SLLPASS9:
  PrintString $A010,528,96,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SLLEND9:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  sll t0,10 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,104,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,104,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,104,FontBlack,TEXTWORD10,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,104,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,104,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD     ; T0 = Word Data Offset
  lw t1,0(t0)      ; T1 = Word Data
  la t0,SLLCHECK10 ; T0 = Word Check Data Offset
  lw t2,0(t0)      ; T2 = Word Check Data
  beq t1,t2,SLLPASS10 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,104,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SLLEND10
  nop ; Delay Slot
  SLLPASS10:
  PrintString $A010,528,104,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SLLEND10:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  sll t0,11 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,112,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,112,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,112,FontBlack,TEXTWORD11,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,112,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,112,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD     ; T0 = Word Data Offset
  lw t1,0(t0)      ; T1 = Word Data
  la t0,SLLCHECK11 ; T0 = Word Check Data Offset
  lw t2,0(t0)      ; T2 = Word Check Data
  beq t1,t2,SLLPASS11 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,112,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SLLEND11
  nop ; Delay Slot
  SLLPASS11:
  PrintString $A010,528,112,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SLLEND11:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  sll t0,12 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,120,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,120,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,120,FontBlack,TEXTWORD12,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,120,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,120,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD     ; T0 = Word Data Offset
  lw t1,0(t0)      ; T1 = Word Data
  la t0,SLLCHECK12 ; T0 = Word Check Data Offset
  lw t2,0(t0)      ; T2 = Word Check Data
  beq t1,t2,SLLPASS12 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,120,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SLLEND12
  nop ; Delay Slot
  SLLPASS12:
  PrintString $A010,528,120,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SLLEND12:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  sll t0,13 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,128,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,128,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,128,FontBlack,TEXTWORD13,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,128,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,128,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD     ; T0 = Word Data Offset
  lw t1,0(t0)      ; T1 = Word Data
  la t0,SLLCHECK13 ; T0 = Word Check Data Offset
  lw t2,0(t0)      ; T2 = Word Check Data
  beq t1,t2,SLLPASS13 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,128,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SLLEND13
  nop ; Delay Slot
  SLLPASS13:
  PrintString $A010,528,128,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SLLEND13:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  sll t0,14 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,136,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,136,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,136,FontBlack,TEXTWORD14,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,136,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,136,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD     ; T0 = Word Data Offset
  lw t1,0(t0)      ; T1 = Word Data
  la t0,SLLCHECK14 ; T0 = Word Check Data Offset
  lw t2,0(t0)      ; T2 = Word Check Data
  beq t1,t2,SLLPASS14 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,136,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SLLEND14
  nop ; Delay Slot
  SLLPASS14:
  PrintString $A010,528,136,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SLLEND14:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  sll t0,15 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,144,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,144,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,144,FontBlack,TEXTWORD15,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,144,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,144,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD     ; T0 = Word Data Offset
  lw t1,0(t0)      ; T1 = Word Data
  la t0,SLLCHECK15 ; T0 = Word Check Data Offset
  lw t2,0(t0)      ; T2 = Word Check Data
  beq t1,t2,SLLPASS15 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,144,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SLLEND15
  nop ; Delay Slot
  SLLPASS15:
  PrintString $A010,528,144,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SLLEND15:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  sll t0,16 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,152,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,152,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,152,FontBlack,TEXTWORD16,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,152,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,152,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD     ; T0 = Word Data Offset
  lw t1,0(t0)      ; T1 = Word Data
  la t0,SLLCHECK16 ; T0 = Word Check Data Offset
  lw t2,0(t0)      ; T2 = Word Check Data
  beq t1,t2,SLLPASS16 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,152,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SLLEND16
  nop ; Delay Slot
  SLLPASS16:
  PrintString $A010,528,152,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SLLEND16:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  sll t0,17 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,160,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,160,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,160,FontBlack,TEXTWORD17,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,160,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,160,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD     ; T0 = Word Data Offset
  lw t1,0(t0)      ; T1 = Word Data
  la t0,SLLCHECK17 ; T0 = Word Check Data Offset
  lw t2,0(t0)      ; T2 = Word Check Data
  beq t1,t2,SLLPASS17 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,160,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SLLEND17
  nop ; Delay Slot
  SLLPASS17:
  PrintString $A010,528,160,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SLLEND17:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  sll t0,18 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,168,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,168,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,168,FontBlack,TEXTWORD18,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,168,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,168,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD     ; T0 = Word Data Offset
  lw t1,0(t0)      ; T1 = Word Data
  la t0,SLLCHECK18 ; T0 = Word Check Data Offset
  lw t2,0(t0)      ; T2 = Word Check Data
  beq t1,t2,SLLPASS18 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,168,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SLLEND18
  nop ; Delay Slot
  SLLPASS18:
  PrintString $A010,528,168,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SLLEND18:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  sll t0,19 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,176,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,176,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,176,FontBlack,TEXTWORD19,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,176,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,176,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD     ; T0 = Word Data Offset
  lw t1,0(t0)      ; T1 = Word Data
  la t0,SLLCHECK19 ; T0 = Word Check Data Offset
  lw t2,0(t0)      ; T2 = Word Check Data
  beq t1,t2,SLLPASS19 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,176,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SLLEND19
  nop ; Delay Slot
  SLLPASS19:
  PrintString $A010,528,176,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SLLEND19:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  sll t0,20 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,184,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,184,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,184,FontBlack,TEXTWORD20,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,184,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,184,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD     ; T0 = Word Data Offset
  lw t1,0(t0)      ; T1 = Word Data
  la t0,SLLCHECK20 ; T0 = Word Check Data Offset
  lw t2,0(t0)      ; T2 = Word Check Data
  beq t1,t2,SLLPASS20 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,184,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SLLEND20
  nop ; Delay Slot
  SLLPASS20:
  PrintString $A010,528,184,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SLLEND20:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  sll t0,21 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,192,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,192,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,192,FontBlack,TEXTWORD21,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,192,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,192,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD     ; T0 = Word Data Offset
  lw t1,0(t0)      ; T1 = Word Data
  la t0,SLLCHECK21 ; T0 = Word Check Data Offset
  lw t2,0(t0)      ; T2 = Word Check Data
  beq t1,t2,SLLPASS21 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,192,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SLLEND21
  nop ; Delay Slot
  SLLPASS21:
  PrintString $A010,528,192,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SLLEND21:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  sll t0,22 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,200,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,200,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,200,FontBlack,TEXTWORD22,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,200,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,200,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD     ; T0 = Word Data Offset
  lw t1,0(t0)      ; T1 = Word Data
  la t0,SLLCHECK22 ; T0 = Word Check Data Offset
  lw t2,0(t0)      ; T2 = Word Check Data
  beq t1,t2,SLLPASS22 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,200,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SLLEND22
  nop ; Delay Slot
  SLLPASS22:
  PrintString $A010,528,200,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SLLEND22:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  sll t0,23 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,208,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,208,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,208,FontBlack,TEXTWORD23,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,208,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,208,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD     ; T0 = Word Data Offset
  lw t1,0(t0)      ; T1 = Word Data
  la t0,SLLCHECK23 ; T0 = Word Check Data Offset
  lw t2,0(t0)      ; T2 = Word Check Data
  beq t1,t2,SLLPASS23 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,208,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SLLEND23
  nop ; Delay Slot
  SLLPASS23:
  PrintString $A010,528,208,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SLLEND23:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  sll t0,24 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,216,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,216,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,216,FontBlack,TEXTWORD24,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,216,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,216,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD     ; T0 = Word Data Offset
  lw t1,0(t0)      ; T1 = Word Data
  la t0,SLLCHECK24 ; T0 = Word Check Data Offset
  lw t2,0(t0)      ; T2 = Word Check Data
  beq t1,t2,SLLPASS24 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,216,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SLLEND24
  nop ; Delay Slot
  SLLPASS24:
  PrintString $A010,528,216,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SLLEND24:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  sll t0,25 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,224,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,224,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,224,FontBlack,TEXTWORD25,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,224,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,224,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD     ; T0 = Word Data Offset
  lw t1,0(t0)      ; T1 = Word Data
  la t0,SLLCHECK25 ; T0 = Word Check Data Offset
  lw t2,0(t0)      ; T2 = Word Check Data
  beq t1,t2,SLLPASS25 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,224,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SLLEND25
  nop ; Delay Slot
  SLLPASS25:
  PrintString $A010,528,224,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SLLEND25:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  sll t0,26 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,232,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,232,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,232,FontBlack,TEXTWORD26,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,232,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,232,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD     ; T0 = Word Data Offset
  lw t1,0(t0)      ; T1 = Word Data
  la t0,SLLCHECK26 ; T0 = Word Check Data Offset
  lw t2,0(t0)      ; T2 = Word Check Data
  beq t1,t2,SLLPASS26 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,232,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SLLEND26
  nop ; Delay Slot
  SLLPASS26:
  PrintString $A010,528,232,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SLLEND26:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  sll t0,27 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,240,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,240,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,240,FontBlack,TEXTWORD27,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,240,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,240,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD     ; T0 = Word Data Offset
  lw t1,0(t0)      ; T1 = Word Data
  la t0,SLLCHECK27 ; T0 = Word Check Data Offset
  lw t2,0(t0)      ; T2 = Word Check Data
  beq t1,t2,SLLPASS27 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,240,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SLLEND27
  nop ; Delay Slot
  SLLPASS27:
  PrintString $A010,528,240,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SLLEND27:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  sll t0,28 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,248,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,248,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,248,FontBlack,TEXTWORD28,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,248,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,248,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD     ; T0 = Word Data Offset
  lw t1,0(t0)      ; T1 = Word Data
  la t0,SLLCHECK28 ; T0 = Word Check Data Offset
  lw t2,0(t0)      ; T2 = Word Check Data
  beq t1,t2,SLLPASS28 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,248,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SLLEND28
  nop ; Delay Slot
  SLLPASS28:
  PrintString $A010,528,248,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SLLEND28:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  sll t0,29 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,256,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,256,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,256,FontBlack,TEXTWORD29,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,256,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,256,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD     ; T0 = Word Data Offset
  lw t1,0(t0)      ; T1 = Word Data
  la t0,SLLCHECK29 ; T0 = Word Check Data Offset
  lw t2,0(t0)      ; T2 = Word Check Data
  beq t1,t2,SLLPASS29 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,256,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SLLEND29
  nop ; Delay Slot
  SLLPASS29:
  PrintString $A010,528,256,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SLLEND29:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  sll t0,30 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,264,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,264,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,264,FontBlack,TEXTWORD30,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,264,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,264,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD     ; T0 = Word Data Offset
  lw t1,0(t0)      ; T1 = Word Data
  la t0,SLLCHECK30 ; T0 = Word Check Data Offset
  lw t2,0(t0)      ; T2 = Word Check Data
  beq t1,t2,SLLPASS30 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,264,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SLLEND30
  nop ; Delay Slot
  SLLPASS30:
  PrintString $A010,528,264,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SLLEND30:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  sll t0,31 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,272,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,272,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,272,FontBlack,TEXTWORD31,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,272,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,272,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD     ; T0 = Word Data Offset
  lw t1,0(t0)      ; T1 = Word Data
  la t0,SLLCHECK31 ; T0 = Word Check Data Offset
  lw t2,0(t0)      ; T2 = Word Check Data
  beq t1,t2,SLLPASS31 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,272,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SLLEND31
  nop ; Delay Slot
  SLLPASS31:
  PrintString $A010,528,272,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SLLEND31:


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

SLL: db "SLL"

RDHEX: db "RD (Hex)"
RTHEX: db "RT (Hex)"
SADEC: db "SA (Decimal)"
TEST: db "Test Result"
FAIL: db "FAIL"
PASS: db "PASS"

DOLLAR: db "$"

TEXTWORD0: db "0"
TEXTWORD1: db "1"
TEXTWORD2: db "2"
TEXTWORD3: db "3"
TEXTWORD4: db "4"
TEXTWORD5: db "5"
TEXTWORD6: db "6"
TEXTWORD7: db "7"
TEXTWORD8: db "8"
TEXTWORD9: db "9"
TEXTWORD10: db "10"
TEXTWORD11: db "11"
TEXTWORD12: db "12"
TEXTWORD13: db "13"
TEXTWORD14: db "14"
TEXTWORD15: db "15"
TEXTWORD16: db "16"
TEXTWORD17: db "17"
TEXTWORD18: db "18"
TEXTWORD19: db "19"
TEXTWORD20: db "20"
TEXTWORD21: db "21"
TEXTWORD22: db "22"
TEXTWORD23: db "23"
TEXTWORD24: db "24"
TEXTWORD25: db "25"
TEXTWORD26: db "26"
TEXTWORD27: db "27"
TEXTWORD28: db "28"
TEXTWORD29: db "29"
TEXTWORD30: db "30"
TEXTWORD31: db "31"

PAGEBREAK: db "--------------------------------------------------------------------------------"

  align 8 ; Align 64-bit
VALUEWORD: dw -123456789

SLLCHECK0:  dw $F8A432EB
SLLCHECK1:  dw $F14865D6
SLLCHECK2:  dw $E290CBAC
SLLCHECK3:  dw $C5219758
SLLCHECK4:  dw $8A432EB0
SLLCHECK5:  dw $14865D60
SLLCHECK6:  dw $290CBAC0
SLLCHECK7:  dw $52197580
SLLCHECK8:  dw $A432EB00
SLLCHECK9:  dw $4865D600
SLLCHECK10: dw $90CBAC00
SLLCHECK11: dw $21975800
SLLCHECK12: dw $432EB000
SLLCHECK13: dw $865D6000
SLLCHECK14: dw $0CBAC000
SLLCHECK15: dw $19758000
SLLCHECK16: dw $32EB0000
SLLCHECK17: dw $65D60000
SLLCHECK18: dw $CBAC0000
SLLCHECK19: dw $97580000
SLLCHECK20: dw $2EB00000
SLLCHECK21: dw $5D600000
SLLCHECK22: dw $BAC00000
SLLCHECK23: dw $75800000
SLLCHECK24: dw $EB000000
SLLCHECK25: dw $D6000000
SLLCHECK26: dw $AC000000
SLLCHECK27: dw $58000000
SLLCHECK28: dw $B0000000
SLLCHECK29: dw $60000000
SLLCHECK30: dw $C0000000
SLLCHECK31: dw $80000000

RDWORD: dw 0

FontBlack: incbin FontBlack8x8.bin
FontGreen: incbin FontGreen8x8.bin
FontRed: incbin FontRed8x8.bin