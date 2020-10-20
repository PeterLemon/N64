// N64 "F-ZERO X" HD Hack by krom (Peter Lemon):
// Special thanks to theboy181 & gamemasterplc

arch n64.cpu
endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "F-ZERO X HD.z64", create
origin $00000000; insert "F-ZERO X (U) [!].z64" // Include USA F-ZERO X N64 ROM
origin $00000020
db "F-ZERO X HD                " // $00000020 - PROGRAM TITLE (27 Byte ASCII String, Use Spaces For Unused Bytes)

include "LIB/N64.INC" // Include N64 Definitions

origin $0003107C
            // ROM       RAM         Force Hi Poly Models
float32 0.0 // $0003107C $8009707C - (IEEE32) (2080.001: $45020004)

origin $00031084
                  // ROM       RAM         Hi Poly All Modes (Replay Extended Effects)
nop               // $00031084 $80097084 - (4 Bytes) ($00000000)
b $000310FC       // $00031088 $80097088 - (4 Bytes) (B $800970FC)
nop               // $0003108C $8009708C - (4 Bytes) ($00000000)
nop               // $00031090 $80097090 - (4 Bytes) ($00000000)
nop               // $00031094 $80097094 - (4 Bytes) ($00000000)
nop               // $00031098 $80097098 - (4 Bytes) ($00000000)
nop               // $0003109C $8009709C - (4 Bytes) ($00000000)
nop               // $000310A0 $800970A0 - (4 Bytes) ($00000000)
nop               // $000310A4 $800970A4 - (4 Bytes) ($00000000)
nop               // $000310A8 $800970A8 - (4 Bytes) ($00000000)
lui s6,$8014      // $000310AC $800970AC - (4 Bytes) (LUI S6,$8014)
lw s6,$F008(s6)   // $000310B0 $800970B0 - (4 Bytes) (LW S6,$F008(S6))
slti at,s6,$0004  // $000310B4 $800970B4 - (4 Bytes) (SLTI AT,S6,$0004)
bnez at,$00030F08 // $000310B8 $800970B8 - (4 Bytes) (BNEZ AT,$80096F08)
nop               // $000310BC $800970BC - (4 Bytes) ($00000000)
b $00031168       // $000310C0 $800970C0 - (4 Bytes) (B $80097168)
nop               // $000310C4 $800970C4 - (4 Bytes) ($00000000)
nop               // $000310C8 $800970C8 - (4 Bytes) ($00000000)
nop               // $000310CC $800970CC - (4 Bytes) ($00000000)
nop               // $000310D0 $800970D0 - (4 Bytes) ($00000000)
nop               // $000310D4 $800970D4 - (4 Bytes) ($00000000)
nop               // $000310D8 $800970D8 - (4 Bytes) ($00000000)
nop               // $000310DC $800970DC - (4 Bytes) ($00000000)
nop               // $000310E0 $800970E0 - (4 Bytes) ($00000000)
nop               // $000310E4 $800970E4 - (4 Bytes) ($00000000)
nop               // $000310E8 $800970E8 - (4 Bytes) ($00000000)
nop               // $000310EC $800970EC - (4 Bytes) ($00000000)
nop               // $000310F0 $800970F0 - (4 Bytes) ($00000000)
nop               // $000310F4 $800970F4 - (4 Bytes) ($00000000)
nop               // $000310F8 $800970F8 - (4 Bytes) ($00000000)
nop               // $000310FC $800970FC - (4 Bytes) ($00000000)
addiu t8,r0,$0001 // $00031100 $80097100 - (4 Bytes) (ADDIU T8,R0,$0001)

origin $0003115C
                   // ROM       RAM         Hi Poly All Modes (Replay Extended Effects)
beqzl at,$000310AC // $0003115C $8009715C - (4 Bytes) (BEQZL AT,$800970AC)

origin $000311D0
    // ROM       RAM         Hi Poly All Modes (Replay Extended Effects)
nop // $000311D0 $800971D0 - (4 Bytes) ($00000000)

////////////////////////////////////////////////////////////////////////////////////////////////////////

origin $0001D4D0
             // ROM       RAM         Remove Black Bars
dw $3C0AED00 // $0001D4D0 $800834D0 - (4 Bytes) ($3C0AED03)
dw $3C0B0050 // $0001D4D4 $800834D4 - (4 Bytes) ($3C0B004D)
dw $356B03B8 // $0001D4D8 $800834D8 - (4 Bytes) ($356B0380)
dw $354A0007 // $0001D4DC $800834DC - (4 Bytes) ($354A0040)

origin $0009B2F4
             // ROM       RAM         Remove Black Bars
dw $3C0F0000 // $0009B2F4 $800FF9A4 - (4 Bytes) ($3C0F0003)
dw $3C0CF650 // $0009B2F8 $800FF9A8 - (4 Bytes) ($3C0CF64D)

origin $0009B304
             // ROM       RAM         Fade Fix
dw $35EF03C0 // $0009B304 $800FF9B4 - (4 Bytes) ($35EF0020)
dw $ACEF0000 // $0009B308 $800FF9B8 - (4 Bytes) ($ACEF0004)

////////////////////////////////////////////////////////////////////////////////////////////////////////

origin $001B5B9C
             // ROM       RAM         Fade Fix
dw $00000000 // $001B5B9C $80387AFC - (4 Bytes) ($00030040)

origin $0017B374
             // ROM       RAM         Fade Fix
dw $00000000 // $0017B374 $80387A14 - (4 Bytes) ($00030020)

origin $001B5AB4
             // ROM       RAM         Fade Fix
dw $00000000 // $001B5AB4 $80387A14 - (4 Bytes) ($00030020)

////////////////////////////////////////////////////////////////////////////////////////////////////////

origin $000679C0
             // ROM       RAM         Scissor Table Fix
dw $00000000 // $000679C0 $800CD9C0 - (4 Bytes) ($0000000C)
dw $00000000 // $000679C4 $800CD9C4 - (4 Bytes) ($00000008)
dw $00000140 // $000679C8 $800CD9C8 - (4 Bytes) ($00000134)
dw $000000F0 // $000679CC $800CD9CC - (4 Bytes) ($000000E8)
dw $00000001 // $000679D0 $800CD9D0 - (4 Bytes) ($0000000C)
dw $00000005 // $000679D4 $800CD9D4 - (4 Bytes) ($00000008)
dw $0000013F // $000679D8 $800CD9D8 - (4 Bytes) ($00000133)
dw $00000077 // $000679DC $800CD9DC - (4 Bytes) ($00000077)
dw $00000001 // $000679E0 $800CD9E0 - (4 Bytes) ($0000000C)
dw $00000078 // $000679E4 $800CD9E4 - (4 Bytes) ($00000078)
dw $0000013F // $000679E8 $800CD9E8 - (4 Bytes) ($00000133)
dw $000000F0 // $000679EC $800CD9EC - (4 Bytes) ($000000E7)
dw $0000000C // $000679F0 $800CD9F0 - (4 Bytes) ($0000000C)
dw $00000008 // $000679F4 $800CD9F4 - (4 Bytes) ($00000008)
dw $0000009F // $000679F8 $800CD9F8 - (4 Bytes) ($0000009F)
dw $000000E7 // $000679FC $800CD9FC - (4 Bytes) ($000000E7)
dw $000000A0 // $00067A00 $800CDA00 - (4 Bytes) ($000000A0)
dw $00000008 // $00067A04 $800CDA04 - (4 Bytes) ($00000008)
dw $00000133 // $00067A08 $800CDA08 - (4 Bytes) ($00000133)
dw $000000E7 // $00067A0C $800CDA0C - (4 Bytes) ($000000E7)
dw $00000006 // $00067A10 $800CDA10 - (4 Bytes) ($0000000C)
dw $00000004 // $00067A14 $800CDA14 - (4 Bytes) ($00000008)
dw $0000009F // $00067A18 $800CDA18 - (4 Bytes) ($0000009F)
dw $00000077 // $00067A1C $800CDA1C - (4 Bytes) ($00000077)
dw $000000A0 // $00067A20 $800CDA20 - (4 Bytes) ($000000A0)
dw $00000004 // $00067A24 $800CDA24 - (4 Bytes) ($00000008)
dw $0000013A // $00067A28 $800CDA28 - (4 Bytes) ($00000133)
dw $00000077 // $00067A2C $800CDA2C - (4 Bytes) ($00000077)
dw $00000006 // $00067A30 $800CDA30 - (4 Bytes) ($0000000C)
dw $00000078 // $00067A34 $800CDA34 - (4 Bytes) ($00000078)
dw $0000009F // $00067A38 $800CDA38 - (4 Bytes) ($0000009F)
dw $000000EC // $00067A3C $800CDA3C - (4 Bytes) ($000000E7)
dw $000000A0 // $00067A40 $800CDA40 - (4 Bytes) ($000000A0)
dw $00000078 // $00067A44 $800CDA44 - (4 Bytes) ($00000078)
dw $0000013A // $00067A48 $800CDA48 - (4 Bytes) ($00000133)
dw $000000EC // $00067A4C $800CDA4C - (4 Bytes) ($000000E7)

////////////////////////////////////////////////////////////////////////////////////////////////////////

origin $00069508
             // ROM       RAM         Better Level Fog (Fits With Better Draw Distance)
dw $000003E4 // $00069508 $800CF50B - (4 Bytes) ($000003DE)

////////////////////////////////////////////////////////////////////////////////////////////////////////

origin $00007164
             // ROM       RAM         Wide Screen (Streched) gamemasterplc
dw $0803522C // $00007164 $8006D164 - (4 Bytes) ($00000000)

origin $0006E8B0
             // ROM       RAM         Wide Screen (Streched) gamemasterplc
dw $3C1B3F40 // $0006E8B0 $800D46D8 - (4 Bytes) ($496E7465)
dw $449B9000 // $0006E8B4 $800D46DC - (4 Bytes) ($72727570)
dw $00000000 // $0006E8B8 $800D46E0 - (4 Bytes) ($74000000)
dw $0801B45B // $0006E8BC $800D46E4 - (4 Bytes) ($544C4220)
dw $46123182 // $0006E8C0 $800D46E8 - (4 Bytes) ($6D6F6469)

origin $000D4B70
                  // ROM       RAM         Wide Screen (Streched) gamemasterplc
float32 1.5984375 // $000D4B70 $801418A0 - (IEEE32) (1.2: $3F99999A)

////////////////////////////////////////////////////////////////////////////////////////////////////////

origin $0006F9A8
                // ROM       RAM         Improved Ship Draw Distance
float32 10000.0 // $0006F9A8 $800D59A8 - (IEEE32) (2500.0: $451C4000)

origin $0006951C
               // ROM       RAM         Improved Draw Distance Z-Culling (Depth)
float32 1000.0 // $0006951C $810CF51C - (IEEE32) (400.0: $43C80000)

origin $0003EFF4
                  // ROM       RAM         Improved Draw Distance				  
add.s f16,f10,f10 // $0003EFF4 $???????? - (4 Bytes) ($460A0400)

origin $0003ED4C
             // ROM       RAM         Improved Draw Distance LOD Precision 1
dw $3C014680 // $0003ED4C $???????? - (4 Bytes) ($3C0144FA)

origin $0003ED5C
             // ROM       RAM         Improved Draw Distance LOD Precision 2
dw $3C014680 // $0003ED5C $???????? - (4 Bytes) ($3C014396)