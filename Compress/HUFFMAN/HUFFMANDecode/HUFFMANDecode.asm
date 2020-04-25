// N64 'Bare Metal' HUFFMAN Decode Demo by krom (Peter Lemon) & Andy Smith:
arch n64.cpu
endian msb
output "HUFFMANDecode.N64", create
fill 1052672 // Set ROM Size

origin $00000000
base $80000000 // Entry Point Of Code
include "LIB/N64.INC" // Include N64 Definitions
include "LIB/N64_HEADER.ASM" // Include 64 Byte Header & Vector Table
insert "LIB/N64_BOOTCODE.BIN" // Include 4032 Byte Boot Code

Start:
  N64_INIT() // Run N64 Initialisation Routine

  la a0,Huff+4  // A0 = Source Address
  lui a1,$8010  // A1 = Destination Address (DRAM Start Offset)

  lbu t0,-1(a0) // T0 = HI Data Length Byte
  lbu t1,-2(a0) // T1 = MID Data Length Byte
  sll t0,8
  or t0,t1
  lbu t1,-3(a0) // T1 = LO Data Length Byte
  sll t0,8
  or t0,t1      // T0 = Data Length
  addu t0,a1    // T0 = Destination End Offset (DRAM End Offset)

  lbu t1,0(a0) // T1 = (Tree Table Size / 2) - 1
  addiu a0,1   // A0 = Tree Table Offset
  sll t1,1
  addiu t1,1   // T1 = Tree Table Size
  addu t1,a0   // T1 = Compressed Bitstream Offset

  subiu a0,5  // A0 = Source Address
  ori t6,r0,0 // T6 = Branch/Leaf Flag (0 = Branch 1 = Leaf)
  ori t7,r0,5 // T7 = Tree Table Offset (Reset)
HuffChunkLoop:
  lbu t2,3(t1) // T2 = Data Length Byte 0
  lbu t8,2(t1) // T8 = Data Length Byte 1
  sll t2,8
  or t2,t8
  lbu t8,1(t1) // T8 = Data Length Byte 2
  sll t2,8
  or t2,t8
  lbu t8,0(t1) // T8 = Data Length Byte 3
  sll t2,8
  or t2,t8     // T2 = Node Bits (Bit31 = First Bit)
  addiu t1,4   // Add 4 To Compressed Bitstream Offset
  lui t3,$8000 // T3 = Node Bit Shifter

  HuffByteLoop: 
    beq a1,t0,HuffEnd // IF (Destination Address == Destination End Offset) HuffEnd
    addu t8,a0,t7 // T8 = Tree Table Offset (Delay Slot)
    beqz t3,HuffChunkLoop // IF (Node Bit Shifter == 0) HuffChunkLoop
    lbu t4,0(t8) // T4 = Next Node (Delay Slot)
    beqz t6,HuffBranch // Test T6 Branch/Leaf Flag (0 = Branch 1 = Leaf)
    andi t5,t4,$3F // T5 = Offset To Next Child Node (Delay Slot)
    sb t4,0(a1)    // Store Data Byte To Destination IF Leaf
    addiu a1,1     // Add 1 To DRAM Offset
    ori t7,r0,5    // T7 = Tree Table Offset (Reset)
    j HuffByteLoop
    ori t6,r0,0 // T6 = Branch (Delay Slot)

    HuffBranch:
      sll t5,1
      addiu t5,2   // T5 = Node0 Child Offset * 2 + 2
      andi t7,-2   // T7 = Tree Offset NOT 1
      addu t7,t5   // T7 = Node0 Child Offset
      and t8,t2,t3 // Test Node Bit (0 = Node0, 1 = Node1)
      beqz t8,HuffNode0
      srl t3,1     // Shift T3 To Next Node Bit (Delay Slot)
      addiu t7,1   // T7 = Node1 Child Offset
      j HuffNodeEnd
      ori t8,r0,$40 // T8 = Test Node1 End Flag (Delay Slot)
      HuffNode0:
        ori t8,r0,$80 // T8 = Test Node0 End Flag
      HuffNodeEnd:
        and t8,t4 // Test Node End Flag (1 = Next Child Node Is Data)
        beqz t8,HuffByteLoop
        nop // Delay Slot
        j HuffByteLoop
        ori t6,r0,1 // T6 = Leaf (Delay Slot)
  HuffEnd:

Loop:
  j Loop
  nop // Delay Slot

insert Huff, "Image.huff" // Include 640x480 24BPP Compressed Image Data (277300 Bytes)