// N64 'Bare Metal' RSP CPU Word Shift Right Logical Variable (0..31) Test Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "RSPCPUSRLV.N64", create
fill 1052672 // Set ROM Size

// Setup Frame Buffer
constant SCREEN_X(640)
constant SCREEN_Y(480)
constant BYTES_PER_PIXEL(4)

// Setup Characters
constant CHAR_X(8)
constant CHAR_Y(8)

origin $00000000
base $80000000 // Entry Point Of Code
include "LIB/N64.INC" // Include N64 Definitions
include "LIB/N64_HEADER.ASM" // Include 64 Byte Header & Vector Table
insert "LIB/N64_BOOTCODE.BIN" // Include 4032 Byte Boot Code

macro PrintString(vram, xpos, ypos, fontfile, string, length) { // Print Text String To VRAM Using Font At X,Y Position
  li a0,{vram}+({xpos}*BYTES_PER_PIXEL)+(SCREEN_X*BYTES_PER_PIXEL*{ypos}) // A0 = Frame Buffer Pointer (Place text at XY Position)
  la a1,{fontfile} // A1 = Characters
  la a2,{string} // A2 = Text Offset
  lli t0,{length} // T0 = Number of Text Characters to Print
  {#}DrawChars:
    lli t1,CHAR_X-1 // T1 = Character X Pixel Counter
    lli t2,CHAR_Y-1 // T2 = Character Y Pixel Counter

    lb t3,0(a2) // T3 = Next Text Character
    addi a2,1

    sll t3,8 // Add Shift to Correct Position in Font (*256: CHAR_X*CHAR_Y*BYTES_PER_PIXEL)
    add t3,a1

    {#}DrawCharX:
      lw t4,0(t3) // Load Font Text Character Pixel
      addi t3,BYTES_PER_PIXEL
      sw t4,0(a0) // Store Font Text Character Pixel into Frame Buffer
      addi a0,BYTES_PER_PIXEL

      bnez t1,{#}DrawCharX // IF (Character X Pixel Counter != 0) DrawCharX
      subi t1,1 // Decrement Character X Pixel Counter

      addi a0,(SCREEN_X*BYTES_PER_PIXEL)-CHAR_X*BYTES_PER_PIXEL // Jump Down 1 Scanline, Jump Back 1 Char
      lli t1,CHAR_X-1 // Reset Character X Pixel Counter
      bnez t2,{#}DrawCharX // IF (Character Y Pixel Counter != 0) DrawCharX
      subi t2,1 // Decrement Character Y Pixel Counter

    subi a0,((SCREEN_X*BYTES_PER_PIXEL)*CHAR_Y)-CHAR_X*BYTES_PER_PIXEL // Jump To Start Of Next Char
    bnez t0,{#}DrawChars // Continue to Print Characters
    subi t0,1 // Subtract Number of Text Characters to Print
}

macro PrintValue(vram, xpos, ypos, fontfile, value, length) { // Print HEX Chars To VRAM Using Font At X,Y Position
  li a0,{vram}+({xpos}*BYTES_PER_PIXEL)+(SCREEN_X*BYTES_PER_PIXEL*{ypos}) // A0 = Frame Buffer Pointer (Place text at XY Position)
  la a1,{fontfile} // A1 = Characters
  la a2,{value} // A2 = Value Offset
  li t0,{length} // T0 = Number of HEX Chars to Print
  {#}DrawHEXChars:
    lli t1,CHAR_X-1 // T1 = Character X Pixel Counter
    lli t2,CHAR_Y-1 // T2 = Character Y Pixel Counter

    lb t3,0(a2) // T3 = Next 2 HEX Chars
    addi a2,1

    srl t4,t3,4 // T4 = 2nd Nibble
    andi t4,$F
    subi t5,t4,9
    bgtz t5,{#}HEXLetters
    addi t4,$30 // Delay Slot
    j {#}HEXEnd
    nop // Delay Slot

    {#}HEXLetters:
    addi t4,7
    {#}HEXEnd:

    sll t4,8 // Add Shift to Correct Position in Font (*256: CHAR_X*CHAR_Y*BYTES_PER_PIXEL)
    add t4,a1

    {#}DrawHEXCharX:
      lw t5,0(t4) // Load Font Text Character Pixel
      addi t4,4
      sw t5,0(a0) // Store Font Text Character Pixel into Frame Buffer
      addi a0,4

      bnez t1,{#}DrawHEXCharX // IF (Character X Pixel Counter != 0) DrawCharX
      subi t1,1 // Decrement Character X Pixel Counter

      addi a0,(SCREEN_X*BYTES_PER_PIXEL)-CHAR_X*BYTES_PER_PIXEL // Jump down 1 Scanline, Jump back 1 Char
      lli t1,CHAR_X-1 // Reset Character X Pixel Counter
      bnez t2,{#}DrawHEXCharX // IF (Character Y Pixel Counter != 0) DrawCharX
      subi t2,1 // Decrement Character Y Pixel Counter

    subi a0,((SCREEN_X*BYTES_PER_PIXEL)*CHAR_Y)-CHAR_X*BYTES_PER_PIXEL // Jump To Start Of Next Char

    lli t2,CHAR_Y-1 // Reset Character Y Pixel Counter

    andi t4,t3,$F // T4 = 1st Nibble
    subi t5,t4,9
    bgtz t5,{#}HEXLettersB
    addi t4,$30 // Delay Slot
    j {#}HEXEndB
    nop // Delay Slot

    {#}HEXLettersB:
    addi t4,7
    {#}HEXEndB:

    sll t4,8 // Add Shift to Correct Position in Font (*256: CHAR_X*CHAR_Y*BYTES_PER_PIXEL)
    add t4,a1

    {#}DrawHEXCharXB:
      lw t5,0(t4) // Load Font Text Character Pixel
      addi t4,4
      sw t5,0(a0) // Store Font Text Character Pixel into Frame Buffer
      addi a0,4

      bnez t1,{#}DrawHEXCharXB // IF (Character X Pixel Counter != 0) DrawCharX
      subi t1,1 // Decrement Character X Pixel Counter

      addi a0,(SCREEN_X*BYTES_PER_PIXEL)-CHAR_X*BYTES_PER_PIXEL // Jump down 1 Scanline, Jump back 1 Char
      lli t1,CHAR_X-1 // Reset Character X Pixel Counter
      bnez t2,{#}DrawHEXCharXB // IF (Character Y Pixel Counter != 0) DrawCharX
      subi t2,1 // Decrement Character Y Pixel Counter

    subi a0,((SCREEN_X*BYTES_PER_PIXEL)*CHAR_Y)-CHAR_X*BYTES_PER_PIXEL // Jump To Start Of Next Char

    bnez t0,{#}DrawHEXChars // Continue to Print Characters
    subi t0,1 // Subtract Number of Text Characters to Print
}

Start:
  include "LIB/N64_GFX.INC" // Include Graphics Macros
  include "LIB/N64_RSP.INC" // Include RSP Macros
  N64_INIT() // Run N64 Initialisation Routine

  ScreenNTSC(640, 480, BPP32|INTERLACE|AA_MODE_2, $A0100000) // Screen NTSC: 640x480, 32BPP, Interlace, Resample Only, DRAM Origin = $A0100000

  lui a0,$A010 // A0 = VRAM Start Offset
  la a1,$A0100000+((SCREEN_X*SCREEN_Y*BYTES_PER_PIXEL)-BYTES_PER_PIXEL) // A1 = VRAM End Offset
  lli t0,$000000FF // T0 = Black
ClearScreen:
  sw t0,0(a0)
  bne a0,a1,ClearScreen
  addi a0,4 // Delay Slot


  PrintString($A0100000,88,8,FontRed,RTHEX,7) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,8,FontRed,RSDEC,11) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,384,8,FontRed,RDHEX,7) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,528,8,FontRed,TEST,10) // Print Text String To VRAM Using Font At X,Y Position


  PrintString($A0100000,0,16,FontBlack,PAGEBREAK,79) // Print Text String To VRAM Using Font At X,Y Position

  // Load RSP Code To IMEM
  DMASPRD(RSPSRLV0Code, RSPSRLV0CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  SetSPPC($0000) // Set RSP Program Counter: Set To Zero (Start Of RSP Code)
  StartSP() // Start RSP Execution: RSP Status = Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break

  PrintString($A0100000,8,24,FontRed,SRLV,3) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,80,24,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,24,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,24,FontBlack,TEXTWORD0,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,24,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE // A0 = Test Word Data Offset
  lw t0,0(a0) // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintValue($A0100000,384,24,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,SRLVCHECK0 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SRLVPASS0 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,24,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLVEND0
  nop // Delay Slot
  SRLVPASS0:
  PrintString($A0100000,528,24,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLVEND0:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRLV1Code, RSPSRLV1CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  StartSP() // Start RSP Execution: RSP Status = Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break

  PrintString($A0100000,80,32,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,32,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,32,FontBlack,TEXTWORD1,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,32,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE // A0 = Test Word Data Offset
  lw t0,0(a0) // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintValue($A0100000,384,32,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,SRLVCHECK1 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SRLVPASS1 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,32,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLVEND1
  nop // Delay Slot
  SRLVPASS1:
  PrintString($A0100000,528,32,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLVEND1:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRLV2Code, RSPSRLV2CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  StartSP() // Start RSP Execution: RSP Status = Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break

  PrintString($A0100000,80,40,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,40,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,40,FontBlack,TEXTWORD2,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,40,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE // A0 = Test Word Data Offset
  lw t0,0(a0) // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintValue($A0100000,384,40,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,SRLVCHECK2 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SRLVPASS2 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,40,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLVEND2
  nop // Delay Slot
  SRLVPASS2:
  PrintString($A0100000,528,40,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLVEND2:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRLV3Code, RSPSRLV3CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  StartSP() // Start RSP Execution: RSP Status = Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break

  PrintString($A0100000,80,48,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,48,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,48,FontBlack,TEXTWORD3,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,48,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE // A0 = Test Word Data Offset
  lw t0,0(a0) // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintValue($A0100000,384,48,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD     // T0 = Word Data Offset
  lw t1,0(t0)      // T1 = Word Data
  la t0,SRLVCHECK3 // T0 = Word Check Data Offset
  lw t2,0(t0)      // T2 = Word Check Data
  beq t1,t2,SRLVPASS3 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,48,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLVEND3
  nop // Delay Slot
  SRLVPASS3:
  PrintString($A0100000,528,48,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLVEND3:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRLV4Code, RSPSRLV4CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  StartSP() // Start RSP Execution: RSP Status = Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break

  PrintString($A0100000,80,56,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,56,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,56,FontBlack,TEXTWORD4,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,56,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE // A0 = Test Word Data Offset
  lw t0,0(a0) // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintValue($A0100000,384,56,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,SRLVCHECK4 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SRLVPASS4 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,56,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLVEND4
  nop // Delay Slot
  SRLVPASS4:
  PrintString($A0100000,528,56,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLVEND4:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRLV5Code, RSPSRLV5CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  StartSP() // Start RSP Execution: RSP Status = Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break

  PrintString($A0100000,80,64,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,64,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,64,FontBlack,TEXTWORD5,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,64,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE // A0 = Test Word Data Offset
  lw t0,0(a0) // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintValue($A0100000,384,64,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,SRLVCHECK5 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SRLVPASS5 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,64,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLVEND5
  nop // Delay Slot
  SRLVPASS5:
  PrintString($A0100000,528,64,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLVEND5:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRLV6Code, RSPSRLV6CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  StartSP() // Start RSP Execution: RSP Status = Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break

  PrintString($A0100000,80,72,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,72,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,72,FontBlack,TEXTWORD6,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,72,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE // A0 = Test Word Data Offset
  lw t0,0(a0) // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintValue($A0100000,384,72,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,SRLVCHECK6 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SRLVPASS6 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,72,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLVEND6
  nop // Delay Slot
  SRLVPASS6:
  PrintString($A0100000,528,72,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLVEND6:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRLV7Code, RSPSRLV7CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  StartSP() // Start RSP Execution: RSP Status = Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break

  PrintString($A0100000,80,80,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,80,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,80,FontBlack,TEXTWORD7,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,80,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE // A0 = Test Word Data Offset
  lw t0,0(a0) // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintValue($A0100000,384,80,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,SRLVCHECK7 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SRLVPASS7 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,80,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLVEND7
  nop // Delay Slot
  SRLVPASS7:
  PrintString($A0100000,528,80,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLVEND7:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRLV8Code, RSPSRLV8CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  StartSP() // Start RSP Execution: RSP Status = Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break

  PrintString($A0100000,80,88,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,88,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,88,FontBlack,TEXTWORD8,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,88,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE // A0 = Test Word Data Offset
  lw t0,0(a0) // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintValue($A0100000,384,88,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,SRLVCHECK8 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SRLVPASS8 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,88,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLVEND8
  nop // Delay Slot
  SRLVPASS8:
  PrintString($A0100000,528,88,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLVEND8:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRLV9Code, RSPSRLV9CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  StartSP() // Start RSP Execution: RSP Status = Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break

  PrintString($A0100000,80,96,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,96,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,96,FontBlack,TEXTWORD9,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,96,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE // A0 = Test Word Data Offset
  lw t0,0(a0) // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintValue($A0100000,384,96,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,SRLVCHECK9 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SRLVPASS9 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,96,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLVEND9
  nop // Delay Slot
  SRLVPASS9:
  PrintString($A0100000,528,96,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLVEND9:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRLV10Code, RSPSRLV10CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  StartSP() // Start RSP Execution: RSP Status = Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break

  PrintString($A0100000,80,104,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,104,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,104,FontBlack,TEXTWORD10,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,104,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE // A0 = Test Word Data Offset
  lw t0,0(a0) // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintValue($A0100000,384,104,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD      // A0 = Word Data Offset
  lw t0,0(a0)       // T0 = Word Data
  la a0,SRLVCHECK10 // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,SRLVPASS10 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,104,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLVEND10
  nop // Delay Slot
  SRLVPASS10:
  PrintString($A0100000,528,104,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLVEND10:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRLV11Code, RSPSRLV11CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  StartSP() // Start RSP Execution: RSP Status = Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break

  PrintString($A0100000,80,112,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,112,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,112,FontBlack,TEXTWORD11,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,112,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE // A0 = Test Word Data Offset
  lw t0,0(a0) // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintValue($A0100000,384,112,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD      // A0 = Word Data Offset
  lw t0,0(a0)       // T0 = Word Data
  la a0,SRLVCHECK11 // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,SRLVPASS11 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,112,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLVEND11
  nop // Delay Slot
  SRLVPASS11:
  PrintString($A0100000,528,112,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLVEND11:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRLV12Code, RSPSRLV12CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  StartSP() // Start RSP Execution: RSP Status = Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break

  PrintString($A0100000,80,120,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,120,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,120,FontBlack,TEXTWORD12,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,120,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE // A0 = Test Word Data Offset
  lw t0,0(a0) // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintValue($A0100000,384,120,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD      // A0 = Word Data Offset
  lw t0,0(a0)       // T0 = Word Data
  la a0,SRLVCHECK12 // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,SRLVPASS12 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,120,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLVEND12
  nop // Delay Slot
  SRLVPASS12:
  PrintString($A0100000,528,120,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLVEND12:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRLV13Code, RSPSRLV13CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  StartSP() // Start RSP Execution: RSP Status = Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break

  PrintString($A0100000,80,128,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,128,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,128,FontBlack,TEXTWORD13,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,128,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE // A0 = Test Word Data Offset
  lw t0,0(a0) // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintValue($A0100000,384,128,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD      // A0 = Word Data Offset
  lw t0,0(a0)       // T0 = Word Data
  la a0,SRLVCHECK13 // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,SRLVPASS13 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,128,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLVEND13
  nop // Delay Slot
  SRLVPASS13:
  PrintString($A0100000,528,128,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLVEND13:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRLV14Code, RSPSRLV14CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  StartSP() // Start RSP Execution: RSP Status = Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break

  PrintString($A0100000,80,136,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,136,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,136,FontBlack,TEXTWORD14,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,136,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE // A0 = Test Word Data Offset
  lw t0,0(a0) // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintValue($A0100000,384,136,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD      // A0 = Word Data Offset
  lw t0,0(a0)       // T0 = Word Data
  la a0,SRLVCHECK14 // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,SRLVPASS14 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,136,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLVEND14
  nop // Delay Slot
  SRLVPASS14:
  PrintString($A0100000,528,136,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLVEND14:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRLV15Code, RSPSRLV15CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  StartSP() // Start RSP Execution: RSP Status = Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break

  PrintString($A0100000,80,144,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,144,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,144,FontBlack,TEXTWORD15,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,144,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE // A0 = Test Word Data Offset
  lw t0,0(a0) // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintValue($A0100000,384,144,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD      // A0 = Word Data Offset
  lw t0,0(a0)       // T0 = Word Data
  la a0,SRLVCHECK15 // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,SRLVPASS15 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,144,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLVEND15
  nop // Delay Slot
  SRLVPASS15:
  PrintString($A0100000,528,144,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLVEND15:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRLV16Code, RSPSRLV16CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  StartSP() // Start RSP Execution: RSP Status = Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break

  PrintString($A0100000,80,152,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,152,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,152,FontBlack,TEXTWORD16,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,152,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE // A0 = Test Word Data Offset
  lw t0,0(a0) // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintValue($A0100000,384,152,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD      // A0 = Word Data Offset
  lw t0,0(a0)       // T0 = Word Data
  la a0,SRLVCHECK16 // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,SRLVPASS16 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,152,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLVEND16
  nop // Delay Slot
  SRLVPASS16:
  PrintString($A0100000,528,152,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLVEND16:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRLV17Code, RSPSRLV17CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  StartSP() // Start RSP Execution: RSP Status = Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break

  PrintString($A0100000,80,160,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,160,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,160,FontBlack,TEXTWORD17,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,160,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE // A0 = Test Word Data Offset
  lw t0,0(a0) // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintValue($A0100000,384,160,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD      // A0 = Word Data Offset
  lw t0,0(a0)       // T0 = Word Data
  la a0,SRLVCHECK17 // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,SRLVPASS17 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,160,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLVEND17
  nop // Delay Slot
  SRLVPASS17:
  PrintString($A0100000,528,160,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLVEND17:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRLV18Code, RSPSRLV18CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  StartSP() // Start RSP Execution: RSP Status = Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break

  PrintString($A0100000,80,168,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,168,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,168,FontBlack,TEXTWORD18,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,168,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE // A0 = Test Word Data Offset
  lw t0,0(a0) // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintValue($A0100000,384,168,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD      // A0 = Word Data Offset
  lw t0,0(a0)       // T0 = Word Data
  la a0,SRLVCHECK18 // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,SRLVPASS18 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,168,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLVEND18
  nop // Delay Slot
  SRLVPASS18:
  PrintString($A0100000,528,168,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLVEND18:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRLV19Code, RSPSRLV19CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  StartSP() // Start RSP Execution: RSP Status = Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break

  PrintString($A0100000,80,176,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,176,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,176,FontBlack,TEXTWORD19,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,176,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE // A0 = Test Word Data Offset
  lw t0,0(a0) // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintValue($A0100000,384,176,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD      // A0 = Word Data Offset
  lw t0,0(a0)       // T0 = Word Data
  la a0,SRLVCHECK19 // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,SRLVPASS19 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,176,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLVEND19
  nop // Delay Slot
  SRLVPASS19:
  PrintString($A0100000,528,176,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLVEND19:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRLV20Code, RSPSRLV20CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  StartSP() // Start RSP Execution: RSP Status = Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break

  PrintString($A0100000,80,184,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,184,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,184,FontBlack,TEXTWORD20,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,184,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE // A0 = Test Word Data Offset
  lw t0,0(a0) // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintValue($A0100000,384,184,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD      // A0 = Word Data Offset
  lw t0,0(a0)       // T0 = Word Data
  la a0,SRLVCHECK20 // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,SRLVPASS20 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,184,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLVEND20
  nop // Delay Slot
  SRLVPASS20:
  PrintString($A0100000,528,184,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLVEND20:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRLV21Code, RSPSRLV21CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  StartSP() // Start RSP Execution: RSP Status = Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break

  PrintString($A0100000,80,192,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,192,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,192,FontBlack,TEXTWORD21,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,192,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE // A0 = Test Word Data Offset
  lw t0,0(a0) // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintValue($A0100000,384,192,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD      // A0 = Word Data Offset
  lw t0,0(a0)       // T0 = Word Data
  la a0,SRLVCHECK21 // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,SRLVPASS21 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,192,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLVEND21
  nop // Delay Slot
  SRLVPASS21:
  PrintString($A0100000,528,192,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLVEND21:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRLV22Code, RSPSRLV22CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  StartSP() // Start RSP Execution: RSP Status = Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break

  PrintString($A0100000,80,200,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,200,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,200,FontBlack,TEXTWORD22,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,200,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE // A0 = Test Word Data Offset
  lw t0,0(a0) // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintValue($A0100000,384,200,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD      // A0 = Word Data Offset
  lw t0,0(a0)       // T0 = Word Data
  la a0,SRLVCHECK22 // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,SRLVPASS22 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,200,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLVEND22
  nop // Delay Slot
  SRLVPASS22:
  PrintString($A0100000,528,200,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLVEND22:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRLV23Code, RSPSRLV23CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  StartSP() // Start RSP Execution: RSP Status = Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break

  PrintString($A0100000,80,208,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,208,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,208,FontBlack,TEXTWORD23,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,208,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE // A0 = Test Word Data Offset
  lw t0,0(a0) // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintValue($A0100000,384,208,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD      // A0 = Word Data Offset
  lw t0,0(a0)       // T0 = Word Data
  la a0,SRLVCHECK23 // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,SRLVPASS23 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,208,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLVEND23
  nop // Delay Slot
  SRLVPASS23:
  PrintString($A0100000,528,208,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLVEND23:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRLV24Code, RSPSRLV24CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  StartSP() // Start RSP Execution: RSP Status = Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break

  PrintString($A0100000,80,216,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,216,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,216,FontBlack,TEXTWORD24,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,216,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE // A0 = Test Word Data Offset
  lw t0,0(a0) // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintValue($A0100000,384,216,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD      // A0 = Word Data Offset
  lw t0,0(a0)       // T0 = Word Data
  la a0,SRLVCHECK24 // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,SRLVPASS24 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,216,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLVEND24
  nop // Delay Slot
  SRLVPASS24:
  PrintString($A0100000,528,216,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLVEND24:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRLV25Code, RSPSRLV25CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  StartSP() // Start RSP Execution: RSP Status = Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break

  PrintString($A0100000,80,224,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,224,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,224,FontBlack,TEXTWORD25,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,224,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE // A0 = Test Word Data Offset
  lw t0,0(a0) // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintValue($A0100000,384,224,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD      // A0 = Word Data Offset
  lw t0,0(a0)       // T0 = Word Data
  la a0,SRLVCHECK25 // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,SRLVPASS25 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,224,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLVEND25
  nop // Delay Slot
  SRLVPASS25:
  PrintString($A0100000,528,224,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLVEND25:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRLV26Code, RSPSRLV26CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  StartSP() // Start RSP Execution: RSP Status = Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break

  PrintString($A0100000,80,232,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,232,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,232,FontBlack,TEXTWORD26,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,232,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE // A0 = Test Word Data Offset
  lw t0,0(a0) // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintValue($A0100000,384,232,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD      // A0 = Word Data Offset
  lw t0,0(a0)       // T0 = Word Data
  la a0,SRLVCHECK26 // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,SRLVPASS26 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,232,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLVEND26
  nop // Delay Slot
  SRLVPASS26:
  PrintString($A0100000,528,232,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLVEND26:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRLV27Code, RSPSRLV27CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  StartSP() // Start RSP Execution: RSP Status = Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break

  PrintString($A0100000,80,240,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,240,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,240,FontBlack,TEXTWORD27,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,240,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE // A0 = Test Word Data Offset
  lw t0,0(a0) // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintValue($A0100000,384,240,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD      // A0 = Word Data Offset
  lw t0,0(a0)       // T0 = Word Data
  la a0,SRLVCHECK27 // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,SRLVPASS27 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,240,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLVEND27
  nop // Delay Slot
  SRLVPASS27:
  PrintString($A0100000,528,240,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLVEND27:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRLV28Code, RSPSRLV28CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  StartSP() // Start RSP Execution: RSP Status = Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break

  PrintString($A0100000,80,248,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,248,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,248,FontBlack,TEXTWORD28,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,248,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE // A0 = Test Word Data Offset
  lw t0,0(a0) // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintValue($A0100000,384,248,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD      // A0 = Word Data Offset
  lw t0,0(a0)       // T0 = Word Data
  la a0,SRLVCHECK28 // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,SRLVPASS28 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,248,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLVEND28
  nop // Delay Slot
  SRLVPASS28:
  PrintString($A0100000,528,248,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLVEND28:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRLV29Code, RSPSRLV29CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  StartSP() // Start RSP Execution: RSP Status = Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break

  PrintString($A0100000,80,256,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,256,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,256,FontBlack,TEXTWORD29,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,256,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE // A0 = Test Word Data Offset
  lw t0,0(a0) // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintValue($A0100000,384,256,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD      // A0 = Word Data Offset
  lw t0,0(a0)       // T0 = Word Data
  la a0,SRLVCHECK29 // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,SRLVPASS29 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,256,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLVEND29
  nop // Delay Slot
  SRLVPASS29:
  PrintString($A0100000,528,256,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLVEND29:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRLV30Code, RSPSRLV30CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  StartSP() // Start RSP Execution: RSP Status = Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break

  PrintString($A0100000,80,264,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,264,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,264,FontBlack,TEXTWORD30,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,264,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE // A0 = Test Word Data Offset
  lw t0,0(a0) // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintValue($A0100000,384,264,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD      // A0 = Word Data Offset
  lw t0,0(a0)       // T0 = Word Data
  la a0,SRLVCHECK30 // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,SRLVPASS30 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,264,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLVEND30
  nop // Delay Slot
  SRLVPASS30:
  PrintString($A0100000,528,264,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLVEND30:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRLV31Code, RSPSRLV31CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  StartSP() // Start RSP Execution: RSP Status = Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break

  PrintString($A0100000,80,272,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,272,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,272,FontBlack,TEXTWORD31,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,272,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE // A0 = Test Word Data Offset
  lw t0,0(a0) // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintValue($A0100000,384,272,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD      // A0 = Word Data Offset
  lw t0,0(a0)       // T0 = Word Data
  la a0,SRLVCHECK31 // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,SRLVPASS31 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,272,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLVEND31
  nop // Delay Slot
  SRLVPASS31:
  PrintString($A0100000,528,272,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLVEND31:


  PrintString($A0100000,0,280,FontBlack,PAGEBREAK,79) // Print Text String To VRAM Using Font At X,Y Position


Loop:
  WaitScanline($1E0) // Wait For Scanline To Reach Vertical Blank
  WaitScanline($1E2)

  lli t0,$00000800 // Even Field
  sw t0,VI_Y_SCALE(a0)

  WaitScanline($1E0) // Wait For Scanline To Reach Vertical Blank
  WaitScanline($1E2)

  li t0,$02000800 // Odd Field
  sw t0,VI_Y_SCALE(a0)

  j Loop
  nop // Delay Slot

SRLV:
  db "SRLV"

RDHEX:
  db "RD (Hex)"
RTHEX:
  db "RT (Hex)"
RSDEC:
  db "RS (Decimal)"
TEST:
  db "Test Result"
FAIL:
  db "FAIL"
PASS:
  db "PASS"

DOLLAR:
  db "$"

TEXTWORD0:
  db "0"
TEXTWORD1:
  db "1"
TEXTWORD2:
  db "2"
TEXTWORD3:
  db "3"
TEXTWORD4:
  db "4"
TEXTWORD5:
  db "5"
TEXTWORD6:
  db "6"
TEXTWORD7:
  db "7"
TEXTWORD8:
  db "8"
TEXTWORD9:
  db "9"
TEXTWORD10:
  db "10"
TEXTWORD11:
  db "11"
TEXTWORD12:
  db "12"
TEXTWORD13:
  db "13"
TEXTWORD14:
  db "14"
TEXTWORD15:
  db "15"
TEXTWORD16:
  db "16"
TEXTWORD17:
  db "17"
TEXTWORD18:
  db "18"
TEXTWORD19:
  db "19"
TEXTWORD20:
  db "20"
TEXTWORD21:
  db "21"
TEXTWORD22:
  db "22"
TEXTWORD23:
  db "23"
TEXTWORD24:
  db "24"
TEXTWORD25:
  db "25"
TEXTWORD26:
  db "26"
TEXTWORD27:
  db "27"
TEXTWORD28:
  db "28"
TEXTWORD29:
  db "29"
TEXTWORD30:
  db "30"
TEXTWORD31:
  db "31"

PAGEBREAK:
  db "--------------------------------------------------------------------------------"

align(8) // Align 64-Bit
VALUEWORD:
  dw -123456789

SRLVCHECK0:
  dw $F8A432EB
SRLVCHECK1:
  dw $7C521975
SRLVCHECK2:
  dw $3E290CBA
SRLVCHECK3:
  dw $1F14865D
SRLVCHECK4:
  dw $0F8A432E
SRLVCHECK5:
  dw $07C52197
SRLVCHECK6:
  dw $03E290CB
SRLVCHECK7:
  dw $01F14865
SRLVCHECK8:
  dw $00F8A432
SRLVCHECK9:
  dw $007C5219
SRLVCHECK10:
  dw $003E290C
SRLVCHECK11:
  dw $001F1486
SRLVCHECK12:
  dw $000F8A43
SRLVCHECK13:
  dw $0007C521
SRLVCHECK14:
  dw $0003E290
SRLVCHECK15:
  dw $0001F148
SRLVCHECK16:
  dw $0000F8A4
SRLVCHECK17:
  dw $00007C52
SRLVCHECK18:
  dw $00003E29
SRLVCHECK19:
  dw $00001F14
SRLVCHECK20:
  dw $00000F8A
SRLVCHECK21:
  dw $000007C5
SRLVCHECK22:
  dw $000003E2
SRLVCHECK23:
  dw $000001F1
SRLVCHECK24:
  dw $000000F8
SRLVCHECK25:
  dw $0000007C
SRLVCHECK26:
  dw $0000003E
SRLVCHECK27:
  dw $0000001F
SRLVCHECK28:
  dw $0000000F
SRLVCHECK29:
  dw $00000007
SRLVCHECK30:
  dw $00000003
SRLVCHECK31:
  dw $00000001

RDWORD:
  dw 0

arch n64.rsp
align(8) // Align 64-Bit
RSPSRLV0Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,0    // T1 = Shift Amount
  srlv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRLV0Code+pc() // Set End Of RSP Code Object
RSPSRLV0CodeEnd:

align(8) // Align 64-Bit
RSPSRLV1Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,1    // T1 = Shift Amount
  srlv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRLV1Code+pc() // Set End Of RSP Code Object
RSPSRLV1CodeEnd:

align(8) // Align 64-Bit
RSPSRLV2Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,2    // T1 = Shift Amount
  srlv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRLV2Code+pc() // Set End Of RSP Code Object
RSPSRLV2CodeEnd:

align(8) // Align 64-Bit
RSPSRLV3Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,3    // T1 = Shift Amount
  srlv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRLV3Code+pc() // Set End Of RSP Code Object
RSPSRLV3CodeEnd:

align(8) // Align 64-Bit
RSPSRLV4Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,4    // T1 = Shift Amount
  srlv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRLV4Code+pc() // Set End Of RSP Code Object
RSPSRLV4CodeEnd:

align(8) // Align 64-Bit
RSPSRLV5Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,5    // T1 = Shift Amount
  srlv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRLV5Code+pc() // Set End Of RSP Code Object
RSPSRLV5CodeEnd:

align(8) // Align 64-Bit
RSPSRLV6Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,6    // T1 = Shift Amount
  srlv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRLV6Code+pc() // Set End Of RSP Code Object
RSPSRLV6CodeEnd:

align(8) // Align 64-Bit
RSPSRLV7Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,7    // T1 = Shift Amount
  srlv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRLV7Code+pc() // Set End Of RSP Code Object
RSPSRLV7CodeEnd:

align(8) // Align 64-Bit
RSPSRLV8Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,8    // T1 = Shift Amount
  srlv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRLV8Code+pc() // Set End Of RSP Code Object
RSPSRLV8CodeEnd:

align(8) // Align 64-Bit
RSPSRLV9Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,9    // T1 = Shift Amount
  srlv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRLV9Code+pc() // Set End Of RSP Code Object
RSPSRLV9CodeEnd:

align(8) // Align 64-Bit
RSPSRLV10Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,10   // T1 = Shift Amount
  srlv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRLV10Code+pc() // Set End Of RSP Code Object
RSPSRLV10CodeEnd:

align(8) // Align 64-Bit
RSPSRLV11Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,11   // T1 = Shift Amount
  srlv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRLV11Code+pc() // Set End Of RSP Code Object
RSPSRLV11CodeEnd:

align(8) // Align 64-Bit
RSPSRLV12Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,12   // T1 = Shift Amount
  srlv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRLV12Code+pc() // Set End Of RSP Code Object
RSPSRLV12CodeEnd:

align(8) // Align 64-Bit
RSPSRLV13Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,13   // T1 = Shift Amount
  srlv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRLV13Code+pc() // Set End Of RSP Code Object
RSPSRLV13CodeEnd:

align(8) // Align 64-Bit
RSPSRLV14Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,14   // T1 = Shift Amount
  srlv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRLV14Code+pc() // Set End Of RSP Code Object
RSPSRLV14CodeEnd:

align(8) // Align 64-Bit
RSPSRLV15Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,15   // T1 = Shift Amount
  srlv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRLV15Code+pc() // Set End Of RSP Code Object
RSPSRLV15CodeEnd:

align(8) // Align 64-Bit
RSPSRLV16Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,16   // T1 = Shift Amount
  srlv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRLV16Code+pc() // Set End Of RSP Code Object
RSPSRLV16CodeEnd:

align(8) // Align 64-Bit
RSPSRLV17Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,17   // T1 = Shift Amount
  srlv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRLV17Code+pc() // Set End Of RSP Code Object
RSPSRLV17CodeEnd:

align(8) // Align 64-Bit
RSPSRLV18Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,18   // T1 = Shift Amount
  srlv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRLV18Code+pc() // Set End Of RSP Code Object
RSPSRLV18CodeEnd:

align(8) // Align 64-Bit
RSPSRLV19Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,19   // T1 = Shift Amount
  srlv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRLV19Code+pc() // Set End Of RSP Code Object
RSPSRLV19CodeEnd:

align(8) // Align 64-Bit
RSPSRLV20Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,20   // T1 = Shift Amount
  srlv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRLV20Code+pc() // Set End Of RSP Code Object
RSPSRLV20CodeEnd:

align(8) // Align 64-Bit
RSPSRLV21Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,21   // T1 = Shift Amount
  srlv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRLV21Code+pc() // Set End Of RSP Code Object
RSPSRLV21CodeEnd:

align(8) // Align 64-Bit
RSPSRLV22Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,22   // T1 = Shift Amount
  srlv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRLV22Code+pc() // Set End Of RSP Code Object
RSPSRLV22CodeEnd:

align(8) // Align 64-Bit
RSPSRLV23Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,23   // T1 = Shift Amount
  srlv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRLV23Code+pc() // Set End Of RSP Code Object
RSPSRLV23CodeEnd:

align(8) // Align 64-Bit
RSPSRLV24Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,24   // T1 = Shift Amount
  srlv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRLV24Code+pc() // Set End Of RSP Code Object
RSPSRLV24CodeEnd:

align(8) // Align 64-Bit
RSPSRLV25Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,25   // T1 = Shift Amount
  srlv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRLV25Code+pc() // Set End Of RSP Code Object
RSPSRLV25CodeEnd:

align(8) // Align 64-Bit
RSPSRLV26Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,26   // T1 = Shift Amount
  srlv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRLV26Code+pc() // Set End Of RSP Code Object
RSPSRLV26CodeEnd:

align(8) // Align 64-Bit
RSPSRLV27Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,27   // T1 = Shift Amount
  srlv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRLV27Code+pc() // Set End Of RSP Code Object
RSPSRLV27CodeEnd:

align(8) // Align 64-Bit
RSPSRLV28Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,28   // T1 = Shift Amount
  srlv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRLV28Code+pc() // Set End Of RSP Code Object
RSPSRLV28CodeEnd:

align(8) // Align 64-Bit
RSPSRLV29Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,29   // T1 = Shift Amount
  srlv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRLV29Code+pc() // Set End Of RSP Code Object
RSPSRLV29CodeEnd:

align(8) // Align 64-Bit
RSPSRLV30Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,30   // T1 = Shift Amount
  srlv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRLV30Code+pc() // Set End Of RSP Code Object
RSPSRLV30CodeEnd:

align(8) // Align 64-Bit
RSPSRLV31Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,31   // T1 = Shift Amount
  srlv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRLV31Code+pc() // Set End Of RSP Code Object
RSPSRLV31CodeEnd:

insert FontBlack, "FontBlack8x8.bin"
insert FontGreen, "FontGreen8x8.bin"
insert FontRed, "FontRed8x8.bin"