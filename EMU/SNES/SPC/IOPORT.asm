// I/O Read/Write Type
la t0,IORWTable // T0 = I/O Read/Write Instruction Table
addu t0,gp // T0 = I/O Read/Write Instruction Table + CPU Instruction
lbu t0,0(t0) // T0 = I/O Read/Write Type

// I/O Register Read/Write
beqz t0,IORW_END // IF (I/O Read/Write Type == 0) Skip I/O Register Read/Write
nop // Delay Slot


// CONTROL Register Write
lli t1,$72 // T1 = Read 8-Bit ByteCode
beq t0,t1,CONTROLEND // IF (I/O Read/Write Type == Read 8-Bit "r") Skip CONTROL
nop // Delay Slot
lli t1,$52 // T1 = Read 16-Bit ByteCode
beq t0,t1,CONTROLEND // IF (I/O Read/Write Type == Read 16-Bit "R") Skip CONTROL
nop // Delay Slot
lli t1,$44 // T1 = Read/Read 8-Bit ByteCode
beq t0,t1,CONTROLEND // IF (I/O Read/Write Type == Read/Read 8-Bit "D") Skip CONTROL
nop // Delay Slot

addiu t1,a0,REG_CONTROL // T1 = MEM_MAP + REG_CONTROL
subiu t2,t1,1           // T2 = MEM_MAP + REG_CONTROL - 1
beq a2,t1,CONTROLWRITE  // IF (MEMAddressA == REG_CONTROL) Control Write
nop // Delay Slot

lli t3,$57 // T3 = DP Write 16-Bit ByteCode
bne t0,t3,CONTROLEND // IF (I/O Read/Write Type != Read/Write 8-Bit) Skip CONTROL
nop // Delay Slot
bne a2,t2,CONTROLEND // IF (MEMAddressA != REG_CONTROL - 1) Skip CONTROL
nop // Delay Slot

CONTROLWRITE:
sb r0,REG_T0OUT(a0) // REG_T0OUT = 0
sb r0,REG_T1OUT(a0) // REG_T1OUT = 0
sb r0,REG_T2OUT(a0) // REG_T2OUT = 0
and s6,r0 // S6 = Timer 0 Cycles Reset
and s7,r0 // S7 = Timer 1 Cycles Reset
and s8,r0 // S8 = Timer 2 Cycles Reset
CONTROLEND:


// DSP DATA Read/Write
la t1,DSP_MAP // T1 = DSP_MAP

lli t2,$77 // T2 = Write 8-Bit ByteCode
beq t0,t2,DSPDATAWRITE // IF (I/O Read/Write Type == Write 8-Bit "w") Skip DSP Data Register
nop // Delay Slot
lli t2,$57 // T2 = Write 16-Bit ByteCode
beq t0,t2,DSPDATAWRITE // IF (I/O Read/Write Type == Write 16-Bit "W") Skip DSP Data Register
nop // Delay Slot
lli t2,$64 // T2 = Read/Write 8-Bit ByteCode
beq t0,t2,DSPDATAWRITE // IF (I/O Read/Write Type == Read/Write 8-Bit "d") Skip DSP Data Register
nop // Delay Slot

addiu t2,a0,REG_DSPDATA // T2 = MEM_MAP + REG_DSPDATA
subiu t3,t2,1           // T3 = MEM_MAP + REG_DSPDATA - 1
beq a2,t2,DSPDATAREAD   // IF (MEMAddressA == REG_DSPDATA) DSP Data Read
nop // Delay Slot
beq a3,t2,DSPDATAREAD   // IF (MEMAddressB == REG_DSPDATA) DSP Data Read
nop // Delay Slot

lli t4,$52 // T4 = Read 16-Bit ByteCode
bne t0,t4,DSPDATAEND // IF (I/O Read/Write Type != Read 16-Bit) Skip DSP Data Register
nop // Delay Slot
bne a2,t3,DSPDATAEND // IF (MEMAddressA != REG_DSPDATA - 1) Skip DSP Data Register
nop // Delay Slot
bne a3,t3,DSPDATAEND // IF (MEMAddressB != REG_DSPDATA - 1) Skip DSP Data Register
nop // Delay Slot

DSPDATAREAD: // DSP Data Register Read
lbu t2,REG_DSPADDR(a0) // T0 = DSP Address
andi t2,$7F // DSP Address &= $7F (DSP Read Only Mirror Access)
addu t2,t1 // T2 = DSP_MAP + DSP Address
lbu t2,0(t2) // Load DSP Data From DSP Address
sb t2,REG_DSPDATA(a0) // Store DSP Data
j DSPDATAEND
nop // Delay Slot

addiu t2,a0,REG_DSPDATA // T2 = MEM_MAP + REG_DSPDATA
subiu t3,t2,1           // T3 = MEM_MAP + REG_DSPDATA - 1
beq a2,t2,DSPDATAWRITE  // IF (MEMAddressA == REG_DSPDATA) DSP Data Write
nop // Delay Slot

lli t4,$57 // T4 = Write 16-Bit ByteCode
bne t0,t4,DSPDATAEND // IF (I/O Read/Write Type != Write 16-Bit) Skip DSP Data Register
nop // Delay Slot
bne a2,t3,DSPDATAEND // IF (MEMAddressA != REG_DSPDATA - 1) Skip DSP Data Register
nop // Delay Slot

DSPDATAWRITE: // DSP Data Register Write
lbu t2,REG_DSPADDR(a0) // T2 = DSP Address
andi t2,$7F // DSP Address &= $7F (DSP Read Only Mirror Access)
addu t2,t1 // T2 = DSP_MAP + DSP Address
lbu t3,REG_DSPDATA(a0) // T3 = DSP Data
sb t3,0(t2) // Store DSP Data to DSP Address
DSPDATAEND:


// Timer OUT Register Read
T0OUTREADA:
addiu t0,a0,REG_T0OUT // T0 = MEM_MAP + REG_T0OUT
bne a2,t0,T1OUTREADA // IF (MEMAddressA == REG_T0OUT)
nop // Delay Slot
sb r0,REG_T0OUT(a0) // REG_T0OUT = 0

T1OUTREADA:
addiu t0,a0,REG_T1OUT // T0 = MEM_MAP + REG_T1OUT
bne a2,t0,T2OUTREADA // IF (MEMAddressA == REG_T1OUT)
nop // Delay Slot
sb r0,REG_T1OUT(a0) // REG_T1OUT = 0

T2OUTREADA:
addiu t0,a0,REG_T2OUT // T0 = MEM_MAP + REG_T2OUT
bne a2,t0,T0OUTREADB // IF (MEMAddressA == REG_T2OUT)
nop // Delay Slot
sb r0,REG_T2OUT(a0) // REG_T2OUT = 0

T0OUTREADB:
addiu t0,a0,REG_T0OUT // T0 = MEM_MAP + REG_T0OUT
bne a3,t0,T1OUTREADB // IF (MEMAddressB == REG_T0OUT)
nop // Delay Slot
sb r0,REG_T0OUT(a0) // REG_T0OUT = 0

T1OUTREADB:
addiu t0,a0,REG_T1OUT // T0 = MEM_MAP + REG_T1OUT
bne a3,t0,T2OUTREADB // IF (MEMAddressB == REG_T1OUT)
nop // Delay Slot
sb r0,REG_T1OUT(a0) // REG_T1OUT = 0

T2OUTREADB:
addiu t0,a0,REG_T2OUT // T0 = MEM_MAP + REG_T2OUT
bne a3,t0,IORW_END // IF (MEMAddressB == REG_T2OUT)
nop // Delay Slot
sb r0,REG_T2OUT(a0) // REG_T2OUT = 0

j IORW_END
nop // Delay Slot

