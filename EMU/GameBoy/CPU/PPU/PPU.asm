//------------
// PPU Macros
//------------
macro PPU8x8BGMAP2BPP() { // Convert GB 2BPP Tile Map To RDP List
  la a0,MEM_MAP+BG1_RAM  // A0 = BG1_RAM (Tile Map Address)
  la a1,N64TILE // A1 = N64TILE (Tile Data Address)
  la a2,$A0000000|((RDPGBTILE2BPP+12)&$3FFFFFF) // A2 = N64 RDP GB Tile Map Address
  la a3,MEM_MAP+SCX_REG // A3 = SCX_REG
  lbu t0,0(a3)   // T0 = SCX_REG Byte
  andi k0,t0,7   // K0 = BGXHOFS & 7
  srl t0,3       // T0 = BGXHOFS >> 3
  la a3,MEM_MAP+SCY_REG // A3 = SCY_REG
  lbu t1,0(a3)   // T1 = SCY_REG Byte
  andi k1,t1,7   // K1 = BGXVOFS & 7
  srl t1,3       // T1 = BGXVOFS >> 3
  ori t2,r0,20   // T2 = 20 (SCREENMAPX)
  ori t3,r0,18   // T3 = 18 (SCREENMAPY)
  ori t4,r0,64   // T4 = 64

  ori t5,r0,0    // T5 = 0 (Y)
  {#}PPU8x8BGMAP2BPPLoopY:
    ori t6,r0,0  // T6 = 0 (X)
    {#}PPU8x8BGMAP2BPPLoopX:
      addu t7,t5,t1  // BGTILE = BGMAP[(((Y+(BGXVOFS>>3))&$1F)<<5) + ((X+(BGXHOFS>>3))&$1F)])
      andi a3,t7,$1F // A3 = T7 & $1F
      sll t7,a3,5    // T7 = (((Y+(BGXVOFS>>3))&$1F)<<5)

      addu a3,t6,t0
      andi gp,a3,$1F // GP = A3 & $1F
      addu t7,gp     // T7 = (((Y+(BGXVOFS>>3))&$1F)<<5) + ((X+(BGXHOFS>>3))&$1F)

      addu t7,a0
      lbu t7,0(t7)   // T7 = GB Tile Map # Byte

      // BG Tile Map
      sll t7,5      // T7 *= 32 (2BPP/4BPP)
      addu t7,a1    // T7 += N64 Tile Address
      sw t7,0(a2)   // Store GB Tile Map # To N64 RDP GB Tile Map

      ori t7,r0,88  // XLYL = $25000000 + (((88-(BGXHOFS&7))+(X<<3))<<14) + (((56-(BGXVOFS&7))+(Y<<3))<<2)
      subu t7,k0
      sll a3,t6,3
      addu t7,a3
      sll t7,14
      lui a3,$2500
      or t7,a3      // T7 = $25000000 + (((88-(BGXHOFS&7))+(X<<3))<<14)
      ori a3,r0,56
      subu a3,k1
      sll gp,t5,3
      addu a3,gp
      sll a3,2
      addu t7,a3    // T7 = $25000000 + (((88-(BGXHOFS&7))+(X<<3))<<14) + (((56-(BGXVOFS&7))+(Y<<3))<<2)
      sw t7,12(a2)

      ori t7,r0,80  // XHYH = (((80-(BGXHOFS&7))+(X<<3))<<14) + (((48-(BGXVOFS&7))+(Y<<3))<<2)
      subu t7,k0
      sll a3,t6,3
      addu t7,a3
      sll t7,14     // T7 = (((80-(BGXHOFS&7))+(X<<3))<<14)
      ori a3,r0,48
      subu a3,k1
      sll gp,t5,3
      addu a3,gp
      sll a3,2
      addu t7,a3    // T7 = (((80-(BGXHOFS&7))+(X<<3))<<14) + (((48-(BGXVOFS&7))+(Y<<3))<<2)
      sw t7,16(a2)

      addiu a2,40   // A2 += 40
      bne t6,t2,{#}PPU8x8BGMAP2BPPLoopX // IF (X != SCREENMAPX) Map Loop X
      addiu t6,1 // Increment X (Delay Slot)
      bne t5,t3,{#}PPU8x8BGMAP2BPPLoopY // IF (Y != SCREENMAPY) Map Loop Y
      addiu t5,1 // Increment Y (Delay Slot)
}


// Flush Data Cache: Index Writeback Invalidate
la a0,$80000000    // A0 = Cache Start
la a1,$80002000-16 // A1 = Cache End
LoopCache:
  cache $0|1,0(a0) // Data Cache: Index Writeback Invalidate
  bne a0,a1,LoopCache
  addiu a0,16 // Address += Data Line Size (Delay Slot)


// Convert GameBoy Palette To N64 TLUT
la a0,MEM_MAP+BGP_REG // A0 = GameBoy Palette Address
lbu t0,0(a0) // T0 = GameBoy Palette Byte
la a0,$A0000000|(N64TLUT&$3FFFFFF) // A0 = N64 TLUT Address

andi t1,t0,3 // BGP Color 0 (PAL&3)
xori t1,3    // Invert Bits
sll t1,9     // Shift Color To Green
ori t1,1     // Add Alpha Bit
sh t1,0(a0)  // Store Color 0

andi t1,t0,12 // BGP Color 1 ((PAL&12)>>2)
xori t1,12    // Invert Bits
sll t1,7      // Shift Color To Green
ori t1,1      // Add Alpha Bit
sh t1,2(a0)   // Store Color 1

andi t1,t0,48 // BGP Color 2 ((PAL&48)>>4)
xori t1,48    // Invert Bits
sll t1,5      // Shift Color To Green
ori t1,1      // Add Alpha Bit
sh t1,4(a0)   // Store Color 2

andi t1,t0,192 // BGP Color 3 ((PAL&192)>>6))
xori t1,192    // Invert Bits
sll t1,3       // Shift Color To Green
ori t1,1       // Add Alpha Bit
sh t1,6(a0)    // Store Color 3


WaitScanline($1D0) // Wait For Scanline To Reach Vertical Blank

// Run RDP Palette & Screen Setup
DPC(RDPINITBuffer, RDPINITBufferEnd) // Run DPC Command Buffer: Start Address, End Address


PPU8x8BGMAP2BPP() // Convert GB 2BPP 8x8 BG Tile Map To RDP List
DPC(RDPBG2BPPBuffer, RDPBG2BPPBufferEnd) // Run DPC Command Buffer: Start Address, End Address


PPUEND:

  // Wait For RSP To Compute
  lui a0,SP_BASE // A0 = SP Base Register ($A4040000)
  lw t0,SP_STATUS(a0) // T0 = RSP Status
  andi t0,RSP_HLT // RSP Status &= RSP Halt Flag
  beqz t0,SkipRSP // IF (RSP Halt Flag == 0) Skip RSP
  nop // Delay Slot

  // Convert GB 2BPP 8x8 Tiles To N64 Linear Textures
  // Load RSP Code To IMEM
  DMASPRD(RSPTILEXBPPCode, RSPTILEXBPPCodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  lui a0,SP_BASE // A0 = SP Base Register ($A4040000)
  TILEXBPPCodeDMABusy:
    lw t0,SP_STATUS(a0) // T0 = Word From SP Status Register ($A4040010)
    andi t0,$C // AND RSP Status Status With $C (Bit 2 = DMA Is Busy, Bit 3 = DMA Is Full)
    bnez t0,TILEXBPPCodeDMABusy // IF TRUE DMA Is Busy
    nop // Delay Slot

  // Set RSP Program Counter
  lui a0,SP_PC_BASE // A0 = SP PC Base Register ($A4080000)
  ori t0,r0,RSPTILEXBPPStart // T0 = RSP Program Counter Set To Start Of RSP Code
  sw t0,SP_PC(a0) // Store RSP Program Counter To SP PC Register ($A4080000)

  // Set RSP Status (Start Execution)
  lui a0,SP_BASE // A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB // T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) // Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  SkipRSP: