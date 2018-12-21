// N64 'Bare Metal' CPU Store Byte Test Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "CPUSB.N64", create
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


  PrintString($A0100000,88,8,FontRed,RTHEX,7) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,8,FontRed,RTDEC,11) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,384,8,FontRed,WORDHEX,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,528,8,FontRed,TEST,10) // Print Text String To VRAM Using Font At X,Y Position


  PrintString($A0100000,0,16,FontBlack,PAGEBREAK,79) // Print Text String To VRAM Using Font At X,Y Position


  PrintString($A0100000,8,24,FontRed,SB,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,VALUEBYTEA // A0 = Byte Data Offset
  lb t0,0(a0) // T0 = Test Byte Data
  la a0,WORD  // A0 = WORD Offset
  sb t0,0(a0) // WORD = Word Data
  PrintString($A0100000,80,24,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,24,FontBlack,VALUEBYTEA,0) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,24,FontBlack,TEXTBYTEA,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,24,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,24,FontBlack,WORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,WORD     // A0 = Word Data Offset
  lw t0,0(a0)    // T0 = Word Data
  la a0,SBCHECKA // A0 = Word Check Data Offset
  lw t1,0(a0)    // T1 = Word Check Data
  beq t0,t1,SBPASSA // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,24,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SBENDA
  nop // Delay Slot
  SBPASSA:
  PrintString($A0100000,528,24,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SBENDA:

  la a0,VALUEBYTEB // A0 = Byte Data Offset
  lb t0,0(a0) // T0 = Test Byte Data
  la a0,WORD  // A0 = WORD Offset
  sb t0,0(a0) // WORD = Word Data
  PrintString($A0100000,80,32,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,32,FontBlack,VALUEBYTEB,0) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,32,FontBlack,TEXTBYTEB,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,32,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,32,FontBlack,WORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,WORD     // A0 = Word Data Offset
  lw t0,0(a0)    // T0 = Word Data
  la a0,SBCHECKB // A0 = Word Check Data Offset
  lw t1,0(a0)    // T1 = Word Check Data
  beq t0,t1,SBPASSB // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,32,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SBENDB
  nop // Delay Slot
  SBPASSB:
  PrintString($A0100000,528,32,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SBENDB:

  la a0,VALUEBYTEC // A0 = Byte Data Offset
  lb t0,0(a0) // T0 = Test Byte Data
  la a0,WORD  // A0 = WORD Offset
  sb t0,0(a0) // WORD = Word Data
  PrintString($A0100000,80,40,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,40,FontBlack,VALUEBYTEC,0) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,40,FontBlack,TEXTBYTEC,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,40,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,40,FontBlack,WORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,WORD     // A0 = Word Data Offset
  lw t0,0(a0)    // T0 = Word Data
  la a0,SBCHECKC // A0 = Word Check Data Offset
  lw t1,0(a0)    // T1 = Word Check Data
  beq t0,t1,SBPASSC // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,40,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SBENDC
  nop // Delay Slot
  SBPASSC:
  PrintString($A0100000,528,40,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SBENDC:

  la a0,VALUEBYTED // A0 = Byte Data Offset
  lb t0,0(a0) // T0 = Test Byte Data
  la a0,WORD  // A0 = WORD Offset
  sb t0,0(a0) // WORD = Word Data
  PrintString($A0100000,80,48,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,48,FontBlack,VALUEBYTED,0) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,344,48,FontBlack,TEXTBYTED,2) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,48,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,48,FontBlack,WORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,WORD     // A0 = Word Data Offset
  lw t0,0(a0)    // T0 = Word Data
  la a0,SBCHECKD // A0 = Word Check Data Offset
  lw t1,0(a0)    // T1 = Word Check Data
  beq t0,t1,SBPASSD // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,48,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SBENDD
  nop // Delay Slot
  SBPASSD:
  PrintString($A0100000,528,48,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SBENDD:

  la a0,VALUEBYTEE // A0 = Byte Data Offset
  lb t0,0(a0) // T0 = Test Byte Data
  la a0,WORD  // A0 = WORD Offset
  sb t0,0(a0) // WORD = Word Data
  PrintString($A0100000,80,56,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,56,FontBlack,VALUEBYTEE,0) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,56,FontBlack,TEXTBYTEE,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,56,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,56,FontBlack,WORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,WORD     // A0 = Word Data Offset
  lw t0,0(a0)    // T0 = Word Data
  la a0,SBCHECKE // A0 = Word Check Data Offset
  lw t1,0(a0)    // T1 = Word Check Data
  beq t0,t1,SBPASSE // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,56,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SBENDE
  nop // Delay Slot
  SBPASSE:
  PrintString($A0100000,528,56,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SBENDE:

  la a0,VALUEBYTEF // A0 = Byte Data Offset
  lb t0,0(a0) // T0 = Test Byte Data
  la a0,WORD  // A0 = WORD Offset
  sb t0,0(a0) // WORD = Word Data
  PrintString($A0100000,80,64,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,64,FontBlack,VALUEBYTEF,0) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,344,64,FontBlack,TEXTBYTEF,2) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,64,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,64,FontBlack,WORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,WORD     // A0 = Word Data Offset
  lw t0,0(a0)    // T0 = Word Data
  la a0,SBCHECKF // A0 = Word Check Data Offset
  lw t1,0(a0)    // T1 = Word Check Data
  beq t0,t1,SBPASSF // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,64,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SBENDF
  nop // Delay Slot
  SBPASSF:
  PrintString($A0100000,528,64,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SBENDF:

  la a0,VALUEBYTEG // A0 = Byte Data Offset
  lb t0,0(a0) // T0 = Test Byte Data
  la a0,WORD  // A0 = WORD Offset
  sb t0,0(a0) // WORD = Word Data
  PrintString($A0100000,80,72,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,72,FontBlack,VALUEBYTEG,0) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,336,72,FontBlack,TEXTBYTEG,3) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,72,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,72,FontBlack,WORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,WORD     // A0 = Word Data Offset
  lw t0,0(a0)    // T0 = Word Data
  la a0,SBCHECKG // A0 = Word Check Data Offset
  lw t1,0(a0)    // T1 = Word Check Data
  beq t0,t1,SBPASSG // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,72,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SBENDG
  nop // Delay Slot
  SBPASSG:
  PrintString($A0100000,528,72,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SBENDG:

  la t0,$DEADBEEF
  la a0,WORD
  sw t0,0(a0)
  la a0,VALUEBYTEH
  lb t0,0(a0)
  la a0,WORD
  sb t0,0(a0)
  PrintString($A0100000,80,80,FontBlack,DOLLAR,0)
  PrintValue($A0100000,88,80,FontBlack,VALUEBYTEH,0)
  PrintString($A0100000,352,80,FontBlack,TEXTBYTEH,1)
  PrintString($A0100000,440,80,FontBlack,DOLLAR,0)
  PrintValue($A0100000,448,80,FontBlack,WORD,3)
  la a0,WORD
  lw t0,0(a0)
  la a0,SBCHECKH
  lw t1,0(a0)
  beq t0,t1,SBPASSH
  nop
  PrintString($A0100000,528,80,FontRed,FAIL,3)
  j SBENDH
  nop
  SBPASSH:
  PrintString($A0100000,528,80,FontGreen,PASS,3)
  SBENDH:

  la a0,VALUEBYTEI
  lb t0,0(a0)
  la a0,WORD
  sb t0,1(a0)
  PrintString($A0100000,80,88,FontBlack,DOLLAR,0)
  PrintValue($A0100000,88,88,FontBlack,VALUEBYTEI,0)
  PrintString($A0100000,352,88,FontBlack,TEXTBYTEI,1)
  PrintString($A0100000,440,88,FontBlack,DOLLAR,0)
  PrintValue($A0100000,448,88,FontBlack,WORD,3)
  la a0,WORD
  lw t0,0(a0)
  la a0,SBCHECKI
  lw t1,0(a0)
  beq t0,t1,SBPASSI
  nop
  PrintString($A0100000,528,88,FontRed,FAIL,3)
  j SBENDI
  nop
  SBPASSI:
  PrintString($A0100000,528,88,FontGreen,PASS,3)
  SBENDI:

  la a0,VALUEBYTEJ
  lb t0,0(a0)
  la a0,WORD
  sb t0,2(a0)
  PrintString($A0100000,80,96,FontBlack,DOLLAR,0)
  PrintValue($A0100000,88,96,FontBlack,VALUEBYTEJ,0)
  PrintString($A0100000,352,96,FontBlack,TEXTBYTEJ,1)
  PrintString($A0100000,440,96,FontBlack,DOLLAR,0)
  PrintValue($A0100000,448,96,FontBlack,WORD,3)
  la a0,WORD
  lw t0,0(a0)
  la a0,SBCHECKJ
  lw t1,0(a0)
  beq t0,t1,SBPASSJ
  nop
  PrintString($A0100000,528,96,FontRed,FAIL,3)
  j SBENDJ
  nop
  SBPASSJ:
  PrintString($A0100000,528,96,FontGreen,PASS,3)
  SBENDJ:

  la a0,VALUEBYTEK
  lb t0,0(a0)
  la a0,WORD
  sb t0,3(a0)
  PrintString($A0100000,80,104,FontBlack,DOLLAR,0)
  PrintValue($A0100000,88,104,FontBlack,VALUEBYTEK,0)
  PrintString($A0100000,344,104,FontBlack,TEXTBYTEK,2)
  PrintString($A0100000,440,104,FontBlack,DOLLAR,0)
  PrintValue($A0100000,448,104,FontBlack,WORD,3)
  la a0,WORD
  lw t0,0(a0)
  la a0,SBCHECKK
  lw t1,0(a0)
  beq t0,t1,SBPASSK
  nop
  PrintString($A0100000,528,104,FontRed,FAIL,3)
  j SBENDK
  nop
  SBPASSK:
  PrintString($A0100000,528,104,FontGreen,PASS,3)
  SBENDK:

  PrintString($A0100000,0,112,FontBlack,PAGEBREAK,79) // Print Text String To VRAM Using Font At X,Y Position


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

SB:
  db "SB"

WORDHEX:
  db "WORD (Hex)"
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

TEXTBYTEA:
  db "0"
TEXTBYTEB:
  db "1"
TEXTBYTEC:
  db "12"
TEXTBYTED:
  db "123"
TEXTBYTEE:
  db "-1"
TEXTBYTEF:
  db "-12"
TEXTBYTEG:
  db "-123"
TEXTBYTEH:
  db "18"
TEXTBYTEI:
  db "52"
TEXTBYTEJ:
  db "86"
TEXTBYTEK:
  db "120"

PAGEBREAK:
  db "--------------------------------------------------------------------------------"

VALUEBYTEA:
  db 0
VALUEBYTEB:
  db 1
VALUEBYTEC:
  db 12
VALUEBYTED:
  db 123
VALUEBYTEE:
  db -1
VALUEBYTEF:
  db -12
VALUEBYTEG:
  db -123
VALUEBYTEH:
  db $12
VALUEBYTEI:
  db $34
VALUEBYTEJ:
  db $56
VALUEBYTEK:
  db $78

align(4) // Align 32-Bit
SBCHECKA:
  dw $00000000
SBCHECKB:
  dw $01000000
SBCHECKC:
  dw $0C000000
SBCHECKD:
  dw $7B000000
SBCHECKE:
  dw $FF000000
SBCHECKF:
  dw $F4000000
SBCHECKG:
  dw $85000000
SBCHECKH:
  dw $12ADBEEF
SBCHECKI:
  dw $1234BEEF
SBCHECKJ:
  dw $123456EF
SBCHECKK:
  dw $12345678

WORD:
  dw 0

insert FontBlack, "FontBlack8x8.bin"
insert FontGreen, "FontGreen8x8.bin"
insert FontRed, "FontRed8x8.bin"
