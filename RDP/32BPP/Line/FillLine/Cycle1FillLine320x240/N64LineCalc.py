# Sort Triangle By Y Coordinates (Highest To Lowest)
# IF Coordinate 0 & 1 Share Same Y: Sort By X Coordinates (Lowest To Highest)

line = (25.0, 100.0), (75.0, 50.0) # Y Sorted Line
#line = (150.0, 100.0), (100.0, 50.0) # Y Sorted Line
#line = (175.0, 100.0), (175.0, 50.0) # Y Sorted Line
#line = (300.0, 100.0), (250.0, 100.0) # Y Sorted Line
#line = (75.0, 175.0), (25.0, 150.0) # Y Sorted Line
#line = (125.0, 200.0), (150.0, 150.0) # Y Sorted Line
#line = (175.0, 175.0), (225.0, 150.0) # Y Sorted Line
#line = (300.0, 200.0), (275.0, 150.0) # Y Sorted Line

XL = line[0][0] # XL = line[0].x
XH = line[1][0] # XH = line[1].x
YL = line[0][1] # YL = line[0].y
YH = line[1][1] # YH = line[1].y

DxDy = 0.0
if XL == XH: XL += 1 # Vertical Line (|)
else:
    if YL == YH: YL += 1 # Horizontal Line (-)
    else:
        DxDy = (XL - XH) / (YL - YH) # DxDy = X / Y
        if abs(DxDy) < 1: XL = XH + 1 # Lines With X Distance < 1
        else: XL = XH + abs(DxDy) # Forward Line (/), Backward Line (\)

print ("YL = %f" % YL)
print ("YH = %f" % YH)
print ("XL = %f" % XL)
print ("XH = %f" % XH)
print ("DxDy = %f\n" % DxDy)
YL *= 4.0 # Convert YL Into 11.2 Fixed Point Format
YH *= 4.0 # Convert YH Into 11.2 Fixed Point Format
XLf = (XL % 1) * 65536 # Convert XL 16-Bit Fraction
XHf = (XH % 1) * 65536 # Convert XH 16-Bit Fraction
if (DxDy < 0.0) and (DxDy > -1.0): DxDy -= 1.0 # Convert DxDy 16-Bit Signed Integer
DxDyf = (DxDy % 1) * 65536 # Convert DxDy 16-Bit Fraction
print ("Fill_Triangle 1,0,0, %i,%i,%i, %i,%i,%i,%i, %i,%i,%i,%i, 0,0,0,0" % (YL,YH,YH, XL,XLf, DxDy,DxDyf, XH,XHf, DxDy,DxDyf))
