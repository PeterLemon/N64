// N64 'Bare Metal' 16BPP 320x240 GameBoy PPU 2BPP Tile 8x8 Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "PPU2BPPTile8x8.N64", create
fill 1052672 // Set ROM Size

origin $00000000
base $80000000 // Entry Point Of Code
include "LIB\N64.INC" // Include N64 Definitions
include "LIB\N64_HEADER.ASM" // Include 64 Byte Header & Vector Table
insert "LIB\N64_BOOTCODE.BIN" // Include 4032 Byte Boot Code

Start:
  include "LIB\N64_GFX.INC" // Include Graphics Macros
  include "LIB\N64_RSP.INC" // Include RSP Macros
  N64_INIT() // Run N64 Initialisation Routine

  ScreenNTSC(320, 240, BPP16, $A0100000) // Screen NTSC: 320x240, 16BPP, DRAM Origin $A0100000

// DMA Copy GameBoy Background Image To FrameBuffer
  DMA(Image, Image+Image.size, $00100000) // DMA Data Copy Cart->DRAM: Start Cart Address, End Cart Address, Destination DRAM Address

// Convert GameBoy Palette To N64 TLUT
la a0,GBPAL  // A0 = GameBoy Palette Address
lbu t0,0(a0) // T0 = GameBoy Palette Byte
la a0,$A0000000|(N64TLUT&$3FFFFFF) // A0 = N64 TLUT Address

andi t1,t0,3 // BGP Color 0 (PAL&3)
xori t1,3    // Invert Bits
sll t1,9     // Shift Color To Green
ori t1,1     // Add Alpha Bit
sh t1,0(a0)  // Store Color 0

andi t1,t0,12 // BGP Color 1 ((PAL&12)>>2)
xori t1,12    // Invert Bits
sll t1,7      // Shift Color To Green
ori t1,1      // Add Alpha Bit
sh t1,2(a0)   // Store Color 1

andi t1,t0,48 // BGP Color 2 ((PAL&48)>>4)
xori t1,48    // Invert Bits
sll t1,5      // Shift Color To Green
ori t1,1      // Add Alpha Bit
sh t1,4(a0)   // Store Color 2

andi t1,t0,192 // BGP Color 3 ((PAL&192)>>6))
xor t1,192     // Invert Bits
sll t1,3       // Shift Color To Green
ori t1,1       // Add Alpha Bit
sh t1,6(a0)    // Store Color 3

// Convert GameBoy Tile Map To RDP List
la a0,GBMAP // A0 = GameBoy Tile Map Address
la a1,$A0000000|((RDPGBTILE+12)&$3FFFFFF) // A1 = N64 RDP GameBoy Tile Map Address
la a2,(N64TILE&$3FFFFFF) // A2 = N64 Tile Address
lli t0,1023 // T0 = Number Of Tiles To Convert
MAPLoop:
  lbu t1,0(a0) // T1 = GameBoy Tile Map # Byte
  addiu a0,1   // A0++
  sll t1,5     // T1 *= 32
  addu t1,a2   // T1 += N64 Tile Address
  sw t1,0(a1)  // Store GameBoy Tile Map # To N64 RDP GameBoy Tile Map
  addiu a1,40  // A1 += 40
  bnez t0,MAPLoop // IF (Number Of Tiles To Convert != 0) Map Loop
  subiu t0,1 // Decrement Number Of Tiles To Convert (Delay Slot)

