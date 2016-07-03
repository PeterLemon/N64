align(256)
  // $00 NOP                    No Operation
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $01 LD    BC, imm          Load 16-Bit Immediate Value To BC
  lbu s1,1(a2)                  // BC_REG = Imm16Bit Lo
  lbu t0,2(a2)                  // T0 = Imm16Bit Hi
  sll t0,8
  or s1,t0                      // BC_REG = Imm16Bit
  addiu s4,2                    // PC_REG += 2
  jr ra
  addiu v0,3                    // QCycles += 3 (Delay Slot)

align(256)
  // $02 LD    (BC), A          Load Value A To Address In BC
  srl t0,s0,8                   // T0 = A_REG
  addu a2,a0,s1                 // A2 = MEM_MAP + BC_REG
  sb t0,0(a2)                   // MEM_MAP[BC_REG] = A_REG
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $03 INC   BC               Increment Register BC
  addiu s1,1                    // BC_REG++
  andi s1,$FFFF
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $04 INC   B                Increment Register B
  addiu s1,$100                 // B_REG++
  andi s1,$FFFF
  srl t0,s1,8                   // T0 = B_REG
  beqz t0,INCBZ                 // IF (! B_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  INCBZ:
  andi t0,$F
  beqz t0,INCBH                 // IF (! (B_REG & $F)) H Flag Set (Carry From Bit 3)
  ori s0,H_FLAG                 // F_REG: H Flag Set (Carry From Bit 3) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (No Carry From Bit 3)
  INCBH:
  andi s0,~N_FLAG               // F_REG: N Flag Reset
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $05 DEC   B                Decrement Register B
  andi t0,s1,$F00               // T0 = B_REG & $F
  beqz t0,DECBH                 // IF (! (B_REG & $F)) H Flag Set (No Borrow From Bit 4)
  ori s0,H_FLAG                 // F_REG: H Flag Set (No Borrow From Bit 4) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (Borrow From Bit 4)
  DECBH:
  subiu s1,$100                 // B_REG--
  andi s1,$FFFF
  srl t0,s1,8                   // T0 = B_REG
  beqz t0,DECBZ                 // IF (! B_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  DECBZ:
  ori s0,N_FLAG                 // F_REG: N Flag Set
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $06 LD    B, imm           Load 8-Bit Immediate Value To B
  lbu t0,1(a2)                  // T0 = Imm8Bit
  sll t0,8
  andi s1,$FF                   // B_REG = Imm8Bit
  or s1,t0
  addiu s4,1                    // PC_REG++
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $07 RLCA                   Rotate Register A Left, Old Bit 7 To Carry Flag
  srl t0,s0,8                   // T0 = A_REG
  sll t0,1                      // T0 = A_REG << 1
  srl t1,s0,15                  // T1 = A_REG >> 7
  or t0,t1                      // T0 = (A_REG << 1) | (A_REG >> 7)
  sll t0,8
  andi s0,$FF
  or s0,t0                      // A_REG = (A_REG << 1) | (A_REG >> 7)
  andi t0,s0,$100
  bnez t0,RLCC                  // IF (A_REG & 1) C Flag Set (Old Bit 7)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Old Bit 7) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Old Bit 7)
  RLCC:
  andi s0,~(H_FLAG+N_FLAG+Z_FLAG) // F_REG: H Flag Reset, N Flag Reset, Z Flag Reset
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $08 LD    (imm), SP        Load Stack Pointer (SP) To 16-Bit Immediate Address
  lbu t0,1(a2)                  // MEM_MAP[Imm16Bit] = SP_REG
  lbu t1,2(a2)
  sll t1,8
  or t0,t1                      // T0 = Imm16Bit
  addu t0,a0                    // T0 = MEM_MAP[Imm16Bit]
  sb sp,0(t0)
  srl t1,sp,8
  sb t1,1(t0)
  addiu s4,2                    // PC_REG += 2
  jr ra
  addiu v0,5                    // QCycles += 5 (Delay Slot)

align(256)
  // $09 ADD   HL, BC           Add BC To HL
  andi t0,s3,$FFF               // IF ((HL_REG & $FFF) + (BC_REG & $FFF) & $1000) H Flag Set (Carry From Bit 11)
  andi t1,s1,$FFF
  addu t0,t1
  andi t0,$1000
  bnez t0,ADDHLBCH
  ori s0,H_FLAG                 // F_REG: H Flag Set (Carry From Bit 11) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (No Carry From Bit 11)
  ADDHLBCH:
  addu s3,s1                    // HL_REG += BC_REG
  srl t0,s3,16
  bnez t0,ADDHLBCC              // IF (HL_REG >> 16 == 1) C Flag Set (Carry From Bit 15)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Carry From Bit 15) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (No Carry From Bit 15)
  ADDHLBCC:
  andi s3,$FFFF
  andi s0,~N_FLAG               // F_REG: N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $0A LD    A, (BC)          Load 8-Bit Value From Address In BC To A
  addu a2,a0,s1                 // A2 = MEM_MAP + BC_REG
  lbu t0,0(a2)                  // T0 = MEM_MAP[BC_REG]
  sll t0,8                      // T0 <<= 8
  andi s0,$FF
  or s0,t0                      // A_REG = MEM_MAP[BC_REG]
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $0B DEC   BC               Decrement Register BC
  sub s1,1                      // BC_REG--
  andi s1,$FFFF
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $0C INC   C                Increment Register C
  addiu s1,1                    // C_REG++
  andi t0,s1,$FF
  bnez t0,INCCZ                 // IF (! C_REG) Z Flag Set, B_REG-- (Result Is Zero)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero) (Delay Slot)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero)
  subiu s1,$100                 // B_REG-- (Result Is Zero)
  INCCZ:
  andi t0,$F
  beqz t0,INCCH                 // IF (! (C_REG & $F)) H Flag Set (Carry From Bit 3)
  ori s0,H_FLAG                 // F_REG: H Flag Set (Carry From Bit 3) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (No Carry From Bit 3)
  INCCH:
  andi s0,~N_FLAG               // F_REG: N Flag Reset
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $0D DEC   C                Decrement Register C
  andi t0,s1,$F
  beqz t0,DECCH                 // IF (! (C_REG & $F)) H Flag Set (No Borrow From Bit 4)
  ori s0,H_FLAG                 // F_REG: H Flag Set (No Borrow From Bit 4) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (Borrow From Bit 4)
  DECCH:
  sub s1,1                      // C_REG--
  andi t0,s1,$FF
  beqz t0,DECCZ                 // IF (! C_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  DECCZ:
  ori s0,N_FLAG                 // F_REG: N Flag Set
  xori t0,$FF
  beqz t0,DECCB
  addiu s1,$100                 // B_REG++ (Delay Slot)
  DECCB:
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $0E LD    C, imm           Load 8-Bit Immediate Value To C
  lbu t0,1(a2)                  // C_REG = Imm8Bit
  andi s1,$FF00
  or s1,t0
  addiu s4,1                    // PC_REG++
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $0F RRCA                   Rotate Register A Right, Old Bit 0 To Carry Flag
  andi t0,s0,$100
  bnez t0,RRCC                  // IF (A_REG & 1) C Flag Set (Old Bit 0)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Old Bit 0) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Old Bit 0)
  RRCC:
  srl t1,s0,9                   // A_REG = (A_REG >> 1) | (A_REG << 7)
  sll t1,8
  or t0,t1
  andi s0,$FF
  or s0,t0
  andi s0,~(H_FLAG+N_FLAG+Z_FLAG) // F_REG: H Flag Reset, N Flag Reset, Z Flag Reset
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $10 STOP                   Halt CPU & LCD Display Until Button Press
  lli t9,1                      // IME_FLAG = 1
  lli t0,$10                    // IF_REG = $10 (Set Joypad Interrupt On)
  addiu a2,a0,IF_REG            // A2 = MEM_MAP + IF_REG
  sb t0,0(a2)
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $11 LD    DE, imm          Load 16-Bit Immediate Value To DE
  lbu s2,1(a2)                  // DE_REG = Imm16Bit Lo
  lbu t0,2(a2)                  // T0 = Imm16Bit Hi
  sll t0,8
  or s2,t0                      // DE_REG = Imm16Bit
  addiu s4,2                    // PC_REG += 2
  jr ra
  addiu v0,3                    // QCycles += 3 (Delay Slot)

align(256)
  // $12 LD    (DE), A          Load Value A To Address In DE
  srl t0,s0,8                   // T0 = A_REG
  addu a2,a0,s2                 // A2 = MEM_MAP + DE_REG
  sb t0,0(a2)                   // MEM_MAP[DE_REG] = A_REG
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $13 INC   DE               Increment Register DE
  addiu s2,1                    // DE_REG++
  andi s2,$FFFF
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $14 INC   D                Increment Register D
  addiu s2,$100                 // D_REG++
  andi s2,$FFFF
  srl t0,s2,8                   // T0 = D_REG
  beqz t0,INCDZ                 // IF (! D_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  INCDZ:
  andi t0,$F
  beqz t0,INCDH                 // IF (! (D_REG & $F)) H Flag Set (Carry From Bit 3)
  ori s0,H_FLAG                 // F_REG: H Flag Set (Carry From Bit 3) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (No Carry From Bit 3)
  INCDH:
  andi s0,~N_FLAG               // F_REG: N Flag Reset
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $15 DEC   D                Decrement Register D
  andi t0,s2,$F00               // T0 = D_REG & $F
  beqz t0,DECDH                 // IF (! (D_REG & $F)) H Flag Set (No Borrow From Bit 4)
  ori s0,H_FLAG                 // F_REG: H Flag Set (No Borrow From Bit 4) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (Borrow From Bit 4)
  DECDH:
  subiu s2,$100                 // D_REG--
  andi s2,$FFFF
  srl t0,s2,8                   // T0 = D_REG
  beqz t0,DECDZ                 // IF (! D_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  DECDZ:
  ori s0,N_FLAG                 // F_REG: N Flag Set
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $16 LD    D, imm           Load 8-Bit Immediate Value To D
  lbu t0,1(a2)                  // T0 = Imm8Bit
  sll t0,8
  andi s2,$FF                   // D_REG = Imm8Bit
  or s2,t0
  addiu s4,1                    // PC_REG++
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $17 RLA                    Rotate Register A Left, Through Carry Flag
  srl t0,s0,7                   // A_REG = (A_REG << 1) | (C_FLAG)
  andi t1,s0,C_FLAG
  bnez t1,RLAA
  ori t0,1                      // Delay Slot
  andi t0,~1
  RLAA:
  andi t1,t0,$100
  bnez t1,RLC                   // IF (A_REG & $100) C Flag Set (Old Bit 7)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Old Bit 7) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Old Bit 7)
  RLC:
  andi t0,$FF
  andi s0,$FF
  sll t0,8
  or s0,t0
  andi s0,~(H_FLAG+N_FLAG+Z_FLAG) // F_REG: H Flag Reset, N Flag Reset, Z Flag Reset
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $18 JR    imm              Add 8-Bit Signed Immediate Value To Current Address & Jump To It 
  lb t0,1(a2)                   // PC_REG += Imm8Bit
  add s4,t0
  addiu s4,1                    // PC_REG++
  jr ra
  addiu v0,3                    // QCycles += 3 (Delay Slot)

align(256)
  // $19 ADD   HL, DE           Add DE To HL
  andi t0,s3,$FFF               // IF ((HL_REG & $FFF) + (DE_REG & $FFF) & $1000) H Flag Set (Carry From Bit 11)
  andi t1,s2,$FFF
  addu t0,t1
  andi t0,$1000
  bnez t0,ADDHLDEH
  ori s0,H_FLAG                 // F_REG: H Flag Set (Carry From Bit 11) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (No Carry From Bit 11)
  ADDHLDEH:
  addu s3,s2                    // HL_REG += DE_REG
  srl t0,s3,16
  bnez t0,ADDHLDEC              // IF (HL_REG >> 16 == 1) C Flag Set (Carry From Bit 15)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Carry From Bit 15) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (No Carry From Bit 15)
  ADDHLDEC:
  andi s3,$FFFF
  andi s0,~N_FLAG               // F_REG: N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $1A LD    A, (DE)          Load 8-Bit Value From Address In DE To A
  addu a2,a0,s2                 // A2 = MEM_MAP + DE_REG
  lbu t0,0(a2)                  // T0 = MEM_MAP[DE_REG]
  sll t0,8                      // T0 <<= 8
  andi s0,$FF
  or s0,t0                      // A_REG = MEM_MAP[DE_REG]
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $1B DEC   DE               Decrement Register DE
  sub s2,1                      // DE_REG--
  andi s2,$FFFF
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $1C INC   E                Increment Register E
  addiu s2,1                    // E_REG++
  andi t0,s2,$FF
  bnez t0,INCEZ                 // IF (! E_REG) Z Flag Set, D_REG-- (Result Is Zero)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero) (Delay Slot)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero)
  subiu s2,$100                 // D_REG-- (Result Is Zero)
  INCEZ:
  andi t0,$F
  beqz t0,INCEH                 // IF (! (E_REG & $F)) H Flag Set (Carry From Bit 3)
  ori s0,H_FLAG                 // F_REG: H Flag Set (Carry From Bit 3) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (No Carry From Bit 3)
  INCEH:
  andi s0,~N_FLAG               // F_REG: N Flag Reset
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $1D DEC   E                Decrement Register E
  andi t0,s2,$F
  beqz t0,DECEH                 // IF (! (E_REG & $F)) H Flag Set (No Borrow From Bit 4)
  ori s0,H_FLAG                 // F_REG: H Flag Set (No Borrow From Bit 4) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (Borrow From Bit 4)
  DECEH:
  sub s2,1                      // E_REG--
  andi t0,s2,$FF
  beqz t0,DECEZ                 // IF (! E_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  DECEZ:
  ori s0,N_FLAG                 // F_REG: N Flag Set
  xori t0,$FF
  beqz t0,DECED
  addiu s2,$100                 // D_REG++ (Delay Slot)
  DECED:
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $1E LD    E, imm           Load 8-Bit Immediate Value To E
  lbu t0,1(a2)                  // E_REG = Imm8Bit
  andi s2,$FF00
  or s2,t0
  addiu s4,1                    // PC_REG++
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $1F RRA                    Rotate Register A Right, Through Carry Flag
  srl t0,s0,9                   // A_REG = (A_REG >> 1) | (C_FLAG << 7)
  andi t1,s0,C_FLAG
  bnez t1,RRAA
  ori t0,$80                    // Delay Slot
  andi t0,~$80
  RRAA:
  andi t1,s0,$100
  bnez t1,RRC                   // IF (A_REG & 1) C Flag Set (Old Bit 0)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Old Bit 0) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Old Bit 0)
  RRC:
  andi t0,$FF
  andi s0,$FF
  sll t0,8
  or s0,t0
  andi s0,~(H_FLAG+N_FLAG+Z_FLAG) // F_REG: H Flag Reset, N Flag Reset, Z Flag Reset
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $20 JR    NZ, imm          IF Z Flag Reset, Add 8-Bit Signed Immediate Value To Current Address & Jump To It
  andi t0,s0,Z_FLAG
  bnez t0,JRNZ
  nop                           // Delay Slot
  lb t0,1(a2)                   // IF (! Z_FLAG) {
  add s4,t0                     //   PC_REG += Imm8Bit
  addiu v0,1                    //   QCycles++ }
  JRNZ:
  addiu s4,1                    // PC_REG++
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $21 LD    HL, imm          Load 16-Bit Immediate Value To HL
  lbu s3,1(a2)                  // HL_REG = Imm16Bit Lo
  lbu t0,2(a2)                  // T0 = Imm16Bit Hi
  sll t0,8
  or s3,t0                      // HL_REG = Imm16Bit
  addiu s4,2                    // PC_REG += 2
  jr ra
  addiu v0,3                    // QCycles += 3 (Delay Slot)

align(256)
  // $22 LD    (HLI), A         Load A To Memory Address HL, Increment HL
  srl t0,s0,8                   // MEM_MAP[HL_REG] = A_REG
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  sb t0,0(a2)
  addiu s3,1                    // HL_REG++
  andi s3,$FFFF
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $23 INC   HL               Increment Register HL
  addiu s3,1                    // HL_REG++
  andi s3,$FFFF
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $24 INC   H                Increment Register H
  addiu s3,$100                 // H_REG++
  andi s3,$FFFF
  srl t0,s3,8                   // T0 = H_REG
  beqz t0,INCHZ                 // IF (! H_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  INCHZ:
  andi t0,$F
  beqz t0,INCHH                 // IF (! (H_REG & $F)) H Flag Set (Carry From Bit 3)
  ori s0,H_FLAG                 // F_REG: H Flag Set (Carry From Bit 3) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (No Carry From Bit 3)
  INCHH:
  andi s0,~N_FLAG               // F_REG: N Flag Reset
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $25 DEC   H                Decrement Register H
  andi t0,s3,$F00               // T0 = H_REG & $F
  beqz t0,DECHH                 // IF (! (H_REG & $F)) H Flag Set (No Borrow From Bit 4)
  ori s0,H_FLAG                 // F_REG: H Flag Set (No Borrow From Bit 4) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (Borrow From Bit 4)
  DECHH:
  subiu s3,$100                 // H_REG--
  andi s3,$FFFF
  srl t0,s3,8                   // T0 = H_REG
  beqz t0,DECHZ                 // IF (! H_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  DECHZ:
  ori s0,N_FLAG                 // F_REG: N Flag Set
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $26 LD    H, imm           Load 8-Bit Immediate Value To H
  lbu t0,1(a2)                  // T0 = Imm8Bit
  sll t0,8
  andi s3,$FF                   // H_REG = Imm8Bit
  or s3,t0
  addiu s4,1                    // PC_REG++
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $27 DAA                    Decimal Adjust Register A (Convert To Binary Coded Data)
  srl t0,s0,8                   // A = A_REG
  andi t1,s0,N_FLAG             // IF (! N_FLAG) {
  bnez t1,DAA_N_FLAG
  nop                           // Delay Slot
  andi t1,s0,H_FLAG
  bnez t1,DAA_H_FLAG            //   IF (H_FLAG || (A & $F) > $9) A += $6
  addiu t0,6                    //   A += $6 (Delay Slot)
  andi t1,t0,$F
  lli t2,9
  bgt t1,t2,DAA_H_FLAG
  addiu t0,6                    //   A += $6 (Delay Slot)
DAA_H_FLAG:
  andi t1,s0,C_FLAG
  bnez t1,DAA_END               //   IF (C_FLAG || A > $9F) A += $60 }
  addiu t0,$60                  //   A += $60 (Delay Slot)
  lli t1,$9F
  bgt t0,t1,DAA_END
  addiu t0,$60                  //   A += $60 (Delay Slot)
  b DAA_END
  nop                           //   Delay Slot
DAA_N_FLAG:                     // ELSE {
  andi t1,s0,H_FLAG             //   IF (H_FLAG) {
  beqz t1,DAA_C_FLAG
  nop                           //   Delay Slot
  subiu t0,6                    //     A -= $6
  andi t1,s0,C_FLAG
  beqz t1,DAA_C_FLAG            //     IF (! C_FLAG) A &= $FF }
  andi t0,$FF                   //     A &= $FF (Delay Slot)
DAA_C_FLAG:
  bnez t1,DAA_END               //   IF (C_FLAG) A -= $60 }
  subiu t0,$60                  //   A -= $60 (Delay Slot)
DAA_END:
  andi t1,t0,$100               // IF (A & $100) C Flag Set (Carry From Bit 7)
  bnez t1,DAAC
  ori s0,C_FLAG                 // F_REG: C Flag Set (Carry From Bit 7) (Delay Slot)
  DAAC:
  andi s0,~H_FLAG               // F_REG: H Flag Reset
  andi t0,$FF                   // A_REG = A
  andi s0,$FF
  sll t0,8
  or s0,t0
  beqz t0,DAAZ                 // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG              // F_REG: Z Flag Reset (Result Is Not Zero)
  DAAZ:
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $28 JR    Z, imm           IF Z Flag Set, Add 8-Bit Signed Immediate Value To Current Address & Jump To It
  andi t0,s0,Z_FLAG
  beqz t0,JRZ
  nop                           // Delay Slot
  lb t0,1(a2)                   // IF (Z_FLAG) {
  add s4,t0                     //   PC_REG += Imm8Bit
  addiu v0,1                    //   QCycles++ }
  JRZ:
  addiu s4,1                    // PC_REG++
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $29 ADD   HL, HL           Add HL To HL
  andi t0,s3,$FFF               // IF ((HL_REG & $FFF) << 1 & $1000) H Flag Set IF Carry From Bit 11
  sll t0,1
  andi t0,$1000
  bnez t0,ADDHLHLH
  ori s0,H_FLAG                 // F_REG: H Flag Set (Carry From Bit 11) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (No Carry From Bit 11)
  ADDHLHLH:
  sll s3,1                      // HL_REG += HL_REG
  srl t0,s3,16
  bnez t0,ADDHLHLC              // IF (HL_REG >> 16 == 1) C Flag Set (Carry From Bit 15)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Carry From Bit 15) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (No Carry From Bit 15)
  ADDHLHLC:
  andi s3,$FFFF
  andi s0,~N_FLAG               // F_REG: N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $2A LD    A, (HLI)         Load Value At Address HL To A, Increment HL
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  lb t0,0(a2)                   // A_REG = MEM_MAP[HL_REG]
  and s0,$FF
  sll t0,8
  or s0,t0
  addiu s3,1                    // HL_REG++
  andi s3,$FFFF
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $2B DEC   HL               Decrement Register HL
  subiu s3,1                    // HL_REG--
  andi s3,$FFFF
  jr ra
  addiu v0,1                    // QCycles += 1 (Delay Slot)

align(256)
  // $2C INC   L                Increment Register L
  addiu s3,1                    // L_REG++
  andi t0,s3,$FF
  bnez t0,INCLZ                 // IF (! L_REG) Z Flag Set, H_REG-- (Result Is Zero)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero) (Delay Slot)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero)
  subiu s3,$100                 // H_REG-- (Result Is Zero)
  INCLZ:
  andi t0,$F
  beqz t0,INCLH                 // IF (! (L_REG & $F)) H Flag Set (Carry From Bit 3)
  ori s0,H_FLAG                 // F_REG: H Flag Set (Carry From Bit 3) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (No Carry From Bit 3)
  INCLH:
  andi s0,~N_FLAG               // F_REG: N Flag Reset
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $2D DEC   L                Decrement Register L
  andi t0,s3,$F
  beqz t0,DECLH                 // IF (! (L_REG & $F)) H Flag Set (No Borrow From Bit 4)
  ori s0,H_FLAG                 // F_REG: H Flag Set (No Borrow From Bit 4) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (Borrow From Bit 4)
  DECLH:
  sub s3,1                      // L_REG--
  andi t0,s3,$FF
  beqz t0,DECLZ                 // IF (! L_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  DECLZ:
  ori s0,N_FLAG                 // F_REG: N Flag Set
  xori t0,$FF
  beqz t0,DECLHR
  addiu s3,$100                 // H_REG++ (Delay Slot)
  DECLHR:
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $2E LD    L, imm           Load 8-Bit Immediate Value To L
  lbu t0,1(a2)                  // L_REG = Imm8Bit
  andi s3,$FF00
  or s3,t0
  addiu s4,1                    // PC_REG++
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $2F CPL                    Complement Register A (Flip All Bits)
  xori s0,$FF00                 // A_REG ^= $FF
  ori s0,H_FLAG+N_FLAG          // F_REG: H Flag Set, N Flag Set
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $30 JR    NC, imm          IF C Flag Reset, Add 8-Bit Signed Immediate Value To Current Address & Jump To It
  andi t0,s0,C_FLAG
  bnez t0,JRNC
  nop                           // Delay Slot
  lb t0,1(a2)                   // IF (! C_FLAG) {
  add s4,t0                     //   PC_REG += Imm8Bit
  addiu v0,1                    //   QCycles++ }
  JRNC:
  addiu s4,1                    // PC_REG++
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $31 LD    SP, imm          Load 16-Bit Immediate Value To SP
  lbu sp,1(a2)                  // SP_REG = Imm16Bit Lo
  lbu t0,2(a2)                  // T0 = Imm16Bit Hi
  sll t0,8
  or sp,t0                      // SP_REG = Imm16Bit
  addiu s4,2                    // PC_REG += 2
  jr ra
  addiu v0,3                    // QCycles += 3 (Delay Slot)

align(256)
  // $32 LD    (HLD), A         Load A To Memory Address HL, Decrement HL
  srl t0,s0,8                   // MEM_MAP[HL_REG] = A_REG
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  sb t0,0(a2)
  subiu s3,1                    // HL_REG--
  andi s3,$FFFF
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $33 INC   SP               Increment Register SP
  addiu sp,1                    // SP_REG++
  andi sp,$FFFF
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $34 INC   (HL)             Increment Address In Register HL
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  lbu t0,0(a2)                  // MEM_MAP[HL_REG]++
  addiu t0,1
  sb t0,0(a2)
  andi t0,$FF
  beqz t0,INCHLZ                // IF (! MEM_MAP[HL_REG]) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  INCHLZ:
  andi t0,$F
  beqz t0,INCHLH                // IF (! (MEM_MAP[HL_REG] & $F)) H Flag Set (Carry From Bit 3)
  ori s0,H_FLAG                 // F_REG: H Flag Set (Carry From Bit 3) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (No Carry From Bit 3)
  INCHLH:
  andi s0,~N_FLAG               // F_REG: N Flag Reset
  jr ra
  addiu v0,3                    // QCycles += 3 (Delay Slot)

align(256)
  // $35 DEC   (HL)             Decrement Address In Register HL
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  lbu t0,0(a2)
  andi t1,t0,$F
  beqz t1,DECHLH                // IF (! (MEM_MAP[HL_REG] & $F)) H Flag Set (No Borrow From Bit 4)
  ori s0,H_FLAG                 // F_REG: H Flag Set (No Borrow From Bit 4) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (Borrow From Bit 4)
  DECHLH:
  subiu t0,1                    // MEM_MAP[HL_REG]--
  sb t0,0(a2)
  andi t0,$FF
  beqz t0,DECHLZ                // IF (! MEM_MAP[HL_REG]) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  DECHLZ:
  ori s0,N_FLAG                 // F_REG: N Flag Set
  jr ra
  addiu v0,3                    // QCycles += 3 (Delay Slot)

align(256)
  // $36 LD    (HL), imm        Load 8-Bit Immediate Value To Address In HL
  lbu t0,0(a2)                  // MEM_MAP[HL_REG] = Imm8Bit
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  sb t0,0(a2)
  addiu s4,1                    // PC_REG++
  jr ra
  addiu v0,3                    // QCycles += 3 (Delay Slot)

align(256)
  // $37 SCF                    Set Carry Flag
  ori s0,C_FLAG                 // F_REG: C Flag Set
  andi s0,~(H_FLAG+N_FLAG)      // F_REG: H Flag Reset, N Flag Reset
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $38 JR    C, imm           IF C Flag Set, Add 8-Bit Signed Immediate Value To Current Address & Jump To It
  andi t0,s0,C_FLAG
  beqz t0,JRC
  nop                           // Delay Slot
  lb t0,1(a2)                   // IF (C_FLAG) {
  add s4,t0                     //   PC_REG += Imm8Bit
  addiu v0,1                    //   QCycles++ }
  JRC:
  addiu s4,1                    // PC_REG++
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $39 ADD   HL, SP           Add SP To HL
  andi t0,s3,$FFF               // IF ((HL_REG & $FFF) + (SP_REG & $FFF) & $1000) H Flag Set (Carry From Bit 11)
  andi t1,sp,$FFF
  addu t0,t1
  andi t0,$1000
  bnez t0,ADDHLSPH
  ori s0,H_FLAG                 // F_REG: H Flag Set (Carry From Bit 11) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (No Carry From Bit 11)
  ADDHLSPH:
  addu s3,sp                    // HL_REG += SP_REG
  srl t0,s3,16
  bnez t0,ADDHLSPC              // IF (HL_REG >> 16 == 1) C Flag Set (Carry From Bit 15)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Carry From Bit 15) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (No Carry From Bit 15)
  ADDHLSPC:
  andi s3,$FFFF
  andi s0,~N_FLAG               // F_REG: N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $3A LD    A, (HLD)         Load Value At Address HL To A, Decrement HL
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  lb t0,0(a2)                   // A_REG = MEM_MAP[HL_REG]
  and s0,$FF
  sll t0,8
  or s0,t0
  subiu s3,1                    // HL_REG--
  andi s3,$FFFF
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $3B DEC   SP               Decrement Register SP
  subiu sp,1                    // SP_REG--
  andi sp,$FFFF
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $3C INC   A                Increment Register A
  addiu s0,$100                 // A_REG++
  andi s0,$FFFF
  srl t0,s0,8                   // T0 = A_REG
  beqz t0,INCAZ                 // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  INCAZ:
  andi t0,$F
  beqz t0,INCAH                 // IF (! (A_REG & $F)) H Flag Set (Carry From Bit 3)
  ori s0,H_FLAG                 // F_REG: H Flag Set (Carry From Bit 3) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (No Carry From Bit 3)
  INCAH:
  andi s0,~N_FLAG               // F_REG: N Flag Reset
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $3D DEC   A                Decrement Register A
  andi t0,s0,$F00               // T0 = A_REG & $F
  beqz t0,DECAH                 // IF (! (A_REG & $F)) H Flag Set (No Borrow From Bit 4)
  ori s0,H_FLAG                 // F_REG: H Flag Set (No Borrow From Bit 4) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (Borrow From Bit 4)
  DECAH:
  subiu s0,$100                 // A_REG--
  andi s0,$FFFF
  srl t0,s0,8                   // T0 = A_REG
  beqz t0,DECAZ                 // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  DECAZ:
  ori s0,N_FLAG                 // F_REG: N Flag Set
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $3E LD    A, imm           Load 8-Bit Immediate Value To A
  lbu t0,1(a2)                  // T0 = Imm8Bit
  sll t0,8
  andi s0,$FF                   // A_REG = Imm8Bit
  or s0,t0
  addiu s4,1                    // PC_REG++
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $3F CCF                    Complement Carry Flag (Flip Carry Bit)
  xor s0,C_FLAG                 // F_REG ^= $10
  andi s0,~(H_FLAG+N_FLAG)      // F_REG: H Flag Reset, N Flag Reset
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $40 LD    B, B             Load Value B To B
                                // B_REG = B_REG
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $41 LD    B, C             Load Value C To B
  andi t0,s1,$FF                // B_REG = C_REG
  andi s1,$FF
  sll t0,8
  or s1,t0
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $42 LD    B, D             Load Value D To B
  srl t0,s2,8                   // B_REG = D_REG
  andi s1,$FF
  sll t0,8
  or s1,t0
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $43 LD    B, E             Load Value E To B
  andi t0,s2,$FF                // B_REG = E_REG
  andi s1,$FF
  sll t0,8
  or s1,t0
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $44 LD    B, H             Load Value H To B
  srl t0,s3,8                   // B_REG = H_REG
  andi s1,$FF
  sll t0,8
  or s1,t0
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $45 LD    B, L             Load Value L To B
  andi t0,s3,$FF                // B_REG = L_REG
  andi s1,$FF
  sll t0,8
  or s1,t0
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $46 LD    B, (HL)          Load 8-Bit Value From Address In HL To B
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  lbu t0,0(a2)                  // B_REG = MEM_MAP[HL_REG]
  andi s1,$FF
  sll t0,8
  or s1,t0
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $47 LD    B, A             Load Value A To B
  srl t0,s0,8                   // B_REG = A_REG
  andi s1,$FF
  sll t0,8
  or s1,t0
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $48 LD    C, B             Load Value B To C
  srl t0,s1,8                   // C_REG = B_REG
  andi s1,$FF00
  or s1,t0
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $49 LD    C, C             Load Value C To C
                                // C_REG = C_REG
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $4A LD    C, D             Load Value D To C
  srl t0,s2,8                   // C_REG = D_REG
  andi s1,$FF00
  or s1,t0
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $4B LD    C, E             Load Value E To C
  andi t0,s2,$FF                // C_REG = E_REG
  andi s1,$FF00
  or s1,t0
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $4C LD    C, H             Load Value H To C
  srl t0,s3,8                   // C_REG = H_REG
  andi s1,$FF00
  or s1,t0
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $4D LD    C, L             Load Value L To C
  andi t0,s3,$FF                // C_REG = L_REG
  andi s1,$FF00
  or s1,t0
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $4E LD    C, (HL)          Load 8-Bit Value From Address In HL To C
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  lbu t0,0(a2)                  // C_REG = MEM_MAP[HL_REG]
  andi s1,$FF00
  or s1,t0
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $4F LD    C, A             Load Value A To C
  srl t0,s0,8                   // C_REG = A_REG
  andi s1,$FF00
  or s1,t0
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $50 LD    D, B             Load Value B To D
  srl t0,s1,8                   // D_REG = B_REG
  andi s2,$FF
  sll t0,8
  or s2,t0
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $51 LD    D, C             Load Value C To D
  andi t0,s1,$FF                // D_REG = C_REG
  andi s2,$FF
  sll t0,8
  or s2,t0
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $52 LD    D, D             Load Value D To D
                                // D_REG = D_REG
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $53 LD    D, E             Load Value E To D
  andi t0,s2,$FF                // D_REG = E_REG
  andi s2,$FF
  sll t0,8
  or s2,t0
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $54 LD    D, H             Load Value H To D
  srl t0,s3,8                   // D_REG = H_REG
  andi s2,$FF
  sll t0,8
  or s2,t0
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $55 LD    D, L             Load Value L To D
  andi t0,s3,$FF                // D_REG = L_REG
  andi s2,$FF
  or s2,t0
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $56 LD    D, (HL)          Load 8-Bit Value From Address In HL To D
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  lbu t0,0(a2)                  // D_REG = MEM_MAP[HL_REG]
  andi s2,$FF
  sll t0,8
  or s2,t0
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $57 LD    D, A             Load Value A To D
  srl t0,s0,8                   // D_REG = A_REG
  andi s2,$FF
  sll t0,8
  or s2,t0
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $58 LD    E, B             Load Value B To E
  srl t0,s1,8                   // E_REG = B_REG
  andi s2,$FF00
  or s2,t0
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $59 LD    E, C             Load Value C To E
  andi t0,s1,$FF                // E_REG = C_REG
  andi s2,$FF00
  or s2,t0
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $5A LD    E, D             Load Value D To E
  srl t0,s2,8                   // E_REG = D_REG
  andi s2,$FF00
  or s2,t0
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $5B LD    E, E             Load Value E To E
                                // E_REG = E_REG
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $5C LD    E, H             Load Value H To E
  srl t0,s3,8                   // E_REG = H_REG
  andi s2,$FF00
  or s2,t0
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $5D LD    E, L             Load Value L To E
  andi t0,s3,$FF                // E_REG = L_REG
  andi s2,$FF00
  or s2,t0
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $5E LD    E, (HL)          Load 8-Bit Value From Address In HL To E
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  lbu t0,0(a2)                  // E_REG = MEM_MAP[HL_REG]
  andi s2,$FF00
  or s2,t0
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $5F LD    E, A             Load Value A To E
  srl t0,s0,8                   // E_REG = A_REG
  andi s2,$FF00
  or s2,t0
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $60 LD    H, B             Load Value B To H
  srl t0,s1,8                   // H_REG = B_REG
  andi s3,$FF
  sll t0,8
  or s3,t0
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $61 LD    H, C             Load Value C To H
  andi t0,s1,$FF                // H_REG = C_REG
  andi s3,$FF
  sll t0,8
  or s3,t0
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $62 LD    H, D             Load Value D To H
  srl t0,s2,8                   // H_REG = D_REG
  andi s3,$FF
  sll t0,8
  or s3,t0
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $63 LD    H, E             Load Value E To H
  andi t0,s2,$FF                // H_REG = E_REG
  andi s3,$FF
  sll t0,8
  or s3,t0
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $64 LD    H, H             Load Value H To H
                                // H_REG = H_REG
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $65 LD    H, L             Load Value L To H
  andi t0,s3,$FF                // H_REG = L_REG
  andi s3,$FF
  sll t0,8
  or s3,t0
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $66 LD    H, (HL)          Load 8-Bit Value From Address In HL To H
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  lbu t0,0(a2)                  // H_REG = MEM_MAP[HL_REG]
  andi s3,$FF
  sll t0,8
  or s3,t0
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $67 LD    H, A             Load Value A To H
  srl t0,s0,8                   // H_REG = A_REG
  andi s3,$FF
  sll t0,8
  or s3,t0
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $68 LD    L, B             Load Value B To L
  srl t0,s1,8                   // L_REG = B_REG
  andi s3,$FF00
  or s3,t0
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $69 LD    L, C             Load Value C To L
  andi t0,s1,$FF                // L_REG = C_REG
  andi s3,$FF00
  or s3,t0
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $6A LD    L, D             Load Value D To L
  srl t0,s2,8                   // L_REG = D_REG
  andi s3,$FF00
  or s3,t0
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $6B LD    L, E             Load Value E To L
  andi t0,s2,$FF                // L_REG = E_REG
  andi s3,$FF00
  or s3,t0
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $6C LD    L, H             Load Value H To L
  srl t0,s3,8                   // L_REG = H_REG
  andi s3,$FF00
  or s3,t0
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $6D LD    L, L             Load Value L To L
                                // L_REG = L_REG
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $6E LD    L, (HL)          Load 8-Bit Value From Address In HL To L
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  lbu t0,0(a2)                  // L_REG = MEM_MAP[HL_REG]
  andi s3,$FF00
  or s3,t0
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $6F LD    L, A             Load Value A To L
  srl t0,s0,8                   // L_REG = A_REG
  andi s3,$FF00
  or s3,t0
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $70 LD    (HL), B          Load Value B To Address In HL
  srl t0,s1,8                   // MEM_MAP[HL_REG] = B_REG
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  sb t0,0(a2)
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $71 LD    (HL), C          Load Value C To Address In HL
  andi t0,s1,$FF                // MEM_MAP[HL_REG] = C_REG
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  sb t0,0(a2)
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $72 LD    (HL), D          Load Value D To Address In HL
  srl t0,s2,8                   // MEM_MAP[HL_REG] = D_REG
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  sb t0,0(a2)
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $73 LD    (HL), E          Load Value E To Address In HL
  andi t0,s2,$FF                // MEM_MAP[HL_REG] = E_REG
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  sb t0,0(a2)
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $74 LD    (HL), H          Load Value H To Address In HL
  srl t0,s3,8                   // MEM_MAP[HL_REG] = H_REG
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  sb t0,0(a2)
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $75 LD    (HL), L          Load Value L To Address In HL
  andi t0,s3,$FF                // MEM_MAP[HL_REG] = L_REG
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  sb t0,0(a2)
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $76 HALT                   Power Down CPU Until An Interrupt Occurs
  lli t9,1                      // IME_FLAG = 1
  lli t0,$1F                    // IF_REG = $1F (Set All Interrupts On)
  addiu a2,a0,IF_REG            // A2 = MEM_MAP + IF_REG
  sb t0,0(a2)
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $77 LD    (HL), A          Load Value A To Address In HL
  srl t0,s0,8                   // MEM_MAP[HL_REG] = A_REG
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  sb t0,0(a2)
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $78 LD    A, B             Load Value B To A
  srl t0,s1,8                   // A_REG = B_REG
  andi s0,$FF
  sll t0,8
  or s0,t0
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $79 LD    A, C             Load Value C To A
  andi t0,s1,$FF                // A_REG = C_REG
  andi s0,$FF
  sll t0,8
  or s0,t0
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $7A LD    A, D             Load Value D To A
  srl t0,s2,8                   // A_REG = D_REG
  andi s0,$FF
  sll t0,8
  or s0,t0
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $7B LD    A, E             Load Value E To A
  andi t0,s2,$FF                // A_REG = E_REG
  andi s0,$FF
  sll t0,8
  or s0,t0
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $7C LD    A, H             Load Value H To A
  srl t0,s3,8                   // A_REG = H_REG
  andi s0,$FF
  sll t0,8
  or s0,t0
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $7D LD    A, L             Load Value L To A
  andi t0,s3,$FF                // A_REG = L_REG
  andi s0,$FF
  sll t0,8
  or s0,t0
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $7E LD    A, (HL)          Load 8-Bit Value From Address In HL To A
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  lbu t0,0(a2)                  // A_REG = MEM_MAP[HL_REG]
  andi s0,$FF
  sll t0,8
  or s0,t0
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $7F LD    A, A             Load Value A To A
                                // A_REG = A_REG
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $80 ADD   A, B             Add B To A
  srl t0,s0,8                   // IF ((A_REG & $F) + (B_REG & $F) & $10) H Flag Set (Carry From Bit 3)
  srl t1,s1,8
  andi t2,t0,$F
  andi t3,t1,$F
  addu t2,t3
  andi t2,$10
  bnez t2,ADDABH
  ori s0,H_FLAG                 // F_REG: H Flag Set (Carry From Bit 3) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (No Carry From Bit 3)
  ADDABH:
  addu t0,t1                    // A_REG += B_REG
  andi t1,t0,$100
  bnez t1,ADDABC                // IF (A_REG & $100) C Flag Set (Carry From Bit 7)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Carry From Bit 7) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (No Carry From Bit 7)
  ADDABC:
  andi t0,$FF
  andi s0,$FF
  sll t0,8
  or s0,t0
  beqz t0,ADDABZ                // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  ADDABZ:
  andi s0,~N_FLAG               // F_REG: N Flag Reset
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $81 ADD   A, C             Add C To A
  srl t0,s0,8                   // IF ((A_REG & $F) + (C_REG & $F) & $10) H Flag Set (Carry From Bit 3)
  andi t1,s1,$FF
  andi t2,t0,$F
  andi t3,t1,$F
  addu t2,t3
  andi t2,$10
  bnez t2,ADDACH
  ori s0,H_FLAG                 // F_REG: H Flag Set (Carry From Bit 3) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (No Carry From Bit 3)
  ADDACH:
  addu t0,t1                    // A_REG += C_REG
  andi t1,t0,$100
  bnez t1,ADDACC                // IF (A_REG & $100) C Flag Set (Carry From Bit 7)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Carry From Bit 7) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (No Carry From Bit 7)
  ADDACC:
  andi t0,$FF
  andi s0,$FF
  sll t0,8
  or s0,t0
  beqz t0,ADDACZ                // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  ADDACZ:
  andi s0,~N_FLAG               // F_REG: N Flag Reset
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $82 ADD   A, D             Add D To A
  srl t0,s0,8                   // IF ((A_REG & $F) + (D_REG & $F) & $10) H Flag Set (Carry From Bit 3)
  srl t1,s2,8
  andi t2,t0,$F
  andi t3,t1,$F
  addu t2,t3
  andi t2,$10
  bnez t2,ADDADH
  ori s0,H_FLAG                 // F_REG: H Flag Set (Carry From Bit 3) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (No Carry From Bit 3)
  ADDADH:
  addu t0,t1                    // A_REG += D_REG
  andi t1,t0,$100
  bnez t1,ADDADC                // IF (A_REG & $100) C Flag Set (Carry From Bit 7)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Carry From Bit 7) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (No Carry From Bit 7)
  ADDADC:
  andi t0,$FF
  andi s0,$FF
  sll t0,8
  or s0,t0
  beqz t0,ADDADZ                // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  ADDADZ:
  andi s0,~N_FLAG               // F_REG: N Flag Reset
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $83 ADD   A, E             Add E To A
  srl t0,s0,8                   // IF ((A_REG & $F) + (E_REG & $F) & $10) H Flag Set (Carry From Bit 3)
  andi t1,s2,$FF
  andi t2,t0,$F
  andi t3,t1,$F
  addu t2,t3
  andi t2,$10
  bnez t2,ADDAEH
  ori s0,H_FLAG                 // F_REG: H Flag Set (Carry From Bit 3) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (No Carry From Bit 3)
  ADDAEH:
  addu t0,t1                    // A_REG += E_REG
  andi t1,t0,$100
  bnez t1,ADDAEC                // IF (A_REG & $100) C Flag Set (Carry From Bit 7)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Carry From Bit 7) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (No Carry From Bit 7)
  ADDAEC:
  andi t0,$FF
  andi s0,$FF
  sll t0,8
  or s0,t0
  beqz t0,ADDAEZ                // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  ADDAEZ:
  andi s0,~N_FLAG               // F_REG: N Flag Reset
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $84 ADD   A, H             Add H To A
  srl t0,s0,8                   // IF ((A_REG & $F) + (H_REG & $F) & $10) H Flag Set (Carry From Bit 3)
  srl t1,s3,8
  andi t2,t0,$F
  andi t3,t1,$F
  addu t2,t3
  andi t2,$10
  bnez t2,ADDAHH
  ori s0,H_FLAG                 // F_REG: H Flag Set (Carry From Bit 3) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (No Carry From Bit 3)
  ADDAHH:
  addu t0,t1                    // A_REG += H_REG
  andi t1,t0,$100
  bnez t1,ADDAHC                // IF (A_REG & $100) C Flag Set (Carry From Bit 7)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Carry From Bit 7) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (No Carry From Bit 7)
  ADDAHC:
  andi t0,$FF
  andi s0,$FF
  sll t0,8
  or s0,t0
  beqz t0,ADDAHZ                // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  ADDAHZ:
  andi s0,~N_FLAG               // F_REG: N Flag Reset
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $85 ADD   A, L             Add L To A
  srl t0,s0,8                   // IF ((A_REG & $F) + (L_REG & $F) & $10) H Flag Set (Carry From Bit 3)
  andi t1,s3,$FF
  andi t2,t0,$F
  andi t3,t1,$F
  addu t2,t3
  andi t2,$10
  bnez t2,ADDALH
  ori s0,H_FLAG                 // F_REG: H Flag Set (Carry From Bit 3) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (No Carry From Bit 3)
  ADDALH:
  addu t0,t1                    // A_REG += L_REG
  andi t1,t0,$100
  bnez t1,ADDALC                // IF (A_REG & $100) C Flag Set (Carry From Bit 7)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Carry From Bit 7) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (No Carry From Bit 7)
  ADDALC:
  andi t0,$FF
  andi s0,$FF
  sll t0,8
  or s0,t0
  beqz t0,ADDALZ                // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  ADDALZ:
  andi s0,~N_FLAG               // F_REG: N Flag Reset
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $86 ADD   A, (HL)          Add 8-Bit Value From Address In HL To A
  srl t0,s0,8                   // IF ((A_REG & $F) + (MEM_MAP[HL_REG] & $F) & $10) H Flag Set (Carry From Bit 3)
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  lbu t1,0(a2)
  andi t2,t0,$F
  andi t3,t1,$F
  addu t2,t3
  andi t2,$10
  bnez t2,ADDAHLH
  ori s0,H_FLAG                 // F_REG: H Flag Set (Carry From Bit 3) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (No Carry From Bit 3)
  ADDAHLH:
  addu t0,t1                    // A_REG += MEM_MAP[HL_REG]
  andi t1,t0,$100
  bnez t1,ADDAHLC               // IF (A_REG & $100) C Flag Set (Carry From Bit 7)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Carry From Bit 7) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (No Carry From Bit 7)
  ADDAHLC:
  andi t0,$FF
  andi s0,$FF
  sll t0,8
  or s0,t0
  beqz t0,ADDAHLZ               // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  ADDAHLZ:
  andi s0,~N_FLAG               // F_REG: N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $87 ADD   A, A             Add A To A
  srl t0,s0,8                   // IF ((A_REG & $F) << 1 & $10) H Flag Set (Carry From Bit 3)
  andi t1,t0,$F
  sll t1,1
  andi t1,$10
  bnez t2,ADDAAH
  ori s0,H_FLAG                 // F_REG: H Flag Set (Carry From Bit 3) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (No Carry From Bit 3)
  ADDAAH:
  sll t0,1                      // A_REG += A_REG
  andi t1,t0,$100
  bnez t1,ADDAAC                // IF (A_REG & $100) C Flag Set (Carry From Bit 7)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Carry From Bit 7) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (No Carry From Bit 7)
  ADDAAC:
  andi t0,$FF
  andi s0,$FF
  sll t0,8
  or s0,t0
  beqz t0,ADDAAZ                // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  ADDAAZ:
  andi s0,~N_FLAG               // F_REG: N Flag Reset
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $88 ADC   A, B             Add B + Carry Flag To A
  srl t0,s0,8                   // IF ((A_REG & $F) + (B_REG & $F) + C_FLAG & $10) H Flag Set (Carry From Bit 3)
  srl t1,s1,8
  andi t2,t0,$F
  andi t3,t1,$F
  addu t2,t3
  andi t3,s0,C_FLAG
  srl t3,4
  addu t2,t3
  andi t2,$10
  bnez t2,ADDCABH
  ori s0,H_FLAG                 // F_REG: H Flag Set (Carry From Bit 3) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (No Carry From Bit 3)
  ADDCABH:
  addu t0,t1                    // A_REG += B_REG + C_FLAG
  addu t0,t3
  andi t1,t0,$100
  bnez t1,ADDCABC               // IF (A_REG & $100) C Flag Set (Carry From Bit 7)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Carry From Bit 7) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (No Carry From Bit 7)
  ADDCABC:
  andi t0,$FF
  andi s0,$FF
  sll t0,8
  or s0,t0
  beqz t0,ADDCABZ               // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  ADDCABZ:
  andi s0,~N_FLAG               // F_REG: N Flag Reset
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $89 ADC   A, C             Add C + Carry Flag To A
  srl t0,s0,8                   // IF ((A_REG & $F) + (C_REG & $F) + C_FLAG & $10) H Flag Set (Carry From Bit 3)
  andi t1,s1,$FF
  andi t2,t0,$F
  andi t3,t1,$F
  addu t2,t3
  andi t3,s0,C_FLAG
  srl t3,4
  addu t2,t3
  andi t2,$10
  bnez t2,ADDCACH
  ori s0,H_FLAG                 // F_REG: H Flag Set (Carry From Bit 3) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (No Carry From Bit 3)
  ADDCACH:
  addu t0,t1                    // A_REG += C_REG + C_FLAG
  addu t0,t3
  andi t1,t0,$100
  bnez t1,ADDCACC               // IF (A_REG & $100) C Flag Set (Carry From Bit 7)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Carry From Bit 7) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (No Carry From Bit 7)
  ADDCACC:
  andi t0,$FF
  andi s0,$FF
  sll t0,8
  or s0,t0
  beqz t0,ADDCACZ               // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  ADDCACZ:
  andi s0,~N_FLAG               // F_REG: N Flag Reset
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $8A ADC   A, D             Add D + Carry Flag To A
  srl t0,s0,8                   // IF ((A_REG & $F) + (D_REG & $F) + C_FLAG & $10) H Flag Set (Carry From Bit 3)
  srl t1,s2,8
  andi t2,t0,$F
  andi t3,t1,$F
  addu t2,t3
  andi t3,s0,C_FLAG
  srl t3,4
  addu t2,t3
  andi t2,$10
  bnez t2,ADDCADH
  ori s0,H_FLAG                 // F_REG: H Flag Set (Carry From Bit 3) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (No Carry From Bit 3)
  ADDCADH:
  addu t0,t1                    // A_REG += D_REG + C_FLAG
  addu t0,t3
  andi t1,t0,$100
  bnez t1,ADDCADC               // IF (A_REG & $100) C Flag Set (Carry From Bit 7)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Carry From Bit 7) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (No Carry From Bit 7)
  ADDCADC:
  andi t0,$FF
  andi s0,$FF
  sll t0,8
  or s0,t0
  beqz t0,ADDCADZ               // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  ADDCADZ:
  andi s0,~N_FLAG               // F_REG: N Flag Reset
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $8B ADC   A, E             Add E + Carry Flag To A
  srl t0,s0,8                   // IF ((A_REG & $F) + (E_REG & $F) + C_FLAG & $10) H Flag Set (Carry From Bit 3)
  andi t1,s2,$FF
  andi t2,t0,$F
  andi t3,t1,$F
  addu t2,t3
  andi t3,s0,C_FLAG
  srl t3,4
  addu t2,t3
  andi t2,$10
  bnez t2,ADDCAEH
  ori s0,H_FLAG                 // F_REG: H Flag Set (Carry From Bit 3) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (No Carry From Bit 3)
  ADDCAEH:
  addu t0,t1                    // A_REG += E_REG + C_FLAG
  addu t0,t3
  andi t1,t0,$100
  bnez t1,ADDCAEC               // IF (A_REG & $100) C Flag Set (Carry From Bit 7)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Carry From Bit 7) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (No Carry From Bit 7)
  ADDCAEC:
  andi t0,$FF
  andi s0,$FF
  sll t0,8
  or s0,t0
  beqz t0,ADDCAEZ               // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  ADDCAEZ:
  andi s0,~N_FLAG               // F_REG: N Flag Reset
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $8C ADC   A, H             Add H + Carry Flag To A
  srl t0,s0,8                   // IF ((A_REG & $F) + (H_REG & $F) + C_FLAG & $10) H Flag Set (Carry From Bit 3)
  srl t1,s3,8
  andi t2,t0,$F
  andi t3,t1,$F
  addu t2,t3
  andi t3,s0,C_FLAG
  srl t3,4
  addu t2,t3
  andi t2,$10
  bnez t2,ADDCAHH
  ori s0,H_FLAG                 // F_REG: H Flag Set (Carry From Bit 3) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (No Carry From Bit 3)
  ADDCAHH:
  addu t0,t1                    // A_REG += H_REG + C_FLAG
  addu t0,t3
  andi t1,t0,$100
  bnez t1,ADDCAHC               // IF (A_REG & $100) C Flag Set (Carry From Bit 7)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Carry From Bit 7) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (No Carry From Bit 7)
  ADDCAHC:
  andi t0,$FF
  andi s0,$FF
  sll t0,8
  or s0,t0
  beqz t0,ADDCAHZ               // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  ADDCAHZ:
  andi s0,~N_FLAG               // F_REG: N Flag Reset
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $8D ADC   A, L             Add L + Carry Flag To A
  srl t0,s0,8                   // IF ((A_REG & $F) + (L_REG & $F) + C_FLAG & $10) H Flag Set (Carry From Bit 3)
  andi t1,s3,$FF
  andi t2,t0,$F
  andi t3,t1,$F
  addu t2,t3
  andi t3,s0,C_FLAG
  srl t3,4
  addu t2,t3
  andi t2,$10
  bnez t2,ADDCALH
  ori s0,H_FLAG                 // F_REG: H Flag Set (Carry From Bit 3) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (No Carry From Bit 3)
  ADDCALH:
  addu t0,t1                    // A_REG += L_REG + C_FLAG
  addu t0,t3
  andi t1,t0,$100
  bnez t1,ADDCALC               // IF (A_REG & $100) C Flag Set (Carry From Bit 7)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Carry From Bit 7) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (No Carry From Bit 7)
  ADDCALC:
  andi t0,$FF
  andi s0,$FF
  sll t0,8
  or s0,t0
  beqz t0,ADDCALZ               // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  ADDCALZ:
  andi s0,~N_FLAG               // F_REG: N Flag Reset
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $8E ADC   A, (HL)          Add 8-Bit Value From Address In HL + Carry Flag To A
  srl t0,s0,8                   // IF ((A_REG & $F) + (MEM_MAP[HL_REG] & $F) + C_FLAG & $10) H Flag Set (Carry From Bit 3)
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  lbu t1,0(a2)
  andi t2,t0,$F
  andi t3,t1,$F
  addu t2,t3
  andi t3,s0,C_FLAG
  srl t3,4
  addu t2,t3
  andi t2,$10
  bnez t2,ADDCAHLH
  ori s0,H_FLAG                 // F_REG: H Flag Set (Carry From Bit 3) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (No Carry From Bit 3)
  ADDCAHLH:
  addu t0,t1                    // A_REG += MEM_MAP[HL_REG] + C_FLAG
  addu t0,t3
  andi t1,t0,$100
  bnez t1,ADDCAHLC              // IF (A_REG & $100) C Flag Set (Carry From Bit 7)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Carry From Bit 7) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (No Carry From Bit 7)
  ADDCAHLC:
  andi t0,$FF
  andi s0,$FF
  sll t0,8
  or s0,t0
  beqz t0,ADDCAHLZ              // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  ADDCAHLZ:
  andi s0,~N_FLAG               // F_REG: N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $8F ADC   A, A             Add A + Carry Flag To A
  srl t0,s0,8                   // IF (((A_REG & $F) << 1) + C_FLAG & $10) H Flag Set (Carry From Bit 3)
  andi t1,t0,$F
  srl t1,t1,1
  andi t2,s0,C_FLAG
  srl t2,4
  addu t1,t2
  andi t1,$10
  bnez t1,ADDCAAH
  ori s0,H_FLAG                 // F_REG: H Flag Set (Carry From Bit 3) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (No Carry From Bit 3)
  ADDCAAH:
  sll t0,t0,1                   // A_REG += A_REG + C_FLAG
  addu t0,t2
  andi t1,t0,$100
  bnez t1,ADDCAAC               // IF (A_REG & $100) C Flag Set (Carry From Bit 7)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Carry From Bit 7) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (No Carry From Bit 7)
  ADDCAAC:
  andi t0,$FF
  andi s0,$FF
  sll t0,8
  or s0,t0
  beqz t0,ADDCAAZ               // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  ADDCAAZ:
  andi s0,~N_FLAG               // F_REG: N Flag Reset
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $90 SUB   B                Subtract B From A
  srl t0,s0,8                   // IF ((A_REG & $F) - (B_REG & $F) < $0) H Flag Set (No Borrow From Bit 4)
  srl t1,s1,8
  andi t2,t0,$F
  andi t3,t1,$F
  sub t2,t3
  bltz t2,SUBBH
  ori s0,H_FLAG                 // F_REG: H Flag Set (No Borrow From Bit 4) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (Borrow From Bit 4)
  SUBBH:
  sub t0,t1                     // A_REG -= B_REG
  bltz t0,SUBBC                 // IF (A_REG < $0) C Flag Set (No Borrow)
  ori s0,C_FLAG                 // F_REG: C Flag Set (No Borrow) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Borrow)
  SUBBC:
  andi t0,$FF
  andi s0,$FF
  sll t0,8
  or s0,t0
  beqz t0,SUBBZ                 // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  SUBBZ:
  ori s0,N_FLAG                 // F_REG: N Flag Set
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $91 SUB   C                Subtract C From A
  srl t0,s0,8                   // IF ((A_REG & $F) - (C_REG & $F) < $0) H Flag Set (No Borrow From Bit 4)
  andi t1,s1,$FF
  andi t2,t0,$F
  andi t3,t1,$F
  sub t2,t3
  bltz t2,SUBCH
  ori s0,H_FLAG                 // F_REG: H Flag Set (No Borrow From Bit 4) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (Borrow From Bit 4)
  SUBCH:
  sub t0,t1                     // A_REG -= C_REG
  bltz t0,SUBCC                 // IF (A_REG < $0) C Flag Set (No Borrow)
  ori s0,C_FLAG                 // F_REG: C Flag Set (No Borrow) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Borrow)
  SUBCC:
  andi t0,$FF
  andi s0,$FF
  sll t0,8
  or s0,t0
  beqz t0,SUBCZ                 // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  SUBCZ:
  ori s0,N_FLAG                 // F_REG: N Flag Set
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $92 SUB   D                Subtract D From A
  srl t0,s0,8                   // IF ((A_REG & $F) - (D_REG & $F) < $0) H Flag Set (No Borrow From Bit 4)
  srl t1,s2,8
  andi t2,t0,$F
  andi t3,t1,$F
  sub t2,t3
  bltz t2,SUBDH
  ori s0,H_FLAG                 // F_REG: H Flag Set (No Borrow From Bit 4) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (Borrow From Bit 4)
  SUBDH:
  sub t0,t1                     // A_REG -= D_REG
  bltz t0,SUBDC                 // IF (A_REG < $0) C Flag Set (No Borrow)
  ori s0,C_FLAG                 // F_REG: C Flag Set (No Borrow) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Borrow)
  SUBDC:
  andi t0,$FF
  andi s0,$FF
  sll t0,8
  or s0,t0
  beqz t0,SUBDZ                 // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  SUBDZ:
  ori s0,N_FLAG                 // F_REG: N Flag Set
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $93 SUB   E                Subtract E From A
  srl t0,s0,8                   // IF ((A_REG & $F) - (E_REG & $F) < $0) H Flag Set (No Borrow From Bit 4)
  andi t1,s2,$FF
  andi t2,t0,$F
  andi t3,t1,$F
  sub t2,t3
  bltz t2,SUBEH
  ori s0,H_FLAG                 // F_REG: H Flag Set (No Borrow From Bit 4) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (Borrow From Bit 4)
  SUBEH:
  sub t0,t1                     // A_REG -= E_REG
  bltz t0,SUBEC                 // IF (A_REG < $0) C Flag Set (No Borrow)
  ori s0,C_FLAG                 // F_REG: C Flag Set (No Borrow) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Borrow)
  SUBEC:
  andi t0,$FF
  andi s0,$FF
  sll t0,8
  or s0,t0
  beqz t0,SUBEZ                 // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  SUBEZ:
  ori s0,N_FLAG                 // F_REG: N Flag Set
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $94 SUB   H                Subtract H From A
  srl t0,s0,8                   // IF ((A_REG & $F) - (H_REG & $F) < $0) H Flag Set (No Borrow From Bit 4)
  srl t1,s3,8
  andi t2,t0,$F
  andi t3,t1,$F
  sub t2,t3
  bltz t2,SUBHH
  ori s0,H_FLAG                 // F_REG: H Flag Set (No Borrow From Bit 4) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (Borrow From Bit 4)
  SUBHH:
  sub t0,t1                     // A_REG -= H_REG
  bltz t0,SUBHC                 // IF (A_REG < $0) C Flag Set (No Borrow)
  ori s0,C_FLAG                 // F_REG: C Flag Set (No Borrow) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Borrow)
  SUBHC:
  andi t0,$FF
  andi s0,$FF
  sll t0,8
  or s0,t0
  beqz t0,SUBHZ                 // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  SUBHZ:
  ori s0,N_FLAG                 // F_REG: N Flag Set
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $95 SUB   L                Subtract L From A
  srl t0,s0,8                   // IF ((A_REG & $F) - (L_REG & $F) < $0) H Flag Set (No Borrow From Bit 4)
  andi t1,s3,$FF
  andi t2,t0,$F
  andi t3,t1,$F
  sub t2,t3
  bltz t2,SUBLH
  ori s0,H_FLAG                 // F_REG: H Flag Set (No Borrow From Bit 4) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (Borrow From Bit 4)
  SUBLH:
  sub t0,t1                     // A_REG -= L_REG
  bltz t0,SUBLC                 // IF (A_REG < $0) C Flag Set (No Borrow)
  ori s0,C_FLAG                 // F_REG: C Flag Set (No Borrow) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Borrow)
  SUBLC:
  andi t0,$FF
  andi s0,$FF
  sll t0,8
  or s0,t0
  beqz t0,SUBLZ                 // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  SUBLZ:
  ori s0,N_FLAG                 // F_REG: N Flag Set
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $96 SUB   (HL)             Subtract 8-Bit Value From Address In HL From A
  srl t0,s0,8                   // IF ((A_REG & $F) - (MEM_MAP[HL_REG] & $F) < $0) H Flag Set (No Borrow From Bit 4)
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  lbu t1,0(a2)
  andi t2,t0,$F
  andi t3,t1,$F
  sub t2,t3
  bltz t2,SUBHLH
  ori s0,H_FLAG                 // F_REG: H Flag Set (No Borrow From Bit 4) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (Borrow From Bit 4)
  SUBHLH:
  sub t0,t1                     // A_REG -= MEM_MAP[HL_REG]
  bltz t0,SUBHLC                // IF (A_REG < $0) C Flag Set (No Borrow)
  ori s0,C_FLAG                 // F_REG: C Flag Set (No Borrow) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Borrow)
  SUBHLC:
  andi t0,$FF
  andi s0,$FF
  sll t0,8
  or s0,t0
  beqz t0,SUBHLZ                // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  SUBHLZ:
  ori s0,N_FLAG                 // F_REG: N Flag Set
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $97 SUB   A                Subtract A From A
  andi s0,$FF                   // A_REG = 0
  andi s0,~(H_FLAG+C_FLAG)      // F_REG: H Flag Reset, C Flag Reset
  ori s0,N_FLAG+Z_FLAG          // F_REG: N Flag Set, Z Flag Set
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $98 SBC   A, B             Subtract B + Carry Flag From A
  srl t0,s0,8                   // IF ((A_REG & $F) - (B_REG & $F) - C_FLAG < $0) H Flag Set (No Borrow From Bit 4)
  srl t1,s1,8
  andi t2,t0,$F
  andi t3,t1,$F
  sub t2,t3
  andi t3,s0,C_FLAG
  sll t3,4
  sub t2,t3
  bltz t2,SUBCABH
  ori s0,H_FLAG                 // F_REG: H Flag Set (No Borrow From Bit 4) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (Borrow From Bit 4)
  SUBCABH:
  sub t0,t1                     // A_REG -= B_REG - C_FLAG
  sub t0,t3
  bltz t0,SUBCABC               // IF (A_REG < $0) C Flag Set (No Borrow)
  ori s0,C_FLAG                 // F_REG: C Flag Set (No Borrow) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Borrow)
  SUBCABC:
  andi t0,$FF
  andi s0,$FF
  sll t0,8
  or s0,t0
  beqz t0,SUBCABZ               // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  SUBCABZ:
  ori s0,N_FLAG                 // F_REG: N Flag Set
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $99 SBC   A, C             Subtract C + Carry Flag From A
  srl t0,s0,8                   // IF ((A_REG & $F) - (C_REG & $F) - C_FLAG < $0) H Flag Set (No Borrow From Bit 4)
  andi t1,s1,$FF
  andi t2,t0,$F
  andi t3,t1,$F
  sub t2,t3
  andi t3,s0,C_FLAG
  sll t3,4
  sub t2,t3
  bltz t2,SUBCACH
  ori s0,H_FLAG                 // F_REG: H Flag Set (No Borrow From Bit 4) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (Borrow From Bit 4)
  SUBCACH:
  sub t0,t1                     // A_REG -= C_REG - C_FLAG
  sub t0,t3
  bltz t0,SUBCACC               // IF (A_REG < $0) C Flag Set (No Borrow)
  ori s0,C_FLAG                 // F_REG: C Flag Set (No Borrow) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Borrow)
  SUBCACC:
  andi t0,$FF
  andi s0,$FF
  sll t0,8
  or s0,t0
  beqz t0,SUBCACZ               // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  SUBCACZ:
  ori s0,N_FLAG                 // F_REG: N Flag Set
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $9A SBC   A, D             Subtract D + Carry Flag From A
  srl t0,s0,8                   // IF ((A_REG & $F) - (D_REG & $F) - C_FLAG < $0) H Flag Set (No Borrow From Bit 4)
  srl t1,s2,8
  andi t2,t0,$F
  andi t3,t1,$F
  sub t2,t3
  andi t3,s0,C_FLAG
  sll t3,4
  sub t2,t3
  bltz t2,SUBCADH
  ori s0,H_FLAG                 // F_REG: H Flag Set (No Borrow From Bit 4) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (Borrow From Bit 4)
  SUBCADH:
  sub t0,t1                     // A_REG -= D_REG - C_FLAG
  sub t0,t3
  bltz t0,SUBCADC               // IF (A_REG < $0) C Flag Set (No Borrow)
  ori s0,C_FLAG                 // F_REG: C Flag Set (No Borrow) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Borrow)
  SUBCADC:
  andi t0,$FF
  andi s0,$FF
  sll t0,8
  or s0,t0
  beqz t0,SUBCADZ               // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  SUBCADZ:
  ori s0,N_FLAG                 // F_REG: N Flag Set
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $9B SBC   A, E             Subtract E + Carry Flag From A
  srl t0,s0,8                   // IF ((A_REG & $F) - (E_REG & $F) - C_FLAG < $0) H Flag Set (No Borrow From Bit 4)
  andi t1,s2,$FF
  andi t2,t0,$F
  andi t3,t1,$F
  sub t2,t3
  andi t3,s0,C_FLAG
  sll t3,4
  sub t2,t3
  bltz t2,SUBCAEH
  ori s0,H_FLAG                 // F_REG: H Flag Set (No Borrow From Bit 4) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (Borrow From Bit 4)
  SUBCAEH:
  sub t0,t1                     // A_REG -= E_REG - C_FLAG
  sub t0,t3
  bltz t0,SUBCAEC               // IF (A_REG < $0) C Flag Set (No Borrow)
  ori s0,C_FLAG                 // F_REG: C Flag Set (No Borrow) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Borrow)
  SUBCAEC:
  andi t0,$FF
  andi s0,$FF
  sll t0,8
  or s0,t0
  beqz t0,SUBCAEZ               // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  SUBCAEZ:
  ori s0,N_FLAG                 // F_REG: N Flag Set
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $9C SBC   A, H             Subtract H + Carry Flag From A
  srl t0,s0,8                   // IF ((A_REG & $F) - (H_REG & $F) - C_FLAG < $0) H Flag Set (No Borrow From Bit 4)
  srl t1,s3,8
  andi t2,t0,$F
  andi t3,t1,$F
  sub t2,t3
  andi t3,s0,C_FLAG
  sll t3,4
  sub t2,t3
  bltz t2,SUBCAHH
  ori s0,H_FLAG                 // F_REG: H Flag Set (No Borrow From Bit 4) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (Borrow From Bit 4)
  SUBCAHH:
  sub t0,t1                     // A_REG -= H_REG - C_FLAG
  sub t0,t3
  bltz t0,SUBCAHC               // IF (A_REG < $0) C Flag Set (No Borrow)
  ori s0,C_FLAG                 // F_REG: C Flag Set (No Borrow) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Borrow)
  SUBCAHC:
  andi t0,$FF
  andi s0,$FF
  sll t0,8
  or s0,t0
  beqz t0,SUBCAHZ               // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  SUBCAHZ:
  ori s0,N_FLAG                 // F_REG: N Flag Set
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $9D SBC   A, L             Subtract L + Carry Flag From A
  srl t0,s0,8                   // IF ((A_REG & $F) - (L_REG & $F) - C_FLAG < $0) H Flag Set (No Borrow From Bit 4)
  andi t1,s3,$FF
  andi t2,t0,$F
  andi t3,t1,$F
  sub t2,t3
  andi t3,s0,C_FLAG
  sll t3,4
  sub t2,t3
  bltz t2,SUBCALH
  ori s0,H_FLAG                 // F_REG: H Flag Set (No Borrow From Bit 4) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (Borrow From Bit 4)
  SUBCALH:
  sub t0,t1                     // A_REG -= L_REG - C_FLAG
  sub t0,t3
  bltz t0,SUBCALC               // IF (A_REG < $0) C Flag Set (No Borrow)
  ori s0,C_FLAG                 // F_REG: C Flag Set (No Borrow) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Borrow)
  SUBCALC:
  andi t0,$FF
  andi s0,$FF
  sll t0,8
  or s0,t0
  beqz t0,SUBCALZ               // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  SUBCALZ:
  ori s0,N_FLAG                 // F_REG: N Flag Set
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $9E SBC   A, (HL)          Subtract 8-Bit Value From Address In HL + Carry Flag From A
  srl t0,s0,8                   // IF ((A_REG & $F) - (MEM_MAP[HL_REG] & $F) - C_FLAG < $0) H Flag Set (No Borrow From Bit 4)
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  lbu t1,0(a2)
  andi t2,t0,$F
  andi t3,t1,$F
  sub t2,t3
  andi t3,s0,C_FLAG
  sll t3,4
  sub t2,t3
  bltz t2,SUBCAHLH
  ori s0,H_FLAG                 // F_REG: H Flag Set (No Borrow From Bit 4) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (Borrow From Bit 4)
  SUBCAHLH:
  sub t0,t1                     // A_REG -= MEM_MAP[HL_REG] - C_FLAG
  sub t0,t3
  bltz t0,SUBCAHLC              // IF (A_REG < $0) C Flag Set (No Borrow)
  ori s0,C_FLAG                 // F_REG: C Flag Set (No Borrow) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Borrow)
  SUBCAHLC:
  andi t0,$FF
  andi s0,$FF
  sll t0,8
  or s0,t0
  beqz t0,SUBCAHLZ              // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  SUBCAHLZ:
  ori s0,N_FLAG                 // F_REG: N Flag Set
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $9F SBC   A, A             Subtract A + Carry Flag From A
  andi t0,s0,C_FLAG             // A_REG = -C_FLAG
  beqz t0,SBCAA
  lli t0,0
  lli t0,$FF
  SBCAA:
  andi s0,$FF
  sll t0,8
  or s0,t0
  bltz t0,SUBCAAH               // IF (-C_FLAG > $F) H Flag Set (No Borrow From Bit 4)
  ori s0,H_FLAG                 // F_REG: H Flag Set (No Borrow From Bit 4)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (Borrow From Bit 4)
  SUBCAAH:
  beqz t0,SUBCAAZ               // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  SUBCAAZ:
  ori s0,N_FLAG                 // F_REG: N Flag Set
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $A0 AND   B                Logical AND B With A
  andi t0,s1,$FF00              // A_REG &= B_REG
  ori t0,$FF
  and s0,t0
  ori s0,H_FLAG                 // H Flag Set
  andi t0,s0,$FF00
  beqz t0,ANDBZ                 // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  ANDBZ:
  andi s0,~(C_FLAG+N_FLAG)      // F_REG: C Flag Reset, N Flag Reset
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $A1 AND   C                Logical AND C With A
  sll t0,s1,8                   // A_REG &= C_REG
  andi t0,$FF00
  ori t0,$FF
  and s0,t0
  ori s0,H_FLAG                 // H Flag Set
  andi t0,s0,$FF00
  beqz t0,ANDCZ                 // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  ANDCZ:
  andi s0,~(C_FLAG+N_FLAG)      // F_REG: C Flag Reset, N Flag Reset
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $A2 AND   D                Logical AND D With A
  andi t0,s2,$FF00              // A_REG &= D_REG
  ori t0,$FF
  and s0,t0
  ori s0,H_FLAG                 // H Flag Set
  andi t0,s0,$FF00
  beqz t0,ANDDZ                 // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  ANDDZ:
  andi s0,~(C_FLAG+N_FLAG)      // F_REG: C Flag Reset, N Flag Reset
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $A3 AND   E                Logical AND E With A
  sll t0,s2,8                   // A_REG &= E_REG
  andi t0,$FF00
  ori t0,$FF
  and s0,t0
  ori s0,H_FLAG                 // H Flag Set
  andi t0,s0,$FF00
  beqz t0,ANDEZ                 // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  ANDEZ:
  andi s0,~(C_FLAG+N_FLAG)      // F_REG: C Flag Reset, N Flag Reset
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $A4 AND   H                Logical AND H With A
  andi t0,s3,$FF00              // A_REG &= H_REG
  ori t0,$FF
  and s0,t0
  ori s0,H_FLAG                 // H Flag Set
  andi t0,s0,$FF00
  beqz t0,ANDHZ                 // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  ANDHZ:
  andi s0,~(C_FLAG+N_FLAG)      // F_REG: C Flag Reset, N Flag Reset
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $A5 AND   L                Logical AND L With A
  sll t0,s3,8                   // A_REG &= L_REG
  andi t0,$FF00
  ori t0,$FF
  and s0,t0
  ori s0,H_FLAG                 // H Flag Set
  andi t0,s0,$FF00
  beqz t0,ANDLZ                 // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  ANDLZ:
  andi s0,~(C_FLAG+N_FLAG)      // F_REG: C Flag Reset, N Flag Reset
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $A6 AND   (HL)             Logical AND 8-Bit Value Of Address In HL With A
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  lbu t0,0(a2)                  // A_REG &= MEM_MAP[HL_REG]
  sll t0,8
  ori t0,$FF
  and s0,t0
  ori s0,H_FLAG                 // H Flag Set
  andi t0,s0,$FF00
  beqz t0,ANDHLZ                // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  ANDHLZ:
  andi s0,~(C_FLAG+N_FLAG)      // F_REG: C Flag Reset, N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $A7 AND   A                Logical AND A With A
  ori s0,H_FLAG                 // H Flag Set
  andi t0,s0,$FF00
  beqz t0,ANDAZ                 // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  ANDAZ:
  andi s0,~(C_FLAG+N_FLAG)      // F_REG: C Flag Reset, N Flag Reset
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $A8 XOR   B                Logical eXclusive OR B With A
  andi t0,s1,$FF00              // A_REG ^= B_REG
  xor s0,t0
  andi t0,s0,$FF00
  beqz t0,XORBZ                 // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  XORBZ:
  andi s0,~(C_FLAG+H_FLAG+N_FLAG) // F_REG: C Flag Reset, H Flag Reset, N Flag Reset
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $A9 XOR   C                Logical eXclusive OR C With A
  sll t0,s1,8                   // A_REG ^= C_REG
  andi t0,$FF00
  xor s0,t0
  andi t0,s0,$FF00
  beqz t0,XORCZ                 // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  XORCZ:
  andi s0,~(C_FLAG+H_FLAG+N_FLAG) // F_REG: C Flag Reset, H Flag Reset, N Flag Reset
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $AA XOR   D                Logical eXclusive OR D With A
  andi t0,s2,$FF00              // A_REG ^= D_REG
  xor s0,t0
  andi t0,s0,$FF00
  beqz t0,XORDZ                 // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  XORDZ:
  andi s0,~(C_FLAG+H_FLAG+N_FLAG) // F_REG: C Flag Reset, H Flag Reset, N Flag Reset
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $AB XOR   E                Logical eXclusive OR E With A
  sll t0,s2,8                   // A_REG ^= E_REG
  andi t0,$FF00
  xor s0,t0
  andi t0,s0,$FF00
  beqz t0,XOREZ                 // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  XOREZ:
  andi s0,~(C_FLAG+H_FLAG+N_FLAG) // F_REG: C Flag Reset, H Flag Reset, N Flag Reset
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $AC XOR   H                Logical eXclusive OR H With A
  andi t0,s3,$FF00              // A_REG ^= H_REG
  xor s0,t0
  andi t0,s0,$FF00
  beqz t0,XORHZ                 // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  XORHZ:
  andi s0,~(C_FLAG+H_FLAG+N_FLAG) // F_REG: C Flag Reset, H Flag Reset, N Flag Reset
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $AD XOR   L                Logical eXclusive OR L With A
  sll t0,s3,8                   // A_REG ^= L_REG
  andi t0,$FF00
  xor s0,t0
  andi t0,s0,$FF00
  beqz t0,XORLZ                 // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  XORLZ:
  andi s0,~(C_FLAG+H_FLAG+N_FLAG) // F_REG: C Flag Reset, H Flag Reset, N Flag Reset
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $AE XOR  (HL)              Logical eXclusive OR 8-Bit Value From Address In HL With A
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  lbu t0,0(a2)                  // A_REG ^= MEM_MAP[HL_REG]
  sll t0,8
  xor s0,t0
  andi t0,s0,$FF00
  beqz t0,XORHLZ                // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  XORHLZ:
  andi s0,~(C_FLAG+H_FLAG+N_FLAG) // F_REG: C Flag Reset, H Flag Reset, N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $AF XOR   A                Logical eXclusive OR A With A
  andi s0,$FF                   // A_REG ^= A_REG
  ori s0,Z_FLAG                 // F_REG: Z Flag Set
  andi s0,~(C_FLAG+H_FLAG+N_FLAG) // F_REG: C Flag Reset, H Flag Reset, N Flag Reset
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $B0 OR    B                Logical OR B With A
  andi t0,s1,$FF00              // A_REG |= B_REG
  or s0,t0
  andi t0,s0,$FF00
  beqz t0,ORBZ                  // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  ORBZ:
  andi s0,~(C_FLAG+H_FLAG+N_FLAG) // F_REG: C Flag Reset, H Flag Reset, N Flag Reset
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $B1 OR    C                Logical OR C With A
  sll t0,s1,8                   // A_REG |= C_REG
  andi t0,$FF00
  or s0,t0
  andi t0,s0,$FF00
  beqz t0,ORCZ                  // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  ORCZ:
  andi s0,~(C_FLAG+H_FLAG+N_FLAG) // F_REG: C Flag Reset, H Flag Reset, N Flag Reset
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $B2 OR    D                Logical OR D With A
  andi t0,s2,$FF00              // A_REG |= D_REG
  or s0,t0
  andi t0,s0,$FF00
  beqz t0,ORDZ                  // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  ORDZ:
  andi s0,~(C_FLAG+H_FLAG+N_FLAG) // F_REG: C Flag Reset, H Flag Reset, N Flag Reset
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $B3 OR    E                Logical OR E With A
  sll t0,s2,8                   // A_REG |= E_REG
  andi t0,$FF00
  or s0,t0
  andi t0,s0,$FF00
  beqz t0,OREZ                  // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  OREZ:
  andi s0,~(C_FLAG+H_FLAG+N_FLAG) // F_REG: C Flag Reset, H Flag Reset, N Flag Reset
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $B4 OR    H                Logical OR H With A
  andi t0,s3,$FF00              // A_REG |= H_REG
  or s0,t0
  andi t0,s0,$FF00
  beqz t0,ORHZ                  // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  ORHZ:
  andi s0,~(C_FLAG+H_FLAG+N_FLAG) // F_REG: C Flag Reset, H Flag Reset, N Flag Reset
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $B5 OR    L                Logical OR L With A
  sll t0,s3,8                   // A_REG |= L_REG
  andi t0,$FF00
  or s0,t0
  andi t0,s0,$FF00
  beqz t0,ORLZ                  // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  ORLZ:
  andi s0,~(C_FLAG+H_FLAG+N_FLAG) // F_REG: C Flag Reset, H Flag Reset, N Flag Reset
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $B6 OR    (HL)             Logical OR 8-Bit Value From Address In HL With A
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  lbu t0,0(a2)                  // A_REG |= MEM_MAP[HL_REG]
  sll t0,8
  or s0,t0
  andi t0,s0,$FF00
  beqz t0,ORHLZ                 // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  ORHLZ:
  andi s0,~(C_FLAG+H_FLAG+N_FLAG) // F_REG: C Flag Reset, H Flag Reset, N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $B7 OR    A                Logical OR A With A
  andi t0,s0,$FF00
  beqz t0,ORAZ                  // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  ORAZ:
  andi s0,~(C_FLAG+H_FLAG+N_FLAG) // F_REG: C Flag Reset, H Flag Reset, N Flag Reset
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $B8 CP    B                Compare A With B
  srl t0,s0,8                   // IF ((A_REG & $F) - (B_REG & $F) < $0) H Flag Set (No Borrow From Bit 4)
  srl t1,s1,8
  andi t2,t0,$F
  andi t3,t1,$F
  sub t2,t3
  bltz t2,CPBH
  ori s0,H_FLAG                 // F_REG: H Flag Set (No Borrow From Bit 4) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (Borrow From Bit 4)
  CPBH:
  blt t0,t1,CPBC                // IF (A_REG < B_REG) C Flag Set (No Borrow)
  ori s0,C_FLAG                 // F_REG: C Flag Set (No Borrow) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Borrow)
  CPBC:
  beq t0,t1,CPBZ                // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  CPBZ:
  ori s0,N_FLAG                 // F_REG: N Flag Set
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $B9 CP    C                Compare A With C
  srl t0,s0,8                   // IF ((A_REG & $F) - (C_REG & $F) < $0) H Flag Set (No Borrow From Bit 4)
  andi t1,s1,$FF
  andi t2,t0,$F
  andi t3,t1,$F
  sub t2,t3
  bltz t2,CPCH
  ori s0,H_FLAG                 // F_REG: H Flag Set (No Borrow From Bit 4) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (Borrow From Bit 4)
  CPCH:
  blt t0,t1,CPCC                // IF (A_REG < B_REG) C Flag Set (No Borrow)
  ori s0,C_FLAG                 // F_REG: C Flag Set (No Borrow) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Borrow)
  CPCC:
  beq t0,t1,CPCZ                // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  CPCZ:
  ori s0,N_FLAG                 // F_REG: N Flag Set
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $BA CP    D                Compare A With D
  srl t0,s0,8                   // IF ((A_REG & $F) - (D_REG & $F) < $0) H Flag Set (No Borrow From Bit 4)
  srl t1,s2,8
  andi t2,t0,$F
  andi t3,t1,$F
  sub t2,t3
  bltz t2,CPDH
  ori s0,H_FLAG                 // F_REG: H Flag Set (No Borrow From Bit 4) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (Borrow From Bit 4)
  CPDH:
  blt t0,t1,CPDC                // IF (A_REG < B_REG) C Flag Set (No Borrow)
  ori s0,C_FLAG                 // F_REG: C Flag Set (No Borrow) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Borrow)
  CPDC:
  beq t0,t1,CPDZ                // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  CPDZ:
  ori s0,N_FLAG                 // F_REG: N Flag Set
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $BB CP    E                Compare A With E
  srl t0,s0,8                   // IF ((A_REG & $F) - (E_REG & $F) < $0) H Flag Set (No Borrow From Bit 4)
  andi t1,s2,$FF
  andi t2,t0,$F
  andi t3,t1,$F
  sub t2,t3
  bltz t2,CPEH
  ori s0,H_FLAG                 // F_REG: H Flag Set (No Borrow From Bit 4) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (Borrow From Bit 4)
  CPEH:
  blt t0,t1,CPEC                // IF (A_REG < B_REG) C Flag Set (No Borrow)
  ori s0,C_FLAG                 // F_REG: C Flag Set (No Borrow) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Borrow)
  CPEC:
  beq t0,t1,CPEZ                // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  CPEZ:
  ori s0,N_FLAG                 // F_REG: N Flag Set
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $BC CP    H                Compare A With H
  srl t0,s0,8                   // IF ((A_REG & $F) - (H_REG & $F) < $0) H Flag Set (No Borrow From Bit 4)
  srl t1,s3,8
  andi t2,t0,$F
  andi t3,t1,$F
  sub t2,t3
  bltz t2,CPHH
  ori s0,H_FLAG                 // F_REG: H Flag Set (No Borrow From Bit 4) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (Borrow From Bit 4)
  CPHH:
  blt t0,t1,CPHC                // IF (A_REG < B_REG) C Flag Set (No Borrow)
  ori s0,C_FLAG                 // F_REG: C Flag Set (No Borrow) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Borrow)
  CPHC:
  beq t0,t1,CPHZ                // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  CPHZ:
  ori s0,N_FLAG                 // F_REG: N Flag Set
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $BD CP    L                Compare A With L
  srl t0,s0,8                   // IF ((A_REG & $F) - (L_REG & $F) < $0) H Flag Set (No Borrow From Bit 4)
  andi t1,s3,$FF
  andi t2,t0,$F
  andi t3,t1,$F
  sub t2,t3
  bltz t2,CPLH
  ori s0,H_FLAG                 // F_REG: H Flag Set (No Borrow From Bit 4) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (Borrow From Bit 4)
  CPLH:
  blt t0,t1,CPLC                // IF (A_REG < B_REG) C Flag Set (No Borrow)
  ori s0,C_FLAG                 // F_REG: C Flag Set (No Borrow) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Borrow)
  CPLC:
  beq t0,t1,CPLZ                // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  CPLZ:
  ori s0,N_FLAG                 // F_REG: N Flag Set
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $BE CP    (HL)             Compare A With 8-Bit Value From Address In HL
  srl t0,s0,8                   // IF ((A_REG & $F) - (MEM_MAP[HL_REG] & $F) < $0) H Flag Set (No Borrow From Bit 4)
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  lbu t1,0(a2)
  andi t2,t0,$F
  andi t3,t1,$F
  sub t2,t3
  bltz t2,CPHLH
  ori s0,H_FLAG                 // F_REG: H Flag Set (No Borrow From Bit 4) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (Borrow From Bit 4)
  CPHLH:
  blt t0,t1,CPHLC               // IF (A_REG < B_REG) C Flag Set (No Borrow)
  ori s0,C_FLAG                 // F_REG: C Flag Set (No Borrow) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Borrow)
  CPHLC:
  beq t0,t1,CPHLZ               // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  CPHLZ:
  ori s0,N_FLAG                 // F_REG: N Flag Set
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $BF CP    A                Compare A With A
  andi s0,~(H_FLAG+C_FLAG)      // F_REG: H Flag Reset, C Flag Reset
  ori s0,N_FLAG+Z_FLAG          // F_REG: N Flag Set, Z Flag Set
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $C0 RET   NZ               IF Z Flag Is Reset Pop 2 Bytes From Stack & Jump To That Address
  andi t0,s0,Z_FLAG             // IF (! Z_FLAG) {
  bnez t0,RETNZ
  nop                           // Delay Slot
  addu a2,a0,sp                 // A2 = MEM_MAP + SP_REG
  lbu s4,0(a2)                  //   PC_REG = STACK
  lbu t0,1(a2)
  sll t0,8
  or s4,t0
  addiu sp,2                    //   SP_REG += 2 
  addiu v0,3                    //   QCycles += 3 }
  RETNZ:
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $C1 POP   BC               Pop 2 Bytes Off Stack To Register Pair BC, Increment Stack Pointer (SP) Twice
  addu a2,a0,sp                 // A2 = MEM_MAP + SP_REG
  lbu s1,0(a2)                  // BC_REG = STACK
  lbu t0,1(a2)
  sll t0,8
  or s1,t0
  addiu sp,2                    // SP_REG += 2
  jr ra
  addiu v0,3                    // QCycles += 3 (Delay Slot)

