// N64 "Star Wars Episode I - Racer" Widescreen Hack by gamemasterplc:

arch n64.cpu
endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "Star Wars Episode I - Racer WS.z64", create
origin $00000000; insert "Star Wars Episode I - Racer (U) [!].z64" // Include USA Star Wars Episode I - Racer N64 ROM
origin $00000020
db "STAR WARS EP1 RACER WS     " // $00000020 - PROGRAM TITLE (27 Byte ASCII String, Use Spaces For Unused Bytes)

include "LIB/N64.INC" // Include N64 Definitions

origin $00086BC4

addiu a1, r0, 418 //Camera Y FOV

origin $00086BFC

lui at, $3F25 //Camera tan(x/2) FOV Multiplier

origin $00012B40

addiu t7, r0, 240 //Text View Width

origin $00012BDC

addiu a0, a0, 53 //Move Text View Right 53 Pixels
beq r0, r0, $00012BF0 //Unrestricted Text View Width

origin $0003E108

j $800A82B0 //Jump to Sprite Corrections

origin $000A8EB0 //Freespace

spritecorrections:
mtc1 a3, f14
lui k1, $3F40 //Sprite Size Multiplier
mtc1 k1, f0
nop
mul.s f14, f14, f0
sra at, a1, 2
sra a1, a1, 1
addu a1, a1, at //Multiply Sprite Position by 3/4
j $8003D510
addiu a1, a1, 40 //Center Sprites

origin $0000B1D0
lui at, 0x41D5 //Sun Effect Width (26.6f)

origin $0000B214
addiu a1, r0, -53 //Sun Effect Position

origin $0000B324
lui at, 0x41D5 //Fadeout Width (26.6f)

origin $0000B368
addiu a1, r0, -53 //Fadeout Position

origin $0000B398
lui at, 0x41D5 //Fadein Width (26.6f)

origin $0000B3D8
addiu a1, r0, -53 //Fadein Position

origin $0001B290
addiu a1, r0, -53 //Title Screen Background Position

origin $0001B2A0
lui a1, 0x3F2A //Title Screen Background Width (0.66f)

origin $0001B4CC
lui at, 0x43D5 //Title Screen RACER Source Position (426.6f)

origin $00058AEC
addiu a1, r0, -53 //2P Splitscreen Black Bar Position

origin $00058AFC
lui a1, 0x43D5 //2P Splitscreen Black Bar Width (426.6f)

origin $0005631C
lui at, 0x4496 //2P Player Course Position Scale (1200.0f)

origin $00056420
lui at, 0xC204 //2P Racer Course Position Offset (-33.0f)

origin $00056494
lui at, 0xC204 //2P Racer Course Position Offset (-33.0f)

origin $000580C4
lui at, 0x4399 //Speed Numbers X Position (306.0f)

origin $00058A48
addiu a2, r0, 278 //Boost Meter X Position

origin $000578D4
addiu t9, r0, 282 //Speed Meter Background X Position

origin $00057BBC
addiu t0, r0, 328 //Speed Meter Top X Position

origin $00058870
lui at, 0xC135 //Lap Counter X Position (-11.3f)

origin $000589F8
addiu a0, r0, 331 //x/y Place X Position

origin $00058A28
addiu a0, r0, 331 //Position Icon X Position

origin $000587F0
addiu a0, r0, 342 //2P Timer X Position

origin $000ADAE0
dw $43900AAB //Map Background X Position

origin $00055D88
lui at, 0x439E //Map Path X Position (316.0f)

origin $000560A8
lui at, 0x439E //Map Enemies Location X Position (316.0f)

origin $0005609C
lui at, 0x439E //Map Enemies Crosses X Position (316.0f)

origin $0005622C
lui at, 0x439E //Map Your Location X Position (316.0f)

origin $0005622C
lui at, 0x439E //Map Your Location X Position (316.0f)

origin $00055F18
lui at, 0x439E //Map Finish Line Location X Position (316.0f)

origin $0005A548
lui at, 0xC0A0 //Machine Status Indicators X Position (-5.0f)

origin $0005A87C
lui at, 0xC0A0 //Machine Status Indicator Borders X Position (-5.0f)

origin $00057498
addiu a1, r0, -53 //Status Bar Background and Top Border X Position

origin $000574BC
lui a1, 0x43D5 //Status Bar Top Border Width (426.6f)

origin $00057534
lui a1, 0x42D5 //Status Bar Background Width (106.6f)

origin $00057580
lui at, 0xC20D //Leftmost Status Bar Dip X Position (-35.25f)

origin $000575D8
lui at, 0xC0AA //Leftmost Status Bar Dash X Position (-5.3125f)

origin $00057640
lui a1, 0x4240 //Leftmost Status Bar Dash Width (48.0f)

origin $00057704
lui a1, 0x4248 //Rightmost Status Bar Dash Width (50.0f)

origin $0005774C
lui at, 0x439A //Rightmost Status Bar Dip Position (308.0f)

origin $0000F424
lui at, 0x43D5 //Player Indicator Numbers Viewport Width (426.6f)

origin $0000F48C
addiu a0, a0, -53 //Player Indicator Numbers X Offset

origin $0000F2B0
lui at, 0x43D5 //Sun+Parts Viewport Width (426.6f)

origin $0000F300
addiu a1, a1, -53 //Sun+Parts X Offset

origin $0005AC38
addiu a0, r0, -28 //Lap Text on Result Screen X Position

origin $0005AC7C
addiu a0, r0, -8 //Lap Numbers on Result Screen X Position

origin $0005AB88
addiu t8, r0, 52 //Lap Times on Result Screen X Position

origin $0005B1E0
addiu a0, r0, -28 //Total Text on Result Screen X Position

origin $0002C4B0
addiu a1, r0, -28 //Button Icons X Position Vehicle Inspection

origin $0002C484
addiu t3, r0, -28 //Zoom In and Out Text X Position Vehicle Inspection

origin $0002C574
addiu t2, t8, -26 //Change Subject and Move Camera Text X Position Vehicle Inspection

origin $0001ABB0
addiu a0, r0, -23 //EXPANSION PAK SUPPORTED Text X Position

origin $0001ABD4
addiu a0, r0, -23 //EXPANSION PAK NOT DETECTED Text X Position

origin $0001AB84
addiu a0, r0, -23 //EXPANSION PAK ENHANCED Text X Position

origin $0001AB48
addiu a0, r0, -23 //LICENSED TO NINTENDO Text X Position

origin $0001AB20
addiu a0, r0, -23 //Second USED UNDER AUTHORIZATION. Text X Position

origin $0001AAF8
addiu a0, r0, -23 //TRADEMARK OF LUCASFILM LTD., Text X Position

origin $0001AAD0
addiu a0, r0, -23 //THE LUCASARTS LOGO IS A REGISTERED Text X Position

origin $0001AAA8
addiu a0, r0, -23 //First USED UNDER AUTHORIZATION. Text X Position

origin $0001AA80
addiu a0, r0, -23 //Second Copyright Text X Position

origin $0001AA58
addiu a0, r0, -23 //First Copyright Text X Position

origin $0001AA10
addiu a0, r0, -23 //Game Name (Copyright Screen) X Position

origin $0001ABDC
addiu a1, r0, 127 //Expansion Pak Icon X Position

origin $0001C15C
lui a1, 0x431E //SELECT VEHICLE Statistics X Position (158.0f)

origin $00048A38
lui a1, 0xC205 //VEHICLE UPGRADES Statistics X Position (-33.25f)

origin $00048A38
addiu a0, r0, -23 //VEHICLE UPGRADES Part Names X Position

origin $0001EDA0
addiu a1, r0, 7 //MAIN MENU Choices X Position

origin $00048A38
lui at, 0xC205 //BUY PARTS Statistics X Position (-33.25f)

origin $00024E60
lui a1, 0xC205 //JUNKYARD Statistics X Position (-33.25f)

origin $00056E80
addiu a0, r0, 297 //BOOST Text X Position

origin $00056D78
addiu a1, r0, 300 //BOOST A Button X Position

origin $00059B10
lui at, 0xC1EA //Most Machine Status Messages X Position (-29.25f)

origin $00059A74
lui at, 0xC1EA //ENGINE FIRE Text X Position (-29.25f)