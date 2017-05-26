align(256)
  // $00 BRK   #nn               Software Break
  subiu s4,4             // S_REG -= 4 (Decrement Stack)
  andi s4,$FFFF
  addu a2,a0,s4          // STACK = MEM_MAP[$100 + S_REG]
  addiu a2,$100          // A2 = STACK                 
  sb s8,4(a2)            // STACK = PB_REG (65816 Native Mode)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  sb s3,2(a2)            // STACK = PC_REG
  srl t0,s3,8
  sb t0,3(a2)                 
  sb s5,1(a2)            // STACK = P_REG
  ori s5,I_FLAG          // P_REG: I Flag Set
  andi s5,~D_FLAG        // P_REG: D Flag Reset (65816 Native Mode)
  and s8,r0              // PB_REG = 0 (65816 Native Mode)
  lbu t0,BRK1_VEC+1(a0)  // PC_REG: Set To 65816 Break Vector ($FFE6)
  sll t0,8
  lbu s3,BRK1_VEC(a0)
  or s3,t0
  jr ra
  addiu v0,8             // Cycles += 8 (Delay Slot)

align(256)
  // $01 ORA   (dp,X)            OR Accumulator With Memory Direct Page Indexed Indirect, X
  LoadDPIX16(t0)         // T0 = DP Indexed Indirect, X (16-Bit)
  or s0,t0               // A_REG |= DP Indexed Indirect, X
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

align(256)
  // $02 COP   #nn               Co-Processor Enable
  subiu s4,4             // S_REG -= 4 (Decrement Stack)
  andi s4,$FFFF
  addu a2,a0,s4          // STACK = MEM_MAP[$100 + S_REG]
  addiu a2,$100          // A2 = STACK
  sb s8,4(a2)            // STACK = PB_REG (65816 Native Mode)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  sb s3,2(a2)            // STACK = PC_REG
  srl t0,s3,8
  sb t0,3(a2)
  sb s5,1(a2)            // STACK = P_REG
  ori s5,I_FLAG          // P_REG: I Flag Set
  andi s5,~D_FLAG        // P_REG: D Flag Reset
  and s8,r0              // PB_REG = 0 (65816 Native Mode)
  lbu t0,COP1_VEC+1(a0)  // PC_REG: Set To 65816 COP Vector ($FFE4)
  sll t0,8
  lbu s3,COP1_VEC(a0)
  or s3,t0
  jr ra
  addiu v0,8             // Cycles += 8 (Delay Slot)

align(256)
  // $03 ORA   sr,S              OR Accumulator With Memory Stack Relative
  LoadSR16(t0)           // T0 = SR (16-Bit)
  or s0,t0               // A_REG |= SR
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
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

align(256)
  // $05 ORA   dp                OR Accumulator With Memory Direct Page
  LoadDP16(t0)           // T0 = DP (16-Bit)
  or s0,t0               // A_REG |= DP
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
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

align(256)
  // $07 ORA   [dp]              OR Accumulator With Memory Direct Page Indirect Long
  LoadDPIL16(t0)         // T0 = DP Indirect Long (16-Bit)
  or s0,t0               // A_REG |= DP Indirect Long
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

align(256)
  // $08 PHP                     Push Processor Status Register
  PushNAT8(s5)           // STACK = P_REG (8-Bit)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $09 ORA   #nnnn             OR Accumulator With Memory Immediate
  LoadIMM16(t0)          // T0 = Immediate (16-Bit)
  or s0,t0               // A_REG |= Immediate
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $0A ASL A                   Shift Accumulator Left
  sll s0,1               // A_REG <<= 1 (16-Bit)
  TestNZCASLROL16(s0)    // Test Result Negative / Zero / Carry Flags Of A_REG (16-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $0B PHD                     Push Direct Page Register
  PushNAT16(s6)          // STACK = D_REG (16-Bit)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
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

align(256)
  // $0D ORA   nnnn              OR Accumulator With Memory Absolute
  LoadABS16(t0)          // T0 = Absolute (16-Bit)
  or s0,t0               // A_REG |= Absolute
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
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

align(256)
  // $0F ORA   nnnnnn            OR Accumulator With Memory Absolute Long
  LoadABSL16(t0)         // T0 = Absolute Long (16-Bit)
  or s0,t0               // A_REG |= Absolute Long
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,3             // PC_REG += 3 (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

align(256)
  // $10 BPL   nn                Branch IF Plus
  BranchCLR(N_FLAG)      // IF (N Flag == 0) Branch, ELSE Continue
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $11 ORA   (dp),Y            OR Accumulator With Memory Direct Page Indirect Indexed, Y
  LoadDPIY16(t0)         // T0 = DP Indirect Indexed, Y (16-Bit)
  or s0,t0               // A_REG |= DP Indirect Indexed, Y
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

align(256)
  // $12 ORA   (dp)              OR Accumulator With Memory Direct Page Indirect
  LoadDPI16(t0)          // T0 = DP Indirect (16-Bit)
  or s0,t0               // A_REG |= DP Indirect
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

align(256)
  // $13 ORA   (sr,S),Y          OR Accumulator With Memory Stack Relative Indirect Indexed, Y
  LoadSRIY16(t0)         // T0 = SR Indirect Indexed, Y (16-Bit)
  or s0,t0               // A_REG |= SR Indirect Indexed, Y
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,8             // Cycles += 8 (Delay Slot)

align(256)
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

align(256)
  // $15 ORA   dp,X              OR Accumulator With Memory Direct Page Indexed, X
  LoadDPX16(t0)          // T0 = DP Indexed, X (16-Bit)
  or s0,t0               // A_REG |= DP Indexed, X
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
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

align(256)
  // $17 ORA   [dp],Y            OR Accumulator With Memory Direct Page Indirect Long Indexed, Y
  LoadDPILY16(t0)        // T0 = DP Indirect Long Indexed, Y (16-Bit)
  or s0,t0               // A_REG |= DP Indirect Long Indexed, Y
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

align(256)
  // $18 CLC                     Clear Carry Flag
  andi s5,~C_FLAG        // P_REG: C Flag Reset
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $19 ORA   nnnn,Y            OR Accumulator With Memory Absolute Indexed, Y
  LoadABSY16(t0)         // T0 = Absolute Indexed, Y (16-Bit)
  or s0,t0               // A_REG |= Absolute Indexed, Y
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $1A INA                     Increment Accumulator
  addiu s0,1             // A_REG++ (16-Bit)
  andi s0,$FFFF          // A_REG = 16-Bit
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $1B TCS                     Transfer Accumulator To Stack Pointer
  andi s4,s0,$FFFF       // S_REG = C_REG (16-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
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

align(256)
  // $1D ORA   nnnn,X            OR Accumulator With Memory Absolute Indexed, X
  LoadABSX16(t0)         // T0 = Absolute Indexed, X (16-Bit)
  or s0,t0               // A_REG |= Absolute Indexed, X
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
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

align(256)
  // $1F ORA   nnnnnn,X          OR Accumulator With Memory Absolute Long Indexed, X
  LoadABSLX16(t0)        // T0 = Absolute Long Indexed, X (16-Bit)
  or s0,t0               // A_REG |= Absolute Long Indexed, X
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,3             // PC_REG += 3 (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

align(256)
  // $20 JSR   nnnn              Jump To Subroutine Absolute
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  PushNAT16(s3)          // STACK = PC_REG (16-Bit)
  LoadIMM16(s3)          // PC_REG = Immediate (16-Bit)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

align(256)
  // $21 AND   (dp,X)            AND Accumulator With Memory Direct Page Indexed Indirect, X
  LoadDPIX16(t0)         // T0 = DP Indexed Indirect, X (16-Bit)
  and s0,t0              // A_REG &= DP Indexed Indirect, X
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

align(256)
  // $22 JSL   nnnnnn            Jump To Subroutine Absolute Long
  addiu s3,2             // PC_REG += 2
  PushNAT24(s3)          // STACK = PC_REG (16-Bit), PB_REG (8-Bit)
  LoadIMM16(s3)          // PC_REG = Immediate (16-Bit)
  lbu s8,3(a2)           // PB_REG = Bank Address (8-Bit)
  jr ra
  addiu v0,8             // Cycles += 8 (Delay Slot)

align(256)
  // $23 AND   sr,S              AND Accumulator With Memory Stack Relative
  LoadSR16(t0)           // T0 = SR (16-Bit)
  and s0,t0              // A_REG &= SR
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $24 BIT   dp                Test Memory Bits Against Accumulator Direct Page
  LoadDP16(t0)           // T0 = DP (16-Bit)
  TestNVZBIT16(t0)       // Test Result Negative / Overflow / Zero Flags Of DP (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $25 AND   dp                AND Accumulator With Memory Direct Page
  LoadDP16(t0)           // T0 = DP (16-Bit)
  and s0,t0              // A_REG &= DP
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
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

align(256)
  // $27 AND   [dp]              AND Accumulator With Memory Direct Page Indirect Long
  LoadDPIL16(t0)         // T0 = DP Indirect Long (16-Bit)
  and s0,t0              // A_REG &= DP Indirect Long
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

align(256)
  // $28 PLP                     Pull Status Flags
  PullNAT8(s5)           // P_REG = STACK (8-Bit)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $29 AND   #nnnn             AND Accumulator With Memory Immediate
  LoadIMM16(t0)          // T0 = Immediate (16-Bit)
  and s0,t0              // A_REG &= Immediate
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $2A ROL A                   Rotate Accumulator Left
  sll s0,1               // A_REG = Rotate Left (16-Bit)
  andi t0,s5,C_FLAG      // T0 = C Flag
  or s0,t0               // A_REG |= C Flag (16-Bit)
  TestNZCASLROL16(s0)    // Test Result Negative / Zero / Carry Flags Of A_REG (16-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $2B PLD                     Pull Direct Page Register
  PullNAT16(s6)          // D_REG = STACK (16-Bit)
  TestNZ16(s6)           // Test Result Negative / Zero Flags Of D_REG (16-Bit)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $2C BIT   nnnn              Test Memory Bits Against Accumulator Absolute
  LoadABS16(t0)          // T0 = Absolute (16-Bit)
  TestNVZBIT16(t0)       // Test Result Negative / Overflow / Zero Flags Of Absolute (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $2D AND   nnnn              AND Accumulator With Memory Absolute
  LoadABS16(t0)          // T0 = Absolute (16-Bit)
  and s0,t0              // A_REG &= Absolute
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
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

align(256)
  // $2F AND   nnnnnn            AND Accumulator With Memory Absolute Long
  LoadABSL16(t0)         // T0 = Absolute Long (16-Bit)
  and s0,t0              // A_REG &= Absolute Long
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,3             // PC_REG += 3 (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

align(256)
  // $30 BMI   nn                Branch IF Minus
  BranchSET(N_FLAG)      // IF (N Flag != 0) Branch, ELSE Continue
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $31 AND   (dp),Y            AND Accumulator With Memory Direct Page Indirect Indexed, Y
  LoadDPIY16(t0)         // T0 = DP Indirect Indexed, Y (16-Bit)
  and s0,t0              // A_REG &= DP Indirect Indexed, Y
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

align(256)
  // $32 AND   (dp)              AND Accumulator With Memory Direct Page Indirect
  LoadDPI16(t0)          // T0 = DP Indirect (16-Bit)
  and s0,t0              // A_REG &= DP Indirect
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

align(256)
  // $33 AND   (sr,S),Y          AND Accumulator With Memory Stack Relative Indirect Indexed, Y
  LoadSRIY16(t0)         // T0 = SR Indirect Indexed, Y (16-Bit)
  and s0,t0              // A_REG &= SR Indirect Indexed, Y
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,8             // Cycles += 8 (Delay Slot)

align(256)
  // $34 BIT   dp,X              Test Memory Bits Against Accumulator Direct Page Indexed, X
  LoadDPX16(t0)          // T0 = DP Indexed, X (16-Bit)
  TestNVZBIT16(t0)       // Test Result Negative / Overflow / Zero Flags Of DP Indexed, X (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $35 AND   dp,X              AND Accumulator With Memory Direct Page Indexed, X
  LoadDPX16(t0)          // T0 = DP Indexed, X (16-Bit)
  and s0,t0              // A_REG &= DP Indexed, X
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
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

align(256)
  // $37 AND   [dp],Y            AND Accumulator With Memory Direct Page Indirect Long Indexed, Y
  LoadDPILY16(t0)        // T0 = DP Indirect Long Indexed, Y (16-Bit)
  and s0,t0              // A_REG &= DP Indirect Long Indexed, Y
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

align(256)
  // $38 SEC                     Set Carry Flag
  ori s5,C_FLAG          // P_REG: C Flag Set
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $39 AND   nnnn,Y            AND Accumulator With Memory Absolute Indexed, Y
  LoadABSY16(t0)         // T0 = Absolute Indexed, Y (16-Bit)
  and s0,t0              // A_REG &= Absolute Indexed, Y
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $3A DEA                     Decrement Accumulator
  subiu s0,1             // A_REG-- (16-Bit)
  andi s0,$FFFF          // A_REG = 16-Bit
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $3B TSC                     Transfer Stack Pointer To 16-Bit Accumulator
  andi s0,s4,$FFFF       // C_REG = S_REG (16-Bit)
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of C_REG (16-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $3C BIT   nnnn,X            Test Memory Bits Against Accumulator Absolute Indexed, X
  LoadABSX16(t0)         // T0 = Absolute Indexed, X (16-Bit)
  TestNVZBIT16(t0)       // Test Result Negative / Overflow / Zero Flags Of Absolute Indexed, X (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $3D AND   nnnn,X            AND Accumulator With Memory Absolute Indexed, X
  LoadABSX16(t0)         // T0 = Absolute Indexed, X (16-Bit)
  and s0,t0              // A_REG &= Absolute Indexed, X
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
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

align(256)
  // $3F AND   nnnnnn,X          AND Accumulator With Memory Absolute Long Indexed, X
  LoadABSLX16(t0)        // T0 = Absolute Long Indexed, X (16-Bit)
  and s0,t0              // A_REG &= Absolute Long Indexed, X
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,3             // PC_REG += 3 (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

align(256)
  // $40 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $41 EOR   (dp,X)            Exclusive-OR Accumulator With Memory Direct Page Indexed Indirect, X
  LoadDPIX16(t0)         // T0 = DP Indexed Indirect, X (16-Bit)
  xor s0,t0              // A_REG ^= DP Indexed Indirect, X
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

align(256)
  // $42 WDM   #nn               Reserved For Future Expansion
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $43 EOR   sr,S              Exclusive-OR Accumulator With Memory Stack Relative
  LoadSR16(t0)           // T0 = SR (16-Bit)
  xor s0,t0              // A_REG ^= SR
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $44 MVP   sb,db             Block Move Previous
  BlockMVP()             // Transfer Bytes From Source Bank To Destination Bank
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

align(256)
  // $45 EOR   dp                Exclusive-OR Accumulator With Memory Direct Page
  LoadDP16(t0)           // T0 = DP (16-Bit)
  xor s0,t0              // A_REG ^= DP
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
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

align(256)
  // $47 EOR   [dp]              Exclusive-OR Accumulator With Memory Direct Page Indirect Long
  LoadDPIL16(t0)         // T0 = DP Indirect Long (16-Bit)
  xor s0,t0              // A_REG ^= DP Indirect Long
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

align(256)
  // $48 PHA                     Push Accumulator
  PushNAT16(s0)          // STACK = A_REG (16-Bit)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $49 EOR   #nnnn             Exclusive-OR Accumulator With Memory Immediate
  LoadIMM16(t0)          // T0 = Immediate (16-Bit)
  xor s0,t0              // A_REG ^= Immediate
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $4A LSR A                   Logical Shift Accumulator Right
  andi t1,s0,1           // Test Negative MSB / Carry
  srl s0,1               // A_REG >>= 1 (16-Bit)
  TestNZCLSRROR(s0)      // Test Result Negative / Zero / Carry Flags Of A_REG (16-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $4B PHK                     Push Program Bank Register
  PushNAT8(s8)           // STACK = PB_REG (8-Bit)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $4C JMP   nnnn              Jump Absolute
  LoadIMM16(s3)          // PC_REG = Immediate (16-Bit)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $4D EOR   nnnn              Exclusive-OR Accumulator With Memory Absolute
  LoadABS16(t0)          // T0 = Absolute (16-Bit)
  xor s0,t0              // A_REG ^= Absolute
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
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

align(256)
  // $4F EOR   nnnnnn            Exclusive-OR Accumulator With Memory Absolute Long
  LoadABSL16(t0)         // T0 = Absolute Long (16-Bit)
  xor s0,t0              // A_REG ^= Absolute Long
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,3             // PC_REG += 3 (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

align(256)
  // $50 BVC   nn                Branch IF Overflow Clear
  BranchCLR(V_FLAG)      // IF (V Flag == 0) Branch, ELSE Continue
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $51 EOR   (dp),Y            Exclusive-OR Accumulator With Memory Direct Page Indirect Indexed, Y
  LoadDPIY16(t0)         // T0 = DP Indirect Indexed, Y (16-Bit)
  xor s0,t0              // A_REG ^= DP Indirect Indexed, Y
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

align(256)
  // $52 EOR   (dp)              Exclusive-OR Accumulator With Memory Direct Page Indirect
  LoadDPI16(t0)          // T0 = DP Indirect (16-Bit)
  xor s0,t0              // A_REG ^= DP Indirect
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

align(256)
  // $53 EOR   (sr,S),Y          Exclusive-OR Accumulator With Memory Stack Relative Indirect Indexed, Y
  LoadSRIY16(t0)         // T0 = SR Indirect Indexed, Y (16-Bit)
  xor s0,t0              // A_REG ^= SR Indirect Indexed, Y
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,8             // Cycles += 8 (Delay Slot)

align(256)
  // $54 MVN   sb,db             Block Move Next
  BlockMVN()             // Transfer Bytes From Source Bank To Destination Bank
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

align(256)
  // $55 EOR   dp,X              Exclusive-OR Accumulator With Memory Direct Page Indexed, X
  LoadDPX16(t0)          // T0 = DP Indexed, X (16-Bit)
  xor s0,t0              // A_REG ^= DP Indexed, X
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
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

align(256)
  // $57 EOR   [dp],Y            Exclusive-OR Accumulator With Memory Direct Page Indirect Long Indexed, Y
  LoadDPILY16(t0)        // T0 = DP Indirect Long Indexed, Y (16-Bit)
  xor s0,t0              // A_REG ^= DP Indirect Long Indexed, Y
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

align(256)
  // $58 CLI                     Clear Interrupt Disable Flag
  andi s5,~I_FLAG        // P_REG: I Flag Reset
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $59 EOR   nnnn,Y            Exclusive-OR Accumulator With Memory Absolute Indexed, Y
  LoadABSY16(t0)         // T0 = Absolute Indexed, Y (16-Bit)
  xor s0,t0              // A_REG ^= Absolute Indexed, Y
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $5A PHY                     Push Index Register Y
  PushNAT16(s2)          // STACK = Y_REG (16-Bit)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $5B TCD                     Transfer 16-Bit Accumulator To Direct Page Register
  andi s6,s0,$FFFF       // D_REG = C_REG (16-Bit)
  TestNZ16(s6)           // Test Result Negative / Zero Flags Of D_REG (16-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $5C JML   nnnnnn            Jump Absolute Long
  LoadIMM16(s3)          // PC_REG = Immediate (16-Bit)
  lbu s8,3(a2)           // PB_REG = Bank Address (8-Bit)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $5D EOR   nnnn,X            Exclusive-OR Accumulator With Memory Absolute Indexed, X
  LoadABSX16(t0)         // T0 = Absolute Indexed, X (16-Bit)
  xor s0,t0              // A_REG ^= Absolute Indexed, X
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
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

align(256)
  // $5F EOR   nnnnnn,X          Exclusive-OR Accumulator With Memory Absolute Long Indexed, X
  LoadABSLX16(t0)        // T0 = Absolute Long Indexed, X (16-Bit)
  xor s0,t0              // A_REG ^= Absolute Long Indexed, X
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,3             // PC_REG += 3 (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

align(256)
  // $60 RTS                     Return From Subroutine
  addiu s4,2             // S_REG += 2 (Increment Stack)
  andi s4,$FFFF
  addu a2,a0,s4          // PC_REG = STACK (16-Bit)
  lbu t0,0(a2)
  sll t0,8
  lbu s3,-1(a2)
  or s3,t0
  addiu s3,1             // PC_REG++
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

align(256)
  // $61 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $62 PER   nnnn              Push Effective PC Relative Indirect Address
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  PushER16()             // STACK = Effective PC Relative Indirect Address (16-Bit)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

align(256)
  // $63 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $64 STZ   dp                Store Zero To Memory Direct Page
  StoreDP16(r0)          // DP = 0 (16-Bit)
  la sp,StoreWord        // Store Word
  jalr sp,sp
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $65 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
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

align(256)
  // $67 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $68 PLA                     Pull Accumulator
  PullNAT16(s0)          // A_REG = STACK (16-Bit)
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $69 ADC   #nnnn             Add With Carry Accumulator With Memory Immediate
  addu a2,a0,s3          // A_REG: Add With Carry With 16-Bit Immediate
  lbu t1,1(a2)
  sll t1,8
  lbu t0,0(a2)
  or t0,t1
  addu s0,t0
  andi t0,s5,C_FLAG
  addu s0,t0
  andi t0,s0,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  li t1,$00018000        // Test Signed Overflow
  and t0,s0,t1
  beq t0,t1,ADCIMMM0X0V  // IF (Signed Overflow) V Flag Set
  ori s5,V_FLAG          // P_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG        // P_REG: V Flag Reset
  ADCIMMM0X0V:
  lui t1,$0001           // Test Unsigned Overflow
  beq t0,t1,ADCIMMM0X0C  // IF (Unsigned Overflow) C Flag Set
  ori s5,C_FLAG          // P_REG: C Flag Set (Delay Slot)
  andi s5,~C_FLAG        // P_REG: C Flag Reset
  ADCIMMM0X0C:
  andi s0,$FFFF
  beqz s0,ADCIMMM0X0Z    // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  ADCIMMM0X0Z:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
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

align(256)
  // $6B RTL                     Return From Subroutine Long
  addiu s4,3             // S_REG += 3 (Increment Stack)
  andi s4,$FFFF
  addu a2,a0,s4          // PC_REG = STACK (16-Bit)
  lbu t0,-1(a2)
  sll t0,8
  lbu s3,-2(a2)
  or s3,t0
  addiu s3,1             // PC_REG++
  lbu s8,0(a2)           // PB_REG = STACK
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

align(256)
  // $6C JMP   (nnnn)            Jump Absolute Indirect
  JumpABSI16()           // PC_REG = Absolute Indirect (16-Bit)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $6D ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
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

align(256)
  // $6F ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $70 BVS   nn                Branch IF Overflow Set
  BranchSET(V_FLAG)      // IF (V Flag != 0) Branch, ELSE Continue
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $71 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $72 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $73 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $74 STZ   dp,X              Store Zero To Memory Direct Page Indexed, X
  StoreDPX16(r0)         // DP Indexed, X = 0 (16-Bit)
  la sp,StoreWord        // Store Word
  jalr sp,sp
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $75 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
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

align(256)
  // $77 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $78 SEI                     Set Interrupt Disable Flag
  ori s5,I_FLAG          // P_REG: I Flag Set
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $79 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $7A PLY                     Pull Index Register Y From Stack
  PullNAT16(s2)          // Y_REG = STACK (16-Bit)
  TestNZ16(s2)           // Test Result Negative / Zero Flags Of Y_REG (16-Bit)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $7B TDC                     Transfer Direct Page Register To 16-Bit Accumulator
  andi s0,s6,$FFFF       // C_REG = D_REG (16-Bit)
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of C_REG (16-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $7C JMP   (nnnn,X)          Jump Absolute Indexed Indirect
  JumpABSIX16()          // PC_REG = Absolute Indexed Indirect
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

align(256)
  // $7D ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
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

align(256)
  // $7F ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $80 BRA   nn                Branch Always
  Branch8()              // Branch (8-Bit)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $81 STA   (dp,X)            Store Accumulator To Memory Direct Page Indexed Indirect, X
  StoreDPIX16(s0)        // DP Indexed Indirect, X = A_REG (16-Bit)
  la sp,StoreWord        // Store Word
  jalr sp,sp
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

align(256)
  // $82 BRL   nnnn              Branch Always Long
  Branch16()             // Branch Long (16-Bit)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $83 STA   sr,S              Store Accumulator To Memory Stack Relative
  StoreSR16(s0)          // SR = A_REG (16-Bit)
  la sp,StoreWord        // Store Word
  jalr sp,sp
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $84 STY   dp                Store Index Register Y To Memory Direct Page
  StoreDP16(s2)          // DP = Y_REG (16-Bit)
  la sp,StoreWord        // Store Word
  jalr sp,sp
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $85 STA   dp                Store Accumulator To Memory Direct Page
  StoreDP16(s0)          // DP = A_REG (16-Bit)
  la sp,StoreWord        // Store Word
  jalr sp,sp
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $86 STX   dp                Store Index Register X To Memory Direct Page
  StoreDP16(s1)          // DP = X_REG (16-Bit)
  la sp,StoreWord        // Store Word
  jalr sp,sp
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $87 STA   [dp]              Store Accumulator To Memory Direct Page Indirect Long
  StoreDPIL16(s0)        // DP Indirect Long = A_REG (16-Bit)
  la sp,StoreWord        // Store Word
  jalr sp,sp
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

align(256)
  // $88 DEY                     Decrement Index Register Y
  subiu s2,1             // Y_REG-- (16-Bit)
  andi s2,$FFFF          // Y_REG = 16-Bit
  TestNZ16(s2)           // Test Result Negative / Zero Flags Of Y_REG (16-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $89 BIT   #nnnn             Test Memory Bits Against Accumulator Immediate
  LoadIMM16(t0)          // T0 = Immediate (16-Bit)
  TestZBIT(t0)           // Test Result Zero Flag Of Immediate (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $8A TXA                     Transfer Index Register X To Accumulator
  andi s0,s1,$FFFF       // A_REG = X_REG (16-Bit)
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $8B PHB                     Push Data Bank Register
  PushNAT8(s7)           // STACK = DB_REG (8-Bit)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $8C STY   nnnn              Store Index Register Y To Memory Absolute
  StoreABS16(s2)         // Absolute = Y_REG (16-Bit)
  la sp,StoreWord        // Store Word
  jalr sp,sp
  addiu s3,2             // PC_REG += 2 (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $8D STA   nnnn              Store Accumulator To Memory Absolute
  StoreABS16(s0)         // Absolute = A_REG (16-Bit)
  la sp,StoreWord        // Store Word
  jalr sp,sp
  addiu s3,2             // PC_REG += 2 (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $8E STX   nnnn              Store Index Register X To Memory Absolute
  StoreABS16(s1)         // Absolute = X_REG (16-Bit)
  la sp,StoreWord        // Store Word
  jalr sp,sp
  addiu s3,2             // PC_REG += 2 (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $8F STA   nnnnnn            Store Accumulator To Memory Absolute Long
  StoreABSL16(s0)        // Absolute Long = A_REG (16-Bit)
  la sp,StoreWord        // Store Word
  jalr sp,sp
  addiu s3,3             // PC_REG += 3 (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

align(256)
  // $90 BCC   nn                Branch IF Carry Clear
  BranchCLR(C_FLAG)      // IF (C Flag == 0) Branch, ELSE Continue
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $91 STA   (dp),Y            Store Accumulator To Memory Direct Page Indirect Indexed, Y
  StoreDPIY16(s0)        // DP Indirect Indexed, Y = A_REG (16-Bit)
  la sp,StoreWord        // Store Word
  jalr sp,sp
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

align(256)
  // $92 STA   (dp)              Store Accumulator To Memory Direct Page Indirect
  StoreDPI16(s0)         // DP Indirect = A_REG (16-Bit)
  la sp,StoreWord        // Store Word
  jalr sp,sp
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

align(256)
  // $93 STA   (sr,S),Y          Store Accumulator To Memory Stack Relative Indirect Indexed, Y
  StoreSRIY16(s0)        // SR Indirect Indexed, Y = A_REG (16-Bit)
  la sp,StoreWord        // Store Word
  jalr sp,sp
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,8             // Cycles += 8 (Delay Slot)

align(256)
  // $94 STY   dp,X              Store Index Register Y To Memory Direct Page Indexed, X
  StoreDPX16(s2)         // DP Indexed, X = Y_REG (16-Bit)
  la sp,StoreWord        // Store Word
  jalr sp,sp
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $95 STA   dp,X              Store Accumulator To Memory Direct Page Indexed, X
  StoreDPX16(s0)         // DP Indexed, X = A_REG (16-Bit)
  la sp,StoreWord        // Store Word
  jalr sp,sp
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $96 STX   dp,Y              Store Index Register X To Memory Direct Page Indexed, Y
  StoreDPY16(s1)         // DP Indexed, Y = X_REG (16-Bit)
  la sp,StoreWord        // Store Word
  jalr sp,sp
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $97 STA   [dp],Y            Store Accumulator To Memory Direct Page Indirect Long Indexed, Y
  StoreDPILY16(s0)       // DP Indirect Long Indexed, Y = A_REG (16-Bit)
  la sp,StoreWord        // Store Word
  jalr sp,sp
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

align(256)
  // $98 TYA                     Transfer Index Register Y To Accumulator
  andi s0,s2,$FFFF       // A_REG = Y_REG (16-Bit)
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $99 STA   nnnn,Y            Store Accumulator To Memory Absolute Indexed, Y
  StoreABSY16(s0)        // Absolute Indexed, Y = A_REG (16-Bit)
  la sp,StoreWord        // Store Word
  jalr sp,sp
  addiu s3,2             // PC_REG += 2 (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

align(256)
  // $9A TXS                     Transfer Index Register X To Stack Pointer
  andi s4,s1,$FFFF       // S_REG = X_REG (16-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $9B TXY                     Transfer Index Register X To Y
  andi s2,s1,$FFFF       // Y_REG = X_REG (16-Bit)
  TestNZ16(s2)           // Test Result Negative / Zero Flags Of Y_REG (16-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $9C STZ   nnnn              Store Zero To Memory Absolute
  StoreABS16(r0)         // Absolute = 0 (16-Bit)
  la sp,StoreWord        // Store Word
  jalr sp,sp
  addiu s3,2             // PC_REG += 2 (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $9D STA   nnnn,X            Store Accumulator To Memory Absolute Indexed, X
  StoreABSX16(s0)        // Absolute Indexed, X = A_REG (16-Bit)
  la sp,StoreWord        // Store Word
  jalr sp,sp
  addiu s3,2             // PC_REG += 2 (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

align(256)
  // $9E STZ   nnnn,X            Store Zero To Memory Absolute Indexed, X
  StoreABSX16(r0)        // Absolute Indexed, X = 0 (16-Bit)
  la sp,StoreWord        // Store Word
  jalr sp,sp
  addiu s3,2             // PC_REG += 2 (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

align(256)
  // $9F STA   nnnnnn,X          Store Accumulator To Memory Absolute Long Indexed, X
  StoreABSLX16(s0)       // Absolute Long Indexed, X = A_REG (16-Bit)
  la sp,StoreWord        // Store Word
  jalr sp,sp
  addiu s3,3             // PC_REG += 3 (Increment Program Counter) (Delay Slot)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

align(256)
  // $A0 LDY   #nnnn             Load Index Register Y From Memory Immediate
  LoadIMM16(s2)          // Y_REG = Immediate (16-Bit)
  TestNZ16(s2)           // Test Result Negative / Zero Flags Of Y_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $A1 LDA   (dp,X)            Load Accumulator From Memory Direct Page Indexed Indirect, X
  LoadDPIX16(s0)         // A_REG = DP Indexed Indirect, X (16-Bit)
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

align(256)
  // $A2 LDX   #nnnn             Load Index Register X From Memory Immediate
  LoadIMM16(s1)          // X_REG = Immediate (16-Bit)
  TestNZ16(s1)           // Test Result Negative / Zero Flags Of X_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $A3 LDA   sr,S              Load Accumulator From Memory Stack Relative
  LoadSR16(s0)           // A_REG = SR (16-Bit)
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $A4 LDY   dp                Load Index Register Y From Memory Direct Page
  LoadDP16(s2)           // Y_REG = DP (16-Bit)
  TestNZ16(s2)           // Test Result Negative / Zero Flags Of Y_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $A5 LDA   dp                Load Accumulator From Memory Direct Page
  LoadDP16(s0)           // A_REG = DP (16-Bit)
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $A6 LDX   dp                Load Index Register X From Memory Direct Page
  LoadDP16(s1)           // X_REG = DP (16-Bit)
  TestNZ16(s1)           // Test Result Negative / Zero Flags Of X_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $A7 LDA   [dp]              Load Accumulator From Memory Direct Page Indirect Long
  LoadDPIL16(s0)         // A_REG = DP Indirect Long (16-Bit)
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

align(256)
  // $A8 TAY                     Transfer Accumulator To Index Register Y
  andi s2,s0,$FFFF       // Y_REG = A_REG (16-Bit)
  TestNZ16(s2)           // Test Result Negative / Zero Flags Of Y_REG (16-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $A9 LDA   #nnnn             Load Accumulator From Memory Immediate
  LoadIMM16(s0)          // A_REG = Immediate (16-Bit)
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $AA TAX                     Transfer Accumulator To Index Register X
  andi s1,s0,$FFFF       // X_REG = A_REG (16-Bit)
  TestNZ16(s1)           // Test Result Negative / Zero Flags Of X_REG (16-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $AB PLB                     Pull Data Bank Register
  PullNAT8(s7)           // DB_REG = STACK (8-Bit)
  TestNZ8(s7)            // Test Result Negative / Zero Flags Of DB_REG (8-Bit)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $AC LDY   nnnn              Load Index Register Y From Memory Absolute
  LoadABS16(s2)          // Y_REG = Absolute (16-Bit)
  TestNZ16(s2)           // Test Result Negative / Zero Flags Of Y_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $AD LDA   nnnn              Load Accumulator From Memory Absolute
  LoadABS16(s0)          // A_REG = Absolute (16-Bit)
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $AE LDX   nnnn              Load Index Register X From Memory Absolute
  LoadABS16(s1)          // X_REG = Absolute (16-Bit)
  TestNZ16(s1)           // Test Result Negative / Zero Flags Of X_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $AF LDA   nnnnnn            Load Accumulator From Memory Absolute Long
  LoadABSL16(s0)         // A_REG = Absolute Long (16-Bit)
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,3             // PC_REG += 3 (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

align(256)
  // $B0 BCS   nn                Branch IF Carry Set
  BranchSET(C_FLAG)      // IF (C Flag != 0) Branch, ELSE Continue
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $B1 LDA   (dp),Y            Load Accumulator From Memory Direct Page Indirect Indexed, Y
  LoadDPIY16(s0)         // A_REG = DP Indirect Indexed, Y (16-Bit)
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

align(256)
  // $B2 LDA   (dp)              Load Accumulator From Memory Direct Page Indirect
  LoadDPI16(s0)          // A_REG = DP Indirect (16-Bit)
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

align(256)
  // $B3 LDA   (sr,S),Y          Load Accumulator From Memory Stack Relative Indirect Indexed, Y
  LoadSRIY16(s0)         // A_REG = SR Indirect Indexed, Y (16-Bit)
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,8             // Cycles += 8 (Delay Slot)

align(256)
  // $B4 LDY   dp,X              Load Index Register Y From Memory Direct Page Indexed, X
  LoadDPX16(s2)          // Y_REG = DP Indexed, X (16-Bit)
  TestNZ16(s2)           // Test Result Negative / Zero Flags Of Y_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $B5 LDA   dp,X              Load Accumulator From Memory Direct Page Indexed, X
  LoadDPX16(s0)          // A_REG = DP Indexed, X (16-Bit)
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $B6 LDX   dp,Y              Load Index Register X From Memory Direct Page Indexed, Y
  LoadDPY16(s1)          // X_REG = DP Indexed, Y (16-Bit)
  TestNZ16(s1)           // Test Result Negative / Zero Flags Of X_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $B7 LDA   [dp],Y            Load Accumulator From Memory Direct Page Indirect Long Indexed, Y
  LoadDPILY16(s0)        // A_REG = DP Indirect Long Indexed, Y (16-Bit)
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

align(256)
  // $B8 CLV                     Clear Overflow Flag
  andi s5,~V_FLAG        // P_REG: V Flag Reset
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $B9 LDA   nnnn,Y            Load Accumulator From Memory Absolute Indexed, Y
  LoadABSY16(s0)         // A_REG = Absolute Indexed, Y (16-Bit)
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $BA TSX                     Transfer Stack Pointer To Index Register X
  andi s1,s4,$FFFF       // X_REG = S_REG (16-Bit)
  TestNZ16(s1)           // Test Result Negative / Zero Flags Of X_REG (16-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $BB TYX                     Transfer Index Register Y To X
  andi s1,s2,$FFFF       // X_REG = Y_REG (16-Bit)
  TestNZ16(s1)           // Test Result Negative / Zero Flags Of X_REG (16-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $BC LDY   nnnn,X            Load Index Register Y From Memory Absolute Indexed, X
  LoadABSX16(s2)         // Y_REG = Absolute Indexed, X (16-Bit)
  TestNZ16(s2)           // Test Result Negative / Zero Flags Of Y_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $BD LDA   nnnn,X            Load Accumulator From Memory Absolute Indexed, X
  LoadABSX16(s0)         // A_REG = Absolute Indexed, X (16-Bit)
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $BE LDX   nnnn,Y            Load Index Register X From Memory Absolute Indexed, Y
  LoadABSY16(s1)         // X_REG = Absolute Indexed, Y (16-Bit)
  TestNZ16(s1)           // Test Result Negative / Zero Flags Of X_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $BF LDA   nnnnnn,X          Load Accumulator From Memory Absolute Long Indexed, X
  LoadABSLX16(s0)        // A_REG = Absolute Long Indexed, X (16-Bit)
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of A_REG (16-Bit)
  addiu s3,3             // PC_REG += 3 (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

align(256)
  // $C0 CPY   #nnnn             Compare Index Register Y With Memory Immediate
  LoadIMM16(t0)          // T0 = Immediate (16-Bit)
  TestNZCCMP16(s2)       // Test Result Negative / Zero / Carry Flags Of Y_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $C1 CMP   (dp,X)            Compare Accumulator With Memory Direct Page Indexed Indirect, X
  LoadDPIX16(t0)         // T0 = DP Indexed Indirect, X (16-Bit)
  TestNZCCMP16(s0)       // Test Result Negative / Zero / Carry Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

align(256)
  // $C2 REP   #nn               Reset Status Bits
  REPNAT()               // P_REG: Immediate Flags Reset (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $C3 CMP   sr,S              Compare Accumulator With Memory Stack Relative
  LoadSR16(t0)           // T0 = SR (16-Bit)
  TestNZCCMP16(s0)       // Test Result Negative / Zero / Carry Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $C4 CPY   dp                Compare Index Register Y With Memory Direct Page
  LoadDP16(t0)           // T0 = DP (16-Bit)
  TestNZCCMP16(s2)       // Test Result Negative / Zero / Carry Flags Of Y_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $C5 CMP   dp                Compare Accumulator With Memory Direct Page
  LoadDP16(t0)           // T0 = DP (16-Bit)
  TestNZCCMP16(s0)       // Test Result Negative / Zero / Carry Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
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

align(256)
  // $C7 CMP   [dp]              Compare Accumulator With Memory Direct Page Indirect Long
  LoadDPIL16(t0)         // T0 = DP Indirect Long (16-Bit)
  TestNZCCMP16(s0)       // Test Result Negative / Zero / Carry Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

align(256)
  // $C8 INY                     Increment Index Register Y
  addiu s2,1             // Y_REG++ (16-Bit)
  andi s2,$FFFF          // Y_REG = 16-Bit
  TestNZ16(s2)           // Test Result Negative / Zero Flags Of Y_REG (16-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $C9 CMP   #nnnn             Compare Accumulator With Memory Immediate
  LoadIMM16(t0)          // T0 = Immediate (16-Bit)
  TestNZCCMP16(s0)       // Test Result Negative / Zero / Carry Flags Of A_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $CA DEX                     Decrement Index Register X
  subiu s1,1             // X_REG-- (16-Bit)
  andi s1,$FFFF          // X_REG = 16-Bit
  TestNZ16(s1)           // Test Result Negative / Zero Flags Of X_REG (16-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $CB ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $CC CPY   nnnn              Compare Index Register Y With Memory Absolute
  LoadABS16(t0)          // T0 = Absolute (16-Bit)
  TestNZCCMP16(s2)       // Test Result Negative / Zero / Carry Flags Of Y_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $CD CMP   nnnn              Compare Accumulator With Memory Absolute
  LoadABS16(t0)          // T0 = Absolute (16-Bit)
  TestNZCCMP16(s0)       // Test Result Negative / Zero / Carry Flags Of A_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
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

align(256)
  // $CF CMP   nnnnnn            Compare Accumulator With Memory Absolute Long
  LoadABSL16(t0)         // T0 = Absolute Long (16-Bit)
  TestNZCCMP16(s0)       // Test Result Negative / Zero / Carry Flags Of A_REG (16-Bit)
  addiu s3,3             // PC_REG += 3 (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

align(256)
  // $D0 BNE   nn                Branch IF Not Equal
  BranchCLR(Z_FLAG)      // IF (Z Flag == 0) Branch, ELSE Continue
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $D1 CMP   (dp),Y            Compare Accumulator With Memory Direct Page Indirect Indexed, Y
  LoadDPIY16(t0)         // T0 = DP Indirect Indexed, Y (16-Bit)
  TestNZCCMP16(s0)       // Test Result Negative / Zero / Carry Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

align(256)
  // $D2 CMP   (dp)              Compare Accumulator With Memory Direct Page Indirect
  LoadDPI16(t0)          // T0 = DP Indirect (16-Bit)
  TestNZCCMP16(s0)       // Test Result Negative / Zero / Carry Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

align(256)
  // $D3 CMP   (sr,S),Y          Compare Accumulator With Memory Stack Relative Indirect Indexed, Y
  LoadSRIY16(t0)         // T0 = SR Indirect Indexed, Y (16-Bit)
  TestNZCCMP16(s0)       // Test Result Negative / Zero / Carry Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,8             // Cycles += 8 (Delay Slot)

align(256)
  // $D4 PEI   (dp)              Push Effective Indirect Address
  PushEI16()             // STACK = Effective Indirect Address (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

align(256)
  // $D5 CMP   dp,X              Compare Accumulator With Memory Direct Page Indexed, X
  LoadDPX16(t0)          // T0 = DP Indexed, X (16-Bit)
  TestNZCCMP16(s0)       // Test Result Negative / Zero / Carry Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
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

align(256)
  // $D7 CMP   [dp],Y            Compare Accumulator With Memory Direct Page Indirect Long Indexed, Y
  LoadDPILY16(t0)        // T0 = DP Indirect Long Indexed, Y (16-Bit)
  TestNZCCMP16(s0)       // Test Result Negative / Zero / Carry Flags Of A_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

align(256)
  // $D8 CLD                     Clear Decimal Mode Flag
  andi s5,~D_FLAG        // P_REG: D Flag Reset
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $D9 CMP   nnnn,Y            Compare Accumulator With Memory Absolute Indexed, Y
  LoadABSY16(t0)         // T0 = Absolute Indexed, Y (16-Bit)
  TestNZCCMP16(s0)       // Test Result Negative / Zero / Carry Flags Of A_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $DA PHX                     Push Index Register X
  PushNAT16(s1)          // STACK = X_REG (16-Bit)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $DB ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $DC JML   (nnnn)            Jump Absolute Indirect Long
  JumpABSI16()           // PC_REG = Absolute Indirect (16-Bit)
  lbu s8,2(a2)           // PB_REG = Bank Address (8-Bit)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

align(256)
  // $DD CMP   nnnn,X            Compare Accumulator With Memory Absolute Indexed, X
  LoadABSX16(t0)         // T0 = Absolute Indexed, X (16-Bit)
  TestNZCCMP16(s0)       // Test Result Negative / Zero / Carry Flags Of A_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
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

align(256)
  // $DF CMP   nnnnnn,X          Compare Accumulator With Memory Absolute Long Indexed, X
  LoadABSLX16(t0)        // T0 = Absolute Long Indexed, X (16-Bit)
  TestNZCCMP16(s0)       // Test Result Negative / Zero / Carry Flags Of A_REG (16-Bit)
  addiu s3,3             // PC_REG += 3 (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

align(256)
  // $E0 CPX   #nnnn             Compare Index Register X With Memory Immediate
  LoadIMM16(t0)          // T0 = Immediate (16-Bit)
  TestNZCCMP16(s1)       // Test Result Negative / Zero / Carry Flags Of X_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $E1 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $E2 SEP   #nn               Set Status Bits
  SEPNAT()               // P_REG: Immediate Flags Set (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $E3 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $E4 CPX   dp                Compare Index Register X With Memory Direct Page
  LoadDP16(t0)           // T0 = DP (16-Bit)
  TestNZCCMP16(s1)       // Test Result Negative / Zero / Carry Flags Of X_REG (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $E5 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
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

align(256)
  // $E7 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $E8 INX                     Increment Index Register X
  addiu s1,1             // X_REG++ (16-Bit)
  andi s1,$FFFF          // X_REG = 16-Bit
  TestNZ16(s1)           // Test Result Negative / Zero Flags Of X_REG (16-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $E9 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $EA NOP                     No Operation
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $EB XBA                     Exchange The B & A Accumulators
  andi t1,s0,$FF         // T1 = A_REG (8-Bit)
  sll t1,8               // T1 = B_REG (8-Bit)
  srl t0,s0,8            // T0 = A_REG (8-Bit)
  or s0,t1,t0            // A_REG = B_REG  (8-Bit) / B_REG = A_REG (8-Bit)
  TestNZ8(t0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $EC CPX   nnnn              Compare Index Register X With Memory Absolute
  LoadABS16(t0)          // T0 = Absolute (16-Bit)
  TestNZCCMP16(s1)       // Test Result Negative / Zero / Carry Flags Of X_REG (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $ED ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
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

align(256)
  // $EF ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $F0 BEQ   nn                Branch IF Equal
  BranchSET(Z_FLAG)      // IF (Z Flag != 0) Branch, ELSE Continue
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $F1 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $F2 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $F3 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $F4 PEA   nnnn              Push Effective Absolute Address
  PushEA16()             // STACK = Effective Absolute Address (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $F5 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
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

align(256)
  // $F7 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $F8 SED                     Set Decimal Mode Flag
  ori s5,D_FLAG          // P_REG: D Flag Set
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $F9 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $FA PLX                     Pull Index Register X From Stack
  PullNAT16(s1)          // X_REG = STACK (16-Bit)
  TestNZ16(s1)           // Test Result Negative / Zero Flags Of X_REG (16-Bit)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $FB XCE                     Exchange Carry & Emulation Bits
  XCE()                  // P_REG: C Flag = E Flag / E Flag = C Flag
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $FC JSR   (nnnn,X)          Jump To Subroutine Absolute Indexed Indirect
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  PushNAT16(s3)          // STACK = PC_REG (16-Bit)
  JumpABSIX16()          // PC_REG = Absolute Indexed Indirect
  jr ra
  addiu v0,8             // Cycles += 8 (Delay Slot)

align(256)
  // $FD ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
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

align(256)
  // $FF ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)