import math

# Scalar Multiply The JPEG Standard Quantization 8x8 Matrix (Quality = 50)
# To Obtain The Desired JPEG Standard Quantization 8x8 Result Matrix
# IF (Quality Level > 50) Quantization Matrix *= (100-Quality Level)/50
# IF (Quality Level < 50) Quantization Matrix *= 50/Quality Level
# Scaled Quantization Matrix Values Are Rounded & Clipped
# To Have Positive Integer Values Ranging From 1..255

quality = 10 # Quality Level (1..100)
             # 1 = Poorest Quality & Highest compression
             # 100 = Best Quality & Lowest Compression

q_input_1d = [16,11,10,16,24,40,51,61, # JPEG Standard Quantization 8x8 Input Matrix (Quality = 50)
              12,12,14,19,26,58,60,55,
              14,13,16,24,40,57,69,56,
              14,17,22,29,51,87,80,62,
              18,22,37,56,68,109,103,77,
              24,35,55,64,81,104,113,92,
              49,64,78,87,103,121,120,101,
              72,92,95,98,112,100,103,99]

q_result_1d = [0,0,0,0,0,0,0,0, # JPEG Standard Quantization 8x8 Result Matrix
               0,0,0,0,0,0,0,0,
               0,0,0,0,0,0,0,0,
               0,0,0,0,0,0,0,0,
               0,0,0,0,0,0,0,0,
               0,0,0,0,0,0,0,0,
               0,0,0,0,0,0,0,0,
               0,0,0,0,0,0,0,0]

# Quantization Quality
for q in range(64):
    if quality > 50: q_result_1d[q] = q_input_1d[q] * (100-quality)/50
    if quality < 50: q_result_1d[q] = q_input_1d[q] * 50/quality
    if quality == 50: q_result_1d[q] = q_input_1d[q]
    if q_result_1d[q] > 255: q_result_1d[q] = 255
    if q_result_1d[q] < 1: q_result_1d[q] = 1

print ("JPEG Standard Quantization 8x8 Input Matrix (Quality = 50):") # Print The Quantization 8x8 Input Matrix
print ([x for x in q_input_1d])

print ("JPEG Standard Quantization 8x8 Result Matrix (Quality =", quality, "):") # Print The Quantization 8x8 Result Matrix
print ([round(x) for x in q_result_1d])
