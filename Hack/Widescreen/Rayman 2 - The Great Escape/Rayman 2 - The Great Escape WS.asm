// N64 "Rayman 2 - The Great Escape" Widescreen Hack by krom (Peter Lemon):
// Special thanks to gamemasterplc

arch n64.cpu
endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "Rayman 2 - The Great Escape WS.z64", create
origin $00000000; insert "Rayman 2 - The Great Escape (U) (M5) [!].z64" // Include USA Rayman 2 - The Great Escape N64 ROM
origin $00000020
db "Rayman 2 WS                " // $00000020 - PROGRAM TITLE (27 Byte ASCII String, Use Spaces For Unused Bytes)

include "LIB/N64.INC" // Include N64 Definitions

origin $00091E80
                  // ROM       RAM         Widescreen (Streched)
addiu v0,r0,$0190 // $00091E80 $80099E10 - (4 Bytes) (LW V0,$006C(SP): $8FA2006C)

origin $00091EA4
                  // ROM       RAM         Widescreen (Streched)
addiu v0,r0,$00E0 // $00091EA4 $80099E34 - (4 Bytes) (LW V0,$0068(SP): $8FA20068)

origin $00081C34
                  // ROM       RAM         Widescreen (Streched)
jr ra             // $00081C34 $80089BC4 - (4 Bytes) (LWC1 F0,$0000(A1): $C4A00000)
addiu v0,r0,$0001 // $00081C38 $80089BC8 - (4 Bytes) (LUI AT,$800D: $3C01800D)