// N64 'Bare Metal' Quantization Block GFX Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "QuantizationBlockGFX.N64", create
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
  la a1,DCTQ // A1 = DCTQ
  la a2,DCT // A2 = DCT

  lli t0,63 // T0 = 63

  // DCT Block Decode (Inverse Quantization)
  QLoop:
    lbu t2,0(a0) // T2 = Q
    addiu a0,1 // Q++
    lb t1,0(a1) // T1 = DCTQ
    addiu a1,1 // DCTQ++
    mult t1,t2 // T1 = DCTQ * Q
    mflo t1
    sh t1,0(a2) // DCT = T1
    addiu a2,2 // DCT += 2
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
  lui a1,$A010 // A1 = VRAM
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
      sw t2,0(a1) // Store Pixel To VRAM
      addiu a1,4 // VRAM += 4

      bnez t1,LoopX // IF (X != 0) Loop X
      subiu t1,1 // X-- (Delay Slot)
      addiu a1,1248 // Jump 1 Scanline Down, 8 Pixels Back

    bnez t0,LoopY // IF (Y != 0) Loop Y
    subiu t0,1 // Y-- (Delay Slot)

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

Q: // JPEG Standard Quantization 8x8 Result Matrix (Quality = 50)
  db 16,11,10,16,24,40,51,61
  db 12,12,14,19,26,58,60,55
  db 14,13,16,24,40,57,69,56
  db 14,17,22,29,51,87,80,62
  db 18,22,37,56,68,109,103,77
  db 24,35,55,64,81,104,113,92
  db 49,64,78,87,103,121,120,101
  db 72,92,95,98,112,100,103,99

DCTQ: // DCT Quantization 8x8 Result Matrix (Quality = 50)
  db 38,0,-26,0,-8,0,-2,0
  db -9,0,-14,0,10,0,3,0
  db -13,0,6,0,5,0,-3,0
  db 16,0,-8,0,2,0,-2,0
  db 0,0,0,0,0,0,0,0
  db -6,0,2,0,-1,0,1,0
  db 2,0,-1,0,-1,0,1,0
  db 0,0,0,0,0,0,0,0

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