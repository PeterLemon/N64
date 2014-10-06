; N64 'Bare Metal' Sound Double Shot Mono 16BIT Demo by krom (Peter Lemon):
  include LIB\N64.INC ; Include N64 Definitions
  dcb 1052672,$00 ; Set ROM Size
  org $80000000 ; Entry Point Of Code
  include LIB\N64_HEADER.ASM  ; Include 64 Byte Header & Vector Table
  incbin LIB\N64_BOOTCODE.BIN ; Include 4032 Byte Boot Code

Start:
  N64_INIT ; Run N64 Initialisation Routine

  lui a0,AI_BASE ; A0 = AI Base Register ($A4500000)
  li t0,1 ; T0 = AI Control DMA Enable Bit (1)
  sw t0,AI_CONTROL(a0) ; Store AI Control DMA Enable Bit To AI Control Register ($A4500008)

  la t0,Sample ; T0 = Sample DRAM Offset
  sw t0,AI_DRAM_ADDR(a0) ; Store Sample DRAM Offset To AI DRAM Address Register ($A4500000)
  li t0,15 ; T0 = Sample Bit Rate (Bitrate-1)
  sw t0,AI_BITRATE(a0) ; Store Sample Bit Rate To AI Bit Rate Register ($A4500014)

  li t0,(VI_NTSC_CLOCK/(44100/2))-1 ; T0 = Sample Frequency: (VI_NTSC_CLOCK(48681812) / FREQ(44100 / 2)) - 1
  sw t0,AI_DACRATE(a0) ; Store Sample Frequency To AI DAC Rate Register ($A4500010)
  li t0,246288 ; T0 = Length Of Sample Buffer
  sw t0,AI_LEN(a0) ; Store Length Of Sample Buffer To AI Length Register ($A4500004)

AIBusy:
  lb t0,AI_STATUS(a0) ; T0 = AI Status Register Byte ($A450000C)
  andi t0,$40 ; AND AI Status With AI Status DMA Busy Bit ($40XXXXXX)
  bnez t0,AIBusy ; IF TRUE AI DMA Is Busy
  nop ; Delay Slot

  li t0,(VI_NTSC_CLOCK/(22050/2))-1 ; T0 = Sample Frequency: (VI_NTSC_CLOCK(48681812) / FREQ(22050 / 2)) - 1
  sw t0,AI_DACRATE(a0) ; Store Sample Frequency To AI DAC Rate Register ($A4500010)
  li t0,246288 ; T0 = Length Of Sample Buffer
  sw t0,AI_LEN(a0) ; Store Length Of Sample Buffer To AI Length Register ($A4500004)

Loop:
  j Loop
  nop ; Delay Slot

Sample: ; 16-Bit 44100Hz Signed Big-Endian Mono Sound Sample
  incbin Sample.bin