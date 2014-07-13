; N64 'Bare Metal' CPU CP1/FPU Multiplication Test Demo by krom (Peter Lemon):

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




  PrintString $A010,88,8,FontRed,FSFTHEX,10 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,232,8,FontRed,FSFTDEC,14 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,384,8,FontRed,FDHEX,7 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,528,8,FontRed,TEST,10 ; Print Text String To VRAM Using Font At X,Y Position


  PrintString $A010,0,16,FontBlack,PAGEBREAK,79 ; Print Text String To VRAM Using Font At X,Y Position


  PrintString $A010,8,24,FontRed,MULD,4 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,VALUEDOUBLEA ; T0 = Double Data Offset
  ldc1 f0,0(t0)      ; F0 = Double Data
  la t0,VALUEDOUBLEB ; T0 = Double Data Offset
  ldc1 f1,0(t0)      ; F1 = Double Data
  mul.d f0,f1 ; Convert To Long Data
  la t0,FDLONG  ; T0 = FDLONG Offset
  sdc1 f0,0(t0) ; FDLONG = Long Data
  PrintString $A010,80,24,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,24,FontBlack,VALUEDOUBLEA,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,344,24,FontBlack,TEXTDOUBLEA,2 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,80,32,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,32,FontBlack,VALUEDOUBLEB,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,232,32,FontBlack,TEXTDOUBLEB,16 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,32,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,32,FontBlack,FDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,FDLONG     ; T0 = Long Data Offset
  ld t1,0(t0)      ; T1 = Long Data
  la t0,MULDCHECKA ; T0 = Long Check Data Offset
  ld t2,0(t0)      ; T2 = Long Check Data
  beq t1,t2,MULDPASSA ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,32,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j MULDENDA
  nop ; Delay Slot
  MULDPASSA:
  PrintString $A010,528,32,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  MULDENDA:

  la t0,VALUEDOUBLEB ; T0 = Double Data Offset
  ldc1 f0,0(t0)      ; F0 = Double Data
  la t0,VALUEDOUBLEC ; T0 = Double Data Offset
  ldc1 f1,0(t0)      ; F1 = Double Data
  mul.d f0,f1 ; Convert To Long Data
  la t0,FDLONG  ; T0 = FDLONG Offset
  sdc1 f0,0(t0) ; FDLONG = Long Data
  PrintString $A010,80,48,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,48,FontBlack,VALUEDOUBLEB,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,232,48,FontBlack,TEXTDOUBLEB,16 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,80,56,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,56,FontBlack,VALUEDOUBLEC,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,56,FontBlack,TEXTDOUBLEC,9 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,56,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,56,FontBlack,FDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,FDLONG     ; T0 = Long Data Offset
  ld t1,0(t0)      ; T1 = Long Data
  la t0,MULDCHECKB ; T0 = Long Check Data Offset
  ld t2,0(t0)      ; T2 = Long Check Data
  beq t1,t2,MULDPASSB ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,56,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j MULDENDB
  nop ; Delay Slot
  MULDPASSB:
  PrintString $A010,528,56,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  MULDENDB:

  la t0,VALUEDOUBLEC ; T0 = Double Data Offset
  ldc1 f0,0(t0)      ; F0 = Double Data
  la t0,VALUEDOUBLED ; T0 = Double Data Offset
  ldc1 f1,0(t0)      ; F1 = Double Data
  mul.d f0,f1 ; Convert To Long Data
  la t0,FDLONG  ; T0 = FDLONG Offset
  sdc1 f0,0(t0) ; FDLONG = Long Data
  PrintString $A010,80,72,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,72,FontBlack,VALUEDOUBLEC,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,72,FontBlack,TEXTDOUBLEC,9 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,80,80,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,80,FontBlack,VALUEDOUBLED,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,232,80,FontBlack,TEXTDOUBLED,16 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,80,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,80,FontBlack,FDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,FDLONG     ; T0 = Long Data Offset
  ld t1,0(t0)      ; T1 = Long Data
  la t0,MULDCHECKC ; T0 = Long Check Data Offset
  ld t2,0(t0)      ; T2 = Long Check Data
  beq t1,t2,MULDPASSC ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,80,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j MULDENDC
  nop ; Delay Slot
  MULDPASSC:
  PrintString $A010,528,80,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  MULDENDC:

  la t0,VALUEDOUBLED ; T0 = Double Data Offset
  ldc1 f0,0(t0)      ; F0 = Double Data
  la t0,VALUEDOUBLEE ; T0 = Double Data Offset
  ldc1 f1,0(t0)      ; F1 = Double Data
  mul.d f0,f1 ; Convert To Long Data
  la t0,FDLONG  ; T0 = FDLONG Offset
  sdc1 f0,0(t0) ; FDLONG = Long Data
  PrintString $A010,80,96,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,96,FontBlack,VALUEDOUBLED,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,232,96,FontBlack,TEXTDOUBLED,16 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,80,104,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,104,FontBlack,VALUEDOUBLEE,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,224,104,FontBlack,TEXTDOUBLEE,17 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,104,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,104,FontBlack,FDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,FDLONG     ; T0 = Long Data Offset
  ld t1,0(t0)      ; T1 = Long Data
  la t0,MULDCHECKD ; T0 = Long Check Data Offset
  ld t2,0(t0)      ; T2 = Long Check Data
  beq t1,t2,MULDPASSD ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,104,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j MULDENDD
  nop ; Delay Slot
  MULDPASSD:
  PrintString $A010,528,104,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  MULDENDD:

  la t0,VALUEDOUBLEE ; T0 = Double Data Offset
  ldc1 f0,0(t0)      ; F0 = Double Data
  la t0,VALUEDOUBLEF ; T0 = Double Data Offset
  ldc1 f1,0(t0)      ; F1 = Double Data
  mul.d f0,f1 ; Convert To Long Data
  la t0,FDLONG  ; T0 = FDLONG Offset
  sdc1 f0,0(t0) ; FDLONG = Long Data
  PrintString $A010,80,120,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,120,FontBlack,VALUEDOUBLEE,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,224,120,FontBlack,TEXTDOUBLEE,17 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,80,128,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,128,FontBlack,VALUEDOUBLEF,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,280,128,FontBlack,TEXTDOUBLEF,10 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,128,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,128,FontBlack,FDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,FDLONG     ; T0 = Long Data Offset
  ld t1,0(t0)      ; T1 = Long Data
  la t0,MULDCHECKE ; T0 = Long Check Data Offset
  ld t2,0(t0)      ; T2 = Long Check Data
  beq t1,t2,MULDPASSE ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,128,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j MULDENDE
  nop ; Delay Slot
  MULDPASSE:
  PrintString $A010,528,128,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  MULDENDE:

  la t0,VALUEDOUBLEF ; T0 = Double Data Offset
  ldc1 f0,0(t0)      ; F0 = Double Data
  la t0,VALUEDOUBLEG ; T0 = Double Data Offset
  ldc1 f1,0(t0)      ; F1 = Double Data
  mul.d f0,f1 ; Convert To Long Data
  la t0,FDLONG  ; T0 = FDLONG Offset
  sdc1 f0,0(t0) ; FDLONG = Long Data
  PrintString $A010,80,144,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,144,FontBlack,VALUEDOUBLEF,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,280,144,FontBlack,TEXTDOUBLEF,10 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,80,152,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,152,FontBlack,VALUEDOUBLEG,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,224,152,FontBlack,TEXTDOUBLEG,17 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,152,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,152,FontBlack,FDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,FDLONG     ; T0 = Long Data Offset
  ld t1,0(t0)      ; T1 = Long Data
  la t0,MULDCHECKF ; T0 = Long Check Data Offset
  ld t2,0(t0)      ; T2 = Long Check Data
  beq t1,t2,MULDPASSF ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,152,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j MULDENDF
  nop ; Delay Slot
  MULDPASSF:
  PrintString $A010,528,152,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  MULDENDF:

  la t0,VALUEDOUBLEA ; T0 = Double Data Offset
  ldc1 f0,0(t0)      ; F0 = Double Data
  la t0,VALUEDOUBLEG ; T0 = Double Data Offset
  ldc1 f1,0(t0)      ; F1 = Double Data
  mul.d f0,f1 ; Convert To Long Data
  la t0,FDLONG  ; T0 = FDLONG Offset
  sdc1 f0,0(t0) ; FDLONG = Long Data
  PrintString $A010,80,168,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,168,FontBlack,VALUEDOUBLEA,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,344,168,FontBlack,TEXTDOUBLEA,2 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,80,176,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,176,FontBlack,VALUEDOUBLEG,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,224,176,FontBlack,TEXTDOUBLEG,17 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,176,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,176,FontBlack,FDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,FDLONG     ; T0 = Long Data Offset
  ld t1,0(t0)      ; T1 = Long Data
  la t0,MULDCHECKG ; T0 = Long Check Data Offset
  ld t2,0(t0)      ; T2 = Long Check Data
  beq t1,t2,MULDPASSG ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,176,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j MULDENDG
  nop ; Delay Slot
  MULDPASSG:
  PrintString $A010,528,176,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  MULDENDG:


  PrintString $A010,8,192,FontRed,MULS,4 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,VALUEFLOATA ; T0 = Float Data Offset
  lwc1 f0,0(t0)     ; F0 = Float Data
  la t0,VALUEFLOATB ; T0 = Float Data Offset
  lwc1 f1,0(t0)     ; F1 = Float Data
  mul.s f0,f1 ; Convert To Word Data
  la t0,FDWORD  ; T0 = FDWORD Offset
  swc1 f0,0(t0) ; FDWORD = Word Data
  PrintString $A010,144,192,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,192,FontBlack,VALUEFLOATA,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,344,192,FontBlack,TEXTFLOATA,2  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,144,200,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,200,FontBlack,VALUEFLOATB,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,296,200,FontBlack,TEXTFLOATB,8  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,200,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,200,FontBlack,FDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,FDWORD     ; T0 = Word Data Offset
  lw t1,0(t0)      ; T1 = Word Data
  la t0,MULSCHECKA ; T0 = Word Check Data Offset
  lw t2,0(t0)      ; T2 = Word Check Data
  beq t1,t2,MULSPASSA ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,200,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j MULSENDA
  nop ; Delay Slot
  MULSPASSA:
  PrintString $A010,528,200,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  MULSENDA:

  la t0,VALUEFLOATB ; T0 = Float Data Offset
  lwc1 f0,0(t0)     ; F0 = Float Data
  la t0,VALUEFLOATC ; T0 = Float Data Offset
  lwc1 f1,0(t0)     ; F1 = Float Data
  mul.s f0,f1 ; Convert To Word Data
  la t0,FDWORD  ; T0 = FDWORD Offset
  swc1 f0,0(t0) ; FDWORD = Word Data
  PrintString $A010,144,216,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,216,FontBlack,VALUEFLOATB,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,296,216,FontBlack,TEXTFLOATB,8  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,144,224,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,224,FontBlack,VALUEFLOATC,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,320,224,FontBlack,TEXTFLOATC,5  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,224,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,224,FontBlack,FDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,FDWORD     ; T0 = Word Data Offset
  lw t1,0(t0)      ; T1 = Word Data
  la t0,MULSCHECKB ; T0 = Word Check Data Offset
  lw t2,0(t0)      ; T2 = Word Check Data
  beq t1,t2,MULSPASSB ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,224,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j MULSENDB
  nop ; Delay Slot
  MULSPASSB:
  PrintString $A010,528,224,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  MULSENDB:

  la t0,VALUEFLOATC ; T0 = Float Data Offset
  lwc1 f0,0(t0)     ; F0 = Float Data
  la t0,VALUEFLOATD ; T0 = Float Data Offset
  lwc1 f1,0(t0)     ; F1 = Float Data
  mul.s f0,f1 ; Convert To Word Data
  la t0,FDWORD  ; T0 = FDWORD Offset
  swc1 f0,0(t0) ; FDWORD = Word Data
  PrintString $A010,144,240,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,240,FontBlack,VALUEFLOATC,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,320,240,FontBlack,TEXTFLOATC,5  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,144,248,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,248,FontBlack,VALUEFLOATD,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,296,248,FontBlack,TEXTFLOATD,8  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,248,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,248,FontBlack,FDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,FDWORD     ; T0 = Word Data Offset
  lw t1,0(t0)      ; T1 = Word Data
  la t0,MULSCHECKC ; T0 = Word Check Data Offset
  lw t2,0(t0)      ; T2 = Word Check Data
  beq t1,t2,MULSPASSC ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,248,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j MULSENDC
  nop ; Delay Slot
  MULSPASSC:
  PrintString $A010,528,248,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  MULSENDC:

  la t0,VALUEFLOATD ; T0 = Float Data Offset
  lwc1 f0,0(t0)     ; F0 = Float Data
  la t0,VALUEFLOATE ; T0 = Float Data Offset
  lwc1 f1,0(t0)     ; F1 = Float Data
  mul.s f0,f1 ; Convert To Word Data
  la t0,FDWORD  ; T0 = FDWORD Offset
  swc1 f0,0(t0) ; FDWORD = Word Data
  PrintString $A010,144,264,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,264,FontBlack,VALUEFLOATD,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,296,264,FontBlack,TEXTFLOATD,8  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,144,272,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,272,FontBlack,VALUEFLOATE,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,272,FontBlack,TEXTFLOATE,9  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,272,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,272,FontBlack,FDWord,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,FDWORD     ; T0 = Word Data Offset
  lw t1,0(t0)      ; T1 = Word Data
  la t0,MULSCHECKD ; T0 = Word Check Data Offset
  lw t2,0(t0)      ; T2 = Word Check Data
  beq t1,t2,MULSPASSD ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,272,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j MULSENDD
  nop ; Delay Slot
  MULSPASSD:
  PrintString $A010,528,272,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  MULSENDD:

  la t0,VALUEFLOATE ; T0 = Float Data Offset
  lwc1 f0,0(t0)     ; F0 = Float Data
  la t0,VALUEFLOATF ; T0 = Float Data Offset
  lwc1 f1,0(t0)     ; F1 = Float Data
  mul.s f0,f1 ; Convert To Word Data
  la t0,FDWORD  ; T0 = FDWORD Offset
  swc1 f0,0(t0) ; FDWORD = Word Data
  PrintString $A010,144,288,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,288,FontBlack,VALUEFLOATE,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,288,FontBlack,TEXTFLOATE,9  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,144,296,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,296,FontBlack,VALUEFLOATF,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,312,296,FontBlack,TEXTFLOATF,6  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,296,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,296,FontBlack,FDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,FDWord     ; T0 = Word Data Offset
  lw t1,0(t0)      ; T1 = Word Data
  la t0,MULSCHECKE ; T0 = Word Check Data Offset
  lw t2,0(t0)      ; T2 = Word Check Data
  beq t1,t2,MULSPASSE ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,296,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j MULSENDE
  nop ; Delay Slot
  MULSPASSE:
  PrintString $A010,528,296,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  MULSENDE:

  la t0,VALUEFLOATF ; T0 = Float Data Offset
  lwc1 f0,0(t0)     ; F0 = Float Data
  la t0,VALUEFLOATG ; T0 = Float Data Offset
  lwc1 f1,0(t0)     ; F1 = Float Data
  mul.s f0,f1 ; Convert To Word Data
  la t0,FDWORD  ; T0 = FDWORD Offset
  swc1 f0,0(t0) ; FDWORD = Word Data
  PrintString $A010,144,312,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,312,FontBlack,VALUEFLOATF,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,312,312,FontBlack,TEXTFLOATF,6  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,144,320,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,320,FontBlack,VALUEFLOATG,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,320,FontBlack,TEXTFLOATG,9  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,320,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,320,FontBlack,FDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,FDWORD     ; T0 = Word Data Offset
  lw t1,0(t0)      ; T1 = Word Data
  la t0,MULSCHECKF ; T0 = Word Check Data Offset
  lw t2,0(t0)      ; T2 = Word Check Data
  beq t1,t2,MULSPASSF ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,320,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j MULSENDF
  nop ; Delay Slot
  MULSPASSF:
  PrintString $A010,528,320,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  MULSENDF:

  la t0,VALUEFLOATA ; T0 = Float Data Offset
  lwc1 f0,0(t0)     ; F0 = Float Data
  la t0,VALUEFLOATG ; T0 = Float Data Offset
  lwc1 f1,0(t0)     ; F1 = Float Data
  mul.s f0,f1 ; Convert To Word Data
  la t0,FDWORD  ; T0 = FDWORD Offset
  swc1 f0,0(t0) ; FDWORD = Word Data
  PrintString $A010,144,336,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,336,FontBlack,VALUEFLOATA,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,344,336,FontBlack,TEXTFLOATA,2  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,144,344,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,344,FontBlack,VALUEFLOATG,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,344,FontBlack,TEXTFLOATG,9  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,344,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,344,FontBlack,FDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,FDWORD     ; T0 = Word Data Offset
  lw t1,0(t0)      ; T1 = Word Data
  la t0,MULSCHECKG ; T0 = Word Check Data Offset
  lw t2,0(t0)      ; T2 = Word Check Data
  beq t1,t2,MULSPASSG ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,344,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j MULSENDG
  nop ; Delay Slot
  MULSPASSG:
  PrintString $A010,528,344,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  MULSENDG:


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

MULD: db "MUL.D"
MULS: db "MUL.S"

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

  align 8 ; Align 64-bit
VALUEDOUBLEA: IEEE64 0.0
VALUEDOUBLEB: IEEE64 12345678.67891234
VALUEDOUBLEC: IEEE64 12345678.5
VALUEDOUBLED: IEEE64 12345678.12345678
VALUEDOUBLEE: IEEE64 -12345678.12345678
VALUEDOUBLEF: IEEE64 -12345678.5
VALUEDOUBLEG: IEEE64 -12345678.67891234

MULDCHECKA: data $0000000000000000
MULDCHECKB: data $42E153E20D49258F
MULDCHECKC: data $42E153E20034C517
MULDCHECKD: data $C2E153E1F756E7EA
MULDCHECKE: data $42E153E20034C517
MULDCHECKF: data $42E153E20D49258F
MULDCHECKG: data $8000000000000000

FDLONG: data 0

VALUEFLOATA: IEEE32 0.0
VALUEFLOATB: IEEE32 1234.6789
VALUEFLOATC: IEEE32 1234.5
VALUEFLOATD: IEEE32 1234.1234
VALUEFLOATE: IEEE32 -1234.1234
VALUEFLOATF: IEEE32 -1234.5
VALUEFLOATG: IEEE32 -1234.6789

MULSCHECKA: dw $00000000
MULSCHECKB: dw $49BA0F99
MULSCHECKC: dw $49B9FA2B
MULSCHECKD: dw $C9B9EBA5
MULSCHECKE: dw $49B9FA2B
MULSCHECKF: dw $49BA0F99
MULSCHECKG: dw $80000000

FDWORD: dw 0

FontBlack: incbin FontBlack8x8.bin
FontGreen: incbin FontGreen8x8.bin
FontRed: incbin FontRed8x8.bin