// N64 "Mario Kart 64" 1500cc Hack by krom (Peter Lemon):

endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "Mario Kart 64 1500cc.z64", create
origin $0000000; insert "Mario Kart 64 (U) [!].z64" // Include USA Mario Kart 64 N64 ROM

origin $00000020
db "MARIOKART641500CC          " // $00000020 - PROGRAM TITLE (27 Byte ASCII String, Use Spaces For Unused Bytes)

//-----------------
// Kart Properties
//-----------------
origin $000E2F40
             // ROM       RAM         Kart *Unknown*
dd $0F12D430 // $000E2F40 $800E2340 - Mario  (4 Bytes) ($0F12D430)
dd $0F09ABFC // $000E2F44 $800E2344 - Luigi  (4 Bytes) ($0F09ABFC)
dd $0F1C4958 // $000E2F48 $800E2348 - Peach  (4 Bytes) ($0F1C4958)
dd $0F386858 // $000E2F4C $800E234C - Toad   (4 Bytes) ($0F386858)
dd $0F438874 // $000E2F50 $800E2350 - Yoshi  (4 Bytes) ($0F438874)
dd $0F2F5DEC // $000E2F54 $800E2354 - D.K.   (4 Bytes) ($0F2F5DEC)
dd $0F258AC8 // $000E2F58 $800E2358 - Wario  (4 Bytes) ($0F258AC8)
dd $0F4F8C88 // $000E2F5C $800E235C - Bowser (4 Bytes) ($0F4F8C88)

origin $000E2F60
             // ROM       RAM         Kart *Unknown*
dd $C1200000 // $000E2F60 $800E2360 - Mario  (4 Bytes) ($C1200000)
dd $C1200000 // $000E2F64 $800E2364 - Luigi  (4 Bytes) ($C1200000)
dd $C1200000 // $000E2F68 $800E2368 - Peach  (4 Bytes) ($C1200000)
dd $C1200000 // $000E2F6C $800E236C - Toad   (4 Bytes) ($C1200000)
dd $C1200000 // $000E2F70 $800E2370 - Yoshi  (4 Bytes) ($C1200000)
dd $C1200000 // $000E2F74 $800E2374 - D.K.   (4 Bytes) ($C1200000)
dd $C1200000 // $000E2F78 $800E2378 - Wario  (4 Bytes) ($C1200000)
dd $C1200000 // $000E2F7C $800E237C - Bowser (4 Bytes) ($C1200000)

origin $000E2F80
             // ROM       RAM         Kart *Unknown*
dd $C1700000 // $000E2F80 $800E2380 - Mario  (4 Bytes) ($C1700000)
dd $C1700000 // $000E2F84 $800E2384 - Luigi  (4 Bytes) ($C1700000)
dd $C1700000 // $000E2F88 $800E2388 - Peach  (4 Bytes) ($C1700000)
dd $C1700000 // $000E2F8C $800E238C - Toad   (4 Bytes) ($C1700000)
dd $C1700000 // $000E2F90 $800E2390 - Yoshi  (4 Bytes) ($C1700000)
dd $C1700000 // $000E2F94 $800E2394 - D.K.   (4 Bytes) ($C1700000)
dd $C1700000 // $000E2F98 $800E2398 - Wario  (4 Bytes) ($C1700000)
dd $C1700000 // $000E2F9C $800E239C - Bowser (4 Bytes) ($C1700000)

origin $000E2FA0
             // ROM       RAM         Kart *Unknown*
dd $C1A00000 // $000E2FA0 $800E23A0 - Mario  (4 Bytes) ($C1A00000)
dd $C1A00000 // $000E2FA4 $800E23A4 - Luigi  (4 Bytes) ($C1A00000)
dd $C1A00000 // $000E2FA8 $800E23A8 - Peach  (4 Bytes) ($C1A00000)
dd $C1A00000 // $000E2FAC $800E23AC - Toad   (4 Bytes) ($C1A00000)
dd $C1A00000 // $000E2FB0 $800E23B0 - Yoshi  (4 Bytes) ($C1A00000)
dd $C1A00000 // $000E2FB4 $800E23B4 - D.K.   (4 Bytes) ($C1A00000)
dd $C1A00000 // $000E2FB8 $800E23B8 - Wario  (4 Bytes) ($C1A00000)
dd $C1A00000 // $000E2FBC $800E23BC - Bowser (4 Bytes) ($C1A00000)

origin $000E2FC0
             // ROM       RAM         Kart *Unknown*
dd $C1700000 // $000E2FC0 $800E23C0 - Mario  (4 Bytes) ($C1700000)
dd $C1700000 // $000E2FC4 $800E23C4 - Luigi  (4 Bytes) ($C1700000)
dd $C1700000 // $000E2FC8 $800E23C8 - Peach  (4 Bytes) ($C1700000)
dd $C1700000 // $000E2FCC $800E23CC - Toad   (4 Bytes) ($C1700000)
dd $C1700000 // $000E2FD0 $800E23D0 - Yoshi  (4 Bytes) ($C1700000)
dd $C1700000 // $000E2FD4 $800E23D4 - D.K.   (4 Bytes) ($C1700000)
dd $C1700000 // $000E2FD8 $800E23D8 - Wario  (4 Bytes) ($C1700000)
dd $C1700000 // $000E2FDC $800E23DC - Bowser (4 Bytes) ($C1700000)

origin $000E2FE0
             // ROM       RAM         Kart *Unknown*
dd $C1F00000 // $000E2FE0 $800E23E0 - Mario  (4 Bytes) ($C1F00000)
dd $C1F00000 // $000E2FE4 $800E23E4 - Luigi  (4 Bytes) ($C1F00000)
dd $C1F00000 // $000E2FE8 $800E23E8 - Peach  (4 Bytes) ($C1F00000)
dd $C1F00000 // $000E2FEC $800E23EC - Toad   (4 Bytes) ($C1F00000)
dd $C1F00000 // $000E2FF0 $800E23F0 - Yoshi  (4 Bytes) ($C1F00000)
dd $C1F00000 // $000E2FF4 $800E23F4 - D.K.   (4 Bytes) ($C1F00000)
dd $C1F00000 // $000E2FF8 $800E23F8 - Wario  (4 Bytes) ($C1F00000)
dd $C1F00000 // $000E2FFC $800E23FC - Bowser (4 Bytes) ($C1F00000)




origin $000E3014
             // ROM       RAM         Kart *Unknown*
dd $41E00000 // $000E3014 $800E2414 - Mario  (4 Bytes) ($41E00000)
dd $41E00000 // $000E3018 $800E2418 - Luigi  (4 Bytes) ($41E00000)
dd $41E00000 // $000E301C $800E241C - Peach  (4 Bytes) ($41E00000)
dd $41E00000 // $000E3020 $800E2420 - Toad   (4 Bytes) ($41E00000)
dd $41E00000 // $000E3024 $800E2424 - Yoshi  (4 Bytes) ($41E00000)
dd $41E00000 // $000E3028 $800E2428 - D.K.   (4 Bytes) ($41E00000)
dd $41E00000 // $000E302C $800E242C - Wario  (4 Bytes) ($41E00000)
dd $41E00000 // $000E3030 $800E2430 - Bowser (4 Bytes) ($41E00000)

origin $000E3034
             // ROM       RAM         Kart *Unknown*
dd $41E00000 // $000E3034 $800E2434 - Mario  (4 Bytes) ($41E00000)
dd $41E00000 // $000E3038 $800E2438 - Luigi  (4 Bytes) ($41E00000)
dd $41E00000 // $000E303C $800E243C - Peach  (4 Bytes) ($41E00000)
dd $41E00000 // $000E3040 $800E2440 - Toad   (4 Bytes) ($41E00000)
dd $41E00000 // $000E3044 $800E2444 - Yoshi  (4 Bytes) ($41E00000)
dd $41E00000 // $000E3048 $800E2448 - D.K.   (4 Bytes) ($41E00000)
dd $41E00000 // $000E304C $800E244C - Wario  (4 Bytes) ($41E00000)
dd $41E00000 // $000E3050 $800E2450 - Bowser (4 Bytes) ($41E00000)

origin $000E3054
             // ROM       RAM         Kart *Unknown*
dd $420C0000 // $000E3054 $800E2454 - Mario  (4 Bytes) ($420C0000)
dd $420C0000 // $000E3058 $800E2458 - Luigi  (4 Bytes) ($420C0000)
dd $420C0000 // $000E305C $800E245C - Peach  (4 Bytes) ($420C0000)
dd $420C0000 // $000E3060 $800E2460 - Toad   (4 Bytes) ($420C0000)
dd $420C0000 // $000E3064 $800E2464 - Yoshi  (4 Bytes) ($420C0000)
dd $420C0000 // $000E3068 $800E2468 - D.K.   (4 Bytes) ($420C0000)
dd $420C0000 // $000E306C $800E246C - Wario  (4 Bytes) ($420C0000)
dd $420C0000 // $000E3070 $800E2470 - Bowser (4 Bytes) ($420C0000)

origin $000E3074
             // ROM       RAM         Kart *Unknown*
dd $41E00000 // $000E3074 $800E2474 - Mario  (4 Bytes) ($41E00000)
dd $41E00000 // $000E3078 $800E2478 - Luigi  (4 Bytes) ($41E00000)
dd $41E00000 // $000E307C $800E247C - Peach  (4 Bytes) ($41E00000)
dd $41E00000 // $000E3080 $800E2480 - Toad   (4 Bytes) ($41E00000)
dd $41E00000 // $000E3084 $800E2484 - Yoshi  (4 Bytes) ($41E00000)
dd $41E00000 // $000E3088 $800E2488 - D.K.   (4 Bytes) ($41E00000)
dd $41E00000 // $000E308C $800E248C - Wario  (4 Bytes) ($41E00000)
dd $41E00000 // $000E3090 $800E2490 - Bowser (4 Bytes) ($41E00000)

origin $000E3094
             // ROM       RAM         Kart *Unknown*
dd $42400000 // $000E3094 $800E2494 - Mario  (4 Bytes) ($42400000)
dd $42400000 // $000E3098 $800E2498 - Luigi  (4 Bytes) ($42400000)
dd $42400000 // $000E309C $800E249C - Peach  (4 Bytes) ($42400000)
dd $42400000 // $000E30A0 $800E24A0 - Toad   (4 Bytes) ($42400000)
dd $42400000 // $000E30A4 $800E24A4 - Yoshi  (4 Bytes) ($42400000)
dd $42400000 // $000E30A8 $800E24A8 - D.K.   (4 Bytes) ($42400000)
dd $42400000 // $000E30AC $800E24AC - Wario  (4 Bytes) ($42400000)
dd $42400000 // $000E30B0 $800E24B0 - Bowser (4 Bytes) ($42400000)




origin $000E30C8
             // ROM       RAM         Kart *Unknown*
dd $45524000 // $000E30C8 $800E24C8 - Mario  (4 Bytes) ($45524000)
dd $45524000 // $000E30CC $800E24CC - Luigi  (4 Bytes) ($45524000)
dd $45581000 // $000E30D0 $800E24D0 - Peach  (4 Bytes) ($45581000)
dd $45581000 // $000E30D4 $800E24D4 - Toad   (4 Bytes) ($45581000)
dd $45524000 // $000E30D8 $800E24D8 - Yoshi  (4 Bytes) ($45524000)
dd $45524000 // $000E30DC $800E24DC - D.K.   (4 Bytes) ($45524000)
dd $45581000 // $000E30E0 $800E24E0 - Wario  (4 Bytes) ($45581000)
dd $45524000 // $000E30E4 $800E24E4 - Bowser (4 Bytes) ($45524000)

origin $000E30E8
             // ROM       RAM         Kart *Unknown*
dd $45704000 // $000E30E8 $800E24E8 - Mario  (4 Bytes) ($45704000)
dd $45704000 // $000E30EC $800E24EC - Luigi  (4 Bytes) ($45704000)
dd $45767000 // $000E30F0 $800E24F0 - Peach  (4 Bytes) ($45767000)
dd $45767000 // $000E30F4 $800E24F4 - Toad   (4 Bytes) ($45767000)
dd $45704000 // $000E30F8 $800E24F8 - Yoshi  (4 Bytes) ($45704000)
dd $45704000 // $000E30FC $800E24FC - D.K.   (4 Bytes) ($45704000)
dd $45767000 // $000E3100 $800E2500 - Wario  (4 Bytes) ($45767000)
dd $45704000 // $000E3104 $800E2504 - Bowser (4 Bytes) ($45704000)

origin $000E3108
             // ROM       RAM         Kart *Unknown*
dd $45800000 // $000E3108 $800E2508 - Mario  (4 Bytes) ($45800000)
dd $45800000 // $000E310C $800E250C - Luigi  (4 Bytes) ($45800000)
dd $45833800 // $000E3110 $800E2510 - Peach  (4 Bytes) ($45833800)
dd $45833800 // $000E3114 $800E2514 - Toad   (4 Bytes) ($45833800)
dd $45800000 // $000E3118 $800E2518 - Yoshi  (4 Bytes) ($45800000)
dd $45800000 // $000E311C $800E251C - D.K.   (4 Bytes) ($45800000)
dd $45833800 // $000E3120 $800E2520 - Wario  (4 Bytes) ($45833800)
dd $45800000 // $000E3124 $800E2524 - Bowser (4 Bytes) ($45800000)

origin $000E3128
             // ROM       RAM         Kart *Unknown*
dd $45704000 // $000E3128 $800E2528 - Mario  (4 Bytes) ($45704000)
dd $45704000 // $000E312C $800E252C - Luigi  (4 Bytes) ($45704000)
dd $45767000 // $000E3130 $800E2530 - Peach  (4 Bytes) ($45767000)
dd $45767000 // $000E3134 $800E2534 - Toad   (4 Bytes) ($45767000)
dd $45704000 // $000E3138 $800E2538 - Yoshi  (4 Bytes) ($45704000)
dd $45704000 // $000E313C $800E253C - D.K.   (4 Bytes) ($45704000)
dd $45767000 // $000E3140 $800E2540 - Wario  (4 Bytes) ($45767000)
dd $45704000 // $000E3144 $800E2544 - Bowser (4 Bytes) ($45704000)

origin $000E3148
             // ROM       RAM         Kart *Unknown*
dd $45161000 // $000E3128 $800E2528 - Mario  (4 Bytes) ($45161000)
dd $45161000 // $000E312C $800E252C - Luigi  (4 Bytes) ($45161000)
dd $45161000 // $000E3130 $800E2530 - Peach  (4 Bytes) ($45161000)
dd $45161000 // $000E3134 $800E2534 - Toad   (4 Bytes) ($45161000)
dd $45161000 // $000E3138 $800E2538 - Yoshi  (4 Bytes) ($45161000)
dd $45161000 // $000E313C $800E253C - D.K.   (4 Bytes) ($45161000)
dd $45161000 // $000E3140 $800E2540 - Wario  (4 Bytes) ($45161000)
dd $45161000 // $000E3144 $800E2544 - Bowser (4 Bytes) ($45161000)




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