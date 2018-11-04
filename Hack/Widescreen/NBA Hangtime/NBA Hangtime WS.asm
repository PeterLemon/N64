// N64 "NBA Hangtime" Widescreen Hack by gamemasterplc:

arch n64.cpu
endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "NBA Hangtime WS.z64", create
origin $00000000; insert "NBA Hangtime (U) [!].z64" // Include USA NBA Hangtime N64 ROM
origin $00000020
db "NBA HANGTIME WS            " // $00000020 - PROGRAM TITLE (27 Byte ASCII String, Use Spaces For Unused Bytes)

include "LIB/N64.INC" // Include N64 Definitions

constant SCREEN_WIDTH(424)
constant SCREEN_HEIGHT(240)
constant BYTES_PER_PIXEL(2)
constant NUM_FRAMEBUFFERS(2)
constant DEFAULT_RAM_SIZE(4194304)

origin $00017208
lui t1, (8687-SCREEN_WIDTH) //Max X Position of Camera After Dunks

origin $00017344
lui t8, (8667-SCREEN_WIDTH) //Max X Position of Camera During Dunks

origin $00017400
addiu t7, t8, ((SCREEN_WIDTH/2)-16) //Camera X Offset

origin $0001748C
addiu t1, a0, -((SCREEN_WIDTH/2)+40) //Camera Offset for Edge of Stage

origin $000174B4
addiu t1, a0, -((SCREEN_WIDTH/2)+40) //Camera Offset for Everywhere Else on Stage

origin $0001E81C
addiu a0, r0, (SCREEN_WIDTH+12) //Starting X Position of Slide In of Right Ball Jump Meter

origin $0001E888
addiu a0, r0, (SCREEN_WIDTH+12) //Destination X Position of Slide Out of Right Ball Jump Meter

origin $0001E91C
addiu a0, r0, (SCREEN_WIDTH-26) //Destination X Position of Slide In of Right Ball Jump Meter

origin $0001E790
lui t7, (SCREEN_WIDTH+12) //X Position of Right Ball Jump Meter

origin $00026740
addiu t9, r0, (SCREEN_WIDTH) //Width of Pause Screen Filter

origin $00026758
lui s5, (SCREEN_WIDTH/2) //X Position of Quit Explanation

origin $00027024
slti at, v0, (SCREEN_WIDTH-19) //X Position to Hide Right-Side Offscreen Player Marker

origin $00027154
slti at, v0, (SCREEN_WIDTH-5) //X Position to Show Right-Side Offscreen Player Marker

origin $00027188
addiu s3, r0, (SCREEN_WIDTH-61) //X Position of Player 2 Offscreen Marker

origin $000271A0
addiu s3, r0, (SCREEN_WIDTH-61) //X Position of Player 1 Offscreen Marker

origin $000271B0
addiu s3, r0, (SCREEN_WIDTH-61) //X Position of Player 3 Offscreen Marker

origin $000271B8
addiu s3, r0, (SCREEN_WIDTH-61) //X Position of Player 4 Offscreen Marker

origin $000272E4
lui t7, (SCREEN_WIDTH-29) //Stop X Position of Offscreen Player Marker

origin $00027314
lui at, (SCREEN_WIDTH-29) //Clamp X Position of Offscreen Player Marker

origin $0002732C
lui at, (SCREEN_WIDTH-29) //Alternate Clamp X Position of Offscreen Player Marker

origin $0002854C
lui t6, ((SCREEN_WIDTH/2)+1) //X Position of Deciseconds of Timer with Less Than One Minute

origin $00028554
lui t8, ((SCREEN_WIDTH/2)-14) //X Position of Seconds Timer with Less Than One Minute

origin $0002861C
lui t9, ((SCREEN_WIDTH/2)-14) //X Position of Minutes Timer at Timer End

origin $00028628
lui t1, ((SCREEN_WIDTH/2)-4) //X Position of Seconds Timer at Timer End

origin $00029460
lui t6, (SCREEN_WIDTH-84) //X Position of Hundreds Digit of Team 1 Score

origin $000294EC
lui t4, (SCREEN_WIDTH-70) //X Position of Tens Digit of Team 1 Score

origin $00029570
lui t5, (SCREEN_WIDTH-56) //X Position of Ones Digit of Team 1 Score

origin $00029608
lui t6, (SCREEN_WIDTH-84) //X Position of Hundreds Digit of Team 2 Score

origin $00029698
lui t8, (SCREEN_WIDTH-70) //X Position of Tens Digit of Team 2 Score

origin $00029720
lui t9, (SCREEN_WIDTH-56) //X Position of Tens Digit of Team 2 Score

origin $0002A810
lui t8, (SCREEN_WIDTH/2) //X Position of Touurnament Mode Warning Header

origin $0002A854
lui t4, (SCREEN_WIDTH/2) //X Position of Touurnament Mode Warning Text Line 1

origin $0002A898
lui t0, (SCREEN_WIDTH/2) //X Position of Touurnament Mode Warning Text Line 2

origin $0002A91C
lui t8, (SCREEN_WIDTH/2) //X Position of No CPU Assistance Warning

origin $00030A84
lui t5, (SCREEN_WIDTH/2) //X Position of Right Half of Header Bar

origin $00031D8C
addiu t8, r0, (SCREEN_WIDTH) //Width of Quarter Fadeouts

origin $00032100
lui t6, (8672-SCREEN_WIDTH) //Starting X Position of Camera

origin $00033778
addiu t7, r0, (SCREEN_WIDTH+20) //Width of Options Fadeout

origin $00033818
addiu t7, r0, (SCREEN_WIDTH+20) //Width of Options Fadein

origin $00033930
addiu t8, r0, (SCREEN_WIDTH) //Width of Fadeouts

origin $000356E4
lui a3, ((SCREEN_WIDTH/2)-91) //X Position of Select a Player Box

origin $0003B588
addiu t9, r0, ((SCREEN_WIDTH/2)-108) //X Position of Win Record Number on Best Overall Player Screen

origin $0003B5E0
addiu t3, r0, ((SCREEN_WIDTH/2)-42) //X Position of Win Streak Number on Best Overall Player Screen

origin $0003B614
addiu t5, r0, ((SCREEN_WIDTH/2)+8) //X Position of Win Average Number on Best Overall Player Screen

origin $0003B684
addiu t9, r0, ((SCREEN_WIDTH/2)+63) //X Position of Defensive Rank Number on Best Overall Player Screen

origin $0003B6C4
addiu t1, r0, ((SCREEN_WIDTH/2)+127) //X Position of Offensive Rank Number on Best Overall Player Screen

origin $0003B704
addiu t3, r0, ((SCREEN_WIDTH/2)-96) //X Position of Average Points Scored Number on Best Overall Player Screen

origin $0003B728
addiu t5, r0, ((SCREEN_WIDTH/2)-20) //X Position of Average Points Allowed Number on Best Overall Player Screen

origin $0003B74C
addiu t7, r0, ((SCREEN_WIDTH/2)+53) //X Position of Teams Defeated Number on Best Overall Player Screen

origin $0003B780
addiu t9, r0, ((SCREEN_WIDTH/2)+127) //X Position of Games Playedd Number on Best Overall Player Screen

origin $0003B7F8
addiu t6, r0, ((SCREEN_WIDTH/2)+7) //X Position of Grand Champions List

origin $0003BB40
addiu s7, r0, ((SCREEN_WIDTH/2)+94) //X Position of Win Percentage on Greatest Players Screen

origin $0003BB58
addiu t2, r0, ((SCREEN_WIDTH/2)-93) //X Position of Ranking Number on Greatest Players Screen

origin $0003BB84
addiu t3, r0, ((SCREEN_WIDTH/2)-112) //X Position of Hashtag on Greatest Players Screen

origin $0003BBA0
addiu t6, r0, ((SCREEN_WIDTH/2)-40) //X Position of Player Name on Greatest Players Screen

origin $0003BBC8
addiu t7, r0, ((SCREEN_WIDTH/2)+30) //X Position of Win Streak on Greatest Players Screen

origin $0003BBEC
addiu t8, r0, ((SCREEN_WIDTH/2)+32) //X Position of Dash on Greatest Players Screen

origin $0003BC00
addiu t9, r0, ((SCREEN_WIDTH/2)+44) //X Position of Dash on Greatest Players Screen

origin $0003BDC4
addiu r30, r0, ((SCREEN_WIDTH/2)-93) //X Position of Ranking Number on Best Offensive Players Screen

origin $0003BE00
addiu t2, r0, ((SCREEN_WIDTH/2)-112) //X Position of Hashtag on Best Offensive Players Screen

origin $0003BE1C
addiu t5, r0, ((SCREEN_WIDTH/2)-40) //X Position of Player Name on Best Offensive Players Screen

origin $0003BE44
addiu t6, r0, ((SCREEN_WIDTH/2)+44) //X Position of Team Points Number on Best Offensive Players Screen

origin $0003BF44
addiu r30, r0, ((SCREEN_WIDTH/2)-93) //X Position of Ranking Number on Best Offensive Players Screen

origin $0003BF80
addiu t2, r0, ((SCREEN_WIDTH/2)-112) //X Position of Hashtag on Best Defensive Players Screen

origin $0003BF9C
addiu t5, r0, ((SCREEN_WIDTH/2)-40) //X Position of Player Name on Best Defensive Players Screen

origin $0003BFC4
addiu t6, r0, ((SCREEN_WIDTH/2)+44) //X Position of Team Points Number on Best Defensive Players Screen

origin $0003C0C0
addiu t7, r0, ((SCREEN_WIDTH/2)+94) //X Position of Win Percent Number on Experienced Players Screen

origin $0003C0D8
addiu t2, r0, ((SCREEN_WIDTH/2)-93) //X Position of Ranking Number on Experienced Players Screen

origin $0003C104
addiu t3, r0, ((SCREEN_WIDTH/2)-112) //X Position of Hashtag on Experienced Players Screen

origin $0003C120
addiu t6, r0, ((SCREEN_WIDTH/2)-40) //X Position of Player Name on Experienced Players Screen

origin $0003C148
addiu t7, r0, ((SCREEN_WIDTH/2)+37) //X Position of Games Played Number on Experienced Players Screen

origin $0003C308
addiu t1, r0, ((SCREEN_WIDTH/2)-93) //X Position of Ranking Number on Current Winning Streak Screen

origin $0003C33C
addiu t2, r0, ((SCREEN_WIDTH/2)-112) //X Position of Hashtag on Current Winning Streak Screen

origin $0003C358
addiu t5, r0, ((SCREEN_WIDTH/2)-40) //X Position of Player Name on Current Winning Streak Screen

origin $0003C380
addiu t6, r0, ((SCREEN_WIDTH/2)+61) //X Position of Win Streak on Current Winning Streak Screen

origin $0003C49C
addiu t1, r0, ((SCREEN_WIDTH/2)-93) //X Position of Ranking Number on Trivia Masters Screen

origin $0003C4D0
addiu t2, r0, ((SCREEN_WIDTH/2)-112) //X Position of Hashtag on Trivia Masters Screen

origin $0003C4EC
addiu t5, r0, ((SCREEN_WIDTH/2)-40) //X Position of Player Name on Trivia Masters Screen

origin $0003C514
addiu t6, r0, ((SCREEN_WIDTH/2)+52) //X Position of Score on Trivia Masters Screen

origin $0003CBFC
addiu a1, r0, ((SCREEN_WIDTH/2)+85) //X Position of Team 2 Team Names List on Teams Screen

origin $0003CC28
addiu a1, r0, ((SCREEN_WIDTH/2)-150) //X Position of Team 1 Team Names List on Teams Screen

origin $00041764
lui t6, ((((SCREEN_WIDTH/2)+198)*320)/400) //X Position of Player on Create Player Screen

origin $00041AF8
lui t9, ((SCREEN_WIDTH/2)+73) //X Position of Stat Descriptions for Created Player

origin $00041B5C
lui s5, ((SCREEN_WIDTH/2)+102) //X Position of Stats for Created Player

origin $00041BE4
addiu a0, r0, ((SCREEN_WIDTH/2)+108) //X Position of Name of Created Player

origin $00042024
lui t6, ((SCREEN_WIDTH/2)-60) //X Position of Heads on Head Selection Screen

origin $000420FC
lui t8, ((SCREEN_WIDTH/2)-45) //X Position of Player Number on Head Selection Screen

origin $0004215C
lui t4, ((SCREEN_WIDTH/2)-33) //X Position of Coach Head Selection Screen

origin $000424D4
lui t6, ((SCREEN_WIDTH/2)-22) //X Position of Attributes Points Used

origin $00042594
lui t6, ((SCREEN_WIDTH/2)-12) //X Position of Attributes List

origin $000437D8
addiu v0, r0, ((SCREEN_WIDTH/2)-12) //X Position of Name on Create Player Screen

origin $000450A0
lui at, ((SCREEN_WIDTH/2)-160) //X Position of Game Logo Background

origin $000450C0
sw at, 12(v0) //Update X Position of Game Logo Background

origin $00045378
lui t6, ((SCREEN_WIDTH/2)-48) //X Position of Main Menu Box

origin $0004660C
addiu t9, r0, ((SCREEN_WIDTH/2)-152) //X Position of P1 Halftime Stats

origin $0004665C
addiu t2, r0, ((SCREEN_WIDTH/2)-60) //X Position of P2 Halftime Stats

origin $000466AC
addiu t5, r0, ((SCREEN_WIDTH/2)+4) //X Position of P3 Halftime Stats

origin $000466FC
addiu t8, r0, ((SCREEN_WIDTH/2)+95) //X Position of P4 Halftime Stats

origin $00046AB4
addiu t6, r0, ((SCREEN_WIDTH/2)-125) //X Position of Left Team Score on 1st Half Stats

origin $00046AE0
addiu t7, r0, ((SCREEN_WIDTH/2)+127) //X Position of Right Team Score on 1st Half Stats

origin $0004756C
lui t9, ((SCREEN_WIDTH/2)+80) //Starring Screen Ball X Position

origin $0004762C
lui t6, ((SCREEN_WIDTH/2)+80) //Starring Screen Team Logo X Position

origin $00047670
lui t4, ((SCREEN_WIDTH/2)-168) //X Position Team Member 1 Face Background Starring Screen

origin $000476A0
lui t7, ((SCREEN_WIDTH/2)-148) //X Position Team Member 1 Face Starring Screen

origin $00047748
lui t1, ((SCREEN_WIDTH/2)-108) //X Position Team Member 2 Face Background Starring Screen

origin $00047778
lui t4, ((SCREEN_WIDTH/2)-88) //X Position Team Member 2 Face Starring Screen

origin $00047818
lui t7, ((SCREEN_WIDTH/2)-48) //X Position Team Member 3 Face Background Starring Screen

origin $00047848
lui t0, ((SCREEN_WIDTH/2)-28) //X Position Team Member 3 Face Starring Screen

origin $000478E8
lui t3, ((SCREEN_WIDTH/2)+12) //X Position Team Member 4 Face Background Starring Screen

origin $00047918
lui t6, ((SCREEN_WIDTH/2)+32) //X Position Team Member 4 Face Starring Screen

origin $000479B8
lui t9, ((SCREEN_WIDTH/2)+72) //X Position Team Member 5 Face Background Starring Screen

origin $000479E8
lui t2, ((SCREEN_WIDTH/2)+92) //X Position Team Member 5 Face Starring Screen

origin $00048400
lui t7, (SCREEN_WIDTH-70) //X Position of NBA Logo on Legal Screen

origin $00048648
lui t9, ((SCREEN_WIDTH/2)-4) //X Position of Multiplayer Warning Message

origin $00049074
addiu v0, r0, ((((SCREEN_WIDTH/2)-6)*400)/320) //X Position of P1 Team Stats
addiu v0, r0, ((((SCREEN_WIDTH/2)++76)*400)/320) //X Position of P2 Team Stats

origin $0004A23C
addiu t6, r0, ((SCREEN_WIDTH/2)-116) //X Position of P1 Name on 1st Half Stats

origin $0004A2BC
addiu t2, r0, ((SCREEN_WIDTH/2)-43) //X Position of P2 Name on 1st Half Stats

origin $0004A33C
addiu t8, r0, ((SCREEN_WIDTH/2)+40) //X Position of P3 Name on 1st Half Stats

origin $0004A3BC
addiu t4, r0, ((SCREEN_WIDTH/2)+113) //X Position of P4 Name on 1st Half Stats

origin $0004A544
addiu t7, r0, ((SCREEN_WIDTH/2)-116) //X Position of P1 Player Name on First Half Stats

origin $0004A564
addiu t7, r0, ((SCREEN_WIDTH/2)-116) //X Position of Alternate P1 Player Name on First Half Stats

origin $0004A5C4
addiu t7, r0, ((SCREEN_WIDTH/2)-42) //X Position of P2 Player Name on First Half Stats

origin $0004A5E4
addiu t7, r0, ((SCREEN_WIDTH/2)-42) //X Position of Alternate P2 Player Name on First Half Stats

origin $0004A644
addiu t3, r0, ((SCREEN_WIDTH/2)+40) //X Position of P3 Player Name on First Half Stats

origin $0004A664
addiu t3, r0, ((SCREEN_WIDTH/2)+40) //X Position of Alternate P3 Player Name on First Half Stats

origin $0004A6C4
addiu t9, r0, ((SCREEN_WIDTH/2)+114) //X Position of P4 Player Name on First Half Stats

origin $0004A6E4
addiu t9, r0, ((SCREEN_WIDTH/2)+114) //X Position of Alternate P4 Player Name on First Half Stats

origin $0004A720
lui t6, (((SCREEN_WIDTH-320)/2)+5) //X Position of Left Bar on Best Overall Player Screen

origin $0004A760
lui t9, (((SCREEN_WIDTH-320)/2)+5) //X Position of NBA Logo on Best Overall Player Screen

origin $0004A934
lui t6, ((SCREEN_WIDTH/2)-81) //X Position of Center Bar on Team Select Screen

origin $0004AC98
addiu a1, r0, ((SCREEN_WIDTH/2)-142) //X Position of Left Ball in Main Menu After Reversing from Menu

origin $0004AE44
addiu a1, r0, ((SCREEN_WIDTH/2)-142) //X Position of Left Ball in Main Menu

origin $0004AE5C
addiu a1, r0, ((SCREEN_WIDTH/2)-37) //X Position of Center Ball in Main Menu

origin $0004AE74
addiu a1, r0, ((SCREEN_WIDTH/2)+67) //X Position of Right Ball in Main Menu

origin $0004B964
addiu t5, r0, ((SCREEN_WIDTH/2)-116) //X Position of P1 Name on Final Results Screen

origin $0004B998
addiu t7, r0, ((SCREEN_WIDTH/2)-43) //X Position of P2 Name on Final Results Screen

origin $0004B9C0
addiu t8, r0, ((SCREEN_WIDTH/2)+40) //X Position of P3 Name on Final Results Screen

origin $0004B9E8
addiu t6, r0, ((SCREEN_WIDTH/2)+113) //X Position of P4 Name on Final Results Screen

origin $0004BBAC
lui s0, ((SCREEN_WIDTH/2)-144) //X Position of Team Names on Final Results Screen

origin $0004BCC0
addiu t9, r0, ((SCREEN_WIDTH/2)-66) //X Position of Team 1 1st Quarter Score

origin $0004BCF0
addiu t1, r0, ((SCREEN_WIDTH/2)-66) //X Position of Team 2 1st Quarter Score

origin $0004BD20
addiu t3, r0, ((SCREEN_WIDTH/2)-38) //X Position of Team 1 2nd Quarter Score

origin $0004BD50
addiu t5, r0, ((SCREEN_WIDTH/2)-38) //X Position of Team 2 2nd Quarter Score

origin $0004BD80
addiu t7, r0, ((SCREEN_WIDTH/2)-11) //X Position of Team 1 3rd Quarter Score

origin $0004BDB0
addiu t9, r0, ((SCREEN_WIDTH/2)-11) //X Position of Team 2 3rd Quarter Score

origin $0004BDE0
addiu t1, r0, ((SCREEN_WIDTH/2)+16) //X Position of Team 1 4th Quarter Score

origin $0004BE10
addiu t3, r0, ((SCREEN_WIDTH/2)+16) //X Position of Team 2 4th Quarter Score

origin $0004BE54
addiu t7, r0, ((SCREEN_WIDTH/2)+44) //X Position of Team 1 1st Overtime Quarter Score

origin $0004BE84
addiu t9, r0, ((SCREEN_WIDTH/2)+44) //X Position of Team 2 1st Overtime Quarter Score

origin $0004BEC8
addiu t3, r0, ((SCREEN_WIDTH/2)+71) //X Position of Team 1 2nd Overtime Quarter Score

origin $0004BEF8
addiu t5, r0, ((SCREEN_WIDTH/2)+71) //X Position of Team 2 2nd Overtime Quarter Score

origin $0004BF3C
addiu t9, r0, ((SCREEN_WIDTH/2)+98) //X Position of Team 1 3rd Overtime Quarter Score

origin $0004BF6C
addiu t1, r0, ((SCREEN_WIDTH/2)+98) //X Position of Team 2 3rd Overtime Quarter Score

origin $0004C074
lui t7, ((SCREEN_WIDTH/2)-27) //X Position of V in VS Text

origin $0004C0B8
lui t3, ((SCREEN_WIDTH/2)-11) //X Position of S in VS Text

origin $0004C45C
addiu a1, r0, ((SCREEN_WIDTH/2)-2) //Initial X Position of Countdown Timer for Menus

origin $0004C4F8
addiu a1, r0, ((SCREEN_WIDTH/2)-2) //X Position of Countdown Timer for Menus

origin $0004CA4C
addiu a1, r0, ((SCREEN_WIDTH/2)-2) //X Position of First Second of Timer for Trivia Quiz

origin $0004CAA8
addiu a1, r0, ((SCREEN_WIDTH/2)-2) //X Position of Timer for Trivia Quiz

origin $0004D1AC
lui t6, (SCREEN_WIDTH/2) //X Position of Control Instructions on Team Select Screen

origin $0004E2EC
addiu t5, r0, ((SCREEN_WIDTH/2)-76) //X Position of Answer A on Trivia Answer Screen

origin $0004E304
addiu t6, r0, ((SCREEN_WIDTH/2)-56) //X Position of Answer A Text on Trivia Answer Screen

origin $0004E378
addiu t0, r0, ((SCREEN_WIDTH/2)-76) //X Position of Answer B on Trivia Answer Screen

origin $0004E390
addiu t1, r0, ((SCREEN_WIDTH/2)-56) //X Position of Answer B Text on Trivia Answer Screen

origin $0004E404
addiu t5, r0, ((SCREEN_WIDTH/2)-76) //X Position of Answer C on Trivia Answer Screen

origin $0004E41C
addiu t6, r0, ((SCREEN_WIDTH/2)-56) //X Position of Answer C Text on Trivia Answer Screen

origin $0004E490
addiu t1, r0, ((SCREEN_WIDTH/2)-76) //X Position of Answer D on Trivia Answer Screen

origin $0004E4A8
addiu t2, r0, ((SCREEN_WIDTH/2)-56) //X Position of Answer D Text on Trivia Answer Screen

origin $0004E794
lui t1, ((SCREEN_WIDTH/2)-60) //X Position of Answer Cursor for Trivia Quiz

origin $0004F234
lui t6, ((SCREEN_WIDTH/2)-71) //X Position of Left Bar for Uniform Selection

origin $0004F280
lui t2, ((SCREEN_WIDTH/2)-56) //X Position of Selector Bar for Uniform Selection

origin $0004F314
lui t6, ((SCREEN_WIDTH/2)-69) //X Position of Up Arrow for Uniform Selection

origin $0004F380
lui t6, ((SCREEN_WIDTH/2)-69) //X Position of Down Arrow for Uniform Selection

origin $0004F3EC
lui t6, ((SCREEN_WIDTH/2)+10) //X Position of Right Arrow for Head Selection

origin $0004F538
addiu t8, r0, ((SCREEN_WIDTH/2)-40) //X Position of Teams List for Uniforms

origin $0004F698
addiu t8, r0, ((SCREEN_WIDTH/2)-40) //X Position of Nick Name List

origin $0004F85C
lui t6, ((SCREEN_WIDTH/2)-38) //X Position of Left Arrow for Head Selection

origin $0004F8E0
lui t9, ((SCREEN_WIDTH/2)-64) //X Position of Yes Option in Create Player Menu

origin $0004F924
lui t3, ((SCREEN_WIDTH/2)-64) //X Position of No Option in Create Player Menu

origin $0004FAB8
lui t6, ((SCREEN_WIDTH/2)+76) //X Position of Clouds on Player Creation Screen

origin $0004FBC4
lui t7, ((SCREEN_WIDTH/2)+55) //X Position of Floor on Player Creation Screen

origin $000504B4
lui t8, ((SCREEN_WIDTH/2)+76) //X Position of Slanted Timer Box on Player Creation Screen

origin $000504F8
lui t2, ((SCREEN_WIDTH/2)+88) //X Position of Timer Minutes on Player Creation Screen

origin $00050530
lui t7, ((SCREEN_WIDTH/2)+99) //X Position of Timer Colon on Player Creation Screen

origin $00050564
lui t0, ((SCREEN_WIDTH/2)+124) //X Position of Timer Ones of Seconds on Player Creation Screen

origin $0005059C
lui t5, ((SCREEN_WIDTH/2)+108) //X Position of Timer Tens of Seconds on Player Creation Screen

origin $000506C4
lui s0, ((SCREEN_WIDTH/2)-71) //X Position of Head Selection Screen Borders

origin $00056878
addiu t6, r0, ((SCREEN_WIDTH*562)/320) //VI X Scale of Framebuffer for NTSC Mode

origin $000568C0
addiu t8, r0, ((SCREEN_WIDTH*562)/320) //VI X Scale of Framebuffer for MPAL Mode

origin $0005708C
ori t7, t7, (SCREEN_WIDTH-1) //Framebuffer Width for RDP

origin $000570C0
lui t6, ((SCREEN_WIDTH-1 << 14) >> 16) //Upper-Half of Scissor for Graphics

origin $000572C8
ori t6, t6, (SCREEN_WIDTH-1) //Framebuffer Width for Buffer Clear

origin $000572FC
lui t9, (($F6000000|(SCREEN_WIDTH-1 << 14)) >> 16) //Upper-Half of Buffer Clear Rectangle

origin $00057978
slti at, t7, SCREEN_WIDTH //Max X Position for 2D Sprites

origin $00057988
addiu a0, a0, (SCREEN_WIDTH-1) //Clamp to X Position for Background Elements

origin $000583B8
slti at, v0, (SCREEN_WIDTH) //Altered Behaviour X Position of GUI Sprites

origin $000577C0
addiu t8, v0, -(SCREEN_WIDTH-1) //Move X Position of Offscreen GUI Sprites

origin $00058E14
slti at, t8, (SCREEN_WIDTH) //Max Visible Screen Width for Front Sprite Men

origin $00058E24
addiu a0, a0, (SCREEN_WIDTH-1) //Clamp X Position of Visibility of Front Sprite Men

origin $0005C078
lui t6, (($80000000|DEFAULT_RAM_SIZE-(SCREEN_WIDTH*SCREEN_HEIGHT*BYTES_PER_PIXEL*NUM_FRAMEBUFFERS)) >> 16) //Framebuffer 1 Address Upper-Half

origin $0005C080
lui t8, (($80000000|DEFAULT_RAM_SIZE-(SCREEN_WIDTH*SCREEN_HEIGHT*BYTES_PER_PIXEL)) >> 16) //Framebuffer 2 Address Upper-Half

origin $0005C088
ori t6, t6, (($80000000|DEFAULT_RAM_SIZE-(SCREEN_WIDTH*SCREEN_HEIGHT*BYTES_PER_PIXEL*NUM_FRAMEBUFFERS)) & 0xFFFF) //Framebuffer 1 Address Lower-Half

origin $0005C090
ori t8, t8, (($80000000|DEFAULT_RAM_SIZE-(SCREEN_WIDTH*SCREEN_HEIGHT*BYTES_PER_PIXEL)) & 0xFFFF) //Framebuffer 2 Address Lower-Half

origin $0005C668
slti at, t0, (SCREEN_WIDTH-1) //Max Visible X Position of Front Sprite Men

origin $0005C7C8
slti at, v0, (SCREEN_WIDTH-1) //Max Visible X Position for Sprites

origin $0005CCA0
slti at, v0, (SCREEN_WIDTH-1) //Max Visible X Position of Floor and GUI

origin $000616E0
slti at, t7, (SCREEN_WIDTH) //Max X Position of Player Draw

origin $000624FC
addiu t3, t1, (SCREEN_WIDTH-1) //Texture Width for Floor

origin $00062520
addiu t5, t5, (SCREEN_WIDTH+7) //Max Texture Coordinate for Floor

origin $00062618
addiu t8, a0, (SCREEN_WIDTH-1) //Visible Width for Floor

origin $00063910
slti at, a2, (SCREEN_WIDTH) //Max X Position for Fill Rectangles

origin $00063924
addiu a2, r0, (SCREEN_WIDTH-1) //Clamp X Position for Fill Rectangles

origin $00069294
li t7, ($80000000|DEFAULT_RAM_SIZE-(SCREEN_WIDTH*SCREEN_HEIGHT*BYTES_PER_PIXEL*NUM_FRAMEBUFFERS)) //Heap End Address
li t8, $80169D90 //Heap Start Address

origin $0007B822
dh (SCREEN_WIDTH/2) //X Position of GOAL TENDING Text 

origin $00093406
dh ((SCREEN_WIDTH/2)-1) //X Position of Paused Text

origin $0009418E
dh ((SCREEN_WIDTH/2)-80) //X Position of Team 1 COM Text

origin $000941A2
dh ((SCREEN_WIDTH/2)+80) //X Position of Team 2 COM Text

origin $000941E4
dw ((SCREEN_WIDTH/2)-14) //X Position of Minutes of Timer

origin $000941F4
dw ((SCREEN_WIDTH/2)-4) //X Position of Seconds of Timer

origin $00094204
dw ((SCREEN_WIDTH/2)-26) //X Position of Team 1 Score

origin $00094214
dw ((SCREEN_WIDTH/2)+10) //X Position of Team 2 Score

origin $00094252
dh ((SCREEN_WIDTH/2)-89) //X Position of Flashing Player 2 Ball Icon
dh ((SCREEN_WIDTH/2)+28) //X Position of Flashing Player 3 Ball Icon
dh (SCREEN_WIDTH-68) //X Position of Flashing Player 4 Ball Icon

origin $00094282
dh ((SCREEN_WIDTH/2)-89) //X Position of Player 2 Ball Icon
dh ((SCREEN_WIDTH/2)+28) //X Position of Player 3 Ball Icon
dh (SCREEN_WIDTH-68) //X Position of Player 4 Ball Icon

origin $00094414
dw (SCREEN_WIDTH-105) //X Position of Minutes of Long Quarter Timer

origin $00094428
dw (SCREEN_WIDTH-92) //X Position of Tens of Seconds of Long Quarter Timer

origin $0009443C
dw (SCREEN_WIDTH-84) //X Position of Ones of Seconds of Long Quarter Timer

origin $00094468
dw (SCREEN_WIDTH-85) //X Position of Deciseconds of Short Quarter Timer

origin $0009447C
dw (SCREEN_WIDTH-106) //X Position of Tens of Seconds of Short Quarter Timer

origin $00094490
dw (SCREEN_WIDTH-98) //X Position of Ones of Seconds of Short Quarter Timer

origin $000945A0
dw (SCREEN_WIDTH-67) //X Position of Player 2 Shot Timer

origin $000945B4
dw (SCREEN_WIDTH-62) //X Position of Tens Digit of Player 2 Shot Timer

origin $000945C8
dw (SCREEN_WIDTH-45) //X Position of Ones Digit of Player 2 Shot Timer

origin $0009465E
dh (SCREEN_WIDTH/2) //X Position of Shot Clock Violation Text

origin $0009472A
dh (SCREEN_WIDTH/2) //X Position of Game Over Text Upper Half

origin $0009473E
dh (SCREEN_WIDTH/2) //X Position of Game Over Text Lower Half

origin $0009773A
dh ((SCREEN_WIDTH/2)-116) //X Position of Name Text for Name Entry Player 1

origin $0009774E
dh ((SCREEN_WIDTH/2)-116) //X Position of Name Text for Name Entry Player 2

origin $00097762
dh ((SCREEN_WIDTH/2)-116) //X Position of Name Text for Name Entry Player 3

origin $00097776
dh ((SCREEN_WIDTH/2)-116) //X Position of Name Text for Name Entry Player 4

origin $00097794
dh ((SCREEN_WIDTH/2)-117) //X Position of P1 Stat Bar on Stats Screen
dh ((SCREEN_WIDTH/2)-40) //X Position of P2 Stat Bar on Stats Screen
dh ((SCREEN_WIDTH/2)+38) //X Position of P3 Stat Bar on Stats Screen
dh ((SCREEN_WIDTH/2)+115) //X Position of P4 Stat Bar on Stats Screen

origin $000977C4
dw ((SCREEN_WIDTH-320)/2) //X Position of Left Edge of Header Bar Start Game

origin $000977D0
dw ((SCREEN_WIDTH-320)/2) //X Position of Left Edge of Header Bar Statistics

origin $000977DC
dw ((SCREEN_WIDTH-320)/2) //X Position of Left Edge of Header Bar 1st Half Stats

origin $0009788A
dh (SCREEN_WIDTH/2) //X Position of Winner Text

origin $00097CC6
dh ((SCREEN_WIDTH/2)-82) //X Position of Select Player Text

origin $00097D88
dw ((SCREEN_WIDTH/2)-10) //X Position of Quarter Number

origin $00097DA0
dw ((SCREEN_WIDTH/2)-31) //X Position of Center UI Frame

origin $00097E0C
dw ((SCREEN_WIDTH/2)-60) //X Position of Player 2 Player Name

origin $00097E24
dw ((SCREEN_WIDTH/2)-85) //X Position of Player 2 Turbo Meter

origin $00097E40
dw ((SCREEN_WIDTH/2)-60) //X Position of Player 2 Generic Text

origin $00097E5C
dw ((SCREEN_WIDTH/2)+57) //X Position of Player 3 Player Name

origin $00097E74
dw ((SCREEN_WIDTH/2)+32) //X Position of Player 3 Turbo Meter

origin $00097E90
dw ((SCREEN_WIDTH/2)+57) //X Position of Player 3 Generic Text

origin $00097EAC
dw (SCREEN_WIDTH-39) //X Position of Player 4 Player Name

origin $00097EC4
dw (SCREEN_WIDTH-64) //X Position of Player 4 Turbo Meter

origin $00097EE0
dw (SCREEN_WIDTH-39) //X Position of Player 4 Generic Text

origin $000981D6
dh (SCREEN_WIDTH/2) //X Position of Controller Pak Loading Text

origin $000981EA
dh (SCREEN_WIDTH/2) //X Position of Controller Pak Error Text

origin $000981FE
dh ((SCREEN_WIDTH/2)-12) //X Position of Controller Pak Yes Text

origin $00098212
dh ((SCREEN_WIDTH/2)+13) //X Position of Controller Pak No Text

