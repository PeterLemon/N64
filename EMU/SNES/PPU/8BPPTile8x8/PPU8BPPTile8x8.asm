// N64 'Bare Metal' 16BPP 320x240 SNES PPU 8BPP Tile 8x8 Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "PPU8BPPTile8x8.N64", create
fill 1052672 // Set ROM Size

origin $00000000
base $80000000 // Entry Point Of Code
include "LIB/N64.INC" // Include N64 Definitions
include "LIB/N64_HEADER.ASM" // Include 64 Byte Header & Vector Table
insert "LIB/N64_BOOTCODE.BIN" // Include 4032 Byte Boot Code

Start:
  include "LIB/N64_GFX.INC" // Include Graphics Macros
  include "LIB/N64_RSP.INC" // Include RSP Macros
  N64_INIT() // Run N64 Initialisation Routine

  ScreenNTSC(320, 240, BPP16, $A0100000) // Screen NTSC: 320x240, 16BPP, DRAM Origin $A0100000

  WaitScanline($200) // Wait For Scanline To Reach Vertical Blank

// Convert SNES Palette To N64 TLUT
  // Load RSP Code To IMEM
  DMASPRD(RSPPALCode, RSPPALCodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  SetSPPC(RSPPALStart) // Set RSP Program Counter: Start Address
  StartSP() // Start RSP Execution: RSP Status = Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break

DelayPAL: // Wait For RSP To Compute
  lwu t0,SP_STATUS(a0) // T0 = RSP Status
  andi t0,RSP_HLT // RSP Status &= RSP Halt Flag
  beqz t0,DelayPAL // IF (RSP Halt Flag == 0) Delay PAL
  nop // Delay Slot


// Copy SNES Clear Color To RDP List
la a0,N64TLUT // A0 = N64 TLUT Address
la a1,RDPSNESCLEARCOL+4 // A1 = N64 RDP SNES Clear Color Address
lhu t0,0(a0) // T0 = TLUT Color 0
sh t0,0(a1) // Store Color 0 To RDP Fill Color Hi
sh t0,2(a1) // Store Color 0 To RDP Fill Color Lo


// Convert SNES Tiles To N64 Linear Texture
  // Load RSP Code To IMEM
  DMASPRD(RSPTILECode, RSPTILECodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  DMASPWait() // Wait For RSP DMA To Finish

  SetSPPC(RSPTILEStart) // Set RSP Program Counter: Start Address
  StartSP() // Start RSP Execution: RSP Status = Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break

DelayTILES: // Wait For RSP To Compute
  lwu t0,SP_STATUS(a0) // T0 = RSP Status
  andi t0,RSP_HLT // RSP Status &= RSP Halt Flag
  beqz t0,DelayTILES // IF (RSP Halt Flag == 0) Delay TILES
  nop // Delay Slot


// Convert SNES Tile Map To RDP List
la a0,SNESMAP // A0 = SNES Tile Map Address
la a1,$A0000000|((RDPSNESTILE+12)&$3FFFFFF) // A1 = N64 RDP SNES Tile Map Address
la a2,N64TILE // A2 = N64 Tile Address
ori t0,r0,895 // T0 = Number Of Tiles To Convert
MAPLoop:
  lbu t1,0(a0) // T1 = SNES Tile Map # Lo Byte
  lbu t2,1(a0) // T2 = SNES Tile Map # Hi Byte
  addiu a0,2   // A0 += 2
  sll t2,8     // T2 <<= 8
  or t1,t2     // T1 != T2 
  sll t1,6     // T1 *= 64
  addu t1,a2   // T1 += N64 Tile Address
  sw t1,0(a1)  // Store SNES Tile Map # To N64 RDP SNES Tile Map
  addiu a1,40  // A1 += 40
  bnez t0,MAPLoop // IF (Number Of Tiles To Convert != 0) Map Loop
  subiu t0,1 // Decrement Number Of Tiles To Convert (Delay Slot)

WaitScanline($200) // Wait For Scanline To Reach Vertical Blank

DPC(RDPBuffer, RDPBufferEnd) // Run DPC Command Buffer: Start Address, End Address

Loop:
  j Loop
  nop // Delay Slot

align(8) // Align 64-Bit
N64TLUT:
  fill 512 // Generates 512 Bytes Containing $00

align(8) // Align 64-Bit
N64TILE:
  fill 65536 // Generates 65536 Bytes Containing $00

align(8) // Align 64-Bit
insert SNESPAL, "BG.pal"

align(8) // Align 64-Bit
insert SNESTILE, "BG.pic"

align(8) // Align 64-Bit
insert SNESMAP, "BG.map" // SNES 32x32 Background Tile Map (2048 Bytes)

align(8) // Align 64-Bit
RSPPALData:
base $0000 // Set Base Of RSP Data Object To Zero

// Uses Whole Vector For 1st 8 Colors To Preserve SNES Palette Color 0 Alpha
// Uses Element 9 To OR Vector By Scalar $0001 For Other Colors
AlphaOR:
  dh $0000, $0001, $0001, $0001, $0001, $0001, $0001, $0001
  // 1 * $0000, 7 * $0001 (OR Alpha 1 Bit) (1st 8 Colors)
  // $0001 (OR Alpha 1 Bit) (Other Colors) (e9)

// Uses Elements 8..12 To AND Vector By Scalar
ANDByte:
  dh $00FF, $FF00, $001F, $03E0, $7C00, $0000, $0000, $0000
  // $00FF (AND Lo Byte) (e8)
  // $FF00 (AND Hi Byte) (e9)
  // $001F (AND Red   5 Bits) (e10)
  // $03E0 (AND Green 5 Bits) (e11)
  // $7C00 (AND Blue  5 Bits) (e12)

// Uses Elements 8..11 To Multiply Vector By Scalar For Pseudo Vector Shifts
PALShift:
  dh $0100, $0800, $0002, $0080
  // $0100 (Left Shift Using Multiply: << 8), (Right Shift Using Multiply: >> 8) (Big-Endian Convert) (e8)
  // $0800 (Left Shift Using Multiply: << 11) (Red) (e9)
  // $0002 (Left Shift Using Multiply: << 1)  (Green) (e10)
  // $0080 (Right Shift Using Multiply: >> 9) (Blue) (e11)

align(8) // Align 64-Bit
base RSPPALData+pc() // Set End Of RSP Data Object
RSPPALDataEnd:


align(8) // Align 64-Bit
RSPSHIFTData:
base $0000 // Set Base Of RSP Data Object To Zero

// Uses Elements 8..15 To Multiply Vector By Scalar For Pseudo Vector Shifts
ShiftLeftRightA:
  dh $0001, $0002, $0004, $0008, $0010, $0020, $0040, $0080
  // $0001 (Left Shift Using Multiply: << 0),  (Right Shift Using Multiply: >> 16) (e8)
  // $0002 (Left Shift Using Multiply: << 1),  (Right Shift Using Multiply: >> 15) (e9)
  // $0004 (Left Shift Using Multiply: << 2),  (Right Shift Using Multiply: >> 14) (e10)
  // $0008 (Left Shift Using Multiply: << 3),  (Right Shift Using Multiply: >> 13) (e11)
  // $0010 (Left Shift Using Multiply: << 4),  (Right Shift Using Multiply: >> 12) (e12)
  // $0020 (Left Shift Using Multiply: << 5),  (Right Shift Using Multiply: >> 11) (e13)
  // $0040 (Left Shift Using Multiply: << 6),  (Right Shift Using Multiply: >> 10) (e14)
  // $0080 (Left Shift Using Multiply: << 7),  (Right Shift Using Multiply: >> 9)  (e15)
ShiftLeftRightB:
  dh $0100, $0200, $0400, $0800, $1000, $2000, $4000, $8000
  // $0100 (Left Shift Using Multiply: << 8),  (Right Shift Using Multiply: >> 8) (e8)
  // $0200 (Left Shift Using Multiply: << 9),  (Right Shift Using Multiply: >> 7) (e9)
  // $0400 (Left Shift Using Multiply: << 10), (Right Shift Using Multiply: >> 6) (e10)
  // $0800 (Left Shift Using Multiply: << 11), (Right Shift Using Multiply: >> 5) (e11)
  // $1000 (Left Shift Using Multiply: << 12), (Right Shift Using Multiply: >> 4) (e12)
  // $2000 (Left Shift Using Multiply: << 13), (Right Shift Using Multiply: >> 3) (e13)
  // $4000 (Left Shift Using Multiply: << 14), (Right Shift Using Multiply: >> 2) (e14)
  // $8000 (Left Shift Using Multiply: << 15), (Right Shift Using Multiply: >> 1) (e15)

align(8) // Align 64-Bit
base RSPSHIFTData+pc() // Set End Of RSP Data Object
RSPSHIFTDataEnd:


align(8) // Align 64-Bit
RSPPALCode:
arch n64.rsp
base $0000 // Set Base Of RSP Code Object To Zero

RSPPALStart:
// Load Static Palette Data
  RSPDMASPRD(RSPPALData, RSPPALDataEnd, SP_DMEM) // RSP DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  RSPDMASPWait() // Wait For RSP DMA To Finish

  lqv v0[e0],AlphaOR(r0)  // V0 = 1 * $0000, 7 * $0001 (OR Alpha 1 Bit) (128-Bit Quad)
  lqv v1[e0],ANDByte(r0)  // V1 = AND Lo/Hi/Red/Green/Blue Bytes (128-Bit Quad)
  ldv v2[e0],PALShift(r0) // V2 = Shift Using Multiply: Red/Green/Blue (64-Bit Double)

// Decode Colors
  ori a0,r0,0 // A0 = Palette Start Offset
  la a1,N64TLUT // A1 = Aligned DRAM Physical RAM Offset ($00000000..$007FFFFF 8MB)
  la a2,SNESPAL // A2 = Aligned DRAM Physical RAM Offset ($00000000..$007FFFFF 8MB)

  ori t0,r0,511 // T0 = Length Of DMA Transfer In Bytes - 1
  ori t1,r0,30 // T1 = Color Counter

  mtc0 a0,c0 // Store Memory Offset To SP Memory Address Register ($A4040000)
  mtc0 a2,c1 // Store RAM Offset To SP DRAM Address Register ($A4040004)
  mtc0 t0,c2 // Store DMA Length To SP Read Length Register ($A4040008)

  RSPDMASPWait() // Wait For RSP DMA To Finish

// Vector Grab 1st 8 Colors:
  lqv v3[e0],0(a0) // V3 = Palette Colors 0..7

  vand v4,v3,v1[e8] // V4 = Lo Byte Color 0..7 (& $00FF)
  vand v5,v3,v1[e9] // V5 = Hi Byte Color 0..7 (& $FF00)
  vmudn v4,v2[e8]   // V4 = Lo Byte Color 0..7 << 8
  vmudl v5,v2[e8]   // V5 = Hi Byte Color 0..7 >> 8
  vor v4,v5[e0]     // V4 = Color 0..7 Big-Endian

  vand v5,v4,v1[e10] // V5 = RED 5 Bits, Color 0..7 (& $001F)
  vmudn v5,v2[e9]    // V5 = RED 5 Bits, Color 0..7 << 11

  vand v6,v4,v1[e11] // V6 = GREEN 5 Bits, Color 0..7 (& $03E0)
  vmudn v6,v2[e10]   // V6 = GREEN 5 Bits, Color 0..7 << 1
  vor v5,v6[e0]      // V5 = RED,GREEN 10 Bits, Color 0..7

  vand v6,v4,v1[e12] // V6 = BLUE 5 Bits, Color 0..7 (& $7C00)
  vmudl v6,v2[e11]   // V6 = BLUE 5 Bits, Color 0..7 >> 9
  vor v5,v6[e0]      // V5 = RED,GREEN,BLUE 15 Bits, Color 0..7
  vor v5,v0[e0]      // V5 = RED,GREEN,BLUE,ALPHA 16 Bits, Color 0..7

// Store Colors 0..7:
  sqv v5[e0],0(a0) // Palette Colors 0..8 = V5 Quad


LoopColors:
// Vector Grab Next 8 Colors:
  addi a0,16
  lqv v3[e0],0(a0) // V3 = Palette Colors 0..7

  vand v4,v3,v1[e8] // V4 = Lo Byte Color 0..7 (& $00FF)
  vand v5,v3,v1[e9] // V5 = Hi Byte Color 0..7 (& $FF00)
  vmudn v4,v2[e8]   // V4 = Lo Byte Color 0..7 << 8
  vmudl v5,v2[e8]   // V5 = Hi Byte Color 0..7 >> 8
  vor v4,v5[e0]     // V4 = Color 0..7 Big-Endian

  vand v5,v4,v1[e10] // V5 = RED 5 Bits, Color 0..7 (& $001F)
  vmudn v5,v2[e9]    // V5 = RED 5 Bits, Color 0..7 << 11

  vand v6,v4,v1[e11] // V6 = GREEN 5 Bits, Color 0..7 (& $03E0)
  vmudn v6,v2[e10]   // V6 = GREEN 5 Bits, Color 0..7 << 1
  vor v5,v6[e0]      // V5 = RED,GREEN 10 Bits, Color 0..7

  vand v6,v4,v1[e12] // V6 = BLUE 5 Bits, Color 0..7 (& $7C00)
  vmudl v6,v2[e11]   // V6 = BLUE 5 Bits, Color 0..7 >> 9
  vor v5,v6[e0]      // V5 = RED,GREEN,BLUE 15 Bits, Color 0..7
  vor v5,v0[e9]      // V5 = RED,GREEN,BLUE,ALPHA 16 Bits, Color 0..7

// Store Colors 0..7:
  sqv v5[e0],0(a0) // Palette Colors 0..8 = V5 Quad

  bnez t1,LoopColors // IF (Tile Counter != 0) Loop Colors
  subi t1,1 // Decrement Color Counter (Delay Slot)


  ori a0,r0,0 // A0 = SP Memory Address Offset DMEM ($A4000000..$A4001FFF 8KB)
  ori t0,r0,511 // T0 = Length Of DMA Transfer In Bytes - 1

  mtc0 a0,c0 // Store Memory Offset To SP Memory Address Register ($A4040000)
  mtc0 a1,c1 // Store RAM Offset To SP DRAM Address Register ($A4040004)
  mtc0 t0,c3 // Store DMA Length To SP Write Length Register ($A404000C)

  RSPDMASPWait() // Wait For RSP DMA To Finish


  break // Set SP Status Halt, Broke & Check For Interrupt
align(8) // Align 64-Bit
base RSPPALCode+pc() // Set End Of RSP Code Object
RSPPALCodeEnd:


align(8) // Align 64-Bit
RSPTILECode:
arch n64.rsp
base $0000 // Set Base Of RSP Code Object To Zero

RSPTILEStart:
// Load Static Shift Data
  RSPDMASPRD(RSPSHIFTData, RSPSHIFTDataEnd, SP_DMEM) // RSP DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address
  RSPDMASPWait() // Wait For RSP DMA To Finish

  lqv v0[e0],ShiftLeftRightA(r0) // V0 = Left Shift Using Multiply: << 0..7,  Right Shift Using Multiply: >> 16..9 (128-Bit Quad)
  lqv v1[e0],ShiftLeftRightB(r0) // V1 = Left Shift Using Multiply: << 8..15, Right Shift Using Multiply: >> 8..1  (128-Bit Quad)

// Decode Tiles
  ori t2,r0,15 // T2 = Tile Block Counter
  ori a0,r0,0 // A0 = Tile Start Offset
  la a1,N64TILE // A1 = Aligned DRAM Physical RAM Offset ($00000000..$007FFFFF 8MB)
  la a2,SNESTILE // A2 = Aligned DRAM Physical RAM Offset ($00000000..$007FFFFF 8MB)

LoopTileBlocks:
  // Uses DMA To Copy 4096 Bytes To DMEM, For 8BPPSNES->8BPPN64
  ori t0,r0,4095 // T0 = Length Of DMA Transfer In Bytes - 1
  ori t1,r0,63 // T1 = Tile Counter

  mtc0 a0,c0 // Store Memory Offset To SP Memory Address Register ($A4040000)
  mtc0 a2,c1 // Store RAM Offset To SP DRAM Address Register ($A4040004)
  mtc0 t0,c2 // Store DMA Length To SP Read Length Register ($A4040008)

  RSPDMASPWait() // Wait For RSP DMA To Finish

LoopTiles:
  lqv v2[e0],$00(a0) // V2 = Tile BitPlane 0,1 Row 0..7
  lqv v3[e0],$10(a0) // V3 = Tile BitPlane 2,3 Row 0..7
  lqv v4[e0],$20(a0) // V4 = Tile BitPlane 4,5 Row 0..7
  lqv v5[e0],$30(a0) // V5 = Tile BitPlane 6,7 Row 0..7

// Vector Grab Column 0:
  vand v6,v2,v1[e8] // V6 = bp0 Of r0..r7 (& $0100)
  vand v7,v2,v0[e8] // V7 = bp1 Of r0..r7 (& $0001)
  vmudl v6,v1[e15]  // V6 = bp0 Of r0..r7 >> 1
  vmudn v7,v1[e8]   // V7 = bp1 Of r0..r7 << 8
  vor v8,v6,v7[e0]  // V8 = bp0/bp1 Of r0..r7 In Unsigned Byte (%00000011)

  vand v6,v3,v1[e8] // V6 = bp2 Of r0..r7 (& $0100)
  vand v7,v3,v0[e8] // V7 = bp3 Of r0..r7 (& $0001)
  vmudn v6,v0[e9]   // V6 = bp2 Of r0..r7 << 1
  vmudn v7,v1[e10]  // V7 = bp3 Of r0..r7 << 10
  vor v8,v6[e0]     // V8 = bp0/bp1/bp2 Of r0..r7 In Unsigned Byte
  vor v8,v7[e0]     // V8 = bp0/bp1/bp2/bp3 Of r0..r7 In Unsigned Byte (%00001111)

  vand v6,v4,v1[e8] // V6 = bp4 Of r0..r7 (& $0100)
  vand v7,v4,v0[e8] // V7 = bp5 Of r0..r7 (& $0001)
  vmudn v6,v0[e11]  // V6 = bp4 Of r0..r7 << 3
  vmudn v7,v1[e12]  // V7 = bp5 Of r0..r7 << 12
  vor v8,v6[e0]     // V8 = bp0/bp1/bp2/bp3/bp4 Of r0..r7 In Unsigned Byte
  vor v8,v7[e0]     // V8 = bp0/bp1/bp2/bp3/bp4/bp5 Of r0..r7 In Unsigned Byte (%00111111)

  vand v6,v5,v1[e8] // V6 = bp6 Of r0..r7 (& $0100)
  vand v7,v5,v0[e8] // V7 = bp7 Of r0..r7 (& $0001)
  vmudn v6,v0[e13]  // V6 = bp6 Of r0..r7 << 5
  vmudn v7,v1[e14]  // V7 = bp7 Of r0..r7 << 14
  vor v8,v6[e0]     // V8 = bp0/bp1/bp2/bp3/bp4/bp5/bp6 Of r0..r7 In Unsigned Byte
  vor v8,v7[e0]     // V8 = bp0/bp1/bp2/bp3/bp4/bp5/bp6/bp7 Of r0..r7 In Unsigned Byte (%11111111)

// Store Column 0:
  suv v8[e0],0(a0) // Tile Row 0 = V8 Unsigned Bytes


// Vector Grab Column 1:
  vand v6,v2,v1[e9] // V6 = bp0 Of r0..r7 (& $0200)
  vand v7,v2,v0[e9] // V7 = bp1 Of r0..r7 (& $0002)
  vmudl v6,v1[e14]  // V6 = bp0 Of r0..r7 >> 2
  vmudn v7,v0[e15]  // V7 = bp1 Of r0..r7 << 7
  vor v8,v6,v7[e0]  // V8 = bp0/bp1 Of r0..r7 In Unsigned Byte (%00000011)

  vand v6,v3,v1[e9] // V6 = bp2 Of r0..r7 (& $0200)
  vand v7,v3,v0[e9] // V7 = bp3 Of r0..r7 (& $0002)
  vmudn v7,v1[e9]   // V7 = bp3 Of r0..r7 << 9
  vor v8,v6[e0]     // V8 = bp0/bp1/bp2 Of r0..r7 In Unsigned Byte
  vor v8,v7[e0]     // V8 = bp0/bp1/bp2/bp3 Of r0..r7 In Unsigned Byte (%00001111)

  vand v6,v4,v1[e9] // V6 = bp4 Of r0..r7 (& $0200)
  vand v7,v4,v0[e9] // V7 = bp5 Of r0..r7 (& $0002)
  vmudn v6,v0[e10]  // V6 = bp4 Of r0..r7 << 2
  vmudn v7,v1[e11]  // V7 = bp5 Of r0..r7 << 11
  vor v8,v6[e0]     // V8 = bp0/bp1/bp2/bp3/bp4 Of r0..r7 In Unsigned Byte
  vor v8,v7[e0]     // V8 = bp0/bp1/bp2/bp3/bp4/bp5 Of r0..r7 In Unsigned Byte (%00111111)

  vand v6,v5,v1[e9] // V6 = bp6 Of r0..r7 (& $0200)
  vand v7,v5,v0[e9] // V7 = bp7 Of r0..r7 (& $0002)
  vmudn v6,v0[e12]  // V6 = bp6 Of r0..r7 << 4
  vmudn v7,v1[e13]  // V7 = bp7 Of r0..r7 << 13
  vor v8,v6[e0]     // V8 = bp0/bp1/bp2/bp3/bp4/bp5/bp6 Of r0..r7 In Unsigned Byte
  vor v8,v7[e0]     // V8 = bp0/bp1/bp2/bp3/bp4/bp5/bp6/bp7 Of r0..r7 In Unsigned Byte (%11111111)

// Store Column 1:
  addi a0,8
  suv v8[e0],0(a0) // Tile Row 1 = V8 Unsigned Bytes


// Vector Grab Column 2:
  vand v6,v2,v1[e10] // V6 = bp0 Of r0..r7 (& $0400)
  vand v7,v2,v0[e10] // V7 = bp1 Of r0..r7 (& $0004)
  vmudl v6,v1[e13]   // V6 = bp0 Of r0..r7 >> 3
  vmudn v7,v0[e14]   // V7 = bp1 Of r0..r7 << 6
  vor v8,v6,v7[e0]   // V8 = bp0/bp1 Of r0..r7 In Unsigned Byte (%00000011)

  vand v6,v3,v1[e10] // V6 = bp2 Of r0..r7 (& $0400)
  vand v7,v3,v0[e10] // V7 = bp3 Of r0..r7 (& $0004)
  vmudl v6,v1[e15]   // V6 = bp2 Of r0..r7 >> 1
  vmudn v7,v1[e8]    // V7 = bp3 Of r0..r7 << 8
  vor v8,v6[e0]      // V8 = bp0/bp1/bp2 Of r0..r7 In Unsigned Byte
  vor v8,v7[e0]      // V8 = bp0/bp1/bp2/bp3 Of r0..r7 In Unsigned Byte (%00001111)

  vand v6,v4,v1[e10] // V6 = bp4 Of r0..r7 (& $0400)
  vand v7,v4,v0[e10] // V7 = bp5 Of r0..r7 (& $0004)
  vmudn v6,v0[e9]    // V6 = bp4 Of r0..r7 << 1
  vmudn v7,v1[e10]   // V7 = bp5 Of r0..r7 << 10
  vor v8,v6[e0]      // V8 = bp0/bp1/bp2/bp3/bp4 Of r0..r7 In Unsigned Byte
  vor v8,v7[e0]      // V8 = bp0/bp1/bp2/bp3/bp4/bp5 Of r0..r7 In Unsigned Byte (%00111111)

  vand v6,v5,v1[e10] // V6 = bp6 Of r0..r7 (& $0400)
  vand v7,v5,v0[e10] // V7 = bp7 Of r0..r7 (& $0004)
  vmudn v6,v0[e11]   // V6 = bp6 Of r0..r7 << 3
  vmudn v7,v1[e12]   // V7 = bp7 Of r0..r7 << 12
  vor v8,v6[e0]      // V8 = bp0/bp1/bp2/bp3/bp4/bp5/bp6 Of r0..r7 In Unsigned Byte
  vor v8,v7[e0]      // V8 = bp0/bp1/bp2/bp3/bp4/bp5/bp6/bp7 Of r0..r7 In Unsigned Byte (%11111111)

// Store Column 2:
  addi a0,8
  suv v8[e0],0(a0) // Tile Row 2 = V8 Unsigned Bytes


// Vector Grab Column 3:
  vand v6,v2,v1[e11] // V6 = bp0 Of r0..r7 (& $0800)
  vand v7,v2,v0[e11] // V7 = bp1 Of r0..r7 (& $0008)
  vmudl v6,v1[e12]   // V6 = bp0 Of r0..r7 >> 4
  vmudn v7,v0[e13]   // V7 = bp1 Of r0..r7 << 5
  vor v8,v6,v7[e0]   // V8 = bp0/bp1 Of r0..r7 In Unsigned Byte (%00000011)

  vand v6,v3,v1[e11] // V6 = bp2 Of r0..r7 (& $0800)
  vand v7,v3,v0[e11] // V7 = bp3 Of r0..r7 (& $0008)
  vmudl v6,v1[e14]   // V6 = bp2 Of r0..r7 >> 2
  vmudn v7,v0[e15]   // V7 = bp3 Of r0..r7 << 7
  vor v8,v6[e0]      // V8 = bp0/bp1/bp2 Of r0..r7 In Unsigned Byte
  vor v8,v7[e0]      // V8 = bp0/bp1/bp2/bp3 Of r0..r7 In Unsigned Byte (%00001111)

  vand v6,v4,v1[e11] // V6 = bp4 Of r0..r7 (& $0800)
  vand v7,v4,v0[e11] // V7 = bp5 Of r0..r7 (& $0008)
  vmudn v7,v1[e9]    // V7 = bp5 Of r0..r7 << 9
  vor v8,v6[e0]      // V8 = bp0/bp1/bp2/bp3/bp4 Of r0..r7 In Unsigned Byte
  vor v8,v7[e0]      // V8 = bp0/bp1/bp2/bp3/bp4/bp5 Of r0..r7 In Unsigned Byte (%00111111)

  vand v6,v5,v1[e11] // V6 = bp6 Of r0..r7 (& $0800)
  vand v7,v5,v0[e11] // V7 = bp7 Of r0..r7 (& $0008)
  vmudn v6,v0[e10]   // V6 = bp6 Of r0..r7 << 2
  vmudn v7,v1[e11]   // V7 = bp7 Of r0..r7 << 11
  vor v8,v6[e0]      // V8 = bp0/bp1/bp2/bp3/bp4/bp5/bp6 Of r0..r7 In Unsigned Byte
  vor v8,v7[e0]      // V8 = bp0/bp1/bp2/bp3/bp4/bp5/bp6/bp7 Of r0..r7 In Unsigned Byte (%11111111)

// Store Column 3:
  addi a0,8
  suv v8[e0],0(a0) // Tile Row 3 = V8 Unsigned Bytes


// Vector Grab Column 4:
  vand v6,v2,v1[e12] // V6 = bp0 Of r0..r7 (& $1000)
  vand v7,v2,v0[e12] // V7 = bp1 Of r0..r7 (& $0010)
  vmudl v6,v1[e11]   // V6 = bp0 Of r0..r7 >> 5
  vmudn v7,v0[e12]   // V7 = bp1 Of r0..r7 << 4
  vor v8,v6,v7[e0]   // V8 = bp0/bp1 Of r0..r7 In Unsigned Byte (%00000011)

  vand v6,v3,v1[e12] // V6 = bp2 Of r0..r7 (& $1000)
  vand v7,v3,v0[e12] // V7 = bp3 Of r0..r7 (& $0010)
  vmudl v6,v1[e13]   // V6 = bp2 Of r0..r7 >> 3
  vmudn v7,v0[e14]   // V7 = bp3 Of r0..r7 << 6
  vor v8,v6[e0]      // V8 = bp0/bp1/bp2 Of r0..r7 In Unsigned Byte
  vor v8,v7[e0]      // V8 = bp0/bp1/bp2/bp3 Of r0..r7 In Unsigned Byte (%00001111)

  vand v6,v4,v1[e12] // V6 = bp4 Of r0..r7 (& $1000)
  vand v7,v4,v0[e12] // V7 = bp5 Of r0..r7 (& $0010)
  vmudl v6,v1[e15]   // V6 = bp4 Of r0..r7 >> 1
  vmudn v7,v1[e8]    // V7 = bp5 Of r0..r7 << 8
  vor v8,v6[e0]      // V8 = bp0/bp1/bp2/bp3/bp4 Of r0..r7 In Unsigned Byte
  vor v8,v7[e0]      // V8 = bp0/bp1/bp2/bp3/bp4/bp5 Of r0..r7 In Unsigned Byte (%00111111)

  vand v6,v5,v1[e12] // V6 = bp6 Of r0..r7 (& $1000)
  vand v7,v5,v0[e12] // V7 = bp7 Of r0..r7 (& $0010)
  vmudn v6,v0[e9]    // V6 = bp6 Of r0..r7 << 1
  vmudn v7,v1[e10]   // V7 = bp7 Of r0..r7 << 10
  vor v8,v6[e0]      // V8 = bp0/bp1/bp2/bp3/bp4/bp5/bp6 Of r0..r7 In Unsigned Byte
  vor v8,v7[e0]      // V8 = bp0/bp1/bp2/bp3/bp4/bp5/bp6/bp7 Of r0..r7 In Unsigned Byte (%11111111)

// Store Column 4:
  addi a0,8
  suv v8[e0],0(a0) // Tile Row 4 = V8 Unsigned Bytes


// Vector Grab Column 5:
  vand v6,v2,v1[e13] // V6 = bp0 Of r0..r7 (& $2000)
  vand v7,v2,v0[e13] // V7 = bp1 Of r0..r7 (& $0020)
  vmudl v6,v1[e10]   // V6 = bp0 Of r0..r7 >> 6
  vmudn v7,v0[e11]   // V7 = bp1 Of r0..r7 << 3
  vor v8,v6,v7[e0]   // V8 = bp0/bp1 Of r0..r7 In Unsigned Byte (%00000011)

  vand v6,v3,v1[e13] // V6 = bp2 Of r0..r7 (& $2000)
  vand v7,v3,v0[e13] // V7 = bp3 Of r0..r7 (& $0020)
  vmudl v6,v1[e12]   // V6 = bp2 Of r0..r7 >> 4
  vmudn v7,v0[e13]   // V7 = bp3 Of r0..r7 << 5
  vor v8,v6[e0]      // V8 = bp0/bp1/bp2 Of r0..r7 In Unsigned Byte
  vor v8,v7[e0]      // V8 = bp0/bp1/bp2/bp3 Of r0..r7 In Unsigned Byte (%00001111)

  vand v6,v4,v1[e13] // V6 = bp4 Of r0..r7 (& $2000)
  vand v7,v4,v0[e13] // V7 = bp5 Of r0..r7 (& $0020)
  vmudl v6,v1[e14]   // V6 = bp4 Of r0..r7 >> 2
  vmudn v7,v0[e15]   // V7 = bp5 Of r0..r7 << 7
  vor v8,v6[e0]      // V8 = bp0/bp1/bp2/bp3/bp4 Of r0..r7 In Unsigned Byte
  vor v8,v7[e0]      // V8 = bp0/bp1/bp2/bp3/bp4/bp5 Of r0..r7 In Unsigned Byte (%00111111)

  vand v6,v5,v1[e13] // V6 = bp6 Of r0..r7 (& $2000)
  vand v7,v5,v0[e13] // V7 = bp7 Of r0..r7 (& $0020)
  vmudn v7,v1[e9]    // V7 = bp7 Of r0..r7 << 9
  vor v8,v6[e0]      // V8 = bp0/bp1/bp2/bp3/bp4/bp5/bp6 Of r0..r7 In Unsigned Byte
  vor v8,v7[e0]      // V8 = bp0/bp1/bp2/bp3/bp4/bp5/bp6/bp7 Of r0..r7 In Unsigned Byte (%11111111)

// Store Column 5:
  addi a0,8
  suv v8[e0],0(a0) // Tile Row 5 = V8 Unsigned Bytes


// Vector Grab Column 6:
  vand v6,v2,v1[e14] // V6 = bp0 Of r0..r7 (& $4000)
  vand v7,v2,v0[e14] // V7 = bp1 Of r0..r7 (& $0040)
  vmudl v6,v1[e9]    // V6 = bp0 Of r0..r7 >> 7
  vmudn v7,v0[e10]   // V7 = bp1 Of r0..r7 << 2
  vor v8,v6,v7[e0]   // V8 = bp0/bp1 Of r0..r7 In Unsigned Byte (%00000011)

  vand v6,v3,v1[e14] // V6 = bp2 Of r0..r7 (& $4000)
  vand v7,v3,v0[e14] // V7 = bp3 Of r0..r7 (& $0040)
  vmudl v6,v1[e11]   // V6 = bp2 Of r0..r7 >> 5
  vmudn v7,v0[e12]   // V7 = bp3 Of r0..r7 << 4
  vor v8,v6[e0]      // V8 = bp0/bp1/bp2 Of r0..r7 In Unsigned Byte
  vor v8,v7[e0]      // V8 = bp0/bp1/bp2/bp3 Of r0..r7 In Unsigned Byte (%00001111)

  vand v6,v4,v1[e14] // V6 = bp4 Of r0..r7 (& $4000)
  vand v7,v4,v0[e14] // V7 = bp5 Of r0..r7 (& $0040)
  vmudl v6,v1[e13]   // V6 = bp4 Of r0..r7 >> 3
  vmudn v7,v0[e14]   // V7 = bp5 Of r0..r7 << 6
  vor v8,v6[e0]      // V8 = bp0/bp1/bp2/bp3/bp4 Of r0..r7 In Unsigned Byte
  vor v8,v7[e0]      // V8 = bp0/bp1/bp2/bp3/bp4/bp5 Of r0..r7 In Unsigned Byte (%00111111)

  vand v6,v5,v1[e14] // V6 = bp6 Of r0..r7 (& $4000)
  vand v7,v5,v0[e14] // V7 = bp7 Of r0..r7 (& $0040)
  vmudl v6,v1[e15]   // V6 = bp6 Of r0..r7 >> 1
  vmudn v7,v1[e8]    // V7 = bp7 Of r0..r7 << 8
  vor v8,v6[e0]      // V8 = bp0/bp1/bp2/bp3/bp4/bp5/bp6 Of r0..r7 In Unsigned Byte
  vor v8,v7[e0]      // V8 = bp0/bp1/bp2/bp3/bp4/bp5/bp6/bp7 Of r0..r7 In Unsigned Byte (%11111111)

// Store Column 6:
  addi a0,8
  suv v8[e0],0(a0) // Tile Row 6 = V8 Unsigned Bytes


// Vector Grab Column 7:
  vand v6,v2,v1[e15] // V6 = bp0 Of r0..r7 (& $8000)
  vand v7,v2,v0[e15] // V7 = bp1 Of r0..r7 (& $0080)
  vmudl v6,v1[e8]    // V6 = bp0 Of r0..r7 >> 8
  vmudn v7,v0[e9]    // V7 = bp1 Of r0..r7 << 1
  vor v8,v6,v7[e0]   // V8 = bp0/bp1 Of r0..r7 In Unsigned Byte (%00000011)

  vand v6,v3,v1[e15] // V6 = bp2 Of r0..r7 (& $8000)
  vand v7,v3,v0[e15] // V7 = bp3 Of r0..r7 (& $0080)
  vmudl v6,v1[e10]   // V6 = bp2 Of r0..r7 >> 6
  vmudn v7,v0[e11]   // V7 = bp3 Of r0..r7 << 3
  vor v8,v6[e0]      // V8 = bp0/bp1/bp2 Of r0..r7 In Unsigned Byte
  vor v8,v7[e0]      // V8 = bp0/bp1/bp2/bp3 Of r0..r7 In Unsigned Byte (%00001111)

  vand v6,v4,v1[e15] // V6 = bp4 Of r0..r7 (& $8000)
  vand v7,v4,v0[e15] // V7 = bp5 Of r0..r7 (& $0080)
  vmudl v6,v1[e12]   // V6 = bp4 Of r0..r7 >> 4
  vmudn v7,v0[e13]   // V7 = bp5 Of r0..r7 << 5
  vor v8,v6[e0]      // V8 = bp0/bp1/bp2/bp3/bp4 Of r0..r7 In Unsigned Byte
  vor v8,v7[e0]      // V8 = bp0/bp1/bp2/bp3/bp4/bp5 Of r0..r7 In Unsigned Byte (%00111111)

  vand v6,v5,v1[e15] // V6 = bp6 Of r0..r7 (& $8000)
  vand v7,v5,v0[e15] // V7 = bp7 Of r0..r7 (& $0080)
  vmudl v6,v1[e14]   // V6 = bp6 Of r0..r7 >> 2
  vmudn v7,v0[e15]   // V7 = bp7 Of r0..r7 << 7
  vor v8,v6[e0]      // V8 = bp0/bp1/bp2/bp3/bp4/bp5/bp6 Of r0..r7 In Unsigned Byte
  vor v8,v7[e0]      // V8 = bp0/bp1/bp2/bp3/bp4/bp5/bp6/bp7 Of r0..r7 In Unsigned Byte (%11111111)

// Store Column 7:
  addi a0,8
  suv v8[e0],0(a0) // Tile Row 7 = V8 Unsigned Bytes


  addi a0,8 // A0 = Next SNES Tile Offset

  bnez t1,LoopTiles // IF (Tile Counter != 0) Loop Tiles
  subi t1,1 // Decrement Tile Counter (Delay Slot)


  ori a0,r0,0 // A0 = SP Memory Address Offset DMEM ($A4000000..$A4001FFF 8KB)
  ori t0,r0,4095 // T0 = Length Of DMA Transfer In Bytes - 1

  mtc0 a0,c0 // Store Memory Offset To SP Memory Address Register ($A4040000)
  mtc0 a1,c1 // Store RAM Offset To SP DRAM Address Register ($A4040004)
  mtc0 t0,c3 // Store DMA Length To SP Write Length Register ($A404000C)

  RSPDMASPWait() // Wait For RSP DMA To Finish

  addi a1,4096 // A1 = Next N64  Tile Offset
  addi a2,4096 // A2 = Next SNES Tile Offset

  bnez t2,LoopTileBlocks // IF (Tile Block Counter != 0) Loop Tile Blocks
  subi t2,1 // Decrement Tile Block Counter (Delay Slot)

  break // Set SP Status Halt, Broke & Check For Interrupt
align(8) // Align 64-Bit
base RSPTILECode+pc() // Set End Of RSP Code Object
RSPTILECodeEnd:


align(8) // Align 64-Bit
RDPBuffer:
arch n64.rdp
  Set_Scissor 32<<2,8<<2, 0,0, 288<<2,232<<2 // Set Scissor: XH 32.0,YH 8.0, Scissor Field Enable Off,Field Off, XL 288.0,YL 232.0
  Set_Other_Modes CYCLE_TYPE_FILL // Set Other Modes
  Set_Color_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,320-1, $00100000 // Set Color Image: FORMAT RGBA,SIZE 16B,WIDTH 320, DRAM ADDRESS $00100000

RDPSNESCLEARCOL:
  Set_Fill_Color $00010001 // Set Fill Color: PACKED COLOR 16B R5G5B5A1 Pixels
  Fill_Rectangle 319<<2,239<<2, 0<<2,0<<2 // Fill Rectangle: XL 319.0,YL 239.0, XH 0.0,YH 0.0

  Set_Other_Modes EN_TLUT|SAMPLE_TYPE|BI_LERP_0|ALPHA_DITHER_SEL_NO_DITHER|B_M2A_0_1|FORCE_BLEND|IMAGE_READ_EN // Set Other Modes
  Set_Combine_Mode $0,$00, 0,0, $1,$01, $0,$F, 1,0, 0,0,0, 7,7,7 // Set Combine Mode: SubA RGB0,MulRGB0, SubA Alpha0,MulAlpha0, SubA RGB1,MulRGB1, SubB RGB0,SubB RGB1, SubA Alpha1,MulAlpha1, AddRGB0,SubB Alpha0,AddAlpha0, AddRGB1,SubB Alpha1,AddAlpha1

  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,1-1, N64TLUT // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 1, N64TLUT DRAM ADDRESS
  Set_Tile 0,0,0, $100, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: TMEM Address $100, Tile 0
  Load_Tlut 0<<2,0<<2, 0, 255<<2,0<<2 // Load Tlut: SL 0.0,TL 0.0, Tile 0, SH 255.0,TH 0.0
  Sync_Tile // Sync Tile

// BG Column 0..31 / Row 0..27
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,1, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 8B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0

RDPSNESTILE:

  define y(0)
  while {y} < 28 {
    define x(0)
    while {x} < 32 {
      Sync_Tile // Sync Tile
      Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,8-1, N64TILE+(64*(({y}*32)+{x})) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 8, Tile DRAM ADDRESS
      Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load Tile: SL,TL, Tile, SH,TH
      Texture_Rectangle_Flip (40+({x}*8))<<2,(16+({y}*8))<<2, 0, (32+({x}*8))<<2,(8+({y}*8))<<2, 0<<5,7<<5, 1<<10,-1<<10 // Texture Rectangle Flip: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

      evaluate x({x} + 1)
    }
    evaluate y({y} + 1)
  }

  Sync_Full // Ensure Entire Scene Is Fully Drawn
RDPBufferEnd: