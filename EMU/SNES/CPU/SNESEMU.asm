// N64 'Bare Metal' SNES Emulator by krom (Peter Lemon):
arch n64.cpu
endian msb
output "SNESEMU.N64", create
fill 1052672 // Set ROM Size

origin $00000000
base $80000000 // Entry Point Of Code
include "LIB/N64.INC" // Include N64 Definitions
include "LIB/N64_HEADER.ASM" // Include 64 Byte Header & Vector Table
insert "LIB/N64_BOOTCODE.BIN" // Include 4032 Byte Boot Code

include "MEM.INC" // Include SNES Memory Map

// P Register (Processor Status Register Flags)
constant C_FLAG($1)   // P Register Bit 0 Carry Flag (0=No Carry, 1=Carry)
constant Z_FLAG($2)   // P Register Bit 1 Zero Flag (0=Nonzero, 1=Zero)
constant I_FLAG($4)   // P Register Bit 2 IRQ Disable Flag (0=IRQ Enable, 1=IRQ Disable)
constant D_FLAG($8)   // P Register Bit 3 Decimal Mode Flag (0=Normal, 1=BCD Mode for ADC/SBC opcodes)
constant B_FLAG($10)  // P Register Bit 4 Break Flag (0=IRQ/NMI, 1=BRK/PHP Opcode) (Emulation Mode)
constant X_FLAG($10)  // P Register Bit 4 X Flag Indicates Size Of Index Registers (0=16bit, 1=8bit) (Native Mode)
constant U_FLAG($20)  // P Register Bit 5 Unused Flag (Always 1) (Emulation Mode)
constant M_FLAG($20)  // P Register Bit 5 M Flag Indicates Size Of Accumulator (0=16bit, 1=8bit) (Native Mode)
constant V_FLAG($40)  // P Register Bit 6 Overflow Flag (0=No Overflow, 1=Overflow)
constant N_FLAG($80)  // P Register Bit 7 Negative/Sign Flag (0=Positive, 1=Negative)
constant E_FLAG($100) // P Register Bit 8 Emulation Flag (Can Be Accessed Only Via XCE Opcode) (0=Native Mode 65816, 1=Emulation Mode 6502)

Start:
  include "LIB/N64_GFX.INC" // Include Graphics Macros
  include "LIB/N64_RSP.INC" // Include RSP Macros
  N64_INIT() // Run N64 Initialisation Routine
  ScreenNTSC(320, 240, BPP16|AA_MODE_2, $A0100000) // Screen NTSC: 320x240, 16BPP, Resample Only, DRAM Origin $A0100000

  la a0,MEM_MAP // A0 = MEM_MAP
  la a1,CPU_INST // A1 = CPU Instruction Table
  //ori v1,r0,$73E2 // V1 = Refresh Cycles 1.78MHz (1780000Hz / 60Hz = 29666 CPU Cycles)
  ori v1,r0,$AE7A // V1 = Refresh Cycles 2.68MHz (2680000Hz / 60Hz = 44666 CPU Cycles)
  //ori v1,r0,$E912 // V1 = Refresh Cycles 3.58MHz (3580000Hz / 60Hz = 59666 CPU Cycles)

  // Setup SNES Registers
  and s0,r0 // S0 = 8/16-Bit Register A  (Accumulator Register)
  and s1,r0 // S1 = 8/16-Bit Register X  (Index Register)
  and s2,r0 // S2 = 8/16-Bit Register Y  (Index Register)
  and s3,r0 // S3 =   16-Bit Register PC (Program Counter)
  and s4,r0 // S4 = 8/16-Bit Register S  (Stack Pointer)
  and s5,r0 // S5 =    8-Bit Register P  (Processor Status Register)
  and s6,r0 // S6 =   16-Bit Register D  (Zeropage Offset: Expands 8-Bit [nn] To 16-Bit [00:nn+D])
  and s7,r0 // S7 =    8-Bit Register DB (Data Bank: Expands 16-Bit [nnnn] To 24-Bit [DB:nnnn])
  and s8,r0 // S8 =    8-Bit Register PB (Program Counter Bank: Expands 16-Bit PC To 24-Bit PB:PC)

  // Setup SNES Initial Values
  ori s4,$01FF // S_REG: Set To $01FF On Reset
  ori s5,E_FLAG+U_FLAG+B_FLAG+I_FLAG  // P_REG: Set To Emulation Mode 6502 On Reset (E + U + B + I Flag Set)
  ori a2,r0,RES2_VEC // PC_REG: Set To 6502 Reset Vector ($FFFC)
  addu a2,a0
  lbu t0,1(a2)
  sll t0,8
  lbu s3,RES2_VEC(a2)
  or s3,t0

Refresh:
  and v0,r0 // V0 = Cycles Counter (Reset To Zero)
  CPU_EMU:
    addu a2,a0,s3 // A2 = MEM_MAP + PC
    lbu t0,0(a2)  // T0 = CPU Instruction
    sll t0,2 // T0 = CPU Instruction * 4

    andi t1,s5,E_FLAG // P_REG: Test Emulation Flag
    bnez t1,EXECUTE // IF (E Flag != 0) Emulation Mode
    ori t1,r0,$1000 // T1 = Emulation Mode CPU Instruction Base (Delay Slot)
    andi t1,s5,M_FLAG+X_FLAG // T1 = M & X Flags
    sll t1,6 // T1 = Native Mode CPU Instruction Base

    EXECUTE:
      or t0,t1    // T0 |= Native/Emulation Mode CPU Instruction Base
      addu t0,a1  // T0 = CPU Instruction Indirect Table Opcode Offset
      lw t0,0(t0) // T0 = CPU Instruction Table Opcode Offset
      jalr t0     // Run CPU Instruction
      addiu s3,1  // PC_REG++ (Delay Slot)

      include "IO/IOPORT.asm" // Run IO Port

      blt v0,v1,CPU_EMU // Compare Cycles Counter To Refresh Cycles
      nop // Delay Slot

  include "PPU/PPU.asm" // Run PPU

  la a0,MEM_MAP  // A0 = MEM_MAP
  la a1,CPU_INST // A1 = CPU Instruction Table

  b Refresh
  nop // Delay Slot

include "CPU/CPU.asm" // Include CPU Macros & Tables
include "DMA/DMA.asm" // Include DMA Macros & Tables
include "IO/IO.asm"   // Include I/O Macros & Tables

// PPU Data
include "PPU/PPUPALRDP.asm" // PPU Palette Data
include "PPU/PPU2BPPRDP.asm" // PPU 2BPP RDP Data
include "PPU/PPU4BPPRDP.asm" // PPU 4BPP RDP Data
include "PPU/PPU8BPPRDP.asm" // PPU 8BPP RDP Data
include "PPU/PPUXBPPRSP.asm" // PPU XBPP RSP Data

// Additional Memory (Not Mapped To CPU Addresses) (Accessible Only Via I/O)
align(8) // Align 64-Bit
VRAM: // VRAM 32K Words (64KB)
  fill $10000 // Generates $10000 Bytes Containing $00

align(8) // Align 64-Bit
CGRAM: // Palette CGRAM 256 Words (512 Bytes)
  fill 512 // Generates 512 Bytes Containing $00

align(8) // Align 64-Bit
OAM: // OAM 256+16 Words (512+32 Bytes)
  fill (512+32) // Generates 512+32 Bytes Containing $00

SPC_RAM: // SPC Sound RAM (64KB)
  fill $10000 // Generates $10000 Bytes Containing $00

insert SPC_ROM, "spc700.rom" // SPC Sound ROM (64 Bytes BIOS Boot ROM)

// Memory
WRAM: // Work RAM (128KB)
  fill $20000 // Generates $20000 Bytes Containing $00

MEM_MAP: // Memory Map = $10000 Bytes
  //fill $10000 // Generates $10000 Bytes Containing $00
  fill $8000 // Generates $8000 Bytes Containing $00
//insert CART_ROM, "TEST/8x8BGMap8BPP32x32.sfc" // Copy 98304 Bytes of Cartridge into Memory Map ** PASS **
//insert CART_ROM, "TEST/8x8BGMap8BPP32x64.sfc" // Copy 98304 Bytes of Cartridge into Memory Map ** PASS **
//insert CART_ROM, "TEST/8x8BGMap8BPP64x32.sfc" // Copy 98304 Bytes of Cartridge into Memory Map ** PASS **
insert CART_ROM, "TEST/8x8BGMap8BPP64x64.sfc" // Copy 98304 Bytes of Cartridge into Memory Map ** PASS **
//insert CART_ROM, "TEST/LinearPicture2BPP.sfc" // Copy 32768 Bytes of Cartridge into Memory Map ** PASS **
//insert CART_ROM, "TEST/LinearPicture4BPP.sfc" // Copy 98304 Bytes of Cartridge into Memory Map ** PASS **
//insert CART_ROM, "TEST/LinearPicture8BPP.sfc" // Copy 98304 Bytes of Cartridge into Memory Map ** PASS **
//insert CART_ROM, "TEST/HelloWorld.sfc" // Copy 32768 Bytes of Cartridge into Memory Map ** PASS **
//insert CART_ROM, "TEST/CPUADC.sfc" // Copy 32768 Bytes of Cartridge into Memory Map ** PASS **
//insert CART_ROM, "TEST/CPUAND.sfc" // Copy 32768 Bytes of Cartridge into Memory Map ** PASS **
//insert CART_ROM, "TEST/CPUASL.sfc" // Copy 32768 Bytes of Cartridge into Memory Map ** PASS **
//insert CART_ROM, "TEST/CPUBIT.sfc" // Copy 32768 Bytes of Cartridge into Memory Map ** PASS **
//insert CART_ROM, "TEST/CPUBRA.sfc" // Copy 32768 Bytes of Cartridge into Memory Map ** PASS **
//insert CART_ROM, "TEST/CPUCMP.sfc" // Copy 32768 Bytes of Cartridge into Memory Map ** PASS **
//insert CART_ROM, "TEST/CPUDEC.sfc" // Copy 32768 Bytes of Cartridge into Memory Map ** PASS **
//insert CART_ROM, "TEST/CPUEOR.sfc" // Copy 32768 Bytes of Cartridge into Memory Map ** PASS **
//insert CART_ROM, "TEST/CPUINC.sfc" // Copy 32768 Bytes of Cartridge into Memory Map ** PASS **
//insert CART_ROM, "TEST/CPUJMP.sfc" // Copy 32768 Bytes of Cartridge into Memory Map ** PASS **
//insert CART_ROM, "TEST/CPULDR.sfc" // Copy 32768 Bytes of Cartridge into Memory Map ** PASS **
//insert CART_ROM, "TEST/CPULSR.sfc" // Copy 32768 Bytes of Cartridge into Memory Map ** PASS **
//insert CART_ROM, "TEST/CPUMOV.sfc" // Copy 32768 Bytes of Cartridge into Memory Map ** PASS **
//insert CART_ROM, "TEST/CPUMSC.sfc" // Copy 32768 Bytes of Cartridge into Memory Map ** PASS **
//insert CART_ROM, "TEST/CPUORA.sfc" // Copy 32768 Bytes of Cartridge into Memory Map ** PASS **
//insert CART_ROM, "TEST/CPUPHL.sfc" // Copy 32768 Bytes of Cartridge into Memory Map ** PASS **
//insert CART_ROM, "TEST/CPUPSR.sfc" // Copy 32768 Bytes of Cartridge into Memory Map ** PASS **
//insert CART_ROM, "TEST/CPURET.sfc" // Copy 32768 Bytes of Cartridge into Memory Map ** PASS **
//insert CART_ROM, "TEST/CPUROL.sfc" // Copy 32768 Bytes of Cartridge into Memory Map ** PASS **
//insert CART_ROM, "TEST/CPUROR.sfc" // Copy 32768 Bytes of Cartridge into Memory Map ** PASS **
//insert CART_ROM, "TEST/CPUSBC.sfc" // Copy 32768 Bytes of Cartridge into Memory Map ** PASS **
//insert CART_ROM, "TEST/CPUSTR.sfc" // Copy 32768 Bytes of Cartridge into Memory Map ** PASS **
//insert CART_ROM, "TEST/CPUTRN.sfc" // Copy 32768 Bytes of Cartridge into Memory Map ** PASS **