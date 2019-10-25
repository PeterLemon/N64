// N64 'Bare Metal' CPU Store Doubleword Test Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "CPUSD.N64", create
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


  PrintString($A0100000,88,8,FontRed,RTHEX,7) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,8,FontRed,RTDEC,11) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,384,8,FontRed,DWORDHEX,10) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,528,8,FontRed,TEST,10) // Print Text String To VRAM Using Font At X,Y Position


  PrintString($A0100000,0,16,FontBlack,PAGEBREAK,79) // Print Text String To VRAM Using Font At X,Y Position


  PrintString($A0100000,8,24,FontRed,SD,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,VALUELONGA // A0 = Long Data Offset
  ld t0,0(a0) // T0 = Test Long Data
  la a0,DWORD // A0 = DWORD Offset
  sd t0,0(a0) // DWORD = Long Data
  PrintString($A0100000,80,24,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,24,FontBlack,VALUELONGA,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,24,FontBlack,TEXTLONGA,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,24,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,24,FontBlack,DWORD,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,DWORD    // A0 = Long Data Offset
  ld t0,0(a0)    // T0 = Long Data
  la a0,SDCHECKA // A0 = Long Check Data Offset
  ld t1,0(a0)    // T1 = Long Check Data
  beq t0,t1,SDPASSA // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,24,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SDENDA
  nop // Delay Slot
  SDPASSA:
  PrintString($A0100000,528,24,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SDENDA:

  la a0,VALUELONGB // A0 = Long Data Offset
  ld t0,0(a0) // T0 = Test Long Data
  la a0,DWORD // A0 = RTWORD Offset
  sd t0,0(a0) // DWORD = Long Data
  PrintString($A0100000,80,32,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,32,FontBlack,VALUELONGB,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,32,FontBlack,TEXTLONGB,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,32,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,32,FontBlack,DWORD,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,DWORD    // A0 = Long Data Offset
  ld t0,0(a0)    // T0 = Long Data
  la a0,SDCHECKB // A0 = Long Check Data Offset
  ld t1,0(a0)    // T1 = Long Check Data
  beq t0,t1,SDPASSB // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,32,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SDENDB
  nop // Delay Slot
  SDPASSB:
  PrintString($A0100000,528,32,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SDENDB:

  la a0,VALUELONGC // A0 = Long Data Offset
  ld t0,0(a0) // T0 = Test Long Data
  la a0,DWORD // A0 = DWORD Offset
  sd t0,0(a0) // DWORD = Long Data
  PrintString($A0100000,80,40,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,40,FontBlack,VALUELONGC,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,40,FontBlack,TEXTLONGC,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,40,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,40,FontBlack,DWORD,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,DWORD    // A0 = Long Data Offset
  ld t0,0(a0)    // T0 = Long Data
  la a0,SDCHECKC // A0 = Long Check Data Offset
  ld t1,0(a0)    // T1 = Long Check Data
  beq t0,t1,SDPASSC // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,40,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SDENDC
  nop // Delay Slot
  SDPASSC:
  PrintString($A0100000,528,40,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SDENDC:

  la a0,VALUELONGD // A0 = Long Data Offset
  ld t0,0(a0) // T0 = Test Long Data
  la a0,DWORD // A0 = DWORD Offset
  sd t0,0(a0) // DWORD = Long Data
  PrintString($A0100000,80,48,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,48,FontBlack,VALUELONGD,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,48,FontBlack,TEXTLONGD,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,48,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,48,FontBlack,DWORD,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,DWORD    // A0 = Long Data Offset
  ld t0,0(a0)    // T0 = Long Data
  la a0,SDCHECKD // A0 = Long Check Data Offset
  ld t1,0(a0)    // T1 = Long Check Data
  beq t0,t1,SDPASSD // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,48,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SDENDD
  nop // Delay Slot
  SDPASSD:
  PrintString($A0100000,528,48,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SDENDD:

  la a0,VALUELONGE // A0 = Long Data Offset
  ld t0,0(a0) // T0 = Test Long Data
  la a0,DWORD // A0 = DWORD Offset
  sd t0,0(a0) // DWORD = Long Data
  PrintString($A0100000,80,56,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,56,FontBlack,VALUELONGE,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,224,56,FontBlack,TEXTLONGE,17) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,56,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,56,FontBlack,DWORD,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,DWORD    // A0 = Long Data Offset
  ld t0,0(a0)    // T0 = Long Data
  la a0,SDCHECKE // A0 = Long Check Data Offset
  ld t1,0(a0)    // T1 = Long Check Data
  beq t0,t1,SDPASSE // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,56,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SDENDE
  nop // Delay Slot
  SDPASSE:
  PrintString($A0100000,528,56,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SDENDE:

  la a0,VALUELONGF // A0 = Long Data Offset
  ld t0,0(a0) // T0 = Test Long Data
  la a0,DWORD // A0 = DWORD Offset
  sd t0,0(a0) // DWORD = Long Data
  PrintString($A0100000,80,64,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,64,FontBlack,VALUELONGF,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,280,64,FontBlack,TEXTLONGF,10) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,64,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,64,FontBlack,DWORD,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,DWORD    // A0 = Long Data Offset
  ld t0,0(a0)    // T0 = Long Data
  la a0,SDCHECKF // A0 = Long Check Data Offset
  ld t1,0(a0)    // T1 = Long Check Data
  beq t0,t1,SDPASSF // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,64,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SDENDF
  nop // Delay Slot
  SDPASSF:
  PrintString($A0100000,528,64,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SDENDF:

  la a0,VALUELONGG // A0 = Long Data Offset
  ld t0,0(a0) // T0 = Test Long Data
  la a0,DWORD // A0 = DWORD Offset
  sd t0,0(a0) // DWORD = Long Data
  PrintString($A0100000,80,72,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,72,FontBlack,VALUELONGG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,224,72,FontBlack,TEXTLONGG,17) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,72,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,72,FontBlack,DWORD,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,DWORD    // A0 = Long Data Offset
  ld t0,0(a0)    // T0 = Long Data
  la a0,SDCHECKG // A0 = Long Check Data Offset
  ld t1,0(a0)    // T1 = Long Check Data
  beq t0,t1,SDPASSG // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,72,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SDENDG
  nop // Delay Slot
  SDPASSG:
  PrintString($A0100000,528,72,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SDENDG:


  PrintString($A0100000,8,88,FontRed,SDL,2) // Print Text String To VRAM Using Font At X,Y Position
  la a0,VALUELONGB // A0 = Long Data Offset
  ld t0,0(a0)  // T0 = Test Long Data
  la a0,DWORD  // A0 = DWORD Offset
  sdl t0,0(a0) // DWORD = Long Data
  PrintString($A0100000,80,88,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,88,FontBlack,VALUELONGB,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,88,FontBlack,TEXTLONGB,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,88,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,88,FontBlack,DWORD,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,DWORD     // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,SDLCHECKA // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,SDLPASSA // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,88,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SDLENDA
  nop // Delay Slot
  SDLPASSA:
  PrintString($A0100000,528,88,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SDLENDA:

  la a0,VALUELONGB // A0 = Long Data Offset
  ld t0,0(a0)  // T0 = Test Long Data
  la a0,DWORD  // A0 = DWORD Offset
  sdl t0,1(a0) // DWORD = Long Data
  PrintString($A0100000,80,96,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,96,FontBlack,VALUELONGB,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,96,FontBlack,TEXTLONGB,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,96,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,96,FontBlack,DWORD,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,DWORD     // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,SDLCHECKB // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,SDLPASSB // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,96,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SDLENDB
  nop // Delay Slot
  SDLPASSB:
  PrintString($A0100000,528,96,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SDLENDB:

  la a0,VALUELONGB // A0 = Long Data Offset
  ld t0,0(a0)  // T0 = Test Long Data
  la a0,DWORD  // A0 = DWORD Offset
  sdl t0,2(a0) // DWORD = Long Data
  PrintString($A0100000,80,104,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,104,FontBlack,VALUELONGB,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,104,FontBlack,TEXTLONGB,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,104,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,104,FontBlack,DWORD,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,DWORD     // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,SDLCHECKC // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,SDLPASSC // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,104,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SDLENDC
  nop // Delay Slot
  SDLPASSC:
  PrintString($A0100000,528,104,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SDLENDC:

  la a0,VALUELONGB // A0 = Long Data Offset
  ld t0,0(a0)  // T0 = Test Long Data
  la a0,DWORD  // A0 = DWORD Offset
  sdl t0,3(a0) // DWORD = Long Data
  PrintString($A0100000,80,112,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,112,FontBlack,VALUELONGB,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,112,FontBlack,TEXTLONGB,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,112,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,112,FontBlack,DWORD,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,DWORD     // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,SDLCHECKD // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,SDLPASSD // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,112,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SDLENDD
  nop // Delay Slot
  SDLPASSD:
  PrintString($A0100000,528,112,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SDLENDD:

  la a0,VALUELONGB // A0 = Long Data Offset
  ld t0,0(a0)  // T0 = Test Long Data
  la a0,DWORD  // A0 = DWORD Offset
  sdl t0,4(a0) // DWORD = Long Data
  PrintString($A0100000,80,120,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,120,FontBlack,VALUELONGB,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,120,FontBlack,TEXTLONGB,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,120,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,120,FontBlack,DWORD,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,DWORD     // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,SDLCHECKE // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,SDLPASSE // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,120,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SDLENDE
  nop // Delay Slot
  SDLPASSE:
  PrintString($A0100000,528,120,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SDLENDE:

  la a0,VALUELONGB // A0 = Long Data Offset
  ld t0,0(a0)  // T0 = Test Long Data
  la a0,DWORD  // A0 = DWORD Offset
  sdl t0,5(a0) // DWORD = Long Data
  PrintString($A0100000,80,128,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,128,FontBlack,VALUELONGB,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,128,FontBlack,TEXTLONGB,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,128,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,128,FontBlack,DWORD,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,DWORD     // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,SDLCHECKF // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,SDLPASSF // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,128,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SDLENDF
  nop // Delay Slot
  SDLPASSF:
  PrintString($A0100000,528,128,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SDLENDF:

  la a0,VALUELONGB // A0 = Long Data Offset
  ld t0,0(a0)  // T0 = Test Long Data
  la a0,DWORD  // A0 = DWORD Offset
  sdl t0,6(a0) // DWORD = Long Data
  PrintString($A0100000,80,136,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,136,FontBlack,VALUELONGB,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,136,FontBlack,TEXTLONGB,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,136,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,136,FontBlack,DWORD,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,DWORD     // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,SDLCHECKG // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,SDLPASSG // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,136,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SDLENDG
  nop // Delay Slot
  SDLPASSG:
  PrintString($A0100000,528,136,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SDLENDG:

  la a0,VALUELONGB // A0 = Long Data Offset
  ld t0,0(a0)  // T0 = Test Long Data
  la a0,DWORD  // A0 = DWORD Offset
  sdl t0,7(a0) // DWORD = Long Data
  PrintString($A0100000,80,144,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,144,FontBlack,VALUELONGB,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,144,FontBlack,TEXTLONGB,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,144,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,144,FontBlack,DWORD,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,DWORD     // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,SDLCHECKH // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,SDLPASSH // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,144,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SDLENDH
  nop // Delay Slot
  SDLPASSH:
  PrintString($A0100000,528,144,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SDLENDH:

  la a0,VALUELONGG // A0 = Long Data Offset
  ld t0,0(a0)  // T0 = Test Long Data
  la a0,DWORD  // A0 = DWORD Offset
  sdl t0,0(a0) // DWORD = Long Data
  PrintString($A0100000,80,152,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,152,FontBlack,VALUELONGG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,224,152,FontBlack,TEXTLONGG,17) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,152,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,152,FontBlack,DWORD,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,DWORD     // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,SDLCHECKI // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,SDLPASSI // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,152,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SDLENDI
  nop // Delay Slot
  SDLPASSI:
  PrintString($A0100000,528,152,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SDLENDI:

  la a0,VALUELONGG // A0 = Long Data Offset
  ld t0,0(a0)  // T0 = Test Long Data
  la a0,DWORD  // A0 = DWORD Offset
  sdl t0,1(a0) // DWORD = Long Data
  PrintString($A0100000,80,160,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,160,FontBlack,VALUELONGG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,224,160,FontBlack,TEXTLONGG,17) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,160,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,160,FontBlack,DWORD,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,DWORD     // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,SDLCHECKJ // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,SDLPASSJ // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,160,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SDLENDJ
  nop // Delay Slot
  SDLPASSJ:
  PrintString($A0100000,528,160,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SDLENDJ:

  la a0,VALUELONGG // A0 = Long Data Offset
  ld t0,0(a0)  // T0 = Test Long Data
  la a0,DWORD  // A0 = DWORD Offset
  sdl t0,2(a0) // DWORD = Long Data
  PrintString($A0100000,80,168,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,168,FontBlack,VALUELONGG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,224,168,FontBlack,TEXTLONGG,17) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,168,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,168,FontBlack,DWORD,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,DWORD     // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,SDLCHECKK // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,SDLPASSK // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,168,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SDLENDK
  nop // Delay Slot
  SDLPASSK:
  PrintString($A0100000,528,168,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SDLENDK:

  la a0,VALUELONGG // A0 = Long Data Offset
  ld t0,0(a0)  // T0 = Test Long Data
  la a0,DWORD  // A0 = DWORD Offset
  sdl t0,3(a0) // DWORD = Long Data
  PrintString($A0100000,80,176,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,176,FontBlack,VALUELONGG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,224,176,FontBlack,TEXTLONGG,17) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,176,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,176,FontBlack,DWORD,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,DWORD     // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,SDLCHECKL // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,SDLPASSL // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,176,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SDLENDL
  nop // Delay Slot
  SDLPASSL:
  PrintString($A0100000,528,176,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SDLENDL:

  la a0,VALUELONGG // A0 = Long Data Offset
  ld t0,0(a0)  // T0 = Test Long Data
  la a0,DWORD  // A0 = DWORD Offset
  sdl t0,4(a0) // DWORD = Long Data
  PrintString($A0100000,80,184,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,184,FontBlack,VALUELONGG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,224,184,FontBlack,TEXTLONGG,17) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,184,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,184,FontBlack,DWORD,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,DWORD     // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,SDLCHECKM // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,SDLPASSM // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,184,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SDLENDM
  nop // Delay Slot
  SDLPASSM:
  PrintString($A0100000,528,184,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SDLENDM:

  la a0,VALUELONGG // A0 = Long Data Offset
  ld t0,0(a0)  // T0 = Test Long Data
  la a0,DWORD  // A0 = DWORD Offset
  sdl t0,5(a0) // DWORD = Long Data
  PrintString($A0100000,80,192,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,192,FontBlack,VALUELONGG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,224,192,FontBlack,TEXTLONGG,17) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,192,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,192,FontBlack,DWORD,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,DWORD     // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,SDLCHECKN // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,SDLPASSN // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,192,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SDLENDN
  nop // Delay Slot
  SDLPASSN:
  PrintString($A0100000,528,192,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SDLENDN:

  la a0,VALUELONGG // A0 = Long Data Offset
  ld t0,0(a0)  // T0 = Test Long Data
  la a0,DWORD  // A0 = DWORD Offset
  sdl t0,6(a0) // DWORD = Long Data
  PrintString($A0100000,80,200,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,200,FontBlack,VALUELONGG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,224,200,FontBlack,TEXTLONGG,17) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,200,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,200,FontBlack,DWORD,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,DWORD     // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,SDLCHECKO // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,SDLPASSO // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,200,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SDLENDO
  nop // Delay Slot
  SDLPASSO:
  PrintString($A0100000,528,200,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SDLENDO:

  la a0,VALUELONGG // A0 = Long Data Offset
  ld t0,0(a0)  // T0 = Test Long Data
  la a0,DWORD  // A0 = DWORD Offset
  sdl t0,7(a0) // DWORD = Long Data
  PrintString($A0100000,80,208,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,208,FontBlack,VALUELONGG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,224,208,FontBlack,TEXTLONGG,17) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,208,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,208,FontBlack,DWORD,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,DWORD     // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,SDLCHECKP // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,SDLPASSP // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,208,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SDLENDP
  nop // Delay Slot
  SDLPASSP:
  PrintString($A0100000,528,208,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SDLENDP:


  PrintString($A0100000,8,224,FontRed,SDR,2) // Print Text String To VRAM Using Font At X,Y Position
  la a0,VALUELONGB // A0 = Long Data Offset
  ld t0,0(a0)  // T0 = Test Long Data
  la a0,DWORD  // A0 = DWORD Offset
  sdr t0,0(a0) // DWORD = Long Data
  PrintString($A0100000,80,224,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,224,FontBlack,VALUELONGB,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,224,FontBlack,TEXTLONGB,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,224,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,224,FontBlack,DWORD,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,DWORD     // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,SDRCHECKA // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,SDRPASSA // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,224,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SDRENDA
  nop // Delay Slot
  SDRPASSA:
  PrintString($A0100000,528,224,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SDRENDA:

  la a0,VALUELONGB // A0 = Long Data Offset
  ld t0,0(a0)  // T0 = Test Long Data
  la a0,DWORD  // A0 = DWORD Offset
  sdr t0,1(a0) // DWORD = Long Data
  PrintString($A0100000,80,232,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,232,FontBlack,VALUELONGB,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,232,FontBlack,TEXTLONGB,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,232,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,232,FontBlack,DWORD,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,DWORD     // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,SDRCHECKB // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,SDRPASSB // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,232,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SDRENDB
  nop // Delay Slot
  SDRPASSB:
  PrintString($A0100000,528,232,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SDRENDB:

  la a0,VALUELONGB // A0 = Long Data Offset
  ld t0,0(a0)  // T0 = Test Long Data
  la a0,DWORD  // A0 = DWORD Offset
  sdr t0,2(a0) // DWORD = Long Data
  PrintString($A0100000,80,240,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,240,FontBlack,VALUELONGB,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,240,FontBlack,TEXTLONGB,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,240,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,240,FontBlack,DWORD,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,DWORD     // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,SDRCHECKC // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,SDRPASSC // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,240,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SDRENDC
  nop // Delay Slot
  SDRPASSC:
  PrintString($A0100000,528,240,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SDRENDC:

  la a0,VALUELONGB // A0 = Long Data Offset
  ld t0,0(a0)  // T0 = Test Long Data
  la a0,DWORD  // A0 = DWORD Offset
  sdr t0,3(a0) // DWORD = Long Data
  PrintString($A0100000,80,248,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,248,FontBlack,VALUELONGB,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,248,FontBlack,TEXTLONGB,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,248,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,248,FontBlack,DWORD,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,DWORD     // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,SDRCHECKD // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,SDRPASSD // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,248,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SDRENDD
  nop // Delay Slot
  SDRPASSD:
  PrintString($A0100000,528,248,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SDRENDD:

  la a0,VALUELONGB // A0 = Long Data Offset
  ld t0,0(a0)  // T0 = Test Long Data
  la a0,DWORD  // A0 = DWORD Offset
  sdr t0,4(a0) // DWORD = Long Data
  PrintString($A0100000,80,256,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,256,FontBlack,VALUELONGB,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,256,FontBlack,TEXTLONGB,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,256,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,256,FontBlack,DWORD,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,DWORD     // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,SDRCHECKE // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,SDRPASSE // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,256,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SDRENDE
  nop // Delay Slot
  SDRPASSE:
  PrintString($A0100000,528,256,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SDRENDE:

  la a0,VALUELONGB // A0 = Long Data Offset
  ld t0,0(a0)  // T0 = Test Long Data
  la a0,DWORD  // A0 = DWORD Offset
  sdr t0,5(a0) // DWORD = Long Data
  PrintString($A0100000,80,264,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,264,FontBlack,VALUELONGB,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,264,FontBlack,TEXTLONGB,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,264,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,264,FontBlack,DWORD,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,DWORD     // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,SDRCHECKF // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,SDRPASSF // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,264,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SDRENDF
  nop // Delay Slot
  SDRPASSF:
  PrintString($A0100000,528,264,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SDRENDF:

  la a0,VALUELONGB // A0 = Long Data Offset
  ld t0,0(a0)  // T0 = Test Long Data
  la a0,DWORD  // A0 = DWORD Offset
  sdr t0,6(a0) // DWORD = Long Data
  PrintString($A0100000,80,272,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,272,FontBlack,VALUELONGB,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,272,FontBlack,TEXTLONGB,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,272,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,272,FontBlack,DWORD,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,DWORD     // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,SDRCHECKG // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,SDRPASSG // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,272,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SDRENDG
  nop // Delay Slot
  SDRPASSG:
  PrintString($A0100000,528,272,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SDRENDG:

  la a0,VALUELONGB // A0 = Long Data Offset
  ld t0,0(a0)  // T0 = Test Long Data
  la a0,DWORD  // A0 = DWORD Offset
  sdr t0,7(a0) // DWORD = Long Data
  PrintString($A0100000,80,280,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,280,FontBlack,VALUELONGB,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,280,FontBlack,TEXTLONGB,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,280,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,280,FontBlack,DWORD,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,DWORD     // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,SDRCHECKH // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,SDRPASSH // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,280,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SDRENDH
  nop // Delay Slot
  SDRPASSH:
  PrintString($A0100000,528,280,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SDRENDH:

  la a0,VALUELONGG // A0 = Long Data Offset
  ld t0,0(a0)  // T0 = Test Long Data
  la a0,DWORD  // A0 = DWORD Offset
  sdr t0,0(a0) // DWORD = Long Data
  PrintString($A0100000,80,288,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,288,FontBlack,VALUELONGG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,224,288,FontBlack,TEXTLONGG,17) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,288,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,288,FontBlack,DWORD,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,DWORD     // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,SDRCHECKI // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,SDRPASSI // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,288,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SDRENDI
  nop // Delay Slot
  SDRPASSI:
  PrintString($A0100000,528,288,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SDRENDI:

  la a0,VALUELONGG // A0 = Long Data Offset
  ld t0,0(a0)  // T0 = Test Long Data
  la a0,DWORD  // A0 = DWORD Offset
  sdr t0,1(a0) // DWORD = Long Data
  PrintString($A0100000,80,296,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,296,FontBlack,VALUELONGG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,224,296,FontBlack,TEXTLONGG,17) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,296,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,296,FontBlack,DWORD,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,DWORD     // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,SDRCHECKJ // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,SDRPASSJ // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,296,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SDRENDJ
  nop // Delay Slot
  SDRPASSJ:
  PrintString($A0100000,528,296,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SDRENDJ:

  la a0,VALUELONGG // A0 = Long Data Offset
  ld t0,0(a0)  // T0 = Test Long Data
  la a0,DWORD  // A0 = DWORD Offset
  sdr t0,2(a0) // DWORD = Long Data
  PrintString($A0100000,80,304,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,304,FontBlack,VALUELONGG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,224,304,FontBlack,TEXTLONGG,17) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,304,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,304,FontBlack,DWORD,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,DWORD     // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,SDRCHECKK // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,SDRPASSK // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,304,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SDRENDK
  nop // Delay Slot
  SDRPASSK:
  PrintString($A0100000,528,304,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SDRENDK:

  la a0,VALUELONGG // A0 = Long Data Offset
  ld t0,0(a0)  // T0 = Test Long Data
  la a0,DWORD  // A0 = DWORD Offset
  sdr t0,3(a0) // DWORD = Long Data
  PrintString($A0100000,80,312,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,312,FontBlack,VALUELONGG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,224,312,FontBlack,TEXTLONGG,17) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,312,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,312,FontBlack,DWORD,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,DWORD     // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,SDRCHECKL // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,SDRPASSL // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,312,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SDRENDL
  nop // Delay Slot
  SDRPASSL:
  PrintString($A0100000,528,312,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SDRENDL:

  la a0,VALUELONGG // A0 = Long Data Offset
  ld t0,0(a0)  // T0 = Test Long Data
  la a0,DWORD  // A0 = DWORD Offset
  sdr t0,4(a0) // DWORD = Long Data
  PrintString($A0100000,80,320,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,320,FontBlack,VALUELONGG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,224,320,FontBlack,TEXTLONGG,17) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,320,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,320,FontBlack,DWORD,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,DWORD     // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,SDRCHECKM // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,SDRPASSM // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,320,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SDRENDM
  nop // Delay Slot
  SDRPASSM:
  PrintString($A0100000,528,320,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SDRENDM:

  la a0,VALUELONGG // A0 = Long Data Offset
  ld t0,0(a0)  // T0 = Test Long Data
  la a0,DWORD  // A0 = DWORD Offset
  sdr t0,5(a0) // DWORD = Long Data
  PrintString($A0100000,80,328,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,328,FontBlack,VALUELONGG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,224,328,FontBlack,TEXTLONGG,17) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,328,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,328,FontBlack,DWORD,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,DWORD     // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,SDRCHECKN // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,SDRPASSN // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,328,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SDRENDN
  nop // Delay Slot
  SDRPASSN:
  PrintString($A0100000,528,328,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SDRENDN:

  la a0,VALUELONGG // A0 = Long Data Offset
  ld t0,0(a0)  // T0 = Test Long Data
  la a0,DWORD  // A0 = DWORD Offset
  sdr t0,6(a0) // DWORD = Long Data
  PrintString($A0100000,80,336,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,336,FontBlack,VALUELONGG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,224,336,FontBlack,TEXTLONGG,17) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,336,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,336,FontBlack,DWORD,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,DWORD     // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,SDRCHECKO // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,SDRPASSO // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,336,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SDRENDO
  nop // Delay Slot
  SDRPASSO:
  PrintString($A0100000,528,336,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SDRENDO:

  la a0,VALUELONGG // A0 = Long Data Offset
  ld t0,0(a0)  // T0 = Test Long Data
  la a0,DWORD  // A0 = DWORD Offset
  sdr t0,7(a0) // DWORD = Long Data
  PrintString($A0100000,80,344,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,344,FontBlack,VALUELONGG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,224,344,FontBlack,TEXTLONGG,17) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,344,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,344,FontBlack,DWORD,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,DWORD     // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  la a0,SDRCHECKP // A0 = Long Check Data Offset
  ld t1,0(a0)     // T1 = Long Check Data
  beq t0,t1,SDRPASSP // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,344,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SDRENDP
  nop // Delay Slot
  SDRPASSP:
  PrintString($A0100000,528,344,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SDRENDP:


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

SD:
  db "SD"
SDL:
  db "SDL"
SDR:
  db "SDR"

DWORDHEX:
  db "DWORD (Hex)"
RTHEX:
  db "RT (Hex)"
RTDEC:
  db "RT (Decimal)"
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

SDCHECKA:
  dd $0000000000000000
SDCHECKB:
  dd $002BDC5461646522
SDCHECKC:
  dd $00000000499602D7
SDCHECKD:
  dd $002BDC545E14D64E
SDCHECKE:
  dd $FFD423ABA1EB29B2
SDCHECKF:
  dd $FFFFFFFFB669FD29
SDCHECKG:
  dd $FFD423AB9E9B9ADE

SDLCHECKA:
  dd $002BDC5461646522
SDLCHECKB:
  dd $00002BDC54616465
SDLCHECKC:
  dd $0000002BDC546164
SDLCHECKD:
  dd $000000002BDC5461
SDLCHECKE:
  dd $00000000002BDC54
SDLCHECKF:
  dd $0000000000002BDC
SDLCHECKG:
  dd $000000000000002B
SDLCHECKH:
  dd $0000000000000000
SDLCHECKI:
  dd $FFD423AB9E9B9ADE
SDLCHECKJ:
  dd $FFFFD423AB9E9B9A
SDLCHECKK:
  dd $FFFFFFD423AB9E9B
SDLCHECKL:
  dd $FFFFFFFFD423AB9E
SDLCHECKM:
  dd $FFFFFFFFFFD423AB
SDLCHECKN:
  dd $FFFFFFFFFFFFD423
SDLCHECKO:
  dd $FFFFFFFFFFFFFFD4
SDLCHECKP:
  dd $FFFFFFFFFFFFFFFF

SDRCHECKA:
  dd $22FFFFFFFFFFFFFF
SDRCHECKB:
  dd $6522FFFFFFFFFFFF
SDRCHECKC:
  dd $646522FFFFFFFFFF
SDRCHECKD:
  dd $61646522FFFFFFFF
SDRCHECKE:
  dd $5461646522FFFFFF
SDRCHECKF:
  dd $DC5461646522FFFF
SDRCHECKG:
  dd $2BDC5461646522FF
SDRCHECKH:
  dd $002BDC5461646522
SDRCHECKI:
  dd $DE2BDC5461646522
SDRCHECKJ:
  dd $9ADEDC5461646522
SDRCHECKK:
  dd $9B9ADE5461646522
SDRCHECKL:
  dd $9E9B9ADE61646522
SDRCHECKM:
  dd $AB9E9B9ADE646522
SDRCHECKN:
  dd $23AB9E9B9ADE6522
SDRCHECKO:
  dd $D423AB9E9B9ADE22
SDRCHECKP:
  dd $FFD423AB9E9B9ADE

DWORD:
  dd 0

insert FontBlack, "FontBlack8x8.bin"
insert FontGreen, "FontGreen8x8.bin"
insert FontRed, "FontRed8x8.bin"