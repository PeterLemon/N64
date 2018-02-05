// N64 "Virtual Chess 64" Widescreen Hack by krom (Peter Lemon):
// Special thanks to theboy181

arch n64.cpu
endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "Virtual Chess 64 WS.z64", create
origin $00000000; insert "Virtual Chess 64 (U) (M3) [!].z64" // Include USA Virtual Chess 64 N64 ROM
origin $00000020
db "VIRTUALCHESS WS            " // $00000020 - PROGRAM TITLE (27 Byte ASCII String, Use Spaces For Unused Bytes)

include "LIB/N64.INC" // Include N64 Definitions

origin $00012294
             // ROM       RAM         Widescreen (Streched)
lui a3,$3FE3 // $00012294 $80011694 - (4 Bytes) (LUI A3,$3FAA: $3C073FAA)
ori a3,$8E39 // $00012298 $80011698 - (4 Bytes) (ORI A3,$AAAB: $34E7AAAB)