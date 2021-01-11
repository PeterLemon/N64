// Tests COMPARE with various way of disabling exceptions
// Author: Lemmy with original sources from Peter Lemon's test sources
output "ExceptionCompareDisabled.n64", create
arch n64.cpu
endian msb
fill 1052672 // Set ROM Size

constant SCREEN_X(400)
constant SCREEN_Y(240)
constant BYTES_PER_PIXEL(4)
// Setup Characters
constant CHAR_X(8)
constant CHAR_Y(8)

define header_title_27("Exc: Compare (disabled)    ")

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
    PrintString($A0100000, ({left}), ({top}), FontRed, FAIL, 3)
    b {#}Done
    nop
{#}Equal:
    PrintString($A0100000, ({left}), ({top}), FontGreen, PASS, 3)

{#}Done:
}

macro PrintPassIf1ValueMatchesAnd1IsInRange(left, top, source1, expected1, source2, minExpected2, maxExpected2) {
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
    la r3, {minExpected2}
    sub r3, r2, r3
    bltz r3, {#}OutsideRange2
    nop
    la r3, {maxExpected2}
    sub r3, r3, r2
    bltz r3, {#}OutsideRange2
    nop
    b {#}Done2
    nop
{#}OutsideRange2:
    ori r1, r1, 1
{#}Done2:

    beqz r1, {#}Equal

    nop
    PrintString($A0100000, ({left}), ({top}), FontRed, FAIL, 3)
    b {#}Done
    nop
{#}Equal:
    PrintString($A0100000, ({left}), ({top}), FontGreen, PASS, 3)

{#}Done:
}

constant RANDOM(1)
constant CONTEXT(4)
constant COUNT(9)
constant COMPARE(11)
constant STATUS(12)
constant CAUSE(13)
constant EXCEPTPC(14)
constant BADVADDR(8)
constant ERRORPC(30)

macro memcpy(to, from, length) {
    la r1, {to}
    la r2, {from}
    la r3, {length}
{#}loop:
    lw r4, 0(r2)
    sw r4, 0(r1)
    addi r1, r1, 4
    addi r2, r2, 4
    addi r3, r3, -4
    bgtz r3, {#}loop
    nop
}

macro InvalidateCache(start, length, type) {
    la r1, {start}
    la r3, {length}
{#}loop:
    cache {type}, 0(r1)
    addi r1, r1, 16
    addi r3, r3, -16
    bgtz r3, {#}loop
    nop
}

macro InstallExceptionHandlers() {
    memcpy(0x80000000, handler_0, 0x80)
    memcpy(0x80000080, handler_80, 0x100)
    memcpy(0x80000180, handler_180, 0x100)
    InvalidateCache(0x80000000, 0x300, 25) // index load data
    InvalidateCache(0x80000000, 0x300, 16) // hit invalidate - instruction
}

macro ShowRow(top, label, labelLength, data, expectedBefore, expectedDuring, expectedAfter) {
  PrintString($A0100000, (16), ({top}), FontBlack, {label}, {labelLength})
  PrintValue($A0100000, (112), ({top}), FontBlack, {data}, 3)
  PrintValue($A0100000, (188), ({top}), FontBlack, ({data}+4), 3)
  PrintValue($A0100000, (264), ({top}), FontBlack, ({data}+8), 3)
  PrintPassIf3ValuesMatch(340, top, {data}, {expectedBefore}, ({data}+4), {expectedDuring}, ({data}+8), {expectedAfter})
}

// Doesn't test the previous value. It still shows it though
macro ShowRowNoBefore(top, label, labelLength, data, expectedDuring, expectedAfter) {
  PrintString($A0100000, (16), ({top}), FontBlack, {label}, {labelLength})
  PrintValue($A0100000, (112), ({top}), FontBlack, {data}, 3)
  PrintValue($A0100000, (188), ({top}), FontBlack, ({data}+4), 3)
  PrintValue($A0100000, (264), ({top}), FontBlack, ({data}+8), 3)
  PrintPassIf2ValuesMatch(340, top, ({data}+4), {expectedDuring}, ({data}+8), {expectedAfter})
}

Start:
  include "LIB/N64_GFX.INC" // Include Graphics Macros
  N64_INIT() // Run N64 Initialisation Routine

  ScreenNTSC(SCREEN_X, SCREEN_Y, BPP32|AA_MODE_2, $A0100000)

  WaitScanline($200) // Wait For Scanline To Reach Vertical Blank

  clear($A0100000, $A0100000 + SCREEN_X*BYTES_PER_PIXEL*SCREEN_Y)

  InstallExceptionHandlers()


  // First run: Interrupts and compare both disabled
  variable top(16)
  mfc0 r1, COUNT
  li r2, Count
  sw r1, 0(r2)
  la r2, 0x01000000
  add r1, r1, r2
  mtc0 r1, COMPARE

  mfc0 r1, STATUS
  li r2, 0xFFFF7FFE
  and r1, r1, r2
  mtc0 r1, STATUS
  nop
  nop
  nop
  PrintString($A0100000, (16), (top), FontBlack, Wait_7, 6)
WaitForCompare:
  mfc0 r1, CAUSE
  la r2, 0x00008000
  and r1, r1, r2
  beqz r1, WaitForCompare
  nop
  mfc0 r3, COUNT
  li r1, Count
  li r2, CountDelta
  lw r4, 0(r1)     // Load LastCount
  sub r4, r3, r4   // Count - LastCount
  sw r4, 0(r2)     // Store CountDelta
  sw r3, 0(r1)     // Store Count as new LastCount
  PrintString($A0100000, (16), (top), FontBlack, BothDisabled_14, 13)
  PrintValue($A0100000, (160), (top), FontBlack, HandlerPC, 3)
  PrintValue($A0100000, (240), (top), FontBlack, CountDelta, 3)
  PrintPassIf1ValueMatchesAnd1IsInRange(340, top, HandlerPC, 0x00000000, CountDelta, 0x01000000, 0x01000100)

  // Second run: Interrupts enabled, compare disabled
  variable top(top+16)
  mfc0 r1, COUNT
  li r2, Count
  sw r1, 0(r2)
  la r2, 0x01000000
  add r1, r1, r2
  mtc0 r1, COMPARE
  mfc0 r1, STATUS
  li r2, 0xFFFF7FFE
  and r1, r1, r2
  ori r1, r1, 0x0001
  mtc0 r1, STATUS
  nop
  nop
  nop
  PrintString($A0100000, (16), (top), FontBlack, Wait_7, 6)
WaitForCompare2:
  mfc0 r1, CAUSE
  la r2, 0x00008000
  and r1, r1, r2
  beqz r1, WaitForCompare2
  nop
  mfc0 r3, COUNT
  li r1, Count
  li r2, CountDelta
  lw r4, 0(r1)     // Load LastCount
  sub r4, r3, r4   // Count - LastCount
  sw r4, 0(r2)     // Store CountDelta
  PrintString($A0100000, (16), (top), FontBlack, InterruptDisabled_11, 10)
  PrintValue($A0100000, (160), (top), FontBlack, HandlerPC, 3)
  PrintValue($A0100000, (240), (top), FontBlack, CountDelta, 3)
  PrintPassIf1ValueMatchesAnd1IsInRange(340, top, HandlerPC, 0x00000000, CountDelta, 0x01000000, 0x01000100)

  // Third run: Interrupts disabled, compare enabled
  variable top(top+16)

  mfc0 r1, COUNT
  li r2, Count
  sw r1, 0(r2)
  la r2, 0x01000000
  add r1, r1, r2
  mtc0 r1, COMPARE

  mfc0 r1, STATUS
  li r2, 0xFFFF7FFE
  and r1, r1, r2
  ori r1, r1, 0x8000
  mtc0 r1, STATUS
  nop
  nop
  nop
  PrintString($A0100000, (16), (top), FontBlack, Wait_7, 6)
WaitForCompare3:
  mfc0 r1, CAUSE
  la r2, 0x00008000
  and r1, r1, r2
  beqz r1, WaitForCompare3
  nop
  mfc0 r3, COUNT
  li r1, Count
  li r2, CountDelta
  lw r4, 0(r1)     // Load LastCount
  sub r4, r3, r4   // Count - LastCount
  sw r4, 0(r2)     // Store CountDelta
  PrintString($A0100000, (16), (top), FontBlack, CompareDisabled_11, 10)
  PrintValue($A0100000, (160), (top), FontBlack, HandlerPC, 3)
  PrintValue($A0100000, (240), (top), FontBlack, CountDelta, 3)
  PrintPassIf1ValueMatchesAnd1IsInRange(340, top, HandlerPC, 0x00000000, CountDelta, 0x01000000, 0x01000100)

  // Fourth run: Interrupts enabled, compare enabled
  variable top(top+16)

  mfc0 r1, COUNT
  li r2, Count
  sw r1, 0(r2)
  la r2, 0x01000000
  add r1, r1, r2
  mtc0 r1, COMPARE

  mfc0 r1, STATUS
  ori r1, r1, 0x8001
  mtc0 r1, STATUS
  nop
  nop
  nop
  PrintString($A0100000, (16), (top), FontBlack, Wait_7, 6)
  li r1, ReturnPC
  li r2, PostLoop4
  sw r2, 0(1)
WaitForCompare4:
  mfc0 r1, CAUSE
  la r2, 0x00008000
  and r1, r1, r2
  beqz r1, WaitForCompare4
  nop
PostLoop4:
  mfc0 r3, COUNT
  li r1, Count
  li r2, CountDelta
  lw r4, 0(r1)     // Load LastCount
  sub r4, r3, r4   // Count - LastCount
  sw r4, 0(r2)     // Store CountDelta
  PrintString($A0100000, (16), (top), FontBlack, BothEnabled_13, 12)
  PrintValue($A0100000, (160), (top), FontBlack, HandlerPC, 3)
  PrintValue($A0100000, (240), (top), FontBlack, CountDelta, 3)
  PrintPassIf1ValueMatchesAnd1IsInRange(340, top, HandlerPC, 0x80000180, CountDelta, 0x01000000, 0x01000100)


  // Fifth: Without resetting COMPARE, simply enable interrupts again. This should fire again right away
  variable top(top+16)
  mfc0 r1, COUNT
  li r2, Count
  sw r1, 0(r2)
  li r1, ReturnPC
  li r2, PostEnable
  sw r2, 0(1)

  la r1, HandlerPC
  sw r0, 0(r1)
  mfc0 r1, STATUS
  ori r1, r1, 0x8001
  mtc0 r1, STATUS
  mfc0 r1, COUNT

  nop
  nop
PostEnable:
  nop
  nop

  mfc0 r3, COUNT
  li r1, Count
  li r2, CountDelta
  lw r4, 0(r1)     // Load LastCount
  sub r4, r3, r4   // Count - LastCount
  sw r4, 0(r2)     // Store CountDelta
  PrintString($A0100000, (16), (top), FontBlack, NoClear_9, 8)
  PrintValue($A0100000, (160), (top), FontBlack, HandlerPC, 3)
  PrintValue($A0100000, (240), (top), FontBlack, CountDelta, 3)
  PrintPassIf1ValueMatchesAnd1IsInRange(340, top, HandlerPC, 0x80000180, CountDelta, 0x00000000, 0x00000100)


Loop:
  j Loop
  nop // Delay Slot



align(8)
PASS:
  db "PASS"

align(8)
FAIL:
  db "FAIL"

Wait_7:
  db "Wait..."
BothDisabled_14:
  db "Both disabled:"
InterruptDisabled_11:
  db "Intr. dis.:"
CompareDisabled_11:
  db "Comp. dis.:"
BothEnabled_13:
  db "Both enabled:"
NoClear_9:
  db "No clear:"
ErrorPC_8:
  db "ErrorPC:"
ExceptPC_9:
  db "ExceptPC:"
Cause_6:
  db "Cause:"
Status_7:
  db "Status:"
BadVAddr_9:
  db "BadVAddr:"
Context_8:
  db "Context:"

align(0x100)
align(4)
handler_0:
  la r1, 0x80000000
  la r2, HandlerPC
  sw r1, 0(r2)

  // Disable compare interrupt
  mfc0 r1, STATUS
  li r2, 0xFFFF7FFE
  and r1, r1, r2
  mtc0 r1, STATUS

  // Load return address
  li r1, ReturnPC
  lw r1, 0(r1)
  mtc0 r1, EXCEPTPC

  // Need a minimum of 2 nops after changing EXCEPTPC before eret will work
  nop
  nop
  eret

align(0x100)
handler_80:
  la r1, 0x80000080
  la r2, HandlerPC
  sw r1, 0(r2)

  // Disable compare interrupt
  mfc0 r1, STATUS
  li r2, 0xFFFF7FFE
  and r1, r1, r2
  mtc0 r1, STATUS

  // Load return address
  li r1, ReturnPC
  lw r1, 0(r1)
  mtc0 r1, EXCEPTPC

  // Need a minimum of 2 nops after changing EXCEPTPC before eret will work
  nop
  nop
  nop
  eret

align(0x100)
handler_180:
  la r1, 0x80000180
  la r2, HandlerPC
  sw r1, 0(r2)

  // Disable compare interrupt
  mfc0 r1, STATUS
  li r2, 0xFFFF7FFE
  and r1, r1, r2
  mtc0 r1, STATUS

  // Load return address
  li r1, ReturnPC
  lw r1, 0(r1)
  mtc0 r1, EXCEPTPC

  // Need a minimum of 2 nops after changing EXCEPTPC before eret will work
  nop
  nop
  nop
  eret
  nop
  nop
  nop
  nop

align(0x1000)
HandlerPC:
  dw 0
Count:
  dw 0
CountDelta:
  dw 0
ReturnPC:
  dw 0


insert FontBlack, "FontBlack8x8.bin"
insert FontGreen, "FontGreen8x8.bin"
insert FontRed, "FontRed8x8.bin"
