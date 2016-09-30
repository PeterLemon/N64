// N64 DD "Mario Artist - Polygon Studio" Japanese To English Translation by krom (Peter Lemon):

arch n64.cpu
endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "Mario Artist - Polygon Studio.n64", create
origin $000000; insert "NUD-DMGJ-JPN.n64" // Include Japanese Mario Artist - Polygon Studio N64 DD ROM

macro TextSmall(OFFSET, TEXT) {
  origin {OFFSET}
  dh {TEXT} // Text To Print
}

// Character Table
map '!', $0001, 32 // Map Special Characters & Numbers
map 'A', $0021, 31 // Map English "Upper Case" Characters & Special Characters
map ' ', $0040     // Map Space Character
map 'a', $0041, 30 // Map English "Lower Case" Characters & Special Characters

// Model
TextSmall($0147DE4, "Reset") ; fill 6
TextSmall($0147DF4, "Switch") ; fill 4
TextSmall($0147E04, "Center") ; fill 8

TextSmall($0147E34, "Out") ; fill 2
TextSmall($0147E3C, "Undo") ; fill 4

TextSmall($07894BC, "Skeleton") ; fill 4

origin $0823A20 // Origin In ROM
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

origin $08240DC // Origin In ROM
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
TextSmall($0824D38, "Next Page") ; fill 2
TextSmall($0824D4C, "Move") ; fill 8
TextSmall($0824D5C, "Rotate") ; fill 4
TextSmall($0824D6C, "Scale") ; fill 10
TextSmall($0824D80, "Dot") ; fill 2
TextSmall($0824D88, "Lin") ; fill 2
TextSmall($0824D90, "Fac") ; fill 2
TextSmall($0824D98, "Obj") ; fill 2
TextSmall($0824DA0, "Cut") ; fill 2
TextSmall($0824DA8, "Connect") ; fill 2
TextSmall($0824DB8, "Pull") ; fill 4
TextSmall($0824DC4, "Rounded") ; fill 2
TextSmall($0824DD4, "Rem") ; fill 2
TextSmall($0824DDC, "Del") ; fill 2

TextSmall($0824DF8, "Copy") ; fill 8
TextSmall($0824E08, "PullLine") ; fill 8
TextSmall($0824E20, "PullPoint") ; fill 2
TextSmall($0824E34, "SmallFace") ; fill 6
TextSmall($0824E4C, "ShadeType") ; fill 2
TextSmall($0824E60, "Smooth") ; fill 4
TextSmall($0824E70, "Cpy") ; fill 2
TextSmall($0824E78, "Mirror") ; fill 4

TextSmall($0824EEC, "AllAxis") ; fill 6
TextSmall($0824F00, "Normal") ; fill 4

TextSmall($0824F2C, "RedAxis") ; fill 6
TextSmall($0824F40, "GreenAxis") ; fill 6
TextSmall($0824F58, "BlueAxis") ; fill 4
TextSmall($0824F6C, "RedAxis") ; fill 10
TextSmall($0824F84, "GreenAxis") ; fill 10
TextSmall($0824FA0, "BlueAxis") ; fill 8
TextSmall($0824FB8, "RedAxis") ; fill 6
TextSmall($0824FCC, "GreenAxis") ; fill 2
TextSmall($0824FE0, "BlueAxis") ; fill 4
TextSmall($0824FF4, "2Part") ; fill 2
TextSmall($0825000, "3Part") ; fill 2
TextSmall($082500C, "4Part") ; fill 2
TextSmall($0825018, "5Part") ; fill 2

TextSmall($0825060, "RedPlane") ; fill 10
TextSmall($082507C, "GreenPlane") ; fill 8
TextSmall($0825098, "BluePlane") ; fill 10

TextSmall($08250B4, "Basic") ; fill 6
TextSmall($08250C4, "Character") ; fill 2
TextSmall($08250D8, "Animal") ; fill 4
TextSmall($08250E8, "Vehicle") ; fill 2
TextSmall($08250F8, "Other") ; fill 6