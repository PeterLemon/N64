// N64 "Hydro Thunder" Widescreen Hack by krom (Peter Lemon):
// Special thanks to theboy181

arch n64.cpu
endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "Hydro Thunder WS.z64", create
origin $00000000; insert "Hydro Thunder (U) [!].z64" // Include USA Hydro Thunder N64 ROM
origin $00000020
db "HYDRO THUNDER WS           " // $00000020 - PROGRAM TITLE (27 Byte ASCII String, Use Spaces For Unused Bytes)

include "LIB/N64.INC" // Include N64 Definitions

origin $0006290C
                // ROM       RAM         Widescreen (Streched)
li at,$3FE38E39 // $0006290C $8020B20C - (8 Bytes) (LUI AT,$3FAA: $3C013FAA, ORI AT,$AAAB: $3421AAAB)