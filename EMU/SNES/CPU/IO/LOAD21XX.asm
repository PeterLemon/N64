LOAD2100:
  // $2100 REG_INIDISP           Display Control 1                                    1B/W
  jr gp
  nop                    // Delay Slot

LOAD2101:
  // $2101 REG_OBSEL             Object Size & Object Base                            1B/W
  jr gp
  nop                    // Delay Slot

LOAD2102:
  // $2102 REG_OAMADDL           OAM Address (Lower 8bit)                             2B/W
  jr gp
  nop                    // Delay Slot

LOAD2103:
  // $2103 REG_OAMADDH           OAM Address (Upper 1bit) & Priority Rotation         1B/W
  jr gp
  nop                    // Delay Slot

LOAD2104:
  // $2104 REG_OAMDATA           OAM Data Write                                       1B/W D
  jr gp
  nop                    // Delay Slot

LOAD2105:
  // $2105 REG_BGMODE            BG Mode and BG Character Size                        1B/W
  jr gp
  nop                    // Delay Slot

LOAD2106:
  // $2106 REG_MOSAIC            Mosaic Size and Mosaic Enable                        1B/W
  jr gp
  nop                    // Delay Slot

LOAD2107:
  // $2107 REG_BG1SC             BG1 Screen Base & Screen Size                        1B/W
  jr gp
  nop                    // Delay Slot

LOAD2108:
  // $2108 REG_BG2SC             BG2 Screen Base & Screen Size                        1B/W
  jr gp
  nop                    // Delay Slot

LOAD2109:
  // $2109 REG_BG3SC             BG3 Screen Base & Screen Size                        1B/W
  jr gp
  nop                    // Delay Slot

LOAD210A:
  // $210A REG_BG4SC             BG4 Screen Base & Screen Size                        1B/W
  jr gp
  nop                    // Delay Slot

LOAD210B:
  // $210B REG_BG12NBA           BG Character Data Area Designation                   1B/W
  jr gp
  nop                    // Delay Slot

LOAD210C:
  // $210C REG_BG34NBA           BG Character Data Area Designation                   1B/W
  jr gp
  nop                    // Delay Slot

LOAD210D:
  // $210D REG_BG1HOFS           BG1 Horizontal Scroll (X) / M7HOFS                   1B/W D
  jr gp
  nop                    // Delay Slot

LOAD210E:
  // $210E REG_BG1VOFS           BG1 Vertical   Scroll (Y) / M7VOFS                   1B/W D
  jr gp
  nop                    // Delay Slot

LOAD210F:
  // $210F REG_BG2HOFS           BG2 Horizontal Scroll (X)                            1B/W D
  jr gp
  nop                    // Delay Slot

LOAD2110:
  // $2110 REG_BG2VOFS           BG2 Vertical   Scroll (Y)                            1B/W D
  jr gp
  nop                    // Delay Slot

LOAD2111:
  // $2111 REG_BG3HOFS           BG3 Horizontal Scroll (X)                            1B/W D
  jr gp
  nop                    // Delay Slot

LOAD2112:
  // $2112 REG_BG3VOFS           BG3 Vertical   Scroll (Y)                            1B/W D
  jr gp
  nop                    // Delay Slot

LOAD2113:
  // $2113 REG_BG4HOFS           BG4 Horizontal Scroll (X)                            1B/W D
  jr gp
  nop                    // Delay Slot

LOAD2114:
  // $2114 REG_BG4VOFS           BG4 Vertical   Scroll (Y)                            1B/W D
  jr gp
  nop                    // Delay Slot

LOAD2115:
  // $2115 REG_VMAIN             VRAM Address Increment Mode                          1B/W
  jr gp
  nop                    // Delay Slot

LOAD2116:
  // $2116 REG_VMADDL            VRAM Address    (Lower 8bit)                         2B/W
  jr gp
  nop                    // Delay Slot

LOAD2117:
  // $2117 REG_VMADDH            VRAM Address    (Upper 8bit)                         1B/W
  jr gp
  nop                    // Delay Slot

LOAD2118:
  // $2118 REG_VMDATAL           VRAM Data Write (Lower 8bit)                         2B/W
  jr gp
  nop                    // Delay Slot

LOAD2119:
  // $2119 REG_VMDATAH           VRAM Data Write (Upper 8bit)                         1B/W
  jr gp
  nop                    // Delay Slot

LOAD211A:
  // $211A REG_M7SEL             MODE7 Rot/Scale Mode Settings                        1B/W
  jr gp
  nop                    // Delay Slot

LOAD211B:
  // $211B REG_M7A               MODE7 Rot/Scale A (COSINE A) & Maths 16bit Operand   1B/W D
  jr gp
  nop                    // Delay Slot

LOAD211C:
  // $211C REG_M7B               MODE7 Rot/Scale B (SINE A)   & Maths  8bit Operand   1B/W D
  jr gp
  nop                    // Delay Slot

LOAD211D:
  // $211D REG_M7C               MODE7 Rot/Scale C (SINE B)                           1B/W D
  jr gp
  nop                    // Delay Slot

LOAD211E:
  // $211E REG_M7D               MODE7 Rot/Scale D (COSINE B)                         1B/W D
  jr gp
  nop                    // Delay Slot

LOAD211F:
  // $211F REG_M7X               MODE7 Rot/Scale Center Coordinate X                  1B/W D
  jr gp
  nop                    // Delay Slot

LOAD2120:
  // $2120 REG_M7Y               MODE7 Rot/Scale Center Coordinate Y                  1B/W D
  jr gp
  nop                    // Delay Slot

LOAD2121:
  // $2121 REG_CGADD             Palette CGRAM Address                                1B/W
  jr gp
  nop                    // Delay Slot

LOAD2122:
  // $2122 REG_CGDATA            Palette CGRAM Data Write                             1B/W D
  jr gp
  nop                    // Delay Slot

LOAD2123:
  // $2123 REG_W12SEL            Window BG1/BG2  Mask Settings                        1B/W
  jr gp
  nop                    // Delay Slot

LOAD2124:
  // $2124 REG_W34SEL            Window BG3/BG4  Mask Settings                        1B/W
  jr gp
  nop                    // Delay Slot

LOAD2125:
  // $2125 REG_WOBJSEL           Window OBJ/MATH Mask Settings                        1B/W
  jr gp
  nop                    // Delay Slot

LOAD2126:
  // $2126 REG_WH0               Window 1 Left  Position (X1)                         1B/W
  jr gp
  nop                    // Delay Slot

LOAD2127:
  // $2127 REG_WH1               Window 1 Right Position (X2)                         1B/W
  jr gp
  nop                    // Delay Slot

LOAD2128:
  // $2128 REG_WH2               Window 2 Left  Position (X1)                         1B/W
  jr gp
  nop                    // Delay Slot

LOAD2129:
  // $2129 REG_WH3               Window 2 Right Position (X2)                         1B/W
  jr gp
  nop                    // Delay Slot

LOAD212A:
  // $212A REG_WBGLOG            Window 1/2 Mask Logic (BG1-BG4)                      1B/W
  jr gp
  nop                    // Delay Slot

LOAD212B:
  // $212B REG_WOBJLOG           Window 1/2 Mask Logic (OBJ/MATH)                     1B/W
  jr gp
  nop                    // Delay Slot

LOAD212C:
  // $212C REG_TM                Main Screen Designation                              1B/W
  jr gp
  nop                    // Delay Slot

LOAD212D:
  // $212D REG_TS                Sub  Screen Designation                              1B/W
  jr gp
  nop                    // Delay Slot

LOAD212E:
  // $212E REG_TMW               Window Area Main Screen Disable                      1B/W
  jr gp
  nop                    // Delay Slot

LOAD212F:
  // $212F REG_TSW               Window Area Sub  Screen Disable                      1B/W
  jr gp
  nop                    // Delay Slot

LOAD2130:
  // $2130 REG_CGWSEL            Color Math Control Register A                        1B/W
  jr gp
  nop                    // Delay Slot

LOAD2131:
  // $2131 REG_CGADSUB           Color Math Control Register B                        1B/W
  jr gp
  nop                    // Delay Slot

LOAD2132:
  // $2132 REG_COLDATA           Color Math Sub Screen Backdrop Color                 1B/W
  jr gp
  nop                    // Delay Slot

LOAD2133:
  // $2133 REG_SETINI            Display Control 2                                    1B/W
  jr gp
  nop                    // Delay Slot

LOAD2134:
  // $2134 REG_MPYL              PPU1 Signed Multiply Result (Lower  8bit)            1B/R
  jr gp
  nop                    // Delay Slot

LOAD2135:
  // $2135 REG_MPYM              PPU1 Signed Multiply Result (Middle 8bit)            1B/R
  jr gp
  nop                    // Delay Slot

LOAD2136:
  // $2136 REG_MPYH              PPU1 Signed Multiply Result (Upper  8bit)            1B/R
  jr gp
  nop                    // Delay Slot

LOAD2137:
  // $2137 REG_SLHV              PPU1 Latch H/V-Counter By Software (Read=Strobe)     1B/R
  jr gp
  nop                    // Delay Slot

LOAD2138:
  // $2138 REG_RDOAM             PPU1 OAM  Data Read                                  1B/R D
  la t1,OAMDATA          // T1 = OAMDATA
  lbu t2,2(t1)           // T2 = OAMDATA Flip Flop
  lhu t3,-2(t1)          // T3 = OAMADD
  la t4,OAM              // T4 = OAM
  sll t3,1               // OAMADD << 1
  bnez t2,RDOAMHI        // IF (Flip Flop != 0) Read Hi Byte, Else Read Lo Byte
  addu t4,t3             // OAM += OAMADD (Delay Slot)
  lbu t0,0(t4)           // T0 = OAM[OAMADD] Lo
  sb t0,REG_RDOAM(a0)    // MEM_MAP[REG_RDOAM] = T0
  b RDOAMEND
  nop                    // Delay Slot
  RDOAMHI:
  lbu t0,1(t4)           // T0 = OAM[OAMADD] Hi
  sb t0,REG_RDOAM(a0)    // MEM_MAP[REG_RDOAM] = T0
  srl t3,1               // OAMADD >> 1
  addiu t3,1             // OAMADD++
  sh t3,-2(t1)           // OAMADD = T3
  RDOAMEND:
  addiu t2,1             // T2++
  andi t2,1              // T2 &= 1
  jr gp
  sb t2,2(t1)            // OAMDATA Flip Flop = T2 (Delay Slot)

LOAD2139:
  // $2139 REG_RDVRAML           PPU1 VRAM  Data Read (Lower 8bits)                   1B/R
  la t1,VMDATA           // T1 = VMDATA
  lhu t2,-2(t1)          // T2 = VMADD
  la t3,VRAM             // T3 = VRAM
  sll t2,1               // VMADD << 1
  addu t3,t2             // VRAM += VMADD
  lbu t0,0(t3)           // T0 = VRAM[VMADD] Lo
  sb t0,REG_RDVRAML(a0)  // MEM_MAP[RDVRAML] = T0
  lbu t3,-3(t1)          // T3 = VMAIN
  andi t4,t3,$80         // T4 = Increment VRAM Address After Accessing High/Low Byte (0=Low, 1=High)
  bnez t4,RDVRAMLEND     // IF (T4 != 0) RDVRAMLEND
  srl t2,1               // VMADD >> 1 (Delay Slot)
  andi t3,$03            // T3 = Address Increment Step (Increment Word-Address: 0=1, 1=32, 2=128, 3=128)
  beqz t3,RDVRAMLEND     // IF (T3 == 0) RDVRAMLEND
  addiu t2,1             // VMADD++ (Delay Slot)
  or t4,r0,1             // T4 = 1
  beq t3,t4,RDVRAMLEND   // IF (T3 == 1) RDVRAMLEND
  addiu t2,31            // VMADD += 31 (Delay Slot)
  addiu t2,96            // VMADD += 96
  RDVRAMLEND:
  jr gp
  sh t2,-2(t1)           // VMADD = T2 (Delay Slot)

LOAD213A:
  // $213A REG_RDVRAMH           PPU1 VRAM  Data Read (Upper 8bits)                   1B/R
  la t1,VMDATA           // T1 = VMDATA
  lhu t2,-2(t1)          // T2 = VMADD
  la t3,VRAM             // T3 = VRAM
  sll t2,1               // VMADD << 1
  addu t3,t2             // VRAM += VMADD
  lbu t0,1(t3)           // T0 = VRAM[VMADD] Hi
  sb t0,REG_RDVRAMH(a0)  // MEM_MAP[RDVRAMH] = T0
  lbu t3,-3(t1)          // T3 = VMAIN
  andi t4,t3,$80         // T4 = Increment VRAM Address After Accessing High/Low Byte (0=Low, 1=High)
  beqz t4,RDVRAMHEND     // IF (T4 == 0) RDVRAMHEND
  srl t2,1               // VMADD >> 1 (Delay Slot)
  andi t3,$03            // T3 = Address Increment Step (Increment Word-Address: 0=1, 1=32, 2=128, 3=128)
  beqz t3,RDVRAMHEND     // IF (T3 == 0) RDVRAMHEND
  addiu t2,1             // VMADD++ (Delay Slot)
  or t4,r0,1             // T4 = 1
  beq t3,t4,RDVRAMHEND   // IF (T3 == 1) RDVRAMHEND
  addiu t2,31            // VMADD += 31 (Delay Slot)
  addiu t2,96            // VMADD += 96
  RDVRAMHEND:
  jr gp
  sh t2,-2(t1)           // VMADD = T2 (Delay Slot)

LOAD213B:
  // $213B REG_RDCGRAM           PPU2 CGRAM Data Read (Palette)                       1B/R D
  la t1,CGDATA           // T1 = CGDATA
  lbu t2,2(t1)           // T2 = CGDATA Flip Flop
  lbu t3,-1(t1)          // T3 = CGADD
  la t4,CGRAM            // T4 = CGRAM
  sll t3,1               // CGADD << 1
  bnez t2,RDCGRAMHI      // IF (Flip Flop != 0) Write Hi Byte, Else Write Lo Byte
  addu t4,t3             // CGRAM += CGADD (Delay Slot)
  lbu t0,0(t4)           // T0 = CGRAM[CGADD] Lo
  sb t0,REG_RDCGRAM(a0)  // MEM_MAP[REG_RDCGRAM] = T0
  b CGDATAEND
  nop                    // Delay Slot
  RDCGRAMHI:
  lbu t0,1(t4)           // T0 = CGRAM[CGADD] Hi
  sb t0,REG_RDCGRAM(a0)  // MEM_MAP[REG_RDCGRAM] = T0
  srl t3,1               // CGADD >> 1
  addiu t3,1             // CGADD++
  sb t3,-1(t1)           // CGADD = T3
  RDCGRAMEND:
  addiu t2,1             // T2++
  andi t2,1              // T2 &= 1
  jr gp
  sb t2,2(t1)            // CGDATA Flip Flop = T2 (Delay Slot)

LOAD213C:
  // $213C REG_OPHCT             PPU2 Horizontal Counter Latch (Scanline X)           1B/R D
  jr gp
  nop                    // Delay Slot

LOAD213D:
  // $213D REG_OPVCT             PPU2 Vertical   Counter Latch (Scanline Y)           1B/R D
  jr gp
  nop                    // Delay Slot