align(256)
  // $C2 JP    NZ, imm          Jump To 16-Bit Immediate Address IF Z Flag Reset
  andi t0,s0,Z_FLAG             // IF (! Z_FLAG) {
  bnez t0,JPNZ
  addiu s4,2                    // ELSE PC_REG += 2 (Delay Slot)
  lbu s4,1(a2)                  //   PC_REG = Imm16Bit
  lbu t0,2(a2)
  sll t0,8
  or s4,t0
  addiu v0,1                    //   QCycles++ }
  JPNZ:
  jr ra
  addiu v0,3                    // QCycles += 3 (Delay Slot)

align(256)
  // $C3 JP    imm              Jump To 16-Bit Immediate Address
  lbu s4,1(a2)                  // PC_REG = Imm16Bit
  lbu t0,2(a2)
  sll t0,8
  or s4,t0
  jr ra
  addiu v0,4                    // QCycles += 4 (Delay Slot)

align(256)
  // $C4 CALL  NZ, imm          IF Z Flag Reset, Push Address Of Next Instruction To Stack & Jump To 16-Bit Immediate Address
  addiu s4,2                    // PC_REG += 2
  andi t0,s0,Z_FLAG             // IF (! Z_FLAG) {
  bnez t0,CALLNZ
  nop                           // Delay Slot
  subiu sp,2                    //   SP_REG -= 2
  addu a3,a0,sp                 //   A3 = MEM_MAP + SP_REG
  sb s4,0(a3)                   //   STACK = PC_REG + 2
  srl t0,sp,8
  sb t0,1(a3)
  lbu s4,1(a2)                  //   PC_REG = Imm16Bit
  lbu t0,2(a2)
  sll t0,8
  or s4,t0
  addiu v0,3                    //   QCycles += 3 }
  CALLNZ:
  jr ra
  addiu v0,3                    // QCycles += 3 (Delay Slot)

align(256)
  // $C5 PUSH  BC               Push Register Pair BC To Stack, Decrement Stack Pointer (SP) Twice
  subiu sp,2                    // SP_REG -= 2
  addu a2,a0,sp                 // A2 = MEM_MAP + SP_REG
  sb s1,0(a2)                   // STACK = BC_REG
  srl t0,s1,8
  sb t0,1(a2)
  jr ra
  addiu v0,4                    // QCycles += 4 (Delay Slot)

align(256)
  // $C6 ADD   A, imm           Add 8-Bit Immediate Value To A
  srl t0,s0,8                   // IF ((A_REG & $F) + (Imm8Bit & $F) & $10) H Flag Set (Carry From Bit 3)
  lbu t1,1(a2)
  andi t2,t0,$F
  andi t3,t1,$F
  addu t2,t3
  andi t2,$10
  bnez t2,ADDAIH
  ori s0,H_FLAG                 // F_REG: H Flag Set (Carry From Bit 3) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (No Carry From Bit 3)
  ADDAIH:
  addu t0,t1                    // A_REG += Imm8Bit
  andi t1,t0,$100
  bnez t1,ADDAIC                // IF (A_REG & $100) C Flag Set (Carry From Bit 7)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Carry From Bit 7) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (No Carry From Bit 7)
  ADDAIC:
  andi t0,$FF
  andi s0,$FF
  sll t0,8
  or s0,t0
  beqz t0,ADDAIZ                // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  ADDAIZ:
  andi s0,~N_FLAG               // F_REG: N Flag Reset
  addiu s4,1                    // PC_REG++
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $C7 RST   00H              Push Present Address To Stack, Jump To Address $0000
  subiu sp,2                    // SP_REG -= 2
  addu a2,a0,sp                 // A2 = MEM_MAP + SP_REG
  sb s4,0(a2)                   // STACK = PC_REG
  srl t0,s4,8
  sb t0,1(a2)
  lli s4,$0000                  // PC_REG = $0000
  jr ra
  addiu v0,4                    // QCycles += 4 (Delay Slot)

align(256)
  // $C8 RET   Z                IF Z Flag Set, Pop 2 Bytes From Stack & Jump To Address
  andi t0,s0,Z_FLAG             // IF (Z_FLAG) {
  beqz t0,RETZ
  nop                           // Delay Slot
  addu a2,a0,sp                 //   A2 = MEM_MAP + SP_REG
  lbu s4,0(a2)                  //   PC_REG = STACK
  lbu t0,1(a2)
  sll t0,8
  or s4,t0
  addiu sp,2                    //   SP_REG += 2 
  addiu v0,3                    //   QCycles += 3 }
  RETZ:
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $C9 RET                    Pop 2 Bytes From Stack & Jump To Address
  addu a2,a0,sp                 // A2 = MEM_MAP + SP_REG
  lbu s4,0(a2)                  // PC_REG = STACK
  lbu t0,1(a2)
  sll t0,8
  or s4,t0
  addiu sp,2                    // SP_REG += 2 
  jr ra
  addiu v0,4                    // QCycles += 4 (Delay Slot)

align(256)
  // $CA JP    Z, imm           Jump To 16-Bit Immediate Address IF Z Flag Set
  andi t0,s0,Z_FLAG             // IF (Z_FLAG) {
  beqz t0,JPZ
  addiu s4,2                    // ELSE PC_REG += 2 (Delay Slot)
  lbu s4,1(a2)                  //   PC_REG = Imm16Bit
  lbu t0,2(a2)
  sll t0,8
  or s4,t0
  addiu v0,1                    //   QCycles++ }
  JPZ:
  jr ra
  addiu v0,3                    // QCycles += 3 (Delay Slot)

align(256)
  // $CB                        Run Extra CPU Opcodes Jump Table
  la t0,CPU_CB_INST             // CPU CB Instruction Table
  lb t1,1(a2)                   // CPU CB Instruction
  sll t1,8
  addu t0,t1                    // CPU CB Instruction Table Opcode
  jr t0
  add s4,1                      // PC_REG++ (Delay Slot)

align(256)
  // $CC CALL  Z, imm           IF Z Flag Set, Push Address Of Next Instruction To Stack & Jump To 16-Bit Immediate Address
  addiu s4,2                    // PC_REG += 2
  andi t0,s0,Z_FLAG             // IF (Z_FLAG) {
  beqz t0,CALLZ
  nop                           // Delay Slot
  subiu sp,2                    //   SP_REG -= 2
  addu a3,a0,sp                 //   A3 = MEM_MAP + SP_REG
  sb s4,0(a3)                   //   STACK = PC_REG + 2
  srl t0,sp,8
  sb t0,1(a3)
  lbu s4,1(a2)                  //   PC_REG = Imm16Bit
  lbu t0,2(a2)
  sll t0,8
  or s4,t0
  addiu v0,3                    //   QCycles += 3 }
  CALLZ:
  jr ra
  addiu v0,3                    // QCycles += 3 (Delay Slot)

align(256)
  // $CD CALL  imm              Push Address Of Next Instruction To Stack & Jump To 16-Bit Immediate Address
  addiu s4,2                    // PC_REG += 2
  subiu sp,2                    // SP_REG -= 2
  addu a3,a0,sp                 // A3 = MEM_MAP + SP_REG
  sb s4,0(a3)                   // STACK = PC_REG + 2
  srl t0,sp,8
  sb t0,1(a3)
  lbu s4,1(a2)                  // PC_REG = Imm16Bit
  lbu t0,2(a2)
  sll t0,8
  or s4,t0
  jr ra
  addiu v0,6                    // QCycles += 6 (Delay Slot)

align(256)
  // $CE ADC   A, imm           Add 8-Bit Immediate Value + Carry Flag To A
  srl t0,s0,8                   // IF ((A_REG & $F) + (Imm8Bit & $F) + C_FLAG & $10) H Flag Set (Carry From Bit 3)
  lbu t1,1(a2)
  andi t2,t0,$F
  andi t3,t1,$F
  addu t2,t3
  andi t3,s0,C_FLAG
  srl t3,4
  addu t2,t3
  andi t2,$10
  bnez t2,ADDCAIH
  ori s0,H_FLAG                 // F_REG: H Flag Set (Carry From Bit 3) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (No Carry From Bit 3)
  ADDCAIH:
  addu t0,t1                    // A_REG += Imm8Bit + C_FLAG
  addu t0,t3
  andi t1,t0,$100
  bnez t1,ADDCAIC               // IF (A_REG & $100) C Flag Set (Carry From Bit 7)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Carry From Bit 7) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (No Carry From Bit 7)
  ADDCAIC:
  andi t0,$FF
  andi s0,$FF
  sll t0,8
  or s0,t0
  beqz t0,ADDCAIZ               // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  ADDCAIZ:
  andi s0,~N_FLAG               // F_REG: N Flag Reset
  addiu s4,1                    // PC_REG++
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $CF RST   08H              Push Present Address To Stack, Jump To Address $0008
  subiu sp,2                    // SP_REG -= 2
  addu a2,a0,sp                 // A2 = MEM_MAP + SP_REG
  sb s4,0(a2)                   // STACK = PC_REG
  srl t0,s4,8
  sb t0,1(a2)
  lli s4,$0008                  // PC_REG = $0008
  jr ra
  addiu v0,4                    // QCycles += 4 (Delay Slot)

align(256)
  // $D0 RET   NC               If C Flag Reset, Pop 2 Bytes From Stack & Jump To Address
  andi t0,s0,C_FLAG             // IF (! C_FLAG) {
  bnez t0,RETNC
  nop                           // Delay Slot
  addu a2,a0,sp                 // A2 = MEM_MAP + SP_REG
  lbu s4,0(a2)                  //   PC_REG = STACK
  lbu t0,1(a2)
  sll t0,8
  or s4,t0
  addiu sp,2                    //   SP_REG += 2 
  addiu v0,3                    //   QCycles += 3 }
  RETNC:
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $D1 POP   DE               Pop 2 Bytes Off Stack To Register Pair DE, Increment Stack Pointer (SP) Twice
  addu a2,a0,sp                 // A2 = MEM_MAP + SP_REG
  lbu s2,0(a2)                  // DE_REG = STACK
  lbu t0,1(a2)
  sll t0,8
  or s2,t0
  addiu sp,2                    // SP_REG += 2
  jr ra
  addiu v0,3                    // QCycles += 3 (Delay Slot)

align(256)
  // $D2 JP    NC, imm          Jump To 16-Bit Immediate Address IF C Flag Reset
  andi t0,s0,C_FLAG             // IF (! C_FLAG) {
  bnez t0,JPNC
  addiu s4,2                    // ELSE PC_REG += 2 (Delay Slot)
  lbu s4,1(a2)                  //   PC_REG = Imm16Bit
  lbu t0,2(a2)
  sll t0,8
  or s4,t0
  addiu v0,1                    //   QCycles++ }
  JPNC:
  jr ra
  addiu v0,3                    // QCycles += 3 (Delay Slot)

align(256)
  // $D3 UNUSED OPCODE          Execution Will Cause GB To Permanently Halt Operation Until Power Down / Power Up
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $D4 CALL  NC, imm          IF C Flag Reset, Push Address Of Next Instruction To Stack & Jump To 16-Bit Immediate Address
  addiu s4,2                    // PC_REG += 2
  andi t0,s0,C_FLAG             // IF (! C_FLAG) {
  bnez t0,CALLNC
  nop                           // Delay Slot
  subiu sp,2                    //   SP_REG -= 2
  addu a3,a0,sp                 //   A3 = MEM_MAP + SP_REG
  sb s4,0(a3)                   //   STACK = PC_REG + 2
  srl t0,sp,8
  sb t0,1(a3)
  lbu s4,1(a2)                  //   PC_REG = Imm16Bit
  lbu t0,2(a2)
  sll t0,8
  or s4,t0
  addiu v0,3                    //   QCycles += 3 }
  CALLNC:
  jr ra
  addiu v0,3                    // QCycles += 3 (Delay Slot)

align(256)
  // $D5 PUSH  DE               Push Register Pair DE To Stack, Decrement Stack Pointer (SP) Twice
  subiu sp,2                    // SP_REG -= 2
  addu a2,a0,sp                 // A2 = MEM_MAP + SP_REG
  sb s2,0(a2)                   // STACK = DE_REG
  srl t0,s2,8
  sb t0,1(a2)
  jr ra
  addiu v0,4                    // QCycles += 4 (Delay Slot)

align(256)
  // $D6 SUB   imm              Subtract 8-Bit Immediate Value From A
  srl t0,s0,8                   // IF ((A_REG & $F) - (Imm8Bit & $F) < $0) H Flag Set (No Borrow From Bit 4)
  lbu t1,1(a2)
  andi t2,t0,$F
  andi t3,t1,$F
  sub t2,t3
  bltz t2,SUBIH
  ori s0,H_FLAG                 // F_REG: H Flag Set (No Borrow From Bit 4) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (Borrow From Bit 4)
  SUBIH:
  sub t0,t1                     // A_REG -= Imm8Bit
  bltz t0,SUBIC                 // IF (A_REG < $0) C Flag Set (No Borrow)
  ori s0,C_FLAG                 // F_REG: C Flag Set (No Borrow) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Borrow)
  SUBIC:
  andi t0,$FF
  andi s0,$FF
  sll t0,8
  or s0,t0
  beqz t0,SUBIZ                 // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  SUBIZ:
  ori s0,N_FLAG                 // F_REG: N Flag Set
  addiu s4,1                    // PC_REG++
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $D7 RST   10H              Push Present Address To Stack, Jump To Address $0010
  subiu sp,2                    // SP_REG -= 2
  addu a2,a0,sp                 // A2 = MEM_MAP + SP_REG
  sb s4,0(a2)                   // STACK = PC_REG
  srl t0,s4,8
  sb t0,1(a2)
  lli s4,$0010                  // PC_REG = $0010
  jr ra
  addiu v0,4                    // QCycles += 4 (Delay Slot)

