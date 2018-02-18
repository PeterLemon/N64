// N64 "Hot Wheels Turbo Racing" Widescreen Hack by krom (Peter Lemon):
// Special thanks to gamemasterplc & theboy181

arch n64.cpu
endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "Hot Wheels Turbo Racing WS.z64", create
origin $00000000; insert "Hot Wheels Turbo Racing (U) [!].z64" // Include USA Hot Wheels Turbo Racing N64 ROM
origin $00000020
db "HOT WHEELS TURBO WS        " // $00000020 - PROGRAM TITLE (27 Byte ASCII String, Use Spaces For Unused Bytes)

include "LIB/N64.INC" // Include N64 Definitions

origin $00011A88
             // ROM       RAM         Widescreen (Streched)
lui at,$4000 // $00011A88 $80070E88 - (4 Bytes) (LUI AT,$3F80: $3C013F80)

origin $00011F58
             // ROM       RAM         Widescreen (Streched)
lui at,$4016 // $00011F58 $80071358 - (4 Bytes) (LUI AT,$4049: $3C014049)

origin $0004F8F0
             // ROM       RAM         Widescreen (Streched)
lui a3,$3FE3 // $0004F8F0 $800AECF0 - (4 Bytes) (LUI A3,$3FAA: $3C073FAA)

origin $0004F900
             // ROM       RAM         Widescreen (Streched)
lui a3,$4063 // $0004F900 $800AED00 - (4 Bytes) (LUI A3,$402A: $3C07402A)

origin $00053EB8
             // ROM       RAM         Widescreen (Streched)
lui a3,$3FE3 // $00053EB8 $800B32B8 - (4 Bytes) (LUI A3,$3FAA: $3C073FAA)


origin $00054828
             // ROM       RAM         Car Menu Fixed For Widescreen
lui at,$3FAA // $00054828 $800B3C28 - (4 Bytes) (LUI AT,$3F80: $3C013F80)

origin $000548B4
             // ROM       RAM         Car Menu Fixed For Widescreen
lui at,$3FFF // $000548B4 $800B3CB4 - (4 Bytes) (LUI AT,$3FC0: $3C013FC0)

origin $000548EC
             // ROM       RAM         Car Menu Fixed For Widescreen
lui at,$3FAA // $000548EC $800B3CEC - (4 Bytes) (LUI AT,$3F80: $3C013F80)


origin $0005A514
    // ROM       RAM         Remove Menu Arrows For Widescreen
nop // $0005A514 $800B9914 - (4 Bytes) (SH S3,$0030(V0): $A4530030)