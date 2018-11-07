// N64 'Bare Metal' RSP IMEM Last Instruction Delay Slot & Instruction Wrap Test Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "RSPIMEM.N64", create
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


  PrintString($A0100000,32,8,FontRed,DMEMOUTHEX,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,200,8,FontRed,TEST,10) // Print Text String To VRAM Using Font At X,Y Position


  PrintString($A0100000,0,16,FontBlack,PAGEBREAK,39) // Print Text String To VRAM Using Font At X,Y Position


  // Load RSP Code To IMEM
  DMASPRD(RSPIMEMLastInstructionDelaySlotCode, RSPIMEMLastInstructionDelaySlotCodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  SetSPPC($0FF8) // Set RSP Program Counter: Set To $0FF8 (End Of RSP Code)
  StartSP() // Start RSP Execution: RSP Status = Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break

  PrintString($A0100000,32,24,FontRed,IMEMLastInstructionDelaySlotTEXT,31) // Print Text String To VRAM Using Font At X,Y Position

  // Store RSP Data To MEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,DMEMHALF // A1 = Half Data Offset
  lh t0,0(a0)  // T0 = Half Data
  sh t0,0(a1)  // Store Half Data To MEM

  PrintString($A0100000,32,32,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,40,32,FontBlack,DMEMHALF,1) // Print HEX Chars To VRAM Using Font At X,Y Position

  la a0,DMEMHALF  // A0 = Half Data Offset
  lh t0,0(a0)     // T0 = Half Data
  la a0,IMEMLastInstructionDelaySlotCHECK // A0 = Half Check Data Offset
  lh t1,0(a0)     // T1 = Half Check Data
  bne t0,t1,IMEMLastInstructionDelaySlotFAIL // Compare Result Equality With Check Data
  nop // Delay Slot

  PrintString($A0100000,256,32,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  j IMEMLastInstructionDelaySlotEND
  nop // Delay Slot
  IMEMLastInstructionDelaySlotFAIL:
  PrintString($A0100000,256,32,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  IMEMLastInstructionDelaySlotEND:


  PrintString($A0100000,0,40,FontBlack,PAGEBREAK,39) // Print Text String To VRAM Using Font At X,Y Position


  // Load RSP Code To IMEM
  DMASPRD(RSPIMEMInstructionWrapCode, RSPIMEMInstructionWrapCodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  SetSPPC($0FFC) // Set RSP Program Counter: Set To $0FFC (End Of RSP Code)
  StartSP() // Start RSP Execution: RSP Status = Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break

  PrintString($A0100000,32,48,FontRed,IMEMInstructionWrapTEXT,20) // Print Text String To VRAM Using Font At X,Y Position

  // Store RSP Data To MEM
  lui a0,SP_MEM_BASE // A0 = SP Memory Base Offset (DMEM)
  la a1,DMEMHALF // A1 = Half Data Offset
  lh t0,0(a0)  // T0 = Half Data
  sh t0,0(a1)  // Store Half Data To MEM

  PrintString($A0100000,32,56,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,40,56,FontBlack,DMEMHALF,1) // Print HEX Chars To VRAM Using Font At X,Y Position

  la a0,DMEMHALF  // A0 = Half Data Offset
  lh t0,0(a0)     // T0 = Half Data
  la a0,IMEMInstructionWrapCHECK // A0 = Half Check Data Offset
  lh t1,0(a0)     // T1 = Half Check Data
  bne t0,t1,IMEMInstructionWrapFAIL // Compare Result Equality With Check Data
  nop // Delay Slot

  PrintString($A0100000,256,56,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  j IMEMInstructionWrapEND
  nop // Delay Slot
  IMEMInstructionWrapFAIL:
  PrintString($A0100000,256,56,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  IMEMInstructionWrapEND:


  PrintString($A0100000,0,64,FontBlack,PAGEBREAK,39) // Print Text String To VRAM Using Font At X,Y Position


Loop:
  j Loop
  nop // Delay Slot

IMEMLastInstructionDelaySlotTEXT:
  db "IMEM Last Instruction Delay Slot"
IMEMInstructionWrapTEXT:
  db "IMEM Instruction Wrap"

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

align(2) // Align 16-Bit
IMEMLastInstructionDelaySlotCHECK:
  dh $BEEF

IMEMInstructionWrapCHECK:
  dh $BABE

DMEMHALF:
  dh $0000

arch n64.rsp
align(8) // Align 64-Bit
RSPIMEMLastInstructionDelaySlotCode:
base $0000 // Set Base Of RSP Code Object To Zero
  IMEMSTART: // Offset == 0000 (Start Of IMEM)
    ori t0,r0,$BEEF // T0 = BEEF (Delay Slot From Last Instruction)

  define i(0)
  while {i} < 511 {
    nop // Write 511 NOP Instructions
    evaluate i({i} + 1)
  }

  IMEMMIDDLE: // Offset == 2048 (Middle Of IMEM)
    sh t0,0(r0) // DMEM[$0000] = T0
    break // Set SP Status Halt, Broke & Check For Interrupt

  define i(0)
  while {i} < 508 {
    nop // Write 508 NOP Instructions
    evaluate i({i} + 1)
  }

  IMEMEND: // Offset == 4088 (End Of IMEM, 2 Last Instructions)
    ori t0,r0,$DEAD // T0 = $DEAD
    j IMEMMIDDLE // Jump To Middle Of IMEM (Delay Slot Run From 1st Instruction)
align(8) // Align 64-Bit
base RSPIMEMLastInstructionDelaySlotCode+pc() // Set End Of RSP Code Object
RSPIMEMLastInstructionDelaySlotCodeEnd:

arch n64.rsp
align(8) // Align 64-Bit
RSPIMEMInstructionWrapCode:
base $0000 // Set Base Of RSP Code Object To Zero
  IMEMSTARTB: // Offset == 0000 (Start Of IMEM)
    ori t0,r0,$BABE // T0 = BABE (Wrap From Last Instruction)
    sh t0,0(r0) // DMEM[$0000] = T0
    break // Set SP Status Halt, Broke & Check For Interrupt

  define i(0)
  while {i} < 1020 {
    nop // Write 1020 NOP Instructions
    evaluate i({i} + 1)
  }

  IMEMENDB: // Offset == 4092 (End Of IMEM, Last Instruction)
    ori t0,r0,$CAFE // T0 = $CAFE
align(8) // Align 64-Bit
base RSPIMEMInstructionWrapCode+pc() // Set End Of RSP Code Object
RSPIMEMInstructionWrapCodeEnd:

insert FontBlack, "FontBlack8x8.bin"
insert FontGreen, "FontGreen8x8.bin"
insert FontRed, "FontRed8x8.bin"