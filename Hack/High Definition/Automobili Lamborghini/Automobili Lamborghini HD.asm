// N64 "Automobili Lamborghini" High Definition Hack by krom (Peter Lemon):
// Special thanks to theboy181 & retroben

arch n64.cpu
endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "Automobili Lamborghini HD.z64", create
origin $00000000; insert "Automobili Lamborghini (U) [!].z64" // Include USA Automobili Lamborghini N64 ROM
origin $00000020
db "LAMBORGHINI HD             " // $00000020 - PROGRAM TITLE (27 Byte ASCII String, Use Spaces For Unused Bytes)

include "LIB/N64.INC" // Include N64 Definitions

origin $0000CDA4
    // ROM       RAM         Car LOD (Level Of Detail)
nop // $0000CDA4 $8000C1A4 - (4 Bytes) (BEQZ AT,$8000C1B4: $10200003)

origin $0000CDD4
    // ROM       RAM         Car LOD (Level Of Detail)
nop // $0000CDD4 $8000C1D4 - (4 Bytes) (BNEZ AT,$8000C17C: $1420FFE9)

origin $0000CDF0
                  // ROM       RAM         Car LOD (Level Of Detail)
addiu t7,r0,$0000 // $0000CDF0 $8000C1F0 - (4 Bytes) (ADDU T7,T4,T1: $01897821)

origin $0000CEB0
                  // ROM       RAM         Car LOD (Level Of Detail)
addiu t7,r0,$0000 // $0000CEB0 $8000C2B0 - (4 Bytes) (ADDIU T7,R0,$FFFF: $240FFFFF)

origin $0000CEC0
                  // ROM       RAM         Car LOD (Level Of Detail)
addiu t6,r0,$0001 // $0000CEC0 $8000C2C0 - (4 Bytes) (LH T6,$8720(T6): $85CE8720)


origin $00005A90
                 // ROM       RAM         Enable Effect In MP (Multi Player)
slti at,t5,$00FF // $00005A90 $80004E90 - (4 Bytes) (SLTI AT,T5,$0003: $29A10003)

origin $0000C9D8
                 // ROM       RAM         Enable Effect In MP (Multi Player)
slti at,t6,$00FF // $0000C9D8 $8000BDD8 - (4 Bytes) (SLTI AT,T6,$0003: $29C10003)

origin $0000DBA0
                 // ROM       RAM         Enable Effect In MP (Multi Player)
slti at,t4,$00FF // $0000DBA0 $8000CFA0 - (4 Bytes) (SLTI AT,T4,$0002: $29810002)

origin $0000E434
                 // ROM       RAM         Enable Effect In MP (Multi Player)
slti at,t5,$00FF // $0000E434 $8000D834 - (4 Bytes) (SLTI AT,T5,$0002: $29A10002)

origin $0002903C
                 // ROM       RAM         Enable Effect In MP (Multi Player)
slti at,t6,$00FF // $0002903C $8002843C - (4 Bytes) (SLTI AT,T6,$0003: $29C10003)


origin $00004E04
             // ROM       RAM         Improved DD (Draw Distance)
lui at,$4700 // $00004E04 $80004204 - (4 Bytes) (LUI AT,$43E1: $3C0143E1)

origin $00004EBC
             // ROM       RAM         Improved DD (Draw Distance)
lui at,$4700 // $00004EBC $800042BC - (4 Bytes) (LUI AT,$43E1: $3C0143E1)

origin $00089BD0
                // ROM       RAM         Improved DD (Draw Distance)
float32 75000.0 // $00089BD0 $80088FD0 - (IEEE32) (55000.0)

origin $0008E2E0
               // ROM       RAM         Improved DD (Draw Distance)
float32 9000.0 // $0008E2E0 $8008D6E0 - (IEEE32) (550.0)
float32 9000.0 // $0008E2E4 $8008D6E4 - (IEEE32) (275.0)


origin $00004D90
             // ROM       RAM         Widescreen (Streched)
lui a3,$3FE3 // $00004D90 $80004190 - (4 Bytes) (LUI A3,$3FAA: $3C073FAA)

origin $00004F58
             // ROM       RAM         Widescreen (Streched)
lui a3,$3FE3 // $00004F58 $80004358 - (4 Bytes) (LUI A3,$3FAA: $3C073FAA)

origin $000438E0
             // ROM       RAM         Widescreen (Streched)
lui a3,$3FE3 // $000438E0 $80042CE0 - (4 Bytes) (LUI A3,$3FAA: $3C073FAA)

origin $0007617C
             // ROM       RAM         Widescreen (Streched)
lui at,$3FE9 // $0007617C $8007557C - (4 Bytes) (LUI AT,$3FF0: $3C013FF0)