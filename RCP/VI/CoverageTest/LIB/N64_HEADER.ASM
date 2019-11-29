//============
// N64 Header
//============
// PI_BSB_DOM1
  db $80 // Initial PI_BSB_DOM1_LAT_REG Value
  db $37 // Initial PI_BSB_DOM1_PGS_REG Value
  db $12 // Initial PI_BSB_DOM1_PWD_REG Value
  db $40 // Initial PI_BSB_DOM1_PGS_REG Value

// CLOCK RATE
  dw $000F // Initial Clock Rate

// VECTOR
  dw Start // Boot Address Offset
  dw $1444 // Release Offset

// COMPLEMENT CHECK & CHECKSUM
  db "CRC1" // CRC1: COMPLEMENT CHECK
  db "CRC2" // CRC2: CHECKSUM

  dd 0 // UNUSED

// PROGRAM TITLE (27 Byte ASCII String, Use Spaces For Unused Bytes)
  db "Coverage test              "
//   "123456789012345678901234567"

// CARTRIDGE ID CODE
  db "NCTE"
  db 0 // UNUSED
