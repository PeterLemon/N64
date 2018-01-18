// N64 "Super Smash Bros." Widescreen Hack by krom (Peter Lemon):
// Special thanks to gamemasterplc

arch n64.cpu
endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "Super Smash Bros. WS.z64", create
origin $00000000; insert "Super Smash Bros. (U) [!].z64" // Include USA Super Smash Bros. N64 ROM
origin $00000020
db "SMASH BROTHERS WS          " // $00000020 - PROGRAM TITLE (27 Byte ASCII String, Use Spaces For Unused Bytes)

include "LIB/N64.INC" // Include N64 Definitions

origin $0003C484
             // ROM       RAM         Widescreen (Streched)
dw $3FE3AAAB // $0003C484 $8003B884 - (4 Bytes) ($3FAAAAAB)

origin $0004C944
             // ROM       RAM         Widescreen (Streched)
lui a3,$3FE8 // $0004C944 $800D0F64 - (4 Bytes) (LW A3,$0024(S0): $8E070024)

origin $00088A88
             // ROM       RAM         Widescreen (Streched)
lui a3,$3FE8 // $00088A88 $8010D288 - (4 Bytes) (LW A3,$0024(S0): $8E070024)