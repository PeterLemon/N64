// N64 "Deadly Arts" Widescreen Hack by krom (Peter Lemon):
// Special thanks to gamemasterplc

arch n64.cpu
endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "Deadly Arts WS.z64", create
origin $00000000; insert "Deadly Arts (U) [!].z64" // Include USA Deadly Arts N64 ROM
origin $00000020
db "DeadlyArts WS              " // $00000020 - PROGRAM TITLE (27 Byte ASCII String, Use Spaces For Unused Bytes)

include "LIB/N64.INC" // Include N64 Definitions

origin $000328BC
                   // ROM       RAM         Widescreen (Streched)
float32 1.77777777 // $000328BC $80031CBC - (IEEE32) (1.33333333)