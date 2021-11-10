// Test LoadTLUT with various bitdepths, overflow and uls!=0
// Written by Lemmy with plenty of stuff copied from krom

scope b8_b4 {
	output "LoadTLUT_b8_b4.N64", create
	define header_title_27("LoadTLUT: tex=8b tile=4b   ")
	constant tmem_start($100)
	constant bpp_texture(SIZE_OF_PIXEL_8B)
	constant bpp_tile(SIZE_OF_PIXEL_4B)
	constant color_format(IMAGE_DATA_FORMAT_RGBA)
	constant lrs(255)
	constant lrt(0)
	constant uls(0)
	constant ult(0)
	include "LoadTLUT.inc"
}

scope b8_b8 {
	output "LoadTLUT_b8_b8.N64", create
	define header_title_27("LoadTLUT: tex=8b tile=8b   ")
	constant tmem_start($100)
	constant bpp_texture(SIZE_OF_PIXEL_8B)
	constant bpp_tile(SIZE_OF_PIXEL_8B)
	constant color_format(IMAGE_DATA_FORMAT_RGBA)
	constant lrs(255)
	constant lrt(0)
	constant uls(0)
	constant ult(0)
	include "LoadTLUT.inc"
}

scope b8_b16 {
	output "LoadTLUT_b8_b16.N64", create
	define header_title_27("LoadTLUT: tex=8b tile=16b  ")
	constant tmem_start($100)
	constant bpp_texture(SIZE_OF_PIXEL_8B)
	constant bpp_tile(SIZE_OF_PIXEL_16B)
	constant color_format(IMAGE_DATA_FORMAT_RGBA)
	constant lrs(255)
	constant lrt(0)
	constant uls(0)
	constant ult(0)
	include "LoadTLUT.inc"
}

scope b8_b32 {
	output "LoadTLUT_b8_b32.N64", create
	define header_title_27("LoadTLUT: tex=8b tile=32b  ")
	constant tmem_start($100)
	constant bpp_texture(SIZE_OF_PIXEL_8B)
	constant bpp_tile(SIZE_OF_PIXEL_32B)
	constant color_format(IMAGE_DATA_FORMAT_RGBA)
	constant lrs(255)
	constant lrt(0)
	constant uls(0)
	constant ult(0)
	include "LoadTLUT.inc"
}

scope b16_b4 {
	output "LoadTLUT_b16_b4.N64", create
	define header_title_27("LoadTLUT: tex=16b tile=4b  ")
	constant tmem_start($100)
	constant bpp_texture(SIZE_OF_PIXEL_16B)
	constant bpp_tile(SIZE_OF_PIXEL_4B)
	constant color_format(IMAGE_DATA_FORMAT_RGBA)
	constant lrs(127)
	constant lrt(0)
	constant uls(0)
	constant ult(0)
	include "LoadTLUT.inc"
}

scope b16_b8 {
	output "LoadTLUT_b16_b8.N64", create
	define header_title_27("LoadTLUT: tex=16b tile=8b  ")
	constant tmem_start($100)
	constant bpp_texture(SIZE_OF_PIXEL_16B)
	constant bpp_tile(SIZE_OF_PIXEL_8B)
	constant color_format(IMAGE_DATA_FORMAT_RGBA)
	constant lrs(127)
	constant lrt(0)
	constant uls(0)
	constant ult(0)
	include "LoadTLUT.inc"
}

scope b16_b16 {
	output "LoadTLUT_b16_b16.N64", create
	define header_title_27("LoadTLUT: tex=16b tile=16b ")
	constant tmem_start($100)
	constant bpp_texture(SIZE_OF_PIXEL_16B)
	constant bpp_tile(SIZE_OF_PIXEL_16B)
	constant color_format(IMAGE_DATA_FORMAT_RGBA)
	constant lrs(127)
	constant lrt(0)
	constant uls(0)
	constant ult(0)
	include "LoadTLUT.inc"
}

scope b16_b32 {
	output "LoadTLUT_b16_b32.N64", create
	define header_title_27("LoadTLUT: tex=16b tile=32b ")
	constant tmem_start($100)
	constant bpp_texture(SIZE_OF_PIXEL_16B)
	constant bpp_tile(SIZE_OF_PIXEL_32B)
	constant color_format(IMAGE_DATA_FORMAT_RGBA)
	constant lrs(127)
	constant lrt(0)
	constant uls(0)
	constant ult(0)
	include "LoadTLUT.inc"
}

scope b32_b4 {
	output "LoadTLUT_b32_b4.N64", create
	define header_title_27("LoadTLUT: tex=32b tile=4b  ")
	constant tmem_start($100)
	constant bpp_texture(SIZE_OF_PIXEL_32B)
	constant bpp_tile(SIZE_OF_PIXEL_4B)
	constant color_format(IMAGE_DATA_FORMAT_RGBA)
	constant lrs(127)
	constant lrt(0)
	constant uls(0)
	constant ult(0)
	include "LoadTLUT.inc"
}

scope b32_b8 {
	output "LoadTLUT_b32_b8.N64", create
	define header_title_27("LoadTLUT: tex=32b tile=8b  ")
	constant tmem_start($100)
	constant bpp_texture(SIZE_OF_PIXEL_32B)
	constant bpp_tile(SIZE_OF_PIXEL_8B)
	constant color_format(IMAGE_DATA_FORMAT_RGBA)
	constant lrs(127)
	constant lrt(0)
	constant uls(0)
	constant ult(0)
	include "LoadTLUT.inc"
}

scope b32_b16 {
	output "LoadTLUT_b32_b16.N64", create
	define header_title_27("LoadTLUT: tex=32b tile=16b ")
	constant tmem_start($100)
	constant bpp_texture(SIZE_OF_PIXEL_32B)
	constant bpp_tile(SIZE_OF_PIXEL_16B)
	constant color_format(IMAGE_DATA_FORMAT_RGBA)
	constant lrs(127)
	constant lrt(0)
	constant uls(0)
	constant ult(0)
	include "LoadTLUT.inc"
}

scope b32_b32 {
	output "LoadTLUT_b32_b32.N64", create
	define header_title_27("LoadTLUT: tex=32b tile=32b ")
	constant tmem_start($100)
	constant bpp_texture(SIZE_OF_PIXEL_32B)
	constant bpp_tile(SIZE_OF_PIXEL_32B)
	constant color_format(IMAGE_DATA_FORMAT_RGBA)
	constant lrs(127)
	constant lrt(0)
	constant uls(0)
	constant ult(0)
	include "LoadTLUT.inc"
}

scope b16_with_overflow {
	output "LoadTLUT_b16_overflow.N64", create
	define header_title_27("LoadTLUT: 16 bpp overflow  ")
	constant tmem_start($E00)
	constant bpp_texture(SIZE_OF_PIXEL_16B)
	constant bpp_tile(SIZE_OF_PIXEL_16B)
	constant color_format(IMAGE_DATA_FORMAT_RGBA)
	constant lrs(127)
	constant lrt(0)
	constant uls(0)
	constant ult(0)
	include "LoadTLUT.inc"
}

scope b16_b8_uls16 {
	output "LoadTLUT_b16_b8_uls16.N64", create
	define header_title_27("LoadTLUT: uls=16           ")
	constant tmem_start($100)
	constant bpp_texture(SIZE_OF_PIXEL_16B)
	constant bpp_tile(SIZE_OF_PIXEL_8B)
	constant color_format(IMAGE_DATA_FORMAT_RGBA)
	constant lrs(127)
	constant lrt(0)
	constant uls(16)
	constant ult(0)
	include "LoadTLUT.inc"
}
