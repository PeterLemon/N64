// N64 "Automobili Lamborghini" Widescreen Hack by krom (Peter Lemon):
// Special thanks to theboy181

arch n64.cpu
endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "Automobili Lamborghini WS.z64", create
origin $00000000; insert "Automobili Lamborghini (U) [!].z64" // Include USA Automobili Lamborghini N64 ROM
origin $00000020
db "LAMBORGHINI WS             " // $00000020 - PROGRAM TITLE (27 Byte ASCII String, Use Spaces For Unused Bytes)

include "LIB/N64.INC" // Include N64 Definitions

origin $00004D90
                // ROM       RAM         Widescreen (Streched)
li a3,$3FE38E39 // $00004D90 $80004190 - (8 Bytes) (LUI A3,$3FAA: $3C073FAA, ORI A3,$AAAB: $34E7AAAB)

origin $00004F58
                // ROM       RAM         Widescreen (Streched)
li a3,$3FE38E39 // $00004F58 $80004358 - (8 Bytes) (LUI A3,$3FAA: $3C073FAA, ORI A3,$AAAB: $34E7AAAB)

origin $000438E0
                // ROM       RAM         Widescreen (Streched)
li a3,$3FE38E39 // $000438E0 $80042CE0 - (8 Bytes) (LUI A3,$3FAA: $3C073FAA, ORI A3,$AAAB: $34E7AAAB)

origin $0007617C
             // ROM       RAM         Widescreen (Streched)
lui at,$3FE9 // $0007617C $8007557C - (4 Bytes) (LUI AT,$3FF0: $3C013FF0)