; N64 'Bare Metal' CPU CP1/FPU Convert Test Demo by krom (Peter Lemon):

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




  PrintString $A010,80,8,FontRed,FSHEX,7 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,224,8,FontRed,FDFSDEC,14 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,8,FontRed,FDHEX,7 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,520,8,FontRed,TEST,10 ; Print Text String To VRAM Using Font At X,Y Position


  PrintString $A010,0,16,FontBlack,PAGEBREAK,79 ; Print Text String To VRAM Using Font At X,Y Position


  PrintString $A010,8,24,FontRed,CVTDL,6 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,VALUELONGA ; T0 = Long Data Offset
  ldc1 f0,0(t0)    ; F0 = Long Data
  cvt.d.l f0 ; Convert To Double Data
  la t0,FDLONG  ; T0 = FDLONG Offset
  sdc1 f0,0(t0) ; FDLONG = Double Data
  PrintString $A010,72,24,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,80,24,FontBlack,VALUELONGA,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,24,FontBlack,TEXTLONGA,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,368,24,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,376,24,FontBlack,FDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,FDLONG      ; T0 = Double Data Offset
  ld t1,0(t0)       ; T1 = Double Data
  la t0,CVTDLCHECKA ; T0 = Long Check Data Offset
  ld t2,0(t0)       ; T2 = Long Check Data
  beq t1,t2,CVTDLPASSA ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,520,24,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j CVTDLENDA
  nop ; Delay Slot
  CVTDLPASSA:
  PrintString $A010,520,24,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  CVTDLENDA:

  la t0,VALUELONGB ; T0 = Long Data Offset
  ldc1 f0,0(t0)    ; F0 = Long Data
  cvt.d.l f0 ; Convert To Double Data
  la t0,FDLONG  ; T0 = FDLONG Offset
  sdc1 f0,0(t0) ; FDLONG = Double Data
  PrintString $A010,72,32,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,80,32,FontBlack,VALUELONGB,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,296,32,FontBlack,TEXTLONGB,7 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,368,32,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,376,32,FontBlack,FDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,FDLONG      ; T0 = Double Data Offset
  ld t1,0(t0)       ; T1 = Double Data
  la t0,CVTDLCHECKB ; T0 = Long Check Data Offset
  ld t2,0(t0)       ; T2 = Long Check Data
  beq t1,t2,CVTDLPASSB ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,520,32,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j CVTDLENDB
  nop ; Delay Slot
  CVTDLPASSB:
  PrintString $A010,520,32,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  CVTDLENDB:

  la t0,VALUELONGC ; T0 = Long Data Offset
  ldc1 f0,0(t0)    ; F0 = Long Data
  cvt.d.l f0 ; Convert To Double Data
  la t0,FDLONG  ; T0 = FDLONG Offset
  sdc1 f0,0(t0) ; FDLONG = Double Data
  PrintString $A010,72,40,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,80,40,FontBlack,VALUELONGC,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,40,FontBlack,TEXTLONGC,8 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,368,40,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,376,40,FontBlack,FDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,FDLONG      ; T0 = Double Data Offset
  ld t1,0(t0)       ; T1 = Double Data
  la t0,CVTDLCHECKC ; T0 = Long Check Data Offset
  ld t2,0(t0)       ; T2 = Long Check Data
  beq t1,t2,CVTDLPASSC ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,520,40,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j CVTDLENDC
  nop ; Delay Slot
  CVTDLPASSC:
  PrintString $A010,520,40,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  CVTDLENDC:

  PrintString $A010,8,56,FontRed,CVTDS,6 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,VALUEFLOATA ; T0 = Float Data Offset
  lwc1 f0,0(t0)     ; F0 = Float Data
  cvt.d.s f0 ; Convert To Double Data
  la t0,FDLONG  ; T0 = FDLONG Offset
  sdc1 f0,0(t0) ; FDLONG = Double Data
  PrintString $A010,136,56,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,144,56,FontBlack,VALUEFLOATA,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,336,56,FontBlack,TEXTFLOATA,2  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,368,56,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,376,56,FontBlack,FDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,FDLONG      ; T0 = Double Data Offset
  ld t1,0(t0)       ; T1 = Double Data
  la t0,CVTDSCHECKA ; T0 = Long Check Data Offset
  ld t2,0(t0)       ; T2 = Long Check Data
  beq t1,t2,CVTDSPASSA ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,520,56,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j CVTDSENDA
  nop ; Delay Slot
  CVTDSPASSA:
  PrintString $A010,520,56,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  CVTDSENDA:

  la t0,VALUEFLOATB ; T0 = Float Data Offset
  lwc1 f0,0(t0)     ; F0 = Float Data
  cvt.d.s f0 ; Convert To Double Data
  la t0,FDLONG  ; T0 = FDLONG Offset
  sdc1 f0,0(t0) ; FDLONG = Double Data
  PrintString $A010,136,64,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,144,64,FontBlack,VALUEFLOATB,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,64,FontBlack,TEXTFLOATB,8  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,368,64,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,376,64,FontBlack,FDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,FDLONG      ; T0 = Double Data Offset
  ld t1,0(t0)       ; T1 = Double Data
  la t0,CVTDSCHECKB ; T0 = Long Check Data Offset
  ld t2,0(t0)       ; T2 = Long Check Data
  beq t1,t2,CVTDSPASSB ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,520,64,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j CVTDSENDB
  nop ; Delay Slot
  CVTDSPASSB:
  PrintString $A010,520,64,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  CVTDSENDB:

  la t0,VALUEFLOATC ; T0 = Float Data Offset
  lwc1 f0,0(t0)     ; F0 = Float Data
  cvt.d.s f0 ; Convert To Double Data
  la t0,FDLONG  ; T0 = FDLONG Offset
  sdc1 f0,0(t0) ; FDLONG = Double Data
  PrintString $A010,136,72,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,144,72,FontBlack,VALUEFLOATC,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,280,72,FontBlack,TEXTFLOATC,9  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,368,72,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,376,72,FontBlack,FDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,FDLONG      ; T0 = Double Data Offset
  ld t1,0(t0)       ; T1 = Double Data
  la t0,CVTDSCHECKC ; T0 = Long Check Data Offset
  ld t2,0(t0)       ; T2 = Long Check Data
  beq t1,t2,CVTDSPASSC ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,520,72,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j CVTDSENDC
  nop ; Delay Slot
  CVTDSPASSC:
  PrintString $A010,520,72,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  CVTDSENDC:


  PrintString $A010,8,88,FontRed,CVTDW,6 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,VALUEWORDA ; T0 = Word Data Offset
  lwc1 f0,0(t0)    ; F0 = Word Data
  cvt.d.w f0 ; Convert To Double Data
  la t0,FDLONG  ; T0 = FDLONG Offset
  sdc1 f0,0(t0) ; FDLONG = Double Data
  PrintString $A010,136,88,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,144,88,FontBlack,VALUEWORDA,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,88,FontBlack,TEXTWORDA,0  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,368,88,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,376,88,FontBlack,FDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,FDLONG      ; T0 = Double Data Offset
  ld t1,0(t0)       ; T1 = Double Data
  la t0,CVTDWCHECKA ; T0 = Long Check Data Offset
  ld t2,0(t0)       ; T2 = Long Check Data
  beq t1,t2,CVTDWPASSA ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,520,88,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j CVTDWENDA
  nop ; Delay Slot
  CVTDWPASSA:
  PrintString $A010,520,88,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  CVTDWENDA:

  la t0,VALUEWORDB ; T0 = Word Data Offset
  lwc1 f0,0(t0)    ; F0 = Word Data
  cvt.d.w f0 ; Convert To Double Data
  la t0,FDLONG  ; T0 = FDLONG Offset
  sdc1 f0,0(t0) ; FDLONG = Double Data
  PrintString $A010,136,96,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,144,96,FontBlack,VALUEWORDB,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,328,96,FontBlack,TEXTWORDB,3  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,368,96,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,376,96,FontBlack,FDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,FDLONG      ; T0 = Double Data Offset
  ld t1,0(t0)       ; T1 = Double Data
  la t0,CVTDWCHECKB ; T0 = Long Check Data Offset
  ld t2,0(t0)       ; T2 = Long Check Data
  beq t1,t2,CVTDWPASSB ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,520,96,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j CVTDWENDB
  nop ; Delay Slot
  CVTDWPASSB:
  PrintString $A010,520,96,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  CVTDWENDB:

  la t0,VALUEWORDC ; T0 = Word Data Offset
  lwc1 f0,0(t0)    ; F0 = Word Data
  cvt.d.w f0 ; Convert To Double Data
  la t0,FDLONG  ; T0 = FDLONG Offset
  sdc1 f0,0(t0) ; FDLONG = Double Data
  PrintString $A010,136,104,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,144,104,FontBlack,VALUEWORDC,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,320,104,FontBlack,TEXTWORDC,4  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,368,104,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,376,104,FontBlack,FDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,FDLONG      ; T0 = Double Data Offset
  ld t1,0(t0)       ; T1 = Double Data
  la t0,CVTDWCHECKC ; T0 = Long Check Data Offset
  ld t2,0(t0)       ; T2 = Long Check Data
  beq t1,t2,CVTDWPASSC ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,520,104,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j CVTDWENDC
  nop ; Delay Slot
  CVTDWPASSC:
  PrintString $A010,520,104,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  CVTDWENDC:


  PrintString $A010,0,112,FontBlack,PAGEBREAK,79 ; Print Text String To VRAM Using Font At X,Y Position


  PrintString $A010,8,120,FontRed,CVTLD,6 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,VALUEDOUBLEA ; T0 = Double Data Offset
  ldc1 f0,0(t0)      ; F0 = Double Data
  cvt.l.d f0 ; Convert To Long Data
  la t0,FDLONG  ; T0 = FDLONG Offset
  sdc1 f0,0(t0) ; FDLONG = Long Data
  PrintString $A010,72,120,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,80,120,FontBlack,VALUEDOUBLEA,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,336,120,FontBlack,TEXTDOUBLEA,2 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,368,120,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,376,120,FontBlack,FDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,FDLONG      ; T0 = Long Data Offset
  ld t1,0(t0)       ; T1 = Long Data
  la t0,CVTLDCHECKA ; T0 = Long Check Data Offset
  ld t2,0(t0)       ; T2 = Long Check Data
  beq t1,t2,CVTLDPASSA ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,520,120,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j CVTLDENDA
  nop ; Delay Slot
  CVTLDPASSA:
  PrintString $A010,520,120,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  CVTLDENDA:

  la t0,VALUEDOUBLEB ; T0 = Double Data Offset
  ldc1 f0,0(t0)      ; F0 = Double Data
  cvt.l.d f0 ; Convert To Long Data
  la t0,FDLONG  ; T0 = FDLONG Offset
  sdc1 f0,0(t0) ; FDLONG = Long Data
  PrintString $A010,72,128,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,80,128,FontBlack,VALUEDOUBLEB,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,224,128,FontBlack,TEXTDOUBLEB,16 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,368,128,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,376,128,FontBlack,FDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,FDLONG      ; T0 = Long Data Offset
  ld t1,0(t0)       ; T1 = Long Data
  la t0,CVTLDCHECKB ; T0 = Long Check Data Offset
  ld t2,0(t0)       ; T2 = Long Check Data
  beq t1,t2,CVTLDPASSB ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,520,128,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j CVTLDENDB
  nop ; Delay Slot
  CVTLDPASSB:
  PrintString $A010,520,128,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  CVTLDENDB:

  la t0,VALUEDOUBLEC ; T0 = Double Data Offset
  ldc1 f0,0(t0)      ; F0 = Double Data
  cvt.l.d f0 ; Convert To Long Data
  la t0,FDLONG  ; T0 = FDLONG Offset
  sdc1 f0,0(t0) ; FDLONG = Long Data
  PrintString $A010,72,136,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,80,136,FontBlack,VALUEDOUBLEC,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,216,136,FontBlack,TEXTDOUBLEC,17 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,368,136,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,376,136,FontBlack,FDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,FDLONG      ; T0 = Long Data Offset
  ld t1,0(t0)       ; T1 = Long Data
  la t0,CVTLDCHECKC ; T0 = Long Check Data Offset
  ld t2,0(t0)       ; T2 = Long Check Data
  beq t1,t2,CVTLDPASSC ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,520,136,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j CVTLDENDC
  nop ; Delay Slot
  CVTLDPASSC:
  PrintString $A010,520,136,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  CVTLDENDC:


  PrintString $A010,8,152,FontRed,CVTLS,6 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,VALUEFLOATA ; T0 = Float Data Offset
  lwc1 f0,0(t0)     ; F0 = Float Data
  cvt.l.s f0 ; Convert To Long Data
  la t0,FDLONG  ; T0 = FDLONG Offset
  sdc1 f0,0(t0) ; FDLONG = Long Data
  PrintString $A010,136,152,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,144,152,FontBlack,VALUEFLOATA,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,336,152,FontBlack,TEXTFLOATA,2  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,368,152,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,376,152,FontBlack,FDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,FDLONG      ; T0 = Long Data Offset
  ld t1,0(t0)       ; T1 = Long Data
  la t0,CVTLSCHECKA ; T0 = Long Check Data Offset
  ld t2,0(t0)       ; T2 = Long Check Data
  beq t1,t2,CVTLSPASSA ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,520,152,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j CVTLSENDA
  nop ; Delay Slot
  CVTLSPASSA:
  PrintString $A010,520,152,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  CVTLSENDA:

  la t0,VALUEFLOATB ; T0 = Float Data Offset
  lwc1 f0,0(t0)     ; F0 = Float Data
  cvt.l.s f0 ; Convert To Long Data
  la t0,FDLONG  ; T0 = FDLONG Offset
  sdc1 f0,0(t0) ; FDLONG = Long Data
  PrintString $A010,136,160,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,144,160,FontBlack,VALUEFLOATB,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,160,FontBlack,TEXTFLOATB,8  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,368,160,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,376,160,FontBlack,FDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,FDLONG      ; T0 = Long Data Offset
  ld t1,0(t0)       ; T1 = Long Data
  la t0,CVTLSCHECKB ; T0 = Long Check Data Offset
  ld t2,0(t0)       ; T2 = Long Check Data
  beq t1,t2,CVTLSPASSB ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,520,160,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j CVTLSENDB
  nop ; Delay Slot
  CVTLSPASSB:
  PrintString $A010,520,160,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  CVTLSENDB:

  la t0,VALUEFLOATC ; T0 = Float Data Offset
  lwc1 f0,0(t0)     ; F0 = Float Data
  cvt.l.s f0 ; Convert To Long Data
  la t0,FDLONG  ; T0 = FDLONG Offset
  sdc1 f0,0(t0) ; FDLONG = Long Data
  PrintString $A010,136,168,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,144,168,FontBlack,VALUEFLOATC,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,280,168,FontBlack,TEXTFLOATC,9  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,368,168,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,376,168,FontBlack,FDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,FDLONG      ; T0 = Long Data Offset
  ld t1,0(t0)       ; T1 = Long Data
  la t0,CVTLSCHECKC ; T0 = Long Check Data Offset
  ld t2,0(t0)       ; T2 = Long Check Data
  beq t1,t2,CVTLSPASSC ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,520,168,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j CVTLSENDC
  nop ; Delay Slot
  CVTLSPASSC:
  PrintString $A010,520,168,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  CVTLSENDC:


  PrintString $A010,0,176,FontBlack,PAGEBREAK,79 ; Print Text String To VRAM Using Font At X,Y Position


  PrintString $A010,8,184,FontRed,CVTSD,6 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,VALUEDOUBLEA ; T0 = Double Data Offset
  ldc1 f0,0(t0)      ; F0 = Double Data
  cvt.s.d f0 ; Convert To Float Data
  la t0,FDWORD  ; T0 = FDWORD Offset
  swc1 f0,0(t0) ; FDWORD = Float Data
  PrintString $A010,72,184,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,80,184,FontBlack,VALUEDOUBLEA,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,336,184,FontBlack,TEXTDOUBLEA,2 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,432,184,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,440,184,FontBlack,FDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,FDWORD      ; T0 = Float Data Offset
  lw t1,0(t0)       ; T1 = Float Data
  la t0,CVTSDCHECKA ; T0 = Word Check Data Offset
  lw t2,0(t0)       ; T2 = Word Check Data
  beq t1,t2,CVTSDPASSA ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,520,184,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j CVTSDENDA
  nop ; Delay Slot
  CVTSDPASSA:
  PrintString $A010,520,184,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  CVTSDENDA:

  la t0,VALUEDOUBLEB ; T0 = Double Data Offset
  ldc1 f0,0(t0)      ; F0 = Double Data
  cvt.s.d f0 ; Convert To Float Data
  la t0,FDWORD  ; T0 = FDWORD Offset
  swc1 f0,0(t0) ; FDWORD = Float Data
  PrintString $A010,72,192,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,80,192,FontBlack,VALUEDOUBLEB,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,224,192,FontBlack,TEXTDOUBLEB,16 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,432,192,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,440,192,FontBlack,FDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,FDWORD      ; T0 = Float Data Offset
  lw t1,0(t0)       ; T1 = Float Data
  la t0,CVTSDCHECKB ; T0 = Word Check Data Offset
  lw t2,0(t0)       ; T2 = Word Check Data
  beq t1,t2,CVTSDPASSB ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,520,192,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j CVTSDENDB
  nop ; Delay Slot
  CVTSDPASSB:
  PrintString $A010,520,192,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  CVTSDENDB:

  la t0,VALUEDOUBLEC ; T0 = Double Data Offset
  ldc1 f0,0(t0)      ; F0 = Double Data
  cvt.s.d f0 ; Convert To Float Data
  la t0,FDWORD  ; T0 = FDWORD Offset
  swc1 f0,0(t0) ; FDWORD = Float Data
  PrintString $A010,72,200,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,80,200,FontBlack,VALUEDOUBLEC,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,216,200,FontBlack,TEXTDOUBLEC,17 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,432,200,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,440,200,FontBlack,FDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,FDWORD      ; T0 = Float Data Offset
  lw t1,0(t0)       ; T1 = Float Data
  la t0,CVTSDCHECKC ; T0 = Word Check Data Offset
  lw t2,0(t0)       ; T2 = Word Check Data
  beq t1,t2,CVTSDPASSC ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,520,200,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j CVTSDENDC
  nop ; Delay Slot
  CVTSDPASSC:
  PrintString $A010,520,200,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  CVTSDENDC:


  PrintString $A010,8,216,FontRed,CVTSL,6 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,VALUELONGA ; T0 = Long Data Offset
  ldc1 f0,0(t0)    ; F0 = Long Data
  cvt.s.l f0 ; Convert To Float Data
  la t0,FDWORD  ; T0 = FDWORD Offset
  swc1 f0,0(t0) ; FDWORD = Float Data
  PrintString $A010,72,216,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,80,216,FontBlack,VALUELONGA,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,216,FontBlack,TEXTLONGA,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,432,216,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,440,216,FontBlack,FDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,FDWORD      ; T0 = Float Data Offset
  lw t1,0(t0)       ; T1 = Float Data
  la t0,CVTSLCHECKA ; T0 = Word Check Data Offset
  lw t2,0(t0)       ; T2 = Word Check Data
  beq t1,t2,CVTSLPASSA ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,520,216,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j CVTSLENDA
  nop ; Delay Slot
  CVTSLPASSA:
  PrintString $A010,520,216,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  CVTSLENDA:

  la t0,VALUELONGB ; T0 = Long Data Offset
  ldc1 f0,0(t0)    ; F0 = Long Data
  cvt.s.l f0 ; Convert To Float Data
  la t0,FDWORD  ; T0 = FDWORD Offset
  swc1 f0,0(t0) ; FDWORD = Float Data
  PrintString $A010,72,224,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,80,224,FontBlack,VALUELONGB,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,296,224,FontBlack,TEXTLONGB,7 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,432,224,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,440,224,FontBlack,FDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,FDWORD      ; T0 = Float Data Offset
  lw t1,0(t0)       ; T1 = Float Data
  la t0,CVTSLCHECKB ; T0 = Word Check Data Offset
  lw t2,0(t0)       ; T2 = Word Check Data
  beq t1,t2,CVTSLPASSB ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,520,224,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j CVTSLENDB
  nop ; Delay Slot
  CVTSLPASSB:
  PrintString $A010,520,224,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  CVTSLENDB:

  la t0,VALUELONGC ; T0 = Long Data Offset
  ldc1 f0,0(t0)    ; F0 = Long Data
  cvt.s.l f0 ; Convert To Float Data
  la t0,FDWORD  ; T0 = FDWORD Offset
  swc1 f0,0(t0) ; FDWORD = Float Data
  PrintString $A010,72,232,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,80,232,FontBlack,VALUELONGC,7  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,232,FontBlack,TEXTLONGC,8 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,432,232,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,440,232,FontBlack,FDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,FDWORD      ; T0 = Float Data Offset
  lw t1,0(t0)       ; T1 = Float Data
  la t0,CVTSLCHECKC ; T0 = Word Check Data Offset
  lw t2,0(t0)       ; T2 = Word Check Data
  beq t1,t2,CVTSLPASSC ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,520,232,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j CVTSLENDC
  nop ; Delay Slot
  CVTSLPASSC:
  PrintString $A010,520,232,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  CVTSLENDC:


  PrintString $A010,8,248,FontRed,CVTSW,6 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,VALUEWORDA ; T0 = Word Data Offset
  lwc1 f0,0(t0)    ; F0 = Word Data
  cvt.s.w f0 ; Convert To Float Data
  la t0,FDWORD  ; T0 = FDWORD Offset
  swc1 f0,0(t0) ; FDWORD = Float Data
  PrintString $A010,136,248,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,144,248,FontBlack,VALUEWORDA,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,248,FontBlack,TEXTWORDA,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,432,248,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,440,248,FontBlack,FDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,FDWORD      ; T0 = Float Data Offset
  lw t1,0(t0)       ; T1 = Float Data
  la t0,CVTSWCHECKA ; T0 = Word Check Data Offset
  lw t2,0(t0)       ; T2 = Word Check Data
  beq t1,t2,CVTSWPASSA ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,520,248,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j CVTSWENDA
  nop ; Delay Slot
  CVTSWPASSA:
  PrintString $A010,520,248,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  CVTSWENDA:

  la t0,VALUEWORDB ; T0 = Word Data Offset
  lwc1 f0,0(t0)    ; F0 = Word Data
  cvt.s.w f0 ; Convert To Float Data
  la t0,FDWORD  ; T0 = FDWORD Offset
  swc1 f0,0(t0) ; FDWORD = Float Data
  PrintString $A010,136,256,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,144,256,FontBlack,VALUEWORDB,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,328,256,FontBlack,TEXTWORDB,3 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,432,256,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,440,256,FontBlack,FDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,FDWORD      ; T0 = Float Data Offset
  lw t1,0(t0)       ; T1 = Float Data
  la t0,CVTSWCHECKB ; T0 = Word Check Data Offset
  lw t2,0(t0)       ; T2 = Word Check Data
  beq t1,t2,CVTSWPASSB ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,520,256,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j CVTSWENDB
  nop ; Delay Slot
  CVTSWPASSB:
  PrintString $A010,520,256,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  CVTSWENDB:

  la t0,VALUEWORDC ; T0 = Word Data Offset
  lwc1 f0,0(t0)    ; F0 = Word Data
  cvt.s.w f0 ; Convert To Float Data
  la t0,FDWORD  ; T0 = FDWORD Offset
  swc1 f0,0(t0) ; FDWORD = Float Data
  PrintString $A010,136,264,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,144,264,FontBlack,VALUEWORDC,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,320,264,FontBlack,TEXTWORDC,4 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,432,264,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,440,264,FontBlack,FDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,FDWORD      ; T0 = Float Data Offset
  lw t1,0(t0)       ; T1 = Float Data
  la t0,CVTSWCHECKC ; T0 = Word Check Data Offset
  lw t2,0(t0)       ; T2 = Word Check Data
  beq t1,t2,CVTSWPASSC ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,520,264,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j CVTSWENDC
  nop ; Delay Slot
  CVTSWPASSC:
  PrintString $A010,520,264,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  CVTSWENDC:


  PrintString $A010,0,272,FontBlack,PAGEBREAK,79 ; Print Text String To VRAM Using Font At X,Y Position


  PrintString $A010,8,280,FontRed,CVTWD,6 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,VALUEDOUBLEA ; T0 = Double Data Offset
  ldc1 f0,0(t0)      ; F0 = Double Data
  cvt.w.d f0 ; Convert To Word Data
  la t0,FDWORD  ; T0 = FDWORD Offset
  swc1 f0,0(t0) ; FDWORD = Word Data
  PrintString $A010,72,280,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,80,280,FontBlack,VALUEDOUBLEA,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,336,280,FontBlack,TEXTDOUBLEA,2 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,432,280,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,440,280,FontBlack,FDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,FDWORD      ; T0 = Word Data Offset
  lw t1,0(t0)       ; T1 = Word Data
  la t0,CVTWDCHECKA ; T0 = Word Check Data Offset
  lw t2,0(t0)       ; T2 = Word Check Data
  beq t1,t2,CVTWDPASSA ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,520,280,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j CVTWDENDA
  nop ; Delay Slot
  CVTWDPASSA:
  PrintString $A010,520,280,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  CVTWDENDA:

  la t0,VALUEDOUBLEB ; T0 = Double Data Offset
  ldc1 f0,0(t0)      ; F0 = Double Data
  cvt.w.d f0 ; Convert To Word Data
  la t0,FDWORD  ; T0 = FDWORD Offset
  swc1 f0,0(t0) ; FDWORD = Word Data
  PrintString $A010,72,288,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,80,288,FontBlack,VALUEDOUBLEB,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,224,288,FontBlack,TEXTDOUBLEB,16 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,432,288,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,440,288,FontBlack,FDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,FDWORD      ; T0 = Word Data Offset
  lw t1,0(t0)       ; T1 = Word Data
  la t0,CVTWDCHECKB ; T0 = Word Check Data Offset
  lw t2,0(t0)       ; T2 = Word Check Data
  beq t1,t2,CVTWDPASSB ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,520,288,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j CVTWDENDB
  nop ; Delay Slot
  CVTWDPASSB:
  PrintString $A010,520,288,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  CVTWDENDB:

  la t0,VALUEDOUBLEC ; T0 = Double Data Offset
  ldc1 f0,0(t0)      ; F0 = Double Data
  cvt.w.d f0 ; Convert To Word Data
  la t0,FDWORD  ; T0 = FDWORD Offset
  swc1 f0,0(t0) ; FDWORD = Word Data
  PrintString $A010,72,296,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,80,296,FontBlack,VALUEDOUBLEC,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,216,296,FontBlack,TEXTDOUBLEC,17 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,432,296,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,440,296,FontBlack,FDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,FDWORD      ; T0 = Word Data Offset
  lw t1,0(t0)       ; T1 = Word Data
  la t0,CVTWDCHECKC ; T0 = Word Check Data Offset
  lw t2,0(t0)       ; T2 = Word Check Data
  beq t1,t2,CVTWDPASSC ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,520,296,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j CVTWDENDC
  nop ; Delay Slot
  CVTWDPASSC:
  PrintString $A010,520,296,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  CVTWDENDC:


  PrintString $A010,8,312,FontRed,CVTWS,6 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,VALUEFLOATA ; T0 = Float Data Offset
  lwc1 f0,0(t0)     ; F0 = Float Data
  cvt.w.s f0 ; Convert To Word Data
  la t0,FDWORD  ; T0 = FDWORD Offset
  swc1 f0,0(t0) ; FDWORD = Word Data
  PrintString $A010,136,312,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,144,312,FontBlack,VALUEFLOATA,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,336,312,FontBlack,TEXTFLOATA,2  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,432,312,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,440,312,FontBlack,FDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,FDWORD      ; T0 = Word Data Offset
  lw t1,0(t0)       ; T1 = Word Data
  la t0,CVTWSCHECKA ; T0 = Word Check Data Offset
  lw t2,0(t0)       ; T2 = Word Check Data
  beq t1,t2,CVTWSPASSA ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,520,312,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j CVTWSENDA
  nop ; Delay Slot
  CVTWSPASSA:
  PrintString $A010,520,312,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  CVTWSENDA:

  la t0,VALUEFLOATB ; T0 = Float Data Offset
  lwc1 f0,0(t0)     ; F0 = Float Data
  cvt.w.s f0 ; Convert To Word Data
  la t0,FDWORD  ; T0 = FDWORD Offset
  swc1 f0,0(t0) ; FDWORD = Word Data
  PrintString $A010,136,320,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,144,320,FontBlack,VALUEFLOATB,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,320,FontBlack,TEXTFLOATB,8  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,432,320,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,440,320,FontBlack,FDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,FDWORD      ; T0 = Word Data Offset
  lw t1,0(t0)       ; T1 = Word Data
  la t0,CVTWSCHECKB ; T0 = Word Check Data Offset
  lw t2,0(t0)       ; T2 = Word Check Data
  beq t1,t2,CVTWSPASSB ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,520,320,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j CVTWSENDB
  nop ; Delay Slot
  CVTWSPASSB:
  PrintString $A010,520,320,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  CVTWSENDB:

  la t0,VALUEFLOATC ; T0 = Float Data Offset
  lwc1 f0,0(t0)     ; F0 = Float Data
  cvt.w.s f0 ; Convert To Word Data
  la t0,FDWORD  ; T0 = FDWORD Offset
  swc1 f0,0(t0) ; FDWORD = Word Data
  PrintString $A010,136,328,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,144,328,FontBlack,VALUEFLOATC,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,280,328,FontBlack,TEXTFLOATC,9  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,432,328,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,440,328,FontBlack,FDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,FDWORD      ; T0 = Word Data Offset
  lw t1,0(t0)       ; T1 = Word Data
  la t0,CVTWSCHECKC ; T0 = Word Check Data Offset
  lw t2,0(t0)       ; T2 = Word Check Data
  beq t1,t2,CVTWSPASSC ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,520,328,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j CVTWSENDC
  nop ; Delay Slot
  CVTWSPASSC:
  PrintString $A010,520,328,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  CVTWSENDC:


  PrintString $A010,0,336,FontBlack,PAGEBREAK,79 ; Print Text String To VRAM Using Font At X,Y Position

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

CVTDL: db "CVT.D.L"
CVTDS: db "CVT.D.S"
CVTDW: db "CVT.D.W"

CVTLD: db "CVT.L.D"
CVTLS: db "CVT.L.S"

CVTSD: db "CVT.S.D"
CVTSL: db "CVT.S.L"
CVTSW: db "CVT.S.W"

CVTWD: db "CVT.W.D"
CVTWS: db "CVT.W.S"

FDHEX: db "FD (Hex)"
FSHEX: db "FS (Hex)"
FDFSDEC: db "FS/FD (Decimal)"
TEST: db "Test Result"
FAIL: db "FAIL"
PASS: db "PASS"

DOLLAR: db "$"

TEXTDOUBLEA: db "0.0"
TEXTDOUBLEB: db "12345678.12345678"
TEXTDOUBLEC: db "-12345678.12345678"

TEXTLONGA: db "0"
TEXTLONGB: db "12345678"
TEXTLONGC: db "-12345678"

TEXTFLOATA: db "0.0"
TEXTFLOATB: db "1234.1234"
TEXTFLOATC: db "-1234.1234"

TEXTWORDA: db "0"
TEXTWORDB: db "1234"
TEXTWORDC: db "-1234"

PAGEBREAK: db "--------------------------------------------------------------------------------"

  align 8 ; Align 64-bit
VALUEDOUBLEA: IEEE64 0.0
VALUEDOUBLEB: IEEE64 12345678.12345678
VALUEDOUBLEC: IEEE64 -12345678.12345678

VALUELONGA: data 0
VALUELONGB: data 12345678
VALUELONGC: data -12345678

CVTDLCHECKA: data $0000000000000000
CVTDLCHECKB: data $41678C29C0000000
CVTDLCHECKC: data $C1678C29C0000000

CVTDSCHECKA: data $0000000000000000
CVTDSCHECKB: data $4093487E60000000
CVTDSCHECKC: data $C093487E60000000

CVTDWCHECKA: data $0000000000000000
CVTDWCHECKB: data $4093480000000000
CVTDWCHECKC: data $C093480000000000

CVTLDCHECKA: data $0000000000000000
CVTLDCHECKB: data $0000000000BC614E
CVTLDCHECKC: data $FFFFFFFFFF439EB2

CVTLSCHECKA: data $0000000000000000
CVTLSCHECKB: data $00000000000004D2
CVTLSCHECKC: data $FFFFFFFFFFFFFB2E

FDLONG: data 0

VALUEFLOATA: IEEE32 0.0
VALUEFLOATB: IEEE32 1234.1234
VALUEFLOATC: IEEE32 -1234.1234

VALUEWORDA: dw 0
VALUEWORDB: dw 1234
VALUEWORDC: dw -1234

CVTSDCHECKA: dw $00000000
CVTSDCHECKB: dw $4B3C614E
CVTSDCHECKC: dw $CB3C614E

CVTSLCHECKA: dw $00000000
CVTSLCHECKB: dw $4B3C614E
CVTSLCHECKC: dw $CB3C614E

CVTSWCHECKA: dw $00000000
CVTSWCHECKB: dw $449A4000
CVTSWCHECKC: dw $C49A4000

CVTWDCHECKA: dw $00000000
CVTWDCHECKB: dw $00BC614E
CVTWDCHECKC: dw $FF439EB2

CVTWSCHECKA: dw $00000000
CVTWSCHECKB: dw $000004D2
CVTWSCHECKC: dw $FFFFFB2E

FDWORD: dw 0

FontBlack: incbin FontBlack8x8.bin
FontGreen: incbin FontGreen8x8.bin
FontRed: incbin FontRed8x8.bin