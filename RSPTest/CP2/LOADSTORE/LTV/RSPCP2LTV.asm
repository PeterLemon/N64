// N64 'Bare Metal' RSP CP2 Load Transpose To Vector Register Test Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "RSPCP2LTV.N64", create
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


  PrintString($A0100000,40,8,FontRed,DMEMINHEX,15) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,312,8,FontRed,DMEMOUTHEX,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,552,8,FontRed,TEST,10) // Print Text String To VRAM Using Font At X,Y Position


  PrintString($A0100000,0,16,FontBlack,PAGEBREAK,79) // Print Text String To VRAM Using Font At X,Y Position


  // Load RSP Code To IMEM
  DMASPRD(RSPLTVCode, RSPLTVCodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  DMASPRD(VALUEDMEMA, VALUEDMEMHEnd, SP_DMEM)     // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  SetSPPC($0000) // Set RSP Program Counter: Set To Zero (Start Of RSP Code)
  StartSP() // Start RSP Execution: RSP Status = Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break

  PrintString($A0100000,0,24,FontRed,LTVTEXT,2) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,32,24,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,40,24,FontBlack,VALUEDMEMA,15) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,32,32,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,40,32,FontBlack,VALUEDMEMB,15) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,32,40,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,40,40,FontBlack,VALUEDMEMC,15) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,32,48,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,40,48,FontBlack,VALUEDMEMD,15) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,32,56,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,40,56,FontBlack,VALUEDMEME,15) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,32,64,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,40,64,FontBlack,VALUEDMEMF,15) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,32,72,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,40,72,FontBlack,VALUEDMEMG,15) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,32,80,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,40,80,FontBlack,VALUEDMEMH,15) // Print HEX Chars To VRAM Using Font At X,Y Position


  // Store RSP Data To MEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,DMEMQUAD // A1 = Quad Data Offset
  lw t0,0(a0)  // T0 = Quad Data
  sw t0,0(a1)  // Store Quad Data To MEM
  lw t0,4(a0)  // T0 = Quad Data
  sw t0,4(a1)  // Store Quad Data To MEM
  lw t0,8(a0)  // T0 = Quad Data
  sw t0,8(a1)  // Store Quad Data To MEM
  lw t0,12(a0) // T0 = Quad Data
  sw t0,12(a1) // Store Quad Data To MEM

  PrintString($A0100000,304,24,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,312,24,FontBlack,DMEMQUAD,15) // Print HEX Chars To VRAM Using Font At X,Y Position

  la a0,DMEMQUAD  // A0 = Quad Data Offset
  ld t0,0(a0)     // T0 = Quad Data
  la a0,LTVCHECKA // A0 = Quad Check Data Offset
  ld t1,0(a0)     // T1 = Quad Check Data
  bne t0,t1,LTVFAILA // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,DMEMQUAD  // A0 = Quad Data Offset
  ld t0,8(a0)     // T0 = Quad Data
  la a0,LTVCHECKA // A0 = Quad Check Data Offset
  ld t1,8(a0)     // T1 = Quad Check Data
  bne t0,t1,LTVFAILA // Compare Result Equality With Check Data
  nop // Delay Slot

  PrintString($A0100000,576,24,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  j LTVENDA
  nop // Delay Slot
  LTVFAILA:
  PrintString($A0100000,576,24,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  LTVENDA:


  // Store RSP Data To MEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  addiu a0,16
  la a1,DMEMQUAD // A1 = Quad Data Offset
  lw t0,0(a0)  // T0 = Quad Data
  sw t0,0(a1)  // Store Quad Data To MEM
  lw t0,4(a0)  // T0 = Quad Data
  sw t0,4(a1)  // Store Quad Data To MEM
  lw t0,8(a0)  // T0 = Quad Data
  sw t0,8(a1)  // Store Quad Data To MEM
  lw t0,12(a0) // T0 = Quad Data
  sw t0,12(a1) // Store Quad Data To MEM

  PrintString($A0100000,304,32,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,312,32,FontBlack,DMEMQUAD,15) // Print HEX Chars To VRAM Using Font At X,Y Position

  la a0,DMEMQUAD  // A0 = Quad Data Offset
  ld t0,0(a0)     // T0 = Quad Data
  la a0,LTVCHECKB // A0 = Quad Check Data Offset
  ld t1,0(a0)     // T1 = Quad Check Data
  bne t0,t1,LTVFAILB // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,DMEMQUAD  // A0 = Quad Data Offset
  ld t0,8(a0)     // T0 = Quad Data
  la a0,LTVCHECKB // A0 = Quad Check Data Offset
  ld t1,8(a0)     // T1 = Quad Check Data
  bne t0,t1,LTVFAILB // Compare Result Equality With Check Data
  nop // Delay Slot

  PrintString($A0100000,576,32,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  j LTVENDB
  nop // Delay Slot
  LTVFAILB:
  PrintString($A0100000,576,32,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  LTVENDB:


  // Store RSP Data To MEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  addiu a0,32
  la a1,DMEMQUAD // A1 = Quad Data Offset
  lw t0,0(a0)  // T0 = Quad Data
  sw t0,0(a1)  // Store Quad Data To MEM
  lw t0,4(a0)  // T0 = Quad Data
  sw t0,4(a1)  // Store Quad Data To MEM
  lw t0,8(a0)  // T0 = Quad Data
  sw t0,8(a1)  // Store Quad Data To MEM
  lw t0,12(a0) // T0 = Quad Data
  sw t0,12(a1) // Store Quad Data To MEM

  PrintString($A0100000,304,40,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,312,40,FontBlack,DMEMQUAD,15) // Print HEX Chars To VRAM Using Font At X,Y Position

  la a0,DMEMQUAD  // A0 = Quad Data Offset
  ld t0,0(a0)     // T0 = Quad Data
  la a0,LTVCHECKC // A0 = Quad Check Data Offset
  ld t1,0(a0)     // T1 = Quad Check Data
  bne t0,t1,LTVFAILC // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,DMEMQUAD  // A0 = Quad Data Offset
  ld t0,8(a0)     // T0 = Quad Data
  la a0,LTVCHECKC // A0 = Quad Check Data Offset
  ld t1,8(a0)     // T1 = Quad Check Data
  bne t0,t1,LTVFAILC // Compare Result Equality With Check Data
  nop // Delay Slot

  PrintString($A0100000,576,40,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  j LTVENDC
  nop // Delay Slot
  LTVFAILC:
  PrintString($A0100000,576,40,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  LTVENDC:


  // Store RSP Data To MEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  addiu a0,48
  la a1,DMEMQUAD // A1 = Quad Data Offset
  lw t0,0(a0)  // T0 = Quad Data
  sw t0,0(a1)  // Store Quad Data To MEM
  lw t0,4(a0)  // T0 = Quad Data
  sw t0,4(a1)  // Store Quad Data To MEM
  lw t0,8(a0)  // T0 = Quad Data
  sw t0,8(a1)  // Store Quad Data To MEM
  lw t0,12(a0) // T0 = Quad Data
  sw t0,12(a1) // Store Quad Data To MEM

  PrintString($A0100000,304,48,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,312,48,FontBlack,DMEMQUAD,15) // Print HEX Chars To VRAM Using Font At X,Y Position

  la a0,DMEMQUAD  // A0 = Quad Data Offset
  ld t0,0(a0)     // T0 = Quad Data
  la a0,LTVCHECKD // A0 = Quad Check Data Offset
  ld t1,0(a0)     // T1 = Quad Check Data
  bne t0,t1,LTVFAILD // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,DMEMQUAD  // A0 = Quad Data Offset
  ld t0,8(a0)     // T0 = Quad Data
  la a0,LTVCHECKD // A0 = Quad Check Data Offset
  ld t1,8(a0)     // T1 = Quad Check Data
  bne t0,t1,LTVFAILD // Compare Result Equality With Check Data
  nop // Delay Slot

  PrintString($A0100000,576,48,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  j LTVENDD
  nop // Delay Slot
  LTVFAILD:
  PrintString($A0100000,576,48,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  LTVENDD:


  // Store RSP Data To MEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  addiu a0,64
  la a1,DMEMQUAD // A1 = Quad Data Offset
  lw t0,0(a0)  // T0 = Quad Data
  sw t0,0(a1)  // Store Quad Data To MEM
  lw t0,4(a0)  // T0 = Quad Data
  sw t0,4(a1)  // Store Quad Data To MEM
  lw t0,8(a0)  // T0 = Quad Data
  sw t0,8(a1)  // Store Quad Data To MEM
  lw t0,12(a0) // T0 = Quad Data
  sw t0,12(a1) // Store Quad Data To MEM

  PrintString($A0100000,304,56,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,312,56,FontBlack,DMEMQUAD,15) // Print HEX Chars To VRAM Using Font At X,Y Position

  la a0,DMEMQUAD  // A0 = Quad Data Offset
  ld t0,0(a0)     // T0 = Quad Data
  la a0,LTVCHECKE // A0 = Quad Check Data Offset
  ld t1,0(a0)     // T1 = Quad Check Data
  bne t0,t1,LTVFAILE // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,DMEMQUAD  // A0 = Quad Data Offset
  ld t0,8(a0)     // T0 = Quad Data
  la a0,LTVCHECKE // A0 = Quad Check Data Offset
  ld t1,8(a0)     // T1 = Quad Check Data
  bne t0,t1,LTVFAILE // Compare Result Equality With Check Data
  nop // Delay Slot

  PrintString($A0100000,576,56,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  j LTVENDE
  nop // Delay Slot
  LTVFAILE:
  PrintString($A0100000,576,56,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  LTVENDE:


  // Store RSP Data To MEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  addiu a0,80
  la a1,DMEMQUAD // A1 = Quad Data Offset
  lw t0,0(a0)  // T0 = Quad Data
  sw t0,0(a1)  // Store Quad Data To MEM
  lw t0,4(a0)  // T0 = Quad Data
  sw t0,4(a1)  // Store Quad Data To MEM
  lw t0,8(a0)  // T0 = Quad Data
  sw t0,8(a1)  // Store Quad Data To MEM
  lw t0,12(a0) // T0 = Quad Data
  sw t0,12(a1) // Store Quad Data To MEM

  PrintString($A0100000,304,64,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,312,64,FontBlack,DMEMQUAD,15) // Print HEX Chars To VRAM Using Font At X,Y Position

  la a0,DMEMQUAD  // A0 = Quad Data Offset
  ld t0,0(a0)     // T0 = Quad Data
  la a0,LTVCHECKF // A0 = Quad Check Data Offset
  ld t1,0(a0)     // T1 = Quad Check Data
  bne t0,t1,LTVFAILF // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,DMEMQUAD  // A0 = Quad Data Offset
  ld t0,8(a0)     // T0 = Quad Data
  la a0,LTVCHECKF // A0 = Quad Check Data Offset
  ld t1,8(a0)     // T1 = Quad Check Data
  bne t0,t1,LTVFAILF // Compare Result Equality With Check Data
  nop // Delay Slot

  PrintString($A0100000,576,64,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  j LTVENDF
  nop // Delay Slot
  LTVFAILF:
  PrintString($A0100000,576,64,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  LTVENDF:


  // Store RSP Data To MEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  addiu a0,96
  la a1,DMEMQUAD // A1 = Quad Data Offset
  lw t0,0(a0)  // T0 = Quad Data
  sw t0,0(a1)  // Store Quad Data To MEM
  lw t0,4(a0)  // T0 = Quad Data
  sw t0,4(a1)  // Store Quad Data To MEM
  lw t0,8(a0)  // T0 = Quad Data
  sw t0,8(a1)  // Store Quad Data To MEM
  lw t0,12(a0) // T0 = Quad Data
  sw t0,12(a1) // Store Quad Data To MEM

  PrintString($A0100000,304,72,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,312,72,FontBlack,DMEMQUAD,15) // Print HEX Chars To VRAM Using Font At X,Y Position

  la a0,DMEMQUAD  // A0 = Quad Data Offset
  ld t0,0(a0)     // T0 = Quad Data
  la a0,LTVCHECKG // A0 = Quad Check Data Offset
  ld t1,0(a0)     // T1 = Quad Check Data
  bne t0,t1,LTVFAILG // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,DMEMQUAD  // A0 = Quad Data Offset
  ld t0,8(a0)     // T0 = Quad Data
  la a0,LTVCHECKG // A0 = Quad Check Data Offset
  ld t1,8(a0)     // T1 = Quad Check Data
  bne t0,t1,LTVFAILG // Compare Result Equality With Check Data
  nop // Delay Slot

  PrintString($A0100000,576,72,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  j LTVENDG
  nop // Delay Slot
  LTVFAILG:
  PrintString($A0100000,576,72,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  LTVENDG:


  // Store RSP Data To MEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  addiu a0,112
  la a1,DMEMQUAD // A1 = Quad Data Offset
  lw t0,0(a0)  // T0 = Quad Data
  sw t0,0(a1)  // Store Quad Data To MEM
  lw t0,4(a0)  // T0 = Quad Data
  sw t0,4(a1)  // Store Quad Data To MEM
  lw t0,8(a0)  // T0 = Quad Data
  sw t0,8(a1)  // Store Quad Data To MEM
  lw t0,12(a0) // T0 = Quad Data
  sw t0,12(a1) // Store Quad Data To MEM

  PrintString($A0100000,304,80,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,312,80,FontBlack,DMEMQUAD,15) // Print HEX Chars To VRAM Using Font At X,Y Position

  la a0,DMEMQUAD  // A0 = Quad Data Offset
  ld t0,0(a0)     // T0 = Quad Data
  la a0,LTVCHECKH // A0 = Quad Check Data Offset
  ld t1,0(a0)     // T1 = Quad Check Data
  bne t0,t1,LTVFAILH // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,DMEMQUAD  // A0 = Quad Data Offset
  ld t0,8(a0)     // T0 = Quad Data
  la a0,LTVCHECKH // A0 = Quad Check Data Offset
  ld t1,8(a0)     // T1 = Quad Check Data
  bne t0,t1,LTVFAILH // Compare Result Equality With Check Data
  nop // Delay Slot

  PrintString($A0100000,576,80,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  j LTVENDH
  nop // Delay Slot
  LTVFAILH:
  PrintString($A0100000,576,80,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  LTVENDH:


  PrintString($A0100000,0,88,FontBlack,PAGEBREAK,79) // Print Text String To VRAM Using Font At X,Y Position




  // Load RSP Code To IMEM
  DMASPRD(RSPSTVCode, RSPSTVCodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  DMASPRD(VALUEDMEMA, VALUEDMEMHEnd, SP_DMEM)     // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  SetSPPC($0000) // Set RSP Program Counter: Set To Zero (Start Of RSP Code)
  StartSP() // Start RSP Execution: RSP Status = Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break

  PrintString($A0100000,0,96,FontRed,STVTEXT,2) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,32,96,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,40,96,FontBlack,VALUEDMEMA,15) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,32,104,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,40,104,FontBlack,VALUEDMEMB,15) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,32,112,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,40,112,FontBlack,VALUEDMEMC,15) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,32,120,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,40,120,FontBlack,VALUEDMEMD,15) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,32,128,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,40,128,FontBlack,VALUEDMEME,15) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,32,136,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,40,136,FontBlack,VALUEDMEMF,15) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,32,144,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,40,144,FontBlack,VALUEDMEMG,15) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,32,152,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,40,152,FontBlack,VALUEDMEMH,15) // Print HEX Chars To VRAM Using Font At X,Y Position


  // Store RSP Data To MEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,DMEMQUAD // A1 = Quad Data Offset
  lw t0,0(a0)  // T0 = Quad Data
  sw t0,0(a1)  // Store Quad Data To MEM
  lw t0,4(a0)  // T0 = Quad Data
  sw t0,4(a1)  // Store Quad Data To MEM
  lw t0,8(a0)  // T0 = Quad Data
  sw t0,8(a1)  // Store Quad Data To MEM
  lw t0,12(a0) // T0 = Quad Data
  sw t0,12(a1) // Store Quad Data To MEM

  PrintString($A0100000,304,96,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,312,96,FontBlack,DMEMQUAD,15) // Print HEX Chars To VRAM Using Font At X,Y Position

  la a0,DMEMQUAD  // A0 = Quad Data Offset
  ld t0,0(a0)     // T0 = Quad Data
  la a0,STVCHECKA // A0 = Quad Check Data Offset
  ld t1,0(a0)     // T1 = Quad Check Data
  bne t0,t1,STVFAILA // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,DMEMQUAD  // A0 = Quad Data Offset
  ld t0,8(a0)     // T0 = Quad Data
  la a0,STVCHECKA // A0 = Quad Check Data Offset
  ld t1,8(a0)     // T1 = Quad Check Data
  bne t0,t1,STVFAILA // Compare Result Equality With Check Data
  nop // Delay Slot

  PrintString($A0100000,576,96,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  j STVENDA
  nop // Delay Slot
  STVFAILA:
  PrintString($A0100000,576,96,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  STVENDA:


  // Store RSP Data To MEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  addiu a0,16
  la a1,DMEMQUAD // A1 = Quad Data Offset
  lw t0,0(a0)  // T0 = Quad Data
  sw t0,0(a1)  // Store Quad Data To MEM
  lw t0,4(a0)  // T0 = Quad Data
  sw t0,4(a1)  // Store Quad Data To MEM
  lw t0,8(a0)  // T0 = Quad Data
  sw t0,8(a1)  // Store Quad Data To MEM
  lw t0,12(a0) // T0 = Quad Data
  sw t0,12(a1) // Store Quad Data To MEM

  PrintString($A0100000,304,104,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,312,104,FontBlack,DMEMQUAD,15) // Print HEX Chars To VRAM Using Font At X,Y Position

  la a0,DMEMQUAD  // A0 = Quad Data Offset
  ld t0,0(a0)     // T0 = Quad Data
  la a0,STVCHECKB // A0 = Quad Check Data Offset
  ld t1,0(a0)     // T1 = Quad Check Data
  bne t0,t1,STVFAILB // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,DMEMQUAD  // A0 = Quad Data Offset
  ld t0,8(a0)     // T0 = Quad Data
  la a0,STVCHECKB // A0 = Quad Check Data Offset
  ld t1,8(a0)     // T1 = Quad Check Data
  bne t0,t1,STVFAILB // Compare Result Equality With Check Data
  nop // Delay Slot

  PrintString($A0100000,576,104,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  j STVENDB
  nop // Delay Slot
  STVFAILB:
  PrintString($A0100000,576,104,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  STVENDB:


  // Store RSP Data To MEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  addiu a0,32
  la a1,DMEMQUAD // A1 = Quad Data Offset
  lw t0,0(a0)  // T0 = Quad Data
  sw t0,0(a1)  // Store Quad Data To MEM
  lw t0,4(a0)  // T0 = Quad Data
  sw t0,4(a1)  // Store Quad Data To MEM
  lw t0,8(a0)  // T0 = Quad Data
  sw t0,8(a1)  // Store Quad Data To MEM
  lw t0,12(a0) // T0 = Quad Data
  sw t0,12(a1) // Store Quad Data To MEM

  PrintString($A0100000,304,112,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,312,112,FontBlack,DMEMQUAD,15) // Print HEX Chars To VRAM Using Font At X,Y Position

  la a0,DMEMQUAD  // A0 = Quad Data Offset
  ld t0,0(a0)     // T0 = Quad Data
  la a0,STVCHECKC // A0 = Quad Check Data Offset
  ld t1,0(a0)     // T1 = Quad Check Data
  bne t0,t1,STVFAILC // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,DMEMQUAD  // A0 = Quad Data Offset
  ld t0,8(a0)     // T0 = Quad Data
  la a0,STVCHECKC // A0 = Quad Check Data Offset
  ld t1,8(a0)     // T1 = Quad Check Data
  bne t0,t1,STVFAILC // Compare Result Equality With Check Data
  nop // Delay Slot

  PrintString($A0100000,576,112,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  j STVENDC
  nop // Delay Slot
  STVFAILC:
  PrintString($A0100000,576,112,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  STVENDC:


  // Store RSP Data To MEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  addiu a0,48
  la a1,DMEMQUAD // A1 = Quad Data Offset
  lw t0,0(a0)  // T0 = Quad Data
  sw t0,0(a1)  // Store Quad Data To MEM
  lw t0,4(a0)  // T0 = Quad Data
  sw t0,4(a1)  // Store Quad Data To MEM
  lw t0,8(a0)  // T0 = Quad Data
  sw t0,8(a1)  // Store Quad Data To MEM
  lw t0,12(a0) // T0 = Quad Data
  sw t0,12(a1) // Store Quad Data To MEM

  PrintString($A0100000,304,120,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,312,120,FontBlack,DMEMQUAD,15) // Print HEX Chars To VRAM Using Font At X,Y Position

  la a0,DMEMQUAD  // A0 = Quad Data Offset
  ld t0,0(a0)     // T0 = Quad Data
  la a0,STVCHECKD // A0 = Quad Check Data Offset
  ld t1,0(a0)     // T1 = Quad Check Data
  bne t0,t1,STVFAILD // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,DMEMQUAD  // A0 = Quad Data Offset
  ld t0,8(a0)     // T0 = Quad Data
  la a0,STVCHECKD // A0 = Quad Check Data Offset
  ld t1,8(a0)     // T1 = Quad Check Data
  bne t0,t1,STVFAILD // Compare Result Equality With Check Data
  nop // Delay Slot

  PrintString($A0100000,576,120,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  j STVENDD
  nop // Delay Slot
  STVFAILD:
  PrintString($A0100000,576,120,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  STVENDD:


  // Store RSP Data To MEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  addiu a0,64
  la a1,DMEMQUAD // A1 = Quad Data Offset
  lw t0,0(a0)  // T0 = Quad Data
  sw t0,0(a1)  // Store Quad Data To MEM
  lw t0,4(a0)  // T0 = Quad Data
  sw t0,4(a1)  // Store Quad Data To MEM
  lw t0,8(a0)  // T0 = Quad Data
  sw t0,8(a1)  // Store Quad Data To MEM
  lw t0,12(a0) // T0 = Quad Data
  sw t0,12(a1) // Store Quad Data To MEM

  PrintString($A0100000,304,128,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,312,128,FontBlack,DMEMQUAD,15) // Print HEX Chars To VRAM Using Font At X,Y Position

  la a0,DMEMQUAD  // A0 = Quad Data Offset
  ld t0,0(a0)     // T0 = Quad Data
  la a0,STVCHECKE // A0 = Quad Check Data Offset
  ld t1,0(a0)     // T1 = Quad Check Data
  bne t0,t1,STVFAILE // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,DMEMQUAD  // A0 = Quad Data Offset
  ld t0,8(a0)     // T0 = Quad Data
  la a0,STVCHECKE // A0 = Quad Check Data Offset
  ld t1,8(a0)     // T1 = Quad Check Data
  bne t0,t1,STVFAILE // Compare Result Equality With Check Data
  nop // Delay Slot

  PrintString($A0100000,576,128,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  j STVENDE
  nop // Delay Slot
  STVFAILE:
  PrintString($A0100000,576,128,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  STVENDE:


  // Store RSP Data To MEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  addiu a0,80
  la a1,DMEMQUAD // A1 = Quad Data Offset
  lw t0,0(a0)  // T0 = Quad Data
  sw t0,0(a1)  // Store Quad Data To MEM
  lw t0,4(a0)  // T0 = Quad Data
  sw t0,4(a1)  // Store Quad Data To MEM
  lw t0,8(a0)  // T0 = Quad Data
  sw t0,8(a1)  // Store Quad Data To MEM
  lw t0,12(a0) // T0 = Quad Data
  sw t0,12(a1) // Store Quad Data To MEM

  PrintString($A0100000,304,136,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,312,136,FontBlack,DMEMQUAD,15) // Print HEX Chars To VRAM Using Font At X,Y Position

  la a0,DMEMQUAD  // A0 = Quad Data Offset
  ld t0,0(a0)     // T0 = Quad Data
  la a0,STVCHECKF // A0 = Quad Check Data Offset
  ld t1,0(a0)     // T1 = Quad Check Data
  bne t0,t1,STVFAILF // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,DMEMQUAD  // A0 = Quad Data Offset
  ld t0,8(a0)     // T0 = Quad Data
  la a0,STVCHECKF // A0 = Quad Check Data Offset
  ld t1,8(a0)     // T1 = Quad Check Data
  bne t0,t1,STVFAILF // Compare Result Equality With Check Data
  nop // Delay Slot

  PrintString($A0100000,576,136,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  j STVENDF
  nop // Delay Slot
  STVFAILF:
  PrintString($A0100000,576,136,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  STVENDF:


  // Store RSP Data To MEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  addiu a0,96
  la a1,DMEMQUAD // A1 = Quad Data Offset
  lw t0,0(a0)  // T0 = Quad Data
  sw t0,0(a1)  // Store Quad Data To MEM
  lw t0,4(a0)  // T0 = Quad Data
  sw t0,4(a1)  // Store Quad Data To MEM
  lw t0,8(a0)  // T0 = Quad Data
  sw t0,8(a1)  // Store Quad Data To MEM
  lw t0,12(a0) // T0 = Quad Data
  sw t0,12(a1) // Store Quad Data To MEM

  PrintString($A0100000,304,144,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,312,144,FontBlack,DMEMQUAD,15) // Print HEX Chars To VRAM Using Font At X,Y Position

  la a0,DMEMQUAD  // A0 = Quad Data Offset
  ld t0,0(a0)     // T0 = Quad Data
  la a0,STVCHECKG // A0 = Quad Check Data Offset
  ld t1,0(a0)     // T1 = Quad Check Data
  bne t0,t1,STVFAILG // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,DMEMQUAD  // A0 = Quad Data Offset
  ld t0,8(a0)     // T0 = Quad Data
  la a0,STVCHECKG // A0 = Quad Check Data Offset
  ld t1,8(a0)     // T1 = Quad Check Data
  bne t0,t1,STVFAILG // Compare Result Equality With Check Data
  nop // Delay Slot

  PrintString($A0100000,576,144,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  j STVENDG
  nop // Delay Slot
  STVFAILG:
  PrintString($A0100000,576,144,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  STVENDG:


  // Store RSP Data To MEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  addiu a0,112
  la a1,DMEMQUAD // A1 = Quad Data Offset
  lw t0,0(a0)  // T0 = Quad Data
  sw t0,0(a1)  // Store Quad Data To MEM
  lw t0,4(a0)  // T0 = Quad Data
  sw t0,4(a1)  // Store Quad Data To MEM
  lw t0,8(a0)  // T0 = Quad Data
  sw t0,8(a1)  // Store Quad Data To MEM
  lw t0,12(a0) // T0 = Quad Data
  sw t0,12(a1) // Store Quad Data To MEM

  PrintString($A0100000,304,152,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,312,152,FontBlack,DMEMQUAD,15) // Print HEX Chars To VRAM Using Font At X,Y Position

  la a0,DMEMQUAD  // A0 = Quad Data Offset
  ld t0,0(a0)     // T0 = Quad Data
  la a0,STVCHECKH // A0 = Quad Check Data Offset
  ld t1,0(a0)     // T1 = Quad Check Data
  bne t0,t1,STVFAILH // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,DMEMQUAD  // A0 = Quad Data Offset
  ld t0,8(a0)     // T0 = Quad Data
  la a0,STVCHECKH // A0 = Quad Check Data Offset
  ld t1,8(a0)     // T1 = Quad Check Data
  bne t0,t1,STVFAILH // Compare Result Equality With Check Data
  nop // Delay Slot

  PrintString($A0100000,576,152,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  j STVENDH
  nop // Delay Slot
  STVFAILH:
  PrintString($A0100000,576,152,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  STVENDH:


  PrintString($A0100000,0,160,FontBlack,PAGEBREAK,79) // Print Text String To VRAM Using Font At X,Y Position


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

LTVTEXT:
  db "LTV"
STVTEXT:
  db "STV"

DMEMINHEX:
  db "DMEM Input (Hex)"
DMEMOUTHEX:
  db "DMEM Output (Hex)"
TEST:
  db "Test Result"
FAIL:
  db "FAIL"
PASS:
  db "PASS"

DOLLAR:
  db "$"

PAGEBREAK:
  db "--------------------------------------------------------------------------------"

align(8) // Align 64-Bit
VALUEDMEMA:
  dh $0001, $0002, $0003, $0004, $0005, $0006, $0007, $0008
VALUEDMEMAEnd:

VALUEDMEMB:
  dh $0009, $0010, $0011, $0012, $0013, $0014, $0015, $0016
VALUEDMEMBEnd:

VALUEDMEMC:
  dh $0017, $0018, $0019, $0020, $0021, $0022, $0023, $0024
VALUEDMEMCEnd:

VALUEDMEMD:
  dh $0025, $0026, $0027, $0028, $0029, $0030, $0031, $0032
VALUEDMEMDEnd:

VALUEDMEME:
  dh $0033, $0034, $0035, $0036, $0037, $0038, $0039, $0040
VALUEDMEMEEnd:

VALUEDMEMF:
  dh $0041, $0042, $0043, $0044, $0045, $0046, $0047, $0048
VALUEDMEMFEnd:

VALUEDMEMG:
  dh $0049, $0050, $0051, $0052, $0053, $0054, $0055, $0056
VALUEDMEMGEnd:

VALUEDMEMH:
  dh $0057, $0058, $0059, $0060, $0061, $0062, $0063, $0064
VALUEDMEMHEnd:

LTVCHECKA:
  dh $0001, $0057, $0049, $0041, $0033, $0025, $0017, $0009
LTVCHECKB:
  dh $0010, $0002, $0058, $0050, $0042, $0034, $0026, $0018
LTVCHECKC:
  dh $0019, $0011, $0003, $0059, $0051, $0043, $0035, $0027
LTVCHECKD:
  dh $0028, $0020, $0012, $0004, $0060, $0052, $0044, $0036
LTVCHECKE:
  dh $0037, $0029, $0021, $0013, $0005, $0061, $0053, $0045
LTVCHECKF:
  dh $0046, $0038, $0030, $0022, $0014, $0006, $0062, $0054
LTVCHECKG:
  dh $0055, $0047, $0039, $0031, $0023, $0015, $0007, $0063
LTVCHECKH:
  dh $0064, $0056, $0048, $0040, $0032, $0024, $0016, $0008

STVCHECKA:
  dh $0001, $0010, $0019, $0028, $0037, $0046, $0055, $0064
STVCHECKB:
  dh $0009, $0018, $0027, $0036, $0045, $0054, $0063, $0008
STVCHECKC:
  dh $0017, $0026, $0035, $0044, $0053, $0062, $0007, $0016
STVCHECKD:
  dh $0025, $0034, $0043, $0052, $0061, $0006, $0015, $0024
STVCHECKE:
  dh $0033, $0042, $0051, $0060, $0005, $0014, $0023, $0032
STVCHECKF:
  dh $0041, $0050, $0059, $0004, $0013, $0022, $0031, $0040
STVCHECKG:
  dh $0049, $0058, $0003, $0012, $0021, $0030, $0039, $0048
STVCHECKH:
  dh $0057, $0002, $0011, $0020, $0029, $0038, $0047, $0056

DMEMQUAD:
  dh $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000

arch n64.rsp
align(8) // Align 64-Bit
RSPLTVCode:
base $0000 // Set Base Of RSP Code Object To Zero
  ltv v0[e0],$00(r0)  // V0..V7 = 128-Bit DMEM $000(R0), Load Transpose To Vector: LTV VT[ELEMENT],$OFFSET(BASE)
  ltv v0[e2],$10(r0)  // V0..V7 = 128-Bit DMEM $010(R0), Load Transpose To Vector: LTV VT[ELEMENT],$OFFSET(BASE)
  ltv v0[e4],$20(r0)  // V0..V7 = 128-Bit DMEM $010(R0), Load Transpose To Vector: LTV VT[ELEMENT],$OFFSET(BASE)
  ltv v0[e6],$30(r0)  // V0..V7 = 128-Bit DMEM $010(R0), Load Transpose To Vector: LTV VT[ELEMENT],$OFFSET(BASE)
  ltv v0[e8],$40(r0)  // V0..V7 = 128-Bit DMEM $010(R0), Load Transpose To Vector: LTV VT[ELEMENT],$OFFSET(BASE)
  ltv v0[e10],$50(r0) // V0..V7 = 128-Bit DMEM $010(R0), Load Transpose To Vector: LTV VT[ELEMENT],$OFFSET(BASE)
  ltv v0[e12],$60(r0) // V0..V7 = 128-Bit DMEM $010(R0), Load Transpose To Vector: LTV VT[ELEMENT],$OFFSET(BASE)
  ltv v0[e14],$70(r0) // V0..V7 = 128-Bit DMEM $010(R0), Load Transpose To Vector: LTV VT[ELEMENT],$OFFSET(BASE)
  sqv v0[e0],$00(r0) // 128-Bit DMEM $000(R0) = V0, Store Vector To Quad: SQV VT[ELEMENT],$OFFSET(BASE)
  sqv v1[e0],$10(r0) // 128-Bit DMEM $010(R0) = V1, Store Vector To Quad: SQV VT[ELEMENT],$OFFSET(BASE)
  sqv v2[e0],$20(r0) // 128-Bit DMEM $020(R0) = V2, Store Vector To Quad: SQV VT[ELEMENT],$OFFSET(BASE)
  sqv v3[e0],$30(r0) // 128-Bit DMEM $030(R0) = V3, Store Vector To Quad: SQV VT[ELEMENT],$OFFSET(BASE)
  sqv v4[e0],$40(r0) // 128-Bit DMEM $040(R0) = V4, Store Vector To Quad: SQV VT[ELEMENT],$OFFSET(BASE)
  sqv v5[e0],$50(r0) // 128-Bit DMEM $050(R0) = V5, Store Vector To Quad: SQV VT[ELEMENT],$OFFSET(BASE)
  sqv v6[e0],$60(r0) // 128-Bit DMEM $060(R0) = V6, Store Vector To Quad: SQV VT[ELEMENT],$OFFSET(BASE)
  sqv v7[e0],$70(r0) // 128-Bit DMEM $070(R0) = V7, Store Vector To Quad: SQV VT[ELEMENT],$OFFSET(BASE)
  break // Set SP Status Halt, Broke & Check For Interrupt
align(8) // Align 64-Bit
base RSPLTVCode+pc() // Set End Of RSP Code Object
RSPLTVCodeEnd:

arch n64.rsp
align(8) // Align 64-Bit
RSPSTVCode:
base $0000 // Set Base Of RSP Code Object To Zero
  lqv v0[e0],$00(r0) // V0 = 128-Bit DMEM $000(R0), Load Quad To Vector: LQV VT[ELEMENT],$OFFSET(BASE)
  lqv v1[e0],$10(r0) // V1 = 128-Bit DMEM $010(R0), Load Quad To Vector: LQV VT[ELEMENT],$OFFSET(BASE)
  lqv v2[e0],$20(r0) // V2 = 128-Bit DMEM $020(R0), Load Quad To Vector: LQV VT[ELEMENT],$OFFSET(BASE)
  lqv v3[e0],$30(r0) // V3 = 128-Bit DMEM $030(R0), Load Quad To Vector: LQV VT[ELEMENT],$OFFSET(BASE)
  lqv v4[e0],$40(r0) // V4 = 128-Bit DMEM $040(R0), Load Quad To Vector: LQV VT[ELEMENT],$OFFSET(BASE)
  lqv v5[e0],$50(r0) // V5 = 128-Bit DMEM $050(R0), Load Quad To Vector: LQV VT[ELEMENT],$OFFSET(BASE)
  lqv v6[e0],$60(r0) // V6 = 128-Bit DMEM $060(R0), Load Quad To Vector: LQV VT[ELEMENT],$OFFSET(BASE)
  lqv v7[e0],$70(r0) // V7 = 128-Bit DMEM $070(R0), Load Quad To Vector: LQV VT[ELEMENT],$OFFSET(BASE)
  stv v0[e0],$00(r0)  // 128-Bit DMEM $000(R0) = V0..V7, Store Transpose From Vector: STV VT[ELEMENT],$OFFSET(BASE)
  stv v0[e2],$10(r0)  // 128-Bit DMEM $010(R0) = V0..V7, Store Transpose From Vector: STV VT[ELEMENT],$OFFSET(BASE)
  stv v0[e4],$20(r0)  // 128-Bit DMEM $010(R0) = V0..V7, Store Transpose From Vector: STV VT[ELEMENT],$OFFSET(BASE)
  stv v0[e6],$30(r0)  // 128-Bit DMEM $010(R0) = V0..V7, Store Transpose From Vector: STV VT[ELEMENT],$OFFSET(BASE)
  stv v0[e8],$40(r0)  // 128-Bit DMEM $010(R0) = V0..V7, Store Transpose From Vector: STV VT[ELEMENT],$OFFSET(BASE)
  stv v0[e10],$50(r0) // 128-Bit DMEM $010(R0) = V0..V7, Store Transpose From Vector: STV VT[ELEMENT],$OFFSET(BASE)
  stv v0[e12],$60(r0) // 128-Bit DMEM $010(R0) = V0..V7, Store Transpose From Vector: STV VT[ELEMENT],$OFFSET(BASE)
  stv v0[e14],$70(r0) // 128-Bit DMEM $010(R0) = V0..V7, Store Transpose From Vector: STV VT[ELEMENT],$OFFSET(BASE)
  break // Set SP Status Halt, Broke & Check For Interrupt
align(8) // Align 64-Bit
base RSPSTVCode+pc() // Set End Of RSP Code Object
RSPSTVCodeEnd:

insert FontBlack, "FontBlack8x8.bin"
insert FontGreen, "FontGreen8x8.bin"
insert FontRed, "FontRed8x8.bin"