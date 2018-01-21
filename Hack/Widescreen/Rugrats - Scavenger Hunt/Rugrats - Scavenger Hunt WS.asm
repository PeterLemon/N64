// N64 "Rugrats - Scavenger Hunt" Widescreen Hack by krom (Peter Lemon):
// Special thanks to gamemasterplc

arch n64.cpu
endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "Rugrats - Scavenger Hunt WS.z64", create
origin $00000000; insert "Rugrats - Scavenger Hunt (U) [!].z64" // Include USA Rugrats - Scavenger Hunt N64 ROM
origin $00000020
db "RUGRATSSCAVENGERHUNT WS    " // $00000020 - PROGRAM TITLE (27 Byte ASCII String, Use Spaces For Unused Bytes)

include "LIB/N64.INC" // Include N64 Definitions

origin $000104C0
             // ROM       RAM         Widescreen (Streched)
lui a3,$4036 // $000104C0 $8000F8C0 - (4 Bytes) (LUI A3,$4008: $3C074008)

origin $0001F024
             // ROM       RAM         Widescreen (Streched)
lui a3,$4036 // $0001F024 $8001E424 - (4 Bytes) (LUI A3,$4008: $3C074008)