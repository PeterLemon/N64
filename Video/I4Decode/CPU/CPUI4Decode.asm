// N64 'Bare Metal' 32BPP 320x240 CPU I4 Decode Frame Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "CPUI4Decode.N64", create
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

lui a0,$8010 // A0 = VI Frame Buffer DRAM Origin
la a1,I4 // A1 = I4 Offset
addiu a2,a1,$9600 // A2 = I4 End Offset
DecodeI4:
  lbu t0,0(a1) // T0 = I4 Frame Byte
  addiu a1,1 // I4 Offset++

  sll t1,t0,12 // T1 = I4 2nd Pixel
  andi t1,$F000
  sll t2,t1,8
  or t1,t2
  sll t2,8
  or t1,t2
  sll t0,8 // T0 = I4 1st Pixel
  andi t0,$F000
  sll t2,t0,8
  or t0,t2
  sll t2,8
  or t0,t2
  sw t0,0(a0) // Store 1st Pixel
  sw t1,4(a0) // Store 2nd Pixel
  
  bne a1,a2,DecodeI4 // IF (I4 Offset != I4 End Offset) DecodeI4
  addiu a0,8 // VI Frame Buffer DRAM Origin += 8 (Delay Slot)

Loop:
  j Loop
  nop // Delay Slot

insert I4, "frame.i4"