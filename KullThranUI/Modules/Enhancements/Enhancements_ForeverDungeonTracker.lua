local _, ns = ...
local KT = ns.KT or _G.KT
local Mod = ns.Enhancements or KT:GetModule("Enhancements", true)
if not Mod then return end

local run, testing, frame, activeConfig, simulation
local dead = {}
local GROUP_UNITS = { player = true, party1 = true, party2 = true, party3 = true, party4 = true }

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

local function Config()
    local db = Mod:GetDB()
    db.mplusTracker = db.mplusTracker or {}
    return db.mplusTracker
end
local function Now() return GetServerTime and GetServerTime() or time() end
local function Clock(n)
    n = math.max(0, math.floor(n or 0))
    return string.format("%d:%02d", math.floor(n / 60), n % 60)
end
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
local function ReadBossList(mapID)
    local bosses = {}
    -- The journal is optional on Forever. No UI selection or loading is needed.
    if not EJ_GetEncounterInfoByIndex then return bosses end
    local journal = JournalInstance(mapID)
    if not journal then return bosses end
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
    frame.title, frame.timer, frame.details, frame.progressText = Text(16), Text(26), Text(13), Text(13)
    frame.progress = CreateFrame("StatusBar", nil, frame)
    frame.progress:SetStatusBarTexture("Interface\\AddOns\\KullThranUI\\Libraries\\texture\\Melli.tga")
    frame.progress:SetMinMaxValues(0, 1)
    frame.objectives = {}
    for i = 1, 15 do frame.objectives[i] = Text(12) end
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
    Row(f.title, run.name or "Dungeon", "keyFont", c.keyFontSize or 16, c.keyColor or accent)
    Row(f.timer, Clock(Elapsed()), "timerFont", c.timerFontSize or 26,
        run.completed and c.timerSuccessColor or c.timerRunningColor)
    Row(f.details, (run.completed and "Completed" or (run.difficultyName or "Normal")) .. "  |  " .. (run.deaths or 0) .. " Deaths",
        "keyDetailsFont", c.keyDetailsFontSize or 13, c.keyDetailsColor)
    local killed, total = BossCount(), run.total or 0
    Row(f.progressText, total > 0 and string.format("Bosses: %d / %d", killed, total)
        or string.format("Bosses defeated: %d", killed), "forcesFont", c.forcesFontSize or 13, c.forcesColor)
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
            Row(text, (boss.killed and "|TInterface\\RaidFrame\\ReadyCheck-Ready:12|t " or "") .. boss.name
                .. (boss.split and "  " .. Clock(boss.split) or ""), "objectivesFont", c.objectivesFontSize or 12,
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
    if kind ~= "party" then Pause(); return end
    if not run then run = Config().dungeonRun end
    if not run or run.mapID ~= mapID or run.difficulty ~= difficulty or run.owner ~= owner then
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
                            boss.killed, boss.split = seen.killed, seen.split
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
    if not found then found = { id = id, name = name or "Boss" }; run.bosses[#run.bosses + 1] = found end
    if not found.killed then found.killed = true; found.split = Elapsed() end
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
local function EnsureTicker()
    if Mod.mplusTimer then return end
    Mod.mplusTimer = C_Timer.NewTicker(1, function() if testing or run and run.started then Render() end end)
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
    run = { name = "Forever Dungeon", difficultyName = "Normal", started = Now() - 600,
        elapsed = 0, deaths = 2, total = 3, bosses = {
            { name = "First Boss", killed = true, split = 200 },
            { name = "Second Boss", killed = true, split = 400 }, { name = "Final Boss" } } }
    EnsureTicker()
    Render()
end
-- Plays a short run through the same kill, death and completion paths as a
-- real dungeon. Nothing is written to the saved run.
function Mod:RunDungeonSimulation(step)
    testing = true
    local token = {}
    simulation = token
    run = { name = "Simulated Dungeon", difficultyName = "Normal", started = Now(), elapsed = 0, deaths = 0,
        total = 3, completed = false, bosses = {
            { name = "First Boss", id = 1, known = true }, { name = "Second Boss", id = 2, known = true },
            { name = "Final Boss", id = 3, known = true } } }
    dead = {}
    EnsureTicker()
    Render()
    step = tonumber(step) or 4
    local script = {
        function() RecordKill(1, "First Boss") end,
        function() run.deaths = run.deaths + 1 end,
        function() RecordKill(2, "Second Boss") end,
        function() RecordKill(3, "Final Boss") end,
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
        elapsed = Elapsed(), shown = f:IsShown() == true,
    }
end
function Mod:RegisterMythicPlusTrackerMover()
    if self.mythicPlusTrackerMoverRegistered then return end
    KT:RegisterMovableElements({{
        key = "ENH_MYTHIC_PLUS_TRACKER", label = "Dungeon Timer", group = "Enhancements",
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
    EnsureTicker()
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
        KT:Print(string.format("Dungeon Timer: enabled=%s module=%s ready=%s instance=%s (%s, %s) running=%s completed=%s time=%s shown=%s",
            tostring(s.enabled), tostring(s.moduleEnabled), tostring(s.initialized), tostring(s.instance),
            tostring(s.kind), tostring(s.difficulty), tostring(s.running), tostring(s.completed), Clock(s.elapsed), tostring(s.shown)))
    else KT:Print("/ktdungeon test | sim | stop | status | reset | finish") end
end)
