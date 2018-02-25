// N64 "Clay Fighter - Sculptor's Cut" Widescreen Hack by krom (Peter Lemon):
// Special thanks to theboy181

arch n64.cpu
endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "Clay Fighter - Sculptor's Cut WS.z64", create
origin $00000000; insert "Clay Fighter - Sculptor's Cut (U) [!].z64" // Include USA Clay Fighter - Sculptor's Cut N64 ROM
origin $00000020
db "Clayfighter SC WS          " // $00000020 - PROGRAM TITLE (27 Byte ASCII String, Use Spaces For Unused Bytes)

include "LIB/N64.INC" // Include N64 Definitions

origin $00080B58
                // ROM       RAM         Widescreen (Streched)
li a3,$3FE38E39 // $00080B58 $8007FF58 - (8 Bytes) (LUI A3,$3FAA: $3C073FAA, ORI A3,$AAAB: $34E7AAAB)