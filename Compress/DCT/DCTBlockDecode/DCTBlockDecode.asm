// N64 'Bare Metal' DCT Block Decode Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "DCTBlockDecode.N64", create
fill 1052672 // Set ROM Size

origin $00000000
base $80000000 // Entry Point Of Code
include "LIB/N64.INC" // Include N64 Definitions
include "LIB/N64_HEADER.ASM" // Include 64 Byte Header & Vector Table
insert "LIB/N64_BOOTCODE.BIN" // Include 4032 Byte Boot Code

Start:
  N64_INIT() // Run N64 Initialisation Routine

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
	  lhu t4,0(a1) // T4 = DCT[V*8 + U]
          addiu a1,2 // DCT += 2
          // * C[U]
	  sll t5,t3,1 // T5 = U Offset
          addu t5,a2 // T5 = C[U] Offset
	  lhu t5,0(t5) // T5 = C[U]
	  multu t4,t5 // T4 *= C[U]
          mflo t4
	  srl t4,16 // Shift .16
          // * C[V]
	  sll t5,t2,1 // T5 = V Offset
          addu t5,a2 // T5 = C[V] Offset
	  lhu t5,0(t5) // T5 = C[V]
	  multu t4,t5 // T4 *= C[V]
          mflo t4
	  srl t4,16 // Shift .16
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

IDCT: // Inverse Discrete Cosine Transform (IDCT) 8x8 Result Matrix
  dh 0,0,0,0,0,0,0,0
  dh 0,0,0,0,0,0,0,0
  dh 0,0,0,0,0,0,0,0
  dh 0,0,0,0,0,0,0,0
  dh 0,0,0,0,0,0,0,0
  dh 0,0,0,0,0,0,0,0
  dh 0,0,0,0,0,0,0,0
  dh 0,0,0,0,0,0,0,0