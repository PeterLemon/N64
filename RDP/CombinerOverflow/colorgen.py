print("align(8)")
print("AlphaGradient16x16x32b:")
colors = [ 0x0000FF, 0x00FF00, 0x00FFFF, 0xFF0000, 0xFF00FF, 0xFFFF00, 0xFFFFFF ]
for alpha in range(256):
	if (alpha % 16 == 0):
		if (alpha != 0): print("")
		print("dw ", end="")
	else:
		print(", ", end="")

	# Interleave odd rows
	isOddRow = (alpha // 16) % 2 == 1
	alphaInterleaved = (alpha ^ 2) if isOddRow else alpha
	color = colors[alphaInterleaved % len(colors)] << 8 | alphaInterleaved
	hexColor = "${:08x}".format(color)
	print(hexColor, end="")
print("")

print("align(8)")
print("RedGradient16x16x32b:")
for index in range(256):
	if (index % 16 == 0):
		if (index != 0): print("")
		print("dw ", end="")
	else:
		print(", ", end="")

	# Interleave odd rows
	isOddRow = (index // 16) % 2 == 1
	indexInterleaved = (index ^ 2) if isOddRow else index
	red = indexInterleaved
	green = 128 if (indexInterleaved % 2 == 0) else 0
	color = (red << 24) | (green << 16) | 0xFF
	hexColor = "${:08x}".format(color)
	print(hexColor, end="")
print("")