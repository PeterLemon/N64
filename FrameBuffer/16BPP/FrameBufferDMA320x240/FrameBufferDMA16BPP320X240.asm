// N64 'Bare Metal' 16BPP Frame Buffer DMA 320x240 Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "FrameBufferDMA16BPP320X240.N64", create
fill 1052672 // Set ROM Size

origin $00000000
base $80000000 // Entry Point Of Code
include "LIB\N64.INC" // Include N64 Definitions
include "LIB\N64_HEADER.ASM" // Include 64 Byte Header & Vector Table
insert "LIB\N64_BOOTCODE.BIN" // Include 4032 Byte Boot Code

Start:
  include "LIB\N64_GFX.INC" // Include Graphics Macros
  N64_INIT() // Run N64 Initialisation Routine

  ScreenNTSC(320, 240, BPP16, $A0100000) // Screen NTSC: 320x240, 16BPP, DRAM Origin $A0100000

  DMA(Image, Image+Image.size, $00100000) // DMA Data Copy Cart->DRAM: Start Cart Address, End Cart Address, Destination DRAM Address

Loop:
  j Loop
  nop // Delay Slot

insert Image, "Image.bin"