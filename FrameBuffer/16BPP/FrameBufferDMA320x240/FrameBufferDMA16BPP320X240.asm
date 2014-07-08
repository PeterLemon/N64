; N64 'Bare Metal' 16BPP Frame Buffer DMA 320x240 Demo by krom (Peter Lemon):

  include LIB\N64.INC ; Include N64 Definitions
  dcb 2097152,$00 ; Set ROM Size
  org $80000000 ; Entry Point Of Code
  include LIB\N64_HEADER.ASM  ; Include 64 Byte Header & Vector Table
  incbin LIB\N64_BOOTCODE.BIN ; Include 4032 Byte Boot Code

Start:
  include LIB\N64_INIT.ASM ; Include Initialisation Routine
  include LIB\N64_GFX.INC  ; Include Graphics Macros

  ScreenNTSC 320,240, BPP16, $A0100000 ; Screen NTSC: 320x240, 16BPP, DRAM Origin $A0100000

  DMA Image,ImageEnd, $00100000 ; DMA Data Copy Cart->DRAM: Start Cart Address, End Cart Address, Destination DRAM Address

Loop:
  j Loop
  nop ; Delay Slot

Image:
  incbin Image.bin
ImageEnd: