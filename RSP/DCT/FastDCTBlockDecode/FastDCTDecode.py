# Fast DCT Decoding: "https://github.com/mozilla/mozjpeg/blob/master/jidctint.c"

# DCT Decoding: "https://vsr.informatik.tu-chemnitz.de/~jan/MPEG/HTML/mpeg_tech.html"

# DCT Value At The Upper Left Corner Is Called The "DC" Value.
# This Is The Abbreviation For "Direct Current" & Refers To A Similar Phenomenon
# In The Theory Of Alternating Current Where An Alternating Current Can Have A Direct Component.
# In DCT The "DC" Value Determines The Average Brightness In The Block.
# All Other Values Describe The Variation Around This DC value.
# Therefore They Are Sometimes Referred To As "AC" Values (From "Alternating Current").

dct_result_1d = [ # Discrete Cosine Transform (DCT) 8x8 Result Matrix
##    700,0,0,0,0,0,0,0, # We Apply The IDCT To A Matrix, Only Containing A DC Value Of 700.
##    0,0,0,0,0,0,0,0,   # It Will Produce A Grey Colored Square.
##    0,0,0,0,0,0,0,0,
##    0,0,0,0,0,0,0,0,
##    0,0,0,0,0,0,0,0,
##    0,0,0,0,0,0,0,0,
##    0,0,0,0,0,0,0,0,
##    0,0,0,0,0,0,0,0]

##    700,100,0,0,0,0,0,0, # Now Let's Add An AC Value Of 100, At The 1st Position.
##    0,0,0,0,0,0,0,0,     # It Will Produce A Bar Diagram With A Curve Like A Half Cosine Line.
##    0,0,0,0,0,0,0,0,     # It Is Said It Has A Frequency Of 1 In X-Direction.
##    0,0,0,0,0,0,0,0,
##    0,0,0,0,0,0,0,0,
##    0,0,0,0,0,0,0,0,
##    0,0,0,0,0,0,0,0,
##    0,0,0,0,0,0,0,0]

##    700,0,100,0,0,0,0,0, # What Happens If We Place The AC Value Of 100 At The Next Position?
##    0,0,0,0,0,0,0,0,     # The Shape Of The Bar Diagram Shows A Cosine Line, Too.
##    0,0,0,0,0,0,0,0,     # But Now We See A Full Period.
##    0,0,0,0,0,0,0,0,     # The Frequency Is Twice As High As In The Previous Example.
##    0,0,0,0,0,0,0,0,
##    0,0,0,0,0,0,0,0,
##    0,0,0,0,0,0,0,0,
##    0,0,0,0,0,0,0,0]

##    700,100,100,0,0,0,0,0, # But What Happens If We Place Both AC Values?
##    0,0,0,0,0,0,0,0,       # The Shape Of The Bar Diagram Is A Mix Of Both The 1st & 2nd Cosines.
##    0,0,0,0,0,0,0,0,       # The Resulting AC Value Is Simply An Addition Of The Cosine Lines.
##    0,0,0,0,0,0,0,0,
##    0,0,0,0,0,0,0,0,
##    0,0,0,0,0,0,0,0,
##    0,0,0,0,0,0,0,0,
##    0,0,0,0,0,0,0,0]

##    700,100,100,0,0,0,0,0, # Now Let's Add An AC Value At The Other Direction.
##    200,0,0,0,0,0,0,0,     # Now The Values Vary In Y Direction, Too. The Principle Is:
##    0,0,0,0,0,0,0,0,       # The Higher The Index Of The AC Value The Greater The Frequency Is.
##    0,0,0,0,0,0,0,0,
##    0,0,0,0,0,0,0,0,
##    0,0,0,0,0,0,0,0,
##    0,0,0,0,0,0,0,0,
##    0,0,0,0,0,0,0,0]

    950,0,0,0,0,0,0,0, # Placing An AC Value At The Opposite Side Of The DC Value.
    0,0,0,0,0,0,0,0,   # The Highest Possible Frequency Of 8 Is Applied In Both X- & Y- Direction.
    0,0,0,0,0,0,0,0,   # Because Of The High Frequency The Neighbouring Values Differ Numerously.
    0,0,0,0,0,0,0,0,   # The Picture Shows A Checker-Like Appearance.
    0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,500]

# This code only copes with 8x8 DCTs.

FIX_0_298631336 = 0.298631336
FIX_0_390180644 = 0.390180644
FIX_0_541196100 = 0.541196100
FIX_0_765366865 = 0.765366865
FIX_0_899976223 = 0.899976223
FIX_1_175875602 = 1.175875602
FIX_1_501321110 = 1.501321110
FIX_1_847759065 = 1.847759065
FIX_1_961570560 = 1.961570560
FIX_2_053119869 = 2.053119869
FIX_2_562915447 = 2.562915447
FIX_3_072711026 = 3.072711026

# Pass 1: process columns from input, store into work array.
# Note results are scaled up by sqrt(8) compared to a true IDCT;
# furthermore, we scale the results by 2**PASS1_BITS.

for ctr in range(8):
    # Even part: reverse the even part of the forward DCT.
    # The rotator is sqrt(2)*c(-6).

    z2 = dct_result_1d[ctr + 8*2]
    z3 = dct_result_1d[ctr + 8*6]

    z1 = (z2 + z3) * FIX_0_541196100
    tmp2 = z1 + (z3 * -FIX_1_847759065)
    tmp3 = z1 + (z2 * FIX_0_765366865)

    z2 = dct_result_1d[ctr + 8*0]
    z3 = dct_result_1d[ctr + 8*4]

    tmp0 = z2 + z3
    tmp1 = z2 - z3

    tmp10 = tmp0 + tmp3
    tmp13 = tmp0 - tmp3
    tmp11 = tmp1 + tmp2
    tmp12 = tmp1 - tmp2
    
    # Odd part per figure 8; the matrix is unitary and hence its
    # transpose is its inverse.  i0..i3 are y7,y5,y3,y1 respectively.

    tmp0 = dct_result_1d[ctr + 8*7]
    tmp1 = dct_result_1d[ctr + 8*5]
    tmp2 = dct_result_1d[ctr + 8*3]
    tmp3 = dct_result_1d[ctr + 8*1]

    z1 = tmp0 + tmp3
    z2 = tmp1 + tmp2
    z3 = tmp0 + tmp2
    z4 = tmp1 + tmp3
    z5 = (z3 + z4) * FIX_1_175875602 # sqrt(2) * c3

    tmp0 *= FIX_0_298631336 # sqrt(2) * (-c1+c3+c5-c7)
    tmp1 *= FIX_2_053119869 # sqrt(2) * ( c1+c3-c5+c7)
    tmp2 *= FIX_3_072711026 # sqrt(2) * ( c1+c3+c5-c7)
    tmp3 *= FIX_1_501321110 # sqrt(2) * ( c1+c3-c5-c7)
    z1 *= -FIX_0_899976223 # sqrt(2) * ( c7-c3)
    z2 *= -FIX_2_562915447 # sqrt(2) * (-c1-c3)
    z3 *= -FIX_1_961570560 # sqrt(2) * (-c3-c5)
    z4 *= -FIX_0_390180644 # sqrt(2) * ( c5-c3)

    z3 += z5
    z4 += z5

    tmp0 += z1 + z3
    tmp1 += z2 + z4
    tmp2 += z2 + z3
    tmp3 += z1 + z4

    # Final output stage: inputs are tmp10..tmp13, tmp0..tmp3

    dct_result_1d[ctr + 8*0] = tmp10 + tmp3
    dct_result_1d[ctr + 8*7] = tmp10 - tmp3
    dct_result_1d[ctr + 8*1] = tmp11 + tmp2
    dct_result_1d[ctr + 8*6] = tmp11 - tmp2
    dct_result_1d[ctr + 8*2] = tmp12 + tmp1
    dct_result_1d[ctr + 8*5] = tmp12 - tmp1
    dct_result_1d[ctr + 8*3] = tmp13 + tmp0
    dct_result_1d[ctr + 8*4] = tmp13 - tmp0

# Pass 2: process rows from work array, store into output array.
# Note that we must descale the results by a factor of 8 == 2**3,
# and also undo the PASS1_BITS scaling.

for ctr in range(8):
    # Even part: reverse the even part of the forward DCT.
    # The rotator is sqrt(2)*c(-6).

    z2 = dct_result_1d[ctr*8 + 2]
    z3 = dct_result_1d[ctr*8 + 6]

    z1 = (z2 + z3) * FIX_0_541196100
    tmp2 = z1 + (z3 * -FIX_1_847759065)
    tmp3 = z1 + (z2 * FIX_0_765366865)

    z2 = dct_result_1d[ctr*8 + 0]
    z3 = dct_result_1d[ctr*8 + 4]

    tmp0 = z2 + z3
    tmp1 = z2 - z3

    tmp10 = tmp0 + tmp3
    tmp13 = tmp0 - tmp3
    tmp11 = tmp1 + tmp2
    tmp12 = tmp1 - tmp2

    # Odd part per figure 8; the matrix is unitary and hence its
    # transpose is its inverse.  i0..i3 are y7,y5,y3,y1 respectively.

    tmp0 = dct_result_1d[ctr*8 + 7]
    tmp1 = dct_result_1d[ctr*8 + 5]
    tmp2 = dct_result_1d[ctr*8 + 3]
    tmp3 = dct_result_1d[ctr*8 + 1]

    z1 = tmp0 + tmp3
    z2 = tmp1 + tmp2
    z3 = tmp0 + tmp2
    z4 = tmp1 + tmp3
    z5 = (z3 + z4) * FIX_1_175875602 # sqrt(2) * c3

    tmp0 *= FIX_0_298631336 # sqrt(2) * (-c1+c3+c5-c7)
    tmp1 *= FIX_2_053119869 # sqrt(2) * ( c1+c3-c5+c7)
    tmp2 *= FIX_3_072711026 # sqrt(2) * ( c1+c3+c5-c7)
    tmp3 *= FIX_1_501321110 # sqrt(2) * ( c1+c3-c5-c7)
    z1 *= -FIX_0_899976223 # sqrt(2) * ( c7-c3)
    z2 *= -FIX_2_562915447 # sqrt(2) * (-c1-c3)
    z3 *= -FIX_1_961570560 # sqrt(2) * (-c3-c5)
    z4 *= -FIX_0_390180644 # sqrt(2) * ( c5-c3)

    z3 += z5
    z4 += z5

    tmp0 += z1 + z3
    tmp1 += z2 + z4
    tmp2 += z2 + z3
    tmp3 += z1 + z4

    # Final output stage: inputs are tmp10..tmp13, tmp0..tmp3

    dct_result_1d[ctr*8 + 0] = int(tmp10 + tmp3) >> 3
    dct_result_1d[ctr*8 + 7] = int(tmp10 - tmp3) >> 3
    dct_result_1d[ctr*8 + 1] = int(tmp11 + tmp2) >> 3
    dct_result_1d[ctr*8 + 6] = int(tmp11 - tmp2) >> 3
    dct_result_1d[ctr*8 + 2] = int(tmp12 + tmp1) >> 3
    dct_result_1d[ctr*8 + 5] = int(tmp12 - tmp1) >> 3
    dct_result_1d[ctr*8 + 3] = int(tmp13 + tmp0) >> 3
    dct_result_1d[ctr*8 + 4] = int(tmp13 - tmp0) >> 3

print ("Discrete Cosine Transform (DCT) 8x8 Result Matrix:") # Print The DCT 8x8 Result Matrix
print ([round(x) for x in dct_result_1d])
