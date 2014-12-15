; N64 'Bare Metal' LZ77 GFX Demo by krom (Peter Lemon):
  include LIB\N64.INC ; Include N64 Definitions
  dcb 1052672,$00 ; Set ROM Size
  org $80000000 ; Entry Point Of Code
  include LIB\N64_HEADER.ASM  ; Include 64 Byte Header & Vector Table
  incbin LIB\N64_BOOTCODE.BIN ; Include 4032 Byte Boot Code

Start:
  include LIB\N64_GFX.INC ; Include Graphics Macros
  N64_INIT ; Run N64 Initialisation Routine

  ScreenNTSC 640, 480, BPP32|INTERLACE|AA_MODE_2, $A0100000 ; Screen NTSC: 640x480, 32BPP, DRAM Origin $A0100000

  la a0,LZ ; A0 = Source Address
  lui a1,$A010 ; A1 = Destination Address (DRAM Start Offset)

  lbu t0,3(a0) ; T0 = HI Data Length Byte
  sll t0,8
  lbu t1,2(a0) ; T1 = MID Data Length Byte
  or t0,t1
  sll t0,8
  lbu t1,1(a0) ; T1 = LO Data Length Byte
  or t0,t1 ; T0 = Data Length
  add t0,a1 ; T0 = Destination End Offset (DRAM End Offset)
  addi a0,4 ; Add 4 To LZ Offset

LZLoop:
  lbu t1,0(a0) ; T1 = Flag Data For Next 8 Blocks (0 = Uncompressed Byte, 1 = Compressed Bytes)
  addi a0,1 ; Add 1 To LZ Offset
  li t2,%10000000 ; T2 = Flag Data Block Type Shifter
  LZBlockLoop:
    beq a1,t0,LZEnd ; IF (Destination Address == Destination End Offset) LZEnd
    nop ; Delay Slot
    beqz t2,LZLoop ; IF (Flag Data Block Type Shifter == 0) LZLoop
    nop ; Delay Slot
    and t3,t1,t2 ; Test Block Type
    srl t2,1 ; Shift T2 To Next Flag Data Block Type
    bnez t3,LZDecode ; IF (BlockType != 0) LZDecode Bytes
    nop ; Delay Slot
    lbu t3,0(a0) ; ELSE Copy Uncompressed Byte
    addi a0,1 ; Add 1 To LZ Offset
    sb t3,0(a1) ; Store Uncompressed Byte To Destination
    addi a1,1 ; Add 1 To DRAM Offset
    j LZBlockLoop
    nop ; Delay Slot

    LZDecode:
      lbu t3,0(a0) ; T3 = Number Of Bytes To Copy & Disp MSB's
      addi a0,1 ; Add 1 To LZ Offset
      lbu t4,0(a0) ; T4 = Disp LSB's
      addi a0,1 ; Add 1 To LZ Offset
      sll t5,t3,8 ; T5 = Disp MSB's
      or t4,t5
      andi t4,$FFF ; T4 = Disp
      addi t4,1    ; T4 = Disp + 1
      sub t4,a1,t4 ; T4 = Destination - Disp - 1
      srl t3,4  ; T3 = Number Of Bytes To Copy (Minus 3)
      addi t3,3 ; T3 = Number Of Bytes To Copy
      LZCopy:
        lbu t5,0(t4) ; T5 = Byte To Copy
        addi t4,1 ; Add 1 To T4 Offset
        sb t5,0(a1) ; Store Byte To DRAM
        addi a1,1 ; Add 1 To DRAM Offset
        subi t3,1 ; Number Of Bytes To Copy -= 1
        bnez t3,LZCopy ; IF (Number Of Bytes To Copy != 0) LZCopy Bytes
        nop ; Delay Slot
        j LZBlockLoop
        nop ; Delay Slot
  LZEnd:

Loop:
  WaitScanline $1E0 ; Wait For Scanline To Reach Vertical Blank
  WaitScanline $1E2

  li t0,$00000800 ; Even Field
  sw t0,VI_Y_SCALE(a0)

  WaitScanline $1E0 ; Wait For Scanline To Reach Vertical Blank
  WaitScanline $1E2

  li t0,$02000800 ; Odd Field
  sw t0,VI_Y_SCALE(a0)

  j Loop
  nop

LZ:
  incbin Image.lz