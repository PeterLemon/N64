import math

# Scalar Divide The DCT Block By The JPEG Standard Quantization 8x8 Matrix
# To Obtain The Desired DCT Quantization 8x8 Result Matrix
# DCT Quantization Matrix Values Are Rounded & Clipped
# To Have Signed Integer Values Ranging From -128..127

dct_result_1d = [600,0,-261,0,-200,0,-108,0, # Discrete Cosine Transform (DCT) 8x8 Result Matrix
                 -106,0,-196,0,256,0,196,0,
                 -185,0,100,0,185,0,-241,0,
                 217,0,-166,0,90,0,-166,0,
                 0,0,0,0,0,0,0,0,
                 -145,0,111,0,-60,0,111,0,
                 77,0,-41,0,-77,0,100,0,
                 21,0,39,0,-51,0,-39,0]

q_result_1d = [16,11,10,16,24,40,51,61, # JPEG Standard Quantization 8x8 Result Matrix
               12,12,14,19,26,58,60,55,
               14,13,16,24,40,57,69,56,
               14,17,22,29,51,87,80,62,
               18,22,37,56,68,109,103,77,
               24,35,55,64,81,104,113,92,
               49,64,78,87,103,121,120,101,
               72,92,95,98,112,100,103,99]

dctq_result_1d = [0,0,0,0,0,0,0,0, # DCT Quantization 8x8 Result Matrix
                  0,0,0,0,0,0,0,0,
                  0,0,0,0,0,0,0,0,
                  0,0,0,0,0,0,0,0,
                  0,0,0,0,0,0,0,0,
                  0,0,0,0,0,0,0,0,
                  0,0,0,0,0,0,0,0,
                  0,0,0,0,0,0,0,0]

# Quantization
for q in range(64):
    dctq_result_1d[q] = dct_result_1d[q] / q_result_1d[q]
    if dctq_result_1d[q] > 127: dctq_result_1d[q] = 127
    if dctq_result_1d[q] < -128: dctq_result_1d[q] = -128

print ("Discrete Cosine Transform (DCT) 8x8 Result Matrix:") # Print The DCT 8x8 Result Matrix
print ([round(x) for x in dct_result_1d])

print ("JPEG Standard Quantization 8x8 Result Matrix:") # Print The Quantization 8x8 Result Matrix
print ([x for x in q_result_1d])

print ("DCT Quantization 8x8 Result Matrix:") # Print The DCT Quantization 8x8 Result Matrix
print ([round(x) for x in dctq_result_1d])
