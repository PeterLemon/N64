CPU65816HEX00:
  // $00 BRK   #nn               Software Break
  BRKNAT()               // STACK = PB:PC_REG & P_REG, PB_REG = 0 & PC_REG = Breakpoint Vector
  jr ra
  addiu v0,8             // Cycles += 8 (Delay Slot)

CPU65816HEX02:
  // $02 COP   #nn               Co-Processor Enable
  COPNAT()               // STACK = PB:PC_REG & P_REG, PB_REG = 0 & PC_REG = COP Vector
  jr ra
  addiu v0,8             // Cycles += 8 (Delay Slot)

CPU65816HEX08:
  // $08 PHP                     Push Processor Status Register
  PushNAT8(s5)           // STACK = P_REG (8-Bit)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

CPU65816HEX0B:
  // $0B PHD                     Push Direct Page Register
  PushNAT16(s6)          // STACK = D_REG (16-Bit)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU65816HEX1B:
  // $1B TCS                     Transfer Accumulator To Stack Pointer
  andi s4,s0,$FFFF       // S_REG = C_REG (16-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU65816HEX20:
  // $20 JSR   nnnn              Jump To Subroutine Absolute
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  PushNAT16(s3)          // STACK = PC_REG (16-Bit)
  LoadIMM16(s3)          // PC_REG = Immediate (16-Bit)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU65816HEX22:
  // $22 JSL   nnnnnn            Jump To Subroutine Absolute Long
  addiu s3,2             // PC_REG += 2
  PushNAT24(s3)          // STACK = PB:PC_REG (24-Bit)
  LoadIMM16(s3)          // PC_REG = Immediate (16-Bit)
  lbu s8,3(a2)           // PB_REG = Bank Address (8-Bit)
  jr ra
  addiu v0,8             // Cycles += 8 (Delay Slot)

CPU65816HEX28:
  // $28 PLP                     Pull Status Flags
  PullNAT8(s5)           // P_REG = STACK (8-Bit)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU65816HEX2B:
  // $2B PLD                     Pull Direct Page Register
  PullNAT16(s6)          // D_REG = STACK (16-Bit)
  TestNZ16(s6)           // Test Result Negative / Zero Flags Of D_REG (16-Bit)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816HEX3B:
  // $3B TSC                     Transfer Stack Pointer To 16-Bit Accumulator
  andi s0,s4,$FFFF       // C_REG = S_REG (16-Bit)
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of C_REG (16-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU65816HEX40:
  // $40 RTI                     Return From Interrupt
  RTINAT()               // PB:PC_REG & P_REG = STACK
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

CPU65816HEX42:
  // $42 WDM   #nn               Reserved For Future Expansion
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU65816HEX44:
  // $44 MVP   sb,db             Block Move Previous
  BlockMVP()             // Transfer Bytes From Source Bank To Destination Bank
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

CPU65816HEX4B:
  // $4B PHK                     Push Program Bank Register
  PushNAT8(s8)           // STACK = PB_REG (8-Bit)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

CPU65816HEX54:
  // $54 MVN   sb,db             Block Move Next
  BlockMVN()             // Transfer Bytes From Source Bank To Destination Bank
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,7             // Cycles += 7 (Delay Slot)

CPU65816HEX5B:
  // $5B TCD                     Transfer 16-Bit Accumulator To Direct Page Register
  andi s6,s0,$FFFF       // D_REG = C_REG (16-Bit)
  TestNZ16(s6)           // Test Result Negative / Zero Flags Of D_REG (16-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU65816HEX5C:
  // $5C JML   nnnnnn            Jump Absolute Long
  LoadIMM16(s3)          // PC_REG = Immediate (16-Bit)
  lbu s8,3(a2)           // PB_REG = Bank Address (8-Bit)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU65816HEX60:
  // $60 RTS                     Return From Subroutine
  PullNAT16(s3)          // PC_REG = STACK (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU65816HEX62:
  // $62 PER   nnnn              Push Effective PC Relative Indirect Address
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  PushER16()             // STACK = Effective PC Relative Indirect Address (16-Bit)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU65816HEX6B:
  // $6B RTL                     Return From Subroutine Long
  RTLNAT()               // PB:PC_REG = STACK
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU65816HEX7B:
  // $7B TDC                     Transfer Direct Page Register To 16-Bit Accumulator
  andi s0,s6,$FFFF       // C_REG = D_REG (16-Bit)
  TestNZ16(s0)           // Test Result Negative / Zero Flags Of C_REG (16-Bit)
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU65816HEX7C:
  // $7C JMP   (nnnn,X)          Jump Absolute Indexed Indirect
  JumpABSIX16()          // PC_REG = Absolute Indexed Indirect
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU65816HEX80:
  // $80 BRA   nn                Branch Always
  Branch8()              // Branch (8-Bit)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

CPU65816HEX82:
  // $82 BRL   nnnn              Branch Always Long
  Branch16()             // Branch Long (16-Bit)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU65816HEX8B:
  // $8B PHB                     Push Data Bank Register
  PushNAT8(s7)           // STACK = DB_REG (8-Bit)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

CPU65816HEXAB:
  // $AB PLB                     Pull Data Bank Register
  PullNAT8(s7)           // DB_REG = STACK (8-Bit)
  TestNZ8(s7)            // Test Result Negative / Zero Flags Of DB_REG (8-Bit)
  jr ra
  addiu v0,4             // Cycles += 4 (Delay Slot)

CPU65816HEXC2:
  // $C2 REP   #nn               Reset Status Bits
  REPNAT()               // P_REG: Immediate Flags Reset (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

CPU65816HEXCB:
  // $CB WAI                     Wait For Interrupt
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

CPU65816HEXD4:
  // $D4 PEI   (dp)              Push Effective Indirect Address
  PushEI16()             // STACK = Effective Indirect Address (16-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU65816HEXDB:
  // $DB STP                     Stop The Processor
  //STPLoop:
  //  b STPLoop            // Stop Processor Loop
  //  nop                  // Delay Slot
  jr ra
  addiu v0,2             // Cycles += 2 (Delay Slot)

CPU65816HEXDC:
  // $DC JML   (nnnn)            Jump Absolute Indirect Long
  JumpABSI16()           // PC_REG = Absolute Indirect (16-Bit)
  lbu s8,2(a2)           // PB_REG = Bank Address (8-Bit)
  jr ra
  addiu v0,6             // Cycles += 6 (Delay Slot)

CPU65816HEXE2:
  // $E2 SEP   #nn               Set Status Bits
  SEPNAT()               // P_REG: Immediate Flags Set (8-Bit)
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

CPU65816HEXEB:
  // $EB XBA                     Exchange The B & A Accumulators
  andi t1,s0,$FF         // T1 = A_REG (8-Bit)
  sll t1,8               // T1 = B_REG (8-Bit)
  srl t0,s0,8            // T0 = A_REG (8-Bit)
  or s0,t1,t0            // A_REG = B_REG  (8-Bit) / B_REG = A_REG (8-Bit)
  TestNZ8(t0)            // Test Result Negative / Zero Flags Of A_REG (8-Bit)
  jr ra
  addiu v0,3             // Cycles += 3 (Delay Slot)

CPU65816HEXF4:
  // $F4 PEA   nnnn              Push Effective Absolute Address
  PushEA16()             // STACK = Effective Absolute Address (16-Bit)
  addiu s3,2             // PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             // Cycles += 5 (Delay Slot)

CPU65816HEXFC:
  // $FC JSR   (nnnn,X)          Jump To Subroutine Absolute Indexed Indirect
  addiu s3,1             // PC_REG++ (Increment Program Counter)
  PushNAT16(s3)          // STACK = PC_REG (16-Bit)
  JumpABSIX16()          // PC_REG = Absolute Indexed Indirect
  jr ra
  addiu v0,8             // Cycles += 8 (Delay Slot)