// Convert GameBoy Tiles To N64 Linear Texture
  // Load RSP Code To IMEM
  DMASPRD(RSPTILECode, RSPTILECodeEnd, SP_IMEM) // DMA Data Read DRAM->RSP MEM: Start Address, End Address, Destination RSP MEM Address

  lui a0,SP_BASE // A0 = SP Base Register ($A4040000)
  TILECodeDMABusy:
    lb t0,SP_STATUS(a0) // T0 = Byte From SP Status Register ($A4040010)
    andi t0,$C // AND RSP Status Status With $C (Bit 2 = DMA Is Busy, Bit 3 = DMA Is Full)
    bnez t0,TILECodeDMABusy // IF TRUE DMA Is Busy
    nop // Delay Slot

  // Set RSP Program Counter
  lui a0,SP_PC_BASE // A0 = SP PC Base Register ($A4080000)
  lli t0,RSPTILEStart // T0 = RSP Program Counter Set To Start Of RSP Code
  sw t0,SP_PC(a0) // Store RSP Program Counter To SP PC Register ($A4080000)

  // Set RSP Status (Start Execution)
  lui a0,SP_BASE // A0 = SP Base Register ($A4040000)
  li t0,CLR_HLT|CLR_BRK|CLR_INT|CLR_STP|CLR_IOB // T0 = RSP Status: Clear Halt, Broke, Interrupt, Single Step, Interrupt On Break
  sw t0,SP_STATUS(a0) // Run RSP Code: Store RSP Status To SP Status Register ($A4040010)

  li t0,$22000 // Wait For RSP To Compute
DelayTILES:
  bnez t0,DelayTILES
  subi t0,1

WaitScanline($200) // Wait For Scanline To Reach Vertical Blank

  DPC(RDPBuffer, RDPBufferEnd) // Run DPC Command Buffer: Start Address, End Address

Loop:
  j Loop
  nop // Delay Slot

insert Image, "Image.bin" // GameBoy Background Image

GBPAL:
  db %00001100 // BG Palette (White/Black) (BGP_REG BG Palette Data Register $FF47)

align(8) // Align 64-Bit
GBTILE:
  include "BG.asm"

align(8) // Align 64-Bit
GBMAP:
  include "BGMAP.asm" // GB 32x32 Background Tile Map (1024 Bytes)

align(8) // Align 64-Bit
N64TLUT:
  fill 8 // Generates 8 Bytes Containing $00

align(8) // Align 64-Bit
N64TILE:
  fill 65536 // Generates 65536 Bytes Containing $00

align(8) // Align 64-Bit
RSPSHIFTData:
base $0000 // Set Base Of RSP Data Object To Zero

// Uses Elements 8..15 To Multiply Vector By Scalar For Pseudo Vector Shifts
ShiftLeftRightA:
  dw $0001, $0002, $0004, $0008, $0010, $0020, $0040, $0080
  // $0001 (Left Shift Using Multiply: << 0),  (Right Shift Using Multiply: >> 16) (e8)
  // $0002 (Left Shift Using Multiply: << 1),  (Right Shift Using Multiply: >> 15) (e9)
  // $0004 (Left Shift Using Multiply: << 2),  (Right Shift Using Multiply: >> 14) (e10)
  // $0008 (Left Shift Using Multiply: << 3),  (Right Shift Using Multiply: >> 13) (e11)
  // $0010 (Left Shift Using Multiply: << 4),  (Right Shift Using Multiply: >> 12) (e12)
  // $0020 (Left Shift Using Multiply: << 5),  (Right Shift Using Multiply: >> 11) (e13)
  // $0040 (Left Shift Using Multiply: << 6),  (Right Shift Using Multiply: >> 10) (e14)
  // $0080 (Left Shift Using Multiply: << 7),  (Right Shift Using Multiply: >> 9)  (e15)
ShiftLeftRightB:
  dw $0100, $0200, $0400, $0800, $1000, $2000, $4000, $8000
  // $0100 (Left Shift Using Multiply: << 8),  (Right Shift Using Multiply: >> 8) (e8)
  // $0200 (Left Shift Using Multiply: << 9),  (Right Shift Using Multiply: >> 7) (e9)
  // $0400 (Left Shift Using Multiply: << 10), (Right Shift Using Multiply: >> 6) (e10)
  // $0800 (Left Shift Using Multiply: << 11), (Right Shift Using Multiply: >> 5) (e11)
  // $1000 (Left Shift Using Multiply: << 12), (Right Shift Using Multiply: >> 4) (e12)
  // $2000 (Left Shift Using Multiply: << 13), (Right Shift Using Multiply: >> 3) (e13)
  // $4000 (Left Shift Using Multiply: << 14), (Right Shift Using Multiply: >> 2) (e14)
  // $8000 (Left Shift Using Multiply: << 15), (Right Shift Using Multiply: >> 1) (e15)

// Uses Elements 8..9 To AND Lo/Hi Nibbles
ANDNibble:
  dw $000F, $0F00
  // $000F (AND Lo Nibble) (e8)
  // $0F00 (AND Hi Nibble) (e9)

align(8) // Align 64-Bit
base RSPSHIFTData+pc() // Set End Of RSP Data Object
RSPSHIFTDataEnd:


align(8) // Align 64-Bit
RSPTILECode:
arch n64.rsp
base $0000 // Set Base Of RSP Code Object To Zero

RSPTILEStart:
// Load Static Shift Data
  lli a0,0 // A0 = Shift Start Offset
  la a1,RSPSHIFTData // A1 = Aligned DRAM Physical RAM Offset ($00000000..$007FFFFF 8MB)
  li t0,(RSPSHIFTDataEnd-RSPSHIFTData)-1 // T0 = Length Of DMA Transfer In Bytes - 1

  mtc0 a0,c0 // Store Memory Offset To SP Memory Address Register ($A4040000)
  mtc0 a1,c1 // Store RAM Offset To SP DRAM Address Register ($A4040004)
  mtc0 t0,c2 // Store DMA Length To SP Read Length Register ($A4040008)

  SHIFTDMAREADBusy:
    mfc0 t0,c4 // T0 = RSP Status Register ($A4040010)
    andi t0,RSP_BSY|RSP_FUL // AND RSP Status Status With $C (Bit 2 = DMA Is Busy, Bit 3 = DMA Is Full)
    bnez t0,SHIFTDMAREADBusy // IF TRUE DMA Is Busy
    nop // Delay Slot

  lqv v0[e0],ShiftLeftRightA>>4(r0) // V0 = Left Shift Using Multiply: << 0..7,  Right Shift Using Multiply: >> 16..9 (128-Bit Quad)
  lqv v1[e0],ShiftLeftRightB>>4(r0) // V1 = Left Shift Using Multiply: << 8..15, Right Shift Using Multiply: >> 8..1  (128-Bit Quad)
  llv v2[e0],ANDNibble>>2(r0) // V2 = $000F (AND Lo Nibble), $0F00 (AND Hi Nibble) (32-Bit Long)

// Decode Tiles
  lli t2,1 // T2 = Tile Block Counter
  lli a0,0 // A0 = Tile Start Offset
  la a1,N64TILE // A1 = Aligned DRAM Physical RAM Offset ($00000000..$007FFFFF 8MB)
  la a2,GBTILE // A2 = Aligned DRAM Physical RAM Offset ($00000000..$007FFFFF 8MB)

LoopTileBlocks:
  // Uses DMA & Stride To Copy 128 Tiles (2048 Bytes) To DMEM, 16 Bytes Per Tile, Followed by 16 Bytes Stride, For 2BPPGB->4BPPN64
  li t0,(15 | (127<<12) | (16<<20)) // T0 = Length Of DMA Transfer In Bytes - 1, DMA Line Count - 1, Line Skip/Stride
  lli t1,127 // T1 = Tile Counter

  mtc0 a0,c0 // Store Memory Offset To SP Memory Address Register ($A4040000)
  mtc0 a2,c1 // Store RAM Offset To SP DRAM Address Register ($A4040004)
  mtc0 t0,c2 // Store DMA Length To SP Read Length Register ($A4040008)

  TILEDMAREADBusy:
    mfc0 t0,c4 // T0 = RSP Status Register ($A4040010)
    andi t0,RSP_BSY|RSP_FUL // AND RSP Status Status With $C (Bit 2 = DMA Is Busy, Bit 3 = DMA Is Full)
    bnez t0,TILEDMAREADBusy // IF TRUE DMA Is Busy
    nop // Delay Slot

LoopTiles:
  lqv v3[e0],0(a0) // V3 = Tile BitPlane 0,1 Row 0..7

// Vector Grab Column 0:
  vand v4,v3,v1[e8] // V4 = bp0 Of r0..r7 (& $0100)
  vand v5,v3,v0[e8] // V5 = bp1 Of r0..r7 (& $0001)
  vmudl v4,v1[e15]  // V4 = bp0 Of r0..r7 >> 1
  vmudn v5,v1[e8]   // V5 = bp1 Of r0..r7 << 8
  vor v6,v4,v5[e0]  // V6 = bp0/bp1 Of r0..r7 In Unsigned Byte (%00000011)

// Store Column 0:
  suv v6[e0],0(a0) // Tile Row 0 = V6 Unsigned Bytes


// Vector Grab Column 1:
  vand v4,v3,v1[e9] // V4 = bp0 Of r0..r7 (& $0200)
  vand v5,v3,v0[e9] // V5 = bp1 Of r0..r7 (& $0002)
  vmudl v4,v1[e14]  // V4 = bp0 Of r0..r7 >> 2
  vmudn v5,v0[e15]  // V5 = bp1 Of r0..r7 << 7
  vor v6,v4,v5[e0]  // V6 = bp0/bp1 Of r0..r7 In Unsigned Byte (%00000011)

// Store Column 1:
  addi a0,8
  suv v6[e0],0(a0) // Tile Row 1 = V6 Unsigned Bytes

// Pack Column 0,1 Nibbles:
  subi a0,8
  lqv v4[e0],0(a0)  // V4 = Column 0,1
  vand v5,v4,v2[e9] // V5 = Nibble Of Column 0 (& $0F00)
  vand v6,v4,v2[e8] // V6 = Nibble Of Column 1 (& $000F)
  vmudn v5,v0[e11]  // V5 = Nibble Of Column 0 << 3
  vmudn v6,v0[e15]  // V6 = Nibble Of Column 1 << 7
  vor v7,v5,v6[e0]  // V7 = Packed Column 0,1 Byte


// Vector Grab Column 2:
  vand v4,v3,v1[e10] // V4 = bp0 Of r0..r7 (& $0400)
  vand v5,v3,v0[e10] // V5 = bp1 Of r0..r7 (& $0004)
  vmudl v4,v1[e13]   // V4 = bp0 Of r0..r7 >> 3
  vmudn v5,v0[e14]   // V5 = bp1 Of r0..r7 << 6
  vor v6,v4,v5[e0]   // V6 = bp0/bp1 Of r0..r7 In Unsigned Byte (%00000011)

// Store Column 2:
  suv v6[e0],0(a0) // Tile Row 2 = V6 Unsigned Bytes


// Vector Grab Column 3:
  vand v4,v3,v1[e11] // V4 = bp0 Of r0..r7 (& $0800)
  vand v5,v3,v0[e11] // V5 = bp1 Of r0..r7 (& $0008)
  vmudl v4,v1[e12]   // V4 = bp0 Of r0..r7 >> 4
  vmudn v5,v0[e13]   // V5 = bp1 Of r0..r7 << 5
  vor v6,v4,v5[e0]   // V6 = bp0/bp1 Of r0..r7 In Unsigned Byte (%00000011)

// Store Column 3:
  addi a0,8
  suv v6[e0],0(a0) // Tile Row 3 = V6 Unsigned Bytes

// Pack Column 2,3 Nibbles:
  subi a0,8
  lqv v4[e0],0(a0)  // V4 = Column 2,3
  vand v5,v4,v2[e9] // V5 = Nibble Of Column 0 (& $0F00)
  vand v6,v4,v2[e8] // V6 = Nibble Of Column 1 (& $000F)
  vmudn v5,v0[e11]  // V5 = Nibble Of Column 2 << 3
  vmudn v6,v0[e15]  // V6 = Nibble Of Column 3 << 7
  vor v8,v5,v6[e0]  // V8 = Packed Column 2,3 Byte


// Vector Grab Column 4:
  vand v4,v3,v1[e12] // V4 = bp0 Of r0..r7 (& $1000)
  vand v5,v3,v0[e12] // V5 = bp1 Of r0..r7 (& $0010)
  vmudl v4,v1[e11]   // V4 = bp0 Of r0..r7 >> 5
  vmudn v5,v0[e12]   // V5 = bp1 Of r0..r7 << 4
  vor v6,v4,v5[e0]   // V6 = bp0/bp1 Of r0..r7 In Unsigned Byte (%00000011)

// Store Column 4:
  suv v6[e0],0(a0) // Tile Row 4 = V6 Unsigned Bytes


// Vector Grab Column 5:
  vand v4,v3,v1[e13] // V4 = bp0 Of r0..r7 (& $2000)
  vand v5,v3,v0[e13] // V5 = bp1 Of r0..r7 (& $0020)
  vmudl v4,v1[e10]   // V4 = bp0 Of r0..r7 >> 6
  vmudn v5,v0[e11]   // V5 = bp1 Of r0..r7 << 3
  vor v6,v4,v5[e0]   // V6 = bp0/bp1 Of r0..r7 In Unsigned Byte (%00000011)

// Store Column 5:
  addi a0,8
  suv v6[e0],0(a0) // Tile Row 5 = V6 Unsigned Bytes

// Pack Column 4,5 Nibbles:
  subi a0,8
  lqv v4[e0],0(a0)  // V4 = Column 4,5
  vand v5,v4,v2[e9] // V5 = Nibble Of Column 0 (& $0F00)
  vand v6,v4,v2[e8] // V6 = Nibble Of Column 1 (& $000F)
  vmudn v5,v0[e11]  // V5 = Nibble Of Column 4 << 3
  vmudn v6,v0[e15]  // V6 = Nibble Of Column 5 << 7
  vor v9,v5,v6[e0]  // V9 = Packed Column 4,5 Byte


// Vector Grab Column 6:
  vand v4,v3,v1[e14] // V4 = bp0 Of r0..r7 (& $4000)
  vand v5,v3,v0[e14] // V5 = bp1 Of r0..r7 (& $0040)
  vmudl v4,v1[e9]    // V4 = bp0 Of r0..r7 >> 7
  vmudn v5,v0[e10]   // V5 = bp1 Of r0..r7 << 2
  vor v6,v4,v5[e0]   // V6 = bp0/bp1 Of r0..r7 In Unsigned Byte (%00000011)

// Store Column 6:
  suv v6[e0],0(a0) // Tile Row 6 = V6 Unsigned Bytes


// Vector Grab Column 7:
  vand v4,v3,v1[e15] // V4 = bp0 Of r0..r7 (& $8000)
  vand v5,v3,v0[e15] // V5 = bp1 Of r0..r7 (& $0080)
  vmudl v4,v1[e8]    // V4 = bp0 Of r0..r7 >> 8
  vmudn v5,v0[e9]    // V5 = bp1 Of r0..r7 << 1
  vor v6,v4,v5[e0]   // V6 = bp0/bp1 Of r0..r7 In Unsigned Byte (%00000011)

// Store Column 7:
  addi a0,8
  suv v6[e0],0(a0) // Tile Row 7 = V6 Unsigned Bytes

// Pack Column 6,7 Nibbles:
  subi a0,8
  lqv v4[e0],0(a0)  // V4 = Column 6,7
  vand v5,v4,v2[e9] // V5 = Nibble Of Column 0 (& $0F00)
  vand v6,v4,v2[e8] // V6 = Nibble Of Column 1 (& $000F)
  vmudn v5,v0[e11]  // V5 = Nibble Of Column 6 << 3
  vmudn v6,v0[e15]  // V6 = Nibble Of Column 7 << 7
  vor v10,v5,v6[e0] // V10 = Packed Column 6,7 Byte


// Store Tile:
  suv v7[e0],0(a0)  // Tile Row 0,1 = V7 Unsigned Bytes
  addi a0,8
  suv v8[e0],0(a0)  // Tile Row 2,3 = V8 Unsigned Bytes
  addi a0,8
  suv v9[e0],0(a0)  // Tile Row 4,5 = V9 Unsigned Bytes
  addi a0,8
  suv v10[e0],0(a0) // Tile Row 6,7 = V10 Unsigned Bytes

  addi a0,8 // A0 = Next GameBoy Tile Offset

  bnez t1,LoopTiles // IF (Tile Counter != 0) Loop Tiles
  subi t1,1 // Decrement Tile Counter (Delay Slot)


  lli a0,0 // A0 = SP Memory Address Offset DMEM ($A4000000..$A4001FFF 8KB)
  lli t0,4095 // T0 = Length Of DMA Transfer In Bytes - 1

  mtc0 a0,c0 // Store Memory Offset To SP Memory Address Register ($A4040000)
  mtc0 a1,c1 // Store RAM Offset To SP DRAM Address Register ($A4040004)
  mtc0 t0,c3 // Store DMA Length To SP Write Length Register ($A404000C)

  TILEDMAWRITEBusy:
    mfc0 t0,c4 // T0 = RSP Status Register ($A4040010)
    andi t0,RSP_BSY|RSP_FUL // AND RSP Status Status With $C (Bit 2 = DMA Is Busy, Bit 3 = DMA Is Full)
    bnez t0,TILEDMAWRITEBusy // IF TRUE DMA Is Busy
    nop // Delay Slot

  addi a1,4096 // A1 = Next N64  Tile Offset
  addi a2,2048 // A2 = Next GameBoy Tile Offset

  bnez t2,LoopTileBlocks // IF (Tile Block Counter != 0) Loop Tile Blocks
  subi t2,1 // Decrement Tile Block Counter (Delay Slot)

  break // Set SP Status Halt, Broke & Check For Interrupt, Set SP Program Counter To $0000
align(8) // Align 64-Bit
base RSPTILECode+pc() // Set End Of RSP Code Object
RSPTILECodeEnd:


align(8) // Align 64-Bit
RDPBuffer:
arch n64.rdp
  Set_Scissor 80<<2,40<<2, 0,0, 240<<2,184<<2 // Set Scissor: XH 80.0,YH 40.0, Scissor Field Enable Off,Field Off, XL 240.0,YL 184.0
  Set_Color_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,320-1, $00100000 // Set Color Image: FORMAT RGBA,SIZE 16B,WIDTH 320, DRAM ADDRESS $00100000

  Set_Other_Modes EN_TLUT|SAMPLE_TYPE|BI_LERP_0|ALPHA_DITHER_SEL_NO_DITHER|B_M2A_0_1|FORCE_BLEND|IMAGE_READ_EN // Set Other Modes
  Set_Combine_Mode $0,$00, 0,0, $1,$01, $0,$F, 1,0, 0,0,0, 7,7,7 // Set Combine Mode: SubA RGB0,MulRGB0, SubA Alpha0,MulAlpha0, SubA RGB1,MulRGB1, SubB RGB0,SubB RGB1, SubA Alpha1,MulAlpha1, AddRGB0,SubB Alpha0,AddAlpha0, AddRGB1,SubB Alpha1,AddAlpha1

  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,1-1, N64TLUT // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 1, N64TLUT DRAM ADDRESS
  Set_Tile 0,0,0, $100, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: TMEM Address $100, Tile 0
  Load_Tlut 0<<2,0<<2, 0, 15<<2,0<<2 // Load Tlut: SL 0.0,TL 0.0, Tile 0, SH 15.0,TH 0.0

// BG Column 0..31 / Row 0..31 
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,1, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0

RDPGBTILE:

  define y(0)
  while {y} < 32 {
    define x(0)
    while {x} < 32 {
      Sync_Tile // Sync Tile
      Set_Texture_Image IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_8B,4-1, N64TILE+(32*(({y}*32)+{x})) // Set Texture Image: FORMAT COLOR INDEX,SIZE 8B,WIDTH 4, Tile 1 DRAM ADDRESS
      Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load Tile: SL,TL, Tile, SH,TH
      Texture_Rectangle_Flip (88+({x}*8))<<2,(48+({y}*8))<<2, 0, (80+({x}*8))<<2,(40+({y}*8))<<2, 0<<5,7<<5, 1<<10,-1<<10 // Texture Rectangle Flip: XL,YL, Tile, XH,YH, S,T, DSDX,DTDY

      evaluate x({x} + 1)
    }
    evaluate y({y} + 1)
  }

  Sync_Full // Ensure Entire Scene Is Fully Drawn
RDPBufferEnd: