STORE2100:
  // $2100 REG_INIDISP           Display Control 1                                    1B/W
  lbu t0,REG_INIDISP(a0) // T0 = MEM_MAP[REG_INIDISP]
  sb r0,REG_INIDISP(a0)  // MEM_MAP[REG_INIDISP] = 0
  la t1,INIDISP          // T1 = INIDISP
  jr gp
  sb t0,0(t1)            // INIDISP = T0 (Delay Slot)

STORE2101:
  // $2101 REG_OBSEL             Object Size & Object Base                            1B/W
  lbu t0,REG_OBSEL(a0)   // T0 = MEM_MAP[REG_OBSEL]
  sb r0,REG_OBSEL(a0)    // MEM_MAP[REG_OBSEL] = 0
  la t1,OBSEL            // T1 = OBSEL
  jr gp
  sb t0,0(t1)            // OBSEL = T0 (Delay Slot)

STORE2102:
  // $2102 REG_OAMADDL           OAM Address (Lower 8bit)                             2B/W
  lbu t0,REG_OAMADDL(a0) // T0 = MEM_MAP[REG_OAMADDL]
  sb r0,REG_OAMADDL(a0)  // MEM_MAP[REG_OAMADDL] = 0
  la t1,OAMADD           // T1 = OAMADD
  jr gp
  sb t0,1(t1)            // OAMADD Lo = T0 (Delay Slot)

STORE2103:
  // $2103 REG_OAMADDH           OAM Address (Upper 1bit) & Priority Rotation         1B/W
  lbu t0,REG_OAMADDH(a0) // T0 = MEM_MAP[REG_OAMADDH]
  sb r0,REG_OAMADDH(a0)  // MEM_MAP[REG_OAMADDH] = 0
  la t1,OAMADD           // T1 = OAMADD
  jr gp
  sb t0,0(t1)            // OAMADD Hi = T0 (Delay Slot)

STORE2104:
  // $2104 REG_OAMDATA           OAM Data Write                                       1B/W D
  lbu t0,REG_OAMDATA(a0) // T0 = MEM_MAP[REG_OAMDATA]
  sb r0,REG_OAMDATA(a0)  // MEM_MAP[REG_OAMDATA] = 0
  la t1,OAMDATA          // T1 = OAMDATA
  lbu t2,2(t1)           // T2 = OAMDATA Flip Flop
  lhu t3,-2(t1)          // T3 = OAMADD
  la t4,OAM              // T4 = OAM
  sll t3,1               // OAMADD << 1
  bnez t2,OAMDATAHI      // IF (Flip Flop != 0) Write Hi Byte, Else Write Lo Byte
  addu t4,t3             // OAM += OAMADD (Delay Slot)
  sb t0,1(t1)            // OAMDATA Lo = T0
  sb t0,0(t4)            // OAM[OAMADD] Lo = T0
  b OAMDATAEND
  nop                    // Delay Slot
  OAMDATAHI:
  sb t0,0(t1)            // OAMDATA Hi = T0
  sb t0,1(t4)            // OAM[OAMADD] Hi = T0
  srl t3,1               // OAMADD >> 1
  addiu t3,1             // OAMADD++
  sh t3,-2(t1)           // OAMADD = T3
  OAMDATAEND:
  addiu t2,1             // T2++
  andi t2,1              // T2 &= 1
  jr gp
  sb t2,2(t1)            // OAMDATA Flip Flop = T2 (Delay Slot)

STORE2105:
  // $2105 REG_BGMODE            BG Mode and BG Character Size                        1B/W
  lbu t0,REG_BGMODE(a0)  // T0 = MEM_MAP[REG_BGMODE]
  sb r0,REG_BGMODE(a0)   // MEM_MAP[REG_BGMODE] = 0
  la t1,BGMODE           // T1 = BGMODE
  jr gp
  sb t0,0(t1)            // BGMODE = T0 (Delay Slot)

STORE2106:
  // $2106 REG_MOSAIC            Mosaic Size and Mosaic Enable                        1B/W
  lbu t0,REG_MOSAIC(a0)  // T0 = MEM_MAP[REG_MOSAIC]
  sb r0,REG_MOSAIC(a0)   // MEM_MAP[REG_MOSAIC] = 0
  la t1,MOSAIC           // T1 = MOSAIC
  jr gp
  sb t0,0(t1)            // MOSAIC = T0 (Delay Slot)

STORE2107:
  // $2107 REG_BG1SC             BG1 Screen Base & Screen Size                        1B/W
  lbu t0,REG_BG1SC(a0)   // T0 = MEM_MAP[REG_BG1SC]
  sb r0,REG_BG1SC(a0)    // MEM_MAP[REG_BG1SC] = 0
  la t1,BG1SC            // T1 = BG1SC
  jr gp
  sb t0,0(t1)            // BG1SC = T0 (Delay Slot)

STORE2108:
  // $2108 REG_BG2SC             BG2 Screen Base & Screen Size                        1B/W
  lbu t0,REG_BG2SC(a0)   // T0 = MEM_MAP[REG_BG2SC]
  sb r0,REG_BG2SC(a0)    // MEM_MAP[REG_BG2SC] = 0
  la t1,BG2SC            // T1 = BG2SC
  jr gp
  sb t0,0(t1)            // BG2SC = T0 (Delay Slot)

STORE2109:
  // $2109 REG_BG3SC             BG3 Screen Base & Screen Size                        1B/W
  lbu t0,REG_BG3SC(a0)   // T0 = MEM_MAP[REG_BG3SC]
  sb r0,REG_BG3SC(a0)    // MEM_MAP[REG_BG3SC] = 0
  la t1,BG3SC            // T1 = BG3SC
  jr gp
  sb t0,0(t1)            // BG3SC = T0 (Delay Slot)

STORE210A:
  // $210A REG_BG4SC             BG4 Screen Base & Screen Size                        1B/W
  lbu t0,REG_BG4SC(a0)   // T0 = MEM_MAP[REG_BG4SC]
  sb r0,REG_BG4SC(a0)    // MEM_MAP[REG_BG4SC] = 0
  la t1,BG4SC            // T1 = BG4SC
  jr gp
  sb t0,0(t1)            // BG4SC = T0 (Delay Slot)

