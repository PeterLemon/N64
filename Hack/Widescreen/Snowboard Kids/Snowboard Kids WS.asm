// N64 "Snowboard Kids" Widescreen Hack by krom (Peter Lemon):
// Special thanks to gamemasterplc

arch n64.cpu
endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "Snowboard Kids WS.z64", create
origin $00000000; insert "Snowboard Kids (U) [!].z64" // Include USA Snowboard Kids N64 ROM
origin $00000020
db "SNOWBOARD KIDS WS          " // $00000020 - PROGRAM TITLE (27 Byte ASCII String, Use Spaces For Unused Bytes)

include "LIB/N64.INC" // Include N64 Definitions

origin $00001038
             // ROM       RAM         Widescreen (Streched)
lui a3,$3FAA // $00001038 $80000438 - (4 Bytes) (NOP: $00000000)
ori a3,$AAAB // $0000103C $8000043C - (4 Bytes) (NOP: $00000000)
mtc1 a3,f0   // $00001040 $80000440 - (4 Bytes) (NOP: $00000000)
mtc1 a2,f12  // $00001044 $80000444 - (4 Bytes) (NOP: $00000000)
j $800A3B3C  // $00001048 $80000448 - (4 Bytes) (NOP: $00000000)
mul.s f14,f0 // $0000104C $8000044C - (4 Bytes) (NOP: $00000000)

origin $000A4734
            // ROM       RAM         Widescreen (Streched)
j $80000438 // $000A4734 $800A3B34 - (4 Bytes) (MTC1 A2,F12: $44866000)