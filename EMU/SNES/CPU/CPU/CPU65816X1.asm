CPU65816X1HEX5A:
  // $5A PHY                     Push Index Register Y
  PushNAT8(s2)           // STACK = Y_REG (8-Bit)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

CPU65816X1HEX7A:
  // $7A PLY                     Pull Index Register Y From Stack
  PullNAT8(s2)           // Y_REG = STACK (8-Bit)
  TestNZ8(s2)            // Test Result Negative / Zero Flags Of Y_REG (8-Bit)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU65816X1HEX8A:
  // $8A TXA                     Transfer Index Register X To Accumulator
  andi s0,s1,$FF         // A_REG = X_REG (8-Bit)
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU65816X1HEX98:
  // $98 TYA                     Transfer Index Register Y To Accumulator
  andi s0,s2,$FF         // A_REG: Set To Index Register Y (8-Bit)
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU65816X1HEX9B:
  // $9B TXY                     Transfer Index Register X To Y
  andi s2,s1,$FF         // Y_REG = X_REG (8-Bit)
  TestNZ8(s2)            // Test Result Negative / Zero Flags Of Y_REG (8-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU65816X1HEXBB:
  // $BB TYX                     Transfer Index Register Y To X
  andi s1,s2,$FF         // X_REG = Y_REG (8-Bit)
  TestNZ8(s1)            // Test Result Negative / Zero Flags Of X_REG (8-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU65816X1HEXDA:
  // $DA PHX                     Push Index Register X
  PushNAT8(s1)           // STACK = X_REG (8-Bit)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

CPU65816X1HEXFA:
  // $FA PLX                     Pull Index Register X From Stack
  PullNAT8(s1)           // X_REG = STACK (8-Bit)
  TestNZ8(s1)            // Test Result Negative / Zero Flags Of X_REG (8-Bit)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)