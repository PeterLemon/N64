; N64 'Bare Metal' CPU CP1/FPU Absolute Test Demo by krom (Peter Lemon):

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




  PrintString $A010,88,8,FontRed,FSHEX,7 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,232,8,FontRed,FSDEC,11 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,384,8,FontRed,ABSFSHEX,12 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,528,8,FontRed,TEST,10 ; Print Text String To VRAM Using Font At X,Y Position


  PrintString $A010,0,16,FontBlack,PAGEBREAK,79 ; Print Text String To VRAM Using Font At X,Y Position


  PrintString $A010,8,24,FontRed,ABSD,4 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,VALUEDOUBLEA ; T0 = Double Data Offset
  ldc1 f0,0(t0)      ; F0 = Double Data
  abs.d f0 ; Convert To Long Data
  la t0,FSLONG  ; T0 = FSLONG Offset
  sdc1 f0,0(t0) ; FSLONG = Long Data
  PrintString $A010,80,24,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,24,FontBlack,VALUEDOUBLEA,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,344,24,FontBlack,TEXTDOUBLEA,2 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,24,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,24,FontBlack,FSLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,FSLONG     ; T0 = Long Data Offset
  ld t1,0(t0)      ; T1 = Long Data
  la t0,ABSDCHECKA ; T0 = Long Check Data Offset
  ld t2,0(t0)      ; T2 = Long Check Data
  beq t1,t2,ABSDPASSA ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,24,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j ABSDENDA
  nop ; Delay Slot
  ABSDPASSA:
  PrintString $A010,528,24,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  ABSDENDA:

  la t0,VALUEDOUBLEB ; T0 = Double Data Offset
  ldc1 f0,0(t0)      ; F0 = Double Data
  abs.d f0 ; Convert To Long Data
  la t0,FSLONG  ; T0 = FSLONG Offset
  sdc1 f0,0(t0) ; FSLONG = Long Data
  PrintString $A010,80,32,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,32,FontBlack,VALUEDOUBLEB,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,232,32,FontBlack,TEXTDOUBLEB,16 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,32,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,32,FontBlack,FSLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,FSLONG     ; T0 = Long Data Offset
  ld t1,0(t0)      ; T1 = Long Data
  la t0,ABSDCHECKB ; T0 = Long Check Data Offset
  ld t2,0(t0)      ; T2 = Long Check Data
  beq t1,t2,ABSDPASSB ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,32,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j ABSDENDB
  nop ; Delay Slot
  ABSDPASSB:
  PrintString $A010,528,32,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  ABSDENDB:

  la t0,VALUEDOUBLEC ; T0 = Double Data Offset
  ldc1 f0,0(t0)      ; F0 = Double Data
  abs.d f0 ; Convert To Long Data
  la t0,FSLONG  ; T0 = FSLONG Offset
  sdc1 f0,0(t0) ; FSLONG = Long Data
  PrintString $A010,80,40,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,40,FontBlack,VALUEDOUBLEC,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,40,FontBlack,TEXTDOUBLEC,9 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,40,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,40,FontBlack,FSLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,FSLONG     ; T0 = Long Data Offset
  ld t1,0(t0)      ; T1 = Long Data
  la t0,ABSDCHECKC ; T0 = Long Check Data Offset
  ld t2,0(t0)      ; T2 = Long Check Data
  beq t1,t2,ABSDPASSC ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,40,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j ABSDENDC
  nop ; Delay Slot
  ABSDPASSC:
  PrintString $A010,528,40,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  ABSDENDC:

  la t0,VALUEDOUBLED ; T0 = Double Data Offset
  ldc1 f0,0(t0)      ; F0 = Double Data
  abs.d f0 ; Convert To Long Data
  la t0,FSLONG  ; T0 = FSLONG Offset
  sdc1 f0,0(t0) ; FSLONG = Long Data
  PrintString $A010,80,48,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,48,FontBlack,VALUEDOUBLED,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,232,48,FontBlack,TEXTDOUBLED,16 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,48,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,48,FontBlack,FSLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,FSLONG     ; T0 = Long Data Offset
  ld t1,0(t0)      ; T1 = Long Data
  la t0,ABSDCHECKD ; T0 = Long Check Data Offset
  ld t2,0(t0)      ; T2 = Long Check Data
  beq t1,t2,ABSDPASSD ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,48,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j ABSDENDD
  nop ; Delay Slot
  ABSDPASSD:
  PrintString $A010,528,48,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  ABSDENDD:

  la t0,VALUEDOUBLEE ; T0 = Double Data Offset
  ldc1 f0,0(t0)      ; F0 = Double Data
  abs.d f0 ; Convert To Long Data
  la t0,FSLONG  ; T0 = FSLONG Offset
  sdc1 f0,0(t0) ; FSLONG = Long Data
  PrintString $A010,80,56,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,56,FontBlack,VALUEDOUBLEE,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,224,56,FontBlack,TEXTDOUBLEE,17 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,56,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,56,FontBlack,FSLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,FSLONG     ; T0 = Long Data Offset
  ld t1,0(t0)      ; T1 = Long Data
  la t0,ABSDCHECKE ; T0 = Long Check Data Offset
  ld t2,0(t0)      ; T2 = Long Check Data
  beq t1,t2,ABSDPASSE ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,56,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j ABSDENDE
  nop ; Delay Slot
  ABSDPASSE:
  PrintString $A010,528,56,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  ABSDENDE:

  la t0,VALUEDOUBLEF ; T0 = Double Data Offset
  ldc1 f0,0(t0)      ; F0 = Double Data
  abs.d f0 ; Convert To Long Data
  la t0,FSLONG  ; T0 = FSLONG Offset
  sdc1 f0,0(t0) ; FSLONG = Long Data
  PrintString $A010,80,64,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,64,FontBlack,VALUEDOUBLEF,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,280,64,FontBlack,TEXTDOUBLEF,10 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,64,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,64,FontBlack,FSLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,FSLONG     ; T0 = Long Data Offset
  ld t1,0(t0)      ; T1 = Long Data
  la t0,ABSDCHECKF ; T0 = Long Check Data Offset
  ld t2,0(t0)      ; T2 = Long Check Data
  beq t1,t2,ABSDPASSF ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,64,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j ABSDENDF
  nop ; Delay Slot
  ABSDPASSF:
  PrintString $A010,528,64,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  ABSDENDF:

  la t0,VALUEDOUBLEG ; T0 = Double Data Offset
  ldc1 f0,0(t0)      ; F0 = Double Data
  abs.d f0 ; Convert To Long Data
  la t0,FSLONG  ; T0 = FSLONG Offset
  sdc1 f0,0(t0) ; FSLONG = Long Data
  PrintString $A010,80,72,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,72,FontBlack,VALUEDOUBLEG,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,224,72,FontBlack,TEXTDOUBLEG,17 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,72,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,72,FontBlack,FSLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,FSLONG     ; T0 = Long Data Offset
  ld t1,0(t0)      ; T1 = Long Data
  la t0,ABSDCHECKG ; T0 = Long Check Data Offset
  ld t2,0(t0)      ; T2 = Long Check Data
  beq t1,t2,ABSDPASSG ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,72,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j ABSDENDG
  nop ; Delay Slot
  ABSDPASSG:
  PrintString $A010,528,72,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  ABSDENDG:


  PrintString $A010,8,88,FontRed,ABSS,4 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,VALUEFLOATA ; T0 = Float Data Offset
  lwc1 f0,0(t0)     ; F0 = Float Data
  abs.s f0 ; Convert To Word Data
  la t0,FSWORD  ; T0 = FSWORD Offset
  swc1 f0,0(t0) ; FSWORD = Word Data
  PrintString $A010,144,88,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,88,FontBlack,VALUEFLOATA,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,344,88,FontBlack,TEXTFLOATA,2  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,88,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,88,FontBlack,FSWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,FSWORD     ; T0 = Word Data Offset
  lw t1,0(t0)      ; T1 = Word Data
  la t0,ABSSCHECKA ; T0 = Word Check Data Offset
  lw t2,0(t0)      ; T2 = Word Check Data
  beq t1,t2,ABSSPASSA ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,88,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j ABSSENDA
  nop ; Delay Slot
  ABSSPASSA:
  PrintString $A010,528,88,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  ABSSENDA:

  la t0,VALUEFLOATB ; T0 = Float Data Offset
  lwc1 f0,0(t0)     ; F0 = Float Data
  abs.s f0 ; Convert To Word Data
  la t0,FSWORD  ; T0 = FSWORD Offset
  swc1 f0,0(t0) ; FSWORD = Word Data
  PrintString $A010,144,96,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,96,FontBlack,VALUEFLOATB,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,296,96,FontBlack,TEXTFLOATB,8  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,96,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,96,FontBlack,FSWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,FSWORD     ; T0 = Word Data Offset
  lw t1,0(t0)      ; T1 = Word Data
  la t0,ABSSCHECKB ; T0 = Word Check Data Offset
  lw t2,0(t0)      ; T2 = Word Check Data
  beq t1,t2,ABSSPASSB ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,96,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j ABSSENDB
  nop ; Delay Slot
  ABSSPASSB:
  PrintString $A010,528,96,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  ABSSENDB:

  la t0,VALUEFLOATC ; T0 = Float Data Offset
  lwc1 f0,0(t0)     ; F0 = Float Data
  abs.s f0 ; Convert To Word Data
  la t0,FSWORD  ; T0 = FSWORD Offset
  swc1 f0,0(t0) ; FSWORD = Word Data
  PrintString $A010,144,104,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,104,FontBlack,VALUEFLOATC,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,320,104,FontBlack,TEXTFLOATC,5  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,104,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,104,FontBlack,FSWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,FSWORD     ; T0 = Word Data Offset
  lw t1,0(t0)      ; T1 = Word Data
  la t0,ABSSCHECKC ; T0 = Word Check Data Offset
  lw t2,0(t0)      ; T2 = Word Check Data
  beq t1,t2,ABSSPASSC ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,104,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j ABSSENDC
  nop ; Delay Slot
  ABSSPASSC:
  PrintString $A010,528,104,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  ABSSENDC:

  la t0,VALUEFLOATD ; T0 = Float Data Offset
  lwc1 f0,0(t0)     ; F0 = Float Data
  abs.s f0 ; Convert To Word Data
  la t0,FSWORD  ; T0 = FSWORD Offset
  swc1 f0,0(t0) ; FSWORD = Word Data
  PrintString $A010,144,112,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,112,FontBlack,VALUEFLOATD,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,296,112,FontBlack,TEXTFLOATD,8  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,112,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,112,FontBlack,FSWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,FSWORD     ; T0 = Word Data Offset
  lw t1,0(t0)      ; T1 = Word Data
  la t0,ABSSCHECKD ; T0 = Word Check Data Offset
  lw t2,0(t0)      ; T2 = Word Check Data
  beq t1,t2,ABSSPASSD ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,112,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j ABSSENDD
  nop ; Delay Slot
  ABSSPASSD:
  PrintString $A010,528,112,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  ABSSENDD:

  la t0,VALUEFLOATE ; T0 = Float Data Offset
  lwc1 f0,0(t0)     ; F0 = Float Data
  abs.s f0 ; Convert To Word Data
  la t0,FSWORD  ; T0 = FSWORD Offset
  swc1 f0,0(t0) ; FSWORD = Word Data
  PrintString $A010,144,120,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,120,FontBlack,VALUEFLOATE,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,120,FontBlack,TEXTFLOATE,9  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,120,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,120,FontBlack,FSWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,FSWORD     ; T0 = Word Data Offset
  lw t1,0(t0)      ; T1 = Word Data
  la t0,ABSSCHECKE ; T0 = Word Check Data Offset
  lw t2,0(t0)      ; T2 = Word Check Data
  beq t1,t2,ABSSPASSE ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,120,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j ABSSENDE
  nop ; Delay Slot
  ABSSPASSE:
  PrintString $A010,528,120,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  ABSSENDE:

  la t0,VALUEFLOATF ; T0 = Float Data Offset
  lwc1 f0,0(t0)     ; F0 = Float Data
  abs.s f0 ; Convert To Word Data
  la t0,FSWORD  ; T0 = FSWORD Offset
  swc1 f0,0(t0) ; FSWORD = Word Data
  PrintString $A010,144,128,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,128,FontBlack,VALUEFLOATF,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,312,128,FontBlack,TEXTFLOATF,6  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,128,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,128,FontBlack,FSWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,FSWORD     ; T0 = Word Data Offset
  lw t1,0(t0)      ; T1 = Word Data
  la t0,ABSSCHECKF ; T0 = Word Check Data Offset
  lw t2,0(t0)      ; T2 = Word Check Data
  beq t1,t2,ABSSPASSF ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,128,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j ABSSENDF
  nop ; Delay Slot
  ABSSPASSF:
  PrintString $A010,528,128,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  ABSSENDF:

  la t0,VALUEFLOATG ; T0 = Float Data Offset
  lwc1 f0,0(t0)     ; F0 = Float Data
  abs.s f0 ; Convert To Word Data
  la t0,FSWORD  ; T0 = FSWORD Offset
  swc1 f0,0(t0) ; FSWORD = Word Data
  PrintString $A010,144,136,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,136,FontBlack,VALUEFLOATG,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,136,FontBlack,TEXTFLOATG,9  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,136,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,136,FontBlack,FSWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,FSWORD     ; T0 = Word Data Offset
  lw t1,0(t0)      ; T1 = Word Data
  la t0,ABSSCHECKG ; T0 = Word Check Data Offset
  lw t2,0(t0)      ; T2 = Word Check Data
  beq t1,t2,ABSSPASSG ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,136,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j ABSSENDG
  nop ; Delay Slot
  ABSSPASSG:
  PrintString $A010,528,136,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  ABSSENDG:


  PrintString $A010,0,144,FontBlack,PAGEBREAK,79 ; Print Text String To VRAM Using Font At X,Y Position


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

ABSD: db "ABS.D"
ABSS: db "ABS.S"

ABSFSHEX: db "ABS(FS) (Hex)"
FSHEX: db "FS (Hex)"
FSDEC: db "FS (Decimal)"
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

ABSDCHECKA: data $0000000000000000
ABSDCHECKB: data $41678C29D5B9A65F
ABSDCHECKC: data $41678C29D0000000
ABSDCHECKD: data $41678C29C3F35BA2
ABSDCHECKE: data $41678C29C3F35BA2
ABSDCHECKF: data $41678C29D0000000
ABSDCHECKG: data $41678C29D5B9A65F

FSLONG: data 0

VALUEFLOATA: IEEE32 0.0
VALUEFLOATB: IEEE32 1234.6789
VALUEFLOATC: IEEE32 1234.5
VALUEFLOATD: IEEE32 1234.1234
VALUEFLOATE: IEEE32 -1234.1234
VALUEFLOATF: IEEE32 -1234.5
VALUEFLOATG: IEEE32 -1234.6789

ABSSCHECKA: dw $00000000
ABSSCHECKB: dw $449A55BA
ABSSCHECKC: dw $449A5000
ABSSCHECKD: dw $449A43F3
ABSSCHECKE: dw $449A43F3
ABSSCHECKF: dw $449A5000
ABSSCHECKG: dw $449A55BA

FSWORD: dw 0

FontBlack: incbin FontBlack8x8.bin
FontGreen: incbin FontGreen8x8.bin
FontRed: incbin FontRed8x8.bin