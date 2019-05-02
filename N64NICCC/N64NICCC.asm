// N64 'Bare Metal' 16BPP 320x240 Atari-ST-NICCC Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "N64NICCC.N64", create
fill 1052672 // Set ROM Size

origin $00000000
base $80000000 // Entry Point Of Code
include "LIB/N64.INC" // Include N64 Definitions
include "LIB/N64_HEADER.ASM" // Include 64 Byte Header & Vector Table
insert "LIB/N64_BOOTCODE.BIN" // Include 4032 Byte Boot Code

Start:
  include "LIB/N64_GFX.INC" // Include Graphics Macros
  N64_INIT() // Run N64 Initialisation Routine

  ScreenNTSC(320, 240, BPP16, $A0100000) // Screen NTSC: 320x240, 16BPP, DRAM Origin $A0100000

  la a0,SceneData // A0 = Scene Data Start Address
  la a1,Palette   // A1 = Palette Color Data Address
  lui t9,$A010    // T9 = Double Buffer Frame Offset = Frame A

LoopFrames:
  lui a2,VI_BASE // A2 = VI Base Register ($A4400000)
  lli t0,200 // T0 = Scan Line
  WaitVBlank:
    lw t1,VI_V_CURRENT_LINE(a2) // T1 = Current Scan Line
    bne t1,t0,WaitVBlank // IF (Current Scan Line != Scan Line) Wait
    nop // ELSE Continue (Delay Slot)

  // Double Buffer Screen
  lui a2,VI_BASE // A2 = VI Base Register ($A4400000)
  sw t9,VI_ORIGIN(a2) // Store Origin To VI Origin Register ($A4400004)
  lui t0,$A010
  beq t0,t9,FrameEnd
  lui t9,$A020 // T9 = Double Buffer Frame Offset = Frame B
  lui t9,$A010 // T9 = Double Buffer Frame Offset = Frame A
  FrameEnd:
  la a2,$A0000000|(DoubleBuffer&$3FFFFF)
  sw t9,4(a2)

  // Frame Clear Screen
  lui t0,DPC_BASE                    // T0 = Reality Display Processer Control Interface Base Register ($A4100000)
  la t1,FrameClearScreenRDPBuffer    // T1 = DPC Command Start Address
  sw t1,DPC_START(t0)                // Store DPC Command Start Address To DP Start Register ($A4100000)
  la t1,FrameClearScreenRDPBufferEnd // T1 = DPC Command End Address
  sw t1,DPC_END(t0)                  // Store DPC Command End Address To DP End Register ($A4100004)

  lbu t0,0(a0) // T0 = Frame Data Byte Flags (Bit 0: Frame Clear Screen, Bit 1: Frame Contains Palette Data, Bit 2: Frame Indexed Mode)
  addiu a0,1   // Increment Scene Data Address

  andi t1,t0,2 // T1 = Frame Data Byte Flags Bit 1 (Frame Contains Palette Data)
  beqz t1,SkipPalette
  nop // Delay Slot

  // Frame Palette
  lbu t1,0(a0) // T1 = Palette Bitmask HI Byte
  sll t1,8     // T1 <<= 8
  lbu t2,1(a0) // T2 = Palette Bitmask LO Byte
  or t1,t2     // T1 = Palette Bitmask Word (16-Bits)
  addiu a0,2   // Increment Scene Data Address

  // Palette Color 0
  andi t2,t1,$8000 // T2 = Palette Bitmask Bit 15 (Palette Color 0 Flag)
  beqz t2,PaletteColor1
  nop // Delay Slot

  lbu t2,0(a0) // T2 = Palette Color HI Byte
  lbu t3,1(a0) // T3 = Palette Color LO Byte
  sll t2,8     // T2 <<= 8
  or t2,t3     // T2 = Palette Color Word (16-Bits)
  addiu a0,2   // Increment Scene Data Address

  andi t3,t2,$000F // T3 = Blue (4 Bits)
  sll t3,12        // T3 <<= 12
  andi t4,t2,$00F0 // T4 = Green (4 Bits)
  sll t4,16        // T4 <<= 16
  andi t2,$0F00    // T2 = Red (4 Bits)
  sll t2,20        // T2 <<= 20

  or t2,t3
  or t2,t4    // T2 = Palette Color (RGBA8888)
  sw t2,0(a1) // Store Palette Color 0

PaletteColor1: // Palette Color 1
  andi t2,t1,$4000 // T2 = Palette Bitmask Bit 14 (Palette Color 1 Flag)
  beqz t2,PaletteColor2
  nop // Delay Slot

  lbu t2,0(a0) // T2 = Palette Color HI Byte
  lbu t3,1(a0) // T3 = Palette Color LO Byte
  sll t2,8     // T2 <<= 8
  or t2,t3     // T2 = Palette Color Word (16-Bits)
  addiu a0,2   // Increment Scene Data Address

  andi t3,t2,$000F // T3 = Blue (4 Bits)
  sll t3,12        // T3 <<= 12
  andi t4,t2,$00F0 // T4 = Green (4 Bits)
  sll t4,16        // T4 <<= 16
  andi t2,$0F00    // T2 = Red (4 Bits)
  sll t2,20        // T2 <<= 20

  or t2,t3
  or t2,t4    // T2 = Palette Color (RGBA8888)
  sw t2,4(a1) // Store Palette Color 1

PaletteColor2: // Palette Color 2
  andi t2,t1,$2000 // T2 = Palette Bitmask Bit 13 (Palette Color 2 Flag)
  beqz t2,PaletteColor3
  nop // Delay Slot

  lbu t2,0(a0) // T2 = Palette Color HI Byte
  lbu t3,1(a0) // T3 = Palette Color LO Byte
  sll t2,8     // T2 <<= 8
  or t2,t3     // T2 = Palette Color Word (16-Bits)
  addiu a0,2   // Increment Scene Data Address

  andi t3,t2,$000F // T3 = Blue (4 Bits)
  sll t3,12        // T3 <<= 12
  andi t4,t2,$00F0 // T4 = Green (4 Bits)
  sll t4,16        // T4 <<= 16
  andi t2,$0F00    // T2 = Red (4 Bits)
  sll t2,20        // T2 <<= 20

  or t2,t3
  or t2,t4    // T2 = Palette Color (RGBA8888)
  sw t2,8(a1) // Store Palette Color 2

PaletteColor3: // Palette Color 3
  andi t2,t1,$1000 // T2 = Palette Bitmask Bit 12 (Palette Color 3 Flag)
  beqz t2,PaletteColor4
  nop // Delay Slot

  lbu t2,0(a0) // T2 = Palette Color HI Byte
  lbu t3,1(a0) // T3 = Palette Color LO Byte
  sll t2,8     // T2 <<= 8
  or t2,t3     // T2 = Palette Color Word (16-Bits)
  addiu a0,2   // Increment Scene Data Address

  andi t3,t2,$000F // T3 = Blue (4 Bits)
  sll t3,12        // T3 <<= 12
  andi t4,t2,$00F0 // T4 = Green (4 Bits)
  sll t4,16        // T4 <<= 16
  andi t2,$0F00    // T2 = Red (4 Bits)
  sll t2,20        // T2 <<= 20

  or t2,t3
  or t2,t4     // T2 = Palette Color (RGBA8888)
  sw t2,12(a1) // Store Palette Color 3

PaletteColor4: // Palette Color 4
  andi t2,t1,$0800 // T2 = Palette Bitmask Bit 11 (Palette Color 4 Flag)
  beqz t2,PaletteColor5
  nop // Delay Slot

  lbu t2,0(a0) // T2 = Palette Color HI Byte
  lbu t3,1(a0) // T3 = Palette Color LO Byte
  sll t2,8     // T2 <<= 8
  or t2,t3     // T2 = Palette Color Word (16-Bits)
  addiu a0,2   // Increment Scene Data Address

  andi t3,t2,$000F // T3 = Blue (4 Bits)
  sll t3,12        // T3 <<= 12
  andi t4,t2,$00F0 // T4 = Green (4 Bits)
  sll t4,16        // T4 <<= 16
  andi t2,$0F00    // T2 = Red (4 Bits)
  sll t2,20        // T2 <<= 20

  or t2,t3
  or t2,t4     // T2 = Palette Color (RGBA8888)
  sw t2,16(a1) // Store Palette Color 4

PaletteColor5: // Palette Color 5
  andi t2,t1,$0400 // T2 = Palette Bitmask Bit 10 (Palette Color 5 Flag)
  beqz t2,PaletteColor6
  nop // Delay Slot

  lbu t2,0(a0) // T2 = Palette Color HI Byte
  lbu t3,1(a0) // T3 = Palette Color LO Byte
  sll t2,8     // T2 <<= 8
  or t2,t3     // T2 = Palette Color Word (16-Bits)
  addiu a0,2   // Increment Scene Data Address

  andi t3,t2,$000F // T3 = Blue (4 Bits)
  sll t3,12        // T3 <<= 12
  andi t4,t2,$00F0 // T4 = Green (4 Bits)
  sll t4,16        // T4 <<= 16
  andi t2,$0F00    // T2 = Red (4 Bits)
  sll t2,20        // T2 <<= 20

  or t2,t3
  or t2,t4     // T2 = Palette Color (RGBA8888)
  sw t2,20(a1) // Store Palette Color 5

PaletteColor6: // Palette Color 6
  andi t2,t1,$0200 // T2 = Palette Bitmask Bit 9 (Palette Color 6 Flag)
  beqz t2,PaletteColor7
  nop // Delay Slot

  lbu t2,0(a0) // T2 = Palette Color HI Byte
  lbu t3,1(a0) // T3 = Palette Color LO Byte
  sll t2,8     // T2 <<= 8
  or t2,t3     // T2 = Palette Color Word (16-Bits)
  addiu a0,2   // Increment Scene Data Address

  andi t3,t2,$000F // T3 = Blue (4 Bits)
  sll t3,12        // T3 <<= 12
  andi t4,t2,$00F0 // T4 = Green (4 Bits)
  sll t4,16        // T4 <<= 16
  andi t2,$0F00    // T2 = Red (4 Bits)
  sll t2,20        // T2 <<= 20

  or t2,t3
  or t2,t4     // T2 = Palette Color (RGBA8888)
  sw t2,24(a1) // Store Palette Color 6

PaletteColor7: // Palette Color 7
  andi t2,t1,$0100 // T2 = Palette Bitmask Bit 8 (Palette Color 7 Flag)
  beqz t2,PaletteColor8
  nop // Delay Slot

  lbu t2,0(a0) // T2 = Palette Color HI Byte
  lbu t3,1(a0) // T3 = Palette Color LO Byte
  sll t2,8     // T2 <<= 8
  or t2,t3     // T2 = Palette Color Word (16-Bits)
  addiu a0,2   // Increment Scene Data Address

  andi t3,t2,$000F // T3 = Blue (4 Bits)
  sll t3,12        // T3 <<= 12
  andi t4,t2,$00F0 // T4 = Green (4 Bits)
  sll t4,16        // T4 <<= 16
  andi t2,$0F00    // T2 = Red (4 Bits)
  sll t2,20        // T2 <<= 20

  or t2,t3
  or t2,t4     // T2 = Palette Color (RGBA8888)
  sw t2,28(a1) // Store Palette Color 7

PaletteColor8: // Palette Color 8
  andi t2,t1,$0080 // T2 = Palette Bitmask Bit 7 (Palette Color 8 Flag)
  beqz t2,PaletteColor9
  nop // Delay Slot

  lbu t2,0(a0) // T2 = Palette Color HI Byte
  lbu t3,1(a0) // T3 = Palette Color LO Byte
  sll t2,8     // T2 <<= 8
  or t2,t3     // T2 = Palette Color Word (16-Bits)
  addiu a0,2   // Increment Scene Data Address

  andi t3,t2,$000F // T3 = Blue (4 Bits)
  sll t3,12        // T3 <<= 12
  andi t4,t2,$00F0 // T4 = Green (4 Bits)
  sll t4,16        // T4 <<= 16
  andi t2,$0F00    // T2 = Red (4 Bits)
  sll t2,20        // T2 <<= 20

  or t2,t3
  or t2,t4     // T2 = Palette Color (RGBA8888)
  sw t2,32(a1) // Store Palette Color 8

PaletteColor9: // Palette Color 9
  andi t2,t1,$0040 // T2 = Palette Bitmask Bit 6 (Palette Color 9 Flag)
  beqz t2,PaletteColor10
  nop // Delay Slot

  lbu t2,0(a0) // T2 = Palette Color HI Byte
  lbu t3,1(a0) // T3 = Palette Color LO Byte
  sll t2,8     // T2 <<= 8
  or t2,t3     // T2 = Palette Color Word (16-Bits)
  addiu a0,2   // Increment Scene Data Address

  andi t3,t2,$000F // T3 = Blue (4 Bits)
  sll t3,12        // T3 <<= 12
  andi t4,t2,$00F0 // T4 = Green (4 Bits)
  sll t4,16        // T4 <<= 16
  andi t2,$0F00    // T2 = Red (4 Bits)
  sll t2,20        // T2 <<= 20

  or t2,t3
  or t2,t4     // T2 = Palette Color (RGBA8888)
  sw t2,36(a1) // Store Palette Color 9

PaletteColor10: // Palette Color 10
  andi t2,t1,$0020 // T2 = Palette Bitmask Bit 5 (Palette Color 10 Flag)
  beqz t2,PaletteColor11
  nop // Delay Slot

  lbu t2,0(a0) // T2 = Palette Color HI Byte
  lbu t3,1(a0) // T3 = Palette Color LO Byte
  sll t2,8     // T2 <<= 8
  or t2,t3     // T2 = Palette Color Word (16-Bits)
  addiu a0,2   // Increment Scene Data Address

  andi t3,t2,$000F // T3 = Blue (4 Bits)
  sll t3,12        // T3 <<= 12
  andi t4,t2,$00F0 // T4 = Green (4 Bits)
  sll t4,16        // T4 <<= 16
  andi t2,$0F00    // T2 = Red (4 Bits)
  sll t2,20        // T2 <<= 20

  or t2,t3
  or t2,t4     // T2 = Palette Color (RGBA8888)
  sw t2,40(a1) // Store Palette Color 10

PaletteColor11: // Palette Color 11
  andi t2,t1,$0010 // T2 = Palette Bitmask Bit 4 (Palette Color 11 Flag)
  beqz t2,PaletteColor12
  nop // Delay Slot

  lbu t2,0(a0) // T2 = Palette Color HI Byte
  lbu t3,1(a0) // T3 = Palette Color LO Byte
  sll t2,8     // T2 <<= 8
  or t2,t3     // T2 = Palette Color Word (16-Bits)
  addiu a0,2   // Increment Scene Data Address

  andi t3,t2,$000F // T3 = Blue (4 Bits)
  sll t3,12        // T3 <<= 12
  andi t4,t2,$00F0 // T4 = Green (4 Bits)
  sll t4,16        // T4 <<= 16
  andi t2,$0F00    // T2 = Red (4 Bits)
  sll t2,20        // T2 <<= 20

  or t2,t3
  or t2,t4     // T2 = Palette Color (RGBA8888)
  sw t2,44(a1) // Store Palette Color 11

PaletteColor12: // Palette Color 12
  andi t2,t1,$0008 // T2 = Palette Bitmask Bit 3 (Palette Color 12 Flag)
  beqz t2,PaletteColor13
  nop // Delay Slot

  lbu t2,0(a0) // T2 = Palette Color HI Byte
  lbu t3,1(a0) // T3 = Palette Color LO Byte
  sll t2,8     // T2 <<= 8
  or t2,t3     // T2 = Palette Color Word (16-Bits)
  addiu a0,2   // Increment Scene Data Address

  andi t3,t2,$000F // T3 = Blue (4 Bits)
  sll t3,12        // T3 <<= 12
  andi t4,t2,$00F0 // T4 = Green (4 Bits)
  sll t4,16        // T4 <<= 16
  andi t2,$0F00    // T2 = Red (4 Bits)
  sll t2,20        // T2 <<= 20

  or t2,t3
  or t2,t4     // T2 = Palette Color (RGBA8888)
  sw t2,48(a1) // Store Palette Color 12

PaletteColor13: // Palette Color 13
  andi t2,t1,$0004 // T2 = Palette Bitmask Bit 2 (Palette Color 13 Flag)
  beqz t2,PaletteColor14
  nop // Delay Slot

  lbu t2,0(a0) // T2 = Palette Color HI Byte
  lbu t3,1(a0) // T3 = Palette Color LO Byte
  sll t2,8     // T2 <<= 8
  or t2,t3     // T2 = Palette Color Word (16-Bits)
  addiu a0,2   // Increment Scene Data Address

  andi t3,t2,$000F // T3 = Blue (4 Bits)
  sll t3,12        // T3 <<= 12
  andi t4,t2,$00F0 // T4 = Green (4 Bits)
  sll t4,16        // T4 <<= 16
  andi t2,$0F00    // T2 = Red (4 Bits)
  sll t2,20        // T2 <<= 20

  or t2,t3
  or t2,t4     // T2 = Palette Color (RGBA8888)
  sw t2,52(a1) // Store Palette Color 13

PaletteColor14: // Palette Color 14
  andi t2,t1,$0002 // T2 = Palette Bitmask Bit 1 (Palette Color 14 Flag)
  beqz t2,PaletteColor15
  nop // Delay Slot

  lbu t2,0(a0) // T2 = Palette Color HI Byte
  lbu t3,1(a0) // T3 = Palette Color LO Byte
  sll t2,8     // T2 <<= 8
  or t2,t3     // T2 = Palette Color Word (16-Bits)
  addiu a0,2   // Increment Scene Data Address

  andi t3,t2,$000F // T3 = Blue (4 Bits)
  sll t3,12        // T3 <<= 12
  andi t4,t2,$00F0 // T4 = Green (4 Bits)
  sll t4,16        // T4 <<= 16
  andi t2,$0F00    // T2 = Red (4 Bits)
  sll t2,20        // T2 <<= 20

  or t2,t3
  or t2,t4     // T2 = Palette Color (RGBA8888)
  sw t2,56(a1) // Store Palette Color 14

PaletteColor15: // Palette Color 15
  andi t2,t1,$0001 // T2 = Palette Bitmask Bit 0 (Palette Color 15 Flag)
  beqz t2,SkipPalette
  nop // Delay Slot

  lbu t2,0(a0) // T2 = Palette Color HI Byte
  lbu t3,1(a0) // T3 = Palette Color LO Byte
  sll t2,8     // T2 <<= 8
  or t2,t3     // T2 = Palette Color Word (16-Bits)
  addiu a0,2   // Increment Scene Data Address

  andi t3,t2,$000F // T3 = Blue (4 Bits)
  sll t3,12        // T3 <<= 12
  andi t4,t2,$00F0 // T4 = Green (4 Bits)
  sll t4,16        // T4 <<= 16
  andi t2,$0F00    // T2 = Red (4 Bits)
  sll t2,20        // T2 <<= 20

  or t2,t3
  or t2,t4     // T2 = Palette Color (RGBA8888)
  sw t2,60(a1) // Store Palette Color 15

SkipPalette:
  andi t1,t0,4 // T1 = Frame Data Byte Flags Bit 2 (Frame Indexed Mode)
  beqz t1,FrameNonIndexed
  nop // Delay Slot

  // Frame Indexed Mode
  lbu t0,0(a0) // T0 = Number Of Vertices
  addiu a0,1   // Increment Scene Data Address
  sll t0,1     // T0 <<= 1 (Multiply By 2 For X/Y Bytes Length)
  or a2,a0,r0  // A2 = Vertex Index Data Address
  addu a0,t0   // Scene Data Address += X/Y Bytes Length

FrameIndexLoop:
  lbu t0,0(a0) // T0 = Poly-Descripter Byte (Bits 4..7 = Color-Index, Bits 0..3 = Number Of Polygon Vertices (3..15))
               // ($FF = End Of Frame, $FE = End Of Frame & Skip To Next 64KB Block, $FD = End Of Stream)
  addiu a0,1   // Increment Scene Data Address

  ori t1,r0,$00FF // T1 = End Of Frame Byte Code ($FF)
  beq t0,t1,EndOfFrame
  nop // Delay Slot

  ori t1,r0,$00FE // T1 = End Of Frame & Skip To Next 64KB Block Byte Code ($FE)
  beq t0,t1,EndOfFrameSkipBlock
  nop // Delay Slot

  ori t1,r0,$00FD // T1 = End Of Stream Byte Code ($FD)
  beq t0,t1,EndOfStream
  nop // Delay Slot

  andi t1,t0,$000F // T1 = Number Of Polygon Vertices (3..15)

  ori t2,r0,3          // T2 = 3
  beq t1,t2,IndexPoly3 // Indexed Polygon (3 Vertices)
  nop // Delay Slot

  ori t2,r0,4          // T2 = 4
  beq t1,t2,IndexPoly4 // Indexed Polygon (4 Vertices)
  nop // Delay Slot

  ori t2,r0,5          // T2 = 5
  beq t1,t2,IndexPoly5 // Indexed Polygon (5 Vertices)
  nop // Delay Slot

  ori t2,r0,6          // T2 = 6
  beq t1,t2,IndexPoly6 // Indexed Polygon (6 Vertices)
  nop // Delay Slot

  ori t2,r0,7          // T2 = 7
  beq t1,t2,IndexPoly7 // Indexed Polygon (7 Vertices)
  nop // Delay Slot

IndexPoly3: // Indexed Polygon (3 Vertices)
  srl t0,4    // T0 >>= 4 (Polygon Palette Color Index)
  sll t0,2    // T0 <<= 2
  add t0,a1   // T0 += Palette Color Data Address
  lw t0,0(t0) // T0 = Palette Color

  la a3,$A0000000|(PolyRDPBuffer&$3FFFFFF) // A3 = RDP Buffer Address
  sw t0,4(a3) // Store Polygon Palette Color

  lbu t0,0(a0) // T0 = Polygon Vertex Index 0
  addiu a0,1   // Increment Scene Data Address
  sll t0,1     // T0 <<= 1
  add t0,a2    // T0 += A2 (Vertex Index Data Address)
  lbu s0,0(t0) // S0 = Vertex X0
  lbu s1,1(t0) // S1 = Vertex Y0

  lbu t0,0(a0) // T0 = Polygon Vertex Index 1
  addiu a0,1   // Increment Scene Data Address
  sll t0,1     // T0 <<= 1
  add t0,a2    // T0 += A2 (Vertex Index Data Address)
  lbu s2,0(t0) // S2 = Vertex X1
  lbu s3,1(t0) // S3 = Vertex Y1

  lbu t0,0(a0) // T0 = Polygon Vertex Index 2
  addiu a0,1   // Increment Scene Data Address
  sll t0,1     // T0 <<= 1
  add t0,a2    // T0 += A2 (Vertex Index Data Address)
  lbu s4,0(t0) // S4 = Vertex X2
  lbu s5,1(t0) // S5 = Vertex Y2

  jal PlotFillTriangle // Plot Fill Triangle
  nop // Delay Slot

  j FrameIndexLoop // Frame Index Loop
  nop // Delay Slot

IndexPoly4: // Indexed Polygon (4 Vertices)
  srl t0,4    // T0 >>= 4 (Polygon Palette Color Index)
  sll t0,2    // T0 <<= 2
  add t0,a1   // T0 += Palette Color Data Address
  lw t0,0(t0) // T0 = Palette Color

  la a3,$A0000000|(PolyRDPBuffer&$3FFFFFF) // A3 = RDP Buffer Address
  sw t0,4(a3) // Store Polygon Palette Color

  lbu t0,0(a0) // T0 = Polygon Vertex Index 0
  addiu a0,1   // Increment Scene Data Address
  sll t0,1     // T0 <<= 1
  add t0,a2    // T0 += A2 (Vertex Index Data Address)
  lbu s0,0(t0) // S0 = Vertex X0
  lbu s1,1(t0) // S1 = Vertex Y0

  lbu t0,0(a0) // T0 = Polygon Vertex Index 1
  addiu a0,1   // Increment Scene Data Address
  sll t0,1     // T0 <<= 1
  add t0,a2    // T0 += A2 (Vertex Index Data Address)
  lbu s2,0(t0) // S2 = Vertex X1
  lbu s3,1(t0) // S3 = Vertex Y1

  lbu t0,0(a0) // T0 = Polygon Vertex Index 2
  addiu a0,1   // Increment Scene Data Address
  sll t0,1     // T0 <<= 1
  add t0,a2    // T0 += A2 (Vertex Index Data Address)
  lbu s4,0(t0) // S4 = Vertex X2
  lbu s5,1(t0) // S5 = Vertex Y2

  jal PlotFillTriangle // Plot Fill Triangle
  nop // Delay Slot


  lbu t0,-3(a0) // T0 = Polygon Vertex Index 0
  sll t0,1      // T0 <<= 1
  add t0,a2     // T0 += A2 (Vertex Index Data Address)
  lbu s0,0(t0)  // S0 = Vertex X0
  lbu s1,1(t0)  // S1 = Vertex Y0

  lbu t0,-1(a0) // T0 = Polygon Vertex Index 2
  sll t0,1      // T0 <<= 1
  add t0,a2     // T0 += A2 (Vertex Index Data Address)
  lbu s2,0(t0)  // S2 = Vertex X1
  lbu s3,1(t0)  // S3 = Vertex Y1

  lbu t0,0(a0) // T0 = Polygon Vertex Index 3
  addiu a0,1   // Increment Scene Data Address
  sll t0,1     // T0 <<= 1
  add t0,a2    // T0 += A2 (Vertex Index Data Address)
  lbu s4,0(t0) // S4 = Vertex X2
  lbu s5,1(t0) // S5 = Vertex Y2

  jal PlotFillTriangle // Plot Fill Triangle
  nop // Delay Slot

  j FrameIndexLoop // Frame Index Loop
  nop // Delay Slot

IndexPoly5: // Indexed Polygon (5 Vertices)
  srl t0,4    // T0 >>= 4 (Polygon Palette Color Index)
  sll t0,2    // T0 <<= 2
  add t0,a1   // T0 += Palette Color Data Address
  lw t0,0(t0) // T0 = Palette Color

  la a3,$A0000000|(PolyRDPBuffer&$3FFFFFF) // A3 = RDP Buffer Address
  sw t0,4(a3) // Store Polygon Palette Color

  lbu t0,0(a0) // T0 = Polygon Vertex Index 0
  addiu a0,1   // Increment Scene Data Address
  sll t0,1     // T0 <<= 1
  add t0,a2    // T0 += A2 (Vertex Index Data Address)
  lbu s0,0(t0) // S0 = Vertex X0
  lbu s1,1(t0) // S1 = Vertex Y0

  lbu t0,0(a0) // T0 = Polygon Vertex Index 1
  addiu a0,1   // Increment Scene Data Address
  sll t0,1     // T0 <<= 1
  add t0,a2    // T0 += A2 (Vertex Index Data Address)
  lbu s2,0(t0) // S2 = Vertex X1
  lbu s3,1(t0) // S3 = Vertex Y1

  lbu t0,0(a0) // T0 = Polygon Vertex Index 2
  addiu a0,1   // Increment Scene Data Address
  sll t0,1     // T0 <<= 1
  add t0,a2    // T0 += A2 (Vertex Index Data Address)
  lbu s4,0(t0) // S4 = Vertex X2
  lbu s5,1(t0) // S5 = Vertex Y2

  jal PlotFillTriangle // Plot Fill Triangle
  nop // Delay Slot


  lbu t0,-3(a0) // T0 = Polygon Vertex Index 0
  sll t0,1      // T0 <<= 1
  add t0,a2     // T0 += A2 (Vertex Index Data Address)
  lbu s0,0(t0)  // S0 = Vertex X0
  lbu s1,1(t0)  // S1 = Vertex Y0

  lbu t0,-1(a0) // T0 = Polygon Vertex Index 2
  sll t0,1      // T0 <<= 1
  add t0,a2     // T0 += A2 (Vertex Index Data Address)
  lbu s2,0(t0)  // S2 = Vertex X1
  lbu s3,1(t0)  // S3 = Vertex Y1

  lbu t0,0(a0) // T0 = Polygon Vertex Index 3
  addiu a0,1   // Increment Scene Data Address
  sll t0,1     // T0 <<= 1
  add t0,a2    // T0 += A2 (Vertex Index Data Address)
  lbu s4,0(t0) // S4 = Vertex X2
  lbu s5,1(t0) // S5 = Vertex Y2

  jal PlotFillTriangle // Plot Fill Triangle
  nop // Delay Slot


  lbu t0,-4(a0) // T0 = Polygon Vertex Index 0
  sll t0,1      // T0 <<= 1
  add t0,a2     // T0 += A2 (Vertex Index Data Address)
  lbu s0,0(t0)  // S0 = Vertex X0
  lbu s1,1(t0)  // S1 = Vertex Y0

  lbu t0,-1(a0) // T0 = Polygon Vertex Index 3
  sll t0,1      // T0 <<= 1
  add t0,a2     // T0 += A2 (Vertex Index Data Address)
  lbu s2,0(t0)  // S2 = Vertex X1
  lbu s3,1(t0)  // S3 = Vertex Y1

  lbu t0,0(a0) // T0 = Polygon Vertex Index 4
  addiu a0,1   // Increment Scene Data Address
  sll t0,1     // T0 <<= 1
  add t0,a2    // T0 += A2 (Vertex Index Data Address)
  lbu s4,0(t0) // S4 = Vertex X2
  lbu s5,1(t0) // S5 = Vertex Y2

  jal PlotFillTriangle // Plot Fill Triangle
  nop // Delay Slot

  j FrameIndexLoop // Frame Index Loop
  nop // Delay Slot

IndexPoly6: // Indexed Polygon (6 Vertices)
  srl t0,4    // T0 >>= 4 (Polygon Palette Color Index)
  sll t0,2    // T0 <<= 2
  add t0,a1   // T0 += Palette Color Data Address
  lw t0,0(t0) // T0 = Palette Color

  la a3,$A0000000|(PolyRDPBuffer&$3FFFFFF) // A3 = RDP Buffer Address
  sw t0,4(a3) // Store Polygon Palette Color

  lbu t0,0(a0) // T0 = Polygon Vertex Index 0
  addiu a0,1   // Increment Scene Data Address
  sll t0,1     // T0 <<= 1
  add t0,a2    // T0 += A2 (Vertex Index Data Address)
  lbu s0,0(t0) // S0 = Vertex X0
  lbu s1,1(t0) // S1 = Vertex Y0

  lbu t0,0(a0) // T0 = Polygon Vertex Index 1
  addiu a0,1   // Increment Scene Data Address
  sll t0,1     // T0 <<= 1
  add t0,a2    // T0 += A2 (Vertex Index Data Address)
  lbu s2,0(t0) // S2 = Vertex X1
  lbu s3,1(t0) // S3 = Vertex Y1

  lbu t0,0(a0) // T0 = Polygon Vertex Index 2
  addiu a0,1   // Increment Scene Data Address
  sll t0,1     // T0 <<= 1
  add t0,a2    // T0 += A2 (Vertex Index Data Address)
  lbu s4,0(t0) // S4 = Vertex X2
  lbu s5,1(t0) // S5 = Vertex Y2

  jal PlotFillTriangle // Plot Fill Triangle
  nop // Delay Slot


  lbu t0,-3(a0) // T0 = Polygon Vertex Index 0
  sll t0,1      // T0 <<= 1
  add t0,a2     // T0 += A2 (Vertex Index Data Address)
  lbu s0,0(t0)  // S0 = Vertex X0
  lbu s1,1(t0)  // S1 = Vertex Y0

  lbu t0,-1(a0) // T0 = Polygon Vertex Index 2
  sll t0,1      // T0 <<= 1
  add t0,a2     // T0 += A2 (Vertex Index Data Address)
  lbu s2,0(t0)  // S2 = Vertex X1
  lbu s3,1(t0)  // S3 = Vertex Y1

  lbu t0,0(a0) // T0 = Polygon Vertex Index 3
  addiu a0,1   // Increment Scene Data Address
  sll t0,1     // T0 <<= 1
  add t0,a2    // T0 += A2 (Vertex Index Data Address)
  lbu s4,0(t0) // S4 = Vertex X2
  lbu s5,1(t0) // S5 = Vertex Y2

  jal PlotFillTriangle // Plot Fill Triangle
  nop // Delay Slot


  lbu t0,-4(a0) // T0 = Polygon Vertex Index 0
  sll t0,1      // T0 <<= 1
  add t0,a2     // T0 += A2 (Vertex Index Data Address)
  lbu s0,0(t0)  // S0 = Vertex X0
  lbu s1,1(t0)  // S1 = Vertex Y0

  lbu t0,-1(a0) // T0 = Polygon Vertex Index 3
  sll t0,1      // T0 <<= 1
  add t0,a2     // T0 += A2 (Vertex Index Data Address)
  lbu s2,0(t0)  // S2 = Vertex X1
  lbu s3,1(t0)  // S3 = Vertex Y1

  lbu t0,0(a0) // T0 = Polygon Vertex Index 4
  addiu a0,1   // Increment Scene Data Address
  sll t0,1     // T0 <<= 1
  add t0,a2    // T0 += A2 (Vertex Index Data Address)
  lbu s4,0(t0) // S4 = Vertex X2
  lbu s5,1(t0) // S5 = Vertex Y2

  jal PlotFillTriangle // Plot Fill Triangle
  nop // Delay Slot


  lbu t0,-5(a0) // T0 = Polygon Vertex Index 0
  sll t0,1      // T0 <<= 1
  add t0,a2     // T0 += A2 (Vertex Index Data Address)
  lbu s0,0(t0)  // S0 = Vertex X0
  lbu s1,1(t0)  // S1 = Vertex Y0

  lbu t0,-1(a0) // T0 = Polygon Vertex Index 4
  sll t0,1      // T0 <<= 1
  add t0,a2     // T0 += A2 (Vertex Index Data Address)
  lbu s2,0(t0)  // S2 = Vertex X1
  lbu s3,1(t0)  // S3 = Vertex Y1

  lbu t0,0(a0) // T0 = Polygon Vertex Index 5
  addiu a0,1   // Increment Scene Data Address
  sll t0,1     // T0 <<= 1
  add t0,a2    // T0 += A2 (Vertex Index Data Address)
  lbu s4,0(t0) // S4 = Vertex X2
  lbu s5,1(t0) // S5 = Vertex Y2

  jal PlotFillTriangle // Plot Fill Triangle
  nop // Delay Slot

  j FrameIndexLoop // Frame Index Loop
  nop // Delay Slot

IndexPoly7: // Indexed Polygon (7 Vertices)
  srl t0,4    // T0 >>= 4 (Polygon Palette Color Index)
  sll t0,2    // T0 <<= 2
  add t0,a1   // T0 += Palette Color Data Address
  lw t0,0(t0) // T0 = Palette Color

  la a3,$A0000000|(PolyRDPBuffer&$3FFFFFF) // A3 = RDP Buffer Address
  sw t0,4(a3) // Store Polygon Palette Color

  lbu t0,0(a0) // T0 = Polygon Vertex Index 0
  addiu a0,1   // Increment Scene Data Address
  sll t0,1     // T0 <<= 1
  add t0,a2    // T0 += A2 (Vertex Index Data Address)
  lbu s0,0(t0) // S0 = Vertex X0
  lbu s1,1(t0) // S1 = Vertex Y0

  lbu t0,0(a0) // T0 = Polygon Vertex Index 1
  addiu a0,1   // Increment Scene Data Address
  sll t0,1     // T0 <<= 1
  add t0,a2    // T0 += A2 (Vertex Index Data Address)
  lbu s2,0(t0) // S2 = Vertex X1
  lbu s3,1(t0) // S3 = Vertex Y1

  lbu t0,0(a0) // T0 = Polygon Vertex Index 2
  addiu a0,1   // Increment Scene Data Address
  sll t0,1     // T0 <<= 1
  add t0,a2    // T0 += A2 (Vertex Index Data Address)
  lbu s4,0(t0) // S4 = Vertex X2
  lbu s5,1(t0) // S5 = Vertex Y2

  jal PlotFillTriangle // Plot Fill Triangle
  nop // Delay Slot


  lbu t0,-3(a0) // T0 = Polygon Vertex Index 0
  sll t0,1      // T0 <<= 1
  add t0,a2     // T0 += A2 (Vertex Index Data Address)
  lbu s0,0(t0)  // S0 = Vertex X0
  lbu s1,1(t0)  // S1 = Vertex Y0

  lbu t0,-1(a0) // T0 = Polygon Vertex Index 2
  sll t0,1      // T0 <<= 1
  add t0,a2     // T0 += A2 (Vertex Index Data Address)
  lbu s2,0(t0)  // S2 = Vertex X1
  lbu s3,1(t0)  // S3 = Vertex Y1

  lbu t0,0(a0) // T0 = Polygon Vertex Index 3
  addiu a0,1   // Increment Scene Data Address
  sll t0,1     // T0 <<= 1
  add t0,a2    // T0 += A2 (Vertex Index Data Address)
  lbu s4,0(t0) // S4 = Vertex X2
  lbu s5,1(t0) // S5 = Vertex Y2

  jal PlotFillTriangle // Plot Fill Triangle
  nop // Delay Slot


  lbu t0,-4(a0) // T0 = Polygon Vertex Index 0
  sll t0,1      // T0 <<= 1
  add t0,a2     // T0 += A2 (Vertex Index Data Address)
  lbu s0,0(t0)  // S0 = Vertex X0
  lbu s1,1(t0)  // S1 = Vertex Y0

  lbu t0,-1(a0) // T0 = Polygon Vertex Index 3
  sll t0,1      // T0 <<= 1
  add t0,a2     // T0 += A2 (Vertex Index Data Address)
  lbu s2,0(t0)  // S2 = Vertex X1
  lbu s3,1(t0)  // S3 = Vertex Y1

  lbu t0,0(a0) // T0 = Polygon Vertex Index 4
  addiu a0,1   // Increment Scene Data Address
  sll t0,1     // T0 <<= 1
  add t0,a2    // T0 += A2 (Vertex Index Data Address)
  lbu s4,0(t0) // S4 = Vertex X2
  lbu s5,1(t0) // S5 = Vertex Y2

  jal PlotFillTriangle // Plot Fill Triangle
  nop // Delay Slot


  lbu t0,-5(a0) // T0 = Polygon Vertex Index 0
  sll t0,1      // T0 <<= 1
  add t0,a2     // T0 += A2 (Vertex Index Data Address)
  lbu s0,0(t0)  // S0 = Vertex X0
  lbu s1,1(t0)  // S1 = Vertex Y0

  lbu t0,-1(a0) // T0 = Polygon Vertex Index 4
  sll t0,1      // T0 <<= 1
  add t0,a2     // T0 += A2 (Vertex Index Data Address)
  lbu s2,0(t0)  // S2 = Vertex X1
  lbu s3,1(t0)  // S3 = Vertex Y1

  lbu t0,0(a0) // T0 = Polygon Vertex Index 5
  addiu a0,1   // Increment Scene Data Address
  sll t0,1     // T0 <<= 1
  add t0,a2    // T0 += A2 (Vertex Index Data Address)
  lbu s4,0(t0) // S4 = Vertex X2
  lbu s5,1(t0) // S5 = Vertex Y2

  jal PlotFillTriangle // Plot Fill Triangle
  nop // Delay Slot


  lbu t0,-6(a0) // T0 = Polygon Vertex Index 0
  sll t0,1      // T0 <<= 1
  add t0,a2     // T0 += A2 (Vertex Index Data Address)
  lbu s0,0(t0)  // S0 = Vertex X0
  lbu s1,1(t0)  // S1 = Vertex Y0

  lbu t0,-1(a0) // T0 = Polygon Vertex Index 5
  sll t0,1      // T0 <<= 1
  add t0,a2     // T0 += A2 (Vertex Index Data Address)
  lbu s2,0(t0)  // S2 = Vertex X1
  lbu s3,1(t0)  // S3 = Vertex Y1

  lbu t0,0(a0) // T0 = Polygon Vertex Index 6
  addiu a0,1   // Increment Scene Data Address
  sll t0,1     // T0 <<= 1
  add t0,a2    // T0 += A2 (Vertex Index Data Address)
  lbu s4,0(t0) // S4 = Vertex X2
  lbu s5,1(t0) // S5 = Vertex Y2

  jal PlotFillTriangle // Plot Fill Triangle
  nop // Delay Slot

  j FrameIndexLoop // Frame Index Loop
  nop // Delay Slot


FrameNonIndexed: // Frame Non-Indexed Mode
  lbu t0,0(a0) // T0 = Poly-Descripter Byte (Bits 4..7 = Color-Index, Bits 0..3 = Number Of Polygon Vertices (3..15))
               // ($FF = End Of Frame, $FE = End Of Frame & Skip To Next 64KB Block, $FD = End Of Stream)
  addiu a0,1   // Increment Scene Data Address

  ori t1,r0,$00FF // T1 = End Of Frame Byte Code ($FF)
  beq t0,t1,EndOfFrame
  nop // Delay Slot

  ori t1,r0,$00FE // T1 = End Of Frame & Skip To Next 64KB Block Byte Code ($FE)
  beq t0,t1,EndOfFrameSkipBlock
  nop // Delay Slot

  ori t1,r0,$00FD // T1 = End Of Stream Byte Code ($FD)
  beq t0,t1,EndOfStream
  nop // Delay Slot

  andi t1,t0,$000F // T1 = Number Of Polygon Vertices (3..15)

  ori t2,r0,3             // T2 = 3
  beq t1,t2,NonIndexPoly3 // Non-Indexed Polygon (3 Vertices)
  nop // Delay Slot

  ori t2,r0,4             // T2 = 4
  beq t1,t2,NonIndexPoly4 // Non-Indexed Polygon (4 Vertices)
  nop // Delay Slot

  ori t2,r0,5             // T2 = 5
  beq t1,t2,NonIndexPoly5 // Non-Indexed Polygon (5 Vertices)
  nop // Delay Slot

  ori t2,r0,6             // T2 = 6
  beq t1,t2,NonIndexPoly6 // Non-Indexed Polygon (6 Vertices)
  nop // Delay Slot

  ori t2,r0,7             // T2 = 7
  beq t1,t2,NonIndexPoly7 // Non-Indexed Polygon (7 Vertices)
  nop // Delay Slot

NonIndexPoly3: // Non-Indexed Polygon (3 Vertices)
  srl t0,4    // T0 >>= 4 (Polygon Palette Color Index)
  sll t0,2    // T0 <<= 2
  add t0,a1   // T0 += Palette Color Data Address
  lw t0,0(t0) // T0 = Palette Color

  la a3,$A0000000|(PolyRDPBuffer&$3FFFFFF) // A3 = RDP Buffer Address
  sw t0,4(a3) // Store Polygon Palette Color

  lbu s0,0(a0) // S0 = Vertex X0
  lbu s1,1(a0) // S1 = Vertex Y0
  lbu s2,2(a0) // S2 = Vertex X1
  lbu s3,3(a0) // S3 = Vertex Y1
  lbu s4,4(a0) // S4 = Vertex X2
  lbu s5,5(a0) // S5 = Vertex Y2
  addiu a0,6   // Increment Scene Data Address

  jal PlotFillTriangle // Plot Fill Triangle
  nop // Delay Slot

  j FrameNonIndexed // Frame Non-Index Loop
  nop // Delay Slot

NonIndexPoly4: // Non-Indexed Polygon (4 Vertices)
  srl t0,4    // T0 >>= 4 (Polygon Palette Color Index)
  sll t0,2    // T0 <<= 2
  add t0,a1   // T0 += Palette Color Data Address
  lw t0,0(t0) // T0 = Palette Color

  la a3,$A0000000|(PolyRDPBuffer&$3FFFFFF) // A3 = RDP Buffer Address
  sw t0,4(a3) // Store Polygon Palette Color

  lbu s0,0(a0) // S0 = Vertex X0
  lbu s1,1(a0) // S1 = Vertex Y0
  lbu s2,2(a0) // S2 = Vertex X1
  lbu s3,3(a0) // S3 = Vertex Y1
  lbu s4,4(a0) // S4 = Vertex X2
  lbu s5,5(a0) // S5 = Vertex Y2

  jal PlotFillTriangle // Plot Fill Triangle
  nop // Delay Slot


  lbu s0,0(a0) // S0 = Vertex X0
  lbu s1,1(a0) // S1 = Vertex Y0
  lbu s2,4(a0) // S2 = Vertex X1
  lbu s3,5(a0) // S3 = Vertex Y1
  lbu s4,6(a0) // S4 = Vertex X2
  lbu s5,7(a0) // S5 = Vertex Y2
  addiu a0,8   // Increment Scene Data Address

  jal PlotFillTriangle // Plot Fill Triangle
  nop // Delay Slot

  j FrameNonIndexed // Frame Non-Index Loop
  nop // Delay Slot

NonIndexPoly5: // Non-Indexed Polygon (5 Vertices)
  srl t0,4    // T0 >>= 4 (Polygon Palette Color Index)
  sll t0,2    // T0 <<= 2
  add t0,a1   // T0 += Palette Color Data Address
  lw t0,0(t0) // T0 = Palette Color

  la a3,$A0000000|(PolyRDPBuffer&$3FFFFFF) // A3 = RDP Buffer Address
  sw t0,4(a3) // Store Polygon Palette Color

  lbu s0,0(a0) // S0 = Vertex X0
  lbu s1,1(a0) // S1 = Vertex Y0
  lbu s2,2(a0) // S2 = Vertex X1
  lbu s3,3(a0) // S3 = Vertex Y1
  lbu s4,4(a0) // S4 = Vertex X2
  lbu s5,5(a0) // S5 = Vertex Y2

  jal PlotFillTriangle // Plot Fill Triangle
  nop // Delay Slot


  lbu s0,0(a0) // S0 = Vertex X0
  lbu s1,1(a0) // S1 = Vertex Y0
  lbu s2,4(a0) // S2 = Vertex X1
  lbu s3,5(a0) // S3 = Vertex Y1
  lbu s4,6(a0) // S4 = Vertex X2
  lbu s5,7(a0) // S5 = Vertex Y2

  jal PlotFillTriangle // Plot Fill Triangle
  nop // Delay Slot


  lbu s0,0(a0) // S0 = Vertex X0
  lbu s1,1(a0) // S1 = Vertex Y0
  lbu s2,6(a0) // S2 = Vertex X1
  lbu s3,7(a0) // S3 = Vertex Y1
  lbu s4,8(a0) // S4 = Vertex X2
  lbu s5,9(a0) // S5 = Vertex Y2
  addiu a0,10  // Increment Scene Data Address

  jal PlotFillTriangle // Plot Fill Triangle
  nop // Delay Slot

  j FrameNonIndexed // Frame Non-Index Loop
  nop // Delay Slot

NonIndexPoly6: // Non-Indexed Polygon (6 Vertices)
  srl t0,4    // T0 >>= 4 (Polygon Palette Color Index)
  sll t0,2    // T0 <<= 2
  add t0,a1   // T0 += Palette Color Data Address
  lw t0,0(t0) // T0 = Palette Color

  la a3,$A0000000|(PolyRDPBuffer&$3FFFFFF) // A3 = RDP Buffer Address
  sw t0,4(a3) // Store Polygon Palette Color

  lbu s0,0(a0) // S0 = Vertex X0
  lbu s1,1(a0) // S1 = Vertex Y0
  lbu s2,2(a0) // S2 = Vertex X1
  lbu s3,3(a0) // S3 = Vertex Y1
  lbu s4,4(a0) // S4 = Vertex X2
  lbu s5,5(a0) // S5 = Vertex Y2

  jal PlotFillTriangle // Plot Fill Triangle
  nop // Delay Slot


  lbu s0,0(a0) // S0 = Vertex X0
  lbu s1,1(a0) // S1 = Vertex Y0
  lbu s2,4(a0) // S2 = Vertex X1
  lbu s3,5(a0) // S3 = Vertex Y1
  lbu s4,6(a0) // S4 = Vertex X2
  lbu s5,7(a0) // S5 = Vertex Y2

  jal PlotFillTriangle // Plot Fill Triangle
  nop // Delay Slot


  lbu s0,0(a0) // S0 = Vertex X0
  lbu s1,1(a0) // S1 = Vertex Y0
  lbu s2,6(a0) // S2 = Vertex X1
  lbu s3,7(a0) // S3 = Vertex Y1
  lbu s4,8(a0) // S4 = Vertex X2
  lbu s5,9(a0) // S5 = Vertex Y2

  jal PlotFillTriangle // Plot Fill Triangle
  nop // Delay Slot


  lbu s0,0(a0)  // S0 = Vertex X0
  lbu s1,1(a0)  // S1 = Vertex Y0
  lbu s2,8(a0)  // S2 = Vertex X1
  lbu s3,9(a0)  // S3 = Vertex Y1
  lbu s4,10(a0) // S4 = Vertex X2
  lbu s5,11(a0) // S5 = Vertex Y2
  addiu a0,12   // Increment Scene Data Address

  jal PlotFillTriangle // Plot Fill Triangle
  nop // Delay Slot

  j FrameNonIndexed // Frame Non-Index Loop
  nop // Delay Slot

NonIndexPoly7: // Non-Indexed Polygon (7 Vertices)
  srl t0,4    // T0 >>= 4 (Polygon Palette Color Index)
  sll t0,2    // T0 <<= 2
  add t0,a1   // T0 += Palette Color Data Address
  lw t0,0(t0) // T0 = Palette Color

  la a3,$A0000000|(PolyRDPBuffer&$3FFFFFF) // A3 = RDP Buffer Address
  sw t0,4(a3) // Store Polygon Palette Color

  lbu s0,0(a0) // S0 = Vertex X0
  lbu s1,1(a0) // S1 = Vertex Y0
  lbu s2,2(a0) // S2 = Vertex X1
  lbu s3,3(a0) // S3 = Vertex Y1
  lbu s4,4(a0) // S4 = Vertex X2
  lbu s5,5(a0) // S5 = Vertex Y2

  jal PlotFillTriangle // Plot Fill Triangle
  nop // Delay Slot


  lbu s0,0(a0) // S0 = Vertex X0
  lbu s1,1(a0) // S1 = Vertex Y0
  lbu s2,4(a0) // S2 = Vertex X1
  lbu s3,5(a0) // S3 = Vertex Y1
  lbu s4,6(a0) // S4 = Vertex X2
  lbu s5,7(a0) // S5 = Vertex Y2

  jal PlotFillTriangle // Plot Fill Triangle
  nop // Delay Slot


  lbu s0,0(a0) // S0 = Vertex X0
  lbu s1,1(a0) // S1 = Vertex Y0
  lbu s2,6(a0) // S2 = Vertex X1
  lbu s3,7(a0) // S3 = Vertex Y1
  lbu s4,8(a0) // S4 = Vertex X2
  lbu s5,9(a0) // S5 = Vertex Y2

  jal PlotFillTriangle // Plot Fill Triangle
  nop // Delay Slot


  lbu s0,0(a0)  // S0 = Vertex X0
  lbu s1,1(a0)  // S1 = Vertex Y0
  lbu s2,8(a0)  // S2 = Vertex X1
  lbu s3,9(a0)  // S3 = Vertex Y1
  lbu s4,10(a0) // S4 = Vertex X2
  lbu s5,11(a0) // S5 = Vertex Y2

  jal PlotFillTriangle // Plot Fill Triangle
  nop // Delay Slot


  lbu s0,0(a0)  // S0 = Vertex X0
  lbu s1,1(a0)  // S1 = Vertex Y0
  lbu s2,10(a0) // S2 = Vertex X1
  lbu s3,11(a0) // S3 = Vertex Y1
  lbu s4,12(a0) // S4 = Vertex X2
  lbu s5,13(a0) // S5 = Vertex Y2
  addiu a0,14   // Increment Scene Data Address

  jal PlotFillTriangle // Plot Fill Triangle
  nop // Delay Slot

  j FrameNonIndexed // Frame Non-Index Loop
  nop // Delay Slot


EndOfFrame: // End Of Frame
  b LoopFrames
  nop // Delay Slot

EndOfFrameSkipBlock: // End Of Frame & Skip To Next 64KB Block
  lui t0,$FFFF // T0 = $FFFF0000
  and a0,t0    // Scene Data Address &= $FFFF0000
  lui t0,$0001 // T0 = $00010000
  addu a0,t0   // Scene Data Address += $00010000 (Next 64KB Block)

  b LoopFrames
  nop // Delay Slot

EndOfStream: // End Of Stream
  la a0,SceneData // A0 = Scene Data Start Address

  b LoopFrames
  nop // Delay Slot

PlotFillTriangle: // Plot Fill Triangle (S0=X0, S1=Y0, S2=X1, S3=Y1, S4=X2, S5=Y2)
  // Sort Vertices By Y Ascending To Find The Major, Mid & Low Edges
  ble s1,s3,YSort1 // IF( Y0 > Y1 ) T0 = X1, T1 = Y1, Y1 = Y0, Y0 = T1, X1 = X0, X0 = T0
  nop // Delay Slot
  or t0,s2,r0 // T0 = X1
  or t1,s3,r0 // T1 = Y1
  or s3,s1,r0 // Y1 = Y0
  or s1,t1,r0 // Y0 = T1
  or s2,s0,r0 // X1 = X0
  or s0,t0,r0 // X0 = T0
YSort1:
  ble s3,s5,YSort2 // IF( Y1 > Y2 ) T0 = X2, T1 = Y2, Y2 = Y1, Y1 = T1, X2 = X1, X1 = T0
  nop // Delay Slot
  or t0,s4,r0 // T0 = X2
  or t1,s5,r0 // T1 = Y2
  or s5,s3,r0 // Y2 = Y1
  or s3,t1,r0 // Y1 = T1
  or s4,s2,r0 // X2 = X1
  or s2,t0,r0 // X1 = T0
YSort2:
  ble s1,s3,YSort3 // IF( Y0 > Y1 ) T0 = X1, T1 = Y1, Y1 = Y0, Y0 = T1, X1 = X0, X0 = T0
  nop // Delay Slot
  or t0,s2,r0 // T0 = X1
  or t1,s3,r0 // T1 = Y1
  or s3,s1,r0 // Y1 = Y0
  or s1,t1,r0 // Y0 = T1
  or s2,s0,r0 // X1 = X0
  or s0,t0,r0 // X0 = T0
YSort3:

  // Determine Triangle Winding Left Major Flag
  sub t0,s4,s0 // T0 = HDX (X2 - X0)
  sub t1,s5,s1 // T1 = HDY (Y2 - Y0)
  sub t2,s2,s0 // T2 = MDX (X1 - X0)
  sub t3,s3,s1 // T3 = MDY (Y1 - Y0)
  mul t0,t3    // R = HDX * MDY - HDY * MDX
  mflo t0      // T0 = HDX * MDY
  mul t1,t2
  mflo t1      // T1 = HDY * MDX
  sub t0,t1    // T0 = R (HDX * MDY - HDY * MDX)
  bltz t0,LFT // LFT = R < 0 ? 1 : 0
  ori s6,r0,1  // S6 = 1 (LFT) (Delay Slot)
  ori s6,r0,0  // S6 = 0 (LFT)
LFT:

  // Convert X/Y Verts To 16.16 Fixed Point Format
  sll s0,16 // X0 <<= 16
  sll s1,16 // Y0 <<= 16
  sll s2,16 // X1 <<= 16
  sll s3,16 // Y1 <<= 16
  sll s4,16 // X2 <<= 16
  sll s5,16 // Y2 <<= 16

  // YH = Y0, YM = Y1, YL = Y2
  // XH = X0, XM = X0, XL = X1
  // Calculate Inverse Slopes
  beq s5,s1,Slope1 // DXHDY = ( Y2 == Y0 ) ? 0 : ( X2 - X0 ) / ( Y2 - Y0 )
  and t0,r0    // T0 = 0 (DXHDY) (Delay Slot)
  sub t3,s4,s0 // T3 = X2 - X0
  sub t4,s5,s1 // T4 = Y2 - Y0
  sra t4,16    // T4 >>= 16
  div t3,t4    // T3 / T4
  mflo t0      // T0 = DXHDY
Slope1:
  beq s3,s1,Slope2 // DXMDY = ( Y1 == Y0 ) ? 0 : ( X1 - X0 ) / ( Y1 - Y0 )
  and t1,r0    // T1 = 0 (DXMDY) (Delay Slot)
  sub t3,s2,s0 // T3 = X1 - X0
  sub t4,s3,s1 // T4 = Y1 - Y0
  sra t4,16    // T4 >>= 16
  div t3,t4    // T3 / T4
  mflo t1      // T1 = DXMDY
Slope2:
  beq s5,s3,Slope3 // DXLDY = ( Y2 == Y1 ) ? 0 : ( X2 - X1 ) / ( Y2 - Y1 )
  and t2,r0    // T2 = 0 (DXLDY) (Delay Slot)
  sub t3,s4,s2 // T3 = X2 - X1
  sub t4,s5,s3 // T4 = Y2 - Y1
  sra t4,16    // T4 >>= 16
  div t3,t4    // T3 / T4
  mflo t2      // T2 = DXLDY
Slope3:

  // Store RDP Triangle Results In 32-Bit Chunks
  la a3,$A0000000|(PolyRDPBuffer&$3FFFFFF) // A3 = RDP Buffer Address
  lui t3,$0800
  sll s6,23 // LFT
  or t3,s6
  sra s5,14 // YL (Y2)
  andi s5,$3FFF
  or t3,s5
  sw t3,8(a3) // Store RDP Word 0

  sra s3,14 // YM (Y1)
  andi s3,$3FFF
  sll t3,s3,16
  sra s1,14 // YH (Y0)
  andi s1,$3FFF
  or t3,s1
  sw t3,12(a3) // Store RDP Word 1

  sw s2,16(a3) // Store RDP Word 2 (XL/X1)
  sw t2,20(a3) // Store RDP Word 3 (DXLDY)
  sw s0,24(a3) // Store RDP Word 4 (XH/X0)
  sw t0,28(a3) // Store RDP Word 5 (DXHDY)
  sw s0,32(a3) // Store RDP Word 6 (XM/X0)
  sw t1,36(a3) // Store RDP Word 7 (DXMDY)

  lui t0,DPC_BASE        // T0 = Reality Display Processer Control Interface Base Register ($A4100000)
  la t1,PolyRDPBuffer    // T1 = DPC Command Start Address
  sw t1,DPC_START(t0)    // Store DPC Command Start Address To DP Start Register ($A4100000)
  la t1,PolyRDPBufferEnd // T1 = DPC Command End Address
  sw t1,DPC_END(t0)      // Store DPC Command End Address To DP End Register ($A4100004)

  // Wait For RDP To Finish
  li t2,$00FFFFFF // T2 = $00FFFFFF
  and t1,t2       // T1 = 24-Bit RDP Buffer End Address
  RDPLoop:
    lw t2,DPC_CURRENT(t0) // T2 = CMD DMA Current ($04100008)
    bne t2,t1,RDPLoop // IF (T2 != T1) RDPLoop
    nop // Delay Slot

  jr ra // Return
  nop   // Delay Slot

arch n64.rdp
align(8) // Align 64-Bit
FrameClearScreenRDPBuffer: // Frame Clear Screen RDP Buffer
  Set_Scissor 0<<2,0<<2, 0,0, 320<<2,240<<2 // Set Scissor: XH 0.0,YH 0.0, Scissor Field Enable Off,Field Off, XL 320.0,YL 240.0
  Set_Other_Modes CYCLE_TYPE_FILL // Set Other Modes
DoubleBuffer:
  Set_Color_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,320-1, $00100000 // Set Color Image: FORMAT RGBA,SIZE 16B,WIDTH 320, DRAM ADDRESS $00100000
  Set_Fill_Color $00000000 // Set Fill Color: PACKED COLOR 16B R5G5B5A1 Pixels
  Fill_Rectangle 319<<2,239<<2, 0<<2,0<<2 // Fill Rectangle: XL 319.0,YL 239.0, XH 0.0,YH 0.0

  Set_Other_Modes SAMPLE_TYPE|BI_LERP_0|ALPHA_DITHER_SEL_NO_DITHER|B_M1A_0_2 // Set Other Modes
  Set_Combine_Mode $0,$00, 0,0, $6,$01, $0,$F, 1,0, 0,0,0, 7,7,7 // Set Combine Mode: SubA RGB0,MulRGB0, SubA Alpha0,MulAlpha0, SubA RGB1,MulRGB1, SubB RGB0,SubB RGB1, SubA Alpha1,MulAlpha1, AddRGB0,SubB Alpha0,AddAlpha0, AddRGB1,SubB Alpha1,AddAlpha1

  Sync_Pipe // Stall Pipeline, Until Preceeding Primitives Completely Finish
FrameClearScreenRDPBufferEnd:

align(8) // Align 64-Bit
PolyRDPBuffer: // Polygon RDP Buffer
  Set_Blend_Color $00000000 // Set Blend Color: R,G,B,A
  Fill_Triangle 0,0,0, 0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0
  Sync_Pipe // Stall Pipeline, Until Preceeding Primitives Completely Finish
PolyRDPBufferEnd:

align(4) // Align 32-Bit
Palette:
  dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 // Palette Color Data (16 Colors, RGBA8888, 64 Bytes)

align(65536) // Align 64KB Block
insert SceneData, "scene1.bin" // Scene Data (1800 Frames, 639976 Bytes)