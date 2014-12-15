Compress
===========
<br />
Compression MIPS Code by krom (Peter Lemon).<br />
<br />
I have provided examples of LZ77 & Huffman decompression, compatible with the same standards used by<br />
Nintendo GBA/DS bios decompression functions.<br />
There is a simple minimal demo & a GFX demo for both LZ77 & Huffman.<br />
The minimal demos decompress image data to RAM.<br />
The GFX demos decompress image data to the screen.<br />
<br />
The best LZ77/Huffman compressor I have found is called "Nintendo DS/GBA Compressors" by CUE.<br />
You can find it here: http://www.romhacking.net/utilities/826/<br />
It also includes full CPP source code for all of it's compressors.<br />
<br />
Here is an url to the best explanation of LZ77/Huffman decompression I have found:<br />
http://nocash.emubase.de/gbatek.htm#biosdecompressionfunctions<br />
<br />
P.S The variant of LZ77 on GBA/NDS is sometimes called LZSS hence the naming scheme in this util,<br />
but you will find that it is indeed LZ77 compatible data.<br />
<br />
Huffman:<br />
Command line used to compress data: "huffman -e8 Image.bin"<br />
Original data size: Image.bin = 1228800 bytes<br />
Compress data size: Image.huff = 230592 bytes<br />
<br />
LZ77:<br />
Command line used to compress data: "lzss -ewo Image.bin"<br />
Original data size: Image.bin = 1228800 bytes<br />
Compress data size: Image.lz = 145741 bytes<br />
<br />
Many thanks to my friend Andy Smith, who helped me understand the Huffman decoding =D<br />