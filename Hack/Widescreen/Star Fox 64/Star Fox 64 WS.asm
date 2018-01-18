// N64 "Star Fox 64" Widescreen Hack by krom (Peter Lemon):
// Special thanks to gamemasterplc

arch n64.cpu
endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "Star Fox 64 WS.z64", create
origin $00000000; insert "Star Fox 64 (U) (V1.1) [!].z64" // Include USA Star Fox 64 N64 ROM
origin $00000020
db "STARFOX64 WS               " // $00000020 - PROGRAM TITLE (27 Byte ASCII String, Use Spaces For Unused Bytes)

origin $00003DA2
         // ROM       RAM         Widescreen (Streched)
dh $3FE3 // $00003DA2 $800031A2 - (2 Bytes) ($3FAA)