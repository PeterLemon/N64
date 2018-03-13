// N64 "Super Mario 64" Widescreen Hack by gamemasterplc (Requires Expansion Pak 8MB RDRAM):

arch n64.cpu
endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "Super Mario 64 WS.z64", create
origin $00000000; insert "Super Mario 64 (U) [!].z64" // Include USA Super Mario 64 N64 ROM
origin $00000020
db "SUPER MARIO 64 WS          " // $00000020 - PROGRAM TITLE (27 Byte ASCII String, Use Spaces For Unused Bytes)

include "LIB/N64.INC" // Include N64 Definitions

origin $00001EFC
lui t1, 0x6A
ori t1, t1, 0x83C0

origin $00002338
ori t4, t4, 425 //Depth Buffer Width

origin $000023A0
lui t6, 0xF66A //First 2 Bytes of Depth Buffer Clear Command
ori t6, t6, 0x439C

origin $00002448
ori t8, t8, 425 //Colour Framebuffer Width

origin $0000249C
lui t8, 0x6A
ori t8, t8, 0x83A0

origin $0000259C
lui t0, 0xF66A
ori t0, t0, 0x439C

origin $000028A4
lui t5, 0x6A
ori t5, t5, 0x83C0

origin $00002964
lui t6, 0xF66A
ori t6, t6, 0x401C

origin $00002994
lui t1, 0xF66A
ori t1, t1, 0x43BC

origin $000029A4
addiu t3, r0, 0x3A0

origin $000039A8
lui t6, 0x8060 //Depth Buffer Address

origin $000039B4
addiu t6, t6, 0x0000 //Lower Half of Depth Buffer Address

origin $000039C4
lui t8, 0x8040 //Framebuffer 1 Address

origin $000039D0
addiu t8, t8, 0 //Lower Half of Framebuffer 1 Address

origin $000039E4
lui t1, 0x8043 //Framebuffer 2 Address

origin $000039F0
addiu t1, t1, 0x1EC0 //Lower Half of Framebuffer 2 Address

origin $00003A04
lui t4, 0x8046 //Framebuffer 3 Address

origin $00003A10
addiu t4, t4, 0x3D80 //Lower Half of Framebuffer 3 Address

origin $00003C08
addiu a0, r0, 286 //BUF Text X Position

origin $0000E7B0
addiu a0, r0, 316 //X Position of ANG Text

origin $0000E7E0
addiu a0, r0, 316 //X Position of SPD Text

origin $0000E808
addiu a0, r0, 316 //X Position of STA Text

origin $00011FF0
addiu t2, r0, 398 //X Position of Names in Ending

origin $00017848
addiu a0, r0, 213 //X Position of First Line Ending Cutscene Text

origin $000178A4
addiu a0, r0, 213 //X Position of Second Line Ending Cutscene Text

origin $0001796C
addiu a0, r0, 213 //X Position of Third Line Ending Cutscene Text

origin $000179B4
addiu a0, r0, 213 //X Position of Fourth Line Ending Cutscene Text

origin $000179E8
addiu a0, r0, 213 //X Position of Fifth Line Ending Cutscene Text

origin $00017E34
addiu a0, r0, 213 //X Position of Sixth Line Ending Cutscene Text

origin $00017E84
addiu a0, r0, 213 //X Position of Seventh Line Ending Cutscene Text

origin $00017F80
addiu a0, r0, 213 //X Position of Last Line Ending Cutscene Text

origin $00018164
addiu t1, r0, 852 //Viewport Width*2 of Ending Cutscene

origin $00018180
addiu t5, r0, 852 //Viewport Offset of Ending Cutscene

origin $0001834C
addiu t9, r0, 852 //Viewport Offset Base Width*2 Shrunken Ending Viewports

origin $000183C0
addiu t3, t0, 852 //Viewport Offset Base Shrunken Ending Viewports

origin $00036478
lui t0, 0x6A
ori t0, t0, 0x83A0

origin $000364B4
lui t6, 0x6A
ori t6, t6, 0x83C0

origin $00036504
lui t2, 0x6A
ori t2, t2, 0x83A0

origin $00036590
lui t1, 0x6A
ori t1, t1, 0x83A0

origin $00037998
lui t0, 0xF66A
ori t0, t0, 0x439C

origin $000386A0
beq r0, r0, $000386B0 //Left Side Render Fix

