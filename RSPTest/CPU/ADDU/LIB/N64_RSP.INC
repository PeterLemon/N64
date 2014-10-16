;==============================
; N64 Reality Signal Processor
;==============================
; RSP CP2 128-Bit Vector Registers:
V00: equ 00
V01: equ 01
V02: equ 02
V03: equ 03
V04: equ 04
V05: equ 05
V06: equ 06
V07: equ 07
V08: equ 08
V09: equ 09
V10: equ 10
V11: equ 11
V12: equ 12
V13: equ 13
V14: equ 14
V15: equ 15
V16: equ 16
V17: equ 17
V18: equ 18
V19: equ 19
V20: equ 20
V21: equ 21
V22: equ 22
V23: equ 23
V24: equ 24
V25: equ 25
V26: equ 26
V27: equ 27
V28: equ 28
V29: equ 29
V30: equ 30
V31: equ 31

; RSP CP2 Vector Elements (128-Bit Vector = 16 Elements):
E0:  equ 00
E1:  equ 01
E2:  equ 02
E3:  equ 03
E4:  equ 04
E5:  equ 05
E6:  equ 06
E7:  equ 07
E8:  equ 08
E9:  equ 09
E10: equ 10
E11: equ 11
E12: equ 12
E13: equ 13
E14: equ 14
E15: equ 15

; RSP CP2 Control Registers (CFC2/CTC2):
VC0: equr 0
VCC: equr 1
VCE: equr 2

; SP Status Read Flags:
RSP_HLT: equ $0001 ; SP_STATUS: Halt (Bit 0)
RSP_BRK: equ $0002 ; SP_STATUS: Break (Bit 1)
RSP_BSY: equ $0004 ; SP_STATUS: DMA Busy (Bit 2)
RSP_FUL: equ $0008 ; SP_STATUS: DMA Full (Bit 3)
RSP_IOF: equ $0010 ; SP_STATUS: IO Full (Bit 4)
RSP_STP: equ $0020 ; SP_STATUS: Single Step (Bit 5)
RSP_IOB: equ $0040 ; SP_STATUS: Interrupt On Break (Bit 6)
RSP_SG0: equ $0080 ; SP_STATUS: Signal 0 Set (Bit 7)
RSP_SG1: equ $0100 ; SP_STATUS: Signal 1 Set (Bit 8)
RSP_SG2: equ $0200 ; SP_STATUS: Signal 2 Set (Bit 9)
RSP_SG3: equ $0400 ; SP_STATUS: Signal 3 Set (Bit 10)
RSP_SG4: equ $0800 ; SP_STATUS: Signal 4 Set (Bit 11)
RSP_SG5: equ $1000 ; SP_STATUS: Signal 5 Set (Bit 12)
RSP_SG6: equ $2000 ; SP_STATUS: Signal 6 Set (Bit 13)
RSP_SG7: equ $4000 ; SP_STATUS: Signal 7 Set (Bit 14)

; SP Status Write Flags:
CLR_HLT: equ $0000001 ; SP_STATUS: Clear Halt (Bit 0)
SET_HLT: equ $0000002 ; SP_STATUS: Set Halt (Bit 1)
CLR_BRK: equ $0000004 ; SP_STATUS: Clear Broke (Bit 2)
CLR_INT: equ $0000008 ; SP_STATUS: Clear Interrupt (Bit 3)
SET_INT: equ $0000010 ; SP_STATUS: Set Interrupt (Bit 4)
CLR_STP: equ $0000020 ; SP_STATUS: Clear Single Step (Bit 5)
SET_STP: equ $0000040 ; SP_STATUS: Set Single Step (Bit 6)
CLR_IOB: equ $0000080 ; SP_STATUS: Clear Interrupt On Break (Bit 7)
SET_IOB: equ $0000100 ; SP_STATUS: Set Interrupt On Break (Bit 8)
CLR_SG0: equ $0000200 ; SP_STATUS: Clear Signal 0 (Bit 9)
SET_SG0: equ $0000400 ; SP_STATUS: Set Signal 0 (Bit 10)
CLR_SG1: equ $0000800 ; SP_STATUS: Clear Signal 1 (Bit 11)
SET_SG1: equ $0001000 ; SP_STATUS: Set Signal 1 (Bit 12)
CLR_SG2: equ $0002000 ; SP_STATUS: Clear Signal 2 (Bit 13)
SET_SG2: equ $0004000 ; SP_STATUS: Set Signal 2 (Bit 14)
CLR_SG3: equ $0008000 ; SP_STATUS: Clear Signal 3 (Bit 15)
SET_SG3: equ $0010000 ; SP_STATUS: Set Signal 3 (Bit 16)
CLR_SG4: equ $0020000 ; SP_STATUS: Clear Signal 4 (Bit 17)
SET_SG4: equ $0040000 ; SP_STATUS: Set Signal 4 (Bit 18)
CLR_SG5: equ $0080000 ; SP_STATUS: Clear Signal 5 (Bit 19)
SET_SG5: equ $0100000 ; SP_STATUS: Set Signal 5 (Bit 20)
CLR_SG6: equ $0200000 ; SP_STATUS: Clear Signal 6 (Bit 21)
SET_SG6: equ $0400000 ; SP_STATUS: Set Signal 6 (Bit 22)
CLR_SG7: equ $0800000 ; SP_STATUS: Clear Signal 7 (Bit 23)
SET_SG7: equ $1000000 ; SP_STATUS: Set Signal 7 (Bit 24)

DMASPRD: macro start, end, dest ; DMA Data Read MEM->RSP DRAM: Start Address, End Address, Destination RSP DRAM Address
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  lui t0,SP_MEM_BASE ; T0 = SP Memory Base Register ($A4000000)
  ori t0,dest&$1FFF ; T0 = SP Memory Address Offset ($A4000000..$A4001FFF 8KB)
  sw t0,SP_MEM_ADDR(a0) ; Store Memory Offset To SP Memory Address Register ($A4040000)
  la t0,start&$7FFFFFF ; T0 = Aligned DRAM Physical RAM Offset ($00000000..$007FFFFF 8MB)
  sw t0,SP_DRAM_ADDR(a0) ; Store RAM Offset To SP DRAM Address Register ($A4040004)
  la t0,(end-start)-1 ; T0 = Length Of DMA Transfer In Bytes - 1
  sw t0,SP_RD_LEN(a0) ; Store DMA Length To SP Read Length Register ($A4040008)
  endm

DMASPWR: macro start, end, source ; DMA Data Write RSP RAM->MEM: Start Address, End Address, Source RSP DRAM Address
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  lui t0,SP_MEM_BASE ; T0 = SP Memory Base Register ($A4000000)
  ori t0,source&$1FFF ; T0 = SP Memory Address Offset ($A4000000..$A4001FFF 8KB)
  sw t0,SP_MEM_ADDR(a0) ; Store Memory Offset To SP Memory Address Register ($A4040000)
  la t0,start&$7FFFFFF ; T0 = Aligned DRAM Physical RAM Offset ($00000000..$007FFFFF 8MB)
  sw t0,SP_DRAM_ADDR(a0) ; Store RAM Offset To SP DRAM Address Register ($A4040004)
  la t0,(end-start)-1 ; T0 = Length Of DMA Transfer In Bytes - 1
  sw t0,SP_WR_LEN(a0) ; Store DMA Length To SP Write Length Register ($A404000C)
  endm

; RSP CP2 Vector Operation Matrix Instructions (COP2):
VMULF: macro vd, vs, vt, element ; Vector Multiply Signed Fractions: VMULF VD,VS,VT[ELEMENT]
; Word: Element (0..15), Source Vector 2 (0..31), Source Vector 1 (0..31), Destination Vector (0..31)
  dw $4A000000|(element<<21)|(vt<<16)|(vs<<11)|(vd<<6)|$00 ; Word: COP2 $48 (Bit 26..31), Function Bit 1 (Bit 25), Element (Bit 21..25), Source Vector 2 (Bit 16..20), Source Vector 1 (Bit 11..15), Destination Vector (Bit 6..10), VMULF $00 (Bit 0..5)
  endm
VMULU: macro vd, vs, vt, element ; Vector Multiply Unsigned Fractions: VMULU VD,VS,VT[ELEMENT]
; Word: Element (0..15), Source Vector 2 (0..31), Source Vector 1 (0..31), Destination Vector (0..31)
  dw $4A000000|(element<<21)|(vt<<16)|(vs<<11)|(vd<<6)|$01 ; Word: COP2 $48 (Bit 26..31), Function Bit 1 (Bit 25), Element (Bit 21..25), Source Vector 2 (Bit 16..20), Source Vector 1 (Bit 11..15), Destination Vector (Bit 6..10), VMULU $01 (Bit 0..5)
  endm
VRNDP: macro vd, vs, vt, element ; Vector DCT Round Positive: VRNDP VD,VS,VT[ELEMENT] (Reserved: MPEG DCT Rounding)
; Word: Element (0..15), Source Vector 2 (0..31), Source Vector 1 (0..31), Destination Vector (0..31)
  dw $4A000000|(element<<21)|(vt<<16)|(vs<<11)|(vd<<6)|$02 ; Word: COP2 $48 (Bit 26..31), Function Bit 1 (Bit 25), Element (Bit 21..25), Source Vector 2 (Bit 16..20), Source Vector 1 (Bit 11..15), Destination Vector (Bit 6..10), VRNDP $02 (Bit 0..5)
  endm
VMULQ: macro vd, vs, vt, element ; Vector Multiply Integer: VMULQ VD,VS,VT[ELEMENT] (Reserved: MPEG Inverse Quantization)
; Word: Element (0..15), Source Vector 2 (0..31), Source Vector 1 (0..31), Destination Vector (0..31)
  dw $4A000000|(element<<21)|(vt<<16)|(vs<<11)|(vd<<6)|$03 ; Word: COP2 $48 (Bit 26..31), Function Bit 1 (Bit 25), Element (Bit 21..25), Source Vector 2 (Bit 16..20), Source Vector 1 (Bit 11..15), Destination Vector (Bit 6..10), VMULQ $03 (Bit 0..5)
  endm
VMUDL: macro vd, vs, vt, element ; Vector Multiply Low Partial Products: VMUDL VD,VS,VT[ELEMENT]
; Word: Element (0..15), Source Vector 2 (0..31), Source Vector 1 (0..31), Destination Vector (0..31)
  dw $4A000000|(element<<21)|(vt<<16)|(vs<<11)|(vd<<6)|$04 ; Word: COP2 $48 (Bit 26..31), Function Bit 1 (Bit 25), Element (Bit 21..25), Source Vector 2 (Bit 16..20), Source Vector 1 (Bit 11..15), Destination Vector (Bit 6..10), VMUDL $04 (Bit 0..5)
  endm
VMUDM: macro vd, vs, vt, element ; Vector Multiply Mid Partial Products: VMUDM VD,VS,VT[ELEMENT]
; Word: Element (0..15), Source Vector 2 (0..31), Source Vector 1 (0..31), Destination Vector (0..31)
  dw $4A000000|(element<<21)|(vt<<16)|(vs<<11)|(vd<<6)|$05 ; Word: COP2 $48 (Bit 26..31), Function Bit 1 (Bit 25), Element (Bit 21..25), Source Vector 2 (Bit 16..20), Source Vector 1 (Bit 11..15), Destination Vector (Bit 6..10), VMUDM $05 (Bit 0..5)
  endm
VMUDN: macro vd, vs, vt, element ; Vector Multiply Mid Partial Products: VMUDN VD,VS,VT[ELEMENT]
; Word: Element (0..15), Source Vector 2 (0..31), Source Vector 1 (0..31), Destination Vector (0..31)
  dw $4A000000|(element<<21)|(vt<<16)|(vs<<11)|(vd<<6)|$06 ; Word: COP2 $48 (Bit 26..31), Function Bit 1 (Bit 25), Element (Bit 21..25), Source Vector 2 (Bit 16..20), Source Vector 1 (Bit 11..15), Destination Vector (Bit 6..10), VMUDN $06 (Bit 0..5)
  endm
VMUDH: macro vd, vs, vt, element ; Vector Multiply High Partial Products: VMUDH VD,VS,VT[ELEMENT]
; Word: Element (0..15), Source Vector 2 (0..31), Source Vector 1 (0..31), Destination Vector (0..31)
  dw $4A000000|(element<<21)|(vt<<16)|(vs<<11)|(vd<<6)|$07 ; Word: COP2 $48 (Bit 26..31), Function Bit 1 (Bit 25), Element (Bit 21..25), Source Vector 2 (Bit 16..20), Source Vector 1 (Bit 11..15), Destination Vector (Bit 6..10), VMUDH $07 (Bit 0..5)
  endm
VMACF: macro vd, vs, vt, element ; Vector Multiply Accumulate Signed Fractions: VMACF VD,VS,VT[ELEMENT]
; Word: Element (0..15), Source Vector 2 (0..31), Source Vector 1 (0..31), Destination Vector (0..31)
  dw $4A000000|(element<<21)|(vt<<16)|(vs<<11)|(vd<<6)|$08 ; Word: COP2 $48 (Bit 26..31), Function Bit 1 (Bit 25), Element (Bit 21..25), Source Vector 2 (Bit 16..20), Source Vector 1 (Bit 11..15), Destination Vector (Bit 6..10), VMACF $08 (Bit 0..5)
  endm
VMACU: macro vd, vs, vt, element ; Vector Multiply Accumulate Unsigned Fractions: VMACU VD,VS,VT[ELEMENT]
; Word: Element (0..15), Source Vector 2 (0..31), Source Vector 1 (0..31), Destination Vector (0..31)
  dw $4A000000|(element<<21)|(vt<<16)|(vs<<11)|(vd<<6)|$09 ; Word: COP2 $48 (Bit 26..31), Function Bit 1 (Bit 25), Element (Bit 21..25), Source Vector 2 (Bit 16..20), Source Vector 1 (Bit 11..15), Destination Vector (Bit 6..10), VMACU $09 (Bit 0..5)
  endm
VRNDN: macro vd, vs, vt, element ; Vector DCT Round Negative: VRNDN VD,VS,VT[ELEMENT] (Reserved: MPEG DCT Rounding)
; Word: Element (0..15), Source Vector 2 (0..31), Source Vector 1 (0..31), Destination Vector (0..31)
  dw $4A000000|(element<<21)|(vt<<16)|(vs<<11)|(vd<<6)|$0A ; Word: COP2 $48 (Bit 26..31), Function Bit 1 (Bit 25), Element (Bit 21..25), Source Vector 2 (Bit 16..20), Source Vector 1 (Bit 11..15), Destination Vector (Bit 6..10), VRNDN $0A (Bit 0..5)
  endm
VMACQ: macro vd, vs, vt, element ; Vector Multiply Accumulate Integer: VMACQ VD,VS,VT[ELEMENT] (Reserved: MPEG Inverse Quantization)
; Word: Element (0..15), Source Vector 2 (0..31), Source Vector 1 (0..31), Destination Vector (0..31)
  dw $4A000000|(element<<21)|(vt<<16)|(vs<<11)|(vd<<6)|$0B ; Word: COP2 $48 (Bit 26..31), Function Bit 1 (Bit 25), Element (Bit 21..25), Source Vector 2 (Bit 16..20), Source Vector 1 (Bit 11..15), Destination Vector (Bit 6..10), VMACQ $0B (Bit 0..5)
  endm
VMADL: macro vd, vs, vt, element ; Vector Multiply Accumulate Low Partial Products: VMADL VD,VS,VT[ELEMENT]
; Word: Element (0..15), Source Vector 2 (0..31), Source Vector 1 (0..31), Destination Vector (0..31)
  dw $4A000000|(element<<21)|(vt<<16)|(vs<<11)|(vd<<6)|$0C ; Word: COP2 $48 (Bit 26..31), Function Bit 1 (Bit 25), Element (Bit 21..25), Source Vector 2 (Bit 16..20), Source Vector 1 (Bit 11..15), Destination Vector (Bit 6..10), VMADL $0C (Bit 0..5)
  endm
VMADM: macro vd, vs, vt, element ; Vector Multiply Accumulate Mid Partial Products: VMADM VD,VS,VT[ELEMENT]
; Word: Element (0..15), Source Vector 2 (0..31), Source Vector 1 (0..31), Destination Vector (0..31)
  dw $4A000000|(element<<21)|(vt<<16)|(vs<<11)|(vd<<6)|$0D ; Word: COP2 $48 (Bit 26..31), Function Bit 1 (Bit 25), Element (Bit 21..25), Source Vector 2 (Bit 16..20), Source Vector 1 (Bit 11..15), Destination Vector (Bit 6..10), VMADM $0D (Bit 0..5)
  endm
VMADN: macro vd, vs, vt, element ; Vector Multiply Accumulate Mid Partial Products: VMADN VD,VS,VT[ELEMENT]
; Word: Element (0..15), Source Vector 2 (0..31), Source Vector 1 (0..31), Destination Vector (0..31)
  dw $4A000000|(element<<21)|(vt<<16)|(vs<<11)|(vd<<6)|$0E ; Word: COP2 $48 (Bit 26..31), Function Bit 1 (Bit 25), Element (Bit 21..25), Source Vector 2 (Bit 16..20), Source Vector 1 (Bit 11..15), Destination Vector (Bit 6..10), VMADN $0E (Bit 0..5)
  endm
VMADH: macro vd, vs, vt, element ; Vector Multiply Accumulate High Partial Products: VMADH VD,VS,VT[ELEMENT]
; Word: Element (0..15), Source Vector 2 (0..31), Source Vector 1 (0..31), Destination Vector (0..31)
  dw $4A000000|(element<<21)|(vt<<16)|(vs<<11)|(vd<<6)|$0F ; Word: COP2 $48 (Bit 26..31), Function Bit 1 (Bit 25), Element (Bit 21..25), Source Vector 2 (Bit 16..20), Source Vector 1 (Bit 11..15), Destination Vector (Bit 6..10), VMADH $0F (Bit 0..5)
  endm
VADD: macro vd, vs, vt, element ; Vector Add Short Elements: VADD VD,VS,VT[ELEMENT]
; Word: Element (0..15), Source Vector 2 (0..31), Source Vector 1 (0..31), Destination Vector (0..31)
  dw $4A000000|(element<<21)|(vt<<16)|(vs<<11)|(vd<<6)|$10 ; Word: COP2 $48 (Bit 26..31), Function Bit 1 (Bit 25), Element (Bit 21..25), Source Vector 2 (Bit 16..20), Source Vector 1 (Bit 11..15), Destination Vector (Bit 6..10), VADD $10 (Bit 0..5)
  endm
VSUB: macro vd, vs, vt, element ; Vector Subtract Short Elements: VSUB VD,VS,VT[ELEMENT]
; Word: Element (0..15), Source Vector 2 (0..31), Source Vector 1 (0..31), Destination Vector (0..31)
  dw $4A000000|(element<<21)|(vt<<16)|(vs<<11)|(vd<<6)|$11 ; Word: COP2 $48 (Bit 26..31), Function Bit 1 (Bit 25), Element (Bit 21..25), Source Vector 2 (Bit 16..20), Source Vector 1 (Bit 11..15), Destination Vector (Bit 6..10), VSUB $11 (Bit 0..5)
  endm
VSUT: macro vd, vs, vt, element ; Vector Subtract Short Elements (VT-VS): VSUT VD,VS,VT[ELEMENT] (Reserved)
; Word: Element (0..15), Source Vector 2 (0..31), Source Vector 1 (0..31), Destination Vector (0..31)
  dw $4A000000|(element<<21)|(vt<<16)|(vs<<11)|(vd<<6)|$12 ; Word: COP2 $48 (Bit 26..31), Function Bit 1 (Bit 25), Element (Bit 21..25), Source Vector 2 (Bit 16..20), Source Vector 1 (Bit 11..15), Destination Vector (Bit 6..10), VSUT $12 (Bit 0..5)
  endm
VABS: macro vd, vs, vt, element ; Vector Absolute Value Of Short Elements: VABS VD,VS,VT[ELEMENT]
; Word: Element (0..15), Source Vector 2 (0..31), Source Vector 1 (0..31), Destination Vector (0..31)
  dw $4A000000|(element<<21)|(vt<<16)|(vs<<11)|(vd<<6)|$13 ; Word: COP2 $48 (Bit 26..31), Function Bit 1 (Bit 25), Element (Bit 21..25), Source Vector 2 (Bit 16..20), Source Vector 1 (Bit 11..15), Destination Vector (Bit 6..10), VABS $13 (Bit 0..5)
  endm
VADDC: macro vd, vs, vt, element ; Vector Add Short Elements With Carry: VADDC VD,VS,VT[ELEMENT]
; Word: Element (0..15), Source Vector 2 (0..31), Source Vector 1 (0..31), Destination Vector (0..31)
  dw $4A000000|(element<<21)|(vt<<16)|(vs<<11)|(vd<<6)|$14 ; Word: COP2 $48 (Bit 26..31), Function Bit 1 (Bit 25), Element (Bit 21..25), Source Vector 2 (Bit 16..20), Source Vector 1 (Bit 11..15), Destination Vector (Bit 6..10), VADDC $14 (Bit 0..5)
  endm
VSUBC: macro vd, vs, vt, element ; Vector Subtract Short Elements With Carry: VSUBC VD,VS,VT[ELEMENT]
; Word: Element (0..15), Source Vector 2 (0..31), Source Vector 1 (0..31), Destination Vector (0..31)
  dw $4A000000|(element<<21)|(vt<<16)|(vs<<11)|(vd<<6)|$15 ; Word: COP2 $48 (Bit 26..31), Function Bit 1 (Bit 25), Element (Bit 21..25), Source Vector 2 (Bit 16..20), Source Vector 1 (Bit 11..15), Destination Vector (Bit 6..10), VSUBC $15 (Bit 0..5)
  endm
VADDB: macro vd, vs, vt, element ; Vector Add Byte Elements: VADDB VD,VS,VT[ELEMENT] (Reserved)
; Word: Element (0..15), Source Vector 2 (0..31), Source Vector 1 (0..31), Destination Vector (0..31)
  dw $4A000000|(element<<21)|(vt<<16)|(vs<<11)|(vd<<6)|$16 ; Word: COP2 $48 (Bit 26..31), Function Bit 1 (Bit 25), Element (Bit 21..25), Source Vector 2 (Bit 16..20), Source Vector 1 (Bit 11..15), Destination Vector (Bit 6..10), VADDB $16 (Bit 0..5)
  endm
VSUBB: macro vd, vs, vt, element ; Vector Subtract Byte Elements: VSUBB VD,VS,VT[ELEMENT] (Reserved)
; Word: Element (0..15), Source Vector 2 (0..31), Source Vector 1 (0..31), Destination Vector (0..31)
  dw $4A000000|(element<<21)|(vt<<16)|(vs<<11)|(vd<<6)|$17 ; Word: COP2 $48 (Bit 26..31), Function Bit 1 (Bit 25), Element (Bit 21..25), Source Vector 2 (Bit 16..20), Source Vector 1 (Bit 11..15), Destination Vector (Bit 6..10), VSUBB $17 (Bit 0..5)
  endm
VADCB: macro vd, vs, vt, element ; Vector Add Byte Elements With Carry: VADCB VD,VS,VT[ELEMENT] (Reserved)
; Word: Element (0..15), Source Vector 2 (0..31), Source Vector 1 (0..31), Destination Vector (0..31)
  dw $4A000000|(element<<21)|(vt<<16)|(vs<<11)|(vd<<6)|$18 ; Word: COP2 $48 (Bit 26..31), Function Bit 1 (Bit 25), Element (Bit 21..25), Source Vector 2 (Bit 16..20), Source Vector 1 (Bit 11..15), Destination Vector (Bit 6..10), VADCB $18 (Bit 0..5)
  endm
VSUCB: macro vd, vs, vt, element ; Vector Subtract Byte Elements With Carry: VSUCB VD,VS,VT[ELEMENT] (Reserved)
; Word: Element (0..15), Source Vector 2 (0..31), Source Vector 1 (0..31), Destination Vector (0..31)
  dw $4A000000|(element<<21)|(vt<<16)|(vs<<11)|(vd<<6)|$19 ; Word: COP2 $48 (Bit 26..31), Function Bit 1 (Bit 25), Element (Bit 21..25), Source Vector 2 (Bit 16..20), Source Vector 1 (Bit 11..15), Destination Vector (Bit 6..10), VSUCB $19 (Bit 0..5)
  endm
VSAD: macro vd, vs, vt, element ; Vector SAD: VSAD VD,VS,VT[ELEMENT] (Reserved)
; Word: Element (0..15), Source Vector 2 (0..31), Source Vector 1 (0..31), Destination Vector (0..31)
  dw $4A000000|(element<<21)|(vt<<16)|(vs<<11)|(vd<<6)|$1A ; Word: COP2 $48 (Bit 26..31), Function Bit 1 (Bit 25), Element (Bit 21..25), Source Vector 2 (Bit 16..20), Source Vector 1 (Bit 11..15), Destination Vector (Bit 6..10), VSAD $1A (Bit 0..5)
  endm
VSAC: macro vd, vs, vt, element ; Vector SAC: VSAC VD,VS,VT[ELEMENT] (Reserved)
; Word: Element (0..15), Source Vector 2 (0..31), Source Vector 1 (0..31), Destination Vector (0..31)
  dw $4A000000|(element<<21)|(vt<<16)|(vs<<11)|(vd<<6)|$1B ; Word: COP2 $48 (Bit 26..31), Function Bit 1 (Bit 25), Element (Bit 21..25), Source Vector 2 (Bit 16..20), Source Vector 1 (Bit 11..15), Destination Vector (Bit 6..10), VSAC $1B (Bit 0..5)
  endm
VSUM: macro vd, vs, vt, element ; Vector SUM: VSUM VD,VS,VT[ELEMENT] (Reserved)
; Word: Element (0..15), Source Vector 2 (0..31), Source Vector 1 (0..31), Destination Vector (0..31)
  dw $4A000000|(element<<21)|(vt<<16)|(vs<<11)|(vd<<6)|$1C ; Word: COP2 $48 (Bit 26..31), Function Bit 1 (Bit 25), Element (Bit 21..25), Source Vector 2 (Bit 16..20), Source Vector 1 (Bit 11..15), Destination Vector (Bit 6..10), VSUM $1C (Bit 0..5)
  endm
VSAR: macro vd, vs, vt, element ; Vector Accumulator Read: VSAR VD,VS,VT[ELEMENT]
; Word: Element (0..15), Source Vector 2 (0..31), Source Vector 1 (0..31), Destination Vector (0..31)
  dw $4A000000|(element<<21)|(vt<<16)|(vs<<11)|(vd<<6)|$1D ; Word: COP2 $48 (Bit 26..31), Function Bit 1 (Bit 25), Element (Bit 21..25), Source Vector 2 (Bit 16..20), Source Vector 1 (Bit 11..15), Destination Vector (Bit 6..10), VSAR $1D (Bit 0..5)
  endm

VLT: macro vd, vs, vt, element ; Vector Select Less Than: VLT VD,VS,VT[ELEMENT]
; Word: Element (0..15), Source Vector 2 (0..31), Source Vector 1 (0..31), Destination Vector (0..31)
  dw $4A000000|(element<<21)|(vt<<16)|(vs<<11)|(vd<<6)|$20 ; Word: COP2 $48 (Bit 26..31), Function Bit 1 (Bit 25), Element (Bit 21..25), Source Vector 2 (Bit 16..20), Source Vector 1 (Bit 11..15), Destination Vector (Bit 6..10), VLT $20 (Bit 0..5)
  endm
VEQ: macro vd, vs, vt, element ; Vector Select Equal: VEQ VD,VS,VT[ELEMENT]
; Word: Element (0..15), Source Vector 2 (0..31), Source Vector 1 (0..31), Destination Vector (0..31)
  dw $4A000000|(element<<21)|(vt<<16)|(vs<<11)|(vd<<6)|$21 ; Word: COP2 $48 (Bit 26..31), Function Bit 1 (Bit 25), Element (Bit 21..25), Source Vector 2 (Bit 16..20), Source Vector 1 (Bit 11..15), Destination Vector (Bit 6..10), VEQ $21 (Bit 0..5)
  endm
VNE: macro vd, vs, vt, element ; Vector Select Not Equal: VNE VD,VS,VT[ELEMENT]
; Word: Element (0..15), Source Vector 2 (0..31), Source Vector 1 (0..31), Destination Vector (0..31)
  dw $4A000000|(element<<21)|(vt<<16)|(vs<<11)|(vd<<6)|$22 ; Word: COP2 $48 (Bit 26..31), Function Bit 1 (Bit 25), Element (Bit 21..25), Source Vector 2 (Bit 16..20), Source Vector 1 (Bit 11..15), Destination Vector (Bit 6..10), VNE $22 (Bit 0..5)
  endm
VGE: macro vd, vs, vt, element ; Vector Select Greater Than Or Equal: VGE VD,VS,VT[ELEMENT]
; Word: Element (0..15), Source Vector 2 (0..31), Source Vector 1 (0..31), Destination Vector (0..31)
  dw $4A000000|(element<<21)|(vt<<16)|(vs<<11)|(vd<<6)|$23 ; Word: COP2 $48 (Bit 26..31), Function Bit 1 (Bit 25), Element (Bit 21..25), Source Vector 2 (Bit 16..20), Source Vector 1 (Bit 11..15), Destination Vector (Bit 6..10), VGE $23 (Bit 0..5)
  endm