LOAD213E:
  // $213E REG_STAT77            PPU1 Status & PPU1 Version Number                    1B/R
  jr gp
  nop                    // Delay Slot

LOAD213F:
  // $213F REG_STAT78            PPU2 Status & PPU2 Version Number (Bit 7=0)          1B/R
  jr gp
  nop                    // Delay Slot

LOAD2140:
  // $2140 REG_APUIO0            Main CPU To Sound CPU Communication Port 0           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD2141:
  // $2141 REG_APUIO1            Main CPU To Sound CPU Communication Port 1           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD2142:
  // $2142 REG_APUIO2            Main CPU To Sound CPU Communication Port 2           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD2143:
  // $2143 REG_APUIO3            Main CPU To Sound CPU Communication Port 3           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD2144:
  // $2144 REG_APUIO0            Main CPU To Sound CPU Communication Port 0           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD2145:
  // $2145 REG_APUIO1            Main CPU To Sound CPU Communication Port 1           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD2146:
  // $2146 REG_APUIO2            Main CPU To Sound CPU Communication Port 2           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD2147:
  // $2147 REG_APUIO3            Main CPU To Sound CPU Communication Port 3           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD2148:
  // $2148 REG_APUIO0            Main CPU To Sound CPU Communication Port 0           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD2149:
  // $2149 REG_APUIO1            Main CPU To Sound CPU Communication Port 1           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD214A:
  // $214A REG_APUIO2            Main CPU To Sound CPU Communication Port 2           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD214B:
  // $214B REG_APUIO3            Main CPU To Sound CPU Communication Port 3           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD214C:
  // $214C REG_APUIO0            Main CPU To Sound CPU Communication Port 0           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD214D:
  // $214D REG_APUIO1            Main CPU To Sound CPU Communication Port 1           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD214E:
  // $214E REG_APUIO2            Main CPU To Sound CPU Communication Port 2           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD214F:
  // $214F REG_APUIO3            Main CPU To Sound CPU Communication Port 3           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD2150:
  // $2150 REG_APUIO0            Main CPU To Sound CPU Communication Port 0           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD2151:
  // $2151 REG_APUIO1            Main CPU To Sound CPU Communication Port 1           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD2152:
  // $2152 REG_APUIO2            Main CPU To Sound CPU Communication Port 2           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD2153:
  // $2153 REG_APUIO3            Main CPU To Sound CPU Communication Port 3           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD2154:
  // $2154 REG_APUIO0            Main CPU To Sound CPU Communication Port 0           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD2155:
  // $2155 REG_APUIO1            Main CPU To Sound CPU Communication Port 1           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD2156:
  // $2156 REG_APUIO2            Main CPU To Sound CPU Communication Port 2           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD2157:
  // $2157 REG_APUIO3            Main CPU To Sound CPU Communication Port 3           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD2158:
  // $2158 REG_APUIO0            Main CPU To Sound CPU Communication Port 0           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD2159:
  // $2159 REG_APUIO1            Main CPU To Sound CPU Communication Port 1           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD215A:
  // $215A REG_APUIO2            Main CPU To Sound CPU Communication Port 2           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD215B:
  // $215B REG_APUIO3            Main CPU To Sound CPU Communication Port 3           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD215C:
  // $215C REG_APUIO0            Main CPU To Sound CPU Communication Port 0           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD215D:
  // $215D REG_APUIO1            Main CPU To Sound CPU Communication Port 1           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD215E:
  // $215E REG_APUIO2            Main CPU To Sound CPU Communication Port 2           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD215F:
  // $215F REG_APUIO3            Main CPU To Sound CPU Communication Port 3           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD2160:
  // $2160 REG_APUIO0            Main CPU To Sound CPU Communication Port 0           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD2161:
  // $2161 REG_APUIO1            Main CPU To Sound CPU Communication Port 1           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD2162:
  // $2162 REG_APUIO2            Main CPU To Sound CPU Communication Port 2           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD2163:
  // $2163 REG_APUIO3            Main CPU To Sound CPU Communication Port 3           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD2164:
  // $2164 REG_APUIO0            Main CPU To Sound CPU Communication Port 0           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD2165:
  // $2165 REG_APUIO1            Main CPU To Sound CPU Communication Port 1           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD2166:
  // $2166 REG_APUIO2            Main CPU To Sound CPU Communication Port 2           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD2167:
  // $2167 REG_APUIO3            Main CPU To Sound CPU Communication Port 3           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD2168:
  // $2168 REG_APUIO0            Main CPU To Sound CPU Communication Port 0           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD2169:
  // $2169 REG_APUIO1            Main CPU To Sound CPU Communication Port 1           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD216A:
  // $216A REG_APUIO2            Main CPU To Sound CPU Communication Port 2           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD216B:
  // $216B REG_APUIO3            Main CPU To Sound CPU Communication Port 3           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD216C:
  // $216C REG_APUIO0            Main CPU To Sound CPU Communication Port 0           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD216D:
  // $216D REG_APUIO1            Main CPU To Sound CPU Communication Port 1           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD216E:
  // $216E REG_APUIO2            Main CPU To Sound CPU Communication Port 2           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD216F:
  // $216F REG_APUIO3            Main CPU To Sound CPU Communication Port 3           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD2170:
  // $2170 REG_APUIO0            Main CPU To Sound CPU Communication Port 0           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD2171:
  // $2171 REG_APUIO1            Main CPU To Sound CPU Communication Port 1           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD2172:
  // $2172 REG_APUIO2            Main CPU To Sound CPU Communication Port 2           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD2173:
  // $2173 REG_APUIO3            Main CPU To Sound CPU Communication Port 3           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD2174:
  // $2174 REG_APUIO0            Main CPU To Sound CPU Communication Port 0           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD2175:
  // $2175 REG_APUIO1            Main CPU To Sound CPU Communication Port 1           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD2176:
  // $2176 REG_APUIO2            Main CPU To Sound CPU Communication Port 2           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD2177:
  // $2177 REG_APUIO3            Main CPU To Sound CPU Communication Port 3           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD2178:
  // $2178 REG_APUIO0            Main CPU To Sound CPU Communication Port 0           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD2179:
  // $2179 REG_APUIO1            Main CPU To Sound CPU Communication Port 1           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD217A:
  // $217A REG_APUIO2            Main CPU To Sound CPU Communication Port 2           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD217B:
  // $217B REG_APUIO3            Main CPU To Sound CPU Communication Port 3           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD217C:
  // $217C REG_APUIO0            Main CPU To Sound CPU Communication Port 0           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD217D:
  // $217D REG_APUIO1            Main CPU To Sound CPU Communication Port 1           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD217E:
  // $217E REG_APUIO2            Main CPU To Sound CPU Communication Port 2           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD217F:
  // $217F REG_APUIO3            Main CPU To Sound CPU Communication Port 3           1B/RW
  jr gp
  nop                    // Delay Slot

LOAD2180:
  // $2180 REG_WMDATA            WRAM Data Read/Write                                 1B/RW
  jr gp
  nop                    // Delay Slot

LOAD2181:
  // $2181 REG_WMADDL            WRAM Address (Lower  8bit)                           1B/W
  jr gp
  nop                    // Delay Slot

LOAD2182:
  // $2182 REG_WMADDM            WRAM Address (Middle 8bit)                           1B/W
  jr gp
  nop                    // Delay Slot

LOAD2183:
  // $2183 REG_WMADDH            WRAM Address (Upper  1bit)                           1B/W
  jr gp
  nop                    // Delay Slot

LOAD2184:
  // $2184..$21FF                Unused Region (Open Bus)/Expansion (B-Bus)
  jr gp
  nop                    // Delay Slot