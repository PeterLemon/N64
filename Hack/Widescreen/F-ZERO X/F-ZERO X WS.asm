// N64 "F-ZERO X" Widescreen Hack by gamemasterplc (Requires Expansion Pak 8MB RDRAM):

arch n64.cpu
endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "F-ZERO X WS.z64", create
origin $00000000; insert "F-ZERO X (U) [!].z64" // Include USA F-Zero X ROM
origin $00000020
db "F-ZERO X WS                " // $00000020 - PROGRAM TITLE (27 Byte ASCII String, Use Spaces For Unused Bytes)

include "LIB/N64.INC" // Include N64 Definitions

origin $000018C8
lui t7, 0x8040 //Framebuffer 2 Address

origin $000018CC
lui t8, 0x8043 //Framebuffer 3 Address Upper-Half

origin $000018E0
addiu t8, t8, 0x1EC0 //Framebuffer 3 Address Lower-Half

origin $00002658
addiu t6, r0, 0
li a0, commonfileaddr //Address of common.bin in ROM
li t7, commonfileend //End of common.bin in ROM

origin $00002694
nop //Skip Decompression of common.bin

origin $00003FB8
ori at, r0, 59938 //Framebuffer Offset for N64 Logo DMA

origin $00003FEC
addiu s0, s0, 852 //Offset Between Framebuffer Lines for N64 Logo DMA

origin $00014454
slti at, a1, 426 //Max X Position of Left Edge of Menu Fill Rectangles

origin $000144B0
slti at, a3, 427 //Max X Position of Right Edge of Menu Fill Rectangles+1

origin $000144C4
addiu a3, r0, 426 //Clamping X Position of Menu Fill Rectangles

origin $00014D1C
lui t5, 0 //Upper-Left of Car Configuration Screen Background
lui t4, 0xF66A //Fill Rectangle Command Upper-Half for Car Configuration Screen Background
ori t4, t4, 0x43BC //Fill Rectangle Command Lower-Half for Car Configuration Screen Background
ori t5, t5, 0 //Upper-Left of Car Configuration Screen Background

origin $00014C10
ori t3, t3, 425 //Menu Framebuffer Width-1

origin $0001D4D0
lui t2, 0xED00 //1P Game Scissor Left Edge X is 0
li t3, 0x6A83C0 //1P Game Scissor Size is 426x240
ori t2, t2, 0 //1P Game Scissor Top Edge Y is 0

origin $0001FD04
lui at, 0x42E7 //2P Level Intro FOV

origin $0001FD50
lui at, 0x43D5 //Camera Y-FOV

origin $0001FDB8
lui at ,0x43D5 //Demo 2-Player Camera Y-FOV

origin $0001FE1C
lui at, 0x43D5 //Demo Camera Y-FOV

origin $000201D8
lui at, 0x43D5 //Records Screen Camera Y-FOV

origin $00020310
lui at, 0x43D5 //GP End Camera Y-FOV

origin $00021140
lui at, 0 //Leftmost X Position of Destinaiton of Player 1 Viewport at End of 3/4 Player Race

origin $00021150
lui at, 0 //Leftmost X Position of Destinaiton of Player 2 Viewport at End of 3/4 Player Race

origin $0002115C
lui at, 0 //Leftmost X Position of Destinaiton of Player 3 Viewport at End of 3/4 Player Race

origin $00021164
lui at, 0 //Leftmost X Position of Destinaiton of Player 4 Viewport at End of 3/4 Player Race

origin $00021174
lui at, 0 //Topmost Y Position of Destinaiton of Player 1 Viewport at End of 3/4 Player Race

origin $00021184
lui at, 0x4370 //Bottommost Y Position of Destinaiton of Player 1 Viewport at End of 3/4 Player Race

origin $0002118C
lui at, 0x4355 //Middle X Position of Destinaiton of Player 1 Viewport at End of 3/4 Player Race

origin $000211A8
lui at, 0x43D5 //Rightmost X Position of Destinaiton of Player 1 Viewport at End of 3/4 Player Race

origin $0002123C
lui at, 0 //Topmost Y Position of Destinaiton of Player 2 Viewport at End of 3/4 Player Race

origin $0002124C
lui at, 0x4370 //Bottommost Y Position of Destinaiton of Player 2 Viewport at End of 3/4 Player Races

origin $00021254
lui at, 0x4355 //Middle X Position of Destinaiton of Player 2 Viewport at End of 3/4 Player Races

origin $00021268
lui at, 0x43D5 //Rightmost X Position of Destinaiton of Player 2 Viewport at End of 3/4 Player Races

origin $00021300
lui at, 0 //Topmost Y Position of Destinaiton of Player 3 Viewport at End of 3/4 Player Race

origin $00021310
lui at, 0x4370 //Bottommost Y Position of Destinaiton of Player 3 Viewport at End of 3/4 Player Race

origin $00021318
lui at, 0x4355 //Middle X Position of Destinaiton of Player 3 Viewport at End of 3/4 Player Race

origin $000213BC
lui at, 0 //Topmost Y Position of Destinaiton of Player 4 Viewport at End of 3/4 Player Race

origin $000213CC
lui at, 0x4370 //Bottommost Y Position of Destinaiton of Player 4 Viewport at End of 3/4 Player Race

origin $000213D4
lui at, 0x4355 //Middle X Position of Destinaiton of Player 4 Viewport at End of 3/4 Player Race

origin $000679C0
dw 0 //Fades/Check Left Edge Scissor
dw 0 //Fades/Check Top Edge Scissor
dw 426 //Fades/Check Right Edge Scissor
dw 240 //Fades/Check Bottom Edge Scissor
dw 0 //Player 1 Viewport 2 Player Mode Left Edge Scissor
dw 0 //Player 1 Viewport 2 Player Mode Top Edge Scissor
dw 426 //Player 1 Viewport 2 Player Mode Right Edge Scissor
dw 119 //Player 1 Viewport 2 Player Mode Bottom Edge Scissor
dw 0 //Player 2 Viewport 2 Player Mode Left Edge Scissor
dw 120 //Player 2 Viewport 2 Player Mode Top Edge Scissor
dw 426 //Player 2 Viewport 2 Player Mode Right Edge Scissor
dw 240 //Player 2 Viewport 2 Player Mode Bottom Edge Scissor

origin $00067A10
dw 0 //Player 1 Viewport 4 Player Mode Left Edge Scissor
dw 0 //Player 1 Viewport 4 Player Mode Top Edge Scissor
dw 212 //Player 1 Viewport 4 Player Mode Right Edge Scissor
dw 119 //Player 1 Viewport 4 Player Mode Bottom Edge Scissor
dw 213 //Player 2 Viewport 4 Player Mode Left Edge Scissor
dw 0 //Player 2 Viewport 4 Player Mode Top Edge Scissor
dw 426 //Player 2 Viewport 4 Player Mode Right Edge Scissor
dw 119 //Player 2 Viewport 4 Player Mode Bottom Edge Scissor
dw 0 //Player 3 Viewport 4 Player Mode Left Edge Scissor
dw 120 //Player 3 Viewport 4 Player Mode Top Edge Scissor
dw 212 //Player 3 Viewport 4 Player Mode Right Edge Scissor
dw 240 //Player 3 Viewport 4 Player Mode Bottom Edge Scissor
dw 213 //Player 4 Viewport 4 Player Mode Left Edge Scissor
dw 120 //Player 4 Viewport 4 Player Mode Top Edge Scissor
dw 426 //Player 4 Viewport 4 Player Mode Right Edge Scissor
dw 240 //Player 4 Viewport 4 Player Mode Bottom Edge Scissor

origin $0006BDA8
dw 426 //VI_WIDTH for NTSC Video Mode

origin $0006BDC0
dw 680 //VI_X_SCALE for NTSC Video Mode

origin $0006BDC8
dw 852 //VI Framebuffer Offset for NTSC Video Mode

origin $0006C668
dw 426 //VI_WIDTH for MPAL Video Mode

origin $0006C680
dw 680 //VI_X_SCALE for MPAL Video Mode

origin $0006C688
dw 852 //VI Framebuffer Offset for MPAL Video Mode

origin $0006F284
float32 91.3085 //FOV of Intro Race Cutscene

origin $0006F2F8
float32 96.4183 //FOV of 1 Player Overhead Camera View

origin $0006F304
float32 93.368 //FOV of 1 Player Near Car Camera View

origin $0006F310
float32 93.368 //FOV of 1 Player Low Angle Camera View

origin $0006F31C
float32 115.634 //FOV of 1 Player Medium Angle Camera View

origin $0006F328
float32 115.634 //FOV of Multiplayer Overhead Camera View

origin $0006F334
float32 106.26 //FOV of Multiplayer Near Car Camera View

origin $0006F340
float32 115.634 //FOV of Multiplayer Low Angle Camera View

origin $0006F34C
float32 124.587 //FOV of Multiplayer Medium Angle Camera View

origin $0006F750
float32 426 //Player 1 Viewport Right Edge at End of 3P/4P Race
float32 426 //Player 2 Viewport Right Edge at End of 3P/4P Race
float32 426 //Player 3 Viewport Right Edge at End of 3P/4P Race
float32 426 //Player 4 Viewport Right Edge at End of 3P/4P Race

origin $000981A0
addiu a1, r0, 5 //Replace Distorted Fade-outs with Simple Fade-outs

origin $0009825C
addiu a1, r0, 5 //Replace Blocky Fade-outs with Simple Fade-outs

origin $000983A8
addiu a1, r0, 5 //Replace Blocky Fade-ins with Simple Fade-ins

origin $00098410
addiu a1, r0, 5 //Replace Distorted Move Down Fade-ins with Simple Fade-ins

origin $0009844C
addiu a1, r0, 5 //Replace Distorted Move Down Fade-outs with Simple Fade-outs

origin $0009845C
addiu a1, r0, 5 //Replace Distorted Fade-ins with Simple Fade-ins

origin $0009848C
addiu a1, r0, 5 //Replace Distorted Move Left Fade-ins with Simple Fade-ins

origin $0009B2F4
lui t7, 0 //Upper-Left X of Fade is 0
lui t4, 0xF66A //Upper-Half of Fill Rectangle Command for Fade

origin $0009B300
ori t4, t4, 0x83C0 //Lower-Half of Fill Rectangle Command for Fade
ori t7, t7, 0 //Upper-Left Y of Fade is 0

origin $0009F770
ori t3, t3, 425 //Framebuffer Width for Ingame-1

origin $0009FA98
ori t2, t2, 425 //Framebuffer Width for Ingame-1

origin $000A64B0
dw 5 //Replace Random Fade Type 1 with Random Fade Type 5
dw 6 //Replace Random Fade Type 2 with Random Fade Type 6
dw 5 //Replace Random Fade Type 3 with Random Fade Type 5
dw 6 //Replace Random Fade Type 4 with Random Fade Type 6

origin $000A64C8
dw 5 //Replace Random Fade Type 7 with Random Fade Type 5

origin $000B0C30
li t5, 0x6A83C0 //Lower-Right of Blank Colored Time Scissor is (426,240)
li t4, 0xED000000 //Blank Colored Time Scissor Command

origin $000B0EDC
li t6, 0x6A83C0 //Lower-Right of Colored Time Scissor is (426,240)
li t5, 0xED000000 //Colored Time Scissor Command

origin $000B1050
li t6, 0xED000000 //Time Trial End Race Screen Scissor Command
li t7, 0x6A83C0 //Lower-Right of Time Trial End Race Screen Scissor is (426,240)

origin $000B2000
li t6, 0xED000000 //Grand Prix End Race Screen Scissor Command
li t7, 0x6A83C0 //Lower-Right of Grand Prix End Race Screen Scissor is (426,240)

origin $000B2100
addiu s3, s3, 98 //X Position of Place Icons at End of Grand Prix Race

origin $000B223C
addiu s3, r0, 98 //X Position of Place Icons at End of Grand Prix Race

origin $000B2DC4
addiu t6, r0, 302 //X Position of Time Statistics for This Race at End of Grand Prix Race

origin $000B32BC
li t8, 0xED000000 //Winner Text Scissor Command
li t9, 0x6A83C0 //Lower-Right of Winner Text Scissor is (426,240)
mtc1 a3, f12 //Add Back Replaced Opcode

origin $000B37A4
addiu v0, r0, 153 //Starting X Position of Winner Text in 2-Player Mode

origin $000B37AC
addiu a3, r0, 316 //Destination X Position of Winner Text in 2-Player Mode

origin $000B381C
addiu v0, r0, 69 //Starting X Position of Winner Text for Player 3 in 3-Player Mode

origin $000B3824
addiu v0, r0, 262 //Starting X Position of Winner Text for Player 2 in 3-Player Mode

origin $000B3838
addiu v0, r0, 69 //Starting X Position of Winner Text for Player 1 in 3-Player Mode

origin $000B3888
addiu a3, v0, 80 //Destination X Offset of Winner Text in 3-Player Mode

origin $000B38A4
addiu v0, r0, 69 //Starting X Position of Winner Text for Player 3 in 4-Player Mode

origin $000B38AC
addiu v0, r0, 262 //Starting X Position of Winner Text for Player 2 in 4-Player Mode

origin $000B38B4
addiu v0, r0, 262 //Starting X Position of Winner Text for Player 4 in 4-Player Mode

origin $000B38C0
addiu v0, r0, 69 //Starting X Position of Winner Text for Player 1 in 4-Player Mode

origin $000B3910
addiu a3, v0, 80 //Destination X Offset of Winner Text in 4-Player Mode

origin $000B4030
li t8, 0xED000000 //Final Lap Text Scissor Command
li t9, 0x6A83C0 //Lower-Right of Final Lap Text Scissor is (426,240)
mtc1 a3, f12 //Add Back Replaced Opcode

origin $000B4494
addiu t6, r0, 153 //X Position of Final Lap Text in 1-Player Mode

origin $000B44B0
addiu t8, r0, 153 //X Position of Final Lap Text in 2-Player Mode

origin $000B44EC
addiu t1, r0, 69 //X Position of Booster OK Text for Player 1 in 3/4 Player Mode

origin $000B44FC
addiu t3, r0, 69 //X Position of Booster OK Text for Player 3 in 3/4 Player Mode

origin $000B4504
addiu t5, r0, 262 //X Position of Booster OK Text for Player 2 in 3/4 Player Mode

origin $000B450C
addiu t7, r0, 262 //X Position of Booster OK Text for Player 4 in 3/4 Player Mode

origin $000B45D4
li t8, 0xED000000 //Booster OK Text Scissor Command
li t9, 0x6A83C0 //Lower-Right of Booster OK Text Scissor is (426,240)

origin $000B49DC
addiu t6, r0, 173 //X Position of Booster OK Text in 1-Player Mode

origin $000B49F8
addiu t8, r0, 173 //X Position of Booster OK Text in 2-Player Mode

origin $000B4A34
addiu t1, r0, 69 //X Position of Booster OK Text for Player 1 in 3/4 Player Mode

origin $000B4A44
addiu t3, r0, 69 //X Position of Booster OK Text for Player 3 in 3/4 Player Mode

origin $000B4A4C
addiu t5, r0, 272 //X Position of Booster OK Text for Player 2 in 3/4 Player Mode

origin $000B4A54
addiu t7, r0, 272 //X Position of Booster OK Text for Player 4 in 3/4 Player Mode

origin $000B52A8
li t8, 0xED000000 //Game Over Screen Scissor Command
li t9, 0x6A83C0 //Lower-Right of Game Over Screen Scissor is (426,240)

origin $000B52CC
addiu t1, r0, 0 //Top of Game Over Screen Fade

origin $000B52D8
lui ra, 0 //Left Edge of Game Over Screen Fade

origin $000B52DC
lui t5, 0xE46B //Game Over Fadeout Texrect Right is 428

origin $000B541C
addiu at, r0, 240 //Game Over Fadeout is 240 Pixels Tall

origin $000B6E40
addiu t8, v0, 311 //X Position of Scissor Start for Time Trial End Race Options

origin $000B6E60
addiu a1, r0, 316 //X Position of Left Edge of Rectangle Rounding for Time Trial End Race Options

origin $000B6E70
addiu a3, r0, 406 //X Position of Right Edge of Rectangle Rounding for Time Trial End Race Options

origin $000B6EA4
addiu t3, r0, 411 //X Position of Left Edge of Rectangle for Time Trial End Race Options
addiu t9, r0, 331 //X Position of Right Edge of Rectangle for Time Trial End Race Options

origin $000B6FCC
addiu a2, r0, 336 //X Position of Retry Option for Time Trial End Race Options

origin $000B7050
addiu a2, r0, 336 //X Position of Ghost Save Option for Time Trial End Race Options

origin $000B7078
addiu a2, r0, 336 //X Position of Settings Option for Time Trial End Race Options

origin $000B70A0
addiu a2, r0, 336 //X Position of Change Machine Option for Time Trial End Race Options

origin $000B70C8
addiu a2, r0, 336 //X Position of Change Course Option for Time Trial End Race Options

origin $000B70F0
addiu a2, r0, 336 //X Position of Exit Option for Time Trial End Race Options

origin $000B717C
addiu a1, r0, 321 //X Position of Arrow for Time Trial End Race Options

origin $000B7C44
addiu t8, v0, 311 //X Position of Left Edge of Scissor for Retire Race Options

origin $000B7C64
addiu a1, r0, 316 //X Position of Left Edge of Box for Retire Race Options

origin $000B7C74
addiu a3, r0, 406 //X Position of Right Edge of Box for Retire Race Options

origin $000B7CA8
addiu t3, r0, 411 //X Position of Right Edge of Scissor for Retire Race Options

origin $000B7DD4
addiu a2, r0, 336 //X Position of Retry Option in the Retire Race Options

origin $000B7DFC
addiu a2, r0, 336 //X Position of Settings Option in the Retire Race Options

origin $000B7E24
addiu a2, r0, 336 //X Position of Quit Option in the Retire Race Options

origin $000B7E4C
addiu a2, r0, 336 //X Position of Change Machine Option in the Retire Race Options

origin $000B7E74
addiu a2, r0, 336 //X Position of Change Course Option in the Retire Race Options

origin $000B7EE4
addiu a1, r0, 321 //X Position of Arrow in the Retire Race Options

origin $000B8208
addiu t8, v0, 311 //X Position of Left Edge of Scissor for Death Race Options

origin $000B8268
addiu t1, r0, 411 //X Position of Right Edge of Scissor for Death Race Options

origin $000B82E0
addiu a1, r0, 316 //X Position of Left Edge of Death Race Options Box
addiu a2, r0, 137 //Y Position of Top Edge of Death Race Options Box
addiu a3, r0, 406 //X Position of Right Edge of Death Race Options Box

origin $000B83FC
addiu a2, r0, 336 //X Position of Retry Text in Death Race Options

origin $000B8424
addiu a2, r0, 336 //X Position of Settings Text in Death Race Options

origin $000B844C
addiu a2, r0, 336 //X Position of Change Machine Text in Death Race Options

origin $000B8474
addiu a2, r0, 336 //X Position of Quit Text in Death Race Options

origin $000B84E4
addiu a1, r0, 321 //X Position of Arrow in Death Race Options

origin $000B87A4
addiu t8, v0, 153 //X Position of Pause Menu Left Edge of Scissor

origin $000B87C4
addiu a1, r0, 173 //X Position of Left Edge of Pause Menu Box

origin $000B87D4
addiu a3, r0, 263 //X Position of Right Edge of Pause Menu Box

origin $000B8808
addiu t3, r0, 283 //X Position of Pause Menu Right Edge of Scissor

origin $000B8930
addiu a2, r0, 193 //X Position of Continue Option in Pause Menu

origin $000B8958
addiu a2, r0, 193 //X Position of Retry Option in Pause Menu

origin $000B8980
addiu a2, r0, 193 //X Position of Settings Option in Pause Menu

origin $000B89A8
addiu a2, r0, 193 //X Position of Quit Option in Pause Menu

origin $000B89D0
addiu a2, r0, 193 //X Position of Change Machine Option in Pause Menu

origin $000B89F8
addiu a2, r0, 193 //X Position of Change Course Option in Pause Menu

origin $000B8A68
addiu a1, r0, 178 //X Position of Arrow in Pause Menu

origin $000B8AB4
addiu t6, r0, 219 //X Position of Pause Text Shadow in Pause Menu

origin $000B8B2C
addiu t6, r0, 218 //X Position of Pause Text in Pause Menu

origin $000B8F4C
addiu t8, v0, 153 //X Position of Death Race Pause Menu Left Edge of Scissor

origin $000B8F6C
addiu a1, r0, 173 //X Position of Left Edge of Death Race Pause Menu Box

origin $000B8F7C
addiu a3, r0, 263 //X Position of Right Edge of Death Race Pause Menu Box

origin $000B8FB0
addiu t3, r0, 283 //X Position of Death Race Pause Menu Right Edge of Scissor

origin $000B90D8
addiu a2, r0, 193 //X Position of Continue Option in Death Race Pause Menu

origin $000B9100
addiu a2, r0, 193 //X Position of Retry Option in Death Race Pause Menu

origin $000B9128
addiu a2, r0, 193 //X Position of Settings Option in Death Race Pause Menu

origin $000B9150
addiu a2, r0, 193 //X Position of Quit Option in Death Race Pause Menu

origin $000B9178
addiu a2, r0, 193 //X Position of Change Machine Option in Death Race Pause Menu

origin $000B91E8
addiu a1, r0, 178 //X Position of Arrow in Death Race Pause Menu

origin $000B9234
addiu t6, r0, 219 //X Position of Pause Text Shadow in Death Race Pause Menu

origin $000B92AC
addiu t6, r0, 218 //X Position of Pause Text in Death Race Pause Menu

origin $000B9648
addiu t8, v0, 153 //X Position of Left Edge of Scissor for Grand Prix Pause Menu

origin $000B9668
addiu a1, r0, 173 //X Position of Left Edge of Box for Grand Prix Pause Menu

origin $000B9678
addiu a3, r0, 253 //X Position of Right Edge of Box for Grand Prix Pause Menu

origin $000B96AC
addiu t3, r0, 273 //X Position of Right Edge of Scissor for Grand Prix Pause Menu

origin $000B97D4
addiu a2, r0, 193 //X Position of Continue Option in Grand Prix Pause Menu

origin $000B9844
addiu a2, r0, 193 //X Position of Retry Option in Grand Prix Pause Menu

origin $000B986C
addiu a2, r0, 193 //X Position of Quit Option in Grand Prix Pause Menu

origin $000B98D8
addiu a2, r0, 193 //X Position of Settings Option in Grand Prix Pause Menu

origin $000B9948
addiu a1, r0, 178 //X Position of Arrow in Grand Prix Pause Menu

origin $000B9994
addiu t6, r0, 215 //X Position of Pause Text Shadow in Grand Prix Pause Menu

origin $000B9A0C
addiu t6, r0, 214 //X Position of Pause Text in Grand Prix Pause Menu

origin $000B9E38
addiu t7, r0, 326 //X Position of Max Speed for 2-Player Mode

origin $000B9E64
addiu t7, r0, 183 //X Position of Max Speed in Race at End of Time Trial Race

origin $000B9EC0
addiu t6, r0, 134 //X Position of Player 1 Max Speed in 3/4-Player Mode

origin $000B9EC8
addiu t8, r0, 134 //X Position of Player 3 Max Speed in 3/4-Player Mode

origin $000B9ED0
addiu t6, r0, 331 //X Position of Player 2 Max Speed in 3/4-Player Mode

origin $000B9ED8
addiu t8, r0, 331 //X Position of Player 4 Max Speed in 3/4-Player Mode

origin $000B9FA8
li t8, 0xED000000 //Max Speed End of Race 1-Player Scissor Command
li t9, 0x6A83C0 //Lower-Right of Max Speed End of Race 1-Player Scissor is (426,240)

origin $000B9FCC
li t6, 0xED000000 //Max Speed End of Race 1-Player Scissor Command
li t7, 0x6A83C0 //Lower-Right of Max Speed End of Race 1-Player Scissor is (426,240)

origin $000BA7BC
addiu t6, r0, 163 //X Position of Lap Statistics at end of Time Trial Race

origin $000BA904
slti at, t0, 427 //Course Name Box Check X Position

origin $000BA910
addiu t3, r0, 426 //Course Name Box Max X Position

origin $000BAAE4
li t9, 0xED000000 //Retire Fade Scissor Command
li t6, 0x6A83C0 //Lower-Right of Retire Fade Scissor is (426,240)
lui t7, 0xE700 //Run Replaced Opcode

origin $000BAE80
slti at, ra, 241 //Max Y Position for Ghost Time Box Near Right Edge

origin $000BAE88
slti at, ra, 241 //Max Y Position for Ghost Time Box Far from Right Edge

origin $000BAE94
addiu t5, r0, 240 //Y Position Clamp for Ghost Time Box

origin $000BB1DC
slti at, ra, 241 //Max Y Position for Death Race Box Near Right Edge

origin $000BB1E4
slti at, ra, 241 //Max Y Position for Death Race Box Near Right Edge

origin $000BB1F0
addiu t5, r0, 240 //Y Position Clamp for Ghost Time Box

origin $000BB600
slti at, a0, 0 //Render GP Text Up to Left Side of Screen

origin $000BB60C
addiu a3, r0, 0 //Clamp GP Text Rendering Up to Left Side of Screen

origin $000BC1A0
li t8, 0xED000000 //Retire Fade Scissor Command
li t9, 0x6A83C0 //Lower-Right of Retire Fade Scissor is (426,240)

origin $000BC1C0
addiu t1, r0, 0 //Top of Retire Fadeout

origin $000BC1C8
lui t5, 0 //Left Corner of Retire Fadeout
lui t4, 0xE46B //Retire Fade Texrect Right is 428

origin $000BC334
addiu at, r0, 240 //Retire Fadeout is 240 Pixels Tall

origin $000BC394
addiu t8, r0, 153 //X Position of Retire Text 1-Player Mode

origin $000BC3B8
addiu t6, r0, 153 //X Position of Retire Text 2-Player Mode

origin $000BC418
addiu t7, r0, 81 //X Position of Retire Text Player 1 3/4-Player Mode

origin $000BC420
addiu t9, r0, 282 //X Position of Retire Text Player 2 3/4-Player Mode

origin $000BC428
addiu t9, r0, 282 //X Position of Retire Text Player 4 3/4-Player Mode

origin $000BC434
addiu t9, r0, 81 //X Position of Retire Text Player 3 3/4-Player Mode

origin $000BC4D4
addiu t8, r0, 426 //X Position of Right Edge of Scissor for Retire Text in 1-Player Mode

origin $000BC504
addiu t7, r0, 0 //X Position of Left Edge of Scissor for Retire Text in 1-Player Mode

origin $000BC55C
addiu t9, r0, 0 //X Position of Left Edge of Scissor for Player 1 Retire Text in 2-Player Mode

origin $000BC564
addiu t9, r0, 0 //X Position of Left Edge of Scissor for Player 2 Retire Text in 2-Player Mode

origin $000BC574
addiu t8, r0, 426 //X Position of Right Edge of Scissor for Player 1 Retire Text in 2 Player Mode

origin $000BC594
addiu t8, r0, 426 //X Position of Right Edge of Scissor for Player 2 Retire Text in 2 Player Mode

origin $000BC5B4
addiu t9, r0, 0 //X Position of Left Edge of Scissor for Player 1 Retire Text in 3/4-Player Mode

origin $000BC5BC
addiu t9, r0, 0 //X Position of Left Edge of Scissor for Player 3 Retire Text in 3/4-Player Mode

origin $000BC5C4
addiu t9, r0, 213 //X Position of Left Edge of Scissor for Player 2 Retire Text in 3/4-Player Mode

origin $000BC5CC
addiu t9, r0, 213 //X Position of Left Edge of Scissor for Player 4 Retire Text in 3/4-Player Mode

origin $000BC5DC
addiu t8, r0, 212 //X Position of Right Edge of Scissor for Player 1 Retire Text in 3/4-Player Mode

origin $000BC5FC
addiu t8, r0, 212 //X Position of Right Edge of Scissor for Player 3 Retire Text in 3/4-Player Mode

origin $000BC61C
addiu t8, r0, 426 //X Position of Right Edge of Scissor for Player 2 Retire Text in 3/4-Player Mode

origin $000BC63C
addiu t8, r0, 426 //X Position of Right Edge of Scissor for Player 4 Retire Text in 3/4-Player Mode

origin $000BC808
addiu t6, r0, 398 //Width of Generic Large Box

origin $000BCC3C
addiu t6, r0, 208 //Base X Position of Left Edge of Death Race Results Box

origin $000BCC70
addiu a3, v1, 222 //Base X Position of Right Edge of Death Race Results Box

origin $000BCCB8
addiu t8, r0, 215 //X Position of Death Race Results Shadow

origin $000BCD30
addiu t9, r0, 215 //X Position of Death Race Results Text

origin $000BCE28
addiu t5, r0, 319 //Base for Right Edge Calculation of Time Text at Death Race End

origin $000BCE78
addiu a1, r0, 1276 //X Position*4 of Time Text at Death Race End

origin $000BD030
li t6, 0xE453C1C4 //Define Lower-Right of BEST Text at End of Death Race (lrx=335,lry=113)
li t8, 0x4FC194  //Upper-Left Corner Coordinates of BEST Text at End of Death Race (lrx=319,lry=101)
addiu s0, s0, 8 //Run Replaced Operation

origin $000BD18C
addiu a2, r0, 319 //X Position of This Run Time at End of Death Race

origin $000BD1EC
addiu a2, r0, 319 //X Position of Best Run Time at End of Death Race

origin $000BD2F0
addiu t9, r0, 208 //Left Edge of VS Results Box Base X Position

origin $000BD324
addiu a3, v1, 222 //Right Edge of VS Results Box Base X Position

origin $000BD36C
addiu t9, r0, 215 //X Position of VS Results Text Shadow

origin $000BD3E4
addiu t9, r0, 213 //X Position of VS Results Text

origin $000BD460
addiu t9, r0, 208 //Left Edge of VS Total Ranking Box Base X Position

origin $000BD494
addiu a3, v1, 222 //Right Edge of VS Total Ranking Box Base X Position

origin $000BD4DC
addiu t8, r0, 215 //X Position of VS Results Text Shadow

origin $000BD54C
addiu t7, r0, 213 //X Position of VS Results Text

origin $000BD664
addiu t6, r0, 396 //Right Edge of VS Results Scissor

origin $000BDEF8
addiu t7, r0, 264 //X Position of Point Number on Versus Results Screen

origin $000BDF3C
addiu a1, r0, 264 //X Position of pts on Versus Results Screen

origin $000BDF90
addiu a1, r0, 343 //X Position of Point Gain Sign on Versus Results Screen

origin $000BDFD0
addiu a1, r0, 356 //X Position of Point Gain Amount on Versus Results Screen

origin $000BE048
addiu a1, r0, 376 //X Position of Victory Indicator on Versus Results Screen

origin $000BE160
addiu t9, r0, 396 //Right Edge of VS Total Ranking Scissor

origin $000BE198
addiu a1, r0, 183 //X Position of Quit Text on VS Total Ranking

origin $000BE220
addiu a1, r0, 183 //X Position of Select Course Text on VS Total Ranking

origin $000BE25C
addiu a1, r0, 163 //X Position of Arrow on VS Total Ranking

origin $000BE2B8
addiu a1, r0, 183 //X Position of Select Course Text on VS Total Ranking

origin $000BE858
addiu t7, r0, 317 //X Position of Point Number on VS Total Ranking

origin $000BE8A4
addiu a1, r0, 317 //X Position of pts on VS Total Ranking

origin $000BE920
addiu a1, r0, 341 //X Position of Victory Symbol on VS Total Ranking

origin $000BE97C
addiu a1, r0, 355 //X Position of Victory Number on VS Total Ranking

origin $000BEF64
addiu t2, r0, 215 //X Position of VS Results Text Shadow

origin $000BEFDC
addiu t9, r0, 213 //X Position of VS Results Text

origin $000BF01C
li t7, 0xED0780DC //Scissor Command for Grand Prix Results Box Interior (ulx=30,uly=55)
li t4, 0x6300330 //Lower-Right of Scissor for Grand Prix Results Box Interior (ulx=396,uly=204)
li a3, 0x800E5EC0 //Run a Replaced Instruction
lui t1, 0xE700 //Run Another Replaced Instruction

origin $000BF180
addiu a2, r0, 269 //X Position of + and pts in Grand Prix Results Box 

origin $000BF1CC
addiu a3, r0, 252 //X Position of Point Number in Grand Prix Results Box 

origin $000BF1F8
addiu a3, r0, 252 //X Position of Retire Text in Grand Prix Results Box 

origin $000BF50C
addiu a2, r0, 319 //X Position of Current Race Time in Grand Prix Results Box

origin $000BF890
addiu t6, r0, 215 //X Position of Total Ranking Text Shadow

origin $000BF908
addiu t7, r0, 215 //X Position of Total Ranking Text

origin $000BFADC
li t7, 0xED0780DC //Scissor Command for Grand Prix Total Ranking Box Interior (ulx=30,uly=55)
li t5, 0x630350 //Lower-Right of Scissor for Grand Prix Total Ranking Box Interior (ulx=396,uly=204)

origin $000BFE4C
addiu a2, r0, 365 //X Position of + and pts in Grand Prix Total Ranking Box 

origin $000BFE70
addiu a3, r0, 349 //X Position of Point Number in Grand Prix Total Ranking Box 

origin $000C089C
li t3, 0x6A83C0 //Scissor for 3-Player Lower-Right Information

origin $000C08D8
addiu a1, r0, 213 //X Position of Left Edge of 3-Player Lower-Right Viewport Black Box

origin $000C08F0
addiu a3, r0, 426 //X Position of Right Edge of 3-Player Lower-Right Viewport Black Box

origin $000C0954
lui at, 0x43A0 //3-Player Course Name Shadow X Position (320.0f)

origin $000C09E4
lui at, 0x439F //3-Player Course Name X Position (318.0f)

origin $000C0A5C
lui t2, 0xED00 //Main GUI Scissor Command
li t3, 0x6A83C0 //Lower-Right of Main GUI Scissor is (426,240)
ori t2, t2, 0 //Set Upper-Left of Main GUI Scissor to (0,0)

origin $000C0A7C
lui t4, 0xED00 //Multiplayer GUI Scissor Command
li t5, 0x6A83C0 //Lower-Right of Multiplayer GUI Scissor is (426,240)
ori t4, t4, 0 //Set Upper-Left of Multiplayer GUI Scissor to (0,0)

origin $000C0E74
addiu a1, r0, 328 //X Position of Start Race Blank Time Distance from First Place

origin $000C0F04
addiu a1, r0, 328 //X Position of Blank Time Distance from First Place

origin $000C0F9C
addiu a2, r0, 328 //X Position of Time Distance from First Place

origin $000C1110
addiu a1, r0, 328 //X Position of Time Trial Start Race Blank Time Distance from Ghost

origin $000C116C
addiu a1, r0, 328 //X Position of Time Trial Blank Time Distance from Ghost

origin $000C120C
addiu a2, r0, 328 //X Position of Time Trial Time Distance from Ghost

origin $000C14B0
addiu t3, r0, 426 //Starting X Position for Course Name at Level Start

origin $000C14B8
slti at, s0, 213 //Distance for Course Name to Move at Level Start Before Stop

origin $000C14C4
addiu s0, r0, 213  //Destination X Position for Course Name at Level Start

origin $000C14F0
slti at, s0, 214 //Distance for GP Difficulty Text to Move

origin $000C14FC
addiu s0, r0, 213 //Destination X Position for GP Difficulty Text at Level Start

origin $000C1558
addiu a1, r0, 213 //X Position for Death Race Best Time Box at Level Start

origin $000C15D0
addiu a1, r0, 213 //X Position of Ghost Time at Level Start

origin $000C16A4
addiu a1, r0, 213 //X Position of Course Name at End of Time Trial Race

origin $000C1814
addiu a1, r0, 213 //X Position of Course Name at End of Grand Prix Race

origin $000C21BC
lui at, 0x43D5 //Y-FOV for Rotating Finish Sign

origin $000C21DC
lui a2, 0x4267 //FOV for Rotating Finish Sign

origin $000C79D4
addiu s1, r0, 1364 //X Position*4 of Leftmost Star in Death Race

origin $000C79F0
addiu v0, r0, 1564 //X Position*4 of Rightmost Star in Death Race

origin $000C80E8
addiu a1, r0, 181 //X Position of No Lap Completed Best Lap Time in Practice Mode

origin $000C8108
addiu a1, r0, 181 //X Position of Best Lap Time in Practice Mode

origin $000C81C0
li t8, 0x2D5050 //Upper-Left of BEST Texture in BEST LAP is (181.25,20)
li t7, 0xE4315080 //Lower-Right of BEST Texture in BEST LAP is (197.25,32)

origin $000C8278
li t9, 0x315050 //Upper-Left of LAP Texture in BEST LAP is (197.25,20)
li t8, 0xE4355080 //Lower-Right of LAP Texture in BEST LAP is (213.25,32)

origin $000CD054
addiu v0, r0, 326 //X Position of Max Speed and Record on Time Trial Records Screen

origin $000CD0F8
addiu v0, r0, 326 //X Position of Max Speed and Record on Records Screen

origin $000CD690
ori t9, t9, 425 //Framebuffer Width for Records Screen-1

origin $000CD6F0
addiu a3, r0, 414 //Width of Records Box on Records Screen

origin $000CD740
addiu t8, r0, 206 //X Position of Left Edge of Course Name Box on Records Screen

origin $000CD778
addiu a3, v1, 220 //X Position of Right Edge of Course Name Box on Records Screen

origin $000CD7BC
addiu t8, r0, 215 //X Position of Course Name Shadow on Records Screen

origin $000CD82C
addiu t8, r0, 213 //X Position of Course Name on Records Screen

origin $000CD960
addiu a2, a2, 171 //X Position of Left Arrow on Records Screen

origin $000CD994
addiu a2, a2, 223 //X Position of Right Arrow on Records Screen

origin $000CDA70
addiu a3, a3, 130 //X Offset for Right Edge of Player Name Boxes on Records Screen

origin $000CDA74
addiu a1, v0, 127 //X Offset for Left Edge of Player Name Boxes on Records Screen

origin $000CDE4C
addiu a2, a2, 128 //X Position of Filled Times on Record Screen

origin $000CE268
addiu a1, a1, 128 //X Position of Empty Times on Record Screen

origin $000CE344
addiu a1, a1, 128 //X Position of Record Player Names on Record Screen-1

origin $000CE3A8
addiu a1, r0, 284 //X Position of Speed Setting on Records Screen

origin $000CF528
addiu s6, r0, 426 //Viewport for Random Letter Start Position on Name Entry Screen

origin $000CF838
addiu t8, t7, 115 //Viewport for Letters Initial Destination Position on Name Entry Screen

origin $000CFC94
addiu t6, t5, 115 //X Position Source of Name Entry Letters on Name Entry Screen

origin $000CFED4
addiu t7, t6, 115 //X Position of Rotating Letters on Name Entry Screen

origin $000CFF30
addiu t7, t6, 185 //Destination X Offset for Name Entry Letters

origin $000D064C
addiu a1, r0, 105 //X Position of Left Edge of Name Entry Box

origin $000D0654
addiu a3, r0, 321 //X Position of Right Edge of Name Entry Box

origin $000D0694
addiu t7, r0, 426 //Viewport Width of Name Entry Text X Position Calculation

origin $000D07D0
addiu s0, s0, 115 //X Position of Non-Rotating Letters on Name Entry Screen

origin $000D084C
addiu s3, r0, 185 //X Position of Entered Name on Name Entry Screen

origin $000D23EC
dw 336 //X Position of Timer Digits in 1-Player Mode

origin $000D243C
dw 221 //X Position of Player 2's Timer Digits in 3-Player Mode

origin $000D245C
dw 221 //X Position of Player 2's Timer Digits in 4-Player Mode

origin $000D2464
dw 221 //X Position of Player 4's Timer Digits in 4-Player Mode

origin $000D246C
dw 304 //X Position of Time Text During Racing

origin $000D2524
dw 326 //Energy Bar Background X Position in 1-Player Mode

origin $000D2544
dw 330 //Player 1 Energy Bar Background X Position in 2-Player Mode

origin $000D254C
dw 330 //Player 2 Energy Bar Background X Position in 2-Player Mode

origin $000D2564
dw 149 //Player 1 Energy Bar Background X Position in 3-Player Mode

origin $000D256C
dw 149 //Player 3 Energy Bar Background X Position in 3-Player Mode

origin $000D2574
dw 346 //Player 2 Energy Bar Background X Position in 3-Player Mode

