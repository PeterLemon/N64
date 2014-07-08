; N64 'Bare Metal' Sound Single Shot Mono 16BIT Demo by krom (Peter Lemon):

  include LIB\N64.INC ; Include N64 Definitions
  dcb 2097152,$00 ; Set ROM Size
  org $80000000 ; Entry Point Of Code
  include LIB\N64_HEADER.ASM  ; Include 64 Byte Header & Vector Table
  incbin LIB\N64_BOOTCODE.BIN ; Include 4032 Byte Boot Code

Start:
  include LIB\N64_INIT.ASM ; Include Initialisation Routine

  lui t0,AI_BASE; AI Base Reg: Initialize Sound
  li t1,1 ; Load AI Control DMA Enable Bit (1)
  sw t1,AI_CONTROL(t0) ; Store AI Control DMA Enable Bit To AI Control Reg $A4500008

  la t1,Sample ; Sample DRAM Offset
  sw t1,AI_DRAM_ADDR(t0) ; Store Sample DRAM Offset To AI DRAM Address Reg $A4500000
  li t1,15 ; Load Sample Bit Rate (Bitrate-1)
  sw t1,AI_BITRATE(t0) ; Store Sample Bit Rate To AI Bit Rate Reg $A4500014

  li t1,(VI_NTSC_CLOCK/(44100/2))-1 ; Load Sample Frequency: (VI_NTSC_CLOCK(48681812) / FREQ(44100 / 2)) - 1
  sw t1,AI_DACRATE(t0) ; Store Sample Frequency To AI DAC Rate Reg $A4500010
  li t1,246288 ; Length Of Sample Buffer
  sw t1,AI_LEN(t0) ; Store Length Of Sample Buffer To AI Length Reg $A4500004

Loop:
  j Loop
  nop ; Delay Slot

Sample:
  incbin Sample.bin