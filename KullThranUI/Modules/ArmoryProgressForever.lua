local KT = LibStub("AceAddon-3.0"):GetAddon("KullThranUI", true)
if not KT then return end

--[[
    ArmoryProgressForever.lua

    The Progress page's sections on WoW Forever, which has no Mythic+, no
    Great Vault and no seasons of either. Top to bottom:
      level       level, experience and rested experience
      dungeons    completed dungeons: times, best time, last time
                  (recorded by the Dungeon Tracker, per character)
      raids       raid lockouts, as on the shared page, with their reset
      pvp         PvP rank, its points and this week's rank cap
      professions skill of every profession
    The level card has no header; the sections fold like the shared ones.
    Drawing uses the pieces of ArmoryProgressPage.lua (Page.Draw). Data
    collection (Collect*) has no UI and is tested on its own.
]]

local Page = KT.ArmoryProgressPage
if not (Page and KT.IsForever and KT:IsForever()) then return end

local D = Page.Draw
local PAD, MUTED, LText, Text, Color = D.PAD, D.MUTED, D.LText, D.Text, D.Color
local LIGHT = { 0.94, 0.94, 0.96 }
local XP_COLOR, RESTED_COLOR = { 0.58, 0.3, 0.78 }, { 0.2, 0.36, 0.72 }
local PVP_COLOR = { 0.8, 0.24, 0.2 }
-- The major faction behind the PvP rank (Blizzard's PVPRankFrame.lua).
local PVP_RANK_FACTION = 2800

local function Plain(value)
    if value ~= nil and issecretvalue and issecretvalue(value) then return nil end
    return value
end

local function Call(fn, ...)
    if type(fn) ~= "function" then return nil end
    local ok, value = pcall(fn, ...)
    return ok and Plain(value) or nil
end

local function Number(fn, ...)
    local value = Call(fn, ...)
    return type(value) == "number" and value or nil
end

local function Thousands(value)
    value = math.floor(value or 0)
    return BreakUpLargeNumbers and BreakUpLargeNumbers(value) or tostring(value)
end

-- 38:12, or 1:04:50 from an hour on.
local function FormatTime(seconds)
    seconds = math.max(0, math.floor(tonumber(seconds) or 0))
    local hours, minutes = math.floor(seconds / 3600), math.floor(seconds % 3600 / 60)
    if hours > 0 then return string.format("%d:%02d:%02d", hours, minutes, seconds % 60) end
    return string.format("%d:%02d", minutes, seconds % 60)
end

-- Today, Yesterday or the client's short date.
local function FormatDay(stamp, now)
    local day, today = date("*t", stamp), date("*t", now)
    local function Same(a, b) return a.year == b.year and a.yday == b.yday end
    if Same(day, today) then return HONOR_TODAY or "Today" end
    local yesterday = date("*t", time({ year = today.year, month = today.month, day = today.day - 1, hour = 12 }))
    if Same(day, yesterday) then return HONOR_YESTERDAY or "Yesterday" end
    if FormatShortDate then return FormatShortDate(day.day, day.month, day.year) end
    return date("%x", stamp)
end

-------------------------------------------------------------------------------
--  Data
-------------------------------------------------------------------------------

-- nil without a level. No max: the level cap, or no experience to earn.
function Page:CollectLevel()
    local level = Number(UnitLevel, "player")
    if not level then return nil end
    local info = { level = level }
    local cap = Number(GetMaxPlayerLevel)
    local atCap = cap and cap > 0 and level >= cap
        or GameRulesUtil and Call(GameRulesUtil.IsPlayerAtEffectiveMaxLevel) == true
    local xp, max = Number(UnitXP, "player"), Number(UnitXPMax, "player")
    if atCap or not xp or not max or max <= 0 then
        info.capped = atCap and true or false
        return info
    end
    info.xp, info.max = math.min(xp, max), max
    info.rested = math.max(0, Number(GetXPExhaustion) or 0)
    return info
end

function Page:CollectForeverDungeons()
    local mod = KT.GetModule and KT:GetModule("Enhancements", true)
    return mod and mod.GetForeverDungeonRecords and mod:GetForeverDungeonRecords() or {}
end

local function RankTitle(rank)
    if rank <= 0 then return PVP_RANK_0_NAME or "" end
    local first = Enum and Enum.PvPRanks and Enum.PvPRanks.Rank_1
    if not (first and GetText) then return "" end
    local side = Call(UnitFactionGroup, "player") == "Alliance" and 1 or 0
    return Call(GetText, "PVP_RANK_" .. (first + rank - 1) .. "_" .. side, Number(UnitSex, "player")) or ""
end

-- nil while the client has no PvP rank data.
function Page:CollectPvP()
    local info = C_MajorFactions and Call(C_MajorFactions.GetMajorFactionProgressionInfo, PVP_RANK_FACTION)
    local rank = type(info) == "table" and Plain(info.renownLevel)
    if type(rank) ~= "number" then return nil end
    local points, threshold = Plain(info.renownReputationEarned) or 0, Plain(info.renownLevelThreshold) or 0
    local title = RankTitle(rank)
    local label = title
    if rank > 0 then
        label = title ~= "" and string.format(PVP_RANK_NUMBER_AND_TITLE or "%d - %s", rank, title)
            or string.format("%s %d", RANK or "Rank", rank)
    end
    local badge = rank > 0 and ("UI-Character-Info-Honor-Icon-" .. rank)
        or (Call(UnitFactionGroup, "player") == "Horde" and "UI-Character-Info-Honor-Icon-Horde"
            or "UI-Character-Info-Honor-Icon-Alliance")
    return {
        rank = rank, label = label, badge = badge, points = points, threshold = threshold,
        weekCap = Plain(info.currentWeekProgressiveMaxLevel) or 0, maxRank = Plain(info.maxLevel) or 0,
    }
end

-- Primary professions, then cooking, fishing and first aid, as in the
-- professions book.
function Page:CollectProfessions()
    local list = {}
    if type(GetProfessions) ~= "function" or type(GetProfessionInfo) ~= "function" then return list end
    local first, second, firstAid, fishing, cooking = GetProfessions()
    for _, index in ipairs({ first or false, second or false, cooking or false, fishing or false, firstAid or false }) do
        if index then
            local name, texture, rank, max, _, _, _, modifier = GetProfessionInfo(index)
            if name then
                list[#list + 1] = { name = name, texture = texture, rank = tonumber(rank) or 0,
                    max = tonumber(max) or 0, modifier = tonumber(modifier) or 0 }
            end
        end
    end
    return list
end

-------------------------------------------------------------------------------
--  Pieces
-------------------------------------------------------------------------------

local function LevelCard(y, ctx, info)
    local width = ctx.width - 2 * PAD
    local c = D.Pool("levelCard", function()
        local f = CreateFrame("Frame", nil, ctx.content, "BackdropTemplate")
        f:SetHeight(66)
        f.bg = f:CreateTexture(nil, "BACKGROUND")
        f.bg:SetAllPoints()
        f.icon = f:CreateTexture(nil, "ARTWORK")
        f.icon:SetSize(34, 34)
        f.icon:SetPoint("LEFT", f, "LEFT", 10, 0)
        f.label = Text(f, 8)
        f.label:SetPoint("TOPLEFT", f, "TOPLEFT", 54, -7)
        f.level = Text(f, 20, "OUTLINE")
        f.level:SetPoint("TOPLEFT", f.label, "BOTTOMLEFT", -1, -2)
        f.percent = Text(f, 11)
        f.percent:SetPoint("RIGHT", f, "RIGHT", -8, 6)
        f.track = f:CreateTexture(nil, "ARTWORK", nil, 0)
        f.track:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 54, 19)
        f.track:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -8, 19)
        f.track:SetHeight(6)
        f.restedBar = f:CreateTexture(nil, "ARTWORK", nil, 1)
        f.restedBar:SetPoint("LEFT", f.track, "LEFT", 0, 0)
        f.restedBar:SetHeight(6)
        f.bar = f:CreateTexture(nil, "ARTWORK", nil, 2)
        f.bar:SetPoint("LEFT", f.track, "LEFT", 0, 0)
        f.bar:SetHeight(6)
        f.rested = Text(f, 8)
        f.rested:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -8, 6)
        f.left = Text(f, 8)
        f.left:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 54, 6)
        f.left:SetPoint("RIGHT", f.rested, "LEFT", -4, 0)
        f.left:SetJustifyH("LEFT")
        f.left:SetWordWrap(false)
        return f
    end)
    c:ClearAllPoints()
    c:SetPoint("TOPLEFT", ctx.content, "TOPLEFT", PAD, y)
    c:SetWidth(width)
    c.bg:SetColorTexture(0, 0, 0, 0.4)
    D.Border(c, ctx.accent, 0.45)
    D.Glyph(c.icon, "star")
    for _, fs in ipairs({ c.label, c.level, c.percent, c.left, c.rested }) do D.Restyle(fs) end
    c.label:SetText(string.upper(LEVEL or "Level"))
    Color(c.label, MUTED)
    c.level:SetText(tostring(info.level))
    Color(c.level, LIGHT)
    Color(c.percent, LIGHT)
    Color(c.left, MUTED)
    Color(c.rested, MUTED)
    local tip
    if info.max then
        local full = width - 54 - 8
        local share, restedShare = info.xp / info.max, math.min(1, (info.xp + info.rested) / info.max)
        c.track:SetColorTexture(0.12, 0.12, 0.14, 1)
        c.bar:SetColorTexture(XP_COLOR[1], XP_COLOR[2], XP_COLOR[3], 1)
        c.restedBar:SetColorTexture(RESTED_COLOR[1], RESTED_COLOR[2], RESTED_COLOR[3], 0.75)
        c.bar:SetWidth(math.max(1, full * share))
        c.restedBar:SetWidth(math.max(1, full * restedShare))
        c.track:Show()
        c.bar:SetShown(info.xp > 0)
        c.restedBar:SetShown(info.rested > 0)
        c.percent:SetText(string.format("%d%%", math.floor(share * 100)))
        c.left:SetText(string.format(LText("%s XP to level %d"), Thousands(info.max - info.xp), info.level + 1))
        local rested = info.rested > 0 and string.format(LText("Rested: %d%%"), math.floor(info.rested / info.max * 100 + 0.5)) or ""
        c.rested:SetText(rested)
        tip = { string.format("%s %d", LEVEL or "Level", info.level),
            string.format("%s / %s", Thousands(info.xp), Thousands(info.max)) }
        if rested ~= "" then tip[#tip + 1] = rested end
    else
        c.track:Hide(); c.bar:Hide(); c.restedBar:Hide()
        c.percent:SetText("")
        c.left:SetText(info.capped and (GUILD_RECRUITMENT_MAXLEVEL or "Max Level") or "")
        c.rested:SetText("")
        tip = nil
    end
    c:EnableMouse(true)
    D.Tooltip(c, tip)
    return y - 72
end

-- A completed dungeon: name and times on the first line, best and last below.
local function DungeonRow(y, ctx, d, index, now)
    local r = D.Pool("foreverDungeons", function()
        local f = CreateFrame("Frame", nil, ctx.content)
        f:SetHeight(30)
        f.band = f:CreateTexture(nil, "BACKGROUND")
        f.band:SetAllPoints()
        f.edge = f:CreateTexture(nil, "ARTWORK")
        f.edge:SetPoint("TOPLEFT"); f.edge:SetPoint("BOTTOMLEFT")
        f.edge:SetWidth(2)
        f.runs = Text(f, 9)
        f.runs:SetPoint("TOPRIGHT", f, "TOPRIGHT", -6, -4)
        f.name = Text(f, 10)
        f.name:SetPoint("TOPLEFT", f, "TOPLEFT", 8, -4)
        f.name:SetPoint("RIGHT", f.runs, "LEFT", -6, 0)
        f.name:SetJustifyH("LEFT")
        f.name:SetWordWrap(false)
        f.best = Text(f, 8)
        f.best:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 8, 4)
        f.last = Text(f, 8)
        f.last:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -6, 4)
        return f
    end)
    r:ClearAllPoints()
    r:SetPoint("TOPLEFT", ctx.content, "TOPLEFT", PAD, y)
    r:SetWidth(ctx.width - 2 * PAD)
    r.band:SetColorTexture(1, 1, 1, index % 2 == 1 and 0.04 or 0.015)
    r.edge:SetColorTexture(ctx.accent[1], ctx.accent[2], ctx.accent[3], 0.9)
    for _, fs in ipairs({ r.name, r.runs, r.best, r.last }) do D.Restyle(fs) end
    local runs = d.runs == 1 and LText("1 run") or string.format(LText("%d runs"), d.runs)
    local best = d.best and string.format(LText("Best: %s"), FormatTime(d.best)) or ""
    local last = d.last > 0 and FormatDay(d.last, now) or ""
    r.name:SetText(d.name); Color(r.name, LIGHT)
    r.runs:SetText(runs); Color(r.runs, ctx.accent)
    r.best:SetText(best); Color(r.best, MUTED)
    r.last:SetText(last); Color(r.last, MUTED)
    r:EnableMouse(true)
    local tip = { d.name, runs }
    if best ~= "" then tip[#tip + 1] = best end
    if last ~= "" then tip[#tip + 1] = last end
    D.Tooltip(r, tip)
    return y - 32
end

-- Icon, label, value and a thin bar. data: texture or atlas, label, value,
-- share (0-1), color, dim, tip.
local function BarRow(y, ctx, data)
    local r = D.Pool("barRows", function()
        local f = CreateFrame("Frame", nil, ctx.content)
        f:SetHeight(28)
        f.icon = f:CreateTexture(nil, "ARTWORK")
        f.icon:SetSize(24, 24)
        f.icon:SetPoint("LEFT", f, "LEFT", 2, 0)
        f.value = Text(f, 9)
        f.value:SetPoint("TOPRIGHT", f, "TOPRIGHT", -4, -4)
        f.label = Text(f, 10)
        f.label:SetPoint("TOPLEFT", f, "TOPLEFT", 32, -4)
        f.label:SetPoint("RIGHT", f.value, "LEFT", -6, 0)
        f.label:SetJustifyH("LEFT")
        f.label:SetWordWrap(false)
        f.track = f:CreateTexture(nil, "ARTWORK", nil, 0)
        f.track:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 32, 4)
        f.track:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -4, 4)
        f.track:SetHeight(5)
        f.bar = f:CreateTexture(nil, "ARTWORK", nil, 1)
        f.bar:SetPoint("LEFT", f.track, "LEFT", 0, 0)
        f.bar:SetHeight(5)
        return f
    end)
    local width = ctx.width - 2 * PAD
    r:ClearAllPoints()
    r:SetPoint("TOPLEFT", ctx.content, "TOPLEFT", PAD, y)
    r:SetWidth(width)
    if data.atlas and r.icon.SetAtlas and not (C_Texture and C_Texture.GetAtlasInfo and not C_Texture.GetAtlasInfo(data.atlas)) then
        r.icon:SetAtlas(data.atlas)
        r.icon:Show()
    elseif data.texture then
        r.icon:SetTexture(data.texture)
        r.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
        r.icon:Show()
    else
        r.icon:Hide()
    end
    D.Restyle(r.label); D.Restyle(r.value)
    r.label:SetText(data.label); Color(r.label, LIGHT)
    r.value:SetText(data.value); Color(r.value, MUTED)
    r.track:SetColorTexture(0.12, 0.12, 0.14, 1)
    local share = math.max(0, math.min(1, data.share or 0))
    r.bar:SetColorTexture(data.color[1], data.color[2], data.color[3], 1)
    r.bar:SetWidth(math.max(1, (width - 36) * share))
    r.bar:SetShown(share > 0)
    r:EnableMouse(true)
    D.Tooltip(r, data.tip)
    return y - 30
end

-------------------------------------------------------------------------------
--  Page
-------------------------------------------------------------------------------

function Page:DrawBody(y, ctx)
    self.foreverContent, self.foreverBridge = ctx.content, ctx.bridge
    local now = GetServerTime and GetServerTime() or time()

    local level = self:CollectLevel()
    if level then y = LevelCard(y, ctx, level) end

    local collapsed
    y, collapsed = D.Header(y, "dungeons", DUNGEONS or "Dungeons")
    if not collapsed then
        local dungeons = self:CollectForeverDungeons()
        if #dungeons == 0 then y = D.Note(y, LText("No dungeons completed yet")) end
        for i, d in ipairs(dungeons) do y = DungeonRow(y, ctx, d, i, now) end
    end
    y = y - 6

    y, collapsed = D.Header(y, "raids", RAIDS or "Raids")
    if not collapsed then
        local raids = self:CollectRaids()
        if #raids == 0 then y = D.Note(y, LText("No raid lockouts this week")) end
        for _, raid in ipairs(raids) do
            raid.color = ctx.accent -- the difficulty colours are Retail's
            y = D.RaidCard(y, raid)
            if raid.reset then
                y = D.Note(y + 4, string.format(LText("Resets in %s"), D.FormatReset(raid.reset)), "clock") - 4
            end
        end
    end
    y = y - 4

    local pvp = self:CollectPvP()
    if pvp then
        y, collapsed = D.Header(y, "pvp", LText("PvP Rank"))
        if not collapsed then
            local top = pvp.threshold <= 0
            local week = pvp.weekCap > 0 and string.format(LText("Rank cap this week: %d"), pvp.weekCap) or nil
            y = BarRow(y, ctx, {
                atlas = pvp.badge, label = pvp.label, color = PVP_COLOR, share = top and 1 or pvp.points / pvp.threshold,
                value = top and "" or string.format("%s/%s", Thousands(pvp.points), Thousands(pvp.threshold)),
                tip = { pvp.label, week },
            })
            if week then y = D.Note(y, week) end
        end
        y = y - 4
    end

    local professions = self:CollectProfessions()
    if #professions > 0 then
        y, collapsed = D.Header(y, "professions", TRADE_SKILLS or "Professions")
        if not collapsed then
            for _, p in ipairs(professions) do
                local value = p.modifier > 0 and string.format("%d+%d/%d", p.rank, p.modifier, p.max)
                    or string.format("%d/%d", p.rank, p.max)
                y = BarRow(y, ctx, { texture = p.texture, label = p.name, value = value, color = ctx.accent,
                    share = p.max > 0 and p.rank / p.max or 0, tip = { p.name, value } })
            end
        end
    end
    return y
end

-- Keeps the open page current. Several of these events come in bursts.
local pending
local events = CreateFrame("Frame")
for _, event in ipairs({ "PLAYER_XP_UPDATE", "UPDATE_EXHAUSTION", "PLAYER_LEVEL_UP", "SKILL_LINES_CHANGED",
    "UPDATE_FACTION", "MAJOR_FACTION_RENOWN_LEVEL_CHANGED" }) do
    pcall(events.RegisterEvent, events, event)
end
events:SetScript("OnEvent", function()
    local content, bridge = Page.foreverContent, Page.foreverBridge
    if pending or not (content and bridge and content:IsVisible()) then return end
    pending = true
    C_Timer.After(0.2, function()
        pending = nil
        if content:IsVisible() and bridge.RefreshProgress then bridge:RefreshProgress() end
    end)
end)
