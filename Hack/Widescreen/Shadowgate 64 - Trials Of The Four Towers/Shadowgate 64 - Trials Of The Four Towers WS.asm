// N64 "Shadowgate 64 - Trials Of The Four Towers" Widescreen Hack by krom (Peter Lemon):
// Special thanks to theboy181

arch n64.cpu
endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "Shadowgate 64 - Trials Of The Four Towers WS.z64", create
origin $00000000; insert "Shadowgate 64 - Trials Of The Four Towers (U) (M2) [!].z64" // Include USA Shadowgate 64 - Trials Of The Four Towers N64 ROM
origin $00000020
db "SHADOWGATE64 WS            " // $00000020 - PROGRAM TITLE (27 Byte ASCII String, Use Spaces For Unused Bytes)

include "LIB/N64.INC" // Include N64 Definitions

origin $00016B14
             // ROM       RAM         Widescreen (Streched)
lui t0,$3FAA // $00016B14 $8003B714 - (4 Bytes) (NOP: $00000000)
ori t0,$AAAB // $00016B18 $8003B718 - (4 Bytes) (LUI AT,$3F80: $3C013F80)
mtc1 t0,f12  // $00016B1C $8003B71C - (4 Bytes) (MTC1 AT,F12: $44816000)