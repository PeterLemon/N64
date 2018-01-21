// N64 "Star Wars - Rogue Squadron" Widescreen Hack by krom (Peter Lemon):
// Special thanks to gamemasterplc

arch n64.cpu
endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "Star Wars - Rogue Squadron WS.z64", create
origin $00000000; insert "Star Wars - Rogue Squadron (U) (M3) [!].z64" // Include USA Star Wars - Rogue Squadron N64 ROM
origin $00000020
db "Rogue Squadron WS          " // $00000020 - PROGRAM TITLE (27 Byte ASCII String, Use Spaces For Unused Bytes)

include "LIB/N64.INC" // Include N64 Definitions

origin $000013DC
             // ROM       RAM         Widescreen (Streched)
dw $3FE3AAAB // $000013DC $800007DC - (4 Bytes) ($3FAAAAAB)

origin $0003B11C
             // ROM       RAM         Widescreen (Streched)
dw $C0AA0000 // $0003B11C $8003A51C - (4 Bytes) ($C0800000)

origin $00129004
                  // ROM       RAM         Widescreen (Streched)
addiu s3,v1,$FE00 // $00129004 $800C1E64 - (4 Bytes) (ADDIU S3,V1,$FFD0: $2473FFD0)

origin $00129018
            // ROM       RAM         Widescreen (Streched)
j $800C0800 // $00129018 $800C1E78 - (4 Bytes) (J $800C1F58: $080307D6)