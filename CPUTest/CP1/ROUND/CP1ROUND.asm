// N64 'Bare Metal' CPU CP1/FPU Round Test Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "CP1ROUND.N64", create
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


  PrintString($A0100000,88,8,FontRed,FSHEX,7) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,8,FontRed,FDFSDEC,14) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,384,8,FontRed,FDHEX,7) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,528,8,FontRed,TEST,10) // Print Text String To VRAM Using Font At X,Y Position


  PrintString($A0100000,0,16,FontBlack,PAGEBREAK,79) // Print Text String To VRAM Using Font At X,Y Position


  PrintString($A0100000,8,24,FontRed,ROUNDLD,8) // Print Text String To VRAM Using Font At X,Y Position
  la a0,VALUEDOUBLEA // A0 = Double Data Offset
  ldc1 f0,0(a0)      // F0 = Double Data
  round.l.d f0 // Convert To Long Data
  la a0,FDLONG  // A0 = FDLONG Offset
  sdc1 f0,0(a0) // FDLONG = Long Data
  PrintString($A0100000,80,24,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,24,FontBlack,VALUEDOUBLEA,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,344,24,FontBlack,TEXTDOUBLEA,2) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,24,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,24,FontBlack,FDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FDLONG        // A0 = Long Data Offset
  ld t0,0(a0)         // T0 = Long Data
  la a0,ROUNDLDCHECKA // A0 = Long Check Data Offset
  ld t1,0(a0)         // T1 = Long Check Data
  beq t0,t1,ROUNDLDPASSA // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,24,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j ROUNDLDENDA
  nop // Delay Slot
  ROUNDLDPASSA:
  PrintString($A0100000,528,24,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  ROUNDLDENDA:

  la a0,VALUEDOUBLEB // A0 = Double Data Offset
  ldc1 f0,0(a0)      // F0 = Double Data
  round.l.d f0 // Convert To Long Data
  la a0,FDLONG  // A0 = FDLONG Offset
  sdc1 f0,0(a0) // FDLONG = Long Data
  PrintString($A0100000,80,32,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,32,FontBlack,VALUEDOUBLEB,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,32,FontBlack,TEXTDOUBLEB,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,32,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,32,FontBlack,FDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FDLONG        // A0 = Long Data Offset
  ld t0,0(a0)         // T0 = Long Data
  la a0,ROUNDLDCHECKB // A0 = Long Check Data Offset
  ld t1,0(a0)         // T1 = Long Check Data
  beq t0,t1,ROUNDLDPASSB // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,32,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j ROUNDLDENDB
  nop // Delay Slot
  ROUNDLDPASSB:
  PrintString($A0100000,528,32,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  ROUNDLDENDB:

  la a0,VALUEDOUBLEC // A0 = Double Data Offset
  ldc1 f0,0(a0)      // F0 = Double Data
  round.l.d f0 // Convert To Long Data
  la a0,FDLONG  // A0 = FDLONG Offset
  sdc1 f0,0(a0) // FDLONG = Long Data
  PrintString($A0100000,80,40,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,40,FontBlack,VALUEDOUBLEC,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,40,FontBlack,TEXTDOUBLEC,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,40,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,40,FontBlack,FDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FDLONG        // A0 = Long Data Offset
  ld t0,0(a0)         // T0 = Long Data
  la a0,ROUNDLDCHECKC // A0 = Long Check Data Offset
  ld t1,0(a0)         // T1 = Long Check Data
  beq t0,t1,ROUNDLDPASSC // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,40,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j ROUNDLDENDC
  nop // Delay Slot
  ROUNDLDPASSC:
  PrintString($A0100000,528,40,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  ROUNDLDENDC:

  la a0,VALUEDOUBLED // A0 = Double Data Offset
  ldc1 f0,0(a0)      // F0 = Double Data
  round.l.d f0 // Convert To Long Data
  la a0,FDLONG  // A0 = FDLONG Offset
  sdc1 f0,0(a0) // FDLONG = Long Data
  PrintString($A0100000,80,48,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,48,FontBlack,VALUEDOUBLED,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,48,FontBlack,TEXTDOUBLED,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,48,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,48,FontBlack,FDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FDLONG        // A0 = Long Data Offset
  ld t0,0(a0)         // T0 = Long Data
  la a0,ROUNDLDCHECKD // A0 = Long Check Data Offset
  ld t1,0(a0)         // T1 = Long Check Data
  beq t0,t1,ROUNDLDPASSD // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,48,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j ROUNDLDENDD
  nop // Delay Slot
  ROUNDLDPASSD:
  PrintString($A0100000,528,48,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  ROUNDLDENDD:

  la a0,VALUEDOUBLEE // A0 = Double Data Offset
  ldc1 f0,0(a0)      // F0 = Double Data
  round.l.d f0 // Convert To Long Data
  la a0,FDLONG  // A0 = FDLONG Offset
  sdc1 f0,0(a0) // FDLONG = Long Data
  PrintString($A0100000,80,56,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,56,FontBlack,VALUEDOUBLEE,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,224,56,FontBlack,TEXTDOUBLEE,17) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,56,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,56,FontBlack,FDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FDLONG        // A0 = Long Data Offset
  ld t0,0(a0)         // T0 = Long Data
  la a0,ROUNDLDCHECKE // A0 = Long Check Data Offset
  ld t1,0(a0)         // T1 = Long Check Data
  beq t0,t1,ROUNDLDPASSE // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,56,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j ROUNDLDENDE
  nop // Delay Slot
  ROUNDLDPASSE:
  PrintString($A0100000,528,56,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  ROUNDLDENDE:

  la a0,VALUEDOUBLEF // A0 = Double Data Offset
  ldc1 f0,0(a0)      // F0 = Double Data
  round.l.d f0 // Convert To Long Data
  la a0,FDLONG  // A0 = FDLONG Offset
  sdc1 f0,0(a0) // FDLONG = Long Data
  PrintString($A0100000,80,64,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,64,FontBlack,VALUEDOUBLEF,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,280,64,FontBlack,TEXTDOUBLEF,10) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,64,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,64,FontBlack,FDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FDLONG        // A0 = Long Data Offset
  ld t0,0(a0)         // T0 = Long Data
  la a0,ROUNDLDCHECKF // A0 = Long Check Data Offset
  ld t1,0(a0)         // T1 = Long Check Data
  beq t0,t1,ROUNDLDPASSF // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,64,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j ROUNDLDENDF
  nop // Delay Slot
  ROUNDLDPASSF:
  PrintString($A0100000,528,64,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  ROUNDLDENDF:

  la a0,VALUEDOUBLEG // A0 = Double Data Offset
  ldc1 f0,0(a0)      // F0 = Double Data
  round.l.d f0 // Convert To Long Data
  la a0,FDLONG  // A0 = FDLONG Offset
  sdc1 f0,0(a0) // FDLONG = Long Data
  PrintString($A0100000,80,72,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,72,FontBlack,VALUEDOUBLEG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,224,72,FontBlack,TEXTDOUBLEG,17) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,72,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,72,FontBlack,FDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FDLONG        // A0 = Long Data Offset
  ld t0,0(a0)         // T0 = Long Data
  la a0,ROUNDLDCHECKG // A0 = Long Check Data Offset
  ld t1,0(a0)         // T1 = Long Check Data
  beq t0,t1,ROUNDLDPASSG // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,72,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j ROUNDLDENDG
  nop // Delay Slot
  ROUNDLDPASSG:
  PrintString($A0100000,528,72,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  ROUNDLDENDG:


  PrintString($A0100000,8,88,FontRed,ROUNDLS,8) // Print Text String To VRAM Using Font At X,Y Position
  la a0,VALUEFLOATA // A0 = Float Data Offset
  lwc1 f0,0(a0)     // F0 = Float Data
  round.l.s f0 // Convert To Long Data
  la a0,FDLONG  // A0 = FDLONG Offset
  sdc1 f0,0(a0) // FDLONG = Long Data
  PrintString($A0100000,144,88,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,88,FontBlack,VALUEFLOATA,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,344,88,FontBlack,TEXTFLOATA,2) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,88,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,88,FontBlack,FDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FDLONG        // A0 = Long Data Offset
  ld t0,0(a0)         // T0 = Long Data
  la a0,ROUNDLSCHECKA // A0 = Long Check Data Offset
  ld t1,0(a0)         // T1 = Long Check Data
  beq t0,t1,ROUNDLSPASSA // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,88,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j ROUNDLSENDA
  nop // Delay Slot
  ROUNDLSPASSA:
  PrintString($A0100000,528,88,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  ROUNDLSENDA:

  la a0,VALUEFLOATB // A0 = Float Data Offset
  lwc1 f0,0(a0)     // F0 = Float Data
  round.l.s f0 // Convert To Long Data
  la a0,FDLONG  // A0 = FDLONG Offset
  sdc1 f0,0(a0) // FDLONG = Long Data
  PrintString($A0100000,144,96,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,96,FontBlack,VALUEFLOATB,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,296,96,FontBlack,TEXTFLOATB,8) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,96,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,96,FontBlack,FDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FDLONG        // A0 = Long Data Offset
  ld t0,0(a0)         // T0 = Long Data
  la a0,ROUNDLSCHECKB // A0 = Long Check Data Offset
  ld t1,0(a0)         // T1 = Long Check Data
  beq t0,t1,ROUNDLSPASSB // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,96,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j ROUNDLSENDB
  nop // Delay Slot
  ROUNDLSPASSB:
  PrintString($A0100000,528,96,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  ROUNDLSENDB:

  la a0,VALUEFLOATC // A0 = Float Data Offset
  lwc1 f0,0(a0)     // F0 = Float Data
  round.l.s f0 // Convert To Long Data
  la a0,FDLONG  // A0 = FDLONG Offset
  sdc1 f0,0(a0) // FDLONG = Long Data
  PrintString($A0100000,144,104,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,104,FontBlack,VALUEFLOATC,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,320,104,FontBlack,TEXTFLOATC,5) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,104,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,104,FontBlack,FDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FDLONG        // A0 = Long Data Offset
  ld t0,0(a0)         // T0 = Long Data
  la a0,ROUNDLSCHECKC // A0 = Long Check Data Offset
  ld t1,0(a0)         // T1 = Long Check Data
  beq t0,t1,ROUNDLSPASSC // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,104,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j ROUNDLSENDC
  nop // Delay Slot
  ROUNDLSPASSC:
  PrintString($A0100000,528,104,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  ROUNDLSENDC:

  la a0,VALUEFLOATD // A0 = Float Data Offset
  lwc1 f0,0(a0)     // F0 = Float Data
  round.l.s f0 // Convert To Long Data
  la a0,FDLONG  // A0 = FDLONG Offset
  sdc1 f0,0(a0) // FDLONG = Long Data
  PrintString($A0100000,144,112,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,112,FontBlack,VALUEFLOATD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,296,112,FontBlack,TEXTFLOATD,8) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,112,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,112,FontBlack,FDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FDLONG        // A0 = Long Data Offset
  ld t0,0(a0)         // T0 = Long Data
  la a0,ROUNDLSCHECKD // A0 = Long Check Data Offset
  ld t1,0(a0)         // T1 = Long Check Data
  beq t0,t1,ROUNDLSPASSD // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,112,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j ROUNDLSENDD
  nop // Delay Slot
  ROUNDLSPASSD:
  PrintString($A0100000,528,112,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  ROUNDLSENDD:

  la a0,VALUEFLOATE // A0 = Float Data Offset
  lwc1 f0,0(a0)     // F0 = Float Data
  round.l.s f0 // Convert To Long Data
  la a0,FDLONG  // A0 = FDLONG Offset
  sdc1 f0,0(a0) // FDLONG = Long Data
  PrintString($A0100000,144,120,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,120,FontBlack,VALUEFLOATE,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,120,FontBlack,TEXTFLOATE,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,120,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,120,FontBlack,FDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FDLONG        // A0 = Long Data Offset
  ld t0,0(a0)         // T0 = Long Data
  la a0,ROUNDLSCHECKE // A0 = Long Check Data Offset
  ld t1,0(a0)         // T1 = Long Check Data
  beq t0,t1,ROUNDLSPASSE // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,120,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j ROUNDLSENDE
  nop // Delay Slot
  ROUNDLSPASSE:
  PrintString($A0100000,528,120,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  ROUNDLSENDE:

  la a0,VALUEFLOATF // A0 = Float Data Offset
  lwc1 f0,0(a0)     // F0 = Float Data
  round.l.s f0 // Convert To Long Data
  la a0,FDLONG  // A0 = FDLONG Offset
  sdc1 f0,0(a0) // FDLONG = Long Data
  PrintString($A0100000,144,128,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,128,FontBlack,VALUEFLOATF,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,312,128,FontBlack,TEXTFLOATF,6) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,128,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,128,FontBlack,FDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FDLONG        // A0 = Long Data Offset
  ld t0,0(a0)         // T0 = Long Data
  la a0,ROUNDLSCHECKF // A0 = Long Check Data Offset
  ld t1,0(a0)         // T1 = Long Check Data
  beq t0,t1,ROUNDLSPASSF // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,128,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j ROUNDLSENDF
  nop // Delay Slot
  ROUNDLSPASSF:
  PrintString($A0100000,528,128,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  ROUNDLSENDF:

  la a0,VALUEFLOATG // A0 = Float Data Offset
  lwc1 f0,0(a0)     // F0 = Float Data
  round.l.s f0 // Convert To Long Data
  la a0,FDLONG  // A0 = FDLONG Offset
  sdc1 f0,0(a0) // FDLONG = Long Data
  PrintString($A0100000,144,136,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,136,FontBlack,VALUEFLOATG,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,136,FontBlack,TEXTFLOATG,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,136,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,136,FontBlack,FDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FDLONG        // A0 = Long Data Offset
  ld t0,0(a0)         // T0 = Long Data
  la a0,ROUNDLSCHECKG // A0 = Long Check Data Offset
  ld t1,0(a0)         // T1 = Long Check Data
  beq t0,t1,ROUNDLSPASSG // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,136,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j ROUNDLSENDG
  nop // Delay Slot
  ROUNDLSPASSG:
  PrintString($A0100000,528,136,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  ROUNDLSENDG:


  PrintString($A0100000,0,144,FontBlack,PAGEBREAK,79) // Print Text String To VRAM Using Font At X,Y Position


  PrintString($A0100000,8,152,FontRed,ROUNDWD,8) // Print Text String To VRAM Using Font At X,Y Position
  la a0,VALUEDOUBLEA // A0 = Double Data Offset
  ldc1 f0,0(a0)      // F0 = Double Data
  round.w.d f0 // Convert To Word Data
  la a0,FDWORD  // A0 = FDWORD Offset
  swc1 f0,0(a0) // FDWORD = Word Data
  PrintString($A0100000,80,152,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,152,FontBlack,VALUEDOUBLEA,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,344,152,FontBlack,TEXTDOUBLEA,2) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,152,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,152,FontBlack,FDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FDWORD        // A0 = Word Data Offset
  lw t0,0(a0)         // T0 = Word Data
  la a0,ROUNDWDCHECKA // A0 = Word Check Data Offset
  lw t1,0(a0)         // T1 = Word Check Data
  beq t0,t1,ROUNDWDPASSA // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,152,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j ROUNDWDENDA
  nop // Delay Slot
  ROUNDWDPASSA:
  PrintString($A0100000,528,152,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  ROUNDWDENDA:

  la a0,VALUEDOUBLEB // A0 = Double Data Offset
  ldc1 f0,0(a0)      // F0 = Double Data
  round.w.d f0 // Convert To Word Data
  la a0,FDWORD  // A0 = FDWORD Offset
  swc1 f0,0(a0) // FDWORD = Word Data
  PrintString($A0100000,80,160,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,160,FontBlack,VALUEDOUBLEB,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,160,FontBlack,TEXTDOUBLEB,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,160,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,160,FontBlack,FDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FDWORD        // A0 = Word Data Offset
  lw t0,0(a0)         // T0 = Word Data
  la a0,ROUNDWDCHECKB // A0 = Word Check Data Offset
  lw t1,0(a0)         // T1 = Word Check Data
  beq t0,t1,ROUNDWDPASSB // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,160,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j ROUNDWDENDB
  nop // Delay Slot
  ROUNDWDPASSB:
  PrintString($A0100000,528,160,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  ROUNDWDENDB:

  la a0,VALUEDOUBLEC // A0 = Double Data Offset
  ldc1 f0,0(a0)      // F0 = Double Data
  round.w.d f0 // Convert To Word Data
  la a0,FDWORD  // A0 = FDWORD Offset
  swc1 f0,0(a0) // FDWORD = Word Data
  PrintString($A0100000,80,168,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,168,FontBlack,VALUEDOUBLEC,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,168,FontBlack,TEXTDOUBLEC,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,168,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,168,FontBlack,FDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FDWORD        // A0 = Word Data Offset
  lw t0,0(a0)         // T0 = Word Data
  la a0,ROUNDWDCHECKC // A0 = Word Check Data Offset
  lw t1,0(a0)         // T1 = Word Check Data
  beq t0,t1,ROUNDWDPASSC // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,168,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j ROUNDWDENDC
  nop // Delay Slot
  ROUNDWDPASSC:
  PrintString($A0100000,528,168,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  ROUNDWDENDC:

  la a0,VALUEDOUBLED // A0 = Double Data Offset
  ldc1 f0,0(a0)      // F0 = Double Data
  round.w.d f0 // Convert To Word Data
  la a0,FDWORD  // A0 = FDWORD Offset
  swc1 f0,0(a0) // FDWORD = Word Data
  PrintString($A0100000,80,176,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,176,FontBlack,VALUEDOUBLED,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,176,FontBlack,TEXTDOUBLED,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,176,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,176,FontBlack,FDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FDWORD        // A0 = Word Data Offset
  lw t0,0(a0)         // T0 = Word Data
  la a0,ROUNDWDCHECKD // A0 = Word Check Data Offset
  lw t1,0(a0)         // T1 = Word Check Data
  beq t0,t1,ROUNDWDPASSD // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,176,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j ROUNDWDENDD
  nop // Delay Slot
  ROUNDWDPASSD:
  PrintString($A0100000,528,176,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  ROUNDWDENDD:

  la a0,VALUEDOUBLEE // A0 = Double Data Offset
  ldc1 f0,0(a0)      // F0 = Double Data
  round.w.d f0 // Convert To Word Data
  la a0,FDWORD  // A0 = FDWORD Offset
  swc1 f0,0(a0) // FDWORD = Word Data
  PrintString($A0100000,80,184,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,184,FontBlack,VALUEDOUBLEE,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,224,184,FontBlack,TEXTDOUBLEE,17) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,184,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,184,FontBlack,FDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FDWORD        // A0 = Word Data Offset
  lw t0,0(a0)         // T0 = Word Data
  la a0,ROUNDWDCHECKE // A0 = Word Check Data Offset
  lw t1,0(a0)         // T1 = Word Check Data
  beq t0,t1,ROUNDWDPASSE // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,184,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j ROUNDWDENDE
  nop // Delay Slot
  ROUNDWDPASSE:
  PrintString($A0100000,528,184,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  ROUNDWDENDE:

  la a0,VALUEDOUBLEF // A0 = Double Data Offset
  ldc1 f0,0(a0)      // F0 = Double Data
  round.w.d f0 // Convert To Word Data
  la a0,FDWORD  // A0 = FDWORD Offset
  swc1 f0,0(a0) // FDWORD = Word Data
  PrintString($A0100000,80,192,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,192,FontBlack,VALUEDOUBLEF,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,280,192,FontBlack,TEXTDOUBLEF,10) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,192,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,192,FontBlack,FDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FDWORD        // A0 = Word Data Offset
  lw t0,0(a0)         // T0 = Word Data
  la a0,ROUNDWDCHECKF // A0 = Word Check Data Offset
  lw t1,0(a0)         // T1 = Word Check Data
  beq t0,t1,ROUNDWDPASSF // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,192,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j ROUNDWDENDF
  nop // Delay Slot
  ROUNDWDPASSF:
  PrintString($A0100000,528,192,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  ROUNDWDENDF:

  la a0,VALUEDOUBLEG // A0 = Double Data Offset
  ldc1 f0,0(a0)      // F0 = Double Data
  round.w.d f0 // Convert To Word Data
  la a0,FDWORD  // A0 = FDWORD Offset
  swc1 f0,0(a0) // FDWORD = Word Data
  PrintString($A0100000,80,200,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,200,FontBlack,VALUEDOUBLEG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,224,200,FontBlack,TEXTDOUBLEG,17) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,200,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,200,FontBlack,FDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FDWORD        // A0 = Word Data Offset
  lw t0,0(a0)         // T0 = Word Data
  la a0,ROUNDWDCHECKG // A0 = Word Check Data Offset
  lw t1,0(a0)         // T1 = Word Check Data
  beq t0,t1,ROUNDWDPASSG // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,200,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j ROUNDWDENDG
  nop // Delay Slot
  ROUNDWDPASSG:
  PrintString($A0100000,528,200,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  ROUNDWDENDG:


  PrintString($A0100000,8,216,FontRed,ROUNDWS,8) // Print Text String To VRAM Using Font At X,Y Position
  la a0,VALUEFLOATA // A0 = Float Data Offset
  lwc1 f0,0(a0)     // F0 = Float Data
  round.w.s f0 // Convert To Word Data
  la a0,FDWORD  // A0 = FDWORD Offset
  swc1 f0,0(a0) // FDWORD = Word Data
  PrintString($A0100000,144,216,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,216,FontBlack,VALUEFLOATA,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,344,216,FontBlack,TEXTFLOATA,2) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,216,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,216,FontBlack,FDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FDWORD        // A0 = Word Data Offset
  lw t0,0(a0)         // T0 = Word Data
  la a0,ROUNDWSCHECKA // A0 = Word Check Data Offset
  lw t1,0(a0)         // T1 = Word Check Data
  beq t0,t1,ROUNDWSPASSA // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,216,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j ROUNDWSENDA
  nop // Delay Slot
  ROUNDWSPASSA:
  PrintString($A0100000,528,216,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  ROUNDWSENDA:

  la a0,VALUEFLOATB // A0 = Float Data Offset
  lwc1 f0,0(a0)     // F0 = Float Data
  round.w.s f0 // Convert To Word Data
  la a0,FDWORD  // A0 = FDWORD Offset
  swc1 f0,0(a0) // FDWORD = Word Data
  PrintString($A0100000,144,224,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,224,FontBlack,VALUEFLOATB,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,296,224,FontBlack,TEXTFLOATB,8) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,224,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,224,FontBlack,FDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FDWORD        // A0 = Word Data Offset
  lw t0,0(a0)         // T0 = Word Data
  la a0,ROUNDWSCHECKB // A0 = Word Check Data Offset
  lw t1,0(a0)         // T1 = Word Check Data
  beq t0,t1,ROUNDWSPASSB // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,224,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j ROUNDWSENDB
  nop // Delay Slot
  ROUNDWSPASSB:
  PrintString($A0100000,528,224,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  ROUNDWSENDB:

  la a0,VALUEFLOATC // A0 = Float Data Offset
  lwc1 f0,0(a0)     // F0 = Float Data
  round.w.s f0 // Convert To Word Data
  la a0,FDWORD  // A0 = FDWORD Offset
  swc1 f0,0(a0) // FDWORD = Word Data
  PrintString($A0100000,144,232,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,232,FontBlack,VALUEFLOATC,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,320,232,FontBlack,TEXTFLOATC,5) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,232,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,232,FontBlack,FDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FDWORD        // A0 = Word Data Offset
  lw t0,0(a0)         // T0 = Word Data
  la a0,ROUNDWSCHECKC // A0 = Word Check Data Offset
  lw t1,0(a0)         // T1 = Word Check Data
  beq t0,t1,ROUNDWSPASSC // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,232,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j ROUNDWSENDC
  nop // Delay Slot
  ROUNDWSPASSC:
  PrintString($A0100000,528,232,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  ROUNDWSENDC:

  la a0,VALUEFLOATD // A0 = Float Data Offset
  lwc1 f0,0(a0)     // F0 = Float Data
  round.w.s f0 // Convert To Word Data
  la a0,FDWORD  // A0 = FDWORD Offset
  swc1 f0,0(a0) // FDWORD = Word Data
  PrintString($A0100000,144,240,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,240,FontBlack,VALUEFLOATD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,296,240,FontBlack,TEXTFLOATD,8) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,240,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,240,FontBlack,FDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FDWORD        // A0 = Word Data Offset
  lw t0,0(a0)         // T0 = Word Data
  la a0,ROUNDWSCHECKD // A0 = Word Check Data Offset
  lw t1,0(a0)         // T1 = Word Check Data
  beq t0,t1,ROUNDWSPASSD // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,240,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j ROUNDWSENDD
  nop // Delay Slot
  ROUNDWSPASSD:
  PrintString($A0100000,528,240,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  ROUNDWSENDD:

  la a0,VALUEFLOATE // A0 = Float Data Offset
  lwc1 f0,0(a0)     // F0 = Float Data
  round.w.s f0 // Convert To Word Data
  la a0,FDWORD  // A0 = FDWORD Offset
  swc1 f0,0(a0) // FDWORD = Word Data
  PrintString($A0100000,144,248,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,248,FontBlack,VALUEFLOATE,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,248,FontBlack,TEXTFLOATE,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,248,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,248,FontBlack,FDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FDWORD        // A0 = Word Data Offset
  lw t0,0(a0)         // T0 = Word Data
  la a0,ROUNDWSCHECKE // A0 = Word Check Data Offset
  lw t1,0(a0)         // T1 = Word Check Data
  beq t0,t1,ROUNDWSPASSE // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,248,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j ROUNDWSENDE
  nop // Delay Slot
  ROUNDWSPASSE:
  PrintString($A0100000,528,248,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  ROUNDWSENDE:

  la a0,VALUEFLOATF // A0 = Float Data Offset
  lwc1 f0,0(a0)     // F0 = Float Data
  round.w.s f0 // Convert To Word Data
  la a0,FDWORD  // A0 = FDWORD Offset
  swc1 f0,0(a0) // FDWORD = Word Data
  PrintString($A0100000,144,256,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,256,FontBlack,VALUEFLOATF,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,312,256,FontBlack,TEXTFLOATF,6) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,256,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,256,FontBlack,FDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FDWORD        // A0 = Word Data Offset
  lw t0,0(a0)         // T0 = Word Data
  la a0,ROUNDWSCHECKF // A0 = Word Check Data Offset
  lw t1,0(a0)         // T1 = Word Check Data
  beq t0,t1,ROUNDWSPASSF // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,256,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j ROUNDWSENDF
  nop // Delay Slot
  ROUNDWSPASSF:
  PrintString($A0100000,528,256,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  ROUNDWSENDF:

  la a0,VALUEFLOATG // A0 = Float Data Offset
  lwc1 f0,0(a0)     // F0 = Float Data
  round.w.s f0 // Convert To Word Data
  la a0,FDWORD  // A0 = FDWORD Offset
  swc1 f0,0(a0) // FDWORD = Word Data
  PrintString($A0100000,144,264,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,264,FontBlack,VALUEFLOATG,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,264,FontBlack,TEXTFLOATG,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,264,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,264,FontBlack,FDWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FDWORD        // A0 = Word Data Offset
  lw t0,0(a0)         // T0 = Word Data
  la a0,ROUNDWSCHECKG // A0 = Word Check Data Offset
  lw t1,0(a0)         // T1 = Word Check Data
  beq t0,t1,ROUNDWSPASSG // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,264,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j ROUNDWSENDG
  nop // Delay Slot
  ROUNDWSPASSG:
  PrintString($A0100000,528,264,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  ROUNDWSENDG:


  PrintString($A0100000,0,272,FontBlack,PAGEBREAK,79) // Print Text String To VRAM Using Font At X,Y Position


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

ROUNDLD:
  db "ROUND.L.D"
ROUNDLS:
  db "ROUND.L.S"

ROUNDWD:
  db "ROUND.W.D"
ROUNDWS:
  db "ROUND.W.S"

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
  db "12345678.67891234"
TEXTDOUBLEC:
  db "12345678.5"
TEXTDOUBLED:
  db "12345678.12345678"
TEXTDOUBLEE:
  db "-12345678.12345678"
TEXTDOUBLEF:
  db "-12345678.5"
TEXTDOUBLEG:
  db "-12345678.67891234"

TEXTFLOATA:
  db "0.0"
TEXTFLOATB:
  db "1234.6789"
TEXTFLOATC:
  db "1234.5"
TEXTFLOATD:
  db "1234.1234"
TEXTFLOATE:
  db "-1234.1234"
TEXTFLOATF:
  db "-1234.5"
TEXTFLOATG:
  db "-1234.6789"

PAGEBREAK:
  db "--------------------------------------------------------------------------------"

align(8) // Align 64-Bit
VALUEDOUBLEA:
  float64 0.0
VALUEDOUBLEB:
  float64 12345678.67891234
VALUEDOUBLEC:
  float64 12345678.5
VALUEDOUBLED:
  float64 12345678.12345678
VALUEDOUBLEE:
  float64 -12345678.12345678
VALUEDOUBLEF:
  float64 -12345678.5
VALUEDOUBLEG:
  float64 -12345678.67891234

ROUNDLDCHECKA:
  dq $0000000000000000
ROUNDLDCHECKB:
  dq $0000000000BC614F
ROUNDLDCHECKC:
  dq $0000000000BC614E
ROUNDLDCHECKD:
  dq $0000000000BC614E
ROUNDLDCHECKE:
  dq $FFFFFFFFFF439EB2
ROUNDLDCHECKF:
  dq $FFFFFFFFFF439EB2
ROUNDLDCHECKG:
  dq $FFFFFFFFFF439EB1

ROUNDLSCHECKA:
  dq $0000000000000000
ROUNDLSCHECKB:
  dq $00000000000004D3
ROUNDLSCHECKC:
  dq $00000000000004D2
ROUNDLSCHECKD:
  dq $00000000000004D2
ROUNDLSCHECKE:
  dq $FFFFFFFFFFFFFB2E
ROUNDLSCHECKF:
  dq $FFFFFFFFFFFFFB2E
ROUNDLSCHECKG:
  dq $FFFFFFFFFFFFFB2D

FDLONG:
  dq 0

VALUEFLOATA:
  float32 0.0
VALUEFLOATB:
  float32 1234.6789
VALUEFLOATC:
  float32 1234.5
VALUEFLOATD:
  float32 1234.1234
VALUEFLOATE:
  float32 -1234.1234
VALUEFLOATF:
  float32 -1234.5
VALUEFLOATG:
  float32 -1234.6789

ROUNDWDCHECKA:
  dd $00000000
ROUNDWDCHECKB:
  dd $00BC614F
ROUNDWDCHECKC:
  dd $00BC614E
ROUNDWDCHECKD:
  dd $00BC614E
ROUNDWDCHECKE:
  dd $FF439EB2
ROUNDWDCHECKF:
  dd $FF439EB2
ROUNDWDCHECKG:
  dd $FF439EB1

ROUNDWSCHECKA:
  dd $00000000
ROUNDWSCHECKB:
  dd $000004D3
ROUNDWSCHECKC:
  dd $000004D2
ROUNDWSCHECKD:
  dd $000004D2
ROUNDWSCHECKE:
  dd $FFFFFB2E
ROUNDWSCHECKF:
  dd $FFFFFB2E
ROUNDWSCHECKG:
  dd $FFFFFB2D

FDWORD:
  dd 0

insert FontBlack, "FontBlack8x8.bin"
insert FontGreen, "FontGreen8x8.bin"
insert FontRed, "FontRed8x8.bin"