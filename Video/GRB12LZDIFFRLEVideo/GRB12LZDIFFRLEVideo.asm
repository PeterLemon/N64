// N64 'Bare Metal' 320x240 GRB 12-Bit LZSS DIFF RLE Video Decode Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "GRB12LZDIFFRLEVideo.N64", create
fill 1052672 // Set ROM Size

constant RLE($80300000) // RLE Frame DRAM Offset
constant GRB($80380000) // GRB Frame DRAM Offset

constant FRAMES(866) // Number Of Frames

origin $00000000
base $80000000 // Entry Point Of Code
include "LIB/N64.INC" // Include N64 Definitions
include "LIB/N64_HEADER.ASM" // Include 64 Byte Header & Vector Table
insert "LIB/N64_BOOTCODE.BIN" // Include 4032 Byte Boot Code

Start:
  include "LIB/N64_GFX.INC" // Include Graphics Macros
  N64_INIT() // Run N64 Initialisation Routine

  ScreenNTSC(320, 240, BPP16|AA_MODE_2, $A0100000) // Screen NTSC: 320x240, 16BPP, Resample Only, DRAM Origin $A0100000

  lui a0,AI_BASE // A0 = AI Base Register ($A4500000)
  ori t0,r0,1 // T0 = AI Control DMA Enable Bit (1)
  sw t0,AI_CONTROL(a0) // Store AI Control DMA Enable Bit To AI Control Register ($A4500008)
  ori t0,r0,15 // T0 = Sample Bit Rate (Bitrate-1)
  sw t0,AI_BITRATE(a0) // Store Sample Bit Rate To AI Bit Rate Register ($A4500014)
  li t0,(VI_NTSC_CLOCK/44100)-1 // T0 = Sample Frequency: (VI_NTSC_CLOCK(48681812) / FREQ(44100)) - 1
  sw t0,AI_DACRATE(a0) // Store Sample Frequency To AI DAC Rate Register ($A4500010)

  // Load TLUT Using RDP
  DPC(RDPTLUTBuffer, RDPTLUTBufferEnd) // Run DPC Command Buffer: Start, End

LoopVideo:
  // Clear GRB Frame
  lui a0,GRB>>16
  li t0,(50400/4) - 1
  ClearGRB:
    sw r0,0(a0)
    addiu a0,4
    bnez t0,ClearGRB
    subiu t0,1 // T0-- (Delay Slot)

  la t6,Sample // T6 = Sample DRAM Offset
  la t7,$10000000|(Sample&$FFFFFFF) // T7 = Sample Aligned Cart Physical ROM Offset ($10000000..$1FFFFFFF 128MB)

  lui t8,$A010 // T8 = Double Buffer Frame Offset = Frame A
  ori t9,r0,FRAMES-1 // T9 = Frame Count - 1
  la a3,$B0000000|(LZVideo&$FFFFFFF) // A3 = Aligned Cart ROM Offset ($B0000000..$BFFFFFFF 128MB)
  
  LoopFrames:
  WaitScanline($1E0) // Wait For Scanline To Reach Vertical Start

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


  // Decode LZSS Data
  lui a1,RLE>>16 // A1 = Destination Address (DRAM Start Offset)

  lw t1,0(a3) // T1 = Data Length Word
  srl t0,t1,16 // T0 = T1 >> 16
  andi t0,$00FF // T0 = LO Data Length Byte
  andi t2,t1,$FF00 // T2 = T1 & $FF00
  or t0,t2 // T0 = MID/LO Data Length Bytes
  andi t1,$00FF // T1 &= $00FF
  sll t1,16 // T1 <<= 16
  or t0,t1 // T0 = Data Length
  addu t0,a1 // T0 = Destination End Offset (DRAM End Offset)

  ori s0,r0,3 // S0 = Word Byte Counter
  lw s1,4(a3) // S1 = ROM Word
  addiu a3,8  // Source Address += 8

  LZLoop:
    sll t1,s0,3   // T1 = Word Byte Counter * 8
    srlv t1,s1,t1 // T1 = Flag Data For Next 8 Blocks (0 = Uncompressed Byte, 1 = Compressed Bytes)
    andi t1,$00FF // T1 &= $00FF
    bnez s0,LZSkipA // IF (Word Byte Counter != 0) LZ Skip A
    subiu s0,1  // Word Byte Counter-- (Delay Slot)
    ori s0,r0,3 // S0 = Word Byte Counter
    lw s1,0(a3) // S1 = ROM Word
    addiu a3,4  // Source Address += 4
    LZSkipA:

    ori t2,r0,%10000000 // T2 = Flag Data Block Type Shifter
    LZBlockLoop:
      beq a1,t0,LZEnd // IF (Destination Address == Destination End Offset) LZEnd
      and t4,t1,t2 // Test Block Type (Delay Slot)
      beqz t2,LZLoop // IF (Flag Data Block Type Shifter == 0) LZLoop
      srl t2,1 // Shift T2 To Next Flag Data Block Type (Delay Slot)

      sll t3,s0,3   // T3 = Word Byte Counter * 8
      srlv t3,s1,t3 // T3 = Copy Uncompressed Byte / Number Of Bytes To Copy & Disp MSB's
      andi t3,$00FF // T3 &= $00FF
      bnez s0,LZSkipB // IF (Word Byte Counter != 0) LZ Skip B
      subiu s0,1  // Word Byte Counter-- (Delay Slot)
      ori s0,r0,3 // S0 = Word Byte Counter
      lw s1,0(a3) // S1 = ROM Word
      addiu a3,4  // Source Address += 4
      LZSkipB:

      bnez t4,LZDecode // IF (BlockType != 0) LZDecode Bytes
      nop // Delay Slot
      sb t3,0(a1) // Store Uncompressed Byte To Destination
      j LZBlockLoop
      addiu a1,1 // Add 1 To DRAM Offset (Delay Slot)

      LZDecode:
        sll t4,s0,3   // T4 = Word Byte Counter * 8
        srlv t4,s1,t4 // T4 = Disp LSB's
        andi t4,$00FF // T4 &= $00FF
        bnez s0,LZSkipC // IF (Word Byte Counter != 0) LZ Skip C
        subiu s0,1  // Word Byte Counter-- (Delay Slot)
        ori s0,r0,3 // S0 = Word Byte Counter
        lw s1,0(a3) // S1 = ROM Word
        addiu a3,4  // Source Address += 4
        LZSkipC:

        sll t5,t3,8 // T5 = Disp MSB's
        or t4,t5 // T4 = Disp 16-Bit
        andi t4,$FFF // T4 &= $FFF (Disp 12-Bit)
        not t4 // T4 = -Disp - 1
        addu t4,a1 // T4 = Destination - Disp - 1
        srl t3,4 // T3 = Number Of Bytes To Copy (Minus 3)
        addiu t3,3 // T3 = Number Of Bytes To Copy
        LZCopy:
          lbu t5,0(t4) // T5 = Byte To Copy
          addiu t4,1 // Add 1 To T4 Offset
          sb t5,0(a1) // Store Byte To DRAM
          subiu t3,1 // Number Of Bytes To Copy -= 1
          bnez t3,LZCopy // IF (Number Of Bytes To Copy != 0) LZCopy Bytes
          addiu a1,1 // Add 1 To DRAM Offset (Delay Slot)
          j LZBlockLoop
          nop // Delay Slot
  LZEnd:
    ori t0,r0,3 // T0 = 3
    bne s0,t0,LZEOF // IF (Word Byte Counter != 3) LZEOF
    nop // Delay Slot
    subiu a3,4 // ELSE Source Address -= 4
  LZEOF:


  // Decode RLE DIFF Data
  la a0,RLE+4 // A0 = Source Address (ROM Start Offset) ($B0000000..$B3FFFFFF)
  lui a1,GRB>>16  // A1 = Destination Address (DRAM Start Offset)
  la t0,GRB+50400 // T0 = Destination End Offset (DRAM End Offset)

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
      lb t2,0(a0) // T2 = Difference Signed Byte
      addiu a0,1 // Add 1 To RLE Offset
      lb t3,0(a1) // T3 = Source Data Byte
      add t3,t2 // Add Signed Byte (T2) To Data Byte (T3)
      sb t3,0(a1) // Store Uncompressed Byte To Destination
      addiu a1,1 // Add 1 To DRAM Offset
      bnez t1,RLECopy // IF (Expanded Data Length != 0) RLECopy
      subiu t1,1 // Expanded Data Length -= 1 (Delay Slot)
      j RLELoop
      nop // Delay Slot

    RLEDecode:
      addiu t1,2 // Expanded Data Length += 2
      lb t2,0(a0) // T2 = Difference Signed Byte
      bnez t2,RLEDecodeByte // IF (Difference Signed Byte != 0) RLEDecodeByte
      addiu a0,1 // Add 1 To RLE Offset (Delay Slot)
      addu a1,t1 // Add T1 To DRAM Offset // ELSE Skip RLEDecodeByte
      j RLELoop
      addiu a1,1 // DRAM Offset += 1 (Delay Slot)

      RLEDecodeByte:
        lb t3,0(a1) // T3 = Source Data Byte
        add t3,t2 // Add Signed Byte (T2) To Data Byte (T3)
        sb t3,0(a1) // Store Uncompressed Byte To Destination
        addiu a1,1 // Add 1 To DRAM Offset
        bnez t1,RLEDecodeByte // IF (Expanded Data Length != 0) RLEDecodeByte
        subiu t1,1 // Expanded Data Length -= 1 (Delay Slot)
        j RLELoop
        nop // Delay Slot
    RLEEnd:


  // Flush Data Cache: Index Writeback Invalidate
  la a0,$80000000    // A0 = Cache Start
  la a1,$80002000-16 // A1 = Cache End
  LoopCache:
    cache $0|1,0(a0) // Data Cache: Index Writeback Invalidate
    bne a0,a1,LoopCache
    addiu a0,16 // Address += Data Line Size (Delay Slot)


  // Buffer Sound
  lui a0,AI_BASE // A0 = AI Base Register ($A4500000)
  AIBusy:
    lb t0,AI_STATUS(a0) // T0 = AI Status Register Byte ($A450000C)
    andi t0,$40 // AND AI Status With AI Status DMA Busy Bit ($40XXXXXX)
    bnez t0,AIBusy // IF TRUE AI DMA Is Busy
    nop // Delay Slot

  lui a0,PI_BASE // A0 = PI Base Register ($A4600000)
  sw t6,PI_DRAM_ADDR(a0) // Store RAM Offset To PI DRAM Address Register ($A4600000)
  sw t7,PI_CART_ADDR(a0) // Store ROM Offset To PI Cart Address Register ($A4600004)
  ori t0,r0,(Sample.size/FRAMES)-1 // T0 = Length Of DMA Transfer In Bytes - 1
  sw t0,PI_WR_LEN(a0) // Store DMA Length To PI Write Length Register ($A460000C)

  lui a0,AI_BASE // A0 = AI Base Register ($A4500000)
  sw t6,AI_DRAM_ADDR(a0) // Store Sample DRAM Offset To AI DRAM Address Register ($A4500000)
  sw t0,AI_LEN(a0) // Store Length Of Sample Buffer To AI Length Register ($A4500004)

  addiu t7,(Sample.size/FRAMES) // Sample ROM Offset += Sample Length


  // Decode GRB Frame Using RDP
  DPC(RDPBuffer, RDPBufferEnd) // Run DPC Command Buffer: Start, End

  // Wait For RDP To Finish
  RDPLoop:
    lw t0,DPC_STATUS(a0) // T0 = CMD Status ($0410000C)
    andi t0,%101100000 // Wait For RDP DMA Busy Bit 8, Command Busy Bit 6, & RDP Pipeline Busy Bit 5 To Clear
    bnez t0,RDPLoop // IF (T0 != 0) RDPLoop
    nop // Delay Slot


  bnez t9,LoopFrames
  subiu t9,1 // Frame Count -- (Delay Slot)
  j LoopVideo
  nop // Delay Slot

arch n64.rdp
align(8) // Align 64-Bit
RDPTLUTBuffer:
  Set_Scissor 0<<2,0<<2, 0,0, 320<<2,240<<2 // Set Scissor: XH 0.0,YH 0.0, Scissor Field Enable Off,Field Off, XL 320.0,YL 240.0
  Set_Combine_Mode $0,$00, 0,0, $1,$07, $0,$F, 1,0, 0,0,0, 7,7,7 // Set Combine Mode: SubA RGB0,MulRGB0, SubA Alpha0,MulAlpha0, SubA RGB1,MulRGB1, SubB RGB0,SubB RGB1, SubA Alpha1,MulAlpha1, AddRGB0,SubB Alpha0,AddAlpha0, AddRGB1,SubB Alpha1,AddAlpha1

  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,1-1, TLUT // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 1, DRAM ADDRESS TLUT
  Set_Tile 0,0,0, $1D0, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: TMEM Address $1D0, Tile 0
  Load_Tlut 0<<2,0<<2, 0, 47<<2,0<<2 // Load Tlut: SL 0.0,TL 0.0, Tile 0, SH 47.0,TH 0.0
  Sync_Load // Sync Load

  Sync_Full // Ensure Entire Scene Is Fully Drawn
RDPTLUTBufferEnd:

align(8) // Align 64-Bit
RDPBuffer:
DoubleBuffer:
  Set_Color_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,320-1, $00100000 // Set Color Image: FORMAT RGBA,SIZE 16B,WIDTH 320, DRAM ADDRESS $00100000

  Set_Other_Modes EN_TLUT|SAMPLE_TYPE|BI_LERP_0|ALPHA_DITHER_SEL_NO_DITHER|RGB_DITHER_SEL_NO_DITHER|B_M2A_0_1 // Set Other Modes

  // Green Tiles
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,80-1, GRB // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 80, DRAM ADDRESS I Tile 0
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 319<<2,11<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 11.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,20, $000, 0,PALETTE_D, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0,Palette D
  Texture_Rectangle 320<<2,12<<2, 0, 0<<2,0<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 12.0, Tile 0, XH 0.0,YH 0.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,80-1, GRB+(160*12) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 80, DRAM ADDRESS G Tile 1
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 319<<2,11<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 11.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,20, $000, 0,PALETTE_D, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0,Palette D
  Texture_Rectangle 320<<2,24<<2, 0, 0<<2,12<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 24.0, Tile 0, XH 0.0,YH 12.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,80-1, GRB+((160*12)*2) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 80, DRAM ADDRESS G Tile 2
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 319<<2,11<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 11.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,20, $000, 0,PALETTE_D, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0,Palette D
  Texture_Rectangle 320<<2,36<<2, 0, 0<<2,24<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 36.0, Tile 0, XH 0.0,YH 24.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,80-1, GRB+((160*12)*3) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 80, DRAM ADDRESS G Tile 3
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 319<<2,11<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 11.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,20, $000, 0,PALETTE_D, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0,Palette D
  Texture_Rectangle 320<<2,48<<2, 0, 0<<2,36<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 48.0, Tile 0, XH 0.0,YH 36.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,80-1, GRB+((160*12)*4) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 80, DRAM ADDRESS G Tile 4
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 319<<2,11<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 11.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,20, $000, 0,PALETTE_D, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0,Palette D
  Texture_Rectangle 320<<2,60<<2, 0, 0<<2,48<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 60.0, Tile 0, XH 0.0,YH 48.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,80-1, GRB+((160*12)*5) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 80, DRAM ADDRESS G Tile 5
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 319<<2,11<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 11.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,20, $000, 0,PALETTE_D, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0,Palette D
  Texture_Rectangle 320<<2,72<<2, 0, 0<<2,60<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 72.0, Tile 0, XH 0.0,YH 60.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,80-1, GRB+((160*12)*6) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 80, DRAM ADDRESS G Tile 6
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 319<<2,11<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 11.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,20, $000, 0,PALETTE_D, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0,Palette D
  Texture_Rectangle 320<<2,84<<2, 0, 0<<2,72<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 84.0, Tile 0, XH 0.0,YH 72.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,80-1, GRB+((160*12)*7) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 80, DRAM ADDRESS G Tile 7
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 319<<2,11<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 11.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,20, $000, 0,PALETTE_D, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0,Palette D
  Texture_Rectangle 320<<2,96<<2, 0, 0<<2,84<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 96.0, Tile 0, XH 0.0,YH 84.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,80-1, GRB+((160*12)*8) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 80, DRAM ADDRESS G Tile 8
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 319<<2,11<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 11.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,20, $000, 0,PALETTE_D, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0,Palette D
  Texture_Rectangle 320<<2,108<<2, 0, 0<<2,96<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 108.0, Tile 0, XH 0.0,YH 96.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,80-1, GRB+((160*12)*9) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 80, DRAM ADDRESS G Tile 9
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 319<<2,11<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 11.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,20, $000, 0,PALETTE_D, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0,Palette D
  Texture_Rectangle 320<<2,120<<2, 0, 0<<2,108<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 120.0, Tile 0, XH 0.0,YH 108.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,80-1, GRB+((160*12)*10) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 80, DRAM ADDRESS G Tile 10
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 319<<2,11<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 11.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,20, $000, 0,PALETTE_D, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0,Palette D
  Texture_Rectangle 320<<2,132<<2, 0, 0<<2,120<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 132.0, Tile 0, XH 0.0,YH 120.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,80-1, GRB+((160*12)*11) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 80, DRAM ADDRESS G Tile 11
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 319<<2,11<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 11.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,20, $000, 0,PALETTE_D, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0,Palette D
  Texture_Rectangle 320<<2,144<<2, 0, 0<<2,132<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 144.0, Tile 0, XH 0.0,YH 132.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,80-1, GRB+((160*12)*12) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 80, DRAM ADDRESS G Tile 11
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 319<<2,11<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 11.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,20, $000, 0,PALETTE_D, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0,Palette D
  Texture_Rectangle 320<<2,156<<2, 0, 0<<2,144<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 156.0, Tile 0, XH 0.0,YH 144.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,80-1, GRB+((160*12)*13) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 80, DRAM ADDRESS G Tile 13
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 319<<2,11<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 11.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,20, $000, 0,PALETTE_D, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0,Palette D
  Texture_Rectangle 320<<2,168<<2, 0, 0<<2,156<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 168.0, Tile 0, XH 0.0,YH 156.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,80-1, GRB+((160*12)*14) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 80, DRAM ADDRESS G Tile 14
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 319<<2,11<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 11.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,20, $000, 0,PALETTE_D, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0,Palette D
  Texture_Rectangle 320<<2,180<<2, 0, 0<<2,168<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 180.0, Tile 0, XH 0.0,YH 168.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,80-1, GRB+((160*12)*15) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 80, DRAM ADDRESS G Tile 15
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 319<<2,11<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 11.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,20, $000, 0,PALETTE_D, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0,Palette D
  Texture_Rectangle 320<<2,192<<2, 0, 0<<2,180<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 192.0, Tile 0, XH 0.0,YH 180.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,80-1, GRB+((160*12)*16) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 80, DRAM ADDRESS G Tile 16
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 319<<2,11<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 11.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,20, $000, 0,PALETTE_D, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0,Palette D
  Texture_Rectangle 320<<2,204<<2, 0, 0<<2,192<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 204.0, Tile 0, XH 0.0,YH 192.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,80-1, GRB+((160*12)*17) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 80, DRAM ADDRESS G Tile 17
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 319<<2,11<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 11.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,20, $000, 0,PALETTE_D, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0,Palette D
  Texture_Rectangle 320<<2,216<<2, 0, 0<<2,204<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 216.0, Tile 0, XH 0.0,YH 204.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,80-1, GRB+((160*12)*18) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 80, DRAM ADDRESS G Tile 18
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 319<<2,11<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 11.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,20, $000, 0,PALETTE_D, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0,Palette D
  Texture_Rectangle 320<<2,228<<2, 0, 0<<2,216<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 228.0, Tile 0, XH 0.0,YH 216.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,80-1, GRB+((160*12)*19) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 80, DRAM ADDRESS G Tile 19
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,20, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 319<<2,11<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 319.0,TH 11.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,20, $000, 0,PALETTE_D, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 20 (64bit Words), TMEM Address $000, Tile 0,Palette D
  Texture_Rectangle 320<<2,240<<2, 0, 0<<2,228<<2, 0<<5,0<<5, 1<<10,1<<10 // Texture Rectangle: XL 320.0,YL 240.0, Tile 0, XH 0.0,YH 228.0, S 0.0,T 0.0, DSDX 1.0,DTDY 1.0

  // Red Tiles
  Sync_Tile // Sync Tile

  Set_Other_Modes EN_TLUT|SAMPLE_TYPE|BI_LERP_0|ALPHA_DITHER_SEL_NO_DITHER|RGB_DITHER_SEL_NO_DITHER|B_M2B_0_2|B_M2A_0_1|FORCE_BLEND|IMAGE_READ_EN // Set Other Modes

  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,40-1, GRB+((160*12)*20) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 40, DRAM ADDRESS R Tile 0
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,10, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 10 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 159<<2,23<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 159.0,TH 23.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,10, $000, 0,PALETTE_E, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 10 (64bit Words), TMEM Address $000, Tile 0,Palette E
  Texture_Rectangle 320<<2,48<<2, 0, 0<<2,0<<2, 0<<5,0<<5, $200,$200 // Texture Rectangle: XL 320.0,YL 48.0, Tile 0, XH 0.0,YH 0.0, S 0.0,T 0.0, DSDX 0.5,DTDY 0.5

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,40-1, GRB+((160*12)*20)+(80*24) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 40, DRAM ADDRESS R Tile 1
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,10, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 10 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 159<<2,23<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 159.0,TH 23.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,10, $000, 0,PALETTE_E, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 10 (64bit Words), TMEM Address $000, Tile 0,Palette E
  Texture_Rectangle 320<<2,96<<2, 0, 0<<2,48<<2, 0<<5,0<<5, $200,$200 // Texture Rectangle: XL 320.0,YL 96.0, Tile 0, XH 0.0,YH 48.0, S 0.0,T 0.0, DSDX 0.5,DTDY 0.5

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,40-1, GRB+((160*12)*20)+((80*24)*2) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 40, DRAM ADDRESS R Tile 2
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,10, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 10 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 159<<2,23<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 159.0,TH 23.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,10, $000, 0,PALETTE_E, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 10 (64bit Words), TMEM Address $000, Tile 0,Palette E
  Texture_Rectangle 320<<2,144<<2, 0, 0<<2,96<<2, 0<<5,0<<5, $200,$200 // Texture Rectangle: XL 320.0,YL 144.0, Tile 0, XH 0.0,YH 96.0, S 0.0,T 0.0, DSDX 0.5,DTDY 0.5

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,40-1, GRB+((160*12)*20)+((80*24)*3) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 40, DRAM ADDRESS R Tile 3
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,10, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 10 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 159<<2,23<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 159.0,TH 23.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,10, $000, 0,PALETTE_E, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 10 (64bit Words), TMEM Address $000, Tile 0,Palette E
  Texture_Rectangle 320<<2,192<<2, 0, 0<<2,144<<2, 0<<5,0<<5, $200,$200 // Texture Rectangle: XL 320.0,YL 192.0, Tile 0, XH 0.0,YH 144.0, S 0.0,T 0.0, DSDX 0.5,DTDY 0.5

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,40-1, GRB+((160*12)*20)+((80*24)*4) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 40, DRAM ADDRESS R Tile 4
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,10, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 10 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 159<<2,23<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 159.0,TH 23.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,10, $000, 0,PALETTE_E, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 10 (64bit Words), TMEM Address $000, Tile 0,Palette E
  Texture_Rectangle 320<<2,240<<2, 0, 0<<2,192<<2, 0<<5,0<<5, $200,$200 // Texture Rectangle: XL 320.0,YL 240.0, Tile 0, XH 0.0,YH 192.0, S 0.0,T 0.0, DSDX 0.5,DTDY 0.5

  // Blue Tiles
  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,20-1, GRB+((160*12)*20)+((80*24)*5) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 20, DRAM ADDRESS B Tile 0
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,5, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 5 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 79<<2,59<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 79.0,TH 59.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,5, $000, 0,PALETTE_F, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 5 (64bit Words), TMEM Address $000, Tile 0,Palette F
  Texture_Rectangle 320<<2,120<<2, 0, 0<<2,0<<2, 0<<5,0<<5, $100,$100 // Texture Rectangle: XL 320.0,YL 120.0, Tile 0, XH 0.0,YH 0.0, S 0.0,T 0.0, DSDX 0.25,DTDY 0.25

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,20-1, GRB+((160*12)*20)+((80*24)*5)+(40*30) // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 20, DRAM ADDRESS B Tile 1
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,5, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 5 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 79<<2,59<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 79.0,TH 59.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,5, $000, 0,PALETTE_F, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 5 (64bit Words), TMEM Address $000, Tile 0,Palette F
  Texture_Rectangle 320<<2,240<<2, 0, 0<<2,120<<2, 0<<5,0<<5, $100,$100 // Texture Rectangle: XL 320.0,YL 240.0, Tile 0, XH 0.0,YH 120.0, S 0.0,T 0.0, DSDX 0.25,DTDY 0.25

  Sync_Full // Ensure Entire Scene Is Fully Drawn
RDPBufferEnd:

TLUT: // 16x16Bx3 = 96 Bytes
  // Green Channel Palette D
  dh $0041, $00C1, $0141, $01C1, $0241, $02C1, $0341, $03C1, $0441, $04C1, $0541, $05C1, $0641, $06C1, $0741, $07C1 // 16x16B = 32 Bytes

  // Red Channel Palette E
  dh $0801, $1801, $2801, $3801, $4801, $5801, $6801, $7801, $8801, $9801, $A801, $B801, $C801, $D801, $E801, $F801 // 16x16B = 32 Bytes

  // Blue Channel Palette F
  dh $0003, $0007, $000B, $000F, $0013, $0017, $001B, $001F, $0023, $0027, $002B, $002F, $0033, $0037, $003B, $003F // 16x16B = 32 Bytes

insert Sample, "Sample.bin" // 16-Bit 44100Hz Signed Big-Endian Stereo Sound Sample
insert LZVideo, "Video.lz" // 866 320x240 LZSS DIFF RLE Compressed GRB Frames