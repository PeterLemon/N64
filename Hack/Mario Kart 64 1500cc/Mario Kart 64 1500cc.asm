// N64 "Mario Kart 64" 1500cc Hack by krom (Peter Lemon):

endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "Mario Kart 64 1500cc.z64", create
origin $0000000; insert "Mario Kart 64 (U) [!].z64" // Include USA Mario Kart 64 N64 ROM

origin $00000020
db "MARIOKART641500CC          " // $00000020 - PROGRAM TITLE (27 Byte ASCII String, Use Spaces For Unused Bytes)

//-----------------
// Kart Properties
//-----------------
origin $000E317C
             // ROM       RAM         50cc Kart Speed
dd $43F10000 // $000E317C $800E257C - Mario  (4 Bytes) ($43910000)
dd $43F10000 // $000E3180 $800E2580 - Luigi  (4 Bytes) ($43910000)
dd $43F30000 // $000E3184 $800E2584 - Peach  (4 Bytes) ($43930000)
dd $43F30000 // $000E3188 $800E2588 - Toad   (4 Bytes) ($43930000)
dd $43F10000 // $000E318C $800E258C - Yoshi  (4 Bytes) ($43910000)
dd $43F10000 // $000E3190 $800E2590 - D.K.   (4 Bytes) ($43910000)
dd $43F30000 // $000E3194 $800E2594 - Wario  (4 Bytes) ($43930000)
dd $43F10000 // $000E3198 $800E2598 - Bowser (4 Bytes) ($43910000)

origin $000E319C
             // ROM       RAM         100cc / Time Trial Kart Speed
dd $43FB0000 // $000E319C $800E259C - Mario  (4 Bytes) ($439B0000)
dd $43FB0000 // $000E31A0 $800E25A0 - Luigi  (4 Bytes) ($439B0000)
dd $43FD0000 // $000E31A4 $800E25A4 - Peach  (4 Bytes) ($439D0000)
dd $43FD0000 // $000E31A8 $800E25A8 - Toad   (4 Bytes) ($439D0000)
dd $43FB0000 // $000E31AC $800E25AC - Yoshi  (4 Bytes) ($439B0000)
dd $43FB0000 // $000E31B0 $800E25B0 - D.K.   (4 Bytes) ($439B0000)
dd $43FD0000 // $000E31B4 $800E25B4 - Wario  (4 Bytes) ($439D0000)
dd $43FB0000 // $000E31B8 $800E25B8 - Bowser (4 Bytes) ($439B0000)

origin $000E31BC
             // ROM       RAM         150cc Kart Speed
dd $43FD0000 // $000E31BC $800E25BC - Mario  (4 Bytes) ($43A00000)
dd $43FD0000 // $000E31C0 $800E25C0 - Luigi  (4 Bytes) ($43A00000)
dd $43FF0000 // $000E31C4 $800E25C4 - Peach  (4 Bytes) ($43A20000)
dd $43FF0000 // $000E31C8 $800E25C8 - Toad   (4 Bytes) ($43A20000)
dd $43FD0000 // $000E31CC $800E25CC - Yoshi  (4 Bytes) ($43A00000)
dd $43FD0000 // $000E31D0 $800E25D0 - D.K.   (4 Bytes) ($43A00000)
dd $43FF0000 // $000E31D4 $800E25D4 - Wario  (4 Bytes) ($43A20000)
dd $43FD0000 // $000E31D8 $800E25D8 - Bowser (4 Bytes) ($43A00000)

origin $000E31DC
             // ROM       RAM         Extra Kart Speed
dd $43FB0000 // $000E31DC $800E25DC - Mario  (4 Bytes) ($439B0000)
dd $43FB0000 // $000E31E0 $800E25E0 - Luigi  (4 Bytes) ($439B0000)
dd $43FD0000 // $000E31E4 $800E25E4 - Peach  (4 Bytes) ($439D0000)
dd $43FD0000 // $000E31E8 $800E25E8 - Toad   (4 Bytes) ($439D0000)
dd $43FB0000 // $000E31EC $800E25EC - Yoshi  (4 Bytes) ($439B0000)
dd $43FB0000 // $000E31F0 $800E25F0 - D.K.   (4 Bytes) ($439B0000)
dd $43FD0000 // $000E31F4 $800E25F4 - Wario  (4 Bytes) ($439D0000)
dd $43FB0000 // $000E31F8 $800E25F8 - Bowser (4 Bytes) ($439B0000)

origin $000E31FC
             // ROM       RAM         Battle Kart Speed
dd $43F50000 // $000E31FC $800E25FC - Mario  (4 Bytes) ($43750000)
dd $43F50000 // $000E3200 $800E2600 - Luigi  (4 Bytes) ($43750000)
dd $43F50000 // $000E3204 $800E2604 - Peach  (4 Bytes) ($43750000)
dd $43F50000 // $000E3208 $800E2608 - Toad   (4 Bytes) ($43750000)
dd $43F50000 // $000E320C $800E260C - Yoshi  (4 Bytes) ($43750000)
dd $43F50000 // $000E3210 $800E2610 - D.K.   (4 Bytes) ($43750000)
dd $43F50000 // $000E3214 $800E2614 - Wario  (4 Bytes) ($43750000)
dd $43F50000 // $000E3218 $800E2618 - Bowser (4 Bytes) ($43750000)