// Tests whether FPU register survive a 32/64 bit mode switch. And if so, what are their values?
// Author: Lemmy with original sources from Peter Lemon's test sources
output "COP1FullMode.N64", create
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

  constant FullMode($34000000)
  constant HalfMode($30000000)

  macro TestFullHalf(loadStatus, saveStatus, top) {
    // Initialize 64 bit registers first. This way we can see what isn't overwritten
    la r1, FullMode
    mtc0 r1, 12
    nop
    nop
    la r1, FillValue
    ldc1 f0, 0(r1)
    ldc1 f1, 0(r1)
    ldc1 f2, 0(r1)


    // Set mode for loading registers
    la r1, {loadStatus}
    mtc0 r1, 12

    nop
    nop

    // Load some values as 32 bit
    la r1, Values
    lwc1 f0, 0(r1)
    lwc1 f1, 4(r1)

    // Load 64 bit value
    ldc1 f2, 8(r1)

    nop
    nop

    // Set mode for saving
    la r1, {saveStatus}
    mtc0 r1, 12

    nop
    nop

    // Store as 64 bits
    la r1, RDWORD
    dmfc1 r2, f0
    dsrl32 r2, r2, 0
    sw r2, 0(r1)
    PrintValue($A0100000, (16 + 160 * 0 + 00), ({top}), FontBlack, RDWORD, 3)
    dmfc1 r2, f0
    sw r2, 0(r1)
    PrintValue($A0100000, (16 + 160 * 0 + 68), ({top}), FontBlack, RDWORD, 3)

    dmfc1 r2, f1
    dsrl32 r2, r2, 0
    sw r2, 0(r1)
    PrintValue($A0100000, (16 + 160 * 1 + 00), ({top}), FontBlack, RDWORD, 3)
    dmfc1 r2, f1
    sw r2, 0(r1)
    PrintValue($A0100000, (16 + 160 * 1 + 68), ({top}), FontBlack, RDWORD, 3)

    dmfc1 r2, f2
    dsrl32 r2, r2, 0
    sw r2, 0(r1)
    PrintValue($A0100000, (16 + 160 * 2 + 00), ({top}), FontBlack, RDWORD, 3)
    dmfc1 r2, f2
    sw r2, 0(r1)
    PrintValue($A0100000, (16 + 160 * 2 + 68), ({top}), FontBlack, RDWORD, 3)
  }

  // Read and write in same mode
  TestFullHalf(FullMode, FullMode, 16)
  TestFullHalf(HalfMode, HalfMode, 16 + 16 * 1)

  // Read and write in different modes
  TestFullHalf(HalfMode, FullMode, 16 + 16 * 3)
  TestFullHalf(FullMode, HalfMode, 16 + 16 * 4)

Loop:
  j Loop
  nop // Delay Slot


align(8)
Values:
  dw 0x01230123
  dw 0x45674567
  dd 0x1212343456567878

align(8)
FillValue:
  dd 0xdecafbad0badf00d

align(8)
RDWORD:
  dw 0
insert FontBlack, "FontBlack8x8.bin"
insert FontGreen, "FontGreen8x8.bin"
insert FontRed, "FontRed8x8.bin"
