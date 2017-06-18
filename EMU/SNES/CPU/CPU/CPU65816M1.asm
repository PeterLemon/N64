CPU65816M1HEX03:
  // $03 ORA   sr,S              OR Accumulator With Memory Stack Relative
  LoadSR8(t0)            // T0 = SR (8-Bit)
  andi t1,s0,$FF         // T1 = A_REG (8-Bit)
  or t1,t0               // T1 |= SR
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t1               // A_REG |= T1
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU65816M1HEX04:
  // $04 TSB   dp                Test & Set Bits In Direct Page Offset With A
  LoadDP8(t0)            // T0 = DP (8-Bit)
  andi t1,s0,$FF         // T1 = A_REG (8-Bit)
  or t1,t0               // T1 |= DP (Set Bits)
  sb t1,0(a2)            // DP = Set Bits (8-Bit)
  TestZBIT(t0)           // Test Result Zero Flag Of DP (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M1HEX07:
  // $07 ORA   [dp]              OR Accumulator With Memory Direct Page Indirect Long
  LoadDPIL8(t0)          // T0 = DP Indirect Long (8-Bit)
  andi t1,s0,$FF         // T1 = A_REG (8-Bit)
  or t1,t0               // T1 |= DP Indirect Long
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t1               // A_REG |= T1
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU65816M1HEX0C:
  // $0C TSB   nnnn              Test & Set Memory Bits Against Accumulator Absolute
  LoadABS8(t0)           // T0 = Absolute (8-Bit)
  andi t1,s0,$FF         // T1 = A_REG (8-Bit)
  or t1,t0               // T1 |= Absolute (Set Bits)
  sb t1,0(a2)            // Absolute = Set Bits (8-Bit)
  TestZBIT(t0)           // Test Result Zero Flag Of Absolute (8-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU65816M1HEX0F:
  // $0F ORA   nnnnnn            OR Accumulator With Memory Absolute Long
  LoadABSL8(t0)          // T0 = Absolute Long (8-Bit)
  andi t1,s0,$FF         // T1 = A_REG (8-Bit)
  or t1,t0               // T1 |= Absolute Long
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t1               // A_REG |= T1
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  addiu s3,3             // PC_REG += 3 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M1HEX12:
  // $12 ORA   (dp)              OR Accumulator With Memory Direct Page Indirect
  LoadDPI8(t0)           // T0 = DP Indirect (8-Bit)
  andi t1,s0,$FF         // T1 = A_REG (8-Bit)
  or t1,t0               // T1 |= DP Indirect
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t1               // A_REG |= T1
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M1HEX13:
  // $13 ORA   (sr,S),Y          OR Accumulator With Memory Stack Relative Indirect Indexed, Y
  LoadSRIY8(t0)          // T0 = SR Indirect Indexed, Y (8-Bit)
  andi t1,s0,$FF         // T1 = A_REG (8-Bit)
  or t1,t0               // T1 |= SR Indirect Indexed, Y
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t1               // A_REG |= T1
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

CPU65816M1HEX14:
  // $14 TRB   dp                Test & Reset Memory Bits Against Accumulator Direct Page
  LoadDP8(t0)            // T0 = DP (8-Bit)
  xori t1,s0,$FF         // T1 = A_REG ^ $FF (Complement)
  and t1,t0              // T1 = Reset Bits
  sb t1,0(a2)            // DP = Reset Bits (8-Bit)
  TestZBIT(t0)           // Test Result Zero Flag Of DP (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M1HEX17:
  // $17 ORA   [dp],Y            OR Accumulator With Memory Direct Page Indirect Long Indexed, Y
  LoadDPILY8(t0)         // T0 = DP Indirect Long Indexed, Y (8-Bit)
  andi t1,s0,$FF         // T1 = A_REG (8-Bit)
  or t1,t0               // T1 |= DP Indirect Long Indexed, Y
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t1               // A_REG |= T1
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU65816M1HEX1A:
  // $1A INA                     Increment Accumulator
  andi t0,s0,$FF         // T0 = A_REG (8-Bit)
  addiu t0,1             // T0++ (8-Bit)
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  andi t0,$FF            // T0 &= $FF
  or s0,t0               // A_REG |= T0
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU65816M1HEX1C:
  // $1C TRB   nnnn              Test & Reset Memory Bits Against Accumulator Absolute
  LoadABS8(t0)           // T0 = Absolute (8-Bit)
  xori t1,s0,$FF         // T1 = A_REG ^ $FF (Complement)
  and t1,t0              // T1 = Reset Bits
  sb t1,0(a2)            // Absolute = Reset Bits (8-Bit)
  TestZBIT(t0)           // Test Result Zero Flag Of Absolute (8-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU65816M1HEX1F:
  // $1F ORA   nnnnnn,X          OR Accumulator With Memory Absolute Long Indexed, X
  LoadABSLX8(t0)         // T0 = Absolute Long Indexed, X (8-Bit)
  andi t1,s0,$FF         // T1 = A_REG (8-Bit)
  or t1,t0               // T1 |= Absolute Long Indexed, X
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t1               // A_REG |= T1
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  addiu s3,3             // PC_REG += 3 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M1HEX23:
  // $23 AND   sr,S              AND Accumulator With Memory Stack Relative
  LoadSR8(t0)            // T0 = SR (8-Bit)
  andi t1,s0,$FF         // T1 = A_REG (8-Bit)
  and t1,t0              // T1 &= SR
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t1               // A_REG |= T1
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU65816M1HEX27:
  // $27 AND   [dp]              AND Accumulator With Memory Direct Page Indirect Long
  LoadDPIL8(t0)          // T0 = DP Indirect Long (8-Bit)
  andi t1,s0,$FF         // T1 = A_REG (8-Bit)
  and t1,t0              // T1 &= DP Indirect Long
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t1               // A_REG |= T1
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU65816M1HEX2F:
  // $2F AND   nnnnnn            AND Accumulator With Memory Absolute Long
  LoadABSL8(t0)          // T0 = Absolute Long (8-Bit)
  andi t1,s0,$FF         // T1 = A_REG (8-Bit)
  and t1,t0              // T1 &= Absolute Long
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t1               // A_REG |= T1
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  addiu s3,3             // PC_REG += 3 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M1HEX32:
  // $32 AND   (dp)              AND Accumulator With Memory Direct Page Indirect
  LoadDPI8(t0)           // T0 = DP Indirect (8-Bit)
  andi t1,s0,$FF         // T1 = A_REG (8-Bit)
  and t1,t0              // T1 &= DP Indirect
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t1               // A_REG |= T1
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M1HEX33:
  // $33 AND   (sr,S),Y          AND Accumulator With Memory Stack Relative Indirect Indexed, Y
  LoadSRIY8(t0)          // T0 = SR Indirect Indexed, Y (8-Bit)
  andi t1,s0,$FF         // T1 = A_REG (8-Bit)
  and t1,t0              // T1 &= SR Indirect Indexed, Y
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t1               // A_REG |= T1
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

CPU65816M1HEX34:
  // $34 BIT   dp,X              Test Memory Bits Against Accumulator Direct Page Indexed, X
  LoadDPX8(t0)           // T0 = DP Indexed, X (8-Bit)
  TestNVZBIT8(t0)        // Test Result Negative / Overflow / Zero Flags Of DP Indexed, X (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU65816M1HEX37:
  // $37 AND   [dp],Y            AND Accumulator With Memory Direct Page Indirect Long Indexed, Y
  LoadDPILY8(t0)         // T0 = DP Indirect Long Indexed, Y (8-Bit)
  andi t1,s0,$FF         // T1 = A_REG (8-Bit)
  and t1,t0              // T1 &= DP Indirect Long Indexed, Y
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t1               // A_REG |= T1
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU65816M1HEX3A:
  // $3A DEA                     Decrement Accumulator
  andi t0,s0,$FF         // T0 = A_REG (8-Bit)
  subiu t0,1             // T0-- (8-Bit)
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  andi t0,$FF            // T0 &= $FF
  or s0,t0               // A_REG |= T0
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU65816M1HEX3C:
  // $3C BIT   nnnn,X            Test Memory Bits Against Accumulator Absolute Indexed, X
  LoadABSX8(t0)          // T0 = Absolute Indexed, X (8-Bit)
  TestNVZBIT8(t0)        // Test Result Negative / Overflow / Zero Flags Of Absolute Indexed, X (8-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU65816M1HEX3F:
  // $3F AND   nnnnnn,X          AND Accumulator With Memory Absolute Long Indexed, X
  LoadABSLX8(t0)         // T0 = Absolute Long Indexed, X (8-Bit)
  andi t1,s0,$FF         // T1 = A_REG (8-Bit)
  and t1,t0              // T1 &= Absolute Long Indexed, X
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t1               // A_REG |= T1
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  addiu s3,3             // PC_REG += 3 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M1HEX43:
  // $43 EOR   sr,S              Exclusive-OR Accumulator With Memory Stack Relative
  LoadSR8(t0)            // T0 = SR (8-Bit)
  andi t1,s0,$FF         // T1 = A_REG (8-Bit)
  xor t1,t0              // T1 ^= SR
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t1               // A_REG |= T1
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU65816M1HEX47:
  // $47 EOR   [dp]              Exclusive-OR Accumulator With Memory Direct Page Indirect Long
  LoadDPIL8(t0)          // T0 = DP Indirect Long (8-Bit)
  andi t1,s0,$FF         // T1 = A_REG (8-Bit)
  xor t1,t0              // T1 ^= DP Indirect Long
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t1               // A_REG |= T1
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU65816M1HEX48:
  // $48 PHA                     Push Accumulator
  PushNAT8(s0)           // STACK = A_REG (8-Bit)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

CPU65816M1HEX4F:
  // $4F EOR   nnnnnn            Exclusive-OR Accumulator With Memory Absolute Long
  LoadABSL8(t0)          // T0 = Absolute Long (8-Bit)
  andi t1,s0,$FF         // T1 = A_REG (8-Bit)
  xor t1,t0              // T1 ^= Absolute Long
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t1               // A_REG |= T1
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  addiu s3,3             // PC_REG += 3 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M1HEX52:
  // $52 EOR   (dp)              Exclusive-OR Accumulator With Memory Direct Page Indirect
  LoadDPI8(t0)           // T0 = DP Indirect (8-Bit)
  andi t1,s0,$FF         // T1 = A_REG (8-Bit)
  xor t1,t0              // T1 ^= DP Indirect
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t1               // A_REG |= T1
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M1HEX53:
  // $53 EOR   (sr,S),Y          Exclusive-OR Accumulator With Memory Stack Relative Indirect Indexed, Y
  LoadSRIY8(t0)          // T0 = SR Indirect Indexed, Y (8-Bit)
  andi t1,s0,$FF         // T1 = A_REG (8-Bit)
  xor t1,t0              // T1 ^= SR Indirect Indexed, Y
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t1               // A_REG |= T1
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

CPU65816M1HEX57:
  // $57 EOR   [dp],Y            Exclusive-OR Accumulator With Memory Direct Page Indirect Long Indexed, Y
  LoadDPILY8(t0)         // T0 = DP Indirect Long Indexed, Y (8-Bit)
  andi t1,s0,$FF         // T1 = A_REG (8-Bit)
  xor t1,t0              // T1 ^= DP Indirect Long Indexed, Y
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t1               // A_REG |= T1
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU65816M1HEX5F:
  // $5F EOR   nnnnnn,X          Exclusive-OR Accumulator With Memory Absolute Long Indexed, X
  LoadABSLX8(t0)         // T0 = Absolute Long Indexed, X (8-Bit)
  andi t1,s0,$FF         // T1 = A_REG (8-Bit)
  xor t1,t0              // T1 ^= Absolute Long Indexed, X
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t1               // A_REG |= T1
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  addiu s3,3             // PC_REG += 3 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M1HEX63:
  // $63 ADC   sr,S              Add With Carry Accumulator With Memory Stack Relative
  LoadSR8(t0)            // T0 = SR (8-Bit)
  TestNVZCADC8(s0)       // Test Result Negative / Overflow / Zero / Carry Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU65816M1HEX64:
  // $64 STZ   dp                Store Zero To Memory Direct Page
  StoreDP8(r0)           // DP = 0 (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

CPU65816M1HEX67:
  // $67 ADC   [dp]              Add With Carry Accumulator With Memory Direct Page Indirect Long
  LoadDPIL8(t0)          // T0 = DP Indirect Long (8-Bit)
  TestNVZCADC8(s0)       // Test Result Negative / Overflow / Zero / Carry Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU65816M1HEX68:
  // $68 PLA                     Pull Accumulator
  PullNAT8(t0)           // T0 = STACK (8-Bit)
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t0               // A_REG |= T0
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU65816M1HEX6F:
  // $6F ADC   nnnnnn            Add With Carry Accumulator With Memory Absolute Long
  LoadABSL8(t0)          // T0 = Absolute Long (8-Bit)
  TestNVZCADC8(s0)       // Test Result Negative / Overflow / Zero / Carry Flags Of A_REG (8-Bit)
  addiu s3,3             // PC_REG += 3 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M1HEX72:
  // $72 ADC   (dp)              Add With Carry Accumulator With Memory Direct Page Indirect
  LoadDPI8(t0)           // T0 = DP Indirect (8-Bit)
  TestNVZCADC8(s0)       // Test Result Negative / Overflow / Zero / Carry Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M1HEX73:
  // $73 ADC   (sr,S),Y          Add With Carry Accumulator With Memory Stack Relative Indirect Indexed, Y
  LoadSRIY8(t0)          // T0 = SR Indirect Indexed, Y (8-Bit)
  TestNVZCADC8(s0)       // Test Result Negative / Overflow / Zero / Carry Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

CPU65816M1HEX74:
  // $74 STZ   dp,X              Store Zero To Memory Direct Page Indexed, X
  StoreDPX8(r0)          // DP Indexed, X = 0 (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU65816M1HEX77:
  // $77 ADC   [dp],Y            Add With Carry Accumulator With Memory Direct Page Indirect Long Indexed, Y
  LoadDPILY8(t0)         // T0 = DP Indirect Long Indexed, Y (8-Bit)
  TestNVZCADC8(s0)       // Test Result Negative / Overflow / Zero / Carry Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU65816M1HEX7F:
  // $7F ADC   nnnnnn,X          Add With Carry Accumulator With Memory Absolute Long Indexed, X
  LoadABSLX8(t0)         // T0 = Absolute Long Indexed, X (8-Bit)
  TestNVZCADC8(s0)       // Test Result Negative / Overflow / Zero / Carry Flags Of A_REG (8-Bit)
  addiu s3,3             // PC_REG += 3 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M1HEX83:
  // $83 STA   sr,S              Store Accumulator To Memory Stack Relative
  StoreSR8(s0)           // SR = A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU65816M1HEX87:
  // $87 STA   [dp]              Store Accumulator To Memory Direct Page Indirect Long
  StoreDPIL8(s0)         // DP Indirect Long = A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU65816M1HEX89:
  // $89 BIT   #nn               Test Memory Bits Against Accumulator Immediate
  LoadIMM8(t0)           // T0 = Immediate (8-Bit)
  TestZBIT(t0)           // Test Result Zero Flag Of Immediate (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU65816M1HEX8F:
  // $8F STA   nnnnnn            Store Accumulator To Memory Absolute Long
  StoreABSL8(s0)         // Absolute Long = A_REG (8-Bit)
  addiu s3,3             // PC_REG += 3 (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M1HEX92:
  // $92 STA   (dp)              Store Accumulator To Memory Direct Page Indirect
  StoreDPI8(s0)          // DP Indirect = A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M1HEX93:
  // $93 STA   (sr,S),Y          Store Accumulator To Memory Stack Relative Indirect Indexed, Y
  StoreSRIY8(s0)         // SR Indirect Indexed, Y = A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

CPU65816M1HEX97:
  // $97 STA   [dp],Y            Store Accumulator To Memory Direct Page Indirect Long Indexed, Y
  StoreDPILY8(s0)        // DP Indirect Long Indexed, Y = A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU65816M1HEX9C:
  // $9C STZ   nnnn              Store Zero To Memory Absolute
  StoreABS8(r0)          // Absolute = 0 (8-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU65816M1HEX9E:
  // $9E STZ   nnnn,X            Store Zero To Memory Absolute Indexed, X
  StoreABSX8(r0)         // Absolute Indexed, X = 0 (8-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M1HEX9F:
  // $9F STA   nnnnnn,X          Store Accumulator To Memory Absolute Long Indexed, X
  StoreABSLX8(s0)        // Absolute Long Indexed, X = A_REG (8-Bit)
  addiu s3,3             // PC_REG += 3 (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M1HEXA3:
  // $A3 LDA   sr,S              Load Accumulator From Memory Stack Relative
  LoadSR8(t0)            // T0 = SR (8-Bit)
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t0               // A_REG |= T0
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU65816M1HEXA7:
  // $A7 LDA   [dp]              Load Accumulator From Memory Direct Page Indirect Long
  LoadDPIL8(t0)          // T0 = DP Indirect Long (8-Bit)
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t0               // A_REG |= T0
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU65816M1HEXAF:
  // $AF LDA   nnnnnn            Load Accumulator From Memory Absolute Long
  LoadABSL8(t0)          // T0 = Absolute Long (8-Bit)
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t0               // A_REG |= T0
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  addiu s3,3             // PC_REG += 3 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M1HEXB2:
  // $B2 LDA   (dp)              Load Accumulator From Memory Direct Page Indirect
  LoadDPI8(t0)           // T0 = DP Indirect (8-Bit)
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t0               // A_REG |= T0
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M1HEXB3:
  // $B3 LDA   (sr,S),Y          Load Accumulator From Memory Stack Relative Indirect Indexed, Y
  LoadSRIY8(t0)          // T0 = SR Indirect Indexed, Y (8-Bit)
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t0               // A_REG |= T0
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

CPU65816M1HEXB7:
  // $B7 LDA   [dp],Y            Load Accumulator From Memory Direct Page Indirect Long Indexed, Y
  LoadDPILY8(t0)         // T0 = DP Indirect Long Indexed, Y (8-Bit)
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t0               // A_REG |= T0
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU65816M1HEXBF:
  // $BF LDA   nnnnnn,X          Load Accumulator From Memory Absolute Long Indexed, X
  LoadABSLX8(t0)         // T0 = Absolute Long Indexed, X (8-Bit)
  andi s0,$FF00          // Preserve Hidden B Register (8-Bit)
  or s0,t0               // A_REG |= T0
  TestNZ8(s0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  addiu s3,3             // PC_REG += 3 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M1HEXC3:
  // $C3 CMP   sr,S              Compare Accumulator With Memory Stack Relative
  LoadSR8(t0)            // T0 = SR (8-Bit)
  TestNZCCMP8(s0)        // Test Result Negative / Zero / Carry Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU65816M1HEXC7:
  // $C7 CMP   [dp]              Compare Accumulator With Memory Direct Page Indirect Long
  LoadDPIL8(t0)          // T0 = DP Indirect Long (8-Bit)
  TestNZCCMP8(s0)        // Test Result Negative / Zero / Carry Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU65816M1HEXCF:
  // $CF CMP   nnnnnn            Compare Accumulator With Memory Absolute Long
  LoadABSL8(t0)          // T0 = Absolute Long (8-Bit)
  TestNZCCMP8(s0)        // Test Result Negative / Zero / Carry Flags Of A_REG (8-Bit)
  addiu s3,3             // PC_REG += 3 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M1HEXD2:
  // $D2 CMP   (dp)              Compare Accumulator With Memory Direct Page Indirect
  LoadDPI8(t0)           // T0 = DP Indirect (8-Bit)
  TestNZCCMP8(s0)        // Test Result Negative / Zero / Carry Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M1HEXD3:
  // $D3 CMP   (sr,S),Y          Compare Accumulator With Memory Stack Relative Indirect Indexed, Y
  LoadSRIY8(t0)          // T0 = SR Indirect Indexed, Y (8-Bit)
  TestNZCCMP8(s0)        // Test Result Negative / Zero / Carry Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

CPU65816M1HEXD7:
  // $D7 CMP   [dp],Y            Compare Accumulator With Memory Direct Page Indirect Long Indexed, Y
  LoadDPILY8(t0)         // T0 = DP Indirect Long Indexed, Y (8-Bit)
  TestNZCCMP8(s0)        // Test Result Negative / Zero / Carry Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU65816M1HEXDF:
  // $DF CMP   nnnnnn,X          Compare Accumulator With Memory Absolute Long Indexed, X
  LoadABSLX8(t0)         // T0 = Absolute Long Indexed, X (8-Bit)
  TestNZCCMP8(s0)        // Test Result Negative / Zero / Carry Flags Of A_REG (8-Bit)
  addiu s3,3             // PC_REG += 3 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M1HEXE3:
  // $E3 SBC   sr,S              Subtract With Borrow From Accumulator With Memory Stack Relative
  LoadSR8(t0)            // T0 = SR (8-Bit)
  TestNVZCSBC8(s0)       // Test Result Negative / Overflow / Zero / Carry Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU65816M1HEXE7:
  // $E7 SBC   [dp]              Subtract With Borrow From Accumulator With Memory Direct Page Indirect Long
  LoadDPIL8(t0)          // T0 = DP Indirect Long (8-Bit)
  TestNVZCSBC8(s0)       // Test Result Negative / Overflow / Zero / Carry Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU65816M1HEXEF:
  // $EF SBC   nnnnnn            Subtract With Borrow From Accumulator With Memory Absolute Long
  LoadABSL8(t0)          // T0 = Absolute Long (8-Bit)
  TestNVZCSBC8(s0)       // Test Result Negative / Overflow / Zero / Carry Flags Of A_REG (8-Bit)
  addiu s3,3             // PC_REG += 3 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M1HEXF2:
  // $F2 SBC   (dp)              Subtract With Borrow From Accumulator With Memory Direct Page Indirect
  LoadDPI8(t0)           // T0 = DP Indirect (8-Bit)
  TestNVZCSBC8(s0)       // Test Result Negative / Overflow / Zero / Carry Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816M1HEXF3:
  // $F3 SBC   (sr,S),Y          Subtract With Borrow From Accumulator With Memory Stack Relative Indirect Indexed, Y
  LoadSRIY8(t0)          // T0 = SR Indirect Indexed, Y (8-Bit)
  TestNVZCSBC8(s0)       // Test Result Negative / Overflow / Zero / Carry Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

CPU65816M1HEXF7:
  // $F7 SBC   [dp],Y            Subtract With Borrow From Accumulator With Memory Direct Page Indirect Long Indexed, Y
  LoadDPILY8(t0)         // T0 = DP Indirect Long Indexed, Y (8-Bit)
  TestNVZCSBC8(s0)       // Test Result Negative / Overflow / Zero / Carry Flags Of A_REG (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU65816M1HEXFF:
  // $FF SBC   nnnnnn,X          Subtract With Borrow From Accumulator With Memory Absolute Long Indexed, X
  LoadABSLX8(t0)        // T0 = Absolute Long Indexed, X (8-Bit)
  TestNVZCSBC8(s0)      // Test Result Negative / Overflow / Zero / Carry Flags Of A_REG (8-Bit)
  addiu s3,3             // PC_REG += 3 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)