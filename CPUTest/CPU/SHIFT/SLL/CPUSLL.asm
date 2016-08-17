// N64 'Bare Metal' CPU Word Shift Left Logical (0..31) Test Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "CPUSLL.N64", create
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


  PrintString($A0100000,8,24,FontRed,SLL,2) // Print Text String To VRAM Using Font At X,Y Position
  la a0,VALUEWORD // A0 = Word Data Offset
  lw t0,0(a0)     // T0 = Word Data
  sll t0,0 // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintString($A0100000,80,24,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,24,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,24,FontBlack,TEXTWORD0,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,24,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,24,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD    // A0 = Word Data Offset
  lw t0,0(a0)     // T0 = Word Data
  la a0,SLLCHECK0 // A0 = Word Check Data Offset
  lw t1,0(a0)     // T1 = Word Check Data
  beq t0,t1,SLLPASS0 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,24,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLEND0
  nop // Delay Slot
  SLLPASS0:
  PrintString($A0100000,528,24,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLEND0:

  la a0,VALUEWORD // A0 = Word Data Offset
  lw t0,0(a0)     // T0 = Word Data
  sll t0,1 // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintString($A0100000,80,32,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,32,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,32,FontBlack,TEXTWORD1,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,32,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,32,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD    // A0 = Word Data Offset
  lw t0,0(a0)     // T0 = Word Data
  la a0,SLLCHECK1 // A0 = Word Check Data Offset
  lw t1,0(a0)     // T1 = Word Check Data
  beq t0,t1,SLLPASS1 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,32,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLEND1
  nop // Delay Slot
  SLLPASS1:
  PrintString($A0100000,528,32,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLEND1:

  la a0,VALUEWORD // A0 = Word Data Offset
  lw t0,0(a0)     // T0 = Word Data
  sll t0,2 // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintString($A0100000,80,40,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,40,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,40,FontBlack,TEXTWORD2,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,40,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,40,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD    // A0 = Word Data Offset
  lw t0,0(a0)     // T0 = Word Data
  la a0,SLLCHECK2 // A0 = Word Check Data Offset
  lw t1,0(a0)     // T1 = Word Check Data
  beq t0,t1,SLLPASS2 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,40,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLEND2
  nop // Delay Slot
  SLLPASS2:
  PrintString($A0100000,528,40,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLEND2:

  la a0,VALUEWORD // A0 = Word Data Offset
  lw t0,0(a0)     // T0 = Word Data
  sll t0,3 // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintString($A0100000,80,48,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,48,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,48,FontBlack,TEXTWORD3,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,48,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,48,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD    // A0 = Word Data Offset
  lw t0,0(a0)     // T0 = Word Data
  la a0,SLLCHECK3 // A0 = Word Check Data Offset
  lw t1,0(a0)     // T1 = Word Check Data
  beq t0,t1,SLLPASS3 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,48,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLEND3
  nop // Delay Slot
  SLLPASS3:
  PrintString($A0100000,528,48,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLEND3:

  la a0,VALUEWORD // A0 = Word Data Offset
  lw t0,0(a0)     // T0 = Word Data
  sll t0,4 // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintString($A0100000,80,56,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,56,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,56,FontBlack,TEXTWORD4,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,56,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,56,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD    // A0 = Word Data Offset
  lw t0,0(a0)     // T0 = Word Data
  la a0,SLLCHECK4 // A0 = Word Check Data Offset
  lw t1,0(a0)     // T1 = Word Check Data
  beq t0,t1,SLLPASS4 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,56,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLEND4
  nop // Delay Slot
  SLLPASS4:
  PrintString($A0100000,528,56,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLEND4:

  la a0,VALUEWORD // A0 = Word Data Offset
  lw t0,0(a0)     // T0 = Word Data
  sll t0,5 // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintString($A0100000,80,64,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,64,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,64,FontBlack,TEXTWORD5,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,64,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,64,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD    // A0 = Word Data Offset
  lw t0,0(a0)     // T0 = Word Data
  la a0,SLLCHECK5 // A0 = Word Check Data Offset
  lw t1,0(a0)     // T1 = Word Check Data
  beq t0,t1,SLLPASS5 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,64,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLEND5
  nop // Delay Slot
  SLLPASS5:
  PrintString($A0100000,528,64,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLEND5:

  la a0,VALUEWORD // A0 = Word Data Offset
  lw t0,0(a0)     // T0 = Word Data
  sll t0,6 // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintString($A0100000,80,72,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,72,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,72,FontBlack,TEXTWORD6,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,72,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,72,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD    // A0 = Word Data Offset
  lw t0,0(a0)     // T0 = Word Data
  la a0,SLLCHECK6 // A0 = Word Check Data Offset
  lw t1,0(a0)     // T1 = Word Check Data
  beq t0,t1,SLLPASS6 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,72,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLEND6
  nop // Delay Slot
  SLLPASS6:
  PrintString($A0100000,528,72,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLEND6:

  la a0,VALUEWORD // A0 = Word Data Offset
  lw t0,0(a0)     // T0 = Word Data
  sll t0,7 // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintString($A0100000,80,80,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,80,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,80,FontBlack,TEXTWORD7,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,80,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,80,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD    // A0 = Word Data Offset
  lw t0,0(a0)     // T0 = Word Data
  la a0,SLLCHECK7 // A0 = Word Check Data Offset
  lw t1,0(a0)     // T1 = Word Check Data
  beq t0,t1,SLLPASS7 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,80,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLEND7
  nop // Delay Slot
  SLLPASS7:
  PrintString($A0100000,528,80,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLEND7:

  la a0,VALUEWORD // A0 = Word Data Offset
  lw t0,0(a0)     // T0 = Word Data
  sll t0,8 // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintString($A0100000,80,88,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,88,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,88,FontBlack,TEXTWORD8,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,88,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,88,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD    // A0 = Word Data Offset
  lw t0,0(a0)     // T0 = Word Data
  la a0,SLLCHECK8 // A0 = Word Check Data Offset
  lw t1,0(a0)     // T1 = Word Check Data
  beq t0,t1,SLLPASS8 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,88,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLEND8
  nop // Delay Slot
  SLLPASS8:
  PrintString($A0100000,528,88,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLEND8:

  la a0,VALUEWORD // A0 = Word Data Offset
  lw t0,0(a0)     // T0 = Word Data
  sll t0,9 // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintString($A0100000,80,96,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,96,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,96,FontBlack,TEXTWORD9,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,96,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,96,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD    // A0 = Word Data Offset
  lw t0,0(a0)     // T0 = Word Data
  la a0,SLLCHECK9 // A0 = Word Check Data Offset
  lw t1,0(a0)     // T1 = Word Check Data
  beq t0,t1,SLLPASS9 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,96,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLEND9
  nop // Delay Slot
  SLLPASS9:
  PrintString($A0100000,528,96,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLEND9:

  la a0,VALUEWORD // A0 = Word Data Offset
  lw t0,0(a0)     // T0 = Word Data
  sll t0,10 // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintString($A0100000,80,104,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,104,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,104,FontBlack,TEXTWORD10,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,104,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,104,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,SLLCHECK10 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SLLPASS10 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,104,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLEND10
  nop // Delay Slot
  SLLPASS10:
  PrintString($A0100000,528,104,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLEND10:

  la a0,VALUEWORD // A0 = Word Data Offset
  lw t0,0(a0)     // T0 = Word Data
  sll t0,11 // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintString($A0100000,80,112,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,112,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,112,FontBlack,TEXTWORD11,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,112,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,112,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,SLLCHECK11 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SLLPASS11 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,112,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLEND11
  nop // Delay Slot
  SLLPASS11:
  PrintString($A0100000,528,112,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLEND11:

  la a0,VALUEWORD // A0 = Word Data Offset
  lw t0,0(a0)     // T0 = Word Data
  sll t0,12 // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintString($A0100000,80,120,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,120,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,120,FontBlack,TEXTWORD12,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,120,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,120,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,SLLCHECK12 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SLLPASS12 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,120,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLEND12
  nop // Delay Slot
  SLLPASS12:
  PrintString($A0100000,528,120,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLEND12:

  la a0,VALUEWORD // A0 = Word Data Offset
  lw t0,0(a0)     // T0 = Word Data
  sll t0,13 // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintString($A0100000,80,128,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,128,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,128,FontBlack,TEXTWORD13,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,128,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,128,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,SLLCHECK13 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SLLPASS13 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,128,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLEND13
  nop // Delay Slot
  SLLPASS13:
  PrintString($A0100000,528,128,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLEND13:

  la a0,VALUEWORD // A0 = Word Data Offset
  lw t0,0(a0)     // T0 = Word Data
  sll t0,14 // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintString($A0100000,80,136,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,136,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,136,FontBlack,TEXTWORD14,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,136,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,136,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,SLLCHECK14 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SLLPASS14 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,136,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLEND14
  nop // Delay Slot
  SLLPASS14:
  PrintString($A0100000,528,136,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLEND14:

  la a0,VALUEWORD // A0 = Word Data Offset
  lw t0,0(a0)     // T0 = Word Data
  sll t0,15 // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintString($A0100000,80,144,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,144,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,144,FontBlack,TEXTWORD15,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,144,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,144,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,SLLCHECK15 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SLLPASS15 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,144,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLEND15
  nop // Delay Slot
  SLLPASS15:
  PrintString($A0100000,528,144,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLEND15:

  la a0,VALUEWORD // A0 = Word Data Offset
  lw t0,0(a0)     // T0 = Word Data
  sll t0,16 // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintString($A0100000,80,152,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,152,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,152,FontBlack,TEXTWORD16,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,152,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,152,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,SLLCHECK16 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SLLPASS16 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,152,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLEND16
  nop // Delay Slot
  SLLPASS16:
  PrintString($A0100000,528,152,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLEND16:

  la a0,VALUEWORD // A0 = Word Data Offset
  lw t0,0(a0)     // T0 = Word Data
  sll t0,17 // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintString($A0100000,80,160,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,160,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,160,FontBlack,TEXTWORD17,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,160,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,160,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,SLLCHECK17 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SLLPASS17 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,160,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLEND17
  nop // Delay Slot
  SLLPASS17:
  PrintString($A0100000,528,160,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLEND17:

  la a0,VALUEWORD // A0 = Word Data Offset
  lw t0,0(a0)     // T0 = Word Data
  sll t0,18 // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintString($A0100000,80,168,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,168,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,168,FontBlack,TEXTWORD18,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,168,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,168,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,SLLCHECK18 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SLLPASS18 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,168,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLEND18
  nop // Delay Slot
  SLLPASS18:
  PrintString($A0100000,528,168,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLEND18:

  la a0,VALUEWORD // A0 = Word Data Offset
  lw t0,0(a0)     // T0 = Word Data
  sll t0,19 // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintString($A0100000,80,176,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,176,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,176,FontBlack,TEXTWORD19,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,176,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,176,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,SLLCHECK19 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SLLPASS19 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,176,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLEND19
  nop // Delay Slot
  SLLPASS19:
  PrintString($A0100000,528,176,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLEND19:

  la a0,VALUEWORD // A0 = Word Data Offset
  lw t0,0(a0)     // T0 = Word Data
  sll t0,20 // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintString($A0100000,80,184,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,184,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,184,FontBlack,TEXTWORD20,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,184,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,184,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,SLLCHECK20 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SLLPASS20 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,184,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLEND20
  nop // Delay Slot
  SLLPASS20:
  PrintString($A0100000,528,184,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLEND20:

  la a0,VALUEWORD // A0 = Word Data Offset
  lw t0,0(a0)     // T0 = Word Data
  sll t0,21 // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintString($A0100000,80,192,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,192,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,192,FontBlack,TEXTWORD21,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,192,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,192,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,SLLCHECK21 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SLLPASS21 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,192,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLEND21
  nop // Delay Slot
  SLLPASS21:
  PrintString($A0100000,528,192,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLEND21:

  la a0,VALUEWORD // A0 = Word Data Offset
  lw t0,0(a0)     // T0 = Word Data
  sll t0,22 // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintString($A0100000,80,200,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,200,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,200,FontBlack,TEXTWORD22,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,200,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,200,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,SLLCHECK22 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SLLPASS22 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,200,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLEND22
  nop // Delay Slot
  SLLPASS22:
  PrintString($A0100000,528,200,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLEND22:

  la a0,VALUEWORD // A0 = Word Data Offset
  lw t0,0(a0)     // T0 = Word Data
  sll t0,23 // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintString($A0100000,80,208,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,208,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,208,FontBlack,TEXTWORD23,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,208,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,208,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,SLLCHECK23 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SLLPASS23 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,208,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLEND23
  nop // Delay Slot
  SLLPASS23:
  PrintString($A0100000,528,208,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLEND23:

  la a0,VALUEWORD // A0 = Word Data Offset
  lw t0,0(a0)     // T0 = Word Data
  sll t0,24 // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintString($A0100000,80,216,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,216,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,216,FontBlack,TEXTWORD24,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,216,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,216,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,SLLCHECK24 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SLLPASS24 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,216,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLEND24
  nop // Delay Slot
  SLLPASS24:
  PrintString($A0100000,528,216,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLEND24:

  la a0,VALUEWORD // A0 = Word Data Offset
  lw t0,0(a0)     // T0 = Word Data
  sll t0,25 // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintString($A0100000,80,224,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,224,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,224,FontBlack,TEXTWORD25,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,224,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,224,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,SLLCHECK25 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SLLPASS25 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,224,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLEND25
  nop // Delay Slot
  SLLPASS25:
  PrintString($A0100000,528,224,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLEND25:

  la a0,VALUEWORD // A0 = Word Data Offset
  lw t0,0(a0)     // T0 = Word Data
  sll t0,26 // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintString($A0100000,80,232,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,232,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,232,FontBlack,TEXTWORD26,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,232,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,232,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,SLLCHECK26 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SLLPASS26 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,232,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLEND26
  nop // Delay Slot
  SLLPASS26:
  PrintString($A0100000,528,232,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLEND26:

  la a0,VALUEWORD // A0 = Word Data Offset
  lw t0,0(a0)     // T0 = Word Data
  sll t0,27 // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintString($A0100000,80,240,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,240,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,240,FontBlack,TEXTWORD27,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,240,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,240,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,SLLCHECK27 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SLLPASS27 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,240,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLEND27
  nop // Delay Slot
  SLLPASS27:
  PrintString($A0100000,528,240,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLEND27:

  la a0,VALUEWORD // A0 = Word Data Offset
  lw t0,0(a0)     // T0 = Word Data
  sll t0,28 // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintString($A0100000,80,248,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,248,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,248,FontBlack,TEXTWORD28,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,248,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,248,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,SLLCHECK28 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SLLPASS28 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,248,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLEND28
  nop // Delay Slot
  SLLPASS28:
  PrintString($A0100000,528,248,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLEND28:

  la a0,VALUEWORD // A0 = Word Data Offset
  lw t0,0(a0)     // T0 = Word Data
  sll t0,29 // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintString($A0100000,80,256,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,256,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,256,FontBlack,TEXTWORD29,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,256,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,256,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,SLLCHECK29 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SLLPASS29 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,256,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLEND29
  nop // Delay Slot
  SLLPASS29:
  PrintString($A0100000,528,256,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLEND29:

  la a0,VALUEWORD // A0 = Word Data Offset
  lw t0,0(a0)     // T0 = Word Data
  sll t0,30 // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintString($A0100000,80,264,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,264,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,264,FontBlack,TEXTWORD30,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,264,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,264,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,SLLCHECK30 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SLLPASS30 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,264,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLEND30
  nop // Delay Slot
  SLLPASS30:
  PrintString($A0100000,528,264,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLEND30:

  la a0,VALUEWORD // A0 = Word Data Offset
  lw t0,0(a0)     // T0 = Word Data
  sll t0,31 // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintString($A0100000,80,272,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,272,FontBlack,VALUEWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,272,FontBlack,TEXTWORD31,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,272,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,272,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,SLLCHECK31 // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,SLLPASS31 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,272,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLEND31
  nop // Delay Slot
  SLLPASS31:
  PrintString($A0100000,528,272,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLEND31:


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

SLL:
  db "SLL"

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

TEXTWORD0:
  db "0"
TEXTWORD1:
  db "1"
TEXTWORD2:
  db "2"
TEXTWORD3:
  db "3"
TEXTWORD4:
  db "4"
TEXTWORD5:
  db "5"
TEXTWORD6:
  db "6"
TEXTWORD7:
  db "7"
TEXTWORD8:
  db "8"
TEXTWORD9:
  db "9"
TEXTWORD10:
  db "10"
TEXTWORD11:
  db "11"
TEXTWORD12:
  db "12"
TEXTWORD13:
  db "13"
TEXTWORD14:
  db "14"
TEXTWORD15:
  db "15"
TEXTWORD16:
  db "16"
TEXTWORD17:
  db "17"
TEXTWORD18:
  db "18"
TEXTWORD19:
  db "19"
TEXTWORD20:
  db "20"
TEXTWORD21:
  db "21"
TEXTWORD22:
  db "22"
TEXTWORD23:
  db "23"
TEXTWORD24:
  db "24"
TEXTWORD25:
  db "25"
TEXTWORD26:
  db "26"
TEXTWORD27:
  db "27"
TEXTWORD28:
  db "28"
TEXTWORD29:
  db "29"
TEXTWORD30:
  db "30"
TEXTWORD31:
  db "31"

PAGEBREAK:
  db "--------------------------------------------------------------------------------"

align(8) // Align 64-Bit
VALUEWORD:
  dd -123456789

SLLCHECK0:
  dd $F8A432EB
SLLCHECK1:
  dd $F14865D6
SLLCHECK2:
  dd $E290CBAC
SLLCHECK3:
  dd $C5219758
SLLCHECK4:
  dd $8A432EB0
SLLCHECK5:
  dd $14865D60
SLLCHECK6:
  dd $290CBAC0
SLLCHECK7:
  dd $52197580
SLLCHECK8:
  dd $A432EB00
SLLCHECK9:
  dd $4865D600
SLLCHECK10:
  dd $90CBAC00
SLLCHECK11:
  dd $21975800
SLLCHECK12:
  dd $432EB000
SLLCHECK13:
  dd $865D6000
SLLCHECK14:
  dd $0CBAC000
SLLCHECK15:
  dd $19758000
SLLCHECK16:
  dd $32EB0000
SLLCHECK17:
  dd $65D60000
SLLCHECK18:
  dd $CBAC0000
SLLCHECK19:
  dd $97580000
SLLCHECK20:
  dd $2EB00000
SLLCHECK21:
  dd $5D600000
SLLCHECK22:
  dd $BAC00000
SLLCHECK23:
  dd $75800000
SLLCHECK24:
  dd $EB000000
SLLCHECK25:
  dd $D6000000
SLLCHECK26:
  dd $AC000000
SLLCHECK27:
  dd $58000000
SLLCHECK28:
  dd $B0000000
SLLCHECK29:
  dd $60000000
SLLCHECK30:
  dd $C0000000
SLLCHECK31:
  dd $80000000

RDWORD:
  dd 0

insert FontBlack, "FontBlack8x8.bin"
insert FontGreen, "FontGreen8x8.bin"
insert FontRed, "FontRed8x8.bin"