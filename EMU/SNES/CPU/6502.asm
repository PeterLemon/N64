  align 256
  ; $00 BRK   #nn               Software Break
  addiu s3,1             ; PC_REG++ (Increment Program Counter)
  ori t0,s4,$100         ; S_REG: High-Order Byte = $01
  addu a2,a0,t0          ; STACK = PC_REG (16-Bit)
  sb s3,-1(a2)
  srl t0,s3,8
  sb t0,0(a2)
  subiu s4,2             ; S_REG -= 2 (Decrement Stack)
  andi s4,$FF
  ori s5,B_FLAG          ; P_REG: B Flag Set (6502 Emulation Mode)
  ori t0,s4,$100         ; S_REG: High-Order Byte = $01
  addu a2,a0,t0          ; STACK = P_REG (8-Bit)
  sb s5,0(a2)
  subiu s4,1             ; S_REG-- (Decrement Stack)
  andi s4,$FF
  ori s5,I_FLAG          ; P_REG: I Flag Set
  lbu t0,IRQ2_VEC+1(a0)  ; PC_REG: Set To 6502 IRQ Vector ($FFFE)
  sll t0,8
  lbu s3,IRQ2_VEC(a0)
  or s3,t0
  jr ra
  addiu v0,7             ; Cycles += 7 (Delay Slot)

  align 256
  ; $01 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $02 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $03 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $04 UNUSED OPCODE           No Operation
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $05 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $06 ASL   nn                Shift Memory Left Direct Page
  addu a2,a0,s3          ; Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          ; Load D_REG+MEM (8-Bit)
  addu a2,s6
  lbu t0,0(a2)
  sll t0,1               ; D_REG+MEM: << 1 & Store Bits (8-Bit)
  sb t0,0(a2)
  andi t1,t0,$80         ; Test Negative MSB / Carry
  srl t2,t0,8
  or t1,t2
  andi s5,~(N_FLAG+C_FLAG) ; P_REG: N/C Flag Reset
  or s5,t1               ; P_REG: N/C Flag = Result MSB / Carry
  andi t0,$FF
  beqz t0,ASLDP6502      ; IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          ; P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        ; P_REG: Z Flag Reset
  ASLDP6502:
  addiu s3,1             ; PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,5             ; Cycles += 5 (Delay Slot)

  align 256
  ; $07 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $08 PHP                     Push Processor Status Register
  ori t0,s4,$100         ; S_REG: High-Order Byte = $01
  addu a2,a0,t0          ; STACK = P_REG (8-Bit)
  sb s5,0(a2)
  subiu s4,1             ; S_REG-- (Decrement Stack)
  andi s4,$FF
  jr ra
  addiu v0,3             ; Cycles += 3 (Delay Slot)

  align 256
  ; $09 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $0A ASL A                   Shift Accumulator Left
  sll s0,1               ; A_REG: << 1 (8-Bit)
  andi t0,s0,$80         ; Test Negative MSB / Carry
  srl t1,s0,8
  or t0,t1
  andi s5,~(N_FLAG+C_FLAG) ; P_REG: N/C Flag Reset
  or s5,t0               ; P_REG: N/C Flag = Result MSB / Carry
  andi s0,$FF
  beqz s0,ASLA6502       ; IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          ; P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        ; P_REG: Z Flag Reset
  ASLA6502:
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $0B UNUSED OPCODE           No Operation
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $0C UNUSED OPCODE           No Operation
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $0D ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $0E ASL   nnnn              Shift Memory Left Absolute
  addu a2,a0,s3          ; Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          ; Load DB_REG:MEM (8-Bit)
  sll t0,s7,16
  addu a2,t0
  lbu t0,0(a2)
  sll t0,1               ; DB_REG:MEM: << 1 & Store Bits (8-Bit)
  sb t0,0(a2)
  andi t1,t0,$80         ; Test Negative MSB / Carry
  srl t2,t0,8
  or t1,t2
  andi s5,~(N_FLAG+C_FLAG) ; P_REG: N/C Flag Reset
  or s5,t1               ; P_REG: N/C Flag = Result MSB / Carry
  andi t0,$FF
  beqz t0,ASLABS6502     ; IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          ; P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        ; P_REG: Z Flag Reset
  ASLABS6502:
  addiu s3,2             ; PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,6             ; Cycles += 6 (Delay Slot)

  align 256
  ; $0F ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $10 BPL   nn                Branch IF Plus
  andi t0,s5,N_FLAG      ; P_REG: Test N Flag
  bnez t0,BPL6502        ; IF (N Flag != 0) Minus
  addiu s3,1             ; PC_REG++ (Increment Program Counter) (Delay Slot)
  addu a2,a0,s3          ; Load Signed 8-Bit Relative Address
  lb t0,-1(a2)
  add s3,t0              ; PC_REG: Set To 8-Bit Relative Address
  addiu v0,1             ; Cycles++
  BPL6502:
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $11 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $12 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $13 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $14 UNUSED OPCODE           No Operation
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $15 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $16 ASL   nn,X              Shift Memory Left Direct Page Indexed, X
  addu a2,a0,s3          ; Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          ; Load D_REG+MEM+X_REG (8-Bit)
  addu a2,s6
  addu a2,s1
  lbu t0,0(a2)
  sll t0,1               ; D_REG+MEM+X_REG: << 1 & Store Bits (8-Bit)
  sb t0,0(a2)
  andi t1,t0,$80         ; Test Negative MSB / Carry
  srl t2,t0,8
  or t1,t2
  andi s5,~(N_FLAG+C_FLAG) ; P_REG: N/C Flag Reset
  or s5,t1               ; P_REG: N/C Flag = Result MSB / Carry
  andi t0,$FF
  beqz t0,ASLDPX6502     ; IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          ; P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        ; P_REG: Z Flag Reset
  ASLDPX6502:
  addiu s3,1             ; PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,6             ; Cycles += 6 (Delay Slot)

  align 256
  ; $17 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $18 CLC                     Clear Carry Flag
  andi s5,~C_FLAG        ; P_REG: C Flag Reset
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $19 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $1A UNUSED OPCODE           No Operation
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $1B TCS                     Transfer Accumulator To Stack Pointer
  andi s4,s0,$FF         ; S_REG: Set To Accumulator (8-Bit)
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $1C UNUSED OPCODE           No Operation
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $1D ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $1E ASL   nnnn,X            Shift Memory Left Absolute Indexed, X
  addu a2,a0,s3          ; Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          ; Load DB_REG:MEM+X_REG (8-Bit)
  sll t0,s7,16
  addu a2,t0
  addu a2,s1
  lbu t0,0(a2)
  sll t0,1               ; DB_REG:MEM+X_REG: << 1 & Store Bits (8-Bit)
  sb t0,0(a2)
  andi t1,t0,$80         ; Test Negative MSB / Carry
  srl t2,t0,8
  or t1,t2
  andi s5,~(N_FLAG+C_FLAG) ; P_REG: N/C Flag Reset
  or s5,t1               ; P_REG: N/C Flag = Result MSB / Carry
  andi t0,$FF
  beqz t0,ASLABSX6502    ; IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          ; P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        ; P_REG: Z Flag Reset
  ASLABSX6502:
  addiu s3,2             ; PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,7             ; Cycles += 7 (Delay Slot)

  align 256
  ; $1F ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $20 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $21 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $22 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $23 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $24 BIT   nn                Test Memory Bits Against Accumulator Direct Page
  addu a2,a0,s3          ; Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          ; Load D_REG+MEM (8-Bit)
  addu a2,s6
  lbu t0,0(a2)
  andi t1,t0,$C0         ; Test Negative MSB / Overflow MSB-1
  andi s5,~(N_FLAG+V_FLAG) ; P_REG: N/V Flag Reset
  or s5,t1               ; P_REG: N/V Flag = Result MSB/MSB-1
  and t0,s0              ; Result AND Accumulator
  beqz t0,BITDP6502      ; IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          ; P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        ; P_REG: Z Flag Reset
  BITDP6502:
  addiu s3,1             ; PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,3             ; Cycles += 3 (Delay Slot)

  align 256
  ; $25 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $26 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $27 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $28 PLP                     Pull Status Flags
  addiu s4,1             ; S_REG++ (Increment Stack)
  andi s4,$FF
  ori t0,s4,$100         ; S_REG: High-Order Byte = $01
  addu a2,a0,t0          ; P_REG = STACK (8-Bit)
  lbu s5,0(a2)
  andi s5,~U_FLAG        ; P_REG: U Flag Reset (6502 Emulation Mode)
  jr ra
  addiu v0,4             ; Cycles += 4 (Delay Slot)

  align 256
  ; $29 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $2A ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $2B UNUSED OPCODE           No Operation
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $2C BIT   nnnn              Test Memory Bits Against Accumulator Absolute
  addu a2,a0,s3          ; Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          ; Load DB_REG:MEM (8-Bit)
  sll t0,s7,16
  addu a2,t0
  lbu t0,0(a2)
  andi t1,t0,$C0         ; Test Negative MSB / Overflow MSB-1
  andi s5,~(N_FLAG+V_FLAG) ; P_REG: N/V Flag Reset
  or s5,t1               ; P_REG: N/V Flag = Result MSB/MSB-1
  and t0,s0              ; Result AND Accumulator
  beqz t0,BITABS6502     ; IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          ; P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        ; P_REG: Z Flag Reset
  BITABS6502:
  addiu s3,2             ; PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             ; Cycles += 4 (Delay Slot)

  align 256
  ; $2D ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $2E ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $2F ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $30 BMI   nn                Branch IF Minus
  andi t0,s5,N_FLAG      ; P_REG: Test N Flag
  beqz t0,BMI6502        ; IF (N Flag == 0) Plus
  addiu s3,1             ; PC_REG++ (Increment Program Counter) (Delay Slot)
  addu a2,a0,s3          ; Load Signed 8-Bit Relative Address
  lb t0,-1(a2)
  add s3,t0              ; PC_REG: Set To 8-Bit Relative Address
  addiu v0,1             ; Cycles++
  BMI6502:
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $31 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $32 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $33 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $34 UNUSED OPCODE           No Operation
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $35 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $36 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $37 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $38 SEC                     Set Carry Flag
  ori s5,C_FLAG          ; P_REG: C Flag Set
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $39 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $3A UNUSED OPCODE           No Operation
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $3B UNUSED OPCODE           No Operation
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $3C UNUSED OPCODE           No Operation
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $3D ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $3E ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $3F ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $40 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $41 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $42 UNUSED OPCODE           No Operation
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $43 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $44 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $45 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $46 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $47 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $48 PHA                     Push Accumulator
  ori t0,s4,$100         ; S_REG: High-Order Byte = $01
  addu a2,a0,t0          ; STACK = A_REG (8-Bit)
  sb s0,0(a2)
  subiu s4,1             ; S_REG-- (Decrement Stack)
  andi s4,$FF
  jr ra
  addiu v0,3             ; Cycles += 3 (Delay Slot)

  align 256
  ; $49 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $4A ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $4B UNUSED OPCODE           No Operation
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $4C JMP   nnnn              Jump Absolute
  addu a2,a0,s3          ; PC_REG: Set To 16-Bit Absolute Address
  lbu t0,1(a2)
  sll t0,8
  lbu s3,0(a2)
  or s3,t0
  jr ra
  addiu v0,3             ; Cycles += 3 (Delay Slot)

  align 256
  ; $4D ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $4E ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $4F ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $50 BVC   nn                Branch IF Overflow Clear
  andi t0,s5,V_FLAG      ; P_REG: Test V Flag
  bnez t0,BVC6502        ; IF (V Flag != 0) Overflow Set
  addiu s3,1             ; PC_REG++ (Increment Program Counter) (Delay Slot)
  addu a2,a0,s3          ; Load Signed 8-Bit Relative Address
  lb t0,-1(a2)
  add s3,t0              ; PC_REG: Set To 8-Bit Relative Address
  addiu v0,1             ; Cycles++
  BVC6502:
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $51 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $52 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $53 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $54 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $55 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $56 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $57 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $58 CLI                     Clear Interrupt Disable Flag
  andi s5,~I_FLAG        ; P_REG: I Flag Reset
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $59 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $5A UNUSED OPCODE           No Operation
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $5B UNUSED OPCODE           No Operation
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $5C ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $5D ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $5E ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $5F ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $60 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $61 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $62 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $63 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $64 UNUSED OPCODE           No Operation
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $65 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $66 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $67 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $68 PLA                     Pull Accumulator
  addiu s4,1             ; S_REG++ (Increment Stack)
  andi s4,$FF
  addu a2,a0,s4          ; A_REG = STACK (8-Bit)
  lbu s0,0(a2)
  andi t0,s0,$80         ; Test Negative MSB
  andi s5,~N_FLAG        ; P_REG: N Flag Reset
  or s5,t0               ; P_REG: N Flag = Result MSB
  beqz s0,PLA6502        ; IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          ; P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        ; P_REG: Z Flag Reset
  PLA6502:
  jr ra
  addiu v0,4             ; Cycles += 4 (Delay Slot)

  align 256
  ; $69 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $6A ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $6B ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $6C ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $6D ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $6E ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $6F ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $70 BVS   nn                Branch IF Overflow Set
  andi t0,s5,V_FLAG      ; P_REG: Test V Flag
  beqz t0,BVS6502        ; IF (V Flag == 0) Overflow Clear
  addiu s3,1             ; PC_REG++ (Increment Program Counter) (Delay Slot)
  addu a2,a0,s3          ; Load Signed 8-Bit Relative Address
  lb t0,-1(a2)
  add s3,t0              ; PC_REG: Set To 8-Bit Relative Address
  addiu v0,1             ; Cycles++
  BVS6502:
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $71 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $72 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $73 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $74 UNUSED OPCODE           No Operation
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $75 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $76 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $77 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $78 SEI                     Set Interrupt Disable Flag
  ori s5,I_FLAG          ; P_REG: I Flag Set
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $79 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $7A UNUSED OPCODE           No Operation
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $7B UNUSED OPCODE           No Operation
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $7C ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $7D ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $7E ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $7F ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $80 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $81 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $82 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $83 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $84 STY   nn                Store Index Register Y To Memory Direct Page
  addu a2,a0,s3          ; Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          ; D_REG+MEM: Set To Index Register Y (8-Bit)
  addu a2,s6
  sb s2,0(a2)
  addiu s3,1             ; PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,3             ; Cycles += 3 (Delay Slot)

  align 256
  ; $85 STA   nn                Store Accumulator To Memory Direct Page
  addu a2,a0,s3          ; Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          ; D_REG+MEM: Set To Accumulator (8-Bit)
  addu a2,s6
  sb s0,0(a2)
  addiu s3,1             ; PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,3             ; Cycles += 3 (Delay Slot)

  align 256
  ; $86 STX   nn                Store Index Register X To Memory Direct Page
  addu a2,a0,s3          ; Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          ; D_REG+MEM: Set To Index Register X (8-Bit)
  addu a2,s6
  sb s1,0(a2)
  addiu s3,1             ; PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,3             ; Cycles += 3 (Delay Slot)

  align 256
  ; $87 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $88 DEY                     Decrement Index Register Y
  subiu s2,1             ; Y_REG: Set To Index Register Y-- (8-Bit)
  andi s2,$FF
  andi t0,s2,$80         ; Test Negative MSB
  andi s5,~N_FLAG        ; P_REG: N Flag Reset
  or s5,t0               ; P_REG: N Flag = Result MSB
  beqz s2,DEY6502        ; IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          ; P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        ; P_REG: Z Flag Reset
  DEY6502:
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $89 UNUSED OPCODE           No Operation
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $8A TXA                     Transfer Index Register X To Accumulator
  andi s0,s1,$FF         ; A_REG: Set To Index Register X (8-Bit)
  andi t0,s0,$80         ; Test Negative MSB
  andi s5,~N_FLAG        ; P_REG: N Flag Reset
  or s5,t0               ; P_REG: N Flag = Result MSB
  beqz s0,TXA6502        ; IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          ; P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        ; P_REG: Z Flag Reset
  TXA6502:
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $8B UNUSED OPCODE           No Operation
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $8C STY   nnnn              Store Index Register Y To Memory Absolute
  addu a2,a0,s3          ; Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          ; DB_REG:MEM: Set To Index Register Y (8-Bit)
  sll t0,s7,16
  addu a2,t0
  sb s2,0(a2)
  addiu s3,2             ; PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             ; Cycles += 4 (Delay Slot)

  align 256
  ; $8D STA   nnnn              Store Accumulator To Memory Absolute
  addu a2,a0,s3          ; Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          ; DB_REG:MEM: Set To Accumulator (8-Bit)
  sll t0,s7,16
  addu a2,t0
  sb s0,0(a2)
  addiu s3,2             ; PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             ; Cycles += 4 (Delay Slot)

  align 256
  ; $8E STX   nnnn              Store Index Register X To Memory Absolute
  addu a2,a0,s3          ; Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          ; DB_REG:MEM: Set To Index Register X (8-Bit)
  sll t0,s7,16
  addu a2,t0
  sb s1,0(a2)
  addiu s3,2             ; PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             ; Cycles += 4 (Delay Slot)

  align 256
  ; $8F ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $90 BCC   nn                Branch IF Carry Clear
  andi t0,s5,C_FLAG      ; P_REG: Test C Flag
  bnez t0,BCC6502        ; IF (C Flag != 0) Carry Set
  addiu s3,1             ; PC_REG++ (Increment Program Counter) (Delay Slot)
  addu a2,a0,s3          ; Load Signed 8-Bit Relative Address
  lb t0,-1(a2)
  add s3,t0              ; PC_REG: Set To 8-Bit Relative Address
  addiu v0,1             ; Cycles++
  BCC6502:
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $91 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $92 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $93 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $94 STY   nn,X              Store Index Register Y To Memory Direct Page Indexed, X
  addu a2,a0,s3          ; Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          ; D_REG+MEM+X_REG: Set To Index Register Y (8-Bit)
  addu a2,s6
  addu a2,s1
  sb s2,0(a2)
  addiu s3,1             ; PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             ; Cycles += 4 (Delay Slot)

  align 256
  ; $95 STA   nn,X              Store Accumulator To Memory Direct Page Indexed, X
  addu a2,a0,s3          ; Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          ; D_REG+MEM+X_REG: Set To Accumulator (8-Bit)
  addu a2,s6
  addu a2,s1
  sb s0,0(a2)
  addiu s3,1             ; PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             ; Cycles += 4 (Delay Slot)

  align 256
  ; $96 STX   nn,Y              Store Index Register X To Memory Direct Page Indexed, Y
  addu a2,a0,s3          ; Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          ; D_REG+MEM+Y_REG: Set To Index Register X (8-Bit)
  addu a2,s6
  addu a2,s2
  sb s1,0(a2)
  addiu s3,1             ; PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             ; Cycles += 4 (Delay Slot)

  align 256
  ; $97 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $98 TYA                     Transfer Index Register Y To Accumulator
  andi s0,s2,$FF         ; A_REG: Set To Index Register Y (8-Bit)
  andi t0,s0,$80         ; Test Negative MSB
  andi s5,~N_FLAG        ; P_REG: N Flag Reset
  or s5,t0               ; P_REG: N Flag = Result MSB
  beqz s0,TYA6502        ; IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          ; P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        ; P_REG: Z Flag Reset
  TYA6502:
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $99 STA   nnnn,Y            Store Accumulator To Memory Absolute Indexed, Y
  addu a2,a0,s3          ; Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          ; DB_REG:MEM+Y_REG: Set To Accumulator (8-Bit)
  sll t0,s7,16
  addu a2,t0
  addu a2,s2
  sb s0,0(a2)
  addiu s3,2             ; PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             ; Cycles += 5 (Delay Slot)

  align 256
  ; $9A TXS                     Transfer Index Register X To Stack Pointer
  andi s4,s1,$FF         ; S_REG: Set To Index Register X (8-Bit)
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $9B UNUSED OPCODE           No Operation
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $9C UNUSED OPCODE           No Operation
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $9D STA   nnnn,X            Store Accumulator To Memory Absolute Indexed, X
  addu a2,a0,s3          ; Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          ; DB_REG:MEM+X_REG: Set To Accumulator (8-Bit)
  sll t0,s7,16
  addu a2,t0
  addu a2,s1
  sb s0,0(a2)
  addiu s3,2             ; PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             ; Cycles += 5 (Delay Slot)

  align 256
  ; $9E UNUSED OPCODE           No Operation
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $9F ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $A0 LDY   #nn               Load Index Register Y From Memory Immediate
  addu a2,a0,s3          ; Y_REG: Set To 8-Bit Immediate
  lbu s2,0(a2)
  andi t0,s2,$80         ; Test Negative MSB
  andi s5,~N_FLAG        ; P_REG: N Flag Reset
  or s5,t0               ; P_REG: N Flag = Result MSB
  beqz s2,LDYIMM6502     ; IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          ; P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        ; P_REG: Z Flag Reset
  LDYIMM6502:
  addiu s3,1             ; PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $A1 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $A2 LDX   #nn               Load Index Register X From Memory Immediate
  addu a2,a0,s3          ; X_REG: Set To 8-Bit Immediate
  lbu s1,0(a2)
  andi t0,s1,$80         ; Test Negative MSB
  andi s5,~N_FLAG        ; P_REG: N Flag Reset
  or s5,t0               ; P_REG: N Flag = Result MSB
  beqz s1,LDXIMM6502     ; IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          ; P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        ; P_REG: Z Flag Reset
  LDXIMM6502:
  addiu s3,1             ; PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $A3 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $A4 LDY   nn                Load Index Register Y From Memory Direct Page
  addu a2,a0,s3          ; Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          ; Y_REG: Set To D_REG+MEM (8-Bit)
  addu a2,s6
  lbu s2,0(a2)
  andi t0,s2,$80         ; Test Negative MSB
  andi s5,~N_FLAG        ; P_REG: N Flag Reset
  or s5,t0               ; P_REG: N Flag = Result MSB
  beqz s2,LDYDP6502      ; IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          ; P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        ; P_REG: Z Flag Reset
  LDYDP6502:
  addiu s3,1             ; PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,3             ; Cycles += 3 (Delay Slot)

  align 256
  ; $A5 LDA   nn                Load Accumulator From Memory Direct Page
  addu a2,a0,s3          ; Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          ; A_REG: Set To D_REG+MEM (8-Bit)
  addu a2,s6
  lbu s0,0(a2)
  andi t0,s0,$80         ; Test Negative MSB
  andi s5,~N_FLAG        ; P_REG: N Flag Reset
  or s5,t0               ; P_REG: N Flag = Result MSB
  beqz s0,LDADP6502      ; IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          ; P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        ; P_REG: Z Flag Reset
  LDADP6502:
  addiu s3,1             ; PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,3             ; Cycles += 3 (Delay Slot)

  align 256
  ; $A6 LDX   nn                Load Index Register X From Memory Direct Page
  addu a2,a0,s3          ; Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          ; X_REG: Set To D_REG+MEM (8-Bit)
  addu a2,s6
  lbu s1,0(a2)
  andi t0,s1,$80         ; Test Negative MSB
  andi s5,~N_FLAG        ; P_REG: N Flag Reset
  or s5,t0               ; P_REG: N Flag = Result MSB
  beqz s1,LDXDP6502      ; IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          ; P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        ; P_REG: Z Flag Reset
  LDXDP6502:
  addiu s3,1             ; PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,3             ; Cycles += 3 (Delay Slot)

  align 256
  ; $A7 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $A8 TAY                     Transfer Accumulator To Index Register Y
  andi s2,s0,$FF         ; Y_REG: Set To Accumulator (8-Bit)
  andi t0,s2,$80         ; Test Negative MSB
  andi s5,~N_FLAG        ; P_REG: N Flag Reset
  or s5,t0               ; P_REG: N Flag = Result MSB
  beqz s2,TAY6502        ; IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          ; P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        ; P_REG: Z Flag Reset
  TAY6502:
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $A9 LDA   #nn               Load Accumulator From Memory Immediate
  addu a2,a0,s3          ; A_REG: Set To 8-Bit Immediate
  lbu s0,0(a2)
  andi t0,s0,$80         ; Test Negative MSB
  andi s5,~N_FLAG        ; P_REG: N Flag Reset
  or s5,t0               ; P_REG: N Flag = Result MSB
  beqz s0,LDAIMM6502     ; IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          ; P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        ; P_REG: Z Flag Reset
  LDAIMM6502:
  addiu s3,1             ; PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $AA TAX                     Transfer Accumulator To Index Register X
  andi s1,s0,$FF         ; X_REG: Set To Accumulator (8-Bit)
  andi t0,s1,$80         ; Test Negative MSB
  andi s5,~N_FLAG        ; P_REG: N Flag Reset
  or s5,t0               ; P_REG: N Flag = Result MSB
  beqz s1,TAX6502        ; IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          ; P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        ; P_REG: Z Flag Reset
  TAX6502:
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $AB UNUSED OPCODE           No Operation
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $AC LDY   nnnn              Load Index Register Y From Memory Absolute
  addu a2,a0,s3          ; Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          ; Y_REG: Set To DB_REG:MEM (8-Bit)
  sll t0,s7,16
  addu a2,t0
  lbu s2,0(a2)
  andi t0,s2,$80         ; Test Negative MSB
  andi s5,~N_FLAG        ; P_REG: N Flag Reset
  or s5,t0               ; P_REG: N Flag = Result MSB
  beqz s2,LDYABS6502     ; IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          ; P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        ; P_REG: Z Flag Reset
  LDYABS6502:
  addiu s3,2             ; PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             ; Cycles += 4 (Delay Slot)

  align 256
  ; $AD LDA   nnnn              Load Accumulator From Memory Absolute
  addu a2,a0,s3          ; Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          ; A_REG: Set To DB_REG:MEM (8-Bit)
  sll t0,s7,16
  addu a2,t0
  lbu s0,0(a2)
  andi t0,s0,$80         ; Test Negative MSB
  andi s5,~N_FLAG        ; P_REG: N Flag Reset
  or s5,t0               ; P_REG: N Flag = Result MSB
  beqz s0,LDAABS6502     ; IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          ; P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        ; P_REG: Z Flag Reset
  LDAABS6502:
  addiu s3,2             ; PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             ; Cycles += 4 (Delay Slot)

  align 256
  ; $AE LDX   nnnn              Load Index Register X From Memory Absolute
  addu a2,a0,s3          ; Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          ; X_REG: Set To DB_REG:MEM (8-Bit)
  sll t0,s7,16
  addu a2,t0
  lbu s1,0(a2)
  andi t0,s1,$80         ; Test Negative MSB
  andi s5,~N_FLAG        ; P_REG: N Flag Reset
  or s5,t0               ; P_REG: N Flag = Result MSB
  beqz s1,LDXABS6502     ; IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          ; P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        ; P_REG: Z Flag Reset
  LDXABS6502:
  addiu s3,2             ; PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             ; Cycles += 4 (Delay Slot)

  align 256
  ; $AF ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $B0 BCS   nn                Branch IF Carry Set
  andi t0,s5,C_FLAG      ; P_REG: Test C Flag
  beqz t0,BCS6502        ; IF (C Flag == 0) Carry Clear
  addiu s3,1             ; PC_REG++ (Increment Program Counter) (Delay Slot)
  addu a2,a0,s3          ; Load Signed 8-Bit Relative Address
  lb t0,-1(a2)
  add s3,t0              ; PC_REG: Set To 8-Bit Relative Address
  addiu v0,1             ; Cycles++
  BCS6502:
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $B1 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $B2 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $B3 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $B4 LDY   nn,X              Load Index Register Y From Memory Direct Page Indexed, X
  addu a2,a0,s3          ; Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          ; Y_REG: Set To D_REG+MEM+X_REG (8-Bit)
  addu a2,s6
  addu a2,s1
  lbu s2,0(a2)
  andi t0,s2,$80         ; Test Negative MSB
  andi s5,~N_FLAG        ; P_REG: N Flag Reset
  or s5,t0               ; P_REG: N Flag = Result MSB
  beqz s2,LDYDPX6502     ; IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          ; P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        ; P_REG: Z Flag Reset
  LDYDPX6502:
  addiu s3,1             ; PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             ; Cycles += 4 (Delay Slot)

  align 256
  ; $B5 LDA   nn,X              Load Accumulator From Memory Direct Page Indexed, X
  addu a2,a0,s3          ; Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          ; A_REG: Set To D_REG+MEM+X_REG (8-Bit)
  addu a2,s6
  addu a2,s1
  lbu s0,0(a2)
  andi t0,s0,$80         ; Test Negative MSB
  andi s5,~N_FLAG        ; P_REG: N Flag Reset
  or s5,t0               ; P_REG: N Flag = Result MSB
  beqz s0,LDADPX6502     ; IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          ; P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        ; P_REG: Z Flag Reset
  LDADPX6502:
  addiu s3,1             ; PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             ; Cycles += 4 (Delay Slot)

  align 256
  ; $B6 LDX   nn,Y              Load Index Register X From Memory Direct Page Indexed, Y
  addu a2,a0,s3          ; Load 8-Bit Address
  lbu t0,0(a2)
  addu a2,a0,t0          ; X_REG: Set To D_REG+MEM+Y_REG (8-Bit)
  addu a2,s6
  addu a2,s2
  lbu s1,0(a2)
  andi t0,s1,$80         ; Test Negative MSB
  andi s5,~N_FLAG        ; P_REG: N Flag Reset
  or s5,t0               ; P_REG: N Flag = Result MSB
  beqz s1,LDXDPY6502     ; IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          ; P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        ; P_REG: Z Flag Reset
  LDXDPY6502:
  addiu s3,1             ; PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,4             ; Cycles += 4 (Delay Slot)

  align 256
  ; $B7 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $B8 CLV                     Clear Overflow Flag
  andi s5,~V_FLAG        ; P_REG: V Flag Reset
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $B9 LDA   nnnn,Y            Load Accumulator From Memory Absolute Indexed, Y
  addu a2,a0,s3          ; Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          ; A_REG: Set To DB_REG:MEM+Y_REG (8-Bit)
  sll t0,s7,16
  addu a2,t0
  addu a2,s2
  lbu s0,0(a2)
  andi t0,s0,$80         ; Test Negative MSB
  andi s5,~N_FLAG        ; P_REG: N Flag Reset
  or s5,t0               ; P_REG: N Flag = Result MSB
  beqz s0,LDAABSY6502    ; IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          ; P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        ; P_REG: Z Flag Reset
  LDAABSY6502:
  addiu s3,2             ; PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             ; Cycles += 4 (Delay Slot)

  align 256
  ; $BA TSX                     Transfer Stack Pointer To Index Register X
  andi s1,s4,$FF         ; X_REG: Set To Stack Pointer (8-Bit)
  andi t0,s1,$80         ; Test Negative MSB
  andi s5,~N_FLAG        ; P_REG: N Flag Reset
  or s5,t0               ; P_REG: N Flag = Result MSB
  beqz s1,TSX6502        ; IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          ; P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        ; P_REG: Z Flag Reset
  TSX6502:
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $BB UNUSED OPCODE           No Operation
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $BC LDY   nnnn,X            Load Index Register Y From Memory Absolute Indexed, X
  addu a2,a0,s3          ; Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          ; Y_REG: Set To DB_REG:MEM+X_REG (8-Bit)
  sll t0,s7,16
  addu a2,t0
  addu a2,s1
  lbu s2,0(a2)
  andi t0,s2,$80         ; Test Negative MSB
  andi s5,~N_FLAG        ; P_REG: N Flag Reset
  or s5,t0               ; P_REG: N Flag = Result MSB
  beqz s2,LDYABSX6502    ; IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          ; P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        ; P_REG: Z Flag Reset
  LDYABSX6502:
  addiu s3,2             ; PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             ; Cycles += 4 (Delay Slot)

  align 256
  ; $BD LDA   nnnn,X            Load Accumulator From Memory Absolute Indexed, X
  addu a2,a0,s3          ; Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          ; A_REG: Set To DB_REG:MEM+X_REG (8-Bit)
  sll t0,s7,16
  addu a2,t0
  addu a2,s1
  lbu s0,0(a2)
  andi t0,s0,$80         ; Test Negative MSB
  andi s5,~N_FLAG        ; P_REG: N Flag Reset
  or s5,t0               ; P_REG: N Flag = Result MSB
  beqz s0,LDAABSX6502    ; IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          ; P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        ; P_REG: Z Flag Reset
  LDAABSX6502:
  addiu s3,2             ; PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             ; Cycles += 4 (Delay Slot)

  align 256
  ; $BE LDX   nnnn,Y            Load Index Register X From Memory Absolute Indexed, Y
  addu a2,a0,s3          ; Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          ; X_REG: Set To DB_REG:MEM+Y_REG (8-Bit)
  sll t0,s7,16
  addu a2,t0
  addu a2,s2
  lbu s1,0(a2)
  andi t0,s1,$80         ; Test Negative MSB
  andi s5,~N_FLAG        ; P_REG: N Flag Reset
  or s5,t0               ; P_REG: N Flag = Result MSB
  beqz s1,LDXABSY6502    ; IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          ; P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        ; P_REG: Z Flag Reset
  LDXABSY6502:
  addiu s3,2             ; PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,4             ; Cycles += 4 (Delay Slot)

  align 256
  ; $BF ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $C0 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $C1 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $C2 REP   #nn               Reset Status Bits
  addu a2,a0,s3          ; Load 8-Bit Immediate
  lbu t0,0(a2)           ; Reset Bits
  andi t0,~(B_FLAG+U_FLAG) ; Ignore Break & Unused Flags (6502 Emulation Mode)
  xori t0,$FF            ; Convert 8-Bit Immediate To Reset Bits
  ori t0,E_FLAG          ; Preserve Emulation Flag
  and s5,t0              ; P_REG: 8-Bit Immediate Flags Reset
  addiu s3,1             ; PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,3             ; Cycles += 3 (Delay Slot)

  align 256
  ; $C3 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $C4 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $C5 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $C6 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $C7 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $C8 INY                     Increment Index Register Y
  addiu s2,1             ; Y_REG: Set To Index Register Y++ (8-Bit)
  andi s2,$FF
  andi t0,s2,$80         ; Test Negative MSB
  andi s5,~N_FLAG        ; P_REG: N Flag Reset
  or s5,t0               ; P_REG: N Flag = Result MSB
  beqz s2,INY6502        ; IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          ; P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        ; P_REG: Z Flag Reset
  INY6502:
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $C9 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $CA DEX                     Decrement Index Register X
  subiu s1,1             ; X_REG: Set To Index Register X-- (8-Bit)
  andi s1,$FF
  andi t0,s1,$80         ; Test Negative MSB
  andi s5,~N_FLAG        ; P_REG: N Flag Reset
  or s5,t0               ; P_REG: N Flag = Result MSB
  beqz s1,DEX6502        ; IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          ; P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        ; P_REG: Z Flag Reset
  DEX6502:
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $CB ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $CC ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $CD ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $CE ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $CF ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $D0 BNE   nn                Branch IF Not Equal
  andi t0,s5,Z_FLAG      ; P_REG: Test Z Flag
  bnez t0,BNE6502        ; IF (Z Flag != 0) Equal
  addiu s3,1             ; PC_REG++ (Increment Program Counter) (Delay Slot)
  addu a2,a0,s3          ; Load Signed 8-Bit Relative Address
  lb t0,-1(a2)
  add s3,t0              ; PC_REG: Set To 8-Bit Relative Address
  addiu v0,1             ; Cycles++
  BNE6502:
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $D1 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $D2 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $D3 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $D4 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $D5 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $D6 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $D7 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $D8 CLD                     Clear Decimal Mode Flag
  andi s5,~D_FLAG        ; P_REG: D Flag Reset
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $D9 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $DA UNUSED OPCODE           No Operation
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $DB ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $DC ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $DD ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $DE ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $DF ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $E0 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $E1 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $E2 SEP   #nn               Set Status Bits
  addu a2,a0,s3          ; Load 8-Bit Immediate
  lbu t0,0(a2)           ; Set Bits
  andi t0,~(B_FLAG+U_FLAG) ; Ignore Break & Unused Flags (6502 Emulation Mode)
  or s5,t0               ; P_REG: 8-Bit Immediate Flags Set
  addiu s3,1             ; PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,3             ; Cycles += 3 (Delay Slot)

  align 256
  ; $E3 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $E4 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $E5 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $E6 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $E7 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $E8 INX                     Increment Index Register X
  addiu s1,1             ; X_REG: Set To Index Register X++ (8-Bit)
  andi s1,$FF
  andi t0,s1,$80         ; Test Negative MSB
  andi s5,~N_FLAG        ; P_REG: N Flag Reset
  or s5,t0               ; P_REG: N Flag = Result MSB
  beqz s1,INX6502        ; IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          ; P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        ; P_REG: Z Flag Reset
  INX6502:
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $E9 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $EA NOP                     No Operation
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $EB UNUSED OPCODE           No Operation
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $EC ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $ED ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $EE ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $EF ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $F0 BEQ   nn                Branch IF Equal
  andi t0,s5,Z_FLAG      ; P_REG: Test Z Flag
  beqz t0,BEQ6502        ; IF (Z Flag == 0) Not Equal
  addiu s3,1             ; PC_REG++ (Increment Program Counter) (Delay Slot)
  addu a2,a0,s3          ; Load Signed 8-Bit Relative Address
  lb t0,-1(a2)
  add s3,t0              ; PC_REG: Set To 8-Bit Relative Address
  addiu v0,1             ; Cycles++
  BEQ6502:
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $F1 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $F2 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $F3 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $F4 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $F5 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $F6 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $F7 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $F8 SED                     Set Decimal Mode Flag
  ori s5,D_FLAG          ; P_REG: D Flag Set
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $F9 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $FA UNUSED OPCODE           No Operation
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $FB XCE                     Exchange Carry & Emulation Bits
  andi t0,s5,C_FLAG      ; P_REG: C Flag
  andi t1,s5,E_FLAG      ; P_REG: E Flag
  sll t0,8               ; C Flag -> E Flag
  srl t1,8               ; E Flag -> C Flag
  or t1,t0               ; C + E Flag
  andi s5,~(C_FLAG+E_FLAG) ; P_REG: C + E Flag Reset
  or s5,t1               ; P_REG: Exchange Carry & Emulation Bits
  beqz t0,XCE6502        ; IF (E Flag == 0) Native Mode
  ori s5,M_FLAG+X_FLAG   ; P_REG: M + X Flag Set (Delay Slot)
  andi s5,~(M_FLAG+X_FLAG) ; P_REG: M + X Flag Reset
  andi s1,$FF            ; X_REG = X_REG Low Byte
  andi s2,$FF            ; Y_REG = Y_REG Low Byte
  andi s4,$FF            ; S_REG = S_REG Low Byte
  XCE6502:
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $FC ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $FD ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $FE ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $FF ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)