align(256)
  // $D8 RET   C                IF C Flag Set, Pop 2 Bytes From Stack & Jump To Address
  andi t0,s0,C_FLAG             // IF (C_FLAG) {
  beqz t0,RETC
  nop                           // Delay Slot
  addu a2,a0,sp                 //   A2 = MEM_MAP + SP_REG
  lbu s4,0(a2)                  //   PC_REG = STACK
  lbu t0,1(a2)
  sll t0,8
  or s4,t0
  addiu sp,2                    //   SP_REG += 2 
  addiu v0,3                    //   QCycles += 3 }
  RETC:
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $D9 RETI                   Pop 2 Bytes From Stack & Jump To Address, Enable Interrupts
  addu a2,a0,sp                 // A2 = MEM_MAP + SP_REG
  lbu s4,0(a2)                  // PC_REG = STACK
  lbu t0,1(a2)
  sll t0,8
  or s4,t0
  addiu sp,2                    // SP_REG += 2
  lli t9,1                      // IME_FLAG = 1
  jr ra
  addiu v0,4                    // QCycles += 4 (Delay Slot)

align(256)
  // $DA JP    C, imm           Jump To 16-Bit Immediate Address IF C Flag Set
  andi t0,s0,C_FLAG             // IF (C_FLAG) {
  beqz t0,JPC
  addiu s4,2                    // ELSE PC_REG += 2 (Delay Slot)
  lbu s4,1(a2)                  //   PC_REG = Imm16Bit
  lbu t0,2(a2)
  sll t0,8
  or s4,t0
  addiu v0,1                    //   QCycles++ }
  JPC:
  jr ra
  addiu v0,3                    // QCycles += 3 (Delay Slot)

align(256)
  // $DB UNUSED OPCODE          Execution Will Cause GB To Permanently Halt Operation Until Power Down / Power Up
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $DC CALL  C, imm           IF C Flag Set, Push Address Of Next Instruction To Stack & Jump To 16-Bit Immediate Address
  addiu s4,2                    // PC_REG += 2
  andi t0,s0,C_FLAG             // IF (C_FLAG) {
  beqz t0,CALLC
  nop                           // Delay Slot
  subiu sp,2                    //   SP_REG -= 2
  addu a3,a0,sp                 //   A3 = MEM_MAP + SP_REG
  sb s4,0(a3)                   //   STACK = PC_REG + 2
  srl t0,sp,8
  sb t0,1(a3)
  lbu s4,1(a2)                  //   PC_REG = Imm16Bit
  lbu t0,2(a2)
  sll t0,8
  or s4,t0
  addiu v0,3                    //   QCycles += 3 }
  CALLC:
  jr ra
  addiu v0,3                    // QCycles += 3 (Delay Slot)

align(256)
  // $DD UNUSED OPCODE          Execution Will Cause GB To Permanently Halt Operation Until Power Down / Power Up
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $DE SBC   A, imm           Subtract 8-Bit Immediate Value + Carry Flag From A
  srl t0,s0,8                   // IF ((A_REG & $F) - (Imm8Bit & $F) - C_FLAG < $0) H Flag Set (No Borrow From Bit 4)
  lbu t1,1(a2)
  andi t2,t0,$F
  andi t3,t1,$F
  sub t2,t3
  andi t3,s0,C_FLAG
  sll t3,4
  sub t2,t3
  bltz t2,SUBCAIH
  ori s0,H_FLAG                 // F_REG: H Flag Set (No Borrow From Bit 4) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (Borrow From Bit 4)
  SUBCAIH:
  sub t0,t1                     // A_REG -= Imm8Bit - C_FLAG
  sub t0,t3
  bltz t0,SUBCAIC               // IF (A_REG < $0) C Flag Set (No Borrow)
  ori s0,C_FLAG                 // F_REG: C Flag Set (No Borrow) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Borrow)
  SUBCAIC:
  andi t0,$FF
  andi s0,$FF
  sll t0,8
  or s0,t0
  beqz t0,SUBCAIZ               // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  SUBCAIZ:
  ori s0,N_FLAG                 // F_REG: N Flag Set
  addiu s4,1                    // PC_REG++
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $DF RST   18H              Push Present Address To Stack, Jump To Address $0018
  subiu sp,2                    // SP_REG -= 2
  addu a2,a0,sp                 // A2 = MEM_MAP + SP_REG
  sb s4,0(a2)                   // STACK = PC_REG
  srl t0,s4,8
  sb t0,1(a2)
  lli s4,$0018                  // PC_REG = $0018
  jr ra
  addiu v0,4                    // QCycles += 4 (Delay Slot)

align(256)
  // $E0 LD    ($FF00 + imm), A  Load A To Memory Address $FF00 + 8-Bit Immediate Value
  lbu t0,1(a2)                  // MEM_MAP[$FF00 + Imm8Bit] = A_REG
  ori t0,$FF00
  srl t1,s0,8
  addu a2,a0,t0                 // A2 = MEM_MAP + $FF00 + Imm8Bit
  sb t1,0(a2)
  addiu s4,1                    // PC_REG++
  jr ra
  addiu v0,3                    // QCycles += 3 (Delay Slot)

align(256)
  // $E1 POP   HL               Pop 2 Bytes Off Stack To Register Pair HL, Increment Stack Pointer (SP) Twice
  addu a2,a0,sp                 // A2 = MEM_MAP + SP_REG
  lbu s3,0(a2)                  // HL_REG = STACK
  lbu t0,1(a2)
  sll t0,8
  or s3,t0
  addiu sp,2                    // SP_REG += 2
  jr ra
  addiu v0,3                    // QCycles += 3 (Delay Slot)

align(256)
  // $E2 LD    (C), A           Load Value A To Address $FF00 + Register C
  andi t0,s1,$FF                // MEM_MAP[$FF00 + C_REG] = A_REG
  ori t0,$FF00
  srl t1,s0,8
  addu a2,a0,t0                 // A2 = MEM_MAP + $FF00 + C_REG
  sb t1,0(a2)
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $E3 UNUSED OPCODE          Execution Will Cause GB To Permanently Halt Operation Until Power Down / Power Up
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $E4 UNUSED OPCODE          Execution Will Cause GB To Permanently Halt Operation Until Power Down / Power Up
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $E5 PUSH  HL               Push Register Pair HL To Stack, Decrement Stack Pointer (SP) Twice
  subiu sp,2                    // SP_REG -= 2
  addu a2,a0,sp                 // A2 = MEM_MAP + SP_REG
  sb s3,0(a2)                   // STACK = HL_REG
  srl t0,s3,8
  sb t0,1(a2)
  jr ra
  addiu v0,4                    // QCycles += 4 (Delay Slot)

align(256)
  // $E6 AND   imm              Logical AND 8-Bit Immediate Value With A
  lbu t0,1(a2)                  // A_REG &= Imm8Bit
  sll t0,8
  ori t0,$FF
  and s0,t0
  ori s0,H_FLAG                 // H Flag Set
  andi t0,s0,$FF00
  beqz t0,ANDIZ                 // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  ANDIZ:
  andi s0,~(C_FLAG+N_FLAG)      // F_REG: C Flag Reset, N Flag Reset
  addiu s4,1                    // PC_REG++
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $E7 RST   20H              Push Present Address To Stack, Jump To Address $0020
  subiu sp,2                    // SP_REG -= 2
  addu a2,a0,sp                 // A2 = MEM_MAP + SP_REG
  sb s4,0(a2)                   // STACK = PC_REG
  srl t0,s4,8
  sb t0,1(a2)
  lli s4,$0020                  // PC_REG = $0020
  jr ra
  addiu v0,4                    // QCycles += 4 (Delay Slot)

align(256)
  // $E8 ADD   SP, imm          Add 8-Bit Signed Immediate Value To Stack Pointer (SP)
  andi t0,sp,$F                 // IF ((SP_REG & $F) + (Imm8bit & $F) & $10) H Flag Set (Carry From Bit 3)
  lbu t1,1(a2)
  andi t2,t1,$F
  addu t0,t2
  bnez t2,ADDSPH
  ori s0,H_FLAG                 // F_REG: H Flag Set (Carry From Bit 3) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (No Carry From Bit 3)
  ADDSPH:
  lb t0,1(a2)                   // SP_REG += Imm8Bit
  add sp,t0
  andi sp,$FFFF
  andi t0,sp,$FF
  blt t0,t1,ADDSPC              // IF ((SP_REG & $FF) < Imm8Bit) C Flag Set (Carry From Bit 7)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Carry From Bit 7)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (No Carry From Bit 7)
  ADDSPC:
  andi s0,~(N_FLAG+Z_FLAG)      // F_REG: N Flag Reset, Z Flag Reset
  addiu s4,1                    // PC_REG++
  jr ra
  addiu v0,4                    // QCycles += 4 (Delay Slot)

align(256)
  // $E9 JP    (HL)             Jump To 16-Bit Immediate Address Contained In HL
  addu s4,r0,s3                 // PC_REG = HL_REG
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $EA LD    (imm), A         Load Value A To 16-Bit Immediate Address
  lbu t0,1(a2)                  // MEM_MAP[Imm16Bit] = A_REG
  lbu t1,2(a2)
  sll t1,8
  add t0,t1
  srl t1,s0,8
  addu a2,a0,t0                 // A2 = MEM_MAP + Imm16Bit
  sb t1,0(a2)
  addiu s4,2                    // PC_REG += 2
  jr ra
  addiu v0,4                    // QCycles += 4 (Delay Slot)

align(256)
  // $EB UNUSED OPCODE          Execution Will Cause GB To Permanently Halt Operation Until Power Down / Power Up
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $EC UNUSED OPCODE          Execution Will Cause GB To Permanently Halt Operation Until Power Down / Power Up
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $ED UNUSED OPCODE          Execution Will Cause GB To Permanently Halt Operation Until Power Down / Power Up
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $EE XOR   imm              Logical eXclusive OR 8-Bit Immediate Value With A
  lbu t0,1(a2)                  // A_REG ^= Imm8Bit
  sll t0,8
  xor s0,t0
  andi t0,s0,$FF00
  beqz t0,XORIZ                 // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  XORIZ:
  andi s0,~(C_FLAG+H_FLAG+N_FLAG) // F_REG: C Flag Reset, H Flag Reset, N Flag Reset
  addiu s4,1                    // PC_REG++
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $EF RST   28H              Push Present Address To Stack, Jump To Address $0028
  subiu sp,2                    // SP_REG -= 2
  addu a2,a0,sp                 // A2 = MEM_MAP + SP_REG
  sb s4,0(a2)                   // STACK = PC_REG
  srl t0,s4,8
  sb t0,1(a2)
  lli s4,$0028                  // PC_REG = $0028
  jr ra
  addiu v0,4                    // QCycles += 4 (Delay Slot)

align(256)
  // $F0 LD    A, ($FF00 + imm) Load Memory Address $FF00 + 8-Bit Immediate Value To A
  lbu t0,1(a2)                  // A_REG = MEM_MAP[$FF00 + Imm8Bit]
  ori t0,$FF00
  addu a2,a0,t0                 // A2 = MEM_MAP + $FF00 + Imm8Bit
  lbu t0,0(a2)
  and s0,$FF
  sll t0,8
  or s0,t0
  addiu s4,1                    // PC_REG++
  jr ra
  addiu v0,3                    // QCycles += 3 (Delay Slot)

align(256)
  // $F1 POP   AF               Pop 2 Bytes Off Stack To Register Pair AF, Increment Stack Pointer (SP) Twice, Mask Flag Register With $F0
  addu a2,a0,sp                 // A2 = MEM_MAP + SP_REG
  lbu s0,0(a2)                  // AF_REG = STACK
  andi s0,$F0                   // F_REG &= $F0
  lbu t0,1(a2)
  sll t0,8
  or s0,t0
  addiu sp,2                    // SP_REG += 2
  jr ra
  addiu v0,3                    // QCycles += 3 (Delay Slot)

align(256)
  // $F2 LD    A, (C)           Load Value At Address $FF00 + Register C To A
  andi t0,s1,$FF                // A_REG = MEM_MAP[$FF00 + C_REG]
  ori t0,$FF00
  addu a2,a0,t0                 // A2 = MEM_MAP + $FF00 + C_REG
  lbu t0,0(a2)
  andi s0,$FF
  sll t0,8
  or s0,t0
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $F3 DI                     Disable Interrupts 2 Instructions After DI Is Executed
  lli t9,0                      // IME_FLAG = 0
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $F4 UNUSED OPCODE          Execution Will Cause GB To Permanently Halt Operation Until Power Down / Power Up
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $F5 PUSH  AF               Push Register Pair AF To Stack, Decrement Stack Pointer (SP) Twice
  subiu sp,2                    // SP_REG -= 2
  addu a2,a0,sp                 // A2 = MEM_MAP + SP_REG
  sb s0,0(a2)                   // STACK = AF_REG
  srl t0,s0,8
  sb t0,1(a2)
  jr ra
  addiu v0,4                    // QCycles += 4 (Delay Slot)

align(256)
  // $F6 OR    imm              Logical OR 8-Bit Immediate Value With A
  lbu t0,1(a2)                  // A_REG |= Imm8Bit
  sll t0,8
  or s0,t0
  andi t0,s0,$FF00
  beqz t0,ORIZ                  // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  ORIZ:
  andi s0,~(C_FLAG+H_FLAG+N_FLAG) // F_REG: C Flag Reset, H Flag Reset, N Flag Reset
  addiu s4,1                    // PC_REG++
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $F7 RST   30H              Push Present Address To Stack, Jump To Address $0030
  subiu sp,2                    // SP_REG -= 2
  addu a2,a0,sp                 // A2 = MEM_MAP + SP_REG
  sb s4,0(a2)                   // STACK = PC_REG
  srl t0,s4,8
  sb t0,1(a2)
  lli s4,$0030                  // PC_REG = $0030
  jr ra
  addiu v0,4                    // QCycles += 4 (Delay Slot)

align(256)
  // $F8 LDHL  SP, imm          Load SP + 8-Bit Signed Immediate Value Effective Address To HL
  andi t0,sp,$F                 // IF ((SP_REG & $F) + (Imm8bit & $F) & $10) H Flag Set (Carry From Bit 3)
  lbu t1,1(a2)
  andi t2,t1,$F
  addu t0,t2
  andi t0,$10
  bnez t0,LDHLSPH
  ori s0,H_FLAG                 // F_REG: H Flag Set (Carry From Bit 3) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (No Carry From Bit 3)
  LDHLSPH:
  lb t0,1(a2)                   // HL_REG = SP_REG + Imm8Bit
  add s3,sp,t0        
  andi s3,$FFFF
  andi t0,s3,$FF
  blt t0,t1,LDHLSPC             // IF ((HL_REG & $FF) < Imm8Bit) C Flag Set (Carry From Bit 7)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Carry From Bit 7) (Delay Slot)
  andi s0,C_FLAG                // F_REG: C Flag Reset (No Carry From Bit 7)
  LDHLSPC:
  andi s0,~(N_FLAG+Z_FLAG)      // F_REG: N Flag Reset, Z Flag Reset
  addiu s4,1                    // PC_REG++
  jr ra
  addiu v0,3                    // QCycles += 3 (Delay Slot)

align(256)
  // $F9 LD    SP, HL           Load HL To Stack Pointer (SP)
  addu sp,r0,s3                 // SP_REG = HL_REG
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $FA LD    A, (imm)         Load 16-Bit Immediate Value To A
  lbu t0,1(a2)                  // A_REG = MEM_MAP[Imm16Bit]
  lbu t1,2(a2)
  sll t1,8
  or t0,t1
  addu a2,a0,t0                 // A2 = MEM_MAP + Imm16Bit
  lbu t0,0(a2)
  andi s0,$FF
  sll t0,8
  or s0,t0
  addiu s4,2                    // PC_REG += 2
  jr ra
  addiu v0,4                    // QCycles += 4 (Delay Slot)

align(256)
  // $FB EI                     Enable Interrupts 2 Instructions After EI Is Executed
  lli t9,1                      // IME_FLAG = 1
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $FC UNUSED OPCODE          Execution Will Cause GB To Permanently Halt Operation Until Power Down / Power Up
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $FD UNUSED OPCODE          Execution Will Cause GB To Permanently Halt Operation Until Power Down / Power Up
  jr ra
  addiu v0,1                    // QCycles++ (Delay Slot)

align(256)
  // $FE CP    imm              Compare A With 8-Bit Immediate Value
  srl t0,s0,8                   // IF ((A_REG & $F) - (Imm8Bit & $F) < $0) H Flag Set (No Borrow From Bit 4)
  lbu t1,1(a2)
  andi t2,t0,$F
  andi t3,t1,$F
  sub t2,t3
  bltz t2,CPIH
  ori s0,H_FLAG                 // F_REG: H Flag Set (No Borrow From Bit 4) (Delay Slot)
  andi s0,~H_FLAG               // F_REG: H Flag Reset (Borrow From Bit 4)
  CPIH:
  blt t0,t1,CPIC                // IF (A_REG < B_REG) C Flag Set (No Borrow)
  ori s0,C_FLAG                 // F_REG: C Flag Set (No Borrow) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Borrow)
  CPIC:
  beq t0,t1,CPIZ                // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  CPIZ:
  ori s0,N_FLAG                 // F_REG: N Flag Set
  addiu s4,1                    // PC_REG++
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $FF RST   38H              Push Present Address To Stack, Jump To Address $0038
  subiu sp,2                    // SP_REG -= 2
  addu a2,a0,sp                 // A2 = MEM_MAP + SP_REG
  sb s4,0(a2)                   // STACK = PC_REG
  srl t0,s4,8
  sb t0,1(a2)
  lli s4,$0038                  // PC_REG = $0038
  jr ra
  addiu v0,4                    // QCycles += 4 (Delay Slot)

// $CBXX Instructions
align(256)
CPU_CB_INST:
  // $00 RLC   B                Rotate Register B Left, Old Bit 7 To Carry Flag
  srl t0,s1,7                   // B_REG = (B_REG << 1) | (B_REG >> 7)
  andi t0,$FE
  srl t1,s1,15
  or t0,t1
  andi s1,$FF
  sll t0,8
  or s1,t0
  beqz t0,RLCBZ                 // IF (! B_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  RLCBZ:
  andi t0,1
  bnez t0,RLCBC                 // IF (B_REG & 1) C Flag Set (Old Bit 7)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Old Bit 7) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Old Bit 7)
  RLCBC:
  andi s0,~(H_FLAG+N_FLAG)      // F_REG: H Flag Reset, N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $01 RLC   C                Rotate Register C Left, Old Bit 7 To Carry Flag
  andi t0,s1,$FF                // C_REG = (C_REG << 1) | (C_REG >> 7)
  sll t0,1
  andi t1,t0,$100
  beqz t1,RLCCC                 // IF (C_REG & 1) C Flag Set (Old Bit 7)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Old Bit 7) (Delay Slot)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Old Bit 7)
  ori t0,1
  RLCCC:
  andi t0,$FF
  andi s1,$FF00
  or s1,t0
  beqz t0,RLCCZ                 // IF (! C_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  RLCCZ:
  andi s0,~(H_FLAG+N_FLAG)      // F_REG: H Flag Reset, N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $02 RLC   D                Rotate Register D Left, Old Bit 7 To Carry Flag
  srl t0,s2,7                   // D_REG = (D_REG << 1) | (D_REG >> 7)
  andi t0,$FE
  srl t1,s2,15
  or t0,t1
  andi s2,$FF
  sll t0,8
  or s2,t0
  beqz t0,RLCDZ                 // IF (! D_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  RLCDZ:
  andi t0,1
  bnez t0,RLCDC                 // IF (D_REG & 1) C Flag Set (Old Bit 7)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Old Bit 7) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Old Bit 7)
  RLCDC:
  andi s0,~(H_FLAG+N_FLAG)      // F_REG: H Flag Reset, N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $03 RLC   E                Rotate Register E Left, Old Bit 7 To Carry Flag
  andi t0,s2,$FF                // E_REG = (E_REG << 1) | (E_REG >> 7)
  sll t0,1
  andi t1,t0,$100
  beqz t1,RLCEC                 // IF (E_REG & 1) C Flag Set (Old Bit 7)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Old Bit 7) (Delay Slot)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Old Bit 7)
  ori t0,1
  RLCEC:
  andi t0,$FF
  andi s2,$FF00
  or s2,t0
  beqz t0,RLCEZ                 // IF (! E_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  RLCEZ:
  andi s0,~(H_FLAG+N_FLAG)      // F_REG: H Flag Reset, N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $04 RLC   H                Rotate Register H Left, Old Bit 7 To Carry Flag
  srl t0,s3,7                   // H_REG = (H_REG << 1) | (H_REG >> 7)
  andi t0,$FE
  srl t1,s3,15
  or t0,t1
  andi s3,$FF
  sll t0,8
  or s3,t0
  beqz t0,RLCHZ                 // IF (! H_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  RLCHZ:
  andi t0,1
  bnez t0,RLCHC                 // IF (H_REG & 1) C Flag Set (Old Bit 7)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Old Bit 7) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Old Bit 7)
  RLCHC:
  andi s0,~(H_FLAG+N_FLAG)      // F_REG: H Flag Reset, N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $05 RLC   L                Rotate Register L Left, Old Bit 7 To Carry Flag
  andi t0,s3,$FF                // L_REG = (L_REG << 1) | (L_REG >> 7)
  sll t0,1
  andi t1,t0,$100
  beqz t1,RLCLC                 // IF (L_REG & 1) C Flag Set (Old Bit 7)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Old Bit 7) (Delay Slot)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Old Bit 7)
  ori t0,1
  RLCLC:
  andi t0,$FF
  andi s3,$FF00
  or s3,t0
  beqz t0,RLCLZ                 // IF (! L_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  RLCLZ:
  andi s0,~(H_FLAG+N_FLAG)      // F_REG: H Flag Reset, N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $06 RLC   (HL)             Rotate 8-Bit Value From Address In HL Left, Old Bit 7 To Carry Flag
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  lbu t0,0(a2)                  // MEM_MAP[HL_REG] = (MEM_MAP[HL_REG] << 1) | (MEM_MAP[HL_REG] >> 7)
  sll t0,1
  andi t1,t0,$100
  beqz t1,RLCHLC                // IF (MEM_MAP[HL_REG] & 1) C Flag Set (Old Bit 7)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Old Bit 7) (Delay Slot)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Old Bit 7)
  ori t0,1
  RLCHLC:
  sb t1,0(a2)
  andi t0,$FF
  beqz t0,RLCHLZ                // IF (! MEM_MAP[HL_REG]) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  RLCHLZ:
  andi s0,~(H_FLAG+N_FLAG)      // F_REG: H Flag Reset, N Flag Reset
  jr ra
  addiu v0,4                    // QCycles += 4 (Delay Slot)

