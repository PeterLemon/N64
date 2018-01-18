// N64 "Beetle Adventure Racing!" Widescreen Hack by krom (Peter Lemon):
// Special thanks to gamemasterplc

arch n64.cpu
endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "Beetle Adventure Racing! WS.z64", create
origin $00000000; insert "Beetle Adventure Racing! (U) (M3) [!].z64" // Include USA Beetle Adventure Racing! N64 ROM
origin $00000020
db "Beetle Adventure Rac WS    " // $00000020 - PROGRAM TITLE (27 Byte ASCII String, Use Spaces For Unused Bytes)

include "LIB/N64.INC" // Include N64 Definitions

origin $0003F05C
             // ROM       RAM         Widescreen (Streched)
lui at,$3F2B // $0003F05C $80178BF4 - (4 Bytes) (LUI AT,$3F00: $3C013F00)

origin $0003F07C
             // ROM       RAM         Widescreen (Streched)
lui at,$3F2B // $0003F07C $80178C14 - (4 Bytes) (LUI AT,$3F00: $3C013F00)