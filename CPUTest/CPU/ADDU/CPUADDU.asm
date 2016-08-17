// N64 'Bare Metal' CPU Unsigned Word Addition Test Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "CPUADDU.N64", create
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


  PrintString($A0100000,8,24,FontRed,ADDU,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,VALUEWORDA // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,VALUEWORDB // A0 = Word Data Offset
  lw t1,0(a0)      // T1 = Word Data
  addu t0,t1 // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintString($A0100000,144,24,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,24,FontBlack,VALUEWORDA,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,24,FontBlack,TEXTWORDA,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,144,32,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,32,FontBlack,VALUEWORDB,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,296,32,FontBlack,TEXTWORDB,8) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,32,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,32,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,ADDUCHECKA // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,ADDUPASSA // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,32,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j ADDUENDA
  nop // Delay Slot
  ADDUPASSA:
  PrintString($A0100000,528,32,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  ADDUENDA:

  la a0,VALUEWORDB // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,VALUEWORDC // A0 = Word Data Offset
  lw t1,0(a0)      // T1 = Word Data
  addu t0,t1 // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintString($A0100000,144,48,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,48,FontBlack,VALUEWORDB,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,296,48,FontBlack,TEXTWORDB,8) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,144,56,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,56,FontBlack,VALUEWORDC,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,320,56,FontBlack,TEXTWORDC,5) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,56,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,56,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,ADDUCHECKB // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,ADDUPASSB // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,56,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j ADDUENDB
  nop // Delay Slot
  ADDUPASSB:
  PrintString($A0100000,528,56,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  ADDUENDB:

  la a0,VALUEWORDC // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,VALUEWORDD // A0 = Word Data Offset
  lw t1,0(a0)      // T1 = Word Data
  addu t0,t1 // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintString($A0100000,144,72,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,72,FontBlack,VALUEWORDC,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,320,72,FontBlack,TEXTWORDC,5) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,144,80,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,80,FontBlack,VALUEWORDD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,296,80,FontBlack,TEXTWORDD,8) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,80,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,80,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,ADDUCHECKC // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,ADDUPASSC // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,80,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j ADDUENDC
  nop // Delay Slot
  ADDUPASSC:
  PrintString($A0100000,528,80,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  ADDUENDC:

  la a0,VALUEWORDD // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,VALUEWORDE // A0 = Word Data Offset
  lw t1,0(a0)      // T1 = Word Data
  addu t0,t1 // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintString($A0100000,144,96,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,96,FontBlack,VALUEWORDD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,296,96,FontBlack,TEXTWORDD,8) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,144,104,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,104,FontBlack,VALUEWORDE,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,104,FontBlack,TEXTWORDE,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,104,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,104,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,ADDUCHECKD // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,ADDUPASSD // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,104,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j ADDUENDD
  nop // Delay Slot
  ADDUPASSD:
  PrintString($A0100000,528,104,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  ADDUENDD:

  la a0,VALUEWORDE // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,VALUEWORDF // A0 = Word Data Offset
  lw t1,0(a0)      // T1 = Word Data
  addu t0,t1 // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintString($A0100000,144,120,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,120,FontBlack,VALUEWORDE,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,120,FontBlack,TEXTWORDE,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,144,128,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,128,FontBlack,VALUEWORDF,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,312,128,FontBlack,TEXTWORDF,6) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,128,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,128,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,ADDUCHECKE // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,ADDUPASSE // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,128,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j ADDUENDE
  nop // Delay Slot
  ADDUPASSE:
  PrintString($A0100000,528,128,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  ADDUENDE:

  la a0,VALUEWORDF // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,VALUEWORDG // A0 = Word Data Offset
  lw t1,0(a0)      // T1 = Word Data
  addu t0,t1 // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintString($A0100000,144,144,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,144,FontBlack,VALUEWORDF,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,312,144,FontBlack,TEXTWORDF,6) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,144,152,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,152,FontBlack,VALUEWORDG,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,152,FontBlack,TEXTWORDG,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,152,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,152,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,ADDUCHECKF // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,ADDUPASSF // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,152,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j ADDUENDF
  nop // Delay Slot
  ADDUPASSF:
  PrintString($A0100000,528,152,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  ADDUENDF:

  la a0,VALUEWORDA // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,VALUEWORDG // A0 = Word Data Offset
  lw t1,0(a0)      // T1 = Word Data
  addu t0,t1 // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintString($A0100000,144,168,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,168,FontBlack,VALUEWORDA,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,168,FontBlack,TEXTWORDA,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,144,176,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,176,FontBlack,VALUEWORDG,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,176,FontBlack,TEXTWORDG,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,176,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,176,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD     // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  la a0,ADDUCHECKG // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,ADDUPASSG // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,176,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j ADDUENDG
  nop // Delay Slot
  ADDUPASSG:
  PrintString($A0100000,528,176,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  ADDUENDG:


  PrintString($A0100000,8,192,FontRed,ADDIU,4) // Print Text String To VRAM Using Font At X,Y Position
  la a0,VALUEWORDA // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  addiu t0,VALUEIWORDB // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintString($A0100000,144,192,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,192,FontBlack,VALUEWORDA,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,192,FontBlack,TEXTWORDA,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,144,200,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,200,FontBlack,IWORDB,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,328,200,FontBlack,TEXTIWORDB,4) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,200,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,200,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD      // A0 = Word Data Offset
  lw t0,0(a0)       // T0 = Word Data
  la a0,ADDIUCHECKA // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,ADDIUPASSA // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,200,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j ADDIUENDA
  nop // Delay Slot
  ADDIUPASSA:
  PrintString($A0100000,528,200,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  ADDIUENDA:

  la a0,VALUEWORDB // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  addiu t0,VALUEIWORDC // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintString($A0100000,144,216,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,216,FontBlack,VALUEWORDB,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,296,216,FontBlack,TEXTWORDB,8) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,144,224,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,224,FontBlack,IWORDC,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,336,224,FontBlack,TEXTIWORDC,3) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,224,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,224,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD      // A0 = Word Data Offset
  lw t0,0(a0)       // T0 = Word Data
  la a0,ADDIUCHECKB // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,ADDIUPASSB // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,224,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j ADDIUENDB
  nop // Delay Slot
  ADDIUPASSB:
  PrintString($A0100000,528,224,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  ADDIUENDB:

  la a0,VALUEWORDC // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  addiu t0,VALUEIWORDD // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintString($A0100000,144,240,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,240,FontBlack,VALUEWORDC,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,320,240,FontBlack,TEXTWORDC,5) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,144,248,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,248,FontBlack,IWORDD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,328,248,FontBlack,TEXTIWORDD,4) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,248,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,248,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD      // T0 = Word Data Offset
  lw t1,0(t0)       // T1 = Word Data
  la t0,ADDIUCHECKC // T0 = Word Check Data Offset
  lw t2,0(t0)       // T2 = Word Check Data
  beq t1,t2,ADDIUPASSC // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,248,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j ADDIUENDC
  nop // Delay Slot
  ADDIUPASSC:
  PrintString($A0100000,528,248,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  ADDIUENDC:

  la a0,IWORDD // A0 = Word Data Offset
  lw t0,0(a0)  // T0 = Word Data
  addiu t0,VALUEIWORDE // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintString($A0100000,144,264,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,264,FontBlack,IWORDD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,328,264,FontBlack,TEXTIWORDD,4) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,144,272,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,272,FontBlack,IWORDE,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,328,272,FontBlack,TEXTIWORDE,4) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,272,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,272,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD      // A0 = Word Data Offset
  lw t0,0(a0)       // T0 = Word Data
  la a0,ADDIUCHECKD // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,ADDIUPASSD // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,272,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j ADDIUENDD
  nop // Delay Slot
  ADDIUPASSD:
  PrintString($A0100000,528,272,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  ADDIUENDD:

  la a0,VALUEWORDE // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  addiu t0,VALUEIWORDF // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintString($A0100000,144,288,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,288,FontBlack,VALUEWORDE,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,288,FontBlack,TEXTWORDE,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,144,296,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,296,FontBlack,IWORDF,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,336,296,FontBlack,TEXTIWORDF,3) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,296,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,296,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD      // T0 = Word Data Offset
  lw t1,0(t0)       // T1 = Word Data
  la t0,ADDIUCHECKE // T0 = Word Check Data Offset
  lw t2,0(t0)       // T2 = Word Check Data
  beq t1,t2,ADDIUPASSE // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,296,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j ADDIUENDE
  nop // Delay Slot
  ADDIUPASSE:
  PrintString($A0100000,528,296,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  ADDIUENDE:

  la a0,VALUEWORDF // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  addiu t0,VALUEIWORDG // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintString($A0100000,144,312,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,312,FontBlack,VALUEWORDF,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,312,312,FontBlack,TEXTWORDF,6) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,144,320,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,320,FontBlack,IWORDG,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,328,320,FontBlack,TEXTIWORDG,4) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,320,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,320,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD      // A0 = Word Data Offset
  lw t0,0(a0)       // T0 = Word Data
  la a0,ADDIUCHECKF // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,ADDIUPASSF // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,320,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j ADDIUENDF
  nop // Delay Slot
  ADDIUPASSF:
  PrintString($A0100000,528,320,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  ADDIUENDF:

  la a0,VALUEWORDA // A0 = Word Data Offset
  lw t0,0(a0)      // T0 = Word Data
  addiu t0,VALUEIWORDG // T0 = Test Word Data
  la a0,RDWORD // A0 = RDWORD Offset
  sw t0,0(a0)  // RDWORD = Word Data
  PrintString($A0100000,144,336,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,336,FontBlack,VALUEWORDA,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,336,FontBlack,TEXTWORDA,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,144,344,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,344,FontBlack,IWORDG,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,328,344,FontBlack,TEXTIWORDG,4) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,344,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,344,FontBlack,RDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDWORD      // A0 = Word Data Offset
  lw t0,0(a0)       // T0 = Word Data
  la a0,ADDIUCHECKG // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,ADDIUPASSG // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,344,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j ADDIUENDG
  nop // Delay Slot
  ADDIUPASSG:
  PrintString($A0100000,528,344,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  ADDIUENDG:


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

ADDU:
  db "ADDU"
ADDIU:
  db "ADDIU"

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

TEXTWORDA:
  db "0"
TEXTWORDB:
  db "123456789"
TEXTWORDC:
  db "123456"
TEXTWORDD:
  db "123451234"
TEXTWORDE:
  db "1234512345"
TEXTWORDF:
  db "1234567"
TEXTWORDG:
  db "1234567897"

TEXTIWORDB:
  db "12345"
TEXTIWORDC:
  db "1234"
TEXTIWORDD:
  db "12341"
TEXTIWORDE:
  db "23456"
TEXTIWORDF:
  db "3456"
TEXTIWORDG:
  db "32198"

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
  dd 1234512345
VALUEWORDF:
  dd 1234567
VALUEWORDG:
  dd 1234567891

ADDUCHECKA:
  dd $075BCD15
ADDUCHECKB:
  dd $075DAF55
ADDUCHECKC:
  dd $075D99A2
ADDUCHECKD:
  dd $50F0E13B
ADDUCHECKE:
  dd $49A80060
ADDUCHECKF:
  dd $49A8D95A
ADDUCHECKG:
  dd $499602D3

constant VALUEIWORDB(12345)
constant VALUEIWORDC(1234)
constant VALUEIWORDD(12341)
constant VALUEIWORDE(23456)
constant VALUEIWORDF(3456)
constant VALUEIWORDG(32198)
IWORDB:
  dd 12345
IWORDC:
  dd 1234
IWORDD:
  dd 12341
IWORDE:
  dd 23456
IWORDF:
  dd 3456
IWORDG:
  dd 32198

ADDIUCHECKA:
  dd $00003039
ADDIUCHECKB:
  dd $075BD1E7
ADDIUCHECKC:
  dd $00021275
ADDIUCHECKD:
  dd $00008BD5
ADDIUCHECKE:
  dd $49953759
ADDIUCHECKF:
  dd $0013544D
ADDIUCHECKG:
  dd $00007DC6

RDWORD:
  dd 0

insert FontBlack, "FontBlack8x8.bin"
insert FontGreen, "FontGreen8x8.bin"
insert FontRed, "FontRed8x8.bin"