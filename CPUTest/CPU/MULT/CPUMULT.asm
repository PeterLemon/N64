// N64 'Bare Metal' CPU Signed Word Multiplication Test Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "CPUMULT.N64", create
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
include "LIB\N64.INC" // Include N64 Definitions
include "LIB\N64_HEADER.ASM" // Include 64 Byte Header & Vector Table
insert "LIB\N64_BOOTCODE.BIN" // Include 4032 Byte Boot Code

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
  include "LIB\N64_GFX.INC" // Include Graphics Macros
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


  PrintString($A0100000,8,24,FontRed,MULT,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,VALUEWORDA // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,VALUEWORDB // A0 = Word Data Offset
  lw t1,0(a0)      // T1 = Word Data
  mult t0,t1 // HI/LO = Test Word Data
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
  la a0,LOWORD       // A0 = Word Data Offset
  lw t0,0(a0)        // T0 = Word Data
  la a0,MULTLOCHECKA // A0 = Word Check Data Offset
  lw t1,0(a0)        // T1 = Word Check Data
  beq t0,t1,MULTLOPASSA // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,24,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j MULTENDA
  nop // Delay Slot
  MULTLOPASSA:
  PrintString($A0100000,528,24,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,HIWORD       // A0 = Word Data Offset
  lw t0,0(a0)        // T0 = Word Data
  la a0,MULTHICHECKA // A0 = Word Check Data Offset
  lw t1,0(a0)        // T1 = Word Check Data
  beq t0,t1,MULTHIPASSA // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,32,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j MULTENDA
  nop // Delay Slot
  MULTHIPASSA:
  PrintString($A0100000,528,32,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  MULTENDA:

  la a0,VALUEWORDB // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,VALUEWORDC // A0 = Word Data Offset
  lw t1,0(a0)      // T1 = Word Data
  mult t0,t1 // HI/LO = Test Word Data
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
  la a0,LOWORD       // A0 = Word Data Offset
  lw t0,0(a0)        // T0 = Word Data
  la a0,MULTLOCHECKB // A0 = Word Check Data Offset
  lw t1,0(a0)        // T1 = Word Check Data
  beq t0,t1,MULTLOPASSB // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,48,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j MULTENDB
  nop // Delay Slot
  MULTLOPASSB:
  PrintString($A0100000,528,48,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,HIWORD       // A0 = Word Data Offset
  lw t0,0(a0)        // T0 = Word Data
  la a0,MULTHICHECKB // A0 = Word Check Data Offset
  lw t1,0(a0)        // T1 = Word Check Data
  beq t0,t1,MULTHIPASSB // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,56,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j MULTENDB
  nop // Delay Slot
  MULTHIPASSB:
  PrintString($A0100000,528,56,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  MULTENDB:

  la a0,VALUEWORDC // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,VALUEWORDD // A0 = Word Data Offset
  lw t1,0(a0)      // T1 = Word Data
  mult t0,t1 // HI/LO = Test Word Data
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
  la a0,LOWORD       // A0 = Word Data Offset
  lw t0,0(a0)        // T0 = Word Data
  la a0,MULTLOCHECKC // A0 = Word Check Data Offset
  lw t1,0(a0)        // T1 = Word Check Data
  beq t0,t1,MULTLOPASSC // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,72,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j MULTENDC
  nop // Delay Slot
  MULTLOPASSC:
  PrintString($A0100000,528,72,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,HIWORD       // A0 = Word Data Offset
  lw t0,0(a0)        // T0 = Word Data
  la a0,MULTHICHECKC // A0 = Word Check Data Offset
  lw t1,0(a0)        // T1 = Word Check Data
  beq t0,t1,MULTHIPASSC // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,80,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j MULTENDC
  nop // Delay Slot
  MULTHIPASSC:
  PrintString($A0100000,528,80,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  MULTENDC:

  la a0,VALUEWORDD // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,VALUEWORDE // A0 = Word Data Offset
  lw t1,0(a0)      // T1 = Word Data
  mult t0,t1 // HI/LO = Test Word Data
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
  la a0,LOWORD       // A0 = Word Data Offset
  lw t0,0(a0)        // T0 = Word Data
  la a0,MULTLOCHECKD // A0 = Word Check Data Offset
  lw t1,0(a0)        // T1 = Word Check Data
  beq t0,t1,MULTLOPASSD // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,96,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j MULTENDD
  nop // Delay Slot
  MULTLOPASSD:
  PrintString($A0100000,528,96,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,HIWORD       // A0 = Word Data Offset
  lw t0,0(a0)        // T0 = Word Data
  la a0,MULTHICHECKD // A0 = Word Check Data Offset
  lw t1,0(a0)        // T1 = Word Check Data
  beq t0,t1,MULTHIPASSD // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,104,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j MULTENDD
  nop // Delay Slot
  MULTHIPASSD:
  PrintString($A0100000,528,104,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  MULTENDD:

  la a0,VALUEWORDE // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,VALUEWORDF // A0 = Word Data Offset
  lw t1,0(a0)      // T1 = Word Data
  mult t0,t1 // HI/LO = Test Word Data
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
  la a0,LOWORD       // A0 = Word Data Offset
  lw t0,0(a0)        // T0 = Word Data
  la a0,MULTLOCHECKE // A0 = Word Check Data Offset
  lw t1,0(a0)        // T1 = Word Check Data
  beq t0,t1,MULTLOPASSE // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,120,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j MULTENDE
  nop // Delay Slot
  MULTLOPASSE:
  PrintString($A0100000,528,120,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,HIWORD       // A0 = Word Data Offset
  lw t0,0(a0)        // T0 = Word Data
  la a0,MULTHICHECKE // A0 = Word Check Data Offset
  lw t1,0(a0)        // T1 = Word Check Data
  beq t0,t1,MULTHIPASSE // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,128,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j MULTENDE
  nop // Delay Slot
  MULTHIPASSE:
  PrintString($A0100000,528,128,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  MULTENDE:

  la a0,VALUEWORDF // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,VALUEWORDG // A0 = Word Data Offset
  lw t1,0(a0)      // T1 = Word Data
  mult t0,t1 // HI/LO = Test Word Data
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
  la a0,LOWORD       // A0 = Word Data Offset
  lw t0,0(a0)        // T0 = Word Data
  la a0,MULTLOCHECKF // A0 = Word Check Data Offset
  lw t1,0(a0)        // T1 = Word Check Data
  beq t0,t1,MULTLOPASSF // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,144,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j MULTENDF
  nop // Delay Slot
  MULTLOPASSF:
  PrintString($A0100000,528,144,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,HIWORD       // A0 = Word Data Offset
  lw t0,0(a0)        // T0 = Word Data
  la a0,MULTHICHECKF // A0 = Word Check Data Offset
  lw t1,0(a0)        // T1 = Word Check Data
  beq t0,t1,MULTHIPASSF // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,152,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j MULTENDF
  nop // Delay Slot
  MULTHIPASSF:
  PrintString($A0100000,528,152,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  MULTENDF:

  la a0,VALUEWORDA // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,VALUEWORDG // A0 = Word Data Offset
  lw t1,0(a0)      // T1 = Word Data
  mult t0,t1 // HI/LO = Test Word Data
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
  la a0,LOWORD       // A0 = Word Data Offset
  lw t0,0(a0)        // T0 = Word Data
  la a0,MULTLOCHECKG // A0 = Word Check Data Offset
  lw t1,0(a0)        // T1 = Word Check Data
  beq t0,t1,MULTLOPASSG // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,168,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j MULTENDG
  nop // Delay Slot
  MULTLOPASSG:
  PrintString($A0100000,528,168,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,HIWORD       // A0 = Word Data Offset
  lw t0,0(a0)        // T0 = Word Data
  la a0,MULTHICHECKG // A0 = Word Check Data Offset
  lw t1,0(a0)        // T1 = Word Check Data
  beq t0,t1,MULTHIPASSG // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,176,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j MULTENDG
  nop // Delay Slot
  MULTHIPASSG:
  PrintString($A0100000,528,176,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  MULTENDG:


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

MULT:
  db "MULT"

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

MULTLOCHECKA:
  dd $00000000
MULTHICHECKA:
  dd $00000000
MULTLOCHECKB:
  dd $AF14CF40
MULTHICHECKB:
  dd $00000DDC
MULTLOCHECKC:
  dd $86345C80
MULTHICHECKC:
  dd $00000DDC
MULTLOCHECKD:
  dd $C0F6BE7C
MULTHICHECKD:
  dd $FFC9DB1C
MULTLOCHECKE:
  dd $86345C80
MULTHICHECKE:
  dd $00000DDC
MULTLOCHECKF:
  dd $AF14CF40
MULTHICHECKF:
  dd $00000DDC
MULTLOCHECKG:
  dd $00000000
MULTHICHECKG:
  dd $00000000

LOWORD:
  dd 0
HIWORD:
  dd 0

insert FontBlack, "FontBlack8x8.bin"
insert FontGreen, "FontGreen8x8.bin"
insert FontRed, "FontRed8x8.bin"