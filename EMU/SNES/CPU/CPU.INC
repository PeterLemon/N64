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
  addu a2,a0,t0       // A2 = MEM_MAP + Immediate
  sll t0,s7,16        // T0 = DB_REG << 16 
  addu a2,t0          // A2 = MEM_MAP + DB_REG:Immediate
  lbu {reg},0(a2)     // Register = Absolute (8-Bit)
}

macro LoadABS16(reg) { // Load 16-Bit Absolute Memory To Register
  lbu t0,2(a2)         // Absolute = MEM_MAP[DB_REG:Immediate]
  sll t0,8             // T0 = Immediate HI Byte
  lbu t1,1(a2)         // T1 = Immediate LO Byte
  or t0,t1             // T0 = Immediate (16-Bit)
  addu a2,a0,t0        // A2 = MEM_MAP + Immediate
  sll t0,s7,16         // T0 = DB_REG << 16 
  addu a2,t0           // A2 = MEM_MAP + DB_REG:Immediate
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
  addu a2,a0,t0         // A2 = MEM_MAP + Immediate
  addu a2,s1            // A2 = MEM_MAP + Immediate + X_REG
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
  addu a2,a0,t0          // A2 = MEM_MAP + Immediate
  addu a2,s1             // A2 = MEM_MAP + Immediate + X_REG
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
  addu a2,a0,t0        // A2 = MEM_MAP + Immediate
  sll t0,s7,16         // T0 = DB_REG << 16 
  addu a2,t0           // A2 = MEM_MAP + DB_REG:Immediate
  addu a2,s1           // A2 = MEM_MAP + DB_REG:Immediate + X_REG
  lbu {reg},0(a2)      // Register = Absolute Indexed, X (8-Bit)
}

macro LoadABSX16(reg) { // Load 16-Bit Absolute Indexed, X Memory To Register
  lbu t0,2(a2)          // Absolute Indexed, X = MEM_MAP[DB_REG:Immediate + X_REG]
  sll t0,8              // T0 = Immediate HI Byte
  lbu t1,1(a2)          // T1 = Immediate LO Byte
  or t0,t1              // T0 = Immediate (16-Bit)
  addu a2,a0,t0         // A2 = MEM_MAP + Immediate
  sll t0,s7,16          // T0 = DB_REG << 16 
  addu a2,t0            // A2 = MEM_MAP + DB_REG:Immediate
  addu a2,s1            // A2 = MEM_MAP + DB_REG:Immediate + X_REG
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
  addu a2,a0,t0        // A2 = MEM_MAP + Immediate
  sll t0,s7,16         // T0 = DB_REG << 16 
  addu a2,t0           // A2 = MEM_MAP + DB_REG:Immediate
  addu a2,s2           // A2 = MEM_MAP + DB_REG:Immediate + Y_REG
  lbu {reg},0(a2)      // Register = Absolute Indexed, Y (8-Bit)
}

macro LoadABSY16(reg) { // Load 16-Bit Absolute Indexed, Y Memory To Register
  lbu t0,2(a2)          // Absolute Indexed, Y = MEM_MAP[DB_REG:Immediate + Y_REG]
  sll t0,8              // T0 = Immediate HI Byte
  lbu t1,1(a2)          // T1 = Immediate LO Byte
  or t0,t1              // T0 = Immediate (16-Bit)
  addu a2,a0,t0         // A2 = MEM_MAP + Immediate
  sll t0,s7,16          // T0 = DB_REG << 16 
  addu a2,t0            // A2 = MEM_MAP + DB_REG:Immediate
  addu a2,s2            // A2 = MEM_MAP + DB_REG:Immediate + Y_REG
  lbu {reg},1(a2)       // Register = Absolute Indexed, Y HI Byte
  sll {reg},8           // Register <<= 8
  lbu t1,0(a2)          // T1 = Absolute Indexed, Y LO Byte
  or {reg},t1           // Register = Absolute Indexed, Y (16-Bit)
}

macro LoadDP8(reg) { // Load 8-Bit Direct Page (DP) Memory To Register
  lbu t0,1(a2)       // DP = MEM_MAP[D_REG + Immediate]
  addu t0,s6         // T0 = D_REG + Immediate
  addu a2,a0,t0      // A2 = MEM_MAP + D_REG + Immediate
  lbu {reg},0(a2)    // Register = DP (8-Bit)
}

macro LoadDP16(reg) { // Load 16-Bit Direct Page (DP) Memory To Register
  lbu t0,1(a2)        // DP = MEM_MAP[D_REG + Immediate]
  addu t0,s6          // T0 = D_REG + Immediate
  addu a2,a0,t0       // A2 = MEM_MAP + D_REG + Immediate
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
  addu a2,a0,t0         // A2 = MEM_MAP + DP Indirect Long FAR
  addu a2,s2            // A2 = MEM_MAP + DP Indirect Long FAR + Y_REG
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
  addu a2,a0,t0          // A2 = MEM_MAP + DP Indirect Long FAR
  addu a2,s2             // A2 = MEM_MAP + DP Indirect Long FAR + Y_REG
  lbu {reg},1(a2)        // Register = DP Indirect Long Indexed, Y HI Byte
  sll {reg},8            // Register <<= 8
  lbu t1,0(a2)           // T1 = DP Indirect Long LO Indexed, Y Byte
  or {reg},t1            // Register = DP Indirect Long Indexed, Y (16-Bit)
}

macro LoadDPIX8(reg) { // Load 8-Bit Direct Page (DP) Indexed Indirect, X Memory To Register
  lbu t0,1(a2)         // DP Indexed Indirect, X = MEM_MAP[WORD[D_REG + Immediate + X_REG]]
  addu t0,s6           // T0 = D_REG + Immediate
  addu a2,a0,t0        // A2 = MEM_MAP + D_REG + Immediate
  addu a2,s1           // A2 = MEM_MAP + D_REG + Immediate + X_REG
  lbu t0,1(a2)         // T0 = DP Indirect WORD HI Byte
  sll t0,8             // T0 <<= 8
  lbu t1,0(a2)         // T1 = DP Indexed Indirect, X WORD LO Byte
  or t0,t1             // T0 = DP Indexed Indirect, X WORD
  addu a2,a0,t0        // A2 = MEM_MAP + DP Indexed Indirect, X WORD
  lbu {reg},0(a2)      // Register = DP Indexed Indirect, X (8-Bit)
}

macro LoadDPIX16(reg) { // Load 16-Bit Direct Page (DP) Indexed Indirect, X Memory To Register
  lbu t0,1(a2)          // DP Indexed Indirect, X = MEM_MAP[WORD[D_REG + Immediate + X_REG]]
  addu t0,s6            // T0 = D_REG + Immediate
  addu a2,a0,t0         // A2 = MEM_MAP + D_REG + Immediate
  addu a2,s1            // A2 = MEM_MAP + D_REG + Immediate + X_REG
  lbu t0,1(a2)          // T0 = DP Indexed Indirect, X WORD HI Byte
  sll t0,8              // T0 <<= 8
  lbu t1,0(a2)          // T1 = DP Indexed Indirect, X WORD LO Byte
  or t0,t1              // T0 = DP Indexed Indirect, X WORD
  addu a2,a0,t0         // A2 = MEM_MAP + DP Indexed Indirect, X WORD
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
  addu a2,a0,t0        // A2 = MEM_MAP + DP Indirect WORD
  addu a2,s2           // A2 = MEM_MAP + DP Indirect WORD + Y_REG
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
  addu a2,a0,t0         // A2 = MEM_MAP + DP Indirect WORD
  addu a2,s2            // A2 = MEM_MAP + DP Indirect WORD + Y_REG
  lbu {reg},1(a2)       // Register = DP Indirect Indexed, Y HI Byte
  sll {reg},8           // Register <<= 8
  lbu t1,0(a2)          // T1 = DP Indirect Indexed, Y LO Byte
  or {reg},t1           // Register = DP Indirect Indexed, Y (16-Bit)
}

macro LoadDPX8(reg) { // Load 8-Bit Direct Page (DP) Indexed, X Memory To Register
  lbu t0,1(a2)        // DP Indexed, X = MEM_MAP[D_REG + Immediate + X_REG]
  addu t0,s6          // T0 = D_REG + Immediate
  addu a2,a0,t0       // A2 = MEM_MAP + D_REG + Immediate
  addu a2,s1          // A2 = MEM_MAP + D_REG + Immediate + X_REG
  lbu {reg},0(a2)     // Register = DP Indexed, X (8-Bit)
}

macro LoadDPX16(reg) { // Load 16-Bit Direct Page (DP) Indexed, X Memory To Register
  lbu t0,1(a2)         // DP Indexed, X = MEM_MAP[D_REG + Immediate + X_REG]
  addu t0,s6           // T0 = D_REG + Immediate
  addu a2,a0,t0        // A2 = MEM_MAP + D_REG + Immediate
  addu a2,s1           // A2 = MEM_MAP + D_REG + Immediate + X_REG
  lbu {reg},1(a2)      // Register = DP Indexed, X HI Byte
  sll {reg},8          // Register <<= 8
  lbu t1,0(a2)         // T1 = DP Indexed, X LO Byte
  or {reg},t1          // Register = DP Indexed, X (16-Bit)
}

macro LoadSR8(reg) { // Load 8-Bit Stack Relative (SR) Memory To Register
  lbu t0,1(a2)       // SR = MEM_MAP[Immediate + S_REG]
  addu a2,a0,t0      // A2 = MEM_MAP + Immediate
  addu a2,s4         // A2 = MEM_MAP + Immediate + S_REG
  lbu {reg},0(a2)    // Register = SR (8-Bit)
}

macro LoadSR16(reg) { // Load 16-Bit Stack Relative (SR) Memory To Register
  lbu t0,1(a2)        // SR = MEM_MAP[Immediate + S_REG]
  addu a2,a0,t0       // A2 = MEM_MAP + Immediate
  addu a2,s4          // A2 = MEM_MAP + Immediate + S_REG
  lbu {reg},1(a2)     // Register = SR HI Byte
  sll {reg},8         // Register <<= 8
  lbu t1,0(a2)        // T1 = SR LO Byte
  or {reg},t1         // Register = SR (16-Bit)
}

macro LoadSRIY8(reg) { // Load 8-Bit Stack Relative (SR) Indirect Indexed, Y Memory To Register
  lbu t0,1(a2)         // SR Indirect Indexed, Y = MEM_MAP[WORD[Immediate + S_REG] + Y_REG]
  addu a2,a0,t0        // A2 = MEM_MAP + Immediate
  addu a2,s4           // A2 = MEM_MAP + Immediate + S_REG
  lbu t0,1(a2)         // T0 = SR Indirect WORD HI Byte
  sll t0,8             // T0 <<= 8
  lbu t1,0(a2)         // T1 = SR Indirect WORD LO Byte
  or t0,t1             // T0 = SR Indirect WORD
  addu a2,a0,t0        // A2 = MEM_MAP + SR Indirect WORD
  addu a2,s2           // A2 = MEM_MAP + SR Indirect WORD + Y_REG
  lbu {reg},0(a2)      // Register = SR Indirect Indexed, Y (8-Bit)
}

macro LoadSRIY16(reg) { // Load 16-Bit Stack Relative (SR) Indirect Indexed, Y Memory To Register
  lbu t0,1(a2)          // SR Indirect Indexed, Y = MEM_MAP[WORD[Immediate + S_REG] + Y_REG]
  addu a2,a0,t0         // A2 = MEM_MAP + Immediate
  addu a2,s4            // A2 = MEM_MAP + Immediate + S_REG
  lbu t0,1(a2)          // T0 = SR Indirect WORD HI Byte
  sll t0,8              // T0 <<= 8
  lbu t1,0(a2)          // T1 = SR Indirect WORD LO Byte
  or t0,t1              // T0 = SR Indirect WORD
  addu a2,a0,t0         // A2 = MEM_MAP + SR Indirect WORD
  addu a2,s2            // A2 = MEM_MAP + SR Indirect WORD + Y_REG
  lbu {reg},1(a2)       // Register = SR Indirect Indexed, Y HI Byte
  sll {reg},8           // Register <<= 8
  lbu t1,0(a2)          // T1 = SR Indirect Indexed, Y LO Byte
  or {reg},t1           // Register = SR Indirect Indexed, Y (16-Bit)
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
  or t1,t2                  // T0 = N/C Flag
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
  srl t1,8                   // T0 = N Flag
  srl t2,{reg},16            // Test Carry
  or t1,t2                   // T0 = N/C Flag
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

//-----------------
// CPU Jump Macros
//-----------------
macro JumpABSI16() { // Jump 16-Bit Absolute Indirect Memory To PC
  lbu t0,2(a2)       // Absolute Indirect = MEM_MAP[00:Immediate]
  sll t0,8           // T0 = Immediate HI Byte
  lbu t1,1(a2)       // T1 = Immediate LO Byte
  or t0,t1           // T0 = Immediate (16-Bit)
  addu a2,a0,t0      // A2 = MEM_MAP + Immediate
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
  addu a2,a0,t0       // A2 = MEM_MAP + Immediate
  sll t0,s8,16        // T0 = PB_REG << 16 
  addu a2,t0          // A2 = MEM_MAP + PB_REG:Immediate
  addu a2,s1          // A2 = MEM_MAP + PB_REG:Immediate + X_REG
  lbu s3,1(a2)        // PC_REG = Absolute Indexed Indirect HI Byte
  sll s3,8            // PC_REG <<= 8
  lbu t1,0(a2)        // T1 = Absolute Indexed Indirect LO Byte
  or s3,t1            // PC_REG = Absolute Indexed Indirect (16-Bit)
}

//------------------
// CPU Stack Macros
//------------------
macro PullEMU8(reg) { // Pull 8-Bit Register From Stack (Emulation Mode)
  addiu s4,1          // S_REG++ (Increment Stack)
  andi s4,$FF         // S_REG = 8-Bit
  ori t1,s4,$100      // STACK = MEM_MAP[01:S_REG]
  addu t1,a0          // T1 = MEM_MAP + 01:S_REG
  lbu {reg},0(t1)     // Register = STACK (8-Bit)
}

macro PullEMU16(reg) { // Pull 16-Bit Register From Stack (Emulation Mode)
  addiu s4,2           // S_REG += 2 (Increment Stack)
  andi s4,$FF          // S_REG = 8-Bit
  ori t1,s4,$100       // STACK = MEM_MAP[01:S_REG]
  addu t1,a0           // T1 = MEM_MAP + 01:S_REG
  lbu {reg},0(t1)      // Register = STACK HI Byte
  sll {reg},8          // Register <<= 8
  lbu t0,-1(t1)        // T0 = STACK LO Byte
  or {reg},t0          // Register = STACK (16-Bit)
}

macro PullNAT8(reg) { // Pull 8-Bit Register From Stack (Native Mode)
  addiu s4,1          // S_REG++ (Increment Stack)
  andi s4,$FFFF       // S_REG = 16-Bit
  addu t1,a0,s4       // STACK = MEM_MAP[S_REG]
  lbu {reg},0(t1)     // Register = STACK (8-Bit)
}

macro PullNAT16(reg) { // Pull 16-Bit Register From Stack (Native Mode)
  addiu s4,2           // S_REG += 2 (Increment Stack)
  andi s4,$FFFF        // S_REG = 16-Bit
  addu t1,a0,s4        // STACK = MEM_MAP[S_REG]
  lbu {reg},0(t1)      // Register = STACK HI Byte
  sll {reg},8          // Register <<= 8
  lbu t0,-1(t1)        // T0 = STACK LO Byte
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
  ori t1,s4,$100      // STACK = MEM_MAP[01:S_REG]
  addu t1,a0          // T1 = MEM_MAP + 01:S_REG
  sb {reg},0(t1)      // STACK = Register (8-Bit)
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
  addu t1,a0,s4       // STACK = MEM_MAP[S_REG]
  sb {reg},0(t1)      // STACK = Register (8-Bit)
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