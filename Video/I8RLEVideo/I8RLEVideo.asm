// N64 'Bare Metal' 320x240 I8 RLE Video Decode Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "I8RLEVideo.N64", create
fill 66772628 // Set ROM Size

constant AudioBuffer(RLEVideo + 65536) // Audio Frame DRAM Offset
constant I8(AudioBuffer + 65536) // I8 Frame DRAM Offset

origin $00000000
base $80000000 // Entry Point Of Code
include "LIB/N64.INC" // Include N64 Definitions
include "LIB/N64_HEADER.ASM" // Include 64 Byte Header & Vector Table
insert "LIB/N64_BOOTCODE.BIN" // Include 4032 Byte Boot Code

Start:
  include "LIB/N64_GFX.INC" // Include Graphics Macros
  N64_INIT() // Run N64 Initialisation Routine

  ScreenNTSC(320, 240, BPP16, $A0100000) // Screen NTSC: 320x240, 16BPP, DRAM Origin $A0100000

  lui a0,AI_BASE // A0 = AI Base Register ($A4500000)
  ori t0,r0,1 // T0 = AI Control DMA Enable Bit (1)
  sw t0,AI_CONTROL(a0) // Store AI Control DMA Enable Bit To AI Control Register ($A4500008)
  ori t0,r0,15 // T0 = Sample Bit Rate (Bitrate-1)
  sw t0,AI_BITRATE(a0) // Store Sample Bit Rate To AI Bit Rate Register ($A4500014)
  li t0,(VI_NTSC_CLOCK/19472)-1 // T0 = Sample Frequency: (VI_NTSC_CLOCK(48681812) / FREQ(19472)) - 1
  sw t0,AI_DACRATE(a0) // Store Sample Frequency To AI DAC Rate Register ($A4500010)

LoopVideo:
  la t6,AudioBuffer // T6 = Sample DRAM Offset
  la t7,$10000000|(Sample&$3FFFFFF) // T7 = Sample Aligned Cart Physical ROM Offset ($10000000..$13FFFFFF 64MB)

  ori t9,r0,6572-1 // T9 = Frame Count - 1
  la a3,$10000000|(RLEVideo&$3FFFFFF) // A3 = Aligned Cart Physical ROM Offset ($10000000..$13FFFFFF 64MB)
  
  LoopFrames:
    lui a0,PI_BASE // A0 = PI Base Register ($A4600000)
    la t0,RLEVideo&$7FFFFF // T0 = Aligned DRAM Physical RAM Offset ($00000000..$007FFFFF 8MB)
    sw t0,PI_DRAM_ADDR(a0) // Store RAM Offset To PI DRAM Address Register ($A4600000)
    sw a3,PI_CART_ADDR(a0) // Store ROM Offset To PI Cart Address Register ($A4600004)
    ori t0,r0,44300-1   // T0 = Length Of DMA Transfer In Bytes - 1
    sw t0,PI_WR_LEN(a0) // Store DMA Length To PI Write Length Register ($A460000C)

    WaitScanline($1E0) // Wait For Scanline To Reach Vertical Start
    WaitScanline($1E2) // Wait For Scanline To Reach Vertical Blank

    // Buffer Sound
    lui a0,PI_BASE // A0 = PI Base Register ($A4600000)
    sw t6,PI_DRAM_ADDR(a0) // Store RAM Offset To PI DRAM Address Register ($A4600000)
    sw t7,PI_CART_ADDR(a0) // Store ROM Offset To PI Cart Address Register ($A4600004)
    ori t0,r0,$A23 // T0 = Length Of DMA Transfer In Bytes - 1
    sw t0,PI_WR_LEN(a0) // Store DMA Length To PI Write Length Register ($A460000C)

    lui a0,AI_BASE // A0 = AI Base Register ($A4500000)
    sw t6,AI_DRAM_ADDR(a0) // Store Sample DRAM Offset To AI DRAM Address Register ($A4500000)
    sw t0,AI_LEN(a0) // Store Length Of Sample Buffer To AI Length Register ($A4500004)
    addu t7,t0 // Sample ROM Offset += $A23

    la a0,RLEVideo+4 // A0 = Source Address (ROM Start Offset) ($B0000000..$B3FFFFFF)
    la a1,I8 // A1 = Destination Address (DRAM Start Offset)
    la t0,I8+76800 // T0 = Destination End Offset (DRAM End Offset)

  RLELoop:
    beq a1,t0,RLEEnd // IF (Destination Address == Destination End Offset) RLEEnd
    nop // Delay Slot

    lbu t1,0(a0) // T1 = RLE Flag Data (Bit 0..6 = Expanded Data Length: Uncompressed N-1, Compressed N-3, Bit 7 = Flag: 0 = Uncompressed, 1 = Compressed)
    addiu a0,1 // Add 1 To RLE Offset

    andi t2,t1,%10000000 // T2 = RLE Flag
    andi t1,%01111111 // T1 = Expanded Data Length
    bnez t2,RLEDecode // IF (BlockType != 0) RLE Decode Bytes
    nop // Delay Slot

    RLECopy: // ELSE Copy Uncompressed Bytes
      lbu t2,0(a0) // T2 = Byte To Copy
      addiu a0,1 // Add 1 To RLE Offset
      sb t2,0(a1) // Store Uncompressed Byte To Destination
      addiu a1,1 // Add 1 To DRAM Offset
      bnez t1,RLECopy // IF (Expanded Data Length != 0) RLECopy
      subiu t1,1 // Expanded Data Length -= 1 (Delay Slot)
      j RLELoop
      nop // Delay Slot

    RLEDecode:
      addiu t1,2 // Expanded Data Length += 2
      lbu t2,0(a0) // T2 = Byte To Copy
      addiu a0,1 // Add 1 To RLE Offset

      RLEDecodeByte:
        sb t2,0(a1) // Store Uncompressed Byte To Destination
        addiu a1,1 // Add 1 To DRAM Offset
        bnez t1,RLEDecodeByte // IF (Expanded Data Length != 0) RLEDecodeByte
        subiu t1,1 // Expanded Data Length -= 1 (Delay Slot)
        j RLELoop
        nop // Delay Slot

    RLEEnd:

    // Skip Zero's At End Of RLE Compressed File
    andi t0,a0,3  // Compare RLE Offset To A Multiple Of 4
    beqz t0,RLEEOF // IF (Multiple Of 4) RLEEOF
    subu a0,t0 // Delay Slot
    addiu a0,4 // RLE Offset += 4
    RLEEOF:

    la a1,RLEVideo
    subu a0,a1
    addu a3,a0 // A3 += RLE End Offset 


  // Flush Data Cache: Index Writeback Invalidate
  la a0,$80000000    // A0 = Cache Start
  la a1,$80002000-16 // A1 = Cache End
  LoopCache:
    cache $0|1,0(a0) // Data Cache: Index Writeback Invalidate
    bne a0,a1,LoopCache
    addiu a0,16 // Address += Data Line Size (Delay Slot)


  WaitScanline($1E0) // Wait For Scanline To Reach Vertical Start
  WaitScanline($1E2) // Wait For Scanline To Reach Vertical Blank

  // Decode I8 Frame Using RDP
  DPC(RDPBuffer, RDPBufferEnd) // Run DPC Command Buffer: Start, End

  bnez t9,LoopFrames
  subiu t9,1 // Frame Count -- (Delay Slot)
  j LoopVideo
  nop // Delay Slot

align(8) // Align 64-Bit
RDPBuffer:
arch n64.rdp
  Set_Scissor 0<<2,0<<2, 0,0, 320<<2,240<<2 // Set Scissor: XH 0.0,YH 0.0, Scissor Field Enable Off,Field Off, XL 320.0,YL 240.0
DoubleBuffer:
  Set_Color_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,320-1, $00100000 // Set Color Image: FORMAT RGBA,SIZE 16B,WIDTH 320, DRAM ADDRESS $00100000

  Set_Other_Modes SAMPLE_TYPE|BI_LERP_0|ALPHA_DITHER_SEL_NO_DITHER|B_M2A_0_1 // Set Other Modes
  Set_Combine_Mode $0,$00, 0,0, $6,$01, $0,$F, 1,0, 0,0,0, 7,7,7 // Set Combine Mode: SubA RGB0,MulRGB0, SubA Alpha0,MulAlpha0, SubA RGB1,MulRGB1, SubB RGB0,SubB RGB1, SubA Alpha1,MulAlpha1, AddRGB0,SubB Alpha0,AddAlpha0, AddRGB1,SubB Alpha1,AddAlpha1

  Set_Tile IMAGE_DATA_FORMAT_I,SIZE_OF_PIXEL_8B,40, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT I,SIZE 8B,Tile Line Size 40 (64bit Words), TMEM Address $000, Tile 0

  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8 // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 0
  Load_Tile 0<<2,0<<2, 0, 319<<2,9<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 9.0
  Texture_Rectangle 320<<2,10<<2, 0, 0<<2,0<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 10.0, Tile 0, XH 0.0,YH 0.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+(320*10) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 1
  Load_Tile 0<<2,0<<2, 0, 319<<2,9<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 9.0
  Texture_Rectangle 320<<2,20<<2, 0, 0<<2,10<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 20.0, Tile 0, XH 0.0,YH 10.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+((320*10)*2) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 2
  Load_Tile 0<<2,0<<2, 0, 319<<2,9<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 9.0
  Texture_Rectangle 320<<2,30<<2, 0, 0<<2,20<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 30.0, Tile 0, XH 0.0,YH 20.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+((320*10)*3) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 3
  Load_Tile 0<<2,0<<2, 0, 319<<2,9<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 9.0
  Texture_Rectangle 320<<2,40<<2, 0, 0<<2,30<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 40.0, Tile 0, XH 0.0,YH 30.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+((320*10)*4) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 4
  Load_Tile 0<<2,0<<2, 0, 319<<2,9<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 9.0
  Texture_Rectangle 320<<2,50<<2, 0, 0<<2,40<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 50.0, Tile 0, XH 0.0,YH 40.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+((320*10)*5) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 5
  Load_Tile 0<<2,0<<2, 0, 319<<2,9<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 9.0
  Texture_Rectangle 320<<2,60<<2, 0, 0<<2,50<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 60.0, Tile 0, XH 0.0,YH 50.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+((320*10)*6) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 6
  Load_Tile 0<<2,0<<2, 0, 319<<2,9<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 9.0
  Texture_Rectangle 320<<2,70<<2, 0, 0<<2,60<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 70.0, Tile 0, XH 0.0,YH 60.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+((320*10)*7) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 7
  Load_Tile 0<<2,0<<2, 0, 319<<2,9<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 9.0
  Texture_Rectangle 320<<2,80<<2, 0, 0<<2,70<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 80.0, Tile 0, XH 0.0,YH 70.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+((320*10)*8) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 8
  Load_Tile 0<<2,0<<2, 0, 319<<2,9<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 9.0
  Texture_Rectangle 320<<2,90<<2, 0, 0<<2,80<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 90.0, Tile 0, XH 0.0,YH 80.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+((320*10)*9) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 9
  Load_Tile 0<<2,0<<2, 0, 319<<2,9<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 9.0
  Texture_Rectangle 320<<2,100<<2, 0, 0<<2,90<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 100.0, Tile 0, XH 0.0,YH 90.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+((320*10)*10) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 10
  Load_Tile 0<<2,0<<2, 0, 319<<2,9<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 9.0
  Texture_Rectangle 320<<2,110<<2, 0, 0<<2,100<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 110.0, Tile 0, XH 0.0,YH 100.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+((320*10)*11) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 11
  Load_Tile 0<<2,0<<2, 0, 319<<2,9<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 9.0
  Texture_Rectangle 320<<2,120<<2, 0, 0<<2,110<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 120.0, Tile 0, XH 0.0,YH 110.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+((320*10)*12) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 12
  Load_Tile 0<<2,0<<2, 0, 319<<2,9<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 9.0
  Texture_Rectangle 320<<2,130<<2, 0, 0<<2,120<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 130.0, Tile 0, XH 0.0,YH 120.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+((320*10)*13) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 13
  Load_Tile 0<<2,0<<2, 0, 319<<2,9<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 9.0
  Texture_Rectangle 320<<2,140<<2, 0, 0<<2,130<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 140.0, Tile 0, XH 0.0,YH 130.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+((320*10)*14) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 14
  Load_Tile 0<<2,0<<2, 0, 319<<2,9<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 9.0
  Texture_Rectangle 320<<2,150<<2, 0, 0<<2,140<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 150.0, Tile 0, XH 0.0,YH 140.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+((320*10)*15) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 15
  Load_Tile 0<<2,0<<2, 0, 319<<2,9<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 9.0
  Texture_Rectangle 320<<2,160<<2, 0, 0<<2,150<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 160.0, Tile 0, XH 0.0,YH 150.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+((320*10)*16) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 16
  Load_Tile 0<<2,0<<2, 0, 319<<2,9<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 9.0
  Texture_Rectangle 320<<2,170<<2, 0, 0<<2,160<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 170.0, Tile 0, XH 0.0,YH 160.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+((320*10)*17) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 17
  Load_Tile 0<<2,0<<2, 0, 319<<2,9<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 9.0
  Texture_Rectangle 320<<2,180<<2, 0, 0<<2,170<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 180.0, Tile 0, XH 0.0,YH 170.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+((320*10)*18) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 18
  Load_Tile 0<<2,0<<2, 0, 319<<2,9<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 9.0
  Texture_Rectangle 320<<2,190<<2, 0, 0<<2,180<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 190.0, Tile 0, XH 0.0,YH 180.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+((320*10)*19) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 19
  Load_Tile 0<<2,0<<2, 0, 319<<2,9<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 9.0
  Texture_Rectangle 320<<2,200<<2, 0, 0<<2,190<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 200.0, Tile 0, XH 0.0,YH 190.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+((320*10)*20) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 20
  Load_Tile 0<<2,0<<2, 0, 319<<2,9<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 9.0
  Texture_Rectangle 320<<2,210<<2, 0, 0<<2,200<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 210.0, Tile 0, XH 0.0,YH 200.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+((320*10)*21) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 21
  Load_Tile 0<<2,0<<2, 0, 319<<2,9<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 9.0
  Texture_Rectangle 320<<2,220<<2, 0, 0<<2,210<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 220.0, Tile 0, XH 0.0,YH 210.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+((320*10)*22) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 22
  Load_Tile 0<<2,0<<2, 0, 319<<2,9<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 9.0
  Texture_Rectangle 320<<2,230<<2, 0, 0<<2,220<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 230.0, Tile 0, XH 0.0,YH 220.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+((320*10)*23) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 23
  Load_Tile 0<<2,0<<2, 0, 319<<2,9<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 9.0
  Texture_Rectangle 320<<2,240<<2, 0, 0<<2,230<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 240.0, Tile 0, XH 0.0,YH 230.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Full // Ensure Entire Scene Is Fully Drawn
RDPBufferEnd:

insert RLEVideo, "Video.rle" // 6572 320x240 RLE Compressed I8 Frames
insert Sample, "Sample.bin" // 16-Bit 16000Hz Signed Big-Endian Stereo Sound Sample