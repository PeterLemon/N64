; N64 'Bare Metal' Initialize Demo by krom (Peter Lemon):
  include LIB\N64.INC ; Include N64 Definitions
  dcb 1048576,$00 ; Set ROM Size
  org $80000000 ; Entry Point Of Code
  include LIB\N64_HEADER.ASM  ; Include 64 Byte Header & Vector Table
  incbin LIB\N64_BOOTCODE.BIN ; Include 4032 Byte Boot Code

Start:
  lui a0,PIF_BASE ; A0 = PIF Base Register ($BFC00000)
  li t0,8
  sw t0,(PIF_RAM+$3C)(a0)

Loop:
  j Loop
  nop ; Delay Slot