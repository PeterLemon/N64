// N64 'Bare Metal' Initialize Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "Initialize.N64", create
fill 1052672 // Set ROM Size

origin $00000000
base $80000000 // Entry Point Of Code
include "LIB\N64.INC" // Include N64 Definitions
include "LIB\N64_HEADER.ASM" // Include 64 Byte Header & Vector Table
insert "LIB\N64_BOOTCODE.BIN" // Include 4032 Byte Boot Code

Start:
  lui a0,PIF_BASE // A0 = PIF Base Register ($BFC00000)
  lli t0,8
  sw t0,PIF_RAM+$3C(a0)

Loop:
  j Loop
  nop // Delay Slot