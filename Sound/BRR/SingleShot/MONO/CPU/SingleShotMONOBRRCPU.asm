// N64 'Bare Metal' Sound Single Shot Mono BRR CPU Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "SingleShotMONOBRRCPU.N64", create
fill 1052672 // Set ROM Size

origin $00000000
base $80000000 // Entry Point Of Code
include "LIB\N64.INC" // Include N64 Definitions
include "LIB\N64_HEADER.ASM" // Include 64 Byte Header & Vector Table
insert "LIB\N64_BOOTCODE.BIN" // Include 4032 Byte Boot Code

Start:
  N64_INIT() // Run N64 Initialisation Routine

  // Decode BRR Sound Sample Using CPU
  la a0,Sample // A0 = Sample Address
  la a1,Sample+Sample.size // A1 = Sample End Address
  lui a2,$A010 // A2 = Decode Sample Address
  and t0,r0 // T0 = New Sample (Current Sample)
  and t1,r0 // T1 = Old Sample (Last Sample)
  and t2,r0 // T2 = Older Sample (Previous To Last Sample)
  BRRBlockDecode: // Decode 9 Byte Block, Byte 0 = Block Header
    lbu t3,0(a0) // T3 = BRR Block Header
    addiu a0,1 // Sample Address++
    srl t4,t3,4 // T4 = Shift Amount (Bits 4..7)
    srl t3,2
    andi t3,3 // T3 = Filter Number (Bits 2..3)

    lli t5,8 // T5 = Sample Counter
    BRRSampleDecode: // Next 8 Bytes Contain 2 Signed 4-Bit Sample Nibbles Each (-8..+7) (Sample 1 = Bits 4..7 & Sample 2 = Bits 0..3)
      lbu t6,0(a0)  // T6 = Sample Byte
      andi t7,t6,$F // T7 = Sample 2 Unsigned Nibble
      srl t6,4      // T6 = Sample 1 Unsigned Nibble

      lli t8,7 // T8 = 7
      ble t6,t8,Sample1Signed // IF (Sample 1 <= 7) Sample 1 Signed
      nop // Delay Slot
      subiu t6,16 // ELSE Sample 1 -= 16 (Convert Sample 1 To Signed Nibble)
      Sample1Signed:
      ble t7,t8,Sample2Signed // IF (Sample 2 <= 7) Sample 2 Signed
      nop // Delay Slot
      subiu t7,16 // ELSE Sample 2 -= 16 (Convert Sample 2 To Signed Nibble)
      Sample2Signed:

      // Shift Samples
      lli t8,12 // T8 = 12
      ble t4,t8,SampleShift // IF (Shift Amount <= 12) Apply Shift Amount To Samples
      nop // Delay Slot
      // ELSE Use Default Shift For Reserved Shift Amount (13..15)
      sll t6,12 // Sample 1 SHL 12
      sra t6,3 // Sample 1 SAR 3
      sll t7,12 // Sample 2 SHL 12
      sra t7,3 // Sample 2 SAR 3
      j ShiftEnd
      nop // Delay Slot
      SampleShift:
      sllv t6,t4 // Sample 1 SHL Shift Amount
      sra t6,1 // Sample 1 SAR 1
      sllv t7,t4 // Sample 2 SHL Shift Amount
      sra t7,1 // Sample 2 SAR 1
      ShiftEnd:

      // Filter Samples
      move t0,t6 // Filter 0: New Sample = Sample 1
      beqz t3,S1FilterEnd // IF (Filter Number == 0) GOTO Sample 1 Filter End
      nop // Delay Slot

      lli t8,1 // T8 = 1
      bne t3,t8,S1Filter2 // IF (Filter Number != 1) GOTO Sample 1 Filter 2
      nop // Delay Slot
      add t0,t1 // Filter 1: New Sample += Old Sample + (-Old Sample SAR 4)
      sra t8,t1,4 // T8 = Old Sample SAR 4
      sub t8,r0,t8 // T8 = -Old Sample SAR 4
      add t0,t8 // New Sample = Filter 1
      j S1FilterEnd
      nop // Delay Slot

      S1Filter2:
      lli t8,2 // T8 = 2
      bne t3,t8,S1Filter3 // IF (Filter Number != 2) GOTO Sample 1 Filter 3
      nop // Delay Slot
      sll t8,t1,1 // Filter 2: New Sample += (Old Sample SHL 1) + ((-Old Sample * 3) SAR 5) - Older Sample + (Older Sample SAR 4)
      add t0,t8 // New Sample += Old Sample SHL 1
      add t8,t1 // T8 = Old Sample * 3
      sub t8,r0,t8 // T8 = -Old Sample * 3
      sra t8,5 // T8 = (-Old Sample * 3) SAR 5
      add t0,t8 // New Sample += (-Old Sample * 3) SAR 5
      sub t0,t2 // New Sample -= Older Sample
      sra t8,t2,4 // T8 = Older Sample SAR 4
      add t0,t8 // New Sample = Filter 2
      j S1FilterEnd
      nop // Delay Slot

      S1Filter3:
      sll t8,t1,1 // Filter 3: New Sample += (Old Sample SHL 1) + ((-Old Sample * 13) SAR 6) - Older Sample + ((Older Sample * 3) SAR 4)
      add t0,t8 // New Sample += Old Sample SHL 1
      sub t8,r0,t1 // T8 = -Old Sample
      lli t9,13 // T9 = 13
      mult t8,t9
      mflo t8 // T8 = -Old Sample * 13
      sra t8,6 // T8 = (-Old Sample * 13) SAR 6
      add t0,t8 // New Sample += (-Old Sample * 13) SAR 6
      sub t0,t2 // New Sample -= Older Sample
      sll t8,t2,1
      add t8,t2 // T8 = Older Sample * 3
      sra t8,4 // T8 = (Older Sample * 3) SAR 4
      add t0,t8 // New Sample = Filter 3

      S1FilterEnd:
      move t2,t1 // Older Sample = Old Sample
      move t1,t0 // Old Sample = New Sample
      sh t0,0(a2) // Store Decoded Sample 1


      move t0,t7 // Filter 0: New Sample = Sample 2
      beqz t3,S2FilterEnd // IF (Filter Number == 0) GOTO Sample 2 Filter End
      nop // Delay Slot

      lli t8,1 // T8 = 1
      bne t3,t8,S2Filter2 // IF (Filter Number != 1) GOTO Sample 2 Filter 2
      nop // Delay Slot
      add t0,t1 // Filter 1: New Sample += Old Sample + (-Old Sample SAR 4)
      sra t8,t1,4 // T8 = Old Sample SAR 4
      sub t8,r0,t8 // T8 = -Old Sample SAR 4
      add t0,t8 // New Sample = Filter 1
      j S2FilterEnd
      nop // Delay Slot

      S2Filter2:
      lli t8,2 // T8 = 2
      bne t3,t8,S2Filter3 // IF (Filter Number != 2) GOTO Sample 2 Filter 3
      nop // Delay Slot
      sll t8,t1,1 // Filter 2: New Sample += (Old Sample SHL 1) + ((-Old Sample * 3) SAR 5) - Older Sample + (Older Sample SAR 4)
      add t0,t8 // New Sample += Old Sample SHL 1
      add t8,t1 // T8 = Old Sample * 3
      sub t8,r0,t8 // T8 = -Old Sample * 3
      sra t8,5 // T8 = (-Old Sample * 3) SAR 5
      add t0,t8 // New Sample += (-Old Sample * 3) SAR 5
      sub t0,t2 // New Sample -= Older Sample
      sra t8,t2,4 // T8 = Older Sample SAR 4
      add t0,t8 // New Sample = Filter 2
      j S2FilterEnd
      nop // Delay Slot

      S2Filter3:
      sll t8,t1,1 // Filter 3: New Sample += (Old Sample SHL 1) + ((-Old Sample * 13) SAR 6) - Older Sample + ((Older Sample * 3) SAR 4)
      add t0,t8 // New Sample += Old Sample SHL 1
      sub t8,r0,t1 // T8 = -Old Sample
      lli t9,13 // T9 = 13
      mult t8,t9
      mflo t8 // T8 = -Old Sample * 13
      sra t8,6 // T8 = (-Old Sample * 13) SAR 6
      add t0,t8 // New Sample += (-Old Sample * 13) SAR 6
      sub t0,t2 // New Sample -= Older Sample
      sll t8,t2,1
      add t8,t2 // T8 = Older Sample * 3
      sra t8,4 // T8 = (Older Sample * 3) SAR 4
      add t0,t8 // New Sample = Filter 3

      S2FilterEnd:
      move t2,t1 // Older Sample = Old Sample
      move t1,t0 // Old Sample = New Sample
      sh t0,2(a2) // Store Decoded Sample 1

      addiu a2,4 // Decode Sample Address += 4
      subiu t5,1 // Sample Counter--
      bnez t5,BRRSampleDecode // IF (Sample Counter != 0) Decode Samples
      addiu a0,1 // Sample Address++ (Delay Slot)

    bne a0,a1,BRRBlockDecode // IF (Sample Address != Sample End Address) A-Law Decode
    nop // Delay Slot

  lui a0,AI_BASE // A0 = AI Base Register ($A4500000)
  lli t0,1 // T0 = AI Control DMA Enable Bit (1)
  sw t0,AI_CONTROL(a0) // Store AI Control DMA Enable Bit To AI Control Register ($A4500008)

  lui t0,$A010 // T0 = Sample DRAM Offset
  sw t0,AI_DRAM_ADDR(a0) // Store Sample DRAM Offset To AI DRAM Address Register ($A4500000)
  lli t0,15 // T0 = Sample Bit Rate (Bitrate-1)
  sw t0,AI_BITRATE(a0) // Store Sample Bit Rate To AI Bit Rate Register ($A4500014)

  li t0,(VI_NTSC_CLOCK/(31000/2))-1 // T0 = Sample Frequency: (VI_NTSC_CLOCK(48681812) / FREQ(31000 / 2)) - 1
  sw t0,AI_DACRATE(a0) // Store Sample Frequency To AI DAC Rate Register ($A4500010)
  li t0,25120 // T0 = Length Of Sample Buffer
  sw t0,AI_LEN(a0) // Store Length Of Sample Buffer To AI Length Register ($A4500004)

Loop:
  j Loop
  nop // Delay Slot

insert Sample, "Sample.brr" // 16-Bit 31000Hz Mono BRR Sound Sample