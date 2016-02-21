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




origin $000E3230
             // ROM       RAM         Kart Friction
dd $45B54000 // $000E3230 $800E2630 - Mario  (4 Bytes) ($45B54000)
dd $45B54000 // $000E3234 $800E2634 - Luigi  (4 Bytes) ($45B54000)
dd $45B54000 // $000E3238 $800E2638 - Peach  (4 Bytes) ($45B54000)
dd $45B54000 // $000E323C $800E263C - Toad   (4 Bytes) ($45B54000)
dd $45B54000 // $000E3240 $800E2640 - Yoshi  (4 Bytes) ($45B54000)
dd $45B54000 // $000E3244 $800E2644 - D.K.   (4 Bytes) ($45B54000)
dd $45B54000 // $000E3248 $800E2648 - Wario  (4 Bytes) ($45B54000)
dd $45B54000 // $000E324C $800E264C - Bowser (4 Bytes) ($45B54000)

origin $000E3250
             // ROM       RAM         Kart Gravity
dd $45228000 // $000E3250 $800E2650 - Mario  (4 Bytes) ($45228000)
dd $45228000 // $000E3254 $800E2654 - Luigi  (4 Bytes) ($45228000)
dd $45228000 // $000E3258 $800E2658 - Peach  (4 Bytes) ($45228000)
dd $45228000 // $000E325C $800E265C - Toad   (4 Bytes) ($45228000)
dd $45228000 // $000E3260 $800E2660 - Yoshi  (4 Bytes) ($45228000)
dd $45228000 // $000E3264 $800E2664 - D.K.   (4 Bytes) ($45228000)
dd $45228000 // $000E3268 $800E2668 - Wario  (4 Bytes) ($45228000)
dd $45228000 // $000E326C $800E266C - Bowser (4 Bytes) ($45228000)

origin $000E3270
             // ROM       RAM         Kart *Unknown*
dd $3DF5C28F // $000E3270 $800E2670 - Mario  (4 Bytes) ($3DF5C28F)
dd $3DF5C28F // $000E3274 $800E2674 - Luigi  (4 Bytes) ($3DF5C28F)
dd $3DF5C28F // $000E3278 $800E2678 - Peach  (4 Bytes) ($3DF5C28F)
dd $3DF5C28F // $000E327C $800E267C - Toad   (4 Bytes) ($3DF5C28F)
dd $3DF5C28F // $000E3280 $800E2680 - Yoshi  (4 Bytes) ($3DF5C28F)
dd $3DF5C28F // $000E3284 $800E2684 - D.K.   (4 Bytes) ($3DF5C28F)
dd $3DF5C28F // $000E3288 $800E2688 - Wario  (4 Bytes) ($3DF5C28F)
dd $3DF5C28F // $000E328C $800E268C - Bowser (4 Bytes) ($3DF5C28F)

origin $000E3290
             // ROM       RAM         Kart Top Speed
dd $41100000 // $000E3290 $800E2690 - Mario  (4 Bytes) ($41100000)
dd $41100000 // $000E3294 $800E2694 - Luigi  (4 Bytes) ($41100000)
dd $41100000 // $000E3298 $800E2698 - Peach  (4 Bytes) ($41100000)
dd $41100000 // $000E329C $800E269C - Toad   (4 Bytes) ($41100000)
dd $41100000 // $000E32A0 $800E26A0 - Yoshi  (4 Bytes) ($41100000)
dd $41100000 // $000E32A4 $800E26A4 - D.K.   (4 Bytes) ($41100000)
dd $41100000 // $000E32A8 $800E26A8 - Wario  (4 Bytes) ($41100000)
dd $41100000 // $000E32AC $800E26AC - Bowser (4 Bytes) ($41100000)

origin $000E32B0
             // ROM       RAM         Bounding Box Size (Also Affects Camera Angle)
dd $40B00000 // $000E32B0 $800E26B0 - Mario  (4 Bytes) ($40B00000)
dd $40B00000 // $000E32B4 $800E26B4 - Luigi  (4 Bytes) ($40B00000)
dd $40B00000 // $000E32B8 $800E26B8 - Peach  (4 Bytes) ($40B00000)
dd $40B00000 // $000E32BC $800E26BC - Toad   (4 Bytes) ($40B00000)
dd $40B00000 // $000E32C0 $800E26C0 - Yoshi  (4 Bytes) ($40B00000)
dd $40C00000 // $000E32C4 $800E26C4 - D.K.   (4 Bytes) ($40C00000)
dd $40B00000 // $000E32C8 $800E26C8 - Wario  (4 Bytes) ($40B00000)
dd $40C00000 // $000E32CC $800E26CC - Bowser (4 Bytes) ($40C00000)




origin $000E4230
             // ROM       RAM         Kart Handling (Turn Angle)
dd $3FA00000 // $000E4230 $800E3630 - Mario  (4 Bytes) ($3FA00000)
dd $3FA00000 // $000E4234 $800E3634 - Luigi  (4 Bytes) ($3FA00000)
dd $3FA3D70A // $000E4238 $800E3638 - Peach  (4 Bytes) ($3FA3D70A)
dd $3FA3D70A // $000E423C $800E363C - Toad   (4 Bytes) ($3FA3D70A)
dd $3F933333 // $000E4240 $800E3640 - Yoshi  (4 Bytes) ($3F933333)
dd $3F933333 // $000E4244 $800E3644 - D.K.   (4 Bytes) ($3F933333)
dd $3FA3D70A // $000E4248 $800E3648 - Wario  (4 Bytes) ($3FA3D70A)
dd $3F933333 // $000E424C $800E364C - Bowser (4 Bytes) ($3F933333)

origin $000E4250
             // ROM       RAM         Kart *Unknown*
dd $00000000 // $000E4250 $800E3650 - Mario  (4 Bytes) ($00000000)
dd $00000000 // $000E4254 $800E3654 - Luigi  (4 Bytes) ($00000000)
dd $00000000 // $000E4258 $800E3658 - Peach  (4 Bytes) ($00000000)
dd $00000000 // $000E425C $800E365C - Toad   (4 Bytes) ($00000000)
dd $00000000 // $000E4260 $800E3660 - Yoshi  (4 Bytes) ($00000000)
dd $00000000 // $000E4264 $800E3664 - D.K.   (4 Bytes) ($00000000)
dd $00000000 // $000E4268 $800E3668 - Wario  (4 Bytes) ($00000000)
dd $00000000 // $000E426C $800E366C - Bowser (4 Bytes) ($00000000)

origin $000E4270
             // ROM       RAM         Kart Turn Speed Reduction Coefficient
dd $00000000 // $000E4270 $800E3670 - Mario  (4 Bytes) ($00000000)
dd $00000000 // $000E4274 $800E3674 - Luigi  (4 Bytes) ($00000000)
dd $3B03126F // $000E4278 $800E3678 - Peach  (4 Bytes) ($3B03126F)
dd $3B03126F // $000E427C $800E367C - Toad   (4 Bytes) ($3B03126F)
dd $BB03126F // $000E4280 $800E3680 - Yoshi  (4 Bytes) ($BB03126F)
dd $BB03126F // $000E4284 $800E3684 - D.K.   (4 Bytes) ($BB03126F)
dd $3B03126F // $000E4288 $800E3688 - Wario  (4 Bytes) ($3B03126F)
dd $BB03126F // $000E428C $800E368C - Bowser (4 Bytes) ($BB03126F)

origin $000E4290
             // ROM       RAM         Kart Turn Speed Reduction Coefficient 2
dd $00000000 // $000E4290 $800E3690 - Mario  (4 Bytes) ($00000000)
dd $00000000 // $000E4294 $800E3694 - Luigi  (4 Bytes) ($00000000)
dd $3B03126F // $000E4298 $800E3698 - Peach  (4 Bytes) ($3B03126F)
dd $3B03126F // $000E429C $800E369C - Toad   (4 Bytes) ($3B03126F)
dd $BB03126F // $000E42A0 $800E36A0 - Yoshi  (4 Bytes) ($BB03126F)
dd $BB03126F // $000E42A4 $800E36A4 - D.K.   (4 Bytes) ($BB03126F)
dd $3B03126F // $000E42A8 $800E36A8 - Wario  (4 Bytes) ($3B03126F)
dd $BB03126F // $000E42AC $800E36AC - Bowser (4 Bytes) ($BB03126F)

origin $000E42B0
             // ROM       RAM         Kart *Unknown*
dd $40000000 // $000E42B0 $800E36B0 - Mario  (4 Bytes) ($40000000)
dd $40000000 // $000E42B4 $800E36B4 - Luigi  (4 Bytes) ($40000000)
dd $40400000 // $000E42B8 $800E36B8 - Peach  (4 Bytes) ($40400000)
dd $40400000 // $000E42BC $800E36BC - Toad   (4 Bytes) ($40400000)
dd $3FC00000 // $000E42C0 $800E36C0 - Yoshi  (4 Bytes) ($3FC00000)
dd $3FC00000 // $000E42C4 $800E36C4 - D.K.   (4 Bytes) ($3FC00000)
dd $40400000 // $000E42C8 $800E36C8 - Wario  (4 Bytes) ($40400000)
dd $40400000 // $000E42CC $800E36CC - Bowser (4 Bytes) ($40400000)

origin $000E42D0
             // ROM       RAM         Kart Hop Height
dd $3F6E147B // $000E42D0 $800E36D0 - Mario  (4 Bytes) ($3F6E147B)
dd $3F6E147B // $000E42D4 $800E36D4 - Luigi  (4 Bytes) ($3F6E147B)
dd $3F6E147B // $000E42D8 $800E36D8 - Peach  (4 Bytes) ($3F6E147B)
dd $3F6E147B // $000E42DC $800E36DC - Toad   (4 Bytes) ($3F6E147B)
dd $3F6E147B // $000E42E0 $800E36E0 - Yoshi  (4 Bytes) ($3F6E147B)
dd $3F6E147B // $000E42E4 $800E36E4 - D.K.   (4 Bytes) ($3F6E147B)
dd $3F6E147B // $000E42E8 $800E36E8 - Wario  (4 Bytes) ($3F6E147B)
dd $3F6E147B // $000E42EC $800E36EC - Bowser (4 Bytes) ($3F6E147B)

origin $000E42F0
             // ROM       RAM         Kart Hop Fall Speed
dd $3CF5C28F // $000E42F0 $800E36F0 - Mario  (4 Bytes) ($3CF5C28F)
dd $3CF5C28F // $000E42F4 $800E36F4 - Luigi  (4 Bytes) ($3CF5C28F)
dd $3CF5C28F // $000E42F8 $800E36F8 - Peach  (4 Bytes) ($3CF5C28F)
dd $3CF5C28F // $000E42FC $800E36FC - Toad   (4 Bytes) ($3CF5C28F)
dd $3CF5C28F // $000E4300 $800E3700 - Yoshi  (4 Bytes) ($3CF5C28F)
dd $3CF5C28F // $000E4304 $800E3704 - D.K.   (4 Bytes) ($3CF5C28F)
dd $3CF5C28F // $000E4308 $800E3708 - Wario  (4 Bytes) ($3CF5C28F)
dd $3CF5C28F // $000E430C $800E370C - Bowser (4 Bytes) ($3CF5C28F)

origin $000E4310
             // ROM       RAM         Kart *Unknown*
dd $400CCCCD // $000E4310 $800E3710 - Mario  (4 Bytes) ($400CCCCD)
dd $400CCCCD // $000E4314 $800E3714 - Luigi  (4 Bytes) ($400CCCCD)
dd $400CCCCD // $000E4318 $800E3718 - Peach  (4 Bytes) ($400CCCCD)
dd $400CCCCD // $000E431C $800E371C - Toad   (4 Bytes) ($400CCCCD)
dd $400CCCCD // $000E4320 $800E3720 - Yoshi  (4 Bytes) ($400CCCCD)
dd $400CCCCD // $000E4324 $800E3724 - D.K.   (4 Bytes) ($400CCCCD)
dd $400CCCCD // $000E4328 $800E3728 - Wario  (4 Bytes) ($400CCCCD)
dd $400CCCCD // $000E432C $800E372C - Bowser (4 Bytes) ($400CCCCD)

origin $000E4330
             // ROM       RAM         Kart *Unknown*
dd $3B03126F // $000E4330 $800E3730 - Mario  (4 Bytes) ($3B03126F)
dd $3B03126F // $000E4334 $800E3734 - Luigi  (4 Bytes) ($3B03126F)
dd $3B03126F // $000E4338 $800E3738 - Peach  (4 Bytes) ($3B03126F)
dd $3B03126F // $000E433C $800E373C - Toad   (4 Bytes) ($3B03126F)
dd $3B03126F // $000E4340 $800E3740 - Yoshi  (4 Bytes) ($3B03126F)
dd $3B03126F // $000E4344 $800E3744 - D.K.   (4 Bytes) ($3B03126F)
dd $3B03126F // $000E4348 $800E3748 - Wario  (4 Bytes) ($3B03126F)
dd $3B03126F // $000E434C $800E374C - Bowser (4 Bytes) ($3B03126F)

origin $000E4350
             // ROM       RAM         Kart *Unknown*
dd $40000000 // $000E4350 $800E3750 - Mario  (4 Bytes) ($40000000)
dd $40000000 // $000E4354 $800E3754 - Luigi  (4 Bytes) ($40000000)
dd $40000000 // $000E4358 $800E3758 - Peach  (4 Bytes) ($40000000)
dd $40000000 // $000E435C $800E375C - Toad   (4 Bytes) ($40000000)
dd $40000000 // $000E4360 $800E3760 - Yoshi  (4 Bytes) ($40000000)
dd $40000000 // $000E4364 $800E3764 - D.K.   (4 Bytes) ($40000000)
dd $40000000 // $000E4368 $800E3768 - Wario  (4 Bytes) ($40000000)
dd $40000000 // $000E436C $800E376C - Bowser (4 Bytes) ($40000000)

origin $000E4370
             // ROM       RAM         Kart *Unknown*
dd $3B03126F // $000E4370 $800E3770 - Mario  (4 Bytes) ($3B03126F)
dd $3B03126F // $000E4374 $800E3774 - Luigi  (4 Bytes) ($3B03126F)
dd $3B03126F // $000E4378 $800E3778 - Peach  (4 Bytes) ($3B03126F)
dd $3B03126F // $000E437C $800E377C - Toad   (4 Bytes) ($3B03126F)
dd $3B03126F // $000E4380 $800E3780 - Yoshi  (4 Bytes) ($3B03126F)
dd $3B03126F // $000E4384 $800E3784 - D.K.   (4 Bytes) ($3B03126F)
dd $3B03126F // $000E4388 $800E3788 - Wario  (4 Bytes) ($3B03126F)
dd $3B03126F // $000E438C $800E378C - Bowser (4 Bytes) ($3B03126F)

origin $000E4390
             // ROM       RAM         Kart *Unknown*
dd $3F99999A // $000E4390 $800E3790 - Mario  (4 Bytes) ($3F99999A)
dd $3FB9999A // $000E4394 $800E3794 - Luigi  (4 Bytes) ($3FB9999A)
dd $3FB9999A // $000E4398 $800E3798 - Peach  (4 Bytes) ($3FB9999A)
dd $3FB9999A // $000E439C $800E379C - Toad   (4 Bytes) ($3FB9999A)
dd $3FB9999A // $000E43A0 $800E37A0 - Yoshi  (4 Bytes) ($3FB9999A)
dd $3FB9999A // $000E43A4 $800E37A4 - D.K.   (4 Bytes) ($3FB9999A)
dd $3FB9999A // $000E43A8 $800E37A8 - Wario  (4 Bytes) ($3FB9999A)
dd $3FB9999A // $000E43AC $800E37AC - Bowser (4 Bytes) ($3FB9999A)

origin $000E43B0
             // ROM       RAM         Kart *Unknown*
dd $3C23D70A // $000E43B0 $800E37B0 - Mario  (4 Bytes) ($3C23D70A)
dd $3C23D70A // $000E43B4 $800E37B4 - Luigi  (4 Bytes) ($3C23D70A)
dd $3C23D70A // $000E43B8 $800E37B8 - Peach  (4 Bytes) ($3C23D70A)
dd $3C23D70A // $000E43BC $800E37BC - Toad   (4 Bytes) ($3C23D70A)
dd $3C23D70A // $000E43C0 $800E37C0 - Yoshi  (4 Bytes) ($3C23D70A)
dd $3C23D70A // $000E43C4 $800E37C4 - D.K.   (4 Bytes) ($3C23D70A)
dd $3C23D70A // $000E43C8 $800E37C8 - Wario  (4 Bytes) ($3C23D70A)
dd $3C23D70A // $000E43CC $800E37CC - Bowser (4 Bytes) ($3C23D70A)

origin $000E43D0
             // ROM       RAM         Kart *Unknown*
dd $40600000 // $000E43D0 $800E37D0 - Mario  (4 Bytes) ($40600000)
dd $40600000 // $000E43D4 $800E37D4 - Luigi  (4 Bytes) ($40600000)
dd $40600000 // $000E43D8 $800E37D8 - Peach  (4 Bytes) ($40600000)
dd $40600000 // $000E43DC $800E37DC - Toad   (4 Bytes) ($40600000)
dd $40600000 // $000E43E0 $800E37E0 - Yoshi  (4 Bytes) ($40600000)
dd $40600000 // $000E43E4 $800E37E4 - D.K.   (4 Bytes) ($40600000)
dd $40600000 // $000E43E8 $800E37E8 - Wario  (4 Bytes) ($40600000)
dd $40600000 // $000E43EC $800E37EC - Bowser (4 Bytes) ($40600000)

origin $000E43F0
             // ROM       RAM         Kart *Unknown*
dd $3B03126F // $000E43F0 $800E37F0 - Mario  (4 Bytes) ($3B03126F)
dd $3B03126F // $000E43F4 $800E37F4 - Luigi  (4 Bytes) ($3B03126F)
dd $3B03126F // $000E43F8 $800E37F8 - Peach  (4 Bytes) ($3B03126F)
dd $3B03126F // $000E43FC $800E37FC - Toad   (4 Bytes) ($3B03126F)
dd $3B03126F // $000E4400 $800E3800 - Yoshi  (4 Bytes) ($3B03126F)
dd $3B03126F // $000E4404 $800E3804 - D.K.   (4 Bytes) ($3B03126F)
dd $3B03126F // $000E4408 $800E3808 - Wario  (4 Bytes) ($3B03126F)
dd $3B03126F // $000E440C $800E380C - Bowser (4 Bytes) ($3B03126F)