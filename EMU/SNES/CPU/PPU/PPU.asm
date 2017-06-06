// Convert SNES Palette To N64 TLUT
  // Load RSP Code To IMEM
  DMASPRD(RSPPALCode, RSPPALCodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  lui a0,SP_BASE // A0 = SP Base Register ($A4040000)
  PALCodeDMABusy:
    lw t0,SP_STATUS(a0) // T0 = Word From SP Status Register ($A4040010)
    andi t0,$C // AND RSP Status Status With $C (Bit 2 = DMA Is Busy, Bit 3 = DMA Is Full)
    bnez t0,PALCodeDMABusy // IF TRUE DMA Is Busy
    nop // Delay Slot

  // Set RSP Program Counter
  lui a0,SP_PC_BASE // A0 = SP PC Base Register ($A4080000)
  lli t0,RSPPALStart // T0 = RSP Program Counter Set To Start Of RSP Code
  sw t0,SP_PC(a0) // Store RSP Program Counter To SP PC Register ($A4080000)

  // Set RSP Status (Start Execution)
  lui a0,SP_BASE // A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB // T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) // Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

DelayPAL: // Wait For RSP To Compute
  lw t0,SP_STATUS(a0) // T0 = RSP Status
  andi t0,RSP_HLT // RSP Status &= RSP Halt Flag
  beqz t0,DelayPAL // IF (RSP Halt Flag == 0) Delay PAL
  nop // Delay Slot


// Copy SNES Clear Color To RDP List
la a0,N64TLUT // A0 = N64 TLUT Address
la a1,RDPSNESCLEARCOL+4 // A1 = N64 RDP SNES Clear Color Address
lhu t0,0(a0) // T0 = TLUT Color 0
sh t0,0(a1) // Store Color 0 To RDP Fill Color Hi
sh t0,2(a1) // Store Color 0 To RDP Fill Color Lo


// Convert SNES 2BPP Tiles To N64 Linear Texture
  // Load RSP Code To IMEM
  DMASPRD(RSPTILE2BPPCode, RSPTILE2BPPCodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  lui a0,SP_BASE // A0 = SP Base Register ($A4040000)
  TILE2BPPCodeDMABusy:
    lw t0,SP_STATUS(a0) // T0 = Word From SP Status Register ($A4040010)
    andi t0,$C // AND RSP Status Status With $C (Bit 2 = DMA Is Busy, Bit 3 = DMA Is Full)
    bnez t0,TILE2BPPCodeDMABusy // IF TRUE DMA Is Busy
    nop // Delay Slot

  // Set RSP Program Counter
  lui a0,SP_PC_BASE // A0 = SP PC Base Register ($A4080000)
  lli t0,RSPTILE2BPPStart // T0 = RSP Program Counter Set To Start Of RSP Code
  sw t0,SP_PC(a0) // Store RSP Program Counter To SP PC Register ($A4080000)

  // Set RSP Status (Start Execution)
  lui a0,SP_BASE // A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB // T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) // Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

// Convert SNES 2BPP Tile Map To RDP List
la a0,VRAM+$F800 // A0 = SNES Tile Map Address
la a1,$A0000000|((RDPSNESTILE2BPP+12)&$3FFFFFF) // A1 = N64 RDP SNES Tile Map Address
la a2,N64TILE2BPP // A2 = N64 Tile Address
lli t0,895 // T0 = Number Of Tiles To Convert
MAP2BPPLoop:
  lbu t1,0(a0) // T1 = SNES Tile Map # Lo Byte
  lbu t2,1(a0) // T2 = SNES Tile Map # Hi Byte
  addiu a0,2   // A0 += 2
  sll t2,8     // T2 <<= 8
  or t1,t2     // T1 |= T2 
  sll t1,5     // T1 *= 32 (2BPP/4BPP)
  addu t1,a2   // T1 += N64 Tile Address
  sw t1,0(a1)  // Store SNES Tile Map # To N64 RDP SNES Tile Map
  addiu a1,40  // A1 += 40
  bnez t0,MAP2BPPLoop // IF (Number Of Tiles To Convert != 0) Map Loop
  subiu t0,1 // Decrement Number Of Tiles To Convert (Delay Slot)

lui a0,SP_BASE // A0 = SP Base Register ($A4040000)
DelayTILES2BPP: // Wait For RSP To Compute
  lw t0,SP_STATUS(a0) // T0 = RSP Status
  andi t0,RSP_HLT // RSP Status &= RSP Halt Flag
  beqz t0,DelayTILES2BPP // IF (RSP Halt Flag == 0) Delay TILES
  nop // Delay Slot


// Convert SNES 4BPP Tiles To N64 Linear Texture
  // Load RSP Code To IMEM
  DMASPRD(RSPTILE4BPPCode, RSPTILE4BPPCodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  lui a0,SP_BASE // A0 = SP Base Register ($A4040000)
  TILE4BPPCodeDMABusy:
    lw t0,SP_STATUS(a0) // T0 = Word From SP Status Register ($A4040010)
    andi t0,$C // AND RSP Status Status With $C (Bit 2 = DMA Is Busy, Bit 3 = DMA Is Full)
    bnez t0,TILE4BPPCodeDMABusy // IF TRUE DMA Is Busy
    nop // Delay Slot

  // Set RSP Program Counter
  lui a0,SP_PC_BASE // A0 = SP PC Base Register ($A4080000)
  lli t0,RSPTILE4BPPStart // T0 = RSP Program Counter Set To Start Of RSP Code
  sw t0,SP_PC(a0) // Store RSP Program Counter To SP PC Register ($A4080000)

  // Set RSP Status (Start Execution)
  lui a0,SP_BASE // A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB // T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) // Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

// Convert SNES 4BPP Tile Map To RDP List
la a0,VRAM+$F800 // A0 = SNES Tile Map Address
la a1,$A0000000|((RDPSNESTILE4BPP+12)&$3FFFFFF) // A1 = N64 RDP SNES Tile Map Address
la a2,N64TILE4BPP // A2 = N64 Tile Address
lli t0,895 // T0 = Number Of Tiles To Convert
MAP4BPPLoop:
  lbu t1,0(a0) // T1 = SNES Tile Map # Lo Byte
  lbu t2,1(a0) // T2 = SNES Tile Map # Hi Byte
  addiu a0,2   // A0 += 2
  sll t2,8     // T2 <<= 8
  or t1,t2     // T1 |= T2 
  sll t1,5     // T1 *= 32 (2BPP/4BPP)
  addu t1,a2   // T1 += N64 Tile Address
  sw t1,0(a1)  // Store SNES Tile Map # To N64 RDP SNES Tile Map
  addiu a1,40  // A1 += 40
  bnez t0,MAP4BPPLoop // IF (Number Of Tiles To Convert != 0) Map Loop
  subiu t0,1 // Decrement Number Of Tiles To Convert (Delay Slot)

lui a0,SP_BASE // A0 = SP Base Register ($A4040000)
DelayTILES4BPP: // Wait For RSP To Compute
  lw t0,SP_STATUS(a0) // T0 = RSP Status
  andi t0,RSP_HLT // RSP Status &= RSP Halt Flag
  beqz t0,DelayTILES4BPP // IF (RSP Halt Flag == 0) Delay TILES
  nop // Delay Slot


// Convert SNES 8BPP Tiles To N64 Linear Texture
  // Load RSP Code To IMEM
  DMASPRD(RSPTILE8BPPCode, RSPTILE8BPPCodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  lui a0,SP_BASE // A0 = SP Base Register ($A4040000)
  TILE8BPPCodeDMABusy:
    lw t0,SP_STATUS(a0) // T0 = Word From SP Status Register ($A4040010)
    andi t0,$C // AND RSP Status Status With $C (Bit 2 = DMA Is Busy, Bit 3 = DMA Is Full)
    bnez t0,TILE8BPPCodeDMABusy // IF TRUE DMA Is Busy
    nop // Delay Slot

  // Set RSP Program Counter
  lui a0,SP_PC_BASE // A0 = SP PC Base Register ($A4080000)
  lli t0,RSPTILE8BPPStart // T0 = RSP Program Counter Set To Start Of RSP Code
  sw t0,SP_PC(a0) // Store RSP Program Counter To SP PC Register ($A4080000)

  // Set RSP Status (Start Execution)
  lui a0,SP_BASE // A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB // T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) // Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

// Convert SNES 8BPP Tile Map To RDP List
la a0,VRAM+$F800 // A0 = SNES Tile Map Address
la a1,$A0000000|((RDPSNESTILE8BPP+12)&$3FFFFFF) // A1 = N64 RDP SNES Tile Map Address
la a2,N64TILE8BPP // A2 = N64 Tile Address
lli t0,895 // T0 = Number Of Tiles To Convert
MAP8BPPLoop:
  lbu t1,0(a0) // T1 = SNES Tile Map # Lo Byte
  lbu t2,1(a0) // T2 = SNES Tile Map # Hi Byte
  addiu a0,2   // A0 += 2
  sll t2,8     // T2 <<= 8
  or t1,t2     // T1 |= T2 
  sll t1,6     // T1 *= 64 (8BPP)
  addu t1,a2   // T1 += N64 Tile Address
  sw t1,0(a1)  // Store SNES Tile Map # To N64 RDP SNES Tile Map
  addiu a1,40  // A1 += 40
  bnez t0,MAP8BPPLoop // IF (Number Of Tiles To Convert != 0) Map Loop
  subiu t0,1 // Decrement Number Of Tiles To Convert (Delay Slot)

lui a0,SP_BASE // A0 = SP Base Register ($A4040000)
DelayTILES8BPP: // Wait For RSP To Compute
  lw t0,SP_STATUS(a0) // T0 = RSP Status
  andi t0,RSP_HLT // RSP Status &= RSP Halt Flag
  beqz t0,DelayTILES8BPP // IF (RSP Halt Flag == 0) Delay TILES
  nop // Delay Slot


WaitScanline($200) // Wait For Scanline To Reach Vertical Blank

DPC(RDPPALBuffer, RDPPALBufferEnd) // Run DPC Command Buffer: Start Address, End Address

lui a0,DPC_BASE // A0 = DP Command (DPC) Base Register ($A4100000)
WaitRDPPAL: // Wait For RDP To Finish
  lw t0,DPC_STATUS(a0) // T0 = RDP Status
  andi t0,$100 // RDP Status &= RDP DMA Busy Flag
  bnez t0,WaitRDPPAL // IF (RDP DMA Busy Flag != 0) Delay TILES
  nop // Delay Slot

DPC(RDPBG2BPPBuffer, RDPBG2BPPBufferEnd) // Run DPC Command Buffer: Start Address, End Address
//DPC(RDPBG4BPPBuffer, RDPBG4BPPBufferEnd) // Run DPC Command Buffer: Start Address, End Address
//DPC(RDPBG8BPPBuffer, RDPBG8BPPBufferEnd) // Run DPC Command Buffer: Start Address, End Address