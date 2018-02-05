// N64 "V-Rally Edition 99" Widescreen Hack by krom (Peter Lemon):
// Special thanks to theboy181

arch n64.cpu
endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "V-Rally Edition 99 WS.z64", create
origin $00000000; insert "V-Rally Edition 99 (U) [!].z64" // Include USA V-Rally Edition 99 N64 ROM
origin $00000020
db "V-RALLY WS                 " // $00000020 - PROGRAM TITLE (27 Byte ASCII String, Use Spaces For Unused Bytes)

include "LIB/N64.INC" // Include N64 Definitions

origin $000117C8
             // ROM       RAM         Widescreen (Streched)
lui at,$3FAA // $000117C8 $80010BC8 - (4 Bytes) (LUI AT,$3F80: $3C013F80)

origin $00011814
             // ROM       RAM         Widescreen (Streched)
lui at,$3EF0 // $00011814 $80010C14 - (4 Bytes) (LUI AT,$3ECC: $3C013ECC)