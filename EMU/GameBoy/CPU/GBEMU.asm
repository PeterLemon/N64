// N64 'Bare Metal' GameBoy Emulator by krom (Peter Lemon):
arch n64.cpu
endian msb
output "GBEMU.N64", create
fill 1052672 // Set ROM Size

origin $00000000
base $80000000 // Entry Point Of Code
include "LIB/N64.INC" // Include N64 Definitions
include "LIB/N64_HEADER.ASM" // Include 64 Byte Header & Vector Table
insert "LIB/N64_BOOTCODE.BIN" // Include 4032 Byte Boot Code

include "MEM.INC" // Include GameBoy Memory Map

// F Register (CPU Flag Register ZNHC0000 Low 4 Bits Always Zero)
constant C_FLAG($10) // F Register Bit 4 Carry Flag (0=No Carry, 1=Carry)
constant H_FLAG($20) // F Register Bit 5 Half Carry Flag (0=No Half Carry, 1=Half Carry)
constant N_FLAG($40) // F Register Bit 6 Negative/Sign Flag (0=Positive, 1=Negative)
constant Z_FLAG($80) // F Register Bit 7 Zero Flag (0=Nonzero, 1=Zero)

Start:
  include "LIB/N64_GFX.INC" // Include Graphics Macros
  include "LIB/N64_RSP.INC" // Include RSP Macros
  N64_INIT() // Run N64 Initialisation Routine
  ScreenNTSC(320, 240, BPP16|AA_MODE_2, $A0100000) // Screen NTSC: 320x240, 16BPP, Resample Only, DRAM Origin $A0100000

  // Setup CPU Registers
  and s0,r0 // S0 = 16-Bit Register AF (Bits 0..7 = F, Bits 8..15 = A)
  and s1,r0 // S1 = 16-Bit Register BC (Bits 0..7 = C, Bits 8..15 = B)
  and s2,r0 // S2 = 16-Bit Register DE (Bits 0..7 = E, Bits 8..15 = D)
  and s3,r0 // S3 = 16-Bit Register HL (Bits 0..7 = L, Bits 8..15 = H)
  and s4,r0 // S4 = 16-Bit Register PC (Program Counter)
  and sp,r0 // SP = 16-Bit Register SP (Stack Pointer)

  // Setup Other Registers
  and s5,r0   // S5 = LCD Quad Cycle Count
  and s6,r0   // S6 = Divider Register Quad Cycle Count
  and s7,r0   // S7 = Previous LCD STAT Mode
  ori s8,r0,4 // S8 = Previous TAC_REG (4096Hz)
  and t8,r0   // T8 = Timer Quad Cycles
  and t9,r0   // T9 = (IME) Interrupt Master Enable Flag (0 = Disable Interrupts, 1 = Enable Interrupts, Enabled In IE Register)

  // Copy 32768 Bytes Cartridge ROM To Memory Map
  lui a0,PI_BASE // A0 = PI Base Register ($A4600000)
  la t0,MEM_MAP&$7FFFFF // T0 = Aligned DRAM Physical RAM Offset ($00000000..$007FFFFF 8MB)
  sw t0,PI_DRAM_ADDR(a0) // Store RAM Offset To PI DRAM Address Register ($A4600000)
  la t0,$10000000|(GB_CART&$3FFFFFF) // T0 = Aligned Cart Physical ROM Offset ($10000000..$13FFFFFF 64MB)
  sw t0,PI_CART_ADDR(a0) // Store ROM Offset To PI Cart Address Register ($A4600004)
  la t0,$7FFF // T0 = Length Of DMA Transfer In Bytes - 1
  sw t0,PI_WR_LEN(a0) // Store DMA Length To PI Write Length Register ($A460000C)
  DMACartBusy:
    lw t0,PI_STATUS(a0) // T0 = Word From PI Status Register ($A4600010)
    andi t0,3 // AND PI Status With 3
    bnez t0,DMACartBusy // IF TRUE DMA Is Busy
    nop // Delay Slot

  // Copy 256 Bytes BIOS ROM To Memory Map
  lui a0,PI_BASE // A0 = PI Base Register ($A4600000)
  la t0,MEM_MAP&$7FFFFF // T0 = Aligned DRAM Physical RAM Offset ($00000000..$007FFFFF 8MB)
  sw t0,PI_DRAM_ADDR(a0) // Store RAM Offset To PI DRAM Address Register ($A4600000)
  la t0,$10000000|(GB_BIOS&$3FFFFFF) // T0 = Aligned Cart Physical ROM Offset ($10000000..$13FFFFFF 64MB)
  sw t0,PI_CART_ADDR(a0) // Store ROM Offset To PI Cart Address Register ($A4600004)
  la t0,$FF // T0 = Length Of DMA Transfer In Bytes - 1
  sw t0,PI_WR_LEN(a0) // Store DMA Length To PI Write Length Register ($A460000C)
  DMABiosBusy:
    lw t0,PI_STATUS(a0) // T0 = Word From PI Status Register ($A4600010)
    andi t0,3 // AND PI Status With 3
    bnez t0,DMABiosBusy // IF TRUE DMA Is Busy
    nop // Delay Slot

  la a0,MEM_MAP // A0 = MEM_MAP
  la a1,CPU_INST // A1 = CPU Instruction Table
  ori v1,r0,$4444 // V1 = Refresh Cycles 4MHz (4194304 Hz / 60 Hz = 69905 CPU Cycles / 4 = 17476 Quad Cycles)

Refresh: // Refresh At 60 Hz
  and v0,r0 // V0 = Quad Cycles Counter (Reset To Zero)
  and k0,r0 // K0 = Old Quad Cycles Counter (Reset To Zero)
  CPU_EMU:
    addu a2,a0,s4 // A2 = MEM_MAP + PC
    lbu t0,0(a2)  // T0 = CPU Instruction
    sll t0,2      // T0 = CPU Instruction * 4
    addu t0,a1    // T0 = CPU Instruction Indirect Table Opcode Offset
    lw t0,0(t0)   // T0 = CPU Instruction Table Opcode Offset
    jalr t0       // Run CPU Instruction
    addiu s4,1    // PC_REG++ (Delay Slot)

    include "IOPORT.asm" // Run IO Port

    blt v0,v1,CPU_EMU // Compare Quad Cycles Counter To Refresh Cycles
    nop // Delay Slot

  include "PPU/PPU.asm" // Run PPU

  la a0,MEM_MAP  // A0 = MEM_MAP
  la a1,CPU_INST // A1 = CPU Instruction Table

  b Refresh
  nop // Delay Slot

include "CPU.asm" // GameBoy CPU Instruction Table

// PPU Data
include "PPU/PPUINITRDP.asm" // PPU Init RDP Data
include "PPU/PPU2BPPRDP.asm" // PPU 2BPP RDP Data
include "PPU/PPUXBPPRSP.asm" // PPU XBPP RSP Data

// Memory
MEM_MAP: // SPC-700 Memory Map = $10000 Bytes
  fill $10000 // Generates $10000 Bytes Containing $00

insert GB_BIOS, "DMG_ROM.bin" // Include Game Boy DMG BIOS ROM (256 Bytes)

//insert GB_CART, "ROMS/PPU/HelloWorld.gb" // ** PASS **
//insert GB_CART, "ROMS/CPU/01-special.gb" // ** PASS **
//insert GB_CART, "ROMS/CPU/02-interrupts.gb" // ** PASS **
//insert GB_CART, "ROMS/CPU/03-op sp,hl.gb" // ** PASS **
//insert GB_CART, "ROMS/CPU/04-op r,imm.gb" // ** PASS **
//insert GB_CART, "ROMS/CPU/05-op rp.gb" // ** PASS **
//insert GB_CART, "ROMS/CPU/06-ld r,r.gb" // ** PASS **
//insert GB_CART, "ROMS/CPU/07-jr,jp,call,ret,rst.gb" // ** PASS **
//insert GB_CART, "ROMS/CPU/08-misc instrs.gb" // ** PASS **
//insert GB_CART, "ROMS/CPU/09-op r,r.gb" // ** PASS **
//insert GB_CART, "ROMS/CPU/10-bit ops.gb" // ** PASS **
//insert GB_CART, "ROMS/CPU/11-op a,(hl).gb" // ** PASS **
insert GB_CART, "ROMS/CPU/instr_timing.gb" // ** PASS **