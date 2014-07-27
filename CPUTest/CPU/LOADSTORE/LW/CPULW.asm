; N64 'Bare Metal' CPU Load Word Test Demo by krom (Peter Lemon):

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




  PrintString $A010,88,8,FontRed,WORDHEX,9 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,232,8,FontRed,WORDDEC,13 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,384,8,FontRed,RTHEX,7 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,528,8,FontRed,TEST,10 ; Print Text String To VRAM Using Font At X,Y Position


  PrintString $A010,0,16,FontBlack,PAGEBREAK,79 ; Print Text String To VRAM Using Font At X,Y Position


  PrintString $A010,8,24,FontRed,LW,1 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,VALUEWORDA ; T0 = Word Data Offset
  lw t0,0(t0) ; T0 = Test Long Data
  la t1,RTLONG ; T1 = RTLONG Offset
  sd t0,0(t1)  ; RTLONG = Long Data
  PrintString $A010,144,24,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,24,FontBlack,VALUEWORDA,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,24,FontBlack,TEXTWORDA,0  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,24,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,24,FontBlack,RTLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RTLONG   ; T0 = Long Data Offset
  ld t1,0(t0)    ; T1 = Long Data
  la t0,LWCHECKA ; T0 = Long Check Data Offset
  ld t2,0(t0)    ; T2 = Long Check Data
  beq t1,t2,LWPASSA ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,24,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j LWENDA
  nop ; Delay Slot
  LWPASSA:
  PrintString $A010,528,24,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  LWENDA:

  la t0,VALUEWORDB ; T0 = Word Data Offset
  lw t0,0(t0) ; T0 = Test Long Data
  la t1,RTLONG ; T1 = RTLONG Offset
  sd t0,0(t1)  ; RTLONG = Long Data
  PrintString $A010,144,32,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,32,FontBlack,VALUEWORDB,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,296,32,FontBlack,TEXTWORDB,8  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,32,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,32,FontBlack,RTLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RTLONG   ; T0 = Long Data Offset
  ld t1,0(t0)    ; T1 = Long Data
  la t0,LWCHECKB ; T0 = Long Check Data Offset
  ld t2,0(t0)    ; T2 = Long Check Data
  beq t1,t2,LWPASSB ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,32,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j LWENDB
  nop ; Delay Slot
  LWPASSB:
  PrintString $A010,528,32,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  LWENDB:

  la t0,VALUEWORDC ; T0 = Word Data Offset
  lw t0,0(t0) ; T0 = Test Long Data
  la t1,RTLONG ; T1 = RTLONG Offset
  sd t0,0(t1)  ; RTLONG = Long Data
  PrintString $A010,144,40,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,40,FontBlack,VALUEWORDC,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,320,40,FontBlack,TEXTWORDC,5  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,40,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,40,FontBlack,RTLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RTLONG   ; T0 = Long Data Offset
  ld t1,0(t0)    ; T1 = Long Data
  la t0,LWCHECKC ; T0 = Long Check Data Offset
  ld t2,0(t0)    ; T2 = Long Check Data
  beq t1,t2,LWPASSC ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,40,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j LWENDC
  nop ; Delay Slot
  LWPASSC:
  PrintString $A010,528,40,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  LWENDC:

  la t0,VALUEWORDD ; T0 = Word Data Offset
  lw t0,0(t0) ; T0 = Test Long Data
  la t1,RTLONG ; T1 = RTLONG Offset
  sd t0,0(t1)  ; RTLONG = Long Data
  PrintString $A010,144,48,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,48,FontBlack,VALUEWORDD,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,296,48,FontBlack,TEXTWORDD,8  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,48,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,48,FontBlack,RTLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RTLONG   ; T0 = Long Data Offset
  ld t1,0(t0)    ; T1 = Long Data
  la t0,LWCHECKD ; T0 = Long Check Data Offset
  ld t2,0(t0)    ; T2 = Long Check Data
  beq t1,t2,LWPASSD ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,48,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j LWENDD
  nop ; Delay Slot
  LWPASSD:
  PrintString $A010,528,48,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  LWENDD:

  la t0,VALUEWORDE ; T0 = Word Data Offset
  lw t0,0(t0) ; T0 = Test Long Data
  la t1,RTLONG ; T1 = RTLONG Offset
  sd t0,0(t1)  ; RTLONG = Long Data
  PrintString $A010,144,56,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,56,FontBlack,VALUEWORDE,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,56,FontBlack,TEXTWORDE,9  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,56,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,56,FontBlack,RTLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RTLONG   ; T0 = Long Data Offset
  ld t1,0(t0)    ; T1 = Long Data
  la t0,LWCHECKE ; T0 = Long Check Data Offset
  ld t2,0(t0)    ; T2 = Long Check Data
  beq t1,t2,LWPASSE ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,56,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j LWENDE
  nop ; Delay Slot
  LWPASSE:
  PrintString $A010,528,56,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  LWENDE:

  la t0,VALUEWORDF ; T0 = Word Data Offset
  lw t0,0(t0) ; T0 = Test Long Data
  la t1,RTLONG ; T1 = RTLONG Offset
  sd t0,0(t1)  ; RTLONG = Long Data
  PrintString $A010,144,64,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,64,FontBlack,VALUEWORDF,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,312,64,FontBlack,TEXTWORDF,6  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,64,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,64,FontBlack,RTLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RTLONG   ; T0 = Long Data Offset
  ld t1,0(t0)    ; T1 = Long Data
  la t0,LWCHECKF ; T0 = Long Check Data Offset
  ld t2,0(t0)    ; T2 = Long Check Data
  beq t1,t2,LWPASSF ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,64,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j LWENDF
  nop ; Delay Slot
  LWPASSF:
  PrintString $A010,528,64,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  LWENDF:

  la t0,VALUEWORDG ; T0 = Word Data Offset
  lw t0,0(t0) ; T0 = Test Long Data
  la t1,RTLONG ; T1 = RTLONG Offset
  sd t0,0(t1)  ; RTLONG = Long Data
  PrintString $A010,144,72,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,72,FontBlack,VALUEWORDG,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,72,FontBlack,TEXTWORDG,9  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,72,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,72,FontBlack,RTLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RTLONG   ; T0 = Long Data Offset
  ld t1,0(t0)    ; T1 = Long Data
  la t0,LWCHECKG ; T0 = Long Check Data Offset
  ld t2,0(t0)    ; T2 = Long Check Data
  beq t1,t2,LWPASSG ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,72,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j LWENDG
  nop ; Delay Slot
  LWPASSG:
  PrintString $A010,528,72,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  LWENDG:


  PrintString $A010,8,88,FontRed,LWL,2 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,VALUEWORDA ; T0 = Word Data Offset
  lwl t0,0(t0) ; T0 = Test Long Data
  la t1,RTLONG ; T1 = RTLONG Offset
  sd t0,0(t1)  ; RTLONG = Long Data
  PrintString $A010,144,88,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,88,FontBlack,VALUEWORDA,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,88,FontBlack,TEXTWORDA,0  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,88,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,88,FontBlack,RTLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RTLONG    ; T0 = Long Data Offset
  ld t1,0(t0)     ; T1 = Long Data
  la t0,LWLCHECKA ; T0 = Long Check Data Offset
  ld t2,0(t0)     ; T2 = Long Check Data
  beq t1,t2,LWLPASSA ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,88,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j LWLENDA
  nop ; Delay Slot
  LWLPASSA:
  PrintString $A010,528,88,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  LWLENDA:

  la t0,VALUEWORDB ; T0 = Word Data Offset
  lwl t0,0(t0) ; T0 = Test Long Data
  la t1,RTLONG ; T1 = RTLONG Offset
  sd t0,0(t1)  ; RTLONG = Long Data
  PrintString $A010,144,96,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,96,FontBlack,VALUEWORDB,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,296,96,FontBlack,TEXTWORDB,8  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,96,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,96,FontBlack,RTLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RTLONG    ; T0 = Long Data Offset
  ld t1,0(t0)     ; T1 = Long Data
  la t0,LWLCHECKB ; T0 = Long Check Data Offset
  ld t2,0(t0)     ; T2 = Long Check Data
  beq t1,t2,LWLPASSB ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,96,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j LWLENDB
  nop ; Delay Slot
  LWLPASSB:
  PrintString $A010,528,96,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  LWLENDB:

  la t0,VALUEWORDC ; T0 = Word Data Offset
  lwl t0,0(t0) ; T0 = Test Long Data
  la t1,RTLONG ; T1 = RTLONG Offset
  sd t0,0(t1)  ; RTLONG = Long Data
  PrintString $A010,144,104,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,104,FontBlack,VALUEWORDC,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,320,104,FontBlack,TEXTWORDC,5  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,104,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,104,FontBlack,RTLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RTLONG    ; T0 = Long Data Offset
  ld t1,0(t0)     ; T1 = Long Data
  la t0,LWLCHECKC ; T0 = Long Check Data Offset
  ld t2,0(t0)     ; T2 = Long Check Data
  beq t1,t2,LWLPASSC ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,104,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j LWLENDC
  nop ; Delay Slot
  LWLPASSC:
  PrintString $A010,528,104,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  LWLENDC:

  la t0,VALUEWORDD ; T0 = Word Data Offset
  lwl t0,0(t0) ; T0 = Test Long Data
  la t1,RTLONG ; T1 = RTLONG Offset
  sd t0,0(t1)  ; RTLONG = Long Data
  PrintString $A010,144,112,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,112,FontBlack,VALUEWORDD,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,296,112,FontBlack,TEXTWORDD,8  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,112,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,112,FontBlack,RTLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RTLONG    ; T0 = Long Data Offset
  ld t1,0(t0)     ; T1 = Long Data
  la t0,LWLCHECKD ; T0 = Long Check Data Offset
  ld t2,0(t0)     ; T2 = Long Check Data
  beq t1,t2,LWLPASSD ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,112,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j LWLENDD
  nop ; Delay Slot
  LWLPASSD:
  PrintString $A010,528,112,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  LWLENDD:

  la t0,VALUEWORDE ; T0 = Word Data Offset
  lwl t0,0(t0) ; T0 = Test Long Data
  la t1,RTLONG ; T1 = RTLONG Offset
  sd t0,0(t1)  ; RTLONG = Long Data
  PrintString $A010,144,120,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,120,FontBlack,VALUEWORDE,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,120,FontBlack,TEXTWORDE,9  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,120,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,120,FontBlack,RTLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RTLONG    ; T0 = Long Data Offset
  ld t1,0(t0)     ; T1 = Long Data
  la t0,LWLCHECKE ; T0 = Long Check Data Offset
  ld t2,0(t0)     ; T2 = Long Check Data
  beq t1,t2,LWLPASSE ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,120,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j LWLENDE
  nop ; Delay Slot
  LWLPASSE:
  PrintString $A010,528,120,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  LWLENDE:

  la t0,VALUEWORDF ; T0 = Word Data Offset
  lwl t0,0(t0) ; T0 = Test Long Data
  la t1,RTLONG ; T1 = RTLONG Offset
  sd t0,0(t1)  ; RTLONG = Long Data
  PrintString $A010,144,128,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,128,FontBlack,VALUEWORDF,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,312,128,FontBlack,TEXTWORDF,6  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,128,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,128,FontBlack,RTLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RTLONG    ; T0 = Long Data Offset
  ld t1,0(t0)     ; T1 = Long Data
  la t0,LWLCHECKF ; T0 = Long Check Data Offset
  ld t2,0(t0)     ; T2 = Long Check Data
  beq t1,t2,LWLPASSF ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,128,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j LWLENDF
  nop ; Delay Slot
  LWLPASSF:
  PrintString $A010,528,128,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  LWLENDF:

  la t0,VALUEWORDG ; T0 = Word Data Offset
  lwl t0,0(t0) ; T0 = Test Long Data
  la t1,RTLONG ; T1 = RTLONG Offset
  sd t0,0(t1)  ; RTLONG = Long Data
  PrintString $A010,144,136,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,136,FontBlack,VALUEWORDG,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,136,FontBlack,TEXTWORDG,9  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,136,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,136,FontBlack,RTLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RTLONG    ; T0 = Long Data Offset
  ld t1,0(t0)     ; T1 = Long Data
  la t0,LWLCHECKG ; T0 = Long Check Data Offset
  ld t2,0(t0)     ; T2 = Long Check Data
  beq t1,t2,LWLPASSG ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,136,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j LWLENDG
  nop ; Delay Slot
  LWLPASSG:
  PrintString $A010,528,136,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  LWLENDG:


  PrintString $A010,8,152,FontRed,LWR,2 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,VALUEWORDA ; T0 = Word Data Offset
  lwr t0,0(t0) ; T0 = Test Long Data
  la t1,RTLONG ; T1 = RTLONG Offset
  sd t0,0(t1)  ; RTLONG = Long Data
  PrintString $A010,144,152,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,152,FontBlack,VALUEWORDA,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,152,FontBlack,TEXTWORDA,0  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,152,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,152,FontBlack,RTLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RTLONG    ; T0 = Long Data Offset
  ld t1,0(t0)     ; T1 = Long Data
  la t0,LWRCHECKA ; T0 = Long Check Data Offset
  ld t2,0(t0)     ; T2 = Long Check Data
  beq t1,t2,LWRPASSA ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,152,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j LWRENDA
  nop ; Delay Slot
  LWRPASSA:
  PrintString $A010,528,152,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  LWRENDA:

  la t0,VALUEWORDB ; T0 = Word Data Offset
  lwr t0,0(t0) ; T0 = Test Long Data
  la t1,RTLONG ; T1 = RTLONG Offset
  sd t0,0(t1)  ; RTLONG = Long Data
  PrintString $A010,144,160,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,160,FontBlack,VALUEWORDB,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,296,160,FontBlack,TEXTWORDB,8  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,160,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,160,FontBlack,RTLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RTLONG    ; T0 = Long Data Offset
  ld t1,0(t0)     ; T1 = Long Data
  la t0,LWRCHECKB ; T0 = Long Check Data Offset
  ld t2,0(t0)     ; T2 = Long Check Data
  beq t1,t2,LWRPASSB ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,160,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j LWRENDB
  nop ; Delay Slot
  LWRPASSB:
  PrintString $A010,528,160,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  LWRENDB:

  la t0,VALUEWORDC ; T0 = Word Data Offset
  lwr t0,0(t0) ; T0 = Test Long Data
  la t1,RTLONG ; T1 = RTLONG Offset
  sd t0,0(t1)  ; RTLONG = Long Data
  PrintString $A010,144,168,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,168,FontBlack,VALUEWORDC,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,320,168,FontBlack,TEXTWORDC,5  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,168,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,168,FontBlack,RTLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RTLONG    ; T0 = Long Data Offset
  ld t1,0(t0)     ; T1 = Long Data
  la t0,LWRCHECKC ; T0 = Long Check Data Offset
  ld t2,0(t0)     ; T2 = Long Check Data
  beq t1,t2,LWRPASSC ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,168,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j LWRENDC
  nop ; Delay Slot
  LWRPASSC:
  PrintString $A010,528,168,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  LWRENDC:

  la t0,VALUEWORDD ; T0 = Word Data Offset
  lwr t0,0(t0) ; T0 = Test Long Data
  la t1,RTLONG ; T1 = RTLONG Offset
  sd t0,0(t1)  ; RTLONG = Long Data
  PrintString $A010,144,176,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,176,FontBlack,VALUEWORDD,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,296,176,FontBlack,TEXTWORDD,8  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,176,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,176,FontBlack,RTLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RTLONG    ; T0 = Long Data Offset
  ld t1,0(t0)     ; T1 = Long Data
  la t0,LWRCHECKD ; T0 = Long Check Data Offset
  ld t2,0(t0)     ; T2 = Long Check Data
  beq t1,t2,LWRPASSD ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,176,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j LWRENDD
  nop ; Delay Slot
  LWRPASSD:
  PrintString $A010,528,176,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  LWRENDD:

  la t0,VALUEWORDE ; T0 = Word Data Offset
  lwr t0,0(t0) ; T0 = Test Long Data
  la t1,RTLONG ; T1 = RTLONG Offset
  sd t0,0(t1)  ; RTLONG = Long Data
  PrintString $A010,144,184,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,184,FontBlack,VALUEWORDE,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,184,FontBlack,TEXTWORDE,9  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,184,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,184,FontBlack,RTLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RTLONG    ; T0 = Long Data Offset
  ld t1,0(t0)     ; T1 = Long Data
  la t0,LWRCHECKE ; T0 = Long Check Data Offset
  ld t2,0(t0)     ; T2 = Long Check Data
  beq t1,t2,LWRPASSE ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,184,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j LWRENDE
  nop ; Delay Slot
  LWRPASSE:
  PrintString $A010,528,184,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  LWRENDE:

  la t0,VALUEWORDF ; T0 = Word Data Offset
  lwr t0,0(t0) ; T0 = Test Long Data
  la t1,RTLONG ; T1 = RTLONG Offset
  sd t0,0(t1)  ; RTLONG = Long Data
  PrintString $A010,144,192,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,192,FontBlack,VALUEWORDF,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,312,192,FontBlack,TEXTWORDF,6  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,192,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,192,FontBlack,RTLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RTLONG    ; T0 = Long Data Offset
  ld t1,0(t0)     ; T1 = Long Data
  la t0,LWRCHECKF ; T0 = Long Check Data Offset
  ld t2,0(t0)     ; T2 = Long Check Data
  beq t1,t2,LWRPASSF ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,192,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j LWRENDF
  nop ; Delay Slot
  LWRPASSF:
  PrintString $A010,528,192,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  LWRENDF:

  la t0,VALUEWORDG ; T0 = Word Data Offset
  lwr t0,0(t0) ; T0 = Test Long Data
  la t1,RTLONG ; T1 = RTLONG Offset
  sd t0,0(t1)  ; RTLONG = Long Data
  PrintString $A010,144,200,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,200,FontBlack,VALUEWORDG,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,200,FontBlack,TEXTWORDG,9  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,200,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,200,FontBlack,RTLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RTLONG    ; T0 = Long Data Offset
  ld t1,0(t0)     ; T1 = Long Data
  la t0,LWRCHECKG ; T0 = Long Check Data Offset
  ld t2,0(t0)     ; T2 = Long Check Data
  beq t1,t2,LWRPASSG ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,200,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j LWRENDG
  nop ; Delay Slot
  LWRPASSG:
  PrintString $A010,528,200,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  LWRENDG:


  PrintString $A010,8,216,FontRed,LWU,2 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,VALUEWORDA ; T0 = Word Data Offset
  lwu t0,0(t0) ; T0 = Test Long Data
  la t1,RTLONG ; T1 = RTLONG Offset
  sd t0,0(t1)  ; RTLONG = Long Data
  PrintString $A010,144,216,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,216,FontBlack,VALUEWORDA,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,216,FontBlack,TEXTWORDA,0  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,216,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,216,FontBlack,RTLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RTLONG    ; T0 = Long Data Offset
  ld t1,0(t0)     ; T1 = Long Data
  la t0,LWUCHECKA ; T0 = Long Check Data Offset
  ld t2,0(t0)     ; T2 = Long Check Data
  beq t1,t2,LWUPASSA ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,216,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j LWUENDA
  nop ; Delay Slot
  LWUPASSA:
  PrintString $A010,528,216,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  LWUENDA:

  la t0,VALUEWORDB ; T0 = Word Data Offset
  lwu t0,0(t0) ; T0 = Test Long Data
  la t1,RTLONG ; T1 = RTLONG Offset
  sd t0,0(t1)  ; RTLONG = Long Data
  PrintString $A010,144,224,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,224,FontBlack,VALUEWORDB,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,296,224,FontBlack,TEXTWORDB,8  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,224,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,224,FontBlack,RTLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RTLONG    ; T0 = Long Data Offset
  ld t1,0(t0)     ; T1 = Long Data
  la t0,LWUCHECKB ; T0 = Long Check Data Offset
  ld t2,0(t0)     ; T2 = Long Check Data
  beq t1,t2,LWUPASSB ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,224,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j LWUENDB
  nop ; Delay Slot
  LWUPASSB:
  PrintString $A010,528,224,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  LWUENDB:

  la t0,VALUEWORDC ; T0 = Word Data Offset
  lwu t0,0(t0) ; T0 = Test Long Data
  la t1,RTLONG ; T1 = RTLONG Offset
  sd t0,0(t1)  ; RTLONG = Long Data
  PrintString $A010,144,232,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,232,FontBlack,VALUEWORDC,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,320,232,FontBlack,TEXTWORDC,5  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,232,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,232,FontBlack,RTLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RTLONG    ; T0 = Long Data Offset
  ld t1,0(t0)     ; T1 = Long Data
  la t0,LWUCHECKC ; T0 = Long Check Data Offset
  ld t2,0(t0)     ; T2 = Long Check Data
  beq t1,t2,LWUPASSC ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,232,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j LWUENDC
  nop ; Delay Slot
  LWUPASSC:
  PrintString $A010,528,232,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  LWUENDC:

  la t0,VALUEWORDD ; T0 = Word Data Offset
  lwu t0,0(t0) ; T0 = Test Long Data
  la t1,RTLONG ; T1 = RTLONG Offset
  sd t0,0(t1)  ; RTLONG = Long Data
  PrintString $A010,144,240,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,240,FontBlack,VALUEWORDD,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,296,240,FontBlack,TEXTWORDD,8  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,240,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,240,FontBlack,RTLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RTLONG    ; T0 = Long Data Offset
  ld t1,0(t0)     ; T1 = Long Data
  la t0,LWUCHECKD ; T0 = Long Check Data Offset
  ld t2,0(t0)     ; T2 = Long Check Data
  beq t1,t2,LWUPASSD ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,240,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j LWUENDD
  nop ; Delay Slot
  LWUPASSD:
  PrintString $A010,528,240,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  LWUENDD:

  la t0,VALUEWORDE ; T0 = Word Data Offset
  lwu t0,0(t0) ; T0 = Test Long Data
  la t1,RTLONG ; T1 = RTLONG Offset
  sd t0,0(t1)  ; RTLONG = Long Data
  PrintString $A010,144,248,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,248,FontBlack,VALUEWORDE,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,248,FontBlack,TEXTWORDE,9  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,248,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,248,FontBlack,RTLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RTLONG    ; T0 = Long Data Offset
  ld t1,0(t0)     ; T1 = Long Data
  la t0,LWUCHECKE ; T0 = Long Check Data Offset
  ld t2,0(t0)     ; T2 = Long Check Data
  beq t1,t2,LWUPASSE ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,248,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j LWUENDE
  nop ; Delay Slot
  LWUPASSE:
  PrintString $A010,528,248,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  LWUENDE:

  la t0,VALUEWORDF ; T0 = Word Data Offset
  lwu t0,0(t0) ; T0 = Test Long Data
  la t1,RTLONG ; T1 = RTLONG Offset
  sd t0,0(t1)  ; RTLONG = Long Data
  PrintString $A010,144,256,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,256,FontBlack,VALUEWORDF,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,312,256,FontBlack,TEXTWORDF,6  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,256,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,256,FontBlack,RTLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RTLONG    ; T0 = Long Data Offset
  ld t1,0(t0)     ; T1 = Long Data
  la t0,LWUCHECKF ; T0 = Long Check Data Offset
  ld t2,0(t0)     ; T2 = Long Check Data
  beq t1,t2,LWUPASSF ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,256,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j LWUENDF
  nop ; Delay Slot
  LWUPASSF:
  PrintString $A010,528,256,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  LWUENDF:

  la t0,VALUEWORDG ; T0 = Word Data Offset
  lwu t0,0(t0) ; T0 = Test Long Data
  la t1,RTLONG ; T1 = RTLONG Offset
  sd t0,0(t1)  ; RTLONG = Long Data
  PrintString $A010,144,264,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,264,FontBlack,VALUEWORDG,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,264,FontBlack,TEXTWORDG,9  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,264,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,264,FontBlack,RTLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RTLONG    ; T0 = Long Data Offset
  ld t1,0(t0)     ; T1 = Long Data
  la t0,LWUCHECKG ; T0 = Long Check Data Offset
  ld t2,0(t0)     ; T2 = Long Check Data
  beq t1,t2,LWUPASSG ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,264,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j LWUENDG
  nop ; Delay Slot
  LWUPASSG:
  PrintString $A010,528,264,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  LWUENDG:


  PrintString $A010,0,272,FontBlack,PAGEBREAK,79 ; Print Text String To VRAM Using Font At X,Y Position


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

LW: db "LW"
LWL: db "LWL"
LWR: db "LWR"
LWU: db "LWU"

RTHEX: db "RT (Hex)"
WORDHEX: db "WORD (Hex)"
WORDDEC: db "WORD (Decimal)"
TEST: db "Test Result"
FAIL: db "FAIL"
PASS: db "PASS"

DOLLAR: db "$"

TEXTWORDA: db "0"
TEXTWORDB: db "123456789"
TEXTWORDC: db "123456"
TEXTWORDD: db "123451234"
TEXTWORDE: db "-123451234"
TEXTWORDF: db "-123456"
TEXTWORDG: db "-123456789"

PAGEBREAK: db "--------------------------------------------------------------------------------"

  align 8 ; Align 64-bit
VALUEWORDA: dw 0
VALUEWORDB: dw 123456789
VALUEWORDC: dw 123456
VALUEWORDD: dw 123451234
VALUEWORDE: dw -123451234
VALUEWORDF: dw -123456
VALUEWORDG: dw -123456789

  align 8 ; Align 64-bit
LWCHECKA: data $0000000000000000
LWCHECKB: data $00000000075BCD15
LWCHECKC: data $000000000001E240
LWCHECKD: data $00000000075BB762
LWCHECKE: data $FFFFFFFFF8A4489E
LWCHECKF: data $FFFFFFFFFFFE1DC0
LWCHECKG: data $FFFFFFFFF8A432EB

LWLCHECKA: data $0000000000000000
LWLCHECKB: data $00000000075BCD15
LWLCHECKC: data $000000000001E240
LWLCHECKD: data $00000000075BB762
LWLCHECKE: data $FFFFFFFFF8A4489E
LWLCHECKF: data $FFFFFFFFFFFE1DC0
LWLCHECKG: data $FFFFFFFFF8A432EB

LWRCHECKA: data $FFFFFFFF80008C00
LWRCHECKB: data $FFFFFFFF80008C07
LWRCHECKC: data $FFFFFFFF80008C00
LWRCHECKD: data $FFFFFFFF80008C07
LWRCHECKE: data $FFFFFFFF80008CF8
LWRCHECKF: data $FFFFFFFF80008CFF
LWRCHECKG: data $FFFFFFFF80008CF8

LWUCHECKA: data $0000000000000000
LWUCHECKB: data $00000000075BCD15
LWUCHECKC: data $000000000001E240
LWUCHECKD: data $00000000075BB762
LWUCHECKE: data $00000000F8A4489E
LWUCHECKF: data $00000000FFFE1DC0
LWUCHECKG: data $00000000F8A432EB

RTLONG: data 0

FontBlack: incbin FontBlack8x8.bin
FontGreen: incbin FontGreen8x8.bin
FontRed: incbin FontRed8x8.bin