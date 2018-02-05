// N64 "Last Legion UX" Widescreen Hack by krom (Peter Lemon):
// Special thanks to theboy181

arch n64.cpu
endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "Last Legion UX WS.z64", create
origin $00000000; insert "Last Legion UX (J) [!].z64" // Include JPN Last Legion UX N64 ROM
origin $00000020
db "LASTLEGION UX WS           " // $00000020 - PROGRAM TITLE (27 Byte ASCII String, Use Spaces For Unused Bytes)

include "LIB/N64.INC" // Include N64 Definitions

origin $0000C5B4
             // ROM       RAM         Widescreen (Streched)
lui a3,$3FE3 // $0000C5B4 $800311B4 - (4 Bytes) (LUI A3,$3FAA: $3C073FAA)

origin $0002B750
             // ROM       RAM         Widescreen (Streched)
lui a3,$3FE3 // $0002B750 $80050350 - (4 Bytes) (LUI A3,$3FAA: $3C073FAA)