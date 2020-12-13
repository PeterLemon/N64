// PI Timings - based on Bare Metal SDK from PeterLemeon
arch n64.cpu
endian msb
output "PITimings.N64", create
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


macro MeasurePIDMA(result, length) {
  WaitScanline(0) // It stabilizes the measurements !
  DMA($00,$00+{length}, DMA_BUF)
  mfc0 t1, 9
  -
    lw t0, PI_STATUS(a0)
    mfc0 t2, 9
    andi t0, 3
    bnez t0,-
    nop
  sub t0, t2, t1
  la a0, {result}
  sw t0, 0(a0)
}

macro SetupPiDom1(lat, pwd, rls, pgs) {
  lui a0,PI_BASE
  li t1, {lat}
  sw  t1, PI_BSD_DOM1_LAT(a0)
  li t1, {pwd}
  sw  t1, PI_BSD_DOM1_PWD(a0)
  li t1, {rls}
  sw  t1, PI_BSD_DOM1_RLS(a0)
  li t1, {pgs}
  sw  t1, PI_BSD_DOM1_PGS(a0)
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
  PrintString(SCREEN_BUF,8,8,FontRed,PITIMINGS,10)
  PrintString(SCREEN_BUF,192,8,FontGreen,RESULT,6)
  PrintString(SCREEN_BUF,0,16,FontBlack,PAGEBREAK,39)


  // Polling calibration
  PrintString(SCREEN_BUF,8,32,FontBlack,CALIB,13)

  // Length = 1, ROM speed
  la a0, RLENGTH
  li a1, 1
  sw a1, 0(a0)
  PrintString(SCREEN_BUF,8,40,FontBlack,DOLLAR,0)
  PrintValue(SCREEN_BUF,16,40,FontBlack,RLENGTH,3)

  // Length = 8, ROM speed
  la a0, RLENGTH
  li a1, 8
  sw a1, 0(a0)
  PrintString(SCREEN_BUF,8,48,FontBlack,DOLLAR,0)
  PrintValue(SCREEN_BUF,16,48,FontBlack,RLENGTH,3)

  // Length = 16, ROM speed
  la a0, RLENGTH
  li a1, 16
  sw a1, 0(a0)
  PrintString(SCREEN_BUF,8,56,FontBlack,DOLLAR,0)
  PrintValue(SCREEN_BUF,16,56,FontBlack,RLENGTH,3)

  // Length = 32, ROM speed
  la a0, RLENGTH
  li a1, 32
  sw a1, 0(a0)
  PrintString(SCREEN_BUF,8,64,FontBlack,DOLLAR,0)
  PrintValue(SCREEN_BUF,16,64,FontBlack,RLENGTH,3)

  // Length = 127, ROM speed
  la a0, RLENGTH
  li a1, 127
  sw a1, 0(a0)
  PrintString(SCREEN_BUF,8,72,FontBlack,DOLLAR,0)
  PrintValue(SCREEN_BUF,16,72,FontBlack,RLENGTH,3)

  // Length = 128, ROM speed
  la a0, RLENGTH
  li a1, 128
  sw a1, 0(a0)
  PrintString(SCREEN_BUF,8,80,FontBlack,DOLLAR,0)
  PrintValue(SCREEN_BUF,16,80,FontBlack,RLENGTH,3)

  // Length = 129, ROM speed
  la a0, RLENGTH
  li a1, 129
  sw a1, 0(a0)
  PrintString(SCREEN_BUF,8,88,FontBlack,DOLLAR,0)
  PrintValue(SCREEN_BUF,16,88,FontBlack,RLENGTH,3)

  // length = 256, ROM speed
  la a0, RLENGTH
  li a1, 256
  sw a1, 0(a0)
  PrintString(SCREEN_BUF,8,96,FontBlack,DOLLAR,0)
  PrintValue(SCREEN_BUF,16,96,FontBlack,RLENGTH,3)

  // length = 512, ROM speed
  la a0, RLENGTH
  li a1, 512
  sw a1, 0(a0)
  PrintString(SCREEN_BUF,8,104,FontBlack,DOLLAR,0)
  PrintValue(SCREEN_BUF,16,104,FontBlack,RLENGTH,3)

  // length = 1024, ROM speed
  la a0, RLENGTH
  li a1, 1024
  sw a1, 0(a0)
  PrintString(SCREEN_BUF,8,112,FontBlack,DOLLAR,0)
  PrintValue(SCREEN_BUF,16,112,FontBlack,RLENGTH,3)

  // length = 4032, ROM speed
  la a0, RLENGTH
  li a1, 4032
  sw a1, 0(a0)
  PrintString(SCREEN_BUF,8,120,FontBlack,DOLLAR,0)
  PrintValue(SCREEN_BUF,16,120,FontBlack,RLENGTH,3)

  // length = 4096, ROM speed
  la a0, RLENGTH
  li a1, 4096
  sw a1, 0(a0)
  PrintString(SCREEN_BUF,8,128,FontBlack,DOLLAR,0)
  PrintValue(SCREEN_BUF,16,128,FontBlack,RLENGTH,3)

  // length = 8192, ROM speed
  la a0, RLENGTH
  li a1, 8192
  sw a1, 0(a0)
  PrintString(SCREEN_BUF,8,136,FontBlack,DOLLAR,0)
  PrintValue(SCREEN_BUF,16,136,FontBlack,RLENGTH,3)

  // length = 32, slow speed
  la a0, RLENGTH
  li a1, 32
  sw a1, 0(a0)
  PrintString(SCREEN_BUF,8,152,FontBlack,DOLLAR,0)
  PrintValue(SCREEN_BUF,16,152,FontBlack,RLENGTH,3)

  // length = 1024, slow speed
  la a0, RLENGTH
  li a1, 1024
  sw a1, 0(a0)
  PrintString(SCREEN_BUF,8,160,FontBlack,DOLLAR,0)
  PrintValue(SCREEN_BUF,16,160,FontBlack,RLENGTH,3)

  // length = 8192, slow speed
  la a0, RLENGTH
  li a1, 8192
  sw a1, 0(a0)
  PrintString(SCREEN_BUF,8,168,FontBlack,DOLLAR,0)
  PrintValue(SCREEN_BUF,16,168,FontBlack,RLENGTH,3)


  // length = 32, test speed
  la a0, RLENGTH
  li a1, 32
  sw a1, 0(a0)
  PrintString(SCREEN_BUF,8,184,FontBlack,DOLLAR,0)
  PrintValue(SCREEN_BUF,16,184,FontBlack,RLENGTH,3)

  // length = 1024, test speed
  la a0, RLENGTH
  li a1, 1024
  sw a1, 0(a0)
  PrintString(SCREEN_BUF,8,194,FontBlack,DOLLAR,0)
  PrintValue(SCREEN_BUF,16,194,FontBlack,RLENGTH,3)

  // length = 8192, test speed
  la a0, RLENGTH
  li a1, 8192
  sw a1, 0(a0)
  PrintString(SCREEN_BUF,8,204,FontBlack,DOLLAR,0)
  PrintValue(SCREEN_BUF,16,204,FontBlack,RLENGTH,3)

  // length = 1M, ROM speed
  la a0, RLENGTH
  li a1, 1024*1024
  sw a1, 0(a0)
  PrintString(SCREEN_BUF,8,220,FontBlack,DOLLAR,0)
  PrintValue(SCREEN_BUF,16,220,FontBlack,RLENGTH,3)


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
  lui a0, PI_BASE
  mfc0 t1, 9
dma_busy:
    lw t0, PI_STATUS(a0)
    mfc0 t2, 9
    andi t0, 3
    bnez r0, dma_busy // no jump because zero
    nop
  sub t0, t2, t1
  la a0, TIME_POLL
  sw t0, 0(a0)

  // Setup default ROM timings
  SetupPiDom1($40, $12, $03, $07)

  MeasurePIDMA(TIME_0, 1)
  MeasurePIDMA(TIME_1, 8)
  MeasurePIDMA(TIME_2, 16)
  MeasurePIDMA(TIME_3, 32)
  MeasurePIDMA(TIME_4, 127)
  MeasurePIDMA(TIME_5, 128)
  MeasurePIDMA(TIME_6, 129)
  MeasurePIDMA(TIME_7, 256)
  MeasurePIDMA(TIME_8, 512)
  MeasurePIDMA(TIME_9, 1024)
  MeasurePIDMA(TIME_10, 4032)
  MeasurePIDMA(TIME_11, 4096)
  MeasurePIDMA(TIME_12, 8192)
  MeasurePIDMA(TIME_19, 1024*1024)

  // Setup new speed values (simulate slow device)
  SetupPiDom1($FF, $FF, $03, $0F)

  MeasurePIDMA(TIME_13, 32)
  MeasurePIDMA(TIME_14, 1024)
  MeasurePIDMA(TIME_15, 8192)

  // Setup new speed values
  SetupPiDom1($03, $06, $02, $06)

  MeasurePIDMA(TIME_16, 32)
  MeasurePIDMA(TIME_17, 1024)
  MeasurePIDMA(TIME_18, 8192)

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

  PrintString(SCREEN_BUF,192,64,FontGreen,DOLLAR,0)
  PrintValue(SCREEN_BUF,200,64,FontGreen,TIME_3,3)

  PrintString(SCREEN_BUF,192,72,FontGreen,DOLLAR,0)
  PrintValue(SCREEN_BUF,200,72,FontGreen,TIME_4,3)

  PrintString(SCREEN_BUF,192,80,FontGreen,DOLLAR,0)
  PrintValue(SCREEN_BUF,200,80,FontGreen,TIME_5,3)

  PrintString(SCREEN_BUF,192,88,FontGreen,DOLLAR,0)
  PrintValue(SCREEN_BUF,200,88,FontGreen,TIME_6,3)

  PrintString(SCREEN_BUF,192,96,FontGreen,DOLLAR,0)
  PrintValue(SCREEN_BUF,200,96,FontGreen,TIME_7,3)

  PrintString(SCREEN_BUF,192,104,FontGreen,DOLLAR,0)
  PrintValue(SCREEN_BUF,200,104,FontGreen,TIME_8,3)

  PrintString(SCREEN_BUF,192,112,FontGreen,DOLLAR,0)
  PrintValue(SCREEN_BUF,200,112,FontGreen,TIME_9,3)

  PrintString(SCREEN_BUF,192,120,FontGreen,DOLLAR,0)
  PrintValue(SCREEN_BUF,200,120,FontGreen,TIME_10,3)

  PrintString(SCREEN_BUF,192,128,FontGreen,DOLLAR,0)
  PrintValue(SCREEN_BUF,200,128,FontGreen,TIME_11,3)

  PrintString(SCREEN_BUF,192,136,FontGreen,DOLLAR,0)
  PrintValue(SCREEN_BUF,200,136,FontGreen,TIME_12,3)

  PrintString(SCREEN_BUF,192,152,FontGreen,DOLLAR,0)
  PrintValue(SCREEN_BUF,200,152,FontGreen,TIME_13,3)

  PrintString(SCREEN_BUF,192,160,FontGreen,DOLLAR,0)
  PrintValue(SCREEN_BUF,200,160,FontGreen,TIME_14,3)

  PrintString(SCREEN_BUF,192,168,FontGreen,DOLLAR,0)
  PrintValue(SCREEN_BUF,200,168,FontGreen,TIME_15,3)

  PrintString(SCREEN_BUF,192,184,FontGreen,DOLLAR,0)
  PrintValue(SCREEN_BUF,200,184,FontGreen,TIME_16,3)

  PrintString(SCREEN_BUF,192,194,FontGreen,DOLLAR,0)
  PrintValue(SCREEN_BUF,200,194,FontGreen,TIME_17,3)

  PrintString(SCREEN_BUF,192,204,FontGreen,DOLLAR,0)
  PrintValue(SCREEN_BUF,200,204,FontGreen,TIME_18,3)

  PrintString(SCREEN_BUF,192,220,FontGreen,DOLLAR,0)
  PrintValue(SCREEN_BUF,200,220,FontGreen,TIME_19,3)

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


PITIMINGS:
  db "PI Timings:"

RESULT:
  db "Result:"

DOLLAR:
  db "$"

PAGEBREAK:
  db "--------------------------------------------------------------------------------"

CALIB:
  db "DMA busy poll:"

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
TIME_12:
  dw 0
TIME_13:
  dw 0
TIME_14:
  dw 0
TIME_15:
  dw 0
TIME_16:
  dw 0
TIME_17:
  dw 0
TIME_18:
  dw 0
TIME_19:
  dw 0

insert FontBlack, "FontBlack8x8.bin"
insert FontGreen, "FontGreen8x8.bin"
insert FontRed, "FontRed8x8.bin"

align(16)
DMA_BUF:
  db 0
align(1024*1024)
