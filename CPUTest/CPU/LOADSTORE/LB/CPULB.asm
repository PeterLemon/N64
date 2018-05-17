// N64 'Bare Metal' CPU Load Byte Test Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "CPULB.N64", create
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
  N64_INIT() // Run N64 Initialisation Routine

  ScreenNTSC(640, 480, BPP32|INTERLACE|AA_MODE_2, $A0100000) // Screen NTSC: 640x480, 32BPP, Interlace, Resample Only, DRAM Origin = $A0100000

  lui a0,$A010 // A0 = VRAM Start Offset
  la a1,$A0100000+((SCREEN_X*SCREEN_Y*BYTES_PER_PIXEL)-BYTES_PER_PIXEL) // A1 = VRAM End Offset
  lli t0,$000000FF // T0 = Black
ClearScreen:
  sw t0,0(a0)
  bne a0,a1,ClearScreen
  addi a0,4 // Delay Slot


  PrintString($A0100000,88,8,FontRed,BYTEHEX,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,8,FontRed,BYTEDEC,13) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,384,8,FontRed,RTHEX,7) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,528,8,FontRed,TEST,10) // Print Text String To VRAM Using Font At X,Y Position


  PrintString($A0100000,0,16,FontBlack,PAGEBREAK,79) // Print Text String To VRAM Using Font At X,Y Position


  PrintString($A0100000,8,24,FontRed,LB,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,VALUEBYTEA // A0 = Byte Data Offset
  lb t0,0(a0) // T0 = Test Byte Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,144,24,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,24,FontBlack,VALUEBYTEA,0) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,24,FontBlack,TEXTBYTEA,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,24,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,24,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG   // A0 = Long Data Offset
  ld t0,0(a0)    // T0 = Long Data
  la a0,LBCHECKA // A0 = Long Check Data Offset
  ld t1,0(a0)    // T1 = Long Check Data
  beq t0,t1,LBPASSA // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,24,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LBENDA
  nop // Delay Slot
  LBPASSA:
  PrintString($A0100000,528,24,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LBENDA:

  la a0,VALUEBYTEB // A0 = Byte Data Offset
  lb t0,0(a0) // T0 = Test Byte Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,144,32,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,32,FontBlack,VALUEBYTEB,0) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,32,FontBlack,TEXTBYTEB,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,32,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,32,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG   // A0 = Long Data Offset
  ld t0,0(a0)    // T0 = Long Data
  la a0,LBCHECKB // A0 = Long Check Data Offset
  ld t1,0(a0)    // T1 = Long Check Data
  beq t0,t1,LBPASSB // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,32,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LBENDB
  nop // Delay Slot
  LBPASSB:
  PrintString($A0100000,528,32,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LBENDB:

  la a0,VALUEBYTEC // A0 = Byte Data Offset
  lb t0,0(a0) // T0 = Test Byte Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,144,40,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,40,FontBlack,VALUEBYTEC,0) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,40,FontBlack,TEXTBYTEC,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,40,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,40,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG   // A0 = Long Data Offset
  ld t0,0(a0)    // T0 = Long Data
  la a0,LBCHECKC // A0 = Long Check Data Offset
  ld t1,0(a0)    // T1 = Long Check Data
  beq t0,t1,LBPASSC // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,40,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LBENDC
  nop // Delay Slot
  LBPASSC:
  PrintString($A0100000,528,40,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LBENDC:

  la a0,VALUEBYTED // A0 = Byte Data Offset
  lb t0,0(a0) // T0 = Test Byte Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,144,48,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,48,FontBlack,VALUEBYTED,0) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,344,48,FontBlack,TEXTBYTED,2) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,48,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,48,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG   // A0 = Long Data Offset
  ld t0,0(a0)    // T0 = Long Data
  la a0,LBCHECKD // A0 = Long Check Data Offset
  ld t1,0(a0)    // T1 = Long Check Data
  beq t0,t1,LBPASSD // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,48,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LBENDD
  nop // Delay Slot
  LBPASSD:
  PrintString($A0100000,528,48,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LBENDD:

  la a0,VALUEBYTEE // A0 = Byte Data Offset
  lb t0,0(a0) // T0 = Test Byte Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,144,56,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,56,FontBlack,VALUEBYTEE,0) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,56,FontBlack,TEXTBYTEE,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,56,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,56,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG   // A0 = Long Data Offset
  ld t0,0(a0)    // T0 = Long Data
  la a0,LBCHECKE // A0 = Long Check Data Offset
  ld t1,0(a0)    // T1 = Long Check Data
  beq t0,t1,LBPASSE // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,56,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LBENDE
  nop // Delay Slot
  LBPASSE:
  PrintString($A0100000,528,56,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LBENDE:

  la a0,VALUEBYTEF // A0 = Byte Data Offset
  lb t0,0(a0) // T0 = Test Byte Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,144,64,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,64,FontBlack,VALUEBYTEF,0) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,344,64,FontBlack,TEXTBYTEF,2) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,64,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,64,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG   // A0 = Long Data Offset
  ld t0,0(a0)    // T0 = Long Data
  la a0,LBCHECKF // A0 = Long Check Data Offset
  ld t1,0(a0)    // T1 = Long Check Data
  beq t0,t1,LBPASSF // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,64,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LBENDF
  nop // Delay Slot
  LBPASSF:
  PrintString($A0100000,528,64,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LBENDF:

  la a0,VALUEBYTEG // A0 = Byte Data Offset
  lb t0,0(a0) // T0 = Test Byte Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,144,72,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,72,FontBlack,VALUEBYTEG,0) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,336,72,FontBlack,TEXTBYTEG,3) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,72,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,72,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG   // A0 = Long Data Offset
  ld t0,0(a0)    // T0 = Long Data
  la a0,LBCHECKG // A0 = Long Check Data Offset
  ld t1,0(a0)    // T1 = Long Check Data
  beq t0,t1,LBPASSG // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,72,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LBENDG
  nop // Delay Slot
  LBPASSG:
  PrintString($A0100000,528,72,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LBENDG:


  PrintString($A0100000,8,88,FontRed,LBU,2) // Print Text String To VRAM Using Font At X,Y Position
  la a0,VALUEBYTEA // A0 = Byte Data Offset
  lbu t0,0(a0) // T0 = Test Byte Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,144,88,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,88,FontBlack,VALUEBYTEA,0) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,88,FontBlack,TEXTBYTEA,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,88,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,88,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG    // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,LBUCHECKA // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,LBUPASSA // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,88,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LBUENDA
  nop // Delay Slot
  LBUPASSA:
  PrintString($A0100000,528,88,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LBUENDA:

  la a0,VALUEBYTEB // A0 = Byte Data Offset
  lbu t0,0(a0) // T0 = Test Byte Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,144,96,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,96,FontBlack,VALUEBYTEB,0) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,96,FontBlack,TEXTBYTEB,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,96,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,96,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG    // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,LBUCHECKB // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,LBUPASSB // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,96,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LBUENDB
  nop // Delay Slot
  LBUPASSB:
  PrintString($A0100000,528,96,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LBUENDB:

  la a0,VALUEBYTEC // A0 = Byte Data Offset
  lbu t0,0(a0) // T0 = Test Byte Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,144,104,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,104,FontBlack,VALUEBYTEC,0) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,104,FontBlack,TEXTBYTEC,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,104,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,104,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG    // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,LBUCHECKC // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,LBUPASSC // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,104,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LBUENDC
  nop // Delay Slot
  LBUPASSC:
  PrintString($A0100000,528,104,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LBUENDC:

  la a0,VALUEBYTED // A0 = Byte Data Offset
  lbu t0,0(a0) // T0 = Test Byte Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,144,112,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,112,FontBlack,VALUEBYTED,0) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,344,112,FontBlack,TEXTBYTED,2) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,112,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,112,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG    // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,LBUCHECKD // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,LBUPASSD // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,112,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LBUENDD
  nop // Delay Slot
  LBUPASSD:
  PrintString($A0100000,528,112,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LBUENDD:

  la a0,VALUEBYTEE // A0 = Byte Data Offset
  lbu t0,0(a0) // T0 = Test Byte Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,144,120,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,120,FontBlack,VALUEBYTEE,0) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,120,FontBlack,TEXTBYTEE,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,120,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,120,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG    // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,LBUCHECKE // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,LBUPASSE // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,120,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LBUENDE
  nop // Delay Slot
  LBUPASSE:
  PrintString($A0100000,528,120,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LBUENDE:

  la a0,VALUEBYTEF // A0 = Byte Data Offset
  lbu t0,0(a0) // T0 = Test Byte Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,144,128,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,128,FontBlack,VALUEBYTEF,0) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,344,128,FontBlack,TEXTBYTEF,2) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,128,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,128,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG    // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,LBUCHECKF // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,LBUPASSF // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,128,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LBUENDF
  nop // Delay Slot
  LBUPASSF:
  PrintString($A0100000,528,128,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LBUENDF:

  la a0,VALUEBYTEG // A0 = Byte Data Offset
  lbu t0,0(a0) // T0 = Test Byte Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,144,136,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,136,FontBlack,VALUEBYTEG,0) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,336,136,FontBlack,TEXTBYTEG,3) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,136,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,136,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG    // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,LBUCHECKG // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,LBUPASSG // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,136,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LBUENDG
  nop // Delay Slot
  LBUPASSG:
  PrintString($A0100000,528,136,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LBUENDG:


  PrintString($A0100000,0,144,FontBlack,PAGEBREAK,79) // Print Text String To VRAM Using Font At X,Y Position


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

LB:
  db "LB"
LBU:
  db "LBU"

RTHEX:
  db "RT (Hex)"
BYTEHEX:
  db "BYTE (Hex)"
BYTEDEC:
  db "BYTE (Decimal)"
TEST:
  db "Test Result"
FAIL:
  db "FAIL"
PASS:
  db "PASS"

DOLLAR:
  db "$"

TEXTBYTEA:
  db "0"
TEXTBYTEB:
  db "1"
TEXTBYTEC:
  db "12"
TEXTBYTED:
  db "123"
TEXTBYTEE:
  db "-1"
TEXTBYTEF:
  db "-12"
TEXTBYTEG:
  db "-123"

PAGEBREAK:
  db "--------------------------------------------------------------------------------"

VALUEBYTEA:
  db 0
VALUEBYTEB:
  db 1
VALUEBYTEC:
  db 12
VALUEBYTED:
  db 123
VALUEBYTEE:
  db -1
VALUEBYTEF:
  db -12
VALUEBYTEG:
  db -123

align(8) // Align 64-Bit
LBCHECKA:
  dd $0000000000000000
LBCHECKB:
  dd $0000000000000001
LBCHECKC:
  dd $000000000000000C
LBCHECKD:
  dd $000000000000007B
LBCHECKE:
  dd $FFFFFFFFFFFFFFFF
LBCHECKF:
  dd $FFFFFFFFFFFFFFF4
LBCHECKG:
  dd $FFFFFFFFFFFFFF85

LBUCHECKA:
  dd $0000000000000000
LBUCHECKB:
  dd $0000000000000001
LBUCHECKC:
  dd $000000000000000C
LBUCHECKD:
  dd $000000000000007B
LBUCHECKE:
  dd $00000000000000FF
LBUCHECKF:
  dd $00000000000000F4
LBUCHECKG:
  dd $0000000000000085

RTLONG:
  dd 0

insert FontBlack, "FontBlack8x8.bin"
insert FontGreen, "FontGreen8x8.bin"
insert FontRed, "FontRed8x8.bin"