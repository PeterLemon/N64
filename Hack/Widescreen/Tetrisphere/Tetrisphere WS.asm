// N64 "Tetrisphere" Widescreen Hack by krom (Peter Lemon):
// Special thanks to theboy181

arch n64.cpu
endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "Tetrisphere WS.z64", create
origin $00000000; insert "Tetrisphere (U) [!].z64" // Include USA Tetrisphere N64 ROM
origin $00000020
db "TETRISPHERE WS             " // $00000020 - PROGRAM TITLE (27 Byte ASCII String, Use Spaces For Unused Bytes)

include "LIB/N64.INC" // Include N64 Definitions

origin $0000CEF4
                // ROM       RAM         Widescreen (Streched)
li a3,$3FE38E39 // $0000CEF4 $80031B44 - (8 Bytes) (LUI A3,$3FAA: $3C073FAA, ORI A3,$AAAB: $34E7AAAB)

origin $00014600
                // ROM       RAM         Widescreen (Streched)
li a3,$3FE38E39 // $00014600 $80039250 - (8 Bytes) (LUI A3,$3FAA: $3C073FAA, ORI A3,$AAAB: $34E7AAAB)

origin $00016988
                // ROM       RAM         Widescreen (Streched)
li a3,$3FE38E39 // $00016988 $8003B5D8 - (8 Bytes) (LUI A3,$3FAA: $3C073FAA, ORI A3,$AAAB: $34E7AAAB)

origin $000A8810
                // ROM       RAM         Widescreen (Streched)
li a3,$3FE38E39 // $000A8810 $800CD460 - (8 Bytes) (LUI A3,$3FAA: $3C073FAA, ORI A3,$AAAB: $34E7AAAB)