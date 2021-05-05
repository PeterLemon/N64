// Tests behavior of PI DMA: Unaligned vs unaligned, going from ROM to RDRAM
// Also tests what the PI registers return when being read
// Authors: Lemmy & Mazamars312 with original sources from Peter Lemon's test sources
output "DMAAlignment-PI-ROM-FROM_large_6.N64", create
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

macro PrintData(label, label_length, top, offset, expectedHash) {
    constant {#}byteCount(15)
	
    PrintString($A0100000, 8, {top}, FontBlack, {label}, {label_length})
    PrintValue($A0100000, 104, {top}, FontBlack, (0xA0000000 | (data + {offset})), {#}byteCount)

	// Calculate simple hash so that we can say OK/FAIL
    la r1, (0xA0000000 | data + {offset})
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

  WritePI_RDRAM(0xffffffff)
  WritePI_CART(0xffffffff)
  
  PrintString($A0100000, 0, 10 * 1, FontRed, MemoryOffset, 12)

  // ROM (source) address alignment. We'll start at 0x100 as it seems that some development hardware messes with headers
  ZeroMemory()
  DMAFrom(data + 6, 0x10001000, 255)
  PrintData(From0to15  	, 8, 10 * 2, 0x0000, 0x000014f8)
  PrintData(From16to31 	, 8, 10 * 3, 0x0010, 0x003f1764)
  PrintData(From32to47	, 8, 10 * 4, 0x0020, 0x00023f78)
  PrintData(From48to63	, 8, 10 * 5, 0x0030, 0x003c5c58)
  PrintData(From64to79	, 8, 10 * 6, 0x0040, 0x001d0e4c)
  PrintData(From80to95	, 8, 10 * 7, 0x0050, 0x0002f56c)
  PrintData(From96to111	, 8, 10 * 8, 0x0060, 0x000048b8)
  PrintData(From112to127, 8, 10 * 9, 0x0070, 0x001f5900)
  PrintData(From128to143, 8, 10 *10, 0x0080, 0x002294f8)
  PrintData(From144to159, 8, 10 *11, 0x0090, 0x000cfb78)
  PrintData(From160to175, 8, 10 *12, 0x00a0, 0x000e987a)
  PrintData(From176to191, 8, 10 *13, 0x00b0, 0x004026b8)
  PrintData(From192to207, 8, 10 *14, 0x00c0, 0x005844d0)
  PrintData(From208to223, 8, 10 *15, 0x00d0, 0x000a0b58)
  PrintData(From224to239, 8, 10 *16, 0x00e0, 0x0003d9e0)
  PrintData(From240to255, 8, 10 *17, 0x00f0, 0x00000078)
  PrintData(From256to271, 8, 10 *18, 0x0100, 0x004e9000)
  
  nop


Loop:
  j Loop
  nop // Delay Slot


// Use a big alignment. This makes it less likely that offsets will change when program code is changed above
align(16384)

PASS:
  db "PASS"
FAIL:
  db "FAIL"
From0to15:
  db "0->15    16b:"
From16to31:
  db "16->31   16b:"
From32to47:
  db "32->47   16b:"
From48to63:
  db "48->63   16b:"
From64to79:
  db "64->79   16b:"
From80to95:
  db "80->95   16b:"
From96to111:
  db "96->111  16b:"
From112to127:
  db "112->127 16b:"
From128to143:
  db "128->143 16b:"
From144to159:
  db "144->159 16b:"
From160to175:
  db "160->175 16b:"
From176to191:
  db "176->191 16b:"
From192to207:
  db "192->207 16b:"
From208to223:
  db "208->223 16b:"
From224to239:
  db "224->239 16b:"
From240to255:
  db "240->255 16b:"
From256to271:
  db "256->271 16b:"

MemoryOffset:
  db "MEMORY OFFSET"
  
MemoryData:
  db "MEMORY DATA"
  
PassOrFail:
  db "PASS OR FAIL"

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
