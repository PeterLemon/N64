// Tests exactly where a textured rectangle should be drawn on-screen, including sub-pixel accuracy
// Uses 160x120 to show pixels more clearly
// Author: Lemmy with original sources from Peter Lemon's test sources
output "TextureCoordinates1b.N64", create
arch n64.cpu
endian msb
fill 1052672 // Set ROM Size

origin $00000000
base $80000000 // Entry Point Of Code
include "LIB/N64.INC" // Include N64 Definitions
include "LIB/N64_HEADER.ASM" // Include 64 Byte Header & Vector Table
insert "LIB/N64_BOOTCODE.BIN" // Include 4032 Byte Boot Code

Start:
  include "LIB/N64_GFX.INC" // Include Graphics Macros
  N64_INIT() // Run N64 Initialisation Routine

  ScreenNTSC(160, 120, BPP16|AA_MODE_2, $A0100000) // Screen NTSC: 160x120, 16BPP, Resample Only, DRAM Origin $A0100000

  WaitScanline($200) // Wait For Scanline To Reach Vertical Blank

  DPC(RDPBuffer, RDPBufferEnd) // Run DPC Command Buffer: Start, End

Loop:
  j Loop
  nop // Delay Slot

align(8) // Align 64-Bit
RDPBuffer:
arch n64.rdp
  // ***************************************************************************************
  // ** Initialize and clear screen                                                       **
  // ***************************************************************************************
  Set_Scissor 0<<2,0<<2, 0,0, 160<<2,120<<2
  Set_Other_Modes CYCLE_TYPE_FILL // Set Other Modes
  Set_Color_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,160-1, $00100000
  Set_Fill_Color $39CF39CF // Set Fill Color: PACKED COLOR 16B R5G5B5A1 Pixels
  Fill_Rectangle 319<<2,239<<2, 0<<2,0<<2 // Fill Rectangle: XL 319.0,YL 239.0, XH 0.0,YH 0.0
  Set_Combine_Mode 8,16,7,7,  8,16,8,8,  7,7,1,7,  6,1,7,6   // Color=Tex0Color, Alpha=1


  // ***************************************************************************************
  // ** Load test texture                                                                 **
  // ***************************************************************************************
  Sync_Pipe
  Sync_Load
  Sync_Tile


  // SETTIMG, address: 0x1ff330, width: 8, size=2, format=0
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,7, Texture8x8x16b

  // SETTILE: tile: 7, shift_s: 0, mask_s: 5, clamp_s: 0, mirror_s: 0, shift_t: 0, mask_t: 4, clamp_t: 0, mirror_t: 0, palette: 0, tmem: 0 (meaning 0x0), line: 8, pixelSize: 2, format: 0
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,8, $000>>3, 7,0, 0,0,3,0, 0,0,4,0
  Sync_Load
  
  Load_Tile 0<<2,0<<2, 7, 7<<2, 15<<2
  Sync_Pipe

  macro Rectangle(variable left, variable top, variable height) {
    variable shift_s(0)
    variable mask_s(3)
    variable clamp_s(0)
    variable mirror_s(0)
    variable shift_t(0)
    variable mask_t(3)
    variable clamp_t(0)
    variable mirror_t(0)
    variable line(8)
    variable tile(0)
    variable pal(0)
    
    // alphaCompare=off, alphaCompareDither=off, primitiveDepth=off, aa=off, zCompare=off, zWrite=off, imgRead=off, colorOnCvg=off, cvgDst=0, zMode=Opaque, cvg*alpha=off, alphaCvgSel=off, forceBl=on
    // blendMask=0, alphaDither=0, rgbDither=3, combKey=0, convertOne=0, biLerp0=1, biLerp1=1, texFilter=2, tlutType=RGBA16, tlutEnabled=off, lod=off, sharpen=off, detail=off, textPersp=off, cycleType=copy, colorDither=off, pipeline=on
    Set_Other_Modes FORCE_BLEND|CYCLE_TYPE_COPY|BI_LERP_0|BI_LERP_1|SAMPLE_TYPE|RGB_DITHER_SEL_NO_DITHER|ATOMIC_PRIM
    Sync_Pipe
    Sync_Load
    Sync_Tile
    
    // SETTILE: tile: 1, shift_s: 2, mask_s: 5, clamp_s: 0, mirror_s: 0, shift_t: 11, mask_t: 5, clamp_t: 0, mirror_t: 0, palette: 0, tmem: 256 (meaning 0x800), line: 4, pixelSize: 1, format: 4
    Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,line, $000 >> 3, tile,pal, clamp_t,mirror_t,mask_t,shift_t, clamp_s,mirror_s,mask_s,shift_s
    
    variable uls(0)
    variable ult(0)
    variable lrs(8)
    variable lrt(8)
    Set_Tile_Size uls << 2, ult << 2, 0, lrs << 2, lrt << 2
    
    // TEXRECT, tile: 0, left: 93.000000, top: 63.000000, right: 125.000000, bottom: 95.000000, s: 0.000000, t: 0.000000, dsdx: 1.000000, dsdy: 1.000000

    variable right(left + (8 << 2))
    variable bottom(top + height)
    Texture_Rectangle right,bottom, 0, left,top, 0<<5,0<<5, 1<<10, 1<<10
  }

  // columns: increase top (subpixels)
  // rows: increase height (subpixels)
  variable columnIndex(0)
  while columnIndex < 16 {
    variable rowIndex(0)
    while rowIndex < 8 {
      Rectangle(((10 + columnIndex * 8) << 2), ((10 + rowIndex * 16) << 2) + columnIndex, (0 << 2) + rowIndex)

      variable rowIndex(rowIndex + 1)
    }
    
    variable columnIndex(columnIndex + 1)
  }

  Sync_Full
RDPBufferEnd:

align(8) // Align 64-Bit
Texture8x8x16b:
  dh $003F,$003F,$003F,$003F,$003F,$003F,$003F,$003F
  dh $003F,$003F,$003F,$003F,$003F,$003F,$003F,$003F
  dh $003F,$003F,$003F,$003F,$003F,$003F,$003F,$003F
  dh $003F,$003F,$003F,$003F,$003F,$003F,$003F,$003F
  dh $003F,$003F,$003F,$003F,$003F,$003F,$003F,$003F
  dh $003F,$003F,$003F,$003F,$003F,$003F,$003F,$003F
  dh $003F,$003F,$003F,$003F,$003F,$003F,$003F,$003F
  dh $003F,$003F,$003F,$003F,$003F,$003F,$003F,$003F
