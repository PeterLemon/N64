// N64 'Bare Metal' CPU CP1/FPU Convert Test Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "CP1CVT.N64", create
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


  PrintString($A0100000,80,8,FontRed,FSHEX,7) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,224,8,FontRed,FDFSDEC,14) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,8,FontRed,FDHEX,7) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,520,8,FontRed,TEST,10) // Print Text String To VRAM Using Font At X,Y Position


  PrintString($A0100000,0,16,FontBlack,PAGEBREAK,79) // Print Text String To VRAM Using Font At X,Y Position


  PrintString($A0100000,8,24,FontRed,CVTDL,6) // Print Text String To VRAM Using Font At X,Y Position
  la a0,VALUELONGA // A0 = Long Data Offset
  ldc1 f0,0(a0)    // F0 = Long Data
  cvt.d.l f0 // Convert To Double Data
  la a0,FDLONG  // A0 = FDLONG Offset
  sdc1 f0,0(a0) // FDLONG = Double Data
  PrintString($A0100000,72,24,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,80,24,FontBlack,VALUELONGA,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,24,FontBlack,TEXTLONGA,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,368,24,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,376,24,FontBlack,FDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FDLONG      // A0 = Double Data Offset
  ld t0,0(a0)       // T0 = Double Data
  la a0,CVTDLCHECKA // A0 = Long Check Data Offset
  ld t1,0(a0)       // T1 = Long Check Data
  beq t0,t1,CVTDLPASSA // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,520,24,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CVTDLENDA
  nop // Delay Slot
  CVTDLPASSA:
  PrintString($A0100000,520,24,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CVTDLENDA:

  la a0,VALUELONGB // A0 = Long Data Offset
  ldc1 f0,0(a0)    // F0 = Long Data
  cvt.d.l f0 // Convert To Double Data
  la a0,FDLONG  // A0 = FDLONG Offset
  sdc1 f0,0(a0) // FDLONG = Double Data
  PrintString($A0100000,72,32,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,80,32,FontBlack,VALUELONGB,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,296,32,FontBlack,TEXTLONGB,7) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,368,32,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,376,32,FontBlack,FDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FDLONG      // A0 = Double Data Offset
  ld t0,0(a0)       // T0 = Double Data
  la a0,CVTDLCHECKB // A0 = Long Check Data Offset
  ld t1,0(a0)       // T1 = Long Check Data
  beq t0,t1,CVTDLPASSB // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,520,32,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CVTDLENDB
  nop // Delay Slot
  CVTDLPASSB:
  PrintString($A0100000,520,32,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CVTDLENDB:

  la a0,VALUELONGC // A0 = Long Data Offset
  ldc1 f0,0(a0)    // F0 = Long Data
  cvt.d.l f0 // Convert To Double Data
  la a0,FDLONG  // A0 = FDLONG Offset
  sdc1 f0,0(a0) // FDLONG = Double Data
  PrintString($A0100000,72,40,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,80,40,FontBlack,VALUELONGC,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,40,FontBlack,TEXTLONGC,8) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,368,40,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,376,40,FontBlack,FDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FDLONG      // A0 = Double Data Offset
  ld t0,0(a0)       // T0 = Double Data
  la a0,CVTDLCHECKC // A0 = Long Check Data Offset
  ld t1,0(a0)       // T1 = Long Check Data
  beq t0,t1,CVTDLPASSC // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,520,40,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CVTDLENDC
  nop // Delay Slot
  CVTDLPASSC:
  PrintString($A0100000,520,40,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CVTDLENDC:

  PrintString($A0100000,8,56,FontRed,CVTDS,6) // Print Text String To VRAM Using Font At X,Y Position
  la a0,VALUEFLOATA // A0 = Float Data Offset
  lwc1 f0,0(a0)     // F0 = Float Data
  cvt.d.s f0 // Convert To Double Data
  la a0,FDLONG  // A0 = FDLONG Offset
  sdc1 f0,0(a0) // FDLONG = Double Data
  PrintString($A0100000,136,56,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,144,56,FontBlack,VALUEFLOATA,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,336,56,FontBlack,TEXTFLOATA,2) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,368,56,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,376,56,FontBlack,FDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FDLONG      // A0 = Double Data Offset
  ld t0,0(a0)       // T0 = Double Data
  la a0,CVTDSCHECKA // A0 = Long Check Data Offset
  ld t1,0(a0)       // T1 = Long Check Data
  beq t0,t1,CVTDSPASSA // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,520,56,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CVTDSENDA
  nop // Delay Slot
  CVTDSPASSA:
  PrintString($A0100000,520,56,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CVTDSENDA:

  la a0,VALUEFLOATB // A0 = Float Data Offset
  lwc1 f0,0(a0)     // F0 = Float Data
  cvt.d.s f0 // Convert To Double Data
  la a0,FDLONG  // A0 = FDLONG Offset
  sdc1 f0,0(a0) // FDLONG = Double Data
  PrintString($A0100000,136,64,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,144,64,FontBlack,VALUEFLOATB,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,64,FontBlack,TEXTFLOATB,8) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,368,64,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,376,64,FontBlack,FDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FDLONG      // A0 = Double Data Offset
  ld t0,0(a0)       // T0 = Double Data
  la a0,CVTDSCHECKB // A0 = Long Check Data Offset
  ld t1,0(a0)       // T1 = Long Check Data
  beq t0,t1,CVTDSPASSB // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,520,64,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CVTDSENDB
  nop // Delay Slot
  CVTDSPASSB:
  PrintString($A0100000,520,64,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CVTDSENDB:

  la a0,VALUEFLOATC // A0 = Float Data Offset
  lwc1 f0,0(a0)     // F0 = Float Data
  cvt.d.s f0 // Convert To Double Data
  la a0,FDLONG  // A0 = FDLONG Offset
  sdc1 f0,0(a0) // FDLONG = Double Data
  PrintString($A0100000,136,72,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,144,72,FontBlack,VALUEFLOATC,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,280,72,FontBlack,TEXTFLOATC,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,368,72,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,376,72,FontBlack,FDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FDLONG      // A0 = Double Data Offset
  ld t0,0(a0)       // T0 = Double Data
  la a0,CVTDSCHECKC // A0 = Long Check Data Offset
  ld t1,0(a0)       // T1 = Long Check Data
  beq t0,t1,CVTDSPASSC // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,520,72,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CVTDSENDC
  nop // Delay Slot
  CVTDSPASSC:
  PrintString($A0100000,520,72,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CVTDSENDC:


  PrintString($A0100000,8,88,FontRed,CVTDW,6) // Print Text String To VRAM Using Font At X,Y Position
  la a0,VALUEWORDA // A0 = Word Data Offset
  lwc1 f0,0(a0)    // F0 = Word Data
  cvt.d.w f0 // Convert To Double Data
  la a0,FDLONG  // A0 = FDLONG Offset
  sdc1 f0,0(a0) // FDLONG = Double Data
  PrintString($A0100000,136,88,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,144,88,FontBlack,VALUEWORDA,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,88,FontBlack,TEXTWORDA,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,368,88,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,376,88,FontBlack,FDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FDLONG      // A0 = Double Data Offset
  ld t0,0(a0)       // T0 = Double Data
  la a0,CVTDWCHECKA // A0 = Long Check Data Offset
  ld t1,0(a0)       // T1 = Long Check Data
  beq t0,t1,CVTDWPASSA // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,520,88,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CVTDWENDA
  nop // Delay Slot
  CVTDWPASSA:
  PrintString($A0100000,520,88,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CVTDWENDA:

  la a0,VALUEWORDB // A0 = Word Data Offset
  lwc1 f0,0(a0)    // F0 = Word Data
  cvt.d.w f0 // Convert To Double Data
  la a0,FDLONG  // A0 = FDLONG Offset
  sdc1 f0,0(a0) // FDLONG = Double Data
  PrintString($A0100000,136,96,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,144,96,FontBlack,VALUEWORDB,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,328,96,FontBlack,TEXTWORDB,3) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,368,96,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,376,96,FontBlack,FDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FDLONG      // A0 = Double Data Offset
  ld t0,0(a0)       // T0 = Double Data
  la a0,CVTDWCHECKB // A0 = Long Check Data Offset
  ld t1,0(a0)       // T1 = Long Check Data
  beq t0,t1,CVTDWPASSB // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,520,96,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CVTDWENDB
  nop // Delay Slot
  CVTDWPASSB:
  PrintString($A0100000,520,96,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CVTDWENDB:

  la a0,VALUEWORDC // A0 = Word Data Offset
  lwc1 f0,0(a0)    // F0 = Word Data
  cvt.d.w f0 // Convert To Double Data
  la a0,FDLONG  // A0 = FDLONG Offset
  sdc1 f0,0(a0) // FDLONG = Double Data
  PrintString($A0100000,136,104,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,144,104,FontBlack,VALUEWORDC,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,320,104,FontBlack,TEXTWORDC,4) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,368,104,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,376,104,FontBlack,FDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FDLONG      // A0 = Double Data Offset
  ld t0,0(a0)       // T0 = Double Data
  la a0,CVTDWCHECKC // A0 = Long Check Data Offset
  ld t1,0(a0)       // T1 = Long Check Data
  beq t0,t1,CVTDWPASSC // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,520,104,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CVTDWENDC
  nop // Delay Slot
  CVTDWPASSC:
  PrintString($A0100000,520,104,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CVTDWENDC:


  PrintString($A0100000,0,112,FontBlack,PAGEBREAK,79) // Print Text String To VRAM Using Font At X,Y Position


  PrintString($A0100000,8,120,FontRed,CVTLD,6) // Print Text String To VRAM Using Font At X,Y Position
  la a0,VALUEDOUBLEA // A0 = Double Data Offset
  ldc1 f0,0(a0)      // F0 = Double Data
  cvt.l.d f0 // Convert To Long Data
  la a0,FDLONG  // A0 = FDLONG Offset
  sdc1 f0,0(a0) // FDLONG = Long Data
  PrintString($A0100000,72,120,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,80,120,FontBlack,VALUEDOUBLEA,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,336,120,FontBlack,TEXTDOUBLEA,2) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,368,120,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,376,120,FontBlack,FDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FDLONG      // A0 = Long Data Offset
  ld t0,0(a0)       // T0 = Long Data
  la a0,CVTLDCHECKA // A0 = Long Check Data Offset
  ld t1,0(a0)       // T1 = Long Check Data
  beq t0,t1,CVTLDPASSA // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,520,120,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CVTLDENDA
  nop // Delay Slot
  CVTLDPASSA:
  PrintString($A0100000,520,120,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CVTLDENDA:

  la a0,VALUEDOUBLEB // A0 = Double Data Offset
  ldc1 f0,0(a0)      // F0 = Double Data
  cvt.l.d f0 // Convert To Long Data
  la a0,FDLONG  // A0 = FDLONG Offset
  sdc1 f0,0(a0) // FDLONG = Long Data
  PrintString($A0100000,72,128,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,80,128,FontBlack,VALUEDOUBLEB,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,224,128,FontBlack,TEXTDOUBLEB,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,368,128,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,376,128,FontBlack,FDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FDLONG      // A0 = Long Data Offset
  ld t0,0(a0)       // T0 = Long Data
  la a0,CVTLDCHECKB // A0 = Long Check Data Offset
  ld t1,0(a0)       // T1 = Long Check Data
  beq t0,t1,CVTLDPASSB // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,520,128,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CVTLDENDB
  nop // Delay Slot
  CVTLDPASSB:
  PrintString($A0100000,520,128,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CVTLDENDB:

  la a0,VALUEDOUBLEC // A0 = Double Data Offset
  ldc1 f0,0(a0)      // F0 = Double Data
  cvt.l.d f0 // Convert To Long Data
  la a0,FDLONG  // A0 = FDLONG Offset
  sdc1 f0,0(a0) // FDLONG = Long Data
  PrintString($A0100000,72,136,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,80,136,FontBlack,VALUEDOUBLEC,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,216,136,FontBlack,TEXTDOUBLEC,17) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,368,136,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,376,136,FontBlack,FDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FDLONG      // A0 = Long Data Offset
  ld t0,0(a0)       // T0 = Long Data
  la a0,CVTLDCHECKC // A0 = Long Check Data Offset
  ld t1,0(a0)       // T1 = Long Check Data
  beq t0,t1,CVTLDPASSC // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,520,136,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CVTLDENDC
  nop // Delay Slot
  CVTLDPASSC:
  PrintString($A0100000,520,136,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CVTLDENDC:


  PrintString($A0100000,8,152,FontRed,CVTLS,6) // Print Text String To VRAM Using Font At X,Y Position
  la a0,VALUEFLOATA // A0 = Float Data Offset
  lwc1 f0,0(a0)     // F0 = Float Data
  cvt.l.s f0 // Convert To Long Data
  la a0,FDLONG  // A0 = FDLONG Offset
  sdc1 f0,0(a0) // FDLONG = Long Data
  PrintString($A0100000,136,152,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,144,152,FontBlack,VALUEFLOATA,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,336,152,FontBlack,TEXTFLOATA,2) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,368,152,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,376,152,FontBlack,FDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FDLONG      // A0 = Long Data Offset
  ld t0,0(a0)       // T0 = Long Data
  la a0,CVTLSCHECKA // A0 = Long Check Data Offset
  ld t1,0(a0)       // T1 = Long Check Data
  beq t0,t1,CVTLSPASSA // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,520,152,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CVTLSENDA
  nop // Delay Slot
  CVTLSPASSA:
  PrintString($A0100000,520,152,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CVTLSENDA:

  la a0,VALUEFLOATB // A0 = Float Data Offset
  lwc1 f0,0(a0)     // F0 = Float Data
  cvt.l.s f0 // Convert To Long Data
  la a0,FDLONG  // A0 = FDLONG Offset
  sdc1 f0,0(a0) // FDLONG = Long Data
  PrintString($A0100000,136,160,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,144,160,FontBlack,VALUEFLOATB,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,160,FontBlack,TEXTFLOATB,8) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,368,160,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,376,160,FontBlack,FDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FDLONG      // A0 = Long Data Offset
  ld t0,0(a0)       // T0 = Long Data
  la a0,CVTLSCHECKB // A0 = Long Check Data Offset
  ld t1,0(a0)       // T1 = Long Check Data
  beq t0,t1,CVTLSPASSB // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,520,160,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CVTLSENDB
  nop // Delay Slot
  CVTLSPASSB:
  PrintString($A0100000,520,160,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CVTLSENDB:

  la a0,VALUEFLOATC // A0 = Float Data Offset
  lwc1 f0,0(a0)     // F0 = Float Data
  cvt.l.s f0 // Convert To Long Data
  la a0,FDLONG  // A0 = FDLONG Offset
  sdc1 f0,0(a0) // FDLONG = Long Data
  PrintString($A0100000,136,168,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,144,168,FontBlack,VALUEFLOATC,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,280,168,FontBlack,TEXTFLOATC,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,368,168,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,376,168,FontBlack,FDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FDLONG      // A0 = Long Data Offset
  ld t0,0(a0)       // T0 = Long Data
  la a0,CVTLSCHECKC // A0 = Long Check Data Offset
  ld t1,0(a0)       // T1 = Long Check Data
  beq t0,t1,CVTLSPASSC // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,520,168,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CVTLSENDC
  nop // Delay Slot
  CVTLSPASSC:
  PrintString($A0100000,520,168,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CVTLSENDC:


  PrintString($A0100000,0,176,FontBlack,PAGEBREAK,79) // Print Text String To VRAM Using Font At X,Y Position


  PrintString($A0100000,8,184,FontRed,CVTSD,6) // Print Text String To VRAM Using Font At X,Y Position
  la a0,VALUEDOUBLEA // A0 = Double Data Offset
  ldc1 f0,0(a0)      // F0 = Double Data
  cvt.s.d f0 // Convert To Float Data
  la a0,FDWORD  // A0 = FDWORD Offset
  swc1 f0,0(a0) // FDWORD = Float Data
  PrintString($A0100000,72,184,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,80,184,FontBlack,VALUEDOUBLEA,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,336,184,FontBlack,TEXTDOUBLEA,2) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,432,184,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,440,184,FontBlack,FDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FDWORD      // A0 = Float Data Offset
  lw t0,0(a0)       // T0 = Float Data
  la a0,CVTSDCHECKA // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,CVTSDPASSA // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,520,184,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CVTSDENDA
  nop // Delay Slot
  CVTSDPASSA:
  PrintString($A0100000,520,184,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CVTSDENDA:

  la a0,VALUEDOUBLEB // A0 = Double Data Offset
  ldc1 f0,0(a0)      // F0 = Double Data
  cvt.s.d f0 // Convert To Float Data
  la a0,FDWORD  // A0 = FDWORD Offset
  swc1 f0,0(a0) // FDWORD = Float Data
  PrintString($A0100000,72,192,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,80,192,FontBlack,VALUEDOUBLEB,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,224,192,FontBlack,TEXTDOUBLEB,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,432,192,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,440,192,FontBlack,FDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FDWORD      // A0 = Float Data Offset
  lw t0,0(a0)       // T0 = Float Data
  la a0,CVTSDCHECKB // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,CVTSDPASSB // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,520,192,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CVTSDENDB
  nop // Delay Slot
  CVTSDPASSB:
  PrintString($A0100000,520,192,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CVTSDENDB:

  la a0,VALUEDOUBLEC // A0 = Double Data Offset
  ldc1 f0,0(a0)      // F0 = Double Data
  cvt.s.d f0 // Convert To Float Data
  la a0,FDWORD  // A0 = FDWORD Offset
  swc1 f0,0(a0) // FDWORD = Float Data
  PrintString($A0100000,72,200,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,80,200,FontBlack,VALUEDOUBLEC,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,216,200,FontBlack,TEXTDOUBLEC,17) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,432,200,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,440,200,FontBlack,FDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FDWORD      // A0 = Float Data Offset
  lw t0,0(a0)       // T0 = Float Data
  la a0,CVTSDCHECKC // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,CVTSDPASSC // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,520,200,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CVTSDENDC
  nop // Delay Slot
  CVTSDPASSC:
  PrintString($A0100000,520,200,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CVTSDENDC:


  PrintString($A0100000,8,216,FontRed,CVTSL,6) // Print Text String To VRAM Using Font At X,Y Position
  la a0,VALUELONGA // A0 = Long Data Offset
  ldc1 f0,0(a0)    // F0 = Long Data
  cvt.s.l f0 // Convert To Float Data
  la a0,FDWORD  // A0 = FDWORD Offset
  swc1 f0,0(a0) // FDWORD = Float Data
  PrintString($A0100000,72,216,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,80,216,FontBlack,VALUELONGA,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,216,FontBlack,TEXTLONGA,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,432,216,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,440,216,FontBlack,FDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FDWORD      // A0 = Float Data Offset
  lw t0,0(a0)       // T0 = Float Data
  la a0,CVTSLCHECKA // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,CVTSLPASSA // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,520,216,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CVTSLENDA
  nop // Delay Slot
  CVTSLPASSA:
  PrintString($A0100000,520,216,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CVTSLENDA:

  la a0,VALUELONGB // A0 = Long Data Offset
  ldc1 f0,0(a0)    // F0 = Long Data
  cvt.s.l f0 // Convert To Float Data
  la a0,FDWORD  // A0 = FDWORD Offset
  swc1 f0,0(a0) // FDWORD = Float Data
  PrintString($A0100000,72,224,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,80,224,FontBlack,VALUELONGB,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,296,224,FontBlack,TEXTLONGB,7) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,432,224,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,440,224,FontBlack,FDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FDWORD      // A0 = Float Data Offset
  lw t0,0(a0)       // T0 = Float Data
  la a0,CVTSLCHECKB // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,CVTSLPASSB // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,520,224,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CVTSLENDB
  nop // Delay Slot
  CVTSLPASSB:
  PrintString($A0100000,520,224,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CVTSLENDB:

  la a0,VALUELONGC // A0 = Long Data Offset
  ldc1 f0,0(a0)    // F0 = Long Data
  cvt.s.l f0 // Convert To Float Data
  la a0,FDWORD  // A0 = FDWORD Offset
  swc1 f0,0(a0) // FDWORD = Float Data
  PrintString($A0100000,72,232,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,80,232,FontBlack,VALUELONGC,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,232,FontBlack,TEXTLONGC,8) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,432,232,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,440,232,FontBlack,FDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FDWORD      // A0 = Float Data Offset
  lw t0,0(a0)       // T0 = Float Data
  la a0,CVTSLCHECKC // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,CVTSLPASSC // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,520,232,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CVTSLENDC
  nop // Delay Slot
  CVTSLPASSC:
  PrintString($A0100000,520,232,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CVTSLENDC:


  PrintString($A0100000,8,248,FontRed,CVTSW,6) // Print Text String To VRAM Using Font At X,Y Position
  la a0,VALUEWORDA // A0 = Word Data Offset
  lwc1 f0,0(a0)    // F0 = Word Data
  cvt.s.w f0 // Convert To Float Data
  la a0,FDWORD  // A0 = FDWORD Offset
  swc1 f0,0(a0) // FDWORD = Float Data
  PrintString($A0100000,136,248,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,144,248,FontBlack,VALUEWORDA,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,248,FontBlack,TEXTWORDA,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,432,248,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,440,248,FontBlack,FDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FDWORD      // A0 = Float Data Offset
  lw t0,0(a0)       // T0 = Float Data
  la a0,CVTSWCHECKA // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,CVTSWPASSA // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,520,248,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CVTSWENDA
  nop // Delay Slot
  CVTSWPASSA:
  PrintString($A0100000,520,248,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CVTSWENDA:

  la a0,VALUEWORDB // A0 = Word Data Offset
  lwc1 f0,0(a0)    // F0 = Word Data
  cvt.s.w f0 // Convert To Float Data
  la a0,FDWORD  // A0 = FDWORD Offset
  swc1 f0,0(a0) // FDWORD = Float Data
  PrintString($A0100000,136,256,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,144,256,FontBlack,VALUEWORDB,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,328,256,FontBlack,TEXTWORDB,3) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,432,256,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,440,256,FontBlack,FDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FDWORD      // A0 = Float Data Offset
  lw t0,0(a0)       // T0 = Float Data
  la a0,CVTSWCHECKB // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,CVTSWPASSB // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,520,256,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CVTSWENDB
  nop // Delay Slot
  CVTSWPASSB:
  PrintString($A0100000,520,256,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CVTSWENDB:

  la a0,VALUEWORDC // A0 = Word Data Offset
  lwc1 f0,0(a0)    // F0 = Word Data
  cvt.s.w f0 // Convert To Float Data
  la a0,FDWORD  // A0 = FDWORD Offset
  swc1 f0,0(a0) // FDWORD = Float Data
  PrintString($A0100000,136,264,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,144,264,FontBlack,VALUEWORDC,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,320,264,FontBlack,TEXTWORDC,4) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,432,264,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,440,264,FontBlack,FDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FDWORD      // A0 = Float Data Offset
  lw t0,0(a0)       // T0 = Float Data
  la a0,CVTSWCHECKC // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,CVTSWPASSC // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,520,264,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CVTSWENDC
  nop // Delay Slot
  CVTSWPASSC:
  PrintString($A0100000,520,264,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CVTSWENDC:


  PrintString($A0100000,0,272,FontBlack,PAGEBREAK,79) // Print Text String To VRAM Using Font At X,Y Position


  PrintString($A0100000,8,280,FontRed,CVTWD,6) // Print Text String To VRAM Using Font At X,Y Position
  la a0,VALUEDOUBLEA // A0 = Double Data Offset
  ldc1 f0,0(a0)      // F0 = Double Data
  cvt.w.d f0 // Convert To Word Data
  la a0,FDWORD  // A0 = FDWORD Offset
  swc1 f0,0(a0) // FDWORD = Word Data
  PrintString($A0100000,72,280,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,80,280,FontBlack,VALUEDOUBLEA,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,336,280,FontBlack,TEXTDOUBLEA,2) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,432,280,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,440,280,FontBlack,FDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FDWORD      // A0 = Word Data Offset
  lw t0,0(a0)       // T0 = Word Data
  la a0,CVTWDCHECKA // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,CVTWDPASSA // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,520,280,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CVTWDENDA
  nop // Delay Slot
  CVTWDPASSA:
  PrintString($A0100000,520,280,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CVTWDENDA:

  la a0,VALUEDOUBLEB // A0 = Double Data Offset
  ldc1 f0,0(a0)      // F0 = Double Data
  cvt.w.d f0 // Convert To Word Data
  la a0,FDWORD  // A0 = FDWORD Offset
  swc1 f0,0(a0) // FDWORD = Word Data
  PrintString($A0100000,72,288,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,80,288,FontBlack,VALUEDOUBLEB,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,224,288,FontBlack,TEXTDOUBLEB,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,432,288,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,440,288,FontBlack,FDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FDWORD      // A0 = Word Data Offset
  lw t0,0(a0)       // T0 = Word Data
  la a0,CVTWDCHECKB // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,CVTWDPASSB // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,520,288,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CVTWDENDB
  nop // Delay Slot
  CVTWDPASSB:
  PrintString($A0100000,520,288,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CVTWDENDB:

  la a0,VALUEDOUBLEC // A0 = Double Data Offset
  ldc1 f0,0(a0)      // F0 = Double Data
  cvt.w.d f0 // Convert To Word Data
  la a0,FDWORD  // A0 = FDWORD Offset
  swc1 f0,0(a0) // FDWORD = Word Data
  PrintString($A0100000,72,296,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,80,296,FontBlack,VALUEDOUBLEC,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,216,296,FontBlack,TEXTDOUBLEC,17) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,432,296,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,440,296,FontBlack,FDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FDWORD      // A0 = Word Data Offset
  lw t0,0(a0)       // T0 = Word Data
  la a0,CVTWDCHECKC // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,CVTWDPASSC // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,520,296,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CVTWDENDC
  nop // Delay Slot
  CVTWDPASSC:
  PrintString($A0100000,520,296,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CVTWDENDC:


  PrintString($A0100000,8,312,FontRed,CVTWS,6) // Print Text String To VRAM Using Font At X,Y Position
  la a0,VALUEFLOATA // A0 = Float Data Offset
  lwc1 f0,0(a0)     // F0 = Float Data
  cvt.w.s f0 // Convert To Word Data
  la a0,FDWORD  // A0 = FDWORD Offset
  swc1 f0,0(a0) // FDWORD = Word Data
  PrintString($A0100000,136,312,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,144,312,FontBlack,VALUEFLOATA,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,336,312,FontBlack,TEXTFLOATA,2) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,432,312,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,440,312,FontBlack,FDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FDWORD      // A0 = Word Data Offset
  lw t0,0(a0)       // T0 = Word Data
  la a0,CVTWSCHECKA // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,CVTWSPASSA // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,520,312,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CVTWSENDA
  nop // Delay Slot
  CVTWSPASSA:
  PrintString($A0100000,520,312,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CVTWSENDA:

  la a0,VALUEFLOATB // A0 = Float Data Offset
  lwc1 f0,0(a0)     // F0 = Float Data
  cvt.w.s f0 // Convert To Word Data
  la a0,FDWORD  // A0 = FDWORD Offset
  swc1 f0,0(a0) // FDWORD = Word Data
  PrintString($A0100000,136,320,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,144,320,FontBlack,VALUEFLOATB,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,320,FontBlack,TEXTFLOATB,8) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,432,320,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,440,320,FontBlack,FDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FDWORD      // A0 = Word Data Offset
  lw t0,0(a0)       // T0 = Word Data
  la a0,CVTWSCHECKB // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,CVTWSPASSB // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,520,320,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CVTWSENDB
  nop // Delay Slot
  CVTWSPASSB:
  PrintString($A0100000,520,320,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CVTWSENDB:

  la a0,VALUEFLOATC // A0 = Float Data Offset
  lwc1 f0,0(a0)     // F0 = Float Data
  cvt.w.s f0 // Convert To Word Data
  la a0,FDWORD  // A0 = FDWORD Offset
  swc1 f0,0(a0) // FDWORD = Word Data
  PrintString($A0100000,136,328,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,144,328,FontBlack,VALUEFLOATC,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,280,328,FontBlack,TEXTFLOATC,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,432,328,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,440,328,FontBlack,FDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FDWORD      // A0 = Word Data Offset
  lw t0,0(a0)       // T0 = Word Data
  la a0,CVTWSCHECKC // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,CVTWSPASSC // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,520,328,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CVTWSENDC
  nop // Delay Slot
  CVTWSPASSC:
  PrintString($A0100000,520,328,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CVTWSENDC:


  PrintString($A0100000,0,336,FontBlack,PAGEBREAK,79) // Print Text String To VRAM Using Font At X,Y Position


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

CVTDL:
  db "CVT.D.L"
CVTDS:
  db "CVT.D.S"
CVTDW:
  db "CVT.D.W"

CVTLD:
  db "CVT.L.D"
CVTLS:
  db "CVT.L.S"

CVTSD:
  db "CVT.S.D"
CVTSL:
  db "CVT.S.L"
CVTSW:
  db "CVT.S.W"

CVTWD:
  db "CVT.W.D"
CVTWS:
  db "CVT.W.S"

FDHEX:
  db "FD (Hex)"
FSHEX:
  db "FS (Hex)"
FDFSDEC:
  db "FS/FD (Decimal)"
TEST:
  db "Test Result"
FAIL:
  db "FAIL"
PASS:
  db "PASS"

DOLLAR:
  db "$"

TEXTDOUBLEA:
  db "0.0"
TEXTDOUBLEB:
  db "12345678.12345678"
TEXTDOUBLEC:
  db "-12345678.12345678"

TEXTLONGA:
  db "0"
TEXTLONGB:
  db "12345678"
TEXTLONGC:
  db "-12345678"

TEXTFLOATA:
  db "0.0"
TEXTFLOATB:
  db "1234.1234"
TEXTFLOATC:
  db "-1234.1234"

TEXTWORDA:
  db "0"
TEXTWORDB:
  db "1234"
TEXTWORDC:
  db "-1234"

PAGEBREAK:
  db "--------------------------------------------------------------------------------"

align(8) // Align 64-Bit
VALUEDOUBLEA:
  float64 0.0
VALUEDOUBLEB:
  float64 12345678.12345678
VALUEDOUBLEC:
  float64 -12345678.12345678

VALUELONGA:
  dd 0
VALUELONGB:
  dd 12345678
VALUELONGC:
  dd -12345678

CVTDLCHECKA:
  dd $0000000000000000
CVTDLCHECKB:
  dd $41678C29C0000000
CVTDLCHECKC:
  dd $C1678C29C0000000

CVTDSCHECKA:
  dd $0000000000000000
CVTDSCHECKB:
  dd $4093487E60000000
CVTDSCHECKC:
  dd $C093487E60000000

CVTDWCHECKA:
  dd $0000000000000000
CVTDWCHECKB:
  dd $4093480000000000
CVTDWCHECKC:
  dd $C093480000000000

CVTLDCHECKA:
  dd $0000000000000000
CVTLDCHECKB:
  dd $0000000000BC614E
CVTLDCHECKC:
  dd $FFFFFFFFFF439EB2

CVTLSCHECKA:
  dd $0000000000000000
CVTLSCHECKB:
  dd $00000000000004D2
CVTLSCHECKC:
  dd $FFFFFFFFFFFFFB2E

FDLONG:
  dd 0

VALUEFLOATA:
  float32 0.0
VALUEFLOATB:
  float32 1234.1234
VALUEFLOATC:
  float32 -1234.1234

VALUEWORDA:
  dw 0
VALUEWORDB:
  dw 1234
VALUEWORDC:
  dw -1234

CVTSDCHECKA:
  dw $00000000
CVTSDCHECKB:
  dw $4B3C614E
CVTSDCHECKC:
  dw $CB3C614E

CVTSLCHECKA:
  dw $00000000
CVTSLCHECKB:
  dw $4B3C614E
CVTSLCHECKC:
  dw $CB3C614E

CVTSWCHECKA:
  dw $00000000
CVTSWCHECKB:
  dw $449A4000
CVTSWCHECKC:
  dw $C49A4000

CVTWDCHECKA:
  dw $00000000
CVTWDCHECKB:
  dw $00BC614E
CVTWDCHECKC:
  dw $FF439EB2

CVTWSCHECKA:
  dw $00000000
CVTWSCHECKB:
  dw $000004D2
CVTWSCHECKC:
  dw $FFFFFB2E

FDWORD:
  dw 0

insert FontBlack, "FontBlack8x8.bin"
insert FontGreen, "FontGreen8x8.bin"
insert FontRed, "FontRed8x8.bin"