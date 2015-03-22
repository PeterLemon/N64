; N64 'Bare Metal' CPU Signed Word Multiplication Test Demo by krom (Peter Lemon):
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


  PrintString $A010,88,8,FontRed,RSRTHEX,10 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,232,8,FontRed,RSRTDEC,14 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,384,8,FontRed,LOHIHEX,10 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,528,8,FontRed,TEST,10 ; Print Text String To VRAM Using Font At X,Y Position


  PrintString $A010,0,16,FontBlack,PAGEBREAK,79 ; Print Text String To VRAM Using Font At X,Y Position


  PrintString $A010,8,24,FontRed,MULT,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,VALUEWORDA ; A0 = Word Data Offset
  lw t0,0(a0)      ; T0 = Word Data
  la a0,VALUEWORDB ; A0 = Word Data Offset
  lw t1,0(a0)      ; T1 = Word Data
  mult t0,t1 ; HI/LO = Test Word Data
  mflo t0 ; T0 = LO
  la a0,LOWORD ; A0 = LOWORD Offset
  sw t0,0(a0)  ; LOWORD = Word Data
  mfhi t0 ; T0 = HI
  la a0,HIWORD ; A0 = HIWORD Offset
  sw t0,0(a0)  ; HIWORD = Word Data
  PrintString $A010,144,24,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,24,FontBlack,VALUEWORDA,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,24,FontBlack,TEXTWORDA,0  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,24,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,24,FontBlack,LOWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,144,32,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,32,FontBlack,VALUEWORDB,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,296,32,FontBlack,TEXTWORDB,8  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,32,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,32,FontBlack,HIWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,LOWORD       ; A0 = Word Data Offset
  lw t0,0(a0)        ; T0 = Word Data
  la a0,MULTLOCHECKA ; A0 = Word Check Data Offset
  lw t1,0(a0)        ; T1 = Word Check Data
  beq t0,t1,MULTLOPASSA ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,24,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j MULTENDA
  nop ; Delay Slot
  MULTLOPASSA:
  PrintString $A010,528,24,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,HIWORD       ; A0 = Word Data Offset
  lw t0,0(a0)        ; T0 = Word Data
  la a0,MULTHICHECKA ; A0 = Word Check Data Offset
  lw t1,0(a0)        ; T1 = Word Check Data
  beq t0,t1,MULTHIPASSA ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,32,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j MULTENDA
  nop ; Delay Slot
  MULTHIPASSA:
  PrintString $A010,528,32,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  MULTENDA:

  la a0,VALUEWORDB ; A0 = Word Data Offset
  lw t0,0(a0)      ; T0 = Word Data
  la a0,VALUEWORDC ; A0 = Word Data Offset
  lw t1,0(a0)      ; T1 = Word Data
  mult t0,t1 ; HI/LO = Test Word Data
  mflo t0 ; T0 = LO
  la a0,LOWORD ; A0 = LOWORD Offset
  sw t0,0(a0)  ; LOWORD = Word Data
  mfhi t0 ; T0 = HI
  la a0,HIWORD ; A0 = HIWORD Offset
  sw t0,0(a0)  ; HIWORD = Word Data
  PrintString $A010,144,48,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,48,FontBlack,VALUEWORDB,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,296,48,FontBlack,TEXTWORDB,8  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,48,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,48,FontBlack,LOWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,144,56,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,56,FontBlack,VALUEWORDC,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,320,56,FontBlack,TEXTWORDC,5  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,56,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,56,FontBlack,HIWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,LOWORD       ; A0 = Word Data Offset
  lw t0,0(a0)        ; T0 = Word Data
  la a0,MULTLOCHECKB ; A0 = Word Check Data Offset
  lw t1,0(a0)        ; T1 = Word Check Data
  beq t0,t1,MULTLOPASSB ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,48,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j MULTENDB
  nop ; Delay Slot
  MULTLOPASSB:
  PrintString $A010,528,48,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,HIWORD       ; A0 = Word Data Offset
  lw t0,0(a0)        ; T0 = Word Data
  la a0,MULTHICHECKB ; A0 = Word Check Data Offset
  lw t1,0(a0)        ; T1 = Word Check Data
  beq t0,t1,MULTHIPASSB ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,56,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j MULTENDB
  nop ; Delay Slot
  MULTHIPASSB:
  PrintString $A010,528,56,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  MULTENDB:

  la a0,VALUEWORDC ; A0 = Word Data Offset
  lw t0,0(a0)      ; T0 = Word Data
  la a0,VALUEWORDD ; A0 = Word Data Offset
  lw t1,0(a0)      ; T1 = Word Data
  mult t0,t1 ; HI/LO = Test Word Data
  mflo t0 ; T0 = LO
  la a0,LOWORD ; A0 = LOWORD Offset
  sw t0,0(a0)  ; LOWORD = Word Data
  mfhi t0 ; T0 = HI
  la a0,HIWORD ; A0 = HIWORD Offset
  sw t0,0(a0)  ; HIWORD = Word Data
  PrintString $A010,144,72,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,72,FontBlack,VALUEWORDC,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,320,72,FontBlack,TEXTWORDC,5  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,72,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,72,FontBlack,LOWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,144,80,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,80,FontBlack,VALUEWORDD,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,296,80,FontBlack,TEXTWORDD,8  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,80,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,80,FontBlack,HIWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,LOWORD       ; A0 = Word Data Offset
  lw t0,0(a0)        ; T0 = Word Data
  la a0,MULTLOCHECKC ; A0 = Word Check Data Offset
  lw t1,0(a0)        ; T1 = Word Check Data
  beq t0,t1,MULTLOPASSC ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,72,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j MULTENDC
  nop ; Delay Slot
  MULTLOPASSC:
  PrintString $A010,528,72,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,HIWORD       ; A0 = Word Data Offset
  lw t0,0(a0)        ; T0 = Word Data
  la a0,MULTHICHECKC ; A0 = Word Check Data Offset
  lw t1,0(a0)        ; T1 = Word Check Data
  beq t0,t1,MULTHIPASSC ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,80,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j MULTENDC
  nop ; Delay Slot
  MULTHIPASSC:
  PrintString $A010,528,80,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  MULTENDC:

  la a0,VALUEWORDD ; A0 = Word Data Offset
  lw t0,0(a0)      ; T0 = Word Data
  la a0,VALUEWORDE ; A0 = Word Data Offset
  lw t1,0(a0)      ; T1 = Word Data
  mult t0,t1 ; HI/LO = Test Word Data
  mflo t0 ; T0 = LO
  la a0,LOWORD ; A0 = LOWORD Offset
  sw t0,0(a0)  ; LOWORD = Word Data
  mfhi t0 ; T0 = HI
  la a0,HIWORD ; A0 = HIWORD Offset
  sw t0,0(a0)  ; HIWORD = Word Data
  PrintString $A010,144,96,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,96,FontBlack,VALUEWORDD,3  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,296,96,FontBlack,TEXTWORDD,8   ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,96,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,96,FontBlack,LOWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,144,104,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,104,FontBlack,VALUEWORDE,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,104,FontBlack,TEXTWORDE,9  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,104,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,104,FontBlack,HIWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,LOWORD       ; A0 = Word Data Offset
  lw t0,0(a0)        ; T0 = Word Data
  la a0,MULTLOCHECKD ; A0 = Word Check Data Offset
  lw t1,0(a0)        ; T1 = Word Check Data
  beq t0,t1,MULTLOPASSD ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,96,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j MULTENDD
  nop ; Delay Slot
  MULTLOPASSD:
  PrintString $A010,528,96,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,HIWORD       ; A0 = Word Data Offset
  lw t0,0(a0)        ; T0 = Word Data
  la a0,MULTHICHECKD ; A0 = Word Check Data Offset
  lw t1,0(a0)        ; T1 = Word Check Data
  beq t0,t1,MULTHIPASSD ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,104,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j MULTENDD
  nop ; Delay Slot
  MULTHIPASSD:
  PrintString $A010,528,104,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  MULTENDD:

  la a0,VALUEWORDE ; A0 = Word Data Offset
  lw t0,0(a0)      ; T0 = Word Data
  la a0,VALUEWORDF ; A0 = Word Data Offset
  lw t1,0(a0)      ; T1 = Word Data
  mult t0,t1 ; HI/LO = Test Word Data
  mflo t0 ; T0 = LO
  la a0,LOWORD ; A0 = LOWORD Offset
  sw t0,0(a0)  ; LOWORD = Word Data
  mfhi t0 ; T0 = HI
  la a0,HIWORD ; A0 = HIWORD Offset
  sw t0,0(a0)  ; HIWORD = Word Data
  PrintString $A010,144,120,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,120,FontBlack,VALUEWORDE,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,120,FontBlack,TEXTWORDE,9  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,120,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,120,FontBlack,LOWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,144,128,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,128,FontBlack,VALUEWORDF,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,312,128,FontBlack,TEXTWORDF,6  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,128,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,128,FontBlack,HIWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,LOWORD       ; A0 = Word Data Offset
  lw t0,0(a0)        ; T0 = Word Data
  la a0,MULTLOCHECKE ; A0 = Word Check Data Offset
  lw t1,0(a0)        ; T1 = Word Check Data
  beq t0,t1,MULTLOPASSE ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,120,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j MULTENDE
  nop ; Delay Slot
  MULTLOPASSE:
  PrintString $A010,528,120,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,HIWORD       ; A0 = Word Data Offset
  lw t0,0(a0)        ; T0 = Word Data
  la a0,MULTHICHECKE ; A0 = Word Check Data Offset
  lw t1,0(a0)        ; T1 = Word Check Data
  beq t0,t1,MULTHIPASSE ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,128,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j MULTENDE
  nop ; Delay Slot
  MULTHIPASSE:
  PrintString $A010,528,128,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  MULTENDE:

  la a0,VALUEWORDF ; A0 = Word Data Offset
  lw t0,0(a0)      ; T0 = Word Data
  la a0,VALUEWORDG ; A0 = Word Data Offset
  lw t1,0(a0)      ; T1 = Word Data
  mult t0,t1 ; HI/LO = Test Word Data
  mflo t0 ; T0 = LO
  la a0,LOWORD ; A0 = LOWORD Offset
  sw t0,0(a0)  ; LOWORD = Word Data
  mfhi t0 ; T0 = HI
  la a0,HIWORD ; A0 = HIWORD Offset
  sw t0,0(a0)  ; HIWORD = Word Data
  PrintString $A010,144,144,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,144,FontBlack,VALUEWORDF,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,312,144,FontBlack,TEXTWORDF,6  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,144,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,144,FontBlack,LOWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,144,152,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,152,FontBlack,VALUEWORDG,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,152,FontBlack,TEXTWORDG,9  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,152,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,152,FontBlack,HIWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,LOWORD       ; A0 = Word Data Offset
  lw t0,0(a0)        ; T0 = Word Data
  la a0,MULTLOCHECKF ; A0 = Word Check Data Offset
  lw t1,0(a0)        ; T1 = Word Check Data
  beq t0,t1,MULTLOPASSF ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,144,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j MULTENDF
  nop ; Delay Slot
  MULTLOPASSF:
  PrintString $A010,528,144,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,HIWORD       ; A0 = Word Data Offset
  lw t0,0(a0)        ; T0 = Word Data
  la a0,MULTHICHECKF ; A0 = Word Check Data Offset
  lw t1,0(a0)        ; T1 = Word Check Data
  beq t0,t1,MULTHIPASSF ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,152,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j MULTENDF
  nop ; Delay Slot
  MULTHIPASSF:
  PrintString $A010,528,152,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  MULTENDF:

  la a0,VALUEWORDA ; A0 = Word Data Offset
  lw t0,0(a0)      ; T0 = Word Data
  la a0,VALUEWORDG ; A0 = Word Data Offset
  lw t1,0(a0)      ; T1 = Word Data
  mult t0,t1 ; HI/LO = Test Word Data
  mflo t0 ; T0 = LO
  la a0,LOWORD ; A0 = LOWORD Offset
  sw t0,0(a0)  ; LOWORD = Word Data
  mfhi t0 ; T0 = HI
  la a0,HIWORD ; A0 = HIWORD Offset
  sw t0,0(a0)  ; HIWORD = Word Data
  PrintString $A010,144,168,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,168,FontBlack,VALUEWORDA,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,168,FontBlack,TEXTWORDA,0  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,168,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,168,FontBlack,LOWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,144,176,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,176,FontBlack,VALUEWORDG,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,176,FontBlack,TEXTWORDG,9  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,176,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,448,176,FontBlack,HIWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,LOWORD       ; A0 = Word Data Offset
  lw t0,0(a0)        ; T0 = Word Data
  la a0,MULTLOCHECKG ; A0 = Word Check Data Offset
  lw t1,0(a0)        ; T1 = Word Check Data
  beq t0,t1,MULTLOPASSG ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,168,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j MULTENDG
  nop ; Delay Slot
  MULTLOPASSG:
  PrintString $A010,528,168,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,HIWORD       ; A0 = Word Data Offset
  lw t0,0(a0)        ; T0 = Word Data
  la a0,MULTHICHECKG ; A0 = Word Check Data Offset
  lw t1,0(a0)        ; T1 = Word Check Data
  beq t0,t1,MULTHIPASSG ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,176,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j MULTENDG
  nop ; Delay Slot
  MULTHIPASSG:
  PrintString $A010,528,176,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  MULTENDG:


  PrintString $A010,0,184,FontBlack,PAGEBREAK,79 ; Print Text String To VRAM Using Font At X,Y Position


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

MULT: db "MULT"

LOHIHEX: db "LO/HI (Hex)"
RSRTHEX: db "RS/RT (Hex)"
RSRTDEC: db "RS/RT (Decimal)"
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

  align 8 ; Align 64-Bit
VALUEWORDA: dw 0
VALUEWORDB: dw 123456789
VALUEWORDC: dw 123456
VALUEWORDD: dw 123451234
VALUEWORDE: dw -123451234
VALUEWORDF: dw -123456
VALUEWORDG: dw -123456789

MULTLOCHECKA: dw $00000000
MULTHICHECKA: dw $00000000
MULTLOCHECKB: dw $AF14CF40
MULTHICHECKB: dw $00000DDC
MULTLOCHECKC: dw $86345C80
MULTHICHECKC: dw $00000DDC
MULTLOCHECKD: dw $C0F6BE7C
MULTHICHECKD: dw $FFC9DB1C
MULTLOCHECKE: dw $86345C80
MULTHICHECKE: dw $00000DDC
MULTLOCHECKF: dw $AF14CF40
MULTHICHECKF: dw $00000DDC
MULTLOCHECKG: dw $00000000
MULTHICHECKG: dw $00000000

LOWORD: dw 0
HIWORD: dw 0

FontBlack: incbin FontBlack8x8.bin
FontGreen: incbin FontGreen8x8.bin
FontRed: incbin FontRed8x8.bin