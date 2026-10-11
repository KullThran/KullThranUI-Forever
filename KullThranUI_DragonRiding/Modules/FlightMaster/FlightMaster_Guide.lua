-- Modules/FlightMaster/FlightMaster_Guide.lua
-- Adventure-guide style window listing every flight point with its distance
-- from the player, discovery state and recorded flight times.
local _, ns = ...
local Mod = ns.Mod
local FM = ns.FM
local L = FM.L
if not Mod then return end

local KT = LibStub("AceAddon-3.0"):GetAddon("KullThranUI")

local WIDTH, HEIGHT = 440, 520
-- Cards: flight master portrait on the left, point details on the right.
local PORTRAIT = 58
local CELL_W, CELL_H = 196, 66
local CELL_GAP = 6
local BADGE = 20
local PAGER_HEIGHT = 26
-- World map flight point pin (bronze winged boot). The neutral variant is
-- the bronze one; each node's own atlas from the map API is the fallback.
local FLIGHT_ATLAS = "TaxiNode_Neutral"
local REFRESH_INTERVAL = 1

local FILTERS = { "ALL", "KNOWN", "UNKNOWN" }
local FILTER_LABELS = { ALL = "All", KNOWN = "Known only", UNKNOWN = "To discover" }
local SORTS = { "DISTANCE", "ZONE" }
local SORT_LABELS = { DISTANCE = "Sort: distance", ZONE = "Sort: zone" }

local guide
local cells = {}

-- ============================================================================
-- DATA SHAPING
-- ============================================================================

local function GuideDB()
    local db = Mod:GetDB()
    db.guide = db.guide or {}
    local gdb = db.guide
    -- v2: open on the learned flight points by default.
    if not gdb.v2 then
        gdb.v2 = true
        gdb.filter = "KNOWN"
        gdb.page = 1
    end
    -- v3: distance is the default order.
    if not gdb.v3 then
        gdb.v3 = true
        gdb.sort = "DISTANCE"
        gdb.page = 1
    end
    return gdb
end

local function NextIn(list, current)
    for i, v in ipairs(list) do
        if v == current then
            return list[(i % #list) + 1]
        end
    end
    return list[1]
end

local function BuildEntries()
    local db = Mod:GetDB()
    local gdb = GuideDB()
    local query = guide and guide.search and guide.search:GetText() or ""
    query = query:lower()
    local playerFaction = FM.PlayerFactionCode()
    local playerContinent = FM.GetPlayerWorldPos()

    -- With nothing learned yet, "Known only" would be an empty page.
    local filter = gdb.filter
    if filter == "KNOWN" then
        local any = false
        for _, node in ipairs(FM.BuildCatalog()) do
            if FM.IsKnown(node) then any = true; break end
        end
        if not any then filter = "ALL" end
    end

    local entries, knownCount, total = {}, 0, 0
    for _, node in ipairs(FM.BuildCatalog()) do
        local factionOk = not (db.hideOppositeFaction and playerFaction and node.faction
            and node.faction ~= 0 and node.faction ~= playerFaction)
        if factionOk then
            local known = FM.IsKnown(node)
            total = total + 1
            if known then knownCount = knownCount + 1 end

            local pass = true
            if filter == "KNOWN" and not known then pass = false end
            if filter == "UNKNOWN" and known then pass = false end
            if gdb.continentOnly and playerContinent and not FM.IsOnPlayerContinent(node) then pass = false end
            if pass and query ~= "" then
                local hay = ((node.name or "") .. " " .. (node.zone or "") .. " " .. (node.continent or "")):lower()
                pass = hay:find(query, 1, true) ~= nil
            end

            if pass then
                local yards, reason = FM.DistanceToNode(node)
                local entry = { node = node, known = known, yards = yards, reason = reason }
                -- At a flight master, show the flight time from here.
                local slot = FM.taxiSlots and FM.taxiSlots[node.key]
                if slot then
                    entry.flightTime, entry.flightSource = FM.GetEstimateForSlot(slot)
                end
                entry.isCurrent = FM.taxiSlots ~= nil and FM.currentNode ~= nil and FM.Key(FM.currentNode) == node.key
                entries[#entries + 1] = entry
            end
        end
    end

    local function byDistance(a, b)
        if a.yards and b.yards then return a.yards < b.yards end
        if a.yards then return true end
        if b.yards then return false end
        return (a.node.name or "") < (b.node.name or "")
    end

    if gdb.sort == "ZONE" then
        table.sort(entries, function(a, b)
            local ca, cb = a.node.continent or "", b.node.continent or ""
            if ca ~= cb then return ca < cb end
            local za, zb = a.node.zone or "", b.node.zone or ""
            if za ~= zb then return za < zb end
            return (a.node.name or "") < (b.node.name or "")
        end)
    else
        table.sort(entries, function(a, b)
            if a.known ~= b.known then return a.known end
            return byDistance(a, b)
        end)
    end

    return entries, knownCount, total
end

-- ============================================================================
-- ROWS
-- ============================================================================

local function HasAtlas(name)
    return type(name) == "string" and name ~= "" and C_Texture and C_Texture.GetAtlasInfo
        and C_Texture.GetAtlasInfo(name) ~= nil
end

local function ApplyFlightIcon(tex, node)
    if HasAtlas(FLIGHT_ATLAS) then
        tex:SetAtlas(FLIGHT_ATLAS)
    elseif node and HasAtlas(node.atlasName) then
        tex:SetAtlas(node.atlasName)
    elseif HasAtlas("FlightPath") then
        tex:SetAtlas("FlightPath")
    else
        tex:SetTexture("Interface\\AddOns\\KullThranUI\\Libraries\\texture\\media\\icons\\FlightMaster.png")
    end
end

local function DistanceLabel(entry)
    if entry.yards then
        return FM.FormatDistance(entry.yards, Mod:GetDB().distanceUnit)
    end
    if entry.reason == "continent" then
        return "|cff888888" .. L("Other continent") .. "|r"
    end
    return "|cff888888" .. L("No position") .. "|r"
end

local function SetWaypoint(node)
    if not (node and node.mapID and node.x and node.y) then return end
    local ok = false
    if C_Map and C_Map.SetUserWaypoint and UiMapPoint and UiMapPoint.CreateFromCoordinates then
        ok = pcall(function()
            C_Map.SetUserWaypoint(UiMapPoint.CreateFromCoordinates(node.mapID, node.x, node.y))
            if C_SuperTrack and C_SuperTrack.SetSuperTrackedUserWaypoint then
                C_SuperTrack.SetSuperTrackedUserWaypoint(true)
            end
        end)
    end
    if ok then
        print("|cff00ccffKullThranUI|r " .. string.format(L("Waypoint set: %s"), node.name))
    elseif WorldMapFrame and WorldMapFrame.SetMapID then
        if not WorldMapFrame:IsShown() and ToggleWorldMap then ToggleWorldMap() end
        pcall(WorldMapFrame.SetMapID, WorldMapFrame, node.mapID)
    end
end

local function RowTooltip(row)
    local entry = row.entry
    if not entry or not entry.node then return end
    local node = entry.node
    GameTooltip:SetOwner(row, "ANCHOR_RIGHT")
    GameTooltip:AddLine(node.name, 1, 0.82, 0)
    GameTooltip:AddLine(string.format("%s, %s", node.zone or "?", node.continent or "?"), 0.8, 0.8, 0.8)
    local npc = FM.GetFlightMasterNPC(node)
    if npc and npc.name then
        GameTooltip:AddDoubleLine(L("Flight master"), npc.name, 0.8, 0.8, 0.8, 1, 0.82, 0)
        if npc.title then
            GameTooltip:AddDoubleLine(" ", "<" .. npc.title .. ">", 0.8, 0.8, 0.8, 0.7, 0.7, 0.7)
        end
    end
    GameTooltip:AddDoubleLine(entry.known and L("Known") or L("Undiscovered"), FM.FactionLabel(node.faction),
        entry.known and 0.3 or 0.6, entry.known and 1 or 0.6, entry.known and 0.3 or 0.6, 0.8, 0.8, 0.8)
    if node.x and node.y then
        GameTooltip:AddDoubleLine(L("Position"), string.format("%.1f, %.1f", node.x * 100, node.y * 100),
            0.8, 0.8, 0.8, 1, 1, 1)
    end
    GameTooltip:AddDoubleLine(L("Distance"), DistanceLabel(entry), 0.8, 0.8, 0.8, 1, 1, 1)

    local to, from = FM.GetTimingsFor(node.key)
    if #to > 0 or #from > 0 then
        if #to > 0 then
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine(L("Recorded flights to here"), 1, 0.82, 0)
            for i = 1, math.min(#to, 6) do
                GameTooltip:AddDoubleLine(to[i].other, FM.FormatTime(to[i].timing.avg), 1, 1, 1, 1, 1, 1)
            end
        end
        if #from > 0 then
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine(L("Recorded flights from here"), 1, 0.82, 0)
            for i = 1, math.min(#from, 6) do
                GameTooltip:AddDoubleLine(from[i].other, FM.FormatTime(from[i].timing.avg), 1, 1, 1, 1, 1, 1)
            end
        end
    else
        GameTooltip:AddLine(L("No recorded flights yet."), 0.6, 0.6, 0.6)
    end
    GameTooltip:AddLine(" ")
    GameTooltip:AddLine(L("Click: set waypoint"), 0.6, 0.6, 0.6)
    GameTooltip:Show()
end

local BORDER_IDLE = { 0, 0, 0, 1 }

-- Portrait of the point's flight master. NPCs are learned on each visit; until
-- then (or if the client has not cached the creature) the bronze boot fills in.
local function UpdatePortrait(cell, entry)
    local npc = FM.GetFlightMasterNPC(entry.node)
    local useUnit = entry.isCurrent and UnitExists and UnitExists("npc")
    -- Display IDs render from client data; creature IDs need the creature
    -- cache, so they are only the fallback.
    local wanted = (useUnit and "unit") or (npc and npc.display and ("d" .. npc.display))
        or (npc and npc.id and ("c" .. npc.id)) or nil
    if cell.portraitKey ~= wanted then
        cell.portraitKey = wanted
        cell.modelLoaded = false
        cell.model:ClearModel()
        if useUnit then
            cell.model:SetUnit("npc")
        elseif npc and npc.display and cell.model.SetDisplayInfo then
            cell.model:SetDisplayInfo(npc.display)
        elseif npc and npc.id then
            cell.model:SetCreature(npc.id)
        end
        if wanted then
            cell.model:SetPortraitZoom(0.85)
        end
    end
    -- Until a model has actually loaded, the bronze boot fills the portrait.
    local hasModel = wanted ~= nil and cell.modelLoaded
    cell.model:SetShown(wanted ~= nil)
    cell.bigIcon:SetShown(not hasModel)
    cell.badge:SetShown(hasModel)
    ApplyFlightIcon(cell.bigIcon, entry.node)
    ApplyFlightIcon(cell.badge, entry.node)

    local tint = entry.known and 1 or 0.45
    cell.bigIcon:SetDesaturated(not entry.known)
    cell.bigIcon:SetVertexColor(tint, tint, tint, 1)
    cell.badge:SetDesaturated(not entry.known)
    -- Unlearned points keep a dimmed, silhouetted portrait.
    if cell.model.SetModelAlpha then cell.model:SetModelAlpha(entry.known and 1 or 0.55) end
    cell.model:SetAlpha(entry.known and 1 or 0.6)
    return npc
end

local function CreateCell(parent)
    local cell = CreateFrame("Button", nil, parent, "BackdropTemplate")
    cell:SetSize(CELL_W, CELL_H)
    cell:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8x8", edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1 })
    cell:SetBackdropColor(0, 0, 0, 0.35)
    cell:SetBackdropBorderColor(unpack(BORDER_IDLE))

    cell.frame = CreateFrame("Frame", nil, cell, "BackdropTemplate")
    cell.frame:SetSize(PORTRAIT, PORTRAIT)
    cell.frame:SetPoint("LEFT", cell, "LEFT", 4, 0)
    cell.frame:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8x8", edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1 })
    cell.frame:SetBackdropColor(0.04, 0.035, 0.03, 0.9)
    cell.frame:SetBackdropBorderColor(0, 0, 0, 1)

    cell.model = CreateFrame("PlayerModel", nil, cell.frame)
    cell.model:SetPoint("TOPLEFT", 1, -1)
    cell.model:SetPoint("BOTTOMRIGHT", -1, 1)
    cell.model:SetScript("OnModelLoaded", function(self)
        cell.modelLoaded = true
        self:SetPortraitZoom(0.85)
        cell.bigIcon:Hide()
        cell.badge:Show()
    end)

    cell.bigIcon = cell.frame:CreateTexture(nil, "ARTWORK")
    cell.bigIcon:SetSize(PORTRAIT - 14, PORTRAIT - 14)
    cell.bigIcon:SetPoint("CENTER")

    -- Small bronze boot on the portrait corner, like the world map pin.
    local badgeHolder = CreateFrame("Frame", nil, cell)
    badgeHolder:SetAllPoints(cell.frame)
    badgeHolder:SetFrameLevel(cell.model:GetFrameLevel() + 2)
    cell.badge = badgeHolder:CreateTexture(nil, "OVERLAY")
    cell.badge:SetSize(BADGE, BADGE)
    cell.badge:SetPoint("BOTTOMLEFT", cell.frame, "BOTTOMLEFT", -4, -4)

    local textLeft = PORTRAIT + 12
    cell.name = cell:CreateFontString(nil, "OVERLAY")
    cell.name:SetPoint("TOPLEFT", cell, "TOPLEFT", textLeft, -6)
    cell.name:SetPoint("RIGHT", cell, "RIGHT", -6, 0)
    cell.name:SetJustifyH("LEFT")
    cell.name:SetWordWrap(false)

    cell.npc = cell:CreateFontString(nil, "OVERLAY")
    cell.npc:SetPoint("TOPLEFT", cell.name, "BOTTOMLEFT", 0, -2)
    cell.npc:SetPoint("RIGHT", cell, "RIGHT", -6, 0)
    cell.npc:SetJustifyH("LEFT")
    cell.npc:SetWordWrap(false)

    cell.dist = cell:CreateFontString(nil, "OVERLAY")
    cell.dist:SetPoint("BOTTOMLEFT", cell, "BOTTOMLEFT", textLeft, 6)
    cell.dist:SetJustifyH("LEFT")

    cell.time = cell:CreateFontString(nil, "OVERLAY")
    cell.time:SetPoint("BOTTOMRIGHT", cell, "BOTTOMRIGHT", -6, 6)
    cell.time:SetJustifyH("RIGHT")

    cell:SetScript("OnEnter", function(self)
        local r, g, b = Mod:GetAccentColor()
        self:SetBackdropBorderColor(r, g, b, 1)
        self:SetBackdropColor(r * 0.25, g * 0.25, b * 0.25, 0.5)
        RowTooltip(self)
    end)
    cell:SetScript("OnLeave", function(self)
        self:SetBackdropBorderColor(unpack(BORDER_IDLE))
        self:SetBackdropColor(0, 0, 0, 0.35)
        GameTooltip:Hide()
    end)
    cell:SetScript("OnClick", function(self)
        if self.entry and self.entry.node then SetWaypoint(self.entry.node) end
    end)
    return cell
end

local function StyleCellFonts(cell)
    local size = Mod:GetDB().fontSize or 12
    Mod.SetFont(cell.name, math.max(8, size))
    Mod.SetFont(cell.npc, math.max(7, size - 2))
    Mod.SetFont(cell.dist, math.max(7, size - 2))
    Mod.SetFont(cell.time, math.max(7, size - 2))
end

local function GridMetrics()
    local w = math.max(CELL_W, guide.grid:GetWidth() or 0)
    local h = math.max(CELL_H, guide.grid:GetHeight() or 0)
    local cols = math.max(1, math.floor((w + CELL_GAP) / (CELL_W + CELL_GAP)))
    local rowsPerPage = math.max(1, math.floor((h + CELL_GAP) / (CELL_H + CELL_GAP)))
    return cols, rowsPerPage
end

local function RenderGrid(entries)
    local gdb = GuideDB()
    local cols, rowsPerPage = GridMetrics()
    local perPage = cols * rowsPerPage
    local pages = math.max(1, math.ceil(#entries / perPage))
    gdb.page = math.max(1, math.min(tonumber(gdb.page) or 1, pages))
    local first = (gdb.page - 1) * perPage + 1

    -- Center the grid horizontally inside the list area.
    local usedW = cols * CELL_W + (cols - 1) * CELL_GAP
    local left = math.max(0, math.floor(((guide.grid:GetWidth() or usedW) - usedW) / 2))

    local shown = 0
    for i = first, math.min(#entries, first + perPage - 1) do
        shown = shown + 1
        local entry = entries[i]
        local cell = cells[shown]
        if not cell then
            cell = CreateCell(guide.grid)
            cells[shown] = cell
        end
        if cell.fontSize ~= Mod:GetDB().fontSize then
            StyleCellFonts(cell)
            cell.fontSize = Mod:GetDB().fontSize
        end
        local col = (shown - 1) % cols
        local row = math.floor((shown - 1) / cols)
        cell:ClearAllPoints()
        cell:SetPoint("TOPLEFT", guide.grid, "TOPLEFT", left + col * (CELL_W + CELL_GAP), -row * (CELL_H + CELL_GAP))
        cell.entry = entry

        local npc = UpdatePortrait(cell, entry)
        cell.name:SetText(entry.node.name)
        cell.dist:SetText(DistanceLabel(entry))
        if npc and npc.name then
            cell.npc:SetText(npc.name)
        else
            cell.npc:SetText(entry.node.zone or "")
        end
        if entry.known then
            cell.name:SetTextColor(1, 0.82, 0)
            cell.npc:SetTextColor(0.85, 0.85, 0.85)
        else
            cell.name:SetTextColor(0.6, 0.6, 0.6)
            cell.npc:SetTextColor(0.5, 0.5, 0.5)
        end
        if entry.flightTime then
            cell.time:SetText(FM.FormatTime(entry.flightTime))
            cell.time:SetTextColor(1, 0.82, 0)
        elseif entry.isCurrent then
            cell.time:SetText(L("You are here"))
            cell.time:SetTextColor(0.2, 1, 0.33)
        else
            cell.time:SetText("")
        end
        cell:Show()
    end
    for i = shown + 1, #cells do
        cells[i]:Hide()
        cells[i].entry = nil
    end

    guide.pageText:SetText(string.format("%d / %d", gdb.page, pages))
    guide.prevBtn:SetEnabled(gdb.page > 1)
    guide.nextBtn:SetEnabled(gdb.page < pages)
    guide.prevBtn:SetAlpha(gdb.page > 1 and 1 or 0.4)
    guide.nextBtn:SetAlpha(gdb.page < pages and 1 or 0.4)
    guide.empty:SetShown(#entries == 0)
end

-- ============================================================================
-- WINDOW
-- ============================================================================

local ICON_PATH = "Interface\\AddOns\\KullThranUI\\Libraries\\texture\\media\\icons\\"

-- KullThranUI nav-tab buttons (KT.NavTabs) instead of the red Blizzard ones.
local function CreateCycleButton(parent, width)
    local btn = CreateFrame("Button", nil, parent)
    btn:SetSize(width, 22)
    if KT.NavTabs and KT.NavTabs.StyleButton then
        KT.NavTabs.StyleButton(btn, { label = "", fontSize = 10 })
    else
        btn.fallbackText = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        btn.fallbackText:SetPoint("CENTER")
    end
    return btn
end

local function SetButtonLabel(btn, text, selected)
    if btn._ktNav and KT.NavTabs then
        KT.NavTabs.SetLabel(btn, text)
        KT.NavTabs.SetState(btn, selected)
    elseif btn.fallbackText then
        btn.fallbackText:SetText(text)
    end
end

local function UpdateControlLabels()
    local gdb = GuideDB()
    SetButtonLabel(guide.filterBtn, L(FILTER_LABELS[gdb.filter] or "All"), gdb.filter ~= "ALL")
    SetButtonLabel(guide.continentBtn, gdb.continentOnly and L("This continent") or L("All continents"), gdb.continentOnly)
    SetButtonLabel(guide.sortBtn, L(SORT_LABELS[gdb.sort] or "Sort: distance"), false)
end

function Mod:ApplyGuideStyle()
    if not guide then return end
    local r, g, b = self:GetAccentColor()
    -- Border only: the background is the KullThranUI Skins surface texture.
    guide:SetBackdrop({ edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1 })
    guide:SetBackdropBorderColor(r, g, b, 1)
    local S = KT:GetModule("Skins", true)
    if S and S.ApplyKuiSurface then
        -- Applied once; Skins re-tints it when the window color changes.
        if not guide.kuiSurface then
            guide.kuiSurface = true
            S:ApplyKuiSurface(guide, { flat = guide })
        end
    elseif KT.ApplyTexturedSurface then
        KT:ApplyTexturedSurface(guide, nil, 0.55)
    else
        guide:SetBackdrop({ bgFile = "Interface\\ChatFrame\\ChatFrameBackground", edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1 })
        guide:SetBackdropColor(0.06, 0.06, 0.08, 0.96)
        guide:SetBackdropBorderColor(r, g, b, 1)
    end
    guide.titleBar:SetColorTexture(r, g, b, 0.18)
    self.SetFont(guide.pageText, math.max(8, (self:GetDB().fontSize or 12) - 1))
    if KT.AddBackdrop then KT:AddBackdrop(guide.search, 0.02, 0.02, 0.03, 0.85) end
    if KT.AddBorder then KT:AddBorder(guide.search, r, g, b, 0.6) end
    self.SetFont(guide.search, math.max(8, (self:GetDB().fontSize or 12) - 1))
    self.SetFont(guide.search.placeholder, math.max(8, (self:GetDB().fontSize or 12) - 1))
    guide.search.placeholder:SetText(L("Search..."))
    if guide:IsShown() then UpdateControlLabels() end
    self.SetFont(guide.title, (self:GetDB().fontSize or 12) + 3)
    guide.title:SetText(L("Flight Points"))
    self.SetFont(guide.summary, math.max(8, (self:GetDB().fontSize or 12) - 1))
    self.SetFont(guide.nearest, math.max(8, (self:GetDB().fontSize or 12) - 1))
    self.SetFont(guide.empty, self:GetDB().fontSize or 12)
    for _, cell in ipairs(cells) do
        cell.fontSize = nil
    end
end

local function BuildGuide()
    if guide then return guide end

    guide = CreateFrame("Frame", "KT_FlightMasterGuide", UIParent, "BackdropTemplate")
    guide:SetSize(WIDTH, HEIGHT)
    guide:SetFrameStrata("HIGH")
    guide:SetClampedToScreen(true)
    guide:SetMovable(true)
    guide:EnableMouse(true)
    guide:RegisterForDrag("LeftButton")
    guide:SetScript("OnDragStart", function(self)
        if self.mode ~= "embedded" then self:StartMoving() end
    end)
    guide:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        if self.mode == "standalone" then
            local point, _, relativePoint, x, y = self:GetPoint(1)
            GuideDB().point = { point, relativePoint, x, y }
        end
    end)
    guide:Hide()
    guide:SetPoint("CENTER", UIParent, "CENTER", 0, 40)

    guide.titleBar = guide:CreateTexture(nil, "ARTWORK")
    guide.titleBar:SetPoint("TOPLEFT", 1, -1)
    guide.titleBar:SetPoint("TOPRIGHT", -1, -1)
    guide.titleBar:SetHeight(30)

    guide.title = guide:CreateFontString(nil, "OVERLAY")
    guide.title:SetPoint("TOPLEFT", guide, "TOPLEFT", 12, -8)
    guide.title:SetTextColor(1, 1, 1)

    local close = CreateFrame("Button", nil, guide)
    close:SetSize(24, 24)
    close:SetPoint("TOPRIGHT", guide, "TOPRIGHT", -4, -3)
    close.tex = close:CreateTexture(nil, "ARTWORK")
    close.tex:SetSize(14, 14)
    close.tex:SetPoint("CENTER")
    close.tex:SetTexture(ICON_PATH .. "kui-close.png")
    close:SetScript("OnClick", function() guide:Hide() end)
    close:SetScript("OnEnter", function(self) self.tex:SetVertexColor(1, 0.3, 0.3, 1) end)
    close:SetScript("OnLeave", function(self) self.tex:SetVertexColor(1, 1, 1, 1) end)
    guide.closeBtn = close

    guide.summary = guide:CreateFontString(nil, "OVERLAY")
    guide.summary:SetPoint("TOPLEFT", guide, "TOPLEFT", 12, -38)
    guide.summary:SetPoint("RIGHT", guide, "RIGHT", -12, 0)
    guide.summary:SetJustifyH("LEFT")
    guide.summary:SetTextColor(0.85, 0.85, 0.85)

    guide.nearest = guide:CreateFontString(nil, "OVERLAY")
    guide.nearest:SetPoint("TOPLEFT", guide.summary, "BOTTOMLEFT", 0, -4)
    guide.nearest:SetPoint("RIGHT", guide, "RIGHT", -12, 0)
    guide.nearest:SetJustifyH("LEFT")
    guide.nearest:SetTextColor(0.85, 0.85, 0.85)

    local search = CreateFrame("EditBox", nil, guide, "BackdropTemplate")
    search:SetHeight(22)
    search:SetPoint("TOPLEFT", guide, "TOPLEFT", 12, -76)
    search:SetPoint("RIGHT", guide, "RIGHT", -12, 0)
    search:SetAutoFocus(false)
    search:SetTextInsets(8, 8, 0, 0)
    search:SetFont("Fonts\\FRIZQT__.TTF", 11, "")
    search:SetTextColor(1, 1, 1)
    search:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)
    search:SetScript("OnTextChanged", function() GuideDB().page = 1; Mod:RefreshGuide() end)
    search:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
    search.placeholder = search:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    search.placeholder:SetPoint("LEFT", search, "LEFT", 8, 0)
    search.placeholder:SetTextColor(0.55, 0.55, 0.58)
    search:HookScript("OnTextChanged", function(self)
        self.placeholder:SetShown(self:GetText() == "")
    end)
    guide.search = search

    local btnWidth = math.floor((WIDTH - 32) / 3)
    guide:SetScript("OnSizeChanged", function(self, w)
        local bw = math.floor(((w or WIDTH) - 32) / 3)
        self.filterBtn:SetWidth(bw)
        self.continentBtn:SetWidth(bw)
        self.sortBtn:SetWidth(bw)
        if self:IsShown() then Mod:RefreshGuide() end
    end)
    guide.filterBtn = CreateCycleButton(guide, btnWidth)
    guide.filterBtn:SetPoint("TOPLEFT", guide, "TOPLEFT", 12, -102)
    guide.filterBtn:SetScript("OnClick", function()
        local gdb = GuideDB()
        gdb.filter = NextIn(FILTERS, gdb.filter)
        gdb.page = 1
        Mod:RefreshGuide()
    end)

    guide.continentBtn = CreateCycleButton(guide, btnWidth)
    guide.continentBtn:SetPoint("LEFT", guide.filterBtn, "RIGHT", 4, 0)
    guide.continentBtn:SetScript("OnClick", function()
        local gdb = GuideDB()
        gdb.continentOnly = not gdb.continentOnly
        gdb.page = 1
        Mod:RefreshGuide()
    end)

    guide.sortBtn = CreateCycleButton(guide, btnWidth)
    guide.sortBtn:SetPoint("LEFT", guide.continentBtn, "RIGHT", 4, 0)
    guide.sortBtn:SetScript("OnClick", function()
        local gdb = GuideDB()
        gdb.sort = NextIn(SORTS, gdb.sort)
        gdb.page = 1
        Mod:RefreshGuide()
    end)

    local listBg = CreateFrame("Frame", nil, guide, "BackdropTemplate")
    listBg:SetPoint("TOPLEFT", guide, "TOPLEFT", 10, -130)
    listBg:SetPoint("BOTTOMRIGHT", guide, "BOTTOMRIGHT", -10, 10)
    listBg:SetBackdrop({ bgFile = "Interface\\ChatFrame\\ChatFrameBackground", edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1 })
    listBg:SetBackdropColor(0, 0, 0, 0.2)
    listBg:SetBackdropBorderColor(0, 0, 0, 0.6)

    -- Paged grid of square flight point buttons.
    local grid = CreateFrame("Frame", nil, listBg)
    grid:SetPoint("TOPLEFT", listBg, "TOPLEFT", 8, -8)
    grid:SetPoint("BOTTOMRIGHT", listBg, "BOTTOMRIGHT", -8, PAGER_HEIGHT + 6)
    grid:SetScript("OnSizeChanged", function() if guide:IsShown() then Mod:RefreshGuide() end end)
    grid:EnableMouseWheel(true)
    grid:SetScript("OnMouseWheel", function(_, delta)
        local gdb = GuideDB()
        gdb.page = (tonumber(gdb.page) or 1) - delta
        Mod:RefreshGuide()
    end)
    guide.grid = grid

    local function PageButton(label, delta)
        local btn = CreateCycleButton(listBg, 34)
        btn:SetHeight(20)
        SetButtonLabel(btn, label, false)
        btn:SetScript("OnClick", function()
            local gdb = GuideDB()
            gdb.page = (tonumber(gdb.page) or 1) + delta
            Mod:RefreshGuide()
        end)
        return btn
    end
    guide.pageText = listBg:CreateFontString(nil, "OVERLAY")
    guide.pageText:SetPoint("BOTTOM", listBg, "BOTTOM", 0, 9)
    guide.pageText:SetTextColor(0.85, 0.85, 0.85)
    guide.prevBtn = PageButton("<", -1)
    guide.prevBtn:SetPoint("RIGHT", guide.pageText, "LEFT", -10, 0)
    guide.nextBtn = PageButton(">", 1)
    guide.nextBtn:SetPoint("LEFT", guide.pageText, "RIGHT", 10, 0)

    guide.empty = listBg:CreateFontString(nil, "OVERLAY")
    guide.empty:SetPoint("TOPLEFT", listBg, "TOPLEFT", 12, -12)
    guide.empty:SetPoint("RIGHT", listBg, "RIGHT", -12, 0)
    guide.empty:SetJustifyH("LEFT")
    guide.empty:SetTextColor(0.7, 0.7, 0.7)
    guide.empty:Hide()

    guide:SetScript("OnShow", function()
        FM.Invalidate()
        Mod:RefreshGuide()
        if guide.ticker then guide.ticker:Cancel() end
        guide.ticker = C_Timer.NewTicker(REFRESH_INTERVAL, function()
            if not guide:IsShown() then return end
            -- Keep a stable list while the cursor is over it.
            if guide.grid:IsMouseOver() and GuideDB().sort == "DISTANCE" then
                Mod:RefreshGuide(true)
            else
                Mod:RefreshGuide()
            end
        end)
    end)
    guide:SetScript("OnHide", function()
        if guide.ticker then guide.ticker:Cancel(); guide.ticker = nil end
    end)

    Mod.guideFrame = guide
    Mod:ApplyGuideStyle()
    return guide
end

-- distancesOnly: update the distance column in place without re-sorting.
function Mod:RefreshGuide(distancesOnly)
    if not guide or not guide:IsShown() then return end
    UpdateControlLabels()

    if distancesOnly then
        for _, cell in ipairs(cells) do
            local entry = cell:IsShown() and cell.entry
            if entry and entry.node then
                entry.yards, entry.reason = FM.DistanceToNode(entry.node)
                cell.dist:SetText(DistanceLabel(entry))
            end
        end
        return
    end

    local entries, knownCount, total = BuildEntries()
    local zone = GetRealZoneText and GetRealZoneText() or ""
    guide.summary:SetText(string.format(L("%d of %d known"), knownCount, total) .. (zone ~= "" and ("  ·  " .. zone) or ""))

    local nearest, nearestYards = FM.GetNearestKnown()
    if nearest then
        guide.nearest:SetText(string.format("%s: |cffffffff%s|r  (%s)", L("Nearest known"), nearest.name,
            FM.FormatDistance(nearestYards, self:GetDB().distanceUnit)))
    else
        guide.nearest:SetText(L("Visit a flight master to finish the list."))
    end

    local emptyText = L("No flight points match the filters.")
    if total == 0 then
        emptyText = L("Visit a flight master to finish the list.")
    elseif GuideDB().filter == "UNKNOWN" and knownCount == total then
        emptyText = L("You already know every flight point of your faction.")
    end
    guide.empty:SetText(emptyText)
    RenderGrid(entries)
end

-- ============================================================================
-- PLACEMENT: standalone window, flight master popup, or embedded in the
-- KullThranUI options page. One frame is reparented between the three.
-- ============================================================================

local function SetEscapeClosable(enabled)
    for i = #UISpecialFrames, 1, -1 do
        if UISpecialFrames[i] == "KT_FlightMasterGuide" then table.remove(UISpecialFrames, i) end
    end
    if enabled then tinsert(UISpecialFrames, "KT_FlightMasterGuide") end
end

local function Float(strata, level)
    SetEscapeClosable(true)
    guide:SetParent(UIParent)
    guide:SetFrameStrata(strata)
    if level then guide:SetFrameLevel(level) end
    guide:SetToplevel(true)
    guide:SetSize(WIDTH, HEIGHT)
    guide:SetMovable(true)
    guide:SetClampedToScreen(true)
    guide.closeBtn:Show()
end

local function PlaceStandalone()
    Float("HIGH")
    guide.mode = "standalone"
    guide:ClearAllPoints()
    local saved = GuideDB().point
    if type(saved) == "table" and saved[1] then
        guide:SetPoint(saved[1], UIParent, saved[2] or saved[1], saved[3] or 0, saved[4] or 0)
    else
        guide:SetPoint("CENTER", UIParent, "CENTER", 0, 40)
    end
end

local function GetOpenTaxiFrame()
    for _, name in ipairs({ "FlightMapFrame", "TaxiFrame" }) do
        local f = _G[name]
        if f and f.IsShown and f:IsShown() then return f end
    end
end

-- The flight map border uses HIGH strata, so the popup sits on DIALOG.
local function PlaceAtTaxi()
    Float("DIALOG", 50)
    guide.mode = "taxi"
    guide:ClearAllPoints()
    local anchor = GetOpenTaxiFrame()
    if anchor and anchor:GetRight() then
        if anchor:GetRight() + WIDTH + 8 <= UIParent:GetRight() then
            guide:SetPoint("TOPLEFT", anchor, "TOPRIGHT", 6, 0)
        else
            guide:SetPoint("TOPRIGHT", anchor, "TOPLEFT", -6, 0)
        end
    else
        guide:SetPoint("RIGHT", UIParent, "RIGHT", -40, 0)
    end
    guide:Raise()
end

function Mod:ToggleGuide(show)
    local g = BuildGuide()
    if show == nil then show = not (g:IsShown() and g.mode ~= "embedded") end
    if show then
        if g.mode ~= "standalone" then
            g:Hide()
            PlaceStandalone()
        end
        g:Show()
    else
        g:Hide()
    end
end

function Mod:ShowGuideAtTaxi()
    local g = BuildGuide()
    -- Never steal the guide from an open KullThranUI options page.
    if g.mode == "embedded" and g:IsVisible() then return end
    g:Hide()
    PlaceAtTaxi()
    g:Show()
end

function Mod:HideGuideFromTaxi()
    if guide and guide.mode == "taxi" then
        guide:Hide()
        -- Hand the guide back to the options page if it is open.
        local holder = guide.embedHolder
        if holder and holder:IsVisible() then
            self:EmbedGuide(holder, guide.embedW, guide.embedH)
        end
    end
end

function Mod:EmbedGuide(parent, width, height)
    local g = BuildGuide()
    g:Hide()
    g:SetParent(parent)
    g:SetFrameStrata(parent:GetFrameStrata())
    g:SetFrameLevel(parent:GetFrameLevel() + 5)
    g:SetToplevel(false)
    g:SetMovable(false)
    g:SetClampedToScreen(false)
    g:SetSize(width, height)
    g:ClearAllPoints()
    g:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, 0)
    g.closeBtn:Hide()
    g.mode = "embedded"
    g.embedHolder, g.embedW, g.embedH = parent, width, height
    SetEscapeClosable(false)
    -- Re-show (or take back from the flight master popup / standalone window)
    -- whenever the options page becomes visible again.
    if not parent._ktFlightGuideHooked then
        parent._ktFlightGuideHooked = true
        parent:HookScript("OnShow", function(self)
            if not guide or guide.embedHolder ~= self then return end
            if guide.mode == "embedded" and guide:GetParent() == self then
                if not guide:IsShown() then guide:Show() end
            elseif not (guide.mode == "taxi" and guide:IsShown()) then
                Mod:EmbedGuide(self, guide.embedW, guide.embedH)
            end
        end)
    end
    g:Show()
    return g
end
