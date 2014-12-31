; N64 'Bare Metal' Sound Long Shot Stereo 16BIT Demo by krom (Peter Lemon):
  include LIB\N64.INC ; Include N64 Definitions
  dcb 8388608,$00 ; Set ROM Size
  org $80000000 ; Entry Point Of Code
  include LIB\N64_HEADER.ASM  ; Include 64 Byte Header & Vector Table
  incbin LIB\N64_BOOTCODE.BIN ; Include 4032 Byte Boot Code

Start:
  N64_INIT ; Run N64 Initialisation Routine

  lui a0,AI_BASE ; A0 = AI Base Register ($A4500000)
  li t0,1 ; T0 = AI Control DMA Enable Bit (1)
  sw t0,AI_CONTROL(a0) ; Store AI Control DMA Enable Bit To AI Control Register ($A4500008)

LoopSample:
  la a1,Sample ; A1 = Sample DRAM Offset
  la a2,$10000000|(Sample&$3FFFFFF) ; A2 = Sample Aligned Cart Physical ROM Offset ($10000000..$13FFFFFF 64MB)
  li t0,15 ; T0 = Sample Bit Rate (Bitrate-1)
  sw t0,AI_BITRATE(a0) ; Store Sample Bit Rate To AI Bit Rate Register ($A4500014)
  li t0,(VI_NTSC_CLOCK/44100)-1 ; T0 = Sample Frequency: (VI_NTSC_CLOCK(48681812) / FREQ(44100)) - 1
  sw t0,AI_DACRATE(a0) ; Store Sample Frequency To AI DAC Rate Register ($A4500010)

LoopBuffer:
  sw a1,AI_DRAM_ADDR(a0) ; Store Sample DRAM Offset To AI DRAM Address Register ($A4500000)
  li t0,$FFFF ; T0 = Length Of Sample Buffer
  sw t0,AI_LEN(a0) ; Store Length Of Sample Buffer To AI Length Register ($A4500004)

AIBusy:
  lb t0,AI_STATUS(a0) ; T0 = AI Status Register Byte ($A450000C)
  andi t0,$40 ; AND AI Status With AI Status DMA Busy Bit ($40XXXXXX)
  bnez t0,AIBusy ; IF TRUE AI DMA Is Busy
  nop ; Delay Slot

  addi a2,$FFFF ; Sample ROM Offset += $FFFF
  la a3,$10000000|(SampleEND&$3FFFFFF) ; A2 = Sample END Aligned Cart Physical ROM Offset ($10000000..$13FFFFFF 64MB)
  bge a2,a3,LoopSample ; IF (Sample ROM Offset >= Sample END Offset) LoopSample
  nop ; Delay Slot

  lui a3,PI_BASE ; A3 = PI Base Register ($A4600000)
  sw a1,PI_DRAM_ADDR(a3) ; Store RAM Offset To PI DRAM Address Register ($A4600000)
  sw a2,PI_CART_ADDR(a3) ; Store ROM Offset To PI Cart Address Register ($A4600004)
  li t0,$FFFE ; T0 = Length Of DMA Transfer In Bytes - 1
  sw t0,PI_WR_LEN(a3) ; Store DMA Length To PI Write Length Register ($A460000C)

  j LoopBuffer
  nop ; Delay Slot

Sample: ; 16-Bit 44100Hz Signed Big-Endian Stereo Sound Sample
  incbin Sample.bin
SampleEND: