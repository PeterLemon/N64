scope regular {
  constant tile_size_ult(0)
  constant tile_size_lrt(7)

  scope shift_t_0 {
    output "TexturesMaskCMShiftT0_1.N64", create
    define header_title_27("Mask Shift  0->7  shiftt=0 ")
    constant shift_t(0)
    include "TexturesMaskClampMirror.inc"
  }
  
  scope shift_t_1 {
    output "TexturesMaskCMShiftT1_1.N64", create
    define header_title_27("Mask Shift  0->7  shiftt=1 ")
    constant shift_t(1)
    include "TexturesMaskClampMirror.inc"
  }
  
  scope shift_t_15 {
    output "TexturesMaskCMShiftT15_1.N64", create
    define header_title_27("Mask Shift  0->7  shiftt=15")
    constant shift_t(15)
    include "TexturesMaskClampMirror.inc"
  }
}

scope regular_higher {
  constant tile_size_ult(2)
  constant tile_size_lrt(8)

  scope shift_t_0 {
    output "TexturesMaskCMShiftT0_2.N64", create
    define header_title_27("Mask Shift  2->8  shiftt=0 ")
    constant shift_t(0)
    include "TexturesMaskClampMirror.inc"
  }
  
  scope shift_t_1 {
    output "TexturesMaskCMShiftT1_2.N64", create
    define header_title_27("Mask Shift  2->8  shiftt=1 ")
    constant shift_t(1)
    include "TexturesMaskClampMirror.inc"
  }
  
  scope shift_t_15 {
    output "TexturesMaskCMShiftT15_2.N64", create
    define header_title_27("Mask Shift  2->8  shiftt=15")
    constant shift_t(15)
    include "TexturesMaskClampMirror.inc"
  }
}


scope flipped {
  constant tile_size_ult(7)
  constant tile_size_lrt(0)

  scope shift_t_0 {
    output "TexturesMaskCMShiftT0_3.N64", create
    define header_title_27("Mask Shift  7->0  shiftt=0 ")
    constant shift_t(0)
    include "TexturesMaskClampMirror.inc"
  }
  
  scope shift_t_1 {
    output "TexturesMaskCMShiftT1_3.N64", create
    define header_title_27("Mask Shift  7->0  shiftt=1 ")
    constant shift_t(1)
    include "TexturesMaskClampMirror.inc"
  }
  
  scope shift_t_15 {
    output "TexturesMaskCMShiftT15_3.N64", create
    define header_title_27("Mask Shift  7->0  shiftt=15")
    constant shift_t(15)
    include "TexturesMaskClampMirror.inc"
  }
}

scope flipped_higher {
  constant tile_size_ult(8)
  constant tile_size_lrt(2)

  scope shift_t_0 {
    output "TexturesMaskCMShiftT0_4.N64", create
    define header_title_27("Mask Shift  8->2  shiftt=0 ")
    constant shift_t(0)
    include "TexturesMaskClampMirror.inc"
  }
  
  scope shift_t_1 {
    output "TexturesMaskCMShiftT1_4.N64", create
    define header_title_27("Mask Shift  8->2  shiftt=1 ")
    constant shift_t(1)
    include "TexturesMaskClampMirror.inc"
  }
  
  scope shift_t_15 {
    output "TexturesMaskCMShiftT15_4.N64", create
    define header_title_27("Mask Shift  8->2  shiftt=15")
    constant shift_t(15)
    include "TexturesMaskClampMirror.inc"
  }
}

