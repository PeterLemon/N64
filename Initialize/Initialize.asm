; N64 'Bare Metal' Initialize Demo by krom (Peter Lemon):

  include LIB\N64.INC ; Include N64 Definitions
  dcb 2097152,$00 ; Set ROM Size
  org $80000000 ; Entry Point Of Code
  include LIB\N64_HEADER.ASM  ; Include 64 Byte Header & Vector Table
  incbin LIB\N64_BOOTCODE.BIN ; Include 4032 Byte Boot Code

Start:
  lui t0,$BFC0 ; Initialize N64 (Stop N64 From Crashing 5 Seconds After Boot)
  li t1,8
  sw t1,$7FC(t0)

Loop:
  j Loop
  nop ; Delay Slot