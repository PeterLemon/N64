// Tests a matrix of values for FPU compare instructions
// Author: Lemmy with original sources from Peter Lemon's test sources
output "FPUCompare-{operation}.N64", create
arch n64.cpu
endian msb
fill 1052672 // Set ROM Size

constant SCREEN_X(640)
constant SCREEN_Y(240)
constant BYTES_PER_PIXEL(4)
// Setup Characters
constant CHAR_X(8)
constant CHAR_Y(8)

origin $00000000
base $80000000 // Entry Point Of Code
include "LIB/N64.INC" // Include N64 Definitions
include "LIB/N64_HEADER.ASM" // Include 64 Byte Header & Vector Table
insert "LIB/N64_BOOTCODE.BIN" // Include 4032 Byte Boot Code

macro clear(start, end) {
    li a0, {start}
    li a1, {end}
loop:
    sw r0, 0(a0)
    addiu a0, a0, 4
    blt a0, a1, loop
    nop
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
  N64_INIT() // Run N64 Initialisation Routine

  ScreenNTSC(SCREEN_X, SCREEN_Y, BPP32|AA_MODE_2, $A0100000)

  WaitScanline($200) // Wait For Scanline To Reach Vertical Blank

  clear($A0100000, $A0100000 + SCREEN_X*BYTES_PER_PIXEL*SCREEN_Y)

  macro DisplayValue(left, top, value) {
    la a0, ({value})
    lw t1, 0(a0)
    la a1, RDWORD
    sw t1, 0(a1)
    PrintValue($A0100000, ({left}), ({top}), FontBlack, RDWORD, 3)
  }

  // As the resolution is 640x480, the font is pretty hard to read. Let's use color to distinguish
  macro DisplayA2WithColor(columnIndex, rowIndex) {
    la a3, RDWORD
    sw a2, 0(a3)
    beq a2, r0, {#}cFalse
    nop
    lui t0, $0080
    beq a2, t0, {#}cTrue
    nop

    PrintValue($A0100000, (88 + 72 * columnIndex), (32 + rowIndex * 16), FontBlack, RDWORD, 3)
    b {#}Done
    nop

    {#}cFalse:
    PrintValue($A0100000, (88 + 72 * columnIndex), (32 + rowIndex * 16), FontRed, RDWORD, 3)
    b {#}Done
    nop

    {#}cTrue:
    PrintValue($A0100000, (88 + 72 * columnIndex), (32 + rowIndex * 16), FontGreen, RDWORD, 3)
    {#}Done:
  }

  // Draw row and column headers
  variable index(0)
  while index <= 6 {
    // Column
    DisplayValue(88 + 72 * index, 16, Values + index * 4)

    // Column
    DisplayValue(16, 32 + index * 16, Values + index * 4)
    
    variable index(index + 1)
  }

  // Disable exceptions. Otherwise those NaNs and infs might crash
  // Fill in values
  variable columnIndex(0)
  while columnIndex <= 6 {
    variable rowIndex(0)
    while rowIndex <= 6 {
      ctc1 r0, 31
      nop

      la a0, Values+(rowIndex*4)
      lwc1 f0, 0(a0)
      la a1, Values+(columnIndex*4)
      lwc1 f1, 0(a1)
      nop
      {operation} f0, f1
      nop
      cfc1 a2, 31
      nop

      DisplayA2WithColor(columnIndex, rowIndex)

      variable rowIndex(rowIndex + 1)
    }

    variable columnIndex(columnIndex + 1)
  }


Loop:
  j Loop
  nop // Delay Slot

Values:
  dw 0xBF800000  // -1.0
  dw 0x80000000  // -0.0
  dw 0x00000000  //  0.0
  dw 0x3F800000  //  1.0
  dw 0xFF800000  // -inf
  dw 0x7F800000  // +inf
  dw 0x7FBFFFFF  //  NaN

RDWORD:
  dw 0
insert FontBlack, "FontBlack8x8.bin"
insert FontGreen, "FontGreen8x8.bin"
insert FontRed, "FontRed8x8.bin"
