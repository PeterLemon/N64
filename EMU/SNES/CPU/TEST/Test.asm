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
  sta.w REG_MEMSEL  // Access Cycle Designation (Slow ROM / Fast ROM)

  stz.w REG_OBSEL   // Object Size & Object Base ($2101)
  stz.w REG_OAMADDL // OAM Address (Lower 8-Bit) ($2102)
  stz.w REG_OAMADDH // OAM Address (Upper 1-Bit) & Priority Rotation ($2103)
  stz.w REG_BGMODE  // BG Mode & BG Character Size: Set Graphics Mode 0 ($2105)
  stz.w REG_MOSAIC  // Mosaic Size & Mosaic Enable: No Planes, No Mosiac ($2106)
  stz.w REG_BG1SC   // BG1 Screen Base & Screen Size: BG1 Map VRAM Location = $0000 ($2107)
  stz.w REG_BG2SC   // BG2 Screen Base & Screen Size: BG2 Map VRAM Location = $0000 ($2108)
  stz.w REG_BG3SC   // BG3 Screen Base & Screen Size: BG3 Map VRAM Location = $0000 ($2109)
  stz.w REG_BG4SC   // BG4 Screen Base & Screen Size: BG4 Map VRAM Location = $0000 ($210A)
  stz.w REG_BG12NBA // BG1/BG2 Character Data Area Designation: BG1/BG2 Tile Data Location = $0000 ($210B)
  stz.w REG_BG34NBA // BG3/BG4 Character Data Area Designation: BG3/BG4 Tile Data Location = $0000 ($210C)
  stz.w REG_BG1HOFS // BG1 Horizontal Scroll (X) / M7HOFS: BG1 Horizontal Scroll 1st Write = 0 (Lower 8-Bit) ($210D)
  stz.w REG_BG1HOFS // BG1 Horizontal Scroll (X) / M7HOFS: BG1 Horizontal Scroll 2nd Write = 0 (Upper 3-Bit) ($210D)
  stz.w REG_BG1VOFS // BG1 Vertical   Scroll (Y) / M7VOFS: BG1 Vertical   Scroll 1st Write = 0 (Lower 8-Bit) ($210E)
  stz.w REG_BG1VOFS // BG1 Vertical   Scroll (Y) / M7VOFS: BG1 Vertical   Scroll 2nd Write = 0 (Upper 3-Bit) ($210E)
  stz.w REG_BG2HOFS // BG2 Horizontal Scroll (X): BG2 Horizontal Scroll 1st Write = 0 (Lower 8-Bit) ($210F)
  stz.w REG_BG2HOFS // BG2 Horizontal Scroll (X): BG2 Horizontal Scroll 2nd Write = 0 (Upper 3-Bit) ($210F)
  stz.w REG_BG2VOFS // BG2 Vertical   Scroll (Y): BG2 Vertical   Scroll 1st Write = 0 (Lower 8-Bit) ($2110)
  stz.w REG_BG2VOFS // BG2 Vertical   Scroll (Y): BG2 Vertical   Scroll 2nd Write = 0 (Upper 3-Bit) ($2110)
  stz.w REG_BG3HOFS // BG3 Horizontal Scroll (X): BG3 Horizontal Scroll 1st Write = 0 (Lower 8-Bit) ($2111)
  stz.w REG_BG3HOFS // BG3 Horizontal Scroll (X): BG3 Horizontal Scroll 2nd Write = 0 (Upper 3-Bit) ($2111)
  stz.w REG_BG3VOFS // BG3 Vertical   Scroll (Y): BG3 Vertical   Scroll 1st Write = 0 (Lower 8-Bit) ($2112)
  stz.w REG_BG3VOFS // BG3 Vertical   Scroll (Y): BG3 Vertical   Scroll 2nd Write = 0 (Upper 3-Bit) ($2112)
  stz.w REG_BG4HOFS // BG4 Horizontal Scroll (X): BG4 Horizontal Scroll 1st Write = 0 (Lower 8-Bit) ($2113)
  stz.w REG_BG4HOFS // BG4 Horizontal Scroll (X): BG4 Horizontal Scroll 2nd Write = 0 (Upper 3-Bit) ($2113)
  stz.w REG_BG4VOFS // BG4 Vertical   Scroll (Y): BG4 Vertical   Scroll 1st Write = 0 (Lower 8-Bit) ($2114)
  stz.w REG_BG4VOFS // BG4 Vertical   Scroll (Y): BG4 Vertical   Scroll 2nd Write = 0 (Upper 3-Bit) ($2114)

  lda.b #$01
  stz.w REG_M7A // Mode7 Rot/Scale A (COSINE A) & Maths 16-Bit Operand: 1st Write = 0 (Lower 8-Bit) ($211B)
  sta.w REG_M7A // Mode7 Rot/Scale A (COSINE A) & Maths 16-Bit Operand: 2nd Write = 1 (Upper 8-Bit) ($211B)
  stz.w REG_M7B // Mode7 Rot/Scale B (SINE A)   & Maths  8-bit Operand: 1st Write = 0 (Lower 8-Bit) ($211C)
  stz.w REG_M7B // Mode7 Rot/Scale B (SINE A)   & Maths  8-bit Operand: 2nd Write = 0 (Upper 8-Bit) ($211C)
  stz.w REG_M7C // Mode7 Rot/Scale C (SINE B): 1st Write = 0 (Lower 8-Bit) ($211D)
  stz.w REG_M7C // Mode7 Rot/Scale C (SINE B): 2nd Write = 0 (Upper 8-Bit) ($211D)
  stz.w REG_M7D // Mode7 Rot/Scale D (COSINE B): 1st Write = 0 (Lower 8-Bit) ($211E)
  sta.w REG_M7D // Mode7 Rot/Scale D (COSINE B): 2nd Write = 1 (Upper 8-Bit) ($211E)
  stz.w REG_M7X // Mode7 Rot/Scale Center Coordinate X: 1st Write = 0 (Lower 8-Bit) ($211F)
  stz.w REG_M7X // Mode7 Rot/Scale Center Coordinate X: 2nd Write = 0 (Upper 8-Bit) ($211F)
  stz.w REG_M7Y // Mode7 Rot/Scale Center Coordinate Y: 1st Write = 0 (Lower 8-Bit) ($2120)
  stz.w REG_M7Y // Mode7 Rot/Scale Center Coordinate Y: 2nd Write = 0 (Upper 8-Bit) ($2120)

  stz.w REG_W12SEL  // Window BG1/BG2  Mask Settings = 0 ($2123)
  stz.w REG_W34SEL  // Window BG3/BG4  Mask Settings = 0 ($2124)
  stz.w REG_WOBJSEL // Window OBJ/MATH Mask Settings = 0 ($2125)
  stz.w REG_WH0     // Window 1 Left  Position (X1) = 0 ($2126)
  stz.w REG_WH1     // Window 1 Right Position (X2) = 0 ($2127)
  stz.w REG_WH2     // Window 2 Left  Position (X1) = 0 ($2128)
  stz.w REG_WH3     // Window 2 Right Position (X2) = 0 ($2129)
  stz.w REG_WBGLOG  // Window 1/2 Mask Logic (BG1..BG4) = 0 ($212A)
  stz.w REG_WOBJLOG // Window 1/2 Mask Logic (OBJ/MATH) = 0 ($212B)
  stz.w REG_TM      // Main Screen Designation = 0 ($212C)
  stz.w REG_TS      // Sub  Screen Designation = 0 ($212D)
  stz.w REG_TMW     // Window Area Main Screen Disable = 0 ($212E)
  stz.w REG_TSW     // Window Area Sub  Screen Disable = 0 ($212F)

  lda.b #$30
  sta.w REG_CGWSEL  // Color Math Control Register A = $30 ($2130)
  stz.w REG_CGADSUB // Color Math Control Register B = 0 ($2131)

  lda.b #$E0
  sta.w REG_COLDATA // Color Math Sub Screen Backdrop Color = $E0 ($2132)
  stz.w REG_SETINI  // Display Control 2 = 0 ($2133)

  stz.w REG_JOYWR // Joypad Output = 0 ($4016)

  stz.w REG_NMITIMEN // Interrupt Enable & Joypad Request: Reset VBlank, Interrupt, Joypad ($4200)

  lda.b #$FF
  sta.w REG_WRIO // Programmable I/O Port (Open-Collector Output) = $FF ($4201)

  stz.w REG_WRMPYA // Set Unsigned  8-Bit Multiplicand = 0 ($4202)
  stz.w REG_WRMPYB // Set Unsigned  8-Bit Multiplier & Start Multiplication = 0 ($4203)
  stz.w REG_WRDIVL // Set Unsigned 16-Bit Dividend (Lower 8-Bit) = 0 ($4204)
  stz.w REG_WRDIVH // Set Unsigned 16-Bit Dividend (Upper 8-Bit) = 0 ($4205)
  stz.w REG_WRDIVB // Set Unsigned  8-Bit Divisor & Start Division = 0 ($4206)
  stz.w REG_HTIMEL // H-Count Timer Setting (Lower 8-Bit) = 0 ($4207)
  stz.w REG_HTIMEH // H-Count Timer Setting (Upper 1-Bit) = 0 ($4208)
  stz.w REG_VTIMEL // V-Count Timer Setting (Lower 8-Bit) = 0 ($4209)
  stz.w REG_VTIMEH // V-Count Timer Setting (Upper 1-Bit) = 0 ($420A)
  stz.w REG_MDMAEN // Select General Purpose DMA Channels & Start Transfer = 0 ($420B)
  stz.w REG_HDMAEN // Select H-Blank DMA (H-DMA) Channels = 0 ($420C)

  // Clear OAM
  ldx.w #$0080
  lda.b #$E0
  -
    sta.w REG_OAMDATA // OAM Data Write 1st Write = $E0 (Lower 8-Bit) ($2104)
    sta.w REG_OAMDATA // OAM Data Write 2nd Write = $E0 (Upper 8-Bit) ($2104)
    stz.w REG_OAMDATA // OAM Data Write 1st Write = 0 (Lower 8-Bit) ($2104)
    stz.w REG_OAMDATA // OAM Data Write 2nd Write = 0 (Upper 8-Bit) ($2104)
    dex
    bne -

  ldx.w #$0020
  -
    stz.w REG_OAMDATA // OAM Data Write 1st/2nd Write = 0 (Lower/Upper 8-Bit) ($2104)
    dex
    bne -

  // Clear WRAM
  ldy.w #$0000
  sty.w REG_WMADDL // WRAM Address (Lower  8-Bit): Transfer To $7E:0000 ($2181)
  stz.w REG_WMADDH // WRAM Address (Upper  1-Bit): Select 1st WRAM Bank = $7E ($2183)

  ldx.w #$8008    // Fixed Source Byte Write To REG_WMDATA: WRAM Data Read/Write ($2180)
  stx.w REG_DMAP0 // DMA0 DMA/HDMA Parameters ($4300)

Loop:
  jmp Loop