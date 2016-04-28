import struct
brrfile = open("Sample.brr", "rb").read()
decoded = []
older = 0 # Older Sample (Previous To Last Sample)
old = 0   # Old Sample (Last Sample)
new = 0   # New Sample (Current Sample)

i = 0 # Byte Counter
while i < len(brrfile):
    # Decode 9 Byte Block, Byte 0 = Block Header
    blockheader = struct.unpack("@B", brrfile[i:i+1])
    loopendflags = blockheader[0] & 0x3 # Loop/End Flags (Bits 0..1)
    filternumber = (blockheader[0] >> 2) & 0x3 # Filter Number (Bits 0..1)
    shiftamount = (blockheader[0] >> 4) & 0xF # Shift Amount

    s = 0 # Sample Byte Counter
    while s < 8:
        # Next 8 Bytes Contain 2 Signed 4-Bit Sample Nibbles Each (-8..+7)
        # Sample 1 = Bits 4..7 & Sample 2 = Bits 0..3
        samplebyte = struct.unpack("@B", brrfile[i+1:i+2]) # Byte 1
        sample1 = (samplebyte[0] >> 4)  # Sample 1 Unsigned Nibble
        if sample1 > 7: sample1 -= 16 # Convert Sample 1 To Signed Nibble
        sample2 = (samplebyte[0] & 0xF) # Sample 2 Unsigned Nibble
        if sample2 > 7: sample2 -= 16 # Convert Sample 2 To Signed Nibble

        # Shift Samples
        if shiftamount < 13:
            sample1 <<= shiftamount # Sample 1 SHL Shift Amount
            sample1 >>= 1 # Sample 1 SAR 1
            sample2 <<= shiftamount # Sample 2 SHL Shift Amount
            sample2 >>= 1 # Sample 2 SAR 1
        else:
            sample1 <<= 12 # Sample 1 SHL 12
            sample1 >>= 3  # Sample 1 SAR 3
            sample2 <<= 12 # Sample 2 SHL 12
            sample2 >>= 3  # Sample 2 SAR 3

        # Filter Samples
        new = sample1 # Filter 0
        if filternumber == 1: new += old + (-old >> 4)
        if filternumber == 2: new += (old << 1) + ((-old * 3)  >> 5) - older + (older >> 4)
        if filternumber == 3: new += (old << 1) + ((-old * 13) >> 6) - older + ((older * 3) >> 4)
        older = old
        old = new
        decoded.append(new)
        new = sample2 # Filter 0
        if filternumber == 1: new += old + (-old >> 4)
        if filternumber == 2: new += (old << 1) + ((-old * 3)  >> 5) - older + (older >> 4)
        if filternumber == 3: new += (old << 1) + ((-old * 13) >> 6) - older + ((older * 3) >> 4)
        older = old
        old = new
        decoded.append(new)

        s += 1 # Increment Sample Byte Count
        i += 1 # Increment Byte Count

    i += 1 # Increment Byte Count For Next Block
    
print ("Decoded Samples = %d (%d Bytes)" % (len(decoded), (len(decoded) * 2)))

with open('out.bin', 'wb') as f:
    for b in decoded: f.write(struct.pack('h', b))
