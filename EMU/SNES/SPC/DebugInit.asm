// Setup Frame Buffer
constant SCREEN_X(320)
constant SCREEN_Y(240)
constant BYTES_PER_PIXEL(4)

// Setup Characters
constant CHAR_X(8)
constant CHAR_Y(8)

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

  lui a0,$A010 // A0 = VRAM Start Offset
  la a1,$A0100000+((SCREEN_X*SCREEN_Y*BYTES_PER_PIXEL)-BYTES_PER_PIXEL) // A1 = VRAM End Offset
  ori t0,r0,$000000FF // T0 = Black
ClearScreen:
  sw t0,0(a0)
  bne a0,a1,ClearScreen
  addi a0,4 // Delay Slot

// CPU Instruction:
PrintString($A0100000,152,8,FontRed,CPUINSTRUCTION,15) // Print Text String To VRAM Using Font At X,Y Position
PrintString($A0100000,280,8,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// CPU Registers:
PrintString($A0100000,8,8,FontRed,CPUREGISTERS,13) // Print Text String To VRAM Using Font At X,Y Position

// A Register:
PrintString($A0100000,16,16,FontGreen,A_REG,0) // Print Text String To VRAM Using Font At X,Y Position
PrintString($A0100000,24,16,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// X Register:
PrintString($A0100000,56,16,FontGreen,X_REG,0) // Print Text String To VRAM Using Font At X,Y Position
PrintString($A0100000,64,16,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Y Register:
PrintString($A0100000,96,16,FontGreen,Y_REG,0) // Print Text String To VRAM Using Font At X,Y Position
PrintString($A0100000,104,16,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// PC Register:
PrintString($A0100000,136,16,FontGreen,PC_REG,1) // Print Text String To VRAM Using Font At X,Y Position
PrintString($A0100000,152,16,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// SP Register:
PrintString($A0100000,200,16,FontGreen,SP_REG,1) // Print Text String To VRAM Using Font At X,Y Position
PrintString($A0100000,216,16,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
PrintString($A0100000,224,16,FontBlack,SP1,0) // Print Text String To VRAM Using Font At X,Y Position

// PSW Register:
PrintString($A0100000,256,16,FontGreen,PSW_REG,2) // Print Text String To VRAM Using Font At X,Y Position
PrintString($A0100000,280,16,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position


// I/O Registers: ($00F0..$00FF)
PrintString($A0100000,8,32,FontRed,IOREGISTERS,28) // Print Text String To VRAM Using Font At X,Y Position

// Testing Functions:
PrintString($A0100000,24,40,FontGreen,TEST,3) // Print Text String To VRAM Using Font At X,Y Position
PrintString($A0100000,56,40,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Timer, I/O & ROM Control:
PrintString($A0100000,96,40,FontGreen,CTRL,3) // Print Text String To VRAM Using Font At X,Y Position
PrintString($A0100000,128,40,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// DSP Register Index:
PrintString($A0100000,160,40,FontGreen,DSPAD,4) // Print Text String To VRAM Using Font At X,Y Position
PrintString($A0100000,200,40,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// DSP Register Data:
PrintString($A0100000,232,40,FontGreen,DSPDA,4) // Print Text String To VRAM Using Font At X,Y Position
PrintString($A0100000,272,40,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// CPU Input & Output Register 0:
PrintString($A0100000,16,48,FontGreen,CPIO0,4) // Print Text String To VRAM Using Font At X,Y Position
PrintString($A0100000,56,48,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// CPU Input & Output Register 1:
PrintString($A0100000,88,48,FontGreen,CPIO1,4) // Print Text String To VRAM Using Font At X,Y Position
PrintString($A0100000,128,48,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// CPU Input & Output Register 2:
PrintString($A0100000,160,48,FontGreen,CPIO2,4) // Print Text String To VRAM Using Font At X,Y Position
PrintString($A0100000,200,48,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// CPU Input & Output Register 3:
PrintString($A0100000,232,48,FontGreen,CPIO3,4) // Print Text String To VRAM Using Font At X,Y Position
PrintString($A0100000,272,48,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// External I/O Port P4 (S-SMP Pins 34-27):
PrintString($A0100000,16,56,FontGreen,AXIO4,4) // Print Text String To VRAM Using Font At X,Y Position
PrintString($A0100000,56,56,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// External I/O Port P5 (S-SMP Pins 25-18):
PrintString($A0100000,88,56,FontGreen,AXIO5,4) // Print Text String To VRAM Using Font At X,Y Position
PrintString($A0100000,128,56,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Timer 0 Divider (8000Hz Clock Source):
PrintString($A0100000,160,56,FontGreen,T0DIV,4) // Print Text String To VRAM Using Font At X,Y Position
PrintString($A0100000,200,56,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Timer 1 Divider (8000Hz Clock Source):
PrintString($A0100000,232,56,FontGreen,T1DIV,4) // Print Text String To VRAM Using Font At X,Y Position
PrintString($A0100000,272,56,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Timer 2 Divider (64000Hz Clock Source):
PrintString($A0100000,16,64,FontGreen,T2DIV,4) // Print Text String To VRAM Using Font At X,Y Position
PrintString($A0100000,56,64,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Timer 0 Output:
PrintString($A0100000,88,64,FontGreen,T0OUT,4) // Print Text String To VRAM Using Font At X,Y Position
PrintString($A0100000,128,64,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Timer 1 Output:
PrintString($A0100000,160,64,FontGreen,T1OUT,4) // Print Text String To VRAM Using Font At X,Y Position
PrintString($A0100000,200,64,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Timer 2 Output:
PrintString($A0100000,232,64,FontGreen,T2OUT,4) // Print Text String To VRAM Using Font At X,Y Position
PrintString($A0100000,272,64,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position


// DSP Registers: Voice
PrintString($A0100000,8,80,FontRed,DSPREGISTERSVOICE,26) // Print Text String To VRAM Using Font At X,Y Position

// Voice Left / Right Volume:
PrintString($A0100000,16,88,FontGreen,VOLLR,4) // Print Text String To VRAM Using Font At X,Y Position

// Voice Pitch Scaler:
PrintString($A0100000,64,88,FontGreen,PITCH,4) // Print Text String To VRAM Using Font At X,Y Position

// Voice Source Number:
PrintString($A0100000,112,88,FontGreen,SRC,2) // Print Text String To VRAM Using Font At X,Y Position

// Voice ADSR Settings:
PrintString($A0100000,152,88,FontGreen,ADSR,3) // Print Text String To VRAM Using Font At X,Y Position

// Voice GAIN:
PrintString($A0100000,192,88,FontGreen,GAIN,3) // Print Text String To VRAM Using Font At X,Y Position

// Voice Current Envelope Value:
PrintString($A0100000,232,88,FontGreen,ENVX,3) // Print Text String To VRAM Using Font At X,Y Position

// Voice Current Sample Value:
PrintString($A0100000,272,88,FontGreen,OUTX,3) // Print Text String To VRAM Using Font At X,Y Position


// Voice 0:
PrintString($A0100000,8,96,FontRed,VOICE0,0) // Print Text String To VRAM Using Font At X,Y Position

// Voice 0 Left / Right Volume:
PrintString($A0100000,16,96,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Voice 0 Pitch Scaler:
PrintString($A0100000,64,96,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Voice 0 Source Number:
PrintString($A0100000,112,96,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Voice 0 ADSR Settings:
PrintString($A0100000,144,96,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Voice 0 GAIN Settings:
PrintString($A0100000,200,96,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Voice 0 Current Envelope Value:
PrintString($A0100000,240,96,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Voice 0 Current Sample Value:
PrintString($A0100000,280,96,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position


// Voice 1:
PrintString($A0100000,8,104,FontRed,VOICE1,0) // Print Text String To VRAM Using Font At X,Y Position

// Voice 1 Left / Right Volume:
PrintString($A0100000,16,104,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Voice 1 Pitch Scaler:
PrintString($A0100000,64,104,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Voice 1 Source Number:
PrintString($A0100000,112,104,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Voice 1 ADSR Settings:
PrintString($A0100000,144,104,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Voice 1 GAIN Settings:
PrintString($A0100000,200,104,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Voice 1 Current Envelope Value:
PrintString($A0100000,240,104,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Voice 1 Current Sample Value:
PrintString($A0100000,280,104,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position


// Voice 2:
PrintString($A0100000,8,112,FontRed,VOICE2,0) // Print Text String To VRAM Using Font At X,Y Position

// Voice 2 Left / Right Volume:
PrintString($A0100000,16,112,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Voice 2 Pitch Scaler:
PrintString($A0100000,64,112,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Voice 2 Source Number:
PrintString($A0100000,112,112,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Voice 2 ADSR Settings:
PrintString($A0100000,144,112,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Voice 2 GAIN Settings:
PrintString($A0100000,200,112,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Voice 2 Current Envelope Value:
PrintString($A0100000,240,112,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Voice 2 Current Sample Value:
PrintString($A0100000,280,112,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position


// Voice 3:
PrintString($A0100000,8,120,FontRed,VOICE3,0) // Print Text String To VRAM Using Font At X,Y Position

// Voice 3 Left / Right Volume:
PrintString($A0100000,16,120,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Voice 3 Pitch Scaler:
PrintString($A0100000,64,120,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Voice 3 Source Number:
PrintString($A0100000,112,120,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Voice 3 ADSR Settings:
PrintString($A0100000,144,120,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Voice 3 GAIN Settings:
PrintString($A0100000,200,120,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Voice 3 Current Envelope Value:
PrintString($A0100000,240,120,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Voice 3 Current Sample Value:
PrintString($A0100000,280,120,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position


// Voice 4:
PrintString($A0100000,8,128,FontRed,VOICE4,0) // Print Text String To VRAM Using Font At X,Y Position

// Voice 4 Left / Right Volume:
PrintString($A0100000,16,128,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Voice 4 Pitch Scaler:
PrintString($A0100000,64,128,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Voice 4 Source Number:
PrintString($A0100000,112,128,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Voice 4 ADSR Settings:
PrintString($A0100000,144,128,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Voice 4 GAIN Settings:
PrintString($A0100000,200,128,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Voice 4 Current Envelope Value:
PrintString($A0100000,240,128,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Voice 4 Current Sample Value:
PrintString($A0100000,280,128,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position


// Voice 5:
PrintString($A0100000,8,136,FontRed,VOICE5,0) // Print Text String To VRAM Using Font At X,Y Position

// Voice 5 Left / Right Volume:
PrintString($A0100000,16,136,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Voice 5 Pitch Scaler:
PrintString($A0100000,64,136,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Voice 5 Source Number:
PrintString($A0100000,112,136,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Voice 5 ADSR Settings:
PrintString($A0100000,144,136,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Voice 5 GAIN Settings:
PrintString($A0100000,200,136,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Voice 5 Current Envelope Value:
PrintString($A0100000,240,136,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Voice 5 Current Sample Value:
PrintString($A0100000,280,136,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position


// Voice 6:
PrintString($A0100000,8,144,FontRed,VOICE6,0) // Print Text String To VRAM Using Font At X,Y Position

// Voice 6 Left / Right Volume:
PrintString($A0100000,16,144,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Voice 6 Pitch Scaler:
PrintString($A0100000,64,144,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Voice 6 Source Number:
PrintString($A0100000,112,144,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Voice 6 ADSR Settings:
PrintString($A0100000,144,144,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Voice 6 GAIN Settings:
PrintString($A0100000,200,144,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Voice 6 Current Envelope Value:
PrintString($A0100000,240,144,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Voice 6 Current Sample Value:
PrintString($A0100000,280,144,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position


// Voice 7:
PrintString($A0100000,8,152,FontRed,VOICE7,0) // Print Text String To VRAM Using Font At X,Y Position

// Voice 7 Left / Right Volume:
PrintString($A0100000,16,152,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Voice 7 Pitch Scaler:
PrintString($A0100000,64,152,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Voice 7 Source Number:
PrintString($A0100000,112,152,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Voice 7 ADSR Settings:
PrintString($A0100000,144,152,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Voice 7 GAIN Settings:
PrintString($A0100000,200,152,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Voice 7 Current Envelope Value:
PrintString($A0100000,240,152,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Voice 7 Current Sample Value:
PrintString($A0100000,280,152,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position


// DSP Registers: Master
PrintString($A0100000,8,168,FontRed,DSPREGISTERSMASTER,20) // Print Text String To VRAM Using Font At X,Y Position

// Left Channel Master Volume:
PrintString($A0100000,16,176,FontGreen,MVOLL,4) // Print Text String To VRAM Using Font At X,Y Position
PrintString($A0100000,56,176,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Right Channel Master Volume:
PrintString($A0100000,88,176,FontGreen,MVOLR,4) // Print Text String To VRAM Using Font At X,Y Position
PrintString($A0100000,128,176,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Left Channel Echo Volume:
PrintString($A0100000,160,176,FontGreen,EVOLL,4) // Print Text String To VRAM Using Font At X,Y Position
PrintString($A0100000,200,176,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Right Channel Echo Volume:
PrintString($A0100000,232,176,FontGreen,EVOLR,4) // Print Text String To VRAM Using Font At X,Y Position
PrintString($A0100000,272,176,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position


// Voice 0..7 Key On Flags:
PrintString($A0100000,32,184,FontGreen,KON,2) // Print Text String To VRAM Using Font At X,Y Position
PrintString($A0100000,56,184,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Voice 0..7 Key Off Flags:
PrintString($A0100000,96,184,FontGreen,KOFF,3) // Print Text String To VRAM Using Font At X,Y Position
PrintString($A0100000,128,184,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// DSP Reset, Mute, Echo-Write Flags & Noise Clock:
PrintString($A0100000,176,184,FontGreen,FLG,2) // Print Text String To VRAM Using Font At X,Y Position
PrintString($A0100000,200,184,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Voice 0..7 End Flags:
PrintString($A0100000,240,184,FontGreen,ENDX,3) // Print Text String To VRAM Using Font At X,Y Position
PrintString($A0100000,272,184,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position


// Echo Feedback Volume:
PrintString($A0100000,32,192,FontGreen,EFB,2) // Print Text String To VRAM Using Font At X,Y Position
PrintString($A0100000,56,192,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Unused Byte (1 Byte Of General-Purpose RAM):
PrintString($A0100000,88,192,FontGreen,UNUSE,4) // Print Text String To VRAM Using Font At X,Y Position
PrintString($A0100000,128,192,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Voice 0..7 Pitch Modulation Enable Flags:
PrintString($A0100000,168,192,FontGreen,PMON,3) // Print Text String To VRAM Using Font At X,Y Position
PrintString($A0100000,200,192,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Voice 0..7 Noise Enable Flags:
PrintString($A0100000,248,192,FontGreen,NON,2) // Print Text String To VRAM Using Font At X,Y Position
PrintString($A0100000,272,192,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position


// Voice 0..7 Echo Enable Flags:
PrintString($A0100000,32,200,FontGreen,EON,2) // Print Text String To VRAM Using Font At X,Y Position
PrintString($A0100000,56,200,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Sample Table Address (DIR * $100):
PrintString($A0100000,104,200,FontGreen,DIR,2) // Print Text String To VRAM Using Font At X,Y Position
PrintString($A0100000,128,200,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Echo Ring Buffer Address (ESA * $100):
PrintString($A0100000,176,200,FontGreen,ESA,2) // Print Text String To VRAM Using Font At X,Y Position
PrintString($A0100000,200,200,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Echo Delay (Ring Buffer Size):
PrintString($A0100000,248,200,FontGreen,EDL,2) // Print Text String To VRAM Using Font At X,Y Position
PrintString($A0100000,272,200,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position


// Echo FIR Filter Coefficient 0:
PrintString($A0100000,24,208,FontGreen,FIR0,3) // Print Text String To VRAM Using Font At X,Y Position
PrintString($A0100000,56,208,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Echo FIR Filter Coefficient 1:
PrintString($A0100000,96,208,FontGreen,FIR1,3) // Print Text String To VRAM Using Font At X,Y Position
PrintString($A0100000,128,208,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Echo FIR Filter Coefficient 2:
PrintString($A0100000,168,208,FontGreen,FIR2,3) // Print Text String To VRAM Using Font At X,Y Position
PrintString($A0100000,200,208,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Echo FIR Filter Coefficient 3:
PrintString($A0100000,240,208,FontGreen,FIR3,3) // Print Text String To VRAM Using Font At X,Y Position
PrintString($A0100000,272,208,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Echo FIR Filter Coefficient 4:
PrintString($A0100000,24,216,FontGreen,FIR4,3) // Print Text String To VRAM Using Font At X,Y Position
PrintString($A0100000,56,216,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Echo FIR Filter Coefficient 5:
PrintString($A0100000,96,216,FontGreen,FIR5,3) // Print Text String To VRAM Using Font At X,Y Position
PrintString($A0100000,128,216,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Echo FIR Filter Coefficient 6:
PrintString($A0100000,168,216,FontGreen,FIR6,3) // Print Text String To VRAM Using Font At X,Y Position
PrintString($A0100000,200,216,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position

// Echo FIR Filter Coefficient 7:
PrintString($A0100000,240,216,FontGreen,FIR7,3) // Print Text String To VRAM Using Font At X,Y Position
PrintString($A0100000,272,216,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position


j DebugInitEnd
nop // Delay Slot

insert FontBlack, "FontBlack8x8.bin"
insert FontGreen, "FontGreen8x8.bin"
insert FontRed, "FontRed8x8.bin"

DOLLAR:
  db "$"

CPUINSTRUCTION:
  db "CPU INSTRUCTION:"

CPUREGISTERS:
  db "CPU REGISTERS:"
A_REG:
  db "A"
X_REG:
  db "X"
Y_REG:
  db "Y"
PC_REG:
  db "PC"
SP_REG:
  db "SP"
SP1:
  db "1"
PSW_REG:
  db "PSW"

IOREGISTERS:
  db "I/O REGISTERS: ($00F0..$00FF)"
TEST:
  db "TEST"
CTRL:
  db "CTRL"
DSPAD:
  db "DSPAD"
DSPDA:
  db "DSPDA"
CPIO0:
  db "CPIO0"
CPIO1:
  db "CPIO1"
CPIO2:
  db "CPIO2"
CPIO3:
  db "CPIO3"
AXIO4:
  db "AXIO4"
AXIO5:
  db "AXIO5"
T0DIV:
  db "T0DIV"
T1DIV:
  db "T1DIV"
T2DIV:
  db "T2DIV"
T0OUT:
  db "T0OUT"
T1OUT:
  db "T1OUT"
T2OUT:
  db "T2OUT"

DSPREGISTERSVOICE:
  db "DSP REGISTERS: VOICE (0..7)"
VOICE0:
  db "0"
VOICE1:
  db "1"
VOICE2:
  db "2"
VOICE3:
  db "3"
VOICE4:
  db "4"
VOICE5:
  db "5"
VOICE6:
  db "6"
VOICE7:
  db "7"
VOLLR:
  db "VOLLR"
PITCH:
  db "PITCH"
SRC:
  db "SRC"
ADSR:
  db "ADSR"
GAIN:
  db "GAIN"
ENVX:
  db "ENVX"
OUTX:
  db "OUTX"

DSPREGISTERSMASTER:
  db "DSP REGISTERS: MASTER"
MVOLL:
  db "MVOLL"
MVOLR:
  db "MVOLR"
EVOLL:
  db "EVOLL"
EVOLR:
  db "EVOLR"
KON:
  db "KON"
KOFF:
  db "KOFF"
FLG:
  db "FLG"
ENDX:
  db "ENDX"
EFB:
  db "EFB"
UNUSE:
  db "UNUSE"
PMON:
  db "PMON"
NON:
  db "NON"
EON:
  db "EON"
DIR:
  db "DIR"
ESA:
  db "ESA"
EDL:
  db "EDL"
FIR0:
  db "FIR0"
FIR1:
  db "FIR1"
FIR2:
  db "FIR2"
FIR3:
  db "FIR3"
FIR4:
  db "FIR4"
FIR5:
  db "FIR5"
FIR6:
  db "FIR6"
FIR7:
  db "FIR7"

align(4)
DebugInitEnd: