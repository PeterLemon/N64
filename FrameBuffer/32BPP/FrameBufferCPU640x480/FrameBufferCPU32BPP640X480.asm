; N64 'Bare Metal' 32BPP Frame Buffer CPU 640x480 Demo by krom (Peter Lemon):
  include LIB\N64.INC ; Include N64 Definitions
  dcb 2097152,$00 ; Set ROM Size
  org $80000000 ; Entry Point Of Code
  include LIB\N64_HEADER.ASM  ; Include 64 Byte Header & Vector Table
  incbin LIB\N64_BOOTCODE.BIN ; Include 4032 Byte Boot Code

Start:
  include LIB\N64_GFX.INC ; Include Graphics Macros
  N64_INIT ; Run N64 Initialisation Routine

  ScreenNTSC 640, 480, BPP32|INTERLACE|AA_MODE_2, $A0100000 ; Screen NTSC: 640x480, 32BPP, DRAM Origin $A0100000

  lui a0,$A010 ; A0 = DRAM Start Offset
  la a1,$B0000000|(Image&$3FFFFFF) ; A1 = Image ROM Start Offset ($B0000000..$B3FFFFFF)
  la a2,$B0000000|(ImageEnd&$3FFFFFF) ; A2 = Image ROM End Offset ($B0000000..$B3FFFFFF)
DrawImage:
  lw t0,0(a1) ; T0 = Next Word From Image
  sync ; Sync Load
  sw t0,0(a0) ; Store Word To RDRAM
  addi a1,4 ; Add 4 To Image Offset
  bne a1,a2,DrawImage
  addi a0,4 ; Add 4 To RDRAM Offset (Delay Slot)

Loop:
  WaitScanline $1E0 ; Wait For Scanline To Reach Vertical Blank
  WaitScanline $1E2

  li t0,$00000800 ; Even Field
  sw t0,VI_Y_SCALE(a0)

  WaitScanline $1E0 ; Wait For Scanline To Reach Vertical Blank
  WaitScanline $1E2

  li t0,$02000800 ; Odd Field
  sw t0,VI_Y_SCALE(a0)

  j Loop
  nop

Image:
  incbin Image.bin
ImageEnd: