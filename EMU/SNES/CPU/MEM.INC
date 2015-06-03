; Memory Map
WRAM_MIR:     equ $0000 ; WRAM Mirror ($7E0000-$7E1FFF)                       8KB/RW
; $2000..$20FF - Unused Region

; PPU Picture Processing Unit Ports (Write-Only)
REG_INIDISP:  equ $2100 ; Display Control 1                                    1B/W
REG_OBSEL:    equ $2101 ; Object Size & Object Base                            1B/W
REG_OAMADDL:  equ $2102 ; OAM Address (Lower 8bit)                             2B/W
REG_OAMADDH:  equ $2103 ; OAM Address (Upper 1bit) & Priority Rotation         1B/W
REG_OAMDATA:  equ $2104 ; OAM Data Write                                       1B/W D
REG_BGMODE:   equ $2105 ; BG Mode and BG Character Size                        1B/W
REG_MOSAIC:   equ $2106 ; Mosaic Size and Mosaic Enable                        1B/W
REG_BG1SC:    equ $2107 ; BG1 Screen Base & Screen Size                        1B/W
REG_BG2SC:    equ $2108 ; BG2 Screen Base & Screen Size                        1B/W
REG_BG3SC:    equ $2109 ; BG3 Screen Base & Screen Size                        1B/W
REG_BG4SC:    equ $210A ; BG4 Screen Base & Screen Size                        1B/W
REG_BG12NBA:  equ $210B ; BG Character Data Area Designation                   1B/W
REG_BG34NBA:  equ $210C ; BG Character Data Area Designation                   1B/W
REG_BG1HOFS:  equ $210D ; BG1 Horizontal Scroll (X) / M7HOFS                   1B/W D
REG_BG1VOFS:  equ $210E ; BG1 Vertical   Scroll (Y) / M7VOFS                   1B/W D
REG_BG2HOFS:  equ $210F ; BG2 Horizontal Scroll (X)                            1B/W D
REG_BG2VOFS:  equ $2110 ; BG2 Vertical   Scroll (Y)                            1B/W D
REG_BG3HOFS:  equ $2111 ; BG3 Horizontal Scroll (X)                            1B/W D
REG_BG3VOFS:  equ $2112 ; BG3 Vertical   Scroll (Y)                            1B/W D
REG_BG4HOFS:  equ $2113 ; BG4 Horizontal Scroll (X)                            1B/W D
REG_BG4VOFS:  equ $2114 ; BG4 Vertical   Scroll (Y)                            1B/W D
REG_VMAIN:    equ $2115 ; VRAM Address Increment Mode                          1B/W
REG_VMADDL:   equ $2116 ; VRAM Address    (Lower 8bit)                         2B/W
REG_VMADDH:   equ $2117 ; VRAM Address    (Upper 8bit)                         1B/W
REG_VMDATAL:  equ $2118 ; VRAM Data Write (Lower 8bit)                         2B/W
REG_VMDATAH:  equ $2119 ; VRAM Data Write (Upper 8bit)                         1B/W
REG_M7SEL:    equ $211A ; MODE7 Rot/Scale Mode Settings                        1B/W
REG_M7A:      equ $211B ; MODE7 Rot/Scale A (COSINE A) & Maths 16bit Operand   1B/W D
REG_M7B:      equ $211C ; MODE7 Rot/Scale B (SINE A)   & Maths  8bit Operand   1B/W D
REG_M7C:      equ $211D ; MODE7 Rot/Scale C (SINE B)                           1B/W D
REG_M7D:      equ $211E ; MODE7 Rot/Scale D (COSINE B)                         1B/W D
REG_M7X:      equ $211F ; MODE7 Rot/Scale Center Coordinate X                  1B/W D
REG_M7Y:      equ $2120 ; MODE7 Rot/Scale Center Coordinate Y                  1B/W D
REG_CGADD:    equ $2121 ; Palette CGRAM Address                                1B/W
REG_CGDATA:   equ $2122 ; Palette CGRAM Data Write                             1B/W D
REG_W12SEL:   equ $2123 ; Window BG1/BG2  Mask Settings                        1B/W
REG_W34SEL:   equ $2124 ; Window BG3/BG4  Mask Settings                        1B/W
REG_WOBJSEL:  equ $2125 ; Window OBJ/MATH Mask Settings                        1B/W
REG_WH0:      equ $2126 ; Window 1 Left  Position (X1)                         1B/W
REG_WH1:      equ $2127 ; Window 1 Right Position (X2)                         1B/W
REG_WH2:      equ $2128 ; Window 2 Left  Position (X1)                         1B/W
REG_WH3:      equ $2129 ; Window 2 Right Position (X2)                         1B/W
REG_WBGLOG:   equ $212A ; Window 1/2 Mask Logic (BG1-BG4)                      1B/W
REG_WOBJLOG:  equ $212B ; Window 1/2 Mask Logic (OBJ/MATH)                     1B/W
REG_TM:       equ $212C ; Main Screen Designation                              1B/W
REG_TS:       equ $212D ; Sub  Screen Designation                              1B/W
REG_TMW:      equ $212E ; Window Area Main Screen Disable                      1B/W
REG_TSW:      equ $212F ; Window Area Sub  Screen Disable                      1B/W
REG_CGWSEL:   equ $2130 ; Color Math Control Register A                        1B/W
REG_CGADSUB:  equ $2131 ; Color Math Control Register B                        1B/W
REG_COLDATA:  equ $2132 ; Color Math Sub Screen Backdrop Color                 1B/W
REG_SETINI:   equ $2133 ; Display Control 2                                    1B/W

; PPU Picture Processing Unit Ports (Read-Only)
REG_MPYL:     equ $2134 ; PPU1 Signed Multiply Result (Lower  8bit)            1B/R
REG_MPYM:     equ $2135 ; PPU1 Signed Multiply Result (Middle 8bit)            1B/R
REG_MPYH:     equ $2136 ; PPU1 Signed Multiply Result (Upper  8bit)            1B/R
REG_SLHV:     equ $2137 ; PPU1 Latch H/V-Counter By Software (Read=Strobe)     1B/R
REG_RDOAM:    equ $2138 ; PPU1 OAM  Data Read                                  1B/R D
REG_RDVRAML:  equ $2139 ; PPU1 VRAM  Data Read (Lower 8bits)                   1B/R
REG_RDVRAMH:  equ $213A ; PPU1 VRAM  Data Read (Upper 8bits)                   1B/R
REG_RDCGRAM:  equ $213B ; PPU2 CGRAM Data Read (Palette)                       1B/R D
REG_OPHCT:    equ $213C ; PPU2 Horizontal Counter Latch (Scanline X)           1B/R D
REG_OPVCT:    equ $213D ; PPU2 Vertical   Counter Latch (Scanline Y)           1B/R D
REG_STAT77:   equ $213E ; PPU1 Status & PPU1 Version Number                    1B/R
REG_STAT78:   equ $213F ; PPU2 Status & PPU2 Version Number (Bit 7=0)          1B/R

; APU Audio Processing Unit Ports (Read/Write)
REG_APUIO0:   equ $2140 ; Main CPU To Sound CPU Communication Port 0           1B/RW
REG_APUIO1:   equ $2141 ; Main CPU To Sound CPU Communication Port 1           1B/RW
REG_APUIO2:   equ $2142 ; Main CPU To Sound CPU Communication Port 2           1B/RW
REG_APUIO3:   equ $2143 ; Main CPU To Sound CPU Communication Port 3           1B/RW
; $2140..$2143 - APU Ports Mirrored To $2144..$217F

; WRAM Access Ports
REG_WMDATA:   equ $2180 ; WRAM Data Read/Write                                 1B/RW
REG_WMADDL:   equ $2181 ; WRAM Address (Lower  8bit)                           1B/W
REG_WMADDM:   equ $2182 ; WRAM Address (Middle 8bit)                           1B/W
REG_WMADDH:   equ $2183 ; WRAM Address (Upper  1bit)                           1B/W
; $2184..$21FF - Unused Region (Open Bus)/Expansion (B-Bus)
; $2200..$3FFF - Unused Region (A-Bus)

; CPU On-Chip I/O Ports (These Have Long Waitstates: 1.78MHz Cycles Instead Of 3.5MHz)
; $4000..$4015 - Unused Region (Open Bus)
REG_JOYWR:    equ $4016 ; Joypad Output                                        1B/W
REG_JOYA:     equ $4016 ; Joypad Input Register A (Joypad Auto Polling)        1B/R
REG_JOYB:     equ $4017 ; Joypad Input Register B (Joypad Auto Polling)        1B/R
; $4018..$41FF - Unused Region (Open Bus)

; CPU On-Chip I/O Ports (Write-only, Read=Open Bus)
REG_NMITIMEN: equ $4200 ; Interrupt Enable & Joypad Request                    1B/W
REG_WRIO:     equ $4201 ; Joypad Programmable I/O Port (Open-Collector Output) 1B/W
REG_WRMPYA:   equ $4202 ; Set Unsigned  8bit Multiplicand                      1B/W
REG_WRMPYB:   equ $4203 ; Set Unsigned  8bit Multiplier & Start Multiplication 1B/W
REG_WRDIVL:   equ $4204 ; Set Unsigned 16bit Dividend (Lower 8bit)             2B/W
REG_WRDIVH:   equ $4205 ; Set Unsigned 16bit Dividend (Upper 8bit)             1B/W
REG_WRDIVB:   equ $4206 ; Set Unsigned  8bit Divisor & Start Division          1B/W
REG_HTIMEL:   equ $4207 ; H-Count Timer Setting (Lower 8bits)                  2B/W
REG_HTIMEH:   equ $4208 ; H-Count Timer Setting (Upper 1bit)                   1B/W
REG_VTIMEL:   equ $4209 ; V-Count Timer Setting (Lower 8bits)                  2B/W
REG_VTIMEH:   equ $420A ; V-Count Timer Setting (Upper 1bit)                   1B/W
REG_MDMAEN:   equ $420B ; Select General Purpose DMA Channels & Start Transfer 1B/W
REG_HDMAEN:   equ $420C ; Select H-Blank DMA (H-DMA) Channels                  1B/W
REG_MEMSEL:   equ $420D ; Memory-2 Waitstate Control                           1B/W
; $420E..$420F - Unused Region (Open Bus)

; CPU On-Chip I/O Ports (Read-only)
REG_RDNMI:    equ $4210 ; V-Blank NMI Flag and CPU Version Number (Read/Ack)   1B/R
REG_TIMEUP:   equ $4211 ; H/V-Timer IRQ Flag (Read/Ack)                        1B/R
REG_HVBJOY:   equ $4212 ; H/V-Blank Flag & Joypad Busy Flag                    1B/R
REG_RDIO:     equ $4213 ; Joypad Programmable I/O Port (Input)                 1B/R
REG_RDDIVL:   equ $4214 ; Unsigned Div Result (Quotient) (Lower 8bit)          2B/R
REG_RDDIVH:   equ $4215 ; Unsigned Div Result (Quotient) (Upper 8bit)          1B/R
REG_RDMPYL:   equ $4216 ; Unsigned Div Remainder / Mul Product (Lower 8bit)    2B/R
REG_RDMPYH:   equ $4217 ; Unsigned Div Remainder / Mul Product (Upper 8bit)    1B/R
REG_JOY1L:    equ $4218 ; Joypad 1 (Gameport 1, Pin 4) (Lower 8bit)            2B/R
REG_JOY1H:    equ $4219 ; Joypad 1 (Gameport 1, Pin 4) (Upper 8bit)            1B/R
REG_JOY2L:    equ $421A ; Joypad 2 (Gameport 2, Pin 4) (Lower 8bit)            2B/R
REG_JOY2H:    equ $421B ; Joypad 2 (Gameport 2, Pin 4) (Upper 8bit)            1B/R
REG_JOY3L:    equ $421C ; Joypad 3 (Gameport 1, Pin 5) (Lower 8bit)            2B/R
REG_JOY3H:    equ $421D ; Joypad 3 (Gameport 1, Pin 5) (Upper 8bit)            1B/R
REG_JOY4L:    equ $421E ; Joypad 4 (Gameport 2, Pin 5) (Lower 8bit)            2B/R
REG_JOY4H:    equ $421F ; Joypad 4 (Gameport 2, Pin 5) (Upper 8bit)            1B/R
; $4220..$42FF - Unused Region (Open Bus)

; CPU DMA Ports (Read/Write) ($43XP X = Channel Number 0..7, P = Port)
REG_DMAP0:    equ $4300 ; DMA0 DMA/HDMA Parameters                             1B/RW
REG_BBAD0:    equ $4301 ; DMA0 DMA/HDMA I/O-Bus Address (PPU-Bus AKA B-Bus)    1B/RW
REG_A1T0L:    equ $4302 ; DMA0 DMA/HDMA Table Start Address (Lower 8bit)       2B/RW
REG_A1T0H:    equ $4303 ; DMA0 DMA/HDMA Table Start Address (Upper 8bit)       1B/RW
REG_A1B0:     equ $4304 ; DMA0 DMA/HDMA Table Start Address (Bank)             1B/RW
REG_DAS0L:    equ $4305 ; DMA0 DMA Count / Indirect HDMA Address (Lower 8bit)  2B/RW
REG_DAS0H:    equ $4306 ; DMA0 DMA Count / Indirect HDMA Address (Upper 8bit)  1B/RW
REG_DASB0:    equ $4307 ; DMA0 Indirect HDMA Address (Bank)                    1B/RW
REG_A2A0L:    equ $4308 ; DMA0 HDMA Table Current Address (Lower 8bit)         2B/RW
REG_A2A0H:    equ $4309 ; DMA0 HDMA Table Current Address (Upper 8bit)         1B/RW
REG_NTRL0:    equ $430A ; DMA0 HDMA Line-Counter (From Current Table entry)    1B/RW
REG_UNUSED0:  equ $430B ; DMA0 Unused Byte                                     1B/RW
; $430C..$430E - Unused Region (Open Bus)
REG_MIRR0:    equ $430F ; DMA0 Mirror Of $430B                                 1B/RW

REG_DMAP1:    equ $4310 ; DMA1 DMA/HDMA Parameters                             1B/RW
REG_BBAD1:    equ $4311 ; DMA1 DMA/HDMA I/O-Bus Address (PPU-Bus AKA B-Bus)    1B/RW
REG_A1T1L:    equ $4312 ; DMA1 DMA/HDMA Table Start Address (Lower 8bit)       2B/RW
REG_A1T1H:    equ $4313 ; DMA1 DMA/HDMA Table Start Address (Upper 8bit)       1B/RW
REG_A1B1:     equ $4314 ; DMA1 DMA/HDMA Table Start Address (Bank)             1B/RW
REG_DAS1L:    equ $4315 ; DMA1 DMA Count / Indirect HDMA Address (Lower 8bit)  2B/RW
REG_DAS1H:    equ $4316 ; DMA1 DMA Count / Indirect HDMA Address (Upper 8bit)  1B/RW
REG_DASB1:    equ $4317 ; DMA1 Indirect HDMA Address (Bank)                    1B/RW
REG_A2A1L:    equ $4318 ; DMA1 HDMA Table Current Address (Lower 8bit)         2B/RW
REG_A2A1H:    equ $4319 ; DMA1 HDMA Table Current Address (Upper 8bit)         1B/RW
REG_NTRL1:    equ $431A ; DMA1 HDMA Line-Counter (From Current Table entry)    1B/RW
REG_UNUSED1:  equ $431B ; DMA1 Unused Byte                                     1B/RW
; $431C..$431E - Unused Region (Open Bus)
REG_MIRR1:    equ $431F ; DMA1 Mirror Of $431B                                 1B/RW

REG_DMAP2:    equ $4320 ; DMA2 DMA/HDMA Parameters                             1B/RW
REG_BBAD2:    equ $4321 ; DMA2 DMA/HDMA I/O-Bus Address (PPU-Bus AKA B-Bus)    1B/RW
REG_A1T2L:    equ $4322 ; DMA2 DMA/HDMA Table Start Address (Lower 8bit)       2B/RW
REG_A1T2H:    equ $4323 ; DMA2 DMA/HDMA Table Start Address (Upper 8bit)       1B/RW
REG_A1B2:     equ $4324 ; DMA2 DMA/HDMA Table Start Address (Bank)             1B/RW
REG_DAS2L:    equ $4325 ; DMA2 DMA Count / Indirect HDMA Address (Lower 8bit)  2B/RW
REG_DAS2H:    equ $4326 ; DMA2 DMA Count / Indirect HDMA Address (Upper 8bit)  1B/RW
REG_DASB2:    equ $4327 ; DMA2 Indirect HDMA Address (Bank)                    1B/RW
REG_A2A2L:    equ $4328 ; DMA2 HDMA Table Current Address (Lower 8bit)         2B/RW
REG_A2A2H:    equ $4329 ; DMA2 HDMA Table Current Address (Upper 8bit)         1B/RW
REG_NTRL2:    equ $432A ; DMA2 HDMA Line-Counter (From Current Table entry)    1B/RW
REG_UNUSED2:  equ $432B ; DMA2 Unused Byte                                     1B/RW
; $432C..$432E - Unused Region (Open Bus)
REG_MIRR2:    equ $432F ; DMA2 Mirror Of $432B                                 1B/RW

REG_DMAP3:    equ $4330 ; DMA3 DMA/HDMA Parameters                             1B/RW
REG_BBAD3:    equ $4331 ; DMA3 DMA/HDMA I/O-Bus Address (PPU-Bus AKA B-Bus)    1B/RW
REG_A1T3L:    equ $4332 ; DMA3 DMA/HDMA Table Start Address (Lower 8bit)       2B/RW
REG_A1T3H:    equ $4333 ; DMA3 DMA/HDMA Table Start Address (Upper 8bit)       1B/RW
REG_A1B3:     equ $4334 ; DMA3 DMA/HDMA Table Start Address (Bank)             1B/RW
REG_DAS3L:    equ $4335 ; DMA3 DMA Count / Indirect HDMA Address (Lower 8bit)  2B/RW
REG_DAS3H:    equ $4336 ; DMA3 DMA Count / Indirect HDMA Address (Upper 8bit)  1B/RW
REG_DASB3:    equ $4337 ; DMA3 Indirect HDMA Address (Bank)                    1B/RW
REG_A2A3L:    equ $4338 ; DMA3 HDMA Table Current Address (Lower 8bit)         2B/RW
REG_A2A3H:    equ $4339 ; DMA3 HDMA Table Current Address (Upper 8bit)         1B/RW
REG_NTRL3:    equ $433A ; DMA3 HDMA Line-Counter (From Current Table entry)    1B/RW
REG_UNUSED3:  equ $433B ; DMA3 Unused Byte                                     1B/RW
; $433C..$433E - Unused Region (Open Bus)
REG_MIRR3:    equ $433F ; DMA3 Mirror Of $433B                                 1B/RW

REG_DMAP4:    equ $4340 ; DMA4 DMA/HDMA Parameters                             1B/RW
REG_BBAD4:    equ $4341 ; DMA4 DMA/HDMA I/O-Bus Address (PPU-Bus AKA B-Bus)    1B/RW
REG_A1T4L:    equ $4342 ; DMA4 DMA/HDMA Table Start Address (Lower 8bit)       2B/RW
REG_A1T4H:    equ $4343 ; DMA4 DMA/HDMA Table Start Address (Upper 8bit)       1B/RW
REG_A1B4:     equ $4344 ; DMA4 DMA/HDMA Table Start Address (Bank)             1B/RW
REG_DAS4L:    equ $4345 ; DMA4 DMA Count / Indirect HDMA Address (Lower 8bit)  2B/RW
REG_DAS4H:    equ $4346 ; DMA4 DMA Count / Indirect HDMA Address (Upper 8bit)  1B/RW
REG_DASB4:    equ $4347 ; DMA4 Indirect HDMA Address (Bank)                    1B/RW
REG_A2A4L:    equ $4348 ; DMA4 HDMA Table Current Address (Lower 8bit)         2B/RW
REG_A2A4H:    equ $4349 ; DMA4 HDMA Table Current Address (Upper 8bit)         1B/RW
REG_NTRL4:    equ $434A ; DMA4 HDMA Line-Counter (From Current Table entry)    1B/RW
REG_UNUSED4:  equ $434B ; DMA4 Unused Byte                                     1B/RW
; $434C..$434E - Unused Region (Open Bus)
REG_MIRR4:    equ $434F ; DMA4 Mirror Of $434B                                 1B/RW

