// N64 'Bare Metal' LZ77 ROM GFX Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "LZ77ROMGFX.N64", create
fill 1052672 // Set ROM Size

origin $00000000
base $80000000 // Entry Point Of Code
include "LIB/N64.INC" // Include N64 Definitions
include "LIB/N64_HEADER.ASM" // Include 64 Byte Header & Vector Table
insert "LIB/N64_BOOTCODE.BIN" // Include 4032 Byte Boot Code

Start:
  include "LIB/N64_GFX.INC" // Include Graphics Macros
  N64_INIT() // Run N64 Initialisation Routine

  ScreenNTSC(640, 480, BPP32|INTERLACE|AA_MODE_2, $A0100000) // Screen NTSC: 640x480, 32BPP, Interlace, Resample Only, DRAM Origin $A0100000

  la a0,$B0000000|((LZ+4)&$FFFFFFF) // A0 = Source Address Aligned Cart ROM Offset ($B0000000..$BFFFFFFF 256MB)
  lui a1,$A010 // A1 = Destination Address (DRAM Start Offset)

  lw t1,-4(a0) // T1 = Data Length Word
  srl t0,t1,24 // T0 = T1 >> 24
  andi t0,$00FF // T0 = LO Data Length Byte
  andi t2,t1,$FF00 // T2 = T1 & $FF00
  or t0,t2 // T0 = MID/LO Data Length Bytes
  andi t1,$00FF // T1 &= $00FF
  sll t1,16 // T1 <<= 16
  or t0,t1 // T0 = Data Length
  addu t0,a1 // T0 = Destination End Offset (DRAM End Offset)

  ori s0,r0,3 // S0 = Word Byte Counter
  lw s1,0(a0) // S1 = ROM Word
  addiu a0,4  // Source Address += 4

  LZLoop:
    sll t1,s0,3   // T1 = Word Byte Counter * 8
    srlv t1,s1,t1 // T1 = Flag Data For Next 8 Blocks (0 = Uncompressed Byte, 1 = Compressed Bytes)
    andi t1,$00FF // T1 &= $00FF
    bnez s0,LZSkipA // IF (Word Byte Counter != 0) LZ Skip A
    subiu s0,1  // Word Byte Counter-- (Delay Slot)
    ori s0,r0,3 // S0 = Word Byte Counter
    lw s1,0(a0) // S1 = ROM Word
    addiu a0,4  // Source Address += 4
    LZSkipA:

    lli t2,%10000000 // T2 = Flag Data Block Type Shifter
    LZBlockLoop:
      beq a1,t0,LZEnd // IF (Destination Address == Destination End Offset) LZEnd
      and t4,t1,t2 // Test Block Type (Delay Slot)
      beqz t2,LZLoop // IF (Flag Data Block Type Shifter == 0) LZLoop
      srl t2,1 // Shift T2 To Next Flag Data Block Type (Delay Slot)

      sll t3,s0,3   // T3 = Word Byte Counter * 8
      srlv t3,s1,t3 // T3 = Copy Uncompressed Byte / Number Of Bytes To Copy & Disp MSB's
      andi t3,$00FF // T3 &= $00FF
      bnez s0,LZSkipB // IF (Word Byte Counter != 0) LZ Skip A
      subiu s0,1  // Word Byte Counter-- (Delay Slot)
      ori s0,r0,3 // S0 = Word Byte Counter
      lw s1,0(a0) // S1 = ROM Word
      addiu a0,4  // Source Address += 4
      LZSkipB:

      bnez t4,LZDecode // IF (BlockType != 0) LZDecode Bytes
      nop // Delay Slot
      sb t3,0(a1) // Store Uncompressed Byte To Destination
      j LZBlockLoop
      addiu a1,1 // Add 1 To DRAM Offset (Delay Slot)

      LZDecode:
        sll t4,s0,3   // T4 = Word Byte Counter * 8
        srlv t4,s1,t4 // T4 = Disp LSB's
        andi t4,$00FF // T4 &= $00FF
        bnez s0,LZSkipC // IF (Word Byte Counter != 0) LZ Skip A
        subiu s0,1  // Word Byte Counter-- (Delay Slot)
        ori s0,r0,3 // S0 = Word Byte Counter
        lw s1,0(a0) // S1 = ROM Word
        addiu a0,4  // Source Address += 4
        LZSkipC:

        sll t5,t3,8 // T5 = Disp MSB's
        or t4,t5 // T4 = Disp 16-Bit
        andi t4,$FFF // T4 &= $FFF (Disp 12-Bit)
        not t4 // T4 = -Disp - 1
        addu t4,a1 // T4 = Destination - Disp - 1
        srl t3,4 // T3 = Number Of Bytes To Copy (Minus 3)
        addiu t3,3 // T3 = Number Of Bytes To Copy
        LZCopy:
          lbu t5,0(t4) // T5 = Byte To Copy
          addiu t4,1 // Add 1 To T4 Offset
          sb t5,0(a1) // Store Byte To DRAM
          subiu t3,1 // Number Of Bytes To Copy -= 1
          bnez t3,LZCopy // IF (Number Of Bytes To Copy != 0) LZCopy Bytes
          addiu a1,1 // Add 1 To DRAM Offset (Delay Slot)
          j LZBlockLoop
          nop // Delay Slot
    LZEnd:

Loop:
  WaitScanline($1E0) // Wait For Scanline To Reach Vertical Blank
  WaitScanline($1E2)

  lli t0,$00000800 // Even Field
  sw t0,VI_Y_SCALE(a0)

  WaitScanline($1E0) // Wait For Scanline To Reach Vertical Blank
  WaitScanline($1E2)

  li t0,$02000800 // Odd Field
  sw t0,VI_Y_SCALE(a0)

  j Loop
  nop // Delay Slot

insert LZ, "Image.lz"