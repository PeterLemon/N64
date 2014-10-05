;===========
; N64 Input
;===========
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
  lui a0,SI_BASE ; A0 = SI Base Register ($A4800000)
  la a1,PIF ; A1 = PIF1 Offset
  sw a1,SI_DRAM_ADDR(a0) ; Store PIF1 To SI_DRAM_ADDR ($A4800000)
  la a1,((PIF_BASE<<16)|PIF_RAM) ; A1 = PIF_RAM: JoyChannel ($BFC007C0)
  sw a1,SI_PIF_ADDR_WR64B(a0) ; 64 Byte Write DRAM -> PIF ($A4800010)
  endm

ReadController: macro PIF
  lui a0,PIF_BASE ; A0 = PIF Base Register ($BFC00000)
  lui a1,SI_BASE ; A1 = SI Base Register ($A4800000)
  la a2,PIF ; A2 = PIF2 Offset
  sw a2,SI_DRAM_ADDR(a1) ; Store PIF2 To SI_DRAM_ADDR ($A4800000)
  ori a2,a0,PIF_RAM ; A2 = PIF_RAM: JoyChannel ($BFC007C0)
  sw a2,SI_PIF_ADDR_RD64B(a1) ; 64 Byte Read PIF -> DRAM ($A4800004)
  lhu t0,PIF_HWORD(a0) ; T0 = Buttons ($BFC007C4)
  lb t1,PIF_XBYTE(a0) ; T1 = Analog X ($BFC007C6)
  lb t2,PIF_YBYTE(a0) ; T2 = Analog Y ($BFC007C7)
  endm