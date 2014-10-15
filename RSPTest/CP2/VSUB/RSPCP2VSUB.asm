; N64 'Bare Metal' RSP CP2 Vector Subtract Short Elements Test Demo by krom (Peter Lemon):
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


  PrintString $A010,88,8,FontRed,VSVTHEX,10 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,336,8,FontRed,VDHEX,7 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,528,8,FontRed,TEST,10 ; Print Text String To VRAM Using Font At X,Y Position


  PrintString $A010,0,16,FontBlack,PAGEBREAK,79 ; Print Text String To VRAM Using Font At X,Y Position


  ; Load RSP Code To IMEM
  DMASPRD RSPVSUBCode, RSPVSUBCodeEND, SP_IMEM ; DMA Data Read MEM->RSP DRAM: Start Address, End Address, Destination RSP DRAM Address

  ; Load RSP Data To DMEM
  DMASPRD VALUEQUADA, VALUEQUADAEND, SP_DMEM    ; DMA Data Read MEM->RSP DRAM: Start Address, End Address, Destination RSP DRAM Address
  DMASPRD VALUEQUADB, VALUEQUADBEND, SP_DMEM+16 ; DMA Data Read MEM->RSP DRAM: Start Address, End Address, Destination RSP DRAM Address

  ; Set RSP Program Counter
  lui a0,SP_PC_BASE ; A0 = SP PC Base Register ($A4080000)
  li t0,$0000 ; T0 = RSP Program Counter Set To Zero (Start Of RSP Code)
  sw t0,SP_PC(a0) ; Store RSP Program Counter To SP PC Register ($A4080000)

  ; Set RSP Status (Start Execution)
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB ; T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) ; Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString $A010,8,24,FontRed,VSUBTEXT,3 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,80,24,FontBlack,DOLLAR,0         ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,24,FontBlack,VALUEQUADA,1     ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,128,24,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,136,24,FontBlack,VALUEQUADA+2,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,176,24,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,184,24,FontBlack,VALUEQUADA+4,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,224,24,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,232,24,FontBlack,VALUEQUADA+6,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,80,32,FontBlack,DOLLAR,0         ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,32,FontBlack,VALUEQUADA+8,1   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,128,32,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,136,32,FontBlack,VALUEQUADA+10,1 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,176,32,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,184,32,FontBlack,VALUEQUADA+12,1 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,224,32,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,232,32,FontBlack,VALUEQUADA+14,1 ; Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString $A010,80,48,FontBlack,DOLLAR,0         ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,48,FontBlack,VALUEQUADB,1     ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,128,48,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,136,48,FontBlack,VALUEQUADB+2,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,176,48,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,184,48,FontBlack,VALUEQUADB+4,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,224,48,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,232,48,FontBlack,VALUEQUADB+6,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,80,56,FontBlack,DOLLAR,0         ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,56,FontBlack,VALUEQUADB+8,1   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,128,56,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,136,56,FontBlack,VALUEQUADB+10,1 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,176,56,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,184,56,FontBlack,VALUEQUADB+12,1 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,224,56,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,232,56,FontBlack,VALUEQUADB+14,1 ; Print HEX Chars To VRAM Using Font At X,Y Position

  ; Store RSP Data To MEM
  lui a0,SP_MEM_BASE ; A0 = SP Memory Base Offset (DMEM)
  la a1,VDQUAD ; A1 = Quad Data Offset
  lw t0,0(a0)  ; T0 = Quad Data
  sw t0,0(a1)  ; Store Quad Data To MEM
  lw t0,4(a0)  ; T0 = Quad Data
  sw t0,4(a1)  ; Store Quad Data To MEM
  lw t0,8(a0)  ; T0 = Quad Data
  sw t0,8(a1)  ; Store Quad Data To MEM
  lw t0,12(a0) ; T0 = Quad Data
  sw t0,12(a1) ; Store Quad Data To MEM

  PrintString $A010,328,48,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,336,48,FontBlack,VDQUAD,1    ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,376,48,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,48,FontBlack,VDQUAD+2,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,424,48,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,432,48,FontBlack,VDQUAD+4,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,472,48,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,480,48,FontBlack,VDQUAD+6,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,328,56,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,336,56,FontBlack,VDQUAD+8,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,376,56,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,56,FontBlack,VDQUAD+10,1 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,424,56,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,432,56,FontBlack,VDQUAD+12,1 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,472,56,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,480,56,FontBlack,VDQUAD+14,1 ; Print HEX Chars To VRAM Using Font At X,Y Position
  la a0,VDQUAD     ; A0 = Quad Data Offset
  ld t0,0(a0)      ; T0 = Quad Data
  la a0,VSUBCHECKA ; A0 = Quad Check Data Offset
  ld t1,0(a0)      ; T1 = Quad Check Data
  bne t0,t1,VSUBFAILA ; Compare Result Equality With Check Data
  nop ; Delay Slot
  la a0,VDQUAD     ; A0 = Quad Data Offset
  ld t0,8(a0)      ; T0 = Quad Data
  la a0,VSUBCHECKA ; A0 = Quad Check Data Offset
  ld t1,8(a0)      ; T1 = Quad Check Data
  bne t0,t1,VSUBFAILA ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,56,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  j VSUBENDA
  nop ; Delay Slot
  VSUBFAILA:
  PrintString $A010,528,56,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  VSUBENDA:

  PrintString $A010,0,64,FontBlack,PAGEBREAK,79 ; Print Text String To VRAM Using Font At X,Y Position


  ; Load RSP Data To MEM
  DMASPRD VALUEQUADB, VALUEQUADBEND, SP_DMEM    ; DMA Data Read MEM->RSP DRAM: Start Address, End Address, Destination RSP DRAM Address
  DMASPRD VALUEQUADB, VALUEQUADBEND, SP_DMEM+16 ; DMA Data Read MEM->RSP DRAM: Start Address, End Address, Destination RSP DRAM Address

  ; Set RSP Status (Start Execution)
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB ; T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) ; Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString $A010,80,72,FontBlack,DOLLAR,0         ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,72,FontBlack,VALUEQUADB,1     ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,128,72,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,136,72,FontBlack,VALUEQUADB+2,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,176,72,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,184,72,FontBlack,VALUEQUADB+4,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,224,72,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,232,72,FontBlack,VALUEQUADB+6,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,80,80,FontBlack,DOLLAR,0         ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,80,FontBlack,VALUEQUADB+8,1   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,128,80,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,136,80,FontBlack,VALUEQUADB+10,1 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,176,80,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,184,80,FontBlack,VALUEQUADB+12,1 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,224,80,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,232,80,FontBlack,VALUEQUADB+14,1 ; Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString $A010,80,96,FontBlack,DOLLAR,0         ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,96,FontBlack,VALUEQUADB,1     ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,128,96,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,136,96,FontBlack,VALUEQUADB+2,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,176,96,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,184,96,FontBlack,VALUEQUADB+4,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,224,96,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,232,96,FontBlack,VALUEQUADB+6,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,80,104,FontBlack,DOLLAR,0         ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,104,FontBlack,VALUEQUADB+8,1   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,128,104,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,136,104,FontBlack,VALUEQUADB+10,1 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,176,104,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,184,104,FontBlack,VALUEQUADB+12,1 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,224,104,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,232,104,FontBlack,VALUEQUADB+14,1 ; Print HEX Chars To VRAM Using Font At X,Y Position

  ; Store RSP Data To MEM
  lui a0,SP_MEM_BASE ; A0 = SP Memory Base Offset (DMEM)
  la a1,VDQUAD ; A1 = Quad Data Offset
  lw t0,0(a0)  ; T0 = Quad Data
  sw t0,0(a1)  ; Store Quad Data To MEM
  lw t0,4(a0)  ; T0 = Quad Data
  sw t0,4(a1)  ; Store Quad Data To MEM
  lw t0,8(a0)  ; T0 = Quad Data
  sw t0,8(a1)  ; Store Quad Data To MEM
  lw t0,12(a0) ; T0 = Quad Data
  sw t0,12(a1) ; Store Quad Data To MEM

  PrintString $A010,328,96,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,336,96,FontBlack,VDQUAD,1    ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,376,96,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,96,FontBlack,VDQUAD+2,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,424,96,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,432,96,FontBlack,VDQUAD+4,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,472,96,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,480,96,FontBlack,VDQUAD+6,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,328,104,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,336,104,FontBlack,VDQUAD+8,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,376,104,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,104,FontBlack,VDQUAD+10,1 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,424,104,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,432,104,FontBlack,VDQUAD+12,1 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,472,104,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,480,104,FontBlack,VDQUAD+14,1 ; Print HEX Chars To VRAM Using Font At X,Y Position
  la a0,VDQUAD     ; A0 = Quad Data Offset
  ld t0,0(a0)      ; T0 = Quad Data
  la a0,VSUBCHECKB ; A0 = Quad Check Data Offset
  ld t1,0(a0)      ; T1 = Quad Check Data
  bne t0,t1,VSUBFAILB ; Compare Result Equality With Check Data
  nop ; Delay Slot
  la a0,VDQUAD     ; A0 = Quad Data Offset
  ld t0,8(a0)      ; T0 = Quad Data
  la a0,VSUBCHECKB ; A0 = Quad Check Data Offset
  ld t1,8(a0)      ; T1 = Quad Check Data
  bne t0,t1,VSUBFAILB ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,104,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  j VSUBENDB
  nop ; Delay Slot
  VSUBFAILB:
  PrintString $A010,528,104,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  VSUBENDB:

  PrintString $A010,0,112,FontBlack,PAGEBREAK,79 ; Print Text String To VRAM Using Font At X,Y Position


  ; Load RSP Data To MEM
  DMASPRD VALUEQUADB, VALUEQUADBEND, SP_DMEM    ; DMA Data Read MEM->RSP DRAM: Start Address, End Address, Destination RSP DRAM Address
  DMASPRD VALUEQUADC, VALUEQUADCEND, SP_DMEM+16 ; DMA Data Read MEM->RSP DRAM: Start Address, End Address, Destination RSP DRAM Address

  ; Set RSP Status (Start Execution)
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB ; T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) ; Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString $A010,80,120,FontBlack,DOLLAR,0         ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,120,FontBlack,VALUEQUADB,1     ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,128,120,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,136,120,FontBlack,VALUEQUADB+2,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,176,120,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,184,120,FontBlack,VALUEQUADB+4,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,224,120,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,232,120,FontBlack,VALUEQUADB+6,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,80,128,FontBlack,DOLLAR,0         ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,128,FontBlack,VALUEQUADB+8,1   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,128,128,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,136,128,FontBlack,VALUEQUADB+10,1 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,176,128,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,184,128,FontBlack,VALUEQUADB+12,1 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,224,128,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,232,128,FontBlack,VALUEQUADB+14,1 ; Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString $A010,80,144,FontBlack,DOLLAR,0         ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,144,FontBlack,VALUEQUADC,1     ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,128,144,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,136,144,FontBlack,VALUEQUADC+2,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,176,144,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,184,144,FontBlack,VALUEQUADC+4,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,224,144,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,232,144,FontBlack,VALUEQUADC+6,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,80,152,FontBlack,DOLLAR,0         ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,152,FontBlack,VALUEQUADC+8,1   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,128,152,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,136,152,FontBlack,VALUEQUADC+10,1 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,176,152,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,184,152,FontBlack,VALUEQUADC+12,1 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,224,152,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,232,152,FontBlack,VALUEQUADC+14,1 ; Print HEX Chars To VRAM Using Font At X,Y Position

  ; Store RSP Data To MEM
  lui a0,SP_MEM_BASE ; A0 = SP Memory Base Offset (DMEM)
  la a1,VDQUAD ; A1 = Quad Data Offset
  lw t0,0(a0)  ; T0 = Quad Data
  sw t0,0(a1)  ; Store Quad Data To MEM
  lw t0,4(a0)  ; T0 = Quad Data
  sw t0,4(a1)  ; Store Quad Data To MEM
  lw t0,8(a0)  ; T0 = Quad Data
  sw t0,8(a1)  ; Store Quad Data To MEM
  lw t0,12(a0) ; T0 = Quad Data
  sw t0,12(a1) ; Store Quad Data To MEM

  PrintString $A010,328,144,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,336,144,FontBlack,VDQUAD,1    ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,376,144,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,144,FontBlack,VDQUAD+2,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,424,144,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,432,144,FontBlack,VDQUAD+4,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,472,144,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,480,144,FontBlack,VDQUAD+6,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,328,152,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,336,152,FontBlack,VDQUAD+8,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,376,152,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,152,FontBlack,VDQUAD+10,1 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,424,152,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,432,152,FontBlack,VDQUAD+12,1 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,472,152,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,480,152,FontBlack,VDQUAD+14,1 ; Print HEX Chars To VRAM Using Font At X,Y Position
  la a0,VDQUAD     ; A0 = Quad Data Offset
  ld t0,0(a0)      ; T0 = Quad Data
  la a0,VSUBCHECKC ; A0 = Quad Check Data Offset
  ld t1,0(a0)      ; T1 = Quad Check Data
  bne t0,t1,VSUBFAILC ; Compare Result Equality With Check Data
  nop ; Delay Slot
  la a0,VDQUAD     ; A0 = Quad Data Offset
  ld t0,8(a0)      ; T0 = Quad Data
  la a0,VSUBCHECKC ; A0 = Quad Check Data Offset
  ld t1,8(a0)      ; T1 = Quad Check Data
  bne t0,t1,VSUBFAILC ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,152,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  j VSUBENDC
  nop ; Delay Slot
  VSUBFAILC:
  PrintString $A010,528,152,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  VSUBENDC:

  PrintString $A010,0,160,FontBlack,PAGEBREAK,79 ; Print Text String To VRAM Using Font At X,Y Position


  ; Load RSP Data To DMEM
  DMASPRD VALUEQUADC, VALUEQUADCEND, SP_DMEM    ; DMA Data Read MEM->RSP DRAM: Start Address, End Address, Destination RSP DRAM Address
  DMASPRD VALUEQUADC, VALUEQUADCEND, SP_DMEM+16 ; DMA Data Read MEM->RSP DRAM: Start Address, End Address, Destination RSP DRAM Address

  ; Set RSP Status (Start Execution)
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB ; T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) ; Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString $A010,80,168,FontBlack,DOLLAR,0         ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,168,FontBlack,VALUEQUADC,1     ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,128,168,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,136,168,FontBlack,VALUEQUADC+2,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,176,168,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,184,168,FontBlack,VALUEQUADC+4,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,224,168,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,232,168,FontBlack,VALUEQUADC+6,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,80,176,FontBlack,DOLLAR,0         ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,176,FontBlack,VALUEQUADC+8,1   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,128,176,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,136,176,FontBlack,VALUEQUADC+10,1 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,176,176,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,184,176,FontBlack,VALUEQUADC+12,1 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,224,176,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,232,176,FontBlack,VALUEQUADC+14,1 ; Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString $A010,80,192,FontBlack,DOLLAR,0         ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,192,FontBlack,VALUEQUADC,1     ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,128,192,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,136,192,FontBlack,VALUEQUADC+2,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,176,192,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,184,192,FontBlack,VALUEQUADC+4,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,224,192,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,232,192,FontBlack,VALUEQUADC+6,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,80,200,FontBlack,DOLLAR,0         ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,200,FontBlack,VALUEQUADC+8,1   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,128,200,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,136,200,FontBlack,VALUEQUADC+10,1 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,176,200,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,184,200,FontBlack,VALUEQUADC+12,1 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,224,200,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,232,200,FontBlack,VALUEQUADC+14,1 ; Print HEX Chars To VRAM Using Font At X,Y Position

  ; Store RSP Data To MEM
  lui a0,SP_MEM_BASE ; A0 = SP Memory Base Offset (DMEM)
  la a1,VDQUAD ; A1 = Quad Data Offset
  lw t0,0(a0)  ; T0 = Quad Data
  sw t0,0(a1)  ; Store Quad Data To MEM
  lw t0,4(a0)  ; T0 = Quad Data
  sw t0,4(a1)  ; Store Quad Data To MEM
  lw t0,8(a0)  ; T0 = Quad Data
  sw t0,8(a1)  ; Store Quad Data To MEM
  lw t0,12(a0) ; T0 = Quad Data
  sw t0,12(a1) ; Store Quad Data To MEM

  PrintString $A010,328,192,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,336,192,FontBlack,VDQUAD,1    ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,376,192,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,192,FontBlack,VDQUAD+2,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,424,192,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,432,192,FontBlack,VDQUAD+4,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,472,192,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,480,192,FontBlack,VDQUAD+6,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,328,200,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,336,200,FontBlack,VDQUAD+8,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,376,200,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,200,FontBlack,VDQUAD+10,1 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,424,200,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,432,200,FontBlack,VDQUAD+12,1 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,472,200,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,480,200,FontBlack,VDQUAD+14,1 ; Print HEX Chars To VRAM Using Font At X,Y Position
  la a0,VDQUAD     ; A0 = Quad Data Offset
  ld t0,0(a0)      ; T0 = Quad Data
  la a0,VSUBCHECKD ; A0 = Quad Check Data Offset
  ld t1,0(a0)      ; T1 = Quad Check Data
  bne t0,t1,VSUBFAILD ; Compare Result Equality With Check Data
  nop ; Delay Slot
  la a0,VDQUAD     ; A0 = Quad Data Offset
  ld t0,8(a0)      ; T0 = Quad Data
  la a0,VSUBCHECKD ; A0 = Quad Check Data Offset
  ld t1,8(a0)      ; T1 = Quad Check Data
  bne t0,t1,VSUBFAILD ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,200,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  j VSUBENDD
  nop ; Delay Slot
  VSUBFAILD:
  PrintString $A010,528,200,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  VSUBENDD:

  PrintString $A010,0,208,FontBlack,PAGEBREAK,79 ; Print Text String To VRAM Using Font At X,Y Position


  ; Load RSP Code To IMEM
  DMASPRD RSPVSUBCCode, RSPVSUBCCodeEND, SP_IMEM ; DMA Data Read MEM->RSP DRAM: Start Address, End Address, Destination RSP DRAM Address

  ; Load RSP Data To DMEM
  DMASPRD VALUEQUADA, VALUEQUADAEND, SP_DMEM    ; DMA Data Read MEM->RSP DRAM: Start Address, End Address, Destination RSP DRAM Address
  DMASPRD VALUEQUADB, VALUEQUADBEND, SP_DMEM+16 ; DMA Data Read MEM->RSP DRAM: Start Address, End Address, Destination RSP DRAM Address

  ; Set RSP Program Counter
  lui a0,SP_PC_BASE ; A0 = SP PC Base Register ($A4080000)
  li t0,$0000 ; T0 = RSP Program Counter Set To Zero (Start Of RSP Code)
  sw t0,SP_PC(a0) ; Store RSP Program Counter To SP PC Register ($A4080000)

  ; Set RSP Status (Start Execution)
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB ; T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) ; Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString $A010,8,216,FontRed,VSUBCTEXT,4 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,80,216,FontBlack,DOLLAR,0         ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,216,FontBlack,VALUEQUADA,1     ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,128,216,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,136,216,FontBlack,VALUEQUADA+2,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,176,216,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,184,216,FontBlack,VALUEQUADA+4,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,224,216,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,232,216,FontBlack,VALUEQUADA+6,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,80,224,FontBlack,DOLLAR,0         ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,224,FontBlack,VALUEQUADA+8,1   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,128,224,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,136,224,FontBlack,VALUEQUADA+10,1 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,176,224,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,184,224,FontBlack,VALUEQUADA+12,1 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,224,224,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,232,224,FontBlack,VALUEQUADA+14,1 ; Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString $A010,80,240,FontBlack,DOLLAR,0         ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,240,FontBlack,VALUEQUADB,1     ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,128,240,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,136,240,FontBlack,VALUEQUADB+2,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,176,240,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,184,240,FontBlack,VALUEQUADB+4,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,224,240,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,232,240,FontBlack,VALUEQUADB+6,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,80,248,FontBlack,DOLLAR,0         ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,248,FontBlack,VALUEQUADB+8,1   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,128,248,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,136,248,FontBlack,VALUEQUADB+10,1 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,176,248,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,184,248,FontBlack,VALUEQUADB+12,1 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,224,248,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,232,248,FontBlack,VALUEQUADB+14,1 ; Print HEX Chars To VRAM Using Font At X,Y Position

  ; Store RSP Data To MEM
  lui a0,SP_MEM_BASE ; A0 = SP Memory Base Offset (DMEM)
  la a1,VDQUAD ; A1 = Quad Data Offset
  lw t0,0(a0)  ; T0 = Quad Data
  sw t0,0(a1)  ; Store Quad Data To MEM
  lw t0,4(a0)  ; T0 = Quad Data
  sw t0,4(a1)  ; Store Quad Data To MEM
  lw t0,8(a0)  ; T0 = Quad Data
  sw t0,8(a1)  ; Store Quad Data To MEM
  lw t0,12(a0) ; T0 = Quad Data
  sw t0,12(a1) ; Store Quad Data To MEM

  PrintString $A010,328,240,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,336,240,FontBlack,VDQUAD,1    ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,376,240,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,240,FontBlack,VDQUAD+2,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,424,240,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,432,240,FontBlack,VDQUAD+4,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,472,240,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,480,240,FontBlack,VDQUAD+6,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,328,248,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,336,248,FontBlack,VDQUAD+8,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,376,248,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,248,FontBlack,VDQUAD+10,1 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,424,248,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,432,248,FontBlack,VDQUAD+12,1 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,472,248,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,480,248,FontBlack,VDQUAD+14,1 ; Print HEX Chars To VRAM Using Font At X,Y Position
  la a0,VDQUAD      ; A0 = Quad Data Offset
  ld t0,0(a0)       ; T0 = Quad Data
  la a0,VSUBCCHECKA ; A0 = Quad Check Data Offset
  ld t1,0(a0)       ; T1 = Quad Check Data
  bne t0,t1,VSUBCFAILA ; Compare Result Equality With Check Data
  nop ; Delay Slot
  la a0,VDQUAD      ; A0 = Quad Data Offset
  ld t0,8(a0)       ; T0 = Quad Data
  la a0,VSUBCCHECKA ; A0 = Quad Check Data Offset
  ld t1,8(a0)       ; T1 = Quad Check Data
  bne t0,t1,VSUBCFAILA ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,248,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  j VSUBCENDA
  nop ; Delay Slot
  VSUBCFAILA:
  PrintString $A010,528,248,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  VSUBCENDA:

  PrintString $A010,0,256,FontBlack,PAGEBREAK,79 ; Print Text String To VRAM Using Font At X,Y Position


  ; Load RSP Data To DMEM
  DMASPRD VALUEQUADB, VALUEQUADBEND, SP_DMEM    ; DMA Data Read MEM->RSP DRAM: Start Address, End Address, Destination RSP DRAM Address
  DMASPRD VALUEQUADB, VALUEQUADBEND, SP_DMEM+16 ; DMA Data Read MEM->RSP DRAM: Start Address, End Address, Destination RSP DRAM Address

  ; Set RSP Status (Start Execution)
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB ; T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) ; Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString $A010,80,264,FontBlack,DOLLAR,0         ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,264,FontBlack,VALUEQUADB,1     ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,128,264,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,136,264,FontBlack,VALUEQUADB+2,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,176,264,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,184,264,FontBlack,VALUEQUADB+4,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,224,264,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,232,264,FontBlack,VALUEQUADB+6,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,80,272,FontBlack,DOLLAR,0         ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,272,FontBlack,VALUEQUADB+8,1   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,128,272,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,136,272,FontBlack,VALUEQUADB+10,1 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,176,272,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,184,272,FontBlack,VALUEQUADB+12,1 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,224,272,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,232,272,FontBlack,VALUEQUADB+14,1 ; Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString $A010,80,288,FontBlack,DOLLAR,0         ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,288,FontBlack,VALUEQUADB,1     ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,128,288,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,136,288,FontBlack,VALUEQUADB+2,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,176,288,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,184,288,FontBlack,VALUEQUADB+4,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,224,288,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,232,288,FontBlack,VALUEQUADB+6,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,80,296,FontBlack,DOLLAR,0         ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,296,FontBlack,VALUEQUADB+8,1   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,128,296,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,136,296,FontBlack,VALUEQUADB+10,1 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,176,296,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,184,296,FontBlack,VALUEQUADB+12,1 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,224,296,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,232,296,FontBlack,VALUEQUADB+14,1 ; Print HEX Chars To VRAM Using Font At X,Y Position

  ; Store RSP Data To MEM
  lui a0,SP_MEM_BASE ; A0 = SP Memory Base Offset (DMEM)
  la a1,VDQUAD ; A1 = Quad Data Offset
  lw t0,0(a0)  ; T0 = Quad Data
  sw t0,0(a1)  ; Store Quad Data To MEM
  lw t0,4(a0)  ; T0 = Quad Data
  sw t0,4(a1)  ; Store Quad Data To MEM
  lw t0,8(a0)  ; T0 = Quad Data
  sw t0,8(a1)  ; Store Quad Data To MEM
  lw t0,12(a0) ; T0 = Quad Data
  sw t0,12(a1) ; Store Quad Data To MEM

  PrintString $A010,328,288,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,336,288,FontBlack,VDQUAD,1    ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,376,288,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,288,FontBlack,VDQUAD+2,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,424,288,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,432,288,FontBlack,VDQUAD+4,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,472,288,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,480,288,FontBlack,VDQUAD+6,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,328,296,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,336,296,FontBlack,VDQUAD+8,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,376,296,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,296,FontBlack,VDQUAD+10,1 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,424,296,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,432,296,FontBlack,VDQUAD+12,1 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,472,296,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,480,296,FontBlack,VDQUAD+14,1 ; Print HEX Chars To VRAM Using Font At X,Y Position
  la a0,VDQUAD      ; A0 = Quad Data Offset
  ld t0,0(a0)       ; T0 = Quad Data
  la a0,VSUBCCHECKB ; A0 = Quad Check Data Offset
  ld t1,0(a0)       ; T1 = Quad Check Data
  bne t0,t1,VSUBCFAILB ; Compare Result Equality With Check Data
  nop ; Delay Slot
  la a0,VDQUAD      ; A0 = Quad Data Offset
  ld t0,8(a0)       ; T0 = Quad Data
  la a0,VSUBCCHECKB ; A0 = Quad Check Data Offset
  ld t1,8(a0)       ; T1 = Quad Check Data
  bne t0,t1,VSUBCFAILB ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,296,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  j VSUBCENDB
  nop ; Delay Slot
  VSUBCFAILB:
  PrintString $A010,528,296,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  VSUBCENDB:

  PrintString $A010,0,304,FontBlack,PAGEBREAK,79 ; Print Text String To VRAM Using Font At X,Y Position


  ; Load RSP Data To DMEM
  DMASPRD VALUEQUADB, VALUEQUADBEND, SP_DMEM    ; DMA Data Read MEM->RSP DRAM: Start Address, End Address, Destination RSP DRAM Address
  DMASPRD VALUEQUADC, VALUEQUADCEND, SP_DMEM+16 ; DMA Data Read MEM->RSP DRAM: Start Address, End Address, Destination RSP DRAM Address

  ; Set RSP Status (Start Execution)
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB ; T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) ; Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString $A010,80,312,FontBlack,DOLLAR,0         ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,312,FontBlack,VALUEQUADB,1     ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,128,312,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,136,312,FontBlack,VALUEQUADB+2,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,176,312,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,184,312,FontBlack,VALUEQUADB+4,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,224,312,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,232,312,FontBlack,VALUEQUADB+6,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,80,320,FontBlack,DOLLAR,0         ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,320,FontBlack,VALUEQUADB+8,1   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,128,320,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,136,320,FontBlack,VALUEQUADB+10,1 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,176,320,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,184,320,FontBlack,VALUEQUADB+12,1 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,224,320,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,232,320,FontBlack,VALUEQUADB+14,1 ; Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString $A010,80,336,FontBlack,DOLLAR,0         ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,336,FontBlack,VALUEQUADC,1     ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,128,336,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,136,336,FontBlack,VALUEQUADC+2,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,176,336,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,184,336,FontBlack,VALUEQUADC+4,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,224,336,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,232,336,FontBlack,VALUEQUADC+6,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,80,344,FontBlack,DOLLAR,0         ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,344,FontBlack,VALUEQUADC+8,1   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,128,344,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,136,344,FontBlack,VALUEQUADC+10,1 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,176,344,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,184,344,FontBlack,VALUEQUADC+12,1 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,224,344,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,232,344,FontBlack,VALUEQUADC+14,1 ; Print HEX Chars To VRAM Using Font At X,Y Position

  ; Store RSP Data To MEM
  lui a0,SP_MEM_BASE ; A0 = SP Memory Base Offset (DMEM)
  la a1,VDQUAD ; A1 = Quad Data Offset
  lw t0,0(a0)  ; T0 = Quad Data
  sw t0,0(a1)  ; Store Quad Data To MEM
  lw t0,4(a0)  ; T0 = Quad Data
  sw t0,4(a1)  ; Store Quad Data To MEM
  lw t0,8(a0)  ; T0 = Quad Data
  sw t0,8(a1)  ; Store Quad Data To MEM
  lw t0,12(a0) ; T0 = Quad Data
  sw t0,12(a1) ; Store Quad Data To MEM

  PrintString $A010,328,336,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,336,336,FontBlack,VDQUAD,1    ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,376,336,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,336,FontBlack,VDQUAD+2,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,424,336,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,432,336,FontBlack,VDQUAD+4,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,472,336,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,480,336,FontBlack,VDQUAD+6,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,328,344,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,336,344,FontBlack,VDQUAD+8,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,376,344,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,344,FontBlack,VDQUAD+10,1 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,424,344,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,432,344,FontBlack,VDQUAD+12,1 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,472,344,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,480,344,FontBlack,VDQUAD+14,1 ; Print HEX Chars To VRAM Using Font At X,Y Position
  la a0,VDQUAD      ; A0 = Quad Data Offset
  ld t0,0(a0)       ; T0 = Quad Data
  la a0,VSUBCCHECKC ; A0 = Quad Check Data Offset
  ld t1,0(a0)       ; T1 = Quad Check Data
  bne t0,t1,VSUBCFAILC ; Compare Result Equality With Check Data
  nop ; Delay Slot
  la a0,VDQUAD      ; A0 = Quad Data Offset
  ld t0,8(a0)       ; T0 = Quad Data
  la a0,VSUBCCHECKC ; A0 = Quad Check Data Offset
  ld t1,8(a0)       ; T1 = Quad Check Data
  bne t0,t1,VSUBCFAILC ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,344,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  j VSUBCENDC
  nop ; Delay Slot
  VSUBCFAILC:
  PrintString $A010,528,344,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  VSUBCENDC:

  PrintString $A010,0,352,FontBlack,PAGEBREAK,79 ; Print Text String To VRAM Using Font At X,Y Position


  ; Load RSP Data To DMEM
  DMASPRD VALUEQUADC, VALUEQUADCEND, SP_DMEM    ; DMA Data Read MEM->RSP DRAM: Start Address, End Address, Destination RSP DRAM Address
  DMASPRD VALUEQUADC, VALUEQUADCEND, SP_DMEM+16 ; DMA Data Read MEM->RSP DRAM: Start Address, End Address, Destination RSP DRAM Address

  ; Set RSP Status (Start Execution)
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB ; T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) ; Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString $A010,80,360,FontBlack,DOLLAR,0         ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,360,FontBlack,VALUEQUADC,1     ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,128,360,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,136,360,FontBlack,VALUEQUADC+2,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,176,360,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,184,360,FontBlack,VALUEQUADC+4,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,224,360,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,232,360,FontBlack,VALUEQUADC+6,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,80,368,FontBlack,DOLLAR,0         ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,368,FontBlack,VALUEQUADC+8,1   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,128,368,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,136,368,FontBlack,VALUEQUADC+10,1 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,176,368,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,184,368,FontBlack,VALUEQUADC+12,1 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,224,368,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,232,368,FontBlack,VALUEQUADC+14,1 ; Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString $A010,80,384,FontBlack,DOLLAR,0         ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,384,FontBlack,VALUEQUADC,1     ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,128,384,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,136,384,FontBlack,VALUEQUADC+2,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,176,384,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,184,384,FontBlack,VALUEQUADC+4,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,224,384,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,232,384,FontBlack,VALUEQUADC+6,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,80,392,FontBlack,DOLLAR,0         ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,392,FontBlack,VALUEQUADC+8,1   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,128,392,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,136,392,FontBlack,VALUEQUADC+10,1 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,176,392,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,184,392,FontBlack,VALUEQUADC+12,1 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,224,392,FontBlack,DOLLAR,0        ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,232,392,FontBlack,VALUEQUADC+14,1 ; Print HEX Chars To VRAM Using Font At X,Y Position

  ; Store RSP Data To MEM
  lui a0,SP_MEM_BASE ; A0 = SP Memory Base Offset (DMEM)
  la a1,VDQUAD ; A1 = Quad Data Offset
  lw t0,0(a0)  ; T0 = Quad Data
  sw t0,0(a1)  ; Store Quad Data To MEM
  lw t0,4(a0)  ; T0 = Quad Data
  sw t0,4(a1)  ; Store Quad Data To MEM
  lw t0,8(a0)  ; T0 = Quad Data
  sw t0,8(a1)  ; Store Quad Data To MEM
  lw t0,12(a0) ; T0 = Quad Data
  sw t0,12(a1) ; Store Quad Data To MEM

  PrintString $A010,328,384,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,336,384,FontBlack,VDQUAD,1    ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,376,384,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,384,FontBlack,VDQUAD+2,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,424,384,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,432,384,FontBlack,VDQUAD+4,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,472,384,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,480,384,FontBlack,VDQUAD+6,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,328,392,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,336,392,FontBlack,VDQUAD+8,1  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,376,392,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,392,FontBlack,VDQUAD+10,1 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,424,392,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,432,392,FontBlack,VDQUAD+12,1 ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,472,392,FontBlack,DOLLAR,0    ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,480,392,FontBlack,VDQUAD+14,1 ; Print HEX Chars To VRAM Using Font At X,Y Position
  la a0,VDQUAD      ; A0 = Quad Data Offset
  ld t0,0(a0)       ; T0 = Quad Data
  la a0,VSUBCCHECKD ; A0 = Quad Check Data Offset
  ld t1,0(a0)       ; T1 = Quad Check Data
  bne t0,t1,VSUBCFAILD ; Compare Result Equality With Check Data
  nop ; Delay Slot
  la a0,VDQUAD      ; A0 = Quad Data Offset
  ld t0,8(a0)       ; T0 = Quad Data
  la a0,VSUBCCHECKD ; A0 = Quad Check Data Offset
  ld t1,8(a0)       ; T1 = Quad Check Data
  bne t0,t1,VSUBCFAILD ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,392,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  j VSUBCENDD
  nop ; Delay Slot
  VSUBCFAILD:
  PrintString $A010,528,392,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  VSUBCENDD:

  PrintString $A010,0,400,FontBlack,PAGEBREAK,79 ; Print Text String To VRAM Using Font At X,Y Position


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

VSUBTEXT:  db "VSUB"
VSUBCTEXT: db "VSUBC"

VDHEX: db "VD (Hex)"
VSVTHEX: db "VS/VT (Hex)"
TEST: db "Test Result"
FAIL: db "FAIL"
PASS: db "PASS"

DOLLAR: db "$"

PAGEBREAK: db "--------------------------------------------------------------------------------"

  align 8 ; Align 64-Bit
VALUEQUADA: dh $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
VALUEQUADAEND:

VALUEQUADB: dh $0011, $2233, $4455, $6677, $8899, $AABB, $CCDD, $EEFF
VALUEQUADBEND:

VALUEQUADC: dh $FFEE, $DDCC, $BBAA, $9988, $7766, $5544, $3322, $1100
VALUEQUADCEND:

VSUBCHECKA: dh $FFEF, $DDCD, $BBAB, $9989, $7767, $5545, $3323, $1101
VSUBCHECKB: dh $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
VSUBCHECKC: dh $0023, $4467, $7FFF, $7FFF, $8000, $8000, $99BB, $DDFF
VSUBCHECKD: dh $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000

VSUBCCHECKA: dh $FFEF, $DDCD, $BBAB, $9989, $7767, $5545, $3323, $1101
VSUBCCHECKB: dh $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
VSUBCCHECKC: dh $0023, $4467, $88AB, $CCEF, $1133, $5577, $99BB, $DDFF
VSUBCCHECKD: dh $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000

VDQUAD: dh $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
VDQUADEND:

FontBlack: incbin FontBlack8x8.bin
FontGreen: incbin FontGreen8x8.bin
FontRed: incbin FontRed8x8.bin

  align 8 ; Align 64-Bit
RSPVSUBCode:
  obj $0000 ; Set Base Of RSP Code Object To Zero
  lqv v00,(e0),$00,(0) ; V0 = 128-Bit DMEM $000(R0), Load Quad To Vector: LQV VT[ELEMENT],$OFFSET(BASE)
  lqv v01,(e0),$01,(0) ; V1 = 128-Bit DMEM $010(R0), Load Quad To Vector: LQV VT[ELEMENT],$OFFSET(BASE)
  vsub v00,v00,v01,(e0) ; V0 = V0 - V1[0], Vector Subtract Short Elements: VSUB VD,VS,VT[ELEMENT]
  sqv v00,(e0),$00,(0) ; 128-Bit DMEM $000(R0) = V0, Store Vector To Quad: SQV VT[ELEMENT],$OFFSET(BASE)
  break $0000 ; Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
  objend ; Set End Of RSP Code Object
RSPVSUBCodeEND:

  align 8 ; Align 64-Bit
RSPVSUBCCode:
  obj $0000 ; Set Base Of RSP Code Object To Zero
  lqv v00,(e0),$00,(0) ; V0 = 128-Bit DMEM $000(R0), Load Quad To Vector: LQV VT[ELEMENT],$OFFSET(BASE)
  lqv v01,(e0),$01,(0) ; V1 = 128-Bit DMEM $010(R0), Load Quad To Vector: LQV VT[ELEMENT],$OFFSET(BASE)
  vsubc v00,v00,v01,(e0) ; V0 = V0 - V1[0], Vector Subtract Short Elements With Carry: VSUBC VD,VS,VT[ELEMENT]
  sqv v00,(e0),$00,(0) ; 128-Bit DMEM $000(R0) = V0, Store Vector To Quad: SQV VT[ELEMENT],$OFFSET(BASE)
  break $0000 ; Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
  objend ; Set End Of RSP Code Object
RSPVSUBCCodeEND: