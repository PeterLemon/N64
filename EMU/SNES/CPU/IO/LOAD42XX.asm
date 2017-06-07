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
  jr k1
  nop                    // Delay Slot

LOAD4219:
  // $4219 REG_JOY1H             Joypad 1 (Gameport 1, Pin 4) (Upper 8bit)            1B/R
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