// N64 'Bare Metal' 16BPP 320x240 Fill Rectangle RDP Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "FillRectangle16BPP320X240.N64", create
fill 1052672 // Set ROM Size

origin $00000000
base $80000000 // Entry Point Of Code
include "LIB/N64.INC" // Include N64 Definitions
include "LIB/N64_HEADER.ASM" // Include 64 Byte Header & Vector Table
insert "LIB/N64_BOOTCODE.BIN" // Include 4032 Byte Boot Code

Start:
  include "LIB/N64_GFX.INC" // Include Graphics Macros
  N64_INIT() // Run N64 Initialisation Routine

  ScreenNTSC(320, 240, BPP16, $A0100000) // Screen NTSC: 320x240, 16BPP, DRAM Origin $A0100000

  WaitScanline($200) // Wait For Scanline To Reach Vertical Blank

  DPC(RDPBuffer, RDPBufferEnd) // Run DPC Command Buffer: Start, End

Loop:
  j Loop
  nop // Delay Slot

align(8) // Align 64-Bit
RDPBuffer:
arch n64.rdp
  Set_Scissor 0<<2,0<<2, 0,0, 320<<2,240<<2 // Set Scissor: XH 0.0,YH 0.0, Scissor Field Enable Off,Field Off, XL 320.0,YL 240.0
  Set_Other_Modes CYCLE_TYPE_FILL // Set Other Modes
  Set_Color_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,320-1, $00100000 // Set Color Image: FORMAT RGBA,SIZE 16B,WIDTH 320, DRAM ADDRESS $00100000
  Set_Fill_Color $00010001 // Set Fill Color: PACKED COLOR 16B R5G5B5A1 Pixels
  Fill_Rectangle 319<<2,239<<2, 0<<2,0<<2 // Fill Rectangle: XL 319.0,YL 239.0, XH 0.0,YH 0.0

  Set_Fill_Color $FFFCFF00 // Set Fill Color: PACKED COLOR 16B R5G5B5A1 Pixels
  Fill_Rectangle 179<<2,139<<2, 16<<2,8<<2 // Fill Rectangle: XL 179.0,YL 139.0, XH 16.0,YH 8.0

  Set_Fill_Color $ACFCACFC // Set Fill Color: PACKED COLOR 16B R5G5B5A1 Pixels
  Fill_Rectangle 309<<2,229<<2, 159<<2,129<<2 // Fill Rectangle: XL 309.0,YL 229.0, XH 159.0,YH 129.0

  Sync_Full // Ensure Entire Scene Is Fully Drawn
RDPBufferEnd: