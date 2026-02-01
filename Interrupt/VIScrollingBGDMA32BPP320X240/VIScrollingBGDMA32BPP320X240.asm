// N64 'Bare Metal' VI Interrupt BG Scrolling 32BPP DMA 320x240 Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "VIScrollingBGDMA32BPP320X240.N64", create
fill 1052672 // Set ROM Size

origin $00000000
base $80000000 // Entry Point Of Code
include "LIB/N64.INC" // Include N64 Definitions
include "LIB/N64_HEADER.ASM" // Include 64 Byte Header & Vector Table
insert "LIB/N64_BOOTCODE.BIN" // Include 4032 Byte Boot Code

Start:
  include "LIB/N64_GFX.INC" // Include Graphics Macros
  N64_INIT() // Run N64 Initialisation Routine

  ScreenNTSC(320, 240, BPP32, $A0100000) // Screen NTSC: 320x240, 32BPP, DRAM Origin $A0100000

  DMA(Image, Image+Image.size, $00100000) // DMA Data Copy Cart->DRAM: Start Cart Address, End Cart Address, Destination DRAM Address

  la t1,$A0100000                  // T1 = Origin (Frame Buffer Origin In Bytes)
  la t2,$A0100000+((320*960)-1280) // T1 = Origin End (Frame Buffer Origin End In Bytes)
Loop:
  jal WaitForVerticalInterrupt
  nop

  lui a0,VI_BASE      // A0 = VI Base Register ($A4400000)
  sw t1,VI_ORIGIN(a0) // Store Origin To VI Origin Register ($A4400004)

  bne t1,t2,LoopEnd   // IF (T1 != T2), Skip Reset Origin
  addiu t1,1280       // T1 += 1280 (Frame Buffer Origin In Bytes += 1 Scanline) (Delay Slot)
  la t1,$A0100000     // ELSE Reset Origin
  
LoopEnd:
  j Loop
  nop // Delay Slot

WaitForVerticalInterrupt:
  lui a0,MI_BASE // A0 = MIPS Interface (MI) Base Register ($A4300000)
  WaitVI:
    lw t0,MI_INTR(a0) // T0 = MI: Interrupt Register ($A4300008)
    andi t0,$08       // T0 &= VI Interrupt (Bit 3)
    beqz t0,WaitVI    // IF (VI Interrupt == 0) Wait For VI Interrupt To Fire
    nop               // Delay Slot

  lui a0,VI_BASE // A0 = Video Interface (VI) Base Register ($A4400000)
  sw r0,VI_V_CURRENT_LINE(a0) // Clear VI Interrupt, Store Zero To VI: Current Vertical Line Register ($A4400010)
  jr ra
  nop // Delay Slot

insert Image, "Image.bin"