// N64 "Wheel of Fortune" Widescreen Hack by krom (Peter Lemon):
// Special thanks to theboy181

arch n64.cpu
endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "Wheel of Fortune WS.z64", create
origin $00000000; insert "Wheel of Fortune (U) [!].z64" // Include USA Wheel of Fortune N64 ROM
origin $00000020
db "WHEEL OF FORTUNE WS        " // $00000020 - PROGRAM TITLE (27 Byte ASCII String, Use Spaces For Unused Bytes)

include "LIB/N64.INC" // Include N64 Definitions

origin $000178C4
                // ROM       RAM         Widescreen (Streched)
li a3,$3FE38E39 // $000178C4 $80016CC4 - (8 Bytes) (LUI A3,$3FAA: $3C073FAA, ORI A3,$AAAB: $34E7AAAB)