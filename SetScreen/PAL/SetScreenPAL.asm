; N64 'Bare Metal' Set Screen PAL 16BPP 320x240 Demo by krom (Peter Lemon):

  include LIB\N64.INC ; Include N64 Definitions
  dcb 2097152,$00 ; Set ROM Size
  org $80000000 ; Entry Point Of Code
  include LIB\N64_HEADER.ASM  ; Include 64 Byte Header & Vector Table
  incbin LIB\N64_BOOTCODE.BIN ; Include 4032 Byte Boot Code

Start:
  include LIB\N64_INIT.ASM ; Include Initialisation Routine

  lui t0,$A440    ; VI Status Reg: Init Video
  li t1,2         ; Set Status/Control (Pixel Size = 2: 16BPP 5/5/5/1)
  sw t1,0(t0)     ; Store Status/Control into VI Status Reg $A4400000
  li t1,$A0000000 ; Set Origin (Frame Buffer Origin In Bytes = DRAM)
  sw t1,4(t0)     ; Store Origin into VI Origin Reg $A4400004
  li t1,320       ; Set Width (Frame Buffer Line Width In Pixels = 320)
  sw t1,8(t0)     ; Store Width into VI Width Reg $A4400008
  li t1,$200      ; Set Vertical Interrupt (Interrupt When Current Half-Line = $200)
  sw t1,12(t0)    ; Store Vertical Interupt into VI Intr Reg $A440000C
  li t1,0         ; Set Current Vertical Line (Current Half-Line, Sampled Once Per Line = 0)
  sw t1,16(t0)    ; Store Current Vertical Line into VI Current Reg $A4400010
  li t1,$404233A  ; Set Video Timing (Start Of Color Burst In Pixels from H-Sync = 4, Vertical Sync Width In Half Lines = 04, Color Burst Width In Pixels = 35, Horizontal Sync Width In Pixels = 58)
  sw t1,20(t0)    ; Store Video Timing into VI Burst Reg $A4400014
  li t1,$271      ; Set Vertical Sync (Number Of Half-Lines Per Field = 625)
  sw t1,24(t0)    ; Store Vertical Sync into VI V Sync Reg $A4400018
  li t1,$150C69   ; Set Horizontal Sync (5-bit Leap Pattern Used For PAL only = 21: %10101, Total Duration Of A Line In 1/4 Pixel = 3177)
  sw t1,28(t0)    ; Store Horizontal Sync into VI H Sync Reg $A440001C
  li t1,$C6F0C6E  ; Set Horizontal Sync Leap (Identical To H Sync = 3183, Identical To H Sync = 3182)
  sw t1,32(t0)    ; Store Horizontal Sync Leap into VI Leap Reg $A4400020
  li t1,$800300   ; Set Horizontal Video (Start Of Active Video In Screen Pixels = 128, End Of Active Video In Screen Pixels = 768)
  sw t1,36(t0)    ; Store Horizontal Video into VI H Start Reg $A4400024
  li t1,$5F0239   ; Set Vertical Video (Start Of Active Video In Screen Half-Lines = 95, End Of Active Video In Screen Half-Lines = 569)
  sw t1,40(t0)    ; Store Vertical Video into VI V Start Reg $A4400028
  li t1,$9026B    ; Set Vertical Burst (Start Of Color Burst Enable In Half-Lines = 9, End Of Color Burst Enable In Half-Lines = 619)
  sw t1,44(t0)    ; Store Vertical Burst into VI V Burst Reg $A440002C
  li t1,$200      ; Set X-Scale (Horizontal Subpixel Offset In 2.10 Format = 0, 1/Horizontal Scale Up Factor In 2.10 Format = 512)
  sw t1,48(t0)    ; Store X-Scale into VI X Scale Reg $A4400030
  li t1,$400      ; Set Y-Scale (Vertical Subpixel Offset In 2.10 Format = 0, 1/Vertical Scale Up Factor In 2.10 Format = 1024)
  sw t1,52(t0)    ; Store Y-Scale into VI Y Scale Reg $A4400034

Loop:
  j Loop
  nop ; Delay Slot