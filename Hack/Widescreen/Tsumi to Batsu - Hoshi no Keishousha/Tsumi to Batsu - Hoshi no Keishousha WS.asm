// N64 "Tsumi to Batsu - Hoshi no Keishousha" Widescreen Hack by krom (Peter Lemon):
// Special thanks to gamemasterplc

arch n64.cpu
endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "Tsumi to Batsu - Hoshi no Keishousha WS.z64", create
origin $00000000; insert "Tsumi to Batsu - Hoshi no Keishousha (J) [!].z64" // Include JPN Tsumi to Batsu - Hoshi no Keishousha N64 ROM
origin $00000020
db "TSUMI TO BATSU WS          " // $00000020 - PROGRAM TITLE (27 Byte ASCII String, Use Spaces For Unused Bytes)

include "LIB/N64.INC" // Include N64 Definitions

origin $0003E0CC
             // ROM       RAM         Widescreen (Streched)
dw $3FE3AAAB // $0003E0CC $80062CCC - (4 Bytes) ($3FAAAAAB)