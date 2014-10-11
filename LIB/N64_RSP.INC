;==============================
; N64 Reality Signal Processor
;==============================
; SP Status Read Flags:
RSP_HLT: equ $0000001 ; SP_STATUS: Halt (Bit 0)
RSP_BRK: equ $0000002 ; SP_STATUS: Break (Bit 1)
RSP_BSY: equ $0000004 ; SP_STATUS: DMA Busy (Bit 2)
RSP_FUL: equ $0000008 ; SP_STATUS: DMA Full (Bit 3)
RSP_IOF: equ $0000010 ; SP_STATUS: IO Full (Bit 4)
RSP_STP: equ $0000020 ; SP_STATUS: Single Step (Bit 5)
RSP_IOB: equ $0000040 ; SP_STATUS: Interrupt On Break (Bit 6)
RSP_SG0: equ $0000080 ; SP_STATUS: Signal 0 Set (Bit 7)
RSP_SG1: equ $0000100 ; SP_STATUS: Signal 1 Set (Bit 8)
RSP_SG2: equ $0000200 ; SP_STATUS: Signal 2 Set (Bit 9)
RSP_SG3: equ $0000400 ; SP_STATUS: Signal 3 Set (Bit 10)
RSP_SG4: equ $0000800 ; SP_STATUS: Signal 4 Set (Bit 11)
RSP_SG5: equ $0001000 ; SP_STATUS: Signal 5 Set (Bit 12)
RSP_SG6: equ $0002000 ; SP_STATUS: Signal 6 Set (Bit 13)
RSP_SG7: equ $0004000 ; SP_STATUS: Signal 7 Set (Bit 14)

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

DMASPRD: macro start, end, dest ; DMA Data Copy MEM->RSP RAM: Start Address, End Address, Destination DRAM Address
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  lui t0,SP_MEM_BASE ; T0 = SP Memory Base Register ($A4000000)
  ori t0,dest&$1FFF ; T0 = SP Memory Address Offset ($A4000000..$A4001FFF 8KB)
  sw t0,SP_MEM_ADDR(a0) ; Store Memory Offset To SP Memory Address Register ($A4040000)
  la t0,start&$7FFFFFF ; T0 = Aligned DRAM Physical RAM Offset ($00000000..$007FFFFF 8MB)
  sw t0,SP_DRAM_ADDR(a0) ; Store RAM Offset To SP DRAM Address Register ($A4040004)
  la t0,(end-start)-1 ; T0 = Length Of DMA Transfer In Bytes - 1
  sw t0,SP_RD_LEN(a0) ; Store DMA Length To SP Read Length Register ($A4040008)
  endm

DMASPWR: macro start, end, dest ; DMA Data Copy RSP RAM->MEM: Start Address, End Address, Destination DRAM Address
  lui a0,SP_BASE ; A0 = SP Base Register ($A4040000)
  lui t0,SP_MEM_BASE ; T0 = SP Memory Base Register ($A4000000)
  ori t0,dest&$1FFF ; T0 = SP Memory Address Offset ($A4000000..$A4001FFF 8KB)
  sw t0,SP_MEM_ADDR(a0) ; Store Memory Offset To SP Memory Address Register ($A4040000)
  la t0,start&$7FFFFFF ; T0 = Aligned DRAM Physical RAM Offset ($00000000..$007FFFFF 8MB)
  sw t0,SP_DRAM_ADDR(a0) ; Store RAM Offset To SP DRAM Address Register ($A4040004)
  la t0,(end-start)-1 ; T0 = Length Of DMA Transfer In Bytes - 1
  sw t0,SP_WR_LEN(a0) ; Store DMA Length To SP Write Length Register ($A404000C)
  endm