align(256)
  // $07 RLC   A                Rotate Register A Left, Old Bit 7 To Carry Flag
  srl t0,s0,7                   // A_REG = (A_REG << 1) | (A_REG >> 7)
  andi t0,$FE
  srl t1,s0,15
  or t0,t1
  andi s0,$FF
  sll t0,8
  or s0,t0
  beqz t0,RLCAZ                 // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  RLCAZ:
  andi t0,1
  bnez t0,RLCAC                 // IF (A_REG & 1) C Flag Set (Old Bit 7)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Old Bit 7) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Old Bit 7)
  RLCAC:
  andi s0,~(H_FLAG+N_FLAG)      // F_REG: H Flag Reset, N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $08 RRC   B                Rotate Register B Right, Old Bit 0 To Carry Flag
  srl t0,s1,9                   // B_REG = (B_REG >> 1) | (B_REG << 7)
  andi t1,s1,$100
  beqz t1,RRCBC                 // IF (B_REG & 1) C Flag Set (Old Bit 0)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Old Bit 0) (Delay Slot)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Old Bit 0)
  ori t0,$80
  RRCBC:
  andi s1,$FF
  sll t0,8
  or s1,t0
  beqz t0,RRCBZ                 // IF (! B_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  RRCBZ:
  andi s0,~(H_FLAG+N_FLAG)      // F_REG: H Flag Reset, N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $09 RRC   C                Rotate Register C Right, Old Bit 0 To Carry Flag
  andi t0,s1,$FF                // C_REG = (C_REG >> 1) | (C_REG << 7)
  andi t1,s1,1
  beqz t1,RRCCC                 // IF (C_REG & 1) C Flag Set (Old Bit 0)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Old Bit 0) (Delay Slot)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Old Bit 0)
  ori t0,$100
  RRCCC:
  srl t0,1
  andi s1,$FF00
  or s1,t0
  beqz t0,RRCCZ                 // IF (! C_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  RRCCZ:
  andi s0,~(H_FLAG+N_FLAG)      // F_REG: H Flag Reset, N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $0A RRC   D                Rotate Register D Right, Old Bit 0 To Carry Flag
  srl t0,s2,9                   // D_REG = (D_REG >> 1) | (D_REG << 7)
  andi t1,s2,$100
  beqz t1,RRCDC                 // IF (D_REG & 1) C Flag Set (Old Bit 0)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Old Bit 0) (Delay Slot)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Old Bit 0)
  ori t0,$80
  RRCDC:
  andi s2,$FF
  sll t0,8
  or s2,t0
  beqz t0,RRCDZ                 // IF (! D_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  RRCDZ:
  andi s0,~(H_FLAG+N_FLAG)      // F_REG: H Flag Reset, N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $0B RRC   E                Rotate Register E Right, Old Bit 0 To Carry Flag
  andi t0,s2,$FF                // E_REG = (E_REG >> 1) | (E_REG << 7)
  andi t1,s2,1
  beqz t1,RRCEC                 // IF (E_REG & 1) C Flag Set (Old Bit 0)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Old Bit 0) (Delay Slot)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Old Bit 0)
  ori t0,$100
  RRCEC:
  srl t0,1
  andi s2,$FF00
  or s2,t0
  beqz t0,RRCEZ                 // IF (! E_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  RRCEZ:
  andi s0,~(H_FLAG+N_FLAG)      // F_REG: H Flag Reset, N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $0C RRC   H                Rotate Register H Right, Old Bit 0 To Carry Flag
  srl t0,s3,9                   // H_REG = (H_REG >> 1) | (H_REG << 7)
  andi t1,s3,$100
  beqz t1,RRCHC                 // IF (H_REG & 1) C Flag Set (Old Bit 0)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Old Bit 0) (Delay Slot)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Old Bit 0)
  ori t0,$80
  RRCHC:
  andi s3,$FF
  sll t0,8
  or s3,t0
  beqz t0,RRCHZ                 // IF (! H_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  RRCHZ:
  andi s0,~(H_FLAG+N_FLAG)      // F_REG: H Flag Reset, N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $0D RRC   L                Rotate Register L Right, Old Bit 0 To Carry Flag
  andi t0,s3,$FF                // L_REG = (L_REG >> 1) | (L_REG << 7)
  andi t1,s3,1
  beqz t1,RRCLC                 // IF (L_REG & 1) C Flag Set (Old Bit 0)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Old Bit 0) (Delay Slot)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Old Bit 0)
  ori t0,$100
  RRCLC:
  srl t0,1
  andi s3,$FF00
  or s3,t0
  beqz t0,RRCLZ                 // IF (! L_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  RRCLZ:
  andi s0,~(H_FLAG+N_FLAG)      // F_REG: H Flag Reset, N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $0E RRC   (HL)             Rotate 8-Bit Value From Address In HL Right, Old Bit 0 To Carry Flag
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  lbu t0,0(a2)
  andi t1,s3,1
  beqz t1,RRCHLC                // IF (MEM_MAP[HL_REG] & 1) C Flag Set (Old Bit 0)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Old Bit 0) (Delay Slot)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Old Bit 0)
  ori t0,$100
  RRCHLC:
  srl t0,1                      // MEM_MAP[HL_REG] = (MEM_MAP[HL_REG] >> 1) | (MEM_MAP[HL_REG] << 7)
  sb t0,0(a2)
  beqz t0,RRCHLZ                // IF (! MEM_MAP[HL_REG]) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  RRCHLZ:
  andi s0,~(H_FLAG+N_FLAG)      // F_REG: H Flag Reset, N Flag Reset
  jr ra
  addiu v0,4                    // QCycles += 4 (Delay Slot)

align(256)
  // $0F RRC   A                Rotate Register A Right, Old Bit 0 To Carry Flag
  srl t0,s0,9                   // A_REG = (A_REG >> 1) | (A_REG << 7)
  andi t1,s0,$100
  beqz t1,RRCAC                 // IF (A_REG & 1) C Flag Set (Old Bit 0)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Old Bit 0) (Delay Slot)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Old Bit 0)
  ori t0,$80
  RRCAC:
  andi s0,$FF
  sll t0,8
  or s0,t0
  beqz t0,RRCAZ                 // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  RRCAZ:
  andi s0,~(H_FLAG+N_FLAG)      // F_REG: H Flag Reset, N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $10 RL    B                Rotate Register B Left, Through Carry Flag
  srl t0,s1,7                   // B_REG = (B_REG << 1) | (C_FLAG)
  andi t1,s0,C_FLAG
  bnez t1,RLB
  ori t0,1                      // Delay Slot
  andi t0,~1
  RLB:
  andi t1,t0,$100
  bnez t1,RLBC                  // IF (B_REG & $100) C Flag Set (Old Bit 7)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Old Bit 7) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Old Bit 7)
  RLBC:
  andi t0,$FF
  andi s1,$FF
  sll t0,8
  or s1,t0
  beqz t0,RLBZ                  // IF (! B_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // Z Flag Reset (Result Is Not Zero)
  RLBZ:
  andi s0,~(H_FLAG+N_FLAG)      // F_REG: H Flag Reset, N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $11 RL    C                Rotate Register C Left, Through Carry Flag
  andi t0,s1,$FF                // C_REG = (C_REG << 1) | (C_FLAG)
  srl t0,1
  andi t1,s0,C_FLAG
  bnez t1,RLCR
  ori t0,1                      // Delay Slot
  andi t0,~1
  RLCR:
  andi t1,t0,$100
  bnez t1,RLCRC                 // IF (C_REG & $100) C Flag Set (Old Bit 7)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Old Bit 7) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Old Bit 7)
  RLCRC:
  andi t0,$FF
  andi s1,$FF00
  or s1,t0 
  beqz t0,RLCRZ                 // IF (! C_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // Z Flag Reset (Result Is Not Zero)
  RLCRZ:
  andi s0,~(H_FLAG+N_FLAG)      // F_REG: H Flag Reset, N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $12 RL    D                Rotate Register D Left, Through Carry Flag
  srl t0,s2,7                   // D_REG = (D_REG << 1) | (C_FLAG)
  andi t1,s0,C_FLAG
  bnez t1,RLD
  ori t0,1                      // Delay Slot
  andi t0,~1
  RLD:
  andi t1,t0,$100
  bnez t1,RLDC                  // IF (D_REG & $100) C Flag Set (Old Bit 7)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Old Bit 7) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Old Bit 7)
  RLDC:
  andi t0,$FF
  andi s2,$FF
  sll t0,8
  or s2,t0
  beqz t0,RLDZ                  // IF (! D_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // Z Flag Reset (Result Is Not Zero)
  RLDZ:
  andi s0,~(H_FLAG+N_FLAG)      // F_REG: H Flag Reset, N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $13 RL    E                Rotate Register E Left, Through Carry Flag
  andi t0,s2,$FF                // E_REG = (E_REG << 1) | (C_FLAG)
  srl t0,1
  andi t1,s0,C_FLAG
  bnez t1,RLE
  ori t0,1                      // Delay Slot
  andi t0,~1
  RLE:
  andi t1,t0,$100
  bnez t1,RLEC                  // IF (E_REG & $100) C Flag Set (Old Bit 7)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Old Bit 7) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Old Bit 7)
  RLEC:
  andi t0,$FF
  andi s2,$FF00
  or s2,t0 
  beqz t0,RLEZ                  // IF (! E_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // Z Flag Reset (Result Is Not Zero)
  RLEZ:
  andi s0,~(H_FLAG+N_FLAG)      // F_REG: H Flag Reset, N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $14 RL    H                Rotate Register H Left, Through Carry Flag
  srl t0,s3,7                   // H_REG = (H_REG << 1) | (C_FLAG)
  andi t1,s0,C_FLAG
  bnez t1,RLH
  ori t0,1                      // Delay Slot
  andi t0,~1
  RLH:
  andi t1,t0,$100
  bnez t1,RLHC                  // IF (H_REG & $100) C Flag Set (Old Bit 7)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Old Bit 7) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Old Bit 7)
  RLHC:
  andi t0,$FF
  andi s3,$FF
  sll t0,8
  or s3,t0
  beqz t0,RLHZ                  // IF (! H_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // Z Flag Reset (Result Is Not Zero)
  RLHZ:
  andi s0,~(H_FLAG+N_FLAG)      // F_REG: H Flag Reset, N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $15 RL    L                Rotate Register L Left, Through Carry Flag
  andi t0,s3,$FF                // L_REG = (L_REG << 1) | (C_FLAG)
  srl t0,1
  andi t1,s0,C_FLAG
  bnez t1,RLL
  ori t0,1                      // Delay Slot
  andi t0,~1
  RLL:
  andi t1,t0,$100
  bnez t1,RLLC                  // IF (L_REG & $100) C Flag Set (Old Bit 7)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Old Bit 7) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Old Bit 7)
  RLLC:
  andi t0,$FF
  andi s3,$FF00
  or s3,t0 
  beqz t0,RLLZ                  // IF (! L_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // Z Flag Reset (Result Is Not Zero)
  RLLZ:
  andi s0,~(H_FLAG+N_FLAG)      // F_REG: H Flag Reset, N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $16 RL    (HL)             Rotate 8-Bit Value From Address In HL Left, Through Carry Flag
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  lbu t0,0(a2)                  // MEM_MAP[HL_REG] = (MEM_MAP[HL_REG] << 1) | (C_FLAG)
  srl t0,1
  andi t1,s0,C_FLAG
  bnez t1,RLHL
  ori t0,1                      // Delay Slot
  andi t0,~1
  RLHL:
  andi t1,t0,$100
  bnez t1,RLHLC                 // IF (MEM_MAP[HL_REG] & $100) C Flag Set (Old Bit 7)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Old Bit 7) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Old Bit 7)
  RLHLC:
  sb t0,0(a2)
  andi t0,$FF
  beqz t0,RLHLZ                 // IF (! MEM_MAP[HL_REG]) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // Z Flag Reset (Result Is Not Zero)
  RLHLZ:
  andi s0,~(H_FLAG+N_FLAG)      // F_REG: H Flag Reset, N Flag Reset
  jr ra
  addiu v0,4                    // QCycles += 4 (Delay Slot)

align(256)
  // $17 RL    A                Rotate Register A Left, Through Carry Flag
  srl t0,s0,7                   // A_REG = (A_REG << 1) | (C_FLAG)
  andi t1,s0,C_FLAG
  bnez t1,RLA
  ori t0,1                      // Delay Slot
  andi t0,~1
  RLA:
  andi t1,t0,$100
  bnez t1,RLHC                  // IF (A_REG & $100) C Flag Set (Old Bit 7)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Old Bit 7) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Old Bit 7)
  RLAC:
  andi t0,$FF
  andi s0,$FF
  sll t0,8
  or s0,t0
  beqz t0,RLAZ                  // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // Z Flag Reset (Result Is Not Zero)
  RLAZ:
  andi s0,~(H_FLAG+N_FLAG)      // F_REG: H Flag Reset, N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $18 RR    B                Rotate Register B Right, Through Carry Flag
  srl t0,s1,9                   // B_REG = (B_REG >> 1) | (C_FLAG << 7)
  andi t1,s0,C_FLAG
  bnez t1,RRB                   // Delay Slot
  ori t0,$80
  andi t0,~$80
  RRB:
  andi t1,s1,$100
  bnez t1,RRBC                  // IF (B_REG & 1) C Flag Set (Old Bit 0)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Old Bit 0) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Old Bit 0)
  RRBC:
  andi t0,$FF
  andi s1,$FF
  sll t0,8
  or s1,t0
  beqz t0,RRBZ                  // IF (! B_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // Z Flag Reset (Result Is Not Zero)
  RRBZ:
  andi s0,~(H_FLAG+N_FLAG)      // F_REG: H Flag Reset, N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $19 RR    C                Rotate Register C Right, Through Carry Flag
  andi t0,s1,$FF                // C_REG = (C_REG >> 1) | (C_FLAG << 7)
  srl t0,1
  andi t1,s0,C_FLAG
  bnez t1,RRCR                  // Delay Slot
  ori t0,$80
  andi t0,~$80
  RRCR:
  andi t1,s1,$1
  bnez t1,RRCRC                 // IF (C_REG & 1) C Flag Set (Old Bit 0)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Old Bit 0) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Old Bit 0)
  RRCRC:
  andi t0,$FF
  andi s1,$FF00
  or s1,t0
  beqz t0,RRCRZ                 // IF (! C_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // Z Flag Reset (Result Is Not Zero)
  RRCRZ:
  andi s0,~(H_FLAG+N_FLAG)      // F_REG: H Flag Reset, N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $1A RR    D                Rotate Register D Right, Through Carry Flag
  srl t0,s2,9                   // D_REG = (D_REG >> 1) | (C_FLAG << 7)
  andi t1,s0,C_FLAG
  bnez t1,RRD                   // Delay Slot
  ori t0,$80
  andi t0,~$80
  RRD:
  andi t1,s2,$100
  bnez t1,RRDC                  // IF (D_REG & 1) C Flag Set (Old Bit 0)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Old Bit 0) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Old Bit 0)
  RRDC:
  andi t0,$FF
  andi s2,$FF
  sll t0,8
  or s2,t0
  beqz t0,RRDZ                  // IF (! D_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // Z Flag Reset (Result Is Not Zero)
  RRDZ:
  andi s0,~(H_FLAG+N_FLAG)      // F_REG: H Flag Reset, N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $1B RR    E                Rotate Register E Right, Through Carry Flag
  andi t0,s2,$FF                // E_REG = (E_REG >> 1) | (C_FLAG << 7)
  srl t0,1
  andi t1,s0,C_FLAG
  bnez t1,RRE                   // Delay Slot
  ori t0,$80
  andi t0,~$80
  RRE:
  andi t1,s2,$1
  bnez t1,RREC                  // IF (E_REG & 1) C Flag Set (Old Bit 0)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Old Bit 0) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Old Bit 0)
  RREC:
  andi t0,$FF
  andi s2,$FF00
  or s2,t0
  beqz t0,RREZ                  // IF (! E_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // Z Flag Reset (Result Is Not Zero)
  RREZ:
  andi s0,~(H_FLAG+N_FLAG)      // F_REG: H Flag Reset, N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $1C RR    H                Rotate Register H Right, Through Carry Flag
  srl t0,s3,9                   // H_REG = (H_REG >> 1) | (C_FLAG << 7)
  andi t1,s0,C_FLAG
  bnez t1,RRH                   // Delay Slot
  ori t0,$80
  andi t0,~$80
  RRH:
  andi t1,s3,$100
  bnez t1,RRHC                  // IF (H_REG & 1) C Flag Set (Old Bit 0)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Old Bit 0) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Old Bit 0)
  RRHC:
  andi t0,$FF
  andi s3,$FF
  sll t0,8
  or s3,t0
  beqz t0,RRHZ                  // IF (! H_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // Z Flag Reset (Result Is Not Zero)
  RRHZ:
  andi s0,~(H_FLAG+N_FLAG)      // F_REG: H Flag Reset, N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $1D RR    L                Rotate Register L Right, Through Carry Flag
  andi t0,s3,$FF                // L_REG = (L_REG >> 1) | (C_FLAG << 7)
  srl t0,1
  andi t1,s0,C_FLAG
  bnez t1,RRL                   // Delay Slot
  ori t0,$80
  andi t0,~$80
  RRL:
  andi t1,s3,$1
  bnez t1,RRLC                  // IF (L_REG & 1) C Flag Set (Old Bit 0)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Old Bit 0) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Old Bit 0)
  RRLC:
  andi t0,$FF
  andi s3,$FF00
  or s3,t0
  beqz t0,RRLZ                  // IF (! L_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // Z Flag Reset (Result Is Not Zero)
  RRLZ:
  andi s0,~(H_FLAG+N_FLAG)      // F_REG: H Flag Reset, N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $1E RR    (HL)             Rotate 8-Bit Value From Address In HL Right, Through Carry Flag
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  lbu t0,0(a2)                  // MEM_MAP[HL_REG] = (MEM_MAP[HL_REG] >> 1) | (C_FLAG << 7)
  addu t1,r0,t0
  srl t0,1
  andi t2,s0,C_FLAG
  bnez t2,RRHL                  // Delay Slot
  ori t0,$80
  andi t0,~$80
  RRHL:
  andi t1,$1
  bnez t1,RRHLC                 // IF (MEM_MAP[HL_REG] & 1) C Flag Set (Old Bit 0)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Old Bit 0) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Old Bit 0)
  RRHLC:
  sb t0,0(a2)
  andi t0,$FF
  beqz t0,RRHLZ                 // IF (! MEM_MAP[HL_REG]) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // Z Flag Reset (Result Is Not Zero)
  RRHLZ:
  andi s0,~(H_FLAG+N_FLAG)      // F_REG: H Flag Reset, N Flag Reset
  jr ra
  addiu v0,4                    // QCycles += 4 (Delay Slot)

align(256)
  // $1F RR    A                Rotate Register A Right, Through Carry Flag
  srl t0,s0,9                   // A_REG = (A_REG >> 1) | (C_FLAG << 7)
  andi t1,s0,C_FLAG
  bnez t1,RRA                   // Delay Slot
  ori t0,$80
  andi t0,~$80
  RRA:
  andi t1,s0,$100
  bnez t1,RRAC                  // IF (A_REG & 1) C Flag Set (Old Bit 0)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Old Bit 0) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Old Bit 0)
  RRAC:
  andi t0,$FF
  andi s0,$FF
  sll t0,8
  or s0,t0
  beqz t0,RRAZ                  // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // Z Flag Reset (Result Is Not Zero)
  RRAZ:
  andi s0,~(H_FLAG+N_FLAG)      // F_REG: H Flag Reset, N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $20 SLA   B                Shift Register B Left, Into Carry Flag
  srl t0,s1,7                   // B_REG <<= 1
  andi t0,~1
  andi t1,t0,$100
  bnez t1,SLABC                 // IF (B_REG & $100) C Flag Set (Old Bit 7)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Old Bit 7) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Old Bit 7)
  SLABC:
  andi t0,$FF
  andi s1,$FF
  sll t0,8
  or s1,t0
  beqz t0,SLABZ                 // IF (! B_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  SLABZ:
  andi s0,~(H_FLAG+N_FLAG)      // F_REG: H Flag Reset, N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $21 SLA   C                Shift Register C Left, Into Carry Flag
  andi t0,s1,$FF                // C_REG <<= 1
  sll t0,1
  andi t1,t0,$100
  bnez t1,SLACC                 // IF (C_REG & $100) C Flag Set (Old Bit 7)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Old Bit 7) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Old Bit 7)
  SLACC:
  andi t0,$FF
  andi s1,$FF00
  or s1,t0
  beqz t0,SLACZ                 // IF (! B_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  SLACZ:
  andi s0,~(H_FLAG+N_FLAG)      // F_REG: H Flag Reset, N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $22 SLA   D                Shift Register D Left, Into Carry Flag
  srl t0,s2,7                   // D_REG <<= 1
  andi t0,~1
  andi t1,t0,$100
  bnez t1,SLADC                 // IF (D_REG & $100) C Flag Set (Old Bit 7)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Old Bit 7) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Old Bit 7)
  SLADC:
  andi t0,$FF
  andi s2,$FF
  sll t0,8
  or s2,t0
  beqz t0,SLADZ                 // IF (! D_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  SLADZ:
  andi s0,~(H_FLAG+N_FLAG)      // F_REG: H Flag Reset, N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $23 SLA   E                Shift Register E Left, Into Carry Flag
  andi t0,s2,$FF                // E_REG <<= 1
  sll t0,1
  andi t1,t0,$100
  bnez t1,SLAEC                 // IF (E_REG & $100) C Flag Set (Old Bit 7)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Old Bit 7) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Old Bit 7)
  SLAEC:
  andi t0,$FF
  andi s2,$FF00
  or s2,t0
  beqz t0,SLAEZ                 // IF (! E_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  SLAEZ:
  andi s0,~(H_FLAG+N_FLAG)      // F_REG: H Flag Reset, N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $24 SLA   H                Shift Register H Left, Into Carry Flag
  srl t0,s3,7                   // H_REG <<= 1
  andi t0,~1
  andi t1,t0,$100
  bnez t1,SLAHC                 // IF (H_REG & $100) C Flag Set (Old Bit 7)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Old Bit 7) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Old Bit 7)
  SLAHC:
  andi t0,$FF
  andi s3,$FF
  sll t0,8
  or s3,t0
  beqz t0,SLAHZ                 // IF (! H_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  SLAHZ:
  andi s0,~(H_FLAG+N_FLAG)      // F_REG: H Flag Reset, N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $25 SLA   L                Shift Register L Left, Into Carry Flag
  andi t0,s3,$FF                // L_REG <<= 1
  sll t0,1
  andi t1,t0,$100
  bnez t1,SLALC                 // IF (L_REG & $100) C Flag Set (Old Bit 7)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Old Bit 7) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Old Bit 7)
  SLALC:
  andi t0,$FF
  andi s3,$FF00
  or s3,t0
  beqz t0,SLALZ                 // IF (! L_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  SLALZ:
  andi s0,~(H_FLAG+N_FLAG)      // F_REG: H Flag Reset, N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $26 SLA   (HL)             Shift 8-Bit Value From Address In HL Left, Into Carry Flag
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  lbu t0,0(a2)                  // MEM_MAP[HL_REG] <<= 1
  sll t0,1
  andi t1,t0,$100
  bnez t1,SLAHLC                // IF (MEM_MAP[HL_REG] & $100) C Flag Set (Old Bit 7)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Old Bit 7) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Old Bit 7)
  SLAHLC:
  sb t0,0(a2)
  andi t0,$FF
  beqz t0,SLAHLZ                // IF (! MEM_MAP[HL_REG]) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  SLAHLZ:
  andi s0,~(H_FLAG+N_FLAG)      // F_REG: H Flag Reset, N Flag Reset
  jr ra
  addiu v0,4                    // QCycles += 4 (Delay Slot)

align(256)
  // $27 SLA   A                Shift Register A Left, Into Carry Flag
  srl t0,s0,7                   // A_REG <<= 1
  andi t0,~1
  andi t1,t0,$100
  bnez t1,SLAAC                 // IF (A_REG & $100) C Flag Set (Old Bit 7)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Old Bit 7) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Old Bit 7)
  SLAAC:
  andi t0,$FF
  andi s0,$FF
  sll t0,8
  or s0,t0
  beqz t0,SLAAZ                 // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  SLAAZ:
  andi s0,~(H_FLAG+N_FLAG)      // F_REG: H Flag Reset, N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $28 SRA   B                Shift Register B Right, Into Carry Flag (MSB Does Not Change)
  srl t0,s1,9
  andi t1,s1,$100
  bnez t1,SRABC                 // IF (B_REG & 1) C Flag Set (Old Bit 0)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Old Bit 0) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Old Bit 0)
  SRABC:
  andi t1,s1,$8000              // IF ((B_REG>>7) & 1) B_REG = (B_REG>>1) + $80
  bnez t1,SRAB
  ori t0,$80                    // ELSE B_REG >>= 1
  SRAB:
  andi t0,$FF
  andi s1,$FF
  sll t0,8
  or s1,t0
  beqz t0,SRABZ                 // IF (! B_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  SRABZ:
  andi s0,~(H_FLAG+N_FLAG)      // F_REG: H Flag Reset, N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $29 SRA   C                Shift Register C Right, Into Carry Flag (MSB Does Not Change)
  andi t0,s1,$FF
  srl t0,1
  andi t1,s1,$1
  bnez t1,SRACC                 // IF (C_REG & 1) C Flag Set (Old Bit 0)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Old Bit 0) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Old Bit 0)
  SRACC:
  andi t1,s1,$80                // IF ((C_REG>>7) & 1) C_REG = (C_REG>>1) + $80
  bnez t1,SRAC
  ori t0,$80                    // ELSE C_REG >>= 1
  SRAC:
  andi t0,$FF
  andi s1,$FF00
  or s1,t0
  beqz t0,SRACZ                 // IF (! C_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  SRACZ:
  andi s0,~(H_FLAG+N_FLAG)      // F_REG: H Flag Reset, N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $2A SRA   D                Shift Register D Right, Into Carry Flag (MSB Does Not Change)
  srl t0,s2,9
  andi t1,s2,$100
  bnez t1,SRADC                 // IF (D_REG & 1) C Flag Set (Old Bit 0)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Old Bit 0) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Old Bit 0)
  SRADC:
  andi t1,s2,$8000              // IF ((D_REG>>7) & 1) D_REG = (D_REG>>1) + $80
  bnez t1,SRAD
  ori t0,$80                    // ELSE D_REG >>= 1
  SRAD:
  andi t0,$FF
  andi s2,$FF
  sll t0,8
  or s2,t0
  beqz t0,SRADZ                 // IF (! D_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  SRADZ:
  andi s0,~(H_FLAG+N_FLAG)      // F_REG: H Flag Reset, N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $2B SRA   E                Shift Register E Right, Into Carry Flag (MSB Does Not Change)
  andi t0,s2,$FF
  srl t0,1
  andi t1,s2,$1
  bnez t1,SRAEC                 // IF (E_REG & 1) C Flag Set (Old Bit 0)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Old Bit 0) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Old Bit 0)
  SRAEC:
  andi t1,s2,$80                // IF ((E_REG>>7) & 1) E_REG = (E_REG>>1) + $80
  bnez t1,SRAE
  ori t0,$80                    // ELSE E_REG >>= 1
  SRAE:
  andi t0,$FF
  andi s2,$FF00
  or s2,t0
  beqz t0,SRAEZ                 // IF (! E_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  SRAEZ:
  andi s0,~(H_FLAG+N_FLAG)      // F_REG: H Flag Reset, N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $2C SRA   H                Shift Register H Right, Into Carry Flag (MSB Does Not Change)
  srl t0,s3,9
  andi t1,s3,$100
  bnez t1,SRAHC                 // IF (H_REG & 1) C Flag Set (Old Bit 0)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Old Bit 0) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Old Bit 0)
  SRAHC:
  andi t1,s3,$8000              // IF ((H_REG>>7) & 1) H_REG = (H_REG>>1) + $80
  bnez t1,SRAH
  ori t0,$80                    // ELSE H_REG >>= 1
  SRAH:
  andi t0,$FF
  andi s3,$FF
  sll t0,8
  or s3,t0
  beqz t0,SRAHZ                 // IF (! H_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  SRAHZ:
  andi s0,~(H_FLAG+N_FLAG)      // F_REG: H Flag Reset, N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $2D SRA   L                Shift Register L Right, Into Carry Flag (MSB Does Not Change)
  andi t0,s3,$FF
  srl t0,1
  andi t1,s3,$1
  bnez t1,SRALC                 // IF (L_REG & 1) C Flag Set (Old Bit 0)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Old Bit 0) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Old Bit 0)
  SRALC:
  andi t1,s3,$80                // IF ((L_REG>>7) & 1) L_REG = (L_REG>>1) + $80
  bnez t1,SRAL
  ori t0,$80                    // ELSE L_REG >>= 1
  SRAL:
  andi t0,$FF
  andi s3,$FF00
  or s3,t0
  beqz t0,SRALZ                 // IF (! L_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  SRALZ:
  andi s0,~(H_FLAG+N_FLAG)      // F_REG: H Flag Reset, N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $2E SRA   (HL)             Shift 8-Bit Value From Address In HL Right, Into Carry Flag (MSB Does Not Change)
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  lbu t0,0(a2)
  addu t1,r0,t0
  srl t0,1
  andi t2,t1,$1
  bnez t2,SRAHLC                // IF (MEM_MAP[HL_REG] & 1) C Flag Set (Old Bit 0)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Old Bit 0) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Old Bit 0)
  SRAHLC:
  andi t1,$80                   // IF ((MEM_MAP[HL_REG]>>7) & 1) MEM_MAP[HL_REG] = (MEM_MAP[HL_REG]>>1) + $80
  bnez t1,SRAHL
  ori t0,$80                    // ELSE MEM_MAP[HL_REG] >>= 1
  SRAHL:
  sb t0,0(a2)
  andi t0,$FF
  beqz t0,SRAHLZ                // IF (! MEM_MAP[HL_REG]) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  SRAHLZ:
  andi s0,~(H_FLAG+N_FLAG)      // F_REG: H Flag Reset, N Flag Reset
  jr ra
  addiu v0,4                    // QCycles += 4 (Delay Slot)

align(256)
  // $2F SRA   A                Shift Register A Right, Into Carry Flag (MSB Does Not Change)
  srl t0,s0,9
  andi t1,s0,$100
  bnez t1,SRAAC                 // IF (A_REG & 1) C Flag Set (Old Bit 0)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Old Bit 0) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Old Bit 0)
  SRAAC:
  andi t1,s0,$8000              // IF ((A_REG>>7) & 1) A_REG = (A_REG>>1) + $80
  bnez t1,SRAA
  ori t0,$80                    // ELSE A_REG >>= 1
  SRAA:
  andi t0,$FF
  andi s0,$FF
  sll t0,8
  or s0,t0
  beqz t0,SRAAZ                 // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  SRAAZ:
  andi s0,~(H_FLAG+N_FLAG)      // F_REG: H Flag Reset, N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $30 SWAP  B                Swap Upper & Lower Nibbles Of B
  srl t0,s1,12                  // B_REG = (B_REG>>4) | (B_REG<<4)
  srl t1,s1,4
  andi t1,$F0
  or t0,t1
  andi s1,$FF
  sll t0,8
  or s1,t0
  beqz t0,SWAPBZ                // IF (! B_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  SWAPBZ:
  andi s0,~(C_FLAG+H_FLAG+N_FLAG) // F_REG: C Flag Reset, H Flag Reset, N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $31 SWAP  C                Swap Upper & Lower Nibbles Of C
  sll t0,s1,4                   // C_REG = (C_REG>>4) | (C_REG<<4)
  srl t1,s1,4
  andi t1,$F
  or t0,t1
  andi t0,$FF
  andi s1,$FF00
  or s1,t0
  beqz t0,SWAPCZ                // IF (! C_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  SWAPCZ:
  andi s0,~(C_FLAG+H_FLAG+N_FLAG) // F_REG: C Flag Reset, H Flag Reset, N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $32 SWAP  D                Swap Upper & Lower Nibbles Of D
  srl t0,s2,12                  // D_REG = (D_REG>>4) | (D_REG<<4)
  srl t1,s2,4
  andi t1,$F0
  or t0,t1
  andi s2,$FF
  sll t0,8
  or s2,t0
  beqz t0,SWAPDZ                // IF (! D_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  SWAPDZ:
  andi s0,~(C_FLAG+H_FLAG+N_FLAG) // F_REG: C Flag Reset, H Flag Reset, N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $33 SWAP  E                Swap Upper & Lower Nibbles Of E
  sll t0,s2,4                   // E_REG = (E_REG>>4) | (E_REG<<4)
  srl t1,s2,4
  andi t1,$F
  or t0,t1
  andi t0,$FF
  andi s2,$FF00
  or s2,t0
  beqz t0,SWAPEZ                // IF (! E_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  SWAPEZ:
  andi s0,~(C_FLAG+H_FLAG+N_FLAG) // F_REG: C Flag Reset, H Flag Reset, N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $34 SWAP  H                Swap Upper & Lower Nibbles Of H
  srl t0,s3,12                  // H_REG = (H_REG>>4) | (H_REG<<4)
  srl t1,s3,4
  andi t1,$F0
  or t0,t1
  andi s3,$FF
  sll t0,8
  or s3,t0
  beqz t0,SWAPHZ                // IF (! H_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  SWAPHZ:
  andi s0,~(C_FLAG+H_FLAG+N_FLAG) // F_REG: C Flag Reset, H Flag Reset, N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $35 SWAP  L                Swap Upper & Lower Nibbles Of L
  sll t0,s3,4                   // L_REG = (L_REG>>4) | (L_REG<<4)
  srl t1,s3,4
  andi t1,$F
  or t0,t1
  andi t0,$FF
  andi s3,$FF00
  or s3,t0
  beqz t0,SWAPLZ                // IF (! L_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  SWAPLZ:
  andi s0,~(C_FLAG+H_FLAG+N_FLAG) // F_REG: C Flag Reset, H Flag Reset, N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $36 SWAP  (HL)             Swap Upper & Lower Nibbles Of 8-Bit Value From Address In HL
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  lbu t0,0(a2)                  // MEM_MAP[HL_REG] = (MEM_MAP[HL_REG]>>4) | (MEM_MAP[HL_REG]<<4)
  srl t1,t0,4
  sll t0,4
  andi t1,$F
  or t0,t1
  sb t0,0(a2)
  beqz t0,SWAPHLZ               // IF (! MEM_MAP[HL_REG]) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  SWAPHLZ:
  andi s0,~(C_FLAG+H_FLAG+N_FLAG) // F_REG: C Flag Reset, H Flag Reset, N Flag Reset
  jr ra
  addiu v0,4                    // QCycles += 4 (Delay Slot)

align(256)
  // $37 SWAP  A                Swap Upper & Lower Nibbles Of A
  srl t0,s0,12                  // A_REG = (A_REG>>4) | (A_REG<<4)
  srl t1,s0,4
  andi t1,$F0
  or t0,t1
  andi s0,$FF
  sll t0,8
  or s0,t0
  beqz t0,SWAPAZ                // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  SWAPAZ:
  andi s0,~(C_FLAG+H_FLAG+N_FLAG) // F_REG: C Flag Reset, H Flag Reset, N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $38 SRL   B                Shift Register B Right, Into Carry Flag
  srl t0,s1,9                   // B_REG >>= 1
  andi t1,s1,$100
  bnez t1,SRLBC                 // IF (B_REG & 1) C Flag Set (Old Bit 0)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Old Bit 0) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Old Bit 0)
  SRLBC:
  andi t0,$FF
  andi s1,$FF
  sll t0,8
  or s1,t0
  beqz t0,SRLBZ                 // IF (! B_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  SRLBZ:
  andi s0,~(H_FLAG+N_FLAG)      // F_REG: H Flag Reset, N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $39 SRL   C                Shift Register C Right, Into Carry Flag
  andi t0,s1,$FF                // C_REG >>= 1
  srl t0,1
  andi t1,s1,$1
  bnez t1,SRLCC                 // IF (C_REG & 1) C Flag Set (Old Bit 0)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Old Bit 0) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Old Bit 0)
  SRLCC:
  andi t0,$FF
  andi s1,$FF00
  or s1,t0
  beqz t0,SRLCZ                 // IF (! C_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  SRLCZ:
  andi s0,~(H_FLAG+N_FLAG)      // F_REG: H Flag Reset, N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $3A SRL   D                Shift Register D Right, Into Carry Flag
  srl t0,s2,9                   // D_REG >>= 1
  andi t1,s2,$100
  bnez t1,SRLDC                 // IF (D_REG & 1) C Flag Set (Old Bit 0)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Old Bit 0) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Old Bit 0)
  SRLDC:
  andi t0,$FF
  andi s2,$FF
  sll t0,8
  or s2,t0
  beqz t0,SRLDZ                 // IF (! D_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  SRLDZ:
  andi s0,~(H_FLAG+N_FLAG)      // F_REG: H Flag Reset, N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $3B SRL   E                Shift Register E Right, Into Carry Flag
  andi t0,s2,$FF                // E_REG >>= 1
  srl t0,1
  andi t1,s2,$1
  bnez t1,SRLEC                 // IF (E_REG & 1) C Flag Set (Old Bit 0)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Old Bit 0) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Old Bit 0)
  SRLEC:
  andi t0,$FF
  andi s2,$FF00
  or s2,t0
  beqz t0,SRLEZ                 // IF (! E_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  SRLEZ:
  andi s0,~(H_FLAG+N_FLAG)      // F_REG: H Flag Reset, N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $3C SRL   H                Shift Register H Right, Into Carry Flag
  srl t0,s3,9                   // H_REG >>= 1
  andi t1,s3,$100
  bnez t1,SRLHC                 // IF (H_REG & 1) C Flag Set (Old Bit 0)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Old Bit 0) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Old Bit 0)
  SRLHC:
  andi t0,$FF
  andi s3,$FF
  sll t0,8
  or s3,t0
  beqz t0,SRLHZ                 // IF (! H_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  SRLHZ:
  andi s0,~(H_FLAG+N_FLAG)      // F_REG: H Flag Reset, N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $3D SRL   L                Shift Register L Right, Into Carry Flag
  andi t0,s3,$FF                // L_REG >>= 1
  srl t0,1
  andi t1,s3,$1
  bnez t1,SRLLC                 // IF (L_REG & 1) C Flag Set (Old Bit 0)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Old Bit 0) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Old Bit 0)
  SRLLC:
  andi t0,$FF
  andi s3,$FF00
  or s3,t0
  beqz t0,SRLLZ                 // IF (! L_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  SRLLZ:
  andi s0,~(H_FLAG+N_FLAG)      // F_REG: H Flag Reset, N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $3E SRL   (HL)             Shift 8-Bit Value From Address In HL Right, Into Carry Flag
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  lbu t0,0(a2)                  // MEM_MAP[HL_REG] >>= 1
  addu t1,r0,t0
  srl t0,1
  andi t1,$1
  bnez t1,SRLHLC                // IF (MEM_MAP[HL_REG] & 1) C Flag Set (Old Bit 0)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Old Bit 0) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Old Bit 0)
  SRLHLC:
  sb t0,0(a2)
  andi t0,$FF
  beqz t0,SRLHLZ                // IF (! MEM_MAP[HL_REG]) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  SRLHLZ:
  andi s0,~(H_FLAG+N_FLAG)      // F_REG: H Flag Reset, N Flag Reset
  jr ra
  addiu v0,4                    // QCycles += 4 (Delay Slot)

align(256)
  // $3F SRL   A                Shift Register A Right, Into Carry Flag
  srl t0,s0,9                   // A_REG >>= 1
  andi t1,s0,$100
  bnez t1,SRLAC                 // IF (A_REG & 1) C Flag Set (Old Bit 0)
  ori s0,C_FLAG                 // F_REG: C Flag Set (Old Bit 0) (Delay Slot)
  andi s0,~C_FLAG               // F_REG: C Flag Reset (Old Bit 0)
  SRLAC:
  andi t0,$FF
  andi s0,$FF
  sll t0,8
  or s0,t0
  beqz t0,SRLAZ                 // IF (! A_REG) Z Flag Set (Result Is Zero)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Result Is Zero) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Result Is Not Zero)
  SRLAZ:
  andi s0,~(H_FLAG+N_FLAG)      // F_REG: H Flag Reset, N Flag Reset
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $40 BIT   0, B             Test Bit 0 In Register B
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  andi t0,s1,$0100
  beqz t0,BIT0BZ                // IF (! (B_REG & $01)) Z Flag Set (Bit 0 Of Register B Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 0 Of Register B Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 0 Of Register B Is 1)
  BIT0BZ:
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $41 BIT   0, C             Test Bit 0 In Register C
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  andi t0,s1,$01
  beqz t0,BIT0CZ                // IF (! (C_REG & $01)) Z Flag Set (Bit 0 Of Register C Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 0 Of Register C Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 0 Of Register C Is 1)
  BIT0CZ:
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $42 BIT   0, D             Test Bit 0 In Register D
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  andi t0,s2,$0100
  beqz t0,BIT0DZ                // IF (! (D_REG & $01)) Z Flag Set (Bit 0 Of Register D Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 0 Of Register D Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 0 Of Register D Is 1)
  BIT0DZ:
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $43 BIT   0, E             Test Bit 0 In Register E
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  andi t0,s2,$01
  beqz t0,BIT0EZ                // IF (! (E_REG & $01)) Z Flag Set (Bit 0 Of Register E Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 0 Of Register E Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 0 Of Register E Is 1)
  BIT0EZ:
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $44 BIT   0, H             Test Bit 0 In Register H
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  andi t0,s3,$0100
  beqz t0,BIT0HZ                // IF (! (H_REG & $01)) Z Flag Set (Bit 0 Of Register H Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 0 Of Register H Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 0 Of Register H Is 1)
  BIT0HZ:
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $45 BIT   0, L             Test Bit 0 In Register L
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  andi t0,s3,$01
  beqz t0,BIT0LZ                // IF (! (L_REG & $01)) Z Flag Set (Bit 0 Of Register L Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 0 Of Register L Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 0 Of Register L Is 1)
  BIT0LZ:
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $46 BIT   0, (HL)          Test Bit 0 In 8-Bit Value Of Address In Register HL
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  lbu t0,0(a2)
  andi t0,$01
  beqz t0,BIT0HLZ               // IF (! (MEM_MAP[HL_REG] & $01)) Z Flag Set (Bit 0 Of 8-Bit Value Of Address In Register HL Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 0 Of 8-Bit Value Of Address In Register HL Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 0 Of 8-Bit Value Of Address In Register HL Is 1)
  BIT0HLZ:
  jr ra
  addiu v0,3                    // QCycles += 3 (Delay Slot)

align(256)
  // $47 BIT   0, A             Test Bit 0 In Register A
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  andi t0,s0,$0100
  beqz t0,BIT0AZ                // IF (! (A_REG & $01)) Z Flag Set (Bit 0 Of Register A Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 0 Of Register A Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 0 Of Register A Is 1)
  BIT0AZ:
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $48 BIT   1, B             Test Bit 1 In Register B
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  andi t0,s1,$0200
  beqz t0,BIT1BZ                // IF (! (B_REG & $02)) Z Flag Set (Bit 1 Of Register B Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 1 Of Register B Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 1 Of Register B Is 1)
  BIT1BZ:
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $49 BIT   1, C             Test Bit 1 In Register C
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  andi t0,s1,$02
  beqz t0,BIT1CZ                // IF (! (C_REG & $02)) Z Flag Set (Bit 1 Of Register C Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 1 Of Register C Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 1 Of Register C Is 1)
  BIT1CZ:
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $4A BIT   1, D             Test Bit 1 In Register D
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  andi t0,s2,$0200
  beqz t0,BIT1DZ                // IF (! (D_REG & $02)) Z Flag Set (Bit 1 Of Register D Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 1 Of Register D Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 1 Of Register D Is 1)
  BIT1DZ:
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $4B BIT   1, E             Test Bit 1 In Register E
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  andi t0,s2,$02
  beqz t0,BIT1EZ                // IF (! (E_REG & $02)) Z Flag Set (Bit 1 Of Register E Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 1 Of Register E Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 1 Of Register E Is 1)
  BIT1EZ:
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $4C BIT   1, H             Test Bit 1 In Register H
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  andi t0,s3,$0200
  beqz t0,BIT1HZ                // IF (! (H_REG & $02)) Z Flag Set (Bit 1 Of Register H Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 1 Of Register H Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 1 Of Register H Is 1)
  BIT1HZ:
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $4D BIT   1, L             Test Bit 1 In Register L
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  andi t0,s3,$02
  beqz t0,BIT1LZ                // IF (! (L_REG & $02)) Z Flag Set (Bit 1 Of Register L Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 1 Of Register L Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 1 Of Register L Is 1)
  BIT1LZ:
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $4E BIT   1, (HL)          Test Bit 1 In 8-Bit Value Of Address In Register HL
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  lbu t0,0(a2)
  andi t0,$02
  beqz t0,BIT1HLZ               // IF (! (MEM_MAP[HL_REG] & $02)) Z Flag Set (Bit 1 Of 8-Bit Value Of Address In Register HL Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 1 Of 8-Bit Value Of Address In Register HL Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 1 Of 8-Bit Value Of Address In Register HL Is 1)
  BIT1HLZ:
  jr ra
  addiu v0,3                    // QCycles += 3 (Delay Slot)

align(256)
  // $4F BIT   1, A             Test Bit 1 In Register A
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  andi t0,s0,$0200
  beqz t0,BIT1AZ                // IF (! (A_REG & $02)) Z Flag Set (Bit 1 Of Register A Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 1 Of Register A Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 1 Of Register A Is 1)
  BIT1AZ:
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $50 BIT   2, B             Test Bit 2 In Register B
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  andi t0,s1,$0400
  beqz t0,BIT2BZ                // IF (! (B_REG & $04)) Z Flag Set (Bit 2 Of Register B Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 2 Of Register B Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 2 Of Register B Is 1)
  BIT2BZ:
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $51 BIT   2, C             Test Bit 2 In Register C
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  andi t0,s1,$04
  beqz t0,BIT2CZ                // IF (! (C_REG & $04)) Z Flag Set (Bit 2 Of Register C Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 2 Of Register C Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 2 Of Register C Is 1)
  BIT2CZ:
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $52 BIT   2, D             Test Bit 2 In Register D
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  andi t0,s2,$0400
  beqz t0,BIT2DZ                // IF (! (D_REG & $04)) Z Flag Set (Bit 2 Of Register D Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 2 Of Register D Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 2 Of Register D Is 1)
  BIT2DZ:
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $53 BIT   2, E             Test Bit 2 In Register E
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  andi t0,s2,$04
  beqz t0,BIT2EZ                // IF (! (E_REG & $04)) Z Flag Set (Bit 2 Of Register E Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 2 Of Register E Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 2 Of Register E Is 1)
  BIT2EZ:
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $54 BIT   2, H             Test Bit 2 In Register H
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  andi t0,s3,$0400
  beqz t0,BIT2HZ                // IF (! (H_REG & $04)) Z Flag Set (Bit 2 Of Register H Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 2 Of Register H Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 2 Of Register H Is 1)
  BIT2HZ:
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $55 BIT   2, L             Test Bit 2 In Register L
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  andi t0,s3,$04
  beqz t0,BIT2LZ                // IF (! (L_REG & $04)) Z Flag Set (Bit 2 Of Register L Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 2 Of Register L Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 2 Of Register L Is 1)
  BIT2LZ:
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $56 BIT   2, (HL)          Test Bit 2 In 8-Bit Value Of Address In Register HL
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  lbu t0,0(a2)
  andi t0,$04
  beqz t0,BIT2HLZ               // IF (! (MEM_MAP[HL_REG] & $04)) Z Flag Set (Bit 2 Of 8-Bit Value Of Address In Register HL Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 2 Of 8-Bit Value Of Address In Register HL Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 2 Of 8-Bit Value Of Address In Register HL Is 1)
  BIT2HLZ:
  jr ra
  addiu v0,3                    // QCycles += 3 (Delay Slot)

align(256)
  // $57 BIT   2, A             Test Bit 2 In Register A
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  andi t0,s0,$0400
  beqz t0,BIT2AZ                // IF (! (A_REG & $04)) Z Flag Set (Bit 2 Of Register A Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 2 Of Register A Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 2 Of Register A Is 1)
  BIT2AZ:
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $58 BIT   3, B             Test Bit 3 In Register B
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  andi t0,s1,$0800
  beqz t0,BIT3BZ                // IF (! (B_REG & $08)) Z Flag Set (Bit 3 Of Register B Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 3 Of Register B Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 3 Of Register B Is 1)
  BIT3BZ:
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $59 BIT   3, C             Test Bit 3 In Register C
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  andi t0,s1,$08
  beqz t0,BIT3CZ                // IF (! (C_REG & $08)) Z Flag Set (Bit 3 Of Register C Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 3 Of Register C Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 3 Of Register C Is 1)
  BIT3CZ:
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $5A BIT   3, D             Test Bit 3 In Register D
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  andi t0,s2,$0800
  beqz t0,BIT3DZ                // IF (! (D_REG & $08)) Z Flag Set (Bit 3 Of Register D Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 3 Of Register D Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 3 Of Register D Is 1)
  BIT3DZ:
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $5B BIT   3, E             Test Bit 3 In Register E
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  andi t0,s2,$08
  beqz t0,BIT3EZ                // IF (! (E_REG & $08)) Z Flag Set (Bit 3 Of Register E Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 3 Of Register E Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 3 Of Register E Is 1)
  BIT3EZ:
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $5C BIT   3, H             Test Bit 3 In Register H
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  andi t0,s3,$0800
  beqz t0,BIT3HZ                // IF (! (H_REG & $08)) Z Flag Set (Bit 3 Of Register H Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 3 Of Register H Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 3 Of Register H Is 1)
  BIT3HZ:
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $5D BIT   3, L             Test Bit 3 In Register L
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  andi t0,s3,$08
  beqz t0,BIT3LZ                // IF (! (L_REG & $08)) Z Flag Set (Bit 3 Of Register L Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 3 Of Register L Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 3 Of Register L Is 1)
  BIT3LZ:
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $5E BIT   3, (HL)          Test Bit 3 In 8-Bit Value Of Address In Register HL
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  lbu t0,0(a2)
  andi t0,$08
  beqz t0,BIT3HLZ               // IF (! (MEM_MAP[HL_REG] & $08)) Z Flag Set (Bit 3 Of 8-Bit Value Of Address In Register HL Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 3 Of 8-Bit Value Of Address In Register HL Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 3 Of 8-Bit Value Of Address In Register HL Is 1)
  BIT3HLZ:
  jr ra
  addiu v0,3                    // QCycles += 3 (Delay Slot)

align(256)
  // $5F BIT   3, A             Test Bit 3 In Register A
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  andi t0,s0,$0800
  beqz t0,BIT3AZ                // IF (! (A_REG & $08)) Z Flag Set (Bit 3 Of Register A Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 3 Of Register A Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 3 Of Register A Is 1)
  BIT3AZ:
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $60 BIT   4, B             Test Bit 4 In Register B
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  andi t0,s1,$1000
  beqz t0,BIT4BZ                // IF (! (B_REG & $10)) Z Flag Set (Bit 4 Of Register B Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 4 Of Register B Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 4 Of Register B Is 1)
  BIT4BZ:
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $61 BIT   4, C             Test Bit 4 In Register C
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  andi t0,s1,$10
  beqz t0,BIT4CZ                // IF (! (C_REG & $10)) Z Flag Set (Bit 4 Of Register C Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 4 Of Register C Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 4 Of Register C Is 1)
  BIT4CZ:
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $62 BIT   4, D             Test Bit 4 In Register D
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  andi t0,s2,$1000
  beqz t0,BIT4DZ                // IF (! (D_REG & $10)) Z Flag Set (Bit 4 Of Register D Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 4 Of Register D Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 4 Of Register D Is 1)
  BIT4DZ:
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $63 BIT   4, E             Test Bit 4 In Register E
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  andi t0,s2,$10
  beqz t0,BIT4EZ                // IF (! (E_REG & $10)) Z Flag Set (Bit 4 Of Register E Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 4 Of Register E Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 4 Of Register E Is 1)
  BIT4EZ:
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $64 BIT   4, H             Test Bit 4 In Register H
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  andi t0,s3,$1000
  beqz t0,BIT4HZ                // IF (! (H_REG & $10)) Z Flag Set (Bit 4 Of Register H Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 4 Of Register H Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 4 Of Register H Is 1)
  BIT4HZ:
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $65 BIT   4, L             Test Bit 4 In Register L
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  andi t0,s3,$10
  beqz t0,BIT4LZ                // IF (! (L_REG & $10)) Z Flag Set (Bit 4 Of Register L Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 4 Of Register L Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 4 Of Register L Is 1)
  BIT4LZ:
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $66 BIT   4, (HL)          Test Bit 4 In 8-Bit Value Of Address In Register HL
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  lbu t0,0(a2)
  andi t0,$10
  beqz t0,BIT4HLZ               // IF (! (MEM_MAP[HL_REG] & $10)) Z Flag Set (Bit 4 Of 8-Bit Value Of Address In Register HL Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 4 Of 8-Bit Value Of Address In Register HL Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 4 Of 8-Bit Value Of Address In Register HL Is 1)
  BIT4HLZ:
  jr ra
  addiu v0,3                    // QCycles += 3 (Delay Slot)

align(256)
  // $67 BIT   4, A             Test Bit 4 In Register A
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  andi t0,s0,$1000
  beqz t0,BIT4AZ                // IF (! (A_REG & $10)) Z Flag Set (Bit 4 Of Register A Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 4 Of Register A Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 4 Of Register A Is 1)
  BIT4AZ:
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $68 BIT   5, B             Test Bit 5 In Register B
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  andi t0,s1,$2000
  beqz t0,BIT5BZ                // IF (! (B_REG & $20)) Z Flag Set (Bit 5 Of Register B Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 5 Of Register B Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 5 Of Register B Is 1)
  BIT5BZ:
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $69 BIT   5, C             Test Bit 5 In Register C
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  andi t0,s1,$20
  beqz t0,BIT5CZ                // IF (! (C_REG & $20)) Z Flag Set (Bit 5 Of Register C Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 5 Of Register C Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 5 Of Register C Is 1)
  BIT5CZ:
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $6A BIT   5, D             Test Bit 5 In Register D
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  andi t0,s2,$2000
  beqz t0,BIT5DZ                // IF (! (D_REG & $20)) Z Flag Set (Bit 5 Of Register D Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 5 Of Register D Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 5 Of Register D Is 1)
  BIT5DZ:
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $6B BIT   5, E             Test Bit 5 In Register E
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  andi t0,s2,$20
  beqz t0,BIT5EZ                // IF (! (E_REG & $20)) Z Flag Set (Bit 5 Of Register E Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 5 Of Register E Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 5 Of Register E Is 1)
  BIT5EZ:
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $6C BIT   5, H             Test Bit 5 In Register H
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  andi t0,s3,$2000
  beqz t0,BIT5HZ                // IF (! (H_REG & $20)) Z Flag Set (Bit 5 Of Register H Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 5 Of Register H Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 5 Of Register H Is 1)
  BIT5HZ:
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $6D BIT   5, L             Test Bit 5 In Register L
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  andi t0,s3,$20
  beqz t0,BIT5LZ                // IF (! (L_REG & $20)) Z Flag Set (Bit 5 Of Register L Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 5 Of Register L Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 5 Of Register L Is 1)
  BIT5LZ:
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $6E BIT   5, (HL)          Test Bit 5 In 8-Bit Value Of Address In Register HL
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  lbu t0,0(a2)
  andi t0,$20
  beqz t0,BIT5HLZ               // IF (! (MEM_MAP[HL_REG] & $20)) Z Flag Set (Bit 5 Of 8-Bit Value Of Address In Register HL Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 5 Of 8-Bit Value Of Address In Register HL Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 5 Of 8-Bit Value Of Address In Register HL Is 1)
  BIT5HLZ:
  jr ra
  addiu v0,3                    // QCycles += 3 (Delay Slot)

align(256)
  // $6F BIT   5, A             Test Bit 5 In Register A
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  andi t0,s0,$2000
  beqz t0,BIT5AZ                // IF (! (A_REG & $20)) Z Flag Set (Bit 5 Of Register A Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 5 Of Register A Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 5 Of Register A Is 1)
  BIT5AZ:
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $70 BIT   6, B             Test Bit 6 In Register B
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  andi t0,s1,$4000
  beqz t0,BIT6BZ                // IF (! (B_REG & $40)) Z Flag Set (Bit 6 Of Register B Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 6 Of Register B Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 6 Of Register B Is 1)
  BIT6BZ:
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $71 BIT   6, C             Test Bit 6 In Register C
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  andi t0,s1,$40
  beqz t0,BIT6CZ                // IF (! (C_REG & $40)) Z Flag Set (Bit 6 Of Register C Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 6 Of Register C Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 6 Of Register C Is 1)
  BIT6CZ:
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $72 BIT   6, D             Test Bit 6 In Register D
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  andi t0,s2,$4000
  beqz t0,BIT6DZ                // IF (! (D_REG & $40)) Z Flag Set (Bit 6 Of Register D Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 6 Of Register D Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 6 Of Register D Is 1)
  BIT6DZ:
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $73 BIT   6, E             Test Bit 6 In Register E
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  andi t0,s2,$40
  beqz t0,BIT6EZ                // IF (! (E_REG & $40)) Z Flag Set (Bit 6 Of Register E Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 6 Of Register E Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 6 Of Register E Is 1)
  BIT6EZ:
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $74 BIT   6, H             Test Bit 6 In Register H
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  andi t0,s3,$4000
  beqz t0,BIT6HZ                // IF (! (H_REG & $40)) Z Flag Set (Bit 6 Of Register H Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 6 Of Register H Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 6 Of Register H Is 1)
  BIT6HZ:
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $75 BIT   6, L             Test Bit 6 In Register L
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  andi t0,s3,$40
  beqz t0,BIT6LZ                // IF (! (L_REG & $40)) Z Flag Set (Bit 6 Of Register L Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 6 Of Register L Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 6 Of Register L Is 1)
  BIT6LZ:
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $76 BIT   6, (HL)          Test Bit 6 In 8-Bit Value Of Address In Register HL
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  lbu t0,0(a2)
  andi t0,$40
  beqz t0,BIT6HLZ               // IF (! (MEM_MAP[HL_REG] & $40)) Z Flag Set (Bit 6 Of 8-Bit Value Of Address In Register HL Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 6 Of 8-Bit Value Of Address In Register HL Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 6 Of 8-Bit Value Of Address In Register HL Is 1)
  BIT6HLZ:
  jr ra
  addiu v0,3                    // QCycles += 3 (Delay Slot)

align(256)
  // $77 BIT   6, A             Test Bit 6 In Register A
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  andi t0,s0,$4000
  beqz t0,BIT6AZ                // IF (! (A_REG & $40)) Z Flag Set (Bit 6 Of Register A Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 6 Of Register A Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 6 Of Register A Is 1)
  BIT6AZ:
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $78 BIT   7, B             Test Bit 7 In Register B
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  andi t0,s1,$8000
  beqz t0,BIT7BZ                // IF (! (B_REG & $80)) Z Flag Set (Bit 7 Of Register B Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 7 Of Register B Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 7 Of Register B Is 1)
  BIT7BZ:
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $79 BIT   7, C             Test Bit 7 In Register C
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  andi t0,s1,$80
  beqz t0,BIT7CZ                // IF (! (C_REG & $80)) Z Flag Set (Bit 7 Of Register C Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 7 Of Register C Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 7 Of Register C Is 1)
  BIT7CZ:
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $7A BIT   7, D             Test Bit 7 In Register D
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  andi t0,s2,$8000
  beqz t0,BIT7DZ                // IF (! (D_REG & $80)) Z Flag Set (Bit 7 Of Register D Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 7 Of Register D Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 7 Of Register D Is 1)
  BIT7DZ:
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $7B BIT   7, E             Test Bit 7 In Register E
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  andi t0,s2,$80
  beqz t0,BIT7EZ                // IF (! (E_REG & $80)) Z Flag Set (Bit 7 Of Register E Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 7 Of Register E Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 7 Of Register E Is 1)
  BIT7EZ:
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $7C BIT   7, H             Test Bit 7 In Register H
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  andi t0,s3,$8000
  beqz t0,BIT7HZ                // IF (! (H_REG & $80)) Z Flag Set (Bit 7 Of Register H Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 7 Of Register H Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 7 Of Register H Is 1)
  BIT7HZ:
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $7D BIT   7, L             Test Bit 7 In Register L
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  andi t0,s3,$80
  beqz t0,BIT7LZ                // IF (! (L_REG & $80)) Z Flag Set (Bit 7 Of Register L Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 7 Of Register L Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 7 Of Register L Is 1)
  BIT7LZ:
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $7E BIT   7, (HL)          Test Bit 7 In 8-Bit Value Of Address In Register HL
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  lbu t0,0(a2)
  andi t0,$80
  beqz t0,BIT7HLZ               // IF (! (MEM_MAP[HL_REG] & $80)) Z Flag Set (Bit 7 Of 8-Bit Value Of Address In Register HL Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 7 Of 8-Bit Value Of Address In Register HL Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 7 Of 8-Bit Value Of Address In Register HL Is 1)
  BIT7HLZ:
  jr ra
  addiu v0,3                    // QCycles += 3 (Delay Slot)

align(256)
  // $7F BIT   7, A             Test Bit 7 In Register A
  ori s0,H_FLAG                 // H Flag Set
  andi s0,~N_FLAG               // N Flag Reset
  andi t0,s0,$8000
  beqz t0,BIT7AZ                // IF (! (A_REG & $80)) Z Flag Set (Bit 7 Of Register A Is 0)
  ori s0,Z_FLAG                 // F_REG: Z Flag Set (Bit 7 Of Register A Is 0) (Delay Slot)
  andi s0,~Z_FLAG               // F_REG: Z Flag Reset (Bit 7 Of Register A Is 1)
  BIT7AZ:
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $80 RES   0, B             Reset Bit 0 In Register B
  andi s1,~$0100                // B_REG &= $FE
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $81 RES   0, C             Reset Bit 0 In Register C
  andi s1,~$01                  // C_REG &= $FE
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $82 RES   0, D             Reset Bit 0 In Register D
  andi s2,~$0100                // D_REG &= $FE
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $83 RES   0, E             Reset Bit 0 In Register E
  andi s2,~$01                  // E_REG &= $FE
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $84 RES   0, H             Reset Bit 0 In Register H
  andi s3,~$0100                // H_REG &= $FE
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $85 RES   0, L             Reset Bit 0 In Register L
  andi s3,~$01                  // L_REG &= $FE
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $86 RES   0, (HL)          Reset Bit 0 In 8-Bit Value Of Address In Register HL
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  lbu t0,0(a2)
  andi t0,~$01                  // MEM_MAP[HL_REG] &= $FE
  sb t0,0(a2)
  jr ra
  addiu v0,4                    // QCycles += 4 (Delay Slot)

align(256)
  // $87 RES   0, A             Reset Bit 0 In Register A
  andi s0,~$0100                // A_REG &= $FE
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $88 RES   1, B             Reset Bit 1 In Register B
  andi s1,~$0200                // B_REG &= $FD
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $89 RES   1, C             Reset Bit 1 In Register C
  andi s1,~$02                  // C_REG &= $FD
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $8A RES   1, D             Reset Bit 1 In Register D
  andi s2,~$0200                // D_REG &= $FD
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $8B RES   1, E             Reset Bit 1 In Register E
  andi s2,~$02                  // E_REG &= $FD
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $8C RES   1, H             Reset Bit 1 In Register H
  andi s3,~$0200                // H_REG &= $FD
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $8D RES   1, L             Reset Bit 1 In Register L
  andi s3,~$02                  // L_REG &= $FD
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $8E RES   1, (HL)          Reset Bit 1 In 8-Bit Value Of Address In Register HL
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  lbu t0,0(a2)
  andi t0,~$02                  // MEM_MAP[HL_REG] &= $FD
  sb t0,0(a2)
  jr ra
  addiu v0,4                    // QCycles += 4 (Delay Slot)

align(256)
  // $8F RES   1, A             Reset Bit 1 In Register A
  andi s0,~$0200                // A_REG &= $FD
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $90 RES   2, B             Reset Bit 2 In Register B
  andi s1,~$0400                // B_REG &= $FB
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $91 RES   2, C             Reset Bit 2 In Register C
  andi s1,~$04                  // C_REG &= $FB
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $92 RES   2, D             Reset Bit 2 In Register D
  andi s2,~$0400                // D_REG &= $FB
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $93 RES   2, E             Reset Bit 2 In Register E
  andi s2,~$04                  // E_REG &= $FB
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $94 RES   2, H             Reset Bit 2 In Register H
  andi s3,~$0400                // H_REG &= $FB
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $95 RES   2, L             Reset Bit 2 In Register L
  andi s3,~$04                  // L_REG &= $FB
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $96 RES   2, (HL)          Reset Bit 2 In 8-Bit Value Of Address In Register HL
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  lbu t0,0(a2)
  andi t0,~$04                  // MEM_MAP[HL_REG] &= $FB
  sb t0,0(a2)
  jr ra
  addiu v0,4                    // QCycles += 4 (Delay Slot)

align(256)
  // $97 RES   2, A             Reset Bit 2 In Register A
  andi s0,~$0400                // A_REG &= $FB
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $98 RES   3, B             Reset Bit 3 In Register B
  andi s1,~$0800                // B_REG &= $F7
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $99 RES   3, C             Reset Bit 3 In Register C
  andi s1,~$08                  // C_REG &= $F7
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $9A RES   3, D             Reset Bit 3 In Register D
  andi s2,~$0800                // D_REG &= $F7
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $9B RES   3, E             Reset Bit 3 In Register E
  andi s2,~$08                  // E_REG &= $F7
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $9C RES   3, H             Reset Bit 3 In Register H
  andi s3,~$0800                // H_REG &= $F7
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $9D RES   3, L             Reset Bit 3 In Register L
  andi s3,~$08                  // L_REG &= $F7
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $9E RES   3, (HL)          Reset Bit 3 In 8-Bit Value Of Address In Register HL
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  lbu t0,0(a2)
  andi t0,~$08                  // MEM_MAP[HL_REG] &= $F7
  sb t0,0(a2)
  jr ra
  addiu v0,4                    // QCycles += 4 (Delay Slot)

align(256)
  // $9F RES   3, A             Reset Bit 3 In Register A
  andi s0,~$0800                // A_REG &= $F7
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $A0 RES   4, B             Reset Bit 4 In Register B
  andi s1,~$1000                // B_REG &= $EF
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $A1 RES   4, C             Reset Bit 4 In Register C
  andi s1,~$10                  // C_REG &= $EF
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $A2 RES   4, D             Reset Bit 4 In Register D
  andi s2,~$1000                // D_REG &= $EF
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $A3 RES   4, E             Reset Bit 4 In Register E
  andi s2,~$10                  // E_REG &= $EF
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $A4 RES   4, H             Reset Bit 4 In Register H
  andi s3,~$1000                // H_REG &= $EF
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $A5 RES   4, L             Reset Bit 4 In Register L
  andi s3,~$10                  // L_REG &= $EF
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $A6 RES   4, (HL)          Reset Bit 4 In 8-Bit Value Of Address In Register HL
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  lbu t0,0(a2)
  andi t0,~$10                  // MEM_MAP[HL_REG] &= $EF
  sb t0,0(a2)
  jr ra
  addiu v0,4                    // QCycles += 4 (Delay Slot)

align(256)
  // $A7 RES   4, A             Reset Bit 4 In Register A
  andi s0,~$1000                // A_REG &= $EF
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $A8 RES   5, B             Reset Bit 5 In Register B
  andi s1,~$2000                // B_REG &= $DF
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $A9 RES   5, C             Reset Bit 5 In Register C
  andi s1,~$20                  // C_REG &= $DF
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $AA RES   5, D             Reset Bit 5 In Register D
  andi s2,~$2000                // D_REG &= $DF
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $AB RES   5, E             Reset Bit 5 In Register E
  andi s2,~$20                  // E_REG &= $DF
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $AC RES   5, H             Reset Bit 5 In Register H
  andi s3,~$2000                // H_REG &= $DF
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $AD RES   5, L             Reset Bit 5 In Register L
  andi s3,~$20                  // L_REG &= $DF
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $AE RES   5, (HL)          Reset Bit 5 In 8-Bit Value Of Address In Register HL
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  lbu t0,0(a2)
  andi t0,~$20                  // MEM_MAP[HL_REG] &= $DF
  sb t0,0(a2)
  jr ra
  addiu v0,4                    // QCycles += 4 (Delay Slot)

align(256)
  // $AF RES   5, A             Reset Bit 5 In Register A
  andi s0,~$2000                // A_REG &= $DF
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $B0 RES   6, B             Reset Bit 6 In Register B
  andi s1,~$4000                // B_REG &= $BF
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $B1 RES   6, C             Reset Bit 6 In Register C
  andi s1,~$40                  // C_REG &= $BF
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $B2 RES   6, D             Reset Bit 6 In Register D
  andi s2,~$4000                // D_REG &= $BF
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $B3 RES   6, E             Reset Bit 6 In Register E
  andi s2,~$40                  // E_REG &= $BF
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $B4 RES   6, H             Reset Bit 6 In Register H
  andi s3,~$4000                // H_REG &= $BF
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $B5 RES   6, L             Reset Bit 6 In Register L
  andi s3,~$40                  // L_REG &= $BF
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $B6 RES   6, (HL)          Reset Bit 6 In 8-Bit Value Of Address In Register HL
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  lbu t0,0(a2)
  andi t0,~$40                  // MEM_MAP[HL_REG] &= $BF
  sb t0,0(a2)
  jr ra
  addiu v0,4                    // QCycles += 4 (Delay Slot)

align(256)
  // $B7 RES   6, A             Reset Bit 6 In Register A
  andi s0,~$4000                // A_REG &= $BF
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $B8 RES   7, B             Reset Bit 7 In Register B
  andi s1,~$8000                // B_REG &= $7F
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $B9 RES   7, C             Reset Bit 7 In Register C
  andi s1,~$80                  // C_REG &= $7F
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $BA RES   7, D             Reset Bit 7 In Register D
  andi s2,~$8000                // D_REG &= $7F
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $BB RES   7, E             Reset Bit 7 In Register E
  andi s2,~$80                  // E_REG &= $7F
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $BC RES   7, H             Reset Bit 7 In Register H
  andi s3,~$8000                // H_REG &= $7F
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $BD RES   7, L             Reset Bit 7 In Register L
  andi s3,~$80                  // L_REG &= $7F
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $BE RES   7, (HL)          Reset Bit 7 In 8-Bit Value Of Address In Register HL
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  lbu t0,0(a2)
  andi t0,~$80                  // MEM_MAP[HL_REG] &= $7F
  sb t0,0(a2)
  jr ra
  addiu v0,4                    // QCycles += 4 (Delay Slot)

align(256)
  // $BF RES   7, A             Reset Bit 7 In Register A
  andi s0,~$8000                // A_REG &= $7F
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $C0 SET   0, B             Set Bit 0 In Register B
  ori s1,$0100                  // B_REG |= $01
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $C1 SET   0, C             Set Bit 0 In Register C
  ori s1,$01                    // C_REG |= $01
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $C2 SET   0, D             Set Bit 0 In Register D
  ori s2,$0100                  // D_REG |= $01
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $C3 SET   0, E             Set Bit 0 In Register E
  ori s2,$01                    // E_REG |= $01
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $C4 SET   0, H             Set Bit 0 In Register H
  ori s3,$0100                  // H_REG |= $01
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $C5 SET   0, L             Set Bit 0 In Register L
  ori s3,$01                    // L_REG |= $01
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $C6 SET   0, (HL)          Set Bit 0 In 8-Bit Value Of Address In Register HL
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  lbu t0,0(a2)
  ori t0,$01                    // MEM_MAP[HL_REG] |= $01
  sb t0,0(a2)
  jr ra
  addiu v0,4                    // QCycles += 4 (Delay Slot)

align(256)
  // $C7 SET   0, A             Set Bit 0 In Register A
  ori s0,$0100                  // A_REG |= $01
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $C8 SET   1, B             Set Bit 1 In Register B
  ori s1,$0200                  // B_REG |= $02
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $C9 SET   1, C             Set Bit 1 In Register C
  ori s1,$02                    // C_REG |= $02
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $CA SET   1, D             Set Bit 1 In Register D
  ori s2,$0200                  // D_REG |= $02
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $CB SET   1, E             Set Bit 1 In Register E
  ori s2,$02                    // E_REG |= $02
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $CC SET   1, H             Set Bit 1 In Register H
  ori s3,$0200                  // H_REG |= $02
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $CD SET   1, L             Set Bit 1 In Register L
  ori s3,$02                    // L_REG |= $02
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $CE SET   1, (HL)          Set Bit 1 In 8-Bit Value Of Address In Register HL
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  lbu t0,0(a2)
  ori t0,$02                    // MEM_MAP[HL_REG] |= $02
  sb t0,0(a2)
  jr ra
  addiu v0,4                    // QCycles += 4 (Delay Slot)

align(256)
  // $CF SET   1, A             Set Bit 1 In Register A
  ori s0,$0200                  // A_REG |= $02
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $D0 SET   2, B             Set Bit 2 In Register B
  ori s1,$0400                  // B_REG |= $04
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $D1 SET   2, C             Set Bit 2 In Register C
  ori s1,$04                    // C_REG |= $04
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $D2 SET   2, D             Set Bit 2 In Register D
  ori s2,$0400                  // D_REG |= $04
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $D3 SET   2, E             Set Bit 2 In Register E
  ori s2,$04                    // E_REG |= $04
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $D4 SET   2, H             Set Bit 2 In Register H
  ori s3,$0400                  // H_REG |= $04
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $D5 SET   2, L             Set Bit 2 In Register L
  ori s3,$04                    // L_REG |= $04
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $D6 SET   2, (HL)          Set Bit 2 In 8-Bit Value Of Address In Register HL
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  lbu t0,0(a2)
  ori t0,$04                    // MEM_MAP[HL_REG] |= $04
  sb t0,0(a2)
  jr ra
  addiu v0,4                    // QCycles += 4 (Delay Slot)

align(256)
  // $D7 SET   2, A             Set Bit 2 In Register A
  ori s0,$0400                  // A_REG |= $04
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $D8 SET   3, B             Set Bit 3 In Register B
  ori s1,$0800                  // B_REG |= $08
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $D9 SET   3, C             Set Bit 3 In Register C
  ori s1,$08                    // C_REG |= $08
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $DA SET   3, D             Set Bit 3 In Register D
  ori s2,$0800                  // D_REG |= $08
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $DB SET   3, E             Set Bit 3 In Register E
  ori s2,$08                    // E_REG |= $08
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $DC SET   3, H             Set Bit 3 In Register H
  ori s3,$0800                  // H_REG |= $08
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $DD SET   3, L             Set Bit 3 In Register L
  ori s3,$08                    // L_REG |= $08
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $DE SET   3, (HL)          Set Bit 3 In 8-Bit Value Of Address In Register HL
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  lbu t0,0(a2)
  ori t0,$08                    // MEM_MAP[HL_REG] |= $08
  sb t0,0(a2)
  jr ra
  addiu v0,4                    // QCycles += 4 (Delay Slot)

align(256)
  // $DF SET   3, A             Set Bit 3 In Register A
  ori s0,$0800                  // A_REG |= $08
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $E0 SET   4, B             Set Bit 4 In Register B
  ori s1,$1000                  // B_REG |= $10
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $E1 SET   4, C             Set Bit 4 In Register C
  ori s1,$10                    // C_REG |= $10
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $E2 SET   4, D             Set Bit 4 In Register D
  ori s2,$1000                  // D_REG |= $10
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $E3 SET   4, E             Set Bit 4 In Register E
  ori s2,$10                    // E_REG |= $10
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $E4 SET   4, H             Set Bit 4 In Register H
  ori s3,$1000                  // H_REG |= $10
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $E5 SET   4, L             Set Bit 4 In Register L
  ori s3,$10                    // L_REG |= $10
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $E6 SET   4, (HL)          Set Bit 4 In 8-Bit Value Of Address In Register HL
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  lbu t0,0(a2)
  ori t0,$10                    // MEM_MAP[HL_REG] |= $10
  sb t0,0(a2)
  jr ra
  addiu v0,4                    // QCycles += 4 (Delay Slot)

align(256)
  // $E7 SET   4, A             Set Bit 4 In Register A
  ori s0,$1000                  // A_REG |= $10
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $E8 SET   5, B             Set Bit 5 In Register B
  ori s1,$2000                  // B_REG |= $20
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $E9 SET   5, C             Set Bit 5 In Register C
  ori s1,$20                    // C_REG |= $20
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $EA SET   5, D             Set Bit 5 In Register D
  ori s2,$2000                  // D_REG |= $20
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $EB SET   5, E             Set Bit 5 In Register E
  ori s2,$20                    // E_REG |= $20
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $EC SET   5, H             Set Bit 5 In Register H
  ori s3,$2000                  // H_REG |= $20
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $ED SET   5, L             Set Bit 5 In Register L
  ori s3,$20                    // L_REG |= $20
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $EE SET   5, (HL)          Set Bit 5 In 8-Bit Value Of Address In Register HL
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  lbu t0,0(a2)
  ori t0,$20                    // MEM_MAP[HL_REG] |= $20
  sb t0,0(a2)
  jr ra
  addiu v0,4                    // QCycles += 4 (Delay Slot)

align(256)
  // $EF SET   5, A             Set Bit 5 In Register A
  ori s0,$2000                  // A_REG |= $20
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $F0 SET   6, B             Set Bit 6 In Register B
  ori s1,$4000                  // B_REG |= $40
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $F1 SET   6, C             Set Bit 6 In Register C
  ori s1,$40                    // C_REG |= $40
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $F2 SET   6, D             Set Bit 6 In Register D
  ori s2,$4000                  // D_REG |= $40
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $F3 SET   6, E             Set Bit 6 In Register E
  ori s2,$40                    // E_REG |= $40
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $F4 SET   6, H             Set Bit 6 In Register H
  ori s3,$4000                  // H_REG |= $40
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $F5 SET   6, L             Set Bit 6 In Register L
  ori s3,$40                    // L_REG |= $40
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $F6 SET   6, (HL)          Set Bit 6 In 8-Bit Value Of Address In Register HL
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  lbu t0,0(a2)
  ori t0,$40                    // MEM_MAP[HL_REG] |= $40
  sb t0,0(a2)
  jr ra
  addiu v0,4                    // QCycles += 4 (Delay Slot)

align(256)
  // $F7 SET   6, A             Set Bit 6 In Register A
  ori s0,$4000                  // A_REG |= $40
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $F8 SET   7, B             Set Bit 7 In Register B
  ori s1,$8000                  // B_REG |= $80
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $F9 SET   7, C             Set Bit 7 In Register C
  ori s1,$80                    // C_REG |= $80
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $FA SET   7, D             Set Bit 7 In Register D
  ori s2,$8000                  // D_REG |= $80
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $FB SET   7, E             Set Bit 7 In Register E
  ori s2,$80                    // E_REG |= $80
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $FC SET   7, H             Set Bit 7 In Register H
  ori s3,$8000                  // H_REG |= $80
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $FD SET   7, L             Set Bit 7 In Register L
  ori s3,$80                    // L_REG |= $80
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)

align(256)
  // $FE SET   7, (HL)          Set Bit 7 In 8-Bit Value Of Address In Register HL
  addu a2,a0,s3                 // A2 = MEM_MAP + HL_REG
  lbu t0,0(a2)
  ori t0,$80                    // MEM_MAP[HL_REG] |= $80
  sb t0,0(a2)
  jr ra
  addiu v0,4                    // QCycles += 4 (Delay Slot)

align(256)
  // $FF SET   7, A             Set Bit 7 In Register A
  ori s0,$8000                  // A_REG |= $80
  jr ra
  addiu v0,2                    // QCycles += 2 (Delay Slot)