STORE210B:
  // $210B REG_BG12NBA           BG Character Data Area Designation                   1B/W
  lbu t0,REG_BG12NBA(a0) // T0 = MEM_MAP[REG_BG12NBA]
  sb r0,REG_BG12NBA(a0)  // MEM_MAP[REG_BG12NBA] = 0
  la t1,BG12NBA          // T1 = BG12NBA
  jr gp
  sb t0,0(t1)            // BG12NBA = T0 (Delay Slot)

STORE210C:
  // $210C REG_BG34NBA           BG Character Data Area Designation                   1B/W
  lbu t0,REG_BG34NBA(a0) // T0 = MEM_MAP[REG_BG34NBA]
  sb r0,REG_BG34NBA(a0)  // MEM_MAP[REG_BG34NBA] = 0
  la t1,BG34NBA          // T1 = BG34NBA
  jr gp
  sb t0,0(t1)            // BG34NBA = T0 (Delay Slot)

STORE210D:
  // $210D REG_BG1HOFS           BG1 Horizontal Scroll (X) / M7HOFS                   1B/W D
  lbu t0,REG_BG1HOFS(a0) // T0 = MEM_MAP[REG_BG1HOFS]
  sb r0,REG_BG1HOFS(a0)  // MEM_MAP[REG_BG1HOFS] = 0
  la t1,BG1HOFS          // T1 = BG1HOFS
  lbu t2,2(t1)           // T2 = BG1HOFS Flip Flop
  bnez t2,BG1HOFSHI      // IF (Flip Flop != 0) Write Hi Byte, Else Write Lo Byte
  addiu t2,1             // T2++ (Delay Slot)
  sb t0,1(t1)            // BG1HOFS Lo = T0
  b BG1HOFSEND
  nop                    // Delay Slot
  BG1HOFSHI:
  sb t0,0(t1)            // BG1HOFS Hi = T0
  BG1HOFSEND:
  andi t2,1              // T2 &= 1
  jr gp
  sb t2,2(t1)            // BG1HOFS Flip Flop = T2 (Delay Slot)

STORE210E:
  // $210E REG_BG1VOFS           BG1 Vertical   Scroll (Y) / M7VOFS                   1B/W D
  lbu t0,REG_BG1VOFS(a0) // T0 = MEM_MAP[REG_BG1VOFS]
  sb r0,REG_BG1VOFS(a0)  // MEM_MAP[REG_BG1VOFS] = 0
  la t1,BG1VOFS          // T1 = BG1VOFS
  lbu t2,2(t1)           // T2 = BG1VOFS Flip Flop
  bnez t2,BG1VOFSHI      // IF (Flip Flop != 0) Write Hi Byte, Else Write Lo Byte
  addiu t2,1             // T2++ (Delay Slot)
  sb t0,1(t1)            // BG1VOFS Lo = T0
  b BG1VOFSEND
  nop                    // Delay Slot
  BG1VOFSHI:
  sb t0,0(t1)            // BG1VOFS Hi = T0
  BG1VOFSEND:
  andi t2,1              // T2 &= 1
  jr gp
  sb t2,2(t1)            // BG1VOFS Flip Flop = T2 (Delay Slot)

STORE210F:
  // $210F REG_BG2HOFS           BG2 Horizontal Scroll (X)                            1B/W D
  lbu t0,REG_BG2HOFS(a0) // T0 = MEM_MAP[REG_BG2HOFS]
  sb r0,REG_BG2HOFS(a0)  // MEM_MAP[REG_BG2HOFS] = 0
  la t1,BG2HOFS          // T1 = BG2HOFS
  lbu t2,2(t1)           // T2 = BG2HOFS Flip Flop
  bnez t2,BG2HOFSHI      // IF (Flip Flop != 0) Write Hi Byte, Else Write Lo Byte
  addiu t2,1             // T2++ (Delay Slot)
  sb t0,1(t1)            // BG2HOFS Lo = T0
  b BG2HOFSEND
  nop                    // Delay Slot
  BG2HOFSHI:
  sb t0,0(t1)            // BG2HOFS Hi = T0
  BG2HOFSEND:
  andi t2,1              // T2 &= 1
  jr gp
  sb t2,2(t1)            // BG2HOFS Flip Flop = T2 (Delay Slot)

STORE2110:
  // $2110 REG_BG2VOFS           BG2 Vertical   Scroll (Y)                            1B/W D
  lbu t0,REG_BG2VOFS(a0) // T0 = MEM_MAP[REG_BG2VOFS]
  sb r0,REG_BG2VOFS(a0)  // MEM_MAP[REG_BG2VOFS] = 0
  la t1,BG2VOFS          // T1 = BG2VOFS
  lbu t2,2(t1)           // T2 = BG2VOFS Flip Flop
  bnez t2,BG2VOFSHI      // IF (Flip Flop != 0) Write Hi Byte, Else Write Lo Byte
  addiu t2,1             // T2++ (Delay Slot)
  sb t0,1(t1)            // BG2VOFS Lo = T0
  b BG2VOFSEND
  nop                    // Delay Slot
  BG2VOFSHI:
  sb t0,0(t1)            // BG2VOFS Hi = T0
  BG2VOFSEND:
  andi t2,1              // T2 &= 1
  jr gp
  sb t2,2(t1)            // BG2VOFS Flip Flop = T2 (Delay Slot)

STORE2111:
  // $2111 REG_BG3HOFS           BG3 Horizontal Scroll (X)                            1B/W D
  lbu t0,REG_BG3HOFS(a0) // T0 = MEM_MAP[REG_BG3HOFS]
  sb r0,REG_BG3HOFS(a0)  // MEM_MAP[REG_BG3HOFS] = 0
  la t1,BG3HOFS          // T1 = BG3HOFS
  lbu t2,2(t1)           // T2 = BG3HOFS Flip Flop
  bnez t2,BG3HOFSHI      // IF (Flip Flop != 0) Write Hi Byte, Else Write Lo Byte
  addiu t2,1             // T2++ (Delay Slot)
  sb t0,1(t1)            // BG3HOFS Lo = T0
  b BG3HOFSEND
  nop                    // Delay Slot
  BG3HOFSHI:
  sb t0,0(t1)            // BG3HOFS Hi = T0
  BG3HOFSEND:
  andi t2,1              // T2 &= 1
  jr gp
  sb t2,2(t1)            // BG3HOFS Flip Flop = T2 (Delay Slot)

