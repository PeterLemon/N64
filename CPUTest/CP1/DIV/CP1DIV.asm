; N64 'Bare Metal' CPU CP1/FPU Division Test Demo by krom (Peter Lemon):
  include LIB\N64.INC ; Include N64 Definitions
  dcb 1048576,$00 ; Set ROM Size
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


  PrintString $A010,88,8,FontRed,FSFTHEX,10 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,232,8,FontRed,FSFTDEC,14 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,384,8,FontRed,FDHEX,7 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,528,8,FontRed,TEST,10 ; Print Text String To VRAM Using Font At X,Y Position


  PrintString $A010,0,16,FontBlack,PAGEBREAK,79 ; Print Text String To VRAM Using Font At X,Y Position


  PrintString $A010,8,24,FontRed,DIVD,4 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,VALUEDOUBLEA ; A0 = Double Data Offset
  ldc1 f0,0(a0)      ; F0 = Double Data
  la a0,VALUEDOUBLEB ; A0 = Double Data Offset
  ldc1 f1,0(a0)      ; F1 = Double Data
  div.d f0,f1 ; Convert To Long Data
  la a0,FDLONG  ; A0 = FDLONG Offset
  sdc1 f0,0(a0) ; FDLONG = Long Data
  PrintString $A010,80,24,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,24,FontBlack,VALUEDOUBLEA,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,344,24,FontBlack,TEXTDOUBLEA,2 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,80,32,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,32,FontBlack,VALUEDOUBLEB,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,232,32,FontBlack,TEXTDOUBLEB,16 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,32,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,32,FontBlack,FDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,FDLONG     ; A0 = Long Data Offset
  ld t0,0(a0)      ; T0 = Long Data
  la a0,DIVDCHECKA ; A0 = Long Check Data Offset
  ld t1,0(a0)      ; T1 = Long Check Data
  beq t0,t1,DIVDPASSA ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,32,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DIVDENDA
  nop ; Delay Slot
  DIVDPASSA:
  PrintString $A010,528,32,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DIVDENDA:

  la a0,VALUEDOUBLEB ; A0 = Double Data Offset
  ldc1 f0,0(a0)      ; F0 = Double Data
  la a0,VALUEDOUBLEC ; A0 = Double Data Offset
  ldc1 f1,0(a0)      ; F1 = Double Data
  div.d f0,f1 ; Convert To Long Data
  la a0,FDLONG  ; A0 = FDLONG Offset
  sdc1 f0,0(a0) ; FDLONG = Long Data
  PrintString $A010,80,48,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,48,FontBlack,VALUEDOUBLEB,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,232,48,FontBlack,TEXTDOUBLEB,16 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,80,56,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,56,FontBlack,VALUEDOUBLEC,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,56,FontBlack,TEXTDOUBLEC,9 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,56,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,56,FontBlack,FDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,FDLONG     ; A0 = Long Data Offset
  ld t0,0(a0)      ; T0 = Long Data
  la a0,DIVDCHECKB ; A0 = Long Check Data Offset
  ld t1,0(a0)      ; T1 = Long Check Data
  beq t0,t1,DIVDPASSB ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,56,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DIVDENDB
  nop ; Delay Slot
  DIVDPASSB:
  PrintString $A010,528,56,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DIVDENDB:

  la a0,VALUEDOUBLEC ; A0 = Double Data Offset
  ldc1 f0,0(a0)      ; F0 = Double Data
  la a0,VALUEDOUBLED ; A0 = Double Data Offset
  ldc1 f1,0(a0)      ; F1 = Double Data
  div.d f0,f1 ; Convert To Long Data
  la a0,FDLONG  ; A0 = FDLONG Offset
  sdc1 f0,0(a0) ; FDLONG = Long Data
  PrintString $A010,80,72,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,72,FontBlack,VALUEDOUBLEC,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,72,FontBlack,TEXTDOUBLEC,9 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,80,80,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,80,FontBlack,VALUEDOUBLED,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,232,80,FontBlack,TEXTDOUBLED,16 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,80,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,80,FontBlack,FDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,FDLONG     ; A0 = Long Data Offset
  ld t0,0(a0)      ; T0 = Long Data
  la a0,DIVDCHECKC ; A0 = Long Check Data Offset
  ld t1,0(a0)      ; T1 = Long Check Data
  beq t0,t1,DIVDPASSC ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,80,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DIVDENDC
  nop ; Delay Slot
  DIVDPASSC:
  PrintString $A010,528,80,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DIVDENDC:

  la a0,VALUEDOUBLED ; A0 = Double Data Offset
  ldc1 f0,0(a0)      ; F0 = Double Data
  la a0,VALUEDOUBLEE ; A0 = Double Data Offset
  ldc1 f1,0(a0)      ; F1 = Double Data
  div.d f0,f1 ; Convert To Long Data
  la a0,FDLONG  ; A0 = FDLONG Offset
  sdc1 f0,0(a0) ; FDLONG = Long Data
  PrintString $A010,80,96,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,96,FontBlack,VALUEDOUBLED,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,232,96,FontBlack,TEXTDOUBLED,16 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,80,104,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,104,FontBlack,VALUEDOUBLEE,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,224,104,FontBlack,TEXTDOUBLEE,17 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,104,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,104,FontBlack,FDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,FDLONG     ; A0 = Long Data Offset
  ld t0,0(a0)      ; T0 = Long Data
  la a0,DIVDCHECKD ; A0 = Long Check Data Offset
  ld t1,0(a0)      ; T1 = Long Check Data
  beq t0,t1,DIVDPASSD ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,104,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DIVDENDD
  nop ; Delay Slot
  DIVDPASSD:
  PrintString $A010,528,104,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DIVDENDD:

  la a0,VALUEDOUBLEE ; A0 = Double Data Offset
  ldc1 f0,0(a0)      ; F0 = Double Data
  la a0,VALUEDOUBLEF ; A0 = Double Data Offset
  ldc1 f1,0(a0)      ; F1 = Double Data
  div.d f0,f1 ; Convert To Long Data
  la a0,FDLONG  ; A0 = FDLONG Offset
  sdc1 f0,0(a0) ; FDLONG = Long Data
  PrintString $A010,80,120,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,120,FontBlack,VALUEDOUBLEE,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,224,120,FontBlack,TEXTDOUBLEE,17 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,80,128,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,128,FontBlack,VALUEDOUBLEF,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,280,128,FontBlack,TEXTDOUBLEF,10 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,128,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,128,FontBlack,FDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,FDLONG     ; A0 = Long Data Offset
  ld t0,0(a0)      ; T0 = Long Data
  la a0,DIVDCHECKE ; A0 = Long Check Data Offset
  ld t1,0(a0)      ; T1 = Long Check Data
  beq t0,t1,DIVDPASSE ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,128,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DIVDENDE
  nop ; Delay Slot
  DIVDPASSE:
  PrintString $A010,528,128,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DIVDENDE:

  la a0,VALUEDOUBLEF ; A0 = Double Data Offset
  ldc1 f0,0(a0)      ; F0 = Double Data
  la a0,VALUEDOUBLEG ; A0 = Double Data Offset
  ldc1 f1,0(a0)      ; F1 = Double Data
  div.d f0,f1 ; Convert To Long Data
  la a0,FDLONG  ; A0 = FDLONG Offset
  sdc1 f0,0(a0) ; FDLONG = Long Data
  PrintString $A010,80,144,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,144,FontBlack,VALUEDOUBLEF,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,280,144,FontBlack,TEXTDOUBLEF,10 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,80,152,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,152,FontBlack,VALUEDOUBLEG,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,224,152,FontBlack,TEXTDOUBLEG,17 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,152,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,152,FontBlack,FDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,FDLONG     ; A0 = Long Data Offset
  ld t0,0(a0)      ; T0 = Long Data
  la a0,DIVDCHECKF ; A0 = Long Check Data Offset
  ld t1,0(a0)      ; T1 = Long Check Data
  beq t0,t1,DIVDPASSF ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,152,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DIVDENDF
  nop ; Delay Slot
  DIVDPASSF:
  PrintString $A010,528,152,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DIVDENDF:

  la a0,VALUEDOUBLEA ; A0 = Double Data Offset
  ldc1 f0,0(a0)      ; F0 = Double Data
  la a0,VALUEDOUBLEG ; A0 = Double Data Offset
  ldc1 f1,0(a0)      ; F1 = Double Data
  div.d f0,f1 ; Convert To Long Data
  la a0,FDLONG  ; A0 = FDLONG Offset
  sdc1 f0,0(a0) ; FDLONG = Long Data
  PrintString $A010,80,168,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,168,FontBlack,VALUEDOUBLEA,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,344,168,FontBlack,TEXTDOUBLEA,2 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,80,176,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,176,FontBlack,VALUEDOUBLEG,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,224,176,FontBlack,TEXTDOUBLEG,17 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,176,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,176,FontBlack,FDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,FDLONG     ; A0 = Long Data Offset
  ld t0,0(a0)      ; T0 = Long Data
  la a0,DIVDCHECKG ; A0 = Long Check Data Offset
  ld t1,0(a0)      ; T1 = Long Check Data
  beq t0,t1,DIVDPASSG ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,176,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DIVDENDG
  nop ; Delay Slot
  DIVDPASSG:
  PrintString $A010,528,176,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DIVDENDG:


  PrintString $A010,8,192,FontRed,DIVS,4 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,VALUEFLOATA ; A0 = Float Data Offset
  lwc1 f0,0(a0)     ; F0 = Float Data
  la a0,VALUEFLOATB ; A0 = Float Data Offset
  lwc1 f1,0(a0)     ; F1 = Float Data
  div.s f0,f1 ; Convert To Word Data
  la a0,FDWORD  ; A0 = FDWORD Offset
  swc1 f0,0(a0) ; FDWORD = Word Data
  PrintString $A010,144,192,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,192,FontBlack,VALUEFLOATA,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,344,192,FontBlack,TEXTFLOATA,2  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,144,200,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,200,FontBlack,VALUEFLOATB,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,296,200,FontBlack,TEXTFLOATB,8  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,200,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,200,FontBlack,FDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,FDWORD     ; A0 = Word Data Offset
  lw t0,0(a0)      ; T0 = Word Data
  la a0,DIVSCHECKA ; A0 = Word Check Data Offset
  lw t1,0(a0)      ; T1 = Word Check Data
  beq t0,t1,DIVSPASSA ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,200,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DIVSENDA
  nop ; Delay Slot
  DIVSPASSA:
  PrintString $A010,528,200,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DIVSENDA:

  la a0,VALUEFLOATB ; A0 = Float Data Offset
  lwc1 f0,0(a0)     ; F0 = Float Data
  la a0,VALUEFLOATC ; A0 = Float Data Offset
  lwc1 f1,0(a0)     ; F1 = Float Data
  div.s f0,f1 ; Convert To Word Data
  la a0,FDWORD  ; A0 = FDWORD Offset
  swc1 f0,0(a0) ; FDWORD = Word Data
  PrintString $A010,144,216,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,216,FontBlack,VALUEFLOATB,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,296,216,FontBlack,TEXTFLOATB,8  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,144,224,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,224,FontBlack,VALUEFLOATC,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,320,224,FontBlack,TEXTFLOATC,5  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,224,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,224,FontBlack,FDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,FDWORD     ; A0 = Word Data Offset
  lw t0,0(a0)      ; T0 = Word Data
  la a0,DIVSCHECKB ; A0 = Word Check Data Offset
  lw t1,0(a0)      ; T1 = Word Check Data
  beq t0,t1,DIVSPASSB ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,224,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DIVSENDB
  nop ; Delay Slot
  DIVSPASSB:
  PrintString $A010,528,224,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DIVSENDB:

  la a0,VALUEFLOATC ; A0 = Float Data Offset
  lwc1 f0,0(a0)     ; F0 = Float Data
  la a0,VALUEFLOATD ; A0 = Float Data Offset
  lwc1 f1,0(a0)     ; F1 = Float Data
  div.s f0,f1 ; Convert To Word Data
  la a0,FDWORD  ; A0 = FDWORD Offset
  swc1 f0,0(a0) ; FDWORD = Word Data
  PrintString $A010,144,240,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,240,FontBlack,VALUEFLOATC,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,320,240,FontBlack,TEXTFLOATC,5  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,144,248,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,248,FontBlack,VALUEFLOATD,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,296,248,FontBlack,TEXTFLOATD,8  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,248,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,248,FontBlack,FDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,FDWORD     ; A0 = Word Data Offset
  lw t0,0(a0)      ; T0 = Word Data
  la a0,DIVSCHECKC ; A0 = Word Check Data Offset
  lw t1,0(a0)      ; T1 = Word Check Data
  beq t0,t1,DIVSPASSC ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,248,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DIVSENDC
  nop ; Delay Slot
  DIVSPASSC:
  PrintString $A010,528,248,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DIVSENDC:

  la a0,VALUEFLOATD ; A0 = Float Data Offset
  lwc1 f0,0(a0)     ; F0 = Float Data
  la a0,VALUEFLOATE ; A0 = Float Data Offset
  lwc1 f1,0(a0)     ; F1 = Float Data
  div.s f0,f1 ; Convert To Word Data
  la a0,FDWORD  ; A0 = FDWORD Offset
  swc1 f0,0(a0) ; FDWORD = Word Data
  PrintString $A010,144,264,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,264,FontBlack,VALUEFLOATD,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,296,264,FontBlack,TEXTFLOATD,8  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,144,272,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,272,FontBlack,VALUEFLOATE,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,272,FontBlack,TEXTFLOATE,9  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,272,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,272,FontBlack,FDWord,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,FDWORD     ; A0 = Word Data Offset
  lw t0,0(a0)      ; T0 = Word Data
  la a0,DIVSCHECKD ; A0 = Word Check Data Offset
  lw t1,0(a0)      ; T1 = Word Check Data
  beq t0,t1,DIVSPASSD ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,272,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DIVSENDD
  nop ; Delay Slot
  DIVSPASSD:
  PrintString $A010,528,272,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DIVSENDD:

  la a0,VALUEFLOATE ; A0 = Float Data Offset
  lwc1 f0,0(a0)     ; F0 = Float Data
  la a0,VALUEFLOATF ; A0 = Float Data Offset
  lwc1 f1,0(a0)     ; F1 = Float Data
  div.s f0,f1 ; Convert To Word Data
  la a0,FDWORD  ; A0 = FDWORD Offset
  swc1 f0,0(a0) ; FDWORD = Word Data
  PrintString $A010,144,288,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,288,FontBlack,VALUEFLOATE,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,288,FontBlack,TEXTFLOATE,9  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,144,296,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,296,FontBlack,VALUEFLOATF,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,312,296,FontBlack,TEXTFLOATF,6  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,296,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,296,FontBlack,FDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,FDWord     ; A0 = Word Data Offset
  lw t0,0(a0)      ; T0 = Word Data
  la a0,DIVSCHECKE ; A0 = Word Check Data Offset
  lw t1,0(a0)      ; T1 = Word Check Data
  beq t0,t1,DIVSPASSE ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,296,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DIVSENDE
  nop ; Delay Slot
  DIVSPASSE:
  PrintString $A010,528,296,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DIVSENDE:

  la a0,VALUEFLOATF ; A0 = Float Data Offset
  lwc1 f0,0(a0)     ; F0 = Float Data
  la a0,VALUEFLOATG ; A0 = Float Data Offset
  lwc1 f1,0(a0)     ; F1 = Float Data
  div.s f0,f1 ; Convert To Word Data
  la a0,FDWORD  ; A0 = FDWORD Offset
  swc1 f0,0(a0) ; FDWORD = Word Data
  PrintString $A010,144,312,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,312,FontBlack,VALUEFLOATF,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,312,312,FontBlack,TEXTFLOATF,6  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,144,320,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,320,FontBlack,VALUEFLOATG,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,320,FontBlack,TEXTFLOATG,9  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,320,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,320,FontBlack,FDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,FDWORD     ; A0 = Word Data Offset
  lw t0,0(a0)      ; T0 = Word Data
  la a0,DIVSCHECKF ; A0 = Word Check Data Offset
  lw t1,0(a0)      ; T1 = Word Check Data
  beq t0,t1,DIVSPASSF ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,320,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DIVSENDF
  nop ; Delay Slot
  DIVSPASSF:
  PrintString $A010,528,320,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DIVSENDF:

  la a0,VALUEFLOATA ; A0 = Float Data Offset
  lwc1 f0,0(a0)     ; F0 = Float Data
  la a0,VALUEFLOATG ; A0 = Float Data Offset
  lwc1 f1,0(a0)     ; F1 = Float Data
  div.s f0,f1 ; Convert To Word Data
  la a0,FDWORD  ; A0 = FDWORD Offset
  swc1 f0,0(a0) ; FDWORD = Word Data
  PrintString $A010,144,336,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,336,FontBlack,VALUEFLOATA,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,344,336,FontBlack,TEXTFLOATA,2  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,144,344,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,344,FontBlack,VALUEFLOATG,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,344,FontBlack,TEXTFLOATG,9  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,344,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,344,FontBlack,FDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,FDWORD     ; A0 = Word Data Offset
  lw t0,0(a0)      ; T0 = Word Data
  la a0,DIVSCHECKG ; A0 = Word Check Data Offset
  lw t1,0(a0)      ; T1 = Word Check Data
  beq t0,t1,DIVSPASSG ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,344,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j DIVSENDG
  nop ; Delay Slot
  DIVSPASSG:
  PrintString $A010,528,344,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  DIVSENDG:


  PrintString $A010,0,352,FontBlack,PAGEBREAK,79 ; Print Text String To VRAM Using Font At X,Y Position


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

DIVD: db "DIV.D"
DIVS: db "DIV.S"

FDHEX: db "FD (Hex)"
FSFTHEX: db "FS/FT (Hex)"
FSFTDEC: db "FS/FT (Decimal)"
TEST: db "Test Result"
FAIL: db "FAIL"
PASS: db "PASS"

DOLLAR: db "$"

TEXTDOUBLEA: db "0.0"
TEXTDOUBLEB: db "12345678.67891234"
TEXTDOUBLEC: db "12345678.5"
TEXTDOUBLED: db "12345678.12345678"
TEXTDOUBLEE: db "-12345678.12345678"
TEXTDOUBLEF: db "-12345678.5"
TEXTDOUBLEG: db "-12345678.67891234"

TEXTFLOATA: db "0.0"
TEXTFLOATB: db "1234.6789"
TEXTFLOATC: db "1234.5"
TEXTFLOATD: db "1234.1234"
TEXTFLOATE: db "-1234.1234"
TEXTFLOATF: db "-1234.5"
TEXTFLOATG: db "-1234.6789"

PAGEBREAK: db "--------------------------------------------------------------------------------"

  align 8 ; Align 64-Bit
VALUEDOUBLEA: IEEE64 0.0
VALUEDOUBLEB: IEEE64 12345678.67891234
VALUEDOUBLEC: IEEE64 12345678.5
VALUEDOUBLED: IEEE64 12345678.12345678
VALUEDOUBLEE: IEEE64 -12345678.12345678
VALUEDOUBLEF: IEEE64 -12345678.5
VALUEDOUBLEG: IEEE64 -12345678.67891234

DIVDCHECKA: data $0000000000000000
DIVDCHECKB: data $3FF0000003E3E034
DIVDCHECKC: data $3FF00000082FF1BA
DIVDCHECKD: data $BFF0000000000000
DIVDCHECKE: data $3FEFFFFFEFA01C94
DIVDCHECKF: data $3FEFFFFFF8383F9A
DIVDCHECKG: data $8000000000000000

FDLONG: data 0

VALUEFLOATA: IEEE32 0.0
VALUEFLOATB: IEEE32 1234.6789
VALUEFLOATC: IEEE32 1234.5
VALUEFLOATD: IEEE32 1234.1234
VALUEFLOATE: IEEE32 -1234.1234
VALUEFLOATF: IEEE32 -1234.5
VALUEFLOATG: IEEE32 -1234.6789

DIVSCHECKA: dw $00000000
DIVSCHECKB: dw $3F8004C0
DIVSCHECKC: dw $3F800A00
DIVSCHECKD: dw $BF800000
DIVSCHECKE: dw $3F7FEC02
DIVSCHECKF: dw $3F7FF680
DIVSCHECKG: dw $80000000

FDWORD: dw 0

FontBlack: incbin FontBlack8x8.bin
FontGreen: incbin FontGreen8x8.bin
FontRed: incbin FontRed8x8.bin