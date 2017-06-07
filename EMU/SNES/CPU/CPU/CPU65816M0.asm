CPU65816M0HEX01:
  // $01 ORA   (dp,X)            OR Accumulator With Memory Direct Page Indexed Indirect, X
  LoadDPIX16(t0)         // T0 = DP Indexed Indirect, X (16-Bit)
  or s0,t0               // A_REG |= DP Indexed Indirect, X
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

CPU65816M0HEX03:
  // $03 ORA   sr,S              OR Accumulator With Memory Stack Relative
  LoadSR16(t0)           // T0 = SR (16-Bit)
  or s0,t0               // A_REG |= SR
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M0HEX04:
  // $04 TSB   dp                Test & Set Bits In Direct Page Offset With A
  LoadDP16(t0)           // T0 = DP (16-Bit)
  or t1,t0,s0            // T1 = A_REG | DP (Set Bits)
  sb t1,0(a2)            // DP = Set Bits LO Byte
  srl t1,8               // T1 = Set Bits HI Byte
  sb t1,1(a2)            // DP = Set Bits (16-Bit)
  TestZBIT(t0)           // Test Result Zero Flag Of DP (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

CPU65816M0HEX05:
  // $05 ORA   dp                OR Accumulator With Memory Direct Page
  LoadDP16(t0)           // T0 = DP (16-Bit)
  or s0,t0               // A_REG |= DP
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU65816M0HEX06:
  // $06 ASL   dp                Shift Memory Left Direct Page
  LoadDP16(t0)           // T0 = DP (16-Bit)
  sll t0,1               // T0 <<= 1 (16-Bit)
  sb t0,0(a2)            // DP = T0 LO Byte
  srl t1,t0,8            // T1 = T0 HI Byte
  sb t1,1(a2)            // DP = T0 (16-Bit)
  TestNZCASLROL16(t0)    // Test Result Negative / Zero / Carry Flags Of DP (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

CPU65816M0HEX07:
  // $07 ORA   [dp]              OR Accumulator With Memory Direct Page Indirect Long
  LoadDPIL16(t0)         // T0 = DP Indirect Long (16-Bit)
  or s0,t0               // A_REG |= DP Indirect Long
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

CPU65816M0HEX09:
  // $09 ORA   #nnnn             OR Accumulator With Memory Immediate
  LoadIMM16(t0)          // T0 = Immediate (16-Bit)
  or s0,t0               // A_REG |= Immediate
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

CPU65816M0HEX0A:
  // $0A ASL A                   Shift Accumulator Left
  sll s0,1               // A_REG <<= 1 (16-Bit)
  TestNZCASLROL16(s0)    // Test Result Negative / Zero / Carry Flags Of A_REG (16-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU65816M0HEX0C:
  // $0C TSB   nnnn              Test & Set Memory Bits Against Accumulator Absolute
  LoadABS16(t0)          // T0 = Absolute (16-Bit)
  or t1,t0,s0            // T1 = A_REG | Absolute (Set Bits)
  sb t1,0(a2)            // Absolute = Set Bits LO Byte
  srl t1,8               // T1 = Set Bits HI Byte
  sb t1,1(a2)            // Absolute = Set Bits (16-Bit)
  TestZBIT(t0)           // Test Result Zero Flag Of Absolute (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,8             // Cycles += 8 (Delay Slot)

CPU65816M0HEX0D:
  // $0D ORA   nnnn              OR Accumulator With Memory Absolute
  LoadABS16(t0)          // T0 = Absolute (16-Bit)
  or s0,t0               // A_REG |= Absolute
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M0HEX0E:
  // $0E ASL   nnnn              Shift Memory Left Absolute
  LoadABS16(t0)          // T0 = Absolute (16-Bit)
  sll t0,1               // T0 <<= 1 (16-Bit)
  sb t0,0(a2)            // Absolute = T0 LO Byte
  srl t1,t0,8            // T1 = T0 HI Byte
  sb t1,1(a2)            // Absolute = T0 (16-Bit)
  TestNZCASLROL16(t0)    // Test Result Negative / Zero / Carry Flags Of Absolute (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,8             // Cycles += 8 (Delay Slot)

CPU65816M0HEX0F:
  // $0F ORA   nnnnnn            OR Accumulator With Memory Absolute Long
  LoadABSL16(t0)         // T0 = Absolute Long (16-Bit)
  or s0,t0               // A_REG |= Absolute Long
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,3             // PC_REG += 3 (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU65816M0HEX11:
  // $11 ORA   (dp),Y            OR Accumulator With Memory Direct Page Indirect Indexed, Y
  LoadDPIY16(t0)         // T0 = DP Indirect Indexed, Y (16-Bit)
  or s0,t0               // A_REG |= DP Indirect Indexed, Y
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU65816M0HEX12:
  // $12 ORA   (dp)              OR Accumulator With Memory Direct Page Indirect
  LoadDPI16(t0)          // T0 = DP Indirect (16-Bit)
  or s0,t0               // A_REG |= DP Indirect
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU65816M0HEX13:
  // $13 ORA   (sr,S),Y          OR Accumulator With Memory Stack Relative Indirect Indexed, Y
  LoadSRIY16(t0)         // T0 = SR Indirect Indexed, Y (16-Bit)
  or s0,t0               // A_REG |= SR Indirect Indexed, Y
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,8             // Cycles += 8 (Delay Slot)

CPU65816M0HEX14:
  // $14 TRB   dp                Test & Reset Memory Bits Against Accumulator Direct Page
  LoadDP16(t0)           // T0 = DP (16-Bit)
  xori t1,s0,$FFFF       // T1 = A_REG ^ $FFFF (Complement)
  and t1,t0              // T1 = Reset Bits
  sb t1,0(a2)            // DP = Reset Bits LO Byte
  srl t1,8               // T1 = Reset Bits HI Byte
  sb t1,1(a2)            // DP = Reset Bits (16-Bit)
  TestZBIT(t0)           // Test Result Zero Flag Of DP (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

CPU65816M0HEX15:
  // $15 ORA   dp,X              OR Accumulator With Memory Direct Page Indexed, X
  LoadDPX16(t0)          // T0 = DP Indexed, X (16-Bit)
  or s0,t0               // A_REG |= DP Indexed, X
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M0HEX16:
  // $16 ASL   dp,X              Shift Memory Left Direct Page Indexed, X
  LoadDPX16(t0)          // T0 = DP Indexed, X (16-Bit)
  sll t0,1               // T0 <<= 1 (16-Bit)
  sb t0,0(a2)            // DP Indexed, X = T0 LO Byte
  srl t1,t0,8            // T1 = T0 HI Byte
  sb t1,1(a2)            // DP Indexed, X = T0 (16-Bit)
  TestNZCASLROL16(t0)    // Test Result Negative / Zero / Carry Flags Of DP Indexed, X (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,8             // Cycles += 8 (Delay Slot)

CPU65816M0HEX17:
  // $17 ORA   [dp],Y            OR Accumulator With Memory Direct Page Indirect Long Indexed, Y
  LoadDPILY16(t0)        // T0 = DP Indirect Long Indexed, Y (16-Bit)
  or s0,t0               // A_REG |= DP Indirect Long Indexed, Y
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

CPU65816M0HEX19:
  // $19 ORA   nnnn,Y            OR Accumulator With Memory Absolute Indexed, Y
  LoadABSY16(t0)         // T0 = Absolute Indexed, Y (16-Bit)
  or s0,t0               // A_REG |= Absolute Indexed, Y
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M0HEX1A:
  // $1A INA                     Increment Accumulator
  addiu s0,1             // A_REG++ (16-Bit)
  andi s0,$FFFF          // A_REG = 16-Bit
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU65816M0HEX1C:
  // $1C TRB   nnnn              Test & Reset Memory Bits Against Accumulator Absolute
  LoadABS16(t0)          // T0 = Absolute (16-Bit)
  xori t1,s0,$FFFF       // T1 = A_REG ^ $FFFF (Complement)
  and t1,t0              // T1 = Reset Bits
  sb t1,0(a2)            // Absolute = Reset Bits LO Byte
  srl t1,8               // T1 = Reset Bits HI Byte
  sb t1,1(a2)            // Absolute = Reset Bits (16-Bit)
  TestZBIT(t0)           // Test Result Zero Flag Of Absolute (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,8             // Cycles += 8 (Delay Slot)

CPU65816M0HEX1D:
  // $1D ORA   nnnn,X            OR Accumulator With Memory Absolute Indexed, X
  LoadABSX16(t0)         // T0 = Absolute Indexed, X (16-Bit)
  or s0,t0               // A_REG |= Absolute Indexed, X
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M0HEX1E:
  // $1E ASL   nnnn,X            Shift Memory Left Absolute Indexed, X
  LoadABSX16(t0)         // T0 = Absolute Indexed, X (16-Bit)
  sll t0,1               // T0 <<= 1 (16-Bit)
  sb t0,0(a2)            // Absolute Indexed, X = T0 LO Byte
  srl t1,t0,8            // T1 = T0 HI Byte
  sb t1,1(a2)            // Absolute Indexed, X = T0 (16-Bit)
  TestNZCASLROL16(t0)    // Test Result Negative / Zero / Carry Flags Of Absolute Indexed, X (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,9             // Cycles += 9 (Delay Slot)

CPU65816M0HEX1F:
  // $1F ORA   nnnnnn,X          OR Accumulator With Memory Absolute Long Indexed, X
  LoadABSLX16(t0)        // T0 = Absolute Long Indexed, X (16-Bit)
  or s0,t0               // A_REG |= Absolute Long Indexed, X
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,3             // PC_REG += 3 (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU65816M0HEX21:
  // $21 AND   (dp,X)            AND Accumulator With Memory Direct Page Indexed Indirect, X
  LoadDPIX16(t0)         // T0 = DP Indexed Indirect, X (16-Bit)
  and s0,t0              // A_REG &= DP Indexed Indirect, X
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

CPU65816M0HEX23:
  // $23 AND   sr,S              AND Accumulator With Memory Stack Relative
  LoadSR16(t0)           // T0 = SR (16-Bit)
  and s0,t0              // A_REG &= SR
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M0HEX24:
  // $24 BIT   dp                Test Memory Bits Against Accumulator Direct Page
  LoadDP16(t0)           // T0 = DP (16-Bit)
  TestNVZBIT16(t0)       // Test Result Negative / Overflow / Zero Flags Of DP (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU65816M0HEX25:
  // $25 AND   dp                AND Accumulator With Memory Direct Page
  LoadDP16(t0)           // T0 = DP (16-Bit)
  and s0,t0              // A_REG &= DP
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU65816M0HEX26:
  // $26 ROL   dp                Rotate Memory Left Direct Page
  LoadDP16(t0)           // T0 = DP (16-Bit)
  sll t0,1               // T0 = Rotate Left (16-Bit)
  andi t1,s5,C_FLAG      // T1 = C Flag
  or t0,t1               // T0 |= C Flag (16-Bit)
  sb t0,0(a2)            // DP = T0 LO Byte
  srl t1,t0,8            // T1 = T0 HI Byte
  sb t1,1(a2)            // DP = T0 (16-Bit)
  TestNZCASLROL16(t0)    // Test Result Negative / Zero / Carry Flags Of DP (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

CPU65816M0HEX27:
  // $27 AND   [dp]              AND Accumulator With Memory Direct Page Indirect Long
  LoadDPIL16(t0)         // T0 = DP Indirect Long (16-Bit)
  and s0,t0              // A_REG &= DP Indirect Long
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

CPU65816M0HEX29:
  // $29 AND   #nnnn             AND Accumulator With Memory Immediate
  LoadIMM16(t0)          // T0 = Immediate (16-Bit)
  and s0,t0              // A_REG &= Immediate
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

CPU65816M0HEX2A:
  // $2A ROL A                   Rotate Accumulator Left
  sll s0,1               // A_REG = Rotate Left (16-Bit)
  andi t0,s5,C_FLAG      // T0 = C Flag
  or s0,t0               // A_REG |= C Flag (16-Bit)
  TestNZCASLROL16(s0)    // Test Result Negative / Zero / Carry Flags Of A_REG (16-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU65816M0HEX2C:
  // $2C BIT   nnnn              Test Memory Bits Against Accumulator Absolute
  LoadABS16(t0)          // T0 = Absolute (16-Bit)
  TestNVZBIT16(t0)       // Test Result Negative / Overflow / Zero Flags Of Absolute (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M0HEX2D:
  // $2D AND   nnnn              AND Accumulator With Memory Absolute
  LoadABS16(t0)          // T0 = Absolute (16-Bit)
  and s0,t0              // A_REG &= Absolute
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M0HEX2E:
  // $2E ROL   nnnn              Rotate Memory Left Absolute
  LoadABS16(t0)          // T0 = Absolute (16-Bit)
  sll t0,1               // T0 = Rotate Left (16-Bit)
  andi t1,s5,C_FLAG      // T1 = C Flag
  or t0,t1               // T0 |= C Flag (16-Bit)
  sb t0,0(a2)            // Absolute = T0 LO Byte
  srl t1,t0,8            // T1 = T0 HI Byte
  sb t1,1(a2)            // Absolute = T0 (16-Bit)
  TestNZCASLROL16(t0)    // Test Result Negative / Zero / Carry Flags Of Absolute (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,8             // Cycles += 8 (Delay Slot)

CPU65816M0HEX2F:
  // $2F AND   nnnnnn            AND Accumulator With Memory Absolute Long
  LoadABSL16(t0)         // T0 = Absolute Long (16-Bit)
  and s0,t0              // A_REG &= Absolute Long
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,3             // PC_REG += 3 (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU65816M0HEX31:
  // $31 AND   (dp),Y            AND Accumulator With Memory Direct Page Indirect Indexed, Y
  LoadDPIY16(t0)         // T0 = DP Indirect Indexed, Y (16-Bit)
  and s0,t0              // A_REG &= DP Indirect Indexed, Y
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU65816M0HEX32:
  // $32 AND   (dp)              AND Accumulator With Memory Direct Page Indirect
  LoadDPI16(t0)          // T0 = DP Indirect (16-Bit)
  and s0,t0              // A_REG &= DP Indirect
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU65816M0HEX33:
  // $33 AND   (sr,S),Y          AND Accumulator With Memory Stack Relative Indirect Indexed, Y
  LoadSRIY16(t0)         // T0 = SR Indirect Indexed, Y (16-Bit)
  and s0,t0              // A_REG &= SR Indirect Indexed, Y
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,8             // Cycles += 8 (Delay Slot)

