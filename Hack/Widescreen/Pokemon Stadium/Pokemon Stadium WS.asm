// N64 "Pokemon Stadium" Widescreen Hack by krom (Peter Lemon):
// Special thanks to gamemasterplc

arch n64.cpu
endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "Pokemon Stadium WS.z64", create
origin $00000000; insert "Pokemon Stadium (U) (V1.1) [!].z64" // Include USA Pokemon Stadium N64 ROM
origin $00000020
db "POKEMON STADIUM WS         " // $00000020 - PROGRAM TITLE (27 Byte ASCII String, Use Spaces For Unused Bytes)

include "LIB/N64.INC" // Include N64 Definitions

origin $00012A6C
             // ROM       RAM         Widescreen (Streched)
addiu t7,r0,$00F0 // $00012A6C $80011E6C - (4 Bytes) (LH T7,$0022(A0): $848F0022)
addiu t6,r0,$01AB // $00012A70 $80011E70 - (4 Bytes) (LH T6,$0020(A0): $848E0020)