;============= 
; N64 Include
;=============
; Memory Map
RDRAM: equ $A000 ; $00000000..$003FFFFF RDRAM Memory 4MB ($00000000..$007FFFFF 8MB With Expansion Pak)

RDRAM_BASE:       equ $A3F0 ; $03F00000..$03F00027 RDRAM Base Register
RDRAM_DEVICE_TYPE:  equ $00 ; $03F00000..$03F00003 RDRAM: Device Type Register
RDRAM_DEVICE_ID:    equ $04 ; $03F00004..$03F00007 RDRAM: Device ID Register
RDRAM_DELAY:        equ $08 ; $03F00008..$03F0000B RDRAM: Delay Register
RDRAM_MODE:         equ $0C ; $03F0000C..$03F0000F RDRAM: Mode Register
RDRAM_REF_INTERVAL: equ $10 ; $03F00010..$03F00013 RDRAM: Ref Interval Register
RDRAM_REF_ROW:      equ $14 ; $03F00014..$03F00017 RDRAM: Ref Row Register
RDRAM_RAS_INTERVAL: equ $18 ; $03F00018..$03F0001B RDRAM: Ras Interval Register
RDRAM_MIN_INTERVAL: equ $1C ; $03F0001C..$03F0001F RDRAM: Minimum Interval Register
RDRAM_ADDR_SELECT:  equ $20 ; $03F00020..$03F00023 RDRAM: Address Select Register
RDRAM_DEVICE_MANUF: equ $24 ; $03F00024..$03F00027 RDRAM: Device Manufacturer Register

SP_MEM_BASE: equ $A400 ; $04000000..$04000FFF SP MEM Base Register
SP_DMEM:     equ $0000 ; $04000000..$04000FFF SP: RSP DMEM (4096 Bytes)
SP_IMEM:     equ $1000 ; $04001000..$04001FFF SP: RSP IMEM (4096 Bytes)

SP_BASE:    equ $A404 ; $04040000..$0404001F SP Base Register
SP_MEM_ADDR:  equ $00 ; $04040000..$04040003 SP: Master, SP Memory Address Register
SP_DRAM_ADDR: equ $04 ; $04040004..$04040007 SP: Slave, SP DRAM DMA Address Register
SP_RD_LEN:    equ $08 ; $04040008..$0404000B SP: Read DMA Length Register
SP_WR_LEN:    equ $0C ; $0404000C..$0404000F SP: Write DMA Length Register
SP_STATUS:    equ $10 ; $04040010..$04040013 SP: Status Register
SP_DMA_FULL:  equ $14 ; $04040014..$04040017 SP: DMA Full Register
SP_DMA_BUSY:  equ $18 ; $04040018..$0404001B SP: DMA Busy Register
SP_SEMAPHORE: equ $1C ; $0404001C..$0404001F SP: Semaphore Register

SP_PC_BASE:  equ $A408 ; $04080000..$04080007 SP PC Base Register
SP_PC:         equ $00 ; $04080000..$04080003 SP: PC Register
SP_IBIST_REG:  equ $04 ; $04080004..$04080007 SP: IMEM BIST Register

DPC_BASE:   equ $A410 ; $04100000..$0410001F DP Command (DPC) Base Register
DPC_START:    equ $00 ; $04100000..$04100003 DPC: CMD DMA Start Register
DPC_END:      equ $04 ; $04100004..$04100007 DPC: CMD DMA End Register
DPC_CURRENT:  equ $08 ; $04100008..$0410000B DPC: CMD DMA Current Register
DPC_STATUS:   equ $0C ; $0410000C..$0410000F DPC: CMD Status Register
DPC_CLOCK:    equ $10 ; $04100010..$04100013 DPC: Clock Counter Register
DPC_BUFBUSY:  equ $14 ; $04100014..$04100017 DPC: Buffer Busy Counter Register
DPC_PIPEBUSY: equ $18 ; $04100018..$0410001B DPC: Pipe Busy Counter Register
DPC_TMEM:     equ $1C ; $0410001C..$0410001F DPC: TMEM Load Counter Register

DPS_BASE:       equ $A420 ; $04200000..$0420000F DP Span (DPS) Base Register
DPS_TBIST:        equ $00 ; $04200000..$04200003 DPS: Tmem Bist Register
DPS_TEST_MODE:    equ $04 ; $04200004..$04200007 DPS: Span Test Mode Register
DPS_BUFTEST_ADDR: equ $08 ; $04200008..$0420000B DPS: Span Buffer Test Address Register
DPS_BUFTEST_DATA: equ $0C ; $0420000C..$0420000F DPS: Span Buffer Test Data Register

MI_BASE:    equ $A430 ; $04300000..$0430000F MIPS Interface (MI) Base Register
MI_INIT_MODE: equ $00 ; $04300000..$04300003 MI: Init Mode Register
MI_VERSION:   equ $04 ; $04300004..$04300007 MI: Version Register
MI_INTR:      equ $08 ; $04300008..$0430000B MI: Interrupt Register
MI_INTR_MASK: equ $0C ; $0430000C..$0430000F MI: Interrupt Mask Register

VI_BASE:         equ $A440 ; $04400000..$04400037 Video Interface (VI) Base Register
VI_STATUS:         equ $00 ; $04400000..$04400003 VI: Status/Control Register
VI_ORIGIN:         equ $04 ; $04400004..$04400007 VI: Origin Register
VI_WIDTH:          equ $08 ; $04400008..$0440000B VI: Width Register
VI_V_INTR:         equ $0C ; $0440000C..$0440000F VI: Vertical Interrupt Register
VI_V_CURRENT_LINE: equ $10 ; $04400010..$04400013 VI: Current Vertical Line Register
VI_TIMING:         equ $14 ; $04400014..$04400017 VI: Video Timing Register
VI_V_SYNC:         equ $18 ; $04400018..$0440001B VI: Vertical Sync Register
VI_H_SYNC:         equ $1C ; $0440001C..$0440001F VI: Horizontal Sync Register
VI_H_SYNC_LEAP:    equ $20 ; $04400020..$04400023 VI: Horizontal Sync Leap Register
VI_H_VIDEO:        equ $24 ; $04400024..$04400027 VI: Horizontal Video Register
VI_V_VIDEO:        equ $28 ; $04400028..$0440002B VI: Vertical Video Register
VI_V_BURST:        equ $2C ; $0440002C..$0440002F VI: Vertical Burst Register
VI_X_SCALE:        equ $30 ; $04400030..$04400033 VI: X-Scale Register
VI_Y_SCALE:        equ $34 ; $04400034..$04400037 VI: Y-Scale Register

AI_BASE:    equ $A450 ; $04500000..$04500017 Audio Interface (AI) Base Register
AI_DRAM_ADDR: equ $00 ; $04500000..$04500003 AI: DRAM Address Register
AI_LEN:       equ $04 ; $04500004..$04500007 AI: Length Register
AI_CONTROL:   equ $08 ; $04500008..$0450000B AI: Control Register
AI_STATUS:    equ $0C ; $0450000C..$0450000F AI: Status Register
AI_DACRATE:   equ $10 ; $04500010..$04500013 AI: DAC Sample Period Register
AI_BITRATE:   equ $14 ; $04500014..$04500017 AI: Bit Rate Register

PI_BASE:       equ $A460 ; $04600000..$04600033 Peripheral Interface (PI) Base Register
PI_DRAM_ADDR:    equ $00 ; $04600000..$04600003 PI: DRAM Address Register
PI_CART_ADDR:    equ $04 ; $04600004..$04600007 PI: Pbus (Cartridge) Address Register
PI_RD_LEN:       equ $08 ; $04600008..$0460000B PI: Read Length Register
PI_WR_LEN:       equ $0C ; $0460000C..$0460000F PI: Write length register
PI_STATUS:       equ $10 ; $04600010..$04600013 PI: Status Register
PI_BSD_DOM1_LAT: equ $14 ; $04600014..$04600017 PI: Domain 1 Latency Register
PI_BSD_DOM1_PWD: equ $18 ; $04600018..$0460001B PI: Domain 1 Pulse Width Register
PI_BSD_DOM1_PGS: equ $1C ; $0460001C..$0460001F PI: Domain 1 Page Size Register
PI_BSD_DOM1_RLS: equ $20 ; $04600020..$04600023 PI: Domain 1 Release Register
PI_BSD_DOM2_LAT: equ $24 ; $04600024..$04600027 PI: Domain 2 Latency Register
PI_BSD_DOM2_PWD: equ $28 ; $04600028..$0460002B PI: Domain 2 Pulse Width Register
PI_BSD_DOM2_PGS: equ $2C ; $0460002C..$0460002F PI: Domain 2 Page Size Register
PI_BSD_DOM2_RLS: equ $30 ; $04600030..$04600033 PI: Domain 2 Release Register

RI_BASE:       equ $A470 ; $04700000..$0470001F RDRAM Interface (RI) Base Register
RI_MODE:         equ $00 ; $04700000..$04700003 RI: Mode Register
RI_CONFIG:       equ $04 ; $04700004..$04700007 RI: Config Register
RI_CURRENT_LOAD: equ $08 ; $04700008..$0470000B RI: Current Load Register
RI_SELECT:       equ $0C ; $0470000C..$0470000F RI: Select Register
RI_REFRESH:      equ $10 ; $04700010..$04700013 RI: Refresh Register
RI_LATENCY:      equ $14 ; $04700014..$04700017 RI: Latency Register
RI_RERROR:       equ $18 ; $04700018..$0470001B RI: Read Error Register
RI_WERROR:       equ $1C ; $0470001C..$0470001F RI: Write Error Register

SI_BASE:         equ $A480 ; $04800000..$0480001B Serial Interface (SI) Base Register
SI_DRAM_ADDR:      equ $00 ; $04800000..$04800003 SI: DRAM Address Register
SI_PIF_ADDR_RD64B: equ $04 ; $04800004..$04800007 SI: Address Read 64B Register
;*RESERVED*:       equ $08 ; $04800008..$0480000B SI: Reserved Register
;*RESERVED*:       equ $0C ; $0480000C..$0480000F SI: Reserved Register
SI_PIF_ADDR_WR64B: equ $10 ; $04800010..$04800013 SI: Address Write 64B Register
;*RESERVED*:       equ $14 ; $04800014..$04800017 SI: Reserved Register
SI_STATUS:         equ $18 ; $04800018..$0480001B SI: Status Register

CART_DOM2_ADDR1: equ $A500 ; $05000000..$0507FFFF Cartridge Domain 2(Address 1) SRAM
CART_DOM1_ADDR1: equ $A600 ; $06000000..$07FFFFFF Cartridge Domain 1(Address 1) 64DD
CART_DOM1_ADDR2: equ $B000 ; $10000000..$18000803 Cartridge Domain 1(Address 2) ROM

PIF_BASE: equ $BFC0 ; $1FC00000..$1FC007BF PIF Base Register
PIF_ROM:   equ $000 ; $1FC00000..$1FC007BF PIF: Boot ROM
PIF_RAM:   equ $7C0 ; $1FC007C0..$1FC007FF PIF: RAM (JoyChannel)
PIF_HWORD: equ $7C4 ; $1FC007C4..$1FC007C5 PIF: HWORD
PIF_XBYTE: equ $7C6 ; $1FC007C6 PIF: Analog X Byte
PIF_YBYTE: equ $7C7 ; $1FC007C7 PIF: Analog Y Byte

VI_NTSC_CLOCK equ 48681812 ; NTSC: Hz = 48.681812 MHz
VI_PAL_CLOCK  equ 49656530 ; PAL:  Hz = 49.656530 MHz
VI_MPAL_CLOCK equ 48628316 ; MPAL: Hz = 48.628316 MHz

; Setup asmn64
  datasize 8 ; Set Data Size to 8 (Allows Long Data)

align: macro amount
  cnop 0, amount ; Align Byte Amount
  endm

DMA: macro start, end, dest ; DMA Data Copy Cart->DRAM: Start Cart Address, End Cart Address, Destination DRAM Address
  lui t0,PI_BASE ; PI Base Reg: Init DMA
  DMABusy\@:
    lb t1,PI_STATUS(t0) ; Load Byte From PI Status Reg $A4600010
    sync ; Sync Load
    andi t1,3 ; And PI Status With 3
    bnez t1,DMABusy\@ ; If True DMA Is Busy
    nop ; Delay Slot

    la t1,dest&$7FFFFF ; Aligned DRAM Physical RAM Offset ($00000000..$007FFFFF 8MB)
    sw t1,PI_DRAM_ADDR(t0) ; Store RAM Offset To PI DRAM Address Reg $A4600000
    la t1,$10000000|(start&$3FFFFFF) ; Aligned Cart Physical ROM Offset ($10000000..$13FFFFFF 64MB)
    sw t1,PI_CART_ADDR(t0) ; Store ROM Offset To PI Cart Address Reg $A4600004
    la t1,(end-start)-1 ; Length Of DMA Transfer In Bytes - 1
    sw t1,PI_WR_LEN(t0) ; Store DMA Length To PI Write Length Reg $A460000C
  endm