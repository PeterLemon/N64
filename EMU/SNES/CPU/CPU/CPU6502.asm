CPU6502HEX00:
  // $00 BRK   #nn               Software Break
  BRKEMU()               // STACK = PC_REG & P_REG, PC_REG = Breakpoint Vector
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

CPU6502HEX01:
  // $01 ORA   (dp,X)            OR Accumulator With Memory Direct Page Indexed Indirect, X
  LoadDPIX8(t0)          // T0 = DP Indexed Indirect, X (8-Bit)
  andi t1,s0,$FF         // T1 = A_REG (8-Bit)
  or t1,t0               // T1 |= DP Indexed Indirect, X
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t1               // A_REG |= T1
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU6502HEX02:
  // $02 COP   #nn               Co-Processor Enable
  COPEMU()               // STACK = PC_REG & P_REG, PC_REG = COP Vector
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

CPU6502HEX05:
  // $05 ORA   dp                OR Accumulator With Memory Direct Page
  LoadDP8(t0)            // T0 = DP (8-Bit)
  andi t1,s0,$FF         // T1 = A_REG (8-Bit)
  or t1,t0               // T1 |= DP
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t1               // A_REG |= T1
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

CPU6502HEX06:
  // $06 ASL   dp                Shift Memory Left Direct Page
  LoadDP8(t0)            // T0 = DP (8-Bit)
  sll t0,1               // T0 <<= 1
  sb t0,0(a2)            // DP = T0
  TestNZCASLROL8(t0)     // Test Result Negative / Zero / Carry Flags Of DP (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU6502HEX08:
  // $08 PHP                     Push Processor Status Register
  PushEMU8(s5)           // STACK = P_REG (8-Bit)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

CPU6502HEX09:
  // $09 ORA   #nn               OR Accumulator With Memory Immediate
  LoadIMM8(t0)           // T0 = Immediate (8-Bit)
  andi t1,s0,$FF         // T1 = A_REG (8-Bit)
  or t1,t0               // T1 |= Immediate
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t1               // A_REG |= T1
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU6502HEX0A:
  // $0A ASL A                   Shift Accumulator Left
  andi t0,s0,$FF         // T0 = A_REG (8-Bit)
  sll t0,1               // T0 <<= 1 (8-Bit)
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  andi t1,t0,$FF         // T1 = T0 & $FF
  or s0,t1               // A_REG |= T1
  TestNZCASLROL8(t0)     // Test Result Negative / Zero / Carry Flags Of A_REG (8-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU6502HEX0D:
  // $0D ORA   nnnn              OR Accumulator With Memory Absolute
  LoadABS8(t0)           // T0 = Absolute (8-Bit)
  andi t1,s0,$FF         // T1 = A_REG (8-Bit)
  or t1,t0               // T1 |= Absolute
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t1               // A_REG |= T1
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU6502HEX0E:
  // $0E ASL   nnnn              Shift Memory Left Absolute
  LoadABS8(t0)           // T0 = Absolute (8-Bit)
  sll t0,1               // T0 <<= 1 (8-Bit)
  sb t0,0(a2)            // Absolute = T0
  TestNZCASLROL8(t0)     // Test Result Negative / Zero / Carry Flags Of Absolute (8-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU6502HEX10:
  // $10 BPL   nn                Branch IF Plus
  BranchCLR(N_FLAG)      // IF (N Flag == 0) Branch, ELSE Continue
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU6502HEX11:
  // $11 ORA   (dp),Y            OR Accumulator With Memory Direct Page Indirect Indexed, Y
  LoadDPIY8(t0)          // T0 = DP Indirect Indexed, Y (8-Bit)
  andi t1,s0,$FF         // T1 = A_REG (8-Bit)
  or t1,t0               // T1 |= DP Indirect Indexed, Y
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t1               // A_REG |= T1
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU6502HEX15:
  // $15 ORA   dp,X              OR Accumulator With Memory Direct Page Indexed, X
  LoadDPX8(t0)           // T0 = DP Indexed, X (8-Bit)
  andi t1,s0,$FF         // T1 = A_REG (8-Bit)
  or t1,t0               // T1 |= DP Indexed, X
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t1               // A_REG |= T1
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU6502HEX16:
  // $16 ASL   dp,X              Shift Memory Left Direct Page Indexed, X
  LoadDPX8(t0)           // T0 = DP Indexed, X (8-Bit)
  sll t0,1               // T0 <<= 1
  sb t0,0(a2)            // DP Indexed, X = T0
  TestNZCASLROL8(t0)     // Test Result Negative / Zero / Carry Flags Of DP Indexed, X (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU6502HEX18:
  // $18 CLC                     Clear Carry Flag
  andi s5,~C_FLAG        // P_REG: C Flag Reset
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU6502HEX19:
  // $19 ORA   nnnn,Y            OR Accumulator With Memory Absolute Indexed, Y
  LoadABSY8(t0)          // T0 = Absolute Indexed, Y (8-Bit)
  andi t1,s0,$FF         // T1 = A_REG (8-Bit)
  or t1,t0               // T1 |= Absolute Indexed, Y
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t1               // A_REG |= T1
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU6502HEX1D:
  // $1D ORA   nnnn,X            OR Accumulator With Memory Absolute Indexed, X
  LoadABSX8(t0)          // T0 = Absolute Indexed, X (8-Bit)
  andi t1,s0,$FF         // T1 = A_REG (8-Bit)
  or t1,t0               // T1 |= Absolute Indexed, X
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t1               // A_REG |= T1
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU6502HEX1E:
  // $1E ASL   nnnn,X            Shift Memory Left Absolute Indexed, X
  LoadABSX8(t0)          // T0 = Absolute Indexed, X (8-Bit)
  sll t0,1               // T0 <<= 1 (8-Bit)
  sb t0,0(a2)            // Absolute Indexed, X = T0
  TestNZCASLROL8(t0)     // Test Result Negative / Zero / Carry Flags Of Absolute Indexed, X (8-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

CPU6502HEX20:
  // $20 JSR   nnnn              Jump To Subroutine Absolute
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  PushEMU16(s3)          // STACK = PC_REG (16-Bit)
  LoadIMM16(s3)          // PC_REG = Immediate (16-Bit)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU6502HEX21:
  // $21 AND   (dp,X)            AND Accumulator With Memory Direct Page Indexed Indirect, X
  LoadDPIX8(t0)          // T0 = DP Indexed Indirect, X (8-Bit)
  andi t1,s0,$FF         // T1 = A_REG (8-Bit)
  and t1,t0              // T1 &= DP Indexed Indirect, X
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t1               // A_REG |= T1
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU6502HEX24:
  // $24 BIT   dp                Test Memory Bits Against Accumulator Direct Page
  LoadDP8(t0)            // T0 = DP (8-Bit)
  TestNVZBIT8(t0)        // Test Result Negative / Overflow / Zero Flags Of DP (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

CPU6502HEX25:
  // $25 AND   dp                AND Accumulator With Memory Direct Page
  LoadDP8(t0)            // T0 = DP (8-Bit)
  andi t1,s0,$FF         // T1 = A_REG (8-Bit)
  and t1,t0              // T1 &= DP
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t1               // A_REG |= T1
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

CPU6502HEX26:
  // $26 ROL   dp                Rotate Memory Left Direct Page
  LoadDP8(t0)            // T0 = DP (8-Bit)
  sll t0,1               // T0 = Rotate Left (8-Bit)
  andi t1,s5,C_FLAG      // T1 = C Flag
  or t0,t1               // T0 |= C Flag (8-Bit)
  sb t0,0(a2)            // DP = T0
  TestNZCASLROL8(t0)     // Test Result Negative / Zero / Carry Flags Of DP (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU6502HEX28:
  // $28 PLP                     Pull Status Flags
  PullEMU8(s5)           // P_REG = STACK (8-Bit)
  ori s5,E_FLAG+U_FLAG   // P_REG: E/U Flag Set (6502 Emulation Mode)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU6502HEX29:
  // $29 AND   #nn               AND Accumulator With Memory Immediate
  LoadIMM8(t0)           // T0 = Immediate (8-Bit)
  andi t1,s0,$FF         // T1 = A_REG (8-Bit)
  and t1,t0              // T1 &= Immediate
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t1               // A_REG |= T1
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU6502HEX2A:
  // $2A ROL A                   Rotate Accumulator Left
  andi t0,s0,$FF         // T0 = A_REG (8-Bit)
  sll t0,1               // T0 <<= 1 (8-Bit)
  andi t1,s5,C_FLAG      // T1 = C Flag
  or t0,t1               // T0 |= C Flag (8-Bit)
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  andi t1,t0,$FF         // T1 = T0 & $FF
  or s0,t1               // A_REG |= T1
  TestNZCASLROL8(t0)     // Test Result Negative / Zero / Carry Flags Of A_REG (8-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU6502HEX2C:
  // $2C BIT   nnnn              Test Memory Bits Against Accumulator Absolute
  LoadABS8(t0)           // T0 = Absolute (8-Bit)
  TestNVZBIT8(t0)        // Test Result Negative / Overflow / Zero Flags Of Absolute (8-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU6502HEX2D:
  // $2D AND   nnnn              AND Accumulator With Memory Absolute
  LoadABS8(t0)           // T0 = Absolute (8-Bit)
  andi t1,s0,$FF         // T1 = A_REG (8-Bit)
  and t1,t0              // T1 &= Absolute
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t1               // A_REG |= T1
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU6502HEX2E:
  // $2E ROL   nnnn              Rotate Memory Left Absolute
  LoadABS8(t0)           // T0 = Absolute (8-Bit)
  sll t0,1               // T0 = Rotate Left (8-Bit)
  andi t1,s5,C_FLAG      // T1 = C Flag
  or t0,t1               // T0 |= C Flag (8-Bit)
  sb t0,0(a2)            // Absolute = T0
  TestNZCASLROL8(t0)     // Test Result Negative / Zero / Carry Flags Of Absolute (8-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU6502HEX30:
  // $30 BMI   nn                Branch IF Minus
  BranchSET(N_FLAG)      // IF (N Flag != 0) Branch, ELSE Continue
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU6502HEX31:
  // $31 AND   (dp),Y            AND Accumulator With Memory Direct Page Indirect Indexed, Y
  LoadDPIY8(t0)          // T0 = DP Indirect Indexed, Y (8-Bit)
  andi t1,s0,$FF         // T1 = A_REG (8-Bit)
  and t1,t0              // T1 &= DP Indirect Indexed, Y
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t1               // A_REG |= T1
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU6502HEX35:
  // $35 AND   dp,X              AND Accumulator With Memory Direct Page Indexed, X
  LoadDPX8(t0)           // T0 = DP Indexed, X (8-Bit)
  andi t1,s0,$FF         // T1 = A_REG (8-Bit)
  and t1,t0              // T1 &= DP Indexed, X
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t1               // A_REG |= T1
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU6502HEX36:
  // $36 ROL   dp,X              Rotate Memory Left Direct Page Indexed, X
  LoadDPX8(t0)           // T0 = DP Indexed, X (8-Bit)
  sll t0,1               // T0 = Rotate Left (8-Bit)
  andi t1,s5,C_FLAG      // T1 = C Flag
  or t0,t1               // T0 |= C Flag (8-Bit)
  sb t0,0(a2)            // DP Indexed, X = T0
  TestNZCASLROL8(t0)     // Test Result Negative / Zero / Carry Flags Of DP Indexed, X (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU6502HEX38:
  // $38 SEC                     Set Carry Flag
  ori s5,C_FLAG          // P_REG: C Flag Set
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU6502HEX39:
  // $39 AND   nnnn,Y            AND Accumulator With Memory Absolute Indexed, Y
  LoadABSY8(t0)          // T0 = Absolute Indexed, Y (8-Bit)
  andi t1,s0,$FF         // T1 = A_REG (8-Bit)
  and t1,t0              // T1 &= Absolute Indexed, Y
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t1               // A_REG |= T1
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU6502HEX3D:
  // $3D AND   nnnn,X            AND Accumulator With Memory Absolute Indexed, X
  LoadABSX8(t0)          // T0 = Absolute Indexed, X (8-Bit)
  andi t1,s0,$FF         // T1 = A_REG (8-Bit)
  and t1,t0              // T1 &= Absolute Indexed, X
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t1               // A_REG |= T1
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU6502HEX3E:
  // $3E ROL   nnnn,X            Rotate Memory Left Absolute Indexed, X
  LoadABSX8(t0)          // T0 = Absolute Indexed, X (8-Bit)
  sll t0,1               // T0 = Rotate Left (8-Bit)
  andi t1,s5,C_FLAG      // T1 = C Flag
  or t0,t1               // T0 |= C Flag (8-Bit)
  sb t0,0(a2)            // Absolute Indexed, X = T0
  TestNZCASLROL8(t0)     // Test Result Negative / Zero / Carry Flags Of Absolute Indexed, X (8-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

CPU6502HEX40:
  // $40 RTI                     Return From Interrupt
  RTIEMU()               // PC_REG & P_REG = STACK
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU6502HEX41:
  // $41 EOR   (dp,X)            Exclusive-OR Accumulator With Memory Direct Page Indexed Indirect, X
  LoadDPIX8(t0)          // T0 = DP Indexed Indirect, X (8-Bit)
  andi t1,s0,$FF         // T1 = A_REG (8-Bit)
  xor t1,t0              // T1 ^= DP Indexed Indirect, X
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t1               // A_REG |= T1
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU6502HEX45:
  // $45 EOR   dp                Exclusive-OR Accumulator With Memory Direct Page
  LoadDP8(t0)            // T0 = DP (8-Bit)
  andi t1,s0,$FF         // T1 = A_REG (8-Bit)
  xor t1,t0              // T1 ^= DP
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t1               // A_REG |= T1
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

CPU6502HEX46:
  // $46 LSR   dp                Logical Shift Memory Right Direct Page
  LoadDP8(t0)            // T0 = DP (8-Bit)
  andi t1,t0,1           // Test Negative MSB / Carry
  srl t0,1               // DP >>= 1 (8-Bit)
  sb t0,0(a2)            // DP = T0
  TestNZCLSRROR(t0)      // Test Result Negative / Zero / Carry Flags Of DP (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU6502HEX48:
  // $48 PHA                     Push Accumulator
  PushEMU8(s0)           // STACK = A_REG (8-Bit)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

CPU6502HEX49:
  // $49 EOR   #nn               Exclusive-OR Accumulator With Memory Immediate
  LoadIMM8(t0)           // T0 = Immediate (8-Bit)
  andi t1,s0,$FF         // T1 = A_REG (8-Bit)
  xor t1,t0              // T1 ^= Immediate
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t1               // A_REG |= T1
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU6502HEX4A:
  // $4A LSR A                   Logical Shift Accumulator Right
  andi t1,s0,1           // Test Negative MSB / Carry
  andi t0,s0,$FF         // T0 = A_REG (8-Bit)
  srl t0,1               // T0 >>= 1 (8-Bit)
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  andi t2,t0,$FF         // T2 = T0 & $FF
  or s0,t2               // A_REG |= T2
  TestNZCLSRROR(t0)      // Test Result Negative / Zero / Carry Flags Of A_REG (8-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU6502HEX4C:
  // $4C JMP   nnnn              Jump Absolute
  LoadIMM16(s3)          // PC_REG = Immediate (16-Bit)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

CPU6502HEX4D:
  // $4D EOR   nnnn              Exclusive-OR Accumulator With Memory Absolute
  LoadABS8(t0)           // T0 = Absolute (8-Bit)
  andi t1,s0,$FF         // T1 = A_REG (8-Bit)
  xor t1,t0              // T1 ^= Absolute
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t1               // A_REG |= T1
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU6502HEX4E:
  // $4E LSR   nnnn              Logical Shift Memory Right Absolute
  LoadABS8(t0)           // T0 = Absolute (8-Bit)
  andi t1,t0,1           // Test Negative MSB / Carry
  srl t0,1               // Absolute >>= 1 (8-Bit)
  sb t0,0(a2)            // Absolute = T0
  TestNZCLSRROR(t0)      // Test Result Negative / Zero / Carry Flags Of Absolute (8-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU6502HEX50:
  // $50 BVC   nn                Branch IF Overflow Clear
  BranchCLR(V_FLAG)      // IF (V Flag == 0) Branch, ELSE Continue
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU6502HEX51:
  // $51 EOR   (dp),Y            Exclusive-OR Accumulator With Memory Direct Page Indirect Indexed, Y
  LoadDPIY8(t0)          // T0 = DP Indirect Indexed, Y (8-Bit)
  andi t1,s0,$FF         // T1 = A_REG (8-Bit)
  xor t1,t0              // T1 ^= DP Indirect Indexed, Y
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t1               // A_REG |= T1
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU6502HEX55:
  // $55 EOR   dp,X              Exclusive-OR Accumulator With Memory Direct Page Indexed, X
  LoadDPX8(t0)           // T0 = DP Indexed, X (8-Bit)
  andi t1,s0,$FF         // T1 = A_REG (8-Bit)
  xor t1,t0              // T1 ^= DP Indexed, X
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t1               // A_REG |= T1
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU6502HEX56:
  // $56 LSR   dp,X              Logical Shift Memory Right Direct Page Indexed, X
  LoadDPX8(t0)           // T0 = DP Indexed, X (8-Bit)
  andi t1,t0,1           // Test Negative MSB / Carry
  srl t0,1               // DP Indexed, X >>= 1 (8-Bit)
  sb t0,0(a2)            // DP Indexed, X = T0
  TestNZCLSRROR(t0)      // Test Result Negative / Zero / Carry Flags Of DP Indexed, X (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU6502HEX58:
  // $58 CLI                     Clear Interrupt Disable Flag
  andi s5,~I_FLAG        // P_REG: I Flag Reset
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU6502HEX59:
  // $59 EOR   nnnn,Y            Exclusive-OR Accumulator With Memory Absolute Indexed, Y
  LoadABSY8(t0)          // T0 = Absolute Indexed, Y (8-Bit)
  andi t1,s0,$FF         // T1 = A_REG (8-Bit)
  xor t1,t0              // T1 ^= Absolute Indexed, Y
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t1               // A_REG |= T1
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU6502HEX5D:
  // $5D EOR   nnnn,X            Exclusive-OR Accumulator With Memory Absolute Indexed, X
  LoadABSX8(t0)          // T0 = Absolute Indexed, X (8-Bit)
  andi t1,s0,$FF         // T1 = A_REG (8-Bit)
  xor t1,t0              // T1 ^= Absolute Indexed, X
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t1               // A_REG |= T1
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU6502HEX5E:
  // $5E LSR   nnnn,X            Logical Shift Memory Right Absolute Indexed, X
  LoadABSX8(t0)          // T0 = Absolute Indexed, X (8-Bit)
  andi t1,t0,1           // Test Negative MSB / Carry
  srl t0,1               // Absolute Indexed, X >>= 1 (8-Bit)
  sb t0,0(a2)            // Absolute Indexed, X = T0
  TestNZCLSRROR(t0)      // Test Result Negative / Zero / Carry Flags Of Absolute Indexed, X (8-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

CPU6502HEX60:
  // $60 RTS                     Return From Subroutine
  PullEMU16(s3)          // PC_REG = STACK (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU6502HEX61:
  // $61 ADC   (dp,X)            Add With Carry Accumulator With Memory Direct Page Indexed Indirect, X
  LoadDPIX8(t0)          // T0 = DP Indexed Indirect, X (8-Bit)
  TestNVZCADC8(s0)       // Test Result Negative / Overflow / Zero / Carry Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU6502HEX65:
  // $65 ADC   dp                Add With Carry Accumulator With Memory Direct Page
  LoadDP8(t0)            // T0 = DP (8-Bit)
  TestNVZCADC8(s0)       // Test Result Negative / Overflow / Zero / Carry Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

CPU6502HEX66:
  // $66 ROR   dp                Rotate Memory Right Direct Page
  LoadDP8(t0)            // T0 = DP (8-Bit)
  andi t1,t0,1           // Test Negative MSB / Carry
  andi t2,s5,C_FLAG      // T2 = C Flag
  sll t2,7               // T2 <<= 7
  or t1,t2               // T1 = N/C Flags
  srl t0,1               // T0 >>= 1
  or t0,t2               // T0 |= C Flag (8-Bit)
  sb t0,0(a2)            // DP = Rotate Right (8-Bit)
  TestNZCLSRROR(t0)      // Test Result Negative / Zero / Carry Flags Of DP (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU6502HEX68:
  // $68 PLA                     Pull Accumulator
  PullEMU8(t0)           // T0 = STACK (8-Bit)
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t0               // A_REG |= T0
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU6502HEX69:
  // $69 ADC   #nn               Add With Carry Accumulator With Memory Immediate
  LoadIMM8(t0)           // T0 = Immediate (8-Bit)
  TestNVZCADC8(s0)       // Test Result Negative / Overflow / Zero / Carry Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU6502HEX6A:
  // $6A ROR A                   Rotate Accumulator Right
  andi t1,s0,1           // Test Negative MSB / Carry
  andi t2,s5,C_FLAG      // T2 = C Flag
  sll t2,7               // T2 <<= 7
  or t1,t2               // T1 = N/C Flags
  andi t0,s0,$FF         // T0 = A_REG (8-Bit)
  srl t0,1               // T0 >>= 1 (8-Bit)
  or t0,t2               // A_REG = Rotate Right (8-Bit)
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  andi t2,t0,$FF         // T2 = T0 & $FF
  or s0,t2               // A_REG |= T2
  TestNZCLSRROR(t0)      // Test Result Negative / Zero / Carry Flags Of A_REG (8-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU6502HEX6C:
  // $6C JMP   (nnnn)            Jump Absolute Indirect
  JumpABSI16()           // PC_REG = Absolute Indirect (16-Bit)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU6502HEX6D:
  // $6D ADC   nnnn              Add With Carry Accumulator With Memory Absolute
  LoadABS8(t0)           // T0 = Absolute (8-Bit)
  TestNVZCADC8(s0)       // Test Result Negative / Overflow / Zero / Carry Flags Of A_REG (8-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU6502HEX6E:
  // $6E ROR   nnnn              Rotate Memory Right Absolute
  LoadABS8(t0)           // T0 = Absolute (8-Bit)
  andi t1,t0,1           // Test Negative MSB / Carry
  andi t2,s5,C_FLAG      // T2 = C Flag
  sll t2,7               // T2 <<= 7
  or t1,t2               // T1 = N/C Flags
  srl t0,1               // T0 >>= 1
  or t0,t2               // T0 |= C Flag (8-Bit)
  sb t0,0(a2)            // Absolute = Rotate Right (8-Bit)
  TestNZCLSRROR(t0)      // Test Result Negative / Zero / Carry Flags Of Absolute (8-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU6502HEX70:
  // $70 BVS   nn                Branch IF Overflow Set
  BranchSET(V_FLAG)      // IF (V Flag != 0) Branch, ELSE Continue
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU6502HEX71:
  // $71 ADC   (dp),Y            Add With Carry Accumulator With Memory Direct Page Indirect Indexed, Y
  LoadDPIY8(t0)          // T0 = DP Indirect Indexed, Y (8-Bit)
  TestNVZCADC8(s0)       // Test Result Negative / Overflow / Zero / Carry Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU6502HEX75:
  // $75 ADC   dp,X              Add With Carry Accumulator With Memory Direct Page Indexed, X
  LoadDPX8(t0)           // T0 = DP Indexed, X (8-Bit)
  TestNVZCADC8(s0)       // Test Result Negative / Overflow / Zero / Carry Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU6502HEX76:
  // $76 ROR   dp,X              Rotate Memory Right Direct Page Indexed, X
  LoadDPX8(t0)           // T0 = DP Indexed, X (8-Bit)
  andi t1,t0,1           // Test Negative MSB / Carry
  andi t2,s5,C_FLAG      // T2 = C Flag
  sll t2,7               // T2 <<= 7
  or t1,t2               // T1 = N/C Flags
  srl t0,1               // T0 >>= 1
  or t0,t2               // T0 |= C Flag (8-Bit)
  sb t0,0(a2)            // DP Indexed, X = Rotate Right (8-Bit)
  TestNZCLSRROR(t0)      // Test Result Negative / Zero / Carry Flags Of DP Indexed, X (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU6502HEX78:
  // $78 SEI                     Set Interrupt Disable Flag
  ori s5,I_FLAG          // P_REG: I Flag Set
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU6502HEX79:
  // $79 ADC   nnnn,Y            Add With Carry Accumulator With Memory Absolute Indexed, Y
  LoadABSY8(t0)          // T0 = Absolute Indexed, Y (8-Bit)
  TestNVZCADC8(s0)       // Test Result Negative / Overflow / Zero / Carry Flags Of A_REG (8-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU6502HEX7D:
  // $7D ADC   nnnn,X            Add With Carry Accumulator With Memory Absolute Indexed, X
  LoadABSX8(t0)          // T0 = Absolute Indexed, X (8-Bit)
  TestNVZCADC8(s0)       // Test Result Negative / Overflow / Zero / Carry Flags Of A_REG (8-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU6502HEX7E:
  // $7E ROR   nnnn,X            Rotate Memory Right Absolute Indexed, X
  LoadABSX8(t0)          // T0 = Absolute Indexed, X (8-Bit)
  andi t1,t0,1           // Test Negative MSB / Carry
  andi t2,s5,C_FLAG      // T2 = C Flag
  sll t2,7               // T2 <<= 7
  or t1,t2               // T1 = N/C Flags
  srl t0,1               // T0 >>= 1
  or t0,t2               // T0 |= C Flag (8-Bit)
  sb t0,0(a2)            // Absolute Indexed, X = Rotate Right (8-Bit)
  TestNZCLSRROR(t0)      // Test Result Negative / Zero / Carry Flags Of Absolute Indexed, X (8-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

CPU6502HEX81:
  // $81 STA   (dp,X)            Store Accumulator To Memory Direct Page Indexed Indirect, X
  StoreDPIX8(s0)         // DP Indexed Indirect, X = A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU6502HEX84:
  // $84 STY   dp                Store Index Register Y To Memory Direct Page
  StoreDP8(s2)           // DP = Y_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

CPU6502HEX85:
  // $85 STA   dp                Store Accumulator To Memory Direct Page
  StoreDP8(s0)           // DP = A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

CPU6502HEX86:
  // $86 STX   dp                Store Index Register X To Memory Direct Page
  StoreDP8(s1)           // DP = X_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

CPU6502HEX88:
  // $88 DEY                     Decrement Index Register Y
  subiu s2,1             // Y_REG-- (8-Bit)
  andi s2,$FF            // Y_REG = 8-Bit
  TestNZ8(s2)            // Test Result Negative / Zero Flags Of Y_REG (8-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU6502HEX8A:
  // $8A TXA                     Transfer Index Register X To Accumulator
  andi t0,s1,$FF         // T0 = X_REG (8-Bit)
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t0               // A_REG |= T0
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU6502HEX8C:
  // $8C STY   nnnn              Store Index Register Y To Memory Absolute
  StoreABS8(s2)          // Absolute = Y_REG (8-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU6502HEX8D:
  // $8D STA   nnnn              Store Accumulator To Memory Absolute
  StoreABS8(s0)          // Absolute = A_REG (8-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU6502HEX8E:
  // $8E STX   nnnn              Store Index Register X To Memory Absolute
  StoreABS8(s1)          // Absolute = X_REG (8-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU6502HEX90:
  // $90 BCC   nn                Branch IF Carry Clear
  BranchCLR(C_FLAG)      // IF (C Flag == 0) Branch, ELSE Continue
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU6502HEX91:
  // $91 STA   (dp),Y            Store Accumulator To Memory Direct Page Indirect Indexed, Y
  StoreDPIY8(s0)         // DP Indirect Indexed, Y = A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU6502HEX94:
  // $94 STY   dp,X              Store Index Register Y To Memory Direct Page Indexed, X
  StoreDPX8(s2)          // DP Indexed, X = Y_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU6502HEX95:
  // $95 STA   dp,X              Store Accumulator To Memory Direct Page Indexed, X
  StoreDPX8(s0)          // DP Indexed, X = A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU6502HEX96:
  // $96 STX   dp,Y              Store Index Register X To Memory Direct Page Indexed, Y
  StoreDPY8(s1)          // DP Indexed, Y = X_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU6502HEX98:
  // $98 TYA                     Transfer Index Register Y To Accumulator
  andi t0,s2,$FF         // T0 = Y_REG (8-Bit)
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t0               // A_REG |= T0
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU6502HEX99:
  // $99 STA   nnnn,Y            Store Accumulator To Memory Absolute Indexed, Y
  StoreABSY8(s0)         // Absolute Indexed, Y = A_REG (8-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU6502HEX9A:
  // $9A TXS                     Transfer Index Register X To Stack Pointer
  andi s4,s1,$FF         // S_REG = X_REG (8-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU6502HEX9D:
  // $9D STA   nnnn,X            Store Accumulator To Memory Absolute Indexed, X
  StoreABSX8(s0)         // Absolute Indexed, X = A_REG (8-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU6502HEXA0:
  // $A0 LDY   #nn               Load Index Register Y From Memory Immediate
  LoadIMM8(s2)           // Y_REG = Immediate (8-Bit)
  TestNZ8(s2)            // Test Result Negative / Zero Flags Of Y_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU6502HEXA1:
  // $A1 LDA   (dp,X)            Load Accumulator From Memory Direct Page Indexed Indirect, X
  LoadDPIX8(t0)          // T0 = DP Indexed Indirect, X (8-Bit)
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t0               // A_REG |= T0
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU6502HEXA2:
  // $A2 LDX   #nn               Load Index Register X From Memory Immediate
  LoadIMM8(s1)           // X_REG = Immediate (8-Bit)
  TestNZ8(s1)            // Test Result Negative / Zero Flags Of X_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU6502HEXA4:
  // $A4 LDY   dp                Load Index Register Y From Memory Direct Page
  LoadDP8(s2)            // Y_REG = DP (8-Bit)
  TestNZ8(s2)            // Test Result Negative / Zero Flags Of Y_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

CPU6502HEXA5:
  // $A5 LDA   dp                Load Accumulator From Memory Direct Page
  LoadDP8(t0)            // T0 = DP (8-Bit)
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t0               // A_REG |= T0
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

CPU6502HEXA6:
  // $A6 LDX   dp                Load Index Register X From Memory Direct Page
  LoadDP8(s1)            // X_REG = DP (8-Bit)
  TestNZ8(s1)            // Test Result Negative / Zero Flags Of X_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

CPU6502HEXA8:
  // $A8 TAY                     Transfer Accumulator To Index Register Y
  andi s2,s0,$FF         // Y_REG = A_REG (8-Bit)
  TestNZ8(s2)            // Test Result Negative / Zero Flags Of Y_REG (8-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU6502HEXA9:
  // $A9 LDA   #nn               Load Accumulator From Memory Immediate
  LoadIMM8(t0)           // T0 = Immediate (8-Bit)  
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t0               // A_REG |= T0
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU6502HEXAA:
  // $AA TAX                     Transfer Accumulator To Index Register X
  andi s1,s0,$FF         // X_REG = A_REG (8-Bit)
  TestNZ8(s1)            // Test Result Negative / Zero Flags Of X_REG (8-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU6502HEXAC:
  // $AC LDY   nnnn              Load Index Register Y From Memory Absolute
  LoadABS8(s2)           // Y_REG = Absolute (8-Bit)
  TestNZ8(s2)            // Test Result Negative / Zero Flags Of Y_REG (8-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU6502HEXAD:
  // $AD LDA   nnnn              Load Accumulator From Memory Absolute
  LoadABS8(t0)           // T0 = Absolute (8-Bit)
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t0               // A_REG |= T0
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU6502HEXAE:
  // $AE LDX   nnnn              Load Index Register X From Memory Absolute
  LoadABS8(s1)           // X_REG = Absolute (8-Bit)
  TestNZ8(s1)            // Test Result Negative / Zero Flags Of X_REG (8-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU6502HEXB0:
  // $B0 BCS   nn                Branch IF Carry Set
  BranchSET(C_FLAG)      // IF (C Flag != 0) Branch, ELSE Continue
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU6502HEXB1:
  // $B1 LDA   (dp),Y            Load Accumulator From Memory Direct Page Indirect Indexed, Y
  LoadDPIY8(t0)          // T0 = DP Indirect Indexed, Y (8-Bit)
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t0               // A_REG |= T0
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU6502HEXB4:
  // $B4 LDY   dp,X              Load Index Register Y From Memory Direct Page Indexed, X
  LoadDPX8(s2)           // Y_REG = DP Indexed, X (8-Bit)
  TestNZ8(s2)            // Test Result Negative / Zero Flags Of Y_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU6502HEXB5:
  // $B5 LDA   dp,X              Load Accumulator From Memory Direct Page Indexed, X
  LoadDPX8(t0)           // T0 = DP Indexed, X (8-Bit)
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t0               // A_REG |= T0
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU6502HEXB6:
  // $B6 LDX   dp,Y              Load Index Register X From Memory Direct Page Indexed, Y
  LoadDPY8(s1)           // X_REG = DP Indexed, Y (8-Bit)
  TestNZ8(s1)            // Test Result Negative / Zero Flags Of X_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU6502HEXB8:
  // $B8 CLV                     Clear Overflow Flag
  andi s5,~V_FLAG        // P_REG: V Flag Reset
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU6502HEXB9:
  // $B9 LDA   nnnn,Y            Load Accumulator From Memory Absolute Indexed, Y
  LoadABSY8(t0)          // T0 = Absolute Indexed, Y (8-Bit)
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t0               // A_REG |= T0
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU6502HEXBA:
  // $BA TSX                     Transfer Stack Pointer To Index Register X
  andi s1,s4,$FF         // X_REG = S_REG (8-Bit)
  TestNZ8(s1)            // Test Result Negative / Zero Flags Of X_REG (8-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU6502HEXBC:
  // $BC LDY   nnnn,X            Load Index Register Y From Memory Absolute Indexed, X
  LoadABSX8(s2)          // Y_REG = Absolute Indexed, X (8-Bit)
  TestNZ8(s2)            // Test Result Negative / Zero Flags Of Y_REG (8-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU6502HEXBD:
  // $BD LDA   nnnn,X            Load Accumulator From Memory Absolute Indexed, X
  LoadABSX8(t0)          // T0 = Absolute Indexed, X (8-Bit)
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t0               // A_REG |= T0
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU6502HEXBE:
  // $BE LDX   nnnn,Y            Load Index Register X From Memory Absolute Indexed, Y
  LoadABSY8(s1)          // X_REG = Absolute Indexed, Y (8-Bit)
  TestNZ8(s1)            // Test Result Negative / Zero Flags Of X_REG (8-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU6502HEXC0:
  // $C0 CPY   #nn               Compare Index Register Y With Memory Immediate
  LoadIMM8(t0)           // T0 = Immediate (8-Bit)
  TestNZCCMP8(s2)        // Test Result Negative / Zero / Carry Flags Of Y_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU6502HEXC1:
  // $C1 CMP   (dp,X)            Compare Accumulator With Memory Direct Page Indexed Indirect, X
  LoadDPIX8(t0)          // T0 = DP Indexed Indirect, X (8-Bit)
  TestNZCCMP8(s0)        // Test Result Negative / Zero / Carry Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU6502HEXC2:
  // $C2 REP   #nn               Reset Status Bits
  REPEMU()               // P_REG: Immediate Flags Reset (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

CPU6502HEXC4:
  // $C4 CPY   dp                Compare Index Register Y With Memory Direct Page
  LoadDP8(t0)            // T0 = DP (8-Bit)
  TestNZCCMP8(s2)        // Test Result Negative / Zero / Carry Flags Of Y_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

CPU6502HEXC5:
  // $C5 CMP   dp                Compare Accumulator With Memory Direct Page
  LoadDP8(t0)            // T0 = DP (8-Bit)
  TestNZCCMP8(s0)        // Test Result Negative / Zero / Carry Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

CPU6502HEXC6:
  // $C6 DEC   dp                Decrement Memory Direct Page
  LoadDP8(t0)            // T0 = DP (8-Bit)
  subiu t0,1             // T0--
  sb t0,0(a2)            // DP = T0 (8-Bit)
  TestNZ8(t0)            // Test Result Negative / Zero Flags Of DP (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU6502HEXC8:
  // $C8 INY                     Increment Index Register Y
  addiu s2,1             // Y_REG++ (8-Bit)
  andi s2,$FF            // Y_REG = 8-Bit
  TestNZ8(s2)            // Test Result Negative / Zero Flags Of Y_REG (8-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU6502HEXC9:
  // $C9 CMP   #nn               Compare Accumulator With Memory Immediate
  LoadIMM8(t0)           // T0 = Immediate (8-Bit)
  TestNZCCMP8(s0)        // Test Result Negative / Zero / Carry Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU6502HEXCA:
  // $CA DEX                     Decrement Index Register X
  subiu s1,1             // X_REG-- (8-Bit)
  andi s1,$FF            // X_REG = 8-Bit
  TestNZ8(s1)            // Test Result Negative / Zero Flags Of X_REG (8-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU6502HEXCC:
  // $CC CPY   nnnn              Compare Index Register Y With Memory Absolute
  LoadABS8(t0)           // T0 = Absolute (8-Bit)
  TestNZCCMP8(s2)        // Test Result Negative / Zero / Carry Flags Of Y_REG (8-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU6502HEXCD:
  // $CD CMP   nnnn              Compare Accumulator With Memory Absolute
  LoadABS8(t0)           // T0 = Absolute (8-Bit)
  TestNZCCMP8(s0)        // Test Result Negative / Zero / Carry Flags Of A_REG (8-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU6502HEXCE:
  // $CE DEC   nnnn              Decrement Memory Absolute
  LoadABS8(t0)           // T0 = Absolute (8-Bit)
  subiu t0,1             // T0--
  sb t0,0(a2)            // Absolute = T0 (8-Bit)
  TestNZ8(t0)            // Test Result Negative / Zero Flags Of Absolute (8-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU6502HEXD0:
  // $D0 BNE   nn                Branch IF Not Equal
  BranchCLR(Z_FLAG)      // IF (Z Flag == 0) Branch, ELSE Continue
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU6502HEXD1:
  // $D1 CMP   (dp),Y            Compare Accumulator With Memory Direct Page Indirect Indexed, Y
  LoadDPIY8(t0)          // T0 = DP Indirect Indexed, Y (8-Bit)
  TestNZCCMP8(s0)        // Test Result Negative / Zero / Carry Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU6502HEXD5:
  // $D5 CMP   dp,X              Compare Accumulator With Memory Direct Page Indexed, X
  LoadDPX8(t0)           // T0 = DP Indexed, X (8-Bit)
  TestNZCCMP8(s0)        // Test Result Negative / Zero / Carry Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU6502HEXD6:
  // $D6 DEC   dp,X              Decrement Memory Direct Page Indexed, X
  LoadDPX8(t0)           // T0 = DP Indexed, X (8-Bit)
  subiu t0,1             // T0--
  sb t0,0(a2)            // DP Indexed, X = T0 (8-Bit)
  TestNZ8(t0)            // Test Result Negative / Zero Flags Of DP Indexed, X (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU6502HEXD8:
  // $D8 CLD                     Clear Decimal Mode Flag
  andi s5,~D_FLAG        // P_REG: D Flag Reset
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU6502HEXD9:
  // $D9 CMP   nnnn,Y            Compare Accumulator With Memory Absolute Indexed, Y
  LoadABSY8(t0)          // T0 = Absolute Indexed, Y (8-Bit)
  TestNZCCMP8(s0)        // Test Result Negative / Zero / Carry Flags Of A_REG (8-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU6502HEXDD:
  // $DD CMP   nnnn,X            Compare Accumulator With Memory Absolute Indexed, X
  LoadABSX8(t0)          // T0 = Absolute Indexed, X (8-Bit)
  TestNZCCMP8(s0)        // Test Result Negative / Zero / Carry Flags Of A_REG (8-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU6502HEXDE:
  // $DE DEC   nnnn,X            Decrement Memory Absolute Indexed, X
  LoadABSX8(t0)          // T0 = Absolute Indexed, X (8-Bit)
  subiu t0,1             // T0--
  sb t0,0(a2)            // Absolute Indexed, X = T0 (8-Bit)
  TestNZ8(t0)            // Test Result Negative / Zero Flags Of Absolute Indexed, X (8-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

CPU6502HEXE0:
  // $E0 CPX   #nn               Compare Index Register X With Memory Immediate
  LoadIMM8(t0)           // T0 = Immediate (8-Bit)
  TestNZCCMP8(s1)        // Test Result Negative / Zero / Carry Flags Of X_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU6502HEXE1:
  // $E1 SBC   (dp,X)            Subtract With Borrow From Accumulator With Memory Direct Page Indexed Indirect, X
  LoadDPIX8(t0)          // T0 = DP Indexed Indirect, X (8-Bit)
  TestNVZCSBC8(s0)       // Test Result Negative / Overflow / Zero / Carry Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU6502HEXE2:
  // $E2 SEP   #nn               Set Status Bits
  SEPEMU()               // P_REG: Immediate Flags Set (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

CPU6502HEXE4:
  // $E4 CPX   dp                Compare Index Register X With Memory Direct Page
  LoadDP8(t0)            // T0 = DP (8-Bit)
  TestNZCCMP8(s1)        // Test Result Negative / Zero / Carry Flags Of X_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

CPU6502HEXE5:
  // $E5 SBC   dp                Subtract With Borrow From Accumulator With Memory Direct Page
  LoadDP8(t0)            // T0 = DP (8-Bit)
  TestNVZCSBC8(s0)       // Test Result Negative / Overflow / Zero / Carry Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

CPU6502HEXE6:
  // $E6 INC   dp                Increment Memory Direct Page
  LoadDP8(t0)            // T0 = DP (8-Bit)
  addiu t0,1             // T0++
  sb t0,0(a2)            // DP = T0 (8-Bit)
  andi t0,$FF            // T0 = 8-Bit
  TestNZ8(t0)            // Test Result Negative / Zero Flags Of DP (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU6502HEXE8:
  // $E8 INX                     Increment Index Register X
  addiu s1,1             // X_REG++ (8-Bit)
  andi s1,$FF            // X_REG = 8-Bit
  TestNZ8(s1)            // Test Result Negative / Zero Flags Of X_REG (8-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU6502HEXE9:
  // $E9 SBC   #nn               Subtract With Borrow From Accumulator With Memory Immediate
  LoadIMM8(t0)           // T0 = Immediate (8-Bit)
  TestNVZCSBC8(s0)       // Test Result Negative / Overflow / Zero / Carry Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU6502HEXEA:
  // $EA NOP                     No Operation
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU6502HEXEC:
  // $EC CPX   nnnn              Compare Index Register X With Memory Absolute
  LoadABS8(t0)           // T0 = Absolute (8-Bit)
  TestNZCCMP8(s1)        // Test Result Negative / Zero / Carry Flags Of X_REG (8-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU6502HEXED:
  // $ED SBC   nnnn              Subtract With Borrow From Accumulator With Memory Absolute
  LoadABS8(t0)           // T0 = Absolute (8-Bit)
  TestNVZCSBC8(s0)       // Test Result Negative / Overflow / Zero / Carry Flags Of A_REG (8-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU6502HEXEE:
  // $EE INC   nnnn              Increment Memory Absolute
  LoadABS8(t0)           // T0 = Absolute (8-Bit)
  addiu t0,1             // T0++
  sb t0,0(a2)            // Absolute = T0 (8-Bit)
  andi t0,$FF            // T0 = 8-Bit
  TestNZ8(t0)            // Test Result Negative / Zero Flags Of Absolute (8-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU6502HEXF0:
  // $F0 BEQ   nn                Branch IF Equal
  BranchSET(Z_FLAG)      // IF (Z Flag != 0) Branch, ELSE Continue
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU6502HEXF1:
  // $F1 SBC   (dp),Y            Subtract With Borrow From Accumulator With Memory Direct Page Indirect Indexed, Y
  LoadDPIY8(t0)          // T0 = DP Indirect Indexed, Y (8-Bit)
  TestNVZCSBC8(s0)       // Test Result Negative / Overflow / Zero / Carry Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU6502HEXF5:
  // $F5 SBC   dp,X              Subtract With Borrow From Accumulator With Memory Direct Page Indexed, X
  LoadDPX8(t0)           // T0 = DP Indexed, X (8-Bit)
  TestNVZCSBC8(s0)       // Test Result Negative / Overflow / Zero / Carry Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU6502HEXF6:
  // $F6 INC   dp,X              Increment Memory Direct Page Indexed, X
  LoadDPX8(t0)           // T0 = DP Indexed, X (8-Bit)
  addiu t0,1             // T0++
  sb t0,0(a2)            // DP Indexed, X = T0 (8-Bit)
  andi t0,$FF            // T0 = 8-Bit
  TestNZ8(t0)            // Test Result Negative / Zero Flags Of DP Indexed, X (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU6502HEXF8:
  // $F8 SED                     Set Decimal Mode Flag
  ori s5,D_FLAG          // P_REG: D Flag Set
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU6502HEXF9:
  // $F9 SBC   nnnn,Y            Subtract With Borrow From Accumulator With Memory Absolute Indexed, Y
  LoadABSY8(t0)          // T0 = Absolute Indexed, Y (8-Bit)
  TestNVZCSBC8(s0)       // Test Result Negative / Overflow / Zero / Carry Flags Of A_REG (8-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU6502HEXFB:
  // $FB XCE                     Exchange Carry & Emulation Bits
  XCE()                  // P_REG: C Flag = E Flag / E Flag = C Flag
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU6502HEXFD:
  // $FD SBC   nnnn,X            Subtract With Borrow From Accumulator With Memory Absolute Indexed, X
  LoadABSX8(t0)          // T0 = Absolute Indexed, X (8-Bit)
  TestNVZCSBC8(s0)       // Test Result Negative / Overflow / Zero / Carry Flags Of A_REG (8-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU6502HEXFE:
  // $FE INC   nnnn,X            Increment Memory Absolute Indexed, X
  LoadABSX8(t0)          // T0 = Absolute Indexed, X (8-Bit)
  addiu t0,1             // T0++
  sb t0,0(a2)            // Absolute Indexed, X = T0 (8-Bit)
  andi t0,$FF            // T0 = 16-Bit
  TestNZ8(t0)            // Test Result Negative / Zero Flags Of Absolute Indexed, X (8-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)