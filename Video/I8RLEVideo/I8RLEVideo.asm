// N64 'Bare Metal' 320x240 I8 RLE Video Decode Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "I8RLEVideo.N64", create
fill 50331648 // Set ROM Size

constant I8($80300000) // I8 Frame DRAM Offset

origin $00000000
base $80000000 // Entry Point Of Code
include "LIB\N64.INC" // Include N64 Definitions
include "LIB\N64_HEADER.ASM" // Include 64 Byte Header & Vector Table
insert "LIB\N64_BOOTCODE.BIN" // Include 4032 Byte Boot Code

Start:
  include "LIB\N64_GFX.INC" // Include Graphics Macros
  N64_INIT() // Run N64 Initialisation Routine

  ScreenNTSC(320, 240, BPP16, $A0100000) // Screen NTSC: 320x240, 16BPP, DRAM Origin $A0100000

LoopVideo:
  lui t8,$A010 // T8 = Double Buffer Frame Offset = Frame A
  lli t9,6572-1 // T9 = Frame Count - 1
  la a3,$10000000|(RLEVideo&$3FFFFFF) // A3 = Aligned Cart Physical ROM Offset ($10000000..$13FFFFFF 64MB)
  
  LoopFrames:
    lui a0,PI_BASE // A0 = PI Base Register ($A4600000)

    la t0,RLEVideo&$7FFFFF // T0 = Aligned DRAM Physical RAM Offset ($00000000..$007FFFFF 8MB)
    sw t0,PI_DRAM_ADDR(a0) // Store RAM Offset To PI DRAM Address Register ($A4600000)
    sw a3,PI_CART_ADDR(a0) // Store ROM Offset To PI Cart Address Register ($A4600004)
    lli t0,44299 // T0 = Length Of DMA Transfer In Bytes - 1
    sw t0,PI_WR_LEN(a0) // Store DMA Length To PI Write Length Register ($A460000C)

    WaitScanline($1E0) // Wait For Scanline To Reach Vertical Start
    WaitScanline($1E2) // Wait For Scanline To Reach Vertical Blank

    // Double Buffer Screen
    lui a0,VI_BASE // A0 = VI Base Register ($A4400000)
    sw t8,VI_ORIGIN(a0) // Store Origin To VI Origin Register ($A4400004)
    lui t0,$A010
    beq t0,t8,FrameEnd
    lui t8,$A020 // T8 = Double Buffer Frame Offset = Frame B
    lui t8,$A010 // T8 = Double Buffer Frame Offset = Frame A
    FrameEnd:
    la a0,$A0000000|(DoubleBuffer&$3FFFFF)
    sw t8,4(a0)

    la a0,RLEVideo // A0 = Source Address (ROM Start Offset) ($B0000000..$B3FFFFFF)
    lui a1,$8030 // A1 = Destination Address (DRAM Start Offset)
    li t0,I8+76800 // T0 = Destination End Offset (DRAM End Offset)
    addiu a0,4 // Add 4 To RLE Offset

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

  // Decode I8 Frame Using RDP
  lui a1,DPC_BASE // A1 = Reality Display Processer Control Interface Base Register ($A4100000)
  la a2,RDPBuffer // A2 = DPC Command Start Address
  sw a2,DPC_START(a1) // Store DPC Command Start Address To DP Start Register ($A4100000)
  addi a2,RDPBufferEnd-RDPBuffer // A2 = DPC Command End Address
  sw a2,DPC_END(a1) // Store DPC Command End Address To DP End Register ($A4100004)

  WaitScanline($1E0) // Wait For Scanline To Reach Vertical Start
  WaitScanline($1E2) // Wait For Scanline To Reach Vertical Blank

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
  Set_Combine_Mode $0,$00, 0,0, $1,$01, $0,$F, 1,0, 0,0,0, 7,7,7 // Set Combine Mode: SubA RGB0,MulRGB0, SubA Alpha0,MulAlpha0, SubA RGB1,MulRGB1, SubB RGB0,SubB RGB1, SubA Alpha1,MulAlpha1, AddRGB0,SubB Alpha0,AddAlpha0, AddRGB1,SubB Alpha1,AddAlpha1

  Set_Tile IMAGE_DATA_FORMAT_I,SIZE_OF_PIXEL_8B,40, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT I,SIZE 8B,Tile Line Size 40 (64bit Words), TMEM Address $000, Tile 0

  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8 // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 0
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,6<<2, 0, 0<<2,0<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 6.0, Tile 0, XH 0.0,YH 0.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+(320*6) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 1
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,12<<2, 0, 0<<2,6<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 12.0, Tile 0, XH 0.0,YH 6.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+((320*6)*2) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 2
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,18<<2, 0, 0<<2,12<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 18.0, Tile 0, XH 0.0,YH 12.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+((320*6)*3) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 3
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,24<<2, 0, 0<<2,18<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 24.0, Tile 0, XH 0.0,YH 18.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+((320*6)*4) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 4
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,30<<2, 0, 0<<2,24<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 30.0, Tile 0, XH 0.0,YH 24.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+((320*6)*5) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 5
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,36<<2, 0, 0<<2,30<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 36.0, Tile 0, XH 0.0,YH 30.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+((320*6)*6) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 6
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,42<<2, 0, 0<<2,36<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 42.0, Tile 0, XH 0.0,YH 36.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+((320*6)*7) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 7
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,48<<2, 0, 0<<2,42<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 48.0, Tile 0, XH 0.0,YH 42.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+((320*6)*8) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 8
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,54<<2, 0, 0<<2,48<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 54.0, Tile 0, XH 0.0,YH 48.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+((320*6)*9) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 9
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,60<<2, 0, 0<<2,54<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 60.0, Tile 0, XH 0.0,YH 54.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+((320*6)*10) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 10
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,66<<2, 0, 0<<2,60<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 66.0, Tile 0, XH 0.0,YH 60.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+((320*6)*11) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 11
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,72<<2, 0, 0<<2,66<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 72.0, Tile 0, XH 0.0,YH 66.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+((320*6)*12) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 12
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,78<<2, 0, 0<<2,72<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 78.0, Tile 0, XH 0.0,YH 72.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+((320*6)*13) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 13
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,84<<2, 0, 0<<2,78<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 84.0, Tile 0, XH 0.0,YH 78.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+((320*6)*14) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 14
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,90<<2, 0, 0<<2,84<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 90.0, Tile 0, XH 0.0,YH 84.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+((320*6)*15) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 15
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,96<<2, 0, 0<<2,90<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 96.0, Tile 0, XH 0.0,YH 90.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+((320*6)*16) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 16
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,102<<2, 0, 0<<2,96<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 102.0, Tile 0, XH 0.0,YH 96.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+((320*6)*17) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 17
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,108<<2, 0, 0<<2,102<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 108.0, Tile 0, XH 0.0,YH 102.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+((320*6)*18) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 18
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,114<<2, 0, 0<<2,108<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 114.0, Tile 0, XH 0.0,YH 108.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+((320*6)*19) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 19
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,120<<2, 0, 0<<2,114<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 120.0, Tile 0, XH 0.0,YH 114.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+((320*6)*20) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 20
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,126<<2, 0, 0<<2,120<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 126.0, Tile 0, XH 0.0,YH 120.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+((320*6)*21) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 21
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,132<<2, 0, 0<<2,126<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 132.0, Tile 0, XH 0.0,YH 126.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+((320*6)*22) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 22
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,138<<2, 0, 0<<2,132<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 138.0, Tile 0, XH 0.0,YH 132.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+((320*6)*23) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 23
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,144<<2, 0, 0<<2,138<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 144.0, Tile 0, XH 0.0,YH 138.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+((320*6)*24) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 24
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,150<<2, 0, 0<<2,144<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 150.0, Tile 0, XH 0.0,YH 144.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+((320*6)*25) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 25
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,156<<2, 0, 0<<2,150<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 156.0, Tile 0, XH 0.0,YH 150.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+((320*6)*26) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 26
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,162<<2, 0, 0<<2,156<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 162.0, Tile 0, XH 0.0,YH 156.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+((320*6)*27) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 27
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,168<<2, 0, 0<<2,162<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 168.0, Tile 0, XH 0.0,YH 162.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+((320*6)*28) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 28
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,174<<2, 0, 0<<2,168<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 174.0, Tile 0, XH 0.0,YH 168.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+((320*6)*29) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 29
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,180<<2, 0, 0<<2,174<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 180.0, Tile 0, XH 0.0,YH 174.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+((320*6)*30) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 30
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,186<<2, 0, 0<<2,180<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 186.0, Tile 0, XH 0.0,YH 180.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+((320*6)*31) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 31
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,192<<2, 0, 0<<2,186<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 192.0, Tile 0, XH 0.0,YH 186.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+((320*6)*32) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 32
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,198<<2, 0, 0<<2,192<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 198.0, Tile 0, XH 0.0,YH 192.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+((320*6)*33) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 33
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,204<<2, 0, 0<<2,198<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 204.0, Tile 0, XH 0.0,YH 198.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+((320*6)*34) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 34
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,210<<2, 0, 0<<2,204<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 210.0, Tile 0, XH 0.0,YH 204.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+((320*6)*35) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 35
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,216<<2, 0, 0<<2,210<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 216.0, Tile 0, XH 0.0,YH 210.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+((320*6)*36) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 36
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,222<<2, 0, 0<<2,216<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 222.0, Tile 0, XH 0.0,YH 216.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+((320*6)*37) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 37
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,228<<2, 0, 0<<2,222<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 228.0, Tile 0, XH 0.0,YH 222.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+((320*6)*38) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 38
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,234<<2, 0, 0<<2,228<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 234.0, Tile 0, XH 0.0,YH 228.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_8B,320-1, I8+((320*6)*39) // Set Texture Image: FORMAT RGBA,SIZE 8B,WIDTH 320, DRAM ADDRESS I Tile 39
  Load_Tile 0<<2,0<<2, 0, 319<<2,5<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 5.0
  Texture_Rectangle 320<<2,240<<2, 0, 0<<2,234<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 240.0, Tile 0, XH 0.0,YH 234.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Full // Ensure Entire Scene Is Fully Drawn
RDPBufferEnd:

insert RLEVideo, "Video.rle" // 6572 320x240 RLE Compressed I8 Frames 