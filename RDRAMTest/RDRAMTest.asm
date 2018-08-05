// N64 'Bare Metal' RDRAM Test Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "RDRAMTest.N64", create
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
  N64_INIT() // Run N64 Initialisation Routine

  ScreenNTSC(320, 240, BPP32|AA_MODE_2, $A0100000) // Screen NTSC: 320x240, 32BPP, Resample Only, DRAM Origin = $A0100000

  lui a0,$A010 // A0 = VRAM Start Offset
  la a1,$A0100000+((SCREEN_X*SCREEN_Y*BYTES_PER_PIXEL)-BYTES_PER_PIXEL) // A1 = VRAM End Offset
  lli t0,$000000FF // T0 = Black
ClearScreen:
  sw t0,0(a0)
  bne a0,a1,ClearScreen
  addi a0,4 // Delay Slot


  PrintString($A0100000,8,8,FontRed,RDRAMTEST,10) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,136,8,FontBlack,ADDRESS,7) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,208,8,FontGreen,RESULT,6) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,0,16,FontBlack,PAGEBREAK,39) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,8,24,FontRed,EXTENDEDRDRAM,13) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,128,24,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

  lui a3,$A040 // A3 = Extended RDRAM Address
  li s0,$DEADBEEF // S0 = Test Word
  la s1,RDWORD // S1 = RDRAM Word Address
ExtendedLoop:
  sw a3,0(s1) // Store Extended RDRAM Address To RDRAM Word Address
  sw s0,0(a3) // Store Test Word To Extended RDRAM Address
  PrintValue($A0100000,136,24,FontBlack,RDWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  lw t0,0(a3) // T0 = Extended RDRAM Word
  beq t0,s0,ExtendedLoop // IF (Extended RDRAM Word == Test Word) Extended Loop, ELSE Break
  addiu a3,256 // Extended RDRAM Address += 4 (Delay Slot)

  lui a0,$A040
  subu a3,a0
  sll a3,4
  sw a3,0(s1) // Store Extended RDRAM MB Size To RDRAM Word Address
  PrintString($A0100000,208,24,FontGreen,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,216,24,FontGreen,RDWORD,0) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,24,FontGreen,MB,1) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,32,40,FontRed,TOTALRDRAM,10) // Print Text String To VRAM Using Font At X,Y Position

  lbu t0,0(s1)
  addiu t0,4
  sb t0,0(s1) // Store Total RDRAM MB Size To RDRAM Word Address
  PrintString($A0100000,208,40,FontGreen,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,216,40,FontGreen,RDWORD,0) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,40,FontGreen,MB,1) // Print Text String To VRAM Using Font At X,Y Position


  PrintString($A0100000,0,48,FontBlack,PAGEBREAK,39) // Print Text String To VRAM Using Font At X,Y Position


  PrintString($A0100000,8,56,FontRed,RDRAMREGISTER,13) // Print Text String To VRAM Using Font At X,Y Position

  lui a3,RDRAM_BASE // A3 = RDRAM Base Register ($A3F00000)

  PrintString($A0100000,32,72,FontRed,RDRAMDEVICETYPE,10) // Print Text String To VRAM Using Font At X,Y Position
  addiu t0,a3,RDRAM_DEVICE_TYPE // T0 = RDRAM: Device Type Register Address ($A3F00000)
  sw t0,0(s1) // Store RDRAM Word Address
  PrintString($A0100000,128,72,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,136,72,FontBlack,RDWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  lw t0,RDRAM_DEVICE_TYPE(a3) // T0 = RDRAM Register Word
  sw t0,0(s1) // Store RDRAM Word Address
  PrintString($A0100000,208,72,FontGreen,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,216,72,FontGreen,RDWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,32,88,FontRed,RDRAMDEVICEID,8) // Print Text String To VRAM Using Font At X,Y Position
  addiu t0,a3,RDRAM_DEVICE_ID // T0 = RDRAM: Device ID Register Address ($A3F00004)
  sw t0,0(s1) // Store RDRAM Word Address
  PrintString($A0100000,128,88,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,136,88,FontBlack,RDWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  lw t0,RDRAM_DEVICE_ID(a3) // T0 = RDRAM Register Word
  sw t0,0(s1) // Store RDRAM Word Address
  PrintString($A0100000,208,88,FontGreen,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,216,88,FontGreen,RDWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,32,104,FontRed,RDRAMDELAY,4) // Print Text String To VRAM Using Font At X,Y Position
  addiu t0,a3,RDRAM_DELAY // T0 = RDRAM: Delay Register Address ($A3F00008)
  sw t0,0(s1) // Store RDRAM Word Address
  PrintString($A0100000,128,104,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,136,104,FontBlack,RDWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  lw t0,RDRAM_DELAY(a3) // T0 = RDRAM Register Word
  sw t0,0(s1) // Store RDRAM Word Address
  PrintString($A0100000,208,104,FontGreen,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,216,104,FontGreen,RDWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,32,120,FontRed,RDRAMMODE,3) // Print Text String To VRAM Using Font At X,Y Position
  addiu t0,a3,RDRAM_MODE // T0 = RDRAM: Mode Register Address ($A3F0000C)
  sw t0,0(s1) // Store RDRAM Word Address
  PrintString($A0100000,128,120,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,136,120,FontBlack,RDWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  lw t0,RDRAM_MODE(a3) // T0 = RDRAM Register Word
  sw t0,0(s1) // Store RDRAM Word Address
  PrintString($A0100000,208,120,FontGreen,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,216,120,FontGreen,RDWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,24,136,FontRed,RDRAMREFINTERVAL,11) // Print Text String To VRAM Using Font At X,Y Position
  addiu t0,a3,RDRAM_REF_INTERVAL // T0 = RDRAM: Ref Interval Register Address ($A3F00010)
  sw t0,0(s1) // Store RDRAM Word Address
  PrintString($A0100000,128,136,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,136,136,FontBlack,RDWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  lw t0,RDRAM_REF_INTERVAL(a3) // T0 = RDRAM Register Word
  sw t0,0(s1) // Store RDRAM Word Address
  PrintString($A0100000,208,136,FontGreen,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,216,136,FontGreen,RDWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,24,152,FontRed,RDRAMREFROW,6) // Print Text String To VRAM Using Font At X,Y Position
  addiu t0,a3,RDRAM_REF_ROW // T0 = RDRAM: Ref Row Register Address ($A3F00014)
  sw t0,0(s1) // Store RDRAM Word Address
  PrintString($A0100000,128,152,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,136,152,FontBlack,RDWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  lw t0,RDRAM_REF_ROW(a3) // T0 = RDRAM Register Word
  sw t0,0(s1) // Store RDRAM Word Address
  PrintString($A0100000,208,152,FontGreen,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,216,152,FontGreen,RDWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,24,168,FontRed,RDRAMRASINTERVAL,11) // Print Text String To VRAM Using Font At X,Y Position
  addiu t0,a3,RDRAM_RAS_INTERVAL // T0 = RDRAM: Ras Interval Register Address ($A3F00018)
  sw t0,0(s1) // Store RDRAM Word Address
  PrintString($A0100000,128,168,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,136,168,FontBlack,RDWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  lw t0,RDRAM_RAS_INTERVAL(a3) // T0 = RDRAM Register Word
  sw t0,0(s1) // Store RDRAM Word Address
  PrintString($A0100000,208,168,FontGreen,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,216,168,FontGreen,RDWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,24,184,FontRed,RDRAMMININTERVAL,11) // Print Text String To VRAM Using Font At X,Y Position
  addiu t0,a3,RDRAM_MIN_INTERVAL // T0 = RDRAM: Minimum Interval Register Address ($A3F0001C)
  sw t0,0(s1) // Store RDRAM Word Address
  PrintString($A0100000,128,184,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,136,184,FontBlack,RDWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  lw t0,RDRAM_MIN_INTERVAL(a3) // T0 = RDRAM Register Word
  sw t0,0(s1) // Store RDRAM Word Address
  PrintString($A0100000,208,184,FontGreen,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,216,184,FontGreen,RDWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,32,200,FontRed,RDRAMADDRSELECT,10) // Print Text String To VRAM Using Font At X,Y Position
  addiu t0,a3,RDRAM_ADDR_SELECT // T0 = RDRAM: Address Select Register Address ($A3F00020)
  sw t0,0(s1) // Store RDRAM Word Address
  PrintString($A0100000,128,200,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,136,200,FontBlack,RDWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  lw t0,RDRAM_ADDR_SELECT(a3) // T0 = RDRAM Register Word
  sw t0,0(s1) // Store RDRAM Word Address
  PrintString($A0100000,208,200,FontGreen,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,216,200,FontGreen,RDWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,24,216,FontRed,RDRAMDEVICEMANUF,11) // Print Text String To VRAM Using Font At X,Y Position
  addiu t0,a3,RDRAM_DEVICE_MANUF // T0 = RDRAM: Device Manufacturer Register Address ($A3F00024)
  sw t0,0(s1) // Store RDRAM Word Address
  PrintString($A0100000,128,216,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,136,216,FontBlack,RDWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  lw t0,RDRAM_DEVICE_MANUF(a3) // T0 = RDRAM Register Word
  sw t0,0(s1) // Store RDRAM Word Address
  PrintString($A0100000,208,216,FontGreen,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,216,216,FontGreen,RDWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position


  PrintString($A0100000,0,224,FontBlack,PAGEBREAK,39) // Print Text String To VRAM Using Font At X,Y Position


Loop:
  j Loop
  nop // Delay Slot

RDRAMTEST:
  db "RDRAM Test:"

ADDRESS:
  db "Address:"

RESULT:
  db "Result:"

EXTENDEDRDRAM:
  db "Extended RDRAM"
TOTALRDRAM:
  db "Total RDRAM"

RDRAMREGISTER:
  db "RDRAM Register"

RDRAMDEVICETYPE:
  db "DEVICE_TYPE"

RDRAMDEVICEID:
  db "DEVICE_ID"

RDRAMDELAY:
  db "DELAY"

RDRAMMODE:
  db "MODE"

RDRAMREFINTERVAL:
  db "REF_INTERVAL"

RDRAMREFROW:
  db "REF_ROW"

RDRAMRASINTERVAL:
  db "RAS_INTERVAL"

RDRAMMININTERVAL:
  db "MIN_INTERVAL"

RDRAMADDRSELECT:
  db "ADDR_SELECT"

RDRAMDEVICEMANUF:
  db "DEVICE_MANUF"

DOLLAR:
  db "$"

MB:
  db "MB"

PAGEBREAK:
  db "--------------------------------------------------------------------------------"

align(8) // Align 64-Bit

RDWORD:
  dw 0

insert FontBlack, "FontBlack8x8.bin"
insert FontGreen, "FontGreen8x8.bin"
insert FontRed, "FontRed8x8.bin"