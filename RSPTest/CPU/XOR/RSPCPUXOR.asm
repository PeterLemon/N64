// N64 'Bare Metal' RSP CPU Bitwise Logical EXCLUSIVE OR Test Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "RSPCPUXOR.N64", create
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


  PrintString($A0100000,88,8,FontRed,RSRTHEX,10) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,8,FontRed,RSRTDEC,14) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,384,8,FontRed,RDHEX,7) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,528,8,FontRed,TEST,10) // Print Text String To VRAM Using Font At X,Y Position


  PrintString($A0100000,0,16,FontBlack,PAGEBREAK,79) // Print Text String To VRAM Using Font At X,Y Position


  // Load RSP Code To IMEM
  DMASPRD(RSPXORCode, RSPXORCodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORDA // A1 = Word Data Offset
  lw t0,0(a1)      // T0 = Word Data
  sw t0,0(a0)      // Store Word Data To DMEM
  la a1,VALUEWORDB // A1 = Word Data Offset
  lw t0,0(a1)      // T0 = Word Data
  sw t0,4(a0)      // Store Word Data To DMEM

  SetSPPC($0000) // Set RSP Program Counter: Set To Zero (Start Of RSP Code)
  StartSP() // Start RSP Execution: RSP Status = Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break

  PrintString($A0100000,8,24,FontRed,XOR,2) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,144,24,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,24,FontBlack,VALUEWORDA,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,24,FontBlack,TEXTWORDA,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,144,32,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,32,FontBlack,VALUEWORDB,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,296,32,FontBlack,TEXTWORDB,8) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,32,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE // A0 = Test Word Data Offset
  lw t0,0(a0) // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintValue($A0100000,448,32,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD    // A0 = Word Data Offset
  lw t0,0(a0)     // T0 = Word Data
  la a0,XORCHECKA // A0 = Word Check Data Offset
  lw t1,0(a0)     // T1 = Word Check Data
  beq t0,t1,XORPASSA // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,32,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j XORENDA
  nop // Delay Slot
  XORPASSA:
  PrintString($A0100000,528,32,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  XORENDA:

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORDB // A1 = Word Data Offset
  lw t0,0(a1)      // T0 = Word Data
  sw t0,0(a0)      // Store Word Data To DMEM
  la a1,VALUEWORDC // A1 = Word Data Offset
  lw t0,0(a1)      // T0 = Word Data
  sw t0,4(a0)      // Store Word Data To DMEM

  StartSP() // Start RSP Execution: RSP Status = Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break

  PrintString($A0100000,144,48,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,48,FontBlack,VALUEWORDB,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,296,48,FontBlack,TEXTWORDB,8) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,144,56,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,56,FontBlack,VALUEWORDC,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,320,56,FontBlack,TEXTWORDC,5) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,56,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE // A0 = Test Word Data Offset
  lw t0,0(a0) // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintValue($A0100000,448,56,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD    // A0 = Word Data Offset
  lw t0,0(a0)     // T0 = Word Data
  la a0,XORCHECKB // A0 = Word Check Data Offset
  lw t1,0(a0)     // T1 = Word Check Data
  beq t0,t1,XORPASSB // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,56,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j XORENDB
  nop // Delay Slot
  XORPASSB:
  PrintString($A0100000,528,56,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  XORENDB:

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORDC // A1 = Word Data Offset
  lw t0,0(a1)      // T0 = Word Data
  sw t0,0(a0)      // Store Word Data To DMEM
  la a1,VALUEWORDD // A1 = Word Data Offset
  lw t0,0(a1)      // T0 = Word Data
  sw t0,4(a0)      // Store Word Data To DMEM

  StartSP() // Start RSP Execution: RSP Status = Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break

  PrintString($A0100000,144,72,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,72,FontBlack,VALUEWORDC,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,320,72,FontBlack,TEXTWORDC,5) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,144,80,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,80,FontBlack,VALUEWORDD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,296,80,FontBlack,TEXTWORDD,8) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,80,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE // A0 = Test Word Data Offset
  lw t0,0(a0) // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintValue($A0100000,448,80,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD    // A0 = Word Data Offset
  lw t0,0(a0)     // T0 = Word Data
  la a0,XORCHECKC // A0 = Word Check Data Offset
  lw t1,0(a0)     // T1 = Word Check Data
  beq t0,t1,XORPASSC // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,80,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j XORENDC
  nop // Delay Slot
  XORPASSC:
  PrintString($A0100000,528,80,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  XORENDC:

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORDD // A1 = Word Data Offset
  lw t0,0(a1)      // T0 = Word Data
  sw t0,0(a0)      // Store Word Data To DMEM
  la a1,VALUEWORDE // A1 = Word Data Offset
  lw t0,0(a1)      // T0 = Word Data
  sw t0,4(a0)      // Store Word Data To DMEM

  StartSP() // Start RSP Execution: RSP Status = Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break

  PrintString($A0100000,144,96,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,96,FontBlack,VALUEWORDD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,296,96,FontBlack,TEXTWORDD,8) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,144,104,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,104,FontBlack,VALUEWORDE,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,104,FontBlack,TEXTWORDE,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,104,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE // A0 = Test Word Data Offset
  lw t0,0(a0) // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintValue($A0100000,448,104,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD    // A0 = Word Data Offset
  lw t0,0(a0)     // T0 = Word Data
  la a0,XORCHECKD // A0 = Word Check Data Offset
  lw t1,0(a0)     // T1 = Word Check Data
  beq t0,t1,XORPASSD // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,104,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j XORENDD
  nop // Delay Slot
  XORPASSD:
  PrintString($A0100000,528,104,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  XORENDD:

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORDE // A1 = Word Data Offset
  lw t0,0(a1)      // T0 = Word Data
  sw t0,0(a0)      // Store Word Data To DMEM
  la a1,VALUEWORDF // A1 = Word Data Offset
  lw t0,0(a1)      // T0 = Word Data
  sw t0,4(a0)      // Store Word Data To DMEM

  StartSP() // Start RSP Execution: RSP Status = Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break

  PrintString($A0100000,144,120,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,120,FontBlack,VALUEWORDE,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,120,FontBlack,TEXTWORDE,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,144,128,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,128,FontBlack,VALUEWORDF,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,312,128,FontBlack,TEXTWORDF,6) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,128,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE // A0 = Test Word Data Offset
  lw t0,0(a0) // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintValue($A0100000,448,128,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD    // A0 = Word Data Offset
  lw t0,0(a0)     // T0 = Word Data
  la a0,XORCHECKE // A0 = Word Check Data Offset
  lw t1,0(a0)     // T1 = Word Check Data
  beq t0,t1,XORPASSE // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,128,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j XORENDE
  nop // Delay Slot
  XORPASSE:
  PrintString($A0100000,528,128,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  XORENDE:

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORDF // A1 = Word Data Offset
  lw t0,0(a1)      // T0 = Word Data
  sw t0,0(a0)      // Store Word Data To DMEM
  la a1,VALUEWORDG // A1 = Word Data Offset
  lw t0,0(a1)      // T0 = Word Data
  sw t0,4(a0)      // Store Word Data To DMEM

  StartSP() // Start RSP Execution: RSP Status = Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break

  PrintString($A0100000,144,144,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,144,FontBlack,VALUEWORDF,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,312,144,FontBlack,TEXTWORDF,6) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,144,152,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,152,FontBlack,VALUEWORDG,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,152,FontBlack,TEXTWORDG,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,152,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE // A0 = Test Word Data Offset
  lw t0,0(a0) // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintValue($A0100000,448,152,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD    // A0 = Word Data Offset
  lw t0,0(a0)     // T0 = Word Data
  la a0,XORCHECKF // A0 = Word Check Data Offset
  lw t1,0(a0)     // T1 = Word Check Data
  beq t0,t1,XORPASSF // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,152,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j XORENDF
  nop // Delay Slot
  XORPASSF:
  PrintString($A0100000,528,152,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  XORENDF:

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORDA // A1 = Word Data Offset
  lw t0,0(a1)      // T0 = Word Data
  sw t0,0(a0)      // Store Word Data To DMEM
  la a1,VALUEWORDG // A1 = Word Data Offset
  lw t0,0(a1)      // T0 = Word Data
  sw t0,4(a0)      // Store Word Data To DMEM

  StartSP() // Start RSP Execution: RSP Status = Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break

  PrintString($A0100000,144,168,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,168,FontBlack,VALUEWORDA,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,168,FontBlack,TEXTWORDA,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,144,176,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,176,FontBlack,VALUEWORDG,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,176,FontBlack,TEXTWORDG,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,176,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE // A0 = Test Word Data Offset
  lw t0,0(a0) // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintValue($A0100000,448,176,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD    // A0 = Word Data Offset
  lw t0,0(a0)     // T0 = Word Data
  la a0,XORCHECKG // A0 = Word Check Data Offset
  lw t1,0(a0)     // T1 = Word Check Data
  beq t0,t1,XORPASSG // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,176,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j XORENDG
  nop // Delay Slot
  XORPASSG:
  PrintString($A0100000,528,176,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  XORENDG:


  // Load RSP Code To IMEM
  DMASPRD(RSPXORICodeA, RSPXORICodeAEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORDA // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  StartSP() // Start RSP Execution: RSP Status = Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break

  PrintString($A0100000,8,192,FontRed,XORI,3) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,144,192,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,192,FontBlack,VALUEWORDA,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,192,FontBlack,TEXTWORDA,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,144,200,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,200,FontBlack,IWORDB,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,328,200,FontBlack,TEXTIWORDB,4) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,200,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE // A0 = Test Word Data Offset
  lw t0,0(a0) // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintValue($A0100000,448,200,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,XORICHECKA // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,XORIPASSA // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,200,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j XORIENDA
  nop // Delay Slot
  XORIPASSA:
  PrintString($A0100000,528,200,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  XORIENDA:

  // Load RSP Code To IMEM
  DMASPRD(RSPXORICodeB, RSPXORICodeBEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORDB // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  StartSP() // Start RSP Execution: RSP Status = Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break

  PrintString($A0100000,144,216,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,216,FontBlack,VALUEWORDB,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,296,216,FontBlack,TEXTWORDB,8) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,144,224,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,224,FontBlack,IWORDC,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,336,224,FontBlack,TEXTIWORDC,3) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,224,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE // A0 = Test Word Data Offset
  lw t0,0(a0) // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintValue($A0100000,448,224,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,XORICHECKB // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,XORIPASSB // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,224,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j XORIENDB
  nop // Delay Slot
  XORIPASSB:
  PrintString($A0100000,528,224,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  XORIENDB:

  // Load RSP Code To IMEM
  DMASPRD(RSPXORICodeC, RSPXORICodeCEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORDC // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  StartSP() // Start RSP Execution: RSP Status = Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break

  PrintString($A0100000,144,240,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,240,FontBlack,VALUEWORDC,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,320,240,FontBlack,TEXTWORDC,5) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,144,248,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,248,FontBlack,IWORDD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,328,248,FontBlack,TEXTIWORDD,4) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,248,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE // A0 = Test Word Data Offset
  lw t0,0(a0) // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintValue($A0100000,448,248,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,XORICHECKC // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,XORIPASSC // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,248,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j XORIENDC
  nop // Delay Slot
  XORIPASSC:
  PrintString($A0100000,528,248,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  XORIENDC:

  // Load RSP Code To IMEM
  DMASPRD(RSPXORICodeD, RSPXORICodeDEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,IWORDD // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  StartSP() // Start RSP Execution: RSP Status = Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break

  PrintString($A0100000,144,264,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,264,FontBlack,IWORDD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,328,264,FontBlack,TEXTIWORDD,4) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,144,272,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,272,FontBlack,IWORDE,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,328,272,FontBlack,TEXTIWORDE,4) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,272,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE // A0 = Test Word Data Offset
  lw t0,0(a0) // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintValue($A0100000,448,272,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,XORICHECKD // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,XORIPASSD // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,272,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j XORIENDD
  nop // Delay Slot
  XORIPASSD:
  PrintString($A0100000,528,272,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  XORIENDD:

  // Load RSP Code To IMEM
  DMASPRD(RSPXORICodeE, RSPXORICodeEEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORDE // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  StartSP() // Start RSP Execution: RSP Status = Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break

  PrintString($A0100000,144,288,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,288,FontBlack,VALUEWORDE,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,288,FontBlack,TEXTWORDE,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,144,296,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,296,FontBlack,IWORDF,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,336,296,FontBlack,TEXTIWORDF,3) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,296,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE // A0 = Test Word Data Offset
  lw t0,0(a0) // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintValue($A0100000,448,296,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,XORICHECKE // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,XORIPASSE // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,296,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j XORIENDE
  nop // Delay Slot
  XORIPASSE:
  PrintString($A0100000,528,296,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  XORIENDE:

  // Load RSP Code To IMEM
  DMASPRD(RSPXORICodeF, RSPXORICodeFEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORDF // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  StartSP() // Start RSP Execution: RSP Status = Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break

  PrintString($A0100000,144,312,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,312,FontBlack,VALUEWORDF,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,312,312,FontBlack,TEXTWORDF,6) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,144,320,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,320,FontBlack,IWORDG,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,328,320,FontBlack,TEXTIWORDG,4) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,320,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE // A0 = Test Word Data Offset
  lw t0,0(a0) // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintValue($A0100000,448,320,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,XORICHECKF // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,XORIPASSF // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,320,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j XORIENDF
  nop // Delay Slot
  XORIPASSF:
  PrintString($A0100000,528,320,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  XORIENDF:

  // Load RSP Data To DMEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VALUEWORDA // A1 = Word Data Offset
  lw t0,0(a1) // T0 = Word Data
  sw t0,0(a0) // Store Word Data To DMEM

  StartSP() // Start RSP Execution: RSP Status = Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break

  PrintString($A0100000,144,336,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,336,FontBlack,VALUEWORDA,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,336,FontBlack,TEXTWORDA,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,144,344,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,344,FontBlack,IWORDG,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,328,344,FontBlack,TEXTIWORDG,4) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,344,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  lui a0,SP_MEM_BASE // A0 = Test Word Data Offset
  lw t0,0(a0) // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintValue($A0100000,448,344,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,XORICHECKG // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,XORIPASSG // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,344,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j XORIENDG
  nop // Delay Slot
  XORIPASSG:
  PrintString($A0100000,528,344,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  XORIENDG:


  PrintString($A0100000,0,352,FontBlack,PAGEBREAK,79) // Print Text String To VRAM Using Font At X,Y Position


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

XOR:
  db "XOR"
XORI:
  db "XORI"

RDHEX:
  db "RD (Hex)"
RSRTHEX:
  db "RS/RT (Hex)"
RSRTDEC:
  db "RS/RT (Decimal)"
TEST:
  db "Test Result"
FAIL:
  db "FAIL"
PASS:
  db "PASS"

DOLLAR:
  db "$"

TEXTWORDA:
  db "0"
TEXTWORDB:
  db "123456789"
TEXTWORDC:
  db "123456"
TEXTWORDD:
  db "123451234"
TEXTWORDE:
  db "1234512345"
TEXTWORDF:
  db "1234567"
TEXTWORDG:
  db "1234567897"

TEXTIWORDB:
  db "12345"
TEXTIWORDC:
  db "1234"
TEXTIWORDD:
  db "12341"
TEXTIWORDE:
  db "23456"
TEXTIWORDF:
  db "3456"
TEXTIWORDG:
  db "32198"

PAGEBREAK:
  db "--------------------------------------------------------------------------------"

align(8) // Align 64-Bit
VALUEWORDA:
  dw 0
VALUEWORDB:
  dw 123456789
VALUEWORDC:
  dw 123456
VALUEWORDD:
  dw 123451234
VALUEWORDE:
  dw 1234512345
VALUEWORDF:
  dw 1234567
VALUEWORDG:
  dw 1234567891

XORCHECKA:
  dw $075BCD15
XORCHECKB:
  dw $075A2F55
XORCHECKC:
  dw $075A5522
XORCHECKD:
  dw $4ECE9EBB
XORCHECKE:
  dw $4987FF5E
XORCHECKF:
  dw $4984D454
XORCHECKG:
  dw $499602D3

constant VALUEIWORDB(12345)
constant VALUEIWORDC(1234)
constant VALUEIWORDD(12341)
constant VALUEIWORDE(23456)
constant VALUEIWORDF(3456)
constant VALUEIWORDG(32198)
IWORDB:
  dw 12345
IWORDC:
  dw 1234
IWORDD:
  dw 12341
IWORDE:
  dw 23456
IWORDF:
  dw 3456
IWORDG:
  dw 32198

XORICHECKA:
  dw $00003039
XORICHECKB:
  dw $075BC9C7
XORICHECKC:
  dw $0001D275
XORICHECKD:
  dw $00006B95
XORICHECKE:
  dw $49952459
XORICHECKF:
  dw $0012AB41
XORICHECKG:
  dw $00007DC6

RDWORD:
  dw 0

arch n64.rsp
align(8) // Align 64-Bit
RSPXORCode:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  lw t1,4(a0) // T1 = Word Data 1
  xor t0,t1 // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPXORCode+pc() // Set End Of RSP Code Object
RSPXORCodeEnd:

align(8) // Align 64-Bit
RSPXORICodeA:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  xori t0,VALUEIWORDB // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPXORICodeA+pc() // Set End Of RSP Code Object
RSPXORICodeAEnd:

align(8) // Align 64-Bit
RSPXORICodeB:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  xori t0,VALUEIWORDC // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPXORICodeB+pc() // Set End Of RSP Code Object
RSPXORICodeBEnd:

align(8) // Align 64-Bit
RSPXORICodeC:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  xori t0,VALUEIWORDD // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPXORICodeC+pc() // Set End Of RSP Code Object
RSPXORICodeCEnd:

align(8) // Align 64-Bit
RSPXORICodeD:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  xori t0,VALUEIWORDE // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPXORICodeD+pc() // Set End Of RSP Code Object
RSPXORICodeDEnd:

align(8) // Align 64-Bit
RSPXORICodeE:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  xori t0,VALUEIWORDF // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPXORICodeE+pc() // Set End Of RSP Code Object
RSPXORICodeEEnd:

align(8) // Align 64-Bit
RSPXORICodeF:
base $0000 // Set Base Of RSP Code Object To Zero
  la a0,$0000 // A0 = RSP DMEM Offset
  lw t0,0(a0) // T0 = Word Data 0
  xori t0,VALUEIWORDG // T0 = Test Word Data
  sw t0,0(a0) // RSP DMEM = Test Word Data
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
base RSPXORICodeF+pc() // Set End Of RSP Code Object
RSPXORICodeFEnd:

insert FontBlack, "FontBlack8x8.bin"
insert FontGreen, "FontGreen8x8.bin"
insert FontRed, "FontRed8x8.bin"