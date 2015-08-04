// N64 "SimCity-64" Japanese To English Translation by krom (Peter Lemon):

endian msb // N64 MIPS requires Big-Endian Encoding (Most Significant Bit)
output "SimCity-64.ndd", create
origin $000000; insert "NUD-DSCJ-JPN.ndd" // Include Japanese Sim City 64 N64 DD ROM

macro TextStyle1(OFFSET, TEXT) {
  origin {OFFSET}
  db {TEXT} // ASCII Text To Print
}

// Free Mode
TextStyle1($0E273C0, "Congratulations. I am\n")
                  db "serving as the deputy\n"
                  db "Mayor & my name is ", $A2, $E9, $A2, $EA, "\n"
                  db "Wright. I will give\n"
                  db "you helpful advice.", $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

TextStyle1($0E27448, "Mayor,\n")
                  db "right now, please\n"
                  db "choose a map of a\n"
                  db "city that you want\n"
                  db "to manage", $00

TextStyle1($0E27490, "Yes Sir,\n\n")
                  db "Please fill in your\n"
                  db "name inside this\n"
                  db "document.", $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

TextStyle1($0E274D8, "Now please decide\n")
                  db "the name of the city.\n"
                  db "Please choose a\n"
                  db "respectable name,\n"
                  db "for the citizens.", $00

TextStyle1($0E27534, "How much start money?"); db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

TextStyle1($0E27558, "Enable the disasters?\n")
                  db "Easier if not chosen.", $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

TextStyle1($0E275AC, "Decide year to start."); db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

TextStyle1($0E275D8, "Yes sir.\n")
                  db "Well, Mayor ", $01, "\n"
                  db "I wonder if you have\n"
                  db "any experience?", $00

TextStyle1($0E27614, "If you're experienced\n")
                  db "we can start now...", $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

TextStyle1($0E27650, "So detailed tutorial\n")
                  db "has been ommitted,\n"
                  db "we will start the\n"
                  db "game now.", $00

TextStyle1($0E27694, "So I will briefly\n")
                  db "describe, your job\n"
                  db "as Mayor.", $00, $00, $00, $00, $00, $00

TextStyle1($0E276C8, "First, we need to\n")
                  db "specify the combined\n"
                  db "residential,\n"
                  db "commercial &\n"
                  db "industrial districts.", $00, $00

TextStyle1($0E27720, "Specify each section,\n")
                  db "then surround &\n"
                  db "connect them with\n"
                  db "roads.", $00, $00

TextStyle1($0E27760, "Install a power plant\n")
                  db "to provide power, &\n"
                  db "place power lines\n"
                  db "connecting the\n"
                  db "sections", $00

TextStyle1($0E277B4, "Once these levels\n")
                  db "rise, you'll see\n"
                  db "population rise.", $00

TextStyle1($0E277E8, "When the population\n")
                  db "has increased, & we\n"
                  db "increase the sections\n"
                  db "& roads, the city\n"
                  db "will steadily develop", $00, $00, $00

TextStyle1($0E27850, "However, the town's\n")
                  db "development, will\n"
                  db "need luck facing\n"
                  db "trouble.", $00

TextStyle1($0E27890, "If there is trouble,\n")
                  db "use the advice of the\n"
                  db $A2, $E9, $A2, $EA, " Wright icon. I'll\n"
                  db "answer any questions,\n"
                  db "about city building.", $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

TextStyle1($0E27910, "If you don't know the\n")
                  db "meaning of any icons\n"
                  db "or various tools, you\n"
                  db "can view help using R\n"
                  db "trigger + C button ", $A2, $C1, ".", $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

TextStyle1($0E2798C, "\dWhen you do not\n")
                  db " know, use help with\n"
                  db " R trigger +\n"
                  db " C button ", $A2, $C1, "!\d\n"
                  db "Please remember this.", $00, $00, $00, $00, $00, $00, $00, $00, $00

TextStyle1($0E279EC, "Should I repeat that?"); db $00, $00, $00

TextStyle1($0E27A04, "So, Mayor "); db $01, "\n"
                  db "the game is starting.", $00, $00, $00


TextStyle1($0E27EE8, "$999999 (Easy)"); db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

TextStyle1($0E27F04, "$20000 (Easy)"); db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

TextStyle1($0E27F1C, "$10000 (Normal)"); db $00, $00, $00, $00, $00, $00, $00, $00, $00

TextStyle1($0E27F34, "$10000 Debt (Hard)"); db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

TextStyle1($0E27F50, "Disasters"); db $00, $00, $00, $00, $00, $00, $00

TextStyle1($0E27F60, "No Disasters"); db $00, $00, $00, $00

TextStyle1($0E27F70, "1900"); db $00, $00, $00, $00, $00, $00, $00, $00

TextStyle1($0E27F7C, "1950"); db $00, $00, $00, $00, $00, $00, $00, $00

TextStyle1($0E27F88, "2000"); db $00, $00, $00, $00, $00, $00, $00, $00

TextStyle1($0E27F94, "2050"); db $00, $00, $00, $00, $00, $00, $00, $00

TextStyle1($0E27FA0, "Some..."); db $00, $00, $00, $00, $00

TextStyle1($0E27FAC, "None..."); db $00

TextStyle1($0E27FB4, "Yes"); db $00, $00, $00, $00, $00

TextStyle1($0E27FBC, "No"); db $00, $00, $00, $00, $00, $00

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

// Beginner Table
TextStyle1($119DE30, "Step"); db $A3, $B1, ":Get Larger City!", $00, $00, $00, $00, $00, $00, $00, $00, $00
                  db " Goal:Enlarge The City\n"
                  db " Time:", $A1, $A9, $A1, $A9, "Yr Upto ", $A1, $F5, $A1, $F5, $A1, $F5, $A1, $F5, "\n"
                  db " Need:Population ", $A3, $B2, $A3, $B0, $A3, $B0, $A3, $B0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

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

// Scenario Text
TextStyle1($11A2520, "From an era\n")
                  db "before\n"
                  db "electricity,\n"
                  db "here lies\n"
                  db "Raspberry,\n"
                  db "a big city\n"
                  db "crowded with\n"
                  db "mines.", $00

TextStyle1($11A2574, "Demand for coal\n")
                  db "is down from\n"
                  db "the discovery\n"
                  db "of oil", $A1, $C4, " Each\n"
                  db "mine closed,\n"
                  db "a small district\n"
                  db "suffering\n"
                  db "depopulation.", $00, $00

TextStyle1($11A25E4, "You'll work as\n")
                  db "Mayor, Raspberry\n"
                  db "needs 10005\n"
                  db "inhabitants\n"
                  db "please develop\n"
                  db "it into a lively\n"
                  db "town, invest\n"
                  db "$5000 funds for\n"
                  db "the future of\n"
                  db "the city.", $00, $00, $00, $00

TextStyle1($11A2674, "If Raspberry\n")
                  db "ends as a small\n"
                  db "town of\n"
                  db "depopulation,\n"
                  db "will be down to\n"
                  db "you,\n"
                  db "Mayor ", $A1, $F6, $A1, $F6, $A1, $F6, $A1, $F6, $A1, $F6, $A1, $F6, $A1, $F6, $A1, $F6, ". \n"
                  db "Citizens expect\n"
                  db "you to succeed\n\n"
                  db "please do your\n"
                  db "best.", $00, $00, $00

TextStyle1($11A2838, "The 10 year time\n")
                  db "limit will go\n"
                  db "quickly. You can\n"
                  db "slow down the\n"
                  db "time, to aid in\n"
                  db "the building of\n"
                  db "the town.", $00

TextStyle1($11A28A0, "Now,\n")
                  db "scenario 1 is\n"
                  db "starting!", $00, $00, $00, $00, $00, $00, $00, $00

TextStyle1($11A2960, "May 1970...Share\n")
                  db "prices plunge,\n"
                  db "the world is hit\n"
                  db "by a great\n"
                  db "depression.", $00, $00, $00, $00, $00

TextStyle1($11A29AC, "Effects brought\n")
                  db "by the\n"
                  db "depression are\n"
                  db "enormous, in\n"
                  db "this industrial\n"
                  db "city severe\n"
                  db "recession has\n"
                  db "followed.", $00, $00

TextStyle1($11A2A14, "Your work this\n")
                  db "time Mayor, will\n"
                  db "be to rebuild\n"
                  db "the economy &\n"
                  db "increase\n"
                  db "the industrial\n"
                  db "district by\n"
                  db "20000 people.", $00, $00, $00

TextStyle1($11A2A84, "Industrial\n")
                  db "district\n"
                  db "population can\n"
                  db "be viewed using\n"
                  db "the city graph\n"
                  db "urban details\n"
                  db "icon. You can\n"
                  db "beat the great\n"
                  db "depression!\n"
                  db "Good luck.", $00, $00, $00, $00, $00

TextStyle1($11A2C10, "Industry will\n")
                  db "not increase\n"
                  db "unless you make\n"
                  db "a well-balanced\n"
                  db "city. Specify\n"
                  db "Residential &\n"
                  db "Commercial\n"
                  db "districts", $00

TextStyle1($11A2C80, "Now,\n")
                  db "scenario 2 is\n"
                  db "starting!", $00, $00, $00, $00, $00, $00, $00, $00

TextStyle1($11A2D40, "August 1968, the\n")
                  db "ancient capitol\n"
                  db "Sanrufuna was\n"
                  db "attacked by a\n"
                  db "large-scale\n"
                  db "urban fire.", $00, $00, $00, $00

TextStyle1($11A2D98, "Sanrufuna is a\n")
                  db "famous city with\n"
                  db "many historic\n"
                  db "buildings.\n"
                  db "Precious\n"
                  db "cultural\n"
                  db "heritage will be\n"
                  db "lost.", $00, $00, $00, $00, $00, $00, $00

TextStyle1($11A2E00, "Your work this\n")
                  db "time Mayor, is\n"
                  db "to quickly put\n"
                  db "out fires, & to\n"
                  db "revive the city\n"
                  db "upto 60005\n"
                  db "people.", $00

TextStyle1($11A2E60, "No time to lose.\n")
                  db "In order to\n"
                  db "protect the\n"
                  db "citizens &\n"
                  db "heritage please\n"
                  db "start fire\n"
                  db "fighting ASAP.", $00, $00, $00

TextStyle1($11A2FB0, "Using R button +\n")
                  db "C ", $A2, $C0, " it's easy to\n"
                  db "check the fire,\n"
                  db "it displays fire\n"
                  db "force range on\n"
                  db "the map.", $00

TextStyle1($11A300C, "Now,\n")
                  db "scenario 3 is\n"
                  db "starting!", $00, $00, $00, $00, $00, $00, $00, $00

TextStyle1($11A30C0, "Recently, due to\n")
                  db "overpopulation,\n"
                  db "housing\n"
                  db "shortages &\n"
                  db "overcrowding is\n"
                  db "a problem.", $00

TextStyle1($11A3110, "The governments\n")
                  db "response to this\n"
                  db "problem, is to\n"
                  db "landfill the\n"
                  db "Lipton Bay, &\n"
                  db "develop a modern\n"
                  db "city.", $00, $00, $00

TextStyle1($11A3174, "Your work this\n")
                  db "time, is to\n"
                  db "landfill Lipton\n"
                  db "Bay, Lavender is\n"
                  db "the new modern\n"
                  db "city with 30000\n"
                  db "people equipped\n"
                  db "with air &\n"
                  db "seaports.", $00

TextStyle1($11A31F4, "National\n")
                  db "prestige is\n"
                  db "hanging on this\n"
                  db "plan!\n"
                  db "Good luck.", $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

TextStyle1($11A334C, "Landfill can be\n")
                  db "done using land\n"
                  db "flattening /\n"
                  db "terrain icon.\n"
                  db "Flattening from\n"
                  db "the direction of\n"
                  db "shallow land is\n"
                  db "free, it's good\n"
                  db "to reclaim from\n"
                  db "coastline.", $00, $00

TextStyle1($11A33E4, "Now,\n")
                  db "scenario 4 is\n"
                  db "starting!", $00, $00, $00, $00, $00, $00, $00, $00

TextStyle1($11A34A0, "Mayor "); db $A1, $F6, $A1, $F6, $A1, $F6, $A1, $F6, $A1, $F6, $A1, $F6, $A1, $F6, $A1, $F6, $A1, $C4, "\n"
                  db "Here's\n"
                  db "Eucalyptus Hill\n"
                  db "due to\n"
                  db "corruption of\n"
                  db "the former\n"
                  db "Mayor, citizens\n"
                  db "have a strong\n"
                  db "distrust.", $00

TextStyle1($11A3518, "Your work this\n")
                  db "time Mayor, get\n"
                  db "the welfare\n"
                  db "level upto 180\n"
                  db "in order to\n"
                  db "regain the\n"
                  db "citizens trust,\n"
                  db "& ensure funding\n"
                  db "of $7000 for\n"
                  db "compensation.", $00, $00, $00, $00

TextStyle1($11A35A8, "Continue making\n")
                  db "a lively city,\n"
                  db "transmit your\n"
                  db "sincerity to the\n"
                  db "citizens please\n"
                  db "do your best to\n"
                  db "regain trust.", $00

TextStyle1($11A36EC, "Welfare policy\n")
                  db "will be\n"
                  db "successful, if\n"
                  db "you enhance\n"
                  db "medical care &\n"
                  db "education. It\n"
                  db "takes time to\n"
                  db "take root.", $00

TextStyle1($11A3754, "Now,\n")
                  db "scenario 5 is\n"
                  db "starting!", $00, $00, $00, $00, $00, $00, $00, $00

// Scenario Table
TextStyle1($11A6530, "Scene"); db $A3, $B1, ":Revitalize City!", $00, $00, $00, $00, $00, $00, $00, $00
                  db " Time:", $A1, $A9, $A1, $A9, "Yr Upto ", $A3, $B1, $A3, $B9, $A3, $B2, $A3, $B0, "/", $A3, $B6, "\n"
                  db " Need:Population ", $A3, $B1, $A3, $B0, $A3, $B0,	$A3, $B0, $A3, $B5, "\n"
                  db "  Secure ", $A1, $F0, $A3, $B5, $A3, $B0, $A3, $B0, $A3, $B0, " Funding\n\n"
                  db "Power:", $A1, $F3, $A1, $F3, "Debt:", $A1, $F0, $A1, $DE, $A1, $DE, $A1, $DE, $A1, $DE, $A1, $DE, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

TextStyle1($11A65F0, "Scene"); db $A3, $B2, ":Great Depression", $00, $00, $00, $00, $00, $00, $00, $00
                  db " Time:", $A1, $A9, $A1, $A9, "Yr Upto ", $A3, $B1, $A3, $B9, $A3, $B8, $A3, $B5, "/", $A3, $B8, "\n"
                  db " Need:Population ", $A3, $B6, $A3, $B0, $A3, $B0, $A3, $B0, $A3, $B0, "\n"
                  db "      Industrial ", $A3, $B2, $A3, $B0, $A3, $B0, $A3, $B0, $A3, $B0, "\n"
                  db "      (Currently ", $A1, $A9, $A1, $A9, $A1, $A9, $A1, $A9, $A1, $A9, ")\n"
                  db "Power:", $A1, $F3, $A1, $F3, "Debt:", $A1, $F0, $A1, $DE, $A1, $DE, $A1, $DE, $A1, $DE, $A1, $DE, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

TextStyle1($11A66B4, "Scene"); db $A3, $B3, ":Sanrufuna Fire", $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                  db " Time:", $A1, $A9, $A1, $A9, "Yr Upto ", $A3, $B1, $A3, $B9, $A3, $B7, $A3, $B8, "/", $A3, $B8, "\n"
                  db " Need:Population ", $A3, $B6, $A3, $B0, $A3, $B0, $A3, $B0, $A3, $B5, "\n\n\n"
                  db "Power:", $A1, $F3, $A1, $F3, "Debt:", $A1, $F0, $A1, $DE, $A1, $DE, $A1, $DE, $A1, $DE, $A1, $DE, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

TextStyle1($11A674C, "Scene"); db $A3, $B4, ":Bay City", $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                  db " Time:", $A1, $A9, $A1, $A9, "Yr Upto ", $A3, $B2, $A3, $B0, $A3, $B1, $A3, $B1, "/", $A3, $B6, "\n"
                  db " Need:Population ", $A3, $B3, $A3, $B0, $A3, $B0, $A3, $B0, $A3, $B0, "\n"
                  db "      Specify Seaport ", $A1, $F7, "\n"
                  db "      Specify Airport ", $A1, $F4, "\n"
                  db "Power:", $A1, $F3, $A1, $F3, "Debt:", $A1, $F0, $A1, $DE, $A1, $DE, $A1, $DE, $A1, $DE, $A1, $DE, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

TextStyle1($11A680C, "Scene"); db $A3, $B5, ":Trust Again", $00, $00, $00, $00, $00, $00, $00, $00, $00
                  db " Time:", $A1, $A9, $A1, $A9, "Yr Upto ", $A3, $B1, $A3, $B9, $A3, $B9, $A3, $B5, "/", $A3, $B2, "\n"
                  db " Need:Welfare", $A3, $B1, $A3, $B8, $A3, $B0, " On:", $A1, $A9, $A1, $A9, $A1, $A9, "\n"
                  db "  Secure ", $A1, $F0, $A3, $B7, $A3, $B0, $A3, $B0, $A3, $B0, " Funding\n\n"
                  db "Power:", $A1, $F3, $A1, $F3, "Debt:", $A1, $F0, $A1, $DE, $A1, $DE, $A1, $DE, $A1, $DE, $A1, $DE, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

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
origin $11C74F4; db "ime:", $A1, $A9, $A1, $A9, $A1, $A9, "Yr", $00, $00, $00, $00
origin $11C7504; db "ime:", $A1, $A9, $A1, $A9, "Yr", $00, $00
origin $11C7524; db $A1, $F5, $A1, $F5, $A1, $F5, $A1, $F5, $00, $00, $00, $00

origin $11E4EDC; db "ime:", $A1, $A9, $A1, $A9, $A1, $A9, "Yr", $00, $00, $00, $00
origin $11E4EEC; db "ime:", $A1, $A9, $A1, $A9, "Yr", $00, $00
origin $11E4F2C; db "ently ", $A1, $A9, $A1, $A9, $A1, $A9, $A1, $A9, $A1, $A9, ")", $00, $00, $00, $00, $00, $00, $00
origin $11E4F4C; db "O.K "
origin $11E4F54; db "None"

// Name Select Font Swap
origin $1227AD4; insert "FontSwapCHR.bin" // Include Swapped Font Character Data (3 * 124 Bytes)
origin $1227CC8; insert "FontSwapGFX.bin" // Include Swapped Font Character Data (3 * 240 Bytes)

// Name Select
TextStyle1($1227C54, "Please type in your name"); db $00, $00, $00, $00

TextStyle1($1227C74, "Please name the city"); db $00, $00, $00, $00, $00, $00

TextStyle1($1228374, "  Please enter some\n")
                  db "      characters", $00