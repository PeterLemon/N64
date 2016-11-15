# Fast DCT Encoding: "https://github.com/mozilla/mozjpeg/blob/master/jfdctint.c"

# DCT Encoding: "https://vsr.informatik.tu-chemnitz.de/~jan/MPEG/HTML/mpeg_tech.html"

# DCT Value At The Upper Left Corner Is Called The "DC" Value.
# This Is The Abbreviation For "Direct Current" & Refers To A Similar Phenomenon
# In The Theory Of Alternating Current Where An Alternating Current Can Have A Direct Component.
# In DCT The "DC" Value Determines The Average Brightness In The Block.
# All Other Values Describe The Variation Around This DC value.
# Therefore They Are Sometimes Referred To As "AC" Values (From "Alternating Current").

dct_input_1d = [ # Discrete Cosine Transform (DCT) 8x8 Input Matrix
##    87,87,87,87,87,87,87,87, # A Grey Colored Square.
##    87,87,87,87,87,87,87,87,
##    87,87,87,87,87,87,87,87,
##    87,87,87,87,87,87,87,87,
##    87,87,87,87,87,87,87,87,
##    87,87,87,87,87,87,87,87,
##    87,87,87,87,87,87,87,87,
##    87,87,87,87,87,87,87,87]

##    105,102,97,91,84,78,73,70, # A Curve Like A Half Cosine Line.
##    105,102,97,91,84,78,73,70,
##    105,102,97,91,84,78,73,70,
##    105,102,97,91,84,78,73,70,
##    105,102,97,91,84,78,73,70,
##    105,102,97,91,84,78,73,70,
##    105,102,97,91,84,78,73,70,
##    105,102,97,91,84,78,73,70]

##    104,94,81,71,71,81,94,104, # A Cosine Line, With A Full Period.
##    104,94,81,71,71,81,94,104,
##    104,94,81,71,71,81,94,104,
##    104,94,81,71,71,81,94,104,
##    104,94,81,71,71,81,94,104,
##    104,94,81,71,71,81,94,104,
##    104,94,81,71,71,81,94,104,
##    104,94,81,71,71,81,94,104]

##    121,109,91,75,68,71,80,86, # A Mix Of Both The 1st & 2nd Cosines.
##    121,109,91,75,68,71,80,86,
##    121,109,91,75,68,71,80,86,
##    121,109,91,75,68,71,80,86,
##    121,109,91,75,68,71,80,86,
##    121,109,91,75,68,71,80,86,
##    121,109,91,75,68,71,80,86,
##    121,109,91,75,68,71,80,86]

##    156,144,125,109,102,106,114,121, # Values That Vary In Y Direction
##    151,138,120,104,97,100,109,116,
##    141,129,110,94,87,91,99,106,
##    128,116,97,82,75,78,86,93,
##    114,102,84,68,61,64,73,80,
##    102,89,71,55,48,51,60,67,
##    92,80,61,45,38,42,50,57,
##    86,74,56,40,33,36,45,52]

    124,105,139,95,143,98,132,114, # Highest Possible Frequency Of 8 Is Applied In Both X- & Y- Direction.
    105,157,61,187,51,176,80,132,  # Picture Shows A Checker-Like Appearance.
    139,61,205,17,221,32,176,98,
    95,187,17,239,0,221,51,143,
    143,51,221,0,239,17,187,95,
    98,176,32,221,17,205,61,139,
    132,80,176,51,187,61,157,105,
    114,132,98,143,95,139,105,124]

# This code only copes with 8x8 DCTs.
CONST_BITS = 13
PASS1_BITS = 2

FIX_0_298631336 = 2446 # FIX(0.298631336)
FIX_0_390180644 = 3196 # FIX(0.390180644)
FIX_0_541196100 = 4433 # FIX(0.541196100)
FIX_0_765366865 = 6270 # FIX(0.765366865)
FIX_0_899976223 = 7373 # FIX(0.899976223)
FIX_1_175875602 = 9633 # FIX(1.175875602)
FIX_1_501321110 = 12299 # FIX(1.501321110)
FIX_1_847759065 = 15137 # FIX(1.847759065)
FIX_1_961570560 = 16069 # FIX(1.961570560)
FIX_2_053119869 = 16819 # FIX(2.053119869)
FIX_2_562915447 = 20995 # FIX(2.562915447)
FIX_3_072711026 = 25172 # FIX(3.072711026)

# Pass 1: process rows.
# Note results are scaled up by sqrt(8) compared to a true DCT;
# furthermore, we scale the results by 2**PASS1_BITS.

for ctr in range(8):
    tmp0 = dct_input_1d[ctr*8 + 0] + dct_input_1d[ctr*8 + 7]
    tmp7 = dct_input_1d[ctr*8 + 0] - dct_input_1d[ctr*8 + 7]
    tmp1 = dct_input_1d[ctr*8 + 1] + dct_input_1d[ctr*8 + 6]
    tmp6 = dct_input_1d[ctr*8 + 1] - dct_input_1d[ctr*8 + 6]
    tmp2 = dct_input_1d[ctr*8 + 2] + dct_input_1d[ctr*8 + 5]
    tmp5 = dct_input_1d[ctr*8 + 2] - dct_input_1d[ctr*8 + 5]
    tmp3 = dct_input_1d[ctr*8 + 3] + dct_input_1d[ctr*8 + 4]
    tmp4 = dct_input_1d[ctr*8 + 3] - dct_input_1d[ctr*8 + 4]

    # Even part per LL&M figure 1 --- note that published figure is faulty;
    # rotator "sqrt(2)*c1" should be "sqrt(2)*c6".

    tmp10 = tmp0 + tmp3
    tmp13 = tmp0 - tmp3
    tmp11 = tmp1 + tmp2
    tmp12 = tmp1 - tmp2

    dct_input_1d[ctr*8 + 0] = ((tmp10 + tmp11) << PASS1_BITS)
    dct_input_1d[ctr*8 + 4] = ((tmp10 - tmp11) << PASS1_BITS)

    z1 = (tmp12 + tmp13) * FIX_0_541196100

    dct_input_1d[ctr*8 + 2] = (z1 + (tmp13 * FIX_0_765366865)) >> (CONST_BITS-PASS1_BITS)
    dct_input_1d[ctr*8 + 6] = (z1 + (tmp12 * -FIX_1_847759065)) >> (CONST_BITS-PASS1_BITS)

    # Odd part per figure 8 --- note paper omits factor of sqrt(2).
    # cK represents cos(K*pi/16).
    # i0..i3 in the paper are tmp4..tmp7 here.

    z1 = tmp4 + tmp7
    z2 = tmp5 + tmp6
    z3 = tmp4 + tmp6
    z4 = tmp5 + tmp7
    z5 = (z3 + z4) * FIX_1_175875602 # sqrt(2) * c3

    tmp4 *= FIX_0_298631336 # sqrt(2) * (-c1+c3+c5-c7)
    tmp5 *= FIX_2_053119869 # sqrt(2) * ( c1+c3-c5+c7)
    tmp6 *= FIX_3_072711026 # sqrt(2) * ( c1+c3+c5-c7)
    tmp7 *= FIX_1_501321110 # sqrt(2) * ( c1+c3-c5-c7)
    z1 *= -FIX_0_899976223 # sqrt(2) * ( c7-c3)
    z2 *= -FIX_2_562915447 # sqrt(2) * (-c1-c3)
    z3 *= -FIX_1_961570560 # sqrt(2) * (-c3-c5)
    z4 *= -FIX_0_390180644 # sqrt(2) * ( c5-c3)
    
    z3 += z5
    z4 += z5

    dct_input_1d[ctr*8 + 7] = (tmp4 + z1 + z3) >> (CONST_BITS-PASS1_BITS)
    dct_input_1d[ctr*8 + 5] = (tmp5 + z2 + z4) >> (CONST_BITS-PASS1_BITS)
    dct_input_1d[ctr*8 + 3] = (tmp6 + z2 + z3) >> (CONST_BITS-PASS1_BITS)
    dct_input_1d[ctr*8 + 1] = (tmp7 + z1 + z4) >> (CONST_BITS-PASS1_BITS)

# Pass 2: process columns.
# We remove the PASS1_BITS scaling, but leave the results scaled up
# by an overall factor of 8.

for ctr in range(8):
    tmp0 = dct_input_1d[ctr + 8*0] + dct_input_1d[ctr + 8*7]
    tmp7 = dct_input_1d[ctr + 8*0] - dct_input_1d[ctr + 8*7]
    tmp1 = dct_input_1d[ctr + 8*1] + dct_input_1d[ctr + 8*6]
    tmp6 = dct_input_1d[ctr + 8*1] - dct_input_1d[ctr + 8*6]
    tmp2 = dct_input_1d[ctr + 8*2] + dct_input_1d[ctr + 8*5]
    tmp5 = dct_input_1d[ctr + 8*2] - dct_input_1d[ctr + 8*5]
    tmp3 = dct_input_1d[ctr + 8*3] + dct_input_1d[ctr + 8*4]
    tmp4 = dct_input_1d[ctr + 8*3] - dct_input_1d[ctr + 8*4]

    # Even part per LL&M figure 1 --- note that published figure is faulty;
    # rotator "sqrt(2)*c1" should be "sqrt(2)*c6".
    
    tmp10 = tmp0 + tmp3
    tmp13 = tmp0 - tmp3
    tmp11 = tmp1 + tmp2
    tmp12 = tmp1 - tmp2
    
    dct_input_1d[ctr + 8*0] = (tmp10 + tmp11) >> PASS1_BITS
    dct_input_1d[ctr + 8*4] = (tmp10 - tmp11) >> PASS1_BITS

    z1 = (tmp12 + tmp13) * FIX_0_541196100
    dct_input_1d[ctr + 8*2] = (z1 + (tmp13 * FIX_0_765366865)) >> (CONST_BITS+PASS1_BITS)
    dct_input_1d[ctr + 8*6] = (z1 + (tmp12 * -FIX_1_847759065)) >> (CONST_BITS+PASS1_BITS)

    # Odd part per figure 8 --- note paper omits factor of sqrt(2).
    # cK represents cos(K*pi/16).
    # i0..i3 in the paper are tmp4..tmp7 here.
    
    z1 = tmp4 + tmp7
    z2 = tmp5 + tmp6
    z3 = tmp4 + tmp6
    z4 = tmp5 + tmp7
    z5 = (z3 + z4) * FIX_1_175875602 # sqrt(2) * c3
    
    tmp4 *= FIX_0_298631336 # sqrt(2) * (-c1+c3+c5-c7)
    tmp5 *= FIX_2_053119869 # sqrt(2) * ( c1+c3-c5+c7)
    tmp6 *= FIX_3_072711026 # sqrt(2) * ( c1+c3+c5-c7)
    tmp7 *= FIX_1_501321110 # sqrt(2) * ( c1+c3-c5-c7)
    z1 *= -FIX_0_899976223 # sqrt(2) * ( c7-c3)
    z2 *= -FIX_2_562915447 # sqrt(2) * (-c1-c3)
    z3 *= -FIX_1_961570560 # sqrt(2) * (-c3-c5)
    z4 *= -FIX_0_390180644 # sqrt(2) * ( c5-c3)
    
    z3 += z5
    z4 += z5

    dct_input_1d[ctr + 8*7] = (tmp4 + z1 + z3) >> (CONST_BITS+PASS1_BITS)
    dct_input_1d[ctr + 8*5] = (tmp5 + z2 + z4) >> (CONST_BITS+PASS1_BITS)
    dct_input_1d[ctr + 8*3] = (tmp6 + z2 + z3) >> (CONST_BITS+PASS1_BITS)
    dct_input_1d[ctr + 8*1] = (tmp7 + z1 + z4) >> (CONST_BITS+PASS1_BITS)

print ("Discrete Cosine Transform (DCT) 8x8 Input Matrix:") # Print The DCT 8x8 Input Matrix
print ([round(x / 8) for x in dct_input_1d])
