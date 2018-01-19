// N64 "Star Wars Episode I - Racer" Widescreen Hack by krom (Peter Lemon):
// Special thanks to gamemasterplc

arch n64.cpu
endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "Star Wars Episode I - Racer WS.z64", create
origin $00000000; insert "Star Wars Episode I - Racer (U) [!].z64" // Include USA Star Wars Episode I - Racer N64 ROM
origin $00000020
db "STAR WARS EP1 RACER WS     " // $00000020 - PROGRAM TITLE (27 Byte ASCII String, Use Spaces For Unused Bytes)

include "LIB/N64.INC" // Include N64 Definitions

origin $00086BC4
                  // ROM       RAM         Widescreen (Streched)
addiu a1,r0,$01A2 // $00086BC4 $80085FC4 - (4 Bytes) (LW A1,$0028(A0): $8C850028)

origin $00086BFC
             // ROM       RAM         Widescreen (Streched)
lui at,$3F2A // $00086BFC $80085FFC - (4 Bytes) (LUI AT,$3F00: $3C013F00)