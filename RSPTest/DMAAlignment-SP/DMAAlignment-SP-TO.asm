// Tests behavior of SP DMA: Unaligned vs unaligned, count and skip. Going from RDRAM to SPMEM
// Also tests what the SP registers return when being read
// Author: Lemmy with original sources from Peter Lemon's test sources
output "DMAAlignment-SP-TO.N64", create
arch n64.cpu
endian msb
fill 1052672 // Set ROM Size

constant SCREEN_X(640)
constant SCREEN_Y(240)
constant BYTES_PER_PIXEL(4)
// Setup Characters
constant CHAR_X(8)
constant CHAR_Y(8)

define header_title_27("DMA alignment (ram -> sp)  ")

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

macro PrintSPMEM(label, label_length, top, expectedHash) {
    constant {#}byteCount(28)
    PrintString($A0100000, 8, {top}, FontBlack, {label}, {label_length})
    PrintValue($A0100000, 104, {top}, FontBlack, $A4000000, {#}byteCount)

    // Calculate simple hash so that we can say OK/FAIL
    la r1, $A4000000
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
    PrintValue($A0100000, (SCREEN_X - 64), ({top}), FontRed, RDWORD, 3)
    b {#}Done
    nop
{#}Equal:
    PrintString($A0100000, (SCREEN_X - 64), ({top}), FontGreen, PASS, 3)

{#}Done:

}

constant CAUSE(13)

macro DisplayBusyReg(left, top) {
    la r1, 0xA4040000
    lw r1, 0x18(r1)
    la r2, RDWORD
    sw r1, 0(r2)
    PrintValue($A0100000, ({left}), ({top}), FontBlack, RDWORD, 3)
}

macro DisplaySP_RDRAM(left, top) {
    la r1, 0xA4040000
    lw r1, 0x4(r1)
    la r2, RDWORD
    sw r1, 0(r2)
    PrintValue($A0100000, ({left}), ({top}), FontBlack, RDWORD, 3)
}

macro DisplaySP_SPMEM(left, top) {
    la r1, 0xA4040000
    lw r1, 0x0(r1)
    la r2, RDWORD
    sw r1, 0(r2)
    PrintValue($A0100000, ({left}), ({top}), FontBlack, RDWORD, 3)
}

macro DisplaySP_ReadLength(left, top) {
    la r1, 0xA4040000
    lw r1, 0x8(r1)
    la r2, RDWORD
    sw r1, 0(r2)
    PrintValue($A0100000, ({left}), ({top}), FontBlack, RDWORD, 3)
}

macro WaitForDMANotBusy() {
{#}repeat:
    la r1, 0xA4040000
    lw r1, 0x18(r1)
    bnez r1, {#}repeat
    nop
}


macro WriteSP_RDRAM(value) {
    la r1, 0xA4040000
    la r2, {value}
    sw r2, 4(r1)
    nop
    nop
    nop
    nop
}

macro WriteSP_SPMEM(value) {
    la r1, 0xA4040000
    la r2, {value}
    sw r2, 0(r1)
    nop
    nop
    nop
    nop
}

macro WriteSP_ReadLength(value) {
    la r2, {value}
    la r1, 0xA4040000
    sw r2, 8(r1)
    nop
    nop
    nop
    nop
}

macro DMATo(source, target, length) {
    WriteSP_RDRAM({source})
    WriteSP_SPMEM({target})
    WriteSP_ReadLength({length})
    nop
    WaitForDMANotBusy()
    nop
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

Start:
  include "LIB/N64_GFX.INC" // Include Graphics Macros
  N64_INIT() // Run N64 Initialisation Routine

  ScreenNTSC(SCREEN_X, SCREEN_Y, BPP32|AA_MODE_2, $A0100000)

  WaitScanline($200) // Wait For Scanline To Reach Vertical Blank

  clear($A0100000, $A0100000 + SCREEN_X*BYTES_PER_PIXEL*SCREEN_Y)

  // Perform a dma to ensure the registers are at a known state (otherwise the first test fails on hardware after a reset)
  DMATo(ZEROES, 0x04000000, 63)

  // If only RDRAM/SPMEM is written to, the values aren't visible when read
  DisplaySP_SPMEM(10, 10 * 1)
  DisplaySP_RDRAM(80, 10 * 1)
  DisplaySP_ReadLength(150, 10 * 1)
  PrintPassIf3ValuesMatch((SCREEN_X - 104), 10 * 1, 0xA4040000, 0x40, 0xA4040004, 0x8130, 0xA4040008, 0xff8)

  WriteSP_RDRAM(TESTDATA)
  WriteSP_SPMEM(0x04000020)

  DisplaySP_SPMEM(230, 10 * 1)
  DisplaySP_RDRAM(300, 10 * 1)
  DisplaySP_ReadLength(370, 10 * 1)
  PrintPassIf3ValuesMatch((SCREEN_X - 64), 10 * 1, 0xA4040000, 0x40, 0xA4040004, 0x8130, 0xA4040008, 0xff8)

  // RDRAM address alignment
  DMATo(ZEROES, 0x04000000, 63)
  DMATo(TESTDATA, 0x04000000, 15)
  PrintSPMEM(From0To0For15Bytes_9, 8, 10 * 2, 0x00626AF7)
  nop

  DMATo(ZEROES, 0x04000000, 63)
  DMATo(TESTDATA + 16, 0x04000000, 15)
  PrintSPMEM(From16To0For15Bytes_9, 8, 10 * 3, 0x385A62)

  DMATo(ZEROES, 0x04000000, 63)
  DMATo(TESTDATA + 8, 0x04000000, 15)
  PrintSPMEM(From8To0For15Bytes_9, 8, 10 * 4, 0x1FF0EF)

  DMATo(ZEROES, 0x04000000, 63)
  DMATo(TESTDATA + 4, 0x04000000, 15)
  PrintSPMEM(From4To0For15Bytes_9, 8, 10 * 5, 0x00626AF7)

  DMATo(ZEROES, 0x04000000, 63)
  DMATo(TESTDATA + 2, 0x04000000, 15)
  PrintSPMEM(From2To0For15Bytes_9, 8, 10 * 6, 0x00626AF7)

  DMATo(ZEROES, 0x04000000, 63)
  DMATo(TESTDATA + 1, 0x04000000, 15)
  PrintSPMEM(From1To0For15Bytes_9, 8, 10 * 7, 0x00626AF7)

  // Write to ReadLength twice, without changing addresses
  DMATo(ZEROES, 0x04000000, 63)
  DMATo(TESTDATA, 0x04000000, 15)
  DisplaySP_SPMEM(10, 10 * 9)
  DisplaySP_RDRAM(80, 10 * 9)
  DisplaySP_ReadLength(150, 10 * 9)
  PrintPassIf3ValuesMatch((SCREEN_X - 104), 10 * 9, 0xA4040000, 0x10, 0xA4040004, 0x80d0, 0xA4040008, 0xff8)
  WriteSP_ReadLength(15)
  PrintSPMEM(DoubleWrite_7, 8, 10 * 8, 0x00626AF7)
  DisplaySP_SPMEM(230, 10 * 9)
  DisplaySP_RDRAM(300, 10 * 9)
  DisplaySP_ReadLength(370, 10 * 9)
  PrintPassIf3ValuesMatch((SCREEN_X - 64), 10 * 9, 0xA4040000, 0x10, 0xA4040004, 0x80d0, 0xA4040008, 0xff8)

  // Unaligned SPMEM address
  DMATo(ZEROES, 0x04000000, 63)
  DMATo(TESTDATA, 0x04000008, 15)
  PrintSPMEM(From0To8For15Bytes_9, 8, 10 * 10, 0x71951b)

  DMATo(ZEROES, 0x04000000, 63)
  DMATo(TESTDATA, 0x04000004, 15)
  PrintSPMEM(From0To4For15Bytes_9, 8, 10 * 11, 0x626af7)

  DMATo(ZEROES, 0x04000000, 63)
  DMATo(TESTDATA, 0x04000001, 15)
  PrintSPMEM(From0To1For15Bytes_9, 8, 10 * 12, 0x626af7)

  // Unaligned length
  DMATo(ZEROES, 0x04000000, 63)
  DMATo(TESTDATA, 0x04000000, 7)
  PrintSPMEM(From0To0For7Bytes_8, 7, 10 * 13, 0x2020)

  DMATo(ZEROES, 0x04000000, 63)
  DMATo(TESTDATA, 0x04000000, 3)
  PrintSPMEM(From0To0For3Bytes_8, 7, 10 * 14, 0x2020)

  DMATo(ZEROES, 0x04000000, 63)
  DMATo(TESTDATA, 0x04000000, 1)
  PrintSPMEM(From0To0For1Bytes_8, 7, 10 * 15, 0x2020)

  DMATo(ZEROES, 0x04000000, 63)
  DMATo(TESTDATA, 0x04000000, 0)
  PrintSPMEM(From0To0For0Bytes_8, 7, 10 * 16, 0x2020)

  DMATo(ZEROES, 0x04000000, 63)
  DMATo(TESTDATA, 0x04000000, 0x1000)
  PrintSPMEM(Count1_6, 5, 10 * 17, 0x626af7)

  DMATo(ZEROES, 0x04000000, 63)
  DMATo(TESTDATA, 0x04000000, 0x202000)
  PrintSPMEM(Count2Skip2_12, 11, 10 * 18, 0x67d0b7)

  DMATo(ZEROES, 0x04000000, 63)
  DMATo(TESTDATA, 0x04000000, 0x402000)
  PrintSPMEM(Count2Skip4_12, 11, 10 * 19, 0x67d0b7)

  DMATo(ZEROES, 0x04000000, 63)
  DMATo(TESTDATA, 0x04000000, 0x802000)
  PrintSPMEM(Count2Skip8_12, 11, 10 * 20, 0x1a756f)

  DMATo(ZEROES, 0x04000000, 63)
  DMATo(TESTDATA, 0x04000000, 0x1002000)
  PrintSPMEM(Count2Skip16_13, 12, 10 * 21, 0x3dc002)
  DisplaySP_SPMEM(230, 10 * 22)
  DisplaySP_RDRAM(300, 10 * 22)
  DisplaySP_ReadLength(370, 10 * 22)
  PrintPassIf3ValuesMatch((SCREEN_X - 64), 10 * 22, 0xA4040000, 0x18, 0xA4040004, 0x80f8, 0xA4040008, 0x01000ff8)

  // more things to test:
  //  - overflow at the end of spmem
  //  - higher bits of SPMEM-address - is the 04000000 completely optional?
  // but hey, we're out of screenspace

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
From0To8For15Bytes_9:
  db "0->8 15b:"
From0To4For15Bytes_9:
  db "0->4 15b:"
From0To1For15Bytes_9:
  db "0->1 15b:"
From0To0For7Bytes_8:
  db "0->0 7b:"
From0To0For3Bytes_8:
  db "0->0 3b:"
From0To0For1Bytes_8:
  db "0->0 1b:"
From0To0For0Bytes_8:
  db "0->0 0b:"
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

align(16)
ZEROES:
  dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0


align(8)
RDWORD:
  dw 0
insert FontBlack, "FontBlack8x8.bin"
insert FontGreen, "FontGreen8x8.bin"
insert FontRed, "FontRed8x8.bin"
