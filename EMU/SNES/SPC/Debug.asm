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

la a3,TEMPVALUE // A3 = TEMPVALUE RAM Offset

// CPU Instruction:
sb gp,0(a3) // TEMPVALUE = CPU Instruction
PrintValue($A0100000,288,8,FontBlack,TEMPVALUE,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// CPU Registers:

// A Register:
sb s0,0(a3) // TEMPVALUE = A_REG
PrintValue($A0100000,32,16,FontBlack,TEMPVALUE,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// X Register:
sb s1,0(a3) // TEMPVALUE = X_REG
PrintValue($A0100000,72,16,FontBlack,TEMPVALUE,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// Y Register:
sb s2,0(a3) // TEMPVALUE = Y_REG
PrintValue($A0100000,112,16,FontBlack,TEMPVALUE,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// PC Register:
sh s3,0(a3) // TEMPVALUE = PC_REG
PrintValue($A0100000,160,16,FontBlack,TEMPVALUE,1) // Print HEX Chars To VRAM Using Font At X,Y Position

// SP Register:
sb s4,0(a3) // TEMPVALUE = SP_REG
PrintValue($A0100000,232,16,FontBlack,TEMPVALUE,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// PSW Register:
sb s5,0(a3) // TEMPVALUE = Y_REG
PrintValue($A0100000,288,16,FontBlack,TEMPVALUE,0) // Print HEX Chars To VRAM Using Font At X,Y Position


// I/O Registers: ($00F0..$00FF)

// Testing Functions:
PrintValue($A0100000,64,40,FontBlack,MEM_MAP+REG_TEST,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// Timer, I/O & ROM Control:
PrintValue($A0100000,136,40,FontBlack,MEM_MAP+REG_CONTROL,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// DSP Register Index:
PrintValue($A0100000,208,40,FontBlack,MEM_MAP+REG_DSPADDR,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// DSP Register Data:
PrintValue($A0100000,280,40,FontBlack,MEM_MAP+REG_DSPDATA,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// CPU Input & Output Register 0:
PrintValue($A0100000,64,48,FontBlack,MEM_MAP+REG_CPUIO0,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// CPU Input & Output Register 1:
PrintValue($A0100000,136,48,FontBlack,MEM_MAP+REG_CPUIO1,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// CPU Input & Output Register 2:
PrintValue($A0100000,208,48,FontBlack,MEM_MAP+REG_CPUIO2,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// CPU Input & Output Register 3:
PrintValue($A0100000,280,48,FontBlack,MEM_MAP+REG_CPUIO3,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// External I/O Port P4 (S-SMP Pins 34-27):
PrintValue($A0100000,64,56,FontBlack,MEM_MAP+REG_AUXIO4,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// External I/O Port P5 (S-SMP Pins 25-18):
PrintValue($A0100000,136,56,FontBlack,MEM_MAP+REG_AUXIO5,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// Timer 0 Divider (8000Hz Clock Source):
PrintValue($A0100000,208,56,FontBlack,MEM_MAP+REG_T0DIV,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// Timer 1 Divider (8000Hz Clock Source):
PrintValue($A0100000,280,56,FontBlack,MEM_MAP+REG_T1DIV,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// Timer 2 Divider (64000Hz Clock Source):
PrintValue($A0100000,64,64,FontBlack,MEM_MAP+REG_T2DIV,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// Timer 0 Output:
PrintValue($A0100000,136,64,FontBlack,MEM_MAP+REG_T0OUT,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// Timer 1 Output:
PrintValue($A0100000,208,64,FontBlack,MEM_MAP+REG_T1OUT,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// Timer 2 Output:
PrintValue($A0100000,280,64,FontBlack,MEM_MAP+REG_T2OUT,0) // Print HEX Chars To VRAM Using Font At X,Y Position


// DSP Registers: Voice

// Voice 0:

// Voice 0 Left / Right Volume:
PrintValue($A0100000,24,96,FontBlack,DSP_MAP+DSP_V0VOLL,1) // Print HEX Chars To VRAM Using Font At X,Y Position

// Voice 0 Pitch Scaler:
PrintValue($A0100000,72,96,FontBlack,DSP_MAP+DSP_V0PITCHH,0) // Print HEX Chars To VRAM Using Font At X,Y Position
PrintValue($A0100000,88,96,FontBlack,DSP_MAP+DSP_V0PITCHL,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// Voice 0 Source Number:
PrintValue($A0100000,120,96,FontBlack,DSP_MAP+DSP_V0SRCN,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// Voice 0 ADSR Settings:
PrintValue($A0100000,152,96,FontBlack,DSP_MAP+DSP_V0ADSR1,1) // Print HEX Chars To VRAM Using Font At X,Y Position

// Voice 0 GAIN Settings:
PrintValue($A0100000,208,96,FontBlack,DSP_MAP+DSP_V0GAIN,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// Voice 0 Current Envelope Value:
PrintValue($A0100000,248,96,FontBlack,DSP_MAP+DSP_V0ENVX,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// Voice 0 Current Sample Value:
PrintValue($A0100000,288,96,FontBlack,DSP_MAP+DSP_V0OUTX,0) // Print HEX Chars To VRAM Using Font At X,Y Position


// Voice 1:

// Voice 1 Left / Right Volume:
PrintValue($A0100000,24,104,FontBlack,DSP_MAP+DSP_V1VOLL,1) // Print HEX Chars To VRAM Using Font At X,Y Position

// Voice 1 Pitch Scaler:
PrintValue($A0100000,72,104,FontBlack,DSP_MAP+DSP_V1PITCHH,0) // Print HEX Chars To VRAM Using Font At X,Y Position
PrintValue($A0100000,88,104,FontBlack,DSP_MAP+DSP_V1PITCHL,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// Voice 1 Source Number:
PrintValue($A0100000,120,104,FontBlack,DSP_MAP+DSP_V1SRCN,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// Voice 1 ADSR Settings:
PrintValue($A0100000,152,104,FontBlack,DSP_MAP+DSP_V1ADSR1,1) // Print HEX Chars To VRAM Using Font At X,Y Position

// Voice 1 GAIN Settings:
PrintValue($A0100000,208,104,FontBlack,DSP_MAP+DSP_V1GAIN,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// Voice 1 Current Envelope Value:
PrintValue($A0100000,248,104,FontBlack,DSP_MAP+DSP_V1ENVX,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// Voice 1 Current Sample Value:
PrintValue($A0100000,288,104,FontBlack,DSP_MAP+DSP_V1OUTX,0) // Print HEX Chars To VRAM Using Font At X,Y Position


// Voice 2:

// Voice 2 Left / Right Volume:
PrintValue($A0100000,24,112,FontBlack,DSP_MAP+DSP_V2VOLL,1) // Print HEX Chars To VRAM Using Font At X,Y Position

// Voice 2 Pitch Scaler:
PrintValue($A0100000,72,112,FontBlack,DSP_MAP+DSP_V2PITCHH,0) // Print HEX Chars To VRAM Using Font At X,Y Position
PrintValue($A0100000,88,112,FontBlack,DSP_MAP+DSP_V2PITCHL,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// Voice 2 Source Number:
PrintValue($A0100000,120,112,FontBlack,DSP_MAP+DSP_V2SRCN,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// Voice 2 ADSR Settings:
PrintValue($A0100000,152,112,FontBlack,DSP_MAP+DSP_V2ADSR1,1) // Print HEX Chars To VRAM Using Font At X,Y Position

// Voice 2 GAIN Settings:
PrintValue($A0100000,208,112,FontBlack,DSP_MAP+DSP_V2GAIN,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// Voice 2 Current Envelope Value:
PrintValue($A0100000,248,112,FontBlack,DSP_MAP+DSP_V2ENVX,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// Voice 2 Current Sample Value:
PrintValue($A0100000,288,112,FontBlack,DSP_MAP+DSP_V2OUTX,0) // Print HEX Chars To VRAM Using Font At X,Y Position


// Voice 3:

// Voice 3 Left / Right Volume:
PrintValue($A0100000,24,120,FontBlack,DSP_MAP+DSP_V3VOLL,1) // Print HEX Chars To VRAM Using Font At X,Y Position

// Voice 3 Pitch Scaler:
PrintValue($A0100000,72,120,FontBlack,DSP_MAP+DSP_V3PITCHH,0) // Print HEX Chars To VRAM Using Font At X,Y Position
PrintValue($A0100000,88,120,FontBlack,DSP_MAP+DSP_V3PITCHL,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// Voice 3 Source Number:
PrintValue($A0100000,120,120,FontBlack,DSP_MAP+DSP_V3SRCN,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// Voice 3 ADSR Settings:
PrintValue($A0100000,152,120,FontBlack,DSP_MAP+DSP_V3ADSR1,1) // Print HEX Chars To VRAM Using Font At X,Y Position

// Voice 3 GAIN Settings:
PrintValue($A0100000,208,120,FontBlack,DSP_MAP+DSP_V3GAIN,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// Voice 3 Current Envelope Value:
PrintValue($A0100000,248,120,FontBlack,DSP_MAP+DSP_V3ENVX,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// Voice 3 Current Sample Value:
PrintValue($A0100000,288,120,FontBlack,DSP_MAP+DSP_V3OUTX,0) // Print HEX Chars To VRAM Using Font At X,Y Position


// Voice 4:

// Voice 4 Left / Right Volume:
PrintValue($A0100000,24,128,FontBlack,DSP_MAP+DSP_V4VOLL,1) // Print HEX Chars To VRAM Using Font At X,Y Position

// Voice 4 Pitch Scaler:
PrintValue($A0100000,72,128,FontBlack,DSP_MAP+DSP_V4PITCHH,0) // Print HEX Chars To VRAM Using Font At X,Y Position
PrintValue($A0100000,88,128,FontBlack,DSP_MAP+DSP_V4PITCHL,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// Voice 4 Source Number:
PrintValue($A0100000,120,128,FontBlack,DSP_MAP+DSP_V4SRCN,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// Voice 4 ADSR Settings:
PrintValue($A0100000,152,128,FontBlack,DSP_MAP+DSP_V4ADSR1,1) // Print HEX Chars To VRAM Using Font At X,Y Position

// Voice 4 GAIN Settings:
PrintValue($A0100000,208,128,FontBlack,DSP_MAP+DSP_V4GAIN,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// Voice 4 Current Envelope Value:
PrintValue($A0100000,248,128,FontBlack,DSP_MAP+DSP_V4ENVX,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// Voice 4 Current Sample Value:
PrintValue($A0100000,288,128,FontBlack,DSP_MAP+DSP_V4OUTX,0) // Print HEX Chars To VRAM Using Font At X,Y Position


// Voice 5:

// Voice 5 Left / Right Volume:
PrintValue($A0100000,24,136,FontBlack,DSP_MAP+DSP_V5VOLL,1) // Print HEX Chars To VRAM Using Font At X,Y Position

// Voice 5 Pitch Scaler:
PrintValue($A0100000,72,136,FontBlack,DSP_MAP+DSP_V5PITCHH,0) // Print HEX Chars To VRAM Using Font At X,Y Position
PrintValue($A0100000,88,136,FontBlack,DSP_MAP+DSP_V5PITCHL,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// Voice 5 Source Number:
PrintValue($A0100000,120,136,FontBlack,DSP_MAP+DSP_V5SRCN,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// Voice 5 ADSR Settings:
PrintValue($A0100000,152,136,FontBlack,DSP_MAP+DSP_V5ADSR1,1) // Print HEX Chars To VRAM Using Font At X,Y Position

// Voice 5 GAIN Settings:
PrintValue($A0100000,208,136,FontBlack,DSP_MAP+DSP_V5GAIN,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// Voice 5 Current Envelope Value:
PrintValue($A0100000,248,136,FontBlack,DSP_MAP+DSP_V5ENVX,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// Voice 5 Current Sample Value:
PrintValue($A0100000,288,136,FontBlack,DSP_MAP+DSP_V5OUTX,0) // Print HEX Chars To VRAM Using Font At X,Y Position


// Voice 6:

// Voice 6 Left / Right Volume:
PrintValue($A0100000,24,144,FontBlack,DSP_MAP+DSP_V6VOLL,1) // Print HEX Chars To VRAM Using Font At X,Y Position

// Voice 6 Pitch Scaler:
PrintValue($A0100000,72,144,FontBlack,DSP_MAP+DSP_V6PITCHH,0) // Print HEX Chars To VRAM Using Font At X,Y Position
PrintValue($A0100000,88,144,FontBlack,DSP_MAP+DSP_V6PITCHL,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// Voice 6 Source Number:
PrintValue($A0100000,120,144,FontBlack,DSP_MAP+DSP_V6SRCN,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// Voice 6 ADSR Settings:
PrintValue($A0100000,152,144,FontBlack,DSP_MAP+DSP_V6ADSR1,1) // Print HEX Chars To VRAM Using Font At X,Y Position

// Voice 6 GAIN Settings:
PrintValue($A0100000,208,144,FontBlack,DSP_MAP+DSP_V6GAIN,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// Voice 6 Current Envelope Value:
PrintValue($A0100000,248,144,FontBlack,DSP_MAP+DSP_V6ENVX,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// Voice 6 Current Sample Value:
PrintValue($A0100000,288,144,FontBlack,DSP_MAP+DSP_V6OUTX,0) // Print HEX Chars To VRAM Using Font At X,Y Position


// Voice 7:

// Voice 7 Left / Right Volume:
PrintValue($A0100000,24,152,FontBlack,DSP_MAP+DSP_V7VOLL,1) // Print HEX Chars To VRAM Using Font At X,Y Position

// Voice 7 Pitch Scaler:
PrintValue($A0100000,72,152,FontBlack,DSP_MAP+DSP_V7PITCHH,0) // Print HEX Chars To VRAM Using Font At X,Y Position
PrintValue($A0100000,88,152,FontBlack,DSP_MAP+DSP_V7PITCHL,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// Voice 7 Source Number:
PrintValue($A0100000,120,152,FontBlack,DSP_MAP+DSP_V7SRCN,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// Voice 7 ADSR Settings:
PrintValue($A0100000,152,152,FontBlack,DSP_MAP+DSP_V7ADSR1,1) // Print HEX Chars To VRAM Using Font At X,Y Position

// Voice 7 GAIN Settings:
PrintValue($A0100000,208,152,FontBlack,DSP_MAP+DSP_V7GAIN,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// Voice 7 Current Envelope Value:
PrintValue($A0100000,248,152,FontBlack,DSP_MAP+DSP_V7ENVX,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// Voice 7 Current Sample Value:
PrintValue($A0100000,288,152,FontBlack,DSP_MAP+DSP_V7OUTX,0) // Print HEX Chars To VRAM Using Font At X,Y Position


// DSP Registers: Master

// Left Channel Master Volume:
PrintValue($A0100000,64,176,FontBlack,DSP_MAP+DSP_MVOLL,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// Right Channel Master Volume:
PrintValue($A0100000,136,176,FontBlack,DSP_MAP+DSP_MVOLR,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// Left Channel Echo Volume:
PrintValue($A0100000,208,176,FontBlack,DSP_MAP+DSP_EVOLL,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// Right Channel Echo Volume:
PrintValue($A0100000,280,176,FontBlack,DSP_MAP+DSP_EVOLR,0) // Print HEX Chars To VRAM Using Font At X,Y Position


// Voice 0..7 Key On Flags:
PrintValue($A0100000,64,184,FontBlack,DSP_MAP+DSP_KON,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// Voice 0..7 Key Off Flags:
PrintValue($A0100000,136,184,FontBlack,DSP_MAP+DSP_KOFF,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// DSP Reset, Mute, Echo-Write Flags & Noise Clock:
PrintValue($A0100000,208,184,FontBlack,DSP_MAP+DSP_FLG,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// Voice 0..7 End Flags:
PrintValue($A0100000,280,184,FontBlack,DSP_MAP+DSP_ENDX,0) // Print HEX Chars To VRAM Using Font At X,Y Position


// Echo Feedback Volume:
PrintValue($A0100000,64,192,FontBlack,DSP_MAP+DSP_EFB,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// Unused Byte (1 Byte Of General-Purpose RAM):
PrintValue($A0100000,136,192,FontBlack,DSP_MAP+DSP_UNUSED,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// Voice 0..7 Pitch Modulation Enable Flags:
PrintValue($A0100000,208,192,FontBlack,DSP_MAP+DSP_PMON,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// Voice 0..7 Noise Enable Flags:
PrintValue($A0100000,280,192,FontBlack,DSP_MAP+DSP_NON,0) // Print HEX Chars To VRAM Using Font At X,Y Position


// Voice 0..7 Echo Enable Flags:
PrintValue($A0100000,64,200,FontBlack,DSP_MAP+DSP_EON,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// Sample Table Address (DIR * $100):
PrintValue($A0100000,136,200,FontBlack,DSP_MAP+DSP_DIR,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// Echo Ring Buffer Address (ESA * $100):
PrintValue($A0100000,208,200,FontBlack,DSP_MAP+DSP_ESA,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// Echo Delay (Ring Buffer Size):
PrintValue($A0100000,280,200,FontBlack,DSP_MAP+DSP_EDL,0) // Print HEX Chars To VRAM Using Font At X,Y Position


// Echo FIR Filter Coefficient 0:
PrintValue($A0100000,64,208,FontBlack,DSP_MAP+DSP_FIR0,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// Echo FIR Filter Coefficient 1:
PrintValue($A0100000,136,208,FontBlack,DSP_MAP+DSP_FIR1,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// Echo FIR Filter Coefficient 2:
PrintValue($A0100000,208,208,FontBlack,DSP_MAP+DSP_FIR2,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// Echo FIR Filter Coefficient 3:
PrintValue($A0100000,280,208,FontBlack,DSP_MAP+DSP_FIR3,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// Echo FIR Filter Coefficient 4:
PrintValue($A0100000,64,216,FontBlack,DSP_MAP+DSP_FIR4,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// Echo FIR Filter Coefficient 5:
PrintValue($A0100000,136,216,FontBlack,DSP_MAP+DSP_FIR5,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// Echo FIR Filter Coefficient 6:
PrintValue($A0100000,208,216,FontBlack,DSP_MAP+DSP_FIR6,0) // Print HEX Chars To VRAM Using Font At X,Y Position

// Echo FIR Filter Coefficient 7:
PrintValue($A0100000,280,216,FontBlack,DSP_MAP+DSP_FIR7,0) // Print HEX Chars To VRAM Using Font At X,Y Position


j DebugEnd
nop // Delay Slot

TEMPVALUE:
  dd 0

DebugEnd:
la a0,MEM_MAP // A0 = MEM_MAP
la a1,CPU_INST // A1 = CPU Instruction Table