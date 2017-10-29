// N64 'Bare Metal' 16BPP 320x240 Hello World RDP Copy Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "HelloWorldRDP16BPP320X240.N64", create
fill 1052672 // Set ROM Size

origin $00000000
base $80000000 // Entry Point Of Code
include "LIB/N64.INC" // Include N64 Definitions
include "LIB/N64_HEADER.ASM" // Include 64 Byte Header & Vector Table
insert "LIB/N64_BOOTCODE.BIN" // Include 4032 Byte Boot Code

macro PrintString(xpos, ypos, fontfile, tlut, string, length) { // Print Text String To VRAM Using Font & Tlut At X,Y Position
  la a2,$A0000000+(RDPFontTlut&$3FFFFF) // A2 = RDP Font Tlut Command Address
  la a3,{tlut} // A3 = Font Tlut Address
  sw a3,4(a2) // Store Tlut Address To RDP Command
  DPC(RDPFontTlut, RDPFontCharacter) // Run DPC Command Buffer: Start, End (Load Tlut)

  ori t0,r0,{length} // T0 = Number of Text Characters to Print
  ori t1,r0,{xpos} // T1 = X Position
  sll t1,2 // X Position <<= 2
  ori t2,r0,{ypos} // T2 = Y Position
  sll t2,2 // Y Position <<= 2
  la t3,{fontfile} // T3 = Font Address
  la a2,{string} // A2 = Text Address
  la a3,$A0000000+(RDPFontCharacter&$3FFFFF) // A3 = RDP Font Character Command Address

  {#}DrawChars:
    lbu t4,0(a2) // T4 = Next Text Character
    addiu a2,1 // Text Address++

    sll t4,5 // T4 *= 32 (Shift to Correct Position in Font)
    addu t4,t3 // T4 += Font Address
    sw t4,4(a3) // Store Font Character Address To RDP Command

    sll t4,t1,12 // T4 = XH << 12
    or t4,t2 // T4 = XH/YH
    sw t4,44(a3) // Store XH/YH

    addiu t1,(7*4) // X Position += 7
    addiu t2,(7*4) // Y Position += 7
    sll t4,t1,12 // T4 = XH << 12
    or t4,t2 // T4 = XH/YH
    sw t4,40(a3) // Store XH/YH
    ori t4,r0,$24 // T4 = Texture Rectangle RDP Command Byte
    sb t4,40(a3) // Store RDP Command Byte
    addiu t1,(1*4) // X Position += 1
    subiu t2,(7*4) // Y Position -= 7

    DPC(RDPFontCharacter, RDPBufferEnd) // Run DPC Command Buffer: Start, End (Draw Character)
    bnez t0,{#}DrawChars // Continue to Print Characters
    subiu t0,1 // Subtract Number of Text Characters to Print (Delay Slot)
}

Start:
  include "LIB/N64_GFX.INC" // Include Graphics Macros
  N64_INIT() // Run N64 Initialisation Routine

  ScreenNTSC(320, 240, BPP16, $A0100000) // Screen NTSC: 320x240, 16BPP, DRAM Origin = $A0100000

  WaitScanline($200) // Wait For Scanline To Reach Vertical Blank

  DPC(RDPBuffer, RDPFontTlut) // Run DPC Command Buffer: Start, End (Set Up RDP Screen, Fill Color, Copy Mode + Alpha)

  PrintString(96, 32, Font, BlackTlut, Text, 11) // Print Text String To VRAM Using Font At X,Y Position
  PrintString(192, 72, Font, RedTlut, Text, 11) // Print Text String To VRAM Using Font At X,Y Position
  PrintString(32, 112, Font, GreenTlut, Text, 11) // Print Text String To VRAM Using Font At X,Y Position
  PrintString(192, 152, Font, BlueTlut, Text, 11) // Print Text String To VRAM Using Font At X,Y Position
  PrintString(96, 192, Font, AlphaTlut, Text, 11) // Print Text String To VRAM Using Font At X,Y Position

Loop:
  j Loop
  nop // Delay Slot

Text:
  db "Hello World!"

align(8) // Align 64-Bit
RDPBuffer:
arch n64.rdp
  Set_Scissor 0<<2,0<<2, 0,0, 320<<2,240<<2 // Set Scissor: XH 0.0,YH 0.0, Scissor Field Enable Off,Field Off, XL 320.0,YL 240.0
  Set_Other_Modes CYCLE_TYPE_FILL // Set Other Modes
  Set_Color_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,320-1, $00100000 // Set Color Image: FORMAT RGBA,SIZE 16B,WIDTH 320, DRAM ADDRESS $00100000
  Set_Fill_Color $FF01FF01 // Set Fill Color: PACKED COLOR 16B R5G5B5A1 Pixels
  Fill_Rectangle 319<<2,239<<2, 0<<2,0<<2 // Fill Rectangle: XL 319.0,YL 239.0, XH 0.0,YH 0.0

  Set_Other_Modes CYCLE_TYPE_COPY|EN_TLUT|ALPHA_COMPARE_EN // Set Other Modes

RDPFontTlut:
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,1-1, BlackTlut // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 1, Tlut DRAM ADDRESS
  Set_Tile 0,0,0, $100, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: TMEM Address $100, Tile 0
  Load_Tlut 0<<2,0<<2, 0, 15<<2,0<<2 // Load Tlut: SL 0.0,TL 0.0, Tile 0, SH 15.0,TH 0.0
  Sync_Tile // Sync Tile

RDPFontCharacter:
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,2-1, Font // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 2, Font DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,1, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 7<<2,7<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 7.0,TH 7.0
  Sync_Tile // Sync Tile

  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,1, $000, 0,PALETTE_0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0,Palette 0
  Texture_Rectangle 0,0, 0, 0,0, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 0.0,YL 0.0, Tile 0, XH 0.0,YH 0.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0
  Sync_Tile // Sync Tile
RDPBufferEnd:

Font:
  include "Font4BPP8x8.asm" // Include 4BPP Font
BlackTlut:
  dh $0001,$FFFF,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000 // Black 4B Palette (16x16B = 32 Bytes)
RedTlut:
  dh $F801,$FFFF,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000 // Red 4B Palette (16x16B = 32 Bytes)
GreenTlut:
  dh $07C1,$FFFF,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000 // Green 4B Palette (16x16B = 32 Bytes)
BlueTlut:
  dh $003F,$FFFF,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000 // Blue 4B Palette (16x16B = 32 Bytes)
AlphaTlut:
  dh $0000,$0001,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000 // Alpha 4B Palette (16x16B = 32 Bytes)