// N64 'Bare Metal' CPU Signed Doubleword Addition Test Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "CPUDADD.N64", create
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


  PrintString($A0100000,88,8,FontRed,RSRTHEX,10) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,8,FontRed,RSRTDEC,14) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,384,8,FontRed,RDHEX,7) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,528,8,FontRed,TEST,10) // Print Text String To VRAM Using Font At X,Y Position


  PrintString($A0100000,0,16,FontBlack,PAGEBREAK,79) // Print Text String To VRAM Using Font At X,Y Position


  PrintString($A0100000,8,24,FontRed,DADD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,VALUELONGA // A0 = Long Data Offset
  ld t0,0(a0)      // T0 = Long Data
  la a0,VALUELONGB // A0 = Long Data Offset
  ld t1,0(a0)      // T1 = Long Data
  dadd t0,t1 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,24,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,24,FontBlack,VALUELONGA,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,24,FontBlack,TEXTLONGA,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,80,32,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,32,FontBlack,VALUELONGB,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,32,FontBlack,TEXTLONGB,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,32,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,32,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG     // A0 = Long Data Offset
  ld t0,0(a0)      // T0 = Long Data
  la a0,DADDCHECKA // A0 = Long Check Data Offset
  ld t1,0(a0)      // T1 = Long Check Data
  beq t0,t1,DADDPASSA // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,32,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DADDENDA
  nop // Delay Slot
  DADDPASSA:
  PrintString($A0100000,528,32,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DADDENDA:

  la a0,VALUELONGB // A0 = Long Data Offset
  ld t0,0(a0)      // T0 = Long Data
  la a0,VALUELONGC // A0 = Long Data Offset
  ld t1,0(a0)      // T1 = Long Data
  dadd t0,t1 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,48,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,48,FontBlack,VALUELONGB,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,48,FontBlack,TEXTLONGB,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,80,56,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,56,FontBlack,VALUELONGC,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,56,FontBlack,TEXTLONGC,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,56,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,56,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG     // A0 = Long Data Offset
  ld t0,0(a0)      // T0 = Long Data
  la a0,DADDCHECKB // A0 = Long Check Data Offset
  ld t1,0(a0)      // T1 = Long Check Data
  beq t0,t1,DADDPASSB // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,56,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DADDENDB
  nop // Delay Slot
  DADDPASSB:
  PrintString($A0100000,528,56,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DADDENDB:

  la a0,VALUELONGC // A0 = Long Data Offset
  ld t0,0(a0)      // T0 = Long Data
  la a0,VALUELONGD // A0 = Long Data Offset
  ld t1,0(a0)      // T1 = Long Data
  dadd t0,t1 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,72,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,72,FontBlack,VALUELONGC,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,72,FontBlack,TEXTLONGC,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,80,80,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,80,FontBlack,VALUELONGD,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,80,FontBlack,TEXTLONGD,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,80,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,80,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG     // A0 = Long Data Offset
  ld t0,0(a0)      // T0 = Long Data
  la a0,DADDCHECKC // A0 = Long Check Data Offset
  ld t1,0(a0)      // T1 = Long Check Data
  beq t0,t1,DADDPASSC // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,80,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DADDENDC
  nop // Delay Slot
  DADDPASSC:
  PrintString($A0100000,528,80,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DADDENDC:

  la a0,VALUELONGD // A0 = Long Data Offset
  ld t0,0(a0)      // T0 = Long Data
  la a0,VALUELONGE // A0 = Long Data Offset
  ld t1,0(a0)      // T1 = Long Data
  dadd t0,t1 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,96,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,96,FontBlack,VALUELONGD,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,96,FontBlack,TEXTLONGD,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,80,104,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,104,FontBlack,VALUELONGE,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,224,104,FontBlack,TEXTLONGE,17) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,104,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,104,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG     // A0 = Long Data Offset
  ld t0,0(a0)      // T0 = Long Data
  la a0,DADDCHECKD // A0 = Long Check Data Offset
  ld t1,0(a0)      // T1 = Long Check Data
  beq t0,t1,DADDPASSD // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,104,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DADDENDD
  nop // Delay Slot
  DADDPASSD:
  PrintString($A0100000,528,104,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DADDENDD:

  la a0,VALUELONGE // A0 = Long Data Offset
  ld t0,0(a0)      // T0 = Long Data
  la a0,VALUELONGF // A0 = Long Data Offset
  ld t1,0(a0)      // T1 = Long Data
  dadd t0,t1 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,120,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,120,FontBlack,VALUELONGE,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,224,120,FontBlack,TEXTLONGE,17) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,80,128,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,128,FontBlack,VALUELONGF,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,280,128,FontBlack,TEXTLONGF,10) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,128,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,128,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG     // A0 = Long Data Offset
  ld t0,0(a0)      // T0 = Long Data
  la a0,DADDCHECKE // A0 = Long Check Data Offset
  ld t1,0(a0)      // T1 = Long Check Data
  beq t0,t1,DADDPASSE // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,128,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DADDENDE
  nop // Delay Slot
  DADDPASSE:
  PrintString($A0100000,528,128,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DADDENDE:

  la a0,VALUELONGF // A0 = Long Data Offset
  ld t0,0(a0)      // T0 = Long Data
  la a0,VALUELONGG // A0 = Long Data Offset
  ld t1,0(a0)      // T1 = Long Data
  dadd t0,t1 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,144,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,144,FontBlack,VALUELONGF,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,280,144,FontBlack,TEXTLONGF,10) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,80,152,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,152,FontBlack,VALUELONGG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,224,152,FontBlack,TEXTLONGG,17) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,152,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,152,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG     // A0 = Long Data Offset
  ld t0,0(a0)      // T0 = Long Data
  la a0,DADDCHECKF // A0 = Long Check Data Offset
  ld t1,0(a0)      // T1 = Long Check Data
  beq t0,t1,DADDPASSF // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,152,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DADDENDF
  nop // Delay Slot
  DADDPASSF:
  PrintString($A0100000,528,152,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DADDENDF:

  la a0,VALUELONGA // A0 = Long Data Offset
  ld t0,0(a0)      // T0 = Long Data
  la a0,VALUELONGG // A0 = Long Data Offset
  ld t1,0(a0)      // T1 = Long Data
  dadd t0,t1 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,168,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,168,FontBlack,VALUELONGA,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,168,FontBlack,TEXTLONGA,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,80,176,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,176,FontBlack,VALUELONGG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,224,176,FontBlack,TEXTLONGG,17) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,176,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,176,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG     // A0 = Long Data Offset
  ld t0,0(a0)      // T0 = Long Data
  la a0,DADDCHECKG // A0 = Long Check Data Offset
  ld t1,0(a0)      // T1 = Long Check Data
  beq t0,t1,DADDPASSG // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,176,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DADDENDG
  nop // Delay Slot
  DADDPASSG:
  PrintString($A0100000,528,176,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DADDENDG:


  PrintString($A0100000,8,192,FontRed,DADDI,4) // Print Text String To VRAM Using Font At X,Y Position
  la a0,VALUELONGA // A0 = Long Data Offset
  ld t0,0(a0)      // T0 = Long Data
  daddi t0,VALUEILONGB // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,192,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,192,FontBlack,VALUELONGA,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,192,FontBlack,TEXTLONGA,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,80,200,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,200,FontBlack,ILONGB,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,328,200,FontBlack,TEXTILONGB,4) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,200,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,200,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG      // A0 = Long Data Offset
  ld t0,0(a0)       // T0 = Long Data
  la a0,DADDICHECKA // A0 = Long Check Data Offset
  ld t1,0(a0)       // T1 = Long Check Data
  beq t0,t1,DADDIPASSA // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,200,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DADDIENDA
  nop // Delay Slot
  DADDIPASSA:
  PrintString($A0100000,528,200,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DADDIENDA:

  la a0,VALUELONGB // A0 = Long Data Offset
  ld t0,0(a0)      // T0 = Long Data
  daddi t0,VALUEILONGC // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,216,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,216,FontBlack,VALUELONGB,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,216,FontBlack,TEXTLONGB,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,80,224,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,224,FontBlack,ILONGC,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,336,224,FontBlack,TEXTILONGC,3) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,224,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,224,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG      // A0 = Long Data Offset
  ld t0,0(a0)       // T0 = Long Data
  la a0,DADDICHECKB // A0 = Long Check Data Offset
  ld t1,0(a0)       // T1 = Long Check Data
  beq t0,t1,DADDIPASSB // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,224,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DADDIENDB
  nop // Delay Slot
  DADDIPASSB:
  PrintString($A0100000,528,224,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DADDIENDB:

  la a0,VALUELONGC // A0 = Long Data Offset
  ld t0,0(a0)      // T0 = Long Data
  daddi t0,VALUEILONGD // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,240,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,240,FontBlack,VALUELONGC,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,240,FontBlack,TEXTLONGC,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,80,248,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,248,FontBlack,ILONGD,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,328,248,FontBlack,TEXTILONGD,4) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,248,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,248,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG      // A0 = Long Data Offset
  ld t0,0(a0)       // T0 = Long Data
  la a0,DADDICHECKC // A0 = Long Check Data Offset
  ld t1,0(a0)       // T1 = Long Check Data
  beq t0,t1,DADDIPASSC // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,248,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DADDIENDC
  nop // Delay Slot
  DADDIPASSC:
  PrintString($A0100000,528,248,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DADDIENDC:

  la a0,ILONGD // A0 = Long Data Offset
  ld t0,0(a0)  // T0 = Long Data
  daddi t0,VALUEILONGE // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,264,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,264,FontBlack,ILONGD,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,328,264,FontBlack,TEXTILONGD,4) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,80,272,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,272,FontBlack,ILONGE,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,320,272,FontBlack,TEXTILONGE,5) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,272,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,272,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG      // A0 = Long Data Offset
  ld t0,0(a0)       // T0 = Long Data
  la a0,DADDICHECKD // A0 = Long Check Data Offset
  ld t1,0(a0)       // T1 = Long Check Data
  beq t0,t1,DADDIPASSD // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,272,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DADDIENDD
  nop // Delay Slot
  DADDIPASSD:
  PrintString($A0100000,528,272,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DADDIENDD:

  la a0,VALUELONGE // A0 = Long Data Offset
  ld t0,0(a0)      // T0 = Long Data
  daddi t0,VALUEILONGF // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,288,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,288,FontBlack,VALUELONGE,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,224,288,FontBlack,TEXTLONGE,17) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,80,296,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,296,FontBlack,ILONGF,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,328,296,FontBlack,TEXTILONGF,4) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,296,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,296,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG      // A0 = Long Data Offset
  ld t0,0(a0)       // T0 = Long Data
  la a0,DADDICHECKE // A0 = Long Check Data Offset
  ld t1,0(a0)       // T1 = Long Check Data
  beq t0,t1,DADDIPASSE // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,296,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DADDIENDE
  nop // Delay Slot
  DADDIPASSE:
  PrintString($A0100000,528,296,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DADDIENDE:

  la a0,VALUELONGF // A0 = Long Data Offset
  ld t0,0(a0)      // T0 = Long Data
  daddi t0,VALUEILONGG // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,312,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,312,FontBlack,VALUELONGF,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,280,312,FontBlack,TEXTLONGF,10) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,80,320,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,320,FontBlack,ILONGG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,320,320,FontBlack,TEXTILONGG,5) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,320,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,320,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG      // A0 = Long Data Offset
  ld t0,0(a0)       // T0 = Long Data
  la a0,DADDICHECKF // A0 = Long Check Data Offset
  ld t1,0(a0)       // T1 = Long Check Data
  beq t0,t1,DADDIPASSF // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,320,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DADDIENDF
  nop // Delay Slot
  DADDIPASSF:
  PrintString($A0100000,528,320,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DADDIENDF:

  la a0,VALUELONGA // A0 = Long Data Offset
  ld t0,0(a0)      // T0 = Long Data
  daddi t0,VALUEILONGG // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,336,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,336,FontBlack,VALUELONGA,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,336,FontBlack,TEXTLONGA,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,80,344,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,344,FontBlack,ILONGG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,320,344,FontBlack,TEXTILONGG,5) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,344,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,344,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG      // A0 = Long Data Offset
  ld t0,0(a0)       // T0 = Long Data
  la a0,DADDICHECKG // A0 = Long Check Data Offset
  ld t1,0(a0)       // T1 = Long Check Data
  beq t0,t1,DADDIPASSG // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,344,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DADDIENDG
  nop // Delay Slot
  DADDIPASSG:
  PrintString($A0100000,528,344,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DADDIENDG:


  PrintString($A0100000,0,352,FontBlack,PAGEBREAK,79) // Print Text String To VRAM Using Font At X,Y Position


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

DADD:
  db "DADD"
DADDI:
  db "DADDI"

RDHEX:
  db "RD (Hex)"
RSRTHEX:
  db "RS/RT (Hex)"
RSRTDEC:
  db "RS/RT (Decimal)"
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

TEXTILONGB:
  db "12345"
TEXTILONGC:
  db "1234"
TEXTILONGD:
  db "12341"
TEXTILONGE:
  db "-12341"
TEXTILONGF:
  db "-1234"
TEXTILONGG:
  db "-12345"

PAGEBREAK:
  db "--------------------------------------------------------------------------------"

align(8) // Align 64-Bit
VALUELONGA:
  dq 0
VALUELONGB:
  dq 12345678967891234
VALUELONGC:
  dq 1234567895
VALUELONGD:
  dq 12345678912345678
VALUELONGE:
  dq -12345678912345678
VALUELONGF:
  dq -1234567895
VALUELONGG:
  dq -12345678967891234

DADDCHECKA:
  dq $002BDC5461646522
DADDCHECKB:
  dq $002BDC54AAFA67F9
DADDCHECKC:
  dq $002BDC54A7AAD925
DADDCHECKD:
  dq $0000000000000000
DADDCHECKE:
  dq $FFD423AB585526DB
DADDCHECKF:
  dq $FFD423AB55059807
DADDCHECKG:
  dq $FFD423AB9E9B9ADE

constant VALUEILONGB(12345)
constant VALUEILONGC(1234)
constant VALUEILONGD(12341)
constant VALUEILONGE(-12341)
constant VALUEILONGF(-1234)
constant VALUEILONGG(-12345)
ILONGB:
  dq 12345
ILONGC:
  dq 1234
ILONGD:
  dq 12341
ILONGE:
  dq -12341
ILONGF:
  dq -1234
ILONGG:
  dq -12345

DADDICHECKA:
  dq $0000000000003039
DADDICHECKB:
  dq $002BDC54616469F4
DADDICHECKC:
  dq $000000004996330C
DADDICHECKD:
  dq $0000000000000000
DADDICHECKE:
  dq $FFD423ABA1EB24E0
DADDICHECKF:
  dq $FFFFFFFFB669CCF0
DADDICHECKG:
  dq $FFFFFFFFFFFFCFC7

RDLONG:
  dq 0

insert FontBlack, "FontBlack8x8.bin"
insert FontGreen, "FontGreen8x8.bin"
insert FontRed, "FontRed8x8.bin"