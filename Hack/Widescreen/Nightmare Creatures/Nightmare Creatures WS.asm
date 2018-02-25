// N64 "Nightmare Creatures" Widescreen Hack by krom (Peter Lemon):
// Special thanks to theboy181

arch n64.cpu
endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "Nightmare Creatures WS.z64", create
origin $00000000; insert "Nightmare Creatures (U) [!].z64" // Include USA Nightmare Creatures N64 ROM
origin $00000020
db "NIGHTMARE CREATURES WS     " // $00000020 - PROGRAM TITLE (27 Byte ASCII String, Use Spaces For Unused Bytes)

include "LIB/N64.INC" // Include N64 Definitions

origin $00075914
                // ROM       RAM         Widescreen (Streched)
li a3,$3FE38E39 // $00075914 $80074D14 - (8 Bytes) (LUI A3,$3FAA: $3C073FAA, ORI A3,$AAAB: $34E7AAAB)