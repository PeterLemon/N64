// N64 "Super Mario 64" Widescreen Hack by krom (Peter Lemon):
// Special thanks to gamemasterplc

arch n64.cpu
endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "Super Mario 64 WS.z64", create
origin $00000000; insert "Super Mario 64 (U) [!].z64" // Include USA Super Mario 64 N64 ROM
origin $00000020
db "SUPER MARIO 64 WS          " // $00000020 - PROGRAM TITLE (27 Byte ASCII String, Use Spaces For Unused Bytes)

include "LIB/N64.INC" // Include N64 Definitions

origin $000E0034
             // ROM       RAM         Widescreen (Streched)
lui a3,$3FE3 // $000E0034 $80325034 - (4 Bytes) (MFC1 A3,F14: $44077000)

origin $000386A0
             // ROM       RAM         Widescreen (Streched)
dw $10000003 // $000386A0 $8027D6A0 - (4 Bytes) (BC1F $8027D6B0: $45000003)

origin $000386D4
             // ROM       RAM         Widescreen (Streched)
dw $10000003 // $000386D4 $8027D6D4 - (4 Bytes) (BC1F $8027D6E4: $45000003)