// N64 'Bare Metal' Fast Quantization Multi Block GFX 16-Bit Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "FastQuantizationMultiBlockGFX16BIT.N64", create
fill 1052672 // Set ROM Size

origin $00000000
base $80000000 // Entry Point Of Code
include "LIB/N64.INC" // Include N64 Definitions
include "LIB/N64_HEADER.ASM" // Include 64 Byte Header & Vector Table
insert "LIB/N64_BOOTCODE.BIN" // Include 4032 Byte Boot Code

Start:
  include "LIB/N64_GFX.INC" // Include Graphics Macros
  N64_INIT() // Run N64 Initialisation Routine

  ScreenNTSC(320, 240, BPP32, $A0100000) // Screen NTSC: 320x240, 32BPP, DRAM Origin $A0100000

  la a0,Q // A0 = Q
  la a1,DCTQBLOCKS // A1 = DCTQ Blocks
  la a2,DCT // A2 = DCT/IDCT

  ori t0,r0,(320/8)*(240/8) // T0 = Block Count
  QBlockLoop:
    ori t1,r0,63 // T1 = 63

    // DCT Block Decode (Inverse Quantization)
    QLoop:
      lbu t2,0(a0) // T2 = Q
      addiu a0,1 // Q++
      lh t3,0(a1) // T3 = DCTQ
      addiu a1,2 // DCTQ += 2
      mult t2,t3 // T2 = DCTQ * Q
      mflo t2
      sh t2,0(a2) // DCT = T2
      addiu a2,2 // DCT += 2
      bnez t1,QLoop // IF (T1 != 0) Q Loop
      subiu t1,1 // T1-- (Delay Slot)

    subiu a0,64 // Q -= 64
    bnez t0,QBlockLoop // IF (T0 != 0) Q Block Loop
    subiu t0,1 // T0-- (Delay Slot)


  la a0,DCT // A0 = DCT/IDCT

  LoopIDCT:

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

  la t0,DCT+((320*240)*2)-128 // T0 = DCT/IDCT End Offset
  bne a0,t0,LoopIDCT // IF (DCT/IDCT != WRAM End Offset) Loop IDCT
  addiu a0,128 // DCT/IDCT += 128 (Delay Slot)


  ori s2,r0,40 // S2 = Block Row Count
  ori s3,r0,29 // S3 = Block Column Count - 1
  la a0,DCT // A0 = IDCT
  lui a1,$A010 // A1 = VRAM

  LoopBlocks:

  // Copy IDCT Block To VRAM
  ori t0,r0,7 // T0 = Y
  ori t4,r0,255 // T4 = 255
  LoopY: // While Y
    ori t1,r0,7 // T1 = X
    LoopX: // While X
      lh t2,0(a0) // T2 = IDCT Block Pixel
      addiu a0,2 // IDCT += 2
      bgtz t2,Floor // Compare Pixel To 0
      nop // (Delay Slot)
      and t2,r0 // IF (Pixel < 0) Pixel = 0
      Floor:
      blt t2,t4,Ceiling // Compare Pixel To 255
      nop // (Delay Slot)
      or t2,t4,r0 // IF (Pixel > 255) Pixel = 255
      Ceiling:
      sll t3,t2,8
      or t2,t3
      sll t3,8
      or t2,t3
      sll t2,8
      or t2,t4 // T2 = 32-BIT RGB Pixel
      sw t2,0(a1) // Store Pixel To VRAM
      addiu a1,4 // VRAM += 4

      bnez t1,LoopX // IF (X != 0) Loop X
      subiu t1,1 // X-- (Delay Slot)
      addiu a1,1248 // Jump 1 Scanline Down, 8 Pixels Back

    bnez t0,LoopY // IF (Y != 0) Loop Y
    subiu t0,1 // Y-- (Delay Slot)

  subiu s2,1 // Block Row Count--
  bnez s2,LoopBlocks // IF (Block Row Count != 0) LoopBlocks
  subiu a1,(320*8*4)-8*4 // Jump 8 Scanlines Up, 8 Pixels Forwards (Delay Slot)

  addiu a1,(320*7*4) // Jump 7 Scanlines Down
  ori s2,r0,40 // Block Row Count = 40

  bnez s3,LoopBlocks // IF (Block Column Count != 0) LoopBlocks
  subiu s3,1 // Block Column Count-- (Delay Slot)

Loop:
  j Loop
  nop // Delay Slot

//Q: // JPEG Standard Quantization 8x8 Result Matrix (Quality = 10)
//  db 80,55,50,80,120,200,255,255
//  db 60,60,70,95,130,255,255,255
//  db 70,65,80,120,200,255,255,255
//  db 70,85,110,145,255,255,255,255
//  db 90,110,185,255,255,255,255,255
//  db 120,175,255,255,255,255,255,255
//  db 245,255,255,255,255,255,255,255
//  db 255,255,255,255,255,255,255,255

//Q: // JPEG Standard Quantization 8x8 Result Matrix (Quality = 50)
//  db 16,11,10,16,24,40,51,61
//  db 12,12,14,19,26,58,60,55
//  db 14,13,16,24,40,57,69,56
//  db 14,17,22,29,51,87,80,62
//  db 18,22,37,56,68,109,103,77
//  db 24,35,55,64,81,104,113,92
//  db 49,64,78,87,103,121,120,101
//  db 72,92,95,98,112,100,103,99

Q: // JPEG Standard Quantization 8x8 Result Matrix (Quality = 90)
  db 3,2,2,3,5,8,10,12
  db 2,2,3,4,5,12,12,11
  db 3,3,3,5,8,11,14,11
  db 3,3,4,6,10,17,16,12
  db 4,4,7,11,14,22,21,15
  db 5,7,11,13,16,21,23,18
  db 10,13,16,17,21,24,24,20
  db 14,18,19,20,22,20,21,20

DCTQBLOCKS: // DCT Quantization 8x8 Matrix Blocks (Signed 16-Bit)
  //insert "frame10.dct" // Frame Quality = 10
  //insert "frame50.dct" // Frame Quality = 50
  insert "frame90.dct" // Frame Quality = 90

DCT: // Discrete Cosine Transform (DCT) 8x8 Result Matrix
  fill (320*240)*2