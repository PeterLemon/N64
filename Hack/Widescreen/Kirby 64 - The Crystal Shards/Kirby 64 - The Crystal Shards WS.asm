// N64 "Kirby 64 - The Crystal Shards" Widescreen Hack by krom (Peter Lemon):
// Special thanks to gamemasterplc

arch n64.cpu
endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "Kirby 64 - The Crystal Shards WS.z64", create
origin $00000000; insert "Kirby 64 - The Crystal Shards (U) [!].z64" // Include USA Kirby 64 - The Crystal Shards N64 ROM
origin $00000020
db "Kirby64 WS                 " // $00000020 - PROGRAM TITLE (27 Byte ASCII String, Use Spaces For Unused Bytes)

include "LIB/N64.INC" // Include N64 Definitions

origin $0001BCE0
            // ROM       RAM         Widescreen (Streched)
j $80040D10 // $0001BCE0 $8001B0E0 - (4 Bytes) (NOP: $00000000)

origin $00041910
               // ROM       RAM         Widescreen (Streched)
lui k1,$3F40   // $00041910 $80040D10 - (4 Bytes) ("Inte": $496E7465)
mtc1 k1,f4     // $00041914 $80040D14 - (4 Bytes) ("rrup": $72727570)
j $8001B0E8    // $00041918 $80040D18 - (4 Bytes) ("t...": $74000000)
mul.s f8,f8,f4 // $0004191C $80040D1C - (4 Bytes) ("TLB ": $544C4220)