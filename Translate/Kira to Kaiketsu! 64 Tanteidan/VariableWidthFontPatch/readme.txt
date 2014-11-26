  Backward-compatible single-char VWF support.  Use 0x7F to turn it on and off.  When on it replaces the normal 1-char numerical halfwidth font.  Does +not+ break the special chars (A0, A1, etc.) so be careful with their use.

  This revision should have proper char-by-char display (at least via 800476B8).  This string parser breaks on newlines (0xA or "\n") but has been recoded so it does +not+ require a new 0x7F on each line.  Block ACII text can be displayed with only one use of 0x7F.  +This is a change from the initial patch+
  The parser now reads the (probable) display width of the string to determine where autowrapping occurs.  Displayed char count per row is only retained for debug purposes mostly because it was helpful during debugging.  To avoid recoding all uses of the parser, the normal entry point converts A3 from max strlen per row to physical width per row through multiplication.  To provide the function a physical width on A3, use the alternate entry point 800476C0
  Besides the wchar autowrap combinations, ascii combinations have also been added.  Refer to parserHack!.txt for details.

  Also added "#", "'", ",", and "@" into the ASCII set without need of special codes.  This is documented in DLgenHACK!.txt.
  Tabs are still dumb tabs, not aligning tabs.  If it turns out you need this support it can be added (somewhat more painfully).

  There's at least one more parser to take care of, used during gameplay, residing at 800C9F28-800CA494.

  Provided is a patch to apply the necessary changes and documents disassembling the rewritten routines.  You will need to recalculate the checksum after applying the patch.
  Altered regions:
	0x482B8	0x48788
	0x5FDFC	0x610C0
	0xEDD62	0xEDDAA

-Zoinkity
