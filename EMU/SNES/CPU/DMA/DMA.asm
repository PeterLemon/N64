//-----------------------
// DMA CPU To I/O Macros
//-----------------------
macro DMACPUSRC() { // DMA CPU Source & I/O Destination ($21XX)
  ori t7,t8,$2100 // T7 = I/O Offset ($21XX)
  addu t7,a0      // T7 += MEM_MAP

  sll t8,2        // Offset *= 4 (Indirect Table Offset)
  la t0,STORE21XX // T0 = Store I/O $21XX Indirect Table
  addu t8,t0      // T8 = Store I/O $21XX Indirect Table Offset
}

macro DMACPUFIXSRC() { // DMA CPU Fixed Source & I/O Destination ($21XX)
  lbu t6,0(at)    // T6 = MEM_MAP[DMA Address]
  ori t7,t8,$2100 // T7 = I/O Offset ($21XX)
  addu t7,a0      // T7 += MEM_MAP

  sll t8,2        // Offset *= 4 (Indirect Table Offset)
  la t0,STORE21XX // T0 = Store I/O $21XX Indirect Table
  addu t8,t0      // T8 = Store I/O $21XX Indirect Table Offset
}


macro DMACPUDECSRC0() { // DMA Transfer Mode 0: Decrement Source, Transfer 1 Byte, CPU To I/O (xx)
  lw t8,0(t8)     // T8 = Store I/O $21XX Table Offset
  {#}DMALOOP:
    lbu t6,0(at)  // T6 = MEM_MAP[DMA Address]
    subiu at,1    // DMA Address-- (Decrement Source)
    jalr gp,t8    // Run Store I/O $21XX Instruction
    sb t6,0(t7)   // MEM_MAP[$21XX] = T6 (Delay Slot)
    subiu k0,1    // K0-- (Decrement DMA Count)
    bnez k0,{#}DMALOOP
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)
}

macro DMACPUDECSRC1() { // DMA Transfer Mode 1: Decrement Source, Transfer 2 Bytes, CPU To I/O (XX, XX+1)
  {#}DMALOOP:
    lbu t6,0(at)  // T6 = MEM_MAP[DMA Address]
    subiu at,1    // DMA Address-- (Decrement Source)
    lw t0,0(t8)   // T0 = Store I/O $21XX Table Offset
    jalr gp,t0    // Run Store I/O $21XX Instruction
    sb t6,0(t7)   // MEM_MAP[$21XX] = T6 (Delay Slot)
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lbu t6,0(at)  // T6 = MEM_MAP[DMA Address]
    subiu at,1    // DMA Address-- (Decrement Source)
    lw t0,4(t8)   // T0 = Store I/O $21XX Table Offset
    jalr gp,t0    // Run Store I/O $21XX Instruction
    sb t6,1(t7)   // MEM_MAP[$21XX] = T6 (Delay Slot)
    subiu k0,1    // K0-- (Decrement DMA Count)
    bnez k0,{#}DMALOOP
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)
  {#}DMAEND:
}

macro DMACPUDECSRC2() { // DMA Transfer Mode 2: Decrement Source, Transfer 2 Bytes, CPU To I/O (XX, XX)
  lw t8,0(t8)     // T8 = Store I/O $21XX Table Offset
  {#}DMALOOP:
    lbu t6,0(at)  // T6 = MEM_MAP[DMA Address]
    subiu at,1    // DMA Address-- (Decrement Source)
    jalr gp,t8    // Run Store I/O $21XX Instruction
    sb t6,0(t7)   // MEM_MAP[$21XX] = T6 (Delay Slot)
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lbu t6,0(at)  // T6 = MEM_MAP[DMA Address]
    subiu at,1    // DMA Address-- (Decrement Source)
    jalr gp,t8    // Run Store I/O $21XX Instruction
    sb t6,0(t7)   // MEM_MAP[$21XX] = T6 (Delay Slot)
    subiu k0,1    // K0-- (Decrement DMA Count)
    bnez k0,{#}DMALOOP
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)
  {#}DMAEND:
}

macro DMACPUDECSRC3() { // DMA Transfer Mode 3: Decrement Source, Transfer 4 Bytes, CPU To I/O (XX, XX, XX+1, XX+1)
  {#}DMALOOP:
    lbu t6,0(at)  // T6 = MEM_MAP[DMA Address]
    subiu at,1    // DMA Address-- (Decrement Source)
    lw t0,0(t8)   // T0 = Store I/O $21XX Table Offset
    jalr gp,t0    // Run Store I/O $21XX Instruction
    sb t6,0(t7)   // MEM_MAP[$21XX] = T6 (Delay Slot)
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lbu t6,0(at)  // T6 = MEM_MAP[DMA Address]
    subiu at,1    // DMA Address-- (Decrement Source)
    lw t0,0(t8)   // T0 = Store I/O $21XX Table Offset
    jalr gp,t0    // Run Store I/O $21XX Instruction
    sb t6,0(t7)   // MEM_MAP[$21XX] = T6 (Delay Slot)
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lbu t6,0(at)  // T6 = MEM_MAP[DMA Address]
    subiu at,1    // DMA Address-- (Decrement Source)
    lw t0,4(t8)   // T0 = Store I/O $21XX Table Offset
    jalr gp,t0    // Run Store I/O $21XX Instruction
    sb t6,1(t7)   // MEM_MAP[$21XX] = T6 (Delay Slot)
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lbu t6,0(at)  // T6 = MEM_MAP[DMA Address]
    subiu at,1    // DMA Address-- (Decrement Source)
    lw t0,4(t8)   // T0 = Store I/O $21XX Table Offset
    jalr gp,t0    // Run Store I/O $21XX Instruction
    sb t6,1(t7)   // MEM_MAP[$21XX] = T6 (Delay Slot)
    subiu k0,1    // K0-- (Decrement DMA Count)
    bnez k0,{#}DMALOOP
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)
  {#}DMAEND:
}

macro DMACPUDECSRC4() { // DMA Transfer Mode 4: Decrement Source, Transfer 4 Bytes, CPU To I/O (XX, XX+1, XX+2, XX+3)
  {#}DMALOOP:
    lbu t6,0(at)  // T6 = MEM_MAP[DMA Address]
    subiu at,1    // DMA Address-- (Decrement Source)
    lw t0,0(t8)   // T0 = Store I/O $21XX Table Offset
    jalr gp,t0    // Run Store I/O $21XX Instruction
    sb t6,0(t7)   // MEM_MAP[$21XX] = T6 (Delay Slot)
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lbu t6,0(at)  // T6 = MEM_MAP[DMA Address]
    subiu at,1    // DMA Address-- (Decrement Source)
    lw t0,4(t8)   // T0 = Store I/O $21XX Table Offset
    jalr gp,t0    // Run Store I/O $21XX Instruction
    sb t6,1(t7)   // MEM_MAP[$21XX] = T6 (Delay Slot)
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lbu t6,0(at)  // T6 = MEM_MAP[DMA Address]
    subiu at,1    // DMA Address-- (Decrement Source)
    lw t0,8(t8)   // T0 = Store I/O $21XX Table Offset
    jalr gp,t0    // Run Store I/O $21XX Instruction
    sb t6,2(t7)   // MEM_MAP[$21XX] = T6 (Delay Slot)
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lbu t6,0(at)  // T6 = MEM_MAP[DMA Address]
    subiu at,1    // DMA Address-- (Decrement Source)
    lw t0,12(t8)  // T0 = Store I/O $21XX Table Offset
    jalr gp,t0    // Run Store I/O $21XX Instruction
    sb t6,3(t7)   // MEM_MAP[$21XX] = T6 (Delay Slot)
    subiu k0,1    // K0-- (Decrement DMA Count)
    bnez k0,{#}DMALOOP
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)
  {#}DMAEND:
}

macro DMACPUDECSRC5() { // DMA Transfer Mode 5: Decrement Source, Transfer 4 Bytes, CPU To I/O (XX, XX+1, XX, XX+1)
  {#}DMALOOP:
    lbu t6,0(at)  // T6 = MEM_MAP[DMA Address]
    subiu at,1    // DMA Address-- (Decrement Source)
    lw t0,0(t8)   // T0 = Store I/O $21XX Table Offset
    jalr gp,t0    // Run Store I/O $21XX Instruction
    sb t6,0(t7)   // MEM_MAP[$21XX] = T6 (Delay Slot)
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lbu t6,0(at)  // T6 = MEM_MAP[DMA Address]
    subiu at,1    // DMA Address-- (Decrement Source)
    lw t0,4(t8)   // T0 = Store I/O $21XX Table Offset
    jalr gp,t0    // Run Store I/O $21XX Instruction
    sb t6,1(t7)   // MEM_MAP[$21XX] = T6 (Delay Slot)
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lbu t6,0(at)  // T6 = MEM_MAP[DMA Address]
    subiu at,1    // DMA Address-- (Decrement Source)
    lw t0,0(t8)   // T0 = Store I/O $21XX Table Offset
    jalr gp,t0    // Run Store I/O $21XX Instruction
    sb t6,0(t7)   // MEM_MAP[$21XX] = T6 (Delay Slot)
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lbu t6,0(at)  // T6 = MEM_MAP[DMA Address]
    subiu at,1    // DMA Address-- (Decrement Source)
    lw t0,4(t8)   // T0 = Store I/O $21XX Table Offset
    jalr gp,t0    // Run Store I/O $21XX Instruction
    sb t6,1(t7)   // MEM_MAP[$21XX] = T6 (Delay Slot)
    subiu k0,1    // K0-- (Decrement DMA Count)
    bnez k0,{#}DMALOOP
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)
  {#}DMAEND:
}


macro DMACPUFIXSRC0() { // DMA Transfer Mode 0: Fixed Source, Transfer 1 Byte, CPU To I/O (xx)
  lw t8,0(t8)     // T8 = Store I/O $21XX Table Offset
  {#}DMALOOP:
    jalr gp,t8    // Run Store I/O $21XX Instruction
    sb t6,0(t7)   // MEM_MAP[$21XX] = T6 (Delay Slot)
    subiu k0,1    // K0-- (Decrement DMA Count)
    bnez k0,{#}DMALOOP
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)
}

macro DMACPUFIXSRC1() { // DMA Transfer Mode 1: Fixed Source, Transfer 2 Bytes, CPU To I/O (XX, XX+1)
  {#}DMALOOP:
    lw t0,0(t8)   // T0 = Store I/O $21XX Table Offset
    jalr gp,t0    // Run Store I/O $21XX Instruction
    sb t6,0(t7)   // MEM_MAP[$21XX] = T6 (Delay Slot)
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lw t0,4(t8)   // T0 = Store I/O $21XX Table Offset
    jalr gp,t0    // Run Store I/O $21XX Instruction
    sb t6,1(t7)   // MEM_MAP[$21XX] = T6 (Delay Slot)
    subiu k0,1    // K0-- (Decrement DMA Count)
    bnez k0,{#}DMALOOP
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)
  {#}DMAEND:
}

macro DMACPUFIXSRC2() { // DMA Transfer Mode 2: Fixed Source, Transfer 2 Bytes, CPU To I/O (XX, XX)
  lw t8,0(t8)     // T8 = Store I/O $21XX Table Offset
  {#}DMALOOP:
    jalr gp,t8    // Run Store I/O $21XX Instruction
    sb t6,0(t7)   // MEM_MAP[$21XX] = T6 (Delay Slot)
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    jalr gp,t8    // Run Store I/O $21XX Instruction
    sb t6,0(t7)   // MEM_MAP[$21XX] = T6 (Delay Slot)
    subiu k0,1    // K0-- (Decrement DMA Count)
    bnez k0,{#}DMALOOP
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)
  {#}DMAEND:
}

macro DMACPUFIXSRC3() { // DMA Transfer Mode 3: Fixed Source, Transfer 4 Bytes, CPU To I/O (XX, XX, XX+1, XX+1)
  {#}DMALOOP:
    lw t0,0(t8)   // T0 = Store I/O $21XX Table Offset
    jalr gp,t0    // Run Store I/O $21XX Instruction
    sb t6,0(t7)   // MEM_MAP[$21XX] = T6 (Delay Slot)
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lw t0,0(t8)   // T0 = Store I/O $21XX Table Offset
    jalr gp,t0    // Run Store I/O $21XX Instruction
    sb t6,0(t7)   // MEM_MAP[$21XX] = T6 (Delay Slot)
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lw t0,4(t8)   // T0 = Store I/O $21XX Table Offset
    jalr gp,t0    // Run Store I/O $21XX Instruction
    sb t6,1(t7)   // MEM_MAP[$21XX] = T6 (Delay Slot)
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lw t0,4(t8)   // T0 = Store I/O $21XX Table Offset
    jalr gp,t0    // Run Store I/O $21XX Instruction
    sb t6,1(t7)   // MEM_MAP[$21XX] = T6 (Delay Slot)
    subiu k0,1    // K0-- (Decrement DMA Count)
    bnez k0,{#}DMALOOP
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)
  {#}DMAEND:
}

macro DMACPUFIXSRC4() { // DMA Transfer Mode 4: Fixed Source, Transfer 4 Bytes, CPU To I/O (XX, XX+1, XX+2, XX+3)
  {#}DMALOOP:
    lw t0,0(t8)   // T0 = Store I/O $21XX Table Offset
    jalr gp,t0    // Run Store I/O $21XX Instruction
    sb t6,0(t7)   // MEM_MAP[$21XX] = T6 (Delay Slot)
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lw t0,4(t8)   // T0 = Store I/O $21XX Table Offset
    jalr gp,t0    // Run Store I/O $21XX Instruction
    sb t6,1(t7)   // MEM_MAP[$21XX] = T6 (Delay Slot)
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lw t0,8(t8)   // T0 = Store I/O $21XX Table Offset
    jalr gp,t0    // Run Store I/O $21XX Instruction
    sb t6,2(t7)   // MEM_MAP[$21XX] = T6 (Delay Slot)
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lw t0,12(t8)  // T0 = Store I/O $21XX Table Offset
    jalr gp,t0    // Run Store I/O $21XX Instruction
    sb t6,3(t7)   // MEM_MAP[$21XX] = T6 (Delay Slot)
    subiu k0,1    // K0-- (Decrement DMA Count)
    bnez k0,{#}DMALOOP
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)
  {#}DMAEND:
}

macro DMACPUFIXSRC5() { // DMA Transfer Mode 5: Fixed Source, Transfer 4 Bytes, CPU To I/O (XX, XX+1, XX, XX+1)
  {#}DMALOOP:
    lw t0,0(t8)   // T0 = Store I/O $21XX Table Offset
    jalr gp,t0    // Run Store I/O $21XX Instruction
    sb t6,0(t7)   // MEM_MAP[$21XX] = T6 (Delay Slot)
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lw t0,4(t8)   // T0 = Store I/O $21XX Table Offset
    jalr gp,t0    // Run Store I/O $21XX Instruction
    sb t6,1(t7)   // MEM_MAP[$21XX] = T6 (Delay Slot)
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lw t0,0(t8)   // T0 = Store I/O $21XX Table Offset
    jalr gp,t0    // Run Store I/O $21XX Instruction
    sb t6,0(t7)   // MEM_MAP[$21XX] = T6 (Delay Slot)
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lw t0,4(t8)   // T0 = Store I/O $21XX Table Offset
    jalr gp,t0    // Run Store I/O $21XX Instruction
    sb t6,1(t7)   // MEM_MAP[$21XX] = T6 (Delay Slot)
    subiu k0,1    // K0-- (Decrement DMA Count)
    bnez k0,{#}DMALOOP
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)
  {#}DMAEND:
}


macro DMACPUINCSRC0() { // DMA Transfer Mode 0: Increment Source, Transfer 1 Byte, CPU To I/O (xx)
  lw t8,0(t8)     // T8 = Store I/O $21XX Table Offset
  {#}DMALOOP:
    lbu t6,0(at)  // T6 = MEM_MAP[DMA Address]
    addiu at,1    // DMA Address++ (Increment Source)
    jalr gp,t8    // Run Store I/O $21XX Instruction
    sb t6,0(t7)   // MEM_MAP[$21XX] = T6 (Delay Slot)
    subiu k0,1    // K0-- (Decrement DMA Count)
    bnez k0,{#}DMALOOP
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)
}

macro DMACPUINCSRC1() { // DMA Transfer Mode 1: Increment Source, Transfer 2 Bytes, CPU To I/O (XX, XX+1)
  {#}DMALOOP:
    lbu t6,0(at)  // T6 = MEM_MAP[DMA Address]
    addiu at,1    // DMA Address++ (Increment Source)
    lw t0,0(t8)   // T0 = Store I/O $21XX Table Offset
    jalr gp,t0    // Run Store I/O $21XX Instruction
    sb t6,0(t7)   // MEM_MAP[$21XX] = T6 (Delay Slot)
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lbu t6,0(at)  // T6 = MEM_MAP[DMA Address]
    addiu at,1    // DMA Address++ (Increment Source)
    lw t0,4(t8)   // T0 = Store I/O $21XX Table Offset
    jalr gp,t0    // Run Store I/O $21XX Instruction
    sb t6,1(t7)   // MEM_MAP[$21XX] = T6 (Delay Slot)
    subiu k0,1    // K0-- (Decrement DMA Count)
    bnez k0,{#}DMALOOP
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)
  {#}DMAEND:
}

macro DMACPUINCSRC2() { // DMA Transfer Mode 2: Increment Source, Transfer 2 Bytes, CPU To I/O (XX, XX)
  lw t8,0(t8)     // T8 = Store I/O $21XX Table Offset
  {#}DMALOOP:
    lbu t6,0(at)  // T6 = MEM_MAP[DMA Address]
    addiu at,1    // DMA Address++ (Increment Source)
    jalr gp,t8    // Run Store I/O $21XX Instruction
    sb t6,0(t7)   // MEM_MAP[$21XX] = T6 (Delay Slot)
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lbu t6,0(at)  // T6 = MEM_MAP[DMA Address]
    addiu at,1    // DMA Address++ (Increment Source)
    jalr gp,t8    // Run Store I/O $21XX Instruction
    sb t6,0(t7)   // MEM_MAP[$21XX] = T6 (Delay Slot)
    subiu k0,1    // K0-- (Decrement DMA Count)
    bnez k0,{#}DMALOOP
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)
  {#}DMAEND:
}

macro DMACPUINCSRC3() { // DMA Transfer Mode 3: Increment Source, Transfer 4 Bytes, CPU To I/O (XX, XX, XX+1, XX+1)
  {#}DMALOOP:
    lbu t6,0(at)  // T6 = MEM_MAP[DMA Address]
    addiu at,1    // DMA Address++ (Increment Source)
    lw t0,0(t8)   // T0 = Store I/O $21XX Table Offset
    jalr gp,t0    // Run Store I/O $21XX Instruction
    sb t6,0(t7)   // MEM_MAP[$21XX] = T6 (Delay Slot)
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lbu t6,0(at)  // T6 = MEM_MAP[DMA Address]
    addiu at,1    // DMA Address++ (Increment Source)
    lw t0,0(t8)   // T0 = Store I/O $21XX Table Offset
    jalr gp,t0    // Run Store I/O $21XX Instruction
    sb t6,0(t7)   // MEM_MAP[$21XX] = T6 (Delay Slot)
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lbu t6,0(at)  // T6 = MEM_MAP[DMA Address]
    addiu at,1    // DMA Address++ (Increment Source)
    lw t0,4(t8)   // T0 = Store I/O $21XX Table Offset
    jalr gp,t0    // Run Store I/O $21XX Instruction
    sb t6,1(t7)   // MEM_MAP[$21XX] = T6 (Delay Slot)
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lbu t6,0(at)  // T6 = MEM_MAP[DMA Address]
    addiu at,1    // DMA Address++ (Increment Source)
    lw t0,4(t8)   // T0 = Store I/O $21XX Table Offset
    jalr gp,t0    // Run Store I/O $21XX Instruction
    sb t6,1(t7)   // MEM_MAP[$21XX] = T6 (Delay Slot)
    subiu k0,1    // K0-- (Decrement DMA Count)
    bnez k0,{#}DMALOOP
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)
  {#}DMAEND:
}

macro DMACPUINCSRC4() { // DMA Transfer Mode 4: Increment Source, Transfer 4 Bytes, CPU To I/O (XX, XX+1, XX+2, XX+3)
  {#}DMALOOP:
    lbu t6,0(at)  // T6 = MEM_MAP[DMA Address]
    addiu at,1    // DMA Address++ (Increment Source)
    lw t0,0(t8)   // T0 = Store I/O $21XX Table Offset
    jalr gp,t0    // Run Store I/O $21XX Instruction
    sb t6,0(t7)   // MEM_MAP[$21XX] = T6 (Delay Slot)
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lbu t6,0(at)  // T6 = MEM_MAP[DMA Address]
    addiu at,1    // DMA Address++ (Increment Source)
    lw t0,4(t8)   // T0 = Store I/O $21XX Table Offset
    jalr gp,t0    // Run Store I/O $21XX Instruction
    sb t6,1(t7)   // MEM_MAP[$21XX] = T6 (Delay Slot)
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lbu t6,0(at)  // T6 = MEM_MAP[DMA Address]
    addiu at,1    // DMA Address++ (Increment Source)
    lw t0,8(t8)   // T0 = Store I/O $21XX Table Offset
    jalr gp,t0    // Run Store I/O $21XX Instruction
    sb t6,2(t7)   // MEM_MAP[$21XX] = T6 (Delay Slot)
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lbu t6,0(at)  // T6 = MEM_MAP[DMA Address]
    addiu at,1    // DMA Address++ (Increment Source)
    lw t0,12(t8)  // T0 = Store I/O $21XX Table Offset
    jalr gp,t0    // Run Store I/O $21XX Instruction
    sb t6,3(t7)   // MEM_MAP[$21XX] = T6 (Delay Slot)
    subiu k0,1    // K0-- (Decrement DMA Count)
    bnez k0,{#}DMALOOP
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)
  {#}DMAEND:
}

macro DMACPUINCSRC5() { // DMA Transfer Mode 5: Increment Source, Transfer 4 Bytes, CPU To I/O (XX, XX+1, XX, XX+1)
  {#}DMALOOP:
    lbu t6,0(at)  // T6 = MEM_MAP[DMA Address]
    addiu at,1    // DMA Address++ (Increment Source)
    lw t0,0(t8)   // T0 = Store I/O $21XX Table Offset
    jalr gp,t0    // Run Store I/O $21XX Instruction
    sb t6,0(t7)   // MEM_MAP[$21XX] = T6 (Delay Slot)
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lbu t6,0(at)  // T6 = MEM_MAP[DMA Address]
    addiu at,1    // DMA Address++ (Increment Source)
    lw t0,4(t8)   // T0 = Store I/O $21XX Table Offset
    jalr gp,t0    // Run Store I/O $21XX Instruction
    sb t6,1(t7)   // MEM_MAP[$21XX] = T6 (Delay Slot)
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lbu t6,0(at)  // T6 = MEM_MAP[DMA Address]
    addiu at,1    // DMA Address++ (Increment Source)
    lw t0,0(t8)   // T0 = Store I/O $21XX Table Offset
    jalr gp,t0    // Run Store I/O $21XX Instruction
    sb t6,0(t7)   // MEM_MAP[$21XX] = T6 (Delay Slot)
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lbu t6,0(at)  // T6 = MEM_MAP[DMA Address]
    addiu at,1    // DMA Address++ (Increment Source)
    lw t0,4(t8)   // T0 = Store I/O $21XX Table Offset
    jalr gp,t0    // Run Store I/O $21XX Instruction
    sb t6,1(t7)   // MEM_MAP[$21XX] = T6 (Delay Slot)
    subiu k0,1    // K0-- (Decrement DMA Count)
    bnez k0,{#}DMALOOP
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)
  {#}DMAEND:
}


//-----------------------
// DMA I/O To CPU Macros
//-----------------------
macro DMACPUDST() { // DMA I/O Source & CPU Destination ($21XX)
  ori t7,t8,$2100 // T7 = I/O Offset ($21XX)
  addu t7,a0      // T7 += MEM_MAP

  sll t8,2        // Offset *= 4 (Indirect Table Offset)
  la t0,LOAD21XX  // T0 = Load I/O $21XX Indirect Table
  addu t8,t0      // T8 = Load I/O $21XX Indirect Table Offset
}


macro DMACPUDECDST0() { // DMA Transfer Mode 0: Decrement Destination, Transfer 1 Byte, I/O To CPU (xx)
  lw t8,0(t8)     // T8 = Load I/O $21XX Table Offset
  {#}DMALOOP:
    jalr gp,t8    // Run Load I/O $21XX Instruction
    nop           // Delay Slot
    lbu t6,0(t7)  // T6 = MEM_MAP[$21XX]
    sb t6,0(at)   // MEM_MAP[DMA Address] = T6
    subiu at,1    // DMA Address-- (Decrement Destination)
    subiu k0,1    // K0-- (Decrement DMA Count)
    bnez k0,{#}DMALOOP
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)
}

macro DMACPUDECDST1() { // DMA Transfer Mode 1: Decrement Destination, Transfer 2 Bytes, I/O To CPU (XX, XX+1)
  {#}DMALOOP:
    lw t0,0(t8)   // T0 = Load I/O $21XX Table Offset
    jalr gp,t0    // Run Load I/O $21XX Instruction
    nop           // Delay Slot
    lbu t6,0(t7)  // T6 = MEM_MAP[$21XX]
    sb t6,0(at)   // MEM_MAP[DMA Address] = T6
    subiu at,1    // DMA Address-- (Decrement Destination)
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lw t0,4(t8)   // T0 = Load I/O $21XX Table Offset
    jalr gp,t0    // Run Load I/O $21XX Instruction
    nop           // Delay Slot
    lbu t6,1(t7)  // T6 = MEM_MAP[$21XX]
    sb t6,0(at)   // MEM_MAP[DMA Address] = T6
    subiu at,1    // DMA Address-- (Decrement Destination)
    subiu k0,1    // K0-- (Decrement DMA Count)
    bnez k0,{#}DMALOOP
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)
  {#}DMAEND:
}

macro DMACPUDECDST2() { // DMA Transfer Mode 2: Decrement Destination, Transfer 2 Bytes, I/O To CPU (XX, XX)
  lw t8,0(t8)     // T8 = Load I/O $21XX Table Offset
  {#}DMALOOP:
    jalr gp,t8    // Run Load I/O $21XX Instruction
    nop           // Delay Slot
    lbu t6,0(t7)  // T6 = MEM_MAP[$21XX]
    sb t6,0(at)   // MEM_MAP[DMA Address] = T6
    subiu at,1    // DMA Address-- (Decrement Destination)
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    jalr gp,t8    // Run Load I/O $21XX Instruction
    nop           // Delay Slot
    lbu t6,0(t7)  // T6 = MEM_MAP[$21XX]
    sb t6,0(at)   // MEM_MAP[DMA Address] = T6
    subiu at,1    // DMA Address-- (Decrement Destination)
    subiu k0,1    // K0-- (Decrement DMA Count)
    bnez k0,{#}DMALOOP
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)
  {#}DMAEND:
}

macro DMACPUDECDST3() { // DMA Transfer Mode 3: Decrement Destination, Transfer 4 Bytes, I/O To CPU (XX, XX, XX+1, XX+1)
  {#}DMALOOP:
    lw t0,0(t8)   // T0 = Load I/O $21XX Table Offset
    jalr gp,t0    // Run Load I/O $21XX Instruction
    nop           // Delay Slot
    lbu t6,0(t7)  // T6 = MEM_MAP[$21XX]
    sb t6,0(at)   // MEM_MAP[DMA Address] = T6
    subiu at,1    // DMA Address-- (Decrement Destination)
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lw t0,0(t8)   // T0 = Load I/O $21XX Table Offset
    jalr gp,t0    // Run Load I/O $21XX Instruction
    nop           // Delay Slot
    lbu t6,0(t7)  // T6 = MEM_MAP[$21XX]
    sb t6,0(at)   // MEM_MAP[DMA Address] = T6
    subiu at,1    // DMA Address-- (Decrement Destination)
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lw t0,4(t8)   // T0 = Load I/O $21XX Table Offset
    jalr gp,t0    // Run Load I/O $21XX Instruction
    nop           // Delay Slot
    lbu t6,1(t7)  // T6 = MEM_MAP[$21XX]
    sb t6,0(at)   // MEM_MAP[DMA Address] = T6
    subiu at,1    // DMA Address-- (Decrement Destination)
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lw t0,4(t8)   // T0 = Load I/O $21XX Table Offset
    jalr gp,t0    // Run Load I/O $21XX Instruction
    nop           // Delay Slot
    lbu t6,1(t7)  // T6 = MEM_MAP[$21XX]
    sb t6,0(at)   // MEM_MAP[DMA Address] = T6
    subiu at,1    // DMA Address-- (Decrement Destination)
    subiu k0,1    // K0-- (Decrement DMA Count)
    bnez k0,{#}DMALOOP
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)
  {#}DMAEND:
}

macro DMACPUDECDST4() { // DMA Transfer Mode 4: Decrement Destination, Transfer 4 Bytes, I/O To CPU (XX, XX+1, XX+2, XX+3)
  {#}DMALOOP:
    lw t0,0(t8)   // T0 = Load I/O $21XX Table Offset
    jalr gp,t0    // Run Load I/O $21XX Instruction
    nop           // Delay Slot
    lbu t6,0(t7)  // T6 = MEM_MAP[$21XX]
    sb t6,0(at)   // MEM_MAP[DMA Address] = T6
    subiu at,1    // DMA Address-- (Decrement Destination)
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lw t0,4(t8)   // T0 = Load I/O $21XX Table Offset
    jalr gp,t0    // Run Load I/O $21XX Instruction
    nop           // Delay Slot
    lbu t6,1(t7)  // T6 = MEM_MAP[$21XX]
    sb t6,0(at)   // MEM_MAP[DMA Address] = T6
    subiu at,1    // DMA Address-- (Decrement Destination)
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lw t0,8(t8)   // T0 = Load I/O $21XX Table Offset
    jalr gp,t0    // Run Load I/O $21XX Instruction
    nop           // Delay Slot
    lbu t6,2(t7)  // T6 = MEM_MAP[$21XX]
    sb t6,0(at)   // MEM_MAP[DMA Address] = T6
    subiu at,1    // DMA Address-- (Decrement Destination)
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lw t0,12(t8)  // T0 = Load I/O $21XX Table Offset
    jalr gp,t0    // Run Load I/O $21XX Instruction
    nop           // Delay Slot
    lbu t6,3(t7)  // T6 = MEM_MAP[$21XX]
    sb t6,0(at)   // MEM_MAP[DMA Address] = T6
    subiu at,1    // DMA Address-- (Decrement Destination)
    subiu k0,1    // K0-- (Decrement DMA Count)
    bnez k0,{#}DMALOOP
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)
  {#}DMAEND:
}

macro DMACPUDECDST5() { // DMA Transfer Mode 5: Decrement Destination, Transfer 4 Bytes, I/O To CPU (XX, XX+1, XX, XX+1)
  {#}DMALOOP:
    lw t0,0(t8)   // T0 = Load I/O $21XX Table Offset
    jalr gp,t0    // Run Load I/O $21XX Instruction
    nop           // Delay Slot
    lbu t6,0(t7)  // T6 = MEM_MAP[$21XX]
    sb t6,0(at)   // MEM_MAP[DMA Address] = T6
    subiu at,1    // DMA Address-- (Decrement Destination)
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lw t0,4(t8)   // T0 = Load I/O $21XX Table Offset
    jalr gp,t0    // Run Load I/O $21XX Instruction
    nop           // Delay Slot
    lbu t6,1(t7)  // T6 = MEM_MAP[$21XX]
    sb t6,0(at)   // MEM_MAP[DMA Address] = T6
    subiu at,1    // DMA Address-- (Decrement Destination)
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lw t0,0(t8)   // T0 = Load I/O $21XX Table Offset
    jalr gp,t0    // Run Load I/O $21XX Instruction
    nop           // Delay Slot
    lbu t6,0(t7)  // T6 = MEM_MAP[$21XX]
    sb t6,0(at)   // MEM_MAP[DMA Address] = T6
    subiu at,1    // DMA Address-- (Decrement Destination)
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lw t0,4(t8)   // T0 = Load I/O $21XX Table Offset
    jalr gp,t0    // Run Load I/O $21XX Instruction
    nop           // Delay Slot
    lbu t6,1(t7)  // T6 = MEM_MAP[$21XX]
    sb t6,0(at)   // MEM_MAP[DMA Address] = T6
    subiu at,1    // DMA Address-- (Decrement Destination)
    subiu k0,1    // K0-- (Decrement DMA Count)
    bnez k0,{#}DMALOOP
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)
  {#}DMAEND:
}


macro DMACPUFIXDST0() { // DMA Transfer Mode 0: Fixed Destination, Transfer 1 Byte, I/O To CPU (xx)
  lw t8,0(t8)     // T8 = Load I/O $21XX Table Offset
  {#}DMALOOP:
    jalr gp,t8    // Run Load I/O $21XX Instruction
    nop           // Delay Slot
    lbu t6,0(t7)  // MEM_MAP[$21XX] = T6 (Delay Slot)
    sb t6,0(at)   // MEM_MAP[DMA Address] = T6
    subiu k0,1    // K0-- (Decrement DMA Count)
    bnez k0,{#}DMALOOP
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)
}

macro DMACPUFIXDST1() { // DMA Transfer Mode 1: Fixed Destination, Transfer 2 Bytes, I/O To CPU (XX, XX+1)
  {#}DMALOOP:
    lw t0,0(t8)   // T0 = Load I/O $21XX Table Offset
    jalr gp,t0    // Run Load I/O $21XX Instruction
    nop           // Delay Slot
    lbu t6,0(t7)  // T6 = MEM_MAP[$21XX]
    sb t6,0(at)   // MEM_MAP[DMA Address] = T6
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lw t0,4(t8)   // T0 = Load I/O $21XX Table Offset
    jalr gp,t0    // Run Load I/O $21XX Instruction
    nop           // Delay Slot
    lbu t6,1(t7)  // T6 = MEM_MAP[$21XX]
    sb t6,0(at)   // MEM_MAP[DMA Address] = T6
    subiu k0,1    // K0-- (Decrement DMA Count)
    bnez k0,{#}DMALOOP
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)
  {#}DMAEND:
}

macro DMACPUFIXDST2() { // DMA Transfer Mode 2: Fixed Destination, Transfer 2 Bytes, I/O To CPU (XX, XX)
  lw t8,0(t8)     // T8 = Load I/O $21XX Table Offset
  {#}DMALOOP:
    jalr gp,t8    // Run Load I/O $21XX Instruction
    nop           // Delay Slot
    lbu t6,0(t7)  // T6 = MEM_MAP[$21XX]
    sb t6,0(at)   // MEM_MAP[DMA Address] = T6
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    jalr gp,t8    // Run Load I/O $21XX Instruction
    nop           // Delay Slot
    lbu t6,0(t7)  // T6 = MEM_MAP[$21XX]
    sb t6,0(at)   // MEM_MAP[DMA Address] = T6
    subiu k0,1    // K0-- (Decrement DMA Count)
    bnez k0,{#}DMALOOP
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)
  {#}DMAEND:
}

macro DMACPUFIXDST3() { // DMA Transfer Mode 3: Fixed Destination, Transfer 4 Bytes, I/O To CPU (XX, XX, XX+1, XX+1)
  {#}DMALOOP:
    lw t0,0(t8)   // T0 = Load I/O $21XX Table Offset
    jalr gp,t0    // Run Load I/O $21XX Instruction
    nop           // Delay Slot
    lbu t6,0(t7)  // T6 = MEM_MAP[$21XX]
    sb t6,0(at)   // MEM_MAP[DMA Address] = T6
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lw t0,0(t8)   // T0 = Load I/O $21XX Table Offset
    jalr gp,t0    // Run Load I/O $21XX Instruction
    nop           // Delay Slot
    lbu t6,0(t7)  // T6 = MEM_MAP[$21XX]
    sb t6,0(at)   // MEM_MAP[DMA Address] = T6
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lw t0,4(t8)   // T0 = Load I/O $21XX Table Offset
    jalr gp,t0    // Run Load I/O $21XX Instruction
    nop           // Delay Slot
    lbu t6,1(t7)  // T6 = MEM_MAP[$21XX]
    sb t6,0(at)   // MEM_MAP[DMA Address] = T6
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lw t0,4(t8)   // T0 = Load I/O $21XX Table Offset
    jalr gp,t0    // Run Load I/O $21XX Instruction
    nop           // Delay Slot
    lbu t6,1(t7)  // T6 = MEM_MAP[$21XX]
    sb t6,0(at)   // MEM_MAP[DMA Address] = T6
    subiu k0,1    // K0-- (Decrement DMA Count)
    bnez k0,{#}DMALOOP
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)
  {#}DMAEND:
}

macro DMACPUFIXDST4() { // DMA Transfer Mode 4: Fixed Destination, Transfer 4 Bytes, I/O To CPU (XX, XX+1, XX+2, XX+3)
  {#}DMALOOP:
    lw t0,0(t8)   // T0 = Load I/O $21XX Table Offset
    jalr gp,t0    // Run Load I/O $21XX Instruction
    nop           // Delay Slot
    lbu t6,0(t7)  // T6 = MEM_MAP[$21XX]
    sb t6,0(at)   // MEM_MAP[DMA Address] = T6
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lw t0,4(t8)   // T0 = Load I/O $21XX Table Offset
    jalr gp,t0    // Run Load I/O $21XX Instruction
    nop           // Delay Slot
    lbu t6,1(t7)  // T6 = MEM_MAP[$21XX]
    sb t6,0(at)   // MEM_MAP[DMA Address] = T6
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lw t0,8(t8)   // T0 = Load I/O $21XX Table Offset
    jalr gp,t0    // Run Load I/O $21XX Instruction
    nop           // Delay Slot
    lbu t6,2(t7)  // T6 = MEM_MAP[$21XX]
    sb t6,0(at)   // MEM_MAP[DMA Address] = T6
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lw t0,12(t8)  // T0 = Load I/O $21XX Table Offset
    jalr gp,t0    // Run Load I/O $21XX Instruction
    nop           // Delay Slot
    lbu t6,3(t7)  // T6 = MEM_MAP[$21XX]
    sb t6,0(at)   // MEM_MAP[DMA Address] = T6
    subiu k0,1    // K0-- (Decrement DMA Count)
    bnez k0,{#}DMALOOP
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)
  {#}DMAEND:
}

macro DMACPUFIXDST5() { // DMA Transfer Mode 5: Fixed Destination, Transfer 4 Bytes, I/O To CPU (XX, XX+1, XX, XX+1)
  {#}DMALOOP:
    lw t0,0(t8)   // T0 = Load I/O $21XX Table Offset
    jalr gp,t0    // Run Load I/O $21XX Instruction
    nop           // Delay Slot
    lbu t6,0(t7)  // T6 = MEM_MAP[$21XX]
    sb t6,0(at)   // MEM_MAP[DMA Address] = T6
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lw t0,4(t8)   // T0 = Load I/O $21XX Table Offset
    jalr gp,t0    // Run Load I/O $21XX Instruction
    nop           // Delay Slot
    lbu t6,1(t7)  // T6 = MEM_MAP[$21XX]
    sb t6,0(at)   // MEM_MAP[DMA Address] = T6
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lw t0,0(t8)   // T0 = Load I/O $21XX Table Offset
    jalr gp,t0    // Run Load I/O $21XX Instruction
    nop           // Delay Slot
    lbu t6,0(t7)  // T6 = MEM_MAP[$21XX]
    sb t6,0(at)   // MEM_MAP[DMA Address] = T6
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lw t0,4(t8)   // T0 = Load I/O $21XX Table Offset
    jalr gp,t0    // Run Load I/O $21XX Instruction
    nop           // Delay Slot
    lbu t6,1(t7)  // T6 = MEM_MAP[$21XX]
    sb t6,0(at)   // MEM_MAP[DMA Address] = T6
    subiu k0,1    // K0-- (Decrement DMA Count)
    bnez k0,{#}DMALOOP
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)
  {#}DMAEND:
}


macro DMACPUINCDST0() { // DMA Transfer Mode 0: Increment Destination, Transfer 1 Byte, I/O To CPU (xx)
  lw t8,0(t8)     // T8 = Load I/O $21XX Table Offset
  {#}DMALOOP:
    jalr gp,t8    // Run Load I/O $21XX Instruction
    nop           // Delay Slot
    lbu t6,0(t7)  // T6 = MEM_MAP[$21XX]
    sb t6,0(at)   // MEM_MAP[DMA Address] = T6
    addiu at,1    // DMA Address++ (Increment Destination)
    subiu k0,1    // K0-- (Decrement DMA Count)
    bnez k0,{#}DMALOOP
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)
}

macro DMACPUINCDST1() { // DMA Transfer Mode 1: Increment Destination, Transfer 2 Bytes, I/O To CPU (XX, XX+1)
  {#}DMALOOP:
    lw t0,0(t8)   // T0 = Load I/O $21XX Table Offset
    jalr gp,t0    // Run Load I/O $21XX Instruction
    nop           // Delay Slot
    lbu t6,0(t7)  // T6 = MEM_MAP[$21XX]
    sb t6,0(at)   // MEM_MAP[DMA Address] = T6
    addiu at,1    // DMA Address++ (Increment Destination)
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lw t0,4(t8)   // T0 = Load I/O $21XX Table Offset
    jalr gp,t0    // Run Load I/O $21XX Instruction
    nop           // Delay Slot
    lbu t6,1(t7)  // T6 = MEM_MAP[$21XX]
    sb t6,0(at)   // MEM_MAP[DMA Address] = T6
    addiu at,1    // DMA Address++ (Increment Destination)
    subiu k0,1    // K0-- (Decrement DMA Count)
    bnez k0,{#}DMALOOP
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)
  {#}DMAEND:
}

macro DMACPUINCDST2() { // DMA Transfer Mode 2: Increment Destination, Transfer 2 Bytes, I/O To CPU (XX, XX)
  lw t8,0(t8)     // T8 = Load I/O $21XX Table Offset
  {#}DMALOOP:
    jalr gp,t8    // Run Load I/O $21XX Instruction
    nop           // Delay Slot
    lbu t6,0(t7)  // T6 = MEM_MAP[$21XX]
    sb t6,0(at)   // MEM_MAP[DMA Address] = T6
    addiu at,1    // DMA Address++ (Increment Destination)
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    jalr gp,t8    // Run Load I/O $21XX Instruction
    nop           // Delay Slot
    lbu t6,0(t7)  // T6 = MEM_MAP[$21XX]
    sb t6,0(at)   // MEM_MAP[DMA Address] = T6
    addiu at,1    // DMA Address++ (Increment Destination)
    subiu k0,1    // K0-- (Decrement DMA Count)
    bnez k0,{#}DMALOOP
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)
  {#}DMAEND:
}

macro DMACPUINCDST3() { // DMA Transfer Mode 3: Increment Destination, Transfer 4 Bytes, I/O To CPU (XX, XX, XX+1, XX+1)
  {#}DMALOOP:
    lw t0,0(t8)   // T0 = Load I/O $21XX Table Offset
    jalr gp,t0    // Run Load I/O $21XX Instruction
    nop           // Delay Slot
    lbu t6,0(t7)  // T6 = MEM_MAP[$21XX]
    sb t6,0(at)   // MEM_MAP[DMA Address] = T6
    addiu at,1    // DMA Address++ (Increment Destination)
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lw t0,0(t8)   // T0 = Load I/O $21XX Table Offset
    jalr gp,t0    // Run Load I/O $21XX Instruction
    nop           // Delay Slot
    lbu t6,0(t7)  // T6 = MEM_MAP[$21XX]
    sb t6,0(at)   // MEM_MAP[DMA Address] = T6
    addiu at,1    // DMA Address++ (Increment Destination)
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lw t0,4(t8)   // T0 = Load I/O $21XX Table Offset
    jalr gp,t0    // Run Load I/O $21XX Instruction
    nop           // Delay Slot
    lbu t6,1(t7)  // T6 = MEM_MAP[$21XX]
    sb t6,0(at)   // MEM_MAP[DMA Address] = T6
    addiu at,1    // DMA Address++ (Increment Destination)
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lw t0,4(t8)   // T0 = Load I/O $21XX Table Offset
    jalr gp,t0    // Run Load I/O $21XX Instruction
    nop           // Delay Slot
    lbu t6,1(t7)  // T6 = MEM_MAP[$21XX]
    sb t6,0(at)   // MEM_MAP[DMA Address] = T6
    addiu at,1    // DMA Address++ (Increment Destination)
    subiu k0,1    // K0-- (Decrement DMA Count)
    bnez k0,{#}DMALOOP
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)
  {#}DMAEND:
}

macro DMACPUINCDST4() { // DMA Transfer Mode 4: Increment Destination, Transfer 4 Bytes, I/O To CPU (XX, XX+1, XX+2, XX+3)
  {#}DMALOOP:
    lw t0,0(t8)   // T0 = Load I/O $21XX Table Offset
    jalr gp,t0    // Run Load I/O $21XX Instruction
    nop           // Delay Slot
    lbu t6,0(t7)  // T6 = MEM_MAP[$21XX]
    sb t6,0(at)   // MEM_MAP[DMA Address] = T6
    addiu at,1    // DMA Address++ (Increment Destination)
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lw t0,4(t8)   // T0 = Load I/O $21XX Table Offset
    jalr gp,t0    // Run Load I/O $21XX Instruction
    nop           // Delay Slot
    lbu t6,1(t7)  // T6 = MEM_MAP[$21XX]
    sb t6,0(at)   // MEM_MAP[DMA Address] = T6
    addiu at,1    // DMA Address++ (Increment Destination)
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lw t0,8(t8)   // T0 = Load I/O $21XX Table Offset
    jalr gp,t0    // Run Load I/O $21XX Instruction
    nop           // Delay Slot
    lbu t6,2(t7)  // T6 = MEM_MAP[$21XX]
    sb t6,0(at)   // MEM_MAP[DMA Address] = T6
    addiu at,1    // DMA Address++ (Increment Destination)
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lw t0,12(t8)  // T0 = Load I/O $21XX Table Offset
    jalr gp,t0    // Run Load I/O $21XX Instruction
    nop           // Delay Slot
    lbu t6,3(t7)  // T6 = MEM_MAP[$21XX]
    sb t6,0(at)   // MEM_MAP[DMA Address] = T6
    addiu at,1    // DMA Address++ (Increment Destination)
    subiu k0,1    // K0-- (Decrement DMA Count)
    bnez k0,{#}DMALOOP
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)
  {#}DMAEND:
}

macro DMACPUINCDST5() { // DMA Transfer Mode 5: Increment Destination, Transfer 4 Bytes, I/O To CPU (XX, XX+1, XX, XX+1)
  {#}DMALOOP:
    lw t0,0(t8)   // T0 = Load I/O $21XX Table Offset
    jalr gp,t0    // Run Load I/O $21XX Instruction
    nop           // Delay Slot
    lbu t6,0(t7)  // T6 = MEM_MAP[$21XX]
    sb t6,0(at)   // MEM_MAP[DMA Address] = T6
    addiu at,1    // DMA Address++ (Increment Destination)
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lw t0,4(t8)   // T0 = Load I/O $21XX Table Offset
    jalr gp,t0    // Run Load I/O $21XX Instruction
    nop           // Delay Slot
    lbu t6,1(t7)  // T6 = MEM_MAP[$21XX]
    sb t6,0(at)   // MEM_MAP[DMA Address] = T6
    addiu at,1    // DMA Address++ (Increment Destination)
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lw t0,0(t8)   // T0 = Load I/O $21XX Table Offset
    jalr gp,t0    // Run Load I/O $21XX Instruction
    nop           // Delay Slot
    lbu t6,0(t7)  // T6 = MEM_MAP[$21XX]
    sb t6,0(at)   // MEM_MAP[DMA Address] = T6
    addiu at,1    // DMA Address++ (Increment Destination)
    subiu k0,1    // K0-- (Decrement DMA Count)
    beqz k0,{#}DMAEND
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)

    lw t0,4(t8)   // T0 = Load I/O $21XX Table Offset
    jalr gp,t0    // Run Load I/O $21XX Instruction
    nop           // Delay Slot
    lbu t6,1(t7)  // T6 = MEM_MAP[$21XX]
    sb t6,0(at)   // MEM_MAP[DMA Address] = T6
    addiu at,1    // DMA Address++ (Increment Destination)
    subiu k0,1    // K0-- (Decrement DMA Count)
    bnez k0,{#}DMALOOP
    andi k0,$FFFF // K0 &= $FFFF (Delay Slot)
  {#}DMAEND:
}

DMAPXX:
// DMAPXX 0..7 Indirect Table
dw DMAPHEX00, DMAPHEX01, DMAPHEX02, DMAPHEX03, DMAPHEX04, DMAPHEX05, DMAPHEX02, DMAPHEX03, DMAPHEX08, DMAPHEX09, DMAPHEX0A, DMAPHEX0B, DMAPHEX0C, DMAPHEX0D, DMAPHEX0A, DMAPHEX0B
dw DMAPHEX10, DMAPHEX11, DMAPHEX12, DMAPHEX13, DMAPHEX14, DMAPHEX15, DMAPHEX12, DMAPHEX13, DMAPHEX08, DMAPHEX09, DMAPHEX0A, DMAPHEX0B, DMAPHEX0C, DMAPHEX0D, DMAPHEX0A, DMAPHEX0B
dw DMAPHEX00, DMAPHEX01, DMAPHEX02, DMAPHEX03, DMAPHEX04, DMAPHEX05, DMAPHEX02, DMAPHEX03, DMAPHEX08, DMAPHEX09, DMAPHEX0A, DMAPHEX0B, DMAPHEX0C, DMAPHEX0D, DMAPHEX0A, DMAPHEX0B
dw DMAPHEX10, DMAPHEX11, DMAPHEX12, DMAPHEX13, DMAPHEX14, DMAPHEX15, DMAPHEX12, DMAPHEX13, DMAPHEX08, DMAPHEX09, DMAPHEX0A, DMAPHEX0B, DMAPHEX0C, DMAPHEX0D, DMAPHEX0A, DMAPHEX0B
dw DMAPHEX00, DMAPHEX01, DMAPHEX02, DMAPHEX03, DMAPHEX04, DMAPHEX05, DMAPHEX02, DMAPHEX03, DMAPHEX08, DMAPHEX09, DMAPHEX0A, DMAPHEX0B, DMAPHEX0C, DMAPHEX0D, DMAPHEX0A, DMAPHEX0B
dw DMAPHEX10, DMAPHEX11, DMAPHEX12, DMAPHEX13, DMAPHEX14, DMAPHEX15, DMAPHEX12, DMAPHEX13, DMAPHEX08, DMAPHEX09, DMAPHEX0A, DMAPHEX0B, DMAPHEX0C, DMAPHEX0D, DMAPHEX0A, DMAPHEX0B
dw DMAPHEX00, DMAPHEX01, DMAPHEX02, DMAPHEX03, DMAPHEX04, DMAPHEX05, DMAPHEX02, DMAPHEX03, DMAPHEX08, DMAPHEX09, DMAPHEX0A, DMAPHEX0B, DMAPHEX0C, DMAPHEX0D, DMAPHEX0A, DMAPHEX0B
dw DMAPHEX10, DMAPHEX11, DMAPHEX12, DMAPHEX13, DMAPHEX14, DMAPHEX15, DMAPHEX12, DMAPHEX13, DMAPHEX08, DMAPHEX09, DMAPHEX0A, DMAPHEX0B, DMAPHEX0C, DMAPHEX0D, DMAPHEX0A, DMAPHEX0B
dw DMAPHEX80, DMAPHEX81, DMAPHEX82, DMAPHEX83, DMAPHEX84, DMAPHEX85, DMAPHEX82, DMAPHEX83, DMAPHEX88, DMAPHEX89, DMAPHEX8A, DMAPHEX8B, DMAPHEX8C, DMAPHEX8D, DMAPHEX8A, DMAPHEX8B
dw DMAPHEX90, DMAPHEX91, DMAPHEX92, DMAPHEX93, DMAPHEX94, DMAPHEX95, DMAPHEX92, DMAPHEX93, DMAPHEX88, DMAPHEX89, DMAPHEX8A, DMAPHEX8B, DMAPHEX8C, DMAPHEX8D, DMAPHEX8A, DMAPHEX8B
dw DMAPHEX80, DMAPHEX81, DMAPHEX82, DMAPHEX83, DMAPHEX84, DMAPHEX85, DMAPHEX82, DMAPHEX83, DMAPHEX88, DMAPHEX89, DMAPHEX8A, DMAPHEX8B, DMAPHEX8C, DMAPHEX8D, DMAPHEX8A, DMAPHEX8B
dw DMAPHEX90, DMAPHEX91, DMAPHEX92, DMAPHEX93, DMAPHEX94, DMAPHEX95, DMAPHEX92, DMAPHEX93, DMAPHEX88, DMAPHEX89, DMAPHEX8A, DMAPHEX8B, DMAPHEX8C, DMAPHEX8D, DMAPHEX8A, DMAPHEX8B
dw DMAPHEX80, DMAPHEX81, DMAPHEX82, DMAPHEX83, DMAPHEX84, DMAPHEX85, DMAPHEX82, DMAPHEX83, DMAPHEX88, DMAPHEX89, DMAPHEX8A, DMAPHEX8B, DMAPHEX8C, DMAPHEX8D, DMAPHEX8A, DMAPHEX8B
dw DMAPHEX90, DMAPHEX91, DMAPHEX92, DMAPHEX93, DMAPHEX94, DMAPHEX95, DMAPHEX92, DMAPHEX93, DMAPHEX88, DMAPHEX89, DMAPHEX8A, DMAPHEX8B, DMAPHEX8C, DMAPHEX8D, DMAPHEX8A, DMAPHEX8B
dw DMAPHEX80, DMAPHEX81, DMAPHEX82, DMAPHEX83, DMAPHEX84, DMAPHEX85, DMAPHEX82, DMAPHEX83, DMAPHEX88, DMAPHEX89, DMAPHEX8A, DMAPHEX8B, DMAPHEX8C, DMAPHEX8D, DMAPHEX8A, DMAPHEX8B
dw DMAPHEX90, DMAPHEX91, DMAPHEX92, DMAPHEX93, DMAPHEX94, DMAPHEX95, DMAPHEX92, DMAPHEX93, DMAPHEX88, DMAPHEX89, DMAPHEX8A, DMAPHEX8B, DMAPHEX8C, DMAPHEX8D, DMAPHEX8A, DMAPHEX8B

include "DMAPXX.asm" // DMAPXX 0..7 Table