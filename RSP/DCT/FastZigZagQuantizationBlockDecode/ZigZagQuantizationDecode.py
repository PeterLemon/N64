import math

# Scalar Multiply The DCT Quantization Block By The JPEG Standard Quantization 8x8 Matrix
# To Obtain The Inverse Quantization DCT 8x8 Result Matrix

dctzq_result_1d = [38,0,-9,-13,0,-26,0,-14, # DCT ZigZag Quantization 8x8 Result Matrix
                   0,16,0,0,6,0,-8,0,
                   10,0,-8,0,-6,2,0,0,
                   0,5,0,-2,0,3,0,2,
                   0,2,0,0,0,-1, 0,0,
                   0,-3,0,0,-2,0,-1,0,
                   0,0,-1,0,0,0,0,1,
                   0,0,0,1,0,0,0,0]

dctq_result_1d = [0,0,0,0,0,0,0,0, # DCT Quantization 8x8 Result Matrix
                  0,0,0,0,0,0,0,0,
                  0,0,0,0,0,0,0,0,
                  0,0,0,0,0,0,0,0,
                  0,0,0,0,0,0,0,0,
                  0,0,0,0,0,0,0,0,
                  0,0,0,0,0,0,0,0,
                  0,0,0,0,0,0,0,0]

q_result_1d = [16,11,10,16,24,40,51,61, # JPEG Standard Quantization 8x8 Result Matrix
               12,12,14,19,26,58,60,55,
               14,13,16,24,40,57,69,56,
               14,17,22,29,51,87,80,62,
               18,22,37,56,68,109,103,77,
               24,35,55,64,81,104,113,92,
               49,64,78,87,103,121,120,101,
               72,92,95,98,112,100,103,99]

iz_result_ld = [0,1,5,6,14,15,27,28, # JPEG Standard Inverse ZigZag Transformation Matrix
                2,4,7,13,16,26,29,42,
                3,8,12,17,25,30,41,43,
                9,11,18,24,31,40,44,53,
                10,19,23,32,39,45,52,54,
                20,22,33,38,46,51,55,60,
                21,34,37,47,50,56,59,61,
                35,36,48,49,57,58,62,63]

dct_result_1d = [0,0,0,0,0,0,0,0, # Discrete Cosine Transform (DCT) 8x8 Result Matrix
                 0,0,0,0,0,0,0,0,
                 0,0,0,0,0,0,0,0,
                 0,0,0,0,0,0,0,0,
                 0,0,0,0,0,0,0,0,
                 0,0,0,0,0,0,0,0,
                 0,0,0,0,0,0,0,0,
                 0,0,0,0,0,0,0,0]

# Inverse ZigZag Transformation
for z in range(64):
    dctq_result_1d[z] = dctzq_result_1d[iz_result_ld[z]]

# Inverse Quantization
for q in range(64):
    dct_result_1d[q] = dctq_result_1d[q] * q_result_1d[q]

print ("DCT ZigZag Quantization 8x8 Result Matrix:") # Print The DCT ZigZag Quantization 8x8 Result Matrix
print ([round(x) for x in dctzq_result_1d])

print ("DCT Quantization 8x8 Result Matrix:") # Print The DCT Quantization 8x8 Result Matrix
print ([round(x) for x in dctq_result_1d])

print ("JPEG Standard Quantization 8x8 Result Matrix:") # Print The Quantization 8x8 Result Matrix
print ([x for x in q_result_1d])

print ("Discrete Cosine Transform (DCT) 8x8 Result Matrix:") # Print The DCT 8x8 Result Matrix
print ([round(x) for x in dct_result_1d])
