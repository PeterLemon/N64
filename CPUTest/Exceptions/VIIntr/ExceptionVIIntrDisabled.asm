// Tests VI Interrupt: Understand how VI interrupts are passed through from VI to MI to CP0 and how the masks are used.
// Author: Lemmy with original sources from Peter Lemon's test sources
output "ExceptionVIIntrDisabled.n64", create
arch n64.cpu
endian msb
fill 1052672 // Set ROM Size

constant SCREEN_X(400)
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

macro PrintPassIfValueMatches(left, top, source1, mask1, expected1) {
    lui r1, 0   // this becomes 1 if any value differs

    la r2, {source1}
    lw r2, 0(r2)
    la r3, {mask1}
    and r2, r2, r3
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

macro PrintPassIf2ValuesMatch(left, top, source1, mask1, expected1, source2, mask2, expected2) {
    lui r1, 0   // this becomes 1 if any value differs

    la r2, {source1}
    lw r2, 0(r2)
    la r3, {mask1}
    and r2, r2, r3
    la r3, {expected1}
    beq r2, r3, {#}Equal1
    nop
    ori r1, r1, 1
{#}Equal1:

    la r2, {source2}
    lw r2, 0(r2)
    la r3, {mask2}
    and r2, r2, r3
    la r3, {expected2}
    beq r2, r3, {#}Equal2
    nop
    ori r1, r1, 1
{#}Equal2:

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

macro ClearMIInterrupts() {
  // Clear SI interrupt
  la r1, 0xA4800018
  sw r0, 0(r1)

  // Clear VI interrupt
  la r1, 0xA4400010
  sw r0, 0(r1)

  // Need some nops so that the MI can notify the CPU
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
}

// Sleep long enough to be certain that a VI fired
macro Sleep() {
  mfc0 r1, COUNT
{#}sleep:
  mfc0 r2, COUNT
  sub r2, r2, r1
  li r3, 0x01000000
  sub r2, r3, r2
  bgtz r2, {#}sleep
  nop
}

macro InstallExceptionHandlers() {
    memcpy(0x80000000, handler_0, 0x80)
    memcpy(0x80000080, handler_80, 0x100)
    memcpy(0x80000180, handler_180, 0x100)
    InvalidateCache(0x80000000, 0x300, 25) // index load data
    InvalidateCache(0x80000000, 0x300, 16) // hit invalidate - instruction
}

Start:
  include "LIB/N64_GFX.INC" // Include Graphics Macros
  N64_INIT() // Run N64 Initialisation Routine

  ScreenNTSC(SCREEN_X, SCREEN_Y, BPP32|AA_MODE_2, $A0100000)

  WaitScanline($200) // Wait For Scanline To Reach Vertical Blank

  clear($A0100000, $A0100000 + SCREEN_X*BYTES_PER_PIXEL*SCREEN_Y)

  InstallExceptionHandlers()


  // Disable exceptions in COP0
  mfc0 r1, STATUS
  li r2, 0xFFFF00FE
  and r1, r1, r2
  mtc0 r1, STATUS

  // Set COMPARE to ensure we got plenty of time before it kicks in
  mfc0 r1, COUNT
  addu r1, r1, -1
  mtc0 r1, COMPARE

  variable top(0)

  // ---------------------------------------------------------------------------
  // Clear interrupts, read mi intr and display
  // ---------------------------------------------------------------------------
  ClearMIInterrupts()
  variable top(top + 16)
  li r3, 0xA4300008
  lw r1, 0(r3)
  li r2, Before
  sw r1, 0(r2)
  nop
  nop
  nop
  PrintString($A0100000, (16), (top), FontBlack, MI_INTR_8, 7)
  PrintValue($A0100000, (200), (top), FontBlack, Before, 3)
  PrintPassIfValueMatches(340, top, Before, 0xFFFFFFFF, 0x00000000)


  // ---------------------------------------------------------------------------
  // Waste some time to ensure we got a vblank. Then print MI_INTR_REG again
  // ---------------------------------------------------------------------------
  Sleep()

  variable top(top + 16)
  li r3, 0xA4300008
  lw r1, 0(r3)
  li r2, Before
  sw r1, 0(r2)
  nop
  nop
  nop
  PrintString($A0100000, (16), (top), FontBlack, MI_INTR_8, 7)
  PrintValue($A0100000, (200), (top), FontBlack, Before, 3)
  PrintPassIfValueMatches(340, top, Before, 0xFFFFFFFF, 0x00000008)

  // ---------------------------------------------------------------------------
  // Print Cause. It should not have the VI because the mask was disabled
  // ---------------------------------------------------------------------------
  variable top(top + 16)
  mfc0 r1, CAUSE
  li r2, Before
  sw r1, 0(r2)
  PrintString($A0100000, (16), (top), FontBlack, Cause_6, 5)
  PrintValue($A0100000, (200), (top), FontBlack, Before, 3)
  PrintPassIfValueMatches(340, top, Before, 0x0FFFFF00, 0x00000000)



  // ---------------------------------------------------------------------------
  // Read mi intr mask, enable VI Intr and read back to the mask
  // ---------------------------------------------------------------------------
  li r3, 0xA430000C
  variable top(top + 16)
  lw r1, 0(r3)
  li r2, Before
  sw r1, 0(r2)
  li r1, 0x80
  sw r1, 0(r3)
  nop
  nop
  lw r1, 0(r3)
  li r2, After
  sw r1, 0(r2)
  nop
  nop
  nop
  PrintString($A0100000, (16), (top), FontBlack, MI_INTR_MASK_13, 12)
  PrintValue($A0100000, (160), (top), FontBlack, Before, 3)
  PrintValue($A0100000, (240), (top), FontBlack, After, 3)
  PrintPassIf2ValuesMatch(340, top, Before, 0xFFFFFFFF, 0x00000000, After, 0xFFFFFFFF, 0x00000008)





  // ---------------------------------------------------------------------------
  // Second run: With MI_INTR_MASK having the VI interrupt enabled, wait a bit
  // Expected: We should see the COP0 MI interrupt bit set
  // ---------------------------------------------------------------------------
  ClearMIInterrupts()
  variable top(top + 16)

  mfc0 r1, CAUSE
  li r2, Before
  sw r1, 0(r2)

  Sleep()

  mfc0 r1, CAUSE
  li r2, After
  sw r1, 0(r2)
  PrintString($A0100000, (16), (top), FontBlack, VIEnabled_13, 12)
  PrintValue($A0100000, (160), (top), FontBlack, Before, 3)
  PrintValue($A0100000, (240), (top), FontBlack, After, 3)

  // Ensure that the interrupt we got was a VI
  PrintPassIf2ValuesMatch(340, top, Before, 0x0FFFFF00, 0x00000000, After, 0x0FFFFF00, 0x00000400)

  variable top(top + 32)
  // Clear MASK bit and wait a bit. This will clear the CAUSE bit
  li r3, 0xA430000C
  li r2, 0x40   // clear vi
  sw r2, 0(r3)
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  // Read both CAUSE and MI_INTR_REG
  mfc0 r1, CAUSE
  li r3, 0xA4300008
  lw r2, 0(r3)
  li r3, Before
  sw r1, 0(r3)
  li r3, After
  sw r2, 0(r3)
  PrintString($A0100000, (16), (top), FontBlack, Cause_6, 5)
  PrintValue($A0100000, (200), (top), FontBlack, Before, 3)
  PrintPassIfValueMatches(340, top, Before, 0x0FFFFF00, 0x00000000)
  variable top(top + 16)
  PrintString($A0100000, (16), (top), FontBlack, MI_INTR_8, 7)
  PrintValue($A0100000, (200), (top), FontBlack, After, 3)
  PrintPassIfValueMatches(340, top, After, 0x0FFFFFFF, 0x00000008)







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
MI_INTR_8:
  db "MI_INTR:"
MI_INTR_MASK_13:
  db "MI_INTR_MASK:"
VIDisabled_14:
  db "VI=off. Cause:"
VIEnabled_13:
  db "VI=on. Cause:"
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
Before:
  dw 0
After:
  dw 0
HandlerPC:
  dw 0
ReturnPC:
  dw 0


insert FontBlack, "FontBlack8x8.bin"
insert FontGreen, "FontGreen8x8.bin"
insert FontRed, "FontRed8x8.bin"
