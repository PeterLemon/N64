// N64 "1080 Snowboarding" Widescreen Hack by krom (Peter Lemon):
// Special thanks to gamemasterplc

arch n64.cpu
endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "1080 Snowboarding WS.z64", create
origin $00000000; insert "1080 Snowboarding (JU) (M2) [!].z64" // Include USA/JPN 1080 Snowboarding N64 ROM
origin $00000020
db "1080 SNOWBOARDING WS       " // $00000020 - PROGRAM TITLE (27 Byte ASCII String, Use Spaces For Unused Bytes)

include "LIB/N64.INC" // Include N64 Definitions

origin $00E33C04
                  // ROM       RAM         Widescreen (Streched)
addiu t6,r0,$01AB // $00E33C04 $800F8FE8 - (4 Bytes) (LW T6,$00B8(A0): $8C8E00B8)