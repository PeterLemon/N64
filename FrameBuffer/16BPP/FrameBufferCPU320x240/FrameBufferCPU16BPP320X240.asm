// N64 'Bare Metal' 16BPP Frame Buffer CPU 320x240 Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "FrameBufferCPU16BPP320X240.N64", create
fill 1052672 // Set ROM Size

origin $00000000
base $80000000 // Entry Point Of Code
include "LIB/N64.INC" // Include N64 Definitions
include "LIB/N64_HEADER.ASM" // Include 64 Byte Header & Vector Table
insert "LIB/N64_BOOTCODE.BIN" // Include 4032 Byte Boot Code

Start:
  include "LIB/N64_GFX.INC" // Include Graphics Macros
  N64_INIT() // Run N64 Initialisation Routine

  ScreenNTSC(320, 240, BPP16, $A0100000) // Screen NTSC: 320x240, 16BPP, DRAM Origin $A0100000

  lui a0,$A010 // A0 = DRAM Start Offset
  la a1,$B0000000|(Image&$3FFFFFF) // A1 = Image ROM Start Offset ($B0000000..$B3FFFFFF)
  la a2,$B0000000|((Image+Image.size)&$3FFFFFF) // A2 = Image ROM End Offset ($B0000000..$B3FFFFFF)
DrawImage:
  lw t0,0(a1) // T0 = Next Word From Image
  sync // Sync Load
  sw t0,0(a0) // Store Word To RDRAM
  addi a1,4 // Add 4 To Image Offset
  bne a1,a2,DrawImage
  addi a0,4 // Add 4 To RDRAM Offset (Delay Slot)

Loop:
  j Loop
  nop

insert Image, "Image.bin"