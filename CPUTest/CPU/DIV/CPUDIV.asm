// N64 'Bare Metal' CPU Signed Word Division Test Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "CPUDIV.N64", create
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
  PrintString($A0100000,384,8,FontRed,LOHIHEX,10) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,528,8,FontRed,TEST,10) // Print Text String To VRAM Using Font At X,Y Position


  PrintString($A0100000,0,16,FontBlack,PAGEBREAK,79) // Print Text String To VRAM Using Font At X,Y Position


  PrintString($A0100000,8,24,FontRed,DIV,2) // Print Text String To VRAM Using Font At X,Y Position
  la a0,VALUEWORDA // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,VALUEWORDB // A0 = Word Data Offset
  lw t1,0(a0)      // T1 = Word Data
  div t0,t1 // HI/LO = Test Word Data
  mflo t0 // T0 = LO
  la a0,LOWORD // A0 = LOWORD Offset
  sw t0,0(a0)  // LOWORD = Word Data
  mfhi t0 // T0 = HI
  la a0,HIWORD // A0 = HIWORD Offset
  sw t0,0(a0)  // HIWORD = Word Data
  PrintString($A0100000,144,24,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,24,FontBlack,VALUEWORDA,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,24,FontBlack,TEXTWORDA,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,24,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,24,FontBlack,LOWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,144,32,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,32,FontBlack,VALUEWORDB,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,296,32,FontBlack,TEXTWORDB,8) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,32,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,32,FontBlack,HIWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,LOWORD      // A0 = Word Data Offset
  lw t0,0(a0)       // T0 = Word Data
  la a0,DIVLOCHECKA // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,DIVLOPASSA // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,24,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DIVENDA
  nop // Delay Slot
  DIVLOPASSA:
  PrintString($A0100000,528,24,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,HIWORD      // A0 = Word Data Offset
  lw t0,0(a0)       // T0 = Word Data
  la a0,DIVHICHECKA // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,DIVHIPASSA // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,32,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DIVENDA
  nop // Delay Slot
  DIVHIPASSA:
  PrintString($A0100000,528,32,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DIVENDA:

  la a0,VALUEWORDB // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,VALUEWORDC // A0 = Word Data Offset
  lw t1,0(a0)      // T1 = Word Data
  div t0,t1 // HI/LO = Test Word Data
  mflo t0 // T0 = LO
  la a0,LOWORD // A0 = LOWORD Offset
  sw t0,0(a0)  // LOWORD = Word Data
  mfhi t0 // T0 = HI
  la a0,HIWORD // A0 = HIWORD Offset
  sw t0,0(a0)  // HIWORD = Word Data
  PrintString($A0100000,144,48,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,48,FontBlack,VALUEWORDB,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,296,48,FontBlack,TEXTWORDB,8) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,48,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,48,FontBlack,LOWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,144,56,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,56,FontBlack,VALUEWORDC,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,320,56,FontBlack,TEXTWORDC,5) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,56,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,56,FontBlack,HIWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,LOWORD      // A0 = Word Data Offset
  lw t0,0(a0)       // T0 = Word Data
  la a0,DIVLOCHECKB // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,DIVLOPASSB // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,48,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DIVENDB
  nop // Delay Slot
  DIVLOPASSB:
  PrintString($A0100000,528,48,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,HIWORD      // A0 = Word Data Offset
  lw t0,0(a0)       // T0 = Word Data
  la a0,DIVHICHECKB // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,DIVHIPASSB // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,56,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DIVENDB
  nop // Delay Slot
  DIVHIPASSB:
  PrintString($A0100000,528,56,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DIVENDB:

  la a0,VALUEWORDC // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,VALUEWORDD // A0 = Word Data Offset
  lw t1,0(a0)      // T1 = Word Data
  div t0,t1 // HI/LO = Test Word Data
  mflo t0 // T0 = LO
  la a0,LOWORD // A0 = LOWORD Offset
  sw t0,0(a0)  // LOWORD = Word Data
  mfhi t0 // T0 = HI
  la a0,HIWORD // A0 = HIWORD Offset
  sw t0,0(a0)  // HIWORD = Word Data
  PrintString($A0100000,144,72,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,72,FontBlack,VALUEWORDC,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,320,72,FontBlack,TEXTWORDC,5) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,72,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,72,FontBlack,LOWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,144,80,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,80,FontBlack,VALUEWORDD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,296,80,FontBlack,TEXTWORDD,8) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,80,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,80,FontBlack,HIWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,LOWORD      // A0 = Word Data Offset
  lw t0,0(a0)       // T0 = Word Data
  la a0,DIVLOCHECKC // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,DIVLOPASSC // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,72,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DIVENDC
  nop // Delay Slot
  DIVLOPASSC:
  PrintString($A0100000,528,72,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,HIWORD      // A0 = Word Data Offset
  lw t0,0(a0)       // T0 = Word Data
  la a0,DIVHICHECKC // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,DIVHIPASSC // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,80,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DIVENDC
  nop // Delay Slot
  DIVHIPASSC:
  PrintString($A0100000,528,80,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DIVENDC:

  la a0,VALUEWORDD // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,VALUEWORDE // A0 = Word Data Offset
  lw t1,0(a0)      // T1 = Word Data
  div t0,t1 // HI/LO = Test Word Data
  mflo t0 // T0 = LO
  la a0,LOWORD // A0 = LOWORD Offset
  sw t0,0(a0)  // LOWORD = Word Data
  mfhi t0 // T0 = HI
  la a0,HIWORD // A0 = HIWORD Offset
  sw t0,0(a0)  // HIWORD = Word Data
  PrintString($A0100000,144,96,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,96,FontBlack,VALUEWORDD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,296,96,FontBlack,TEXTWORDD,8) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,96,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,96,FontBlack,LOWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,144,104,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,104,FontBlack,VALUEWORDE,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,104,FontBlack,TEXTWORDE,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,104,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,104,FontBlack,HIWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,LOWORD      // A0 = Word Data Offset
  lw t0,0(a0)       // T0 = Word Data
  la a0,DIVLOCHECKD // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,DIVLOPASSD // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,96,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DIVENDD
  nop // Delay Slot
  DIVLOPASSD:
  PrintString($A0100000,528,96,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,HIWORD      // A0 = Word Data Offset
  lw t0,0(a0)       // T0 = Word Data
  la a0,DIVHICHECKD // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,DIVHIPASSD // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,104,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DIVENDD
  nop // Delay Slot
  DIVHIPASSD:
  PrintString($A0100000,528,104,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DIVENDD:

  la a0,VALUEWORDE // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,VALUEWORDF // A0 = Word Data Offset
  lw t1,0(a0)      // T1 = Word Data
  div t0,t1 // HI/LO = Test Word Data
  mflo t0 // T0 = LO
  la a0,LOWORD // A0 = LOWORD Offset
  sw t0,0(a0)  // LOWORD = Word Data
  mfhi t0 // T0 = HI
  la a0,HIWORD // A0 = HIWORD Offset
  sw t0,0(a0)  // HIWORD = Word Data
  PrintString($A0100000,144,120,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,120,FontBlack,VALUEWORDE,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,120,FontBlack,TEXTWORDE,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,120,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,120,FontBlack,LOWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,144,128,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,128,FontBlack,VALUEWORDF,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,312,128,FontBlack,TEXTWORDF,6) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,128,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,128,FontBlack,HIWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,LOWORD      // A0 = Word Data Offset
  lw t0,0(a0)       // T0 = Word Data
  la a0,DIVLOCHECKE // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,DIVLOPASSE // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,120,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DIVENDE
  nop // Delay Slot
  DIVLOPASSE:
  PrintString($A0100000,528,120,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,HIWORD      // A0 = Word Data Offset
  lw t0,0(a0)       // T0 = Word Data
  la a0,DIVHICHECKE // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,DIVHIPASSE // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,128,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DIVENDE
  nop // Delay Slot
  DIVHIPASSE:
  PrintString($A0100000,528,128,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DIVENDE:

  la a0,VALUEWORDF // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,VALUEWORDG // A0 = Word Data Offset
  lw t1,0(a0)      // T1 = Word Data
  div t0,t1 // HI/LO = Test Word Data
  mflo t0 // T0 = LO
  la a0,LOWORD // A0 = LOWORD Offset
  sw t0,0(a0)  // LOWORD = Word Data
  mfhi t0 // T0 = HI
  la a0,HIWORD // A0 = HIWORD Offset
  sw t0,0(a0)  // HIWORD = Word Data
  PrintString($A0100000,144,144,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,144,FontBlack,VALUEWORDF,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,312,144,FontBlack,TEXTWORDF,6) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,144,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,144,FontBlack,LOWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,144,152,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,152,FontBlack,VALUEWORDG,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,152,FontBlack,TEXTWORDG,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,152,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,152,FontBlack,HIWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,LOWORD      // A0 = Word Data Offset
  lw t0,0(a0)       // T0 = Word Data
  la a0,DIVLOCHECKF // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,DIVLOPASSF // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,144,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DIVENDF
  nop // Delay Slot
  DIVLOPASSF:
  PrintString($A0100000,528,144,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,HIWORD      // A0 = Word Data Offset
  lw t0,0(a0)       // T0 = Word Data
  la a0,DIVHICHECKF // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,DIVHIPASSF // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,152,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DIVENDF
  nop // Delay Slot
  DIVHIPASSF:
  PrintString($A0100000,528,152,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DIVENDF:

  la a0,VALUEWORDA // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,VALUEWORDG // A0 = Word Data Offset
  lw t1,0(a0)      // T1 = Word Data
  div t0,t1 // HI/LO = Test Word Data
  mflo t0 // T0 = LO
  la a0,LOWORD // A0 = LOWORD Offset
  sw t0,0(a0)  // LOWORD = Word Data
  mfhi t0 // T0 = HI
  la a0,HIWORD // A0 = HIWORD Offset
  sw t0,0(a0)  // HIWORD = Word Data
  PrintString($A0100000,144,168,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,168,FontBlack,VALUEWORDA,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,168,FontBlack,TEXTWORDA,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,168,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,168,FontBlack,LOWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,144,176,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,176,FontBlack,VALUEWORDG,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,176,FontBlack,TEXTWORDG,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,176,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,176,FontBlack,HIWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,LOWORD      // A0 = Word Data Offset
  lw t0,0(a0)       // T0 = Word Data
  la a0,DIVLOCHECKG // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,DIVLOPASSG // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,168,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DIVENDG
  nop // Delay Slot
  DIVLOPASSG:
  PrintString($A0100000,528,168,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,HIWORD      // A0 = Word Data Offset
  lw t0,0(a0)       // T0 = Word Data
  la a0,DIVHICHECKG // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,DIVHIPASSG // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,176,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DIVENDG
  nop // Delay Slot
  DIVHIPASSG:
  PrintString($A0100000,528,176,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DIVENDG:


  PrintString($A0100000,0,184,FontBlack,PAGEBREAK,79) // Print Text String To VRAM Using Font At X,Y Position


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

DIV:
  db "DIV"

LOHIHEX:
  db "LO/HI (Hex)"
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

TEXTWORDA:
  db "0"
TEXTWORDB:
  db "123456789"
TEXTWORDC:
  db "123456"
TEXTWORDD:
  db "123451234"
TEXTWORDE:
  db "-123451234"
TEXTWORDF:
  db "-123456"
TEXTWORDG:
  db "-123456789"

PAGEBREAK:
  db "--------------------------------------------------------------------------------"

align(8) // Align 64-Bit
VALUEWORDA:
  dd 0
VALUEWORDB:
  dd 123456789
VALUEWORDC:
  dd 123456
VALUEWORDD:
  dd 123451234
VALUEWORDE:
  dd -123451234
VALUEWORDF:
  dd -123456
VALUEWORDG:
  dd -123456789

DIVLOCHECKA:
  dd $00000000
DIVHICHECKA:
  dd $00000000
DIVLOCHECKB:
  dd $000003E8
DIVHICHECKB:
  dd $00000315
DIVLOCHECKC:
  dd $00000000
DIVHICHECKC:
  dd $0001E240
DIVLOCHECKD:
  dd $FFFFFFFF
DIVHICHECKD:
  dd $00000000
DIVLOCHECKE:
  dd $000003E7
DIVHICHECKE:
  dd $FFFE305E
DIVLOCHECKF:
  dd $00000000
DIVHICHECKF:
  dd $FFFE1DC0
DIVLOCHECKG:
  dd $00000000
DIVHICHECKG:
  dd $00000000

LOWORD:
  dd 0
HIWORD:
  dd 0

insert FontBlack, "FontBlack8x8.bin"
insert FontGreen, "FontGreen8x8.bin"
insert FontRed, "FontRed8x8.bin"