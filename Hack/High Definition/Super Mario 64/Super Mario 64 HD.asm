// N64 "Super Mario 64" High Definition Hack by krom (Peter Lemon):
// Special thanks to theboy181

arch n64.cpu
endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "Super Mario 64 HD.z64", create
origin $00000000; insert "Super Mario 64 (U) [!].z64" // Include USA Super Mario 64 N64 ROM
origin $00000020
db "SUPER MARIO 64 HD          " // $00000020 - PROGRAM TITLE (27 Byte ASCII String, Use Spaces For Unused Bytes)

include "LIB/N64.INC" // Include N64 Definitions

origin $00032184
             // ROM       RAM         Fixed LOD for Mario's Model
dw $10000007 // $00032184 $80277184 - (4 Bytes) (BNE A0,AT,$802771A4: $14810007)

origin $00038550
             // ROM       RAM         Extended Draw Distance
lui at,$4100 // $00038550 $8027D550 - (4 Bytes) (LUI AT,$3F80: $3C013F80)

origin $00066F68
    // ROM       RAM         Extended Draw Distance
nop // $00066F68 $802ABF68 - (4 Bytes) (BC1F $802ABF68: $4500001A)

origin $00066FE8
    // ROM       RAM         Extended Draw Distance
nop // $00066FE8 $802ABFE8 - (4 Bytes) (LWC1 F10,$7990(AT): $C42A7990)

origin $000A03AC
    // ROM       RAM         Extended Draw Distance
nop // $000A03AC $802E53AC - (4 Bytes) (BNE V0,AT,$802E53CC: $14410007)

origin $000BA24C
    // ROM       RAM         Extended Draw Distance
nop // $000BA24C $802FF24C - (4 Bytes) (BC1F $802FF3B8: $4500005A)

origin $000BA3C8
             // ROM       RAM         Extended Draw Distance
lui at,$4979 // $000BA3C8 $802FF3C8 - (4 Bytes) (LUI AT,$457A: $3C01457A)

origin $000BAC88
    // ROM       RAM         Extended Draw Distance
nop // $000BAC88 $802FFC88 - (4 Bytes) (BC1F $802FFD90: $45000041)

origin $000BB960
             // ROM       RAM         Extended Draw Distance
lui at,$497A // $000BB960 $80300960 - (4 Bytes) (LUI AT,$457A: $3C01457A)

origin $000C4EF8
    // ROM       RAM         Extended Draw Distance
nop // $000C4EF8 $80309EF8 - (4 Bytes) (BC1F $80309F50: $45000015)

origin $000C4F8C
             // ROM       RAM         Extended Draw Distance
dw $10000006 // $000C4F8C $80309F8C - (4 Bytes) (BC1F $80309FA8: $45000006)

origin $0010089C
    // ROM       RAM         Extended Draw Distance
nop // $0010089C $80383B1C - (4 Bytes) (BC1F $80383B3C: $45000007)

origin $00102C78
             // ROM       RAM         Extended Draw Distance
dw $1000000D // $00102C78 $80385EF8 - (4 Bytes) (BC1F $80385F30: $4500000D)