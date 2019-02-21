arch n64.cpu
endian msb
output "RCPVersion.N64", create
fill 1052672 // Set ROM Size

// Setup Frame Buffer
constant SCREEN_X(320)
constant SCREEN_Y(240)
constant BYTES_PER_PIXEL(4)
constant VRAM($A0100000)

// Setup Characters
constant CHAR_X(8)
constant CHAR_Y(8)

constant RCP_V1($01010101)
constant RCP_V2($02020102)

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

  ScreenNTSC(SCREEN_X, SCREEN_Y, BPP32|AA_MODE_2, VRAM) // Screen NTSC: 320x240, 32BPP, Resample Only, DRAM Origin = $A0100000

  lui a0,$A010 // A0 = VRAM Start Offset
  la a1,VRAM+((SCREEN_X*SCREEN_Y*BYTES_PER_PIXEL)-BYTES_PER_PIXEL) // A1 = VRAM End Offset
  lli t0,$000000FF // T0 = Black
ClearScreen:
  sw t0,0(a0)
  bne a0,a1,ClearScreen
  addi a0,4 // Delay Slot

  PrintString(VRAM, 8, 8, FontRed, RCP_VERSION_TEST_TEXT, 16)
  PrintString(VRAM, 152, 8, FontBlack, ADDRESS_TEXT, 7)
  PrintString(VRAM, 224, 8, FontGreen, RESULT_TEXT, 6)

  PrintString(VRAM, 0, 16, FontBlack, PAGE_BREAK, 39)

  lui t0, MI_BASE
  ori t0, t0, MI_VERSION
  lw s0, 0(t0)
  la s1, PRINT_VALUE
  sw t0, 0(s1)

  PrintString(VRAM, 8, 24, FontRed, MI_VERSION_TEXT, 9)
  PrintString(VRAM, 144, 24, FontBlack, DOLLAR, 0)
  PrintValue(VRAM, 152, 24, FontBlack, PRINT_VALUE, 3)

  sw s0, 0(s1)

  PrintString(VRAM, 224, 24, FontGreen, DOLLAR, 0)
  PrintValue(VRAM, 232, 24, FontGreen, PRINT_VALUE, 3)

  PrintString(VRAM, 24, 36, FontRed, MI_IO_TEXT, 1)
  PrintString(VRAM, 224, 36, FontGreen, DOLLAR, 0)
  PrintValue(VRAM, 232, 36, FontGreen, PRINT_VALUE + 3, 0)

  PrintString(VRAM, 24, 48, FontRed, MI_RAC_TEXT, 2)
  PrintString(VRAM, 224, 48, FontGreen, DOLLAR, 0)
  PrintValue(VRAM, 232, 48, FontGreen, PRINT_VALUE + 2, 0)

  PrintString(VRAM, 24, 60, FontRed, MI_RDP_TEXT, 2)
  PrintString(VRAM, 224, 60, FontGreen, DOLLAR, 0)
  PrintValue(VRAM, 232, 60, FontGreen, PRINT_VALUE + 1, 0)

  PrintString(VRAM, 24, 72, FontRed, MI_RSP_TEXT, 2)
  PrintString(VRAM, 224, 72, FontGreen, DOLLAR, 0)
  PrintValue(VRAM, 232, 72, FontGreen, PRINT_VALUE, 0)

  PrintString(VRAM, 0, 84, FontBlack, PAGE_BREAK, 39)

  la t0, RCP_V2
  beq s0, t0, IsRCP_V2
  nop
  la t0, RCP_V1
  beq s0, t0, IsRCP_V1
  nop
  PrintString(VRAM, 8, 96, FontRed, UNKNOWN_RCP_TEXT, 15)
  j Loop
  nop
IsRCP_V2:
  PrintString(VRAM, 8, 96, FontGreen, RCP_V2_TEXT, 14)
  j Loop
  nop
IsRCP_V1:
  PrintString(VRAM, 8, 96, FontGreen, RCP_V1_TEXT, 14)
  j Loop
  nop

Loop:
  j Loop
  nop // Delay Slot

RCP_VERSION_TEST_TEXT:
  db "RCP Version Test:"

ADDRESS_TEXT:
  db "Address:"

RESULT_TEXT:
  db "Result:"

MI_VERSION_TEXT:
  db "MI_VERSION"

MI_IO_TEXT:
  db "IO"

MI_RAC_TEXT:
  db "RAC"

MI_RDP_TEXT:
  db "RDP"

MI_RSP_TEXT:
  db "RSP"

RCP_V2_TEXT:
  db "RCP Version 2.0"

RCP_V1_TEXT:
  db "RCP Version 1.0"

UNKNOWN_RCP_TEXT:
  db "Unknown RCP chip"

DOLLAR:
  db "$"

PAGE_BREAK:
  db "--------------------------------------------------------------------------------"

align(8)

PRINT_VALUE:
  dw 0

insert FontBlack, "FontBlack8x8.bin"
insert FontGreen, "FontGreen8x8.bin"
insert FontRed, "FontRed8x8.bin"
