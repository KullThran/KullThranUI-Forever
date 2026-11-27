-- World map quest log: zone headers the player collapses stay collapsed.
--
-- Blizzard opens quest log headers by itself in two places: QuestLog:Refresh
-- runs QuestMapFrame_ResetFilters on every map change (opening the map,
-- zooming, the map following the player into a new zone) and expands every
-- header on the shown map; and hovering a quest pin on the map runs
-- ExpandHeaderForQuest (CVar scrollToLogQuest). Either way a zone the player
-- had just collapsed opened again by itself. Here the headers the player
-- collapses are remembered by title for the session, and any expansion the
-- player did not make on the list is undone. Expanding the header on the list
-- forgets it.
--
-- Other addons can expand every header on purpose: RestedXP Guides calls
-- ExpandQuestHeader(0) whenever a header is collapsed, to read the quest
-- objectives of its guide. That is left alone (answering it collapsed and
-- re-expanded the zone several times a second), and if some other change keeps
-- undoing the collapse, the reapply stops until the player collapses again.
--
-- The collapse is done on the next frame, outside Blizzard's Refresh, so the
-- world map's own update path never runs addon code.

local _G = _G
local type, next, pcall, table = type, next, pcall, table
local hooksecurefunc = _G.hooksecurefunc
local CreateFrame = _G.CreateFrame
local C_Timer = _G.C_Timer

local collapsedByPlayer = {}
local restoring = false
local reapplyQueued = false
-- Loop guard: reapplies undone again within a second.
local REAPPLY_LIMIT, REAPPLY_WINDOW = 3, 1
local reapplyTimes = {}
local reapplyBlocked = false

local function QuestLogAPI()
    local api = _G.C_QuestLog
    if api and type(api.GetInfo) == "function" and type(api.GetNumQuestLogEntries) == "function" then
        return api
    end
end

-- Header title and info for a quest log index, or nil when it is not a header.
local function HeaderAt(index)
    local api = QuestLogAPI()
    if not (api and type(index) == "number" and index > 0) then return nil end
    local ok, info = pcall(api.GetInfo, index)
    if not (ok and type(info) == "table" and info.isHeader) then return nil end
    local title = info.title
    if type(title) ~= "string" or title == "" then return nil end
    return title, info
end

-- True while Blizzard itself is collapsing or expanding (map reset, search).
local function IsAutomaticChange(isAuto)
    if restoring or isAuto == true then return true end
    local questMap = _G.QuestMapFrame
    return questMap and questMap.ignoreQuestLogUpdate and true or false
end

-- An expansion is the player's only when it comes from the quest list under
-- the mouse (the header button); pin hover and map resets are not.
local function PlayerIsOnQuestList()
    local scroll = _G.QuestScrollFrame
    if not (scroll and scroll.IsVisible and scroll:IsVisible() and scroll.IsMouseOver) then return false end
    local ok, over = pcall(scroll.IsMouseOver, scroll)
    return ok and over == true
end

local QueueReapply

local function Remember(index, collapsed, isAuto)
    if restoring then return end
    if IsAutomaticChange(isAuto) or (not collapsed and not PlayerIsOnQuestList()) then
        -- 0 is "every header": another addon's expand-all, not answered.
        if not collapsed and index ~= 0 then QueueReapply() end
        return
    end
    -- The player acted on the list: reapplying may resume.
    reapplyBlocked = false
    for i = #reapplyTimes, 1, -1 do reapplyTimes[i] = nil end
    local api = QuestLogAPI()
    if not api then return end
    if index == 0 then
        -- 0 is "every header".
        for i = 1, api.GetNumQuestLogEntries() do
            local title = HeaderAt(i)
            if title then collapsedByPlayer[title] = collapsed or nil end
        end
        return
    end
    local title = HeaderAt(index)
    if title then collapsedByPlayer[title] = collapsed or nil end
end

local function SearchIsActive()
    local scroll = _G.QuestScrollFrame
    local box = scroll and scroll.SearchBox
    local text = box and box.GetText and box:GetText()
    return type(text) == "string" and text ~= ""
end

local function Reapply()
    reapplyQueued = false
    local api = QuestLogAPI()
    local collapse = _G.CollapseQuestHeader
    if not (api and type(collapse) == "function") or next(collapsedByPlayer) == nil then return end
    -- A search expands every header to show its matches and restores them
    -- itself when it ends.
    if SearchIsActive() or reapplyBlocked then return end
    local now = _G.GetTime and _G.GetTime() or 0
    local recent = 0
    for i = 1, #reapplyTimes do
        if now - reapplyTimes[i] <= REAPPLY_WINDOW then recent = recent + 1 end
    end
    if recent >= REAPPLY_LIMIT then
        reapplyBlocked = true
        return
    end
    reapplyTimes[#reapplyTimes + 1] = now
    if #reapplyTimes > REAPPLY_LIMIT then table.remove(reapplyTimes, 1) end
    restoring = true
    -- From the end, so a collapse can never shift an index still to visit.
    for index = api.GetNumQuestLogEntries(), 1, -1 do
        local title, info = HeaderAt(index)
        if title and collapsedByPlayer[title] and not info.isCollapsed then
            pcall(collapse, index)
        end
    end
    restoring = false
end

function QueueReapply()
    if reapplyQueued or next(collapsedByPlayer) == nil then return end
    reapplyQueued = true
    if C_Timer and C_Timer.After then
        C_Timer.After(0, Reapply)
    else
        Reapply()
    end
end

-- The header hooks need only the quest log API (there from login); the map
-- reset hook waits for the quest map code, which may load later.
local headersHooked, resetHooked = false, false

local function Install()
    if not headersHooked and type(_G.CollapseQuestHeader) == "function"
        and type(_G.ExpandQuestHeader) == "function" and QuestLogAPI() then
        headersHooked = true
        hooksecurefunc("CollapseQuestHeader", function(index, isAuto) Remember(index, true, isAuto) end)
        hooksecurefunc("ExpandQuestHeader", function(index, isAuto) Remember(index, false, isAuto) end)
    end
    if not resetHooked and type(_G.QuestMapFrame_ResetFilters) == "function" then
        resetHooked = true
        hooksecurefunc("QuestMapFrame_ResetFilters", QueueReapply)
    end
    return headersHooked and resetHooked
end

if not Install() then
    local loader = CreateFrame("Frame")
    loader:RegisterEvent("ADDON_LOADED")
    loader:RegisterEvent("PLAYER_LOGIN")
    loader:SetScript("OnEvent", function(self)
        if Install() then
            self:UnregisterAllEvents()
            self:SetScript("OnEvent", nil)
        end
    end)
end
