// N64 "Banjo-Kazooie (1.1)" Widescreen ROM Hack by gamemasterplc:

arch n64.cpu
endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "Banjo-Kazooie WS.z64", create
origin $00000000; insert "Banjo-Kazooie (U) (V1.1) [!].z64" // Include USA 1.1 Banjo Kazooie N64 ROM
origin $00000020
db "Banjo-Kazooie WS           " // $00000020 - PROGRAM TITLE (27 Byte ASCII String, Use Spaces For Unused Bytes)

include "LIB/N64.INC" // Include N64 Definitions

origin $00001034 // 7 Instructions of Free Space
aspectcorrections:
lui a1,$4334 // Render Fix Value
lui at,$8027 // Upper Half of Addresses
sw a1,$683C(at) // Left Side Render Fix
sw a1,$6840(at) // Right Side Render Fix
lui a1,$3FE6 // Upper Half of Aspect Ratio Value
jalr ra,t9 // Call game
sw a1,$4B74(at) // Update Aspect Ratio Value (Delay Slot)

origin $0000112C
j $80000434 // Jump to Aspect Corrections