STORE4200:
  // $4200 REG_NMITIMEN          Interrupt Enable & Joypad Request                    1B/W
  lbu t0,REG_NMITIMEN(a0) // T0 = MEM_MAP[REG_NMITIMEN]
  sb r0,REG_NMITIMEN(a0)  // MEM_MAP[REG_NMITIMEN] = 0
  la t1,NMITIMEN          // T1 = NMITIMEN
  jr k1
  sb t0,0(t1)             // NMITIMEN = T0 (Delay Slot)

STORE4201:
  // $4201 REG_WRIO              Joypad Programmable I/O Port (Open-Collector Output) 1B/W
  jr k1
  nop                    // Delay Slot

STORE4202:
  // $4202 REG_WRMPYA            Set Unsigned  8bit Multiplicand                      1B/W
  jr k1
  nop                    // Delay Slot

STORE4203:
  // $4203 REG_WRMPYB            Set Unsigned  8bit Multiplier & Start Multiplication 1B/W
  jr k1
  nop                    // Delay Slot

STORE4204:
  // $4204 REG_WRDIVL            Set Unsigned 16bit Dividend (Lower 8bit)             2B/W
  jr k1
  nop                    // Delay Slot

STORE4205:
  // $4205 REG_WRDIVH            Set Unsigned 16bit Dividend (Upper 8bit)             1B/W
  jr k1
  nop                    // Delay Slot

STORE4206:
  // $4206 REG_WRDIVB            Set Unsigned  8bit Divisor & Start Division          1B/W
  jr k1
  nop                    // Delay Slot

STORE4207:
  // $4207 REG_HTIMEL            H-Count Timer Setting (Lower 8bits)                  2B/W
  jr k1
  nop                    // Delay Slot

STORE4208:
  // $4208 REG_HTIMEH            H-Count Timer Setting (Upper 1bit)                   1B/W
  jr k1
  nop                    // Delay Slot

STORE4209:
  // $4209 REG_VTIMEL            V-Count Timer Setting (Lower 8bits)                  2B/W
  jr k1
  nop                    // Delay Slot

STORE420A:
  // $420A REG_VTIMEH            V-Count Timer Setting (Upper 1bit)                   1B/W
  jr k1
  nop                    // Delay Slot

STORE420B:
  // $420B REG_MDMAEN            Select General Purpose DMA Channels & Start Transfer 1B/W
  lbu t0,REG_MDMAEN(a0)   // T0 = MEM_MAP[REG_MDMAEN]
  beqz t0,MDMAENEND       // IF (REG_MDMAEN == 0) MDMAEN END
  ori t9,r0,0             // T9 = 0 (DMA Channel Count) (Delay Slot)

  MDMAENLOOP:
    ori t0,r0,1           // T0 = 1
    sllv t0,t9            // T0 <<= DMA Channel Count
    lbu t1,REG_MDMAEN(a0) // T1 = MEM_MAP[REG_MDMAEN]
    and t0,t1             // T0 = DMA0..7 Enable
    beqz t0,MDMAENCHECK   // IF (T0 == 0) MDMAEN CHECK
    sll t0,t9,4           // T0 = DMA Channel Count << 4 (Channel * 16) (Delay Slot)

    addiu t1,a0,REG_DMAP0 // T1 = MEM_MAP + REG_DMAP0
    addu t0,t1            // T0 += T1 (DMA Channel Base)

    lbu t8,1(t0)          // T8 = MEM_MAP[REG_BBADX] ($21XX)

    lbu at,2(t0)          // AT = MEM_MAP[REG_A1TXL]
    lbu t1,3(t0)          // T1 = MEM_MAP[REG_A1TXH]
    sll t1,8              // T1 <<= 8
    or at,t1              // AT = REG_A1TX

    // (DB:ADDR) - (DB * 32768) (LoROM)
    lbu t1,4(t0)          // T1 = MEM_MAP[REG_A1BX] (Bank)
    sll t2,t1,15          // T2 = DB * 32768
    sll t1,16             // T1 <<= 16
    or at,t1              // AT += Bank (DMA Start Address)
    subu at,t2
    addu at,a0            // AT += MEM_MAP

    lbu k0,5(t0)          // K0 = MEM_MAP[REG_DASXL]
    lbu t1,6(t0)          // T1 = MEM_MAP[REG_DASXH]
    sll t1,8              // T1 <<= 8
    or k0,t1              // K0 = REG_DASX (DMA Count)
    sb r0,5(t0)           // MEM_MAP[REG_DASXL] = 0
    sb r0,6(t0)           // MEM_MAP[REG_DASXH] = 0

    lbu t0,0(t0)          // T0 = MEM_MAP[REG_DMAPX] (DMA Parameters)
    sll t0,2              // T0 = DMAPX * 4 (Indirect Table Offset)
    la t1,DMAPXX          // T1 = DMAPXX Indirect Table
    addu t0,t1            // T0 = DMAPXX Indirect Table Offset
    lw t0,0(t0)           // T0 = DMAPXX Table Offset
    jr t0                 // Run DMAPXX 0..7 Instruction
    nop // Delay Slot

  MDMAENCHECK:
    ori t0,r0,7           // T0 = 7
    bne t9,t0,MDMAENLOOP  // IF (DMA Channel Count != 7) MDMAEN LOOP
    addiu t9,1            // DMA Channel Count++ (Delay Slot)

  MDMAENEND:
  jr k1
  sb r0,REG_MDMAEN(a0)   // MEM_MAP[REG_MDMAEN] = 0 (Delay Slot)

STORE420C:
  // $420C REG_HDMAEN            Select H-Blank DMA (H-DMA) Channels                  1B/W
  jr k1
  nop                    // Delay Slot

STORE420D:
  // $420D REG_MEMSEL            Memory-2 Waitstate Control                           1B/W
  jr k1
  nop                    // Delay Slot

STORE420E:
  // $420E                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE420F:
  // $420F                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4210:
  // $4210 REG_RDNMI             V-Blank NMI Flag and CPU Version Number (Read/Ack)   1B/R
  jr k1
  nop                    // Delay Slot

STORE4211:
  // $4211 REG_TIMEUP            H/V-Timer IRQ Flag (Read/Ack)                        1B/R
  jr k1
  nop                    // Delay Slot

STORE4212:
  // $4212 REG_HVBJOY            H/V-Blank Flag & Joypad Busy Flag                    1B/R
  jr k1
  nop                    // Delay Slot

STORE4213:
  // $4213 REG_RDIO              Joypad Programmable I/O Port (Input)                 1B/R
  jr k1
  nop                    // Delay Slot

STORE4214:
  // $4214 REG_RDDIVL            Unsigned Div Result (Quotient) (Lower 8bit)          2B/R
  jr k1
  nop                    // Delay Slot

STORE4215:
  // $4215 REG_RDDIVH            Unsigned Div Result (Quotient) (Upper 8bit)          1B/R
  jr k1
  nop                    // Delay Slot

STORE4216:
  // $4216 REG_RDMPYL            Unsigned Div Remainder / Mul Product (Lower 8bit)    2B/R
  jr k1
  nop                    // Delay Slot

STORE4217:
  // $4217 REG_RDMPYH            Unsigned Div Remainder / Mul Product (Upper 8bit)    1B/R
  jr k1
  nop                    // Delay Slot

STORE4218:
  // $4218 REG_JOY1L             Joypad 1 (Gameport 1, Pin 4) (Lower 8bit)            2B/R
  jr k1
  nop                    // Delay Slot

STORE4219:
  // $4219 REG_JOY1H             Joypad 1 (Gameport 1, Pin 4) (Upper 8bit)            1B/R
  jr k1
  nop                    // Delay Slot

STORE421A:
  // $421A REG_JOY2L             Joypad 2 (Gameport 2, Pin 4) (Lower 8bit)            2B/R
  jr k1
  nop                    // Delay Slot

STORE421B:
  // $421B REG_JOY2H             Joypad 2 (Gameport 2, Pin 4) (Upper 8bit)            1B/R
  jr k1
  nop                    // Delay Slot

STORE421C:
  // $421C REG_JOY3L             Joypad 3 (Gameport 1, Pin 5) (Lower 8bit)            2B/R
  jr k1
  nop                    // Delay Slot

STORE421D:
  // $421D REG_JOY3H             Joypad 3 (Gameport 1, Pin 5) (Upper 8bit)            1B/R
  jr k1
  nop                    // Delay Slot

STORE421E:
  // $421E REG_JOY4L             Joypad 4 (Gameport 2, Pin 5) (Lower 8bit)            2B/R
  jr k1
  nop                    // Delay Slot

STORE421F:
  // $421F REG_JOY4H             Joypad 4 (Gameport 2, Pin 5) (Upper 8bit)            1B/R
  jr k1
  nop                    // Delay Slot

STORE4220:
  // $4220..$42FF                Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot