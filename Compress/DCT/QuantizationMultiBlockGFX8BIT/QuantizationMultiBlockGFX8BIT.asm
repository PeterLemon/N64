// N64 'Bare Metal' Quantization Multi Block GFX 8-Bit Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "QuantizationMultiBlockGFX8BIT.N64", create
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


  la s0,DCTQBLOCKS // S0 = DCTQ Blocks
  lui s1,$A010 // S1 = VRAM
  lli s2,40 // S2 = Block Row Count
  lli s3,29 // S3 = Block Column Count - 1

  LoopBlocks:

  la a0,Q // A0 = Q
  la a1,DCT // A2 = DCT

  lli t0,63 // T0 = 63

  // DCT Block Decode (Inverse Quantization)
  QLoop:
    lbu t1,0(a0) // T1 = Q
    addiu a0,1 // Q++
    lb t2,0(s0) // T2 = DCTQ
    addiu s0,1 // DCTQ++
    mult t1,t2 // T1 = DCTQ * Q
    mflo t1
    sh t1,0(a1) // DCT = T1
    addiu a1,2 // DCT += 2
    bnez t0,QLoop // IF (T0 != 0) Q Loop
    subiu t0,1 // T0--


  la a0,IDCT // A0 = IDCT
  la a2,CLUT // A2 = CLUT
  la a3,COSLUT // A3 = COSLUT

  lli t7,7 // T7 = 7

  // IDCT Block Decode
  and t0,r0 // T0 = Y
  IDCTY: // While (Y < 8)
    and t1,r0 // T1 = X
    IDCTX: // While (X < 8)
      and t2,r0 // T2 = V
      and t6,r0 // T6 = IDCT
      la a1,DCT // A1 = DCT
      IDCTV: // While (V < 8)
	and t3,r0 // T3 = U
	IDCTU: // While (U < 8)
          // IDCT[Y*8 + X] += DCT[V*8 + U]
	  lh t4,0(a1) // T4 = DCT[V*8 + U]
          addiu a1,2 // DCT += 2
          // * C[U]
	  sll t5,t3,1 // T5 = U Offset
          addu t5,a2 // T5 = C[U] Offset
	  lhu t5,0(t5) // T5 = C[U]
	  multu t4,t5 // T4 *= C[U]
          mflo t4
	  sra t4,16 // Shift S.16
          // * C[V]
	  sll t5,t2,1 // T5 = V Offset
          addu t5,a2 // T5 = C[V] Offset
	  lhu t5,0(t5) // T5 = C[V]
	  multu t4,t5 // T4 *= C[V]
          mflo t4
	  sra t4,16 // Shift S.16
          // * COS[U*8 + X]
          sll t5,t3,3 // T5 = U*8
          addu t5,t1 // T5 = U*8 + X
	  sll t5,2 // T5 = U*8 + X Offset
          addu t5,a3 // T5 = COS[U*8 + X] Offset
	  lw t5,0(t5) // T5 = COS[U*8 + X]
	  mult t4,t5 // T4 *= COS[U*8 + X]
          mflo t4
	  sra t4,16 // Shift S.16
          // * COS[V*8 + Y]
          sll t5,t2,3 // T5 = V*8
          addu t5,t0 // T5 = V*8 + Y
	  sll t5,2 // T5 = V*8 + Y Offset
          addu t5,a3 // T5 = COS[V*8 + Y] Offset
	  lw t5,0(t5) // T5 = COS[V*8 + Y]
	  mult t4,t5 // T4 *= COS[V*8 + Y]
          mflo t4
	  sra t4,16 // Shift S.16

          add t6,t4 // IDCT += T4

	  blt t3,t7,IDCTU // IF (U < 7) IDCTU
          addiu t3,1 // U++ (Delay Slot)

	blt t2,t7,IDCTV // IF (V < 7) IDCTV
        addiu t2,1 // V++ (Delay Slot)

      sh t6,0(a0) // IDCT[Y*8 + X] = IDCT
      addiu a0,2 // IDCT += 2

      blt t1,t7,IDCTX // IF (X < 7) IDCTX
      addiu t1,1 // X++ (Delay Slot)

    blt t0,t7,IDCTY // IF (Y < 7) IDCTY
    addiu t0,1 // Y++ (Delay Slot)

  // Copy IDCT Block To VRAM
  la a0,IDCT // A0 = IDCT
  lli t0,7 // T0 = Y
  lli t4,255 // T4 = 255
  LoopY: // While Y
    lli t1,7 // T1 = X
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
      sw t2,0(s1) // Store Pixel To VRAM
      addiu s1,4 // VRAM += 4

      bnez t1,LoopX // IF (X != 0) Loop X
      subiu t1,1 // X-- (Delay Slot)
      addiu s1,1248 // Jump 1 Scanline Down, 8 Pixels Back

    bnez t0,LoopY // IF (Y != 0) Loop Y
    subiu t0,1 // Y-- (Delay Slot)

  subiu s2,1 // Block Row Count--
  bnez s2,LoopBlocks // IF (Block Row Count != 0) LoopBlocks
  subiu s1,(320*8*4)-8*4 // Jump 8 Scanlines Up, 8 Pixels Forwards (Delay Slot)

  addiu s1,(320*7*4) // Jump 7 Scanlines Down
  lli s2,40 // Block Row Count = 40

  bnez s3,LoopBlocks // IF (Block Column Count != 0) LoopBlocks
  subiu s3,1 // Block Column Count-- (Delay Slot)

Loop:
  j Loop
  nop // Delay Slot

CLUT: // C Look Up Table (/2 Applied) (.16)
  dh 23170,32768,32768,32768,32768,32768,32768,32768

COSLUT: // COS Look Up Table (S.16)
  dw 65536,65536,65536,65536,65536,65536,65536,65536
  dw 64277,54491,36410,12785,-12785,-36410,-54491,-64277
  dw 60547,25080,-25080,-60547,-60547,-25080,25080,60547
  dw 54491,-12785,-64277,-36410,36410,64277,12785,-54491
  dw 46341,-46341,-46341,46341,46341,-46341,-46341,46341
  dw 36410,-64277,12785,54491,-54491,-12785,64277,-36410
  dw 25080,-60547,60547,-25080,-25080,60547,-60547,25080
  dw 12785,-36410,54491,-64277,64277,-54491,36410,-12785

//Q: // JPEG Standard Quantization 8x8 Result Matrix (Quality = 10)
//  db 80,55,50,80,120,200,255,255
//  db 60,60,70,95,130,255,255,255
//  db 70,65,80,120,200,255,255,255
//  db 70,85,110,145,255,255,255,255
//  db 90,110,185,255,255,255,255,255
//  db 120,175,255,255,255,255,255,255
//  db 245,255,255,255,255,255,255,255
//  db 255,255,255,255,255,255,255,255

Q: // JPEG Standard Quantization 8x8 Result Matrix (Quality = 50)
  db 16,11,10,16,24,40,51,61
  db 12,12,14,19,26,58,60,55
  db 14,13,16,24,40,57,69,56
  db 14,17,22,29,51,87,80,62
  db 18,22,37,56,68,109,103,77
  db 24,35,55,64,81,104,113,92
  db 49,64,78,87,103,121,120,101
  db 72,92,95,98,112,100,103,99

//Q: // JPEG Standard Quantization 8x8 Result Matrix (Quality = 90)
//  db 3,2,2,3,5,8,10,12
//  db 2,2,3,4,5,12,12,11
//  db 3,3,3,5,8,11,14,11
//  db 3,3,4,6,10,17,16,12
//  db 4,4,7,11,14,22,21,15
//  db 5,7,11,13,16,21,23,18
//  db 10,13,16,17,21,24,24,20
//  db 14,18,19,20,22,20,21,20

DCT: // Discrete Cosine Transform (DCT) 8x8 Result Matrix
  dh 0,0,0,0,0,0,0,0
  dh 0,0,0,0,0,0,0,0
  dh 0,0,0,0,0,0,0,0
  dh 0,0,0,0,0,0,0,0
  dh 0,0,0,0,0,0,0,0
  dh 0,0,0,0,0,0,0,0
  dh 0,0,0,0,0,0,0,0
  dh 0,0,0,0,0,0,0,0

IDCT: // Inverse Discrete Cosine Transform (IDCT) 8x8 Result Matrix
  dh 0,0,0,0,0,0,0,0
  dh 0,0,0,0,0,0,0,0
  dh 0,0,0,0,0,0,0,0
  dh 0,0,0,0,0,0,0,0
  dh 0,0,0,0,0,0,0,0
  dh 0,0,0,0,0,0,0,0
  dh 0,0,0,0,0,0,0,0
  dh 0,0,0,0,0,0,0,0

DCTQBLOCKS: // DCT Quantization 8x8 Matrix Blocks (Signed 8-Bit)
  //insert "frame10.dct" // Frame Quality = 10
  insert "frame50.dct" // Frame Quality = 50
  //insert "frame90.dct" // Frame Quality = 90