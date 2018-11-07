// N64 'Bare Metal' RSP Sort Of Parallel Elements Within Three Vectors Test Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "RSPSORT.N64", create
fill 1052672 // Set ROM Size

// Setup Frame Buffer
constant SCREEN_X(320)
constant SCREEN_Y(240)
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

  ScreenNTSC(320, 240, BPP32, $A0100000) // Screen NTSC: 320x240, 32BPP, DRAM Origin = $A0100000

  lui a0,$A010 // A0 = VRAM Start Offset
  la a1,$A0100000+((SCREEN_X*SCREEN_Y*BYTES_PER_PIXEL)-BYTES_PER_PIXEL) // A1 = VRAM End Offset
  lli t0,$000000FF // T0 = Black
ClearScreen:
  sw t0,0(a0)
  bne a0,a1,ClearScreen
  addi a0,4 // Delay Slot


  PrintString($A0100000,16,8,FontRed,RSPSORTTEXT,35) // Print Text String To VRAM Using Font At X,Y Position


  PrintString($A0100000,0,16,FontBlack,PAGEBREAK,39) // Print Text String To VRAM Using Font At X,Y Position


  PrintString($A0100000,8,24,FontRed,DMEMINHEX,15) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,8,40,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,16,40,FontBlack,VALUEQUADA,15) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,8,48,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,16,48,FontBlack,VALUEQUADB,15) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,8,56,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,16,56,FontBlack,VALUEQUADC,15) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,0,64,FontBlack,PAGEBREAK,39) // Print Text String To VRAM Using Font At X,Y Position

  // Load RSP Code To IMEM
  DMASPRD(RSPSORTCode, RSPSORTCodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  // Load RSP Data To DMEM
  DMASPRD(VALUEQUADA, VALUEQUADCEnd, SP_DMEM)    // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  SetSPPC($0000) // Set RSP Program Counter: Set To Zero (Start Of RSP Code)
  StartSP() // Start RSP Execution: RSP Status = Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break

  PrintString($A0100000,8,72,FontRed,DMEMOUTHEX,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,224,72,FontRed,TEST,10) // Print Text String To VRAM Using Font At X,Y Position


  PrintString($A0100000,8,88,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,16,88,FontBlack,SP_MEM_BASE<<16,15) // Print HEX Chars To VRAM Using Font At X,Y Position

  lui a0,SP_MEM_BASE       // A0 = Quad Data Offset
  ld t0,0(a0)              // T0 = Quad Data
  la a1,SORTQUADMINCHECK   // A0 = Quad Check Data Offset
  ld t1,0(a1)              // T1 = Quad Check Data
  bne t0,t1,RSPSORTMINFAIL // Compare Result Equality With Check Data
  nop // Delay Slot

  ld t0,8(a0)              // T0 = Quad Data
  ld t1,8(a1)              // T1 = Quad Check Data
  bne t0,t1,RSPSORTMINFAIL // Compare Result Equality With Check Data
  nop // Delay Slot

  PrintString($A0100000,280,88,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  j RSPSORTMINEND
  nop // Delay Slot
  RSPSORTMINFAIL:
  PrintString($A0100000,280,88,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  RSPSORTMINEND:


  PrintString($A0100000,8,96,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,16,96,FontBlack,(SP_MEM_BASE<<16)+16,15) // Print HEX Chars To VRAM Using Font At X,Y Position

  lui a0,SP_MEM_BASE       // A0 = Quad Data Offset
  ld t0,16(a0)             // T0 = Quad Data
  la a1,SORTQUADMIDCHECK   // A0 = Quad Check Data Offset
  ld t1,0(a1)              // T1 = Quad Check Data
  bne t0,t1,RSPSORTMIDFAIL // Compare Result Equality With Check Data
  nop // Delay Slot

  ld t0,24(a0)             // T0 = Quad Data
  ld t1,8(a1)              // T1 = Quad Check Data
  bne t0,t1,RSPSORTMIDFAIL // Compare Result Equality With Check Data
  nop // Delay Slot

  PrintString($A0100000,280,96,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  j RSPSORTMIDEND
  nop // Delay Slot
  RSPSORTMIDFAIL:
  PrintString($A0100000,280,96,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  RSPSORTMIDEND:


  PrintString($A0100000,8,104,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,16,104,FontBlack,(SP_MEM_BASE<<16)+32,15) // Print HEX Chars To VRAM Using Font At X,Y Position

  lui a0,SP_MEM_BASE       // A0 = Quad Data Offset
  ld t0,32(a0)             // T0 = Quad Data
  la a1,SORTQUADMAXCHECK   // A0 = Quad Check Data Offset
  ld t1,0(a1)              // T1 = Quad Check Data
  bne t0,t1,RSPSORTMAXFAIL // Compare Result Equality With Check Data
  nop // Delay Slot

  ld t0,40(a0)             // T0 = Quad Data
  ld t1,8(a1)              // T1 = Quad Check Data
  bne t0,t1,RSPSORTMAXFAIL // Compare Result Equality With Check Data
  nop // Delay Slot

  PrintString($A0100000,280,104,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  j RSPSORTMAXEND
  nop // Delay Slot
  RSPSORTMAXFAIL:
  PrintString($A0100000,280,104,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  RSPSORTMAXEND:


  PrintString($A0100000,0,112,FontBlack,PAGEBREAK,39) // Print Text String To VRAM Using Font At X,Y Position

Loop:
  j Loop
  nop // Delay Slot

RSPSORTTEXT:
  db "RSP Vector Sort Of Parallel Elements"
DMEMINHEX:
  db "DMEM Input (Hex)"
DMEMOUTHEX:
  db "DMEM Output (Hex)"
TEST:
  db "Test Result"
FAIL:
  db "FAIL"
PASS:
  db "PASS"

DOLLAR:
  db "$"

PAGEBREAK:
  db "----------------------------------------"

align(8) // Align 64-Bit
VALUEQUADA:
  dh $0123,$0498,$0185,$0010,$0567,$0112,$0898,$0112
VALUEQUADAEnd:

VALUEQUADB:
  dh $0087,$0323,$0343,$0038,$0228,$0238,$0652,$0223
VALUEQUADBEnd:

VALUEQUADC:
  dh $0112,$0198,$0089,$0225,$0329,$0068,$0149,$0329
VALUEQUADCEnd:

SORTQUADMINCHECK:
  dh $0087,$0198,$0089,$0010,$0228,$0068,$0149,$0112

SORTQUADMIDCHECK:
  dh $0112,$0323,$0185,$0038,$0329,$0112,$0652,$0223

SORTQUADMAXCHECK:
  dh $0123,$0498,$0343,$0225,$0567,$0238,$0898,$0329

arch n64.rsp
align(8) // Align 64-Bit
RSPSORTCode:
base $0000 // Set Base Of RSP Code Object To Zero
IMEMSTART: // Offset == 0000 (Start Of IMEM)
  lqv v0[e0],$00(r0) // V0 = 128-Bit DMEM $000(R0), Load Quad To Vector: LQV VT[ELEMENT],$OFFSET(BASE)
  lqv v1[e0],$10(r0) // V1 = 128-Bit DMEM $010(R0), Load Quad To Vector: LQV VT[ELEMENT],$OFFSET(BASE)
  lqv v2[e0],$20(r0) // V2 = 128-Bit DMEM $020(R0), Load Quad To Vector: LQV VT[ELEMENT],$OFFSET(BASE)

  vge v3,v0,v1[e0] // VGE TMP1, MIN, MID
  vlt v0,v0,v1[e0] // VLT  MIN, MIN, MID
  vge v4,v0,v2[e0] // VGE TMP2, MIN, MAX
  vlt v0,v0,v2[e0] // VLT  MIN, MIN, MAX
  vge v2,v3,v4[e0] // VGE MAX, TMP1, TMP2
  vlt v1,v3,v4[e0] // VLT MID, TMP1, TMP2

  sqv v0[e0],$00(r0) // V0 = 128-Bit DMEM $000(R0), Store Quad To Vector: SQV VT[ELEMENT],$OFFSET(BASE)
  sqv v1[e0],$10(r0) // V1 = 128-Bit DMEM $010(R0), Store Quad To Vector: SQV VT[ELEMENT],$OFFSET(BASE)
  sqv v2[e0],$20(r0) // V2 = 128-Bit DMEM $020(R0), Store Quad To Vector: SQV VT[ELEMENT],$OFFSET(BASE)

  break // Set SP Status Halt, Broke & Check For Interrupt
align(8) // Align 64-Bit
base RSPSORTCode+pc() // Set End Of RSP Code Object
RSPSORTCodeEnd:

insert FontBlack, "FontBlack8x8.bin"
insert FontGreen, "FontGreen8x8.bin"
insert FontRed, "FontRed8x8.bin"