// N64 'Bare Metal' Fast DCT Block Decode Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "FastDCTBlockDecode.N64", create
fill 1052672 // Set ROM Size

origin $00000000
base $80000000 // Entry Point Of Code
include "LIB/N64.INC" // Include N64 Definitions
include "LIB/N64_HEADER.ASM" // Include 64 Byte Header & Vector Table
insert "LIB/N64_BOOTCODE.BIN" // Include 4032 Byte Boot Code

Start:
  N64_INIT() // Run N64 Initialisation Routine

  la a0,DCT // A0 = DCT/IDCT

  // Fast IDCT Block Decode
  // Pass 1: Process Columns From Input, Store Into Work Array.
  define CTR(0)
  while {CTR} < 8 { // Static Loop Columns

  // Even part: Reverse The Even Part Of The Forward DCT. The Rotator Is SQRT(2)*C(-6).
  lh t0,2*{CTR}+8*2*2(a0) // T0 = Z2 = DCT[CTR + 8*2]
  lh t1,2*{CTR}+8*6*2(a0) // T1 = Z3 = DCT[CTR + 8*6]

  add t2,t0,t1 // Z1 = (Z2 + Z3) * 0.541196100
  addi t3,r0,4433 // T3 = 0.541196100
  mult t2,t3
  mflo t2 // T2 = Z1
  addi t3,r0,-15137 // TMP2 = Z1 + (Z3 * -1.847759065)
  mult t1,t3
  mflo t1
  add t1,t2 // T1 = TMP2
  addi t3,r0,6270 // TMP3 = Z1 + (Z2 * 0.765366865)
  mult t0,t3
  mflo t0
  add t0,t2 // T0 = TMP3

  lh t4,2*{CTR}+8*0*2(a0) // T4 = Z2 = DCT[CTR + 8*0]
  lh t5,2*{CTR}+8*4*2(a0) // T5 = Z3 = DCT[CTR + 8*4]

  add t2,t4,t5 // TMP0 = (Z2 + Z3) << 13
  sll t2,13 // T2 = TMP0
  sub t3,t4,t5 // TMP1 = (Z2 - Z3) << 13
  sll t3,13 // T3 = TMP1

  add t4,t2,t0 // T4 = TMP10 = TMP0 + TMP3
  add t5,t3,t1 // T5 = TMP11 = TMP1 + TMP2
  sub t6,t3,t1 // T6 = TMP12 = TMP1 - TMP2
  sub t7,t2,t0 // T7 = TMP13 = TMP0 - TMP3

  // Odd Part Per Figure 8; The Matrix Is Unitary And Hence Its Transpose Is Its Inverse.
  lh t0,2*{CTR}+8*7*2(a0) // T0 = TMP0 = DCT[CTR + 8*7]
  lh t1,2*{CTR}+8*5*2(a0) // T1 = TMP1 = DCT[CTR + 8*5]
  lh t2,2*{CTR}+8*3*2(a0) // T2 = TMP2 = DCT[CTR + 8*3]
  lh t3,2*{CTR}+8*1*2(a0) // T3 = TMP3 = DCT[CTR + 8*1]

  add s2,t0,t2 // S2 = Z3 = TMP0 + TMP2
  add s3,t1,t3 // S3 = Z4 = TMP1 + TMP3
  add s4,s2,s3 // Z5 = (Z3 + Z4) * 1.175875602 # SQRT(2) * C3
  addi s0,r0,9633 // S0 = 1.175875602
  mult s4,s0
  mflo s4 // S4 = Z5

  addi s0,r0,-16069 // Z3 *= -1.961570560 # SQRT(2) * (-C3-C5)
  mult s2,s0
  mflo s2 // S2 = Z3
  addi s0,r0,-3196 // Z4 *= -0.390180644 # SQRT(2) * ( C5-C3)
  mult s3,s0
  mflo s3 // S3 = Z4
  add s2,s4 // S2 = Z3 += Z5
  add s3,s4 // S3 = Z4 += Z5

  add s0,t0,t3 // S0 = Z1 = TMP0 + TMP3
  add s1,t1,t2 // S1 = Z2 = TMP1 + TMP2
  addi s4,r0,-7373 // Z1 *= -0.899976223 # SQRT(2) * ( C7-C3)
  mult s0,s4
  mflo s0 // S0 = Z1
  addi s4,r0,-20995 // Z2 *= -2.562915447 # SQRT(2) * (-C1-C3)
  mult s1,s4
  mflo s1 // S1 = Z2

  addi s4,r0,2446 // TMP0 *= 0.298631336 # SQRT(2) * (-C1+C3+C5-C7)
  mult t0,s4
  mflo t0 // T0 = TMP0
  addi s4,r0,16819 // TMP1 *= 2.053119869 # SQRT(2) * ( C1+C3-C5+C7)
  mult t1,s4
  mflo t1 // T1 = TMP1
  addi s4,r0,25172 // TMP2 *= 3.072711026 # SQRT(2) * ( C1+C3+C5-C7)
  mult t2,s4
  mflo t2 // T2 = TMP2
  addi s4,r0,12299 // TMP3 *= 1.501321110 # SQRT(2) * ( C1+C3-C5-C7)
  mult t3,s4
  mflo t3 // T3 = TMP3

  add t0,s0 // TMP0 += Z1 + Z3
  add t0,s2 // T0 = TMP0
  add t1,s1 // TMP1 += Z2 + Z4
  add t1,s3 // T1 = TMP1
  add t2,s1 // TMP2 += Z2 + Z3
  add t2,s2 // T2 = TMP2
  add t3,s0 // TMP3 += Z1 + Z4
  add t3,s3 // R3 = TMP3

  // Final Output Stage: Inputs Are TMP10..TMP13, TMP0..TMP3
  add s0,t4,t3 // DCT[CTR + 8*0] = (TMP10 + TMP3) >> 11
  sra s0,11
  sh s0,2*{CTR}+8*0*2(a0)
  sub s0,t4,t3 // DCT[CTR + 8*7] = (TMP10 - TMP3) >> 11
  sra s0,11
  sh s0,2*{CTR}+8*7*2(a0)
  add s0,t5,t2 // DCT[CTR + 8*1] = (TMP11 + TMP2) >> 11
  sra s0,11
  sh s0,2*{CTR}+8*1*2(a0)
  sub s0,t5,t2 // DCT[CTR + 8*6] = (TMP11 - TMP2) >> 11
  sra s0,11
  sh s0,2*{CTR}+8*6*2(a0)
  add s0,t6,t1 // DCT[CTR + 8*2] = (TMP12 + TMP1) >> 11
  sra s0,11
  sh s0,2*{CTR}+8*2*2(a0)
  sub s0,t6,t1 // DCT[CTR + 8*5] = (TMP12 - TMP1) >> 11
  sra s0,11
  sh s0,2*{CTR}+8*5*2(a0)
  add s0,t7,t0 // DCT[CTR + 8*3] = (TMP13 + TMP0) >> 11
  sra s0,11
  sh s0,2*{CTR}+8*3*2(a0)
  sub s0,t7,t0 // DCT[CTR + 8*4] = (TMP13 - TMP0) >> 11
  sra s0,11
  sh s0,2*{CTR}+8*4*2(a0)

  evaluate CTR({CTR} + 1)
  } // End Of Static Loop Columns

  // Pass 2: Process Rows From Work Array, Store Into Output Array.
  define CTR(0)
  while {CTR} < 8 { // Static Loop Rows

  // Even part: Reverse The Even Part Of The Forward DCT. The Rotator Is SQRT(2)*C(-6).
  lh t0,2*{CTR}*8+2*2(a0) // T0 = Z2 = DCT[CTR*8 + 2]
  lh t1,2*{CTR}*8+6*2(a0) // T1 = Z3 = DCT[CTR*8 + 6]

  add t2,t0,t1 // Z1 = (Z2 + Z3) * 0.541196100
  addi t3,r0,4433 // T3 = 0.541196100
  mult t2,t3
  mflo t2 // T2 = Z1
  addi t3,r0,-15137 // TMP2 = Z1 + (Z3 * -1.847759065)
  mult t1,t3
  mflo t1
  add t1,t2 // T1 = TMP2
  addi t3,r0,6270 // TMP3 = Z1 + (Z2 * 0.765366865)
  mult t0,t3
  mflo t0
  add t0,t2 // T0 = TMP3

  lh t4,2*{CTR}*8+0*2(a0) // T4 = Z2 = DCT[CTR*8 + 0]
  lh t5,2*{CTR}*8+4*2(a0) // T5 = Z3 = DCT[CTR*8 + 4]

  add t2,t4,t5 // TMP0 = (Z2 + Z3) << 13
  sll t2,13 // T2 = TMP0
  sub t3,t4,t5 // TMP1 = (Z2 - Z3) << 13
  sll t3,13 // T3 = TMP1

  add t4,t2,t0 // T4 = TMP10 = TMP0 + TMP3
  add t5,t3,t1 // T5 = TMP11 = TMP1 + TMP2
  sub t6,t3,t1 // T6 = TMP12 = TMP1 - TMP2
  sub t7,t2,t0 // T7 = TMP13 = TMP0 - TMP3

  // Odd Part Per Figure 8; The Matrix Is Unitary And Hence Its Transpose Is Its Inverse.
  lh t0,2*{CTR}*8+7*2(a0) // T0 = TMP0 = DCT[CTR*8 + 7]
  lh t1,2*{CTR}*8+5*2(a0) // T1 = TMP1 = DCT[CTR*8 + 5]
  lh t2,2*{CTR}*8+3*2(a0) // T2 = TMP2 = DCT[CTR*8 + 3]
  lh t3,2*{CTR}*8+1*2(a0) // T3 = TMP3 = DCT[CTR*8 + 1]

  add s2,t0,t2 // S2 = Z3 = TMP0 + TMP2
  add s3,t1,t3 // S3 = Z4 = TMP1 + TMP3
  add s4,s2,s3 // Z5 = (Z3 + Z4) * 1.175875602 # SQRT(2) * C3
  addi s0,r0,9633 // S0 = 1.175875602
  mult s4,s0
  mflo s4 // S4 = Z5

  addi s0,r0,-16069 // Z3 *= -1.961570560 # SQRT(2) * (-C3-C5)
  mult s2,s0
  mflo s2 // S2 = Z3
  addi s0,r0,-3196 // Z4 *= -0.390180644 # SQRT(2) * ( C5-C3)
  mult s3,s0
  mflo s3 // S3 = Z4
  add s2,s4 // S2 = Z3 += Z5
  add s3,s4 // S3 = Z4 += Z5

  add s0,t0,t3 // S0 = Z1 = TMP0 + TMP3
  add s1,t1,t2 // S1 = Z2 = TMP1 + TMP2
  addi s4,r0,-7373 // Z1 *= -0.899976223 # SQRT(2) * ( C7-C3)
  mult s0,s4
  mflo s0 // S0 = Z1
  addi s4,r0,-20995 // Z2 *= -2.562915447 # SQRT(2) * (-C1-C3)
  mult s1,s4
  mflo s1 // S1 = Z2

  addi s4,r0,2446 // TMP0 *= 0.298631336 # SQRT(2) * (-C1+C3+C5-C7)
  mult t0,s4
  mflo t0 // T0 = TMP0
  addi s4,r0,16819 // TMP1 *= 2.053119869 # SQRT(2) * ( C1+C3-C5+C7)
  mult t1,s4
  mflo t1 // T1 = TMP1
  addi s4,r0,25172 // TMP2 *= 3.072711026 # SQRT(2) * ( C1+C3+C5-C7)
  mult t2,s4
  mflo t2 // T2 = TMP2
  addi s4,r0,12299 // TMP3 *= 1.501321110 # SQRT(2) * ( C1+C3-C5-C7)
  mult t3,s4
  mflo t3 // T3 = TMP3

  add t0,s0 // TMP0 += Z1 + Z3
  add t0,s2 // T0 = TMP0
  add t1,s1 // TMP1 += Z2 + Z4
  add t1,s3 // T1 = TMP1
  add t2,s1 // TMP2 += Z2 + Z3
  add t2,s2 // T2 = TMP2
  add t3,s0 // TMP3 += Z1 + Z4
  add t3,s3 // R3 = TMP3

  // Final Output Stage: Inputs Are TMP10..TMP13, TMP0..TMP3
  add s0,t4,t3 // DCT[CTR*8 + 0] = (TMP10 + TMP3) >> 18
  sra s0,18
  sh s0,2*{CTR}*8+0*2(a0)
  sub s0,t4,t3 // DCT[CTR*8 + 7] = (TMP10 - TMP3) >> 18
  sra s0,18
  sh s0,2*{CTR}*8+7*2(a0)
  add s0,t5,t2 // DCT[CTR*8 + 1] = (TMP11 + TMP2) >> 18
  sra s0,18
  sh s0,2*{CTR}*8+1*2(a0)
  sub s0,t5,t2 // DCT[CTR*8 + 6] = (TMP11 - TMP2) >> 18
  sra s0,18
  sh s0,2*{CTR}*8+6*2(a0)
  add s0,t6,t1 // DCT[CTR*8 + 2] = (TMP12 + TMP1) >> 18
  sra s0,18
  sh s0,2*{CTR}*8+2*2(a0)
  sub s0,t6,t1 // DCT[CTR*8 + 5] = (TMP12 - TMP1) >> 18
  sra s0,18
  sh s0,2*{CTR}*8+5*2(a0)
  add s0,t7,t0 // DCT[CTR*8 + 3] = (TMP13 + TMP0) >> 18
  sra s0,18
  sh s0,2*{CTR}*8+3*2(a0)
  sub s0,t7,t0 // DCT[CTR*8 + 4] = (TMP13 - TMP0) >> 18
  sra s0,18
  sh s0,2*{CTR}*8+4*2(a0)

  evaluate CTR({CTR} + 1)
  } // End Of Static Loop Rows

Loop:
  j Loop
  nop // Delay Slot

DCT: // Discrete Cosine Transform (DCT) 8x8 Result Matrix
  //dh 700,0,0,0,0,0,0,0 // We Apply The IDCT To A Matrix, Only Containing A DC Value Of 700.
  //dh 0,0,0,0,0,0,0,0   // It Will Produce A Grey Colored Square.
  //dh 0,0,0,0,0,0,0,0
  //dh 0,0,0,0,0,0,0,0
  //dh 0,0,0,0,0,0,0,0
  //dh 0,0,0,0,0,0,0,0
  //dh 0,0,0,0,0,0,0,0
  //dh 0,0,0,0,0,0,0,0

  //dh 700,100,0,0,0,0,0,0 // Now Let's Add An AC Value Of 100, At The 1st Position.
  //dh 0,0,0,0,0,0,0,0     // It Will Produce A Bar Diagram With A Curve Like A Half Cosine Line.
  //dh 0,0,0,0,0,0,0,0     // It Is Said It Has A Frequency Of 1 In X-Direction.
  //dh 0,0,0,0,0,0,0,0
  //dh 0,0,0,0,0,0,0,0
  //dh 0,0,0,0,0,0,0,0
  //dh 0,0,0,0,0,0,0,0
  //dh 0,0,0,0,0,0,0,0

  //dh 700,0,100,0,0,0,0,0 // What Happens If We Place The AC Value Of 100 At The Next Position?
  //dh 0,0,0,0,0,0,0,0     // The Shape Of The Bar Diagram Shows A Cosine Line, Too.
  //dh 0,0,0,0,0,0,0,0     // But Now We See A Full Period.
  //dh 0,0,0,0,0,0,0,0     // The Frequency Is Twice As High As In The Previous Example.
  //dh 0,0,0,0,0,0,0,0
  //dh 0,0,0,0,0,0,0,0
  //dh 0,0,0,0,0,0,0,0
  //dh 0,0,0,0,0,0,0,0

  //dh 700,100,100,0,0,0,0,0 // But What Happens If We Place Both AC Values?
  //dh 0,0,0,0,0,0,0,0       // The Shape Of The Bar Diagram Is A Mix Of Both The 1st & 2nd Cosines.
  //dh 0,0,0,0,0,0,0,0       // The Resulting AC Value Is Simply An Addition Of The Cosine Lines.
  //dh 0,0,0,0,0,0,0,0
  //dh 0,0,0,0,0,0,0,0
  //dh 0,0,0,0,0,0,0,0
  //dh 0,0,0,0,0,0,0,0
  //dh 0,0,0,0,0,0,0,0

  //dh 700,100,100,0,0,0,0,0 // Now Let's Add An AC Value At The Other Direction.
  //dh 200,0,0,0,0,0,0,0     // Now The Values Vary In Y Direction, Too. The Principle Is:
  //dh 0,0,0,0,0,0,0,0       // The Higher The Index Of The AC Value The Greater The Frequency Is.
  //dh 0,0,0,0,0,0,0,0
  //dh 0,0,0,0,0,0,0,0
  //dh 0,0,0,0,0,0,0,0
  //dh 0,0,0,0,0,0,0,0
  //dh 0,0,0,0,0,0,0,0

  dh 950,0,0,0,0,0,0,0 // Placing An AC Value At The Opposite Side Of The DC Value.
  dh 0,0,0,0,0,0,0,0   // The Highest Possible Frequency Of 8 Is Applied In Both X- & Y- Direction.
  dh 0,0,0,0,0,0,0,0   // Because Of The High Frequency The Neighbouring Values Differ Numerously.
  dh 0,0,0,0,0,0,0,0   // The Picture Shows A Checker-Like Appearance.
  dh 0,0,0,0,0,0,0,0
  dh 0,0,0,0,0,0,0,0
  dh 0,0,0,0,0,0,0,0
  dh 0,0,0,0,0,0,0,500