CPU65816M0HEX34:
  // $34 BIT   dp,X              Test Memory Bits Against Accumulator Direct Page Indexed, X
  LoadDPX16(t0)          // T0 = DP Indexed, X (16-Bit)
  TestNVZBIT16(t0)       // Test Result Negative / Overflow / Zero Flags Of DP Indexed, X (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M0HEX35:
  // $35 AND   dp,X              AND Accumulator With Memory Direct Page Indexed, X
  LoadDPX16(t0)          // T0 = DP Indexed, X (16-Bit)
  and s0,t0              // A_REG &= DP Indexed, X
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M0HEX36:
  // $36 ROL   dp,X              Rotate Memory Left Direct Page Indexed, X
  LoadDPX16(t0)          // T0 = DP Indexed, X (16-Bit)
  sll t0,1               // T0 = Rotate Left (16-Bit)
  andi t1,s5,C_FLAG      // T1 = C Flag
  or t0,t1               // T0 |= C Flag (16-Bit)
  sb t0,0(a2)            // DP Indexed, X = T0 LO Byte
  srl t1,t0,8            // T1 = T0 HI Byte
  sb t1,1(a2)            // DP Indexed, X = T0 (16-Bit)
  TestNZCASLROL16(t0)    // Test Result Negative / Zero / Carry Flags Of DP Indexed, X (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,8             // Cycles += 8 (Delay Slot)

CPU65816M0HEX37:
  // $37 AND   [dp],Y            AND Accumulator With Memory Direct Page Indirect Long Indexed, Y
  LoadDPILY16(t0)        // T0 = DP Indirect Long Indexed, Y (16-Bit)
  and s0,t0              // A_REG &= DP Indirect Long Indexed, Y
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

CPU65816M0HEX39:
  // $39 AND   nnnn,Y            AND Accumulator With Memory Absolute Indexed, Y
  LoadABSY16(t0)         // T0 = Absolute Indexed, Y (16-Bit)
  and s0,t0              // A_REG &= Absolute Indexed, Y
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M0HEX3A:
  // $3A DEA                     Decrement Accumulator
  subiu s0,1             // A_REG-- (16-Bit)
  andi s0,$FFFF          // A_REG = 16-Bit
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU65816M0HEX3C:
  // $3C BIT   nnnn,X            Test Memory Bits Against Accumulator Absolute Indexed, X
  LoadABSX16(t0)         // T0 = Absolute Indexed, X (16-Bit)
  TestNVZBIT16(t0)       // Test Result Negative / Overflow / Zero Flags Of Absolute Indexed, X (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M0HEX3D:
  // $3D AND   nnnn,X            AND Accumulator With Memory Absolute Indexed, X
  LoadABSX16(t0)         // T0 = Absolute Indexed, X (16-Bit)
  and s0,t0              // A_REG &= Absolute Indexed, X
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M0HEX3E:
  // $3E ROL   nnnn,X            Rotate Memory Left Absolute Indexed, X
  LoadABSX16(t0)         // T0 = Absolute Indexed, X (16-Bit)
  sll t0,1               // T0 = Rotate Left (16-Bit)
  andi t1,s5,C_FLAG      // T1 = C Flag
  or t0,t1               // T0 |= C Flag (16-Bit)
  sb t0,0(a2)            // Absolute Indexed, X = T0 LO Byte
  srl t1,t0,8            // T1 = T0 HI Byte
  sb t1,1(a2)            // Absolute Indexed, X = T0 (16-Bit)
  TestNZCASLROL16(t0)    // Test Result Negative / Zero / Carry Flags Of Absolute Indexed, X (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,9             // Cycles += 9 (Delay Slot)

CPU65816M0HEX3F:
  // $3F AND   nnnnnn,X          AND Accumulator With Memory Absolute Long Indexed, X
  LoadABSLX16(t0)        // T0 = Absolute Long Indexed, X (16-Bit)
  and s0,t0              // A_REG &= Absolute Long Indexed, X
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,3             // PC_REG += 3 (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU65816M0HEX41:
  // $41 EOR   (dp,X)            Exclusive-OR Accumulator With Memory Direct Page Indexed Indirect, X
  LoadDPIX16(t0)         // T0 = DP Indexed Indirect, X (16-Bit)
  xor s0,t0              // A_REG ^= DP Indexed Indirect, X
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

CPU65816M0HEX43:
  // $43 EOR   sr,S              Exclusive-OR Accumulator With Memory Stack Relative
  LoadSR16(t0)           // T0 = SR (16-Bit)
  xor s0,t0              // A_REG ^= SR
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M0HEX45:
  // $45 EOR   dp                Exclusive-OR Accumulator With Memory Direct Page
  LoadDP16(t0)           // T0 = DP (16-Bit)
  xor s0,t0              // A_REG ^= DP
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU65816M0HEX46:
  // $46 LSR   dp                Logical Shift Memory Right Direct Page
  LoadDP16(t0)           // T0 = DP (16-Bit)
  andi t1,t0,1           // Test Negative MSB / Carry
  srl t0,1               // DP >>= 1 (16-Bit)
  sb t0,0(a2)            // DP = T0 LO Byte
  srl t2,t0,8            // T2 = T0 HI Byte
  sb t2,1(a2)            // DP = T0 (16-Bit)
  TestNZCLSRROR(t0)      // Test Result Negative / Zero / Carry Flags Of DP (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

CPU65816M0HEX47:
  // $47 EOR   [dp]              Exclusive-OR Accumulator With Memory Direct Page Indirect Long
  LoadDPIL16(t0)         // T0 = DP Indirect Long (16-Bit)
  xor s0,t0              // A_REG ^= DP Indirect Long
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

CPU65816M0HEX48:
  // $48 PHA                     Push Accumulator
  PushNAT16(s0)          // STACK = A_REG (16-Bit)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU65816M0HEX49:
  // $49 EOR   #nnnn             Exclusive-OR Accumulator With Memory Immediate
  LoadIMM16(t0)          // T0 = Immediate (16-Bit)
  xor s0,t0              // A_REG ^= Immediate
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

CPU65816M0HEX4A:
  // $4A LSR A                   Logical Shift Accumulator Right
  andi t1,s0,1           // Test Negative MSB / Carry
  srl s0,1               // A_REG >>= 1 (16-Bit)
  TestNZCLSRROR(s0)      // Test Result Negative / Zero / Carry Flags Of A_REG (16-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU65816M0HEX4D:
  // $4D EOR   nnnn              Exclusive-OR Accumulator With Memory Absolute
  LoadABS16(t0)          // T0 = Absolute (16-Bit)
  xor s0,t0              // A_REG ^= Absolute
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M0HEX4E:
  // $4E LSR   nnnn              Logical Shift Memory Right Absolute
  LoadABS16(t0)          // T0 = Absolute (16-Bit)
  andi t1,t0,1           // Test Negative MSB / Carry
  srl t0,1               // Absolute >>= 1 (16-Bit)
  sb t0,0(a2)            // Absolute = T0 LO Byte
  srl t2,t0,8            // T2 = T0 HI Byte
  sb t2,1(a2)            // Absolute = T0 (16-Bit)
  TestNZCLSRROR(t0)      // Test Result Negative / Zero / Carry Flags Of Absolute (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,8             // Cycles += 8 (Delay Slot)

CPU65816M0HEX4F:
  // $4F EOR   nnnnnn            Exclusive-OR Accumulator With Memory Absolute Long
  LoadABSL16(t0)         // T0 = Absolute Long (16-Bit)
  xor s0,t0              // A_REG ^= Absolute Long
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,3             // PC_REG += 3 (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU65816M0HEX51:
  // $51 EOR   (dp),Y            Exclusive-OR Accumulator With Memory Direct Page Indirect Indexed, Y
  LoadDPIY16(t0)         // T0 = DP Indirect Indexed, Y (16-Bit)
  xor s0,t0              // A_REG ^= DP Indirect Indexed, Y
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU65816M0HEX52:
  // $52 EOR   (dp)              Exclusive-OR Accumulator With Memory Direct Page Indirect
  LoadDPI16(t0)          // T0 = DP Indirect (16-Bit)
  xor s0,t0              // A_REG ^= DP Indirect
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU65816M0HEX53:
  // $53 EOR   (sr,S),Y          Exclusive-OR Accumulator With Memory Stack Relative Indirect Indexed, Y
  LoadSRIY16(t0)         // T0 = SR Indirect Indexed, Y (16-Bit)
  xor s0,t0              // A_REG ^= SR Indirect Indexed, Y
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,8             // Cycles += 8 (Delay Slot)

CPU65816M0HEX55:
  // $55 EOR   dp,X              Exclusive-OR Accumulator With Memory Direct Page Indexed, X
  LoadDPX16(t0)          // T0 = DP Indexed, X (16-Bit)
  xor s0,t0              // A_REG ^= DP Indexed, X
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M0HEX56:
  // $56 LSR   dp,X              Logical Shift Memory Right Direct Page Indexed, X
  LoadDPX16(t0)          // T0 = DP Indexed, X (16-Bit)
  andi t1,t0,1           // Test Negative MSB / Carry
  srl t0,1               // DP Indexed, X >>= 1 (16-Bit)
  sb t0,0(a2)            // DP Indexed, X = T0 LO Byte
  srl t2,t0,8            // T2 = T0 HI Byte
  sb t2,1(a2)            // DP Indexed, X = T0 (16-Bit)
  TestNZCLSRROR(t0)      // Test Result Negative / Zero / Carry Flags Of DP Indexed, X (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,8             // Cycles += 8 (Delay Slot)

CPU65816M0HEX57:
  // $57 EOR   [dp],Y            Exclusive-OR Accumulator With Memory Direct Page Indirect Long Indexed, Y
  LoadDPILY16(t0)        // T0 = DP Indirect Long Indexed, Y (16-Bit)
  xor s0,t0              // A_REG ^= DP Indirect Long Indexed, Y
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

CPU65816M0HEX59:
  // $59 EOR   nnnn,Y            Exclusive-OR Accumulator With Memory Absolute Indexed, Y
  LoadABSY16(t0)         // T0 = Absolute Indexed, Y (16-Bit)
  xor s0,t0              // A_REG ^= Absolute Indexed, Y
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M0HEX5D:
  // $5D EOR   nnnn,X            Exclusive-OR Accumulator With Memory Absolute Indexed, X
  LoadABSX16(t0)         // T0 = Absolute Indexed, X (16-Bit)
  xor s0,t0              // A_REG ^= Absolute Indexed, X
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M0HEX5E:
  // $5E LSR   nnnn,X            Logical Shift Memory Right Absolute Indexed, X
  LoadABSX16(t0)         // T0 = Absolute Indexed, X (16-Bit)
  andi t1,t0,1           // Test Negative MSB / Carry
  srl t0,1               // Absolute Indexed, X >>= 1 (16-Bit)
  sb t0,0(a2)            // Absolute Indexed, X = T0 LO Byte
  srl t2,t0,8            // T2 = T0 HI Byte
  sb t2,1(a2)            // Absolute Indexed, X = T0 (16-Bit)
  TestNZCLSRROR(t0)      // Test Result Negative / Zero / Carry Flags Of Absolute Indexed, X (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,9             // Cycles += 9 (Delay Slot)

CPU65816M0HEX5F:
  // $5F EOR   nnnnnn,X          Exclusive-OR Accumulator With Memory Absolute Long Indexed, X
  LoadABSLX16(t0)        // T0 = Absolute Long Indexed, X (16-Bit)
  xor s0,t0              // A_REG ^= Absolute Long Indexed, X
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,3             // PC_REG += 3 (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU65816M0HEX61:
  // $61 ADC   (dp,X)            Add With Carry Accumulator With Memory Direct Page Indexed Indirect, X
  LoadDPIX16(t0)         // T0 = DP Indexed Indirect, X (16-Bit)
  TestNVZCADC16(s0)      // Test Result Negative / Overflow / Zero / Carry Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

CPU65816M0HEX63:
  // $63 ADC   sr,S              Add With Carry Accumulator With Memory Stack Relative
  LoadSR16(t0)           // T0 = SR (16-Bit)
  TestNVZCADC16(s0)      // Test Result Negative / Overflow / Zero / Carry Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M0HEX64:
  // $64 STZ   dp                Store Zero To Memory Direct Page
  StoreDP16(r0)          // DP = 0 (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU65816M0HEX65:
  // $65 ADC   dp                Add With Carry Accumulator With Memory Direct Page
  LoadDP16(t0)           // T0 = DP (16-Bit)
  TestNVZCADC16(s0)      // Test Result Negative / Overflow / Zero / Carry Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU65816M0HEX66:
  // $66 ROR   dp                Rotate Memory Right Direct Page
  LoadDP16(t0)           // T0 = DP (16-Bit)
  andi t1,s0,1           // Test Negative MSB / Carry
  andi t2,s5,C_FLAG      // T2 = C Flag
  sll t2,7               // T2 <<= 7
  or t1,t2               // T1 = N/C Flags
  srl t0,1               // T0 >>= 1 (8-Bit)
  sll t2,8               // T2 <<= 8
  or t0,t2               // T0 |= C Flag (16-Bit)
  sb t0,0(a2)            // DP = T0 LO Byte
  srl t2,t0,8            // T2 = T0 HI Byte
  sb t2,1(a2)            // DP = Rotate Right (16-Bit)
  TestNZCLSRROR(t0)      // Test Result Negative / Zero / Carry Flags Of DP (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

CPU65816M0HEX67:
  // $67 ADC   [dp]              Add With Carry Accumulator With Memory Direct Page Indirect Long
  LoadDPIL16(t0)         // T0 = DP Indirect Long (16-Bit)
  TestNVZCADC16(s0)      // Test Result Negative / Overflow / Zero / Carry Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

CPU65816M0HEX68:
  // $68 PLA                     Pull Accumulator
  PullNAT16(s0)          // A_REG = STACK (16-Bit)
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M0HEX69:
  // $69 ADC   #nnnn             Add With Carry Accumulator With Memory Immediate
  LoadIMM16(t0)          // T0 = Immediate (16-Bit)
  TestNVZCADC16(s0)      // Test Result Negative / Overflow / Zero / Carry Flags Of A_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

CPU65816M0HEX6A:
  // $6A ROR A                   Rotate Accumulator Right
  andi t1,s0,1           // Test Negative MSB / Carry
  andi t2,s5,C_FLAG      // T2 = C Flag
  sll t2,7               // T2 <<= 7
  or t1,t2               // T1 = N/C Flags
  srl s0,1               // A_REG >>= 1 (8-Bit)
  sll t2,8               // T2 <<= 8
  or s0,t2               // A_REG = Rotate Right (16-Bit)
  TestNZCLSRROR(s0)      // Test Result Negative / Zero / Carry Flags Of A_REG (16-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU65816M0HEX6D:
  // $6D ADC   nnnn              Add With Carry Accumulator With Memory Absolute
  LoadABS16(t0)          // T0 = Absolute (16-Bit)
  TestNVZCADC16(s0)      // Test Result Negative / Overflow / Zero / Carry Flags Of A_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M0HEX6E:
  // $6E ROR   nnnn              Rotate Memory Right Absolute
  LoadABS16(t0)          // T0 = Absolute (16-Bit)
  andi t1,s0,1           // Test Negative MSB / Carry
  andi t2,s5,C_FLAG      // T2 = C Flag
  sll t2,7               // T2 <<= 7
  or t1,t2               // T1 = N/C Flags
  srl t0,1               // T0 >>= 1 (8-Bit)
  sll t2,8               // T2 <<= 8
  or t0,t2               // T0 |= C Flag (16-Bit)
  sb t0,0(a2)            // Absolute = T0 LO Byte
  srl t2,t0,8            // T2 = T0 HI Byte
  sb t2,1(a2)            // Absolute = Rotate Right (16-Bit)
  TestNZCLSRROR(t0)      // Test Result Negative / Zero / Carry Flags Of Absolute (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,8             // Cycles += 8 (Delay Slot)

CPU65816M0HEX6F:
  // $6F ADC   nnnnnn            Add With Carry Accumulator With Memory Absolute Long
  LoadABSL16(t0)         // T0 = Absolute Long (16-Bit)
  TestNVZCADC16(s0)      // Test Result Negative / Overflow / Zero / Carry Flags Of A_REG (16-Bit)
  addiu s3,3             // PC_REG += 3 (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU65816M0HEX71:
  // $71 ADC   (dp),Y            Add With Carry Accumulator With Memory Direct Page Indirect Indexed, Y
  LoadDPIY16(t0)         // T0 = DP Indirect Indexed, Y (16-Bit)
  TestNVZCADC16(s0)      // Test Result Negative / Overflow / Zero / Carry Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU65816M0HEX72:
  // $72 ADC   (dp)              Add With Carry Accumulator With Memory Direct Page Indirect
  LoadDPI16(t0)          // T0 = DP Indirect (16-Bit)
  TestNVZCADC16(s0)      // Test Result Negative / Overflow / Zero / Carry Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU65816M0HEX73:
  // $73 ADC   (sr,S),Y          Add With Carry Accumulator With Memory Stack Relative Indirect Indexed, Y
  LoadSRIY16(t0)         // T0 = SR Indirect Indexed, Y (16-Bit)
  TestNVZCADC16(s0)      // Test Result Negative / Overflow / Zero / Carry Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,8             // Cycles += 8 (Delay Slot)

CPU65816M0HEX74:
  // $74 STZ   dp,X              Store Zero To Memory Direct Page Indexed, X
  StoreDPX16(r0)         // DP Indexed, X = 0 (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M0HEX75:
  // $75 ADC   dp,X              Add With Carry Accumulator With Memory Direct Page Indexed, X
  LoadDPX16(t0)          // T0 = DP Indexed, X (16-Bit)
  TestNVZCADC16(s0)      // Test Result Negative / Overflow / Zero / Carry Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M0HEX76:
  // $76 ROR   dp,X              Rotate Memory Right Direct Page Indexed, X
  LoadDPX16(t0)          // T0 = DP Indexed, X (16-Bit)
  andi t1,s0,1           // Test Negative MSB / Carry
  andi t2,s5,C_FLAG      // T2 = C Flag
  sll t2,7               // T2 <<= 7
  or t1,t2               // T1 = N/C Flags
  srl t0,1               // T0 >>= 1 (8-Bit)
  sll t2,8               // T2 <<= 8
  or t0,t2               // T0 |= C Flag (16-Bit)
  sb t0,0(a2)            // DP Indexed, X = T0 LO Byte
  srl t2,t0,8            // T2 = T0 HI Byte
  sb t2,1(a2)            // DP Indexed, X = Rotate Right (16-Bit)
  TestNZCLSRROR(t0)      // Test Result Negative / Zero / Carry Flags Of DP Indexed, X (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,8             // Cycles += 8 (Delay Slot)

CPU65816M0HEX77:
  // $77 ADC   [dp],Y            Add With Carry Accumulator With Memory Direct Page Indirect Long Indexed, Y
  LoadDPILY16(t0)        // T0 = DP Indirect Long Indexed, Y (16-Bit)
  TestNVZCADC16(s0)      // Test Result Negative / Overflow / Zero / Carry Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

CPU65816M0HEX79:
  // $79 ADC   nnnn,Y            Add With Carry Accumulator With Memory Absolute Indexed, Y
  LoadABSY16(t0)         // T0 = Absolute Indexed, Y (16-Bit)
  TestNVZCADC16(s0)      // Test Result Negative / Overflow / Zero / Carry Flags Of A_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M0HEX7D:
  // $7D ADC   nnnn,X            Add With Carry Accumulator With Memory Absolute Indexed, X
  LoadABSX16(t0)         // T0 = Absolute Indexed, X (16-Bit)
  TestNVZCADC16(s0)      // Test Result Negative / Overflow / Zero / Carry Flags Of A_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M0HEX7E:
  // $7E ROR   nnnn,X            Rotate Memory Right Absolute Indexed, X
  LoadABSX16(t0)         // T0 = Absolute Indexed, X (16-Bit)
  andi t1,s0,1           // Test Negative MSB / Carry
  andi t2,s5,C_FLAG      // T2 = C Flag
  sll t2,7               // T2 <<= 7
  or t1,t2               // T1 = N/C Flags
  srl t0,1               // T0 >>= 1 (8-Bit)
  sll t2,8               // T2 <<= 8
  or t0,t2               // T0 |= C Flag (16-Bit)
  sb t0,0(a2)            // Absolute Indexed, X = T0 LO Byte
  srl t2,t0,8            // T2 = T0 HI Byte
  sb t2,1(a2)            // Absolute Indexed, X = Rotate Right (16-Bit)
  TestNZCLSRROR(t0)      // Test Result Negative / Zero / Carry Flags Of Absolute Indexed, X (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,9             // Cycles += 9 (Delay Slot)

CPU65816M0HEX7F:
  // $7F ADC   nnnnnn,X          Add With Carry Accumulator With Memory Absolute Long Indexed, X
  LoadABSLX16(t0)        // T0 = Absolute Long Indexed, X (16-Bit)
  TestNVZCADC16(s0)      // Test Result Negative / Overflow / Zero / Carry Flags Of A_REG (16-Bit)
  addiu s3,3             // PC_REG += 3 (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU65816M0HEX81:
  // $81 STA   (dp,X)            Store Accumulator To Memory Direct Page Indexed Indirect, X
  StoreDPIX16(s0)        // DP Indexed Indirect, X = A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

CPU65816M0HEX83:
  // $83 STA   sr,S              Store Accumulator To Memory Stack Relative
  StoreSR16(s0)          // SR = A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M0HEX85:
  // $85 STA   dp                Store Accumulator To Memory Direct Page
  StoreDP16(s0)          // DP = A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU65816M0HEX87:
  // $87 STA   [dp]              Store Accumulator To Memory Direct Page Indirect Long
  StoreDPIL16(s0)        // DP Indirect Long = A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

CPU65816M0HEX89:
  // $89 BIT   #nnnn             Test Memory Bits Against Accumulator Immediate
  LoadIMM16(t0)          // T0 = Immediate (16-Bit)
  TestZBIT(t0)           // Test Result Zero Flag Of Immediate (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

CPU65816M0HEX8D:
  // $8D STA   nnnn              Store Accumulator To Memory Absolute
  StoreABS16(s0)         // Absolute = A_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M0HEX8F:
  // $8F STA   nnnnnn            Store Accumulator To Memory Absolute Long
  StoreABSL16(s0)        // Absolute Long = A_REG (16-Bit)
  addiu s3,3             // PC_REG += 3 (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU65816M0HEX91:
  // $91 STA   (dp),Y            Store Accumulator To Memory Direct Page Indirect Indexed, Y
  StoreDPIY16(s0)        // DP Indirect Indexed, Y = A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

CPU65816M0HEX92:
  // $92 STA   (dp)              Store Accumulator To Memory Direct Page Indirect
  StoreDPI16(s0)         // DP Indirect = A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU65816M0HEX93:
  // $93 STA   (sr,S),Y          Store Accumulator To Memory Stack Relative Indirect Indexed, Y
  StoreSRIY16(s0)        // SR Indirect Indexed, Y = A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,8             // Cycles += 8 (Delay Slot)

CPU65816M0HEX95:
  // $95 STA   dp,X              Store Accumulator To Memory Direct Page Indexed, X
  StoreDPX16(s0)         // DP Indexed, X = A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M0HEX97:
  // $97 STA   [dp],Y            Store Accumulator To Memory Direct Page Indirect Long Indexed, Y
  StoreDPILY16(s0)       // DP Indirect Long Indexed, Y = A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

CPU65816M0HEX99:
  // $99 STA   nnnn,Y            Store Accumulator To Memory Absolute Indexed, Y
  StoreABSY16(s0)        // Absolute Indexed, Y = A_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU65816M0HEX9C:
  // $9C STZ   nnnn              Store Zero To Memory Absolute
  StoreABS16(r0)         // Absolute = 0 (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M0HEX9D:
  // $9D STA   nnnn,X            Store Accumulator To Memory Absolute Indexed, X
  StoreABSX16(s0)        // Absolute Indexed, X = A_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU65816M0HEX9E:
  // $9E STZ   nnnn,X            Store Zero To Memory Absolute Indexed, X
  StoreABSX16(r0)        // Absolute Indexed, X = 0 (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU65816M0HEX9F:
  // $9F STA   nnnnnn,X          Store Accumulator To Memory Absolute Long Indexed, X
  StoreABSLX16(s0)       // Absolute Long Indexed, X = A_REG (16-Bit)
  addiu s3,3             // PC_REG += 3 (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU65816M0HEXA1:
  // $A1 LDA   (dp,X)            Load Accumulator From Memory Direct Page Indexed Indirect, X
  LoadDPIX16(s0)         // A_REG = DP Indexed Indirect, X (16-Bit)
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

CPU65816M0HEXA3:
  // $A3 LDA   sr,S              Load Accumulator From Memory Stack Relative
  LoadSR16(s0)           // A_REG = SR (16-Bit)
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M0HEXA5:
  // $A5 LDA   dp                Load Accumulator From Memory Direct Page
  LoadDP16(s0)           // A_REG = DP (16-Bit)
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU65816M0HEXA7:
  // $A7 LDA   [dp]              Load Accumulator From Memory Direct Page Indirect Long
  LoadDPIL16(s0)         // A_REG = DP Indirect Long (16-Bit)
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

CPU65816M0HEXA9:
  // $A9 LDA   #nnnn             Load Accumulator From Memory Immediate
  LoadIMM16(s0)          // A_REG = Immediate (16-Bit)
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

CPU65816M0HEXAD:
  // $AD LDA   nnnn              Load Accumulator From Memory Absolute
  LoadABS16(s0)          // A_REG = Absolute (16-Bit)
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M0HEXAF:
  // $AF LDA   nnnnnn            Load Accumulator From Memory Absolute Long
  LoadABSL16(s0)         // A_REG = Absolute Long (16-Bit)
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,3             // PC_REG += 3 (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU65816M0HEXB1:
  // $B1 LDA   (dp),Y            Load Accumulator From Memory Direct Page Indirect Indexed, Y
  LoadDPIY16(s0)         // A_REG = DP Indirect Indexed, Y (16-Bit)
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU65816M0HEXB2:
  // $B2 LDA   (dp)              Load Accumulator From Memory Direct Page Indirect
  LoadDPI16(s0)          // A_REG = DP Indirect (16-Bit)
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU65816M0HEXB3:
  // $B3 LDA   (sr,S),Y          Load Accumulator From Memory Stack Relative Indirect Indexed, Y
  LoadSRIY16(s0)         // A_REG = SR Indirect Indexed, Y (16-Bit)
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,8             // Cycles += 8 (Delay Slot)

CPU65816M0HEXB5:
  // $B5 LDA   dp,X              Load Accumulator From Memory Direct Page Indexed, X
  LoadDPX16(s0)          // A_REG = DP Indexed, X (16-Bit)
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M0HEXB7:
  // $B7 LDA   [dp],Y            Load Accumulator From Memory Direct Page Indirect Long Indexed, Y
  LoadDPILY16(s0)        // A_REG = DP Indirect Long Indexed, Y (16-Bit)
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

CPU65816M0HEXB9:
  // $B9 LDA   nnnn,Y            Load Accumulator From Memory Absolute Indexed, Y
  LoadABSY16(s0)         // A_REG = Absolute Indexed, Y (16-Bit)
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M0HEXBD:
  // $BD LDA   nnnn,X            Load Accumulator From Memory Absolute Indexed, X
  LoadABSX16(s0)         // A_REG = Absolute Indexed, X (16-Bit)
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M0HEXBF:
  // $BF LDA   nnnnnn,X          Load Accumulator From Memory Absolute Long Indexed, X
  LoadABSLX16(s0)        // A_REG = Absolute Long Indexed, X (16-Bit)
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,3             // PC_REG += 3 (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU65816M0HEXC1:
  // $C1 CMP   (dp,X)            Compare Accumulator With Memory Direct Page Indexed Indirect, X
  LoadDPIX16(t0)         // T0 = DP Indexed Indirect, X (16-Bit)
  TestNZCCMP16(s0)       // Test Result Negative / Zero / Carry Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

CPU65816M0HEXC3:
  // $C3 CMP   sr,S              Compare Accumulator With Memory Stack Relative
  LoadSR16(t0)           // T0 = SR (16-Bit)
  TestNZCCMP16(s0)       // Test Result Negative / Zero / Carry Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M0HEXC5:
  // $C5 CMP   dp                Compare Accumulator With Memory Direct Page
  LoadDP16(t0)           // T0 = DP (16-Bit)
  TestNZCCMP16(s0)       // Test Result Negative / Zero / Carry Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU65816M0HEXC6:
  // $C6 DEC   dp                Decrement Memory Direct Page
  LoadDP16(t0)           // T0 = DP (16-Bit)
  subiu t0,1             // T0--
  sb t0,0(a2)            // DP = T0 LO Byte
  srl t1,t0,8            // T1 = T0 HI Byte
  sb t1,1(a2)            // DP = T0 (16-Bit)
  TestNZ16(t0)           // Test Result Negative / Zero Flags Of DP (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

CPU65816M0HEXC7:
  // $C7 CMP   [dp]              Compare Accumulator With Memory Direct Page Indirect Long
  LoadDPIL16(t0)         // T0 = DP Indirect Long (16-Bit)
  TestNZCCMP16(s0)       // Test Result Negative / Zero / Carry Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

CPU65816M0HEXC9:
  // $C9 CMP   #nnnn             Compare Accumulator With Memory Immediate
  LoadIMM16(t0)          // T0 = Immediate (16-Bit)
  TestNZCCMP16(s0)       // Test Result Negative / Zero / Carry Flags Of A_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

CPU65816M0HEXCD:
  // $CD CMP   nnnn              Compare Accumulator With Memory Absolute
  LoadABS16(t0)          // T0 = Absolute (16-Bit)
  TestNZCCMP16(s0)       // Test Result Negative / Zero / Carry Flags Of A_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M0HEXCE:
  // $CE DEC   nnnn              Decrement Memory Absolute
  LoadABS16(t0)          // T0 = Absolute (16-Bit)
  subiu t0,1             // T0--
  sb t0,0(a2)            // Absolute = T0 LO Byte
  srl t1,t0,8            // T1 = T0 HI Byte
  sb t1,1(a2)            // Absolute = T0 (16-Bit)
  TestNZ16(t0)           // Test Result Negative / Zero Flags Of Absolute (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,8             // Cycles += 8 (Delay Slot)

CPU65816M0HEXCF:
  // $CF CMP   nnnnnn            Compare Accumulator With Memory Absolute Long
  LoadABSL16(t0)         // T0 = Absolute Long (16-Bit)
  TestNZCCMP16(s0)       // Test Result Negative / Zero / Carry Flags Of A_REG (16-Bit)
  addiu s3,3             // PC_REG += 3 (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU65816M0HEXD1:
  // $D1 CMP   (dp),Y            Compare Accumulator With Memory Direct Page Indirect Indexed, Y
  LoadDPIY16(t0)         // T0 = DP Indirect Indexed, Y (16-Bit)
  TestNZCCMP16(s0)       // Test Result Negative / Zero / Carry Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU65816M0HEXD2:
  // $D2 CMP   (dp)              Compare Accumulator With Memory Direct Page Indirect
  LoadDPI16(t0)          // T0 = DP Indirect (16-Bit)
  TestNZCCMP16(s0)       // Test Result Negative / Zero / Carry Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU65816M0HEXD3:
  // $D3 CMP   (sr,S),Y          Compare Accumulator With Memory Stack Relative Indirect Indexed, Y
  LoadSRIY16(t0)         // T0 = SR Indirect Indexed, Y (16-Bit)
  TestNZCCMP16(s0)       // Test Result Negative / Zero / Carry Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,8             // Cycles += 8 (Delay Slot)

CPU65816M0HEXD5:
  // $D5 CMP   dp,X              Compare Accumulator With Memory Direct Page Indexed, X
  LoadDPX16(t0)          // T0 = DP Indexed, X (16-Bit)
  TestNZCCMP16(s0)       // Test Result Negative / Zero / Carry Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M0HEXD6:
  // $D6 DEC   dp,X              Decrement Memory Direct Page Indexed, X
  LoadDPX16(t0)          // T0 = DP Indexed, X (16-Bit)
  subiu t0,1             // T0--
  sb t0,0(a2)            // DP Indexed, X = T0 LO Byte
  srl t1,t0,8            // T1 = T0 HI Byte
  sb t1,1(a2)            // DP Indexed, X = T0 (16-Bit)
  TestNZ16(t0)           // Test Result Negative / Zero Flags Of DP Indexed, X (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,8             // Cycles += 8 (Delay Slot)

CPU65816M0HEXD7:
  // $D7 CMP   [dp],Y            Compare Accumulator With Memory Direct Page Indirect Long Indexed, Y
  LoadDPILY16(t0)        // T0 = DP Indirect Long Indexed, Y (16-Bit)
  TestNZCCMP16(s0)       // Test Result Negative / Zero / Carry Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

CPU65816M0HEXD9:
  // $D9 CMP   nnnn,Y            Compare Accumulator With Memory Absolute Indexed, Y
  LoadABSY16(t0)         // T0 = Absolute Indexed, Y (16-Bit)
  TestNZCCMP16(s0)       // Test Result Negative / Zero / Carry Flags Of A_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M0HEXDD:
  // $DD CMP   nnnn,X            Compare Accumulator With Memory Absolute Indexed, X
  LoadABSX16(t0)         // T0 = Absolute Indexed, X (16-Bit)
  TestNZCCMP16(s0)       // Test Result Negative / Zero / Carry Flags Of A_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M0HEXDE:
  // $DE DEC   nnnn,X            Decrement Memory Absolute Indexed, X
  LoadABSX16(t0)         // T0 = Absolute Indexed, X (16-Bit)
  subiu t0,1             // T0--
  sb t0,0(a2)            // Absolute Indexed, X = T0 LO Byte
  srl t1,t0,8            // T1 = T0 HI Byte
  sb t1,1(a2)            // Absolute Indexed, X = T0 (16-Bit)
  TestNZ16(t0)           // Test Result Negative / Zero Flags Of Absolute Indexed, X (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,9             // Cycles += 9 (Delay Slot)

CPU65816M0HEXDF:
  // $DF CMP   nnnnnn,X          Compare Accumulator With Memory Absolute Long Indexed, X
  LoadABSLX16(t0)        // T0 = Absolute Long Indexed, X (16-Bit)
  TestNZCCMP16(s0)       // Test Result Negative / Zero / Carry Flags Of A_REG (16-Bit)
  addiu s3,3             // PC_REG += 3 (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU65816M0HEXE1:
  // $E1 SBC   (dp,X)            Subtract With Borrow From Accumulator With Memory Direct Page Indexed Indirect, X
  LoadDPIX16(t0)         // T0 = DP Indexed Indirect, X (16-Bit)
  TestNVZCSBC16(s0)      // Test Result Negative / Overflow / Zero / Carry Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

CPU65816M0HEXE3:
  // $E3 SBC   sr,S              Subtract With Borrow From Accumulator With Memory Stack Relative
  LoadSR16(t0)           // T0 = SR (16-Bit)
  TestNVZCSBC16(s0)      // Test Result Negative / Overflow / Zero / Carry Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M0HEXE5:
  // $E5 SBC   dp                Subtract With Borrow From Accumulator With Memory Direct Page
  LoadDP16(t0)           // T0 = DP (16-Bit)
  TestNVZCSBC16(s0)      // Test Result Negative / Overflow / Zero / Carry Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU65816M0HEXE6:
  // $E6 INC   dp                Increment Memory Direct Page
  LoadDP16(t0)           // T0 = DP (16-Bit)
  addiu t0,1             // T0++
  sb t0,0(a2)            // DP = T0 LO Byte
  srl t1,t0,8            // T1 = T0 HI Byte
  sb t1,1(a2)            // DP = T0 (16-Bit)
  andi t0,$FFFF          // T0 = 16-Bit
  TestNZ16(t0)           // Test Result Negative / Zero Flags Of DP (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

CPU65816M0HEXE7:
  // $E7 SBC   [dp]              Subtract With Borrow From Accumulator With Memory Direct Page Indirect Long
  LoadDPIL16(t0)         // T0 = DP Indirect Long (16-Bit)
  TestNVZCSBC16(s0)      // Test Result Negative / Overflow / Zero / Carry Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

CPU65816M0HEXE9:
  // $E9 SBC   #nnnn             Subtract With Borrow From Accumulator With Memory Immediate
  LoadIMM16(t0)          // T0 = Immediate (16-Bit)
  TestNVZCSBC16(s0)      // Test Result Negative / Overflow / Zero / Carry Flags Of A_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

CPU65816M0HEXED:
  // $ED SBC   nnnn              Subtract With Borrow From Accumulator With Memory Absolute
  LoadABS16(t0)          // T0 = Absolute (16-Bit)
  TestNVZCSBC16(s0)      // Test Result Negative / Overflow / Zero / Carry Flags Of A_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M0HEXEE:
  // $EE INC   nnnn              Increment Memory Absolute
  LoadABS16(t0)          // T0 = Absolute (16-Bit)
  addiu t0,1             // T0++
  sb t0,0(a2)            // Absolute = T0 LO Byte
  srl t1,t0,8            // T1 = T0 HI Byte
  sb t1,1(a2)            // Absolute = T0 (16-Bit)
  andi t0,$FFFF          // T0 = 16-Bit
  TestNZ16(t0)           // Test Result Negative / Zero Flags Of Absolute (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,8             // Cycles += 8 (Delay Slot)

CPU65816M0HEXEF:
  // $EF SBC   nnnnnn            Subtract With Borrow From Accumulator With Memory Absolute Long
  LoadABSL16(t0)         // T0 = Absolute Long (16-Bit)
  TestNVZCSBC16(s0)      // Test Result Negative / Overflow / Zero / Carry Flags Of A_REG (16-Bit)
  addiu s3,3             // PC_REG += 3 (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU65816M0HEXF1:
  // $F1 SBC   (dp),Y            Subtract With Borrow From Accumulator With Memory Direct Page Indirect Indexed, Y
  LoadDPIY16(t0)         // T0 = DP Indirect Indexed, Y (16-Bit)
  TestNVZCSBC16(s0)      // Test Result Negative / Overflow / Zero / Carry Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU65816M0HEXF2:
  // $F2 SBC   (dp)              Subtract With Borrow From Accumulator With Memory Direct Page Indirect
  LoadDPI16(t0)          // T0 = DP Indirect (16-Bit)
  TestNVZCSBC16(s0)      // Test Result Negative / Overflow / Zero / Carry Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU65816M0HEXF3:
  // $F3 SBC   (sr,S),Y          Subtract With Borrow From Accumulator With Memory Stack Relative Indirect Indexed, Y
  LoadSRIY16(t0)         // T0 = SR Indirect Indexed, Y (16-Bit)
  TestNVZCSBC16(s0)      // Test Result Negative / Overflow / Zero / Carry Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,8             // Cycles += 8 (Delay Slot)

CPU65816M0HEXF5:
  // $F5 SBC   dp,X              Subtract With Borrow From Accumulator With Memory Direct Page Indexed, X
  LoadDPX16(t0)          // T0 = DP Indexed, X (16-Bit)
  TestNVZCSBC16(s0)      // Test Result Negative / Overflow / Zero / Carry Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M0HEXF6:
  // $F6 INC   dp,X              Increment Memory Direct Page Indexed, X
  LoadDPX16(t0)          // T0 = DP Indexed, X (16-Bit)
  addiu t0,1             // T0++
  sb t0,0(a2)            // DP Indexed, X = T0 LO Byte
  srl t1,t0,8            // T1 = T0 HI Byte
  sb t1,1(a2)            // DP Indexed, X = T0 (16-Bit)
  andi t0,$FFFF          // T0 = 16-Bit
  TestNZ16(t0)           // Test Result Negative / Zero Flags Of DP Indexed, X (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,8             // Cycles += 8 (Delay Slot)

CPU65816M0HEXF7:
  // $F7 SBC   [dp],Y            Subtract With Borrow From Accumulator With Memory Direct Page Indirect Long Indexed, Y
  LoadDPILY16(t0)        // T0 = DP Indirect Long Indexed, Y (16-Bit)
  TestNVZCSBC16(s0)      // Test Result Negative / Overflow / Zero / Carry Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

CPU65816M0HEXF9:
  // $F9 SBC   nnnn,Y            Subtract With Borrow From Accumulator With Memory Absolute Indexed, Y
  LoadABSY16(t0)         // T0 = Absolute Indexed, Y (16-Bit)
  TestNVZCSBC16(s0)      // Test Result Negative / Overflow / Zero / Carry Flags Of A_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M0HEXFD:
  // $FD SBC   nnnn,X            Subtract With Borrow From Accumulator With Memory Absolute Indexed, X
  LoadABSX16(t0)         // T0 = Absolute Indexed, X (16-Bit)
  TestNVZCSBC16(s0)      // Test Result Negative / Overflow / Zero / Carry Flags Of A_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M0HEXFE:
  // $FE INC   nnnn,X            Increment Memory Absolute Indexed, X
  LoadABSX16(t0)         // T0 = Absolute Indexed, X (16-Bit)
  addiu t0,1             // T0++
  sb t0,0(a2)            // Absolute Indexed, X = T0 LO Byte
  srl t1,t0,8            // T1 = T0 HI Byte
  sb t1,1(a2)            // Absolute Indexed, X = T0 (16-Bit)
  andi t0,$FFFF          // T0 = 16-Bit
  TestNZ16(t0)           // Test Result Negative / Zero Flags Of Absolute Indexed, X (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,9             // Cycles += 9 (Delay Slot)

CPU65816M0HEXFF:
  // $FF SBC   nnnnnn,X          Subtract With Borrow From Accumulator With Memory Absolute Long Indexed, X
  LoadABSLX16(t0)        // T0 = Absolute Long Indexed, X (16-Bit)
  TestNVZCSBC16(s0)      // Test Result Negative / Overflow / Zero / Carry Flags Of A_REG (16-Bit)
  addiu s3,3             // PC_REG += 3 (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)