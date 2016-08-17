// N64 'Bare Metal' Sound Single Shot Mono A-Law CPU Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "SingleShotMONOALAWCPU.N64", create
fill 1052672 // Set ROM Size

origin $00000000
base $80000000 // Entry Point Of Code
include "LIB/N64.INC" // Include N64 Definitions
include "LIB/N64_HEADER.ASM" // Include 64 Byte Header & Vector Table
insert "LIB/N64_BOOTCODE.BIN" // Include 4032 Byte Boot Code

Start:
  N64_INIT() // Run N64 Initialisation Routine

  // Decode A-Law Sound Sample Using CPU
  la a0,Sample // A0 = Sample Address
  la a1,Sample+Sample.size // A1 = Sample End Address
  la a2,ALawLUT // A2 = A-Law Look Up Table
  lui a3,$A010 // A3 = Decode Sample Address
  ALawDecode:
    lbu t0,0(a0) // Load A-Law Byte
    addiu a0,1 // A-Law Sample Address += 1
    sll t0,1 // Shift To Correct Position In Look Up Table
    addu t0,a2 // Add Position To Look Up Table
    lh t0,0(t0) // T0 = Signed 16-Bit Sample From Table
    sh t0,0(a3) // Store 16-Bit Sample To Decode Sample Address
    bne a0,a1,ALawDecode // IF (Sample Address != Sample End Address) A-Law Decode
    addiu a3,2 // Decode Sample Address += 2 (Delay Slot)

  lui a0,AI_BASE // A0 = AI Base Register ($A4500000)
  lli t0,1 // T0 = AI Control DMA Enable Bit (1)
  sw t0,AI_CONTROL(a0) // Store AI Control DMA Enable Bit To AI Control Register ($A4500008)

  lui t0,$A010 // T0 = Sample DRAM Offset
  sw t0,AI_DRAM_ADDR(a0) // Store Sample DRAM Offset To AI DRAM Address Register ($A4500000)
  lli t0,15 // T0 = Sample Bit Rate (Bitrate-1)
  sw t0,AI_BITRATE(a0) // Store Sample Bit Rate To AI Bit Rate Register ($A4500014)

  li t0,(VI_NTSC_CLOCK/(44100/2))-1 // T0 = Sample Frequency: (VI_NTSC_CLOCK(48681812) / FREQ(44100 / 2)) - 1
  sw t0,AI_DACRATE(a0) // Store Sample Frequency To AI DAC Rate Register ($A4500010)
  li t0,246288 // T0 = Length Of Sample Buffer
  sw t0,AI_LEN(a0) // Store Length Of Sample Buffer To AI Length Register ($A4500004)

Loop:
  j Loop
  nop // Delay Slot

ALawLUT:
 dw -5504, -5248, -6016, -5760, -4480, -4224, -4992, -4736
 dw -7552, -7296, -8064, -7808, -6528, -6272, -7040, -6784
 dw -2752, -2624, -3008, -2880, -2240, -2112, -2496, -2368
 dw -3776, -3648, -4032, -3904, -3264, -3136, -3520, -3392
 dw -22016,-20992,-24064,-23040,-17920,-16896,-19968,-18944
 dw -30208,-29184,-32256,-31232,-26112,-25088,-28160,-27136
 dw -11008,-10496,-12032,-11520,-8960, -8448, -9984, -9472
 dw -15104,-14592,-16128,-15616,-13056,-12544,-14080,-13568
 dw -344,  -328,  -376,  -360,  -280,  -264,  -312,  -296
 dw -472,  -456,  -504,  -488,  -408,  -392,  -440,  -424
 dw -88,   -72,   -120,  -104,  -24,   -8,    -56,   -40
 dw -216,  -200,  -248,  -232,  -152,  -136,  -184,  -168
 dw -1376, -1312, -1504, -1440, -1120, -1056, -1248, -1184
 dw -1888, -1824, -2016, -1952, -1632, -1568, -1760, -1696
 dw -688,  -656,  -752,  -720,  -560,  -528,  -624,  -592
 dw -944,  -912,  -1008, -976,  -816,  -784,  -880,  -848
 dw 5504,  5248,  6016,  5760,  4480,  4224,  4992,  4736
 dw 7552,  7296,  8064,  7808,  6528,  6272,  7040,  6784
 dw 2752,  2624,  3008,  2880,  2240,  2112,  2496,  2368
 dw 3776,  3648,  4032,  3904,  3264,  3136,  3520,  3392
 dw 22016, 20992, 24064, 23040, 17920, 16896, 19968, 18944
 dw 30208, 29184, 32256, 31232, 26112, 25088, 28160, 27136
 dw 11008, 10496, 12032, 11520, 8960,  8448,  9984,  9472
 dw 15104, 14592, 16128, 15616, 13056, 12544, 14080, 13568
 dw 344,   328,   376,   360,   280,   264,   312,   296
 dw 472,   456,   504,   488,   408,   392,   440,   424
 dw 88,    72,    120,   104,   24,    8,     56,    40
 dw 216,   200,   248,   232,   152,   136,   184,   168
 dw 1376,  1312,  1504,  1440,  1120,  1056,  1248,  1184
 dw 1888,  1824,  2016,  1952,  1632,  1568,  1760,  1696
 dw 688,   656,   752,   720,   560,   528,   624,   592
 dw 944,   912,   1008,  976,   816,   784,   880,   848

insert Sample, "Sample.alaw" // 16-Bit 44100Hz Signed Big-Endian Mono A-Law Sound Sample