-- ============================================================
--  BLOX Gank Server Monitor  |  Discord: @bloxgank
--  Event Monitor: Megalodon / Thunderzilla / Treasure / Shark Hunt dll
--  Deteksi via PlayerGui (hook semua TextLabel perubahan teks)
-- ============================================================

local HttpService        = game:GetService("HttpService")
local Players            = game:GetService("Players")
local TextChatService    = game:GetService("TextChatService")
local ReplicatedStorage  = game:GetService("ReplicatedStorage")
local CoreGui            = game:GetService("CoreGui")
local TweenService       = game:GetService("TweenService")

-- ============================================================
--  CONFIGURATION
-- ============================================================

local WEBHOOK_URL    = ""
local WEBHOOK_STATS  = ""
local WEBHOOK_FISH   = ""
local WEBHOOK_EVENT  = ""
local WEBHOOK_AVATAR = ""
local PROXY          = "https://square-haze-a007.remediashop.workers.dev"
local SCRIPT_ACTIVE  = false

local LEADERBOARD_INTERVAL    = 1800
local EVENT_COOLDOWN_SECONDS  = 120
local ROLE_NELAYAN_ID         = "1465243405591380023"

-- ============================================================
--  BRANDING
-- ============================================================

local BRAND_NAME        = "BLOX GANK"
local BRAND_ICON        = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/blox%20logo.png"
local BRAND_FOOTER_TEXT = "BLOX GANK • Server Monitor"

local TierColors = {
    Secret    = 1752220,
    Forgotten = 15263976,
    Ruby      = 16753920,
    Legendary = 3407871,
    Mutasi    = 16776960,
    Join      = 65280,
    Leave     = 16729344,
    NotBack   = 16711680,
}

local EMOJI_NOTIF     = "<a:notif:1517730648545034390>"
local EMOJI_SEPARATOR = "<a:arrow:1517730055323652106>"
local EMOJI_STARTER   = "<a:mancing:1517730589091041433>"
local EMOJI_FORGOTTEN = "<a:wiu:1517740584763265094>"
local EMOJI_MUTASI    = "<a:mutasi:1517730565225447616>"
local EMOJI_RUBY      = "<a:ruby:1517740619794092153>"
local EMOJI_LEGENDARY = "<a:apiijo:1517778951223902239>"
local EMOJI_TREASURE  = "<a:treasure:1517740647119847516>"
local EMOJI_MEGALODON = "<a:megablink:1517740677814030437>"
local EMOJI_THUNDER   = "<a:thunder:1517730620250390589>"
local EMOJI_CRYSTAL   = "<a:ruby:1517740619794092153>"
local EMOJI_EVENTTAG  = "📢"
local EMOJI_JOIN      = "<a:join:1517738095917924372>"
local EMOJI_LEAVE     = "<a:leave:1517738147914711190>"
local EMOJI_NOTBACK   = "<a:jam:1517740557445894194>"
local EMOJI_SERVER    = "<a:muter:1517778915836563596>"
local EMOJI_TROPHY    = "🏆"

local SEP  = EMOJI_SEPARATOR
local LINE = { name = "\u{200b}", value = "─────────────────────────────", inline = false }

-- ============================================================
--  MEMBER LIST
-- ============================================================

local MemberList = {
    { username = "zupzupzuppasup",   display = "KEPALASPPGDKIJAKARTA", id = "766292778501275678" },
    { username = "natadecxco",       display = "natarebus",            id = "638355599574171668" },
    { username = "pyciieegirls",     display = "pyciiiii",             id = "1182254978904109138" },
    { username = "kdryvka",          display = "YIYA",                 id = "1312729486067761162" },
    { username = "1nhanss",          display = "han",                  id = "1438046472179548190" },
    { username = "cjmin131",         display = "Karaadino",            id = "1406639996127154246" },
    { username = "x_ibo21",          display = "wowo",                 id = "954296542406246400" },
    { username = "evosudin",         display = "Bluuism",              id = "875656564931956766" },
    { username = "minxing_kim",      display = "Minxing",              id = "484295718765461515" },
    { username = "w4terhyacinth",    display = "waterrr",              id = "1309945598409048076" },
    { username = "rexlepwz",         display = "Reeamore",             id = "1205780304753725492" },
    { username = "dekadekadekk",     display = "dekadee",              id = "692735562817470494" },
    { username = "ceriseciscake",    display = "ciscake",              id = "786950836034994216" },
    { username = "mnikndy",          display = "prettyv",              id = "1478607686345035880" },
    { username = "BEJOD06",          display = "MasW",                 id = "1222390041951600640" },
    { username = "flucidious",       display = "fluc",                 id = "279691238494699530" },
    { username = "nahaaa01",         display = "naffz",               id = "1392909983678595244" },
    { username = "AcidReign07",      display = "kiixlau",              id = "1393120438594437161" },
    { username = "minyaktalon9990",  display = "Revv2",                id = "870201488218157107" },
    { username = "alleThetwin",      display = "LikeAvillain",         id = "870201488218157107" },
    { username = "fzallzall",        display = "Ziell",                id = "462346945441038337" },
    { username = "cecillionz1",      display = "ceceyy",               id = "1404117087303110877" },
    { username = "Klerra_Asu",       display = "MomKlerra",            id = "1171410071092215888" },
    { username = "theromantasy",     display = "star",                 id = "1461593359318650880" },
    { username = "choalyn_2",        display = "Alyn_ikaa",            id = "1467390946357416060" },
    { username = "zyr_xi",           display = "fii",                  id = "1181609363236999289" },
    { username = "Matchafav17",      display = "Macaaa",               id = "1478634976990859304" },
    { username = "0_Aurorain",       display = "Aurorain",             id = "574581489912643603" },
    { username = "cobadulumogaseru", display = "lah",                  id = "1451975194397638676" },
    { username = "Avochildoo",       display = "Avo",                  id = "1203622473955024896" },
    { username = "renjunundip",      display = "aleale",               id = "1428266616763977811" },
    { username = "iloafieus",        display = "mavis",                id = "1440589079086628998" },
    { username = "i95jminn",         display = "azkara",               id = "1506715872612585606" },
    { username = "trianayaa23",      display = "tiarkive",             id = "1425223281686085713" },
    { username = "longisimusdorsii", display = "strawberry",           id = "1506324307423526913" },
    { username = "Thismeann",        display = "Oceann",               id = "1463858926394015838" },
    { username = "hynad27",          display = "jisoo",                id = "1217043654909366323" },
    { username = "Bintanggg_1111",   display = "niss",                 id = "574581489912643603" },
    { username = "Baeforlife",       display = "Jaemin_choa",          id = "1467390946357416060" },
    { username = "OomKlerra2",       display = "OomKlerra2",           id = "1171410071092215888" },
    { username = "kathzeu",          display = "katzu",                id = "669806652375040022" },
    { username = "tantecungkring",   display = "Lavvy",                id = "757111417919766648" },
    { username = "prada2296",        display = "Prada",                id = "1461862687343378468" },
    { username = "bluesjjong",       display = "raxye",                id = "1205780304753725492" },
    { username = "Rambo_4200",       display = "RTBxRamboMYST",        id = "1472822553830621362" },
    { username = "PumpPump369",      display = "PumpPump",             id = "602890650345537555"  },
    { username = "Rainoruby",        display = "rain",                 id = "1395401789561507952"  },
    { username = "Reinoruby",        display = "ujan",                 id = "1395401789561507952"  },
    { username = "Binxxx22",         display = "BinxPVNK77",           id = "952992106421579796"  },
    { username = "Lacherve",         display = "RaraPVNK77",           id = "952992106421579796"  },
    { username = "biruneptunus",     display = "BiruKC",               id = "962866204203167774"  },
    { username = "univastic",        display = "ciel",                 id = "1356280326548230274" },
    { username = "Rambo_4209",       display = "SHOPEFOOD",            id = "1472822553830621362" },
    { username = "ZatzaMMay",        display = "TuyulGomenarai",       id = "892353508160970773"  },
    { username = "WaifunyaGomenarai",display = "aci",                  id = "892353508160970773"  },
    { username = "furinyawn",        display = "cipii",                id = "1312729486067761162" },
    { username = "Blckwv3",          display = "Blackwave",            id = "494856245023604736" },
    { username = "Leale716",         display = "Leaa",                 id = "1408658812424028182" },
    { username = "aca_ri17",         display = "ricarica",             id = "1471486371377053768" },
    { username = "keyrannn1",        display = "key",                  id = "1458430632370769972" },
    { username = "shellssyyy",       display = "kenjoyyyyy",           id = "494856245023604736" },
    { username = "Ninym_22N",        display = "Chipii",               id = "688544588830343274" },
    { username = "23Skuy2",          display = "BLAZE",                id = "786950836034994216" },
    { username = "waynecalloipe",    display = "ubuungi",              id = "1407648190580133948" },
    { username = "xiaosanzhe",       display = "san",                  id = "1407648190580133948" },
    { username = "zielsalvatore",    display = "salva",                id = "1205780304753725492" },
    { username = "thispalls",        display = "thispalls",            id = "1311353388314923019" },
    { username = "Moonshyse",        display = "MOON",                 id = "1125668364489080933" },
    { username = "we4thernnoon",     display = "weather",              id = "1125668364489080933" },
    { username = "akuganteng66611",  display = "akun",                 id = "1398328850793889872" },
    { username = "zakeykim",         display = "moonkim",              id = "1391744350714855425" },
    { username = "moonlqghts",       display = "moonkim",              id = "1391744350714855425" },
    { username = "dipyyy",           display = "karyawandripy",        id = "454238781168418826" },
}

-- ============================================================
--  DATABASE
-- ============================================================

local SecretFishList = {
    "Crystal Crab", "Orca", "Zombie Shark", "Zombie Megalodon", "Dead Zombie Shark",
    "Blob Shark", "Ghost Shark", "Skeleton Narwhal", "Ghost Worm Fish", "Worm Fish",
    "Megalodon", "1x1x1x1 Comet Shark", "Bloodmoon Whale", "Lochness Monster",
    "Monster Shark", "Eerie Shark", "Great Whale", "Frostborn Shark", "Thin Armor Shark",
    "Scare", "Queen Crab", "King Crab", "Cryoshade Glider", "Panther Eel",
    "Giant Squid", "Depthseeker Ray", "Robot Kraken", "Mosasaur Shark", "King Jelly",
    "Bone Whale", "Elshark Gran Maja", "Elpirate Gran Maja", "Ancient Whale",
    "Gladiator Shark", "Ancient Lochness Monster", "Talon Serpent", "Hacker Shark",
    "ElRetro Gran Maja", "Strawberry Choc Megalodon", "Krampus Shark",
    "Emerald Winter Whale", "Winter Frost Shark", "Icebreaker Whale", "Leviathan",
    "Pirate Megalodon", "Viridis Lurker", "Cursed Kraken", "Ancient Magma Whale",
    "Rainbow Comet Shark", "Love Nessie", "Broken Heart Nessie",
    "Mutant Runic Koi", "Ketupat Whale", "Cosmic Mutant Shark", "Strawberry Orca",
    "Bonemaw Tyrant", "Deepsea Monster Axolotl", "Blocky Lochness Monster", "Aurelion",
    "Runic Enchant Stone", "Frogalloon", "Coral Whale", "Flame Tyrant", "Withering Core",
    "Sea Eater", "Thunderzilla", "Iridesca", "Frostbite Leviathan", "Fluorivane",
    "Cerulean Dragon", "Machodon", "Scorching Veinmaw", "Crystalline Behemoth",
    "Frostmoon Whale", "Crystal Goliath", "Eggy Enchant Stone", "Dark Megalodon", "Elemental Tempestray", "Glacial Serpent",
}

local ForgottenList = {
    "Sea Eater", "Thunderzilla", "Iridesca", "Frostbite Leviathan", "Fluorivane", "Cerulean Dragon","Crystalline Behemoth",
}

local MutasiList = {
    "Noob", "Fairy Dust", "Holographic", "Gemstone", "Fire", "Color Burn", "Frozen",
    "Galaxy", "BloodMoon", "Binary", "Lightning", "Disco", "Festive", "Radioactive", "Moon Fragment",
}

local LegendaryCrystalList = {
    "Blue Sea Dragon", "Star Snail", "Cute Dumbo", "Blossom Jelly", "Bioluminescent Octopus",
}

local FishChanceData = {
    ["Crystal Crab"]              = "1 in 750K",
    ["Orca"]                      = "1 in 1.5M",
    ["Zombie Shark"]              = "1 in 250K",
    ["Zombie Megalodon"]          = "1 in 4M",
    ["Dead Zombie Shark"]         = "1 in 500K",
    ["Blob Shark"]                = "1 in 250K",
    ["Ghost Shark"]               = "1 in 500K",
    ["Skeleton Narwhal"]          = "1 in 600K",
    ["Ghost Worm Fish"]           = "1 in 1M",
    ["Worm Fish"]                 = "1 in 3M",
    ["Megalodon"]                 = "1 in 4M",
    ["1x1x1x1 Comet Shark"]       = "1 in 4M",
    ["Bloodmoon Whale"]           = "1 in 5M",
    ["Lochness Monster"]          = "1 in 3M",
    ["Monster Shark"]             = "1 in 2.5M",
    ["Eerie Shark"]               = "1 in 250K",
    ["Great Whale"]               = "1 in 900K",
    ["Frostborn Shark"]           = "1 in 500K",
    ["Thin Armor Shark"]          = "1 in 300K",
    ["Scare"]                     = "1 in 3M",
    ["Queen Crab"]                = "1 in 800K",
    ["King Crab"]                 = "1 in 1.2M",
    ["Cryoshade Glider"]          = "1 in 450K",
    ["Panther Eel"]               = "1 in 750K",
    ["Giant Squid"]               = "1 in 800K",
    ["Depthseeker Ray"]           = "1 in 1.2M",
    ["Robot Kraken"]              = "1 in 3.5M",
    ["Mosasaur Shark"]            = "1 in 800K",
    ["King Jelly"]                = "1 in 1.5M",
    ["Bone Whale"]                = "1 in 2M",
    ["Elshark Gran Maja"]         = "1 in 4M",
    ["Elpirate Gran Maja"]        = "1 in 4M",
    ["ElRetro Gran Maja"]         = "1 in 4M",
    ["Ancient Whale"]             = "1 in 2.75M",
    ["Gladiator Shark"]           = "1 in 1M",
    ["Ancient Lochness Monster"]  = "1 in 3M",
    ["Talon Serpent"]             = "1 in 3M",
    ["Hacker Shark"]              = "1 in 2M",
    ["Strawberry Choc Megalodon"] = "1 in 4M",
    ["Krampus Shark"]             = "1 in 1M",
    ["Emerald Winter Whale"]      = "1 in 1.5M",
    ["Winter Frost Shark"]        = "1 in 3M",
    ["Icebreaker Whale"]          = "1 in 4M",
    ["Cursed Kraken"]             = "1 in 3M",
    ["Pirate Megalodon"]          = "1 in 4M",
    ["Leviathan"]                 = "1 in 5M",
    ["Viridis Lurker"]            = "1 in 1.4M",
    ["Ancient Magma Whale"]       = "1 in 5M",
    ["Mutant Runic Koi"]          = "1 in ??",
    ["Cosmic Mutant Shark"]       = "1 in 2M",
    ["Strawberry Orca"]           = "1 in 3M",
    ["Bonemaw Tyrant"]            = "1 in 2.5M",
    ["Rainbow Comet Shark"]       = "1 in ??",
    ["Love Nessie"]               = "1 in ??",
    ["Broken Heart Nessie"]       = "1 in ??",
    ["Sea Eater"]                 = "1 in 25M",
    ["Thunderzilla"]              = "1 in 30M",
    ["Iridesca"]                  = "1 in 25M",
    ["Eggy Enchant Stone"]        = "1 in 100K",
    ["Deepsea Monster Axolotl"]   = "1 in 2M",
    ["Blocky Lochness Monster"]   = "1 in 3M",
    ["Frostbite Leviathan"]       = "1 in 12M",
    ["Aurelion"]                  = "1 in 3M",
    ["Runic Enchant Stone"]       = "1 in 1.5M",
    ["Frogalloon"]                = "1 in 1.5M",
    ["Fluorivane"]                = "1 in 15M",
    ["Coral Whale"]               = "1 in 2M",
    ["Flame Tyrant"]              = "1 in 5M",
    ["Cerulean Dragon"]           = "1 in 25M",
    ["Withering Core"]            = "1 in 3M",
    ["Machodon"]                  = "1 in 10M",
    ["Crystalline Behemoth"]      = "1 in 20M",
    ["Frostmoon Whale"]           = "1 in 5M",
    ["Crystal Goliath"]           = "1 in 3M",
    ["Ketupat Whale"]             = "1 in ??",
    ["Scorching Veinmaw"]         = "1 in 5M",
    ["Glacial Serpent"]           = "1 in 3M",
    ["Elemental Tempestray"]      = "1 in 1M",
    ["Dark Megalodon"]            = "1 in 8M",
}

local FishImageURL = {
    ["Monster Shark"]            = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Monster%20Shark.png",
    ["Megalodon"]                = "https://raw.githubusercontent.com/revkatomy-max/pisit-image/main/36.png",
    ["Ancient Lochness Monster"] = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Ancient%20Lochness%20Monster.png",
    ["Ancient Magma Whale"]      = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Ancient%20Magma%20Whale.png",
    ["Ancient Whale"]            = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Ancient%20Whale.png",
    ["Bloodmoon Whale"]          = "https://raw.githubusercontent.com/revkatomy-max/pisit-image/main/37.png",
    ["Blob Shark"]               = "https://raw.githubusercontent.com/revkatomy-max/pisit-image/main/2.png",
    ["Bonemaw Tyrant"]           = "https://raw.githubusercontent.com/revkatomy-max/pisit-image/main/24.png",
    ["Bone Whale"]               = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Bone%20Whale.png",
    ["Cosmic Mutant Shark"]      = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Cosmic%20Mutant%20Shark.png",
    ["Cryoshade Glider"]         = "https://raw.githubusercontent.com/revkatomy-max/pisit-image/main/5.png",
    ["Crystal Crab"]             = "https://raw.githubusercontent.com/revkatomy-max/pisit-image/main/9.png",
    ["Cursed Kraken"]            = "https://raw.githubusercontent.com/revkatomy-max/pisit-image/main/32.png",
    ["Depthseeker Ray"]          = "https://raw.githubusercontent.com/revkatomy-max/pisit-image/main/18.png",
    ["Eerie Shark"]              = "https://raw.githubusercontent.com/revkatomy-max/pisit-image/main/3.png",
    ["Elpirate Gran Maja"]       = "https://raw.githubusercontent.com/revkatomy-max/pisit-image/main/34.png",
    ["Elshark Gran Maja"]        = "https://raw.githubusercontent.com/revkatomy-max/pisit-image/main/33.png",
    ["Frostborn Shark"]          = "https://raw.githubusercontent.com/revkatomy-max/pisit-image/main/7.png",
    ["Ghost Shark"]              = "https://raw.githubusercontent.com/revkatomy-max/pisit-image/main/6.png",
    ["Giant Squid"]              = "https://raw.githubusercontent.com/revkatomy-max/pisit-image/main/13.png",
    ["Gladiator Shark"]          = "https://raw.githubusercontent.com/revkatomy-max/pisit-image/main/15.png",
    ["Great Whale"]              = "https://raw.githubusercontent.com/revkatomy-max/pisit-image/main/14.png",
    ["Ketupat Whale"]            = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Ketupat%20Whale.png",
    ["King Crab"]                = "https://raw.githubusercontent.com/revkatomy-max/pisit-image/main/19.png",
    ["King Jelly"]               = "https://raw.githubusercontent.com/revkatomy-max/pisit-image/main/20.png",
    ["Leviathan"]                = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Leviathan.png",
    ["Lochness Monster"]         = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Lochness%20Monster.png",
    ["Mosasaur Shark"]           = "https://raw.githubusercontent.com/revkatomy-max/pisit-image/main/12.png",
    ["Orca"]                     = "https://raw.githubusercontent.com/revkatomy-max/pisit-image/main/22.png",
    ["Panther Eel"]              = "https://raw.githubusercontent.com/revkatomy-max/pisit-image/main/10.png",
    ["Pirate Megalodon"]         = "https://raw.githubusercontent.com/revkatomy-max/pisit-image/main/35.png",
    ["Queen Crab"]               = "https://raw.githubusercontent.com/revkatomy-max/pisit-image/main/11.png",
    ["Rainbow Comet Shark"]      = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Rainbow%20Comet%20Shark.png",
    ["Robot Kraken"]             = "https://raw.githubusercontent.com/revkatomy-max/pisit-image/main/31.png",
    ["Ruby"]                     = "https://raw.githubusercontent.com/revkatomy-max/pisit-image/main/1.png",
    ["Sea Eater"]                = "https://raw.githubusercontent.com/revkatomy-max/pisit-image/main/47.png",
    ["Skeleton Narwhal"]         = "https://raw.githubusercontent.com/revkatomy-max/pisit-image/main/8.png",
    ["Thin Armor Shark"]         = "https://raw.githubusercontent.com/revkatomy-max/pisit-image/main/4.png",
    ["Thunderzilla"]             = "https://raw.githubusercontent.com/revkatomy-max/pisit-image/main/48.png",
    ["Strawberry Orca"]          = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Strawberry%20Orca.png",
    ["Eggy Enchant Stone"]       = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Eggy%20Enchant%20Stone.png",
    ["Worm Fish"]                = "https://raw.githubusercontent.com/revkatomy-max/pisit-image/main/25.png",
    ["Iridesca"]                 = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Iridesca.png",
    ["Deepsea Monster Axolotl"]  = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Deepsea%20Monster%20Axolotl.jpeg",
    ["Blocky Lochness Monster"]  = "https://raw.githubusercontent.com/revkatomy-max/pisit-image/main/29.png",
    ["Frostbite Leviathan"]      = "https://raw.githubusercontent.com/revkatomy-max/pisit-image/main/43.png",
    ["Aurelion"]                 = "https://raw.githubusercontent.com/revkatomy-max/pisit-image/main/30.png",
    ["Frogalloon"]               = "https://raw.githubusercontent.com/revkatomy-max/pisit-image/main/21.png",
    ["Scare"]                    = "https://raw.githubusercontent.com/revkatomy-max/pisit-image/main/28.png",
    ["Viridis Lurker"]           = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Viridis%20Lurker.jpg",
    ["Fluorivane"]               = "https://raw.githubusercontent.com/revkatomy-max/pisit-image/main/44.png",
    ["Coral Whale"]              = "https://raw.githubusercontent.com/revkatomy-max/pisit-image/main/23.png",
    ["Runic Enchant Stone"]      = "https://raw.githubusercontent.com/revkatomy-max/pisit-image/main/17.png",
    ["Flame Tyrant"]             = "https://raw.githubusercontent.com/revkatomy-max/pisit-image/main/40.png",
    ["Cerulean Dragon"]          = "https://raw.githubusercontent.com/revkatomy-max/pisit-image/main/46.png",
    ["Withering Core"]           = "https://raw.githubusercontent.com/revkatomy-max/pisit-image/main/26.png",
    ["Machodon"]                 = "https://raw.githubusercontent.com/revkatomy-max/pisit-image/main/42.png",
    ["Scorching Veinmaw"]        = "https://raw.githubusercontent.com/revkatomy-max/pisit-image/main/38.png",
    ["Crystalline Behemoth"]     = "https://raw.githubusercontent.com/revkatomy-max/pisit-image/main/45.png",
    ["Frostmoon Whale"]          = "https://raw.githubusercontent.com/revkatomy-max/pisit-image/main/39.png",
    ["Crystal Goliath"]          = "https://raw.githubusercontent.com/revkatomy-max/pisit-image/main/27.png",
    ["Glacial Serpent"]          = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/SC%20baru.png",
    ["Elemental Tempestray"]     = "https://raw.githubusercontent.com/revkatomy-max/pisit-image/main/16.png",
    ["Dark Megalodon"]           = "https://raw.githubusercontent.com/revkatomy-max/pisit-image/main/41.png",
}

-- ============================================================
--  EVENT HUNT DATABASE
-- ============================================================

local EventHuntData = {
    {
        textTriggers = { "treasure hunt" },
        title        = EMOJI_TREASURE .. " Treasure Hunt Dimulai!",
        description  = "katakan Peta 🗺️",
        color        = 16766720,
        emoji        = "💰",
        imageUrl     = nil,
        thumbUrl     = "",
    },
    {
        textTriggers = { "megalodon hunt" },
        title        = EMOJI_MEGALODON .. " Megalodon Hunt Dimulai!",
        description  = "Mega gusy 🎣",
        color        = 3447003,
        emoji        = "🦈",
        imageUrl     = FishImageURL["Megalodon"],
        thumbUrl     = FishImageURL["Megalodon"],
    },
    {
        textTriggers = { "thunderzilla hunt", "thunderzilla" },
        title        = EMOJI_THUNDER .. " Thunderzilla Hunt Dimulai!",
        description  = "zilla oi " .. EMOJI_THUNDER,
        color        = 16776960,
        emoji        = "⚡",
        imageUrl     = FishImageURL["Thunderzilla"],
        thumbUrl     = FishImageURL["Thunderzilla"],
    },
    {
        textTriggers = { "crystals have spawned", "crystals have", "crystal" },
        title        = EMOJI_CRYSTAL .. " Crystal Event Dimulai!",
        description  = "Crystal muncul gas nambang " .. EMOJI_CRYSTAL,
        color        = 1146986,
        emoji        = "💎",
        imageUrl     = nil,
        thumbUrl     = nil,
    },
}

local EventCooldown  = {}

-- ============================================================
--  STATE / CACHE
-- ============================================================

local MentionCache   = {}
local FishImageCache = {}
local AvatarCache    = {}
local LeaveTimers    = {}
local PlayerStats    = {}
local PlayerNameToId = {}

local ServerStats = {
    totalSecret    = 0,
    totalForgotten = 0,
    secretLog      = {},
    forgottenLog   = {},
    startTime      = 0,
}

-- ============================================================
--  SAVE CONFIG
-- ============================================================

local CONFIG_FILE = "bloxgank_config.json"

local function SaveConfig(joinUrl, fishUrl, statsUrl, eventUrl)
    if not writefile then return end
    pcall(function()
        writefile(CONFIG_FILE, HttpService:JSONEncode({
            webhook_join  = joinUrl  or "",
            webhook_fish  = fishUrl  or "",
            webhook_stats = statsUrl or "",
            webhook_event = eventUrl or "",
        }))
    end)
end

local function LoadConfig()
    if not readfile or not isfile then return nil end
    local ok, raw = pcall(function() return readfile(CONFIG_FILE) end)
    if not ok or not raw or raw == "" then return nil end
    local ok2, data = pcall(function() return HttpService:JSONDecode(raw) end)
    if ok2 and type(data) == "table" then return data end
    return nil
end

-- ============================================================
--  UTILITY
-- ============================================================

local function GetRequestFunc()
    return (syn and syn.request)
        or (http and http.request)
        or http_request
        or (fluxus and fluxus.request)
        or request
end

local function StripTags(str)
    return string.gsub(str, "<[^>]+>", "")
end

local function Trim(s)
    return s:match("^%s*(.-)%s*$") or s
end

local function UptimeString(seconds)
    return math.floor(seconds / 3600) .. "h " .. math.floor((seconds % 3600) / 60) .. "m"
end

local function FindPlayer(name)
    local p = Players:FindFirstChild(name)
    if p then return p end
    local lower = string.lower(name)
    for _, player in ipairs(Players:GetPlayers()) do
        if string.lower(player.Name) == lower then return player end
    end
    for _, player in ipairs(Players:GetPlayers()) do
        if string.find(string.lower(player.Name), lower, 1, true)
        or string.find(lower, string.lower(player.Name), 1, true) then
            return player
        end
    end
    return nil
end

-- ============================================================
--  RARITY BAR HELPER
-- ============================================================

local function ChanceToScale(chanceStr)
    if not chanceStr then return nil end
    local num, unit = chanceStr:match("1 in ([%d%.]+)([KM]?)")
    if not num then return nil end
    local value = tonumber(num)
    if not value then return nil end
    if unit == "K" then value = value * 1000
    elseif unit == "M" then value = value * 1000000
    end
    return value
end

local function BuildRarityBar(chanceStr)
    if not chanceStr or chanceStr == "Unknown" then
        return "░░░░░░░░░░ ?"
    end
    if chanceStr:find("%?%?") then
        return "▓▓▓▓▓▓▓▓▓▓ ∞"
    end

    local value = ChanceToScale(chanceStr)
    if not value then
        return "░░░░░░░░░░ ?"
    end

    local minLog, maxLog = math.log(50000), math.log(35000000)
    local valLog = math.log(value)
    local ratio  = (valLog - minLog) / (maxLog - minLog)
    ratio = math.clamp(ratio, 0, 1)

    local filled = math.floor(ratio * 10 + 0.5)
    if filled < 1 then filled = 1 end
    if filled > 10 then filled = 10 end

    local bar = string.rep("▓", filled) .. string.rep("░", 10 - filled)

    local label
    if value >= 15000000 then label = "FORGOTEN"
    elseif value >= 5000000 then label = "SECRET"
    elseif value >= 1000000 then label = "SIMPEN"
    elseif value >= 300000 then label = "TUMBAL"
    else label = "JUAL KE ALEX"
    end

    return bar .. " " .. label
end

-- ============================================================
--  MENTION HELPERS
-- ============================================================

local function BuildMentionCache(rbxName, rbxDisplay)
    for _, member in ipairs(MemberList) do
        local uLower = string.lower(member.username)
        local dLower = string.lower(member.display)
        if string.lower(rbxName) == uLower    or string.lower(rbxDisplay) == dLower
        or string.lower(rbxName) == dLower    or string.lower(rbxDisplay) == uLower then
            MentionCache[string.lower(rbxName)]    = member.id
            MentionCache[string.lower(rbxDisplay)] = member.id
        end
    end
end

local function GetMention(robloxName)
    if not robloxName then return "" end
    local lower = string.lower(robloxName)
    if MentionCache[lower] then return "<@" .. MentionCache[lower] .. ">" end
    for _, member in ipairs(MemberList) do
        if string.lower(member.username) == lower or string.lower(member.display) == lower then
            return "<@" .. member.id .. ">"
        end
    end
    return ""
end

-- ============================================================
--  FISH DETECTION
-- ============================================================

local function FindSecretFish(fishName)
    local lower = string.lower(fishName)
    for _, baseName in ipairs(SecretFishList) do
        if lower == string.lower(baseName) then return baseName, nil end
    end
    local bestBase, bestLen, bestMutasi = nil, 0, nil
    for _, baseName in ipairs(SecretFishList) do
        local s = string.find(lower, string.lower(baseName), 1, true)
        if s then
            local mutasi = nil
            if s > 1 then
                mutasi = fishName:sub(1, s - 1):match("^%s*(.-)%s*$")
                if mutasi == "" then mutasi = nil end
            end
            if #baseName > bestLen then
                bestLen    = #baseName
                bestBase   = baseName
                bestMutasi = mutasi
            end
        end
    end
    return bestBase, bestMutasi
end

local function FindMutasi(fishName)
    local lower = string.lower(fishName)
    for _, mutasiName in ipairs(MutasiList) do
        local mutasiLower = string.lower(mutasiName)
        local s = string.find(lower, mutasiLower, 1, true)
        if s then
            local before = s == 1 and " " or lower:sub(s - 1, s - 1)
            local after  = lower:sub(s + #mutasiLower, s + #mutasiLower)
            if (before == " " and after == " ") or (s == 1 and after == " ") then
                return mutasiName
            end
        end
    end
    return nil
end

local function FindRuby(fishName)
    local lower = string.lower(fishName)
    if string.find(lower, "ruby") and string.find(lower, "gemstone") then return "Ruby" end
    return nil
end

local function FindLegendaryCrystal(fishName)
    local lower = string.lower(fishName)
    if not string.find(lower, "crystalized") then return nil end
    for _, name in ipairs(LegendaryCrystalList) do
        if string.find(lower, string.lower(name), 1, true) then return name end
    end
    return nil
end

local function GetFishImageId(item)
    for _, desc in ipairs(item:GetDescendants()) do
        local ok, val = pcall(function()
            if desc:IsA("SpecialMesh")                               then return desc.TextureId
            elseif desc:IsA("Decal") or desc:IsA("Texture")         then return desc.Texture
            elseif desc:IsA("ImageLabel") or desc:IsA("ImageButton") then return desc.Image
            end
            return nil
        end)
        if ok and val and val ~= "" and val ~= "rbxasset://" then
            local id = tostring(val):match("%d+")
            if id then return id end
        end
    end
    return nil
end

-- ============================================================
--  WEBHOOK SENDERS
-- ============================================================

local function BrandAuthor()
    if BRAND_ICON ~= "" then
        return { name = BRAND_NAME, icon_url = BRAND_ICON }
    end
    return { name = BRAND_NAME }
end

local function BuildEmbed(title, description, color, fields, imageUrl, thumbUrl, footerTag, author)
    local embed = {
        title       = title,
        description = description,
        color       = color,
        fields      = fields,
        footer      = { text = (footerTag or BRAND_FOOTER_TEXT) .. " " .. os.date("%d/%m/%Y %H:%M:%S") },
        timestamp   = os.date("!%Y-%m-%dT%H:%M:%SZ"),
    }
    if imageUrl then embed.image     = { url = imageUrl } end
    if thumbUrl then embed.thumbnail = { url = thumbUrl } end
    embed.author = author or BrandAuthor()
    return embed
end

local function PostWebhook(url, body)
    local requestFunc = GetRequestFunc()
    if not requestFunc or url == "" then return end
    task.spawn(function()
        pcall(function()
            requestFunc({
                Url     = url,
                Method  = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body    = HttpService:JSONEncode(body),
            })
        end)
    end)
end

local function BuildContent(mention, captionType)
    if not mention or mention == "" then return nil end
    local m = Trim(mention)
    if captionType == "secret" or captionType == "forgotten" then return "Hari hari bersyukur " .. m
    elseif captionType == "leave"   then return "ke disconect ya? " .. m
    elseif captionType == "join"    then return "alhamdulilah kembali " .. m
    elseif captionType == "notback" then return "lah kok ngilang " .. m
    end
    return m
end

local function SendWebhook(title, description, color, fields, imageUrl, thumbUrl, mention, captionType)
    local f = {}
    for _, v in ipairs(fields) do table.insert(f, v) end
    table.insert(f, LINE)
    PostWebhook(WEBHOOK_URL, {
        username   = "BLOX Gank",
        avatar_url = WEBHOOK_AVATAR,
        content    = BuildContent(mention, captionType),
        embeds     = { BuildEmbed(title, description, color, f, imageUrl, thumbUrl) },
    })
end

local function SendFishWebhook(title, description, color, fields, imageUrl, thumbUrl, mention, captionType)
    local url = (WEBHOOK_FISH ~= "") and WEBHOOK_FISH or WEBHOOK_URL
    if url == "" then return end
    local f = {}
    for _, v in ipairs(fields) do table.insert(f, v) end
    table.insert(f, LINE)
    PostWebhook(url, {
        content = BuildContent(mention, captionType),
        embeds  = { BuildEmbed(title, description, color, f, imageUrl, thumbUrl) },
    })
end

local function SendStatsWebhook(title, description, color, fields, imageUrl, thumbUrl)
    local f = {}
    for _, v in ipairs(fields) do table.insert(f, v) end
    table.insert(f, LINE)
    PostWebhook(WEBHOOK_STATS, {
        embeds = { BuildEmbed(title, description, color, f, imageUrl, thumbUrl, "BLOX Gank Stats") }
    })
end

-- ============================================================
--  EVENT WEBHOOK SENDER
-- ============================================================

local function SendEventWebhook(eventData, rawText)
    local url = (WEBHOOK_EVENT ~= "") and WEBHOOK_EVENT or WEBHOOK_URL
    if url == "" then return end

    PostWebhook(url, {
        username   = "BLOX Gank Event",
        avatar_url = WEBHOOK_AVATAR,
        content    = "<@&" .. ROLE_NELAYAN_ID .. ">",
        embeds     = { BuildEmbed(
            eventData.title,
            eventData.description,
            eventData.color,
            {
                { name = SEP .. " Host Server",  value = "**" .. Players.LocalPlayer.Name .. "**",               inline = true },
                { name = SEP .. " Total Player", value = "**" .. tostring(#Players:GetPlayers()) .. "** orang",  inline = true },
                { name = SEP .. " Waktu Mulai",  value = os.date("%H:%M:%S"),                                    inline = true },
                LINE,
            },
            eventData.imageUrl,
            eventData.thumbUrl,
            "BLOX Gank Event Monitor",
            { name = EMOJI_EVENTTAG .. " Event Hunt Alert", icon_url = WEBHOOK_AVATAR ~= "" and WEBHOOK_AVATAR or nil }
        )},
    })
end

-- ============================================================
--  EVENT DETECTION
-- ============================================================

local _hookedLabels = {}

local function ProcessEventText(text)
    if not SCRIPT_ACTIVE then return end
    if not text or text == "" then return end
    local lower = text:lower()

    local isRelevant = lower:find("hunt") or lower:find("started") or lower:find("crystal") or lower:find("spawned")
    if not isRelevant then return end

    for _, evData in ipairs(EventHuntData) do
        for _, trigger in ipairs(evData.textTriggers) do
            if lower:find(trigger, 1, true) then
                local now = os.time()
                if (now - (EventCooldown[evData.title] or 0)) >= EVENT_COOLDOWN_SECONDS then
                    EventCooldown[evData.title] = now
                    SendEventWebhook(evData, text)
                end
                return
            end
        end
    end
end

local function HookLabel(label)
    if _hookedLabels[label] then return end
    _hookedLabels[label] = true

    ProcessEventText(label.Text)

    label:GetPropertyChangedSignal("Text"):Connect(function()
        ProcessEventText(label.Text)
    end)
end

local function StartEventMonitor()
    task.spawn(function()
        local pg = Players.LocalPlayer:WaitForChild("PlayerGui", 30)
        if not pg then return end

        for _, v in ipairs(pg:GetDescendants()) do
            if v:IsA("TextLabel") or v:IsA("TextButton") then
                HookLabel(v)
            end
        end

        pg.DescendantAdded:Connect(function(v)
            if v:IsA("TextLabel") or v:IsA("TextButton") then
                task.wait(0)
                HookLabel(v)
            end
        end)
    end)
end

-- ============================================================
--  LEADERBOARD
-- ============================================================

local function SendLeaderboard()
    local leaderData = {}
    for _, stats in pairs(PlayerStats) do
        local total, fishList = 0, {}
        for fishName, count in pairs(stats.secretList) do
            total = total + count
            table.insert(fishList, fishName .. " x" .. count)
        end
        if total > 0 then
            table.insert(leaderData, { name = stats.name or "Unknown", total = total,
                fishStr = #fishList > 0 and table.concat(fishList, ", ") or "-" })
        end
    end
    table.sort(leaderData, function(a, b) return a.total > b.total end)
    if #leaderData == 0 then return end

    local medals = { "🥇", "🥈", "🥉" }
    local lines  = {}
    for i, entry in ipairs(leaderData) do
        if i > 10 then break end
        local medal = medals[i] or ("**#" .. i .. "**")
        table.insert(lines, medal .. " **" .. entry.name .. "** " .. SEP .. " " .. entry.total .. " secret\n↳ " .. entry.fishStr)
    end

    local uptime = os.time() - ServerStats.startTime
    SendStatsWebhook(EMOJI_TROPHY .. " Leaderboard Secret Fish", table.concat(lines, "\n\n"), 16766720, {
        LINE,
        { name = SEP .. " Uptime Server",   value = UptimeString(uptime),                                      inline = true },
        { name = SEP .. " Total Secret",    value = "**" .. tostring(ServerStats.totalSecret) .. "** ekor",    inline = true },
        { name = SEP .. " Total Forgotten", value = "**" .. tostring(ServerStats.totalForgotten) .. "** ekor", inline = true },
    })
end

-- ============================================================
--  CHAT PARSING & DETECTION
-- ============================================================

local function ParseChat(rawMsg)
    local msg = StripTags(rawMsg)
    msg = string.gsub(msg, "^%[Server%]:%s*", "")

    local playerName, fishFull, weight = string.match(msg, "^(.-) obtained an? (.-) %(([%d%.%a]+ ?kg)%)")
    if not playerName then
        playerName, fishFull = string.match(msg, "^(.-) obtained an? (.+)")
        weight = "N/A"
    end
    if not playerName or not fishFull then return nil end

    playerName = playerName:match("%[%a+%]:%s*(.+)") or playerName
    playerName = Trim(playerName)
    weight     = weight and Trim(weight) or "N/A"
    fishFull   = fishFull:match("^(.-)%s+with a 1 in") or fishFull
    fishFull   = fishFull:match("^(.-)%s*[!%.]?$")     or fishFull
    fishFull   = Trim(fishFull)

    return { player = playerName, fish = fishFull, weight = weight }
end

-- ============================================================
--  AVATAR URL HELPER
-- ============================================================

local function GetAvatarUrlById(userId)
    if not userId then return nil end
    return PROXY .. "/avatar/" .. tostring(userId) .. "?t=" .. tostring(os.time())
end

-- ============================================================
--  CHECK AND SEND
-- ============================================================

local function CheckAndSend(rawMsg)
    if not SCRIPT_ACTIVE then return end
    if not string.find(string.lower(rawMsg), "obtained") then return end

    local data = ParseChat(rawMsg)
    if not data then return end

    local targetPlayer = FindPlayer(data.player)
    local uid = (targetPlayer and targetPlayer.UserId)
             or PlayerNameToId[string.lower(data.player)]
    local avatarUrl = GetAvatarUrlById(uid)

    if uid then
        if not PlayerStats[uid] then
            PlayerStats[uid] = { catchCount = 0, secretList = {}, joinTime = os.time(), lastFishTime = nil, name = data.player }
        end
        PlayerStats[uid].catchCount   = PlayerStats[uid].catchCount + 1
        PlayerStats[uid].lastFishTime = os.time()
    end

    local legendaryBase = FindLegendaryCrystal(data.fish)
    if legendaryBase then
        local imageUrl = FishImageURL[legendaryBase] or (FishImageCache[legendaryBase] and (PROXY .. "/asset/" .. FishImageCache[legendaryBase]))
        SendFishWebhook(EMOJI_LEGENDARY .. " Crystalized Legendary!", " " .. EMOJI_MUTASI, TierColors.Legendary, {
            LINE,
            { name = SEP .. " Pemain",  value = "**" .. data.player .. "**", inline = true },
            { name = SEP .. " Item",    value = "**" .. data.fish .. "**",   inline = true },
            { name = SEP .. " Berat",   value = "**" .. data.weight .. "**", inline = true },
        }, imageUrl, avatarUrl, nil, "secret")
        return
    end

    local rubyBase = FindRuby(data.fish)
    if rubyBase then
        local imageUrl = FishImageURL[rubyBase] or (FishImageCache[rubyBase] and (PROXY .. "/asset/" .. FishImageCache[rubyBase]))
        SendFishWebhook(EMOJI_RUBY .. " Ruby Gemstone!", "Goceng" .. EMOJI_RUBY, TierColors.Ruby, {
            LINE,
            { name = SEP .. " Pemain", value = "**" .. data.player .. "**", inline = true },
            { name = SEP .. " Item",   value = "**" .. data.fish .. "**",   inline = true },
            { name = SEP .. " Berat",  value = "**" .. data.weight .. "**", inline = true },
        }, imageUrl, avatarUrl, nil, "secret")
        return
    end

    local baseName, mutasi = FindSecretFish(data.fish)
    if baseName then
        local imageUrl = FishImageURL[baseName] or (FishImageCache[baseName] and (PROXY .. "/asset/" .. FishImageCache[baseName]))
        local isForgotten = false
        for _, name in ipairs(ForgottenList) do
            if string.lower(baseName) == string.lower(name) then isForgotten = true; break end
        end
        if uid and PlayerStats[uid] then
            PlayerStats[uid].secretList[baseName] = (PlayerStats[uid].secretList[baseName] or 0) + 1
        end
        local chanceInfo  = FishChanceData[baseName] or "Unknown"
        local rarityBar   = BuildRarityBar(chanceInfo)
        local mutasiField = mutasi and (EMOJI_MUTASI .. " *" .. mutasi .. "*") or "—"
        local fields = {
            LINE,
            { name = SEP .. " Pemain", value = "**" .. data.player .. "**", inline = true },
            { name = SEP .. " Ikan",   value = "**" .. data.fish .. "**",   inline = true },
            { name = SEP .. " Berat",  value = "**" .. data.weight .. "**", inline = true },
            { name = SEP .. " Mutasi", value = mutasiField,                  inline = true },
            { name = SEP .. " Chance", value = chanceInfo,                   inline = true },
            { name = SEP .. " Rarity", value = rarityBar,                    inline = false },
        }
        if isForgotten then
            ServerStats.totalForgotten = ServerStats.totalForgotten + 1
            table.insert(ServerStats.forgottenLog, { fish = baseName, player = data.player, time = os.time() })
            SendFishWebhook(EMOJI_FORGOTTEN .. " Forgotten Tier Detected!", " " .. EMOJI_FORGOTTEN, TierColors.Forgotten, fields, imageUrl, avatarUrl, GetMention(data.player), "forgotten")
        else
            ServerStats.totalSecret = ServerStats.totalSecret + 1
            table.insert(ServerStats.secretLog, { fish = baseName, player = data.player, time = os.time() })
            SendFishWebhook(EMOJI_NOTIF .. " Secret Fish Detected!", " ", TierColors.Secret, fields, imageUrl, avatarUrl, GetMention(data.player), "secret")
        end
        return
    end

    local mutasiDetected = FindMutasi(data.fish)
    if not mutasiDetected then return end

    SendFishWebhook(
        EMOJI_MUTASI .. " Mutasi Terdeteksi!",
        "",
        TierColors.Mutasi,
        {
            LINE,
            { name = SEP .. " Pemain", value = "**" .. data.player .. "**", inline = true },
            { name = SEP .. " Ikan",   value = "**" .. data.fish .. "**",   inline = true },
            { name = SEP .. " Berat",  value = "**" .. data.weight .. "**", inline = true },
            { name = SEP .. " Mutasi", value = EMOJI_MUTASI .. " " .. mutasiDetected, inline = true },
        },
        nil,
        avatarUrl,
        nil,
        nil
    )
end

-- ============================================================
--  BACKPACK MONITOR
-- ============================================================

local function WatchBackpack(bp)
    bp.ChildAdded:Connect(function(item)
        task.wait(0.1)
        local baseName = FindSecretFish(item.Name)
        if baseName and not FishImageURL[baseName] and not FishImageCache[baseName] then
            local imgId = GetFishImageId(item)
            if imgId then FishImageCache[baseName] = imgId end
        end
    end)
end

local function WatchForFish(player)
    local bp = player:FindFirstChild("Backpack")
    if bp then WatchBackpack(bp) end
    player.CharacterAdded:Connect(function()
        local newBp = player:WaitForChild("Backpack", 15)
        if newBp then WatchBackpack(newBp) end
    end)
end

-- ============================================================
--  HOOK CHAT
-- ============================================================

local function HookChat()
    if TextChatService then
        TextChatService.MessageReceived:Connect(function(msg)
            local text = msg.Text or ""
            if msg.TextSource == nil then CheckAndSend(text) end
        end)
    end
    local chatEvents = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    if chatEvents then
        local onMessage = chatEvents:FindFirstChild("OnMessageDoneFiltering")
        if onMessage then
            onMessage.OnClientEvent:Connect(function(d)
                if not (d and d.Message) then return end
                local lowerMsg = string.lower(d.Message)
                if string.find(lowerMsg, "%[server%]") or string.find(lowerMsg, "obtained") then
                    CheckAndSend(d.Message)
                end
            end)
        end
    end
end

-- ============================================================
--  START MONITORING
-- ============================================================

local function StartMonitoring()
    ServerStats.startTime = os.time()

    local allPlayers = Players:GetPlayers()
    local names      = {}
    for _, p in ipairs(allPlayers) do table.insert(names, p.Name) end

    SendWebhook(EMOJI_STARTER .. " Monitor Started", "Server monitor sudah aktif ", TierColors.Join, {
        LINE,
        { name = SEP .. " Host",          value = "**" .. Players.LocalPlayer.Name .. "**",     inline = true  },
        { name = SEP .. " Total Player",  value = "**" .. tostring(#allPlayers) .. "** orang",   inline = true  },
        { name = SEP .. " Daftar Player", value = "```\n" .. table.concat(names, ", ") .. "```", inline = false },
    })

    HookChat()
    StartEventMonitor()

    task.spawn(function()
        while SCRIPT_ACTIVE do
            task.wait(LEADERBOARD_INTERVAL)
            if SCRIPT_ACTIVE then SendLeaderboard() end
        end
    end)

    task.spawn(function()
        while SCRIPT_ACTIVE do
            task.wait(1200)
            if not SCRIPT_ACTIVE then break end
            local uptime = os.time() - ServerStats.startTime
            local recentSecret, recentForgotten = {}, {}
            for i = math.max(1, #ServerStats.secretLog - 4), #ServerStats.secretLog do
                local e = ServerStats.secretLog[i]
                table.insert(recentSecret, e.fish .. " (" .. e.player .. ")")
            end
            for i = math.max(1, #ServerStats.forgottenLog - 4), #ServerStats.forgottenLog do
                local e = ServerStats.forgottenLog[i]
                table.insert(recentForgotten, e.fish .. " (" .. e.player .. ")")
            end
            SendStatsWebhook(EMOJI_SERVER .. " Server Stats", "Ringkasan aktivitas server", 3447003, {
                LINE,
                { name = SEP .. " Uptime Monitor",    value = UptimeString(uptime),                                                 inline = true  },
                { name = SEP .. " Total Secret Fish",  value = "**" .. tostring(ServerStats.totalSecret) .. "** ekor",              inline = true  },
                { name = SEP .. " Total Forgotten",    value = "**" .. tostring(ServerStats.totalForgotten) .. "** ekor",           inline = true  },
                { name = SEP .. " Secret Terakhir",    value = #recentSecret   > 0 and table.concat(recentSecret,   "\n") or "—",  inline = false },
                { name = SEP .. " Forgotten Terakhir", value = #recentForgotten > 0 and table.concat(recentForgotten, "\n") or "—",inline = false },
            })
        end
    end)

    for _, p in ipairs(allPlayers) do
        WatchForFish(p)
        AvatarCache[p.UserId]                       = GetAvatarUrlById(p.UserId)
        PlayerStats[p.UserId]                       = { catchCount = 0, secretList = {}, joinTime = os.time(), lastFishTime = nil, name = p.Name }
        PlayerNameToId[string.lower(p.Name)]        = p.UserId
        PlayerNameToId[string.lower(p.DisplayName)] = p.UserId
        BuildMentionCache(p.Name, p.DisplayName)
    end

    Players.PlayerAdded:Connect(function(player)
        if not SCRIPT_ACTIVE then return end
        LeaveTimers[player.UserId] = nil
        PlayerStats[player.UserId] = { catchCount = 0, secretList = {}, joinTime = os.time(), lastFishTime = nil, name = player.Name }
        PlayerNameToId[string.lower(player.Name)]        = player.UserId
        PlayerNameToId[string.lower(player.DisplayName)] = player.UserId
        BuildMentionCache(player.Name, player.DisplayName)
        task.spawn(function()
            task.wait(1)
            AvatarCache[player.UserId] = GetAvatarUrlById(player.UserId)
            SendWebhook(EMOJI_JOIN .. " Player Joined Server", "welcam", TierColors.Join, {
                LINE,
                { name = SEP .. " Username",     value = "**" .. player.Name .. "**",                    inline = true },
                { name = SEP .. " Total Player", value = "**" .. tostring(#Players:GetPlayers()) .. "**", inline = true },
            }, nil, AvatarCache[player.UserId], GetMention(player.Name), "join")
        end)
        WatchForFish(player)
    end)

    Players.PlayerRemoving:Connect(function(player)
        if not SCRIPT_ACTIVE then return end
        local pName      = player.Name
        local pId        = player.UserId
        local avatarUrl  = AvatarCache[pId] or GetAvatarUrlById(pId)
        local totalNow   = #Players:GetPlayers() - 1
        local mentionStr = GetMention(pName)

        AvatarCache[pId]                    = nil
        PlayerStats[pId]                    = nil
        PlayerNameToId[string.lower(pName)] = nil
        for k, v in pairs(PlayerNameToId) do if v == pId then PlayerNameToId[k] = nil end end
        MentionCache[string.lower(pName)]   = nil

        SendWebhook(EMOJI_LEAVE .. " Player Left Server", "Salah satu pemain keluar server.", TierColors.Leave, {
            LINE,
            { name = SEP .. " Username",     value = "**" .. pName .. "**",             inline = true },
            { name = SEP .. " Total Player", value = "**" .. tostring(totalNow) .. "**", inline = true },
        }, nil, avatarUrl, mentionStr, "leave")

        LeaveTimers[pId] = true
        task.spawn(function()
            task.wait(600)
            if LeaveTimers[pId] then
                LeaveTimers[pId] = nil
                local notBackContent = BuildContent(mentionStr, "notback")
                PostWebhook(WEBHOOK_URL, {
                    username   = "BLOX Gank",
                    avatar_url = WEBHOOK_AVATAR,
                    content    = notBackContent,
                    embeds     = { BuildEmbed(EMOJI_NOTBACK .. " Player Tidak Kembali", "Pemain ini belum balik lagi ke server, semoga aman ya~", TierColors.NotBack, {
                        LINE,
                        { name = SEP .. " Username", value = "**" .. pName .. "**",               inline = true },
                        { name = SEP .. " Info",     value = "Tidak kembali selama **10 menit**", inline = true },
                    }, avatarUrl, nil, "BLOX Gank Webhook") },
                })
            end
        end)
    end)
end

-- ============================================================
--  UI
-- ============================================================

local function CreateUI()
    local gui = Instance.new("ScreenGui")
    gui.Name         = "BloxGankUI"
    gui.ResetOnSpawn = false
    gui.Parent       = (gethui and gethui()) or CoreGui

    local savedConfig = LoadConfig()

    local FRAME_H = 355
    local frame = Instance.new("Frame")
    frame.Name              = "Main"
    frame.Size              = UDim2.new(0, 300, 0, FRAME_H)
    frame.Position          = UDim2.new(0.5, -150, 0.5, -120)
    frame.BackgroundColor3  = Color3.fromRGB(20, 20, 20)
    frame.BorderSizePixel   = 0
    frame.Parent            = gui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(50, 50, 50); stroke.Thickness = 1; stroke.Parent = frame

    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 36); topBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    topBar.BorderSizePixel = 0; topBar.Parent = frame
    Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 8)

    local topBarFix = Instance.new("Frame")
    topBarFix.Size = UDim2.new(1, 0, 0, 8); topBarFix.Position = UDim2.new(0, 0, 1, -8)
    topBarFix.BackgroundColor3 = Color3.fromRGB(30, 30, 30); topBarFix.BorderSizePixel = 0; topBarFix.Parent = topBar

    local title = Instance.new("TextLabel")
    title.Text = "🎣 BLOX Gank Monitor"; title.Size = UDim2.new(1, -80, 1, 0); title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1; title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold; title.TextSize = 13; title.TextXAlignment = Enum.TextXAlignment.Left; title.Parent = topBar

    local function MakeWinBtn(text, xOffset, bgColor)
        local btn = Instance.new("TextButton")
        btn.Text = text; btn.Size = UDim2.new(0, 28, 0, 22); btn.Position = UDim2.new(1, xOffset, 0.5, -11)
        btn.BackgroundColor3 = bgColor; btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBold; btn.TextSize = 12; btn.BorderSizePixel = 0; btn.Parent = topBar
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
        return btn
    end

    local minBtn   = MakeWinBtn("—", -58, Color3.fromRGB(60, 60, 60))
    local closeBtn = MakeWinBtn("✕", -28, Color3.fromRGB(200, 50, 50))
    local isMinimized = false
    local fullSize = UDim2.new(0, 300, 0, FRAME_H)
    local miniSize = UDim2.new(0, 300, 0, 36)

    minBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        TweenService:Create(frame, TweenInfo.new(0.2), { Size = isMinimized and miniSize or fullSize }):Play()
        minBtn.Text = isMinimized and "□" or "—"
    end)
    closeBtn.MouseButton1Click:Connect(function()
        TweenService:Create(frame, TweenInfo.new(0.15), { Size = UDim2.new(0,300,0,0), BackgroundTransparency=1 }):Play()
        task.wait(0.2); gui:Destroy()
    end)

    local function HoverTween(btn, hoverColor, baseColor)
        btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.1), { BackgroundColor3 = hoverColor }):Play() end)
        btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.1), { BackgroundColor3 = baseColor  }):Play() end)
    end
    HoverTween(minBtn,   Color3.fromRGB(80,80,80),   Color3.fromRGB(60,60,60))
    HoverTween(closeBtn, Color3.fromRGB(230,70,70),  Color3.fromRGB(200,50,50))

    local dragging, dragStart, startPos
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = frame.Position
        end
    end)
    topBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+delta.X, startPos.Y.Scale, startPos.Y.Offset+delta.Y)
        end
    end)

    local statusDot = Instance.new("Frame")
    statusDot.Size = UDim2.new(0,8,0,8); statusDot.Position = UDim2.new(0,16,0,46)
    statusDot.BackgroundColor3 = Color3.fromRGB(255,60,60); statusDot.BorderSizePixel = 0; statusDot.Parent = frame
    Instance.new("UICorner", statusDot).CornerRadius = UDim.new(1,0)

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Text = "Tidak Aktif"; statusLabel.Size = UDim2.new(1,-40,0,20); statusLabel.Position = UDim2.new(0,30,0,38)
    statusLabel.BackgroundTransparency = 1; statusLabel.TextColor3 = Color3.fromRGB(180,180,180)
    statusLabel.Font = Enum.Font.Gotham; statusLabel.TextSize = 11
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left; statusLabel.Parent = frame

    local function MakeLabel(text, yPos)
        local lbl = Instance.new("TextLabel")
        lbl.Text = text; lbl.Size = UDim2.new(1,-24,0,14); lbl.Position = UDim2.new(0,12,0,yPos)
        lbl.BackgroundTransparency = 1; lbl.TextColor3 = Color3.fromRGB(130,130,130)
        lbl.Font = Enum.Font.Gotham; lbl.TextSize = 10; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = frame
        return lbl
    end

    local function MakeInput(placeholder, yPos)
        local box = Instance.new("TextBox")
        box.PlaceholderText = placeholder; box.Size = UDim2.new(1,-24,0,28); box.Position = UDim2.new(0,12,0,yPos)
        box.BackgroundColor3 = Color3.fromRGB(35,35,35); box.TextColor3 = Color3.fromRGB(220,220,220)
        box.PlaceholderColor3 = Color3.fromRGB(100,100,100); box.Font = Enum.Font.Gotham; box.TextSize = 10
        box.ClearTextOnFocus = false; box.BorderSizePixel = 0; box.Text = ""
        box.TextXAlignment = Enum.TextXAlignment.Left; box.ClipsDescendants = true; box.Parent = frame
        Instance.new("UICorner", box).CornerRadius = UDim.new(0,6)
        local pad = Instance.new("UIPadding", box); pad.PaddingLeft = UDim.new(0,8); pad.PaddingRight = UDim.new(0,8)
        return box
    end

    MakeLabel("👋 Webhook Join / Leave", 58)
    local inputJoin  = MakeInput("Paste webhook join/leave...", 72)

    MakeLabel("🐋 Webhook Secret Fish", 108)
    local inputFish  = MakeInput("Paste webhook secret fish...", 122)

    MakeLabel("📊 Webhook Stats", 158)
    local inputStats = MakeInput("Paste webhook stats...", 172)

    MakeLabel("🎯 Webhook Event Hunt (Role Nelayan)", 208)
    local inputEvent = MakeInput("Kosong = pakai webhook join/leave...", 222)

    local saveEnabled = false

    local toggleBg = Instance.new("Frame")
    toggleBg.Size = UDim2.new(0,36,0,18); toggleBg.Position = UDim2.new(1,-48,0,264)
    toggleBg.BackgroundColor3 = Color3.fromRGB(60,60,60); toggleBg.BorderSizePixel = 0; toggleBg.Parent = frame
    Instance.new("UICorner", toggleBg).CornerRadius = UDim.new(1,0)

    local toggleKnob = Instance.new("Frame")
    toggleKnob.Size = UDim2.new(0,14,0,14); toggleKnob.Position = UDim2.new(0,2,0.5,-7)
    toggleKnob.BackgroundColor3 = Color3.fromRGB(200,200,200); toggleKnob.BorderSizePixel = 0; toggleKnob.Parent = toggleBg
    Instance.new("UICorner", toggleKnob).CornerRadius = UDim.new(1,0)

    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Text = "💾 Simpan Config"; toggleLabel.Size = UDim2.new(1,-60,0,18); toggleLabel.Position = UDim2.new(0,12,0,262)
    toggleLabel.BackgroundTransparency = 1; toggleLabel.TextColor3 = Color3.fromRGB(130,130,130)
    toggleLabel.Font = Enum.Font.Gotham; toggleLabel.TextSize = 10
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left; toggleLabel.Parent = frame

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0,36,0,18); toggleBtn.Position = UDim2.new(1,-48,0,264)
    toggleBtn.BackgroundTransparency = 1; toggleBtn.Text = ""; toggleBtn.BorderSizePixel = 0; toggleBtn.Parent = frame

    local function SetToggle(enabled)
        saveEnabled = enabled
        TweenService:Create(toggleKnob, TweenInfo.new(0.15), {
            Position         = enabled and UDim2.new(0,20,0.5,-7) or UDim2.new(0,2,0.5,-7),
            BackgroundColor3 = enabled and Color3.fromRGB(0,220,100) or Color3.fromRGB(200,200,200),
        }):Play()
        TweenService:Create(toggleBg, TweenInfo.new(0.15), {
            BackgroundColor3 = enabled and Color3.fromRGB(0,100,50) or Color3.fromRGB(60,60,60),
        }):Play()
        toggleLabel.TextColor3 = enabled and Color3.fromRGB(0,220,100) or Color3.fromRGB(130,130,130)
    end

    toggleBtn.MouseButton1Click:Connect(function() SetToggle(not saveEnabled) end)

    if savedConfig then
        if savedConfig.webhook_join  and savedConfig.webhook_join  ~= "" then inputJoin.Text  = savedConfig.webhook_join  end
        if savedConfig.webhook_fish  and savedConfig.webhook_fish  ~= "" then inputFish.Text  = savedConfig.webhook_fish  end
        if savedConfig.webhook_stats and savedConfig.webhook_stats ~= "" then inputStats.Text = savedConfig.webhook_stats end
        if savedConfig.webhook_event and savedConfig.webhook_event ~= "" then inputEvent.Text = savedConfig.webhook_event end
        SetToggle(true)
    end

    local startBtn = Instance.new("TextButton")
    startBtn.Text = "START MONITORING"; startBtn.Size = UDim2.new(1,-24,0,34); startBtn.Position = UDim2.new(0,12,0,298)
    startBtn.BackgroundColor3 = Color3.fromRGB(0,180,100); startBtn.TextColor3 = Color3.fromRGB(255,255,255)
    startBtn.Font = Enum.Font.GothamBold; startBtn.TextSize = 12; startBtn.BorderSizePixel = 0; startBtn.Parent = frame
    Instance.new("UICorner", startBtn).CornerRadius = UDim.new(0,6)
    HoverTween(startBtn, Color3.fromRGB(0,210,120), Color3.fromRGB(0,180,100))

    startBtn.MouseButton1Click:Connect(function()
        if SCRIPT_ACTIVE then return end

        if not inputJoin.Text:find("discord.com/api/webhooks") then
            startBtn.Text = "❌ WEBHOOK JOIN INVALID!"; startBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
            task.wait(2); startBtn.Text = "START MONITORING"; startBtn.BackgroundColor3 = Color3.fromRGB(0,180,100)
            return
        end

        WEBHOOK_URL = inputJoin.Text
        if inputFish.Text:find("discord.com/api/webhooks")  then WEBHOOK_FISH  = inputFish.Text  end
        if inputStats.Text:find("discord.com/api/webhooks") then WEBHOOK_STATS = inputStats.Text end
        if inputEvent.Text:find("discord.com/api/webhooks") then WEBHOOK_EVENT = inputEvent.Text end

        if saveEnabled then SaveConfig(WEBHOOK_URL, WEBHOOK_FISH, WEBHOOK_STATS, WEBHOOK_EVENT) end

        SCRIPT_ACTIVE = true
        statusDot.BackgroundColor3 = Color3.fromRGB(0,220,100)
        statusLabel.Text           = "Aktif — Monitoring..."
        statusLabel.TextColor3     = Color3.fromRGB(0,220,100)
        startBtn.Text              = "✅ MONITORING AKTIF"
        startBtn.BackgroundColor3  = Color3.fromRGB(30,30,30)

        for _, box in ipairs({ inputJoin, inputFish, inputStats, inputEvent }) do
            box.TextEditable = false
        end
        toggleBtn.Active = false

        StartMonitoring()
    end)
end

-- ============================================================
--  INIT
-- ============================================================

CreateUI()