STORE2112:
  // $2112 REG_BG3VOFS           BG3 Vertical   Scroll (Y)                            1B/W D
  lbu t0,REG_BG3VOFS(a0) // T0 = MEM_MAP[REG_BG3VOFS]
  sb r0,REG_BG3VOFS(a0)  // MEM_MAP[REG_BG3VOFS] = 0
  la t1,BG3VOFS          // T1 = BG3VOFS
  lbu t2,2(t1)           // T2 = BG3VOFS Flip Flop
  bnez t2,BG3VOFSHI      // IF (Flip Flop != 0) Write Hi Byte, Else Write Lo Byte
  addiu t2,1             // T2++ (Delay Slot)
  sb t0,1(t1)            // BG3VOFS Lo = T0
  b BG3VOFSEND
  nop                    // Delay Slot
  BG3VOFSHI:
  sb t0,0(t1)            // BG3VOFS Hi = T0
  BG3VOFSEND:
  andi t2,1              // T2 &= 1
  jr gp
  sb t2,2(t1)            // BG3VOFS Flip Flop = T2 (Delay Slot)

STORE2113:
  // $2113 REG_BG4HOFS           BG4 Horizontal Scroll (X)                            1B/W D
  lbu t0,REG_BG4HOFS(a0) // T0 = MEM_MAP[REG_BG4HOFS]
  sb r0,REG_BG4HOFS(a0)  // MEM_MAP[REG_BG4HOFS] = 0
  la t1,BG4HOFS          // T1 = BG4HOFS
  lbu t2,2(t1)           // T2 = BG4HOFS Flip Flop
  bnez t2,BG4HOFSHI      // IF (Flip Flop != 0) Write Hi Byte, Else Write Lo Byte
  addiu t2,1             // T2++ (Delay Slot)
  sb t0,1(t1)            // BG4HOFS Lo = T0
  b BG4HOFSEND
  nop                    // Delay Slot
  BG4HOFSHI:
  sb t0,0(t1)            // BG4HOFS Hi = T0
  BG4HOFSEND:
  andi t2,1              // T2 &= 1
  jr gp
  sb t2,2(t1)            // BG4HOFS Flip Flop = T2 (Delay Slot)

STORE2114:
  // $2114 REG_BG4VOFS           BG4 Vertical   Scroll (Y)                            1B/W D
  lbu t0,REG_BG4VOFS(a0) // T0 = MEM_MAP[REG_BG4VOFS]
  sb r0,REG_BG4VOFS(a0)  // MEM_MAP[REG_BG4VOFS] = 0
  la t1,BG4VOFS          // T1 = BG4VOFS
  lbu t2,2(t1)           // T2 = BG4VOFS Flip Flop
  bnez t2,BG4VOFSHI      // IF (Flip Flop != 0) Write Hi Byte, Else Write Lo Byte
  addiu t2,1             // T2++ (Delay Slot)
  sb t0,1(t1)            // BG4VOFS Lo = T0
  b BG4VOFSEND
  nop                    // Delay Slot
  BG4VOFSHI:
  sb t0,0(t1)            // BG4VOFS Hi = T0
  BG4VOFSEND:
  andi t2,1              // T2 &= 1
  jr gp
  sb t2,2(t1)            // BG4VOFS Flip Flop = T2 (Delay Slot)

STORE2115:
  // $2115 REG_VMAIN             VRAM Address Increment Mode                          1B/W
  lbu t0,REG_VMAIN(a0)   // T0 = MEM_MAP[REG_VMAIN]
  sb r0,REG_VMAIN(a0)    // MEM_MAP[REG_VMAIN] = 0
  la t1,VMAIN            // T1 = VMAIN
  jr gp
  sb t0,0(t1)            // VMAIN = T0 (Delay Slot)

STORE2116:
  // $2116 REG_VMADDL            VRAM Address    (Lower 8bit)                         2B/W
  lbu t0,REG_VMADDL(a0)  // T0 = MEM_MAP[REG_VMADDL]
  sb r0,REG_VMADDL(a0)   // MEM_MAP[REG_VMADDL] = 0
  la t1,VMADD            // T1 = VMADD
  jr gp
  sb t0,1(t1)            // VMADD Lo = T0 (Delay Slot)

STORE2117:
  // $2117 REG_VMADDH            VRAM Address    (Upper 8bit)                         1B/W
  lbu t0,REG_VMADDH(a0)  // T0 = MEM_MAP[REG_VMADDH]
  sb r0,REG_VMADDH(a0)   // MEM_MAP[REG_VMADDH] = 0
  la t1,VMADD            // T1 = VMADD
  jr gp
  sb t0,0(t1)            // VMADD Hi = T0 (Delay Slot)

STORE2118:
  // $2118 REG_VMDATAL           VRAM Data Write (Lower 8bit)                         2B/W
  lbu t0,REG_VMDATAL(a0) // T0 = MEM_MAP[REG_VMDATAL]
  sb r0,REG_VMDATAL(a0)  // MEM_MAP[REG_VMDATAL] = 0
  la t1,VMDATA           // T1 = VMDATA
  lhu t2,-2(t1)          // T2 = VMADD
  la t3,VRAM             // T3 = VRAM
  sll t2,1               // VMADD << 1
  addu t3,t2             // VRAM += VMADD
  sb t0,1(t1)            // VMDATA Lo = T0
  sb t0,0(t3)            // VRAM[VMADD] Lo = T0
  lbu t3,-3(t1)          // T3 = VMAIN
  andi t4,t3,$80         // T4 = Increment VRAM Address After Accessing High/Low Byte (0=Low, 1=High)
  bnez t4,VMDATALEND     // IF (T4 != 0) VMDATALEND
  srl t2,1               // VMADD >> 1 (Delay Slot)
  andi t3,$03            // T3 = Address Increment Step (Increment Word-Address: 0=1, 1=32, 2=128, 3=128)
  beqz t3,VMDATALEND     // IF (T3 == 0) VMDATALEND
  addiu t2,1             // VMADD++ (Delay Slot)
  or t4,r0,1             // T4 = 1
  beq t3,t4,VMDATALEND   // IF (T3 == 1) VMDATALEND
  addiu t2,31            // VMADD += 31 (Delay Slot)
  addiu t2,96            // VMADD += 96
  VMDATALEND:
  jr gp
  sh t2,-2(t1)           // VMADD = T2 (Delay Slot)

STORE2119:
  // $2119 REG_VMDATAH           VRAM Data Write (Upper 8bit)                         1B/W
  lbu t0,REG_VMDATAH(a0) // T0 = MEM_MAP[REG_VMDATAH]
  sb r0,REG_VMDATAH(a0)  // MEM_MAP[REG_VMDATAH] = 0
  la t1,VMDATA           // T1 = VMDATA
  lhu t2,-2(t1)          // T2 = VMADD
  la t3,VRAM             // T3 = VRAM
  sll t2,1               // VMADD << 1
  addu t3,t2             // VRAM += VMADD
  sb t0,0(t1)            // VMDATA Hi = T0
  sb t0,1(t3)            // VRAM[VMADD] Hi = T0
  lbu t3,-3(t1)          // T3 = VMAIN
  andi t4,t3,$80         // T4 = Increment VRAM Address After Accessing High/Low Byte (0=Low, 1=High)
  beqz t4,VMDATAHEND     // IF (T4 == 0) VMDATAHEND
  srl t2,1               // VMADD >> 1 (Delay Slot)
  andi t3,$03            // T3 = Address Increment Step (Increment Word-Address: 0=1, 1=32, 2=128, 3=128)
  beqz t3,VMDATAHEND     // IF (T3 == 0) VMDATAHEND
  addiu t2,1             // VMADD++ (Delay Slot)
  or t4,r0,1             // T4 = 1
  beq t3,t4,VMDATAHEND   // IF (T3 == 1) VMDATAHEND
  addiu t2,31            // VMADD += 31 (Delay Slot)
  addiu t2,96            // VMADD += 96
  VMDATAHEND:
  jr gp
  sh t2,-2(t1)           // VMADD = T2 (Delay Slot)

STORE211A:
  // $211A REG_M7SEL             MODE7 Rot/Scale Mode Settings                        1B/W
  lbu t0,REG_M7SEL(a0)   // T0 = MEM_MAP[REG_M7SEL]
  sb r0,REG_M7SEL(a0)    // MEM_MAP[REG_M7SEL] = 0
  la t1,M7SEL            // T1 = M7SEL
  jr gp
  sb t0,0(t1)            // M7SEL = T0 (Delay Slot)

STORE211B:
  // $211B REG_M7A               MODE7 Rot/Scale A (COSINE A) & Maths 16bit Operand   1B/W D
  lbu t0,REG_M7A(a0)     // T0 = MEM_MAP[REG_M7A]
  sb r0,REG_M7A(a0)      // MEM_MAP[REG_M7A] = 0
  la t1,M7A              // T1 = M7A
  lbu t2,2(t1)           // T2 = M7A Flip Flop
  bnez t2,M7AHI          // IF (Flip Flop != 0) Write Hi Byte, Else Write Lo Byte
  addiu t2,1             // T2++ (Delay Slot)
  sb t0,1(t1)            // M7A Lo = T0
  b M7AEND
  nop                    // Delay Slot
  M7AHI:
  sb t0,0(t1)            // M7A Hi = T0
  M7AEND:
  andi t2,1              // T2 &= 1
  jr gp
  sb t2,2(t1)            // M7A Flip Flop = T2 (Delay Slot)

STORE211C:
  // $211C REG_M7B               MODE7 Rot/Scale B (SINE A)   & Maths  8bit Operand   1B/W D
  lbu t0,REG_M7B(a0)     // T0 = MEM_MAP[REG_M7B]
  sb r0,REG_M7B(a0)      // MEM_MAP[REG_M7B] = 0
  la t1,M7B              // T1 = M7B
  lbu t2,2(t1)           // T2 = M7B Flip Flop
  bnez t2,M7BHI          // IF (Flip Flop != 0) Write Hi Byte, Else Write Lo Byte
  addiu t2,1             // T2++ (Delay Slot)
  sb t0,1(t1)            // M7B Lo = T0
  b M7BEND
  nop                    // Delay Slot
  M7BHI:
  sb t0,0(t1)            // M7B Hi = T0
  M7BEND:
  andi t2,1              // T2 &= 1
  jr gp
  sb t2,2(t1)            // M7B Flip Flop = T2 (Delay Slot)

STORE211D:
  // $211D REG_M7C               MODE7 Rot/Scale C (SINE B)                           1B/W D
  lbu t0,REG_M7C(a0)     // T0 = MEM_MAP[REG_M7C]
  sb r0,REG_M7C(a0)      // MEM_MAP[REG_M7C] = 0
  la t1,M7C              // T1 = M7C
  lbu t2,2(t1)           // T2 = M7C Flip Flop
  bnez t2,M7CHI          // IF (Flip Flop != 0) Write Hi Byte, Else Write Lo Byte
  addiu t2,1             // T2++ (Delay Slot)
  sb t0,1(t1)            // M7C Lo = T0
  b M7CEND
  nop                    // Delay Slot
  M7CHI:
  sb t0,0(t1)            // M7C Hi = T0
  M7CEND:
  andi t2,1              // T2 &= 1
  jr gp
  sb t2,2(t1)            // M7C Flip Flop = T2 (Delay Slot)

STORE211E:
  // $211E REG_M7D               MODE7 Rot/Scale D (COSINE B)                         1B/W D
  lbu t0,REG_M7D(a0)     // T0 = MEM_MAP[REG_M7D]
  sb r0,REG_M7D(a0)      // MEM_MAP[REG_M7D] = 0
  la t1,M7D              // T1 = M7D
  lbu t2,2(t1)           // T2 = M7D Flip Flop
  bnez t2,M7DHI          // IF (Flip Flop != 0) Write Hi Byte, Else Write Lo Byte
  addiu t2,1             // T2++ (Delay Slot)
  sb t0,1(t1)            // M7D Lo = T0
  b M7DEND
  nop                    // Delay Slot
  M7DHI:
  sb t0,0(t1)            // M7D Hi = T0
  M7DEND:
  andi t2,1              // T2 &= 1
  jr gp
  sb t2,2(t1)            // M7D Flip Flop = T2 (Delay Slot)

STORE211F:
  // $211F REG_M7X               MODE7 Rot/Scale Center Coordinate X                  1B/W D
  lbu t0,REG_M7X(a0)     // T0 = MEM_MAP[REG_M7X]
  sb r0,REG_M7X(a0)      // MEM_MAP[REG_M7X] = 0
  la t1,M7X              // T1 = M7X
  lbu t2,2(t1)           // T2 = M7X Flip Flop
  bnez t2,M7XHI          // IF (Flip Flop != 0) Write Hi Byte, Else Write Lo Byte
  addiu t2,1             // T2++ (Delay Slot)
  sb t0,1(t1)            // M7X Lo = T0
  b M7XEND
  nop                    // Delay Slot
  M7XHI:
  sb t0,0(t1)            // M7X Hi = T0
  M7XEND:
  andi t2,1              // T2 &= 1
  jr gp
  sb t2,2(t1)            // M7X Flip Flop = T2 (Delay Slot)

STORE2120:
  // $2120 REG_M7Y               MODE7 Rot/Scale Center Coordinate Y                  1B/W D
  lbu t0,REG_M7Y(a0)     // T0 = MEM_MAP[REG_M7Y]
  sb r0,REG_M7Y(a0)      // MEM_MAP[REG_M7Y] = 0
  la t1,M7Y              // T1 = M7Y
  lbu t2,2(t1)           // T2 = M7Y Flip Flop
  bnez t2,M7YHI          // IF (Flip Flop != 0) Write Hi Byte, Else Write Lo Byte
  addiu t2,1             // T2++ (Delay Slot)
  sb t0,1(t1)            // M7Y Lo = T0
  b M7YEND
  nop                    // Delay Slot
  M7YHI:
  sb t0,0(t1)            // M7Y Hi = T0
  M7YEND:
  andi t2,1              // T2 &= 1
  jr gp
  sb t2,2(t1)            // M7Y Flip Flop = T2 (Delay Slot)

STORE2121:
  // $2121 REG_CGADD             Palette CGRAM Address                                1B/W
  lbu t0,REG_CGADD(a0)   // T0 = MEM_MAP[REG_CGADD]
  sb r0,REG_CGADD(a0)    // MEM_MAP[REG_CGADD] = 0
  la t1,CGADD            // T1 = CGADD
  jr gp
  sb t0,0(t1)            // CGADD = T0 (Delay Slot)

STORE2122:
  // $2122 REG_CGDATA            Palette CGRAM Data Write                             1B/W D
  lbu t0,REG_CGDATA(a0)  // T0 = MEM_MAP[REG_CGDATA]
  sb r0,REG_CGDATA(a0)   // MEM_MAP[REG_CGDATA] = 0
  la t1,CGDATA           // T1 = CGDATA
  lbu t2,2(t1)           // T2 = CGDATA Flip Flop
  lbu t3,-1(t1)          // T3 = CGADD
  la t4,CGRAM            // T4 = CGRAM
  sll t3,1               // CGADD << 1
  bnez t2,CGDATAHI       // IF (Flip Flop != 0) Write Hi Byte, Else Write Lo Byte
  addu t4,t3             // CGRAM += CGADD (Delay Slot)
  sb t0,1(t1)            // CGDATA Lo = T0
  sb t0,0(t4)            // CGRAM[CGADD] Lo = T0
  b CGDATAEND
  nop                    // Delay Slot
  CGDATAHI:
  sb t0,0(t1)            // CGDATA Hi = T0
  sb t0,1(t4)            // CGRAM[CGADD] Hi = T0
  srl t3,1               // CGADD >> 1
  addiu t3,1             // CGADD++
  sb t3,-1(t1)           // CGADD = T3
  CGDATAEND:
  addiu t2,1             // T2++
  andi t2,1              // T2 &= 1
  jr gp
  sb t2,2(t1)            // CGDATA Flip Flop = T2 (Delay Slot)

STORE2123:
  // $2123 REG_W12SEL            Window BG1/BG2  Mask Settings                        1B/W
  lbu t0,REG_W12SEL(a0)  // T0 = MEM_MAP[REG_W12SEL]
  sb r0,REG_W12SEL(a0)   // MEM_MAP[REG_W12SEL] = 0
  la t1,W12SEL           // T1 = W12SEL
  jr gp
  sb t0,0(t1)            // W12SEL = T0 (Delay Slot)

STORE2124:
  // $2124 REG_W34SEL            Window BG3/BG4  Mask Settings                        1B/W
  lbu t0,REG_W34SEL(a0)  // T0 = MEM_MAP[REG_W34SEL]
  sb r0,REG_W34SEL(a0)   // MEM_MAP[REG_W34SEL] = 0
  la t1,W34SEL           // T1 = W34SEL
  jr gp
  sb t0,0(t1)            // W34SEL = T0 (Delay Slot)

STORE2125:
  // $2125 REG_WOBJSEL           Window OBJ/MATH Mask Settings                        1B/W
  lbu t0,REG_WOBJSEL(a0) // T0 = MEM_MAP[REG_WOBJSEL]
  sb r0,REG_WOBJSEL(a0)  // MEM_MAP[REG_WOBJSEL] = 0
  la t1,WOBJSEL          // T1 = WOBJSEL
  jr gp
  sb t0,0(t1)            // WOBJSEL = T0 (Delay Slot)

STORE2126:
  // $2126 REG_WH0               Window 1 Left  Position (X1)                         1B/W
  lbu t0,REG_WH0(a0)     // T0 = MEM_MAP[REG_WH0]
  sb r0,REG_WH0(a0)      // MEM_MAP[REG_WH0] = 0
  la t1,WH0              // T1 = WH0
  jr gp
  sb t0,0(t1)            // WH0 = T0 (Delay Slot)

STORE2127:
  // $2127 REG_WH1               Window 1 Right Position (X2)                         1B/W
  lbu t0,REG_WH1(a0)     // T0 = MEM_MAP[REG_WH1]
  sb r0,REG_WH1(a0)      // MEM_MAP[REG_WH1] = 0
  la t1,WH1              // T1 = WH1
  jr gp
  sb t0,0(t1)            // WH1 = T0 (Delay Slot)

STORE2128:
  // $2128 REG_WH2               Window 2 Left  Position (X1)                         1B/W
  lbu t0,REG_WH2(a0)     // T0 = MEM_MAP[REG_WH2]
  sb r0,REG_WH2(a0)      // MEM_MAP[REG_WH2] = 0
  la t1,WH2              // T1 = WH2
  jr gp
  sb t0,0(t1)            // WH2 = T0 (Delay Slot)

STORE2129:
  // $2129 REG_WH3               Window 2 Right Position (X2)                         1B/W
  lbu t0,REG_WH3(a0)     // T0 = MEM_MAP[REG_WH3]
  sb r0,REG_WH3(a0)      // MEM_MAP[REG_WH3] = 0
  la t1,WH3              // T1 = WH3
  jr gp
  sb t0,0(t1)            // WH3 = T0 (Delay Slot)

STORE212A:
  // $212A REG_WBGLOG            Window 1/2 Mask Logic (BG1-BG4)                      1B/W
  lbu t0,REG_WBGLOG(a0)  // T0 = MEM_MAP[REG_WBGLOG]
  sb r0,REG_WBGLOG(a0)   // MEM_MAP[REG_WBGLOG] = 0
  la t1,WBGLOG           // T1 = WBGLOG
  jr gp
  sb t0,0(t1)            // WBGLOG = T0 (Delay Slot)

STORE212B:
  // $212B REG_WOBJLOG           Window 1/2 Mask Logic (OBJ/MATH)                     1B/W
  lbu t0,REG_WOBJLOG(a0) // T0 = MEM_MAP[REG_WOBJLOG]
  sb r0,REG_WOBJLOG(a0)  // MEM_MAP[REG_WOBJLOG] = 0
  la t1,WOBJLOG          // T1 = WOBJLOG
  jr gp
  sb t0,0(t1)            // WOBJLOG = T0 (Delay Slot)

STORE212C:
  // $212C REG_TM                Main Screen Designation                              1B/W
  lbu t0,REG_TM(a0)      // T0 = MEM_MAP[REG_TM]
  sb r0,REG_TM(a0)       // MEM_MAP[REG_TM] = 0
  la t1,TM               // T1 = TM
  jr gp
  sb t0,0(t1)            // TM = T0 (Delay Slot)

STORE212D:
  // $212D REG_TS                Sub  Screen Designation                              1B/W
  lbu t0,REG_TS(a0)      // T0 = MEM_MAP[REG_TS]
  sb r0,REG_TS(a0)       // MEM_MAP[REG_TS] = 0
  la t1,TS               // T1 = TS
  jr gp
  sb t0,0(t1)            // TS = T0 (Delay Slot)

STORE212E:
  // $212E REG_TMW               Window Area Main Screen Disable                      1B/W
  lbu t0,REG_TMW(a0)     // T0 = MEM_MAP[REG_TMW]
  sb r0,REG_TMW(a0)      // MEM_MAP[REG_TMW] = 0
  la t1,TMW              // T1 = TMW
  jr gp
  sb t0,0(t1)            // TMW = T0 (Delay Slot)

STORE212F:
  // $212F REG_TSW               Window Area Sub  Screen Disable                      1B/W
  lbu t0,REG_TSW(a0)     // T0 = MEM_MAP[REG_TSW]
  sb r0,REG_TSW(a0)      // MEM_MAP[REG_TSW] = 0
  la t1,TSW              // T1 = TSW
  jr gp
  sb t0,0(t1)            // TSW = T0 (Delay Slot)

STORE2130:
  // $2130 REG_CGWSEL            Color Math Control Register A                        1B/W
  lbu t0,REG_CGWSEL(a0)  // T0 = MEM_MAP[REG_CGWSEL]
  sb r0,REG_CGWSEL(a0)   // MEM_MAP[REG_CGWSEL] = 0
  la t1,CGWSEL           // T1 = CGWSEL
  jr gp
  sb t0,0(t1)            // CGWSEL = T0 (Delay Slot)

STORE2131:
  // $2131 REG_CGADSUB           Color Math Control Register B                        1B/W
  lbu t0,REG_CGADSUB(a0) // T0 = MEM_MAP[REG_CGADSUB]
  sb r0,REG_CGADSUB(a0)  // MEM_MAP[REG_CGADSUB] = 0
  la t1,CGADSUB          // T1 = CGADSUB
  jr gp
  sb t0,0(t1)            // CGADSUB = T0 (Delay Slot)

STORE2132:
  // $2132 REG_COLDATA           Color Math Sub Screen Backdrop Color                 1B/W
  lbu t0,REG_COLDATA(a0) // T0 = MEM_MAP[REG_COLDATA]
  sb r0,REG_COLDATA(a0)  // MEM_MAP[REG_COLDATA] = 0
  la t1,COLDATA          // T1 = COLDATA
  jr gp
  sb t0,0(t1)            // COLDATA = T0 (Delay Slot)

STORE2133:
  // $2133 REG_SETINI            Display Control 2                                    1B/W
  lbu t0,REG_SETINI(a0)  // T0 = MEM_MAP[REG_SETINI]
  sb r0,REG_SETINI(a0)   // MEM_MAP[REG_SETINI] = 0
  la t1,SETINI           // T1 = SETINI
  jr gp
  sb t0,0(t1)            // SETINI = T0 (Delay Slot)

STORE2134:
  // $2134 REG_MPYL              PPU1 Signed Multiply Result (Lower  8bit)            1B/R
  jr gp
  nop                    // Delay Slot

STORE2135:
  // $2135 REG_MPYM              PPU1 Signed Multiply Result (Middle 8bit)            1B/R
  jr gp
  nop                    // Delay Slot

STORE2136:
  // $2136 REG_MPYH              PPU1 Signed Multiply Result (Upper  8bit)            1B/R
  jr gp
  nop                    // Delay Slot

STORE2137:
  // $2137 REG_SLHV              PPU1 Latch H/V-Counter By Software (Read=Strobe)     1B/R
  jr gp
  nop                    // Delay Slot

STORE2138:
  // $2138 REG_RDOAM             PPU1 OAM  Data Read                                  1B/R D
  jr gp
  nop                    // Delay Slot

STORE2139:
  // $2139 REG_RDVRAML           PPU1 VRAM  Data Read (Lower 8bits)                   1B/R
  jr gp
  nop                    // Delay Slot

STORE213A:
  // $213A REG_RDVRAMH           PPU1 VRAM  Data Read (Upper 8bits)                   1B/R
  jr gp
  nop                    // Delay Slot

STORE213B:
  // $213B REG_RDCGRAM           PPU2 CGRAM Data Read (Palette)                       1B/R D
  jr gp
  nop                    // Delay Slot

STORE213C:
  // $213C REG_OPHCT             PPU2 Horizontal Counter Latch (Scanline X)           1B/R D
  jr gp
  nop                    // Delay Slot

STORE213D:
  // $213D REG_OPVCT             PPU2 Vertical   Counter Latch (Scanline Y)           1B/R D
  jr gp
  nop                    // Delay Slot

STORE213E:
  // $213E REG_STAT77            PPU1 Status & PPU1 Version Number                    1B/R
  jr gp
  nop                    // Delay Slot

STORE213F:
  // $213F REG_STAT78            PPU2 Status & PPU2 Version Number (Bit 7=0)          1B/R
  jr gp
  nop                    // Delay Slot

STORE2140:
  // $2140 REG_APUIO0            Main CPU To Sound CPU Communication Port 0           1B/RW
  jr gp
  nop                    // Delay Slot

STORE2141:
  // $2141 REG_APUIO1            Main CPU To Sound CPU Communication Port 1           1B/RW
  jr gp
  nop                    // Delay Slot

STORE2142:
  // $2142 REG_APUIO2            Main CPU To Sound CPU Communication Port 2           1B/RW
  jr gp
  nop                    // Delay Slot

STORE2143:
  // $2143 REG_APUIO3            Main CPU To Sound CPU Communication Port 3           1B/RW
  jr gp
  nop                    // Delay Slot

STORE2144:
  // $2144 REG_APUIO0            Main CPU To Sound CPU Communication Port 0           1B/RW
  jr gp
  nop                    // Delay Slot

STORE2145:
  // $2145 REG_APUIO1            Main CPU To Sound CPU Communication Port 1           1B/RW
  jr gp
  nop                    // Delay Slot

STORE2146:
  // $2146 REG_APUIO2            Main CPU To Sound CPU Communication Port 2           1B/RW
  jr gp
  nop                    // Delay Slot

STORE2147:
  // $2147 REG_APUIO3            Main CPU To Sound CPU Communication Port 3           1B/RW
  jr gp
  nop                    // Delay Slot

STORE2148:
  // $2148 REG_APUIO0            Main CPU To Sound CPU Communication Port 0           1B/RW
  jr gp
  nop                    // Delay Slot

STORE2149:
  // $2149 REG_APUIO1            Main CPU To Sound CPU Communication Port 1           1B/RW
  jr gp
  nop                    // Delay Slot

STORE214A:
  // $214A REG_APUIO2            Main CPU To Sound CPU Communication Port 2           1B/RW
  jr gp
  nop                    // Delay Slot

STORE214B:
  // $214B REG_APUIO3            Main CPU To Sound CPU Communication Port 3           1B/RW
  jr gp
  nop                    // Delay Slot

STORE214C:
  // $214C REG_APUIO0            Main CPU To Sound CPU Communication Port 0           1B/RW
  jr gp
  nop                    // Delay Slot

STORE214D:
  // $214D REG_APUIO1            Main CPU To Sound CPU Communication Port 1           1B/RW
  jr gp
  nop                    // Delay Slot

STORE214E:
  // $214E REG_APUIO2            Main CPU To Sound CPU Communication Port 2           1B/RW
  jr gp
  nop                    // Delay Slot

STORE214F:
  // $214F REG_APUIO3            Main CPU To Sound CPU Communication Port 3           1B/RW
  jr gp
  nop                    // Delay Slot

STORE2150:
  // $2150 REG_APUIO0            Main CPU To Sound CPU Communication Port 0           1B/RW
  jr gp
  nop                    // Delay Slot

STORE2151:
  // $2151 REG_APUIO1            Main CPU To Sound CPU Communication Port 1           1B/RW
  jr gp
  nop                    // Delay Slot

STORE2152:
  // $2152 REG_APUIO2            Main CPU To Sound CPU Communication Port 2           1B/RW
  jr gp
  nop                    // Delay Slot

STORE2153:
  // $2153 REG_APUIO3            Main CPU To Sound CPU Communication Port 3           1B/RW
  jr gp
  nop                    // Delay Slot

STORE2154:
  // $2154 REG_APUIO0            Main CPU To Sound CPU Communication Port 0           1B/RW
  jr gp
  nop                    // Delay Slot

STORE2155:
  // $2155 REG_APUIO1            Main CPU To Sound CPU Communication Port 1           1B/RW
  jr gp
  nop                    // Delay Slot

STORE2156:
  // $2156 REG_APUIO2            Main CPU To Sound CPU Communication Port 2           1B/RW
  jr gp
  nop                    // Delay Slot

STORE2157:
  // $2157 REG_APUIO3            Main CPU To Sound CPU Communication Port 3           1B/RW
  jr gp
  nop                    // Delay Slot

STORE2158:
  // $2158 REG_APUIO0            Main CPU To Sound CPU Communication Port 0           1B/RW
  jr gp
  nop                    // Delay Slot

STORE2159:
  // $2159 REG_APUIO1            Main CPU To Sound CPU Communication Port 1           1B/RW
  jr gp
  nop                    // Delay Slot

STORE215A:
  // $215A REG_APUIO2            Main CPU To Sound CPU Communication Port 2           1B/RW
  jr gp
  nop                    // Delay Slot

STORE215B:
  // $215B REG_APUIO3            Main CPU To Sound CPU Communication Port 3           1B/RW
  jr gp
  nop                    // Delay Slot

STORE215C:
  // $215C REG_APUIO0            Main CPU To Sound CPU Communication Port 0           1B/RW
  jr gp
  nop                    // Delay Slot

STORE215D:
  // $215D REG_APUIO1            Main CPU To Sound CPU Communication Port 1           1B/RW
  jr gp
  nop                    // Delay Slot

STORE215E:
  // $215E REG_APUIO2            Main CPU To Sound CPU Communication Port 2           1B/RW
  jr gp
  nop                    // Delay Slot

STORE215F:
  // $215F REG_APUIO3            Main CPU To Sound CPU Communication Port 3           1B/RW
  jr gp
  nop                    // Delay Slot

STORE2160:
  // $2160 REG_APUIO0            Main CPU To Sound CPU Communication Port 0           1B/RW
  jr gp
  nop                    // Delay Slot

STORE2161:
  // $2161 REG_APUIO1            Main CPU To Sound CPU Communication Port 1           1B/RW
  jr gp
  nop                    // Delay Slot

STORE2162:
  // $2162 REG_APUIO2            Main CPU To Sound CPU Communication Port 2           1B/RW
  jr gp
  nop                    // Delay Slot

STORE2163:
  // $2163 REG_APUIO3            Main CPU To Sound CPU Communication Port 3           1B/RW
  jr gp
  nop                    // Delay Slot

STORE2164:
  // $2164 REG_APUIO0            Main CPU To Sound CPU Communication Port 0           1B/RW
  jr gp
  nop                    // Delay Slot

STORE2165:
  // $2165 REG_APUIO1            Main CPU To Sound CPU Communication Port 1           1B/RW
  jr gp
  nop                    // Delay Slot

STORE2166:
  // $2166 REG_APUIO2            Main CPU To Sound CPU Communication Port 2           1B/RW
  jr gp
  nop                    // Delay Slot

STORE2167:
  // $2167 REG_APUIO3            Main CPU To Sound CPU Communication Port 3           1B/RW
  jr gp
  nop                    // Delay Slot

STORE2168:
  // $2168 REG_APUIO0            Main CPU To Sound CPU Communication Port 0           1B/RW
  jr gp
  nop                    // Delay Slot

STORE2169:
  // $2169 REG_APUIO1            Main CPU To Sound CPU Communication Port 1           1B/RW
  jr gp
  nop                    // Delay Slot

STORE216A:
  // $216A REG_APUIO2            Main CPU To Sound CPU Communication Port 2           1B/RW
  jr gp
  nop                    // Delay Slot

STORE216B:
  // $216B REG_APUIO3            Main CPU To Sound CPU Communication Port 3           1B/RW
  jr gp
  nop                    // Delay Slot

STORE216C:
  // $216C REG_APUIO0            Main CPU To Sound CPU Communication Port 0           1B/RW
  jr gp
  nop                    // Delay Slot

STORE216D:
  // $216D REG_APUIO1            Main CPU To Sound CPU Communication Port 1           1B/RW
  jr gp
  nop                    // Delay Slot

STORE216E:
  // $216E REG_APUIO2            Main CPU To Sound CPU Communication Port 2           1B/RW
  jr gp
  nop                    // Delay Slot

STORE216F:
  // $216F REG_APUIO3            Main CPU To Sound CPU Communication Port 3           1B/RW
  jr gp
  nop                    // Delay Slot

STORE2170:
  // $2170 REG_APUIO0            Main CPU To Sound CPU Communication Port 0           1B/RW
  jr gp
  nop                    // Delay Slot

STORE2171:
  // $2171 REG_APUIO1            Main CPU To Sound CPU Communication Port 1           1B/RW
  jr gp
  nop                    // Delay Slot

STORE2172:
  // $2172 REG_APUIO2            Main CPU To Sound CPU Communication Port 2           1B/RW
  jr gp
  nop                    // Delay Slot

STORE2173:
  // $2173 REG_APUIO3            Main CPU To Sound CPU Communication Port 3           1B/RW
  jr gp
  nop                    // Delay Slot

STORE2174:
  // $2174 REG_APUIO0            Main CPU To Sound CPU Communication Port 0           1B/RW
  jr gp
  nop                    // Delay Slot

STORE2175:
  // $2175 REG_APUIO1            Main CPU To Sound CPU Communication Port 1           1B/RW
  jr gp
  nop                    // Delay Slot

STORE2176:
  // $2176 REG_APUIO2            Main CPU To Sound CPU Communication Port 2           1B/RW
  jr gp
  nop                    // Delay Slot

STORE2177:
  // $2177 REG_APUIO3            Main CPU To Sound CPU Communication Port 3           1B/RW
  jr gp
  nop                    // Delay Slot

STORE2178:
  // $2178 REG_APUIO0            Main CPU To Sound CPU Communication Port 0           1B/RW
  jr gp
  nop                    // Delay Slot

STORE2179:
  // $2179 REG_APUIO1            Main CPU To Sound CPU Communication Port 1           1B/RW
  jr gp
  nop                    // Delay Slot

STORE217A:
  // $217A REG_APUIO2            Main CPU To Sound CPU Communication Port 2           1B/RW
  jr gp
  nop                    // Delay Slot

STORE217B:
  // $217B REG_APUIO3            Main CPU To Sound CPU Communication Port 3           1B/RW
  jr gp
  nop                    // Delay Slot

STORE217C:
  // $217C REG_APUIO0            Main CPU To Sound CPU Communication Port 0           1B/RW
  jr gp
  nop                    // Delay Slot

STORE217D:
  // $217D REG_APUIO1            Main CPU To Sound CPU Communication Port 1           1B/RW
  jr gp
  nop                    // Delay Slot

STORE217E:
  // $217E REG_APUIO2            Main CPU To Sound CPU Communication Port 2           1B/RW
  jr gp
  nop                    // Delay Slot

STORE217F:
  // $217F REG_APUIO3            Main CPU To Sound CPU Communication Port 3           1B/RW
  jr gp
  nop                    // Delay Slot

STORE2180:
  // $2180 REG_WMDATA            WRAM Data Read/Write                                 1B/RW
  la t3,WMADD            // T3 = WMADD
  lbu t0,REG_WMDATA(a0)  // T0 = MEM_MAP[REG_WMDATA]
  lw t1,0(t3)            // T1 = WMADD: WRAM 17-Bit Address
  la t2,WRAM             // T2 = WRAM
  addu t2,t1             // WRAM += WMADD
  sb t0,0(t2)            // WRAM[WMADD] = T0
  addiu t1,1             // WMADD++
  li t2,$0001FFFF        // T2 = $0001FFFF
  and t1,t2              // WMADD &= T2
  jr gp
  sw t1,0(t3)            // WMADD = T1 (Delay Slot)

STORE2181:
  // $2181 REG_WMADDL            WRAM Address (Lower  8bit)                           1B/W
  lbu t0,REG_WMADDL(a0)  // T0 = MEM_MAP[REG_WMADDL]
  sb r0,REG_WMADDL(a0)   // MEM_MAP[REG_WMADDL] = 0
  la t1,WMADD            // T1 = WMADD
  jr gp
  sb t0,3(t1)            // WMADD Lo = T0 (Delay Slot)

STORE2182:
  // $2182 REG_WMADDM            WRAM Address (Middle 8bit)                           1B/W
  lbu t0,REG_WMADDM(a0)  // T0 = MEM_MAP[REG_WMADDM]
  sb r0,REG_WMADDM(a0)   // MEM_MAP[REG_WMADDM] = 0
  la t1,WMADD            // T1 = WMADD
  jr gp
  sb t0,2(t1)            // WMADD Mid = T0 (Delay Slot)

STORE2183:
  // $2183 REG_WMADDH            WRAM Address (Upper  1bit)                           1B/W
  lbu t0,REG_WMADDH(a0)  // T0 = MEM_MAP[REG_WMADDH]
  andi t0,1              // T0 &= 1
  sb r0,REG_WMADDH(a0)   // MEM_MAP[REG_WMADDH] = 0
  la t1,WMADD            // T1 = WMADD
  jr gp
  sb t0,1(t1)            // WMADD Hi = T0 (Delay Slot)

STORE2184:
  // $2184..$21FF                Unused Region (Open Bus)/Expansion (B-Bus)
  jr gp
  nop                    // Delay Slot