IORWTable: // I/O Read/Write Instruction Table
  db $00, $00, "w", "r", "r", "r", "r", "r", $00, "d", "r", "w", "w", $00, "w", $00
  db $00, $00, "w", "r", "r", "r", "r", "r", "w", "d", "W", "w", $00, $00, "r", $00
  db $00, $00, "w", "r", "r", "r", "r", "r", $00, "d", "r", "w", "w", $00, "r", $00
  db $00, $00, "w", "r", "r", "r", "r", "r", "w", "d", "W", "w", $00, $00, "r", $00
  db $00, $00, "w", "r", "r", "r", "r", "r", $00, "d", "r", "w", "w", $00, "w", $00
  db $00, $00, "w", "r", "r", "r", "r", "r", "w", "d", "R", "w", $00, $00, "r", $00
  db $00, $00, "w", "r", "r", "r", "r", "r", $00, "D", "r", "w", "w", $00, "w", $00
  db $00, $00, "w", "r", "r", "r", "r", "r", "r", "D", "R", "w", $00, $00, "r", $00
  db $00, $00, "w", "r", "r", "r", "r", "r", $00, "d", "r", "w", "w", $00, $00, "w"
  db $00, $00, "w", "r", "r", "r", "r", "r", "w", "d", "R", "w", $00, $00, $00, $00
  db $00, $00, "w", "r", "r", "r", "r", "r", $00, "d", "r", "w", "w", $00, $00, "w"
  db $00, $00, "w", "r", "r", "r", "r", "r", "w", "d", "R", "w", $00, $00, $00, "r"
  db $00, $00, "w", "r", "w", "w", "w", "w", $00, "w", "w", "w", "w", $00, $00, $00
  db $00, $00, "w", "r", "w", "w", "w", "w", "w", "w", "W", "w", $00, $00, "r", $00
  db $00, $00, "w", "r", "r", "r", "r", "r", $00, "r", "w", "r", "r", $00, $00, $00
  db $00, $00, "w", "r", "r", "r", "r", "r", "r", "r", "d", "r", $00, $00, $00, $00

IORW_END:

// Instruction Cycles
subu k1,v0,k0 // K1 = InstCycles: Cycles - OldCycles (Get Last Instruction Cycle Count)
move k0,v0 // OldCycles = Cycles

// Timers
lbu t0,REG_CONTROL(a0) // IF (REG_CONTROL & 7) Timer 0..2 Used
andi t1,t0,7
bnez t1,T0_8KHz
nop // Delay Slot

sb r0,REG_T0OUT(a0) // ELSE Timer 0..2 Disabled
sb r0,REG_T1OUT(a0)
sb r0,REG_T2OUT(a0)
and s6,r0 // S6 = Timer 0 Cycles Reset
and s7,r0 // S7 = Timer 1 Cycles Reset
and s8,r0 // S8 = Timer 2 Cycles Reset
j TIMER_END
nop // Delay Slot

T0_8KHz:
  andi t1,t0,1 // IF (REG_CONTROL & 1) Timer 0 Clock Frequency = 8KHz
  bnez t1,T0_8KHzTime
  nop // Delay Slot
  sb r0,REG_T0OUT(a0) // REG_T0OUT = 0
  j T1_8KHz
  and s6,r0 // S6 = Timer 0 Cycles Reset (Delay Slot)
T0_8KHzTime:
  addu s6,k1 // Timer0Cycles += InstCycles
  la a2,T8KHzDIVCycleTable // A2 = Timer 8KHz DIV Cycle Table
  lbu t1,REG_T0DIV(a0) // T1 = Timer 0 Divider
  sll t1,1 // T1 = Table Position (*2)
  addu a2,t1 // A2 = Table + Table Position
  lhu t1,0(a2) // T1 = Timer0DIVCycleCount
  blt s6,t1,T1_8KHz // IF (Timer0Cycles < Timer0DIVCycleCount) Skip
  nop // Delay Slot
  subu s6,t1 // Timer0Cycles -= Timer0DIVCycleCount
  lbu t1,REG_T0OUT(a0) // ELSE REG_T0OUT++
  addiu t1,1
  andi t1,$F // REG_T0OUT &= $F
  sb t1,REG_T0OUT(a0)

T1_8KHz:
  andi t1,t0,2 // IF (REG_CONTROL & 2) Timer 1 Clock Frequency = 8KHz
  bnez t1,T1_8KHzTime
  nop // Delay Slot
  sb r0,REG_T1OUT(a0) // REG_T1OUT = 0
  j T2_64KHz
  and s7,r0 // S7 = Timer 0 Cycles Reset (Delay Slot)
T1_8KHzTime:
  addu s7,k1 // Timer1Cycles += InstCycles
  la a2,T8KHzDIVCycleTable // A2 = Timer 8KHz DIV Cycle Table
  lbu t1,REG_T1DIV(a0) // T1 = Timer 1 Divider
  sll t1,1 // T1 = Table Position (*2)
  addu a2,t1 // A2 = Table + Table Position
  lhu t1,0(a2) // T1 = Timer1DIVCycleCount
  blt s7,t1,T2_64KHz // IF (Timer1Cycles < Timer1DIVCycleCount) Skip
  nop // Delay Slot
  subu s7,t1 // Timer1Cycles -= Timer1DIVCycleCount
  lbu t1,REG_T1OUT(a0) // ELSE REG_T1OUT++
  addiu t1,1
  andi t1,$F // REG_T1OUT &= $F
  sb t1,REG_T1OUT(a0)

T2_64KHz:
  andi t1,t0,4 // IF (REG_CONTROL & 4) Timer 2 Clock Frequency = 64KHz
  bnez t1,T2_64KHzTime
  nop // Delay Slot
  sb r0,REG_T2OUT(a0) // REG_T2OUT = 0
  j TIMER_END
  and s8,r0 // S8 = Timer 2 Cycles Reset (Delay Slot)
T2_64KHzTime:
  addu s8,k1 // Timer2Cycles += InstCycles
  la a2,T64KHzDIVCycleTable // A2 = Timer 64KHz DIV Cycle Table
  lbu t1,REG_T2DIV(a0) // T1 = Timer 2 Divider
  sll t1,1 // T1 = Table Position (*2)
  addu a2,t1 // A2 = Table + Table Position
  lhu t1,0(a2) // T1 = Timer2DIVCycleCount
  blt s8,t1,TIMER_END // IF (Timer1Cycles < Timer1DIVCycleCount) Skip
  nop // Delay Slot
  subu s8,t1 // Timer2Cycles -= Timer2DIVCycleCount
  lbu t1,REG_T2OUT(a0) // ELSE REG_T2OUT++
  addiu t1,1
  andi t1,$F // REG_T2OUT &= $F
  sb t1,REG_T2OUT(a0)

  j TIMER_END
  nop // Delay Slot

T8KHzDIVCycleTable: // 1024KHz / (8KHz / REG_T01DIV(IF = 0 / 256)) = Cycles to Increment REG_T0OUT & REG_T1OUT
  dh 32768,   128,   256,   384,   512,   640,   768,   896,  1024,  1152,  1280,  1408,  1536,  1664,  1792,  1919
  dh  2048,  2176,  2304,  2432,  2560,  2688,  2816,  2944,  3072,  3200,  3328,  3456,  3584,  3711,  3839,  3968
  dh  4096,  4224,  4352,  4480,  4608,  4736,  4864,  4992,  5120,  5248,  5376,  5504,  5632,  5760,  5888,  6016
  dh  6144,  6272,  6400,  6527,  6656,  6784,  6912,  7039,  7168,  7295,  7423,  7551,  7679,  7808,  7936,  8064
  dh  8192,  8320,  8448,  8576,  8704,  8832,  8960,  9088,  9216,  9344,  9472,  9600,  9728,  9856,  9984, 10112
  dh 10240, 10368, 10496, 10624, 10752, 10880, 11008, 11136, 11264, 11392, 11520, 11648, 11776, 11904, 12032, 12160
  dh 12288, 12416, 12544, 12672, 12800, 12928, 13055, 13184, 13312, 13440, 13568, 13696, 13824, 13952, 14079, 14208
  dh 14336, 14464, 14591, 14720, 14847, 14976, 15103, 15232, 15359, 15488, 15616, 15743, 15872, 16000, 16128, 16256
  dh 16384, 16512, 16640, 16768, 16896, 17024, 17152, 17280, 17408, 17536, 17664, 17792, 17920, 18048, 18176, 18304
  dh 18432, 18560, 18688, 18816, 18944, 19072, 19200, 19328, 19456, 19584, 19712, 19840, 19968, 20096, 20224, 20352
  dh 20480, 20608, 20736, 20864, 20992, 21120, 21248, 21376, 21504, 21632, 21760, 21888, 22016, 22144, 22272, 22400
  dh 22528, 22656, 22784, 22912, 23040, 23168, 23296, 23424, 23552, 23680, 23808, 23936, 24064, 24192, 24320, 24448
  dh 24576, 24704, 24832, 24959, 25088, 25216, 25344, 25471, 25600, 25728, 25856, 25984, 26111, 26240, 26368, 26496
  dh 26624, 26752, 26880, 27008, 27136, 27264, 27392, 27520, 27648, 27776, 27904, 28032, 28159, 28288, 28416, 28544
  dh 28672, 28800, 28928, 29056, 29183, 29311, 29440, 29568, 29695, 29824, 29952, 30080, 30207, 30336, 30464, 30592
  dh 30719, 30847, 30976, 31104, 31232, 31360, 31487, 31616, 31744, 31872, 32000, 32128, 32256, 32384, 32512, 32640

T64KHzDIVCycleTable: // 1024KHz / (64KHz / REG_T2DIV(IF = 0 / 256)) = Cycles to Increment REG_T2OUT
  dh 4096,   16,   32,   48,   64,   80,   96,  112,  128,  144,  160,  176,  192,  208,  224,  239
  dh  256,  272,  288,  304,  320,  336,  352,  368,  384,  400,  416,  432,  448,  463,  479,  496
  dh  512,  528,  544,  560,  576,  592,  608,  624,  640,  656,  672,  688,  704,  720,  736,  752
  dh  768,  784,  800,  815,  832,  848,  864,  879,  896,  911,  927,  943,  959,  976,  992, 1008
  dh 1024, 1040, 1056, 1072, 1088, 1104, 1120, 1136, 1152, 1168, 1184, 1200, 1216, 1232, 1248, 1264
  dh 1280, 1296, 1312, 1328, 1344, 1360, 1376, 1392, 1408, 1424, 1440, 1456, 1472, 1488, 1504, 1520
  dh 1536, 1552, 1568, 1584, 1600, 1616, 1631, 1648, 1664, 1680, 1696, 1712, 1728, 1744, 1759, 1776
  dh 1792, 1808, 1823, 1840, 1855, 1872, 1887, 1904, 1919, 1936, 1952, 1967, 1984, 2000, 2016, 2032
  dh 2048, 2064, 2080, 2096, 2112, 2128, 2144, 2160, 2176, 2192, 2208, 2224, 2240, 2256, 2272, 2288
  dh 2304, 2320, 2336, 2352, 2368, 2384, 2400, 2416, 2432, 2448, 2464, 2480, 2496, 2512, 2528, 2544
  dh 2560, 2576, 2592, 2608, 2624, 2640, 2656, 2672, 2688, 2704, 2720, 2736, 2752, 2768, 2784, 2800
  dh 2816, 2832, 2848, 2864, 2880, 2896, 2912, 2928, 2944, 2960, 2976, 2992, 3008, 3024, 3040, 3056
  dh 3072, 3088, 3104, 3119, 3136, 3152, 3168, 3183, 3200, 3216, 3232, 3248, 3263, 3280, 3296, 3312
  dh 3328, 3344, 3360, 3376, 3392, 3408, 3424, 3440, 3456, 3472, 3488, 3504, 3519, 3536, 3552, 3568
  dh 3584, 3600, 3616, 3632, 3647, 3663, 3680, 3696, 3711, 3728, 3744, 3760, 3775, 3792, 3808, 3824
  dh 3839, 3855, 3872, 3888, 3904, 3920, 3935, 3952, 3968, 3984, 4000, 4016, 4032, 4048, 4064, 4080

TIMER_END: