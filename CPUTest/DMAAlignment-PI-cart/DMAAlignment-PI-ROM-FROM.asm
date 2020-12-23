// Tests behavior of PI DMA: Unaligned vs unaligned, going from ROM to RDRAM
// Also tests what the PI registers return when being read
// Author: Lemmy with original sources from Peter Lemon's test sources
output "DMAAlignment-PI-ROM-FROM.N64", create
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
{#}loop:
    sw r0, 0(a0)
    addiu a0, a0, 4
    blt a0, a1, {#}loop
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

macro PrintData(label, label_length, top, expectedHash) {
    constant {#}byteCount(28)
    PrintString($A0100000, 8, {top}, FontBlack, {label}, {label_length})
    PrintValue($A0100000, 104, {top}, FontBlack, (0xA0000000 | data), {#}byteCount)

    // Calculate simple hash so that we can say OK/FAIL
    la r1, (0xA0000000 | data)
    la r2, {#}byteCount
    lui r4, 0
{#}hashLoop:
    lbu r3, 0 (r1)
    andi r5, r2, 15
    sllv r3, r3, r5
    xor r4, r4, r3
    addi r2, r2, -1
    addi r1, r1, 1
    bnez r2, {#}hashLoop
    nop

    la r3, {expectedHash}
    beq r4, r3, {#}Equal

    nop
    la r2, RDWORD
    sw r4, 0(r2)
    PrintValue($A0100000, (SCREEN_X - 80), ({top}), FontRed, RDWORD, 3)
    b {#}Done
    nop
{#}Equal:
    PrintString($A0100000, (SCREEN_X - 64), ({top}), FontGreen, PASS, 3)

{#}Done:

}

constant CAUSE(13)

macro DisplayValue(left, top, address) {
    la r1, {address}
    lw r1, 0x0(r1)
    la r2, RDWORD
    sw r1, 0(r2)
    PrintValue($A0100000, ({left}), ({top}), FontBlack, RDWORD, 3)
}

macro DisplayValue16(left, top, address) {
    la r1, {address}
    lhu r1, 0x0(r1)
    la r2, RDWORD
    sh r1, 0(r2)
    PrintValue($A0100000, ({left}), ({top}), FontBlack, RDWORD, 1)
}

macro DisplayValue8(left, top, address) {
    la r1, {address}
    lbu r1, 0x0(r1)
    la r2, RDWORD
    sb r1, 0(r2)
    PrintValue($A0100000, ({left}), ({top}), FontBlack, RDWORD, 0)
}

macro DisplayBusyReg(left, top) {
    DisplayValue({left}, {top}, 0xA4600010)
}

macro DisplayPI_RDRAM(left, top) {
    DisplayValue({left}, {top}, 0xA4600000)
}

macro DisplayPI_CART(left, top) {
    DisplayValue({left}, {top}, 0xA4600004)
}

macro DisplayPI_ReadLength(left, top) {
    DisplayValue({left}, {top}, 0xA4600008)
}

macro DisplayPI_WriteLength(left, top) {
    DisplayValue({left}, {top}, 0xA460000C)
}

macro WaitForDMANotBusy() {
{#}repeat:
    la r1, 0xA4600000
    lw r1, 0x10(r1)
    andi r1, r1, 1
    bnez r1, {#}repeat
    nop
}


macro WritePI_RDRAM(value) {
    la r1, 0xA4600000
    la r2, {value}
    sw r2, 0(r1)
    nop
    nop
    nop
    nop
}

macro WritePI_CART(value) {
    la r1, 0xA4600000
    la r2, {value}
    sw r2, 4(r1)
    nop
    nop
    nop
    nop
}

macro WritePI_ReadLength(value) {
    la r2, {value}
    la r1, 0xA4600000
    sw r2, 8(r1)
    nop
    nop
    nop
    nop
}

macro WritePI_WriteLength(value) {
    la r2, {value}
    la r1, 0xA4600000
    sw r2, 0xc(r1)
    nop
    nop
    nop
    nop
}

macro DMATo(source, target, length) {
    WritePI_RDRAM({source})
    WritePI_CART({target})
    WritePI_ReadLength({length})
    nop
    WaitForDMANotBusy()
    nop
}

macro ZeroMemory() {
    clear(0xa0000000 | data, 0xa0000000 | data + 512)
}

macro DMAFrom(target, source, length) {
    WritePI_RDRAM({target})
    WritePI_CART({source})
    WritePI_WriteLength({length})
    nop
    WaitForDMANotBusy()
    nop
}

macro PrintPassIf2ValuesMatch(left, top, source1, expected1, source2, expected2) {
    lui r1, 0   // this becomes 1 if any value differs

    la r2, {source1}
    lw r2, 0(r2)
    la r3, {expected1}
    beq r2, r3, {#}Equal1
    nop
    ori r1, r1, 1
{#}Equal1:

    la r2, {source2}
    lw r2, 0(r2)
    la r3, {expected2}
    beq r2, r3, {#}Equal2
    nop
    ori r1, r1, 1
{#}Equal2:

    beqz r1, {#}Equal

    nop
    la r2, RDWORD
    PrintString($A0100000, ({left}), ({top}), FontRed, FAIL, 3)
    b {#}Done
    nop
{#}Equal:
    PrintString($A0100000, ({left}), ({top}), FontGreen, PASS, 3)

{#}Done:
}

macro PrintPassIf3ValuesMatch(left, top, source1, expected1, source2, expected2, source3, expected3) {
    lui r1, 0   // this becomes 1 if any value differs

    la r2, {source1}
    lw r2, 0(r2)
    la r3, {expected1}
    beq r2, r3, {#}Equal1
    nop
    ori r1, r1, 1
{#}Equal1:

    la r2, {source2}
    lw r2, 0(r2)
    la r3, {expected2}
    beq r2, r3, {#}Equal2
    nop
    ori r1, r1, 1
{#}Equal2:

    la r2, {source3}
    lw r2, 0(r2)
    la r3, {expected3}
    beq r2, r3, {#}Equal3
    nop
    ori r1, r1, 1
{#}Equal3:

    beqz r1, {#}Equal

    nop
    la r2, RDWORD
    PrintString($A0100000, ({left}), ({top}), FontRed, FAIL, 3)
    b {#}Done
    nop
{#}Equal:
    PrintString($A0100000, ({left}), ({top}), FontGreen, PASS, 3)

{#}Done:
}

macro PrintPassIf4ValuesMatch(left, top, source1, expected1, source2, expected2, source3, expected3, source4, expected4) {
    lui r1, 0   // this becomes 1 if any value differs

    la r2, {source1}
    lw r2, 0(r2)
    la r3, {expected1}
    beq r2, r3, {#}Equal1
    nop
    ori r1, r1, 1
{#}Equal1:

    la r2, {source2}
    lw r2, 0(r2)
    la r3, {expected2}
    beq r2, r3, {#}Equal2
    nop
    ori r1, r1, 1
{#}Equal2:

    la r2, {source3}
    lw r2, 0(r2)
    la r3, {expected3}
    beq r2, r3, {#}Equal3
    nop
    ori r1, r1, 1
{#}Equal3:

    la r2, {source4}
    lw r2, 0(r2)
    la r3, {expected4}
    beq r2, r3, {#}Equal4
    nop
    ori r1, r1, 1
{#}Equal4:

    beqz r1, {#}Equal

    nop
    la r2, RDWORD
    PrintString($A0100000, ({left}), ({top}), FontRed, FAIL, 3)
    b {#}Done
    nop
{#}Equal:
    PrintString($A0100000, ({left}), ({top}), FontGreen, PASS, 3)

{#}Done:
}

macro PrintPassIf6HalfWordsMatch(left, top, source1, expected1, source2, expected2, source3, expected3, source4, expected4, source5, expected5, source6, expected6) {
    lui r1, 0   // this becomes 1 if any value differs

    la r2, {source1}
    lhu r2, 0(r2)
    la r3, {expected1}
    beq r2, r3, {#}Equal1
    nop
    ori r1, r1, 1
{#}Equal1:

    la r2, {source2}
    lhu r2, 0(r2)
    la r3, {expected2}
    beq r2, r3, {#}Equal2
    nop
    ori r1, r1, 1
{#}Equal2:

    la r2, {source3}
    lhu r2, 0(r2)
    la r3, {expected3}
    beq r2, r3, {#}Equal3
    nop
    ori r1, r1, 1
{#}Equal3:

    la r2, {source4}
    lhu r2, 0(r2)
    la r3, {expected4}
    beq r2, r3, {#}Equal4
    nop
    ori r1, r1, 1
{#}Equal4:

    la r2, {source5}
    lhu r2, 0(r2)
    la r3, {expected5}
    beq r2, r3, {#}Equal5
    nop
    ori r1, r1, 1
{#}Equal5:

    la r2, {source6}
    lhu r2, 0(r2)
    la r3, {expected6}
    beq r2, r3, {#}Equal6
    nop
    ori r1, r1, 1
{#}Equal6:

    beqz r1, {#}Equal

    nop
    la r2, RDWORD
    PrintString($A0100000, ({left}), ({top}), FontRed, FAIL, 3)
    b {#}Done
    nop
{#}Equal:
    PrintString($A0100000, ({left}), ({top}), FontGreen, PASS, 3)

{#}Done:
}
macro PrintPassIf6BytesMatch(left, top, source1, expected1, source2, expected2, source3, expected3, source4, expected4, source5, expected5, source6, expected6) {
    lui r1, 0   // this becomes 1 if any value differs

    la r2, {source1}
    lbu r2, 0(r2)
    la r3, {expected1}
    beq r2, r3, {#}Equal1
    nop
    ori r1, r1, 1
{#}Equal1:

    la r2, {source2}
    lbu r2, 0(r2)
    la r3, {expected2}
    beq r2, r3, {#}Equal2
    nop
    ori r1, r1, 1
{#}Equal2:

    la r2, {source3}
    lbu r2, 0(r2)
    la r3, {expected3}
    beq r2, r3, {#}Equal3
    nop
    ori r1, r1, 1
{#}Equal3:

    la r2, {source4}
    lbu r2, 0(r2)
    la r3, {expected4}
    beq r2, r3, {#}Equal4
    nop
    ori r1, r1, 1
{#}Equal4:

    la r2, {source5}
    lbu r2, 0(r2)
    la r3, {expected5}
    beq r2, r3, {#}Equal5
    nop
    ori r1, r1, 1
{#}Equal5:

    la r2, {source6}
    lbu r2, 0(r2)
    la r3, {expected6}
    beq r2, r3, {#}Equal6
    nop
    ori r1, r1, 1
{#}Equal6:

    beqz r1, {#}Equal

    nop
    la r2, RDWORD
    PrintString($A0100000, ({left}), ({top}), FontRed, FAIL, 3)
    b {#}Done
    nop
{#}Equal:
    PrintString($A0100000, ({left}), ({top}), FontGreen, PASS, 3)

{#}Done:
}

Start:
  include "LIB/N64_GFX.INC" // Include Graphics Macros
  N64_INIT() // Run N64 Initialisation Routine

  ScreenNTSC(SCREEN_X, SCREEN_Y, BPP32|AA_MODE_2, $A0100000)

  WaitScanline($200) // Wait For Scanline To Reach Vertical Blank

  clear($A0100000, $A0100000 + SCREEN_X*BYTES_PER_PIXEL*SCREEN_Y)

  // If only RDRAM/SPMEM is written to, the values aren't visible when read
  DisplayPI_RDRAM(10, 10 * 1)
  DisplayPI_CART(80, 10 * 1)
  DisplayPI_ReadLength(150, 10 * 1)
  DisplayPI_WriteLength(220, 10 * 1)
  PrintPassIf4ValuesMatch((SCREEN_X - 104), 10 * 1, 0xA4600000, 0x00101000, 0xA4600004, 0x1000000C, 0xA4600008, 0x7f, 0xA460000C, 0x7f)

  WritePI_RDRAM(0xffffffff)
  WritePI_CART(0xffffffff)

  DisplayPI_RDRAM(300, 10 * 1)
  DisplayPI_CART(370, 10 * 1)
  DisplayPI_WriteLength(440, 10 * 1)
  PrintPassIf3ValuesMatch((SCREEN_X - 64), 10 * 1, 0xA4600000, 0x00FFFFFE, 0xA4600004, 0xFFFFFFFE, 0xA460000C, 0x7f)

  // ROM (source) address alignment. We'll start at 0x100 as it seems that some development hardware messes with headers
  ZeroMemory()
  DMAFrom(data, 0x10000100, 15)
  PrintData(From0To0For15Bytes_9, 8, 10 * 2, 0x39cf16)
  nop

  ZeroMemory()
  DMAFrom(data, 0x10000110, 15)
  PrintData(From16To0For15Bytes_9, 8, 10 * 3, 0x29edb0)

  ZeroMemory()
  DMAFrom(data, 0x10000108, 15)
  PrintData(From8To0For15Bytes_9, 8, 10 * 4, 0x3bc436)

  ZeroMemory()
  DMAFrom(data, 0x10000104, 15)
  PrintData(From4To0For15Bytes_9, 8, 10 * 5, 0x355274)

  ZeroMemory()
  DMAFrom(data, 0x10000102, 15)
  PrintData(From2To0For15Bytes_9, 8, 10 * 6, 0x785ce5)

  ZeroMemory()
  DMAFrom(data, 0x10000101, 15)
  PrintData(From1To0For15Bytes_9, 8, 10 * 7, 0x0039CF16)

  // Write to WriteLength twice, without changing addresses
  ZeroMemory()
  DMAFrom(data, 0x10000100, 7)
  DisplayPI_RDRAM(10, 10 * 9)
  DisplayPI_CART(80, 10 * 9)
  DisplayPI_ReadLength(150, 10 * 9)
  DisplayPI_WriteLength(220, 10 * 9)
  PrintPassIf4ValuesMatch((SCREEN_X - 104), 10 * 9, 0xA4600000, 0x24408, 0xA4600004, 0x10000108, 0xA4600008, 0x7f, 0xA460000C, 0x7f)
  WritePI_WriteLength(7)
  PrintData(DoubleWrite_7, 8, 10 * 8, 0x0039CF16)
  DisplayPI_RDRAM(300, 10 * 9)
  DisplayPI_CART(370, 10 * 9)
  DisplayPI_WriteLength(440, 10 * 9)
  PrintPassIf3ValuesMatch((SCREEN_X - 64), 10 * 9, 0xA4600000, 0x24410, 0xA4600004, 0x10000110, 0xA460000C, 0x7f)

  // RDRAM (target) address
  ZeroMemory()
  DMAFrom(data + 10, 0x10001000, 15)
  PrintData(From0To10For15Bytes_10, 9, 10 * 10, 0x6f96c7)

  ZeroMemory()
  DMAFrom(data + 8, 0x10001000, 15)
  PrintData(From0To8For15Bytes_9, 8, 10 * 11, 0xa7ba8)

  ZeroMemory()
  DMAFrom(data + 6, 0x10001000, 15)
  PrintData(From0To6For15Bytes_9, 8, 10 * 12, 0x3e02b0)

  ZeroMemory()
  DMAFrom(data + 4, 0x10001000, 15)
  PrintData(From0To4For15Bytes_9, 8, 10 * 13, 0x5a4a7c)

  ZeroMemory()
  DMAFrom(data + 2, 0x10001000, 15)
  PrintData(From0To2For15Bytes_9, 8, 10 * 14, 0x71a8e7)

  ZeroMemory()
  DMAFrom(data + 1, 0x10001000, 15)
  PrintData(From0To1For15Bytes_9, 8, 10 * 15, 0x23a258)

  // Very small lengths
  ZeroMemory()
  DMAFrom(data, 0x10001000, 1)
  PrintData(From0To0For1Bytes_8, 7, 10 * 16, 0x3e000)

  ZeroMemory()
  DMAFrom(data, 0x10001000, 0)
  PrintData(From0To0For0Bytes_8, 7, 10 * 17, 0x3c000)

  DisplayPI_RDRAM(10, 10 * 19)
  DisplayPI_CART(80, 10 * 19)
  DisplayPI_ReadLength(150, 10 * 19)
  DisplayPI_WriteLength(220, 10 * 19)
  PrintPassIf4ValuesMatch((SCREEN_X - 104), 10 * 19, 0xA4600000, 0x24408, 0xA4600004, 0x10001002, 0xA4600008, 0x7f, 0xA460000C, 0x7f)

  WritePI_WriteLength(2)
  PrintData(Again_10, 9, 10 * 18, 0x3cd20)
  DisplayPI_RDRAM(300, 10 * 19)
  DisplayPI_CART(370, 10 * 19)
  DisplayPI_WriteLength(440, 10 * 19)
  PrintPassIf3ValuesMatch((SCREEN_X - 64), 10 * 19, 0xA4600000, 0x24410, 0xA4600004, 0x10001006, 0xA460000C, 0x7f)

  // We have some more space. Let's try to read rom with the CPU
  // Why no LD test here? Crashes the N64

  DisplayValue(10, 10 * 20, 0xB0000000)
  DisplayValue(80, 10 * 20, 0xB0000004)
  DisplayValue(150, 10 * 20, 0xB0000008)
  DisplayValue(220, 10 * 20, 0xB000000C)
  PrintPassIf4ValuesMatch((SCREEN_X - 64), 10 * 20, 0xB0000000, 0x80371240, 0xB0000004, 0xf, 0xB0000008, 0x80001000, 0xB000000C, 0x1444)

  DisplayValue16(10, 10 * 21, 0xB0000000)
  DisplayValue16(50, 10 * 21, 0xB0000002)
  DisplayValue16(90, 10 * 21, 0xB0000004)
  DisplayValue16(130, 10 * 21, 0xB0000006)
  DisplayValue16(170, 10 * 21, 0xB0000008)
  DisplayValue16(210, 10 * 21, 0xB000000A)
  PrintPassIf6HalfWordsMatch((SCREEN_X - 104), 10 * 21, 0xB0000000, 0x8037, 0xB0000002, 0x000, 0xB0000004, 0x0000, 0xB0000006, 0x8000, 0xB0000008, 0x8000, 0xB000000A, 0x0000)

  DisplayValue8(270, 10 * 21, 0xB0000000)
  DisplayValue8(290, 10 * 21, 0xB0000001)
  DisplayValue8(310, 10 * 21, 0xB0000002)
  DisplayValue8(330, 10 * 21, 0xB0000003)
  DisplayValue8(350, 10 * 21, 0xB0000004)
  DisplayValue8(370, 10 * 21, 0xB0000005)
  PrintPassIf6BytesMatch((SCREEN_X - 64), 10 * 21, 0xB0000000, 0x80, 0xB0000001, 0x37, 0xB0000002, 0x00, 0xB0000003, 0x00, 0xB0000004, 0x00, 0xB0000005, 0x00)

  // Test flags during DMA. Clear all interrupts first: VI, SI, PI
  la r1, 0xFFFFFFFF
  la r2, 0xA4800018
  sw r1, 0(r2)  // Clear SI Interrupt

  la r2, 0xA4400010
  lw r1, 0(r2)
  sw r1, 0(r2)  // Clear VI Interrupt

  la r1, 2
  la r2, 0xA4600010
  sw r1, 0(r2)  // Clear PI

  DisplayValue(10, 10*22, 0xA4300008)   // MI Interrupt
  DisplayValue(80, 10*22, 0xA4600010)   // PI Status
  PrintPassIf2ValuesMatch((SCREEN_X - 144), 10 * 22, 0xA4300008, 0x0, 0xA4600010, 0x0)

  DMAFrom(data, 0x10000100, 15)

  // Write to status, but without the lowest two bits set
  la r1, 0xFFFFFFFC
  la r2, 0xA4600010
  sw r1, 0(r2)  // clear pi
  nop
  nop

  DisplayValue(160, 10*22, 0xA4300008)   // MI Interrupt
  DisplayValue(230, 10*22, 0xA4600010)   // PI Status
  PrintPassIf2ValuesMatch((SCREEN_X - 104), 10 * 22, 0xA4300008, 0x10, 0xA4600010, 0x8)

  // Clear Interrupt
  la r1, 2
  la r2, 0xA4600010
  sw r1, 0(r2)  // clear pi
  nop
  nop

  DisplayValue(310, 10*22, 0xA4300008)  // MI Interrupt
  DisplayValue(380, 10*22, 0xA4600010)  // PI Status
  PrintPassIf2ValuesMatch((SCREEN_X - 64), 10 * 22, 0xA4300008, 0x0, 0xA4600010, 0x0)


  // more things to test:
  //  - higher bits of SPMEM-address - is the 04000000 completely optional?

Loop:
  j Loop
  nop // Delay Slot


// Use a big alignment. This makes it less likely that offsets will change when program code is changed above
align(16384)

PASS:
  db "PASS"
FAIL:
  db "FAIL"
From0To0For15Bytes_9:
  db "0->0 15b:"
From16To0For15Bytes_9:
  db "16->0 15b:"
From8To0For15Bytes_9:
  db "8->0 15b:"
From4To0For15Bytes_9:
  db "4->0 15b:"
From2To0For15Bytes_9:
  db "2->0 15b:"
From1To0For15Bytes_9:
  db "1->0 15b:"
DoubleWrite_7:
  db "double:"
From0To10For15Bytes_10:
  db "0->10 15b:"
From0To8For15Bytes_9:
  db "0->8 15b:"
From0To6For15Bytes_9:
  db "0->6 15b:"
From0To4For15Bytes_9:
  db "0->4 15b:"
From0To2For15Bytes_9:
  db "0->2 15b:"
From0To1For15Bytes_9:
  db "0->1 15b:"
From0To0For1Bytes_8:
  db "0->0 1b:"
From0To0For0Bytes_8:
  db "0->0 0b:"
Again_10:
  db "again (2b):"
Count1_6:
  db "cnt=1:"
Count2Skip2_12:
  db "cnt=2 skp=2:"
Count2Skip4_12:
  db "cnt=2 skp=4:"
Count2Skip8_12:
  db "cnt=2 skp=8:"
Count2Skip16_13:
  db "cnt=2 skp=16:"

align(16)
TESTDATA:
  dw $01234567
  dw $89ABCDEF
  dw $FFEEDDCC
  dw $BBAA9988
  dw $77665544
  dw $33221100
  dw $00112233
  dw $44556677
  dw $8899AABB
  dw $CCDDEEFF

align(8)
RDWORD:
  dw 0
insert FontBlack, "FontBlack8x8.bin"
insert FontGreen, "FontGreen8x8.bin"
insert FontRed, "FontRed8x8.bin"


align(1024)
data:
  dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
