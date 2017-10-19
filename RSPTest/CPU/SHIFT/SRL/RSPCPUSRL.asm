// N64 'Bare Metal' RSP CPU Word Shift Right Logical (0..31) Test Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "RSPCPUSRL.N64", create
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
  PrintString($A0100000,232,8,FontRed,SADEC,11) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,384,8,FontRed,RDHEX,7) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,528,8,FontRed,TEST,10) // Print Text String To VRAM Using Font At X,Y Position


  PrintString($A0100000,0,16,FontBlack,PAGEBREAK,79) // Print Text String To VRAM Using Font At X,Y Position


  // Load RSP Code To IMEM
  DMASPRD(RSPSRL0Code, RSPSRL0CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  SetSPPC($0000) // Set RSP Program Counter: Set To Zero (Start Of RSP Code)
  StartSP() // Start RSP Execution: RSP Status = Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break

  PrintString($A0100000,8,24,FontRed,SRL,2) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,80,24,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,24,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,24,FontBlack,TEXTWORD0,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,24,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE // A0 = Test Word Data Offset
  lw t0,0(a0) // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintValue($A0100000,384,24,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD    // A0 = Word Data Offset
  lw t0,0(a0)     // T0 = Word Data
  la a0,SRLCHECK0 // A0 = Word Check Data Offset
  lw t1,0(a0)     // T1 = Word Check Data
  beq t0,t1,SRLPASS0 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,24,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLEND0
  nop // Delay Slot
  SRLPASS0:
  PrintString($A0100000,528,24,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLEND0:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRL1Code, RSPSRL1CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
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
  la a0,RDWORD    // A0 = Word Data Offset
  lw t0,0(a0)     // T0 = Word Data
  la a0,SRLCHECK1 // A0 = Word Check Data Offset
  lw t1,0(a0)     // T1 = Word Check Data
  beq t0,t1,SRLPASS1 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,32,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLEND1
  nop // Delay Slot
  SRLPASS1:
  PrintString($A0100000,528,32,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLEND1:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRL2Code, RSPSRL2CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
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
  la a0,RDWORD    // A0 = Word Data Offset
  lw t0,0(a0)     // T0 = Word Data
  la a0,SRLCHECK2 // A0 = Word Check Data Offset
  lw t1,0(a0)     // T1 = Word Check Data
  beq t0,t1,SRLPASS2 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,40,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLEND2
  nop // Delay Slot
  SRLPASS2:
  PrintString($A0100000,528,40,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLEND2:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRL3Code, RSPSRL3CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
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
  la a0,RDWORD    // A0 = Word Data Offset
  lw t0,0(a0)     // T0 = Word Data
  la a0,SRLCHECK3 // A0 = Word Check Data Offset
  lw t1,0(a0)     // T1 = Word Check Data
  beq t0,t1,SRLPASS3 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,48,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLEND3
  nop // Delay Slot
  SRLPASS3:
  PrintString($A0100000,528,48,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLEND3:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRL4Code, RSPSRL4CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
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
  la a0,RDWORD    // A0 = Word Data Offset
  lw t0,0(a0)     // T0 = Word Data
  la a0,SRLCHECK4 // A0 = Word Check Data Offset
  lw t1,0(a0)     // T1 = Word Check Data
  beq t0,t1,SRLPASS4 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,56,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLEND4
  nop // Delay Slot
  SRLPASS4:
  PrintString($A0100000,528,56,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLEND4:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRL5Code, RSPSRL5CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
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
  la a0,RDWORD    // A0 = Word Data Offset
  lw t0,0(a0)     // T0 = Word Data
  la a0,SRLCHECK5 // A0 = Word Check Data Offset
  lw t1,0(a0)     // T1 = Word Check Data
  beq t0,t1,SRLPASS5 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,64,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLEND5
  nop // Delay Slot
  SRLPASS5:
  PrintString($A0100000,528,64,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLEND5:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRL6Code, RSPSRL6CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
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
  la a0,RDWORD    // A0 = Word Data Offset
  lw t0,0(a0)     // T0 = Word Data
  la a0,SRLCHECK6 // A0 = Word Check Data Offset
  lw t1,0(a0)     // T1 = Word Check Data
  beq t0,t1,SRLPASS6 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,72,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLEND6
  nop // Delay Slot
  SRLPASS6:
  PrintString($A0100000,528,72,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLEND6:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRL7Code, RSPSRL7CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
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
  la a0,RDWORD    // A0 = Word Data Offset
  lw t0,0(a0)     // T0 = Word Data
  la a0,SRLCHECK7 // A0 = Word Check Data Offset
  lw t1,0(a0)     // T1 = Word Check Data
  beq t0,t1,SRLPASS7 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,80,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLEND7
  nop // Delay Slot
  SRLPASS7:
  PrintString($A0100000,528,80,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLEND7:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRL8Code, RSPSRL8CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
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
  la a0,RDWORD    // A0 = Word Data Offset
  lw t0,0(a0)     // T0 = Word Data
  la a0,SRLCHECK8 // A0 = Word Check Data Offset
  lw t1,0(a0)     // T1 = Word Check Data
  beq t0,t1,SRLPASS8 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,88,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLEND8
  nop // Delay Slot
  SRLPASS8:
  PrintString($A0100000,528,88,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLEND8:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRL9Code, RSPSRL9CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
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
  la a0,RDWORD    // A0 = Word Data Offset
  lw t0,0(a0)     // T0 = Word Data
  la a0,SRLCHECK9 // A0 = Word Check Data Offset
  lw t1,0(a0)     // T1 = Word Check Data
  beq t0,t1,SRLPASS9 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,96,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLEND9
  nop // Delay Slot
  SRLPASS9:
  PrintString($A0100000,528,96,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLEND9:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRL10Code, RSPSRL10CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
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
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,SRLCHECK10 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SRLPASS10 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,104,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLEND10
  nop // Delay Slot
  SRLPASS10:
  PrintString($A0100000,528,104,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLEND10:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRL11Code, RSPSRL11CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
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
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,SRLCHECK11 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SRLPASS11 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,112,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLEND11
  nop // Delay Slot
  SRLPASS11:
  PrintString($A0100000,528,112,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLEND11:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRL12Code, RSPSRL12CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
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
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,SRLCHECK12 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SRLPASS12 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,120,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLEND12
  nop // Delay Slot
  SRLPASS12:
  PrintString($A0100000,528,120,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLEND12:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRL13Code, RSPSRL13CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
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
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,SRLCHECK13 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SRLPASS13 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,128,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLEND13
  nop // Delay Slot
  SRLPASS13:
  PrintString($A0100000,528,128,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLEND13:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRL14Code, RSPSRL14CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
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
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,SRLCHECK14 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SRLPASS14 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,136,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLEND14
  nop // Delay Slot
  SRLPASS14:
  PrintString($A0100000,528,136,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLEND14:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRL15Code, RSPSRL15CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
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
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,SRLCHECK15 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SRLPASS15 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,144,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLEND15
  nop // Delay Slot
  SRLPASS15:
  PrintString($A0100000,528,144,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLEND15:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRL16Code, RSPSRL16CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
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
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,SRLCHECK16 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SRLPASS16 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,152,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLEND16
  nop // Delay Slot
  SRLPASS16:
  PrintString($A0100000,528,152,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLEND16:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRL17Code, RSPSRL17CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
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
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,SRLCHECK17 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SRLPASS17 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,160,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLEND17
  nop // Delay Slot
  SRLPASS17:
  PrintString($A0100000,528,160,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLEND17:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRL18Code, RSPSRL18CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
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
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,SRLCHECK18 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SRLPASS18 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,168,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLEND18
  nop // Delay Slot
  SRLPASS18:
  PrintString($A0100000,528,168,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLEND18:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRL19Code, RSPSRL19CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
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
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,SRLCHECK19 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SRLPASS19 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,176,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLEND19
  nop // Delay Slot
  SRLPASS19:
  PrintString($A0100000,528,176,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLEND19:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRL20Code, RSPSRL20CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
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
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,SRLCHECK20 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SRLPASS20 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,184,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLEND20
  nop // Delay Slot
  SRLPASS20:
  PrintString($A0100000,528,184,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLEND20:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRL21Code, RSPSRL21CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
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
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,SRLCHECK21 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SRLPASS21 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,192,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLEND21
  nop // Delay Slot
  SRLPASS21:
  PrintString($A0100000,528,192,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLEND21:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRL22Code, RSPSRL22CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
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
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,SRLCHECK22 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SRLPASS22 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,200,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLEND22
  nop // Delay Slot
  SRLPASS22:
  PrintString($A0100000,528,200,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLEND22:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRL23Code, RSPSRL23CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
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
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,SRLCHECK23 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SRLPASS23 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,208,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLEND23
  nop // Delay Slot
  SRLPASS23:
  PrintString($A0100000,528,208,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLEND23:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRL24Code, RSPSRL24CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
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
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,SRLCHECK24 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SRLPASS24 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,216,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLEND24
  nop // Delay Slot
  SRLPASS24:
  PrintString($A0100000,528,216,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLEND24:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRL25Code, RSPSRL25CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
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
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,SRLCHECK25 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SRLPASS25 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,224,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLEND25
  nop // Delay Slot
  SRLPASS25:
  PrintString($A0100000,528,224,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLEND25:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRL26Code, RSPSRL26CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
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
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,SRLCHECK26 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SRLPASS26 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,232,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLEND26
  nop // Delay Slot
  SRLPASS26:
  PrintString($A0100000,528,232,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLEND26:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRL27Code, RSPSRL27CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
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
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,SRLCHECK27 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SRLPASS27 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,240,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLEND27
  nop // Delay Slot
  SRLPASS27:
  PrintString($A0100000,528,240,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLEND27:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRL28Code, RSPSRL28CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
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
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,SRLCHECK28 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SRLPASS28 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,248,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLEND28
  nop // Delay Slot
  SRLPASS28:
  PrintString($A0100000,528,248,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLEND28:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRL29Code, RSPSRL29CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
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
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,SRLCHECK29 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SRLPASS29 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,256,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLEND29
  nop // Delay Slot
  SRLPASS29:
  PrintString($A0100000,528,256,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLEND29:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRL30Code, RSPSRL30CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
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
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,SRLCHECK30 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SRLPASS30 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,264,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLEND30
  nop // Delay Slot
  SRLPASS30:
  PrintString($A0100000,528,264,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLEND30:

  // Load RSP Code To IMEM
  DMASPRD(RSPSRL31Code, RSPSRL31CodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
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
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,SRLCHECK31 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SRLPASS31 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,272,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLEND31
  nop // Delay Slot
  SRLPASS31:
  PrintString($A0100000,528,272,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLEND31:


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

SRL:
  db "SRL"

RDHEX:
  db "RD (Hex)"
RTHEX:
  db "RT (Hex)"
SADEC:
  db "SA (Decimal)"
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

SRLCHECK0:
  dw $F8A432EB
SRLCHECK1:
  dw $7C521975
SRLCHECK2:
  dw $3E290CBA
SRLCHECK3:
  dw $1F14865D
SRLCHECK4:
  dw $0F8A432E
SRLCHECK5:
  dw $07C52197
SRLCHECK6:
  dw $03E290CB
SRLCHECK7:
  dw $01F14865
SRLCHECK8:
  dw $00F8A432
SRLCHECK9:
  dw $007C5219
SRLCHECK10:
  dw $003E290C
SRLCHECK11:
  dw $001F1486
SRLCHECK12:
  dw $000F8A43
SRLCHECK13:
  dw $0007C521
SRLCHECK14:
  dw $0003E290
SRLCHECK15:
  dw $0001F148
SRLCHECK16:
  dw $0000F8A4
SRLCHECK17:
  dw $00007C52
SRLCHECK18:
  dw $00003E29
SRLCHECK19:
  dw $00001F14
SRLCHECK20:
  dw $00000F8A
SRLCHECK21:
  dw $000007C5
SRLCHECK22:
  dw $000003E2
SRLCHECK23:
  dw $000001F1
SRLCHECK24:
  dw $000000F8
SRLCHECK25:
  dw $0000007C
SRLCHECK26:
  dw $0000003E
SRLCHECK27:
  dw $0000001F
SRLCHECK28:
  dw $0000000F
SRLCHECK29:
  dw $00000007
SRLCHECK30:
  dw $00000003
SRLCHECK31:
  dw $00000001

RDWORD:
  dw 0

arch n64.rsp
align(8) // Align 64-Bit
RSPSRL0Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  srl t0,0 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRL0Code+pc() // Set End Of RSP Code Object
RSPSRL0CodeEnd:

align(8) // Align 64-Bit
RSPSRL1Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  srl t0,1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRL1Code+pc() // Set End Of RSP Code Object
RSPSRL1CodeEnd:

align(8) // Align 64-Bit
RSPSRL2Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  srl t0,2 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRL2Code+pc() // Set End Of RSP Code Object
RSPSRL2CodeEnd:

align(8) // Align 64-Bit
RSPSRL3Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  srl t0,3 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRL3Code+pc() // Set End Of RSP Code Object
RSPSRL3CodeEnd:

align(8) // Align 64-Bit
RSPSRL4Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  srl t0,4 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRL4Code+pc() // Set End Of RSP Code Object
RSPSRL4CodeEnd:

align(8) // Align 64-Bit
RSPSRL5Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  srl t0,5 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRL5Code+pc() // Set End Of RSP Code Object
RSPSRL5CodeEnd:

align(8) // Align 64-Bit
RSPSRL6Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  srl t0,6 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRL6Code+pc() // Set End Of RSP Code Object
RSPSRL6CodeEnd:

align(8) // Align 64-Bit
RSPSRL7Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  srl t0,7 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRL7Code+pc() // Set End Of RSP Code Object
RSPSRL7CodeEnd:

align(8) // Align 64-Bit
RSPSRL8Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  srl t0,8 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRL8Code+pc() // Set End Of RSP Code Object
RSPSRL8CodeEnd:

align(8) // Align 64-Bit
RSPSRL9Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  srl t0,9 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRL9Code+pc() // Set End Of RSP Code Object
RSPSRL9CodeEnd:

align(8) // Align 64-Bit
RSPSRL10Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  srl t0,10 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRL10Code+pc() // Set End Of RSP Code Object
RSPSRL10CodeEnd:

align(8) // Align 64-Bit
RSPSRL11Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  srl t0,11 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRL11Code+pc() // Set End Of RSP Code Object
RSPSRL11CodeEnd:

align(8) // Align 64-Bit
RSPSRL12Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  srl t0,12 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRL12Code+pc() // Set End Of RSP Code Object
RSPSRL12CodeEnd:

align(8) // Align 64-Bit
RSPSRL13Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  srl t0,13 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRL13Code+pc() // Set End Of RSP Code Object
RSPSRL13CodeEnd:

align(8) // Align 64-Bit
RSPSRL14Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  srl t0,14 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRL14Code+pc() // Set End Of RSP Code Object
RSPSRL14CodeEnd:

align(8) // Align 64-Bit
RSPSRL15Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  srl t0,15 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRL15Code+pc() // Set End Of RSP Code Object
RSPSRL15CodeEnd:

align(8) // Align 64-Bit
RSPSRL16Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  srl t0,16 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRL16Code+pc() // Set End Of RSP Code Object
RSPSRL16CodeEnd:

align(8) // Align 64-Bit
RSPSRL17Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  srl t0,17 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRL17Code+pc() // Set End Of RSP Code Object
RSPSRL17CodeEnd:

align(8) // Align 64-Bit
RSPSRL18Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  srl t0,18 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRL18Code+pc() // Set End Of RSP Code Object
RSPSRL18CodeEnd:

align(8) // Align 64-Bit
RSPSRL19Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  srl t0,19 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRL19Code+pc() // Set End Of RSP Code Object
RSPSRL19CodeEnd:

align(8) // Align 64-Bit
RSPSRL20Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  srl t0,20 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRL20Code+pc() // Set End Of RSP Code Object
RSPSRL20CodeEnd:

align(8) // Align 64-Bit
RSPSRL21Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  srl t0,21 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRL21Code+pc() // Set End Of RSP Code Object
RSPSRL21CodeEnd:

align(8) // Align 64-Bit
RSPSRL22Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  srl t0,22 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRL22Code+pc() // Set End Of RSP Code Object
RSPSRL22CodeEnd:

align(8) // Align 64-Bit
RSPSRL23Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  srl t0,23 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRL23Code+pc() // Set End Of RSP Code Object
RSPSRL23CodeEnd:

align(8) // Align 64-Bit
RSPSRL24Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  srl t0,24 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRL24Code+pc() // Set End Of RSP Code Object
RSPSRL24CodeEnd:

align(8) // Align 64-Bit
RSPSRL25Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  srl t0,25 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRL25Code+pc() // Set End Of RSP Code Object
RSPSRL25CodeEnd:

align(8) // Align 64-Bit
RSPSRL26Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  srl t0,26 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRL26Code+pc() // Set End Of RSP Code Object
RSPSRL26CodeEnd:

align(8) // Align 64-Bit
RSPSRL27Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  srl t0,27 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRL27Code+pc() // Set End Of RSP Code Object
RSPSRL27CodeEnd:

align(8) // Align 64-Bit
RSPSRL28Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  srl t0,28 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRL28Code+pc() // Set End Of RSP Code Object
RSPSRL28CodeEnd:

align(8) // Align 64-Bit
RSPSRL29Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  srl t0,29 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRL29Code+pc() // Set End Of RSP Code Object
RSPSRL29CodeEnd:

align(8) // Align 64-Bit
RSPSRL30Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  srl t0,30 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRL30Code+pc() // Set End Of RSP Code Object
RSPSRL30CodeEnd:

align(8) // Align 64-Bit
RSPSRL31Code:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  srl t0,31 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPSRL31Code+pc() // Set End Of RSP Code Object
RSPSRL31CodeEnd:

insert FontBlack, "FontBlack8x8.bin"
insert FontGreen, "FontGreen8x8.bin"
insert FontRed, "FontRed8x8.bin"