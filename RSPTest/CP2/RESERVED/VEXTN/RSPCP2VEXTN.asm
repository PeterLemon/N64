// N64 'Bare Metal' RSP CP2 Vector Nibble (4/4/4/4) (Sign Extended) Test Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "RSPCP2VEXTN.N64", create
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
  include "LIB/N64_RSP.INC" // Include RSP Macros
  N64_INIT() // Run N64 Initialisation Routine

  ScreenNTSC(640, 480, BPP32|INTERLACE|AA_MODE_2, $A0100000) // Screen NTSC: 640x480, 32BPP, Interlace, Resample Only, DRAM Origin = $A0100000

  lui a0,$A010 // A0 = VRAM Start Offset
  la a1,$A0100000+((SCREEN_X*SCREEN_Y*BYTES_PER_PIXEL)-BYTES_PER_PIXEL) // A1 = VRAM End Offset
  lli t0,$000000FF // T0 = Black
ClearScreen:
  sw t0,0(a0)
  bne a0,a1,ClearScreen
  addi a0,4 // Delay Slot


  PrintString($A0100000,56,8,FontRed,VSVTHEX,10) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,200,8,FontRed,VAVDHEX,10) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,552,8,FontRed,TEST,10) // Print Text String To VRAM Using Font At X,Y Position


  PrintString($A0100000,0,16,FontBlack,PAGEBREAK,79) // Print Text String To VRAM Using Font At X,Y Position


  // Load RSP Code To IMEM
  DMASPRD(RSPVEXTNCode, RSPVEXTNCodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  // Load RSP Data To DMEM
  DMASPRD(VALUEQUADA, VALUEQUADAEnd, SP_DMEM)    // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPRD(VALUEQUADB, VALUEQUADBEnd, SP_DMEM+16) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  // Set RSP Program Counter
  lui a0,SP_PC_BASE // A0 = SP PC Base Register ($A4080000)
  lli t0,$0000 // T0 = RSP Program Counter Set To Zero (Start Of RSP Code)
  sw t0,SP_PC(a0) // Store RSP Program Counter To SP PC Register ($A4080000)

  // Set RSP Status (Start Execution)
  lui a0,SP_BASE // A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB // T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) // Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString($A0100000,0,24,FontRed,VEXTNTEXT,4) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,48,24,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,56,24,FontBlack,VALUEQUADA,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,48,32,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,56,32,FontBlack,VALUEQUADA+8,7) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,48,48,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,56,48,FontBlack,VALUEQUADB,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,48,56,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,56,56,FontBlack,VALUEQUADB+8,7) // Print HEX Chars To VRAM Using Font At X,Y Position

  // Store RSP Data To MEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VDQUAD // A1 = Quad Data Offset
  lw t0,0(a0)  // T0 = Quad Data
  sw t0,0(a1)  // Store Quad Data To MEM
  lw t0,4(a0)  // T0 = Quad Data
  sw t0,4(a1)  // Store Quad Data To MEM
  lw t0,8(a0)  // T0 = Quad Data
  sw t0,8(a1)  // Store Quad Data To MEM
  lw t0,12(a0) // T0 = Quad Data
  sw t0,12(a1) // Store Quad Data To MEM

  la a1,VAQUAD // A1 = Quad Data Offset
  lw t0,16(a0) // T0 = Quad Data
  sw t0,0(a1)  // Store Quad Data To MEM
  lw t0,20(a0) // T0 = Quad Data
  sw t0,4(a1)  // Store Quad Data To MEM
  lw t0,24(a0) // T0 = Quad Data
  sw t0,8(a1)  // Store Quad Data To MEM
  lw t0,28(a0) // T0 = Quad Data
  sw t0,12(a1) // Store Quad Data To MEM

  lw t0,32(a0) // T0 = Quad Data
  sw t0,16(a1) // Store Quad Data To MEM
  lw t0,36(a0) // T0 = Quad Data
  sw t0,20(a1) // Store Quad Data To MEM
  lw t0,40(a0) // T0 = Quad Data
  sw t0,24(a1) // Store Quad Data To MEM
  lw t0,44(a0) // T0 = Quad Data
  sw t0,28(a1) // Store Quad Data To MEM

  lw t0,48(a0) // T0 = Quad Data
  sw t0,32(a1) // Store Quad Data To MEM
  lw t0,52(a0) // T0 = Quad Data
  sw t0,36(a1) // Store Quad Data To MEM
  lw t0,56(a0) // T0 = Quad Data
  sw t0,40(a1) // Store Quad Data To MEM
  lw t0,60(a0) // T0 = Quad Data
  sw t0,44(a1) // Store Quad Data To MEM

  la a1,VCOVCCWORD // A1 = Word Data Offset
  lw t0,64(a0) // T0 = Word Data
  sw t0,0(a1)  // Store Word Data To MEM

  la a1,VCEBYTE // A1 = Byte Data Offset
  lb t0,68(a0) // T0 = Byte Data
  sb t0,0(a1)  // Store Byte Data To MEM

  PrintString($A0100000,192,24,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,200,24,FontBlack,VAQUAD,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,240,24,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,248,24,FontBlack,VAQUAD+2,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,24,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,296,24,FontBlack,VAQUAD+4,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,336,24,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,344,24,FontBlack,VAQUAD+6,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,384,24,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,392,24,FontBlack,VAQUAD+8,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,432,24,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,440,24,FontBlack,VAQUAD+10,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,480,24,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,488,24,FontBlack,VAQUAD+12,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,528,24,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,536,24,FontBlack,VAQUAD+14,1) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,192,32,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,200,32,FontBlack,VAQUAD+16,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,240,32,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,248,32,FontBlack,VAQUAD+18,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,32,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,296,32,FontBlack,VAQUAD+20,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,336,32,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,344,32,FontBlack,VAQUAD+22,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,384,32,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,392,32,FontBlack,VAQUAD+24,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,432,32,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,440,32,FontBlack,VAQUAD+26,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,480,32,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,488,32,FontBlack,VAQUAD+28,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,528,32,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,536,32,FontBlack,VAQUAD+30,1) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,192,40,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,200,40,FontBlack,VAQUAD+32,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,240,40,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,248,40,FontBlack,VAQUAD+34,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,40,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,296,40,FontBlack,VAQUAD+36,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,336,40,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,344,40,FontBlack,VAQUAD+38,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,384,40,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,392,40,FontBlack,VAQUAD+40,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,432,40,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,440,40,FontBlack,VAQUAD+42,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,480,40,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,488,40,FontBlack,VAQUAD+44,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,528,40,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,536,40,FontBlack,VAQUAD+46,1) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,192,56,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,200,56,FontBlack,VDQUAD,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,240,56,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,248,56,FontBlack,VDQUAD+2,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,56,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,296,56,FontBlack,VDQUAD+4,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,336,56,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,344,56,FontBlack,VDQUAD+6,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,384,56,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,392,56,FontBlack,VDQUAD+8,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,432,56,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,440,56,FontBlack,VDQUAD+10,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,480,56,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,488,56,FontBlack,VDQUAD+12,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,528,56,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,536,56,FontBlack,VDQUAD+14,1) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,576,24,FontGreen,VCOHEX,2) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,600,24,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,608,24,FontBlack,VCOVCCWORD,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,576,32,FontGreen,VCCHEX,2) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,600,32,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,608,32,FontBlack,VCOVCCWORD+2,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,576,40,FontGreen,VCEHEX,2) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,600,40,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,608,40,FontBlack,VCEBYTE,0) // Print HEX Chars To VRAM Using Font At X,Y Position

  la a0,VDQUAD        // A0 = Quad Data Offset
  ld t0,0(a0)         // T0 = Quad Data
  la a0,VEXTNVDCHECKA // A0 = Quad Check Data Offset
  ld t1,0(a0)         // T1 = Quad Check Data
  bne t0,t1,VEXTNFAILA // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,VDQUAD        // A0 = Quad Data Offset
  ld t0,8(a0)         // T0 = Quad Data
  la a0,VEXTNVDCHECKA // A0 = Quad Check Data Offset
  ld t1,8(a0)         // T1 = Quad Check Data
  bne t0,t1,VEXTNFAILA // Compare Result Equality With Check Data
  nop // Delay Slot

  la a0,VAQUAD        // A0 = Quad Data Offset
  ld t0,0(a0)         // T0 = Quad Data
  la a0,VEXTNVACHECKA // A0 = Quad Check Data Offset
  ld t1,0(a0)         // T1 = Quad Check Data
  bne t0,t1,VEXTNFAILA // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,VAQUAD        // A0 = Quad Data Offset
  ld t0,8(a0)         // T0 = Quad Data
  la a0,VEXTNVACHECKA // A0 = Quad Check Data Offset
  ld t1,8(a0)         // T1 = Quad Check Data
  bne t0,t1,VEXTNFAILA // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,VAQUAD        // A0 = Quad Data Offset
  ld t0,16(a0)        // T0 = Quad Data
  la a0,VEXTNVACHECKA // A0 = Quad Check Data Offset
  ld t1,16(a0)        // T1 = Quad Check Data
  bne t0,t1,VEXTNFAILA // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,VAQUAD        // A0 = Quad Data Offset
  ld t0,24(a0)        // T0 = Quad Data
  la a0,VEXTNVACHECKA // A0 = Quad Check Data Offset
  ld t1,24(a0)        // T1 = Quad Check Data
  bne t0,t1,VEXTNFAILA // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,VAQUAD        // A0 = Quad Data Offset
  ld t0,32(a0)        // T0 = Quad Data
  la a0,VEXTNVACHECKA // A0 = Quad Check Data Offset
  ld t1,32(a0)        // T1 = Quad Check Data
  bne t0,t1,VEXTNFAILA // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,VAQUAD        // A0 = Quad Data Offset
  ld t0,40(a0)        // T0 = Quad Data
  la a0,VEXTNVACHECKA // A0 = Quad Check Data Offset
  ld t1,40(a0)        // T1 = Quad Check Data
  bne t0,t1,VEXTNFAILA // Compare Result Equality With Check Data
  nop // Delay Slot

  la a0,VCOVCCWORD        // A0 = Word Data Offset
  lw t0,0(a0)             // T0 = Word Data
  la a0,VEXTNVCOVCCCHECKA // A0 = Word Check Data Offset
  lw t1,0(a0)             // T1 = Word Check Data
  bne t0,t1,VEXTNFAILA // Compare Result Equality With Check Data

  la a0,VCEBYTE        // A0 = Byte Data Offset
  lb t0,0(a0)          // T0 = Byte Data
  la a0,VEXTNVCECHECKA // A0 = Byte Check Data Offset
  lb t1,0(a0)          // T1 = Byte Check Data
  bne t0,t1,VEXTNFAILA // Compare Result Equality With Check Data

  PrintString($A0100000,576,56,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  j VEXTNENDA
  nop // Delay Slot
  VEXTNFAILA:
  PrintString($A0100000,576,56,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  VEXTNENDA:

  PrintString($A0100000,0,64,FontBlack,PAGEBREAK,79) // Print Text String To VRAM Using Font At X,Y Position


  // Load RSP Data To MEM
  DMASPRD(VALUEQUADB, VALUEQUADBEnd, SP_DMEM)    // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPRD(VALUEQUADB, VALUEQUADBEnd, SP_DMEM+16) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  // Set RSP Status (Start Execution)
  lui a0,SP_BASE // A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB // T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) // Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString($A0100000,48,72,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,56,72,FontBlack,VALUEQUADB,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,48,80,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,56,80,FontBlack,VALUEQUADB+8,7) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,48,96,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,56,96,FontBlack,VALUEQUADB,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,48,104,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,56,104,FontBlack,VALUEQUADB+8,7) // Print HEX Chars To VRAM Using Font At X,Y Position

  // Store RSP Data To MEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VDQUAD // A1 = Quad Data Offset
  lw t0,0(a0)  // T0 = Quad Data
  sw t0,0(a1)  // Store Quad Data To MEM
  lw t0,4(a0)  // T0 = Quad Data
  sw t0,4(a1)  // Store Quad Data To MEM
  lw t0,8(a0)  // T0 = Quad Data
  sw t0,8(a1)  // Store Quad Data To MEM
  lw t0,12(a0) // T0 = Quad Data
  sw t0,12(a1) // Store Quad Data To MEM

  la a1,VAQUAD // A1 = Quad Data Offset
  lw t0,16(a0) // T0 = Quad Data
  sw t0,0(a1)  // Store Quad Data To MEM
  lw t0,20(a0) // T0 = Quad Data
  sw t0,4(a1)  // Store Quad Data To MEM
  lw t0,24(a0) // T0 = Quad Data
  sw t0,8(a1)  // Store Quad Data To MEM
  lw t0,28(a0) // T0 = Quad Data
  sw t0,12(a1) // Store Quad Data To MEM

  lw t0,32(a0) // T0 = Quad Data
  sw t0,16(a1) // Store Quad Data To MEM
  lw t0,36(a0) // T0 = Quad Data
  sw t0,20(a1) // Store Quad Data To MEM
  lw t0,40(a0) // T0 = Quad Data
  sw t0,24(a1) // Store Quad Data To MEM
  lw t0,44(a0) // T0 = Quad Data
  sw t0,28(a1) // Store Quad Data To MEM

  lw t0,48(a0) // T0 = Quad Data
  sw t0,32(a1) // Store Quad Data To MEM
  lw t0,52(a0) // T0 = Quad Data
  sw t0,36(a1) // Store Quad Data To MEM
  lw t0,56(a0) // T0 = Quad Data
  sw t0,40(a1) // Store Quad Data To MEM
  lw t0,60(a0) // T0 = Quad Data
  sw t0,44(a1) // Store Quad Data To MEM

  la a1,VCOVCCWORD // A1 = Word Data Offset
  lw t0,64(a0) // T0 = Word Data
  sw t0,0(a1)  // Store Word Data To MEM

  la a1,VCEBYTE // A1 = Byte Data Offset
  lb t0,68(a0) // T0 = Byte Data
  sb t0,0(a1)  // Store Byte Data To MEM

  PrintString($A0100000,192,72,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,200,72,FontBlack,VAQUAD,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,240,72,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,248,72,FontBlack,VAQUAD+2,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,72,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,296,72,FontBlack,VAQUAD+4,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,336,72,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,344,72,FontBlack,VAQUAD+6,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,384,72,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,392,72,FontBlack,VAQUAD+8,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,432,72,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,440,72,FontBlack,VAQUAD+10,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,480,72,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,488,72,FontBlack,VAQUAD+12,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,528,72,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,536,72,FontBlack,VAQUAD+14,1) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,192,80,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,200,80,FontBlack,VAQUAD+16,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,240,80,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,248,80,FontBlack,VAQUAD+18,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,80,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,296,80,FontBlack,VAQUAD+20,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,336,80,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,344,80,FontBlack,VAQUAD+22,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,384,80,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,392,80,FontBlack,VAQUAD+24,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,432,80,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,440,80,FontBlack,VAQUAD+26,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,480,80,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,488,80,FontBlack,VAQUAD+28,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,528,80,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,536,80,FontBlack,VAQUAD+30,1) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,192,88,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,200,88,FontBlack,VAQUAD+32,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,240,88,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,248,88,FontBlack,VAQUAD+34,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,88,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,296,88,FontBlack,VAQUAD+36,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,336,88,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,344,88,FontBlack,VAQUAD+38,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,384,88,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,392,88,FontBlack,VAQUAD+40,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,432,88,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,440,88,FontBlack,VAQUAD+42,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,480,88,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,488,88,FontBlack,VAQUAD+44,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,528,88,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,536,88,FontBlack,VAQUAD+46,1) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,192,104,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,200,104,FontBlack,VDQUAD,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,240,104,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,248,104,FontBlack,VDQUAD+2,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,104,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,296,104,FontBlack,VDQUAD+4,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,336,104,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,344,104,FontBlack,VDQUAD+6,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,384,104,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,392,104,FontBlack,VDQUAD+8,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,432,104,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,440,104,FontBlack,VDQUAD+10,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,480,104,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,488,104,FontBlack,VDQUAD+12,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,528,104,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,536,104,FontBlack,VDQUAD+14,1) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,576,72,FontGreen,VCOHEX,2) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,600,72,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,608,72,FontBlack,VCOVCCWORD,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,576,80,FontGreen,VCCHEX,2) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,600,80,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,608,80,FontBlack,VCOVCCWORD+2,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,576,88,FontGreen,VCEHEX,2) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,600,88,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,608,88,FontBlack,VCEBYTE,0) // Print HEX Chars To VRAM Using Font At X,Y Position

  la a0,VDQUAD        // A0 = Quad Data Offset
  ld t0,0(a0)         // T0 = Quad Data
  la a0,VEXTNVDCHECKB // A0 = Quad Check Data Offset
  ld t1,0(a0)         // T1 = Quad Check Data
  bne t0,t1,VEXTNFAILB // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,VDQUAD        // A0 = Quad Data Offset
  ld t0,8(a0)         // T0 = Quad Data
  la a0,VEXTNVDCHECKB // A0 = Quad Check Data Offset
  ld t1,8(a0)         // T1 = Quad Check Data
  bne t0,t1,VEXTNFAILB // Compare Result Equality With Check Data
  nop // Delay Slot

  la a0,VAQUAD        // A0 = Quad Data Offset
  ld t0,0(a0)         // T0 = Quad Data
  la a0,VEXTNVACHECKB // A0 = Quad Check Data Offset
  ld t1,0(a0)         // T1 = Quad Check Data
  bne t0,t1,VEXTNFAILB // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,VAQUAD        // A0 = Quad Data Offset
  ld t0,8(a0)         // T0 = Quad Data
  la a0,VEXTNVACHECKB // A0 = Quad Check Data Offset
  ld t1,8(a0)         // T1 = Quad Check Data
  bne t0,t1,VEXTNFAILB // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,VAQUAD        // A0 = Quad Data Offset
  ld t0,16(a0)        // T0 = Quad Data
  la a0,VEXTNVACHECKB // A0 = Quad Check Data Offset
  ld t1,16(a0)        // T1 = Quad Check Data
  bne t0,t1,VEXTNFAILB // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,VAQUAD        // A0 = Quad Data Offset
  ld t0,24(a0)        // T0 = Quad Data
  la a0,VEXTNVACHECKB // A0 = Quad Check Data Offset
  ld t1,24(a0)        // T1 = Quad Check Data
  bne t0,t1,VEXTNFAILB // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,VAQUAD        // A0 = Quad Data Offset
  ld t0,32(a0)        // T0 = Quad Data
  la a0,VEXTNVACHECKB // A0 = Quad Check Data Offset
  ld t1,32(a0)        // T1 = Quad Check Data
  bne t0,t1,VEXTNFAILB // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,VAQUAD        // A0 = Quad Data Offset
  ld t0,40(a0)        // T0 = Quad Data
  la a0,VEXTNVACHECKB // A0 = Quad Check Data Offset
  ld t1,40(a0)        // T1 = Quad Check Data
  bne t0,t1,VEXTNFAILB // Compare Result Equality With Check Data
  nop // Delay Slot

  la a0,VCOVCCWORD        // A0 = Word Data Offset
  lw t0,0(a0)             // T0 = Word Data
  la a0,VEXTNVCOVCCCHECKB // A0 = Word Check Data Offset
  lw t1,0(a0)             // T1 = Word Check Data
  bne t0,t1,VEXTNFAILB // Compare Result Equality With Check Data

  la a0,VCEBYTE        // A0 = Byte Data Offset
  lb t0,0(a0)          // T0 = Byte Data
  la a0,VEXTNVCECHECKB // A0 = Byte Check Data Offset
  lb t1,0(a0)          // T1 = Byte Check Data
  bne t0,t1,VEXTNFAILB // Compare Result Equality With Check Data

  PrintString($A0100000,576,104,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  j VEXTNENDB
  nop // Delay Slot
  VEXTNFAILB:
  PrintString($A0100000,576,104,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  VEXTNENDB:

  PrintString($A0100000,0,112,FontBlack,PAGEBREAK,79) // Print Text String To VRAM Using Font At X,Y Position


  // Load RSP Data To MEM
  DMASPRD(VALUEQUADB, VALUEQUADBEnd, SP_DMEM)    // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPRD(VALUEQUADC, VALUEQUADCEnd, SP_DMEM+16) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  // Set RSP Status (Start Execution)
  lui a0,SP_BASE // A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB // T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) // Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString($A0100000,48,120,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,56,120,FontBlack,VALUEQUADB,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,48,128,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,56,128,FontBlack,VALUEQUADB+8,7) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,48,144,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,56,144,FontBlack,VALUEQUADC,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,48,152,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,56,152,FontBlack,VALUEQUADC+8,7) // Print HEX Chars To VRAM Using Font At X,Y Position

  // Store RSP Data To MEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VDQUAD // A1 = Quad Data Offset
  lw t0,0(a0)  // T0 = Quad Data
  sw t0,0(a1)  // Store Quad Data To MEM
  lw t0,4(a0)  // T0 = Quad Data
  sw t0,4(a1)  // Store Quad Data To MEM
  lw t0,8(a0)  // T0 = Quad Data
  sw t0,8(a1)  // Store Quad Data To MEM
  lw t0,12(a0) // T0 = Quad Data
  sw t0,12(a1) // Store Quad Data To MEM

  la a1,VAQUAD // A1 = Quad Data Offset
  lw t0,16(a0) // T0 = Quad Data
  sw t0,0(a1)  // Store Quad Data To MEM
  lw t0,20(a0) // T0 = Quad Data
  sw t0,4(a1)  // Store Quad Data To MEM
  lw t0,24(a0) // T0 = Quad Data
  sw t0,8(a1)  // Store Quad Data To MEM
  lw t0,28(a0) // T0 = Quad Data
  sw t0,12(a1) // Store Quad Data To MEM

  lw t0,32(a0) // T0 = Quad Data
  sw t0,16(a1) // Store Quad Data To MEM
  lw t0,36(a0) // T0 = Quad Data
  sw t0,20(a1) // Store Quad Data To MEM
  lw t0,40(a0) // T0 = Quad Data
  sw t0,24(a1) // Store Quad Data To MEM
  lw t0,44(a0) // T0 = Quad Data
  sw t0,28(a1) // Store Quad Data To MEM

  lw t0,48(a0) // T0 = Quad Data
  sw t0,32(a1) // Store Quad Data To MEM
  lw t0,52(a0) // T0 = Quad Data
  sw t0,36(a1) // Store Quad Data To MEM
  lw t0,56(a0) // T0 = Quad Data
  sw t0,40(a1) // Store Quad Data To MEM
  lw t0,60(a0) // T0 = Quad Data
  sw t0,44(a1) // Store Quad Data To MEM

  la a1,VCOVCCWORD // A1 = Word Data Offset
  lw t0,64(a0) // T0 = Word Data
  sw t0,0(a1)  // Store Word Data To MEM

  la a1,VCEBYTE // A1 = Byte Data Offset
  lb t0,68(a0) // T0 = Byte Data
  sb t0,0(a1)  // Store Byte Data To MEM

  PrintString($A0100000,192,120,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,200,120,FontBlack,VAQUAD,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,240,120,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,248,120,FontBlack,VAQUAD+2,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,120,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,296,120,FontBlack,VAQUAD+4,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,336,120,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,344,120,FontBlack,VAQUAD+6,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,384,120,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,392,120,FontBlack,VAQUAD+8,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,432,120,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,440,120,FontBlack,VAQUAD+10,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,480,120,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,488,120,FontBlack,VAQUAD+12,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,528,120,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,536,120,FontBlack,VAQUAD+14,1) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,192,128,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,200,128,FontBlack,VAQUAD+16,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,240,128,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,248,128,FontBlack,VAQUAD+18,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,128,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,296,128,FontBlack,VAQUAD+20,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,336,128,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,344,128,FontBlack,VAQUAD+22,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,384,128,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,392,128,FontBlack,VAQUAD+24,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,432,128,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,440,128,FontBlack,VAQUAD+26,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,480,128,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,488,128,FontBlack,VAQUAD+28,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,528,128,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,536,128,FontBlack,VAQUAD+30,1) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,192,136,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,200,136,FontBlack,VAQUAD+32,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,240,136,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,248,136,FontBlack,VAQUAD+34,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,136,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,296,136,FontBlack,VAQUAD+36,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,336,136,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,344,136,FontBlack,VAQUAD+38,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,384,136,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,392,136,FontBlack,VAQUAD+40,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,432,136,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,440,136,FontBlack,VAQUAD+42,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,480,136,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,488,136,FontBlack,VAQUAD+44,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,528,136,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,536,136,FontBlack,VAQUAD+46,1) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,192,152,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,200,152,FontBlack,VDQUAD,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,240,152,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,248,152,FontBlack,VDQUAD+2,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,152,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,296,152,FontBlack,VDQUAD+4,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,336,152,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,344,152,FontBlack,VDQUAD+6,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,384,152,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,392,152,FontBlack,VDQUAD+8,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,432,152,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,440,152,FontBlack,VDQUAD+10,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,480,152,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,488,152,FontBlack,VDQUAD+12,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,528,152,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,536,152,FontBlack,VDQUAD+14,1) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,576,120,FontGreen,VCOHEX,2) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,600,120,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,608,120,FontBlack,VCOVCCWORD,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,576,128,FontGreen,VCCHEX,2) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,600,128,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,608,128,FontBlack,VCOVCCWORD+2,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,576,136,FontGreen,VCEHEX,2) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,600,136,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,608,136,FontBlack,VCEBYTE,0) // Print HEX Chars To VRAM Using Font At X,Y Position

  la a0,VDQUAD        // A0 = Quad Data Offset
  ld t0,0(a0)         // T0 = Quad Data
  la a0,VEXTNVDCHECKC // A0 = Quad Check Data Offset
  ld t1,0(a0)         // T1 = Quad Check Data
  bne t0,t1,VEXTNFAILC // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,VDQUAD        // A0 = Quad Data Offset
  ld t0,8(a0)         // T0 = Quad Data
  la a0,VEXTNVDCHECKC // A0 = Quad Check Data Offset
  ld t1,8(a0)         // T1 = Quad Check Data
  bne t0,t1,VEXTNFAILC // Compare Result Equality With Check Data
  nop // Delay Slot

  la a0,VAQUAD        // A0 = Quad Data Offset
  ld t0,0(a0)         // T0 = Quad Data
  la a0,VEXTNVACHECKC // A0 = Quad Check Data Offset
  ld t1,0(a0)         // T1 = Quad Check Data
  bne t0,t1,VEXTNFAILC // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,VAQUAD        // A0 = Quad Data Offset
  ld t0,8(a0)         // T0 = Quad Data
  la a0,VEXTNVACHECKC // A0 = Quad Check Data Offset
  ld t1,8(a0)         // T1 = Quad Check Data
  bne t0,t1,VEXTNFAILC // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,VAQUAD        // A0 = Quad Data Offset
  ld t0,16(a0)        // T0 = Quad Data
  la a0,VEXTNVACHECKC // A0 = Quad Check Data Offset
  ld t1,16(a0)        // T1 = Quad Check Data
  bne t0,t1,VEXTNFAILC // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,VAQUAD        // A0 = Quad Data Offset
  ld t0,24(a0)        // T0 = Quad Data
  la a0,VEXTNVACHECKC // A0 = Quad Check Data Offset
  ld t1,24(a0)        // T1 = Quad Check Data
  bne t0,t1,VEXTNFAILC // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,VAQUAD        // A0 = Quad Data Offset
  ld t0,32(a0)        // T0 = Quad Data
  la a0,VEXTNVACHECKC // A0 = Quad Check Data Offset
  ld t1,32(a0)        // T1 = Quad Check Data
  bne t0,t1,VEXTNFAILC // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,VAQUAD        // A0 = Quad Data Offset
  ld t0,40(a0)        // T0 = Quad Data
  la a0,VEXTNVACHECKC // A0 = Quad Check Data Offset
  ld t1,40(a0)        // T1 = Quad Check Data
  bne t0,t1,VEXTNFAILC // Compare Result Equality With Check Data
  nop // Delay Slot

  la a0,VCOVCCWORD        // A0 = Word Data Offset
  lw t0,0(a0)             // T0 = Word Data
  la a0,VEXTNVCOVCCCHECKC // A0 = Word Check Data Offset
  lw t1,0(a0)             // T1 = Word Check Data
  bne t0,t1,VEXTNFAILC // Compare Result Equality With Check Data

  la a0,VCEBYTE        // A0 = Byte Data Offset
  lb t0,0(a0)          // T0 = Byte Data
  la a0,VEXTNVCECHECKC // A0 = Byte Check Data Offset
  lb t1,0(a0)          // T1 = Byte Check Data
  bne t0,t1,VEXTNFAILC // Compare Result Equality With Check Data

  PrintString($A0100000,576,152,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  j VEXTNENDC
  nop // Delay Slot
  VEXTNFAILC:
  PrintString($A0100000,576,152,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  VEXTNENDC:

  PrintString($A0100000,0,160,FontBlack,PAGEBREAK,79) // Print Text String To VRAM Using Font At X,Y Position


  // Load RSP Data To DMEM
  DMASPRD(VALUEQUADC, VALUEQUADCEnd, SP_DMEM)    // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPRD(VALUEQUADC, VALUEQUADCEnd, SP_DMEM+16) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  // Set RSP Status (Start Execution)
  lui a0,SP_BASE // A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB // T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) // Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString($A0100000,48,168,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,56,168,FontBlack,VALUEQUADC,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,48,176,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,56,176,FontBlack,VALUEQUADC+8,7) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,48,192,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,56,192,FontBlack,VALUEQUADC,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,48,200,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,56,200,FontBlack,VALUEQUADC+8,7) // Print HEX Chars To VRAM Using Font At X,Y Position

  // Store RSP Data To MEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VDQUAD // A1 = Quad Data Offset
  lw t0,0(a0)  // T0 = Quad Data
  sw t0,0(a1)  // Store Quad Data To MEM
  lw t0,4(a0)  // T0 = Quad Data
  sw t0,4(a1)  // Store Quad Data To MEM
  lw t0,8(a0)  // T0 = Quad Data
  sw t0,8(a1)  // Store Quad Data To MEM
  lw t0,12(a0) // T0 = Quad Data
  sw t0,12(a1) // Store Quad Data To MEM

  la a1,VAQUAD // A1 = Quad Data Offset
  lw t0,16(a0) // T0 = Quad Data
  sw t0,0(a1)  // Store Quad Data To MEM
  lw t0,20(a0) // T0 = Quad Data
  sw t0,4(a1)  // Store Quad Data To MEM
  lw t0,24(a0) // T0 = Quad Data
  sw t0,8(a1)  // Store Quad Data To MEM
  lw t0,28(a0) // T0 = Quad Data
  sw t0,12(a1) // Store Quad Data To MEM

  lw t0,32(a0) // T0 = Quad Data
  sw t0,16(a1) // Store Quad Data To MEM
  lw t0,36(a0) // T0 = Quad Data
  sw t0,20(a1) // Store Quad Data To MEM
  lw t0,40(a0) // T0 = Quad Data
  sw t0,24(a1) // Store Quad Data To MEM
  lw t0,44(a0) // T0 = Quad Data
  sw t0,28(a1) // Store Quad Data To MEM

  lw t0,48(a0) // T0 = Quad Data
  sw t0,32(a1) // Store Quad Data To MEM
  lw t0,52(a0) // T0 = Quad Data
  sw t0,36(a1) // Store Quad Data To MEM
  lw t0,56(a0) // T0 = Quad Data
  sw t0,40(a1) // Store Quad Data To MEM
  lw t0,60(a0) // T0 = Quad Data
  sw t0,44(a1) // Store Quad Data To MEM

  la a1,VCOVCCWORD // A1 = Word Data Offset
  lw t0,64(a0) // T0 = Word Data
  sw t0,0(a1)  // Store Word Data To MEM

  la a1,VCEBYTE // A1 = Byte Data Offset
  lb t0,68(a0) // T0 = Byte Data
  sb t0,0(a1)  // Store Byte Data To MEM

  PrintString($A0100000,192,168,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,200,168,FontBlack,VAQUAD,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,240,168,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,248,168,FontBlack,VAQUAD+2,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,168,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,296,168,FontBlack,VAQUAD+4,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,336,168,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,344,168,FontBlack,VAQUAD+6,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,384,168,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,392,168,FontBlack,VAQUAD+8,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,432,168,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,440,168,FontBlack,VAQUAD+10,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,480,168,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,488,168,FontBlack,VAQUAD+12,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,528,168,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,536,168,FontBlack,VAQUAD+14,1) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,192,176,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,200,176,FontBlack,VAQUAD+16,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,240,176,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,248,176,FontBlack,VAQUAD+18,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,176,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,296,176,FontBlack,VAQUAD+20,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,336,176,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,344,176,FontBlack,VAQUAD+22,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,384,176,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,392,176,FontBlack,VAQUAD+24,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,432,176,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,440,176,FontBlack,VAQUAD+26,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,480,176,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,488,176,FontBlack,VAQUAD+28,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,528,176,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,536,176,FontBlack,VAQUAD+30,1) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,192,184,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,200,184,FontBlack,VAQUAD+32,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,240,184,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,248,184,FontBlack,VAQUAD+34,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,184,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,296,184,FontBlack,VAQUAD+36,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,336,184,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,344,184,FontBlack,VAQUAD+38,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,384,184,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,392,184,FontBlack,VAQUAD+40,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,432,184,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,440,184,FontBlack,VAQUAD+42,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,480,184,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,488,184,FontBlack,VAQUAD+44,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,528,184,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,536,184,FontBlack,VAQUAD+46,1) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,192,200,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,200,200,FontBlack,VDQUAD,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,240,200,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,248,200,FontBlack,VDQUAD+2,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,200,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,296,200,FontBlack,VDQUAD+4,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,336,200,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,344,200,FontBlack,VDQUAD+6,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,384,200,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,392,200,FontBlack,VDQUAD+8,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,432,200,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,440,200,FontBlack,VDQUAD+10,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,480,200,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,488,200,FontBlack,VDQUAD+12,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,528,200,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,536,200,FontBlack,VDQUAD+14,1) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,576,168,FontGreen,VCOHEX,2) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,600,168,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,608,168,FontBlack,VCOVCCWORD,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,576,176,FontGreen,VCCHEX,2) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,600,176,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,608,176,FontBlack,VCOVCCWORD+2,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,576,184,FontGreen,VCEHEX,2) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,600,184,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,608,184,FontBlack,VCEBYTE,0) // Print HEX Chars To VRAM Using Font At X,Y Position

  la a0,VDQUAD        // A0 = Quad Data Offset
  ld t0,0(a0)         // T0 = Quad Data
  la a0,VEXTNVDCHECKD // A0 = Quad Check Data Offset
  ld t1,0(a0)         // T1 = Quad Check Data
  bne t0,t1,VEXTNFAILD // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,VDQUAD        // A0 = Quad Data Offset
  ld t0,8(a0)         // T0 = Quad Data
  la a0,VEXTNVDCHECKD // A0 = Quad Check Data Offset
  ld t1,8(a0)         // T1 = Quad Check Data
  bne t0,t1,VEXTNFAILD // Compare Result Equality With Check Data
  nop // Delay Slot

  la a0,VAQUAD        // A0 = Quad Data Offset
  ld t0,0(a0)         // T0 = Quad Data
  la a0,VEXTNVACHECKD // A0 = Quad Check Data Offset
  ld t1,0(a0)         // T1 = Quad Check Data
  bne t0,t1,VEXTNFAILD // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,VAQUAD        // A0 = Quad Data Offset
  ld t0,8(a0)         // T0 = Quad Data
  la a0,VEXTNVACHECKD // A0 = Quad Check Data Offset
  ld t1,8(a0)         // T1 = Quad Check Data
  bne t0,t1,VEXTNFAILD // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,VAQUAD        // A0 = Quad Data Offset
  ld t0,16(a0)        // T0 = Quad Data
  la a0,VEXTNVACHECKD // A0 = Quad Check Data Offset
  ld t1,16(a0)        // T1 = Quad Check Data
  bne t0,t1,VEXTNFAILD // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,VAQUAD        // A0 = Quad Data Offset
  ld t0,24(a0)        // T0 = Quad Data
  la a0,VEXTNVACHECKD // A0 = Quad Check Data Offset
  ld t1,24(a0)        // T1 = Quad Check Data
  bne t0,t1,VEXTNFAILD // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,VAQUAD        // A0 = Quad Data Offset
  ld t0,32(a0)        // T0 = Quad Data
  la a0,VEXTNVACHECKD // A0 = Quad Check Data Offset
  ld t1,32(a0)        // T1 = Quad Check Data
  bne t0,t1,VEXTNFAILD // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,VAQUAD        // A0 = Quad Data Offset
  ld t0,40(a0)        // T0 = Quad Data
  la a0,VEXTNVACHECKD // A0 = Quad Check Data Offset
  ld t1,40(a0)        // T1 = Quad Check Data
  bne t0,t1,VEXTNFAILD // Compare Result Equality With Check Data
  nop // Delay Slot

  la a0,VCOVCCWORD        // A0 = Word Data Offset
  lw t0,0(a0)             // T0 = Word Data
  la a0,VEXTNVCOVCCCHECKD // A0 = Word Check Data Offset
  lw t1,0(a0)             // T1 = Word Check Data
  bne t0,t1,VEXTNFAILD // Compare Result Equality With Check Data

  la a0,VCEBYTE        // A0 = Byte Data Offset
  lb t0,0(a0)          // T0 = Byte Data
  la a0,VEXTNVCECHECKD // A0 = Byte Check Data Offset
  lb t1,0(a0)          // T1 = Byte Check Data
  bne t0,t1,VEXTNFAILD // Compare Result Equality With Check Data

  PrintString($A0100000,576,200,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  j VEXTNENDD
  nop // Delay Slot
  VEXTNFAILD:
  PrintString($A0100000,576,200,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  VEXTNENDD:

  PrintString($A0100000,0,208,FontBlack,PAGEBREAK,79) // Print Text String To VRAM Using Font At X,Y Position


  // Load RSP Code To IMEM
  DMASPRD(RSPVINSNCode, RSPVINSNCodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  // Load RSP Data To DMEM
  DMASPRD(VALUEQUADA, VALUEQUADAEnd, SP_DMEM)    // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPRD(VALUEQUADB, VALUEQUADBEnd, SP_DMEM+16) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  // Set RSP Program Counter
  lui a0,SP_PC_BASE // A0 = SP PC Base Register ($A4080000)
  li t0,$0000 // T0 = RSP Program Counter Set To Zero (Start Of RSP Code)
  sw t0,SP_PC(a0) // Store RSP Program Counter To SP PC Register ($A4080000)

  // Set RSP Status (Start Execution)
  lui a0,SP_BASE // A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB // T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) // Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString($A0100000,0,216,FontRed,VINSNTEXT,4) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,48,216,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,56,216,FontBlack,VALUEQUADA,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,48,224,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,56,224,FontBlack,VALUEQUADA+8,7) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,48,240,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,56,240,FontBlack,VALUEQUADB,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,48,248,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,56,248,FontBlack,VALUEQUADB+8,7) // Print HEX Chars To VRAM Using Font At X,Y Position

  // Store RSP Data To MEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VDQUAD // A1 = Quad Data Offset
  lw t0,0(a0)  // T0 = Quad Data
  sw t0,0(a1)  // Store Quad Data To MEM
  lw t0,4(a0)  // T0 = Quad Data
  sw t0,4(a1)  // Store Quad Data To MEM
  lw t0,8(a0)  // T0 = Quad Data
  sw t0,8(a1)  // Store Quad Data To MEM
  lw t0,12(a0) // T0 = Quad Data
  sw t0,12(a1) // Store Quad Data To MEM

  la a1,VAQUAD // A1 = Quad Data Offset
  lw t0,16(a0) // T0 = Quad Data
  sw t0,0(a1)  // Store Quad Data To MEM
  lw t0,20(a0) // T0 = Quad Data
  sw t0,4(a1)  // Store Quad Data To MEM
  lw t0,24(a0) // T0 = Quad Data
  sw t0,8(a1)  // Store Quad Data To MEM
  lw t0,28(a0) // T0 = Quad Data
  sw t0,12(a1) // Store Quad Data To MEM

  lw t0,32(a0) // T0 = Quad Data
  sw t0,16(a1) // Store Quad Data To MEM
  lw t0,36(a0) // T0 = Quad Data
  sw t0,20(a1) // Store Quad Data To MEM
  lw t0,40(a0) // T0 = Quad Data
  sw t0,24(a1) // Store Quad Data To MEM
  lw t0,44(a0) // T0 = Quad Data
  sw t0,28(a1) // Store Quad Data To MEM

  lw t0,48(a0) // T0 = Quad Data
  sw t0,32(a1) // Store Quad Data To MEM
  lw t0,52(a0) // T0 = Quad Data
  sw t0,36(a1) // Store Quad Data To MEM
  lw t0,56(a0) // T0 = Quad Data
  sw t0,40(a1) // Store Quad Data To MEM
  lw t0,60(a0) // T0 = Quad Data
  sw t0,44(a1) // Store Quad Data To MEM

  la a1,VCOVCCWORD // A1 = Word Data Offset
  lw t0,64(a0) // T0 = Word Data
  sw t0,0(a1)  // Store Word Data To MEM

  la a1,VCEBYTE // A1 = Byte Data Offset
  lb t0,68(a0) // T0 = Byte Data
  sb t0,0(a1)  // Store Byte Data To MEM

  PrintString($A0100000,192,216,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,200,216,FontBlack,VAQUAD,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,240,216,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,248,216,FontBlack,VAQUAD+2,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,216,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,296,216,FontBlack,VAQUAD+4,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,336,216,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,344,216,FontBlack,VAQUAD+6,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,384,216,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,392,216,FontBlack,VAQUAD+8,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,432,216,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,440,216,FontBlack,VAQUAD+10,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,480,216,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,488,216,FontBlack,VAQUAD+12,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,528,216,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,536,216,FontBlack,VAQUAD+14,1) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,192,224,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,200,224,FontBlack,VAQUAD+16,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,240,224,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,248,224,FontBlack,VAQUAD+18,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,224,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,296,224,FontBlack,VAQUAD+20,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,336,224,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,344,224,FontBlack,VAQUAD+22,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,384,224,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,392,224,FontBlack,VAQUAD+24,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,432,224,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,440,224,FontBlack,VAQUAD+26,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,480,224,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,488,224,FontBlack,VAQUAD+28,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,528,224,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,536,224,FontBlack,VAQUAD+30,1) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,192,232,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,200,232,FontBlack,VAQUAD+32,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,240,232,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,248,232,FontBlack,VAQUAD+34,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,232,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,296,232,FontBlack,VAQUAD+36,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,336,232,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,344,232,FontBlack,VAQUAD+38,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,384,232,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,392,232,FontBlack,VAQUAD+40,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,432,232,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,440,232,FontBlack,VAQUAD+42,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,480,232,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,488,232,FontBlack,VAQUAD+44,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,528,232,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,536,232,FontBlack,VAQUAD+46,1) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,192,248,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,200,248,FontBlack,VDQUAD,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,240,248,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,248,248,FontBlack,VDQUAD+2,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,248,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,296,248,FontBlack,VDQUAD+4,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,336,248,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,344,248,FontBlack,VDQUAD+6,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,384,248,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,392,248,FontBlack,VDQUAD+8,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,432,248,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,440,248,FontBlack,VDQUAD+10,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,480,248,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,488,248,FontBlack,VDQUAD+12,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,528,248,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,536,248,FontBlack,VDQUAD+14,1) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,576,216,FontGreen,VCOHEX,2) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,600,216,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,608,216,FontBlack,VCOVCCWORD,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,576,224,FontGreen,VCCHEX,2) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,600,224,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,608,224,FontBlack,VCOVCCWORD+2,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,576,232,FontGreen,VCEHEX,2) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,600,232,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,608,232,FontBlack,VCEBYTE,0) // Print HEX Chars To VRAM Using Font At X,Y Position

  la a0,VDQUAD        // A0 = Quad Data Offset
  ld t0,0(a0)         // T0 = Quad Data
  la a0,VINSNVDCHECKA // A0 = Quad Check Data Offset
  ld t1,0(a0)         // T1 = Quad Check Data
  bne t0,t1,VINSNFAILA // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,VDQUAD        // A0 = Quad Data Offset
  ld t0,8(a0)         // T0 = Quad Data
  la a0,VINSNVDCHECKA // A0 = Quad Check Data Offset
  ld t1,8(a0)         // T1 = Quad Check Data
  bne t0,t1,VINSNFAILA // Compare Result Equality With Check Data
  nop // Delay Slot

  la a0,VAQUAD        // A0 = Quad Data Offset
  ld t0,0(a0)         // T0 = Quad Data
  la a0,VINSNVACHECKA // A0 = Quad Check Data Offset
  ld t1,0(a0)         // T1 = Quad Check Data
  bne t0,t1,VINSNFAILA // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,VAQUAD        // A0 = Quad Data Offset
  ld t0,8(a0)         // T0 = Quad Data
  la a0,VINSNVACHECKA // A0 = Quad Check Data Offset
  ld t1,8(a0)         // T1 = Quad Check Data
  bne t0,t1,VINSNFAILA // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,VAQUAD        // A0 = Quad Data Offset
  ld t0,16(a0)        // T0 = Quad Data
  la a0,VINSNVACHECKA // A0 = Quad Check Data Offset
  ld t1,16(a0)        // T1 = Quad Check Data
  bne t0,t1,VINSNFAILA // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,VAQUAD        // A0 = Quad Data Offset
  ld t0,24(a0)        // T0 = Quad Data
  la a0,VINSNVACHECKA // A0 = Quad Check Data Offset
  ld t1,24(a0)        // T1 = Quad Check Data
  bne t0,t1,VINSNFAILA // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,VAQUAD        // A0 = Quad Data Offset
  ld t0,32(a0)        // T0 = Quad Data
  la a0,VINSNVACHECKA // A0 = Quad Check Data Offset
  ld t1,32(a0)        // T1 = Quad Check Data
  bne t0,t1,VINSNFAILA // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,VAQUAD        // A0 = Quad Data Offset
  ld t0,40(a0)        // T0 = Quad Data
  la a0,VINSNVACHECKA // A0 = Quad Check Data Offset
  ld t1,40(a0)        // T1 = Quad Check Data
  bne t0,t1,VINSNFAILA // Compare Result Equality With Check Data
  nop // Delay Slot

  la a0,VCOVCCWORD        // A0 = Word Data Offset
  lw t0,0(a0)             // T0 = Word Data
  la a0,VINSNVCOVCCCHECKA // A0 = Word Check Data Offset
  lw t1,0(a0)             // T1 = Word Check Data
  bne t0,t1,VINSNFAILA // Compare Result Equality With Check Data

  la a0,VCEBYTE        // A0 = Byte Data Offset
  lb t0,0(a0)          // T0 = Byte Data
  la a0,VINSNVCECHECKA // A0 = Byte Check Data Offset
  lb t1,0(a0)          // T1 = Byte Check Data
  bne t0,t1,VINSNFAILA // Compare Result Equality With Check Data

  PrintString($A0100000,576,248,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  j VINSNENDA
  nop // Delay Slot
  VINSNFAILA:
  PrintString($A0100000,576,248,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  VINSNENDA:

  PrintString($A0100000,0,256,FontBlack,PAGEBREAK,79) // Print Text String To VRAM Using Font At X,Y Position


  // Load RSP Data To DMEM
  DMASPRD(VALUEQUADB, VALUEQUADBEnd, SP_DMEM)    // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPRD(VALUEQUADB, VALUEQUADBEnd, SP_DMEM+16) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  // Set RSP Status (Start Execution)
  lui a0,SP_BASE // A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB // T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) // Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString($A0100000,48,264,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,56,264,FontBlack,VALUEQUADB,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,48,272,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,56,272,FontBlack,VALUEQUADB+8,7) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,48,288,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,56,288,FontBlack,VALUEQUADB,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,48,296,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,56,296,FontBlack,VALUEQUADB+8,7) // Print HEX Chars To VRAM Using Font At X,Y Position

  // Store RSP Data To MEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VDQUAD // A1 = Quad Data Offset
  lw t0,0(a0)  // T0 = Quad Data
  sw t0,0(a1)  // Store Quad Data To MEM
  lw t0,4(a0)  // T0 = Quad Data
  sw t0,4(a1)  // Store Quad Data To MEM
  lw t0,8(a0)  // T0 = Quad Data
  sw t0,8(a1)  // Store Quad Data To MEM
  lw t0,12(a0) // T0 = Quad Data
  sw t0,12(a1) // Store Quad Data To MEM

  la a1,VAQUAD // A1 = Quad Data Offset
  lw t0,16(a0) // T0 = Quad Data
  sw t0,0(a1)  // Store Quad Data To MEM
  lw t0,20(a0) // T0 = Quad Data
  sw t0,4(a1)  // Store Quad Data To MEM
  lw t0,24(a0) // T0 = Quad Data
  sw t0,8(a1)  // Store Quad Data To MEM
  lw t0,28(a0) // T0 = Quad Data
  sw t0,12(a1) // Store Quad Data To MEM

  lw t0,32(a0) // T0 = Quad Data
  sw t0,16(a1) // Store Quad Data To MEM
  lw t0,36(a0) // T0 = Quad Data
  sw t0,20(a1) // Store Quad Data To MEM
  lw t0,40(a0) // T0 = Quad Data
  sw t0,24(a1) // Store Quad Data To MEM
  lw t0,44(a0) // T0 = Quad Data
  sw t0,28(a1) // Store Quad Data To MEM

  lw t0,48(a0) // T0 = Quad Data
  sw t0,32(a1) // Store Quad Data To MEM
  lw t0,52(a0) // T0 = Quad Data
  sw t0,36(a1) // Store Quad Data To MEM
  lw t0,56(a0) // T0 = Quad Data
  sw t0,40(a1) // Store Quad Data To MEM
  lw t0,60(a0) // T0 = Quad Data
  sw t0,44(a1) // Store Quad Data To MEM

  la a1,VCOVCCWORD // A1 = Word Data Offset
  lw t0,64(a0) // T0 = Word Data
  sw t0,0(a1)  // Store Word Data To MEM

  la a1,VCEBYTE // A1 = Byte Data Offset
  lb t0,68(a0) // T0 = Byte Data
  sb t0,0(a1)  // Store Byte Data To MEM

  PrintString($A0100000,192,264,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,200,264,FontBlack,VAQUAD,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,240,264,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,248,264,FontBlack,VAQUAD+2,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,264,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,296,264,FontBlack,VAQUAD+4,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,336,264,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,344,264,FontBlack,VAQUAD+6,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,384,264,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,392,264,FontBlack,VAQUAD+8,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,432,264,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,440,264,FontBlack,VAQUAD+10,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,480,264,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,488,264,FontBlack,VAQUAD+12,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,528,264,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,536,264,FontBlack,VAQUAD+14,1) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,192,272,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,200,272,FontBlack,VAQUAD+16,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,240,272,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,248,272,FontBlack,VAQUAD+18,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,272,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,296,272,FontBlack,VAQUAD+20,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,336,272,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,344,272,FontBlack,VAQUAD+22,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,384,272,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,392,272,FontBlack,VAQUAD+24,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,432,272,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,440,272,FontBlack,VAQUAD+26,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,480,272,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,488,272,FontBlack,VAQUAD+28,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,528,272,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,536,272,FontBlack,VAQUAD+30,1) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,192,280,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,200,280,FontBlack,VAQUAD+32,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,240,280,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,248,280,FontBlack,VAQUAD+34,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,280,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,296,280,FontBlack,VAQUAD+36,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,336,280,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,344,280,FontBlack,VAQUAD+38,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,384,280,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,392,280,FontBlack,VAQUAD+40,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,432,280,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,440,280,FontBlack,VAQUAD+42,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,480,280,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,488,280,FontBlack,VAQUAD+44,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,528,280,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,536,280,FontBlack,VAQUAD+46,1) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,192,296,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,200,296,FontBlack,VDQUAD,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,240,296,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,248,296,FontBlack,VDQUAD+2,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,296,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,296,296,FontBlack,VDQUAD+4,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,336,296,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,344,296,FontBlack,VDQUAD+6,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,384,296,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,392,296,FontBlack,VDQUAD+8,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,432,296,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,440,296,FontBlack,VDQUAD+10,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,480,296,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,488,296,FontBlack,VDQUAD+12,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,528,296,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,536,296,FontBlack,VDQUAD+14,1) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,576,264,FontGreen,VCOHEX,2) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,600,264,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,608,264,FontBlack,VCOVCCWORD,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,576,272,FontGreen,VCCHEX,2) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,600,272,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,608,272,FontBlack,VCOVCCWORD+2,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,576,280,FontGreen,VCEHEX,2) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,600,280,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,608,280,FontBlack,VCEBYTE,0) // Print HEX Chars To VRAM Using Font At X,Y Position

  la a0,VDQUAD        // A0 = Quad Data Offset
  ld t0,0(a0)         // T0 = Quad Data
  la a0,VINSNVDCHECKB // A0 = Quad Check Data Offset
  ld t1,0(a0)         // T1 = Quad Check Data
  bne t0,t1,VINSNFAILB // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,VDQUAD        // A0 = Quad Data Offset
  ld t0,8(a0)         // T0 = Quad Data
  la a0,VINSNVDCHECKB // A0 = Quad Check Data Offset
  ld t1,8(a0)         // T1 = Quad Check Data
  bne t0,t1,VINSNFAILB // Compare Result Equality With Check Data
  nop // Delay Slot

  la a0,VAQUAD        // A0 = Quad Data Offset
  ld t0,0(a0)         // T0 = Quad Data
  la a0,VINSNVACHECKB // A0 = Quad Check Data Offset
  ld t1,0(a0)         // T1 = Quad Check Data
  bne t0,t1,VINSNFAILB // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,VAQUAD        // A0 = Quad Data Offset
  ld t0,8(a0)         // T0 = Quad Data
  la a0,VINSNVACHECKB // A0 = Quad Check Data Offset
  ld t1,8(a0)         // T1 = Quad Check Data
  bne t0,t1,VINSNFAILB // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,VAQUAD        // A0 = Quad Data Offset
  ld t0,16(a0)        // T0 = Quad Data
  la a0,VINSNVACHECKB // A0 = Quad Check Data Offset
  ld t1,16(a0)        // T1 = Quad Check Data
  bne t0,t1,VINSNFAILB // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,VAQUAD        // A0 = Quad Data Offset
  ld t0,24(a0)        // T0 = Quad Data
  la a0,VINSNVACHECKB // A0 = Quad Check Data Offset
  ld t1,24(a0)        // T1 = Quad Check Data
  bne t0,t1,VINSNFAILB // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,VAQUAD        // A0 = Quad Data Offset
  ld t0,32(a0)        // T0 = Quad Data
  la a0,VINSNVACHECKB // A0 = Quad Check Data Offset
  ld t1,32(a0)        // T1 = Quad Check Data
  bne t0,t1,VINSNFAILB // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,VAQUAD        // A0 = Quad Data Offset
  ld t0,40(a0)        // T0 = Quad Data
  la a0,VINSNVACHECKB // A0 = Quad Check Data Offset
  ld t1,40(a0)        // T1 = Quad Check Data
  bne t0,t1,VINSNFAILB // Compare Result Equality With Check Data
  nop // Delay Slot

  la a0,VCOVCCWORD        // A0 = Word Data Offset
  lw t0,0(a0)             // T0 = Word Data
  la a0,VINSNVCOVCCCHECKB // A0 = Word Check Data Offset
  lw t1,0(a0)             // T1 = Word Check Data
  bne t0,t1,VINSNFAILB // Compare Result Equality With Check Data

  la a0,VCEBYTE        // A0 = Byte Data Offset
  lb t0,0(a0)          // T0 = Byte Data
  la a0,VINSNVCECHECKB // A0 = Byte Check Data Offset
  lb t1,0(a0)          // T1 = Byte Check Data
  bne t0,t1,VINSNFAILB // Compare Result Equality With Check Data

  PrintString($A0100000,576,296,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  j VINSNENDB
  nop // Delay Slot
  VINSNFAILB:
  PrintString($A0100000,576,296,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  VINSNENDB:

  PrintString($A0100000,0,304,FontBlack,PAGEBREAK,79) // Print Text String To VRAM Using Font At X,Y Position


  // Load RSP Data To DMEM
  DMASPRD(VALUEQUADB, VALUEQUADBEnd, SP_DMEM)    // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPRD(VALUEQUADC, VALUEQUADCEnd, SP_DMEM+16) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  // Set RSP Status (Start Execution)
  lui a0,SP_BASE // A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB // T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) // Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString($A0100000,48,312,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,56,312,FontBlack,VALUEQUADB,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,48,320,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,56,320,FontBlack,VALUEQUADB+8,7) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,48,336,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,56,336,FontBlack,VALUEQUADC,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,48,344,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,56,344,FontBlack,VALUEQUADC+8,7) // Print HEX Chars To VRAM Using Font At X,Y Position

  // Store RSP Data To MEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VDQUAD // A1 = Quad Data Offset
  lw t0,0(a0)  // T0 = Quad Data
  sw t0,0(a1)  // Store Quad Data To MEM
  lw t0,4(a0)  // T0 = Quad Data
  sw t0,4(a1)  // Store Quad Data To MEM
  lw t0,8(a0)  // T0 = Quad Data
  sw t0,8(a1)  // Store Quad Data To MEM
  lw t0,12(a0) // T0 = Quad Data
  sw t0,12(a1) // Store Quad Data To MEM

  la a1,VAQUAD // A1 = Quad Data Offset
  lw t0,16(a0) // T0 = Quad Data
  sw t0,0(a1)  // Store Quad Data To MEM
  lw t0,20(a0) // T0 = Quad Data
  sw t0,4(a1)  // Store Quad Data To MEM
  lw t0,24(a0) // T0 = Quad Data
  sw t0,8(a1)  // Store Quad Data To MEM
  lw t0,28(a0) // T0 = Quad Data
  sw t0,12(a1) // Store Quad Data To MEM

  lw t0,32(a0) // T0 = Quad Data
  sw t0,16(a1) // Store Quad Data To MEM
  lw t0,36(a0) // T0 = Quad Data
  sw t0,20(a1) // Store Quad Data To MEM
  lw t0,40(a0) // T0 = Quad Data
  sw t0,24(a1) // Store Quad Data To MEM
  lw t0,44(a0) // T0 = Quad Data
  sw t0,28(a1) // Store Quad Data To MEM

  lw t0,48(a0) // T0 = Quad Data
  sw t0,32(a1) // Store Quad Data To MEM
  lw t0,52(a0) // T0 = Quad Data
  sw t0,36(a1) // Store Quad Data To MEM
  lw t0,56(a0) // T0 = Quad Data
  sw t0,40(a1) // Store Quad Data To MEM
  lw t0,60(a0) // T0 = Quad Data
  sw t0,44(a1) // Store Quad Data To MEM

  la a1,VCOVCCWORD // A1 = Word Data Offset
  lw t0,64(a0) // T0 = Word Data
  sw t0,0(a1)  // Store Word Data To MEM

  la a1,VCEBYTE // A1 = Byte Data Offset
  lb t0,68(a0) // T0 = Byte Data
  sb t0,0(a1)  // Store Byte Data To MEM

  PrintString($A0100000,192,312,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,200,312,FontBlack,VAQUAD,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,240,312,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,248,312,FontBlack,VAQUAD+2,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,312,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,296,312,FontBlack,VAQUAD+4,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,336,312,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,344,312,FontBlack,VAQUAD+6,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,384,312,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,392,312,FontBlack,VAQUAD+8,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,432,312,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,440,312,FontBlack,VAQUAD+10,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,480,312,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,488,312,FontBlack,VAQUAD+12,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,528,312,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,536,312,FontBlack,VAQUAD+14,1) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,192,320,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,200,320,FontBlack,VAQUAD+16,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,240,320,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,248,320,FontBlack,VAQUAD+18,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,320,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,296,320,FontBlack,VAQUAD+20,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,336,320,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,344,320,FontBlack,VAQUAD+22,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,384,320,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,392,320,FontBlack,VAQUAD+24,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,432,320,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,440,320,FontBlack,VAQUAD+26,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,480,320,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,488,320,FontBlack,VAQUAD+28,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,528,320,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,536,320,FontBlack,VAQUAD+30,1) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,192,328,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,200,328,FontBlack,VAQUAD+32,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,240,328,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,248,328,FontBlack,VAQUAD+34,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,328,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,296,328,FontBlack,VAQUAD+36,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,336,328,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,344,328,FontBlack,VAQUAD+38,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,384,328,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,392,328,FontBlack,VAQUAD+40,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,432,328,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,440,328,FontBlack,VAQUAD+42,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,480,328,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,488,328,FontBlack,VAQUAD+44,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,528,328,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,536,328,FontBlack,VAQUAD+46,1) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,192,344,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,200,344,FontBlack,VDQUAD,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,240,344,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,248,344,FontBlack,VDQUAD+2,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,344,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,296,344,FontBlack,VDQUAD+4,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,336,344,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,344,344,FontBlack,VDQUAD+6,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,384,344,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,392,344,FontBlack,VDQUAD+8,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,432,344,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,440,344,FontBlack,VDQUAD+10,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,480,344,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,488,344,FontBlack,VDQUAD+12,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,528,344,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,536,344,FontBlack,VDQUAD+14,1) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,576,312,FontGreen,VCOHEX,2) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,600,312,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,608,312,FontBlack,VCOVCCWORD,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,576,320,FontGreen,VCCHEX,2) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,600,320,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,608,320,FontBlack,VCOVCCWORD+2,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,576,328,FontGreen,VCEHEX,2) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,600,328,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,608,328,FontBlack,VCEBYTE,0) // Print HEX Chars To VRAM Using Font At X,Y Position

  la a0,VDQUAD        // A0 = Quad Data Offset
  ld t0,0(a0)         // T0 = Quad Data
  la a0,VINSNVDCHECKC // A0 = Quad Check Data Offset
  ld t1,0(a0)         // T1 = Quad Check Data
  bne t0,t1,VINSNFAILC // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,VDQUAD        // A0 = Quad Data Offset
  ld t0,8(a0)         // T0 = Quad Data
  la a0,VINSNVDCHECKC // A0 = Quad Check Data Offset
  ld t1,8(a0)         // T1 = Quad Check Data
  bne t0,t1,VINSNFAILC // Compare Result Equality With Check Data
  nop // Delay Slot

  la a0,VAQUAD        // A0 = Quad Data Offset
  ld t0,0(a0)         // T0 = Quad Data
  la a0,VINSNVACHECKC // A0 = Quad Check Data Offset
  ld t1,0(a0)         // T1 = Quad Check Data
  bne t0,t1,VINSNFAILC // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,VAQUAD        // A0 = Quad Data Offset
  ld t0,8(a0)         // T0 = Quad Data
  la a0,VINSNVACHECKC // A0 = Quad Check Data Offset
  ld t1,8(a0)         // T1 = Quad Check Data
  bne t0,t1,VINSNFAILC // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,VAQUAD        // A0 = Quad Data Offset
  ld t0,16(a0)        // T0 = Quad Data
  la a0,VINSNVACHECKC // A0 = Quad Check Data Offset
  ld t1,16(a0)        // T1 = Quad Check Data
  bne t0,t1,VINSNFAILC // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,VAQUAD        // A0 = Quad Data Offset
  ld t0,24(a0)        // T0 = Quad Data
  la a0,VINSNVACHECKC // A0 = Quad Check Data Offset
  ld t1,24(a0)        // T1 = Quad Check Data
  bne t0,t1,VINSNFAILC // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,VAQUAD        // A0 = Quad Data Offset
  ld t0,32(a0)        // T0 = Quad Data
  la a0,VINSNVACHECKC // A0 = Quad Check Data Offset
  ld t1,32(a0)        // T1 = Quad Check Data
  bne t0,t1,VINSNFAILC // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,VAQUAD        // A0 = Quad Data Offset
  ld t0,40(a0)        // T0 = Quad Data
  la a0,VINSNVACHECKC // A0 = Quad Check Data Offset
  ld t1,40(a0)        // T1 = Quad Check Data
  bne t0,t1,VINSNFAILC // Compare Result Equality With Check Data
  nop // Delay Slot

  la a0,VCOVCCWORD        // A0 = Word Data Offset
  lw t0,0(a0)             // T0 = Word Data
  la a0,VINSNVCOVCCCHECKC // A0 = Word Check Data Offset
  lw t1,0(a0)             // T1 = Word Check Data
  bne t0,t1,VINSNFAILC // Compare Result Equality With Check Data

  la a0,VCEBYTE        // A0 = Byte Data Offset
  lb t0,0(a0)          // T0 = Byte Data
  la a0,VINSNVCECHECKC // A0 = Byte Check Data Offset
  lb t1,0(a0)          // T1 = Byte Check Data
  bne t0,t1,VINSNFAILC // Compare Result Equality With Check Data

  PrintString($A0100000,576,344,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  j VINSNENDC
  nop // Delay Slot
  VINSNFAILC:
  PrintString($A0100000,576,344,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  VINSNENDC:

  PrintString($A0100000,0,352,FontBlack,PAGEBREAK,79) // Print Text String To VRAM Using Font At X,Y Position


  // Load RSP Data To DMEM
  DMASPRD(VALUEQUADC, VALUEQUADCEnd, SP_DMEM)    // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPRD(VALUEQUADC, VALUEQUADCEnd, SP_DMEM+16) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  // Set RSP Status (Start Execution)
  lui a0,SP_BASE // A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB // T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) // Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  PrintString($A0100000,48,360,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,56,360,FontBlack,VALUEQUADC,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,48,368,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,56,368,FontBlack,VALUEQUADC+8,7) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,48,384,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,56,384,FontBlack,VALUEQUADC,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,48,392,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,56,392,FontBlack,VALUEQUADC+8,7) // Print HEX Chars To VRAM Using Font At X,Y Position

  // Store RSP Data To MEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,VDQUAD // A1 = Quad Data Offset
  lw t0,0(a0)  // T0 = Quad Data
  sw t0,0(a1)  // Store Quad Data To MEM
  lw t0,4(a0)  // T0 = Quad Data
  sw t0,4(a1)  // Store Quad Data To MEM
  lw t0,8(a0)  // T0 = Quad Data
  sw t0,8(a1)  // Store Quad Data To MEM
  lw t0,12(a0) // T0 = Quad Data
  sw t0,12(a1) // Store Quad Data To MEM

  la a1,VAQUAD // A1 = Quad Data Offset
  lw t0,16(a0) // T0 = Quad Data
  sw t0,0(a1)  // Store Quad Data To MEM
  lw t0,20(a0) // T0 = Quad Data
  sw t0,4(a1)  // Store Quad Data To MEM
  lw t0,24(a0) // T0 = Quad Data
  sw t0,8(a1)  // Store Quad Data To MEM
  lw t0,28(a0) // T0 = Quad Data
  sw t0,12(a1) // Store Quad Data To MEM

  lw t0,32(a0) // T0 = Quad Data
  sw t0,16(a1) // Store Quad Data To MEM
  lw t0,36(a0) // T0 = Quad Data
  sw t0,20(a1) // Store Quad Data To MEM
  lw t0,40(a0) // T0 = Quad Data
  sw t0,24(a1) // Store Quad Data To MEM
  lw t0,44(a0) // T0 = Quad Data
  sw t0,28(a1) // Store Quad Data To MEM

  lw t0,48(a0) // T0 = Quad Data
  sw t0,32(a1) // Store Quad Data To MEM
  lw t0,52(a0) // T0 = Quad Data
  sw t0,36(a1) // Store Quad Data To MEM
  lw t0,56(a0) // T0 = Quad Data
  sw t0,40(a1) // Store Quad Data To MEM
  lw t0,60(a0) // T0 = Quad Data
  sw t0,44(a1) // Store Quad Data To MEM

  la a1,VCOVCCWORD // A1 = Word Data Offset
  lw t0,64(a0) // T0 = Word Data
  sw t0,0(a1)  // Store Word Data To MEM

  la a1,VCEBYTE // A1 = Byte Data Offset
  lb t0,68(a0) // T0 = Byte Data
  sb t0,0(a1)  // Store Byte Data To MEM

  PrintString($A0100000,192,360,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,200,360,FontBlack,VAQUAD,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,240,360,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,248,360,FontBlack,VAQUAD+2,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,360,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,296,360,FontBlack,VAQUAD+4,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,336,360,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,344,360,FontBlack,VAQUAD+6,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,384,360,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,392,360,FontBlack,VAQUAD+8,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,432,360,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,440,360,FontBlack,VAQUAD+10,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,480,360,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,488,360,FontBlack,VAQUAD+12,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,528,360,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,536,360,FontBlack,VAQUAD+14,1) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,192,368,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,200,368,FontBlack,VAQUAD+16,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,240,368,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,248,368,FontBlack,VAQUAD+18,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,368,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,296,368,FontBlack,VAQUAD+20,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,336,368,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,344,368,FontBlack,VAQUAD+22,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,384,368,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,392,368,FontBlack,VAQUAD+24,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,432,368,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,440,368,FontBlack,VAQUAD+26,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,480,368,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,488,368,FontBlack,VAQUAD+28,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,528,368,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,536,368,FontBlack,VAQUAD+30,1) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,192,376,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,200,376,FontBlack,VAQUAD+32,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,240,376,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,248,376,FontBlack,VAQUAD+34,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,376,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,296,376,FontBlack,VAQUAD+36,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,336,376,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,344,376,FontBlack,VAQUAD+38,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,384,376,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,392,376,FontBlack,VAQUAD+40,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,432,376,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,440,376,FontBlack,VAQUAD+42,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,480,376,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,488,376,FontBlack,VAQUAD+44,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,528,376,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,536,376,FontBlack,VAQUAD+46,1) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,192,392,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,200,392,FontBlack,VDQUAD,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,240,392,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,248,392,FontBlack,VDQUAD+2,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,392,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,296,392,FontBlack,VDQUAD+4,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,336,392,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,344,392,FontBlack,VDQUAD+6,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,384,392,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,392,392,FontBlack,VDQUAD+8,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,432,392,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,440,392,FontBlack,VDQUAD+10,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,480,392,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,488,392,FontBlack,VDQUAD+12,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,528,392,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,536,392,FontBlack,VDQUAD+14,1) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,576,360,FontGreen,VCOHEX,2) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,600,360,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,608,360,FontBlack,VCOVCCWORD,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,576,368,FontGreen,VCCHEX,2) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,600,368,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,608,368,FontBlack,VCOVCCWORD+2,1) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,576,376,FontGreen,VCEHEX,2) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,600,376,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,608,376,FontBlack,VCEBYTE,0) // Print HEX Chars To VRAM Using Font At X,Y Position

  la a0,VDQUAD        // A0 = Quad Data Offset
  ld t0,0(a0)         // T0 = Quad Data
  la a0,VINSNVDCHECKD // A0 = Quad Check Data Offset
  ld t1,0(a0)         // T1 = Quad Check Data
  bne t0,t1,VINSNFAILD // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,VDQUAD        // A0 = Quad Data Offset
  ld t0,8(a0)         // T0 = Quad Data
  la a0,VINSNVDCHECKD // A0 = Quad Check Data Offset
  ld t1,8(a0)         // T1 = Quad Check Data
  bne t0,t1,VINSNFAILD // Compare Result Equality With Check Data
  nop // Delay Slot

  la a0,VAQUAD        // A0 = Quad Data Offset
  ld t0,0(a0)         // T0 = Quad Data
  la a0,VINSNVACHECKD // A0 = Quad Check Data Offset
  ld t1,0(a0)         // T1 = Quad Check Data
  bne t0,t1,VINSNFAILD // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,VAQUAD        // A0 = Quad Data Offset
  ld t0,8(a0)         // T0 = Quad Data
  la a0,VINSNVACHECKD // A0 = Quad Check Data Offset
  ld t1,8(a0)         // T1 = Quad Check Data
  bne t0,t1,VINSNFAILD // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,VAQUAD        // A0 = Quad Data Offset
  ld t0,16(a0)        // T0 = Quad Data
  la a0,VINSNVACHECKD // A0 = Quad Check Data Offset
  ld t1,16(a0)        // T1 = Quad Check Data
  bne t0,t1,VINSNFAILD // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,VAQUAD        // A0 = Quad Data Offset
  ld t0,24(a0)        // T0 = Quad Data
  la a0,VINSNVACHECKD // A0 = Quad Check Data Offset
  ld t1,24(a0)        // T1 = Quad Check Data
  bne t0,t1,VINSNFAILD // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,VAQUAD        // A0 = Quad Data Offset
  ld t0,32(a0)        // T0 = Quad Data
  la a0,VINSNVACHECKD // A0 = Quad Check Data Offset
  ld t1,32(a0)        // T1 = Quad Check Data
  bne t0,t1,VINSNFAILD // Compare Result Equality With Check Data
  nop // Delay Slot
  la a0,VAQUAD        // A0 = Quad Data Offset
  ld t0,40(a0)        // T0 = Quad Data
  la a0,VINSNVACHECKD // A0 = Quad Check Data Offset
  ld t1,40(a0)        // T1 = Quad Check Data
  bne t0,t1,VINSNFAILD // Compare Result Equality With Check Data
  nop // Delay Slot

  la a0,VCOVCCWORD        // A0 = Word Data Offset
  lw t0,0(a0)             // T0 = Word Data
  la a0,VINSNVCOVCCCHECKD // A0 = Word Check Data Offset
  lw t1,0(a0)             // T1 = Word Check Data
  bne t0,t1,VINSNFAILD // Compare Result Equality With Check Data

  la a0,VCEBYTE        // A0 = Byte Data Offset
  lb t0,0(a0)          // T0 = Byte Data
  la a0,VINSNVCECHECKD // A0 = Byte Check Data Offset
  lb t1,0(a0)          // T1 = Byte Check Data
  bne t0,t1,VINSNFAILD // Compare Result Equality With Check Data

  PrintString($A0100000,576,392,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  j VINSNENDD
  nop // Delay Slot
  VINSNFAILD:
  PrintString($A0100000,576,392,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  VINSNENDD:

  PrintString($A0100000,0,400,FontBlack,PAGEBREAK,79) // Print Text String To VRAM Using Font At X,Y Position


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

VEXTNTEXT:
  db "VEXTN"
VINSNTEXT:
  db "VINSN"

VAVDHEX:
  db "VA/VD (Hex)"
VSVTHEX:
  db "VS/VT (Hex)"
TEST:
  db "Test Result"
FAIL:
  db "FAIL"
PASS:
  db "PASS"

DOLLAR:
  db "$"

VCOHEX:
  db "VCO"
VCCHEX:
  db "VCC"
VCEHEX:
  db "VCE"

PAGEBREAK:
  db "--------------------------------------------------------------------------------"

align(8) // Align 64-Bit
VALUEQUADA:
  dh $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
VALUEQUADAEnd:

VALUEQUADB:
  dh $0011, $2233, $4455, $6677, $8899, $AABB, $CCDD, $EEFF
VALUEQUADBEnd:

VALUEQUADC:
  dh $FFEE, $DDCC, $BBAA, $9988, $7766, $5544, $3322, $1100
VALUEQUADCEnd:

VEXTNVDCHECKA:
  dh $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
VEXTNVDCHECKB:
  dh $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
VEXTNVDCHECKC:
  dh $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
VEXTNVDCHECKD:
  dh $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000

VINSNVDCHECKA:
  dh $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
VINSNVDCHECKB:
  dh $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
VINSNVDCHECKC:
  dh $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
VINSNVDCHECKD:
  dh $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000

VEXTNVACHECKA:
  dh $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
  dh $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
  dh $0011, $2233, $4455, $6677, $8899, $AABB, $CCDD, $EEFF
VEXTNVACHECKB:
  dh $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
  dh $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
  dh $0022, $4466, $88AA, $CCEE, $1132, $5576, $99BA, $DDFE
VEXTNVACHECKC:
  dh $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
  dh $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
  dh $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF
VEXTNVACHECKD:
  dh $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
  dh $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
  dh $FFDC, $BB98, $7754, $3310, $EECC, $AA88, $6644, $2200

VINSNVACHECKA:
  dh $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
  dh $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
  dh $FFCA, $9964, $32FE, $CC98, $6632, $FFCC, $9966, $3300
VINSNVACHECKB:
  dh $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
  dh $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
  dh $FFDB, $BB97, $7753, $330F, $EECB, $AA87, $6643, $21FF
VINSNVACHECKC:
  dh $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
  dh $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
  dh $FFEC, $DDCA, $BBA8, $9986, $7764, $5542, $3320, $10FE
VINSNVACHECKD:
  dh $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
  dh $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
  dh $FFDA, $BB96, $7752, $330E, $EECA, $AA86, $6642, $21FE

VAQUAD:
  dh $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
  dh $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
  dh $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000

VDQUAD:
  dh $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000

VEXTNVCOVCCCHECKA:
  dh $0000, $0000
VEXTNVCOVCCCHECKB:
  dh $0000, $0000
VEXTNVCOVCCCHECKC:
  dh $0000, $0000
VEXTNVCOVCCCHECKD:
  dh $0000, $0000

VINSNVCOVCCCHECKA:
  dh $0000, $0000
VINSNVCOVCCCHECKB:
  dh $0000, $0000
VINSNVCOVCCCHECKC:
  dh $0000, $0000
VINSNVCOVCCCHECKD:
  dh $0000, $0000

VCOVCCWORD:
  dh $0000, $0000

VEXTNVCECHECKA:
  db $00
VEXTNVCECHECKB:
  db $00
VEXTNVCECHECKC:
  db $00
VEXTNVCECHECKD:
  db $00

VINSNVCECHECKA:
  db $00
VINSNVCECHECKB:
  db $00
VINSNVCECHECKC:
  db $00
VINSNVCECHECKD:
  db $00

VCEBYTE:
  db $00

arch n64.rsp
align(8) // Align 64-Bit
RSPVEXTNCode:
base $0000 // Set Base Of RSP Code Object To Zero
  lqv v0[e0],$00(r0) // V0 = 128-Bit DMEM $000(R0), Load Quad To Vector: LQV VT[ELEMENT],$OFFSET(BASE)
  lqv v1[e0],$10(r0) // V1 = 128-Bit DMEM $010(R0), Load Quad To Vector: LQV VT[ELEMENT],$OFFSET(BASE)
  vextn v0,v1[e0] // V0 = V0 EXTN V1[0], Vector Extract Nibble (4/4/4/4) (Sign Extended): VEXTN VD,VS,VT[ELEMENT]
  sqv v0[e0],$00(r0) // 128-Bit DMEM $000(R0) = V0, Store Vector To Quad: SQV VT[ELEMENT],$OFFSET(BASE)
  vsar v0,v0[e8] // V0 = Vector Accumulator HI, Vector Accumulator Read: VSAR VD,VS,VT[ELEMENT]
  sqv v0[e0],$10(r0) // 128-Bit DMEM $010(R0) = V0, Store Vector To Quad: SQV VT[ELEMENT],$OFFSET(BASE)
  vsar v0,v0[e9] // V0 = Vector Accumulator MD, Vector Accumulator Read: VSAR VD,VS,VT[ELEMENT]
  sqv v0[e0],$20(r0) // 128-Bit DMEM $020(R0) = V0, Store Vector To Quad: SQV VT[ELEMENT],$OFFSET(BASE)
  vsar v0,v0[e10] // V0 = Vector Accumulator LO, Vector Accumulator Read: VSAR VD,VS,VT[ELEMENT]
  sqv v0[e0],$30(r0) // 128-Bit DMEM $030(R0) = V0, Store Vector To Quad: SQV VT[ELEMENT],$OFFSET(BASE)
  cfc2 t0,vco   // T0 = RSP CP2 Control Register: VCO (Vector Carry Out)
  sh t0,$40(r0) // 16-Bit DMEM $040(R0) = T0
  cfc2 t0,vcc   // T0 = RSP CP2 Control Register: VCC (Vector Compare Code)
  sh t0,$42(r0) // 16-Bit DMEM $042(R0) = T0
  cfc2 t0,vce   // T0 = RSP CP2 Control Register: VCE (Vector Compare Extension)
  sb t0,$44(r0) //  8-Bit DMEM $044(R0) = T0
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
align(8) // Align 64-Bit
base RSPVEXTNCode+pc() // Set End Of RSP Code Object
RSPVEXTNCodeEnd:

align(8) // Align 64-Bit
RSPVINSNCode:
base $0000 // Set Base Of RSP Code Object To Zero
  lqv v0[e0],$00(r0) // V0 = 128-Bit DMEM $000(R0), Load Quad To Vector: LQV VT[ELEMENT],$OFFSET(BASE)
  lqv v1[e0],$10(r0) // V1 = 128-Bit DMEM $010(R0), Load Quad To Vector: LQV VT[ELEMENT],$OFFSET(BASE)
  vinsn v0,v1[e0] // V0 = V0 INSN V1[0], Vector Insert Nibble (4/4/4/4) (Sign Extended): VINSN VD,VS,VT[ELEMENT]
  sqv v0[e0],$00(r0) // 128-Bit DMEM $000(R0) = V0, Store Vector To Quad: SQV VT[ELEMENT],$OFFSET(BASE)
  vsar v0,v0[e8] // V0 = Vector Accumulator HI, Vector Accumulator Read: VSAR VD,VS,VT[ELEMENT]
  sqv v0[e0],$10(r0) // 128-Bit DMEM $010(R0) = V0, Store Vector To Quad: SQV VT[ELEMENT],$OFFSET(BASE)
  vsar v0,v0[e9] // V0 = Vector Accumulator MD, Vector Accumulator Read: VSAR VD,VS,VT[ELEMENT]
  sqv v0[e0],$20(r0) // 128-Bit DMEM $020(R0) = V0, Store Vector To Quad: SQV VT[ELEMENT],$OFFSET(BASE)
  vsar v0,v0[e10] // V0 = Vector Accumulator LO, Vector Accumulator Read: VSAR VD,VS,VT[ELEMENT]
  sqv v0[e0],$30(r0) // 128-Bit DMEM $030(R0) = V0, Store Vector To Quad: SQV VT[ELEMENT],$OFFSET(BASE)
  cfc2 t0,vco   // T0 = RSP CP2 Control Register: VCO (Vector Carry Out)
  sh t0,$40(r0) // 16-Bit DMEM $040(R0) = T0
  cfc2 t0,vcc   // T0 = RSP CP2 Control Register: VCC (Vector Compare Code)
  sh t0,$42(r0) // 16-Bit DMEM $042(R0) = T0
  cfc2 t0,vce   // T0 = RSP CP2 Control Register: VCE (Vector Compare Extension)
  sb t0,$44(r0) //  8-Bit DMEM $044(R0) = T0
  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
align(8) // Align 64-Bit
base RSPVINSNCode+pc() // Set End Of RSP Code Object
RSPVINSNCodeEnd:

insert FontBlack, "FontBlack8x8.bin"
insert FontGreen, "FontGreen8x8.bin"
insert FontRed, "FontRed8x8.bin"