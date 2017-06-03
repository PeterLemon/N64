CPU65816X0HEX5A:
  // $5A PHY                     Push Index Register Y
  PushNAT16(s2)          // STACK = Y_REG (16-Bit)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU65816X0HEX7A:
  // $7A PLY                     Pull Index Register Y From Stack
  PullNAT16(s2)          // Y_REG = STACK (16-Bit)
  TestNZ16(s2)           // Test Result Negative / Zero Flags Of Y_REG (16-Bit)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816X0HEX84:
  // $84 STY   dp                Store Index Register Y To Memory Direct Page
  StoreDP16(s2)          // DP = Y_REG (16-Bit)
  la sp,StoreWord        // Store Word
  jalr sp,sp
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU65816X0HEX86:
  // $86 STX   dp                Store Index Register X To Memory Direct Page
  StoreDP16(s1)          // DP = X_REG (16-Bit)
  la sp,StoreWord        // Store Word
  jalr sp,sp
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU65816X0HEX88:
  // $88 DEY                     Decrement Index Register Y
  subiu s2,1             // Y_REG-- (16-Bit)
  andi s2,$FFFF          // Y_REG = 16-Bit
  TestNZ16(s2)           // Test Result Negative / Zero Flags Of Y_REG (16-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU65816X0HEX8A:
  // $8A TXA                     Transfer Index Register X To Accumulator
  andi s0,s1,$FFFF       // A_REG = X_REG (16-Bit)
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU65816X0HEX8C:
  // $8C STY   nnnn              Store Index Register Y To Memory Absolute
  StoreABS16(s2)         // Absolute = Y_REG (16-Bit)
  la sp,StoreWord        // Store Word
  jalr sp,sp
  addiu s3,2             // PC_REG += 2 (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816X0HEX8E:
  // $8E STX   nnnn              Store Index Register X To Memory Absolute
  StoreABS16(s1)         // Absolute = X_REG (16-Bit)
  la sp,StoreWord        // Store Word
  jalr sp,sp
  addiu s3,2             // PC_REG += 2 (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816X0HEX94:
  // $94 STY   dp,X              Store Index Register Y To Memory Direct Page Indexed, X
  StoreDPX16(s2)         // DP Indexed, X = Y_REG (16-Bit)
  la sp,StoreWord        // Store Word
  jalr sp,sp
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816X0HEX96:
  // $96 STX   dp,Y              Store Index Register X To Memory Direct Page Indexed, Y
  StoreDPY16(s1)         // DP Indexed, Y = X_REG (16-Bit)
  la sp,StoreWord        // Store Word
  jalr sp,sp
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816X0HEX98:
  // $98 TYA                     Transfer Index Register Y To Accumulator
  andi s0,s2,$FFFF       // A_REG = Y_REG (16-Bit)
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU65816X0HEX9A:
  // $9A TXS                     Transfer Index Register X To Stack Pointer
  andi s4,s1,$FFFF       // S_REG = X_REG (16-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU65816X0HEX9B:
  // $9B TXY                     Transfer Index Register X To Y
  andi s2,s1,$FFFF       // Y_REG = X_REG (16-Bit)
  TestNZ16(s2)           // Test Result Negative / Zero Flags Of Y_REG (16-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU65816X0HEXA0:
  // $A0 LDY   #nnnn             Load Index Register Y From Memory Immediate
  LoadIMM16(s2)          // Y_REG = Immediate (16-Bit)
  TestNZ16(s2)           // Test Result Negative / Zero Flags Of Y_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

CPU65816X0HEXA2:
  // $A2 LDX   #nnnn             Load Index Register X From Memory Immediate
  LoadIMM16(s1)          // X_REG = Immediate (16-Bit)
  TestNZ16(s1)           // Test Result Negative / Zero Flags Of X_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

CPU65816X0HEXA4:
  // $A4 LDY   dp                Load Index Register Y From Memory Direct Page
  LoadDP16(s2)           // Y_REG = DP (16-Bit)
  TestNZ16(s2)           // Test Result Negative / Zero Flags Of Y_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU65816X0HEXA6:
  // $A6 LDX   dp                Load Index Register X From Memory Direct Page
  LoadDP16(s1)           // X_REG = DP (16-Bit)
  TestNZ16(s1)           // Test Result Negative / Zero Flags Of X_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU65816X0HEXA8:
  // $A8 TAY                     Transfer Accumulator To Index Register Y
  andi s2,s0,$FFFF       // Y_REG = A_REG (16-Bit)
  TestNZ16(s2)           // Test Result Negative / Zero Flags Of Y_REG (16-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU65816X0HEXAA:
  // $AA TAX                     Transfer Accumulator To Index Register X
  andi s1,s0,$FFFF       // X_REG = A_REG (16-Bit)
  TestNZ16(s1)           // Test Result Negative / Zero Flags Of X_REG (16-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU65816X0HEXAC:
  // $AC LDY   nnnn              Load Index Register Y From Memory Absolute
  LoadABS16(s2)          // Y_REG = Absolute (16-Bit)
  TestNZ16(s2)           // Test Result Negative / Zero Flags Of Y_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816X0HEXAE:
  // $AE LDX   nnnn              Load Index Register X From Memory Absolute
  LoadABS16(s1)          // X_REG = Absolute (16-Bit)
  TestNZ16(s1)           // Test Result Negative / Zero Flags Of X_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816X0HEXB4:
  // $B4 LDY   dp,X              Load Index Register Y From Memory Direct Page Indexed, X
  LoadDPX16(s2)          // Y_REG = DP Indexed, X (16-Bit)
  TestNZ16(s2)           // Test Result Negative / Zero Flags Of Y_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816X0HEXB6:
  // $B6 LDX   dp,Y              Load Index Register X From Memory Direct Page Indexed, Y
  LoadDPY16(s1)          // X_REG = DP Indexed, Y (16-Bit)
  TestNZ16(s1)           // Test Result Negative / Zero Flags Of X_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816X0HEXBA:
  // $BA TSX                     Transfer Stack Pointer To Index Register X
  andi s1,s4,$FFFF       // X_REG = S_REG (16-Bit)
  TestNZ16(s1)           // Test Result Negative / Zero Flags Of X_REG (16-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU65816X0HEXBB:
  // $BB TYX                     Transfer Index Register Y To X
  andi s1,s2,$FFFF       // X_REG = Y_REG (16-Bit)
  TestNZ16(s1)           // Test Result Negative / Zero Flags Of X_REG (16-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU65816X0HEXBC:
  // $BC LDY   nnnn,X            Load Index Register Y From Memory Absolute Indexed, X
  LoadABSX16(s2)         // Y_REG = Absolute Indexed, X (16-Bit)
  TestNZ16(s2)           // Test Result Negative / Zero Flags Of Y_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816X0HEXBE:
  // $BE LDX   nnnn,Y            Load Index Register X From Memory Absolute Indexed, Y
  LoadABSY16(s1)         // X_REG = Absolute Indexed, Y (16-Bit)
  TestNZ16(s1)           // Test Result Negative / Zero Flags Of X_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816X0HEXC0:
  // $C0 CPY   #nnnn             Compare Index Register Y With Memory Immediate
  LoadIMM16(t0)          // T0 = Immediate (16-Bit)
  TestNZCCMP16(s2)       // Test Result Negative / Zero / Carry Flags Of Y_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

CPU65816X0HEXC4:
  // $C4 CPY   dp                Compare Index Register Y With Memory Direct Page
  LoadDP16(t0)           // T0 = DP (16-Bit)
  TestNZCCMP16(s2)       // Test Result Negative / Zero / Carry Flags Of Y_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU65816X0HEXC8:
  // $C8 INY                     Increment Index Register Y
  addiu s2,1             // Y_REG++ (16-Bit)
  andi s2,$FFFF          // Y_REG = 16-Bit
  TestNZ16(s2)           // Test Result Negative / Zero Flags Of Y_REG (16-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU65816X0HEXCA:
  // $CA DEX                     Decrement Index Register X
  subiu s1,1             // X_REG-- (16-Bit)
  andi s1,$FFFF          // X_REG = 16-Bit
  TestNZ16(s1)           // Test Result Negative / Zero Flags Of X_REG (16-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU65816X0HEXCC:
  // $CC CPY   nnnn              Compare Index Register Y With Memory Absolute
  LoadABS16(t0)          // T0 = Absolute (16-Bit)
  TestNZCCMP16(s2)       // Test Result Negative / Zero / Carry Flags Of Y_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816X0HEXDA:
  // $DA PHX                     Push Index Register X
  PushNAT16(s1)          // STACK = X_REG (16-Bit)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU65816X0HEXE0:
  // $E0 CPX   #nnnn             Compare Index Register X With Memory Immediate
  LoadIMM16(t0)          // T0 = Immediate (16-Bit)
  TestNZCCMP16(s1)       // Test Result Negative / Zero / Carry Flags Of X_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

CPU65816X0HEXE4:
  // $E4 CPX   dp                Compare Index Register X With Memory Direct Page
  LoadDP16(t0)           // T0 = DP (16-Bit)
  TestNZCCMP16(s1)       // Test Result Negative / Zero / Carry Flags Of X_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU65816X0HEXE8:
  // $E8 INX                     Increment Index Register X
  addiu s1,1             // X_REG++ (16-Bit)
  andi s1,$FFFF          // X_REG = 16-Bit
  TestNZ16(s1)           // Test Result Negative / Zero Flags Of X_REG (16-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU65816X0HEXEC:
  // $EC CPX   nnnn              Compare Index Register X With Memory Absolute
  LoadABS16(t0)          // T0 = Absolute (16-Bit)
  TestNZCCMP16(s1)       // Test Result Negative / Zero / Carry Flags Of X_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816X0HEXFA:
  // $FA PLX                     Pull Index Register X From Stack
  PullNAT16(s1)          // X_REG = STACK (16-Bit)
  TestNZ16(s1)           // Test Result Negative / Zero Flags Of X_REG (16-Bit)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)