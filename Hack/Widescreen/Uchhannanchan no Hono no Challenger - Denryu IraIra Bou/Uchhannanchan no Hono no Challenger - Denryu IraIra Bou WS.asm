// N64 "Uchhannanchan no Hono no Challenger - Denryu IraIra Bou" Widescreen Hack by krom (Peter Lemon):

arch n64.cpu
endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "Uchhannanchan no Hono no Challenger - Denryu IraIra Bou WS.z64", create
origin $00000000; insert "Uchhannanchan no Hono no Challenger - Denryu IraIra Bou (J) [!].z64" // Include JPN Uchhannanchan no Hono no Challenger - Denryu IraIra Bou N64 ROM
origin $0000002E
db "WS           " // $00000020 - PROGRAM TITLE (27 Byte ASCII String, Use Spaces For Unused Bytes)

include "LIB/N64.INC" // Include N64 Definitions

origin $00008A28
                // ROM       RAM         Widescreen (Streched)
li a3,$3FE38E39 // $00008A28 $80007E28 - (8 Bytes) (LUI A3,$3FAA: $3C073FAA, ORI A3,$AAAB: $34E7AAAB)

origin $00021CCC
                // ROM       RAM         Widescreen (Streched)
li a3,$3FE38E39 // $00021CCC $800210CC - (8 Bytes) (LUI A3,$3FAA: $3C073FAA, ORI A3,$AAAB: $34E7AAAB)

origin $0002A080
                // ROM       RAM         Widescreen (Streched)
li a3,$3FE38E39 // $0002A080 $80029480 - (8 Bytes) (LUI A3,$3FAA: $3C073FAA, ORI A3,$AAAB: $34E7AAAB)