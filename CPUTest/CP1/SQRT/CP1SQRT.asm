// N64 'Bare Metal' CPU CP1/FPU Square Root Test Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "CP1SQRT.N64", create
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


  PrintString($A0100000,88,8,FontRed,FSHEX,7) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,8,FontRed,FSDEC,11) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,384,8,FontRed,SQRTFSHEX,13) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,528,8,FontRed,TEST,10) // Print Text String To VRAM Using Font At X,Y Position


  PrintString($A0100000,0,16,FontBlack,PAGEBREAK,79) // Print Text String To VRAM Using Font At X,Y Position


  PrintString($A0100000,8,24,FontRed,SQRTD,5) // Print Text String To VRAM Using Font At X,Y Position
  la a0,VALUEDOUBLEA // A0 = Double Data Offset
  ldc1 f0,0(a0)      // F0 = Double Data
  sqrt.d f0 // Convert To Long Data
  la a0,FSLONG  // A0 = FSLONG Offset
  sdc1 f0,0(a0) // FSLONG = Long Data
  PrintString($A0100000,80,24,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,24,FontBlack,VALUEDOUBLEA,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,344,24,FontBlack,TEXTDOUBLEA,2) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,24,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,24,FontBlack,FSLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FSLONG      // A0 = Long Data Offset
  ld t0,0(a0)       // T0 = Long Data
  la a0,SQRTDCHECKA // A0 = Long Check Data Offset
  ld t1,0(a0)       // T1 = Long Check Data
  beq t0,t1,SQRTDPASSA // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,24,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SQRTDENDA
  nop // Delay Slot
  SQRTDPASSA:
  PrintString($A0100000,528,24,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SQRTDENDA:

  la a0,VALUEDOUBLEB // A0 = Double Data Offset
  ldc1 f0,0(a0)      // F0 = Double Data
  sqrt.d f0 // Convert To Long Data
  la a0,FSLONG  // A0 = FSLONG Offset
  sdc1 f0,0(a0) // FSLONG = Long Data
  PrintString($A0100000,80,32,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,32,FontBlack,VALUEDOUBLEB,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,32,FontBlack,TEXTDOUBLEB,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,32,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,32,FontBlack,FSLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FSLONG      // A0 = Long Data Offset
  ld t0,0(a0)       // T0 = Long Data
  la a0,SQRTDCHECKB // A0 = Long Check Data Offset
  ld t1,0(a0)       // T1 = Long Check Data
  beq t0,t1,SQRTDPASSB // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,32,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SQRTDENDB
  nop // Delay Slot
  SQRTDPASSB:
  PrintString($A0100000,528,32,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SQRTDENDB:

  la a0,VALUEDOUBLEC // A0 = Double Data Offset
  ldc1 f0,0(a0)      // F0 = Double Data
  sqrt.d f0 // Convert To Long Data
  la a0,FSLONG  // A0 = FSLONG Offset
  sdc1 f0,0(a0) // FSLONG = Long Data
  PrintString($A0100000,80,40,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,40,FontBlack,VALUEDOUBLEC,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,40,FontBlack,TEXTDOUBLEC,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,40,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,40,FontBlack,FSLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FSLONG      // A0 = Long Data Offset
  ld t0,0(a0)       // T0 = Long Data
  la a0,SQRTDCHECKC // A0 = Long Check Data Offset
  ld t1,0(a0)       // T1 = Long Check Data
  beq t0,t1,SQRTDPASSC // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,40,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SQRTDENDC
  nop // Delay Slot
  SQRTDPASSC:
  PrintString($A0100000,528,40,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SQRTDENDC:

  la a0,VALUEDOUBLED // A0 = Double Data Offset
  ldc1 f0,0(a0)      // F0 = Double Data
  sqrt.d f0 // Convert To Long Data
  la a0,FSLONG  // A0 = FSLONG Offset
  sdc1 f0,0(a0) // FSLONG = Long Data
  PrintString($A0100000,80,48,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,48,FontBlack,VALUEDOUBLED,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,48,FontBlack,TEXTDOUBLED,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,48,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,48,FontBlack,FSLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FSLONG      // A0 = Long Data Offset
  ld t0,0(a0)       // T0 = Long Data
  la a0,SQRTDCHECKD // A0 = Long Check Data Offset
  ld t1,0(a0)       // T1 = Long Check Data
  beq t0,t1,SQRTDPASSD // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,48,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SQRTDENDD
  nop // Delay Slot
  SQRTDPASSD:
  PrintString($A0100000,528,48,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SQRTDENDD:

  
  PrintString($A0100000,8,64,FontRed,SQRTS,5) // Print Text String To VRAM Using Font At X,Y Position
  la a0,VALUEFLOATA // A0 = Float Data Offset
  lwc1 f0,0(a0)     // F0 = Float Data
  sqrt.s f0 // Convert To Word Data
  la a0,FSWORD  // A0 = FSWORD Offset
  swc1 f0,0(a0) // FSWORD = Word Data
  PrintString($A0100000,144,64,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,64,FontBlack,VALUEFLOATA,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,344,64,FontBlack,TEXTFLOATA,2) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,64,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,64,FontBlack,FSWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FSWORD      // A0 = Word Data Offset
  lw t0,0(a0)       // T0 = Word Data
  la a0,SQRTSCHECKA // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,SQRTSPASSA // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,64,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SQRTSENDA
  nop // Delay Slot
  SQRTSPASSA:
  PrintString($A0100000,528,64,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SQRTSENDA:

  la a0,VALUEFLOATB // A0 = Float Data Offset
  lwc1 f0,0(a0)     // F0 = Float Data
  sqrt.s f0 // Convert To Word Data
  la a0,FSWORD  // A0 = FSWORD Offset
  swc1 f0,0(a0) // FSWORD = Word Data
  PrintString($A0100000,144,72,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,72,FontBlack,VALUEFLOATB,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,296,72,FontBlack,TEXTFLOATB,8) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,72,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,72,FontBlack,FSWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FSWORD      // A0 = Word Data Offset
  lw t0,0(a0)       // T0 = Word Data
  la a0,SQRTSCHECKB // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,SQRTSPASSB // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,72,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SQRTSENDB
  nop // Delay Slot
  SQRTSPASSB:
  PrintString($A0100000,528,72,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SQRTSENDB:

  la a0,VALUEFLOATC // A0 = Float Data Offset
  lwc1 f0,0(a0)     // F0 = Float Data
  sqrt.s f0 // Convert To Word Data
  la a0,FSWORD  // A0 = FSWORD Offset
  swc1 f0,0(a0) // FSWORD = Word Data
  PrintString($A0100000,144,80,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,80,FontBlack,VALUEFLOATC,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,320,80,FontBlack,TEXTFLOATC,5) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,80,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,80,FontBlack,FSWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FSWORD      // A0 = Word Data Offset
  lw t0,0(a0)       // T0 = Word Data
  la a0,SQRTSCHECKC // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,SQRTSPASSC // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,80,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SQRTSENDC
  nop // Delay Slot
  SQRTSPASSC:
  PrintString($A0100000,528,80,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SQRTSENDC:

  la a0,VALUEFLOATD // A0 = Float Data Offset
  lwc1 f0,0(a0)     // F0 = Float Data
  sqrt.s f0 // Convert To Word Data
  la a0,FSWORD  // A0 = FSWORD Offset
  swc1 f0,0(a0) // FSWORD = Word Data
  PrintString($A0100000,144,88,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,152,88,FontBlack,VALUEFLOATD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,296,88,FontBlack,TEXTFLOATD,8) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,440,88,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,88,FontBlack,FSWORD,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FSWORD      // A0 = Word Data Offset
  lw t0,0(a0)       // T0 = Word Data
  la a0,SQRTSCHECKD // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,SQRTSPASSD // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,88,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SQRTSENDD
  nop // Delay Slot
  SQRTSPASSD:
  PrintString($A0100000,528,88,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SQRTSENDD:

  PrintString($A0100000,0,96,FontBlack,PAGEBREAK,79) // Print Text String To VRAM Using Font At X,Y Position


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

SQRTD:
  db "SQRT.D"
SQRTS:
  db "SQRT.S"

SQRTFSHEX:
  db "SQRT(FS) (Hex)"
FSHEX:
  db "FS (Hex)"
FSDEC:
  db "FS (Decimal)"
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

TEXTFLOATA:
  db "0.0"
TEXTFLOATB:
  db "1234.6789"
TEXTFLOATC:
  db "1234.5"
TEXTFLOATD:
  db "1234.1234"

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

SQRTDCHECKA:
  dd $0000000000000000
SQRTDCHECKB:
  dd $40AB734899A3F078
SQRTDCHECKC:
  dd $40AB7348964DA78C
SQRTDCHECKD:
  dd $40AB73488F47B4BB

FSLONG:
  dd 0

VALUEFLOATA:
  float32 0.0
VALUEFLOATB:
  float32 1234.6789
VALUEFLOATC:
  float32 1234.5
VALUEFLOATD:
  float32 1234.1234

SQRTSCHECKA:
  dw $00000000
SQRTSCHECKB:
  dw $420C8D50
SQRTSCHECKC:
  dw $420C8AB4
SQRTSCHECKD:
  dw $420C8537

FSWORD:
  dw 0

insert FontBlack, "FontBlack8x8.bin"
insert FontGreen, "FontGreen8x8.bin"
insert FontRed, "FontRed8x8.bin"