// N64 'Bare Metal' RSP CPU Word Shift Left Logical Variable (0..31) Test Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "RSPCPUSLLV.N64", create
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
  ori t0,r0,{length} // T0 = Number of Text Characters to Print
  {#}DrawChars:
    ori t1,r0,CHAR_X-1 // T1 = Character X Pixel Counter
    ori t2,r0,CHAR_Y-1 // T2 = Character Y Pixel Counter

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
      ori t1,r0,CHAR_X-1 // Reset Character X Pixel Counter
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
    ori t1,r0,CHAR_X-1 // T1 = Character X Pixel Counter
    ori t2,r0,CHAR_Y-1 // T2 = Character Y Pixel Counter

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
      ori t1,r0,CHAR_X-1 // Reset Character X Pixel Counter
      bnez t2,{#}DrawHEXCharX // IF (Character Y Pixel Counter != 0) DrawCharX
      subi t2,1 // Decrement Character Y Pixel Counter

    subi a0,((SCREEN_X*BYTES_PER_PIXEL)*CHAR_Y)-CHAR_X*BYTES_PER_PIXEL // Jump To Start Of Next Char

    ori t2,r0,CHAR_Y-1 // Reset Character Y Pixel Counter

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
      ori t1,r0,CHAR_X-1 // Reset Character X Pixel Counter
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
  ori t0,r0,$000000FF // T0 = Black
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
  DMASPRD(RSPSLLV0Code, RSPSLLV0CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  SetSPPC($0000) // Set RSP Program Counter: Set To Zero (Start Of RSP Code)
  StartSP() // Start RSP Execution: RSP Status = Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break

  PrintString($A0100000,8,24,FontRed,SLLV,3) // Print Text String To VRAM Using Font At X,Y Position
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
  la a0,SLLVCHECK0 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SLLVPASS0 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,24,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLVEND0
  nop // Delay Slot
  SLLVPASS0:
  PrintString($A0100000,528,24,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLVEND0:

  // Load RSP Code To IMEM
  DMASPRD(RSPSLLV1Code, RSPSLLV1CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  SetSPPC($0000) // Set RSP Program Counter: Set To Zero (Start Of RSP Code)
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
  la a0,SLLVCHECK1 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SLLVPASS1 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,32,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLVEND1
  nop // Delay Slot
  SLLVPASS1:
  PrintString($A0100000,528,32,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLVEND1:

  // Load RSP Code To IMEM
  DMASPRD(RSPSLLV2Code, RSPSLLV2CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  SetSPPC($0000) // Set RSP Program Counter: Set To Zero (Start Of RSP Code)
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
  la a0,SLLVCHECK2 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SLLVPASS2 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,40,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLVEND2
  nop // Delay Slot
  SLLVPASS2:
  PrintString($A0100000,528,40,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLVEND2:

  // Load RSP Code To IMEM
  DMASPRD(RSPSLLV3Code, RSPSLLV3CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  SetSPPC($0000) // Set RSP Program Counter: Set To Zero (Start Of RSP Code)
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
  la t0,SLLVCHECK3 // T0 = Word Check Data Offset
  lw t2,0(t0)      // T2 = Word Check Data
  beq t1,t2,SLLVPASS3 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,48,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLVEND3
  nop // Delay Slot
  SLLVPASS3:
  PrintString($A0100000,528,48,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLVEND3:

  // Load RSP Code To IMEM
  DMASPRD(RSPSLLV4Code, RSPSLLV4CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  SetSPPC($0000) // Set RSP Program Counter: Set To Zero (Start Of RSP Code)
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
  la a0,SLLVCHECK4 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SLLVPASS4 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,56,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLVEND4
  nop // Delay Slot
  SLLVPASS4:
  PrintString($A0100000,528,56,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLVEND4:

  // Load RSP Code To IMEM
  DMASPRD(RSPSLLV5Code, RSPSLLV5CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  SetSPPC($0000) // Set RSP Program Counter: Set To Zero (Start Of RSP Code)
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
  la a0,SLLVCHECK5 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SLLVPASS5 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,64,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLVEND5
  nop // Delay Slot
  SLLVPASS5:
  PrintString($A0100000,528,64,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLVEND5:

  // Load RSP Code To IMEM
  DMASPRD(RSPSLLV6Code, RSPSLLV6CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  SetSPPC($0000) // Set RSP Program Counter: Set To Zero (Start Of RSP Code)
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
  la a0,SLLVCHECK6 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SLLVPASS6 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,72,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLVEND6
  nop // Delay Slot
  SLLVPASS6:
  PrintString($A0100000,528,72,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLVEND6:

  // Load RSP Code To IMEM
  DMASPRD(RSPSLLV7Code, RSPSLLV7CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  SetSPPC($0000) // Set RSP Program Counter: Set To Zero (Start Of RSP Code)
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
  la a0,SLLVCHECK7 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SLLVPASS7 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,80,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLVEND7
  nop // Delay Slot
  SLLVPASS7:
  PrintString($A0100000,528,80,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLVEND7:

  // Load RSP Code To IMEM
  DMASPRD(RSPSLLV8Code, RSPSLLV8CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  SetSPPC($0000) // Set RSP Program Counter: Set To Zero (Start Of RSP Code)
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
  la a0,SLLVCHECK8 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SLLVPASS8 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,88,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLVEND8
  nop // Delay Slot
  SLLVPASS8:
  PrintString($A0100000,528,88,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLVEND8:

  // Load RSP Code To IMEM
  DMASPRD(RSPSLLV9Code, RSPSLLV9CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  SetSPPC($0000) // Set RSP Program Counter: Set To Zero (Start Of RSP Code)
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
  la a0,SLLVCHECK9 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SLLVPASS9 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,96,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLVEND9
  nop // Delay Slot
  SLLVPASS9:
  PrintString($A0100000,528,96,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLVEND9:

  // Load RSP Code To IMEM
  DMASPRD(RSPSLLV10Code, RSPSLLV10CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  SetSPPC($0000) // Set RSP Program Counter: Set To Zero (Start Of RSP Code)
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
  la a0,SLLVCHECK10 // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,SLLVPASS10 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,104,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLVEND10
  nop // Delay Slot
  SLLVPASS10:
  PrintString($A0100000,528,104,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLVEND10:

  // Load RSP Code To IMEM
  DMASPRD(RSPSLLV11Code, RSPSLLV11CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  SetSPPC($0000) // Set RSP Program Counter: Set To Zero (Start Of RSP Code)
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
  la a0,SLLVCHECK11 // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,SLLVPASS11 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,112,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLVEND11
  nop // Delay Slot
  SLLVPASS11:
  PrintString($A0100000,528,112,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLVEND11:

  // Load RSP Code To IMEM
  DMASPRD(RSPSLLV12Code, RSPSLLV12CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  SetSPPC($0000) // Set RSP Program Counter: Set To Zero (Start Of RSP Code)
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
  la a0,SLLVCHECK12 // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,SLLVPASS12 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,120,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLVEND12
  nop // Delay Slot
  SLLVPASS12:
  PrintString($A0100000,528,120,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLVEND12:

  // Load RSP Code To IMEM
  DMASPRD(RSPSLLV13Code, RSPSLLV13CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  SetSPPC($0000) // Set RSP Program Counter: Set To Zero (Start Of RSP Code)
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
  la a0,SLLVCHECK13 // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,SLLVPASS13 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,128,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLVEND13
  nop // Delay Slot
  SLLVPASS13:
  PrintString($A0100000,528,128,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLVEND13:

  // Load RSP Code To IMEM
  DMASPRD(RSPSLLV14Code, RSPSLLV14CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  SetSPPC($0000) // Set RSP Program Counter: Set To Zero (Start Of RSP Code)
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
  la a0,SLLVCHECK14 // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,SLLVPASS14 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,136,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLVEND14
  nop // Delay Slot
  SLLVPASS14:
  PrintString($A0100000,528,136,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLVEND14:

  // Load RSP Code To IMEM
  DMASPRD(RSPSLLV15Code, RSPSLLV15CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  SetSPPC($0000) // Set RSP Program Counter: Set To Zero (Start Of RSP Code)
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
  la a0,SLLVCHECK15 // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,SLLVPASS15 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,144,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLVEND15
  nop // Delay Slot
  SLLVPASS15:
  PrintString($A0100000,528,144,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLVEND15:

  // Load RSP Code To IMEM
  DMASPRD(RSPSLLV16Code, RSPSLLV16CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  SetSPPC($0000) // Set RSP Program Counter: Set To Zero (Start Of RSP Code)
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
  la a0,SLLVCHECK16 // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,SLLVPASS16 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,152,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLVEND16
  nop // Delay Slot
  SLLVPASS16:
  PrintString($A0100000,528,152,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLVEND16:

  // Load RSP Code To IMEM
  DMASPRD(RSPSLLV17Code, RSPSLLV17CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  SetSPPC($0000) // Set RSP Program Counter: Set To Zero (Start Of RSP Code)
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
  la a0,SLLVCHECK17 // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,SLLVPASS17 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,160,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLVEND17
  nop // Delay Slot
  SLLVPASS17:
  PrintString($A0100000,528,160,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLVEND17:

  // Load RSP Code To IMEM
  DMASPRD(RSPSLLV18Code, RSPSLLV18CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  SetSPPC($0000) // Set RSP Program Counter: Set To Zero (Start Of RSP Code)
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
  la a0,SLLVCHECK18 // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,SLLVPASS18 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,168,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLVEND18
  nop // Delay Slot
  SLLVPASS18:
  PrintString($A0100000,528,168,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLVEND18:

  // Load RSP Code To IMEM
  DMASPRD(RSPSLLV19Code, RSPSLLV19CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  SetSPPC($0000) // Set RSP Program Counter: Set To Zero (Start Of RSP Code)
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
  la a0,SLLVCHECK19 // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,SLLVPASS19 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,176,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLVEND19
  nop // Delay Slot
  SLLVPASS19:
  PrintString($A0100000,528,176,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLVEND19:

  // Load RSP Code To IMEM
  DMASPRD(RSPSLLV20Code, RSPSLLV20CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  SetSPPC($0000) // Set RSP Program Counter: Set To Zero (Start Of RSP Code)
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
  la a0,SLLVCHECK20 // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,SLLVPASS20 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,184,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLVEND20
  nop // Delay Slot
  SLLVPASS20:
  PrintString($A0100000,528,184,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLVEND20:

  // Load RSP Code To IMEM
  DMASPRD(RSPSLLV21Code, RSPSLLV21CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  SetSPPC($0000) // Set RSP Program Counter: Set To Zero (Start Of RSP Code)
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
  la a0,SLLVCHECK21 // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,SLLVPASS21 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,192,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLVEND21
  nop // Delay Slot
  SLLVPASS21:
  PrintString($A0100000,528,192,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLVEND21:

  // Load RSP Code To IMEM
  DMASPRD(RSPSLLV22Code, RSPSLLV22CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  SetSPPC($0000) // Set RSP Program Counter: Set To Zero (Start Of RSP Code)
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
  la a0,SLLVCHECK22 // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,SLLVPASS22 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,200,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLVEND22
  nop // Delay Slot
  SLLVPASS22:
  PrintString($A0100000,528,200,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLVEND22:

  // Load RSP Code To IMEM
  DMASPRD(RSPSLLV23Code, RSPSLLV23CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  SetSPPC($0000) // Set RSP Program Counter: Set To Zero (Start Of RSP Code)
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
  la a0,SLLVCHECK23 // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,SLLVPASS23 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,208,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLVEND23
  nop // Delay Slot
  SLLVPASS23:
  PrintString($A0100000,528,208,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLVEND23:

  // Load RSP Code To IMEM
  DMASPRD(RSPSLLV24Code, RSPSLLV24CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  SetSPPC($0000) // Set RSP Program Counter: Set To Zero (Start Of RSP Code)
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
  la a0,SLLVCHECK24 // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,SLLVPASS24 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,216,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLVEND24
  nop // Delay Slot
  SLLVPASS24:
  PrintString($A0100000,528,216,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLVEND24:

  // Load RSP Code To IMEM
  DMASPRD(RSPSLLV25Code, RSPSLLV25CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  SetSPPC($0000) // Set RSP Program Counter: Set To Zero (Start Of RSP Code)
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
  la a0,SLLVCHECK25 // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,SLLVPASS25 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,224,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLVEND25
  nop // Delay Slot
  SLLVPASS25:
  PrintString($A0100000,528,224,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLVEND25:

  // Load RSP Code To IMEM
  DMASPRD(RSPSLLV26Code, RSPSLLV26CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  SetSPPC($0000) // Set RSP Program Counter: Set To Zero (Start Of RSP Code)
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
  la a0,SLLVCHECK26 // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,SLLVPASS26 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,232,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLVEND26
  nop // Delay Slot
  SLLVPASS26:
  PrintString($A0100000,528,232,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLVEND26:

  // Load RSP Code To IMEM
  DMASPRD(RSPSLLV27Code, RSPSLLV27CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  SetSPPC($0000) // Set RSP Program Counter: Set To Zero (Start Of RSP Code)
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
  la a0,SLLVCHECK27 // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,SLLVPASS27 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,240,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLVEND27
  nop // Delay Slot
  SLLVPASS27:
  PrintString($A0100000,528,240,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLVEND27:

  // Load RSP Code To IMEM
  DMASPRD(RSPSLLV28Code, RSPSLLV28CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  SetSPPC($0000) // Set RSP Program Counter: Set To Zero (Start Of RSP Code)
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
  la a0,SLLVCHECK28 // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,SLLVPASS28 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,248,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLVEND28
  nop // Delay Slot
  SLLVPASS28:
  PrintString($A0100000,528,248,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLVEND28:

  // Load RSP Code To IMEM
  DMASPRD(RSPSLLV29Code, RSPSLLV29CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  SetSPPC($0000) // Set RSP Program Counter: Set To Zero (Start Of RSP Code)
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
  la a0,SLLVCHECK29 // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,SLLVPASS29 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,256,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLVEND29
  nop // Delay Slot
  SLLVPASS29:
  PrintString($A0100000,528,256,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLVEND29:

  // Load RSP Code To IMEM
  DMASPRD(RSPSLLV30Code, RSPSLLV30CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  SetSPPC($0000) // Set RSP Program Counter: Set To Zero (Start Of RSP Code)
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
  la a0,SLLVCHECK30 // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,SLLVPASS30 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,264,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLVEND30
  nop // Delay Slot
  SLLVPASS30:
  PrintString($A0100000,528,264,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLVEND30:

  // Load RSP Code To IMEM
  DMASPRD(RSPSLLV31Code, RSPSLLV31CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  SetSPPC($0000) // Set RSP Program Counter: Set To Zero (Start Of RSP Code)
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
  la a0,SLLVCHECK31 // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,SLLVPASS31 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,272,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLVEND31
  nop // Delay Slot
  SLLVPASS31:
  PrintString($A0100000,528,272,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLVEND31:


  PrintString($A0100000,0,280,FontBlack,PAGEBREAK,79) // Print Text String To VRAM Using Font At X,Y Position


Loop:
  WaitScanline($1E0) // Wait For Scanline To Reach Vertical Blank
  WaitScanline($1E2)

  ori t0,r0,$00000800 // Even Field
  sw t0,VI_Y_SCALE(a0)

  WaitScanline($1E0) // Wait For Scanline To Reach Vertical Blank
  WaitScanline($1E2)

  li t0,$02000800 // Odd Field
  sw t0,VI_Y_SCALE(a0)

  j Loop
  nop // Delay Slot

SLLV:
  db "SLLV"

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

SLLVCHECK0:
  dw $F8A432EB
SLLVCHECK1:
  dw $F14865D6
SLLVCHECK2:
  dw $E290CBAC
SLLVCHECK3:
  dw $C5219758
SLLVCHECK4:
  dw $8A432EB0
SLLVCHECK5:
  dw $14865D60
SLLVCHECK6:
  dw $290CBAC0
SLLVCHECK7:
  dw $52197580
SLLVCHECK8:
  dw $A432EB00
SLLVCHECK9:
  dw $4865D600
SLLVCHECK10:
  dw $90CBAC00
SLLVCHECK11:
  dw $21975800
SLLVCHECK12:
  dw $432EB000
SLLVCHECK13:
  dw $865D6000
SLLVCHECK14:
  dw $0CBAC000
SLLVCHECK15:
  dw $19758000
SLLVCHECK16:
  dw $32EB0000
SLLVCHECK17:
  dw $65D60000
SLLVCHECK18:
  dw $CBAC0000
SLLVCHECK19:
  dw $97580000
SLLVCHECK20:
  dw $2EB00000
SLLVCHECK21:
  dw $5D600000
SLLVCHECK22:
  dw $BAC00000
SLLVCHECK23:
  dw $75800000
SLLVCHECK24:
  dw $EB000000
SLLVCHECK25:
  dw $D6000000
SLLVCHECK26:
  dw $AC000000
SLLVCHECK27:
  dw $58000000
SLLVCHECK28:
  dw $B0000000
SLLVCHECK29:
  dw $60000000
SLLVCHECK30:
  dw $C0000000
SLLVCHECK31:
  dw $80000000

RDWORD:
  dw 0

arch n64.rsp
align(8) // Align 64-Bit
RSPSLLV0Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,0    // T1 = Shift Amount
  sllv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt
base RSPSLLV0Code+pc() // Set End Of RSP Code Object
RSPSLLV0CodeEnd:

align(8) // Align 64-Bit
RSPSLLV1Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,1    // T1 = Shift Amount
  sllv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt
base RSPSLLV1Code+pc() // Set End Of RSP Code Object
RSPSLLV1CodeEnd:

align(8) // Align 64-Bit
RSPSLLV2Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,2    // T1 = Shift Amount
  sllv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt
base RSPSLLV2Code+pc() // Set End Of RSP Code Object
RSPSLLV2CodeEnd:

align(8) // Align 64-Bit
RSPSLLV3Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,3    // T1 = Shift Amount
  sllv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt
base RSPSLLV3Code+pc() // Set End Of RSP Code Object
RSPSLLV3CodeEnd:

align(8) // Align 64-Bit
RSPSLLV4Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,4    // T1 = Shift Amount
  sllv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt
base RSPSLLV4Code+pc() // Set End Of RSP Code Object
RSPSLLV4CodeEnd:

align(8) // Align 64-Bit
RSPSLLV5Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,5    // T1 = Shift Amount
  sllv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt
base RSPSLLV5Code+pc() // Set End Of RSP Code Object
RSPSLLV5CodeEnd:

align(8) // Align 64-Bit
RSPSLLV6Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,6    // T1 = Shift Amount
  sllv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt
base RSPSLLV6Code+pc() // Set End Of RSP Code Object
RSPSLLV6CodeEnd:

align(8) // Align 64-Bit
RSPSLLV7Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,7    // T1 = Shift Amount
  sllv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt
base RSPSLLV7Code+pc() // Set End Of RSP Code Object
RSPSLLV7CodeEnd:

align(8) // Align 64-Bit
RSPSLLV8Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,8    // T1 = Shift Amount
  sllv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt
base RSPSLLV8Code+pc() // Set End Of RSP Code Object
RSPSLLV8CodeEnd:

align(8) // Align 64-Bit
RSPSLLV9Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,9    // T1 = Shift Amount
  sllv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt
base RSPSLLV9Code+pc() // Set End Of RSP Code Object
RSPSLLV9CodeEnd:

align(8) // Align 64-Bit
RSPSLLV10Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,10   // T1 = Shift Amount
  sllv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt
base RSPSLLV10Code+pc() // Set End Of RSP Code Object
RSPSLLV10CodeEnd:

align(8) // Align 64-Bit
RSPSLLV11Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,11   // T1 = Shift Amount
  sllv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt
base RSPSLLV11Code+pc() // Set End Of RSP Code Object
RSPSLLV11CodeEnd:

align(8) // Align 64-Bit
RSPSLLV12Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,12   // T1 = Shift Amount
  sllv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt
base RSPSLLV12Code+pc() // Set End Of RSP Code Object
RSPSLLV12CodeEnd:

align(8) // Align 64-Bit
RSPSLLV13Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,13   // T1 = Shift Amount
  sllv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt
base RSPSLLV13Code+pc() // Set End Of RSP Code Object
RSPSLLV13CodeEnd:

align(8) // Align 64-Bit
RSPSLLV14Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,14   // T1 = Shift Amount
  sllv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt
base RSPSLLV14Code+pc() // Set End Of RSP Code Object
RSPSLLV14CodeEnd:

align(8) // Align 64-Bit
RSPSLLV15Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,15   // T1 = Shift Amount
  sllv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt
base RSPSLLV15Code+pc() // Set End Of RSP Code Object
RSPSLLV15CodeEnd:

align(8) // Align 64-Bit
RSPSLLV16Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,16   // T1 = Shift Amount
  sllv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt
base RSPSLLV16Code+pc() // Set End Of RSP Code Object
RSPSLLV16CodeEnd:

align(8) // Align 64-Bit
RSPSLLV17Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,17   // T1 = Shift Amount
  sllv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt
base RSPSLLV17Code+pc() // Set End Of RSP Code Object
RSPSLLV17CodeEnd:

align(8) // Align 64-Bit
RSPSLLV18Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,18   // T1 = Shift Amount
  sllv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt
base RSPSLLV18Code+pc() // Set End Of RSP Code Object
RSPSLLV18CodeEnd:

align(8) // Align 64-Bit
RSPSLLV19Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,19   // T1 = Shift Amount
  sllv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt
base RSPSLLV19Code+pc() // Set End Of RSP Code Object
RSPSLLV19CodeEnd:

align(8) // Align 64-Bit
RSPSLLV20Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,20   // T1 = Shift Amount
  sllv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt
base RSPSLLV20Code+pc() // Set End Of RSP Code Object
RSPSLLV20CodeEnd:

align(8) // Align 64-Bit
RSPSLLV21Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,21   // T1 = Shift Amount
  sllv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt
base RSPSLLV21Code+pc() // Set End Of RSP Code Object
RSPSLLV21CodeEnd:

align(8) // Align 64-Bit
RSPSLLV22Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,22   // T1 = Shift Amount
  sllv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt
base RSPSLLV22Code+pc() // Set End Of RSP Code Object
RSPSLLV22CodeEnd:

align(8) // Align 64-Bit
RSPSLLV23Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,23   // T1 = Shift Amount
  sllv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt
base RSPSLLV23Code+pc() // Set End Of RSP Code Object
RSPSLLV23CodeEnd:

align(8) // Align 64-Bit
RSPSLLV24Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,24   // T1 = Shift Amount
  sllv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt
base RSPSLLV24Code+pc() // Set End Of RSP Code Object
RSPSLLV24CodeEnd:

align(8) // Align 64-Bit
RSPSLLV25Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,25   // T1 = Shift Amount
  sllv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt
base RSPSLLV25Code+pc() // Set End Of RSP Code Object
RSPSLLV25CodeEnd:

align(8) // Align 64-Bit
RSPSLLV26Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,26   // T1 = Shift Amount
  sllv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt
base RSPSLLV26Code+pc() // Set End Of RSP Code Object
RSPSLLV26CodeEnd:

align(8) // Align 64-Bit
RSPSLLV27Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,27   // T1 = Shift Amount
  sllv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt
base RSPSLLV27Code+pc() // Set End Of RSP Code Object
RSPSLLV27CodeEnd:

align(8) // Align 64-Bit
RSPSLLV28Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,28   // T1 = Shift Amount
  sllv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt
base RSPSLLV28Code+pc() // Set End Of RSP Code Object
RSPSLLV28CodeEnd:

align(8) // Align 64-Bit
RSPSLLV29Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,29   // T1 = Shift Amount
  sllv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt
base RSPSLLV29Code+pc() // Set End Of RSP Code Object
RSPSLLV29CodeEnd:

align(8) // Align 64-Bit
RSPSLLV30Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,30   // T1 = Shift Amount
  sllv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt
base RSPSLLV30Code+pc() // Set End Of RSP Code Object
RSPSLLV30CodeEnd:

align(8) // Align 64-Bit
RSPSLLV31Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  li t1,31   // T1 = Shift Amount
  sllv t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt
base RSPSLLV31Code+pc() // Set End Of RSP Code Object
RSPSLLV31CodeEnd:

insert FontBlack, "FontBlack8x8.bin"
insert FontGreen, "FontGreen8x8.bin"
insert FontRed, "FontRed8x8.bin"