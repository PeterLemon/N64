// N64 DD "Mario Artist - Polygon Studio" Japanese To English Translation by krom (Peter Lemon):

arch n64.cpu
endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "Mario Artist - Polygon Studio.ndd", create
origin $000000; insert "NUD-DMGJ-JPN.ndd" // Include Japanese Mario Artist - Polygon Studio N64 DD ROM

macro TextSmall(OFFSET, TEXT) {
  // Map Character Table
  map '!', $0001, 32 // Map Special Characters & Numbers
  map 'A', $0021, 31 // Map English "Upper Case" Characters & Special Characters
  map ' ', $0040     // Map Space Character
  map 'a', $0041, 30 // Map English "Lower Case" Characters & Special Characters

  origin {OFFSET}
  dh {TEXT} // Text To Print
}

macro TextShiftJIS(OFFSET, TEXT) {
  // Map Shift-JIS
  map ' ',  $8140
  map $2C,  $8143 // Comma ","
  map '.',  $8144
  map ':',  $8146
  map '?',  $8148
  map '!',  $8149
  map '~',  $8160
  map '\s', $818C // Single Quote "'"
  map '\d', $818D // Double Quote '"'
  map '&',  $8195
  map '0',  $824F, 10 // Map Numbers
  map 'A',  $8260, 26 // Map English "Upper Case" Characters
  map 'a',  $8281, 26 // Map English "Lower Case" Characters

  origin {OFFSET}
  dh {TEXT} // Shift-JIS Text To Print
}

TextSmall($011F680, "Selected Color") ; fill 4

// Model
TextSmall($01BA5BC, "Reset") ; fill 6
TextSmall($01BA5CC, "Switch") ; fill 4
TextSmall($01BA5DC, "Center") ; fill 8

TextSmall($01BA60C, "Out") ; fill 2
TextSmall($01BA614, "Undo") ; fill 4

TextSmall($01BA648, "Change") ; fill 8
TextSmall($01BA65C, "Customize") ; fill 2

// Menu
TextSmall($01C2040, "ExitModeler") ; fill 2
TextSmall($01C2058, "Out") ; fill 2
TextSmall($01C2060, "[StageWork]LoadSave") ; fill 2
TextSmall($01C2088, "[BlockWork]LoadSave") ; fill 2
TextSmall($01C20B0, "[3DWork]Load&Save") ; fill 2
TextSmall($01C20D4, "Today") ; fill 10

TextSmall($01C20FC, "Observe") ; fill 2
TextSmall($01C210C, "Photo") ; fill 6
TextSmall($01C211C, "TakeBreak") ; fill 2

TextSmall($01C2144, "Build") ; fill 2
TextSmall($01C2150, "3D") ; fill 4
TextSmall($01C2158, "Paint") ; fill 4

TextSmall($01C2190, "BGM") ; fill 10

// Start Screen
TextShiftJIS($01C9B48, "CurrentWork") ; fill 2
TextShiftJIS($01C9B60, "Gets") ; fill 4
TextShiftJIS($01C9B6C, "Wiped OK?") ; fill 2

// Options
TextSmall($02668AC, "Mono") ; fill 12
TextSmall($02668C0, "Stereo") ; fill 8
TextSmall($02668D4, "Headphone") ; fill 2
TextSmall($02668E8, "Slow") ; fill 12
TextSmall($02668FC, "Normal") ; fill 8
TextSmall($0266910, "Fast") ; fill 12
TextSmall($0266924, "Same as A") ; fill 2
TextSmall($0266938, "Slow Down") ; fill 2
TextSmall($026694C, "Display") ; fill 6
TextSmall($0266960, "NoDisplay") ; fill 2
TextSmall($0266974, "ApplySave") ; fill 2

// Video Tutorial
TextSmall($061036C, "Chair") ; fill 10
TextSmall($0610380, "Toilet") ; fill 8
TextSmall($0610394, "House") ; fill 10
TextSmall($06103A8, "WaterCan") ; fill 4
TextSmall($06103BC, "Dog") ; fill 14
TextSmall($06103D0, "Bird") ; fill 12
TextSmall($06103E4, "Stag") ; fill 12
TextSmall($06103F8, "Helmet") ; fill 8
TextSmall($061040C, "Dolphin") ; fill 6
TextSmall($0610420, "Boat") ; fill 12
TextSmall($0610434, "Submarine") ; fill 2
TextSmall($0610448, "PropPlane") ; fill 2

TextSmall($07FBC80, "Tutorials") ; fill 2
TextSmall($07FBC94, "Skeleton") ; fill 4
TextSmall($07FBCA8, "Tape") ; fill 12

// Easy Mode
TextSmall($07BA31C, "Del") ; fill 2
TextSmall($07BA324, "Glue") ; fill 4
TextSmall($07BA330, "GlueReset") ; fill 2

TextSmall($07BA378, "Move") ; fill 8
TextSmall($07BA388, "Rotate") ; fill 4
TextSmall($07BA398, "Scale") ; fill 10
TextSmall($07BA3AC, "AllAxis") ; fill 6
TextSmall($07BA3C0, "RedAxis") ; fill 6
TextSmall($07BA3D4, "GreenAxis") ; fill 6
TextSmall($07BA3EC, "BlueAxis") ; fill 4
TextSmall($07BA400, "RedAxis") ; fill 10
TextSmall($07BA418, "GreenAxis") ; fill 10
TextSmall($07BA434, "BlueAxis") ; fill 8
TextSmall($07BA44C, "RedAxis") ; fill 6
TextSmall($07BA460, "GreenAxis") ; fill 2
TextSmall($07BA474, "BlueAxis") ; fill 4

origin $08961F8 // Origin In ROM
base $8060EE38  // Base In RDRAM
// Basic Model Text
Basic01:
  dh "Pyramid" ; fill 2
Basic02:
  dh "Cube" ; fill 2
Basic03:
  dh "Cuboid" ; fill 2
Basic04:
  dh "8Face" ; fill 2
Basic05:
  dh "12Face" ; fill 2
Basic06:
  dh "20Face" ; fill 2
Basic07:
  dh "Spheroid" ; fill 2
Basic08:
  dh "Sphere" ; fill 2
Basic09:
  dh "Cone" ; fill 2
Basic10:
  dh "Tube" ; fill 2
Basic11:
  dh "Ring1" ; fill 2
Basic12:
  dh "Ring2" ; fill 2
Basic13:
  dh "Hole" ; fill 2
Basic14:
  dh "Tile" ; fill 2

// Character Model Text
Character01:
  dh "FaceLo" ; fill 2
Character02:
  dh "FaceHi" ; fill 2
Character03:
  dh "Body" ; fill 2
Character04:
  dh "Boy" ; fill 2
Character05:
  dh "Girl" ; fill 2
Character06:
  dh "Alien1" ; fill 2
Character07:
  dh "Alien2" ; fill 2
Character08:
  dh "FlowerMan" ; fill 2
Character09:
  dh "2LegRobo" ; fill 2
Character10:
  dh "3LegRobo" ; fill 2
Character11:
  dh "RoboLo" ; fill 2
Character12:
  dh "Robo1" ; fill 2
Character13:
  dh "Robo2" ; fill 2
Character14:
  dh "Robo3" ; fill 2
Character15:
  dh "Mario" ; fill 2
Character16:
  dh "Koopa" ; fill 2
Character17:
  dh "Yoshi" ; fill 2
Character18:
  dh "Penguin" ; fill 2
Character19:
  dh "Boo" ; fill 2
Character20:
  dh "Hydra" ; fill 2
Character21:
  dh "Dragon" ; fill 2

// Animal Model Text
Animal01:
  dh "Rat" ; fill 2
Animal02:
  dh "Giraffe" ; fill 2
Animal03:
  dh "Horse" ; fill 2
Animal04:
  dh "Pig" ; fill 2
Animal05:
  dh "Ox" ; fill 2
Animal06:
  dh "Elephant" ; fill 2
Animal07:
  dh "Dog" ; fill 2
Animal08:
  dh "Gull" ; fill 2
Animal09:
  dh "Dodo" ; fill 2
Animal10:
  dh "Turtle" ; fill 2
Animal11:
  dh "Skink" ; fill 2
Animal12:
  dh "Snake" ; fill 2
Animal13:
  dh "Stego" ; fill 2
Animal14:
  dh "Snail" ; fill 2
Animal15:
  dh "Ant" ; fill 2
Animal16:
  dh "Centi" ; fill 2
Animal17:
  dh "Scorp" ; fill 2
Animal18:
  dh "Bfly" ; fill 2
Animal19:
  dh "Dfly" ; fill 2
Animal20:
  dh "Stag" ; fill 2
Animal21:
  dh "Rhino" ; fill 2
Animal22:
  dh "Gold" ; fill 2
Animal23:
  dh "Squid" ; fill 2
Animal24:
  dh "Shark" ; fill 2
Animal25:
  dh "SHorse" ; fill 2
Animal26:
  dh "Sail" ; fill 2
Animal27:
  dh "Prawn" ; fill 2
Animal28:
  dh "Carp" ; fill 2

// Vehicle Model Text
Vehicle01:
  dh "OpenTop" ; fill 2
Vehicle02:
  dh "4WD" ; fill 2
Vehicle03:
  dh "Truck" ; fill 2
Vehicle04:
  dh "Pickup" ; fill 2
Vehicle05:
  dh "Sedan" ; fill 2
Vehicle06:
  dh "Classic" ; fill 2
Vehicle07:
  dh "F1" ; fill 2
Vehicle08:
  dh "Bus" ; fill 2
Vehicle09:
  dh "Bull" ; fill 2
Vehicle10:
  dh "Tank" ; fill 2
Vehicle11:
  dh "Train" ; fill 2
Vehicle12:
  dh "Quad" ; fill 2
Vehicle13:
  dh "Moterbike" ; fill 2
Vehicle14:
  dh "Bike" ; fill 2
Vehicle15:
  dh "Yacht" ; fill 2
Vehicle16:
  dh "Tanker" ; fill 2
Vehicle17:
  dh "Chopper" ; fill 2
Vehicle18:
  dh "PropPlane" ; fill 2
Vehicle19:
  dh "Glider" ; fill 2
Vehicle20:
  dh "Jet" ; fill 2
Vehicle21:
  dh "AirBus" ; fill 2

// Other Model Text
Other01:
  dh "House" ; fill 2
Other02:
  dh "Mansion" ; fill 2
Other03:
  dh "Flats" ; fill 2
Other04:
  dh "TV" ; fill 2
Other05:
  dh "BoomBox" ; fill 2
Other06:
  dh "Phone" ; fill 2
Other07:
  dh "64Controller" ; fill 2
Other08:
  dh "Star" ; fill 2
Other09:
  dh "ToyTrain" ; fill 2
Other10:
  dh "Teddy" ; fill 2
Other11:
  dh "Clock" ; fill 2
Other12:
  dh "Lamp" ; fill 2
Other13:
  dh "Sunflower" ; fill 2
Other14:
  dh "Tree" ; fill 2
Other15:
  dh "Sofa" ; fill 2
Other16:
  dh "Shades" ; fill 2
Other17:
  dh "Watch" ; fill 2
Other18:
  dh "Helmet" ; fill 2
Other19:
  dh "Gun" ; fill 2
Other20:
  dh "Bottle" ; fill 2
Other21:
  dh "Carton" ; fill 2

origin $08968B4 // Origin In ROM
// Basic Model Pointer
dw Basic01, Basic02, Basic03, Basic04, Basic05, Basic06, Basic07 // Page 1/2
dw Basic08, Basic09, Basic10, Basic11, Basic12, Basic13, Basic14 // Page 2/2

// Character Model Pointer
dw Character01, Character02, Character03, Character04, Character05, Character06, Character07 // Page 1/3
dw Character08, Character09, Character10, Character11, Character12, Character13, Character14 // Page 2/3
dw Character15, Character16, Character17, Character18, Character19, Character20, Character21 // Page 3/3

// Animal Model Pointer
dw Animal01, Animal02, Animal03, Animal04, Animal05, Animal06, Animal07 // Page 1/4
dw Animal08, Animal09, Animal10, Animal11, Animal12, Animal13, Animal14 // Page 2/4
dw Animal15, Animal16, Animal17, Animal18, Animal19, Animal20, Animal21 // Page 3/4
dw Animal22, Animal23, Animal24, Animal25, Animal26, Animal27, Animal28 // Page 4/4

// Vehicle Model Pointer
dw Vehicle01, Vehicle02, Vehicle03, Vehicle04, Vehicle05, Vehicle06, Vehicle07 // Page 1/3
dw Vehicle08, Vehicle09, Vehicle10, Vehicle11, Vehicle12, Vehicle13, Vehicle14 // Page 2/3
dw Vehicle15, Vehicle16, Vehicle17, Vehicle18, Vehicle19, Vehicle20, Vehicle21 // Page 3/3

// Other Model Pointer
dw Other01, Other02, Other03, Other04, Other05, Other06, Other07 // Page 1/3
dw Other08, Other09, Other10, Other11, Other12, Other13, Other14 // Page 2/3
dw Other15, Other16, Other17, Other18, Other19, Other20, Other21 // Page 3/3

// Interface Text
TextSmall($0897510, "Next Page") ; fill 2
TextSmall($0897524, "Move") ; fill 8
TextSmall($0897534, "Rotate") ; fill 4
TextSmall($0897544, "Scale") ; fill 10
TextSmall($0897558, "Dot") ; fill 2
TextSmall($0897560, "Lin") ; fill 2
TextSmall($0897568, "Fac") ; fill 2
TextSmall($0897570, "Obj") ; fill 2
TextSmall($0897578, "Cut") ; fill 2
TextSmall($0897580, "Connect") ; fill 2
TextSmall($0897590, "Pull") ; fill 4
TextSmall($089759C, "Rounded") ; fill 2
TextSmall($08975AC, "Rem") ; fill 2
TextSmall($08975B4, "Del") ; fill 2

TextSmall($08975D0, "Copy") ; fill 8
TextSmall($08975E0, "PullLine") ; fill 8
TextSmall($08975F8, "PullPoint") ; fill 2
TextSmall($089760C, "SmallFace") ; fill 6
TextSmall($0897624, "ShadeType") ; fill 2
TextSmall($0897638, "Smooth") ; fill 4
TextSmall($0897648, "Cpy") ; fill 2
TextSmall($0897650, "Mirror") ; fill 4

TextSmall($08976C4, "AllAxis") ; fill 6
TextSmall($08976D8, "Normal") ; fill 4

TextSmall($0897704, "RedAxis") ; fill 6
TextSmall($0897718, "GreenAxis") ; fill 6
TextSmall($0897730, "BlueAxis") ; fill 4
TextSmall($0897744, "RedAxis") ; fill 10
TextSmall($089775C, "GreenAxis") ; fill 10
TextSmall($0897778, "BlueAxis") ; fill 8
TextSmall($0897790, "RedAxis") ; fill 6
TextSmall($08977A4, "GreenAxis") ; fill 2
TextSmall($08977B8, "BlueAxis") ; fill 4
TextSmall($08977CC, "2Part") ; fill 2
TextSmall($08977D8, "3Part") ; fill 2
TextSmall($08977E4, "4Part") ; fill 2
TextSmall($08977F0, "5Part") ; fill 2

TextSmall($0897838, "RedPlane") ; fill 10
TextSmall($0897854, "GreenPlane") ; fill 8
TextSmall($0897870, "BluePlane") ; fill 10

TextSmall($089788C, "Basic") ; fill 6
TextSmall($089789C, "Character") ; fill 2
TextSmall($08978B0, "Animal") ; fill 4
TextSmall($08978C0, "Vehicle") ; fill 2
TextSmall($08978D0, "Other") ; fill 6

// Paint
TextSmall($0953E18, "FeltTip") ; fill 2
TextSmall($0953E28, "Spray") ; fill 2
TextSmall($0953E34, "Brush") ; fill 6
TextSmall($0953E44, "FillFace") ; fill 4
TextSmall($0953E58, "EatCol") ; fill 4
TextSmall($0953E68, "Sma") ; fill 2
TextSmall($0953E70, "Med") ; fill 2
TextSmall($0953E78, "Big") ; fill 2
TextSmall($0953E80, "Stamp") ; fill 2

TextSmall($0953EA4, "Fill") ; fill 4
TextSmall($0953EB0, "Overlay") ; fill 2

TextSmall($0953ECC, "Erase") ; fill 2
TextSmall($0953ED8, "Load[2DWork]Stamp") ; fill 2

TextSmall($0953F10, "WipeAll") ; fill 2
TextSmall($0953F20, "Flip") ; fill 4
TextSmall($0953F2C, "Angle") ; fill 2

TextSmall($0953F48, "Pick") ; fill 4
TextSmall($0953F54, "Mask") ; fill 4

origin $0953F60 // Origin In ROM
base $8049C028  // Base In RDRAM
// Stamp Text
Stamp001:
  dh "EyeRea1" ; fill 2
Stamp002:
  dh "EyeRea2" ; fill 2
Stamp003:
  dh "EyeRea3" ; fill 2
Stamp004:
  dh "EyeRea4" ; fill 2
Stamp005:
  dh "EyeRea5" ; fill 2
Stamp006:
  dh "EyeRea6" ; fill 2
Stamp007:
  dh "EyeRea7" ; fill 2
Stamp008:
  dh "EyeCa1" ; fill 2
Stamp009:
  dh "EyeCa2" ; fill 2
Stamp010:
  dh "EyeCa3" ; fill 2
Stamp011:
  dh "EyeCa4" ; fill 2
Stamp012:
  dh "EyeCa5" ; fill 2
Stamp013:
  dh "EyeCa6" ; fill 2
Stamp014:
  dh "EyeCa7" ; fill 2
Stamp015:
  dh "EyeCa8" ; fill 2
Stamp016:
  dh "EyeCa9" ; fill 2
Stamp017:
  dh "EyeCa10" ; fill 2
Stamp018:
  dh "EyeCa11" ; fill 2
Stamp019:
  dh "EyeCa12" ; fill 2
Stamp020:
  dh "EyeCa13" ; fill 2
Stamp021:
  dh "EyeCa14" ; fill 2
Stamp022:
  dh "EyeCa15" ; fill 2
Stamp023:
  dh "EyeCa16" ; fill 2
Stamp024:
  dh "EyeCa17" ; fill 2
Stamp025:
  dh "EyeCa18" ; fill 2
Stamp026:
  dh "EyeCa19" ; fill 2
Stamp027:
  dh "EyeCa20" ; fill 2
Stamp028:
  dh "EyeCa21" ; fill 2
Stamp029:
  dh "EyeCa22" ; fill 2
Stamp030:
  dh "EyeCa23" ; fill 2
Stamp031:
  dh "EyeCa24" ; fill 2
Stamp032:
  dh "EyeCa25" ; fill 2
Stamp033:
  dh "EyeCa26" ; fill 2
Stamp034:
  dh "EyeCa27" ; fill 2
Stamp035:
  dh "EyeCa28" ; fill 2
Stamp036:
  dh "MouthR1" ; fill 2
Stamp037:
  dh "MouthR2" ; fill 2
Stamp038:
  dh "MouthR3" ; fill 2
Stamp039:
  dh "MouthR4" ; fill 2
Stamp040:
  dh "MouthR5" ; fill 2
Stamp041:
  dh "MouthR6" ; fill 2
Stamp042:
  dh "MouthR7" ; fill 2
Stamp043:
  dh "MouthR8" ; fill 2
Stamp044:
  dh "MouthR9" ; fill 2
Stamp045:
  dh "MouthR10" ; fill 2
Stamp046:
  dh "MouthR11" ; fill 2
Stamp047:
  dh "MouthR12" ; fill 2
Stamp048:
  dh "MouthR13" ; fill 2
Stamp049:
  dh "MouthR14" ; fill 2
Stamp050:
  dh "MouthC1" ; fill 2
Stamp051:
  dh "MouthC2" ; fill 2
Stamp052:
  dh "MouthC3" ; fill 2
Stamp053:
  dh "MouthC4" ; fill 2
Stamp054:
  dh "MouthC5" ; fill 2
Stamp055:
  dh "MouthC6" ; fill 2
Stamp056:
  dh "MouthC7" ; fill 2
Stamp057:
  dh "Stk1" ; fill 2
Stamp058:
  dh "Stk2" ; fill 2
Stamp059:
  dh "Stk3" ; fill 2
Stamp060:
  dh "Stk4" ; fill 2
Stamp061:
  dh "Stk5" ; fill 2
Stamp062:
  dh "Stk6" ; fill 2
Stamp063:
  dh "Stk7" ; fill 2
Stamp064:
  dh "Stk8" ; fill 2
Stamp065:
  dh "Stk9" ; fill 2
Stamp066:
  dh "Stk10" ; fill 2
Stamp067:
  dh "Stk11" ; fill 2
Stamp068:
  dh "Stk12" ; fill 2
Stamp069:
  dh "Stk13" ; fill 2
Stamp070:
  dh "Stk14" ; fill 2
Stamp071:
  dh "Stk15" ; fill 2
Stamp072:
  dh "Stk16" ; fill 2
Stamp073:
  dh "Stk17" ; fill 2
Stamp074:
  dh "Stk18" ; fill 2
Stamp075:
  dh "Stk19" ; fill 2
Stamp076:
  dh "Stk20" ; fill 2
Stamp077:
  dh "Stk21" ; fill 2
Stamp078:
  dh "Stk22" ; fill 2
Stamp079:
  dh "Stk23" ; fill 2
Stamp080:
  dh "Stk24" ; fill 2
Stamp081:
  dh "Stk25" ; fill 2
Stamp082:
  dh "Stk26" ; fill 2
Stamp083:
  dh "Stk27" ; fill 2
Stamp084:
  dh "Stk28" ; fill 2
Stamp085:
  dh "Stk29" ; fill 2
Stamp086:
  dh "Stk30" ; fill 2
Stamp087:
  dh "Stk31" ; fill 2
Stamp088:
  dh "Stk32" ; fill 2
Stamp089:
  dh "Stk33" ; fill 2
Stamp090:
  dh "Stk34" ; fill 2
Stamp091:
  dh "Stk35" ; fill 2
Stamp092:
  dh "Stk36" ; fill 2
Stamp093:
  dh "Stk37" ; fill 2
Stamp094:
  dh "Stk38" ; fill 2
Stamp095:
  dh "Stk39" ; fill 2
Stamp096:
  dh "Stk40" ; fill 2
Stamp097:
  dh "Stk41" ; fill 2
Stamp098:
  dh "Stk42" ; fill 2
Stamp099:
  dh "Stk43" ; fill 2
Stamp100:
  dh "Stk44" ; fill 2
Stamp101:
  dh "Stk45" ; fill 2
Stamp102:
  dh "Stk46" ; fill 2
Stamp103:
  dh "Stk47" ; fill 2
Stamp104:
  dh "Stk48" ; fill 2
Stamp105:
  dh "Stk49" ; fill 2
Stamp106:
  dh "Pat1" ; fill 2
Stamp107:
  dh "Pat2" ; fill 2
Stamp108:
  dh "Pat3" ; fill 2
Stamp109:
  dh "Pat4" ; fill 2
Stamp110:
  dh "Pat5" ; fill 2
Stamp111:
  dh "Pat6" ; fill 2
Stamp112:
  dh "Pat7" ; fill 2
Stamp113:
  dh "Pat8" ; fill 2
Stamp114:
  dh "Pat9" ; fill 2
Stamp115:
  dh "Pat10" ; fill 2
Stamp116:
  dh "Pat11" ; fill 2
Stamp117:
  dh "Pat12" ; fill 2
Stamp118:
  dh "Pat13" ; fill 2
Stamp119:
  dh "Pat14" ; fill 2
Stamp120:
  dh "Pat15" ; fill 2
Stamp121:
  dh "Pat16" ; fill 2
Stamp122:
  dh "Pat17" ; fill 2
Stamp123:
  dh "Pat18" ; fill 2
Stamp124:
  dh "Pat19" ; fill 2
Stamp125:
  dh "Pat20" ; fill 2
Stamp126:
  dh "Pat21" ; fill 2
Stamp127:
  dh "Pat22" ; fill 2
Stamp128:
  dh "Pat23" ; fill 2
Stamp129:
  dh "Pat24" ; fill 2
Stamp130:
  dh "Pat25" ; fill 2
Stamp131:
  dh "Pat26" ; fill 2
Stamp132:
  dh "Pat27" ; fill 2
Stamp133:
  dh "Pat28" ; fill 2
Stamp134:
  dh "Pat29" ; fill 2
Stamp135:
  dh "Pat30" ; fill 2
Stamp136:
  dh "Pat31" ; fill 2
Stamp137:
  dh "Pat32" ; fill 2
Stamp138:
  dh "Pat33" ; fill 2
Stamp139:
  dh "Pat34" ; fill 2
Stamp140:
  dh "Pat35" ; fill 2
Stamp141:
  dh "Pat36" ; fill 2
Stamp142:
  dh "Pat37" ; fill 2
Stamp143:
  dh "Pat38" ; fill 2
Stamp144:
  dh "Pat39" ; fill 2
Stamp145:
  dh "Pat40" ; fill 2
Stamp146:
  dh "Pat41" ; fill 2
Stamp147:
  dh "Pat42" ; fill 2

origin $095474C // Origin In ROM
// Stamp Pointer
dw Stamp001, Stamp002, Stamp003, Stamp004, Stamp005, Stamp006, Stamp007 // Page 1/21
dw Stamp008, Stamp009, Stamp010, Stamp011, Stamp012, Stamp013, Stamp014 // Page 2/21
dw Stamp015, Stamp016, Stamp017, Stamp018, Stamp019, Stamp020, Stamp021 // Page 3/21
dw Stamp022, Stamp023, Stamp024, Stamp025, Stamp026, Stamp027, Stamp028 // Page 4/21
dw Stamp029, Stamp030, Stamp031, Stamp032, Stamp033, Stamp034, Stamp035 // Page 5/21
dw Stamp036, Stamp037, Stamp038, Stamp039, Stamp040, Stamp041, Stamp042 // Page 6/21
dw Stamp043, Stamp044, Stamp045, Stamp046, Stamp047, Stamp048, Stamp049 // Page 7/21
dw Stamp050, Stamp051, Stamp052, Stamp053, Stamp054, Stamp055, Stamp056 // Page 8/21
dw Stamp057, Stamp058, Stamp059, Stamp060, Stamp061, Stamp062, Stamp063 // Page 9/21
dw Stamp064, Stamp065, Stamp066, Stamp067, Stamp068, Stamp069, Stamp070 // Page 10/21
dw Stamp071, Stamp072, Stamp073, Stamp074, Stamp075, Stamp076, Stamp077 // Page 11/21
dw Stamp078, Stamp079, Stamp080, Stamp081, Stamp082, Stamp083, Stamp084 // Page 12/21
dw Stamp085, Stamp086, Stamp087, Stamp088, Stamp089, Stamp090, Stamp091 // Page 13/21
dw Stamp092, Stamp093, Stamp094, Stamp095, Stamp096, Stamp097, Stamp098 // Page 14/21
dw Stamp099, Stamp100, Stamp101, Stamp102, Stamp103, Stamp104, Stamp105 // Page 15/21
dw Stamp106, Stamp107, Stamp108, Stamp109, Stamp110, Stamp111, Stamp112 // Page 16/21
dw Stamp113, Stamp114, Stamp115, Stamp116, Stamp117, Stamp118, Stamp119 // Page 17/21
dw Stamp120, Stamp121, Stamp122, Stamp123, Stamp124, Stamp125, Stamp126 // Page 18/21
dw Stamp127, Stamp128, Stamp129, Stamp130, Stamp131, Stamp132, Stamp133 // Page 19/21
dw Stamp134, Stamp135, Stamp136, Stamp137, Stamp138, Stamp139, Stamp140 // Page 20/21
dw Stamp141, Stamp142, Stamp143, Stamp144, Stamp145, Stamp146, Stamp147 // Page 21/21