VCL: macro vd, vs, vt, element ; Vector Select Clip Test Low: VCL VD,VS,VT[ELEMENT]
; Word: Element (0..15), Source Vector 2 (0..31), Source Vector 1 (0..31), Destination Vector (0..31)
  dw $4A000000|(element<<21)|(vt<<16)|(vs<<11)|(vd<<6)|$24 ; Word: COP2 $48 (Bit 26..31), Function Bit 1 (Bit 25), Element (Bit 21..25), Source Vector 2 (Bit 16..20), Source Vector 1 (Bit 11..15), Destination Vector (Bit 6..10), VCL $24 (Bit 0..5)
  endm
VCH: macro vd, vs, vt, element ; Vector Select Clip Test High: VCH VD,VS,VT[ELEMENT]
; Word: Element (0..15), Source Vector 2 (0..31), Source Vector 1 (0..31), Destination Vector (0..31)
  dw $4A000000|(element<<21)|(vt<<16)|(vs<<11)|(vd<<6)|$25 ; Word: COP2 $48 (Bit 26..31), Function Bit 1 (Bit 25), Element (Bit 21..25), Source Vector 2 (Bit 16..20), Source Vector 1 (Bit 11..15), Destination Vector (Bit 6..10), VCH $25 (Bit 0..5)
  endm
VCR: macro vd, vs, vt, element ; Vector Select Clip Test Low (Single Precision): VCR VD,VS,VT[ELEMENT]
; Word: Element (0..15), Source Vector 2 (0..31), Source Vector 1 (0..31), Destination Vector (0..31)
  dw $4A000000|(element<<21)|(vt<<16)|(vs<<11)|(vd<<6)|$26 ; Word: COP2 $48 (Bit 26..31), Function Bit 1 (Bit 25), Element (Bit 21..25), Source Vector 2 (Bit 16..20), Source Vector 1 (Bit 11..15), Destination Vector (Bit 6..10), VCR $26 (Bit 0..5)
  endm
VMRG: macro vd, vs, vt, element ; Vector Select Merge: VMRG VD,VS,VT[ELEMENT]
; Word: Element (0..15), Source Vector 2 (0..31), Source Vector 1 (0..31), Destination Vector (0..31)
  dw $4A000000|(element<<21)|(vt<<16)|(vs<<11)|(vd<<6)|$27 ; Word: COP2 $48 (Bit 26..31), Function Bit 1 (Bit 25), Element (Bit 21..25), Source Vector 2 (Bit 16..20), Source Vector 1 (Bit 11..15), Destination Vector (Bit 6..10), VMRG $27 (Bit 0..5)
  endm
VAND: macro vd, vs, vt, element ; Vector Logical AND Short Elements: VAND VD,VS,VT[ELEMENT]
; Word: Element (0..15), Source Vector 2 (0..31), Source Vector 1 (0..31), Destination Vector (0..31)
  dw $4A000000|(element<<21)|(vt<<16)|(vs<<11)|(vd<<6)|$28 ; Word: COP2 $48 (Bit 26..31), Function Bit 1 (Bit 25), Element (Bit 21..25), Source Vector 2 (Bit 16..20), Source Vector 1 (Bit 11..15), Destination Vector (Bit 6..10), VAND $28 (Bit 0..5)
  endm
VNAND: macro vd, vs, vt, element ; Vector Logical NOT AND Short Elements: VNAND VD,VS,VT[ELEMENT]
; Word: Element (0..15), Source Vector 2 (0..31), Source Vector 1 (0..31), Destination Vector (0..31)
  dw $4A000000|(element<<21)|(vt<<16)|(vs<<11)|(vd<<6)|$29 ; Word: COP2 $48 (Bit 26..31), Function Bit 1 (Bit 25), Element (Bit 21..25), Source Vector 2 (Bit 16..20), Source Vector 1 (Bit 11..15), Destination Vector (Bit 6..10), VNAND $29 (Bit 0..5)
  endm
VOR: macro vd, vs, vt, element ; Vector Logical OR Short Elements: VOR VD,VS,VT[ELEMENT]
; Word: Element (0..15), Source Vector 2 (0..31), Source Vector 1 (0..31), Destination Vector (0..31)
  dw $4A000000|(element<<21)|(vt<<16)|(vs<<11)|(vd<<6)|$2A ; Word: COP2 $48 (Bit 26..31), Function Bit 1 (Bit 25), Element (Bit 21..25), Source Vector 2 (Bit 16..20), Source Vector 1 (Bit 11..15), Destination Vector (Bit 6..10), VOR $2A (Bit 0..5)
  endm
VNOR: macro vd, vs, vt, element ; Vector Logical NOT OR Short Elements: VNOR VD,VS,VT[ELEMENT]
; Word: Element (0..15), Source Vector 2 (0..31), Source Vector 1 (0..31), Destination Vector (0..31)
  dw $4A000000|(element<<21)|(vt<<16)|(vs<<11)|(vd<<6)|$2B ; Word: COP2 $48 (Bit 26..31), Function Bit 1 (Bit 25), Element (Bit 21..25), Source Vector 2 (Bit 16..20), Source Vector 1 (Bit 11..15), Destination Vector (Bit 6..10), VNOR $2B (Bit 0..5)
  endm
VXOR: macro vd, vs, vt, element ; Vector Logical Exclusive OR Short Elements: VXOR VD,VS,VT[ELEMENT]
; Word: Element (0..15), Source Vector 2 (0..31), Source Vector 1 (0..31), Destination Vector (0..31)
  dw $4A000000|(element<<21)|(vt<<16)|(vs<<11)|(vd<<6)|$2C ; Word: COP2 $48 (Bit 26..31), Function Bit 1 (Bit 25), Element (Bit 21..25), Source Vector 2 (Bit 16..20), Source Vector 1 (Bit 11..15), Destination Vector (Bit 6..10), VXOR $2C (Bit 0..5)
  endm
VNXOR: macro vd, vs, vt, element ; Vector Logical NOT Exclusive OR Short Elements: VNXOR VD,VS,VT[ELEMENT]
; Word: Element (0..15), Source Vector 2 (0..31), Source Vector 1 (0..31), Destination Vector (0..31)
  dw $4A000000|(element<<21)|(vt<<16)|(vs<<11)|(vd<<6)|$2D ; Word: COP2 $48 (Bit 26..31), Function Bit 1 (Bit 25), Element (Bit 21..25), Source Vector 2 (Bit 16..20), Source Vector 1 (Bit 11..15), Destination Vector (Bit 6..10), VNXOR $2D (Bit 0..5)
  endm

VRCP: macro vd, vs, vt, element ; Vector Element Scalar Reciprocal (Single Precision): VRCP VD,VS,VT[ELEMENT]
; Word: Element (0..15), Source Vector 2 (0..31), Source Vector 1 (0..31), Destination Vector (0..31)
  dw $4A000000|(element<<21)|(vt<<16)|(vs<<11)|(vd<<6)|$30 ; Word: COP2 $48 (Bit 26..31), Function Bit 1 (Bit 25), Element (Bit 21..25), Source Vector 2 (Bit 16..20), Source Vector 1 (Bit 11..15), Destination Vector (Bit 6..10), VRCP $30 (Bit 0..5)
  endm
VRCPL: macro vd, vs, vt, element ; Vector Element Scalar Reciprocal Low: VRCPL VD,VS,VT[ELEMENT]
; Word: Element (0..15), Source Vector 2 (0..31), Source Vector 1 (0..31), Destination Vector (0..31)
  dw $4A000000|(element<<21)|(vt<<16)|(vs<<11)|(vd<<6)|$31 ; Word: COP2 $48 (Bit 26..31), Function Bit 1 (Bit 25), Element (Bit 21..25), Source Vector 2 (Bit 16..20), Source Vector 1 (Bit 11..15), Destination Vector (Bit 6..10), VRCPL $31 (Bit 0..5)
  endm
VRCPH: macro vd, vs, vt, element ; Vector Element Scalar Reciprocal High: VRCPH VD,VS,VT[ELEMENT]
; Word: Element (0..15), Source Vector 2 (0..31), Source Vector 1 (0..31), Destination Vector (0..31)
  dw $4A000000|(element<<21)|(vt<<16)|(vs<<11)|(vd<<6)|$32 ; Word: COP2 $48 (Bit 26..31), Function Bit 1 (Bit 25), Element (Bit 21..25), Source Vector 2 (Bit 16..20), Source Vector 1 (Bit 11..15), Destination Vector (Bit 6..10), VRCPH $32 (Bit 0..5)
  endm
VMOV: macro vd, vs, vt, element ; Vector Element Scalar Move: VMOV VD,VS,VT[ELEMENT]
; Word: Element (0..15), Source Vector 2 (0..31), Source Vector 1 (0..31), Destination Vector (0..31)
  dw $4A000000|(element<<21)|(vt<<16)|(vs<<11)|(vd<<6)|$33 ; Word: COP2 $48 (Bit 26..31), Function Bit 1 (Bit 25), Element (Bit 21..25), Source Vector 2 (Bit 16..20), Source Vector 1 (Bit 11..15), Destination Vector (Bit 6..10), VMOV $33 (Bit 0..5)
  endm
VRSQ: macro vd, vs, vt, element ; Vector Element Scalar SQRT Reciprocal (Single Precision): VRSQ VD,VS,VT[ELEMENT]
; Word: Element (0..15), Source Vector 2 (0..31), Source Vector 1 (0..31), Destination Vector (0..31)
  dw $4A000000|(element<<21)|(vt<<16)|(vs<<11)|(vd<<6)|$34 ; Word: COP2 $48 (Bit 26..31), Function Bit 1 (Bit 25), Element (Bit 21..25), Source Vector 2 (Bit 16..20), Source Vector 1 (Bit 11..15), Destination Vector (Bit 6..10), VRSQ $34 (Bit 0..5)
  endm
VRSQL: macro vd, vs, vt, element ; Vector Element Scalar SQRT Reciprocal Low: VRSQL VD,VS,VT[ELEMENT]
; Word: Element (0..15), Source Vector 2 (0..31), Source Vector 1 (0..31), Destination Vector (0..31)
  dw $4A000000|(element<<21)|(vt<<16)|(vs<<11)|(vd<<6)|$35 ; Word: COP2 $48 (Bit 26..31), Function Bit 1 (Bit 25), Element (Bit 21..25), Source Vector 2 (Bit 16..20), Source Vector 1 (Bit 11..15), Destination Vector (Bit 6..10), VRSQL $35 (Bit 0..5)
  endm
VRSQH: macro vd, vs, vt, element ; Vector Element Scalar SQRT Reciprocal High: VRSQH VD,VS,VT[ELEMENT]
; Word: Element (0..15), Source Vector 2 (0..31), Source Vector 1 (0..31), Destination Vector (0..31)
  dw $4A000000|(element<<21)|(vt<<16)|(vs<<11)|(vd<<6)|$36 ; Word: COP2 $48 (Bit 26..31), Function Bit 1 (Bit 25), Element (Bit 21..25), Source Vector 2 (Bit 16..20), Source Vector 1 (Bit 11..15), Destination Vector (Bit 6..10), VRSQH $36 (Bit 0..5)
  endm
VNOP: macro vd, vs, vt, element ; Vector Null Instruction: VNOP VD,VS,VT[ELEMENT]
; Word: Element (0..15), Source Vector 2 (0..31), Source Vector 1 (0..31), Destination Vector (0..31)
  dw $4A000000|(element<<21)|(vt<<16)|(vs<<11)|(vd<<6)|$37 ; Word: COP2 $48 (Bit 26..31), Function Bit 1 (Bit 25), Element (Bit 21..25), Source Vector 2 (Bit 16..20), Source Vector 1 (Bit 11..15), Destination Vector (Bit 6..10), VNOP $37 (Bit 0..5)
  endm
VEXTT: macro vd, vs, vt, element ; Vector Extract Triple (5/5/5/1): VEXTT VD,VS,VT[ELEMENT] (Reserved)
; Word: Element (0..15), Source Vector 2 (0..31), Source Vector 1 (0..31), Destination Vector (0..31)
  dw $4A000000|(element<<21)|(vt<<16)|(vs<<11)|(vd<<6)|$38 ; Word: COP2 $48 (Bit 26..31), Function Bit 1 (Bit 25), Element (Bit 21..25), Source Vector 2 (Bit 16..20), Source Vector 1 (Bit 11..15), Destination Vector (Bit 6..10), VEXTT $38 (Bit 0..5)
  endm
VEXTQ: macro vd, vs, vt, element ; Vector Extract Quad (4/4/4/4): VEXTQ VD,VS,VT[ELEMENT] (Reserved)
; Word: Element (0..15), Source Vector 2 (0..31), Source Vector 1 (0..31), Destination Vector (0..31)
  dw $4A000000|(element<<21)|(vt<<16)|(vs<<11)|(vd<<6)|$39 ; Word: COP2 $48 (Bit 26..31), Function Bit 1 (Bit 25), Element (Bit 21..25), Source Vector 2 (Bit 16..20), Source Vector 1 (Bit 11..15), Destination Vector (Bit 6..10), VEXTQ $39 (Bit 0..5)
  endm
VEXTN: macro vd, vs, vt, element ; Vector Extract Nibble (4/4/4/4) (Sign Extended): VEXTN VD,VS,VT[ELEMENT] (Reserved)
; Word: Element (0..15), Source Vector 2 (0..31), Source Vector 1 (0..31), Destination Vector (0..31)
  dw $4A000000|(element<<21)|(vt<<16)|(vs<<11)|(vd<<6)|$3A ; Word: COP2 $48 (Bit 26..31), Function Bit 1 (Bit 25), Element (Bit 21..25), Source Vector 2 (Bit 16..20), Source Vector 1 (Bit 11..15), Destination Vector (Bit 6..10), VEXTN $3A (Bit 0..5)
  endm
VINST: macro vd, vs, vt, element ; Vector Insert Triple (5/5/5/1): VINST VD,VS,VT[ELEMENT] (Reserved)
; Word: Element (0..15), Source Vector 2 (0..31), Source Vector 1 (0..31), Destination Vector (0..31)
  dw $4A000000|(element<<21)|(vt<<16)|(vs<<11)|(vd<<6)|$3B ; Word: COP2 $48 (Bit 26..31), Function Bit 1 (Bit 25), Element (Bit 21..25), Source Vector 2 (Bit 16..20), Source Vector 1 (Bit 11..15), Destination Vector (Bit 6..10), VINST $3B (Bit 0..5)
  endm
VINSQ: macro vd, vs, vt, element ; Vector Insert Quad (4/4/4/4): VINSQ VD,VS,VT[ELEMENT] (Reserved)
; Word: Element (0..15), Source Vector 2 (0..31), Source Vector 1 (0..31), Destination Vector (0..31)
  dw $4A000000|(element<<21)|(vt<<16)|(vs<<11)|(vd<<6)|$3C ; Word: COP2 $48 (Bit 26..31), Function Bit 1 (Bit 25), Element (Bit 21..25), Source Vector 2 (Bit 16..20), Source Vector 1 (Bit 11..15), Destination Vector (Bit 6..10), VINSQ $3C (Bit 0..5)
  endm
VINSN: macro vd, vs, vt, element ; Vector Insert Nibble (4/4/4/4) (Sign Extended): VINSN VD,VS,VT[ELEMENT] (Reserved)
; Word: Element (0..15), Source Vector 2 (0..31), Source Vector 1 (0..31), Destination Vector (0..31)
  dw $4A000000|(element<<21)|(vt<<16)|(vs<<11)|(vd<<6)|$3D ; Word: COP2 $48 (Bit 26..31), Function Bit 1 (Bit 25), Element (Bit 21..25), Source Vector 2 (Bit 16..20), Source Vector 1 (Bit 11..15), Destination Vector (Bit 6..10), VINSN $3D (Bit 0..5)
  endm

; RSP CP2 Vector Load Instructions (LWC2):
LBV: macro vt, element, offset, base ; Load Byte To Vector: LBV VT[ELEMENT],$OFFSET(BASE)
; Word: Base Register (0..31), Destination Vector (0..31), Destination Element (0..15), Offset ($00..$3F)
  dw $C8000000|(base<<21)|(vt<<16)|($00<<11)|(element<<7)|offset ; Word: LWC2 $C8 (Bit 26..31), Base (Bit 21..25), Vector (Bit 16..20), LBV $00 (Bit 11..15), Element (Bit 7..10), Offset (Bit 0..5)
  endm
LSV: macro vt, element, offset, base ; Load Short To Vector: LSV VT[ELEMENT],$OFFSET(BASE)
; Word: Base Register (0..31), Destination Vector (0..31), Destination Element (0..15), Offset ($00..$3F)
  dw $C8000000|(base<<21)|(vt<<16)|($01<<11)|(element<<7)|offset ; Word: LWC2 $C8 (Bit 26..31), Base (Bit 21..25), Vector (Bit 16..20), LSV $01 (Bit 11..15), Element (Bit 7..10), Offset (Bit 0..5)
  endm
LLV: macro vt, element, offset, base ; Load Long To Vector: LLV VT[ELEMENT],$OFFSET(BASE)
; Word: Base Register (0..31), Destination Vector (0..31), Destination Element (0..15), Offset ($00..$3F)
  dw $C8000000|(base<<21)|(vt<<16)|($02<<11)|(element<<7)|offset ; Word: LWC2 $C8 (Bit 26..31), Base (Bit 21..25), Vector (Bit 16..20), LLV $02 (Bit 11..15), Element (Bit 7..10), Offset (Bit 0..5)
  endm
LDV: macro vt, element, offset, base ; Load Double To Vector: LDV VT[ELEMENT],$OFFSET(BASE)
; Word: Base Register (0..31), Destination Vector (0..31), Destination Element (0..15), Offset ($00..$3F)
  dw $C8000000|(base<<21)|(vt<<16)|($03<<11)|(element<<7)|offset ; Word: LWC2 $C8 (Bit 26..31), Base (Bit 21..25), Vector (Bit 16..20), LDV $03 (Bit 11..15), Element (Bit 7..10), Offset (Bit 0..5)
  endm
LQV: macro vt, element, offset, base ; Load Quad To Vector: LQV VT[ELEMENT],$OFFSET(BASE)
; Word: Base Register (0..31), Destination Vector (0..31), Destination Element (0..15), Offset ($00..$3F)
  dw $C8000000|(base<<21)|(vt<<16)|($04<<11)|(element<<7)|offset ; Word: LWC2 $C8 (Bit 26..31), Base (Bit 21..25), Vector (Bit 16..20), LQV $04 (Bit 11..15), Element (Bit 7..10), Offset (Bit 0..5)
  endm
LRV: macro vt, element, offset, base ; Load Rest To Vector: LRV VT[ELEMENT],$OFFSET(BASE)
; Word: Base Register (0..31), Destination Vector (0..31), Destination Element (0..15), Offset ($00..$3F)
  dw $C8000000|(base<<21)|(vt<<16)|($05<<11)|(element<<7)|offset ; Word: LWC2 $C8 (Bit 26..31), Base (Bit 21..25), Vector (Bit 16..20), LRV $05 (Bit 11..15), Element (Bit 7..10), Offset (Bit 0..5)
  endm
LPV: macro vt, element, offset, base ; Load Packed Signed To Vector: LPV VT[ELEMENT],$OFFSET(BASE)
; Word: Base Register (0..31), Destination Vector (0..31), Destination Element (0..15), Offset ($00..$3F)
  dw $C8000000|(base<<21)|(vt<<16)|($06<<11)|(element<<7)|offset ; Word: LWC2 $C8 (Bit 26..31), Base (Bit 21..25), Vector (Bit 16..20), LPV $06 (Bit 11..15), Element (Bit 7..10), Offset (Bit 0..5)
  endm
LUV: macro vt, element, offset, base ; Load Packed Unsigned To Vector: LUV VT[ELEMENT],$OFFSET(BASE)
; Word: Base Register (0..31), Destination Vector (0..31), Destination Element (0..15), Offset ($00..$3F)
  dw $C8000000|(base<<21)|(vt<<16)|($07<<11)|(element<<7)|offset ; Word: LWC2 $C8 (Bit 26..31), Base (Bit 21..25), Vector (Bit 16..20), LUV $07 (Bit 11..15), Element (Bit 7..10), Offset (Bit 0..5)
  endm
LHV: macro vt, element, offset, base ; Load Half Bytes To Vector: LHV VT[ELEMENT],$OFFSET(BASE)
; Word: Base Register (0..31), Destination Vector (0..31), Destination Element (0..15), Offset ($00..$3F)
  dw $C8000000|(base<<21)|(vt<<16)|($08<<11)|(element<<7)|offset ; Word: LWC2 $C8 (Bit 26..31), Base (Bit 21..25), Vector (Bit 16..20), LHV $08 (Bit 11..15), Element (Bit 7..10), Offset (Bit 0..5)
  endm
LFV: macro vt, element, offset, base ; Load Fourth Bytes To Vector: LFV VT[ELEMENT],$OFFSET(BASE)
; Word: Base Register (0..31), Destination Vector (0..31), Destination Element (0..15), Offset ($00..$3F)
  dw $C8000000|(base<<21)|(vt<<16)|($09<<11)|(element<<7)|offset ; Word: LWC2 $C8 (Bit 26..31), Base (Bit 21..25), Vector (Bit 16..20), LFV $09 (Bit 11..15), Element (Bit 7..10), Offset (Bit 0..5)
  endm
LWV: macro vt, element, offset, base ; Load Transposed Wrapped Bytes To Vector: LWV VT[ELEMENT],$OFFSET(BASE)
; Word: Base Register (0..31), Destination Vector (0..31), Destination Element (0..15), Offset ($00..$3F)
  dw $C8000000|(base<<21)|(vt<<16)|($0A<<11)|(element<<7)|offset ; Word: LWC2 $C8 (Bit 26..31), Base (Bit 21..25), Vector (Bit 16..20), LWV $0A (Bit 11..15), Element (Bit 7..10), Offset (Bit 0..5)
  endm
LTV: macro vt, element, offset, base ; Load Transposed Bytes To Vector: LTV VT[ELEMENT],$OFFSET(BASE)
; Word: Base Register (0..31), Destination Vector (0..31), Destination Element (0..15), Offset ($00..$3F)
  dw $C8000000|(base<<21)|(vt<<16)|($0B<<11)|(element<<7)|offset ; Word: LWC2 $C8 (Bit 26..31), Base (Bit 21..25), Vector (Bit 16..20), LTV $0B (Bit 11..15), Element (Bit 7..10), Offset (Bit 0..5)
  endm

; RSP CP2 Vector Store Instructions (SWC2):
SBV: macro vt, element, offset, base ; Store Byte From Vector: SBV VT[ELEMENT],$OFFSET(BASE)
; Word: Base Register (0..31), Destination Vector (0..31), Destination Element (0..15), Offset ($00..$3F)
  dw $E8000000|(base<<21)|(vt<<16)|($00<<11)|(element<<7)|offset ; Word: SWC2 $E8 (Bit 26..31), Base (Bit 21..25), Vector (Bit 16..20), SBV $00 (Bit 11..15), Element (Bit 7..10), Offset (Bit 0..5)
  endm
SSV: macro vt, element, offset, base ; Store Short From Vector: SSV VT[ELEMENT],$OFFSET(BASE)
; Word: Base Register (0..31), Destination Vector (0..31), Destination Element (0..15), Offset ($00..$3F)
  dw $E8000000|(base<<21)|(vt<<16)|($01<<11)|(element<<7)|offset ; Word: SWC2 $E8 (Bit 26..31), Base (Bit 21..25), Vector (Bit 16..20), SSV $01 (Bit 11..15), Element (Bit 7..10), Offset (Bit 0..5)
  endm
SLV: macro vt, element, offset, base ; Store Long From Vector: SLV VT[ELEMENT],$OFFSET(BASE)
; Word: Base Register (0..31), Destination Vector (0..31), Destination Element (0..15), Offset ($00..$3F)
  dw $E8000000|(base<<21)|(vt<<16)|($02<<11)|(element<<7)|offset ; Word: SWC2 $E8 (Bit 26..31), Base (Bit 21..25), Vector (Bit 16..20), SLV $02 (Bit 11..15), Element (Bit 7..10), Offset (Bit 0..5)
  endm
SDV: macro vt, element, offset, base ; Store Double From Vector: SDV VT[ELEMENT],$OFFSET(BASE)
; Word: Base Register (0..31), Destination Vector (0..31), Destination Element (0..15), Offset ($00..$3F)
  dw $E8000000|(base<<21)|(vt<<16)|($03<<11)|(element<<7)|offset ; Word: SWC2 $E8 (Bit 26..31), Base (Bit 21..25), Vector (Bit 16..20), SDV $03 (Bit 11..15), Element (Bit 7..10), Offset (Bit 0..5)
  endm
SQV: macro vt, element, offset, base ; Store Quad From Vector: SQV VT[ELEMENT],$OFFSET(BASE)
; Word: Base Register (0..31), Destination Vector (0..31), Destination Element (0..15), Offset ($00..$3F)
  dw $E8000000|(base<<21)|(vt<<16)|($04<<11)|(element<<7)|offset ; Word: SWC2 $E8 (Bit 26..31), Base (Bit 21..25), Vector (Bit 16..20), SQV $04 (Bit 11..15), Element (Bit 7..10), Offset (Bit 0..5)
  endm
SRV: macro vt, element, offset, base ; Store Rest From Vector: SRV VT[ELEMENT],$OFFSET(BASE)
; Word: Base Register (0..31), Destination Vector (0..31), Destination Element (0..15), Offset ($00..$3F)
  dw $E8000000|(base<<21)|(vt<<16)|($05<<11)|(element<<7)|offset ; Word: SWC2 $E8 (Bit 26..31), Base (Bit 21..25), Vector (Bit 16..20), SRV $05 (Bit 11..15), Element (Bit 7..10), Offset (Bit 0..5)
  endm
SPV: macro vt, element, offset, base ; Store Packed Signed From Vector: SPV VT[ELEMENT],$OFFSET(BASE)
; Word: Base Register (0..31), Destination Vector (0..31), Destination Element (0..15), Offset ($00..$3F)
  dw $E8000000|(base<<21)|(vt<<16)|($06<<11)|(element<<7)|offset ; Word: SWC2 $E8 (Bit 26..31), Base (Bit 21..25), Vector (Bit 16..20), SPV $06 (Bit 11..15), Element (Bit 7..10), Offset (Bit 0..5)
  endm
SUV: macro vt, element, offset, base ; Store Packed Unsigned From Vector: SUV VT[ELEMENT],$OFFSET(BASE)
; Word: Base Register (0..31), Destination Vector (0..31), Destination Element (0..15), Offset ($00..$3F)
  dw $E8000000|(base<<21)|(vt<<16)|($07<<11)|(element<<7)|offset ; Word: SWC2 $E8 (Bit 26..31), Base (Bit 21..25), Vector (Bit 16..20), SUV $07 (Bit 11..15), Element (Bit 7..10), Offset (Bit 0..5)
  endm
SHV: macro vt, element, offset, base ; Store Half Bytes From Vector: SHV VT[ELEMENT],$OFFSET(BASE)
; Word: Base Register (0..31), Destination Vector (0..31), Destination Element (0..15), Offset ($00..$3F)
  dw $E8000000|(base<<21)|(vt<<16)|($08<<11)|(element<<7)|offset ; Word: SWC2 $E8 (Bit 26..31), Base (Bit 21..25), Vector (Bit 16..20), SHV $08 (Bit 11..15), Element (Bit 7..10), Offset (Bit 0..5)
  endm
SFV: macro vt, element, offset, base ; Store Fourth Bytes From Vector: SFV VT[ELEMENT],$OFFSET(BASE)
; Word: Base Register (0..31), Destination Vector (0..31), Destination Element (0..15), Offset ($00..$3F)
  dw $E8000000|(base<<21)|(vt<<16)|($09<<11)|(element<<7)|offset ; Word: SWC2 $E8 (Bit 26..31), Base (Bit 21..25), Vector (Bit 16..20), SFV $09 (Bit 11..15), Element (Bit 7..10), Offset (Bit 0..5)
  endm
SWV: macro vt, element, offset, base ; Store Transposed Wrapped Bytes From Vector: SWV VT[ELEMENT],$OFFSET(BASE)
; Word: Base Register (0..31), Destination Vector (0..31), Destination Element (0..15), Offset ($00..$3F)
  dw $E8000000|(base<<21)|(vt<<16)|($0A<<11)|(element<<7)|offset ; Word: SWC2 $E8 (Bit 26..31), Base (Bit 21..25), Vector (Bit 16..20), SWV $0A (Bit 11..15), Element (Bit 7..10), Offset (Bit 0..5)
  endm
STV: macro vt, element, offset, base ; Store Transposed Bytes From Vector: STV VT[ELEMENT],$OFFSET(BASE)
; Word: Base Register (0..31), Destination Vector (0..31), Destination Element (0..15), Offset ($00..$3F)
  dw $E8000000|(base<<21)|(vt<<16)|($0B<<11)|(element<<7)|offset ; Word: SWC2 $E8 (Bit 26..31), Base (Bit 21..25), Vector (Bit 16..20), STV $0B (Bit 11..15), Element (Bit 7..10), Offset (Bit 0..5)
  endm