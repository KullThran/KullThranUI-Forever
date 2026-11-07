local _, ns = ...
local KT = ns.KT or _G.KT
local Mod = ns.Enhancements or KT:GetModule("Enhancements", true)
if not Mod then return end

local run, testing, frame, activeConfig, simulation
local dead = {}
local GROUP_UNITS = { player = true, party1 = true, party2 = true, party3 = true, party4 = true }
-- The client gives no ID for one dungeon run. Walking back in continues the
-- run (a corpse run, a trip to a vendor) unless it was finished before
-- leaving, or the dungeon was left for longer than this.
local STALE_RUN_SECONDS = 60 * 60

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
-- WoW Forever dungeons have no timer to beat: the tracker shows objectives
-- (the bosses), never a clock. The run keeps the time spent inside only to
-- know whether it is active, paused or finished.
local function Now() return GetServerTime and GetServerTime() or time() end
local function Elapsed()
    return run and ((run.elapsed or 0) + (run.started and math.max(0, Now() - run.started) or 0)) or 0
end
local function Save()
    if not testing then Config().dungeonRun = run end
end
local function BossCount()
    local killed = 0
    for _, boss in ipairs(run and run.bosses or {}) do
        if boss.killed then killed = killed + 1 end
    end
    return killed
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
-- These maps hold several wings as separate instances under one map ID, so a
-- run only meets part of the list: they keep counting kills without a total.
local MULTI_WING = { [189] = true, [229] = true, [429] = true }
local function StaticBossList(mapID)
    local bosses = {}
    local list = mapID and not MULTI_WING[mapID] and DUNGEON_BOSSES[mapID]
    for _, entry in ipairs(list or {}) do
        bosses[#bosses + 1] = { id = entry[1], name = entry[2], known = true }
    end
    return bosses
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
    return bosses
end
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
    frame.title, frame.details, frame.progressText = Text(16), Text(13), Text(13)
    frame.progress = CreateFrame("StatusBar", nil, frame)
    frame.progress:SetStatusBarTexture("Interface\\AddOns\\KullThranUI\\Libraries\\texture\\Melli.tga")
    frame.progress:SetMinMaxValues(0, 1)
    frame.objectives = {}
    -- Blackrock Depths lists 21 bosses.
    for i = 1, 22 do frame.objectives[i] = Text(12) end
    frame:Hide()
    Mod.mplusTrackerFrame = frame
    return frame
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
local function Render()
    local f, c = Build(), Config()
    if not run or (not testing and (not run.started and not run.completed or c.enabled ~= true or Mod:GetDB().enable == false)) then
        f:Hide(); return
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
    Row(f.title, run.name or L("Dungeon"), "keyFont", c.keyFontSize or 16, c.keyColor or accent)
    Row(f.details, (run.completed and L("Dungeon Completed") or (run.difficultyName or L("Normal"))) .. "  |  "
        .. string.format(L("%d Deaths"), run.deaths or 0),
        "keyDetailsFont", c.keyDetailsFontSize or 13, c.keyDetailsColor)
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
    for i, text in ipairs(f.objectives) do
        local boss = run.bosses[i]
        if boss then
            Row(text, (boss.killed and "|TInterface\\RaidFrame\\ReadyCheck-Ready:12|t " or "") .. (boss.label and L(boss.label) or boss.name),
                "objectivesFont", c.objectivesFontSize or 12,
                boss.killed and c.completedObjectivesColor or c.objectivesColor)
        else text:Hide() end
    end
    f:SetHeight(math.max(100, y + 4))
    Mod:ApplyMythicPlusTrackerPosition()
    f:Show()
end
local function Finish()
    if not run or run.completed then return end
    run.elapsed = Elapsed(); run.started = nil; run.completed = true; Save()
end
local function Pause()
    if run and run.started then run.elapsed = Elapsed(); run.started = nil; Save() end
    if frame then frame:Hide() end
end
local function Sync()
    if testing then Render(); return end
    local config = Config()
    if activeConfig ~= config then run = config.dungeonRun; activeConfig = config; dead = run and run.dead or {} end
    if config.enabled ~= true or Mod:GetDB().enable == false then Pause(); return end
    local name, kind, difficulty, difficultyName, _, _, _, mapID = GetInstanceInfo()
    name, kind, difficulty, difficultyName, mapID = Plain(name), Plain(kind), Plain(difficulty), Plain(difficultyName), Plain(mapID)
    local owner = Plain(UnitGUID("player"))
    -- Every five-player dungeon difficulty counts, keystone runs included.
    if kind ~= "party" then
        -- Remember when the dungeon was left: a run finished before, or left
        -- long ago, is not the one the player walks back into.
        if run and not run.leftAt then run.leftAt = Now() end
        Pause(); return
    end
    if not run then run = Config().dungeonRun end
    local stale = run and run.leftAt and (run.completed or Now() - run.leftAt > STALE_RUN_SECONDS)
    if run then run.leftAt = nil end
    if not run or stale or run.mapID ~= mapID or run.difficulty ~= difficulty or run.owner ~= owner then
        local bosses = ReadBossList(mapID)
        run = { mapID = mapID, difficulty = difficulty, difficultyName = difficultyName,
            name = name, owner = owner, started = Now(), elapsed = 0, deaths = 0,
            bosses = bosses, total = #bosses, completed = false }
        dead = {}
        for unit in pairs(GROUP_UNITS) do
            local guid = Plain(UnitGUID(unit))
            if guid and Plain(UnitIsDeadOrGhost(unit)) then dead[guid] = true end
        end
        run.dead = dead
    else
        if not run.started and not run.completed then run.started = Now() end
        if (run.total or 0) == 0 and not run.completed then
            -- The journal may not be ready on the first loading screen.
            local bosses = ReadBossList(mapID)
            if #bosses > 0 then
                for _, seen in ipairs(run.bosses or {}) do
                    for _, boss in ipairs(bosses) do
                        if (seen.id and seen.id == boss.id) or seen.name == boss.name then
                            boss.killed = seen.killed
                        end
                    end
                end
                run.bosses, run.total = bosses, #bosses
            end
        end
    end
    Save(); Render()
end
local function RecordKill(id, name)
    id, name = Plain(id), Plain(name)
    local found
    for _, boss in ipairs(run.bosses) do
        if (id and boss.id == id) or (name and boss.name == name) then found = boss; break end
    end
    if not found then
        found = { id = id, name = name, label = not name and "Boss" or nil }
        run.bosses[#run.bosses + 1] = found
    end
    -- The kill event names the boss in the client's language.
    if name and found.id and found.id == id then found.name = name end
    found.killed = true
    local knownKilled = 0
    for _, boss in ipairs(run.bosses) do if boss.known and boss.killed then knownKilled = knownKilled + 1 end end
    if run.total > 0 and knownKilled == run.total then Finish() end
end
local function RecordHealth(unit)
    local guid = Plain(UnitGUID(unit))
    local killed = Plain(UnitIsDeadOrGhost(unit))
    if not guid or killed == nil then return end
    if killed and not dead[guid] then run.deaths = (run.deaths or 0) + 1 end
    dead[guid] = killed and true or nil
end
function Mod:FinishDungeonRun()
    if testing then return end
    Finish(); Render()
end
function Mod:RestartDungeonRun()
    testing = false; simulation = nil; run = nil; Config().dungeonRun = nil; Sync()
end
function Mod:RefreshMythicPlusTracker()
    if Config().enabled then self:InitializeMythicPlusTracker() end
    Sync()
end
function Mod:GetMythicPlusTrackerFrame() return Build() end
function Mod:RunMythicPlusTrackerTest()
    testing = true; simulation = nil
    run = { name = L("Forever Dungeon"), started = Now() - 600,
        elapsed = 0, deaths = 2, total = 3, bosses = {
            { label = "First Boss", killed = true },
            { label = "Second Boss", killed = true }, { label = "Final Boss" } } }
    Render()
end
-- Plays a short run through the same kill, death and completion paths as a
-- real dungeon. Nothing is written to the saved run.
function Mod:RunDungeonSimulation(step)
    testing = true
    local token = {}
    simulation = token
    run = { name = L("Simulated Dungeon"), started = Now(), elapsed = 0, deaths = 0,
        total = 3, completed = false, bosses = {
            { label = "First Boss", id = 1, known = true }, { label = "Second Boss", id = 2, known = true },
            { label = "Final Boss", id = 3, known = true } } }
    dead = {}
    Render()
    step = tonumber(step) or 4
    local script = {
        function() RecordKill(1) end,
        function() run.deaths = run.deaths + 1 end,
        function() RecordKill(2) end,
        function() RecordKill(3) end,
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
    local events = CreateFrame("Frame")
    for _, event in ipairs({ "PLAYER_ENTERING_WORLD", "ZONE_CHANGED_NEW_AREA", "ENCOUNTER_END", "BOSS_KILL",
        "LFG_COMPLETION_REWARD", "UNIT_HEALTH", "PLAYER_DEAD", "PLAYER_ALIVE", "PLAYER_UNGHOST", "GROUP_ROSTER_UPDATE" }) do
        pcall(events.RegisterEvent, events, event)
    end
    events:SetScript("OnEvent", function(_, event, ...)
        if testing then return end
        local unit
        if event == "UNIT_HEALTH" then
            -- UNIT_HEALTH fires for every nameplate; only the group matters.
            unit = Plain((...))
            if not GROUP_UNITS[unit] then return end
        end
        Sync()
        if event == "PLAYER_ENTERING_WORLD" or event == "ZONE_CHANGED_NEW_AREA" then
            -- Instance info can lag behind the loading screen.
            if C_Timer and C_Timer.After then
                C_Timer.After(1, Sync); C_Timer.After(4, Sync)
            end
        end
        if not run or not run.started or run.completed then return end
        if event == "ENCOUNTER_END" or event == "BOSS_KILL" then
            local id, name, _, _, success = ...
            success = Plain(success)
            if event == "BOSS_KILL" or success == 1 or success == true then RecordKill(id, name) end
        elseif event == "LFG_COMPLETION_REWARD" then Finish()
        elseif event == "UNIT_HEALTH" then RecordHealth(unit)
        elseif event == "PLAYER_DEAD" or event == "PLAYER_ALIVE" or event == "PLAYER_UNGHOST" then RecordHealth("player")
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
    elseif command == "status" then
        local s = Mod:GetDungeonTrackerStatus()
        local function YesNo(value) return value and L("Yes") or L("No") end
        KT:Print(string.format(L("Dungeon Tracker status: enabled %s, module %s, ready %s, instance %s (%s, %s), active %s, completed %s, bosses %s, shown %s"),
            YesNo(s.enabled), YesNo(s.moduleEnabled), YesNo(s.initialized), tostring(s.instance or "-"),
            tostring(s.kind or "-"), tostring(s.difficulty or "-"), YesNo(s.running), YesNo(s.completed),
            s.total > 0 and (s.killed .. " / " .. s.total) or tostring(s.killed), YesNo(s.shown)))
    else KT:Print(L("Dungeon Tracker commands: /ktdungeon test | sim | stop | status | reset | finish")) end
end)
