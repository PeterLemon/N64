// N64 'Bare Metal' CPU Doubleword Shift Left Logical (0..31) Test Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "CPUDSLL.N64", create
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
  PrintString($A0100000,232,8,FontRed,SADEC,11) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,384,8,FontRed,RDHEX,7) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,528,8,FontRed,TEST,10) // Print Text String To VRAM Using Font At X,Y Position


  PrintString($A0100000,0,16,FontBlack,PAGEBREAK,79) // Print Text String To VRAM Using Font At X,Y Position


  PrintString($A0100000,8,24,FontRed,DSLL,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsll t0,0 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,24,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,24,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,24,FontBlack,TEXTLONG0,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,24,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,24,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG     // A0 = Long Data Offset
  ld t0,0(a0)      // T0 = Long Data
  la a0,DSLLCHECK0 // A0 = Long Check Data Offset
  ld t1,0(a0)      // T1 = Long Check Data
  beq t0,t1,DSLLPASS0 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,24,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSLLEND0
  nop // Delay Slot
  DSLLPASS0:
  PrintString($A0100000,528,24,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSLLEND0:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsll t0,1 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,32,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,32,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,32,FontBlack,TEXTLONG1,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,32,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,32,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG     // A0 = Long Data Offset
  ld t0,0(a0)      // T0 = Long Data
  la a0,DSLLCHECK1 // A0 = Long Check Data Offset
  ld t1,0(a0)      // T1 = Long Check Data
  beq t0,t1,DSLLPASS1 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,32,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSLLEND1
  nop // Delay Slot
  DSLLPASS1:
  PrintString($A0100000,528,32,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSLLEND1:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsll t0,2 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,40,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,40,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,40,FontBlack,TEXTLONG2,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,40,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,40,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG     // A0 = Long Data Offset
  ld t0,0(a0)      // T0 = Long Data
  la a0,DSLLCHECK2 // A0 = Long Check Data Offset
  ld t1,0(a0)      // T1 = Long Check Data
  beq t0,t1,DSLLPASS2 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,40,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSLLEND2
  nop // Delay Slot
  DSLLPASS2:
  PrintString($A0100000,528,40,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSLLEND2:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsll t0,3 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,48,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,48,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,48,FontBlack,TEXTLONG3,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,48,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,48,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG     // A0 = Long Data Offset
  ld t0,0(a0)      // T0 = Long Data
  la a0,DSLLCHECK3 // A0 = Long Check Data Offset
  ld t1,0(a0)      // T1 = Long Check Data
  beq t0,t1,DSLLPASS3 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,48,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSLLEND3
  nop // Delay Slot
  DSLLPASS3:
  PrintString($A0100000,528,48,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSLLEND3:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsll t0,4 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,56,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,56,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,56,FontBlack,TEXTLONG4,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,56,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,56,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG     // A0 = Long Data Offset
  ld t0,0(a0)      // T0 = Long Data
  la a0,DSLLCHECK4 // A0 = Long Check Data Offset
  ld t1,0(a0)      // T1 = Long Check Data
  beq t0,t1,DSLLPASS4 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,56,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSLLEND4
  nop // Delay Slot
  DSLLPASS4:
  PrintString($A0100000,528,56,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSLLEND4:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsll t0,5 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,64,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,64,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,64,FontBlack,TEXTLONG5,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,64,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,64,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG     // A0 = Long Data Offset
  ld t0,0(a0)      // T0 = Long Data
  la a0,DSLLCHECK5 // A0 = Long Check Data Offset
  ld t1,0(a0)      // T1 = Long Check Data
  beq t0,t1,DSLLPASS5 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,64,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSLLEND5
  nop // Delay Slot
  DSLLPASS5:
  PrintString($A0100000,528,64,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSLLEND5:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsll t0,6 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,72,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,72,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,72,FontBlack,TEXTLONG6,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,72,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,72,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG     // A0 = Long Data Offset
  ld t0,0(a0)      // T0 = Long Data
  la a0,DSLLCHECK6 // A0 = Long Check Data Offset
  ld t1,0(a0)      // T1 = Long Check Data
  beq t0,t1,DSLLPASS6 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,72,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSLLEND6
  nop // Delay Slot
  DSLLPASS6:
  PrintString($A0100000,528,72,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSLLEND6:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsll t0,7 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,80,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,80,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,80,FontBlack,TEXTLONG7,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,80,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,80,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG     // A0 = Long Data Offset
  ld t0,0(a0)      // T0 = Long Data
  la a0,DSLLCHECK7 // A0 = Long Check Data Offset
  ld t1,0(a0)      // T1 = Long Check Data
  beq t0,t1,DSLLPASS7 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,80,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSLLEND7
  nop // Delay Slot
  DSLLPASS7:
  PrintString($A0100000,528,80,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSLLEND7:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsll t0,8 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,88,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,88,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,88,FontBlack,TEXTLONG8,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,88,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,88,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG     // A0 = Long Data Offset
  ld t0,0(a0)      // T0 = Long Data
  la a0,DSLLCHECK8 // A0 = Long Check Data Offset
  ld t1,0(a0)      // T1 = Long Check Data
  beq t0,t1,DSLLPASS8 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,88,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSLLEND8
  nop // Delay Slot
  DSLLPASS8:
  PrintString($A0100000,528,88,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSLLEND8:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsll t0,9 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,96,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,96,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,96,FontBlack,TEXTLONG9,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,96,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,96,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG     // A0 = Long Data Offset
  ld t0,0(a0)      // T0 = Long Data
  la a0,DSLLCHECK9 // A0 = Long Check Data Offset
  ld t1,0(a0)      // T1 = Long Check Data
  beq t0,t1,DSLLPASS9 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,96,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSLLEND9
  nop // Delay Slot
  DSLLPASS9:
  PrintString($A0100000,528,96,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSLLEND9:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsll t0,10 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,104,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,104,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,104,FontBlack,TEXTLONG10,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,104,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,104,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG      // A0 = Long Data Offset
  ld t0,0(a0)       // T0 = Long Data
  la a0,DSLLCHECK10 // A0 = Long Check Data Offset
  ld t1,0(a0)       // T1 = Long Check Data
  beq t0,t1,DSLLPASS10 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,104,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSLLEND10
  nop // Delay Slot
  DSLLPASS10:
  PrintString($A0100000,528,104,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSLLEND10:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsll t0,11 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,112,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,112,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,112,FontBlack,TEXTLONG11,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,112,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,112,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG      // A0 = Long Data Offset
  ld t0,0(a0)       // T0 = Long Data
  la a0,DSLLCHECK11 // A0 = Long Check Data Offset
  ld t1,0(a0)       // T1 = Long Check Data
  beq t0,t1,DSLLPASS11 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,112,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSLLEND11
  nop // Delay Slot
  DSLLPASS11:
  PrintString($A0100000,528,112,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSLLEND11:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsll t0,12 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,120,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,120,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,120,FontBlack,TEXTLONG12,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,120,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,120,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG      // A0 = Long Data Offset
  ld t0,0(a0)       // T0 = Long Data
  la a0,DSLLCHECK12 // A0 = Long Check Data Offset
  ld t1,0(a0)       // T1 = Long Check Data
  beq t0,t1,DSLLPASS12 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,120,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSLLEND12
  nop // Delay Slot
  DSLLPASS12:
  PrintString($A0100000,528,120,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSLLEND12:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsll t0,13 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,128,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,128,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,128,FontBlack,TEXTLONG13,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,128,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,128,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG      // A0 = Long Data Offset
  ld t0,0(a0)       // T0 = Long Data
  la a0,DSLLCHECK13 // A0 = Long Check Data Offset
  ld t1,0(a0)       // T1 = Long Check Data
  beq t0,t1,DSLLPASS13 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,128,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSLLEND13
  nop // Delay Slot
  DSLLPASS13:
  PrintString($A0100000,528,128,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSLLEND13:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsll t0,14 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,136,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,136,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,136,FontBlack,TEXTLONG14,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,136,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,136,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG      // A0 = Long Data Offset
  ld t0,0(a0)       // T0 = Long Data
  la a0,DSLLCHECK14 // A0 = Long Check Data Offset
  ld t1,0(a0)       // T1 = Long Check Data
  beq t0,t1,DSLLPASS14 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,136,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSLLEND14
  nop // Delay Slot
  DSLLPASS14:
  PrintString($A0100000,528,136,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSLLEND14:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsll t0,15 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,144,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,144,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,144,FontBlack,TEXTLONG15,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,144,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,144,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG      // A0 = Long Data Offset
  ld t0,0(a0)       // T0 = Long Data
  la a0,DSLLCHECK15 // A0 = Long Check Data Offset
  ld t1,0(a0)       // T1 = Long Check Data
  beq t0,t1,DSLLPASS15 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,144,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSLLEND15
  nop // Delay Slot
  DSLLPASS15:
  PrintString($A0100000,528,144,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSLLEND15:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsll t0,16 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,152,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,152,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,152,FontBlack,TEXTLONG16,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,152,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,152,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG      // A0 = Long Data Offset
  ld t0,0(a0)       // T0 = Long Data
  la a0,DSLLCHECK16 // A0 = Long Check Data Offset
  ld t1,0(a0)       // T1 = Long Check Data
  beq t0,t1,DSLLPASS16 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,152,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSLLEND16
  nop // Delay Slot
  DSLLPASS16:
  PrintString($A0100000,528,152,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSLLEND16:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsll t0,17 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,160,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,160,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,160,FontBlack,TEXTLONG17,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,160,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,160,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG      // A0 = Long Data Offset
  ld t0,0(a0)       // T0 = Long Data
  la a0,DSLLCHECK17 // A0 = Long Check Data Offset
  ld t1,0(a0)       // T1 = Long Check Data
  beq t0,t1,DSLLPASS17 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,160,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSLLEND17
  nop // Delay Slot
  DSLLPASS17:
  PrintString($A0100000,528,160,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSLLEND17:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsll t0,18 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,168,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,168,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,168,FontBlack,TEXTLONG18,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,168,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,168,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG      // A0 = Long Data Offset
  ld t0,0(a0)       // T0 = Long Data
  la a0,DSLLCHECK18 // A0 = Long Check Data Offset
  ld t1,0(a0)       // T1 = Long Check Data
  beq t0,t1,DSLLPASS18 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,168,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSLLEND18
  nop // Delay Slot
  DSLLPASS18:
  PrintString($A0100000,528,168,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSLLEND18:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsll t0,19 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,176,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,176,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,176,FontBlack,TEXTLONG19,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,176,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,176,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG      // A0 = Long Data Offset
  ld t0,0(a0)       // T0 = Long Data
  la a0,DSLLCHECK19 // A0 = Long Check Data Offset
  ld t1,0(a0)       // T1 = Long Check Data
  beq t0,t1,DSLLPASS19 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,176,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSLLEND19
  nop // Delay Slot
  DSLLPASS19:
  PrintString($A0100000,528,176,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSLLEND19:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsll t0,20 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,184,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,184,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,184,FontBlack,TEXTLONG20,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,184,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,184,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG      // A0 = Long Data Offset
  ld t0,0(a0)       // T0 = Long Data
  la a0,DSLLCHECK20 // A0 = Long Check Data Offset
  ld t1,0(a0)       // T1 = Long Check Data
  beq t0,t1,DSLLPASS20 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,184,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSLLEND20
  nop // Delay Slot
  DSLLPASS20:
  PrintString($A0100000,528,184,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSLLEND20:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsll t0,21 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,192,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,192,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,192,FontBlack,TEXTLONG21,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,192,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,192,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG      // A0 = Long Data Offset
  ld t0,0(a0)       // T0 = Long Data
  la a0,DSLLCHECK21 // A0 = Long Check Data Offset
  ld t1,0(a0)       // T1 = Long Check Data
  beq t0,t1,DSLLPASS21 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,192,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSLLEND21
  nop // Delay Slot
  DSLLPASS21:
  PrintString($A0100000,528,192,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSLLEND21:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsll t0,22 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,200,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,200,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,200,FontBlack,TEXTLONG22,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,200,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,200,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG      // A0 = Long Data Offset
  ld t0,0(a0)       // T0 = Long Data
  la a0,DSLLCHECK22 // A0 = Long Check Data Offset
  ld t1,0(a0)       // T1 = Long Check Data
  beq t0,t1,DSLLPASS22 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,200,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSLLEND22
  nop // Delay Slot
  DSLLPASS22:
  PrintString($A0100000,528,200,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSLLEND22:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsll t0,23 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,208,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,208,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,208,FontBlack,TEXTLONG23,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,208,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,208,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG      // A0 = Long Data Offset
  ld t0,0(a0)       // T0 = Long Data
  la a0,DSLLCHECK23 // A0 = Long Check Data Offset
  ld t1,0(a0)       // T1 = Long Check Data
  beq t0,t1,DSLLPASS23 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,208,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSLLEND23
  nop // Delay Slot
  DSLLPASS23:
  PrintString($A0100000,528,208,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSLLEND23:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsll t0,24 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,216,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,216,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,216,FontBlack,TEXTLONG24,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,216,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,216,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG      // A0 = Long Data Offset
  ld t0,0(a0)       // T0 = Long Data
  la a0,DSLLCHECK24 // A0 = Long Check Data Offset
  ld t1,0(a0)       // T1 = Long Check Data
  beq t0,t1,DSLLPASS24 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,216,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSLLEND24
  nop // Delay Slot
  DSLLPASS24:
  PrintString($A0100000,528,216,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSLLEND24:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsll t0,25 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,224,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,224,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,224,FontBlack,TEXTLONG25,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,224,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,224,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG      // A0 = Long Data Offset
  ld t0,0(a0)       // T0 = Long Data
  la a0,DSLLCHECK25 // A0 = Long Check Data Offset
  ld t1,0(a0)       // T1 = Long Check Data
  beq t0,t1,DSLLPASS25 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,224,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSLLEND25
  nop // Delay Slot
  DSLLPASS25:
  PrintString($A0100000,528,224,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSLLEND25:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsll t0,26 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,232,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,232,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,232,FontBlack,TEXTLONG26,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,232,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,232,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG      // A0 = Long Data Offset
  ld t0,0(a0)       // T0 = Long Data
  la a0,DSLLCHECK26 // A0 = Long Check Data Offset
  ld t1,0(a0)       // T1 = Long Check Data
  beq t0,t1,DSLLPASS26 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,232,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSLLEND26
  nop // Delay Slot
  DSLLPASS26:
  PrintString($A0100000,528,232,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSLLEND26:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsll t0,27 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,240,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,240,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,240,FontBlack,TEXTLONG27,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,240,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,240,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG      // A0 = Long Data Offset
  ld t0,0(a0)       // T0 = Long Data
  la a0,DSLLCHECK27 // A0 = Long Check Data Offset
  ld t1,0(a0)       // T1 = Long Check Data
  beq t0,t1,DSLLPASS27 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,240,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSLLEND27
  nop // Delay Slot
  DSLLPASS27:
  PrintString($A0100000,528,240,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSLLEND27:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsll t0,28 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,248,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,248,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,248,FontBlack,TEXTLONG28,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,248,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,248,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG      // A0 = Long Data Offset
  ld t0,0(a0)       // T0 = Long Data
  la a0,DSLLCHECK28 // A0 = Long Check Data Offset
  ld t1,0(a0)       // T1 = Long Check Data
  beq t0,t1,DSLLPASS28 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,248,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSLLEND28
  nop // Delay Slot
  DSLLPASS28:
  PrintString($A0100000,528,248,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSLLEND28:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsll t0,29 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,256,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,256,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,256,FontBlack,TEXTLONG29,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,256,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,256,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG      // A0 = Long Data Offset
  ld t0,0(a0)       // T0 = Long Data
  la a0,DSLLCHECK29 // A0 = Long Check Data Offset
  ld t1,0(a0)       // T1 = Long Check Data
  beq t0,t1,DSLLPASS29 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,256,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSLLEND29
  nop // Delay Slot
  DSLLPASS29:
  PrintString($A0100000,528,256,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSLLEND29:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsll t0,30 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,264,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,264,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,264,FontBlack,TEXTLONG30,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,264,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,264,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG      // A0 = Long Data Offset
  ld t0,0(a0)       // T0 = Long Data
  la a0,DSLLCHECK30 // A0 = Long Check Data Offset
  ld t1,0(a0)       // T1 = Long Check Data
  beq t0,t1,DSLLPASS30 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,264,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSLLEND30
  nop // Delay Slot
  DSLLPASS30:
  PrintString($A0100000,528,264,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSLLEND30:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  dsll t0,31 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,272,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,272,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,272,FontBlack,TEXTLONG31,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,272,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,272,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG      // A0 = Long Data Offset
  ld t0,0(a0)       // T0 = Long Data
  la a0,DSLLCHECK31 // A0 = Long Check Data Offset
  ld t1,0(a0)       // T1 = Long Check Data
  beq t0,t1,DSLLPASS31 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,272,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSLLEND31
  nop // Delay Slot
  DSLLPASS31:
  PrintString($A0100000,528,272,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSLLEND31:


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

DSLL:
  db "DSLL"

RDHEX:
  db "RD (Hex)"
RTHEX:
  db "RT (Hex)"
SADEC:
  db "SA (Decimal)"
TEST:
  db "Test Result"
FAIL:
  db "FAIL"
PASS:
  db "PASS"

DOLLAR:
  db "$"

TEXTLONG0:
  db "0"
TEXTLONG1:
  db "1"
TEXTLONG2:
  db "2"
TEXTLONG3:
  db "3"
TEXTLONG4:
  db "4"
TEXTLONG5:
  db "5"
TEXTLONG6:
  db "6"
TEXTLONG7:
  db "7"
TEXTLONG8:
  db "8"
TEXTLONG9:
  db "9"
TEXTLONG10:
  db "10"
TEXTLONG11:
  db "11"
TEXTLONG12:
  db "12"
TEXTLONG13:
  db "13"
TEXTLONG14:
  db "14"
TEXTLONG15:
  db "15"
TEXTLONG16:
  db "16"
TEXTLONG17:
  db "17"
TEXTLONG18:
  db "18"
TEXTLONG19:
  db "19"
TEXTLONG20:
  db "20"
TEXTLONG21:
  db "21"
TEXTLONG22:
  db "22"
TEXTLONG23:
  db "23"
TEXTLONG24:
  db "24"
TEXTLONG25:
  db "25"
TEXTLONG26:
  db "26"
TEXTLONG27:
  db "27"
TEXTLONG28:
  db "28"
TEXTLONG29:
  db "29"
TEXTLONG30:
  db "30"
TEXTLONG31:
  db "31"

PAGEBREAK:
  db "--------------------------------------------------------------------------------"

align(8) // Align 64-Bit
VALUELONG:
  dq -123456789123456789

DSLLCHECK0:
  dq $FE4964B4532FA0EB
DSLLCHECK1:
  dq $FC92C968A65F41D6
DSLLCHECK2:
  dq $F92592D14CBE83AC
DSLLCHECK3:
  dq $F24B25A2997D0758
DSLLCHECK4:
  dq $E4964B4532FA0EB0
DSLLCHECK5:
  dq $C92C968A65F41D60
DSLLCHECK6:
  dq $92592D14CBE83AC0
DSLLCHECK7:
  dq $24B25A2997D07580
DSLLCHECK8:
  dq $4964B4532FA0EB00
DSLLCHECK9:
  dq $92C968A65F41D600
DSLLCHECK10:
  dq $2592D14CBE83AC00
DSLLCHECK11:
  dq $4B25A2997D075800
DSLLCHECK12:
  dq $964B4532FA0EB000
DSLLCHECK13:
  dq $2C968A65F41D6000
DSLLCHECK14:
  dq $592D14CBE83AC000
DSLLCHECK15:
  dq $B25A2997D0758000
DSLLCHECK16:
  dq $64B4532FA0EB0000
DSLLCHECK17:
  dq $C968A65F41D60000
DSLLCHECK18:
  dq $92D14CBE83AC0000
DSLLCHECK19:
  dq $25A2997D07580000
DSLLCHECK20:
  dq $4B4532FA0EB00000
DSLLCHECK21:
  dq $968A65F41D600000
DSLLCHECK22:
  dq $2D14CBE83AC00000
DSLLCHECK23:
  dq $5A2997D075800000
DSLLCHECK24:
  dq $B4532FA0EB000000
DSLLCHECK25:
  dq $68A65F41D6000000
DSLLCHECK26:
  dq $D14CBE83AC000000
DSLLCHECK27:
  dq $A2997D0758000000
DSLLCHECK28:
  dq $4532FA0EB0000000
DSLLCHECK29:
  dq $8A65F41D60000000
DSLLCHECK30:
  dq $14CBE83AC0000000
DSLLCHECK31:
  dq $2997D07580000000

RDLONG:
  dq 0

insert FontBlack, "FontBlack8x8.bin"
insert FontGreen, "FontGreen8x8.bin"
insert FontRed, "FontRed8x8.bin"