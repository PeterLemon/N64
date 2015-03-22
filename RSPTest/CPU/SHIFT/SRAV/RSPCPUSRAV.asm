; N64 'Bare Metal' RSP CPU Word Shift Right Arithmetic Variable (0..31) Test Demo by krom (Peter Lemon):
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


  PrintString $A010,88,8,FontRed,RTHEX,7 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,232,8,FontRed,RSDEC,11 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,384,8,FontRed,RDHEX,7 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,528,8,FontRed,TEST,10 ; Print Text String To VRAM Using Font At X,Y Position


  PrintString $A010,0,16,FontBlack,PAGEBREAK,79 ; Print Text String To VRAM Using Font At X,Y Position

  ; Load RSP Code To IMEM
  DMASPRD RSPSRAV0Code, RSPSRAV0CodeEND, SP_IMEM ; DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  ; Load RSP Data To DMEM
  lui a0,SP_MEM_BASE ; A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD ; A1 = Word Data Offset
  lw t0,0(a1) ; T0 = Word Data
  sw t0,0(a0) ; Store Word Data To DMEM

  ; Set RSP Program Counter
  lui a0,SP_PC_BASE ; A0 = SP PC Base Register ($A4080000)
  li t0,$0000 ; T0 = RSP Program Counter Set To Zero (Start Of RSP Code)
  sw t0,SP_PC(a0) ; Store RSP Program Counter To SP PC Register ($A4080000)

  ; Set RSP Status (Start Execution)
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB ; T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) ; Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString $A010,8,24,FontRed,SRAV,3 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,80,24,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,24,FontBlack,VALUEWORD,3  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,24,FontBlack,TEXTWORD0,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,24,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE ; A0 = Test Word Data Offset
  lw t0,0(a0) ; T0 = Test Word Data
  la a0,RDWORD ; A0 = RDWORD Offset
  sw t0,0(a0)  ; RDWORD = Word Data
  PrintValue  $A010,384,24,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     ; A0 = Word Data Offset
  lw t0,0(a0)      ; T0 = Word Data
  la a0,SRAVCHECK0 ; A0 = Word Check Data Offset
  lw t1,0(a0)      ; T1 = Word Check Data
  beq t0,t1,SRAVPASS0 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,24,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRAVEND0
  nop ; Delay Slot
  SRAVPASS0:
  PrintString $A010,528,24,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRAVEND0:

  ; Load RSP Code To IMEM
  DMASPRD RSPSRAV1Code, RSPSRAV1CodeEND, SP_IMEM ; DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  ; Load RSP Data To DMEM
  lui a0,SP_MEM_BASE ; A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD ; A1 = Word Data Offset
  lw t0,0(a1) ; T0 = Word Data
  sw t0,0(a0) ; Store Word Data To DMEM

  ; Set RSP Status (Start Execution)
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB ; T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) ; Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString $A010,80,32,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,32,FontBlack,VALUEWORD,3  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,32,FontBlack,TEXTWORD1,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,32,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE ; A0 = Test Word Data Offset
  lw t0,0(a0) ; T0 = Test Word Data
  la a0,RDWORD ; A0 = RDWORD Offset
  sw t0,0(a0)  ; RDWORD = Word Data
  PrintValue  $A010,384,32,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     ; A0 = Word Data Offset
  lw t0,0(a0)      ; T0 = Word Data
  la a0,SRAVCHECK1 ; A0 = Word Check Data Offset
  lw t1,0(a0)      ; T1 = Word Check Data
  beq t0,t1,SRAVPASS1 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,32,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRAVEND1
  nop ; Delay Slot
  SRAVPASS1:
  PrintString $A010,528,32,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRAVEND1:

  ; Load RSP Code To IMEM
  DMASPRD RSPSRAV2Code, RSPSRAV2CodeEND, SP_IMEM ; DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  ; Load RSP Data To DMEM
  lui a0,SP_MEM_BASE ; A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD ; A1 = Word Data Offset
  lw t0,0(a1) ; T0 = Word Data
  sw t0,0(a0) ; Store Word Data To DMEM

  ; Set RSP Status (Start Execution)
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB ; T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) ; Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString $A010,80,40,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,40,FontBlack,VALUEWORD,3  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,40,FontBlack,TEXTWORD2,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,40,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE ; A0 = Test Word Data Offset
  lw t0,0(a0) ; T0 = Test Word Data
  la a0,RDWORD ; A0 = RDWORD Offset
  sw t0,0(a0)  ; RDWORD = Word Data
  PrintValue  $A010,384,40,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     ; A0 = Word Data Offset
  lw t0,0(a0)      ; T0 = Word Data
  la a0,SRAVCHECK2 ; A0 = Word Check Data Offset
  lw t1,0(a0)      ; T1 = Word Check Data
  beq t0,t1,SRAVPASS2 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,40,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRAVEND2
  nop ; Delay Slot
  SRAVPASS2:
  PrintString $A010,528,40,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRAVEND2:

  ; Load RSP Code To IMEM
  DMASPRD RSPSRAV3Code, RSPSRAV3CodeEND, SP_IMEM ; DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  ; Load RSP Data To DMEM
  lui a0,SP_MEM_BASE ; A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD ; A1 = Word Data Offset
  lw t0,0(a1) ; T0 = Word Data
  sw t0,0(a0) ; Store Word Data To DMEM

  ; Set RSP Status (Start Execution)
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB ; T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) ; Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString $A010,80,48,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,48,FontBlack,VALUEWORD,3  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,48,FontBlack,TEXTWORD3,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,48,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE ; A0 = Test Word Data Offset
  lw t0,0(a0) ; T0 = Test Word Data
  la a0,RDWORD ; A0 = RDWORD Offset
  sw t0,0(a0)  ; RDWORD = Word Data
  PrintValue  $A010,384,48,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD     ; T0 = Word Data Offset
  lw t1,0(t0)      ; T1 = Word Data
  la t0,SRAVCHECK3 ; T0 = Word Check Data Offset
  lw t2,0(t0)      ; T2 = Word Check Data
  beq t1,t2,SRAVPASS3 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,48,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRAVEND3
  nop ; Delay Slot
  SRAVPASS3:
  PrintString $A010,528,48,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRAVEND3:

  ; Load RSP Code To IMEM
  DMASPRD RSPSRAV4Code, RSPSRAV4CodeEND, SP_IMEM ; DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  ; Load RSP Data To DMEM
  lui a0,SP_MEM_BASE ; A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD ; A1 = Word Data Offset
  lw t0,0(a1) ; T0 = Word Data
  sw t0,0(a0) ; Store Word Data To DMEM

  ; Set RSP Status (Start Execution)
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB ; T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) ; Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString $A010,80,56,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,56,FontBlack,VALUEWORD,3  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,56,FontBlack,TEXTWORD4,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,56,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE ; A0 = Test Word Data Offset
  lw t0,0(a0) ; T0 = Test Word Data
  la a0,RDWORD ; A0 = RDWORD Offset
  sw t0,0(a0)  ; RDWORD = Word Data
  PrintValue  $A010,384,56,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     ; A0 = Word Data Offset
  lw t0,0(a0)      ; T0 = Word Data
  la a0,SRAVCHECK4 ; A0 = Word Check Data Offset
  lw t1,0(a0)      ; T1 = Word Check Data
  beq t0,t1,SRAVPASS4 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,56,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRAVEND4
  nop ; Delay Slot
  SRAVPASS4:
  PrintString $A010,528,56,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRAVEND4:

  ; Load RSP Code To IMEM
  DMASPRD RSPSRAV5Code, RSPSRAV5CodeEND, SP_IMEM ; DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  ; Load RSP Data To DMEM
  lui a0,SP_MEM_BASE ; A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD ; A1 = Word Data Offset
  lw t0,0(a1) ; T0 = Word Data
  sw t0,0(a0) ; Store Word Data To DMEM

  ; Set RSP Status (Start Execution)
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB ; T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) ; Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString $A010,80,64,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,64,FontBlack,VALUEWORD,3  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,64,FontBlack,TEXTWORD5,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,64,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE ; A0 = Test Word Data Offset
  lw t0,0(a0) ; T0 = Test Word Data
  la a0,RDWORD ; A0 = RDWORD Offset
  sw t0,0(a0)  ; RDWORD = Word Data
  PrintValue  $A010,384,64,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     ; A0 = Word Data Offset
  lw t0,0(a0)      ; T0 = Word Data
  la a0,SRAVCHECK5 ; A0 = Word Check Data Offset
  lw t1,0(a0)      ; T1 = Word Check Data
  beq t0,t1,SRAVPASS5 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,64,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRAVEND5
  nop ; Delay Slot
  SRAVPASS5:
  PrintString $A010,528,64,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRAVEND5:

  ; Load RSP Code To IMEM
  DMASPRD RSPSRAV6Code, RSPSRAV6CodeEND, SP_IMEM ; DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  ; Load RSP Data To DMEM
  lui a0,SP_MEM_BASE ; A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD ; A1 = Word Data Offset
  lw t0,0(a1) ; T0 = Word Data
  sw t0,0(a0) ; Store Word Data To DMEM

  ; Set RSP Status (Start Execution)
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB ; T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) ; Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString $A010,80,72,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,72,FontBlack,VALUEWORD,3  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,72,FontBlack,TEXTWORD6,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,72,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE ; A0 = Test Word Data Offset
  lw t0,0(a0) ; T0 = Test Word Data
  la a0,RDWORD ; A0 = RDWORD Offset
  sw t0,0(a0)  ; RDWORD = Word Data
  PrintValue  $A010,384,72,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     ; A0 = Word Data Offset
  lw t0,0(a0)      ; T0 = Word Data
  la a0,SRAVCHECK6 ; A0 = Word Check Data Offset
  lw t1,0(a0)      ; T1 = Word Check Data
  beq t0,t1,SRAVPASS6 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,72,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRAVEND6
  nop ; Delay Slot
  SRAVPASS6:
  PrintString $A010,528,72,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRAVEND6:

  ; Load RSP Code To IMEM
  DMASPRD RSPSRAV7Code, RSPSRAV7CodeEND, SP_IMEM ; DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  ; Load RSP Data To DMEM
  lui a0,SP_MEM_BASE ; A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD ; A1 = Word Data Offset
  lw t0,0(a1) ; T0 = Word Data
  sw t0,0(a0) ; Store Word Data To DMEM

  ; Set RSP Status (Start Execution)
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB ; T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) ; Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString $A010,80,80,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,80,FontBlack,VALUEWORD,3  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,80,FontBlack,TEXTWORD7,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,80,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE ; A0 = Test Word Data Offset
  lw t0,0(a0) ; T0 = Test Word Data
  la a0,RDWORD ; A0 = RDWORD Offset
  sw t0,0(a0)  ; RDWORD = Word Data
  PrintValue  $A010,384,80,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     ; A0 = Word Data Offset
  lw t0,0(a0)      ; T0 = Word Data
  la a0,SRAVCHECK7 ; A0 = Word Check Data Offset
  lw t1,0(a0)      ; T1 = Word Check Data
  beq t0,t1,SRAVPASS7 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,80,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRAVEND7
  nop ; Delay Slot
  SRAVPASS7:
  PrintString $A010,528,80,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRAVEND7:

  ; Load RSP Code To IMEM
  DMASPRD RSPSRAV8Code, RSPSRAV8CodeEND, SP_IMEM ; DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  ; Load RSP Data To DMEM
  lui a0,SP_MEM_BASE ; A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD ; A1 = Word Data Offset
  lw t0,0(a1) ; T0 = Word Data
  sw t0,0(a0) ; Store Word Data To DMEM

  ; Set RSP Status (Start Execution)
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB ; T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) ; Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString $A010,80,88,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,88,FontBlack,VALUEWORD,3  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,88,FontBlack,TEXTWORD8,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,88,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE ; A0 = Test Word Data Offset
  lw t0,0(a0) ; T0 = Test Word Data
  la a0,RDWORD ; A0 = RDWORD Offset
  sw t0,0(a0)  ; RDWORD = Word Data
  PrintValue  $A010,384,88,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     ; A0 = Word Data Offset
  lw t0,0(a0)      ; T0 = Word Data
  la a0,SRAVCHECK8 ; A0 = Word Check Data Offset
  lw t1,0(a0)      ; T1 = Word Check Data
  beq t0,t1,SRAVPASS8 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,88,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRAVEND8
  nop ; Delay Slot
  SRAVPASS8:
  PrintString $A010,528,88,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRAVEND8:

  ; Load RSP Code To IMEM
  DMASPRD RSPSRAV9Code, RSPSRAV9CodeEND, SP_IMEM ; DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  ; Load RSP Data To DMEM
  lui a0,SP_MEM_BASE ; A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD ; A1 = Word Data Offset
  lw t0,0(a1) ; T0 = Word Data
  sw t0,0(a0) ; Store Word Data To DMEM

  ; Set RSP Status (Start Execution)
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB ; T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) ; Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString $A010,80,96,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,96,FontBlack,VALUEWORD,3  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,96,FontBlack,TEXTWORD9,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,96,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE ; A0 = Test Word Data Offset
  lw t0,0(a0) ; T0 = Test Word Data
  la a0,RDWORD ; A0 = RDWORD Offset
  sw t0,0(a0)  ; RDWORD = Word Data
  PrintValue  $A010,384,96,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     ; A0 = Word Data Offset
  lw t0,0(a0)      ; T0 = Word Data
  la a0,SRAVCHECK9 ; A0 = Word Check Data Offset
  lw t1,0(a0)      ; T1 = Word Check Data
  beq t0,t1,SRAVPASS9 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,96,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRAVEND9
  nop ; Delay Slot
  SRAVPASS9:
  PrintString $A010,528,96,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRAVEND9:

  ; Load RSP Code To IMEM
  DMASPRD RSPSRAV10Code, RSPSRAV10CodeEND, SP_IMEM ; DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  ; Load RSP Data To DMEM
  lui a0,SP_MEM_BASE ; A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD ; A1 = Word Data Offset
  lw t0,0(a1) ; T0 = Word Data
  sw t0,0(a0) ; Store Word Data To DMEM

  ; Set RSP Status (Start Execution)
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB ; T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) ; Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString $A010,80,104,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,104,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,104,FontBlack,TEXTWORD10,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,104,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE ; A0 = Test Word Data Offset
  lw t0,0(a0) ; T0 = Test Word Data
  la a0,RDWORD ; A0 = RDWORD Offset
  sw t0,0(a0)  ; RDWORD = Word Data
  PrintValue  $A010,384,104,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD      ; A0 = Word Data Offset
  lw t0,0(a0)       ; T0 = Word Data
  la a0,SRAVCHECK10 ; A0 = Word Check Data Offset
  lw t1,0(a0)       ; T1 = Word Check Data
  beq t0,t1,SRAVPASS10 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,104,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRAVEND10
  nop ; Delay Slot
  SRAVPASS10:
  PrintString $A010,528,104,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRAVEND10:

  ; Load RSP Code To IMEM
  DMASPRD RSPSRAV11Code, RSPSRAV11CodeEND, SP_IMEM ; DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  ; Load RSP Data To DMEM
  lui a0,SP_MEM_BASE ; A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD ; A1 = Word Data Offset
  lw t0,0(a1) ; T0 = Word Data
  sw t0,0(a0) ; Store Word Data To DMEM

  ; Set RSP Status (Start Execution)
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB ; T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) ; Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString $A010,80,112,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,112,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,112,FontBlack,TEXTWORD11,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,112,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE ; A0 = Test Word Data Offset
  lw t0,0(a0) ; T0 = Test Word Data
  la a0,RDWORD ; A0 = RDWORD Offset
  sw t0,0(a0)  ; RDWORD = Word Data
  PrintValue  $A010,384,112,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD      ; A0 = Word Data Offset
  lw t0,0(a0)       ; T0 = Word Data
  la a0,SRAVCHECK11 ; A0 = Word Check Data Offset
  lw t1,0(a0)       ; T1 = Word Check Data
  beq t0,t1,SRAVPASS11 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,112,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRAVEND11
  nop ; Delay Slot
  SRAVPASS11:
  PrintString $A010,528,112,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRAVEND11:

  ; Load RSP Code To IMEM
  DMASPRD RSPSRAV12Code, RSPSRAV12CodeEND, SP_IMEM ; DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  ; Load RSP Data To DMEM
  lui a0,SP_MEM_BASE ; A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD ; A1 = Word Data Offset
  lw t0,0(a1) ; T0 = Word Data
  sw t0,0(a0) ; Store Word Data To DMEM

  ; Set RSP Status (Start Execution)
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB ; T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) ; Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString $A010,80,120,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,120,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,120,FontBlack,TEXTWORD12,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,120,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE ; A0 = Test Word Data Offset
  lw t0,0(a0) ; T0 = Test Word Data
  la a0,RDWORD ; A0 = RDWORD Offset
  sw t0,0(a0)  ; RDWORD = Word Data
  PrintValue  $A010,384,120,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD      ; A0 = Word Data Offset
  lw t0,0(a0)       ; T0 = Word Data
  la a0,SRAVCHECK12 ; A0 = Word Check Data Offset
  lw t1,0(a0)       ; T1 = Word Check Data
  beq t0,t1,SRAVPASS12 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,120,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRAVEND12
  nop ; Delay Slot
  SRAVPASS12:
  PrintString $A010,528,120,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRAVEND12:

  ; Load RSP Code To IMEM
  DMASPRD RSPSRAV13Code, RSPSRAV13CodeEND, SP_IMEM ; DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  ; Load RSP Data To DMEM
  lui a0,SP_MEM_BASE ; A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD ; A1 = Word Data Offset
  lw t0,0(a1) ; T0 = Word Data
  sw t0,0(a0) ; Store Word Data To DMEM

  ; Set RSP Status (Start Execution)
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB ; T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) ; Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString $A010,80,128,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,128,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,128,FontBlack,TEXTWORD13,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,128,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE ; A0 = Test Word Data Offset
  lw t0,0(a0) ; T0 = Test Word Data
  la a0,RDWORD ; A0 = RDWORD Offset
  sw t0,0(a0)  ; RDWORD = Word Data
  PrintValue  $A010,384,128,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD      ; A0 = Word Data Offset
  lw t0,0(a0)       ; T0 = Word Data
  la a0,SRAVCHECK13 ; A0 = Word Check Data Offset
  lw t1,0(a0)       ; T1 = Word Check Data
  beq t0,t1,SRAVPASS13 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,128,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRAVEND13
  nop ; Delay Slot
  SRAVPASS13:
  PrintString $A010,528,128,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRAVEND13:

  ; Load RSP Code To IMEM
  DMASPRD RSPSRAV14Code, RSPSRAV14CodeEND, SP_IMEM ; DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  ; Load RSP Data To DMEM
  lui a0,SP_MEM_BASE ; A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD ; A1 = Word Data Offset
  lw t0,0(a1) ; T0 = Word Data
  sw t0,0(a0) ; Store Word Data To DMEM

  ; Set RSP Status (Start Execution)
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB ; T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) ; Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString $A010,80,136,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,136,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,136,FontBlack,TEXTWORD14,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,136,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE ; A0 = Test Word Data Offset
  lw t0,0(a0) ; T0 = Test Word Data
  la a0,RDWORD ; A0 = RDWORD Offset
  sw t0,0(a0)  ; RDWORD = Word Data
  PrintValue  $A010,384,136,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD      ; A0 = Word Data Offset
  lw t0,0(a0)       ; T0 = Word Data
  la a0,SRAVCHECK14 ; A0 = Word Check Data Offset
  lw t1,0(a0)       ; T1 = Word Check Data
  beq t0,t1,SRAVPASS14 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,136,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRAVEND14
  nop ; Delay Slot
  SRAVPASS14:
  PrintString $A010,528,136,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRAVEND14:

  ; Load RSP Code To IMEM
  DMASPRD RSPSRAV15Code, RSPSRAV15CodeEND, SP_IMEM ; DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  ; Load RSP Data To DMEM
  lui a0,SP_MEM_BASE ; A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD ; A1 = Word Data Offset
  lw t0,0(a1) ; T0 = Word Data
  sw t0,0(a0) ; Store Word Data To DMEM

  ; Set RSP Status (Start Execution)
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB ; T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) ; Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString $A010,80,144,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,144,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,144,FontBlack,TEXTWORD15,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,144,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE ; A0 = Test Word Data Offset
  lw t0,0(a0) ; T0 = Test Word Data
  la a0,RDWORD ; A0 = RDWORD Offset
  sw t0,0(a0)  ; RDWORD = Word Data
  PrintValue  $A010,384,144,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD      ; A0 = Word Data Offset
  lw t0,0(a0)       ; T0 = Word Data
  la a0,SRAVCHECK15 ; A0 = Word Check Data Offset
  lw t1,0(a0)       ; T1 = Word Check Data
  beq t0,t1,SRAVPASS15 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,144,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRAVEND15
  nop ; Delay Slot
  SRAVPASS15:
  PrintString $A010,528,144,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRAVEND15:

  ; Load RSP Code To IMEM
  DMASPRD RSPSRAV16Code, RSPSRAV16CodeEND, SP_IMEM ; DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  ; Load RSP Data To DMEM
  lui a0,SP_MEM_BASE ; A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD ; A1 = Word Data Offset
  lw t0,0(a1) ; T0 = Word Data
  sw t0,0(a0) ; Store Word Data To DMEM

  ; Set RSP Status (Start Execution)
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB ; T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) ; Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString $A010,80,152,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,152,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,152,FontBlack,TEXTWORD16,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,152,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE ; A0 = Test Word Data Offset
  lw t0,0(a0) ; T0 = Test Word Data
  la a0,RDWORD ; A0 = RDWORD Offset
  sw t0,0(a0)  ; RDWORD = Word Data
  PrintValue  $A010,384,152,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD      ; A0 = Word Data Offset
  lw t0,0(a0)       ; T0 = Word Data
  la a0,SRAVCHECK16 ; A0 = Word Check Data Offset
  lw t1,0(a0)       ; T1 = Word Check Data
  beq t0,t1,SRAVPASS16 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,152,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRAVEND16
  nop ; Delay Slot
  SRAVPASS16:
  PrintString $A010,528,152,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRAVEND16:

  ; Load RSP Code To IMEM
  DMASPRD RSPSRAV17Code, RSPSRAV17CodeEND, SP_IMEM ; DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  ; Load RSP Data To DMEM
  lui a0,SP_MEM_BASE ; A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD ; A1 = Word Data Offset
  lw t0,0(a1) ; T0 = Word Data
  sw t0,0(a0) ; Store Word Data To DMEM

  ; Set RSP Status (Start Execution)
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB ; T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) ; Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString $A010,80,160,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,160,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,160,FontBlack,TEXTWORD17,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,160,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE ; A0 = Test Word Data Offset
  lw t0,0(a0) ; T0 = Test Word Data
  la a0,RDWORD ; A0 = RDWORD Offset
  sw t0,0(a0)  ; RDWORD = Word Data
  PrintValue  $A010,384,160,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD      ; A0 = Word Data Offset
  lw t0,0(a0)       ; T0 = Word Data
  la a0,SRAVCHECK17 ; A0 = Word Check Data Offset
  lw t1,0(a0)       ; T1 = Word Check Data
  beq t0,t1,SRAVPASS17 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,160,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRAVEND17
  nop ; Delay Slot
  SRAVPASS17:
  PrintString $A010,528,160,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRAVEND17:

  ; Load RSP Code To IMEM
  DMASPRD RSPSRAV18Code, RSPSRAV18CodeEND, SP_IMEM ; DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  ; Load RSP Data To DMEM
  lui a0,SP_MEM_BASE ; A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD ; A1 = Word Data Offset
  lw t0,0(a1) ; T0 = Word Data
  sw t0,0(a0) ; Store Word Data To DMEM

  ; Set RSP Status (Start Execution)
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB ; T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) ; Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString $A010,80,168,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,168,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,168,FontBlack,TEXTWORD18,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,168,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE ; A0 = Test Word Data Offset
  lw t0,0(a0) ; T0 = Test Word Data
  la a0,RDWORD ; A0 = RDWORD Offset
  sw t0,0(a0)  ; RDWORD = Word Data
  PrintValue  $A010,384,168,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD      ; A0 = Word Data Offset
  lw t0,0(a0)       ; T0 = Word Data
  la a0,SRAVCHECK18 ; A0 = Word Check Data Offset
  lw t1,0(a0)       ; T1 = Word Check Data
  beq t0,t1,SRAVPASS18 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,168,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRAVEND18
  nop ; Delay Slot
  SRAVPASS18:
  PrintString $A010,528,168,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRAVEND18:

  ; Load RSP Code To IMEM
  DMASPRD RSPSRAV19Code, RSPSRAV19CodeEND, SP_IMEM ; DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  ; Load RSP Data To DMEM
  lui a0,SP_MEM_BASE ; A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD ; A1 = Word Data Offset
  lw t0,0(a1) ; T0 = Word Data
  sw t0,0(a0) ; Store Word Data To DMEM

  ; Set RSP Status (Start Execution)
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB ; T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) ; Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString $A010,80,176,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,176,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,176,FontBlack,TEXTWORD19,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,176,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE ; A0 = Test Word Data Offset
  lw t0,0(a0) ; T0 = Test Word Data
  la a0,RDWORD ; A0 = RDWORD Offset
  sw t0,0(a0)  ; RDWORD = Word Data
  PrintValue  $A010,384,176,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD      ; A0 = Word Data Offset
  lw t0,0(a0)       ; T0 = Word Data
  la a0,SRAVCHECK19 ; A0 = Word Check Data Offset
  lw t1,0(a0)       ; T1 = Word Check Data
  beq t0,t1,SRAVPASS19 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,176,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRAVEND19
  nop ; Delay Slot
  SRAVPASS19:
  PrintString $A010,528,176,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRAVEND19:

  ; Load RSP Code To IMEM
  DMASPRD RSPSRAV20Code, RSPSRAV20CodeEND, SP_IMEM ; DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  ; Load RSP Data To DMEM
  lui a0,SP_MEM_BASE ; A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD ; A1 = Word Data Offset
  lw t0,0(a1) ; T0 = Word Data
  sw t0,0(a0) ; Store Word Data To DMEM

  ; Set RSP Status (Start Execution)
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB ; T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) ; Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString $A010,80,184,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,184,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,184,FontBlack,TEXTWORD20,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,184,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE ; A0 = Test Word Data Offset
  lw t0,0(a0) ; T0 = Test Word Data
  la a0,RDWORD ; A0 = RDWORD Offset
  sw t0,0(a0)  ; RDWORD = Word Data
  PrintValue  $A010,384,184,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD      ; A0 = Word Data Offset
  lw t0,0(a0)       ; T0 = Word Data
  la a0,SRAVCHECK20 ; A0 = Word Check Data Offset
  lw t1,0(a0)       ; T1 = Word Check Data
  beq t0,t1,SRAVPASS20 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,184,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRAVEND20
  nop ; Delay Slot
  SRAVPASS20:
  PrintString $A010,528,184,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRAVEND20:

  ; Load RSP Code To IMEM
  DMASPRD RSPSRAV21Code, RSPSRAV21CodeEND, SP_IMEM ; DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  ; Load RSP Data To DMEM
  lui a0,SP_MEM_BASE ; A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD ; A1 = Word Data Offset
  lw t0,0(a1) ; T0 = Word Data
  sw t0,0(a0) ; Store Word Data To DMEM

  ; Set RSP Status (Start Execution)
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB ; T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) ; Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString $A010,80,192,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,192,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,192,FontBlack,TEXTWORD21,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,192,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE ; A0 = Test Word Data Offset
  lw t0,0(a0) ; T0 = Test Word Data
  la a0,RDWORD ; A0 = RDWORD Offset
  sw t0,0(a0)  ; RDWORD = Word Data
  PrintValue  $A010,384,192,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD      ; A0 = Word Data Offset
  lw t0,0(a0)       ; T0 = Word Data
  la a0,SRAVCHECK21 ; A0 = Word Check Data Offset
  lw t1,0(a0)       ; T1 = Word Check Data
  beq t0,t1,SRAVPASS21 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,192,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRAVEND21
  nop ; Delay Slot
  SRAVPASS21:
  PrintString $A010,528,192,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRAVEND21:

  ; Load RSP Code To IMEM
  DMASPRD RSPSRAV22Code, RSPSRAV22CodeEND, SP_IMEM ; DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  ; Load RSP Data To DMEM
  lui a0,SP_MEM_BASE ; A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD ; A1 = Word Data Offset
  lw t0,0(a1) ; T0 = Word Data
  sw t0,0(a0) ; Store Word Data To DMEM

  ; Set RSP Status (Start Execution)
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB ; T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) ; Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString $A010,80,200,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,200,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,200,FontBlack,TEXTWORD22,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,200,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE ; A0 = Test Word Data Offset
  lw t0,0(a0) ; T0 = Test Word Data
  la a0,RDWORD ; A0 = RDWORD Offset
  sw t0,0(a0)  ; RDWORD = Word Data
  PrintValue  $A010,384,200,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD      ; A0 = Word Data Offset
  lw t0,0(a0)       ; T0 = Word Data
  la a0,SRAVCHECK22 ; A0 = Word Check Data Offset
  lw t1,0(a0)       ; T1 = Word Check Data
  beq t0,t1,SRAVPASS22 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,200,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRAVEND22
  nop ; Delay Slot
  SRAVPASS22:
  PrintString $A010,528,200,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRAVEND22:

  ; Load RSP Code To IMEM
  DMASPRD RSPSRAV23Code, RSPSRAV23CodeEND, SP_IMEM ; DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  ; Load RSP Data To DMEM
  lui a0,SP_MEM_BASE ; A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD ; A1 = Word Data Offset
  lw t0,0(a1) ; T0 = Word Data
  sw t0,0(a0) ; Store Word Data To DMEM

  ; Set RSP Status (Start Execution)
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB ; T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) ; Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString $A010,80,208,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,208,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,208,FontBlack,TEXTWORD23,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,208,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE ; A0 = Test Word Data Offset
  lw t0,0(a0) ; T0 = Test Word Data
  la a0,RDWORD ; A0 = RDWORD Offset
  sw t0,0(a0)  ; RDWORD = Word Data
  PrintValue  $A010,384,208,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD      ; A0 = Word Data Offset
  lw t0,0(a0)       ; T0 = Word Data
  la a0,SRAVCHECK23 ; A0 = Word Check Data Offset
  lw t1,0(a0)       ; T1 = Word Check Data
  beq t0,t1,SRAVPASS23 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,208,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRAVEND23
  nop ; Delay Slot
  SRAVPASS23:
  PrintString $A010,528,208,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRAVEND23:

  ; Load RSP Code To IMEM
  DMASPRD RSPSRAV24Code, RSPSRAV24CodeEND, SP_IMEM ; DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  ; Load RSP Data To DMEM
  lui a0,SP_MEM_BASE ; A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD ; A1 = Word Data Offset
  lw t0,0(a1) ; T0 = Word Data
  sw t0,0(a0) ; Store Word Data To DMEM

  ; Set RSP Status (Start Execution)
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB ; T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) ; Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString $A010,80,216,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,216,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,216,FontBlack,TEXTWORD24,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,216,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE ; A0 = Test Word Data Offset
  lw t0,0(a0) ; T0 = Test Word Data
  la a0,RDWORD ; A0 = RDWORD Offset
  sw t0,0(a0)  ; RDWORD = Word Data
  PrintValue  $A010,384,216,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD      ; A0 = Word Data Offset
  lw t0,0(a0)       ; T0 = Word Data
  la a0,SRAVCHECK24 ; A0 = Word Check Data Offset
  lw t1,0(a0)       ; T1 = Word Check Data
  beq t0,t1,SRAVPASS24 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,216,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRAVEND24
  nop ; Delay Slot
  SRAVPASS24:
  PrintString $A010,528,216,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRAVEND24:

  ; Load RSP Code To IMEM
  DMASPRD RSPSRAV25Code, RSPSRAV25CodeEND, SP_IMEM ; DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  ; Load RSP Data To DMEM
  lui a0,SP_MEM_BASE ; A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD ; A1 = Word Data Offset
  lw t0,0(a1) ; T0 = Word Data
  sw t0,0(a0) ; Store Word Data To DMEM

  ; Set RSP Status (Start Execution)
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB ; T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) ; Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString $A010,80,224,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,224,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,224,FontBlack,TEXTWORD25,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,224,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE ; A0 = Test Word Data Offset
  lw t0,0(a0) ; T0 = Test Word Data
  la a0,RDWORD ; A0 = RDWORD Offset
  sw t0,0(a0)  ; RDWORD = Word Data
  PrintValue  $A010,384,224,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD      ; A0 = Word Data Offset
  lw t0,0(a0)       ; T0 = Word Data
  la a0,SRAVCHECK25 ; A0 = Word Check Data Offset
  lw t1,0(a0)       ; T1 = Word Check Data
  beq t0,t1,SRAVPASS25 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,224,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRAVEND25
  nop ; Delay Slot
  SRAVPASS25:
  PrintString $A010,528,224,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRAVEND25:

  ; Load RSP Code To IMEM
  DMASPRD RSPSRAV26Code, RSPSRAV26CodeEND, SP_IMEM ; DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  ; Load RSP Data To DMEM
  lui a0,SP_MEM_BASE ; A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD ; A1 = Word Data Offset
  lw t0,0(a1) ; T0 = Word Data
  sw t0,0(a0) ; Store Word Data To DMEM

  ; Set RSP Status (Start Execution)
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB ; T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) ; Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString $A010,80,232,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,232,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,232,FontBlack,TEXTWORD26,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,232,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE ; A0 = Test Word Data Offset
  lw t0,0(a0) ; T0 = Test Word Data
  la a0,RDWORD ; A0 = RDWORD Offset
  sw t0,0(a0)  ; RDWORD = Word Data
  PrintValue  $A010,384,232,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD      ; A0 = Word Data Offset
  lw t0,0(a0)       ; T0 = Word Data
  la a0,SRAVCHECK26 ; A0 = Word Check Data Offset
  lw t1,0(a0)       ; T1 = Word Check Data
  beq t0,t1,SRAVPASS26 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,232,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRAVEND26
  nop ; Delay Slot
  SRAVPASS26:
  PrintString $A010,528,232,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRAVEND26:

  ; Load RSP Code To IMEM
  DMASPRD RSPSRAV27Code, RSPSRAV27CodeEND, SP_IMEM ; DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  ; Load RSP Data To DMEM
  lui a0,SP_MEM_BASE ; A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD ; A1 = Word Data Offset
  lw t0,0(a1) ; T0 = Word Data
  sw t0,0(a0) ; Store Word Data To DMEM

  ; Set RSP Status (Start Execution)
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB ; T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) ; Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString $A010,80,240,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,240,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,240,FontBlack,TEXTWORD27,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,240,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE ; A0 = Test Word Data Offset
  lw t0,0(a0) ; T0 = Test Word Data
  la a0,RDWORD ; A0 = RDWORD Offset
  sw t0,0(a0)  ; RDWORD = Word Data
  PrintValue  $A010,384,240,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD      ; A0 = Word Data Offset
  lw t0,0(a0)       ; T0 = Word Data
  la a0,SRAVCHECK27 ; A0 = Word Check Data Offset
  lw t1,0(a0)       ; T1 = Word Check Data
  beq t0,t1,SRAVPASS27 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,240,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRAVEND27
  nop ; Delay Slot
  SRAVPASS27:
  PrintString $A010,528,240,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRAVEND27:

  ; Load RSP Code To IMEM
  DMASPRD RSPSRAV28Code, RSPSRAV28CodeEND, SP_IMEM ; DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  ; Load RSP Data To DMEM
  lui a0,SP_MEM_BASE ; A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD ; A1 = Word Data Offset
  lw t0,0(a1) ; T0 = Word Data
  sw t0,0(a0) ; Store Word Data To DMEM

  ; Set RSP Status (Start Execution)
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB ; T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) ; Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString $A010,80,248,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,248,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,248,FontBlack,TEXTWORD28,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,248,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE ; A0 = Test Word Data Offset
  lw t0,0(a0) ; T0 = Test Word Data
  la a0,RDWORD ; A0 = RDWORD Offset
  sw t0,0(a0)  ; RDWORD = Word Data
  PrintValue  $A010,384,248,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD      ; A0 = Word Data Offset
  lw t0,0(a0)       ; T0 = Word Data
  la a0,SRAVCHECK28 ; A0 = Word Check Data Offset
  lw t1,0(a0)       ; T1 = Word Check Data
  beq t0,t1,SRAVPASS28 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,248,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRAVEND28
  nop ; Delay Slot
  SRAVPASS28:
  PrintString $A010,528,248,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRAVEND28:

  ; Load RSP Code To IMEM
  DMASPRD RSPSRAV29Code, RSPSRAV29CodeEND, SP_IMEM ; DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  ; Load RSP Data To DMEM
  lui a0,SP_MEM_BASE ; A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD ; A1 = Word Data Offset
  lw t0,0(a1) ; T0 = Word Data
  sw t0,0(a0) ; Store Word Data To DMEM

  ; Set RSP Status (Start Execution)
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB ; T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) ; Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString $A010,80,256,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,256,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,256,FontBlack,TEXTWORD29,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,256,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE ; A0 = Test Word Data Offset
  lw t0,0(a0) ; T0 = Test Word Data
  la a0,RDWORD ; A0 = RDWORD Offset
  sw t0,0(a0)  ; RDWORD = Word Data
  PrintValue  $A010,384,256,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD      ; A0 = Word Data Offset
  lw t0,0(a0)       ; T0 = Word Data
  la a0,SRAVCHECK29 ; A0 = Word Check Data Offset
  lw t1,0(a0)       ; T1 = Word Check Data
  beq t0,t1,SRAVPASS29 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,256,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRAVEND29
  nop ; Delay Slot
  SRAVPASS29:
  PrintString $A010,528,256,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRAVEND29:

  ; Load RSP Code To IMEM
  DMASPRD RSPSRAV30Code, RSPSRAV30CodeEND, SP_IMEM ; DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  ; Load RSP Data To DMEM
  lui a0,SP_MEM_BASE ; A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD ; A1 = Word Data Offset
  lw t0,0(a1) ; T0 = Word Data
  sw t0,0(a0) ; Store Word Data To DMEM

  ; Set RSP Status (Start Execution)
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB ; T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) ; Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString $A010,80,264,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,264,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,264,FontBlack,TEXTWORD30,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,264,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE ; A0 = Test Word Data Offset
  lw t0,0(a0) ; T0 = Test Word Data
  la a0,RDWORD ; A0 = RDWORD Offset
  sw t0,0(a0)  ; RDWORD = Word Data
  PrintValue  $A010,384,264,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD      ; A0 = Word Data Offset
  lw t0,0(a0)       ; T0 = Word Data
  la a0,SRAVCHECK30 ; A0 = Word Check Data Offset
  lw t1,0(a0)       ; T1 = Word Check Data
  beq t0,t1,SRAVPASS30 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,264,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRAVEND30
  nop ; Delay Slot
  SRAVPASS30:
  PrintString $A010,528,264,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRAVEND30:

  ; Load RSP Code To IMEM
  DMASPRD RSPSRAV31Code, RSPSRAV31CodeEND, SP_IMEM ; DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  ; Load RSP Data To DMEM
  lui a0,SP_MEM_BASE ; A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD ; A1 = Word Data Offset
  lw t0,0(a1) ; T0 = Word Data
  sw t0,0(a0) ; Store Word Data To DMEM

  ; Set RSP Status (Start Execution)
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB ; T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) ; Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString $A010,80,272,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,272,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,272,FontBlack,TEXTWORD31,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,272,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE ; A0 = Test Word Data Offset
  lw t0,0(a0) ; T0 = Test Word Data
  la a0,RDWORD ; A0 = RDWORD Offset
  sw t0,0(a0)  ; RDWORD = Word Data
  PrintValue  $A010,384,272,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD      ; A0 = Word Data Offset
  lw t0,0(a0)       ; T0 = Word Data
  la a0,SRAVCHECK31 ; A0 = Word Check Data Offset
  lw t1,0(a0)       ; T1 = Word Check Data
  beq t0,t1,SRAVPASS31 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,272,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRAVEND31
  nop ; Delay Slot
  SRAVPASS31:
  PrintString $A010,528,272,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRAVEND31:


  PrintString $A010,0,280,FontBlack,PAGEBREAK,79 ; Print Text String To VRAM Using Font At X,Y Position


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

SRAV: db "SRAV"

RDHEX: db "RD (Hex)"
RTHEX: db "RT (Hex)"
RSDEC: db "RS (Decimal)"
TEST: db "Test Result"
FAIL: db "FAIL"
PASS: db "PASS"

DOLLAR: db "$"

TEXTWORD0: db "0"
TEXTWORD1: db "1"
TEXTWORD2: db "2"
TEXTWORD3: db "3"
TEXTWORD4: db "4"
TEXTWORD5: db "5"
TEXTWORD6: db "6"
TEXTWORD7: db "7"
TEXTWORD8: db "8"
TEXTWORD9: db "9"
TEXTWORD10: db "10"
TEXTWORD11: db "11"
TEXTWORD12: db "12"
TEXTWORD13: db "13"
TEXTWORD14: db "14"
TEXTWORD15: db "15"
TEXTWORD16: db "16"
TEXTWORD17: db "17"
TEXTWORD18: db "18"
TEXTWORD19: db "19"
TEXTWORD20: db "20"
TEXTWORD21: db "21"
TEXTWORD22: db "22"
TEXTWORD23: db "23"
TEXTWORD24: db "24"
TEXTWORD25: db "25"
TEXTWORD26: db "26"
TEXTWORD27: db "27"
TEXTWORD28: db "28"
TEXTWORD29: db "29"
TEXTWORD30: db "30"
TEXTWORD31: db "31"

PAGEBREAK: db "--------------------------------------------------------------------------------"

  align 8 ; Align 64-Bit
VALUEWORD: dw -123456789

SRAVCHECK0:  dw $F8A432EB
SRAVCHECK1:  dw $FC521975
SRAVCHECK2:  dw $FE290CBA
SRAVCHECK3:  dw $FF14865D
SRAVCHECK4:  dw $FF8A432E
SRAVCHECK5:  dw $FFC52197
SRAVCHECK6:  dw $FFE290CB
SRAVCHECK7:  dw $FFF14865
SRAVCHECK8:  dw $FFF8A432
SRAVCHECK9:  dw $FFFC5219
SRAVCHECK10: dw $FFFE290C
SRAVCHECK11: dw $FFFF1486
SRAVCHECK12: dw $FFFF8A43
SRAVCHECK13: dw $FFFFC521
SRAVCHECK14: dw $FFFFE290
SRAVCHECK15: dw $FFFFF148
SRAVCHECK16: dw $FFFFF8A4
SRAVCHECK17: dw $FFFFFC52
SRAVCHECK18: dw $FFFFFE29
SRAVCHECK19: dw $FFFFFF14
SRAVCHECK20: dw $FFFFFF8A
SRAVCHECK21: dw $FFFFFFC5
SRAVCHECK22: dw $FFFFFFE2
SRAVCHECK23: dw $FFFFFFF1
SRAVCHECK24: dw $FFFFFFF8
SRAVCHECK25: dw $FFFFFFFC
SRAVCHECK26: dw $FFFFFFFE
SRAVCHECK27: dw $FFFFFFFF
SRAVCHECK28: dw $FFFFFFFF
SRAVCHECK29: dw $FFFFFFFF
SRAVCHECK30: dw $FFFFFFFF
SRAVCHECK31: dw $FFFFFFFF

RDWORD: dw 0

FontBlack: incbin FontBlack8x8.bin
FontGreen: incbin FontGreen8x8.bin
FontRed: incbin FontRed8x8.bin

  align 8 ; Align 64-Bit
RSPSRAV0Code:
  obj $0000 ; Set Base Of RSP Code Object To Zero
  la a0,$0000 ; A0 = RSP DMEM Offset
  lw t0,0(a0) ; T0 = Word Data 0
  li t1,0    ; T1 = Shift Amount
  srav t0,t1 ; T0 = Test Word Data
  sw t0,0(a0) ; RSP DMEM = Test Word Data
  break $0000 ; Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
  objend ; Set End Of RSP Code Object
RSPSRAV0CodeEND:

  align 8 ; Align 64-Bit
RSPSRAV1Code:
  obj $0000 ; Set Base Of RSP Code Object To Zero
  la a0,$0000 ; A0 = RSP DMEM Offset
  lw t0,0(a0) ; T0 = Word Data 0
  li t1,1    ; T1 = Shift Amount
  srav t0,t1 ; T0 = Test Word Data
  sw t0,0(a0) ; RSP DMEM = Test Word Data
  break $0000 ; Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
  objend ; Set End Of RSP Code Object
RSPSRAV1CodeEND:

  align 8 ; Align 64-Bit
RSPSRAV2Code:
  obj $0000 ; Set Base Of RSP Code Object To Zero
  la a0,$0000 ; A0 = RSP DMEM Offset
  lw t0,0(a0) ; T0 = Word Data 0
  li t1,2    ; T1 = Shift Amount
  srav t0,t1 ; T0 = Test Word Data
  sw t0,0(a0) ; RSP DMEM = Test Word Data
  break $0000 ; Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
  objend ; Set End Of RSP Code Object
RSPSRAV2CodeEND:

  align 8 ; Align 64-Bit
RSPSRAV3Code:
  obj $0000 ; Set Base Of RSP Code Object To Zero
  la a0,$0000 ; A0 = RSP DMEM Offset
  lw t0,0(a0) ; T0 = Word Data 0
  li t1,3    ; T1 = Shift Amount
  srav t0,t1 ; T0 = Test Word Data
  sw t0,0(a0) ; RSP DMEM = Test Word Data
  break $0000 ; Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
  objend ; Set End Of RSP Code Object
RSPSRAV3CodeEND:

  align 8 ; Align 64-Bit
RSPSRAV4Code:
  obj $0000 ; Set Base Of RSP Code Object To Zero
  la a0,$0000 ; A0 = RSP DMEM Offset
  lw t0,0(a0) ; T0 = Word Data 0
  li t1,4    ; T1 = Shift Amount
  srav t0,t1 ; T0 = Test Word Data
  sw t0,0(a0) ; RSP DMEM = Test Word Data
  break $0000 ; Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
  objend ; Set End Of RSP Code Object
RSPSRAV4CodeEND:

  align 8 ; Align 64-Bit
RSPSRAV5Code:
  obj $0000 ; Set Base Of RSP Code Object To Zero
  la a0,$0000 ; A0 = RSP DMEM Offset
  lw t0,0(a0) ; T0 = Word Data 0
  li t1,5    ; T1 = Shift Amount
  srav t0,t1 ; T0 = Test Word Data
  sw t0,0(a0) ; RSP DMEM = Test Word Data
  break $0000 ; Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
  objend ; Set End Of RSP Code Object
RSPSRAV5CodeEND:

  align 8 ; Align 64-Bit
RSPSRAV6Code:
  obj $0000 ; Set Base Of RSP Code Object To Zero
  la a0,$0000 ; A0 = RSP DMEM Offset
  lw t0,0(a0) ; T0 = Word Data 0
  li t1,6    ; T1 = Shift Amount
  srav t0,t1 ; T0 = Test Word Data
  sw t0,0(a0) ; RSP DMEM = Test Word Data
  break $0000 ; Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
  objend ; Set End Of RSP Code Object
RSPSRAV6CodeEND:

  align 8 ; Align 64-Bit
RSPSRAV7Code:
  obj $0000 ; Set Base Of RSP Code Object To Zero
  la a0,$0000 ; A0 = RSP DMEM Offset
  lw t0,0(a0) ; T0 = Word Data 0
  li t1,7    ; T1 = Shift Amount
  srav t0,t1 ; T0 = Test Word Data
  sw t0,0(a0) ; RSP DMEM = Test Word Data
  break $0000 ; Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
  objend ; Set End Of RSP Code Object
RSPSRAV7CodeEND:

  align 8 ; Align 64-Bit
RSPSRAV8Code:
  obj $0000 ; Set Base Of RSP Code Object To Zero
  la a0,$0000 ; A0 = RSP DMEM Offset
  lw t0,0(a0) ; T0 = Word Data 0
  li t1,8    ; T1 = Shift Amount
  srav t0,t1 ; T0 = Test Word Data
  sw t0,0(a0) ; RSP DMEM = Test Word Data
  break $0000 ; Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
  objend ; Set End Of RSP Code Object
RSPSRAV8CodeEND:

  align 8 ; Align 64-Bit
RSPSRAV9Code:
  obj $0000 ; Set Base Of RSP Code Object To Zero
  la a0,$0000 ; A0 = RSP DMEM Offset
  lw t0,0(a0) ; T0 = Word Data 0
  li t1,9    ; T1 = Shift Amount
  srav t0,t1 ; T0 = Test Word Data
  sw t0,0(a0) ; RSP DMEM = Test Word Data
  break $0000 ; Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
  objend ; Set End Of RSP Code Object
RSPSRAV9CodeEND:

  align 8 ; Align 64-Bit
RSPSRAV10Code:
  obj $0000 ; Set Base Of RSP Code Object To Zero
  la a0,$0000 ; A0 = RSP DMEM Offset
  lw t0,0(a0) ; T0 = Word Data 0
  li t1,10   ; T1 = Shift Amount
  srav t0,t1 ; T0 = Test Word Data
  sw t0,0(a0) ; RSP DMEM = Test Word Data
  break $0000 ; Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
  objend ; Set End Of RSP Code Object
RSPSRAV10CodeEND:

  align 8 ; Align 64-Bit
RSPSRAV11Code:
  obj $0000 ; Set Base Of RSP Code Object To Zero
  la a0,$0000 ; A0 = RSP DMEM Offset
  lw t0,0(a0) ; T0 = Word Data 0
  li t1,11   ; T1 = Shift Amount
  srav t0,t1 ; T0 = Test Word Data
  sw t0,0(a0) ; RSP DMEM = Test Word Data
  break $0000 ; Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
  objend ; Set End Of RSP Code Object
RSPSRAV11CodeEND:

  align 8 ; Align 64-Bit
RSPSRAV12Code:
  obj $0000 ; Set Base Of RSP Code Object To Zero
  la a0,$0000 ; A0 = RSP DMEM Offset
  lw t0,0(a0) ; T0 = Word Data 0
  li t1,12   ; T1 = Shift Amount
  srav t0,t1 ; T0 = Test Word Data
  sw t0,0(a0) ; RSP DMEM = Test Word Data
  break $0000 ; Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
  objend ; Set End Of RSP Code Object
RSPSRAV12CodeEND:

  align 8 ; Align 64-Bit
RSPSRAV13Code:
  obj $0000 ; Set Base Of RSP Code Object To Zero
  la a0,$0000 ; A0 = RSP DMEM Offset
  lw t0,0(a0) ; T0 = Word Data 0
  li t1,13   ; T1 = Shift Amount
  srav t0,t1 ; T0 = Test Word Data
  sw t0,0(a0) ; RSP DMEM = Test Word Data
  break $0000 ; Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
  objend ; Set End Of RSP Code Object
RSPSRAV13CodeEND:

  align 8 ; Align 64-Bit
RSPSRAV14Code:
  obj $0000 ; Set Base Of RSP Code Object To Zero
  la a0,$0000 ; A0 = RSP DMEM Offset
  lw t0,0(a0) ; T0 = Word Data 0
  li t1,14   ; T1 = Shift Amount
  srav t0,t1 ; T0 = Test Word Data
  sw t0,0(a0) ; RSP DMEM = Test Word Data
  break $0000 ; Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
  objend ; Set End Of RSP Code Object
RSPSRAV14CodeEND:

  align 8 ; Align 64-Bit
RSPSRAV15Code:
  obj $0000 ; Set Base Of RSP Code Object To Zero
  la a0,$0000 ; A0 = RSP DMEM Offset
  lw t0,0(a0) ; T0 = Word Data 0
  li t1,15   ; T1 = Shift Amount
  srav t0,t1 ; T0 = Test Word Data
  sw t0,0(a0) ; RSP DMEM = Test Word Data
  break $0000 ; Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
  objend ; Set End Of RSP Code Object
RSPSRAV15CodeEND:

  align 8 ; Align 64-Bit
RSPSRAV16Code:
  obj $0000 ; Set Base Of RSP Code Object To Zero
  la a0,$0000 ; A0 = RSP DMEM Offset
  lw t0,0(a0) ; T0 = Word Data 0
  li t1,16   ; T1 = Shift Amount
  srav t0,t1 ; T0 = Test Word Data
  sw t0,0(a0) ; RSP DMEM = Test Word Data
  break $0000 ; Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
  objend ; Set End Of RSP Code Object
RSPSRAV16CodeEND:

  align 8 ; Align 64-Bit
RSPSRAV17Code:
  obj $0000 ; Set Base Of RSP Code Object To Zero
  la a0,$0000 ; A0 = RSP DMEM Offset
  lw t0,0(a0) ; T0 = Word Data 0
  li t1,17   ; T1 = Shift Amount
  srav t0,t1 ; T0 = Test Word Data
  sw t0,0(a0) ; RSP DMEM = Test Word Data
  break $0000 ; Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
  objend ; Set End Of RSP Code Object
RSPSRAV17CodeEND:

  align 8 ; Align 64-Bit
RSPSRAV18Code:
  obj $0000 ; Set Base Of RSP Code Object To Zero
  la a0,$0000 ; A0 = RSP DMEM Offset
  lw t0,0(a0) ; T0 = Word Data 0
  li t1,18   ; T1 = Shift Amount
  srav t0,t1 ; T0 = Test Word Data
  sw t0,0(a0) ; RSP DMEM = Test Word Data
  break $0000 ; Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
  objend ; Set End Of RSP Code Object
RSPSRAV18CodeEND:

  align 8 ; Align 64-Bit
RSPSRAV19Code:
  obj $0000 ; Set Base Of RSP Code Object To Zero
  la a0,$0000 ; A0 = RSP DMEM Offset
  lw t0,0(a0) ; T0 = Word Data 0
  li t1,19   ; T1 = Shift Amount
  srav t0,t1 ; T0 = Test Word Data
  sw t0,0(a0) ; RSP DMEM = Test Word Data
  break $0000 ; Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
  objend ; Set End Of RSP Code Object
RSPSRAV19CodeEND:

  align 8 ; Align 64-Bit
RSPSRAV20Code:
  obj $0000 ; Set Base Of RSP Code Object To Zero
  la a0,$0000 ; A0 = RSP DMEM Offset
  lw t0,0(a0) ; T0 = Word Data 0
  li t1,20   ; T1 = Shift Amount
  srav t0,t1 ; T0 = Test Word Data
  sw t0,0(a0) ; RSP DMEM = Test Word Data
  break $0000 ; Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
  objend ; Set End Of RSP Code Object
RSPSRAV20CodeEND:

  align 8 ; Align 64-Bit
RSPSRAV21Code:
  obj $0000 ; Set Base Of RSP Code Object To Zero
  la a0,$0000 ; A0 = RSP DMEM Offset
  lw t0,0(a0) ; T0 = Word Data 0
  li t1,21   ; T1 = Shift Amount
  srav t0,t1 ; T0 = Test Word Data
  sw t0,0(a0) ; RSP DMEM = Test Word Data
  break $0000 ; Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
  objend ; Set End Of RSP Code Object
RSPSRAV21CodeEND:

  align 8 ; Align 64-Bit
RSPSRAV22Code:
  obj $0000 ; Set Base Of RSP Code Object To Zero
  la a0,$0000 ; A0 = RSP DMEM Offset
  lw t0,0(a0) ; T0 = Word Data 0
  li t1,22   ; T1 = Shift Amount
  srav t0,t1 ; T0 = Test Word Data
  sw t0,0(a0) ; RSP DMEM = Test Word Data
  break $0000 ; Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
  objend ; Set End Of RSP Code Object
RSPSRAV22CodeEND:

  align 8 ; Align 64-Bit
RSPSRAV23Code:
  obj $0000 ; Set Base Of RSP Code Object To Zero
  la a0,$0000 ; A0 = RSP DMEM Offset
  lw t0,0(a0) ; T0 = Word Data 0
  li t1,23   ; T1 = Shift Amount
  srav t0,t1 ; T0 = Test Word Data
  sw t0,0(a0) ; RSP DMEM = Test Word Data
  break $0000 ; Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
  objend ; Set End Of RSP Code Object
RSPSRAV23CodeEND:

  align 8 ; Align 64-Bit
RSPSRAV24Code:
  obj $0000 ; Set Base Of RSP Code Object To Zero
  la a0,$0000 ; A0 = RSP DMEM Offset
  lw t0,0(a0) ; T0 = Word Data 0
  li t1,24   ; T1 = Shift Amount
  srav t0,t1 ; T0 = Test Word Data
  sw t0,0(a0) ; RSP DMEM = Test Word Data
  break $0000 ; Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
  objend ; Set End Of RSP Code Object
RSPSRAV24CodeEND:

  align 8 ; Align 64-Bit
RSPSRAV25Code:
  obj $0000 ; Set Base Of RSP Code Object To Zero
  la a0,$0000 ; A0 = RSP DMEM Offset
  lw t0,0(a0) ; T0 = Word Data 0
  li t1,25   ; T1 = Shift Amount
  srav t0,t1 ; T0 = Test Word Data
  sw t0,0(a0) ; RSP DMEM = Test Word Data
  break $0000 ; Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
  objend ; Set End Of RSP Code Object
RSPSRAV25CodeEND:

  align 8 ; Align 64-Bit
RSPSRAV26Code:
  obj $0000 ; Set Base Of RSP Code Object To Zero
  la a0,$0000 ; A0 = RSP DMEM Offset
  lw t0,0(a0) ; T0 = Word Data 0
  li t1,26   ; T1 = Shift Amount
  srav t0,t1 ; T0 = Test Word Data
  sw t0,0(a0) ; RSP DMEM = Test Word Data
  break $0000 ; Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
  objend ; Set End Of RSP Code Object
RSPSRAV26CodeEND:

  align 8 ; Align 64-Bit
RSPSRAV27Code:
  obj $0000 ; Set Base Of RSP Code Object To Zero
  la a0,$0000 ; A0 = RSP DMEM Offset
  lw t0,0(a0) ; T0 = Word Data 0
  li t1,27   ; T1 = Shift Amount
  srav t0,t1 ; T0 = Test Word Data
  sw t0,0(a0) ; RSP DMEM = Test Word Data
  break $0000 ; Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
  objend ; Set End Of RSP Code Object
RSPSRAV27CodeEND:

  align 8 ; Align 64-Bit
RSPSRAV28Code:
  obj $0000 ; Set Base Of RSP Code Object To Zero
  la a0,$0000 ; A0 = RSP DMEM Offset
  lw t0,0(a0) ; T0 = Word Data 0
  li t1,28   ; T1 = Shift Amount
  srav t0,t1 ; T0 = Test Word Data
  sw t0,0(a0) ; RSP DMEM = Test Word Data
  break $0000 ; Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
  objend ; Set End Of RSP Code Object
RSPSRAV28CodeEND:

  align 8 ; Align 64-Bit
RSPSRAV29Code:
  obj $0000 ; Set Base Of RSP Code Object To Zero
  la a0,$0000 ; A0 = RSP DMEM Offset
  lw t0,0(a0) ; T0 = Word Data 0
  li t1,29   ; T1 = Shift Amount
  srav t0,t1 ; T0 = Test Word Data
  sw t0,0(a0) ; RSP DMEM = Test Word Data
  break $0000 ; Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
  objend ; Set End Of RSP Code Object
RSPSRAV29CodeEND:

  align 8 ; Align 64-Bit
RSPSRAV30Code:
  obj $0000 ; Set Base Of RSP Code Object To Zero
  la a0,$0000 ; A0 = RSP DMEM Offset
  lw t0,0(a0) ; T0 = Word Data 0
  li t1,30   ; T1 = Shift Amount
  srav t0,t1 ; T0 = Test Word Data
  sw t0,0(a0) ; RSP DMEM = Test Word Data
  break $0000 ; Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
  objend ; Set End Of RSP Code Object
RSPSRAV30CodeEND:

  align 8 ; Align 64-Bit
RSPSRAV31Code:
  obj $0000 ; Set Base Of RSP Code Object To Zero
  la a0,$0000 ; A0 = RSP DMEM Offset
  lw t0,0(a0) ; T0 = Word Data 0
  li t1,31   ; T1 = Shift Amount
  srav t0,t1 ; T0 = Test Word Data
  sw t0,0(a0) ; RSP DMEM = Test Word Data
  break $0000 ; Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
  objend ; Set End Of RSP Code Object
RSPSRAV31CodeEND: