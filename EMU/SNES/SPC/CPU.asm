align(256)
  // $00 NOP                    No OPeration
  jr ra
  addiu v0,2                    // Cycles += 2 (Delay Slot)

align(256)
  // $01 TCALL n                Table CALL Push PC Onto Stack Then Jump To Table Address
  subiu s4,2                    // SP_REG -= 2 (Decrement Stack)
  andi s4,$FF
  addu a2,a0,s4                 // STACK = MEM_MAP[$100 + SP_REG]
  addiu a2,$100                 // A2 = STACK
  sb s3,1(a2)                   // STACK = PC_REG
  srl t0,s3,8
  sb t0,2(a2)
  addiu a2,a0,$FFDE             // PC_REG = MEM_MAP[$FFDE]
  lbu s3,0(a2)
  lbu t0,1(a2)
  sll t0,8
  or s3,t0
  jr ra
  addiu v0,8                    // Cycles += 8 (Delay Slot)

align(256)
  // $02 SET1  dp.bit           SET Bit In Direct Page Offset
  andi t0,s5,P_FLAG             // DP = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = DP
  ori t0,1                      // DP |= BIT
  sb t0,0(a2)                   // Store DP
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $03 BBS   dp.bit, rel      Branch To Relative Address IF Bit Set In Direct Page Offset
  andi t0,s5,P_FLAG             // DP = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  lb t1,2(a2)                   // T1 = Relative
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = DP
  andi t0,1                     // DP &= BIT
  beqz t0,BBS0SPC               // IF (DP & BIT) PC_REG += Relative
  addiu s3,2                    // PC_REG += 2 (Delay Slot)
  add s3,t1                     // PC_REG += Relative
  addiu v0,2                    // Cycles += 2
  BBS0SPC:
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $04 OR    A, dp            Logical OR Value In Direct Page Offset With A
  andi t0,s5,P_FLAG             // DP = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = DP
  or s0,t0                      // A_REG |= DP
  andi t0,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s0,ORADPSPC              // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  ORADPSPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,3                    // Cycles += 3 (Delay Slot)

align(256)
  // $05 OR    A, !abs          Logical OR Value From Absolute Address With A
  lbu t0,1(a2)                  // ABS = MEM_MAP[Absolute]
  lbu t1,2(a2)
  sll t1,8
  or t0,t1                      // T0 = Absolute
  addu a2,a0,t0                 // A2 = MEM_MAP + Absolute
  lbu t0,0(a2)                  // T0 = ABS
  or s0,t0                      // A_REG |= ABS
  andi t0,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s0,ORAABSSPC             // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  ORAABSSPC:
  addiu s3,2                    // PC_REG += 2
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $06 OR    A, (X)           Logical OR Value X With A
  andi t0,s5,P_FLAG             // (X) = MEM_MAP[X_REG | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  or t0,s1                      // T0 = X_REG | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (X_REG | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = (X)
  or s0,t0                      // A_REG |= (X)
  andi t0,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s0,ORAXSPC               // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  ORAXSPC:
  jr ra
  addiu v0,3                    // Cycles += 3 (Delay Slot)

align(256)
  // $07 OR    A, [dp+X]        Logical OR Value From Indirect Absolute Address In Direct Page Offset Added With Value X With A
  andi t0,s5,P_FLAG             // DPXI = MEM_MAP[MEM_MAP[((Immediate + X_REG) & $FF) | (P_FLAG << 3)]]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  addu t1,s1                    // T1 = Immediate + X_REG
  andi t1,$FF                   // T1 = (Immediate + X_REG) & $FF
  or t0,t1                      // T0 = ((Immediate + X_REG) & $FF) | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + ((Immediate + X_REG) & $FF) | (P_FLAG << 3)
  lbu t0,0(a2)
  lbu t1,1(a2)
  srl t1,8
  or t0,t1                      // T0 = MEM_MAP[((Immediate + X_REG) & $FF) | (P_FLAG << 3)]
  addu a2,a0,t0                 // A2 = MEM_MAP + MEM_MAP[((Immediate + X_REG) & $FF) | (P_FLAG << 3)]
  lbu t0,0(a2)                  // T0 = DPXI
  or s0,t0                      // A_REG |= DPXI
  andi t0,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s0,ORADPXISPC            // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  ORADPXISPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,6                    // Cycles += 6 (Delay Slot)

align(256)
  // $08 OR    A, #imm          Logical OR Immediate Value With A
  lbu t0,1(a2)                  // T0 = Immediate
  or s0,t0                      // A_REG |= Immediate
  andi t0,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s0,ORAIMMSPC             // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  ORAIMMSPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,2                    // Cycles += 2 (Delay Slot)

align(256)
  // $09 OR    dp, dp           Logical OR Value In Direct Page Offset With Direct Page Offset
  andi t0,s5,P_FLAG             // DPB = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t1,t0                      // T1 = Immediate | (P_FLAG << 3)
  addu a3,a0,t1                 // A3 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu t1,0(a3)                  // T1 = DPB
  lbu t2,2(a2)                  // DPA = MEM_MAP[DirectPage | (P_FLAG << 3)]
  or t0,t2                      // T0 = DirectPage | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (DirectPage | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = DPA
  or t0,t1                      // DPA |= DPB
  sb t0,0(a2)                   // Store DPA
  andi t1,t0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t1                      // PSW_REG: N Flag = Result MSB
  beqz t0,ORDPDPSPC             // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  ORDPDPSPC:
  addiu s3,2                    // PC_REG += 2
  jr ra
  addiu v0,6                    // Cycles += 6 (Delay Slot)

align(256)
  // $0A OR1   C, mem.bit       OR Carry Flag With Memory Bit
  lbu t0,1(a2)                  // MEMBIT = (MEM_MAP[MEM] >> BIT) & 1
  lbu t1,2(a2)
  sll t1,8
  or t0,t1                      // T0 = Absolute
  srl t1,t0,13                  // T1 = BIT (Absolute >> 13)
  andi t0,$1FFF                 // T0 = MEM (Absolute & 0x1FFF)
  addu a2,a0,t0                 // A2 = MEM_MAP + MEM
  lbu t0,0(a2)                  // T0 = MEM_MAP[MEM]
  srlv t0,t1                    // T0 = MEM_MAP[MEM] >> BIT
  andi t0,1                     // T0 = MEMBIT
  or s5,t0                      // PSW_REG |= MEMBIT
  addiu s3,2                    // PC_REG += 2
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $0B ASL   dp               Arithmetic Shift Left Value In Direct Page Offset Into Carry Flag
  andi t0,s5,P_FLAG             // DP = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = DP
  andi t1,t0,$80                // C Flag Set To Old MSB
  srl t1,7
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  or s5,t1                      // PSW_REG: C Flag = Old MSB
  sll t0,1                      // DP <<= 1
  andi t0,$FF
  sb t0,0(a2)                   // Store DP
  andi t1,t0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t1                      // PSW_REG: N Flag = Result MSB
  beqz t0,ASLDPSPC              // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  ASLDPSPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $0C ASL   !abs             Arithmetic Shift Left Value From Absolute Address Into Carry Flag
  lbu t0,1(a2)                  // ABS = MEM_MAP[Absolute]
  lbu t1,2(a2)
  sll t1,8
  or t0,t1                      // T0 = Absolute
  addu a2,a0,t0                 // A2 = MEM_MAP + Absolute
  lbu t0,0(a2)                  // T0 = ABS
  andi t1,t0,$80                // C Flag Set To Old MSB
  srl t1,7
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  or s5,t1                      // PSW_REG: C Flag = Old MSB
  sll t0,1                      // ABS <<= 1
  andi t0,$FF
  sb t0,0(a2)                   // Store ABS
  andi t1,t0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t1                      // PSW_REG: N Flag = Result MSB
  beqz t0,ASLABSSPC             // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  ASLABSSPC:
  addiu s3,2                    // PC_REG += 2
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $0D PUSH  PSW              PUSH Register PSW Onto Stack
  addu a2,a0,s4                 // STACK = MEM_MAP[$100 + SP_REG]
  addiu a2,$100                 // A2 = STACK
  sb s5,0(a2)                   // STACK = PSW_REG
  subiu s4,1                    // SP_REG--
  andi s4,$FF
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $0E TSET1 !abs             Test & SET Bits In Absolute Address With A
  lbu t0,1(a2)                  // ABS = MEM_MAP[Absolute]
  lbu t1,2(a2)
  sll t1,8
  or t0,t1                      // T0 = Absolute
  addu a2,a0,t0                 // A2 = MEM_MAP + Absolute
  lbu t0,0(a2)                  // T0 = ABS
  subu t1,s0,t0                 // T1 = A - ABS
  and t1,$FF
  andi t2,t1,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t2                      // PSW_REG: N Flag = Result MSB
  beqz t1,TSET1ABSSPC           // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  TSET1ABSSPC:
  or t0,s0                      // ABS |= A_REG
  sb t0,0(a2)                   // Store ABS
  addiu s3,2                    // PC_REG += 2
  jr ra
  addiu v0,6                    // Cycles += 6 (Delay Slot)

align(256)
  // $0F BRK                    BReaK To Software Interrupt
  subiu s4,2                    // SP_REG -= 2 (Decrement Stack)
  addu a2,a0,s4                 // STACK = MEM_MAP[$100 + SP_REG]
  addiu a2,$100                 // A2 = STACK
  sb s3,1(a2)                   // STACK = PC_REG
  srl t0,s3,8
  sb t0,2(a2)
  addiu a3,a0,$FFDE             // PC_REG = MEM_MAP[$FFDE]
  lbu s3,0(a3)
  lbu t0,1(a3)
  sll t0,8
  or s3,t0
  sb s5,0(a2)                   // STACK = PSW_REG
  subiu s4,1                    // SP_REG--
  ori s5,B_FLAG                 // B Flag Set
  andi s5,~I_FLAG               // I Flag Reset
  jr ra
  addiu v0,8                    // Cycles += 8 (Delay Slot)

align(256)
  // $10 BPL   rel              Branch To Relative Address IF PLus Set
  andi t0,s5,N_FLAG             // IF (! N_FLAG) PC_REG += Relative
  bnez t0,BPLSPC
  addiu s3,1                    // PC_REG++ (Delay Slot)
  lb t0,1(a2)                   // T0 = Relative
  add s3,t0                     // PC_REG += Relative
  addiu v0,2                    // Cycles += 2
  BPLSPC:
  jr ra
  addiu v0,2                    // Cycles += 2 (Delay Slot)

align(256)
  // $11 TCALL n                Table CALL Push PC Onto Stack Then Jump To Table Address
  subiu s4,2                    // SP_REG -= 2 (Decrement Stack)
  andi s4,$FF
  addu a2,a0,s4                 // STACK = MEM_MAP[$100 + SP_REG]
  addiu a2,$100                 // A2 = STACK
  sb s3,1(a2)                   // STACK = PC_REG
  srl t0,s3,8
  sb t0,2(a2)
  addiu a2,a0,$FFDC             // PC_REG = MEM_MAP[$FFDC]
  lbu s3,0(a2)
  lbu t0,1(a2)
  sll t0,8
  or s3,t0
  jr ra
  addiu v0,8                    // Cycles += 8 (Delay Slot)

align(256)
  // $12 CLR1  dp.bit           CLeaR Bit In Direct Page Offset
  andi t0,s5,P_FLAG             // DP = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = DP
  andi t0,$FE                   // DP &= ^BIT
  sb t0,0(a2)                   // Store DP
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $13 BBC   dp.bit, rel      Branch To Relative Address IF Bit Cleared In Direct Page Offset
  andi t0,s5,P_FLAG             // DP = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  lb t1,2(a2)                   // T1 = Relative
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = DP
  andi t0,1                     // DP &= BIT
  bnez t0,BBC0SPC               // IF (! (DP & BIT)) PC_REG += Relative
  addiu s3,2                    // PC_REG += 2 (Delay Slot)
  add s3,t1                     // PC_REG += Relative
  addiu v0,2                    // Cycles += 2
  BBC0SPC:
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $14 OR    A, dp+X          Logical OR Value In Direct Page Offset Added With Value X With A
  andi t0,s5,P_FLAG             // DPX = MEM_MAP[((Immediate + X_REG) & $FF) | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  addu t1,s1                    // T1 = Immediate + X_REG
  andi t1,$FF                   // T1 = (Immediate + X_REG) & $FF
  or t0,t1                      // T0 = ((Immediate + X_REG) & $FF) | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + ((Immediate + X_REG) & $FF) | (P_FLAG << 3)
  lbu t0,0(a2)                  // T0 = DPX
  or s0,t0                      // A_REG |= DPX
  andi t0,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s0,ORADPXSPC             // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  ORADPXSPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $15 OR    A, !abs+X        Logical OR Value From Absolute Address Added With Value X With A
  lbu t0,1(a2)                  // ABSX = MEM_MAP[Absolute + X_REG]
  lbu t1,2(a2)
  sll t1,8
  or t0,t1                      // T0 = Absolute
  addu a2,a0,t0                 // A2 = MEM_MAP + Absolute
  addu a2,s1                    // A2 = MEM_MAP + Absolute + X_REG
  lbu t0,0(a2)                  // T0 = ABSX
  or s0,t0                      // A_REG |= ABSX
  andi t0,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s0,ORAABSXSPC            // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  ORAABSXSPC:
  addiu s3,2                    // PC_REG += 2
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $16 OR    A, !abs+Y        Logical OR Value From Absolute Address Added With Value Y With A
  lbu t0,1(a2)                  // ABSY = MEM_MAP[Absolute + Y_REG]
  lbu t1,2(a2)
  sll t1,8
  or t0,t1                      // T0 = Absolute
  addu a2,a0,t0                 // A2 = MEM_MAP + Absolute
  addu a2,s2                    // A2 = MEM_MAP + Absolute + Y_REG
  lbu t0,0(a2)                  // T0 = ABSY
  or s0,t0                      // A_REG |= ABSY
  andi t0,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s0,ORAABSYSPC            // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  ORAABSYSPC:
  addiu s3,2                    // PC_REG += 2
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $17 OR    A, [dp]+Y        Logical OR Value From Indirect Absolute Address In Direct Page Offset Added With Value Y With A
  andi t0,s5,P_FLAG             // DPYI = MEM_MAP[MEM_MAP[Immediate) | (P_FLAG << 3)] + Y_REG]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate) | (P_FLAG << 3))
  lbu t0,0(a2)
  lbu t1,1(a2)
  srl t1,8
  or t0,t1                      // T0 = MEM_MAP[Immediate) | (P_FLAG << 3)]
  addu t0,s2                    // T0 = MEM_MAP[Immediate) | (P_FLAG << 3)] + Y_REG
  addu a2,a0,t0                 // A2 = MEM_MAP + MEM_MAP[Immediate) | (P_FLAG << 3) + Y_REG]
  lbu t0,0(a2)                  // T0 = DPYI
  or s0,t0                      // A_REG |= DPYI
  andi t0,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s0,ORADPYISPC            // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  ORADPYISPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,6                    // Cycles += 6 (Delay Slot)

align(256)
  // $18 OR    dp, #imm         Logical OR Immediate Value With Direct Page Offset
  andi t0,s5,P_FLAG             // DP = MEM_MAP[DirectPage | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,2(a2)                  // T1 = DirectPage
  or t0,t1                      // T0 = DirectPage | (P_FLAG << 3)
  lbu t1,1(a2)                  // T1 = Immediate
  addu a2,a0,t0                 // A2 = MEM_MAP + (DirectPage | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = DP
  or t0,t1                      // DP |= Immediate
  sb t0,0(a2)                   // Store DP
  andi t1,t0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t1                      // PSW_REG: N Flag = Result MSB
  beqz t0,ORDPIMMSPC            // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  ORDPIMMSPC:
  addiu s3,2                    // PC_REG += 2
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $19 OR    (X), (Y)         Logical OR Value Y With X
  andi t0,s5,P_FLAG             // (Y) = MEM_MAP[Y_REG | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  or t1,t0,s2                   // T1 = Y_REG | (P_FLAG << 3)
  addu a3,a0,t1                 // A3 = MEM_MAP + (Y_REG | (P_FLAG << 3))
  lbu t1,0(a3)                  // T1 = (Y)
  or t0,s1                      // (X) = MEM_MAP[X_REG | (P_FLAG << 3)]
  addu a2,a0,t0                 // A2 = MEM_MAP + (X_REG | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = (X)
  or t0,t1                      // (X) |= (Y)
  sb t0,0(a2)                   // Store (X)
  andi t1,t0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t1                      // PSW_REG: N Flag = Result MSB
  beqz t0,ORXYSPC               // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  ORXYSPC:
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $1A DECW  dp               DECrement Word In Direct Page Offset
  andi t0,s5,P_FLAG             // DPW = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu t0,0(a2)
  lbu t1,1(a2)
  sll t1,8
  or t0,t1                      // T0 = DPW
  subiu t0,1                    // DPW--
  andi t0,$FFFF
  sb t0,0(a2)                   // Store DPW
  srl t1,t0,8
  sb t1,1(a2)
  andi t1,$80                   // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t1                      // PSW_REG: N Flag = Result MSB
  beqz t0,DECWDPSPC             // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  DECWDPSPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,6                    // Cycles += 6 (Delay Slot)

align(256)
  // $1B ASL   dp+X             Arithmetic Shift Left Value In Direct Page Offset Added With Value X Into Carry Flag
  andi t0,s5,P_FLAG             // DPX = MEM_MAP[((Immediate + X_REG) & $FF) | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  addu t1,s1                    // T1 = Immediate + X_REG
  andi t1,$FF                   // T1 = (Immediate + X_REG) & $FF
  or t0,t1                      // T0 = ((Immediate + X_REG) & $FF) | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + ((Immediate + X_REG) & $FF) | (P_FLAG << 3)
  lbu t0,0(a2)                  // T0 = DPX
  andi t1,t0,$80                // C Flag Set To Old MSB
  srl t1,7
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  or s5,t1                      // PSW_REG: C Flag = Old MSB
  sll t0,1                      // DPX <<= 1
  andi t0,$FF
  sb t0,0(a2)                   // Store DPX
  andi t1,t0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t1                      // PSW_REG: N Flag = Result MSB
  beqz t0,ASLDPXSPC             // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  ASLDPXSPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $1C ASL   A                Arithmetic Shift Left Register A Into Carry Flag
  andi t0,s0,$80                // C Flag Set To Old MSB
  srl t0,7
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  or s5,t0                      // PSW_REG: C Flag = Old MSB
  sll s0,1                      // A_REG <<= 1
  andi s0,$FF
  andi t0,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s0,ASLASPC               // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  ASLASPC:
  jr ra
  addiu v0,2                    // Cycles += 2 (Delay Slot)

align(256)
  // $1D DEC   X                DECrement Register X
  subiu s1,1                    // X_REG--
  andi s1,$FF
  andi t0,s1,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s1,DECXSPC               // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  DECXSPC:
  jr ra
  addiu v0,2                    // Cycles += 2 (Delay Slot)

align(256)
  // $1E CMP   X, !abs          CoMPare Value From Absolute Address With X
  lbu t0,1(a2)                  // ABS = MEM_MAP[Absolute]
  lbu t1,2(a2)
  sll t1,8
  or t0,t1                      // T0 = Absolute
  addu a2,a0,t0                 // A2 = MEM_MAP + Absolute
  lbu t0,0(a2)                  // T0 = ABS
  subu t1,s1,t0                 // T1 = X_REG - ABS
  andi t1,$FF
  andi t2,t1,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t2                      // PSW_REG: N Flag = Result MSB
  andi t3,s1,$80                // T3 = X_REG & $80
  andi t4,t0,$80                // T4 = ABS & $80
  beq t3,t4,CMPXABSVASPC        // IF (X_REG & $80 == ABS & $80) &&
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  CMPXABSVASPC:
  bne t3,t2,CMPXABSVBSPC        // IF (X_REG & $80 != (X_REG - ABS) & $80)
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  CMPXABSVBSPC:
  beqz t1,CMPXABSZSPC           // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  CMPXABSZSPC:
  bgtu t1,t0,CMPXABSCSPC        // IF ((X_REG - ABS) > ABS) C Flag Set
  ori s5,C_FLAG                 // PSW_REG: C Flag Set (Delay Slot)
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  CMPXABSCSPC:
  addiu s3,2                    // PC_REG += 2
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $1F JMP   [!abs+X]         JuMP To Absolute Address In Absolute Address Added To Value X
  lbu t0,1(a2)                  // ABSX = MEM_MAP[Absolute + X_REG]
  lbu t1,2(a2)
  sll t1,8
  or t0,t1                      // T0 = Absolute
  addu a2,a0,t0                 // A2 = MEM_MAP + Absolute
  addu a2,s1                    // A2 = MEM_MAP + Absolute + X_REG
  lbu s3,0(a2)                  // PC_REG = ABSX
  lbu t0,1(a2)
  sll t0,8
  or s3,t0
  jr ra
  addiu v0,6                    // Cycles += 6 (Delay Slot)

align(256)
  // $20 CLRP                   CLeaR Direct Page Flag
  andi s5,~P_FLAG               // PSW_REG: P Flag Reset
  jr ra
  addiu v0,2                    // Cycles += 2 (Delay Slot)

align(256)
  // $21 TCALL n                Table CALL Push PC Onto Stack Then Jump To Table Address
  subiu s4,2                    // SP_REG -= 2 (Decrement Stack)
  andi s4,$FF
  addu a2,a0,s4                 // STACK = MEM_MAP[$100 + SP_REG]
  addiu a2,$100                 // A2 = STACK
  sb s3,1(a2)                   // STACK = PC_REG
  srl t0,s3,8
  sb t0,2(a2)
  addiu a2,a0,$FFDA             // PC_REG = MEM_MAP[$FFDA]
  lbu s3,0(a2)
  lbu t0,1(a2)
  sll t0,8
  or s3,t0
  jr ra
  addiu v0,8                    // Cycles += 8 (Delay Slot)

align(256)
  // $22 SET1  dp.bit           SET Bit In Direct Page Offset
  andi t0,s5,P_FLAG             // DP = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = DP
  ori t0,2                      // DP |= BIT
  sb t0,0(a2)                   // Store DP
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $23 BBS   dp.bit, rel      Branch To Relative Address IF Bit Set In Direct Page Offset
  andi t0,s5,P_FLAG             // DP = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  lb t1,2(a2)                   // T1 = Relative
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = DP
  andi t0,2                     // DP &= BIT
  beqz t0,BBS1SPC               // IF (DP & BIT) PC_REG += Relative
  addiu s3,2                    // PC_REG += 2 (Delay Slot)
  add s3,t1                     // PC_REG += Relative
  addiu v0,2                    // Cycles += 2
  BBS1SPC:
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $24 AND   A, dp            Logical AND Value In Direct Page Offset With A
  andi t0,s5,P_FLAG             // DP = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = DP
  and s0,t0                     // A_REG &= DP
  andi t0,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s0,ANDADPSPC             // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  ANDADPSPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,3                    // Cycles += 3 (Delay Slot)

align(256)
  // $25 AND   A, !abs          Logical AND Value From Absolute Address With A
  lbu t0,1(a2)                  // ABS = MEM_MAP[Absolute]
  lbu t1,2(a2)
  sll t1,8
  or t0,t1                      // T0 = Absolute
  addu a2,a0,t0                 // A2 = MEM_MAP + Absolute
  lbu t0,0(a2)                  // T0 = ABS
  and s0,t0                     // A_REG &= ABS
  andi t0,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s0,ANDAABSSPC            // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  ANDAABSSPC:
  addiu s3,2                    // PC_REG += 2
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $26 AND   A, (X)            Logical AND Value X With A
  andi t0,s5,P_FLAG             // (X) = MEM_MAP[X_REG | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  or t0,s1                      // T0 = X_REG | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (X_REG | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = (X)
  and s0,t0                     // A_REG &= (X)
  andi t0,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s0,ANDAXSPC              // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  ANDAXSPC:
  jr ra
  addiu v0,3                    // Cycles += 3 (Delay Slot)

align(256)
  // $27 AND   A, [dp+X]        Logical AND Value From Indirect Absolute Address In Direct Page Offset Added With Value X With A
  andi t0,s5,P_FLAG             // DPXI = MEM_MAP[MEM_MAP[((Immediate + X_REG) & $FF) | (P_FLAG << 3)]]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  addu t1,s1                    // T1 = Immediate + X_REG
  andi t1,$FF                   // T1 = (Immediate + X_REG) & $FF
  or t0,t1                      // T0 = ((Immediate + X_REG) & $FF) | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + ((Immediate + X_REG) & $FF) | (P_FLAG << 3)
  lbu t0,0(a2)
  lbu t1,1(a2)
  srl t1,8
  or t0,t1                      // T0 = MEM_MAP[((Immediate + X_REG) & $FF) | (P_FLAG << 3)]
  addu a2,a0,t0                 // A2 = MEM_MAP + MEM_MAP[((Immediate + X_REG) & $FF) | (P_FLAG << 3)]
  lbu t0,0(a2)                  // T0 = DPXI
  and s0,t0                     // A_REG &= DPXI
  andi t0,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s0,ANDADPXISPC           // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  ANDADPXISPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,6                    // Cycles += 6 (Delay Slot)

align(256)
  // $28 AND   A, #imm          Logical AND Immediate Value With A
  lbu t0,1(a2)                  // T0 = Immediate
  and s0,t0                     // A_REG &= Immediate
  andi t0,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s0,ANDAIMMSPC            // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  ANDAIMMSPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,2                    // Cycles += 2 (Delay Slot)

align(256)
  // $29 AND   dp, dp            Logical AND Value In Direct Page Offset With Direct Page Offset
  andi t0,s5,P_FLAG             // DPB = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t1,t0                      // T1 = Immediate | (P_FLAG << 3)
  addu a3,a0,t1                 // A3 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu t1,0(a3)                  // T1 = DPB
  lbu t2,2(a2)                  // DPA = MEM_MAP[DirectPage | (P_FLAG << 3)]
  or t0,t2                      // T0 = DirectPage | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (DirectPage | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = DPA
  and t0,t1                     // DPA &= DPB
  sb t0,0(a2)                   // Store DPA
  andi t1,t0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t1                      // PSW_REG: N Flag = Result MSB
  beqz t0,ANDDPDPSPC            // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  ANDDPDPSPC:
  addiu s3,2                    // PC_REG += 2
  jr ra
  addiu v0,6                    // Cycles += 6 (Delay Slot)

align(256)
  // $2A OR1   C, /mem.bit      OR Carry Flag With Complemented Memory Bit
  lbu t0,1(a2)                  // MEMBIT = (MEM_MAP[MEM] >> BIT) & 1
  lbu t1,2(a2)
  sll t1,8
  or t0,t1                      // T0 = Absolute
  srl t1,t0,13                  // T1 = BIT (Absolute >> 13)
  andi t0,$1FFF                 // T0 = MEM (Absolute & 0x1FFF)
  addu a2,a0,t0                 // A2 = MEM_MAP + MEM
  lbu t0,0(a2)                  // T0 = MEM_MAP[MEM]
  srlv t0,t1                    // T0 = MEM_MAP[MEM] >> BIT
  andi t0,1                     // T0 = MEMBIT
  not t0                        // T0 = ~MEMBIT
  or s5,t0                      // PSW_REG |= ~MEMBIT
  addiu s3,2                    // PC_REG += 2
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $2B ROL   dp               ROtate Left Value In Direct Page Offset Into Carry Flag
  andi t0,s5,P_FLAG             // DP = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = DP
  andi t1,t0,$80                // C Flag Set To Old MSB
  srl t1,7
  sll t0,1                      // DP <<= 1
  andi t2,s5,C_FLAG             // T2 = C_FLAG
  or t0,t2                      // (DP << 1) | C_FLAG
  andi t0,$FF
  sb t0,0(a2)                   // Store DP
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  or s5,t1                      // PSW_REG: C Flag = Old MSB
  andi t1,t0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t1                      // PSW_REG: N Flag = Result MSB
  beqz t0,ROLDPSPC              // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  ROLDPSPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $2C ROL   !abs             ROtate Left Value From Absolute Address Into Carry Flag
  lbu t0,1(a2)                  // ABS = MEM_MAP[Absolute]
  lbu t1,2(a2)
  sll t1,8
  or t0,t1                      // T0 = Absolute
  addu a2,a0,t0                 // A2 = MEM_MAP + Absolute
  lbu t0,0(a2)                  // T0 = ABS
  andi t1,t0,$80                // C Flag Set To Old MSB
  srl t1,7
  sll t0,1                      // ABS <<= 1
  andi t2,s5,C_FLAG             // T2 = C_FLAG
  or t0,t2                      // (ABS << 1) | C_FLAG
  andi t0,$FF
  sb t0,0(a2)                   // Store ABS
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  or s5,t1                      // PSW_REG: C Flag = Old MSB
  andi t1,t0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t1                      // PSW_REG: N Flag = Result MSB
  beqz t0,ROLABSSPC             // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  ROLABSSPC:
  addiu s3,2                    // PC_REG += 2
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $2D PUSH  A                PUSH Register A Onto Stack
  addu a2,a0,s4                 // STACK = MEM_MAP[$100 + SP_REG]
  addiu a2,$100                 // A2 = STACK
  sb s0,0(a2)                   // STACK = A_REG
  subiu s4,1                    // SP_REG--
  andi s4,$FF
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $2E CBNE  dp, rel          Branch To Relative Address IF Value A Is Not Equal To Direct Page Offset
  andi t0,s5,P_FLAG             // DP = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  lb t1,2(a2)                   // T1 = Relative
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = DP
  beq s0,t0,CBNEDPSPC           // IF (A_REG != DP) PC_REG += Relative
  addiu s3,2                    // PC_REG += 2 (Delay Slot)
  add s3,t1                     // PC_REG += Relative
  addiu v0,2                    // Cycles += 2
  CBNEDPSPC:
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $2F BRA   rel              BRAnch To Relative Address
  addiu s3,1                    // PC_REG++
  lb t0,1(a2)                   // T0 = Relative
  add s3,t0                     // PC_REG += Relative
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $30 BMI   rel              Branch To Relative Address IF MInus Set
  andi t0,s5,N_FLAG             // IF (N_FLAG) PC_REG += Relative
  beqz t0,BMISPC
  addiu s3,1                    // PC_REG++ (Delay Slot)
  lb t0,1(a2)                   // T0 = Relative
  add s3,t0                     // PC_REG += Relative
  addiu v0,2                    // Cycles += 2
  BMISPC:
  jr ra
  addiu v0,2                    // Cycles += 2 (Delay Slot)

align(256)
  // $31 TCALL n                Table CALL Push PC Onto Stack Then Jump To Table Address
  subiu s4,2                    // SP_REG -= 2 (Decrement Stack)
  andi s4,$FF
  addu a2,a0,s4                 // STACK = MEM_MAP[$100 + SP_REG]
  addiu a2,$100                 // A2 = STACK
  sb s3,1(a2)                   // STACK = PC_REG
  srl t0,s3,8
  sb t0,2(a2)
  addiu a2,a0,$FFD8             // PC_REG = MEM_MAP[$FFD8]
  lbu s3,0(a2)
  lbu t0,1(a2)
  sll t0,8
  or s3,t0
  jr ra
  addiu v0,8                    // Cycles += 8 (Delay Slot)

align(256)
  // $32 CLR1  dp.bit           CLeaR Bit In Direct Page Offset
  andi t0,s5,P_FLAG             // DP = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = DP
  andi t0,$FD                   // DP &= ^BIT
  sb t0,0(a2)                   // Store DP
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $33 BBC   dp.bit, rel      Branch To Relative Address IF Bit Cleared In Direct Page Offset
  andi t0,s5,P_FLAG             // DP = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  lb t1,2(a2)                   // T1 = Relative
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = DP
  andi t0,2                     // DP &= BIT
  bnez t0,BBC1SPC               // IF (! (DP & BIT)) PC_REG += Relative
  addiu s3,2                    // PC_REG += 2 (Delay Slot)
  add s3,t1                     // PC_REG += Relative
  addiu v0,2                    // Cycles += 2
  BBC1SPC:
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $34 AND   A, dp+X          Logical AND Value In Direct Page Offset Added With Value X With A
  andi t0,s5,P_FLAG             // DPX = MEM_MAP[((Immediate + X_REG) & $FF) | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  addu t1,s1                    // T1 = Immediate + X_REG
  andi t1,$FF                   // T1 = (Immediate + X_REG) & $FF
  or t0,t1                      // T0 = ((Immediate + X_REG) & $FF) | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + ((Immediate + X_REG) & $FF) | (P_FLAG << 3)
  lbu t0,0(a2)                  // T0 = DPX
  and s0,t0                     // A_REG &= DPX
  andi t0,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s0,ANDADPXSPC            // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  ANDADPXSPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $35 AND   A, !abs+X        Logical AND Value From Absolute Address Added With Value X With A
  lbu t0,1(a2)                  // ABSX = MEM_MAP[Absolute + X_REG]
  lbu t1,2(a2)
  sll t1,8
  or t0,t1                      // T0 = Absolute
  addu a2,a0,t0                 // A2 = MEM_MAP + Absolute
  addu a2,s1                    // A2 = MEM_MAP + Absolute + X_REG
  lbu t0,0(a2)                  // T0 = ABSX
  and s0,t0                     // A_REG &= ABSX
  andi t0,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s0,ANDAABSXSPC           // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  ANDAABSXSPC:
  addiu s3,2                    // PC_REG += 2
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $36 AND   A, !abs+Y        Logical AND Value From Absolute Address Added With Value Y With A
  lbu t0,1(a2)                  // ABSY = MEM_MAP[Absolute + Y_REG]
  lbu t1,2(a2)
  sll t1,8
  or t0,t1                      // T0 = Absolute
  addu a2,a0,t0                 // A2 = MEM_MAP + Absolute
  addu a2,s2                    // A2 = MEM_MAP + Absolute + Y_REG
  lbu t0,0(a2)                  // T0 = ABSY
  and s0,t0                     // A_REG &= ABSY
  andi t0,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s0,ANDAABSYSPC           // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  ANDAABSYSPC:
  addiu s3,2                    // PC_REG += 2
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $37 AND   A, [dp]+Y        Logical AND Value From Indirect Absolute Address In Direct Page Offset Added With Value Y With A
  andi t0,s5,P_FLAG             // DPYI = MEM_MAP[MEM_MAP[Immediate) | (P_FLAG << 3)] + Y_REG]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate) | (P_FLAG << 3))
  lbu t0,0(a2)
  lbu t1,1(a2)
  srl t1,8
  or t0,t1                      // T0 = MEM_MAP[Immediate) | (P_FLAG << 3)]
  addu t0,s2                    // T0 = MEM_MAP[Immediate) | (P_FLAG << 3)] + Y_REG
  addu a2,a0,t0                 // A2 = MEM_MAP + MEM_MAP[Immediate) | (P_FLAG << 3) + Y_REG]
  lbu t0,0(a2)                  // T0 = DPYI
  and s0,t0                     // A_REG &= DPYI
  andi t0,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s0,ANDADPYISPC           // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  ANDADPYISPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,6                    // Cycles += 6 (Delay Slot)

align(256)
  // $38 AND   dp, #imm         Logical AND Immediate Value With Direct Page Offset
  andi t0,s5,P_FLAG             // DP = MEM_MAP[DirectPage | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,2(a2)                  // T1 = DirectPage
  or t0,t1                      // T0 = DirectPage | (P_FLAG << 3)
  lbu t1,1(a2)                  // T1 = Immediate
  addu a2,a0,t0                 // A2 = MEM_MAP + (DirectPage | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = DP
  and t0,t1                     // DP &= Immediate
  sb t0,0(a2)                   // Store DP
  andi t1,t0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t1                      // PSW_REG: N Flag = Result MSB
  beqz t0,ANDDPIMMSPC           // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  ANDDPIMMSPC:
  addiu s3,2                    // PC_REG += 2
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $39 AND   (X), (Y)         Logical AND Value Y With X
  andi t0,s5,P_FLAG             // (Y) = MEM_MAP[Y_REG | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  or t1,t0,s2                   // T1 = Y_REG | (P_FLAG << 3)
  addu a3,a0,t1                 // A3 = MEM_MAP + (Y_REG | (P_FLAG << 3))
  lbu t1,0(a3)                  // T1 = (Y)
  or t0,s1                      // (X) = MEM_MAP[X_REG | (P_FLAG << 3)]
  addu a2,a0,t0                 // A2 = MEM_MAP + (X_REG | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = (X)
  and t0,t1                     // (X) &= (Y)
  sb t0,0(a2)                   // Store (X)
  andi t1,t0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t1                      // PSW_REG: N Flag = Result MSB
  beqz t0,ANDXYSPC              // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  ANDXYSPC:
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $3A INCW  dp                INCrement Word In Direct Page Offset
  andi t0,s5,P_FLAG             // DPW = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu t0,0(a2)
  lbu t1,1(a2)
  sll t1,8
  or t0,t1                      // T0 = DPW
  addiu t0,1                    // DPW++
  andi t0,$FFFF
  sb t0,0(a2)                   // Store DPW
  srl t1,t0,8
  sb t1,1(a2)
  andi t1,$80                   // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t1                      // PSW_REG: N Flag = Result MSB
  beqz t0,INCWDPSPC             // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  INCWDPSPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,6                    // Cycles += 6 (Delay Slot)

align(256)
  // $3B ROL   dp+X             ROtate Left Value In Direct Page Offset Added With Value X Into Carry Flag
  andi t0,s5,P_FLAG             // DPX = MEM_MAP[((Immediate + X_REG) & $FF) | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  addu t1,s1                    // T1 = Immediate + X_REG
  andi t1,$FF                   // T1 = (Immediate + X_REG) & $FF
  or t0,t1                      // T0 = ((Immediate + X_REG) & $FF) | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + ((Immediate + X_REG) & $FF) | (P_FLAG << 3)
  lbu t0,0(a2)                  // T0 = DPX
  andi t1,t0,$80                // C Flag Set To Old MSB
  srl t1,7
  sll t0,1                      // DPX <<= 1
  andi t2,s5,C_FLAG             // T2 = C_FLAG
  or t0,t2                      // (DPX << 1) | C_FLAG
  andi t0,$FF
  sb t0,0(a2)                   // Store DPX
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  or s5,t1                      // PSW_REG: C Flag = Old MSB
  andi t1,t0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t1                      // PSW_REG: N Flag = Result MSB
  beqz t0,ROLDPXSPC             // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  ROLDPXSPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $3C ROL   A                ROtate Left Register A Into Carry Flag
  andi t0,s0,$80                // C Flag Set To Old MSB
  srl t0,7
  sll s0,1                      // A_REG <<= 1
  andi t1,s5,C_FLAG             // T1 = C_FLAG
  or t0,t1                      // (A_REG << 1) | C_FLAG
  andi s0,$FF
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  or s5,t0                      // PSW_REG: C Flag = Old MSB
  andi t0,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s0,ROLASPC               // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  ROLASPC:
  jr ra
  addiu v0,2                    // Cycles += 2 (Delay Slot)

align(256)
  // $3D INC   X                INCrement Register X
  addiu s1,1                    // X_REG++
  andi s1,$FF
  andi t0,s1,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s1,INCXSPC               // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  INCXSPC:
  jr ra
  addiu v0,2                    // Cycles += 2 (Delay Slot)

align(256)
  // $3E CMP   X, dp            CoMPare Value In Direct Page Offset With X
  andi t0,s5,P_FLAG             // DP = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = DP
  subu t1,s1,t0                 // T1 = X_REG - DP
  andi t1,$FF
  andi t2,t1,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t2                      // PSW_REG: N Flag = Result MSB
  andi t3,s1,$80                // T3 = X_REG & $80
  andi t4,t0,$80                // T4 = DP & $80
  beq t3,t4,CMPXDPVASPC         // IF (X_REG & $80 == DP & $80) &&
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  CMPXDPVASPC:
  bne t3,t2,CMPXDPVBSPC         // IF (X_REG & $80 != (X_REG - DP) & $80)
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  CMPXDPVBSPC:
  beqz t1,CMPXDPZSPC            // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  CMPXDPZSPC:
  bgtu t1,t0,CMPXDPCSPC         // IF ((X_REG - DP) > DP) C Flag Set
  ori s5,C_FLAG                 // PSW_REG: C Flag Set (Delay Slot)
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  CMPXDPCSPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,3                    // Cycles += 3 (Delay Slot)

align(256)
  // $3F CALL  !abs             CALL Push PC Onto Stack Then Jump To Absolute Address
  subiu s4,2                    // SP_REG -= 2 (Decrement Stack)
  andi s4,$FF
  addu a3,a0,s4                 // STACK = MEM_MAP[$100 + SP_REG]
  addiu a3,$100                 // A3 = STACK
  addiu s3,2                    // PC_REG += 2
  sb s3,1(a3)                   // STACK = PC_REG
  srl t0,s3,8
  sb t0,2(a3)
  lbu s3,1(a2)                  // PC_REG = Absolute
  lbu t0,2(a2)
  sll t0,8
  or s3,t0
  jr ra
  addiu v0,8                    // Cycles += 8 (Delay Slot)

align(256)
  // $40 SETP                   SET Direct Page Flag
  ori s5,P_FLAG                 // PSW_REG: P Flag Set
  jr ra
  addiu v0,2                    // Cycles += 2 (Delay Slot)

align(256)
  // $41 TCALL n                Table CALL Push PC Onto Stack Then Jump To Table Address
  subiu s4,2                    // SP_REG -= 2 (Decrement Stack)
  andi s4,$FF
  addu a2,a0,s4                 // STACK = MEM_MAP[$100 + SP_REG]
  addiu a2,$100                 // A2 = STACK
  sb s3,1(a2)                   // STACK = PC_REG
  srl t0,s3,8
  sb t0,2(a2)
  addiu a2,a0,$FFD6             // PC_REG = MEM_MAP[$FFD6]
  lbu s3,0(a2)
  lbu t0,1(a2)
  sll t0,8
  or s3,t0
  jr ra
  addiu v0,8                    // Cycles += 8 (Delay Slot)

align(256)
  // $42 SET1  dp.bit           SET Bit In Direct Page Offset
  andi t0,s5,P_FLAG             // DP = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = DP
  ori t0,4                      // DP |= BIT
  sb t0,0(a2)                   // Store DP
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $43 BBS   dp.bit, rel      Branch To Relative Address IF Bit Set In Direct Page Offset
  andi t0,s5,P_FLAG             // DP = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  lb t1,2(a2)                   // T1 = Relative
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = DP
  andi t0,4                     // DP &= BIT
  beqz t0,BBS2SPC               // IF (DP & BIT) PC_REG += Relative
  addiu s3,2                    // PC_REG += 2 (Delay Slot)
  add s3,t1                     // PC_REG += Relative
  addiu v0,2                    // Cycles += 2
  BBS2SPC:
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $44 EOR   A, dp            Exclusive OR Value In Direct Page Offset With A
  andi t0,s5,P_FLAG             // DP = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = DP
  xor s0,t0                     // A_REG ^= DP
  andi t0,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s0,EORADPSPC             // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  EORADPSPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,3                    // Cycles += 3 (Delay Slot)

align(256)
  // $45 EOR   A, !abs          Exclusive OR Value From Absolute Address With A
  lbu t0,1(a2)                  // ABS = MEM_MAP[Absolute]
  lbu t1,2(a2)
  sll t1,8
  or t0,t1                      // T0 = Absolute
  addu a2,a0,t0                 // A2 = MEM_MAP + Absolute
  lbu t0,0(a2)                  // T0 = ABS
  xor s0,t0                     // A_REG ^= ABS
  andi t0,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s0,EORAABSSPC            // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  EORAABSSPC:
  addiu s3,2                    // PC_REG += 2
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $46 EOR   A, (X)           Exclusive OR Value X With A
  andi t0,s5,P_FLAG             // (X) = MEM_MAP[X_REG | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  or t0,s1                      // T0 = X_REG | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (X_REG | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = (X)
  xor s0,t0                     // A_REG ^= (X)
  andi t0,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s0,EORAXSPC              // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  EORAXSPC:
  jr ra
  addiu v0,3                    // Cycles += 3 (Delay Slot)

align(256)
  // $47 EOR   A, [dp+X]        Exclusive OR Value From Indirect Absolute Address In Direct Page Offset Added With Value X With A
  andi t0,s5,P_FLAG             // DPXI = MEM_MAP[MEM_MAP[((Immediate + X_REG) & $FF) | (P_FLAG << 3)]]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  addu t1,s1                    // T1 = Immediate + X_REG
  andi t1,$FF                   // T1 = (Immediate + X_REG) & $FF
  or t0,t1                      // T0 = ((Immediate + X_REG) & $FF) | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + ((Immediate + X_REG) & $FF) | (P_FLAG << 3)
  lbu t0,0(a2)
  lbu t1,1(a2)
  srl t1,8
  or t0,t1                      // T0 = MEM_MAP[((Immediate + X_REG) & $FF) | (P_FLAG << 3)]
  addu a2,a0,t0                 // A2 = MEM_MAP + MEM_MAP[((Immediate + X_REG) & $FF) | (P_FLAG << 3)]
  lbu t0,0(a2)                  // T0 = DPXI
  xor s0,t0                     // A_REG ^= DPXI
  andi t0,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s0,EORADPXISPC           // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  EORADPXISPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,6                    // Cycles += 6 (Delay Slot)

align(256)
  // $48 EOR   A, #imm          Exclusive OR Immediate Value With A
  lbu t0,1(a2)                  // T0 = Immediate
  xor s0,t0                     // A_REG ^= Immediate
  andi t0,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s0,EORAIMMSPC            // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  EORAIMMSPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,2                    // Cycles += 2 (Delay Slot)

align(256)
  // $49 EOR   dp, dp           Exclusive OR Value In Direct Page Offset With Direct Page Offset
  andi t0,s5,P_FLAG             // DPB = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t1,t0                      // T1 = Immediate | (P_FLAG << 3)
  addu a3,a0,t1                 // A3 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu t1,0(a3)                  // T1 = DPB
  lbu t2,2(a2)                  // DPA = MEM_MAP[DirectPage | (P_FLAG << 3)]
  or t0,t2                      // T0 = DirectPage | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (DirectPage | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = DPA
  xor t0,t1                     // DPA ^= DPB
  sb t0,0(a2)                   // Store DPB
  andi t1,t0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t1                      // PSW_REG: N Flag = Result MSB
  beqz t0,EORDPDPSPC            // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  EORDPDPSPC:
  addiu s3,2                    // PC_REG += 2
  jr ra
  addiu v0,6                    // Cycles += 6 (Delay Slot)

align(256)
  // $4A AND1  C, mem.bit       AND Carry Flag With Memory Bit
  lbu t0,1(a2)                  // MEMBIT = (MEM_MAP[MEM] >> BIT) & 1
  lbu t1,2(a2)
  sll t1,8
  or t0,t1                      // T0 = Absolute
  srl t1,t0,13                  // T1 = BIT (Absolute >> 13)
  andi t0,$1FFF                 // T0 = MEM (Absolute & 0x1FFF)
  addu a2,a0,t0                 // A2 = MEM_MAP + MEM
  lbu t0,0(a2)                  // T0 = MEM_MAP[MEM]
  srlv t0,t1                    // T0 = MEM_MAP[MEM] >> BIT
  andi t0,1                     // T0 = MEMBIT
  addiu t0,$FE                  // T0 = MEMBIT + $FE
  and s5,t0                     // C_FLAG &= MEMBIT
  addiu s3,2                    // PC_REG += 2
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $4B LSR   dp               Logical Shift Right Value In Direct Page Offset Into Carry Flag
  andi t0,s5,P_FLAG             // DP = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = DP
  andi t1,t0,$80                // C Flag Set To Old MSB
  srl t1,7
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  or s5,t1                      // PSW_REG: C Flag = Old MSB
  srl t0,1                      // DP >>= 1
  sb t0,0(a2)                   // Store DP
  andi t1,t0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t1                      // PSW_REG: N Flag = Result MSB
  beqz t0,LSRDPSPC              // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  LSRDPSPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $4C LSR   !abs             Logical Shift Right Value From Absolute Address Into Carry Flag
  lbu t0,1(a2)                  // ABS = MEM_MAP[Absolute]
  lbu t1,2(a2)
  sll t1,8
  or t0,t1                      // T0 = Absolute
  addu a2,a0,t0                 // A2 = MEM_MAP + Absolute
  lbu t0,0(a2)                  // T0 = ABS
  andi t1,t0,$80                // C Flag Set To Old MSB
  srl t1,7
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  or s5,t1                      // PSW_REG: C Flag = Old MSB
  srl t0,1                      // ABS >>= 1
  sb t0,0(a2)                   // Store ABS
  andi t1,t0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t1                      // PSW_REG: N Flag = Result MSB
  beqz t0,LSRABSSPC             // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  LSRABSSPC:
  addiu s3,2                    // PC_REG += 2
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $4D PUSH  X                PUSH Register X Onto Stack
  addu a2,a0,s4                 // STACK = MEM_MAP[$100 + SP_REG]
  addiu a2,$100                 // A2 = STACK
  sb s1,0(a2)                   // STACK = X_REG
  subiu s4,1                    // SP_REG--
  andi s4,$FF
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $4E TCLR1 !abs             Test & CLeaR Bits In Absolute Address With A
  lbu t0,1(a2)                  // ABS = MEM_MAP[Absolute]
  lbu t1,2(a2)
  sll t1,8
  or t0,t1                      // T0 = Absolute
  addu a2,a0,t0                 // A2 = MEM_MAP + Absolute
  lbu t0,0(a2)                  // T0 = ABS
  subu t1,s0,t0                 // T1 = A - ABS
  and t1,$FF
  andi t2,t1,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t2                      // PSW_REG: N Flag = Result MSB
  beqz t1,TCLR1ABSSPC           // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  TCLR1ABSSPC:
  not t1,s0                     // T1 = ~A_REG
  and t0,t1                     // ABS &= ~A_REG
  sb t0,0(a2)                   // Store ABS
  addiu s3,2                    // PC_REG += 2
  jr ra
  addiu v0,6                    // Cycles += 6 (Delay Slot)

align(256)
  // $4F PCALL upage            UPage CALL Push PC Onto Stack Then Jump To UPage
  subiu s4,2                    // SP_REG -= 2 (Decrement Stack)
  andi s4,$FF
  addu a3,a0,s4                 // STACK = MEM_MAP[$100 + SP_REG]
  addiu a3,$100                 // A3 = STACK
  addiu s3,1                    // PC_REG++
  sb s3,1(a3)                   // STACK = PC_REG
  srl t0,s3,8
  sb t0,2(a3)
  lbu s3,1(a2)                  // PC_REG = $FF00 | Immediate
  ori s3,$FF00
  jr ra
  addiu v0,6                    // Cycles += 6 (Delay Slot)

align(256)
  // $50 BVC   rel              Branch To Relative Address IF OVerflow Cleared
  andi t0,s5,V_FLAG             // IF (! V_FLAG) PC_REG += Relative
  bnez t0,BVCSPC
  addiu s3,1                    // PC_REG++ (Delay Slot)
  lb t0,1(a2)                   // T0 = Relative
  add s3,t0                     // PC_REG += Relative
  addiu v0,2                    // Cycles += 2
  BVCSPC:
  jr ra
  addiu v0,2                    // Cycles += 2 (Delay Slot)

align(256)
  // $51 TCALL n                Table CALL Push PC Onto Stack Then Jump To Table Address
  subiu s4,2                    // SP_REG -= 2 (Decrement Stack)
  andi s4,$FF
  addu a2,a0,s4                 // STACK = MEM_MAP[$100 + SP_REG]
  addiu a2,$100                 // A2 = STACK
  sb s3,1(a2)                   // STACK = PC_REG
  srl t0,s3,8
  sb t0,2(a2)
  addiu a2,a0,$FFD4             // PC_REG = MEM_MAP[$FFD4]
  lbu s3,0(a2)
  lbu t0,1(a2)
  sll t0,8
  or s3,t0
  jr ra
  addiu v0,8                    // Cycles += 8 (Delay Slot)

align(256)
  // $52 CLR1  dp.bit           CLeaR Bit In Direct Page Offset
  andi t0,s5,P_FLAG             // DP = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = DP
  andi t0,$FB                   // DP &= ^BIT
  sb t0,0(a2)                   // Store DP
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $53 BBC   dp.bit, rel      Branch To Relative Address IF Bit Cleared In Direct Page Offset
  andi t0,s5,P_FLAG             // DP = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  lb t1,2(a2)                   // T1 = Relative
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = DP
  andi t0,4                     // DP &= BIT
  bnez t0,BBC2SPC               // IF (! (DP & BIT)) PC_REG += Relative
  addiu s3,2                    // PC_REG += 2 (Delay Slot)
  add s3,t1                     // PC_REG += Relative
  addiu v0,2                    // Cycles += 2
  BBC2SPC:
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $54 EOR   A, dp+X          Exclusive OR Value In Direct Page Offset Added With Value X With A
  andi t0,s5,P_FLAG             // DPX = MEM_MAP[((Immediate + X_REG) & $FF) | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  addu t1,s1                    // T1 = Immediate + X_REG
  andi t1,$FF                   // T1 = (Immediate + X_REG) & $FF
  or t0,t1                      // T0 = ((Immediate + X_REG) & $FF) | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + ((Immediate + X_REG) & $FF) | (P_FLAG << 3)
  lbu t0,0(a2)                  // T0 = DPX
  xor s0,t0                     // A_REG ^= DPX
  andi t0,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s0,EORADPXSPC            // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  EORADPXSPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $55 EOR   A, !abs+X        Exclusive OR Value From Absolute Address Added With Value X With A
  lbu t0,1(a2)                  // ABSX = MEM_MAP[Absolute + X_REG]
  lbu t1,2(a2)
  sll t1,8
  or t0,t1                      // T0 = Absolute
  addu a2,a0,t0                 // A2 = MEM_MAP + Absolute
  addu a2,s1                    // A2 = MEM_MAP + Absolute + X_REG
  lbu t0,0(a2)                  // T0 = ABSX
  xor s0,t0                     // A_REG ^= ABSX
  andi t0,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s0,EORAABSXSPC           // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  EORAABSXSPC:
  addiu s3,2                    // PC_REG += 2
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $56 EOR   A, !abs+Y        Exclusive OR Value From Absolute Address Added With Value Y With A
  lbu t0,1(a2)                  // ABSY = MEM_MAP[Absolute + Y_REG]
  lbu t1,2(a2)
  sll t1,8
  or t0,t1                      // T0 = Absolute
  addu a2,a0,t0                 // A2 = MEM_MAP + Absolute
  addu a2,s2                    // A2 = MEM_MAP + Absolute + Y_REG
  lbu t0,0(a2)                  // T0 = ABSY
  xor s0,t0                     // A_REG ^= ABSY
  andi t0,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s0,EORAABSYSPC           // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  EORAABSYSPC:
  addiu s3,2                    // PC_REG += 2
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $57 EOR   A, [dp]+Y        Exclusive OR Value From Indirect Absolute Address In Direct Page Offset Added With Value Y With A
  andi t0,s5,P_FLAG             // DPYI = MEM_MAP[MEM_MAP[Immediate) | (P_FLAG << 3)] + Y_REG]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate) | (P_FLAG << 3))
  lbu t0,0(a2)
  lbu t1,1(a2)
  srl t1,8
  or t0,t1                      // T0 = MEM_MAP[Immediate) | (P_FLAG << 3)]
  addu t0,s2                    // T0 = MEM_MAP[Immediate) | (P_FLAG << 3)] + Y_REG
  addu a2,a0,t0                 // A2 = MEM_MAP + MEM_MAP[Immediate) | (P_FLAG << 3) + Y_REG]
  lbu t0,0(a2)                  // T0 = DPYI
  xor s0,t0                     // A_REG ^= DPYI
  andi t0,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s0,EORADPYISPC           // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  EORADPYISPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,6                    // Cycles += 6 (Delay Slot)

align(256)
  // $58 EOR   dp, #imm         Exclusive OR Immediate Value With Direct Page Offset
  andi t0,s5,P_FLAG             // DP = MEM_MAP[DirectPage | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,2(a2)                  // T1 = DirectPage
  or t0,t1                      // T0 = DirectPage | (P_FLAG << 3)
  lbu t1,1(a2)                  // T1 = Immediate
  addu a2,a0,t0                 // A2 = MEM_MAP + (DirectPage | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = DP
  xor t0,t1                     // DP ^= Immediate
  sb t0,0(a2)                   // Store DP
  andi t1,t0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t1                      // PSW_REG: N Flag = Result MSB
  beqz t0,EORDPIMMSPC           // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  EORDPIMMSPC:
  addiu s3,2                    // PC_REG += 2
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $59 EOR   (X), (Y)         Exclusive OR Value Y With X
  andi t0,s5,P_FLAG             // (Y) = MEM_MAP[Y_REG | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  or t1,t0,s2                   // T1 = Y_REG | (P_FLAG << 3)
  addu a3,a0,t1                 // A3 = MEM_MAP + (Y_REG | (P_FLAG << 3))
  lbu t1,0(a3)                  // T1 = (Y)
  or t0,s1                      // (X) = MEM_MAP[X_REG | (P_FLAG << 3)]
  addu a2,a0,t0                 // A2 = MEM_MAP + (X_REG | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = (X)
  xor t0,t1                     // (X) ^= (Y)
  sb t0,0(a2)                   // Store (X)
  andi t1,t0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t1                      // PSW_REG: N Flag = Result MSB
  beqz t0,EORXYSPC              // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  EORXYSPC:
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $5A CMPW  YA, dp           CoMPare Value In Direct Page Offset With YA
  andi t0,s5,P_FLAG             // DPW = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu t0,0(a2)
  lbu t1,1(a2)
  sll t1,8
  or t0,t1                      // T0 = DPW
  move t1,s2                    // YA_REG = (Y_REG << 8) | A_REG
  sll t1,8
  or t1,s0                      // T1 = YA_REG
  subu t1,t0                    // T1 = YA_REG - DPW
  andi t1,$FFFF
  andi t2,t1,$8000              // Test Negative MSB
  srl t2,8
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t2                      // PSW_REG: N Flag = Result MSB
  beqz t1,CMPWYADPZSPC          // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  CMPWYADPZSPC:
  bgtu t1,t0,CMPWYADPCSPC       // IF ((YA_REG - DPW) > DPW) C Flag Set
  ori s5,C_FLAG                 // PSW_REG: C Flag Set (Delay Slot)
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  CMPWYADPCSPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $5B LSR   dp+X             Logical Shift Right Value In Direct Page Offset Added With Value X Into Carry Flag
  andi t0,s5,P_FLAG             // DPX = MEM_MAP[((Immediate + X_REG) & $FF) | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  addu t1,s1                    // T1 = Immediate + X_REG
  andi t1,$FF                   // T1 = (Immediate + X_REG) & $FF
  or t0,t1                      // T0 = ((Immediate + X_REG) & $FF) | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + ((Immediate + X_REG) & $FF) | (P_FLAG << 3)
  lbu t0,0(a2)                  // T0 = DPX
  andi t1,t0,$80                // C Flag Set To Old MSB
  srl t1,7
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  or s5,t1                      // PSW_REG: C Flag = Old MSB
  srl t0,1                      // DPX >>= 1
  sb t0,0(a2)                   // Store DPX
  andi t1,t0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t1                      // PSW_REG: N Flag = Result MSB
  beqz t0,LSRDPXSPC             // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  LSRDPXSPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $5C LSR   A                Logical Shift Right Register A Into Carry Flag
  andi t0,s0,$80                // C Flag Set To Old MSB
  srl t0,7
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  or s5,t0                      // PSW_REG: C Flag = Old MSB
  srl s0,1                      // A_REG >>= 1
  andi t0,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s0,LSRASPC               // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  LSRASPC:
  jr ra
  addiu v0,2                    // Cycles += 2 (Delay Slot)

align(256)
  // $5D MOV   X, A             MOVe Value A Into X
  move s1,s0                    // X_REG = A_REG
  andi t0,s1,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s1,MOVXASPC              // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  MOVXASPC:
  jr ra
  addiu v0,2                    // Cycles += 2 (Delay Slot)

align(256)
  // $5E CMP   Y, !abs          CoMPare Value From Absolute Address With Y
  lbu t0,1(a2)                  // ABS = MEM_MAP[Absolute]
  lbu t1,2(a2)
  sll t1,8
  or t0,t1                      // T0 = Absolute
  addu a2,a0,t0                 // A2 = MEM_MAP + Absolute
  lbu t0,0(a2)                  // T0 = ABS
  subu t1,s2,t0                 // T1 = Y_REG - ABS
  andi t1,$FF
  andi t2,t1,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t2                      // PSW_REG: N Flag = Result MSB
  andi t3,s2,$80                // T3 = Y_REG & $80
  andi t4,t0,$80                // T4 = ABS & $80
  beq t3,t4,CMPYABSVASPC        // IF (Y_REG & $80 == ABS & $80) &&
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  CMPYABSVASPC:
  bne t3,t2,CMPYABSVBSPC        // IF (Y_REG & $80 != (X_REG - ABS) & $80)
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  CMPYABSVBSPC:
  beqz t1,CMPYABSZSPC           // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  CMPYABSZSPC:
  bgtu t1,t0,CMPYABSCSPC        // IF ((Y_REG - ABS) > ABS) C Flag Set
  ori s5,C_FLAG                 // PSW_REG: C Flag Set (Delay Slot)
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  CMPYABSCSPC:
  addiu s3,2                    // PC_REG += 2
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $5F JMP   !abs             JuMP To Absolute Address
  lbu s3,1(a2)                  // PC_REG = Absolute
  lbu t0,2(a2)
  sll t0,8
  or s3,t0
  jr ra
  addiu v0,3                    // Cycles += 3 (Delay Slot)

align(256)
  // $60 CLRC                   CLeaR Carry Flag
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  jr ra
  addiu v0,2                    // Cycles += 2 (Delay Slot)

align(256)
  // $61 TCALL n                Table CALL Push PC Onto Stack Then Jump To Table Address
  subiu s4,2                    // SP_REG -= 2 (Decrement Stack)
  andi s4,$FF
  addu a2,a0,s4                 // STACK = MEM_MAP[$100 + SP_REG]
  addiu a2,$100                 // A2 = STACK
  sb s3,1(a2)                   // STACK = PC_REG
  srl t0,s3,8
  sb t0,2(a2)
  addiu a2,a0,$FFD2             // PC_REG = MEM_MAP[$FFD2]
  lbu s3,0(a2)
  lbu t0,1(a2)
  sll t0,8
  or s3,t0
  jr ra
  addiu v0,8                    // Cycles += 8 (Delay Slot)

align(256)
  // $62 SET1  dp.bit           SET Bit In Direct Page Offset
  andi t0,s5,P_FLAG             // DP = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = DP
  ori t0,8                      // DP |= BIT
  sb t0,0(a2)                   // Store DP
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $63 BBS   dp.bit, rel      Branch To Relative Address IF Bit Set In Direct Page Offset
  andi t0,s5,P_FLAG             // DP = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  lb t1,2(a2)                   // T1 = Relative
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = DP
  andi t0,8                     // DP &= BIT
  beqz t0,BBS3SPC               // IF (DP & BIT) PC_REG += Relative
  addiu s3,2                    // PC_REG += 2 (Delay Slot)
  add s3,t1                     // PC_REG += Relative
  addiu v0,2                    // Cycles += 2
  BBS3SPC:
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $64 CMP   A, dp            CoMPare Value In Direct Page Offset With A
  andi t0,s5,P_FLAG             // DP = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = DP
  subu t1,s0,t0                 // T1 = A_REG - DP
  andi t1,$FF
  andi t2,t1,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t2                      // PSW_REG: N Flag = Result MSB
  andi t3,s0,$80                // T3 = A_REG & $80
  andi t4,t0,$80                // T4 = DP & $80
  beq t3,t4,CMPADPVASPC         // IF (A_REG & $80 == DP & $80) &&
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  CMPADPVASPC:
  bne t3,t2,CMPADPVBSPC         // IF (A_REG & $80 != (A_REG - DP) & $80)
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  CMPADPVBSPC:
  beqz t1,CMPADPZSPC            // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  CMPADPZSPC:
  bgtu t1,t0,CMPADPCSPC         // IF ((A_REG - DP) > DP) C Flag Set
  ori s5,C_FLAG                 // PSW_REG: C Flag Set (Delay Slot)
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  CMPADPCSPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,3                    // Cycles += 3 (Delay Slot)

align(256)
  // $65 CMP   A, !abs          CoMPare Value From Absolute Address With A
  lbu t0,1(a2)                  // ABS = MEM_MAP[Absolute]
  lbu t1,2(a2)
  sll t1,8
  or t0,t1                      // T0 = Absolute
  addu a2,a0,t0                 // A2 = MEM_MAP + Absolute
  lbu t0,0(a2)                  // T0 = ABS
  subu t1,s0,t0                 // T1 = A_REG - ABS
  andi t1,$FF
  andi t2,t1,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t2                      // PSW_REG: N Flag = Result MSB
  andi t3,s0,$80                // T3 = A_REG & $80
  andi t4,t0,$80                // T4 = ABS & $80
  beq t3,t4,CMPAABSVASPC        // IF (A_REG & $80 == ABS & $80) &&
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  CMPAABSVASPC:
  bne t3,t2,CMPAABSVBSPC        // IF (A_REG & $80 != (A_REG - ABS) & $80)
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  CMPAABSVBSPC:
  beqz t1,CMPAABSZSPC           // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  CMPAABSZSPC:
  bgtu t1,t0,CMPAABSCSPC        // IF ((A_REG - ABS) > ABS) C Flag Set
  ori s5,C_FLAG                 // PSW_REG: C Flag Set (Delay Slot)
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  CMPAABSCSPC:
  addiu s3,2                    // PC_REG += 2
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $66 CMP   A, (X)           CoMPare Value X With A
  andi t0,s5,P_FLAG             // (X) = MEM_MAP[X_REG | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  or t0,s1                      // T0 = X_REG | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (X_REG | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = (X)
  subu t1,s0,t0                 // T1 = A_REG - (X)
  andi t1,$FF
  andi t2,t1,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t2                      // PSW_REG: N Flag = Result MSB
  andi t3,s0,$80                // T3 = A_REG & $80
  andi t4,t0,$80                // T4 = (X) & $80
  beq t3,t4,CMPAXVASPC          // IF (A_REG & $80 == (X) & $80) &&
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  CMPAXVASPC:
  bne t3,t2,CMPAXVBSPC          // IF (A_REG & $80 != (A_REG - (X)) & $80)
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  CMPAXVBSPC:
  beqz t1,CMPAXZSPC             // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  CMPAXZSPC:
  bgtu t1,t0,CMPAXCSPC          // IF ((A_REG - (X)) > (X)) C Flag Set
  ori s5,C_FLAG                 // PSW_REG: C Flag Set (Delay Slot)
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  CMPAXCSPC:
  jr ra
  addiu v0,3                    // Cycles += 3 (Delay Slot)

align(256)
  // $67 CMP   A, [dp+X]        CoMPare Value From Indirect Absolute Address In Direct Page Offset Added With Value X With A
  andi t0,s5,P_FLAG             // DPXI = MEM_MAP[MEM_MAP[((Immediate + X_REG) & $FF) | (P_FLAG << 3)]]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  addu t1,s1                    // T1 = Immediate + X_REG
  andi t1,$FF                   // T1 = (Immediate + X_REG) & $FF
  or t0,t1                      // T0 = ((Immediate + X_REG) & $FF) | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + ((Immediate + X_REG) & $FF) | (P_FLAG << 3)
  lbu t0,0(a2)
  lbu t1,1(a2)
  srl t1,8
  or t0,t1                      // T0 = MEM_MAP[((Immediate + X_REG) & $FF) | (P_FLAG << 3)]
  addu a2,a0,t0                 // A2 = MEM_MAP + MEM_MAP[((Immediate + X_REG) & $FF) | (P_FLAG << 3)]
  lbu t0,0(a2)                  // T0 = DPXI
  subu t1,s0,t0                 // T1 = A_REG - DPXI
  andi t1,$FF
  andi t2,t1,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t2                      // PSW_REG: N Flag = Result MSB
  andi t3,s0,$80                // T3 = A_REG & $80
  andi t4,t0,$80                // T4 = DPXI & $80
  beq t3,t4,CMPADPXIVASPC       // IF (A_REG & $80 == DPXI & $80) &&
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  CMPADPXIVASPC:
  bne t3,t2,CMPADPXIVBSPC       // IF (A_REG & $80 != (A_REG - DPXI) & $80)
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  CMPADPXIVBSPC:
  beqz t1,CMPADPXIZSPC          // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  CMPADPXIZSPC:
  bgtu t1,t0,CMPADPXICSPC       // IF ((A_REG - DPXI) > DPXI) C Flag Set
  ori s5,C_FLAG                 // PSW_REG: C Flag Set (Delay Slot)
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  CMPADPXICSPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,6                    // Cycles += 6 (Delay Slot)

align(256)
  // $68 CMP   A, #imm          CoMPare Immediate Value With A
  lbu t0,1(a2)                  // T0 = Immediate
  subu t1,s0,t0                 // T1 = A_REG - Immediate
  andi t1,$FF
  andi t2,t1,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t2                      // PSW_REG: N Flag = Result MSB
  andi t3,s0,$80                // T3 = A_REG & $80
  andi t4,t0,$80                // T4 = Immediate & $80
  beq t3,t4,CMPAIMMVASPC        // IF (A_REG & $80 == Immediate & $80) &&
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  CMPAIMMVASPC:
  bne t3,t2,CMPAIMMVBSPC        // IF (A_REG & $80 != (A_REG - Immediate) & $80)
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  CMPAIMMVBSPC:
  beqz t1,CMPAIMMZSPC           // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  CMPAIMMZSPC:
  bgtu t1,t0,CMPAIMMCSPC        // IF ((A_REG - Immediate) > Immediate) C Flag Set
  ori s5,C_FLAG                 // PSW_REG: C Flag Set (Delay Slot)
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  CMPAIMMCSPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,2                    // Cycles += 2 (Delay Slot)

align(256)
  // $69 CMP   dp, dp           CoMPare Value In Direct Page Offset With Direct Page Offset
  andi t0,s5,P_FLAG             // DPB = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t1,t0                      // T1 = Immediate | (P_FLAG << 3)
  addu a3,a0,t1                 // A3 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu t1,0(a3)                  // T1 = DPB
  lbu t2,2(a2)                  // DPA = MEM_MAP[DirectPage | (P_FLAG << 3)]
  or t0,t2                      // T0 = DirectPage | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (DirectPage | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = DPA
  subu t2,t0,t1                 // T2 = DPA - DPB
  andi t2,$FF
  andi t3,t2,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t3                      // PSW_REG: N Flag = Result MSB
  andi t4,s0,$80                // T4 = DPA & $80
  andi t5,t0,$80                // T5 = DPB & $80
  beq t4,t5,CMPDPDPVASPC        // IF (DPA & $80 == DPB & $80) &&
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  CMPDPDPVASPC:
  bne t4,t3,CMPDPDPVBSPC        // IF (DPA & $80 != (DPA - DPB) & $80)
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  CMPDPDPVBSPC:
  beqz t2,CMPDPDPZSPC           // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  CMPDPDPZSPC:
  bgtu t2,t1,CMPDPDPCSPC        // IF (DPA - DPB) > DPB) C Flag Set
  ori s5,C_FLAG                 // PSW_REG: C Flag Set (Delay Slot)
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  CMPDPDPCSPC:
  addiu s3,2                    // PC_REG += 2
  jr ra
  addiu v0,6                    // Cycles += 6 (Delay Slot)

align(256)
  // $6A AND1  C, /mem.bit      AND Carry Flag With Complemented Memory Bit
  lbu t0,1(a2)                  // MEMBIT = (MEM_MAP[MEM] >> BIT) & 1
  lbu t1,2(a2)
  sll t1,8
  or t0,t1                      // T0 = Absolute
  srl t1,t0,13                  // T1 = BIT (Absolute >> 13)
  andi t0,$1FFF                 // T0 = MEM (Absolute & 0x1FFF)
  addu a2,a0,t0                 // A2 = MEM_MAP + MEM
  lbu t0,0(a2)                  // T0 = MEM_MAP[MEM]
  srlv t0,t1                    // T0 = MEM_MAP[MEM] >> BIT
  andi t0,1                     // T0 = MEMBIT
  not t0                        // T0 = ~MEMBIT
  and s5,t0                     // C_FLAG &= ~MEMBIT
  addiu s3,2                    // PC_REG += 2
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $6B ROR   dp               ROtate Right Value In Direct Page Offset Into Carry Flag
  andi t0,s5,P_FLAG             // DP = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = DP
  andi t1,t0,1                  // C Flag Set To Old LSB
  srl t0,1                      // DP >>= 1
  andi t2,s5,C_FLAG             // T2 = C_FLAG
  sll t2,7                      // T2 = C_FLAG << 7
  or t0,t2                      // (DP >> 1) | C_FLAG << 7
  sb t0,0(a2)                   // Store DP
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  or s5,t1                      // PSW_REG: C Flag = Old LSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t2                      // PSW_REG: N Flag = Result MSB
  beqz t0,RORDPSPC              // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  RORDPSPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $6C ROR   !abs             ROtate Right Value From Absolute Address Into Carry Flag
  lbu t0,1(a2)                  // ABS = MEM_MAP[Absolute]
  lbu t1,2(a2)
  sll t1,8
  or t0,t1                      // T0 = Absolute
  addu a2,a0,t0                 // A2 = MEM_MAP + Absolute
  lbu t0,0(a2)                  // T0 = ABS
  andi t1,t0,1                  // C Flag Set To Old LSB
  srl t0,1                      // ABS >>= 1
  andi t2,s5,C_FLAG             // T2 = C_FLAG
  sll t2,7                      // T2 = C_FLAG << 7
  or t0,t2                      // (ABS >> 1) | C_FLAG << 7
  sb t0,0(a2)                   // Store ABS
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  or s5,t1                      // PSW_REG: C Flag = Old LSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t2                      // PSW_REG: N Flag = Result MSB
  beqz t0,RORABSSPC             // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  RORABSSPC:
  addiu s3,2                    // PC_REG += 2
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $6D PUSH  Y                PUSH Register Y Onto Stack
  addu a2,a0,s4                 // STACK = MEM_MAP[$100 + SP_REG]
  addiu a2,$100                 // A2 = STACK
  sb s2,0(a2)                   // STACK = Y_REG
  subiu s4,1                    // SP_REG--
  andi s4,$FF
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $6E DBNZ  dp, rel          DECrement Direct Page Offset & Branch To Relative Address IF Not Zero
  andi t0,s5,P_FLAG             // DP = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  lb t1,2(a2)                   // T1 = Relative
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = DP
  subiu t0,1                    // DP--
  andi t0,$FF
  sb t0,0(a2)                   // Store DP
  beqz t0,DBNZDPSPC             // IF (DP != 0) PC_REG += Relative
  addiu s3,2                    // PC_REG += 2 (Delay Slot)
  add s3,t1                     // PC_REG += Relative
  addiu v0,2                    // Cycles += 2
  DBNZDPSPC:
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $6F RET                    RETurn From Subroutine POP Absolute Address Off Stack Into PC
  addu a2,a0,s4                 // STACK = MEM_MAP[$100 + SP_REG]
  addiu a2,$100                 // A2 = STACK
  lbu s3,1(a2)                  // PC_REG = STACK
  lbu t0,2(a2)
  sll t0,8
  or s3,t0
  addiu s4,2                    // SP_REG += 2 (Increment Stack)
  andi s4,$FF
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $70 BVS   rel              Branch To Relative Address IF OVerflow Set
  andi t0,s5,V_FLAG             // IF (V_FLAG) PC_REG += Relative
  beqz t0,BVSSPC
  addiu s3,1                    // PC_REG++ (Delay Slot)
  lb t0,1(a2)                   // T0 = Relative
  add s3,t0                     // PC_REG += Relative
  addiu v0,2                    // Cycles += 2
  BVSSPC:
  jr ra
  addiu v0,2                    // Cycles += 2 (Delay Slot)

align(256)
  // $71 TCALL n                Table CALL Push PC Onto Stack Then Jump To Table Address
  subiu s4,2                    // SP_REG -= 2 (Decrement Stack)
  andi s4,$FF
  addu a2,a0,s4                 // STACK = MEM_MAP[$100 + SP_REG]
  addiu a2,$100                 // A2 = STACK
  sb s3,1(a2)                   // STACK = PC_REG
  srl t0,s3,8
  sb t0,2(a2)
  addiu a2,a0,$FFD0             // PC_REG = MEM_MAP[$FFD0]
  lbu s3,0(a2)
  lbu t0,1(a2)
  sll t0,8
  or s3,t0
  jr ra
  addiu v0,8                    // Cycles += 8 (Delay Slot)

align(256)
  // $72 CLR1  dp.bit           CLeaR Bit In Direct Page Offset
  andi t0,s5,P_FLAG             // DP = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = DP
  andi t0,$F7                   // DP &= ^BIT
  sb t0,0(a2)                   // Store DP
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $73 BBC   dp.bit, rel      Branch To Relative Address IF Bit Cleared In Direct Page Offset
  andi t0,s5,P_FLAG             // DP = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  lb t1,2(a2)                   // T1 = Relative
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = DP
  andi t0,8                     // DP &= BIT
  bnez t0,BBC3SPC               // IF (! (DP & BIT)) PC_REG += Relative
  addiu s3,2                    // PC_REG += 2 (Delay Slot)
  add s3,t1                     // PC_REG += Relative
  addiu v0,2                    // Cycles += 2
  BBC3SPC:
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $74 CMP   A, dp+X          CoMPare Value In Direct Page Offset Added With Value X With A
  andi t0,s5,P_FLAG             // DPX = MEM_MAP[((Immediate + X_REG) & $FF) | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  addu t1,s1                    // T1 = Immediate + X_REG
  andi t1,$FF                   // T1 = (Immediate + X_REG) & $FF
  or t0,t1                      // T0 = ((Immediate + X_REG) & $FF) | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + ((Immediate + X_REG) & $FF) | (P_FLAG << 3)
  lbu t0,0(a2)                  // T0 = DPX
  subu t1,s0,t0                 // T1 = A_REG - DPX
  andi t1,$FF
  andi t2,t1,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t2                      // PSW_REG: N Flag = Result MSB
  andi t3,s0,$80                // T3 = A_REG & $80
  andi t4,t0,$80                // T4 = DPX & $80
  beq t3,t4,CMPADPXVASPC        // IF (A_REG & $80 == DPX & $80) &&
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  CMPADPXVASPC:
  bne t3,t2,CMPADPXVBSPC        // IF (A_REG & $80 != (A_REG - DPX) & $80)
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  CMPADPXVBSPC:
  beqz t1,CMPADPXZSPC           // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  CMPADPXZSPC:
  bgtu t1,t0,CMPADPXCSPC        // IF ((A_REG - DPX) > DPX) C Flag Set
  ori s5,C_FLAG                 // PSW_REG: C Flag Set (Delay Slot)
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  CMPADPXCSPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $75 CMP   A, !abs+X        CoMPare Value From Absolute Address Added With Value X With A
  lbu t0,1(a2)                  // ABSX = MEM_MAP[Absolute + X_REG]
  lbu t1,2(a2)
  sll t1,8
  or t0,t1                      // T0 = Absolute
  addu a2,a0,t0                 // A2 = MEM_MAP + Absolute
  addu a2,s1                    // A2 = MEM_MAP + Absolute + X_REG
  lbu t0,0(a2)                  // T0 = ABSX
  subu t1,s0,t0                 // T1 = A_REG - ABSX
  andi t1,$FF
  andi t2,t1,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t2                      // PSW_REG: N Flag = Result MSB
  andi t3,s0,$80                // T3 = A_REG & $80
  andi t4,t0,$80                // T4 = ABSX & $80
  beq t3,t4,CMPAABSXVASPC       // IF (A_REG & $80 == ABSX & $80) &&
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  CMPAABSXVASPC:
  bne t3,t2,CMPAABSXVBSPC       // IF (A_REG & $80 != (A_REG - ABSX) & $80)
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  CMPAABSXVBSPC:
  beqz t1,CMPAABSXZSPC          // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  CMPAABSXZSPC:
  bgtu t1,t0,CMPAABSXCSPC       // IF ((A_REG - ABSX) > ABSX) C Flag Set
  ori s5,C_FLAG                 // PSW_REG: C Flag Set (Delay Slot)
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  CMPAABSXCSPC:
  addiu s3,2                    // PC_REG += 2
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $76 CMP   A, !abs+Y        CoMPare Value From Absolute Address Added With Value Y With A
  lbu t0,1(a2)                  // ABSY = MEM_MAP[Absolute + Y_REG]
  lbu t1,2(a2)
  sll t1,8
  or t0,t1                      // T0 = Absolute
  addu a2,a0,t0                 // A2 = MEM_MAP + Absolute
  addu a2,s2                    // A2 = MEM_MAP + Absolute + Y_REG
  lbu t0,0(a2)                  // T0 = ABSY
  subu t1,s0,t0                 // T1 = A_REG - ABSY
  andi t1,$FF
  andi t2,t1,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t2                      // PSW_REG: N Flag = Result MSB
  andi t3,s0,$80                // T3 = A_REG & $80
  andi t4,t0,$80                // T4 = ABSY & $80
  beq t3,t4,CMPAABSYVASPC       // IF (A_REG & $80 == ABSY & $80) &&
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  CMPAABSYVASPC:
  bne t3,t2,CMPAABSYVBSPC       // IF (A_REG & $80 != (A_REG - ABSY) & $80)
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  CMPAABSYVBSPC:
  beqz t1,CMPAABSYZSPC          // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  CMPAABSYZSPC:
  bgtu t1,t0,CMPAABSYCSPC       // IF ((A_REG - ABSY) > ABSY) C Flag Set
  ori s5,C_FLAG                 // PSW_REG: C Flag Set (Delay Slot)
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  CMPAABSYCSPC:
  addiu s3,2                    // PC_REG += 2
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $77 CMP   A, [dp]+Y        CoMPare Value From Indirect Absolute Address In Direct Page Offset Added With Value Y With A
  andi t0,s5,P_FLAG             // DPYI = MEM_MAP[MEM_MAP[Immediate) | (P_FLAG << 3)] + Y_REG]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate) | (P_FLAG << 3))
  lbu t0,0(a2)
  lbu t1,1(a2)
  srl t1,8
  or t0,t1                      // T0 = MEM_MAP[Immediate) | (P_FLAG << 3)]
  addu t0,s2                    // T0 = MEM_MAP[Immediate) | (P_FLAG << 3)] + Y_REG
  addu a2,a0,t0                 // A2 = MEM_MAP + MEM_MAP[Immediate) | (P_FLAG << 3) + Y_REG]
  lbu t0,0(a2)                  // T0 = DPYI
  subu t1,s0,t0                 // T1 = A_REG - DPYI
  andi t1,$FF
  andi t2,t1,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t2                      // PSW_REG: N Flag = Result MSB
  andi t3,s0,$80                // T3 = A_REG & $80
  andi t4,t0,$80                // T4 = DPYI & $80
  beq t3,t4,CMPADPYIVASPC       // IF (A_REG & $80 == DPYI & $80) &&
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  CMPADPYIVASPC:
  bne t3,t2,CMPADPYIVBSPC       // IF (A_REG & $80 != (A_REG - DPYI) & $80)
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  CMPADPYIVBSPC:
  beqz t1,CMPADPYIZSPC          // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  CMPADPYIZSPC:
  bgtu t1,t0,CMPADPYICSPC       // IF ((A_REG - DPYI) > DPYI) C Flag Set
  ori s5,C_FLAG                 // PSW_REG: C Flag Set (Delay Slot)
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  CMPADPYICSPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,6                    // Cycles += 6 (Delay Slot)

align(256)
  // $78 CMP   dp, #imm         CoMPare Immediate Value With Value In Direct Page Offset
  andi t0,s5,P_FLAG             // DP = MEM_MAP[DirectPage | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,2(a2)                  // T1 = DirectPage
  or t0,t1                      // T0 = DirectPage | (P_FLAG << 3)
  lbu t1,1(a2)                  // T1 = Immediate
  addu a2,a0,t0                 // A2 = MEM_MAP + (DirectPage | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = DP
  subu t2,t0,t1                 // T2 = DP - Immediate
  andi t2,$FF
  andi t3,t2,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t3                      // PSW_REG: N Flag = Result MSB
  andi t4,t0,$80                // T4 = DP & $80
  andi t5,t1,$80                // T5 = Immediate & $80
  beq t4,t5,CMPDPIMMVASPC       // IF (DP & $80 == Immediate & $80) &&
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  CMPDPIMMVASPC:
  bne t4,t3,CMPDPIMMVBSPC       // IF (DP & $80 != (DP - Immediate) & $80)
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  CMPDPIMMVBSPC:
  beqz t2,CMPDPIMMZSPC          // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  CMPDPIMMZSPC:
  bgtu t2,t1,CMPDPIMMCSPC       // IF ((DP - Immediate) > Immediate) C Flag Set
  ori s5,C_FLAG                 // PSW_REG: C Flag Set (Delay Slot)
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  CMPDPIMMCSPC:
  addiu s3,2                    // PC_REG += 2
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $79 CMP   (X), (Y)         CoMPare Value Y With X
  andi t0,s5,P_FLAG             // (Y) = MEM_MAP[Y_REG | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  or t1,t0,s2                   // T1 = Y_REG | (P_FLAG << 3)
  addu a3,a0,t1                 // A3 = MEM_MAP + (Y_REG | (P_FLAG << 3))
  lbu t1,0(a3)                  // T1 = (Y)
  or t0,s1                      // (X) = MEM_MAP[X_REG | (P_FLAG << 3)]
  addu a2,a0,t0                 // A2 = MEM_MAP + (X_REG | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = (X)
  subu t2,t0,t1                 // T2 = (X) - (Y)
  andi t2,$FF
  andi t3,t2,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t3                      // PSW_REG: N Flag = Result MSB
  andi t4,t0,$80                // T4 = DP & $80
  andi t5,t1,$80                // T5 = Immediate & $80
  beq t4,t5,CMPXYVASPC          // IF (DP & $80 == Immediate & $80) &&
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  CMPXYVASPC:
  bne t4,t3,CMPXYVBSPC          // IF (DP & $80 != (DP - Immediate) & $80)
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  CMPXYVBSPC:
  beqz t2,CMPXYZSPC             // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  CMPXYZSPC:
  bgtu t2,t1,CMPXYCSPC          // IF ((DP - Immediate) > Immediate) C Flag Set
  ori s5,C_FLAG                 // PSW_REG: C Flag Set (Delay Slot)
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  CMPXYCSPC:
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $7A ADDW  YA, dp           ADD Word In Direct Page Offset To YA
  andi t0,s5,P_FLAG             // DPW = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu t0,0(a2)
  lbu t1,1(a2)
  sll t1,8
  or t0,t1                      // T0 = DPW
  move t1,s2                    // YA_REG = (Y_REG << 8) | A_REG
  sll t1,8
  or t1,s0                      // T1 = YA_REG
  andi t2,t1,$8000              // T2 = YA_REG & 0x8000
  addu t1,t0                    // T1 = YA_REG + DPW
  andi t1,$FFFF
  andi s0,t1,$FF                // Store YA
  srl s2,t1,8
  andi t3,t1,$8000              // Test Negative MSB
  srl t4,t3,8
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t4                      // PSW_REG: N Flag = Result MSB
  andi t4,t0,$8000              // T4 = DPW & 0x8000
  beq t2,t4,ADDWYADPVASPC       // IF (YA_REG & 0x8000 == DPW & 0x8000) &&
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  ADDWYADPVASPC:
  bne t2,t3,ADDWYADPVBSPC       // IF (YA_REG & 0x8000 != (YA_REG + DPW) & 0x8000)
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  ADDWYADPVBSPC:
  andi t2,t1,$F00               // Test Half Carry
  lli t3,$900
  bgtu t2,t3,ADDWYADPHSPC       // IF ((YA_REG & $F00) > $900) H Flag Set
  ori s5,H_FLAG                 // PSW_REG: H Flag Set (Delay Slot)
  andi s5,~H_FLAG               // PSW_REG: H Flag Reset
  ADDWYADPHSPC:
  beqz t1,ADDWYADPZSPC          // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  ADDWYADPZSPC:
  bltu t1,t0,ADDWYADPCSPC       // IF (YA_REG < DPW) C Flag Set
  ori s5,C_FLAG                 // PSW_REG: C Flag Set (Delay Slot)
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  ADDWYADPCSPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $7B ROR   dp+X             ROtate Right Value In Direct Page Offset Added With Value X Into Carry Flag
  andi t0,s5,P_FLAG             // DPX = MEM_MAP[((Immediate + X_REG) & $FF) | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  addu t1,s1                    // T1 = Immediate + X_REG
  andi t1,$FF                   // T1 = (Immediate + X_REG) & $FF
  or t0,t1                      // T0 = ((Immediate + X_REG) & $FF) | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + ((Immediate + X_REG) & $FF) | (P_FLAG << 3)
  lbu t0,0(a2)                  // T0 = DPX
  andi t1,t0,1                  // C Flag Set To Old LSB
  srl t0,1                      // DPX >>= 1
  andi t2,s5,C_FLAG             // T2 = C_FLAG
  sll t2,7                      // T2 = C_FLAG << 7
  or t0,t2                      // (DPX >> 1) | C_FLAG << 7
  sb t0,0(a2)                   // Store DPX
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  or s5,t1                      // PSW_REG: C Flag = Old LSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t2                      // PSW_REG: N Flag = Result MSB
  beqz t0,RORDPXSPC             // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  RORDPXSPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $7C ROR   A                ROtate Right Register A Into Carry Flag
  andi t0,s5,C_FLAG             // T0 = C_FLAG
  sll t0,7                      // T0 = C_FLAG << 7
  andi t1,s0,1                  // C Flag Set To Old LSB
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  or s5,t1                      // PSW_REG: C Flag = Old LSB
  srl s0,1                      // A_REG >>= 1
  or s0,t0                      // A_REG = (A_REG >> 1) | C_FLAG << 7
  andi t0,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s0,RORASPC               // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  RORASPC:
  jr ra
  addiu v0,2                    // Cycles += 2 (Delay Slot)

align(256)
  // $7D MOV   A, X             MOVe Value X Into A
  move s0,s1                    // A_REG = X_REG
  andi t0,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s0,MOVAXSPC              // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  MOVAXSPC:
  jr ra
  addiu v0,2                    // Cycles += 2 (Delay Slot)

align(256)
  // $7E CMP   Y, dp            CoMPare Value In Direct Page Offset With Y
  andi t0,s5,P_FLAG             // DP = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = DP
  subu t1,s2,t0                 // T1 = Y_REG - DP
  andi t1,$FF
  andi t2,t1,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t2                      // PSW_REG: N Flag = Result MSB
  andi t3,s2,$80                // T3 = Y_REG & $80
  andi t4,t0,$80                // T4 = DP & $80
  beq t3,t4,CMPYDPVASPC         // IF (Y_REG & $80 == DP & $80) &&
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  CMPYDPVASPC:
  bne t3,t2,CMPYDPVBSPC         // IF (Y_REG & $80 != (Y_REG - DP) & $80)
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  CMPYDPVBSPC:
  beqz t1,CMPYDPZSPC            // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  CMPYDPZSPC:
  bgtu t1,t0,CMPYDPCSPC         // IF ((Y_REG - DP) > DP) C Flag Set
  ori s5,C_FLAG                 // PSW_REG: C Flag Set (Delay Slot)
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  CMPYDPCSPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,3                    // Cycles += 3 (Delay Slot)

align(256)
  // $7F RETI                   RETurn From Interrupt POP Flags Off Stack Into PSW POP Absolute Address Off Stack Into PC
  addu a2,a0,s4                 // STACK = MEM_MAP[$100 + SP_REG]
  addiu a2,$100                 // A2 = STACK
  lbu s5,1(a2)                  // PSW_REG = STACK
  lbu s3,2(a2)                  // PC_REG = STACK
  lbu t0,3(a2)
  sll t0,8
  or s3,t0
  addiu s4,3                    // SP_REG += 3 (Increment Stack)
  andi s4,$FF
  jr ra
  addiu v0,6                    // Cycles += 6 (Delay Slot)

align(256)
  // $80 SETC                   SET Carry Flag
  ori s5,C_FLAG                 // PSW_REG: C Flag Set
  jr ra
  addiu v0,2                    // Cycles += 2 (Delay Slot)

align(256)
  // $81 TCALL n                Table CALL Push PC Onto Stack Then Jump To Table Address
  subiu s4,2                    // SP_REG -= 2 (Decrement Stack)
  andi s4,$FF
  addu a2,a0,s4                 // STACK = MEM_MAP[$100 + SP_REG]
  addiu a2,$100                 // A2 = STACK
  sb s3,1(a2)                   // STACK = PC_REG
  srl t0,s3,8
  sb t0,2(a2)
  addiu a2,a0,$FFCE             // PC_REG = MEM_MAP[$FFCE]
  lbu s3,0(a2)
  lbu t0,1(a2)
  sll t0,8
  or s3,t0
  jr ra
  addiu v0,8                    // Cycles += 8 (Delay Slot)

align(256)
  // $82 SET1  dp.bit           SET Bit In Direct Page Offset
  andi t0,s5,P_FLAG             // DP = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = DP
  ori t0,$10                    // DP |= BIT
  sb t0,0(a2)                   // Store DP
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $83 BBS   dp.bit, rel      Branch To Relative Address IF Bit Set In Direct Page Offset
  andi t0,s5,P_FLAG             // DP = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  lb t1,2(a2)                   // T1 = Relative
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = DP
  andi t0,$10                   // DP &= BIT
  beqz t0,BBS4SPC               // IF (DP & BIT) PC_REG += Relative
  addiu s3,2                    // PC_REG += 2 (Delay Slot)
  add s3,t1                     // PC_REG += Relative
  addiu v0,2                    // Cycles += 2
  BBS4SPC:
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $84 ADC   A, dp            ADd Value In Direct Page Offset + Carry Flag To A
  andi t0,s5,P_FLAG             // DP = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = DP
  andi t1,s5,C_FLAG             // T1 = C_FLAG
  andi t2,s0,$80                // T2 = A_REG & 0x80
  addu s0,t0                    // A_REG += DP
  addu s0,t1                    // A_REG += C_FLAG
  andi s0,$FF
  andi t1,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t1                      // PSW_REG: N Flag = Result MSB
  andi t3,t0,$80                // T3 = DP & 0x80
  beq t2,t3,ADCADPVASPC         // IF (A_REG & 0x80 == DP & 0x80) &&
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  ADCADPVASPC:
  bne t2,t1,ADCADPVBSPC         // IF (A_REG & 0x80 != (A_REG + DP + C_FLAG) & 0x80)
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  ADCADPVBSPC:
  andi t1,s0,$F                 // Test Half Carry
  lli t2,9
  bgtu t1,t2,ADCADPHSPC         // IF ((A_REG & $F) > 9) H Flag Set
  ori s5,H_FLAG                 // PSW_REG: H Flag Set (Delay Slot)
  andi s5,~H_FLAG               // PSW_REG: H Flag Reset
  ADCADPHSPC:
  beqz s0,ADCADPZSPC            // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  ADCADPZSPC:
  bltu s0,t0,ADCADPCSPC         // IF (A_REG < DP) C Flag Set
  ori s5,C_FLAG                 // PSW_REG: C Flag Set (Delay Slot)
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  ADCADPCSPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,3                    // Cycles += 3 (Delay Slot)

align(256)
  // $85 ADC   A, !abs          ADd Value From Absolute Address + Carry Flag To A
  lbu t0,1(a2)                  // ABS = MEM_MAP[Absolute]
  lbu t1,2(a2)
  sll t1,8
  or t0,t1                      // T0 = Absolute
  addu a2,a0,t0                 // A2 = MEM_MAP + Absolute
  lbu t0,0(a2)                  // T0 = ABS
  andi t1,s5,C_FLAG             // T1 = C_FLAG
  andi t2,s0,$80                // T2 = A_REG & 0x80
  addu s0,t0                    // A_REG += ABS
  addu s0,t1                    // A_REG += C_FLAG
  andi s0,$FF
  andi t1,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t1                      // PSW_REG: N Flag = Result MSB
  andi t3,t0,$80                // T3 = ABS & 0x80
  beq t2,t3,ADCAABSVASPC        // IF (A_REG & 0x80 == ABS & 0x80) &&
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  ADCAABSVASPC:
  bne t2,t1,ADCAABSVBSPC        // IF (A_REG & 0x80 != (A_REG + ABS + C_FLAG) & 0x80)
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  ADCAABSVBSPC:
  andi t1,s0,$F                 // Test Half Carry
  lli t2,9
  bgtu t1,t2,ADCAABSHSPC        // IF ((A_REG & $F) > 9) H Flag Set
  ori s5,H_FLAG                 // PSW_REG: H Flag Set (Delay Slot)
  andi s5,~H_FLAG               // PSW_REG: H Flag Reset
  ADCAABSHSPC:
  beqz s0,ADCAABSZSPC           // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  ADCAABSZSPC:
  bltu s0,t0,ADCAABSCSPC        // IF (A_REG < ABS) C Flag Set
  ori s5,C_FLAG                 // PSW_REG: C Flag Set (Delay Slot)
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  ADCAABSCSPC:
  addiu s3,2                    // PC_REG += 2
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $86 ADC   A, (X)           ADd Value X + Carry Flag To A
  andi t0,s5,P_FLAG             // (X) = MEM_MAP[X_REG | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  or t0,s1                      // T0 = X_REG | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (X_REG | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = (X)
  andi t1,s5,C_FLAG             // T1 = C_FLAG
  andi t2,s0,$80                // T2 = A_REG & 0x80
  addu s0,t0                    // A_REG += (X)
  addu s0,t1                    // A_REG += C_FLAG
  andi s0,$FF
  andi t1,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t1                      // PSW_REG: N Flag = Result MSB
  andi t3,t0,$80                // T3 = (X) & 0x80
  beq t2,t3,ADCAXVASPC          // IF (A_REG & 0x80 == (X) & 0x80) &&
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  ADCAXVASPC:
  bne t2,t1,ADCAXVBSPC          // IF (A_REG & 0x80 != (A_REG + (X) + C_FLAG) & 0x80)
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  ADCAXVBSPC:
  andi t1,s0,$F                 // Test Half Carry
  lli t2,9
  bgtu t1,t2,ADCAXHSPC          // IF ((A_REG & $F) > 9) H Flag Set
  ori s5,H_FLAG                 // PSW_REG: H Flag Set (Delay Slot)
  andi s5,~H_FLAG               // PSW_REG: H Flag Reset
  ADCAXHSPC:
  beqz s0,ADCAXZSPC             // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  ADCAXZSPC:
  bltu s0,t0,ADCAXCSPC          // IF (A_REG < (X)) C Flag Set
  ori s5,C_FLAG                 // PSW_REG: C Flag Set (Delay Slot)
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  ADCAXCSPC:
  jr ra
  addiu v0,3                    // Cycles += 3 (Delay Slot)

align(256)
  // $87 ADC   A, [dp+X]        ADd Value From Indirect Absolute Address In Direct Page Offset Added With Value X + Carry Flag To A
  andi t0,s5,P_FLAG             // DPXI = MEM_MAP[MEM_MAP[((Immediate + X_REG) & $FF) | (P_FLAG << 3)]]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  addu t1,s1                    // T1 = Immediate + X_REG
  andi t1,$FF                   // T1 = (Immediate + X_REG) & $FF
  or t0,t1                      // T0 = ((Immediate + X_REG) & $FF) | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + ((Immediate + X_REG) & $FF) | (P_FLAG << 3)
  lbu t0,0(a2)
  lbu t1,1(a2)
  srl t1,8
  or t0,t1                      // T0 = MEM_MAP[((Immediate + X_REG) & $FF) | (P_FLAG << 3)]
  addu a2,a0,t0                 // A2 = MEM_MAP + MEM_MAP[((Immediate + X_REG) & $FF) | (P_FLAG << 3)]
  lbu t0,0(a2)                  // T0 = DPXI
  andi t1,s5,C_FLAG             // T1 = C_FLAG
  andi t2,s0,$80                // T2 = A_REG & 0x80
  addu s0,t0                    // A_REG += DPXI
  addu s0,t1                    // A_REG += C_FLAG
  andi s0,$FF
  andi t1,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t1                      // PSW_REG: N Flag = Result MSB
  andi t3,t0,$80                // T3 = DPXI & 0x80
  beq t2,t3,ADCADPXIVASPC       // IF (A_REG & 0x80 == DPXI & 0x80) &&
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  ADCADPXIVASPC:
  bne t2,t1,ADCADPXIVBSPC       // IF (A_REG & 0x80 != (A_REG + DPXI + C_FLAG) & 0x80)
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  ADCADPXIVBSPC:
  andi t1,s0,$F                 // Test Half Carry
  lli t2,9
  bgtu t1,t2,ADCADPXIHSPC       // IF ((A_REG & $F) > 9) H Flag Set
  ori s5,H_FLAG                 // PSW_REG: H Flag Set (Delay Slot)
  andi s5,~H_FLAG               // PSW_REG: H Flag Reset
  ADCADPXIHSPC:
  beqz s0,ADCADPXIZSPC          // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  ADCADPXIZSPC:
  bltu s0,t0,ADCADPXICSPC       // IF (A_REG < DPXI) C Flag Set
  ori s5,C_FLAG                 // PSW_REG: C Flag Set (Delay Slot)
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  ADCADPXICSPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,6                    // Cycles += 6 (Delay Slot)

align(256)
  // $88 ADC   A, #imm          ADd Immediate Value + Carry Flag To A
  lbu t0,1(a2)                  // T0 = Immediate
  andi t1,s5,C_FLAG             // T1 = C_FLAG
  andi t2,s0,$80                // T2 = A_REG & 0x80
  addu s0,t0                    // A_REG += Immediate
  addu s0,t1                    // A_REG += C_FLAG
  andi s0,$FF
  andi t1,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t1                      // PSW_REG: N Flag = Result MSB
  andi t3,t0,$80                // T3 = Immediate & 0x80
  beq t2,t3,ADCAIMMVASPC        // IF (A_REG & 0x80 == Immediate & 0x80) &&
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  ADCAIMMVASPC:
  bne t2,t1,ADCAIMMVBSPC        // IF (A_REG & 0x80 != (A_REG + Immediate + C_FLAG) & 0x80)
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  ADCAIMMVBSPC:
  andi t1,s0,$F                 // Test Half Carry
  lli t2,9
  bgtu t1,t2,ADCAIMMHSPC        // IF ((A_REG & $F) > 9) H Flag Set
  ori s5,H_FLAG                 // PSW_REG: H Flag Set (Delay Slot)
  andi s5,~H_FLAG               // PSW_REG: H Flag Reset
  ADCAIMMHSPC:
  beqz s0,ADCAIMMZSPC           // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  ADCAIMMZSPC:
  bltu s0,t0,ADCAIMMCSPC        // IF (A_REG < Immediate) C Flag Set
  ori s5,C_FLAG                 // PSW_REG: C Flag Set (Delay Slot)
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  ADCAIMMCSPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,2                    // Cycles += 2 (Delay Slot)

align(256)
  // $89 ADC   dp, dp           ADd Value In Direct Page Offset + Carry flag To Direct Page Offset
  andi t0,s5,P_FLAG             // DPB = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t1,t0                      // T1 = Immediate | (P_FLAG << 3)
  addu a3,a0,t1                 // A3 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu t1,0(a3)                  // T1 = DPB
  lbu t2,2(a2)                  // DPA = MEM_MAP[DirectPage | (P_FLAG << 3)]
  or t0,t2                      // T0 = DirectPage | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (DirectPage | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = DPA
  andi t2,s5,C_FLAG             // T2 = C_FLAG
  andi t3,t0,$80                // T3 = DPA & 0x80
  addu t0,t1                    // DPA += DPB
  addu t0,t2                    // DPA += C_FLAG
  andi t0,$FF
  sb t0,0(a2)                   // Store DPA
  andi t2,t0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t2                      // PSW_REG: N Flag = Result MSB
  andi t4,t1,$80                // T4 = DPB & 0x80
  beq t3,t4,ADCDPDPVASPC        // IF (DPA & 0x80 == DPB & 0x80) &&
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  ADCDPDPVASPC:
  bne t3,t2,ADCDPDPVBSPC        // IF (DPA & 0x80 != (DPA + DPB + C_FLAG) & 0x80)
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  ADCDPDPVBSPC:
  andi t2,t0,$F                 // Test Half Carry
  lli t3,9
  bgtu t2,t3,ADCDPDPHSPC        // IF ((DPA & $F) > 9) H Flag Set
  ori s5,H_FLAG                 // PSW_REG: H Flag Set (Delay Slot)
  andi s5,~H_FLAG               // PSW_REG: H Flag Reset
  ADCDPDPHSPC:
  beqz t0,ADCDPDPZSPC           // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  ADCDPDPZSPC:
  bltu t0,t1,ADCDPDPCSPC        // IF (DPA < DPB) C Flag Set
  ori s5,C_FLAG                 // PSW_REG: C Flag Set (Delay Slot)
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  ADCDPDPCSPC:
  addiu s3,2                    // PC_REG += 2
  jr ra
  addiu v0,6                    // Cycles += 6 (Delay Slot)

align(256)
  // $8A EOR1  C, mem.bit       Exclusive OR Carry Flag With Memory Bit
  lbu t0,1(a2)                  // MEMBIT = (MEM_MAP[MEM] >> BIT) & 1
  lbu t1,2(a2)
  sll t1,8
  or t0,t1                      // T0 = Absolute
  srl t1,t0,13                  // T1 = BIT (Absolute >> 13)
  andi t0,$1FFF                 // T0 = MEM (Absolute & 0x1FFF)
  addu a2,a0,t0                 // A2 = MEM_MAP + MEM
  lbu t0,0(a2)                  // T0 = MEM_MAP[MEM]
  srlv t0,t1                    // T0 = MEM_MAP[MEM] >> BIT
  andi t0,1                     // T0 = MEMBIT
  xor t0,s5,t0                  // C_FLAG ^= MEMBIT
  andi t0,1
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  or s5,t0
  addiu s3,2                    // PC_REG += 2
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $8B DEC   dp               DECrement Value In Direct Page Offset
  andi t0,s5,P_FLAG             // DP = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = DP
  subiu t0,1                    // DP--
  andi t0,$FF
  sb t0,0(a2)                   // Store DP
  andi t1,t0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t1                      // PSW_REG: N Flag = Result MSB
  beqz t0,DECDPSPC              // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  DECDPSPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $8C DEC   !abs             DECrement Value In Absolute Address
  lbu t0,1(a2)                  // ABS = MEM_MAP[Absolute]
  lbu t1,2(a2)
  sll t1,8
  or t0,t1                      // T0 = Absolute
  addu a2,a0,t0                 // A2 = MEM_MAP + Absolute
  lbu t0,0(a2)                  // T0 = ABS
  subiu t0,1                    // ABS--
  andi t0,$FF
  sb t0,0(a2)                   // Store ABS
  andi t1,t0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t1                      // PSW_REG: N Flag = Result MSB
  beqz t0,DECABSSPC             // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  DECABSSPC:
  addiu s3,2                    // PC_REG += 2
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $8D MOV   Y, #imm          MOVe Immediate Value Into Y
  lbu s2,1(a2)                  // Y_REG = Immediate
  andi t0,s2,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s2,MOVYIMMSPC            // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  MOVYIMMSPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,2                    // Cycles += 2 (Delay Slot)

align(256)
  // $8E POP   PSW              POP Byte Off Stack Into Register PSW
  addiu s4,1                    // SP_REG += 1 (Increment Stack)
  andi s4,$FF
  addu a2,a0,s4                 // STACK = MEM_MAP[$100 + SP_REG]
  addiu a2,$100                 // A2 = STACK
  lbu s5,0(a2)                  // PSW_REG = STACK
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $8F MOV   dp, #imm         MOVe Immediate Value Into Direct Page Offset
  andi t0,s5,P_FLAG             // DP = MEM_MAP[DirectPage | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,2(a2)                  // T1 = DirectPage
  or t0,t1                      // T0 = DirectPage | (P_FLAG << 3)
  lbu t1,1(a2)                  // T1 = Immediate
  addu a2,a0,t0                 // A2 = MEM_MAP + (DirectPage | (P_FLAG << 3))
  sb t1,0(a2)                   // DP = Immediate
  addiu s3,2                    // PC_REG += 2
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $90 BCC   rel              Branch To Relative Address IF Carry Cleared
  andi t0,s5,C_FLAG             // IF (! C_FLAG) PC_REG += Relative
  bnez t0,BCCSPC
  addiu s3,1                    // PC_REG++ (Delay Slot)
  lb t0,1(a2)                   // T0 = Relative
  add s3,t0                     // PC_REG += Relative
  addiu v0,2                    // Cycles += 2
  BCCSPC:
  jr ra
  addiu v0,2                    // Cycles += 2 (Delay Slot)

align(256)
  // $91 TCALL n                Table CALL Push PC Onto Stack Then Jump To Table Address
  subiu s4,2                    // SP_REG -= 2 (Decrement Stack)
  andi s4,$FF
  addu a2,a0,s4                 // STACK = MEM_MAP[$100 + SP_REG]
  addiu a2,$100                 // A2 = STACK
  sb s3,1(a2)                   // STACK = PC_REG
  srl t0,s3,8
  sb t0,2(a2)
  addiu a2,a0,$FFCC             // PC_REG = MEM_MAP[$FFCC]
  lbu s3,0(a2)
  lbu t0,1(a2)
  sll t0,8
  or s3,t0
  jr ra
  addiu v0,8                    // Cycles += 8 (Delay Slot)

align(256)
  // $92 CLR1  dp.bit           CLeaR Bit In Direct Page Offset
  andi t0,s5,P_FLAG             // DP = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = DP
  andi t0,$EF                   // DP &= ^BIT
  sb t0,0(a2)                   // Store DP
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $93 BBC   dp.bit, rel      Branch To Relative Address IF Bit Cleared In Direct Page Offset
  andi t0,s5,P_FLAG             // DP = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  lb t1,2(a2)                   // T1 = Relative
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = DP
  andi t0,$10                   // DP &= BIT
  bnez t0,BBC4SPC               // IF (! (DP & BIT)) PC_REG += Relative
  addiu s3,2                    // PC_REG += 2 (Delay Slot)
  add s3,t1                     // PC_REG += Relative
  addiu v0,2                    // Cycles += 2
  BBC4SPC:
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $94 ADC   A, dp+X          ADd Value In Direct Page Offset Added With Value X + Carry Flag To A
  andi t0,s5,P_FLAG             // DPX = MEM_MAP[((Immediate + X_REG) & $FF) | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  addu t1,s1                    // T1 = Immediate + X_REG
  andi t1,$FF                   // T1 = (Immediate + X_REG) & $FF
  or t0,t1                      // T0 = ((Immediate + X_REG) & $FF) | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + ((Immediate + X_REG) & $FF) | (P_FLAG << 3)
  lbu t0,0(a2)                  // T0 = DPX
  addu s0,t0                    // A_REG += DPX
  addu s0,t1                    // A_REG += C_FLAG
  andi s0,$FF
  andi t1,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t1                      // PSW_REG: N Flag = Result MSB
  andi t3,t0,$80                // T3 = DPX & 0x80
  beq t2,t3,ADCADPXVASPC        // IF (A_REG & 0x80 == DPX & 0x80) &&
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  ADCADPXVASPC:
  bne t2,t1,ADCADPXVBSPC        // IF (A_REG & 0x80 != (A_REG + DPX + C_FLAG) & 0x80)
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  ADCADPXVBSPC:
  andi t1,s0,$F                 // Test Half Carry
  lli t2,9
  bgtu t1,t2,ADCADPXHSPC        // IF ((A_REG & $F) > 9) H Flag Set
  ori s5,H_FLAG                 // PSW_REG: H Flag Set (Delay Slot)
  andi s5,~H_FLAG               // PSW_REG: H Flag Reset
  ADCADPXHSPC:
  beqz s0,ADCADPXZSPC           // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  ADCADPXZSPC:
  bltu s0,t0,ADCADPXCSPC        // IF (A_REG < DPX) C Flag Set
  ori s5,C_FLAG                 // PSW_REG: C Flag Set (Delay Slot)
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  ADCADPXCSPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $95 ADC   A, !abs+X        ADd Value From Absolute Address Added With Value X + Carry Flag To A
  lbu t0,1(a2)                  // ABSX = MEM_MAP[Absolute + X_REG]
  lbu t1,2(a2)
  sll t1,8
  or t0,t1                      // T0 = Absolute
  addu a2,a0,t0                 // A2 = MEM_MAP + Absolute
  addu a2,s1                    // A2 = MEM_MAP + Absolute + X_REG
  lbu t0,0(a2)                  // T0 = ABSX
  addu s0,t0                    // A_REG += ABSX
  addu s0,t1                    // A_REG += C_FLAG
  andi s0,$FF
  andi t1,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t1                      // PSW_REG: N Flag = Result MSB
  andi t3,t0,$80                // T3 = ABSX & 0x80
  beq t2,t3,ADCAABSXVASPC       // IF (A_REG & 0x80 == ABSX & 0x80) &&
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  ADCAABSXVASPC:
  bne t2,t1,ADCAABSXVBSPC       // IF (A_REG & 0x80 != (A_REG + ABSX + C_FLAG) & 0x80)
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  ADCAABSXVBSPC:
  andi t1,s0,$F                 // Test Half Carry
  lli t2,9
  bgtu t1,t2,ADCAABSXHSPC       // IF ((A_REG & $F) > 9) H Flag Set
  ori s5,H_FLAG                 // PSW_REG: H Flag Set (Delay Slot)
  andi s5,~H_FLAG               // PSW_REG: H Flag Reset
  ADCAABSXHSPC:
  beqz s0,ADCAABSXZSPC          // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  ADCAABSXZSPC:
  bltu s0,t0,ADCAABSXCSPC       // IF (A_REG < ABSX) C Flag Set
  ori s5,C_FLAG                 // PSW_REG: C Flag Set (Delay Slot)
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  ADCAABSXCSPC:
  addiu s3,2                    // PC_REG += 2
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $96 ADC   A, !abs+Y        ADd Value From Absolute Address Added With Value Y + Carry Flag To A
  lbu t0,1(a2)                  // ABSY = MEM_MAP[Absolute + Y_REG]
  lbu t1,2(a2)
  sll t1,8
  or t0,t1                      // T0 = Absolute
  addu a2,a0,t0                 // A2 = MEM_MAP + Absolute
  addu a2,s2                    // A2 = MEM_MAP + Absolute + Y_REG
  lbu t0,0(a2)                  // T0 = ABSY
  addu s0,t0                    // A_REG += ABSY
  addu s0,t1                    // A_REG += C_FLAG
  andi s0,$FF
  andi t1,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t1                      // PSW_REG: N Flag = Result MSB
  andi t3,t0,$80                // T3 = ABSY & 0x80
  beq t2,t3,ADCAABSYVASPC       // IF (A_REG & 0x80 == ABSY & 0x80) &&
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  ADCAABSYVASPC:
  bne t2,t1,ADCAABSYVBSPC       // IF (A_REG & 0x80 != (A_REG + ABSY + C_FLAG) & 0x80)
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  ADCAABSYVBSPC:
  andi t1,s0,$F                 // Test Half Carry
  lli t2,9
  bgtu t1,t2,ADCAABSYHSPC       // IF ((A_REG & $F) > 9) H Flag Set
  ori s5,H_FLAG                 // PSW_REG: H Flag Set (Delay Slot)
  andi s5,~H_FLAG               // PSW_REG: H Flag Reset
  ADCAABSYHSPC:
  beqz s0,ADCAABSYZSPC          // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  ADCAABSYZSPC:
  bltu s0,t0,ADCAABSYCSPC       // IF (A_REG < ABSY) C Flag Set
  ori s5,C_FLAG                 // PSW_REG: C Flag Set (Delay Slot)
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  ADCAABSYCSPC:
  addiu s3,2                    // PC_REG += 2
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $97 ADC   A, [dp]+Y        ADd Value From Indirect Absolute Address In Direct Page Offset Added With Value Y + Carry Flag To A
  andi t0,s5,P_FLAG             // DPYI = MEM_MAP[MEM_MAP[Immediate) | (P_FLAG << 3)] + Y_REG]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate) | (P_FLAG << 3))
  lbu t0,0(a2)
  lbu t1,1(a2)
  srl t1,8
  or t0,t1                      // T0 = MEM_MAP[Immediate) | (P_FLAG << 3)]
  addu t0,s2                    // T0 = MEM_MAP[Immediate) | (P_FLAG << 3)] + Y_REG
  addu a2,a0,t0                 // A2 = MEM_MAP + MEM_MAP[Immediate) | (P_FLAG << 3) + Y_REG]
  lbu t0,0(a2)                  // T0 = DPYI
  andi t1,s5,C_FLAG             // T1 = C_FLAG
  andi t2,s0,$80                // T2 = A_REG & 0x80
  addu s0,t0                    // A_REG += DPYI
  addu s0,t1                    // A_REG += C_FLAG
  andi s0,$FF
  andi t1,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t1                      // PSW_REG: N Flag = Result MSB
  andi t3,t0,$80                // T3 = DPYI & 0x80
  beq t2,t3,ADCADPYIVASPC       // IF (A_REG & 0x80 == DPYI & 0x80) &&
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  ADCADPYIVASPC:
  bne t2,t1,ADCADPYIVBSPC       // IF (A_REG & 0x80 != (A_REG + DPYI + C_FLAG) & 0x80)
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  ADCADPYIVBSPC:
  andi t1,s0,$F                 // Test Half Carry
  lli t2,9
  bgtu t1,t2,ADCADPYIHSPC       // IF ((A_REG & $F) > 9) H Flag Set
  ori s5,H_FLAG                 // PSW_REG: H Flag Set (Delay Slot)
  andi s5,~H_FLAG               // PSW_REG: H Flag Reset
  ADCADPYIHSPC:
  beqz s0,ADCADPYIZSPC          // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  ADCADPYIZSPC:
  bltu s0,t0,ADCADPYICSPC       // IF (A_REG < DPYI) C Flag Set
  ori s5,C_FLAG                 // PSW_REG: C Flag Set (Delay Slot)
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  ADCADPYICSPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,6                    // Cycles += 6 (Delay Slot)

align(256)
  // $98 ADC   dp, #imm         ADd Immediate Value + Carry Flag To Direct Page Offset
  andi t0,s5,P_FLAG             // DP = MEM_MAP[DirectPage | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,2(a2)                  // T1 = DirectPage
  or t0,t1                      // T0 = DirectPage | (P_FLAG << 3)
  lbu t1,1(a2)                  // T1 = Immediate
  addu a2,a0,t0                 // A2 = MEM_MAP + (DirectPage | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = DP
  andi t2,s5,C_FLAG             // T2 = C_FLAG
  andi t3,t0,$80                // T3 = DP & 0x80
  addu t0,t1                    // DP += Immediate
  addu t0,t2                    // DP += C_FLAG
  andi t0,$FF
  sb t0,0(a2)                   // Store DP
  andi t2,t0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t2                      // PSW_REG: N Flag = Result MSB
  andi t4,t1,$80                // T4 = Immediate & 0x80
  beq t3,t4,ADCDPIMMVASPC       // IF (DP & 0x80 == Immediate & 0x80) &&
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  ADCDPIMMVASPC:
  bne t3,t2,ADCDPIMMVBSPC       // IF (DP & 0x80 != (DP + Immediate + C_FLAG) & 0x80)
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  ADCDPIMMVBSPC:
  andi t2,t0,$F                 // Test Half Carry
  lli t3,9
  bgtu t2,t3,ADCDPIMMHSPC       // IF ((DP & $F) > 9) H Flag Set
  ori s5,H_FLAG                 // PSW_REG: H Flag Set (Delay Slot)
  andi s5,~H_FLAG               // PSW_REG: H Flag Reset
  ADCDPIMMHSPC:
  beqz t0,ADCDPIMMZSPC          // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  ADCDPIMMZSPC:
  bltu t0,t1,ADCDPIMMCSPC       // IF (DP < Immediate) C Flag Set
  ori s5,C_FLAG                 // PSW_REG: C Flag Set (Delay Slot)
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  ADCDPIMMCSPC:
  addiu s3,2                    // PC_REG += 2
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $99 ADC   (X), (Y)         ADd Value Y + Carry Flag To X
  andi t0,s5,P_FLAG             // (Y) = MEM_MAP[Y_REG | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  or t1,t0,s2                   // T1 = Y_REG | (P_FLAG << 3)
  addu a3,a0,t1                 // A3 = MEM_MAP + (Y_REG | (P_FLAG << 3))
  lbu t1,0(a3)                  // T1 = (Y)
  or t0,s1                      // (X) = MEM_MAP[X_REG | (P_FLAG << 3)]
  addu a2,a0,t0                 // A2 = MEM_MAP + (X_REG | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = (X)
  andi t2,s5,C_FLAG             // T2 = C_FLAG
  andi t3,t0,$80                // T3 = (X) & 0x80
  addu t0,t1                    // (X) += (Y)
  addu t0,t2                    // (X) += C_FLAG
  andi t0,$FF
  sb t0,0(a2)                   // Store (X)
  andi t2,t0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t2                      // PSW_REG: N Flag = Result MSB
  andi t4,t1,$80                // T4 = (Y) & 0x80
  beq t3,t4,ADCXYVASPC          // IF ((X) & 0x80 == (Y) & 0x80) &&
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  ADCXYVASPC:
  bne t3,t2,ADCXYVBSPC          // IF ((X) & 0x80 != ((X) + (Y) + C_FLAG) & 0x80)
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  ADCXYVBSPC:
  andi t2,t0,$F                 // Test Half Carry
  lli t3,9
  bgtu t2,t3,ADCXYHSPC          // IF (((X) & $F) > 9) H Flag Set
  ori s5,H_FLAG                 // PSW_REG: H Flag Set (Delay Slot)
  andi s5,~H_FLAG               // PSW_REG: H Flag Reset
  ADCXYHSPC:
  beqz t0,ADCXYZSPC             // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  ADCXYZSPC:
  bltu t0,t1,ADCXYCSPC          // IF ((X) < (Y)) C Flag Set
  ori s5,C_FLAG                 // PSW_REG: C Flag Set (Delay Slot)
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  ADCXYCSPC:
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $9A SUBW  YA, dp           SUBtract Word In Direct Page Offset From YA
  andi t0,s5,P_FLAG             // DPW = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu t0,0(a2)
  lbu t1,1(a2)
  sll t1,8
  or t0,t1                      // T0 = DPW
  move t1,s2                    // YA_REG = (Y_REG << 8) | A_REG
  sll t1,8
  or t1,s0                      // T1 = YA_REG
  andi t2,t1,$8000              // T2 = YA_REG & 0x8000
  subu t1,t0                    // T1 = YA_REG - DPW
  andi t1,$FFFF
  andi s0,t1,$FF                // Store YA
  srl s2,t1,8
  andi t3,t1,$8000              // Test Negative MSB
  srl t4,t3,8
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t4                      // PSW_REG: N Flag = Result MSB
  andi t4,t0,$8000              // T4 = DPW & 0x8000
  beq t2,t4,SUBWYADPVASPC       // IF (YA_REG & 0x8000 == DPW & 0x8000) &&
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  SUBWYADPVASPC:
  bne t2,t3,SUBWYADPVBSPC       // IF (YA_REG & 0x8000 != (YA_REG + DPW) & 0x8000)
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  SUBWYADPVBSPC:
  andi t2,t1,$F00               // Test Half Carry
  lli t3,$900
  bgtu t2,t3,SUBWYADPHSPC       // IF ((YA_REG & $F00) > $900) H Flag Set
  ori s5,H_FLAG                 // PSW_REG: H Flag Set (Delay Slot)
  andi s5,~H_FLAG               // PSW_REG: H Flag Reset
  SUBWYADPHSPC:
  beqz t1,SUBWYADPZSPC          // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  SUBWYADPZSPC:
  bgtu t1,t0,SUBWYADPCSPC       // IF (YA_REG > DPW) C Flag Set
  ori s5,C_FLAG                 // PSW_REG: C Flag Set (Delay Slot)
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  SUBWYADPCSPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $9B DEC   dp+X             DECrement Value In Direct Page Offset Added With Value X
  andi t0,s5,P_FLAG             // DPX = MEM_MAP[((Immediate + X_REG) & $FF) | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  addu t1,s1                    // T1 = Immediate + X_REG
  andi t1,$FF                   // T1 = (Immediate + X_REG) & $FF
  or t0,t1                      // T0 = ((Immediate + X_REG) & $FF) | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + ((Immediate + X_REG) & $FF) | (P_FLAG << 3)
  lbu t0,0(a2)                  // T0 = DPX
  subiu t0,1                    // DPX--
  andi t0,$FF
  sb t0,0(a2)                   // Store DPX
  andi t1,t0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t1                      // PSW_REG: N Flag = Result MSB
  beqz t0,DECDPXSPC             // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  DECDPXSPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $9C DEC   A                DECrement Register A
  subiu s0,1                    // A_REG--
  andi s0,$FF
  andi t0,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s0,DECASPC               // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  DECASPC:
  jr ra
  addiu v0,2                    // Cycles += 2 (Delay Slot)

align(256)
  // $9D MOV   X, SP            MOVe Value SP Into X
  move s1,s4                    // X_REG = SP_REG
  andi t0,s1,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s1,MOVXSPSPC             // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  MOVXSPSPC:
  jr ra
  addiu v0,2                    // Cycles += 2 (Delay Slot)

align(256)
  // $9E DIV   YA, X            DIVide Register Pair YA With X
  move t0,s2                    // YA_REG = (Y_REG << 8) | A_REG
  sll t0,8
  or t0,s0                      // T0 = YA_REG
  andi t1,t0,$8000              // T1 = YA_REG & 0x8000
  divu t0,s1                    // HI/LO = YA_REG / X_REG (LO = Quotient, HI = Remainder)
  mflo s0                       // Store YA
  andi s0,$FF
  mfhi s2
  andi s2,$FF
  move t0,s2                    // YA_REG = (Y_REG << 8) | A_REG
  sll t0,8
  or t0,s0                      // T0 = YA_REG
  andi t2,t0,$8000              // Test Negative MSB
  srl t3,t2,8
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t3                      // PSW_REG: N Flag = Result MSB
  andi t3,s1,$80                // T3 = X_REG & 0x80
  beq t1,t3,DIVYAXVASPC         // IF (YA_REG & 0x8000 == X_REG & 0x80) &&
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  DIVYAXVASPC:
  bne t1,t2,DIVYAXVBSPC         // IF (YA_REG & 0x8000 != (YA_REG % X_REG) | ((YA_REG / X_REG) << 8) & 0x8000)
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  DIVYAXVBSPC:
  andi t1,t0,$F00               // Test Half Carry
  lli t2,$900
  bgtu t1,t2,DIVYAXHSPC         // IF ((YA_REG & $F00) > $900) H Flag Set
  ori s5,H_FLAG                 // PSW_REG: H Flag Set (Delay Slot)
  andi s5,~H_FLAG               // PSW_REG: H Flag Reset
  DIVYAXHSPC:
  beqz t0,DIVYAXZSPC            // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  DIVYAXZSPC:
  jr ra
  addiu v0,12                   // Cycles += 12 (Delay Slot)

align(256)
  // $9F XCN   A                EXChaNge Register A (Swap Nibbles)
  sll t0,s0,4                   // A_REG = (A_REG >> 4) | (A_REG << 4)
  srl s0,4
  or s0,t0
  and s0,$FF
  andi t0,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s0,XCNASPC               // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  XCNASPC:
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $A0 EI                     Enable Interrupts Flag
  ori s5,I_FLAG                 // PSW_REG: I Flag Set
  jr ra
  addiu v0,3                    // Cycles += 3 (Delay Slot)

align(256)
  // $A1 TCALL n                Table CALL Push PC Onto Stack Then Jump To Table Address
  subiu s4,2                    // SP_REG -= 2 (Decrement Stack)
  andi s4,$FF
  addu a2,a0,s4                 // STACK = MEM_MAP[$100 + SP_REG]
  addiu a2,$100                 // A2 = STACK
  sb s3,1(a2)                   // STACK = PC_REG
  srl t0,s3,8
  sb t0,2(a2)
  addiu a2,a0,$FFCA             // PC_REG = MEM_MAP[$FFCA]
  lbu s3,0(a2)
  lbu t0,1(a2)
  sll t0,8
  or s3,t0
  jr ra
  addiu v0,8                    // Cycles += 8 (Delay Slot)

align(256)
  // $A2 SET1  dp.bit           SET Bit In Direct Page Offset
  andi t0,s5,P_FLAG             // DP = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = DP
  ori t0,$20                    // DP |= BIT
  sb t0,0(a2)                   // Store DP
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $A3 BBS   dp.bit, rel      Branch To Relative Address IF Bit Set In Direct Page Offset
  andi t0,s5,P_FLAG             // DP = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  lb t1,2(a2)                   // T1 = Relative
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = DP
  andi t0,$20                   // DP &= BIT
  beqz t0,BBS5SPC               // IF (DP & BIT) PC_REG += Relative
  addiu s3,2                    // PC_REG += 2 (Delay Slot)
  add s3,t1                     // PC_REG += Relative
  addiu v0,2                    // Cycles += 2
  BBS5SPC:
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $A4 SBC   A, dp            SuBtract Value In Direct Page Offset + Carry Flag From A
  andi t0,s5,P_FLAG             // DP = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = DP
  andi t1,s5,C_FLAG             // T1 = C_FLAG
  andi t2,s0,$80                // T2 = A_REG & 0x80
  subu s0,t0                    // A_REG -= DP
  subu s0,t1                    // A_REG -= C_FLAG
  andi s0,$FF
  andi t1,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t1                      // PSW_REG: N Flag = Result MSB
  andi t3,t0,$80                // T3 = DP & 0x80
  beq t2,t3,SBCADPVASPC         // IF (A_REG & 0x80 == DP & 0x80) &&
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  SBCADPVASPC:
  bne t2,t1,SBCADPVBSPC         // IF (A_REG & 0x80 != (A_REG - (DP + C_FLAG)) & 0x80)
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  SBCADPVBSPC:
  andi t1,s0,$F                 // Test Half Carry
  lli t2,9
  bgtu t1,t2,SBCADPHSPC         // IF ((A_REG & $F) > 9) H Flag Set
  ori s5,H_FLAG                 // PSW_REG: H Flag Set (Delay Slot)
  andi s5,~H_FLAG               // PSW_REG: H Flag Reset
  SBCADPHSPC:
  beqz s0,SBCADPZSPC            // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  SBCADPZSPC:
  bgtu s0,t0,SBCADPCSPC         // IF (A_REG > DP) C Flag Set
  ori s5,C_FLAG                 // PSW_REG: C Flag Set (Delay Slot)
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  SBCADPCSPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,3                    // Cycles += 3 (Delay Slot)

align(256)
  // $A5 SBC   A, !abs          SuBtract Value From Absolute Address + Carry Flag From A
  lbu t0,1(a2)                  // ABS = MEM_MAP[Absolute]
  lbu t1,2(a2)
  sll t1,8
  or t0,t1                      // T0 = Absolute
  addu a2,a0,t0                 // A2 = MEM_MAP + Absolute
  lbu t0,0(a2)                  // T0 = ABS
  andi t1,s5,C_FLAG             // T1 = C_FLAG
  andi t2,s0,$80                // T2 = A_REG & 0x80
  subu s0,t0                    // A_REG -= ABS
  subu s0,t1                    // A_REG -= C_FLAG
  andi s0,$FF
  andi t1,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t1                      // PSW_REG: N Flag = Result MSB
  andi t3,t0,$80                // T3 = ABS & 0x80
  beq t2,t3,SBCAABSVASPC        // IF (A_REG & 0x80 == ABS & 0x80) &&
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  SBCAABSVASPC:
  bne t2,t1,SBCAABSVBSPC        // IF (A_REG & 0x80 != (A_REG - (ABS + C_FLAG)) & 0x80)
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  SBCAABSVBSPC:
  andi t1,s0,$F                 // Test Half Carry
  lli t2,9
  bgtu t1,t2,SBCAABSHSPC        // IF ((A_REG & $F) > 9) H Flag Set
  ori s5,H_FLAG                 // PSW_REG: H Flag Set (Delay Slot)
  andi s5,~H_FLAG               // PSW_REG: H Flag Reset
  SBCAABSHSPC:
  beqz s0,SBCAABSZSPC           // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  SBCAABSZSPC:
  bgtu s0,t0,SBCAABSCSPC        // IF (A_REG > ABS) C Flag Set
  ori s5,C_FLAG                 // PSW_REG: C Flag Set (Delay Slot)
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  SBCAABSCSPC:
  addiu s3,2                    // PC_REG += 2
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $A6 SBC   A, (X)           SuBtract Value X + Carry Flag From A
  andi t0,s5,P_FLAG             // (X) = MEM_MAP[X_REG | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  or t0,s1                      // T0 = X_REG | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (X_REG | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = (X)
  andi t1,s5,C_FLAG             // T1 = C_FLAG
  andi t2,s0,$80                // T2 = A_REG & 0x80
  subu s0,t0                    // A_REG -= (X)
  subu s0,t1                    // A_REG -= C_FLAG
  andi s0,$FF
  andi t1,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t1                      // PSW_REG: N Flag = Result MSB
  andi t3,t0,$80                // T3 = (X) & 0x80
  beq t2,t3,SBCAXVASPC          // IF (A_REG & 0x80 == (X) & 0x80) &&
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  SBCAXVASPC:
  bne t2,t1,SBCAXVBSPC          // IF (A_REG & 0x80 != (A_REG - ((X) + C_FLAG)) & 0x80)
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  SBCAXVBSPC:
  andi t1,s0,$F                 // Test Half Carry
  lli t2,9
  bgtu t1,t2,SBCAXHSPC          // IF ((A_REG & $F) > 9) H Flag Set
  ori s5,H_FLAG                 // PSW_REG: H Flag Set (Delay Slot)
  andi s5,~H_FLAG               // PSW_REG: H Flag Reset
  SBCAXHSPC:
  beqz s0,SBCAXZSPC             // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  SBCAXZSPC:
  bgtu s0,t0,SBCAXCSPC          // IF (A_REG > (X)) C Flag Set
  ori s5,C_FLAG                 // PSW_REG: C Flag Set (Delay Slot)
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  SBCAXCSPC:
  jr ra
  addiu v0,3                    // Cycles += 3 (Delay Slot)

align(256)
  // $A7 SBC   A, [dp+X]        SuBtract Value From Indirect Absolute Address In Direct Page Offset Added With Value X + Carry Flag From A
  andi t0,s5,P_FLAG             // DPXI = MEM_MAP[MEM_MAP[((Immediate + X_REG) & $FF) | (P_FLAG << 3)]]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  addu t1,s1                    // T1 = Immediate + X_REG
  andi t1,$FF                   // T1 = (Immediate + X_REG) & $FF
  or t0,t1                      // T0 = ((Immediate + X_REG) & $FF) | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + ((Immediate + X_REG) & $FF) | (P_FLAG << 3)
  lbu t0,0(a2)
  lbu t1,1(a2)
  srl t1,8
  or t0,t1                      // T0 = MEM_MAP[((Immediate + X_REG) & $FF) | (P_FLAG << 3)]
  addu a2,a0,t0                 // A2 = MEM_MAP + MEM_MAP[((Immediate + X_REG) & $FF) | (P_FLAG << 3)]
  lbu t0,0(a2)                  // T0 = DPXI
  andi t1,s5,C_FLAG             // T1 = C_FLAG
  andi t2,s0,$80                // T2 = A_REG & 0x80
  subu s0,t0                    // A_REG -= DPXI
  subu s0,t1                    // A_REG -= C_FLAG
  andi s0,$FF
  andi t1,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t1                      // PSW_REG: N Flag = Result MSB
  andi t3,t0,$80                // T3 = DPXI & 0x80
  beq t2,t3,SBCADPXIVASPC       // IF (A_REG & 0x80 == DPXI & 0x80) &&
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  SBCADPXIVASPC:
  bne t2,t1,SBCADPXIVBSPC       // IF (A_REG & 0x80 != (A_REG - (DPXI + C_FLAG)) & 0x80)
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  SBCADPXIVBSPC:
  andi t1,s0,$F                 // Test Half Carry
  lli t2,9
  bgtu t1,t2,SBCADPXIHSPC       // IF ((A_REG & $F) > 9) H Flag Set
  ori s5,H_FLAG                 // PSW_REG: H Flag Set (Delay Slot)
  andi s5,~H_FLAG               // PSW_REG: H Flag Reset
  SBCADPXIHSPC:
  beqz s0,SBCADPXIZSPC          // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  SBCADPXIZSPC:
  bgtu s0,t0,SBCADPXICSPC       // IF (A_REG > DPXI) C Flag Set
  ori s5,C_FLAG                 // PSW_REG: C Flag Set (Delay Slot)
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  SBCADPXICSPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,6                    // Cycles += 6 (Delay Slot)

align(256)
  // $A8 SBC   A, #imm          SuBtract Immediate Value + Carry Flag From A
  lbu t0,1(a2)                  // T0 = Immediate
  andi t1,s5,C_FLAG             // T1 = C_FLAG
  andi t2,s0,$80                // T2 = A_REG & 0x80
  subu s0,t0                    // A_REG -= Immediate
  subu s0,t1                    // A_REG -= C_FLAG
  andi s0,$FF
  andi t1,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t1                      // PSW_REG: N Flag = Result MSB
  andi t3,t0,$80                // T3 = Immediate & 0x80
  beq t2,t3,SBCAIMMVASPC        // IF (A_REG & 0x80 == Immediate & 0x80) &&
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  SBCAIMMVASPC:
  bne t2,t1,SBCAIMMVBSPC        // IF (A_REG & 0x80 != (A_REG - (Immediate + C_FLAG)) & 0x80)
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  SBCAIMMVBSPC:
  andi t1,s0,$F                 // Test Half Carry
  lli t2,9
  bgtu t1,t2,SBCAIMMHSPC        // IF ((A_REG & $F) > 9) H Flag Set
  ori s5,H_FLAG                 // PSW_REG: H Flag Set (Delay Slot)
  andi s5,~H_FLAG               // PSW_REG: H Flag Reset
  SBCAIMMHSPC:
  beqz s0,SBCAIMMZSPC           // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  SBCAIMMZSPC:
  bgtu s0,t0,SBCAIMMCSPC        // IF (A_REG > Immediate) C Flag Set
  ori s5,C_FLAG                 // PSW_REG: C Flag Set (Delay Slot)
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  SBCAIMMCSPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,2                    // Cycles += 2 (Delay Slot)

align(256)
  // $A9 SBC   dp, dp           SuBtract Value In Direct Page Offset + Carry Flag From Direct Page Offset
  andi t0,s5,P_FLAG             // DPB = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t1,t0                      // T1 = Immediate | (P_FLAG << 3)
  addu a3,a0,t1                 // A3 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu t1,0(a3)                  // T1 = DPB
  lbu t2,2(a2)                  // DPA = MEM_MAP[DirectPage | (P_FLAG << 3)]
  or t0,t2                      // T0 = DirectPage | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (DirectPage | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = DPA
  andi t2,s5,C_FLAG             // T2 = C_FLAG
  andi t3,t0,$80                // T3 = DPA & 0x80
  subu t0,t1                    // DPA -= DPB
  subu t0,t2                    // DPA -= C_FLAG
  andi t0,$FF
  sb t0,0(a2)                   // Store DPA
  andi t2,t0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t2                      // PSW_REG: N Flag = Result MSB
  andi t4,t1,$80                // T4 = DPB & 0x80
  beq t3,t4,SBCDPDPVASPC        // IF (DPA & 0x80 == DPB & 0x80) &&
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  SBCDPDPVASPC:
  bne t3,t2,SBCDPDPVBSPC        // IF (DPA & 0x80 != (DPA - (DPB + C_FLAG)) & 0x80)
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  SBCDPDPVBSPC:
  andi t2,t0,$F                 // Test Half Carry
  lli t3,9
  bgtu t2,t3,SBCDPDPHSPC        // IF ((DPA & $F) > 9) H Flag Set
  ori s5,H_FLAG                 // PSW_REG: H Flag Set (Delay Slot)
  andi s5,~H_FLAG               // PSW_REG: H Flag Reset
  SBCDPDPHSPC:
  beqz t0,SBCDPDPZSPC           // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  SBCDPDPZSPC:
  bgtu t0,t1,SBCDPDPCSPC        // IF (DPA > DPB) C Flag Set
  ori s5,C_FLAG                 // PSW_REG: C Flag Set (Delay Slot)
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  SBCDPDPCSPC:
  addiu s3,2                    // PC_REG += 2
  jr ra
  addiu v0,6                    // Cycles += 6 (Delay Slot)

align(256)
  // $AA MOV1  C, mem.bit       MOVe Memory Bit Into Carry Flag
  lbu t0,1(a2)                  // MEMBIT = (MEM_MAP[MEM] >> BIT) & 1
  lbu t1,2(a2)
  sll t1,8
  or t0,t1                      // T0 = Absolute
  srl t1,t0,13                  // T1 = BIT (Absolute >> 13)
  andi t0,$1FFF                 // T0 = MEM (Absolute & 0x1FFF)
  addu a2,a0,t0                 // A2 = MEM_MAP + MEM
  lbu t0,0(a2)                  // T0 = MEM_MAP[MEM]
  srlv t0,t1                    // T0 = MEM_MAP[MEM] >> BIT
  andi t0,1                     // T0 = MEMBIT
  andi s5,~C_FLAG               // C_FLAG = MEMBIT
  or s5,t0
  addiu s3,2                    // PC_REG += 2
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $AB INC   dp               INCrement Value In Direct Page Offset
  andi t0,s5,P_FLAG             // DP = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = DP
  addiu t0,1                    // DP++
  andi t0,$FF
  sb t0,0(a2)                   // Store DP
  andi t1,t0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t1                      // PSW_REG: N Flag = Result MSB
  beqz t0,INCDPSPC              // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  INCDPSPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $AC INC   !abs             INCrement Value In Absolute Address
  lbu t0,1(a2)                  // ABS = MEM_MAP[Absolute]
  lbu t1,2(a2)
  sll t1,8
  or t0,t1                      // T0 = Absolute
  addu a2,a0,t0                 // A2 = MEM_MAP + Absolute
  lbu t0,0(a2)                  // T0 = ABS
  addiu t0,1                    // ABS++
  andi t0,$FF
  sb t0,0(a2)                   // Store ABS
  andi t1,t0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t1                      // PSW_REG: N Flag = Result MSB
  beqz t0,INCABSSPC             // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  INCABSSPC:
  addiu s3,2                    // PC_REG += 2
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $AD CMP   Y, #imm          CoMPare Immediate Value With Y
  lbu t0,1(a2)                  // T0 = Immediate
  subu t1,s2,t0                 // T1 = Y_REG - Immediate
  andi t1,$FF
  andi t2,t1,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t2                      // PSW_REG: N Flag = Result MSB
  andi t3,s2,$80                // T3 = Y_REG & $80
  andi t4,t0,$80                // T4 = Immediate & $80
  beq t3,t4,CMPYIMMVASPC        // IF (Y_REG & $80 == Immediate & $80) &&
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  CMPYIMMVASPC:
  bne t3,t2,CMPYIMMVBSPC        // IF (Y_REG & $80 != (Y_REG - Immediate) & $80)
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  CMPYIMMVBSPC:
  beqz t1,CMPYIMMZSPC           // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  CMPYIMMZSPC:
  bgtu t1,t0,CMPYIMMCSPC        // IF ((Y_REG - Immediate) > Immediate) C Flag Set
  ori s5,C_FLAG                 // PSW_REG: C Flag Set (Delay Slot)
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  CMPYIMMCSPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,2                    // Cycles += 2 (Delay Slot)

align(256)
  // $AE POP   A                POP Byte Off Stack Into Register A
  addiu s4,1                    // SP_REG += 1 (Increment Stack)
  andi s4,$FF
  addu a2,a0,s4                 // STACK = MEM_MAP[$100 + SP_REG]
  addiu a2,$100                 // A2 = STACK
  lbu s0,0(a2)                  // A_REG = STACK
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $AF MOV   (X)+, A          MOVe Value A Into Address In X, Increment X
  andi t0,s5,P_FLAG             // (X) = MEM_MAP[X_REG | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  or t0,s1                      // T0 = X_REG | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (X_REG | (P_FLAG << 3))
  sb s0,0(a2)                   // (X) = A_REG
  addiu s1,1                    // X_REG++
  and s1,$FF
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $B0 BCS   rel              Branch To Relative Address IF Carry Set
  andi t0,s5,C_FLAG             // IF (C_FLAG) PC_REG += Relative
  beqz t0,BCSSPC
  addiu s3,1                    // PC_REG++ (Delay Slot)
  lb t0,1(a2)                   // T0 = Relative
  add s3,t0                     // PC_REG += Relative
  addiu v0,2                    // Cycles += 2
  BCSSPC:
  jr ra
  addiu v0,2                    // Cycles += 2 (Delay Slot)

align(256)
  // $B1 TCALL n                Table CALL Push PC Onto Stack Then Jump To Table Address
  subiu s4,2                    // SP_REG -= 2 (Decrement Stack)
  andi s4,$FF
  addu a2,a0,s4                 // STACK = MEM_MAP[$100 + SP_REG]
  addiu a2,$100                 // A2 = STACK
  sb s3,1(a2)                   // STACK = PC_REG
  srl t0,s3,8
  sb t0,2(a2)
  addiu a2,a0,$FFC8             // PC_REG = MEM_MAP[$FFC8]
  lbu s3,0(a2)
  lbu t0,1(a2)
  sll t0,8
  or s3,t0
  jr ra
  addiu v0,8                    // Cycles += 8 (Delay Slot)

align(256)
  // $B2 CLR1  dp.bit           CLeaR Bit In Direct Page Offset
  andi t0,s5,P_FLAG             // DP = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = DP
  andi t0,$DF                   // DP &= ^BIT
  sb t0,0(a2)                   // Store DP
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $B3 BBC   dp.bit, rel      Branch To Relative Address IF Bit Cleared In Direct Page Offset
  andi t0,s5,P_FLAG             // DP = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  lb t1,2(a2)                   // T1 = Relative
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = DP
  andi t0,$20                   // DP &= BIT
  bnez t0,BBC5SPC               // IF (! (DP & BIT)) PC_REG += Relative
  addiu s3,2                    // PC_REG += 2 (Delay Slot)
  add s3,t1                     // PC_REG += Relative
  addiu v0,2                    // Cycles += 2
  BBC5SPC:
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $B4 SBC   A, dp+X          SuBtract Value In Direct Page Offset Added With Value X + Carry Flag From A
  andi t0,s5,P_FLAG             // DPX = MEM_MAP[((Immediate + X_REG) & $FF) | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  addu t1,s1                    // T1 = Immediate + X_REG
  andi t1,$FF                   // T1 = (Immediate + X_REG) & $FF
  or t0,t1                      // T0 = ((Immediate + X_REG) & $FF) | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + ((Immediate + X_REG) & $FF) | (P_FLAG << 3)
  lbu t0,0(a2)                  // T0 = DPX
  subu s0,t0                    // A_REG -= DPX
  subu s0,t1                    // A_REG -= C_FLAG
  andi s0,$FF
  andi t1,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t1                      // PSW_REG: N Flag = Result MSB
  andi t3,t0,$80                // T3 = DPX & 0x80
  beq t2,t3,SBCADPXVASPC        // IF (A_REG & 0x80 == DPX & 0x80) &&
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  SBCADPXVASPC:
  bne t2,t1,SBCADPXVBSPC        // IF (A_REG & 0x80 != (A_REG - (DPX + C_FLAG)) & 0x80)
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  SBCADPXVBSPC:
  andi t1,s0,$F                 // Test Half Carry
  lli t2,9
  bgtu t1,t2,SBCADPXHSPC        // IF ((A_REG & $F) > 9) H Flag Set
  ori s5,H_FLAG                 // PSW_REG: H Flag Set (Delay Slot)
  andi s5,~H_FLAG               // PSW_REG: H Flag Reset
  SBCADPXHSPC:
  beqz s0,SBCADPXZSPC           // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  SBCADPXZSPC:
  bgtu s0,t0,SBCADPXCSPC        // IF (A_REG > DPX) C Flag Set
  ori s5,C_FLAG                 // PSW_REG: C Flag Set (Delay Slot)
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  SBCADPXCSPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $B5 SBC   A, !abs+X        SuBtract Value From Absolute Address Added With Value X + Carry Flag From A
  lbu t0,1(a2)                  // ABSX = MEM_MAP[Absolute + X_REG]
  lbu t1,2(a2)
  sll t1,8
  or t0,t1                      // T0 = Absolute
  addu a2,a0,t0                 // A2 = MEM_MAP + Absolute
  addu a2,s1                    // A2 = MEM_MAP + Absolute + X_REG
  lbu t0,0(a2)                  // T0 = ABSX
  subu s0,t0                    // A_REG -= ABSX
  subu s0,t1                    // A_REG -= C_FLAG
  andi s0,$FF
  andi t1,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t1                      // PSW_REG: N Flag = Result MSB
  andi t3,t0,$80                // T3 = ABSX & 0x80
  beq t2,t3,SBCAABSXVASPC       // IF (A_REG & 0x80 == ABSX & 0x80) &&
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  SBCAABSXVASPC:
  bne t2,t1,SBCAABSXVBSPC       // IF (A_REG & 0x80 != (A_REG - (ABSX + C_FLAG)) & 0x80)
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  SBCAABSXVBSPC:
  andi t1,s0,$F                 // Test Half Carry
  lli t2,9
  bgtu t1,t2,SBCAABSXHSPC       // IF ((A_REG & $F) > 9) H Flag Set
  ori s5,H_FLAG                 // PSW_REG: H Flag Set (Delay Slot)
  andi s5,~H_FLAG               // PSW_REG: H Flag Reset
  SBCAABSXHSPC:
  beqz s0,SBCAABSXZSPC          // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  SBCAABSXZSPC:
  bgtu s0,t0,SBCAABSXCSPC       // IF (A_REG > ABSX) C Flag Set
  ori s5,C_FLAG                 // PSW_REG: C Flag Set (Delay Slot)
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  SBCAABSXCSPC:
  addiu s3,2                    // PC_REG += 2
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $B6 SBC   A, !abs+Y        SuBtract Value From Absolute Address Added With Value Y + Carry Flag From A
  lbu t0,1(a2)                  // ABSY = MEM_MAP[Absolute + Y_REG]
  lbu t1,2(a2)
  sll t1,8
  or t0,t1                      // T0 = Absolute
  addu a2,a0,t0                 // A2 = MEM_MAP + Absolute
  addu a2,s2                    // A2 = MEM_MAP + Absolute + Y_REG
  lbu t0,0(a2)                  // T0 = ABSY
  subu s0,t0                    // A_REG -= ABSY
  subu s0,t1                    // A_REG -= C_FLAG
  andi s0,$FF
  andi t1,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t1                      // PSW_REG: N Flag = Result MSB
  andi t3,t0,$80                // T3 = ABSY & 0x80
  beq t2,t3,SBCAABSYVASPC       // IF (A_REG & 0x80 == ABSY & 0x80) &&
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  SBCAABSYVASPC:
  bne t2,t1,SBCAABSYVBSPC       // IF (A_REG & 0x80 != (A_REG - (ABSY + C_FLAG)) & 0x80)
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  SBCAABSYVBSPC:
  andi t1,s0,$F                 // Test Half Carry
  lli t2,9
  bgtu t1,t2,SBCAABSYHSPC       // IF ((A_REG & $F) > 9) H Flag Set
  ori s5,H_FLAG                 // PSW_REG: H Flag Set (Delay Slot)
  andi s5,~H_FLAG               // PSW_REG: H Flag Reset
  SBCAABSYHSPC:
  beqz s0,SBCAABSYZSPC          // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  SBCAABSYZSPC:
  bgtu s0,t0,SBCAABSYCSPC       // IF (A_REG > ABSY) C Flag Set
  ori s5,C_FLAG                 // PSW_REG: C Flag Set (Delay Slot)
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  SBCAABSYCSPC:
  addiu s3,2                    // PC_REG += 2
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $B7 SBC   A, [dp]+Y        SuBtract Value From Indirect Absolute Address In Direct Page Offset Added With Value Y + Carry Flag From A
  andi t0,s5,P_FLAG             // DPYI = MEM_MAP[MEM_MAP[Immediate) | (P_FLAG << 3)] + Y_REG]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate) | (P_FLAG << 3))
  lbu t0,0(a2)
  lbu t1,1(a2)
  srl t1,8
  or t0,t1                      // T0 = MEM_MAP[Immediate) | (P_FLAG << 3)]
  addu t0,s2                    // T0 = MEM_MAP[Immediate) | (P_FLAG << 3)] + Y_REG
  addu a2,a0,t0                 // A2 = MEM_MAP + MEM_MAP[Immediate) | (P_FLAG << 3) + Y_REG]
  lbu t0,0(a2)                  // T0 = DPYI
  andi t1,s5,C_FLAG             // T1 = C_FLAG
  andi t2,s0,$80                // T2 = A_REG & 0x80
  subu s0,t0                    // A_REG -= DPYI
  subu s0,t1                    // A_REG -= C_FLAG
  andi s0,$FF
  andi t1,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t1                      // PSW_REG: N Flag = Result MSB
  andi t3,t0,$80                // T3 = DPYI & 0x80
  beq t2,t3,SBCADPYIVASPC       // IF (A_REG & 0x80 == DPYI & 0x80) &&
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  SBCADPYIVASPC:
  bne t2,t1,SBCADPYIVBSPC       // IF (A_REG & 0x80 != (A_REG - (DPYI + C_FLAG)) & 0x80)
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  SBCADPYIVBSPC:
  andi t1,s0,$F                 // Test Half Carry
  lli t2,9
  bgtu t1,t2,SBCADPYIHSPC       // IF ((A_REG & $F) > 9) H Flag Set
  ori s5,H_FLAG                 // PSW_REG: H Flag Set (Delay Slot)
  andi s5,~H_FLAG               // PSW_REG: H Flag Reset
  SBCADPYIHSPC:
  beqz s0,SBCADPYIZSPC          // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  SBCADPYIZSPC:
  bgtu s0,t0,SBCADPYICSPC       // IF (A_REG > DPYI) C Flag Set
  ori s5,C_FLAG                 // PSW_REG: C Flag Set (Delay Slot)
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  SBCADPYICSPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,6                    // Cycles += 6 (Delay Slot)

align(256)
  // $B8 SBC   dp, #imm         SuBtract Immediate Value + Carry Flag From Direct Page Offset
  andi t0,s5,P_FLAG             // DP = MEM_MAP[DirectPage | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,2(a2)                  // T1 = DirectPage
  or t0,t1                      // T0 = DirectPage | (P_FLAG << 3)
  lbu t1,1(a2)                  // T1 = Immediate
  addu a2,a0,t0                 // A2 = MEM_MAP + (DirectPage | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = DP
  andi t2,s5,C_FLAG             // T2 = C_FLAG
  andi t3,t0,$80                // T3 = DP & 0x80
  subu t0,t1                    // DP -= Immediate
  subu t0,t2                    // DP -= C_FLAG
  andi t0,$FF
  sb t0,0(a2)                   // Store DP
  andi t2,t0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t2                      // PSW_REG: N Flag = Result MSB
  andi t4,t1,$80                // T4 = Immediate & 0x80
  beq t3,t4,SBCDPIMMVASPC       // IF (DP & 0x80 == Immediate & 0x80) &&
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  SBCDPIMMVASPC:
  bne t3,t2,SBCDPIMMVBSPC       // IF (DP & 0x80 != (DP - (Immediate + C_FLAG)) & 0x80)
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  SBCDPIMMVBSPC:
  andi t2,t0,$F                 // Test Half Carry
  lli t3,9
  bgtu t2,t3,SBCDPIMMHSPC       // IF ((DP & $F) > 9) H Flag Set
  ori s5,H_FLAG                 // PSW_REG: H Flag Set (Delay Slot)
  andi s5,~H_FLAG               // PSW_REG: H Flag Reset
  SBCDPIMMHSPC:
  beqz t0,SBCDPIMMZSPC          // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  SBCDPIMMZSPC:
  bgtu t0,t1,SBCDPIMMCSPC       // IF (DP > Immediate) C Flag Set
  ori s5,C_FLAG                 // PSW_REG: C Flag Set (Delay Slot)
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  SBCDPIMMCSPC:
  addiu s3,2                    // PC_REG += 2
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $B9 SBC   (X), (Y)         SuBtract Value Y + Carry Flag From X
  andi t0,s5,P_FLAG             // (Y) = MEM_MAP[Y_REG | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  or t1,t0,s2                   // T1 = Y_REG | (P_FLAG << 3)
  addu a3,a0,t1                 // A3 = MEM_MAP + (Y_REG | (P_FLAG << 3))
  lbu t1,0(a3)                  // T1 = (Y)
  or t0,s1                      // (X) = MEM_MAP[X_REG | (P_FLAG << 3)]
  addu a2,a0,t0                 // A2 = MEM_MAP + (X_REG | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = (X)
  andi t2,s5,C_FLAG             // T2 = C_FLAG
  andi t3,t0,$80                // T3 = (X) & 0x80
  subu t0,t1                    // (X) -= (Y)
  subu t0,t2                    // (X) -= C_FLAG
  andi t0,$FF
  sb t0,0(a2)                   // Store (X)
  andi t2,t0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t2                      // PSW_REG: N Flag = Result MSB
  andi t4,t1,$80                // T4 = (Y) & 0x80
  beq t3,t4,SBCXYVASPC          // IF ((X) & 0x80 == (Y) & 0x80) &&
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  SBCXYVASPC:
  bne t3,t2,SBCXYVBSPC          // IF ((X) & 0x80 != ((X) - ((Y) + C_FLAG)) & 0x80)
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  SBCXYVBSPC:
  andi t2,t0,$F                 // Test Half Carry
  lli t3,9
  bgtu t2,t3,SBCXYHSPC          // IF (((X) & $F) > 9) H Flag Set
  ori s5,H_FLAG                 // PSW_REG: H Flag Set (Delay Slot)
  andi s5,~H_FLAG               // PSW_REG: H Flag Reset
  SBCXYHSPC:
  beqz t0,SBCXYZSPC             // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  SBCXYZSPC:
  bgtu t0,t1,SBCXYCSPC          // IF ((X) > (Y)) C Flag Set
  ori s5,C_FLAG                 // PSW_REG: C Flag Set (Delay Slot)
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  SBCXYCSPC:
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $BA MOVW  YA, dp           MOVe Word In Direct Page Offset Into YA
  andi t0,s5,P_FLAG             // DPW = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu s0,0(a2)                  // YA_REG = DPW
  lbu s2,1(a2)
  move t0,s2                    // YA_REG = (Y_REG << 8) | A_REG
  sll t0,8
  or t0,s0                      // T0 = YA_REG
  andi t1,t0,$8000              // Test Negative MSB
  srl t1,8
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t1                      // PSW_REG: N Flag = Result MSB
  beqz t0,MOVWYADPSPC           // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  MOVWYADPSPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $BB INC   dp+X             INCrement Value In Direct Page Offset Added With Value X
  andi t0,s5,P_FLAG             // DPX = MEM_MAP[((Immediate + X_REG) & $FF) | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  addu t1,s1                    // T1 = Immediate + X_REG
  andi t1,$FF                   // T1 = (Immediate + X_REG) & $FF
  or t0,t1                      // T0 = ((Immediate + X_REG) & $FF) | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + ((Immediate + X_REG) & $FF) | (P_FLAG << 3)
  lbu t0,0(a2)                  // T0 = DPX
  addiu t0,1                    // DPX++
  andi t0,$FF
  sb t0,0(a2)                   // Store DPX
  andi t1,t0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t1                      // PSW_REG: N Flag = Result MSB
  beqz t0,INCDPXSPC             // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  INCDPXSPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $BC INC   A                INCrement Register A
  addiu s0,1                    // A_REG++
  andi s1,$FF
  andi t0,s1,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s1,INCASPC               // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  INCASPC:
  jr ra
  addiu v0,2                    // Cycles += 2 (Delay Slot)

align(256)
  // $BD MOV   SP, X            MOVe Value X Into SP
  move s4,s1                    // SP_REG = X_REG
  andi t0,s4,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s4,MOVSPXSPC             // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  MOVSPXSPC:
  jr ra
  addiu v0,2                    // Cycles += 2 (Delay Slot)

align(256)
  // $BE DAS   A                Decimal Adjust For Subtraction Register A (Convert To Binary Coded Data)
  lli t0,$99                    // T0 = $99
  bleu s0,t0,DASACASPC          // IF (A_REG > $99 || ! C_FLAG)
  andi t0,s5,C_FLAG             // T0 = C_FLAG (Delay Slot)
  subiu s0,$60                  // A_REG -= $60
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  j DASACBSPC
  DASACASPC:
  bnez t0,DASACBSPC
  nop                           // Delay Slot
  subiu s0,$60                  // A_REG -= $60
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  DASACBSPC:
  andi t0,s0,$F                 // T0 = A_REG & $F
  lli t1,9                      // T1 = 9
  bleu t0,t1,DASAHASPC          // IF ((A_REG & $F) > 9 || ! H_FLAG)
  andi t0,s5,H_FLAG             // T0 = H_FLAG (Delay Slot)
  subiu s0,$06                  // A_REG -= $06
  j DASAHBSPC
  DASAHASPC:
  bnez t0,DASAHBSPC
  nop                           // Delay Slot
  subiu s0,$06                  // A_REG -= $06
  DASAHBSPC:
  andi t0,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s0,DASAZSPC              // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  DASAZSPC:
  jr ra
  addiu v0,3                    // Cycles += 3 (Delay Slot)

align(256)
  // $BF MOV   A, (X)+          MOVe value from address in X into A, increment X
  andi t0,s5,P_FLAG             // (X) = MEM_MAP[X_REG | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  or t0,s1                      // T0 = X_REG | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (X_REG | (P_FLAG << 3))
  lbu s0,0(a2)                  // A_REG = (X)
  addiu s1,1                    // X_REG++
  and s1,$FF
  andi t0,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s0,MOVAXZSPC             // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  MOVAXZSPC:
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $C0 DI                     Disable Interrupts Flag
  andi s5,~I_FLAG               // PSW_REG: I Flag Reset
  jr ra
  addiu v0,3                    // Cycles += 3 (Delay Slot)

align(256)
  // $C1 TCALL n                Table CALL Push PC Onto Stack Then Jump To Table Address
  subiu s4,2                    // SP_REG -= 2 (Decrement Stack)
  andi s4,$FF
  addu a2,a0,s4                 // STACK = MEM_MAP[$100 + SP_REG]
  addiu a2,$100                 // A2 = STACK
  sb s3,1(a2)                   // STACK = PC_REG
  srl t0,s3,8
  sb t0,2(a2)
  addiu a2,a0,$FFC6             // PC_REG = MEM_MAP[$FFC6]
  lbu s3,0(a2)
  lbu t0,1(a2)
  sll t0,8
  or s3,t0
  jr ra
  addiu v0,8                    // Cycles += 8 (Delay Slot)

align(256)
  // $C2 SET1  dp.bit           SET Bit In Direct Page Offset
  andi t0,s5,P_FLAG             // DP = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = DP
  ori t0,$40                    // DP |= BIT
  sb t0,0(a2)                   // Store DP
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $C3 BBS   dp.bit, rel      Branch To Relative Address IF Bit Set In Direct Page Offset
  andi t0,s5,P_FLAG             // DP = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  lb t1,2(a2)                   // T1 = Relative
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = DP
  andi t0,$40                   // DP &= BIT
  beqz t0,BBS6SPC               // IF (DP & BIT) PC_REG += Relative
  addiu s3,2                    // PC_REG += 2 (Delay Slot)
  add s3,t1                     // PC_REG += Relative
  addiu v0,2                    // Cycles += 2
  BBS6SPC:
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $C4 MOV   dp, A            MOVe Value A Into Direct Page Offset
  andi t0,s5,P_FLAG             // DP = MEM_MAP[DirectPage | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,2(a2)                  // T1 = DirectPage
  or t0,t1                      // T0 = DirectPage | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (DirectPage | (P_FLAG << 3))
  sb s0,0(a2)                   // DP = A_REG
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $C5 MOV   !abs, A          MOVe Value A Into Absolute Address
  lbu t0,1(a2)                  // ABS = MEM_MAP[Absolute]
  lbu t1,2(a2)
  sll t1,8
  or t0,t1                      // T0 = Absolute
  addu a2,a0,t0                 // A2 = MEM_MAP + Absolute
  sb s0,0(a2)                   // ABS = A_REG
  addiu s3,2                    // PC_REG += 2
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $C6 MOV   (X), A           MOVe Value A Into Address In X
  andi t0,s5,P_FLAG             // (X) = MEM_MAP[X_REG | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  or t0,s1                      // T0 = X_REG | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (X_REG | (P_FLAG << 3))
  sb s0,0(a2)                   // (X) = A_REG
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $C7 MOV   [dp+X], A        MOVe Value A Into Indirect Absolute Address In Direct Page Offset Added With Value X
  andi t0,s5,P_FLAG             // DPXI = MEM_MAP[MEM_MAP[((Immediate + X_REG) & $FF) | (P_FLAG << 3)]]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  addu t1,s1                    // T1 = Immediate + X_REG
  andi t1,$FF                   // T1 = (Immediate + X_REG) & $FF
  or t0,t1                      // T0 = ((Immediate + X_REG) & $FF) | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + ((Immediate + X_REG) & $FF) | (P_FLAG << 3)
  lbu t0,0(a2)
  lbu t1,1(a2)
  srl t1,8
  or t0,t1                      // T0 = MEM_MAP[((Immediate + X_REG) & $FF) | (P_FLAG << 3)]
  addu a2,a0,t0                 // A2 = MEM_MAP + MEM_MAP[((Immediate + X_REG) & $FF) | (P_FLAG << 3)]
  sb s0,0(a2)                   // DPXI = A_REG
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,7                    // Cycles += 7 (Delay Slot)

align(256)
  // $C8 CMP   X, #imm          CoMPare Immediate Value With X
  lbu t0,1(a2)                  // T0 = Immediate
  subu t1,s1,t0                 // T1 = X_REG - Immediate
  andi t1,$FF
  andi t2,t1,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t2                      // PSW_REG: N Flag = Result MSB
  andi t3,s1,$80                // T3 = X_REG & $80
  andi t4,t0,$80                // T4 = Immediate & $80
  beq t3,t4,CMPXIMMVASPC        // IF (X_REG & $80 == Immediate & $80) &&
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  CMPXIMMVASPC:
  bne t3,t2,CMPXIMMVBSPC        // IF (X_REG & $80 != (X_REG - Immediate) & $80)
  ori s5,V_FLAG                 // PSW_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG               // PSW_REG: V Flag Reset
  CMPXIMMVBSPC:
  beqz t1,CMPXIMMZSPC           // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  CMPXIMMZSPC:
  bgtu t1,t0,CMPXIMMCSPC        // IF ((X_REG - Immediate) > Immediate) C Flag Set
  ori s5,C_FLAG                 // PSW_REG: C Flag Set (Delay Slot)
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  CMPXIMMCSPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,2                    // Cycles += 2 (Delay Slot)

align(256)
  // $C9 MOV   !abs, X          MOVe Value X Into Absolute Address
  lbu t0,1(a2)                  // ABS = MEM_MAP[Absolute]
  lbu t1,2(a2)
  sll t1,8
  or t0,t1                      // T0 = Absolute
  addu a2,a0,t0                 // A2 = MEM_MAP + Absolute
  sb s1,0(a2)                   // ABS = X_REG
  addiu s3,2                    // PC_REG += 2
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $CA MOV1  mem.bit, C       MOVe Carry Flag Into Memory Bit
  lbu t0,1(a2)                  // MEMBIT = (MEM_MAP[MEM] >> BIT) & 1
  lbu t1,2(a2)
  sll t1,8
  or t0,t1                      // T0 = Absolute
  srl t1,t0,13                  // T1 = BIT (Absolute >> 13)
  andi t0,$1FFF                 // T0 = MEM (Absolute & 0x1FFF)
  addu a2,a0,t0                 // A2 = MEM_MAP + MEM
  lbu t0,0(a2)                  // T0 = MEM_MAP[MEM]
  lli t2,1                      // T2 = 1
  sllv t2,t1                    // T2 = 1 << BIT
  not t2                        // T2 = ~(1 << BIT)
  and t0,t2                     // T0 = MEM_MAP[MEM] & ~(1 << BIT)
  andi t2,s5,C_FLAG             // T2 = C_FLAG
  sllv t2,t1                    // T2 = C_FLAG << BIT
  or t0,t2                      // MEMBIT = C_FLAG << BIT
  sb t0,0(a2)                   // Store MEMBIT
  addiu s3,2                    // PC_REG += 2
  jr ra
  addiu v0,6                    // Cycles += 6 (Delay Slot)

align(256)
  // $CB MOV   dp, Y            MOVe Value Y Into Direct Page Offset
  andi t0,s5,P_FLAG             // DP = MEM_MAP[DirectPage | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,2(a2)                  // T1 = DirectPage
  or t0,t1                      // T0 = DirectPage | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (DirectPage | (P_FLAG << 3))
  sb s2,0(a2)                   // DP = Y_REG
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $CC MOV   !abs, Y          MOVe Value Y Into Absolute Address
  lbu t0,1(a2)                  // ABS = MEM_MAP[Absolute]
  lbu t1,2(a2)
  sll t1,8
  or t0,t1                      // T0 = Absolute
  addu a2,a0,t0                 // A2 = MEM_MAP + Absolute
  sb s2,0(a2)                   // ABS = Y_REG
  addiu s3,2                    // PC_REG += 2
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $CD MOV   X, #imm          MOVe Immediate Value Into X
  lbu s1,1(a2)                  // X_REG = Immediate
  andi t0,s1,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s1,MOVXIMMSPC            // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  MOVXIMMSPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,2                    // Cycles += 2 (Delay Slot)

align(256)
  // $CE POP   X                POP Byte Off Stack Into Register X
  addiu s4,1                    // SP_REG += 1 (Increment Stack)
  andi s4,$FF
  addu a2,a0,s4                 // STACK = MEM_MAP[$100 + SP_REG]
  addiu a2,$100                 // A2 = STACK
  lbu s1,0(a2)                  // X_REG = STACK
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $CF MUL   YA               MULtiply Register Pair YA
  multu s2,s0                   // YA_REG = Y_REG * A_REG
  mflo t0                       // T0 = Y_REG * A_REG
  andi s0,t0,$FF                // A_REG = Result LO
  srl s2,t0,8                   // Y_REG = Result HI
  andi s2,$FF
  andi t0,s2,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s2,MULYASPC              // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  MULYASPC:
  jr ra
  addiu v0,9                    // Cycles += 9 (Delay Slot)

align(256)
  // $D0 BNE   rel              Branch To Relative Address IF Not Equal (Z = 0)
  andi t0,s5,Z_FLAG             // IF (! Z_FLAG) PC_REG += Relative
  bnez t0,BNESPC
  addiu s3,1                    // PC_REG++ (Delay Slot)
  lb t0,1(a2)                   // T0 = Relative
  add s3,t0                     // PC_REG += Relative
  addiu v0,2                    // Cycles += 2
  BNESPC:
  jr ra
  addiu v0,2                    // Cycles += 2 (Delay Slot)

align(256)
  // $D1 TCALL n                Table CALL Push PC Onto Stack Then Jump To Table Address
  subiu s4,2                    // SP_REG -= 2 (Decrement Stack)
  andi s4,$FF
  addu a2,a0,s4                 // STACK = MEM_MAP[$100 + SP_REG]
  addiu a2,$100                 // A2 = STACK
  sb s3,1(a2)                   // STACK = PC_REG
  srl t0,s3,8
  sb t0,2(a2)
  addiu a2,a0,$FFC4             // PC_REG = MEM_MAP[$FFC4]
  lbu s3,0(a2)
  lbu t0,1(a2)
  sll t0,8
  or s3,t0
  jr ra
  addiu v0,8                    // Cycles += 8 (Delay Slot)

align(256)
  // $D2 CLR1  dp.bit           CLeaR Bit In Direct Page Offset
  andi t0,s5,P_FLAG             // DP = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = DP
  andi t0,$BF                   // DP &= ^BIT
  sb t0,0(a2)                   // Store DP
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $D3 BBC   dp.bit, rel      Branch To Relative Address IF Bit Cleared In Direct Page Offset
  andi t0,s5,P_FLAG             // DP = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  lb t1,2(a2)                   // T1 = Relative
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = DP
  andi t0,$40                   // DP &= BIT
  bnez t0,BBC6SPC               // IF (! (DP & BIT)) PC_REG += Relative
  addiu s3,2                    // PC_REG += 2 (Delay Slot)
  add s3,t1                     // PC_REG += Relative
  addiu v0,2                    // Cycles += 2
  BBC6SPC:
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $D4 MOV   dp+X, A          MOVe Value A Into Direct Page Offset Added With Value X
  andi t0,s5,P_FLAG             // DPX = MEM_MAP[((Immediate + X_REG) & $FF) | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  addu t1,s1                    // T1 = Immediate + X_REG
  andi t1,$FF                   // T1 = (Immediate + X_REG) & $FF
  or t0,t1                      // T0 = ((Immediate + X_REG) & $FF) | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + ((Immediate + X_REG) & $FF) | (P_FLAG << 3)
  sb s0,0(a2)                   // DPX = A_REG
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $D5 MOV   !abs+X, A        MOVe Value A Into Absolute Address Added With Value X
  lbu t0,1(a2)                  // ABSX = MEM_MAP[Absolute + X_REG]
  lbu t1,2(a2)
  sll t1,8
  or t0,t1                      // T0 = Absolute
  addu a2,a0,t0                 // A2 = MEM_MAP + Absolute
  addu a2,s1                    // A2 = MEM_MAP + Absolute + X_REG
  sb s0,0(a2)                   // ABSX = A_REG
  addiu s3,2                    // PC_REG += 2
  jr ra
  addiu v0,6                    // Cycles += 6 (Delay Slot)

align(256)
  // $D6 MOV   !abs+Y, A        MOVe Value A Into Absolute Address Added With Value Y
  lbu t0,1(a2)                  // ABSY = MEM_MAP[Absolute + Y_REG]
  lbu t1,2(a2)
  sll t1,8
  or t0,t1                      // T0 = Absolute
  addu a2,a0,t0                 // A2 = MEM_MAP + Absolute
  addu a2,s2                    // A2 = MEM_MAP + Absolute + Y_REG
  sb s0,0(a2)                   // ABSY = A_REG
  addiu s3,2                    // PC_REG += 2
  jr ra
  addiu v0,6                    // Cycles += 6 (Delay Slot)

align(256)
  // $D7 MOV   [dp]+Y, A        MOVe Value A Into Indirect Absolute Address In Direct Page Offset Added With Value Y
  andi t0,s5,P_FLAG             // DPYI = MEM_MAP[MEM_MAP[Immediate) | (P_FLAG << 3)] + Y_REG]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate) | (P_FLAG << 3))
  lbu t0,0(a2)
  lbu t1,1(a2)
  srl t1,8
  or t0,t1                      // T0 = MEM_MAP[Immediate) | (P_FLAG << 3)]
  addu t0,s2                    // T0 = MEM_MAP[Immediate) | (P_FLAG << 3)] + Y_REG
  addu a2,a0,t0                 // A2 = MEM_MAP + MEM_MAP[Immediate) | (P_FLAG << 3) + Y_REG]
  sb s0,0(a2)                   // DPYI = A_REG
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,7                    // Cycles += 7 (Delay Slot)

align(256)
  // $D8 MOV   dp, X            MOVe Value X Into Direct Page Offset
  andi t0,s5,P_FLAG             // DP = MEM_MAP[DirectPage | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,2(a2)                  // T1 = DirectPage
  or t0,t1                      // T0 = DirectPage | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (DirectPage | (P_FLAG << 3))
  sb s1,0(a2)                   // DP = X_REG
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $D9 MOV   dp+Y, X          MOVe Value X Into Direct Page Offset Added With Value Y
  andi t0,s5,P_FLAG             // DPY = MEM_MAP[((Immediate + Y_REG) & $FF) | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  addu t1,s2                    // T1 = Immediate + Y_REG
  andi t1,$FF                   // T1 = (Immediate + Y_REG) & $FF
  or t0,t1                      // T0 = ((Immediate + Y_REG) & $FF) | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + ((Immediate + Y_REG) & $FF) | (P_FLAG << 3)
  sb s1,0(a2)                   // DPY = X_REG
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $DA MOVW  dp, YA           MOVe Word YA Into Direct Page Offset
  andi t0,s5,P_FLAG             // DPW = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate | (P_FLAG << 3))
  sb s0,0(a2)                   // DPW = YA_REG
  sb s2,1(a2)
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $DB MOV   dp+X, Y          MOVe Value Y Into Direct Page Offset Added With Value X
  andi t0,s5,P_FLAG             // DPX = MEM_MAP[((Immediate + X_REG) & $FF) | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  addu t1,s1                    // T1 = Immediate + X_REG
  andi t1,$FF                   // T1 = (Immediate + X_REG) & $FF
  or t0,t1                      // T0 = ((Immediate + X_REG) & $FF) | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + ((Immediate + X_REG) & $FF) | (P_FLAG << 3)
  sb s2,0(a2)                   // DPX = Y_REG
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $DC DEC   Y                DECrement Register Y
  subiu s2,1                    // Y_REG--
  andi s2,$FF
  andi t0,s2,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s2,DECYSPC               // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  DECYSPC:
  jr ra
  addiu v0,2                    // Cycles += 2 (Delay Slot)

align(256)
  // $DD MOV   A, Y             MOVe Value Y Into A
  move s0,s2                    // A_REG = Y_REG
  andi t0,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s0,MOVAYSPC              // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  MOVAYSPC:
  jr ra
  addiu v0,2                    // Cycles += 2 (Delay Slot)

align(256)
  // $DE CBNE  dp+X, rel        Branch To Relative Address IF Value A Is Not Equal To Direct Page Offset Added With Value X
  andi t0,s5,P_FLAG             // DPX = MEM_MAP[((Immediate + X_REG) & $FF) | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  addu t1,s1                    // T1 = Immediate + X_REG
  andi t1,$FF                   // T1 = (Immediate + X_REG) & $FF
  or t0,t1                      // T0 = ((Immediate + X_REG) & $FF) | (P_FLAG << 3)
  lb t1,2(a2)                   // T1 = Relative
  addu a2,a0,t0                 // A2 = MEM_MAP + ((Immediate + X_REG) & $FF) | (P_FLAG << 3)
  lbu t0,0(a2)                  // T0 = DPX
  beq s0,t0,CBNEDPXSPC          // IF (A_REG != DPX) PC_REG += Relative
  addiu s3,2                    // PC_REG += 2 (Delay Slot)
  add s3,t1                     // PC_REG += Relative
  addiu v0,2                    // Cycles += 2
  CBNEDPXSPC:
  jr ra
  addiu v0,6                    // Cycles += 6 (Delay Slot)

align(256)
  // $DF DAA   A                Decimal Adjust For Addition Register A (Convert To Binary Coded Data)
  lli t0,$99                    // T0 = $99
  bleu s0,t0,DAAACASPC          // IF (A_REG > $99 || C_FLAG)
  andi t0,s5,C_FLAG             // T0 = C_FLAG (Delay Slot)
  addiu s0,$60                  // A_REG += $60
  ori s5,C_FLAG                 // PSW_REG: C Flag Set
  j DAAACBSPC
  DAAACASPC:
  beqz t0,DAAACBSPC
  nop                           // Delay Slot
  addiu s0,$60                  // A_REG += $60
  ori s5,C_FLAG                 // PSW_REG: C Flag Set
  DAAACBSPC:
  andi t0,s0,$F                 // T0 = A_REG & $F
  lli t1,9                      // T1 = 9
  bleu t0,t1,DAAAHASPC          // IF ((A_REG & $F) > 9 || H_FLAG)
  andi t0,s5,H_FLAG             // T0 = H_FLAG (Delay Slot)
  addiu s0,$06                  // A_REG += $06
  j DAAAHBSPC
  DAAAHASPC:
  beqz t0,DAAAHBSPC
  nop                           // Delay Slot
  addiu s0,$06                  // A_REG += $06
  DAAAHBSPC:
  andi t0,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s0,DAAAZSPC              // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  DAAAZSPC:
  jr ra
  addiu v0,3                    // Cycles += 3 (Delay Slot)

align(256)
  // $E0 CLRV                   CLeaR OVerflow Flag & Half Carry Flag
  andi s5,~(V_FLAG + H_FLAG)    // PSW_REG: V & H Flag Reset
  jr ra
  addiu v0,2                    // Cycles += 2 (Delay Slot)

align(256)
  // $E1 TCALL n                Table CALL Push PC Onto Stack Then Jump To Table Address
  subiu s4,2                    // SP_REG -= 2 (Decrement Stack)
  andi s4,$FF
  addu a2,a0,s4                 // STACK = MEM_MAP[$100 + SP_REG]
  addiu a2,$100                 // A2 = STACK
  sb s3,1(a2)                   // STACK = PC_REG
  srl t0,s3,8
  sb t0,2(a2)
  addiu a2,a0,$FFC2             // PC_REG = MEM_MAP[$FFC2]
  lbu s3,0(a2)
  lbu t0,1(a2)
  sll t0,8
  or s3,t0
  jr ra
  addiu v0,8                    // Cycles += 8 (Delay Slot)

align(256)
  // $E2 SET1  dp.bit           SET Bit In Direct Page Offset
  andi t0,s5,P_FLAG             // DP = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = DP
  ori t0,$80                    // DP |= BIT
  sb t0,0(a2)                   // Store DP
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $E3 BBS   dp.bit, rel      Branch To Relative Address IF Bit Set In Direct Page Offset
  andi t0,s5,P_FLAG             // DP = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  lb t1,2(a2)                   // T1 = Relative
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = DP
  andi t0,$80                   // DP &= BIT
  beqz t0,BBS7SPC               // IF (DP & BIT) PC_REG += Relative
  addiu s3,2                    // PC_REG += 2 (Delay Slot)
  add s3,t1                     // PC_REG += Relative
  addiu v0,2                    // Cycles += 2
  BBS7SPC:
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $E4 MOV   A, dp            MOVe Value In Direct Page Offset Into A
  andi t0,s5,P_FLAG             // DP = MEM_MAP[DirectPage | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,2(a2)                  // T1 = DirectPage
  or t0,t1                      // T0 = DirectPage | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (DirectPage | (P_FLAG << 3))
  lbu s0,0(a2)                  // A_REG = DP
  andi t0,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s0,MOVADPSPC             // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  MOVADPSPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,3                    // Cycles += 3 (Delay Slot)

align(256)
  // $E5 MOV   A, !abs          MOVe Value From Absolute Address Into A
  lbu t0,1(a2)                  // ABS = MEM_MAP[Absolute]
  lbu t1,2(a2)
  sll t1,8
  or t0,t1                      // T0 = Absolute
  addu a2,a0,t0                 // A2 = MEM_MAP + Absolute
  lbu s0,0(a2)                  // A_REG = ABS
  andi t0,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s0,MOVAABSSPC            // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  MOVAABSSPC:
  addiu s3,2                    // PC_REG += 2
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $E6 MOV   A, (X)           MOVe Value From Address In X Into A
  andi t0,s5,P_FLAG             // (X) = MEM_MAP[X_REG | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  or t0,s1                      // T0 = X_REG | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (X_REG | (P_FLAG << 3))
  lbu s0,0(a2)                  // A_REG = (X)
  andi t0,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s0,MOVAXISPC             // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  MOVAXISPC:
  jr ra
  addiu v0,3                    // Cycles += 3 (Delay Slot)

align(256)
  // $E7 MOV   A, [dp+X]        MOVe Value From Indirect Absolute Address In Direct Page Offset Added With Value X Into A
  andi t0,s5,P_FLAG             // DPXI = MEM_MAP[MEM_MAP[((Immediate + X_REG) & $FF) | (P_FLAG << 3)]]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  addu t1,s1                    // T1 = Immediate + X_REG
  andi t1,$FF                   // T1 = (Immediate + X_REG) & $FF
  or t0,t1                      // T0 = ((Immediate + X_REG) & $FF) | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + ((Immediate + X_REG) & $FF) | (P_FLAG << 3)
  lbu t0,0(a2)
  lbu t1,1(a2)
  srl t1,8
  or t0,t1                      // T0 = MEM_MAP[((Immediate + X_REG) & $FF) | (P_FLAG << 3)]
  addu a2,a0,t0                 // A2 = MEM_MAP + MEM_MAP[((Immediate + X_REG) & $FF) | (P_FLAG << 3)]
  lbu s0,0(a2)                  // A_REG = DPXI
  andi t0,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s0,MOVADPXISPC           // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  MOVADPXISPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,6                    // Cycles += 6 (Delay Slot)

align(256)
  // $E8 MOV   A, #imm          MOVe Immediate Value Into A
  lbu s0,1(a2)                  // A_REG = Immediate
  andi t0,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s0,MOVAIMMSPC            // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  MOVAIMMSPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,2                    // Cycles += 2 (Delay Slot)

align(256)
  // $E9 MOV   X, !abs          MOVe Value From Absolute Address Into X
  lbu t0,1(a2)                  // ABS = MEM_MAP[Absolute]
  lbu t1,2(a2)
  sll t1,8
  or t0,t1                      // T0 = Absolute
  addu a2,a0,t0                 // A2 = MEM_MAP + Absolute
  lbu s1,0(a2)                  // X_REG = ABS
  andi t0,s1,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s1,MOVXABSSPC            // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  MOVXABSSPC:
  addiu s3,2                    // PC_REG += 2
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $EA NOT1  mem.bit          NOT Memory Bit
  lbu t0,1(a2)                  // MEMBIT = (MEM_MAP[MEM] >> BIT) & 1
  lbu t1,2(a2)
  sll t1,8
  or t0,t1                      // T0 = Absolute
  srl t1,t0,13                  // T1 = BIT (Absolute >> 13)
  andi t0,$1FFF                 // T0 = MEM (Absolute & 0x1FFF)
  addu a2,a0,t0                 // A2 = MEM_MAP + MEM
  lbu t0,0(a2)                  // T0 = MEM_MAP[MEM]
  lli t2,1                      // T2 = 1
  sllv t2,t1                    // T2 = 1 << BIT
  and t3,t0,t2                  // T3 = MEM_MAP[MEM] & 1 << BIT
  not t3                        // T3 = ~(MEM_MAP[MEM] & 1 << BIT)
  and t3,t2
  not t2                        // T2 = ~(1 << BIT)
  and t0,t2                     // T0 = MEM_MAP[MEM] & ~(1 << BIT)
  or t0,t3                      // T0 = MEMBIT ~= 1 << BIT
  sb t0,0(a2)                   // Store MEMBIT
  addiu s3,2                    // PC_REG += 2
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $EB MOV   Y, dp            MOVe Value In Direct Page Offset Into Y
  andi t0,s5,P_FLAG             // DP = MEM_MAP[DirectPage | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,2(a2)                  // T1 = DirectPage
  or t0,t1                      // T0 = DirectPage | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (DirectPage | (P_FLAG << 3))
  lbu s2,0(a2)                  // Y_REG = DP
  andi t0,s2,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s2,MOVYDPSPC             // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  MOVYDPSPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,3                    // Cycles += 3 (Delay Slot)

align(256)
  // $EC MOV   Y, !abs          MOVe Value From Absolute Address Into Y
  lbu t0,1(a2)                  // ABS = MEM_MAP[Absolute]
  lbu t1,2(a2)
  sll t1,8
  or t0,t1                      // T0 = Absolute
  addu a2,a0,t0                 // A2 = MEM_MAP + Absolute
  lbu s2,0(a2)                  // Y_REG = ABS
  andi t0,s2,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s2,MOVYABSSPC            // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  MOVYABSSPC:
  addiu s3,2                    // PC_REG += 2
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $ED NOTC                   NOT Carry Flag
  andi t0,s5,C_FLAG             // T0 = C_FLAG
  not t0                        // T0 = ~C_FLAG
  andi t0,1
  andi s5,~C_FLAG               // PSW_REG: C Flag Reset
  or s5,t0                      // PSW_REG: ~C Flag
  jr ra
  addiu v0,3                    // Cycles += 3 (Delay Slot)

align(256)
  // $EE POP   Y                POP Byte Off Stack Into Register Y
  addiu s4,1                    // SP_REG += 1 (Increment Stack)
  andi s4,$FF
  addu a2,a0,s4                 // STACK = MEM_MAP[$100 + SP_REG]
  addiu a2,$100                 // A2 = STACK
  lbu s2,0(a2)                  // Y_REG = STACK
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $EF SLEEP                  SLEEP Mode (Halts The Processor)
  //SLEEPSPC:                   // Halt CPU
  //j SLEEPSPC
  jr ra
  addiu v0,3                    // Cycles += 3 (Delay Slot)

align(256)
  // $F0 BEQ   rel              Branch To Relative Address IF EQual (Z = 1)
  andi t0,s5,Z_FLAG             // IF (Z_FLAG) PC_REG += Relative
  beqz t0,BEQSPC
  addiu s3,1                    // PC_REG++ (Delay Slot)
  lb t0,1(a2)                   // T0 = Relative
  add s3,t0                     // PC_REG += Relative
  addiu v0,2                    // Cycles += 2
  BEQSPC:
  jr ra
  addiu v0,2                    // Cycles += 2 (Delay Slot)

align(256)
  // $F1 TCALL n                Table CALL Push PC Onto Stack Then Jump To Table Address
  subiu s4,2                    // SP_REG -= 2 (Decrement Stack)
  andi s4,$FF
  addu a2,a0,s4                 // STACK = MEM_MAP[$100 + SP_REG]
  addiu a2,$100                 // A2 = STACK
  sb s3,1(a2)                   // STACK = PC_REG
  srl t0,s3,8
  sb t0,2(a2)
  addiu a2,a0,$FFC0             // PC_REG = MEM_MAP[$FFC0]
  lbu s3,0(a2)
  lbu t0,1(a2)
  sll t0,8
  or s3,t0
  jr ra
  addiu v0,8                    // Cycles += 8 (Delay Slot)

align(256)
  // $F2 CLR1  dp.bit           CLeaR Bit In Direct Page Offset
  andi t0,s5,P_FLAG             // DP = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = DP
  andi t0,$7F                   // DP &= ^BIT
  sb t0,0(a2)                   // Store DP
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $F3 BBC   dp.bit, rel      Branch To Relative Address IF Bit Cleared In Direct Page Offset
  andi t0,s5,P_FLAG             // DP = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  lb t1,2(a2)                   // T1 = Relative
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu t0,0(a2)                  // T0 = DP
  andi t0,$80                   // DP &= BIT
  bnez t0,BBC7SPC               // IF (! (DP & BIT)) PC_REG += Relative
  addiu s3,2                    // PC_REG += 2 (Delay Slot)
  add s3,t1                     // PC_REG += Relative
  addiu v0,2                    // Cycles += 2
  BBC7SPC:
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $F4 MOV   A, dp+X          MOVe Value In Direct Page Offset Added With Value X Into A
  andi t0,s5,P_FLAG             // DPX = MEM_MAP[((Immediate + X_REG) & $FF) | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  addu t1,s1                    // T1 = Immediate + X_REG
  andi t1,$FF                   // T1 = (Immediate + X_REG) & $FF
  or t0,t1                      // T0 = ((Immediate + X_REG) & $FF) | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + ((Immediate + X_REG) & $FF) | (P_FLAG << 3)
  lbu s0,0(a2)                  // A_REG = DPX
  andi t0,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s0,MOVADPXSPC            // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  MOVADPXSPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $F5 MOV   A, !abs+X        MOVe Value From Absolute Address Added With Value X Into A
  lbu t0,1(a2)                  // ABSX = MEM_MAP[Absolute + X_REG]
  lbu t1,2(a2)
  sll t1,8
  or t0,t1                      // T0 = Absolute
  addu a2,a0,t0                 // A2 = MEM_MAP + Absolute
  addu a2,s1                    // A2 = MEM_MAP + Absolute + X_REG
  lbu s0,0(a2)                  // A_REG = ABSX
  andi t0,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s0,MOVAABSXSPC           // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  MOVAABSXSPC:
  addiu s3,2                    // PC_REG += 2
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $F6 MOV   A, !abs+Y        MOVe Value From Absolute Address Added With Value Y Into A
  lbu t0,1(a2)                  // ABSY = MEM_MAP[Absolute + Y_REG]
  lbu t1,2(a2)
  sll t1,8
  or t0,t1                      // T0 = Absolute
  addu a2,a0,t0                 // A2 = MEM_MAP + Absolute
  addu a2,s2                    // A2 = MEM_MAP + Absolute + Y_REG
  lbu s0,0(a2)                  // A_REG = ABSY
  andi t0,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s0,MOVAABSYSPC           // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  MOVAABSYSPC:
  addiu s3,2                    // PC_REG += 2
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $F7 MOV   A, [dp]+Y        MOVe Value From Indirect Absolute Address In Direct Page Offset Added With Value Y Into A
  andi t0,s5,P_FLAG             // DPYI = MEM_MAP[MEM_MAP[Immediate) | (P_FLAG << 3)] + Y_REG]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t0,t1                      // T0 = Immediate | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (Immediate) | (P_FLAG << 3))
  lbu t0,0(a2)
  lbu t1,1(a2)
  srl t1,8
  or t0,t1                      // T0 = MEM_MAP[Immediate) | (P_FLAG << 3)]
  addu t0,s2                    // T0 = MEM_MAP[Immediate) | (P_FLAG << 3)] + Y_REG
  addu a2,a0,t0                 // A2 = MEM_MAP + MEM_MAP[Immediate) | (P_FLAG << 3) + Y_REG]
  lbu s0,0(a2)                  // A_REG = DPYI
  andi t0,s0,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s0,MOVADPYISPC           // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  MOVADPYISPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,6                    // Cycles += 6 (Delay Slot)

align(256)
  // $F8 MOV   X, dp            MOVe Value In Direct Page Offset Into X
  andi t0,s5,P_FLAG             // DP = MEM_MAP[DirectPage | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,2(a2)                  // T1 = DirectPage
  or t0,t1                      // T0 = DirectPage | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (DirectPage | (P_FLAG << 3))
  lbu s1,0(a2)                  // X_REG = DP
  andi t0,s1,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s1,MOVXDPSPC             // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  MOVXDPSPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,3                    // Cycles += 3 (Delay Slot)

align(256)
  // $F9 MOV   X, dp+Y          MOVe Value In Direct Page Offset Added With Value Y Into X
  andi t0,s5,P_FLAG             // DPY = MEM_MAP[((Immediate + Y_REG) & $FF) | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  addu t1,s2                    // T1 = Immediate + Y_REG
  andi t1,$FF                   // T1 = (Immediate + Y_REG) & $FF
  or t0,t1                      // T0 = ((Immediate + Y_REG) & $FF) | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + ((Immediate + Y_REG) & $FF) | (P_FLAG << 3)
  lbu s1,0(a2)                  // X_REG = DPY
  andi t0,s1,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s1,MOVXDPYSPC            // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  MOVXDPYSPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $FA MOV   dp, dp           MOVe Value In Direct Page Offset Into Direct Page Offset
  andi t0,s5,P_FLAG             // DPB = MEM_MAP[Immediate | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  or t1,t0                      // T1 = Immediate | (P_FLAG << 3)
  addu a3,a0,t1                 // A3 = MEM_MAP + (Immediate | (P_FLAG << 3))
  lbu t1,0(a3)                  // T1 = DPB
  lbu t2,2(a2)                  // DPA = MEM_MAP[DirectPage | (P_FLAG << 3)]
  or t0,t2                      // T0 = DirectPage | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + (DirectPage | (P_FLAG << 3))
  sb t1,0(a2)                   // DPA = DPB
  addiu s3,2                    // PC_REG += 2
  jr ra
  addiu v0,5                    // Cycles += 5 (Delay Slot)

align(256)
  // $FB MOV   Y, dp+X          MOVe Value In Direct Page Offset Added With Value X Into Y
  andi t0,s5,P_FLAG             // DPX = MEM_MAP[((Immediate + X_REG) & $FF) | (P_FLAG << 3)]
  sll t0,3                      // T0 = P_FLAG << 3
  lbu t1,1(a2)                  // T1 = Immediate
  addu t1,s1                    // T1 = Immediate + X_REG
  andi t1,$FF                   // T1 = (Immediate + X_REG) & $FF
  or t0,t1                      // T0 = ((Immediate + X_REG) & $FF) | (P_FLAG << 3)
  addu a2,a0,t0                 // A2 = MEM_MAP + ((Immediate + X_REG) & $FF) | (P_FLAG << 3)
  lbu s2,0(a2)                  // Y_REG = DPX
  andi t0,s2,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s2,MOVYDPXSPC            // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  MOVYDPXSPC:
  addiu s3,1                    // PC_REG++
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $FC INC   Y                INCrement Register Y
  addiu s2,1                    // Y_REG++
  andi s2,$FF
  andi t0,s2,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s2,INCYSPC               // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  INCYSPC:
  jr ra
  addiu v0,2                    // Cycles += 2 (Delay Slot)

align(256)
  // $FD MOV   Y, A             MOVe Value A Into Y
  move s2,s0                    // Y_REG = A_REG
  andi t0,s2,$80                // Test Negative MSB
  andi s5,~N_FLAG               // PSW_REG: N Flag Reset
  or s5,t0                      // PSW_REG: N Flag = Result MSB
  beqz s2,MOVYASPC              // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG                 // PSW_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG               // PSW_REG: Z Flag Reset
  MOVYASPC:
  jr ra
  addiu v0,2                    // Cycles += 2 (Delay Slot)

align(256)
  // $FE DBNZ  Y, rel           Decrement Register Y & Branch To Relative Address IF Not Zero
  subiu s2,1                    // Y_REG--
  andi s2,$FF
  beqz s2,DBNZYSPC              // IF (Y_REG != 0) PC_REG += Relative
  addiu s3,1                    // PC_REG++ (Delay Slot)
  lb t0,1(a2)                   // T0 = Relative
  add s3,t0                     // PC_REG += Relative
  addiu v0,2                    // Cycles += 2
  DBNZYSPC:
  jr ra
  addiu v0,4                    // Cycles += 4 (Delay Slot)

align(256)
  // $FF STOP                   STOP Mode (Halts The Processor)
  //STOPSPC:                    // Halt CPU
  //j STOPSPC
  jr ra
  addiu v0,3                    // Cycles += 3 (Delay Slot)