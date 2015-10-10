# Sort Line By Y Coordinates (Highest To Lowest)
# IF Coordinate 0 & 1 Share Same Y: Sort By X Coordinates (Lowest To Highest)

#lineu = (25.0, 100.0), (75.0, 50.0) # Unsorted Line
#lineu = (75.0, 50.0), (25.0, 100.0) # Unsorted Line
#linecheck = (25.0, 100.0), (75.0, 50.0) # Y Sorted Line Check

#lineu = (150.0, 100.0), (100.0, 50.0) # Unsorted Line
#lineu = (100.0, 50.0), (150.0, 100.0) # Unsorted Line
#linecheck = (150.0, 100.0), (100.0, 50.0) # Y Sorted Line Check

#lineu = (175.0, 100.0), (175.0, 50.0) # Unsorted Line
#lineu = (175.0, 50.0), (175.0, 100.0) # Unsorted Line
#linecheck = (175.0, 100.0), (175.0, 50.0) # Y Sorted Line Check

#lineu = (300.0, 100.0), (250.0, 100.0) # Unsorted Line
#lineu = (250.0, 100.0), (300.0, 100.0) # Unsorted Line
#linecheck = (300.0, 100.0), (250.0, 100.0) # Y Sorted Line Check

#lineu = (75.0, 175.0), (25.0, 150.0) # Unsorted Line
#lineu = (25.0, 150.0), (75.0, 175.0) # Unsorted Line
#linecheck = (75.0, 175.0), (25.0, 150.0) # Y Sorted Line Check

#lineu = (125.0, 200.0), (150.0, 150.0) # Unsorted Line
#lineu = (150.0, 150.0), (125.0, 200.0) # Unsorted Line
#linecheck = (125.0, 200.0), (150.0, 150.0) # Y Sorted Line Check

#lineu = (175.0, 175.0), (225.0, 150.0) # Unsorted Line
#lineu = (225.0, 150.0), (175.0, 175.0) # Unsorted Line
#linecheck = (175.0, 175.0), (225.0, 150.0) # Y Sorted Line Check

#lineu = (300.0, 200.0), (275.0, 150.0) # Unsorted Line
lineu = (275.0, 150.0), (300.0, 200.0) # Unsorted Line
linecheck = (300.0, 200.0), (275.0, 150.0) # Y Sorted Line Check

lineX0 = lineu[0][0]
lineY0 = lineu[0][1]
lineX1 = lineu[1][0]
lineY1 = lineu[1][1]

# PASS1 Sort Y Coordinate 0 & 1
if (lineY0 < lineY1):
    tempX = lineX0
    tempY = lineY0
    lineX0 = lineX1
    lineY0 = lineY1
    lineX1 = tempX
    lineY1 = tempY

# PASS2 Sort X Coordinate 0 & 1
if (lineY0 == lineY1) and (lineX0 < lineX1):
    tempX = lineX0
    tempY = lineY0
    lineX0 = lineX1
    lineY0 = lineY1
    lineX1 = tempX
    lineY1 = tempY

pass0 = 0
pass1 = 0
if (lineX0 == linecheck[0][0]) and (lineY0 == linecheck[0][1]): pass0 = 1
if (lineX1 == linecheck[1][0]) and (lineY1 == linecheck[1][1]): pass1 = 1

if (pass0) and (pass1): print ("Line Y Sort Passed")
else: print ("Line Y Sort Failed")

print (lineX0,lineY0,lineX1,lineY1)
print (linecheck)