origin $0009834E
dh (SCREEN_WIDTH/2) //X Position of Best Overall Player Text

origin $00098362
dh (SCREEN_WIDTH/2) //X Position of Best Overall Player Stat Information Text

origin $00098376
dh (SCREEN_WIDTH/2) //X Position of Best Overall Player Name

origin $0009838A
dh ((SCREEN_WIDTH/2)+12) //X Position of Static Statistics Line of Best Player

origin $000983B2
dh (SCREEN_WIDTH/2) //X Position of Grand Players List Description

origin $000983C6
dh (SCREEN_WIDTH/2) //X Position of World Records List Static Descriptors

origin $000983DA
dh (SCREEN_WIDTH/2) //X Position of World Records List Record Holder 1

origin $000983EE
dh (SCREEN_WIDTH/2) //X Position of World Records List Record Holder 2

origin $00098402
dh (SCREEN_WIDTH/2) //X Position of World Records List Record Holder 3

origin $00098416
dh (SCREEN_WIDTH/2) //X Position of World Records List Record Holder 4

origin $00098884
dh ((SCREEN_WIDTH/2)-147) //X Position of Player 1 Name Entry

origin $00098890
dh ((SCREEN_WIDTH/2)-153) //X Position of Player 1 Passcode Entry

origin $000988B4
dh ((SCREEN_WIDTH/2)-70) //X Position of Player 2 Name Entry

origin $000988C0
dh ((SCREEN_WIDTH/2)-75) //X Position of Player 2 Passcode Entry

origin $000988CC
dh ((SCREEN_WIDTH/2)+8) //X Position of Player 3 Name Entry

origin $000988D8
dh ((SCREEN_WIDTH/2)+3) //X Position of Player 3 Passcode Entry

origin $000988FC
dh ((SCREEN_WIDTH/2)+84) //X Position of Player 4 Name Entry

origin $00098908
dh ((SCREEN_WIDTH/2)+80) //X Position of Player 4 Passcode Entry

origin $00098976
dh ((SCREEN_WIDTH/2)-1) //X Position of Start Game Text

origin $00098998
dh ((SCREEN_WIDTH/2)-115) //X Position of Player 1 Player Name on Teams Screen
dh ((SCREEN_WIDTH/2)-42) //X Position of Player 2 Player Name on Teams Screen
dh ((SCREEN_WIDTH/2)+40) //X Position of Player 3 Player Name on Teams Screen
dh ((SCREEN_WIDTH/2)+113) //X Position of Player 4 Player Name on Teams Screen
dh ((SCREEN_WIDTH/2)-147) //X Position of Player 1 Player Stas Names on Teams Screen
dh ((SCREEN_WIDTH/2)-74) //X Position of Player 2 Player Stat Names on Teams Screen
dh ((SCREEN_WIDTH/2)+8) //X Position of Player 3 Player Stat Names on Teams Screen
dh ((SCREEN_WIDTH/2)+81) //X Position of Player 4 Player Stat Names on Teams Screen
dh ((SCREEN_WIDTH/2)-117) //X Position of Player 1 Player Stat Bars on Teams Screen
dh ((SCREEN_WIDTH/2)-44) //X Position of Player 2 Player Stat Bars on Teams Screen
dh ((SCREEN_WIDTH/2)+38) //X Position of Player 3 Player Stat Bars on Teams Screen
dh ((SCREEN_WIDTH/2)+111) //X Position of Player 4 Player Stat Bars on Teams Screen

origin $000989B2
dh ((SCREEN_WIDTH/2)-41) //X Position of Team 1 Logo on Select Teams Screen
dh ((SCREEN_WIDTH/2)+40) //X Position of Team 2 Logo on Select Teams Screen

origin $000989BA
dh ((SCREEN_WIDTH/2)-96) //X Position of Team 1 Logo on Tonight's Matchup Screen
dh ((SCREEN_WIDTH/2)+88) //X Position of Team 2 Logo on Tonight's Matchup Screen

origin $000989C2
dh ((SCREEN_WIDTH/2)-100) //X Position of Team 1 Team Logo on Substitutions Screen
dh ((SCREEN_WIDTH/2)+100) //X Position of Team 2 Team Logo on Substitutions Screen

origin $000989CA
dh ((SCREEN_WIDTH/2)-80) //X Position of Team 1 Team Logo on Final Results Screen
dh ((SCREEN_WIDTH/2)+77) //X Position of Team 2 Team Logo on Final Results Screen

origin $000989E0
dh ((SCREEN_WIDTH/2)-114) //X Position of Player 1 Free Play Text
dh ((SCREEN_WIDTH/2)-41) //X Position of Player 2 Free Play Text
dh ((SCREEN_WIDTH/2)+40) //X Position of Player 3 Free Play Text
dh ((SCREEN_WIDTH/2)+114) //X Position of Player 4 Free Play Text

origin $00098A3C
dh ((SCREEN_WIDTH/2)-133) //X Position of Player 1 Join In Text
dh ((SCREEN_WIDTH/2)-60) //X Position of Player 2 Join In Text
dh ((SCREEN_WIDTH/2)+22) //X Position of Player 3 Join In Text
dh ((SCREEN_WIDTH/2)+96) //X Position of Player 4 Join In Text

origin $00098AB6
dh ((SCREEN_WIDTH/2)-36) //X Position of Head Number Text

origin $00098ACA
dh ((SCREEN_WIDTH/2)+20) //X Position of Head Number Selection

origin $00098ADE
dh ((SCREEN_WIDTH/2)-32) //X Position of Total Points Text

origin $00098AF2
dh ((SCREEN_WIDTH/2)+22) //X Position of Total Points Number

origin $00098CF8
dh ((SCREEN_WIDTH/2)-116) //X Position of View Stats Option in Create Player

origin $00098D08
dh ((SCREEN_WIDTH/2)-116) //X Position of Head Option in Create Player

origin $00098D18
dh ((SCREEN_WIDTH/2)-116) //X Position of Uniform Option in Create Player

origin $00098D28
dh ((SCREEN_WIDTH/2)-116) //X Position of Attributes Option in Create Player

origin $00098D38
dh ((SCREEN_WIDTH/2)-116) //X Position of Privileges Option in Create Player

origin $00098D48
dh ((SCREEN_WIDTH/2)-116) //X Position of Nick Name Option in Create Player

origin $00098D58
dh ((SCREEN_WIDTH/2)-116) //X Position of New Name Option in Create Player

origin $00098D68
dh ((SCREEN_WIDTH/2)-116) //X Position of Save/Exit Option in Create Player

origin $00098D7C
dh ((SCREEN_WIDTH/2)-42) //X Position of Name Entry in Create Player Screen

origin $00098D88
dh ((SCREEN_WIDTH/2)-49) //X Position of Name Entry in Create Player Screen

origin $00098DDA
dh (SCREEN_WIDTH/2) //X Position of Coaching Tips Text

origin $00098DEE
dh (SCREEN_WIDTH/2) //X Position of Tip Name on Coaching Tips Screen

origin $00098E02
dh ((SCREEN_WIDTH/2)-125) //X Position of Tip Text on Coaching Tips Screen

origin $00098E16
dh (SCREEN_WIDTH/2) //X Position of Thank You for Creating a Character Text

origin $00098E2A
dh ((SCREEN_WIDTH/2)-148) //X Position of Character Creation Information

origin $00099074
dh (SCREEN_WIDTH/2) //X Position of Start Game Option

origin $0009907C
dh (SCREEN_WIDTH/2) //X Position of Options Option

origin $00099154
dw ((SCREEN_WIDTH-320)/2) //X Position of Hangtime Highlights Background

origin $00099166
dh (SCREEN_WIDTH/2) //X Position of Hangtime Highlights Text

origin $0009917A
dh (SCREEN_WIDTH/2) //X Position of First Line of Hangtime Highlight

origin $0009918E
dh (SCREEN_WIDTH/2) //X Position of Second Line of Hangtime Highlight

origin $00099200
dw ((SCREEN_WIDTH-320)/2) //X Position of 1st Half Time Stats Background

origin $00099212
dh (SCREEN_WIDTH/2) //X Position of 1st Half Time Stats Text

origin $00099246
dh ((SCREEN_WIDTH/2)-60) //X Position of Starring Team Names

origin $0009925A
dh (SCREEN_WIDTH/2) //X Position of Starring Text

origin $0009927E
dh (SCREEN_WIDTH/2) //X Position of Starring Player Names

origin $0009955E
dh ((SCREEN_WIDTH/2)-100) //X Position of Create Player Warning

origin $00099572
dh (SCREEN_WIDTH/2) //X Position of Substitutions Text

origin $00099586
dh (SCREEN_WIDTH/2) //X Position of Control Instructions on Substitutions Screen

origin $000995DC
dw ((SCREEN_WIDTH/2)-105) //X Position of Create Player Text

origin $000995EC
dw ((SCREEN_WIDTH/2)+2) //X Position of Enter Name Text

origin $000995FC
dw ((SCREEN_WIDTH/2)+105) //X Position of Select Teams Text

origin $00099696
dh ((SCREEN_WIDTH/2)-1) //X Position of Select Option Text

origin $000996C8
dh ((SCREEN_WIDTH/2)-152) //X Position of Player 1 Ball on Teams Screen
dh ((SCREEN_WIDTH/2)+4) //X Position of Player 2 Ball on Teams Screen

origin $00099738
dh ((SCREEN_WIDTH/2)-150) //X Position of Player 1/2 Background on Team Select

origin $0009973C
dh ((SCREEN_WIDTH/2)+5) //X Position of Player 3/4 Background on Team Select

origin $00099756
dh (SCREEN_WIDTH/2) //X Position of Final Results Text

origin $0009977E
dh (SCREEN_WIDTH/2) //X Position of New Grand Champion Screen Text

origin $00099792
dh (SCREEN_WIDTH/2) //X Position of Defeated All Teams Screen Text

origin $000997A6
dh (SCREEN_WIDTH/2) //X Position of Tonight's Natchup Text

origin $000997BA
dh ((SCREEN_WIDTH/2)-96) //X Position of Team 1 City Name Text

origin $000997CE
dh ((SCREEN_WIDTH/2)+88) //X Position of Team 2 City Name Text

origin $000997E2
dh ((SCREEN_WIDTH/2)-96) //X Position of Team 1 Team Name Text

origin $000997F6
dh ((SCREEN_WIDTH/2)+88) //X Position of Team 2 Team Name Text

origin $0009980A
dh (SCREEN_WIDTH/2) //X Position of Based on Stats Text

origin $00099980
dh ((SCREEN_WIDTH/2)-115) //X Position of P1 Trivia Quiz Stats
dh ((SCREEN_WIDTH/2)-41) //X Position of P2 Trivia Quiz Stats
dh ((SCREEN_WIDTH/2)+40) //X Position of P3 Trivia Quiz Stats
dh ((SCREEN_WIDTH/2)+113) //X Position of P4 Trivia Quiz Stats
dh ((SCREEN_WIDTH/2)-149) //X Position of P1 Player Icon on 1st Half Stats Screen

origin $0009998C
dh ((SCREEN_WIDTH/2)-18) //X Position of P2 Player Icon on 1st Half Stats Screen

origin $00099990
dh ((SCREEN_WIDTH/2)+6) //X Position of P3 Player Icon on 1st Half Stats Screen

origin $00099994
dh ((SCREEN_WIDTH/2)+137) //X Position of P4 Player Icon on 1st Half Stats Screen

origin $00099998
dh ((SCREEN_WIDTH/2)-149) //X Position of P1 Player Icon on Final Results Screen

origin $0009999C
dh ((SCREEN_WIDTH/2)-18) //X Position of P2 Player Icon on Final Results Screen

origin $000999A0
dh ((SCREEN_WIDTH/2)+6) //X Position of P3 Player Icon on Final Results Screen

origin $000999A4
dh ((SCREEN_WIDTH/2)+137) //X Position of P4 Player Icon on Final Results Screen

origin $000999EE
dh ((SCREEN_WIDTH/2)+131) //X Position of Total Team Scores on Final Results Screen

origin $00099A78
dh ((SCREEN_WIDTH/2)-116) //X Position of Opponent Needed Text Player 1
dh ((SCREEN_WIDTH/2)-40) //X Position of Opponent Needed Text Player 2
dh ((SCREEN_WIDTH/2)+39) //X Position of Opponent Needed Text Player 3
dh ((SCREEN_WIDTH/2)+115) //X Position of Opponent Needed Text Player 4

origin $00099AC8
dh ((SCREEN_WIDTH/2)-80) //X Position of Player 1 Opponent Needed Text on Teams Screen
dh ((SCREEN_WIDTH/2)+76) //X Position of Player 2 Opponent Needed Text on Teams Screen

origin $00099AD6
dh ((SCREEN_WIDTH/2)-1) //X Position of Trivia Quiz Text

origin $00099AFE
dh ((SCREEN_WIDTH/2)-125) //X Position of Trivia Quiz Description

origin $00099AEA
dh (SCREEN_WIDTH/2) //X Position of Test Your Knowledge Text

origin $00099B12
dh ((SCREEN_WIDTH/2)-1) //X Position of Hit Any Button for Rules Text

origin $00099B26
dh ((SCREEN_WIDTH/2)-1) //X Position of Trivia Quiz Rules

origin $00099B3A
dh ((SCREEN_WIDTH/2)-1) //X Position of Hit Any Button for Trivia Question Text

origin $00099B4E
dh ((SCREEN_WIDTH/2)-148) //X Position of Trivia Question

origin $00099B76
dh ((SCREEN_WIDTH/2)-1) //X Position of Correct Answer Reward on Trivia Question

origin $00099FA6
dh ((SCREEN_WIDTH/2)-12) //X Position of Notice Text

origin $00099FBA
dh ((SCREEN_WIDTH/2)-12) //X Position of Pin Changed Text

origin $00099FCE
dh ((SCREEN_WIDTH/2)-12) //X Position of New Record Text

origin $00099FE2
dh ((SCREEN_WIDTH/2)-12) //X Position of Record Not Found Text

origin $00099FF6
dh ((SCREEN_WIDTH/2)-12) //X Position of Save/Exit Question

origin $0009A00A
dh ((SCREEN_WIDTH/2)-12) //X Position of New Name Question

origin $0009A01E
dh ((SCREEN_WIDTH/2)-12) //X Position of Time Expired Text

origin $0009A032
dh ((SCREEN_WIDTH/2)-12) //X Position of Record Saved Text

origin $0009A046
dh ((SCREEN_WIDTH/2)-12) //X Position of Record Saved Extra Text

origin $0009A05A
dh ((SCREEN_WIDTH/2)-28) //X Position of Create Player Header Text

origin $0009A06E
dh ((SCREEN_WIDTH/2)-28) //X Position of Selected Option Text in Create Player Menu

origin $0009A06E
dh ((SCREEN_WIDTH/2)-12) //X Position of Enter Name Text

origin $0009A082
dh ((SCREEN_WIDTH/2)-12) //X Position of Option Descriptor in Create Player Menu

origin $0009A096
dh ((SCREEN_WIDTH/2)-12) //X Position of Alternate Option Descriptor in Create Player Menu

origin $0009A0AA
dh ((SCREEN_WIDTH/2)-12) //X Position of First Option Description

origin $0009A0BE
dh ((SCREEN_WIDTH/2)-12) //X Position of Second Option Description

origin $0009A0D2
dh ((SCREEN_WIDTH/2)-12) //X Position of Third Option Description

origin $0009A0E6
dh ((SCREEN_WIDTH/2)-12) //X Position of Fourth Option Description

origin $0009A0FA
dh ((SCREEN_WIDTH/2)-12) //X Position of Fifth Option Description

origin $0009A10E
dh ((SCREEN_WIDTH/2)-12) //X Position of Sixth Option Description

origin $0009A122
dh ((SCREEN_WIDTH/2)-12) //X Position of Seventh Option Description

origin $0009A136
dh ((SCREEN_WIDTH/2)-12) //X Position of Eighth Option Description

origin $0009A14A
dh ((SCREEN_WIDTH/2)+84) //X Position of Height of New Player

origin $0009A15E
dh ((SCREEN_WIDTH/2)+124) //X Position of Weight of New Player

origin $0009A172
dh ((SCREEN_WIDTH/2)-14) //X Position of Check 2 of The 6 Text

origin $0009ACD0
dw ((((SCREEN_WIDTH/2)-9)*400)/320) //X Position of Controller Configuration in Options Menu

origin $0009AD0C
dw ((((SCREEN_WIDTH/2)-8)*400)/320) //X Position of Settings in Options Menu

origin $0009AD54
dw ((((SCREEN_WIDTH/2)-90)*400)/320) //X Position of Options in Options Menu

origin $0009AD74
dw ((SCREEN_WIDTH/2)-7) //X Position of Game Switches in Options Menu

origin $0009AD9E
dh ((SCREEN_WIDTH/2)+14) //X Position of Option Text in Options Menu

origin $0009ADB2
dh ((SCREEN_WIDTH/2)+14) //X Position of Choose Option Text in Options Menu

origin $0009ADC6
dh ((SCREEN_WIDTH/2)+14) //X Position of Controller Options Control Text in Options Menu

origin $0009C098
dw SCREEN_WIDTH //VI Width

origin $0009C0B8
dw SCREEN_WIDTH*2 //Framebuffer Offset for Video

origin $0009E778
dh ((SCREEN_WIDTH/2)-75) //X Position of Player 1 in Select Player Box

origin $0009E784
dh ((SCREEN_WIDTH/2)-31) //X Position of Player 2 in Select Player Box

origin $0009E790
dh ((SCREEN_WIDTH/2)+13) //X Position of Player 3 in Select Player Box

origin $0009E79C
dh ((SCREEN_WIDTH/2)+57) //X Position of Player 4 in Select Player Box
dh ((SCREEN_WIDTH/2)+57) //X Position of Player 4 in Select Player Box

origin $0009E928
dw ((SCREEN_WIDTH-320)/2) //X Position of Best Overall Player Screen Background

origin $0009ECF8
dw ((SCREEN_WIDTH-320)/2) //X Position of Player Select Screen Background

origin $0009ED0C
dw ((SCREEN_WIDTH-320)/2) //X Position of Start Game Screen Background

origin $0009ED20
dw ((SCREEN_WIDTH-320)/2) //X Position of Name Entry Screen Background

origin $0009ED34
dw ((SCREEN_WIDTH-320)/2) //X Position of Substitutions Screen Background

origin $0009ED48
dh ((SCREEN_WIDTH/2)-117) //X Position of Name Header for Player 1
dh ((SCREEN_WIDTH/2)-112) //X Position of Current Entered Name for Player 1

origin $0009ED50
dh ((SCREEN_WIDTH/2)-40) //X Position of Name Header for Player 2
dh ((SCREEN_WIDTH/2)-40) //X Position of Current Entered Name for Player 2

origin $0009ED58
dh ((SCREEN_WIDTH/2)+38) //X Position of Name Header for Player 3
dh ((SCREEN_WIDTH/2)+43) //X Position of Current Entered Name for Player 3

origin $0009ED60
dh ((SCREEN_WIDTH/2)+115) //X Position of Name Header for Player 4
dh ((SCREEN_WIDTH/2)+116) //X Position of Current Entered Name for Player 4

origin $0009F1B2
dh ((SCREEN_WIDTH/2)-150) //X Position of Player 1 Portrait on Team Select
dh ((SCREEN_WIDTH/2)-7) //X Position of Player 2 Portrait on Team Select
dh ((SCREEN_WIDTH/2)+5) //X Position of Player 3 Portrait on Team Select
dh ((SCREEN_WIDTH/2)+148) //X Position of Player 4 Portrait on Team Select

origin $0009F1C6
dh ((SCREEN_WIDTH/2)-150) //X Position of Player 1 Portrait on Substitutions Screen
dh ((SCREEN_WIDTH/2)-7) //X Position of Player 2 Portrait on Substitutions Screen
dh ((SCREEN_WIDTH/2)+5) //X Position of Player 3 Portrait on Substitutions Screen
dh ((SCREEN_WIDTH/2)+148) //X Position of Player 4 Portrait on Substitutions Screen

origin $0009F1D0
dh ((SCREEN_WIDTH/2)-137) //X Position of Player 1 Portrait on Final Results Screen
dh ((SCREEN_WIDTH/2)-19) //X Position of Player 2 Portrait on Final Results Screen
dh ((SCREEN_WIDTH/2)+18) //X Position of Player 3 Portrait on Final Results Screen
dh ((SCREEN_WIDTH/2)+138) //X Position of Player 4 Portrait on Final Results Screen

origin $0009F1DA
dh ((SCREEN_WIDTH/2)-138) //X Position of Player 1 Portrait on 1st Half Stats Screen
dh ((SCREEN_WIDTH/2)-20) //X Position of Player 2 Portrait on 1st Half Stats Screen
dh ((SCREEN_WIDTH/2)+17) //X Position of Player 3 Portrait on 1st Half Stats Screen
dh ((SCREEN_WIDTH/2)+135) //X Position of Player 4 Portrait on 1st Half Stats Screen

origin $0009F1EC
dh ((SCREEN_WIDTH/2)-149) //X Position of Player 1 Full Game Purchased Text
dh ((SCREEN_WIDTH/2)-76) //X Position of Player 2 Full Game Purchased Text
dh ((SCREEN_WIDTH/2)+5) //X Position of Player 3 Full Game Purchased Text
dh ((SCREEN_WIDTH/2)+79) //X Position of Player 4 Full Game Purchased Text

origin $0009F2A8
dw ((SCREEN_WIDTH-320)/2) //X Position of Create Player Background

origin $0009F39C
dh ((SCREEN_WIDTH/2)-62) //X Position of Privilege 1 Checkmark in Privileges List

origin $0009F3A0
dh ((SCREEN_WIDTH/2)-62) //X Position of Privilege 2 Checkmark in Privileges List

origin $0009F3A4
dh ((SCREEN_WIDTH/2)-62) //X Position of Privilege 3 Checkmark in Privileges List

origin $0009F3A8
dh ((SCREEN_WIDTH/2)-62) //X Position of Privilege 4 Checkmark in Privileges List

origin $0009F3AC
dh ((SCREEN_WIDTH/2)-62) //X Position of Privilege 5 Checkmark in Privileges List

origin $0009F3B0
dh ((SCREEN_WIDTH/2)-62) //X Position of Privilege 6 Checkmark in Privileges List

origin $0009F3B4
dh ((SCREEN_WIDTH/2)-62) //X Position of Privilege 7 Checkmark in Privileges List

origin $0009F3B8
dh ((SCREEN_WIDTH/2)-14) //X Position of Privilege 1 in Privileges List

origin $0009F3C4
dh ((SCREEN_WIDTH/2)-14) //X Position of Privilege 2 in Privileges List

origin $0009F3D0
dh ((SCREEN_WIDTH/2)-14) //X Position of Privilege 3 in Privileges List

origin $0009F3DC
dh ((SCREEN_WIDTH/2)-14) //X Position of Privilege 4 in Privileges List

origin $0009F3E8
dh ((SCREEN_WIDTH/2)-14) //X Position of Privilege 5 in Privileges List

origin $0009F3F4
dh ((SCREEN_WIDTH/2)-14) //X Position of Privilege 6 in Privileges List

origin $0009F400
dh ((SCREEN_WIDTH/2)-14) //X Position of Privilege 7 in Privileges List

origin $0009F4B8
dw ((SCREEN_WIDTH-320)/2) //X Position of Coaching Tips Background

origin $0009F4CC
dw ((SCREEN_WIDTH-320)/2) //X Position of Stats Screen Background

origin $0009F4E0
dw ((SCREEN_WIDTH-320)/2) //X Position of Licensed Logos

origin $0009F4EC
dh ((SCREEN_WIDTH/2)-117) //X Position of P1 Stats on Stats Screen
dh ((SCREEN_WIDTH/2)-112) //X Position of P1 Name on Stats Screen
dh ((SCREEN_WIDTH/2)-40) //X Position of P2 Stats on Stats Screen
dh ((SCREEN_WIDTH/2)-40) //X Position of P2 Name on Stats Screen
dh ((SCREEN_WIDTH/2)+38) //X Position of P3 Stats on Stats Screen
dh ((SCREEN_WIDTH/2)+43) //X Position of P3 Name on Stats Screen
dh ((SCREEN_WIDTH/2)+115) //X Position of P4 Stats on Stats Screen
dh ((SCREEN_WIDTH/2)+116) //X Position of P4 Name on Stats Screen

origin $0009FE1C
dw ((SCREEN_WIDTH-320)/2) //X Position of Starring Screen Background

origin $0009FE50
dh ((SCREEN_WIDTH/2)-152) //X Position of Player 1 Number Box Tonight's Matchup Screen
dh ((SCREEN_WIDTH/2)-76) //X Position of Player 2 Number Box Tonight's Matchup Screen
dh ((SCREEN_WIDTH/2)+8) //X Position of Player 3 Number Box Tonight's Matchup Screen
dh ((SCREEN_WIDTH/2)+78) //X Position of Player 4 Number Box Tonight's Matchup Screen

origin $0009FE68
dh ((SCREEN_WIDTH/2)-149) //X Position of Player 1 Custom Character Box
dh ((SCREEN_WIDTH/2)-76) //X Position of Player 2 Custom Character Box
dh ((SCREEN_WIDTH/2)+5) //X Position of Player 3 Custom Character Box
dh ((SCREEN_WIDTH/2)+79) //X Position of Player 4 Custom Character Box

origin $0009FEC8
dh ((SCREEN_WIDTH/2)-92) //X Position of Left Stat Text on 1st Half Stats Screen

origin $0009FECC
dh ((SCREEN_WIDTH/2)+63) //X Position of Right Stat Text on 1st Half Stats Screen

origin $0009FED2
dh ((SCREEN_WIDTH/2)-151) //X Position of Left Team Score Bar

origin $0009FED8
dh ((SCREEN_WIDTH/2)+150) //X Position of Right Team Score Bar

origin $0009FEE6
dh ((SCREEN_WIDTH/2)-151) //X Position of P1 Select Bar on Teams Screen

origin $0009FEF6
dh ((SCREEN_WIDTH/2)+80) //X Position of P2 Select Bar on Teams Screen

origin $0009FF06
dh ((SCREEN_WIDTH/2)-149) //X Position of P1 Back Top Bar on 1st Half Stats Screen

origin $0009FF16
dh ((SCREEN_WIDTH/2)-146) //X Position of P1 Front Top Bar on 1st Half Stats Screen

origin $0009FF26
dh ((SCREEN_WIDTH/2)-149) //X Position of P1 Back Bottom Bar on 1st Half Stats Screen

origin $0009FF36
dh ((SCREEN_WIDTH/2)-146) //X Position of P1 Front Bottom Bar on 1st Half Stats Screen

origin $0009FF46
dh ((SCREEN_WIDTH/2)-76) //X Position of P2 Back Top Bar on 1st Half Stats Screen

origin $0009FF56
dh ((SCREEN_WIDTH/2)-73) //X Position of P2 Front Top Bar on 1st Half Stats Screen

origin $0009FF66
dh ((SCREEN_WIDTH/2)-76) //X Position of P2 Back Bottom Bar on 1st Half Stats Screen

origin $0009FF76
dh ((SCREEN_WIDTH/2)-73) //X Position of P2 Front Bottom Bar on 1st Half Stats Screen

origin $0009FF86
dh ((SCREEN_WIDTH/2)+6) //X Position of P3 Back Top Bar on 1st Half Stats Screen

origin $0009FF96
dh ((SCREEN_WIDTH/2)+9) //X Position of P3 Front Top Bar on 1st Half Stats Screen

origin $0009FFA6
dh ((SCREEN_WIDTH/2)+6) //X Position of P3 Back Bottom Bar on 1st Half Stats Screen

origin $0009FFB6
dh ((SCREEN_WIDTH/2)+9) //X Position of P3 Front Bottom Bar on 1st Half Stats Screen

origin $0009FFC6
dh ((SCREEN_WIDTH/2)+79) //X Position of P4 Back Top Bar on 1st Half Stats Screen

origin $0009FFD6
dh ((SCREEN_WIDTH/2)+82) //X Position of P4 Front Top Bar on 1st Half Stats Screen

origin $0009FFE6
dh ((SCREEN_WIDTH/2)+79) //X Position of P4 Back Bottom Bar on 1st Half Stats Screen

origin $0009FFF6
dh ((SCREEN_WIDTH/2)+82) //X Position of P4 Front Bottom Bar on 1st Half Stats Screen

origin $0009FFFC
dh ((SCREEN_WIDTH/2)-149) //X Position of P1 Left Half of On Fire Texture on 1st Half Stats Screen
dh ((SCREEN_WIDTH/2)-80) //X Position of P1 Right Half of On Fire Texture on 1st Half Stats Screen

origin $000A0002
dh ((SCREEN_WIDTH/2)-76) //X Position of P2 Left Half of On Fire Texture on 1st Half Stats Screen
dh ((SCREEN_WIDTH/2)-7) //X Position of P2 Right Half of On Fire Texture on 1st Half Stats Screen

origin $000A0008
dh ((SCREEN_WIDTH/2)+6) //X Position of P3 Left Half of On Fire Texture on 1st Half Stats Screen
dh ((SCREEN_WIDTH/2)+76) //X Position of P3 Right Half of On Fire Texture on 1st Half Stats Screen

origin $000A000E
dh ((SCREEN_WIDTH/2)+80) //X Position of P4 Left Half of On Fire Texture on 1st Half Stats Screen
dh ((SCREEN_WIDTH/2)+148) //X Position of P4 Right Half of On Fire Texture on 1st Half Stats Screen

origin $000A01C8
dh ((SCREEN_WIDTH/2)-153) //X Position of Light Over Create Player Option

origin $000A0130
dh ((SCREEN_WIDTH/2)-146) //X Position of Digit 1 of P1 Counter on Tonight's Matchup Screen
dh ((SCREEN_WIDTH/2)-123) //X Position of Digit 2 of P1 Counter on Tonight's Matchup Screen
dh ((SCREEN_WIDTH/2)-100) //X Position of Digit 3 of P1 Counter on Tonight's Matchup Screen
dh ((SCREEN_WIDTH/2)-70) //X Position of Digit 1 of P2 Counter on Tonight's Matchup Screen
dh ((SCREEN_WIDTH/2)-47) //X Position of Digit 2 of P2 Counter on Tonight's Matchup Screen
dh ((SCREEN_WIDTH/2)-24) //X Position of Digit 2 of P2 Counter on Tonight's Matchup Screen
dh ((SCREEN_WIDTH/2)+8) //X Position of Digit 1 of P3 Counter on Tonight's Matchup Screen
dh ((SCREEN_WIDTH/2)+32) //X Position of Digit 2 of P3 Counter on Tonight's Matchup Screen
dh ((SCREEN_WIDTH/2)+55) //X Position of Digit 3 of P3 Counter on Tonight's Matchup Screen
dh ((SCREEN_WIDTH/2)+84) //X Position of Digit 1 of P4 Counter on Tonight's Matchup Screen
dh ((SCREEN_WIDTH/2)+108) //X Position of Digit 2 of P4 Counter on Tonight's Matchup Screen
dh ((SCREEN_WIDTH/2)+131) //X Position of Digit 3 of P4 Counter on Tonight's Matchup Screen

origin $000A01D0
dh ((SCREEN_WIDTH/2)-50) //X Position of Light Over Enter Name Option

origin $000A01D8
dh ((SCREEN_WIDTH/2)+56) //X Position of Light Over Select Teams Option

origin $000A01E0
dw ((SCREEN_WIDTH/2)-140) //X Position of Selected Ball Create Player Option

origin $000A01E8
dw ((SCREEN_WIDTH/2)-33) //X Position of Selected Ball Enter Name Option

origin $000A01F0
dw ((SCREEN_WIDTH/2)+70) //X Position of Selected Ball Select Teams Option

origin $000A01F8
dw ((SCREEN_WIDTH/2)-146) //X Position of Distortion Circle Create Player Option

origin $000A0208
dw ((SCREEN_WIDTH/2)-40) //X Position of Distortion Circle Enter Name Option

origin $000A0218
dw ((SCREEN_WIDTH/2)+64) //X Position of Distortion Circle Select Teams Option

origin $000A025A
dh ((SCREEN_WIDTH/2)-79) //X Position of Player 1 Selected Player Number on Select Teams

origin $000A025E
dh ((SCREEN_WIDTH/2)+76) //X Position of Player 2 Selected Player Number on Select Teams

origin $000A0288
dw ((SCREEN_WIDTH/2)-71) //X Position of P1 Team Stats Text

origin $000A0294
dw ((SCREEN_WIDTH/2)-77) //X Position of P1 Team Stats Text Lines

origin $000A02A0
dw ((SCREEN_WIDTH/2)+12) //X Position of P2 Team Stats Text

origin $000A02AC
dw ((SCREEN_WIDTH/2)+6) //X Position of P2 Team Stats Text Lines

origin $000A03A8
dw ((SCREEN_WIDTH-320)/2) //X Position of Final Results Screen Background

origin $000A03BC
dw ((SCREEN_WIDTH-320)/2) //X Position of Tonight's Matchup Screen Background

origin $000A03D0
dw ((SCREEN_WIDTH-320)/2) //X Position of New Grand Champion Screen Background

origin $000A03E4
dw ((SCREEN_WIDTH-320)/2) //X Position of Defeated All Teams Screen Background

origin $000A0758
dw ((SCREEN_WIDTH-320)/2) //X Position of Trivia Quiz Background

origin $000A076C
dw ((SCREEN_WIDTH-320)/2) //X Position of Trivia Quiz Question Background

origin $000A0A3C
dh ((SCREEN_WIDTH/2)-140) //X Position of Yes Option for Create Player Warning

origin $000A0A40
dh ((SCREEN_WIDTH/2)-140) //X Position of No Option for Create Player Warning

origin $000A0A44
dh ((SCREEN_WIDTH/2)-140) //X Position of Yes Option Shadow for Create Player Warning

origin $000A0A48
dh ((SCREEN_WIDTH/2)-140) //X Position of No Option Shadow for Create Player Warning

origin $000A0AB4
dh ((SCREEN_WIDTH/2)-71) //X Position of Bar 1 for Create Player Menu

origin $000A0AB8
dh ((SCREEN_WIDTH/2)-71) //X Position of Bar 2 for Create Player Menu

origin $000A0ABC
dh ((SCREEN_WIDTH/2)-71) //X Position of Bar 3 for Create Player Menu

origin $000A0AC0
dh ((SCREEN_WIDTH/2)-71) //X Position of Bar 4 for Create Player Menu

origin $000A0AC4
dh ((SCREEN_WIDTH/2)-71) //X Position of Bar 5 for Create Player Menu

origin $000A0AC8
dh ((SCREEN_WIDTH/2)-71) //X Position of Bar 6 for Create Player Menu

origin $000A2BFC
dw ((SCREEN_WIDTH-320)/2) //X Position of Game Options Screen Background

origin $007ACF50
dh -(((SCREEN_WIDTH-106)*400)/320) //X Position of Current Quarter Time

origin $007ACF68
dh -(((SCREEN_WIDTH-106)*400)/320) //X Position of Current Quarter Time on Points Screen
