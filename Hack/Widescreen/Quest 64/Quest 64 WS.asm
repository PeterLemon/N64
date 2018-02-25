// N64 "Quest 64" Widescreen Hack by krom (Peter Lemon):
// Special thanks to gamemasterplc

arch n64.cpu
endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "Quest 64 WS.z64", create
origin $00000000; insert "Quest 64 (U) [!].z64" // Include USA Quest 64 N64 ROM
origin $00000020
db "Quest 64 WS                " // $00000020 - PROGRAM TITLE (27 Byte ASCII String, Use Spaces For Unused Bytes)

include "LIB/N64.INC" // Include N64 Definitions

origin $0001392C
             // ROM       RAM         Widescreen (Streched)
lui a3,$3FE3 // $0001392C $80012D2C - (4 Bytes) (LUI A3,$3FAA: $3C073FAA)
ori a3,$8E39 // $00013930 $80012D30 - (4 Bytes) (ORI A3,$AAAB: $34E7AAAB)