REG_DMAP5:    equ $4350 ; DMA5 DMA/HDMA Parameters                             1B/RW
REG_BBAD5:    equ $4351 ; DMA5 DMA/HDMA I/O-Bus Address (PPU-Bus AKA B-Bus)    1B/RW
REG_A1T5L:    equ $4352 ; DMA5 DMA/HDMA Table Start Address (Lower 8bit)       2B/RW
REG_A1T5H:    equ $4353 ; DMA5 DMA/HDMA Table Start Address (Upper 8bit)       1B/RW
REG_A1B5:     equ $4354 ; DMA5 DMA/HDMA Table Start Address (Bank)             1B/RW
REG_DAS5L:    equ $4355 ; DMA5 DMA Count / Indirect HDMA Address (Lower 8bit)  2B/RW
REG_DAS5H:    equ $4356 ; DMA5 DMA Count / Indirect HDMA Address (Upper 8bit)  1B/RW
REG_DASB5:    equ $4357 ; DMA5 Indirect HDMA Address (Bank)                    1B/RW
REG_A2A5L:    equ $4358 ; DMA5 HDMA Table Current Address (Lower 8bit)         2B/RW
REG_A2A5H:    equ $4359 ; DMA5 HDMA Table Current Address (Upper 8bit)         1B/RW
REG_NTRL5:    equ $435A ; DMA5 HDMA Line-Counter (From Current Table entry)    1B/RW
REG_UNUSED5:  equ $435B ; DMA5 Unused Byte                                     1B/RW
; $435C..$435E - Unused Region (Open Bus)
REG_MIRR5:    equ $435F ; DMA5 Mirror Of $435B                                 1B/RW

REG_DMAP6:    equ $4360 ; DMA6 DMA/HDMA Parameters                             1B/RW
REG_BBAD6:    equ $4361 ; DMA6 DMA/HDMA I/O-Bus Address (PPU-Bus AKA B-Bus)    1B/RW
REG_A1T6L:    equ $4362 ; DMA6 DMA/HDMA Table Start Address (Lower 8bit)       2B/RW
REG_A1T6H:    equ $4363 ; DMA6 DMA/HDMA Table Start Address (Upper 8bit)       1B/RW
REG_A1B6:     equ $4364 ; DMA6 DMA/HDMA Table Start Address (Bank)             1B/RW
REG_DAS6L:    equ $4365 ; DMA6 DMA Count / Indirect HDMA Address (Lower 8bit)  2B/RW
REG_DAS6H:    equ $4366 ; DMA6 DMA Count / Indirect HDMA Address (Upper 8bit)  1B/RW
REG_DASB6:    equ $4367 ; DMA6 Indirect HDMA Address (Bank)                    1B/RW
REG_A2A6L:    equ $4368 ; DMA6 HDMA Table Current Address (Lower 8bit)         2B/RW
REG_A2A6H:    equ $4369 ; DMA6 HDMA Table Current Address (Upper 8bit)         1B/RW
REG_NTRL6:    equ $436A ; DMA6 HDMA Line-Counter (From Current Table entry)    1B/RW
REG_UNUSED6:  equ $436B ; DMA6 Unused Byte                                     1B/RW
; $436C..$436E - Unused Region (Open Bus)
REG_MIRR6:    equ $436F ; DMA6 Mirror Of $436B                                 1B/RW

REG_DMAP7:    equ $4370 ; DMA7 DMA/HDMA Parameters                             1B/RW
REG_BBAD7:    equ $4371 ; DMA7 DMA/HDMA I/O-Bus Address (PPU-Bus AKA B-Bus)    1B/RW
REG_A1T7L:    equ $4372 ; DMA7 DMA/HDMA Table Start Address (Lower 8bit)       2B/RW
REG_A1T7H:    equ $4373 ; DMA7 DMA/HDMA Table Start Address (Upper 8bit)       1B/RW
REG_A1B7:     equ $4374 ; DMA7 DMA/HDMA Table Start Address (Bank)             1B/RW
REG_DAS7L:    equ $4375 ; DMA7 DMA Count / Indirect HDMA Address (Lower 8bit)  2B/RW
REG_DAS7H:    equ $4376 ; DMA7 DMA Count / Indirect HDMA Address (Upper 8bit)  1B/RW
REG_DASB7:    equ $4377 ; DMA7 Indirect HDMA Address (Bank)                    1B/RW
REG_A2A7L:    equ $4378 ; DMA7 HDMA Table Current Address (Lower 8bit)         2B/RW
REG_A2A7H:    equ $4379 ; DMA7 HDMA Table Current Address (Upper 8bit)         1B/RW
REG_NTRL7:    equ $437A ; DMA7 HDMA Line-Counter (From Current Table entry)    1B/RW
REG_UNUSED7:  equ $437B ; DMA7 Unused Byte                                     1B/RW
; $437C..$437E - Unused Region (Open Bus)
REG_MIRR7:    equ $437F ; DMA7 Mirror Of $437B                                 1B/RW
; $4380..$5FFF - Unused Region (Open Bus)

; Further Memory
; $6000..$7FFF - Expansion (Battery Backed RAM, In HiROM Cartridges)
; $8000..$FFFF - Cartridge ROM

; $000000..$3FFFFF - WS1 LoROM (max 2048 Kbytes) (64x32K) plus System Area
; $400000..$7DFFFF - WS1 HiROM (max 3968 Kbytes) (62x64K)
; $7E0000..$7FFFFF - WRAM (Work RAM, 128 Kbytes) (2x64K)
; $800000..$BFFFFF - WS2 LoROM (max 2048 Kbytes) (64x32K) plus System Area
; $C00000..$FFFFFF - WS2 HiROM (max 4096 Kbytes) (64x64K)

; $00FFE0..$00FFFF - CPU Exception Vectors (Reset, Irq, Nmi, etc.)
; $00FFE0..$00FFEF - NATIVE VECTOR (65C816 Mode)
; $00FFE0..$00FFE1 - RESERVED
; $00FFE2..$00FFE3 - RESERVED
COP1_VEC:     equ $FFE4 ; COP VECTOR   (COP Opcode)
BRK1_VEC:     equ $FFE6 ; BRK VECTOR   (BRK Opcode)
ABT1_VEC:     equ $FFE8 ; ABORT VECTOR (Unused)
NMI1_VEC:     equ $FFEA ; NMI VECTOR   (V-Blank Interrupt)
RES1_VEC:     equ $FFEC ; RESET VECTOR (Unused)
IRQ1_VEC:     equ $FFEE ; IRQ VECTOR   (H/V-Timer/External Interrupt)
; $00FFF0..$00FFFF - EMU VECTOR (6502 Mode)
; $00FFF0..$00FFF1 - RESERVED
; $00FFF2..$00FFF3 - RESERVED
COP2_VEC:     equ $FFF4 ; COP VECTOR   (COP Opcode)
BRK2_VEC:     equ $FFF6 ; BRK VECTOR   (Unused)
ABT2_VEC:     equ $FFF8 ; ABORT VECTOR (Unused)
NMI2_VEC:     equ $FFFA ; NMI VECTOR   (V-Blank Interrupt)
RES2_VEC:     equ $FFFC ; RESET VECTOR (CPU is always in 6502 mode on RESET)
IRQ2_VEC:     equ $FFFE ; IRQ/BRK VECTOR