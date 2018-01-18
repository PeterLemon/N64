// N64 "Paper Mario" Widescreen Hack by krom (Peter Lemon):
// Special thanks to gamemasterplc

arch n64.cpu
endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "Paper Mario WS.z64", create
origin $00000000; insert "Paper Mario (U) [!].z64" // Include USA Paper Mario N64 ROM
origin $00000020
db "PAPER MARIO WS             " // $00000020 - PROGRAM TITLE (27 Byte ASCII String, Use Spaces For Unused Bytes)

include "LIB/N64.INC" // Include N64 Definitions

origin $00008974
                  // ROM       RAM         Widescreen (Streched)
addiu a3,r0,$018A // $00008974 $8002D574 - (4 Bytes) (LH A3,$000A(S0): $8607000A)