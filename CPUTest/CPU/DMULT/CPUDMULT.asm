; N64 'Bare Metal' CPU Signed Doubleword Multiplication Test Demo by krom (Peter Lemon):

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




  PrintString $A010,88,8,FontRed,RSRTHEX,10 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,232,8,FontRed,RSRTDEC,14 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,384,8,FontRed,LOHIHEX,10 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,528,8,FontRed,TEST,10 ; Print Text String To VRAM Using Font At X,Y Position


  PrintString $A010,0,16,FontBlack,PAGEBREAK,79 ; Print Text String To VRAM Using Font At X,Y Position


  PrintString $A010,8,24,FontRed,DMULT,4 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,VALUELONGA ; T0 = Long Data Offset
  ld t0,0(t0)      ; T0 = Long Data
  la t1,VALUELONGB ; T1 = Long Data Offset
  ld t1,0(t1)      ; T1 = Long Data
  dmult t0,t1 ; HI/LO = Test Long Data
  mflo t0 ; T0 = LO
  la t1,LOLONG ; T1 = LOLONG Offset
  sd t0,0(t1)  ; LOLONG = Long Data
  mfhi t0 ; T0 = HI
  la t1,HILONG ; T1 = HILONG Offset
  sd t0,0(t1)  ; HILONG = Long Data
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
  la t0,LOLONG        ; T0 = Long Data Offset
  ld t1,0(t0)         ; T1 = Long Data
  la t0,DMULTLOCHECKA ; T0 = Long Check Data Offset
  ld t2,0(t0)         ; T2 = Long Check Data
  beq t1,t2,DMULTLOPASSA ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,24,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DMULTENDA
  nop ; Delay Slot
  DMULTLOPASSA:
  PrintString $A010,528,24,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,HILONG        ; T0 = Long Data Offset
  ld t1,0(t0)         ; T1 = Long Data
  la t0,DMULTHICHECKA ; T0 = Long Check Data Offset
  ld t2,0(t0)         ; T2 = Long Check Data
  beq t1,t2,DMULTHIPASSA ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,32,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DMULTENDA
  nop ; Delay Slot
  DMULTHIPASSA:
  PrintString $A010,528,32,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DMULTENDA:

  la t0,VALUELONGB ; T0 = Long Data Offset
  ld t0,0(t0)      ; T0 = Long Data
  la t1,VALUELONGC ; T1 = Long Data Offset
  ld t1,0(t1)      ; T1 = Long Data
  dmult t0,t1 ; HI/LO = Test Long Data
  mflo t0 ; T0 = LO
  la t1,LOLONG ; T1 = LOLONG Offset
  sd t0,0(t1)  ; LOLONG = Long Data
  mfhi t0 ; T0 = HI
  la t1,HILONG ; T1 = HILONG Offset
  sd t0,0(t1)  ; HILONG = Long Data
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
  la t0,LOLONG        ; T0 = Long Data Offset
  ld t1,0(t0)         ; T1 = Long Data
  la t0,DMULTLOCHECKB ; T0 = Long Check Data Offset
  ld t2,0(t0)         ; T2 = Long Check Data
  beq t1,t2,DMULTLOPASSB ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,48,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DMULTENDB
  nop ; Delay Slot
  DMULTLOPASSB:
  PrintString $A010,528,48,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,HILONG        ; T0 = Long Data Offset
  ld t1,0(t0)         ; T1 = Long Data
  la t0,DMULTHICHECKB ; T0 = Long Check Data Offset
  ld t2,0(t0)         ; T2 = Long Check Data
  beq t1,t2,DMULTHIPASSB ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,56,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DMULTENDB
  nop ; Delay Slot
  DMULTHIPASSB:
  PrintString $A010,528,56,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DMULTENDB:

  la t0,VALUELONGC ; T0 = Long Data Offset
  ld t0,0(t0)      ; T0 = Long Data
  la t1,VALUELONGD ; T1 = Long Data Offset
  ld t1,0(t1)      ; T1 = Long Data
  dmult t0,t1 ; HI/LO = Test Long Data
  mflo t0 ; T0 = LO
  la t1,LOLONG ; T1 = LOLONG Offset
  sd t0,0(t1)  ; LOLONG = Long Data
  mfhi t0 ; T0 = HI
  la t1,HILONG ; T1 = HILONG Offset
  sd t0,0(t1)  ; HILONG = Long Data
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
  la t0,LOLONG        ; T0 = Long Data Offset
  ld t1,0(t0)         ; T1 = Long Data
  la t0,DMULTLOCHECKC ; T0 = Long Check Data Offset
  ld t2,0(t0)         ; T2 = Long Check Data
  beq t1,t2,DMULTLOPASSC ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,72,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DMULTENDC
  nop ; Delay Slot
  DMULTLOPASSC:
  PrintString $A010,528,72,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,HILONG        ; T0 = Long Data Offset
  ld t1,0(t0)         ; T1 = Long Data
  la t0,DMULTHICHECKC ; T0 = Long Check Data Offset
  ld t2,0(t0)         ; T2 = Long Check Data
  beq t1,t2,DMULTHIPASSC ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,80,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DMULTENDC
  nop ; Delay Slot
  DMULTHIPASSC:
  PrintString $A010,528,80,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DMULTENDC:

  la t0,VALUELONGD ; T0 = Long Data Offset
  ld t0,0(t0)      ; T0 = Long Data
  la t1,VALUELONGE ; T1 = Long Data Offset
  ld t1,0(t1)      ; T1 = Long Data
  dmult t0,t1 ; HI/LO = Test Long Data
  mflo t0 ; T0 = LO
  la t1,LOLONG ; T1 = LOLONG Offset
  sd t0,0(t1)  ; LOLONG = Long Data
  mfhi t0 ; T0 = HI
  la t1,HILONG ; T1 = HILONG Offset
  sd t0,0(t1)  ; HILONG = Long Data
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
  la t0,LOLONG        ; T0 = Long Data Offset
  ld t1,0(t0)         ; T1 = Long Data
  la t0,DMULTLOCHECKD ; T0 = Long Check Data Offset
  ld t2,0(t0)         ; T2 = Long Check Data
  beq t1,t2,DMULTLOPASSD ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,96,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DMULTENDD
  nop ; Delay Slot
  DMULTLOPASSD:
  PrintString $A010,528,96,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,HILONG        ; T0 = Long Data Offset
  ld t1,0(t0)         ; T1 = Long Data
  la t0,DMULTHICHECKD ; T0 = Long Check Data Offset
  ld t2,0(t0)         ; T2 = Long Check Data
  beq t1,t2,DMULTHIPASSD ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,104,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DMULTENDD
  nop ; Delay Slot
  DMULTHIPASSD:
  PrintString $A010,528,104,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DMULTENDD:

  la t0,VALUELONGE ; T0 = Long Data Offset
  ld t0,0(t0)      ; T0 = Long Data
  la t1,VALUELONGF ; T1 = Long Data Offset
  ld t1,0(t1)      ; T1 = Long Data
  dmult t0,t1 ; HI/LO = Test Long Data
  mflo t0 ; T0 = LO
  la t1,LOLONG ; T1 = LOLONG Offset
  sd t0,0(t1)  ; LOLONG = Long Data
  mfhi t0 ; T0 = HI
  la t1,HILONG ; T1 = HILONG Offset
  sd t0,0(t1)  ; HILONG = Long Data
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
  la t0,LOLONG        ; T0 = Long Data Offset
  ld t1,0(t0)         ; T1 = Long Data
  la t0,DMULTLOCHECKE ; T0 = Long Check Data Offset
  ld t2,0(t0)         ; T2 = Long Check Data
  beq t1,t2,DMULTLOPASSE ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,120,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DMULTENDE
  nop ; Delay Slot
  DMULTLOPASSE:
  PrintString $A010,528,120,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,HILONG        ; T0 = Long Data Offset
  ld t1,0(t0)         ; T1 = Long Data
  la t0,DMULTHICHECKE ; T0 = Long Check Data Offset
  ld t2,0(t0)         ; T2 = Long Check Data
  beq t1,t2,DMULTHIPASSE ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,128,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DMULTENDE
  nop ; Delay Slot
  DMULTHIPASSE:
  PrintString $A010,528,128,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DMULTENDE:

  la t0,VALUELONGF ; T0 = Long Data Offset
  ld t0,0(t0)      ; T0 = Long Data
  la t1,VALUELONGG ; T1 = Long Data Offset
  ld t1,0(t1)      ; T1 = Long Data
  dmult t0,t1 ; HI/LO = Test Long Data
  mflo t0 ; T0 = LO
  la t1,LOLONG ; T1 = LOLONG Offset
  sd t0,0(t1)  ; LOLONG = Long Data
  mfhi t0 ; T0 = HI
  la t1,HILONG ; T1 = HILONG Offset
  sd t0,0(t1)  ; HILONG = Long Data
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
  la t0,LOLONG        ; T0 = Long Data Offset
  ld t1,0(t0)         ; T1 = Long Data
  la t0,DMULTLOCHECKF ; T0 = Long Check Data Offset
  ld t2,0(t0)         ; T2 = Long Check Data
  beq t1,t2,DMULTLOPASSF ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,144,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DMULTENDF
  nop ; Delay Slot
  DMULTLOPASSF:
  PrintString $A010,528,144,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,HILONG        ; T0 = Long Data Offset
  ld t1,0(t0)         ; T1 = Long Data
  la t0,DMULTHICHECKF ; T0 = Long Check Data Offset
  ld t2,0(t0)         ; T2 = Long Check Data
  beq t1,t2,DMULTHIPASSF ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,152,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DMULTENDF
  nop ; Delay Slot
  DMULTHIPASSF:
  PrintString $A010,528,152,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DMULTENDF:

  la t0,VALUELONGA ; T0 = Long Data Offset
  ld t0,0(t0)      ; T0 = Long Data
  la t1,VALUELONGG ; T1 = Long Data Offset
  ld t1,0(t1)      ; T1 = Long Data
  dmult t0,t1 ; HI/LO = Test Long Data
  mflo t0 ; T0 = LO
  la t1,LOLONG ; T1 = LOLONG Offset
  sd t0,0(t1)  ; LOLONG = Long Data
  mfhi t0 ; T0 = HI
  la t1,HILONG ; T1 = HILONG Offset
  sd t0,0(t1)  ; HILONG = Long Data
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
  la t0,LOLONG        ; T0 = Long Data Offset
  ld t1,0(t0)         ; T1 = Long Data
  la t0,DMULTLOCHECKG ; T0 = Long Check Data Offset
  ld t2,0(t0)         ; T2 = Long Check Data
  beq t1,t2,DMULTLOPASSG ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,168,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DMULTENDG
  nop ; Delay Slot
  DMULTLOPASSG:
  PrintString $A010,528,168,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,HILONG        ; T0 = Long Data Offset
  ld t1,0(t0)         ; T1 = Long Data
  la t0,DMULTHICHECKG ; T0 = Long Check Data Offset
  ld t2,0(t0)         ; T2 = Long Check Data
  beq t1,t2,DMULTHIPASSG ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,176,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DMULTENDG
  nop ; Delay Slot
  DMULTHIPASSG:
  PrintString $A010,528,176,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DMULTENDG:


  PrintString $A010,0,184,FontBlack,PAGEBREAK,79 ; Print Text String To VRAM Using Font At X,Y Position


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

  align 8 ; Align 64-bit
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