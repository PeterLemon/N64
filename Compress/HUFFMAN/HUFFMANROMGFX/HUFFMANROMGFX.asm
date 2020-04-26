// N64 'Bare Metal' HUFFMAN ROM GFX Demo by krom (Peter Lemon) & Andy Smith:
arch n64.cpu
endian msb
output "HUFFMANROMGFX.N64", create
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

  la a0,$B0000000|(Huff&$FFFFFFF) // A0 = Source Address Aligned Cart ROM Offset ($B0000000..$BFFFFFFF 256MB)
  lui a1,$8010                    // A1 = Destination Address (DRAM Start Offset)

  lwu t1,0(a0)     // T1 = Data Length Word
  srl t0,t1,16     // T0 = T1 >> 16
  andi t0,$00FF    // T0 = LO Data Length Byte
  andi t2,t1,$FF00 // T2 = T1 & $FF00
  or t0,t2         // T0 = MID/LO Data Length Bytes
  andi t1,$00FF    // T1 &= $00FF
  sll t1,16        // T1 <<= 16
  or t0,t1         // T0 = Data Length
  addu t0,a1       // T0 = Destination End Offset (DRAM End Offset)

  lwu t1,4(a0) // T1 = (Tree Table Size / 2) - 1
  addiu a0,5   // A0 = Tree Table Offset
  srl t1,23    // T5 >>= 23
  ori t1,1     // T1 = Tree Table Size
  addu t1,a0   // T1 = Compressed Bitstream Offset

  subiu a0,5  // A0 = Source Address
  ori t6,r0,0 // T6 = Branch/Leaf Flag (0 = Branch 1 = Leaf)
  ori t7,r0,5 // T7 = Tree Table Offset (Reset)
HuffChunkLoop:
  lwu t3,0(t1) // T3 = Big Endian Node Bits
  addiu t1,4   // Add 4 To Compressed Bitstream Offset
  sll t2,t3,24 // T2 = Node Bits Byte 0
  andi t4,t3,$FF00
  sll t4,8     // T4 <<= 8
  or t2,t4     // T2 |= Node Bits Byte 1
  srl t3,16    // T3 >>= 16
  andi t4,t3,$00FF
  sll t4,8     // T4 <<= 8
  or t2,t4     // T2 |= Node Bits Byte 2
  srl t3,8     // T3 >>= 8
  or t2,t3     // T2 = Node Bits (Bit31 = First Bit)
  lui t3,$8000 // T3 = Node Bit Shifter

  HuffByteLoop: 
    beq a1,t0,HuffEnd // IF (Destination Address == Destination End Offset) HuffEnd
    addu t4,a0,t7 // T4 = Tree Table Offset (Delay Slot)
    andi t5,t4,3  // T5 = T4 & 3
    subu t4,t5    // T4 = Word Aligned Address
    lwu t4,0(t4)  // T4 = Next Node Word
    xori t5,3     // Invert Bits
    sll t5,3      // T5 <<= 3
    beqz t3,HuffChunkLoop // IF (Node Bit Shifter == 0) HuffChunkLoop
    srlv t4,t5    // T4 = Next Node (Delay Slot)
    beqz t6,HuffBranch // Test T6 Branch/Leaf Flag (0 = Branch 1 = Leaf)
    andi t5,t4,$3F // T5 = Offset To Next Child Node (Delay Slot)
    sb t4,0(a1)    // Store Data Byte To Destination IF Leaf
    addiu a1,1     // Add 1 To DRAM Offset
    ori t7,r0,5    // T7 = Tree Table Offset (Reset)
    j HuffByteLoop
    ori t6,r0,0 // T6 = Branch (Delay Slot)

    HuffBranch:
      sll t5,1     // T5 <<= 1
      addiu t5,2   // T5 = Node0 Child Offset * 2 + 2
      andi t7,-2   // T7 = Tree Offset NOT 1
      addu t7,t5   // T7 = Node0 Child Offset
      and t5,t2,t3 // Test Node Bit (0 = Node0, 1 = Node1)
      beqzl t5,HuffNodeEnd
      andi t4,$80  // T4 = Test Node0 End Flag (Delay Slot)
      andi t4,$40  // T4 = Test Node1 End Flag
      addiu t7,1   // T7 = Node1 Child Offset + 1
      HuffNodeEnd:
        beqz t4,HuffByteLoop // Test Node End Flag (1 = Next Child Node Is Data)
        srl t3,1 // Shift T3 To Next Node Bit (Delay Slot)
        j HuffByteLoop
        ori t6,r0,1 // T6 = Leaf (Delay Slot)
  HuffEnd:

Loop:
  WaitScanline($1E0) // Wait For Scanline To Reach Vertical Blank
  WaitScanline($1E2)

  ori t0,r0,$00000800 // Even Field
  sw t0,VI_Y_SCALE(a0)

  WaitScanline($1E0) // Wait For Scanline To Reach Vertical Blank
  WaitScanline($1E2)

  li t0,$02000800 // Odd Field
  sw t0,VI_Y_SCALE(a0)

  j Loop
  nop // Delay Slot

insert Huff, "Image.huff" // Include 640x480 24BPP Compressed Image Data (277300 Bytes)