// Continuously reads all COP0 registers and displays them on screen
// Author: Lemmy with original sources from Peter Lemon's test sources
output "COP0Register.N64", create
arch n64.cpu
endian msb
fill 1052672 // Set ROM Size

constant SCREEN_X(320)
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

macro DisplayCOP0RegisterValue(left, top, index) {
    mfc0 r1, {index}
    la r2, RDWORD
    sw r1, 0(r2)
    PrintValue($A0100000, ({left}), ({top}), FontBlack, RDWORD, 3)
    la r2, expected
    addiu r2, {index} * 8 + 4
    lw r3, 0(r2)
    beqz r3, {#}Done

    la r2, RDWORD
    lw r1, 0(r2)
    la r2, expected
    addiu r2, {index} * 8
    lw r2, 0(r2)
    and r1, r1, r3
    beq r1, r2, {#}Equal
    nop
    PrintString($A0100000, ({left} + 72), ({top}), FontRed, FAIL, 4)
    b {#}Done
    nop
    {#}Equal:
    PrintString($A0100000, ({left} + 72), ({top}), FontGreen, PASS, 4)

    {#}Done:
}


Start:
  include "LIB/N64_GFX.INC" // Include Graphics Macros
  N64_INIT() // Run N64 Initialisation Routine

  ScreenNTSC(SCREEN_X, SCREEN_Y, BPP32|AA_MODE_2, $A0100000)

  WaitScanline($200) // Wait For Scanline To Reach Vertical Blank

  clear($A0100000, $A0100000 + SCREEN_X*BYTES_PER_PIXEL*SCREEN_Y)

Loop:
  variable registerIndex(0)
  while (registerIndex < 16) {
    DisplayCOP0RegisterValue(16, 16 + 8 * registerIndex, registerIndex)
    DisplayCOP0RegisterValue(180, 16 + 8 * registerIndex, (registerIndex + 16))
    variable registerIndex(registerIndex + 1)
  }

  j Loop
  nop // Delay Slot



align(8)
PASS:
  db "PASS"

align(8)
FAIL:
  db "FAIL"

align(8)
expected:
// First value is the expected value. Second value is the mask. If it is 0, no test is performed
// Two reasons for why a mask bit would be 0:
//  - Either the result seems random
//  - Result is different after cold boot vs launch after a reset of a game
  dw 0x0000007F, 0x00000000 // Index
  dw 0x00000000, 0xFFFFFFE0 // Random
  dw 0x00000000, 0x00000000 // EntryLo0
  dw 0x00000000, 0x00000000 // EntryLo1
  dw 0x007FFFF0, 0x00000000 // Context
  dw 0x00000000, 0x00000FFF // PageMask
  dw 0x00000000, 0x00000000 // Wired
  dw 0x00000000, 0x00000000
  dw 0xFFFFFFFF, 0x00000000 // BadVAddr
  dw 0x00000000, 0x00000000 // Count
  dw 0x00000000, 0x00000000 // EntryHi
  dw 0x00000000, 0xFFFFFFFF // Compare
  dw 0x241000E0, 0xFFFFFFFF // Status
  dw 0x00000000, 0x033F0083 // Cause (most of it is undefined on reset. some bits are 0 however)
  dw 0xFFFFFFFF, 0xFFFFFFFF // ExceptPC
  dw 0x00000B22, 0xFFFFFFFF // PrevID

  dw 0x7006E463, 0xFFFFFFFF // Config
  dw 0xFFFFFFFF, 0x00000000 // LLAddr
  dw 0xFFFFFFFB, 0x00000000 // WatchLo
  dw 0x0000000F, 0x00000000 // WatchHi
  dw 0xFFFFFFF0, 0x00000000 // XContext
  dw 0x00000000, 0x00000000
  dw 0x00000000, 0x00000000
  dw 0x00000000, 0x00000000
  dw 0x00000000, 0x00000000
  dw 0x00000000, 0x00000000
  dw 0x00000000, 0xFFFFFFFF // PErr
  dw 0x00000000, 0xFFFFFFFF // CacheErr
  dw 0x00000000, 0xFFFFFFFF // TagLo
  dw 0x00000000, 0xFFFFFFFF // TagHi
  dw 0xFFFFFFFF, 0xFFFFFFFF // ErrorEPC
  dw 0x008000FF, 0x00000000

align(8)
RDWORD:
  dw 0
insert FontBlack, "FontBlack8x8.bin"
insert FontGreen, "FontGreen8x8.bin"
insert FontRed, "FontRed8x8.bin"
