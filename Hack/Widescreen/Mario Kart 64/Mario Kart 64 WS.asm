// N64 "Mario Kart 64" Widescreen ROM Hack by gamemasterplc:

arch n64.cpu
endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "Mario Kart 64 WS.z64", create
origin $00000000; insert "Mario Kart 64 (U) [!].z64" // Include USA Mario Kart 64 N64 ROM
origin $00000020
db "MARIOKART64 WS             " // $00000020 - PROGRAM TITLE (27 Byte ASCII String, Use Spaces For Unused Bytes)

include "LIB/N64.INC" // Include N64 Definitions

origin $000952B8
li a3,$3FE38E39 // Rotating Nintendo Logo Aspect Ratio (1.77777777f)

origin $000953EC
li a3,$3FE38E39 // Title Screen Flag Aspect Ratio (1.77777777f)

origin $0012322C
float32 1.77777777 // 1 Player Mode Aspect Ratio
float32 0.88888888 // 2 Player Vertical Splitscreen Aspect Ratio
float32 3.55555555 // 2 Player Horizontal Splitscreen Aspect Ratio
float32 1.77777777 // 3 Player and 4 Player Mode Aspect Ratio