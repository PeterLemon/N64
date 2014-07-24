; N64 'Bare Metal' CPU Bitwise Logical OR Test Demo by krom (Peter Lemon):

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
  PrintString $A010,384,8,FontRed,RDHEX,7 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,528,8,FontRed,TEST,10 ; Print Text String To VRAM Using Font At X,Y Position


  PrintString $A010,0,16,FontBlack,PAGEBREAK,79 ; Print Text String To VRAM Using Font At X,Y Position


  PrintString $A010,8,24,FontRed,OR,1 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,VALUELONGA ; T0 = Long Data Offset
  ld t0,0(t0)      ; T0 = Long Data
  la t1,VALUELONGB ; T1 = Long Data Offset
  ld t1,0(t1)      ; T1 = Long Data
  or t0,t1 ; T0 = Test Long Data
  la t1,RDLONG ; T1 = RDLONG Offset
  sd t0,0(t1)  ; RDLONG = Long Data
  PrintString $A010,80,24,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,24,FontBlack,VALUELONGA,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,24,FontBlack,TEXTLONGA,0  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,80,32,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,32,FontBlack,VALUELONGB,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,232,32,FontBlack,TEXTLONGB,16 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,32,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,32,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDLONG   ; T0 = Long Data Offset
  ld t1,0(t0)    ; T1 = Long Data
  la t0,ORCHECKA ; T0 = Long Check Data Offset
  ld t2,0(t0)    ; T2 = Long Check Data
  beq t1,t2,ORPASSA ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,32,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j ORENDA
  nop ; Delay Slot
  ORPASSA:
  PrintString $A010,528,32,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  ORENDA:

  la t0,VALUELONGB ; T0 = Long Data Offset
  ld t0,0(t0)      ; T0 = Long Data
  la t1,VALUELONGC ; T1 = Long Data Offset
  ld t1,0(t1)      ; T1 = Long Data
  or t0,t1 ; T0 = Test Long Data
  la t1,RDLONG ; T1 = RDLONG Offset
  sd t0,0(t1)  ; RDLONG = Long Data
  PrintString $A010,80,48,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,48,FontBlack,VALUELONGB,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,232,48,FontBlack,TEXTLONGB,16 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,80,56,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,56,FontBlack,VALUELONGC,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,56,FontBlack,TEXTLONGC,9  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,56,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,56,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDLONG   ; T0 = Long Data Offset
  ld t1,0(t0)    ; T1 = Long Data
  la t0,ORCHECKB ; T0 = Long Check Data Offset
  ld t2,0(t0)    ; T2 = Long Check Data
  beq t1,t2,ORPASSB ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,56,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j ORENDB
  nop ; Delay Slot
  ORPASSB:
  PrintString $A010,528,56,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  ORENDB:

  la t0,VALUELONGC ; T0 = Long Data Offset
  ld t0,0(t0)      ; T0 = Long Data
  la t1,VALUELONGD ; T1 = Long Data Offset
  ld t1,0(t1)      ; T1 = Long Data
  or t0,t1 ; T0 = Test Long Data
  la t1,RDLONG ; T1 = RDLONG Offset
  sd t0,0(t1)  ; RDLONG = Long Data
  PrintString $A010,80,72,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,72,FontBlack,VALUELONGC,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,72,FontBlack,TEXTLONGC,9  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,80,80,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,80,FontBlack,VALUELONGD,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,232,80,FontBlack,TEXTLONGD,16 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,80,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,80,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDLONG   ; T0 = Long Data Offset
  ld t1,0(t0)    ; T1 = Long Data
  la t0,ORCHECKC ; T0 = Long Check Data Offset
  ld t2,0(t0)    ; T2 = Long Check Data
  beq t1,t2,ORPASSC ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,80,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j ORENDC
  nop ; Delay Slot
  ORPASSC:
  PrintString $A010,528,80,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  ORENDC:

  la t0,VALUELONGD ; T0 = Long Data Offset
  ld t0,0(t0)      ; T0 = Long Data
  la t1,VALUELONGE ; T1 = Long Data Offset
  ld t1,0(t1)      ; T1 = Long Data
  or t0,t1 ; T0 = Test Long Data
  la t1,RDLONG ; T1 = RDLONG Offset
  sd t0,0(t1)  ; RDLONG = Long Data
  PrintString $A010,80,96,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,96,FontBlack,VALUELONGD,7   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,232,96,FontBlack,TEXTLONGD,16  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,80,104,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,104,FontBlack,VALUELONGE,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,224,104,FontBlack,TEXTLONGE,17 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,104,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,104,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDLONG   ; T0 = Long Data Offset
  ld t1,0(t0)    ; T1 = Long Data
  la t0,ORCHECKD ; T0 = Long Check Data Offset
  ld t2,0(t0)    ; T2 = Long Check Data
  beq t1,t2,ORPASSD ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,104,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j ORENDD
  nop ; Delay Slot
  ORPASSD:
  PrintString $A010,528,104,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  ORENDD:

  la t0,VALUELONGE ; T0 = Long Data Offset
  ld t0,0(t0)      ; T0 = Long Data
  la t1,VALUELONGF ; T1 = Long Data Offset
  ld t1,0(t1)      ; T1 = Long Data
  or t0,t1 ; T0 = Test Long Data
  la t1,RDLONG ; T1 = RDLONG Offset
  sd t0,0(t1)  ; RDLONG = Long Data
  PrintString $A010,80,120,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,120,FontBlack,VALUELONGE,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,224,120,FontBlack,TEXTLONGE,17 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,80,128,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,128,FontBlack,VALUELONGF,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,280,128,FontBlack,TEXTLONGF,10 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,128,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,128,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDLONG   ; T0 = Long Data Offset
  ld t1,0(t0)    ; T1 = Long Data
  la t0,ORCHECKE ; T0 = Long Check Data Offset
  ld t2,0(t0)    ; T2 = Long Check Data
  beq t1,t2,ORPASSE ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,128,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j ORENDE
  nop ; Delay Slot
  ORPASSE:
  PrintString $A010,528,128,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  ORENDE:

  la t0,VALUELONGF ; T0 = Long Data Offset
  ld t0,0(t0)      ; T0 = Long Data
  la t1,VALUELONGG ; T1 = Long Data Offset
  ld t1,0(t1)      ; T1 = Long Data
  or t0,t1 ; T0 = Test Long Data
  la t1,RDLONG ; T1 = RDLONG Offset
  sd t0,0(t1)  ; RDLONG = Long Data
  PrintString $A010,80,144,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,144,FontBlack,VALUELONGF,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,280,144,FontBlack,TEXTLONGF,10 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,80,152,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,152,FontBlack,VALUELONGG,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,224,152,FontBlack,TEXTLONGG,17 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,152,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,152,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDLONG   ; T0 = Long Data Offset
  ld t1,0(t0)    ; T1 = Long Data
  la t0,ORCHECKF ; T0 = Long Check Data Offset
  ld t2,0(t0)    ; T2 = Long Check Data
  beq t1,t2,ORPASSF ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,152,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j ORENDF
  nop ; Delay Slot
  ORPASSF:
  PrintString $A010,528,152,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  ORENDF:

  la t0,VALUELONGA ; T0 = Long Data Offset
  ld t0,0(t0)      ; T0 = Long Data
  la t1,VALUELONGG ; T1 = Long Data Offset
  ld t1,0(t1)      ; T1 = Long Data
  or t0,t1 ; T0 = Test Long Data
  la t1,RDLONG ; T1 = RDLONG Offset
  sd t0,0(t1)  ; RDLONG = Long Data
  PrintString $A010,80,168,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,168,FontBlack,VALUELONGA,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,168,FontBlack,TEXTLONGA,0  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,80,176,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,176,FontBlack,VALUELONGG,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,224,176,FontBlack,TEXTLONGG,17 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,176,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,176,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDLONG   ; T0 = Long Data Offset
  ld t1,0(t0)    ; T1 = Long Data
  la t0,ORCHECKG ; T0 = Long Check Data Offset
  ld t2,0(t0)    ; T2 = Long Check Data
  beq t1,t2,ORPASSG ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,176,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j ORENDG
  nop ; Delay Slot
  ORPASSG:
  PrintString $A010,528,176,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  ORENDG:


  PrintString $A010,8,192,FontRed,ORI,2 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,VALUELONGA ; T0 = Long Data Offset
  ld t0,0(t0)      ; T0 = Long Data
  ori t0,VALUEILONGB ; T0 = Test Long Data
  la t1,RDLONG ; T1 = RDLONG Offset
  sd t0,0(t1)  ; RDLONG = Long Data
  PrintString $A010,80,192,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,192,FontBlack,VALUELONGA,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,192,FontBlack,TEXTLONGA,0  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,80,200,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,200,FontBlack,ILONGB,7      ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,328,200,FontBlack,TEXTILONGB,4 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,200,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,200,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDLONG    ; T0 = Long Data Offset
  ld t1,0(t0)     ; T1 = Long Data
  la t0,ORICHECKA ; T0 = Long Check Data Offset
  ld t2,0(t0)     ; T2 = Long Check Data
  beq t1,t2,ORIPASSA ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,200,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j ORIENDA
  nop ; Delay Slot
  ORIPASSA:
  PrintString $A010,528,200,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  ORIENDA:

  la t0,VALUELONGB ; T0 = Long Data Offset
  ld t0,0(t0)      ; T0 = Long Data
  ori t0,VALUEILONGC ; T0 = Test Long Data
  la t1,RDLONG ; T1 = RDLONG Offset
  sd t0,0(t1)  ; RDLONG = Long Data
  PrintString $A010,80,216,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,216,FontBlack,VALUELONGB,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,232,216,FontBlack,TEXTLONGB,16 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,80,224,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,224,FontBlack,ILONGC,7      ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,336,224,FontBlack,TEXTILONGC,3 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,224,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,224,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDLONG    ; T0 = Long Data Offset
  ld t1,0(t0)     ; T1 = Long Data
  la t0,ORICHECKB ; T0 = Long Check Data Offset
  ld t2,0(t0)     ; T2 = Long Check Data
  beq t1,t2,ORIPASSB ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,224,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j ORIENDB
  nop ; Delay Slot
  ORIPASSB:
  PrintString $A010,528,224,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  ORIENDB:

  la t0,VALUELONGC ; T0 = Long Data Offset
  ld t0,0(t0)      ; T0 = Long Data
  ori t0,VALUEILONGD ; T0 = Test Long Data
  la t1,RDLONG ; T1 = RDLONG Offset
  sd t0,0(t1)  ; RDLONG = Long Data
  PrintString $A010,80,240,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,240,FontBlack,VALUELONGC,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,240,FontBlack,TEXTLONGC,9  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,80,248,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,248,FontBlack,ILONGD,7      ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,328,248,FontBlack,TEXTILONGD,4 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,248,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,248,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDLONG    ; T0 = Long Data Offset
  ld t1,0(t0)     ; T1 = Long Data
  la t0,ORICHECKC ; T0 = Long Check Data Offset
  ld t2,0(t0)     ; T2 = Long Check Data
  beq t1,t2,ORIPASSC ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,248,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j ORIENDC
  nop ; Delay Slot
  ORIPASSC:
  PrintString $A010,528,248,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  ORIENDC:

  la t0,ILONGD ; T0 = Long Data Offset
  ld t0,0(t0)  ; T0 = Long Data
  ori t0,VALUEILONGE ; T0 = Test Long Data
  la t1,RDLONG ; T1 = RDLONG Offset
  sd t0,0(t1)  ; RDLONG = Long Data
  PrintString $A010,80,264,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,264,FontBlack,ILONGD,7      ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,328,264,FontBlack,TEXTILONGD,4 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,80,272,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,272,FontBlack,ILONGE,7      ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,328,272,FontBlack,TEXTILONGE,4 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,272,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,272,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDLONG    ; T0 = Long Data Offset
  ld t1,0(t0)     ; T1 = Long Data
  la t0,ORICHECKD ; T0 = Long Check Data Offset
  ld t2,0(t0)     ; T2 = Long Check Data
  beq t1,t2,ORIPASSD ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,272,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j ORIENDD
  nop ; Delay Slot
  ORIPASSD:
  PrintString $A010,528,272,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  ORIENDD:

  la t0,VALUELONGE ; T0 = Long Data Offset
  ld t0,0(t0)      ; T0 = Long Data
  ori t0,VALUEILONGF ; T0 = Test Long Data
  la t1,RDLONG ; T1 = RDLONG Offset
  sd t0,0(t1)  ; RDLONG = Long Data
  PrintString $A010,80,288,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,288,FontBlack,VALUELONGE,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,224,288,FontBlack,TEXTLONGE,17 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,80,296,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,296,FontBlack,ILONGF,7      ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,336,296,FontBlack,TEXTILONGF,3 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,296,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,296,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDLONG    ; T0 = Long Data Offset
  ld t1,0(t0)     ; T1 = Long Data
  la t0,ORICHECKE ; T0 = Long Check Data Offset
  ld t2,0(t0)     ; T2 = Long Check Data
  beq t1,t2,ORIPASSE ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,296,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j ORIENDE
  nop ; Delay Slot
  ORIPASSE:
  PrintString $A010,528,296,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  ORIENDE:

  la t0,VALUELONGF ; T0 = Long Data Offset
  ld t0,0(t0)      ; T0 = Long Data
  ori t0,VALUEILONGG ; T0 = Test Long Data
  la t1,RDLONG ; T1 = RDLONG Offset
  sd t0,0(t1)  ; RDLONG = Long Data
  PrintString $A010,80,312,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,312,FontBlack,VALUELONGF,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,280,312,FontBlack,TEXTLONGF,10 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,80,320,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,320,FontBlack,ILONGG,7      ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,328,320,FontBlack,TEXTILONGG,4 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,320,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,320,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDLONG    ; T0 = Long Data Offset
  ld t1,0(t0)     ; T1 = Long Data
  la t0,ORICHECKF ; T0 = Long Check Data Offset
  ld t2,0(t0)     ; T2 = Long Check Data
  beq t1,t2,ORIPASSF ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,320,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j ORIENDF
  nop ; Delay Slot
  ORIPASSF:
  PrintString $A010,528,320,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  ORIENDF:

  la t0,VALUELONGA ; T0 = Long Data Offset
  ld t0,0(t0)      ; T0 = Long Data
  ori t0,VALUEILONGG ; T0 = Test Long Data
  la t1,RDLONG ; T1 = RDLONG Offset
  sd t0,0(t1)  ; RDLONG = Long Data
  PrintString $A010,80,336,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,336,FontBlack,VALUELONGA,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,336,FontBlack,TEXTLONGA,0  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,80,344,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,344,FontBlack,ILONGG,7      ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,328,344,FontBlack,TEXTILONGG,4 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,344,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,344,FontBlack,RDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDLONG    ; T0 = Long Data Offset
  ld t1,0(t0)     ; T1 = Long Data
  la t0,ORICHECKG ; T0 = Long Check Data Offset
  ld t2,0(t0)     ; T2 = Long Check Data
  beq t1,t2,ORIPASSG ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,344,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j ORIENDG
  nop ; Delay Slot
  ORIPASSG:
  PrintString $A010,528,344,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  ORIENDG:


  PrintString $A010,0,352,FontBlack,PAGEBREAK,79 ; Print Text String To VRAM Using Font At X,Y Position


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

OR: db "OR"
ORI: db "ORI"

RDHEX: db "RD (Hex)"
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
TEXTLONGE: db "123456789123456789"
TEXTLONGF: db "12345678956"
TEXTLONGG: db "123456789678912345"

TEXTILONGB: db "12345"
TEXTILONGC: db "1234"
TEXTILONGD: db "12341"
TEXTILONGE: db "23456"
TEXTILONGF: db "3456"
TEXTILONGG: db "32198"

PAGEBREAK: db "--------------------------------------------------------------------------------"

  align 8 ; Align 64-bit
VALUELONGA: data 0
VALUELONGB: data 12345678967891234
VALUELONGC: data 1234567895
VALUELONGD: data 12345678912345678
VALUELONGE: data 123456789123456789
VALUELONGF: data 12345678956
VALUELONGG: data 123456789678912345

ORCHECKA: data $002BDC5461646522
ORCHECKB: data $002BDC5469F667F7
ORCHECKC: data $002BDC545F96D6DF
ORCHECKD: data $01BFDF5FFED4DF5F
ORCHECKE: data $01B69B4BFFDC5F7D
ORCHECKF: data $01B69B4BDFFFFF7D
ORCHECKG: data $01B69B4BCDEBF359

VALUEILONGB: equ 12345
VALUEILONGC: equ 1234
VALUEILONGD: equ 12341
VALUEILONGE: equ 23456
VALUEILONGF: equ 3456
VALUEILONGG: equ 32198
ILONGB: data 12345
ILONGC: data 1234
ILONGD: data 12341
ILONGE: data 23456
ILONGF: data 3456
ILONGG: data 32198

ORICHECKA: data $0000000000003039
ORICHECKB: data $002BDC54616465F2
ORICHECKC: data $00000000499632F7
ORICHECKD: data $0000000000007BB5
ORICHECKE: data $01B69B4BACD05F95
ORICHECKF: data $00000002DFDC7DEE
ORICHECKG: data $0000000000007DC6

RDLONG: data 0

FontBlack: incbin FontBlack8x8.bin
FontGreen: incbin FontGreen8x8.bin
FontRed: incbin FontRed8x8.bin