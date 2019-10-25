// N64 'Bare Metal' CPU Load Doubleword Test Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "CPULD.N64", create
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


  PrintString($A0100000,88,8,FontRed,DWORDHEX,10) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,8,FontRed,DWORDDEC,14) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,384,8,FontRed,RTHEX,7) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,528,8,FontRed,TEST,10) // Print Text String To VRAM Using Font At X,Y Position


  PrintString($A0100000,0,16,FontBlack,PAGEBREAK,79) // Print Text String To VRAM Using Font At X,Y Position


  PrintString($A0100000,8,24,FontRed,LD,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,VALUELONGA // A0 = Long Data Offset
  ld t0,0(a0) // T0 = Test Long Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,80,24,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,24,FontBlack,VALUELONGA,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,24,FontBlack,TEXTLONGA,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,24,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,24,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG   // A0 = Long Data Offset
  ld t0,0(a0)    // T0 = Long Data
  la a0,LDCHECKA // A0 = Long Check Data Offset
  ld t1,0(a0)    // T1 = Long Check Data
  beq t0,t1,LDPASSA // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,24,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LDENDA
  nop // Delay Slot
  LDPASSA:
  PrintString($A0100000,528,24,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LDENDA:

  la a0,VALUELONGB // A0 = Long Data Offset
  ld t0,0(a0) // T0 = Test Long Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,80,32,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,32,FontBlack,VALUELONGB,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,32,FontBlack,TEXTLONGB,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,32,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,32,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG   // A0 = Long Data Offset
  ld t0,0(a0)    // T0 = Long Data
  la a0,LDCHECKB // A0 = Long Check Data Offset
  ld t1,0(a0)    // T1 = Long Check Data
  beq t0,t1,LDPASSB // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,32,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LDENDB
  nop // Delay Slot
  LDPASSB:
  PrintString($A0100000,528,32,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LDENDB:

  la a0,VALUELONGC // A0 = Long Data Offset
  ld t0,0(a0) // T0 = Test Long Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,80,40,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,40,FontBlack,VALUELONGC,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,40,FontBlack,TEXTLONGC,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,40,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,40,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG   // A0 = Long Data Offset
  ld t0,0(a0)    // T0 = Long Data
  la a0,LDCHECKC // A0 = Long Check Data Offset
  ld t1,0(a0)    // T1 = Long Check Data
  beq t0,t1,LDPASSC // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,40,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LDENDC
  nop // Delay Slot
  LDPASSC:
  PrintString($A0100000,528,40,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LDENDC:

  la a0,VALUELONGD // A0 = Long Data Offset
  ld t0,0(a0) // T0 = Test Long Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,80,48,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,48,FontBlack,VALUELONGD,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,48,FontBlack,TEXTLONGD,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,48,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,48,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG   // A0 = Long Data Offset
  ld t0,0(a0)    // T0 = Long Data
  la a0,LDCHECKD // A0 = Long Check Data Offset
  ld t1,0(a0)    // T1 = Long Check Data
  beq t0,t1,LDPASSD // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,48,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LDENDD
  nop // Delay Slot
  LDPASSD:
  PrintString($A0100000,528,48,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LDENDD:

  la a0,VALUELONGE // A0 = Long Data Offset
  ld t0,0(a0) // T0 = Test Long Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,80,56,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,56,FontBlack,VALUELONGE,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,224,56,FontBlack,TEXTLONGE,17) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,56,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,56,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG   // A0 = Long Data Offset
  ld t0,0(a0)    // T0 = Long Data
  la a0,LDCHECKE // A0 = Long Check Data Offset
  ld t1,0(a0)    // T1 = Long Check Data
  beq t0,t1,LDPASSE // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,56,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LDENDE
  nop // Delay Slot
  LDPASSE:
  PrintString($A0100000,528,56,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LDENDE:

  la a0,VALUELONGF // A0 = Long Data Offset
  ld t0,0(a0) // T0 = Test Long Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,80,64,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,64,FontBlack,VALUELONGF,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,280,64,FontBlack,TEXTLONGF,10) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,64,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,64,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG   // A0 = Long Data Offset
  ld t0,0(a0)    // T0 = Long Data
  la a0,LDCHECKF // A0 = Long Check Data Offset
  ld t1,0(a0)    // T1 = Long Check Data
  beq t0,t1,LDPASSF // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,64,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LDENDF
  nop // Delay Slot
  LDPASSF:
  PrintString($A0100000,528,64,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LDENDF:

  la a0,VALUELONGG // A0 = Long Data Offset
  ld t0,0(a0) // T0 = Test Long Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,80,72,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,72,FontBlack,VALUELONGG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,224,72,FontBlack,TEXTLONGG,17) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,72,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,72,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG   // A0 = Long Data Offset
  ld t0,0(a0)    // T0 = Long Data
  la a0,LDCHECKG // A0 = Long Check Data Offset
  ld t1,0(a0)    // T1 = Long Check Data
  beq t0,t1,LDPASSG // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,72,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LDENDG
  nop // Delay Slot
  LDPASSG:
  PrintString($A0100000,528,72,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LDENDG:


  PrintString($A0100000,8,88,FontRed,LDL,2) // Print Text String To VRAM Using Font At X,Y Position
  la a0,VALUELONGB // A0 = Long Data Offset
  ldl t0,0(a0) // T0 = Test Long Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,80,88,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,88,FontBlack,VALUELONGB,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,88,FontBlack,TEXTLONGB,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,88,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,88,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG    // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,LDLCHECKA // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,LDLPASSA // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,88,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LDLENDA
  nop // Delay Slot
  LDLPASSA:
  PrintString($A0100000,528,88,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LDLENDA:

  la a0,VALUELONGB // A0 = Long Data Offset
  ldl t0,1(a0) // T0 = Test Long Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,80,96,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,96,FontBlack,VALUELONGB,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,96,FontBlack,TEXTLONGB,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,96,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,96,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG    // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,LDLCHECKB // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,LDLPASSB // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,96,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LDLENDB
  nop // Delay Slot
  LDLPASSB:
  PrintString($A0100000,528,96,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LDLENDB:

  la a0,VALUELONGB // A0 = Long Data Offset
  ldl t0,2(a0) // T0 = Test Long Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,80,104,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,104,FontBlack,VALUELONGB,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,104,FontBlack,TEXTLONGB,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,104,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,104,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG    // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,LDLCHECKC // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,LDLPASSC // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,104,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LDLENDC
  nop // Delay Slot
  LDLPASSC:
  PrintString($A0100000,528,104,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LDLENDC:

  la a0,VALUELONGB // A0 = Long Data Offset
  ldl t0,3(a0) // T0 = Test Long Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,80,112,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,112,FontBlack,VALUELONGB,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,112,FontBlack,TEXTLONGB,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,112,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,112,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG    // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,LDLCHECKD // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,LDLPASSD // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,112,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LDLENDD
  nop // Delay Slot
  LDLPASSD:
  PrintString($A0100000,528,112,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LDLENDD:

  la a0,VALUELONGB // A0 = Long Data Offset
  ldl t0,4(a0) // T0 = Test Long Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,80,120,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,120,FontBlack,VALUELONGB,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,120,FontBlack,TEXTLONGB,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,120,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,120,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG    // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,LDLCHECKE // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,LDLPASSE // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,120,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LDLENDE
  nop // Delay Slot
  LDLPASSE:
  PrintString($A0100000,528,120,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LDLENDE:

  la a0,VALUELONGB // A0 = Long Data Offset
  ldl t0,5(a0) // T0 = Test Long Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,80,128,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,128,FontBlack,VALUELONGB,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,128,FontBlack,TEXTLONGB,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,128,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,128,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG    // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,LDLCHECKF // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,LDLPASSF // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,128,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LDLENDF
  nop // Delay Slot
  LDLPASSF:
  PrintString($A0100000,528,128,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LDLENDF:

  la a0,VALUELONGB // A0 = Long Data Offset
  ldl t0,6(a0) // T0 = Test Long Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,80,136,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,136,FontBlack,VALUELONGB,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,136,FontBlack,TEXTLONGB,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,136,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,136,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG    // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,LDLCHECKG // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,LDLPASSG // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,136,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LDLENDG
  nop // Delay Slot
  LDLPASSG:
  PrintString($A0100000,528,136,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LDLENDG:

  la a0,VALUELONGB // A0 = Long Data Offset
  ldl t0,7(a0) // T0 = Test Long Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,80,144,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,144,FontBlack,VALUELONGB,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,144,FontBlack,TEXTLONGB,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,144,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,144,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG    // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,LDLCHECKH // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,LDLPASSH // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,144,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LDLENDH
  nop // Delay Slot
  LDLPASSH:
  PrintString($A0100000,528,144,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LDLENDH:

  la a0,VALUELONGG // A0 = Long Data Offset
  ldl t0,0(a0) // T0 = Test Long Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,80,152,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,152,FontBlack,VALUELONGG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,224,152,FontBlack,TEXTLONGG,17) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,152,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,152,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG    // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,LDLCHECKI // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,LDLPASSI // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,152,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LDLENDI
  nop // Delay Slot
  LDLPASSI:
  PrintString($A0100000,528,152,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LDLENDI:

  la a0,VALUELONGG // A0 = Long Data Offset
  ldl t0,1(a0) // T0 = Test Long Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,80,160,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,160,FontBlack,VALUELONGG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,224,160,FontBlack,TEXTLONGG,17) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,160,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,160,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG    // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,LDLCHECKJ // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,LDLPASSJ // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,160,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LDLENDJ
  nop // Delay Slot
  LDLPASSJ:
  PrintString($A0100000,528,160,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LDLENDJ:

  la a0,VALUELONGG // A0 = Long Data Offset
  ldl t0,2(a0) // T0 = Test Long Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,80,168,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,168,FontBlack,VALUELONGG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,224,168,FontBlack,TEXTLONGG,17) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,168,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,168,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG    // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,LDLCHECKK // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,LDLPASSK // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,168,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LDLENDK
  nop // Delay Slot
  LDLPASSK:
  PrintString($A0100000,528,168,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LDLENDK:

  la a0,VALUELONGG // A0 = Long Data Offset
  ldl t0,3(a0) // T0 = Test Long Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,80,176,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,176,FontBlack,VALUELONGG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,224,176,FontBlack,TEXTLONGG,17) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,176,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,176,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG    // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,LDLCHECKL // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,LDLPASSL // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,176,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LDLENDL
  nop // Delay Slot
  LDLPASSL:
  PrintString($A0100000,528,176,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LDLENDL:

  la a0,VALUELONGG // A0 = Long Data Offset
  ldl t0,4(a0) // T0 = Test Long Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,80,184,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,184,FontBlack,VALUELONGG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,224,184,FontBlack,TEXTLONGG,17) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,184,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,184,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG    // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,LDLCHECKM // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,LDLPASSM // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,184,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LDLENDM
  nop // Delay Slot
  LDLPASSM:
  PrintString($A0100000,528,184,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LDLENDM:

  la a0,VALUELONGG // A0 = Long Data Offset
  ldl t0,5(a0) // T0 = Test Long Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,80,192,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,192,FontBlack,VALUELONGG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,224,192,FontBlack,TEXTLONGG,17) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,192,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,192,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG    // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,LDLCHECKN // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,LDLPASSN // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,192,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LDLENDN
  nop // Delay Slot
  LDLPASSN:
  PrintString($A0100000,528,192,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LDLENDN:

  la a0,VALUELONGG // A0 = Long Data Offset
  ldl t0,6(a0) // T0 = Test Long Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,80,200,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,200,FontBlack,VALUELONGG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,224,200,FontBlack,TEXTLONGG,17) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,200,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,200,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG    // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,LDLCHECKO // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,LDLPASSO // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,200,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LDLENDO
  nop // Delay Slot
  LDLPASSO:
  PrintString($A0100000,528,200,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LDLENDO:

  la a0,VALUELONGG // A0 = Long Data Offset
  ldl t0,7(a0) // T0 = Test Long Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,80,208,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,208,FontBlack,VALUELONGG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,224,208,FontBlack,TEXTLONGG,17) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,208,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,208,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG    // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,LDLCHECKP // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,LDLPASSP // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,208,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LDLENDP
  nop // Delay Slot
  LDLPASSP:
  PrintString($A0100000,528,208,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LDLENDP:


  PrintString($A0100000,8,224,FontRed,LDR,2) // Print Text String To VRAM Using Font At X,Y Position
  la a0,VALUELONGB // A0 = Long Data Offset
  ldr t0,0(a0) // T0 = Test Long Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,80,224,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,224,FontBlack,VALUELONGB,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,224,FontBlack,TEXTLONGB,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,224,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,224,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG    // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,LDRCHECKA // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,LDRPASSA // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,224,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LDRENDA
  nop // Delay Slot
  LDRPASSA:
  PrintString($A0100000,528,224,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LDRENDA:

  la a0,VALUELONGB // A0 = Long Data Offset
  ldr t0,1(a0) // T0 = Test Long Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,80,232,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,232,FontBlack,VALUELONGB,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,232,FontBlack,TEXTLONGB,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,232,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,232,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG    // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,LDRCHECKB // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,LDRPASSB // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,232,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LDRENDB
  nop // Delay Slot
  LDRPASSB:
  PrintString($A0100000,528,232,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LDRENDB:

  la a0,VALUELONGB // A0 = Long Data Offset
  ldr t0,2(a0) // T0 = Test Long Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,80,240,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,240,FontBlack,VALUELONGB,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,240,FontBlack,TEXTLONGB,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,240,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,240,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG    // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,LDRCHECKC // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,LDRPASSC // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,240,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LDRENDC
  nop // Delay Slot
  LDRPASSC:
  PrintString($A0100000,528,240,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LDRENDC:

  la a0,VALUELONGB // T0 = Long Data Offset
  ldr t0,3(a0) // T0 = Test Long Data
  la a0,RTLONG // T1 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,80,248,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,248,FontBlack,VALUELONGB,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,248,FontBlack,TEXTLONGB,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,248,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,248,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG    // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,LDRCHECKD // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,LDRPASSD // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,248,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LDRENDD
  nop // Delay Slot
  LDRPASSD:
  PrintString($A0100000,528,248,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LDRENDD:

  la a0,VALUELONGB // A0 = Long Data Offset
  ldr t0,4(a0) // T0 = Test Long Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,80,256,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,256,FontBlack,VALUELONGB,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,256,FontBlack,TEXTLONGB,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,256,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,256,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG    // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,LDRCHECKE // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,LDRPASSE // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,256,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LDRENDE
  nop // Delay Slot
  LDRPASSE:
  PrintString($A0100000,528,256,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LDRENDE:

  la a0,VALUELONGB // A0 = Long Data Offset
  ldr t0,5(a0) // T0 = Test Long Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,80,264,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,264,FontBlack,VALUELONGB,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,264,FontBlack,TEXTLONGB,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,264,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,264,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG    // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,LDRCHECKF // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,LDRPASSF // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,264,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LDRENDF
  nop // Delay Slot
  LDRPASSF:
  PrintString($A0100000,528,264,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LDRENDF:

  la a0,VALUELONGB // A0 = Long Data Offset
  ldr t0,6(a0) // T0 = Test Long Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,80,272,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,272,FontBlack,VALUELONGB,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,272,FontBlack,TEXTLONGB,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,272,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,272,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG    // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,LDRCHECKG // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,LDRPASSG // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,272,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LDRENDG
  nop // Delay Slot
  LDRPASSG:
  PrintString($A0100000,528,272,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LDRENDG:

  la a0,VALUELONGB // A0 = Long Data Offset
  ldr t0,7(a0) // T0 = Test Long Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,80,280,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,280,FontBlack,VALUELONGB,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,280,FontBlack,TEXTLONGB,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,280,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,280,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG    // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,LDRCHECKH // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,LDRPASSH // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,280,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LDRENDH
  nop // Delay Slot
  LDRPASSH:
  PrintString($A0100000,528,280,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LDRENDH:

  la a0,VALUELONGG // A0 = Long Data Offset
  ldr t0,0(a0) // T0 = Test Long Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,80,288,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,288,FontBlack,VALUELONGG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,224,288,FontBlack,TEXTLONGG,17) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,288,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,288,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG    // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,LDRCHECKI // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,LDRPASSI // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,288,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LDRENDI
  nop // Delay Slot
  LDRPASSI:
  PrintString($A0100000,528,288,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LDRENDI:

  la a0,VALUELONGG // A0 = Long Data Offset
  ldr t0,1(a0) // T0 = Test Long Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,80,296,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,296,FontBlack,VALUELONGG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,224,296,FontBlack,TEXTLONGG,17) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,296,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,296,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG    // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,LDRCHECKJ // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,LDRPASSJ // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,296,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LDRENDJ
  nop // Delay Slot
  LDRPASSJ:
  PrintString($A0100000,528,296,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LDRENDJ:

  la a0,VALUELONGG // A0 = Long Data Offset
  ldr t0,2(a0) // T0 = Test Long Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,80,304,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,304,FontBlack,VALUELONGG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,224,304,FontBlack,TEXTLONGG,17) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,304,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,304,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG    // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,LDRCHECKK // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,LDRPASSK // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,304,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LDRENDK
  nop // Delay Slot
  LDRPASSK:
  PrintString($A0100000,528,304,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LDRENDK:

  la a0,VALUELONGG // A0 = Long Data Offset
  ldr t0,3(a0) // T0 = Test Long Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,80,312,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,312,FontBlack,VALUELONGG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,224,312,FontBlack,TEXTLONGG,17) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,312,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,312,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG    // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,LDRCHECKL // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,LDRPASSL // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,312,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LDRENDL
  nop // Delay Slot
  LDRPASSL:
  PrintString($A0100000,528,312,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LDRENDL:

  la a0,VALUELONGG // A0 = Long Data Offset
  ldr t0,4(a0) // T0 = Test Long Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,80,320,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,320,FontBlack,VALUELONGG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,224,320,FontBlack,TEXTLONGG,17) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,320,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,320,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG    // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,LDRCHECKM // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,LDRPASSM // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,320,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LDRENDM
  nop // Delay Slot
  LDRPASSM:
  PrintString($A0100000,528,320,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LDRENDM:

  la a0,VALUELONGG // A0 = Long Data Offset
  ldr t0,5(a0) // T0 = Test Long Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,80,328,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,328,FontBlack,VALUELONGG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,224,328,FontBlack,TEXTLONGG,17) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,328,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,328,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG    // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,LDRCHECKN // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,LDRPASSN // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,328,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LDRENDN
  nop // Delay Slot
  LDRPASSN:
  PrintString($A0100000,528,328,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LDRENDN:

  la a0,VALUELONGG // A0 = Long Data Offset
  ldr t0,6(a0) // T0 = Test Long Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,80,336,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,336,FontBlack,VALUELONGG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,224,336,FontBlack,TEXTLONGG,17) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,336,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,336,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG    // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,LDRCHECKO // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,LDRPASSO // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,336,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LDRENDO
  nop // Delay Slot
  LDRPASSO:
  PrintString($A0100000,528,336,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LDRENDO:

  la a0,VALUELONGG // A0 = Long Data Offset
  ldr t0,7(a0) // T0 = Test Long Data
  la a0,RTLONG // A0 = RTLONG Offset
  sd t0,0(a0)  // RTLONG = Long Data
  PrintString($A0100000,80,344,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,344,FontBlack,VALUELONGG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,224,344,FontBlack,TEXTLONGG,17) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,344,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,344,FontBlack,RTLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RTLONG    // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,LDRCHECKP // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,LDRPASSP // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,344,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j LDRENDP
  nop // Delay Slot
  LDRPASSP:
  PrintString($A0100000,528,344,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  LDRENDP:


  PrintString($A0100000,0,352,FontBlack,PAGEBREAK,79) // Print Text String To VRAM Using Font At X,Y Position


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

LD:
  db "LD"
LDL:
  db "LDL"
LDR:
  db "LDR"

RTHEX:
  db "RT (Hex)"
DWORDHEX:
  db "DWORD (Hex)"
DWORDDEC:
  db "DWORD (Decimal)"
TEST:
  db "Test Result"
FAIL:
  db "FAIL"
PASS:
  db "PASS"

DOLLAR:
  db "$"

TEXTLONGA:
  db "0"
TEXTLONGB:
  db "12345678967891234"
TEXTLONGC:
  db "1234567895"
TEXTLONGD:
  db "12345678912345678"
TEXTLONGE:
  db "-12345678912345678"
TEXTLONGF:
  db "-1234567895"
TEXTLONGG:
  db "-12345678967891234"

PAGEBREAK:
  db "--------------------------------------------------------------------------------"

align(8) // Align 64-Bit
VALUELONGA:
  dd 0
VALUELONGB:
  dd 12345678967891234
VALUELONGC:
  dd 1234567895
VALUELONGD:
  dd 12345678912345678
VALUELONGE:
  dd -12345678912345678
VALUELONGF:
  dd -1234567895
VALUELONGG:
  dd -12345678967891234

align(8) // Align 64-Bit
LDCHECKA:
  dd $0000000000000000
LDCHECKB:
  dd $002BDC5461646522
LDCHECKC:
  dd $00000000499602D7
LDCHECKD:
  dd $002BDC545E14D64E
LDCHECKE:
  dd $FFD423ABA1EB29B2
LDCHECKF:
  dd $FFFFFFFFB669FD29
LDCHECKG:
  dd $FFD423AB9E9B9ADE

LDLCHECKA:
  dd $002BDC5461646522
LDLCHECKB:
  dd $2BDC5461646522FF
LDLCHECKC:
  dd $DC5461646522FFFF
LDLCHECKD:
  dd $5461646522FFFFFF
LDLCHECKE:
  dd $61646522FFFFFFFF
LDLCHECKF:
  dd $646522FFFFFFFFFF
LDLCHECKG:
  dd $6522FFFFFFFFFFFF
LDLCHECKH:
  dd $22FFFFFFFFFFFFFF
LDLCHECKI:
  dd $FFD423AB9E9B9ADE
LDLCHECKJ:
  dd $D423AB9E9B9ADEFF
LDLCHECKK:
  dd $23AB9E9B9ADEFFFF
LDLCHECKL:
  dd $AB9E9B9ADEFFFFFF
LDLCHECKM:
  dd $9E9B9ADEFFFFFFFF
LDLCHECKN:
  dd $9B9ADEFFFFFFFFFF
LDLCHECKO:
  dd $9ADEFFFFFFFFFFFF
LDLCHECKP:
  dd $DEFFFFFFFFFFFFFF

LDRCHECKA:
  dd $FFFFFFFFFFFFFF00
LDRCHECKB:
  dd $FFFFFFFFFFFF002B
LDRCHECKC:
  dd $FFFFFFFFFF002BDC
LDRCHECKD:
  dd $FFFFFFFF002BDC54
LDRCHECKE:
  dd $FFFFFF002BDC5461
LDRCHECKF:
  dd $FFFF002BDC546164
LDRCHECKG:
  dd $FF002BDC54616465
LDRCHECKH:
  dd $002BDC5461646522
LDRCHECKI:
  dd $FFFFFFFFFFFFFFFF
LDRCHECKJ:
  dd $FFFFFFFFFFFFFFD4
LDRCHECKK:
  dd $FFFFFFFFFFFFD423
LDRCHECKL:
  dd $FFFFFFFFFFD423AB
LDRCHECKM:
  dd $FFFFFFFFD423AB9E
LDRCHECKN:
  dd $FFFFFFD423AB9E9B
LDRCHECKO:
  dd $FFFFD423AB9E9B9A
LDRCHECKP:
  dd $FFD423AB9E9B9ADE

RTLONG:
  dd 0

insert FontBlack, "FontBlack8x8.bin"
insert FontGreen, "FontGreen8x8.bin"
insert FontRed, "FontRed8x8.bin"