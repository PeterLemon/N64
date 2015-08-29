// N64 'Bare Metal' RDP Mode Input Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "RDPModeInput.N64", create
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
  include "LIB\N64_INPUT.INC" // Include Input Macros
  N64_INIT() // Run N64 Initialisation Routine

  ScreenNTSC(320, 240, BPP32, $A0100000) // Screen NTSC: 320x240, 32BPP, DRAM Origin $A0100000

  lui a0,$A010 // A0 = VRAM Start Offset
  la a1,$A0100000+((SCREEN_X*SCREEN_Y*BYTES_PER_PIXEL)-BYTES_PER_PIXEL) // A1 = VRAM End Offset
  lli t0,$000000FF // T0 = Black
ClearScreen:
  sw t0,0(a0)
  bne a0,a1,ClearScreen
  addi a0,4 // VRAM += 4
  
  InitController(PIF1) // Initialize Controller

  lli t9,0 // Reset T9 = Combine Mode Line Count (0..15)

Loop:
  WaitScanline($0) // Wait For Scanline To Reach Vertical Start
  WaitScanline($1E0) // Wait For Scanline To Reach Vertical Blank
  WaitScanline($0) // Wait For Scanline To Reach Vertical Start
  WaitScanline($1E0) // Wait For Scanline To Reach Vertical Blank
  WaitScanline($0) // Wait For Scanline To Reach Vertical Start
  WaitScanline($1E0) // Wait For Scanline To Reach Vertical Blank
  WaitScanline($0) // Wait For Scanline To Reach Vertical Start
  WaitScanline($1E0) // Wait For Scanline To Reach Vertical Blank
  WaitScanline($0) // Wait For Scanline To Reach Vertical Start
  WaitScanline($1E0) // Wait For Scanline To Reach Vertical Blank
  WaitScanline($0) // Wait For Scanline To Reach Vertical Start
  WaitScanline($1E0) // Wait For Scanline To Reach Vertical Blank
  WaitScanline($0) // Wait For Scanline To Reach Vertical Start
  WaitScanline($1E0) // Wait For Scanline To Reach Vertical Blank
  WaitScanline($0) // Wait For Scanline To Reach Vertical Start
  WaitScanline($1E0) // Wait For Scanline To Reach Vertical Blank

  ReadController(PIF2) // T0 = Controller Buttons, T1 = Analog X, T2 = Analog Y

  lli t8,0 // Reset T8 = INC/DEC
  lli t7,0 // Reset UP/DOWN

  andi t1,t0,JOY_UP // Test JOY UP
  beqz t1,Down
  nop // Delay Slot
  subi t9,1

  bgez t9,UpEnd
  nop // Delay Slot
  lli t9,55
  UpEnd:
  lli t7,1

Down:
  andi t1,t0,JOY_DOWN // Test JOY DOWN
  beqz t1,Left
  nop // Delay Slot
  addi t9,1

  lli t1,56
  bgt t1,t9,DownEnd
  nop // Delay Slot
  lli t9,0
  DownEnd:
  lli t7,1

Left:
  andi t1,t0,JOY_LEFT // Test JOY LEFT
  beqz t1,Right
  nop // Delay Slot
  lli t8,-1

Right:
  andi t1,t0,JOY_RIGHT // Test JOY RIGHT
  beqz t1,Render
  nop // Delay Slot
  lli t8,1

Render:
  // RDP Combine Mode
  //PrintValue($A0100000,0,0,FontGreen,$A0000000|(Combine&$3FFFFF),7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,0,0,FontGreen,CombineModeTEXT,11) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,0,8,FontRed,ADDA1TEXT,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,80,8,FontBlack,ADDA1MEM,0) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,0,16,FontRed,SUBBA1TEXT,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,80,16,FontBlack,SUBBA1MEM,0) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,0,24,FontRed,ADDR1TEXT,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,80,24,FontBlack,ADDR1MEM,0) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,0,32,FontRed,ADDA0TEXT,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,80,32,FontBlack,ADDA0MEM,0) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,0,40,FontRed,SUBBA0TEXT,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,80,40,FontBlack,SUBBA0MEM,0) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,0,48,FontRed,ADDR0TEXT,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,80,48,FontBlack,ADDR0MEM,0) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,0,56,FontRed,MULA1TEXT,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,80,56,FontBlack,MULA1MEM,0) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,0,64,FontRed,SUBAA1TEXT,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,80,64,FontBlack,SUBAA1MEM,0) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,0,72,FontRed,SUBBR1TEXT,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,80,72,FontBlack,SUBBR1MEM,0) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,0,80,FontRed,SUBBR0TEXT,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,80,80,FontBlack,SUBBR0MEM,0) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,0,88,FontRed,MULR1TEXT,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,80,88,FontBlack,MULR1MEM,0) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,0,96,FontRed,SUBAR1TEXT,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,80,96,FontBlack,SUBAR1MEM,0) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,0,104,FontRed,MULA0TEXT,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,80,104,FontBlack,MULA0MEM,0) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,0,112,FontRed,SUBAA0TEXT,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,80,112,FontBlack,SUBAA0MEM,0) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,0,120,FontRed,MULR0TEXT,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,80,120,FontBlack,MULR0MEM,0) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,0,128,FontRed,SUBAR0TEXT,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,80,128,FontBlack,SUBAR0MEM,0) // Print Text String To VRAM Using Font At X,Y Position

  // RDP Other Modes
  //PrintValue($A0100000,0,136,FontGreen,$A0000000|(Other&$3FFFFF),7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,0,136,FontGreen,OtherModesTEXT,11) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,0,144,FontRed,ALPHACOMPTEXT,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,80,144,FontBlack,ALPHACOMPMEM,0) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,0,152,FontRed,DITHALPHATEXT,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,80,152,FontBlack,DITHALPHAMEM,0) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,0,160,FontRed,ZSOURCETEXT,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,80,160,FontBlack,ZSOURCEMEM,0) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,0,168,FontRed,ANTIALIASTEXT,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,80,168,FontBlack,ANTIALIASMEM,0) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,0,176,FontRed,ZCOMPARETEXT,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,80,176,FontBlack,ZCOMPAREMEM,0) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,0,184,FontRed,ZUPDATETEXT,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,80,184,FontBlack,ZUPDATEMEM,0) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,0,192,FontRed,IMAGEREADTEXT,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,80,192,FontBlack,IMAGEREADMEM,0) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,0,200,FontRed,COLONCVGTEXT,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,80,200,FontBlack,COLONCVGMEM,0) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,0,208,FontRed,CVGDESTTEXT,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,80,208,FontBlack,CVGDESTMEM,0) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,0,216,FontRed,ZMODETEXT,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,80,216,FontBlack,ZMODEMEM,0) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,0,224,FontRed,CVGALPHATEXT,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,80,224,FontBlack,CVGALPHAMEM,0) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,224,0,FontGreen,OtherModesTEXT,11) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,240,8,FontRed,ALPHACVGTEXT,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,224,8,FontBlack,ALPHACVGMEM,0) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,240,16,FontRed,FORCEBLENDTEXT,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,224,16,FontBlack,FORCEBLENDMEM,0) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,240,24,FontRed,RESERVED0TEXT,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,224,24,FontBlack,RESERVED0MEM,0) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,240,32,FontRed,BM2B1TEXT,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,224,32,FontBlack,BM2B1MEM,0) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,240,40,FontRed,BM2B0TEXT,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,224,40,FontBlack,BM2B0MEM,0) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,240,48,FontRed,BM2A1TEXT,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,224,48,FontBlack,BM2A1MEM,0) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,240,56,FontRed,BM2A0TEXT,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,224,56,FontBlack,BM2A0MEM,0) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,240,64,FontRed,BM1B1TEXT,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,224,64,FontBlack,BM1B1MEM,0) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,240,72,FontRed,BM1B0TEXT,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,224,72,FontBlack,BM1B0MEM,0) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,240,80,FontRed,BM1A1TEXT,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,224,80,FontBlack,BM1A1MEM,0) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,240,88,FontRed,BM1A0TEXT,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,224,88,FontBlack,BM1A0MEM,0) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,240,96,FontRed,RESERVED1TEXT,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,224,96,FontBlack,RESERVED1MEM,0) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,240,104,FontRed,ALPHADITHTEXT,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,224,104,FontBlack,ALPHADITHMEM,0) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,240,112,FontRed,RGBDITHERTEXT,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,224,112,FontBlack,RGBDITHERMEM,0) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,240,120,FontRed,KEYENTEXT,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,224,120,FontBlack,KEYENMEM,0) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,240,128,FontRed,CONVONETEXT,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,224,128,FontBlack,CONVONEMEM,0) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,240,136,FontRed,BILERP1TEXT,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,224,136,FontBlack,BILERP1MEM,0) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,240,144,FontRed,BILERP0TEXT,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,224,144,FontBlack,BILERP0MEM,0) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,240,152,FontRed,MIDTEXELTEXT,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,224,152,FontBlack,MIDTEXELMEM,0) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,240,160,FontRed,SAMPLETYPETEXT,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,224,160,FontBlack,SAMPLETYPEMEM,0) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,240,168,FontRed,TLUTTYPETEXT,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,224,168,FontBlack,TLUTTYPEMEM,0) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,240,176,FontRed,ENTLUTTEXT,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,224,176,FontBlack,ENTLUTMEM,0) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,240,184,FontRed,TEXLODENTEXT,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,224,184,FontBlack,TEXLODENMEM,0) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,240,192,FontRed,SHARPENTEXTEXT,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,224,192,FontBlack,SHARPENTEXMEM,0) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,240,200,FontRed,DETAILTEXTEXT,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,224,200,FontBlack,DETAILTEXMEM,0) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,240,208,FontRed,PERSPTEXTEXT,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,224,208,FontBlack,PERSPTEXMEM,0) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,240,216,FontRed,CYCLETYPETEXT,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,224,216,FontBlack,CYCLETYPEMEM,0) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,240,224,FontRed,RESERVED2TEXT,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,224,224,FontBlack,RESERVED2MEM,0) // Print Text String To VRAM Using Font At X,Y Position

  PrintString($A0100000,240,232,FontRed,ATOMICPRIMTEXT,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,224,232,FontBlack,ATOMICPRIMMEM,0) // Print Text String To VRAM Using Font At X,Y Position


  lli t0,0
  bne t0,t9,CombineMode1
  nop // Delay Slot
  PrintString($A0100000,96,8,FontGreen,LEFTTEXT,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,ADDA1MEM
  lb t0,0(a0)
  add t0,t8
  andi t0,7
  sb t0,0(a0)

  la a0,$A0000000|(Combine&$3FFFFF) // A0 = Combine Mode DRAM Offset
  lw t1,4(a0)
  li t2,$FFFFFFF8
  and t1,t2
  sll t0,0
  or t1,t0
  sw t1,4(a0)
  j ModeEND

  CombineMode1:
  lli t0,1
  bne t0,t9,CombineMode2
  nop // Delay Slot
  PrintString($A0100000,96,16,FontGreen,LEFTTEXT,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,SUBBA1MEM
  lb t0,0(a0)
  add t0,t8
  andi t0,7
  sb t0,0(a0)

  la a0,$A0000000|(Combine&$3FFFFF) // A0 = Combine Mode DRAM Offset
  lw t1,4(a0)
  li t2,$FFFFFFC7
  and t1,t2
  sll t0,3
  or t1,t0
  sw t1,4(a0)
  j ModeEND

  CombineMode2:
  lli t0,2
  bne t0,t9,CombineMode3
  nop // Delay Slot
  PrintString($A0100000,96,24,FontGreen,LEFTTEXT,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,ADDR1MEM
  lb t0,0(a0)
  add t0,t8
  andi t0,7
  sb t0,0(a0)

  la a0,$A0000000|(Combine&$3FFFFF) // A0 = Combine Mode DRAM Offset
  lw t1,4(a0)
  li t2,$FFFFFE3F
  and t1,t2
  sll t0,6
  or t1,t0
  sw t1,4(a0)
  j ModeEND

  CombineMode3:
  lli t0,3
  bne t0,t9,CombineMode4
  nop // Delay Slot
  PrintString($A0100000,96,32,FontGreen,LEFTTEXT,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,ADDA0MEM
  lb t0,0(a0)
  add t0,t8
  andi t0,7
  sb t0,0(a0)

  la a0,$A0000000|(Combine&$3FFFFF) // A0 = Combine Mode DRAM Offset
  lw t1,4(a0)
  li t2,$FFFFF1FF
  and t1,t2
  sll t0,9
  or t1,t0
  sw t1,4(a0)
  j ModeEND

  CombineMode4:
  lli t0,4
  bne t0,t9,CombineMode5
  nop // Delay Slot
  PrintString($A0100000,96,40,FontGreen,LEFTTEXT,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,SUBBA0MEM
  lb t0,0(a0)
  add t0,t8
  andi t0,7
  sb t0,0(a0)

  la a0,$A0000000|(Combine&$3FFFFF) // A0 = Combine Mode DRAM Offset
  lw t1,4(a0)
  li t2,$FFFF8FFF
  and t1,t2
  sll t0,12
  or t1,t0
  sw t1,4(a0)
  j ModeEND

  CombineMode5:
  lli t0,5
  bne t0,t9,CombineMode6
  nop // Delay Slot
  PrintString($A0100000,96,48,FontGreen,LEFTTEXT,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,ADDR0MEM
  lb t0,0(a0)
  add t0,t8
  andi t0,7
  sb t0,0(a0)

  la a0,$A0000000|(Combine&$3FFFFF) // A0 = Combine Mode DRAM Offset
  lw t1,4(a0)
  li t2,$FFFC7FFF
  and t1,t2
  sll t0,15
  or t1,t0
  sw t1,4(a0)
  j ModeEND

  CombineMode6:
  lli t0,6
  bne t0,t9,CombineMode7
  nop // Delay Slot
  PrintString($A0100000,96,56,FontGreen,LEFTTEXT,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,MULA1MEM
  lb t0,0(a0)
  add t0,t8
  andi t0,7
  sb t0,0(a0)

  la a0,$A0000000|(Combine&$3FFFFF) // A0 = Combine Mode DRAM Offset
  lw t1,4(a0)
  li t2,$FFE3FFFF
  and t1,t2
  sll t0,18
  or t1,t0
  sw t1,4(a0)
  j ModeEND

  CombineMode7:
  lli t0,7
  bne t0,t9,CombineMode8
  nop // Delay Slot
  PrintString($A0100000,96,64,FontGreen,LEFTTEXT,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,SUBAA1MEM
  lb t0,0(a0)
  add t0,t8
  andi t0,7
  sb t0,0(a0)

  la a0,$A0000000|(Combine&$3FFFFF) // A0 = Combine Mode DRAM Offset
  lw t1,4(a0)
  li t2,$FF1FFFFF
  and t1,t2
  sll t0,21
  or t1,t0
  sw t1,4(a0)
  j ModeEND

  CombineMode8:
  lli t0,8
  bne t0,t9,CombineMode9
  nop // Delay Slot
  PrintString($A0100000,96,72,FontGreen,LEFTTEXT,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,SUBBR1MEM
  lb t0,0(a0)
  add t0,t8
  andi t0,$F
  sb t0,0(a0)

  la a0,$A0000000|(Combine&$3FFFFF) // A0 = Combine Mode DRAM Offset
  lw t1,4(a0)
  li t2,$F0FFFFFF
  and t1,t2
  sll t0,24
  or t1,t0
  sw t1,4(a0)
  j ModeEND

  CombineMode9:
  lli t0,9
  bne t0,t9,CombineMode10
  nop // Delay Slot
  PrintString($A0100000,96,80,FontGreen,LEFTTEXT,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,SUBBR0MEM
  lb t0,0(a0)
  add t0,t8
  andi t0,$F
  sb t0,0(a0)

  la a0,$A0000000|(Combine&$3FFFFF) // A0 = Combine Mode DRAM Offset
  lw t1,4(a0)
  li t2,$0FFFFFFF
  and t1,t2
  sll t0,28
  or t1,t0
  sw t1,4(a0)
  j ModeEND

  CombineMode10:
  lli t0,10
  bne t0,t9,CombineMode11
  nop // Delay Slot
  PrintString($A0100000,96,88,FontGreen,LEFTTEXT,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,MULR1MEM
  lb t0,0(a0)
  add t0,t8
  andi t0,$1F
  sb t0,0(a0)

  la a0,$A0000000|(Combine&$3FFFFF) // A0 = Combine Mode DRAM Offset
  lw t1,0(a0)
  li t2,$FFFFFFE0
  and t1,t2
  sll t0,0
  or t1,t0
  sw t1,0(a0)
  j ModeEND

  CombineMode11:
  lli t0,11
  bne t0,t9,CombineMode12
  nop // Delay Slot
  PrintString($A0100000,96,96,FontGreen,LEFTTEXT,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,SUBAR1MEM
  lb t0,0(a0)
  add t0,t8
  andi t0,$F
  sb t0,0(a0)

  la a0,$A0000000|(Combine&$3FFFFF) // A0 = Combine Mode DRAM Offset
  lw t1,0(a0)
  li t2,$FFFFFE1F
  and t1,t2
  sll t0,5
  or t1,t0
  sw t1,0(a0)
  j ModeEND

  CombineMode12:
  lli t0,12
  bne t0,t9,CombineMode13
  nop // Delay Slot
  PrintString($A0100000,96,104,FontGreen,LEFTTEXT,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,MULA0MEM
  lb t0,0(a0)
  add t0,t8
  andi t0,7
  sb t0,0(a0)

  la a0,$A0000000|(Combine&$3FFFFF) // A0 = Combine Mode DRAM Offset
  lw t1,0(a0)
  li t2,$FFFFF1FF
  and t1,t2
  sll t0,9
  or t1,t0
  sw t1,0(a0)
  j ModeEND

  CombineMode13:
  lli t0,13
  bne t0,t9,CombineMode14
  nop // Delay Slot
  PrintString($A0100000,96,112,FontGreen,LEFTTEXT,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,SUBAA0MEM
  lb t0,0(a0)
  add t0,t8
  andi t0,7
  sb t0,0(a0)

  la a0,$A0000000|(Combine&$3FFFFF) // A0 = Combine Mode DRAM Offset
  lw t1,0(a0)
  li t2,$FFFF8FFF
  and t1,t2
  sll t0,12
  or t1,t0
  sw t1,0(a0)
  j ModeEND

  CombineMode14:
  lli t0,14
  bne t0,t9,CombineMode15
  nop // Delay Slot
  PrintString($A0100000,96,120,FontGreen,LEFTTEXT,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,MULR0MEM
  lb t0,0(a0)
  add t0,t8
  andi t0,$1F
  sb t0,0(a0)

  la a0,$A0000000|(Combine&$3FFFFF) // A0 = Combine Mode DRAM Offset
  lw t1,0(a0)
  li t2,$FFF07FFF
  and t1,t2
  sll t0,15
  or t1,t0
  sw t1,0(a0)
  j ModeEND

  CombineMode15:
  lli t0,15
  bne t0,t9,OtherModes0
  nop // Delay Slot
  PrintString($A0100000,96,128,FontGreen,LEFTTEXT,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,SUBAR0MEM
  lb t0,0(a0)
  add t0,t8
  andi t0,$F
  sb t0,0(a0)

  la a0,$A0000000|(Combine&$3FFFFF) // A0 = Combine Mode DRAM Offset
  lw t1,0(a0)
  li t2,$FF0FFFFF
  and t1,t2
  sll t0,20
  or t1,t0
  sw t1,0(a0)
  j ModeEND

  OtherModes0:
  lli t0,16
  bne t0,t9,OtherModes1
  nop // Delay Slot
  PrintString($A0100000,96,144,FontGreen,LEFTTEXT,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,ALPHACOMPMEM
  lb t0,0(a0)
  add t0,t8
  andi t0,$1
  sb t0,0(a0)

  la a0,$A0000000|(Other&$3FFFFF) // A0 = Combine Mode DRAM Offset
  lw t1,4(a0)
  li t2,$FFFFFFFE
  and t1,t2
  sll t0,0
  or t1,t0
  sw t1,4(a0)
  j ModeEND

  OtherModes1:
  lli t0,17
  bne t0,t9,OtherModes2
  nop // Delay Slot
  PrintString($A0100000,96,152,FontGreen,LEFTTEXT,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,DITHALPHAMEM
  lb t0,0(a0)
  add t0,t8
  andi t0,$1
  sb t0,0(a0)

  la a0,$A0000000|(Other&$3FFFFF) // A0 = Combine Mode DRAM Offset
  lw t1,4(a0)
  li t2,$FFFFFFFD
  and t1,t2
  sll t0,1
  or t1,t0
  sw t1,4(a0)
  j ModeEND

  OtherModes2:
  lli t0,18
  bne t0,t9,OtherModes3
  nop // Delay Slot
  PrintString($A0100000,96,160,FontGreen,LEFTTEXT,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,ZSOURCEMEM
  lb t0,0(a0)
  add t0,t8
  andi t0,$1
  sb t0,0(a0)

  la a0,$A0000000|(Other&$3FFFFF) // A0 = Combine Mode DRAM Offset
  lw t1,4(a0)
  li t2,$FFFFFFFB
  and t1,t2
  sll t0,2
  or t1,t0
  sw t1,4(a0)
  j ModeEND

  OtherModes3:
  lli t0,19
  bne t0,t9,OtherModes4
  nop // Delay Slot
  PrintString($A0100000,96,168,FontGreen,LEFTTEXT,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,ANTIALIASMEM
  lb t0,0(a0)
  add t0,t8
  andi t0,$1
  sb t0,0(a0)

  la a0,$A0000000|(Other&$3FFFFF) // A0 = Combine Mode DRAM Offset
  lw t1,4(a0)
  li t2,$FFFFFFF7
  and t1,t2
  sll t0,3
  or t1,t0
  sw t1,4(a0)
  j ModeEND

  OtherModes4:
  lli t0,20
  bne t0,t9,OtherModes5
  nop // Delay Slot
  PrintString($A0100000,96,176,FontGreen,LEFTTEXT,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,ZCOMPAREMEM
  lb t0,0(a0)
  add t0,t8
  andi t0,$1
  sb t0,0(a0)

  la a0,$A0000000|(Other&$3FFFFF) // A0 = Combine Mode DRAM Offset
  lw t1,4(a0)
  li t2,$FFFFFFEF
  and t1,t2
  sll t0,4
  or t1,t0
  sw t1,4(a0)
  j ModeEND

  OtherModes5:
  lli t0,21
  bne t0,t9,OtherModes6
  nop // Delay Slot
  PrintString($A0100000,96,184,FontGreen,LEFTTEXT,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,ZUPDATEMEM
  lb t0,0(a0)
  add t0,t8
  andi t0,$1
  sb t0,0(a0)

  la a0,$A0000000|(Other&$3FFFFF) // A0 = Combine Mode DRAM Offset
  lw t1,4(a0)
  li t2,$FFFFFFDF
  and t1,t2
  sll t0,5
  or t1,t0
  sw t1,4(a0)
  j ModeEND

  OtherModes6:
  lli t0,22
  bne t0,t9,OtherModes7
  nop // Delay Slot
  PrintString($A0100000,96,192,FontGreen,LEFTTEXT,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,IMAGEREADMEM
  lb t0,0(a0)
  add t0,t8
  andi t0,$1
  sb t0,0(a0)

  la a0,$A0000000|(Other&$3FFFFF) // A0 = Combine Mode DRAM Offset
  lw t1,4(a0)
  li t2,$FFFFFFBF
  and t1,t2
  sll t0,6
  or t1,t0
  sw t1,4(a0)
  j ModeEND

  OtherModes7:
  lli t0,23
  bne t0,t9,OtherModes8
  nop // Delay Slot
  PrintString($A0100000,96,200,FontGreen,LEFTTEXT,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,COLONCVGMEM
  lb t0,0(a0)
  add t0,t8
  andi t0,$1
  sb t0,0(a0)

  la a0,$A0000000|(Other&$3FFFFF) // A0 = Combine Mode DRAM Offset
  lw t1,4(a0)
  li t2,$FFFFFF7F
  and t1,t2
  sll t0,7
  or t1,t0
  sw t1,4(a0)
  j ModeEND

  OtherModes8:
  lli t0,24
  bne t0,t9,OtherModes9
  nop // Delay Slot
  PrintString($A0100000,96,208,FontGreen,LEFTTEXT,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,CVGDESTMEM
  lb t0,0(a0)
  add t0,t8
  andi t0,$3
  sb t0,0(a0)

  la a0,$A0000000|(Other&$3FFFFF) // A0 = Combine Mode DRAM Offset
  lw t1,4(a0)
  li t2,$FFFFFCFF
  and t1,t2
  sll t0,8
  or t1,t0
  sw t1,4(a0)
  j ModeEND

  OtherModes9:
  lli t0,25
  bne t0,t9,OtherModes10
  nop // Delay Slot
  PrintString($A0100000,96,216,FontGreen,LEFTTEXT,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,ZMODEMEM
  lb t0,0(a0)
  add t0,t8
  andi t0,$3
  sb t0,0(a0)

  la a0,$A0000000|(Other&$3FFFFF) // A0 = Combine Mode DRAM Offset
  lw t1,4(a0)
  li t2,$FFFFF3FF
  and t1,t2
  sll t0,10
  or t1,t0
  sw t1,4(a0)
  j ModeEND

  OtherModes10:
  lli t0,26
  bne t0,t9,OtherModes11
  nop // Delay Slot
  PrintString($A0100000,96,224,FontGreen,LEFTTEXT,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,CVGALPHAMEM
  lb t0,0(a0)
  add t0,t8
  andi t0,$1
  sb t0,0(a0)

  la a0,$A0000000|(Other&$3FFFFF) // A0 = Combine Mode DRAM Offset
  lw t1,4(a0)
  li t2,$FFFFEFFF
  and t1,t2
  sll t0,12
  or t1,t0
  sw t1,4(a0)
  j ModeEND

  OtherModes11:
  lli t0,27
  bne t0,t9,OtherModes12
  nop // Delay Slot
  PrintString($A0100000,208,8,FontGreen,RIGHTTEXT,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,ALPHACVGMEM
  lb t0,0(a0)
  add t0,t8
  andi t0,$1
  sb t0,0(a0)

  la a0,$A0000000|(Other&$3FFFFF) // A0 = Combine Mode DRAM Offset
  lw t1,4(a0)
  li t2,$FFFFDFFF
  and t1,t2
  sll t0,13
  or t1,t0
  sw t1,4(a0)
  j ModeEND

  OtherModes12:
  lli t0,28
  bne t0,t9,OtherModes13
  nop // Delay Slot
  PrintString($A0100000,208,16,FontGreen,RIGHTTEXT,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,FORCEBLENDMEM
  lb t0,0(a0)
  add t0,t8
  andi t0,$1
  sb t0,0(a0)

  la a0,$A0000000|(Other&$3FFFFF) // A0 = Combine Mode DRAM Offset
  lw t1,4(a0)
  li t2,$FFFFBFFF
  and t1,t2
  sll t0,14
  or t1,t0
  sw t1,4(a0)
  j ModeEND

  OtherModes13:
  lli t0,29
  bne t0,t9,OtherModes14
  nop // Delay Slot
  PrintString($A0100000,208,24,FontGreen,RIGHTTEXT,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RESERVED0MEM
  lb t0,0(a0)
  add t0,t8
  andi t0,$1
  sb t0,0(a0)

  la a0,$A0000000|(Other&$3FFFFF) // A0 = Combine Mode DRAM Offset
  lw t1,4(a0)
  li t2,$FFFF7FFF
  and t1,t2
  sll t0,15
  or t1,t0
  sw t1,4(a0)
  j ModeEND

  OtherModes14:
  lli t0,30
  bne t0,t9,OtherModes15
  nop // Delay Slot
  PrintString($A0100000,208,32,FontGreen,RIGHTTEXT,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,BM2B1MEM
  lb t0,0(a0)
  add t0,t8
  andi t0,$3
  sb t0,0(a0)

  la a0,$A0000000|(Other&$3FFFFF) // A0 = Combine Mode DRAM Offset
  lw t1,4(a0)
  li t2,$FFFCFFFF
  and t1,t2
  sll t0,16
  or t1,t0
  sw t1,4(a0)
  j ModeEND

  OtherModes15:
  lli t0,31
  bne t0,t9,OtherModes16
  nop // Delay Slot
  PrintString($A0100000,208,40,FontGreen,RIGHTTEXT,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,BM2B0MEM
  lb t0,0(a0)
  add t0,t8
  andi t0,$3
  sb t0,0(a0)

  la a0,$A0000000|(Other&$3FFFFF) // A0 = Combine Mode DRAM Offset
  lw t1,4(a0)
  li t2,$FFF3FFFF
  and t1,t2
  sll t0,18
  or t1,t0
  sw t1,4(a0)
  j ModeEND

  OtherModes16:
  lli t0,32
  bne t0,t9,OtherModes17
  nop // Delay Slot
  PrintString($A0100000,208,48,FontGreen,RIGHTTEXT,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,BM2A1MEM
  lb t0,0(a0)
  add t0,t8
  andi t0,$3
  sb t0,0(a0)

  la a0,$A0000000|(Other&$3FFFFF) // A0 = Combine Mode DRAM Offset
  lw t1,4(a0)
  li t2,$FFCFFFFF
  and t1,t2
  sll t0,20
  or t1,t0
  sw t1,4(a0)
  j ModeEND

  OtherModes17:
  lli t0,33
  bne t0,t9,OtherModes18
  nop // Delay Slot
  PrintString($A0100000,208,56,FontGreen,RIGHTTEXT,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,BM2A0MEM
  lb t0,0(a0)
  add t0,t8
  andi t0,$3
  sb t0,0(a0)

  la a0,$A0000000|(Other&$3FFFFF) // A0 = Combine Mode DRAM Offset
  lw t1,4(a0)
  li t2,$FF3FFFFF
  and t1,t2
  sll t0,22
  or t1,t0
  sw t1,4(a0)
  j ModeEND

  OtherModes18:
  lli t0,34
  bne t0,t9,OtherModes19
  nop // Delay Slot
  PrintString($A0100000,208,64,FontGreen,RIGHTTEXT,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,BM1B1MEM
  lb t0,0(a0)
  add t0,t8
  andi t0,$3
  sb t0,0(a0)

  la a0,$A0000000|(Other&$3FFFFF) // A0 = Combine Mode DRAM Offset
  lw t1,4(a0)
  li t2,$FCFFFFFF
  and t1,t2
  sll t0,24
  or t1,t0
  sw t1,4(a0)
  j ModeEND

  OtherModes19:
  lli t0,35
  bne t0,t9,OtherModes20
  nop // Delay Slot
  PrintString($A0100000,208,72,FontGreen,RIGHTTEXT,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,BM1B0MEM
  lb t0,0(a0)
  add t0,t8
  andi t0,$3
  sb t0,0(a0)

  la a0,$A0000000|(Other&$3FFFFF) // A0 = Combine Mode DRAM Offset
  lw t1,4(a0)
  li t2,$F3FFFFFF
  and t1,t2
  sll t0,26
  or t1,t0
  sw t1,4(a0)
  j ModeEND

  OtherModes20:
  lli t0,36
  bne t0,t9,OtherModes21
  nop // Delay Slot
  PrintString($A0100000,208,80,FontGreen,RIGHTTEXT,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,BM1A1MEM
  lb t0,0(a0)
  add t0,t8
  andi t0,$3
  sb t0,0(a0)

  la a0,$A0000000|(Other&$3FFFFF) // A0 = Combine Mode DRAM Offset
  lw t1,4(a0)
  li t2,$CFFFFFFF
  and t1,t2
  sll t0,28
  or t1,t0
  sw t1,4(a0)
  j ModeEND

  OtherModes21:
  lli t0,37
  bne t0,t9,OtherModes22
  nop // Delay Slot
  PrintString($A0100000,208,88,FontGreen,RIGHTTEXT,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,BM1A0MEM
  lb t0,0(a0)
  add t0,t8
  andi t0,$3
  sb t0,0(a0)

  la a0,$A0000000|(Other&$3FFFFF) // A0 = Combine Mode DRAM Offset
  lw t1,4(a0)
  li t2,$3FFFFFFF
  and t1,t2
  sll t0,30
  or t1,t0
  sw t1,4(a0)
  j ModeEND

  OtherModes22:
  lli t0,38
  bne t0,t9,OtherModes23
  nop // Delay Slot
  PrintString($A0100000,208,96,FontGreen,RIGHTTEXT,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RESERVED1MEM
  lb t0,0(a0)
  add t0,t8
  andi t0,$F
  sb t0,0(a0)

  la a0,$A0000000|(Other&$3FFFFF) // A0 = Combine Mode DRAM Offset
  lw t1,0(a0)
  li t2,$FFFFFFF0
  and t1,t2
  sll t0,0
  or t1,t0
  sw t1,0(a0)
  j ModeEND

  OtherModes23:
  lli t0,39
  bne t0,t9,OtherModes24
  nop // Delay Slot
  PrintString($A0100000,208,104,FontGreen,RIGHTTEXT,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,ALPHADITHMEM
  lb t0,0(a0)
  add t0,t8
  andi t0,$3
  sb t0,0(a0)

  la a0,$A0000000|(Other&$3FFFFF) // A0 = Combine Mode DRAM Offset
  lw t1,0(a0)
  li t2,$FFFFFFCF
  and t1,t2
  sll t0,4
  or t1,t0
  sw t1,0(a0)
  j ModeEND

  OtherModes24:
  lli t0,40
  bne t0,t9,OtherModes25
  nop // Delay Slot
  PrintString($A0100000,208,112,FontGreen,RIGHTTEXT,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RGBDITHERMEM
  lb t0,0(a0)
  add t0,t8
  andi t0,$3
  sb t0,0(a0)

  la a0,$A0000000|(Other&$3FFFFF) // A0 = Combine Mode DRAM Offset
  lw t1,0(a0)
  li t2,$FFFFFF3F
  and t1,t2
  sll t0,6
  or t1,t0
  sw t1,0(a0)
  j ModeEND

  OtherModes25:
  lli t0,41
  bne t0,t9,OtherModes26
  nop // Delay Slot
  PrintString($A0100000,208,120,FontGreen,RIGHTTEXT,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,KEYENMEM
  lb t0,0(a0)
  add t0,t8
  andi t0,$1
  sb t0,0(a0)

  la a0,$A0000000|(Other&$3FFFFF) // A0 = Combine Mode DRAM Offset
  lw t1,0(a0)
  li t2,$FFFFFEFF
  and t1,t2
  sll t0,8
  or t1,t0
  sw t1,0(a0)
  j ModeEND

  OtherModes26:
  lli t0,42
  bne t0,t9,OtherModes27
  nop // Delay Slot
  PrintString($A0100000,208,128,FontGreen,RIGHTTEXT,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,CONVONEMEM
  lb t0,0(a0)
  add t0,t8
  andi t0,$1
  sb t0,0(a0)

  la a0,$A0000000|(Other&$3FFFFF) // A0 = Combine Mode DRAM Offset
  lw t1,0(a0)
  li t2,$FFFFFDFF
  and t1,t2
  sll t0,9
  or t1,t0
  sw t1,0(a0)
  j ModeEND

  OtherModes27:
  lli t0,43
  bne t0,t9,OtherModes28
  nop // Delay Slot
  PrintString($A0100000,208,136,FontGreen,RIGHTTEXT,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,BILERP1MEM
  lb t0,0(a0)
  add t0,t8
  andi t0,$1
  sb t0,0(a0)

  la a0,$A0000000|(Other&$3FFFFF) // A0 = Combine Mode DRAM Offset
  lw t1,0(a0)
  li t2,$FFFFFBFF
  and t1,t2
  sll t0,10
  or t1,t0
  sw t1,0(a0)
  j ModeEND

  OtherModes28:
  lli t0,44
  bne t0,t9,OtherModes29
  nop // Delay Slot
  PrintString($A0100000,208,144,FontGreen,RIGHTTEXT,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,BILERP0MEM
  lb t0,0(a0)
  add t0,t8
  andi t0,$1
  sb t0,0(a0)

  la a0,$A0000000|(Other&$3FFFFF) // A0 = Combine Mode DRAM Offset
  lw t1,0(a0)
  li t2,$FFFFF7FF
  and t1,t2
  sll t0,11
  or t1,t0
  sw t1,0(a0)
  j ModeEND

  OtherModes29:
  lli t0,45
  bne t0,t9,OtherModes30
  nop // Delay Slot
  PrintString($A0100000,208,152,FontGreen,RIGHTTEXT,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,MIDTEXELMEM
  lb t0,0(a0)
  add t0,t8
  andi t0,$1
  sb t0,0(a0)

  la a0,$A0000000|(Other&$3FFFFF) // A0 = Combine Mode DRAM Offset
  lw t1,0(a0)
  li t2,$FFFFEFFF
  and t1,t2
  sll t0,12
  or t1,t0
  sw t1,0(a0)
  j ModeEND

  OtherModes30:
  lli t0,46
  bne t0,t9,OtherModes31
  nop // Delay Slot
  PrintString($A0100000,208,160,FontGreen,RIGHTTEXT,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,SAMPLETYPEMEM
  lb t0,0(a0)
  add t0,t8
  andi t0,$1
  sb t0,0(a0)

  la a0,$A0000000|(Other&$3FFFFF) // A0 = Combine Mode DRAM Offset
  lw t1,0(a0)
  li t2,$FFFFDFFF
  and t1,t2
  sll t0,13
  or t1,t0
  sw t1,0(a0)
  j ModeEND

  OtherModes31:
  lli t0,47
  bne t0,t9,OtherModes32
  nop // Delay Slot
  PrintString($A0100000,208,168,FontGreen,RIGHTTEXT,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,TLUTTYPEMEM
  lb t0,0(a0)
  add t0,t8
  andi t0,$1
  sb t0,0(a0)

  la a0,$A0000000|(Other&$3FFFFF) // A0 = Combine Mode DRAM Offset
  lw t1,0(a0)
  li t2,$FFFFBFFF
  and t1,t2
  sll t0,14
  or t1,t0
  sw t1,0(a0)
  j ModeEND

  OtherModes32:
  lli t0,48
  bne t0,t9,OtherModes33
  nop // Delay Slot
  PrintString($A0100000,208,176,FontGreen,RIGHTTEXT,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,ENTLUTMEM
  lb t0,0(a0)
  add t0,t8
  andi t0,$1
  sb t0,0(a0)

  la a0,$A0000000|(Other&$3FFFFF) // A0 = Combine Mode DRAM Offset
  lw t1,0(a0)
  li t2,$FFFF7FFF
  and t1,t2
  sll t0,15
  or t1,t0
  sw t1,0(a0)
  j ModeEND

  OtherModes33:
  lli t0,49
  bne t0,t9,OtherModes34
  nop // Delay Slot
  PrintString($A0100000,208,184,FontGreen,RIGHTTEXT,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,TEXLODENMEM
  lb t0,0(a0)
  add t0,t8
  andi t0,$1
  sb t0,0(a0)

  la a0,$A0000000|(Other&$3FFFFF) // A0 = Combine Mode DRAM Offset
  lw t1,0(a0)
  li t2,$FFFEFFFF
  and t1,t2
  sll t0,16
  or t1,t0
  sw t1,0(a0)
  j ModeEND

  OtherModes34:
  lli t0,50
  bne t0,t9,OtherModes35
  nop // Delay Slot
  PrintString($A0100000,208,192,FontGreen,RIGHTTEXT,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,SHARPENTEXMEM
  lb t0,0(a0)
  add t0,t8
  andi t0,$1
  sb t0,0(a0)

  la a0,$A0000000|(Other&$3FFFFF) // A0 = Combine Mode DRAM Offset
  lw t1,0(a0)
  li t2,$FFFDFFFF
  and t1,t2
  sll t0,17
  or t1,t0
  sw t1,0(a0)
  j ModeEND

  OtherModes35:
  lli t0,51
  bne t0,t9,OtherModes36
  nop // Delay Slot
  PrintString($A0100000,208,200,FontGreen,RIGHTTEXT,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,DETAILTEXMEM
  lb t0,0(a0)
  add t0,t8
  andi t0,$1
  sb t0,0(a0)

  la a0,$A0000000|(Other&$3FFFFF) // A0 = Combine Mode DRAM Offset
  lw t1,0(a0)
  li t2,$FFFBFFFF
  and t1,t2
  sll t0,18
  or t1,t0
  sw t1,0(a0)
  j ModeEND

  OtherModes36:
  lli t0,52
  bne t0,t9,OtherModes37
  nop // Delay Slot
  PrintString($A0100000,208,208,FontGreen,RIGHTTEXT,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,PERSPTEXMEM
  lb t0,0(a0)
  add t0,t8
  andi t0,$1
  sb t0,0(a0)

  la a0,$A0000000|(Other&$3FFFFF) // A0 = Combine Mode DRAM Offset
  lw t1,0(a0)
  li t2,$FFF7FFFF
  and t1,t2
  sll t0,19
  or t1,t0
  sw t1,0(a0)
  j ModeEND

  OtherModes37:
  lli t0,53
  bne t0,t9,OtherModes38
  nop // Delay Slot
  PrintString($A0100000,208,216,FontGreen,RIGHTTEXT,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,CYCLETYPEMEM
  lb t0,0(a0)
  add t0,t8
  andi t0,$3
  sb t0,0(a0)

  la a0,$A0000000|(Other&$3FFFFF) // A0 = Combine Mode DRAM Offset
  lw t1,0(a0)
  li t2,$FFCFFFFF
  and t1,t2
  sll t0,20
  or t1,t0
  sw t1,0(a0)
  j ModeEND

  OtherModes38:
  lli t0,54
  bne t0,t9,OtherModes39
  nop // Delay Slot
  PrintString($A0100000,208,224,FontGreen,RIGHTTEXT,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RESERVED2MEM
  lb t0,0(a0)
  add t0,t8
  andi t0,$1
  sb t0,0(a0)

  la a0,$A0000000|(Other&$3FFFFF) // A0 = Combine Mode DRAM Offset
  lw t1,0(a0)
  li t2,$FFBFFFFF
  and t1,t2
  sll t0,22
  or t1,t0
  sw t1,0(a0)
  j ModeEND

  OtherModes39:
  lli t0,55
  bne t0,t9,ModeEND
  nop // Delay Slot
  PrintString($A0100000,208,232,FontGreen,RIGHTTEXT,1) // Print Text String To VRAM Using Font At X,Y Position
  la a0,ATOMICPRIMMEM
  lb t0,0(a0)
  add t0,t8
  andi t0,$1
  sb t0,0(a0)

  la a0,$A0000000|(Other&$3FFFFF) // A0 = Combine Mode DRAM Offset
  lw t1,0(a0)
  li t2,$FF7FFFFF
  and t1,t2
  sll t0,23
  or t1,t0
  sw t1,0(a0)

  ModeEND:
  bnez t7,ModeRender // IF (UP/DOWN != 0) Combine Mode Render
  nop // Delay Slot

  beqz t8,ModeSkip // IF (INC/DEC == 0) Combine Mode Skip
  nop // Delay Slot

  ModeRender:
  DPC(RDPBuffer, RDPBufferEnd) // Run DPC Command Buffer: Start Address, End Address
  ModeSkip:

  j Loop
  nop // Delay Slot

align(8) // Align 64-Bit
PIF1:
  dd $FF010401,0
  dd 0,0
  dd 0,0
  dd 0,0
  dd $FE000000,0
  dd 0,0
  dd 0,0
  dd 0,1

PIF2:
  fill 64 // Generate 64 Bytes Containing $00

align(8) // Align 64-Bit
RDPBuffer:
arch n64.rdp
  Set_Scissor 0<<2,0<<2, 0,0, 320<<2,240<<2 // Set Scissor: XH 0.0,YH 0.0, Scissor Field Enable Off,Field Off, XL 320.0,YL 240.0
  Set_Other_Modes CYCLE_TYPE_FILL // Set Other Modes
  Set_Color_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_32B,320-1, $00100000 // Set Color Image: FORMAT RGBA,SIZE 32B,WIDTH 320, DRAM ADDRESS $00100000
  Set_Fill_Color $000000FF // Set Fill Color: PACKED COLOR 32B R8G8B8A8 Pixel
  Fill_Rectangle 319<<2,239<<2, 0<<2,0<<2 // Fill Rectangle: XL 319.0,YL 239.0, XH 0.0,YH 0.0

Other: // RDP Set Other Modes DMEM Edited by Controller Input
  Set_Other_Modes EN_TLUT|SAMPLE_TYPE|BI_LERP_0|ALPHA_DITHER_SEL_NO_DITHER|B_M2B_0_2|B_M2A_0_1|FORCE_BLEND|IMAGE_READ_EN // Set Other Modes
Combine: // RDP Set Combine Mode DMEM Edited by Controller Input
  Set_Combine_Mode $0,$00, 0,0, $1,$07, $0,$F, 1,0, 0,0,0, 7,7,7 // Set Combine Mode: SubA RGB0,MulRGB0, SubA Alpha0,MulAlpha0, SubA RGB1,MulRGB1, SubB RGB0,SubB RGB1, SubA Alpha1,MulAlpha1, AddRGB0,SubB Alpha0,AddAlpha0, AddRGB1,SubB Alpha1,AddAlpha1

  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,1-1, TLUTG // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 1, DRAM ADDRESS TLUTG
  Set_Tile 0,0,0, $100, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: TMEM Address $100, Tile 0
  Load_Tlut 0<<2,0<<2, 0, 255<<2,0<<2 // Load Tlut: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 0.0
  Sync_Load // Sync Load

  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,40, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 40 (64bit Words), TMEM Address $000, Tile 0

  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, GRB // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS G Tile 0
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,6<<2, 0, 0<<2,0<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 6.0, Tile 0, XH 0.0,YH 0.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, GRB+(320*6) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS G Tile 1
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,12<<2, 0, 0<<2,6<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 12.0, Tile 0, XH 0.0,YH 6.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, GRB+((320*6)*2) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS G Tile 2
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,18<<2, 0, 0<<2,12<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 18.0, Tile 0, XH 0.0,YH 12.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, GRB+((320*6)*3) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS G Tile 3
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,24<<2, 0, 0<<2,18<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 24.0, Tile 0, XH 0.0,YH 18.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, GRB+((320*6)*4) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS G Tile 4
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,30<<2, 0, 0<<2,24<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 30.0, Tile 0, XH 0.0,YH 24.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, GRB+((320*6)*5) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS G Tile 5
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,36<<2, 0, 0<<2,30<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 36.0, Tile 0, XH 0.0,YH 30.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, GRB+((320*6)*6) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS G Tile 6
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,42<<2, 0, 0<<2,36<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 42.0, Tile 0, XH 0.0,YH 36.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, GRB+((320*6)*7) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS G Tile 7
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,48<<2, 0, 0<<2,42<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 48.0, Tile 0, XH 0.0,YH 42.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, GRB+((320*6)*8) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS G Tile 8
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,54<<2, 0, 0<<2,48<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 54.0, Tile 0, XH 0.0,YH 48.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, GRB+((320*6)*9) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS G Tile 9
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,60<<2, 0, 0<<2,54<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 60.0, Tile 0, XH 0.0,YH 54.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, GRB+((320*6)*10) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS G Tile 10
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,66<<2, 0, 0<<2,60<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 66.0, Tile 0, XH 0.0,YH 60.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, GRB+((320*6)*11) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS G Tile 11
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,72<<2, 0, 0<<2,66<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 72.0, Tile 0, XH 0.0,YH 66.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, GRB+((320*6)*12) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS G Tile 12
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,78<<2, 0, 0<<2,72<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 78.0, Tile 0, XH 0.0,YH 72.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, GRB+((320*6)*13) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS G Tile 13
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,84<<2, 0, 0<<2,78<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 84.0, Tile 0, XH 0.0,YH 78.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, GRB+((320*6)*14) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS G Tile 14
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,90<<2, 0, 0<<2,84<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 90.0, Tile 0, XH 0.0,YH 84.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, GRB+((320*6)*15) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS G Tile 15
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,96<<2, 0, 0<<2,90<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 96.0, Tile 0, XH 0.0,YH 90.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, GRB+((320*6)*16) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS G Tile 16
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,102<<2, 0, 0<<2,96<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 102.0, Tile 0, XH 0.0,YH 96.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, GRB+((320*6)*17) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS G Tile 17
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,108<<2, 0, 0<<2,102<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 108.0, Tile 0, XH 0.0,YH 102.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, GRB+((320*6)*18) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS G Tile 18
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,114<<2, 0, 0<<2,108<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 114.0, Tile 0, XH 0.0,YH 108.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, GRB+((320*6)*19) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS G Tile 19
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,120<<2, 0, 0<<2,114<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 120.0, Tile 0, XH 0.0,YH 114.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, GRB+((320*6)*20) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS G Tile 20
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,126<<2, 0, 0<<2,120<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 126.0, Tile 0, XH 0.0,YH 120.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, GRB+((320*6)*21) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS G Tile 21
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,132<<2, 0, 0<<2,126<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 132.0, Tile 0, XH 0.0,YH 126.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, GRB+((320*6)*22) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS G Tile 22
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,138<<2, 0, 0<<2,132<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 138.0, Tile 0, XH 0.0,YH 132.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, GRB+((320*6)*23) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS G Tile 23
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,144<<2, 0, 0<<2,138<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 144.0, Tile 0, XH 0.0,YH 138.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, GRB+((320*6)*24) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS G Tile 24
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,150<<2, 0, 0<<2,144<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 150.0, Tile 0, XH 0.0,YH 144.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, GRB+((320*6)*25) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS G Tile 25
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,156<<2, 0, 0<<2,150<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 156.0, Tile 0, XH 0.0,YH 150.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, GRB+((320*6)*26) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS G Tile 26
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,162<<2, 0, 0<<2,156<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 162.0, Tile 0, XH 0.0,YH 156.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, GRB+((320*6)*27) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS G Tile 27
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,168<<2, 0, 0<<2,162<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 168.0, Tile 0, XH 0.0,YH 162.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, GRB+((320*6)*28) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS G Tile 28
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,174<<2, 0, 0<<2,168<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 174.0, Tile 0, XH 0.0,YH 168.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, GRB+((320*6)*29) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS G Tile 29
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,180<<2, 0, 0<<2,174<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 180.0, Tile 0, XH 0.0,YH 174.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, GRB+((320*6)*30) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS G Tile 30
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,186<<2, 0, 0<<2,180<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 186.0, Tile 0, XH 0.0,YH 180.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, GRB+((320*6)*31) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS G Tile 31
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,192<<2, 0, 0<<2,186<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 192.0, Tile 0, XH 0.0,YH 186.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, GRB+((320*6)*32) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS G Tile 32
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,198<<2, 0, 0<<2,192<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 198.0, Tile 0, XH 0.0,YH 192.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, GRB+((320*6)*33) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS G Tile 33
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,204<<2, 0, 0<<2,198<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 204.0, Tile 0, XH 0.0,YH 198.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, GRB+((320*6)*34) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS G Tile 34
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,210<<2, 0, 0<<2,204<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 210.0, Tile 0, XH 0.0,YH 204.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, GRB+((320*6)*35) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS G Tile 35
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,216<<2, 0, 0<<2,210<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 216.0, Tile 0, XH 0.0,YH 210.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, GRB+((320*6)*36) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS G Tile 36
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,222<<2, 0, 0<<2,216<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 222.0, Tile 0, XH 0.0,YH 216.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, GRB+((320*6)*37) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS G Tile 37
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,228<<2, 0, 0<<2,222<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 228.0, Tile 0, XH 0.0,YH 222.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, GRB+((320*6)*38) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS G Tile 38
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,234<<2, 0, 0<<2,228<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 234.0, Tile 0, XH 0.0,YH 228.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, GRB+((320*6)*39) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS G Tile 39
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,240<<2, 0, 0<<2,234<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 240.0, Tile 0, XH 0.0,YH 234.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0


  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,1-1, TLUTR // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 1, DRAM ADDRESS TLUTR
  Set_Tile 0,0,0, $100, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: TMEM Address $100, Tile 0
  Load_Tlut 0<<2,0<<2, 0, 255<<2,0<<2 // Load Tlut: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 0.0
  Sync_Load // Sync Load

  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0

  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,160-1, GRB+((320*6)*40) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 160, DRAM ADDRESS R Tile 0
  Load_Tile 0<<2,0<<2, 0, 159<<2,11<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 159.0,TH 11.0
  Texture_Rectangle 320<<2,24<<2, 0, 0<<2,0<<2, 0<<5,0<<5, $200,$200 // Texture Rectangle: XL 320.0,YL 24.0, Tile 0, XH 0.0,YH 0.0, S 0.0,T 0.0, DSDX 0.5,DTDY 0.5

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,160-1, GRB+((320*6)*40)+(160*12) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 160, DRAM ADDRESS R Tile 1
  Load_Tile 0<<2,0<<2, 0, 159<<2,11<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 159.0,TH 11.0
  Texture_Rectangle 320<<2,48<<2, 0, 0<<2,24<<2, 0<<5,0<<5, $200,$200 // Texture Rectangle: XL 320.0,YL 48.0, Tile 0, XH 0.0,YH 24.0, S 0.0,T 0.0, DSDX 0.5,DTDY 0.5

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,160-1, GRB+((320*6)*40)+((160*12)*2) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 160, DRAM ADDRESS R Tile 2
  Load_Tile 0<<2,0<<2, 0, 159<<2,11<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 159.0,TH 11.0
  Texture_Rectangle 320<<2,72<<2, 0, 0<<2,48<<2, 0<<5,0<<5, $200,$200 // Texture Rectangle: XL 320.0,YL 72.0, Tile 0, XH 0.0,YH 48.0, S 0.0,T 0.0, DSDX 0.5,DTDY 0.5

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,160-1, GRB+((320*6)*40)+((160*12)*3) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 160, DRAM ADDRESS R Tile 3
  Load_Tile 0<<2,0<<2, 0, 159<<2,11<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 159.0,TH 11.0
  Texture_Rectangle 320<<2,96<<2, 0, 0<<2,72<<2, 0<<5,0<<5, $200,$200 // Texture Rectangle: XL 320.0,YL 96.0, Tile 0, XH 0.0,YH 72.0, S 0.0,T 0.0, DSDX 0.5,DTDY 0.5

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,160-1, GRB+((320*6)*40)+((160*12)*4) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 160, DRAM ADDRESS R Tile 4
  Load_Tile 0<<2,0<<2, 0, 159<<2,11<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 159.0,TH 11.0
  Texture_Rectangle 320<<2,120<<2, 0, 0<<2,96<<2, 0<<5,0<<5, $200,$200 // Texture Rectangle: XL 320.0,YL 120.0, Tile 0, XH 0.0,YH 96.0, S 0.0,T 0.0, DSDX 0.5,DTDY 0.5

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,160-1, GRB+((320*6)*40)+((160*12)*5) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 160, DRAM ADDRESS R Tile 5
  Load_Tile 0<<2,0<<2, 0, 159<<2,11<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 159.0,TH 11.0
  Texture_Rectangle 320<<2,144<<2, 0, 0<<2,120<<2, 0<<5,0<<5, $200,$200 // Texture Rectangle: XL 320.0,YL 144.0, Tile 0, XH 0.0,YH 120.0, S 0.0,T 0.0, DSDX 0.5,DTDY 0.5

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,160-1, GRB+((320*6)*40)+((160*12)*6) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 160, DRAM ADDRESS R Tile 6
  Load_Tile 0<<2,0<<2, 0, 159<<2,11<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 159.0,TH 11.0
  Texture_Rectangle 320<<2,168<<2, 0, 0<<2,144<<2, 0<<5,0<<5, $200,$200 // Texture Rectangle: XL 320.0,YL 168.0, Tile 0, XH 0.0,YH 144.0, S 0.0,T 0.0, DSDX 0.5,DTDY 0.5

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,160-1, GRB+((320*6)*40)+((160*12)*7) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 160, DRAM ADDRESS R Tile 7
  Load_Tile 0<<2,0<<2, 0, 159<<2,11<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 159.0,TH 11.0
  Texture_Rectangle 320<<2,192<<2, 0, 0<<2,168<<2, 0<<5,0<<5, $200,$200 // Texture Rectangle: XL 320.0,YL 192.0, Tile 0, XH 0.0,YH 168.0, S 0.0,T 0.0, DSDX 0.5,DTDY 0.5

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,160-1, GRB+((320*6)*40)+((160*12)*8) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 160, DRAM ADDRESS R Tile 8
  Load_Tile 0<<2,0<<2, 0, 159<<2,11<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 159.0,TH 11.0
  Texture_Rectangle 320<<2,216<<2, 0, 0<<2,192<<2, 0<<5,0<<5, $200,$200 // Texture Rectangle: XL 320.0,YL 216.0, Tile 0, XH 0.0,YH 192.0, S 0.0,T 0.0, DSDX 0.5,DTDY 0.5

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,160-1, GRB+((320*6)*40)+((160*12)*9) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 160, DRAM ADDRESS R Tile 9
  Load_Tile 0<<2,0<<2, 0, 159<<2,11<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 159.0,TH 11.0
  Texture_Rectangle 320<<2,240<<2, 0, 0<<2,216<<2, 0<<5,0<<5, $200,$200 // Texture Rectangle: XL 320.0,YL 240.0, Tile 0, XH 0.0,YH 216.0, S 0.0,T 0.0, DSDX 0.5,DTDY 0.5


  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,1-1, TLUTB // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 1, DRAM ADDRESS TLUTB
  Set_Tile 0,0,0, $100, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: TMEM Address $100, Tile 0
  Load_Tlut 0<<2,0<<2, 0, 255<<2,0<<2 // Load Tlut: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 0.0
  Sync_Load // Sync Load

  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,10, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 10 (64bit Words), TMEM Address $000, Tile 0

  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,80-1, GRB+((320*6)*40)+((160*12)*10) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 80, DRAM ADDRESS B Tile 0
  Load_Tile 0<<2,0<<2, 0, 79<<2,20<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 79.0,TH 20.0
  Texture_Rectangle 320<<2,80<<2, 0, 0<<2,0<<2, 0<<5,0<<5, $100,$100 // Texture Rectangle: XL 320.0,YL 80.0, Tile 0, XH 0.0,YH 0.0, S 0.0,T 0.0, DSDX 0.25,DTDY 0.25

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,80-1, GRB+((320*6)*40)+((160*12)*10)+(80*20) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 80, DRAM ADDRESS B Tile 1
  Load_Tile 0<<2,0<<2, 0, 79<<2,20<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 79.0,TH 20.0
  Texture_Rectangle 320<<2,160<<2, 0, 0<<2,80<<2, 0<<5,0<<5, $100,$100 // Texture Rectangle: XL 320.0,YL 160.0, Tile 0, XH 0.0,YH 80.0, S 0.0,T 0.0, DSDX 0.25,DTDY 0.25

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,80-1, GRB+((320*6)*40)+((160*12)*10)+((80*20)*2) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 80, DRAM ADDRESS B Tile 2
  Load_Tile 0<<2,0<<2, 0, 79<<2,20<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 79.0,TH 20.0
  Texture_Rectangle 320<<2,240<<2, 0, 0<<2,160<<2, 0<<5,0<<5, $100,$100 // Texture Rectangle: XL 320.0,YL 240.0, Tile 0, XH 0.0,YH 160.0, S 0.0,T 0.0, DSDX 0.25,DTDY 0.25

  Sync_Full // Ensure Entire Scene Is Fully Drawn
RDPBufferEnd:

insert GRB, "frame.grb"

TLUTG: // 256x16B = 512 Bytes
  dw $0001,$0001,$0001,$0001,$0001,$0001,$0001,$0001
  dw $0041,$0041,$0041,$0041,$0041,$0041,$0041,$0041
  dw $0081,$0081,$0081,$0081,$0081,$0081,$0081,$0081
  dw $00C1,$00C1,$00C1,$00C1,$00C1,$00C1,$00C1,$00C1
  dw $0101,$0101,$0101,$0101,$0101,$0101,$0101,$0101
  dw $0141,$0141,$0141,$0141,$0141,$0141,$0141,$0141
  dw $0181,$0181,$0181,$0181,$0181,$0181,$0181,$0181
  dw $01C1,$01C1,$01C1,$01C1,$01C1,$01C1,$01C1,$01C1
  dw $0201,$0201,$0201,$0201,$0201,$0201,$0201,$0201
  dw $0241,$0241,$0241,$0241,$0241,$0241,$0241,$0241
  dw $0281,$0281,$0281,$0281,$0281,$0281,$0281,$0281
  dw $02C1,$02C1,$02C1,$02C1,$02C1,$02C1,$02C1,$02C1
  dw $0301,$0301,$0301,$0301,$0301,$0301,$0301,$0301
  dw $0341,$0341,$0341,$0341,$0341,$0341,$0341,$0341
  dw $0381,$0381,$0381,$0381,$0381,$0381,$0381,$0381
  dw $03C1,$03C1,$03C1,$03C1,$03C1,$03C1,$03C1,$03C1
  dw $0401,$0401,$0401,$0401,$0401,$0401,$0401,$0401
  dw $0441,$0441,$0441,$0441,$0441,$0441,$0441,$0441
  dw $0481,$0481,$0481,$0481,$0481,$0481,$0481,$0481
  dw $04C1,$04C1,$04C1,$04C1,$04C1,$04C1,$04C1,$04C1
  dw $0501,$0501,$0501,$0501,$0501,$0501,$0501,$0501
  dw $0541,$0541,$0541,$0541,$0541,$0541,$0541,$0541
  dw $0581,$0581,$0581,$0581,$0581,$0581,$0581,$0581
  dw $05C1,$05C1,$05C1,$05C1,$05C1,$05C1,$05C1,$05C1
  dw $0601,$0601,$0601,$0601,$0601,$0601,$0601,$0601
  dw $0641,$0641,$0641,$0641,$0641,$0641,$0641,$0641
  dw $0681,$0681,$0681,$0681,$0681,$0681,$0681,$0681
  dw $06C1,$06C1,$06C1,$06C1,$06C1,$06C1,$06C1,$06C1
  dw $0701,$0701,$0701,$0701,$0701,$0701,$0701,$0701
  dw $0741,$0741,$0741,$0741,$0741,$0741,$0741,$0741
  dw $0781,$0781,$0781,$0781,$0781,$0781,$0781,$0781
  dw $07C1,$07C1,$07C1,$07C1,$07C1,$07C1,$07C1,$07C1

TLUTR: // 256x16B = 512 Bytes
  dw $0001,$0001,$0001,$0001,$0001,$0001,$0001,$0001
  dw $0801,$0801,$0801,$0801,$0801,$0801,$0801,$0801
  dw $1001,$1001,$1001,$1001,$1001,$1001,$1001,$1001
  dw $1801,$1801,$1801,$1801,$1801,$1801,$1801,$1801
  dw $2001,$2001,$2001,$2001,$2001,$2001,$2001,$2001
  dw $2801,$2801,$2801,$2801,$2801,$2801,$2801,$2801
  dw $3001,$3001,$3001,$3001,$3001,$3001,$3001,$3001
  dw $3801,$3801,$3801,$3801,$3801,$3801,$3801,$3801
  dw $4001,$4001,$4001,$4001,$4001,$4001,$4001,$4001
  dw $4801,$4801,$4801,$4801,$4801,$4801,$4801,$4801
  dw $5001,$5001,$5001,$5001,$5001,$5001,$5001,$5001
  dw $5801,$5801,$5801,$5801,$5801,$5801,$5801,$5801
  dw $6001,$6001,$6001,$6001,$6001,$6001,$6001,$6001
  dw $6801,$6801,$6801,$6801,$6801,$6801,$6801,$6801
  dw $7001,$7001,$7001,$7001,$7001,$7001,$7001,$7001
  dw $7801,$7801,$7801,$7801,$7801,$7801,$7801,$7801
  dw $8001,$8001,$8001,$8001,$8001,$8001,$8001,$8001
  dw $8801,$8801,$8801,$8801,$8801,$8801,$8801,$8801
  dw $9001,$9001,$9001,$9001,$9001,$9001,$9001,$9001
  dw $9801,$9801,$9801,$9801,$9801,$9801,$9801,$9801
  dw $A001,$A001,$A001,$A001,$A001,$A001,$A001,$A001
  dw $A801,$A801,$A801,$A801,$A801,$A801,$A801,$A801
  dw $B001,$B001,$B001,$B001,$B001,$B001,$B001,$B001
  dw $B801,$B801,$B801,$B801,$B801,$B801,$B801,$B801
  dw $C001,$C001,$C001,$C001,$C001,$C001,$C001,$C001
  dw $C801,$C801,$C801,$C801,$C801,$C801,$C801,$C801
  dw $D001,$D001,$D001,$D001,$D001,$D001,$D001,$D001
  dw $D801,$D801,$D801,$D801,$D801,$D801,$D801,$D801
  dw $E001,$E001,$E001,$E001,$E001,$E001,$E001,$E001
  dw $E801,$E801,$E801,$E801,$E801,$E801,$E801,$E801
  dw $F001,$F001,$F001,$F001,$F001,$F001,$F001,$F001
  dw $F801,$F801,$F801,$F801,$F801,$F801,$F801,$F801

TLUTB: // 256x16B = 512 Bytes
  dw $0001,$0001,$0001,$0001,$0001,$0001,$0001,$0001
  dw $0003,$0003,$0003,$0003,$0003,$0003,$0003,$0003
  dw $0005,$0005,$0005,$0005,$0005,$0005,$0005,$0005
  dw $0007,$0007,$0007,$0007,$0007,$0007,$0007,$0007
  dw $0009,$0009,$0009,$0009,$0009,$0009,$0009,$0009
  dw $000B,$000B,$000B,$000B,$000B,$000B,$000B,$000B
  dw $000D,$000D,$000D,$000D,$000D,$000D,$000D,$000D
  dw $000F,$000F,$000F,$000F,$000F,$000F,$000F,$000F
  dw $0011,$0011,$0011,$0011,$0011,$0011,$0011,$0011
  dw $0013,$0013,$0013,$0013,$0013,$0013,$0013,$0013
  dw $0015,$0015,$0015,$0015,$0015,$0015,$0015,$0015
  dw $0017,$0017,$0017,$0017,$0017,$0017,$0017,$0017
  dw $0019,$0019,$0019,$0019,$0019,$0019,$0019,$0019
  dw $001B,$001B,$001B,$001B,$001B,$001B,$001B,$001B
  dw $001D,$001D,$001D,$001D,$001D,$001D,$001D,$001D
  dw $001F,$001F,$001F,$001F,$001F,$001F,$001F,$001F
  dw $0021,$0021,$0021,$0021,$0021,$0021,$0021,$0021
  dw $0023,$0023,$0023,$0023,$0023,$0023,$0023,$0023
  dw $0025,$0025,$0025,$0025,$0025,$0025,$0025,$0025
  dw $0027,$0027,$0027,$0027,$0027,$0027,$0027,$0027
  dw $0029,$0029,$0029,$0029,$0029,$0029,$0029,$0029
  dw $002B,$002B,$002B,$002B,$002B,$002B,$002B,$002B
  dw $002D,$002D,$002D,$002D,$002D,$002D,$002D,$002D
  dw $002F,$002F,$002F,$002F,$002F,$002F,$002F,$002F
  dw $0031,$0031,$0031,$0031,$0031,$0031,$0031,$0031
  dw $0033,$0033,$0033,$0033,$0033,$0033,$0033,$0033
  dw $0035,$0035,$0035,$0035,$0035,$0035,$0035,$0035
  dw $0037,$0037,$0037,$0037,$0037,$0037,$0037,$0037
  dw $0039,$0039,$0039,$0039,$0039,$0039,$0039,$0039
  dw $003B,$003B,$003B,$003B,$003B,$003B,$003B,$003B
  dw $003D,$003D,$003D,$003D,$003D,$003D,$003D,$003D
  dw $003F,$003F,$003F,$003F,$003F,$003F,$003F,$003F

insert FontBlack, "FontBlack8x8.bin"
insert FontGreen, "FontGreen8x8.bin"
insert FontRed, "FontRed8x8.bin"

// RDP Combine Mode
ADDA1MEM:
  db 7   //    Adder Input, Alpha Components, Cycle 1 (Bit  0..2)
SUBBA1MEM:
  db 7   //    SUB_B Input, Alpha Components, Cycle 1 (Bit  3..5)
ADDR1MEM:
  db 7   //    Adder Input,   RGB Components, Cycle 1 (Bit  6..8)
ADDA0MEM:
  db 0   //    Adder Input, Alpha Components, Cycle 0 (Bit  9..11)
SUBBA0MEM:
  db 0   //    SUB_B Input, Alpha Components, Cycle 0 (Bit 12..14)
ADDR0MEM:
  db 0   //    Adder Input,   RGB Components, Cycle 0 (Bit 15..17)
MULA1MEM:
  db 0   // Multiply Input, Alpha Component,  Cycle 1 (Bit 18..20)
SUBAA1MEM:
  db 1   //    SUB_A Input, Alpha Component,  Cycle 1 (Bit 21..23)
SUBBR1MEM:
  db $F  //    SUB_B Input,   RGB Components, Cycle 1 (Bit 24..27)
SUBBR0MEM:
  db $0  //    SUB_B Input,   RGB Components, Cycle 0 (Bit 28..31)
MULR1MEM:
  db $07 // Multiply Input,   RGB Components, Cycle 1 (Bit 32..36)
SUBAR1MEM:
  db $1  //    SUB_A Input,   RGB Components, Cycle 1 (Bit 37..40)
MULA0MEM:
  db 0   // Multiply Input, Alpha Component,  Cycle 0 (Bit 41..43)
SUBAA0MEM:
  db 0   //    SUB_A Input, Alpha Component,  Cycle 0 (Bit 44..46)
MULR0MEM:
  db $00 // Multiply Input,   RGB Components, Cycle 0 (Bit 47..51)
SUBAR0MEM:
  db $0  //    SUB_A Input,   RGB Components, Cycle 0 (Bit 52..55)

CombineModeTEXT:
  db "Combine Mode"
ADDA1TEXT:
  db "  add,A,1:"
SUBBA1TEXT:
  db "sub_b,A,1:"
ADDR1TEXT:
  db "  add,R,1:"
ADDA0TEXT:
  db "  add,A,0:"
SUBBA0TEXT:
  db "sub_b,A,0:"
ADDR0TEXT:
  db "  add,R,0:"
MULA1TEXT:
  db "  mul,A,1:"
SUBAA1TEXT:
  db "sub_a,A,1:"
SUBBR1TEXT:
  db "sub_b,R,1:"
SUBBR0TEXT:
  db "sub_b,R,0:"
MULR1TEXT:
  db "  mul,R,1:"
SUBAR1TEXT:
  db "sub_a,R,1:"
MULA0TEXT:
  db "  mul,A,0:"
SUBAA0TEXT:
  db "sub_a,A,0:"
MULR0TEXT:
  db "  mul,R,0:"
SUBAR0TEXT:
  db "sub_a,R,0:"

// RDP Other Modes
ALPHACOMPMEM:
  db 0 // Set_Other_Modes A: Conditional Color Write On Alpha Compare (Bit 0)
DITHALPHAMEM:
  db 0 // Set_Other_Modes B: Use Random Noise In Alpha Compare, Otherwise Use Blend Alpha In Alpha Compare (Bit 1)
ZSOURCEMEM:
  db 0 // Set_Other_Modes C: Choose Between Primitive Z And Pixel Z (Bit 2)
ANTIALIASMEM:
  db 0 // Set_Other_Modes D: If Not Force Blend, Allow Blend Enable - Use CVG Bits (Bit 3)
ZCOMPAREMEM:
  db 0 // Set_Other_Modes E: Conditional Color Write Enable On Depth Comparison (Bit 4)
ZUPDATEMEM:
  db 0 // Set_Other_Modes F: Enable Writing Of Z If Color Write Enabled (Bit 5)
IMAGEREADMEM:
  db 1 // Set_Other_Modes G: Enable Color/CVG Read/Modify/Write Memory Access (Bit 6)
COLONCVGMEM:
  db 0 // Set_Other_Modes H: Only Update Color On Coverage Overflow (Transparent Surfaces) (Bit 7)
CVGDESTMEM:
  db 0 // Set_Other_Modes I: CVG Destination (Bit 8..9)
ZMODEMEM:
  db 0 // Set_Other_Modes J: Z Mode (Bit 10..11)
CVGALPHAMEM:
  db 0 // Set_Other_Modes K: Use CVG Times Alpha For Pixel Alpha And Coverage (Bit 12)
ALPHACVGMEM:
  db 0 // Set_Other_Modes L: Use CVG (Or CVG*Alpha) For Pixel Alpha (Bit 13)
FORCEBLENDMEM:
  db 1 // Set_Other_Modes M: Force Blend Enable (Bit 14)
RESERVED0MEM:
  db 0 // Set_Other_Modes N: This Mode Bit Is Not Currently Used, But May Be In The Future (Bit 15)
BM2B1MEM:
  db 0 // Set_Other_Modes O: Blend Modeword, Multiply 2b Input Select, Cycle 1 (Bit 16..17)
BM2B0MEM:
  db 2 // Set_Other_Modes P: Blend Modeword, Multiply 2b Input Select, Cycle 0 (Bit 18..19)
BM2A1MEM:
  db 0 // Set_Other_Modes Q: Blend Modeword, Multiply 2a Input Select, Cycle 1 (Bit 20..21)
BM2A0MEM:
  db 1 // Set_Other_Modes R: Blend Modeword, Multiply 2a Input Select, Cycle 0 (Bit 22..23)
BM1B1MEM:
  db 0 // Set_Other_Modes S: Blend Modeword, Multiply 1b Input Select, Cycle 1 (Bit 24..25)
BM1B0MEM:
  db 0 // Set_Other_Modes T: Blend Modeword, Multiply 1b Input Select, Cycle 0 (Bit 26..27)
BM1A1MEM:
  db 0 // Set_Other_Modes U: Blend Modeword, Multiply 1a Input Select, Cycle 1 (Bit 28..29)
BM1A0MEM:
  db 0 // Set_Other_Modes V: Blend Modeword, Multiply 1a Input Select, Cycle 0 (Bit 30..31)
RESERVED1MEM:
  db 0 // Set_Other_Modes: Reserved For Future Use, Default Value Is $F (Bit 32..35)
ALPHADITHMEM:
  db 3 // Set_Other_Modes V1: Alpha Dither Selection (Bit 36..37)
RGBDITHERMEM:
  db 0 // Set_Other_Modes V2:   RGB Dither Selection (Bit 38..39)
KEYENMEM:
  db 0 // Set_Other_Modes W: Enables Chroma Keying (Bit 40)
CONVONEMEM:
  db 0 // Set_Other_Modes X: Color Convert Texel That Was The Ouput Of The Texture Filter On Cycle0, Used To Qualify BI_LERP_1 (Bit 41)
BILERP1MEM:
  db 0 // Set_Other_Modes Y: 1=BI_LERP, 0=Color Convert Operation In Texture Filter. Used In Cycle 1 (Bit 42)
BILERP0MEM:
  db 1 // Set_Other_Modes Z: 1=BI_LERP, 0=Color Convert Operation In Texture Filter. Used In Cycle 0 (Bit 43)
MIDTEXELMEM:
  db 0 // Set_Other_Modes a: Indicates Texture Filter Should Do A 2x2 Half Texel Interpolation, Primarily Used For MPEG Motion Compensation Processing (Bit 44)
SAMPLETYPEMEM:
  db 1 // Set_Other_Modes b: Determines How Textures Are Sampled: 0=1x1 (Point Sample), 1=2x2. Note That Copy (Point Sample 4 Horizontally Adjacent Texels) Mode Is Indicated By CYCLE_TYPE (Bit 45)
TLUTTYPEMEM:
  db 0 // Set_Other_Modes c: Type Of Texels In Table, 0=16b RGBA(5/5/5/1), 1=IA(8/8) (Bit 46)
ENTLUTMEM:
  db 1 // Set_Other_Modes d: Enable Lookup Of Texel Values From TLUT. Meaningful If Texture Type Is Index, Tile Is In Low TMEM, TLUT Is In High TMEM, And Color Image Is RGB (Bit 47)
TEXLODENMEM:
  db 0 // Set_Other_Modes e: Enable Texture Level Of Detail (LOD) (Bit 48)
SHARPENTEXMEM:
  db 0 // Set_Other_Modes f: Enable Sharpened Texture (Bit 49)
DETAILTEXMEM:
  db 0 // Set_Other_Modes g: Enable Detail Texture (Bit 50)
PERSPTEXMEM:
  db 0 // Set_Other_Modes h: Enable Perspective Correction On Texture (Bit 51)
CYCLETYPEMEM:
  db 0 // Set_Other_Modes i: Display Pipeline Cycle Control Mode (Bit 52..53)
RESERVED2MEM:
  db 0 // Set_Other_Modes j: This Mode Bit Is Not Currently Used, But May Be In The Future (Bit 54)
ATOMICPRIMMEM:
  db 0 // Set_Other_Modes k: Force Primitive To Be Written To Frame Buffer Before Read Of Following Primitive (Bit 55)

OtherModesTEXT:
  db "Other Modes "
ALPHACOMPTEXT:
  db "ALPHA_COMP"
DITHALPHATEXT:
  db "DITH_ALPHA"
ZSOURCETEXT:
  db "  Z_SOURCE"
ANTIALIASTEXT:
  db " ANTIALIAS"
ZCOMPARETEXT:
  db " Z_COMPARE"
ZUPDATETEXT:
  db "  Z_UPDATE"
IMAGEREADTEXT:
  db "IMAGE_READ"
COLONCVGTEXT:
  db "COL_ON_CVG"
CVGDESTTEXT:
  db "  CVG_DEST"
ZMODETEXT:
  db "    Z_MODE"
CVGALPHATEXT:
  db " CVG*ALPHA"
ALPHACVGTEXT:
  db "ALPHA_CVG "
FORCEBLENDTEXT:
  db "FORCEBLEND"
RESERVED0TEXT:
  db "RESERVED_0"
BM2B1TEXT:
  db "B_M2B_1   "
BM2B0TEXT:
  db "B_M2B_0   "
BM2A1TEXT:
  db "B_M2A_1   "
BM2A0TEXT:
  db "B_M2A_0   "
BM1B1TEXT:
  db "B_M1B_1   "
BM1B0TEXT:
  db "B_M1B_0   "
BM1A1TEXT:
  db "B_M1A_1   "
BM1A0TEXT:
  db "B_M1A_0   "
RESERVED1TEXT:
  db "RESERVED_1"
ALPHADITHTEXT:
  db "ALPHA_DITH"
RGBDITHERTEXT:
  db "RGB_DITHER"
KEYENTEXT:
  db "KEY_EN    "
CONVONETEXT:
  db "CONV_ONE  "
BILERP1TEXT:
  db "BI_LERP_1 "
BILERP0TEXT:
  db "BI_LERP_0 "
MIDTEXELTEXT:
  db "MID_TEXEL "
SAMPLETYPETEXT:
  db "SAMPLETYPE"
TLUTTYPETEXT:
  db "TLUT_TYPE "
ENTLUTTEXT:
  db "EN_TLUT   "
TEXLODENTEXT:
  db "TEX_LOD_EN"
SHARPENTEXTEXT:
  db "SHARPENTEX"
DETAILTEXTEXT:
  db "DETAIL_TEX"
PERSPTEXTEXT:
  db "PERSP_TEX "
CYCLETYPETEXT:
  db "CYCLE_TYPE"
RESERVED2TEXT:
  db "RESERVED_2"
ATOMICPRIMTEXT:
  db "ATOMICPRIM"

LEFTTEXT:
  db "<-"
RIGHTTEXT:
  db "->"