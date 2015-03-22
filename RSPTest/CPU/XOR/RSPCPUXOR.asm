; N64 'Bare Metal' RSP CPU Bitwise Logical EXCLUSIVE OR Test Demo by krom (Peter Lemon):
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
  include LIB\N64_RSP.INC ; Include RSP Macros
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
  PrintString $A010,384,8,FontRed,RDHEX,7 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,528,8,FontRed,TEST,10 ; Print Text String To VRAM Using Font At X,Y Position


  PrintString $A010,0,16,FontBlack,PAGEBREAK,79 ; Print Text String To VRAM Using Font At X,Y Position


  ; Load RSP Code To IMEM
  DMASPRD RSPXORCode, RSPXORCodeEND, SP_IMEM ; DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  ; Load RSP Data To DMEM
  lui a0,SP_MEM_BASE ; A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORDA ; A1 = Word Data Offset
  lw t0,0(a1)      ; T0 = Word Data
  sw t0,0(a0)      ; Store Word Data To DMEM
  la a1,VALUEWORDB ; A1 = Word Data Offset
  lw t0,0(a1)      ; T0 = Word Data
  sw t0,4(a0)      ; Store Word Data To DMEM

  ; Set RSP Program Counter
  lui a0,SP_PC_BASE ; A0 = SP PC Base Register ($A4080000)
  li t0,$0000 ; T0 = RSP Program Counter Set To Zero (Start Of RSP Code)
  sw t0,SP_PC(a0) ; Store RSP Program Counter To SP PC Register ($A4080000)

  ; Set RSP Status (Start Execution)
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB ; T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) ; Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString $A010,8,24,FontRed,XOR,2 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,144,24,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,24,FontBlack,VALUEWORDA,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,24,FontBlack,TEXTWORDA,0  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,144,32,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,32,FontBlack,VALUEWORDB,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,296,32,FontBlack,TEXTWORDB,8  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,32,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE ; A0 = Test Word Data Offset
  lw t0,0(a0) ; T0 = Test Word Data
  la a0,RDWORD ; A0 = RDWORD Offset
  sw t0,0(a0)  ; RDWORD = Word Data
  PrintValue  $A010,448,32,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD    ; A0 = Word Data Offset
  lw t0,0(a0)     ; T0 = Word Data
  la a0,XORCHECKA ; A0 = Word Check Data Offset
  lw t1,0(a0)     ; T1 = Word Check Data
  beq t0,t1,XORPASSA ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,32,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j XORENDA
  nop ; Delay Slot
  XORPASSA:
  PrintString $A010,528,32,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  XORENDA:

  ; Load RSP Data To DMEM
  lui a0,SP_MEM_BASE ; A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORDB ; A1 = Word Data Offset
  lw t0,0(a1)      ; T0 = Word Data
  sw t0,0(a0)      ; Store Word Data To DMEM
  la a1,VALUEWORDC ; A1 = Word Data Offset
  lw t0,0(a1)      ; T0 = Word Data
  sw t0,4(a0)      ; Store Word Data To DMEM

  ; Set RSP Status (Start Execution)
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB ; T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) ; Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString $A010,144,48,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,48,FontBlack,VALUEWORDB,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,296,48,FontBlack,TEXTWORDB,8  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,144,56,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,56,FontBlack,VALUEWORDC,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,320,56,FontBlack,TEXTWORDC,5  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,56,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE ; A0 = Test Word Data Offset
  lw t0,0(a0) ; T0 = Test Word Data
  la a0,RDWORD ; A0 = RDWORD Offset
  sw t0,0(a0)  ; RDWORD = Word Data
  PrintValue  $A010,448,56,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD    ; A0 = Word Data Offset
  lw t0,0(a0)     ; T0 = Word Data
  la a0,XORCHECKB ; A0 = Word Check Data Offset
  lw t1,0(a0)     ; T1 = Word Check Data
  beq t0,t1,XORPASSB ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,56,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j XORENDB
  nop ; Delay Slot
  XORPASSB:
  PrintString $A010,528,56,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  XORENDB:

  ; Load RSP Data To DMEM
  lui a0,SP_MEM_BASE ; A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORDC ; A1 = Word Data Offset
  lw t0,0(a1)      ; T0 = Word Data
  sw t0,0(a0)      ; Store Word Data To DMEM
  la a1,VALUEWORDD ; A1 = Word Data Offset
  lw t0,0(a1)      ; T0 = Word Data
  sw t0,4(a0)      ; Store Word Data To DMEM

  ; Set RSP Status (Start Execution)
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB ; T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) ; Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString $A010,144,72,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,72,FontBlack,VALUEWORDC,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,320,72,FontBlack,TEXTWORDC,5  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,144,80,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,80,FontBlack,VALUEWORDD,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,296,80,FontBlack,TEXTWORDD,8  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,80,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE ; A0 = Test Word Data Offset
  lw t0,0(a0) ; T0 = Test Word Data
  la a0,RDWORD ; A0 = RDWORD Offset
  sw t0,0(a0)  ; RDWORD = Word Data
  PrintValue  $A010,448,80,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD    ; A0 = Word Data Offset
  lw t0,0(a0)     ; T0 = Word Data
  la a0,XORCHECKC ; A0 = Word Check Data Offset
  lw t1,0(a0)     ; T1 = Word Check Data
  beq t0,t1,XORPASSC ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,80,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j XORENDC
  nop ; Delay Slot
  XORPASSC:
  PrintString $A010,528,80,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  XORENDC:

  ; Load RSP Data To DMEM
  lui a0,SP_MEM_BASE ; A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORDD ; A1 = Word Data Offset
  lw t0,0(a1)      ; T0 = Word Data
  sw t0,0(a0)      ; Store Word Data To DMEM
  la a1,VALUEWORDE ; A1 = Word Data Offset
  lw t0,0(a1)      ; T0 = Word Data
  sw t0,4(a0)      ; Store Word Data To DMEM

  ; Set RSP Status (Start Execution)
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB ; T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) ; Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString $A010,144,96,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,96,FontBlack,VALUEWORDD,3  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,296,96,FontBlack,TEXTWORDD,8   ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,144,104,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,104,FontBlack,VALUEWORDE,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,104,FontBlack,TEXTWORDE,9  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,104,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE ; A0 = Test Word Data Offset
  lw t0,0(a0) ; T0 = Test Word Data
  la a0,RDWORD ; A0 = RDWORD Offset
  sw t0,0(a0)  ; RDWORD = Word Data
  PrintValue  $A010,448,104,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD    ; A0 = Word Data Offset
  lw t0,0(a0)     ; T0 = Word Data
  la a0,XORCHECKD ; A0 = Word Check Data Offset
  lw t1,0(a0)     ; T1 = Word Check Data
  beq t0,t1,XORPASSD ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,104,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j XORENDD
  nop ; Delay Slot
  XORPASSD:
  PrintString $A010,528,104,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  XORENDD:

  ; Load RSP Data To DMEM
  lui a0,SP_MEM_BASE ; A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORDE ; A1 = Word Data Offset
  lw t0,0(a1)      ; T0 = Word Data
  sw t0,0(a0)      ; Store Word Data To DMEM
  la a1,VALUEWORDF ; A1 = Word Data Offset
  lw t0,0(a1)      ; T0 = Word Data
  sw t0,4(a0)      ; Store Word Data To DMEM

  ; Set RSP Status (Start Execution)
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB ; T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) ; Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString $A010,144,120,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,120,FontBlack,VALUEWORDE,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,120,FontBlack,TEXTWORDE,9  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,144,128,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,128,FontBlack,VALUEWORDF,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,312,128,FontBlack,TEXTWORDF,6  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,128,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE ; A0 = Test Word Data Offset
  lw t0,0(a0) ; T0 = Test Word Data
  la a0,RDWORD ; A0 = RDWORD Offset
  sw t0,0(a0)  ; RDWORD = Word Data
  PrintValue  $A010,448,128,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD    ; A0 = Word Data Offset
  lw t0,0(a0)     ; T0 = Word Data
  la a0,XORCHECKE ; A0 = Word Check Data Offset
  lw t1,0(a0)     ; T1 = Word Check Data
  beq t0,t1,XORPASSE ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,128,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j XORENDE
  nop ; Delay Slot
  XORPASSE:
  PrintString $A010,528,128,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  XORENDE:

  ; Load RSP Data To DMEM
  lui a0,SP_MEM_BASE ; A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORDF ; A1 = Word Data Offset
  lw t0,0(a1)      ; T0 = Word Data
  sw t0,0(a0)      ; Store Word Data To DMEM
  la a1,VALUEWORDG ; A1 = Word Data Offset
  lw t0,0(a1)      ; T0 = Word Data
  sw t0,4(a0)      ; Store Word Data To DMEM

  ; Set RSP Status (Start Execution)
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB ; T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) ; Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString $A010,144,144,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,144,FontBlack,VALUEWORDF,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,312,144,FontBlack,TEXTWORDF,6  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,144,152,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,152,FontBlack,VALUEWORDG,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,152,FontBlack,TEXTWORDG,9  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,152,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE ; A0 = Test Word Data Offset
  lw t0,0(a0) ; T0 = Test Word Data
  la a0,RDWORD ; A0 = RDWORD Offset
  sw t0,0(a0)  ; RDWORD = Word Data
  PrintValue  $A010,448,152,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD    ; A0 = Word Data Offset
  lw t0,0(a0)     ; T0 = Word Data
  la a0,XORCHECKF ; A0 = Word Check Data Offset
  lw t1,0(a0)     ; T1 = Word Check Data
  beq t0,t1,XORPASSF ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,152,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j XORENDF
  nop ; Delay Slot
  XORPASSF:
  PrintString $A010,528,152,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  XORENDF:

  ; Load RSP Data To DMEM
  lui a0,SP_MEM_BASE ; A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORDA ; A1 = Word Data Offset
  lw t0,0(a1)      ; T0 = Word Data
  sw t0,0(a0)      ; Store Word Data To DMEM
  la a1,VALUEWORDG ; A1 = Word Data Offset
  lw t0,0(a1)      ; T0 = Word Data
  sw t0,4(a0)      ; Store Word Data To DMEM

  ; Set RSP Status (Start Execution)
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB ; T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) ; Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString $A010,144,168,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,168,FontBlack,VALUEWORDA,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,168,FontBlack,TEXTWORDA,0  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,144,176,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,176,FontBlack,VALUEWORDG,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,176,FontBlack,TEXTWORDG,9  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,176,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE ; A0 = Test Word Data Offset
  lw t0,0(a0) ; T0 = Test Word Data
  la a0,RDWORD ; A0 = RDWORD Offset
  sw t0,0(a0)  ; RDWORD = Word Data
  PrintValue  $A010,448,176,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD    ; A0 = Word Data Offset
  lw t0,0(a0)     ; T0 = Word Data
  la a0,XORCHECKG ; A0 = Word Check Data Offset
  lw t1,0(a0)     ; T1 = Word Check Data
  beq t0,t1,XORPASSG ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,176,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j XORENDG
  nop ; Delay Slot
  XORPASSG:
  PrintString $A010,528,176,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  XORENDG:


  ; Load RSP Code To IMEM
  DMASPRD RSPXORICodeA, RSPXORICodeAEND, SP_IMEM ; DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  ; Load RSP Data To DMEM
  lui a0,SP_MEM_BASE ; A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORDA ; A1 = Word Data Offset
  lw t0,0(a1) ; T0 = Word Data
  sw t0,0(a0) ; Store Word Data To DMEM

  ; Set RSP Status (Start Execution)
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB ; T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) ; Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString $A010,8,192,FontRed,XORI,3 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,144,192,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,192,FontBlack,VALUEWORDA,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,192,FontBlack,TEXTWORDA,0  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,144,200,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,200,FontBlack,IWORDB,3     ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,328,200,FontBlack,TEXTIWORDB,4 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,200,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE ; A0 = Test Word Data Offset
  lw t0,0(a0) ; T0 = Test Word Data
  la a0,RDWORD ; A0 = RDWORD Offset
  sw t0,0(a0)  ; RDWORD = Word Data
  PrintValue  $A010,448,200,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     ; A0 = Word Data Offset
  lw t0,0(a0)      ; T0 = Word Data
  la a0,XORICHECKA ; A0 = Word Check Data Offset
  lw t1,0(a0)      ; T1 = Word Check Data
  beq t0,t1,XORIPASSA ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,200,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j XORIENDA
  nop ; Delay Slot
  XORIPASSA:
  PrintString $A010,528,200,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  XORIENDA:

  ; Load RSP Code To IMEM
  DMASPRD RSPXORICodeB, RSPXORICodeBEND, SP_IMEM ; DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  ; Load RSP Data To DMEM
  lui a0,SP_MEM_BASE ; A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORDB ; A1 = Word Data Offset
  lw t0,0(a1) ; T0 = Word Data
  sw t0,0(a0) ; Store Word Data To DMEM

  ; Set RSP Status (Start Execution)
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB ; T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) ; Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString $A010,144,216,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,216,FontBlack,VALUEWORDB,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,296,216,FontBlack,TEXTWORDB,8  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,144,224,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,224,FontBlack,IWORDC,3     ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,336,224,FontBlack,TEXTIWORDC,3 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,224,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE ; A0 = Test Word Data Offset
  lw t0,0(a0) ; T0 = Test Word Data
  la a0,RDWORD ; A0 = RDWORD Offset
  sw t0,0(a0)  ; RDWORD = Word Data
  PrintValue  $A010,448,224,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     ; A0 = Word Data Offset
  lw t0,0(a0)      ; T0 = Word Data
  la a0,XORICHECKB ; A0 = Word Check Data Offset
  lw t1,0(a0)      ; T1 = Word Check Data
  beq t0,t1,XORIPASSB ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,224,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j XORIENDB
  nop ; Delay Slot
  XORIPASSB:
  PrintString $A010,528,224,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  XORIENDB:

  ; Load RSP Code To IMEM
  DMASPRD RSPXORICodeC, RSPXORICodeCEND, SP_IMEM ; DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  ; Load RSP Data To DMEM
  lui a0,SP_MEM_BASE ; A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORDC ; A1 = Word Data Offset
  lw t0,0(a1) ; T0 = Word Data
  sw t0,0(a0) ; Store Word Data To DMEM

  ; Set RSP Status (Start Execution)
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB ; T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) ; Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString $A010,144,240,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,240,FontBlack,VALUEWORDC,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,320,240,FontBlack,TEXTWORDC,5  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,144,248,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,248,FontBlack,IWORDD,3     ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,328,248,FontBlack,TEXTIWORDD,4 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,248,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE ; A0 = Test Word Data Offset
  lw t0,0(a0) ; T0 = Test Word Data
  la a0,RDWORD ; A0 = RDWORD Offset
  sw t0,0(a0)  ; RDWORD = Word Data
  PrintValue  $A010,448,248,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     ; A0 = Word Data Offset
  lw t0,0(a0)      ; T0 = Word Data
  la a0,XORICHECKC ; A0 = Word Check Data Offset
  lw t1,0(a0)      ; T1 = Word Check Data
  beq t0,t1,XORIPASSC ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,248,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j XORIENDC
  nop ; Delay Slot
  XORIPASSC:
  PrintString $A010,528,248,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  XORIENDC:

  ; Load RSP Code To IMEM
  DMASPRD RSPXORICodeD, RSPXORICodeDEND, SP_IMEM ; DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  ; Load RSP Data To DMEM
  lui a0,SP_MEM_BASE ; A0 = SP Memory Base Offset (DMEM)
  la a1,IWORDD ; A1 = Word Data Offset
  lw t0,0(a1) ; T0 = Word Data
  sw t0,0(a0) ; Store Word Data To DMEM

  ; Set RSP Status (Start Execution)
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB ; T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) ; Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString $A010,144,264,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,264,FontBlack,IWORDD,3     ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,328,264,FontBlack,TEXTIWORDD,4 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,144,272,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,272,FontBlack,IWORDE,3     ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,328,272,FontBlack,TEXTIWORDE,4 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,272,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE ; A0 = Test Word Data Offset
  lw t0,0(a0) ; T0 = Test Word Data
  la a0,RDWORD ; A0 = RDWORD Offset
  sw t0,0(a0)  ; RDWORD = Word Data
  PrintValue  $A010,448,272,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     ; A0 = Word Data Offset
  lw t0,0(a0)      ; T0 = Word Data
  la a0,XORICHECKD ; A0 = Word Check Data Offset
  lw t1,0(a0)      ; T1 = Word Check Data
  beq t0,t1,XORIPASSD ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,272,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j XORIENDD
  nop ; Delay Slot
  XORIPASSD:
  PrintString $A010,528,272,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  XORIENDD:

  ; Load RSP Code To IMEM
  DMASPRD RSPXORICodeE, RSPXORICodeEEND, SP_IMEM ; DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  ; Load RSP Data To DMEM
  lui a0,SP_MEM_BASE ; A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORDE ; A1 = Word Data Offset
  lw t0,0(a1) ; T0 = Word Data
  sw t0,0(a0) ; Store Word Data To DMEM

  ; Set RSP Status (Start Execution)
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB ; T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) ; Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString $A010,144,288,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,288,FontBlack,VALUEWORDE,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,288,288,FontBlack,TEXTWORDE,9  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,144,296,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,296,FontBlack,IWORDF,3     ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,336,296,FontBlack,TEXTIWORDF,3 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,296,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE ; A0 = Test Word Data Offset
  lw t0,0(a0) ; T0 = Test Word Data
  la a0,RDWORD ; A0 = RDWORD Offset
  sw t0,0(a0)  ; RDWORD = Word Data
  PrintValue  $A010,448,296,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     ; A0 = Word Data Offset
  lw t0,0(a0)      ; T0 = Word Data
  la a0,XORICHECKE ; A0 = Word Check Data Offset
  lw t1,0(a0)      ; T1 = Word Check Data
  beq t0,t1,XORIPASSE ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,296,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j XORIENDE
  nop ; Delay Slot
  XORIPASSE:
  PrintString $A010,528,296,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  XORIENDE:

  ; Load RSP Code To IMEM
  DMASPRD RSPXORICodeF, RSPXORICodeFEND, SP_IMEM ; DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  ; Load RSP Data To DMEM
  lui a0,SP_MEM_BASE ; A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORDF ; A1 = Word Data Offset
  lw t0,0(a1) ; T0 = Word Data
  sw t0,0(a0) ; Store Word Data To DMEM

  ; Set RSP Status (Start Execution)
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB ; T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) ; Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString $A010,144,312,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,312,FontBlack,VALUEWORDF,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,312,312,FontBlack,TEXTWORDF,6  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,144,320,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,320,FontBlack,IWORDG,3     ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,328,320,FontBlack,TEXTIWORDG,4 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,320,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE ; A0 = Test Word Data Offset
  lw t0,0(a0) ; T0 = Test Word Data
  la a0,RDWORD ; A0 = RDWORD Offset
  sw t0,0(a0)  ; RDWORD = Word Data
  PrintValue  $A010,448,320,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     ; A0 = Word Data Offset
  lw t0,0(a0)      ; T0 = Word Data
  la a0,XORICHECKF ; A0 = Word Check Data Offset
  lw t1,0(a0)      ; T1 = Word Check Data
  beq t0,t1,XORIPASSF ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,320,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j XORIENDF
  nop ; Delay Slot
  XORIPASSF:
  PrintString $A010,528,320,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  XORIENDF:

  ; Load RSP Data To DMEM
  lui a0,SP_MEM_BASE ; A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORDA ; A1 = Word Data Offset
  lw t0,0(a1) ; T0 = Word Data
  sw t0,0(a0) ; Store Word Data To DMEM

  ; Set RSP Status (Start Execution)
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB ; T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) ; Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString $A010,144,336,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,336,FontBlack,VALUEWORDA,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,336,FontBlack,TEXTWORDA,0  ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,144,344,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,152,344,FontBlack,IWORDG,3     ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,328,344,FontBlack,TEXTIWORDG,4 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,344,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE ; A0 = Test Word Data Offset
  lw t0,0(a0) ; T0 = Test Word Data
  la a0,RDWORD ; A0 = RDWORD Offset
  sw t0,0(a0)  ; RDWORD = Word Data
  PrintValue  $A010,448,344,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     ; A0 = Word Data Offset
  lw t0,0(a0)      ; T0 = Word Data
  la a0,XORICHECKG ; A0 = Word Check Data Offset
  lw t1,0(a0)      ; T1 = Word Check Data
  beq t0,t1,XORIPASSG ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,344,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j XORIENDG
  nop ; Delay Slot
  XORIPASSG:
  PrintString $A010,528,344,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  XORIENDG:


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

XOR: db "XOR"
XORI: db "XORI"

RDHEX: db "RD (Hex)"
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
TEXTWORDE: db "1234512345"
TEXTWORDF: db "1234567"
TEXTWORDG: db "1234567897"

TEXTIWORDB: db "12345"
TEXTIWORDC: db "1234"
TEXTIWORDD: db "12341"
TEXTIWORDE: db "23456"
TEXTIWORDF: db "3456"
TEXTIWORDG: db "32198"

PAGEBREAK: db "--------------------------------------------------------------------------------"

  align 8 ; Align 64-Bit
VALUEWORDA: dw 0
VALUEWORDB: dw 123456789
VALUEWORDC: dw 123456
VALUEWORDD: dw 123451234
VALUEWORDE: dw 1234512345
VALUEWORDF: dw 1234567
VALUEWORDG: dw 1234567891

XORCHECKA: dw $075BCD15
XORCHECKB: dw $075A2F55
XORCHECKC: dw $075A5522
XORCHECKD: dw $4ECE9EBB
XORCHECKE: dw $4987FF5E
XORCHECKF: dw $4984D454
XORCHECKG: dw $499602D3

VALUEIWORDB: equ 12345
VALUEIWORDC: equ 1234
VALUEIWORDD: equ 12341
VALUEIWORDE: equ 23456
VALUEIWORDF: equ 3456
VALUEIWORDG: equ 32198
IWORDB: dw 12345
IWORDC: dw 1234
IWORDD: dw 12341
IWORDE: dw 23456
IWORDF: dw 3456
IWORDG: dw 32198

XORICHECKA: dw $00003039
XORICHECKB: dw $075BC9C7
XORICHECKC: dw $0001D275
XORICHECKD: dw $00006B95
XORICHECKE: dw $49952459
XORICHECKF: dw $0012AB41
XORICHECKG: dw $00007DC6

RDWORD: dw 0

FontBlack: incbin FontBlack8x8.bin
FontGreen: incbin FontGreen8x8.bin
FontRed: incbin FontRed8x8.bin

  align 8 ; Align 64-Bit
RSPXORCode:
  obj $0000 ; Set Base Of RSP Code Object To Zero
  la a0,$0000 ; A0 = RSP DMEM Offset
  lw t0,0(a0) ; T0 = Word Data 0
  lw t1,4(a0) ; T1 = Word Data 1
  xor t0,t1 ; T0 = Test Word Data
  sw t0,0(a0) ; RSP DMEM = Test Word Data
  break $0000 ; Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
  objend ; Set End Of RSP Code Object
RSPXORCodeEND:

  align 8 ; Align 64-Bit
RSPXORICodeA:
  obj $0000 ; Set Base Of RSP Code Object To Zero
  la a0,$0000 ; A0 = RSP DMEM Offset
  lw t0,0(a0) ; T0 = Word Data 0
  xori t0,VALUEIWORDB ; T0 = Test Word Data
  sw t0,0(a0) ; RSP DMEM = Test Word Data
  break $0000 ; Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
  objend ; Set End Of RSP Code Object
RSPXORICodeAEND:

  align 8 ; Align 64-Bit
RSPXORICodeB:
  obj $0000 ; Set Base Of RSP Code Object To Zero
  la a0,$0000 ; A0 = RSP DMEM Offset
  lw t0,0(a0) ; T0 = Word Data 0
  xori t0,VALUEIWORDC ; T0 = Test Word Data
  sw t0,0(a0) ; RSP DMEM = Test Word Data
  break $0000 ; Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
  objend ; Set End Of RSP Code Object
RSPXORICodeBEND:

  align 8 ; Align 64-Bit
RSPXORICodeC:
  obj $0000 ; Set Base Of RSP Code Object To Zero
  la a0,$0000 ; A0 = RSP DMEM Offset
  lw t0,0(a0) ; T0 = Word Data 0
  xori t0,VALUEIWORDD ; T0 = Test Word Data
  sw t0,0(a0) ; RSP DMEM = Test Word Data
  break $0000 ; Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
  objend ; Set End Of RSP Code Object
RSPXORICodeCEND:

  align 8 ; Align 64-Bit
RSPXORICodeD:
  obj $0000 ; Set Base Of RSP Code Object To Zero
  la a0,$0000 ; A0 = RSP DMEM Offset
  lw t0,0(a0) ; T0 = Word Data 0
  xori t0,VALUEIWORDE ; T0 = Test Word Data
  sw t0,0(a0) ; RSP DMEM = Test Word Data
  break $0000 ; Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
  objend ; Set End Of RSP Code Object
RSPXORICodeDEND:

  align 8 ; Align 64-Bit
RSPXORICodeE:
  obj $0000 ; Set Base Of RSP Code Object To Zero
  la a0,$0000 ; A0 = RSP DMEM Offset
  lw t0,0(a0) ; T0 = Word Data 0
  xori t0,VALUEIWORDF ; T0 = Test Word Data
  sw t0,0(a0) ; RSP DMEM = Test Word Data
  break $0000 ; Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
  objend ; Set End Of RSP Code Object
RSPXORICodeEEND:

  align 8 ; Align 64-Bit
RSPXORICodeF:
  obj $0000 ; Set Base Of RSP Code Object To Zero
  la a0,$0000 ; A0 = RSP DMEM Offset
  lw t0,0(a0) ; T0 = Word Data 0
  xori t0,VALUEIWORDG ; T0 = Test Word Data
  sw t0,0(a0) ; RSP DMEM = Test Word Data
  break $0000 ; Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
  objend ; Set End Of RSP Code Object
RSPXORICodeFEND: