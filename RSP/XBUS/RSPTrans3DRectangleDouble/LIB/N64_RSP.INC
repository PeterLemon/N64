//==============================
// N64 Reality Signal Processor
//==============================
// RSP MIPS 4000 CPU Registers R0..R31
// RSP CP2 128-Bit Vector Registers: V0..V31
// RSP CP2 Vector Elements (128-Bit Vector = 16 Elements): E0..E15

// RSP CP0 Control Registers (MTF0/MTC0):
constant c0(0)   // RSP CP0 Control Register 00: I/DMEM Address For DMA (RW) ($04040000)
constant c1(1)   // RSP CP0 Control Register 01:   DRAM Address For DMA (RW) ($04040004)
constant c2(2)   // RSP CP0 Control Register 02: DMA READ  Length (DRAM -> I/DMEM) (RW) ($04040008)
constant c3(3)   // RSP CP0 Control Register 03: DMA WRITE Length (DRAM <- I/DMEM) (RW) ($0404000C)
constant c4(4)   // RSP CP0 Control Register 04: RSP Status (RW) ($04040010)
constant c5(5)   // RSP CP0 Control Register 05: DMA Full (R) ($04040014)
constant c6(6)   // RSP CP0 Control Register 06: DMA Busy (R) ($04040018)
constant c7(7)   // RSP CP0 Control Register 07: CPU-RSP Semaphore (RW) ($0404001C)
constant c8(8)   // RSP CP0 Control Register 08: RDP Command Buffer START (RW) ($04100000)
constant c9(9)   // RSP CP0 Control Register 09: RDP Command Buffer END (RW) ($04100004)
constant c10(10) // RSP CP0 Control Register 10: RDP Command Buffer CURRENT (R) ($04100008)
constant c11(11) // RSP CP0 Control Register 11: RDP Status (RW) ($0410000C)
constant c12(12) // RSP CP0 Control Register 12: RDP Clock Counter (R) ($04100010)
constant c13(13) // RSP CP0 Control Register 13: RDP Command Buffer BUSY (R) ($04100014)
constant c14(14) // RSP CP0 Control Register 14: RDP Pipe BUSY (R) ($04100018)
constant c15(15) // RSP CP0 Control Register 15: RDP TMEM BUSY (R) ($0410001C)

// RSP CP2 Control Registers (CFC2/CTC2):
constant vco(0) // RSP CP2 Control Register 0: Vector Carry Out
constant vcc(1) // RSP CP2 Control Register 1: Vector Compare Code
constant vce(2) // RSP CP2 Control Register 2: Vector Compare Extension

// SP Status Read Flags:
constant RSP_HLT($0001) // SP_STATUS: Halt (Bit 0)
constant RSP_BRK($0002) // SP_STATUS: Break (Bit 1)
constant RSP_BSY($0004) // SP_STATUS: DMA Busy (Bit 2)
constant RSP_FUL($0008) // SP_STATUS: DMA Full (Bit 3)
constant RSP_IOF($0010) // SP_STATUS: IO Full (Bit 4)
constant RSP_STP($0020) // SP_STATUS: Single Step (Bit 5)
constant RSP_IOB($0040) // SP_STATUS: Interrupt On Break (Bit 6)
constant RSP_SG0($0080) // SP_STATUS: Signal 0 Set (Bit 7)
constant RSP_SG1($0100) // SP_STATUS: Signal 1 Set (Bit 8)
constant RSP_SG2($0200) // SP_STATUS: Signal 2 Set (Bit 9)
constant RSP_SG3($0400) // SP_STATUS: Signal 3 Set (Bit 10)
constant RSP_SG4($0800) // SP_STATUS: Signal 4 Set (Bit 11)
constant RSP_SG5($1000) // SP_STATUS: Signal 5 Set (Bit 12)
constant RSP_SG6($2000) // SP_STATUS: Signal 6 Set (Bit 13)
constant RSP_SG7($4000) // SP_STATUS: Signal 7 Set (Bit 14)

// SP Status Write Flags:
constant CLR_HLT($0000001) // SP_STATUS: Clear Halt (Bit 0)
constant SET_HLT($0000002) // SP_STATUS: Set Halt (Bit 1)
constant CLR_BRK($0000004) // SP_STATUS: Clear Broke (Bit 2)
constant CLR_INT($0000008) // SP_STATUS: Clear Interrupt (Bit 3)
constant SET_INT($0000010) // SP_STATUS: Set Interrupt (Bit 4)
constant CLR_STP($0000020) // SP_STATUS: Clear Single Step (Bit 5)
constant SET_STP($0000040) // SP_STATUS: Set Single Step (Bit 6)
constant CLR_IOB($0000080) // SP_STATUS: Clear Interrupt On Break (Bit 7)
constant SET_IOB($0000100) // SP_STATUS: Set Interrupt On Break (Bit 8)
constant CLR_SG0($0000200) // SP_STATUS: Clear Signal 0 (Bit 9)
constant SET_SG0($0000400) // SP_STATUS: Set Signal 0 (Bit 10)
constant CLR_SG1($0000800) // SP_STATUS: Clear Signal 1 (Bit 11)
constant SET_SG1($0001000) // SP_STATUS: Set Signal 1 (Bit 12)
constant CLR_SG2($0002000) // SP_STATUS: Clear Signal 2 (Bit 13)
constant SET_SG2($0004000) // SP_STATUS: Set Signal 2 (Bit 14)
constant CLR_SG3($0008000) // SP_STATUS: Clear Signal 3 (Bit 15)
constant SET_SG3($0010000) // SP_STATUS: Set Signal 3 (Bit 16)
constant CLR_SG4($0020000) // SP_STATUS: Clear Signal 4 (Bit 17)
constant SET_SG4($0040000) // SP_STATUS: Set Signal 4 (Bit 18)
constant CLR_SG5($0080000) // SP_STATUS: Clear Signal 5 (Bit 19)
constant SET_SG5($0100000) // SP_STATUS: Set Signal 5 (Bit 20)
constant CLR_SG6($0200000) // SP_STATUS: Clear Signal 6 (Bit 21)
constant SET_SG6($0400000) // SP_STATUS: Set Signal 6 (Bit 22)
constant CLR_SG7($0800000) // SP_STATUS: Clear Signal 7 (Bit 23)
constant SET_SG7($1000000) // SP_STATUS: Set Signal 7 (Bit 24)

// CPU DMA
macro DMASPRD(start, end, dest) { // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  lui a0,SP_BASE // A0 = SP Base Register ($A4040000)
  lui t0,SP_MEM_BASE // T0 = SP Memory Base Register ($A4000000)
  ori t0,{dest}&$1FFF // T0 = SP Memory Address Offset ($A4000000..$A4001FFF 8KB)
  sw t0,SP_MEM_ADDR(a0) // Store Memory Offset To SP Memory Address Register ($A4040000)
  la t0,{start}&$7FFFFFF // T0 = Aligned DRAM Physical RAM Offset ($00000000..$007FFFFF 8MB)
  sw t0,SP_DRAM_ADDR(a0) // Store RAM Offset To SP DRAM Address Register ($A4040004)
  la t0,({end}-{start})-1 // T0 = Length Of DMA Transfer In Bytes - 1
  sw t0,SP_RD_LEN(a0) // Store DMA Length To SP Read Length Register ($A4040008)
}

macro DMASPWR(start, end, source) { // DMA Data Write RSP MEM->DRAM: Start Address, End Address, Source RSP MEM Address
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  lui t0,SP_MEM_BASE ; T0 = SP Memory Base Register ($A4000000)
  ori t0,{source}&$1FFF ; T0 = SP Memory Address Offset ($A4000000..$A4001FFF 8KB)
  sw t0,SP_MEM_ADDR(a0) ; Store Memory Offset To SP Memory Address Register ($A4040000)
  la t0,{start}&$7FFFFFF ; T0 = Aligned DRAM Physical RAM Offset ($00000000..$007FFFFF 8MB)
  sw t0,SP_DRAM_ADDR(a0) ; Store RAM Offset To SP DRAM Address Register ($A4040004)
  la t0,({end}-{start})-1 ; T0 = Length Of DMA Transfer In Bytes - 1
  sw t0,SP_WR_LEN(a0) ; Store DMA Length To SP Write Length Register ($A404000C)
}

// RSP DMA
macro RSPDMASPRD(start, end, dest) { // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  li a0,{dest}&$1FFF // A0 = SP Memory Address Offset ($A4000000..$A4001FFF 8KB)
  mtc0 a0,c0 // Store Memory Offset To SP Memory Address Register ($A4040000)
  la a0,{start}&$7FFFFFF // A0 = Aligned DRAM Physical RAM Offset ($00000000..$007FFFFF 8MB)
  mtc0 a0,c1 // Store RAM Offset To SP DRAM Address Register ($A4040004)
  la a0,({end}-{start})-1 // A0 = Length Of DMA Transfer In Bytes - 1
  mtc0 a0,c2 // Store DMA Length To SP Read Length Register ($A4040008)
}

macro RSPDMASPWR(start, end, source) { // DMA Data Write RSP MEM->DRAM: Start Address, End Address, Source RSP MEM Address
  li a0,{source}&$1FFF // A0 = SP Memory Address Offset ($A4000000..$A4001FFF 8KB)
  mtc0 a0,c0 // Store Memory Offset To SP Memory Address Register ($A4040000)
  la a0,{start}&$7FFFFFF // A0 = Aligned DRAM Physical RAM Offset ($00000000..$007FFFFF 8MB)
  mtc0 a0,c1 // Store RAM Offset To SP DRAM Address Register ($A4040004)
  la a0,({end}-{start})-1 // A0 = Length Of DMA Transfer In Bytes - 1
  mtc0 a0,c3 // Store DMA Length To SP Write Length Register ($A404000C)
}

macro RSPDPC(start, end) { // Run DPC Command Buffer: Start Address, End Address
  la a0,{start} // A0 = DPC Command Start Address
  mtc0 a0,c8 // Store DPC Command Start Address To DP Start Register ($A4100000)
  addi a0,{end}-{start} // A0 = DPC Command End Address
  mtc0 a0,c9 // Store DPC Command End Address To DP End Register ($A4100004)
}

// RSP CP2 Vector Operation Matrix Instructions (COP2):
// VMULF: vd, vs, vt, element ; Vector Multiply Signed Fractions: VMULF VD,VS,VT[ELEMENT]
// VMULU: vd, vs, vt, element ; Vector Multiply Unsigned Fractions: VMULU VD,VS,VT[ELEMENT]
// VRNDP: vd, vs, vt, element ; Vector DCT Round Positive: VRNDP VD,VS,VT[ELEMENT] (Reserved: MPEG DCT Rounding)
// VMULQ: vd, vs, vt, element ; Vector Multiply Integer: VMULQ VD,VS,VT[ELEMENT] (Reserved: MPEG Inverse Quantization)
// VMUDL: vd, vs, vt, element ; Vector Multiply  Low Partial Products: VMUDL VD,VS,VT[ELEMENT]
// VMUDM: vd, vs, vt, element ; Vector Multiply  Mid Partial Products: VMUDM VD,VS,VT[ELEMENT]
// VMUDN: vd, vs, vt, element ; Vector Multiply  Mid Partial Products: VMUDN VD,VS,VT[ELEMENT]
// VMUDH: vd, vs, vt, element ; Vector Multiply High Partial Products: VMUDH VD,VS,VT[ELEMENT]
// VMACF: vd, vs, vt, element ; Vector Multiply Accumulate Signed Fractions: VMACF VD,VS,VT[ELEMENT]
// VMACU: vd, vs, vt, element ; Vector Multiply Accumulate Unsigned Fractions: VMACU VD,VS,VT[ELEMENT]
// VRNDN: vd, vs, vt, element ; Vector DCT Round Negative: VRNDN VD,VS,VT[ELEMENT] (Reserved: MPEG DCT Rounding)
// VMACQ: vd, vs, vt, element ; Vector Multiply Accumulate Integer: VMACQ VD,VS,VT[ELEMENT] (Reserved: MPEG Inverse Quantization)
// VMADL: vd, vs, vt, element ; Vector Multiply Accumulate  Low Partial Products: VMADL VD,VS,VT[ELEMENT]
// VMADM: vd, vs, vt, element ; Vector Multiply Accumulate  Mid Partial Products: VMADM VD,VS,VT[ELEMENT]
// VMADN: vd, vs, vt, element ; Vector Multiply Accumulate  Mid Partial Products: VMADN VD,VS,VT[ELEMENT]
// VMADH: vd, vs, vt, element ; Vector Multiply Accumulate High Partial Products: VMADH VD,VS,VT[ELEMENT]
// VADD:  vd, vs, vt, element ; Vector Add Short Elements: VADD VD,VS,VT[ELEMENT]
// VSUB:  vd, vs, vt, element ; Vector Subtract Short Elements: VSUB VD,VS,VT[ELEMENT]
// VSUT:  vd, vs, vt, element ; Vector Subtract Short Elements (VT-VS): VSUT VD,VS,VT[ELEMENT] (Reserved)
// VABS:  vd, vs, vt, element ; Vector Absolute Value Of Short Elements: VABS VD,VS,VT[ELEMENT]
// VADDC: vd, vs, vt, element ; Vector Add Short Elements With Carry: VADDC VD,VS,VT[ELEMENT]
// VSUBC: vd, vs, vt, element ; Vector Subtract Short Elements With Carry: VSUBC VD,VS,VT[ELEMENT]
// VADDB: vd, vs, vt, element ; Vector Add Byte Elements: VADDB VD,VS,VT[ELEMENT] (Reserved)
// VSUBB: vd, vs, vt, element ; Vector Subtract Byte Elements: VSUBB VD,VS,VT[ELEMENT] (Reserved)
// VACCB: vd, vs, vt, element ; Vector Add Byte Elements With Carry: VACCB VD,VS,VT[ELEMENT] (Reserved)
// VSUCB: vd, vs, vt, element ; Vector Subtract Byte Elements With Carry: VSUCB VD,VS,VT[ELEMENT] (Reserved)
// VSAD:  vd, vs, vt, element ; Vector SAD: VSAD VD,VS,VT[ELEMENT] (Reserved)
// VSAC:  vd, vs, vt, element ; Vector SAC: VSAC VD,VS,VT[ELEMENT] (Reserved)
// VSUM:  vd, vs, vt, element ; Vector SUM: VSUM VD,VS,VT[ELEMENT] (Reserved)
// VSAR:  vd, vs, vt, element ; Vector Accumulator Read: VSAR VD,VS,VT[ELEMENT]
// VACC:  vd, vs, vt, element ; Vector Add Elements With Carry: VACC VD,VS,VT[ELEMENT] (Reserved)
// VSUC:  vd, vs, vt, element ; Vector Subtract Elements With Carry: VSUC VD,VS,VT[ELEMENT] (Reserved)
// VLT:   vd, vs, vt, element ; Vector Select Less Than: VLT VD,VS,VT[ELEMENT]
// VEQ:   vd, vs, vt, element ; Vector Select Equal: VEQ VD,VS,VT[ELEMENT]
// VNE:   vd, vs, vt, element ; Vector Select Not Equal: VNE VD,VS,VT[ELEMENT]
// VGE:   vd, vs, vt, element ; Vector Select Greater Than Or Equal: VGE VD,VS,VT[ELEMENT]
// VCL:   vd, vs, vt, element ; Vector Select Clip Test Low: VCL VD,VS,VT[ELEMENT]
// VCH:   vd, vs, vt, element ; Vector Select Clip Test High: VCH VD,VS,VT[ELEMENT]
// VCR:   vd, vs, vt, element ; Vector Select Crimp Test Low: VCR VD,VS,VT[ELEMENT]
// VMRG:  vd, vs, vt, element ; Vector Select Merge: VMRG VD,VS,VT[ELEMENT]
// VAND:  vd, vs, vt, element ; Vector Logical AND Short Elements: VAND VD,VS,VT[ELEMENT]
// VNAND: vd, vs, vt, element ; Vector Logical NOT AND Short Elements: VNAND VD,VS,VT[ELEMENT]
// VOR:   vd, vs, vt, element ; Vector Logical OR Short Elements: VOR VD,VS,VT[ELEMENT]
// VNOR:  vd, vs, vt, element ; Vector Logical NOT OR Short Elements: VNOR VD,VS,VT[ELEMENT]
// VXOR:  vd, vs, vt, element ; Vector Logical Exclusive OR Short Elements: VXOR VD,VS,VT[ELEMENT]
// VNXOR: vd, vs, vt, element ; Vector Logical NOT Exclusive OR Short Elements: VNXOR VD,VS,VT[ELEMENT]
// V056:  vd, vs, vt, element ; Vector Row 5 Column 6: V056 VD,VS,VT[ELEMENT] (Reserved)
// V057:  vd, vs, vt, element ; Vector Row 5 Column 7: V057 VD,VS,VT[ELEMENT] (Reserved)
// VRCP:  vd, vs, vt, element ; Vector Element Scalar Reciprocal (Single Precision): VRCP VD,VS,VT[ELEMENT]
// VRCPL: vd, vs, vt, element ; Vector Element Scalar Reciprocal Low: VRCPL VD,VS,VT[ELEMENT]
// VRCPH: vd, vs, vt, element ; Vector Element Scalar Reciprocal High: VRCPH VD,VS,VT[ELEMENT]
// VMOV:  vd, vs, vt, element ; Vector Element Scalar Move: VMOV VD,VS,VT[ELEMENT]
// VRSQ:  vd, vs, vt, element ; Vector Element Scalar SQRT Reciprocal (Single Precision): VRSQ VD,VS,VT[ELEMENT]
// VRSQL: vd, vs, vt, element ; Vector Element Scalar SQRT Reciprocal Low: VRSQL VD,VS,VT[ELEMENT]
// VRSQH: vd, vs, vt, element ; Vector Element Scalar SQRT Reciprocal High: VRSQH VD,VS,VT[ELEMENT]
// VNOP:  vd, vs, vt, element ; Vector Null Instruction: VNOP VD,VS,VT[ELEMENT]
// VEXTT: vd, vs, vt, element ; Vector Extract Triple (5/5/5/1): VEXTT VD,VS,VT[ELEMENT] (Reserved)
// VEXTQ: vd, vs, vt, element ; Vector Extract Quad (4/4/4/4): VEXTQ VD,VS,VT[ELEMENT] (Reserved)
// VEXTN: vd, vs, vt, element ; Vector Extract Nibble (4/4/4/4) (Sign Extended): VEXTN VD,VS,VT[ELEMENT] (Reserved)
// V073:  vd, vs, vt, element ; Vector Row 7 Column 3: V073 VD,VS,VT[ELEMENT] (Reserved)
// VINST: vd, vs, vt, element ; Vector Insert Triple (5/5/5/1): VINST VD,VS,VT[ELEMENT] (Reserved)
// VINSQ: vd, vs, vt, element ; Vector Insert Quad (4/4/4/4): VINSQ VD,VS,VT[ELEMENT] (Reserved)
// VINSN: vd, vs, vt, element ; Vector Insert Nibble (4/4/4/4) (Sign Extended): VINSN VD,VS,VT[ELEMENT] (Reserved)
// VNULL: vd, vs, vt, element ; Vector Null Instruction: VNULL VD,VS,VT[ELEMENT] (Reserved)

// RSP CP2 Vector Load Instructions (LWC2):
// LBV:  vt, element, offset, base ; Load Byte To Vector: LBV VT[ELEMENT],$OFFSET(BASE)
// LSV:  vt, element, offset, base ; Load Short To Vector: LSV VT[ELEMENT],$OFFSET(BASE)
// LLV:  vt, element, offset, base ; Load Long To Vector: LLV VT[ELEMENT],$OFFSET(BASE)
// LDV:  vt, element, offset, base ; Load Double To Vector: LDV VT[ELEMENT],$OFFSET(BASE)
// LQV:  vt, element, offset, base ; Load Quad To Vector: LQV VT[ELEMENT],$OFFSET(BASE)
// LRV:  vt, element, offset, base ; Load Rest To Vector: LRV VT[ELEMENT],$OFFSET(BASE)
// LPV:  vt, element, offset, base ; Load Packed Signed To Vector: LPV VT[ELEMENT],$OFFSET(BASE)
// LUV:  vt, element, offset, base ; Load Packed Unsigned To Vector: LUV VT[ELEMENT],$OFFSET(BASE)
// LHV:  vt, element, offset, base ; Load Half Bytes To Vector: LHV VT[ELEMENT],$OFFSET(BASE)
// LFV:  vt, element, offset, base ; Load Fourth Bytes To Vector: LFV VT[ELEMENT],$OFFSET(BASE)
// LTWV: vt, element, offset, base ; Load Transposed Wrapped Bytes To Vector: LTWV VT[ELEMENT],$OFFSET(BASE) (Reserved)
// LTV:  vt, element, offset, base ; Load Transposed Bytes To Vector: LTV VT[ELEMENT],$OFFSET(BASE)

// RSP CP2 Vector Store Instructions (SWC2):
// SBV: vt, element, offset, base ; Store Byte From Vector: SBV VT[ELEMENT],$OFFSET(BASE)
// SSV: vt, element, offset, base ; Store Short From Vector: SSV VT[ELEMENT],$OFFSET(BASE)
// SLV: vt, element, offset, base ; Store Long From Vector: SLV VT[ELEMENT],$OFFSET(BASE)
// SDV: vt, element, offset, base ; Store Double From Vector: SDV VT[ELEMENT],$OFFSET(BASE)
// SQV: vt, element, offset, base ; Store Quad From Vector: SQV VT[ELEMENT],$OFFSET(BASE)
// SRV: vt, element, offset, base ; Store Rest From Vector: SRV VT[ELEMENT],$OFFSET(BASE)
// SPV: vt, element, offset, base ; Store Packed Signed From Vector: SPV VT[ELEMENT],$OFFSET(BASE)
// SUV: vt, element, offset, base ; Store Packed Unsigned From Vector: SUV VT[ELEMENT],$OFFSET(BASE)
// SHV: vt, element, offset, base ; Store Half Bytes From Vector: SHV VT[ELEMENT],$OFFSET(BASE)
// SFV: vt, element, offset, base ; Store Fourth Bytes From Vector: SFV VT[ELEMENT],$OFFSET(BASE)
// SWV: vt, element, offset, base ; Store Transposed Wrapped Bytes From Vector: SWV VT[ELEMENT],$OFFSET(BASE)
// STV: vt, element, offset, base ; Store Transposed Bytes From Vector: STV VT[ELEMENT],$OFFSET(BASE)