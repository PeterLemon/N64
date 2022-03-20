// SI Timings - based on Bare Metal SDK from PeterLemeon
arch n64.cpu
endian msb
output "SITimings.N64", create
fill 1052672 // Set ROM Size

// Setup Frame Buffer
constant SCREEN_X(320)
constant SCREEN_Y(240)
constant BYTES_PER_PIXEL(4)

// Setup Characters
constant CHAR_X(8)
constant CHAR_Y(8)

constant SCREEN_BUF($A0300000)

origin $00000000
base $80000000 // Entry Point Of Code
include "LIB/N64.INC" // Include N64 Definitions
include "LIB/N64_HEADER.ASM" // Include 64 Byte Header & Vector Table
insert "LIB/N64_BOOTCODE.BIN" // Include 4032 Byte Boot Code

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


macro WaitSIStatus(poll_mask) {
  lui a0, SI_BASE
  -
    lw t0, SI_STATUS(a0)
    andi t0, {poll_mask}
    bnez t0,-
    nop // delay slot
}

macro MeasureSIDMA(result, reg, poll_mask) {

  WaitSIStatus(3)
  WaitScanline(0) // It stabilizes the measurements !

  lui a0, SI_BASE

  // Setup SI DMA
  la t0, DMA_BUF
  sw t0, SI_DRAM_ADDR(a0)
  li t0, $1fc007c0
  sw t0, {reg}(a0)

  // Wait for completion
  mfc0 t1, 9
  -
    lw t0, SI_STATUS(a0)
    mfc0 t2, 9
    andi t0, {poll_mask}
    bnez t0,-
    nop // delay slot

  // Store result
  sub t0, t2, t1
  la a0, {result}
  sw t0, 0(a0)
}

macro MeasureSIIO(result, write, poll_mask) {

  // Make sure there is no SI activity
  WaitSIStatus(3)

  lui a0, PIF_BASE

  // Do IO
  if {write} != 0 {
    sw r0, PIF_RAM(a0)
  } else {
    lw t0, PIF_RAM(a0)
  }

  // Wait for completion
  mfc0 t1, 9
  -
    lw t0, SI_STATUS(a0)
    mfc0 t2, 9
    andi t0, {poll_mask}
    bnez t0,-
    nop // delay slot

  // Store result
  sub t0, t2, t1
  la a0, {result}
  sw t0, 0(a0)
}


Start:
  include "LIB/N64_GFX.INC" // Include Graphics Macros
  N64_INIT() // Run N64 Initialisation Routine

  // Clear screen_buf
  la a0, SCREEN_BUF
  li a1, 320*240*4
  add a1, a0, a1
  addi a0, 8
clear_loop:
  sd r0, -8(a0)
  blt a0, a1, clear_loop
  addi a0, 8

  ScreenPAL(320, 240, BPP32|AA_MODE_2, SCREEN_BUF)


  // Print static part of the screen
  PrintString(SCREEN_BUF,8,8,FontRed,SITIMINGS,10)
  PrintString(SCREEN_BUF,192,8,FontGreen,RESULT,6)
  PrintString(SCREEN_BUF,0,16,FontBlack,PAGEBREAK,39)


  // Polling calibration
  PrintString(SCREEN_BUF,8,32,FontBlack,TEXT_TP,13)

  PrintString(SCREEN_BUF,8,40,FontBlack,TEXT_T0,17)
  PrintString(SCREEN_BUF,8,48,FontBlack,TEXT_T1,17)
  PrintString(SCREEN_BUF,8,56,FontBlack,TEXT_T2,17)

  PrintString(SCREEN_BUF,8,72,FontBlack,TEXT_T3,17)
  PrintString(SCREEN_BUF,8,80,FontBlack,TEXT_T4,17)
  PrintString(SCREEN_BUF,8,88,FontBlack,TEXT_T5,17)

  PrintString(SCREEN_BUF,8,104,FontBlack,TEXT_T6,17)
  PrintString(SCREEN_BUF,8,112,FontBlack,TEXT_T7,17)
  PrintString(SCREEN_BUF,8,120,FontBlack,TEXT_T8,17)

  PrintString(SCREEN_BUF,8,136,FontBlack,TEXT_T9,17)
  PrintString(SCREEN_BUF,8,144,FontBlack,TEXT_T10,17)
  PrintString(SCREEN_BUF,8,152,FontBlack,TEXT_T11,17)

Loop:
  // Only do the measurements when DCOUNTER is zero
  la a0, DCOUNTER
  lw t1, 0(a0)
  bne t1, r0, display_timings
  nop

  // Disable VI when doing measurements
  //lui a0, VI_BASE
  //sw  r0, VI_STATUS(a0)

  WaitScanline(0) // It stabilizes the measurements !
  // Calibration: measure dma_busy polling duration
  lui a0, SI_BASE
  mfc0 t1, 9
  -
    lw t0, SI_STATUS(a0)
    mfc0 t2, 9
    andi t0, 3
    bnez r0,- // no jump because zero
    nop
  sub t0, t2, t1
  la a0, TIME_POLL
  sw t0, 0(a0)

  MeasureSIDMA(TIME_3, SI_PIF_ADDR_RD64B, 1)
  MeasureSIDMA(TIME_4, SI_PIF_ADDR_RD64B, 2)
  MeasureSIDMA(TIME_5, SI_PIF_ADDR_RD64B, 3)

  MeasureSIDMA(TIME_0, SI_PIF_ADDR_WR64B, 1)
  MeasureSIDMA(TIME_1, SI_PIF_ADDR_WR64B, 2)
  MeasureSIDMA(TIME_2, SI_PIF_ADDR_WR64B, 3)

  MeasureSIIO(TIME_6, 0, 1)
  MeasureSIIO(TIME_7, 0, 2)
  MeasureSIIO(TIME_8, 0, 3)

  MeasureSIIO(TIME_9, 1, 1)
  MeasureSIIO(TIME_10,1, 2)
  MeasureSIIO(TIME_11,1, 3)


  // TODO: IO

  // Reenable VI
  //lui a0, VI_BASE
  //li  t0, BPP32|AA_MODE_2
  //sw  t0, VI_STATUS(a0)

