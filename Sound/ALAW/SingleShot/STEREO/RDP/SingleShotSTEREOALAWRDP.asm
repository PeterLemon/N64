// N64 'Bare Metal' Sound Single Shot Stereo A-Law RDP Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "SingleShotSTEREOALAWRDP.N64", create
fill 1052672 // Set ROM Size

origin $00000000
base $80000000 // Entry Point Of Code
include "LIB/N64.INC" // Include N64 Definitions
include "LIB/N64_HEADER.ASM" // Include 64 Byte Header & Vector Table
insert "LIB/N64_BOOTCODE.BIN" // Include 4032 Byte Boot Code

Start:
  include "LIB/N64_GFX.INC" // Include Graphics Macros
  N64_INIT() // Run N64 Initialisation Routine

  // Decode A-Law Sound Sample Using RDP
  DPC(RDPBuffer, RDPBufferEnd) // Run DPC Command Buffer: Start, End

  lui a0,AI_BASE // A0 = AI Base Register ($A4500000)
  ori t0,r0,1 // T0 = AI Control DMA Enable Bit (1)
  sw t0,AI_CONTROL(a0) // Store AI Control DMA Enable Bit To AI Control Register ($A4500008)

  lui t0,$A010 // T0 = Sample DRAM Offset
  sw t0,AI_DRAM_ADDR(a0) // Store Sample DRAM Offset To AI DRAM Address Register ($A4500000)
  ori t0,r0,15 // T0 = Sample Bit Rate (Bitrate-1)
  sw t0,AI_BITRATE(a0) // Store Sample Bit Rate To AI Bit Rate Register ($A4500014)

  li t0,(VI_NTSC_CLOCK/44100)-1 // T0 = Sample Frequency: (VI_NTSC_CLOCK(48681812) / FREQ(44100)) - 1
  sw t0,AI_DACRATE(a0) // Store Sample Frequency To AI DAC Rate Register ($A4500010)
  li t0,492576 // T0 = Length Of Sample Buffer
  sw t0,AI_LEN(a0) // Store Length Of Sample Buffer To AI Length Register ($A4500004)

Loop:
  j Loop
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

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*8) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,71<<2, 0, 0<<2,64<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 71.0, Tile 0, XH 0.0,YH 64.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*9) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,79<<2, 0, 0<<2,72<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 79.0, Tile 0, XH 0.0,YH 72.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*10) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,87<<2, 0, 0<<2,80<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 87.0, Tile 0, XH 0.0,YH 80.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*11) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,95<<2, 0, 0<<2,88<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 95.0, Tile 0, XH 0.0,YH 88.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*12) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,103<<2, 0, 0<<2,96<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 103.0, Tile 0, XH 0.0,YH 96.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*13) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,111<<2, 0, 0<<2,104<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 111.0, Tile 0, XH 0.0,YH 104.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*14) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,119<<2, 0, 0<<2,112<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 119.0, Tile 0, XH 0.0,YH 112.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*15) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,127<<2, 0, 0<<2,120<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 127.0, Tile 0, XH 0.0,YH 120.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*16) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,135<<2, 0, 0<<2,128<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 135.0, Tile 0, XH 0.0,YH 128.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*17) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,143<<2, 0, 0<<2,136<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 143.0, Tile 0, XH 0.0,YH 136.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*18) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,151<<2, 0, 0<<2,144<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 151.0, Tile 0, XH 0.0,YH 144.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*19) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,159<<2, 0, 0<<2,152<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 159.0, Tile 0, XH 0.0,YH 152.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*20) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,167<<2, 0, 0<<2,160<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 167.0, Tile 0, XH 0.0,YH 160.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*21) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,175<<2, 0, 0<<2,168<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 175.0, Tile 0, XH 0.0,YH 168.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*22) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,183<<2, 0, 0<<2,176<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 183.0, Tile 0, XH 0.0,YH 176.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*23) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,191<<2, 0, 0<<2,184<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 191.0, Tile 0, XH 0.0,YH 184.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*24) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,199<<2, 0, 0<<2,192<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 199.0, Tile 0, XH 0.0,YH 192.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*25) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,207<<2, 0, 0<<2,200<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 207.0, Tile 0, XH 0.0,YH 200.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*26) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,215<<2, 0, 0<<2,208<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 215.0, Tile 0, XH 0.0,YH 208.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*27) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,223<<2, 0, 0<<2,216<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 223.0, Tile 0, XH 0.0,YH 216.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*28) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,231<<2, 0, 0<<2,224<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 231.0, Tile 0, XH 0.0,YH 224.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*29) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,239<<2, 0, 0<<2,232<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 239.0, Tile 0, XH 0.0,YH 232.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*30) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,247<<2, 0, 0<<2,240<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 247.0, Tile 0, XH 0.0,YH 240.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*31) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,255<<2, 0, 0<<2,248<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 255.0, Tile 0, XH 0.0,YH 248.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*32) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,263<<2, 0, 0<<2,256<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 263.0, Tile 0, XH 0.0,YH 256.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*33) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,271<<2, 0, 0<<2,264<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 271.0, Tile 0, XH 0.0,YH 264.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*34) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,279<<2, 0, 0<<2,272<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 279.0, Tile 0, XH 0.0,YH 272.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*35) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,287<<2, 0, 0<<2,280<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 287.0, Tile 0, XH 0.0,YH 280.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*36) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,295<<2, 0, 0<<2,288<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 295.0, Tile 0, XH 0.0,YH 288.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*37) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,303<<2, 0, 0<<2,296<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 303.0, Tile 0, XH 0.0,YH 296.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*38) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,311<<2, 0, 0<<2,304<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 311.0, Tile 0, XH 0.0,YH 304.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*39) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,319<<2, 0, 0<<2,312<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 319.0, Tile 0, XH 0.0,YH 312.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*40) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,327<<2, 0, 0<<2,320<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 327.0, Tile 0, XH 0.0,YH 320.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*41) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,335<<2, 0, 0<<2,328<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 335.0, Tile 0, XH 0.0,YH 328.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*42) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,343<<2, 0, 0<<2,336<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 343.0, Tile 0, XH 0.0,YH 336.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*43) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,351<<2, 0, 0<<2,344<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 351.0, Tile 0, XH 0.0,YH 344.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*44) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,359<<2, 0, 0<<2,352<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 359.0, Tile 0, XH 0.0,YH 352.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*45) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,367<<2, 0, 0<<2,360<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 367.0, Tile 0, XH 0.0,YH 360.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*46) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,375<<2, 0, 0<<2,368<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 375.0, Tile 0, XH 0.0,YH 368.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*47) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,383<<2, 0, 0<<2,376<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 383.0, Tile 0, XH 0.0,YH 376.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*48) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,391<<2, 0, 0<<2,384<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 391.0, Tile 0, XH 0.0,YH 384.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*49) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,399<<2, 0, 0<<2,392<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 399.0, Tile 0, XH 0.0,YH 392.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*50) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,407<<2, 0, 0<<2,400<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 407.0, Tile 0, XH 0.0,YH 400.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*51) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,415<<2, 0, 0<<2,408<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 415.0, Tile 0, XH 0.0,YH 408.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*52) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,423<<2, 0, 0<<2,416<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 423.0, Tile 0, XH 0.0,YH 416.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*53) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,431<<2, 0, 0<<2,424<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 431.0, Tile 0, XH 0.0,YH 424.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*54) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,439<<2, 0, 0<<2,432<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 439.0, Tile 0, XH 0.0,YH 432.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*55) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,447<<2, 0, 0<<2,440<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 447.0, Tile 0, XH 0.0,YH 440.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*56) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,455<<2, 0, 0<<2,448<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 455.0, Tile 0, XH 0.0,YH 448.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*57) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,463<<2, 0, 0<<2,456<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 463.0, Tile 0, XH 0.0,YH 456.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*58) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,471<<2, 0, 0<<2,464<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 471.0, Tile 0, XH 0.0,YH 464.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*59) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,479<<2, 0, 0<<2,472<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 479.0, Tile 0, XH 0.0,YH 472.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*60) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,487<<2, 0, 0<<2,480<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 487.0, Tile 0, XH 0.0,YH 480.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*61) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,495<<2, 0, 0<<2,488<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 495.0, Tile 0, XH 0.0,YH 488.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*62) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,503<<2, 0, 0<<2,496<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 503.0, Tile 0, XH 0.0,YH 496.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,256-1, Sample+((256*8)*63) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 256, Sample DRAM ADDRESS
  Load_Tile 0<<2,0<<2, 0, 255<<2,7<<2 // Load_Tile: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 7.0
  Texture_Rectangle 255<<2,511<<2, 0, 0<<2,504<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 255.0,YL 511.0, Tile 0, XH 0.0,YH 504.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

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

insert Sample, "SampleL.alaw" // 16-Bit 44100Hz Signed Big-Endian Stereo A-Law Sound Sample