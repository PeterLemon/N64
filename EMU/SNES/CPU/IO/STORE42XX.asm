STORE4200:
  // $4200 REG_NMITIMEN          Interrupt Enable & Joypad Request                    1B/W
  jr k1
  nop                    // Delay Slot

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
  // $4220                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4221:
  // $4221                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4222:
  // $4222                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4223:
  // $4223                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4224:
  // $4224                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4225:
  // $4225                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4226:
  // $4226                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4227:
  // $4227                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4228:
  // $4228                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4229:
  // $4229                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE422A:
  // $422A                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE422B:
  // $422B                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE422C:
  // $422C                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE422D:
  // $422D                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE422E:
  // $422E                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE422F:
  // $422F                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4230:
  // $4230                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4231:
  // $4231                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4232:
  // $4232                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4233:
  // $4233                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4234:
  // $4234                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4235:
  // $4235                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4236:
  // $4236                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4237:
  // $4237                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4238:
  // $4238                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4239:
  // $4239                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE423A:
  // $423A                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE423B:
  // $423B                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE423C:
  // $423C                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE423D:
  // $423D                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE423E:
  // $423E                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE423F:
  // $423F                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4240:
  // $4240                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4241:
  // $4241                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4242:
  // $4242                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4243:
  // $4243                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4244:
  // $4244                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4245:
  // $4245                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4246:
  // $4246                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4247:
  // $4247                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4248:
  // $4248                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4249:
  // $4249                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE424A:
  // $424A                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE424B:
  // $424B                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE424C:
  // $424C                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE424D:
  // $424D                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE424E:
  // $424E                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE424F:
  // $424F                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4250:
  // $4250                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4251:
  // $4251                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4252:
  // $4252                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4253:
  // $4253                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4254:
  // $4254                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4255:
  // $4255                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4256:
  // $4256                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4257:
  // $4257                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4258:
  // $4258                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4259:
  // $4259                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE425A:
  // $425A                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE425B:
  // $425B                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE425C:
  // $425C                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE425D:
  // $425D                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE425E:
  // $425E                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE425F:
  // $425F                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4260:
  // $4260                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4261:
  // $4261                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4262:
  // $4262                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4263:
  // $4263                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4264:
  // $4264                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4265:
  // $4265                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4266:
  // $4266                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4267:
  // $4267                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4268:
  // $4268                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4269:
  // $4269                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE426A:
  // $426A                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE426B:
  // $426B                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE426C:
  // $426C                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE426D:
  // $426D                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE426E:
  // $426E                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE426F:
  // $426F                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4270:
  // $4270                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4271:
  // $4271                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4272:
  // $4272                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4273:
  // $4273                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4274:
  // $4274                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4275:
  // $4275                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4276:
  // $4276                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4277:
  // $4277                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4278:
  // $4278                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4279:
  // $4279                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE427A:
  // $427A                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE427B:
  // $427B                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE427C:
  // $427C                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE427D:
  // $427D                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE427E:
  // $427E                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE427F:
  // $427F                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4280:
  // $4280                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4281:
  // $4281                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4282:
  // $4282                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4283:
  // $4283                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4284:
  // $4284                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4285:
  // $4285                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4286:
  // $4286                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4287:
  // $4287                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4288:
  // $4288                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4289:
  // $4289                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE428A:
  // $428A                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE428B:
  // $428B                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE428C:
  // $428C                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE428D:
  // $428D                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE428E:
  // $428E                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE428F:
  // $428F                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4290:
  // $4290                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4291:
  // $4291                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4292:
  // $4292                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4293:
  // $4293                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4294:
  // $4294                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4295:
  // $4295                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4296:
  // $4296                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4297:
  // $4297                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4298:
  // $4298                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE4299:
  // $4299                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE429A:
  // $429A                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE429B:
  // $429B                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE429C:
  // $429C                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE429D:
  // $429D                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE429E:
  // $429E                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE429F:
  // $429F                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42A0:
  // $42A0                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42A1:
  // $42A1                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42A2:
  // $42A2                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42A3:
  // $42A3                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42A4:
  // $42A4                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42A5:
  // $42A5                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42A6:
  // $42A6                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42A7:
  // $42A7                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42A8:
  // $42A8                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42A9:
  // $42A9                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42AA:
  // $42AA                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42AB:
  // $42AB                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42AC:
  // $42AC                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42AD:
  // $42AD                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42AE:
  // $42AE                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42AF:
  // $42AF                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42B0:
  // $42B0                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42B1:
  // $42B1                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42B2:
  // $42B2                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42B3:
  // $42B3                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42B4:
  // $42B4                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42B5:
  // $42B5                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42B6:
  // $42B6                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42B7:
  // $42B7                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42B8:
  // $42B8                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42B9:
  // $42B9                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42BA:
  // $42BA                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42BB:
  // $42BB                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42BC:
  // $42BC                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42BD:
  // $42BD                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42BE:
  // $42BE                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42BF:
  // $42BF                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42C0:
  // $42C0                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42C1:
  // $42C1                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42C2:
  // $42C2                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42C3:
  // $42C3                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42C4:
  // $42C4                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42C5:
  // $42C5                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42C6:
  // $42C6                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42C7:
  // $42C7                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42C8:
  // $42C8                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42C9:
  // $42C9                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42CA:
  // $42CA                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42CB:
  // $42CB                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42CC:
  // $42CC                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42CD:
  // $42CD                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42CE:
  // $42CE                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42CF:
  // $42CF                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42D0:
  // $42D0                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42D1:
  // $42D1                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42D2:
  // $42D2                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42D3:
  // $42D3                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42D4:
  // $42D4                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42D5:
  // $42D5                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42D6:
  // $42D6                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42D7:
  // $42D7                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42D8:
  // $42D8                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42D9:
  // $42D9                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42DA:
  // $42DA                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42DB:
  // $42DB                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42DC:
  // $42DC                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42DD:
  // $42DD                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42DE:
  // $42DE                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42DF:
  // $42DF                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42E0:
  // $42E0                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42E1:
  // $42E1                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42E2:
  // $42E2                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42E3:
  // $42E3                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42E4:
  // $42E4                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42E5:
  // $42E5                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42E6:
  // $42E6                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42E7:
  // $42E7                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42E8:
  // $42E8                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42E9:
  // $42E9                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42EA:
  // $42EA                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42EB:
  // $42EB                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42EC:
  // $42EC                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42ED:
  // $42ED                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42EE:
  // $42EE                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42EF:
  // $42EF                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42F0:
  // $42F0                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42F1:
  // $42F1                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42F2:
  // $42F2                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42F3:
  // $42F3                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42F4:
  // $42F4                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42F5:
  // $42F5                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42F6:
  // $42F6                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42F7:
  // $42F7                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42F8:
  // $42F8                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42F9:
  // $42F9                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42FA:
  // $42FA                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42FB:
  // $42FB                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42FC:
  // $42FC                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42FD:
  // $42FD                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42FE:
  // $42FE                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot

STORE42FF:
  // $42FF                       Unused Region (Open Bus)
  jr k1
  nop                    // Delay Slot