  align 256
  ; $00 BRK   #nn               Software Break
  addu a2,a0,s4          ; STACK = PB_REG (8-Bit)
  sb s8,0(a2)
  subiu s4,1             ; S_REG-- (Decrement Stack)
  andi s4,$FFFF
  addiu s3,1             ; PC_REG++ (Increment Program Counter)
  addu a2,a0,s4          ; STACK = PC_REG (16-Bit)
  sb s3,-1(a2)
  srl t0,s3,8
  sb t0,0(a2)
  subiu s4,2             ; S_REG -= 2 (Decrement Stack)
  andi s4,$FFFF
  addu a2,a0,s4          ; STACK = P_REG (8-Bit)
  sb s5,0(a2)
  subiu s4,1             ; S_REG-- (Decrement Stack)
  andi s4,$FFFF
  ori s5,I_FLAG          ; P_REG: I Flag Set
  andi s5,~D_FLAG        ; P_REG: D Flag Reset (65816 Native Mode)
  and s8,r0              ; PB_REG = 0 (65816 Native Mode)
  lbu t0,BRK1_VEC+1(a0)  ; PC_REG: Set To 65816 Break Vector ($FFE6)
  sll t0,8
  lbu s3,BRK1_VEC(a0)
  or s3,t0
  jr ra
  addiu v0,8             ; Cycles += 8 (Delay Slot)

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
  ; $04 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $05 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $06 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $07 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $08 PHP                     Push Processor Status Register
  addu a2,a0,s4          ; STACK = P_REG (8-Bit)
  sb s5,0(a2)
  subiu s4,1             ; S_REG-- (Decrement Stack)
  andi s4,$FFFF
  jr ra
  addiu v0,3             ; Cycles += 3 (Delay Slot)

  align 256
  ; $09 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $0A ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $0B PHD                     Push Direct Page Register
  addu a2,a0,s4          ; STACK = D_REG (16-Bit)
  sb s6,-1(a2)
  srl t0,s6,8
  sb t0,0(a2)
  subiu s4,2             ; S_REG -= 2 (Decrement Stack)
  andi s4,$FFFF
  jr ra
  addiu v0,4             ; Cycles += 4 (Delay Slot)

  align 256
  ; $0C ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $0D ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $0E ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $0F ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $10 BPL   nn                Branch IF Plus
  andi t0,s5,N_FLAG      ; P_REG: Test N Flag
  bnez t0,BPLM0X1        ; IF (N Flag != 0) Minus
  addiu s3,1             ; PC_REG++ (Increment Program Counter) (Delay Slot)
  addu a2,a0,s3          ; Load Signed 8-Bit Relative Address
  lb t0,-1(a2)
  add s3,t0              ; PC_REG: Set To 8-Bit Relative Address
  addiu v0,1             ; Cycles++
  BPLM0X1:
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
  ; $14 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $15 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $16 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

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
  ; $1A ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $1B TCS                     Transfer Accumulator To Stack Pointer
  andi s4,s0,$FFFF       ; S_REG: Set To Accumulator (16-Bit)
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $1C ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $1D ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $1E ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

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
  ; $24 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

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
  andi s4,$FFFF
  addu a2,a0,s4          ; P_REG = STACK (8-Bit)
  lbu s5,0(a2)
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
  ; $2B PLD                     Pull Direct Page Register
  addiu s4,2             ; S_REG += 2 (Increment Stack)
  andi s4,$FFFF
  addu a2,a0,s4          ; D_REG = STACK (16-Bit)
  lbu t0,0(a2)
  sll t0,8
  lbu s6,-1(a2)
  or s6,t0
  andi t0,s6,$8000       ; Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        ; P_REG: N Flag Reset
  or s5,t0               ; P_REG: N Flag = Result MSB 
  beqz s6,PLDM0X1        ; IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          ; P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        ; P_REG: Z Flag Reset
  PLDM0X1:
  jr ra
  addiu v0,5             ; Cycles += 5 (Delay Slot)

  align 256
  ; $2C ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

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
  beqz t0,BMIM0X1        ; IF (N Flag == 0) Plus
  addiu s3,1             ; PC_REG++ (Increment Program Counter) (Delay Slot)
  addu a2,a0,s3          ; Load Signed 8-Bit Relative Address
  lb t0,-1(a2)
  add s3,t0              ; PC_REG: Set To 8-Bit Relative Address
  addiu v0,1             ; Cycles++
  BMIM0X1:
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
  ; $34 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

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
  ; $3A DEA                     Decrement Accumulator
  subiu s0,1             ; A_REG: Set To Accumulator-- (8-Bit)
  andi s0,$FF
  andi t0,s0,$80         ; Test Negative MSB
  andi s5,~N_FLAG        ; P_REG: N Flag Reset
  or s5,t0               ; P_REG: N Flag = Result MSB 
  beqz s0,DEAM0X1        ; IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          ; P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        ; P_REG: Z Flag Reset
  DEAM0X1:
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $3B TSC                     Transfer Stack Pointer To 16-Bit Accumulator
  andi s0,s4,$FFFF       ; A_REG: Set To Stack Pointer (16-Bit)
  andi t0,s0,$8000       ; Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        ; P_REG: N Flag Reset
  or s5,t0               ; P_REG: N Flag = Result MSB 
  beqz s0,TSCM0X1        ; IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          ; P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        ; P_REG: Z Flag Reset
  TSCM0X1:
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $3C ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

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
  ; $42 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

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
  addu a2,a0,s4          ; STACK = A_REG (16-Bit)
  sb s0,-1(a2)
  srl t0,s0,8
  sb t0,0(a2)
  subiu s4,2             ; S_REG -= 2 (Decrement Stack)
  andi s4,$FFFF
  jr ra
  addiu v0,4             ; Cycles += 4 (Delay Slot)

  align 256
  ; $49 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $4A ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $4B PHK                     Push Program Bank Register
  addu a2,a0,s4          ; STACK = PB_REG (8-Bit)
  sb s8,0(a2)
  subiu s4,1             ; S_REG-- (Decrement Stack)
  andi s4,$FFFF
  jr ra
  addiu v0,3             ; Cycles += 3 (Delay Slot)

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
  bnez t0,BVCM0X1        ; IF (V Flag != 0) Overflow Set
  addiu s3,1             ; PC_REG++ (Increment Program Counter) (Delay Slot)
  addu a2,a0,s3          ; Load Signed 8-Bit Relative Address
  lb t0,-1(a2)
  add s3,t0              ; PC_REG: Set To 8-Bit Relative Address
  addiu v0,1             ; Cycles++
  BVCM0X1:
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
  ; $5A PHY                     Push Index Register Y
  addu a2,a0,s4          ; STACK = Y_REG (8-Bit)
  sb s2,0(a2)
  subiu s4,1             ; S_REG-- (Decrement Stack)
  andi s4,$FFFF
  jr ra
  addiu v0,3             ; Cycles += 3 (Delay Slot)

  align 256
  ; $5B TCD                     Transfer 16-Bit Accumulator To Direct Page Register
  andi s6,s0,$FFFF       ; D_REG: Set To 16-Bit Accumulator (16-Bit)
  andi t0,s6,$8000       ; Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        ; P_REG: N Flag Reset
  or s5,t0               ; P_REG: N Flag = Result MSB 
  beqz s6,TCDM0X1        ; IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          ; P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        ; P_REG: Z Flag Reset
  TCDM0X1:
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
  ; $64 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

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
  addiu s4,2             ; S_REG += 2 (Increment Stack)
  andi s4,$FFFF
  addu a2,a0,s4          ; A_REG = STACK (16-Bit)
  lbu t0,0(a2)
  sll t0,8
  lbu s0,-1(a2)
  or s0,t0
  andi t0,s0,$8000       ; Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        ; P_REG: N Flag Reset
  or s5,t0               ; P_REG: N Flag = Result MSB 
  beqz s0,PLAM0X1        ; IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          ; P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        ; P_REG: Z Flag Reset
  PLAM0X1:
  jr ra
  addiu v0,5             ; Cycles += 5 (Delay Slot)

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
  beqz t0,BVSM0X1        ; IF (V Flag == 0) Overflow Clear
  addiu s3,1             ; PC_REG++ (Increment Program Counter) (Delay Slot)
  addu a2,a0,s3          ; Load Signed 8-Bit Relative Address
  lb t0,-1(a2)
  add s3,t0              ; PC_REG: Set To 8-Bit Relative Address
  addiu v0,1             ; Cycles++
  BVSM0X1:
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
  ; $74 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

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
  ; $7A PLY                     Pull Index Register Y From Stack
  addiu s4,1             ; S_REG++ (Increment Stack)
  andi s4,$FFFF
  addu a2,a0,s4          ; Y_REG = STACK (8-Bit)
  lbu s2,0(a2)
  andi t0,s2,$80         ; Test Negative MSB
  andi s5,~N_FLAG        ; P_REG: N Flag Reset
  or s5,t0               ; P_REG: N Flag = Result MSB 
  beqz s2,PLYM0X1        ; IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          ; P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        ; P_REG: Z Flag Reset
  PLYM0X1:
  jr ra
  addiu v0,4             ; Cycles += 4 (Delay Slot)

  align 256
  ; $7B TDC                     Transfer Direct Page Register To 16-Bit Accumulator
  andi s0,s6,$FFFF       ; A_REG: Set To Direct Page Register (16-Bit)
  andi t0,s0,$8000       ; Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        ; P_REG: N Flag Reset
  or s5,t0               ; P_REG: N Flag = Result MSB 
  beqz s0,TDCM0X1        ; IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          ; P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        ; P_REG: Z Flag Reset
  TDCM0X1:
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
  ; $84 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $85 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $86 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

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
  beqz s2,DEYM0X1        ; IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          ; P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        ; P_REG: Z Flag Reset
  DEYM0X1:
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $89 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $8A TXA                     Transfer Index Register X To Accumulator
  andi s0,s1,$FF         ; A_REG: Set To Index Register X (8-Bit)
  andi t0,s0,$80         ; Test Negative MSB
  andi s5,~N_FLAG        ; P_REG: N Flag Reset
  or s5,t0               ; P_REG: N Flag = Result MSB 
  beqz s0,TXAM0X1        ; IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          ; P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        ; P_REG: Z Flag Reset
  TXAM0X1:
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $8B PHB                     Push Data Bank Register
  addu a2,a0,s4          ; STACK = DB_REG (8-Bit)
  sb s7,0(a2)
  subiu s4,1             ; S_REG-- (Decrement Stack)
  andi s4,$FFFF
  jr ra
  addiu v0,3             ; Cycles += 3 (Delay Slot)

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
  addu a2,a0,t0          ; DB_REG:MEM: Set To Accumulator (16-Bit)
  sll t0,s7,16
  addu a2,t0
  sb s0,0(a2)
  srl t0,s0,8
  sb t0,1(a2)
  addiu s3,2             ; PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             ; Cycles += 5 (Delay Slot)

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
  bnez t0,BCCM0X1        ; IF (C Flag != 0) Carry Set
  addiu s3,1             ; PC_REG++ (Increment Program Counter) (Delay Slot)
  addu a2,a0,s3          ; Load Signed 8-Bit Relative Address
  lb t0,-1(a2)
  add s3,t0              ; PC_REG: Set To 8-Bit Relative Address
  addiu v0,1             ; Cycles++
  BCCM0X1:
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
  ; $94 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $95 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $96 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

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
  beqz s0,TYAM0X1        ; IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          ; P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        ; P_REG: Z Flag Reset
  TYAM0X1:
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $99 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $9A TXS                     Transfer Index Register X To Stack Pointer
  andi s4,s1,$FF         ; S_REG: Set To Index Register X (8-Bit)
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $9B TXY                     Transfer Index Register X To Y
  andi s2,s1,$FF         ; Y_REG: Set To Index Register X (8-Bit)
  andi t0,s2,$80         ; Test Negative MSB
  andi s5,~N_FLAG        ; P_REG: N Flag Reset
  or s5,t0               ; P_REG: N Flag = Result MSB 
  beqz s2,TXYM0X1        ; IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          ; P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        ; P_REG: Z Flag Reset
  TXYM0X1:
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $9C STZ   nnnn              Store Zero To Memory Absolute
  addu a2,a0,s3          ; Load 16-Bit Address
  lbu t0,1(a2)
  sll t0,8
  lbu t1,0(a2)
  or t0,t1
  addu a2,a0,t0          ; DB_REG:MEM: Set To Zero (16-Bit)
  sll t0,s7,16
  addu a2,t0
  sb r0,0(a2)
  sb r0,1(a2)
  addiu s3,2             ; PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,5             ; Cycles += 5 (Delay Slot)

  align 256
  ; $9D ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $9E ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

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
  beqz s2,LDYABSM0X1     ; IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          ; P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        ; P_REG: Z Flag Reset
  LDYABSM0X1:
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
  beqz s1,LDXABSM0X1     ; IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          ; P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        ; P_REG: Z Flag Reset
  LDXABSM0X1:
  addiu s3,1             ; PC_REG++ (Increment Program Counter)
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $A3 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $A4 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $A5 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $A6 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

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
  beqz s2,TAYM0X1        ; IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          ; P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        ; P_REG: Z Flag Reset
  TAYM0X1:
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $A9 LDA   #nnnn             Load Accumulator From Memory Immediate
  addu a2,a0,s3          ; A_REG: Set To 16-Bit Immediate
  lbu t0,1(a2)
  sll t0,8
  lbu s0,0(a2)
  or s0,t0
  andi t0,s0,$8000       ; Test Negative MSB
  srl t0,8
  andi s5,~N_FLAG        ; P_REG: N Flag Reset
  or s5,t0               ; P_REG: N Flag = Result MSB 
  beqz s0,LDAABSM0X1     ; IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          ; P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        ; P_REG: Z Flag Reset
  LDAABSM0X1:
  addiu s3,2             ; PC_REG += 2 (Increment Program Counter)
  jr ra
  addiu v0,3             ; Cycles += 3 (Delay Slot)

  align 256
  ; $AA TAX                     Transfer Accumulator To Index Register X
  andi s1,s0,$FF         ; X_REG: Set To Accumulator (8-Bit)
  andi t0,s1,$80         ; Test Negative MSB
  andi s5,~N_FLAG        ; P_REG: N Flag Reset
  or s5,t0               ; P_REG: N Flag = Result MSB 
  beqz s1,TAXM0X1        ; IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          ; P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        ; P_REG: Z Flag Reset
  TAXM0X1:
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $AB PLB                     Pull Data Bank Register
  addiu s4,1             ; S_REG++ (Increment Stack)
  andi s4,$FFFF
  addu a2,a0,s4          ; DB_REG = STACK (8-Bit)
  lbu s7,0(a2)
  andi t0,s7,$80         ; Test Negative MSB
  andi s5,~N_FLAG        ; P_REG: N Flag Reset
  or s5,t0               ; P_REG: N Flag = Result MSB 
  beqz s7,PLBM0X1        ; IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          ; P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        ; P_REG: Z Flag Reset
  PLBM0X1:
  jr ra
  addiu v0,4             ; Cycles += 4 (Delay Slot)

  align 256
  ; $AC ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $AD ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $AE ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $AF ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $B0 BCS   nn                Branch IF Carry Set
  andi t0,s5,C_FLAG      ; P_REG: Test C Flag
  beqz t0,BCSM0X1        ; IF (C Flag == 0) Carry Clear
  addiu s3,1             ; PC_REG++ (Increment Program Counter) (Delay Slot)
  addu a2,a0,s3          ; Load Signed 8-Bit Relative Address
  lb t0,-1(a2)
  add s3,t0              ; PC_REG: Set To 8-Bit Relative Address
  addiu v0,1             ; Cycles++
  BCSM0X1:
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
  ; $B4 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $B5 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $B6 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

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
  ; $B9 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $BA TSX                     Transfer Stack Pointer To Index Register X
  andi s1,s4,$FF         ; X_REG: Set To Stack Pointer (8-Bit)
  andi t0,s1,$80         ; Test Negative MSB
  andi s5,~N_FLAG        ; P_REG: N Flag Reset
  or s5,t0               ; P_REG: N Flag = Result MSB 
  beqz s1,TSXM0X1        ; IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          ; P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        ; P_REG: Z Flag Reset
  TSXM0X1:
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $BB TYX                     Transfer Index Register Y To X
  andi s1,s2,$FF         ; X_REG: Set To Index Register Y (8-Bit)
  andi t0,s1,$80         ; Test Negative MSB
  andi s5,~N_FLAG        ; P_REG: N Flag Reset
  or s5,t0               ; P_REG: N Flag = Result MSB 
  beqz s1,TYXM0X1        ; IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          ; P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        ; P_REG: Z Flag Reset
  TYXM0X1:
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $BC ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $BD ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $BE ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

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
  ; $C8 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

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
  beqz s1,DEXM0X1        ; IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          ; P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        ; P_REG: Z Flag Reset
  DEXM0X1:
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
  bnez t0,BNEM0X1        ; IF (Z Flag != 0) Equal
  addiu s3,1             ; PC_REG++ (Increment Program Counter) (Delay Slot)
  addu a2,a0,s3          ; Load Signed 8-Bit Relative Address
  lb t0,-1(a2)
  add s3,t0              ; PC_REG: Set To 8-Bit Relative Address
  addiu v0,1             ; Cycles++
  BNEM0X1:
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
  ; $DA PHX                     Push Index Register X
  addu a2,a0,s4          ; STACK = X_REG (8-Bit)
  sb s1,0(a2)
  subiu s4,1             ; S_REG-- (Decrement Stack)
  andi s4,$FFFF
  jr ra
  addiu v0,3             ; Cycles += 3 (Delay Slot)

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
  ; $E8 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $E9 ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

  align 256
  ; $EA NOP                     No Operation
  jr ra
  addiu v0,2             ; Cycles += 2 (Delay Slot)

  align 256
  ; $EB ???   ???               ?????
  jr ra
  addiu v0,1             ; Cycles += 1 (Delay Slot)

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
  beqz t0,BEQM0X1        ; IF (Z Flag == 0) Not Equal
  addiu s3,1             ; PC_REG++ (Increment Program Counter) (Delay Slot)
  addu a2,a0,s3          ; Load Signed 8-Bit Relative Address
  lb t0,-1(a2)
  add s3,t0              ; PC_REG: Set To 8-Bit Relative Address
  addiu v0,1             ; Cycles++
  BEQM0X1:
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
  ; $FA PLX                     Pull Index Register X From Stack
  addiu s4,1             ; S_REG++ (Increment Stack)
  andi s4,$FFFF
  addu a2,a0,s4          ; X_REG = STACK (8-Bit)
  lbu s1,0(a2)
  andi t0,s1,$80         ; Test Negative MSB
  andi s5,~N_FLAG        ; P_REG: N Flag Reset
  or s5,t0               ; P_REG: N Flag = Result MSB 
  beqz s1,PLXM0X1        ; IF (Result == 0) Z Flag Set
  ori s5,Z_FLAG          ; P_REG: Z Flag Set (Delay Slot)
  andi s5,~Z_FLAG        ; P_REG: Z Flag Reset
  PLXM0X1:
  jr ra
  addiu v0,4             ; Cycles += 4 (Delay Slot)

  align 256
  ; $FB XCE                     Exchange Carry & Emulation Bits
  andi t0,s5,C_FLAG      ; P_REG: C Flag
  andi t1,s5,E_FLAG      ; P_REG: E Flag
  sll t0,8               ; C Flag -> E Flag
  srl t1,8               ; E Flag -> C Flag
  or t2,t0,t1            ; C + E Flag
  andi s5,~(C_FLAG+E_FLAG) ; P_REG: C + E Flag Reset
  or s5,t1               ; P_REG: Exchange Carry & Emulation Bits
  beqz t0,XCEM0X1        ; IF (E Flag == 0) Native Mode
  ori s5,M_FLAG+X_FLAG   ; P_REG: M + X Flag Set (Delay Slot)
  andi s5,~(M_FLAG+X_FLAG) ; P_REG: M + X Flag Reset
  andi s1,$FF            ; X_REG = X_REG Low Byte
  andi s2,$FF            ; Y_REG = Y_REG Low Byte
  andi s4,$FF            ; S_REG = S_REG Low Byte
  XCEM0X1:
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