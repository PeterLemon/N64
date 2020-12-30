// Tests behavior of LL, LLD, SC, SCD
// Author: Lemmy with original sources from Peter Lemon's test sources
output "LL_LLD_SC_SCD.N64", create
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

constant RANDOM(1)
constant COUNT(9)
constant COMPARE(11)
constant STATUS(12)
constant CAUSE(13)
constant LLADDR(17)
constant EXCEPTPC(14)
constant ERRORPC(30)

macro PrintPassIfValueMatches(left, top, source1, expected1) {
    lui r1, 0   // this becomes 1 if any value differs

    la r2, {source1}
    lw r2, 0(r2)
    la r3, {expected1}
    beq r2, r3, {#}Equal1
    nop
    ori r1, r1, 1
{#}Equal1:

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

macro PrintPassIf5ValuesMatch(left, top, source1, expected1, source2, expected2, source3, expected3, source4, expected4, source5, expected5) {
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

    la r2, {source5}
    lw r2, 0(r2)
    la r3, {expected5}
    beq r2, r3, {#}Equal5
    nop
    ori r1, r1, 1
{#}Equal5:

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

  variable top(16)

  // Print previous value of LLAddr (usually 0xFFFFFFFF, but it is not initialized on reset so we're not checking for it)
  la r1, lladdr
  mfc0 r2, LLADDR
  sw r2, 0(r1)
  PrintValue($A0100000, (400), (top), FontBlack, lladdr, 3)

  // Set LLAddr to 0x00000000 and read it back
  variable top(top+16)
  la r1, 0x00000000
  mtc0 r1, LLADDR
  la r1, lladdr
  mfc0 r2, LLADDR
  sw r2, 0(r1)
  PrintValue($A0100000, (400), (top), FontBlack, lladdr, 3)
  PrintPassIfValueMatches(560, top, lladdr, 0x00000000)

  // Set LLAddr to 0xFFFFFFFF and read it back
  variable top(top+16)
  la r1, 0xFFFFFFFF
  mtc0 r1, LLADDR
  la r1, lladdr
  mfc0 r2, LLADDR
  sw r2, 0(r1)
  PrintValue($A0100000, (400), (top), FontBlack, lladdr, 3)
  PrintPassIfValueMatches(560, top, lladdr, 0xffffffff)

  // Negative test: Clear LLBit, then run just SC
  variable top(top+16)
  la r1, 0x00000000
  mtc0 r1, LLADDR
  la r1, test
  lw r2, 0(r1)
  la r1, test2
  sc r2, 0(r1)
  la r1, RDWORD
  sw r2, 0(r1)
  la r1, lladdr
  mfc0 r2, LLADDR
  sw r2, 0(r1)
  PrintString($A0100000, (16), (top), FontBlack, JustSC0_3, 2)
  PrintValue($A0100000, (160), (top), FontBlack, test2, 3)
  PrintValue($A0100000, (320), (top), FontBlack, RDWORD, 3)
  PrintValue($A0100000, (400), (top), FontBlack, lladdr, 3)
  PrintPassIf3ValuesMatch(560, top, test2, 0x00000000, RDWORD, 0x00000000, lladdr, 0x00000000)

  // Negative test: Clear LLBit, then run just SC
  variable top(top+16)
  la r1, 0x00000000
  la r1, test
  ld r2, 0(r1)
  la r1, test2
  scd r2, 0(r1)
  la r1, RDWORD
  sw r2, 0(r1)
  la r1, lladdr
  mfc0 r2, LLADDR
  sw r2, 0(r1)

  PrintString($A0100000, (16), (top), FontBlack, JustSCD0_4, 3)
  PrintValue($A0100000, (160), (top), FontBlack, test2, 7)
  PrintValue($A0100000, (320), (top), FontBlack, RDWORD, 3)
  PrintValue($A0100000, (400), (top), FontBlack, lladdr, 3)
  PrintPassIf4ValuesMatch(560, top, test2, 0x00000000, (test2+4), 0x00000000, RDWORD, 0x00000000, lladdr, 0x00000000)

  // Positive test: LL followed by SC
  variable top(top+16)
  la r1, 0x00000000
  mtc0 r1, LLADDR
  la r1, test
  ll r2, 0(r1)
  la r4, lladdr
  mfc0 r3, LLADDR
  sw r3, 0(r4)
  la r1, test2
  sc r2, 0(r1)
  la r1, RDWORD
  sw r2, 0(r1)
  la r4, lladdr2
  mfc0 r3, LLADDR
  sw r3, 0(r4)

  PrintString($A0100000, (16), (top), FontBlack, LL_SC_6, 5)
  PrintValue($A0100000, (160), (top), FontBlack, test2, 3)
  PrintValue($A0100000, (320), (top), FontBlack, RDWORD, 3)
  PrintValue($A0100000, (400), (top), FontBlack, lladdr, 3)
  PrintValue($A0100000, (470), (top), FontBlack, lladdr2, 3)
  PrintPassIf4ValuesMatch(560, top, test2, 0xBADDECAF, RDWORD, 0x00000001, lladdr, 0x000003C0, lladdr2, 0x000003C0)

  // Positive test: LLD followed by SCD
  variable top(top+16)
  la r1, 0x00000000
  mtc0 r1, LLADDR
  la r1, test
  lld r2, 0(r1)
  la r4, lladdr
  mfc0 r3, LLADDR
  sw r3, 0(r4)
  la r1, test2
  scd r2, 0(r1)
  la r1, RDWORD
  sw r2, 0(r1)
  la r4, lladdr2
  mfc0 r3, LLADDR
  sw r3, 0(r4)

  PrintString($A0100000, (16), (top), FontBlack, LLD_SCD_8, 7)
  PrintValue($A0100000, (160), (top), FontBlack, test2, 7)
  PrintValue($A0100000, (320), (top), FontBlack, RDWORD, 3)
  PrintValue($A0100000, (400), (top), FontBlack, lladdr, 3)
  PrintValue($A0100000, (470), (top), FontBlack, lladdr2, 3)
  PrintPassIf5ValuesMatch(560, top, test2, 0xBADDECAF, (test2+4), 0xDEADF00D, RDWORD, 0x00000001, lladdr, 0x000003C0, lladdr2, 0x000003C0)

  // Positive test: LL followed by SC, very different location
  variable top(top+16)
  la r1, 0x00000000
  mtc0 r1, LLADDR
  la r1, test3
  ll r2, 0(r1)
  la r4, lladdr
  mfc0 r3, LLADDR
  sw r3, 0(r4)
  la r1, test2
  sc r2, 0(r1)
  la r1, RDWORD
  sw r2, 0(r1)
  la r4, lladdr2
  mfc0 r3, LLADDR
  sw r3, 0(r4)

  PrintString($A0100000, (16), (top), FontBlack, LL_SC_diff_loc_17, 16)
  PrintValue($A0100000, (160), (top), FontBlack, test2, 3)
  PrintValue($A0100000, (320), (top), FontBlack, RDWORD, 3)
  PrintValue($A0100000, (400), (top), FontBlack, lladdr, 3)
  PrintValue($A0100000, (470), (top), FontBlack, lladdr2, 3)
  PrintPassIf4ValuesMatch(560, top, test2, 0xBADDECAF, RDWORD, 0x00000001, lladdr, 0x000003D0, lladdr2, 0x000003D0)

  // Positive test: LL followed by SC, with LLAddr being written to inbetween.
  variable top(top+16)
  la r1, 0x00000000
  mtc0 r1, LLADDR
  la r1, test
  ll r2, 0(r1)
  la r4, lladdr
  mfc0 r3, LLADDR
  sw r3, 0(r4)
  la r3, 0xdeaddead
  mtc0 r3, LLADDR
  nop
  la r1, test2
  sc r2, 0(r1)
  la r1, RDWORD
  sw r2, 0(r1)
  la r4, lladdr2
  mfc0 r3, LLADDR
  sw r3, 0(r4)

  PrintString($A0100000, (16), (top), FontBlack, LL_SC_MTC0_11, 10)
  PrintValue($A0100000, (160), (top), FontBlack, test2, 3)
  PrintValue($A0100000, (320), (top), FontBlack, RDWORD, 3)
  PrintValue($A0100000, (400), (top), FontBlack, lladdr, 3)
  PrintValue($A0100000, (470), (top), FontBlack, lladdr2, 3)
  PrintPassIf4ValuesMatch(560, top, test2, 0xBADDECAF, RDWORD, 0x00000001, lladdr, 0x000003C0, lladdr2, 0xdeaddead)

  // Negative test: LL, ERET, SC
  variable top(top+16)
  la r1, test
  ll r2, 0(r1)
  la r4, lladdr
  mfc0 r3, LLADDR
  sw r3, 0(r4)
  la r3, eret_target
  mtc0 r3, EXCEPTPC
  mtc0 r3, ERRORPC
  nop
  nop
  eret
  nop
  nop
eret_target:
  nop
  nop
  la r1, test2
  sc r2, 0(r1)
  la r1, RDWORD
  sw r2, 0(r1)
  la r4, lladdr2
  mfc0 r3, LLADDR
  sw r3, 0(r4)

  PrintString($A0100000, (16), (top), FontBlack, LL_ERET_SC_11, 10)
  PrintValue($A0100000, (160), (top), FontBlack, test2, 3)
  PrintValue($A0100000, (320), (top), FontBlack, RDWORD, 3)
  PrintValue($A0100000, (400), (top), FontBlack, lladdr, 3)
  PrintValue($A0100000, (470), (top), FontBlack, lladdr2, 3)
  PrintPassIf4ValuesMatch(560, top, test2, 0xBADDECAF, RDWORD, 0x00000000, lladdr, 0x000003C0, lladdr2, 0x000003C0)


Loop:
  j Loop
  nop // Delay Slot



align(8)
PASS:
  db "PASS"

align(8)
FAIL:
  db "FAIL"

LL_SC_6:
  db "LL+SC:"
LL_SC_diff_loc_17:
  db "LL+SC (diff loc):"
LL_SC_MTC0_11:
  db "LL+MTC0+SC:"
LL_ERET_SC_11:
  db "LL+ERET+SC:"

JustSC0_3:
  db "SC:"

JustSCD0_4:
  db "SCD:"

LLD_SCD_8:
  db "LLD+SCD:"

LD_SCD_7:
  db "LD+SCD:"

align(0x100)
test:
  dd 0xBADDECAFDEADF00D
test2:
  dd 0x0

align(0x100)
test3:
  dd 0xBADDECAFDEADF00D

align(8)
RDWORD:
  dw 0
lladdr:
  dw 0
lladdr2:
  dw 0
insert FontBlack, "FontBlack8x8.bin"
insert FontGreen, "FontGreen8x8.bin"
insert FontRed, "FontRed8x8.bin"
