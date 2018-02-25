// N64 "Wave Race 64" Widescreen Hack by krom (Peter Lemon):
// Special thanks to gamemasterplc

arch n64.cpu
endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "Wave Race 64 WS.z64", create
origin $00000000; insert "Wave Race 64 (U) (V1.1) [!].z64" // Include USA Wave Race 64 N64 ROM
origin $00000020
db "WAVE RACE 64 WS            " // $00000020 - PROGRAM TITLE (27 Byte ASCII String, Use Spaces For Unused Bytes)

include "LIB/N64.INC" // Include N64 Definitions

origin $000241F8
             // ROM       RAM         Widescreen (Streched)
lui a3,$3FE3 // $000241F8 $800699F8 - (4 Bytes) (LUI A3,$3F80: $3C073F80)

origin $000AF820
             // ROM       RAM         Widescreen (Streched)
lui a3,$3FE3 // $000AF820 $801E11F0 - (4 Bytes) (LUI A3,$3FAA: $3C073FAA)

origin $000BDA20
                // ROM       RAM         Widescreen (Streched)
li a3,$3FE38E39 // $000BDA20 $801EF3F0 - (8 Bytes) (LUI A3,$3FAA: $3C073FAA, ORI A3,$AAAB: $34E7AAAB)

origin $000BEE14
             // ROM       RAM         Widescreen (Streched)
lui a3,$3FE3 // $000BEE14 $801F07E4 - (4 Bytes) (LUI A3,$3FAA: $3C073FAA)

origin $001B94D0
             // ROM       RAM         Widescreen (Streched)
lui a3,$3FAA // $001B94D0 $802C5890 - (4 Bytes) (MFC1 A3,F28: $4407E000)

origin $001B9504
             // ROM       RAM         Widescreen (Streched)
lui a3,$3FAA // $001B9504 $802C58C4 - (4 Bytes) (MFC1 A3,F28: $4407E000)