// N64 "Kira to Kaiketsu! 64 Tanteidan" Japanese To English Translation by krom (Peter Lemon) & Variable Width Font Engine by Zoinkity:

endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "Shining and Solving! 64 Detective Club.z64", create
origin $000000; insert "Kira to Kaiketsu! 64 Tanteidan VWF.z64" // Include Japanese Kira to Kaiketsu! 64 Tanteidan N64 ROM With Variable Width Font Patch By Zoinkity Applied

// Title Screen GFX
origin $1A7128; include "GFX/TitleScreen/MissionStartA.asm" // Include English GFX Tile, 64x32 TLUT RGBA 8B (2048 Bytes)
origin $1A7A70; include "GFX/TitleScreen/MissionStartB.asm" // Include English GFX Tile, 64x32 TLUT RGBA 8B (2048 Bytes)
origin $1A8380; include "GFX/TitleScreen/MissionStartC.asm" // Include English GFX Tile, 64x32 TLUT RGBA 8B (2048 Bytes)
origin $1A8FB8; include "GFX/TitleScreen/MissionLoadA.asm" // Include English GFX Tile, 64x32 TLUT RGBA 8B (2048 Bytes)
origin $1A9910; include "GFX/TitleScreen/MissionLoadB.asm" // Include English GFX Tile, 64x32 TLUT RGBA 8B (2048 Bytes)
origin $1AA220; include "GFX/TitleScreen/MissionLoadC.asm" // Include English GFX Tile, 64x32 TLUT RGBA 8B (2048 Bytes)

// Player Select GFX
origin $AF3F40; include "GFX/PlayerSelect/None.asm" // Include English GFX Tile, 88x23 TLUT RGBA 8B (2024 Bytes)
origin $AF4730; include "GFX/PlayerSelect/Single.asm" // Include English GFX Tile, 88x23 TLUT RGBA 8B (2024 Bytes)
origin $AF4F20; include "GFX/PlayerSelect/Pair.asm" // Include English GFX Tile, 88x23 TLUT RGBA 8B (2024 Bytes)
origin $AF5710; include "GFX/PlayerSelect/3Player.asm" // Include English GFX Tile, 88x23 TLUT RGBA 8B (2024 Bytes)
origin $AF5F00; include "GFX/PlayerSelect/4Player.asm" // Include English GFX Tile, 88x23 TLUT RGBA 8B (2024 Bytes)
origin $B22150; include "GFX/PlayerSelect/BombA.asm" // Include English GFX Tile, 64x32 TLUT RGBA 8B (2048 Bytes)
origin $B22950; include "GFX/PlayerSelect/BombB.asm" // Include English GFX Tile, 64x32 TLUT RGBA 8B (2048 Bytes)
origin $B23150; include "GFX/PlayerSelect/TheftA.asm" // Include English GFX Tile, 64x32 TLUT RGBA 8B (2048 Bytes)
origin $B23950; include "GFX/PlayerSelect/TheftB.asm" // Include English GFX Tile, 64x32 TLUT RGBA 8B (2048 Bytes)
origin $B24150; include "GFX/PlayerSelect/LostItemA.asm" // Include English GFX Tile, 64x32 TLUT RGBA 8B (2048 Bytes)
origin $B24950; include "GFX/PlayerSelect/LostItemB.asm" // Include English GFX Tile, 64x32 TLUT RGBA 8B (2048 Bytes)
origin $B25150; include "GFX/PlayerSelect/LostItemC.asm" // Include English GFX Tile, 32x32 TLUT RGBA 8B (1024 Bytes)
origin $B25550; include "GFX/PlayerSelect/Random!A.asm" // Include English GFX Tile, 64x32 TLUT RGBA 8B (2048 Bytes)
origin $B25D50; include "GFX/PlayerSelect/Random!B.asm" // Include English GFX Tile, 64x32 TLUT RGBA 8B (2048 Bytes)
origin $B26550; include "GFX/PlayerSelect/Random!C.asm" // Include English GFX Tile, 32x32 TLUT RGBA 8B (1024 Bytes)
origin $B26950; include "GFX/PlayerSelect/Room.asm" // Include English GFX Tile, 64x32 TLUT RGBA 8B (2048 Bytes)

macro TextStyle1(OFFSET, TEXT) {
  origin {OFFSET}
  db $7F // Special Character $7F = Print ASCII Variable Width Font
  db {TEXT} // ASCII Text To Print
}

// Char Table 1
map ' ', $20, 32 // Map Special Chars & Numbers
map 'A', $41, 26 // Map English "Upper Case" Characters
map 'a', $61, 26 // Map English "Lower Case" Characters

// Boot Screen
TextStyle1($0E1E20, "Yes"); db $00
TextStyle1($0E1E27, "No"); db $00
TextStyle1($165094, "Want To Exit Menu?"); db $00
TextStyle1($165148, "Please Insert A")
                 db " Controller PAK\n\n"
                 db "  Make Sure Of\n"
                 db " Re-Connection", $00
TextStyle1($16545C, "Saving Requires A")
                 db "  Controller PAK\n"
                 db "Please Insert Now"
                 db " Save Is Disabled"
                 db "If You Start Game", $00
TextStyle1($1654DC, "Start Anyway?"); db $00
TextStyle1($1654F0, " Ready To Insert\n")
                 db " A Controller PAK", $00
TextStyle1($165528, "Controller PAK Menu"); db $00
TextStyle1($165548, "Starting"); db $00
TextStyle1($165624, "Saving Game"); db $00
TextStyle1($165634, " "); db $00
TextStyle1($165638, "  Is Disabled"); db $00

// Load Screen
TextStyle1($164DB8, " The PAK\n")
                 db " Press Button A", $7F, $00
TextStyle1($164E18, "Load"); db $7F, $00
TextStyle1($165652, " When Connected"); db $7F, $00
TextStyle1($165800, "If Using A SaveGame")
                 db "Controll PAK Push A"
                 db "When It's Connected", $00

// Player Select
TextStyle1($13A818, "How many Players")
                 db "will be Competing"
                 db "Today?", $00
TextStyle1($13A848, "Do You Want any\n")
                 db "Computer Players"
                 db "Today?", $00
TextStyle1($13A878, "Now I need You\n")
                 db "to Select Your\n"
                 db "Controller!", $00
TextStyle1($13A8A8, "Choose the Type\n")
                 db "of Case to Solve?", $00
TextStyle1($13A8D8, "How Big a Mansion")
                 db "Would You Like?", $00
TextStyle1($13A908, "Is it all Correct:"); db $7F, $00
TextStyle1($13A938, "Do You want Me to")
                 db "Start the Game?", $00
TextStyle1($13A998, "You're sure there")
                 db "are No Mistakes?", $00

origin $0E8A64; db $20,$25, $32,$64, $20, $41,$30, $7F, "Health", $00
origin $0E8A78; db $20,$25, $32,$64, $20, $41,$33, $7F, "Shine", $00
origin $0E8A8C; db $20,$25, $32,$64, $20, $41,$32, $7F, "Attack", $00
origin $0E8AA0; db $20,$25, $32,$64, $20, $41,$31, $7F, "Search", $00
origin $0E8AB4; db $20,$25, $32,$64, $20, $41,$34, $7F, "Speed", $00

// Player Name Font Swap
origin $0E2308; insert "FontSwap.bin" // Include Swapped Font Data (3 * $12C Bytes)
TextStyle1($0E2698, "A"); dw $00A4, $A200, $A5A2

// Player Names
TextStyle1($0E1FC8, "Kenta"); db $00
TextStyle1($0E1FD5, "Hiroshi"); db $00
TextStyle1($0E1FE2, "Yosuke"); db $00
TextStyle1($0E1FEF, "Shota"); db $00
TextStyle1($0E1FFC, "Takuya"); db $00
TextStyle1($0E2009, "Jun"); db $00
TextStyle1($0E2016, "Koichi"); db $00
TextStyle1($0E2023, "Shotaro"); db $00
TextStyle1($0E2030, "Ken"); db $00
TextStyle1($0E203D, "Hasegawa"); db $00
TextStyle1($0E204A, "Tomo"); db $00
TextStyle1($0E2057, "Yuki"); db $00
TextStyle1($0E2064, "Anna"); db $00
TextStyle1($0E2071, "Kurumi"); db $00
TextStyle1($0E207E, "Yoshiko"); db $00
TextStyle1($0E208B, "Sanae"); db $00
TextStyle1($0E2098, "Yumi"); db $00
TextStyle1($0E20A5, "Ai"); db $00
TextStyle1($0E20B2, "Emi"); db $00
TextStyle1($0E20BF, "Nakajima"); db $00
TextStyle1($0E20CC, "Jet"); db $00
TextStyle1($0E20D9, "Saburouta"); db $00
TextStyle1($0E20E6, "Koji"); db $00
TextStyle1($0E20F3, "Eiji"); db $00
TextStyle1($0E2100, "Akira"); db $00
TextStyle1($0E210D, "Giraud"); db $00
TextStyle1($0E211A, "Shigeru"); db $00
TextStyle1($0E2127, "Tetsuya"); db $00
TextStyle1($0E2134, "Jin"); db $00
TextStyle1($0E2141, "Yamada"); db $00
TextStyle1($0E214E, "Ryoko"); db $00
TextStyle1($0E215B, "Kyoko"); db $00
TextStyle1($0E2168, "Reiko"); db $00
TextStyle1($0E2175, "Mayumi"); db $00
TextStyle1($0E2182, "Nobuko"); db $00
TextStyle1($0E218F, "Noriko"); db $00
TextStyle1($0E219C, "Shiho"); db $00
TextStyle1($0E21A9, "Eriko"); db $00
TextStyle1($0E21B6, "Momoko"); db $00
TextStyle1($0E21C3, "Hasegawa"); db $00
TextStyle1($0E21D0, "Robo P"); db $00
TextStyle1($0E21DD, "Ponkichi"); db $00
TextStyle1($0E21F7, "Plot"); db $00
TextStyle1($0E2204, "Sanz"); db $00
TextStyle1($0E2211, "Robo Yu"); db $00
TextStyle1($0E221E, "RoboSuke"); db $00
TextStyle1($0E222B, "Robo Be"); db $00
TextStyle1($0E2238, "Holmes"); db $00
TextStyle1($0E2245, "Koike"); db $00

// NPC Names
TextStyle1($AD92B0, "Son"); db $00
TextStyle1($AD92BE, "Businessman"); db $00
TextStyle1($AD92CC, "PresidentJr."); db $00
TextStyle1($AD92DA, "Serious Man"); db $00
TextStyle1($AD92E8, "Elite"); db $00
TextStyle1($AD92F6, "Visitor"); db $00
TextStyle1($AD9304, "Isao"); db $00
TextStyle1($AD9312, "Shuichi"); db $00
TextStyle1($AD9320, "Butler"); db $00
TextStyle1($AD932E, "Tough Dad"); db $00
TextStyle1($AD933C, "President"); db $00
TextStyle1($AD934A, "Sebastian"); db $00
TextStyle1($AD9358, "Old Man"); db $00
TextStyle1($AD9366, "Visitor"); db $00
TextStyle1($AD9374, "Sukezaemon"); db $00
TextStyle1($AD9382, "Daijiro"); db $00
TextStyle1($AD9390, "Gerhard"); db $00
TextStyle1($AD939E, "Daddy"); db $00
TextStyle1($AD93AC, "Visitor"); db $00
TextStyle1($AD93BA, "Father"); db $00
TextStyle1($AD93C8, "Wimpy"); db $00
TextStyle1($AD93D6, "Droopy"); db $00
TextStyle1($AD93E4, "Kotaro"); db $00
TextStyle1($AD93F2, "Keisuke"); db $00
TextStyle1($AD9400, "Master"); db $00
TextStyle1($AD940E, "Foreigner"); db $00
TextStyle1($AD941C, "Freeloader"); db $00
TextStyle1($AD942A, "Guest"); db $00
TextStyle1($AD9438, "Gerhard"); db $00
TextStyle1($AD9446, "Edward"); db $00
TextStyle1($AD9454, "Michael"); db $00
TextStyle1($AD9462, "Jeff"); db $00
TextStyle1($AD9470, "Maid"); db $00
TextStyle1($AD947E, "Housekeeper"); db $00
TextStyle1($AD948C, "Daughter"); db $00
TextStyle1($AD949A, "Rookie Maid"); db $00
TextStyle1($AD94A8, "Yumeko"); db $00
TextStyle1($AD94B6, "Nami"); db $00
TextStyle1($AD94C4, "Yukie"); db $00
TextStyle1($AD94D2, "Violet"); db $00
TextStyle1($AD94E0, "Princess"); db $00
TextStyle1($AD94EE, "Daughter"); db $00
TextStyle1($AD94FC, "Young Wife"); db $00
TextStyle1($AD950A, "Guest"); db $00
TextStyle1($AD9518, "Yumiko"); db $00
TextStyle1($AD9526, "Shizuko"); db $00
TextStyle1($AD9534, "Satoko"); db $00
TextStyle1($AD9542, "Yuko"); db $00
TextStyle1($AD9550, "Secretary"); db $00
TextStyle1($AD955E, "Woman"); db $00
TextStyle1($AD956C, "Daughter"); db $00
TextStyle1($AD957A, "Daughter"); db $00
TextStyle1($AD9588, "Keiko"); db $00
TextStyle1($AD9596, "Miki"); db $00
TextStyle1($AD95A4, "Akemi"); db $00
TextStyle1($AD95B2, "Tomomi"); db $00
TextStyle1($AD95C0, "Model"); db $00
TextStyle1($AD95CE, "Daughter"); db $00
TextStyle1($AD95DC, "Daughter"); db $00
TextStyle1($AD95EA, "Foreigner"); db $00
TextStyle1($AD95F8, "Bonnie"); db $00
TextStyle1($AD9606, "April"); db $00
TextStyle1($AD9614, "Rebecca"); db $00
TextStyle1($AD9622, "Patricia"); db $00
TextStyle1($AD9630, "Doctor"); db $00
TextStyle1($AD963E, "Doctor"); db $00
TextStyle1($AD964C, "Tall Man"); db $00
TextStyle1($AD965A, "Doctor"); db $00
TextStyle1($AD9668, "Doctor"); db $00
TextStyle1($AD9676, "Red Glasses"); db $00
TextStyle1($AD9684, "Erik"); db $00
TextStyle1($AD9692, "Gilbert"); db $00
TextStyle1($AD96A0, "Mad Scholar"); db $00
TextStyle1($AD96AE, "Scholar"); db $00
TextStyle1($AD96BC, "Masseur"); db $00
TextStyle1($AD96CA, "Foreigner"); db $00
TextStyle1($AD96D8, "Chan. Lee"); db $00
TextStyle1($AD96E6, "Jack Ishimo"); db $00
TextStyle1($AD96F4, "Gen. Nagai"); db $00
TextStyle1($AD9702, "Scholar"); db $00
TextStyle1($AD9710, "A.I. Niece"); db $00
TextStyle1($AD971E, "Bomb"); db $00
TextStyle1($AD972C, "KT2000"); db $00
TextStyle1($AD973A, "Pink Eye"); db $00
TextStyle1($AD9748, "Blue Head"); db $00
TextStyle1($AD9756, "Bio-Man"); db $00
TextStyle1($AD9764, "23 Go"); db $00
TextStyle1($AD9772, "Number 6"); db $00
TextStyle1($AD9780, "Cyborg"); db $00
TextStyle1($AD978E, "Policy Robo"); db $00
TextStyle1($AD979C, "Prototype"); db $00
TextStyle1($AD97AA, "Doctor Robo"); db $00
TextStyle1($AD97B8, "Orange Eye"); db $00
TextStyle1($AD97C6, "KR2010"); db $00
TextStyle1($AD97D4, "25 Go"); db $00
TextStyle1($AD97E2, "Number 8"); db $00
TextStyle1($AD97F0, "Walther"); db $00
TextStyle1($AD97FE, "Millionaire"); db $00
TextStyle1($AD980C, "Deb Father"); db $00
TextStyle1($AD981A, "Seijie"); db $00
TextStyle1($AD9828, "Villain"); db $00
TextStyle1($AD9836, "Bald Father"); db $00
TextStyle1($AD9844, "Gonzo"); db $00
TextStyle1($AD9852, "Kumicho"); db $00
TextStyle1($AD9860, "Pro Wrestler"); db $00
TextStyle1($AD986E, "King"); db $00
TextStyle1($AD987C, "Cheerful Man"); db $00
TextStyle1($AD988A, "Singer"); db $00
TextStyle1($AD9898, "Boss"); db $00
TextStyle1($AD98A6, "Sylvester"); db $00
TextStyle1($AD98B4, "Johnny"); db $00
TextStyle1($AD98C2, "Fred"); db $00
TextStyle1($AD98D0, "Taisho"); db $00
TextStyle1($AD98DE, "Uncle"); db $00
TextStyle1($AD98EC, "Running Man"); db $00
TextStyle1($AD98FA, "Geijutsu"); db $00
TextStyle1($AD9908, "Takeshi"); db $00
TextStyle1($AD9916, "Taro"); db $00
TextStyle1($AD9924, "Ichiro"); db $00
TextStyle1($AD9932, "Hirosuke"); db $00
TextStyle1($AD9940, "Nice Father"); db $00
TextStyle1($AD994E, "T-shirt Man"); db $00
TextStyle1($AD995C, "Gurasan Man"); db $00
TextStyle1($AD996A, "Biker"); db $00
TextStyle1($AD9978, "Joe"); db $00
TextStyle1($AD9986, "Ricky"); db $00
TextStyle1($AD9994, "Yoshiwo"); db $00
TextStyle1($AD99A2, "Ryu"); db $00
TextStyle1($AD99B0, "Guard Man"); db $00
TextStyle1($AD99BE, "Guard Man"); db $00
TextStyle1($AD99CC, "Guard Man"); db $00
TextStyle1($AD99DA, "Guard Man"); db $00
TextStyle1($AD99E8, "Guard Man"); db $00
TextStyle1($AD99F6, "Guard Man"); db $00
TextStyle1($AD9A04, "Guard Man"); db $00
TextStyle1($AD9A12, "Guard Man"); db $00
TextStyle1($AD9A20, "Guard Robo"); db $00
TextStyle1($AD9A2E, "Guard Robo"); db $00
TextStyle1($AD9A3C, "Guard Robo"); db $00
TextStyle1($AD9A4A, "Guard Robo"); db $00
TextStyle1($AD9A58, "Guard Robo"); db $00
TextStyle1($AD9A66, "Guard Robo"); db $00
TextStyle1($AD9A74, "Guard Robo"); db $00
TextStyle1($AD9A82, "Guard Robo"); db $00
TextStyle1($AD9A90, "S.Guard Robo"); db $00
TextStyle1($AD9A9E, "S.Guard Robo"); db $00
TextStyle1($AD9AAC, "S.Guard Robo"); db $00
TextStyle1($AD9ABA, "S.Guard Robo"); db $00
TextStyle1($AD9AC8, "S.Guard Robo"); db $00
TextStyle1($AD9AD6, "S.Guard Robo"); db $00
TextStyle1($AD9AE4, "S.Guard Robo"); db $00
TextStyle1($AD9AF2, "S.Guard Robo"); db $00
TextStyle1($AD9B00, "Security"); db $00
TextStyle1($AD9B0E, "Security"); db $00
TextStyle1($AD9B1C, "Security"); db $00
TextStyle1($AD9B2A, "Security"); db $00
TextStyle1($AD9B38, "Security"); db $00
TextStyle1($AD9B46, "Security"); db $00
TextStyle1($AD9B54, "Security"); db $00
TextStyle1($AD9B62, "Security"); db $00
TextStyle1($AD9B70, "Dog"); db $00
TextStyle1($AD9B7E, "Dog"); db $00
TextStyle1($AD9B8C, "Dog"); db $00
TextStyle1($AD9B9A, "Dog"); db $00
TextStyle1($AD9BA8, "Dog"); db $00
TextStyle1($AD9BB6, "Dog"); db $00
TextStyle1($AD9BC4, "Dog"); db $00
TextStyle1($AD9BD2, "Dog"); db $00
TextStyle1($AD9BE0, "Robo Dog"); db $00
TextStyle1($AD9BEE, "Robo Dog"); db $00
TextStyle1($AD9BFC, "Robo Dog"); db $00
TextStyle1($AD9C0A, "Robo Dog"); db $00
TextStyle1($AD9C18, "Robo Dog"); db $00
TextStyle1($AD9C26, "Robo Dog"); db $00
TextStyle1($AD9C34, "Robo Dog"); db $00
TextStyle1($AD9C42, "Robo Dog"); db $00
TextStyle1($AD9C50, "Robo Dog"); db $00
TextStyle1($AD9C5E, "Robo Dog"); db $00
TextStyle1($AD9C6C, "Robo Dog"); db $00
TextStyle1($AD9C7A, "Robo Dog"); db $00
TextStyle1($AD9C88, "Robo Dog"); db $00
TextStyle1($AD9C96, "Robo Dog"); db $00
TextStyle1($AD9CA4, "Robo Dog"); db $00
TextStyle1($AD9CB2, "Robo Dog"); db $00
TextStyle1($AD9CC0, "Robo Dog"); db $00
TextStyle1($AD9CCE, "Robo Dog"); db $00
TextStyle1($AD9CDC, "Robo Dog"); db $00
TextStyle1($AD9CEA, "Robo Dog"); db $00
TextStyle1($AD9CF8, "Robo Dog"); db $00
TextStyle1($AD9D06, "Robo Dog"); db $00
TextStyle1($AD9D14, "Robo Dog"); db $00
TextStyle1($AD9D22, "Robo Dog"); db $00
TextStyle1($AD9D30, "Fairy"); db $00
TextStyle1($AD9D3E, "Fairy"); db $00
TextStyle1($AD9D4C, "Fairy"); db $00
TextStyle1($AD9D5A, "Fairy"); db $00
TextStyle1($AD9D68, "Fairy"); db $00
TextStyle1($AD9D76, "Fairy"); db $00
TextStyle1($AD9D84, "Fairy"); db $00
TextStyle1($AD9D92, "Fairy"); db $00
TextStyle1($AD9DA0, "Fairy"); db $00
TextStyle1($AD9DAE, "Fairy"); db $00
TextStyle1($AD9DBC, "Fairy"); db $00
TextStyle1($AD9DCA, "Fairy"); db $00
TextStyle1($AD9DD8, "Fairy"); db $00
TextStyle1($AD9DE6, "Fairy"); db $00
TextStyle1($AD9DF4, "Fairy"); db $00
TextStyle1($AD9E02, "Fairy"); db $00
TextStyle1($AD9E10, "Fairy"); db $00
TextStyle1($AD9E1E, "Fairy"); db $00
TextStyle1($AD9E2C, "Fairy"); db $00
TextStyle1($AD9E3A, "Fairy"); db $00
TextStyle1($AD9E48, "Fairy"); db $00
TextStyle1($AD9E56, "Fairy"); db $00
TextStyle1($AD9E64, "Fairy"); db $00
TextStyle1($AD9E72, "Fairy"); db $00
TextStyle1($AD9E80, "Fairy"); db $00
TextStyle1($AD9E8E, "Fairy"); db $00
TextStyle1($AD9E9C, "Fairy"); db $00
TextStyle1($AD9EAA, "Fairy"); db $00
TextStyle1($AD9EB8, "Fairy"); db $00
TextStyle1($AD9EC6, "Fairy"); db $00
TextStyle1($AD9ED4, "Fairy"); db $00
TextStyle1($AD9EE2, "Fairy"); db $00
TextStyle1($AD9EF0, "Cosmic Dust"); db $00
TextStyle1($AD9EFE, "Cosmic Dust"); db $00
TextStyle1($AD9F0C, "Cosmic Dust"); db $00
TextStyle1($AD9F1A, "Cosmic Dust"); db $00
TextStyle1($AD9F28, "Cosmic Dust"); db $00
TextStyle1($AD9F36, "Cosmic Dust"); db $00
TextStyle1($AD9F44, "Cosmic Dust"); db $00
TextStyle1($AD9F52, "Cosmic Dust"); db $00
TextStyle1($AD9F60, "Cosmic Dust"); db $00
TextStyle1($AD9F6E, "Cosmic Dust"); db $00
TextStyle1($AD9F7C, "Cosmic Dust"); db $00
TextStyle1($AD9F8A, "Cosmic Dust"); db $00
TextStyle1($AD9F98, "Cosmic Dust"); db $00
TextStyle1($AD9FA6, "Cosmic Dust"); db $00
TextStyle1($AD9FB4, "Cosmic Dust"); db $00
TextStyle1($AD9FC2, "Cosmic Dust"); db $00
TextStyle1($AD9FD0, "Cosmic Dust"); db $00
TextStyle1($AD9FDE, "Cosmic Dust"); db $00
TextStyle1($AD9FEC, "Cosmic Dust"); db $00
TextStyle1($AD9FFA, "Cosmic Dust"); db $00
TextStyle1($ADA008, "Cosmic Dust"); db $00
TextStyle1($ADA016, "Cosmic Dust"); db $00
TextStyle1($ADA024, "Cosmic Dust"); db $00
TextStyle1($ADA032, "Cosmic Dust"); db $00
TextStyle1($ADA040, "Cosmic Dust"); db $00
TextStyle1($ADA04E, "Cosmic Dust"); db $00
TextStyle1($ADA05C, "Cosmic Dust"); db $00
TextStyle1($ADA06A, "Cosmic Dust"); db $00
TextStyle1($ADA078, "Cosmic Dust"); db $00
TextStyle1($ADA086, "Cosmic Dust"); db $00
TextStyle1($ADA094, "Cosmic Dust"); db $00
TextStyle1($ADA0A2, "Cosmic Dust"); db $00

// Item Names
TextStyle1($ADA0B0, "Dummy"); db $00
TextStyle1($ADA0C8, "Teddy Bear"); db $00
TextStyle1($ADA0E0, "Game Machine"); db $00
TextStyle1($ADA0F8, "Car Toys"); db $00
TextStyle1($ADA110, "Plastic Tree"); db $00
TextStyle1($ADA128, "Doll"); db $00
TextStyle1($ADA140, "Piggy Bank"); db $00
TextStyle1($ADA158, "Jewel"); db $00
TextStyle1($ADA170, "Coin"); db $00
TextStyle1($ADA188, "Ring"); db $00
TextStyle1($ADA1A0, "Necklace"); db $00
TextStyle1($ADA1B8, "Wad of Money"); db $00
TextStyle1($ADA1D0, "Wallet"); db $00
TextStyle1($ADA1E8, "Cassette Tape"); db $00
TextStyle1($ADA200, "Videotape"); db $00
TextStyle1($ADA218, "Reel-to-Reel"); db $00
TextStyle1($ADA230, "Floppy Disk"); db $00
TextStyle1($ADA248, "MO Disk"); db $00
TextStyle1($ADA260, "CD"); db $00
TextStyle1($ADA278, "Rope"); db $00
TextStyle1($ADA290, "Piano Wire"); db $00
TextStyle1($ADA2A8, "Electrical Cord"); db $00
TextStyle1($ADA2C0, "Coat"); db $00
TextStyle1($ADA2D8, "T-shirt"); db $00
TextStyle1($ADA2F0, "Jacket"); db $00
TextStyle1($ADA308, "Sweatshirt"); db $00
TextStyle1($ADA320, "Suit"); db $00
TextStyle1($ADA338, "Jeans"); db $00
TextStyle1($ADA350, "Skirt"); db $00
TextStyle1($ADA368, "Ashtray"); db $00
TextStyle1($ADA380, "Tobacco"); db $00
TextStyle1($ADA398, "Lighter"); db $00
TextStyle1($ADA3B0, "Wrist Watch"); db $00
TextStyle1($ADA3C8, "Pen"); db $00
TextStyle1($ADA3E0, "Wastepaper Basket"); db $00
TextStyle1($ADA3F8, "Credit Card"); db $00
TextStyle1($ADA410, "Iron Dumbbell"); db $00
TextStyle1($ADA428, "Tennis Ball"); db $00
TextStyle1($ADA440, "Soccer Ball"); db $00
TextStyle1($ADA458, "Tennis Racket"); db $00
TextStyle1($ADA470, "Card Key"); db $00
TextStyle1($ADA488, "Gold Key"); db $00
TextStyle1($ADA4A0, "Silver Key"); db $00
TextStyle1($ADA4B8, "Dishes"); db $00
TextStyle1($ADA4D0, "Coffee Cup"); db $00
TextStyle1($ADA4E8, "Soup Mug"); db $00
TextStyle1($ADA500, "Mug"); db $00
TextStyle1($ADA518, "Frying Pan"); db $00
TextStyle1($ADA530, "Spoon"); db $00
TextStyle1($ADA548, "Fork"); db $00
TextStyle1($ADA560, "Pan"); db $00
TextStyle1($ADA578, "Glass"); db $00
TextStyle1($ADA590, "Bait"); db $00
TextStyle1($ADA5A8, "Gum"); db $00
TextStyle1($ADA5C0, "Candy"); db $00
TextStyle1($ADA5D8, "Fruit"); db $00
TextStyle1($ADA5F0, "Knife"); db $00
TextStyle1($ADA608, "Kitchen Knife"); db $00
TextStyle1($ADA620, "Cutter"); db $00
TextStyle1($ADA638, "Scissors"); db $00
TextStyle1($ADA650, "Ice Pick"); db $00
TextStyle1($ADA668, "Butterfly Catcher"); db $00
TextStyle1($ADA680, "Small Insect Catcher"); db $00
TextStyle1($ADA698, "Fine Insect Catcher"); db $00
TextStyle1($ADA6B0, "Bomb"); db $00
TextStyle1($ADA6C8, "Time Bomb"); db $00
TextStyle1($ADA6E0, "Dynamite EX"); db $00
TextStyle1($ADA6F8, "Photo"); db $00
TextStyle1($ADA710, "Picture Frame"); db $00
TextStyle1($ADA728, "Sculpture"); db $00
TextStyle1($ADA740, "Figurine"); db $00
TextStyle1($ADA758, "Liquor Bottle"); db $00
TextStyle1($ADA770, "Juice Bottle"); db $00
TextStyle1($ADA788, "Pistol"); db $00
TextStyle1($ADA7A0, "Powerful Pistol"); db $00
TextStyle1($ADA7B8, "Small Pistol"); db $00
TextStyle1($ADA7D0, "Machine Gun"); db $00
TextStyle1($ADA7E8, "Rifle"); db $00
TextStyle1($ADA800, "Powerful Rifle"); db $00
TextStyle1($ADA818, "Bullet Gun"); db $00
TextStyle1($ADA830, "Powerful Bullet Gun"); db $00
TextStyle1($ADA848, "Bat"); db $00
TextStyle1($ADA860, "Pipe"); db $00
TextStyle1($ADA878, "Club"); db $00
TextStyle1($ADA890, "Hammer"); db $00
TextStyle1($ADA8A8, "Spanner"); db $00
TextStyle1($ADA8C0, "Notepad"); db $00
TextStyle1($ADA8D8, "Book"); db $00
TextStyle1($ADA8F0, "Written Notes"); db $00
TextStyle1($ADA908, "Memo"); db $00
