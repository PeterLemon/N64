// N64 "1080 Snowboarding" High Definition Hack by krom (Peter Lemon):
// Special thanks to theboy181

arch n64.cpu
endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "1080 Snowboarding HD.z64", create
origin $00000000; insert "1080 Snowboarding (JU) (M2) [!].z64" // Include USA/JPN 1080 Snowboarding N64 ROM
origin $00000020
db "1080 SNOWBOARDING HD       " // $00000020 - PROGRAM TITLE (27 Byte ASCII String, Use Spaces For Unused Bytes)

include "LIB/N64.INC" // Include N64 Definitions

origin $00DD7114
              // ROM       RAM         Increased Draw Distance (DD) & Level of Detail (LOD)
mfc1 t4,f10   // $00DD7114 $8009C4F8 - (4 Bytes) (MFC1 T4,F8: $440C4000)
subu v1,v0,v0 // $00DD7118 $8009C4FC - (4 Bytes) (SUBU V1,V0: $00621823)

origin $00DDDBB8
    // ROM       RAM         Increased Draw Distance (DD) & Level of Detail (LOD)
nop // $00DDDBB8 $800A2F9C - (4 Bytes) (BNEZ T6,$800A3244: $15C000A9)

origin $00E33CA8
             // ROM       RAM         Increased Draw Distance (DD) & Level of Detail (LOD)
lui at,$43FF // $00E33CA8 $800F908C - (4 Bytes) (LUI AT,$42AA: $3C0142AA)

origin $00E44674
                 // ROM       RAM         Increased Draw Distance (DD) & Level of Detail (LOD)
lui at,$3F00     // $00E44674 $80109A58 - (4 Bytes) (LUI AT,$4000: $3C014000)
add.s f4,f16,f18 // $00E44678 $80109A5C - (4 Bytes) (ADD.S F4,F16,F14: $460E8100)