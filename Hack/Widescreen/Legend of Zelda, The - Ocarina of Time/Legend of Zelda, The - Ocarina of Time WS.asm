// N64 "Ocarina of Time" Widescreen Hack by gamemasterplc:
// Special thanks to Zoinkity for his Aegh decompressor

arch n64.cpu
endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "Legend of Zelda, The - Ocarina of Time WS.z64", create
origin $00000000; insert "Legend of Zelda, The - Ocarina of Time (U) (V1.2) (Decompressed).z64" // Include Decompressed 1.2 Legend of Zelda, The - Ocarina of Time ROM
origin $00000020
db "THE LEGEND OF ZELDA WS     " // $00000020 - PROGRAM TITLE (27 Byte ASCII String, Use Spaces For Unused Bytes)

include "LIB/N64.INC" // Include N64 Definitions

constant SCREEN_WIDTH(424)
constant SCREEN_HEIGHT(240)
constant BYTES_PER_PIXEL(2)
constant EXPANSION_RAM_SIZE(8388608)
constant DEFAULT_RAM_SIZE(4194304)

origin $00007548
dw SCREEN_WIDTH //VI_WIDTH Register

origin $00007560
dw (SCREEN_WIDTH*512)/320 //VI_X_SCALE Register

origin $00007568
dw SCREEN_WIDTH*2 //VI_ORIGIN Offset

origin $00A8A418
lui at, 0xC3D4 //Minimum X Position of Z Targeting Target (-424.0f)

origin $00A8A424
lui at, 0x4354 //X Position Scale of Z Targeting Target (212.0f)

origin $00A8A42C
lui at, 0x43D4 //Maximum X Position of Z Targeting Target  (424.0f)

origin $00A8AFC4
addiu a3, a3, ((SCREEN_WIDTH-320)/2) //Center Boss Names
nop //Pad Code to Original Space

origin $00A8D384
lui at, 0x4354 //3D to 2D X Position Scale  (212.0f)

origin $00A8EF4C
li t9, ($E4000000|SCREEN_WIDTH << 14|SCREEN_HEIGHT << 2) //Lens of Truth Texture Rectangle

origin $00A8EF68
li t8, (1408 << 16|1600) //Texture Coordinates for Lens of Truth Texture Rectangle

origin $00ABD158
addiu a3, r0, (SCREEN_WIDTH/2) //X Position of Area Names in Dungeon Intros

origin $00AC6768
addiu t6, r0, SCREEN_WIDTH*2 //Line Offset for Reading Depth Buffer
multu t6, a1 //Calculate Line Offset for Depth Buffer Read
mflo t6 //Get Line Offset for Depth Buffer Read
sll t7, a0, 1 //Get Pixel Offset on Line of Depth Buffer
addu t8, t6, t7 //Get Offset of Current Pixel of Depth Buffer
li v1, ($80000000|DEFAULT_RAM_SIZE) //Depth Buffer Address
addu v1, v1, t8 //Get Address of Current Pixel of  Depth Buffer
jr ra //Return to Caller
lhu v0, 0(v1) //Read Pixel of Depth Buffer

origin $00ACA6FC
lui at, 0x43D4 //Viewport Width for Lens Flare Check  (424.0f)

origin $00ACAF84
li t7, ($F6000000|SCREEN_WIDTH-1 << 14|SCREEN_HEIGHT-1 << 2) //Sun Filter Fill Rectangle

origin $00ACB7AC
li t0, ($F6000000|SCREEN_WIDTH-1 << 14|SCREEN_HEIGHT-1 << 2) //Weather Effect Background Fill Rectangle

origin $00ACCF3C
li t0, ($F6000000|SCREEN_WIDTH-1 << 14|SCREEN_HEIGHT-1 << 2) //Intro Start Background Fill Rectangle

origin $00ACD01C
li t9, ($F6000000|SCREEN_WIDTH-1 << 14|SCREEN_HEIGHT-1 << 2) //Intro Fades Fill Rectangle

origin $00AD01B8
lui at, 0xC336 //X Position of Beating Heart (-182.0f)

origin $00AD110C
li r30, ($80000000|DEFAULT_RAM_SIZE) //Depth Buffer Address for Corona Check

origin $00AD1130
lui at, 0x4354 //Viewport Width for Corona Check  (212.0f)

origin $00AD123C
addiu t3, r0, SCREEN_WIDTH*2 //Width of Line for Corona Check
multu t3, t2 //Calculate Offset of Current Line for Corona Check
mflo t3 //Get Offset of Current Line for Corona Check

origin $00AD1BC0
addiu a0, a0, SCREEN_WIDTH-116 //X Offset for Dungeon Map Icons

origin $00AD69F4
j $80106730 //Call Function to Adjust Dungeon Minimap Arrows

origin $00AD7CD8
addiu t7, v0, 8 //Run a Replaced Opcode
sw t7, 688(a1) //Run another Replaced Opcode
li t6, ($E4000000|(SCREEN_WIDTH-50)+8 << 14|(SCREEN_HEIGHT-86)+8 << 2) //Lower-Right of Zora's Fountain Dungeon Icon
li t8, ((SCREEN_WIDTH-50) << 14|SCREEN_HEIGHT-86 << 2) //Upper-Left of Zora's Fountain Dungeon Icon

origin $00ADE840
addiu t7, t0, 8 //Run a Replaced Opcode
sw t7, 688(s1) //Run another Replaced Opcode
li t6, ($E4000000|(SCREEN_WIDTH-188)+22 << 14|(17+22) << 2) //Lower-Right of Start Button
li t9, ((SCREEN_WIDTH-188) << 14|(17) << 2) //Upper-Left of Start Button

origin $00ADFF28
addiu t7, r0, SCREEN_WIDTH //Viewport Width of Scaling/Rotating 2D Elements

origin $00AE3438
addiu t5, r0, ((SCREEN_WIDTH/2)-20) //Starting X Position of Timer

origin $00AEA59C
addiu t9, r0, ((SCREEN_WIDTH-320)*2) //X Position of Left Edge of Prerendered Background

origin $00AE9970
li t1, ($80000000|DEFAULT_RAM_SIZE) //Depth Buffer Address for RDP

origin $00AFC0DC
addiu t7, r0, SCREEN_WIDTH //Viewport Width of Main Menu

origin $00AFE94C
lui at, ($E400|SCREEN_WIDTH >> 2) //Upper-Half of Sepia Effect Texture Rectangle

origin $00B06E58
li t7, ($80000000|DEFAULT_RAM_SIZE) //Background Texture Address for Pause Screen

origin $00B06D64
addiu t9, r0, SCREEN_WIDTH //Fadeout View Width

origin $00B06E70
addiu a1, r0, SCREEN_WIDTH //Framebuffer Width for Pause Screen

origin $00B07274
li t7, ($80000000|DEFAULT_RAM_SIZE) //Depth Buffer Copy Address for Pause Screen

origin $00B072D4
addiu t7, r0, 3 //Skip Stage 2 of Pause to Fix Random Freezes

origin $00B07954
lui at, 0x4354 //Viewport Width for Alternate 3D to 2D Conversion  (212.0f)

origin $00B096F4
nop //Fix Display List Buffer Overflow on Pause Screen

origin $00B0B2EC
lui a3, (($80000000|DEFAULT_RAM_SIZE) >> 16) //Depth Buffer Address Upper-Half for Segment Addressing

origin $00B0B32C
ori a3, a3, (($80000000|(DEFAULT_RAM_SIZE)) & 0xFFFF) //Depth Buffer Address Lower-Half for Segment Addressing

origin $00B0C544
addiu t6, r0, SCREEN_WIDTH //Framebuffer Width for Video

origin $00B0EAE0
nop //Move Framebuffers to Expansion Pak RAM

origin $00B0EAF0
lui t6, (($80000000|EXPANSION_RAM_SIZE) >> 16) //End of Last Framebuffer in RAM

origin $00B0EB50
li at, (0-(SCREEN_WIDTH*SCREEN_HEIGHT*BYTES_PER_PIXEL*2)) //Offset of First Framebuffer from End of RAM

origin $00B0EB68
li at, (0-(SCREEN_WIDTH*SCREEN_HEIGHT*BYTES_PER_PIXEL)) //Offset of Second Framebuffer from End of RAM

origin $00B18008
addiu a0, a0, ((SCREEN_WIDTH-320)/2) //X Offset of Crash Handler Boxes

origin $00B1817C
addiu a0, a0, ((SCREEN_WIDTH-320)/2) //X Offset of Crash Handler Text

origin $00B19F00
addiu a0, r0, 30 //X Position of First Line of Crash Cause Text

origin $00B19F18
addiu a0, r0, 30 //X Position of Second Line of Crash Cause Text

origin $00B19F38
addiu a0, r0, 30 //X Position of Third Line of Crash Cause Text

origin $00B40C2C
addiu t3, r0, (48+((SCREEN_WIDTH-320)/2)) //X Position of Selection Cursor in Textbox

origin $00B47138
addiu t9, r0, (20+((SCREEN_WIDTH-320)/2)) //X Position of Credits Text

origin $00B47178
addiu t9, r0, (50+((SCREEN_WIDTH-320)/2)) //X Position of Japanese Text in Textbox

origin $00B47198
addiu t6, r0, (65+((SCREEN_WIDTH-320)/2)) //X Position of English Text in Textbox

origin $00B47A04
addiu t7, r0, (34+((SCREEN_WIDTH-320)/2)) //X Position of Song Textbox Background

origin $00B4C7E4
addiu v0, r0, (SCREEN_WIDTH-160) //X Position of B Button and Item Icon

origin $00B4C7F4
addiu t2, r0, (SCREEN_WIDTH-158) //X Position of B Button Item Quantity

origin $00B4C7F8
addiu v1, r0, (SCREEN_WIDTH-134) //X Position of A Button

origin $00B4CD88
addiu t8, r0, SCREEN_WIDTH-198 //X Position of Start Button Text in Japanese

origin $00B4CD94
addiu t6, r0, SCREEN_WIDTH-200 //X Position of Start Button Text in English

origin $00B4CBD4
addiu t6, r0, SCREEN_WIDTH-73 //X Position of C-Up Navi Text

origin $00B4CDB8
addiu t9, r0, SCREEN_WIDTH-66 //X Position of C-Up Button

origin $00B4CDE4
addiu t9, r0, SCREEN_WIDTH-93 //X Position of C-Left Button

origin $00B4CDF0
addiu t7, r0, SCREEN_WIDTH-71 //X Position of C-Down Button

origin $00B4CDFC
addiu t9, r0, SCREEN_WIDTH-49 //X Position of C-Right Button

origin $00B4CE5C
addiu t9, r0, SCREEN_WIDTH-93 //X Position of C-Left Item Icon

origin $00B4CE68
addiu t7, r0, SCREEN_WIDTH-71 //X Position of C-Down Item Icon

origin $00B4CE74
addiu t9, r0, SCREEN_WIDTH-49 //X Position of C-Right Item Icon

origin $00B4D118
addiu t6, r0, ((SCREEN_WIDTH/2)-2) //X Position of Continue Text Arrow

origin $00B4D2B4
addiu t7, r0, SCREEN_WIDTH-169 //X Position of Save Icon on Pause Screen in Japanese

origin $00B4D2C8
addiu t9, r0, SCREEN_WIDTH-172 //X Position of Save Icon on Pause Screen in English

origin $00B4D3D0
addiu t8, r0, SCREEN_WIDTH-116 //X Position of Dungeon Map in HUD

origin $00B4D4AC
addiu t6, r0, (78+((SCREEN_WIDTH-320)/2)) //X Position of Song Icon Textbox

origin $00B4D520
addiu a2, r0, SCREEN_WIDTH-71 //X Position of C-Down Item Quantity

origin $00B4D554
addiu t8, r0, (98+((SCREEN_WIDTH-320)/2)) //X Position of Song Playback Guide

origin $00B4D6A4
addiu t6, r0, SCREEN_WIDTH-92 //X Position of C-Left Item Quantity

origin $00B4D6C0
addiu t9, r0, SCREEN_WIDTH-48 //X Position of C-Right Item Quantity

origin $00B4D768
addiu t9, r0, ((SCREEN_WIDTH/2)-96) //X Position of Game Over Text

origin $00B610F4
dh SCREEN_WIDTH-104 //X Position of Hyrule Field Minimap
dh SCREEN_WIDTH-104 //X Position of Kakiriko Village Minimap
dh SCREEN_WIDTH-102 //X Position of Graveyard Minimap
dh SCREEN_WIDTH-118 //X Position of Zora's River Minimap
dh SCREEN_WIDTH-118 //X Position of Kokiri Forest Minimap
dh SCREEN_WIDTH-70 //X Position of Sacred Meadow Minimap
dh SCREEN_WIDTH-104 //X Position of Lake Hylia Minimap
dh SCREEN_WIDTH-86 //X Position of Zora's Domain Minimap
dh SCREEN_WIDTH-86 //X Position of Zora's Fountain Minimap
dh SCREEN_WIDTH-104 //X Position of Gerudo Valley Minimap
dh SCREEN_WIDTH-86 //X Position of Haunted Wasteland Minimap
dh SCREEN_WIDTH-86 //X Position of Desert Colossus Minimap
dh SCREEN_WIDTH-104 //X Position of Gerudo's Fortress Minimap
dh SCREEN_WIDTH-86 //X Position of Lost Woods Minimap
dh SCREEN_WIDTH-86 //X Position of Hyrule Castle Area Minimap
dh SCREEN_WIDTH-70 //X Position of Death Mountain Trail Minimap
dh SCREEN_WIDTH-104 //X Position of Death Mountain Crater Minimap
dh SCREEN_WIDTH-86 //X Position of Goron City Minimap
dh SCREEN_WIDTH-86 //X Position of Lon Lon Ranch Minimap
dh SCREEN_WIDTH-86 //X Position of Outside Ganon's Castle Minimap

origin $00B61158
dh ((108*10)+(((SCREEN_WIDTH-320)*5))) //X Position of Arrows on Hyrule Field Minimap

origin $00B61160
dh ((100*10)+(((SCREEN_WIDTH-320)*5))) //X Position of Arrows on Kakiriko Village Minimap

origin $00B61168
dh ((89*10)+(((SCREEN_WIDTH-320)*5))) //X Position of Arrows on Graveyard Minimap

origin $00B61170
dh ((72*10)+(((SCREEN_WIDTH-320)*5))) //X Position of Arrows on Zora's River Minimap

origin $00B61178
dh ((66*10)+(((SCREEN_WIDTH-320)*5))) //X Position of Arrows on Kokiri Forest Minimap

origin $00B61180
dh ((122*10)+(((SCREEN_WIDTH-320)*5))) //X Position of Arrows on Sacred Meadow Minimap

origin $00B61188
dh ((108*10)+(((SCREEN_WIDTH-320)*5))) //X Position of Arrows on Lake Hylia Minimap

origin $00B61190
dh ((112*10)+(((SCREEN_WIDTH-320)*5))) //X Position of Arrows on Zora's Domain Minimap

origin $00B61198
dh ((115*10)+(((SCREEN_WIDTH-320)*5))) //X Position of Arrows on Zora's Fountain Minimap

origin $00B611A0
dh ((106*10)+(((SCREEN_WIDTH-320)*5))) //X Position of Arrows on Gerudo Valley Minimap

origin $00B611A8
dh ((110*10)+(((SCREEN_WIDTH-320)*5))) //X Position of Arrows on Haunted Wasteland Minimap

origin $00B611B0
dh ((93*10)+(((SCREEN_WIDTH-320)*5))) //X Position of Arrows on Desert Colossus Minimap

origin $00B611B8
dh ((85*10)+(((SCREEN_WIDTH-320)*5))) //X Position of Arrows on Gerudo's Fortress Minimap

origin $00B611C0
dh ((110*10)+(((SCREEN_WIDTH-320)*5))) //X Position of Arrows on Lost Woods Minimap

origin $00B611C8
dh ((103*10)+(((SCREEN_WIDTH-320)*5))) //X Position of Arrows on Hyrule Castle Area Minimap

origin $00B611D0
dh ((124*10)+(((SCREEN_WIDTH-320)*5))) //X Position of Arrows on Death Mountain Trail Minimap

origin $00B611D8
dh ((103*10)+(((SCREEN_WIDTH-320)*5))) //X Position of Arrows on Death Mountain Crater Minimap

origin $00B611E0
dh ((110*10)+(((SCREEN_WIDTH-320)*5))) //X Position of Arrows on Goron City Minimap

origin $00B611E8
dh ((112*10)+(((SCREEN_WIDTH-320)*5))) //X Position of Arrows on Lon Lon Ranch Minimap

origin $00B611F0
dh ((107*10)+(((SCREEN_WIDTH-320)*5))) //X Position of Arrows on Outside Ganon's Castle Minimap

origin $00B612DA
dh SCREEN_WIDTH-51 //X Position of Bottom of the Well Dungeon Icon

origin $00B612E0
dh SCREEN_WIDTH-47 //X Position of Deku Tree Dungeon Icon
dh SCREEN_WIDTH-41 //X Position of Sacred Meadow Dungeon Icon
dh SCREEN_WIDTH-61 //X Position of A Dungeon Icon

origin $00B612E8
dh SCREEN_WIDTH-60 //X Position of Entrypoint 1 of Zora's Fountain Dungeon Icon

origin $00B612EE
dh SCREEN_WIDTH-85 //X Position of Spirit Temple Dungeon Icon

origin $00B612F6
dh SCREEN_WIDTH-53 //X Position of Death Mountain Dungeon Icon

origin $00B612F8
dh SCREEN_WIDTH-59 //X Position of Death Mountain Crater Dungeon Icon

origin $00B612FE
dh SCREEN_WIDTH-60 //X Position of Ganon's Castle Dungeon Icon

origin $00B61300
dh SCREEN_WIDTH-26 //X Position of Another Dungeon Icon
dh SCREEN_WIDTH-61 //X Position of Lake Hylia Dungeon Icon

origin $00B61306
dh SCREEN_WIDTH-77 //X Position of A Third Dungeon Icon

origin $00B70930 //Equivalent to 0x80106730 in RAM
lh t8, 0(t7) //Get Position of Arrows for Dungeon Minimap
j $8006C7FC //Return to Game Code
addiu t8, t8, ((SCREEN_WIDTH-320)*5) //Update Position for Dungeon Minimap Arrows

origin $00B7DA30
dh (54+((SCREEN_WIDTH-320)/2)) //Textbox Icon Type 1 X Position
dh (74+((SCREEN_WIDTH-320)/2)) //Textbox Icon Type 2 X Position
dh (50+((SCREEN_WIDTH-320)/2)) //Textbox Icon Type 3 X Position
dh (72+((SCREEN_WIDTH-320)/2)) //Textbox Icon Type 4 X Position

origin $00B7DAE0
dh (34+((SCREEN_WIDTH-320)/2)) //Textbox Type 0 Textbox X Position
dh (34+((SCREEN_WIDTH-320)/2)) //Textbox Type 1 Textbox X Position
dh (34+((SCREEN_WIDTH-320)/2)) //Textbox Type 2 Textbox X Position
dh (34+((SCREEN_WIDTH-320)/2)) //Textbox Type 3 Textbox X Position
dh (34+((SCREEN_WIDTH-320)/2)) //Textbox Type 4 Textbox X Position
dh (34+((SCREEN_WIDTH-320)/2)) //Textbox Type 5 Textbox X Position

origin $00B927C0
li s7, (((SCREEN_WIDTH/2)-63) << 14) //Left Corner of Nintendo 64 Text
li s6, ($E4000000|((SCREEN_WIDTH/2)+129) << 14) //Right Corner of Nintendo 64 Text
li s4, 0x002FC004 //Run a Replaced Opcode
li s3, 0xF5883000 //Run Another Replaced Opcode
li s2, 0x070BF056 //Run a Third Replaced Opcode
li t4, 0x01000000 //Run a Fourth Replaced Opcode

origin $00B93840
addiu a1, r0, (((SCREEN_WIDTH/2)-64)/8) //X Position of ZELDA MAP SELECT Text on Map Select

origin $00B93898
addiu a1, r0, (((SCREEN_WIDTH/2)-88)/8) //X Position of Map Names on Map Select

origin $00B93980
addiu a1, r0, ((SCREEN_WIDTH/2)/8) //X Position of OPT=%d Text on Map Select

origin $00B93CDC
addiu t9, r0, SCREEN_WIDTH //Max X Position for Text Rendering on Map Select

origin $00BA3F9C
li t8, ($E4000000|(SCREEN_WIDTH/2)+74 << 14|SCREEN_HEIGHT-20 << 2) //Lower-Right Corner of Decide and Cancel on Menu
li t3, ((SCREEN_WIDTH/2)-70 << 14|SCREEN_HEIGHT-36 << 2) //Upper-Left Corner of Decide and Cancel on Menu
addiu t7, v0, 8 //Run a Replaced Opcode
sw t7, 704(t2) //Run another Replaced Opcode

origin $00BBBA88
dh ((66*10)+(((SCREEN_WIDTH-320)*5))) //X Destination Position of Left C Button Item HUD Slide

origin $00BBBA8A
dh ((90*10)+(((SCREEN_WIDTH-320)*5))) //X Destination Position of Down C Button Item HUD Slide

origin $00BBBA8C
dh ((114*10)+(((SCREEN_WIDTH-320)*5))) //X Destination Position of Right C Button Item HUD Slide

origin $00BD74A4
addiu a3, r0, (SCREEN_WIDTH/2) //X Position of Area Names in Intros

origin $00C64ADC
lui at, 0x43C5 //X Position of Right Arrow in Shops (394.0f)

origin $00C64B24
lui at, 0x43BD //X Position of Right Arrow Analog Stick in Shops (378.0f)

origin $00E6111C
addiu t8, r0, ((SCREEN_WIDTH/2)-41) //X Position of Press Start Text

origin $00E6116C
addiu t8, r0, ((SCREEN_WIDTH/2)-61) //X Position of No Controller Text

origin $00E62CA0
addiu s4, r0, ((SCREEN_WIDTH/2)-96) //X Position of Flame Effect on Game Logo

origin $00E62DD4
addiu a1, r0, SCREEN_WIDTH/2 //X Position of Game Logo

origin $00E62DFC
addiu a1, r0, SCREEN_WIDTH/2 //X Position of Disk Icon on Title Screen

origin $00E62FC8
addiu t3, r0, ((SCREEN_WIDTH/2)-6) //X Position of The Legend of Text Shadow

origin $00E63010
addiu t1, r0, ((SCREEN_WIDTH/2)-8) //X Position of Ocarina of Time Text Shadow

origin $00E630AC
addiu t8, r0, ((SCREEN_WIDTH/2)-7) //X Position of The Legend of Text

origin $00E63108
addiu t5, r0, ((SCREEN_WIDTH/2)-9) //X Position of Ocarina of Time Text

origin $00E634AC
li t5, ($E4000000|(SCREEN_WIDTH/2)+74 << 14|(SCREEN_HEIGHT/2)+40 << 2) //Lower-Right Corner of Japanese Subtitle of Logo
li t2, ((SCREEN_WIDTH/2)-54 << 14|(SCREEN_HEIGHT/2)+24 << 2) //Upper-Left Corner of Japanese Subtitle of Logo
addiu t1, t9, 8 //Run a Replaced Opcode
sw t1, 416(sp) //Run another Replaced Opcode

origin $00E63690
li t8, ($E4000000|(SCREEN_WIDTH/2)+62 << 14|SCREEN_HEIGHT-26 << 2) //Lower-Right Corner of Title Screen Copyright
li t3, ((SCREEN_WIDTH/2)-66 << 14|SCREEN_HEIGHT-42 << 2) //Upper-Left Corner of Title Screen Copyright
addiu t1, t2, 8 //Run a Replaced Opcode
sw t1, 416(sp) //Run another Replaced Opcode

origin $00E8B4E0
li t8, ($E4000000|(SCREEN_WIDTH/2)+40 << 14|(SCREEN_HEIGHT/2)-7 << 2) //Lower-Right Corner of The End Graphic
li t7, ((SCREEN_WIDTH/2)-40 << 14|(SCREEN_HEIGHT/2)-30 << 2) //Upper-Left Corner of The End Graphic
addiu t6, v1, 8 //Run a Replaced Opcode
sw t6, 688(a1) //Run another Replaced Opcode

origin $00E8B624
li t7, ($E4000000|(SCREEN_WIDTH/2)+60 << 14|(SCREEN_HEIGHT/2)+63 << 2) //Lower-Right Corner of Ending The Legend of Zelda Graphic
li t9, ((SCREEN_WIDTH/2)-60 << 14|(SCREEN_HEIGHT/2)+40 << 2) //Upper-Left Corner of Ending The Legend of Zelda Graphic
addiu t8, v1, 8 //Run a Replaced Opcode
sw t8, 688(a1) //Run another Replaced Opcode

origin $00E8B760
li t8, ($E4000000|(SCREEN_WIDTH/2)+56 << 14|(SCREEN_HEIGHT/2)+72 << 2) //Lower-Right Corner of Ending Ocarina of Time Graphic
li t7, ((SCREEN_WIDTH/2)-56 << 14|(SCREEN_HEIGHT/2)+57 << 2) //Upper-Left Corner of Ending Ocarina of Time Graphic
addiu t6, v1, 8 //Run a Replaced Opcode
sw t6, 688(a1) //Run another Replaced Opcode

origin $00E8F178
dw ($E4000000|SCREEN_WIDTH/2 << 14|(SCREEN_HEIGHT/2)+17 << 2) //Lower-Right of Left Side of Nintendo Logo
dw ((SCREEN_WIDTH/2)-63 << 14|(SCREEN_HEIGHT/2)-30 << 2) //Upper-Left of Left Side of Nintendo Logo

origin $00E8F1C8
dw ($E4000000|(SCREEN_WIDTH/2)+63 << 14|(SCREEN_HEIGHT/2)+17 << 2) //Lower-Right of Right Side of Nintendo Logo
dw (SCREEN_WIDTH/2 << 14|(SCREEN_HEIGHT/2)-30 << 2) //Upper-Left of Right Side of Nintendo Logo

origin $00E8F218
dw ($E4000000|(SCREEN_WIDTH/2)+48 << 14|(SCREEN_HEIGHT/2)-25 << 2) //Lower-Right of Presented By Text
dw ((SCREEN_WIDTH/2)-47 << 14|(SCREEN_HEIGHT/2)-40 << 2) //Upper-Left of Presented By Text

origin $00F600C0
dw ($E4000000|SCREEN_WIDTH << 14| SCREEN_HEIGHT << 2) //Texture Rectangle for Sand Effect in Haunted Wasteland