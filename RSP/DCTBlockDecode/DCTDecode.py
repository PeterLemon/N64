# DCT Decoding: "https://vsr.informatik.tu-chemnitz.de/~jan/MPEG/HTML/mpeg_tech.html"

# DCT Value At The Upper Left Corner Is Called The "DC" Value.
# This Is The Abbreviation For "Direct Current" & Refers To A Similar Phenomenon
# In The Theory Of Alternating Current Where An Alternating Current Can Have A Direct Component.
# In DCT The "DC" Value Determines The Average Brightness In The Block.
# All Other Values Describe The Variation Around This DC value.
# Therefore They Are Sometimes Referred To As "AC" Values (From "Alternating Current").

DCT = [ # Discrete Cosine Transform (DCT) 8x8 Input Block
    #700,0,0,0,0,0,0,0, # We Apply The IDCT To A Matrix, Only Containing A DC Value Of 700.
    #0,0,0,0,0,0,0,0,   # It Will Produce A Grey Colored Square.
    #0,0,0,0,0,0,0,0,
    #0,0,0,0,0,0,0,0,
    #0,0,0,0,0,0,0,0,
    #0,0,0,0,0,0,0,0,
    #0,0,0,0,0,0,0,0,
    #0,0,0,0,0,0,0,0]

    700,100,0,0,0,0,0,0, # Now Let's Add An AC Value Of 100, At The 1st Position
    0,0,0,0,0,0,0,0,     # It Will Produce A Bar Diagram With A Curve Like A Half Cosine Line.
    0,0,0,0,0,0,0,0,     # It Is Said It Has A Frequency Of 1 In X-Direction.
    0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0]

    #700,0,100,0,0,0,0,0, # What Happens If We Place The AC Value Of 100 At The Next Position?
    #0,0,0,0,0,0,0,0,     # The Shape Of The Bar Diagram Shows A Cosine Line, Too.
    #0,0,0,0,0,0,0,0,     # But Now We See A Full Period.
    #0,0,0,0,0,0,0,0,     # The Frequency Is Twice As High As In The Previous Example.
    #0,0,0,0,0,0,0,0,
    #0,0,0,0,0,0,0,0,
    #0,0,0,0,0,0,0,0,
    #0,0,0,0,0,0,0,0]

    #700,100,100,0,0,0,0,0, # But What Happens If We Place Both AC Values?
    #0,0,0,0,0,0,0,0,       # The Shape Of The Bar Diagram Is A Mix Of Both The 1st & 2nd Cosines.
    #0,0,0,0,0,0,0,0,       # The Resulting AC Value Is Simply An Addition Of The Cosine Lines.
    #0,0,0,0,0,0,0,0,
    #0,0,0,0,0,0,0,0,
    #0,0,0,0,0,0,0,0,
    #0,0,0,0,0,0,0,0,
    #0,0,0,0,0,0,0,0]

    #700,100,100,0,0,0,0,0, # Now Let's Add An AC Value At The Other Direction.
    #200,0,0,0,0,0,0,0,     # Now The Values Vary In Y Direction, Too. The Principle Is:
    #0,0,0,0,0,0,0,0,       # The Higher The Index Of The AC Value The Greater The Frequency Is.
    #0,0,0,0,0,0,0,0,
    #0,0,0,0,0,0,0,0,
    #0,0,0,0,0,0,0,0,
    #0,0,0,0,0,0,0,0,
    #0,0,0,0,0,0,0,0]

    #950,0,0,0,0,0,0,0, # Placing An AC Value At The Opposite Side Of The DC Value.
    #0,0,0,0,0,0,0,0,   # The Highest Possible Frequency Of 8 Is Applied In Both X- & Y- Direction.
    #0,0,0,0,0,0,0,0,   # Because Of The High Frequency The Neighbouring Values Differ Numerously.
    #0,0,0,0,0,0,0,0,   # The Picture Shows A Checker-Like Appearance.
    #0,0,0,0,0,0,0,0,
    #0,0,0,0,0,0,0,0,
    #0,0,0,0,0,0,0,0,
    #0,0,0,0,0,0,0,500]

IDCT = [ # Inverse Discrete Cosine Transform (IDCT) 8x8 Output Block
    0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0]

Q = 8 # Quantization Value
      # In MPEG There Is A Quantization Matrix Which Defines A Different
      # Quantization Value For Every Transform Value Depending On Its Position

DC = DCT[0] # DC Value
y = 0 # Row
while y < 8:
    x = 0 # Column
    while x < 8:
        IDCT[(y * 8) + x] = DC / Q # Quantization Value Of 8 Is Applied
        x += 1
    y += 1

print ("Discrete Cosine Transform (DCT) 8x8 Input Block:") # Print The DCT 8x8 Input Block
print ("%d,%d,%d,%d,%d,%d,%d,%d" % (DCT[0],DCT[1],DCT[2],DCT[3],DCT[4],DCT[5],DCT[6],DCT[7]))
print ("%d,%d,%d,%d,%d,%d,%d,%d" % (DCT[8],DCT[9],DCT[10],DCT[11],DCT[12],DCT[13],DCT[14],DCT[15]))
print ("%d,%d,%d,%d,%d,%d,%d,%d" % (DCT[16],DCT[17],DCT[18],DCT[19],DCT[20],DCT[21],DCT[22],DCT[23]))
print ("%d,%d,%d,%d,%d,%d,%d,%d" % (DCT[24],DCT[25],DCT[26],DCT[27],DCT[28],DCT[29],DCT[30],DCT[31]))
print ("%d,%d,%d,%d,%d,%d,%d,%d" % (DCT[32],DCT[33],DCT[34],DCT[35],DCT[36],DCT[37],DCT[38],DCT[39]))
print ("%d,%d,%d,%d,%d,%d,%d,%d" % (DCT[40],DCT[41],DCT[42],DCT[43],DCT[44],DCT[45],DCT[46],DCT[47]))
print ("%d,%d,%d,%d,%d,%d,%d,%d" % (DCT[48],DCT[49],DCT[50],DCT[51],DCT[52],DCT[53],DCT[54],DCT[55]))
print ("%d,%d,%d,%d,%d,%d,%d,%d" % (DCT[56],DCT[57],DCT[58],DCT[59],DCT[60],DCT[61],DCT[62],DCT[63]))

print ("Inverse Discrete Cosine Transform (IDCT) 8x8 Output Block:") # Print The IDCT 8x8 Output Block
print ("%d,%d,%d,%d,%d,%d,%d,%d" % (IDCT[0],IDCT[1],IDCT[2],IDCT[3],IDCT[4],IDCT[5],IDCT[6],IDCT[7]))
print ("%d,%d,%d,%d,%d,%d,%d,%d" % (IDCT[8],IDCT[9],IDCT[10],IDCT[11],IDCT[12],IDCT[13],IDCT[14],IDCT[15]))
print ("%d,%d,%d,%d,%d,%d,%d,%d" % (IDCT[16],IDCT[17],IDCT[18],IDCT[19],IDCT[20],IDCT[21],IDCT[22],IDCT[23]))
print ("%d,%d,%d,%d,%d,%d,%d,%d" % (IDCT[24],IDCT[25],IDCT[26],IDCT[27],IDCT[28],IDCT[29],IDCT[30],IDCT[31]))
print ("%d,%d,%d,%d,%d,%d,%d,%d" % (IDCT[32],IDCT[33],IDCT[34],IDCT[35],IDCT[36],IDCT[37],IDCT[38],IDCT[39]))
print ("%d,%d,%d,%d,%d,%d,%d,%d" % (IDCT[40],IDCT[41],IDCT[42],IDCT[43],IDCT[44],IDCT[45],IDCT[46],IDCT[47]))
print ("%d,%d,%d,%d,%d,%d,%d,%d" % (IDCT[48],IDCT[49],IDCT[50],IDCT[51],IDCT[52],IDCT[53],IDCT[54],IDCT[55]))
print ("%d,%d,%d,%d,%d,%d,%d,%d" % (IDCT[56],IDCT[57],IDCT[58],IDCT[59],IDCT[60],IDCT[61],IDCT[62],IDCT[63]))

