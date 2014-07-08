JOY_CRIGHT: equ    $1 ; PIF HWORD: CAMERA RIGHT
JOY_CLEFT:  equ    $2 ; PIF HWORD: CAMERA LEFT
JOY_CDOWN:  equ    $4 ; PIF HWORD: CAMERA DOWN
JOY_CUP:    equ    $8 ; PIF HWORD: CAMERA UP
JOY_R:      equ   $10 ; PIF HWORD: R (PAN RIGHT)
JOY_L:      equ   $20 ; PIF HWORD: L (PAN LEFT)
JOY_RIGHT:  equ  $100 ; PIF HWORD: RIGHT
JOY_LEFT:   equ  $200 ; PIF HWORD: LEFT
JOY_DOWN:   equ  $400 ; PIF HWORD: DOWN
JOY_UP:     equ  $800 ; PIF HWORD: UP
JOY_START:  equ $1000 ; PIF HWORD: START
JOY_Z:      equ $2000 ; PIF HWORD: Z
JOY_B:      equ $4000 ; PIF HWORD: B
JOY_A:      equ $8000 ; PIF HWORD: A

InitController: macro PIF
  lui s0,SI_BASE ; S0 = $A4800000 (SI_BASE)
  la t1,PIF ; T1 = PIF1 Offset
  sw t1,SI_DRAM_ADDR(s0) ; Store PIF1 To SI_DRAM_ADDR
  la t1,((PIF_BASE<<16)|PIF_RAM) ; T1 = $BFC007C0 (PIF_RAM: JoyChannel)
  sw t1,SI_PIF_ADDR_WR64B(s0) ; 64 Byte Write DRAM -> PIF
  endm

ReadController: macro PIF
  lui s0,PIF_BASE ; S0 = $BFC00000 (PIF_BASE)
  lui s1,SI_BASE ; S1 = $A4800000 (SI_BASE)
  la t0,PIF ; T0 = PIF2 Offset
  sw t0,SI_DRAM_ADDR(S1) ; Store PIF2 To SI_DRAM_ADDR
  ori t0,s0,PIF_RAM ; T0 = $BFC007C0 (PIF_RAM: JoyChannel)
  sw t0,SI_PIF_ADDR_RD64B(S1) ; 64 Byte Read PIF -> DRAM
  lhu t0,PIF_HWORD(S0) ; T0 = Buttons ($BFC007C4)
  lb t1,PIF_XBYTE(S0) ; T1 = Analog X ($BFC007C6)
  lb t2,PIF_YBYTE(S0) ; T2 = Analog Y ($BFC007C7)
  endm