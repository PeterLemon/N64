// N64 'Bare Metal' Sound Single Shot Mono Mu-Law CPU Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "SingleShotMONOMULAWCPU.N64", create
fill 1052672 // Set ROM Size

origin $00000000
base $80000000 // Entry Point Of Code
include "LIB/N64.INC" // Include N64 Definitions
include "LIB/N64_HEADER.ASM" // Include 64 Byte Header & Vector Table
insert "LIB/N64_BOOTCODE.BIN" // Include 4032 Byte Boot Code

Start:
  N64_INIT() // Run N64 Initialisation Routine

  // Decode Mu-Law Sound Sample Using RDP
  la a0,Sample // A0 = Sample Address
  la a1,Sample+Sample.size // A1 = Sample End Address
  la a2,MuLawLUT // A2 = Mu-Law Look Up Table
  lui a3,$A010 // A3 = Decode Sample Address
  MuLawDecode:
    lbu t0,0(a0) // Load Mu-Law Byte
    addiu a0,1 // Mu-Law Sample Address += 1
    sll t0,1 // Shift To Correct Position In Look Up Table
    addu t0,a2 // Add Position To Look Up Table
    lh t0,0(t0) // T0 = Signed 16-Bit Sample From Table
    sh t0,0(a3) // Store 16-Bit Sample To Decode Sample Address
    bne a0,a1,MuLawDecode // IF (Sample Address != Sample End Address) Mu-Law Decode
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

MuLawLUT:
 dw -32124,-31100,-30076,-29052,-28028,-27004,-25980,-24956
 dw -23932,-22908,-21884,-20860,-19836,-18812,-17788,-16764
 dw -15996,-15484,-14972,-14460,-13948,-13436,-12924,-12412
 dw -11900,-11388,-10876,-10364,-9852, -9340, -8828, -8316
 dw -7932, -7676, -7420, -7164, -6908, -6652, -6396, -6140
 dw -5884, -5628, -5372, -5116, -4860, -4604, -4348, -4092
 dw -3900, -3772, -3644, -3516, -3388, -3260, -3132, -3004
 dw -2876, -2748, -2620, -2492, -2364, -2236, -2108, -1980
 dw -1884, -1820, -1756, -1692, -1628, -1564, -1500, -1436
 dw -1372, -1308, -1244, -1180, -1116, -1052, -988,  -924
 dw -876,  -844,  -812,  -780,  -748,  -716,  -684,  -652
 dw -620,  -588,  -556,  -524,  -492,  -460,  -428,  -396
 dw -372,  -356,  -340,  -324,  -308,  -292,  -276,  -260
 dw -244,  -228,  -212,  -196,  -180,  -164,  -148,  -132
 dw -120,  -112,  -104,  -96,   -88,   -80,   -72,   -64
 dw -56,   -48,   -40,   -32,   -24,   -16,   -8,    -1
 dw 32124, 31100, 30076, 29052, 28028, 27004, 25980, 24956
 dw 23932, 22908, 21884, 20860, 19836, 18812, 17788, 16764
 dw 15996, 15484, 14972, 14460, 13948, 13436, 12924, 12412
 dw 11900, 11388, 10876, 10364, 9852,  9340,  8828,  8316
 dw 7932,  7676,  7420,  7164,  6908,  6652,  6396,  6140
 dw 5884,  5628,  5372,  5116,  4860,  4604,  4348,  4092
 dw 3900,  3772,  3644,  3516,  3388,  3260,  3132,  3004
 dw 2876,  2748,  2620,  2492,  2364,  2236,  2108,  1980
 dw 1884,  1820,  1756,  1692,  1628,  1564,  1500,  1436
 dw 1372,  1308,  1244,  1180,  1116,  1052,  988,   924
 dw 876,   844,   812,   780,   748,   716,   684,   652
 dw 620,   588,   556,   524,   492,   460,   428,   396
 dw 372,   356,   340,   324,   308,   292,   276,   260
 dw 244,   228,   212,   196,   180,   164,   148,   132
 dw 120,   112,   104,   96,    88,    80,    72,    64
 dw 56,    48,    40,    32,    24,    16,    8,     0

insert Sample, "Sample.mulaw" // 16-Bit 44100Hz Signed Big-Endian Mono Mu-Law Sound Sample