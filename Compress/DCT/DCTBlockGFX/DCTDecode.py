import math

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

idct_result_1d = [0,0,0,0,0,0,0,0, # Inverse Discrete Cosine Transform (IDCT) 8x8 Result Matrix
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

# IDCT
for y in range(8): # For IDCT
    for x in range(8):
        for v in range(8): # For DCT
            for u in range(8):
                idct_result_1d[y*8 + x] += (
                        dct_result_1d[v*8 + u]
                        * C[u]
                        * C[v]
                        * COS[u*8 + x] # math.cos((2*x + 1) * u * math.pi / 16)
                        * COS[v*8 + y] # math.cos((2*y + 1) * v * math.pi / 16)
                    )

print ("Discrete Cosine Transform (DCT) 8x8 Result Matrix:") # Print The DCT 8x8 Result Matrix
print ([x for x in dct_result_1d])

print ("Inverse Discrete Cosine Transform (IDCT) 8x8 Result Matrix:") # Print The IDCT 8x8 Result Matrix
print ([round(x) for x in idct_result_1d])

#print ([round(x*65536) for x in C])   # Print C Look Up Table
#print ([round(x*65536) for x in COS]) # Print COS / PI Look Up Table
