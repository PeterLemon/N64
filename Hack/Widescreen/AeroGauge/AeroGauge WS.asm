// N64 "AeroGauge" Widescreen Hack by krom (Peter Lemon):
// Special thanks to theboy181

arch n64.cpu
endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "AeroGauge WS.z64", create
origin $00000000; insert "AeroGauge (U) [!].z64" // Include USA AeroGauge N64 ROM
origin $00000020
db "AEROGAUGE WS               " // $00000020 - PROGRAM TITLE (27 Byte ASCII String, Use Spaces For Unused Bytes)

include "LIB/N64.INC" // Include N64 Definitions

origin $0000FC6C
             // ROM       RAM         Widescreen (Streched)
lui a3,$3FE2 // $0000FC6C $8000F06C - (4 Bytes) (LUI A3,$3FAA: $3C073FAA)

origin $000405C4
             // ROM       RAM         Widescreen (Streched)
lui a3,$3FE2 // $000405C4 $8003F9C4 - (4 Bytes) (LUI A3,$3FAA: $3C073FAA)

origin $00042A58
             // ROM       RAM         Widescreen (Streched)
lui a3,$3FE2 // $00042A58 $80041E58 - (4 Bytes) (LUI A3,$3FAA: $3C073FAA)

origin $00043BB0
             // ROM       RAM         Widescreen (Streched)
lui a3,$3FE2 // $00043BB0 $80042FB0 - (4 Bytes) (LUI A3,$3FA0: $3C073FA0)

origin $000976BC
             // ROM       RAM         Widescreen (Streched)
dw $40638E39 // $000976BC $80096ABC - (4 Bytes) ($402AAAAB)
dw $3FE38BAC // $000976C0 $80096AC0 - (4 Bytes) ($3FAAAAAB)
dw $40638E39 // $000976C4 $80096AC4 - (4 Bytes) ($402AAAAB)

origin $000976CC
             // ROM       RAM         Widescreen (Streched)
dw $3FE38BAC // $000976CC $80096ACC - (4 Bytes) ($3FAAAAAB)