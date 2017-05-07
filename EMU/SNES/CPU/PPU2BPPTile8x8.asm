la a0,$80000000    // A0 = Cache Start
la a1,$80002000-32 // A1 = Cache End
LoopCache:
  cache $C|1,0(a0) // Data Cache: Create Dirty Exclusive
  bne a0,a1,LoopCache
  addiu a0,16 // Address += Data Line Size (Delay Slot)

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

  lli t0,$800 // Wait For RSP To Compute
DelayPAL:
  bnez t0,DelayPAL
  subi t0,1


// Convert SNES Tiles To N64 Linear Texture
  // Load RSP Code To IMEM
  DMASPRD(RSPTILECode, RSPTILECodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  lui a0,SP_BASE // A0 = SP Base Register ($A4040000)
  TILECodeDMABusy:
    lw t0,SP_STATUS(a0) // T0 = Word From SP Status Register ($A4040010)
    andi t0,$C // AND RSP Status Status With $C (Bit 2 = DMA Is Busy, Bit 3 = DMA Is Full)
    bnez t0,TILECodeDMABusy // IF TRUE DMA Is Busy
    nop // Delay Slot

  // Set RSP Program Counter
  lui a0,SP_PC_BASE // A0 = SP PC Base Register ($A4080000)
  lli t0,RSPTILEStart // T0 = RSP Program Counter Set To Start Of RSP Code
  sw t0,SP_PC(a0) // Store RSP Program Counter To SP PC Register ($A4080000)

  // Set RSP Status (Start Execution)
  lui a0,SP_BASE // A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB // T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) // Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  li t0,$22000 // Wait For RSP To Compute
DelayTILES:
  bnez t0,DelayTILES
  subi t0,1


// Convert SNES Tile Map To RDP List
la a0,VRAM+$F800 // A0 = SNES Tile Map Address
la a1,$A0000000|((RDPSNESTILE+12)&$3FFFFFF) // A1 = N64 RDP SNES Tile Map Address
la a2,N64TILE // A2 = N64 Tile Address
lli t0,895 // T0 = Number Of Tiles To Convert
MAPLoop:
  lbu t1,0(a0) // T1 = SNES Tile Map # Lo Byte
  lbu t2,1(a0) // T2 = SNES Tile Map # Hi Byte
  addiu a0,2   // A0 += 2
  sll t2,8     // T2 <<= 8
  or t1,t2     // T1 != T2 
  sll t1,5     // T1 *= 32
  addu t1,a2   // T1 += N64 Tile Address
  sw t1,0(a1)  // Store SNES Tile Map # To N64 RDP SNES Tile Map
  addiu a1,40  // A1 += 40
  bnez t0,MAPLoop // IF (Number Of Tiles To Convert != 0) Map Loop
  subiu t0,1 // Decrement Number Of Tiles To Convert (Delay Slot)

WaitScanline($200) // Wait For Scanline To Reach Vertical Blank

DPC(RDPBuffer, RDPBufferEnd) // Run DPC Command Buffer: Start Address, End Address

