; N64 'Bare Metal' RSP CPU Unsigned Word Addition Test Demo by krom (Peter Lemon):
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

  ScreenNTSC 640, 480, BPP32|INTERLACE|AA_MODE_2, $A0100000 ; Screen NTSC: 640x480, 32BPP, Interlace, Reample Only, DRAM Origin = $A0100000

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
  DMASPRD RSPADDUCode, RSPADDUCodeEND, SP_IMEM ; DMA Data Copy MEM->RSP RAM: Start Address, End Address, Destination DRAM Address

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

  PrintString $A010,8,24,FontRed,ADDU,3 ; Print Text String To VRAM Using Font At X,Y Position
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
  la a0,RDWORD     ; A0 = Word Data Offset
  lw t0,0(a0)      ; T0 = Word Data
  la a0,ADDUCHECKA ; A0 = Word Check Data Offset
  lw t1,0(a0)      ; T1 = Word Check Data
  beq t0,t1,ADDUPASSA ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,32,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j ADDUENDA
  nop ; Delay Slot
  ADDUPASSA:
  PrintString $A010,528,32,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  ADDUENDA:

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
  la a0,RDWORD     ; A0 = Word Data Offset
  lw t0,0(a0)      ; T0 = Word Data
  la a0,ADDUCHECKB ; A0 = Word Check Data Offset
  lw t1,0(a0)      ; T1 = Word Check Data
  beq t0,t1,ADDUPASSB ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,56,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j ADDUENDB
  nop ; Delay Slot
  ADDUPASSB:
  PrintString $A010,528,56,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  ADDUENDB:

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
  la a0,RDWORD     ; A0 = Word Data Offset
  lw t0,0(a0)      ; T0 = Word Data
  la a0,ADDUCHECKC ; A0 = Word Check Data Offset
  lw t1,0(a0)      ; T1 = Word Check Data
  beq t0,t1,ADDUPASSC ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,80,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j ADDUENDC
  nop ; Delay Slot
  ADDUPASSC:
  PrintString $A010,528,80,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  ADDUENDC:

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
  la a0,RDWORD     ; A0 = Word Data Offset
  lw t0,0(a0)      ; T0 = Word Data
  la a0,ADDUCHECKD ; A0 = Word Check Data Offset
  lw t1,0(a0)      ; T1 = Word Check Data
  beq t0,t1,ADDUPASSD ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,104,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j ADDUENDD
  nop ; Delay Slot
  ADDUPASSD:
  PrintString $A010,528,104,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  ADDUENDD:

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
  la a0,RDWORD     ; A0 = Word Data Offset
  lw t0,0(a0)      ; T0 = Word Data
  la a0,ADDUCHECKE ; A0 = Word Check Data Offset
  lw t1,0(a0)      ; T1 = Word Check Data
  beq t0,t1,ADDUPASSE ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,128,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j ADDUENDE
  nop ; Delay Slot
  ADDUPASSE:
  PrintString $A010,528,128,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  ADDUENDE:

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
  la a0,RDWORD     ; A0 = Word Data Offset
  lw t0,0(a0)      ; T0 = Word Data
  la a0,ADDUCHECKF ; A0 = Word Check Data Offset
  lw t1,0(a0)      ; T1 = Word Check Data
  beq t0,t1,ADDUPASSF ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,152,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j ADDUENDF
  nop ; Delay Slot
  ADDUPASSF:
  PrintString $A010,528,152,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  ADDUENDF:

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
  la a0,RDWORD     ; A0 = Word Data Offset
  lw t0,0(a0)      ; T0 = Word Data
  la a0,ADDUCHECKG ; A0 = Word Check Data Offset
  lw t1,0(a0)      ; T1 = Word Check Data
  beq t0,t1,ADDUPASSG ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,176,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j ADDUENDG
  nop ; Delay Slot
  ADDUPASSG:
  PrintString $A010,528,176,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  ADDUENDG:


  ; Load RSP Code To IMEM
  DMASPRD RSPADDIUCodeA, RSPADDIUCodeAEND, SP_IMEM ; DMA Data Copy MEM->RSP RAM: Start Address, End Address, Destination DRAM Address

  ; Load RSP Data To DMEM
  lui a0,SP_MEM_BASE ; A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORDA ; A1 = Word Data Offset
  lw t0,0(a1) ; T0 = Word Data
  sw t0,0(a0) ; Store Word Data To DMEM

  ; Set RSP Status (Start Execution)
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB ; T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) ; Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString $A010,8,192,FontRed,ADDIU,4 ; Print Text String To VRAM Using Font At X,Y Position
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
  la a0,RDWORD      ; A0 = Word Data Offset
  lw t0,0(a0)       ; T0 = Word Data
  la a0,ADDIUCHECKA ; A0 = Word Check Data Offset
  lw t1,0(a0)       ; T1 = Word Check Data
  beq t0,t1,ADDIUPASSA ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,200,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j ADDIUENDA
  nop ; Delay Slot
  ADDIUPASSA:
  PrintString $A010,528,200,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  ADDIUENDA:

  ; Load RSP Code To IMEM
  DMASPRD RSPADDIUCodeB, RSPADDIUCodeBEND, SP_IMEM ; DMA Data Copy MEM->RSP RAM: Start Address, End Address, Destination DRAM Address

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
  la a0,RDWORD      ; A0 = Word Data Offset
  lw t0,0(a0)       ; T0 = Word Data
  la a0,ADDIUCHECKB ; A0 = Word Check Data Offset
  lw t1,0(a0)       ; T1 = Word Check Data
  beq t0,t1,ADDIUPASSB ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,224,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j ADDIUENDB
  nop ; Delay Slot
  ADDIUPASSB:
  PrintString $A010,528,224,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  ADDIUENDB:

  ; Load RSP Code To IMEM
  DMASPRD RSPADDIUCodeC, RSPADDIUCodeCEND, SP_IMEM ; DMA Data Copy MEM->RSP RAM: Start Address, End Address, Destination DRAM Address

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
  la t0,RDWORD      ; T0 = Word Data Offset
  lw t1,0(t0)       ; T1 = Word Data
  la t0,ADDIUCHECKC ; T0 = Word Check Data Offset
  lw t2,0(t0)       ; T2 = Word Check Data
  beq t1,t2,ADDIUPASSC ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,248,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j ADDIUENDC
  nop ; Delay Slot
  ADDIUPASSC:
  PrintString $A010,528,248,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  ADDIUENDC:

  ; Load RSP Code To IMEM
  DMASPRD RSPADDIUCodeD, RSPADDIUCodeDEND, SP_IMEM ; DMA Data Copy MEM->RSP RAM: Start Address, End Address, Destination DRAM Address

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
  la a0,RDWORD      ; A0 = Word Data Offset
  lw t0,0(a0)       ; T0 = Word Data
  la a0,ADDIUCHECKD ; A0 = Word Check Data Offset
  lw t1,0(a0)       ; T1 = Word Check Data
  beq t0,t1,ADDIUPASSD ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,272,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j ADDIUENDD
  nop ; Delay Slot
  ADDIUPASSD:
  PrintString $A010,528,272,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  ADDIUENDD:

  ; Load RSP Code To IMEM
  DMASPRD RSPADDIUCodeE, RSPADDIUCodeEEND, SP_IMEM ; DMA Data Copy MEM->RSP RAM: Start Address, End Address, Destination DRAM Address

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
  PrintValue  $A010,152,296,FontBlack,IWORDF,3 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,336,296,FontBlack,TEXTIWORDF,3 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,440,296,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE ; A0 = Test Word Data Offset
  lw t0,0(a0) ; T0 = Test Word Data
  la a0,RDWORD ; A0 = RDWORD Offset
  sw t0,0(a0)  ; RDWORD = Word Data
  PrintValue  $A010,448,296,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD      ; T0 = Word Data Offset
  lw t1,0(t0)       ; T1 = Word Data
  la t0,ADDIUCHECKE ; T0 = Word Check Data Offset
  lw t2,0(t0)       ; T2 = Word Check Data
  beq t1,t2,ADDIUPASSE ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,296,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j ADDIUENDE
  nop ; Delay Slot
  ADDIUPASSE:
  PrintString $A010,528,296,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  ADDIUENDE:

  ; Load RSP Code To IMEM
  DMASPRD RSPADDIUCodeF, RSPADDIUCodeFEND, SP_IMEM ; DMA Data Copy MEM->RSP RAM: Start Address, End Address, Destination DRAM Address

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
  la a0,RDWORD      ; A0 = Word Data Offset
  lw t0,0(a0)       ; T0 = Word Data
  la a0,ADDIUCHECKF ; A0 = Word Check Data Offset
  lw t1,0(a0)       ; T1 = Word Check Data
  beq t0,t1,ADDIUPASSF ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,320,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j ADDIUENDF
  nop ; Delay Slot
  ADDIUPASSF:
  PrintString $A010,528,320,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  ADDIUENDF:

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
  la a0,RDWORD      ; A0 = Word Data Offset
  lw t0,0(a0)       ; T0 = Word Data
  la a0,ADDIUCHECKG ; A0 = Word Check Data Offset
  lw t1,0(a0)       ; T1 = Word Check Data
  beq t0,t1,ADDIUPASSG ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,344,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j ADDIUENDG
  nop ; Delay Slot
  ADDIUPASSG:
  PrintString $A010,528,344,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  ADDIUENDG:


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

ADDU: db "ADDU"
ADDIU: db "ADDIU"

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

ADDUCHECKA: dw $075BCD15
ADDUCHECKB: dw $075DAF55
ADDUCHECKC: dw $075D99A2
ADDUCHECKD: dw $50F0E13B
ADDUCHECKE: dw $49A80060
ADDUCHECKF: dw $49A8D95A
ADDUCHECKG: dw $499602D3

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

ADDIUCHECKA: dw $00003039
ADDIUCHECKB: dw $075BD1E7
ADDIUCHECKC: dw $00021275
ADDIUCHECKD: dw $00008BD5
ADDIUCHECKE: dw $49953759
ADDIUCHECKF: dw $0013544D
ADDIUCHECKG: dw $00007DC6

RDWORD: dw 0

FontBlack: incbin FontBlack8x8.bin
FontGreen: incbin FontGreen8x8.bin
FontRed: incbin FontRed8x8.bin

  align 8 ; Align 64-Bit
RSPADDUCode:
  obj $0000 ; Set Base Of RSP Code Object To Zero
  la a0,$0000 ; A0 = RSP DMEM Offset
  lw t0,0(a0) ; T0 = Word Data 0
  lw t1,4(a0) ; T1 = Word Data 1
  addu t0,t1 ; T0 = Test Word Data
  sw t0,0(a0) ; RSP DMEM = Test Word Data
  break $0000 ; Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
  objend ; Set End Of RSP Code Object
RSPADDUCodeEND:

  align 8 ; Align 64-Bit
RSPADDIUCodeA:
  obj $0000 ; Set Base Of RSP Code Object To Zero
  la a0,$0000 ; A0 = RSP DMEM Offset
  lw t0,0(a0) ; T0 = Word Data 0
  addiu t0,VALUEIWORDB ; T0 = Test Word Data
  sw t0,0(a0) ; RSP DMEM = Test Word Data
  break $0000 ; Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
  objend ; Set End Of RSP Code Object
RSPADDIUCodeAEND:

  align 8 ; Align 64-Bit
RSPADDIUCodeB:
  obj $0000 ; Set Base Of RSP Code Object To Zero
  la a0,$0000 ; A0 = RSP DMEM Offset
  lw t0,0(a0) ; T0 = Word Data 0
  addiu t0,VALUEIWORDC ; T0 = Test Word Data
  sw t0,0(a0) ; RSP DMEM = Test Word Data
  break $0000 ; Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
  objend ; Set End Of RSP Code Object
RSPADDIUCodeBEND:

  align 8 ; Align 64-Bit
RSPADDIUCodeC:
  obj $0000 ; Set Base Of RSP Code Object To Zero
  la a0,$0000 ; A0 = RSP DMEM Offset
  lw t0,0(a0) ; T0 = Word Data 0
  addiu t0,VALUEIWORDD ; T0 = Test Word Data
  sw t0,0(a0) ; RSP DMEM = Test Word Data
  break $0000 ; Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
  objend ; Set End Of RSP Code Object
RSPADDIUCodeCEND:

  align 8 ; Align 64-Bit
RSPADDIUCodeD:
  obj $0000 ; Set Base Of RSP Code Object To Zero
  la a0,$0000 ; A0 = RSP DMEM Offset
  lw t0,0(a0) ; T0 = Word Data 0
  addiu t0,VALUEIWORDE ; T0 = Test Word Data
  sw t0,0(a0) ; RSP DMEM = Test Word Data
  break $0000 ; Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
  objend ; Set End Of RSP Code Object
RSPADDIUCodeDEND:

  align 8 ; Align 64-Bit
RSPADDIUCodeE:
  obj $0000 ; Set Base Of RSP Code Object To Zero
  la a0,$0000 ; A0 = RSP DMEM Offset
  lw t0,0(a0) ; T0 = Word Data 0
  addiu t0,VALUEIWORDF ; T0 = Test Word Data
  sw t0,0(a0) ; RSP DMEM = Test Word Data
  break $0000 ; Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
  objend ; Set End Of RSP Code Object
RSPADDIUCodeEEND:

  align 8 ; Align 64-Bit
RSPADDIUCodeF:
  obj $0000 ; Set Base Of RSP Code Object To Zero
  la a0,$0000 ; A0 = RSP DMEM Offset
  lw t0,0(a0) ; T0 = Word Data 0
  addiu t0,VALUEIWORDG ; T0 = Test Word Data
  sw t0,0(a0) ; RSP DMEM = Test Word Data
  break $0000 ; Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
  objend ; Set End Of RSP Code Object
RSPADDIUCodeFEND: