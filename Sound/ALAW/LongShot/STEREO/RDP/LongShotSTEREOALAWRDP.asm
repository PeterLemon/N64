// N64 'Bare Metal' Sound Long Shot Stereo A-Law RDP Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "LongShotSTEREOALAWRDP.N64", create
fill 4194304 // Set ROM Size

origin $00000000
base $80000000 // Entry Point Of Code
include "LIB/N64.INC" // Include N64 Definitions
include "LIB/N64_HEADER.ASM" // Include 64 Byte Header & Vector Table
insert "LIB/N64_BOOTCODE.BIN" // Include 4032 Byte Boot Code

Start:
  include "LIB/N64_GFX.INC" // Include Graphics Macros
  N64_INIT() // Run N64 Initialisation Routine

  lui a0,AI_BASE // A0 = AI Base Register ($A4500000)
  lli t0,1 // T0 = AI Control DMA Enable Bit (1)
  sw t0,AI_CONTROL(a0) // Store AI Control DMA Enable Bit To AI Control Register ($A4500008)

LoopSample:
  la a1,Sample // A1 = Sample DRAM Offset
  la a2,$10000000|(Sample&$3FFFFFF) // A2 = Sample Aligned Cart Physical ROM Offset ($10000000..$13FFFFFF 64MB)
  lli t0,15 // T0 = Sample Bit Rate (Bitrate-1)
  sw t0,AI_BITRATE(a0) // Store Sample Bit Rate To AI Bit Rate Register ($A4500014)
  li t0,(VI_NTSC_CLOCK/44100)-1 // T0 = Sample Frequency: (VI_NTSC_CLOCK(48681812) / FREQ(44100)) - 1
  sw t0,AI_DACRATE(a0) // Store Sample Frequency To AI DAC Rate Register ($A4500010)

LoopBuffer:
  // Decode A-Law Sound Sample Using RDP
  //DPC(RDPBuffer, RDPBufferEnd) // Run DPC Command Buffer: Start, End
  lui s0,DPC_BASE // S0 = Reality Display Processer Control Interface Base Register ($A4100000)
  la s1,RDPBuffer // S1 = DPC Command Start Address
  sw s1,DPC_START(s0) // Store DPC Command Start Address To DP Start Register ($A4100000)
  la s1,RDPBufferEnd // S1 = DPC Command End Address
  sw s1,DPC_END(s0) // Store DPC Command End Address To DP End Register ($A4100004)

  AIBusy:
  lb t0,AI_STATUS(a0) // T0 = AI Status Register Byte ($A450000C)
  andi t0,$40 // AND AI Status With AI Status DMA Busy Bit ($40XXXXXX)
  bnez t0,AIBusy // IF TRUE AI DMA Is Busy
  nop // Delay Slot

  lui a3,$A010 // A3 = Sample DRAM Offset
  sw a3,AI_DRAM_ADDR(a0) // Store Sample DRAM Offset To AI DRAM Address Register ($A4500000)
  lli t0,$8000-1 // T0 = Length Of Sample Buffer In Bytes - 1
  sw t0,AI_LEN(a0) // Store Length Of Sample Buffer To AI Length Register ($A4500004)

  addiu a2,$4000 // Sample ROM Offset += $4000
  la a3,$10000000|((Sample+Sample.size)&$3FFFFFF) // A2 = Sample END Aligned Cart Physical ROM Offset ($10000000..$13FFFFFF 64MB)
  bge a2,a3,LoopSample // IF (Sample ROM Offset >= Sample END Offset) LoopSample
  nop // Delay Slot

  lui a3,PI_BASE // A3 = PI Base Register ($A4600000)
  sw a1,PI_DRAM_ADDR(a3) // Store RAM Offset To PI DRAM Address Register ($A4600000)
  sw a2,PI_CART_ADDR(a3) // Store ROM Offset To PI Cart Address Register ($A4600004)
  lli t0,$3FFF // T0 = Length Of DMA Transfer In Bytes - 1
  sw t0,PI_WR_LEN(a3) // Store DMA Length To PI Write Length Register ($A460000C)

  j LoopBuffer
  nop // Delay Slot

align(8) // Align 64-Bit
RDPBuffer:
arch n64.rdp
  Set_Scissor 0<<2,0<<2, 0,0, 256<<2,512<<2 // Set Scissor: XH 0.0,YH 0.0, Scissor Field Enable Off,Field Off, XL 256.0,YL 512.0
  Set_Color_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,256-1, $00100000 // Set Color Image: FORMAT RGBA,SIZE 16B,WIDTH 256, DRAM ADDRESS $00100000
  Set_Other_Modes CYCLE_TYPE_COPY|EN_TLUT // Set Other Modes

  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,1-1, ALawLUT // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 1, Tlut DRAM ADDRESS
  Set_Tile 0,0,0, $100, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: TMEM Address $100, Tile 0
  Load_Tlut 0<<2,0<<2, 0, 255<<2,0<<2 // Load Tlut: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 0.0

  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,32, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 32 (64bit Words), TMEM Address $000, Tile 0
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,7<<2, 0, 0<<2,0<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 7.0, Tile 0, XH 0.0,YH 0.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+(256*8) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,15<<2, 0, 0<<2,8<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 15.0, Tile 0, XH 0.0,YH 8.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*2) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,23<<2, 0, 0<<2,16<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 23.0, Tile 0, XH 0.0,YH 16.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*3) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,31<<2, 0, 0<<2,24<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 31.0, Tile 0, XH 0.0,YH 24.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*4) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,39<<2, 0, 0<<2,32<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 39.0, Tile 0, XH 0.0,YH 32.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*5) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,47<<2, 0, 0<<2,40<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 47.0, Tile 0, XH 0.0,YH 40.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*6) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,55<<2, 0, 0<<2,48<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 55.0, Tile 0, XH 0.0,YH 48.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*7) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,63<<2, 0, 0<<2,56<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 63.0, Tile 0, XH 0.0,YH 56.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Full // Ensure Entire Scene Is Fully Drawn
RDPBufferEnd:

ALawLUT:
 dh -5504, -5248, -6016, -5760, -4480, -4224, -4992, -4736
 dh -7552, -7296, -8064, -7808, -6528, -6272, -7040, -6784
 dh -2752, -2624, -3008, -2880, -2240, -2112, -2496, -2368
 dh -3776, -3648, -4032, -3904, -3264, -3136, -3520, -3392
 dh -22016,-20992,-24064,-23040,-17920,-16896,-19968,-18944
 dh -30208,-29184,-32256,-31232,-26112,-25088,-28160,-27136
 dh -11008,-10496,-12032,-11520,-8960, -8448, -9984, -9472
 dh -15104,-14592,-16128,-15616,-13056,-12544,-14080,-13568
 dh -344,  -328,  -376,  -360,  -280,  -264,  -312,  -296
 dh -472,  -456,  -504,  -488,  -408,  -392,  -440,  -424
 dh -88,   -72,   -120,  -104,  -24,   -8,    -56,   -40
 dh -216,  -200,  -248,  -232,  -152,  -136,  -184,  -168
 dh -1376, -1312, -1504, -1440, -1120, -1056, -1248, -1184
 dh -1888, -1824, -2016, -1952, -1632, -1568, -1760, -1696
 dh -688,  -656,  -752,  -720,  -560,  -528,  -624,  -592
 dh -944,  -912,  -1008, -976,  -816,  -784,  -880,  -848
 dh 5504,  5248,  6016,  5760,  4480,  4224,  4992,  4736
 dh 7552,  7296,  8064,  7808,  6528,  6272,  7040,  6784
 dh 2752,  2624,  3008,  2880,  2240,  2112,  2496,  2368
 dh 3776,  3648,  4032,  3904,  3264,  3136,  3520,  3392
 dh 22016, 20992, 24064, 23040, 17920, 16896, 19968, 18944
 dh 30208, 29184, 32256, 31232, 26112, 25088, 28160, 27136
 dh 11008, 10496, 12032, 11520, 8960,  8448,  9984,  9472
 dh 15104, 14592, 16128, 15616, 13056, 12544, 14080, 13568
 dh 344,   328,   376,   360,   280,   264,   312,   296
 dh 472,   456,   504,   488,   408,   392,   440,   424
 dh 88,    72,    120,   104,   24,    8,     56,    40
 dh 216,   200,   248,   232,   152,   136,   184,   168
 dh 1376,  1312,  1504,  1440,  1120,  1056,  1248,  1184
 dh 1888,  1824,  2016,  1952,  1632,  1568,  1760,  1696
 dh 688,   656,   752,   720,   560,   528,   624,   592
 dh 944,   912,   1008,  976,   816,   784,   880,   848

insert Sample, "Sample.alaw" // 16-Bit 44100Hz Signed Big-Endian Stereo A-Law Sound Sample