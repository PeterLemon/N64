import math

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

dct_result_1d = [0,0,0,0,0,0,0,0, # Discrete Cosine Transform (DCT) 8x8 Result Matrix
                 0,0,0,0,0,0,0,0,
                 0,0,0,0,0,0,0,0,
                 0,0,0,0,0,0,0,0,
                 0,0,0,0,0,0,0,0,
                 0,0,0,0,0,0,0,0,
                 0,0,0,0,0,0,0,0,
                 0,0,0,0,0,0,0,0]

C = [(1/(2*math.sqrt(2))),0.5,0.5,0.5,0.5,0.5,0.5,0.5] # C Look Up Table (/2 Applied)

COS = [] # COS Look Up Table
for u in range(8):
    for x in range(8):
        COS.append(math.cos((2*x + 1) * u * math.pi / 16))

# DCT
for u in range(8):
    for v in range(8):
        for x in range(8):
            for y in range(8):
                dct_result_1d[v*8 + u] += (
                        dct_input_1d[y*8 + x]
                        * C[u]
                        * C[v]
                        * COS[u*8 + x] # math.cos((2*x + 1) * u * math.pi / 16)
                        * COS[v*8 + y] # math.cos((2*y + 1) * v * math.pi / 16)
                    )

print ("Discrete Cosine Transform (DCT) 8x8 Input Matrix:") # Print The DCT 8x8 Input Matrix
print ([x for x in dct_input_1d])

print ("Discrete Cosine Transform (DCT) 8x8 Result Matrix:") # Print The DCT 8x8 Result Matrix
print ([round(x) for x in dct_result_1d])
