// N64 "Kira to Kaiketsu! 64 Tanteidan" Japanese To English Translation by krom (Peter Lemon) & Variable Width Font Engine by Zoinkity:

endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "Shining and Solving! 64 Detective Club.z64", create
origin $000000; insert "Kira to Kaiketsu! 64 Tanteidan VWF.z64" // Include Japanese Kira to Kaiketsu! 64 Tanteidan N64 ROM With Variable Width Font Patch By Zoinkity Applied

// Title Screen GFX
origin $1A7128; include "GFX\TitleScreen\MissionStartA.asm" // Include English GFX Tile, 64x32 TLUT RGBA 8B (2048 Bytes)
origin $1A7A70; include "GFX\TitleScreen\MissionStartB.asm" // Include English GFX Tile, 64x32 TLUT RGBA 8B (2048 Bytes)
origin $1A8380; include "GFX\TitleScreen\MissionStartC.asm" // Include English GFX Tile, 64x32 TLUT RGBA 8B (2048 Bytes)
origin $1A8FB8; include "GFX\TitleScreen\MissionLoadA.asm" // Include English GFX Tile, 64x32 TLUT RGBA 8B (2048 Bytes)
origin $1A9910; include "GFX\TitleScreen\MissionLoadB.asm" // Include English GFX Tile, 64x32 TLUT RGBA 8B (2048 Bytes)
origin $1AA220; include "GFX\TitleScreen\MissionLoadC.asm" // Include English GFX Tile, 64x32 TLUT RGBA 8B (2048 Bytes)

// Player Select GFX
origin $AF3F40; include "GFX\PlayerSelect\None.asm" // Include English GFX Tile, 88x23 TLUT RGBA 8B (2024 Bytes)
origin $AF4730; include "GFX\PlayerSelect\Single.asm" // Include English GFX Tile, 88x23 TLUT RGBA 8B (2024 Bytes)
origin $AF4F20; include "GFX\PlayerSelect\Pair.asm" // Include English GFX Tile, 88x23 TLUT RGBA 8B (2024 Bytes)
origin $AF5710; include "GFX\PlayerSelect\3Player.asm" // Include English GFX Tile, 88x23 TLUT RGBA 8B (2024 Bytes)
origin $AF5F00; include "GFX\PlayerSelect\4Player.asm" // Include English GFX Tile, 88x23 TLUT RGBA 8B (2024 Bytes)
origin $B22150; include "GFX\PlayerSelect\BombA.asm" // Include English GFX Tile, 64x32 TLUT RGBA 8B (2048 Bytes)
origin $B22950; include "GFX\PlayerSelect\BombB.asm" // Include English GFX Tile, 64x32 TLUT RGBA 8B (2048 Bytes)
origin $B23150; include "GFX\PlayerSelect\TheftA.asm" // Include English GFX Tile, 64x32 TLUT RGBA 8B (2048 Bytes)
origin $B23950; include "GFX\PlayerSelect\TheftB.asm" // Include English GFX Tile, 64x32 TLUT RGBA 8B (2048 Bytes)
origin $B24150; include "GFX\PlayerSelect\LostItemA.asm" // Include English GFX Tile, 64x32 TLUT RGBA 8B (2048 Bytes)
origin $B24950; include "GFX\PlayerSelect\LostItemB.asm" // Include English GFX Tile, 64x32 TLUT RGBA 8B (2048 Bytes)
origin $B25150; include "GFX\PlayerSelect\LostItemC.asm" // Include English GFX Tile, 32x32 TLUT RGBA 8B (1024 Bytes)
origin $B25550; include "GFX\PlayerSelect\Random!A.asm" // Include English GFX Tile, 64x32 TLUT RGBA 8B (2048 Bytes)
origin $B25D50; include "GFX\PlayerSelect\Random!B.asm" // Include English GFX Tile, 64x32 TLUT RGBA 8B (2048 Bytes)
origin $B26550; include "GFX\PlayerSelect\Random!C.asm" // Include English GFX Tile, 32x32 TLUT RGBA 8B (1024 Bytes)
origin $B26950; include "GFX\PlayerSelect\Room.asm" // Include English GFX Tile, 64x32 TLUT RGBA 8B (2048 Bytes)

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
                 db " Controller PAK", $0A,$0A
                 db "  Make Sure Of", $0A
                 db " Re-Connection", $00
TextStyle1($16545C, "Saving Requires A")
                 db "  Controller PAK", $0A
                 db "Please Insert Now"
                 db " Save Is Disabled"
                 db "If You Start Game", $00
TextStyle1($1654DC, "Start Anyway?"); db $00
TextStyle1($1654F0, " Ready To Insert"); db $0A
                 db " A Controller PAK", $00
TextStyle1($165528, "Controller PAK Menu"); db $00
TextStyle1($165548, "Starting"); db $00
TextStyle1($165624, "Saving Game"); db $00
TextStyle1($165634, " "); db $00
TextStyle1($165638, "  Is Disabled"); db $00

// Load Screen
TextStyle1($164DB8, " The PAK"); db $0A
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
TextStyle1($13A848, "Do You Want any"); db $0A
                 db "Computer Players"
                 db "Today?", $00
TextStyle1($13A878, "Now I need You"); db $0A
                 db "to Select Your", $0A
                 db "Controller!", $00
TextStyle1($13A8A8, "Choose the Type"); db $0A
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