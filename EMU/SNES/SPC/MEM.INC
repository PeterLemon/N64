//============= (Key: R=Read, W=Write)
// SNES SPC700
//=============
// Memory Map (64 KBytes Allocated For SPC-700 Memory Map)
constant SPCPAGE0($0000)    // RAM Page 0 (Typically Used For CPU Pointers/Variables)  240B/RW
// $00F0..$00FF - I/O Ports (Writes Are Also Passed To RAM)
constant SPCPAGE1($0100)    // RAM Page 1 (Typically Used For CPU Stack)               256B/RW
constant SPCRAM($0200)      // RAM (Code, Data, Dir-Table, BRR-Samples, Echo-Buffer) 64960B/RW
constant SPCIPL($FFC0)      // 64-Byte IPL Boot ROM Or RAM (Selectable Via Port $00F1)  64B/RW

// I/O Ports (CPU Includes 16 Memory Mapper Ports At Address $00F0..$00FF)
constant REG_TEST($F0)      // Testing Functions                                         1B/W
constant REG_CONTROL($F1)   // Timer, I/O & ROM Control                                  1B/W
constant REG_DSPADDR($F2)   // DSP Register Index                                        1B/RW
constant REG_DSPDATA($F3)   // DSP Register Data                                         1B/RW
constant REG_CPUIO0($F4)    // CPU Input & Output Register 0                             1B/W
constant REG_CPUIO1($F5)    // CPU Input & Output Register 1                             1B/W
constant REG_CPUIO2($F6)    // CPU Input & Output Register 2                             1B/W
constant REG_CPUIO3($F7)    // CPU Input & Output Register 3                             1B/W
constant REG_AUXIO4($F8)    // External I/O Port P4 (S-SMP Pins 34-27)                   1B/RW
constant REG_AUXIO5($F9)    // External I/O Port P5 (S-SMP Pins 25-18)                   1B/RW
constant REG_T0DIV($FA)     // Timer 0 Divider  (8000Hz Clock Source)                    1B/W
constant REG_T1DIV($FB)     // Timer 1 Divider  (8000Hz Clock Source)                    1B/W
constant REG_T2DIV($FC)     // Timer 2 Divider (64000Hz Clock Source)                    1B/W
constant REG_T0OUT($FD)     // Timer 0 Output                                            1B/R
constant REG_T1OUT($FE)     // Timer 1 Output                                            1B/R
constant REG_T2OUT($FF)     // Timer 2 Output                                            1B/R

// DSP Map (128 Bytes Allocated For SPC-700 DSP Register Map)
// DSP Registers (128 DSP Registers Are Indirectly Accessed Via I/O Ports $00F2/$00F3)
constant DSP_MVOLL($0C)     // Left  Channel Master Volume                               1B/RW
constant DSP_MVOLR($1C)     // Right Channel Master Volume                               1B/RW
constant DSP_EVOLL($2C)     // Left  Channel Echo   Volume                               1B/RW
constant DSP_EVOLR($3C)     // Right Channel Echo   Volume                               1B/RW
constant DSP_KON($4C)       // Voice 0..7 Key On  Flags                                  1B/W
constant DSP_KOFF($5C)      // Voice 0..7 Key Off Flags                                  1B/RW
constant DSP_FLG($6C)       // DSP Reset, Mute, Echo-Write Flags & Noise Clock           1B/RW
constant DSP_ENDX($7C)      // Voice 0..7 End Flags                                      1B/R

constant DSP_EFB($0D)       // Echo Feedback Volume                                      1B/RW
constant DSP_UNUSED($1D)    // Unused Byte (1 Byte Of General-Purpose RAM)               1B/RW
constant DSP_PMON($2D)      // Voice 0..7 Pitch Modulation Enable Flags                  1B/RW
constant DSP_NON($3D)       // Voice 0..7 Noise Enable Flags                             1B/RW
constant DSP_EON($4D)       // Voice 0..7 Echo  Enable Flags                             1B/RW
constant DSP_DIR($5D)       // Sample Table Address     (DIR * $100)                     1B/RW
constant DSP_ESA($6D)       // Echo Ring Buffer Address (ESA * $100)                     1B/RW
constant DSP_EDL($7D)       // Echo Delay (Ring Buffer Size)                             1B/RW

constant DSP_FIR0($0F)      // Echo FIR Filter Coefficient 0                             1B/RW
constant DSP_FIR1($1F)      // Echo FIR Filter Coefficient 1                             1B/RW
constant DSP_FIR2($2F)      // Echo FIR Filter Coefficient 2                             1B/RW
constant DSP_FIR3($3F)      // Echo FIR Filter Coefficient 3                             1B/RW
constant DSP_FIR4($4F)      // Echo FIR Filter Coefficient 4                             1B/RW
constant DSP_FIR5($5F)      // Echo FIR Filter Coefficient 5                             1B/RW
constant DSP_FIR6($6F)      // Echo FIR Filter Coefficient 6                             1B/RW
constant DSP_FIR7($7F)      // Echo FIR Filter Coefficient 7                             1B/RW

constant DSP_V0VOLL($00)    // Voice 0 Left  Volume                                      1B/RW
constant DSP_V0VOLR($01)    // Voice 0 Right Volume                                      1B/RW
constant DSP_V0PITCHL($02)  // Voice 0 Pitch Scaler  (Lower 8bit)                        2B/RW
constant DSP_V0PITCHH($03)  // Voice 0 Pitch Scaler  (Upper 6bit)                        1B/RW
constant DSP_V0SRCN($04)    // Voice 0 Source Number (0-255)                             1B/RW
constant DSP_V0ADSR1($05)   // Voice 0 ADSR Settings (Lower 8bit)                        2B/RW
constant DSP_V0ADSR2($06)   // Voice 0 ADSR Settings (Upper 8bit)                        1B/RW
constant DSP_V0GAIN($07)    // Voice 0 Gain Settings                                     1B/RW
constant DSP_V0ENVX($08)    // Voice 0 Current Envelope Value                            1B/R
constant DSP_V0OUTX($09)    // Voice 0 Current Sample   Value                            1B/R
constant DSP_V0UNUSEDA($0A) // Voice 0 Unused Byte A (1 Byte Of General-Purpose RAM)     1B/RW
constant DSP_V0UNUSEDB($0B) // Voice 0 Unused Byte B (1 Byte Of General-Purpose RAM)     1B/RW
constant DSP_V0UNUSEDC($0E) // Voice 0 Unused Byte C (1 Byte Of General-Purpose RAM)     1B/RW

constant DSP_V1VOLL($10)    // Voice 1 Left  Volume                                      1B/RW
constant DSP_V1VOLR($11)    // Voice 1 Right Volume                                      1B/RW
constant DSP_V1PITCHL($12)  // Voice 1 Pitch Scaler  (Lower 8bit)                        2B/RW
constant DSP_V1PITCHH($13)  // Voice 1 Pitch Scaler  (Upper 6bit)                        1B/RW
constant DSP_V1SRCN($14)    // Voice 1 Source Number (0-255)                             1B/RW
constant DSP_V1ADSR1($15)   // Voice 1 ADSR Settings (Lower 8bit)                        2B/RW
constant DSP_V1ADSR2($16)   // Voice 1 ADSR Settings (Upper 8bit)                        1B/RW
constant DSP_V1GAIN($17)    // Voice 1 Gain Settings                                     1B/RW
constant DSP_V1ENVX($18)    // Voice 1 Current Envelope Value                            1B/R
constant DSP_V1OUTX($19)    // Voice 1 Current Sample   Value                            1B/R
constant DSP_V1UNUSEDA($1A) // Voice 1 Unused Byte A (1 Byte Of General-Purpose RAM)     1B/RW
constant DSP_V1UNUSEDB($1B) // Voice 1 Unused Byte B (1 Byte Of General-Purpose RAM)     1B/RW
constant DSP_V1UNUSEDC($1E) // Voice 1 Unused Byte C (1 Byte Of General-Purpose RAM)     1B/RW

constant DSP_V2VOLL($20)    // Voice 2 Left  Volume                                      1B/RW
constant DSP_V2VOLR($21)    // Voice 2 Right Volume                                      1B/RW
constant DSP_V2PITCHL($22)  // Voice 2 Pitch Scaler  (Lower 8bit)                        2B/RW
constant DSP_V2PITCHH($23)  // Voice 2 Pitch Scaler  (Upper 6bit)                        1B/RW
constant DSP_V2SRCN($24)    // Voice 2 Source Number (0-255)                             1B/RW
constant DSP_V2ADSR1($25)   // Voice 2 ADSR Settings (Lower 8bit)                        2B/RW
constant DSP_V2ADSR2($26)   // Voice 2 ADSR Settings (Upper 8bit)                        1B/RW
constant DSP_V2GAIN($27)    // Voice 2 Gain Settings                                     1B/RW
constant DSP_V2ENVX($28)    // Voice 2 Current Envelope Value                            1B/R
constant DSP_V2OUTX($29)    // Voice 2 Current Sample   Value                            1B/R
constant DSP_V2UNUSEDA($2A) // Voice 2 Unused Byte A (1 Byte Of General-Purpose RAM)     1B/RW
constant DSP_V2UNUSEDB($2B) // Voice 2 Unused Byte B (1 Byte Of General-Purpose RAM)     1B/RW
constant DSP_V2UNUSEDC($2E) // Voice 2 Unused Byte C (1 Byte Of General-Purpose RAM)     1B/RW

constant DSP_V3VOLL($30)    // Voice 3 Left  Volume                                      1B/RW
constant DSP_V3VOLR($31)    // Voice 3 Right Volume                                      1B/RW
constant DSP_V3PITCHL($32)  // Voice 3 Pitch Scaler  (Lower 8bit)                        2B/RW
constant DSP_V3PITCHH($33)  // Voice 3 Pitch Scaler  (Upper 6bit)                        1B/RW
constant DSP_V3SRCN($34)    // Voice 3 Source Number (0-255)                             1B/RW
constant DSP_V3ADSR1($35)   // Voice 3 ADSR Settings (Lower 8bit)                        2B/RW
constant DSP_V3ADSR2($36)   // Voice 3 ADSR Settings (Upper 8bit)                        1B/RW
constant DSP_V3GAIN($37)    // Voice 3 Gain Settings                                     1B/RW
constant DSP_V3ENVX($38)    // Voice 3 Current Envelope Value                            1B/R
constant DSP_V3OUTX($39)    // Voice 3 Current Sample   Value                            1B/R
constant DSP_V3UNUSEDA($3A) // Voice 3 Unused Byte A (1 Byte Of General-Purpose RAM)     1B/RW
constant DSP_V3UNUSEDB($3B) // Voice 3 Unused Byte B (1 Byte Of General-Purpose RAM)     1B/RW
constant DSP_V3UNUSEDC($3E) // Voice 3 Unused Byte C (1 Byte Of General-Purpose RAM)     1B/RW

constant DSP_V4VOLL($40)    // Voice 4 Left  Volume                                      1B/RW
constant DSP_V4VOLR($41)    // Voice 4 Right Volume                                      1B/RW
constant DSP_V4PITCHL($42)  // Voice 4 Pitch Scaler  (Lower 8bit)                        2B/RW
constant DSP_V4PITCHH($43)  // Voice 4 Pitch Scaler  (Upper 6bit)                        1B/RW
constant DSP_V4SRCN($44)    // Voice 4 Source Number (0-255)                             1B/RW
constant DSP_V4ADSR1($45)   // Voice 4 ADSR Settings (Lower 8bit)                        2B/RW
constant DSP_V4ADSR2($46)   // Voice 4 ADSR Settings (Upper 8bit)                        1B/RW
constant DSP_V4GAIN($47)    // Voice 4 Gain Settings                                     1B/RW
constant DSP_V4ENVX($48)    // Voice 4 Current Envelope Value                            1B/R
constant DSP_V4OUTX($49)    // Voice 4 Current Sample   Value                            1B/R
constant DSP_V4UNUSEDA($4A) // Voice 4 Unused Byte A (1 Byte Of General-Purpose RAM)     1B/RW
constant DSP_V4UNUSEDB($4B) // Voice 4 Unused Byte B (1 Byte Of General-Purpose RAM)     1B/RW
constant DSP_V4UNUSEDC($4E) // Voice 4 Unused Byte C (1 Byte Of General-Purpose RAM)     1B/RW

constant DSP_V5VOLL($50)    // Voice 5 Left  Volume                                      1B/RW
constant DSP_V5VOLR($51)    // Voice 5 Right Volume                                      1B/RW
constant DSP_V5PITCHL($52)  // Voice 5 Pitch Scaler  (Lower 8bit)                        2B/RW
constant DSP_V5PITCHH($53)  // Voice 5 Pitch Scaler  (Upper 6bit)                        1B/RW
constant DSP_V5SRCN($54)    // Voice 5 Source Number (0-255)                             1B/RW
constant DSP_V5ADSR1($55)   // Voice 5 ADSR Settings (Lower 8bit)                        2B/RW
constant DSP_V5ADSR2($56)   // Voice 5 ADSR Settings (Upper 8bit)                        1B/RW
constant DSP_V5GAIN($57)    // Voice 5 Gain Settings                                     1B/RW
constant DSP_V5ENVX($58)    // Voice 5 Current Envelope Value                            1B/R
constant DSP_V5OUTX($59)    // Voice 5 Current Sample   Value                            1B/R
constant DSP_V5UNUSEDA($5A) // Voice 5 Unused Byte A (1 Byte Of General-Purpose RAM)     1B/RW
constant DSP_V5UNUSEDB($5B) // Voice 5 Unused Byte B (1 Byte Of General-Purpose RAM)     1B/RW
constant DSP_V5UNUSEDC($5E) // Voice 5 Unused Byte C (1 Byte Of General-Purpose RAM)     1B/RW

constant DSP_V6VOLL($60)    // Voice 6 Left  Volume                                      1B/RW
constant DSP_V6VOLR($61)    // Voice 6 Right Volume                                      1B/RW
constant DSP_V6PITCHL($62)  // Voice 6 Pitch Scaler  (Lower 8bit)                        2B/RW
constant DSP_V6PITCHH($63)  // Voice 6 Pitch Scaler  (Upper 6bit)                        1B/RW
constant DSP_V6SRCN($64)    // Voice 6 Source Number (0-255)                             1B/RW
constant DSP_V6ADSR1($65)   // Voice 6 ADSR Settings (Lower 8bit)                        2B/RW
constant DSP_V6ADSR2($66)   // Voice 6 ADSR Settings (Upper 8bit)                        1B/RW
constant DSP_V6GAIN($67)    // Voice 6 Gain Settings                                     1B/RW
constant DSP_V6ENVX($68)    // Voice 6 Current Envelope Value                            1B/R
constant DSP_V6OUTX($69)    // Voice 6 Current Sample   Value                            1B/R
constant DSP_V6UNUSEDA($6A) // Voice 6 Unused Byte A (1 Byte Of General-Purpose RAM)     1B/RW
constant DSP_V6UNUSEDB($6B) // Voice 6 Unused Byte B (1 Byte Of General-Purpose RAM)     1B/RW
constant DSP_V6UNUSEDC($6E) // Voice 6 Unused Byte C (1 Byte Of General-Purpose RAM)     1B/RW

constant DSP_V7VOLL($70)    // Voice 7 Left  Volume                                      1B/RW
constant DSP_V7VOLR($71)    // Voice 7 Right Volume                                      1B/RW
constant DSP_V7PITCHL($72)  // Voice 7 Pitch Scaler  (Lower 8bit)                        2B/RW
constant DSP_V7PITCHH($73)  // Voice 7 Pitch Scaler  (Upper 6bit)                        1B/RW
constant DSP_V7SRCN($74)    // Voice 7 Source Number (0-255)                             1B/RW
constant DSP_V7ADSR1($75)   // Voice 7 ADSR Settings (Lower 8bit)                        2B/RW
constant DSP_V7ADSR2($76)   // Voice 7 ADSR Settings (Upper 8bit)                        1B/RW
constant DSP_V7GAIN($77)    // Voice 7 Gain Settings                                     1B/RW
constant DSP_V7ENVX($78)    // Voice 7 Current Envelope Value                            1B/R
constant DSP_V7OUTX($79)    // Voice 7 Current Sample   Value                            1B/R
constant DSP_V7UNUSEDA($7A) // Voice 7 Unused Byte A (1 Byte Of General-Purpose RAM)     1B/RW
constant DSP_V7UNUSEDB($7B) // Voice 7 Unused Byte B (1 Byte Of General-Purpose RAM)     1B/RW
constant DSP_V7UNUSEDC($7E) // Voice 7 Unused Byte C (1 Byte Of General-Purpose RAM)     1B/RW
// $80..$FF - Read-Only Mirror Of $00..$7F