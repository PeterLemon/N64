DMAPHEX00:
  // $00 DMA   Transfer Mode 0: Increment Source, Transfer 1 Byte, CPU To I/O (XX)
  DMAIOSRC()             // DMA CPU Source & I/O Destination ($21XX) 
  DMACPUINCSRC0()        // DMA Transfer Bytes From CPU To I/O Using Mode 0, Increment Source
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX01:
  // $01 DMA   Transfer Mode 1: Increment Source, Transfer 2 Bytes, CPU To I/O (XX, XX+1)
  DMAIOSRC()             // DMA CPU Source & I/O Destination ($21XX)
  DMACPUINCSRC1()        // DMA Transfer Bytes From CPU To I/O Using Mode 1, Increment Source
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX02:
  // $02 DMA   Transfer Mode 2: Increment Source, Transfer 2 Bytes, CPU To I/O (XX, XX)
  DMAIOSRC()             // DMA CPU Source & I/O Destination ($21XX)
  DMACPUINCSRC2()        // DMA Transfer Bytes From CPU To I/O Using Mode 2, Increment Source
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX03:
  // $03 DMA   Transfer Mode 3: Increment Source, Transfer 4 Bytes, CPU To I/O (XX, XX, XX+1, XX+1)
  DMAIOSRC()             // DMA CPU Source & I/O Destination ($21XX)
  DMACPUINCSRC3()        // DMA Transfer Bytes From CPU To I/O Using Mode 3, Increment Source
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX04:
  // $04 DMA   Transfer Mode 4: Increment Source, Transfer 4 Bytes, CPU To I/O (XX, XX+1, XX+2, XX+3)
  DMAIOSRC()             // DMA CPU Source & I/O Destination ($21XX)
  DMACPUINCSRC4()        // DMA Transfer Bytes From CPU To I/O Using Mode 4, Increment Source
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX05:
  // $05 DMA   Transfer Mode 5: Increment Source, Transfer 4 Bytes, CPU To I/O (XX, XX+1, XX, XX+1)
  DMAIOSRC()             // DMA CPU Source & I/O Destination ($21XX)
  DMACPUINCSRC5()        // DMA Transfer Bytes From CPU To I/O Using Mode 5, Increment Source
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX08:
  // $08 DMA   Transfer Mode 0: Fixed Source, Transfer 1 Byte, CPU To I/O (xx)
  DMAIOFIXSRC()          // DMA CPU Fixed Source & I/O Destination ($21XX)
  DMACPUFIXSRC0()        // DMA Transfer Bytes From CPU To I/O Using Mode 0, Fixed Source
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX09:
  // $09 DMA   Transfer Mode 1: Fixed Source, Transfer 2 Bytes, CPU To I/O (XX, XX+1)
  DMAIOFIXSRC()          // DMA CPU Fixed Source & I/O Destination ($21XX)
  DMACPUFIXSRC1()        // DMA Transfer Bytes From CPU To I/O Using Mode 1, Fixed Source
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX0A:
  // $0A DMA   Transfer Mode 2: Fixed Source, Transfer 2 Bytes, CPU To I/O (XX, XX)
  DMAIOFIXSRC()          // DMA CPU Fixed Source & I/O Destination ($21XX)
  DMACPUFIXSRC2()        // DMA Transfer Bytes From CPU To I/O Using Mode 2, Fixed Source
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX0B:
  // $0B DMA   Transfer Mode 3: Fixed Source, Transfer 4 Bytes, CPU To I/O (XX, XX, XX+1, XX+1)
  DMAIOFIXSRC()          // DMA CPU Fixed Source & I/O Destination ($21XX)
  DMACPUFIXSRC3()        // DMA Transfer Bytes From CPU To I/O Using Mode 3, Fixed Source
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX0C:
  // $0C DMA   Transfer Mode 4: Fixed Source, Transfer 4 Bytes, CPU To I/O (XX, XX+1, XX+2, XX+3)
  DMAIOFIXSRC()          // DMA CPU Fixed Source & I/O Destination ($21XX)
  DMACPUFIXSRC4()        // DMA Transfer Bytes From CPU To I/O Using Mode 4, Fixed Source
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX0D:
  // $0D DMA   Transfer Mode 5: Fixed Source, Transfer 4 Bytes, CPU To I/O (XX, XX+1, XX, XX+1)
  DMAIOFIXSRC()          // DMA CPU Fixed Source & I/O Destination ($21XX)
  DMACPUFIXSRC5()        // DMA Transfer Bytes From CPU To I/O Using Mode 5, Fixed Source
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX10:
  // $10 DMA   Transfer Mode 0: Decrement Source, Transfer 1 Byte, CPU To I/O (XX)
  DMAIOSRC()             // DMA CPU Source & I/O Destination ($21XX) 
  DMACPUDECSRC0()        // DMA Transfer Bytes From CPU To I/O Using Mode 0, Decrement Source
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX11:
  // $11 DMA   Transfer Mode 1: Decrement Source, Transfer 2 Bytes, CPU To I/O (XX, XX+1)
  DMAIOSRC()             // DMA CPU Source & I/O Destination ($21XX)
  DMACPUDECSRC1()        // DMA Transfer Bytes From CPU To I/O Using Mode 1, Decrement Source
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX12:
  // $12 DMA   Transfer Mode 2: Decrement Source, Transfer 2 Bytes, CPU To I/O (XX, XX)
  DMAIOSRC()             // DMA CPU Source & I/O Destination ($21XX)
  DMACPUDECSRC2()        // DMA Transfer Bytes From CPU To I/O Using Mode 2, Decrement Source
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX13:
  // $13 DMA   Transfer Mode 3: Decrement Source, Transfer 4 Bytes, CPU To I/O (XX, XX, XX+1, XX+1)
  DMAIOSRC()             // DMA CPU Source & I/O Destination ($21XX)
  DMACPUDECSRC3()        // DMA Transfer Bytes From CPU To I/O Using Mode 3, Decrement Source
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX14:
  // $14 DMA   Transfer Mode 4: Decrement Source, Transfer 4 Bytes, CPU To I/O (XX, XX+1, XX+2, XX+3)
  DMAIOSRC()             // DMA CPU Source & I/O Destination ($21XX)
  DMACPUDECSRC4()        // DMA Transfer Bytes From CPU To I/O Using Mode 4, Decrement Source
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX15:
  // $15 DMA   Transfer Mode 5: Decrement Source, Transfer 4 Bytes, CPU To I/O (XX, XX+1, XX, XX+1)
  DMAIOSRC()             // DMA CPU Source & I/O Destination ($21XX)
  DMACPUDECSRC5()        // DMA Transfer Bytes From CPU To I/O Using Mode 5, Decrement Source
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX80:
  // $80 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX81:
  // $81 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX82:
  // $82 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX83:
  // $83 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX84:
  // $84 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX85:
  // $85 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX86:
  // $86 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX87:
  // $87 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX88:
  // $88 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX89:
  // $89 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX8A:
  // $8A DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX8B:
  // $8B DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX8C:
  // $8C DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX8D:
  // $8D DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX8E:
  // $8E DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX8F:
  // $8F DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX90:
  // $90 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX91:
  // $91 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX92:
  // $92 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX93:
  // $93 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX94:
  // $94 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX95:
  // $95 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX96:
  // $96 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX97:
  // $97 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX98:
  // $98 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX99:
  // $99 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX9A:
  // $9A DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX9B:
  // $9B DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX9C:
  // $9C DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX9D:
  // $9D DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX9E:
  // $9E DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEX9F:
  // $9F DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXA0:
  // $A0 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXA1:
  // $A1 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXA2:
  // $A2 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXA3:
  // $A3 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXA4:
  // $A4 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXA5:
  // $A5 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXA6:
  // $A6 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXA7:
  // $A7 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXA8:
  // $A8 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXA9:
  // $A9 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXAA:
  // $AA DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXAB:
  // $AB DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXAC:
  // $AC DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXAD:
  // $AD DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXAE:
  // $AE DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXAF:
  // $AF DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXB0:
  // $B0 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXB1:
  // $B1 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXB2:
  // $B2 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXB3:
  // $B3 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXB4:
  // $B4 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXB5:
  // $B5 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXB6:
  // $B6 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXB7:
  // $B7 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXB8:
  // $B8 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXB9:
  // $B9 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXBA:
  // $BA DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXBB:
  // $BB DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXBC:
  // $BC DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXBD:
  // $BD DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXBE:
  // $BE DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXBF:
  // $BF DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXC0:
  // $C0 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXC1:
  // $C1 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXC2:
  // $C2 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXC3:
  // $C3 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXC4:
  // $C4 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXC5:
  // $C5 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXC6:
  // $C6 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXC7:
  // $C7 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXC8:
  // $C8 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXC9:
  // $C9 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXCA:
  // $CA DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXCB:
  // $CB DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXCC:
  // $CC DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXCD:
  // $CD DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXCE:
  // $CE DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXCF:
  // $CF DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXD0:
  // $D0 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXD1:
  // $D1 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXD2:
  // $D2 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXD3:
  // $D3 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXD4:
  // $D4 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXD5:
  // $D5 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXD6:
  // $D6 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXD7:
  // $D7 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXD8:
  // $D8 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXD9:
  // $D9 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXDA:
  // $DA DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXDB:
  // $DB DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXDC:
  // $DC DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXDD:
  // $DD DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXDE:
  // $DE DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXDF:
  // $DF DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXE0:
  // $E0 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXE1:
  // $E1 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXE2:
  // $E2 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXE3:
  // $E3 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXE4:
  // $E4 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXE5:
  // $E5 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXE6:
  // $E6 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXE7:
  // $E7 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXE8:
  // $E8 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXE9:
  // $E9 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXEA:
  // $EA DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXEB:
  // $EB DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXEC:
  // $EC DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXED:
  // $ED DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXEE:
  // $EE DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXEF:
  // $EF DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXF0:
  // $F0 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXF1:
  // $F1 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXF2:
  // $F2 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXF3:
  // $F3 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXF4:
  // $F4 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXF5:
  // $F5 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXF6:
  // $F6 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXF7:
  // $F7 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXF8:
  // $F8 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXF9:
  // $F9 DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXFA:
  // $FA DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXFB:
  // $FB DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXFC:
  // $FC DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXFD:
  // $FD DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXFE:
  // $FE DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot

DMAPHEXFF:
  // $FF DMA   ???               ?????
  j MDMAENCHECK
  nop                    // Delay Slot