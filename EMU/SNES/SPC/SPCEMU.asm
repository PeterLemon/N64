// N64 'Bare Metal' SPC-700 Emulator by krom (Peter Lemon):
arch n64.cpu
endian msb
output "SPCEMU.N64", create
fill 1052672 // Set ROM Size

origin $00000000
base $80000000 // Entry Point Of Code
include "LIB\N64.INC" // Include N64 Definitions
include "LIB\N64_HEADER.ASM" // Include 64 Byte Header & Vector Table
insert "LIB\N64_BOOTCODE.BIN" // Include 4032 Byte Boot Code

include "MEM.INC" // Include SNES Memory Map

// PSW Register (Program Status Word Register Flags)
constant C_FLAG($1)   // PSW Register Bit 0 Carry Flag (0=No Carry, 1=Carry)
constant Z_FLAG($2)   // PSW Register Bit 1 Zero Flag (0=Nonzero, 1=Zero)
constant I_FLAG($4)   // PSW Register Bit 2 Interrupt Enable Flag
constant H_FLAG($8)   // PSW Register Bit 3 Half Carry Flag (0=No Half Carry, 1=Half Carry)
constant B_FLAG($10)  // PSW Register Bit 4 Break Flag
constant P_FLAG($20)  // PSW Register Bit 5 Direct Page Flag
constant V_FLAG($40)  // PSW Register Bit 6 Overflow Flag (0=No Overflow, 1=Overflow)
constant N_FLAG($80)  // PSW Register Bit 7 Negative/Sign Flag (0=Positive, 1=Negative)

Start:
  include "LIB\N64_GFX.INC" // Include Graphics Macros
  N64_INIT() // Run N64 Initialisation Routine
  ScreenNTSC(320, 240, BPP32, $A0100000) // Screen NTSC: 320x240, 32BPP, DRAM Origin $A0100000

  la a0,MEM_MAP // A0 = MEM_MAP
  la a1,CPU_INST // A1 = CPU Instruction Table
  lli v1,$42AA // V1 = Refresh Cycles 1.024MHz (1024000Hz / 60Hz = 17066 CPU Cycles)

  // Setup SPC Registers
  and s0,r0 // S0 =  8-Bit Register A   (Accumulator Register)
  and s1,r0 // S1 =  8-Bit Register X   (Index Register)
  and s2,r0 // S2 =  8-Bit Register Y   (Index Register)
  and s3,r0 // S3 = 16-Bit Register PC (Program Counter)
  and s4,r0 // S4 =  8-Bit Register SP  (Stack Pointer)
  and s5,r0 // S5 =  8-Bit Register PSW (Processor Status Register)
  // 16-bit Register YA (MSB=Y, LSB=A)

  and s6,r0 // S6 = Timer 0 Cycles
  and s7,r0 // S7 = Timer 1 Cycles
  and s8,r0 // S8 = Timer 2 Cycles
  
  // Setup SPC Initial Values (From SPC File)
  la a2,SPC_FILE // A2 = SPC_FILE
  lbu s0,$27(a2) // A_REG = SPC_FILE[$27]
  lbu s1,$28(a2) // X_REG = SPC_FILE[$28]
  lbu s2,$29(a2) // Y_REG = SPC_FILE[$29]
  lbu s4,$2B(a2) // SP_REG = SPC_FILE[$2B]
  lbu s5,$2A(a2) // PSW_REG = SPC_FILE[$2A] 
  lbu t0,$26(a2) // PC_REG = SPC_FILE+$25
  sll t0,8
  lbu s3,$25(a2)
  or s3,t0

  // Copy 65536 + 128 Bytes Of SPC_FILE To MEM MAP & DSP_MAP
  lui a2,PI_BASE // A2 = PI Base Register ($A4600000)
  la a3,MEM_MAP&$7FFFFF // A3 = Aligned DRAM Physical RAM Offset ($00000000..$007FFFFF 8MB)
  sw a3,PI_DRAM_ADDR(a2) // Store RAM Offset To PI DRAM Address Register ($A4600000)
  la a3,$10000000|((SPC_FILE+$100)&$3FFFFFF) // T0 = Aligned Cart Physical ROM Offset ($10000000..$13FFFFFF 64MB)
  sw a3,PI_CART_ADDR(a2) // Store ROM Offset To PI Cart Address Register ($A4600004)
  la t0,$1007F // T0 = Length Of DMA Transfer In Bytes - 1
  sw t0,PI_WR_LEN(a2) // Store DMA Length To PI Write Length Register ($A460000C)

Refresh:
  and v0,r0 // V0 = Cycles Counter (Reset To Zero)
  and k0,r0 // K0 = Old Cycles Counter (Reset To Zero)
  CPU_EMU:
    addu a2,a0,s3 // A2 = MEM_MAP + PC
    lbu t0,0(a2)  // T0 = CPU Instruction
    sll t0,8 // T0 = CPU Instruction * 256
    addu t0,a1 // T0 = CPU Instruction Table Opcode Offset
    jalr t0    // Run CPU Instruction
    addiu s3,1 // PC_REG++ (Delay Slot)

    include "IOPORT.asm" // Run IO Port

    blt v0,v1,CPU_EMU // Compare Cycles Counter To Refresh Cycles
    nop // Delay Slot

include "Debug.asm" // Show Debug

  lui a3,VI_BASE // A0 = VI Base Register ($A4400000)
  lli t0,$1E0 // T0 = Scan Line
  WaitScanline:
    lw t1,VI_V_CURRENT_LINE(a3) // T1 = Current Scan Line
    bne t1,t0,WaitScanline // IF (Current Scan Line != Scan Line) Wait
    nop // ELSE Continue (Delay Slot)

  j Refresh
  nop // Delay Slot

align(256)
CPU_INST:
  include "CPU.asm" // SPC=700 CPU Instruction Table

// Memory
MEM_MAP: // SPC-700 Memory Map = $10000 Bytes
  fill $10000 // Generates $10000 Bytes Containing $00

DSP_MAP: // SPC-700 DSP Map = $80 Bytes
  fill $80 // Generates $80 Bytes Containing $00

insert SPC_ROM, "spc700.rom" // SPC IPL ROM (64 Bytes BIOS Boot ROM)
insert SPC_FILE, "Twinkle.spc" // Include SPC File