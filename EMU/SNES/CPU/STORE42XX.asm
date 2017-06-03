align(256)
  // $4200 REG_NMITIMEN          Interrupt Enable & Joypad Request                    1B/W
  jr k1
  nop                    // Delay Slot

align(256)
  // $4201 REG_WRIO              Joypad Programmable I/O Port (Open-Collector Output) 1B/W
  jr k1
  nop                    // Delay Slot

align(256)
  // $4202 REG_WRMPYA            Set Unsigned  8bit Multiplicand                      1B/W
  jr k1
  nop                    // Delay Slot

align(256)
  // $4203 REG_WRMPYB            Set Unsigned  8bit Multiplier & Start Multiplication 1B/W
  jr k1
  nop                    // Delay Slot

align(256)
  // $4204 REG_WRDIVL            Set Unsigned 16bit Dividend (Lower 8bit)             2B/W
  jr k1
  nop                    // Delay Slot

align(256)
  // $4205 REG_WRDIVH            Set Unsigned 16bit Dividend (Upper 8bit)             1B/W
  jr k1
  nop                    // Delay Slot

align(256)
  // $4206 REG_WRDIVB            Set Unsigned  8bit Divisor & Start Division          1B/W
  jr k1
  nop                    // Delay Slot

align(256)
  // $4207 REG_HTIMEL            H-Count Timer Setting (Lower 8bits)                  2B/W
  jr k1
  nop                    // Delay Slot

align(256)
  // $4208 REG_HTIMEH            H-Count Timer Setting (Upper 1bit)                   1B/W
  jr k1
  nop                    // Delay Slot

align(256)
  // $4209 REG_VTIMEL            V-Count Timer Setting (Lower 8bits)                  2B/W
  jr k1
  nop                    // Delay Slot

align(256)
  // $420A REG_VTIMEH            V-Count Timer Setting (Upper 1bit)                   1B/W
  jr k1
  nop                    // Delay Slot

align(256)
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

    sll t0,8              // Offset <<= 8 (Table Offset)
    la t1,DMAPXX          // T1 = DMA 0..7 Table
    addu t1,t0            // T1 = DMA 0..7 Table + Table Offset
    jr t1                 // Run DMA 0..7 Table Instruction
    nop // Delay Slot

  MDMAENCHECK:
    ori t0,r0,7           // T0 = 7
    bne t9,t0,MDMAENLOOP  // IF (DMA Channel Count != 7) MDMAEN LOOP
    addiu t9,1            // DMA Channel Count++ (Delay Slot)

  MDMAENEND:
  jr k1
  sb r0,REG_MDMAEN(a0)   // MEM_MAP[REG_MDMAEN] = 0 (Delay Slot)

align(256)
  // $420C REG_HDMAEN            Select H-Blank DMA (H-DMA) Channels                  1B/W
  jr k1
  nop                    // Delay Slot

align(256)
  // $420D REG_MEMSEL            Memory-2 Waitstate Control                           1B/W
  jr k1
  nop                    // Delay Slot

align(256)
  // $420E                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $420F                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4210 REG_RDNMI             V-Blank NMI Flag and CPU Version Number (Read/Ack)   1B/R
  jr k1
  nop                    // Delay Slot

align(256)
  // $4211 REG_TIMEUP            H/V-Timer IRQ Flag (Read/Ack)                        1B/R
  jr k1
  nop                    // Delay Slot

align(256)
  // $4212 REG_HVBJOY            H/V-Blank Flag & Joypad Busy Flag                    1B/R
  jr k1
  nop                    // Delay Slot

align(256)
  // $4213 REG_RDIO              Joypad Programmable I/O Port (Input)                 1B/R
  jr k1
  nop                    // Delay Slot

align(256)
  // $4214 REG_RDDIVL            Unsigned Div Result (Quotient) (Lower 8bit)          2B/R
  jr k1
  nop                    // Delay Slot

align(256)
  // $4215 REG_RDDIVH            Unsigned Div Result (Quotient) (Upper 8bit)          1B/R
  jr k1
  nop                    // Delay Slot

align(256)
  // $4216 REG_RDMPYL            Unsigned Div Remainder / Mul Product (Lower 8bit)    2B/R
  jr k1
  nop                    // Delay Slot

align(256)
  // $4217 REG_RDMPYH            Unsigned Div Remainder / Mul Product (Upper 8bit)    1B/R
  jr k1
  nop                    // Delay Slot

align(256)
  // $4218 REG_JOY1L             Joypad 1 (Gameport 1, Pin 4) (Lower 8bit)            2B/R
  jr k1
  nop                    // Delay Slot

align(256)
  // $4219 REG_JOY1H             Joypad 1 (Gameport 1, Pin 4) (Upper 8bit)            1B/R
  jr k1
  nop                    // Delay Slot

align(256)
  // $421A REG_JOY2L             Joypad 2 (Gameport 2, Pin 4) (Lower 8bit)            2B/R
  jr k1
  nop                    // Delay Slot

align(256)
  // $421B REG_JOY2H             Joypad 2 (Gameport 2, Pin 4) (Upper 8bit)            1B/R
  jr k1
  nop                    // Delay Slot

align(256)
  // $421C REG_JOY3L             Joypad 3 (Gameport 1, Pin 5) (Lower 8bit)            2B/R
  jr k1
  nop                    // Delay Slot

align(256)
  // $421D REG_JOY3H             Joypad 3 (Gameport 1, Pin 5) (Upper 8bit)            1B/R
  jr k1
  nop                    // Delay Slot

align(256)
  // $421E REG_JOY4L             Joypad 4 (Gameport 2, Pin 5) (Lower 8bit)            2B/R
  jr k1
  nop                    // Delay Slot

align(256)
  // $421F REG_JOY4H             Joypad 4 (Gameport 2, Pin 5) (Upper 8bit)            1B/R
  jr k1
  nop                    // Delay Slot

align(256)
  // $4220                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4221                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4222                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4223                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4224                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4225                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4226                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4227                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4228                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4229                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $422A                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $422B                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $422C                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $422D                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $422E                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $422F                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4230                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4231                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4232                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4233                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4234                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4235                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4236                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4237                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4238                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4239                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $423A                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $423B                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $423C                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $423D                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $423E                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $423F                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4240                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4241                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4242                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4243                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4244                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4245                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4246                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4247                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4248                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4249                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $424A                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $424B                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $424C                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $424D                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $424E                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $424F                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4250                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4251                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4252                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4253                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4254                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4255                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4256                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4257                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4258                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4259                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $425A                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $425B                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $425C                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $425D                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $425E                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $425F                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4260                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4261                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4262                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4263                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4264                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4265                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4266                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4267                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4268                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4269                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $426A                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $426B                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $426C                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $426D                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $426E                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $426F                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4270                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4271                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4272                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4273                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4274                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4275                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4276                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4277                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4278                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4279                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $427A                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $427B                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $427C                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $427D                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $427E                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $427F                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4280                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4281                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4282                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4283                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4284                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4285                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4286                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4287                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4288                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4289                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $428A                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $428B                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $428C                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $428D                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $428E                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $428F                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4290                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4291                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4292                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4293                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4294                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4295                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4296                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4297                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4298                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $4299                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $429A                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $429B                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $429C                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $429D                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $429E                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $429F                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42A0                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42A1                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42A2                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42A3                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42A4                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42A5                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42A6                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42A7                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42A8                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42A9                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42AA                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42AB                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42AC                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42AD                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42AE                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42AF                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42B0                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42B1                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42B2                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42B3                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42B4                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42B5                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42B6                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42B7                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42B8                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42B9                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42BA                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42BB                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42BC                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42BD                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42BE                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42BF                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42C0                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42C1                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42C2                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42C3                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42C4                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42C5                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42C6                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42C7                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42C8                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42C9                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42CA                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42CB                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42CC                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42CD                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42CE                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42CF                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42D0                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42D1                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42D2                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42D3                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42D4                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42D5                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42D6                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42D7                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42D8                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42D9                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42DA                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42DB                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42DC                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42DD                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42DE                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42DF                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42E0                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42E1                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42E2                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42E3                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42E4                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42E5                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42E6                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42E7                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42E8                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42E9                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42EA                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42EB                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42EC                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42ED                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42EE                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42EF                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42F0                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42F1                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42F2                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42F3                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42F4                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42F5                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42F6                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42F7                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42F8                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42F9                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42FA                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42FB                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42FC                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42FD                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42FE                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

align(256)
  // $42FF                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot