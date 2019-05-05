// N64 'Bare Metal' CPU Load Halfword Test Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "CPULH.N64", create
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

Start:
  include "LIB/N64_GFX.INC" // Include Graphics Macros
  N64_INIT() // Run N64 Initialisation Routine

  ScreenNTSC(640, 480, BPP32|INTERLACE|AA_MODE_2, $A0100000) // Screen NTSC: 640x480, 32BPP, Interlace, Resample Only, DRAM Origin = $A0100000

  lui a0,$A010 // A0 = VRAM Start Offset
  la a1,$A0100000+((SCREEN_X*SCREEN_Y*BYTES_PER_PIXEL)-BYTES_PER_PIXEL) // A1 = VRAM End Offset
  ori t0,r0,$000000FF // T0 = Black
ClearScreen:
  sw t0,0(a0)
  bne a0,a1,ClearScreen
  addi a0,4 // Delay Slot


  PrintString($A0100000,88,8,FontRed,HALFHEX,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,8,FontRed,HALFDEC,13) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,384,8,FontRed,RTHEX,7) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,528,8,FontRed,TEST,10) // Print Text String To VRAM Using Font At X,Y Position


  PrintString($A0100000,0,16,FontBlack,PAGEBREAK,79) // Print Text String To VRAM Using Font At X,Y Position


  PrintString($A0100000,8,24,FontRed,LH,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,VALUEHALFA // A0 = Halfword Data Offset
  lh t0,0(a0) // T0 = Test Halfword Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,144,24,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,24,FontBlack,VALUEHALFA,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,24,FontBlack,TEXTHALFA,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,24,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,24,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG   // A0 = Long Data Offset
  ld t0,0(a0)    // T0 = Long Data
  la a0,LHCHECKA // A0 = Long Check Data Offset
  ld t1,0(a0)    // T1 = Long Check Data
  beq t0,t1,LHPASSA // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,24,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LHENDA
  nop // Delay Slot
  LHPASSA:
  PrintString($A0100000,528,24,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LHENDA:

  la a0,VALUEHALFB // A0 = Halfword Data Offset
  lh t0,0(a0) // T0 = Test Halfword Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,144,32,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,32,FontBlack,VALUEHALFB,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,328,32,FontBlack,TEXTHALFB,4) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,32,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,32,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG   // A0 = Long Data Offset
  ld t0,0(a0)    // T0 = Long Data
  la a0,LHCHECKB // A0 = Long Check Data Offset
  ld t1,0(a0)    // T1 = Long Check Data
  beq t0,t1,LHPASSB // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,32,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LHENDB
  nop // Delay Slot
  LHPASSB:
  PrintString($A0100000,528,32,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LHENDB:

  la a0,VALUEHALFC // A0 = Halfword Data Offset
  lh t0,0(a0) // T0 = Test Halfword Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,144,40,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,40,FontBlack,VALUEHALFC,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,336,40,FontBlack,TEXTHALFC,3) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,40,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,40,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG   // A0 = Long Data Offset
  ld t0,0(a0)    // T0 = Long Data
  la a0,LHCHECKC // A0 = Long Check Data Offset
  ld t1,0(a0)    // T1 = Long Check Data
  beq t0,t1,LHPASSC // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,40,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LHENDC
  nop // Delay Slot
  LHPASSC:
  PrintString($A0100000,528,40,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LHENDC:

  la a0,VALUEHALFD // A0 = Halfword Data Offset
  lh t0,0(a0) // T0 = Test Halfword Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,144,48,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,48,FontBlack,VALUEHALFD,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,328,48,FontBlack,TEXTHALFD,4) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,48,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,48,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG   // A0 = Long Data Offset
  ld t0,0(a0)    // T0 = Long Data
  la a0,LHCHECKD // A0 = Long Check Data Offset
  ld t1,0(a0)    // T1 = Long Check Data
  beq t0,t1,LHPASSD // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,48,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LHENDD
  nop // Delay Slot
  LHPASSD:
  PrintString($A0100000,528,48,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LHENDD:

  la a0,VALUEHALFE // A0 = Halfword Data Offset
  lh t0,0(a0) // T0 = Test Halfword Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,144,56,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,56,FontBlack,VALUEHALFE,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,320,56,FontBlack,TEXTHALFE,5) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,56,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,56,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG   // A0 = Long Data Offset
  ld t0,0(a0)    // T0 = Long Data
  la a0,LHCHECKE // A0 = Long Check Data Offset
  ld t1,0(a0)    // T1 = Long Check Data
  beq t0,t1,LHPASSE // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,56,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LHENDE
  nop // Delay Slot
  LHPASSE:
  PrintString($A0100000,528,56,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LHENDE:

  la a0,VALUEHALFF // A0 = Halfword Data Offset
  lh t0,0(a0) // T0 = Test Halfword Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,144,64,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,64,FontBlack,VALUEHALFF,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,328,64,FontBlack,TEXTHALFF,4) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,64,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,64,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG   // A0 = Long Data Offset
  ld t0,0(a0)    // T0 = Long Data
  la a0,LHCHECKF // A0 = Long Check Data Offset
  ld t1,0(a0)    // T1 = Long Check Data
  beq t0,t1,LHPASSF // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,64,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LHENDF
  nop // Delay Slot
  LHPASSF:
  PrintString($A0100000,528,64,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LHENDF:

  la a0,VALUEHALFG // A0 = Halfword Data Offset
  lh t0,0(a0) // T0 = Test Halfword Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,144,72,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,72,FontBlack,VALUEHALFG,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,320,72,FontBlack,TEXTHALFG,5) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,72,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,72,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG   // A0 = Long Data Offset
  ld t0,0(a0)    // T0 = Long Data
  la a0,LHCHECKG // A0 = Long Check Data Offset
  ld t1,0(a0)    // T1 = Long Check Data
  beq t0,t1,LHPASSG // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,72,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LHENDG
  nop // Delay Slot
  LHPASSG:
  PrintString($A0100000,528,72,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LHENDG:


  PrintString($A0100000,8,88,FontRed,LHU,2) // Print Text String To VRAM Using Font At X,Y Position
  la a0,VALUEHALFA // A0 = Halfword Data Offset
  lhu t0,0(a0) // T0 = Test Halfword Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,144,88,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,88,FontBlack,VALUEHALFA,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,88,FontBlack,TEXTHALFA,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,88,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,88,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG    // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,LHUCHECKA // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,LHUPASSA // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,88,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LHUENDA
  nop // Delay Slot
  LHUPASSA:
  PrintString($A0100000,528,88,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LHUENDA:

  la a0,VALUEHALFB // A0 = Halfword Data Offset
  lhu t0,0(a0) // T0 = Test Halfword Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,144,96,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,96,FontBlack,VALUEHALFB,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,328,96,FontBlack,TEXTHALFB,4) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,96,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,96,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG    // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,LHUCHECKB // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,LHUPASSB // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,96,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LHUENDB
  nop // Delay Slot
  LHUPASSB:
  PrintString($A0100000,528,96,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LHUENDB:

  la a0,VALUEHALFC // A0 = Halfword Data Offset
  lhu t0,0(a0) // T0 = Test Halfword Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,144,104,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,104,FontBlack,VALUEHALFC,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,336,104,FontBlack,TEXTHALFC,3) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,104,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,104,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG    // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,LHUCHECKC // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,LHUPASSC // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,104,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LHUENDC
  nop // Delay Slot
  LHUPASSC:
  PrintString($A0100000,528,104,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LHUENDC:

  la a0,VALUEHALFD // A0 = Halfword Data Offset
  lhu t0,0(a0) // T0 = Test Halfword Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,144,112,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,112,FontBlack,VALUEHALFD,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,328,112,FontBlack,TEXTHALFD,4) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,112,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,112,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG    // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,LHUCHECKD // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,LHUPASSD // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,112,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LHUENDD
  nop // Delay Slot
  LHUPASSD:
  PrintString($A0100000,528,112,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LHUENDD:

  la a0,VALUEHALFE // A0 = Halfword Data Offset
  lhu t0,0(a0) // T0 = Test Halfword Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,144,120,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,120,FontBlack,VALUEHALFE,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,320,120,FontBlack,TEXTHALFE,5) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,120,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,120,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG    // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,LHUCHECKE // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,LHUPASSE // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,120,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LHUENDE
  nop // Delay Slot
  LHUPASSE:
  PrintString($A0100000,528,120,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LHUENDE:

  la a0,VALUEHALFF // A0 = Halfword Data Offset
  lhu t0,0(a0) // T0 = Test Halfword Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,144,128,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,128,FontBlack,VALUEHALFF,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,328,128,FontBlack,TEXTHALFF,4) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,128,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,128,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG    // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,LHUCHECKF // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,LHUPASSF // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,128,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LHUENDF
  nop // Delay Slot
  LHUPASSF:
  PrintString($A0100000,528,128,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LHUENDF:

  la a0,VALUEHALFG // A0 = Halfword Data Offset
  lhu t0,0(a0) // T0 = Test Halfword Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,144,136,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,136,FontBlack,VALUEHALFG,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,320,136,FontBlack,TEXTHALFG,5) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,136,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,136,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG    // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,LHUCHECKG // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,LHUPASSG // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,136,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LHUENDG
  nop // Delay Slot
  LHUPASSG:
  PrintString($A0100000,528,136,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LHUENDG:


  PrintString($A0100000,0,144,FontBlack,PAGEBREAK,79) // Print Text String To VRAM Using Font At X,Y Position


Loop:
  WaitScanline($1E0) // Wait For Scanline To Reach Vertical Blank
  WaitScanline($1E2)

  ori t0,r0,$00000800 // Even Field
  sw t0,VI_Y_SCALE(a0)

  WaitScanline($1E0) // Wait For Scanline To Reach Vertical Blank
  WaitScanline($1E2)

  li t0,$02000800 // Odd Field
  sw t0,VI_Y_SCALE(a0)

  j Loop
  nop // Delay Slot

LH:
  db "LH"
LHU:
  db "LHU"

RTHEX:
  db "RT (Hex)"
HALFHEX:
  db "HALF (Hex)"
HALFDEC:
  db "HALF (Decimal)"
TEST:
  db "Test Result"
FAIL:
  db "FAIL"
PASS:
  db "PASS"

DOLLAR:
  db "$"

TEXTHALFA:
  db "0"
TEXTHALFB:
  db "12345"
TEXTHALFC:
  db "1234"
TEXTHALFD:
  db "12341"
TEXTHALFE:
  db "-12341"
TEXTHALFF:
  db "-1234"
TEXTHALFG:
  db "-12345"

PAGEBREAK:
  db "--------------------------------------------------------------------------------"

align(2) // Align 16-Bit
VALUEHALFA:
  dh 0
VALUEHALFB:
  dh 12345
VALUEHALFC:
  dh 1234
VALUEHALFD:
  dh 12341
VALUEHALFE:
  dh -12341
VALUEHALFF:
  dh -1234
VALUEHALFG:
  dh -12345

align(8) // Align 64-Bit
LHCHECKA:
  dd $0000000000000000
LHCHECKB:
  dd $0000000000003039
LHCHECKC:
  dd $00000000000004D2
LHCHECKD:
  dd $0000000000003035
LHCHECKE:
  dd $FFFFFFFFFFFFCFCB
LHCHECKF:
  dd $FFFFFFFFFFFFFB2E
LHCHECKG:
  dd $FFFFFFFFFFFFCFC7

LHUCHECKA:
  dd $0000000000000000
LHUCHECKB:
  dd $0000000000003039
LHUCHECKC:
  dd $00000000000004D2
LHUCHECKD:
  dd $0000000000003035
LHUCHECKE:
  dd $000000000000CFCB
LHUCHECKF:
  dd $000000000000FB2E
LHUCHECKG:
  dd $000000000000CFC7

RTLONG:
  dd 0

insert FontBlack, "FontBlack8x8.bin"
insert FontGreen, "FontGreen8x8.bin"
insert FontRed, "FontRed8x8.bin"