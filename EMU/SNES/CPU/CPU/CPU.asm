//-----------------------
// CPU Block Move Macros
//-----------------------
macro BlockMVN() { // Block Move Next (C = Count, X = Source, Y = Destination)
  lbu t0,1(a2)     // T0 = SRCBANK (8-Bit)
  sll t0,16        // T0 <<= 8
  lbu s7,2(a2)     // DB_REG = DSTBANK (8-Bit)
  sll t1,s7,16     // T1 = DB_REG << 8

  or t0,s1         // T0 = SRCBANK:X
  addu a2,a0,t0    // A2 = MEM_MAP + SRCBANK:X
  or t1,s2         // T1 = DSTBANK:Y
  addu a3,a0,t1    // A3 = MEM_MAP + DSTBANK:Y

  addu s1,s0    // X_REG += A_REG
  addiu s1,1    // X_REG++
  andi s1,$FFFF // X_REG = 16-Bit
  addu s2,s0    // Y_REG += A_REG
  addiu s2,1    // Y_REG++
  andi s2,$FFFF // Y_REG = 16-Bit

  {#}MVNCopy:
    lbu t0,0(a2) // Copy 1 Byte From MEM_MAP[SRCBANK:X] To MEM_MAP[DSTBANK:Y]
    addiu a2,1   // SRC++ (Increment Source)
    sb t0,0(a3)  // DST = SRC
    addiu a3,1   // DST++ (Increment Destination)
    bnez s0,{#}MVNCopy
    subiu s0,1   // A_REG-- (Decrement Count) (Delay Slot)
}

macro BlockMVP() { // Block Move Previous (C = Count, X = Source, Y = Destination)
  lbu t0,1(a2)     // T0 = SRCBANK (8-Bit)
  sll t0,16        // T0 <<= 8
  lbu s7,2(a2)     // DB_REG = DSTBANK (8-Bit)
  sll t1,s7,16     // T1 = DB_REG << 8

  or t0,s1         // T0 = SRCBANK:X
  addu a2,a0,t0    // A2 = MEM_MAP + SRCBANK:X
  or t1,s2         // T1 = DSTBANK:Y
  addu a3,a0,t1    // A3 = MEM_MAP + DSTBANK:Y

  subu s1,s0    // X_REG -= A_REG
  subiu s1,1    // X_REG--
  andi s1,$FFFF // X_REG = 16-Bit
  subu s2,s0    // Y_REG -= A_REG
  subiu s2,1    // Y_REG--
  andi s2,$FFFF // Y_REG = 16-Bit

  {#}MVPCopy:
    lbu t0,0(a2) // Copy 1 Byte From MEM_MAP[SRCBANK:X] To MEM_MAP[DSTBANK:Y]
    subiu a2,1   // SRC-- (Decrement Source)
    sb t0,0(a3)  // DST = SRC
    subiu a3,1   // DST-- (Decrement Destination)
    bnez s0,{#}MVPCopy
    subiu s0,1   // A_REG-- (Decrement Count) (Delay Slot)
}

//-------------------
// CPU Branch Macros
//-------------------
macro Branch8() { // Branch Always 8-Bit
  addiu s3,1      // PC_REG++ (Increment Program Counter)
  addu a2,a0,s3   // A2 = Signed 8-Bit Relative Address
  lb t0,-1(a2)    // T0 = Signed 8-Bit Relative Offset
  add s3,t0       // PC_REG += Signed 8-Bit Relative Offset
}

macro Branch16() { // Branch Always Long 16-Bit
  addiu s3,2       // PC_REG += 2 (Increment Program Counter)
  addu a2,a0,s3    // A2 = Signed 16-Bit Relative Address
  lb t0,-1(a2)     // T0 = Signed 16-Bit Relative Offset HI Byte
  sll t0,8         // T0 <<= 8
  lbu t1,-2(a2)    // T1 = Signed 16-Bit Relative Offset LO Byte
  or t0,t1         // T0 = Signed 16-Bit Relative Offset
  add s3,t0        // PC_REG += Signed 16-Bit Relative Offset
}

macro BranchCLR(flag) { // Branch IF Flag Clear
  andi t0,s5,{flag}     // P_REG: Test Flag
  bnez t0,{#}BRACLR     // IF (Flag != 0) Flag Set
  addiu s3,1            // PC_REG++ (Increment Program Counter) (Delay Slot)
  addu a2,a0,s3         // A2 = Signed 8-Bit Relative Address
  lb t0,-1(a2)          // T0 = Signed 8-Bit Relative Offset
  add s3,t0             // PC_REG += Signed 8-Bit Relative Offset
  addiu v0,1            // Cycles++
  {#}BRACLR:
}

macro BranchSET(flag) { // Branch IF Flag Set
  andi t0,s5,{flag}     // P_REG: Test Flag
  beqz t0,{#}BRASET     // IF (Flag == 0) Flag Clear
  addiu s3,1            // PC_REG++ (Increment Program Counter) (Delay Slot)
  addu a2,a0,s3         // A2 = Signed 8-Bit Relative Address
  lb t0,-1(a2)          // T0 = Signed 8-Bit Relative Offset
  add s3,t0             // PC_REG += Signed 8-Bit Relative Offset
  addiu v0,1            // Cycles++
  {#}BRASET:
}

//------------------------
// CPU Memory Load Macros
//------------------------
macro LoadIMM8(reg) { // Load 8-Bit Immediate Memory To Register
  lbu {reg},1(a2)     // Register = Immediate (8-Bit)
}

macro LoadIMM16(reg) { // Load 16-Bit Immediate Memory To Register
  lbu {reg},2(a2)      // Register = Immediate HI Byte
  sll {reg},8          // Register <<= 8
  lbu t1,1(a2)         // T1 = Immediate LO Byte
  or {reg},t1          // Register = Immediate (16-Bit)
}

macro LoadABS8(reg) { // Load 8-Bit Absolute Memory To Register
  lbu t0,2(a2)        // Absolute = MEM_MAP[DB_REG:Immediate]
  sll t0,8            // T0 = Immediate HI Byte
  lbu t1,1(a2)        // T1 = Immediate LO Byte
  or t0,t1            // T0 = Immediate (16-Bit)
  sll t1,s7,16        // T1 = DB_REG << 16 
  or t0,t1            // T0 = DB_REG:Immediate
  addu a2,a0,t0       // A2 = MEM_MAP + DB_REG:Immediate

  la sp,LoadByte      // Load Byte
  jalr sp,sp

  lbu {reg},0(a2)     // Register = Absolute (8-Bit)
}

macro LoadABS16(reg) { // Load 16-Bit Absolute Memory To Register
  lbu t0,2(a2)         // Absolute = MEM_MAP[DB_REG:Immediate]
  sll t0,8             // T0 = Immediate HI Byte
  lbu t1,1(a2)         // T1 = Immediate LO Byte
  or t0,t1             // T0 = Immediate (16-Bit)
  sll t1,s7,16         // T1 = DB_REG << 16 
  or t0,t1             // T0 = DB_REG:Immediate
  addu a2,a0,t0        // A2 = MEM_MAP + DB_REG:Immediate

  la sp,LoadWord       // Load Word
  jalr sp,sp

  lbu {reg},1(a2)      // Register = Absolute HI Byte
  sll {reg},8          // Register <<= 8
  lbu t1,0(a2)         // T1 = Absolute LO Byte
  or {reg},t1          // Register = Absolute (16-Bit)
}

macro LoadABSL8(reg) { // Load 8-Bit Absolute Long Memory To Register
  lbu t0,3(a2)         // Absolute Long = MEM_MAP[Immediate]
  sll t0,16            // T0 = Immediate HI Byte
  lbu t1,2(a2)         // T1 = Immediate MID Byte
  sll t1,8             // T1 <<= 8
  or t0,t1             // T0 = Immediate HI | MID Byte
  lbu t1,1(a2)         // T1 = Immediate LO Byte
  or t0,t1             // T0 = Immediate (24-Bit)
  addu a2,a0,t0        // A2 = MEM_MAP + Immediate

  la sp,LoadByte       // Load Byte
  jalr sp,sp

  lbu {reg},0(a2)      // Register = Absolute Long (8-Bit)
}

macro LoadABSL16(reg) { // Load 16-Bit Absolute Long Memory To Register
  lbu t0,3(a2)          // Absolute Long = MEM_MAP[Immediate]
  sll t0,16             // T0 = Immediate HI Byte
  lbu t1,2(a2)          // T1 = Immediate MID Byte
  sll t1,8              // T1 <<= 8
  or t0,t1              // T0 = Immediate HI | MID Byte
  lbu t1,1(a2)          // T1 = Immediate LO Byte
  or t0,t1              // T0 = Immediate (24-Bit)
  addu a2,a0,t0         // A2 = MEM_MAP + Immediate

  la sp,LoadWord        // Load Word
  jalr sp,sp

  lbu {reg},1(a2)       // Register = Absolute Long HI Byte
  sll {reg},8           // Register <<= 8
  lbu t1,0(a2)          // T1 = Absolute Long LO Byte
  or {reg},t1           // Register = Absolute Long (16-Bit)
}

macro LoadABSLX8(reg) { // Load 8-Bit Absolute Long Indexed, X Memory To Register
  lbu t0,3(a2)          // Absolute Long Indexed, X = MEM_MAP[Immediate + X_REG]
  sll t0,16             // T0 = Immediate HI Byte
  lbu t1,2(a2)          // T1 = Immediate MID Byte
  sll t1,8              // T1 <<= 8
  or t0,t1              // T0 = Immediate HI | MID Byte
  lbu t1,1(a2)          // T1 = Immediate LO Byte
  or t0,t1              // T0 = Immediate (24-Bit)
  addu t0,s1            // T0 = Immediate + X_REG
  addu a2,a0,t0         // A2 = MEM_MAP + Immediate + X_REG

  la sp,LoadByte        // Load Byte
  jalr sp,sp

  lbu {reg},0(a2)       // Register = Absolute Long Indexed, X (8-Bit)
}

macro LoadABSLX16(reg) { // Load 16-Bit Absolute Long Indexed, X Memory To Register
  lbu t0,3(a2)           // Absolute Long Indexed, X = MEM_MAP[Immediate + X_REG]
  sll t0,16              // T0 = Immediate HI Byte
  lbu t1,2(a2)           // T1 = Immediate MID Byte
  sll t1,8               // T1 <<= 8
  or t0,t1               // T0 = Immediate HI | MID Byte
  lbu t1,1(a2)           // T1 = Immediate LO Byte
  or t0,t1               // T0 = Immediate (24-Bit)
  addu t0,s1             // T0 = Immediate + X_REG
  addu a2,a0,t0          // A2 = MEM_MAP + Immediate + X_REG

  la sp,LoadWord         // Load Word
  jalr sp,sp

  lbu {reg},1(a2)        // Register = Absolute Long Indexed, X HI Byte
  sll {reg},8            // Register <<= 8
  lbu t1,0(a2)           // T1 = Absolute Long Indexed, X LO Byte
  or {reg},t1            // Register = Absolute Long Indexed, X (16-Bit)
}

macro LoadABSX8(reg) { // Load 8-Bit Absolute Indexed, X Memory To Register
  lbu t0,2(a2)         // Absolute Indexed, X = MEM_MAP[DB_REG:Immediate + X_REG]
  sll t0,8             // T0 = Immediate HI Byte
  lbu t1,1(a2)         // T1 = Immediate LO Byte
  or t0,t1             // T0 = Immediate (16-Bit)
  sll t1,s7,16         // T1 = DB_REG << 16 
  or t0,t1             // T0 = DB_REG:Immediate
  addu t0,s1           // T0 = DB_REG:Immediate + X_REG
  addu a2,a0,t0        // A2 = MEM_MAP + DB_REG:Immediate + X_REG

  la sp,LoadByte       // Load Byte
  jalr sp,sp

  lbu {reg},0(a2)      // Register = Absolute Indexed, X (8-Bit)
}

macro LoadABSX16(reg) { // Load 16-Bit Absolute Indexed, X Memory To Register
  lbu t0,2(a2)          // Absolute Indexed, X = MEM_MAP[DB_REG:Immediate + X_REG]
  sll t0,8              // T0 = Immediate HI Byte
  lbu t1,1(a2)          // T1 = Immediate LO Byte
  or t0,t1              // T0 = Immediate (16-Bit)
  sll t1,s7,16          // T1 = DB_REG << 16 
  or t0,t1              // T0 = DB_REG:Immediate
  addu t0,s1            // T0 = DB_REG:Immediate + X_REG
  addu a2,a0,t0         // A2 = MEM_MAP + DB_REG:Immediate + X_REG

  la sp,LoadWord         // Load Word
  jalr sp,sp

  lbu {reg},1(a2)       // Register = Absolute Indexed, X HI Byte
  sll {reg},8           // Register <<= 8
  lbu t1,0(a2)          // T1 = Absolute Indexed, X LO Byte
  or {reg},t1           // Register = Absolute Indexed, X (16-Bit)
}

macro LoadABSY8(reg) { // Load 8-Bit Absolute Indexed, Y Memory To Register
  lbu t0,2(a2)         // Absolute Indexed, Y = MEM_MAP[DB_REG:Immediate + Y_REG]
  sll t0,8             // T0 = Immediate HI Byte
  lbu t1,1(a2)         // T1 = Immediate LO Byte
  or t0,t1             // T0 = Immediate (16-Bit)
  sll t1,s7,16         // T1 = DB_REG << 16 
  or t0,t1             // T0 = DB_REG:Immediate
  addu t0,s2           // T0 = DB_REG:Immediate + Y_REG
  addu a2,a0,t0        // A2 = MEM_MAP + DB_REG:Immediate + Y_REG

  la sp,LoadByte       // Load Byte
  jalr sp,sp

  lbu {reg},0(a2)      // Register = Absolute Indexed, Y (8-Bit)
}

macro LoadABSY16(reg) { // Load 16-Bit Absolute Indexed, Y Memory To Register
  lbu t0,2(a2)          // Absolute Indexed, Y = MEM_MAP[DB_REG:Immediate + Y_REG]
  sll t0,8              // T0 = Immediate HI Byte
  lbu t1,1(a2)          // T1 = Immediate LO Byte
  or t0,t1              // T0 = Immediate (16-Bit)
  sll t1,s7,16          // T1 = DB_REG << 16 
  or t0,t1              // T0 = DB_REG:Immediate
  addu t0,s2            // T0 = DB_REG:Immediate + Y_REG
  addu a2,a0,t0         // A2 = MEM_MAP + DB_REG:Immediate + Y_REG

  la sp,LoadWord        // Load Word
  jalr sp,sp

  lbu {reg},1(a2)       // Register = Absolute Indexed, Y HI Byte
  sll {reg},8           // Register <<= 8
  lbu t1,0(a2)          // T1 = Absolute Indexed, Y LO Byte
  or {reg},t1           // Register = Absolute Indexed, Y (16-Bit)
}

macro LoadDP8(reg) { // Load 8-Bit Direct Page (DP) Memory To Register
  lbu t0,1(a2)       // DP = MEM_MAP[D_REG + Immediate]
  addu t0,s6         // T0 = D_REG + Immediate
  addu a2,a0,t0      // A2 = MEM_MAP + D_REG + Immediate

  la sp,LoadByte     // Load Byte
  jalr sp,sp

  lbu {reg},0(a2)    // Register = DP (8-Bit)
}

macro LoadDP16(reg) { // Load 16-Bit Direct Page (DP) Memory To Register
  lbu t0,1(a2)        // DP = MEM_MAP[D_REG + Immediate]
  addu t0,s6          // T0 = D_REG + Immediate
  addu a2,a0,t0       // A2 = MEM_MAP + D_REG + Immediate

  la sp,LoadWord      // Load Word
  jalr sp,sp

  lbu {reg},1(a2)     // Register = DP HI Byte
  sll {reg},8         // Register <<= 8
  lbu t1,0(a2)        // T1 = DP LO Byte
  or {reg},t1         // Register = DP (16-Bit)
}

macro LoadDPI8(reg) { // Load 8-Bit Direct Page (DP) Indirect Memory To Register
  lbu t0,1(a2)        // DP Indirect = MEM_MAP[WORD[D_REG + Immediate]]
  addu t0,s6          // T0 = D_REG + Immediate
  addu a2,a0,t0       // A2 = MEM_MAP + D_REG + Immediate
  lbu t0,1(a2)        // T0 = DP Indirect WORD HI Byte
  sll t0,8            // T0 <<= 8
  lbu t1,0(a2)        // T1 = DP Indirect WORD LO Byte
  or t0,t1            // T0 = DP Indirect WORD
  addu a2,a0,t0       // A2 = MEM_MAP + DP Indirect WORD

  la sp,LoadByte      // Load Byte
  jalr sp,sp

  lbu {reg},0(a2)     // Register = DP Indirect (8-Bit)
}

macro LoadDPI16(reg) { // Load 16-Bit Direct Page (DP) Indirect Memory To Register
  lbu t0,1(a2)         // DP Indirect = MEM_MAP[WORD[D_REG + Immediate]]
  addu t0,s6           // T0 = D_REG + Immediate
  addu a2,a0,t0        // A2 = MEM_MAP + D_REG + Immediate
  lbu t0,1(a2)         // T0 = DP Indirect WORD HI Byte
  sll t0,8             // T0 <<= 8
  lbu t1,0(a2)         // T1 = DP Indirect WORD LO Byte
  or t0,t1             // T0 = DP Indirect WORD
  addu a2,a0,t0        // A2 = MEM_MAP + DP Indirect WORD

  la sp,LoadWord       // Load Word
  jalr sp,sp

  lbu {reg},1(a2)      // Register = DP Indirect HI Byte
  sll {reg},8          // Register <<= 8
  lbu t1,0(a2)         // T1 = DP Indirect LO Byte
  or {reg},t1          // Register = DP Indirect (16-Bit)
}

macro LoadDPIL8(reg) { // Load 8-Bit Direct Page (DP) Indirect Long Memory To Register
  lbu t0,1(a2)         // DP Indirect Long = MEM_MAP[FAR[D_REG + Immediate]]
  addu t0,s6           // T0 = D_REG + Immediate
  addu a2,a0,t0        // A2 = MEM_MAP + D_REG + Immediate
  lbu t0,2(a2)         // T0 = DP Indirect Long FAR HI Byte
  sll t0,16            // T0 <<= 16
  lbu t1,1(a2)         // T1 = DP Indirect Long FAR MID Byte
  sll t1,8             // T1 <<= 8
  or t0,t1             // T0 = DP Indirect Long FAR HI | MID Byte
  lbu t1,0(a2)         // T1 = DP Indirect Long FAR LO Byte
  or t0,t1             // T0 = DP Indirect Long FAR
  addu a2,a0,t0        // A2 = MEM_MAP + DP Indirect Long FAR

  la sp,LoadByte       // Load Byte
  jalr sp,sp

  lbu {reg},0(a2)      // Register = DP Indirect Long (8-Bit)
}

macro LoadDPIL16(reg) { // Load 16-Bit Direct Page (DP) Indirect Long Memory To Register
  lbu t0,1(a2)          // DP Indirect Long = MEM_MAP[FAR[D_REG + Immediate]]
  addu t0,s6            // T0 = D_REG + Immediate
  addu a2,a0,t0         // A2 = MEM_MAP + D_REG + Immediate
  lbu t0,2(a2)          // T0 = DP Indirect Long FAR HI Byte
  sll t0,16             // T0 <<= 16
  lbu t1,1(a2)          // T1 = DP Indirect Long FAR MID Byte
  sll t1,8              // T1 <<= 8
  or t0,t1              // T0 = DP Indirect Long FAR HI | MID Byte
  lbu t1,0(a2)          // T1 = DP Indirect Long FAR LO Byte
  or t0,t1              // T0 = DP Indirect Long FAR
  addu a2,a0,t0         // A2 = MEM_MAP + DP Indirect Long FAR

  la sp,LoadWord        // Load Word
  jalr sp,sp

  lbu {reg},1(a2)       // Register = DP Indirect Long HI Byte
  sll {reg},8           // Register <<= 8
  lbu t1,0(a2)          // T1 = DP Indirect Long LO Byte
  or {reg},t1           // Register = DP Indirect Long (16-Bit)
}

macro LoadDPILY8(reg) { // Load 8-Bit Direct Page (DP) Indirect Long Indexed, Y Memory To Register
  lbu t0,1(a2)          // DP Indirect Long Indexed, Y = MEM_MAP[FAR[D_REG + Immediate] + Y_REG]
  addu t0,s6            // T0 = D_REG + Immediate
  addu a2,a0,t0         // A2 = MEM_MAP + D_REG + Immediate
  lbu t0,2(a2)          // T0 = DP Indirect Long FAR HI Byte
  sll t0,16             // T0 <<= 16
  lbu t1,1(a2)          // T1 = DP Indirect Long FAR MID Byte
  sll t1,8              // T1 <<= 8
  or t0,t1              // T0 = DP Indirect Long FAR HI | MID Byte
  lbu t1,0(a2)          // T1 = DP Indirect Long FAR LO Byte
  or t0,t1              // T0 = DP Indirect Long FAR
  addu t0,s2            // T0 = DP Indirect Long FAR + Y_REG
  addu a2,a0,t0         // A2 = MEM_MAP + DP Indirect Long FAR + Y_REG

  la sp,LoadByte        // Load Byte
  jalr sp,sp

  lbu {reg},0(a2)       // Register = DP Indirect Long Indexed, Y (8-Bit)
}

macro LoadDPILY16(reg) { // Load 16-Bit Direct Page (DP) Indirect Long Indexed, Y Memory To Register
  lbu t0,1(a2)           // DP Indirect Long Indexed, Y = MEM_MAP[FAR[D_REG + Immediate] + Y_REG]
  addu t0,s6             // T0 = D_REG + Immediate
  addu a2,a0,t0          // A2 = MEM_MAP + D_REG + Immediate
  lbu t0,2(a2)           // T0 = DP Indirect Long FAR HI Byte
  sll t0,16              // T0 <<= 16
  lbu t1,1(a2)           // T1 = DP Indirect Long FAR MID Byte
  sll t1,8               // T1 <<= 8
  or t0,t1               // T0 = DP Indirect Long FAR HI | MID Byte
  lbu t1,0(a2)           // T1 = DP Indirect Long FAR LO Byte
  or t0,t1               // T0 = DP Indirect Long FAR
  addu t0,s2             // T0 = DP Indirect Long FAR + Y_REG
  addu a2,a0,t0          // A2 = MEM_MAP + DP Indirect Long FAR + Y_REG

  la sp,LoadWord         // Load Word
  jalr sp,sp

  lbu {reg},1(a2)        // Register = DP Indirect Long Indexed, Y HI Byte
  sll {reg},8            // Register <<= 8
  lbu t1,0(a2)           // T1 = DP Indirect Long LO Indexed, Y Byte
  or {reg},t1            // Register = DP Indirect Long Indexed, Y (16-Bit)
}

macro LoadDPIX8(reg) { // Load 8-Bit Direct Page (DP) Indexed Indirect, X Memory To Register
  lbu t0,1(a2)         // DP Indexed Indirect, X = MEM_MAP[WORD[D_REG + Immediate + X_REG]]
  addu t0,s6           // T0 = D_REG + Immediate
  addu t0,s1           // T0 = D_REG + Immediate + X_REG
  addu a2,a0,t0        // A2 = MEM_MAP + D_REG + Immediate + X_REG
  lbu t0,1(a2)         // T0 = DP Indirect WORD HI Byte
  sll t0,8             // T0 <<= 8
  lbu t1,0(a2)         // T1 = DP Indexed Indirect, X WORD LO Byte
  or t0,t1             // T0 = DP Indexed Indirect, X WORD
  addu a2,a0,t0        // A2 = MEM_MAP + DP Indexed Indirect, X WORD

  la sp,LoadByte       // Load Byte
  jalr sp,sp

  lbu {reg},0(a2)      // Register = DP Indexed Indirect, X (8-Bit)
}

macro LoadDPIX16(reg) { // Load 16-Bit Direct Page (DP) Indexed Indirect, X Memory To Register
  lbu t0,1(a2)          // DP Indexed Indirect, X = MEM_MAP[WORD[D_REG + Immediate + X_REG]]
  addu t0,s6            // T0 = D_REG + Immediate
  addu t0,s1            // T0 = D_REG + Immediate + X_REG
  addu a2,a0,t0         // A2 = MEM_MAP + D_REG + Immediate + X_REG
  lbu t0,1(a2)          // T0 = DP Indexed Indirect, X WORD HI Byte
  sll t0,8              // T0 <<= 8
  lbu t1,0(a2)          // T1 = DP Indexed Indirect, X WORD LO Byte
  or t0,t1              // T0 = DP Indexed Indirect, X WORD
  addu a2,a0,t0         // A2 = MEM_MAP + DP Indexed Indirect, X WORD

  la sp,LoadWord        // Load Word
  jalr sp,sp

  lbu {reg},1(a2)       // Register = DP Indexed Indirect, X HI Byte
  sll {reg},8           // Register <<= 8
  lbu t1,0(a2)          // T1 = DP Indexed Indirect, X LO Byte
  or {reg},t1           // Register = DP Indexed Indirect, X (16-Bit)
}

macro LoadDPIY8(reg) { // Load 8-Bit Direct Page (DP) Indirect Indexed, Y Memory To Register
  lbu t0,1(a2)         // DP Indirect Indexed, Y = MEM_MAP[WORD[D_REG + Immediate] + Y_REG]
  addu t0,s6           // T0 = D_REG + Immediate
  addu a2,a0,t0        // A2 = MEM_MAP + D_REG + Immediate
  lbu t0,1(a2)         // T0 = DP Indirect WORD HI Byte
  sll t0,8             // T0 <<= 8
  lbu t1,0(a2)         // T1 = DP Indirect WORD LO Byte
  or t0,t1             // T0 = DP Indirect WORD
  addu t0,s2           // T0 = DP Indirect WORD + Y_REG
  addu a2,a0,t0        // A2 = MEM_MAP + DP Indirect WORD + Y_REG

  la sp,LoadByte       // Load Byte
  jalr sp,sp

  lbu {reg},0(a2)      // Register = DP Indirect Indexed, Y (8-Bit)
}

macro LoadDPIY16(reg) { // Load 16-Bit Direct Page (DP) Indirect Indexed, Y Memory To Register
  lbu t0,1(a2)          // DP Indirect Indexed, Y = MEM_MAP[WORD[D_REG + Immediate] + Y_REG]
  addu t0,s6            // T0 = D_REG + Immediate
  addu a2,a0,t0         // A2 = MEM_MAP + D_REG + Immediate
  lbu t0,1(a2)          // T0 = DP Indirect WORD HI Byte
  sll t0,8              // T0 <<= 8
  lbu t1,0(a2)          // T1 = DP Indirect WORD LO Byte
  or t0,t1              // T0 = DP Indirect WORD
  addu t0,s2            // T0 = DP Indirect WORD + Y_REG
  addu a2,a0,t0         // A2 = MEM_MAP + DP Indirect WORD + Y_REG

  la sp,LoadWord        // Load Word
  jalr sp,sp

  lbu {reg},1(a2)       // Register = DP Indirect Indexed, Y HI Byte
  sll {reg},8           // Register <<= 8
  lbu t1,0(a2)          // T1 = DP Indirect Indexed, Y LO Byte
  or {reg},t1           // Register = DP Indirect Indexed, Y (16-Bit)
}

macro LoadDPX8(reg) { // Load 8-Bit Direct Page (DP) Indexed, X Memory To Register
  lbu t0,1(a2)        // DP Indexed, X = MEM_MAP[D_REG + Immediate + X_REG]
  addu t0,s6          // T0 = D_REG + Immediate
  addu t0,s1          // T0 = D_REG + Immediate + X_REG
  addu a2,a0,t0       // A2 = MEM_MAP + D_REG + Immediate + X_REG

  la sp,LoadByte      // Load Byte
  jalr sp,sp

  lbu {reg},0(a2)     // Register = DP Indexed, X (8-Bit)
}

macro LoadDPX16(reg) { // Load 16-Bit Direct Page (DP) Indexed, X Memory To Register
  lbu t0,1(a2)         // DP Indexed, X = MEM_MAP[D_REG + Immediate + X_REG]
  addu t0,s6           // T0 = D_REG + Immediate
  addu t0,s1           // T0 = D_REG + Immediate + X_REG
  addu a2,a0,t0        // A2 = MEM_MAP + D_REG + Immediate + X_REG

  la sp,LoadWord       // Load Word
  jalr sp,sp

  lbu {reg},1(a2)      // Register = DP Indexed, X HI Byte
  sll {reg},8          // Register <<= 8
  lbu t1,0(a2)         // T1 = DP Indexed, X LO Byte
  or {reg},t1          // Register = DP Indexed, X (16-Bit)
}

macro LoadDPY8(reg) { // Load 8-Bit Direct Page (DP) Indexed, Y Memory To Register
  lbu t0,1(a2)        // DP Indexed, Y = MEM_MAP[D_REG + Immediate + Y_REG]
  addu t0,s6          // T0 = D_REG + Immediate
  addu t0,s2          // T0 = D_REG + Immediate + Y_REG
  addu a2,a0,t0       // A2 = MEM_MAP + D_REG + Immediate + Y_REG

  la sp,LoadByte      // Load Byte
  jalr sp,sp

  lbu {reg},0(a2)     // Register = DP Indexed, Y (8-Bit)
}

macro LoadDPY16(reg) { // Load 16-Bit Direct Page (DP) Indexed, Y Memory To Register
  lbu t0,1(a2)         // DP Indexed, Y = MEM_MAP[D_REG + Immediate + Y_REG]
  addu t0,s6           // T0 = D_REG + Immediate
  addu t0,s2           // T0 = D_REG + Immediate + Y_REG
  addu a2,a0,t0        // A2 = MEM_MAP + D_REG + Immediate + Y_REG

  la sp,LoadWord       // Load Word
  jalr sp,sp

  lbu {reg},1(a2)      // Register = DP Indexed, Y HI Byte
  sll {reg},8          // Register <<= 8
  lbu t1,0(a2)         // T1 = DP Indexed, Y LO Byte
  or {reg},t1          // Register = DP Indexed, Y (16-Bit)
}

macro LoadSR8(reg) { // Load 8-Bit Stack Relative (SR) Memory To Register
  lbu t0,1(a2)       // SR = MEM_MAP[Immediate + S_REG]
  addu t0,s4         // T0 = Immediate + S_REG
  addu a2,a0,t0      // A2 = MEM_MAP + Immediate + S_REG

  la sp,LoadByte     // Load Byte
  jalr sp,sp

  lbu {reg},0(a2)    // Register = SR (8-Bit)
}

macro LoadSR16(reg) { // Load 16-Bit Stack Relative (SR) Memory To Register
  lbu t0,1(a2)        // SR = MEM_MAP[Immediate + S_REG]
  addu t0,s4          // T0 = Immediate + S_REG
  addu a2,a0,t0       // A2 = MEM_MAP + Immediate + S_REG

  la sp,LoadWord      // Load Word
  jalr sp,sp

  lbu {reg},1(a2)     // Register = SR HI Byte
  sll {reg},8         // Register <<= 8
  lbu t1,0(a2)        // T1 = SR LO Byte
  or {reg},t1         // Register = SR (16-Bit)
}

macro LoadSRIY8(reg) { // Load 8-Bit Stack Relative (SR) Indirect Indexed, Y Memory To Register
  lbu t0,1(a2)         // SR Indirect Indexed, Y = MEM_MAP[WORD[Immediate + S_REG] + Y_REG]
  addu t0,s4           // T0 = Immediate + S_REG
  addu a2,a0,t0        // A2 = MEM_MAP + Immediate + S_REG
  lbu t0,1(a2)         // T0 = SR Indirect WORD HI Byte
  sll t0,8             // T0 <<= 8
  lbu t1,0(a2)         // T1 = SR Indirect WORD LO Byte
  or t0,t1             // T0 = SR Indirect WORD
  addu t0,s2           // T0 = SR Indirect WORD + Y_REG
  addu a2,a0,t0        // A2 = MEM_MAP + SR Indirect WORD + Y_REG

  la sp,LoadByte       // Load Byte
  jalr sp,sp

  lbu {reg},0(a2)      // Register = SR Indirect Indexed, Y (8-Bit)
}

macro LoadSRIY16(reg) { // Load 16-Bit Stack Relative (SR) Indirect Indexed, Y Memory To Register
  lbu t0,1(a2)          // SR Indirect Indexed, Y = MEM_MAP[WORD[Immediate + S_REG] + Y_REG]
  addu t0,s4            // T0 = Immediate + S_REG
  addu a2,a0,t0         // A2 = MEM_MAP + Immediate + S_REG
  lbu t0,1(a2)          // T0 = SR Indirect WORD HI Byte
  sll t0,8              // T0 <<= 8
  lbu t1,0(a2)          // T1 = SR Indirect WORD LO Byte
  or t0,t1              // T0 = SR Indirect WORD
  addu t0,s2            // T0 = SR Indirect WORD + Y_REG
  addu a2,a0,t0         // A2 = MEM_MAP + SR Indirect WORD + Y_REG

  la sp,LoadWord        // Load Word
  jalr sp,sp

  lbu {reg},1(a2)       // Register = SR Indirect Indexed, Y HI Byte
  sll {reg},8           // Register <<= 8
  lbu t1,0(a2)          // T1 = SR Indirect Indexed, Y LO Byte
  or {reg},t1           // Register = SR Indirect Indexed, Y (16-Bit)
}

//-------------------------
// CPU Memory Store Macros
//-------------------------
macro StoreABS8(reg) { // Store 8-Bit Register To Absolute Memory 
  lbu t0,2(a2)         // Absolute = MEM_MAP[DB_REG:Immediate]
  sll t0,8             // T0 = Immediate HI Byte
  lbu t1,1(a2)         // T1 = Immediate LO Byte
  or t0,t1             // T0 = Immediate (16-Bit)
  sll t1,s7,16         // T1 = DB_REG << 16 
  or t0,t1             // T0 = DB_REG:Immediate
  addu a2,a0,t0        // A2 = MEM_MAP + DB_REG:Immediate
  sb {reg},0(a2)       // Absolute = Register (8-Bit)

  la sp,StoreByte      // Store Byte
  jalr sp,sp
}

macro StoreABS16(reg) { // Store 16-Bit Register To Absolute Memory 
  lbu t0,2(a2)          // Absolute = MEM_MAP[DB_REG:Immediate]
  sll t0,8              // T0 = Immediate HI Byte
  lbu t1,1(a2)          // T1 = Immediate LO Byte
  or t0,t1              // T0 = Immediate (16-Bit)
  sll t1,s7,16          // T1 = DB_REG << 16 
  or t0,t1              // T0 = DB_REG:Immediate
  addu a2,a0,t0         // A2 = MEM_MAP + DB_REG:Immediate
  sb {reg},0(a2)        // Absolute = Register LO Byte
  srl t1,{reg},8        // T1 = Register >> 8
  sb t1,1(a2)           // Absolute = Register (16-Bit)

  la sp,StoreWord       // Store Word
  jalr sp,sp
}

macro StoreABSL8(reg) { // Store 8-Bit Register To Absolute Long Memory
  lbu t0,3(a2)          // Absolute Long = MEM_MAP[Immediate]
  sll t0,16             // T0 = Immediate HI Byte
  lbu t1,2(a2)          // T1 = Immediate MID Byte
  sll t1,8              // T1 <<= 8
  or t0,t1              // T0 = Immediate HI | MID Byte
  lbu t1,1(a2)          // T1 = Immediate LO Byte
  or t0,t1              // T0 = Immediate (24-Bit)
  addu a2,a0,t0         // A2 = MEM_MAP + Immediate
  sb {reg},0(a2)        // Absolute Long = Register (8-Bit)

  la sp,StoreByte       // Store Byte
  jalr sp,sp
}

macro StoreABSL16(reg) { // Store 16-Bit Register To Absolute Long Memory
  lbu t0,3(a2)           // Absolute Long = MEM_MAP[Immediate]
  sll t0,16              // T0 = Immediate HI Byte
  lbu t1,2(a2)           // T1 = Immediate MID Byte
  sll t1,8               // T1 <<= 8
  or t0,t1               // T0 = Immediate HI | MID Byte
  lbu t1,1(a2)           // T1 = Immediate LO Byte
  or t0,t1               // T0 = Immediate (24-Bit)
  addu a2,a0,t0          // A2 = MEM_MAP + Immediate
  sb {reg},0(a2)         // Absolute Long = Register LO Byte
  srl t1,{reg},8         // T1 = Register >> 8
  sb t1,1(a2)            // Absolute Long = Register (16-Bit)

  la sp,StoreWord        // Store Word
  jalr sp,sp
}

macro StoreABSLX8(reg) { // Store 8-Bit Register To Absolute Long Indexed, X Memory
  lbu t0,3(a2)           // Absolute Long Indexed, X = MEM_MAP[Immediate + X_REG]
  sll t0,16              // T0 = Immediate HI Byte
  lbu t1,2(a2)           // T1 = Immediate MID Byte
  sll t1,8               // T1 <<= 8
  or t0,t1               // T0 = Immediate HI | MID Byte
  lbu t1,1(a2)           // T1 = Immediate LO Byte
  or t0,t1               // T0 = Immediate (24-Bit)
  addu t0,s1             // T0 = Immediate + X_REG
  addu a2,a0,t0          // A2 = MEM_MAP + Immediate + X_REG
  sb {reg},0(a2)         // Absolute Long Indexed, X = Register (8-Bit)

  la sp,StoreByte        // Store Byte
  jalr sp,sp
}

macro StoreABSLX16(reg) { // Store 16-Bit Register To Absolute Long Indexed, X Memory
  lbu t0,3(a2)            // Absolute Long Indexed, X = MEM_MAP[Immediate + X_REG]
  sll t0,16               // T0 = Immediate HI Byte
  lbu t1,2(a2)            // T1 = Immediate MID Byte
  sll t1,8                // T1 <<= 8
  or t0,t1                // T0 = Immediate HI | MID Byte
  lbu t1,1(a2)            // T1 = Immediate LO Byte
  or t0,t1                // T0 = Immediate (24-Bit)
  addu t0,s1              // T0 = Immediate + X_REG
  addu a2,a0,t0           // A2 = MEM_MAP + Immediate + X_REG
  sb {reg},0(a2)          // Absolute Long Indexed, X Memory = Register LO Byte
  srl t1,{reg},8          // T1 = Register >> 8
  sb t1,1(a2)             // Absolute Long Indexed, X Memory = Register (16-Bit)

  la sp,StoreWord         // Store Word
  jalr sp,sp
}

macro StoreABSX8(reg) { // Store 8-Bit Register To Absolute Indexed, X Memory
  lbu t0,2(a2)          // Absolute Indexed, X = MEM_MAP[DB_REG:Immediate + X_REG]
  sll t0,8              // T0 = Immediate HI Byte
  lbu t1,1(a2)          // T1 = Immediate LO Byte
  or t0,t1              // T0 = Immediate (16-Bit)
  sll t1,s7,16          // T1 = DB_REG << 16 
  or t0,t1              // T0 = DB_REG:Immediate
  addu t0,s1            // T0 = DB_REG:Immediate + X_REG
  addu a2,a0,t0         // A2 = MEM_MAP + DB_REG:Immediate + X_REG
  sb {reg},0(a2)        // Absolute Indexed, X = Register (8-Bit)

  la sp,StoreByte       // Store Byte
  jalr sp,sp
}

macro StoreABSX16(reg) { // Store 16-Bit Register To Absolute Indexed, X Memory
  lbu t0,2(a2)           // Absolute Indexed, X = MEM_MAP[DB_REG:Immediate + X_REG]
  sll t0,8               // T0 = Immediate HI Byte
  lbu t1,1(a2)           // T1 = Immediate LO Byte
  or t0,t1               // T0 = Immediate (16-Bit)
  sll t1,s7,16           // T1 = DB_REG << 16 
  or t0,t1               // T0 = DB_REG:Immediate
  addu t0,s1             // T0 = DB_REG:Immediate + X_REG
  addu a2,a0,t0          // A2 = MEM_MAP + DB_REG:Immediate + X_REG
  sb {reg},0(a2)         // Absolute Indexed, X Memory = Register LO Byte
  srl t1,{reg},8         // T1 = Register >> 8
  sb t1,1(a2)            // Absolute Indexed, X Memory = Register (16-Bit)

  la sp,StoreWord        // Store Word
  jalr sp,sp
}

macro StoreABSY8(reg) { // Store 8-Bit Register To Absolute Indexed, Y Memory
  lbu t0,2(a2)          // Absolute Indexed, Y = MEM_MAP[DB_REG:Immediate + Y_REG]
  sll t0,8              // T0 = Immediate HI Byte
  lbu t1,1(a2)          // T1 = Immediate LO Byte
  or t0,t1              // T0 = Immediate (16-Bit)
  sll t1,s7,16          // T1 = DB_REG << 16 
  or t0,t1              // T0 = DB_REG:Immediate
  addu t0,s2            // T0 = DB_REG:Immediate + Y_REG
  addu a2,a0,t0         // A2 = MEM_MAP + DB_REG:Immediate + Y_REG
  sb {reg},0(a2)        // Absolute Indexed, Y = Register (8-Bit)

  la sp,StoreByte       // Store Byte
  jalr sp,sp
}

macro StoreABSY16(reg) { // Store 16-Bit Register To Absolute Indexed, Y Memory
  lbu t0,2(a2)           // Absolute Indexed, Y = MEM_MAP[DB_REG:Immediate + Y_REG]
  sll t0,8               // T0 = Immediate HI Byte
  lbu t1,1(a2)           // T1 = Immediate LO Byte
  or t0,t1               // T0 = Immediate (16-Bit)
  sll t1,s7,16           // T1 = DB_REG << 16 
  or t0,t1               // T0 = DB_REG:Immediate
  addu t0,s2             // T0 = DB_REG:Immediate + Y_REG
  addu a2,a0,t0          // A2 = MEM_MAP + DB_REG:Immediate + Y_REG
  sb {reg},0(a2)         // Absolute Indexed, Y Memory = Register LO Byte
  srl t1,{reg},8         // T1 = Register >> 8
  sb t1,1(a2)            // Absolute Indexed, Y Memory = Register (16-Bit)

  la sp,StoreWord        // Store Word
  jalr sp,sp
}

macro StoreDP8(reg) { // Store 8-Bit Register To Direct Page (DP) Memory
  lbu t0,1(a2)        // DP = MEM_MAP[D_REG + Immediate]
  addu t0,s6          // T0 = D_REG + Immediate
  addu a2,a0,t0       // A2 = MEM_MAP + D_REG + Immediate
  sb {reg},0(a2)      // DP = Register (8-Bit)

  la sp,StoreByte     // Store Byte
  jalr sp,sp
}

macro StoreDP16(reg) { // Store 16-Bit Register To Direct Page (DP) Memory
  lbu t0,1(a2)         // DP = MEM_MAP[D_REG + Immediate]
  addu t0,s6           // T0 = D_REG + Immediate
  addu a2,a0,t0        // A2 = MEM_MAP + D_REG + Immediate
  sb {reg},0(a2)       // DP = Register LO Byte
  srl t1,{reg},8       // T1 = Register >> 8
  sb t1,1(a2)          // DP = Register (16-Bit)

  la sp,StoreWord      // Store Word
  jalr sp,sp
}

macro StoreDPI8(reg) { // Store 8-Bit Register To Direct Page (DP) Indirect Memory
  lbu t0,1(a2)         // DP Indirect = MEM_MAP[WORD[D_REG + Immediate]]
  addu t0,s6           // T0 = D_REG + Immediate
  addu a2,a0,t0        // A2 = MEM_MAP + D_REG + Immediate
  lbu t0,1(a2)         // T0 = DP Indirect WORD HI Byte
  sll t0,8             // T0 <<= 8
  lbu t1,0(a2)         // T1 = DP Indirect WORD LO Byte
  or t0,t1             // T0 = DP Indirect WORD
  addu a2,a0,t0        // A2 = MEM_MAP + DP Indirect WORD
  sb {reg},0(a2)       // DP Indirect = Register (8-Bit)

  la sp,StoreByte      // Store Byte
  jalr sp,sp
}

macro StoreDPI16(reg) { // Store 16-Bit Register To Direct Page (DP) Indirect Memory
  lbu t0,1(a2)          // DP Indirect = MEM_MAP[WORD[D_REG + Immediate]]
  addu t0,s6            // T0 = D_REG + Immediate
  addu a2,a0,t0         // A2 = MEM_MAP + D_REG + Immediate
  lbu t0,1(a2)          // T0 = DP Indirect WORD HI Byte
  sll t0,8              // T0 <<= 8
  lbu t1,0(a2)          // T1 = DP Indirect WORD LO Byte
  or t0,t1              // T0 = DP Indirect WORD
  addu a2,a0,t0         // A2 = MEM_MAP + DP Indirect WORD
  sb {reg},0(a2)        // DP Indirect = Register LO Byte
  srl t1,{reg},8        // T1 = Register >> 8
  sb t1,1(a2)           // DP Indirect = Register (16-Bit)

  la sp,StoreWord       // Store Word
  jalr sp,sp
}

macro StoreDPIL8(reg) { // Store 8-Bit Register To Direct Page (DP) Indirect Long Memory
  lbu t0,1(a2)          // DP Indirect Long = MEM_MAP[FAR[D_REG + Immediate]]
  addu t0,s6            // T0 = D_REG + Immediate
  addu a2,a0,t0         // A2 = MEM_MAP + D_REG + Immediate
  lbu t0,2(a2)          // T0 = DP Indirect Long FAR HI Byte
  sll t0,16             // T0 <<= 16
  lbu t1,1(a2)          // T1 = DP Indirect Long FAR MID Byte
  sll t1,8              // T1 <<= 8
  or t0,t1              // T0 = DP Indirect Long FAR HI | MID Byte
  lbu t1,0(a2)          // T1 = DP Indirect Long FAR LO Byte
  or t0,t1              // T0 = DP Indirect Long FAR
  addu a2,a0,t0         // A2 = MEM_MAP + DP Indirect Long FAR
  sb {reg},0(a2)        // DP Indirect Long = Register (8-Bit)

  la sp,StoreByte       // Store Byte
  jalr sp,sp
}

macro StoreDPIL16(reg) { // Store 16-Bit Register To Direct Page (DP) Indirect Long Memory
  lbu t0,1(a2)           // DP Indirect Long = MEM_MAP[FAR[D_REG + Immediate]]
  addu t0,s6             // T0 = D_REG + Immediate
  addu a2,a0,t0          // A2 = MEM_MAP + D_REG + Immediate
  lbu t0,2(a2)           // T0 = DP Indirect Long FAR HI Byte
  sll t0,16              // T0 <<= 16
  lbu t1,1(a2)           // T1 = DP Indirect Long FAR MID Byte
  sll t1,8               // T1 <<= 8
  or t0,t1               // T0 = DP Indirect Long FAR HI | MID Byte
  lbu t1,0(a2)           // T1 = DP Indirect Long FAR LO Byte
  or t0,t1               // T0 = DP Indirect Long FAR
  addu a2,a0,t0          // A2 = MEM_MAP + DP Indirect Long FAR
  sb {reg},0(a2)         // DP Indirect Long = Register LO Byte
  srl t1,{reg},8         // T1 = Register >> 8
  sb t1,1(a2)            // DP Indirect Long = Register (16-Bit)

  la sp,StoreWord        // Store Word
  jalr sp,sp
}

macro StoreDPILY8(reg) { // Store 8-Bit Register To Direct Page (DP) Indirect Long Indexed, Y Memory
  lbu t0,1(a2)           // DP Indirect Long Indexed, Y = MEM_MAP[FAR[D_REG + Immediate] + Y_REG]
  addu t0,s6             // T0 = D_REG + Immediate
  addu a2,a0,t0          // A2 = MEM_MAP + D_REG + Immediate
  lbu t0,2(a2)           // T0 = DP Indirect Long FAR HI Byte
  sll t0,16              // T0 <<= 16
  lbu t1,1(a2)           // T1 = DP Indirect Long FAR MID Byte
  sll t1,8               // T1 <<= 8
  or t0,t1               // T0 = DP Indirect Long FAR HI | MID Byte
  lbu t1,0(a2)           // T1 = DP Indirect Long FAR LO Byte
  or t0,t1               // T0 = DP Indirect Long FAR
  addu t0,s2             // T0 = DP Indirect Long FAR + Y_REG
  addu a2,a0,t0          // A2 = MEM_MAP + DP Indirect Long FAR + Y_REG
  sb {reg},0(a2)         // DP Indirect Long Indexed, Y = Register (8-Bit)

  la sp,StoreByte        // Store Byte
  jalr sp,sp
}

macro StoreDPILY16(reg) { // Store 16-Bit Register To Direct Page (DP) Indirect Long Indexed, Y Memory
  lbu t0,1(a2)            // DP Indirect Long Indexed, Y = MEM_MAP[FAR[D_REG + Immediate] + Y_REG]
  addu t0,s6              // T0 = D_REG + Immediate
  addu a2,a0,t0           // A2 = MEM_MAP + D_REG + Immediate
  lbu t0,2(a2)            // T0 = DP Indirect Long FAR HI Byte
  sll t0,16               // T0 <<= 16
  lbu t1,1(a2)            // T1 = DP Indirect Long FAR MID Byte
  sll t1,8                // T1 <<= 8
  or t0,t1                // T0 = DP Indirect Long FAR HI | MID Byte
  lbu t1,0(a2)            // T1 = DP Indirect Long FAR LO Byte
  or t0,t1                // T0 = DP Indirect Long FAR
  addu t0,s2              // T0 = DP Indirect Long FAR + Y_REG
  addu a2,a0,t0           // A2 = MEM_MAP + DP Indirect Long FAR + Y_REG
  sb {reg},0(a2)          // DP Indirect Long Indexed, Y = Register LO Byte
  srl t1,{reg},8          // T1 = Register >> 8
  sb t1,1(a2)             // DP Indirect Long Indexed, Y = Register (16-Bit)

  la sp,StoreWord         // Store Word
  jalr sp,sp
}

macro StoreDPIX8(reg) { // Store 8-Bit Register To Direct Page (DP) Indexed Indirect, X Memory
  lbu t0,1(a2)          // DP Indexed Indirect, X = MEM_MAP[WORD[D_REG + Immediate + X_REG]]
  addu t0,s6            // T0 = D_REG + Immediate
  addu t0,s1            // T0 = D_REG + Immediate + X_REG
  addu a2,a0,t0         // A2 = MEM_MAP + D_REG + Immediate + X_REG
  lbu t0,1(a2)          // T0 = DP Indirect WORD HI Byte
  sll t0,8              // T0 <<= 8
  lbu t1,0(a2)          // T1 = DP Indexed Indirect, X WORD LO Byte
  or t0,t1              // T0 = DP Indexed Indirect, X WORD
  addu a2,a0,t0         // A2 = MEM_MAP + DP Indexed Indirect, X WORD
  sb {reg},0(a2)        // DP Indexed Indirect, X = Register (8-Bit)

  la sp,StoreByte       // Store Byte
  jalr sp,sp
}

macro StoreDPIX16(reg) { // Store 16-Bit Register To Direct Page (DP) Indexed Indirect, X Memory
  lbu t0,1(a2)           // DP Indexed Indirect, X = MEM_MAP[WORD[D_REG + Immediate + X_REG]]
  addu t0,s6             // T0 = D_REG + Immediate
  addu t0,s1             // T0 = D_REG + Immediate + X_REG
  addu a2,a0,t0          // A2 = MEM_MAP + D_REG + Immediate + X_REG
  lbu t0,1(a2)           // T0 = DP Indexed Indirect, X WORD HI Byte
  sll t0,8               // T0 <<= 8
  lbu t1,0(a2)           // T1 = DP Indexed Indirect, X WORD LO Byte
  or t0,t1               // T0 = DP Indexed Indirect, X WORD
  addu a2,a0,t0          // A2 = MEM_MAP + DP Indexed Indirect, X WORD
  sb {reg},0(a2)         // DP Indexed Indirect, X = Register LO Byte
  srl t1,{reg},8         // T1 = Register >> 8
  sb t1,1(a2)            // DP Indexed Indirect, X = Register (16-Bit)

  la sp,StoreWord        // Store Word
  jalr sp,sp
}

macro StoreDPIY8(reg) { // Store 8-Bit Register To Direct Page (DP) Indirect Indexed, Y Memory
  lbu t0,1(a2)          // DP Indirect Indexed, Y = MEM_MAP[WORD[D_REG + Immediate] + Y_REG]
  addu t0,s6            // T0 = D_REG + Immediate
  addu a2,a0,t0         // A2 = MEM_MAP + D_REG + Immediate
  lbu t0,1(a2)          // T0 = DP Indirect WORD HI Byte
  sll t0,8              // T0 <<= 8
  lbu t1,0(a2)          // T1 = DP Indirect WORD LO Byte
  or t0,t1              // T0 = DP Indirect WORD
  addu t0,s2            // T0 = DP Indirect WORD + Y_REG
  addu a2,a0,t0         // A2 = MEM_MAP + DP Indirect WORD + Y_REG
  sb {reg},0(a2)        // DP Indirect Indexed, Y = Register (8-Bit)

  la sp,StoreByte       // Store Byte
  jalr sp,sp
}

macro StoreDPIY16(reg) { // Store 16-Bit Register To Direct Page (DP) Indirect Indexed, Y Memory
  lbu t0,1(a2)           // DP Indirect Indexed, Y = MEM_MAP[WORD[D_REG + Immediate] + Y_REG]
  addu t0,s6             // T0 = D_REG + Immediate
  addu a2,a0,t0          // A2 = MEM_MAP + D_REG + Immediate
  lbu t0,1(a2)           // T0 = DP Indirect WORD HI Byte
  sll t0,8               // T0 <<= 8
  lbu t1,0(a2)           // T1 = DP Indirect WORD LO Byte
  or t0,t1               // T0 = DP Indirect WORD
  addu t0,s2             // T0 = DP Indirect WORD + Y_REG
  addu a2,a0,t0          // A2 = MEM_MAP + DP Indirect WORD + Y_REG
  sb {reg},0(a2)         // DP Indirect Indexed, Y = Register LO Byte
  srl t1,{reg},8         // T1 = Register >> 8
  sb t1,1(a2)            // DP Indirect Indexed, Y = Register (16-Bit)

  la sp,StoreWord        // Store Word
  jalr sp,sp
}

macro StoreDPX8(reg) { // Store 8-Bit Register To Direct Page (DP) Indexed, X Memory
  lbu t0,1(a2)         // DP Indexed, X = MEM_MAP[D_REG + Immediate + X_REG]
  addu t0,s6           // T0 = D_REG + Immediate
  addu t0,s1           // T0 = D_REG + Immediate + X_REG
  addu a2,a0,t0        // A2 = MEM_MAP + D_REG + Immediate + X_REG
  sb {reg},0(a2)       // DP Indexed, X = Register (8-Bit)

  la sp,StoreByte      // Store Byte
  jalr sp,sp
}

macro StoreDPX16(reg) { // Store 16-Bit Register To Direct Page (DP) Indexed, X Memory
  lbu t0,1(a2)          // DP Indexed, X = MEM_MAP[D_REG + Immediate + X_REG]
  addu t0,s6            // T0 = D_REG + Immediate
  addu t0,s1            // T0 = D_REG + Immediate + X_REG
  addu a2,a0,t0         // A2 = MEM_MAP + D_REG + Immediate + X_REG
  sb {reg},0(a2)        // DP Indexed, X = Register LO Byte
  srl t1,{reg},8        // T1 = Register >> 8
  sb t1,1(a2)           // DP Indexed, X = Register (16-Bit)

  la sp,StoreWord       // Store Word
  jalr sp,sp
}

macro StoreDPY8(reg) { // Store 8-Bit Register To Direct Page (DP) Indexed, Y Memory
  lbu t0,1(a2)         // DP Indexed, Y = MEM_MAP[D_REG + Immediate + Y_REG]
  addu t0,s6           // T0 = D_REG + Immediate
  addu t0,s2           // T0 = D_REG + Immediate + Y_REG
  addu a2,a0,t0        // A2 = MEM_MAP + D_REG + Immediate + Y_REG
  sb {reg},0(a2)       // DP Indexed, Y = Register (8-Bit)

  la sp,StoreByte      // Store Byte
  jalr sp,sp
}

macro StoreDPY16(reg) { // Store 16-Bit Register To Direct Page (DP) Indexed, Y Memory
  lbu t0,1(a2)          // DP Indexed, Y = MEM_MAP[D_REG + Immediate + Y_REG]
  addu t0,s6            // T0 = D_REG + Immediate
  addu t0,s2            // T0 = D_REG + Immediate + Y_REG
  addu a2,a0,t0         // A2 = MEM_MAP + D_REG + Immediate + Y_REG
  sb {reg},0(a2)        // DP Indexed, Y = Register LO Byte
  srl t1,{reg},8        // T1 = Register >> 8
  sb t1,1(a2)           // DP Indexed, Y = Register (16-Bit)

  la sp,StoreWord       // Store Word
  jalr sp,sp
}

macro StoreSR8(reg) { // Store 8-Bit Register To Stack Relative (SR) Memory
  lbu t0,1(a2)        // SR = MEM_MAP[Immediate + S_REG]
  addu t0,s4          // T0 = Immediate + S_REG
  addu a2,a0,t0       // A2 = MEM_MAP + Immediate + S_REG
  sb {reg},0(a2)      // SR = Register (8-Bit)

  la sp,StoreByte     // Store Byte
  jalr sp,sp
}

macro StoreSR16(reg) { // Store 16-Bit Register To Stack Relative (SR) Memory
  lbu t0,1(a2)         // SR = MEM_MAP[Immediate + S_REG]
  addu t0,s4           // T0 = Immediate + S_REG
  addu a2,a0,t0        // A2 = MEM_MAP + Immediate + S_REG
  sb {reg},0(a2)       // SR = Register LO Byte
  srl t1,{reg},8       // T1 = Register >> 8
  sb t1,1(a2)          // SR = Register (16-Bit)

  la sp,StoreWord      // Store Word
  jalr sp,sp
}

macro StoreSRIY8(reg) { // Store 8-Bit Register To Stack Relative (SR) Indirect Indexed, Y Memory
  lbu t0,1(a2)          // SR Indirect Indexed, Y = MEM_MAP[WORD[Immediate + S_REG] + Y_REG]
  addu t0,s4            // T0 = Immediate + S_REG
  addu a2,a0,t0         // A2 = MEM_MAP + Immediate + S_REG
  lbu t0,1(a2)          // T0 = SR Indirect WORD HI Byte
  sll t0,8              // T0 <<= 8
  lbu t1,0(a2)          // T1 = SR Indirect WORD LO Byte
  or t0,t1              // T0 = SR Indirect WORD
  addu t0,s2            // T0 = SR Indirect WORD + Y_REG
  addu a2,a0,t0         // A2 = MEM_MAP + SR Indirect WORD + Y_REG
  sb {reg},0(a2)        // SR Indirect Indexed, Y = Register (8-Bit)

  la sp,StoreByte       // Store Byte
  jalr sp,sp
}

macro StoreSRIY16(reg) { // Store 16-Bit Register To Stack Relative (SR) Indirect Indexed, Y Memory
  lbu t0,1(a2)           // SR Indirect Indexed, Y = MEM_MAP[WORD[Immediate + S_REG] + Y_REG]
  addu t0,s4             // T0 = Immediate + S_REG
  addu a2,a0,t0          // A2 = MEM_MAP + Immediate + S_REG
  lbu t0,1(a2)           // T0 = SR Indirect WORD HI Byte
  sll t0,8               // T0 <<= 8
  lbu t1,0(a2)           // T1 = SR Indirect WORD LO Byte
  or t0,t1               // T0 = SR Indirect WORD
  addu t0,s2             // T0 = SR Indirect WORD + Y_REG
  addu a2,a0,t0          // A2 = MEM_MAP + SR Indirect WORD + Y_REG
  sb {reg},0(a2)         // SR Indirect Indexed, Y = Register LO Byte
  srl t1,{reg},8         // T1 = Register >> 8
  sb t1,1(a2)            // SR Indirect Indexed, Y = Register (16-Bit)

  la sp,StoreWord        // Store Word
  jalr sp,sp
}

//-----------------
// CPU Flag Macros
//-----------------
macro REPEMU() { // Reset Status Bits (Emulation Mode)
  lbu t0,1(a2)             // T0 = Immediate (8-Bit)
  andi t0,~(B_FLAG+U_FLAG) // Ignore Break & Unused Flags (6502 Emulation Mode)
  xori t0,$FF              // Convert Immediate To Reset Bits
  ori t0,E_FLAG            // Preserve Emulation Flag
  and s5,t0                // P_REG: Immediate Flags Reset (8-Bit)
}

macro REPNAT() { // Reset Status Bits (Native Mode)
  lbu t0,1(a2)   // T0 = Immediate (8-Bit)
  xori t0,$FF    // Convert Immediate To Reset Bits
  ori t0,E_FLAG  // Preserve Emulation Flag
  and s5,t0      // P_REG: Immediate Flags Reset (8-Bit)
}

macro SEPEMU() { // Reset Status Bits (Emulation Mode)
  lbu t0,1(a2)             // T0 = Immediate (8-Bit)
  andi t0,~(B_FLAG+U_FLAG) // Ignore Break & Unused Flags (6502 Emulation Mode)
  or s5,t0                 // P_REG: Immediate Flags Set (8-Bit)
}

macro SEPNAT() { // Reset Status Bits (Native Mode)
  lbu t0,1(a2)   // T0 = Immediate (8-Bit)
  or s5,t0       // P_REG: Immediate Flags Set (8-Bit)
}

macro TestNVZBIT8(reg) { // Test BIT 8-Bit Result Negative / Overflow / Zero Flags Of Register
  andi t1,{reg},$C0        // Test Negative MSB / Overflow MSB-1
  andi s5,~(N_FLAG+V_FLAG) // P_REG: N/V Flag Reset
  or s5,t1                 // P_REG: N/V Flag = Result Negative MSB / Overflow MSB-1
  and {reg},s0             // Result AND Accumulator (8-Bit)
  beqz {reg},{#}NVZBIT8    // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG            // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG          // P_REG: Z Flag Reset
  {#}NVZBIT8:
}

macro TestNVZBIT16(reg) { // Test BIT 16-Bit Result Negative / Overflow / Zero Flags Of Register
  andi t1,{reg},$C000      // Test Negative MSB / Overflow MSB-1
  srl t1,8                 // T1 >>= 8
  andi s5,~(N_FLAG+V_FLAG) // P_REG: N/V Flag Reset
  or s5,t1                 // P_REG: N/V Flag = Result Negative MSB / Overflow MSB-1
  and {reg},s0             // Result AND Accumulator (16-Bit)
  beqz {reg},{#}NVZBIT16   // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG            // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG          // P_REG: Z Flag Reset
  {#}NVZBIT16:
}

macro TestNVZCADC8(reg) { // Test ADC 8-Bit Result Negative / Overflow / Zero / Carry Flags Of Register
  andi t1,s5,D_FLAG        // T1 = D Flag
  beqz t1,{#}NVZCADCBIN    // IF (D Flag == 0) Binary Mode, ELSE Decimal Mode
  andi t1,s5,C_FLAG        // T1 = C Flag (Delay Slot)

  ori t8,r0,1              // T8 = 1 (Nibble Count)
  la t9,ADCBCD             // T9 = ADC BCD Calculation
  jalr t9,t9               // Run ADC BCD Calculation
  nop                      // Delay Slot

  or {reg},t1,r0           // Register = A
  b {#}NVZCADC8V
  ori s5,V_FLAG            // P_REG: V Flag Set (Delay Slot)

  {#}NVZCADCBIN:
  addu {reg},t1            // Register += C Flag
  andi t1,{reg},$80        // 8-Bit Sign Extend (A_REG + C Flag)
  sll t1,1
  or {reg},t1
  addu {reg},t0            // Register += Memory (8-Bit)

  andi t0,{reg},$0180      // Test Signed Overflow
  ori t1,r0,$0180          // T1 = $0180
  beq t0,t1,{#}NVZCADC8V   // IF (Signed Overflow) V Flag Set
  ori s5,V_FLAG            // P_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG          // P_REG: V Flag Reset
  {#}NVZCADC8V:
  andi t1,{reg},$80        // Test Negative MSB
  andi s5,~N_FLAG          // P_REG: N Flag Reset
  or s5,t1                 // P_REG: N Flag = Result MSB
  andi t0,{reg},$0180      // Test Unsigned Overflow
  ori t1,r0,$0100          // T1 = $0100
  beq t0,t1,{#}NVZCADC8C   // IF (Unsigned Overflow) C Flag Set
  ori s5,C_FLAG            // P_REG: C Flag Set (Delay Slot)
  andi s5,~C_FLAG          // P_REG: C Flag Reset
  {#}NVZCADC8C:
  andi {reg},$FF           // Register = 8-Bit
  beqz {reg},{#}NVZCADC8Z  // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG            // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG          // P_REG: Z Flag Reset
  {#}NVZCADC8Z:
}

macro TestNVZCADC16(reg) { // Test ADC 16-Bit Result Negative / Overflow / Zero / Carry Flags Of Register
  andi t1,s5,D_FLAG        // T1 = D Flag
  beqz t1,{#}NVZCADCBIN    // IF (D Flag == 0) Binary Mode, ELSE Decimal Mode
  andi t1,s5,C_FLAG        // T1 = C Flag (Delay Slot)

  ori t8,r0,3              // T8 = 3 (Nibble Count)
  la t9,ADCBCD             // T9 = ADC BCD Calculation
  jalr t9,t9               // Run ADC BCD Calculation
  nop                      // Delay Slot

  or {reg},t1,r0           // Register = A
  b {#}NVZCADC16V
  ori s5,V_FLAG            // P_REG: V Flag Set (Delay Slot)

  {#}NVZCADCBIN:
  addu {reg},t1            // Register += C Flag
  andi t1,{reg},$8000      // 16-Bit Sign Extend (A_REG + C Flag)
  sll t1,1
  or {reg},t1
  addu {reg},t0            // Register += Memory (16-Bit)

  li t1,$00018000          // Test Signed Overflow
  and t0,{reg},t1
  beq t0,t1,{#}NVZCADC16V  // IF (Signed Overflow) V Flag Set
  ori s5,V_FLAG            // P_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG          // P_REG: V Flag Reset
  {#}NVZCADC16V:
  andi t1,{reg},$8000      // Test Negative MSB
  srl t1,8                 // T1 >>= 8
  andi s5,~N_FLAG          // P_REG: N Flag Reset
  or s5,t1                 // P_REG: N Flag = Result MSB
  li t1,$00018000          // Test Unsigned Overflow
  and t0,{reg},t1
  lui t1,$0001             // T1 = $00010000
  beq t0,t1,{#}NVZCADC16C  // IF (Unsigned Overflow) C Flag Set
  ori s5,C_FLAG            // P_REG: C Flag Set (Delay Slot)
  andi s5,~C_FLAG          // P_REG: C Flag Reset
  {#}NVZCADC16C:
  andi {reg},$FFFF         // Register = 16-Bit
  beqz {reg},{#}NVZCADC16Z // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG            // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG          // P_REG: Z Flag Reset
  {#}NVZCADC16Z:
}

macro TestNVZCSBC8(reg) { // Test SBC 8-Bit Result Negative / Overflow / Zero / Carry Flags Of Register
  andi t1,s5,D_FLAG        // T1 = D Flag
  beqz t1,{#}NVZCSBCBIN    // IF (D Flag == 0) Binary Mode, ELSE Decimal Mode
  andi t1,s5,C_FLAG        // T1 = C Flag (Delay Slot)
  subiu t1,1               // T1 = C Flag - 1

  ori t8,r0,1              // T8 = 1 (Nibble Count)
  la t9,SBCBCD             // T9 = SBC BCD Calculation
  jalr t9,t9               // Run SBC BCD Calculation
  nop                      // Delay Slot

  or {reg},t1,r0           // Register = A
  b {#}NVZCSBC8V
  andi s5,~V_FLAG          // P_REG: V Flag Reset (Delay Slot)

  {#}NVZCSBCBIN:
  subiu t1,1               // T1 = C Flag - 1
  addu {reg},t1            // Register += C Flag
  andi t1,{reg},$80        // 8-Bit Sign Extend (A_REG + C Flag)
  sll t1,1
  or {reg},t1
  subu {reg},t0            // Register += Memory (8-Bit)

  andi t0,{reg},$0180      // Test Signed Overflow
  ori t1,r0,$0180          // T1 = $0180
  beq t0,t1,{#}NVZCSBC8V   // IF (Signed Overflow) V Flag Set
  ori s5,V_FLAG            // P_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG          // P_REG: V Flag Reset
  {#}NVZCSBC8V:
  andi t1,{reg},$80        // Test Negative MSB
  andi s5,~N_FLAG          // P_REG: N Flag Reset
  or s5,t1                 // P_REG: N Flag = Result MSB
  andi t0,{reg},$0180      // Test Unsigned Borrow
  beqz t0,{#}NVZCSBC8C     // IF (Unsigned Borrow) C Flag Reset
  ori s5,C_FLAG            // P_REG: C Flag Set (Delay Slot)
  andi s5,~C_FLAG          // P_REG: C Flag Reset
  {#}NVZCSBC8C:
  andi {reg},$FF           // Register = 8-Bit
  beqz {reg},{#}NVZCSBC8Z  // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG            // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG          // P_REG: Z Flag Reset
  {#}NVZCSBC8Z:
}

macro TestNVZCSBC16(reg) { // Test SBC 16-Bit Result Negative / Overflow / Zero / Carry Flags Of Register
  andi t1,s5,D_FLAG        // T1 = D Flag
  beqz t1,{#}NVZCSBCBIN    // IF (D Flag == 0) Binary Mode, ELSE Decimal Mode
  andi t1,s5,C_FLAG        // T1 = C Flag (Delay Slot)
  subiu t1,1               // T1 = C Flag - 1

  ori t8,r0,3              // T8 = 3 (Nibble Count)
  la t9,SBCBCD             // T9 = SBC BCD Calculation
  jalr t9,t9               // Run SBC BCD Calculation
  nop                      // Delay Slot

  or {reg},t1,r0           // Register = A
  b {#}NVZCSBC16V
  andi s5,~V_FLAG          // P_REG: V Flag Reset (Delay Slot)

  {#}NVZCSBCBIN:
  subiu t1,1               // T1 = C Flag - 1
  addu {reg},t1            // Register += C Flag - 1
  andi t1,{reg},$8000      // 16-Bit Sign Extend (A_REG + C Flag)
  sll t1,1
  or {reg},t1
  subu {reg},t0            // Register -= Memory (16-Bit)

  li t1,$00018000          // Test Signed Overflow
  and t0,{reg},t1
  beq t0,t1,{#}NVZCSBC16V  // IF (Signed Overflow) V Flag Set
  ori s5,V_FLAG            // P_REG: V Flag Set (Delay Slot)
  andi s5,~V_FLAG          // P_REG: V Flag Reset
  {#}NVZCSBC16V:
  andi t1,{reg},$8000      // Test Negative MSB
  srl t1,8                 // T1 >>= 8
  andi s5,~N_FLAG          // P_REG: N Flag Reset
  or s5,t1                 // P_REG: N Flag = Result MSB
  li t1,$00018000          // Test Unsigned Borrow
  and t0,{reg},t1
  beqz t0,{#}NVZCSBC16C    // IF (Unsigned Borrow) C Flag Reset
  ori s5,C_FLAG            // P_REG: C Flag Set (Delay Slot)
  andi s5,~C_FLAG          // P_REG: C Flag Reset
  {#}NVZCSBC16C:
  andi {reg},$FFFF         // Register = 16-Bit
  beqz {reg},{#}NVZCSBC16Z // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG            // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG          // P_REG: Z Flag Reset
  {#}NVZCSBC16Z:
}

macro TestZBIT(reg) { // Test 8-Bit / 16-Bit Result Zero Flag Of Register Against Accumulator
  and {reg},s0        // Result AND Accumulator (8-Bit)
  beqz {reg},{#}ZBIT  // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG       // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG     // P_REG: Z Flag Reset
  {#}ZBIT:
}

macro TestNZ8(reg) { // Test 8-Bit Result Negative / Zero Flags Of Register
  andi t1,{reg},$80  // Test Negative MSB
  andi s5,~N_FLAG    // P_REG: N Flag Reset
  or s5,t1           // P_REG: N Flag = Result MSB
  beqz {reg},{#}NZ8  // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG      // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG    // P_REG: Z Flag Reset
  {#}NZ8:
}

macro TestNZ16(reg) { // Test 16-Bit Result Negative / Zero Flags Of Register
  andi t1,{reg},$8000 // Test Negative MSB
  srl t1,8            // T1 >>= 8
  andi s5,~N_FLAG     // P_REG: N Flag Reset
  or s5,t1            // P_REG: N Flag = Result MSB
  beqz {reg},{#}NZ16  // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG       // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG     // P_REG: Z Flag Reset
  {#}NZ16:
}

macro TestNZCASLROL8(reg) { // Test ASL / ROL 8-Bit Result Negative / Zero / Carry Flags Of Register
  andi t1,{reg},$80         // Test Negative MSB
  srl t2,{reg},8            // Test Carry
  or t1,t2                  // T1 = N/C Flag
  andi s5,~(N_FLAG+C_FLAG)  // P_REG: N/C Flag Reset
  or s5,t1                  // P_REG: N/C Flag = Result MSB / Carry
  andi {reg},$FF            // Register = 8-Bit
  beqz {reg},{#}NZCASLROL8  // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG             // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG           // P_REG: Z Flag Reset
  {#}NZCASLROL8:
}

macro TestNZCASLROL16(reg) { // Test ASL / ROL 16-Bit Result Negative / Zero / Carry Flags Of Register
  andi t1,{reg},$8000        // Test Negative MSB
  srl t1,8                   // T1 = N Flag
  srl t2,{reg},16            // Test Carry
  or t1,t2                   // T1 = N/C Flag
  andi s5,~(N_FLAG+C_FLAG)   // P_REG: N/C Flag Reset
  or s5,t1                   // P_REG: N/C Flag = Result MSB / Carry
  andi {reg},$FFFF           // Register = 16-Bit
  beqz {reg},{#}NZCASLROL16  // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG              // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG            // P_REG: Z Flag Reset
  {#}NZCASLROL16:
}

macro TestNZCLSRROR(reg) { // Test LSR / ROR 8-Bit / 16-Bit Result Negative / Zero / Carry Flags Of Register
  andi s5,~(N_FLAG+C_FLAG) // P_REG: N/C Flag Reset
  or s5,t1                 // P_REG: N/C Flag = Result MSB / Carry
  beqz {reg},{#}NZCLSRROL  // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG            // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG          // P_REG: Z Flag Reset
  {#}NZCLSRROL:
}

macro TestNZCCMP8(reg) { // Test CMP 8-Bit Result Negative / Zero / Carry Flags Of Register
  blt {reg},t0,{#}NZCMP8C // IF (Register < T0) C Flag Reset
  andi s5,~C_FLAG         // P_REG: C Flag Reset (Delay Slot)
  ori s5,C_FLAG           // P_REG: C Flag Set
  {#}NZCMP8C:
  subu t0,{reg},t0        // T0 = Register - T0 (8-Bit)
  andi t1,t0,$80          // Test Negative MSB
  andi s5,~N_FLAG         // P_REG: N Flag Reset
  or s5,t1                // P_REG: N Flag = Result MSB
  beqz t0,{#}NZCMP8Z      // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG           // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG         // P_REG: Z Flag Reset
  {#}NZCMP8Z:
}

macro TestNZCCMP16(reg) { // Test CMP 16-Bit Result Negative / Zero / Carry Flags Of Register
  blt {reg},t0,{#}NZCMP16C // IF (Register < T0) C Flag Reset
  andi s5,~C_FLAG          // P_REG: C Flag Reset (Delay Slot)
  ori s5,C_FLAG            // P_REG: C Flag Set
  {#}NZCMP16C:
  subu t0,{reg},t0         // T0 = Register - T0 (16-Bit)
  andi t1,t0,$8000         // Test Negative MSB
  srl t1,8                 // T1 = N Flag
  andi s5,~N_FLAG          // P_REG: N Flag Reset
  or s5,t1                 // P_REG: N Flag = Result MSB
  beqz t0,{#}NZCMP16Z      // IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG            // P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG          // P_REG: Z Flag Reset
  {#}NZCMP16Z:
}

macro XCE() { // Exchange Carry & Emulation Bits
  andi t0,s5,C_FLAG        // T0 = P_REG: C Flag
  andi t1,s5,E_FLAG        // T1 = P_REG: E Flag
  sll t0,8                 // T0 = E Flag
  srl t1,8                 // T1 = C Flag
  or t1,t0                 // T1 = C Flag = E Flag / E Flag = C Flag
  andi s5,~(C_FLAG+E_FLAG) // P_REG: C + E Flag Reset
  or s5,t1                 // P_REG: Exchange Carry & Emulation Bits
  beqz t0,{#}XCENAT        // IF (E Flag == 0) Native Mode
  ori s5,M_FLAG+X_FLAG     // P_REG: M + X Flag Set (Native Mode) (Delay Slot)
  andi s5,~(M_FLAG+X_FLAG) // P_REG: M + X Flag Reset (Emulation Mode)
  andi s1,$FF              // X_REG = 8-Bit (Emulation Mode)
  andi s2,$FF              // Y_REG = 8-Bit (Emulation Mode)
  andi s4,$FF              // S_REG = 8-Bit (Emulation Mode)
  {#}XCENAT:
}

//----------------------
// CPU Interrupt Macros
//----------------------
macro BRKEMU() { // Software Break (Emulation Mode)
  ori a2,s4,$100        // STACK = MEM_MAP[01:S_REG]
  addu a2,a0            // A2 = MEM_MAP + 01:S_REG
  addiu s3,1            // PC_REG++ (Increment Program Counter)
  sb s3,-1(a2)          // STACK = PC_REG LO Byte
  srl t0,s3,8           // T0 = PC_REG HI Byte
  sb t0,0(a2)           // STACK = PC_REG (16-Bit)
  ori s5,B_FLAG         // P_REG: B Flag Set (6502 Emulation Mode)                 
  sb s5,-2(a2)          // STACK = P_REG
  ori s5,I_FLAG         // P_REG: I Flag Set
  andi s5,~D_FLAG       // P_REG: D Flag Reset
  ori a2,r0,IRQ2_VEC    // A2 = IRQ2_VEC
  addu a2,a0            // A2 = MEM_MAP + IRQ2_VEC
  lbu t0,1(a2)          // T0 = 6502 IRQ Vector HI Byte
  sll t0,8              // T0 <<= 8
  lbu s3,0(a2)          // PC_REG = 6502 IRQ Vector LO Byte
  or s3,t0              // PC_REG = 6502 IRQ Vector ($FFFE)
  subiu s4,3            // S_REG -= 3 (Decrement Stack)
  andi s4,$FF           // S_REG = 8-Bit
}

macro BRKNAT() { // Software Break (Native Mode)
  addu a2,a0,s4         // STACK = MEM_MAP[S_REG]
  sb s8,0(a2)           // STACK = PB_REG (65816 Native Mode)
  and s8,r0             // PB_REG = 0 (65816 Native Mode)
  addiu s3,1            // PC_REG++ (Increment Program Counter)
  sb s3,-2(a2)          // STACK = PC_REG LO Byte
  srl t0,s3,8           // T0 = PC_REG HI Byte
  sb t0,-1(a2)          // STACK = PC_REG (16-Bit)                 
  sb s5,-3(a2)          // STACK = P_REG
  ori s5,I_FLAG         // P_REG: I Flag Set
  andi s5,~D_FLAG       // P_REG: D Flag Reset
  ori a2,r0,BRK1_VEC    // A2 = BRK1_VEC
  addu a2,a0            // A2 = MEM_MAP + BRK1_VEC
  lbu t0,1(a2)          // T0 = 65816 Break Vector HI Byte
  sll t0,8              // T0 <<= 8
  lbu s3,0(a2)          // PC_REG = 65816 Break Vector LO Byte
  or s3,t0              // PC_REG = 65816 Break Vector ($FFE6)
  subiu s4,4            // S_REG -= 4 (Decrement Stack)
  andi s4,$FFFF         // S_REG = 16-Bit
}

macro COPEMU() { // Co-Processor Enable (Emulation Mode)
  ori a2,s4,$100        // STACK = MEM_MAP[01:S_REG]
  addu a2,a0            // A2 = MEM_MAP + 01:S_REG
  addiu s3,1            // PC_REG++ (Increment Program Counter)
  sb s3,-1(a2)          // STACK = PC_REG LO Byte
  srl t0,s3,8           // T0 = PC_REG HI Byte
  sb t0,0(a2)           // STACK = PC_REG (16-Bit)
  ori s5,B_FLAG         // P_REG: B Flag Set (6502 Emulation Mode)                 
  sb s5,-2(a2)          // STACK = P_REG
  ori s5,I_FLAG         // P_REG: I Flag Set
  andi s5,~D_FLAG       // P_REG: D Flag Reset
  ori a2,r0,COP2_VEC    // A2 = COP2_VEC
  addu a2,a0            // A2 = MEM_MAP + COP2_VEC
  lbu t0,1(a2)          // T0 = 6502 COP Vector HI Byte
  sll t0,8              // T0 <<= 8
  lbu s3,0(a2)          // PC_REG = 6502 COP Vector LO Byte
  or s3,t0              // PC_REG = 6502 COP Vector ($FFF4)
  subiu s4,3            // S_REG -= 3 (Decrement Stack)
  andi s4,$FF           // S_REG = 8-Bit
}

macro COPNAT() { // Co-Processor Enable (Native Mode)
  addu a2,a0,s4         // STACK = MEM_MAP[S_REG]
  sb s8,0(a2)           // STACK = PB_REG (65816 Native Mode)
  and s8,r0             // PB_REG = 0 (65816 Native Mode)
  addiu s3,1            // PC_REG++ (Increment Program Counter)
  sb s3,-2(a2)          // STACK = PC_REG LO Byte
  srl t0,s3,8           // T0 = PC_REG HI Byte
  sb t0,-1(a2)          // STACK = PC_REG (16-Bit)                 
  sb s5,-3(a2)          // STACK = P_REG
  ori s5,I_FLAG         // P_REG: I Flag Set
  andi s5,~D_FLAG       // P_REG: D Flag Reset
  ori a2,r0,COP1_VEC    // A2 = COP1_VEC
  addu a2,a0            // A2 = MEM_MAP + COP1_VEC
  lbu t0,1(a2)          // T0 = 65816 COP Vector HI Byte
  sll t0,8              // T0 <<= 8
  lbu s3,0(a2)          // PC_REG = 65816 COP Vector LO Byte
  or s3,t0              // PC_REG = 65816 COP Vector ($FFE4)
  subiu s4,4            // S_REG -= 4 (Decrement Stack)
  andi s4,$FFFF         // S_REG = 16-Bit
}

//-----------------
// CPU Jump Macros
//-----------------
macro JumpABSI16() { // Jump 16-Bit Absolute Indirect Memory To PC
  lbu t0,2(a2)       // Absolute Indirect = MEM_MAP[00:Immediate]
  sll t0,8           // T0 = Immediate HI Byte
  lbu t1,1(a2)       // T1 = Immediate LO Byte
  or t0,t1           // T0 = 00:Immediate (16-Bit)
  addu a2,a0,t0      // A2 = MEM_MAP + 00:Immediate
  lbu s3,1(a2)       // PC_REG = Absolute Indirect HI Byte
  sll s3,8           // PC_REG <<= 8
  lbu t1,0(a2)       // T1 = Absolute Indirect LO Byte
  or s3,t1           // PC_REG = Absolute Indirect (16-Bit)
}

macro JumpABSIX16() { // Jump 16-Bit Absolute Indexed Indirect Memory To PC
  lbu t0,2(a2)        // Absolute Indexed Indirect = MEM_MAP[PB_REG:Immediate + X_REG]
  sll t0,8            // T0 = Immediate HI Byte
  lbu t1,1(a2)        // T1 = Immediate LO Byte
  or t0,t1            // T0 = Immediate (16-Bit)
  sll t1,s8,16        // T1 = PB_REG << 16 
  or t0,t1            // T0 = PB_REG:Immediate
  addu t0,s1          // T0 = PB_REG:Immediate + X_REG
  addu a2,a0,t0       // A2 = MEM_MAP + PB_REG:Immediate + X_REG
  lbu s3,1(a2)        // PC_REG = Absolute Indexed Indirect HI Byte
  sll s3,8            // PC_REG <<= 8
  lbu t1,0(a2)        // T1 = Absolute Indexed Indirect LO Byte
  or s3,t1            // PC_REG = Absolute Indexed Indirect (16-Bit)
}

//-------------------
// CPU Return Macros
//-------------------
macro RTIEMU() { // Return From Interrupt (Emulation Mode)
  addiu s4,3     // S_REG += 3 (Increment Stack)
  andi s4,$FF    // S_REG = 8-Bit
  ori a2,s4,$100 // STACK = MEM_MAP[01:S_REG]
  addu a2,a0     // A2 = MEM_MAP + 01:S_REG
  lbu s5,-2(a2)  // P_REG = STACK (8-Bit)
  ori s5,E_FLAG  // P_REG: E Flag Set (Emulation Mode)
  lbu t0,0(a2)   // T0 = STACK HI Byte
  sll t0,8       // T0 <<= 8
  lbu s3,-1(a2)  // PC_REG = STACK LO Byte
  or s3,t0       // PC_REG = STACK (16-Bit)
  
}

macro RTINAT() { // Return From Interrupt (Native Mode)
  addiu s4,4     // S_REG += 4 (Increment Stack)
  andi s4,$FFFF  // S_REG = 16-Bit
  addu a2,a0,s4  // STACK = MEM_MAP[S_REG]
  lbu s5,-3(a2)  // P_REG = STACK (8-Bit)
  lbu t0,-1(a2)  // T0 = STACK HI Byte
  sll t0,8       // T0 <<= 8
  lbu s3,-2(a2)  // PC_REG = STACK LO Byte
  or s3,t0       // PC_REG = STACK (16-Bit)
  lbu s8,0(a2)   // PB_REG = STACK (8-Bit)
}

macro RTLNAT() { // Return from Subroutine Long (Native Mode)
  addiu s4,3     // S_REG += 3 (Increment Stack)
  andi s4,$FFFF  // S_REG = 16-Bit
  addu a2,a0,s4  // STACK = MEM_MAP[S_REG]
  lbu t0,-1(a2)  // T0 = STACK HI Byte
  sll t0,8       // T0 <<= 8
  lbu s3,-2(a2)  // PC_REG = STACK LO Byte
  or s3,t0       // PC_REG = STACK (16-Bit)
  lbu s8,0(a2)   // PB_REG = STACK (8-Bit)
}

//------------------
// CPU Stack Macros
//------------------
macro PullEMU8(reg) { // Pull 8-Bit Register From Stack (Emulation Mode)
  addiu s4,1          // S_REG++ (Increment Stack)
  andi s4,$FF         // S_REG = 8-Bit
  ori a2,s4,$100      // STACK = MEM_MAP[01:S_REG]
  addu a2,a0          // A2 = MEM_MAP + 01:S_REG
  lbu {reg},0(a2)     // Register = STACK (8-Bit)
}

macro PullEMU16(reg) { // Pull 16-Bit Register From Stack (Emulation Mode)
  addiu s4,2           // S_REG += 2 (Increment Stack)
  andi s4,$FF          // S_REG = 8-Bit
  ori a2,s4,$100       // STACK = MEM_MAP[01:S_REG]
  addu a2,a0           // A2 = MEM_MAP + 01:S_REG
  lbu {reg},0(a2)      // Register = STACK HI Byte
  sll {reg},8          // Register <<= 8
  lbu t0,-1(a2)        // T0 = STACK LO Byte
  or {reg},t0          // Register = STACK (16-Bit)
}

macro PullNAT8(reg) { // Pull 8-Bit Register From Stack (Native Mode)
  addiu s4,1          // S_REG++ (Increment Stack)
  andi s4,$FFFF       // S_REG = 16-Bit
  addu a2,a0,s4       // STACK = MEM_MAP[S_REG]
  lbu {reg},0(a2)     // Register = STACK (8-Bit)
}

macro PullNAT16(reg) { // Pull 16-Bit Register From Stack (Native Mode)
  addiu s4,2           // S_REG += 2 (Increment Stack)
  andi s4,$FFFF        // S_REG = 16-Bit
  addu a2,a0,s4        // STACK = MEM_MAP[S_REG]
  lbu {reg},0(a2)      // Register = STACK HI Byte
  sll {reg},8          // Register <<= 8
  lbu t0,-1(a2)        // T0 = STACK LO Byte
  or {reg},t0          // Register = STACK (16-Bit)
}

macro PushEA16() { // Push 16-Bit Effective Absolute Address To Stack
  lbu t0,1(a2)     // T0 = Effective Absolute Address LO Byte
  lbu t1,2(a2)     // T1 = Effective Absolute Address HI Byte
  addu a2,a0,s4    // STACK = MEM_MAP[S_REG]
  sb t0,-1(a2)     // STACK = Effective Absolute Address LO Byte
  sb t1,0(a2)      // STACK = Effective Absolute Address (16-Bit)
  subiu s4,2       // S_REG -= 2 (Decrement Stack)
  andi s4,$FFFF    // S_REG = 16-Bit
}

macro PushEI16() { // Push 16-Bit Effective Indirect Address To Stack
  lbu t0,1(a2)     // DP = MEM_MAP[D_REG + Immediate]
  addu t0,s6       // T0 = D_REG + Immediate
  addu a2,a0,t0    // A2 = MEM_MAP + D_REG + Immediate
  lbu t0,0(a2)     // T0 = Effective Indirect Address LO Byte
  lbu t1,1(a2)     // T1 = Effective Indirect Address HI Byte
  addu a2,a0,s4    // STACK = MEM_MAP[S_REG]
  sb t0,-1(a2)     // STACK = Effective Indirect Address LO Byte
  sb t1,0(a2)      // STACK = Effective Indirect Address (16-Bit)
  subiu s4,2       // S_REG -= 2 (Decrement Stack)
  andi s4,$FFFF    // S_REG = 16-Bit
}

macro PushER16() { // Push 16-Bit Effective PC Relative Indirect Address To Stack
  lb t0,2(a2)      // Effective PC Relative Indirect Address = PC_REG + Relative Indirect Address
  sll t0,8         // T0 = Effective Relative Indirect Address HI Byte (Signed)
  lbu t1,1(a2)     // T0 = Effective Relative Indirect Address LO Byte
  or t0,t1         // T0 = Effective Relative Indirect Address (Signed)
  add t0,s3,t0     // T0 = Effective PC Relative Indirect Address (16-Bit)
  addu a2,a0,s4    // STACK = MEM_MAP[S_REG]
  sb t0,-1(a2)     // STACK = Effective PC Relative Indirect Address LO Byte
  srl t0,8         // T0 = Effective PC Relative Indirect Address HI Byte
  sb t0,0(a2)      // STACK = Effective PC Relative Indirect Address (16-Bit)
  subiu s4,2       // S_REG -= 2 (Decrement Stack)
  andi s4,$FFFF    // S_REG = 16-Bit
}

macro PushEMU8(reg) { // Push 8-Bit Register To Stack (Emulation Mode)
  ori a2,s4,$100      // STACK = MEM_MAP[01:S_REG]
  addu a2,a0          // A2 = MEM_MAP + 01:S_REG
  sb {reg},0(a2)      // STACK = Register (8-Bit)
  subiu s4,1          // S_REG-- (Decrement Stack)
  andi s4,$FF         // S_REG = 8-Bit
}

macro PushEMU16(reg) { // Push 16-Bit Register To Stack (Emulation Mode)
  ori t1,s4,$100       // STACK = MEM_MAP[01:S_REG]
  addu t1,a0           // T1 = MEM_MAP + 01:S_REG
  sb {reg},-1(t1)      // STACK = Register LO Byte
  srl t0,{reg},8       // T0 = Register HI Byte
  sb t0,0(t1)          // STACK = Register (16-Bit)
  subiu s4,2           // S_REG -= 2 (Decrement Stack)
  andi s4,$FF          // S_REG = 8-Bit
}

macro PushNAT8(reg) { // Push 8-Bit Register To Stack (Native Mode)
  addu a2,a0,s4       // STACK = MEM_MAP[S_REG]
  sb {reg},0(a2)      // STACK = Register (8-Bit)
  subiu s4,1          // S_REG-- (Decrement Stack)
  andi s4,$FFFF       // S_REG = 16-Bit
}

macro PushNAT16(reg) { // Push 16-Bit Register To Stack (Native Mode)
  addu t1,a0,s4        // STACK = MEM_MAP[S_REG]
  sb {reg},-1(t1)      // STACK = Register LO Byte
  srl t0,{reg},8       // T0 = Register HI Byte
  sb t0,0(t1)          // STACK = Register (16-Bit)
  subiu s4,2           // S_REG -= 2 (Decrement Stack)
  andi s4,$FFFF        // S_REG = 16-Bit
}

macro PushNAT24(reg) { // Push 16-Bit Register & 8-Bit Program Bank To Stack (Native Mode)
  addu t1,a0,s4        // STACK = MEM_MAP[S_REG]
  sb {reg},-2(t1)      // STACK = Register LO Byte
  srl t0,{reg},8       // T0 = Register HI Byte
  sb t0,-1(t1)         // STACK = Register (16-Bit)
  sb s8,0(t1)          // STACK = PB_REG Byte (8-Bit)
  subiu s4,3           // S_REG -= 3 (Decrement Stack)
  andi s4,$FFFF        // S_REG = 16-Bit
}

//---------------------
// CPU BCD Subroutines
//---------------------
ADCBCD: // Calculate ADC BCD (S0 = A, T0 = B, T1 = C Flag, T8 = Nibble Count)
  ori t3,r0,$F           // T3 = $F
  ori t4,r0,$A           // T4 = $A
  ori t5,r0,$6           // T5 = $6
  ori t6,r0,$10          // T6 = $10
  ori t7,r0,$F           // T7 = $F
  ADCBCDLoop:
    and t2,s0,t3         // A = (A & $F) + (B & $F) + T1
    addu t1,t2           // T1 += (A & $F)
    and t2,t0,t3         // T2 = (B & $F)
    addu t1,t2           // T1 = A
    blt t1,t4,ADCBCDSkip // IF (A >= $A) A = ((A + $6) & $F) + $10
    nop                  // Delay Slot
    addu t1,t5           // A += $6
    and t1,t7            // A &= $F
    addu t1,t6           // A += $10
    ADCBCDSkip:
      sll t3,4           // T3 <<= 4
      sll t4,4           // T4 <<= 4
      sll t5,4           // T5 <<= 4
      sll t6,4           // T6 <<= 4
      sll t7,4           // T7 <<= 4
      ori t7,$F          // T7 &= $F
      bnez t8,ADCBCDLoop // IF (Nibble Count != 0) ADC BCD Loop
      subiu t8,1         // Nibble Count-- (Delay Slot)
      jr t9
      nop // Delay Slot

SBCBCD: // Calculate SBC BCD (S0 = A, T0 = B, T1 = C Flag - 1, T8 = Nibble Count)
  ori t3,r0,$F           // T3 = $F
  ori t4,r0,$6           // T4 = $6
  ori t5,r0,$10          // T5 = $10
  ori t6,r0,$F           // T6 = $F
  SBCBCDLoop:
    and t2,s0,t3         // A = (A & $F) - (B & $F) + T1
    addu t1,t2           // T1 += (A & $F)
    and t2,t0,t3         // T2 = (B & $F)
    subu t1,t2           // T1 = A
    bgez t1,SBCBCDSkip   // IF (A < 0) A = ((A - $6) & $F) - $10
    nop                  // Delay Slot
    subu t1,t4           // A -= $6
    and t1,t6            // A &= $F
    subu t1,t5           // A -= $10
    SBCBCDSkip:
      sll t3,4           // T3 <<= 4
      sll t4,4           // T4 <<= 4
      sll t5,4           // T5 <<= 4
      sll t6,4           // T6 <<= 4
      ori t6,$F          // T6 &= $F
      bnez t8,SBCBCDLoop // IF (Nibble Count != 0) SBC BCD Loop
      subiu t8,1         // Nibble Count-- (Delay Slot)
      jr t9
      nop // Delay Slot

CPU_INST:
// 65816 CPU Instruction Indirect Table (E = 0, X = 0, M = 0)
dw   CPU65816HEX00, CPU65816M0HEX01,   CPU65816HEX02, CPU65816M0HEX03, CPU65816M0HEX04, CPU65816M0HEX05, CPU65816M0HEX06, CPU65816M0HEX07,   CPU65816HEX08, CPU65816M0HEX09, CPU65816M0HEX0A,   CPU65816HEX0B, CPU65816M0HEX0C, CPU65816M0HEX0D, CPU65816M0HEX0E, CPU65816M0HEX0F
dw    CPU6502HEX10, CPU65816M0HEX11, CPU65816M0HEX12, CPU65816M0HEX13, CPU65816M0HEX14, CPU65816M0HEX15, CPU65816M0HEX16, CPU65816M0HEX17,    CPU6502HEX18, CPU65816M0HEX19, CPU65816M0HEX1A,   CPU65816HEX1B, CPU65816M0HEX1C, CPU65816M0HEX1D, CPU65816M0HEX1E, CPU65816M0HEX1F
dw   CPU65816HEX20, CPU65816M0HEX21,   CPU65816HEX22, CPU65816M0HEX23, CPU65816M0HEX24, CPU65816M0HEX25, CPU65816M0HEX26, CPU65816M0HEX27,   CPU65816HEX28, CPU65816M0HEX29, CPU65816M0HEX2A,   CPU65816HEX2B, CPU65816M0HEX2C, CPU65816M0HEX2D, CPU65816M0HEX2E, CPU65816M0HEX2F
dw    CPU6502HEX30, CPU65816M0HEX31, CPU65816M0HEX32, CPU65816M0HEX33, CPU65816M0HEX34, CPU65816M0HEX35, CPU65816M0HEX36, CPU65816M0HEX37,    CPU6502HEX38, CPU65816M0HEX39, CPU65816M0HEX3A,   CPU65816HEX3B, CPU65816M0HEX3C, CPU65816M0HEX3D, CPU65816M0HEX3E, CPU65816M0HEX3F
dw   CPU65816HEX40, CPU65816M0HEX41,   CPU65816HEX42, CPU65816M0HEX43,   CPU65816HEX44, CPU65816M0HEX45, CPU65816M0HEX46, CPU65816M0HEX47, CPU65816M0HEX48, CPU65816M0HEX49, CPU65816M0HEX4A,   CPU65816HEX4B,    CPU6502HEX4C, CPU65816M0HEX4D, CPU65816M0HEX4E, CPU65816M0HEX4F
dw    CPU6502HEX50, CPU65816M0HEX51, CPU65816M0HEX52, CPU65816M0HEX53,   CPU65816HEX54, CPU65816M0HEX55, CPU65816M0HEX56, CPU65816M0HEX57,    CPU6502HEX58, CPU65816M0HEX59, CPU65816X0HEX5A,   CPU65816HEX5B,   CPU65816HEX5C, CPU65816M0HEX5D, CPU65816M0HEX5E, CPU65816M0HEX5F
dw   CPU65816HEX60, CPU65816M0HEX61,   CPU65816HEX62, CPU65816M0HEX63, CPU65816M0HEX64, CPU65816M0HEX65, CPU65816M0HEX66, CPU65816M0HEX67, CPU65816M0HEX68, CPU65816M0HEX69, CPU65816M0HEX6A,   CPU65816HEX6B,    CPU6502HEX6C, CPU65816M0HEX6D, CPU65816M0HEX6E, CPU65816M0HEX6F
dw    CPU6502HEX70, CPU65816M0HEX71, CPU65816M0HEX72, CPU65816M0HEX73, CPU65816M0HEX74, CPU65816M0HEX75, CPU65816M0HEX76, CPU65816M0HEX77,    CPU6502HEX78, CPU65816M0HEX79, CPU65816X0HEX7A,   CPU65816HEX7B,   CPU65816HEX7C, CPU65816M0HEX7D, CPU65816M0HEX7E, CPU65816M0HEX7F
dw   CPU65816HEX80, CPU65816M0HEX81,   CPU65816HEX82, CPU65816M0HEX83, CPU65816X0HEX84, CPU65816M0HEX85, CPU65816X0HEX86, CPU65816M0HEX87, CPU65816X0HEX88, CPU65816M0HEX89, CPU65816X0HEX8A,   CPU65816HEX8B, CPU65816X0HEX8C, CPU65816M0HEX8D, CPU65816X0HEX8E, CPU65816M0HEX8F
dw    CPU6502HEX90, CPU65816M0HEX91, CPU65816M0HEX92, CPU65816M0HEX93, CPU65816X0HEX94, CPU65816M0HEX95, CPU65816X0HEX96, CPU65816M0HEX97, CPU65816X0HEX98, CPU65816M0HEX99, CPU65816X0HEX9A, CPU65816X0HEX9B, CPU65816M0HEX9C, CPU65816M0HEX9D, CPU65816M0HEX9E, CPU65816M0HEX9F
dw CPU65816X0HEXA0, CPU65816M0HEXA1, CPU65816X0HEXA2, CPU65816M0HEXA3, CPU65816X0HEXA4, CPU65816M0HEXA5, CPU65816X0HEXA6, CPU65816M0HEXA7, CPU65816X0HEXA8, CPU65816M0HEXA9, CPU65816X0HEXAA,   CPU65816HEXAB, CPU65816X0HEXAC, CPU65816M0HEXAD, CPU65816X0HEXAE, CPU65816M0HEXAF
dw    CPU6502HEXB0, CPU65816M0HEXB1, CPU65816M0HEXB2, CPU65816M0HEXB3, CPU65816X0HEXB4, CPU65816M0HEXB5, CPU65816X0HEXB6, CPU65816M0HEXB7,    CPU6502HEXB8, CPU65816M0HEXB9, CPU65816X0HEXBA, CPU65816X0HEXBB, CPU65816X0HEXBC, CPU65816M0HEXBD, CPU65816X0HEXBE, CPU65816M0HEXBF
dw CPU65816X0HEXC0, CPU65816M0HEXC1,   CPU65816HEXC2, CPU65816M0HEXC3, CPU65816X0HEXC4, CPU65816M0HEXC5, CPU65816M0HEXC6, CPU65816M0HEXC7, CPU65816X0HEXC8, CPU65816M0HEXC9, CPU65816X0HEXCA,   CPU65816HEXCB, CPU65816X0HEXCC, CPU65816M0HEXCD, CPU65816M0HEXCE, CPU65816M0HEXCF
dw    CPU6502HEXD0, CPU65816M0HEXD1, CPU65816M0HEXD2, CPU65816M0HEXD3,   CPU65816HEXD4, CPU65816M0HEXD5, CPU65816M0HEXD6, CPU65816M0HEXD7,    CPU6502HEXD8, CPU65816M0HEXD9, CPU65816X0HEXDA,   CPU65816HEXDB,   CPU65816HEXDC, CPU65816M0HEXDD, CPU65816M0HEXDE, CPU65816M0HEXDF
dw CPU65816X0HEXE0, CPU65816M0HEXE1,   CPU65816HEXE2, CPU65816M0HEXE3, CPU65816X0HEXE4, CPU65816M0HEXE5, CPU65816M0HEXE6, CPU65816M0HEXE7, CPU65816X0HEXE8, CPU65816M0HEXE9,    CPU6502HEXEA,   CPU65816HEXEB, CPU65816X0HEXEC, CPU65816M0HEXED, CPU65816M0HEXEE, CPU65816M0HEXEF
dw    CPU6502HEXF0, CPU65816M0HEXF1, CPU65816M0HEXF2, CPU65816M0HEXF3,   CPU65816HEXF4, CPU65816M0HEXF5, CPU65816M0HEXF6, CPU65816M0HEXF7,    CPU6502HEXF8, CPU65816M0HEXF9, CPU65816X0HEXFA,    CPU6502HEXFB,   CPU65816HEXFC, CPU65816M0HEXFD, CPU65816M0HEXFE, CPU65816M0HEXFF

// 65816 CPU Instruction Indirect Table (E = 0, X = 1, M = 0)
dw CPU65816HEX00, CPU65816M0HEX01,   CPU65816HEX02, CPU65816M0HEX03, CPU65816M0HEX04, CPU65816M0HEX05, CPU65816M0HEX06, CPU65816M0HEX07,   CPU65816HEX08, CPU65816M0HEX09, CPU65816M0HEX0A,   CPU65816HEX0B, CPU65816M0HEX0C, CPU65816M0HEX0D, CPU65816M0HEX0E, CPU65816M0HEX0F
dw  CPU6502HEX10, CPU65816M0HEX11, CPU65816M0HEX12, CPU65816M0HEX13, CPU65816M0HEX14, CPU65816M0HEX15, CPU65816M0HEX16, CPU65816M0HEX17,    CPU6502HEX18, CPU65816M0HEX19, CPU65816M0HEX1A,   CPU65816HEX1B, CPU65816M0HEX1C, CPU65816M0HEX1D, CPU65816M0HEX1E, CPU65816M0HEX1F
dw CPU65816HEX20, CPU65816M0HEX21,   CPU65816HEX22, CPU65816M0HEX23, CPU65816M0HEX24, CPU65816M0HEX25, CPU65816M0HEX26, CPU65816M0HEX27,   CPU65816HEX28, CPU65816M0HEX29, CPU65816M0HEX2A,   CPU65816HEX2B, CPU65816M0HEX2C, CPU65816M0HEX2D, CPU65816M0HEX2E, CPU65816M0HEX2F
dw  CPU6502HEX30, CPU65816M0HEX31, CPU65816M0HEX32, CPU65816M0HEX33, CPU65816M0HEX34, CPU65816M0HEX35, CPU65816M0HEX36, CPU65816M0HEX37,    CPU6502HEX38, CPU65816M0HEX39, CPU65816M0HEX3A,   CPU65816HEX3B, CPU65816M0HEX3C, CPU65816M0HEX3D, CPU65816M0HEX3E, CPU65816M0HEX3F
dw CPU65816HEX40, CPU65816M0HEX41,   CPU65816HEX42, CPU65816M0HEX43,   CPU65816HEX44, CPU65816M0HEX45, CPU65816M0HEX46, CPU65816M0HEX47, CPU65816M0HEX48, CPU65816M0HEX49, CPU65816M0HEX4A,   CPU65816HEX4B,    CPU6502HEX4C, CPU65816M0HEX4D, CPU65816M0HEX4E, CPU65816M0HEX4F
dw  CPU6502HEX50, CPU65816M0HEX51, CPU65816M0HEX52, CPU65816M0HEX53,   CPU65816HEX54, CPU65816M0HEX55, CPU65816M0HEX56, CPU65816M0HEX57,    CPU6502HEX58, CPU65816M0HEX59, CPU65816X1HEX5A,   CPU65816HEX5B,   CPU65816HEX5C, CPU65816M0HEX5D, CPU65816M0HEX5E, CPU65816M0HEX5F
dw CPU65816HEX60, CPU65816M0HEX61,   CPU65816HEX62, CPU65816M0HEX63, CPU65816M0HEX64, CPU65816M0HEX65, CPU65816M0HEX66, CPU65816M0HEX67, CPU65816M0HEX68, CPU65816M0HEX69, CPU65816M0HEX6A,   CPU65816HEX6B,    CPU6502HEX6C, CPU65816M0HEX6D, CPU65816M0HEX6E, CPU65816M0HEX6F
dw  CPU6502HEX70, CPU65816M0HEX71, CPU65816M0HEX72, CPU65816M0HEX73, CPU65816M0HEX74, CPU65816M0HEX75, CPU65816M0HEX76, CPU65816M0HEX77,    CPU6502HEX78, CPU65816M0HEX79, CPU65816X1HEX7A,   CPU65816HEX7B,   CPU65816HEX7C, CPU65816M0HEX7D, CPU65816M0HEX7E, CPU65816M0HEX7F
dw CPU65816HEX80, CPU65816M0HEX81,   CPU65816HEX82, CPU65816M0HEX83,    CPU6502HEX84, CPU65816M0HEX85,    CPU6502HEX86, CPU65816M0HEX87,    CPU6502HEX88, CPU65816M0HEX89, CPU65816X1HEX8A,   CPU65816HEX8B,    CPU6502HEX8C, CPU65816M0HEX8D,    CPU6502HEX8E, CPU65816M0HEX8F
dw  CPU6502HEX90, CPU65816M0HEX91, CPU65816M0HEX92, CPU65816M0HEX93,    CPU6502HEX94, CPU65816M0HEX95,    CPU6502HEX96, CPU65816M0HEX97, CPU65816X1HEX98, CPU65816M0HEX99,    CPU6502HEX9A, CPU65816X1HEX9B, CPU65816M0HEX9C, CPU65816M0HEX9D, CPU65816M0HEX9E, CPU65816M0HEX9F
dw  CPU6502HEXA0, CPU65816M0HEXA1,    CPU6502HEXA2, CPU65816M0HEXA3,    CPU6502HEXA4, CPU65816M0HEXA5,    CPU6502HEXA6, CPU65816M0HEXA7,    CPU6502HEXA8, CPU65816M0HEXA9,    CPU6502HEXAA,   CPU65816HEXAB,    CPU6502HEXAC, CPU65816M0HEXAD,    CPU6502HEXAE, CPU65816M0HEXAF
dw  CPU6502HEXB0, CPU65816M0HEXB1, CPU65816M0HEXB2, CPU65816M0HEXB3,    CPU6502HEXB4, CPU65816M0HEXB5,    CPU6502HEXB6, CPU65816M0HEXB7,    CPU6502HEXB8, CPU65816M0HEXB9,    CPU6502HEXBA, CPU65816X1HEXBB,    CPU6502HEXBC, CPU65816M0HEXBD,    CPU6502HEXBE, CPU65816M0HEXBF
dw  CPU6502HEXC0, CPU65816M0HEXC1,   CPU65816HEXC2, CPU65816M0HEXC3,    CPU6502HEXC4, CPU65816M0HEXC5, CPU65816M0HEXC6, CPU65816M0HEXC7,    CPU6502HEXC8, CPU65816M0HEXC9,    CPU6502HEXCA,   CPU65816HEXCB,    CPU6502HEXCC, CPU65816M0HEXCD, CPU65816M0HEXCE, CPU65816M0HEXCF
dw  CPU6502HEXD0, CPU65816M0HEXD1, CPU65816M0HEXD2, CPU65816M0HEXD3,   CPU65816HEXD4, CPU65816M0HEXD5, CPU65816M0HEXD6, CPU65816M0HEXD7,    CPU6502HEXD8, CPU65816M0HEXD9, CPU65816X1HEXDA,   CPU65816HEXDB,   CPU65816HEXDC, CPU65816M0HEXDD, CPU65816M0HEXDE, CPU65816M0HEXDF
dw  CPU6502HEXE0, CPU65816M0HEXE1,   CPU65816HEXE2, CPU65816M0HEXE3,    CPU6502HEXE4, CPU65816M0HEXE5, CPU65816M0HEXE6, CPU65816M0HEXE7,    CPU6502HEXE8, CPU65816M0HEXE9,    CPU6502HEXEA,   CPU65816HEXEB,    CPU6502HEXEC, CPU65816M0HEXED, CPU65816M0HEXEE, CPU65816M0HEXEF
dw  CPU6502HEXF0, CPU65816M0HEXF1, CPU65816M0HEXF2, CPU65816M0HEXF3,   CPU65816HEXF4, CPU65816M0HEXF5, CPU65816M0HEXF6, CPU65816M0HEXF7,    CPU6502HEXF8, CPU65816M0HEXF9, CPU65816X1HEXFA,    CPU6502HEXFB,   CPU65816HEXFC, CPU65816M0HEXFD, CPU65816M0HEXFE, CPU65816M0HEXFF

// 65816 CPU Instruction Indirect Table (E = 0, X = 0, M = 1)
dw   CPU65816HEX00,    CPU6502HEX01,   CPU65816HEX02, CPU65816M1HEX03, CPU65816M1HEX04, CPU6502HEX05,    CPU6502HEX06, CPU65816M1HEX07,   CPU65816HEX08,    CPU6502HEX09,    CPU6502HEX0A,   CPU65816HEX0B, CPU65816M1HEX0C, CPU6502HEX0D,    CPU6502HEX0E, CPU65816M1HEX0F
dw    CPU6502HEX10, CPU65816M1HEX11, CPU65816M1HEX12, CPU65816M1HEX13, CPU65816M1HEX14, CPU6502HEX15,    CPU6502HEX16, CPU65816M1HEX17,    CPU6502HEX18,    CPU6502HEX19, CPU65816M1HEX1A,   CPU65816HEX1B, CPU65816M1HEX1C, CPU6502HEX1D,    CPU6502HEX1E, CPU65816M1HEX1F
dw   CPU65816HEX20,    CPU6502HEX21,   CPU65816HEX22, CPU65816M1HEX23,    CPU6502HEX24, CPU6502HEX25,    CPU6502HEX26, CPU65816M1HEX27,   CPU65816HEX28,    CPU6502HEX29,    CPU6502HEX2A,   CPU65816HEX2B,    CPU6502HEX2C, CPU6502HEX2D,    CPU6502HEX2E, CPU65816M1HEX2F
dw    CPU6502HEX30,    CPU6502HEX31, CPU65816M1HEX32, CPU65816M1HEX33, CPU65816M1HEX34, CPU6502HEX35,    CPU6502HEX36, CPU65816M1HEX37,    CPU6502HEX38,    CPU6502HEX39, CPU65816M1HEX3A,   CPU65816HEX3B, CPU65816M1HEX3C, CPU6502HEX3D,    CPU6502HEX3E, CPU65816M1HEX3F
dw   CPU65816HEX40,    CPU6502HEX41,   CPU65816HEX42, CPU65816M1HEX43,   CPU65816HEX44, CPU6502HEX45,    CPU6502HEX46, CPU65816M1HEX47, CPU65816M1HEX48,    CPU6502HEX49,    CPU6502HEX4A,   CPU65816HEX4B,    CPU6502HEX4C, CPU6502HEX4D,    CPU6502HEX4E, CPU65816M1HEX4F
dw    CPU6502HEX50,    CPU6502HEX51, CPU65816M1HEX52, CPU65816M1HEX53,   CPU65816HEX54, CPU6502HEX55,    CPU6502HEX56, CPU65816M1HEX57,    CPU6502HEX58,    CPU6502HEX59, CPU65816X0HEX5A,   CPU65816HEX5B,   CPU65816HEX5C, CPU6502HEX5D,    CPU6502HEX5E, CPU65816M1HEX5F
dw   CPU65816HEX60,    CPU6502HEX61,   CPU65816HEX62, CPU65816M1HEX63, CPU65816M1HEX64, CPU6502HEX65,    CPU6502HEX66, CPU65816M1HEX67, CPU65816M1HEX68,    CPU6502HEX69,    CPU6502HEX6A,   CPU65816HEX6B,    CPU6502HEX6C, CPU6502HEX6D,    CPU6502HEX6E, CPU65816M1HEX6F
dw    CPU6502HEX70,    CPU6502HEX71, CPU65816M1HEX72, CPU65816M1HEX73, CPU65816M1HEX74, CPU6502HEX75,    CPU6502HEX76, CPU65816M1HEX77,    CPU6502HEX78,    CPU6502HEX79, CPU65816X0HEX7A,   CPU65816HEX7B,   CPU65816HEX7C, CPU6502HEX7D,    CPU6502HEX7E, CPU65816M1HEX7F
dw   CPU65816HEX80,    CPU6502HEX81,   CPU65816HEX82, CPU65816M1HEX83, CPU65816X0HEX84, CPU6502HEX85, CPU65816X0HEX86, CPU65816M1HEX87, CPU65816X0HEX88, CPU65816M1HEX89, CPU65816M1HEX8A,   CPU65816HEX8B, CPU65816X0HEX8C, CPU6502HEX8D, CPU65816X0HEX8E, CPU65816M1HEX8F
dw    CPU6502HEX90,    CPU6502HEX91, CPU65816M1HEX92, CPU65816M1HEX93, CPU65816X0HEX94, CPU6502HEX95, CPU65816X0HEX96, CPU65816M1HEX97, CPU65816M1HEX98,    CPU6502HEX99, CPU65816X0HEX9A, CPU65816X0HEX9B, CPU65816M1HEX9C, CPU6502HEX9D, CPU65816M1HEX9E, CPU65816M1HEX9F
dw CPU65816X0HEXA0,    CPU6502HEXA1, CPU65816X0HEXA2, CPU65816M1HEXA3, CPU65816X0HEXA4, CPU6502HEXA5, CPU65816X0HEXA6, CPU65816M1HEXA7, CPU65816X0HEXA8,    CPU6502HEXA9, CPU65816X0HEXAA,   CPU65816HEXAB, CPU65816X0HEXAC, CPU6502HEXAD, CPU65816X0HEXAE, CPU65816M1HEXAF
dw    CPU6502HEXB0,    CPU6502HEXB1, CPU65816M1HEXB2, CPU65816M1HEXB3, CPU65816X0HEXB4, CPU6502HEXB5, CPU65816X0HEXB6, CPU65816M1HEXB7,    CPU6502HEXB8,    CPU6502HEXB9, CPU65816X0HEXBA, CPU65816X0HEXBB, CPU65816X0HEXBC, CPU6502HEXBD, CPU65816X0HEXBE, CPU65816M1HEXBF
dw CPU65816X0HEXC0,    CPU6502HEXC1,   CPU65816HEXC2, CPU65816M1HEXC3, CPU65816X0HEXC4, CPU6502HEXC5,    CPU6502HEXC6, CPU65816M1HEXC7, CPU65816X0HEXC8,    CPU6502HEXC9, CPU65816X0HEXCA,   CPU65816HEXCB, CPU65816X0HEXCC, CPU6502HEXCD,    CPU6502HEXCE, CPU65816M1HEXCF
dw    CPU6502HEXD0,    CPU6502HEXD1, CPU65816M1HEXD2, CPU65816M1HEXD3,   CPU65816HEXD4, CPU6502HEXD5,    CPU6502HEXD6, CPU65816M1HEXD7,    CPU6502HEXD8,    CPU6502HEXD9, CPU65816X0HEXDA,   CPU65816HEXDB,   CPU65816HEXDC, CPU6502HEXDD,    CPU6502HEXDE, CPU65816M1HEXDF
dw CPU65816X0HEXE0,    CPU6502HEXE1,   CPU65816HEXE2, CPU65816M1HEXE3, CPU65816X0HEXE4, CPU6502HEXE5,    CPU6502HEXE6, CPU65816M1HEXE7, CPU65816X0HEXE8,    CPU6502HEXE9,    CPU6502HEXEA,   CPU65816HEXEB, CPU65816X0HEXEC, CPU6502HEXED,    CPU6502HEXEE, CPU65816M1HEXEF
dw    CPU6502HEXF0,    CPU6502HEXF1, CPU65816M1HEXF2, CPU65816M1HEXF3,   CPU65816HEXF4, CPU6502HEXF5,    CPU6502HEXF6, CPU65816M1HEXF7,    CPU6502HEXF8,    CPU6502HEXF9, CPU65816X0HEXFA,    CPU6502HEXFB,   CPU65816HEXFC, CPU6502HEXFD,    CPU6502HEXFE, CPU65816M1HEXFF

// 65816 CPU Instruction Indirect Table (E = 0, X = 1, M = 1)
dw CPU65816HEX00,    CPU6502HEX01,   CPU65816HEX02, CPU65816M1HEX03, CPU65816M1HEX04, CPU6502HEX05, CPU6502HEX06, CPU65816M1HEX07,   CPU65816HEX08,    CPU6502HEX09,    CPU6502HEX0A,   CPU65816HEX0B, CPU65816M1HEX0C, CPU6502HEX0D,    CPU6502HEX0E, CPU65816M1HEX0F
dw  CPU6502HEX10, CPU65816M1HEX11, CPU65816M1HEX12, CPU65816M1HEX13, CPU65816M1HEX14, CPU6502HEX15, CPU6502HEX16, CPU65816M1HEX17,    CPU6502HEX18,    CPU6502HEX19, CPU65816M1HEX1A,   CPU65816HEX1B, CPU65816M1HEX1C, CPU6502HEX1D,    CPU6502HEX1E, CPU65816M1HEX1F
dw CPU65816HEX20,    CPU6502HEX21,   CPU65816HEX22, CPU65816M1HEX23,    CPU6502HEX24, CPU6502HEX25, CPU6502HEX26, CPU65816M1HEX27,   CPU65816HEX28,    CPU6502HEX29,    CPU6502HEX2A,   CPU65816HEX2B,    CPU6502HEX2C, CPU6502HEX2D,    CPU6502HEX2E, CPU65816M1HEX2F
dw  CPU6502HEX30,    CPU6502HEX31, CPU65816M1HEX32, CPU65816M1HEX33, CPU65816M1HEX34, CPU6502HEX35, CPU6502HEX36, CPU65816M1HEX37,    CPU6502HEX38,    CPU6502HEX39, CPU65816M1HEX3A,   CPU65816HEX3B, CPU65816M1HEX3C, CPU6502HEX3D,    CPU6502HEX3E, CPU65816M1HEX3F
dw CPU65816HEX40,    CPU6502HEX41,   CPU65816HEX42, CPU65816M1HEX43,   CPU65816HEX44, CPU6502HEX45, CPU6502HEX46, CPU65816M1HEX47, CPU65816M1HEX48,    CPU6502HEX49,    CPU6502HEX4A,   CPU65816HEX4B,    CPU6502HEX4C, CPU6502HEX4D,    CPU6502HEX4E, CPU65816M1HEX4F
dw  CPU6502HEX50,    CPU6502HEX51, CPU65816M1HEX52, CPU65816M1HEX53,   CPU65816HEX54, CPU6502HEX55, CPU6502HEX56, CPU65816M1HEX57,    CPU6502HEX58,    CPU6502HEX59, CPU65816X1HEX5A,   CPU65816HEX5B,   CPU65816HEX5C, CPU6502HEX5D,    CPU6502HEX5E, CPU65816M1HEX5F
dw CPU65816HEX60,    CPU6502HEX61,   CPU65816HEX62, CPU65816M1HEX63, CPU65816M1HEX64, CPU6502HEX65, CPU6502HEX66, CPU65816M1HEX67, CPU65816M1HEX68,    CPU6502HEX69,    CPU6502HEX6A,   CPU65816HEX6B,    CPU6502HEX6C, CPU6502HEX6D,    CPU6502HEX6E, CPU65816M1HEX6F
dw  CPU6502HEX70,    CPU6502HEX71, CPU65816M1HEX72, CPU65816M1HEX73, CPU65816M1HEX74, CPU6502HEX75, CPU6502HEX76, CPU65816M1HEX77,    CPU6502HEX78,    CPU6502HEX79, CPU65816X1HEX7A,   CPU65816HEX7B,   CPU65816HEX7C, CPU6502HEX7D,    CPU6502HEX7E, CPU65816M1HEX7F
dw CPU65816HEX80,    CPU6502HEX81,   CPU65816HEX82, CPU65816M1HEX83,    CPU6502HEX84, CPU6502HEX85, CPU6502HEX86, CPU65816M1HEX87,    CPU6502HEX88, CPU65816M1HEX89,    CPU6502HEX8A,   CPU65816HEX8B,    CPU6502HEX8C, CPU6502HEX8D,    CPU6502HEX8E, CPU65816M1HEX8F
dw  CPU6502HEX90,    CPU6502HEX91, CPU65816M1HEX92, CPU65816M1HEX93,    CPU6502HEX94, CPU6502HEX95, CPU6502HEX96, CPU65816M1HEX97,    CPU6502HEX98,    CPU6502HEX99,    CPU6502HEX9A, CPU65816X1HEX9B, CPU65816M1HEX9C, CPU6502HEX9D, CPU65816M1HEX9E, CPU65816M1HEX9F
dw  CPU6502HEXA0,    CPU6502HEXA1,    CPU6502HEXA2, CPU65816M1HEXA3,    CPU6502HEXA4, CPU6502HEXA5, CPU6502HEXA6, CPU65816M1HEXA7,    CPU6502HEXA8,    CPU6502HEXA9,    CPU6502HEXAA,   CPU65816HEXAB,    CPU6502HEXAC, CPU6502HEXAD,    CPU6502HEXAE, CPU65816M1HEXAF
dw  CPU6502HEXB0,    CPU6502HEXB1, CPU65816M1HEXB2, CPU65816M1HEXB3,    CPU6502HEXB4, CPU6502HEXB5, CPU6502HEXB6, CPU65816M1HEXB7,    CPU6502HEXB8,    CPU6502HEXB9,    CPU6502HEXBA, CPU65816X1HEXBB,    CPU6502HEXBC, CPU6502HEXBD,    CPU6502HEXBE, CPU65816M1HEXBF
dw  CPU6502HEXC0,    CPU6502HEXC1,   CPU65816HEXC2, CPU65816M1HEXC3,    CPU6502HEXC4, CPU6502HEXC5, CPU6502HEXC6, CPU65816M1HEXC7,    CPU6502HEXC8,    CPU6502HEXC9,    CPU6502HEXCA,   CPU65816HEXCB,    CPU6502HEXCC, CPU6502HEXCD,    CPU6502HEXCE, CPU65816M1HEXCF
dw  CPU6502HEXD0,    CPU6502HEXD1, CPU65816M1HEXD2, CPU65816M1HEXD3,   CPU65816HEXD4, CPU6502HEXD5, CPU6502HEXD6, CPU65816M1HEXD7,    CPU6502HEXD8,    CPU6502HEXD9, CPU65816X1HEXDA,   CPU65816HEXDB,   CPU65816HEXDC, CPU6502HEXDD,    CPU6502HEXDE, CPU65816M1HEXDF
dw  CPU6502HEXE0,    CPU6502HEXE1,   CPU65816HEXE2, CPU65816M1HEXE3,    CPU6502HEXE4, CPU6502HEXE5, CPU6502HEXE6, CPU65816M1HEXE7,    CPU6502HEXE8,    CPU6502HEXE9,    CPU6502HEXEA,   CPU65816HEXEB,    CPU6502HEXEC, CPU6502HEXED,    CPU6502HEXEE, CPU65816M1HEXEF
dw  CPU6502HEXF0,    CPU6502HEXF1, CPU65816M1HEXF2, CPU65816M1HEXF3,   CPU65816HEXF4, CPU6502HEXF5, CPU6502HEXF6, CPU65816M1HEXF7,    CPU6502HEXF8,    CPU6502HEXF9, CPU65816X1HEXFA,    CPU6502HEXFB,   CPU65816HEXFC, CPU6502HEXFD,    CPU6502HEXFE, CPU65816M1HEXFF

// 6502 CPU Instruction Indirect Table (E = 1)
dw CPU6502HEX00, CPU6502HEX01, CPU6502HEX02, CPU6502HEXEA, CPU6502HEXEA, CPU6502HEX05, CPU6502HEX06, CPU6502HEXEA, CPU6502HEX08, CPU6502HEX09, CPU6502HEX0A, CPU6502HEXEA, CPU6502HEXEA, CPU6502HEX0D, CPU6502HEX0E, CPU6502HEXEA
dw CPU6502HEX10, CPU6502HEXEA, CPU6502HEXEA, CPU6502HEXEA, CPU6502HEXEA, CPU6502HEX15, CPU6502HEX16, CPU6502HEXEA, CPU6502HEX18, CPU6502HEX19, CPU6502HEXEA, CPU6502HEXEA, CPU6502HEXEA, CPU6502HEX1D, CPU6502HEX1E, CPU6502HEXEA
dw CPU6502HEX20, CPU6502HEX21, CPU6502HEXEA, CPU6502HEXEA, CPU6502HEX24, CPU6502HEX25, CPU6502HEX26, CPU6502HEXEA, CPU6502HEX28, CPU6502HEX29, CPU6502HEX2A, CPU6502HEXEA, CPU6502HEX2C, CPU6502HEX2D, CPU6502HEX2E, CPU6502HEXEA
dw CPU6502HEX30, CPU6502HEX31, CPU6502HEXEA, CPU6502HEXEA, CPU6502HEXEA, CPU6502HEX35, CPU6502HEX36, CPU6502HEXEA, CPU6502HEX38, CPU6502HEX39, CPU6502HEXEA, CPU6502HEXEA, CPU6502HEXEA, CPU6502HEX3D, CPU6502HEX3E, CPU6502HEXEA
dw CPU6502HEX40, CPU6502HEX41, CPU6502HEXEA, CPU6502HEXEA, CPU6502HEXEA, CPU6502HEX45, CPU6502HEX46, CPU6502HEXEA, CPU6502HEX48, CPU6502HEX49, CPU6502HEX4A, CPU6502HEXEA, CPU6502HEX4C, CPU6502HEX4D, CPU6502HEX4E, CPU6502HEXEA
dw CPU6502HEX50, CPU6502HEX51, CPU6502HEXEA, CPU6502HEXEA, CPU6502HEXEA, CPU6502HEX55, CPU6502HEX56, CPU6502HEXEA, CPU6502HEX58, CPU6502HEX59, CPU6502HEXEA, CPU6502HEXEA, CPU6502HEXEA, CPU6502HEX5D, CPU6502HEX5E, CPU6502HEXEA
dw CPU6502HEX60, CPU6502HEX61, CPU6502HEXEA, CPU6502HEXEA, CPU6502HEXEA, CPU6502HEX65, CPU6502HEX66, CPU6502HEXEA, CPU6502HEX68, CPU6502HEX69, CPU6502HEX6A, CPU6502HEXEA, CPU6502HEX6C, CPU6502HEX6D, CPU6502HEX6E, CPU6502HEXEA
dw CPU6502HEX70, CPU6502HEX71, CPU6502HEXEA, CPU6502HEXEA, CPU6502HEXEA, CPU6502HEX75, CPU6502HEX76, CPU6502HEXEA, CPU6502HEX78, CPU6502HEX79, CPU6502HEXEA, CPU6502HEXEA, CPU6502HEXEA, CPU6502HEX7D, CPU6502HEX7E, CPU6502HEXEA
dw CPU6502HEXEA, CPU6502HEX81, CPU6502HEXEA, CPU6502HEXEA, CPU6502HEX84, CPU6502HEX85, CPU6502HEX86, CPU6502HEXEA, CPU6502HEX88, CPU6502HEXEA, CPU6502HEX8A, CPU6502HEXEA, CPU6502HEX8C, CPU6502HEX8D, CPU6502HEX8E, CPU6502HEXEA
dw CPU6502HEX90, CPU6502HEX91, CPU6502HEXEA, CPU6502HEXEA, CPU6502HEX94, CPU6502HEX95, CPU6502HEX96, CPU6502HEXEA, CPU6502HEX98, CPU6502HEX99, CPU6502HEX9A, CPU6502HEXEA, CPU6502HEXEA, CPU6502HEX9D, CPU6502HEXEA, CPU6502HEXEA
dw CPU6502HEXA0, CPU6502HEXA1, CPU6502HEXA2, CPU6502HEXEA, CPU6502HEXA4, CPU6502HEXA5, CPU6502HEXA6, CPU6502HEXEA, CPU6502HEXA8, CPU6502HEXA9, CPU6502HEXAA, CPU6502HEXEA, CPU6502HEXAC, CPU6502HEXAD, CPU6502HEXAE, CPU6502HEXEA
dw CPU6502HEXB0, CPU6502HEXB1, CPU6502HEXEA, CPU6502HEXEA, CPU6502HEXB4, CPU6502HEXB5, CPU6502HEXB6, CPU6502HEXEA, CPU6502HEXB8, CPU6502HEXB9, CPU6502HEXBA, CPU6502HEXEA, CPU6502HEXBC, CPU6502HEXBD, CPU6502HEXBE, CPU6502HEXEA
dw CPU6502HEXC0, CPU6502HEXC1, CPU6502HEXC2, CPU6502HEXEA, CPU6502HEXC4, CPU6502HEXC5, CPU6502HEXC6, CPU6502HEXEA, CPU6502HEXC8, CPU6502HEXC9, CPU6502HEXCA, CPU6502HEXEA, CPU6502HEXCC, CPU6502HEXCD, CPU6502HEXCE, CPU6502HEXEA
dw CPU6502HEXD0, CPU6502HEXD1, CPU6502HEXEA, CPU6502HEXEA, CPU6502HEXEA, CPU6502HEXD5, CPU6502HEXD6, CPU6502HEXEA, CPU6502HEXD8, CPU6502HEXD9, CPU6502HEXEA, CPU6502HEXEA, CPU6502HEXEA, CPU6502HEXDD, CPU6502HEXDE, CPU6502HEXEA
dw CPU6502HEXE0, CPU6502HEXE1, CPU6502HEXE2, CPU6502HEXEA, CPU6502HEXE4, CPU6502HEXE5, CPU6502HEXE6, CPU6502HEXEA, CPU6502HEXE8, CPU6502HEXE9, CPU6502HEXEA, CPU6502HEXEA, CPU6502HEXEC, CPU6502HEXED, CPU6502HEXEE, CPU6502HEXEA
dw CPU6502HEXF0, CPU6502HEXF1, CPU6502HEXEA, CPU6502HEXEA, CPU6502HEXEA, CPU6502HEXF5, CPU6502HEXF6, CPU6502HEXEA, CPU6502HEXF8, CPU6502HEXF9, CPU6502HEXEA, CPU6502HEXFB, CPU6502HEXEA, CPU6502HEXFD, CPU6502HEXFE, CPU6502HEXEA

include "CPU6502.asm"    //  6502 CPU Instruction Table (E = 1)
include "CPU65816.asm"   // 65816 CPU Instruction Table (E = 0)
include "CPU65816M0.asm" // 65816 CPU Instruction Table (E = 0, M = 0)
include "CPU65816M1.asm" // 65816 CPU Instruction Table (E = 0, M = 1)
include "CPU65816X0.asm" // 65816 CPU Instruction Table (E = 0, X = 0)
include "CPU65816X1.asm" // 65816 CPU Instruction Table (E = 0, X = 1)