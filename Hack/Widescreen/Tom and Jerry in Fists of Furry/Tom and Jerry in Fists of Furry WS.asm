// N64 "Tom and Jerry in Fists of Furry" Widescreen Hack by krom (Peter Lemon):
// Special thanks to theboy181

arch n64.cpu
endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "Tom and Jerry in Fists of Furry WS.z64", create
origin $00000000; insert "Tom and Jerry in Fists of Furry (U) [!].z64" // Include USA Tom and Jerry in Fists of Furry N64 ROM
origin $00000020
db "TOM AND JERRY WS           " // $00000020 - PROGRAM TITLE (27 Byte ASCII String, Use Spaces For Unused Bytes)

include "LIB/N64.INC" // Include N64 Definitions

origin $0000D370
                // ROM       RAM         Widescreen (Streched)
li a3,$3FE38E39 // $0000D370 $8000C770 - (8 Bytes) (LUI A3,$3FAA: $3C073FAA, ORI A3,$AAAB: $34E7AAAB)