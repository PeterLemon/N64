// N64 'Bare Metal' LZ77 Decode Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "LZ77Decode.N64", create
fill 1052672 // Set ROM Size

origin $00000000
base $80000000 // Entry Point Of Code
include "LIB/N64.INC" // Include N64 Definitions
include "LIB/N64_HEADER.ASM" // Include 64 Byte Header & Vector Table
insert "LIB/N64_BOOTCODE.BIN" // Include 4032 Byte Boot Code

Start:
  N64_INIT() // Run N64 Initialisation Routine

  la a0,LZ+4 // A0 = Source Address
  lui a1,$A010 // A1 = Destination Address (DRAM Start Offset)

  lbu t0,-1(a0) // T0 = HI Data Length Byte
  sll t0,8
  lbu t1,-2(a0) // T1 = MID Data Length Byte
  or t0,t1
  sll t0,8
  lbu t1,-3(a0) // T1 = LO Data Length Byte
  or t0,t1 // T0 = Data Length
  addu t0,a1 // T0 = Destination End Offset (DRAM End Offset)

  LZLoop:
    lbu t1,0(a0) // T1 = Flag Data For Next 8 Blocks (0 = Uncompressed Byte, 1 = Compressed Bytes)
    addiu a0,1 // Add 1 To LZ Offset
    lli t2,%10000000 // T2 = Flag Data Block Type Shifter
    LZBlockLoop:
      beq a1,t0,LZEnd // IF (Destination Address == Destination End Offset) LZEnd
      and t4,t1,t2 // Test Block Type (Delay Slot)
      beqz t2,LZLoop // IF (Flag Data Block Type Shifter == 0) LZLoop
      srl t2,1 // Shift T2 To Next Flag Data Block Type (Delay Slot)
      lbu t3,0(a0) // T3 = Copy Uncompressed Byte / Number Of Bytes To Copy & Disp MSB's
      bnez t4,LZDecode // IF (BlockType != 0) LZDecode Bytes
      addiu a0,1 // Add 1 To LZ Offset (Delay Slot)
      sb t3,0(a1) // Store Uncompressed Byte To Destination
      j LZBlockLoop
      addiu a1,1 // Add 1 To DRAM Offset (Delay Slot)

      LZDecode:
        lbu t4,0(a0) // T4 = Disp LSB's
        addiu a0,1 // Add 1 To LZ Offset
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
  j Loop
  nop // Delay Slot

insert LZ, "Image.lz"