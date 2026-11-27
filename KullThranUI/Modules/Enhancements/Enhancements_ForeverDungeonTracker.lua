local _, ns = ...
local KT = ns.KT or _G.KT
local Mod = ns.Enhancements or KT:GetModule("Enhancements", true)
if not Mod then return end

local run, testing, frame, activeConfig, simulation
-- inside: the player is in the run's dungeon. ghostOutside: released and
-- running back, when the tracker stays up. pendingTargets: the click areas
-- wait for the end of combat.
local inside, ghostOutside, pendingTargets = false, false, false
local dead = {}
local GROUP_UNITS = { player = true, party1 = true, party2 = true, party3 = true, party4 = true }
-- The client gives no ID for one dungeon run. Walking back in continues the
-- run (a corpse run, a trip to a vendor) unless it was finished before
-- leaving, or the dungeon was left for longer than this.
local STALE_RUN_SECONDS = 60 * 60
-- Portraits of the test and simulated bosses (Modules/BossPortrait.lua).
local SAMPLE_DISPLAYS = KT.BossPortrait and KT.BossPortrait.SAMPLE_DISPLAYS or {}

-- Instance payloads can be secret on modern clients. Never compare, index or
-- format them; treat them as missing instead.
local function IsSecret(value)
    if value == nil or not issecretvalue then return false end
    local ok, secret = pcall(issecretvalue, value)
    return ok and secret == true
end
local function Plain(value)
    if IsSecret(value) then return nil end
    return value
end

-- Every visible string goes through the locale tables (Locales/Modules/DungeonTimer.lua).
local function L(text)
    local locale = KT.GetLocale and KT:GetLocale()
    local value = locale and locale[text]
    return type(value) == "string" and value ~= "" and value or text
end

local function Config()
    local db = Mod:GetDB()
    db.mplusTracker = db.mplusTracker or {}
    return db.mplusTracker
end
-- WoW Forever dungeons have no timer to beat. The tracker shows how long the
-- run has taken (clockStart/clockEnd, see Clock below), not a limit. The time
-- spent inside (started/elapsed) only says whether the run is active, paused
-- or finished.
local function Now() return GetServerTime and GetServerTime() or time() end
local function Elapsed()
    return run and ((run.elapsed or 0) + (run.started and math.max(0, Now() - run.started) or 0)) or 0
end
local function Save()
    if not testing then Config().dungeonRun = run end
end
local function JournalInstance(mapID)
    -- EJ_GetInstanceForMap expects a UI map, not the instance ID returned by
    -- GetInstanceInfo, so try the player's UI map first.
    local candidates = {}
    if C_Map and C_Map.GetBestMapForUnit then
        local ok, uiMap = pcall(C_Map.GetBestMapForUnit, "player")
        if ok and Plain(uiMap) then candidates[#candidates + 1] = uiMap end
    end
    candidates[#candidates + 1] = mapID
    if EJ_GetInstanceForMap then
        for _, id in ipairs(candidates) do
            local ok, journal = pcall(EJ_GetInstanceForMap, id)
            journal = ok and Plain(journal)
            if journal and journal ~= 0 then return journal end
        end
    end
    if EJ_GetCurrentInstance then
        local ok, journal = pcall(EJ_GetCurrentInstance)
        journal = ok and Plain(journal)
        if journal and journal ~= 0 then return journal end
    end
end
-- Forever ships no Adventure Guide data (its journal tables are empty), so the
-- boss list of every five-player dungeon comes from the client's own
-- DungeonEncounter table: encounter ID and name in kill order, the normal
-- difficulty only. The IDs are the ones ENCOUNTER_END reports.
local DUNGEON_BOSSES = {
    [33] = { -- Shadowfang Keep
        { 2748, "Rethilgore" }, { 2749, "Razorclaw the Butcher" }, { 2750, "Baron Silverlaine" },
        { 2751, "Commander Springvale" }, { 2752, "Odo the Blindwatcher" }, { 2753, "Fenrus the Devourer" },
        { 2754, "Wolf Master Nandos" }, { 2755, "Archmage Arugal" },
    },
    [34] = { -- Stormwind Stockade
        { 2756, "Targorr the Dread" }, { 2757, "Kam Deepfury" }, { 2758, "Hamhock" },
        { 2759, "Dextren Ward" }, { 2760, "Bazil Thredd" },
    },
    [36] = { -- Deadmines
        { 2741, "Rhahk'Zor" }, { 2742, "Sneed" }, { 3676, "Miner Johnson" }, { 2743, "Gilnid" },
        { 2744, "Captain Greenskin" }, { 2745, "Mr. Smite" }, { 2746, "Cookie" }, { 2747, "Edwin VanCleef" },
    },
    [43] = { -- Wailing Caverns
        { 585, "Lady Anacondra" }, { 586, "Lord Cobrahn" }, { 587, "Kresh" }, { 588, "Lord Pythas" },
        { 589, "Skum" }, { 590, "Lord Serpentis" }, { 591, "Verdan the Everliving" },
        { 592, "Mutanus the Devourer" },
    },
    [47] = { -- Razorfen Kraul
        { 2773, "Roogug" }, { 2774, "Aggem Thorncurse" }, { 2775, "Death Speaker Jargba" },
        { 2776, "Overlord Ramtusk" }, { 2777, "Agathelos the Raging" }, { 2778, "Charlga Razorflank" },
    },
    [48] = { -- Blackfathom Deeps
        { 2916, "Ghamoo-ra" }, { 2915, "Lady Sarevess" }, { 2914, "Geilhast" }, { 2913, "Lorgus Jett" },
        { 2912, "Old Serra'kis" }, { 2911, "Twilight Lord Kelris" }, { 2910, "Aku'mai" },
    },
    [70] = { -- Uldaman
        { 547, "Revelosh" }, { 548, "The Lost Dwarves" }, { 549, "Ironaya" }, { 1887, "Obsidian Sentinel" },
        { 551, "Ancient Stone Keeper" }, { 552, "Galgann Firehammer" }, { 553, "Grimlok" },
        { 554, "Archaedas" },
    },
    [90] = { -- Gnomeregan
        { 2768, "Grubbis" }, { 2769, "Viscous Fallout" }, { 2770, "Electrocutioner 6000" },
        { 2771, "Crowd Pummeler 9-60" }, { 2772, "Mekgineer Thermaplugg" },
    },
    [109] = { -- Sunken Temple
        { 3582, "Atal'alarion" }, { 3583, "Avatar of Hakkar" }, { 3584, "Shade of Eranikus" },
        { 3585, "Hazzas" }, { 3586, "Morphaz" }, { 3587, "Weaver" }, { 3588, "Dreamscythe" },
        { 3589, "Jammal'an the Prophet" },
    },
    [129] = { -- Razorfen Downs
        { 2780, "Tuten'kash" }, { 2781, "Plaguemaw the Rotting" }, { 2782, "Mordresh Fire Eye" },
        { 2783, "Ragglesnout" }, { 2784, "Glutton" }, { 2785, "Amnennar the Coldbringer" },
    },
    [189] = { -- Scarlet Monastery
        { 444, "Interrogator Vishas" }, { 2779, "Bloodmage Thalnos" }, { 446, "Houndmaster Loksey" },
        { 447, "Arcanist Doan" }, { 448, "Herod" }, { 449, "High Inquisitor Fairbanks" },
        { 450, "High Inquisitor Whitemane" },
    },
    [209] = { -- Zul'Farrak
        { 593, "Hydromancer Velratha" }, { 594, "Gahz'rilla" }, { 595, "Antu'sul" },
        { 596, "Theka the Martyr" }, { 597, "Witch Doctor Zum'rah" }, { 598, "Nekrum Gutchewer" },
        { 599, "Shadowpriest Sezz'ziz" }, { 600, "Chief Ukorz Sandscalp" },
    },
    [229] = { -- Blackrock Spire
        { 267, "Highlord Omokk" }, { 268, "Shadow Hunter Vosh'gajin" }, { 269, "War Master Voone" },
        { 270, "Mother Smolderweb" }, { 271, "Urok Doomhowl" }, { 272, "Quartermaster Zigris" },
        { 274, "Halycon" }, { 273, "Gizrul the Slavener" }, { 275, "Overlord Wyrmthalak" },
        { 3062, "Pyroguard Emberseer" }, { 3063, "Warchief Rend Blackhand" }, { 3068, "The Beast" },
        { 3069, "General Drakkisath" }, { 3070, "Lord Valthalak" },
    },
    [230] = { -- Blackrock Depths
        { 227, "High Interrogator Gerstahn" }, { 228, "Lord Roccor" }, { 229, "Houndmaster Grebmar" },
        { 230, "Ring of Law" }, { 231, "Pyromancer Loregrain" }, { 232, "Lord Incendius" },
        { 233, "Warder Stilgiss" }, { 234, "Fineous Darkvire" }, { 235, "Bael'Gar" },
        { 236, "General Angerforge" }, { 237, "Golem Lord Argelmach" }, { 238, "Hurley Blackbreath" },
        { 239, "Phalanx" }, { 240, "Ribbly Screwspigot" }, { 241, "Plugger Spazzring" },
        { 2791, "The Vault" }, { 242, "Ambassador Flamelash" }, { 243, "The Seven" }, { 244, "Magmus" },
        { 2789, "Princess Moira Bronzebeard" }, { 2790, "Emperor Dagran Thaurissan" },
    },
    [289] = { -- Scholomance
        { 2805, "Kirtonos" }, { 2804, "Jandice Barov" }, { 2811, "Rattlegore" }, { 2809, "Marduk Blackpool" },
        { 2813, "Vectus" }, { 3055, "Kormok" }, { 2810, "Ras Frostwhisperer" },
        { 2803, "Instructor Malicia" }, { 2802, "Doctor Theolen Krastinov" }, { 2808, "Lorekeeper Polkelt" },
        { 2812, "The Ravenian" }, { 2807, "Lord Alexei Barov" }, { 2806, "Lady Illucia Barov" },
        { 2801, "Darkmaster Gandling" },
    },
    [329] = { -- Stratholme
        { 473, "Hearthsinger Forresten" }, { 474, "Timmy the Cruel" }, { 476, "Malor the Zealous" },
        { 475, "Cannon Master Willey" }, { 477, "Archivist Galford" }, { 478, "Balnazzar" },
        { 472, "The Unforgiven" }, { 479, "Baroness Anastari" }, { 480, "Nerub'enkan" },
        { 481, "Maleki the Pallid" }, { 482, "Magistrate Barthilas" }, { 483, "Ramstein the Gorger" },
        { 484, "Baron Rivendare" }, { 2795, "Black Guard Swordsmith" }, { 2796, "Crimson Hammersmith" },
        { 2797, "Ezra Grimm" }, { 2798, "Postmaster Malown" }, { 2799, "Skul" }, { 2800, "Stonespine" },
    },
    [349] = { -- Maraudon
        { 422, "Noxxion" }, { 423, "Razorlash" }, { 427, "Tinkerer Gizlock" }, { 424, "Lord Vyletongue" },
        { 425, "Celebras the Cursed" }, { 426, "Landslide" }, { 428, "Rotgrip" },
        { 429, "Princess Theradras" },
    },
    [389] = { -- Ragefire Chasm
        { 2732, "Oggleflint" }, { 2733, "Taragaman the Hungerer" }, { 2734, "Jergosh the Invoker" },
        { 2735, "Bazzalan" },
    },
    [429] = { -- Dire Maul
        { 343, "Zevrim Thornhoof" }, { 344, "Hydrospawn" }, { 345, "Lethtendris" }, { 2792, "Pusillin" },
        { 346, "Alzzin the Wildshaper" }, { 350, "Tendris Warpwood" }, { 347, "Illyanna Ravenoak" },
        { 348, "Magister Kalendris" }, { 349, "Immol'thar" }, { 361, "Prince Tortheldrin" },
        { 362, "Guard Mol'dar" }, { 363, "Stomper Kreeg" }, { 364, "Guard Fengus" },
        { 365, "Guard Slip'kik" }, { 366, "Captain Kromcrush" }, { 367, "Cho'Rush the Observer" },
        { 368, "King Gordok" }, { 2793, "Lord Hel'nurath" }, { 2794, "Tsu'zee" },
    },
    [2720] = { -- The Searing Basin
        { 3025, "Testwerk" },
    },
    [2784] = { -- Demon Fall Canyon
        { 3023, "Grimroot" }, { 3028, "Destructor's Wraith" }, { 3029, "Zilbagob" }, { 3030, "Pyranis" },
        { 3024, "Diathorus the Seeker" }, { 3031, "Hellscream's Phantom" }, { 3080, "Azgaloth" },
    },
    [2875] = { -- Karazhan Crypts
        { 3141, "Harbinger of Sin" }, { 3146, "Creeping Malison" }, { 3144, "Three Little Wolves" },
        { 3145, "Dark Rider" }, { 3143, "Kharon" }, { 3152, "Unk'omon" }, { 3168, "Hans and Greta" },
        { 3169, "The Ugly Goblin" }, { 3170, "Kaigy Maryla" }, { 3171, "Sairuh Maryla" },
        { 3172, "Barian Maryla" },
    },
    [2921] = { -- Naxxramas
        { 3296, "Spirit of Mograine" },
    },
    [2959] = { -- City of Dalaran
        { 3298, "Arcane Anomaly" }, { 3299, "Fel Ancient" }, { 3300, "Mana Devourer" },
        { 3301, "Mana Elemental" }, { 3302, "Unstable Sentinel" }, { 3310, "Lyn the Ignored" },
        { 3311, "Atrexis the Grave Knight" }, { 3312, "Mana Wraith" }, { 3303, "Shade of the Archmage" },
    },
    [2998] = { -- Excavation Site: Wetlands
        { 3480, "Saltspine" }, { 3481, "Shadetooth" }, { 3644, "Highland Horror" },
        { 3482, "Relic Guardian" },
    },
    [2999] = { -- Ruins of Lordaeron
        { 3353, "Witherfang" }, { 3357, "The Abandoned" }, { 3355, "The Butcher" },
        { 3408, "Lordaeron Captain" }, { 3411, "Viktor the Vile" }, { 3412, "Bjork" }, { 3354, "Rath'mael" },
    },
    [3065] = { -- The Hall of Thanes
        { 3493, "Faldrim Anvilmar" }, { 3495, "Infurnus" }, { 3494, "Plunder" },
        { 3496, "Durgen Dirgehammer" },
    },
}
-- Scarlet Monastery, Blackrock Spire and Dire Maul hold their wings under one
-- map ID, and Forever's client has no sub-zone or UI map data inside them, so
-- the wing is learnt from its bosses: an encounter ID (start, kill, saved
-- state) or the creature ID of a boss seen on a nameplate, target, mouseover or
-- boss frame. Until then every wing is listed under its own heading. Scarlet
-- Monastery's wings are separate instances: meeting another wing starts a new
-- run. Summoned or rare encounters outside the wings (Lord Hel'nurath, Tsu'zee)
-- are added to the list only when killed.
local WINGS = {
    [189] = { separate = true,
        { label = "Graveyard", bosses = { 444, 2779 }, npcs = { 3983, 4543 } },
        { label = "Library", bosses = { 446, 447 }, npcs = { 3974, 6487 } },
        { label = "Armory", bosses = { 448 }, npcs = { 3975 } },
        { label = "Cathedral", bosses = { 449, 450 }, npcs = { 4542, 3976, 3977 } },
    },
    [229] = {
        { label = "Lower Spire", bosses = { 267, 268, 269, 270, 271, 272, 274, 273, 275 },
            npcs = { 9196, 9236, 9237, 10596, 10584, 9736, 10220, 10268, 9568 } },
        { label = "Upper Spire", bosses = { 3062, 3063, 3068, 3069, 3070 },
            npcs = { 9816, 10429, 10339, 10430, 10363, 16042 } },
    },
    [429] = {
        { label = "East", bosses = { 343, 344, 345, 2792, 346 }, npcs = { 11490, 13280, 14327, 14354, 11492 } },
        { label = "West", bosses = { 350, 347, 348, 349, 361 }, npcs = { 11489, 11488, 11487, 11496, 11486 } },
        { label = "North", bosses = { 362, 363, 364, 365, 366, 367, 368 },
            npcs = { 14326, 14322, 14321, 14323, 14325, 14324, 11501 } },
    },
}
for _, wings in pairs(WINGS) do
    wings.wingOf, wings.npcOf = {}, {}
    for index, wing in ipairs(wings) do
        for _, id in ipairs(wing.bosses) do wings.wingOf[id] = index end
        for _, id in ipairs(wing.npcs) do wings.npcOf[id] = index end
    end
end
-- Wing names have their own locale keys: "Armory" and "Cathedral" already
-- name other things in the shared tables.
local function WingName(label)
    local key = "Dungeon wing: " .. label
    local value = L(key)
    return value ~= key and value or label
end
local function StaticBossList(mapID)
    local bosses = {}
    local wings = mapID and WINGS[mapID]
    for _, entry in ipairs(mapID and DUNGEON_BOSSES[mapID] or {}) do
        local wing = wings and wings.wingOf[entry[1]]
        if wing or not wings then
            bosses[#bosses + 1] = { id = entry[1], name = entry[2], known = true, wing = wing }
        end
    end
    return bosses
end
-- A boss counts toward the total when its wing is known to be in this run.
local function Counts(boss)
    return boss.known and (not boss.wing or (run.wings and run.wings[boss.wing])) and true or false
end
local function UpdateTotal()
    local total = 0
    for _, boss in ipairs(run.bosses or {}) do
        if Counts(boss) then total = total + 1 end
    end
    run.total = total
end
-- With a total, only the bosses it counts: a rare killed on the side does not
-- read as 6 / 5.
local function BossCount()
    local killed = 0
    local counted = run and (run.total or 0) > 0
    for _, boss in ipairs(run and run.bosses or {}) do
        if boss.killed and (not counted or Counts(boss)) then killed = killed + 1 end
    end
    return killed
end
-- Records that the run is in this wing. Returns true when that is news.
local function MarkWing(index)
    local wings = run and run.mapID and WINGS[run.mapID]
    if not (wings and wings[index]) then return false end
    run.wings = run.wings or {}
    if run.wings[index] then return false end
    if wings.separate and next(run.wings) then
        -- Another Scarlet Monastery wing is another instance: start over.
        local bosses = {}
        for _, boss in ipairs(run.bosses or {}) do
            if boss.known then boss.killed, boss.at = nil, nil; bosses[#bosses + 1] = boss end
        end
        run.bosses, run.wings = bosses, {}
        run.started, run.elapsed, run.deaths, run.completed = Now(), 0, 0, false
        run.clockStart, run.clockEnd, run.xp, run.money, run.questXP, run.rares = nil, nil, 0, 0, 0, {}
        run.savedAt, run.savedXP, run.savedMoney = nil, nil, nil
        run.joinedLate = nil
    end
    run.wings[index] = true
    UpdateTotal()
    return true
end
-- A boss keeps the time of its first kill: the kill and boss events of one
-- fight arrive one after the other.
local function Killed(boss)
    if boss.wing then MarkWing(boss.wing) end
    boss.killed = true
    boss.at = boss.at or Now()
end
local function ReadBossList(mapID)
    local bosses = {}
    -- The journal is optional on Forever. No UI selection or loading is needed.
    if not EJ_GetEncounterInfoByIndex then return StaticBossList(mapID) end
    local journal = JournalInstance(mapID)
    if not journal then return StaticBossList(mapID) end
    -- Passing a journal instance only works after EJ_SelectInstance has run
    -- once this session. Leave an open Adventure Guide on its own page.
    local guide = _G.EncounterJournal
    if EJ_SelectInstance and not (guide and guide.IsShown and guide:IsShown()) then
        pcall(EJ_SelectInstance, journal)
    end
    for i = 1, 15 do
        local found, name, _, _, _, _, _, encounterID = pcall(EJ_GetEncounterInfoByIndex, i, journal)
        name = found and Plain(name)
        if type(name) ~= "string" or name == "" then break end
        bosses[#bosses + 1] = { name = name, id = Plain(encounterID), known = true }
    end
    if #bosses == 0 then return StaticBossList(mapID) end
    local wings = mapID and WINGS[mapID]
    for _, boss in ipairs(bosses) do boss.wing = wings and boss.id and wings.wingOf[boss.id] end
    return bosses
end
local function UnitValue(fn, unit)
    if type(fn) ~= "function" then return nil end
    local ok, value = pcall(fn, unit)
    if ok then return Plain(value) end
end
local function Shows(key) return Config()[key] ~= false end
-- The boss portrait: a display read from the boss itself wins, then the
-- static table (Enhancements_ForeverDungeonBossDisplays.lua), then the sample
-- display of a test run.
local function BossDisplay(boss)
    local key = boss.id or boss.name
    local learned = Config().bossDisplays
    local static = ns.ForeverBossDisplays
    return (learned and key and learned[key]) or (boss.id and static and static[boss.id]) or boss.display
end
-- A listed boss seen alive or dead: remember its display. Returns true when
-- that is news.
local function SeeBossPortrait(unit)
    if not (run and run.bosses and unit and KT.BossPortrait) then return false end
    local name = UnitValue(UnitName, unit)
    if type(name) ~= "string" or name == "" then return false end
    for _, boss in ipairs(run.bosses) do
        local key = boss.id or boss.name
        if boss.name == name and key then
            local config = Config()
            if config.bossDisplays and config.bossDisplays[key] then return false end
            local display = KT.BossPortrait.DisplayFromUnit(unit)
            if not display then return false end
            config.bossDisplays = config.bossDisplays or {}
            config.bossDisplays[key] = display
            return true
        end
    end
    return false
end
local function InCombat() return type(InCombatLockdown) == "function" and InCombatLockdown() and true or false end
local CHECK = "|TInterface\\RaidFrame\\ReadyCheck-Ready:12|t"
local SKULL = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_8:12|t"
-- The run clock starts with the first fight inside, so buffing at the door is
-- not counted, and stops when the last boss dies. It keeps running during a
-- corpse run or a trip outside: that time is part of the run.
local function Clock(seconds)
    seconds = math.max(0, math.floor(seconds or 0))
    local hours, minutes = math.floor(seconds / 3600), math.floor(seconds % 3600 / 60)
    if hours > 0 then return string.format("%d:%02d:%02d", hours, minutes, seconds % 60) end
    return string.format("%d:%02d", minutes, seconds % 60)
end
local function RunTime()
    if not (run and run.clockStart) then return 0 end
    return math.max(0, (run.clockEnd or Now()) - run.clockStart)
end
local function StartClock()
    if run and not run.clockStart and not run.completed then run.clockStart = Now() end
end
local function Thousands(value)
    value = math.floor(value or 0)
    if type(BreakUpLargeNumbers) == "function" then
        local ok, text = pcall(BreakUpLargeNumbers, value)
        if ok and type(text) == "string" then return text end
    end
    local text = tostring(value):reverse():gsub("(%d%d%d)", "%1,"):reverse()
    return (text:gsub("^,", ""))
end
local GOLD_COIN = "|TInterface\\MoneyFrame\\UI-GoldIcon:0:0:2:0|t"
local SILVER_COIN = "|TInterface\\MoneyFrame\\UI-SilverIcon:0:0:2:0|t"
local COPPER_COIN = "|TInterface\\MoneyFrame\\UI-CopperIcon:0:0:2:0|t"
-- Gold and silver from one gold up; below that, silver and copper.
local function Coins(copper)
    copper = math.max(0, math.floor(copper or 0))
    local gold, silver = math.floor(copper / 10000), math.floor(copper % 10000 / 100)
    if gold > 0 then return Thousands(gold) .. GOLD_COIN .. " " .. silver .. SILVER_COIN end
    if silver > 0 then return silver .. SILVER_COIN .. " " .. copper % 100 .. COPPER_COIN end
    return copper .. COPPER_COIN
end
-- XP and money are read as changes of the player's totals while inside the
-- run. The XP of quests handed in there is taken off (the row says mobs); the
-- gold is all the money earned, quests included. Money that changes hands at a
-- vendor or in a trade is left out.
local xpLast, moneyLast, merchantOpen
local function MobsXP() return run and math.max(0, (run.xp or 0) - (run.questXP or 0)) or 0 end
local function Money() return run and math.max(0, run.money or 0) or 0 end
local function AtLevelCap()
    local level = UnitValue(UnitLevel, "player")
    local cap = type(GetMaxPlayerLevel) == "function" and GetMaxPlayerLevel() or MAX_PLAYER_LEVEL
    return type(level) == "number" and type(cap) == "number" and level >= cap
end
local function ReadXP()
    local level, xp, max = UnitValue(UnitLevel, "player"), UnitValue(UnitXP, "player"), UnitValue(UnitXPMax, "player")
    if type(level) ~= "number" or type(xp) ~= "number" or type(max) ~= "number" then return nil end
    return { level = level, xp = xp, max = max }
end
local function ReadMoney()
    if type(GetMoney) ~= "function" then return nil end
    local ok, money = pcall(GetMoney)
    money = ok and Plain(money)
    return type(money) == "number" and money or nil
end
local function TrackXP()
    local current, last = ReadXP(), xpLast
    xpLast = current
    if not (current and last and run and inside) then return false end
    local gained = current.xp - last.xp
    -- A level gained: the rest of the old level plus the new XP.
    if current.level > last.level or gained < 0 then gained = (last.max - last.xp) + current.xp end
    if gained <= 0 then return false end
    run.xp = (run.xp or 0) + gained
    return true
end
local function TrackMoney()
    local current, last = ReadMoney(), moneyLast
    moneyLast = current
    if not (current and last and run and inside) or merchantOpen or current <= last then return false end
    run.money = (run.money or 0) + (current - last)
    return true
end
-- WoW writes addon data to disk only on a reload or a logout, so a crash takes
-- the tracker back to the last of those: to no run at all when the dungeon was
-- entered after it. The tracker therefore offers one reload at the door. The
-- saved run keeps when it was saved and the XP and money of that moment, and
-- after a crash the rest follows from them (see RestoreAfterLoad).
local pendingRestore
local function MarkSaved()
    local saved = Config().dungeonRun
    if not saved then return end
    if inside then
        saved.savedAt = saved.savedAt or Now()
        saved.savedXP, saved.savedMoney = xpLast, moneyLast
    else
        saved.savedXP, saved.savedMoney = nil, nil
    end
end
local function NeedsSave()
    return inside and not testing and Shows("showSave") and not run.completed and not run.clockStart and not run.savedAt
end
-- The first time the player stands in the saved run after loading. After a
-- login (a crash, a disconnect) a run saved before its first fight counts from
-- the save, the closest moment known; a plain reload keeps waiting for a fight.
local function RestoreAfterLoad()
    local how = pendingRestore
    if not how then return end
    pendingRestore = nil
    if how == "login" and run.savedAt and not run.clockStart and not run.completed then run.clockStart = run.savedAt end
    local xp, money, last = ReadXP(), ReadMoney(), run.savedXP
    if xp and last and xp.max > 0 then
        local gained = xp.xp - last.xp
        if xp.level > last.level then gained = (last.max - last.xp) + xp.xp end
        if gained > 0 then run.xp = (run.xp or 0) + gained end
        xpLast = xp
    end
    if money and run.savedMoney then
        if money > run.savedMoney then run.money = (run.money or 0) + (money - run.savedMoney) end
        moneyLast = money
    end
    run.savedXP, run.savedMoney = nil, nil
end
-- Rares need no list: a unit the client marks rare or rare elite inside the
-- run is added the first time it is seen, alive or dead. One found alive
-- pulses and chimes (at once, then 4, 8 and 16 seconds later) until it is
-- clicked (target and skull) or killed.
local RARE_CHIMES = { 4, 8, 16 }
local function NpcID(guid)
    if type(guid) ~= "string" then return nil end
    return tonumber(guid:match("^Creature%-%d+%-%d+%-%d+%-%d+%-(%d+)") or guid:match("^Vehicle%-%d+%-%d+%-%d+%-%d+%-(%d+)"))
end
local function FindRare(name, npc)
    for _, rare in ipairs(run and run.rares or {}) do
        if (npc and rare.npc == npc) or rare.name == name then return rare end
    end
end
local function Chime(rare)
    if Config().rareSound == false or rare.killed or rare.ack or FindRare(rare.name, rare.npc) ~= rare then return end
    if type(PlaySound) == "function" then
        pcall(PlaySound, SOUNDKIT and SOUNDKIT.RAID_WARNING or 8959, "Master")
    end
end
local function AnnounceRare(rare)
    if Config().rareSound ~= false then KT:Print(string.format(L("Rare found: %s"), rare.name)) end
    Chime(rare)
    if C_Timer and C_Timer.After then
        for _, delay in ipairs(RARE_CHIMES) do C_Timer.After(delay, function() Chime(rare) end) end
    end
end
local function SeeRare(unit)
    if not (run and inside and unit) then return false end
    local class = UnitValue(UnitClassification, unit)
    if class ~= "rare" and class ~= "rareelite" then return false end
    if UnitValue(UnitPlayerControlled, unit) then return false end
    local name = UnitValue(UnitName, unit)
    if type(name) ~= "string" or name == "" then return false end
    -- A listed boss the client also calls rare stays a boss.
    for _, boss in ipairs(run.bosses or {}) do
        if boss.name == name then return false end
    end
    local npc = NpcID(UnitValue(UnitGUID, unit))
    local corpse = UnitValue(UnitIsDead, unit) and true or false
    local rare = FindRare(name, npc)
    if not rare then
        rare = { name = name, npc = npc, seen = Now() }
        run.rares = run.rares or {}
        run.rares[#run.rares + 1] = rare
        if corpse then rare.killed = true else AnnounceRare(rare) end
        return true
    end
    if corpse and not rare.killed then rare.killed = true; return true end
    return false
end
local SAVE_TIP = "Save this run: reloads the UI, so a crash or a closed game no longer restarts the timer"
local function Build()
    if frame then return frame end
    frame = CreateFrame("Frame", "KullThranUIForeverDungeonTracker", UIParent, "BackdropTemplate")
    frame:SetFrameStrata("MEDIUM")
    frame:SetSize(271, 150)
    KT:AddBackdrop(frame, 0, 0, 0, 0)
    local function Text(size)
        local text = frame:CreateFontString(nil, "OVERLAY")
        text:SetFont(KT.FONT_PATH or "Fonts\\FRIZQT__.TTF", size, "OUTLINE")
        text:SetJustifyH("RIGHT")
        return text
    end
    frame.title, frame.timer, frame.details = Text(16), Text(26), Text(13)
    frame.stats, frame.money = Text(13), Text(13)
    frame.progressText, frame.saveText = Text(13), Text(13)
    frame.progress = CreateFrame("StatusBar", nil, frame)
    frame.progress:SetStatusBarTexture("Interface\\AddOns\\KullThranUI\\Libraries\\texture\\Melli.tga")
    frame.progress:SetMinMaxValues(0, 1)
    frame.objectives = {}
    -- Blackrock Depths lists 21 bosses; Dire Maul, before its wing is known,
    -- 17 bosses under three wing headings, plus two side encounters. Rares
    -- found on the way go under their own heading.
    for i = 1, 32 do
        local text = Text(12)
        local pulse = text:CreateAnimationGroup()
        pulse:SetLooping("BOUNCE")
        local fade = pulse:CreateAnimation("Alpha")
        fade:SetFromAlpha(1)
        fade:SetToAlpha(0.35)
        fade:SetDuration(0.6)
        text.pulse = pulse
        frame.objectives[i] = text
    end
    -- A small round portrait to the right of each boss name.
    frame.portraits = {}
    if KT.BossPortrait then
        for i = 1, #frame.objectives do frame.portraits[i] = KT.BossPortrait.Create(frame) end
    end
    frame.targets = {}
    -- The title row takes the mouse: right-click opens the options, and the
    -- hide and restart buttons show while the mouse is on it.
    local header = CreateFrame("Button", nil, frame)
    header:RegisterForClicks("RightButtonUp")
    local function UpdateControls()
        local over = header:IsMouseOver() or frame.close:IsMouseOver() or frame.restart:IsMouseOver()
            or frame.save:IsMouseOver()
        frame.close:SetShown(over and true or false)
        frame.restart:SetShown(over and not testing and true or false)
        frame.save:SetShown(over and not testing and true or false)
    end
    local function LeaveSoon()
        if GameTooltip then GameTooltip:Hide() end
        if C_Timer and C_Timer.After then C_Timer.After(0.2, UpdateControls) else UpdateControls() end
    end
    local function Tip(owner, text)
        if not GameTooltip then return end
        GameTooltip:SetOwner(owner, "ANCHOR_LEFT")
        GameTooltip:SetText(text, 1, 1, 1, 1, true)
        GameTooltip:Show()
    end
    header:SetScript("OnEnter", function(self) UpdateControls(); Tip(self, L("Right-click: tracker options")) end)
    header:SetScript("OnLeave", LeaveSoon)
    header:SetScript("OnClick", function(_, button) if button == "RightButton" then Mod:OpenDungeonTrackerOptions() end end)
    frame.header = header
    local function Control(texture, tooltip, onClick)
        local button = CreateFrame("Button", nil, frame)
        button:SetSize(14, 14)
        button:SetFrameLevel(header:GetFrameLevel() + 2)
        button.icon = button:CreateTexture(nil, "ARTWORK")
        button.icon:SetAllPoints()
        button.icon:SetTexture(texture)
        button:SetScript("OnEnter", function(self)
            self.icon:SetVertexColor(KT.C_R or 1, KT.C_G or 0.5, KT.C_B or 0)
            UpdateControls(); Tip(self, L(tooltip))
        end)
        button:SetScript("OnLeave", function(self) self.icon:SetVertexColor(1, 1, 1); LeaveSoon() end)
        button:SetScript("OnClick", onClick)
        button:Hide()
        return button
    end
    frame.close = Control("Interface\\Buttons\\UI-StopButton", "Hide the tracker for this run",
        function() Mod:SetDungeonTrackerHidden(true) end)
    frame.restart = Control("Interface\\Buttons\\UI-RefreshButton", "Restart this dungeon run",
        function() Mod:ConfirmRestartDungeonRun() end)
    frame.save = Control("Interface\\Buttons\\UI-GuildButton-PublicNote-Up", SAVE_TIP,
        function() Mod:SaveDungeonRun() end)
    -- The row offered before the first fight of a run not saved yet.
    local saveRow = CreateFrame("Button", nil, frame)
    saveRow:SetScript("OnEnter", function(self) Tip(self, L(SAVE_TIP)) end)
    saveRow:SetScript("OnLeave", function() if GameTooltip then GameTooltip:Hide() end end)
    saveRow:SetScript("OnClick", function() Mod:SaveDungeonRun() end)
    saveRow:Hide()
    frame.saveRow = saveRow
    frame:Hide()
    Mod.mplusTrackerFrame = frame
    return frame
end
-- Secure click areas over the bosses and rares still alive. They live on
-- UIParent, never on the tracker, and move only out of combat: after a fight
-- they catch up with the tracker.
local targetButtons = {}
local function TargetTooltip(self)
    local entry = self.entry
    if not (entry and GameTooltip) then return end
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    GameTooltip:SetText(entry.name, 1, 1, 1)
    GameTooltip:AddLine(entry.rare and L("Click: target and mark with a skull") or L("Click: target"), 0.75, 0.75, 0.75)
    GameTooltip:Show()
end
local function TargetButton(index)
    local button = targetButtons[index]
    if button then return button end
    button = CreateFrame("Button", "KullThranUIDungeonTarget" .. index, UIParent, "SecureActionButtonTemplate")
    button:RegisterForClicks("LeftButtonDown", "LeftButtonUp")
    button:SetAttribute("type", "macro")
    button:SetScript("OnEnter", TargetTooltip)
    button:SetScript("OnLeave", function() if GameTooltip then GameTooltip:Hide() end end)
    button:HookScript("PostClick", function(self)
        local rare = self.entry and self.entry.rare
        if rare and not rare.ack then rare.ack = true; Save(); Mod:RefreshMythicPlusTracker() end
    end)
    button:Hide()
    targetButtons[index] = button
    return button
end
local function TargetMacro(entry)
    local macro = "/targetexact " .. entry.name
    if entry.rare then
        macro = macro .. string.format("\n/run if UnitName('target')==%q and GetRaidTargetIndex('target')~=8 then SetRaidTarget('target',8) end", entry.name)
    end
    return macro
end
local function LayoutTargets(force)
    if InCombat() then pendingTargets = true; return end
    local list = frame and frame:IsShown() and frame.targets or {}
    local ui = UIParent.GetEffectiveScale and UIParent:GetEffectiveScale() or 1
    local signature = #list .. ":" .. (frame and frame:IsShown() and table.concat({ frame:GetRight() or 0, frame:GetTop() or 0,
        frame:GetEffectiveScale() or 1 }, ":") or "-")
    for _, entry in ipairs(list) do signature = signature .. ":" .. entry.name end
    if not force and not pendingTargets and frame and frame.targetSignature == signature then return end
    pendingTargets = false
    if frame then frame.targetSignature = signature end
    for index, entry in ipairs(list) do
        local button, text = TargetButton(index), entry.text
        local right, top = text:GetRight(), text:GetTop()
        if right and top then
            local scale = (text:GetEffectiveScale() or 1) / ui
            button:ClearAllPoints()
            button:SetPoint("TOPRIGHT", UIParent, "BOTTOMLEFT", right * scale, top * scale)
            button:SetSize(math.max(24, (text:GetStringWidth() or 0) * scale), math.max(10, (text:GetStringHeight() or 12) * scale))
            button:SetFrameStrata(frame:GetFrameStrata())
            button:SetFrameLevel(frame:GetFrameLevel() + 5)
            local macro = TargetMacro(entry)
            if button.macro ~= macro then button:SetAttribute("macrotext", macro); button.macro = macro end
            button.entry = entry
            button:Show()
        else
            button:Hide()
        end
    end
    for index = #list + 1, #targetButtons do targetButtons[index]:Hide() end
end
local function Font(text, config, key, size)
    local path = config[key] or config.globalFont or KT.FONT_PATH
    if path == KT.DEFAULT_FONT_PATH then path = KT.FONT_PATH end
    if KT.ResolveTextFontPath then path = KT:ResolveTextFontPath(path) end
    if not path or (not path:find("\\", 1, true) and not path:find("/", 1, true)) then path = KT.FONT_PATH end
    if not text:SetFont(path or "Fonts\\FRIZQT__.TTF", size, "OUTLINE") then
        text:SetFont("Fonts\\FRIZQT__.TTF", size, "OUTLINE")
    end
end
local function Color(text, value, fallback)
    local c = value or fallback
    text:SetTextColor(c.r, c.g, c.b, c.a or 1)
end
function Mod:ApplyMythicPlusTrackerPosition()
    local f = Build()
    local um = KT:GetModule("UnlockMode", true)
    if um and um.pendingPositions and um.pendingPositions.ENH_MYTHIC_PLUS_TRACKER then return end
    local edit = KT.db.profile.editMode
    local p = edit and edit.frames and edit.frames.ENH_MYTHIC_PLUS_TRACKER or Config().position
    p = p or { point = "RIGHT", x = -16, y = 224 }
    f:ClearAllPoints()
    f:SetPoint(p.point or "RIGHT", UIParent, p.relativePoint or p.point or "RIGHT", p.x or -16, p.y or 224)
end
local function InGroup()
    if type(IsInGroup) == "function" then return IsInGroup() and true or false end
    return type(GetNumGroupMembers) == "function" and (GetNumGroupMembers() or 0) > 0
end
-- Shown inside the dungeon, and outside only during the corpse run of a death
-- in it: the player left the run as a ghost (released inside) less than
-- STALE_RUN_SECONDS ago. Dying anywhere else must not bring back an old run.
local function CorpseRunOutside()
    return ghostOutside and not run.completed and run.leftAsGhost == true
        and run.leftAt and Now() - run.leftAt <= STALE_RUN_SECONDS
end
local function Visible()
    if testing then return run ~= nil end
    local c = Config()
    if not run or c.enabled ~= true or Mod:GetDB().enable == false or run.hidden then return false end
    if not inside and not CorpseRunOutside() then return false end
    if c.showSolo == false and not InGroup() then return false end
    return true
end
local Render
local function Tick(self, elapsed)
    self.tick = (self.tick or 0) + elapsed
    if self.tick < 0.25 then return end
    self.tick = 0
    if run and run.clockStart and not run.clockEnd and self.timer:IsShown() then self.timer:SetText(Clock(RunTime())) end
    if not InCombat() then LayoutTargets() end
end
Render = function()
    local f, c = Build(), Config()
    if not Visible() then
        f:Hide(); f.targets = {}; LayoutTargets()
        return
    end
    f:SetScale(c.scale or 1)
    f:SetWidth(c.barWidth or 271)
    local bg = c.backgroundColor or { r = 0, g = 0, b = 0, a = .7 }
    f:SetBackdropColor(bg.r, bg.g, bg.b, c.showBackground and bg.a or 0)
    local accent = { r = KT.C_R or 1, g = KT.C_G or .5, b = KT.C_B or 0 }
    local white = { r = 1, g = 1, b = 1 }
    local y, width = 8, (c.barWidth or 271) - 16
    local function Row(text, value, fontKey, size, color)
        Font(text, c, fontKey, size)
        Color(text, color, white)
        text:SetText(value)
        text:ClearAllPoints()
        text:SetPoint("TOPRIGHT", f, "TOPRIGHT", -8, -y)
        text:SetWidth(width)
        text:Show()
        y = y + size + 5
    end
    local titleSize = c.keyFontSize or 16
    f.header:ClearAllPoints()
    f.header:SetPoint("TOPLEFT", f, "TOPLEFT", 0, -y + 4)
    f.header:SetPoint("TOPRIGHT", f, "TOPRIGHT", 0, -y + 4)
    f.header:SetHeight(titleSize + 8)
    f.close:ClearAllPoints()
    f.close:SetPoint("TOPLEFT", f, "TOPLEFT", 8, -y)
    f.restart:ClearAllPoints()
    f.restart:SetPoint("LEFT", f.close, "RIGHT", 4, 0)
    f.save:ClearAllPoints()
    f.save:SetPoint("LEFT", f.restart, "RIGHT", 4, 0)
    Row(f.title, run.name or L("Dungeon"), "keyFont", titleSize, c.keyColor or accent)
    if Shows("showTime") then
        Row(f.timer, Clock(RunTime()), "timerFont", c.timerFontSize or 26, run.completed
            and (c.timerSuccessColor or { r = 0.118, g = 1, b = 0.714 }) or (c.timerRunningColor or white))
    else
        f.timer:Hide()
    end
    if NeedsSave() then
        local size, top = c.keyDetailsFontSize or 13, y
        Row(f.saveText, L("Click to save this run"), "keyDetailsFont", size, accent)
        f.saveRow:ClearAllPoints()
        f.saveRow:SetPoint("TOPRIGHT", f, "TOPRIGHT", -8, -top)
        f.saveRow:SetSize(width, size + 3)
        f.saveRow:Show()
    else
        f.saveText:Hide()
        f.saveRow:Hide()
    end
    Row(f.details, (run.completed and L("Dungeon Completed") or (run.difficultyName or L("Normal"))) .. "  |  "
        .. string.format(L("%d Deaths"), run.deaths or 0),
        "keyDetailsFont", c.keyDetailsFontSize or 13, c.keyDetailsColor)
    if Shows("showXP") and not AtLevelCap() then
        Row(f.stats, string.format(L("Mobs XP: %s"), Thousands(MobsXP())),
            "keyDetailsFont", c.keyDetailsFontSize or 13, c.keyDetailsColor)
    else
        f.stats:Hide()
    end
    if Shows("showGold") then
        Row(f.money, string.format(L("Gold: %s"), Coins(Money())),
            "keyDetailsFont", c.keyDetailsFontSize or 13, c.keyDetailsColor)
    else
        f.money:Hide()
    end
    local killed, total = BossCount(), run.total or 0
    Row(f.progressText, total > 0 and string.format(L("Bosses: %d / %d"), killed, total)
        or string.format(L("Bosses defeated: %d"), killed), "forcesFont", c.forcesFontSize or 13, c.forcesColor)
    f.progress:ClearAllPoints()
    f.progress:SetPoint("TOPLEFT", f, "TOPLEFT", 8, -y)
    f.progress:SetSize(width, c.barHeight or 10)
    local pc = c.forcesBarColor or accent
    f.progress:SetStatusBarColor(pc.r, pc.g, pc.b, pc.a or 1)
    f.progress:SetValue(total > 0 and math.min(1, killed / total) or 0)
    f.progress:SetShown(total > 0)
    if total > 0 then y = y + (c.barHeight or 10) + 8 end
    -- Multi-wing maps list each wing that may be this run under its heading:
    -- every wing until one is known, then only the known ones.
    local lines = {}
    local wings = run.mapID and WINGS[run.mapID]
    if not Shows("showBosses") then
        -- Hidden in the options: the count and bar stay.
    elseif wings then
        local known = run.wings and next(run.wings) ~= nil
        for index, wing in ipairs(wings) do
            if not known or run.wings[index] then
                lines[#lines + 1] = { heading = WingName(wing.label) }
                for _, boss in ipairs(run.bosses) do
                    if boss.wing == index then lines[#lines + 1] = boss end
                end
            end
        end
        for _, boss in ipairs(run.bosses) do
            if not boss.wing then lines[#lines + 1] = boss end
        end
    else
        for _, boss in ipairs(run.bosses) do lines[#lines + 1] = boss end
    end
    if Shows("showRares") and run.rares and #run.rares > 0 then
        lines[#lines + 1] = { heading = L("Rares") }
        for _, rare in ipairs(run.rares) do lines[#lines + 1] = { rare = rare } end
    end
    local targets = {}
    local size = c.objectivesFontSize or 12
    for i, text in ipairs(f.objectives) do
        local line, glow = lines[i], false
        local portrait = f.portraits[i]
        if portrait then portrait:Hide() end
        if line and line.heading then
            Row(text, line.heading, "objectivesFont", size, c.keyColor or accent)
        elseif line and line.rare then
            local rare = line.rare
            glow = not rare.killed and not rare.ack
            Row(text, (rare.killed and CHECK or SKULL) .. " " .. rare.name, "objectivesFont", size,
                rare.killed and c.completedObjectivesColor or (glow and (c.keyColor or accent)) or c.objectivesColor)
            if not rare.killed then targets[#targets + 1] = { text = text, name = rare.name, rare = rare } end
        elseif line then
            -- A killed boss shows its time into the run, as on the Mythic+ tracker.
            local split = line.killed and line.at and run.clockStart and math.max(0, line.at - run.clockStart)
            Row(text, (line.killed and CHECK .. " " or "") .. (line.label and L(line.label) or line.name)
                .. (split and " (" .. Clock(split) .. ")" or ""),
                "objectivesFont", size, line.killed and c.completedObjectivesColor or c.objectivesColor)
            if portrait then
                -- The portrait takes the right edge; the name moves left of it.
                local top, psize = y - size - 5, size + 3
                KT.BossPortrait.Set(portrait, BossDisplay(line), line.killed, psize)
                portrait:ClearAllPoints()
                portrait:SetPoint("TOPRIGHT", f, "TOPRIGHT", -8, -top + 2)
                text:ClearAllPoints()
                text:SetPoint("TOPRIGHT", f, "TOPRIGHT", -12 - psize, -top)
                text:SetWidth(width - psize - 4)
            end
            if not line.killed and line.name and not line.label then targets[#targets + 1] = { text = text, name = line.name } end
        else
            text:Hide()
        end
        if glow then
            if not text.pulse:IsPlaying() then text.pulse:Play() end
        elseif text.pulse:IsPlaying() then
            text.pulse:Stop()
        end
    end
    f:SetHeight(math.max(100, y + 4))
    Mod:ApplyMythicPlusTrackerPosition()
    f:SetScript("OnUpdate", Tick)
    f:Show()
    f.targets = testing and {} or targets
    LayoutTargets(true)
end
-- Completed dungeons per character, for the Armory's Progress page:
-- db.global.foreverDungeons[guid][dungeon] = { name, mapID, wings, runs, best, last }.
-- A wing counts as a dungeon of its own. Runs joined late keep no best time.
local function RecordCompletion()
    local db = KT.db
    local owner = run.owner or Plain(UnitGUID("player"))
    if testing or not db or not owner or not run.mapID or BossCount() == 0 then return end
    local wingKeys = {}
    for index = 1, #(WINGS[run.mapID] or {}) do
        if run.wings and run.wings[index] then wingKeys[#wingKeys + 1] = index end
    end
    db.global = db.global or {}
    db.global.foreverDungeons = db.global.foreverDungeons or {}
    local records = db.global.foreverDungeons
    records[owner] = records[owner] or {}
    local key = tostring(run.mapID) .. (#wingKeys > 0 and (":" .. table.concat(wingKeys, "+")) or "")
    local record = records[owner][key] or { mapID = run.mapID, runs = 0 }
    records[owner][key] = record
    record.name = run.name or record.name
    record.wings = #wingKeys > 0 and wingKeys or nil
    record.runs = (tonumber(record.runs) or 0) + 1
    record.last = Now()
    local duration = RunTime()
    if not run.joinedLate and duration > 0 and (not record.best or duration < record.best) then record.best = duration end
end
-- The completed dungeons of this character, the latest first.
function Mod:GetForeverDungeonRecords()
    local all = KT.db and KT.db.global and KT.db.global.foreverDungeons
    local list = {}
    for _, record in pairs(type(all) == "table" and all[Plain(UnitGUID("player")) or ""] or {}) do
        local name = record.name or "?"
        local names = {}
        for _, index in ipairs(record.wings or {}) do
            local wing = WINGS[record.mapID] and WINGS[record.mapID][index]
            if wing then names[#names + 1] = WingName(wing.label) end
        end
        if #names > 0 then name = name .. ": " .. table.concat(names, ", ") end
        list[#list + 1] = { name = name, runs = record.runs or 0, best = record.best, last = record.last or 0 }
    end
    table.sort(list, function(a, b)
        if a.last == b.last then return a.name < b.name end
        return a.last > b.last
    end)
    return list
end
-- byHand: Finish Dungeon Run. With bosses of a known list still alive it only
-- stops the clock; the dungeon was not completed.
local function Finish(byHand)
    if not run or run.completed then return end
    run.elapsed = Elapsed(); run.started = nil; run.completed = true
    if run.clockStart and not run.clockEnd then run.clockEnd = Now() end
    if not (byHand and (run.total or 0) > 0 and BossCount() < run.total) then RecordCompletion() end
    Save()
end
local function Pause()
    if run and run.started then run.elapsed = Elapsed(); run.started = nil; Save() end
end
local function NewRun(name, mapID, difficulty, difficultyName, owner)
    run = { mapID = mapID, difficulty = difficulty, difficultyName = difficultyName,
        name = name, owner = owner, started = Now(), enteredAt = Now(), elapsed = 0, deaths = 0,
        bosses = ReadBossList(mapID), completed = false, wings = mapID and WINGS[mapID] and {} or nil,
        xp = 0, money = 0, rares = {} }
    UpdateTotal()
    dead = {}
    for unit in pairs(GROUP_UNITS) do
        local guid = Plain(UnitGUID(unit))
        if guid and Plain(UnitIsDeadOrGhost(unit)) then dead[guid] = true end
    end
    run.dead = dead
    return run
end
local function Positive(value) return type(value) == "number" and value > 0 end
-- Why the last run was replaced by a new one, kept in the saved variables so
-- an unexpected restart (after a wipe, say) can be traced afterwards.
local function NoteNewRun(reason, old, mapID, difficulty)
    if testing or not old then return end
    Config().lastNewRun = {
        reason = reason, at = Now(), name = old.name, inside = inside == true,
        oldMap = old.mapID, newMap = mapID, oldDifficulty = old.difficulty, newDifficulty = difficulty,
        leftAt = old.leftAt, enteredAt = old.enteredAt, completed = old.completed == true,
    }
end
local function Sync()
    if testing then Render(); return end
    local config = Config()
    if activeConfig ~= config then run = config.dungeonRun; activeConfig = config; dead = run and run.dead or {} end
    if config.enabled ~= true or Mod:GetDB().enable == false then inside = false; Pause(); Render(); return end
    local name, kind, difficulty, difficultyName, _, _, _, mapID = GetInstanceInfo()
    name, kind, difficulty, difficultyName, mapID = Plain(name), Plain(kind), Plain(difficulty), Plain(difficultyName), Plain(mapID)
    local owner = Plain(UnitGUID("player"))
    -- Every five-player dungeon difficulty counts, keystone runs included.
    if kind ~= "party" then
        -- Remember when the dungeon was left: a run finished before, or left
        -- long ago, is not the one the player walks back into.
        inside = false
        ghostOutside = UnitValue(UnitIsGhost, "player") == true
        if run and not run.leftAt then
            run.leftAt = Now()
            -- Releasing inside puts the ghost at a graveyard outside.
            run.leftAsGhost = (ghostOutside or UnitValue(UnitIsDeadOrGhost, "player") == true) or nil
        end
        Pause(); Render(); return
    end
    -- Right after a loading screen (a ghost walking back in after a wipe) the
    -- instance info can come without a map ID: wait for the delayed Sync
    -- instead of taking it for another dungeon.
    if not mapID or mapID == 0 then Render(); return end
    inside, ghostOutside = true, false
    if not run then run = Config().dungeonRun end
    local stale = run and run.leftAt and (run.completed or Now() - run.leftAt > STALE_RUN_SECONDS)
    local returning = run and run.leftAt
    -- A difficulty (or a character) missing on either side is not a different one.
    local otherDifficulty = run and Positive(run.difficulty) and Positive(difficulty) and run.difficulty ~= difficulty
    local reason = not run and "none" or stale and "stale" or run.mapID ~= mapID and "map"
        or otherDifficulty and "difficulty" or run.owner and owner and run.owner ~= owner and "owner" or nil
    if reason then
        NoteNewRun(reason, run, mapID, difficulty)
        NewRun(name, mapID, difficulty, difficultyName, owner)
    else
        run.leftAt, run.leftAsGhost = nil, nil
        if not Positive(run.difficulty) and Positive(difficulty) then
            run.difficulty, run.difficultyName = difficulty, difficultyName or run.difficultyName
        end
        if returning then run.enteredAt = Now() end
        if not run.started and not run.completed then run.started = Now() end
        local listed = false
        for _, boss in ipairs(run.bosses or {}) do
            if boss.known then listed = true; break end
        end
        if not listed and not run.completed then
            -- The journal may not be ready on the first loading screen.
            local bosses = ReadBossList(mapID)
            if #bosses > 0 then
                for _, seen in ipairs(run.bosses or {}) do
                    for _, boss in ipairs(bosses) do
                        if (seen.id and seen.id == boss.id) or seen.name == boss.name then
                            boss.killed, boss.at = seen.killed, seen.at
                        end
                    end
                end
                run.bosses = bosses
                run.wings = run.wings or (mapID and WINGS[mapID] and {}) or nil
                for _, boss in ipairs(bosses) do
                    if boss.killed and boss.wing then run.wings[boss.wing] = true end
                end
                UpdateTotal()
            end
        end
    end
    xpLast = xpLast or ReadXP()
    moneyLast = moneyLast or ReadMoney()
    RestoreAfterLoad()
    Save(); Render()
end
local function CheckComplete()
    local knownKilled = 0
    for _, boss in ipairs(run.bosses) do if boss.killed and Counts(boss) then knownKilled = knownKilled + 1 end end
    if run.total > 0 and knownKilled == run.total then Finish() end
end
local function FindBoss(id, name)
    for _, boss in ipairs(run.bosses) do
        if (id and boss.id == id) or (name and boss.name == name) then return boss end
    end
end
local function RecordKill(id, name)
    id, name = Plain(id), Plain(name)
    local found = FindBoss(id, name)
    -- A boss that dies again after the player left and came back means the
    -- dungeon was reset (by a leader whose reset message nobody else gets):
    -- that kill opens a new run.
    if found and found.killed and found.at and run.enteredAt and found.at < run.enteredAt and run.mapID then
        local old = run
        NoteNewRun("boss killed again", old, old.mapID, old.difficulty)
        NewRun(old.name, old.mapID, old.difficulty, old.difficultyName, old.owner)
        found = FindBoss(id, name)
    end
    if not found then
        found = { id = id, name = name, label = not name and "Boss" or nil }
        run.bosses[#run.bosses + 1] = found
    end
    -- The kill event names the boss in the client's language.
    if name and found.id and found.id == id then found.name = name end
    StartClock()
    Killed(found)
    CheckComplete()
end
-- The kill events only reach players inside the instance. A boss killed while
-- the player was out (released after dying, a disconnect, a trip outside) is
-- read back from the instance's encounter state when the player returns.
local function ReconcileKills()
    if not (run and run.started and not run.completed and run.mapID) then return false end
    local isComplete = C_RaidLocks and C_RaidLocks.IsEncounterComplete
    if type(isComplete) ~= "function" then return false end
    local changed = false
    for _, boss in ipairs(run.bosses or {}) do
        if boss.id and not boss.killed then
            local ok, done = pcall(isComplete, run.mapID, boss.id, run.difficulty)
            if ok and Plain(done) == true then Killed(boss); changed = true end
        end
    end
    -- Bosses already dead before the first fight: the group was under way, and
    -- the clock does not tell how long the dungeon took.
    if changed and not run.clockStart then run.joinedLate = true end
    if changed then CheckComplete() end
    return changed
end
-- A boss corpse seen as target, focus, mouseover or boss frame also counts:
-- it covers kills whose encounter event never reached the player.
local BOSS_UNITS = { target = true, focus = true, mouseover = true,
    boss1 = true, boss2 = true, boss3 = true, boss4 = true, boss5 = true }
local function DeadBossName(unit)
    if not UnitValue(UnitIsDead, unit) then return nil end
    local class = UnitValue(UnitClassification, unit)
    if not (UnitValue(UnitIsBossMob, unit) or class == "worldboss" or class == "elite" or class == "rareelite") then
        return nil
    end
    local name = UnitValue(UnitName, unit)
    return type(name) == "string" and name ~= "" and name or nil
end
local function RecordBossUnit(unit)
    local name = DeadBossName(unit)
    if not name then return end
    for _, boss in ipairs(run.bosses) do
        if not boss.killed and boss.name == name then
            Killed(boss); CheckComplete(); return
        end
    end
end
-- A boss of a multi-wing map seen alive or dead names the wing. Needs no
-- instance lookup: the run already knows its map.
local function SeeWingUnit(unit)
    local wings = run and run.started and not run.completed and run.mapID and WINGS[run.mapID]
    if not wings or not unit then return false end
    local npc = NpcID(UnitValue(UnitGUID, unit))
    local index = npc and wings.npcOf[npc]
    return index and MarkWing(index) or false
end
local function SeeWingEncounter(id)
    id = Plain(id)
    local wings = run and run.started and not run.completed and run.mapID and WINGS[run.mapID]
    local index = wings and id and wings.wingOf[id]
    return index and MarkWing(index) or false
end
local function RecordHealth(unit)
    local guid = Plain(UnitGUID(unit))
    local killed = Plain(UnitIsDeadOrGhost(unit))
    if not guid or killed == nil then return end
    if killed and not dead[guid] then run.deaths = (run.deaths or 0) + 1 end
    dead[guid] = killed and true or nil
end
-- "<Dungeon> has been reset." reaches only the player who reset it: their
-- unfinished run of that dungeon ends. The others get a new run from the next
-- boss kill (see RecordKill) or from Restart Dungeon Run.
local resetPattern
local function ResetName(message)
    message = Plain(message)
    if type(message) ~= "string" then return nil end
    if resetPattern == nil then
        local text = type(INSTANCE_RESET_SUCCESS) == "string" and INSTANCE_RESET_SUCCESS or nil
        if text then
            text = text:gsub("%%%d?%$?s", "\001"):gsub("[%(%)%.%+%-%*%?%[%]%^%$%%]", "%%%0")
            resetPattern = "^" .. text:gsub("\001", "(.+)") .. "$"
        else
            resetPattern = false
        end
    end
    return resetPattern and message:match(resetPattern) or nil
end
function Mod:FinishDungeonRun()
    if testing then return end
    Finish(true); Render()
end
function Mod:RestartDungeonRun()
    testing = false; simulation = nil; run = nil; Config().dungeonRun = nil; Sync()
end
-- Needs a click or a typed command: the client refuses any other addon reload.
function Mod:SaveDungeonRun()
    if InCombat() then KT:Print(L("The run cannot be saved in combat.")); return end
    if type(ReloadUI) == "function" then ReloadUI() elseif C_UI and C_UI.Reload then C_UI.Reload() end
end
function Mod:ConfirmRestartDungeonRun()
    local dialogs = _G.StaticPopupDialogs
    if not (dialogs and _G.StaticPopup_Show) then self:RestartDungeonRun(); return end
    dialogs.KT_DUNGEON_TRACKER_RESTART = dialogs.KT_DUNGEON_TRACKER_RESTART or {
        button1 = _G.YES or "Yes", button2 = _G.NO or "No",
        timeout = 0, whileDead = true, hideOnEscape = true, preferredIndex = 3,
        OnAccept = function() Mod:RestartDungeonRun() end,
    }
    dialogs.KT_DUNGEON_TRACKER_RESTART.text = L("Restart this dungeon run? The time, XP, gold and bosses start again from zero.")
    _G.StaticPopup_Show("KT_DUNGEON_TRACKER_RESTART")
end
-- Hidden for the current run only: the next run shows the tracker again.
function Mod:SetDungeonTrackerHidden(hidden)
    if not run or testing then return end
    run.hidden = hidden and true or nil
    Save(); Render()
    if hidden then KT:Print(L("The tracker is hidden for this run. Type /ktdungeon show to bring it back.")) end
end
function Mod:OpenDungeonTrackerOptions()
    local db = self.GetDB and self:GetDB()
    if db then
        db.ui = db.ui or {}
        db.ui.activeEnhancementCategory = "timer"
    end
    if KT.OpenMenu then KT:OpenMenu("enhancements") end
end
function Mod:RefreshMythicPlusTracker()
    if Config().enabled then self:InitializeMythicPlusTracker() end
    Sync()
end
function Mod:GetMythicPlusTrackerFrame() return Build() end
function Mod:RunMythicPlusTrackerTest()
    testing = true; simulation = nil
    local start = Now() - 754
    run = { name = L("Forever Dungeon"), started = Now() - 600, clockStart = start,
        elapsed = 0, deaths = 2, total = 3, xp = 18450, money = 23560, bosses = {
            { label = "First Boss", known = true, killed = true, at = start + 212, display = SAMPLE_DISPLAYS[1] },
            { label = "Second Boss", known = true, killed = true, at = start + 538, display = SAMPLE_DISPLAYS[2] },
            { label = "Final Boss", known = true, display = SAMPLE_DISPLAYS[3] } },
        rares = { { name = L("Rare Enemy") } } }
    Render()
end
-- Plays a short run through the same kill, death and completion paths as a
-- real dungeon. Nothing is written to the saved run.
function Mod:RunDungeonSimulation(step)
    testing = true
    local token = {}
    simulation = token
    run = { name = L("Simulated Dungeon"), started = Now(), clockStart = Now(), elapsed = 0, deaths = 0,
        total = 3, completed = false, xp = 0, money = 0, rares = {}, bosses = {
            { label = "First Boss", id = 1, known = true, display = SAMPLE_DISPLAYS[1] },
            { label = "Second Boss", id = 2, known = true, display = SAMPLE_DISPLAYS[2] },
            { label = "Final Boss", id = 3, known = true, display = SAMPLE_DISPLAYS[3] } } }
    dead = {}
    Render()
    step = tonumber(step) or 4
    local script = {
        function() RecordKill(1); run.xp = run.xp + 1240; run.money = run.money + 3150 end,
        function() run.deaths = run.deaths + 1 end,
        function() RecordKill(2); run.xp = run.xp + 1580; run.money = run.money + 4720 end,
        function() RecordKill(3); run.xp = run.xp + 2310; run.money = run.money + 9800 end,
    }
    for i, action in ipairs(script) do
        C_Timer.After(step * i, function()
            if simulation ~= token or not run then return end
            action(); Render()
        end)
    end
end
function Mod:StopMythicPlusTrackerTest()
    testing = false; simulation = nil; run = nil; activeConfig = nil; Sync()
end
function Mod:GetDungeonTrackerStatus()
    local config = Config()
    local name, kind, difficulty = GetInstanceInfo()
    local f = Build()
    return {
        enabled = config.enabled == true, moduleEnabled = Mod:GetDB().enable ~= false,
        initialized = self.mplusTrackerInitialized == true, testing = testing == true,
        instance = Plain(name), kind = Plain(kind), difficulty = Plain(difficulty),
        running = run and run.started ~= nil or false, completed = run and run.completed or false,
        killed = BossCount(), total = run and run.total or 0, shown = f:IsShown() == true,
        hidden = run and run.hidden == true or false, time = RunTime(),
    }
end
function Mod:RegisterMythicPlusTrackerMover()
    if self.mythicPlusTrackerMoverRegistered then return end
    KT:RegisterMovableElements({{
        key = "ENH_MYTHIC_PLUS_TRACKER", label = L("Dungeon Tracker"), group = "Enhancements",
        getFrame = Build, getSize = function() local f = Build(); return f:GetWidth(), f:GetHeight() end,
        isHidden = function() return false end,
        loadPosition = function() return Config().position or { point = "RIGHT", relativePoint = "RIGHT", x = -16, y = 224 } end,
        savePosition = function(_, point, relativePoint, x, y)
            local p = { point = point, relativePoint = relativePoint, x = x, y = y }
            Config().position = p
            KT.db.profile.editMode = KT.db.profile.editMode or { frames = {} }
            KT.db.profile.editMode.frames = KT.db.profile.editMode.frames or {}
            KT.db.profile.editMode.frames.ENH_MYTHIC_PLUS_TRACKER = p
        end,
        applyPosition = function() Mod:ApplyMythicPlusTrackerPosition() end,
        applyPendingPosition = function(_, p) Build():ClearAllPoints(); Build():SetPoint(p.point, UIParent, p.relativePoint or p.point, p.x, p.y) end,
    }})
    self.mythicPlusTrackerMoverRegistered = true
end
function Mod:InitializeMythicPlusTracker()
    if self.mplusTrackerInitialized then return end
    self.mplusTrackerInitialized = true
    xpLast, moneyLast = ReadXP(), ReadMoney()
    local events = CreateFrame("Frame")
    for _, event in ipairs({ "PLAYER_ENTERING_WORLD", "ZONE_CHANGED_NEW_AREA", "ENCOUNTER_END", "BOSS_KILL",
        "LFG_COMPLETION_REWARD", "UNIT_HEALTH", "PLAYER_DEAD", "PLAYER_ALIVE", "PLAYER_UNGHOST", "GROUP_ROSTER_UPDATE",
        "UPDATE_INSTANCE_INFO", "PLAYER_TARGET_CHANGED", "UPDATE_MOUSEOVER_UNIT",
        "NAME_PLATE_UNIT_ADDED", "ENCOUNTER_START", "INSTANCE_ENCOUNTER_ENGAGE_UNIT",
        "PLAYER_REGEN_DISABLED", "PLAYER_REGEN_ENABLED", "PLAYER_XP_UPDATE", "PLAYER_MONEY", "QUEST_TURNED_IN",
        "MERCHANT_SHOW", "MERCHANT_CLOSED", "TRADE_SHOW", "TRADE_CLOSED", "CHAT_MSG_SYSTEM", "PLAYER_LOGOUT" }) do
        pcall(events.RegisterEvent, events, event)
    end
    local function SyncAndReconcile()
        Sync()
        if ReconcileKills() then Save(); Render() end
    end
    events:SetScript("OnEvent", function(_, event, ...)
        if event == "PLAYER_REGEN_ENABLED" then
            if pendingTargets then LayoutTargets(true) end
            return
        end
        if event == "PLAYER_LOGOUT" then MarkSaved(); return end
        if event == "PLAYER_ENTERING_WORLD" then
            local login, reload = ...
            if login or reload then
                pendingRestore = login and "login" or "reload"
                -- Past the loading screen, walking in is not a return.
                if C_Timer and C_Timer.After then C_Timer.After(5, function() pendingRestore = nil end) end
            end
        end
        -- Totals are followed even while testing, so a test never turns a
        -- whole level of XP into one gain afterwards.
        if event == "PLAYER_XP_UPDATE" then
            if TrackXP() and not testing then Save(); Render() end
            return
        elseif event == "PLAYER_MONEY" then
            if TrackMoney() and not testing then Save(); Render() end
            return
        elseif event == "MERCHANT_SHOW" or event == "TRADE_SHOW" then
            merchantOpen = true; return
        elseif event == "MERCHANT_CLOSED" or event == "TRADE_CLOSED" then
            merchantOpen = false; moneyLast = ReadMoney(); return
        end
        if testing then return end
        if event == "QUEST_TURNED_IN" then
            local _, xp = ...
            xp = Plain(xp)
            if run and inside and type(xp) == "number" then
                run.questXP = (run.questXP or 0) + xp
                Save(); Render()
            end
            return
        elseif event == "CHAT_MSG_SYSTEM" then
            local reset = run and not inside and ResetName((...))
            if reset and reset == run.name and not run.completed then
                NoteNewRun("instance reset", run, run.mapID, run.difficulty)
                run = nil; Config().dungeonRun = nil; Render()
            end
            return
        elseif event == "PLAYER_REGEN_DISABLED" then
            if run and inside and not run.completed and not run.clockStart then StartClock(); Save(); Render() end
            return
        end
        -- Wing detection runs before the cheap early returns below.
        if event == "ENCOUNTER_START" then
            if SeeWingEncounter((...)) then Save(); Render() end
            return
        end
        local seen
        if event == "NAME_PLATE_UNIT_ADDED" then seen = Plain((...))
        elseif event == "INSTANCE_ENCOUNTER_ENGAGE_UNIT" then seen = "boss1"
        elseif event == "PLAYER_TARGET_CHANGED" then seen = "target"
        elseif event == "UPDATE_MOUSEOVER_UNIT" then seen = "mouseover"
        elseif event == "UNIT_HEALTH" and BOSS_UNITS[Plain((...))] then seen = Plain((...))
        end
        if seen then
            local changed = SeeWingUnit(seen)
            if SeeRare(seen) then changed = true end
            if SeeBossPortrait(seen) then changed = true end
            if changed then Save(); Render() end
        end
        if event == "NAME_PLATE_UNIT_ADDED" or event == "INSTANCE_ENCOUNTER_ENGAGE_UNIT" then return end
        local unit, watched
        if event == "UNIT_HEALTH" then
            -- UNIT_HEALTH fires for every nameplate; only the group and boss units matter.
            unit = Plain((...))
            if BOSS_UNITS[unit] then watched = unit
            elseif not GROUP_UNITS[unit] then return
            else
                -- Group health ticks all fight long: only a change of the
                -- dead state is worth a Sync, Save and Render.
                local guid = Plain(UnitGUID(unit))
                local killed = Plain(UnitIsDeadOrGhost(unit))
                if not guid or killed == nil or (killed and true or nil) == dead[guid] then return end
            end
        elseif event == "PLAYER_TARGET_CHANGED" then watched = "target"
        elseif event == "UPDATE_MOUSEOVER_UNIT" then watched = "mouseover"
        end
        -- Living units, and units that are not bosses, change nothing.
        if watched and not DeadBossName(watched) then return end
        Sync()
        if event == "PLAYER_ENTERING_WORLD" or event == "ZONE_CHANGED_NEW_AREA" then
            -- Instance info can lag behind the loading screen.
            if C_Timer and C_Timer.After then
                C_Timer.After(1, SyncAndReconcile); C_Timer.After(4, SyncAndReconcile)
            end
            -- Ask the server for the instance's encounter state; it answers
            -- with UPDATE_INSTANCE_INFO.
            if run and run.started and type(RequestRaidInfo) == "function" then pcall(RequestRaidInfo) end
        end
        if not run or not run.started or run.completed then return end
        if event == "ENCOUNTER_END" or event == "BOSS_KILL" then
            local id, name, _, _, success = ...
            success = Plain(success)
            if event == "BOSS_KILL" or success == 1 or success == true then RecordKill(id, name) end
        elseif event == "LFG_COMPLETION_REWARD" then Finish()
        elseif watched then RecordBossUnit(watched)
        elseif event == "UNIT_HEALTH" then RecordHealth(unit)
        elseif event == "PLAYER_DEAD" or event == "PLAYER_ALIVE" or event == "PLAYER_UNGHOST" then RecordHealth("player")
        end
        if event == "PLAYER_ENTERING_WORLD" or event == "ZONE_CHANGED_NEW_AREA" or event == "UPDATE_INSTANCE_INFO" then
            ReconcileKills()
        end
        Save(); Render()
    end)
    Mod.foreverDungeonEvents = events
    self:RegisterMythicPlusTrackerMover()
end
KT:RegisterChatCommand("ktdungeon", function(message)
    local command, value = (message or ""):lower():match("^%s*(%S*)%s*(%S*)")
    if command == "test" then Mod:RunMythicPlusTrackerTest()
    elseif command == "sim" then Mod:RunDungeonSimulation(value)
    elseif command == "stop" then Mod:StopMythicPlusTrackerTest()
    elseif command == "reset" then Mod:RestartDungeonRun()
    elseif command == "finish" then Mod:FinishDungeonRun()
    elseif command == "show" then Mod:SetDungeonTrackerHidden(false)
    elseif command == "save" then Mod:SaveDungeonRun()
    elseif command == "hide" then Mod:SetDungeonTrackerHidden(true)
    elseif command == "status" then
        local s = Mod:GetDungeonTrackerStatus()
        local function YesNo(value) return value and L("Yes") or L("No") end
        KT:Print(string.format(L("Dungeon Tracker status: enabled %s, module %s, ready %s, instance %s (%s, %s), active %s, completed %s, bosses %s, shown %s"),
            YesNo(s.enabled), YesNo(s.moduleEnabled), YesNo(s.initialized), tostring(s.instance or "-"),
            tostring(s.kind or "-"), tostring(s.difficulty or "-"), YesNo(s.running), YesNo(s.completed),
            s.total > 0 and (s.killed .. " / " .. s.total) or tostring(s.killed), YesNo(s.shown)))
    else KT:Print(L("Dungeon Tracker commands: /ktdungeon test | sim | stop | status | show | hide | reset | finish | save")) end
end)