origin $000386D4
beq r0, r0, $000386E4 //Right Side Render Fix

origin $000393A4
addiu a0, r0, 286 //MEM Text X Position

origin $00087E34
addiu a3, r0, -27 //Bottom-Left Y Coordinate of Cannon Reticule

origin $00087E74
addiu a3, r0, -27 //Bottom-Right Y Coordinate of Cannon Reticule

origin $00087EB4
addiu a3, r0, 267 //Upper-Right Y Coordinate of Cannon Reticule

origin $00087EF4
addiu a3, r0, 267 //Upper-Left Y Coordinate of Cannon Reticule

origin $00091AE8
slti at, t8, 407 //Viewport Width of Font

origin $00091AF4
addiu t9, r0, 406 //Constrain to Viewport Width-1 if Character Exceeds Font Edge

origin $000923DC
lui a2, 0x43D5 //Orthographic Size of Menu Viewport (426.0f)

origin $000957B4
lui t6, 0x69 //Scissor for Text Arrow Upper Half
ori t6, t6, 0x83B0 //Scissor for Text Arrow Lower Half

origin $00096098
lui a1, 0x4355 //X Position of Cannon Reticule Arrows (213.0f)

origin $000963D4
lui a1, 0x4059 //Width of Pause Screen Filter (3.39062f)

origin $00096708
addiu t9, r0, 396 //X Position of Red Coins on Pause Screen

origin $000968AC
addiu a3, r0, 231 //X Position of Max Coin Score from Current Course on Pause Screen

origin $000968C4
addiu a2, r0, 171 //X Position of Stars from Current Course on Pause Screen

origin $000969A8
addiu a0, r0, 115 //X Position of MY SCORE Text on Pause Screen

origin $000969E4
addiu a0, r0, 116 //X Position of COURSE Text on Pause Screen

origin $00096A04
addiu a0, r0, 153 //X Position of Course Number Text on Pause Screen

origin $00096A70
addiu a0, r0, 151 //X Position of Collected Star Icon on Pause Screen

origin $00096A88
addiu a0, r0, 151 //X Position of Uncollected Star Icon on Pause Screen

origin $00096A98
addiu a0, r0, 169 //X Position of Selected Star Name on Pause Screen

origin $00096AAC
addiu a0, r0, 170 //X Position of Current Course Name on Pause Screen

origin $00096AC8
addiu a0, r0, 147 //X Position of Course Name Text on Pause Screen for Special Courses

origin $00097514
addiu a1, r0, 176 //X Position of PAUSE Text on Pause Screen

origin $00097B84
addiu a0, r0, 158 //X Position of Pause Screen Options

origin $00097C38
addiu a0, r0, 213 //X Position of Course Statistics Box on Pause Screen

origin $00097C44
addiu a0, r0, 157 //X Position of Course Statistics on Pause Screen

origin $00097EB8
addiu a1, r0, 162 //X Position of HI SCORE Text on Level End Screen

origin $00097ED4
addiu a1, r0, 123 //X Position of CONGRAULATIONS Text on Level End Screen

origin $000982B0
addiu a0, r0, 171 //X Position of Coin Counter on Level End Screen

origin $000983B4
addiu a0, r0, 118 //X Position of COURSE Text Shadow on Level End Screen

origin $000983C4
addiu a0, r0, 157 //X Position of Course Number Text Shadow on Level End Screen

origin $00098414
addiu a0, r0, 116 //X Position of COURSE Text on Level End Screen

origin $00098424
addiu a0, r0, 155 //X Position of Course Number Text on Level End Screen

origin $0009851C
addiu a0, r0, 124 //Bowser Course Name Shadow X Position

origin $00098540
addiu a0, s0, 134 //Clear Shadow X Position on Level End Screen

origin $00098590
addiu a0, r0, 122 //Bowser Course Name X Position

origin $000985B4
addiu a0, s0, 132 //Clear X Position on Level End Screen

origin $00098600
addiu a0, r0, 171 //Coin Counter X Position on Bowser Level End Screen

origin $00098638
addiu a0, r0, 171 //X Position of Castle Secret Star Coin Counter on Level End Screen

origin $000986D8
addiu a1, r0, 108 //X Position of Star Icon on Level End Screen

origin $00098788
addiu a0, r0, 129 //X Position of Star Names Shadow on Level End Screen

origin $000987D8
addiu a0, r0, 128 //X Position of Star Names on Level End Screen

origin $00098B8C
addiu a0, r0, 153 //X Position of Options for Level End Screen

origin $0009E7B8
addiu a0, r0, 221 //X Position of Coin Icon in HUD

origin $0009E7CC
addiu a0, r0, 237 //X Position of Coin X in HUD

origin $0009E7E8
addiu a0, r0, 251 //X Position of Coin Count in HUD

origin $0009E86C
addiu a0, r0, 348 //X Position of Star Icon in HUD

origin $0009E890
addiu a0, r0, 364 //X Position of Star X in HUD

origin $0009E8B8
addiu a0, a0, 364 //X Position of Star Count in HUD

origin $0009EA20
addiu a0, r0, 276 //X Position of TIME Text in HUD

origin $0009EA34
addiu a0, r0, 335 //X Position of Minutes Timer Digit in HUD

origin $0009EA4C
addiu a0, r0, 355 //X Position of Seconds Timer Digits in HUD

origin $0009EA64
addiu a0, r0, 389 //X Position of Tenths of Seconds Timer Digit in HUD

origin $0009EAAC
addiu a0, r0, 345 //X Position of Minutes Separator in HUD

origin $0009EAC0
addiu a0, r0, 380 //X Position of Seconds Separator in HUD

origin $0009EB58
addiu t6, r0, 372 //X Position of Camera Icons

origin $000E8B30
dh 852 //Size of Menu Viewport

origin $000E8B30
dh 852 //Left Edge of Menu Viewport

origin $000E8E60
dh 852 //Size of Ingame Orthographic Viewport

origin $000E8E68
dh 852 //Left Edge of Ingame Orthographic Viewport

origin $000ED5F2
dh 193 //X Position of Health Meter

origin $000F00B8
dw 426 //Framebuffer Width

origin $000F00D0
dw 681 //Framebuffer Width * 512/320

origin $000F00D8
dw 852 //Framebuffer Offset

origin $000FBB00
lui a0, 0x8060 //Depth Buffer Address for Clearing

origin $000FBB04
li a1, 204480 //Depth Buffer Size

origin $000FBB10
addiu a0, a0, 0x0000 //Lower Half of Depth Buffer Address for Clearing

origin $000FBB14
lui a0, 0x8040 //Framebuffers Address for Clearing

origin $000FBB18
li a1, 613440 //Size of All 3 Framebuffers Combined

origin $000FBB24
addiu a0, a0, 0 //Lower Half of Framebuffer Address

origin $00112E3F
db 148 //X Position of Center Aligned Textboxes

origin $00112E67
db 148 //X Position of More Center Aligned Textboxes

origin $00112ED1
db 255 //X Position of Right Aligned Textboxes

origin $0021F7A8
addiu a0, r0, 213 //X Position of SELECT STAGE Text in Level Select

origin $0021F7BC
addiu a0, r0, 213 //X Position of PRESS START BUTTON Text in Level Select

origin $0021F7D8
addiu a0, r0, 93 //X Position of Course Number Selected in Level Select

origin $0021F800
addiu a0, r0, 133 //X Position of Course Name in Level Select

origin $0022451C
addiu a1, r0, 146 //X Position of SELECT FILE Text

origin $0022452C
addiu a1, r0, 145 //X Position of File A Star Count

origin $0022453C
addiu a1, r0, 262 //X Position of File B Star Count

origin $0022454C
addiu a1, r0, 145 //X Position of File C Star Count

origin $0022455C
addiu a1, r0, 262 //X Position of File D Star Count

origin $00224618
addiu a0, r0, 105 //X Position of SCORE Text

origin $0022462C
addiu a0, r0, 170 //X Position of COPY Text

origin $00224640
addiu a0, r0, 230 //X Position of ERASE Text

origin $00224664
addiu a0, r0, 307 //X Position of Current Sound Option Text

origin $00224750
addiu a0, r0, 145 //X Position of MARIO A Text

origin $00224764
addiu a0, r0, 260 //X Position of MARIO B Text

origin $00224778
addiu a0, r0, 145 //X Position of MARIO C Text

origin $0022478C
addiu a0, r0, 260 //X Position of MARIO D Text

origin $00224820
addiu a1, r0, 148 //X Position of CHECK FILE Text in File Score Check Menu

origin $0022483C
addiu a0, r0, 152 //X Position of NO SAVED DATA EXISTS Text in File Score Check Menu

origin $00224954
addiu a1, r0, 143 //X Position of File A Star Count in File Score Check Menu

origin $00224964
addiu a1, r0, 264 //X Position of File B Star Count in File Score Check Menu

origin $00224974
addiu a1, r0, 143 //X Position of File C Star Count in File Score Check Menu

origin $00224984
addiu a1, r0, 264 //X Position of File D Star Count in File Score Check Menu

origin $00224A40
addiu a0, r0, 97 //X Position of RETURN Text in File Score Check Menu

origin $00224A54
addiu a0, r0, 188 //X Position of COPY FILE Text in File Score Check Menu

origin $00224A68
addiu a0, r0, 284 //X Position of ERASE FILE Text in File Score Check Menu

origin $00224B24
addiu a0, r0, 142 //X Position of MARIO A Text in File Score Check Menu

origin $00224B38
addiu a0, r0, 264 //X Position of MARIO B Text in File Score Check Menu

origin $00224B4C
addiu a0, r0, 142 //X Position of MARIO C Text in File Score Check Menu

origin $00224B60
addiu a0, r0, 264 //X Position of MARIO D Text in File Score Check Menu

origin $00224C28
addiu a0, r0, 157 //X Position of COPY FILE Text in Copy File Menu

origin $00224C44
addiu a0, r0, 162 //X Position of COPY IT TO WHERE? Text in Copy File Menu

origin $00224C60
addiu a0, r0, 154 //X Position of NO SAVED DATA EXISTS Text in Copy File Menu

origin $00224C7C
addiu a0, r0, 163 //X Position of NO COPYING COMPLETED Text in Copy File Menu

origin $00224F04
addiu a1, r0, 143 //X Position of File A Star Count in Copy File Menu

origin $00224F14
addiu a1, r0, 264 //X Position of File B Star Count in Copy File Menu

origin $00224F24
addiu a1, r0, 143 //X Position of File C Star Count in Copy File Menu

origin $00224F34
addiu a1, r0, 264 //X Position of File D Star Count in Copy File Menu

origin $00224FF0
addiu a0, r0, 97 //X Position of RETURN Text in Copy File Menu

origin $00225004
addiu a0, r0, 181 //X Position of CHECK SCORE Text in Copy File Menu

origin $00225018
addiu a0, r0, 283 //X Position of ERASE FILE Text in Copy File Menu

origin $002250D4
addiu a0, r0, 142 //X Position of MARIO A in Copy File Menu

origin $002250E8
addiu a0, r0, 264 //X Position of MARIO B in Copy File Menu

origin $002250FC
addiu a0, r0, 142 //X Position of MARIO C in Copy File Menu

origin $00225110
addiu a0, r0, 264 //X Position of MARIO D in Copy File Menu

origin $00225194
addiu t0, t9, 17 //X Offset of Collision for YES/NO Text in Erase File Menu

origin $00225814
addiu a1, r0, 151 //X Position of ERASE FILE text in Erase File Menu

origin $0022582C
addiu a0, r0, 143 //X Position of SURE? Text in Erase File Menu

origin $0022583C
addiu a0, r0, 143 //X Position of YES/NO Text in Erase File Menu

origin $00225850
addiu a0, r0, 153 //X Position of NO SAVED DATA EXISTS Text

origin $0022587C
addiu a0, r0, 153 //X Position of MARIO %s JUST ERASED Text

origin $00225AFC
addiu a1, r0, 143 //X Position of File A Star Count in Erase File Menu

origin $00225B0C
addiu a1, r0, 264 //X Position of File B Star Count in Erase File Menu

origin $00225B1C
addiu a1, r0, 143 //X Position of File C Star Count in Erase File Menu

origin $00225B2C
addiu a1, r0, 264 //X Position of File D Star Count in Erase File Menu

origin $00225BE8
addiu a0, r0, 97 //X Position of RETURN Text in Erase File Menu

origin $00225BFC
addiu a0, r0, 180 //X Position of CHECK SCORE Text in Erase File Menu

origin $00225C10
addiu a0, r0, 286 //X Position of COPY FILE Text in Erase File Menu

origin $00225CCC
addiu a0, r0, 142 //X Position of MARIO A Text in Erase File Menu

origin $00225CE0
addiu a0, r0, 264 //X Position of MARIO B Text in Erase File Menu

origin $00225CF4
addiu a0, r0, 142 //X Position of MARIO C Text in Erase File Menu

origin $00225D08
addiu a0, r0, 264 //X Position of MARIO D Text in Erase File Menu

origin $00225E0C
addiu a1, r0, 141 //X Position of SOUND SELECT Text

origin $00225F44
addiu a0, a0, 140 //Position of Sound Options in Sound Select

origin $00223FB8
lui at, 0x4355 //Viewport Offset of File Select Cursor

origin $002263D4
addiu a1, r0, 78 //X Position of MARIO on File Statistics Screen

origin $002263E8
addiu a1, r0, 148 //X Position of File Letter on File Statistics Screen

origin $002263FC
addiu a1, r0, 177 //X Position of Star Count on File Statistics Screen

origin $002264C0
addu s0, r0, r0 //Loop Counter
coursestatloop:
lw t5, 64(sp) //Course Name Offset in Pointer Table
jal 0x80277F50 //SegmentedtoVirtual
lw a0, 0(t5) //Read Table Entry for Course Name Offset
sll a0, s0, 3 //Multiply Course ID by 8
sll a1, s0, 2 //Multiply Course ID by 4
addu k1, a1, a0 //Add Previous 2 Operations
addiu k1, k1, 35  //Y Position of Course Statistics Line Start
addu a1, k1, 0 //Y Position of Course Name Text
addiu a0, r0, 79 //X Position of Course Name Text
jal 0x802D7E88 //Print the Course Names Pointed to by A2
addu a2, v0, r0
lb a0, 0x6B(sp) //Not Sure WTF this is for
addu a1, s0, r0 //Get Course ID 
addiu a2, r0, 224 //X Position of Course Star Statistics
jal 0x80175D2C //Call PrintCourseStars
addu a3, k1, r0 //Y Position of Course Star Statistics
lb a0, 0x6B(sp) //Not Sure WTF this is for either
addu a1, s0, r0 //Get Course ID For Printing the Coin Statistics
addiu a2, r0, 266 //X Position of Course Coin Statistics
jal 0x80175B90 //Call PrintCourseCoinStat
addu a3, k1, r0 //Y Position of Course Coin Statistics
lw t5, 64(sp)
addiu t5, t5, 4 //Get to Next Entry in Pointer Table
sw t5, 64(sp)
addiu s0, s0, 1 //Current Course Number
addiu at, r0, 15 //Number of Courses
bne s0, at, coursestatloop //Has Course 15 been Reached
nop //Delay Slot
lw t5, 64(sp)
addiu t5, t5, -60 //Restore Change to Pointer Table Pointer
j 0x80176428 //Return to Original Function
sw t5, 64(sp) //Update Pointer Table Pointer

origin $002268FC
addiu a0, r0, 82 //CASTLE SECRET STARS Text X Position

origin $0022690C
addiu a1, r0, 224 //Castle Secret Stars Number Text X Position

origin $00226928
addiu a0, r0, 291 //MY SCORE Text X Position

origin $00226940
addiu a0, r0, 284 //HI SCORE Text X Position

origin $00227490
lui a1, 0x4353 //X Position of COURSE Face on Star Select (211.0f)

origin $0022758C
addiu a1, r0, 205 //X Position of Course Number on Low Course Numbers on Star Select

origin $002275A8
addiu a1, r0, 196 //X Position of Course Number on High Course Numbers on Star Select

origin $002276FC
addiu a3, r0, 208 //X Position of Coin High Score on Star Select

origin $002277C8
addiu a0, r0, 155 //X Position of MY SCORE on Star Select

origin $002277DC
addiu a0, r0, 213 //X Position of Course Name on Star Select

origin $002278EC
addiu a0, r0, 216 //X Position of Star Name on Course Select

origin $00227958
addiu a0, a0, 192 //X Position of Star Numbers on Course Select

origin $0024CACC
addiu t6, r0, 426 //Viewport Width of Mario Face in Attract Demo

origin $00255D78
addiu t4, r0, 426 //Viewport Width of Cursor in Attract Demo

origin $00255EBC
addiu t0, r0, 213 //Starting Position of Cursor in Attract Demo

origin $0026A174
dh 213 //Viewport Offset on Title Screen

origin $0026A178
dh 213 //Viewport Width/2 on Title Screen

origin $0026A200
dh 213 //Background Viewport Offset on Attract Screen

origin $0026A204
dh 213 //Background Viewport Width/2 on Attract Screen

origin $0026A2B8
dh 213 //Viewport Offset on Level Select Screen

origin $0026A2BC
dh 213 //Viewport Width/2 on Level Select Screen

origin $002A64A4
dh 213 //Viewport Offset on File Select Screen

origin $002A64A8
dh 213 //Viewport Width/2 on File Select Screen

origin $002A652C
dh 213 //Viewport Offset on Star Select Screen

origin $002A6530
dh 213 //Viewport Width/2 on Star Select Screen

origin $003837C4
dh 213 //Viewport Offset Inside Princess Peach's Castle

origin $003837C8
dh 213 //Viewport Width/2 Inside Princess Peach's Castle

origin $003961C0
dh 213 //Viewport Offset Cool Cool Mountain

origin $003961C4
dh 213 //Viewport Width/2 Cool Cool Mountain

origin $0039628C
dh 213 //Viewport Offset Cool Cool Mountain Slide

origin $00396290
dh 213 //Viewport Width/2 Cool Cool Mountain Slide

origin $003D04D4
dh 213 //Viewport Offset Inside Princess Peach's Castle

origin $003D04D8
dh 213 //Viewport Width/2 Inside Princess Peach's Castle

origin $003D092C
dh 213 //Viewport Offset Upper Floor Princess Peach's Castle

origin $003D0930
dh 213 //Viewport Width/2 Upper Floor Princess Peach's Castle

origin $003D0CE4
dh 213 //Viewport Offset Basement Princess Peach's Castle

origin $003D0CE8
dh 213 //Viewport Width/2 Basement Princess Peach's Castle

origin $003E7594
dh 213 //Viewport Offset Hazy Maze Cave

origin $003E7598
dh 213 //Viewport Width/2 Hazy Maze Cave

origin $003FBFDC
dh 213 //Viewport Offset Shifting Sand Land

origin $003FBFE0
dh 213 //Viewport Width/2 Shifting Sand Land

origin $003FC160
dh 213 //Viewport Offset Shifting Sand Land Inside Pyramid

origin $003FC164
dh 213 //Viewport Width/2 Shifting Sand Land Inside Pyramid

origin $003FC220
dh 213 //Viewport Offset Shifting Sand Land Eyerok Room

origin $003FC224
dh 213 //Viewport Width/2 Shifting Sand Land Eyerok Room

origin $00405EEC
dh 213 //Viewport Offset Bob Omb Battlefield

origin $00405EF0
dh 213 //Viewport Width/2 Bob Omb Battlefield

origin $0040EBEC
dh 213 //Viewport Offset Snowman's Land

origin $0040EBF0
dh 213 //Viewport Width/2 Snowman's Land

origin $0040ECC8
dh 213 //Viewport Offset Snowman's Land Igloo

origin $0040ECCC
dh 213 //Viewport Width/2 Snowman's Land Igloo

origin $0041A5EC
dh 213 //Viewport Offset Wet Dry World

origin $0041A5F0
dh 213 //Viewport Width/2 Wet Dry World

origin $0041A6B8
dh 213 //Viewport Offset Wet Dry World Downtown

origin $0041A6BC
dh 213 //Viewport Width/2 Wet Dry World Downtown

origin $0042453C
dh 213 //Viewport Offset Jolly Roger Bay

origin $00424540
dh 213 //Viewport Width/2 Jolly Roger Bay

origin $00424620
dh 213 //Viewport Offset Jolly Roger Bay Inside Ship

origin $00424624
dh 213 //Viewport Width/2 Jolly Roger Bay Inside Ship

origin $0042CCEC
dh 213 //Viewport Offset Tiny Huge Island Big Island

origin $0042CCF0
dh 213 //Viewport Width/2 Tiny Huge Island Big Island

origin $0042CDB8
dh 213 //Viewport Offset Tiny Huge Island Little Island

origin $0042CDBC
dh 213 //Viewport Width/2 Tiny Huge Island ittle Island

origin $0042CE80
dh 213 //Viewport Offset Tiny Huge Island Cave

origin $0042CE84
dh 213 //Viewport Width/2 Tiny Huge Island Cave

origin $004377BC
dh 213 //Viewport Offset Tick Tock Clock

origin $004377C0
dh 213 //Viewport Width/2 Tick Tock Clock

origin $0044AB14
dh 213 //Viewport Offset Rainbow Ride

origin $0044AB18
dh 213 //Viewport Width/2 Rainbow Ride

origin $00454D20
dh 213 //Viewport Offset Outside Princess Peach's Castle

origin $00454D24
dh 213 //Viewport Width/2 Outside Princess Peach's Castle

origin $0045C57C
dh 213 //Viewport Offset Bowser in the Dark World

origin $0045C580
dh 213 //Viewport Width/2 Bowser in the Dark World

origin $0046142C
dh 213 //Viewport Offset Vanish Cap Under the Moat

origin $00461430
dh 213 //Viewport Width/2 Vanish Cap Under the Moat

origin $0046AFE4
dh 213 //Viewport Offset Bowser in the Fire Sea

origin $0046AFE8
dh 213 //Viewport Width/2 Bowser in the Fire Sea

origin $0046C314
dh 213 //Viewport Offset The Secret Aquarium

origin $0046C318
dh 213 //Viewport Width/2 The Secret Aquarium

origin $0047841C
dh 213 //Viewport Offset Bowser in the Sky

origin $00478420
dh 213 //Viewport Width/2 Bowser in the Sky

origin $0048D7B4
dh 213 //Viewport Offset Lethal Lava Land

origin $0048D7B8
dh 213 //Viewport Width/2 Lethal Lava Land

origin $0048D874
dh 213 //Viewport Offset Lethal Lava Land Inside Volcano

origin $0048D878
dh 213 //Viewport Width/2 Lethal Lava Land Inside Volcano

origin $00495F24
dh 213 //Viewport Offset Dire Dire Docks

origin $00495F28
dh 213 //Viewport Width/2 Dire Dire Docks

origin $00495FD4
dh 213 //Viewport Offset Dire Dire Docks Part 2

origin $00495FD8
dh 213 //Viewport Width/2 Dire Dire Docks Part 2

origin $0049E64C
dh 213 //Viewport Offset Whomp's Fortress

origin $0049E650
dh 213 //Viewport Width/2 Whomp's Fortress

origin $004AC504
dh 213 //Viewport Offset Peach's Cake Scene

origin $004AC508
dh 213 //Viewport Width/2 Peach's Cake Scene

origin $004AF88C
dh 213 //Viewport Offset Castle Courtyard

origin $004AF890
dh 213 //Viewport Width/2 Castle Courtyard

origin $004B8014
dh 213 //Viewport Offset Princess Peach's Slide

origin $004B8018
dh 213 //Viewport Width/2 Princess Peach's Slide

origin $004BEB84
dh 213 //Viewport Offset Cavern of the Metal Cap

origin $004BEB88
dh 213 //Viewport Width/2 Cavern of the Metal Cap

origin $004C288C
dh 213 //Viewport Offset Tower of the Wing Cap

origin $004C2890
dh 213 //Viewport Width/2 Tower of the Wing Cap

origin $004C4294
dh 213 //Viewport Offset First Bowser Battle

origin $004C4298
dh 213 //Viewport Width/2 First Bowser Battle

origin $004CDB24
dh 213 //Viewport Offset Wing Mario Over the Rainbow

origin $004CDB28
dh 213 //Viewport Width/2 Wing Mario Over the Rainbow

origin $004CEB7C
dh 213 //Viewport Offset Second Bowser Battle

origin $004CEB80
dh 213 //Viewport Width/2 Second Bowser Battle

origin $004D188C
dh 213 //Viewport Offset Third Bowser Battle

origin $004D1890
dh 213 //Viewport Width/2 Third Bowser Battle

origin $004EBC64
dh 213 //Viewport Offset Tall Tall Mountain

origin $004EBC68
dh 213 //Viewport Width/2 Tall Tall Mountain

origin $004EBD50
dh 213 //Viewport Offset Tall Tall Mountain Slide Beginning

origin $004EBD54
dh 213 //Viewport Width/2 Tall Tall Mountain Slide Beginning

origin $004EBDE0
dh 213 //Viewport Offset Tall Tall Mountain Slide Middle

origin $004EBDE4
dh 213 //Viewport Width/2 Tall Tall Mountain Slide Middle

origin $004EBE78
dh 213 //Viewport Offset Tall Tall Mountain Slide End

origin $004EBE7C
dh 213 //Viewport Width/2 Tall Tall Mountain Slide End