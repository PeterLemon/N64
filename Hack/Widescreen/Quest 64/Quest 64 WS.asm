// N64 "Quest 64" Widescreen Hack by krom (Peter Lemon):
// Special thanks to theboy181

arch n64.cpu
endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "Quest 64 WS.z64", create
origin $00000000; insert "Quest 64 (U) [!].z64" // Include USA Quest 64 N64 ROM
origin $00000020
db "Quest 64 WS                " // $00000020 - PROGRAM TITLE (27 Byte ASCII String, Use Spaces For Unused Bytes)

include "LIB/N64.INC" // Include N64 Definitions

origin $0001392C
                // ROM       RAM         Widescreen (Streched)
li a3,$3FE38E39 // $0001392C $80012D2C - (8 Bytes) (LUI A3,$3FAA: $3C073FAA, ORI A3,$AAAB: $34E7AAAB)