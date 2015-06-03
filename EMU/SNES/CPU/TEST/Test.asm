arch snes.cpu
output "Test.sfc", create

macro seek(variable offset) {
  origin ((offset & $7F0000) >> 1) | (offset & $7FFF)
  base offset
}

seek($8000); fill $8000 // Fill Upto $7FFF (Bank 0) With Zero Bytes
include "LIB\SNES.INC"        // Include SNES Definitions
include "LIB\SNES_HEADER.ASM" // Include Header & Vector Table

seek($8000); Start:
  sei // Disable Interrupts
  clc // Clear Carry To Switch To Native Mode
  xce // Xchange Carry & Emulation Bit (Native Mode)

  phk
  plb
  rep #$38

  ldx.w #$1FFF // Set Stack To $1FFF
  txs // Transfer Index Register X To Stack Pointer

  lda.w #$0000
  tcd

  sep #$20 // Set 8-Bit Accumulator

  lda.b #0 // Romspeed: Slow ROM = 0, Fast ROM = 1

Loop:
  jmp Loop