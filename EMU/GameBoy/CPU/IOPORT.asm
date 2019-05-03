// Copy Cart Over BIOS Area When DMG Is Complete (Overwrite 256 Bytes Bios Area)
ori t0,r0,$100
bne t0,s4,NO_DMG // IF (PC_REG == $100) DMG Complete
or a2,r0,a0
la a3,GB_CART
addiu t0,a2,$100
DMG_Copy:
  lw t1,0(a3)
  sw t1,0(a2)
  addiu a2,4
  bne a2,t0,DMG_Copy
  addiu a3,4 // Delay Slot
NO_DMG:

// Instruction Cycles
bge v0,k0,ICZ // IF (QCycles < OldQCycles) OldQCycles = 0
nop           // Delay Slot
and k0,r0     // OldQCycles = 0
ICZ:
subu t0,v0,k0 // T0 = InstQCycles = QCycles - OldQCycles (Get Last Instruction Quad Cycle Count)
or k0,r0,v0   // OldQCycles = QCycles

//-----
// LCD
//-----
la a2,MEM_MAP+LCDC_REG // A2 = MEM_MAP + LCDC_REG
lbu t1,0(a2)   // T1 = LCDC_REG
andi t1,$80    // IF ((LCDC_REG>>7) & 1)
beqz t1,NO_LCD // ELSE NO LCD
nop // Delay Slot

addu s5,t0           // LCDQCycles += InstQCycles
la a2,MEM_MAP+LY_REG // A2 = MEM_MAP + LY_REG
lbu t1,0(a2)         // T1 = LY_REG
ori t2,r0,114        // T2 = 114
blt s5,t2,VBLANK     // IF (LCDQCycles >= 114) LCDQCycles = 0, LY_REG++ (Scanline Takes 456 Cycles (114 QCycles)) 
nop                  // Delay Slot
and s5,r0            // LCDQCycles = 0
addiu t1,1           // LY_REG++
sb t1,0(a2)          // Store LY_REG

VBLANK:
ori t2,r0,144
bne t1,t2,NO_VBLANK  // IF (LY_REG == 144) IF_REG |= 1 (VBlank Interrupt Flag Set When LY_REG Reaches 144)
nop // Delay Slot
la a2,MEM_MAP+IF_REG // A2 = MEM_MAP + IF_REG
lbu t1,0(a2)         // T1 = IF_REG
ori t1,1             // IF_REG |= 1
sb t1,0(a2)
b END_LY
nop // Delay Slot

NO_VBLANK:
ori t2,r0,153
ble t1,t2,END_LY // ELSE IF (LY_REG > 153) LY_REG = 0 (Reset LY_REG When Above 153)
nop // Delay Slot
sb r0,0(a2)

END_LY:


la a2,MEM_MAP+STAT_REG // A2 = MEM_MAP + STAT_REG
lbu t1,0(a2) // T1 = STAT_REG
andi s7,t1,3 // S7 = OldMode

// LCD MODE 1
la a2,MEM_MAP+LY_REG // A2 = MEM_MAP + LY_REG
lbu t2,0(a2)  // T2 = LY_REG
ori t3,r0,144 // T3 = 144
blt t2,t3,LCD_MODE_2 // IF (LY_REG >= 144) (Mode 1)
nop // Delay Slot
ori t1,1   // STAT_REG |= 1 (Set Status Bit 0)
andi t1,~2 // STAT_REG &= $FD (Reset Status Bit 1)
la a2,MEM_MAP+STAT_REG // A2 = MEM_MAP + STAT_REG
sb t1,0(a2) // STAT_REG = T1
andi t1,$10 // IF ((STAT_REG & $10) && (OldMode != 1)) IF_REG |= 2 (IF Status Bit 4 & OldMode != 1 LCD STAT Interrupt Flag Set) 
beqz t1,END_STAT
nop // Delay Slot
ori t3,r0,1 // T3 = 1
beq s7,t3,END_STAT // IF (OldMode == 1) END STAT
nop // Delay Slot
la a2,MEM_MAP+IF_REG // A2 = MEM_MAP + IF_REG
lbu t1,0(a2) // T1 = IF_REG
ori t1,2
sb t1,0(a2)
b END_STAT
nop // Delay Slot

LCD_MODE_2:
ori t3,r0,20 // T3 = 20
bgt s5,t3,LCD_MODE_3 // IF (LCDQCycles <= 20) (Mode 2)
nop // Delay Slot
ori t1,2 // STAT_REG |= 2 (Set Status Bit 1)
andi t1,~1 // STAT_REG &= $FE (Reset Status Bit 0)
la a2,MEM_MAP+STAT_REG // A2 = MEM_MAP + STAT_REG
sb t1,0(a2) // STAT_REG = T1
andi t1,$20 // IF ((STAT_REG & $20) && (OldMode != 2)) IF_REG |= 2 (IF Status Bit 5 & OldMode != 2 LCD STAT Interrupt Flag Set)
beqz t1,END_STAT
nop // Delay Slot
ori t3,r0,2 // T3 = 2
beq s7,t3,END_STAT // IF (OldMode == 2) END STAT
nop // Delay Slot
la a2,MEM_MAP+IF_REG // A2 = MEM_MAP + IF_REG
lbu t1,0(a2) // T1 = IF_REG
ori t1,2
sb t1,0(a2)
b END_STAT
nop // Delay Slot

LCD_MODE_3:
ori t3,r0,63 // T3 = 63
bgt s5,t3,LCD_MODE_0 // ELSE IF (LCDQCycles <= 63) (Mode 3)
nop // Delay Slot
ori t1,3 // STAT_REG |= 3 (Set Status Bits 0 & 1)
la a2,MEM_MAP+STAT_REG // A2 = MEM_MAP + STAT_REG
sb t1,0(a2) // STAT_REG = T1
b END_STAT
nop // Delay Slot

LCD_MODE_0: // ELSE (Mode 0)
andi t1,~3 // STAT_REG &= $FC (Reset Status Bits 0 & 1)
la a2,MEM_MAP+STAT_REG // A2 = MEM_MAP + STAT_REG
sb t1,0(a2) // STAT_REG = T1
andi t1,8 // IF ((STAT_REG & 8) && (OldMode != 0)) IF_REG |= 2 (IF Status Bit 3 & OldMode != 0 LCD STAT Interrupt Flag Set) 
beqz t1,END_STAT
nop // Delay Slot
beqz s7,END_STAT // IF (OldMode == 0) END STAT
nop // Delay Slot
la a2,MEM_MAP+IF_REG // A2 = MEM_MAP + IF_REG
lbu t1,0(a2) // T1 = IF_REG
ori t1,2
sb t1,0(a2)

END_STAT:
la a2,MEM_MAP+LY_REG // A2 = MEM_MAP + LY_REG
lbu t1,0(a2) // T1 = LY_REG
la a2,MEM_MAP+LYC_REG // A2 = MEM_MAP + LYC_REG
lbu t2,0(a2) // T2 = LYC_REG
bne t1,t2,NO_LYCMP // IF (LY_REG == LYC_REG) (Check The Coincidence Flag)
nop // Delay Slot
la a2,MEM_MAP+STAT_REG // A2 = MEM_MAP + STAT_REG
lbu t1,0(a2) // T1 = STAT_REG
ori t1,4 // STAT_REG |= 4 (Set Status Bit 2)
sb t1,0(a2)
andi t1,$40 // IF (STAT_REG & $40) IF_REG |= 2 (IF Status Bit 6 LCD STAT Interrupt Flag Set) 
beqz t1,TIMERS
nop // Delay Slot
la a2,MEM_MAP+IF_REG // A2 = MEM_MAP + IF_REG
lbu t1,0(a2) // T1 = IF_REG
ori t1,2
sb t1,0(a2)
b TIMERS
nop // Delay Slot

NO_LYCMP: // ELSE
la a2,MEM_MAP+STAT_REG // A2 = MEM_MAP + STAT_REG
lbu t1,0(a2) // T1 = STAT_REG
andi t1,~4 // STAT_REG &= $FB (Reset Status Bit 2)
sb t1,0(a2)
b TIMERS
nop // Delay Slot

NO_LCD: // ELSE
and s5,r0 // LCDQCycles = 0, LY_REG = 0 (Set The Mode To 1 During LCD Disabled & Reset Scanline)
la a2,MEM_MAP+LY_REG // A2 = MEM_MAP + LY_REG
sb r0,0(a2) // T1 = LY_REG
la a2,MEM_MAP+STAT_REG // A2 = MEM_MAP + STAT_REG
lbu t1,0(a2) // T1 = STAT_REG
ori t1,1 // STAT_REG |= 1 (Set Status Bit 0)
andi t1,~2 // STAT_REG &= 0xFD (Reset Status Bit 1)
sb t1,0(a2)

//--------
// Timers
//--------
TIMERS:
addu s6,t0 // DIVQCycles += InstQCycles
ori t1,r0,256
blt s6,t0,NO_DIV // IF (DIVQCycles >= 256)
nop // Delay Slot
and s6,r0 // DIVQCycles = 0
la a2,MEM_MAP+DIV_REG // A2 = MEM_MAP + DIV_REG
lbu t1,0(a2) // T1 = DIV_REG
addiu t1,1 // DIV_REG++
sb t1,0(a2)

NO_DIV:
la a2,MEM_MAP+TAC_REG // A2 = MEM_MAP + TAC_REG
lbu t1,0(a2) // T1 = TAC_REG
andi t2,t1,4 // T2 = TAC_REG & 4
beqz t2,NO_TMR // IF (TAC_REG & 4)
nop // Delay Slot
beq t1,s8,NO_TAC // IF (TAC_REG != OldTAC_REG)
nop // Delay Slot
or s8,r0,t1 // OldTAC_REG = TAC_REG
ori t8,r0,4 // TimerQCycles = 4

NO_TAC:

TMR_4096:
  ori t2,r0,4 // T2 = 4
  bne t1,t2,TMR_262144 // IF (TAC_REG == 4) (Timer Clock Frequency = 4096 Hz)
  nop // Delay Slot
  addu t8,t0 // TimerQCycles += InstQCycles
  la a2,MEM_MAP+TIMA_REG // A2 = MEM_MAP + TIMA_REG
  lbu t0,0(a2) // T0 = TIMA_REG
  LOOP_4096:
    ori t2,r0,256 // T2 = 256
    blt t8,t2,TMR_END // WHILE (TimerQCycles >= 256)
    nop // Delay Slot
    subiu t8,256 // TimerQCycles -= 256
    addiu t0,1 // IF (++TIMA_REG == 0)
    ori t2,r0,$100 // T2 = $100
    bne t0,t2,LOOP_4096
    nop // Delay Slot
    la a2,MEM_MAP+TMA_REG // A2 = MEM_MAP + TMA_REG
    lbu t0,0(a2) // TIMA_REG = TMA_REG
    la a2,MEM_MAP+IF_REG // A2 = MEM_MAP + IF_REG
    lbu t2,0(a2) // T2 = IF_REG
    ori t2,4 // IF_REG |= 4 (Interrupt Is Requested By Setting Bit 2 In The IF Register)
    sb t2,0(a2)
    b LOOP_4096
    nop // Delay Slot

TMR_262144:
  ori t2,r0,5 // T2 = 5
  bne t1,t2,TMR_65536 // IF (TAC_REG == 5) (Timer Clock Frequency = 262144 Hz)
  nop // Delay Slot 
  addu t8,t0 // TimerQCycles += InstQCycles
  la a2,MEM_MAP+TIMA_REG // A2 = MEM_MAP + TIMA_REG
  lbu t0,0(a2) // T0 = TIMA_REG
  LOOP_262144:
    ori t2,r0,4 // T2 = 4
    blt t8,t2,TMR_END // WHILE (TimerQCycles >= 4)
    nop // Delay Slot
    subiu t8,4 // TimerQCycles -= 4
    addiu t0,1 // IF (++TIMA_REG == 0)
    ori t2,r0,$100 // T2 = $100
    bne t0,t2,LOOP_262144
    nop // Delay Slot
    la a2,MEM_MAP+TMA_REG // A2 = MEM_MAP + TMA_REG
    lbu t0,0(a2) // TIMA_REG = TMA_REG
    la a2,MEM_MAP+IF_REG // A2 = MEM_MAP + IF_REG
    lbu t2,0(a2) // T2 = IF_REG
    ori t2,4 // IF_REG |= 4 (Interrupt Is Requested By Setting Bit 2 In The IF Register)
    sb t2,0(a2)
    b LOOP_262144
    nop // Delay Slot

TMR_65536:
  ori t2,r0,6 // T2 = 6
  bne t1,t2,TMR_16384 // IF (TAC_REG == 6) (Timer Clock Frequency = 65536 Hz)
  nop // Delay Slot
  addu t8,t0 // TimerQCycles += InstQCycles
  la a2,MEM_MAP+TIMA_REG // A2 = MEM_MAP + TIMA_REG
  lbu t0,0(a2) // T0 = TIMA_REG
  LOOP_65536:
    ori t2,r0,16 // T2 = 16
    blt t8,t2,TMR_END // WHILE (TimerQCycles >= 16)
    nop // Delay Slot
    subiu t8,16 // TimerQCycles -= 16
    addiu t0,1 // IF (++TIMA_REG == 0)
    ori t2,r0,$100 // T2 = $100
    bne t0,t2,LOOP_65536
    nop // Delay Slot
    la a2,MEM_MAP+TMA_REG // A2 = MEM_MAP + TMA_REG
    lbu t0,0(a2) // TIMA_REG = TMA_REG
    la a2,MEM_MAP+IF_REG // A2 = MEM_MAP + IF_REG
    lbu t2,0(a2) // T2 = IF_REG
    ori t2,4 // IF_REG |= 4 (Interrupt Is Requested By Setting Bit 2 In The IF Register)
    sb t2,0(a2)
    b LOOP_65536
    nop // Delay Slot

TMR_16384:
  ori t2,r0,7 // T2 = 7
  bne t1,t2,NO_TMR // IF (TAC_REG == 7) (Timer Clock Frequency = 16384 Hz)
  nop // Delay Slot
  addu t8,t0 // TimerQCycles += InstQCycles
  la a2,MEM_MAP+TIMA_REG // A2 = MEM_MAP + TIMA_REG
  lbu t0,0(a2) // T0 = TIMA_REG
  LOOP_16384:
    ori t2,r0,64 // T2 = 64
    blt t8,t2,TMR_END // WHILE (TimerQCycles >= 64)
    nop // Delay Slot
    subiu t8,64 // TimerQCycles -= 64
    addiu t0,1 // IF (++TIMA_REG == 0)
    ori t2,r0,$100 // T2 = $100
    bne t0,t2,LOOP_16384
    nop // Delay Slot
    la a2,MEM_MAP+TMA_REG // A2 = MEM_MAP + TMA_REG
    lbu t0,0(a2) // TIMA_REG = TMA_REG
    la a2,MEM_MAP+IF_REG // A2 = MEM_MAP + IF_REG
    lbu t2,0(a2) // T2 = IF_REG
    ori t2,4 // IF_REG |= 4 (Interrupt Is Requested By Setting Bit 2 In The IF Register)
    sb t2,0(a2)
    b LOOP_16384
    nop // Delay Slot

TMR_END:
  la a2,MEM_MAP+TIMA_REG // A2 = MEM_MAP + TIMA_REG
  sb t0,0(a2) // TIMA_REG = T0
NO_TMR:


//------------
// Interrupts
//------------
beqz t9,NO_INTR // IF (IME_FLAG)
nop // Delay Slot
la a2,MEM_MAP+IF_REG // A2 = MEM_MAP + IF_REG
lbu t0,0(a2) // T0 = IF_REG
beqz t0,NO_INTR // IF (IF_REG)
nop // Delay Slot
and t0,r0 // i = 0 (T0 = i)
INTR_LOOP:
  ori t1,r0,5 // T1 = 5
  beq t0,t1,NO_INTR // WHILE (i != 5)
  nop // Delay Slot
  la a2,MEM_MAP+IF_REG // A2 = MEM_MAP + IF_REG
  lbu t1,0(a2) // T1 = IF_REG
  ori t2,r0,1
  sllv t2,t0
  and t1,t2
  beqz t1,INC_INTR // IF ((IF_REG & (1 << i)) && (IE_REG & (1 << i)) )
  nop // Delay Slot
  la a2,MEM_MAP+IE_REG // A2 = MEM_MAP + IE_REG
  lbu t1,0(a2) // T1 = IE_REG
  and t1,t2
  beqz t1,INC_INTR
  nop // Delay Slot

  and t9,r0 // IME_FLAG = 0 Disable Interrupt Master Enable Switch

  // SWITCH(i)
  bnez t0,INTR_1 // CASE 0: // Bit 0: V-Blank Interrupt Request (INT 40h)
  nop // Delay Slot
  la a2,MEM_MAP+IE_REG // A2 = MEM_MAP + IE_REG
  lbu t1,0(a2) // T1 = IE_REG
  andi t1,$FE // IE_REG &= $FE CALL $0040
  sb t1,0(a2)
  la a2,MEM_MAP+IF_REG // A2 = MEM_MAP + IF_REG
  lbu t1,0(a2) // T1 = IF_REG
  andi t1,$FE // IF_REG &= $FE
  sb t1,0(a2)
  subiu sp,2 // SP_REG -= 2
  addu a2,a0,sp // A2 = MEM_MAP + SP_REG
  sb s4,0(a2) // STACK = PC_REG
  srl t1,s4,8
  sb t1,1(a2)
  ori s4,r0,$40 // PC_REG = $0040
  b INC_INTR
  addiu v0,6 // QCycles += 6 (Delay Slot)

  INTR_1:
  ori t1,r0,1
  bne t0,t1,INTR_2 // CASE 1: // Bit 1: LCD STAT Interrupt Request (INT 48h)
  nop // Delay Slot
  la a2,MEM_MAP+IE_REG // A2 = MEM_MAP + IE_REG
  lbu t1,0(a2) // T1 = IE_REG
  andi t1,$FD // IE_REG &= $FD CALL $0048
  sb t1,0(a2)
  la a2,MEM_MAP+IF_REG // A2 = MEM_MAP + IF_REG
  lbu t1,0(a2) // T1 = IF_REG
  andi t1,$FD // IF_REG &= $FD
  sb t1,0(a2)
  subiu sp,2 // SP_REG -= 2
  addu a2,a0,sp // A2 = MEM_MAP + SP_REG
  sb s4,0(a2) // STACK = PC_REG
  srl t1,s4,8
  sb t1,1(a2)
  ori s4,r0,$48 // PC_REG = $0048
  b INC_INTR
  addiu v0,6 // QCycles += 6 (Delay Slot)

  INTR_2:
  ori t1,r0,2
  bne t0,t1,INTR_3 // CASE 2: // Bit 2: Timer Interrupt Request (INT 50h)
  nop // Delay Slot
  la a2,MEM_MAP+IE_REG // A2 = MEM_MAP + IE_REG
  lbu t1,0(a2) // T1 = IE_REG
  andi t1,$FB // IE_REG &= $FB CALL $0050
  sb t1,0(a2)
  la a2,MEM_MAP+IF_REG // A2 = MEM_MAP + IF_REG
  lbu t1,0(a2) // T1 = IF_REG
  andi t1,$FB // IF_REG &= $FB
  sb t1,0(a2)
  subiu sp,2 // SP_REG -= 2
  addu a2,a0,sp // A2 = MEM_MAP + SP_REG
  sb s4,0(a2) // STACK = PC_REG
  srl t1,s4,8
  sb t1,1(a2)
  ori s4,r0,$50 // PC_REG = $0050
  b INC_INTR
  addiu v0,6 // QCycles += 6 (Delay Slot)

  INTR_3:
  ori t1,r0,3
  bne t0,t1,INTR_4 // CASE 3: // Bit 3: Serial Interrupt Request (INT 58h)
  nop // Delay Slot
  la a2,MEM_MAP+IE_REG // A2 = MEM_MAP + IE_REG
  lbu t1,0(a2) // T1 = IE_REG
  andi t1,$F7 // IE_REG &= $F7 CALL $0058
  sb t1,0(a2)
  la a2,MEM_MAP+IF_REG // A2 = MEM_MAP + IF_REG
  lbu t1,0(a2) // T1 = IF_REG
  andi t1,$F7 // IF_REG &= $F7
  sb t1,0(a2)
  subiu sp,2 // SP_REG -= 2
  addu a2,a0,sp // A2 = MEM_MAP + SP_REG
  sb s4,0(a2) // STACK = PC_REG
  srl t1,s4,8
  sb t1,1(a2)
  ori s4,r0,$58 // PC_REG = $0058
  b INC_INTR
  addiu v0,6 // QCycles += 6 (Delay Slot)

  INTR_4:
  ori t1,r0,4
  bne t0,t1,INC_INTR // CASE 4: // Bit 4: Joypad Interrupt Request (INT 60h)
  nop // Delay Slot
  la a2,MEM_MAP+IE_REG // A2 = MEM_MAP + IE_REG
  lbu t1,0(a2) // T1 = IE_REG
  andi t1,$EF // IE_REG &= $EF CALL $0060
  sb t1,0(a2)
  la a2,MEM_MAP+IF_REG // A2 = MEM_MAP + IF_REG
  lbu t1,0(a2) // T1 = IF_REG
  andi t1,$EF // IF_REG &= $EF
  sb t1,0(a2)
  subiu sp,2 // SP_REG -= 2
  addu a2,a0,sp // A2 = MEM_MAP + SP_REG
  sb s4,0(a2) // STACK = PC_REG
  srl t1,s4,8
  sb t1,1(a2)
  ori s4,r0,$60 // PC_REG = $0060
  addiu v0,6 // QCycles += 6

  INC_INTR:
    b INTR_LOOP
    addiu t0,1 // i++ Check Each Interrupt In Priority Order (Delay Slot)

NO_INTR:


//-----
// DMA
//-----
la a2,MEM_MAP+DMA_REG // A2 = MEM_MAP + DMA_REG
lbu t0,0(a2) // T0 = DMA_REG
beqz t0,NO_DMA // IF (DMA_REG) (DMA Transfer Enabled)
nop // Delay Slot
sll t1,t0,8 // DMASRCADDR = DMA_REG << 8
and t0,r0 // int i = 0 (T0 = i)
sb r0,0(a2) // DMA_REG = 0
addu a2,a0,t1 // A2 = MEM_MAP + DMASRCADDR
la a3,MEM_MAP+OAM_RAM // A3 = MEM_MAP + OAM_RAM
DMA_LOOP:
  lbu t1,0(a2) // WHILE (i < 0xA0) (Loads 160 Bytes Of Cartridge To Memory Map)
  addiu a2,1
  sb t1,0(a3) // MEM_MAP[0xFE00 + i] = MEM_MAP[DMASRCADDR + i]
  addiu a3,1
  ori t1,r0,$A0
  bne t0,t1,DMA_LOOP
  addiu t0,1 // i++ (Delay Slot)
  
NO_DMA:

// Joypad
la a2,MEM_MAP+P1_REG // A2 = MEM_MAP + P1_REG
ori t0,r0,$F
sb t0,0(a2) // Reset Joypad (P1_REG = $F)