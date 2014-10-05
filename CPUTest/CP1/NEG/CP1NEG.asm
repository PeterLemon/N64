; N64 'Bare Metal' CPU CP1/FPU Negate Test Demo by krom (Peter Lemon):
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


  PrintString $A010,88,8,FontRed,FSHEX,7 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,232,8,FontRed,FSDEC,11 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,384,8,FontRed,NEGFSHEX,12 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,528,8,FontRed,TEST,10 ; Print Text String To VRAM Using Font At X,Y Position


  PrintString $A010,0,16,FontBlack,PAGEBREAK,79 ; Print Text String To VRAM Using Font At X,Y Position


  PrintString $A010,8,24,FontRed,NEGD,4 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,VALUEDOUBLEA ; A0 = Double Data Offset
  ldc1 f0,0(a0)      ; F0 = Double Data
  neg.d f0 ; Convert To Long Data
  la a0,FSLONG  ; A0 = FSLONG Offset
  sdc1 f0,0(a0) ; FSLONG = Long Data
  PrintString $A010,80,24,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,24,FontBlack,VALUEDOUBLEA,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,344,24,FontBlack,TEXTDOUBLEA,2 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,24,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,24,FontBlack,FSLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,FSLONG     ; A0 = Long Data Offset
  ld t0,0(a0)      ; T0 = Long Data
  la a0,NEGDCHECKA ; A0 = Long Check Data Offset
  ld t1,0(a0)      ; T1 = Long Check Data
  beq t0,t1,NEGDPASSA ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,24,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j NEGDENDA
  nop ; Delay Slot
  NEGDPASSA:
  PrintString $A010,528,24,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  NEGDENDA:

  la a0,VALUEDOUBLEB ; A0 = Double Data Offset
  ldc1 f0,0(a0)      ; F0 = Double Data
  neg.d f0 ; Convert To Long Data
  la a0,FSLONG  ; A0 = FSLONG Offset
  sdc1 f0,0(a0) ; FSLONG = Long Data
  PrintString $A010,80,32,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,32,FontBlack,VALUEDOUBLEB,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,232,32,FontBlack,TEXTDOUBLEB,16 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,32,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,32,FontBlack,FSLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,FSLONG     ; A0 = Long Data Offset
  ld t0,0(a0)      ; T0 = Long Data
  la a0,NEGDCHECKB ; A0 = Long Check Data Offset
  ld t1,0(a0)      ; T1 = Long Check Data
  beq t0,t1,NEGDPASSB ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,32,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j NEGDENDB
  nop ; Delay Slot
  NEGDPASSB:
  PrintString $A010,528,32,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  NEGDENDB:

  la a0,VALUEDOUBLEC ; A0 = Double Data Offset
  ldc1 f0,0(a0)      ; F0 = Double Data
  neg.d f0 ; Convert To Long Data
  la a0,FSLONG  ; A0 = FSLONG Offset
  sdc1 f0,0(a0) ; FSLONG = Long Data
  PrintString $A010,80,40,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,40,FontBlack,VALUEDOUBLEC,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,40,FontBlack,TEXTDOUBLEC,9 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,40,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,40,FontBlack,FSLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,FSLONG     ; A0 = Long Data Offset
  ld t0,0(a0)      ; T0 = Long Data
  la a0,NEGDCHECKC ; A0 = Long Check Data Offset
  ld t1,0(a0)      ; T1 = Long Check Data
  beq t0,t1,NEGDPASSC ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,40,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j NEGDENDC
  nop ; Delay Slot
  NEGDPASSC:
  PrintString $A010,528,40,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  NEGDENDC:

  la a0,VALUEDOUBLED ; A0 = Double Data Offset
  ldc1 f0,0(a0)      ; F0 = Double Data
  neg.d f0 ; Convert To Long Data
  la a0,FSLONG  ; A0 = FSLONG Offset
  sdc1 f0,0(a0) ; FSLONG = Long Data
  PrintString $A010,80,48,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,48,FontBlack,VALUEDOUBLED,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,232,48,FontBlack,TEXTDOUBLED,16 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,48,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,48,FontBlack,FSLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,FSLONG     ; A0 = Long Data Offset
  ld t0,0(a0)      ; T0 = Long Data
  la a0,NEGDCHECKD ; A0 = Long Check Data Offset
  ld t1,0(a0)      ; T1 = Long Check Data
  beq t0,t1,NEGDPASSD ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,48,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j NEGDENDD
  nop ; Delay Slot
  NEGDPASSD:
  PrintString $A010,528,48,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  NEGDENDD:

  la a0,VALUEDOUBLEE ; A0 = Double Data Offset
  ldc1 f0,0(a0)      ; F0 = Double Data
  neg.d f0 ; Convert To Long Data
  la a0,FSLONG  ; A0 = FSLONG Offset
  sdc1 f0,0(a0) ; FSLONG = Long Data
  PrintString $A010,80,56,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,56,FontBlack,VALUEDOUBLEE,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,224,56,FontBlack,TEXTDOUBLEE,17 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,56,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,56,FontBlack,FSLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,FSLONG     ; A0 = Long Data Offset
  ld t0,0(a0)      ; T0 = Long Data
  la a0,NEGDCHECKE ; A0 = Long Check Data Offset
  ld t1,0(a0)      ; T1 = Long Check Data
  beq t0,t1,NEGDPASSE ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,56,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j NEGDENDE
  nop ; Delay Slot
  NEGDPASSE:
  PrintString $A010,528,56,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  NEGDENDE:

  la a0,VALUEDOUBLEF ; A0 = Double Data Offset
  ldc1 f0,0(a0)      ; F0 = Double Data
  neg.d f0 ; Convert To Long Data
  la a0,FSLONG  ; A0 = FSLONG Offset
  sdc1 f0,0(a0) ; FSLONG = Long Data
  PrintString $A010,80,64,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,64,FontBlack,VALUEDOUBLEF,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,280,64,FontBlack,TEXTDOUBLEF,10 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,64,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,64,FontBlack,FSLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,FSLONG     ; A0 = Long Data Offset
  ld t0,0(a0)      ; T0 = Long Data
  la a0,NEGDCHECKF ; A0 = Long Check Data Offset
  ld t1,0(a0)      ; T1 = Long Check Data
  beq t0,t1,NEGDPASSF ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,64,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j NEGDENDF
  nop ; Delay Slot
  NEGDPASSF:
  PrintString $A010,528,64,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  NEGDENDF:

  la a0,VALUEDOUBLEG ; A0 = Double Data Offset
  ldc1 f0,0(a0)      ; F0 = Double Data
  neg.d f0 ; Convert To Long Data
  la a0,FSLONG  ; A0 = FSLONG Offset
  sdc1 f0,0(a0) ; FSLONG = Long Data
  PrintString $A010,80,72,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,72,FontBlack,VALUEDOUBLEG,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,224,72,FontBlack,TEXTDOUBLEG,17 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,72,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,72,FontBlack,FSLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,FSLONG     ; A0 = Long Data Offset
  ld t0,0(a0)      ; T0 = Long Data
  la a0,NEGDCHECKG ; A0 = Long Check Data Offset
  ld t1,0(a0)      ; T1 = Long Check Data
  beq t0,t1,NEGDPASSG ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,72,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j NEGDENDG
  nop ; Delay Slot
  NEGDPASSG:
  PrintString $A010,528,72,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  NEGDENDG:


  PrintString $A010,8,88,FontRed,NEGS,4 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,VALUEFLOATA ; A0 = Float Data Offset
  lwc1 f0,0(a0)     ; F0 = Float Data
  neg.s f0 ; Convert To Word Data
  la a0,FSWORD  ; A0 = FSWORD Offset
  swc1 f0,0(a0) ; FSWORD = Word Data
  PrintString $A010,144,88,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,88,FontBlack,VALUEFLOATA,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,344,88,FontBlack,TEXTFLOATA,2  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,88,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,88,FontBlack,FSWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,FSWORD     ; A0 = Word Data Offset
  lw t0,0(a0)      ; T0 = Word Data
  la a0,NEGSCHECKA ; A0 = Word Check Data Offset
  lw t1,0(a0)      ; T1 = Word Check Data
  beq t0,t1,NEGSPASSA ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,88,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j NEGSENDA
  nop ; Delay Slot
  NEGSPASSA:
  PrintString $A010,528,88,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  NEGSENDA:

  la a0,VALUEFLOATB ; A0 = Float Data Offset
  lwc1 f0,0(a0)     ; F0 = Float Data
  neg.s f0 ; Convert To Word Data
  la a0,FSWORD  ; A0 = FSWORD Offset
  swc1 f0,0(a0) ; FSWORD = Word Data
  PrintString $A010,144,96,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,96,FontBlack,VALUEFLOATB,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,296,96,FontBlack,TEXTFLOATB,8  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,96,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,96,FontBlack,FSWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,FSWORD     ; A0 = Word Data Offset
  lw t0,0(a0)      ; T0 = Word Data
  la a0,NEGSCHECKB ; A0 = Word Check Data Offset
  lw t1,0(a0)      ; T1 = Word Check Data
  beq t0,t1,NEGSPASSB ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,96,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j NEGSENDB
  nop ; Delay Slot
  NEGSPASSB:
  PrintString $A010,528,96,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  NEGSENDB:

  la a0,VALUEFLOATC ; A0 = Float Data Offset
  lwc1 f0,0(a0)     ; F0 = Float Data
  neg.s f0 ; Convert To Word Data
  la a0,FSWORD  ; A0 = FSWORD Offset
  swc1 f0,0(a0) ; FSWORD = Word Data
  PrintString $A010,144,104,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,104,FontBlack,VALUEFLOATC,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,320,104,FontBlack,TEXTFLOATC,5  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,104,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,104,FontBlack,FSWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,FSWORD     ; A0 = Word Data Offset
  lw t0,0(a0)      ; T0 = Word Data
  la a0,NEGSCHECKC ; A0 = Word Check Data Offset
  lw t1,0(a0)      ; T1 = Word Check Data
  beq t0,t1,NEGSPASSC ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,104,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j NEGSENDC
  nop ; Delay Slot
  NEGSPASSC:
  PrintString $A010,528,104,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  NEGSENDC:

  la a0,VALUEFLOATD ; A0 = Float Data Offset
  lwc1 f0,0(a0)     ; F0 = Float Data
  neg.s f0 ; Convert To Word Data
  la a0,FSWORD  ; A0 = FSWORD Offset
  swc1 f0,0(a0) ; FSWORD = Word Data
  PrintString $A010,144,112,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,112,FontBlack,VALUEFLOATD,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,296,112,FontBlack,TEXTFLOATD,8  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,112,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,112,FontBlack,FSWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,FSWORD     ; A0 = Word Data Offset
  lw t0,0(a0)      ; T0 = Word Data
  la a0,NEGSCHECKD ; A0 = Word Check Data Offset
  lw t1,0(a0)      ; T1 = Word Check Data
  beq t0,t1,NEGSPASSD ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,112,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j NEGSENDD
  nop ; Delay Slot
  NEGSPASSD:
  PrintString $A010,528,112,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  NEGSENDD:

  la a0,VALUEFLOATE ; A0 = Float Data Offset
  lwc1 f0,0(a0)     ; F0 = Float Data
  neg.s f0 ; Convert To Word Data
  la a0,FSWORD  ; A0 = FSWORD Offset
  swc1 f0,0(a0) ; FSWORD = Word Data
  PrintString $A010,144,120,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,120,FontBlack,VALUEFLOATE,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,120,FontBlack,TEXTFLOATE,9  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,120,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,120,FontBlack,FSWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,FSWORD     ; A0 = Word Data Offset
  lw t0,0(a0)      ; T0 = Word Data
  la a0,NEGSCHECKE ; A0 = Word Check Data Offset
  lw t1,0(a0)      ; T1 = Word Check Data
  beq t0,t1,NEGSPASSE ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,120,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j NEGSENDE
  nop ; Delay Slot
  NEGSPASSE:
  PrintString $A010,528,120,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  NEGSENDE:

  la a0,VALUEFLOATF ; A0 = Float Data Offset
  lwc1 f0,0(a0)     ; F0 = Float Data
  neg.s f0 ; Convert To Word Data
  la a0,FSWORD  ; A0 = FSWORD Offset
  swc1 f0,0(a0) ; FSWORD = Word Data
  PrintString $A010,144,128,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,128,FontBlack,VALUEFLOATF,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,312,128,FontBlack,TEXTFLOATF,6  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,128,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,128,FontBlack,FSWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,FSWORD     ; A0 = Word Data Offset
  lw t0,0(a0)      ; T0 = Word Data
  la a0,NEGSCHECKF ; A0 = Word Check Data Offset
  lw t1,0(a0)      ; T1 = Word Check Data
  beq t0,t1,NEGSPASSF ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,128,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j NEGSENDF
  nop ; Delay Slot
  NEGSPASSF:
  PrintString $A010,528,128,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  NEGSENDF:

  la a0,VALUEFLOATG ; A0 = Float Data Offset
  lwc1 f0,0(a0)     ; F0 = Float Data
  neg.s f0 ; Convert To Word Data
  la a0,FSWORD  ; A0 = FSWORD Offset
  swc1 f0,0(a0) ; FSWORD = Word Data
  PrintString $A010,144,136,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,136,FontBlack,VALUEFLOATG,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,136,FontBlack,TEXTFLOATG,9  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,136,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,136,FontBlack,FSWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,FSWORD     ; A0 = Word Data Offset
  lw t0,0(a0)      ; T0 = Word Data
  la a0,NEGSCHECKG ; A0 = Word Check Data Offset
  lw t1,0(a0)      ; T1 = Word Check Data
  beq t0,t1,NEGSPASSG ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,136,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j NEGSENDG
  nop ; Delay Slot
  NEGSPASSG:
  PrintString $A010,528,136,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  NEGSENDG:


  PrintString $A010,0,144,FontBlack,PAGEBREAK,79 ; Print Text String To VRAM Using Font At X,Y Position


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

NEGD: db "NEG.D"
NEGS: db "NEG.S"

NEGFSHEX: db "NEG(FS) (Hex)"
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

  align 8 ; Align 64-Bit
VALUEDOUBLEA: IEEE64 0.0
VALUEDOUBLEB: IEEE64 12345678.67891234
VALUEDOUBLEC: IEEE64 12345678.5
VALUEDOUBLED: IEEE64 12345678.12345678
VALUEDOUBLEE: IEEE64 -12345678.12345678
VALUEDOUBLEF: IEEE64 -12345678.5
VALUEDOUBLEG: IEEE64 -12345678.67891234

NEGDCHECKA: data $8000000000000000
NEGDCHECKB: data $C1678C29D5B9A65F
NEGDCHECKC: data $C1678C29D0000000
NEGDCHECKD: data $C1678C29C3F35BA2
NEGDCHECKE: data $41678C29C3F35BA2
NEGDCHECKF: data $41678C29D0000000
NEGDCHECKG: data $41678C29D5B9A65F

FSLONG: data 0

VALUEFLOATA: IEEE32 0.0
VALUEFLOATB: IEEE32 1234.6789
VALUEFLOATC: IEEE32 1234.5
VALUEFLOATD: IEEE32 1234.1234
VALUEFLOATE: IEEE32 -1234.1234
VALUEFLOATF: IEEE32 -1234.5
VALUEFLOATG: IEEE32 -1234.6789

NEGSCHECKA: dw $80000000
NEGSCHECKB: dw $C49A55BA
NEGSCHECKC: dw $C49A5000
NEGSCHECKD: dw $C49A43F3
NEGSCHECKE: dw $449A43F3
NEGSCHECKF: dw $449A5000
NEGSCHECKG: dw $449A55BA

FSWORD: dw 0

FontBlack: incbin FontBlack8x8.bin
FontGreen: incbin FontGreen8x8.bin
FontRed: incbin FontRed8x8.bin