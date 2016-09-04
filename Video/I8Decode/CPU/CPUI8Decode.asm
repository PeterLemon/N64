// N64 'Bare Metal' 32BPP 320x240 CPU I8 Decode Frame Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "CPUI8Decode.N64", create
fill 1052672 // Set ROM Size

origin $00000000
base $80000000 // Entry Point Of Code
include "LIB/N64.INC" // Include N64 Definitions
include "LIB/N64_HEADER.ASM" // Include 64 Byte Header & Vector Table
insert "LIB/N64_BOOTCODE.BIN" // Include 4032 Byte Boot Code

Start:
  include "LIB/N64_GFX.INC" // Include Graphics Macros
  N64_INIT() // Run N64 Initialisation Routine

  ScreenNTSC(320, 240, BPP32, $A0100000) // Screen NTSC: 320x240, 32BPP, DRAM Origin $A0100000

lui a0,$A010 // A0 = VI Frame Buffer DRAM Origin
la a1,I8 // A1 = I8 Offset
la a2,I8+$12C00 // A2 = I8 End Offset
DecodeI8:
  lbu t0,0(a1) // T0 = I8 Frame Byte
  addiu a1,1 // I8 Offset++
  sb t0,0(a0) // Store Pixel R
  sb t0,1(a0) // Store Pixel G
  sb t0,2(a0) // Store Pixel B
  bne a1,a2,DecodeI8 // IF (I8 Offset != I8 End Offset) DecodeI8
  addiu a0,4 // VI Frame Buffer DRAM Origin += 4 (Delay Slot)

Loop:
  j Loop
  nop // Delay Slot

insert I8, "frame.i8"