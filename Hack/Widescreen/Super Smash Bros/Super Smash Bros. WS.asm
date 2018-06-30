// N64 "Super Smash Bros " Widescreen Hack by gamemasterplc:

arch n64.cpu
endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "Super Smash Bros. WS.z64", create
origin $00000000; insert "Super Smash Bros. (U) [!].z64" // Include USA Super Smash Bros. N64 ROM
origin $00000020
db "SMASH BROTHERS WS          " // $00000020 - PROGRAM TITLE (27 Byte ASCII String, Use Spaces For Unused Bytes)

include "LIB/N64.INC" // Include N64 Definitions

origin $0001BF20
j $8003E420 //Patch Aspect Ratio of 3D

origin $0003F020
lui k1, 0x3F40 //Aspect Ratio Divisor is 0.75f
mtc1 k1, f4 //Load Aspect Ratio Divisor
nop //mtc1 Delay Slot
j $8001B328 //Return to Original Code
mul.s f8, f8, f4 //Update Aspect Ratio of 3D Elements

origin $00132E30
sll t3, t3, 5 //Multiply Player Number by 32
sll t4, t3, 2 //Multiply Player Number by 128
addu t3, t3, t4 //Add Previous 2 Operations into Temporary
sll t4, t3, 3 //Multiply Temporary by 8 into a Result
subu t4, t4, t3 //Subtract Previous Operation with Temporary
addiu t5, t4, -1666 //X Offset for Character Select Players
nop //Fill in Unused Opcode
nop //Fill in Unused Opcode

origin $00137F70
addiu s2, r0, -1666 //X Offset for Character Select Player Shadows

origin $00138004
addiu s2, s2, 1120 //X Offset between Character Select Player Shadows

origin $001410C8
float32 -1466.666666 //X Position of Character on 1P Character Select

origin $001410D4
float32 -1466.666666 //X Position of Shadow on 1P Character Select

origin $00147B04
float32 -1106.666666 //X Position of Player 1 Character on Training Mode Character Select

origin $00147B0C
float32 1106.666666 //X Position of Player 2 Character on Training Mode Character Selec

origin $00147B18
float32 1106.666666 //X Position of Player 2 Shadow on Training Mode Character Select

origin $00147B1C
float32 -1106.666666 //X Position of Player 1 Shadow on Training Mode Character Selec

origin $0014A22C
lui at, 0xC469 //X Position of Character on Bonus Game Character Select (-932.0f)

origin $0014C688
lui at, 0xC469 //X Position of Shadow on Bonus Game Character Select (-932.0f)

origin $001503EC
float32 2266.666666 //X Position of Peach's Castle Stage Select Model

origin $001503F8
float32 2133.333333 //X Position of Sector Z Stage Select Model

origin $00150404
float32 2133.333333 //X Position of Congo Jungle Stage Select Model

origin $00150410
float32 2133.333333 //X Position of Planet Zebes Stage Select Model

origin $0015041C
float32 2133.333333 //X Position of Hyrule Castle Stage Select Model

origin $00150428
float32 2133.333333 //X Position of Yoshi's Island Stage Select Model

origin $00150434
float32 2133.333333 //X Position of Dream Land Stage Select Model

origin $00150440
float32 2133.333333 //X Position of Saffron City Stage Select Model

origin $0015044C
float32 2133.333333 //X Position of Mushroom Kingdom Stage Select Model

origin $0015E0E4
lui at, 0xC3E9 //X Position of Character Series Icon on Character Data Screen (-466.0f)

origin $0015F51C
lui at, 0x4469 //X Position of First Character on Character Data Screen (932.0f)

origin $0015F8B4
lui at, 0x4469 //X Position of Later Characters on Character Data Screen (932.0f)