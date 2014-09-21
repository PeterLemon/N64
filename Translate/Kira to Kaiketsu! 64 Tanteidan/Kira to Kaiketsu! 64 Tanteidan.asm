// N64 "Kira to Kaiketsu! 64 Tanteidan" Japanese To English Translation by krom (Peter Lemon):

endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "Shining and Solving! 64 Detective Club.z64", create
origin $000000; insert "Kira to Kaiketsu! 64 Tanteidan (J) [!].z64" // Include Japanese Kira to Kaiketsu! 64 Tanteidan N64 ROM

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
origin $B25550; include "GFX\PlayerSelect\Random!A.asm" // Include English GFX Tile, 64x32 TLUT RGBA 8B (2048 Bytes)
origin $B25D50; include "GFX\PlayerSelect\Random!B.asm" // Include English GFX Tile, 64x32 TLUT RGBA 8B (2048 Bytes)
origin $B26550; include "GFX\PlayerSelect\Random!C.asm" // Include English GFX Tile, 32x32 TLUT RGBA 8B (1024 Bytes)
origin $B26950; include "GFX\PlayerSelect\Room.asm" // Include English GFX Tile, 64x32 TLUT RGBA 8B (2048 Bytes)

macro TextStyle1(OFFSET, TEXT) {
  origin {OFFSET}
  dw {TEXT}
}

// Char Table 1
map ' ', $2020
map '!', $212F // Italic
map '.', $A1A6
map ':', $A1A7
map '?', $A1A9
//map '!', $A1AA // Non-Italic
map '0', $A3B0, 10 // Map Numbers
map 'A', $A3C1, 26 // Map English "Upper Case" Characters
map 'a', $A3E1, 26 // Map English "Lower Case" Characters
map '-', $A8A1

// Boot Screen
TextStyle1($0E1E20, "Yes")
TextStyle1($0E1E27, "No ")
TextStyle1($165094, "Exit The Menu?")
TextStyle1($165148, "PleaseInsert")
TextStyle1($165160, "ControlPAK")
TextStyle1($165176, "Make Sure Of")
TextStyle1($16518E, "Re-Connect")
TextStyle1($16545C, "Save Requires")
TextStyle1($165476, "A Control PAK")
TextStyle1($165490, "Please Insert")
TextStyle1($1654AA, "Save Disabled")
TextStyle1($1654C4, "If Starting")
TextStyle1($1654DC, "Continue?")
TextStyle1($1654F0, "Please Insert")
TextStyle1($16550A, "A Control PAK")
TextStyle1($165528, "ControlPAKMenu")
TextStyle1($165548, "Start")
TextStyle1($165624, "No Save")
TextStyle1($165634, " ")
TextStyle1($165638, "Is Chosen")

// Load Screen
TextStyle1($164DB8, " ThePAK")
TextStyle1($164DCD, "Push A")
TextStyle1($164E18, "Put")
TextStyle1($165652, "If Connected")
TextStyle1($165800, "If using a Save")
TextStyle1($16581E, "GamePAK PushA")
TextStyle1($165839, "WhenConnected")

// Player Select
TextStyle1($13A818, "How many Players Today?")
TextStyle1($13A848, "Select any COM Players?")
TextStyle1($13A878, "Choose your Controller!")
TextStyle1($13A8A8, "Choose a Case to Solve?")
TextStyle1($13A8D8, "How Big is the Mansion?")
TextStyle1($13A908, "Is this Correct:")
TextStyle1($13A938, "Want to Start the Game?")
TextStyle1($13A998, " There are No Mistakes?")
TextStyle1($0E8A66, "Health"); dw $2025, $3264
TextStyle1($0E8A7A, "Shine "); dw $2025, $3264
TextStyle1($0E8A8E, "Attack"); dw $2025, $3264
TextStyle1($0E8AA2, "Search"); dw $2025, $3264
TextStyle1($0E8AB6, "Speed "); dw $2025, $3264

// Player Name Font Swap
origin $0E2308; insert "FontSwap.bin" // Include Swapped Font Data (3 * $12C Bytes)
TextStyle1($0E2698, "A"); dw $00A4, $A200, $A5A2

// Player Names
TextStyle1($0E1FC8, "Kenta")
TextStyle1($0E1FD5, "Hirosh")
TextStyle1($0E1FE2, "Yosuke")
TextStyle1($0E1FEF, "Shota")
TextStyle1($0E1FFC, "Takuya")
TextStyle1($0E2009, "Jun")
TextStyle1($0E2016, "Koichi")
TextStyle1($0E2023, "Shotar")
TextStyle1($0E2030, "Ken")
TextStyle1($0E203D, "Hasega")
TextStyle1($0E204A, "Tomo")
TextStyle1($0E2057, "Yuki")
TextStyle1($0E2064, "Anna")
TextStyle1($0E2071, "Kurumi")
TextStyle1($0E207E, "Yoshik")
TextStyle1($0E208B, "Sanae")
TextStyle1($0E2098, "Yumi")
TextStyle1($0E20A5, "Ai")
TextStyle1($0E20B2, "Emi")
TextStyle1($0E20BF, "Nakaji")
TextStyle1($0E20CC, "Jet"); dw $0000
TextStyle1($0E20D9, "Saburo")
TextStyle1($0E20E6, "koji")
TextStyle1($0E20F3, "Eiji")
TextStyle1($0E2100, "Akira")
TextStyle1($0E210D, "Giraud")
TextStyle1($0E211A, "Shiger")
TextStyle1($0E2127, "Tetsu")
TextStyle1($0E2134, "Jin")
TextStyle1($0E2141, "Yamada")
TextStyle1($0E214E, "Ryoko")
TextStyle1($0E215B, "Kyoko")
TextStyle1($0E2168, "Reiko")
TextStyle1($0E2175, "Mayumi")
TextStyle1($0E2182, "Nobuko")
TextStyle1($0E218F, "Noriko")
TextStyle1($0E219C, "Shiho")
TextStyle1($0E21A9, "Eriko")
TextStyle1($0E21B6, "Momoko")
TextStyle1($0E21C3, "Hasega")
TextStyle1($0E21D0, "Robo P")
TextStyle1($0E21DD, "Ponkic")
TextStyle1($0E21F7, "Plot")
TextStyle1($0E2204, "Sanz")
TextStyle1($0E2211, "RoboTa")
TextStyle1($0E221E, "RoboSu")
TextStyle1($0E222B, "RoboBe")
TextStyle1($0E2238, "Holmes")
TextStyle1($0E2245, "Koike")