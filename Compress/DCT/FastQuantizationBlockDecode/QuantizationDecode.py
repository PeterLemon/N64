import math

# Scalar Multiply The DCT Quantization Block By The JPEG Standard Quantization 8x8 Matrix
# To Obtain The Inverse Quantization DCT 8x8 Result Matrix

dctq_result_1d = [38,0,-26,0,-8,0,-2,0, # DCT Quantization 8x8 Result Matrix
                  -9,0,-14,0,10,0,3,0,
                  -13,0,6,0,5,0,-3,0,
                  16,0,-8,0,2,0,-2,0,
                  0,0,0,0,0,0,0,0,
                  -6,0,2,0,-1,0,1,0,
                  2,0,-1,0,-1,0,1,0,
                  0,0,0,0,0,0,0,0]

q_result_1d = [16,11,10,16,24,40,51,61, # JPEG Standard Quantization 8x8 Result Matrix
               12,12,14,19,26,58,60,55,
               14,13,16,24,40,57,69,56,
               14,17,22,29,51,87,80,62,
               18,22,37,56,68,109,103,77,
               24,35,55,64,81,104,113,92,
               49,64,78,87,103,121,120,101,
               72,92,95,98,112,100,103,99]

dct_result_1d = [0,0,0,0,0,0,0,0, # Discrete Cosine Transform (DCT) 8x8 Result Matrix
                 0,0,0,0,0,0,0,0,
                 0,0,0,0,0,0,0,0,
                 0,0,0,0,0,0,0,0,
                 0,0,0,0,0,0,0,0,
                 0,0,0,0,0,0,0,0,
                 0,0,0,0,0,0,0,0,
                 0,0,0,0,0,0,0,0]

# Inverse Quantization
for q in range(64):
    dct_result_1d[q] = dctq_result_1d[q] * q_result_1d[q]

print ("DCT Quantization 8x8 Result Matrix:") # Print The DCT Quantization 8x8 Result Matrix
print ([round(x) for x in dctq_result_1d])

print ("JPEG Standard Quantization 8x8 Result Matrix:") # Print The Quantization 8x8 Result Matrix
print ([x for x in q_result_1d])

print ("Discrete Cosine Transform (DCT) 8x8 Result Matrix:") # Print The DCT 8x8 Result Matrix
print ([round(x) for x in dct_result_1d])
