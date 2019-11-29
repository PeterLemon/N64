arch n64.cpu
endian msb
output "CoverageTest.n64", create
fill 1052672

origin $00000000
base $80000000 // Entry Point Of Code
include "LIB/N64.INC" // Include N64 Definitions
include "LIB/N64_GFX.INC"
include "LIB/N64_HEADER.ASM" // Include 64 Byte Header & Vector Table
insert "LIB/N64_BOOTCODE.BIN" // Include 4032 Byte Boot Code

constant FB($A0100000)

Start:
    N64_INIT()
    ScreenNTSC(320, 240, BPP32, FB)
    DMA(FrameBuffer, FrameBufferEnd, FB)

Loop:
    j Loop
    nop

insert FrameBuffer, "FB.rgba"
FrameBufferEnd:
