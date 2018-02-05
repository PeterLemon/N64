// N64 "Snowboard Kids 2" Widescreen Hack by krom (Peter Lemon):
// Special thanks to gamemasterplc

arch n64.cpu
endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "Snowboard Kids 2 WS.z64", create
origin $00000000; insert "Snowboard Kids 2 (U) [!].z64" // Include USA Snowboard Kids 2 N64 ROM
origin $00000020
db "SNOWBOARD KIDS2 WS         " // $00000020 - PROGRAM TITLE (27 Byte ASCII String, Use Spaces For Unused Bytes)

include "LIB/N64.INC" // Include N64 Definitions

origin $00001038
                 // ROM       RAM         Widescreen (Streched)
mtc1 a3,f22      // $00001038 $80000438 - (4 Bytes) (ADDIU SP,-$4FE0: $27BDB020)
lui a3,$3FAA     // $0000103C $8000043C - (4 Bytes) (NOP: $00000000)
mtc1 a3,f0       // $00001040 $80000440 - (4 Bytes) (NOP: $00000000)
nop              // $00001044 $80000444 - (4 Bytes) (NOP: $00000000)
j $80075CC8      // $00001048 $80000448 - (4 Bytes) (NOP: $00000000)
mul.s f22,f0,f22 // $0000104C $8000044C - (4 Bytes) (NOP: $00000000)

origin $000768C0
            // ROM       RAM         Widescreen (Streched)
j $80000438 // $000768C0 $80075CC0 - (4 Bytes) (MTC1 A3,F22: $4487B000)