// N64 "Cruis'n World" Widescreen Hack by krom (Peter Lemon):
// Special thanks to theboy181

arch n64.cpu
endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "Cruis'n World WS.z64", create
origin $00000000; insert "Cruis'n World (U) [!].z64" // Include USA Cruis'n World N64 ROM
origin $00000020
db "CRUIS'N WORLD WS           " // $00000020 - PROGRAM TITLE (27 Byte ASCII String, Use Spaces For Unused Bytes)

include "LIB/N64.INC" // Include N64 Definitions

origin $000A5410
                   // ROM       RAM         Widescreen (Streched)
float32 1.77777777 // $000A5410 $80351810 - (IEEE32) (1.33333333)