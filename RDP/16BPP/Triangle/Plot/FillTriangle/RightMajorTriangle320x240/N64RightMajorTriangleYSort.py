# Sort Triangle By Y Coordinates (Highest To Lowest)
# IF Coordinate 0 & 1 Share Same Y: Sort By X Coordinates (Lowest To Highest)
# IF Coordinate 1 & 2 Share Same Y: Sort By X Coordinates (Highest To Lowest)

#triu = (25.0, 100.0), (75.0, 50.0), (25.0, 50.0) # Unsorted Triangle
#triu = (25.0, 100.0), (25.0, 50.0), (75.0, 50.0) # Unsorted Triangle
#triu = (75.0, 50.0), (25.0, 100.0), (25.0, 50.0) # Unsorted Triangle
#triu = (75.0, 50.0), (25.0, 50.0), (25.0, 100.0) # Unsorted Triangle
#triu = (25.0, 50.0), (25.0, 100.0), (75.0, 50.0) # Unsorted Triangle
#triu = (25.0, 50.0), (75.0, 50.0), (25.0, 100.0) # Unsorted Triangle
#tricheck = (25.0, 100.0), (75.0, 50.0), (25.0, 50.0) # Y Sorted Triangle Check

#triu = (150.0, 100.0), (150.0, 50.0), (100.0, 50.0) # Unsorted Triangle
#triu = (150.0, 100.0), (100.0, 50.0), (150.0, 50.0) # Unsorted Triangle
#triu = (150.0, 50.0), (150.0, 100.0), (100.0, 50.0) # Unsorted Triangle
#triu = (150.0, 50.0), (100.0, 50.0), (150.0, 100.0) # Unsorted Triangle
#triu = (100.0, 50.0), (150.0, 100.0), (150.0, 50.0) # Unsorted Triangle
#triu = (100.0, 50.0), (150.0, 50.0), (150.0, 100.0) # Unsorted Triangle
#tricheck = (150.0, 100.0), (150.0, 50.0), (100.0, 50.0) # Y Sorted Triangle Check

#triu = (175.0, 100.0), (225.0, 100.0), (225.0, 50.0) # Unsorted Triangle
#triu = (175.0, 100.0), (225.0, 50.0), (225.0, 100.0) # Unsorted Triangle
#triu = (225.0, 100.0), (175.0, 100.0), (225.0, 50.0) # Unsorted Triangle
#triu = (225.0, 100.0), (225.0, 50.0), (175.0, 100.0) # Unsorted Triangle
#triu = (225.0, 50.0), (175.0, 100.0), (225.0, 100.0) # Unsorted Triangle
#triu = (225.0, 50.0), (225.0, 100.0), (175.0, 100.0) # Unsorted Triangle
#tricheck = (175.0, 100.0), (225.0, 100.0), (225.0, 50.0) # Y Sorted Triangle Check

#triu = (250.0, 100.0), (300.0, 100.0), (250.0, 50.0) # Unsorted Triangle
#triu = (250.0, 100.0), (250.0, 50.0), (300.0, 100.0) # Unsorted Triangle
#triu = (300.0, 100.0), (250.0, 100.0), (250.0, 50.0) # Unsorted Triangle
#triu = (300.0, 100.0), (250.0, 50.0), (250.0, 100.0) # Unsorted Triangle
#triu = (250.0, 50.0), (250.0, 100.0), (300.0, 100.0) # Unsorted Triangle
#triu = (250.0, 50.0), (300.0, 100.0), (250.0, 100.0) # Unsorted Triangle
#tricheck = (250.0, 100.0), (300.0, 100.0), (250.0, 50.0) # Y Sorted Triangle Check

#triu = (25.0, 200.0), (75.0, 175.0), (25.0, 150.0) # Unsorted Triangle
#triu = (25.0, 200.0), (25.0, 150.0), (75.0, 175.0) # Unsorted Triangle
#triu = (75.0, 175.0), (25.0, 200.0), (25.0, 150.0) # Unsorted Triangle
#triu = (75.0, 175.0), (25.0, 150.0), (25.0, 200.0) # Unsorted Triangle
#triu = (25.0, 150.0), (25.0, 200.0), (75.0, 175.0) # Unsorted Triangle
#triu = (25.0, 150.0), (75.0, 175.0), (25.0, 200.0) # Unsorted Triangle
#tricheck = (25.0, 200.0), (75.0, 175.0), (25.0, 150.0) # Y Sorted Triangle Check

#triu = (125.0, 200.0), (150.0, 150.0), (100.0, 150.0) # Unsorted Triangle
#triu = (125.0, 200.0), (100.0, 150.0), (150.0, 150.0) # Unsorted Triangle
#triu = (150.0, 150.0), (125.0, 200.0), (100.0, 150.0) # Unsorted Triangle
#triu = (150.0, 150.0), (100.0, 150.0), (125.0, 200.0) # Unsorted Triangle
#triu = (100.0, 150.0), (125.0, 200.0), (150.0, 150.0) # Unsorted Triangle
#triu = (100.0, 150.0), (150.0, 150.0), (125.0, 200.0) # Unsorted Triangle
#tricheck = (125.0, 200.0), (150.0, 150.0), (100.0, 150.0) # Y Sorted Triangle Check

#triu = (225.0, 200.0), (175.0, 175.0), (225.0, 150.0) # Y Unsorted Triangle
#triu = (225.0, 200.0), (225.0, 150.0), (175.0, 175.0) # Y Unsorted Triangle
#triu = (175.0, 175.0), (225.0, 200.0), (225.0, 150.0) # Y Unsorted Triangle
#triu = (175.0, 175.0), (225.0, 150.0), (225.0, 200.0) # Y Unsorted Triangle
#triu = (225.0, 150.0), (225.0, 200.0), (175.0, 175.0) # Y Unsorted Triangle
#triu = (225.0, 150.0), (175.0, 175.0), (225.0, 200.0) # Y Unsorted Triangle
#tricheck = (225.0, 200.0), (175.0, 175.0), (225.0, 150.0) # Y Sorted Triangle Check

#triu = (250.0, 200.0), (300.0, 200.0), (275.0, 150.0) # Unsorted Triangle
#triu = (250.0, 200.0), (275.0, 150.0), (300.0, 200.0) # Unsorted Triangle
#triu = (300.0, 200.0), (250.0, 200.0), (275.0, 150.0) # Unsorted Triangle
#triu = (300.0, 200.0), (275.0, 150.0), (250.0, 200.0) # Unsorted Triangle
#triu = (275.0, 150.0), (250.0, 200.0), (300.0, 200.0) # Unsorted Triangle
triu = (275.0, 150.0), (300.0, 200.0), (250.0, 200.0) # Unsorted Triangle
tricheck = (250.0, 200.0), (300.0, 200.0), (275.0, 150.0) # Y Sorted Triangle Check

triX0 = triu[0][0]
triY0 = triu[0][1]
triX1 = triu[1][0]
triY1 = triu[1][1]
triX2 = triu[2][0]
triY2 = triu[2][1]

# PASS1 Sort Coordinate 0 & 1
if (triY0 <= triY1):
    tempX = triX0
    tempY = triY0
    triX0 = triX1
    triY0 = triY1
    triX1 = tempX
    triY1 = tempY

# PASS1 Sort Coordinate 1 & 2
if (triY1 <= triY2):
    tempX = triX1
    tempY = triY1
    triX1 = triX2
    triY1 = triY2
    triX2 = tempX
    triY2 = tempY

# PASS1 Sort Coordinate 2 & 0
if (triY0 <= triY2):
    tempX = triX0
    tempY = triY0
    triX0 = triX2
    triY0 = triY2
    triX2 = tempX
    triY2 = tempY

# PASS1 Sort Coordinate 0 & 1
if (triY0 <= triY1):
    tempX = triX0
    tempY = triY0
    triX0 = triX1
    triY0 = triY1
    triX1 = tempX
    triY1 = tempY

# PASS2 Sort Coordinate 0 & 1
if (triY0 == triY1) and (triX0 >= triX1):
    tempX = triX0
    tempY = triY0
    triX0 = triX1
    triY0 = triY1
    triX1 = tempX
    triY1 = tempY

# PASS2 Sort Coordinate 1 & 2
if (triY1 == triY2) and (triX1 <= triX2):
    tempX = triX1
    tempY = triY1
    triX1 = triX2
    triY1 = triY2
    triX2 = tempX
    triY2 = tempY

pass0 = 0
pass1 = 0
pass2 = 0
if (triX0 == tricheck[0][0]) and (triY0 == tricheck[0][1]): pass0 = 1
if (triX1 == tricheck[1][0]) and (triY1 == tricheck[1][1]): pass1 = 1
if (triX2 == tricheck[2][0]) and (triY2 == tricheck[2][1]): pass2 = 1

if (pass0) and (pass1) and (pass2): print ("Triangle Y Sort Passed")
else: print ("Triangle Y Sort Failed")

print triX0,triY0,triX1,triY1,triX2,triY2
print tricheck
