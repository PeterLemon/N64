// N64 "Robotron 64" Widescreen Hack by krom (Peter Lemon):
// Special thanks to theboy181

arch n64.cpu
endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "Robotron 64 WS.z64", create
origin $00000000; insert "Robotron 64 (U) [!].z64" // Include USA Robotron 64 N64 ROM
origin $00000020
db "ROBOTRON-64 WS             " // $00000020 - PROGRAM TITLE (27 Byte ASCII String, Use Spaces For Unused Bytes)

include "LIB/N64.INC" // Include N64 Definitions

origin $00049B0C
             // ROM       RAM         Widescreen (Streched)
lui a3,$3FE3 // $00049B0C $80048F0C - (4 Bytes) (LUI A3,$3FAA: $3C073FAA)

origin $00049B18
             // ROM       RAM         Widescreen (Streched)
ori a3,$8E39 // $00049B18 $80048F18 - (4 Bytes) (ORI A3,$AAAB: $34E7AAAB)