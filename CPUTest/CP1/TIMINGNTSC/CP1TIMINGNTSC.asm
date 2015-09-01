// N64 'Bare Metal' CPU CP1/FPU Instruction Timing (NTSC) Test Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "CP1TIMINGNTSC.N64", create
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


  PrintString($A0100000,312,8,FontRed,INSTPERVIHEX,24) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,528,8,FontRed,TEST,10) // Print Text String To VRAM Using Font At X,Y Position


  PrintString($A0100000,0,16,FontBlack,PAGEBREAK,79) // Print Text String To VRAM Using Font At X,Y Position


  PrintString($A0100000,8,24,FontRed,ABSD,4) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEDOUBLEA // T1 = Double Data Offset
  ldc1 f0,0(t1)      // F0 = Double Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  ABSDWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,ABSDWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  ABSDWAITEND:
    abs.d f0 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,ABSDWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,24,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,24,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD // T0 = Word Data Offset
  lw t1,0(t0)     // T1 = Word Data
  la t0,ABSDCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)     // T2 = Word Check Data
  beq t1,t2,ABSDPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,24,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j ABSDEND
  nop // Delay Slot
  ABSDPASS:
  PrintString($A0100000,528,24,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  ABSDEND:

  PrintString($A0100000,8,32,FontRed,ABSS,4) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEFLOATA // T1 = Float Data Offset
  lwc1 f0,0(t1)     // F0 = Float Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  ABSSWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,ABSSWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  ABSSWAITEND:
    abs.s f0 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,ABSSWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,32,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,32,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD // T0 = Word Data Offset
  lw t1,0(t0)     // T1 = Word Data
  la t0,ABSSCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)     // T2 = Word Check Data
  beq t1,t2,ABSSPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,32,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j ABSSEND
  nop // Delay Slot
  ABSSPASS:
  PrintString($A0100000,528,32,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  ABSSEND:

  PrintString($A0100000,8,40,FontRed,ADDD,4) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEDOUBLEA // T1 = Double Data Offset
  ldc1 f0,0(t1)      // F0 = Double Data
  la t1,VALUEDOUBLEB // T1 = Double Data Offset
  ldc1 f1,0(t1)      // F1 = Double Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  ADDDWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,ADDDWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  ADDDWAITEND:
    add.d f0,f1 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,ADDDWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,40,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,40,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD // T0 = Word Data Offset
  lw t1,0(t0)     // T1 = Word Data
  la t0,ADDDCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)     // T2 = Word Check Data
  beq t1,t2,ADDDPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,40,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j ADDDEND
  nop // Delay Slot
  ADDDPASS:
  PrintString($A0100000,528,40,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  ADDDEND:

  PrintString($A0100000,8,48,FontRed,ADDS,4) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEFLOATA // T1 = Float Data Offset
  lwc1 f0,0(t1)     // F0 = Float Data
  la t1,VALUEFLOATB // T1 = Float Data Offset
  lwc1 f1,0(t1)     // F1 = Float Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  ADDSWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,ADDSWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  ADDSWAITEND:
    add.s f0,f1 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,ADDSWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,48,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,48,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD // T0 = Word Data Offset
  lw t1,0(t0)     // T1 = Word Data
  la t0,ADDSCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)     // T2 = Word Check Data
  beq t1,t2,ADDSPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,48,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j ADDSEND
  nop // Delay Slot
  ADDSPASS:
  PrintString($A0100000,528,48,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  ADDSEND:

  PrintString($A0100000,8,56,FontRed,CEILLD,7) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEDOUBLEA // T1 = Double Data Offset
  ldc1 f0,0(t1)      // F0 = Double Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  CEILLDWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,CEILLDWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  CEILLDWAITEND:
    ceil.l.d f0 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,CEILLDWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,56,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,56,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD   // T0 = Word Data Offset
  lw t1,0(t0)       // T1 = Word Data
  la t0,CEILLDCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)       // T2 = Word Check Data
  beq t1,t2,CEILLDPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,56,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CEILLDEND
  nop // Delay Slot
  CEILLDPASS:
  PrintString($A0100000,528,56,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CEILLDEND:

  PrintString($A0100000,8,64,FontRed,CEILLS,7) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEFLOATA // T1 = Float Data Offset
  lwc1 f0,0(t1)     // F0 = Float Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  CEILLSWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,CEILLSWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  CEILLSWAITEND:
    ceil.l.s f0 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,CEILLSWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,64,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,64,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD   // T0 = Word Data Offset
  lw t1,0(t0)       // T1 = Word Data
  la t0,CEILLSCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)       // T2 = Word Check Data
  beq t1,t2,CEILLSPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,64,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CEILLSEND
  nop // Delay Slot
  CEILLSPASS:
  PrintString($A0100000,528,64,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CEILLSEND:

  PrintString($A0100000,8,72,FontRed,CEILWD,7) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEDOUBLEA // T1 = Double Data Offset
  ldc1 f0,0(t1)      // F0 = Double Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  CEILWDWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,CEILWDWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  CEILWDWAITEND:
    ceil.w.d f0 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,CEILWDWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,72,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,72,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD   // T0 = Word Data Offset
  lw t1,0(t0)       // T1 = Word Data
  la t0,CEILWDCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)       // T2 = Word Check Data
  beq t1,t2,CEILWDPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,72,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CEILWDEND
  nop // Delay Slot
  CEILWDPASS:
  PrintString($A0100000,528,72,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CEILWDEND:

  PrintString($A0100000,8,80,FontRed,CEILWS,7) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEFLOATA // T1 = Float Data Offset
  lwc1 f0,0(t1)     // F0 = Float Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  CEILWSWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,CEILWSWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  CEILWSWAITEND:
    ceil.w.s f0 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,CEILWSWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,80,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,80,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD   // T0 = Word Data Offset
  lw t1,0(t0)       // T1 = Word Data
  la t0,CEILWSCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)       // T2 = Word Check Data
  beq t1,t2,CEILWSPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,80,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CEILWSEND
  nop // Delay Slot
  CEILWSPASS:
  PrintString($A0100000,528,80,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CEILWSEND:

  PrintString($A0100000,8,88,FontRed,CVTDL,6) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEDOUBLEA // T1 = Double Data Offset
  ldc1 f0,0(t1)      // F0 = Double Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  CVTDLWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,CVTDLWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  CVTDLWAITEND:
    cvt.d.l f0 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,CVTDLWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,88,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,88,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD  // T0 = Word Data Offset
  lw t1,0(t0)      // T1 = Word Data
  la t0,CVTDLCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)      // T2 = Word Check Data
  beq t1,t2,CVTDLPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,88,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CVTDLEND
  nop // Delay Slot
  CVTDLPASS:
  PrintString($A0100000,528,88,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CVTDLEND:

  PrintString($A0100000,8,96,FontRed,CVTDS,6) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEFLOATA // T1 = Float Data Offset
  lwc1 f0,0(t1)     // F0 = Float Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  CVTDSWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,CVTDSWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  CVTDSWAITEND:
    cvt.d.s f0 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,CVTDSWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,96,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,96,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD  // T0 = Word Data Offset
  lw t1,0(t0)      // T1 = Word Data
  la t0,CVTDSCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)      // T2 = Word Check Data
  beq t1,t2,CVTDSPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,96,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CVTDSEND
  nop // Delay Slot
  CVTDSPASS:
  PrintString($A0100000,528,96,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CVTDSEND:

  PrintString($A0100000,8,104,FontRed,CVTDW,6) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEFLOATA // T1 = Float Data Offset
  lwc1 f0,0(t1)     // F0 = Float Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  CVTDWWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,CVTDWWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  CVTDWWAITEND:
    cvt.d.w f0 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,CVTDWWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,104,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,104,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD  // T0 = Word Data Offset
  lw t1,0(t0)      // T1 = Word Data
  la t0,CVTDWCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)      // T2 = Word Check Data
  beq t1,t2,CVTDWPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,104,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CVTDWEND
  nop // Delay Slot
  CVTDWPASS:
  PrintString($A0100000,528,104,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CVTDWEND:

  PrintString($A0100000,8,112,FontRed,CVTLD,6) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEDOUBLEA // T1 = Double Data Offset
  ldc1 f0,0(t1)      // F0 = Double Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  CVTLDWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,CVTLDWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  CVTLDWAITEND:
    cvt.l.d f0 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,CVTLDWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,112,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,112,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD  // T0 = Word Data Offset
  lw t1,0(t0)      // T1 = Word Data
  la t0,CVTLDCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)      // T2 = Word Check Data
  beq t1,t2,CVTLDPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,112,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CVTLDEND
  nop // Delay Slot
  CVTLDPASS:
  PrintString($A0100000,528,112,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CVTLDEND:

  PrintString($A0100000,8,120,FontRed,CVTLS,6) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEFLOATA // T1 = Float Data Offset
  lwc1 f0,0(t1)     // F0 = Float Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  CVTLSWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,CVTLSWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  CVTLSWAITEND:
    cvt.l.s f0 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,CVTLSWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,120,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,120,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD  // T0 = Word Data Offset
  lw t1,0(t0)      // T1 = Word Data
  la t0,CVTLSCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)      // T2 = Word Check Data
  beq t1,t2,CVTLSPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,120,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CVTLSEND
  nop // Delay Slot
  CVTLSPASS:
  PrintString($A0100000,528,120,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CVTLSEND:

  PrintString($A0100000,8,128,FontRed,CVTSD,6) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEDOUBLEA // T1 = Double Data Offset
  ldc1 f0,0(t1)      // F0 = Double Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  CVTSDWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,CVTSDWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  CVTSDWAITEND:
    cvt.s.d f0 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,CVTSDWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,128,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,128,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD  // T0 = Word Data Offset
  lw t1,0(t0)      // T1 = Word Data
  la t0,CVTSDCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)      // T2 = Word Check Data
  beq t1,t2,CVTSDPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,128,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CVTSDEND
  nop // Delay Slot
  CVTSDPASS:
  PrintString($A0100000,528,128,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CVTSDEND:

  PrintString($A0100000,8,136,FontRed,CVTSL,6) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEDOUBLEA // T1 = Double Data Offset
  ldc1 f0,0(t1)      // F0 = Double Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  CVTSLWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,CVTSLWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  CVTSLWAITEND:
    cvt.s.l f0 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,CVTSLWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,136,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,136,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD  // T0 = Word Data Offset
  lw t1,0(t0)      // T1 = Word Data
  la t0,CVTSLCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)      // T2 = Word Check Data
  beq t1,t2,CVTSLPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,136,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CVTSLEND
  nop // Delay Slot
  CVTSLPASS:
  PrintString($A0100000,528,136,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CVTSLEND:

  PrintString($A0100000,8,144,FontRed,CVTSW,6) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEFLOATA // T1 = Float Data Offset
  lwc1 f0,0(t1)     // F0 = Float Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  CVTSWWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,CVTSWWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  CVTSWWAITEND:
    cvt.s.w f0 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,CVTSWWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,144,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,144,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD  // T0 = Word Data Offset
  lw t1,0(t0)      // T1 = Word Data
  la t0,CVTSWCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)      // T2 = Word Check Data
  beq t1,t2,CVTSWPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,144,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CVTSWEND
  nop // Delay Slot
  CVTSWPASS:
  PrintString($A0100000,528,144,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CVTSWEND:

  PrintString($A0100000,8,152,FontRed,CVTWD,6) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEDOUBLEA // T1 = Double Data Offset
  ldc1 f0,0(t1)      // F0 = Double Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  CVTWDWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,CVTWDWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  CVTWDWAITEND:
    cvt.w.d f0 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,CVTWDWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,152,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,152,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD  // T0 = Word Data Offset
  lw t1,0(t0)      // T1 = Word Data
  la t0,CVTWDCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)      // T2 = Word Check Data
  beq t1,t2,CVTWDPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,152,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CVTWDEND
  nop // Delay Slot
  CVTWDPASS:
  PrintString($A0100000,528,152,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CVTWDEND:

  PrintString($A0100000,8,160,FontRed,CVTWS,6) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEFLOATA // T1 = Float Data Offset
  lwc1 f0,0(t1)     // F0 = Float Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  CVTWSWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,CVTWSWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  CVTWSWAITEND:
    cvt.w.s f0 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,CVTWSWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,160,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,160,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD  // T0 = Word Data Offset
  lw t1,0(t0)      // T1 = Word Data
  la t0,CVTWSCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)      // T2 = Word Check Data
  beq t1,t2,CVTWSPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,160,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CVTWSEND
  nop // Delay Slot
  CVTWSPASS:
  PrintString($A0100000,528,160,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CVTWSEND:

  PrintString($A0100000,8,168,FontRed,DIVD,4) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEDOUBLEA // T1 = Double Data Offset
  ldc1 f0,0(t1)      // F0 = Double Data
  la t1,VALUEDOUBLEB // T1 = Double Data Offset
  ldc1 f1,0(t1)      // F1 = Double Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  DIVDWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,DIVDWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  DIVDWAITEND:
    div.d f0,f1 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,DIVDWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,168,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,168,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD // T0 = Word Data Offset
  lw t1,0(t0)     // T1 = Word Data
  la t0,DIVDCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)     // T2 = Word Check Data
  beq t1,t2,DIVDPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,168,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DIVDEND
  nop // Delay Slot
  DIVDPASS:
  PrintString($A0100000,528,168,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DIVDEND:

  PrintString($A0100000,8,176,FontRed,DIVS,4) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEFLOATA // T1 = Float Data Offset
  lwc1 f0,0(t1)     // F0 = Float Data
  la t1,VALUEFLOATB // T1 = Float Data Offset
  lwc1 f1,0(t1)     // F1 = Float Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  DIVSWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,DIVSWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  DIVSWAITEND:
    div.s f0,f1 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,DIVSWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,176,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,176,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD // T0 = Word Data Offset
  lw t1,0(t0)     // T1 = Word Data
  la t0,DIVSCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)     // T2 = Word Check Data
  beq t1,t2,DIVSPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,176,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DIVSEND
  nop // Delay Slot
  DIVSPASS:
  PrintString($A0100000,528,176,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DIVSEND:

  PrintString($A0100000,8,184,FontRed,FLOORLD,8) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEDOUBLEA // T1 = Double Data Offset
  ldc1 f0,0(t1)      // F0 = Double Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  FLOORLDWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,FLOORLDWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  FLOORLDWAITEND:
    floor.l.d f0 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,FLOORLDWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,184,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,184,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD    // T0 = Word Data Offset
  lw t1,0(t0)        // T1 = Word Data
  la t0,FLOORLDCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)        // T2 = Word Check Data
  beq t1,t2,FLOORLDPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,184,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j FLOORLDEND
  nop // Delay Slot
  FLOORLDPASS:
  PrintString($A0100000,528,184,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  FLOORLDEND:

  PrintString($A0100000,8,192,FontRed,FLOORLS,8) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEFLOATA // T1 = Float Data Offset
  lwc1 f0,0(t1)     // F0 = Float Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  FLOORLSWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,FLOORLSWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  FLOORLSWAITEND:
    floor.l.s f0 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,FLOORLSWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,192,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,192,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD    // T0 = Word Data Offset
  lw t1,0(t0)        // T1 = Word Data
  la t0,FLOORLSCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)        // T2 = Word Check Data
  beq t1,t2,FLOORLSPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,192,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j FLOORLSEND
  nop // Delay Slot
  FLOORLSPASS:
  PrintString($A0100000,528,192,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  FLOORLSEND:

  PrintString($A0100000,8,200,FontRed,FLOORWD,8) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEDOUBLEA // T1 = Double Data Offset
  ldc1 f0,0(t1)      // F0 = Double Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  FLOORWDWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,FLOORWDWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  FLOORWDWAITEND:
    floor.w.d f0 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,FLOORWDWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,200,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,200,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD    // T0 = Word Data Offset
  lw t1,0(t0)        // T1 = Word Data
  la t0,FLOORWDCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)        // T2 = Word Check Data
  beq t1,t2,FLOORWDPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,200,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j FLOORWDEND
  nop // Delay Slot
  FLOORWDPASS:
  PrintString($A0100000,528,200,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  FLOORWDEND:

  PrintString($A0100000,8,208,FontRed,FLOORWS,8) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEFLOATA // T1 = Float Data Offset
  lwc1 f0,0(t1)     // F0 = Float Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  FLOORWSWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,FLOORWSWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  FLOORWSWAITEND:
    floor.w.s f0 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,FLOORWSWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,208,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,208,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD    // T0 = Word Data Offset
  lw t1,0(t0)        // T1 = Word Data
  la t0,FLOORWSCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)        // T2 = Word Check Data
  beq t1,t2,FLOORWSPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,208,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j FLOORWSEND
  nop // Delay Slot
  FLOORWSPASS:
  PrintString($A0100000,528,208,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  FLOORWSEND:

  PrintString($A0100000,8,216,FontRed,MULD,4) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEDOUBLEA // T1 = Double Data Offset
  ldc1 f0,0(t1)      // F0 = Double Data
  la t1,VALUEDOUBLEB // T1 = Double Data Offset
  ldc1 f1,0(t1)      // F1 = Double Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  MULDWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,MULDWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  MULDWAITEND:
    mul.d f0,f1 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,MULDWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,216,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,216,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD // T0 = Word Data Offset
  lw t1,0(t0)     // T1 = Word Data
  la t0,MULDCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)     // T2 = Word Check Data
  beq t1,t2,MULDPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,216,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j MULDEND
  nop // Delay Slot
  MULDPASS:
  PrintString($A0100000,528,216,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  MULDEND:

  PrintString($A0100000,8,224,FontRed,MULS,4) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEFLOATA // T1 = Float Data Offset
  lwc1 f0,0(t1)     // F0 = Float Data
  la t1,VALUEFLOATB // T1 = Float Data Offset
  lwc1 f1,0(t1)     // F1 = Float Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  MULSWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,MULSWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  MULSWAITEND:
    mul.s f0,f1 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,MULSWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,224,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,224,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD // T0 = Word Data Offset
  lw t1,0(t0)     // T1 = Word Data
  la t0,MULSCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)     // T2 = Word Check Data
  beq t1,t2,MULSPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,224,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j MULSEND
  nop // Delay Slot
  MULSPASS:
  PrintString($A0100000,528,224,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  MULSEND:

  PrintString($A0100000,8,232,FontRed,NEGD,4) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEDOUBLEA // T1 = Double Data Offset
  ldc1 f0,0(t1)      // F0 = Double Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  NEGDWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,NEGDWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  NEGDWAITEND:
    neg.d f0 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,NEGDWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,232,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,232,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD // T0 = Word Data Offset
  lw t1,0(t0)     // T1 = Word Data
  la t0,NEGDCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)     // T2 = Word Check Data
  beq t1,t2,NEGDPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,232,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j NEGDEND
  nop // Delay Slot
  NEGDPASS:
  PrintString($A0100000,528,232,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  NEGDEND:

  PrintString($A0100000,8,240,FontRed,NEGS,4) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEFLOATA // T1 = Float Data Offset
  lwc1 f0,0(t1)     // F0 = Float Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  NEGSWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,NEGSWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  NEGSWAITEND:
    neg.s f0 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,NEGSWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,240,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,240,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD // T0 = Word Data Offset
  lw t1,0(t0)     // T1 = Word Data
  la t0,NEGSCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)     // T2 = Word Check Data
  beq t1,t2,NEGSPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,240,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j NEGSEND
  nop // Delay Slot
  NEGSPASS:
  PrintString($A0100000,528,240,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  NEGSEND:

  PrintString($A0100000,8,248,FontRed,ROUNDLD,8) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEDOUBLEA // T1 = Double Data Offset
  ldc1 f0,0(t1)      // F0 = Double Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  ROUNDLDWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,ROUNDLDWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  ROUNDLDWAITEND:
    round.l.d f0 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,ROUNDLDWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,248,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,248,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD    // T0 = Word Data Offset
  lw t1,0(t0)        // T1 = Word Data
  la t0,ROUNDLDCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)        // T2 = Word Check Data
  beq t1,t2,ROUNDLDPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,248,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j ROUNDLDEND
  nop // Delay Slot
  ROUNDLDPASS:
  PrintString($A0100000,528,248,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  ROUNDLDEND:

  PrintString($A0100000,8,256,FontRed,ROUNDLS,8) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEFLOATA // T1 = Float Data Offset
  lwc1 f0,0(t1)     // F0 = Float Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  ROUNDLSWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,ROUNDLSWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  ROUNDLSWAITEND:
    round.l.s f0 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,ROUNDLSWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,256,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,256,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD    // T0 = Word Data Offset
  lw t1,0(t0)        // T1 = Word Data
  la t0,ROUNDLSCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)        // T2 = Word Check Data
  beq t1,t2,ROUNDLSPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,256,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j ROUNDLSEND
  nop // Delay Slot
  ROUNDLSPASS:
  PrintString($A0100000,528,256,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  ROUNDLSEND:

  PrintString($A0100000,8,264,FontRed,ROUNDWD,8) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEDOUBLEA // T1 = Double Data Offset
  ldc1 f0,0(t1)      // F0 = Double Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  ROUNDWDWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,ROUNDWDWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  ROUNDWDWAITEND:
    round.w.d f0 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,ROUNDWDWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,264,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,264,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD    // T0 = Word Data Offset
  lw t1,0(t0)        // T1 = Word Data
  la t0,ROUNDWDCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)        // T2 = Word Check Data
  beq t1,t2,ROUNDWDPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,264,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j ROUNDWDEND
  nop // Delay Slot
  ROUNDWDPASS:
  PrintString($A0100000,528,264,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  ROUNDWDEND:

  PrintString($A0100000,8,272,FontRed,ROUNDWS,8) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEFLOATA // T1 = Float Data Offset
  lwc1 f0,0(t1)     // F0 = Float Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  ROUNDWSWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,ROUNDWSWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  ROUNDWSWAITEND:
    round.w.s f0 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,ROUNDWSWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,272,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,272,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD    // T0 = Word Data Offset
  lw t1,0(t0)        // T1 = Word Data
  la t0,ROUNDWSCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)        // T2 = Word Check Data
  beq t1,t2,ROUNDWSPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,272,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j ROUNDWSEND
  nop // Delay Slot
  ROUNDWSPASS:
  PrintString($A0100000,528,272,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  ROUNDWSEND:

  PrintString($A0100000,8,280,FontRed,SQRTD,5) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEDOUBLEA // T1 = Double Data Offset
  ldc1 f0,0(t1)      // F0 = Double Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  SQRTDWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,SQRTDWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  SQRTDWAITEND:
    sqrt.d f0 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,SQRTDWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,280,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,280,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD  // T0 = Word Data Offset
  lw t1,0(t0)      // T1 = Word Data
  la t0,SQRTDCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)      // T2 = Word Check Data
  beq t1,t2,SQRTDPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,280,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SQRTDEND
  nop // Delay Slot
  SQRTDPASS:
  PrintString($A0100000,528,280,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SQRTDEND:

  PrintString($A0100000,8,288,FontRed,SQRTS,5) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEFLOATA // T1 = Float Data Offset
  lwc1 f0,0(t1)     // F0 = Float Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  SQRTSWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,SQRTSWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  SQRTSWAITEND:
    sqrt.s f0 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,SQRTSWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,288,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,288,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD  // T0 = Word Data Offset
  lw t1,0(t0)      // T1 = Word Data
  la t0,SQRTSCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)      // T2 = Word Check Data
  beq t1,t2,SQRTSPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,288,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SQRTSEND
  nop // Delay Slot
  SQRTSPASS:
  PrintString($A0100000,528,288,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SQRTSEND:

  PrintString($A0100000,8,296,FontRed,SUBD,4) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEDOUBLEA // T1 = Double Data Offset
  ldc1 f0,0(t1)      // F0 = Double Data
  la t1,VALUEDOUBLEB // T1 = Double Data Offset
  ldc1 f1,0(t1)      // F1 = Double Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  SUBDWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,SUBDWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  SUBDWAITEND:
    sub.d f0,f1 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,SUBDWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,296,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,296,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD // T0 = Word Data Offset
  lw t1,0(t0)     // T1 = Word Data
  la t0,SUBDCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)     // T2 = Word Check Data
  beq t1,t2,SUBDPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,296,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SUBDEND
  nop // Delay Slot
  SUBDPASS:
  PrintString($A0100000,528,296,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SUBDEND:

  PrintString($A0100000,8,304,FontRed,SUBS,4) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEFLOATA // T1 = Float Data Offset
  lwc1 f0,0(t1)     // F0 = Float Data
  la t1,VALUEFLOATB // T1 = Float Data Offset
  lwc1 f1,0(t1)     // F1 = Float Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  SUBSWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,SUBSWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  SUBSWAITEND:
    sub.s f0,f1 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,SUBSWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,304,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,304,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD // T0 = Word Data Offset
  lw t1,0(t0)     // T1 = Word Data
  la t0,SUBSCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)     // T2 = Word Check Data
  beq t1,t2,SUBSPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,304,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j SUBSEND
  nop // Delay Slot
  SUBSPASS:
  PrintString($A0100000,528,304,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  SUBSEND:

  PrintString($A0100000,8,312,FontRed,TRUNCLD,8) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEDOUBLEA // T1 = Double Data Offset
  ldc1 f0,0(t1)      // F0 = Double Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  TRUNCLDWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,TRUNCLDWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  TRUNCLDWAITEND:
    trunc.l.d f0 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,TRUNCLDWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,312,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,312,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD    // T0 = Word Data Offset
  lw t1,0(t0)        // T1 = Word Data
  la t0,TRUNCLDCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)        // T2 = Word Check Data
  beq t1,t2,TRUNCLDPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,312,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j TRUNCLDEND
  nop // Delay Slot
  TRUNCLDPASS:
  PrintString($A0100000,528,312,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  TRUNCLDEND:

  PrintString($A0100000,8,320,FontRed,TRUNCLS,8) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEFLOATA // T1 = Float Data Offset
  lwc1 f0,0(t1)     // F0 = Float Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  TRUNCLSWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,TRUNCLSWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  TRUNCLSWAITEND:
    trunc.l.s f0 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,TRUNCLSWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,320,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,320,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD    // T0 = Word Data Offset
  lw t1,0(t0)        // T1 = Word Data
  la t0,TRUNCLSCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)        // T2 = Word Check Data
  beq t1,t2,TRUNCLSPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,320,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j TRUNCLSEND
  nop // Delay Slot
  TRUNCLSPASS:
  PrintString($A0100000,528,320,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  TRUNCLSEND:

  PrintString($A0100000,8,328,FontRed,TRUNCWD,8) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEDOUBLEA // T1 = Double Data Offset
  ldc1 f0,0(t1)      // F0 = Double Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  TRUNCWDWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,TRUNCWDWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  TRUNCWDWAITEND:
    trunc.w.d f0 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,TRUNCWDWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,328,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,328,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD    // T0 = Word Data Offset
  lw t1,0(t0)        // T1 = Word Data
  la t0,TRUNCWDCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)        // T2 = Word Check Data
  beq t1,t2,TRUNCWDPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,328,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j TRUNCWDEND
  nop // Delay Slot
  TRUNCWDPASS:
  PrintString($A0100000,528,328,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  TRUNCWDEND:

  PrintString($A0100000,8,336,FontRed,TRUNCWS,8) // Print Text String To VRAM Using Font At X,Y Position
  lli t0,0 // T0 = Instruction Count
  la t1,VALUEFLOATA // T1 = Float Data Offset
  lwc1 f0,0(t1)     // F0 = Float Data
  lui t3,VI_BASE
  lli t4,0
  lli t5,$200
  TRUNCWSWAITSTART:
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t4,TRUNCWSWAITSTART // Wait For Scanline To Reach Start Of Vertical Blank
    nop // Delay Slot
  TRUNCWSWAITEND:
    trunc.w.s f0 // Test Instruction
    lw t6,VI_V_CURRENT_LINE(t3) // T6 = Current Scan Line
    sync // Sync Load
    bne t6,t5,TRUNCWSWAITEND // Wait For Scanline To Reach End Of Vertical Blank
    addiu t0,1 // T0 = Instruction Count Word Data (Delay Slot)
  la t1,COUNTWORD // T1 = COUNTWORD Offset
  sw t0,0(t1) // COUNTWORD = Word Data
  PrintString($A0100000,440,336,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,448,336,FontBlack,COUNTWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  la t0,COUNTWORD    // T0 = Word Data Offset
  lw t1,0(t0)        // T1 = Word Data
  la t0,TRUNCWSCOUNT // T0 = Word Check Data Offset
  lw t2,0(t0)        // T2 = Word Check Data
  beq t1,t2,TRUNCWSPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,336,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j TRUNCWSEND
  nop // Delay Slot
  TRUNCWSPASS:
  PrintString($A0100000,528,336,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  TRUNCWSEND:


  PrintString($A0100000,0,344,FontBlack,PAGEBREAK,79) // Print Text String To VRAM Using Font At X,Y Position


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

ABSD:
  db "ABS.D"
ABSS:
  db "ABS.S"
ADDD:
  db "ADD.D"
ADDS:
  db "ADD.S"
CEILLD:
  db "CEIL.L.D"
CEILLS:
  db "CEIL.L.S"
CEILWD:
  db "CEIL.W.D"
CEILWS:
  db "CEIL.W.S"
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
DIVD:
  db "DIV.D"
DIVS:
  db "DIV.S"
FLOORLD:
  db "FLOOR.L.D"
FLOORLS:
  db "FLOOR.L.S"
FLOORWD:
  db "FLOOR.W.D"
FLOORWS:
  db "FLOOR.W.S"
MULD:
  db "MUL.D"
MULS:
  db "MUL.S"
NEGD:
  db "NEG.D"
NEGS:
  db "NEG.S"
ROUNDLD:
  db "ROUND.L.D"
ROUNDLS:
  db "ROUND.L.S"
ROUNDWD:
  db "ROUND.W.D"
ROUNDWS:
  db "ROUND.W.S"
SQRTD:
  db "SQRT.D"
SQRTS:
  db "SQRT.S"
SUBD:
  db "SUB.D"
SUBS:
  db "SUB.S"
TRUNCLD:
  db "TRUNC.L.D"
TRUNCLS:
  db "TRUNC.L.S"
TRUNCWD:
  db "TRUNC.W.D"
TRUNCWS:
  db "TRUNC.W.S"

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
VALUEDOUBLEA:
  float64 0.0
VALUEDOUBLEB:
  float64 1.0

VALUEFLOATA:
  float32 0.0
VALUEFLOATB:
  float32 1.0

ABSDCOUNT:
  dd $0000DB1F
ABSSCOUNT:
  dd $0000DB1C
ADDDCOUNT:
  dd $0000CFB7
ADDSCOUNT:
  dd $0000CFB5
CEILLDCOUNT:
  dd $0000C341
CEILLSCOUNT:
  dd $0000C344
CEILWDCOUNT:
  dd $0000C340
CEILWSCOUNT:
  dd $0000C341
CVTDLCOUNT:
  dd $0000DABB
CVTDSCOUNT:
  dd $0000DB1F
CVTDWCOUNT:
  dd $0000DABA
CVTLDCOUNT:
  dd $0000C341
CVTLSCOUNT:
  dd $0000C341
CVTSDCOUNT:
  dd $0000DABD
CVTSLCOUNT:
  dd $0000DAB7
CVTSWCOUNT:
  dd $0000DABB
CVTWDCOUNT:
  dd $0000C342
CVTWSCOUNT:
  dd $0000C344
DIVDCOUNT:
  dd $0000DABA
DIVSCOUNT:
  dd $0000DAB9
FLOORLDCOUNT:
  dd $0000C344
FLOORLSCOUNT:
  dd $0000C341
FLOORWDCOUNT:
  dd $0000C341
FLOORWSCOUNT:
  dd $0000C342
MULDCOUNT:
  dd $0000DABA
MULSCOUNT:
  dd $0000DAB9
NEGDCOUNT:
  dd $0000DB1C
NEGSCOUNT:
  dd $0000DB1F
ROUNDLDCOUNT:
  dd $0000C340
ROUNDLSCOUNT:
  dd $0000C341
ROUNDWDCOUNT:
  dd $0000C341
ROUNDWSCOUNT:
  dd $0000C344
SQRTDCOUNT:
  dd $0000DABB
SQRTSCOUNT:
  dd $0000DABB
SUBDCOUNT:
  dd $0000CFB4
SUBSCOUNT:
  dd $0000CFB5
TRUNCLDCOUNT:
  dd $0000C341
TRUNCLSCOUNT:
  dd $0000C342
TRUNCWDCOUNT:
  dd $0000C344
TRUNCWSCOUNT:
  dd $0000C341

COUNTWORD:
  dd 0

insert FontBlack, "FontBlack8x8.bin"
insert FontGreen, "FontGreen8x8.bin"
insert FontRed, "FontRed8x8.bin"