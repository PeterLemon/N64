// PPU
lbu t0,REG_INIDISP(a0) // T0 = MEM_MAP[REG_INIDISP]
andi t0,$80            // IF (REG_INIDISP & $80 == 0) DISPLAY
bnez t0,VBLANKEND      // ELSE FORCED BLANK
//sb t0,REG_RDNMI(a0)    // MEM_MAP[REG_RDNMI] = $80 (Delay Slot)
//sb r0,REG_RDNMI(a0)    // MEM_MAP[REG_RDNMI] = $80 (Delay Slot)
nop // Delay Slot

la t1,RDNMI           // T1 = RDNMI
ori t0,r0,$94C0       // T0 = $94C0 (($AE7A / 262) * 224)
bge v0,t0,VBLANKSTART // IF (Cycles Counter > $94C0) VBLANK START
nop                   // Delay Slot

sb r0,REG_RDNMI(a0) // MEM_MAP[REG_RDNMI] = 0 (Delay Slot)
sb r0,0(t1)         // RDNMI = 0 (Delay Slot)
b VBLANKEND

VBLANKSTART:
lbu t0,0(t1)        // T0 = RDNMI
bnez t0,VBLANKEND   // IF (RDNMI != 0) VBLANK END
sb r0,REG_RDNMI(a0) // MEM_MAP[REG_RDNMI] = 0 (Delay Slot)

ori t0,r0,$80       // T0 = $80 (Delay Slot)
sb t0,REG_RDNMI(a0) // MEM_MAP[REG_RDNMI] = $80

VBLANKEND:
