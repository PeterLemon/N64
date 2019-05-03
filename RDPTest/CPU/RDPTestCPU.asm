// N64 'Bare Metal' RDP Test CPU Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "RDPTestCPU.N64", create
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

  DPC(RDPBuffer, RDPBufferEnd) // Run DPC Command Buffer: Start, End


  PrintString($A0100000,8,8,FontRed,RDPTESTCPU,12) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,120,8,FontBlack,ADDRESS,7) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,192,8,FontGreen,RESULT,6) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,272,8,FontRed,TEST,4) // Print Text String To VRAM Using Font At X,Y Position


  PrintString($A0100000,0,16,FontBlack,PAGEBREAK,39) // Print Text String To VRAM Using Font At X,Y Position


  PrintString($A0100000,8,24,FontRed,DPCREGISTER,11) // Print Text String To VRAM Using Font At X,Y Position

  lui a3,DPC_BASE // A3 = RDRAM Base Register ($A4100000)
  la s0,RDWORD // S0 = RDRAM Word Address

  PrintString($A0100000,64,40,FontRed,START,4) // Print Text String To VRAM Using Font At X,Y Position
  addiu t0,a3,DPC_START // T0 = DPC: CMD DMA Start Register Address ($A4100000)
  sw t0,0(s0) // Store RDRAM Word Address
  PrintString($A0100000,112,40,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,120,40,FontBlack,RDWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  lw t0,DPC_START(a3) // T0 = RDRAM Register Word
  sw t0,0(s0) // Store RDRAM Word Address
  PrintString($A0100000,192,40,FontGreen,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,200,40,FontGreen,RDWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  lw t0,0(s0)      // T0 = Word Data
  la a0,STARTCHECK // A0 = Word Check Data Offset
  lw t1,0(a0)      // T1 = Word Check Data
  beq t0,t1,STARTPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,272,40,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j STARTEND
  nop // Delay Slot
  STARTPASS:
  PrintString($A0100000,272,40,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  STARTEND:

  PrintString($A0100000,80,56,FontRed,END,2) // Print Text String To VRAM Using Font At X,Y Position
  addiu t0,a3,DPC_END // T0 = DPC: CMD DMA End Register Address ($A4100004)
  sw t0,0(s0) // Store RDRAM Word Address
  PrintString($A0100000,112,56,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,120,56,FontBlack,RDWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  lw t0,DPC_END(a3) // T0 = RDRAM Register Word
  sw t0,0(s0) // Store RDRAM Word Address
  PrintString($A0100000,192,56,FontGreen,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,200,56,FontGreen,RDWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  lw t0,0(s0)    // T0 = Word Data
  la a0,ENDCHECK // A0 = Word Check Data Offset
  lw t1,0(a0)    // T1 = Word Check Data
  beq t0,t1,ENDPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,272,56,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j ENDEND
  nop // Delay Slot
  ENDPASS:
  PrintString($A0100000,272,56,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  ENDEND:

  PrintString($A0100000,48,72,FontRed,CURRENT,6) // Print Text String To VRAM Using Font At X,Y Position
  addiu t0,a3,DPC_CURRENT // T0 = DPC: CMD DMA Current Register Address ($A4100008)
  sw t0,0(s0) // Store RDRAM Word Address
  PrintString($A0100000,112,72,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,120,72,FontBlack,RDWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  lw t0,DPC_CURRENT(a3) // T0 = RDRAM Register Word
  sw t0,0(s0) // Store RDRAM Word Address
  PrintString($A0100000,192,72,FontGreen,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,200,72,FontGreen,RDWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  lw t0,0(s0)        // T0 = Word Data
  la a0,CURRENTCHECK // A0 = Word Check Data Offset
  lw t1,0(a0)        // T1 = Word Check Data
  beq t0,t1,CURRENTPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,272,72,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j CURRENTEND
  nop // Delay Slot
  CURRENTPASS:
  PrintString($A0100000,272,72,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  CURRENTEND:

  PrintString($A0100000,56,88,FontRed,STATUS,5) // Print Text String To VRAM Using Font At X,Y Position
  addiu t0,a3,DPC_STATUS // T0 = DPC: CMD Status Register Address ($A410000C)
  sw t0,0(s0) // Store RDRAM Word Address
  PrintString($A0100000,112,88,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,120,88,FontBlack,RDWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  lw t0,DPC_STATUS(a3) // T0 = RDRAM Register Word
  sw t0,0(s0) // Store RDRAM Word Address
  PrintString($A0100000,192,88,FontGreen,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,200,88,FontGreen,RDWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  lw t0,0(s0)       // T0 = Word Data
  la a0,STATUSCHECK // A0 = Word Check Data Offset
  lw t1,0(a0)       // T1 = Word Check Data
  beq t0,t1,STATUSPASS // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,272,88,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j STATUSEND
  nop // Delay Slot
  STATUSPASS:
  PrintString($A0100000,272,88,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  STATUSEND:

  PrintString($A0100000,64,104,FontRed,CLOCK,4) // Print Text String To VRAM Using Font At X,Y Position
  addiu t0,a3,DPC_CLOCK // T0 = DPC: Clock Counter Register Address ($A4100010)
  sw t0,0(s0) // Store RDRAM Word Address
  PrintString($A0100000,112,104,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,120,104,FontBlack,RDWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  lw t0,DPC_CLOCK(a3) // T0 = RDRAM Register Word
  sw t0,0(s0) // Store RDRAM Word Address
  PrintString($A0100000,192,104,FontGreen,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,200,104,FontGreen,RDWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,48,120,FontRed,BUFBUSY,6) // Print Text String To VRAM Using Font At X,Y Position
  addiu t0,a3,DPC_BUFBUSY // T0 = DPC: Buffer Busy Counter Register Address ($A4100014)
  sw t0,0(s0) // Store RDRAM Word Address
  PrintString($A0100000,112,120,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,120,120,FontBlack,RDWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  lw t0,DPC_BUFBUSY(a3) // T0 = RDRAM Register Word
  sw t0,0(s0) // Store RDRAM Word Address
  PrintString($A0100000,192,120,FontGreen,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,200,120,FontGreen,RDWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,40,136,FontRed,PIPEBUSY,7) // Print Text String To VRAM Using Font At X,Y Position
  addiu t0,a3,DPC_PIPEBUSY // T0 = DPC: Pipe Busy Counter Register Address ($A4100018)
  sw t0,0(s0) // Store RDRAM Word Address
  PrintString($A0100000,112,136,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,120,136,FontBlack,RDWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  lw t0,DPC_PIPEBUSY(a3) // T0 = RDRAM Register Word
  sw t0,0(s0) // Store RDRAM Word Address
  PrintString($A0100000,192,136,FontGreen,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,200,136,FontGreen,RDWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position

  PrintString($A0100000,72,152,FontRed,TMEM,3) // Print Text String To VRAM Using Font At X,Y Position
  addiu t0,a3,DPC_TMEM // T0 = DPC: TMEM Load Counter Register Address ($A410001C)
  sw t0,0(s0) // Store RDRAM Word Address
  PrintString($A0100000,112,152,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,120,152,FontBlack,RDWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position
  lw t0,DPC_TMEM(a3) // T0 = RDRAM Register Word
  sw t0,0(s0) // Store RDRAM Word Address
  PrintString($A0100000,192,152,FontGreen,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,200,152,FontGreen,RDWORD,3) // Print HEX Chars To VRAM Using Font At X,Y Position


  PrintString($A0100000,0,224,FontBlack,PAGEBREAK,39) // Print Text String To VRAM Using Font At X,Y Position


Loop:
  j Loop
  nop // Delay Slot

RDPTESTCPU:
  db "RDP Test CPU:"

ADDRESS:
  db "Address:"

RESULT:
  db "Result:"

TEST:
  db "TEST:"

FAIL:
  db "FAIL"
PASS:
  db "PASS"

DPCREGISTER:
  db "DPC Register"

START:
  db "START"

END:
  db "END"

CURRENT:
  db "CURRENT"

STATUS:
  db "STATUS"

CLOCK:
  db "CLOCK"

BUFBUSY:
  db "BUFBUSY"

PIPEBUSY:
  db "PIPEBUSY"

TMEM:
  db "TMEM"

DOLLAR:
  db "$"

PAGEBREAK:
  db "--------------------------------------------------------------------------------"

align(8) // Align 64-Bit

RDWORD:
  dw 0

STARTCHECK:
  dw $0001B070

ENDCHECK:
  dw $0001B0B0

CURRENTCHECK:
  dw $0001B0B0

STATUSCHECK:
  dw $00000080

insert FontBlack, "FontBlack8x8.bin"
insert FontGreen, "FontGreen8x8.bin"
insert FontRed, "FontRed8x8.bin"

align(8) // Align 64-Bit
RDPBuffer:
arch n64.rdp
  Set_Scissor 0<<2,0<<2, 0,0, 320<<2,240<<2 // Set Scissor: XH 0.0,YH 0.0, Scissor Field Enable Off,Field Off, XL 320.0,YL 240.0
  Set_Other_Modes CYCLE_TYPE_FILL // Set Other Modes
  Set_Color_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_32B,320-1, $00100000 // Set Color Image: FORMAT RGBA,SIZE 32B,WIDTH 320, DRAM ADDRESS $00100000
  Set_Fill_Color $000000FF // Set Fill Color: PACKED COLOR 32B R8G8B8A8 Pixel
  Fill_Rectangle 319<<2,239<<2, 0<<2,0<<2 // Fill Rectangle: XL 319.0,YL 239.0, XH 0.0,YH 0.0

  Set_Fill_Color $00FFFFFF // Set Fill Color: PACKED COLOR 32B R8G8B8A8 Pixel
  Fill_Rectangle 312<<2,224<<2, 192<<2,160<<2 // Fill Rectangle: XL 312.0,YL 224.0, XH 192.0,YH 160.0

  Sync_Full // Ensure Entire Scene Is Fully Drawn
RDPBufferEnd: