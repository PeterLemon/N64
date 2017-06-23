LOAD4200:
  // $4200 REG_NMITIMEN          Interrupt Enable & Joypad Request                    1B/W
  jr k1
  nop                    // Delay Slot

LOAD4201:
  // $4201 REG_WRIO              Joypad Programmable I/O Port (Open-Collector Output) 1B/W
  jr k1
  nop                    // Delay Slot

LOAD4202:
  // $4202 REG_WRMPYA            Set Unsigned  8bit Multiplicand                      1B/W
  jr k1
  nop                    // Delay Slot

LOAD4203:
  // $4203 REG_WRMPYB            Set Unsigned  8bit Multiplier & Start Multiplication 1B/W
  jr k1
  nop                    // Delay Slot

LOAD4204:
  // $4204 REG_WRDIVL            Set Unsigned 16bit Dividend (Lower 8bit)             2B/W
  jr k1
  nop                    // Delay Slot

LOAD4205:
  // $4205 REG_WRDIVH            Set Unsigned 16bit Dividend (Upper 8bit)             1B/W
  jr k1
  nop                    // Delay Slot

LOAD4206:
  // $4206 REG_WRDIVB            Set Unsigned  8bit Divisor & Start Division          1B/W
  jr k1
  nop                    // Delay Slot

LOAD4207:
  // $4207 REG_HTIMEL            H-Count Timer Setting (Lower 8bits)                  2B/W
  jr k1
  nop                    // Delay Slot

LOAD4208:
  // $4208 REG_HTIMEH            H-Count Timer Setting (Upper 1bit)                   1B/W
  jr k1
  nop                    // Delay Slot

LOAD4209:
  // $4209 REG_VTIMEL            V-Count Timer Setting (Lower 8bits)                  2B/W
  jr k1
  nop                    // Delay Slot

LOAD420A:
  // $420A REG_VTIMEH            V-Count Timer Setting (Upper 1bit)                   1B/W
  jr k1
  nop                    // Delay Slot

LOAD420B:
  // $420B REG_MDMAEN            Select General Purpose DMA Channels & Start Transfer 1B/W
  jr k1
  nop                    // Delay Slot

LOAD420C:
  // $420C REG_HDMAEN            Select H-Blank DMA (H-DMA) Channels                  1B/W
  jr k1
  nop                    // Delay Slot

LOAD420D:
  // $420D REG_MEMSEL            Memory-2 Waitstate Control                           1B/W
  jr k1
  nop                    // Delay Slot

LOAD420E:
  // $420E                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

LOAD420F:
  // $420F                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

LOAD4210:
  // $4210 REG_RDNMI             V-Blank NMI Flag and CPU Version Number (Read/Ack)   1B/R
  lbu t0,REG_RDNMI(a0)   // T0 = MEM_MAP[REG_RDNMI]
  beqz t0,RDNMISKIP      // IF (REG_RDNMI == 0) RDNMI Skip
  ori t1,r0,$80          // T1 = $80 (Delay Slot)
  la t0,RDNMI            // T0 = RDNMI
  sb t1,0(t0)            // RDNMI = $80 (NMI Reset After Read)
  RDNMISKIP:
  jr k1
  nop                    // Delay Slot

LOAD4211:
  // $4211 REG_TIMEUP            H/V-Timer IRQ Flag (Read/Ack)                        1B/R
  jr k1
  nop                    // Delay Slot

LOAD4212:
  // $4212 REG_HVBJOY            H/V-Blank Flag & Joypad Busy Flag                    1B/R
  jr k1
  nop                    // Delay Slot

LOAD4213:
  // $4213 REG_RDIO              Joypad Programmable I/O Port (Input)                 1B/R
  jr k1
  nop                    // Delay Slot

LOAD4214:
  // $4214 REG_RDDIVL            Unsigned Div Result (Quotient) (Lower 8bit)          2B/R
  jr k1
  nop                    // Delay Slot

LOAD4215:
  // $4215 REG_RDDIVH            Unsigned Div Result (Quotient) (Upper 8bit)          1B/R
  jr k1
  nop                    // Delay Slot

LOAD4216:
  // $4216 REG_RDMPYL            Unsigned Div Remainder / Mul Product (Lower 8bit)    2B/R
  jr k1
  nop                    // Delay Slot

LOAD4217:
  // $4217 REG_RDMPYH            Unsigned Div Remainder / Mul Product (Upper 8bit)    1B/R
  jr k1
  nop                    // Delay Slot

LOAD4218:
  // $4218 REG_JOY1L             Joypad 1 (Gameport 1, Pin 4) (Lower 8bit)            2B/R
  la t0,NMITIMEN // T0 = NMITIMEN Address
  lbu t0,0(t0) // T0 = NMITIMEN Byte
  andi t0,1 // T0 &= NMITIMEN: Joypad Enable
  beqz t0,JOY1LSKIP // IF (Joypad Enable == 0) JOY1L Skip
  sb r0,REG_JOY1L(a0) // MEM_MAP[REG_JOY1L] = 0 (Delay Slot)

  // Read N64 Controller 1 Buttons Hi Byte (L & R, N64 CAMERA LEFT = SNES X, N64 CAMERA DOWN = SNES A)
  lui t0,PIF_BASE // T0 = PIF Base Register ($BFC00000)
  lui t1,SI_BASE // T1 = SI Base Register ($A4800000)
  la t2,PIF2 // T2 = PIF2 Offset
  sw t2,SI_DRAM_ADDR(t1) // Store PIF2 To SI_DRAM_ADDR ($A4800000)
  ori t2,t1,PIF_RAM // T2 = PIF_RAM: JoyChannel ($BFC007C0)
  sw t2,SI_PIF_ADDR_RD64B(t1) // 64 Byte Read PIF -> DRAM ($A4800004)
  lbu t0,PIF_HWORD+1(t0) // T0 = Buttons Lo Byte ($BFC007C4)
  andi t1,t0,$30 // T1 = L & R
  andi t0,$6     // T0 = CAMERA LEFT & CAMERA DOWN
  sll t0,3       // T0 <<= 3
  or t0,t1       // T0 |= T1
  sb t0,REG_JOY1L(a0)  // MEM_MAP[REG_JOY1L] = T0

  JOY1LSKIP:
  jr k1
  nop                    // Delay Slot

LOAD4219:
  // $4219 REG_JOY1H             Joypad 1 (Gameport 1, Pin 4) (Upper 8bit)            1B/R
  la t0,NMITIMEN // T0 = NMITIMEN Address
  lbu t0,0(t0) // T0 = NMITIMEN Byte
  andi t0,1 // T0 &= NMITIMEN: Joypad Enable
  beqz t0,JOY1HSKIP // IF (Joypad Enable == 0) JOY1H Skip
  sb r0,REG_JOY1H(a0) // MEM_MAP[REG_JOY1H] = 0 (Delay Slot)

  // Read N64 Controller 1 Buttons Hi Byte (Directions & Start, N64 B = SNES Y, N64 A = SNES B, N64 Z = SNES Select)
  lui t0,PIF_BASE // T0 = PIF Base Register ($BFC00000)
  lui t1,SI_BASE // T1 = SI Base Register ($A4800000)
  la t2,PIF2 // T2 = PIF2 Offset
  sw t2,SI_DRAM_ADDR(t1) // Store PIF2 To SI_DRAM_ADDR ($A4800000)
  ori t2,t1,PIF_RAM // T2 = PIF_RAM: JoyChannel ($BFC007C0)
  sw t2,SI_PIF_ADDR_RD64B(t1) // 64 Byte Read PIF -> DRAM ($A4800004)
  lbu t0,PIF_HWORD(t0) // T0 = Buttons Hi Byte ($BFC007C4)
  sb t0,REG_JOY1H(a0)  // MEM_MAP[REG_JOY1H] = T0

  JOY1HSKIP:
  jr k1
  nop                    // Delay Slot

LOAD421A:
  // $421A REG_JOY2L             Joypad 2 (Gameport 2, Pin 4) (Lower 8bit)            2B/R
  jr k1
  nop                    // Delay Slot

LOAD421B:
  // $421B REG_JOY2H             Joypad 2 (Gameport 2, Pin 4) (Upper 8bit)            1B/R
  jr k1
  nop                    // Delay Slot

LOAD421C:
  // $421C REG_JOY3L             Joypad 3 (Gameport 1, Pin 5) (Lower 8bit)            2B/R
  jr k1
  nop                    // Delay Slot

LOAD421D:
  // $421D REG_JOY3H             Joypad 3 (Gameport 1, Pin 5) (Upper 8bit)            1B/R
  jr k1
  nop                    // Delay Slot

LOAD421E:
  // $421E REG_JOY4L             Joypad 4 (Gameport 2, Pin 5) (Lower 8bit)            2B/R
  jr k1
  nop                    // Delay Slot

LOAD421F:
  // $421F REG_JOY4H             Joypad 4 (Gameport 2, Pin 5) (Upper 8bit)            1B/R
  jr k1
  nop                    // Delay Slot

LOAD4220:
  // $4220..$42FF                Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot