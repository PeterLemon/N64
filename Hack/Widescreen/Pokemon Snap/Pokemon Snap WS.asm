// N64 "Pokemon Snap" Widescreen Hack by krom (Peter Lemon):
// Special thanks to gamemasterplc

arch n64.cpu
endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "Pokemon Snap WS.z64", create
origin $00000000; insert "Pokemon Snap (U) [!].z64" // Include USA Pokemon Snap N64 ROM
origin $00000020
db "POKEMON SNAP WS            " // $00000020 - PROGRAM TITLE (27 Byte ASCII String, Use Spaces For Unused Bytes)

include "LIB/N64.INC" // Include N64 Definitions

origin $0001D3A0
            // ROM       RAM         Widescreen (Streched)
j $80043E10 // $0001D3A0 $8001C7A0 - (4 Bytes) (NOP: $00000000)

origin $00044A10
               // ROM       RAM         Widescreen (Streched)
lui k1,$3F40   // $00044A10 $80043E10 - (4 Bytes) ("Inte": $496E7465)
mtc1 k1,f4     // $00044A14 $80043E14 - (4 Bytes) ("rrup": $72727570)
j $8001C7A8    // $00044A18 $80043E18 - (4 Bytes) ("t...": $74000000)
mul.s f8,f8,f4 // $00044A1C $80043E1C - (4 Bytes) ("TLB ": $544C4220)

origin $0005BEC8
         // ROM       RAM         Widescreen (Streched)
dw $4300CCCD // $0005BEC8 $800B0518 - (4 Bytes) ($404CCCCD)