display_timings:
  // Print timings
  PrintString(SCREEN_BUF,192,32,FontGreen,DOLLAR,0)
  PrintValue(SCREEN_BUF,200,32,FontGreen,TIME_POLL,3)

  PrintString(SCREEN_BUF,192,40,FontGreen,DOLLAR,0)
  PrintValue(SCREEN_BUF,200,40,FontGreen,TIME_0,3)

  PrintString(SCREEN_BUF,192,48,FontGreen,DOLLAR,0)
  PrintValue(SCREEN_BUF,200,48,FontGreen,TIME_1,3)

  PrintString(SCREEN_BUF,192,56,FontGreen,DOLLAR,0)
  PrintValue(SCREEN_BUF,200,56,FontGreen,TIME_2,3)

  PrintString(SCREEN_BUF,192,72,FontGreen,DOLLAR,0)
  PrintValue(SCREEN_BUF,200,72,FontGreen,TIME_3,3)

  PrintString(SCREEN_BUF,192,80,FontGreen,DOLLAR,0)
  PrintValue(SCREEN_BUF,200,80,FontGreen,TIME_4,3)

  PrintString(SCREEN_BUF,192,88,FontGreen,DOLLAR,0)
  PrintValue(SCREEN_BUF,200,88,FontGreen,TIME_5,3)

  PrintString(SCREEN_BUF,192,104,FontGreen,DOLLAR,0)
  PrintValue(SCREEN_BUF,200,104,FontGreen,TIME_6,3)

  PrintString(SCREEN_BUF,192,112,FontGreen,DOLLAR,0)
  PrintValue(SCREEN_BUF,200,112,FontGreen,TIME_7,3)

  PrintString(SCREEN_BUF,192,120,FontGreen,DOLLAR,0)
  PrintValue(SCREEN_BUF,200,120,FontGreen,TIME_8,3)

  PrintString(SCREEN_BUF,192,136,FontGreen,DOLLAR,0)
  PrintValue(SCREEN_BUF,200,136,FontGreen,TIME_9,3)

  PrintString(SCREEN_BUF,192,144,FontGreen,DOLLAR,0)
  PrintValue(SCREEN_BUF,200,144,FontGreen,TIME_10,3)

  PrintString(SCREEN_BUF,192,152,FontGreen,DOLLAR,0)
  PrintValue(SCREEN_BUF,200,152,FontGreen,TIME_11,3)

  PrintValue(SCREEN_BUF,0,0,FontBlack,DCOUNTER,3)

  // increment DCOUNTER
  la a0, DCOUNTER
  lw t0, 0(a0)
  addi t0, 1
  li t1, 300
  blt t0, t1, save_dcounter
  nop
  ori t0, r0, r0
save_dcounter:
  sw t0, 0(a0)

  j Loop
  nop


SITIMINGS:
  db "SI Timings:"

RESULT:
  db "Result:"

DOLLAR:
  db "$"

PAGEBREAK:
  db "--------------------------------------------------------------------------------"

TEXT_TP:
  db "Poll ref time:"

//   "123456789012345678"
TEXT_T0:
  db "RD64B BUSY: DMA   "
TEXT_T1:
  db "RD64B BUSY:     IO"
TEXT_T2:
  db "RD64B BUSY: DMA+IO"
TEXT_T3:
  db "WR64B BUSY: DMA   "
TEXT_T4:
  db "WR64B BUSY:     IO"
TEXT_T5:
  db "WR64B BUSY: DMA+IO"
TEXT_T6:
  db "RD 4B BUSY: DMA   "
TEXT_T7:
  db "RD 4B BUSY:     IO"
TEXT_T8:
  db "RD 4B BUSY: DMA+IO"
TEXT_T9:
  db "WR 4B BUSY: DMA   "
TEXT_T10:
  db "WR 4B BUSY:     IO"
TEXT_T11:
  db "WR 4B BUSY: DMA+IO"


align(4) // Align 32-Bit
DCOUNTER:
  dw 0
RLENGTH:
  dw 0
TIME_POLL:
  dw 0
TIME_0:
  dw 0
TIME_1:
  dw 0
TIME_2:
  dw 0
TIME_3:
  dw 0
TIME_4:
  dw 0
TIME_5:
  dw 0
TIME_6:
  dw 0
TIME_7:
  dw 0
TIME_8:
  dw 0
TIME_9:
  dw 0
TIME_10:
  dw 0
TIME_11:
  dw 0

insert FontBlack, "FontBlack8x8.bin"
insert FontGreen, "FontGreen8x8.bin"
insert FontRed, "FontRed8x8.bin"

align(16)
DMA_BUF:
  db 0
align(1024*1024)
