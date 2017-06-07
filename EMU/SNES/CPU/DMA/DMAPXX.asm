DMAPHEX00:
  // $00 DMA   Transfer Mode 0: Increment Source, Transfer 1 Byte, CPU To I/O (XX)
  DMACPUSRC()            // DMA CPU Source & I/O Destination ($21XX) 
  DMACPUINCSRC0()        // DMA Transfer Bytes From CPU To I/O Using Mode 0, Increment Source
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX01:
  // $01 DMA   Transfer Mode 1: Increment Source, Transfer 2 Bytes, CPU To I/O (XX, XX+1)
  DMACPUSRC()            // DMA CPU Source & I/O Destination ($21XX)
  DMACPUINCSRC1()        // DMA Transfer Bytes From CPU To I/O Using Mode 1, Increment Source
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX02:
  // $02 DMA   Transfer Mode 2: Increment Source, Transfer 2 Bytes, CPU To I/O (XX, XX)
  DMACPUSRC()            // DMA CPU Source & I/O Destination ($21XX)
  DMACPUINCSRC2()        // DMA Transfer Bytes From CPU To I/O Using Mode 2, Increment Source
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX03:
  // $03 DMA   Transfer Mode 3: Increment Source, Transfer 4 Bytes, CPU To I/O (XX, XX, XX+1, XX+1)
  DMACPUSRC()            // DMA CPU Source & I/O Destination ($21XX)
  DMACPUINCSRC3()        // DMA Transfer Bytes From CPU To I/O Using Mode 3, Increment Source
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX04:
  // $04 DMA   Transfer Mode 4: Increment Source, Transfer 4 Bytes, CPU To I/O (XX, XX+1, XX+2, XX+3)
  DMACPUSRC()            // DMA CPU Source & I/O Destination ($21XX)
  DMACPUINCSRC4()        // DMA Transfer Bytes From CPU To I/O Using Mode 4, Increment Source
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX05:
  // $05 DMA   Transfer Mode 5: Increment Source, Transfer 4 Bytes, CPU To I/O (XX, XX+1, XX, XX+1)
  DMACPUSRC()            // DMA CPU Source & I/O Destination ($21XX)
  DMACPUINCSRC5()        // DMA Transfer Bytes From CPU To I/O Using Mode 5, Increment Source
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX08:
  // $08 DMA   Transfer Mode 0: Fixed Source, Transfer 1 Byte, CPU To I/O (xx)
  DMACPUFIXSRC()         // DMA CPU Fixed Source & I/O Destination ($21XX)
  DMACPUFIXSRC0()        // DMA Transfer Bytes From CPU To I/O Using Mode 0, Fixed Source
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX09:
  // $09 DMA   Transfer Mode 1: Fixed Source, Transfer 2 Bytes, CPU To I/O (XX, XX+1)
  DMACPUFIXSRC()         // DMA CPU Fixed Source & I/O Destination ($21XX)
  DMACPUFIXSRC1()        // DMA Transfer Bytes From CPU To I/O Using Mode 1, Fixed Source
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX0A:
  // $0A DMA   Transfer Mode 2: Fixed Source, Transfer 2 Bytes, CPU To I/O (XX, XX)
  DMACPUFIXSRC()         // DMA CPU Fixed Source & I/O Destination ($21XX)
  DMACPUFIXSRC2()        // DMA Transfer Bytes From CPU To I/O Using Mode 2, Fixed Source
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX0B:
  // $0B DMA   Transfer Mode 3: Fixed Source, Transfer 4 Bytes, CPU To I/O (XX, XX, XX+1, XX+1)
  DMACPUFIXSRC()         // DMA CPU Fixed Source & I/O Destination ($21XX)
  DMACPUFIXSRC3()        // DMA Transfer Bytes From CPU To I/O Using Mode 3, Fixed Source
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX0C:
  // $0C DMA   Transfer Mode 4: Fixed Source, Transfer 4 Bytes, CPU To I/O (XX, XX+1, XX+2, XX+3)
  DMACPUFIXSRC()         // DMA CPU Fixed Source & I/O Destination ($21XX)
  DMACPUFIXSRC4()        // DMA Transfer Bytes From CPU To I/O Using Mode 4, Fixed Source
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX0D:
  // $0D DMA   Transfer Mode 5: Fixed Source, Transfer 4 Bytes, CPU To I/O (XX, XX+1, XX, XX+1)
  DMACPUFIXSRC()         // DMA CPU Fixed Source & I/O Destination ($21XX)
  DMACPUFIXSRC5()        // DMA Transfer Bytes From CPU To I/O Using Mode 5, Fixed Source
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX10:
  // $10 DMA   Transfer Mode 0: Decrement Source, Transfer 1 Byte, CPU To I/O (XX)
  DMACPUSRC()            // DMA CPU Source & I/O Destination ($21XX) 
  DMACPUDECSRC0()        // DMA Transfer Bytes From CPU To I/O Using Mode 0, Decrement Source
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX11:
  // $11 DMA   Transfer Mode 1: Decrement Source, Transfer 2 Bytes, CPU To I/O (XX, XX+1)
  DMACPUSRC()            // DMA CPU Source & I/O Destination ($21XX)
  DMACPUDECSRC1()        // DMA Transfer Bytes From CPU To I/O Using Mode 1, Decrement Source
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX12:
  // $12 DMA   Transfer Mode 2: Decrement Source, Transfer 2 Bytes, CPU To I/O (XX, XX)
  DMACPUSRC()            // DMA CPU Source & I/O Destination ($21XX)
  DMACPUDECSRC2()        // DMA Transfer Bytes From CPU To I/O Using Mode 2, Decrement Source
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX13:
  // $13 DMA   Transfer Mode 3: Decrement Source, Transfer 4 Bytes, CPU To I/O (XX, XX, XX+1, XX+1)
  DMACPUSRC()            // DMA CPU Source & I/O Destination ($21XX)
  DMACPUDECSRC3()        // DMA Transfer Bytes From CPU To I/O Using Mode 3, Decrement Source
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX14:
  // $14 DMA   Transfer Mode 4: Decrement Source, Transfer 4 Bytes, CPU To I/O (XX, XX+1, XX+2, XX+3)
  DMACPUSRC()            // DMA CPU Source & I/O Destination ($21XX)
  DMACPUDECSRC4()        // DMA Transfer Bytes From CPU To I/O Using Mode 4, Decrement Source
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX15:
  // $15 DMA   Transfer Mode 5: Decrement Source, Transfer 4 Bytes, CPU To I/O (XX, XX+1, XX, XX+1)
  DMACPUSRC()            // DMA CPU Source & I/O Destination ($21XX)
  DMACPUDECSRC5()        // DMA Transfer Bytes From CPU To I/O Using Mode 5, Decrement Source
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX80:
  // $80 DMA   Transfer Mode 0: Increment Destination, Transfer 1 Byte, I/O To CPU (XX)
  DMACPUDST()            // DMA I/O Source & CPU Destination ($21XX) 
  DMACPUINCDST0()        // DMA Transfer Bytes From I/O To CPU Using Mode 0, Increment Destination
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX81:
  // $81 DMA   Transfer Mode 1: Increment Destination, Transfer 2 Bytes, I/O To CPU (XX, XX+1)
  DMACPUDST()            // DMA I/O Source & CPU Destination ($21XX)
  DMACPUINCDST1()        // DMA Transfer Bytes From I/O To CPU Using Mode 1, Increment Destination
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX82:
  // $82 DMA   Transfer Mode 2: Increment Destination, Transfer 2 Bytes, I/O To CPU (XX, XX)
  DMACPUDST()            // DMA I/O Source & CPU Destination ($21XX)
  DMACPUINCDST2()        // DMA Transfer Bytes From I/O To CPU Using Mode 2, Increment Destination
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX83:
  // $83 DMA   Transfer Mode 3: Increment Destination, Transfer 4 Bytes, I/O To CPU (XX, XX, XX+1, XX+1)
  DMACPUDST()            // DMA I/O Source & CPU Destination ($21XX)
  DMACPUINCDST3()        // DMA Transfer Bytes From I/O To CPU Using Mode 3, Increment Destination
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX84:
  // $84 DMA   Transfer Mode 4: Increment Destination, Transfer 4 Bytes, I/O To CPU (XX, XX+1, XX+2, XX+3)
  DMACPUDST()            // DMA I/O Source & CPU Destination ($21XX)
  DMACPUINCDST4()        // DMA Transfer Bytes From I/O To CPU Using Mode 4, Increment Destination
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX85:
  // $85 DMA   Transfer Mode 5: Increment Destination, Transfer 4 Bytes, I/O To CPU (XX, XX+1, XX, XX+1)
  DMACPUDST()            // DMA I/O Source & CPU Destination ($21XX)
  DMACPUINCDST5()        // DMA Transfer Bytes From I/O To CPU Using Mode 5, Increment Destination
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX88:
  // $88 DMA   Transfer Mode 0: Fixed Destination, Transfer 1 Byte, I/O To CPU (XX)
  DMACPUDST()            // DMA I/O Source & CPU Destination ($21XX) 
  DMACPUFIXDST0()        // DMA Transfer Bytes From I/O To CPU Using Mode 0, Fixed Destination
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX89:
  // $89 DMA   Transfer Mode 1: Fixed Destination, Transfer 2 Bytes, I/O To CPU (XX, XX+1)
  DMACPUDST()            // DMA I/O Source & CPU Destination ($21XX)
  DMACPUFIXDST1()        // DMA Transfer Bytes From I/O To CPU Using Mode 1, Fixed Destination
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX8A:
  // $8A DMA   Transfer Mode 2: Fixed Destination, Transfer 2 Bytes, I/O To CPU (XX, XX)
  DMACPUDST()            // DMA I/O Source & CPU Destination ($21XX)
  DMACPUFIXDST2()        // DMA Transfer Bytes From I/O To CPU Using Mode 2, Fixed Destination
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX8B:
  // $8B DMA   Transfer Mode 3: Fixed Destination, Transfer 4 Bytes, I/O To CPU (XX, XX, XX+1, XX+1)
  DMACPUDST()            // DMA I/O Source & CPU Destination ($21XX)
  DMACPUFIXDST3()        // DMA Transfer Bytes From I/O To CPU Using Mode 3, Fixed Destination
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX8C:
  // $8C DMA   Transfer Mode 4: Fixed Destination, Transfer 4 Bytes, I/O To CPU (XX, XX+1, XX+2, XX+3)
  DMACPUDST()            // DMA I/O Source & CPU Destination ($21XX)
  DMACPUFIXDST4()        // DMA Transfer Bytes From I/O To CPU Using Mode 4, Fixed Destination
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX8D:
  // $8D DMA   Transfer Mode 5: Fixed Destination, Transfer 4 Bytes, I/O To CPU (XX, XX+1, XX, XX+1)
  DMACPUDST()            // DMA I/O Source & CPU Destination ($21XX)
  DMACPUFIXDST5()        // DMA Transfer Bytes From I/O To CPU Using Mode 5, Fixed Destination
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX90:
  // $90 DMA   Transfer Mode 0: Decrement Destination, Transfer 1 Byte, I/O To CPU (XX)
  DMACPUDST()            // DMA I/O Source & CPU Destination ($21XX) 
  DMACPUDECDST0()        // DMA Transfer Bytes From I/O To CPU Using Mode 0, Decrement Destination
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX91:
  // $91 DMA   Transfer Mode 1: Decrement Destination, Transfer 2 Bytes, I/O To CPU (XX, XX+1)
  DMACPUDST()            // DMA I/O Source & CPU Destination ($21XX)
  DMACPUDECDST1()        // DMA Transfer Bytes From I/O To CPU Using Mode 1, Decrement Destination
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX92:
  // $92 DMA   Transfer Mode 2: Decrement Destination, Transfer 2 Bytes, I/O To CPU (XX, XX)
  DMACPUDST()            // DMA I/O Source & CPU Destination ($21XX)
  DMACPUDECDST2()        // DMA Transfer Bytes From I/O To CPU Using Mode 2, Decrement Destination
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX93:
  // $93 DMA   Transfer Mode 3: Decrement Destination, Transfer 4 Bytes, I/O To CPU (XX, XX, XX+1, XX+1)
  DMACPUDST()            // DMA I/O Source & CPU Destination ($21XX)
  DMACPUDECDST3()        // DMA Transfer Bytes From I/O To CPU Using Mode 3, Decrement Destination
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX94:
  // $94 DMA   Transfer Mode 4: Decrement Destination, Transfer 4 Bytes, I/O To CPU (XX, XX+1, XX+2, XX+3)
  DMACPUDST()            // DMA I/O Source & CPU Destination ($21XX)
  DMACPUDECDST4()        // DMA Transfer Bytes From I/O To CPU Using Mode 4, Decrement Destination
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX95:
  // $95 DMA   Transfer Mode 5: Decrement Destination, Transfer 4 Bytes, I/O To CPU (XX, XX+1, XX, XX+1)
  DMACPUDST()            // DMA I/O Source & CPU Destination ($21XX)
  DMACPUDECDST5()        // DMA Transfer Bytes From I/O To CPU Using Mode 5, Decrement Destination
  j MDMAENCHECK
  nop                    // Delay Slot