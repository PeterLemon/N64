// PPU
lbu t0,REG_INIDISP(a0) // T0 = MEM_MAP[REG_INIDISP]
andi t0,$80            // IF (REG_INIDISP & $80 == 0) DISPLAY
bnez t0,VBLANKEND      // ELSE FORCED BLANK
ori t0,$94C0        // T0 = $94C0 (($AE7A / 262) * 224) (Delay Slot)
blt v0,t0,VBLANKEND // IF (Cycles Counter < $94C0) NO VBLANK
sb r0,REG_RDNMI(a0) // MEM_MAP[REG_RDNMI] = 0 (Delay Slot)
ori t0,$80          // T0 = $80
sb t0,REG_RDNMI(a0) // MEM_MAP[REG_RDNMI] = $80

VBLANKEND: