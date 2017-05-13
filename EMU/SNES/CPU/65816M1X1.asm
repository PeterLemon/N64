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
  // $01 ORA   (dp+X)            Logical OR Value From Indirect Absolute Address In Direct Page Offset Added With Value X With A
  lbu t0,1(a2)           // DPXI = MEM_MAP[MEM_MAP[Immediate + X_REG + D_REG]]
  addu t0,s1             // T0 = Immediate + X_REG
  addu t0,s6             // T0 = Immediate + X_REG + D_REG
  addu a2,a0,t0          // A2 = MEM_MAP + Immediate + X_REG + D_REG
  lbu t0,0(a2)
  lbu t1,1(a2)
  sll t1,8
  or t0,t1               // T0 = MEM_MAP[Immediate + X_REG + D_REG]
  addu a2,a0,t0          // A2 = MEM_MAP + MEM_MAP[Immediate + X_REG + D_REG]
  lbu t0,0(a2)           // T0 = DPXI
  or s0,t0               // A_REG |= DPXI
  andi t0,s0,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,ORADPXIM1X1    // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  ORADPXIM1X1:
  addiu s3,1             // PC_REG++
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

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
  // $03 ORA   sr,S              Logical OR Value From Stack Relative Offset Added With Value S With A
  lbu t0,1(a2)           // SRS = MEM_MAP[Immediate + S_REG]
  addu t0,s4             // T0 = Immediate + S_REG
  addu a2,a0,t0          // A2 = MEM_MAP + Immediate + S_REG
  lbu t0,0(a2)           // T0 = SRS
  or s0,t0               // A_REG |= SRS
  andi t0,s0,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,ORASRSM1X1     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  ORASRSM1X1:
  addiu s3,1             // PC_REG++
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $04 TSB   dp                Test & Set Bits In Direct Page Offset With A
  lbu t0,1(a2)           // DP = MEM_MAP[Immediate + D_REG]
  addu t0,s6             // T0 = Immediate + D_REG
  addu a2,a0,t0          // A2 = MEM_MAP + Immediate + D_REG
  lbu t0,0(a2)           // T0 = DP
  or t1,t0,s0            // Set & Store Bits
  sb t1,0(a2)
  and t0,s0              // Test DP AND Accumulator
  beqz t0,TSBDPM1X1      // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  TSBDPM1X1:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $05 ORA   dp                Logical OR Value In Direct Page Offset With A
  lbu t0,1(a2)           // DP = MEM_MAP[Immediate + D_REG]
  addu t0,s6             // T0 = Immediate + D_REG
  addu a2,a0,t0          // A2 = MEM_MAP + Immediate + D_REG
  lbu t0,0(a2)           // T0 = DP
  or s0,t0               // A_REG |= DP
  andi t0,s0,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,ORADPM1X1      // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  ORADPM1X1:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $06 ASL   dp                Arithmetic Shift Left Value In Direct Page Offset Into Carry Flag
  lbu t0,1(a2)           // DP = MEM_MAP[Immediate + D_REG]
  addu t0,s6             // T0 = Immediate + D_REG
  addu a2,a0,t0          // A2 = MEM_MAP + Immediate + D_REG
  lbu t0,0(a2)           // T0 = DP
  andi t1,t0,$80         // C Flag Set To Old MSB
  srl t1,7
  andi s5,~C_FLAG        // P_REG: C Flag Reset
  or s5,t1               // P_REG: C Flag = Old MSB
  sll t0,1               // DP <<= 1
  andi t0,$FF
  sb t0,0(a2)            // Store DP
  andi t1,t0,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t1               // P_REG: N Flag = Result MSB
  beqz t0,ASLDPM1X1      // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  ASLDPM1X1:
  addiu s3,1             // PC_REG++
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $07 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $08 PHP                     Push Processor Status Register
  addu a2,a0,s4          // STACK = P_REG (8-Bit)
  sb s5,0(a2)
  subiu s4,1             // S_REG-- (Decrement Stack)
  andi s4,$FFFF
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $09 ORA   #nn               OR Accumulator With Memory Immediate
  addu a2,a0,s3          // A_REG: OR With 8-Bit Immediate
  lbu t0,0(a2)
  or s0,t0
  andi t0,s0,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,ORAIMMM1X1     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  ORAIMMM1X1:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $0A ASL A                   Shift Accumulator Left
  sll s0,1               // A_REG: << 1 (8-Bit)
  andi t0,s0,$80         // Test Negative MSB / Carry
  srl t1,s0,8
  or t0,t1
  andi s5,~(N_FLAG+C_FLAG) // P_REG: N/C Flag Reset
  or s5,t0               // P_REG: N/C Flag = Result MSB / Carry
  andi s0,$FF
  beqz s0,ASLAM1X1       // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  ASLAM1X1:
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $0B PHD                     Push Direct Page Register
  addu a2,a0,s4          // STACK = D_REG (16-Bit)
  sb s6,-1(a2)
  srl t0,s6,8
  sb t0,0(a2)
  subiu s4,2             // S_REG -= 2 (Decrement Stack)
  andi s4,$FFFF
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $0C TSB   nnnn              Test & Set Memory Bits Against Accumulator Absolute
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // Load DB_REG:MEM (8-Bit)
  sll t0,s7,16
  addu a2,t0
  lbu t0,0(a2)
  or t1,t0,s0            // Set & Store Bits (8-Bit)
  sb t1,0(a2)
  and t0,s0              // Result AND Accumulator
  beqz t0,TSBABSM1X1     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  TSBABSM1X1:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

align(256)
  // $0D ORA   nnnn              OR Accumulator With Memory Absolute
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // A_REG: OR With DB_REG:MEM (8-Bit)
  sll t0,s7,16
  addu a2,t0
  lbu t0,0(a2)
  or s0,t0
  andi t0,s0,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,ORAABSM1X1     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  ORAABSM1X1:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $0E ASL   nnnn              Shift Memory Left Absolute
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // Load DB_REG:MEM (8-Bit)
  sll t0,s7,16
  addu a2,t0
  lbu t0,0(a2)
  sll t0,1               // DB_REG:MEM: << 1 & Store Bits (8-Bit)
  sb t0,0(a2)
  andi t1,t0,$80         // Test Negative MSB / Carry
  srl t2,t0,8
  or t1,t2
  andi s5,~(N_FLAG+C_FLAG) // P_REG: N/C Flag Reset
  or s5,t1               // P_REG: N/C Flag = Result MSB / Carry
  andi t0,$FF
  beqz t0,ASLABSM1X1     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  ASLABSM1X1:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

align(256)
  // $0F ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $10 BPL   nn                Branch IF Plus
  andi t0,s5,N_FLAG      // P_REG: Test N Flag
  bnez t0,BPLM1X1        // IF (N Flag != 0) Minus
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  addu a2,a0,s3          // Load Signed 8-Bit Relative Address
  lb t0,-1(a2)
  add s3,t0              // PC_REG: Set To 8-Bit Relative Address
  addiu v0,1             // Cycles++
  BPLM1X1:
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $11 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $12 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $13 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $14 TRB   nn                Test & Reset Memory Bits Against Accumulator Direct Page
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // Load D_REG+MEM (8-Bit)
  addu a2,s6
  lbu t0,0(a2)
  xori t1,s0,$FFFF       // Reset & Store Bits (8-Bit)
  and t1,t0
  sb t1,0(a2)
  and t0,s0              // Result AND Accumulator
  beqz t0,TRBDPM1X1      // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  TRBDPM1X1:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $15 ORA   nn,X              OR Accumulator With Memory Direct Page Indexed, X
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // A_REG: OR With D_REG+MEM+X_REG (8-Bit)
  addu a2,s6
  addu a2,s1
  lbu t0,0(a2)
  or s0,t0
  andi t0,s0,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,ORADPXM1X1     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  ORADPXM1X1:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $16 ASL   nn,X              Shift Memory Left Direct Page Indexed, X
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // Load D_REG+MEM+X_REG (8-Bit)
  addu a2,s6
  addu a2,s1
  lbu t0,0(a2)
  sll t0,1               // D_REG+MEM+X_REG: << 1 & Store Bits (8-Bit)
  sb t0,0(a2)
  andi t1,t0,$80         // Test Negative MSB / Carry
  srl t2,t0,8
  or t1,t2
  andi s5,~(N_FLAG+C_FLAG) // P_REG: N/C Flag Reset
  or s5,t1               // P_REG: N/C Flag = Result MSB / Carry
  andi t0,$FF
  beqz t0,ASLDPXM1X1     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  ASLDPXM1X1:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

align(256)
  // $17 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $18 CLC                     Clear Carry Flag
  andi s5,~C_FLAG        // P_REG: C Flag Reset
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $19 ORA   nnnn,Y            OR Accumulator With Memory Absolute Indexed, Y
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // A_REG: OR With DB_REG:MEM+Y_REG (8-Bit)
  sll t0,s7,16
  addu a2,t0
  addu a2,s2
  lbu t0,0(a2)
  or s0,t0
  andi t0,s0,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,ORAABSYM1X1    // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  ORAABSYM1X1:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $1A INA                     Increment Accumulator
  addiu s0,1             // A_REG: Set To Accumulator++ (8-Bit)
  andi s0,$FF
  andi t0,s0,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,INAM1X1        // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  INAM1X1:
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $1B TCS                     Transfer Accumulator To Stack Pointer
  andi s4,s0,$FFFF       // S_REG: Set To Accumulator (16-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $1C TRB   nnnn              Test & Reset Memory Bits Against Accumulator Absolute
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // Load DB_REG:MEM (8-Bit)
  sll t0,s7,16
  addu a2,t0
  lbu t0,0(a2)
  xori t1,s0,$FF         // Reset & Store Bits (8-Bit)
  and t1,t0
  sb t1,0(a2)
  and t0,s0              // Result AND Accumulator
  beqz t0,TRBABSM1X1     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  TRBABSM1X1:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

align(256)
  // $1D ORA   nnnn,X            OR Accumulator With Memory Absolute Indexed, X
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // A_REG: OR With DB_REG:MEM+X_REG (8-Bit)
  sll t0,s7,16
  addu a2,t0
  addu a2,s1
  lbu t0,0(a2)
  or s0,t0
  andi t0,s0,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,ORAABSXM1X1    // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  ORAABSXM1X1:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $1E ASL   nnnn,X            Shift Memory Left Absolute Indexed, X
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // Load DB_REG:MEM+X_REG (8-Bit)
  sll t0,s7,16
  addu a2,t0
  addu a2,s1
  lbu t0,0(a2)
  sll t0,1               // DB_REG:MEM+X_REG: << 1 & Store Bits (8-Bit)
  sb t0,0(a2)
  andi t1,t0,$80         // Test Negative MSB / Carry
  srl t2,t0,8
  or t1,t2
  andi s5,~(N_FLAG+C_FLAG) // P_REG: N/C Flag Reset
  or s5,t1               // P_REG: N/C Flag = Result MSB / Carry
  andi t0,$FF
  beqz t0,ASLABSXM1X1    // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  ASLABSXM1X1:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

align(256)
  // $1F ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $20 JSR   nnnn              Jump To Subroutine Absolute
  addiu s3,1             // PC_REG++
  addu a2,a0,s4          // STACK = PC_REG (16-Bit)
  sb s3,-1(a2)
  srl t0,s3,8
  sb t0,0(a2)
  subiu s4,2             // S_REG -= 2 (Decrement Stack)
  andi s4,$FFFF
  addu a2,a0,s3          // PC_REG: Set To 16-Bit Absolute Address
  lbu t0,0(a2)
  sll t0,8
  lbu s3,-1(a2)
  or s3,t0
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

align(256)
  // $21 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $22 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $23 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $24 BIT   nn                Test Memory Bits Against Accumulator Direct Page
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // Load D_REG+MEM (8-Bit)
  addu a2,s6
  lbu t0,0(a2)
  andi t1,t0,$C0         // Test Negative MSB / Overflow MSB-1
  andi s5,~(N_FLAG+V_FLAG) // P_REG: N/V Flag Reset
  or s5,t1               // P_REG: N/V Flag = Result MSB/MSB-1
  and t0,s0              // Result AND Accumulator
  beqz t0,BITDPM1X1      // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  BITDPM1X1:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $25 AND   nn                AND Accumulator With Memory Direct Page
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // A_REG: AND With D_REG+MEM (8-Bit)
  addu a2,s6
  lbu t0,0(a2)
  and s0,t0
  andi t0,s0,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,ANDDPM1X1      // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  ANDDPM1X1:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $26 ROL   nn                Rotate Memory Left Direct Page
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // Load D_REG+MEM (8-Bit)
  addu a2,s6
  lbu t0,0(a2)
  sll t0,1               // D_REG+MEM: Rotate Left & Store Bits (8-Bit)
  andi t1,s5,C_FLAG
  or t0,t1
  sb t0,0(a2)
  andi t1,t0,$80         // Test Negative MSB / Carry
  srl t2,t0,8
  or t1,t2
  andi s5,~(N_FLAG+C_FLAG) // P_REG: N/C Flag Reset
  or s5,t1               // P_REG: N/C Flag = Result MSB / Carry
  andi t0,$FF
  beqz t0,ROLDPM1X1      // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  ROLDPM1X1:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $27 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $28 PLP                     Pull Status Flags
  addiu s4,1             // S_REG++ (Increment Stack)
  andi s4,$FFFF
  addu a2,a0,s4          // P_REG = STACK (8-Bit)
  lbu s5,0(a2)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $29 AND   #nn               AND Accumulator With Memory Immediate
  addu a2,a0,s3          // A_REG: AND With 8-Bit Immediate
  lbu t0,0(a2)
  and s0,t0
  andi t0,s0,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,ANDIMMM1X1     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  ANDIMMM1X1:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $2A ROL A                   Rotate Accumulator Left
  sll s0,1               // A_REG: Rotate Left (8-Bit)
  andi t0,s5,C_FLAG
  or s0,t0
  andi t0,s0,$80         // Test Negative MSB / Carry
  srl t1,s0,8
  or t0,t1
  andi s5,~(N_FLAG+C_FLAG) // P_REG: N/C Flag Reset
  or s5,t0               // P_REG: N/C Flag = Result MSB / Carry
  andi s0,$FF
  beqz s0,ROLAM1X1       // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  ROLAM1X1:
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $2B PLD                     Pull Direct Page Register
  addiu s4,2             // S_REG += 2 (Increment Stack)
  andi s4,$FFFF
  addu a2,a0,s4          // D_REG = STACK (16-Bit)
  lbu t0,0(a2)
  sll t0,8
  lbu s6,-1(a2)
  or s6,t0
  andi t0,s6,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s6,PLDM1X1        // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  PLDM1X1:
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $2C BIT   nnnn              Test Memory Bits Against Accumulator Absolute
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // Load DB_REG:MEM (8-Bit)
  sll t0,s7,16
  addu a2,t0
  lbu t0,0(a2)
  andi t1,t0,$C0         // Test Negative MSB / Overflow MSB-1
  andi s5,~(N_FLAG+V_FLAG) // P_REG: N/V Flag Reset
  or s5,t1               // P_REG: N/V Flag = Result MSB/MSB-1
  and t0,s0              // Result AND Accumulator
  beqz t0,BITABSM1X1     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  BITABSM1X1:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $2D AND   nnnn              AND Accumulator With Memory Absolute
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // A_REG: AND With DB_REG:MEM (8-Bit)
  sll t0,s7,16
  addu a2,t0
  lbu t0,0(a2)
  and s0,t0
  andi t0,s0,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,ANDABSM1X1     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  ANDABSM1X1:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $2E ROL   nnnn              Rotate Memory Left Absolute
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // Load DB_REG:MEM (8-Bit)
  sll t0,s7,16
  addu a2,t0
  lbu t0,0(a2)
  sll t0,1               // DB_REG:MEM: Rotate Left & Store Bits (8-Bit)
  andi t1,s5,C_FLAG
  or t0,t1
  sb t0,0(a2)
  andi t1,t0,$80         // Test Negative MSB / Carry
  srl t2,t0,8
  or t1,t2
  andi s5,~(N_FLAG+C_FLAG) // P_REG: N/C Flag Reset
  or s5,t1               // P_REG: N/C Flag = Result MSB / Carry
  andi t0,$FF
  beqz t0,ROLABSM1X1     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  ROLABSM1X1:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

align(256)
  // $2F ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $30 BMI   nn                Branch IF Minus
  andi t0,s5,N_FLAG      // P_REG: Test N Flag
  beqz t0,BMIM1X1        // IF (N Flag == 0) Plus
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  addu a2,a0,s3          // Load Signed 8-Bit Relative Address
  lb t0,-1(a2)
  add s3,t0              // PC_REG: Set To 8-Bit Relative Address
  addiu v0,1             // Cycles++
  BMIM1X1:
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $31 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $32 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $33 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $34 BIT   nn,X              Test Memory Bits Against Accumulator Direct Page Indexed, X
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // Load D_REG+MEM+X_REG (8-Bit)
  addu a2,s6
  addu a2,s1
  lbu t0,0(a2)
  andi t1,t0,$C0         // Test Negative MSB / Overflow MSB-1
  andi s5,~(N_FLAG+V_FLAG) // P_REG: N/V Flag Reset
  or s5,t1               // P_REG: N/V Flag = Result MSB/MSB-1
  and t0,s0              // Result AND Accumulator
  beqz t0,BITDPXM1X1     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  BITDPXM1X1:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $35 AND   nn,X              AND Accumulator With Memory Direct Page Indexed, X
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // A_REG: AND With D_REG+MEM+X_REG (8-Bit)
  addu a2,s6
  addu a2,s1
  lbu t0,0(a2)
  and s0,t0
  andi t0,s0,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,ANDDPXM1X1     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  ANDDPXM1X1:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $36 ROL   nn,X              Rotate Memory Left Direct Page Indexed, X
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // Load D_REG+MEM+X_REG (8-Bit)
  addu a2,s6
  addu a2,s1
  lbu t0,0(a2)
  sll t0,1               // D_REG+MEM+X_REG: Rotate Left & Store Bits (8-Bit)
  andi t1,s5,C_FLAG
  or t0,t1
  sb t0,0(a2)
  andi t1,t0,$80         // Test Negative MSB / Carry
  srl t2,t0,8
  or t1,t2
  andi s5,~(N_FLAG+C_FLAG) // P_REG: N/C Flag Reset
  or s5,t1               // P_REG: N/C Flag = Result MSB / Carry
  andi t0,$FF
  beqz t0,ROLDPXM1X1     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  ROLDPXM1X1:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

align(256)
  // $37 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $38 SEC                     Set Carry Flag
  ori s5,C_FLAG          // P_REG: C Flag Set
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $39 AND   nnnn,Y            AND Accumulator With Memory Absolute Indexed, Y
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // A_REG: AND With DB_REG:MEM+Y_REG (8-Bit)
  sll t0,s7,16
  addu a2,t0
  addu a2,s2
  lbu t0,0(a2)
  and s0,t0
  andi t0,s0,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,ANDABSYM1X1    // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  ANDABSYM1X1:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $3A DEA                     Decrement Accumulator
  subiu s0,1             // A_REG: Set To Accumulator-- (8-Bit)
  andi s0,$FF
  andi t0,s0,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,DEAM1X1        // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  DEAM1X1:
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $3B TSC                     Transfer Stack Pointer To 16-Bit Accumulator
  andi s0,s4,$FFFF       // A_REG: Set To Stack Pointer (16-Bit)
  andi t0,s0,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,TSCM1X1        // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  TSCM1X1:
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $3C BIT   nnnn,X            Test Memory Bits Against Accumulator Absolute Indexed, X
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // Load DB_REG:MEM+X_REG (8-Bit)
  sll t0,s7,16
  addu a2,t0
  addu a2,s1
  lbu t0,0(a2)
  andi t1,t0,$C0         // Test Negative MSB / Overflow MSB-1
  andi s5,~(N_FLAG+V_FLAG) // P_REG: N/V Flag Reset
  or s5,t1               // P_REG: N/V Flag = Result MSB/MSB-1
  and t0,s0              // Result AND Accumulator
  beqz t0,BITABSXM1X1    // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  BITABSXM1X1:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $3D AND   nnnn,X            AND Accumulator With Memory Absolute Indexed, X
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // A_REG: AND With DB_REG:MEM+X_REG (8-Bit)
  sll t0,s7,16
  addu a2,t0
  addu a2,s1
  lbu t0,0(a2)
  and s0,t0
  andi t0,s0,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,ANDABSXM1X1    // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  ANDABSXM1X1:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $3E ROL   nnnn,X            Rotate Memory Left Absolute Indexed, X
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // Load DB_REG:MEM+X_REG (8-Bit)
  sll t0,s7,16
  addu a2,t0
  addu a2,s1
  lbu t0,0(a2)
  sll t0,1               // DB_REG:MEM+X_REG: Rotate Left & Store Bits (8-Bit)
  andi t1,s5,C_FLAG
  or t0,t1
  sb t0,0(a2)
  andi t1,t0,$80         // Test Negative MSB / Carry
  srl t2,t0,8
  or t1,t2
  andi s5,~(N_FLAG+C_FLAG) // P_REG: N/C Flag Reset
  or s5,t1               // P_REG: N/C Flag = Result MSB / Carry
  andi t0,$FF
  beqz t0,ROLABSXM1X1    // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  ROLABSXM1X1:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

align(256)
  // $3F ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $40 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $41 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $42 WDM   #nn               Reserved For Future Expansion
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $43 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $44 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $45 EOR   nn                Exclusive-OR Accumulator With Memory Direct Page
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // A_REG: Exclusive-OR With D_REG+MEM (8-Bit)
  addu a2,s6
  lbu t0,0(a2)
  xor s0,t0
  andi t0,s0,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,EORDPM1X1      // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  EORDPM1X1:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $46 LSR   nn                Logical Shift Memory Right Direct Page
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // Load D_REG+MEM (8-Bit)
  addu a2,s6
  lbu t0,0(a2)
  andi t1,t0,1           // Test Negative MSB / Carry
  andi s5,~(N_FLAG+C_FLAG) // P_REG: N/C Flag Reset
  or s5,t1               // P_REG: N/C Flag = Result MSB / Carry
  srl t0,1               // D_REG+MEM: >> 1 & Store Bits (8-Bit)
  sb t0,0(a2)
  beqz t0,LSRDPM1X1      // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  LSRDPM1X1:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $47 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $48 PHA                     Push Accumulator
  addu a2,a0,s4          // STACK = A_REG (8-Bit)
  sb s0,0(a2)
  subiu s4,1             // S_REG-- (Decrement Stack)
  andi s4,$FFFF
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $49 EOR   #nn               Exclusive-OR Accumulator With Memory Immediate
  addu a2,a0,s3          // A_REG: Exclusive-OR With 8-Bit Immediate
  lbu t0,0(a2)
  xor s0,t0
  andi t0,s0,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,EORIMMM1X1     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  EORIMMM1X1:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $4A LSR A                   Logical Shift Accumulator Right
  andi t0,s0,1           // Test Negative MSB / Carry
  andi s5,~(N_FLAG+C_FLAG) // P_REG: N/C Flag Reset
  or s5,t0               // P_REG: N/C Flag = Result MSB / Carry
  srl s0,1               // A_REG: >> 1 (8-Bit)
  beqz s0,LSRAM1X1       // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  LSRAM1X1:
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $4B PHK                     Push Program Bank Register
  addu a2,a0,s4          // STACK = PB_REG (8-Bit)
  sb s8,0(a2)
  subiu s4,1             // S_REG-- (Decrement Stack)
  andi s4,$FFFF
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $4C JMP   nnnn              Jump Absolute
  addu a2,a0,s3          // PC_REG: Set To 16-Bit Absolute Address
  lbu t0,1(a2)
  sll t0,8
  lbu s3,0(a2)
  or s3,t0
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $4D EOR   nnnn              Exclusive-OR Accumulator With Memory Absolute
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // A_REG: Exclusive-OR With DB_REG:MEM (8-Bit)
  sll t0,s7,16
  addu a2,t0
  lbu t0,0(a2)
  xor s0,t0
  andi t0,s0,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,EORABSM1X1     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  EORABSM1X1:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $4E LSR   nnnn              Logical Shift Memory Right Absolute
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // Load DB_REG:MEM (8-Bit)
  sll t0,s7,16
  addu a2,t0
  lbu t0,0(a2)
  andi t1,t0,1           // Test Negative MSB / Carry
  andi s5,~(N_FLAG+C_FLAG) // P_REG: N/C Flag Reset
  or s5,t1               // P_REG: N/C Flag = Result MSB / Carry
  srl t0,1               // DB_REG:MEM: >> 1 & Store Bits (8-Bit)
  sb t0,0(a2)
  beqz t0,LSRABSM1X1     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  LSRABSM1X1:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

align(256)
  // $4F ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $50 BVC   nn                Branch IF Overflow Clear
  andi t0,s5,V_FLAG      // P_REG: Test V Flag
  bnez t0,BVCM1X1        // IF (V Flag != 0) Overflow Set
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  addu a2,a0,s3          // Load Signed 8-Bit Relative Address
  lb t0,-1(a2)
  add s3,t0              // PC_REG: Set To 8-Bit Relative Address
  addiu v0,1             // Cycles++
  BVCM1X1:
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $51 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $52 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $53 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $54 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $55 EOR   nn,X              Exclusive-OR Accumulator With Memory Direct Page Indexed, X
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // A_REG: Exclusive-OR With D_REG+MEM+X_REG (8-Bit)
  addu a2,s6
  addu a2,s1
  lbu t0,0(a2)
  xor s0,t0
  andi t0,s0,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,EORDPXM1X1     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  EORDPXM1X1:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $56 LSR   nn,X              Logical Shift Memory Right Direct Page Indexed, X
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // Load D_REG+MEM+X_REG (8-Bit)
  addu a2,s6
  addu a2,s1
  lbu t0,0(a2)
  andi t1,t0,1           // Test Negative MSB / Carry
  andi s5,~(N_FLAG+C_FLAG) // P_REG: N/C Flag Reset
  or s5,t1               // P_REG: N/C Flag = Result MSB / Carry
  srl t0,1               // D_REG+MEM+X_REG: >> 1 & Store Bits (8-Bit)
  sb t0,0(a2)
  beqz t0,LSRDPXM1X1     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  LSRDPXM1X1:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

align(256)
  // $57 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $58 CLI                     Clear Interrupt Disable Flag
  andi s5,~I_FLAG        // P_REG: I Flag Reset
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $59 EOR   nnnn,Y            Exclusive-OR Accumulator With Memory Absolute Indexed, Y
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // A_REG: Exclusive-OR With DB_REG:MEM+Y_REG (8-Bit)
  sll t0,s7,16
  addu a2,t0
  addu a2,s2
  lbu t0,0(a2)
  xor s0,t0
  andi t0,s0,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,EORABSYM1X1    // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  EORABSYM1X1:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $5A PHY                     Push Index Register Y
  addu a2,a0,s4          // STACK = Y_REG (8-Bit)
  sb s2,0(a2)
  subiu s4,1             // S_REG-- (Decrement Stack)
  andi s4,$FFFF
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $5B TCD                     Transfer 16-Bit Accumulator To Direct Page Register
  andi s6,s0,$FFFF       // D_REG: Set To 16-Bit Accumulator (16-Bit)
  andi t0,s6,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s6,TCDM1X1        // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  TCDM1X1:
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $5C JML   nnnnnn            Jump Absolute Long
  addu a2,a0,s3          // PC_REG: Set To 16-Bit Absolute Address
  lbu t0,1(a2)
  sll t0,8
  lbu s3,0(a2)
  or s3,t0
  lbu s8,2(a2)           // PB_REG: Set To Long Bank Address
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $5D EOR   nnnn,X            Exclusive-OR Accumulator With Memory Absolute Indexed, X
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // A_REG: Exclusive-OR With DB_REG:MEM+X_REG (8-Bit)
  sll t0,s7,16
  addu a2,t0
  addu a2,s1
  lbu t0,0(a2)
  xor s0,t0
  andi t0,s0,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,EORABSXM1X1    // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  EORABSXM1X1:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $5E LSR   nnnn,X            Logical Shift Memory Right Absolute Indexed, X
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // Load DB_REG:MEM+X_REG (8-Bit)
  sll t0,s7,16
  addu a2,t0
  addu a2,s1
  lbu t0,0(a2)
  andi t1,t0,1           // Test Negative MSB / Carry
  andi s5,~(N_FLAG+C_FLAG) // P_REG: N/C Flag Reset
  or s5,t1               // P_REG: N/C Flag = Result MSB / Carry
  srl t0,1               // DB_REG:MEM+X_REG: >> 1 & Store Bits (8-Bit)
  sb t0,0(a2)
  beqz t0,LSRABSXM1X1    // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  LSRABSXM1X1:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

align(256)
  // $5F ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

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
  addu a2,a0,s3          // Load Signed 16-Bit Relative Address
  lb t0,-1(a2)
  sll t0,8
  lbu t1,-2(a2)
  or t0,t1
  add t0,s3,t0           // Load 16-Bit Effective PC Relative Indirect Address
  addu a2,a0,s4          // STACK = Effective PC Relative Indirect Address (16-Bit)
  sb t0,-1(a2)
  srl t0,8
  sb t0,0(a2)
  subiu s4,2             // S_REG -= 2 (Decrement Stack)
  andi s4,$FFFF
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

align(256)
  // $63 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $64 STZ   nn                Store Zero To Memory Direct Page
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // D_REG+MEM: Set To Zero (8-Bit)
  addu a2,s6
  sb r0,0(a2)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $65 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $66 ROR   nn                Rotate Memory Right Direct Page
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // Load D_REG+MEM (8-Bit)
  addu a2,s6
  lbu t0,0(a2)
  andi t1,t0,1           // Test Negative MSB / Carry
  andi t2,s5,C_FLAG
  sll t2,7
  or t1,t2
  andi s5,~(N_FLAG+C_FLAG) // P_REG: N/C Flag Reset
  or s5,t1               // P_REG: N/C Flag = Result MSB / Carry
  srl t0,1               // D_REG+MEM: Rotate Right & Store Bits (8-Bit)
  or t0,t2
  sb t0,0(a2)
  beqz t0,RORDPM1X1      // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  RORDPM1X1:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $67 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $68 PLA                     Pull Accumulator
  addiu s4,1             // S_REG++ (Increment Stack)
  andi s4,$FFFF
  addu a2,a0,s4          // A_REG = STACK (8-Bit)
  lbu s0,0(a2)
  andi t0,s0,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,PLAM1X1        // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  PLAM1X1:
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $69 ADC   #nn               Add With Carry Accumulator With Memory Immediate
  addu a2,a0,s3          // A_REG: Add With Carry With 8-Bit Immediate
  lbu t0,0(a2)
  addu s0,t0
  andi t0,s5,C_FLAG
  addu s0,t0
  andi t0,s0,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  andi t0,s0,$0180       // Test Signed Overflow
  ori t1,r0,$0180
  beq t0,t1,ADCIMMM1X1V  // IF (Signed Overflow) V Flag Set
  ori s5,V_FLAG          // P_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG        // P_REG: V Flag Reset
  ADCIMMM1X1V:
  ori t1,r0,$0100        // Test Unsigned Overflow
  beq t0,t1,ADCIMMM1X1C  // IF (Unsigned Overflow) C Flag Set
  ori s5,C_FLAG          // P_REG: C Flag Set (Delay Slot)
  andi s5,~C_FLAG        // P_REG: C Flag Reset
  ADCIMMM1X1C:
  andi s0,$FF
  beqz s0,ADCIMMM1X1Z    // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  ADCIMMM1X1Z:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $6A ROR A                   Rotate Accumulator Right
  andi t0,s0,1           // Test Negative MSB / Carry
  andi t1,s5,C_FLAG
  sll t1,7
  or t0,t1
  andi s5,~(N_FLAG+C_FLAG) // P_REG: N/C Flag Reset
  or s5,t0               // P_REG: N/C Flag = Result MSB / Carry
  srl s0,1               // A_REG: Rotate Right (8-Bit)
  or s0,t1
  beqz s0,RORAM1X1       // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  RORAM1X1:
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $6B ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $6C ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $6D ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $6E ROR   nnnn              Rotate Memory Right Absolute
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // Load DB_REG:MEM (8-Bit)
  sll t0,s7,16
  addu a2,t0
  lbu t0,0(a2)
  andi t1,t0,1           // Test Negative MSB / Carry
  andi t2,s5,C_FLAG
  sll t2,7
  or t1,t2
  andi s5,~(N_FLAG+C_FLAG) // P_REG: N/C Flag Reset
  or s5,t1               // P_REG: N/C Flag = Result MSB / Carry
  srl t0,1               // DB_REG:MEM: Rotate Right & Store Bits (8-Bit)
  or t0,t2
  sb t0,0(a2)
  beqz t0,RORABSM1X1     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  RORABSM1X1:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

align(256)
  // $6F ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $70 BVS   nn                Branch IF Overflow Set
  andi t0,s5,V_FLAG      // P_REG: Test V Flag
  beqz t0,BVSM1X1        // IF (V Flag == 0) Overflow Clear
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  addu a2,a0,s3          // Load Signed 8-Bit Relative Address
  lb t0,-1(a2)
  add s3,t0              // PC_REG: Set To 8-Bit Relative Address
  addiu v0,1             // Cycles++
  BVSM1X1:
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
  // $74 STZ   nn,X              Store Zero To Memory Direct Page Indexed, X
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu t0,s1
  addu a2,a0,t0          // D_REG+MEM+X_REG: Set To Zero (8-Bit)
  addu a2,s6
  sb r0,0(a2)

  la sp,StoreByte        // Store Byte
  jalr sp,sp
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)

  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $75 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $76 ROR   nn,X              Rotate Memory Right Direct Page Indexed, X
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // Load D_REG+MEM+X_REG (8-Bit)
  addu a2,s6
  addu a2,s1
  lbu t0,0(a2)
  andi t1,t0,1           // Test Negative MSB / Carry
  andi t2,s5,C_FLAG
  sll t2,7
  or t1,t2
  andi s5,~(N_FLAG+C_FLAG) // P_REG: N/C Flag Reset
  or s5,t1               // P_REG: N/C Flag = Result MSB / Carry
  srl t0,1               // D_REG+MEM+X_REG: Rotate Right & Store Bits (8-Bit)
  or t0,t2
  sb t0,0(a2)
  beqz t0,RORDPXM1X1     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  RORDPXM1X1:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

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
  addiu s4,1             // S_REG++ (Increment Stack)
  andi s4,$FFFF
  addu a2,a0,s4          // Y_REG = STACK (8-Bit)
  lbu s2,0(a2)
  andi t0,s2,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s2,PLYM1X1        // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  PLYM1X1:
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $7B TDC                     Transfer Direct Page Register To 16-Bit Accumulator
  andi s0,s6,$FFFF       // A_REG: Set To Direct Page Register (16-Bit)
  andi t0,s0,$8000       // Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,TDCM1X1        // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  TDCM1X1:
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $7C ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $7D ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $7E ROR   nnnn,X            Rotate Memory Right Absolute Indexed, X
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // Load DB_REG:MEM+X_REG (8-Bit)
  sll t0,s7,16
  addu a2,t0
  addu a2,s1
  lbu t0,0(a2)
  andi t1,t0,1           // Test Negative MSB / Carry
  andi t2,s5,C_FLAG
  sll t2,7
  or t1,t2
  andi s5,~(N_FLAG+C_FLAG) // P_REG: N/C Flag Reset
  or s5,t1               // P_REG: N/C Flag = Result MSB / Carry
  srl t0,1               // DB_REG:MEM+X_REG: Rotate Right & Store Bits (8-Bit)
  or t0,t2
  sb t0,0(a2)
  beqz t0,RORABSXM1X1    // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  RORABSXM1X1:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

align(256)
  // $7F ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $80 BRA   nn                Branch Always
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  addu a2,a0,s3          // Load Signed 8-Bit Relative Address
  lb t0,-1(a2)
  add s3,t0              // PC_REG: Set To 8-Bit Relative Address
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $81 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $82 BRL   nnnn              Branch Always Long
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  addu a2,a0,s3          // Load Signed 16-Bit Relative Address
  lb t0,-1(a2)
  sll t0,8
  lbu t1,-2(a2)
  or t0,t1
  add s3,t0              // PC_REG: Set To 16-Bit Relative Address
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $83 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $84 STY   nn                Store Index Register Y To Memory Direct Page
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // D_REG+MEM: Set To Index Register Y (8-Bit)
  addu a2,s6
  sb s2,0(a2)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $85 STA   nn                Store Accumulator To Memory Direct Page
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // D_REG+MEM: Set To Accumulator (8-Bit)
  addu a2,s6
  sb s0,0(a2)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $86 STX   nn                Store Index Register X To Memory Direct Page
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // D_REG+MEM: Set To Index Register X (8-Bit)
  addu a2,s6
  sb s1,0(a2)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $87 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $88 DEY                     Decrement Index Register Y
  subiu s2,1             // Y_REG: Set To Index Register Y-- (8-Bit)
  andi s2,$FF
  andi t0,s2,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s2,DEYM1X1        // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  DEYM1X1:
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $89 BIT   #nn               Test Memory Bits Against Accumulator Immediate
  addu a2,a0,s3          // Load 8-Bit Immediate
  lbu t0,0(a2)
  and t0,s0              // Test Result AND Accumulator
  beqz t0,BITIMMM1X1     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  BITIMMM1X1:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $8A TXA                     Transfer Index Register X To Accumulator
  andi s0,s1,$FF         // A_REG: Set To Index Register X (8-Bit)
  andi t0,s0,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,TXAM1X1        // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  TXAM1X1:
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $8B PHB                     Push Data Bank Register
  addu a2,a0,s4          // STACK = DB_REG (8-Bit)
  sb s7,0(a2)
  subiu s4,1             // S_REG-- (Decrement Stack)
  andi s4,$FFFF
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $8C STY   nnnn              Store Index Register Y To Memory Absolute
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // DB_REG:MEM: Set To Index Register Y (8-Bit)
  sll t1,s7,16
  addu a2,t1
  sb s2,0(a2)

  la sp,StoreByte        // Store Byte
  jalr sp,sp
  addiu s3,2             // PC_REG += 2 (Increment Program Counter) (Delay Slot)

  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $8D STA   nnnn              Store Accumulator To Memory Absolute
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // DB_REG:MEM: Set To Accumulator (8-Bit)
  sll t1,s7,16
  addu a2,t1
  sb s0,0(a2)

  la sp,StoreByte        // Store Byte
  jalr sp,sp
  addiu s3,2             // PC_REG += 2 (Increment Program Counter) (Delay Slot)

  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $8E STX   nnnn              Store Index Register X To Memory Absolute
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // DB_REG:MEM: Set To Index Register X (8-Bit)
  sll t1,s7,16
  addu a2,t1
  sb s1,0(a2)

  la sp,StoreByte        // Store Byte
  jalr sp,sp
  addiu s3,2             // PC_REG += 2 (Increment Program Counter) (Delay Slot)

  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $8F ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $90 BCC   nn                Branch IF Carry Clear
  andi t0,s5,C_FLAG      // P_REG: Test C Flag
  bnez t0,BCCM1X1        // IF (C Flag != 0) Carry Set
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  addu a2,a0,s3          // Load Signed 8-Bit Relative Address
  lb t0,-1(a2)
  add s3,t0              // PC_REG: Set To 8-Bit Relative Address
  addiu v0,1             // Cycles++
  BCCM1X1:
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $91 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $92 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $93 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $94 STY   nn,X              Store Index Register Y To Memory Direct Page Indexed, X
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu t0,s1
  addu a2,a0,t0          // D_REG+MEM+X_REG: Set To Index Register Y (8-Bit)
  addu a2,s6
  sb s2,0(a2)

  la sp,StoreByte        // Store Byte
  jalr sp,sp
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)

  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $95 STA   nn,X              Store Accumulator To Memory Direct Page Indexed, X
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu t0,s1
  addu a2,a0,t0          // D_REG+MEM+X_REG: Set To Accumulator (8-Bit)
  addu a2,s6
  sb s0,0(a2)

  la sp,StoreByte        // Store Byte
  jalr sp,sp
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)

  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $96 STX   nn,Y              Store Index Register X To Memory Direct Page Indexed, Y
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu t0,s2
  addu a2,a0,t0          // D_REG+MEM+Y_REG: Set To Index Register X (8-Bit)
  addu a2,s6
  sb s1,0(a2)

  la sp,StoreByte        // Store Byte
  jalr sp,sp
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)

  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $97 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $98 TYA                     Transfer Index Register Y To Accumulator
  andi s0,s2,$FF         // A_REG: Set To Index Register Y (8-Bit)
  andi t0,s0,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,TYAM1X1        // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  TYAM1X1:
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $99 STA   nnnn,Y            Store Accumulator To Memory Absolute Indexed, Y
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu t0,s2
  addu a2,a0,t0          // DB_REG:MEM+Y_REG: Set To Accumulator (8-Bit)
  sll t1,s7,16
  addu a2,t1
  sb s0,0(a2)

  la sp,StoreByte        // Store Byte
  jalr sp,sp
  addiu s3,2             // PC_REG += 2 (Increment Program Counter) (Delay Slot)

  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $9A TXS                     Transfer Index Register X To Stack Pointer
  andi s4,s1,$FF         // S_REG: Set To Index Register X (8-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $9B TXY                     Transfer Index Register X To Y
  andi s2,s1,$FF         // Y_REG: Set To Index Register X (8-Bit)
  andi t0,s2,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s2,TXYM1X1        // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  TXYM1X1:
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $9C STZ   nnnn              Store Zero To Memory Absolute
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // DB_REG:MEM: Set To Zero (8-Bit)
  sll t1,s7,16
  addu a2,t1
  sb r0,0(a2)

  la sp,StoreByte        // Store Byte
  jalr sp,sp
  addiu s3,2             // PC_REG += 2 (Increment Program Counter) (Delay Slot)

  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $9D STA   nnnn,X            Store Accumulator To Memory Absolute Indexed, X
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu t0,s1
  addu a2,a0,t0          // DB_REG:MEM+X_REG: Set To Accumulator (8-Bit)
  sll t1,s7,16
  addu a2,t1
  sb s0,0(a2)

  la sp,StoreByte        // Store Byte
  jalr sp,sp
  addiu s3,2             // PC_REG += 2 (Increment Program Counter) (Delay Slot)

  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $9E STZ   nnnn,X            Store Zero To Memory Absolute Indexed, X
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu t0,s1
  addu a2,a0,t0          // DB_REG:MEM+X_REG: Set To Zero (8-Bit)
  sll t1,s7,16
  addu a2,t1
  sb r0,0(a2)

  la sp,StoreByte        // Store Byte
  jalr sp,sp
  addiu s3,2             // PC_REG += 2 (Increment Program Counter) (Delay Slot)

  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $9F ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $A0 LDY   #nn               Load Index Register Y From Memory Immediate
  addu a2,a0,s3          // Y_REG: Set To 8-Bit Immediate
  lbu s2,0(a2)
  andi t0,s2,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s2,LDYIMMM1X1     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  LDYIMMM1X1:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $A1 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $A2 LDX   #nn               Load Index Register X From Memory Immediate
  addu a2,a0,s3          // X_REG: Set To 8-Bit Immediate
  lbu s1,0(a2)
  andi t0,s1,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s1,LDXABSM1X1     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  LDXABSM1X1:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $A3 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $A4 LDY   nn                Load Index Register Y From Memory Direct Page
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // Y_REG: Set To D_REG+MEM (8-Bit)
  addu a2,s6
  lbu s2,0(a2)
  andi t0,s2,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s2,LDYDPM1X1      // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  LDYDPM1X1:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $A5 LDA   nn                Load Accumulator From Memory Direct Page
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // A_REG: Set To D_REG+MEM (8-Bit)
  addu a2,s6
  lbu s0,0(a2)
  andi t0,s0,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,LDADPM1X1      // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  LDADPM1X1:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $A6 LDX   nn                Load Index Register X From Memory Direct Page
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // X_REG: Set To D_REG+MEM (8-Bit)
  addu a2,s6
  lbu s1,0(a2)
  andi t0,s1,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s1,LDXDPM1X1      // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  LDXDPM1X1:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $A7 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $A8 TAY                     Transfer Accumulator To Index Register Y
  andi s2,s0,$FF         // Y_REG: Set To Accumulator (8-Bit)
  andi t0,s2,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s2,TAYM1X1        // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  TAYM1X1:
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $A9 LDA   #nn               Load Accumulator From Memory Immediate
  addu a2,a0,s3          // A_REG: Set To 8-Bit Immediate
  lbu s0,0(a2)
  andi t0,s0,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,LDAIMMM1X1     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  LDAIMMM1X1:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $AA TAX                     Transfer Accumulator To Index Register X
  andi s1,s0,$FF         // X_REG: Set To Accumulator (8-Bit)
  andi t0,s1,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s1,TAXM1X1        // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  TAXM1X1:
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $AB PLB                     Pull Data Bank Register
  addiu s4,1             // S_REG++ (Increment Stack)
  andi s4,$FFFF
  addu a2,a0,s4          // DB_REG = STACK (8-Bit)
  lbu s7,0(a2)
  andi t0,s7,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s7,PLBM1X1        // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  PLBM1X1:
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $AC LDY   nnnn              Load Index Register Y From Memory Absolute
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // Y_REG: Set To DB_REG:MEM (8-Bit)
  sll t0,s7,16
  addu a2,t0
  lbu s2,0(a2)
  andi t0,s2,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s2,LDYABSM1X1     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  LDYABSM1X1:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $AD LDA   nnnn              Load Accumulator From Memory Absolute
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // A_REG: Set To DB_REG:MEM (8-Bit)
  sll t0,s7,16
  addu a2,t0
  lbu s0,0(a2)
  andi t0,s0,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,LDAABSM1X1     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  LDAABSM1X1:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $AE LDX   nnnn              Load Index Register X From Memory Absolute
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // X_REG: Set To DB_REG:MEM (8-Bit)
  sll t0,s7,16
  addu a2,t0
  lbu s1,0(a2)
  andi t0,s1,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s1,LDXIMMM1X1     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  LDXIMMM1X1:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $AF ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $B0 BCS   nn                Branch IF Carry Set
  andi t0,s5,C_FLAG      // P_REG: Test C Flag
  beqz t0,BCSM1X1        // IF (C Flag == 0) Carry Clear
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  addu a2,a0,s3          // Load Signed 8-Bit Relative Address
  lb t0,-1(a2)
  add s3,t0              // PC_REG: Set To 8-Bit Relative Address
  addiu v0,1             // Cycles++
  BCSM1X1:
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $B1 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $B2 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $B3 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $B4 LDY   nn,X              Load Index Register Y From Memory Direct Page Indexed, X
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // Y_REG: Set To D_REG+MEM+X_REG (8-Bit)
  addu a2,s6
  addu a2,s1
  lbu s2,0(a2)
  andi t0,s2,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s2,LDYDPXM1X1     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  LDYDPXM1X1:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $B5 LDA   nn,X              Load Accumulator From Memory Direct Page Indexed, X
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // A_REG: Set To D_REG+MEM+X_REG (8-Bit)
  addu a2,s6
  addu a2,s1
  lbu s0,0(a2)
  andi t0,s0,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,LDADPXM1X1     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  LDADPXM1X1:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $B6 LDX   nn,Y              Load Index Register X From Memory Direct Page Indexed, Y
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // X_REG: Set To D_REG+MEM+Y_REG (8-Bit)
  addu a2,s6
  addu a2,s2
  lbu s1,0(a2)
  andi t0,s1,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s1,LDXDPYM1X1     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  LDXDPYM1X1:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $B7 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $B8 CLV                     Clear Overflow Flag
  andi s5,~V_FLAG        // P_REG: V Flag Reset
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $B9 LDA   nnnn,Y            Load Accumulator From Memory Absolute Indexed, Y
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // A_REG: Set To DB_REG:MEM+Y_REG (8-Bit)
  sll t0,s7,16
  addu a2,t0
  addu a2,s2
  lbu s0,0(a2)
  andi t0,s0,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,LDAABSYM1X1    // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  LDAABSYM1X1:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $BA TSX                     Transfer Stack Pointer To Index Register X
  andi s1,s4,$FF         // X_REG: Set To Stack Pointer (8-Bit)
  andi t0,s1,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s1,TSXM1X1        // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  TSXM1X1:
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $BB TYX                     Transfer Index Register Y To X
  andi s1,s2,$FF         // X_REG: Set To Index Register Y (8-Bit)
  andi t0,s1,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s1,TYXM1X1        // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  TYXM1X1:
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $BC LDY   nnnn,X            Load Index Register Y From Memory Absolute Indexed, X
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // Y_REG: Set To DB_REG:MEM+X_REG (8-Bit)
  sll t0,s7,16
  addu a2,t0
  addu a2,s1
  lbu s2,0(a2)
  andi t0,s2,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s2,LDYABSXM1X1    // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  LDYABSXM1X1:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $BD LDA   nnnn,X            Load Accumulator From Memory Absolute Indexed, X
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // A_REG: Set To DB_REG:MEM+X_REG (8-Bit)
  sll t0,s7,16
  addu a2,t0
  addu a2,s1
  lbu s0,0(a2)
  andi t0,s0,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s0,LDAABSXM1X1    // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  LDAABSXM1X1:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $BE LDX   nnnn,Y            Load Index Register X From Memory Absolute Indexed, Y
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // X_REG: Set To DB_REG:MEM+Y_REG (8-Bit)
  sll t0,s7,16
  addu a2,t0
  addu a2,s2
  lbu s1,0(a2)
  andi t0,s1,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s1,LDXABSYM1X1    // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  LDXABSYM1X1:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $BF ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $C0 CPY   #nn               Compare Index Register Y With Memory Immediate
  addu a2,a0,s3          // Y_REG: Compare With 8-Bit Immediate
  lbu t0,0(a2)
  blt s2,t0,CPYIMMM1X1C  // IF (Y_REG < Immediate) C Flag Reset
  andi s5,~C_FLAG        // P_REG: C Flag Reset (Delay Slot)
  ori s5,C_FLAG          // P_REG: C Flag Set
  CPYIMMM1X1C:
  subu t0,s2,t0
  andi t1,t0,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t1               // P_REG: N Flag = Result MSB
  beqz t0,CPYIMMM1X1Z    // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  CPYIMMM1X1Z:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $C1 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $C2 REP   #nn               Reset Status Bits
  addu a2,a0,s3          // Load 8-Bit Immediate
  lbu t0,0(a2)           // Reset Bits
  xori t0,$FF            // Convert 8-Bit Immediate To Reset Bits
  ori t0,E_FLAG          // Preserve Emulation Flag
  and s5,t0              // P_REG: 8-Bit Immediate Flags Reset
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $C3 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $C4 CPY   nn                Compare Index Register Y With Memory Direct Page
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // Y_REG: Compare With D_REG+MEM (8-Bit)
  addu a2,s6
  lbu t0,0(a2)
  blt s2,t0,CPYDPM1X1C   // IF (Y_REG < Immediate) C Flag Reset
  andi s5,~C_FLAG        // P_REG: C Flag Reset (Delay Slot)
  ori s5,C_FLAG          // P_REG: C Flag Set
  CPYDPM1X1C:
  subu t0,s2,t0
  andi t1,t0,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t1               // P_REG: N Flag = Result MSB
  beqz t0,CPYDPM1X1Z     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  CPYDPM1X1Z:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $C5 CMP   nn                Compare Accumulator With Memory Direct Page
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // A_REG: Compare With D_REG+MEM (8-Bit)
  addu a2,s6
  lbu t0,0(a2)
  blt s0,t0,CMPDPM1X1C   // IF (A_REG < Immediate) C Flag Reset
  andi s5,~C_FLAG        // P_REG: C Flag Reset (Delay Slot)
  ori s5,C_FLAG          // P_REG: C Flag Set
  CMPDPM1X1C:
  subu t0,s0,t0
  andi t1,t0,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t1               // P_REG: N Flag = Result MSB
  beqz t0,CMPDPM1X1Z     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  CMPDPM1X1Z:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $C6 DEC   dp                Decrement Value In Direct Page Offset
  lbu t0,1(a2)           // DP = MEM_MAP[Immediate + D_REG]
  addu t0,s6             // T0 = Immediate + D_REG
  addu a2,a0,t0          // A2 = MEM_MAP + Immediate + D_REG
  lbu t0,0(a2)           // T0 = DP
  subiu t0,1             // DP--
  sb t0,0(a2)
  andi t1,t0,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t1               // P_REG: N Flag = Result MSB
  beqz t0,DECDPM1X1      // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  DECDPM1X1:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $C7 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $C8 INY                     Increment Index Register Y
  addiu s2,1             // Y_REG: Set To Index Register Y++ (8-Bit)
  andi s2,$FF
  andi t0,s2,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s2,INYM1X1        // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  INYM1X1:
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $C9 CMP   #nn               Compare Accumulator With Memory Immediate
  addu a2,a0,s3          // A_REG: Compare With 8-Bit Immediate
  lbu t0,0(a2)
  blt s0,t0,CMPIMMM1X1C  // IF (A_REG < Immediate) C Flag Reset
  andi s5,~C_FLAG        // P_REG: C Flag Reset (Delay Slot)
  ori s5,C_FLAG          // P_REG: C Flag Set
  CMPIMMM1X1C:
  subu t0,s0,t0
  andi t1,t0,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t1               // P_REG: N Flag = Result MSB
  beqz t0,CMPIMMM1X1Z    // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  CMPIMMM1X1Z:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $CA DEX                     Decrement Index Register X
  subiu s1,1             // X_REG: Set To Index Register X-- (8-Bit)
  andi s1,$FF
  andi t0,s1,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s1,DEXM1X1        // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  DEXM1X1:
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $CB ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $CC CPY   nnnn              Compare Index Register Y With Memory Absolute
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // Y_REG: Compare With DB_REG:MEM (8-Bit)
  sll t0,s7,16
  addu a2,t0
  lbu t0,0(a2)
  blt s2,t0,CPYABSM1X1C  // IF (Y_REG < Immediate) C Flag Reset
  andi s5,~C_FLAG        // P_REG: C Flag Reset (Delay Slot)
  ori s5,C_FLAG          // P_REG: C Flag Set
  CPYABSM1X1C:
  subu t0,s2,t0
  andi t1,t0,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t1               // P_REG: N Flag = Result MSB
  beqz t0,CPYABSM1X1Z    // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  CPYABSM1X1Z:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $CD CMP   nnnn              Compare Accumulator With Memory Absolute
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // A_REG: Compare With DB_REG:MEM (8-Bit)
  sll t0,s7,16
  addu a2,t0
  lbu t0,0(a2)
  blt s0,t0,CMPABSM1X1C  // IF (A_REG < Immediate) C Flag Reset
  andi s5,~C_FLAG        // P_REG: C Flag Reset (Delay Slot)
  ori s5,C_FLAG          // P_REG: C Flag Set
  CMPABSM1X1C:
  subu t0,s0,t0
  andi t1,t0,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t1               // P_REG: N Flag = Result MSB
  beqz t0,CMPABSM1X1Z    // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  CMPABSM1X1Z:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $CE DEC   nnnn              Decrement Memory Absolute
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // Decrement DB_REG:MEM (8-Bit)
  sll t0,s7,16
  addu a2,t0
  lbu t0,0(a2)
  subiu t0,1
  sb t0,0(a2)
  andi t1,t0,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t1               // P_REG: N Flag = Result MSB
  beqz t0,DECABSM1X1     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  DECABSM1X1:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

align(256)
  // $CF ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $D0 BNE   nn                Branch IF Not Equal
  andi t0,s5,Z_FLAG      // P_REG: Test Z Flag
  bnez t0,BNEM1X1        // IF (Z Flag != 0) Equal
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  addu a2,a0,s3          // Load Signed 8-Bit Relative Address
  lb t0,-1(a2)
  add s3,t0              // PC_REG: Set To 8-Bit Relative Address
  addiu v0,1             // Cycles++
  BNEM1X1:
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $D1 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $D2 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $D3 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $D4 PEI   nn                Push Effective Indirect Address
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // Load D_REG+MEM (16-Bit)
  addu a2,s6
  lbu t0,0(a2)           // Load 16-Bit Effective Indirect Address
  lbu t1,1(a2)
  addu a2,a0,s4          // STACK = Effective Indirect Address (16-Bit)
  sb t0,-1(a2)
  sb t1,0(a2)
  subiu s4,2             // S_REG -= 2 (Decrement Stack)
  andi s4,$FFFF
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

align(256)
  // $D5 CMP   nn,X              Compare Accumulator With Memory Direct Page Indexed, X
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // A_REG: Compare With D_REG+MEM+X_REG (8-Bit)
  addu a2,s6
  addu a2,s1
  lbu t0,0(a2)
  blt s0,t0,CMPDPXM1X1C  // IF (A_REG < Immediate) C Flag Reset
  andi s5,~C_FLAG        // P_REG: C Flag Reset (Delay Slot)
  ori s5,C_FLAG          // P_REG: C Flag Set
  CMPDPXM1X1C:
  subu t0,s0,t0
  andi t1,t0,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t1               // P_REG: N Flag = Result MSB
  beqz t0,CMPDPXM1X1Z    // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  CMPDPXM1X1Z:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $D6 DEC   nn,X              Decrement Memory Direct Page Indexed, X
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // Decrement D_REG+MEM+X_REG (8-Bit)
  addu a2,s6
  addu a2,s1
  lbu t0,0(a2)
  subiu t0,1
  sb t0,0(a2)
  andi t1,t0,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t1               // P_REG: N Flag = Result MSB
  beqz t0,DECDPXM1X1     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  DECDPXM1X1:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

align(256)
  // $D7 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $D8 CLD                     Clear Decimal Mode Flag
  andi s5,~D_FLAG        // P_REG: D Flag Reset
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $D9 CMP   nnnn,Y            Compare Accumulator With Memory Absolute Indexed, Y
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // A_REG: Compare With DB_REG:MEM+Y_REG (8-Bit)
  sll t0,s7,16
  addu a2,t0
  addu a2,s2
  lbu t0,0(a2)
  blt s0,t0,CMPABSYM1X1C // IF (A_REG < Immediate) C Flag Reset
  andi s5,~C_FLAG        // P_REG: C Flag Reset (Delay Slot)
  ori s5,C_FLAG          // P_REG: C Flag Set
  CMPABSYM1X1C:
  subu t0,s0,t0
  andi t1,t0,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t1               // P_REG: N Flag = Result MSB
  beqz t0,CMPABSYM1X1Z   // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  CMPABSYM1X1Z:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $DA PHX                     Push Index Register X
  addu a2,a0,s4          // STACK = X_REG (8-Bit)
  sb s1,0(a2)
  subiu s4,1             // S_REG-- (Decrement Stack)
  andi s4,$FFFF
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $DB ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $DC ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $DD CMP   nnnn,X            Compare Accumulator With Memory Absolute Indexed, X
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // A_REG: Compare With DB_REG:MEM+X_REG (8-Bit)
  sll t0,s7,16
  addu a2,t0
  addu a2,s1
  lbu t0,0(a2)
  blt s0,t0,CMPABSXM1X1C // IF (A_REG < Immediate) C Flag Reset
  andi s5,~C_FLAG        // P_REG: C Flag Reset (Delay Slot)
  ori s5,C_FLAG          // P_REG: C Flag Set
  CMPABSXM1X1C:
  subu t0,s0,t0
  andi t1,t0,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t1               // P_REG: N Flag = Result MSB
  beqz t0,CMPABSXM1X1Z   // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  CMPABSXM1X1Z:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $DE DEC   nnnn,X            Decrement Memory Absolute Indexed, X
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // Decrement DB_REG:MEM+X_REG (8-Bit)
  sll t0,s7,16
  addu a2,t0
  addu a2,s1
  lbu t0,0(a2)
  subiu t0,1
  sb t0,0(a2)
  andi t1,t0,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t1               // P_REG: N Flag = Result MSB
  beqz t0,DECABSXM1X1    // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  DECABSXM1X1:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

align(256)
  // $DF ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $E0 CPX   #nn               Compare Index Register X With Memory Immediate
  addu a2,a0,s3          // X_REG: Compare With 8-Bit Immediate
  lbu t0,0(a2)
  blt s1,t0,CPXIMMM1X1C  // IF (X_REG < Immediate) C Flag Reset
  andi s5,~C_FLAG        // P_REG: C Flag Reset (Delay Slot)
  ori s5,C_FLAG          // P_REG: C Flag Set
  CPXIMMM1X1C:
  subu t0,s1,t0
  andi t1,t0,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t1               // P_REG: N Flag = Result MSB
  beqz t0,CPXIMMM1X1Z    // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  CPXIMMM1X1Z:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $E1 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $E2 SEP   #nn               Set Status Bits
  addu a2,a0,s3          // Load 8-Bit Immediate
  lbu t0,0(a2)           // Set Bits
  or s5,t0               // P_REG: 8-Bit Immediate Flags Set
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $E3 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $E4 CPX   nn                Compare Index Register X With Memory Direct Page
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // X_REG: Compare With D_REG+MEM (8-Bit)
  addu a2,s6
  lbu t0,0(a2)
  blt s1,t0,CPXDPM1X1C   // IF (X_REG < Immediate) C Flag Reset
  andi s5,~C_FLAG        // P_REG: C Flag Reset (Delay Slot)
  ori s5,C_FLAG          // P_REG: C Flag Set
  CPXDPM1X1C:
  subu t0,s1,t0
  andi t1,t0,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t1               // P_REG: N Flag = Result MSB
  beqz t0,CPXDPM1X1Z     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  CPXDPM1X1Z:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $E5 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $E6 INC   dp                Increment Value In Direct Page Offset
  lbu t0,1(a2)           // DP = MEM_MAP[Immediate + D_REG]
  addu t0,s6             // T0 = Immediate + D_REG
  addu a2,a0,t0          // A2 = MEM_MAP + Immediate + D_REG
  lbu t0,0(a2)           // T0 = DP
  addiu t0,1             // DP++
  sb t0,0(a2)
  andi t0,$FF
  andi t1,t0,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t1               // P_REG: N Flag = Result MSB
  beqz t0,INCDPM1X1      // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  INCDPM1X1:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $E7 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $E8 INX                     Increment Index Register X
  addiu s1,1             // X_REG: Set To Index Register X++ (8-Bit)
  andi s1,$FF
  andi t0,s1,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s1,INXM1X1        // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  INXM1X1:
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
  andi t0,s0,$FF         // A_REG: Set To B (8-Bit)
  sll t0,8               // B_REG: Set To A (8-Bit)
  srl s0,8
  or s0,t0
  andi t0,s0,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  andi t0,s0,$FF
  beqz t0,XBAM1X1        // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  XBAM1X1:
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

align(256)
  // $EC CPX   nnnn              Compare Index Register X With Memory Absolute
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // X_REG: Compare With DB_REG:MEM (8-Bit)
  sll t0,s7,16
  addu a2,t0
  lbu t0,0(a2)
  blt s1,t0,CPXABSM1X1C  // IF (X_REG < Immediate) C Flag Reset
  andi s5,~C_FLAG        // P_REG: C Flag Reset (Delay Slot)
  ori s5,C_FLAG          // P_REG: C Flag Set
  CPXABSM1X1C:
  subu t0,s1,t0
  andi t1,t0,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t1               // P_REG: N Flag = Result MSB
  beqz t0,CPXABSM1X1Z    // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  CPXABSM1X1Z:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $ED ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $EE INC   nnnn              Increment Memory Absolute
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // Increment DB_REG:MEM (8-Bit)
  sll t0,s7,16
  addu a2,t0
  lbu t0,0(a2)
  addiu t0,1
  sb t0,0(a2)
  andi t0,$FF
  andi t1,t0,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t1               // P_REG: N Flag = Result MSB
  beqz t0,INCABSM1X1     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  INCABSM1X1:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

align(256)
  // $EF ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $F0 BEQ   nn                Branch IF Equal
  andi t0,s5,Z_FLAG      // P_REG: Test Z Flag
  beqz t0,BEQM1X1        // IF (Z Flag == 0) Not Equal
  addiu s3,1             // PC_REG++ (Increment Program Counter) (Delay Slot)
  addu a2,a0,s3          // Load Signed 8-Bit Relative Address
  lb t0,-1(a2)
  add s3,t0              // PC_REG: Set To 8-Bit Relative Address
  addiu v0,1             // Cycles++
  BEQM1X1:
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
  addu a2,a0,s3          // Load 16-Bit Effective Absolute Address
  lbu t0,0(a2)
  lbu t1,1(a2)
  addu a2,a0,s4          // STACK = Effective Absolute Address (16-Bit)
  sb t0,-1(a2)
  sb t1,0(a2)
  subiu s4,2             // S_REG -= 2 (Decrement Stack)
  andi s4,$FFFF
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

align(256)
  // $F5 ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $F6 INC   nn,X              Increment Memory Direct Page Indexed, X
  addu a2,a0,s3          // Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          // Increment D_REG+MEM+X_REG (8-Bit)
  addu a2,s6
  addu a2,s1
  lbu t0,0(a2)
  addiu t0,1
  sb t0,0(a2)
  andi t0,$FF
  andi t1,t0,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t1               // P_REG: N Flag = Result MSB
  beqz t0,INCDPXM1X1     // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  INCDPXM1X1:
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

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
  addiu s4,1             // S_REG++ (Increment Stack)
  andi s4,$FFFF
  addu a2,a0,s4          // X_REG = STACK (8-Bit)
  lbu s1,0(a2)
  andi t0,s1,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t0               // P_REG: N Flag = Result MSB
  beqz s1,PLXM1X1        // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  PLXM1X1:
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

align(256)
  // $FB XCE                     Exchange Carry & Emulation Bits
  andi t0,s5,C_FLAG      // P_REG: C Flag
  andi t1,s5,E_FLAG      // P_REG: E Flag
  sll t0,8               // C Flag -> E Flag
  srl t1,8               // E Flag -> C Flag
  or t2,t0,t1            // C + E Flag
  andi s5,~(C_FLAG+E_FLAG) // P_REG: C + E Flag Reset
  or s5,t1               // P_REG: Exchange Carry & Emulation Bits
  beqz t0,XCEM1X1        // IF (E Flag == 0) Native Mode
  ori s5,M_FLAG+X_FLAG   // P_REG: M + X Flag Set (Delay Slot)
  andi s5,~(M_FLAG+X_FLAG) // P_REG: M + X Flag Reset
  andi s1,$FF            // X_REG = X_REG Low Byte
  andi s2,$FF            // Y_REG = Y_REG Low Byte
  andi s4,$FF            // S_REG = S_REG Low Byte
  XCEM1X1:
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

align(256)
  // $FC ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $FD ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)

align(256)
  // $FE INC   nnnn,X            Increment Memory Absolute Indexed, X
  addu a2,a0,s3          // Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          // Increment DB_REG:MEM+X_REG (8-Bit)
  sll t0,s7,16
  addu a2,t0
  addu a2,s1
  lbu t0,0(a2)
  addiu t0,1
  sb t0,0(a2)
  andi t0,$FF
  andi t1,t0,$80         // Test Negative MSB
  andi s5,~N_FLAG        // P_REG: N Flag Reset
  or s5,t1               // P_REG: N Flag = Result MSB
  beqz t0,INCABSXM1X1    // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        // P_REG: Z Flag Reset
  INCABSXM1X1:
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

align(256)
  // $FF ???   ???               ?????
  jr ra
  addiu v0,1             // Cycles += 1 (Delay Slot)