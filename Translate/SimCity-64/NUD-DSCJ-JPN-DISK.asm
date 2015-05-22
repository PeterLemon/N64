// N64 "SimCity-64" Japanese To English Translation by krom (Peter Lemon):

endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "SimCity-64.ndd", create
origin $000000; insert "NUD-DSCJ-JPN.ndd" // Include Japanese Sim City 64 N64 DD ROM

macro TextStyle1(OFFSET, TEXT) {
  origin {OFFSET}
  db {TEXT} // ASCII Text To Print
}

// Scenario
TextStyle1($0F1ACB0, "Raspberry mining\n")
                  db "town, is a small\n"
                  db "town suffering from\n"
                  db "depopulation. Please\n"
                  db "revitalize the town.", $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

TextStyle1($0F1AD1C, "Maypole's in a great\n")
                  db "depression & severe\n"
                  db "recession. Perform\n"
                  db "economic rebuild, &\n"
                  db "activate industry.", $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

TextStyle1($0F1ADA4, "Large fire, ancient\n")
                  db "capitol Sanrufuna.\n"
                  db "Put out the fire, &\n"
                  db "reconstruct the\n"
                  db "damaged city.", $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

TextStyle1($0F1AE4C, "Create a new town on\n")
                  db "reclaimed land.\n"
                  db "Landfill the Lipton\n"
                  db "Bay area, & grow it\n"
                  db "into a modern city.", $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

TextStyle1($0F1AF00, "Due to corruption,\n")
                  db "citizens distrustful\n"
                  db "Build up a welfare\n"
                  db "policy & regain the\n"
                  db "trust of citizens.", $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

// Tutorial
TextStyle1($1047F10, "City making in Sim\n")
                  db "City-64, is choosing\n"
                  db "how the residential,\n"
                  db "commerce & industry\n"
                  db "districts will grow.\n"
                  db "Citizens will work\n"
                  db "in the commerce &\n"
                  db "industry districts.\n"
                  db "Shops & commuting\n"
                  db "will require roads.", $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

TextStyle1($1047FF8, "The 3 districts are\n")
                  db "shown below, where\n"
                  db "each section is\n"
                  db "connected\n"
                  db "by roads\n"
                  db "& can be\n"
                  db "supplied\n"
                  db "with\n"
                  db "power.", $00, $00, $00, $00, $00, $00, $00, $00, $00

TextStyle1($1048068, "The city develops,\n")
                  db "alongside roads,\n"
                  db "using tools to\n"
                  db "install police\n"
                  db "stations & schools.\n\n"
                  db "It all starts from\n"
                  db "the main menu,\n"
                  db "which displays\n"
                  db "using Z or L.", $00, $00, $00

TextStyle1($1048100, "Select the commerce\n")
                  db "& industry districts\n"
                  db "to work with the\n"
                  db "residential area for\n"
                  db "citizens to live.\n"
                  db "Choose it from the\n"
                  db "main menu & press A.\n"
                  db "You can enlarge the\n"
                  db "range by moving the\n"
                  db "cursor & holding A.", $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

TextStyle1($1048210, "Then, the specified\n")
                  db "range will change to\n"
                  db "a colored tile, as\n"
                  db "shown\n"
                  db "below.\n\n"
                  db "The\n"
                  db "selection\n"
                  db "is now\n"
                  db "complete", $00

TextStyle1($1048278, "However, the\n")
                  db "specified section,\n"
                  db "is just a planned\n"
                  db "site. The section\n"
                  db "will be lined with\n"
                  db "houses & buildings,\n"
                  db "for a state in which\n"
                  db "citizens can live,\n"
                  db "who will need power\n"
                  db "& transportation.", $00, $00, $00, $00, $00, $00, $00, $00

TextStyle1($1048338, "To be traffic ready,\n")
                  db "please connect them\n"
                  db "up, surrounding the\n"
                  db "3\n"
                  db "sections,\n"
                  db "using\n"
                  db "the road\n"
                  db "traffic\n"
                  db "icon.", $00, $00, $00, $00, $00, $00, $00

TextStyle1($10483A4, "Set up a power plant\n")
                  db "using the power icon\n"
                  db "& place in contact\n"
                  db "with\n"
                  db "power\n"
                  db "lines\n"
                  db "from all\n"
                  db "of the\n"
                  db "sections.", $00

TextStyle1($104840C, "After a time, if you\n")
                  db "check back, houses\n"
                  db "& buildings will\n"
                  db "have\n"
                  db "gradually\n"
                  db "developed\n"
                  db "inside\n"
                  db "the\n"
                  db "sections.", $00

TextStyle1($1048474, "Once the sections\n")
                  db "have buildings, it's\n"
                  db "time to check the\n"
                  db "demand indicator in\n"
                  db "the top-right corner\n"
                  db "of the screen.\n"
                  db "Residential (R),\n"
                  db "Commercial  (C), &\n"
                  db "Industrial  (I), bar\n"
                  db "indicates demand.", $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

TextStyle1($1048560, "Specify the sections\n")
                  db "that are most needed\n"
                  db "in the residential\n"
                  db "commerce & industry\n"
                  db "districts.\n\n"
                  db "Using a 6x6 section\n"
                  db "will yield better\n"
                  db "efficiency.", $00, $00

TextStyle1($10485F0, "Basically repeating\n")
                  db "this process,\n"
                  db "the city will\n"
                  db "continue to develop.\n\n"
                  db "Development of\n"
                  db "these sections is\n"
                  db "the basis of\n"
                  db "city building.", $00, $00

// Steps
TextStyle1($119DE30, "Step1:Get larger city!"); db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                  db " Goal:Enlarge the city\n"
                  db " Time:", $A1, $A1, $A1, $A1, $A1, $A9, $A1, $A9, "Yr Upto ", $A1, $F5, $A1, $F5, $A1, $F5, $A1, $F5, "\n"
                  db " Need:Population 2000", $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

// Beginner Mode
TextStyle1($119E6F0, "Congratulations.\n")
                  db "I am serving as\n"
                  db "the deputy Mayor\n"
                  db "& my name is\n"
                  db $A2, $E9, $A2, $EA, " Wright.", $00

TextStyle1($119E740, "In this beginner\n")
                  db "mode, objectives\n"
                  db "chosen by me are\n"
                  db "to be achieved\n"
                  db "in a time limit\n"
                  db "working as Mayor", $00, $00, $00, $00, $00, $00, $00, $00, $00

TextStyle1($119E7AC, "If you do not\n")
                  db "achieve the goal\n"
                  db "within the time\n"
                  db "limit, you will\n"
                  db "be dismissed as\n"
                  db "the city Mayor.", $00, $00, $00, $00, $00, $00

TextStyle1($119E810, "All right.\n")
                  db $A1, $A9, $A1, $A9, $A1, $A9, $A1, $A9, $A1, $A9, $A1, $A9, $A1, $A9, $A1, $A9, " City \n"
                  db $A1, $F6, $A1, $F6, $A1, $F6, $A1, $F6, $A1, $F6, $A1, $F6, $A1, $F6, $A1, $F6, " Mayor. ", $00, $00, $00, $00, $00, $00, $00, $00

TextStyle1($119E854, "Ahem, so...\n")
                  db "I will explain a\n"
                  db "little about the\n"
                  db "situation of\n"
                  db $A1, $A9, $A1, $A9, $A1, $A9, $A1, $A9, $A1, $A9, $A1, $A9, $A1, $A9, $A1, $A9, ". ", $00, $00, $00, $00, $00

TextStyle1($119E8A8, ""); db $A1, $A9, $A1, $A9, $A1, $A9, $A1, $A9, $A1, $A9, $A1, $A9, $A1, $A9, $A1, $A9, " is a,\n"
                  db "small scale city\n"
                  db "it's a promising\n"
                  db "city that has\n"
                  db "continued to\n"
                  db "steadily develop", $00, $00, $00, $00, $00, $00

TextStyle1($119E914, "If this city\n")
                  db "becomes a large\n"
                  db "development, or\n"
                  db "it ends up as a\n"
                  db "smaller one,\n"
                  db "will be down\n"
                  db "to your ability.", $00

TextStyle1($119E97C, "Mayor "); db $A1, $F6, $A1, $F6, $A1, $F6, $A1, $F6, $A1, $F6, $A1, $F6, $A1, $F6, $A1, $F6, ", \n"
                  db "I am sure that\n"
                  db "you will have\n"
                  db "great success.", $00, $00, $00, $00, $00, $00, $00, $00, $00

TextStyle1($119E9CC, "Well,\n")
                  db "Mayor ", $A1, $F6, $A1, $F6, $A1, $F6, $A1, $F6, $A1, $F6, $A1, $F6, $A1, $F6, $A1, $F6, "\n"
                  db "if you are\n"
                  db "experienced, we\n"
                  db "can start right\n"
                  db "away, but...", $00

TextStyle1($119EA24, "Any experience?\n")
                  db "  Some as Mayor\n"
                  db "  None as Mayor", $00

TextStyle1($119EA54, "So, the 1st goal\n")
                  db "is to get to\n"
			db "2000 population\n"
                  db "within 10 years.", $00, $00

TextStyle1($119EA98, "If you get stuck\n")
                  db "please view the\n"
			db "help by pressing\n"
                  db "R trigger +\n"
                  db "C button ", $A2, $C1, ".", $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

TextStyle1($119EAF0, "Certainly.\n")
                  db "Right, ahem.", $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

TextStyle1($119EB14, "It will take a\n")
                  db "little\n"
                  db "explaining,\n"
                  db "please prepare\n"
                  db "notes.", $00

TextStyle1($119EB4C, "Did you get that?\n")
                  db "  Yes\n"
                  db "  No", $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

TextStyle1($119EB7C, "But, city making\n")
                  db "does not always\n"
                  db "go smoothly.\n"
                  db "Troubling events\n"
                  db "are inherent\n"
                  db "in development.", $00

TextStyle1($119EBD8, "If you have any\n")
                  db "trouble, please\n"
                  db "call me for\n"
                  db "advice using the\n"
                  db $A2, $E9, $A2, $EA, " Wright icon.\n"
                  db "It will also let\n"
                  db "me answer any\n"
                  db "questions about\n"
                  db "city making.", $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

TextStyle1($119EC6C, "As you proceed\n")
                  db "through the city\n"
                  db "making, demands\n"
                  db "& parameters of\n"
                  db "citizens are\n"
                  db "displayed in the\n"
                  db "alert window &\n"
                  db "bars.", $00, $00

TextStyle1($119ECE0, "Please display\n")
                  db "help by pressing\n"
                  db "the R trigger +\n"
                  db "C button ", $A2, $C1, "\n"
                  db "if you need a\n"
                  db "more detailed\n"
                  db "description of\n"
                  db "an item.", $00, $00, $00, $00, $00

TextStyle1($119ED54, "I'll give the\n")
                  db "appropriate\n"
                  db "description of\n"
                  db "the situation.", $00

TextStyle1($119ED8C, "\dUse the help\n")
                  db " from R trigger\n"
                  db " + C button ", $A2, $C1, "!\d\n"
                  db "Please do not\n"
                  db "forget this.", $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

TextStyle1($119EDE4, "Did you get that?\n")
                  db "  Yes\n"
                  db "  No", $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

TextStyle1($119EE14, "It is easy to\n")
                  db "achieve the goal\n"
                  db "sooner than the\n"
                  db "target time.\n"
                  db "Please view the\n"
                  db $A2, $E9, $A2, $EA, " Wright Icon\n"
                  db "if you're unsure", $00, $00, $00, $00, $00, $00

TextStyle1($119EE88, "Now,\n")
                  db "beginner mode\n"
                  db "step 1\n"
                  db "is starting!", $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00


TextStyle1($119EFE4, "City, "); db $A1, $A9, $A1, $A9, $A1, $A9, $A1, $A9, $A1, $A9, $A1, $A9, $A1, $A9, $A1, $A9, "\n"
                  db "Mayor ", $A1, $F6, $A1, $F6, $A1, $F6, $A1, $F6, $A1, $F6, $A1, $F6, $A1, $F6, $A1, $F6, "\n"
                  db "Is this correct?\n"
                  db "  Yes\n"
                  db "  No", $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

TextStyle1($119F03C, "Please fill in\n")
                  db "your name & the\n"
                  db "name of the city.", $00

TextStyle1($119F070, "Well, there is\n")
                  db "plenty of work\n"
                  db "I'd like you to\n"
                  db "do.\n\n"
                  db "First, please\n"
                  db "fill in your\n"
                  db "name & the name\n"
                  db "of the city.", $00, $00

// Scenario Mode
TextStyle1($11A7C90, "Congratulations.\n")
                  db "I am serving as\n"
                  db "the deputy Mayor\n"
                  db "& my name is\n"
                  db $A2, $E9, $A2, $EA, " Wright.", $00

TextStyle1($11A7CE0, "In this scenario\n")
                  db "mode, solve\n"
                  db "various city\n"
                  db "problems within\n"
                  db "a time limit,\n"
                  db "it has levels\n"
                  db "for intermediate\n"
                  db "& advanced.", $00, $00

TextStyle1($11A7D54, "If you don't\n")
                  db "achieve the\n"
                  db "target in time,\n"
                  db "you'll be\n"
                  db "dismissed as\n"
                  db "the city Mayor.", $00

TextStyle1($11A7DA4, "Also, when the\n")
                  db "power supply or\n"
                  db "debt is\n"
                  db "insufficient,\n"
                  db "you will not be\n"
                  db "able to achieve\n"
                  db "the target.", $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

TextStyle1($11A7E14, "So,\n")
                  db "Mayor ", $A1, $F6, $A1, $F6, $A1, $F6, $A1, $F6, $A1, $F6, $A1, $F6, $A1, $F6, $A1, $F6, ". \n"
                  db "Please choose\n"
                  db "the scenario.", $00, $00, $00, $00

TextStyle1($11A7E50, "Mayor "); db $A1, $F6, $A1, $F6, $A1, $F6, $A1, $F6, $A1, $F6, $A1, $F6, $A1, $F6, $A1, $F6, "\n"
                  db "Is this correct?\n"
                  db "  Yes\n"
                  db "  No", $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

TextStyle1($11A7E94, "Well, there is\n")
                  db "plenty of work\n"
                  db "I'd like you to\n"
                  db "do.\n\n"
                  db "First, please\n"
                  db "fill in your\n"
                  db "name.", $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

TextStyle1($11A7EF8, "Please fill in\n")
                  db "your name.", $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

// Text Hack
origin $11C74F4; db $A1, $A1, $A1, $A1, $A1, $A9, $A1, $A9, $A1, $A9, "Yr", $00, $00, $00, $00
origin $11C7504; db $A1, $A1, $A1, $A1, $A1, $A9, $A1, $A9, "Yr", $00, $00
origin $11C7524; db $A1, $F5, $A1, $F5, $A1, $F5, $A1, $F5, $00, $00, $00, $00

// Name Select
TextStyle1($1227C54, "Please type in your name"); db $00, $00, $00, $00

TextStyle1($1227C74, "Please name the city"); db $00, $00, $00, $00, $00, $00

TextStyle1($1228374, "  Please enter some\n")
                  db "      characters", $00