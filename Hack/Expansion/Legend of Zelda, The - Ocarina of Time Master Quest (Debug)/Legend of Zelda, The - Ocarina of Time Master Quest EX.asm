// N64 "Legend of Zelda, The - Ocarina of Time Master Quest" Expansion Hack by krom (Peter Lemon):
// Special thanks to Airikitascave & ChriisTiian

arch n64.cpu
endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "Legend of Zelda, The - Ocarina of Time Master Quest EX.z64", create
origin $00000000; insert "Legend of Zelda, The - Ocarina of Time Master Quest (U) (Debug) [!].z64" // Include USA Legend of Zelda, The - Ocarina of Time Master Quest Debug N64 ROM
origin $00000020
db "THE LEGEND OF ZELDA EX     " // $00000020 - PROGRAM TITLE (27 Byte ASCII String, Use Spaces For Unused Bytes)

include "LIB/N64.INC" // Include N64 Definitions

origin $00002CF0
      // ROM       RAM         Remove printf Debug Function
jr ra // $00002CF0 $800020F0 - (4 Bytes) (ADDIU SP,-$0020: $27BDFFE0)
nop   // $00002CF4 $800020F4 - (4 Bytes) (SW A0,$0020(SP): $AFA40020)


origin $00005250
    // ROM       RAM         Remove osStartThread Exception Handler
nop // $00005250 $80004650 - (4 Bytes) (JAL $80007280: $0C001CA0)

origin $00005278
    // ROM       RAM         Remove osStartThread Exception Handler
nop // $00005278 $80004678 - (4 Bytes) (JAL $800072F0: $0C001CBC)


origin $00005DF8
                // ROM       RAM         Faster Boot Loading (For RAM) & RAM Expansion
lui at,$0080    // $00005DF8 $800051F8 - (4 Bytes) (LUI AT,$0080: $3C010080)
sw at,$0008(sp) // $00005DFC $800051FC - (4 Bytes) (SLTU AT,T6,AT: $01C1082B)
nop             // $00005E00 $80005200 - (4 Bytes) (BNEZ AT,$8000510C: $1420FFC2)


origin $00B36478
                  // ROM       RAM         Faster Subscreen Delay
addiu a1,r0,$0100 // $00B36478 $???????? - (4 Bytes) (ADDIU A1,R0,$0140: $24050140)

origin $00B36480
                  // ROM       RAM         Faster Subscreen Delay
addiu a2,r0,$00CA // $00B36480 $???????? - (4 Bytes) (ADDIU A2,R0,$00F0: $240600F0)

origin $00B36B68
                  // ROM       RAM         Faster Subscreen Delay
addiu t2,r0,$0003 // $00B36B68 $???????? - (4 Bytes) (ADDIU T2,R0,$0002: $240A0002)


origin $00ACEE2C
    // ROM       RAM         Faster Loading Area
nop // $00ACEE2C $???????? - (4 Bytes) (JAL $80106860: $0C041A18)

origin $00B74FE0
    // ROM       RAM         Faster Loading Area
nop // $00B74FE0 $???????? - (4 Bytes) (JAL $80106860: $0C041A18)

origin $00B75094
    // ROM       RAM         Faster Loading Area
nop // $00B75094 $???????? - (4 Bytes) (JAL $80106860: $0C041A18)


origin $00B33C5C
             // ROM       RAM         RAM Expansion
lui a1,$004D // $00B33C5C $???????? - (4 Bytes) (LUI A1,$001D: $3C05001D)

origin $00B415B0
             // ROM       RAM         RAM Expansion
lui t8,$8074 // $00B415B0 $???????? - (4 Bytes) (LUI T8,$8044: $3C188044)


origin $00B0EF9C
             // ROM       RAM         More RAM Space For Loaded Objects (For Scenes/Maps, Allow More Polygons)
lui s1,$0020 // $00B0EF9C $???????? - (4 Bytes) (LUI S1,$000F: $3C11000F)

origin $00B0EFBC
             // ROM       RAM         More RAM Space For Loaded Objects (For Scenes/Maps, Allow More Polygons)
lui s1,$0020 // $00B0EFBC $???????? - (4 Bytes) (LUI S1,$000F: $3C11000F)

origin $00B0EFE4
             // ROM       RAM         More RAM Space For Loaded Objects (For Scenes/Maps, Allow More Polygons)
lui s1,$0020 // $00B0EFE4 $???????? - (4 Bytes) (LUI S1,$0010: $3C110010)

origin $00B0F00C
             // ROM       RAM         More RAM Space For Loaded Objects (For Scenes/Maps, Allow More Polygons)
lui s1,$0020 // $00B0F00C $???????? - (4 Bytes) (LUI S1,$000F: $3C11000F)
lui s1,$0020 // $00B0F010 $???????? - (4 Bytes) (LUI S1,$0010: $3C110010)