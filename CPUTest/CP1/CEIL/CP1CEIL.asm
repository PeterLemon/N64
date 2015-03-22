; N64 'Bare Metal' CPU CP1/FPU Ceiling Test Demo by krom (Peter Lemon):
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


  PrintString $A010,88,8,FontRed,FSHEX,7 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,232,8,FontRed,FDFSDEC,14 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,384,8,FontRed,FDHEX,7 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,528,8,FontRed,TEST,10 ; Print Text String To VRAM Using Font At X,Y Position


  PrintString $A010,0,16,FontBlack,PAGEBREAK,79 ; Print Text String To VRAM Using Font At X,Y Position


  PrintString $A010,8,24,FontRed,CEILLD,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,VALUEDOUBLEA ; A0 = Double Data Offset
  ldc1 f0,0(a0)      ; F0 = Double Data
  ceil.l.d f0 ; Convert To Long Data
  la a0,FDLONG  ; A0 = FDLONG Offset
  sdc1 f0,0(a0) ; FDLONG = Long Data
  PrintString $A010,80,24,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,24,FontBlack,VALUEDOUBLEA,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,344,24,FontBlack,TEXTDOUBLEA,2 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,24,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,24,FontBlack,FDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,FDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,CEILLDCHECKA ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,CEILLDPASSA ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,24,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j CEILLDENDA
  nop ; Delay Slot
  CEILLDPASSA:
  PrintString $A010,528,24,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  CEILLDENDA:

  la a0,VALUEDOUBLEB ; A0 = Double Data Offset
  ldc1 f0,0(a0)      ; F0 = Double Data
  ceil.l.d f0 ; Convert To Long Data
  la a0,FDLONG  ; A0 = FDLONG Offset
  sdc1 f0,0(a0) ; FDLONG = Long Data
  PrintString $A010,80,32,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,32,FontBlack,VALUEDOUBLEB,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,232,32,FontBlack,TEXTDOUBLEB,16 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,32,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,32,FontBlack,FDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,FDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,CEILLDCHECKB ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,CEILLDPASSB ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,32,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j CEILLDENDB
  nop ; Delay Slot
  CEILLDPASSB:
  PrintString $A010,528,32,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  CEILLDENDB:

  la a0,VALUEDOUBLEC ; A0 = Double Data Offset
  ldc1 f0,0(a0)      ; F0 = Double Data
  ceil.l.d f0 ; Convert To Long Data
  la a0,FDLONG  ; A0 = FDLONG Offset
  sdc1 f0,0(a0) ; FDLONG = Long Data
  PrintString $A010,80,40,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,40,FontBlack,VALUEDOUBLEC,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,40,FontBlack,TEXTDOUBLEC,9 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,40,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,40,FontBlack,FDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,FDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,CEILLDCHECKC ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,CEILLDPASSC ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,40,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j CEILLDENDC
  nop ; Delay Slot
  CEILLDPASSC:
  PrintString $A010,528,40,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  CEILLDENDC:

  la a0,VALUEDOUBLED ; A0 = Double Data Offset
  ldc1 f0,0(a0)      ; F0 = Double Data
  ceil.l.d f0 ; Convert To Long Data
  la a0,FDLONG  ; A0 = FDLONG Offset
  sdc1 f0,0(a0) ; FDLONG = Long Data
  PrintString $A010,80,48,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,48,FontBlack,VALUEDOUBLED,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,232,48,FontBlack,TEXTDOUBLED,16 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,48,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,48,FontBlack,FDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,FDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,CEILLDCHECKD ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,CEILLDPASSD ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,48,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j CEILLDENDD
  nop ; Delay Slot
  CEILLDPASSD:
  PrintString $A010,528,48,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  CEILLDENDD:

  la a0,VALUEDOUBLEE ; A0 = Double Data Offset
  ldc1 f0,0(a0)      ; F0 = Double Data
  ceil.l.d f0 ; Convert To Long Data
  la a0,FDLONG  ; A0 = FDLONG Offset
  sdc1 f0,0(a0) ; FDLONG = Long Data
  PrintString $A010,80,56,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,56,FontBlack,VALUEDOUBLEE,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,224,56,FontBlack,TEXTDOUBLEE,17 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,56,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,56,FontBlack,FDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,FDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,CEILLDCHECKE ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,CEILLDPASSE ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,56,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j CEILLDENDE
  nop ; Delay Slot
  CEILLDPASSE:
  PrintString $A010,528,56,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  CEILLDENDE:

  la a0,VALUEDOUBLEF ; A0 = Double Data Offset
  ldc1 f0,0(a0)      ; F0 = Double Data
  ceil.l.d f0 ; Convert To Long Data
  la a0,FDLONG  ; A0 = FDLONG Offset
  sdc1 f0,0(a0) ; FDLONG = Long Data
  PrintString $A010,80,64,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,64,FontBlack,VALUEDOUBLEF,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,280,64,FontBlack,TEXTDOUBLEF,10 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,64,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,64,FontBlack,FDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,FDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,CEILLDCHECKF ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,CEILLDPASSF ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,64,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j CEILLDENDF
  nop ; Delay Slot
  CEILLDPASSF:
  PrintString $A010,528,64,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  CEILLDENDF:

  la a0,VALUEDOUBLEG ; A0 = Double Data Offset
  ldc1 f0,0(a0)      ; F0 = Double Data
  ceil.l.d f0 ; Convert To Long Data
  la a0,FDLONG  ; A0 = FDLONG Offset
  sdc1 f0,0(a0) ; FDLONG = Long Data
  PrintString $A010,80,72,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,72,FontBlack,VALUEDOUBLEG,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,224,72,FontBlack,TEXTDOUBLEG,17 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,72,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,72,FontBlack,FDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,FDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,CEILLDCHECKG ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,CEILLDPASSG ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,72,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j CEILLDENDG
  nop ; Delay Slot
  CEILLDPASSG:
  PrintString $A010,528,72,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  CEILLDENDG:


  PrintString $A010,8,88,FontRed,CEILLS,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,VALUEFLOATA ; A0 = Float Data Offset
  lwc1 f0,0(a0)     ; F0 = Float Data
  ceil.l.s f0 ; Convert To Long Data
  la a0,FDLONG  ; A0 = FDLONG Offset
  sdc1 f0,0(a0) ; FDLONG = Long Data
  PrintString $A010,144,88,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,88,FontBlack,VALUEFLOATA,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,344,88,FontBlack,TEXTFLOATA,2  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,88,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,88,FontBlack,FDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,FDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,CEILLSCHECKA ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,CEILLSPASSA ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,88,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j CEILLSENDA
  nop ; Delay Slot
  CEILLSPASSA:
  PrintString $A010,528,88,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  CEILLSENDA:

  la a0,VALUEFLOATB ; A0 = Float Data Offset
  lwc1 f0,0(a0)     ; F0 = Float Data
  ceil.l.s f0 ; Convert To Long Data
  la a0,FDLONG  ; A0 = FDLONG Offset
  sdc1 f0,0(a0) ; FDLONG = Long Data
  PrintString $A010,144,96,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,96,FontBlack,VALUEFLOATB,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,296,96,FontBlack,TEXTFLOATB,8  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,96,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,96,FontBlack,FDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,FDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,CEILLSCHECKB ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,CEILLSPASSB ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,96,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j CEILLSENDB
  nop ; Delay Slot
  CEILLSPASSB:
  PrintString $A010,528,96,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  CEILLSENDB:

  la a0,VALUEFLOATC ; A0 = Float Data Offset
  lwc1 f0,0(a0)     ; F0 = Float Data
  ceil.l.s f0 ; Convert To Long Data
  la a0,FDLONG  ; A0 = FDLONG Offset
  sdc1 f0,0(a0) ; FDLONG = Long Data
  PrintString $A010,144,104,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,104,FontBlack,VALUEFLOATC,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,320,104,FontBlack,TEXTFLOATC,5  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,104,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,104,FontBlack,FDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,FDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,CEILLSCHECKC ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,CEILLSPASSC ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,104,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j CEILLSENDC
  nop ; Delay Slot
  CEILLSPASSC:
  PrintString $A010,528,104,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  CEILLSENDC:

  la a0,VALUEFLOATD ; A0 = Float Data Offset
  lwc1 f0,0(a0)     ; F0 = Float Data
  ceil.l.s f0 ; Convert To Long Data
  la a0,FDLONG  ; A0 = FDLONG Offset
  sdc1 f0,0(a0) ; FDLONG = Long Data
  PrintString $A010,144,112,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,112,FontBlack,VALUEFLOATD,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,296,112,FontBlack,TEXTFLOATD,8  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,112,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,112,FontBlack,FDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,FDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,CEILLSCHECKD ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,CEILLSPASSD ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,112,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j CEILLSENDD
  nop ; Delay Slot
  CEILLSPASSD:
  PrintString $A010,528,112,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  CEILLSENDD:

  la a0,VALUEFLOATE ; A0 = Float Data Offset
  lwc1 f0,0(a0)     ; F0 = Float Data
  ceil.l.s f0 ; Convert To Long Data
  la a0,FDLONG  ; A0 = FDLONG Offset
  sdc1 f0,0(a0) ; FDLONG = Long Data
  PrintString $A010,144,120,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,120,FontBlack,VALUEFLOATE,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,120,FontBlack,TEXTFLOATE,9  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,120,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,120,FontBlack,FDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,FDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,CEILLSCHECKE ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,CEILLSPASSE ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,120,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j CEILLSENDE
  nop ; Delay Slot
  CEILLSPASSE:
  PrintString $A010,528,120,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  CEILLSENDE:

  la a0,VALUEFLOATF ; A0 = Float Data Offset
  lwc1 f0,0(a0)     ; F0 = Float Data
  ceil.l.s f0 ; Convert To Long Data
  la a0,FDLONG  ; A0 = FDLONG Offset
  sdc1 f0,0(a0) ; FDLONG = Long Data
  PrintString $A010,144,128,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,128,FontBlack,VALUEFLOATF,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,312,128,FontBlack,TEXTFLOATF,6  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,128,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,128,FontBlack,FDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,FDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,CEILLSCHECKF ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,CEILLSPASSF ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,128,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j CEILLSENDF
  nop ; Delay Slot
  CEILLSPASSF:
  PrintString $A010,528,128,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  CEILLSENDF:

  la a0,VALUEFLOATG ; A0 = Float Data Offset
  lwc1 f0,0(a0)     ; F0 = Float Data
  ceil.l.s f0 ; Convert To Long Data
  la a0,FDLONG  ; A0 = FDLONG Offset
  sdc1 f0,0(a0) ; FDLONG = Long Data
  PrintString $A010,144,136,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,136,FontBlack,VALUEFLOATG,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,136,FontBlack,TEXTFLOATG,9  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,136,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,136,FontBlack,FDLONG,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,FDLONG       ; A0 = Long Data Offset
  ld t0,0(a0)        ; T0 = Long Data
  la a0,CEILLSCHECKG ; A0 = Long Check Data Offset
  ld t1,0(a0)        ; T1 = Long Check Data
  beq t0,t1,CEILLSPASSG ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,136,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j CEILLSENDG
  nop ; Delay Slot
  CEILLSPASSG:
  PrintString $A010,528,136,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  CEILLSENDG:


  PrintString $A010,0,144,FontBlack,PAGEBREAK,79 ; Print Text String To VRAM Using Font At X,Y Position


  PrintString $A010,8,152,FontRed,CEILWD,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,VALUEDOUBLEA ; A0 = Double Data Offset
  ldc1 f0,0(a0)      ; F0 = Double Data
  ceil.w.d f0 ; Convert To Word Data
  la a0,FDWORD  ; A0 = FDWORD Offset
  swc1 f0,0(a0) ; FDWORD = Word Data
  PrintString $A010,80,152,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,152,FontBlack,VALUEDOUBLEA,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,344,152,FontBlack,TEXTDOUBLEA,2 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,152,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,152,FontBlack,FDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,FDWORD       ; A0 = Word Data Offset
  lw t0,0(a0)        ; T0 = Word Data
  la a0,CEILWDCHECKA ; A0 = Word Check Data Offset
  lw t1,0(a0)        ; T1 = Word Check Data
  beq t0,t1,CEILWDPASSA ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,152,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j CEILWDENDA
  nop ; Delay Slot
  CEILWDPASSA:
  PrintString $A010,528,152,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  CEILWDENDA:

  la a0,VALUEDOUBLEB ; A0 = Double Data Offset
  ldc1 f0,0(a0)      ; F0 = Double Data
  ceil.w.d f0 ; Convert To Word Data
  la a0,FDWORD  ; A0 = FDWORD Offset
  swc1 f0,0(a0) ; FDWORD = Word Data
  PrintString $A010,80,160,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,160,FontBlack,VALUEDOUBLEB,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,232,160,FontBlack,TEXTDOUBLEB,16 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,160,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,160,FontBlack,FDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,FDWORD       ; A0 = Word Data Offset
  lw t0,0(a0)        ; T0 = Word Data
  la a0,CEILWDCHECKB ; A0 = Word Check Data Offset
  lw t1,0(a0)        ; T1 = Word Check Data
  beq t0,t1,CEILWDPASSB ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,160,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j CEILWDENDB
  nop ; Delay Slot
  CEILWDPASSB:
  PrintString $A010,528,160,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  CEILWDENDB:

  la a0,VALUEDOUBLEC ; A0 = Double Data Offset
  ldc1 f0,0(a0)      ; F0 = Double Data
  ceil.w.d f0 ; Convert To Word Data
  la a0,FDWORD  ; A0 = FDWORD Offset
  swc1 f0,0(a0) ; FDWORD = Word Data
  PrintString $A010,80,168,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,168,FontBlack,VALUEDOUBLEC,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,168,FontBlack,TEXTDOUBLEC,9 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,168,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,168,FontBlack,FDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,FDWORD       ; A0 = Word Data Offset
  lw t0,0(a0)        ; T0 = Word Data
  la a0,CEILWDCHECKC ; A0 = Word Check Data Offset
  lw t1,0(a0)        ; T1 = Word Check Data
  beq t0,t1,CEILWDPASSC ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,168,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j CEILWDENDC
  nop ; Delay Slot
  CEILWDPASSC:
  PrintString $A010,528,168,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  CEILWDENDC:

  la a0,VALUEDOUBLED ; A0 = Double Data Offset
  ldc1 f0,0(a0)      ; F0 = Double Data
  ceil.w.d f0 ; Convert To Word Data
  la a0,FDWORD  ; A0 = FDWORD Offset
  swc1 f0,0(a0) ; FDWORD = Word Data
  PrintString $A010,80,176,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,176,FontBlack,VALUEDOUBLED,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,232,176,FontBlack,TEXTDOUBLED,16 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,176,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,176,FontBlack,FDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,FDWORD       ; A0 = Word Data Offset
  lw t0,0(a0)        ; T0 = Word Data
  la a0,CEILWDCHECKD ; A0 = Word Check Data Offset
  lw t1,0(a0)        ; T1 = Word Check Data
  beq t0,t1,CEILWDPASSD ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,176,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j CEILWDENDD
  nop ; Delay Slot
  CEILWDPASSD:
  PrintString $A010,528,176,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  CEILWDENDD:

  la a0,VALUEDOUBLEE ; A0 = Double Data Offset
  ldc1 f0,0(a0)      ; F0 = Double Data
  ceil.w.d f0 ; Convert To Word Data
  la a0,FDWORD  ; A0 = FDWORD Offset
  swc1 f0,0(a0) ; FDWORD = Word Data
  PrintString $A010,80,184,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,184,FontBlack,VALUEDOUBLEE,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,224,184,FontBlack,TEXTDOUBLEE,17 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,184,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,184,FontBlack,FDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,FDWORD       ; A0 = Word Data Offset
  lw t0,0(a0)        ; T0 = Word Data
  la a0,CEILWDCHECKE ; A0 = Word Check Data Offset
  lw t1,0(a0)        ; T1 = Word Check Data
  beq t0,t1,CEILWDPASSE ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,184,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j CEILWDENDE
  nop ; Delay Slot
  CEILWDPASSE:
  PrintString $A010,528,184,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  CEILWDENDE:

  la a0,VALUEDOUBLEF ; A0 = Double Data Offset
  ldc1 f0,0(a0)      ; F0 = Double Data
  ceil.w.d f0 ; Convert To Word Data
  la a0,FDWORD  ; A0 = FDWORD Offset
  swc1 f0,0(a0) ; FDWORD = Word Data
  PrintString $A010,80,192,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,192,FontBlack,VALUEDOUBLEF,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,280,192,FontBlack,TEXTDOUBLEF,10 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,192,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,192,FontBlack,FDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,FDWORD       ; A0 = Word Data Offset
  lw t0,0(a0)        ; T0 = Word Data
  la a0,CEILWDCHECKF ; A0 = Word Check Data Offset
  lw t1,0(a0)        ; T1 = Word Check Data
  beq t0,t1,CEILWDPASSF ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,192,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j CEILWDENDF
  nop ; Delay Slot
  CEILWDPASSF:
  PrintString $A010,528,192,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  CEILWDENDF:

  la a0,VALUEDOUBLEG ; A0 = Double Data Offset
  ldc1 f0,0(a0)      ; F0 = Double Data
  ceil.w.d f0 ; Convert To Word Data
  la a0,FDWORD  ; A0 = FDWORD Offset
  swc1 f0,0(a0) ; FDWORD = Word Data
  PrintString $A010,80,200,FontBlack,DOLLAR,0       ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,200,FontBlack,VALUEDOUBLEG,7 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,224,200,FontBlack,TEXTDOUBLEG,17 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,200,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,200,FontBlack,FDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,FDWORD       ; A0 = Word Data Offset
  lw t0,0(a0)        ; T0 = Word Data
  la a0,CEILWDCHECKG ; A0 = Word Check Data Offset
  lw t1,0(a0)        ; T1 = Word Check Data
  beq t0,t1,CEILWDPASSG ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,200,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j CEILWDENDG
  nop ; Delay Slot
  CEILWDPASSG:
  PrintString $A010,528,200,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  CEILWDENDG:


  PrintString $A010,8,216,FontRed,CEILWS,7 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,VALUEFLOATA ; A0 = Float Data Offset
  lwc1 f0,0(a0)     ; F0 = Float Data
  ceil.w.s f0 ; Convert To Word Data
  la a0,FDWORD  ; A0 = FDWORD Offset
  swc1 f0,0(a0) ; FDWORD = Word Data
  PrintString $A010,144,216,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,216,FontBlack,VALUEFLOATA,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,344,216,FontBlack,TEXTFLOATA,2  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,216,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,216,FontBlack,FDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,FDWORD       ; A0 = Word Data Offset
  lw t0,0(a0)        ; T0 = Word Data
  la a0,CEILWSCHECKA ; A0 = Word Check Data Offset
  lw t1,0(a0)        ; T1 = Word Check Data
  beq t0,t1,CEILWSPASSA ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,216,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j CEILWSENDA
  nop ; Delay Slot
  CEILWSPASSA:
  PrintString $A010,528,216,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  CEILWSENDA:

  la a0,VALUEFLOATB ; A0 = Float Data Offset
  lwc1 f0,0(a0)     ; F0 = Float Data
  ceil.w.s f0 ; Convert To Word Data
  la a0,FDWORD  ; A0 = FDWORD Offset
  swc1 f0,0(a0) ; FDWORD = Word Data
  PrintString $A010,144,224,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,224,FontBlack,VALUEFLOATB,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,296,224,FontBlack,TEXTFLOATB,8  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,224,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,224,FontBlack,FDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,FDWORD       ; A0 = Word Data Offset
  lw t0,0(a0)        ; T0 = Word Data
  la a0,CEILWSCHECKB ; A0 = Word Check Data Offset
  lw t1,0(a0)        ; T1 = Word Check Data
  beq t0,t1,CEILWSPASSB ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,224,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j CEILWSENDB
  nop ; Delay Slot
  CEILWSPASSB:
  PrintString $A010,528,224,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  CEILWSENDB:

  la a0,VALUEFLOATC ; A0 = Float Data Offset
  lwc1 f0,0(a0)     ; F0 = Float Data
  ceil.w.s f0 ; Convert To Word Data
  la a0,FDWORD  ; A0 = FDWORD Offset
  swc1 f0,0(a0) ; FDWORD = Word Data
  PrintString $A010,144,232,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,232,FontBlack,VALUEFLOATC,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,320,232,FontBlack,TEXTFLOATC,5  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,232,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,232,FontBlack,FDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,FDWORD       ; A0 = Word Data Offset
  lw t0,0(a0)        ; T0 = Word Data
  la a0,CEILWSCHECKC ; A0 = Word Check Data Offset
  lw t1,0(a0)        ; T1 = Word Check Data
  beq t0,t1,CEILWSPASSC ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,232,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j CEILWSENDC
  nop ; Delay Slot
  CEILWSPASSC:
  PrintString $A010,528,232,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  CEILWSENDC:

  la a0,VALUEFLOATD ; A0 = Float Data Offset
  lwc1 f0,0(a0)     ; F0 = Float Data
  ceil.w.s f0 ; Convert To Word Data
  la a0,FDWORD  ; A0 = FDWORD Offset
  swc1 f0,0(a0) ; FDWORD = Word Data
  PrintString $A010,144,240,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,240,FontBlack,VALUEFLOATD,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,296,240,FontBlack,TEXTFLOATD,8  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,240,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,240,FontBlack,FDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,FDWORD       ; A0 = Word Data Offset
  lw t0,0(a0)        ; T0 = Word Data
  la a0,CEILWSCHECKD ; A0 = Word Check Data Offset
  lw t1,0(a0)        ; T1 = Word Check Data
  beq t0,t1,CEILWSPASSD ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,240,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j CEILWSENDD
  nop ; Delay Slot
  CEILWSPASSD:
  PrintString $A010,528,240,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  CEILWSENDD:

  la a0,VALUEFLOATE ; A0 = Float Data Offset
  lwc1 f0,0(a0)     ; F0 = Float Data
  ceil.w.s f0 ; Convert To Word Data
  la a0,FDWORD  ; A0 = FDWORD Offset
  swc1 f0,0(a0) ; FDWORD = Word Data
  PrintString $A010,144,248,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,248,FontBlack,VALUEFLOATE,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,248,FontBlack,TEXTFLOATE,9  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,248,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,248,FontBlack,FDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,FDWORD       ; A0 = Word Data Offset
  lw t0,0(a0)        ; T0 = Word Data
  la a0,CEILWSCHECKE ; A0 = Word Check Data Offset
  lw t1,0(a0)        ; T1 = Word Check Data
  beq t0,t1,CEILWSPASSE ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,248,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j CEILWSENDE
  nop ; Delay Slot
  CEILWSPASSE:
  PrintString $A010,528,248,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  CEILWSENDE:

  la a0,VALUEFLOATF ; A0 = Float Data Offset
  lwc1 f0,0(a0)     ; F0 = Float Data
  ceil.w.s f0 ; Convert To Word Data
  la a0,FDWORD  ; A0 = FDWORD Offset
  swc1 f0,0(a0) ; FDWORD = Word Data
  PrintString $A010,144,256,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,256,FontBlack,VALUEFLOATF,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,312,256,FontBlack,TEXTFLOATF,6  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,256,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,256,FontBlack,FDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,FDWORD       ; A0 = Word Data Offset
  lw t0,0(a0)        ; T0 = Word Data
  la a0,CEILWSCHECKF ; A0 = Word Check Data Offset
  lw t1,0(a0)        ; T1 = Word Check Data
  beq t0,t1,CEILWSPASSF ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,256,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j CEILWSENDF
  nop ; Delay Slot
  CEILWSPASSF:
  PrintString $A010,528,256,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  CEILWSENDF:

  la a0,VALUEFLOATG ; A0 = Float Data Offset
  lwc1 f0,0(a0)     ; F0 = Float Data
  ceil.w.s f0 ; Convert To Word Data
  la a0,FDWORD  ; A0 = FDWORD Offset
  swc1 f0,0(a0) ; FDWORD = Word Data
  PrintString $A010,144,264,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,264,FontBlack,VALUEFLOATG,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,264,FontBlack,TEXTFLOATG,9  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,264,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,264,FontBlack,FDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,FDWORD       ; A0 = Word Data Offset
  lw t0,0(a0)        ; T0 = Word Data
  la a0,CEILWSCHECKG ; A0 = Word Check Data Offset
  lw t1,0(a0)        ; T1 = Word Check Data
  beq t0,t1,CEILWSPASSG ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,264,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j CEILWSENDG
  nop ; Delay Slot
  CEILWSPASSG:
  PrintString $A010,528,264,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  CEILWSENDG:


  PrintString $A010,0,272,FontBlack,PAGEBREAK,79 ; Print Text String To VRAM Using Font At X,Y Position


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

CEILLD: db "CEIL.L.D"
CEILLS: db "CEIL.L.S"

CEILWD: db "CEIL.W.D"
CEILWS: db "CEIL.W.S"

FDHEX: db "FD (Hex)"
FSHEX: db "FS (Hex)"
FDFSDEC: db "FS/FD (Decimal)"
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

CEILLDCHECKA: data $0000000000000000
CEILLDCHECKB: data $0000000000BC614F
CEILLDCHECKC: data $0000000000BC614F
CEILLDCHECKD: data $0000000000BC614F
CEILLDCHECKE: data $FFFFFFFFFF439EB2
CEILLDCHECKF: data $FFFFFFFFFF439EB2
CEILLDCHECKG: data $FFFFFFFFFF439EB2

CEILLSCHECKA: data $0000000000000000
CEILLSCHECKB: data $00000000000004D3
CEILLSCHECKC: data $00000000000004D3
CEILLSCHECKD: data $00000000000004D3
CEILLSCHECKE: data $FFFFFFFFFFFFFB2E
CEILLSCHECKF: data $FFFFFFFFFFFFFB2E
CEILLSCHECKG: data $FFFFFFFFFFFFFB2E

FDLONG: data 0

VALUEFLOATA: IEEE32 0.0
VALUEFLOATB: IEEE32 1234.6789
VALUEFLOATC: IEEE32 1234.5
VALUEFLOATD: IEEE32 1234.1234
VALUEFLOATE: IEEE32 -1234.1234
VALUEFLOATF: IEEE32 -1234.5
VALUEFLOATG: IEEE32 -1234.6789

CEILWDCHECKA: dw $00000000
CEILWDCHECKB: dw $00BC614F
CEILWDCHECKC: dw $00BC614F
CEILWDCHECKD: dw $00BC614F
CEILWDCHECKE: dw $FF439EB2
CEILWDCHECKF: dw $FF439EB2
CEILWDCHECKG: dw $FF439EB2

CEILWSCHECKA: dw $00000000
CEILWSCHECKB: dw $000004D3
CEILWSCHECKC: dw $000004D3
CEILWSCHECKD: dw $000004D3
CEILWSCHECKE: dw $FFFFFB2E
CEILWSCHECKF: dw $FFFFFB2E
CEILWSCHECKG: dw $FFFFFB2E

FDWORD: dw 0

FontBlack: incbin FontBlack8x8.bin
FontGreen: incbin FontGreen8x8.bin
FontRed: incbin FontRed8x8.bin