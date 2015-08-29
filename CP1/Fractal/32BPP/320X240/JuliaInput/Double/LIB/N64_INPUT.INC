//===========
// N64 Input
//===========
constant JOY_CRIGHT($1)   // PIF HWORD: CAMERA RIGHT
constant JOY_CLEFT($2)    // PIF HWORD: CAMERA LEFT
constant JOY_CDOWN($4)    // PIF HWORD: CAMERA DOWN
constant JOY_CUP($8)      // PIF HWORD: CAMERA UP
constant JOY_R($10)       // PIF HWORD: R (PAN RIGHT)
constant JOY_L($20)       // PIF HWORD: L (PAN LEFT)
constant JOY_RIGHT($100)  // PIF HWORD: RIGHT
constant JOY_LEFT($200)   // PIF HWORD: LEFT
constant JOY_DOWN($400)   // PIF HWORD: DOWN
constant JOY_UP($800)     // PIF HWORD: UP
constant JOY_START($1000) // PIF HWORD: START
constant JOY_Z($2000)     // PIF HWORD: Z
constant JOY_B($4000)     // PIF HWORD: B
constant JOY_A($8000)     // PIF HWORD: A

macro InitController(PIF) {
  lui a0,SI_BASE // A0 = SI Base Register ($A4800000)
  la a1,{PIF} // A1 = PIF1 Offset
  sw a1,SI_DRAM_ADDR(a0) // Store PIF1 To SI_DRAM_ADDR ($A4800000)
  la a1,(PIF_BASE<<16)|PIF_RAM // A1 = PIF_RAM: JoyChannel ($BFC007C0)
  sw a1,SI_PIF_ADDR_WR64B(a0) // 64 Byte Write DRAM -> PIF ($A4800010)
}

macro ReadController(PIF) {
  lui a0,PIF_BASE // A0 = PIF Base Register ($BFC00000)
  lui a1,SI_BASE // A1 = SI Base Register ($A4800000)
  la a2,{PIF} // A2 = PIF2 Offset
  sw a2,SI_DRAM_ADDR(a1) // Store PIF2 To SI_DRAM_ADDR ($A4800000)
  ori a2,a0,PIF_RAM // A2 = PIF_RAM: JoyChannel ($BFC007C0)
  sw a2,SI_PIF_ADDR_RD64B(a1) // 64 Byte Read PIF -> DRAM ($A4800004)
  lhu t0,PIF_HWORD(a0) // T0 = Buttons ($BFC007C4)
  lb t1,PIF_XBYTE(a0) // T1 = Analog X ($BFC007C6)
  lb t2,PIF_YBYTE(a0) // T2 = Analog Y ($BFC007C7)
}