// N64 'Bare Metal' 320x240 I4 RLE Video Decode Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "I4RLEVideo.N64", create
fill 61865984 // Set ROM Size

origin $00000000
base $80000000 // Entry Point Of Code
include "LIB/N64.INC" // Include N64 Definitions
include "LIB/N64_HEADER.ASM" // Include 64 Byte Header & Vector Table
insert "LIB/N64_BOOTCODE.BIN" // Include 4032 Byte Boot Code

Start:
  include "LIB/N64_GFX.INC" // Include Graphics Macros
  N64_INIT() // Run N64 Initialisation Routine

  ScreenNTSC(320, 240, BPP32, $A0100000) // Screen NTSC: 320x240, 32BPP, DRAM Origin $A0100000

  lui a0,AI_BASE // A0 = AI Base Register ($A4500000)
  lli t0,1 // T0 = AI Control DMA Enable Bit (1)
  sw t0,AI_CONTROL(a0) // Store AI Control DMA Enable Bit To AI Control Register ($A4500008)
  lli t0,15 // T0 = Sample Bit Rate (Bitrate-1)
  sw t0,AI_BITRATE(a0) // Store Sample Bit Rate To AI Bit Rate Register ($A4500014)
  li t0,(VI_NTSC_CLOCK/44100)-1 // T0 = Sample Frequency: (VI_NTSC_CLOCK(48681812) / FREQ(44100)) - 1
  sw t0,AI_DACRATE(a0) // Store Sample Frequency To AI DAC Rate Register ($A4500010)

  WaitScanline($1E0) // Wait For Scanline To Reach Vertical Start

LoopVideo:
  la t6,Sample // T6 = Sample DRAM Offset
  la t7,$10000000|(Sample&$3FFFFFF) // T7 = Sample Aligned Cart Physical ROM Offset ($10000000..$13FFFFFF 64MB)

  lui t8,$A010 // T8 = Double Buffer Frame Offset = Frame A
  lli t9,6572-1 // T9 = Frame Count - 1
  la a3,$10000000|(RLEVideo&$3FFFFFF) // A3 = Aligned Cart Physical ROM Offset ($10000000..$13FFFFFF 64MB)
  
  LoopFrames:
    lui a0,PI_BASE // A0 = PI Base Register ($A4600000)

    la t0,RLEVideo&$7FFFFF // T0 = Aligned DRAM Physical RAM Offset ($00000000..$007FFFFF 8MB)
    sw t0,PI_DRAM_ADDR(a0) // Store RAM Offset To PI DRAM Address Register ($A4600000)
    sw a3,PI_CART_ADDR(a0) // Store ROM Offset To PI Cart Address Register ($A4600004)
    lli t0,14912-1 // T0 = Length Of DMA Transfer In Bytes - 1
    sw t0,PI_WR_LEN(a0) // Store DMA Length To PI Write Length Register ($A460000C)

    // Double Buffer Screen
    lui a0,VI_BASE // A0 = VI Base Register ($A4400000)
    sw t8,VI_ORIGIN(a0) // Store Origin To VI Origin Register ($A4400004)
    lui t0,$A010
    beq t0,t8,FrameEnd
    lui t8,$A020 // T8 = Double Buffer Frame Offset = Frame B
    lui t8,$A010 // T8 = Double Buffer Frame Offset = Frame A
    FrameEnd:

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
    lli t0,$16F8 // T0 = Length Of DMA Transfer In Bytes - 1
    sw t0,PI_WR_LEN(a0) // Store DMA Length To PI Write Length Register ($A460000C)

    lui a0,AI_BASE // A0 = AI Base Register ($A4500000)
    sw t6,AI_DRAM_ADDR(a0) // Store Sample DRAM Offset To AI DRAM Address Register ($A4500000)
    sw t0,AI_LEN(a0) // Store Length Of Sample Buffer To AI Length Register ($A4500004)
    add t7,t0 // Sample ROM Offset += $16F8

    la a0,RLEVideo+4 // A0 = Source Address (ROM Start Offset) ($B0000000..$B3FFFFFF)
    li a1,$8FFFFFFF
    and a1,t8 // A1 = Destination Address (DRAM Start Offset)
    li t0,(320*4)*240
    addu t0,a1 // T0 = Destination End Offset (DRAM End Offset)

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

      sll t3,t2,12 // T3 = I4 2nd Pixel
      andi t3,$F000
      sll t4,t3,8
      or t3,t4
      sll t4,8
      or t3,t4
      sll t2,8 // T2 = I4 1st Pixel
      andi t2,$F000
      sll t4,t2,8
      or t2,t4
      sll t4,8
      or t2,t4
      sw t2,0(a1) // Store 1st Pixel
      sw t3,4(a1) // Store 2nd Pixel

      addiu a1,8 // Add 8 To DRAM Offset
      bnez t1,RLECopy // IF (Expanded Data Length != 0) RLECopy
      subiu t1,1 // Expanded Data Length -= 1 (Delay Slot)
      j RLELoop
      nop // Delay Slot

    RLEDecode:
      addiu t1,2 // Expanded Data Length += 2
      lbu t2,0(a0) // T2 = Byte To Copy
      addiu a0,1 // Add 1 To RLE Offset

      sll t3,t2,12 // T3 = I4 2nd Pixel
      andi t3,$F000
      sll t4,t3,8
      or t3,t4
      sll t4,8
      or t3,t4
      sll t2,8 // T2 = I4 1st Pixel
      andi t2,$F000
      sll t4,t2,8
      or t2,t4
      sll t4,8
      or t2,t4

      RLEDecodeByte:
        sw t2,0(a1) // Store 1st Pixel
        sw t3,4(a1) // Store 2nd Pixel
        addiu a1,8 // Add 8 To DRAM Offset
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

  bnez t9,LoopFrames
  subiu t9,1 // Frame Count -- (Delay Slot)
  j LoopVideo
  nop // Delay Slot

insert RLEVideo, "Video.rle" // 6572 320x240 RLE Compressed I4 Frames
insert Sample, "Sample.bin" // 16-Bit 16000Hz Signed Big-Endian Stereo Sound Sample