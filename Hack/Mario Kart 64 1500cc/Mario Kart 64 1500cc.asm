// N64 "Mario Kart 64" 1500cc Hack by krom (Peter Lemon):
// Special thanks to queueRAM for the TKMK00 menu & MIO0 logo compressed textures & hacking

arch n64.cpu
endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "Mario Kart 64 1500cc.z64", create
origin $00000000; insert "Mario Kart 64 (U) [!].z64" // Include USA Mario Kart 64 N64 ROM
origin $00000020
db "MARIOKART641500CC          " // $00000020 - PROGRAM TITLE (27 Byte ASCII String, Use Spaces For Unused Bytes)

//-----------------
// Macros
//-----------------

// Seek To RAM Address
macro seek(variable offset) {
  origin ((offset & $7FFFFFFF) + $C00)
  base offset
}

// Align data
macro align(size) {
   while (pc() % {size}) {
      db 0
   }
}

// flag: if 1, pass 0xBE through A3 TKMK00 decoder, else pass 0x00
// seg_addr: segmented address of texture (in 0x0B segment)
// width: width of texture
// height: height of texture
// others unknown
macro MK_TEXTURE(flag, seg_addr, width, height, h0C, h0E, h10, h12) {
  dh {flag}, 0
  dw {seg_addr}
  dh {width}, {height}, {h0C}, {h0E}, {h10}, {h12}
}


//----------------
// String updates
//----------------

// relocate 50cc string pointers since only 4 bytes allocated for them
seek(0x800E76CC)
dw results_50cc
seek(0x800E76DC)
dw awards_50cc

// update strings
seek(0x800EFE16) // start 2 bytes lower to allow for longer string
results_50cc:
db "500(", 0
align(0x4)
results_100cc:
db "1000(", 0
align(0x4)
results_150cc:
db "1500(", 0
align(0x4)
// skip the "extra"
seek(0x800EFE32) // start 2 bytes lower to allow for longer string
awards_50cc:
db "500(", 0
align(0x4)
awards_100cc:
db "1000(", 0
align(0x4)
awards_150cc:
db "1500(", 0
align(0x4)


//-----------------
// Kart Properties
//-----------------

seek($800E2340) // Seek To RAM Address

KartUnknown00:
             // ROM       RAM         Kart *Unknown*
dw $0F12D430 // $000E2F40 $800E2340 - Mario  (4 Bytes) ($0F12D430)
dw $0F09ABFC // $000E2F44 $800E2344 - Luigi  (4 Bytes) ($0F09ABFC)
dw $0F1C4958 // $000E2F48 $800E2348 - Yoshi  (4 Bytes) ($0F1C4958)
dw $0F386858 // $000E2F4C $800E234C - Toad   (4 Bytes) ($0F386858)
dw $0F438874 // $000E2F50 $800E2350 - D.K.   (4 Bytes) ($0F438874)
dw $0F2F5DEC // $000E2F54 $800E2354 - Wario  (4 Bytes) ($0F2F5DEC)
dw $0F258AC8 // $000E2F58 $800E2358 - Peach  (4 Bytes) ($0F258AC8)
dw $0F4F8C88 // $000E2F5C $800E235C - Bowser (4 Bytes) ($0F4F8C88)

KartUnknown01:
              // ROM       RAM         Kart *Unknown*
float32 -10.0 // $000E2F60 $800E2360 - Mario  (IEEE32) (-10.0: $C1200000)
float32 -10.0 // $000E2F64 $800E2364 - Luigi  (IEEE32) (-10.0: $C1200000)
float32 -10.0 // $000E2F68 $800E2368 - Yoshi  (IEEE32) (-10.0: $C1200000)
float32 -10.0 // $000E2F6C $800E236C - Toad   (IEEE32) (-10.0: $C1200000)
float32 -10.0 // $000E2F70 $800E2370 - D.K.   (IEEE32) (-10.0: $C1200000)
float32 -10.0 // $000E2F74 $800E2374 - Wario  (IEEE32) (-10.0: $C1200000)
float32 -10.0 // $000E2F78 $800E2378 - Peach  (IEEE32) (-10.0: $C1200000)
float32 -10.0 // $000E2F7C $800E237C - Bowser (IEEE32) (-10.0: $C1200000)

KartUnknown02:
              // ROM       RAM         Kart *Unknown*
float32 -15.0 // $000E2F80 $800E2380 - Mario  (IEEE32) (-15.0: $C1700000)
float32 -15.0 // $000E2F84 $800E2384 - Luigi  (IEEE32) (-15.0: $C1700000)
float32 -15.0 // $000E2F88 $800E2388 - Yoshi  (IEEE32) (-15.0: $C1700000)
float32 -15.0 // $000E2F8C $800E238C - Toad   (IEEE32) (-15.0: $C1700000)
float32 -15.0 // $000E2F90 $800E2390 - D.K.   (IEEE32) (-15.0: $C1700000)
float32 -15.0 // $000E2F94 $800E2394 - Wario  (IEEE32) (-15.0: $C1700000)
float32 -15.0 // $000E2F98 $800E2398 - Peach  (IEEE32) (-15.0: $C1700000)
float32 -15.0 // $000E2F9C $800E239C - Bowser (IEEE32) (-15.0: $C1700000)

KartUnknown03:
              // ROM       RAM         Kart *Unknown*
float32 -20.0 // $000E2FA0 $800E23A0 - Mario  (IEEE32) (-20.0: $C1A00000)
float32 -20.0 // $000E2FA4 $800E23A4 - Luigi  (IEEE32) (-20.0: $C1A00000)
float32 -20.0 // $000E2FA8 $800E23A8 - Yoshi  (IEEE32) (-20.0: $C1A00000)
float32 -20.0 // $000E2FAC $800E23AC - Toad   (IEEE32) (-20.0: $C1A00000)
float32 -20.0 // $000E2FB0 $800E23B0 - D.K.   (IEEE32) (-20.0: $C1A00000)
float32 -20.0 // $000E2FB4 $800E23B4 - Wario  (IEEE32) (-20.0: $C1A00000)
float32 -20.0 // $000E2FB8 $800E23B8 - Peach  (IEEE32) (-20.0: $C1A00000)
float32 -20.0 // $000E2FBC $800E23BC - Bowser (IEEE32) (-20.0: $C1A00000)

KartUnknown04:
              // ROM       RAM         Kart *Unknown*
float32 -15.0 // $000E2FC0 $800E23C0 - Mario  (IEEE32) (-15.0: $C1700000)
float32 -15.0 // $000E2FC4 $800E23C4 - Luigi  (IEEE32) (-15.0: $C1700000)
float32 -15.0 // $000E2FC8 $800E23C8 - Yoshi  (IEEE32) (-15.0: $C1700000)
float32 -15.0 // $000E2FCC $800E23CC - Toad   (IEEE32) (-15.0: $C1700000)
float32 -15.0 // $000E2FD0 $800E23D0 - D.K.   (IEEE32) (-15.0: $C1700000)
float32 -15.0 // $000E2FD4 $800E23D4 - Wario  (IEEE32) (-15.0: $C1700000)
float32 -15.0 // $000E2FD8 $800E23D8 - Peach  (IEEE32) (-15.0: $C1700000)
float32 -15.0 // $000E2FDC $800E23DC - Bowser (IEEE32) (-15.0: $C1700000)

KartUnknown05:
              // ROM       RAM         Kart *Unknown*
float32 -30.0 // $000E2FE0 $800E23E0 - Mario  (IEEE32) (-30.0: $C1F00000)
float32 -30.0 // $000E2FE4 $800E23E4 - Luigi  (IEEE32) (-30.0: $C1F00000)
float32 -30.0 // $000E2FE8 $800E23E8 - Yoshi  (IEEE32) (-30.0: $C1F00000)
float32 -30.0 // $000E2FEC $800E23EC - Toad   (IEEE32) (-30.0: $C1F00000)
float32 -30.0 // $000E2FF0 $800E23F0 - D.K.   (IEEE32) (-30.0: $C1F00000)
float32 -30.0 // $000E2FF4 $800E23F4 - Wario  (IEEE32) (-30.0: $C1F00000)
float32 -30.0 // $000E2FF8 $800E23F8 - Peach  (IEEE32) (-30.0: $C1F00000)
float32 -30.0 // $000E2FFC $800E23FC - Bowser (IEEE32) (-30.0: $C1F00000)

                 // ROM       RAM         Offsets To IEEE32 Tables Above
dw KartUnknown01 // $000E3000 $800E2400 - Kart *Unknown* (UINT32) ($800E2360)
dw KartUnknown02 // $000E3004 $800E2404 - Kart *Unknown* (UINT32) ($800E2380)
dw KartUnknown03 // $000E3008 $800E2408 - Kart *Unknown* (UINT32) ($800E23A0)
dw KartUnknown04 // $000E300C $800E240C - Kart *Unknown* (UINT32) ($800E23C0)
dw KartUnknown05 // $000E3010 $800E2410 - Kart *Unknown* (UINT32) ($800E23E0)


KartUnknown06:
             // ROM       RAM         Kart *Unknown*
float32 28.0 // $000E3014 $800E2414 - Mario  (IEEE32) (28.0: $41E00000)
float32 28.0 // $000E3018 $800E2418 - Luigi  (IEEE32) (28.0: $41E00000)
float32 28.0 // $000E301C $800E241C - Yoshi  (IEEE32) (28.0: $41E00000)
float32 28.0 // $000E3020 $800E2420 - Toad   (IEEE32) (28.0: $41E00000)
float32 28.0 // $000E3024 $800E2424 - D.K.   (IEEE32) (28.0: $41E00000)
float32 28.0 // $000E3028 $800E2428 - Wario  (IEEE32) (28.0: $41E00000)
float32 28.0 // $000E302C $800E242C - Peach  (IEEE32) (28.0: $41E00000)
float32 28.0 // $000E3030 $800E2430 - Bowser (IEEE32) (28.0: $41E00000)

KartUnknown07:
             // ROM       RAM         Kart *Unknown*
float32 28.0 // $000E3034 $800E2434 - Mario  (IEEE32) (28.0: $41E00000)
float32 28.0 // $000E3038 $800E2438 - Luigi  (IEEE32) (28.0: $41E00000)
float32 28.0 // $000E303C $800E243C - Yoshi  (IEEE32) (28.0: $41E00000)
float32 28.0 // $000E3040 $800E2440 - Toad   (IEEE32) (28.0: $41E00000)
float32 28.0 // $000E3044 $800E2444 - D.K.   (IEEE32) (28.0: $41E00000)
float32 28.0 // $000E3048 $800E2448 - Wario  (IEEE32) (28.0: $41E00000)
float32 28.0 // $000E304C $800E244C - Peach  (IEEE32) (28.0: $41E00000)
float32 28.0 // $000E3050 $800E2450 - Bowser (IEEE32) (28.0: $41E00000)

KartUnknown08:
             // ROM       RAM         Kart *Unknown*
float32 35.0 // $000E3054 $800E2454 - Mario  (IEEE32) (35.0: $420C0000)
float32 35.0 // $000E3058 $800E2458 - Luigi  (IEEE32) (35.0: $420C0000)
float32 35.0 // $000E305C $800E245C - Yoshi  (IEEE32) (35.0: $420C0000)
float32 35.0 // $000E3060 $800E2460 - Toad   (IEEE32) (35.0: $420C0000)
float32 35.0 // $000E3064 $800E2464 - D.K.   (IEEE32) (35.0: $420C0000)
float32 35.0 // $000E3068 $800E2468 - Wario  (IEEE32) (35.0: $420C0000)
float32 35.0 // $000E306C $800E246C - Peach  (IEEE32) (35.0: $420C0000)
float32 35.0 // $000E3070 $800E2470 - Bowser (IEEE32) (35.0: $420C0000)

KartUnknown09:
             // ROM       RAM         Kart *Unknown*
float32 28.0 // $000E3074 $800E2474 - Mario  (IEEE32) (28.0: $41E00000)
float32 28.0 // $000E3078 $800E2478 - Luigi  (IEEE32) (28.0: $41E00000)
float32 28.0 // $000E307C $800E247C - Yoshi  (IEEE32) (28.0: $41E00000)
float32 28.0 // $000E3080 $800E2480 - Toad   (IEEE32) (28.0: $41E00000)
float32 28.0 // $000E3084 $800E2484 - D.K.   (IEEE32) (28.0: $41E00000)
float32 28.0 // $000E3088 $800E2488 - Wario  (IEEE32) (28.0: $41E00000)
float32 28.0 // $000E308C $800E248C - Peach  (IEEE32) (28.0: $41E00000)
float32 28.0 // $000E3090 $800E2490 - Bowser (IEEE32) (28.0: $41E00000)

KartUnknown10:
             // ROM       RAM         Kart *Unknown*
float32 48.0 // $000E3094 $800E2494 - Mario  (IEEE32) (48.0: $42400000)
float32 48.0 // $000E3098 $800E2498 - Luigi  (IEEE32) (48.0: $42400000)
float32 48.0 // $000E309C $800E249C - Yoshi  (IEEE32) (48.0: $42400000)
float32 48.0 // $000E30A0 $800E24A0 - Toad   (IEEE32) (48.0: $42400000)
float32 48.0 // $000E30A4 $800E24A4 - D.K.   (IEEE32) (48.0: $42400000)
float32 48.0 // $000E30A8 $800E24A8 - Wario  (IEEE32) (48.0: $42400000)
float32 48.0 // $000E30AC $800E24AC - Peach  (IEEE32) (48.0: $42400000)
float32 48.0 // $000E30B0 $800E24B0 - Bowser (IEEE32) (48.0: $42400000)

                 // ROM       RAM         Offsets To IEEE32 Tables Above
dw KartUnknown06 // $000E30B4 $800E24B4 - Kart *Unknown* (UINT32) ($800E2414)
dw KartUnknown07 // $000E30B8 $800E24B8 - Kart *Unknown* (UINT32) ($800E2434)
dw KartUnknown08 // $000E30BC $800E24BC - Kart *Unknown* (UINT32) ($800E2454)
dw KartUnknown09 // $000E30C0 $800E24C0 - Kart *Unknown* (UINT32) ($800E2474)
dw KartUnknown10 // $000E30C4 $800E24C4 - Kart *Unknown* (UINT32) ($800E2494)


KartUnknown11:
               // ROM       RAM         Kart *Unknown*
float32 3364.0 // $000E30C8 $800E24C8 - Mario  (IEEE32) (3364.0: $45524000)
float32 3364.0 // $000E30CC $800E24CC - Luigi  (IEEE32) (3364.0: $45524000)
float32 3457.0 // $000E30D0 $800E24D0 - Yoshi  (IEEE32) (3457.0: $45581000)
float32 3457.0 // $000E30D4 $800E24D4 - Toad   (IEEE32) (3457.0: $45581000)
float32 3364.0 // $000E30D8 $800E24D8 - D.K.   (IEEE32) (3364.0: $45524000)
float32 3364.0 // $000E30DC $800E24DC - Wario  (IEEE32) (3364.0: $45524000)
float32 3457.0 // $000E30E0 $800E24E0 - Peach  (IEEE32) (3457.0: $45581000)
float32 3364.0 // $000E30E4 $800E24E4 - Bowser (IEEE32) (3364.0: $45524000)

KartUnknown12:
               // ROM       RAM         Kart *Unknown*
float32 3844.0 // $000E30E8 $800E24E8 - Mario  (IEEE32) (3844.0: $45704000)
float32 3844.0 // $000E30EC $800E24EC - Luigi  (IEEE32) (3844.0: $45704000)
float32 3943.0 // $000E30F0 $800E24F0 - Yoshi  (IEEE32) (3943.0: $45767000)
float32 3943.0 // $000E30F4 $800E24F4 - Toad   (IEEE32) (3943.0: $45767000)
float32 3844.0 // $000E30F8 $800E24F8 - D.K.   (IEEE32) (3844.0: $45704000)
float32 3844.0 // $000E30FC $800E24FC - Wario  (IEEE32) (3844.0: $45704000)
float32 3943.0 // $000E3100 $800E2500 - Peach  (IEEE32) (3943.0: $45767000)
float32 3844.0 // $000E3104 $800E2504 - Bowser (IEEE32) (3844.0: $45704000)

KartUnknown13:
               // ROM       RAM         Kart *Unknown*
float32 4096.0 // $000E3108 $800E2508 - Mario  (IEEE32) (4096.0: $45800000)
float32 4096.0 // $000E310C $800E250C - Luigi  (IEEE32) (4096.0: $45800000)
float32 4199.0 // $000E3110 $800E2510 - Yoshi  (IEEE32) (4199.0: $45833800)
float32 4199.0 // $000E3114 $800E2514 - Toad   (IEEE32) (4199.0: $45833800)
float32 4096.0 // $000E3118 $800E2518 - D.K.   (IEEE32) (4096.0: $45800000)
float32 4096.0 // $000E311C $800E251C - Wario  (IEEE32) (4096.0: $45800000)
float32 4199.0 // $000E3120 $800E2520 - Peach  (IEEE32) (4199.0: $45833800)
float32 4096.0 // $000E3124 $800E2524 - Bowser (IEEE32) (4096.0: $45800000)

KartUnknown14:
               // ROM       RAM         Kart *Unknown*
float32 3844.0 // $000E3128 $800E2528 - Mario  (IEEE32) (3844.0: $45704000)
float32 3844.0 // $000E312C $800E252C - Luigi  (IEEE32) (3844.0: $45704000)
float32 3943.0 // $000E3130 $800E2530 - Yoshi  (IEEE32) (3943.0: $45767000)
float32 3943.0 // $000E3134 $800E2534 - Toad   (IEEE32) (3943.0: $45767000)
float32 3844.0 // $000E3138 $800E2538 - D.K.   (IEEE32) (3844.0: $45704000)
float32 3844.0 // $000E313C $800E253C - Wario  (IEEE32) (3844.0: $45704000)
float32 3943.0 // $000E3140 $800E2540 - Peach  (IEEE32) (3943.0: $45767000)
float32 3844.0 // $000E3144 $800E2544 - Bowser (IEEE32) (3844.0: $45704000)

KartUnknown15:
               // ROM       RAM         Kart *Unknown*
float32 2401.0 // $000E3148 $800E2548 - Mario  (IEEE32) (2401.0: $45161000)
float32 2401.0 // $000E314C $800E254C - Luigi  (IEEE32) (2401.0: $45161000)
float32 2401.0 // $000E3150 $800E2550 - Yoshi  (IEEE32) (2401.0: $45161000)
float32 2401.0 // $000E3154 $800E2554 - Toad   (IEEE32) (2401.0: $45161000)
float32 2401.0 // $000E3158 $800E2558 - D.K.   (IEEE32) (2401.0: $45161000)
float32 2401.0 // $000E315C $800E255C - Wario  (IEEE32) (2401.0: $45161000)
float32 2401.0 // $000E3160 $800E2560 - Peach  (IEEE32) (2401.0: $45161000)
float32 2401.0 // $000E3164 $800E2564 - Bowser (IEEE32) (2401.0: $45161000)

                 // ROM       RAM         Offsets To IEEE32 Tables Above
dw KartUnknown11 // $000E3168 $800E2568 - Kart *Unknown* (UINT32) ($800E24C8)
dw KartUnknown12 // $000E316C $800E256C - Kart *Unknown* (UINT32) ($800E24E8)
dw KartUnknown13 // $000E3170 $800E2570 - Kart *Unknown* (UINT32) ($800E2508)
dw KartUnknown14 // $000E3174 $800E2574 - Kart *Unknown* (UINT32) ($800E2528)
dw KartUnknown15 // $000E3178 $800E2578 - Kart *Unknown* (UINT32) ($800E2548)


KartSpeed50cc:
              // ROM       RAM         50cc Kart Speed
float32 482.0 // $000E317C $800E257C - Mario  (IEEE32) (290.0: $43910000)
float32 482.0 // $000E3180 $800E2580 - Luigi  (IEEE32) (290.0: $43910000)
float32 486.0 // $000E3184 $800E2584 - Yoshi  (IEEE32) (294.0: $43930000)
float32 486.0 // $000E3188 $800E2588 - Toad   (IEEE32) (294.0: $43930000)
float32 482.0 // $000E318C $800E258C - D.K.   (IEEE32) (290.0: $43910000)
float32 482.0 // $000E3190 $800E2590 - Wario  (IEEE32) (290.0: $43910000)
float32 486.0 // $000E3194 $800E2594 - Peach  (IEEE32) (294.0: $43930000)
float32 482.0 // $000E3198 $800E2598 - Bowser (IEEE32) (290.0: $43910000)

KartSpeed100cc:
              // ROM       RAM         100cc / Time Trial Kart Speed
float32 502.0 // $000E319C $800E259C - Mario  (IEEE32) (310.0: $439B0000)
float32 502.0 // $000E31A0 $800E25A0 - Luigi  (IEEE32) (310.0: $439B0000)
float32 506.0 // $000E31A4 $800E25A4 - Yoshi  (IEEE32) (314.0: $439D0000)
float32 506.0 // $000E31A8 $800E25A8 - Toad   (IEEE32) (314.0: $439D0000)
float32 502.0 // $000E31AC $800E25AC - D.K.   (IEEE32) (310.0: $439B0000)
float32 502.0 // $000E31B0 $800E25B0 - Wario  (IEEE32) (310.0: $439B0000)
float32 506.0 // $000E31B4 $800E25B4 - Peach  (IEEE32) (314.0: $439D0000)
float32 502.0 // $000E31B8 $800E25B8 - Bowser (IEEE32) (310.0: $439B0000)

KartSpeed150cc:
              // ROM       RAM         150cc Kart Speed
float32 506.0 // $000E31BC $800E25BC - Mario  (IEEE32) (320.0: $43A00000)
float32 506.0 // $000E31C0 $800E25C0 - Luigi  (IEEE32) (320.0: $43A00000)
float32 510.0 // $000E31C4 $800E25C4 - Yoshi  (IEEE32) (324.0: $43A20000)
float32 510.0 // $000E31C8 $800E25C8 - Toad   (IEEE32) (324.0: $43A20000)
float32 506.0 // $000E31CC $800E25CC - D.K.   (IEEE32) (320.0: $43A00000)
float32 506.0 // $000E31D0 $800E25D0 - Wario  (IEEE32) (320.0: $43A00000)
float32 510.0 // $000E31D4 $800E25D4 - Peach  (IEEE32) (324.0: $43A20000)
float32 506.0 // $000E31D8 $800E25D8 - Bowser (IEEE32) (320.0: $43A00000)

KartSpeedExtra:
              // ROM       RAM         Extra Kart Speed
float32 502.0 // $000E31DC $800E25DC - Mario  (IEEE32) (310.0: $439B0000)
float32 502.0 // $000E31E0 $800E25E0 - Luigi  (IEEE32) (310.0: $439B0000)
float32 506.0 // $000E31E4 $800E25E4 - Yoshi  (IEEE32) (314.0: $439D0000)
float32 506.0 // $000E31E8 $800E25E8 - Toad   (IEEE32) (314.0: $439D0000)
float32 502.0 // $000E31EC $800E25EC - D.K.   (IEEE32) (310.0: $439B0000)
float32 502.0 // $000E31F0 $800E25F0 - Wario  (IEEE32) (310.0: $439B0000)
float32 506.0 // $000E31F4 $800E25F4 - Peach  (IEEE32) (314.0: $439D0000)
float32 502.0 // $000E31F8 $800E25F8 - Bowser (IEEE32) (310.0: $439B0000)

KartSpeedBattle:
              // ROM       RAM         Battle Kart Speed
float32 490.0 // $000E31FC $800E25FC - Mario  (IEEE32) (245.0: $43750000)
float32 490.0 // $000E3200 $800E2600 - Luigi  (IEEE32) (245.0: $43750000)
float32 490.0 // $000E3204 $800E2604 - Yoshi  (IEEE32) (245.0: $43750000)
float32 490.0 // $000E3208 $800E2608 - Toad   (IEEE32) (245.0: $43750000)
float32 490.0 // $000E320C $800E260C - D.K.   (IEEE32) (245.0: $43750000)
float32 490.0 // $000E3210 $800E2610 - Wario  (IEEE32) (245.0: $43750000)
float32 490.0 // $000E3214 $800E2614 - Peach  (IEEE32) (245.0: $43750000)
float32 490.0 // $000E3218 $800E2618 - Bowser (IEEE32) (245.0: $43750000)

                   // ROM       RAM         Offsets To IEEE32 Tables Above
dw KartSpeed50cc   // $000E321C $800E261C -   50cc Kart Speed (UINT32) ($800E257C)
dw KartSpeed100cc  // $000E3220 $800E2620 -  100cc Kart Speed (UINT32) ($800E259C)
dw KartSpeed150cc  // $000E3224 $800E2624 -  150cc Kart Speed (UINT32) ($800E25BC)
dw KartSpeedExtra  // $000E3228 $800E2628 -  Extra Kart Speed (UINT32) ($800E25DC)
dw KartSpeedBattle // $000E322C $800E262C - Battle Kart Speed (UINT32) ($800E25FC)


KartFriction:
               // ROM       RAM         Kart Friction
float32 5800.0 // $000E3230 $800E2630 - Mario  (IEEE32) (5800.0: $45B54000)
float32 5800.0 // $000E3234 $800E2634 - Luigi  (IEEE32) (5800.0: $45B54000)
float32 5800.0 // $000E3238 $800E2638 - Yoshi  (IEEE32) (5800.0: $45B54000)
float32 5800.0 // $000E323C $800E263C - Toad   (IEEE32) (5800.0: $45B54000)
float32 5800.0 // $000E3240 $800E2640 - D.K.   (IEEE32) (5800.0: $45B54000)
float32 5800.0 // $000E3244 $800E2644 - Wario  (IEEE32) (5800.0: $45B54000)
float32 5800.0 // $000E3248 $800E2648 - Peach  (IEEE32) (5800.0: $45B54000)
float32 5800.0 // $000E324C $800E264C - Bowser (IEEE32) (5800.0: $45B54000)

KartGravity:
               // ROM       RAM         Kart Gravity
float32 2600.0 // $000E3250 $800E2650 - Mario  (IEEE32) (2600.0: $45228000)
float32 2600.0 // $000E3254 $800E2654 - Luigi  (IEEE32) (2600.0: $45228000)
float32 2600.0 // $000E3258 $800E2658 - Yoshi  (IEEE32) (2600.0: $45228000)
float32 2600.0 // $000E325C $800E265C - Toad   (IEEE32) (2600.0: $45228000)
float32 2600.0 // $000E3260 $800E2660 - D.K.   (IEEE32) (2600.0: $45228000)
float32 2600.0 // $000E3264 $800E2664 - Wario  (IEEE32) (2600.0: $45228000)
float32 2600.0 // $000E3268 $800E2668 - Peach  (IEEE32) (2600.0: $45228000)
float32 2600.0 // $000E326C $800E266C - Bowser (IEEE32) (2600.0: $45228000)

KartUnknown16:
             // ROM       RAM         Kart *Unknown*
float32 0.12 // $000E3270 $800E2670 - Mario  (IEEE32) (0.12: $3DF5C28F)
float32 0.12 // $000E3274 $800E2674 - Luigi  (IEEE32) (0.12: $3DF5C28F)
float32 0.12 // $000E3278 $800E2678 - Yoshi  (IEEE32) (0.12: $3DF5C28F)
float32 0.12 // $000E327C $800E267C - Toad   (IEEE32) (0.12: $3DF5C28F)
float32 0.12 // $000E3280 $800E2680 - D.K.   (IEEE32) (0.12: $3DF5C28F)
float32 0.12 // $000E3284 $800E2684 - Wario  (IEEE32) (0.12: $3DF5C28F)
float32 0.12 // $000E3288 $800E2688 - Peach  (IEEE32) (0.12: $3DF5C28F)
float32 0.12 // $000E328C $800E268C - Bowser (IEEE32) (0.12: $3DF5C28F)

KartTopSpeed:
            // ROM       RAM         Kart Top Speed
float32 9.0 // $000E3290 $800E2690 - Mario  (IEEE32) (9.0: $41100000)
float32 9.0 // $000E3294 $800E2694 - Luigi  (IEEE32) (9.0: $41100000)
float32 9.0 // $000E3298 $800E2698 - Yoshi  (IEEE32) (9.0: $41100000)
float32 9.0 // $000E329C $800E269C - Toad   (IEEE32) (9.0: $41100000)
float32 9.0 // $000E32A0 $800E26A0 - D.K.   (IEEE32) (9.0: $41100000)
float32 9.0 // $000E32A4 $800E26A4 - Wario  (IEEE32) (9.0: $41100000)
float32 9.0 // $000E32A8 $800E26A8 - Peach  (IEEE32) (9.0: $41100000)
float32 9.0 // $000E32AC $800E26AC - Bowser (IEEE32) (9.0: $41100000)

KartBoundingBox:
            // ROM       RAM         Kart Bounding Box Size (Also Affects Camera Angle)
float32 5.5 // $000E32B0 $800E26B0 - Mario  (IEEE32) (5.5: $40B00000)
float32 5.5 // $000E32B4 $800E26B4 - Luigi  (IEEE32) (5.5: $40B00000)
float32 5.5 // $000E32B8 $800E26B8 - Yoshi  (IEEE32) (5.5: $40B00000)
float32 5.5 // $000E32BC $800E26BC - Toad   (IEEE32) (5.5: $40B00000)
float32 5.5 // $000E32C0 $800E26C0 - D.K.   (IEEE32) (5.5: $40B00000)
float32 6.0 // $000E32C4 $800E26C4 - Wario  (IEEE32) (6.0: $40C00000)
float32 5.5 // $000E32C8 $800E26C8 - Peach  (IEEE32) (5.5: $40B00000)
float32 6.0 // $000E32CC $800E26CC - Bowser (IEEE32) (6.0: $40C00000)


KartUnknown17: // Mario
             // ROM       RAM         Kart *Unknown*
float32 0.0  // $000E32D0 $800E26D0 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E32D4 $800E26D4 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E32D8 $800E26D8 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E32DC $800E26DC - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E32E0 $800E26E0 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E32E4 $800E26E4 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E32E8 $800E26E8 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.38 // $000E32EC $800E26EC - Kart *Unknown* (IEEE32) (0.38: $3EC28F5C)
float32 0.38 // $000E32F0 $800E26F0 - Kart *Unknown* (IEEE32) (0.38: $3EC28F5C)
float32 0.0  // $000E32F4 $800E26F4 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.38 // $000E32F8 $800E26F8 - Kart *Unknown* (IEEE32) (0.38: $3EC28F5C)
float32 0.1  // $000E32FC $800E26FC - Kart *Unknown* (IEEE32) (0.1:  $3DCCCCCD)
float32 0.0  // $000E3300 $800E2700 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.38 // $000E3304 $800E2704 - Kart *Unknown* (IEEE32) (0.38: $3EC28F5C)
float32 0.0  // $000E3308 $800E2708 - Kart *Unknown* (IEEE32) (0.0:  $00000000)

KartUnknown18: // Luigi
             // ROM       RAM         Kart *Unknown*
float32 0.0  // $000E330C $800E270C - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3310 $800E2710 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3314 $800E2714 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3318 $800E2718 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E331C $800E271C - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3320 $800E2720 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3324 $800E2724 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.38 // $000E3328 $800E2728 - Kart *Unknown* (IEEE32) (0.38: $3EC28F5C)
float32 0.38 // $000E332C $800E272C - Kart *Unknown* (IEEE32) (0.38: $3EC28F5C)
float32 0.0  // $000E3330 $800E2730 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.38 // $000E3334 $800E2734 - Kart *Unknown* (IEEE32) (0.38: $3EC28F5C)
float32 0.1  // $000E3338 $800E2738 - Kart *Unknown* (IEEE32) (0.1:  $3DCCCCCD)
float32 0.0  // $000E333C $800E273C - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.38 // $000E3340 $800E2740 - Kart *Unknown* (IEEE32) (0.38: $3EC28F5C)
float32 0.0  // $000E3344 $800E2744 - Kart *Unknown* (IEEE32) (0.0:  $00000000)

KartUnknown19: // Yoshi
             // ROM       RAM         Kart *Unknown*
float32 0.0  // $000E3348 $800E2748 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E334C $800E274C - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3350 $800E2750 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3354 $800E2754 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3358 $800E2758 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E335C $800E275C - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3360 $800E2760 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.38 // $000E3364 $800E2764 - Kart *Unknown* (IEEE32) (0.38: $3EC28F5C)
float32 0.38 // $000E3368 $800E2768 - Kart *Unknown* (IEEE32) (0.38: $3EC28F5C)
float32 0.0  // $000E336C $800E276C - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.38 // $000E3370 $800E2770 - Kart *Unknown* (IEEE32) (0.38: $3EC28F5C)
float32 0.1  // $000E3374 $800E2774 - Kart *Unknown* (IEEE32) (0.1:  $3DCCCCCD)
float32 0.0  // $000E3378 $800E2778 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.38 // $000E337C $800E277C - Kart *Unknown* (IEEE32) (0.38: $3EC28F5C)
float32 0.0  // $000E3380 $800E2780 - Kart *Unknown* (IEEE32) (0.0:  $00000000)

KartUnknown20: // Toad
             // ROM       RAM         Kart *Unknown*
float32 0.0  // $000E3384 $800E2784 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3388 $800E2788 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E338C $800E278C - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3390 $800E2790 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3394 $800E2794 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3398 $800E2798 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E339C $800E279C - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.38 // $000E33A0 $800E27A0 - Kart *Unknown* (IEEE32) (0.38: $3EC28F5C)
float32 0.38 // $000E33A4 $800E27A4 - Kart *Unknown* (IEEE32) (0.38: $3EC28F5C)
float32 0.0  // $000E33A8 $800E27A8 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.38 // $000E33AC $800E27AC - Kart *Unknown* (IEEE32) (0.38: $3EC28F5C)
float32 0.1  // $000E33B0 $800E27B0 - Kart *Unknown* (IEEE32) (0.1:  $3DCCCCCD)
float32 0.0  // $000E33B4 $800E27B4 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.38 // $000E33B8 $800E27B8 - Kart *Unknown* (IEEE32) (0.38: $3EC28F5C)
float32 0.0  // $000E33BC $800E27BC - Kart *Unknown* (IEEE32) (0.0:  $00000000)

KartUnknown21: // D.K.
             // ROM       RAM         Kart *Unknown*
float32 0.0  // $000E33C0 $800E27C0 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E33C4 $800E27C4 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E33C8 $800E27C8 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E33CC $800E27CC - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E33D0 $800E27D0 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E33D4 $800E27D4 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E33D8 $800E27D8 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.38 // $000E33DC $800E27DC - Kart *Unknown* (IEEE32) (0.38: $3EC28F5C)
float32 0.38 // $000E33E0 $800E27E0 - Kart *Unknown* (IEEE32) (0.38: $3EC28F5C)
float32 0.0  // $000E33E4 $800E27E4 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.38 // $000E33E8 $800E27E8 - Kart *Unknown* (IEEE32) (0.38: $3EC28F5C)
float32 0.1  // $000E33EC $800E27EC - Kart *Unknown* (IEEE32) (0.1:  $3DCCCCCD)
float32 0.0  // $000E33F0 $800E27F0 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.38 // $000E33F4 $800E27F4 - Kart *Unknown* (IEEE32) (0.38: $3EC28F5C)
float32 0.0  // $000E33F8 $800E27F8 - Kart *Unknown* (IEEE32) (0.0:  $00000000)

KartUnknown22: // Wario
             // ROM       RAM         Kart *Unknown*
float32 0.0  // $000E33FC $800E27FC - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3400 $800E2800 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3404 $800E2804 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3408 $800E2808 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E340C $800E280C - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3410 $800E2810 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3414 $800E2814 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.38 // $000E3418 $800E2818 - Kart *Unknown* (IEEE32) (0.38: $3EC28F5C)
float32 0.38 // $000E341C $800E281C - Kart *Unknown* (IEEE32) (0.38: $3EC28F5C)
float32 0.0  // $000E3420 $800E2820 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.38 // $000E3424 $800E2824 - Kart *Unknown* (IEEE32) (0.38: $3EC28F5C)
float32 0.1  // $000E3428 $800E2828 - Kart *Unknown* (IEEE32) (0.1:  $3DCCCCCD)
float32 0.0  // $000E342C $800E282C - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.38 // $000E3430 $800E2830 - Kart *Unknown* (IEEE32) (0.38: $3EC28F5C)
float32 0.0  // $000E3434 $800E2834 - Kart *Unknown* (IEEE32) (0.0:  $00000000)

KartUnknown23: // Peach
             // ROM       RAM         Kart *Unknown*
float32 0.0  // $000E3438 $800E2838 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E343C $800E283C - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3440 $800E2840 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3444 $800E2844 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3448 $800E2848 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E344C $800E284C - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3450 $800E2850 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.38 // $000E3454 $800E2854 - Kart *Unknown* (IEEE32) (0.38: $3EC28F5C)
float32 0.38 // $000E3458 $800E2858 - Kart *Unknown* (IEEE32) (0.38: $3EC28F5C)
float32 0.0  // $000E345C $800E285C - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.38 // $000E3460 $800E2860 - Kart *Unknown* (IEEE32) (0.38: $3EC28F5C)
float32 0.1  // $000E3464 $800E2864 - Kart *Unknown* (IEEE32) (0.1:  $3DCCCCCD)
float32 0.0  // $000E3468 $800E2868 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.38 // $000E346C $800E286C - Kart *Unknown* (IEEE32) (0.38: $3EC28F5C)
float32 0.0  // $000E3470 $800E2870 - Kart *Unknown* (IEEE32) (0.0:  $00000000)

KartUnknown24: // Bowser
             // ROM       RAM         Kart *Unknown*
float32 0.0  // $000E3474 $800E2874 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3478 $800E2878 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E347C $800E287C - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3480 $800E2880 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3484 $800E2884 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3488 $800E2888 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E348C $800E288C - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.38 // $000E3490 $800E2890 - Kart *Unknown* (IEEE32) (0.38: $3EC28F5C)
float32 0.38 // $000E3494 $800E2894 - Kart *Unknown* (IEEE32) (0.38: $3EC28F5C)
float32 0.0  // $000E3498 $800E2898 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.38 // $000E349C $800E289C - Kart *Unknown* (IEEE32) (0.38: $3EC28F5C)
float32 0.1  // $000E34A0 $800E28A0 - Kart *Unknown* (IEEE32) (0.1:  $3DCCCCCD)
float32 0.0  // $000E34A4 $800E28A4 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.38 // $000E34A8 $800E28A8 - Kart *Unknown* (IEEE32) (0.38: $3EC28F5C)
float32 0.0  // $000E34AC $800E28AC - Kart *Unknown* (IEEE32) (0.0:  $00000000)


KartUnknown25: // Mario
             // ROM       RAM         Kart *Unknown*
float32 0.0  // $000E34B0 $800E28B0 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E34B4 $800E28B4 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.3  // $000E34B8 $800E28B8 - Kart *Unknown* (IEEE32) (0.3:  $3E99999A)
float32 0.3  // $000E34BC $800E28BC - Kart *Unknown* (IEEE32) (0.3:  $3E99999A)
float32 0.0  // $000E34C0 $800E28C0 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.3  // $000E34C4 $800E28C4 - Kart *Unknown* (IEEE32) (0.3:  $3E99999A)
float32 0.0  // $000E34C8 $800E28C8 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.58 // $000E34CC $800E28CC - Kart *Unknown* (IEEE32) (0.58: $3F147AE1)
float32 0.58 // $000E34D0 $800E28D0 - Kart *Unknown* (IEEE32) (0.58: $3F147AE1)
float32 0.0  // $000E34D4 $800E28D4 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.58 // $000E34D8 $800E28D8 - Kart *Unknown* (IEEE32) (0.58: $3F147AE1)
float32 0.28 // $000E34DC $800E28DC - Kart *Unknown* (IEEE32) (0.28: $3E8F5C29)
float32 0.0  // $000E34E0 $800E28E0 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.58 // $000E34E4 $800E28E4 - Kart *Unknown* (IEEE32) (0.58: $3F147AE1)
float32 0.0  // $000E34E8 $800E28E8 - Kart *Unknown* (IEEE32) (0.0:  $00000000)

KartUnknown26: // Luigi
             // ROM       RAM         Kart *Unknown*
float32 0.0  // $000E34EC $800E28EC - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E34F0 $800E28F0 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.3  // $000E34F4 $800E28F4 - Kart *Unknown* (IEEE32) (0.3:  $3E99999A)
float32 0.3  // $000E34F8 $800E28F8 - Kart *Unknown* (IEEE32) (0.3:  $3E99999A)
float32 0.0  // $000E35FC $800E28FC - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.3  // $000E3500 $800E2900 - Kart *Unknown* (IEEE32) (0.3:  $3E99999A)
float32 0.0  // $000E3504 $800E2904 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.58 // $000E3508 $800E2908 - Kart *Unknown* (IEEE32) (0.58: $3F147AE1)
float32 0.58 // $000E350C $800E290C - Kart *Unknown* (IEEE32) (0.58: $3F147AE1)
float32 0.0  // $000E3510 $800E2910 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.58 // $000E3514 $800E2914 - Kart *Unknown* (IEEE32) (0.58: $3F147AE1)
float32 0.28 // $000E3518 $800E2918 - Kart *Unknown* (IEEE32) (0.28: $3E8F5C29)
float32 0.0  // $000E351C $800E291C - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.58 // $000E3520 $800E2920 - Kart *Unknown* (IEEE32) (0.58: $3F147AE1)
float32 0.0  // $000E3524 $800E2924 - Kart *Unknown* (IEEE32) (0.0:  $00000000)

KartUnknown27: // Yoshi
             // ROM       RAM         Kart *Unknown*
float32 0.0  // $000E3528 $800E2928 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E352C $800E292C - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.3  // $000E3530 $800E2930 - Kart *Unknown* (IEEE32) (0.3:  $3E99999A)
float32 0.3  // $000E3534 $800E2934 - Kart *Unknown* (IEEE32) (0.3:  $3E99999A)
float32 0.0  // $000E3538 $800E2938 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.3  // $000E353C $800E293C - Kart *Unknown* (IEEE32) (0.3:  $3E99999A)
float32 0.0  // $000E3540 $800E2940 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.58 // $000E3544 $800E2944 - Kart *Unknown* (IEEE32) (0.58: $3F147AE1)
float32 0.58 // $000E3548 $800E2948 - Kart *Unknown* (IEEE32) (0.58: $3F147AE1)
float32 0.0  // $000E354C $800E294C - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.58 // $000E3550 $800E2950 - Kart *Unknown* (IEEE32) (0.58: $3F147AE1)
float32 0.28 // $000E3554 $800E2954 - Kart *Unknown* (IEEE32) (0.28: $3E8F5C29)
float32 0.0  // $000E3558 $800E2958 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.58 // $000E355C $800E295C - Kart *Unknown* (IEEE32) (0.58: $3F147AE1)
float32 0.0  // $000E3560 $800E2960 - Kart *Unknown* (IEEE32) (0.0:  $00000000)

KartUnknown28: // Toad
             // ROM       RAM         Kart *Unknown*
float32 0.0  // $000E3564 $800E2964 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3568 $800E2968 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.3  // $000E356C $800E296C - Kart *Unknown* (IEEE32) (0.3:  $3E99999A)
float32 0.3  // $000E3570 $800E2970 - Kart *Unknown* (IEEE32) (0.3:  $3E99999A)
float32 0.0  // $000E3574 $800E2974 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.3  // $000E3578 $800E2978 - Kart *Unknown* (IEEE32) (0.3:  $3E99999A)
float32 0.0  // $000E357C $800E297C - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.58 // $000E3580 $800E2980 - Kart *Unknown* (IEEE32) (0.58: $3F147AE1)
float32 0.58 // $000E3584 $800E2984 - Kart *Unknown* (IEEE32) (0.58: $3F147AE1)
float32 0.0  // $000E3588 $800E2988 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.58 // $000E358C $800E298C - Kart *Unknown* (IEEE32) (0.58: $3F147AE1)
float32 0.28 // $000E3590 $800E2990 - Kart *Unknown* (IEEE32) (0.28: $3E8F5C29)
float32 0.0  // $000E3594 $800E2994 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.58 // $000E3598 $800E2998 - Kart *Unknown* (IEEE32) (0.58: $3F147AE1)
float32 0.0  // $000E359C $800E299C - Kart *Unknown* (IEEE32) (0.0:  $00000000)

KartUnknown29: // D.K.
             // ROM       RAM         Kart *Unknown*
float32 0.0  // $000E35A0 $800E29A0 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E35A4 $800E29A4 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.3  // $000E35A8 $800E29A8 - Kart *Unknown* (IEEE32) (0.3:  $3E99999A)
float32 0.3  // $000E35AC $800E29AC - Kart *Unknown* (IEEE32) (0.3:  $3E99999A)
float32 0.0  // $000E35B0 $800E29B0 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.3  // $000E35B4 $800E29B4 - Kart *Unknown* (IEEE32) (0.3:  $3E99999A)
float32 0.0  // $000E35B8 $800E29B8 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.58 // $000E35BC $800E29BC - Kart *Unknown* (IEEE32) (0.58: $3F147AE1)
float32 0.58 // $000E35C0 $800E29C0 - Kart *Unknown* (IEEE32) (0.58: $3F147AE1)
float32 0.0  // $000E35C4 $800E29C4 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.58 // $000E35C8 $800E29C8 - Kart *Unknown* (IEEE32) (0.58: $3F147AE1)
float32 0.28 // $000E35CC $800E29CC - Kart *Unknown* (IEEE32) (0.28: $3E8F5C29)
float32 0.0  // $000E35D0 $800E29D0 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.58 // $000E35D4 $800E29D4 - Kart *Unknown* (IEEE32) (0.58: $3F147AE1)
float32 0.0  // $000E35D8 $800E29D8 - Kart *Unknown* (IEEE32) (0.0:  $00000000)

KartUnknown30: // Wario
             // ROM       RAM         Kart *Unknown*
float32 0.0  // $000E35DC $800E29DC - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E35E0 $800E29E0 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.3  // $000E35E4 $800E29E4 - Kart *Unknown* (IEEE32) (0.3:  $3E99999A)
float32 0.3  // $000E35E8 $800E29E8 - Kart *Unknown* (IEEE32) (0.3:  $3E99999A)
float32 0.0  // $000E35EC $800E29EC - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.3  // $000E35F0 $800E29F0 - Kart *Unknown* (IEEE32) (0.3:  $3E99999A)
float32 0.0  // $000E35F4 $800E29F4 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.58 // $000E35F8 $800E29F8 - Kart *Unknown* (IEEE32) (0.58: $3F147AE1)
float32 0.58 // $000E35FC $800E29FC - Kart *Unknown* (IEEE32) (0.58: $3F147AE1)
float32 0.0  // $000E3600 $800E2A00 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.58 // $000E3604 $800E2A04 - Kart *Unknown* (IEEE32) (0.58: $3F147AE1)
float32 0.28 // $000E3608 $800E2A08 - Kart *Unknown* (IEEE32) (0.28: $3E8F5C29)
float32 0.0  // $000E360C $800E2A0C - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.58 // $000E3610 $800E2A10 - Kart *Unknown* (IEEE32) (0.58: $3F147AE1)
float32 0.0  // $000E3614 $800E2A14 - Kart *Unknown* (IEEE32) (0.0:  $00000000)

KartUnknown31: // Peach
             // ROM       RAM         Kart *Unknown*
float32 0.0  // $000E3618 $800E2A18 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E361C $800E2A1C - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.3  // $000E3620 $800E2A20 - Kart *Unknown* (IEEE32) (0.3:  $3E99999A)
float32 0.3  // $000E3624 $800E2A24 - Kart *Unknown* (IEEE32) (0.3:  $3E99999A)
float32 0.0  // $000E3628 $800E2A28 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.3  // $000E362C $800E2A2C - Kart *Unknown* (IEEE32) (0.3:  $3E99999A)
float32 0.0  // $000E3630 $800E2A30 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.58 // $000E3634 $800E2A34 - Kart *Unknown* (IEEE32) (0.58: $3F147AE1)
float32 0.58 // $000E3638 $800E2A38 - Kart *Unknown* (IEEE32) (0.58: $3F147AE1)
float32 0.0  // $000E363C $800E2A3C - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.58 // $000E3640 $800E2A40 - Kart *Unknown* (IEEE32) (0.58: $3F147AE1)
float32 0.28 // $000E3644 $800E2A44 - Kart *Unknown* (IEEE32) (0.28: $3E8F5C29)
float32 0.0  // $000E3648 $800E2A48 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.58 // $000E364C $800E2A4C - Kart *Unknown* (IEEE32) (0.58: $3F147AE1)
float32 0.0  // $000E3650 $800E2A50 - Kart *Unknown* (IEEE32) (0.0:  $00000000)

KartUnknown32: // Bowser
             // ROM       RAM         Kart *Unknown*
float32 0.0  // $000E3654 $800E2A54 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3658 $800E2A58 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.3  // $000E365C $800E2A5C - Kart *Unknown* (IEEE32) (0.3:  $3E99999A)
float32 0.3  // $000E3660 $800E2A60 - Kart *Unknown* (IEEE32) (0.3:  $3E99999A)
float32 0.0  // $000E3664 $800E2A64 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.3  // $000E3668 $800E2A68 - Kart *Unknown* (IEEE32) (0.3:  $3E99999A)
float32 0.0  // $000E366C $800E2A6C - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.58 // $000E3670 $800E2A70 - Kart *Unknown* (IEEE32) (0.58: $3F147AE1)
float32 0.58 // $000E3674 $800E2A74 - Kart *Unknown* (IEEE32) (0.58: $3F147AE1)
float32 0.0  // $000E3678 $800E2A78 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.58 // $000E367C $800E2A7C - Kart *Unknown* (IEEE32) (0.58: $3F147AE1)
float32 0.28 // $000E3680 $800E2A80 - Kart *Unknown* (IEEE32) (0.28: $3E8F5C29)
float32 0.0  // $000E3684 $800E2A84 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.58 // $000E3688 $800E2A88 - Kart *Unknown* (IEEE32) (0.58: $3F147AE1)
float32 0.0  // $000E368C $800E2A8C - Kart *Unknown* (IEEE32) (0.0:  $00000000)

                 // ROM       RAM         Offsets To IEEE32 Tables Above
dw KartUnknown25 // $000E3690 $800E2A90 - Kart *Unknown* Mario  (UINT32) ($800E28B0)
dw KartUnknown26 // $000E3694 $800E2A94 - Kart *Unknown* Luigi  (UINT32) ($800E28EC)
dw KartUnknown27 // $000E3698 $800E2A98 - Kart *Unknown* Yoshi  (UINT32) ($800E2928)
dw KartUnknown28 // $000E369C $800E2A9C - Kart *Unknown* Toad   (UINT32) ($800E2964)
dw KartUnknown29 // $000E36A0 $800E2AA0 - Kart *Unknown* D.K.   (UINT32) ($800E29A0)
dw KartUnknown30 // $000E36A4 $800E2AA4 - Kart *Unknown* Wario  (UINT32) ($800E29DC)
dw KartUnknown31 // $000E36A8 $800E2AA8 - Kart *Unknown* Peach  (UINT32) ($800E2A18)
dw KartUnknown32 // $000E36AC $800E2AAC - Kart *Unknown* Bowser (UINT32) ($800E2A54)

                 // ROM       RAM         Offsets To IEEE32 Tables Above
dw KartUnknown17 // $000E36B0 $800E2AB0 - Kart *Unknown* Mario  (UINT32) ($800E26D0)
dw KartUnknown18 // $000E36B4 $800E2AB4 - Kart *Unknown* Luigi  (UINT32) ($800E270C)
dw KartUnknown19 // $000E36B8 $800E2AB8 - Kart *Unknown* Yoshi  (UINT32) ($800E2748)
dw KartUnknown20 // $000E36BC $800E2ABC - Kart *Unknown* Toad   (UINT32) ($800E2784)
dw KartUnknown21 // $000E36C0 $800E2AC0 - Kart *Unknown* D.K.   (UINT32) ($800E27C0)
dw KartUnknown22 // $000E36C4 $800E2AC4 - Kart *Unknown* Wario  (UINT32) ($800E27FC)
dw KartUnknown23 // $000E36C8 $800E2AC8 - Kart *Unknown* Peach  (UINT32) ($800E2838)
dw KartUnknown24 // $000E36CC $800E2ACC - Kart *Unknown* Bowser (UINT32) ($800E2874)


KartUnknown33: // Mario
             // ROM       RAM         Kart *Unknown*
float32 0.0  // $000E36D0 $800E2AD0 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E36D4 $800E2AD4 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E36D8 $800E2AD8 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E36DC $800E2ADC - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E36E0 $800E2AE0 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E36E4 $800E2AE4 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E36E8 $800E2AE8 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.03 // $000E36EC $800E2AEC - Kart *Unknown* (IEEE32) (0.03: $3CF5C28F)
float32 0.03 // $000E36F0 $800E2AF0 - Kart *Unknown* (IEEE32) (0.03: $3CF5C28F)
float32 0.0  // $000E36F4 $800E2AF4 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E36F8 $800E2AF8 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.03 // $000E36FC $800E2AFC - Kart *Unknown* (IEEE32) (0.03: $3CF5C28F)
float32 0.0  // $000E3700 $800E2B00 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.03 // $000E3704 $800E2B04 - Kart *Unknown* (IEEE32) (0.03: $3CF5C28F)
float32 0.03 // $000E3708 $800E2B08 - Kart *Unknown* (IEEE32) (0.03: $3CF5C28F)

KartUnknown34: // Luigi
             // ROM       RAM         Kart *Unknown*
float32 0.0  // $000E370C $800E2B0C - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3710 $800E2B10 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3714 $800E2B14 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3718 $800E2B18 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E371C $800E2B1C - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3720 $800E2B20 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3724 $800E2B24 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.03 // $000E3728 $800E2B28 - Kart *Unknown* (IEEE32) (0.03: $3CF5C28F)
float32 0.03 // $000E372C $800E2B2C - Kart *Unknown* (IEEE32) (0.03: $3CF5C28F)
float32 0.0  // $000E3730 $800E2B30 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3734 $800E2B34 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.03 // $000E3738 $800E2B38 - Kart *Unknown* (IEEE32) (0.03: $3CF5C28F)
float32 0.0  // $000E373C $800E2B3C - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.03 // $000E3740 $800E2B40 - Kart *Unknown* (IEEE32) (0.03: $3CF5C28F)
float32 0.03 // $000E3744 $800E2B44 - Kart *Unknown* (IEEE32) (0.03: $3CF5C28F)

KartUnknown35: // Yoshi
             // ROM       RAM         Kart *Unknown*
float32 0.0  // $000E3748 $800E2B48 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E374C $800E2B4C - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3750 $800E2B50 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3754 $800E2B54 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3758 $800E2B58 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E375C $800E2B5C - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3760 $800E2B60 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.02 // $000E3764 $800E2B64 - Kart *Unknown* (IEEE32) (0.02: $3CA3D70A)
float32 0.02 // $000E3768 $800E2B68 - Kart *Unknown* (IEEE32) (0.02: $3CA3D70A)
float32 0.0  // $000E376C $800E2B6C - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3770 $800E2B70 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.02 // $000E3774 $800E2B74 - Kart *Unknown* (IEEE32) (0.02: $3CA3D70A)
float32 0.0  // $000E3778 $800E2B78 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.02 // $000E377C $800E2B7C - Kart *Unknown* (IEEE32) (0.02: $3CA3D70A)
float32 0.02 // $000E3780 $800E2B80 - Kart *Unknown* (IEEE32) (0.02: $3CA3D70A)

KartUnknown36: // Toad
             // ROM       RAM         Kart *Unknown*
float32 0.0  // $000E3784 $800E2B84 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3788 $800E2B88 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E378C $800E2B8C - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3790 $800E2B90 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3794 $800E2B94 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3798 $800E2B98 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E379C $800E2B9C - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.02 // $000E37A0 $800E2BA0 - Kart *Unknown* (IEEE32) (0.02: $3CA3D70A)
float32 0.02 // $000E37A4 $800E2BA4 - Kart *Unknown* (IEEE32) (0.02: $3CA3D70A)
float32 0.0  // $000E37A8 $800E2BA8 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E37AC $800E2BAC - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.02 // $000E37B0 $800E2BB0 - Kart *Unknown* (IEEE32) (0.02: $3CA3D70A)
float32 0.0  // $000E37B4 $800E2BB4 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.02 // $000E37B8 $800E2BB8 - Kart *Unknown* (IEEE32) (0.02: $3CA3D70A)
float32 0.02 // $000E37BC $800E2BBC - Kart *Unknown* (IEEE32) (0.02: $3CA3D70A)

KartUnknown37: // D.K.
             // ROM       RAM         Kart *Unknown*
float32 0.0  // $000E37C0 $800E2BC0 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E37C4 $800E2BC4 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E37C8 $800E2BC8 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E37CC $800E2BCC - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E37D0 $800E2BD0 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E37D4 $800E2BD4 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E37D8 $800E2BD8 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.04 // $000E37DC $800E2BDC - Kart *Unknown* (IEEE32) (0.02: $3D23D70A)
float32 0.04 // $000E37E0 $800E2BE0 - Kart *Unknown* (IEEE32) (0.02: $3D23D70A)
float32 0.0  // $000E37E4 $800E2BE4 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E37E8 $800E2BE8 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.04 // $000E37EC $800E2BEC - Kart *Unknown* (IEEE32) (0.02: $3D23D70A)
float32 0.0  // $000E37F0 $800E2BF0 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.04 // $000E37F4 $800E2BF4 - Kart *Unknown* (IEEE32) (0.02: $3D23D70A)
float32 0.04 // $000E37F8 $800E2BF8 - Kart *Unknown* (IEEE32) (0.02: $3D23D70A)

KartUnknown38: // Wario
             // ROM       RAM         Kart *Unknown*
float32 0.0  // $000E37FC $800E2BFC - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3800 $800E2C00 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3804 $800E2C04 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3808 $800E2C08 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E380C $800E2C0C - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3810 $800E2C10 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3814 $800E2C14 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.04 // $000E3818 $800E2C18 - Kart *Unknown* (IEEE32) (0.02: $3D23D70A)
float32 0.04 // $000E381C $800E2C1C - Kart *Unknown* (IEEE32) (0.02: $3D23D70A)
float32 0.0  // $000E3820 $800E2C20 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3824 $800E2C24 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.04 // $000E3828 $800E2C28 - Kart *Unknown* (IEEE32) (0.02: $3D23D70A)
float32 0.0  // $000E382C $800E2C2C - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.04 // $000E3830 $800E2C30 - Kart *Unknown* (IEEE32) (0.02: $3D23D70A)
float32 0.04 // $000E3834 $800E2C34 - Kart *Unknown* (IEEE32) (0.02: $3D23D70A)

KartUnknown39: // Peach
             // ROM       RAM         Kart *Unknown*
float32 0.0  // $000E3838 $800E2C38 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E383C $800E2C3C - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3840 $800E2C40 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3844 $800E2C44 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3848 $800E2C48 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E384C $800E2C4C - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3850 $800E2C50 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.02 // $000E3854 $800E2C54 - Kart *Unknown* (IEEE32) (0.02: $3CA3D70A)
float32 0.02 // $000E3858 $800E2C58 - Kart *Unknown* (IEEE32) (0.02: $3CA3D70A)
float32 0.0  // $000E385C $800E2C5C - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3860 $800E2C60 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.02 // $000E3864 $800E2C64 - Kart *Unknown* (IEEE32) (0.02: $3CA3D70A)
float32 0.0  // $000E3868 $800E2C68 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.02 // $000E386C $800E2C6C - Kart *Unknown* (IEEE32) (0.02: $3CA3D70A)
float32 0.02 // $000E3870 $800E2C70 - Kart *Unknown* (IEEE32) (0.02: $3CA3D70A)

KartUnknown40: // Bowser
             // ROM       RAM         Kart *Unknown*
float32 0.0  // $000E3874 $800E2C74 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3878 $800E2C78 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E387C $800E2C7C - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3880 $800E2C80 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3884 $800E2C84 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3888 $800E2C88 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E388C $800E2C8C - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.04 // $000E3890 $800E2C90 - Kart *Unknown* (IEEE32) (0.02: $3D23D70A)
float32 0.04 // $000E3894 $800E2C94 - Kart *Unknown* (IEEE32) (0.02: $3D23D70A)
float32 0.0  // $000E3898 $800E2C98 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E389C $800E2C9C - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.04 // $000E38A0 $800E2CA0 - Kart *Unknown* (IEEE32) (0.02: $3D23D70A)
float32 0.0  // $000E38A4 $800E2CA4 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.04 // $000E38A8 $800E2CA8 - Kart *Unknown* (IEEE32) (0.02: $3D23D70A)
float32 0.04 // $000E38AC $800E2CAC - Kart *Unknown* (IEEE32) (0.02: $3D23D70A)


KartUnknown41: // Mario
             // ROM       RAM         Kart *Unknown*
float32 0.0  // $000E38B0 $800E2CB0 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E38B4 $800E2CB4 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E38B8 $800E2CB8 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.03 // $000E38BC $800E2CBC - Kart *Unknown* (IEEE32) (0.03: $3CF5C28F)
float32 0.0  // $000E38C0 $800E2CC0 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E38C4 $800E2CC4 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E38C8 $800E2CC8 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.09 // $000E38CC $800E2CCC - Kart *Unknown* (IEEE32) (0.09: $3DB851EC)
float32 0.09 // $000E38D0 $800E2CD0 - Kart *Unknown* (IEEE32) (0.09: $3DB851EC)
float32 0.0  // $000E38D4 $800E2CD4 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E38D8 $800E2CD8 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.09 // $000E38DC $800E2CDC - Kart *Unknown* (IEEE32) (0.09: $3DB851EC)
float32 0.0  // $000E38E0 $800E2CE0 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.09 // $000E38E4 $800E2CE4 - Kart *Unknown* (IEEE32) (0.09: $3DB851EC)
float32 0.09 // $000E38E8 $800E2CE8 - Kart *Unknown* (IEEE32) (0.09: $3DB851EC)

KartUnknown42: // Luigi
             // ROM       RAM         Kart *Unknown*
float32 0.0  // $000E38EC $800E2CEC - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E38F0 $800E2CF0 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E38F4 $800E2CF4 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.03 // $000E38F8 $800E2CF8 - Kart *Unknown* (IEEE32) (0.03: $3CF5C28F)
float32 0.0  // $000E38FC $800E2CFC - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3900 $800E2D00 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3904 $800E2D04 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.09 // $000E3908 $800E2D08 - Kart *Unknown* (IEEE32) (0.09: $3DB851EC)
float32 0.09 // $000E390C $800E2D0C - Kart *Unknown* (IEEE32) (0.09: $3DB851EC)
float32 0.0  // $000E3910 $800E2D10 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3914 $800E2D14 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.09 // $000E3918 $800E2D18 - Kart *Unknown* (IEEE32) (0.09: $3DB851EC)
float32 0.0  // $000E391C $800E2D1C - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.09 // $000E3920 $800E2D20 - Kart *Unknown* (IEEE32) (0.09: $3DB851EC)
float32 0.09 // $000E3924 $800E2D24 - Kart *Unknown* (IEEE32) (0.09: $3DB851EC)

KartUnknown43: // Yoshi
             // ROM       RAM         Kart *Unknown*
float32 0.0  // $000E3928 $800E2D28 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E392C $800E2D2C - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3930 $800E2D30 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.02 // $000E3934 $800E2D34 - Kart *Unknown* (IEEE32) (0.02: $3CA3D70A)
float32 0.0  // $000E3938 $800E2D38 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E393C $800E2D3C - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3940 $800E2D40 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.08 // $000E3944 $800E2D44 - Kart *Unknown* (IEEE32) (0.08: $3DA3D70A)
float32 0.08 // $000E3948 $800E2D48 - Kart *Unknown* (IEEE32) (0.08: $3DA3D70A)
float32 0.0  // $000E394C $800E2D4C - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3950 $800E2D50 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.08 // $000E3954 $800E2D54 - Kart *Unknown* (IEEE32) (0.08: $3DA3D70A)
float32 0.0  // $000E3958 $800E2D58 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.08 // $000E395C $800E2D5C - Kart *Unknown* (IEEE32) (0.08: $3DA3D70A)
float32 0.08 // $000E3960 $800E2D60 - Kart *Unknown* (IEEE32) (0.08: $3DA3D70A)

KartUnknown44: // Toad
             // ROM       RAM         Kart *Unknown*
float32 0.0  // $000E3964 $800E2D64 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3968 $800E2D68 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E396C $800E2D6C - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.02 // $000E3970 $800E2D70 - Kart *Unknown* (IEEE32) (0.02: $3CA3D70A)
float32 0.0  // $000E3974 $800E2D74 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3978 $800E2D78 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E397C $800E2D7C - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.08 // $000E3980 $800E2D80 - Kart *Unknown* (IEEE32) (0.08: $3DA3D70A)
float32 0.08 // $000E3984 $800E2D84 - Kart *Unknown* (IEEE32) (0.08: $3DA3D70A)
float32 0.0  // $000E3988 $800E2D88 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E398C $800E2D8C - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.08 // $000E3990 $800E2D90 - Kart *Unknown* (IEEE32) (0.08: $3DA3D70A)
float32 0.0  // $000E3994 $800E2D94 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.08 // $000E3998 $800E2D98 - Kart *Unknown* (IEEE32) (0.08: $3DA3D70A)
float32 0.08 // $000E399C $800E2D9C - Kart *Unknown* (IEEE32) (0.08: $3DA3D70A)

KartUnknown45: // D.K.
             // ROM       RAM         Kart *Unknown*
float32 0.0  // $000E39A0 $800E2DA0 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E39A4 $800E2DA4 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E39A8 $800E2DA8 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.04 // $000E39AC $800E2DAC - Kart *Unknown* (IEEE32) (0.04: $3D23D70A)
float32 0.0  // $000E39B0 $800E2DB0 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E39B4 $800E2DB4 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E39B8 $800E2DB8 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.1  // $000E39BC $800E2DBC - Kart *Unknown* (IEEE32) (0.1:  $3DCCCCCD)
float32 0.1  // $000E39C0 $800E2DC0 - Kart *Unknown* (IEEE32) (0.1:  $3DCCCCCD)
float32 0.0  // $000E39C4 $800E2DC4 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E39C8 $800E2DC8 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.1  // $000E39CC $800E2DCC - Kart *Unknown* (IEEE32) (0.1:  $3DCCCCCD)
float32 0.0  // $000E39D0 $800E2DD0 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.1  // $000E39D4 $800E2DD4 - Kart *Unknown* (IEEE32) (0.1:  $3DCCCCCD)
float32 0.1  // $000E39D8 $800E2DD8 - Kart *Unknown* (IEEE32) (0.1:  $3DCCCCCD)

KartUnknown46: // Wario
             // ROM       RAM         Kart *Unknown*
float32 0.0  // $000E39DC $800E2DDC - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E39E0 $800E2DE0 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E39E4 $800E2DE4 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.04 // $000E39E8 $800E2DE8 - Kart *Unknown* (IEEE32) (0.04: $3D23D70A)
float32 0.0  // $000E39EC $800E2DEC - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E39F0 $800E2DF0 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E39F4 $800E2DF4 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.1  // $000E39F8 $800E2DF8 - Kart *Unknown* (IEEE32) (0.1:  $3DCCCCCD)
float32 0.1  // $000E39FC $800E2DFC - Kart *Unknown* (IEEE32) (0.1:  $3DCCCCCD)
float32 0.0  // $000E3A00 $800E2E00 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3A04 $800E2E04 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.1  // $000E3A08 $800E2E08 - Kart *Unknown* (IEEE32) (0.1:  $3DCCCCCD)
float32 0.0  // $000E3A0C $800E2E0C - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.1  // $000E3A10 $800E2E10 - Kart *Unknown* (IEEE32) (0.1:  $3DCCCCCD)
float32 0.1  // $000E3A14 $800E2E14 - Kart *Unknown* (IEEE32) (0.1:  $3DCCCCCD)

KartUnknown47: // Peach
             // ROM       RAM         Kart *Unknown*
float32 0.0  // $000E3A18 $800E2E18 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3A1C $800E2E1C - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3A20 $800E2E20 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.02 // $000E3A24 $800E2E24 - Kart *Unknown* (IEEE32) (0.02: $3CA3D70A)
float32 0.0  // $000E3A28 $800E2E28 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3A2C $800E2E2C - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3A30 $800E2E30 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.08 // $000E3A34 $800E2E34 - Kart *Unknown* (IEEE32) (0.08: $3DA3D70A)
float32 0.08 // $000E3A38 $800E2E38 - Kart *Unknown* (IEEE32) (0.08: $3DA3D70A)
float32 0.0  // $000E3A3C $800E2E3C - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3A40 $800E2E40 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.08 // $000E3A44 $800E2E44 - Kart *Unknown* (IEEE32) (0.08: $3DA3D70A)
float32 0.0  // $000E3A48 $800E2E48 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.08 // $000E3A4C $800E2E4C - Kart *Unknown* (IEEE32) (0.08: $3DA3D70A)
float32 0.08 // $000E3A50 $800E2E50 - Kart *Unknown* (IEEE32) (0.08: $3DA3D70A)

KartUnknown48: // Bowser
             // ROM       RAM         Kart *Unknown*
float32 0.0  // $000E3A54 $800E2E54 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3A58 $800E2E58 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3A5C $800E2E5C - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.04 // $000E3A60 $800E2E60 - Kart *Unknown* (IEEE32) (0.04: $3D23D70A)
float32 0.0  // $000E3A64 $800E2E64 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3A68 $800E2E68 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3A6C $800E2E6C - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.1  // $000E3A70 $800E2E70 - Kart *Unknown* (IEEE32) (0.1:  $3DCCCCCD)
float32 0.1  // $000E3A74 $800E2E74 - Kart *Unknown* (IEEE32) (0.1:  $3DCCCCCD)
float32 0.0  // $000E3A78 $800E2E78 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.0  // $000E3A7C $800E2E7C - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.1  // $000E3A80 $800E2E80 - Kart *Unknown* (IEEE32) (0.1:  $3DCCCCCD)
float32 0.0  // $000E3A84 $800E2E84 - Kart *Unknown* (IEEE32) (0.0:  $00000000)
float32 0.1  // $000E3A88 $800E2E88 - Kart *Unknown* (IEEE32) (0.1:  $3DCCCCCD)
float32 0.1  // $000E3A8C $800E2E8C - Kart *Unknown* (IEEE32) (0.1:  $3DCCCCCD)

                 // ROM       RAM         Offsets To IEEE32 Tables Above
dw KartUnknown41 // $000E3A90 $800E2E90 - Kart *Unknown* Mario  (UINT32) ($800E2CB0)
dw KartUnknown42 // $000E3A94 $800E2E94 - Kart *Unknown* Luigi  (UINT32) ($800E2CEC)
dw KartUnknown43 // $000E3A98 $800E2E98 - Kart *Unknown* Yoshi  (UINT32) ($800E2D28)
dw KartUnknown44 // $000E3A9C $800E2E9C - Kart *Unknown* Toad   (UINT32) ($800E2D64)
dw KartUnknown45 // $000E3AA0 $800E2EA0 - Kart *Unknown* D.K.   (UINT32) ($800E2DA0)
dw KartUnknown46 // $000E3AA4 $800E2EA4 - Kart *Unknown* Wario  (UINT32) ($800E2DDC)
dw KartUnknown47 // $000E3AA8 $800E2EA8 - Kart *Unknown* Peach  (UINT32) ($800E2E18)
dw KartUnknown48 // $000E3AAC $800E2EAC - Kart *Unknown* Bowser (UINT32) ($800E2E54)

                 // ROM       RAM         Offsets To IEEE32 Tables Above
dw KartUnknown33 // $000E3AB0 $800E2EB0 - Kart *Unknown* Mario  (UINT32) ($800E2AD0)
dw KartUnknown34 // $000E3AB4 $800E2EB4 - Kart *Unknown* Luigi  (UINT32) ($800E2B0C)
dw KartUnknown35 // $000E3AB8 $800E2EB8 - Kart *Unknown* Yoshi  (UINT32) ($800E2B48)
dw KartUnknown36 // $000E3ABC $800E2EBC - Kart *Unknown* Toad   (UINT32) ($800E2B84)
dw KartUnknown37 // $000E3AC0 $800E2EC0 - Kart *Unknown* D.K.   (UINT32) ($800E2BC0)
dw KartUnknown38 // $000E3AC4 $800E2EC4 - Kart *Unknown* Wario  (UINT32) ($800E2BFC)
dw KartUnknown39 // $000E3AC8 $800E2EC8 - Kart *Unknown* Peach  (UINT32) ($800E2C38)
dw KartUnknown40 // $000E3ACC $800E2ECC - Kart *Unknown* Bowser (UINT32) ($800E2C74)


KartAccelerationMario:
            // ROM       RAM         Kart Acceleration Mario
float32 2.0 // $000E3AD0 $800E2ED0 - Kart Acceleration Mario (IEEE32) (2.0: $40000000)
float32 2.0 // $000E3AD4 $800E2ED4 - Kart Acceleration Mario (IEEE32) (2.0: $40000000)
float32 2.0 // $000E3AD8 $800E2ED8 - Kart Acceleration Mario (IEEE32) (2.0: $40000000)
float32 1.6 // $000E3ADC $800E2EDC - Kart Acceleration Mario (IEEE32) (1.6: $3FCCCCCD)
float32 1.4 // $000E3AE0 $800E2EE0 - Kart Acceleration Mario (IEEE32) (1.4: $3FB33333)
float32 1.2 // $000E3AE4 $800E2EE4 - Kart Acceleration Mario (IEEE32) (1.2: $3F99999A)
float32 1.0 // $000E3AE8 $800E2EE8 - Kart Acceleration Mario (IEEE32) (1.0: $3F800000)
float32 0.8 // $000E3AEC $800E2EEC - Kart Acceleration Mario (IEEE32) (0.8: $3F4CCCCD)
float32 0.6 // $000E3AF0 $800E2EF0 - Kart Acceleration Mario (IEEE32) (0.6: $3F19999A)
float32 0.4 // $000E3AF4 $800E2EF4 - Kart Acceleration Mario (IEEE32) (0.4: $3ECCCCCD)

KartAccelerationLuigi:
            // ROM       RAM         Kart Acceleration Luigi
float32 2.0 // $000E3AF8 $800E2EF8 - Kart Acceleration Luigi (IEEE32) (2.0: $40000000)
float32 2.0 // $000E3AFC $800E2EFC - Kart Acceleration Luigi (IEEE32) (2.0: $40000000)
float32 2.0 // $000E3B00 $800E2F00 - Kart Acceleration Luigi (IEEE32) (2.0: $40000000)
float32 1.6 // $000E3B04 $800E2F04 - Kart Acceleration Luigi (IEEE32) (1.6: $3FCCCCCD)
float32 1.4 // $000E3B08 $800E2F08 - Kart Acceleration Luigi (IEEE32) (1.4: $3FB33333)
float32 1.2 // $000E3B0C $800E2F0C - Kart Acceleration Luigi (IEEE32) (1.2: $3F99999A)
float32 1.0 // $000E3B10 $800E2F10 - Kart Acceleration Luigi (IEEE32) (1.0: $3F800000)
float32 0.8 // $000E3B14 $800E2F14 - Kart Acceleration Luigi (IEEE32) (0.8: $3F4CCCCD)
float32 0.6 // $000E3B18 $800E2F18 - Kart Acceleration Luigi (IEEE32) (0.6: $3F19999A)
float32 0.4 // $000E3B1C $800E2F1C - Kart Acceleration Luigi (IEEE32) (0.4: $3ECCCCCD)

KartAccelerationYoshi:
            // ROM       RAM         Kart Acceleration Yoshi
float32 2.0 // $000E3B20 $800E2F20 - Kart Acceleration Yoshi (IEEE32) (2.0: $40000000)
float32 2.0 // $000E3B24 $800E2F24 - Kart Acceleration Yoshi (IEEE32) (2.0: $40000000)
float32 2.5 // $000E3B28 $800E2F28 - Kart Acceleration Yoshi (IEEE32) (2.5: $40200000)
float32 2.6 // $000E3B2C $800E2F2C - Kart Acceleration Yoshi (IEEE32) (2.6: $40266666)
float32 2.6 // $000E3B30 $800E2F30 - Kart Acceleration Yoshi (IEEE32) (2.6: $40266666)
float32 2.0 // $000E3B34 $800E2F34 - Kart Acceleration Yoshi (IEEE32) (2.0: $40000000)
float32 1.5 // $000E3B38 $800E2F38 - Kart Acceleration Yoshi (IEEE32) (1.5: $3FC00000)
float32 0.8 // $000E3B3C $800E2F3C - Kart Acceleration Yoshi (IEEE32) (0.8: $3F4CCCCD)
float32 0.8 // $000E3B40 $800E2F40 - Kart Acceleration Yoshi (IEEE32) (0.8: $3F4CCCCD)
float32 0.8 // $000E3B44 $800E2F44 - Kart Acceleration Yoshi (IEEE32) (0.8: $3F4CCCCD)

KartAccelerationToad:
            // ROM       RAM         Kart Acceleration Toad
float32 2.0 // $000E3B48 $800E2F48 - Kart Acceleration Toad (IEEE32) (2.0: $40000000)
float32 2.0 // $000E3B4C $800E2F4C - Kart Acceleration Toad (IEEE32) (2.0: $40000000)
float32 2.5 // $000E3B50 $800E2F50 - Kart Acceleration Toad (IEEE32) (2.5: $40200000)
float32 2.6 // $000E3B54 $800E2F54 - Kart Acceleration Toad (IEEE32) (2.6: $40266666)
float32 2.6 // $000E3B58 $800E2F58 - Kart Acceleration Toad (IEEE32) (2.6: $40266666)
float32 2.0 // $000E3B5C $800E2F5C - Kart Acceleration Toad (IEEE32) (2.0: $40000000)
float32 1.5 // $000E3B60 $800E2F60 - Kart Acceleration Toad (IEEE32) (1.5: $3FC00000)
float32 0.8 // $000E3B64 $800E2F64 - Kart Acceleration Toad (IEEE32) (0.8: $3F4CCCCD)
float32 0.8 // $000E3B68 $800E2F68 - Kart Acceleration Toad (IEEE32) (0.8: $3F4CCCCD)
float32 0.8 // $000E3B6C $800E2F6C - Kart Acceleration Toad (IEEE32) (0.8: $3F4CCCCD)

KartAccelerationDK:
            // ROM       RAM         Kart Acceleration D.K.
float32 2.0 // $000E3B70 $800E2F70 - Kart Acceleration D.K. (IEEE32) (2.0: $40000000)
float32 2.0 // $000E3B74 $800E2F74 - Kart Acceleration D.K. (IEEE32) (2.0: $40000000)
float32 2.0 // $000E3B78 $800E2F78 - Kart Acceleration D.K. (IEEE32) (2.0: $40000000)
float32 1.6 // $000E3B7C $800E2F7C - Kart Acceleration D.K. (IEEE32) (1.6: $3FCCCCCD)
float32 1.0 // $000E3B80 $800E2F80 - Kart Acceleration D.K. (IEEE32) (1.0: $3F800000)
float32 1.0 // $000E3B84 $800E2F84 - Kart Acceleration D.K. (IEEE32) (1.0: $3F800000)
float32 1.0 // $000E3B88 $800E2F88 - Kart Acceleration D.K. (IEEE32) (1.0: $3F800000)
float32 1.8 // $000E3B8C $800E2F8C - Kart Acceleration D.K. (IEEE32) (1.8: $3FE66666)
float32 1.8 // $000E3B90 $800E2F90 - Kart Acceleration D.K. (IEEE32) (1.8: $3FE66666)
float32 1.2 // $000E3B94 $800E2F94 - Kart Acceleration D.K. (IEEE32) (1.2: $3F99999A)

KartAccelerationWario:
            // ROM       RAM         Kart Acceleration Wario
float32 2.0 // $000E3B98 $800E2F98 - Kart Acceleration Wario (IEEE32) (2.0: $40000000)
float32 2.0 // $000E3B9C $800E2F9C - Kart Acceleration Wario (IEEE32) (2.0: $40000000)
float32 2.0 // $000E3BA0 $800E2FA0 - Kart Acceleration Wario (IEEE32) (2.0: $40000000)
float32 1.6 // $000E3BA4 $800E2FA4 - Kart Acceleration Wario (IEEE32) (1.6: $3FCCCCCD)
float32 1.0 // $000E3BA8 $800E2FA8 - Kart Acceleration Wario (IEEE32) (1.0: $3F800000)
float32 1.0 // $000E3BAC $800E2FAC - Kart Acceleration Wario (IEEE32) (1.0: $3F800000)
float32 1.0 // $000E3BB0 $800E2FB0 - Kart Acceleration Wario (IEEE32) (1.0: $3F800000)
float32 1.8 // $000E3BB4 $800E2FB4 - Kart Acceleration Wario (IEEE32) (1.8: $3FE66666)
float32 1.8 // $000E3BB8 $800E2FB8 - Kart Acceleration Wario (IEEE32) (1.8: $3FE66666)
float32 1.2 // $000E3BBC $800E2FBC - Kart Acceleration Wario (IEEE32) (1.2: $3F99999A)

KartAccelerationPeach:
            // ROM       RAM         Kart Acceleration Peach
float32 2.0 // $000E3BC0 $800E2FC0 - Kart Acceleration Peach (IEEE32) (2.0: $40000000)
float32 2.0 // $000E3BC4 $800E2FC4 - Kart Acceleration Peach (IEEE32) (2.0: $40000000)
float32 2.5 // $000E3BC8 $800E2FC8 - Kart Acceleration Peach (IEEE32) (2.5: $40200000)
float32 2.6 // $000E3BCC $800E2FCC - Kart Acceleration Peach (IEEE32) (2.6: $40266666)
float32 2.6 // $000E3BD0 $800E2FD0 - Kart Acceleration Peach (IEEE32) (2.6: $40266666)
float32 2.0 // $000E3BD4 $800E2FD4 - Kart Acceleration Peach (IEEE32) (2.0: $40000000)
float32 1.5 // $000E3BD8 $800E2FD8 - Kart Acceleration Peach (IEEE32) (1.5: $3FC00000)
float32 0.8 // $000E3BDC $800E2FDC - Kart Acceleration Peach (IEEE32) (0.8: $3F4CCCCD)
float32 0.8 // $000E3BE0 $800E2FE0 - Kart Acceleration Peach (IEEE32) (0.8: $3F4CCCCD)
float32 0.8 // $000E3BE4 $800E2FE4 - Kart Acceleration Peach (IEEE32) (0.8: $3F4CCCCD)

KartAccelerationBowser:
            // ROM       RAM         Kart Acceleration Bowser
float32 2.0 // $000E3BE8 $800E2FE8 - Kart Acceleration Bowser (IEEE32) (2.0: $40000000)
float32 2.0 // $000E3BEC $800E2FEC - Kart Acceleration Bowser (IEEE32) (2.0: $40000000)
float32 2.0 // $000E3BF0 $800E2FF0 - Kart Acceleration Bowser (IEEE32) (2.0: $40000000)
float32 1.6 // $000E3BF4 $800E2FF4 - Kart Acceleration Bowser (IEEE32) (1.6: $3FCCCCCD)
float32 1.0 // $000E3BF8 $800E2FF8 - Kart Acceleration Bowser (IEEE32) (1.0: $3F800000)
float32 1.0 // $000E3BFC $800E2FFC - Kart Acceleration Bowser (IEEE32) (1.0: $3F800000)
float32 1.0 // $000E3C00 $800E3000 - Kart Acceleration Bowser (IEEE32) (1.0: $3F800000)
float32 1.8 // $000E3C04 $800E3004 - Kart Acceleration Bowser (IEEE32) (1.8: $3FE66666)
float32 1.8 // $000E3C08 $800E3008 - Kart Acceleration Bowser (IEEE32) (1.8: $3FE66666)
float32 1.2 // $000E3C0C $800E300C - Kart Acceleration Bowser (IEEE32) (1.2: $3F99999A)

                          // ROM       RAM         Offsets To IEEE32 Acceleration Tables Above
dw KartAccelerationMario  // $000E3C10 $800E3010 - Kart Acceleration Mario  (UINT32) ($800E2ED0)
dw KartAccelerationLuigi  // $000E3C14 $800E3014 - Kart Acceleration Luigi  (UINT32) ($800E2EF8)
dw KartAccelerationYoshi  // $000E3C18 $800E3018 - Kart Acceleration Yoshi  (UINT32) ($800E2F20)
dw KartAccelerationToad   // $000E3C1C $800E301C - Kart Acceleration Toad   (UINT32) ($800E2F48)
dw KartAccelerationDK     // $000E3C20 $800E3020 - Kart Acceleration D.K.   (UINT32) ($800E2F70)
dw KartAccelerationWario  // $000E3C24 $800E3024 - Kart Acceleration Wario  (UINT32) ($800E2F98)
dw KartAccelerationPeach  // $000E3C28 $800E3028 - Kart Acceleration Peach  (UINT32) ($800E2FC0)
dw KartAccelerationBowser // $000E3C2C $800E302C - Kart Acceleration Bowser (UINT32) ($800E2FE8)


KartUnknown49: // Mario
            // ROM       RAM         Kart *Unknown*
float32 0.0 // $000E3C30 $800E3030 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3C34 $800E3034 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.2 // $000E3C38 $800E3038 - Kart *Unknown* (IEEE32) (0.2: $3E4CCCCD)
float32 0.2 // $000E3C3C $800E303C - Kart *Unknown* (IEEE32) (0.2: $3E4CCCCD)
float32 0.0 // $000E3C40 $800E3040 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.4 // $000E3C44 $800E3044 - Kart *Unknown* (IEEE32) (0.4: $3ECCCCCD)
float32 0.1 // $000E3C48 $800E3048 - Kart *Unknown* (IEEE32) (0.1: $3DCCCCCD)
float32 0.2 // $000E3C4C $800E304C - Kart *Unknown* (IEEE32) (0.2: $3E4CCCCD)
float32 0.2 // $000E3C50 $800E3050 - Kart *Unknown* (IEEE32) (0.2: $3E4CCCCD)
float32 0.0 // $000E3C54 $800E3054 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3C58 $800E3058 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3C5C $800E305C - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3C60 $800E3060 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3C64 $800E3064 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3C68 $800E3068 - Kart *Unknown* (IEEE32) (0.0: $00000000)

KartUnknown50: // Luigi
            // ROM       RAM         Kart *Unknown*
float32 0.0 // $000E3C6C $800E306C - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3C70 $800E3070 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.2 // $000E3C74 $800E3074 - Kart *Unknown* (IEEE32) (0.2: $3E4CCCCD)
float32 0.2 // $000E3C78 $800E3078 - Kart *Unknown* (IEEE32) (0.2: $3E4CCCCD)
float32 0.0 // $000E3C7C $800E307C - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.4 // $000E3C80 $800E3080 - Kart *Unknown* (IEEE32) (0.4: $3ECCCCCD)
float32 0.1 // $000E3C84 $800E3084 - Kart *Unknown* (IEEE32) (0.1: $3DCCCCCD)
float32 0.2 // $000E3C88 $800E3088 - Kart *Unknown* (IEEE32) (0.2: $3E4CCCCD)
float32 0.2 // $000E3C8C $800E308C - Kart *Unknown* (IEEE32) (0.2: $3E4CCCCD)
float32 0.0 // $000E3C90 $800E3090 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3C94 $800E3094 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3C98 $800E3098 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3C9C $800E309C - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3CA0 $800E30A0 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3CA4 $800E30A4 - Kart *Unknown* (IEEE32) (0.0: $00000000)

KartUnknown51: // Yoshi
            // ROM       RAM         Kart *Unknown*
float32 0.0 // $000E3CA8 $800E30A8 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3CAC $800E30AC - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.2 // $000E3CB0 $800E30B0 - Kart *Unknown* (IEEE32) (0.2: $3E4CCCCD)
float32 0.2 // $000E3CB4 $800E30B4 - Kart *Unknown* (IEEE32) (0.2: $3E4CCCCD)
float32 0.0 // $000E3CB8 $800E30B8 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.4 // $000E3CBC $800E30BC - Kart *Unknown* (IEEE32) (0.4: $3ECCCCCD)
float32 0.1 // $000E3CC0 $800E30C0 - Kart *Unknown* (IEEE32) (0.1: $3DCCCCCD)
float32 0.2 // $000E3CC4 $800E30C4 - Kart *Unknown* (IEEE32) (0.2: $3E4CCCCD)
float32 0.2 // $000E3CC8 $800E30C8 - Kart *Unknown* (IEEE32) (0.2: $3E4CCCCD)
float32 0.0 // $000E3CCC $800E30CC - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3CD0 $800E30D0 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3CD4 $800E30D4 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3CD8 $800E30D8 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3CDC $800E30DC - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3CE0 $800E30E0 - Kart *Unknown* (IEEE32) (0.0: $00000000)

KartUnknown52: // Toad
            // ROM       RAM         Kart *Unknown*
float32 0.0 // $000E3CE4 $800E30E4 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3CE8 $800E30E8 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.2 // $000E3CEC $800E30EC - Kart *Unknown* (IEEE32) (0.2: $3E4CCCCD)
float32 0.2 // $000E3CF0 $800E30F0 - Kart *Unknown* (IEEE32) (0.2: $3E4CCCCD)
float32 0.0 // $000E3CF4 $800E30F4 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.4 // $000E3CF8 $800E30F8 - Kart *Unknown* (IEEE32) (0.4: $3ECCCCCD)
float32 0.1 // $000E3CFC $800E30FC - Kart *Unknown* (IEEE32) (0.1: $3DCCCCCD)
float32 0.2 // $000E3D00 $800E3100 - Kart *Unknown* (IEEE32) (0.2: $3E4CCCCD)
float32 0.2 // $000E3D04 $800E3104 - Kart *Unknown* (IEEE32) (0.2: $3E4CCCCD)
float32 0.0 // $000E3D08 $800E3108 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3D0C $800E310C - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3D10 $800E3110 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3D14 $800E3114 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3D18 $800E3118 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3D1C $800E311C - Kart *Unknown* (IEEE32) (0.0: $00000000)

KartUnknown53: // D.K.
            // ROM       RAM         Kart *Unknown*
float32 0.0 // $000E3D20 $800E3120 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3D24 $800E3124 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.2 // $000E3D28 $800E3128 - Kart *Unknown* (IEEE32) (0.2: $3E4CCCCD)
float32 0.2 // $000E3D2C $800E312C - Kart *Unknown* (IEEE32) (0.2: $3E4CCCCD)
float32 0.0 // $000E3D30 $800E3130 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.4 // $000E3D34 $800E3134 - Kart *Unknown* (IEEE32) (0.4: $3ECCCCCD)
float32 0.1 // $000E3D38 $800E3138 - Kart *Unknown* (IEEE32) (0.1: $3DCCCCCD)
float32 0.2 // $000E3D3C $800E313C - Kart *Unknown* (IEEE32) (0.2: $3E4CCCCD)
float32 0.2 // $000E3D40 $800E3140 - Kart *Unknown* (IEEE32) (0.2: $3E4CCCCD)
float32 0.0 // $000E3D44 $800E3144 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3D48 $800E3148 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3D4C $800E314C - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3D50 $800E3150 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3D54 $800E3154 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3D58 $800E3158 - Kart *Unknown* (IEEE32) (0.0: $00000000)

KartUnknown54: // Wario
            // ROM       RAM         Kart *Unknown*
float32 0.0 // $000E3D5C $800E315C - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3D60 $800E3160 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.2 // $000E3D64 $800E3164 - Kart *Unknown* (IEEE32) (0.2: $3E4CCCCD)
float32 0.2 // $000E3D68 $800E3168 - Kart *Unknown* (IEEE32) (0.2: $3E4CCCCD)
float32 0.0 // $000E3D6C $800E316C - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.4 // $000E3D70 $800E3170 - Kart *Unknown* (IEEE32) (0.4: $3ECCCCCD)
float32 0.1 // $000E3D74 $800E3174 - Kart *Unknown* (IEEE32) (0.1: $3DCCCCCD)
float32 0.2 // $000E3D78 $800E3178 - Kart *Unknown* (IEEE32) (0.2: $3E4CCCCD)
float32 0.2 // $000E3D7C $800E317C - Kart *Unknown* (IEEE32) (0.2: $3E4CCCCD)
float32 0.0 // $000E3D80 $800E3180 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3D84 $800E3184 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3D88 $800E3188 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3D8C $800E318C - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3D90 $800E3190 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3D94 $800E3194 - Kart *Unknown* (IEEE32) (0.0: $00000000)

KartUnknown55: // Peach
            // ROM       RAM         Kart *Unknown*
float32 0.0 // $000E3D98 $800E3198 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3D9C $800E319C - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.2 // $000E3DA0 $800E31A0 - Kart *Unknown* (IEEE32) (0.2: $3E4CCCCD)
float32 0.2 // $000E3DA4 $800E31A4 - Kart *Unknown* (IEEE32) (0.2: $3E4CCCCD)
float32 0.0 // $000E3DA8 $800E31A8 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.4 // $000E3DAC $800E31AC - Kart *Unknown* (IEEE32) (0.4: $3ECCCCCD)
float32 0.1 // $000E3DB0 $800E31B0 - Kart *Unknown* (IEEE32) (0.1: $3DCCCCCD)
float32 0.2 // $000E3DB4 $800E31B4 - Kart *Unknown* (IEEE32) (0.2: $3E4CCCCD)
float32 0.2 // $000E3DB8 $800E31B8 - Kart *Unknown* (IEEE32) (0.2: $3E4CCCCD)
float32 0.0 // $000E3DBC $800E31BC - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3DC0 $800E31C0 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3DC4 $800E31C4 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3DC8 $800E31C8 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3DCC $800E31CC - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3DD0 $800E31D0 - Kart *Unknown* (IEEE32) (0.0: $00000000)

KartUnknown56: // Bowser
            // ROM       RAM         Kart *Unknown*
float32 0.0 // $000E3DD4 $800E31D4 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3DD8 $800E31D8 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.2 // $000E3DDC $800E31DC - Kart *Unknown* (IEEE32) (0.2: $3E4CCCCD)
float32 0.2 // $000E3DE0 $800E31E0 - Kart *Unknown* (IEEE32) (0.2: $3E4CCCCD)
float32 0.0 // $000E3DE4 $800E31E4 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.4 // $000E3DE8 $800E31E8 - Kart *Unknown* (IEEE32) (0.4: $3ECCCCCD)
float32 0.1 // $000E3DEC $800E31EC - Kart *Unknown* (IEEE32) (0.1: $3DCCCCCD)
float32 0.2 // $000E3DF0 $800E31F0 - Kart *Unknown* (IEEE32) (0.2: $3E4CCCCD)
float32 0.2 // $000E3DF4 $800E31F4 - Kart *Unknown* (IEEE32) (0.2: $3E4CCCCD)
float32 0.0 // $000E3DF8 $800E31F8 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3DFC $800E31FC - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3E00 $800E3200 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3E04 $800E3204 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3E08 $800E3208 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3E0C $800E320C - Kart *Unknown* (IEEE32) (0.0: $00000000)

                 // ROM       RAM         Offsets To IEEE32 Tables Above
dw KartUnknown49 // $000E3E10 $800E3210 - Kart *Unknown* Mario  (UINT32) ($800E3030)
dw KartUnknown50 // $000E3E14 $800E3214 - Kart *Unknown* Luigi  (UINT32) ($800E306C)
dw KartUnknown51 // $000E3E18 $800E3218 - Kart *Unknown* Yoshi  (UINT32) ($800E30A8)
dw KartUnknown52 // $000E3E1C $800E321C - Kart *Unknown* Toad   (UINT32) ($800E30E4)
dw KartUnknown53 // $000E3E20 $800E3220 - Kart *Unknown* D.K.   (UINT32) ($800E3120)
dw KartUnknown54 // $000E3E24 $800E3224 - Kart *Unknown* Wario  (UINT32) ($800E315C)
dw KartUnknown55 // $000E3E28 $800E3228 - Kart *Unknown* Peach  (UINT32) ($800E3198)
dw KartUnknown56 // $000E3E2C $800E322C - Kart *Unknown* Bowser (UINT32) ($800E31D4)


KartUnknown57: // Mario
            // ROM       RAM         Kart *Unknown*
float32 0.0 // $000E3E30 $800E3230 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3E34 $800E3234 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3E38 $800E3238 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3E3C $800E323C - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3E40 $800E3240 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3E44 $800E3244 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3E48 $800E3248 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3E4C $800E324C - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3E50 $800E3250 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3E54 $800E3254 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3E58 $800E3258 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3E5C $800E325C - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3E60 $800E3260 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3E64 $800E3264 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3E68 $800E3268 - Kart *Unknown* (IEEE32) (0.0: $00000000)

KartUnknown58: // Luigi
            // ROM       RAM         Kart *Unknown*
float32 0.0 // $000E3E6C $800E326C - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3E70 $800E3270 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3E74 $800E3274 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3E78 $800E3278 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3E7C $800E327C - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3E80 $800E3280 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3E84 $800E3284 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3E88 $800E3288 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3E8C $800E328C - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3E90 $800E3290 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3E94 $800E3294 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3E98 $800E3298 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3E9C $800E329C - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3EA0 $800E32A0 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3EA4 $800E32A4 - Kart *Unknown* (IEEE32) (0.0: $00000000)

KartUnknown59: // Yoshi
            // ROM       RAM         Kart *Unknown*
float32 0.0 // $000E3EA8 $800E32A8 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3EAC $800E32AC - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3EB0 $800E32B0 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3EB4 $800E32B4 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3EB8 $800E32B8 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3EBC $800E32BC - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3EC0 $800E32C0 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3EC4 $800E32C4 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3EC8 $800E32C8 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3ECC $800E32CC - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3ED0 $800E32D0 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3ED4 $800E32D4 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3ED8 $800E32D8 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3EDC $800E32DC - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3EE0 $800E32E0 - Kart *Unknown* (IEEE32) (0.0: $00000000)

KartUnknown60: // Toad
            // ROM       RAM         Kart *Unknown*
float32 0.0 // $000E3EE4 $800E32E4 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3EE8 $800E32E8 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3EEC $800E32EC - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3EF0 $800E32F0 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3EF4 $800E32F4 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3EF8 $800E32F8 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3EFC $800E32FC - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3F00 $800E3300 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3F04 $800E3304 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3F08 $800E3308 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3F0C $800E330C - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3F10 $800E3310 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3F14 $800E3314 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3F18 $800E3318 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3F1C $800E331C - Kart *Unknown* (IEEE32) (0.0: $00000000)

KartUnknown61: // D.K.
            // ROM       RAM         Kart *Unknown*
float32 0.0 // $000E3F20 $800E3320 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3F24 $800E3324 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3F28 $800E3328 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3F2C $800E332C - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3F30 $800E3330 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3F34 $800E3334 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3F38 $800E3338 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3F3C $800E333C - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3F40 $800E3340 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3F44 $800E3344 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3F48 $800E3348 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3F4C $800E334C - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3F50 $800E3350 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3F54 $800E3354 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3F58 $800E3358 - Kart *Unknown* (IEEE32) (0.0: $00000000)

KartUnknown62: // Wario
            // ROM       RAM         Kart *Unknown*
float32 0.0 // $000E3F5C $800E335C - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3F60 $800E3360 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3F64 $800E3364 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3F68 $800E3368 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3F6C $800E336C - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3F70 $800E3370 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3F74 $800E3374 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3F78 $800E3378 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3F7C $800E337C - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3F80 $800E3380 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3F84 $800E3384 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3F88 $800E3388 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3F8C $800E338C - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3F90 $800E3390 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3F94 $800E3394 - Kart *Unknown* (IEEE32) (0.0: $00000000)

KartUnknown63: // Peach
            // ROM       RAM         Kart *Unknown*
float32 0.0 // $000E3F98 $800E3398 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3F9C $800E339C - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3FA0 $800E33A0 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3FA4 $800E33A4 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3FA8 $800E33A8 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3FAC $800E33AC - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3FB0 $800E33B0 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3FB4 $800E33B4 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3FB8 $800E33B8 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3FBC $800E33BC - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3FC0 $800E33C0 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3FC4 $800E33C4 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3FC8 $800E33C8 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3FCC $800E33CC - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3FD0 $800E33D0 - Kart *Unknown* (IEEE32) (0.0: $00000000)

KartUnknown64: // Bowser
            // ROM       RAM         Kart *Unknown*
float32 0.0 // $000E3FD4 $800E33D4 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3FD8 $800E33D8 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3FDC $800E33DC - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3FE0 $800E33E0 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3FE4 $800E33E4 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3FE8 $800E33E8 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3FEC $800E33EC - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3FF0 $800E33F0 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3FF4 $800E33F4 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3FF8 $800E33F8 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E3FFC $800E33FC - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E4000 $800E3400 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E4004 $800E3404 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E4008 $800E3408 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E400C $800E340C - Kart *Unknown* (IEEE32) (0.0: $00000000)

                 // ROM       RAM         Offsets To IEEE32 Tables Above
dw KartUnknown57 // $000E4010 $800E3410 - Kart *Unknown* Mario  (UINT32) ($800E3230)
dw KartUnknown58 // $000E4014 $800E3414 - Kart *Unknown* Luigi  (UINT32) ($800E326C)
dw KartUnknown59 // $000E4018 $800E3418 - Kart *Unknown* Yoshi  (UINT32) ($800E32A8)
dw KartUnknown60 // $000E401C $800E341C - Kart *Unknown* Toad   (UINT32) ($800E32E4)
dw KartUnknown61 // $000E4020 $800E3420 - Kart *Unknown* D.K.   (UINT32) ($800E3320)
dw KartUnknown62 // $000E4024 $800E3424 - Kart *Unknown* Wario  (UINT32) ($800E335C)
dw KartUnknown63 // $000E4028 $800E3428 - Kart *Unknown* Peach  (UINT32) ($800E3398)
dw KartUnknown64 // $000E402C $800E342C - Kart *Unknown* Bowser (UINT32) ($800E33D4)


KartUnknown65: // Mario
            // ROM       RAM         Kart *Unknown*
float32 0.0 // $000E4030 $800E3430 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E4034 $800E3434 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E4038 $800E3438 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E403C $800E343C - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E4040 $800E3440 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E4044 $800E3444 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E4048 $800E3448 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E404C $800E344C - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E4050 $800E3450 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E4054 $800E3454 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E4058 $800E3458 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E405C $800E345C - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E4060 $800E3460 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E4064 $800E3464 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E4068 $800E3468 - Kart *Unknown* (IEEE32) (0.0: $00000000)

KartUnknown66: // Luigi
            // ROM       RAM         Kart *Unknown*
float32 0.0 // $000E406C $800E346C - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E4070 $800E3470 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E4074 $800E3474 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E4078 $800E3478 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E407C $800E347C - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E4080 $800E3480 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E4084 $800E3484 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E4088 $800E3488 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E408C $800E348C - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E4090 $800E3490 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E4094 $800E3494 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E4098 $800E3498 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E409C $800E349C - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E40A0 $800E34A0 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E40A4 $800E34A4 - Kart *Unknown* (IEEE32) (0.0: $00000000)

KartUnknown67: // Yoshi
            // ROM       RAM         Kart *Unknown*
float32 0.0 // $000E40A8 $800E34A8 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E40AC $800E34AC - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E40B0 $800E34B0 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E40B4 $800E34B4 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E40B8 $800E34B8 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E40BC $800E34BC - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E40C0 $800E34C0 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E40C4 $800E34C4 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E40C8 $800E34C8 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E40CC $800E34CC - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E40D0 $800E34D0 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E40D4 $800E34D4 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E40D8 $800E34D8 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E40DC $800E34DC - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E40E0 $800E34E0 - Kart *Unknown* (IEEE32) (0.0: $00000000)

KartUnknown68: // Toad
            // ROM       RAM         Kart *Unknown*
float32 0.0 // $000E40E4 $800E34E4 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E40E8 $800E34E8 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E40EC $800E34EC - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E40F0 $800E34F0 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E40F4 $800E34F4 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E40F8 $800E34F8 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E40FC $800E34FC - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E4100 $800E3500 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E4104 $800E3504 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E4108 $800E3508 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E410C $800E350C - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E4110 $800E3510 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E4114 $800E3514 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E4118 $800E3518 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E411C $800E351C - Kart *Unknown* (IEEE32) (0.0: $00000000)

KartUnknown69: // D.K.
            // ROM       RAM         Kart *Unknown*
float32 0.0 // $000E4120 $800E3520 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E4124 $800E3524 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E4128 $800E3528 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E412C $800E352C - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E4130 $800E3530 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E4134 $800E3534 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E4138 $800E3538 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E413C $800E353C - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E4140 $800E3540 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E4144 $800E3544 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E4148 $800E3548 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E414C $800E354C - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E4150 $800E3550 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E4154 $800E3554 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E4158 $800E3558 - Kart *Unknown* (IEEE32) (0.0: $00000000)

KartUnknown70: // Wario
            // ROM       RAM         Kart *Unknown*
float32 0.0 // $000E415C $800E355C - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E4160 $800E3560 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E4164 $800E3564 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E4168 $800E3568 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E416C $800E356C - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E4170 $800E3570 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E4174 $800E3574 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E4178 $800E3578 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E417C $800E357C - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E4180 $800E3580 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E4184 $800E3584 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E4188 $800E3588 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E418C $800E358C - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E4190 $800E3590 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E4194 $800E3594 - Kart *Unknown* (IEEE32) (0.0: $00000000)

KartUnknown71: // Peach
            // ROM       RAM         Kart *Unknown*
float32 0.0 // $000E4198 $800E3598 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E419C $800E359C - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E41A0 $800E35A0 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E41A4 $800E35A4 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E41A8 $800E35A8 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E41AC $800E35AC - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E41B0 $800E35B0 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E41B4 $800E35B4 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E41B8 $800E35B8 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E41BC $800E35BC - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E41C0 $800E35C0 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E41C4 $800E35C4 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E41C8 $800E35C8 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E41CC $800E35CC - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E41D0 $800E35D0 - Kart *Unknown* (IEEE32) (0.0: $00000000)

KartUnknown72: // Bowser
            // ROM       RAM         Kart *Unknown*
float32 0.0 // $000E41D4 $800E35D4 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E41D8 $800E35D8 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E41DC $800E35DC - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E41E0 $800E35E0 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E41E4 $800E35E4 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E41E8 $800E35E8 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E41EC $800E35EC - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E41F0 $800E35F0 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E41F4 $800E35F4 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E41F8 $800E35F8 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E41FC $800E35FC - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E4200 $800E3600 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E4204 $800E3604 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E4208 $800E3608 - Kart *Unknown* (IEEE32) (0.0: $00000000)
float32 0.0 // $000E420C $800E360C - Kart *Unknown* (IEEE32) (0.0: $00000000)

                 // ROM       RAM         Offsets To IEEE32 Tables Above
dw KartUnknown65 // $000E4210 $800E3610 - Kart *Unknown* Mario  (UINT32) ($800E3230)
dw KartUnknown66 // $000E4214 $800E3614 - Kart *Unknown* Luigi  (UINT32) ($800E326C)
dw KartUnknown67 // $000E4218 $800E3618 - Kart *Unknown* Yoshi  (UINT32) ($800E32A8)
dw KartUnknown68 // $000E421C $800E361C - Kart *Unknown* Toad   (UINT32) ($800E32E4)
dw KartUnknown69 // $000E4220 $800E3620 - Kart *Unknown* D.K.   (UINT32) ($800E3320)
dw KartUnknown70 // $000E4224 $800E3624 - Kart *Unknown* Wario  (UINT32) ($800E335C)
dw KartUnknown71 // $000E4228 $800E3628 - Kart *Unknown* Peach  (UINT32) ($800E3398)
dw KartUnknown72 // $000E422C $800E362C - Kart *Unknown* Bowser (UINT32) ($800E33D4)


             // ROM       RAM         Kart Handling (Turn Angle)
float32 1.25 // $000E4230 $800E3630 - Mario  (IEEE32) (1.25: $3FA00000)
float32 1.25 // $000E4234 $800E3634 - Luigi  (IEEE32) (1.25: $3FA00000)
float32 1.28 // $000E4238 $800E3638 - Yoshi  (IEEE32) (1.28: $3FA3D70A)
float32 1.28 // $000E423C $800E363C - Toad   (IEEE32) (1.28: $3FA3D70A)
float32 1.15 // $000E4240 $800E3640 - D.K.   (IEEE32) (1.15: $3F933333)
float32 1.15 // $000E4244 $800E3644 - Wario  (IEEE32) (1.15: $3F933333)
float32 1.28 // $000E4248 $800E3648 - Peach  (IEEE32) (1.28: $3FA3D70A)
float32 1.15 // $000E424C $800E364C - Bowser (IEEE32) (1.15: $3F933333)

            // ROM       RAM         Kart *Unknown*
float32 0.0 // $000E4250 $800E3650 - Mario  (IEEE32) (0.0: $00000000)
float32 0.0 // $000E4254 $800E3654 - Luigi  (IEEE32) (0.0: $00000000)
float32 0.0 // $000E4258 $800E3658 - Yoshi  (IEEE32) (0.0: $00000000)
float32 0.0 // $000E425C $800E365C - Toad   (IEEE32) (0.0: $00000000)
float32 0.0 // $000E4260 $800E3660 - D.K.   (IEEE32) (0.0: $00000000)
float32 0.0 // $000E4264 $800E3664 - Wario  (IEEE32) (0.0: $00000000)
float32 0.0 // $000E4268 $800E3668 - Peach  (IEEE32) (0.0: $00000000)
float32 0.0 // $000E426C $800E366C - Bowser (IEEE32) (0.0: $00000000)

               // ROM       RAM         Kart Turn Speed Reduction Coefficient
float32  0.0   // $000E4270 $800E3670 - Mario  (IEEE32) ( 0.0:   $00000000)
float32  0.0   // $000E4274 $800E3674 - Luigi  (IEEE32) ( 0.0:   $00000000)
float32  0.002 // $000E4278 $800E3678 - Yoshi  (IEEE32) ( 0.002: $3B03126F)
float32  0.002 // $000E427C $800E367C - Toad   (IEEE32) ( 0.002: $3B03126F)
float32 -0.002 // $000E4280 $800E3680 - D.K.   (IEEE32) (-0.002: $BB03126F)
float32 -0.002 // $000E4284 $800E3684 - Wario  (IEEE32) (-0.002: $BB03126F)
float32  0.002 // $000E4288 $800E3688 - Peach  (IEEE32) ( 0.002: $3B03126F)
float32 -0.002 // $000E428C $800E368C - Bowser (IEEE32) (-0.002: $BB03126F)

               // ROM       RAM         Kart Turn Speed Reduction Coefficient 2
float32  0.0   // $000E4290 $800E3690 - Mario  (IEEE32) ( 0.0:   $00000000)
float32  0.0   // $000E4294 $800E3694 - Luigi  (IEEE32) ( 0.0:   $00000000)
float32  0.002 // $000E4298 $800E3698 - Yoshi  (IEEE32) ( 0.002: $3B03126F)
float32  0.002 // $000E429C $800E369C - Toad   (IEEE32) ( 0.002: $3B03126F)
float32 -0.002 // $000E42A0 $800E36A0 - D.K.   (IEEE32) (-0.002: $BB03126F)
float32 -0.002 // $000E42A4 $800E36A4 - Wario  (IEEE32) (-0.002: $BB03126F)
float32  0.002 // $000E42A8 $800E36A8 - Peach  (IEEE32) ( 0.002: $3B03126F)
float32 -0.002 // $000E42AC $800E36AC - Bowser (IEEE32) (-0.002: $BB03126F)

            // ROM       RAM         Kart *Unknown*
float32 2.0 // $000E42B0 $800E36B0 - Mario  (IEEE32) (2.0: $40000000)
float32 2.0 // $000E42B4 $800E36B4 - Luigi  (IEEE32) (2.0: $40000000)
float32 3.0 // $000E42B8 $800E36B8 - Yoshi  (IEEE32) (3.0: $40400000)
float32 3.0 // $000E42BC $800E36BC - Toad   (IEEE32) (3.0: $40400000)
float32 1.5 // $000E42C0 $800E36C0 - D.K.   (IEEE32) (1.5: $3FC00000)
float32 1.5 // $000E42C4 $800E36C4 - Wario  (IEEE32) (1.5: $3FC00000)
float32 3.0 // $000E42C8 $800E36C8 - Peach  (IEEE32) (3.0: $40400000)
float32 3.0 // $000E42CC $800E36CC - Bowser (IEEE32) (3.0: $40400000)

             // ROM       RAM         Kart Hop Height
float32 0.93 // $000E42D0 $800E36D0 - Mario  (IEEE32) (0.93: $3F6E147B)
float32 0.93 // $000E42D4 $800E36D4 - Luigi  (IEEE32) (0.93: $3F6E147B)
float32 0.93 // $000E42D8 $800E36D8 - Yoshi  (IEEE32) (0.93: $3F6E147B)
float32 0.93 // $000E42DC $800E36DC - Toad   (IEEE32) (0.93: $3F6E147B)
float32 0.93 // $000E42E0 $800E36E0 - D.K.   (IEEE32) (0.93: $3F6E147B)
float32 0.93 // $000E42E4 $800E36E4 - Wario  (IEEE32) (0.93: $3F6E147B)
float32 0.93 // $000E42E8 $800E36E8 - Peach  (IEEE32) (0.93: $3F6E147B)
float32 0.93 // $000E42EC $800E36EC - Bowser (IEEE32) (0.93: $3F6E147B)

             // ROM       RAM         Kart Hop Fall Speed
float32 0.03 // $000E42F0 $800E36F0 - Mario  (IEEE32) (0.03: $3CF5C28F)
float32 0.03 // $000E42F4 $800E36F4 - Luigi  (IEEE32) (0.03: $3CF5C28F)
float32 0.03 // $000E42F8 $800E36F8 - Yoshi  (IEEE32) (0.03: $3CF5C28F)
float32 0.03 // $000E42FC $800E36FC - Toad   (IEEE32) (0.03: $3CF5C28F)
float32 0.03 // $000E4300 $800E3700 - D.K.   (IEEE32) (0.03: $3CF5C28F)
float32 0.03 // $000E4304 $800E3704 - Wario  (IEEE32) (0.03: $3CF5C28F)
float32 0.03 // $000E4308 $800E3708 - Peach  (IEEE32) (0.03: $3CF5C28F)
float32 0.03 // $000E430C $800E370C - Bowser (IEEE32) (0.03: $3CF5C28F)

            // ROM       RAM         Kart *Unknown*
float32 2.2 // $000E4310 $800E3710 - Mario  (IEEE32) (2.2: $400CCCCD)
float32 2.2 // $000E4314 $800E3714 - Luigi  (IEEE32) (2.2: $400CCCCD)
float32 2.2 // $000E4318 $800E3718 - Yoshi  (IEEE32) (2.2: $400CCCCD)
float32 2.2 // $000E431C $800E371C - Toad   (IEEE32) (2.2: $400CCCCD)
float32 2.2 // $000E4320 $800E3720 - D.K.   (IEEE32) (2.2: $400CCCCD)
float32 2.2 // $000E4324 $800E3724 - Wario  (IEEE32) (2.2: $400CCCCD)
float32 2.2 // $000E4328 $800E3728 - Peach  (IEEE32) (2.2: $400CCCCD)
float32 2.2 // $000E432C $800E372C - Bowser (IEEE32) (2.2: $400CCCCD)

              // ROM       RAM         Kart *Unknown*
float32 0.002 // $000E4330 $800E3730 - Mario  (IEEE32) (0.002: $3B03126F)
float32 0.002 // $000E4334 $800E3734 - Luigi  (IEEE32) (0.002: $3B03126F)
float32 0.002 // $000E4338 $800E3738 - Yoshi  (IEEE32) (0.002: $3B03126F)
float32 0.002 // $000E433C $800E373C - Toad   (IEEE32) (0.002: $3B03126F)
float32 0.002 // $000E4340 $800E3740 - D.K.   (IEEE32) (0.002: $3B03126F)
float32 0.002 // $000E4344 $800E3744 - Wario  (IEEE32) (0.002: $3B03126F)
float32 0.002 // $000E4348 $800E3748 - Peach  (IEEE32) (0.002: $3B03126F)
float32 0.002 // $000E434C $800E374C - Bowser (IEEE32) (0.002: $3B03126F)

            // ROM       RAM         Kart *Unknown*
float32 2.0 // $000E4350 $800E3750 - Mario  (IEEE32) (2.0: $40000000)
float32 2.0 // $000E4354 $800E3754 - Luigi  (IEEE32) (2.0: $40000000)
float32 2.0 // $000E4358 $800E3758 - Yoshi  (IEEE32) (2.0: $40000000)
float32 2.0 // $000E435C $800E375C - Toad   (IEEE32) (2.0: $40000000)
float32 2.0 // $000E4360 $800E3760 - D.K.   (IEEE32) (2.0: $40000000)
float32 2.0 // $000E4364 $800E3764 - Wario  (IEEE32) (2.0: $40000000)
float32 2.0 // $000E4368 $800E3768 - Peach  (IEEE32) (2.0: $40000000)
float32 2.0 // $000E436C $800E376C - Bowser (IEEE32) (2.0: $40000000)

              // ROM       RAM         Kart *Unknown*
float32 0.002 // $000E4370 $800E3770 - Mario  (IEEE32) (0.002: $3B03126F)
float32 0.002 // $000E4374 $800E3774 - Luigi  (IEEE32) (0.002: $3B03126F)
float32 0.002 // $000E4378 $800E3778 - Yoshi  (IEEE32) (0.002: $3B03126F)
float32 0.002 // $000E437C $800E377C - Toad   (IEEE32) (0.002: $3B03126F)
float32 0.002 // $000E4380 $800E3780 - D.K.   (IEEE32) (0.002: $3B03126F)
float32 0.002 // $000E4384 $800E3784 - Wario  (IEEE32) (0.002: $3B03126F)
float32 0.002 // $000E4388 $800E3788 - Peach  (IEEE32) (0.002: $3B03126F)
float32 0.002 // $000E438C $800E378C - Bowser (IEEE32) (0.002: $3B03126F)

             // ROM       RAM         Kart *Unknown*
float32 1.2  // $000E4390 $800E3790 - Mario  (IEEE32) (1.2:  $3F99999A)
float32 1.45 // $000E4394 $800E3794 - Luigi  (IEEE32) (1.45: $3FB9999A)
float32 1.45 // $000E4398 $800E3798 - Yoshi  (IEEE32) (1.45: $3FB9999A)
float32 1.45 // $000E439C $800E379C - Toad   (IEEE32) (1.45: $3FB9999A)
float32 1.45 // $000E43A0 $800E37A0 - D.K.   (IEEE32) (1.45: $3FB9999A)
float32 1.45 // $000E43A4 $800E37A4 - Wario  (IEEE32) (1.45: $3FB9999A)
float32 1.45 // $000E43A8 $800E37A8 - Peach  (IEEE32) (1.45: $3FB9999A)
float32 1.45 // $000E43AC $800E37AC - Bowser (IEEE32) (1.45: $3FB9999A)

             // ROM       RAM         Kart *Unknown*
float32 0.01 // $000E43B0 $800E37B0 - Mario  (IEEE32) (0.01: $3C23D70A)
float32 0.01 // $000E43B4 $800E37B4 - Luigi  (IEEE32) (0.01: $3C23D70A)
float32 0.01 // $000E43B8 $800E37B8 - Yoshi  (IEEE32) (0.01: $3C23D70A)
float32 0.01 // $000E43BC $800E37BC - Toad   (IEEE32) (0.01: $3C23D70A)
float32 0.01 // $000E43C0 $800E37C0 - D.K.   (IEEE32) (0.01: $3C23D70A)
float32 0.01 // $000E43C4 $800E37C4 - Wario  (IEEE32) (0.01: $3C23D70A)
float32 0.01 // $000E43C8 $800E37C8 - Peach  (IEEE32) (0.01: $3C23D70A)
float32 0.01 // $000E43CC $800E37CC - Bowser (IEEE32) (0.01: $3C23D70A)

            // ROM       RAM         Kart *Unknown*
float32 3.5 // $000E43D0 $800E37D0 - Mario  (IEEE32) (3.5: $40600000)
float32 3.5 // $000E43D4 $800E37D4 - Luigi  (IEEE32) (3.5: $40600000)
float32 3.5 // $000E43D8 $800E37D8 - Yoshi  (IEEE32) (3.5: $40600000)
float32 3.5 // $000E43DC $800E37DC - Toad   (IEEE32) (3.5: $40600000)
float32 3.5 // $000E43E0 $800E37E0 - D.K.   (IEEE32) (3.5: $40600000)
float32 3.5 // $000E43E4 $800E37E4 - Wario  (IEEE32) (3.5: $40600000)
float32 3.5 // $000E43E8 $800E37E8 - Peach  (IEEE32) (3.5: $40600000)
float32 3.5 // $000E43EC $800E37EC - Bowser (IEEE32) (3.5: $40600000)

              // ROM       RAM         Kart *Unknown*
float32 0.002 // $000E43F0 $800E37F0 - Mario  (IEEE32) (0.002: $3B03126F)
float32 0.002 // $000E43F4 $800E37F4 - Luigi  (IEEE32) (0.002: $3B03126F)
float32 0.002 // $000E43F8 $800E37F8 - Yoshi  (IEEE32) (0.002: $3B03126F)
float32 0.002 // $000E43FC $800E37FC - Toad   (IEEE32) (0.002: $3B03126F)
float32 0.002 // $000E4400 $800E3800 - D.K.   (IEEE32) (0.002: $3B03126F)
float32 0.002 // $000E4404 $800E3804 - Wario  (IEEE32) (0.002: $3B03126F)
float32 0.002 // $000E4408 $800E3808 - Peach  (IEEE32) (0.002: $3B03126F)
float32 0.002 // $000E440C $800E380C - Bowser (IEEE32) (0.002: $3B03126F)


origin $00121DA0
            // ROM       RAM         Kart Weight
float32 1.2 // $00121DA0 $802B8790 - Mario  (IEEE32) (1.2: $3F99999A)
float32 1.0 // $00121DA4 $802B8794 - Luigi  (IEEE32) (1.0: $3F800000)
float32 0.9 // $00121DA8 $802B8798 - Yoshi  (IEEE32) (0.9: $3F666666)
float32 0.7 // $00121DAC $802B879C - Toad   (IEEE32) (0.7: $3F333333)
float32 2.0 // $00121DB0 $802B87A0 - D.K.   (IEEE32) (2.0: $40000000)
float32 1.8 // $00121DB4 $802B87A4 - Wario  (IEEE32) (1.8: $3FE66666)
float32 0.9 // $00121DB8 $802B87A8 - Peach  (IEEE32) (0.9: $3F666666)
float32 2.3 // $00121DBC $802B87AC - Bowser (IEEE32) (2.3: $40133333)

//----------------------
// TKMK00 menu textures
//----------------------

// Race type menu textures table
origin 0x12F3D4
MK_TEXTURE(1,  menu_50cc,  64,  18,   0,   0, 0x0000, 0x0000) // 50cc
MK_TEXTURE(0, 0x00000000,   0,   0,   0,   0, 0x0000, 0x0000)
MK_TEXTURE(1, menu_100cc,  64,  18,   0,   0, 0x0000, 0x0000) // 100cc
MK_TEXTURE(0, 0x00000000,   0,   0,   0,   0, 0x0000, 0x0000)
MK_TEXTURE(1, menu_150cc,  64,  18,   0,   0, 0x0000, 0x0000) // 150cc
MK_TEXTURE(0, 0x00000000,   0,   0,   0,   0, 0x0000, 0x0000)

// assign segment 0B base for use with TKMK00 textures
origin 0x7FA3C0
base 0x0B000000

// put new TKMK00 textures at end of ROM
origin 0xBEA000
menu_50cc:
insert "textures/menu_50cc.tkmk00"
align(0x10)
menu_100cc:
insert "textures/menu_100cc.tkmk00"
align(0x10)
menu_150cc:
insert "textures/menu_150cc.tkmk00"
align(0x10)

//----------------------
// MIO0 logo texture
//----------------------

// assign segment 0F base
// Stock title logo: 719480/0F0D7510
origin 0x641F70
base 0x0F000000

// MIO0 textures after TKMK00
// this origin just needs to be after the last TKMK00 texture above
origin 0xBEB000
title_logo:
insert "textures/title_logo.mio0"
align(0x4)
title_logo.end:

// TODO: include N64.INC?
constant r0(0)
constant a0(4)
constant a1(5)
constant a2(6)

// update asm pointer to title logo (was 0F0D7510)
origin 0x06FA4C // 8006EE4C
lui   a0, (title_logo >> 16)
lui   a1, 0x8019
lw    a1, -0x2650(a1)
ori   a0, a0, (title_logo & 0xFFFF)
addiu a2, r0, title_logo.end - title_logo