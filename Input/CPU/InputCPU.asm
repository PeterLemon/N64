// N64 'Bare Metal' Input CPU Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "InputCPU.N64", create
fill 1052672 // Set ROM Size

origin $00000000
base $80000000 // Entry Point Of Code
include "LIB\N64.INC" // Include N64 Definitions
include "LIB\N64_HEADER.ASM" // Include 64 Byte Header & Vector Table
insert "LIB\N64_BOOTCODE.BIN" // Include 4032 Byte Boot Code

Start:
  include "LIB\N64_GFX.INC" // Include Graphics Macros
  include "LIB\N64_INPUT.INC" // Include Input Macros
  N64_INIT() // Run N64 Initialisation Routine

  ScreenNTSC(320, 240, BPP32, $A0100000) // Screen NTSC: 320x240, 32BPP, DRAM Origin $A0100000

  lui a0,$A010 // A0 = VRAM Start Offset
  la a1,$A0100000+(320*240*4)-4 // A1 = VRAM End Offset
  lli t0,$000000FF // T0 = Black
ClearScreen:
  sw t0,0(a0)
  bne a0,a1,ClearScreen
  addi a0,4 // VRAM += 4

  la a3,$A0100000+(120*320*4)+(160*4) // A3 = Pixel Position
  
  InitController(PIF1) // Initialize Controller

Loop:
  WaitScanline($1E0) // Wait For Scanline To Reach Vertical Blank

  ReadController(PIF2) // T0 = Controller Buttons, T1 = Analog X, T2 = Analog Y

  andi t3,t0,JOY_UP // Test JOY UP
  beqz t3,Down
  nop // Delay Slot
  subi a3,320*4

Down:
  andi t3,t0,JOY_DOWN // Test JOY DOWN
  beqz t3,Left
  nop // Delay Slot
  addi a3,320*4

Left:
  andi t3,t0,JOY_LEFT // Test JOY LEFT
  beqz t3,Right
  nop // Delay Slot
  subi a3,4

Right:
  andi t3,t0,JOY_RIGHT // Test JOY RIGHT
  beqz t3,Render
  nop // Delay Slot
  addi a3,4

Render:
  li t0,$FFFFFFFF
  sw t0,0(a3)

  j Loop
  nop // Delay Slot

align(8) // Align 64-Bit
PIF1:
  dd $FF010401,0
  dd 0,0
  dd 0,0
  dd 0,0
  dd $FE000000,0
  dd 0,0
  dd 0,0
  dd 0,1

PIF2:
  fill 64 // Generate 64 Bytes Containing $00