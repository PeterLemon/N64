align(8) // Align 64-Bit
PPUTileFlipRDP: // Static RDP Textured Rectangle SNES X/Y Flip Modes (S,T, DSDX,DTDY) 
dh 0<<5,7<<5,  1<<10,-1<<10 // X Flip = 0, Y Flip = 0 (64-Bit)
dh 0<<5,0<<5,  1<<10, 1<<10 // X Flip = 1, Y Flip = 0 (64-Bit)
dh 7<<5,7<<5, -1<<10,-1<<10 // X Flip = 0, Y Flip = 1 (64-Bit)
dh 7<<5,0<<5, -1<<10, 1<<10 // X Flip = 1, Y Flip = 1 (64-Bit)