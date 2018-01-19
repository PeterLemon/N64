// N64 "Bomberman Hero" Widescreen Hack by krom (Peter Lemon):
// Special thanks to gamemasterplc

arch n64.cpu
endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "Bomberman Hero WS.z64", create
origin $00000000; insert "Bomberman Hero (U) [!].z64" // Include USA Bomberman Hero N64 ROM
origin $00000020
db "BOMBERMAN HERO WS          " // $00000020 - PROGRAM TITLE (27 Byte ASCII String, Use Spaces For Unused Bytes)

include "LIB/N64.INC" // Include N64 Definitions

origin $00037A94
             // ROM       RAM         Widescreen (Streched)
lui a3,$3FE3 // $00037A94 $80036E94 - (4 Bytes) (MFC1 A3,F14: $44077000)