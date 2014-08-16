  lui t0,PIF_BASE ; Initialize N64 (Stop N64 From Crashing 5 Seconds After Boot)
  li t1,8
  sw t1,(PIF_RAM+$3C)(t0)