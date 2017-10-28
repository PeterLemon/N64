// MI Interrupt Masks:
constant MI_INTR_SP($01) // SP Interrupt Bit
constant MI_INTR_SI($02) // SI Interrupt Bit
constant MI_INTR_AI($04) // AI Interrupt Bit
constant MI_INTR_VI($08) // VI Interrupt Bit
constant MI_INTR_PI($10) // PI Interrupt Bit
constant MI_INTR_DP($20) // DP Interrupt Bit
constant MI_MASK_SP($01) // SP Mask Bit
constant MI_MASK_SI($02) // SI Mask Bit
constant MI_MASK_AI($04) // AI Mask Bit
constant MI_MASK_VI($08) // VI Mask Bit
constant MI_MASK_PI($10) // PI Mask Bit
constant MI_MASK_DP($20) // DP Mask Bit
constant MI_MASK_CLR_SP($0001) // Clear SP Mask
constant MI_MASK_SET_SP($0002) // Set SP Mask
constant MI_MASK_CLR_SI($0004) // Clear SI Mask
constant MI_MASK_SET_SI($0008) // Set SI Mask
constant MI_MASK_CLR_AI($0010) // Clear AI Mask
constant MI_MASK_SET_AI($0020) // Set AI Mask
constant MI_MASK_CLR_VI($0040) // Clear VI Mask
constant MI_MASK_SET_VI($0080) // Set VI Mask
constant MI_MASK_CLR_PI($0100) // Clear PI Mask
constant MI_MASK_SET_PI($0200) // Set PI Mask
constant MI_MASK_CLR_DP($0400) // Clear DP Mask
constant MI_MASK_SET_DP($0800) // Set DP Mask 
constant PI_CLEAR_INTERRUPT(1 << 1) // Bit To Set, To Clear PI Interrupt

// COP0 registers:
constant Index($00)
constant Random($01)
constant EntryLo0($02)
constant EntryLo1($03)
constant Context($04)
constant PageMask($05)
constant Wired($06)
//constant *RESERVED*($07)
constant BadVAddr($08)
constant Count($09)
constant EntryHi($0A)
constant Compare($0B)
constant Status($0C)
constant Cause($0D)
constant EPC($0E)
constant PRevID($0F)
constant Config($10)
constant LLAddr($11)
constant WatchLo($12)
constant WatchHi($13)
constant XContext($14)
//constant *RESERVED*($15)
//constant *RESERVED*($16)
//constant *RESERVED*($17)
//constant *RESERVED*($18)
//constant *RESERVED*($19)
constant PErr($1A)
constant CacheErr($1B)
constant TagLo($1C)
constant TagHi($1D)
constant ErrorEPC($1E)
//constant *RESERVED*($1F)

macro DISABLE_INTERRUPTS() { // Disable Interrupts In VR4300
  mfc0 t0,Status // T0 = COP 0 Status Register
  srl t0,1 // T0 >>= 1 (Clear Enable Interrupts Bit)
  sll t0,1 // T0 <<= 1
  mtc0 t0,Status // COP 0 Status Register = T0
}

macro ENABLE_INTERRUPTS() { // Enable Interrupts In VR4300
  mfc0 t0,Status // T0 = COP 0 Status Register
  ori t0,1 // T0 |= 1 (Set Enable Interrupts Bit)
  mtc0 t0,Status // COP 0 Status Register = T0
}

macro MI_SET_INTR_MASK(mask) { // Set Interrupt Mask In MI
  lui a0,MI_BASE // A0 = MI_BASE ($A4300000)
  ori t0,r0,{mask} // T0 = Interrupt Mask
  sw t0,MI_INTR_MASK(a0) // WORD[$A430000C] MI_INTR_MASK = Interrupt Mask
}

macro INSTALL_INTERRUPT_HANDLER(addr) { // Installs An Interrupt Handler
  la a0,$3C1A0000|({addr}>>16) // A0 = Interrupt Address HI
  la a1,$A0000180 // A1 = Processor Vector Offset
  sw a0,0(a1) // Store Interrupt Address Hi To Processor Vector Offset ($A0000180)
  la a0,$375A0000|({addr}&$FFFF) // A0 = Interrupt Address Lo
  sw a0,4(a1) // Store Interrupt Address Lo To Processor Vector Offset ($A0000184)
  la a0,$03400008
  sw a0,8(a1) // Store To Processor Vector Offset ($A0000188)
  la a0,$401A6800
  sw a0,12(a1) // Store To Processor Vector Offset ($A000018C)
}