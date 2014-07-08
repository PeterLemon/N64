; N64 'Bare Metal' 16BPP Frame Buffer CPU 320x240 Demo by krom (Peter Lemon):

  include LIB\N64.INC ; Include N64 Definitions
  dcb 2097152,$00 ; Set ROM Size
  org $80000000 ; Entry Point Of Code
  include LIB\N64_HEADER.ASM  ; Include 64 Byte Header & Vector Table
  incbin LIB\N64_BOOTCODE.BIN ; Include 4032 Byte Boot Code

Start:
  include LIB\N64_INIT.ASM ; Include Initialisation Routine
  include LIB\N64_GFX.INC  ; Include Graphics Macros

  ScreenNTSC 320,240, BPP16, $A0100000 ; Screen NTSC: 320x240, 16BPP, DRAM Origin $A0100000

  lui t0,$A010 ; T0 = DRAM Start Offset
  la t1,$B0000000|(Image&$3FFFFFF) ; T1 = Image ROM Start Offset ($B0000000..$B3FFFFFF)
  la t2,$B0000000|(ImageEnd&$3FFFFFF) ; T2 = Image ROM End Offset ($B0000000..$B3FFFFFF)
DrawImage:
  lw t3,0(t1) ; T3 = Next Word From Image
  sync ; Sync Load
  sw t3,0(t0) ; Store Word To RDRAM
  addi t1,4 ; Add 4 To Image Offset
  bne t1,t2,DrawImage
  addi t0,4 ; Add 4 To RDRAM Offset (Delay Slot)

Loop:
  j Loop
  nop

Image:
  incbin Image.bin
ImageEnd: