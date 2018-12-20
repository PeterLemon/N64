// N64 'Bare Metal' CPU Store Halfword Test Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "CPUSH.N64", create
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


  PrintString($A0100000,8,24,FontRed,SH,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,VALUEHALFA // A0 = Halfword Data Offset
  lh t0,0(a0) // T0 = Test Halfword Data
  la a0,WORD  // A0 = WORD Offset
  sh t0,0(a0) // WORD = Word Data
  PrintString($A0100000,80,24,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,24,FontBlack,VALUEHALFA,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,24,FontBlack,TEXTHALFA,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,24,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,24,FontBlack,WORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,WORD     // A0 = Word Data Offset
  lw t0,0(a0)    // T0 = Word Data
  la a0,SHCHECKA // A0 = Word Check Data Offset
  lw t1,0(a0)    // T1 = Word Check Data
  beq t0,t1,SHPASSA // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,24,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SHENDA
  nop // Delay Slot
  SHPASSA:
  PrintString($A0100000,528,24,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SHENDA:

  la a0,VALUEHALFB // A0 = Halfword Data Offset
  lh t0,0(a0) // T0 = Test Halfword Data
  la a0,WORD  // A0 = WORD Offset
  sh t0,0(a0) // WORD = Word Data
  PrintString($A0100000,80,32,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,32,FontBlack,VALUEHALFB,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,328,32,FontBlack,TEXTHALFB,4) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,32,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,32,FontBlack,WORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,WORD     // A0 = Word Data Offset
  lw t0,0(a0)    // T0 = Word Data
  la a0,SHCHECKB // A0 = Word Check Data Offset
  lw t1,0(a0)    // T1 = Word Check Data
  beq t0,t1,SHPASSB // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,32,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SHENDB
  nop // Delay Slot
  SHPASSB:
  PrintString($A0100000,528,32,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SHENDB:

  la a0,VALUEHALFC // A0 = Halfword Data Offset
  lh t0,0(a0) // T0 = Test Halfword Data
  la a0,WORD  // A0 = WORD Offset
  sh t0,0(a0) // WORD = Word Data
  PrintString($A0100000,80,40,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,40,FontBlack,VALUEHALFC,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,336,40,FontBlack,TEXTHALFC,3) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,40,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,40,FontBlack,WORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,WORD     // A0 = Word Data Offset
  lw t0,0(a0)    // T0 = Word Data
  la a0,SHCHECKC // A0 = Word Check Data Offset
  lw t1,0(a0)    // T1 = Word Check Data
  beq t0,t1,SHPASSC // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,40,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SHENDC
  nop // Delay Slot
  SHPASSC:
  PrintString($A0100000,528,40,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SHENDC:

  la a0,VALUEHALFD // A0 = Halfword Data Offset
  lh t0,0(a0) // T0 = Test Halfword Data
  la a0,WORD  // A0 = WORD Offset
  sh t0,0(a0) // WORD = Word Data
  PrintString($A0100000,80,48,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,48,FontBlack,VALUEHALFD,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,328,48,FontBlack,TEXTHALFD,4) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,48,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,48,FontBlack,WORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,WORD     // A0 = Word Data Offset
  lw t0,0(a0)    // T0 = Word Data
  la a0,SHCHECKD // A0 = Word Check Data Offset
  lw t1,0(a0)    // T1 = Word Check Data
  beq t0,t1,SHPASSD // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,48,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SHENDD
  nop // Delay Slot
  SHPASSD:
  PrintString($A0100000,528,48,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SHENDD:

  la a0,VALUEHALFE // A0 = Halfword Data Offset
  lh t0,0(a0) // T0 = Test Halfword Data
  la a0,WORD  // A0 = WORD Offset
  sh t0,0(a0) // WORD = Word Data
  PrintString($A0100000,80,56,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,56,FontBlack,VALUEHALFE,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,320,56,FontBlack,TEXTHALFE,5) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,56,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,56,FontBlack,WORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,WORD     // A0 = Word Data Offset
  lw t0,0(a0)    // T0 = Word Data
  la a0,SHCHECKE // A0 = Word Check Data Offset
  lw t1,0(a0)    // T1 = Word Check Data
  beq t0,t1,SHPASSE // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,56,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SHENDE
  nop // Delay Slot
  SHPASSE:
  PrintString($A0100000,528,56,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SHENDE:

  la a0,VALUEHALFF // A0 = Halfword Data Offset
  lh t0,0(a0) // T0 = Test Halfword Data
  la a0,WORD  // A0 = WORD Offset
  sh t0,0(a0) // WORD = Word Data
  PrintString($A0100000,80,64,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,64,FontBlack,VALUEHALFF,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,328,64,FontBlack,TEXTHALFF,4) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,64,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,64,FontBlack,WORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,WORD     // A0 = Word Data Offset
  lw t0,0(a0)    // T0 = Word Data
  la a0,SHCHECKF // A0 = Word Check Data Offset
  lw t1,0(a0)    // T1 = Word Check Data
  beq t0,t1,SHPASSF // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,64,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SHENDF
  nop // Delay Slot
  SHPASSF:
  PrintString($A0100000,528,64,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SHENDF:

  la a0,VALUEHALFG // A0 = Halfword Data Offset
  lh t0,0(a0) // T0 = Test Halfword Data
  la a0,WORD  // A0 = WORD Offset
  sh t0,0(a0) // WORD = Word Data
  PrintString($A0100000,80,72,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,72,FontBlack,VALUEHALFG,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,320,72,FontBlack,TEXTHALFG,5) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,72,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,72,FontBlack,WORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,WORD     // A0 = Word Data Offset
  lw t0,0(a0)    // T0 = Word Data
  la a0,SHCHECKG // A0 = Word Check Data Offset
  lw t1,0(a0)    // T1 = Word Check Data
  beq t0,t1,SHPASSG // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,72,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SHENDG
  nop // Delay Slot
  SHPASSG:
  PrintString($A0100000,528,72,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SHENDG:

  la t0,$DEADBEEF
  la a0,WORD
  sw t0,0(a0)
  la t0,VALUEHALFH
  lh t0,0(t0)
  sh t0,0(a0)
  PrintString($A0100000,80,80,FontBlack,DOLLAR,0)
  PrintValue($A0100000,88,80,FontBlack,VALUEHALFH,1)
  PrintString($A0100000,336,80,FontBlack,TEXTHALFH,3)
  PrintString($A0100000,440,80,FontBlack,DOLLAR,0)
  PrintValue($A0100000,448,80,FontBlack,WORD,3)
  la t0,WORD
  lw t0,0(t0)
  la t1,SHCHECKH
  lw t1,0(t1)
  beq t0,t1,SHPASSH
  nop
  PrintString($A0100000,528,80,FontRed,FAIL,3)
  j SHENDH
  nop
  SHPASSH:
  PrintString($A0100000,528,80,FontGreen,PASS,3)
  SHENDH:

  la t0,VALUEHALFI
  lh t0,0(t0)
  la a0,WORD
  sh t0,2(a0)
  PrintString($A0100000,80,88,FontBlack,DOLLAR,0)
  PrintValue($A0100000,88,88,FontBlack,VALUEHALFI,1)
  PrintString($A0100000,328,88,FontBlack,TEXTHALFI,4)
  PrintString($A0100000,440,88,FontBlack,DOLLAR,0)
  PrintValue($A0100000,448,88,FontBlack,WORD,3)
  la t0,WORD
  lw t0,0(t0)
  la t1,SHCHECKI
  lw t1,0(t1)
  beq t0,t1,SHPASSI
  nop
  PrintString($A0100000,528,88,FontRed,FAIL,3)
  j SHENDI
  nop
  SHPASSI:
  PrintString($A0100000,528,88,FontGreen,PASS,3)
  SHENDI:

  PrintString($A0100000,0,96,FontBlack,PAGEBREAK,79) // Print Text String To VRAM Using Font At X,Y Position


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

SH:
  db "SH"

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

TEXTHALFA:
  db "0"
TEXTHALFB:
  db "12345"
TEXTHALFC:
  db "1234"
TEXTHALFD:
  db "12341"
TEXTHALFE:
  db "-12341"
TEXTHALFF:
  db "-1234"
TEXTHALFG:
  db "-12345"
TEXTHALFH:
  db "4660"
TEXTHALFI:
  db "22136"

PAGEBREAK:
  db "--------------------------------------------------------------------------------"

align(2) // Align 16-Bit
VALUEHALFA:
  dh 0
VALUEHALFB:
  dh 12345
VALUEHALFC:
  dh 1234
VALUEHALFD:
  dh 12341
VALUEHALFE:
  dh -12341
VALUEHALFF:
  dh -1234
VALUEHALFG:
  dh -12345
VALUEHALFH:
  dh $1234
VALUEHALFI:
  dh $5678

align(4) // Align 32-Bit
SHCHECKA:
  dw $00000000
SHCHECKB:
  dw $30390000
SHCHECKC:
  dw $04D20000
SHCHECKD:
  dw $30350000
SHCHECKE:
  dw $CFCB0000
SHCHECKF:
  dw $FB2E0000
SHCHECKG:
  dw $CFC70000
SHCHECKH:
  dw $1234BEEF
SHCHECKI:
  dw $12345678

WORD:
  dw 0

insert FontBlack, "FontBlack8x8.bin"
insert FontGreen, "FontGreen8x8.bin"
insert FontRed, "FontRed8x8.bin"