origin $000D2584
dw 149 //Player 1 Energy Bar Background X Position in 4-Player Mode

origin $000D258C
dw 149 //Player 3 Energy Bar Background X Position in 4-Player Mode

origin $000D2594
dw 346 //Player 2 Energy Bar Background X Position in 4-Player Mode

origin $000D259C
dw 346 //Player 4 Energy Bar Background X Position in 4-Player Mode

origin $000D25A4
dw 328 //Energy Bar Background X Position in 1-Player Mode

origin $000D25C4
dw 332 //Player 1 Energy Bar X Position in 2-Player Mode

origin $000D25CC
dw 332 //Player 2 Energy Bar X Position in 2-Player Mode

origin $000D25E4
dw 151 //Player 1 Energy Bar X Position in 3-Player Mode

origin $000D25EC
dw 151 //Player 3 Energy Bar X Position in 3-Player Mode

origin $000D25F4
dw 348 //Player 2 Energy Bar X Position in 3-Player Mode

origin $000D2604
dw 151 //Player 1 Energy Bar X Position in 4-Player Mode

origin $000D260C
dw 151 //Player 3 Energy Bar X Position in 4-Player Mode

origin $000D2614
dw 348 //Player 2 Energy Bar X Position in 4-Player Mode

origin $000D261C
dw 348 //Player 4 Energy Bar X Position in 4-Player Mode

origin $000D2624
dw 332 //Speedometer X Position 1-Player Mode

origin $000D2644
dw 332 //Player 1 Speedometer X Position 2-Player Mode

origin $000D264C
dw 332 //Player 2 Speedometer X Position 2-Player Mode

origin $000D2674
dw 221 //Player 2 Speedometer X Position 3-Player Mode

origin $000D2694
dw 221 //Player 2 Speedometer X Position 4-Player Mode

origin $000D269C
dw 221 //Player 4 Speedometer X Position 4-Player Mode

origin $000D26A4
dw 171 //GP Mode Current Ranking X Position

origin $000D26F4
dw 199 //Player 2 Current Ranking X Position 3-Player Mode 

origin $000D2714
dw 199 //Player 2 Current Ranking X Position 4-Player Mode 

origin $000D271C
dw 199 //Player 4 Current Ranking X Position 4-Player Mode

origin $000D2764
dw 183 //Player 1 Lap Count X Position 3-Player Mode

origin $000D276C
dw 183 //Player 2 Lap Count X Position 3-Player Mode

origin $000D2774
dw 378 //Player 3 Lap Count X Position 3-Player Mode

origin $000D2784
dw 183 //Player 1 Lap Count X Position 4-Player Mode

origin $000D278C
dw 183 //Player 2 Lap Count X Position 4-Player Mode

origin $000D2794
dw 378 //Player 3 Lap Count X Position 4-Player Mode

origin $000D279C
dw 378 //Player 4 Lap Count X Position 4-Player Mode

origin $000D27D4
dw 173 //Distance from First Place End of Lap X Position 1-Player Mode

origin $000D27F4
dw 173 //Distance from First Place End of Lap Player 1 X Position 2-Player Mode

origin $000D27FC
dw 173 //Distance from First Place End of Lap Player 2 X Position 2-Player Mode

origin $000D2814
dw 74 //Distance from First Place End of Lap Player 1 X Position 3-Player Mode

origin $000D281C
dw 74 //Distance from First Place End of Lap Player 3 X Position 3-Player Mode

origin $000D2824
dw 275 //Distance from First Place End of Lap Player 2 X Position 3-Player Mode

origin $000D2834
dw 74 //Distance from First Place End of Lap Player 1 X Position 4-Player Mode

origin $000D283C
dw 74 //Distance from First Place End of Lap Player 3 X Position 4-Player Mode

origin $000D2844
dw 275 //Distance from First Place End of Lap Player 2 X Position 4-Player Mode

origin $000D284C
dw 275 //Distance from First Place End of Lap Player 4 X Position 4-Player Mode

origin $000D2854
dw 157 //X Position of Reverse Warning in 1-Player Mode

origin $000D2874
dw 157 //X Position of Reverse Warning for Player 1 in 2-Player Mode

origin $000D287C
dw 157 //X Position of Reverse Warning for Player 2 in 2-Player Mode

origin $000D2894
dw 70 //X Position of Reverse Warning for Player 1 in 3-Player Mode

origin $000D289C
dw 70 //X Position of Reverse Warning for Player 2 in 3-Player Mode

origin $000D28A4
dw 267 //X Position of Reverse Warning for Player 3 in 3-Player Mode

origin $000D28B4
dw 70 //X Position of Reverse Warning for Player 1 in 4-Player Mode

origin $000D28BC
dw 70 //X Position of Reverse Warning for Player 2 in 4-Player Mode

origin $000D28C4
dw 267 //X Position of Reverse Warning for Player 3 in 4-Player Mode

origin $000D28CC
dw 267 //X Position of Reverse Warning for Player 4 in 4-Player Mode

origin $000D39D8
dw 338 //Map X Position in 1-Player Mode

origin $000D39F8
dw 352 //Player 1 Map X Position in 2-Player Mode

origin $000D3A00
dw 352 //Player 2 Map X Position in 2-Player Mode

origin $000D3A18
dw 159 //Player 1 Map X Position in 3-Player Mode

origin $000D3A20
dw 159 //Player 2 Map X Position in 3-Player Mode

origin $000D3A28
dw 354 //Player 3 Map X Position in 3-Player Mode

origin $000D3A30
dw 297 //Shared Map X Position in 3-Player Mode

origin $000D3A38
dw 159 //Player 1 Map X Position in 4-Player Mode

origin $000D3A40
dw 159 //Player 2 Map X Position in 4-Player Mode

origin $000D3A48
dw 354 //Player 3 Map X Position in 4-Player Mode

origin $000D3A50
dw 354 //Player 4 Map X Position in 4-Player Mode

origin $000D4B70
float32 1.33333 //Size of Level Background Filter 

origin $000D4CFC
addiu a1, r0, 133 //X Position of Machine Select Text on Car Select Screen

origin $000D4D90
addiu a1, r0, 366 //X Position of Player 4 Portrait on Car Select

origin $000D4DCC
addiu a1, r0, 366 //X Position of Player 3 Portrait on Car Select

origin $000D4FC4
addiu a1, r0, 266 //X Position of Speed Bar and Car Weight on 1-Player Car Configuration Screen

origin $000D4FD8
addiu a1, r0, 266 //X Position of Car Statistics on 1-Player Car Configuration Screen

origin $000D5E8C
lw t6, 24(sp) //Get Base Address of Car Select Graphics Structure
sw v0, 28(t6) //Write Base Address of Car Viewport List to Car Select Graphics Structure
addiu v1, r0, 0 //Initial Horizontal Car Viewport Loop Counter
addiu at, r0, 0 //Initial Vertical Car Viewport Loop Counter
lui a0, 0x1FF //Car Viewport Depth (511)
addiu a1, r0, 640 //Car Viewport Width
addiu a2, r0, 480 //Car Viewport Height
carvploop:
addiu t0, r0, 160 //Car Viewport Horizontal Spacing
multu t0, v1 //Calculate X Offset of Current Car Viewport
nop //Delay Slot
mflo t0 //Get X Offset of Current Car Viewport
addiu t0, t0, 441 //Get X Position of Current Car Viewport
sh t0, 8(v0) //Update X Position of Current Car Viewport
addiu t0, r0, 136 //Car Viewport Vertical Spacing
multu t0, at //Calculate Y Offset of Current Car Viewport
nop //Delay Slot
mflo t0 //Get Y Offset of Current Car Viewport
addiu t0, t0, 228 //Get Y Position of Current Car Viewport
sh t0, 10(v0) //Update Y Position of Current Car Viewport
sw a0, 4(v0) //Set Depth Size of Current Car Viewport
sw a0, 12(v0) //Set Depth Offset of Current Car Viewport
sh a1, 0(v0) //Set Width of Current Car Viewport
sh a2, 2(v0) //Set Height of Current Car Viewport
addiu v0, v0, 16 //Get Address of Next Car Viewport
addiu v1, v1, 1 //Get Next Horizontal Car Viewport
addiu t0, r0, 6 //Max Horizontal Car Viewports
bne v1, t0, carvploop //Loop Through Horizontal Car Viewports
nop //Delay Slot
addiu v1, r0, 0 //Reset Horizontal Car Viewports Loop Counter
addiu at, at, 1 //Get Next Vertical Car Viewport
addiu t0, r0, 5 //Max Vertical Car Viewports
bne at, t0, carvploop //Loop Through Vertical Car Viewports
nop //Delay Slot
j $80117398 //Return to Game Code
nop //Delay Slot

origin $000D6248
addiu ra, r0, 213 //Offset of P3/P4 Cars on Car Configuration Screen

origin $000D6310
addiu t7, t6, 326 //X Position of Car on 1-Player Configuration Screen

origin $000D633C
addiu t9, t8, 339 //X Position of Cars on 2-Player Car Configuration Screen

origin $000D66E0
lui r30, 0xF66A //Select Machine Screen Clear Rectangle Width Upper-Half (426)

origin $000D66F0
ori r30, r30, 0x4000 //Select Machine Screen Clear Rectangle Width Lower-Half (426)
addiu s5, r0, 240 //Select Machine Screen Gradient Height

origin $000D6700
lui ra, 0 //Select Machine Screen Clear Rectangle Left Edge X Position (0)

origin $000D67EC
addiu s3, v0, 0 //Select Machine Screen Gradient Top Offset

origin $000D689C
addiu s4, v0, 1 //Select Machine Screen Gradient Bottom Offset

origin $000D7178
addiu a2, a2, 93 //X Offset of Car Select Cursor

origin $000D7534
addiu v1, r0, 371 //X Position of OK Text in 1-Player Car Select
addiu v1, r0, 197 //X Position of OK Text in Multiplayer Car Select

origin $000D760C
addiu t8, r0, 396 //X Position of Right Edge of Character Name Text on 1-Player Car Select

origin $000D8434
addiu a2, a2, 258 //X Position of Max Speed/Acceleration Balance Arrow on Car Configuration Screen in 1-Player

origin $000D8588
addiu t6, r0, 0 //X Position of Left Edge of Player 1/2 Split on Car Configuration Screen

origin $000D8590
addiu t8, r0, 426 //X Position of Right Edge of Player 1/2 Split on Car Configuration Screen

origin $000D85D4
addiu t1, r0, 211 //3/4 Player Split Left Edge X Position Car Configuration Screen
addiu t2, r0, 0 //3/4 Player Split Top Edge X Position Car Configuration Screen
addiu t3 ,r0, 212 //3/4 Player Split Right Edge X Position Car Configuration Screen
addiu t4, r0, 240 //3/4 Player Split Bottom Edge X Position Car Configuration Screen

origin $000D8880
addiu t8, r0, 213 //X Position of Car Name on Car Select Screen

origin $000D88EC
addiu a1, r0, 358 //X Position of Car Weight on Car Select Screen

origin $000D890C
addiu a1, r0, 358 //X Position of Car Weight Symbol on Car Select Screen

origin $000D897C
addiu a2, a2, 373 //X Position of OK Icon on Car Configuration Screen

origin $000D8B2C
addiu t9, t8, 93 //X Offset of Car Select Cursor Player Number

origin $000D8EE0
addiu t1, r0, 213 //Offset of P3/P4 Car Shadows on Car Configuration Screen

origin $000D8F58
addiu t7, t6, 326 //X Position of Car Shadow on 1-Player Car Configuration Screen

origin $000D8F7C
addiu t9, t8, 339 //X Position of Player 1 Shadow on 2-Player Car Configuration Screen

origin $000D9048
addiu t8, t7, 339 //X Position of Player 2 Shadow on 2-Player Car Configuration Screen

origin $000D9BCC
addiu a1, r0, 147 //Copyright Text X Position Title Screen

origin $000D9E84
addiu t0, r0, 61 //X Position of Title Screen Background

origin $000D9EC0
addiu t7, r0, 136 //X Position of Title Screen Logo

origin $000D9F70
addiu t8, r0, 173 //X Position of Title Screen Press Start Text

origin $000DC484
dw 405 //Player 3 Car Statistics X Position Car Select

origin $000DC48C
dw 405 //Player 4 Car Statistics X Position Car Select

origin $000DC4B4
dw 238 //Player 3 Car Information X Position Car Configuration

origin $000DC4BC
dw 238 //Player 4 Car Information X Position Car Configuration

origin $000DCC3C
addiu t8, a0, 852 //Offset for First Course Viewport in Course Select

origin $000DCC64
addiu t6, a0, 2132 //Offset for Second Course Viewport in Course Select

origin $000DCCD0
addiu t6, a2, 852 //Offset for Third Course Viewport in Course Select

origin $000DCCF8
addiu t5, a2, 2132 //Offset for Fourth Course Viewport in Course Select

origin $000DCD38
addiu t9, a2, 3412 //Offset for Fifth Course Viewport in Course Select

origin $000DCD78
addiu t8, a2, 4692 //Offset for Last Course Viewport in Course Select

origin $000DD2B8
addiu a1, r0, 133 //X Position of Select Course Text

origin $000DD2C4
addiu a1, r0, 165 //X Position of Records Text

origin $000DD440
addiu a1, r0, 243 //X Position of Ghost Text on Time Trial Course Select

origin $000DDE24
addiu t0, r0, 61 //X Position of Submenu Background

origin $000DE0B4
addiu t6, r0, 103 //Starting Slide Position of OK Button on Course Select

origin $000DE1DC
addiu t6, r0, 203 //Starting Slide Position for Ghost Options on Course Select

origin $000DE210
nop //Never Have Light Submenu Background 

origin $000DE254
addiu a0, a0, 24 //Display List Move Size for Submenu Background

origin $000DE26C
nop //Move DrawMenuSprite Call

origin $000DE274
lui t1, 0xF700 //Set Fill Color
sw t1, -16(a0) //Add Fill Color Set to Display List Buffer
sw r0, -12(a0) //Set Fill Color to Black in Display List Buffer
li t1, 0xF66A43BC //Fill Rectangle for Submenu Background
sw t1, -8(a0) //Add Fill Rectangle to Display List Buffer
jal 0x80078EA0 //Call DrawMenuSprite
sw r0, -4(a0) //Add Fill Rectangle Extended Parameters to Display List Buffer
j $80117BCC //Return to Original Code
addu a0, v0, r0 //Get Address of Display List Buffer for Caller

origin $000DE8AC
addiu a2, a2, 320 //Base X Position for OK Button in Course Select

origin $000DE960
addiu a2, a2, 96 //Base X Position for Left Arrow in Course Select

origin $000DEA20
addiu a2, a2, 298 //Base X Position for Right Arrow in Course Select

origin $000DEC80
addiu a1, a1, 213 //X Position for Course Number on Course Select

origin $000DECFC
addiu a1, a1, 213 //X Position for Course Name on Course Select

origin $000DED84
addiu t6, r0, 213 //X Position for Course Alternate Name on Course Select

origin $000DEFF0
addiu a2, a2, 248 //Base X Position for Time Trial Ghost Options

origin $000DF13C
addiu t7, r0, 181 //X Position of Cup Icons During GP Between Races

origin $000DF31C
addiu a1, r0, 181 //Destinaiton X Position for Cups on Course Select

origin $000DF3A0
addiu a1, a1, 43 //X Offset for Cups on Course Select

origin $000DF3EC
addiu a1, a1, 69 //X Offset for Cups on 5-Cup Course Select

origin $000DF428
addiu a1, a1, -75 //X Offset for Cups on 4-Cup Course Select

origin $000DF4C4
addiu a1, r0, 103 //Slide Distance of OK Button on Course Select

origin $000DF594
addiu a1, r0, -153 //Slide Distance for Left Arrow on Course Select

origin $000DF660
addiu a1, r0, 153 //Slide Distance for Right Arrow on Course Select

origin $000DF714
addiu a1, r0, 203 //Slide Distance for Ghost Options on Course Select

origin $000E00A0
addiu a1, r0, 153 //X Position of Select Mode Text in Main Menu

origin $000E00B4
addiu a1, r0, 149 //X Position of Versus Mode Player Number Select in Main Menu

origin $000E00DC
addiu a1, r0, 149 //X Position of Grand Prix Difficulty Select in Main Menu

origin $000E00F0
addiu a1, r0, 149 //X Position of Time Trial in Main Menu

origin $000E0948
addiu t9, r0, 61 //X Position of Main Menu Background

origin $000E0CC4
slti at, v0, 17 //Slide Out Duration of Selectable Main Menu Items

origin $000E0CD0
addiu v0, r0, 16 //Max Slide Out Distance of Selectable Main Menu Items

origin $000E0D38
addiu a2, a2, 85 //X Position of Selectable Main Menu Items

origin $000E0E10
addiu a1, r0, 0 //X Position of Main Menu Background Darkness Effect

origin $000E0E18
addiu t8, r0, 426 //Width of Main Menu Background Darkness Effect

origin $000E1674
addiu v0, r0, -16 //Slide-In Duration of Versus Mode Player Number Select Box

origin $000E18F8
addiu v0, r0, -16 //Slide-In Duration of Grand Prix Difficulty Select Box

origin $000E190C
slti at, v0, 17 //Slide-Out Duration of Grand Prix Difficulty Select Box

origin $000E1918
addiu v0, r0, 16 //Max Slide-Out Distance of Grand Prix Difficulty Select Box

origin $000E1BB0
addiu v0, r0, -16 //Slide-In Duration of Time Trial Mode Select Box

origin $000E1BC4
slti at, v0, 17 //Slide-Out Duration of Time Trial Mode Select Box

origin $000E1BD0
addiu v0, r0, 16 //Max Slide-Out Distance of Time Trial Mode Select Box

origin $000E1DE4
addiu a2, a2, 320 //X Position of OK Text in Main Menu

origin $000E1E38
addiu a2, a2, 320 //X Position of Slid In OK Text in Main Menu

origin $000E1E84
addiu a1, r0, 103 //Slide Distance of OK Text in Main Menu

origin $000E6ED8
addiu a2, r0, 61 //X Position of Options Screen Background

origin $000E6F50
addiu a2, r0, 103 //X Position of Left Head on Options Screen

origin $000E6F98
addiu a2, r0, 259 //X Position of Left Head on Options Screen

origin $000E6FFC
addiu t0, r0, 165 //X Position of Options Text on Options Screen

origin $000E70DC
addiu t4, t3, 83 //X Position of Option Names on Options Screen

origin $000E713C
addiu t2, r0, 243 //X Position of Left Arrow on Options Screen

origin $000E7188
addiu t6, r0, 318 //X Position of Right Arrow on Options Screen

origin $000E7204
addiu t8, s4, 261 //X Position of Option Values on Options Screen

origin $000E9EA4
lui at, 0x42A6 //Congraulations Text X Position at End of Grand Prix (83.0f)

origin $000EA9C8
ori t4, t4, 425 //Framebuffer Width for End of Grand Prix Screen-1

origin $000EAAD0
ori t5, t5, 425 //Framebuffer Width for End of Grand Prix Screen-1

origin $000EAFD4
lui at, 0x4355 //X Position of Course Name Shadows at End of Grand Prix

origin $000EB078
lui at, 0x4355 //X Position of Course Name at End of Grand Prix

origin $000EB128
addiu a1, r0, 103 //X Position of Placement in Races at End of Grand Prix

origin $000EB218
addiu a2, r0, 163 //X Position of Race Time at End of Grand Prix

origin $000EB248
addiu a1, r0, 247 //X Position of Max Race Speed at End of Grand Prix

origin $000EB274
addiu a1, r0, 163 //X Position of Number of Kills in Each Race at End of Grand Prix

origin $000EB640
lui at, 0x4355 //X Position of Total Ranking Text Shadow at End of Grand Prix

origin $000EB6F4
lui at, 0x4355 //X Position of Total Ranking Text at End of Grand Prix

origin $000EB764
lui at, 0x432F //X Position of Final Placement at End of Grand Prix

origin $000EBC58
addiu a1, r0, 163 //X Position of Total Number of Kills at End of Grand Prix

origin $000EBDF8
lui at, 0x4355 //Shadows on Cup Names at End of Grand Prix Screen X Position

origin $000EBEA0
lui at, 0x4355 //Cup Names at End of Grand Prix Screen X Position

origin $000EBFEC
lui at, 0x4355 //Cup Difficulty at End of Grand Prix Screen X Position

origin $000EC0A8
addiu t6, r0, 240 //Height of Thanks for Playing Screen Fade

origin $000EC0C4
addiu a1, r0, 0 //X Position of Thanks for Playing Screen Fade
addiu a2, r0, 0 //Y Position of Thanks for Playing Screen Fade

origin $000EC0D0
addiu a3, r0, 426 //Width of Thanks for Playing Screen Fade

origin $000EC120
addiu t2, r0, 426 //Width of Viewport for Placing Thanks for Playing Text

origin $000EC330
addiu a2, r0, 129 //X Position of Winner Portrait in Grand Prix Ending Cutscene

origin $000EC348
addiu a2, r0, 115 //X Position of Winning Message in Grand Prix Ending Cutscene

origin $000F1BB8
addiu a1, r0, 161 //X Position of Records Screen Submenu

origin $000F21EC
ori t4, t4, 425 //Framebuffer Width for Records Screen-1

origin $000F23E0
addiu a2, r0, 342 //X Position of Left Edge of Ghost Icon on Records Screen

origin $000F2414
addiu a3, r0, 373 //X Position of Right Edge of Ghost Icon on Records Screen

origin $000F2AB0
float32 425 //Orthographic Width of Ghost Text on Records Screen

origin $0017B35C
dw $00463D80 //Depth Buffer Address

origin $0017B362
dh 425 //RDP Depth Buffer Width-1
dw $00463D80 //Depth Buffer Address for Clear

origin $0017B370
dw $F66A43BC //Lower-Right Corner of Depth Buffer Clear is (426,240)
dw $00000000 //Upper-Left Corner of Depth Buffer Clear is (0,0)

origin $0017B410
dw $ED000000 //Upper-Left of Menu 2D Scissor is (0,0)
dw $006A83BC //Lower-Right of Menu 2D Scissor is (426,240)

origin $0017B4D8
dw $ED000000 //Upper-Left of Depth Buffer Clear Scissor is (0,0)
dw $006A83BC //Lower-Right of Depth Buffer Clear Scissor is (426,240)

origin $0017B4E4
dw $00463D80 //Depth Buffer Address for Clear

origin $0017B4EA
dh 425 //RDP Depth Buffer Width-1
dw $00463D80 //Depth Buffer Address for Clear

origin $0017B4F8
dw $F66A83C0 //Lower-Right Corner of Depth Buffer Clear is (426,240)
dw $00000000 //Upper-Left Corner of Depth Buffer Clear is (0,0)

origin $0017B50C
dw $00463D80 //Depth Buffer Address for Clear

origin $0017B558
dw $ED000000 //Upper-Left of Time Trial Course Select Scissor is (0,0)
dw $006A83BC //Lower-Right of Time Trial Course Select Scissor is (426,240)

origin $001B5A94
dw $00463D80 //Depth Buffer Address for Side Object Clear

origin $001B5A9A
dh 425 //RDP Depth Buffer Width for Side Object Clear-1
dw $00463D80 //Depth Buffer Address for Side Object Clear

origin $001B5AA8
dw $ED000000 //Upper-Left of Depth Buffer Clear Scissor is (0,0)
dw $006A83C0 //Lower-Right of Depth Buffer Clear Scissor is (426,240)

origin $001B5AB0
dw $F66A43BC //Lower-Right Corner of Depth Buffer Clear is (426,240)
dw $00000000 //Upper-Left Corner of Depth Buffer Clear is (0,0)

origin $001B5B7C
dw $00463D80 //Depth Buffer Address for Side Object Clear

origin $001B5B82
dh 425 //RDP Depth Buffer Width for Side Object Clear-1
dw $00463D80 //Depth Buffer Address for Side Object Clear

origin $001B5B90
dw $ED000000 //Upper-Left of Depth Buffer Clear Scissor is (0,0)
dw $006A83C0 //Lower-Right of Depth Buffer Clear Scissor is (426,240)

origin $001B5B98
dw $F66A43BC //Lower-Right Corner of Depth Buffer Clear is (426,240)
dw $00000000 //Upper-Left Corner of Depth Buffer Clear is (0,0)

origin $00F68000
commonfileaddr:
insert "common.bin" //Insert Decompressed General Use File
commonfileend: