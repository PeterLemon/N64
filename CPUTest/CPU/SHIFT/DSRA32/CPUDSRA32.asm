// N64 'Bare Metal' CPU Doubleword Shift Right Arithmetic + 32 (32..63) Test Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "CPUDSRA32.N64", create
fill 1052672 // Set ROM Size

// Setup Frame Buffer
constant SCREEN_X(640)
constant SCREEN_Y(480)
constant BYTES_PER_PIXEL(4)

// Setup Characters
constant CHAR_X(8)
constant CHAR_Y(8)

origin $00000000
base $80000000 // Entry Point Of Code
include "LIB/N64.INC" // Include N64 Definitions
include "LIB/N64_HEADER.ASM" // Include 64 Byte Header & Vector Table
insert "LIB/N64_BOOTCODE.BIN" // Include 4032 Byte Boot Code

macro PrintString(vram, xpos, ypos, fontfile, string, length) { // Print Text String To VRAM Using Font At X,Y Position
  li a0,{vram}+({xpos}*BYTES_PER_PIXEL)+(SCREEN_X*BYTES_PER_PIXEL*{ypos}) // A0 = Frame Buffer Pointer (Place text at XY Position)
  la a1,{fontfile} // A1 = Characters
  la a2,{string} // A2 = Text Offset
  lli t0,{length} // T0 = Number of Text Characters to Print
  {#}DrawChars:
    lli t1,CHAR_X-1 // T1 = Character X Pixel Counter
    lli t2,CHAR_Y-1 // T2 = Character Y Pixel Counter

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
      lli t1,CHAR_X-1 // Reset Character X Pixel Counter
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
    lli t1,CHAR_X-1 // T1 = Character X Pixel Counter
    lli t2,CHAR_Y-1 // T2 = Character Y Pixel Counter

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
      lli t1,CHAR_X-1 // Reset Character X Pixel Counter
      bnez t2,{#}DrawHEXCharX // IF (Character Y Pixel Counter != 0) DrawCharX
      subi t2,1 // Decrement Character Y Pixel Counter

    subi a0,((SCREEN_X*BYTES_PER_PIXEL)*CHAR_Y)-CHAR_X*BYTES_PER_PIXEL // Jump To Start Of Next Char

    lli t2,CHAR_Y-1 // Reset Character Y Pixel Counter

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
      lli t1,CHAR_X-1 // Reset Character X Pixel Counter
      bnez t2,{#}DrawHEXCharXB // IF (Character Y Pixel Counter != 0) DrawCharX
      subi t2,1 // Decrement Character Y Pixel Counter

    subi a0,((SCREEN_X*BYTES_PER_PIXEL)*CHAR_Y)-CHAR_X*BYTES_PER_PIXEL // Jump To Start Of Next Char

    bnez t0,{#}DrawHEXChars // Continue to Print Characters
    subi t0,1 // Subtract Number of Text Characters to Print
}

Start:
  include "LIB/N64_GFX.INC" // Include Graphics Macros
  N64_INIT() // Run N64 Initialisation Routine

  ScreenNTSC(640, 480, BPP32|INTERLACE|AA_MODE_2, $A0100000) // Screen NTSC: 640x480, 32BPP, Interlace, Resample Only, DRAM Origin = $A0100000

  lui a0,$A010 // A0 = VRAM Start Offset
  la a1,$A0100000+((SCREEN_X*SCREEN_Y*BYTES_PER_PIXEL)-BYTES_PER_PIXEL) // A1 = VRAM End Offset
  lli t0,$000000FF // T0 = Black
ClearScreen:
  sw t0,0(a0)
  bne a0,a1,ClearScreen
  addi a0,4 // Delay Slot


  PrintString($A0100000,88,8,FontRed,RTHEX,7) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,8,FontRed,SA32DEC,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,384,8,FontRed,RDHEX,7) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,528,8,FontRed,TEST,10) // Print Text String To VRAM Using Font At X,Y Position


  PrintString($A0100000,0,16,FontBlack,PAGEBREAK,79) // Print Text String To VRAM Using Font At X,Y Position


  PrintString($A0100000,8,24,FontRed,DSRA32,5) // Print Text String To VRAM Using Font At X,Y Position
  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsra32 t0,0 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,24,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,24,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,24,FontBlack,TEXTLONG0,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,24,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,24,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       // A0 = Long Data Offset
  ld t0,0(a0)        // T0 = Long Data
  la a0,DSRA32CHECK0 // A0 = Long Check Data Offset
  ld t1,0(a0)        // T1 = Long Check Data
  beq t0,t1,DSRA32PASS0 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,24,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRA32END0
  nop // Delay Slot
  DSRA32PASS0:
  PrintString($A0100000,528,24,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRA32END0:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsra32 t0,1 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,32,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,32,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,32,FontBlack,TEXTLONG1,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,32,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,32,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       // A0 = Long Data Offset
  ld t0,0(a0)        // T0 = Long Data
  la a0,DSRA32CHECK1 // A0 = Long Check Data Offset
  ld t1,0(a0)        // T1 = Long Check Data
  beq t0,t1,DSRA32PASS1 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,32,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRA32END1
  nop // Delay Slot
  DSRA32PASS1:
  PrintString($A0100000,528,32,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRA32END1:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsra32 t0,2 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,40,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,40,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,40,FontBlack,TEXTLONG2,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,40,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,40,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       // A0 = Long Data Offset
  ld t0,0(a0)        // T0 = Long Data
  la a0,DSRA32CHECK2 // A0 = Long Check Data Offset
  ld t1,0(a0)        // T1 = Long Check Data
  beq t0,t1,DSRA32PASS2 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,40,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRA32END2
  nop // Delay Slot
  DSRA32PASS2:
  PrintString($A0100000,528,40,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRA32END2:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsra32 t0,3 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,48,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,48,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,48,FontBlack,TEXTLONG3,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,48,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,48,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       // A0 = Long Data Offset
  ld t0,0(a0)        // T0 = Long Data
  la a0,DSRA32CHECK3 // A0 = Long Check Data Offset
  ld t1,0(a0)        // T1 = Long Check Data
  beq t0,t1,DSRA32PASS3 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,48,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRA32END3
  nop // Delay Slot
  DSRA32PASS3:
  PrintString($A0100000,528,48,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRA32END3:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsra32 t0,4 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,56,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,56,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,56,FontBlack,TEXTLONG4,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,56,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,56,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       // A0 = Long Data Offset
  ld t0,0(a0)        // T0 = Long Data
  la a0,DSRA32CHECK4 // A0 = Long Check Data Offset
  ld t1,0(a0)        // T1 = Long Check Data
  beq t0,t1,DSRA32PASS4 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,56,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRA32END4
  nop // Delay Slot
  DSRA32PASS4:
  PrintString($A0100000,528,56,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRA32END4:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsra32 t0,5 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,64,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,64,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,64,FontBlack,TEXTLONG5,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,64,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,64,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       // A0 = Long Data Offset
  ld t0,0(a0)        // T0 = Long Data
  la a0,DSRA32CHECK5 // A0 = Long Check Data Offset
  ld t1,0(a0)        // T1 = Long Check Data
  beq t0,t1,DSRA32PASS5 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,64,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRA32END5
  nop // Delay Slot
  DSRA32PASS5:
  PrintString($A0100000,528,64,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRA32END5:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsra32 t0,6 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,72,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,72,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,72,FontBlack,TEXTLONG6,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,72,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,72,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       // A0 = Long Data Offset
  ld t0,0(a0)        // T0 = Long Data
  la a0,DSRA32CHECK6 // A0 = Long Check Data Offset
  ld t1,0(a0)        // T1 = Long Check Data
  beq t0,t1,DSRA32PASS6 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,72,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRA32END6
  nop // Delay Slot
  DSRA32PASS6:
  PrintString($A0100000,528,72,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRA32END6:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsra32 t0,7 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,80,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,80,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,80,FontBlack,TEXTLONG7,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,80,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,80,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       // A0 = Long Data Offset
  ld t0,0(a0)        // T0 = Long Data
  la a0,DSRA32CHECK7 // A0 = Long Check Data Offset
  ld t1,0(a0)        // T1 = Long Check Data
  beq t0,t1,DSRA32PASS7 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,80,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRA32END7
  nop // Delay Slot
  DSRA32PASS7:
  PrintString($A0100000,528,80,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRA32END7:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsra32 t0,8 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,88,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,88,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,88,FontBlack,TEXTLONG8,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,88,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,88,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       // A0 = Long Data Offset
  ld t0,0(a0)        // T0 = Long Data
  la a0,DSRA32CHECK8 // A0 = Long Check Data Offset
  ld t1,0(a0)        // T1 = Long Check Data
  beq t0,t1,DSRA32PASS8 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,88,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRA32END8
  nop // Delay Slot
  DSRA32PASS8:
  PrintString($A0100000,528,88,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRA32END8:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsra32 t0,9 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,96,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,96,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,96,FontBlack,TEXTLONG9,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,96,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,96,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       // A0 = Long Data Offset
  ld t0,0(a0)        // T0 = Long Data
  la a0,DSRA32CHECK9 // A0 = Long Check Data Offset
  ld t1,0(a0)        // T1 = Long Check Data
  beq t0,t1,DSRA32PASS9 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,96,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRA32END9
  nop // Delay Slot
  DSRA32PASS9:
  PrintString($A0100000,528,96,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRA32END9:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsra32 t0,10 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,104,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,104,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,104,FontBlack,TEXTLONG10,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,104,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,104,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG        // A0 = Long Data Offset
  ld t0,0(a0)         // T0 = Long Data
  la a0,DSRA32CHECK10 // A0 = Long Check Data Offset
  ld t1,0(a0)         // T1 = Long Check Data
  beq t0,t1,DSRA32PASS10 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,104,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRA32END10
  nop // Delay Slot
  DSRA32PASS10:
  PrintString($A0100000,528,104,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRA32END10:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsra32 t0,11 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,112,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,112,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,112,FontBlack,TEXTLONG11,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,112,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,112,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG        // A0 = Long Data Offset
  ld t0,0(a0)         // T0 = Long Data
  la a0,DSRA32CHECK11 // A0 = Long Check Data Offset
  ld t1,0(a0)         // T1 = Long Check Data
  beq t0,t1,DSRA32PASS11 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,112,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRA32END11
  nop // Delay Slot
  DSRA32PASS11:
  PrintString($A0100000,528,112,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRA32END11:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsra32 t0,12 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,120,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,120,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,120,FontBlack,TEXTLONG12,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,120,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,120,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG        // A0 = Long Data Offset
  ld t0,0(a0)         // T0 = Long Data
  la a0,DSRA32CHECK12 // A0 = Long Check Data Offset
  ld t1,0(a0)         // T1 = Long Check Data
  beq t0,t1,DSRA32PASS12 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,120,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRA32END12
  nop // Delay Slot
  DSRA32PASS12:
  PrintString($A0100000,528,120,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRA32END12:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsra32 t0,13 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,128,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,128,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,128,FontBlack,TEXTLONG13,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,128,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,128,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG        // A0 = Long Data Offset
  ld t0,0(a0)         // T0 = Long Data
  la a0,DSRA32CHECK13 // A0 = Long Check Data Offset
  ld t1,0(a0)         // T1 = Long Check Data
  beq t0,t1,DSRA32PASS13 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,128,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRA32END13
  nop // Delay Slot
  DSRA32PASS13:
  PrintString($A0100000,528,128,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRA32END13:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsra32 t0,14 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,136,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,136,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,136,FontBlack,TEXTLONG14,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,136,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,136,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG        // A0 = Long Data Offset
  ld t0,0(a0)         // T0 = Long Data
  la a0,DSRA32CHECK14 // A0 = Long Check Data Offset
  ld t1,0(a0)         // T1 = Long Check Data
  beq t0,t1,DSRA32PASS14 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,136,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRA32END14
  nop // Delay Slot
  DSRA32PASS14:
  PrintString($A0100000,528,136,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRA32END14:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsra32 t0,15 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,144,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,144,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,144,FontBlack,TEXTLONG15,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,144,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,144,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG        // A0 = Long Data Offset
  ld t0,0(a0)         // T0 = Long Data
  la a0,DSRA32CHECK15 // A0 = Long Check Data Offset
  ld t1,0(a0)         // T1 = Long Check Data
  beq t0,t1,DSRA32PASS15 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,144,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRA32END15
  nop // Delay Slot
  DSRA32PASS15:
  PrintString($A0100000,528,144,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRA32END15:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsra32 t0,16 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,152,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,152,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,152,FontBlack,TEXTLONG16,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,152,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,152,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG        // A0 = Long Data Offset
  ld t0,0(a0)         // T0 = Long Data
  la a0,DSRA32CHECK16 // A0 = Long Check Data Offset
  ld t1,0(a0)         // T1 = Long Check Data
  beq t0,t1,DSRA32PASS16 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,152,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRA32END16
  nop // Delay Slot
  DSRA32PASS16:
  PrintString($A0100000,528,152,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRA32END16:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsra32 t0,17 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,160,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,160,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,160,FontBlack,TEXTLONG17,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,160,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,160,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG        // A0 = Long Data Offset
  ld t0,0(a0)         // T0 = Long Data
  la a0,DSRA32CHECK17 // A0 = Long Check Data Offset
  ld t1,0(a0)         // T1 = Long Check Data
  beq t0,t1,DSRA32PASS17 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,160,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRA32END17
  nop // Delay Slot
  DSRA32PASS17:
  PrintString($A0100000,528,160,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRA32END17:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsra32 t0,18 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,168,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,168,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,168,FontBlack,TEXTLONG18,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,168,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,168,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG        // A0 = Long Data Offset
  ld t0,0(a0)         // T0 = Long Data
  la a0,DSRA32CHECK18 // A0 = Long Check Data Offset
  ld t1,0(a0)         // T1 = Long Check Data
  beq t0,t1,DSRA32PASS18 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,168,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRA32END18
  nop // Delay Slot
  DSRA32PASS18:
  PrintString($A0100000,528,168,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRA32END18:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsra32 t0,19 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,176,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,176,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,176,FontBlack,TEXTLONG19,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,176,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,176,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG        // A0 = Long Data Offset
  ld t0,0(a0)         // T0 = Long Data
  la a0,DSRA32CHECK19 // A0 = Long Check Data Offset
  ld t1,0(a0)         // T1 = Long Check Data
  beq t0,t1,DSRA32PASS19 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,176,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRA32END19
  nop // Delay Slot
  DSRA32PASS19:
  PrintString($A0100000,528,176,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRA32END19:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsra32 t0,20 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,184,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,184,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,184,FontBlack,TEXTLONG20,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,184,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,184,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG        // A0 = Long Data Offset
  ld t0,0(a0)         // T0 = Long Data
  la a0,DSRA32CHECK20 // A0 = Long Check Data Offset
  ld t1,0(a0)         // T1 = Long Check Data
  beq t0,t1,DSRA32PASS20 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,184,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRA32END20
  nop // Delay Slot
  DSRA32PASS20:
  PrintString($A0100000,528,184,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRA32END20:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsra32 t0,21 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,192,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,192,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,192,FontBlack,TEXTLONG21,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,192,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,192,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG        // A0 = Long Data Offset
  ld t0,0(a0)         // T0 = Long Data
  la a0,DSRA32CHECK21 // A0 = Long Check Data Offset
  ld t1,0(a0)         // T1 = Long Check Data
  beq t0,t1,DSRA32PASS21 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,192,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRA32END21
  nop // Delay Slot
  DSRA32PASS21:
  PrintString($A0100000,528,192,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRA32END21:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsra32 t0,22 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,200,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,200,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,200,FontBlack,TEXTLONG22,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,200,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,200,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG        // A0 = Long Data Offset
  ld t0,0(a0)         // T0 = Long Data
  la a0,DSRA32CHECK22 // A0 = Long Check Data Offset
  ld t1,0(a0)         // T1 = Long Check Data
  beq t0,t1,DSRA32PASS22 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,200,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRA32END22
  nop // Delay Slot
  DSRA32PASS22:
  PrintString($A0100000,528,200,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRA32END22:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsra32 t0,23 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,208,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,208,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,208,FontBlack,TEXTLONG23,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,208,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,208,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG        // A0 = Long Data Offset
  ld t0,0(a0)         // T0 = Long Data
  la a0,DSRA32CHECK23 // A0 = Long Check Data Offset
  ld t1,0(a0)         // T1 = Long Check Data
  beq t0,t1,DSRA32PASS23 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,208,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRA32END23
  nop // Delay Slot
  DSRA32PASS23:
  PrintString($A0100000,528,208,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRA32END23:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsra32 t0,24 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,216,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,216,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,216,FontBlack,TEXTLONG24,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,216,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,216,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG        // A0 = Long Data Offset
  ld t0,0(a0)         // T0 = Long Data
  la a0,DSRA32CHECK24 // A0 = Long Check Data Offset
  ld t1,0(a0)         // T1 = Long Check Data
  beq t0,t1,DSRA32PASS24 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,216,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRA32END24
  nop // Delay Slot
  DSRA32PASS24:
  PrintString($A0100000,528,216,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRA32END24:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsra32 t0,25 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,224,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,224,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,224,FontBlack,TEXTLONG25,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,224,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,224,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG        // A0 = Long Data Offset
  ld t0,0(a0)         // T0 = Long Data
  la a0,DSRA32CHECK25 // A0 = Long Check Data Offset
  ld t1,0(a0)         // T1 = Long Check Data
  beq t0,t1,DSRA32PASS25 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,224,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRA32END25
  nop // Delay Slot
  DSRA32PASS25:
  PrintString($A0100000,528,224,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRA32END25:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsra32 t0,26 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,232,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,232,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,232,FontBlack,TEXTLONG26,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,232,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,232,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG        // A0 = Long Data Offset
  ld t0,0(a0)         // T0 = Long Data
  la a0,DSRA32CHECK26 // A0 = Long Check Data Offset
  ld t1,0(a0)         // T1 = Long Check Data
  beq t0,t1,DSRA32PASS26 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,232,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRA32END26
  nop // Delay Slot
  DSRA32PASS26:
  PrintString($A0100000,528,232,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRA32END26:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsra32 t0,27 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,240,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,240,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,240,FontBlack,TEXTLONG27,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,240,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,240,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG        // A0 = Long Data Offset
  ld t0,0(a0)         // T0 = Long Data
  la a0,DSRA32CHECK27 // A0 = Long Check Data Offset
  ld t1,0(a0)         // T1 = Long Check Data
  beq t0,t1,DSRA32PASS27 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,240,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRA32END27
  nop // Delay Slot
  DSRA32PASS27:
  PrintString($A0100000,528,240,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRA32END27:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsra32 t0,28 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,248,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,248,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,248,FontBlack,TEXTLONG28,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,248,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,248,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG        // A0 = Long Data Offset
  ld t0,0(a0)         // T0 = Long Data
  la a0,DSRA32CHECK28 // A0 = Long Check Data Offset
  ld t1,0(a0)         // T1 = Long Check Data
  beq t0,t1,DSRA32PASS28 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,248,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRA32END28
  nop // Delay Slot
  DSRA32PASS28:
  PrintString($A0100000,528,248,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRA32END28:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsra32 t0,29 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,256,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,256,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,256,FontBlack,TEXTLONG29,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,256,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,256,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG        // A0 = Long Data Offset
  ld t0,0(a0)         // T0 = Long Data
  la a0,DSRA32CHECK29 // A0 = Long Check Data Offset
  ld t1,0(a0)         // T1 = Long Check Data
  beq t0,t1,DSRA32PASS29 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,256,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRA32END29
  nop // Delay Slot
  DSRA32PASS29:
  PrintString($A0100000,528,256,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRA32END29:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsra32 t0,30 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,264,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,264,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,264,FontBlack,TEXTLONG30,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,264,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,264,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG        // A0 = Long Data Offset
  ld t0,0(a0)         // T0 = Long Data
  la a0,DSRA32CHECK30 // A0 = Long Check Data Offset
  ld t1,0(a0)         // T1 = Long Check Data
  beq t0,t1,DSRA32PASS30 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,264,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRA32END30
  nop // Delay Slot
  DSRA32PASS30:
  PrintString($A0100000,528,264,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRA32END30:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsra32 t0,31 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,272,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,272,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,272,FontBlack,TEXTLONG31,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,272,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,272,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG        // A0 = Long Data Offset
  ld t0,0(a0)         // T0 = Long Data
  la a0,DSRA32CHECK31 // A0 = Long Check Data Offset
  ld t1,0(a0)         // T1 = Long Check Data
  beq t0,t1,DSRA32PASS31 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,272,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRA32END31
  nop // Delay Slot
  DSRA32PASS31:
  PrintString($A0100000,528,272,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRA32END31:


  PrintString($A0100000,0,280,FontBlack,PAGEBREAK,79) // Print Text String To VRAM Using Font At X,Y Position


Loop:
  WaitScanline($1E0) // Wait For Scanline To Reach Vertical Blank
  WaitScanline($1E2)

  lli t0,$00000800 // Even Field
  sw t0,VI_Y_SCALE(a0)

  WaitScanline($1E0) // Wait For Scanline To Reach Vertical Blank
  WaitScanline($1E2)

  li t0,$02000800 // Odd Field
  sw t0,VI_Y_SCALE(a0)

  j Loop
  nop // Delay Slot

DSRA32:
  db "DSRA32"

RDHEX:
  db "RD (Hex)"
RTHEX:
  db "RT (Hex)"
SA32DEC:
  db "SA + 32 (Decimal)"
TEST:
  db "Test Result"
FAIL:
  db "FAIL"
PASS:
  db "PASS"

DOLLAR:
  db "$"

TEXTLONG0:
  db "32"
TEXTLONG1:
  db "33"
TEXTLONG2:
  db "34"
TEXTLONG3:
  db "35"
TEXTLONG4:
  db "36"
TEXTLONG5:
  db "37"
TEXTLONG6:
  db "38"
TEXTLONG7:
  db "39"
TEXTLONG8:
  db "40"
TEXTLONG9:
  db "41"
TEXTLONG10:
  db "42"
TEXTLONG11:
  db "43"
TEXTLONG12:
  db "44"
TEXTLONG13:
  db "45"
TEXTLONG14:
  db "46"
TEXTLONG15:
  db "47"
TEXTLONG16:
  db "48"
TEXTLONG17:
  db "49"
TEXTLONG18:
  db "50"
TEXTLONG19:
  db "51"
TEXTLONG20:
  db "52"
TEXTLONG21:
  db "53"
TEXTLONG22:
  db "54"
TEXTLONG23:
  db "55"
TEXTLONG24:
  db "56"
TEXTLONG25:
  db "57"
TEXTLONG26:
  db "58"
TEXTLONG27:
  db "59"
TEXTLONG28:
  db "60"
TEXTLONG29:
  db "61"
TEXTLONG30:
  db "62"
TEXTLONG31:
  db "63"

PAGEBREAK:
  db "--------------------------------------------------------------------------------"

align(8) // Align 64-Bit
VALUELONG:
  dq -123456789123456789

DSRA32CHECK0:
  dq $FFFFFFFFFE4964B4
DSRA32CHECK1:
  dq $FFFFFFFFFF24B25A
DSRA32CHECK2:
  dq $FFFFFFFFFF92592D
DSRA32CHECK3:
  dq $FFFFFFFFFFC92C96
DSRA32CHECK4:
  dq $FFFFFFFFFFE4964B
DSRA32CHECK5:
  dq $FFFFFFFFFFF24B25
DSRA32CHECK6:
  dq $FFFFFFFFFFF92592
DSRA32CHECK7:
  dq $FFFFFFFFFFFC92C9
DSRA32CHECK8:
  dq $FFFFFFFFFFFE4964
DSRA32CHECK9:
  dq $FFFFFFFFFFFF24B2
DSRA32CHECK10:
  dq $FFFFFFFFFFFF9259
DSRA32CHECK11:
  dq $FFFFFFFFFFFFC92C
DSRA32CHECK12:
  dq $FFFFFFFFFFFFE496
DSRA32CHECK13:
  dq $FFFFFFFFFFFFF24B
DSRA32CHECK14:
  dq $FFFFFFFFFFFFF925
DSRA32CHECK15:
  dq $FFFFFFFFFFFFFC92
DSRA32CHECK16:
  dq $FFFFFFFFFFFFFE49
DSRA32CHECK17:
  dq $FFFFFFFFFFFFFF24
DSRA32CHECK18:
  dq $FFFFFFFFFFFFFF92
DSRA32CHECK19:
  dq $FFFFFFFFFFFFFFC9
DSRA32CHECK20:
  dq $FFFFFFFFFFFFFFE4
DSRA32CHECK21:
  dq $FFFFFFFFFFFFFFF2
DSRA32CHECK22:
  dq $FFFFFFFFFFFFFFF9
DSRA32CHECK23:
  dq $FFFFFFFFFFFFFFFC
DSRA32CHECK24:
  dq $FFFFFFFFFFFFFFFE
DSRA32CHECK25:
  dq $FFFFFFFFFFFFFFFF
DSRA32CHECK26:
  dq $FFFFFFFFFFFFFFFF
DSRA32CHECK27:
  dq $FFFFFFFFFFFFFFFF
DSRA32CHECK28:
  dq $FFFFFFFFFFFFFFFF
DSRA32CHECK29:
  dq $FFFFFFFFFFFFFFFF
DSRA32CHECK30:
  dq $FFFFFFFFFFFFFFFF
DSRA32CHECK31:
  dq $FFFFFFFFFFFFFFFF

RDLONG:
  dq 0

insert FontBlack, "FontBlack8x8.bin"
insert FontGreen, "FontGreen8x8.bin"
insert FontRed, "FontRed8x8.bin"