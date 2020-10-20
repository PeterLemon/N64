// N64 "Vigilante 8" High Definition Hack by krom (Peter Lemon):
// Special thanks to theboy181

arch n64.cpu
endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "Vigilante 8 HD.z64", create
origin $00000000; insert "Vigilante 8 (U) [!].z64" // Include USA Vigilante 8 N64 ROM
origin $00000020
db "VIGILANTE 8 HD             " // $00000020 - PROGRAM TITLE (27 Byte ASCII String, Use Spaces For Unused Bytes)

include "LIB/N64.INC" // Include N64 Definitions

origin $000070BC
    // ROM       RAM         Performance Boost 60FPS
nop // $000070BC $8012B8BC - (4 Bytes) (BEQZ A0,0x8012B8FC: $1080000F)

origin $000070EC
                  // ROM       RAM         Performance Boost 60FPS
addiu t7,r0,$0001 // $000070EC $8012B8EC - (4 Bytes) (ADDIU T7,R0,$0002: $240F0002)