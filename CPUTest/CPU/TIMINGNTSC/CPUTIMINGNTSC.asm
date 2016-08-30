// N64 'Bare Metal' CPU Instruction Timing (NTSC) Test Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "CPUTIMINGNTSC.N64", create
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


  PrintString($A0100000,312,8,FontRed,INSTPERVIHEX,24) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,528,8,FontRed,TEST,10) // Print Text String To VRAM Using Font At X,Y Position


  PrintString($A0100000,0,16,FontBlack,PAGEBREAK,79) // Print Text String To VRAM Using Font At X,Y Position


  PrintString($A0100000,8,24,FontRed,ADD,2) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEWORDA // T1 = Word Data Offset
  lw t1,0(t1)      // T1 = Word Data
  la t2,VALUEWORDB // T2 = Word Data Offset
  lw t2,0(t2)      // T2 = Word Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  ADDWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,ADDWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  ADDWAITEND:
    add t1,t2 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,ADDWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,24,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,24,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD // T0 = Word Data Offset
  lw t1,0(t0)     // T1 = Word Data
  la t0,ADDCOUNT  // T0 = Word Check Data Offset
  lw t2,0(t0)     // T2 = Word Check Data
  beq t1,t2,ADDPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,24,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j ADDEND
  nop // Delay Slot
  ADDPASS:
  PrintString($A0100000,528,24,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  ADDEND:

  PrintString($A0100000,8,32,FontRed,ADDI,3) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEWORDA // T1 = Word Data Offset
  lw t1,0(t1)      // T1 = Word Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  ADDIWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,ADDIWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  ADDIWAITEND:
    addi t1,1 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,ADDIWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,32,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,32,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD // T0 = Word Data Offset
  lw t1,0(t0)     // T1 = Word Data
  la t0,ADDICOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)     // T2 = Word Check Data
  beq t1,t2,ADDIPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,32,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j ADDIEND
  nop // Delay Slot
  ADDIPASS:
  PrintString($A0100000,528,32,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  ADDIEND:

  PrintString($A0100000,8,40,FontRed,ADDIU,4) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEWORDA // T1 = Word Data Offset
  lw t1,0(t1)      // T1 = Word Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  ADDIUWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,ADDIUWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  ADDIUWAITEND:
    addiu t1,1 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,ADDIUWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,40,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,40,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD  // T0 = Word Data Offset
  lw t1,0(t0)      // T1 = Word Data
  la t0,ADDIUCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)      // T2 = Word Check Data
  beq t1,t2,ADDIUPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,40,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j ADDIUEND
  nop // Delay Slot
  ADDIUPASS:
  PrintString($A0100000,528,40,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  ADDIUEND:

  PrintString($A0100000,8,48,FontRed,ADDU,3) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEWORDA // T1 = Word Data Offset
  lw t1,0(t1)      // T1 = Word Data
  la t2,VALUEWORDB // T2 = Word Data Offset
  lw t2,0(t2)      // T2 = Word Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  ADDUWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,ADDUWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  ADDUWAITEND:
    addu t1,t2 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,ADDUWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,48,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,48,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD // T0 = Word Data Offset
  lw t1,0(t0)     // T1 = Word Data
  la t0,ADDUCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)     // T2 = Word Check Data
  beq t1,t2,ADDUPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,48,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j ADDUEND
  nop // Delay Slot
  ADDUPASS:
  PrintString($A0100000,528,48,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  ADDUEND:

  PrintString($A0100000,8,56,FontRed,AND,2) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEWORDA // T1 = Word Data Offset
  lw t1,0(t1)      // T1 = Word Data
  la t2,VALUEWORDB // T2 = Word Data Offset
  lw t2,0(t2)      // T2 = Word Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  ANDWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,ANDWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  ANDWAITEND:
    and t1,t2 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,ANDWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,56,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,56,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD // T0 = Word Data Offset
  lw t1,0(t0)     // T1 = Word Data
  la t0,ANDCOUNT  // T0 = Word Check Data Offset
  lw t2,0(t0)     // T2 = Word Check Data
  beq t1,t2,ANDPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,56,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j ANDEND
  nop // Delay Slot
  ANDPASS:
  PrintString($A0100000,528,56,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  ANDEND:

  PrintString($A0100000,8,64,FontRed,ANDI,3) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEWORDA // T1 = Word Data Offset
  lw t1,0(t1)      // T1 = Word Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  ANDIWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,ANDIWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  ANDIWAITEND:
    andi t1,1 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,ANDIWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,64,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,64,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD // T0 = Word Data Offset
  lw t1,0(t0)     // T1 = Word Data
  la t0,ANDICOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)     // T2 = Word Check Data
  beq t1,t2,ANDIPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,64,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j ANDIEND
  nop // Delay Slot
  ANDIPASS:
  PrintString($A0100000,528,64,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  ANDIEND:

  PrintString($A0100000,8,72,FontRed,DADD,3) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEWORDA // T1 = Word Data Offset
  lw t1,0(t1)      // T1 = Word Data
  la t2,VALUEWORDB // T2 = Word Data Offset
  lw t2,0(t2)      // T2 = Word Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  DADDWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,DADDWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  DADDWAITEND:
    dadd t1,t2 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,DADDWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,72,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,72,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD // T0 = Word Data Offset
  lw t1,0(t0)     // T1 = Word Data
  la t0,DADDCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)     // T2 = Word Check Data
  beq t1,t2,DADDPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,72,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DADDEND
  nop // Delay Slot
  DADDPASS:
  PrintString($A0100000,528,72,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DADDEND:

  PrintString($A0100000,8,80,FontRed,DADDI,4) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEWORDA // T1 = Word Data Offset
  lw t1,0(t1)      // T1 = Word Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  DADDIWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,DADDIWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  DADDIWAITEND:
    daddi t1,1 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,DADDIWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,80,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,80,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD  // T0 = Word Data Offset
  lw t1,0(t0)      // T1 = Word Data
  la t0,DADDICOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)      // T2 = Word Check Data
  beq t1,t2,DADDIPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,80,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DADDIEND
  nop // Delay Slot
  DADDIPASS:
  PrintString($A0100000,528,80,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DADDIEND:

  PrintString($A0100000,8,88,FontRed,DADDIU,5) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEWORDA // T1 = Word Data Offset
  lw t1,0(t1)      // T1 = Word Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  DADDIUWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,DADDIUWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  DADDIUWAITEND:
    daddiu t1,1 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,DADDIUWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,88,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,88,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD   // T0 = Word Data Offset
  lw t1,0(t0)       // T1 = Word Data
  la t0,DADDIUCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)       // T2 = Word Check Data
  beq t1,t2,DADDIUPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,88,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DADDIUEND
  nop // Delay Slot
  DADDIUPASS:
  PrintString($A0100000,528,88,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DADDIUEND:

  PrintString($A0100000,8,96,FontRed,DADDU,4) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEWORDA // T1 = Word Data Offset
  lw t1,0(t1)      // T1 = Word Data
  la t2,VALUEWORDB // T2 = Word Data Offset
  lw t2,0(t2)      // T2 = Word Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  DADDUWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,DADDUWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  DADDUWAITEND:
    daddu t1,t2 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,DADDUWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,96,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,96,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD  // T0 = Word Data Offset
  lw t1,0(t0)      // T1 = Word Data
  la t0,DADDUCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)      // T2 = Word Check Data
  beq t1,t2,DADDUPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,96,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DADDUEND
  nop // Delay Slot
  DADDUPASS:
  PrintString($A0100000,528,96,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DADDUEND:

  PrintString($A0100000,8,104,FontRed,DDIV,3) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEWORDA // T1 = Word Data Offset
  lw t1,0(t1)      // T1 = Word Data
  la t2,VALUEWORDB // T2 = Word Data Offset
  lw t2,0(t2)      // T2 = Word Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  DDIVWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,DDIVWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  DDIVWAITEND:
    ddiv t1,t2 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,DDIVWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,104,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,104,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD // T0 = Word Data Offset
  lw t1,0(t0)     // T1 = Word Data
  la t0,DDIVCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)     // T2 = Word Check Data
  beq t1,t2,DDIVPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,104,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DDIVEND
  nop // Delay Slot
  DDIVPASS:
  PrintString($A0100000,528,104,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DDIVEND:

  PrintString($A0100000,8,112,FontRed,DDIVU,4) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEWORDA // T1 = Word Data Offset
  lw t1,0(t1)      // T1 = Word Data
  la t2,VALUEWORDB // T2 = Word Data Offset
  lw t2,0(t2)      // T2 = Word Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  DDIVUWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,DDIVUWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  DDIVUWAITEND:
    ddivu t1,t2 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,DDIVUWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,112,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,112,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD  // T0 = Word Data Offset
  lw t1,0(t0)      // T1 = Word Data
  la t0,DDIVUCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)      // T2 = Word Check Data
  beq t1,t2,DDIVUPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,112,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DDIVUEND
  nop // Delay Slot
  DDIVUPASS:
  PrintString($A0100000,528,112,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DDIVUEND:

  PrintString($A0100000,8,120,FontRed,DIV,2) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEWORDA // T1 = Word Data Offset
  lw t1,0(t1)      // T1 = Word Data
  la t2,VALUEWORDB // T2 = Word Data Offset
  lw t2,0(t2)      // T2 = Word Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  DIVWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,DIVWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  DIVWAITEND:
    div t1,t2 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,DIVWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,120,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,120,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD // T0 = Word Data Offset
  lw t1,0(t0)     // T1 = Word Data
  la t0,DIVCOUNT  // T0 = Word Check Data Offset
  lw t2,0(t0)     // T2 = Word Check Data
  beq t1,t2,DIVPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,120,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DIVEND
  nop // Delay Slot
  DIVPASS:
  PrintString($A0100000,528,120,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DIVEND:

  PrintString($A0100000,8,128,FontRed,DIVU,3) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEWORDA // T1 = Word Data Offset
  lw t1,0(t1)      // T1 = Word Data
  la t2,VALUEWORDB // T2 = Word Data Offset
  lw t2,0(t2)      // T2 = Word Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  DIVUWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,DIVUWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  DIVUWAITEND:
    divu t1,t2 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,DIVUWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,128,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,128,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD // T0 = Word Data Offset
  lw t1,0(t0)     // T1 = Word Data
  la t0,DIVUCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)     // T2 = Word Check Data
  beq t1,t2,DIVUPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,128,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DIVUEND
  nop // Delay Slot
  DIVUPASS:
  PrintString($A0100000,528,128,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DIVUEND:

  PrintString($A0100000,8,136,FontRed,DMULT,4) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEWORDA // T1 = Word Data Offset
  lw t1,0(t1)      // T1 = Word Data
  la t2,VALUEWORDB // T2 = Word Data Offset
  lw t2,0(t2)      // T2 = Word Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  DMULTWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,DMULTWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  DMULTWAITEND:
    dmult t1,t2 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,DMULTWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,136,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,136,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD  // T0 = Word Data Offset
  lw t1,0(t0)      // T1 = Word Data
  la t0,DMULTCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)      // T2 = Word Check Data
  beq t1,t2,DMULTPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,136,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DMULTEND
  nop // Delay Slot
  DMULTPASS:
  PrintString($A0100000,528,136,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DMULTEND:

  PrintString($A0100000,8,144,FontRed,DMULTU,5) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEWORDA // T1 = Word Data Offset
  lw t1,0(t1)      // T1 = Word Data
  la t2,VALUEWORDB // T2 = Word Data Offset
  lw t2,0(t2)      // T2 = Word Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  DMULTUWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,DMULTUWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  DMULTUWAITEND:
    dmultu t1,t2 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,DMULTUWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,144,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,144,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD   // T0 = Word Data Offset
  lw t1,0(t0)       // T1 = Word Data
  la t0,DMULTUCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)       // T2 = Word Check Data
  beq t1,t2,DMULTUPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,144,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DMULTUEND
  nop // Delay Slot
  DMULTUPASS:
  PrintString($A0100000,528,144,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DMULTUEND:

  PrintString($A0100000,8,152,FontRed,DSLL,3) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEWORDA // T1 = Word Data Offset
  lw t1,0(t1)      // T1 = Word Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  DSLLWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,DSLLWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  DSLLWAITEND:
    dsll t1,1 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,DSLLWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,152,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,152,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD // T0 = Word Data Offset
  lw t1,0(t0)     // T1 = Word Data
  la t0,DSLLCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)     // T2 = Word Check Data
  beq t1,t2,DSLLPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,152,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSLLEND
  nop // Delay Slot
  DSLLPASS:
  PrintString($A0100000,528,152,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSLLEND:

  PrintString($A0100000,8,160,FontRed,DSLL32,5) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEWORDA // T1 = Word Data Offset
  lw t1,0(t1)      // T1 = Word Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  DSLL32WAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,DSLL32WAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  DSLL32WAITEND:
    dsll32 t1,1 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,DSLL32WAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,160,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,160,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD // T0 = Word Data Offset
  lw t1,0(t0)     // T1 = Word Data
  la t0,DSLL32COUNT // T0 = Word Check Data Offset
  lw t2,0(t0)     // T2 = Word Check Data
  beq t1,t2,DSLL32PASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,160,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSLL32END
  nop // Delay Slot
  DSLL32PASS:
  PrintString($A0100000,528,160,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSLL32END:

  PrintString($A0100000,8,168,FontRed,DSLLV,4) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEWORDA // T1 = Word Data Offset
  lw t1,0(t1)      // T1 = Word Data
  la t2,VALUEWORDB // T2 = Word Data Offset
  lw t2,0(t2)      // T2 = Word Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  DSLLVWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,DSLLVWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  DSLLVWAITEND:
    dsllv t1,t2 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,DSLLVWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,168,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,168,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD  // T0 = Word Data Offset
  lw t1,0(t0)      // T1 = Word Data
  la t0,DSLLVCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)      // T2 = Word Check Data
  beq t1,t2,DSLLVPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,168,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSLLVEND
  nop // Delay Slot
  DSLLVPASS:
  PrintString($A0100000,528,168,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSLLVEND:

  PrintString($A0100000,8,176,FontRed,DSRA,3) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEWORDA // T1 = Word Data Offset
  lw t1,0(t1)      // T1 = Word Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  DSRAWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,DSRAWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  DSRAWAITEND:
    dsra t1,1 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,DSRAWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,176,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,176,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD // T0 = Word Data Offset
  lw t1,0(t0)     // T1 = Word Data
  la t0,DSRACOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)     // T2 = Word Check Data
  beq t1,t2,DSRAPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,176,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRAEND
  nop // Delay Slot
  DSRAPASS:
  PrintString($A0100000,528,176,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRAEND:

  PrintString($A0100000,8,184,FontRed,DSRA32,5) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEWORDA // T1 = Word Data Offset
  lw t1,0(t1)      // T1 = Word Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  DSRA32WAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,DSRA32WAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  DSRA32WAITEND:
    dsra32 t1,1 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,DSRA32WAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,184,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,184,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD // T0 = Word Data Offset
  lw t1,0(t0)     // T1 = Word Data
  la t0,DSRA32COUNT // T0 = Word Check Data Offset
  lw t2,0(t0)     // T2 = Word Check Data
  beq t1,t2,DSRA32PASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,184,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRA32END
  nop // Delay Slot
  DSRA32PASS:
  PrintString($A0100000,528,184,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRA32END:

  PrintString($A0100000,8,192,FontRed,DSRAV,4) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEWORDA // T1 = Word Data Offset
  lw t1,0(t1)      // T1 = Word Data
  la t2,VALUEWORDB // T2 = Word Data Offset
  lw t2,0(t2)      // T2 = Word Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  DSRAVWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,DSRAVWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  DSRAVWAITEND:
    dsrav t1,t2 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,DSRAVWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,192,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,192,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD  // T0 = Word Data Offset
  lw t1,0(t0)      // T1 = Word Data
  la t0,DSRAVCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)      // T2 = Word Check Data
  beq t1,t2,DSRAVPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,192,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND
  nop // Delay Slot
  DSRAVPASS:
  PrintString($A0100000,528,192,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND:

  PrintString($A0100000,8,200,FontRed,DSRL,3) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEWORDA // T1 = Word Data Offset
  lw t1,0(t1)      // T1 = Word Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  DSRLWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,DSRLWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  DSRLWAITEND:
    dsrl t1,1 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,DSRLWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,200,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,200,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD // T0 = Word Data Offset
  lw t1,0(t0)     // T1 = Word Data
  la t0,DSRLCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)     // T2 = Word Check Data
  beq t1,t2,DSRLPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,200,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRLEND
  nop // Delay Slot
  DSRLPASS:
  PrintString($A0100000,528,200,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRLEND:

  PrintString($A0100000,8,208,FontRed,DSRL32,5) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEWORDA // T1 = Word Data Offset
  lw t1,0(t1)      // T1 = Word Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  DSRL32WAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,DSRL32WAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  DSRL32WAITEND:
    dsrl32 t1,1 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,DSRL32WAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,208,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,208,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD // T0 = Word Data Offset
  lw t1,0(t0)     // T1 = Word Data
  la t0,DSRL32COUNT // T0 = Word Check Data Offset
  lw t2,0(t0)     // T2 = Word Check Data
  beq t1,t2,DSRL32PASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,208,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRL32END
  nop // Delay Slot
  DSRL32PASS:
  PrintString($A0100000,528,208,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRL32END:

  PrintString($A0100000,8,216,FontRed,DSRLV,4) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEWORDA // T1 = Word Data Offset
  lw t1,0(t1)      // T1 = Word Data
  la t2,VALUEWORDB // T2 = Word Data Offset
  lw t2,0(t2)      // T2 = Word Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  DSRLVWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,DSRLVWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  DSRLVWAITEND:
    dsrlv t1,t2 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,DSRLVWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,216,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,216,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD  // T0 = Word Data Offset
  lw t1,0(t0)      // T1 = Word Data
  la t0,DSRLVCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)      // T2 = Word Check Data
  beq t1,t2,DSRLVPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,216,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRLVEND
  nop // Delay Slot
  DSRLVPASS:
  PrintString($A0100000,528,216,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRLVEND:

  PrintString($A0100000,8,224,FontRed,DSUB,3) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEWORDA // T1 = Word Data Offset
  lw t1,0(t1)      // T1 = Word Data
  la t2,VALUEWORDB // T2 = Word Data Offset
  lw t2,0(t2)      // T2 = Word Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  DSUBWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,DSUBWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  DSUBWAITEND:
    dsub t1,t2 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,DSUBWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,224,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,224,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD // T0 = Word Data Offset
  lw t1,0(t0)     // T1 = Word Data
  la t0,DSUBCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)     // T2 = Word Check Data
  beq t1,t2,DSUBPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,224,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSUBEND
  nop // Delay Slot
  DSUBPASS:
  PrintString($A0100000,528,224,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSUBEND:

  PrintString($A0100000,8,232,FontRed,DSUBU,4) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEWORDA // T1 = Word Data Offset
  lw t1,0(t1)      // T1 = Word Data
  la t2,VALUEWORDB // T2 = Word Data Offset
  lw t2,0(t2)      // T2 = Word Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  DSUBUWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,DSUBUWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  DSUBUWAITEND:
    dsubu t1,t2 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,DSUBUWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,232,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,232,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD  // T0 = Word Data Offset
  lw t1,0(t0)      // T1 = Word Data
  la t0,DSUBUCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)      // T2 = Word Check Data
  beq t1,t2,DSUBUPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,232,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSUBUEND
  nop // Delay Slot
  DSUBUPASS:
  PrintString($A0100000,528,232,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSUBUEND:

  PrintString($A0100000,8,240,FontRed,MULT,3) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEWORDA // T1 = Word Data Offset
  lw t1,0(t1)      // T1 = Word Data
  la t2,VALUEWORDB // T2 = Word Data Offset
  lw t2,0(t2)      // T2 = Word Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  MULTWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,MULTWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  MULTWAITEND:
    mult t1,t2 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,MULTWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,240,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,240,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD // T0 = Word Data Offset
  lw t1,0(t0)     // T1 = Word Data
  la t0,MULTCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)     // T2 = Word Check Data
  beq t1,t2,MULTPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,240,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j MULTEND
  nop // Delay Slot
  MULTPASS:
  PrintString($A0100000,528,240,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  MULTEND:

  PrintString($A0100000,8,248,FontRed,MULTU,4) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEWORDA // T1 = Word Data Offset
  lw t1,0(t1)      // T1 = Word Data
  la t2,VALUEWORDB // T2 = Word Data Offset
  lw t2,0(t2)      // T2 = Word Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  MULTUWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,MULTUWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  MULTUWAITEND:
    multu t1,t2 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,MULTUWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,248,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,248,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD  // T0 = Word Data Offset
  lw t1,0(t0)      // T1 = Word Data
  la t0,MULTUCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)      // T2 = Word Check Data
  beq t1,t2,MULTUPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,248,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j MULTUEND
  nop // Delay Slot
  MULTUPASS:
  PrintString($A0100000,528,248,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  MULTUEND:

  PrintString($A0100000,8,256,FontRed,NOR,2) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEWORDA // T1 = Word Data Offset
  lw t1,0(t1)      // T1 = Word Data
  la t2,VALUEWORDB // T2 = Word Data Offset
  lw t2,0(t2)      // T2 = Word Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  NORWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,NORWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  NORWAITEND:
    nor t1,t2 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,NORWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,256,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,256,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD // T0 = Word Data Offset
  lw t1,0(t0)     // T1 = Word Data
  la t0,NORCOUNT  // T0 = Word Check Data Offset
  lw t2,0(t0)     // T2 = Word Check Data
  beq t1,t2,NORPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,256,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j NOREND
  nop // Delay Slot
  NORPASS:
  PrintString($A0100000,528,256,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  NOREND:

  PrintString($A0100000,8,264,FontRed,OR,1) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEWORDA // T1 = Word Data Offset
  lw t1,0(t1)      // T1 = Word Data
  la t2,VALUEWORDB // T2 = Word Data Offset
  lw t2,0(t2)      // T2 = Word Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  ORWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,ORWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  ORWAITEND:
    or t1,t2 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,ORWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,264,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,264,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD // T0 = Word Data Offset
  lw t1,0(t0)     // T1 = Word Data
  la t0,ORCOUNT   // T0 = Word Check Data Offset
  lw t2,0(t0)     // T2 = Word Check Data
  beq t1,t2,ORPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,264,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j OREND
  nop // Delay Slot
  ORPASS:
  PrintString($A0100000,528,264,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  OREND:

  PrintString($A0100000,8,272,FontRed,ORI,2) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEWORDA // T1 = Word Data Offset
  lw t1,0(t1)      // T1 = Word Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  ORIWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,ORIWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  ORIWAITEND:
    ori t1,1 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,ORIWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,272,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,272,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD // T0 = Word Data Offset
  lw t1,0(t0)     // T1 = Word Data
  la t0,ORICOUNT  // T0 = Word Check Data Offset
  lw t2,0(t0)     // T2 = Word Check Data
  beq t1,t2,ORIPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,272,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j ORIEND
  nop // Delay Slot
  ORIPASS:
  PrintString($A0100000,528,272,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  ORIEND:

  PrintString($A0100000,8,280,FontRed,SLL,2) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEWORDA // T1 = Word Data Offset
  lw t1,0(t1)      // T1 = Word Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  SLLWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,SLLWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  SLLWAITEND:
    sll t1,1 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,SLLWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,280,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,280,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD // T0 = Word Data Offset
  lw t1,0(t0)     // T1 = Word Data
  la t0,SLLCOUNT  // T0 = Word Check Data Offset
  lw t2,0(t0)     // T2 = Word Check Data
  beq t1,t2,SLLPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,280,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLEND
  nop // Delay Slot
  SLLPASS:
  PrintString($A0100000,528,280,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLEND:

  PrintString($A0100000,8,288,FontRed,SLLV,3) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEWORDA // T1 = Word Data Offset
  lw t1,0(t1)      // T1 = Word Data
  la t2,VALUEWORDB // T2 = Word Data Offset
  lw t2,0(t2)      // T2 = Word Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  SLLVWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,SLLVWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  SLLVWAITEND:
    sllv t1,t2 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,SLLVWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,288,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,288,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD // T0 = Word Data Offset
  lw t1,0(t0)     // T1 = Word Data
  la t0,SLLVCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)     // T2 = Word Check Data
  beq t1,t2,SLLVPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,288,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SLLVEND
  nop // Delay Slot
  SLLVPASS:
  PrintString($A0100000,528,288,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SLLVEND:

  PrintString($A0100000,8,296,FontRed,SRA,2) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEWORDA // T1 = Word Data Offset
  lw t1,0(t1)      // T1 = Word Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  SRAWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,SRAWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  SRAWAITEND:
    sra t1,1 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,SRAWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,296,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,296,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD // T0 = Word Data Offset
  lw t1,0(t0)     // T1 = Word Data
  la t0,SRACOUNT  // T0 = Word Check Data Offset
  lw t2,0(t0)     // T2 = Word Check Data
  beq t1,t2,SRAPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,296,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRAEND
  nop // Delay Slot
  SRAPASS:
  PrintString($A0100000,528,296,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRAEND:

  PrintString($A0100000,8,304,FontRed,SRAV,3) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEWORDA // T1 = Word Data Offset
  lw t1,0(t1)      // T1 = Word Data
  la t2,VALUEWORDB // T2 = Word Data Offset
  lw t2,0(t2)      // T2 = Word Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  SRAVWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,SRAVWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  SRAVWAITEND:
    srav t1,t2 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,SRAVWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,304,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,304,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD // T0 = Word Data Offset
  lw t1,0(t0)     // T1 = Word Data
  la t0,SRAVCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)     // T2 = Word Check Data
  beq t1,t2,SRAVPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,304,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRAVEND
  nop // Delay Slot
  SRAVPASS:
  PrintString($A0100000,528,304,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRAVEND:

  PrintString($A0100000,8,312,FontRed,SRL,2) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEWORDA // T1 = Word Data Offset
  lw t1,0(t1)      // T1 = Word Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  SRLWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,SRLWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  SRLWAITEND:
    srl t1,1 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,SRLWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,312,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,312,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD // T0 = Word Data Offset
  lw t1,0(t0)     // T1 = Word Data
  la t0,SRLCOUNT  // T0 = Word Check Data Offset
  lw t2,0(t0)     // T2 = Word Check Data
  beq t1,t2,SRLPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,312,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLEND
  nop // Delay Slot
  SRLPASS:
  PrintString($A0100000,528,312,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLEND:

  PrintString($A0100000,8,320,FontRed,SRLV,3) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEWORDA // T1 = Word Data Offset
  lw t1,0(t1)      // T1 = Word Data
  la t2,VALUEWORDB // T2 = Word Data Offset
  lw t2,0(t2)      // T2 = Word Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  SRLVWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,SRLVWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  SRLVWAITEND:
    srlv t1,t2 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,SRLVWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,320,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,320,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD // T0 = Word Data Offset
  lw t1,0(t0)     // T1 = Word Data
  la t0,SRLVCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)     // T2 = Word Check Data
  beq t1,t2,SRLVPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,320,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SRLVEND
  nop // Delay Slot
  SRLVPASS:
  PrintString($A0100000,528,320,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SRLVEND:

  PrintString($A0100000,8,328,FontRed,SUB,2) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEWORDA // T1 = Word Data Offset
  lw t1,0(t1)      // T1 = Word Data
  la t2,VALUEWORDB // T2 = Word Data Offset
  lw t2,0(t2)      // T2 = Word Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  SUBWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,SUBWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  SUBWAITEND:
    sub t1,t2 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,SUBWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,328,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,328,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD // T0 = Word Data Offset
  lw t1,0(t0)     // T1 = Word Data
  la t0,SUBCOUNT  // T0 = Word Check Data Offset
  lw t2,0(t0)     // T2 = Word Check Data
  beq t1,t2,SUBPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,328,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SUBEND
  nop // Delay Slot
  SUBPASS:
  PrintString($A0100000,528,328,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SUBEND:

  PrintString($A0100000,8,336,FontRed,SUBU,3) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEWORDA // T1 = Word Data Offset
  lw t1,0(t1)      // T1 = Word Data
  la t2,VALUEWORDB // T2 = Word Data Offset
  lw t2,0(t2)      // T2 = Word Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  SUBUWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,SUBUWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  SUBUWAITEND:
    subu t1,t2 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,SUBUWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,336,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,336,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD // T0 = Word Data Offset
  lw t1,0(t0)     // T1 = Word Data
  la t0,SUBUCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)     // T2 = Word Check Data
  beq t1,t2,SUBUPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,336,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SUBUEND
  nop // Delay Slot
  SUBUPASS:
  PrintString($A0100000,528,336,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SUBUEND:

  PrintString($A0100000,8,344,FontRed,XOR,2) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEWORDA // T1 = Word Data Offset
  lw t1,0(t1)      // T1 = Word Data
  la t2,VALUEWORDB // T2 = Word Data Offset
  lw t2,0(t2)      // T2 = Word Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  XORWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,XORWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  XORWAITEND:
    xor t1,t2 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,XORWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,344,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,344,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD // T0 = Word Data Offset
  lw t1,0(t0)     // T1 = Word Data
  la t0,XORCOUNT  // T0 = Word Check Data Offset
  lw t2,0(t0)     // T2 = Word Check Data
  beq t1,t2,XORPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,344,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j XOREND
  nop // Delay Slot
  XORPASS:
  PrintString($A0100000,528,344,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  XOREND:

  PrintString($A0100000,8,352,FontRed,XORI,3) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEWORDA // T1 = Word Data Offset
  lw t1,0(t1)      // T1 = Word Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  XORIWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,XORIWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  XORIWAITEND:
    xori t1,1 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,XORIWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,352,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,352,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD // T0 = Word Data Offset
  lw t1,0(t0)     // T1 = Word Data
  la t0,XORICOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)     // T2 = Word Check Data
  beq t1,t2,XORIPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,352,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j XORIEND
  nop // Delay Slot
  XORIPASS:
  PrintString($A0100000,528,352,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  XORIEND:


  PrintString($A0100000,0,360,FontBlack,PAGEBREAK,79) // Print Text String To VRAM Using Font At X,Y Position


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

ADD:
  db "ADD"
ADDI:
  db "ADDI"
ADDIU:
  db "ADDIU"
ADDU:
  db "ADDU"
AND:
  db "AND"
ANDI:
  db "ANDI"
DADD:
  db "DADD"
DADDI:
  db "DADDI"
DADDIU:
  db "DADDIU"
DADDU:
  db "DADDU"
DDIV:
  db "DDIV"
DDIVU:
  db "DDIVU"
DIV:
  db "DIV"
DIVU:
  db "DIVU"
DMULT:
  db "DMULT"
DMULTU:
  db "DMULTU"
DSLL:
  db "DSLL"
DSLL32:
  db "DSLL32"
DSLLV:
  db "DSLLV"
DSRA:
  db "DSRA"
DSRA32:
  db "DSRA32"
DSRAV:
  db "DSRAV"
DSRL:
  db "DSRL"
DSRL32:
  db "DSRL32"
DSRLV:
  db "DSRLV"
DSUB:
  db "DSUB"
DSUBU:
  db "DSUBU"
MULT:
  db "MULT"
MULTU:
  db "MULTU"
NOR:
  db "NOR"
OR:
  db "OR"
ORI:
  db "ORI"
SLL:
  db "SLL"
SLLV:
  db "SLLV"
SRA:
  db "SRA"
SRAV:
  db "SRAV"
SRL:
  db "SRL"
SRLV:
  db "SRLV"
SUB:
  db "SUB"
SUBU:
  db "SUBU"
XOR:
  db "XOR"
XORI:
  db "XORI"

INSTPERVIHEX:
  db "Instructions Per VI (Hex)"
TEST:
  db "Test Result"
FAIL:
  db "FAIL"
PASS:
  db "PASS"

DOLLAR:
  db "$"

PAGEBREAK:
  db "--------------------------------------------------------------------------------"

align(8) // Align 64-Bit
VALUEWORDA:
  dw -123456789
VALUEWORDB:
  dw 1

ADDCOUNT:
  dw $0000DB1C
ADDICOUNT:
  dw $0000DB1B
ADDIUCOUNT:
  dw $0000DB1C
ADDUCOUNT:
  dw $0000DB1B
ANDCOUNT:
  dw $0000DB1B
ANDICOUNT:
  dw $0000DB1C
DADDCOUNT:
  dw $0000DB1B
DADDICOUNT:
  dw $0000DB1C
DADDIUCOUNT:
  dw $0000DB1F
DADDUCOUNT:
  dw $0000DB1F
DDIVCOUNT:
  dw $00003EEC
DDIVUCOUNT:
  dw $00003EEC
DIVCOUNT:
  dw $00005E71
DIVUCOUNT:
  dw $00005E71
DMULTCOUNT:
  dw $0000B3B7
DMULTUCOUNT:
  dw $0000B3BA
DSLLCOUNT:
  dw $0000DB1B
DSLL32COUNT:
  dw $0000DB1C
DSLLVCOUNT:
  dw $0000DB1B
DSRACOUNT:
  dw $0000DB1C
DSRA32COUNT:
  dw $0000DB1F
DSRAVCOUNT:
  dw $0000DB1F
DSRLCOUNT:
  dw $0000DB1F
DSRL32COUNT:
  dw $0000DB1B
DSRLVCOUNT:
  dw $0000DB1B
DSUBCOUNT:
  dw $0000DB1F
DSUBUCOUNT:
  dw $0000DB1F
MULTCOUNT:
  dw $0000C344
MULTUCOUNT:
  dw $0000C342
NORCOUNT:
  dw $0000DB1C
ORCOUNT:
  dw $0000DB1B
ORICOUNT:
  dw $0000DB1C
SLLCOUNT:
  dw $0000DB1F
SLLVCOUNT:
  dw $0000DB1F
SRACOUNT:
  dw $0000DB1F
SRAVCOUNT:
  dw $0000DB1F
SRLCOUNT:
  dw $0000DB1B
SRLVCOUNT:
  dw $0000DB1F
SUBCOUNT:
  dw $0000DB1F
SUBUCOUNT:
  dw $0000DB1F
XORCOUNT:
  dw $0000DB1C
XORICOUNT:
  dw $0000DB1F

COUNTWORD:
  dw 0

insert FontBlack, "FontBlack8x8.bin"
insert FontGreen, "FontGreen8x8.bin"
insert FontRed, "FontRed8x8.bin"