// N64 'Bare Metal' CPU CP1/FPU Comparison Signaling Equal Test Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "CP1CSEQ.N64", create
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


  PrintString($A0100000,88,8,FontRed,FSFTHEX,10) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,8,FontRed,FSFTDEC,14) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,528,8,FontRed,TEST,10) // Print Text String To VRAM Using Font At X,Y Position


  PrintString($A0100000,0,16,FontBlack,PAGEBREAK,79) // Print Text String To VRAM Using Font At X,Y Position


  PrintString($A0100000,8,24,FontRed,CSEQD,6) // Print Text String To VRAM Using Font At X,Y Position
  la a0,VALUEDOUBLEA // A0 = Double Data Offset
  ldc1 f0,0(a0)      // F0 = Double Data
  la a0,VALUEDOUBLEB // A0 = Double Data Offset
  ldc1 f1,0(a0)      // F1 = Double Data
  c.seq.d f0,f1 // Comparison Test
  PrintString($A0100000,80,24,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,24,FontBlack,VALUEDOUBLEA,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,344,24,FontBlack,TEXTDOUBLEA,2) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,80,32,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,32,FontBlack,VALUEDOUBLEB,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,32,FontBlack,TEXTDOUBLEB,16) // Print Text String To VRAM Using Font At X,Y Position
  bc1f CSEQDPASSA // Branch On FP False
  nop // Delay Slot
  PrintString($A0100000,528,32,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CSEQDENDA
  nop // Delay Slot
  CSEQDPASSA:
  PrintString($A0100000,528,32,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CSEQDENDA:

  la a0,VALUEDOUBLEB // A0 = Double Data Offset
  ldc1 f0,0(a0)      // F0 = Double Data
  la a0,VALUEDOUBLEC // A0 = Double Data Offset
  ldc1 f1,0(a0)      // F1 = Double Data
  c.seq.d f0,f1 // Comparison Test
  PrintString($A0100000,80,48,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,48,FontBlack,VALUEDOUBLEB,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,48,FontBlack,TEXTDOUBLEB,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,80,56,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,56,FontBlack,VALUEDOUBLEC,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,56,FontBlack,TEXTDOUBLEC,9) // Print Text String To VRAM Using Font At X,Y Position
  bc1f CSEQDPASSB // Branch On FP False
  nop // Delay Slot
  PrintString($A0100000,528,56,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CSEQDENDB
  nop // Delay Slot
  CSEQDPASSB:
  PrintString($A0100000,528,56,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CSEQDENDB:

  la a0,VALUEDOUBLEC // A0 = Double Data Offset
  ldc1 f0,0(a0)      // F0 = Double Data
  la a0,VALUEDOUBLED // A0 = Double Data Offset
  ldc1 f1,0(a0)      // F1 = Double Data
  c.seq.d f0,f1 // Comparison Test
  PrintString($A0100000,80,72,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,72,FontBlack,VALUEDOUBLEC,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,72,FontBlack,TEXTDOUBLEC,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,80,80,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,80,FontBlack,VALUEDOUBLED,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,80,FontBlack,TEXTDOUBLED,16) // Print Text String To VRAM Using Font At X,Y Position
  bc1f CSEQDPASSC // Branch On FP False
  nop // Delay Slot
  PrintString($A0100000,528,80,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CSEQDENDC
  nop // Delay Slot
  CSEQDPASSC:
  PrintString($A0100000,528,80,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CSEQDENDC:

  la a0,VALUEDOUBLED // A0 = Double Data Offset
  ldc1 f0,0(a0)      // F0 = Double Data
  la a0,VALUEDOUBLEE // A0 = Double Data Offset
  ldc1 f1,0(a0)      // F1 = Double Data
  c.seq.d f0,f1 // Comparison Test
  PrintString($A0100000,80,96,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,96,FontBlack,VALUEDOUBLED,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,96,FontBlack,TEXTDOUBLED,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,80,104,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,104,FontBlack,VALUEDOUBLEE,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,224,104,FontBlack,TEXTDOUBLEE,17) // Print Text String To VRAM Using Font At X,Y Position
  bc1f CSEQDPASSD // Branch On FP False
  nop // Delay Slot
  PrintString($A0100000,528,104,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CSEQDENDD
  nop // Delay Slot
  CSEQDPASSD:
  PrintString($A0100000,528,104,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CSEQDENDD:

  la a0,VALUEDOUBLEE // A0 = Double Data Offset
  ldc1 f0,0(a0)      // F0 = Double Data
  la a0,VALUEDOUBLEF // A0 = Double Data Offset
  ldc1 f1,0(a0)      // F1 = Double Data
  c.seq.d f0,f1 // Comparison Test
  PrintString($A0100000,80,120,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,120,FontBlack,VALUEDOUBLEE,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,224,120,FontBlack,TEXTDOUBLEE,17) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,80,128,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,128,FontBlack,VALUEDOUBLEF,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,280,128,FontBlack,TEXTDOUBLEF,10) // Print Text String To VRAM Using Font At X,Y Position
  bc1f CSEQDPASSE // Branch On FP False
  nop // Delay Slot
  PrintString($A0100000,528,128,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CSEQDENDE
  nop // Delay Slot
  CSEQDPASSE:
  PrintString($A0100000,528,128,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CSEQDENDE:

  la a0,VALUEDOUBLEF // A0 = Double Data Offset
  ldc1 f0,0(a0)      // F0 = Double Data
  la a0,VALUEDOUBLEG // A0 = Double Data Offset
  ldc1 f1,0(a0)      // F1 = Double Data
  c.seq.d f0,f1 // Comparison Test
  PrintString($A0100000,80,144,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,144,FontBlack,VALUEDOUBLEF,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,280,144,FontBlack,TEXTDOUBLEF,10) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,80,152,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,152,FontBlack,VALUEDOUBLEG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,224,152,FontBlack,TEXTDOUBLEG,17) // Print Text String To VRAM Using Font At X,Y Position
  bc1f CSEQDPASSF // Branch On FP False
  nop // Delay Slot
  PrintString($A0100000,528,152,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CSEQDENDF
  nop // Delay Slot
  CSEQDPASSF:
  PrintString($A0100000,528,152,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CSEQDENDF:

  la a0,VALUEDOUBLEA // A0 = Double Data Offset
  ldc1 f0,0(a0)      // F0 = Double Data
  la a0,VALUEDOUBLEG // A0 = Double Data Offset
  ldc1 f1,0(a0)      // F1 = Double Data
  c.seq.d f0,f1 // Comparison Test
  PrintString($A0100000,80,168,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,168,FontBlack,VALUEDOUBLEA,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,344,168,FontBlack,TEXTDOUBLEA,2) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,80,176,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,176,FontBlack,VALUEDOUBLEG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,224,176,FontBlack,TEXTDOUBLEG,17) // Print Text String To VRAM Using Font At X,Y Position
  bc1f CSEQDPASSG // Branch On FP False
  nop // Delay Slot
  PrintString($A0100000,528,176,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CSEQDENDG
  nop // Delay Slot
  CSEQDPASSG:
  PrintString($A0100000,528,176,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CSEQDENDG:

  la a0,VALUEDOUBLED // A0 = Double Data Offset
  ldc1 f0,0(a0)      // F0 = Double Data
  la a0,VALUEDOUBLED // A0 = Double Data Offset
  ldc1 f1,0(a0)      // F1 = Double Data
  c.seq.d f0,f1 // Comparison Test
  PrintString($A0100000,80,192,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,192,FontBlack,VALUEDOUBLED,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,192,FontBlack,TEXTDOUBLED,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,80,200,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,200,FontBlack,VALUEDOUBLED,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,200,FontBlack,TEXTDOUBLED,16) // Print Text String To VRAM Using Font At X,Y Position
  bc1t CSEQDPASSH // Branch On FP True
  nop // Delay Slot
  PrintString($A0100000,528,200,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CSEQDENDH
  nop // Delay Slot
  CSEQDPASSH:
  PrintString($A0100000,528,200,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CSEQDENDH:

  la a0,VALUEDOUBLEE // A0 = Double Data Offset
  ldc1 f0,0(a0)      // F0 = Double Data
  la a0,VALUEDOUBLEE // A0 = Double Data Offset
  ldc1 f1,0(a0)      // F1 = Double Data
  c.seq.d f0,f1 // Comparison Test
  PrintString($A0100000,80,216,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,216,FontBlack,VALUEDOUBLEE,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,224,216,FontBlack,TEXTDOUBLEE,17) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,80,224,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,224,FontBlack,VALUEDOUBLEE,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,224,224,FontBlack,TEXTDOUBLEE,17) // Print Text String To VRAM Using Font At X,Y Position
  bc1t CSEQDPASSI // Branch On FP True
  nop // Delay Slot
  PrintString($A0100000,528,224,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CSEQDENDI
  nop // Delay Slot
  CSEQDPASSI:
  PrintString($A0100000,528,224,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CSEQDENDI:


  PrintString($A0100000,8,240,FontRed,CSEQS,6) // Print Text String To VRAM Using Font At X,Y Position
  la a0,VALUEFLOATA // A0 = Float Data Offset
  lwc1 f0,0(a0)     // F0 = Float Data
  la a0,VALUEFLOATB // A0 = Float Data Offset
  lwc1 f1,0(a0)     // F1 = Float Data
  c.seq.s f0,f1 // Comparison Test
  PrintString($A0100000,144,240,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,240,FontBlack,VALUEFLOATA,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,344,240,FontBlack,TEXTFLOATA,2) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,144,248,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,248,FontBlack,VALUEFLOATB,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,296,248,FontBlack,TEXTFLOATB,8) // Print Text String To VRAM Using Font At X,Y Position
  bc1f CSEQSPASSA // Branch On FP False
  nop // Delay Slot
  PrintString($A0100000,528,248,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CSEQSENDA
  nop // Delay Slot
  CSEQSPASSA:
  PrintString($A0100000,528,248,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CSEQSENDA:

  la a0,VALUEFLOATB // A0 = Float Data Offset
  lwc1 f0,0(a0)     // F0 = Float Data
  la a0,VALUEFLOATC // A0 = Float Data Offset
  lwc1 f1,0(a0)     // F1 = Float Data
  c.seq.s f0,f1 // Comparison Test
  PrintString($A0100000,144,264,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,264,FontBlack,VALUEFLOATB,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,296,264,FontBlack,TEXTFLOATB,8) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,144,272,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,272,FontBlack,VALUEFLOATC,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,320,272,FontBlack,TEXTFLOATC,5) // Print Text String To VRAM Using Font At X,Y Position
  bc1f CSEQSPASSB // Branch On FP False
  nop // Delay Slot
  PrintString($A0100000,528,272,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CSEQSENDB
  nop // Delay Slot
  CSEQSPASSB:
  PrintString($A0100000,528,272,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CSEQSENDB:

  la a0,VALUEFLOATC // A0 = Float Data Offset
  lwc1 f0,0(a0)     // F0 = Float Data
  la a0,VALUEFLOATD // A0 = Float Data Offset
  lwc1 f1,0(a0)     // F1 = Float Data
  c.seq.s f0,f1 // Comparison Test
  PrintString($A0100000,144,288,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,288,FontBlack,VALUEFLOATC,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,320,288,FontBlack,TEXTFLOATC,5) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,144,296,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,296,FontBlack,VALUEFLOATD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,296,296,FontBlack,TEXTFLOATD,8) // Print Text String To VRAM Using Font At X,Y Position
  bc1f CSEQSPASSC // Branch On FP False
  nop // Delay Slot
  PrintString($A0100000,528,296,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CSEQSENDC
  nop // Delay Slot
  CSEQSPASSC:
  PrintString($A0100000,528,296,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CSEQSENDC:

  la a0,VALUEFLOATD // A0 = Float Data Offset
  lwc1 f0,0(a0)     // F0 = Float Data
  la a0,VALUEFLOATE // A0 = Float Data Offset
  lwc1 f1,0(a0)     // F1 = Float Data
  c.seq.s f0,f1 // Comparison Test
  PrintString($A0100000,144,312,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,312,FontBlack,VALUEFLOATD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,296,312,FontBlack,TEXTFLOATD,8) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,144,320,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,320,FontBlack,VALUEFLOATE,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,320,FontBlack,TEXTFLOATE,9) // Print Text String To VRAM Using Font At X,Y Position
  bc1f CSEQSPASSD // Branch On FP False
  nop // Delay Slot
  PrintString($A0100000,528,320,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CSEQSENDD
  nop // Delay Slot
  CSEQSPASSD:
  PrintString($A0100000,528,320,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CSEQSENDD:

  la a0,VALUEFLOATE // A0 = Float Data Offset
  lwc1 f0,0(a0)     // F0 = Float Data
  la a0,VALUEFLOATF // A0 = Float Data Offset
  lwc1 f1,0(a0)     // F1 = Float Data
  c.seq.s f0,f1 // Comparison Test
  PrintString($A0100000,144,336,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,336,FontBlack,VALUEFLOATE,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,336,FontBlack,TEXTFLOATE,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,144,344,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,344,FontBlack,VALUEFLOATF,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,312,344,FontBlack,TEXTFLOATF,6) // Print Text String To VRAM Using Font At X,Y Position
  bc1f CSEQSPASSE // Branch On FP False
  nop // Delay Slot
  PrintString($A0100000,528,344,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CSEQSENDE
  nop // Delay Slot
  CSEQSPASSE:
  PrintString($A0100000,528,344,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CSEQSENDE:

  la a0,VALUEFLOATF // A0 = Float Data Offset
  lwc1 f0,0(a0)     // F0 = Float Data
  la a0,VALUEFLOATG // A0 = Float Data Offset
  lwc1 f1,0(a0)     // F1 = Float Data
  c.seq.s f0,f1 // Comparison Test
  PrintString($A0100000,144,360,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,360,FontBlack,VALUEFLOATF,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,312,360,FontBlack,TEXTFLOATF,6) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,144,368,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,368,FontBlack,VALUEFLOATG,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,368,FontBlack,TEXTFLOATG,9) // Print Text String To VRAM Using Font At X,Y Position
  bc1f CSEQSPASSF // Branch On FP False
  nop // Delay Slot
  PrintString($A0100000,528,368,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CSEQSENDF
  nop // Delay Slot
  CSEQSPASSF:
  PrintString($A0100000,528,368,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CSEQSENDF:

  la a0,VALUEFLOATA // A0 = Float Data Offset
  lwc1 f0,0(a0)     // F0 = Float Data
  la a0,VALUEFLOATG // A0 = Float Data Offset
  lwc1 f1,0(a0)     // F1 = Float Data
  c.seq.s f0,f1 // Comparison Test
  PrintString($A0100000,144,384,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,384,FontBlack,VALUEFLOATA,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,344,384,FontBlack,TEXTFLOATA,2) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,144,392,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,392,FontBlack,VALUEFLOATG,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,392,FontBlack,TEXTFLOATG,9) // Print Text String To VRAM Using Font At X,Y Position
  bc1f CSEQSPASSG // Branch On FP False
  nop // Delay Slot
  PrintString($A0100000,528,392,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CSEQSENDG
  nop // Delay Slot
  CSEQSPASSG:
  PrintString($A0100000,528,392,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CSEQSENDG:

  la a0,VALUEFLOATD // A0 = Float Data Offset
  lwc1 f0,0(a0)     // F0 = Float Data
  la a0,VALUEFLOATD // A0 = Float Data Offset
  lwc1 f1,0(a0)     // F1 = Float Data
  c.seq.s f0,f1 // Comparison Test
  PrintString($A0100000,144,408,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,408,FontBlack,VALUEFLOATD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,296,408,FontBlack,TEXTFLOATD,8) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,144,416,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,416,FontBlack,VALUEFLOATD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,296,416,FontBlack,TEXTFLOATD,8) // Print Text String To VRAM Using Font At X,Y Position
  bc1t CSEQSPASSH // Branch On FP True
  nop // Delay Slot
  PrintString($A0100000,528,416,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CSEQSENDH
  nop // Delay Slot
  CSEQSPASSH:
  PrintString($A0100000,528,416,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CSEQSENDH:

  la a0,VALUEFLOATE // A0 = Float Data Offset
  lwc1 f0,0(a0)     // F0 = Float Data
  la a0,VALUEFLOATE // A0 = Float Data Offset
  lwc1 f1,0(a0)     // F1 = Float Data
  c.seq.s f0,f1 // Comparison Test
  PrintString($A0100000,144,432,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,432,FontBlack,VALUEFLOATE,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,432,FontBlack,TEXTFLOATE,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,144,440,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,440,FontBlack,VALUEFLOATE,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,440,FontBlack,TEXTFLOATE,9) // Print Text String To VRAM Using Font At X,Y Position
  bc1t CSEQSPASSI // Branch On FP True
  nop // Delay Slot
  PrintString($A0100000,528,440,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CSEQSENDI
  nop // Delay Slot
  CSEQSPASSI:
  PrintString($A0100000,528,440,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CSEQSENDI:


  PrintString($A0100000,0,448,FontBlack,PAGEBREAK,79) // Print Text String To VRAM Using Font At X,Y Position


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

CSEQD:
  db "C.SEQ.D"
CSEQS:
  db "C.SEQ.S"

FSFTHEX:
  db "FS/FT (Hex)"
FSFTDEC:
  db "FS/FT (Decimal)"
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

insert FontBlack, "FontBlack8x8.bin"
insert FontGreen, "FontGreen8x8.bin"
insert FontRed, "FontRed8x8.bin"