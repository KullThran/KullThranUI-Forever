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
-- Cards: round flight master portrait on the left, point details on the right
-- (see LOOK below).
local CELL_W, CELL_H = 196, 66
local CELL_GAP = 6
local BADGE = 16
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

-- Arrow created by the last click, so the next click replaces it instead of
-- piling waypoints up.
local tomtomWaypoint

-- Waypoint arrow: a waypoint with the flight master's coordinates and the arrow pointing
-- at it. Coordinates are normalized (0-1), which is what the waypoint API expects.
local function SetTomTomArrow(node)
    local tomtom = _G.TomTom
    if not (tomtom and tomtom.AddWaypoint) then return false end
    local ok, uid = pcall(function()
        if tomtomWaypoint and tomtom.RemoveWaypoint then
            pcall(tomtom.RemoveWaypoint, tomtom, tomtomWaypoint)
        end
        tomtomWaypoint = nil
        return tomtom:AddWaypoint(node.mapID, node.x, node.y, {
            title = node.name,
            from = "KullThranUI",
            persistent = false,
            minimap = true,
            world = true,
            crazy = true,
            silent = true,
        })
    end)
    if not (ok and uid) then return false end
    tomtomWaypoint = uid
    -- AddWaypoint returns an existing waypoint untouched; make sure the arrow follows it.
    if tomtom.SetCrazyArrow then
        local arrival = tomtom.profile and tomtom.profile.arrow and tomtom.profile.arrow.arrival or 10
        pcall(tomtom.SetCrazyArrow, tomtom, uid, arrival, node.name)
    end
    return true
end

-- The card whose waypoint is set (the "toggle on" card) and who holds it.
local activeKey, activeSource, activeNode

-- Returns true when a waypoint was placed (TomTom or the native one).
local function SetWaypoint(node)
    if not (node and node.mapID and node.x and node.y) then return false end
    if SetTomTomArrow(node) then
        activeKey, activeSource, activeNode = node.key, "tomtom", node
        print("|cff00ccffKullThranUI|r " .. string.format(L("Waypoint set: %s"),
            string.format("%s (%.1f, %.1f)", node.name, node.x * 100, node.y * 100)))
        return true
    end
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
        activeKey, activeSource, activeNode = node.key, "native", node
        print("|cff00ccffKullThranUI|r " .. string.format(L("Waypoint set: %s"), node.name))
        return true
    elseif WorldMapFrame and WorldMapFrame.SetMapID then
        if not WorldMapFrame:IsShown() and ToggleWorldMap then ToggleWorldMap() end
        pcall(WorldMapFrame.SetMapID, WorldMapFrame, node.mapID)
    end
    return false
end

local function ClearWaypoint(node)
    if activeSource == "tomtom" then
        local tomtom = _G.TomTom
        if tomtomWaypoint and tomtom and tomtom.RemoveWaypoint then
            pcall(tomtom.RemoveWaypoint, tomtom, tomtomWaypoint)
        end
        tomtomWaypoint = nil
    elseif activeSource == "native" and C_Map and C_Map.ClearUserWaypoint then
        pcall(C_Map.ClearUserWaypoint)
    end
    activeKey, activeSource, activeNode = nil, nil, nil
    if node and node.name then
        print("|cff00ccffKullThranUI|r " .. string.format(L("Waypoint cleared: %s"), node.name))
    end
end

-- The waypoint can go away outside the guide (arrival, the map, TomTom's own
-- menu); the card lets go of it then.
local function ActiveWaypointAlive()
    local node = activeNode
    if not activeKey then return false end
    if activeSource == "tomtom" then
        local tomtom = _G.TomTom
        if not (tomtom and tomtomWaypoint) then return false end
        if tomtom.IsValidWaypoint then
            local ok, valid = pcall(tomtom.IsValidWaypoint, tomtom, tomtomWaypoint)
            if ok then return valid and true or false end
        end
    elseif activeSource == "native" and C_Map and C_Map.HasUserWaypoint then
        if not C_Map.HasUserWaypoint() then return false end
        local point = C_Map.GetUserWaypoint and C_Map.GetUserWaypoint()
        local pos = point and point.position
        if node and pos and point.uiMapID == node.mapID then
            return math.abs(pos.x - node.x) < 0.001 and math.abs(pos.y - node.y) < 0.001
        end
        return point == nil or node == nil
    end
    return true
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
    GameTooltip:AddLine(activeKey == node.key and L("Click again: clear waypoint") or L("Click: set waypoint"),
        0.6, 0.6, 0.6)
    GameTooltip:Show()
end

-- ============================================================================
-- LOOK
-- Two CSS components ported to frames, both lit with the theme accent:
--   * Cards (spin button): a squircle key, #111215, inside a 3px dark #0005
--     rim. A linear gradient of two accent shades turns behind it and shows
--     along the rim; the key face stays flat so the text reads cleanly. It rests
--     at half strength and paused; it turns (and slowly breathes in scale)
--     while hovered, and goes full strength while pressed or while the card's
--     waypoint is set. A second click on that card clears the waypoint.
--   * Window (spin card): #111215 body 2px inside a dark #0005 border; the
--     same turning gradient glows along that border and blurs outward. A
--     #0b0d10 header holds the breadcrumb, outlined icon controls and the
--     filter tabs (accent underline); the cards sit in a 1px #343539 list.
-- The CSS turns every 8s; here the window takes 18s and a hovered card 12s,
-- and the breathing that took 4s takes 8s.
-- ============================================================================

local MEDIA = "Interface\\AddOns\\KullThranUI\\Libraries\\texture\\media\\"
local ICON_PATH = MEDIA .. "icons\\"
local WHITE_TEX = "Interface\\Buttons\\WHITE8x8"
local OUTER_TEX = MEDIA .. "FlightCardOuter.tga"   -- card outline, drawn for CELL_W x CELL_H
local INNER_TEX = MEDIA .. "FlightCardInner.tga"   -- key face, drawn for the size inside RIM
local RAMP_TEX = MEDIA .. "FlightSpinRamp.tga"     -- one side of the turning gradient
local ROUND_TEX = MEDIA .. "FlightRound.tga"       -- rounded rect, corner 48/128
local GLOW_TEX = MEDIA .. "NavButtonGlow.tga"      -- soft glow 9-slice
local DISC_TEX = MEDIA .. "PortalRound.tga"        -- antialiased disc
local ROUND_C = 48 / 128

local RIM = 3
local SPIN_SIZE = 280            -- covers the card diagonal at 0.75 scale
local CARD_PERIOD = 12
local WINDOW_PERIOD = 18
local BREATH_PERIOD = 8
local PFP = 46                   -- round portrait in the key's left cap
local PFP_CENTER = CELL_H / 2
local TEXT_LEFT = PFP_CENTER + PFP / 2 + 9
local TEXT_RIGHT = 24

local WINDOW_RADIUS = 16
local BORDER = 2
local HEADER_H = 72              -- top row 40 + tab row 32
local TAB_ROW = 40
local LIST_TOP = 114
local LIST_INSET = 6
local RING_SEGMENTS = 10

local BODY = { 0x11 / 255, 0x12 / 255, 0x15 / 255 }        -- #111215
local HEADER = { 0x0b / 255, 0x0d / 255, 0x10 / 255 }      -- #0b0d10
local HEADER_LINE = { 0x1d / 255, 0x1f / 255, 0x23 / 255 } -- #1d1f23
local LIST_LINE = { 0x34 / 255, 0x35 / 255, 0x39 / 255 }   -- #343539
local OUTLINE = { 0x30 / 255, 0x32 / 255, 0x36 / 255 }     -- #303236
local MUTED = { 0x79 / 255, 0x7d / 255, 0x86 / 255 }       -- #797d86
local SOFT = { 0xbe / 255, 0xbe / 255, 0xbe / 255 }        -- #bebebe

local TAU = 0.08                 -- the CSS 0.3s transitions

-- ---------------------------------------------------------------- helpers

local function Lerp(a, b, f) return a + (b - a) * f end

local function NoSnap(tex)
    if tex.SetSnapToPixelGrid then tex:SetSnapToPixelGrid(false) end
    if tex.SetTexelSnappingBias then tex:SetTexelSnappingBias(0) end
    return tex
end

local function Clip(frame)
    if frame.SetClipsChildren then frame:SetClipsChildren(true) end
end

local function Approach(value, target, dt)
    local v = value + (target - value) * (1 - math.exp(-dt / TAU))
    if math.abs(target - v) < 0.004 then v = target end
    return v
end

-- Accent and accent mixed toward white.
local function Tone(f)
    local r, g, b = Mod:GetAccentColor()
    return { r + (1 - r) * f, g + (1 - g) * f, b + (1 - b) * f }
end

-- The CSS easing of each half turn: cubic-bezier(0.56, 0.15, 0.28, 0.86).
local function Bezier(x1, y1, x2, y2)
    local function at(a1, a2, t)
        local u = 1 - t
        return 3 * u * u * t * a1 + 3 * u * t * t * a2 + t * t * t
    end
    local function slope(a1, a2, t)
        local u = 1 - t
        return 3 * u * u * a1 + 6 * u * t * (a2 - a1) + 3 * t * t * (1 - a2)
    end
    return function(x)
        local t = x
        for _ = 1, 6 do
            local s = slope(x1, x2, t)
            if math.abs(s) < 1e-5 then break end
            t = math.max(0, math.min(1, t - (at(x1, x2, t) - x) / s))
        end
        return at(y1, y2, t)
    end
end
local SpinEase = Bezier(0.56, 0.15, 0.28, 0.86)

-- speen: 10deg -> 190deg -> 370deg, each half eased.
local function SpinAngle(phase)
    if phase < 0.5 then
        return math.rad(10 + 180 * SpinEase(phase * 2))
    end
    return math.rad(190 + 180 * SpinEase((phase - 0.5) * 2))
end

-- 9-slice of FlightRound.tga; `inset` moves it inside `owner`, `squareBottom`
-- drops the bottom corners (a header). Returns tl,t,tr,l,m,r,bl,b,br.
local function Rounded(owner, layer, sub, radius, inset, squareBottom)
    local c = ROUND_C
    local u = { 0, c, 1 - c, 1 }
    local parts = {}
    for row = 1, 3 do
        for col = 1, 3 do
            local t = owner:CreateTexture(nil, layer, nil, sub)
            t:SetTexture(ROUND_TEX)
            t:SetTexCoord(u[col], u[col + 1], u[row], u[row + 1])
            parts[#parts + 1] = t
        end
    end
    local i = inset or 0
    local tl, t, tr, l, m, r, bl, b, br = unpack(parts)
    tl:SetSize(radius, radius); tl:SetPoint("TOPLEFT", owner, "TOPLEFT", i, -i)
    tr:SetSize(radius, radius); tr:SetPoint("TOPRIGHT", owner, "TOPRIGHT", -i, -i)
    t:SetPoint("TOPLEFT", tl, "TOPRIGHT"); t:SetPoint("BOTTOMRIGHT", tr, "BOTTOMLEFT")
    if squareBottom then
        bl:Hide(); b:Hide(); br:Hide()
        l:SetPoint("TOPLEFT", tl, "BOTTOMLEFT"); l:SetPoint("BOTTOMRIGHT", owner, "BOTTOMLEFT", i + radius, i)
        r:SetPoint("TOPRIGHT", tr, "BOTTOMRIGHT"); r:SetPoint("BOTTOMLEFT", owner, "BOTTOMRIGHT", -i - radius, i)
        m:SetPoint("TOPLEFT", tl, "BOTTOMRIGHT"); m:SetPoint("BOTTOMRIGHT", owner, "BOTTOMRIGHT", -i - radius, i)
    else
        bl:SetSize(radius, radius); bl:SetPoint("BOTTOMLEFT", owner, "BOTTOMLEFT", i, i)
        br:SetSize(radius, radius); br:SetPoint("BOTTOMRIGHT", owner, "BOTTOMRIGHT", -i, i)
        b:SetPoint("TOPLEFT", bl, "TOPRIGHT"); b:SetPoint("BOTTOMRIGHT", br, "BOTTOMLEFT")
        l:SetPoint("TOPLEFT", tl, "BOTTOMLEFT"); l:SetPoint("BOTTOMRIGHT", bl, "TOPRIGHT")
        r:SetPoint("TOPLEFT", tr, "BOTTOMLEFT"); r:SetPoint("BOTTOMRIGHT", br, "TOPRIGHT")
        m:SetPoint("TOPLEFT", tl, "BOTTOMRIGHT"); m:SetPoint("BOTTOMRIGHT", br, "TOPLEFT")
    end
    return parts
end

-- FontString with the module font already set: SetText on a FontString
-- without a font raises "Font not set".
local function NewText(parent)
    local fs = parent:CreateFontString(nil, "OVERLAY")
    Mod.SetFont(fs, Mod:GetDB().fontSize or 12)
    return fs
end

local function Tint(parts, c, a)
    for _, t in ipairs(parts) do t:SetVertexColor(c[1], c[2], c[3], a or 1) end
end

-- Outlined control (.icon / search): 1px #303236 rounded outline, header
-- fill, and the white 7% hover layer.
local function Outlined(frame, radius)
    local box = {}
    box.outline = Rounded(frame, "BACKGROUND", 1, radius)
    Tint(box.outline, OUTLINE)
    box.fill = Rounded(frame, "BACKGROUND", 2, radius - 1, 1)
    Tint(box.fill, HEADER)
    box.hover = Rounded(frame, "BACKGROUND", 3, radius - 1, 1)
    Tint(box.hover, { 1, 1, 1 }, 0.07)
    for _, t in ipairs(box.hover) do t:Hide() end
    frame.box = box
    return box
end

local function SetHover(frame, on)
    if not (frame.box and frame.box.hover) then return end
    for _, t in ipairs(frame.box.hover) do t:SetShown(on) end
end

local function SetOutline(frame, c, a)
    if frame.box then Tint(frame.box.outline, c, a) end
end

-- ---------------------------------------------------------------- window light
-- The window can take any size, so its turning light is a 9-slice whose
-- pieces are colored from the gradient instead of a rotated texture: each
-- edge is cut into RING_SEGMENTS pieces with a gradient between their ends.

local SetGradientRGBA
do
    local mode
    SetGradientRGBA = function(tex, orientation, c0, c1)
        if mode == nil then
            mode = (tex.SetGradient and CreateColor and pcall(tex.SetGradient, tex, orientation, c0, c1)) and "color"
                or (tex.SetGradientAlpha and "alpha") or false
            return
        end
        if mode == "color" then
            tex:SetGradient(orientation, c0, c1)
        elseif mode == "alpha" then
            tex:SetGradientAlpha(orientation, c0.r, c0.g, c0.b, c0.a, c1.r, c1.g, c1.b, c1.a)
        end
    end
end

local function NewColor()
    if CreateColor then return CreateColor(1, 1, 1, 0) end
    local c = { r = 1, g = 1, b = 1, a = 0 }
    function c:SetRGBA(r, g, b, a) self.r, self.g, self.b, self.a = r, g, b, a end
    return c
end

-- inside: pieces fill the owner's rounded edge; outside: a glow around it.
local function NewSpinRing(owner, layer, sub, size, outside)
    local ring = { owner = owner, size = size, outside = outside, corners = {}, edges = {} }
    local tex = outside and GLOW_TEX or ROUND_TEX
    local c = outside and 0.5 or ROUND_C
    local m0, m1 = outside and 0.49 or c, outside and 0.51 or 1 - c
    local function piece(l, r, t, b)
        local p = NoSnap(owner:CreateTexture(nil, layer, nil, sub))
        p:SetTexture(tex)
        p:SetTexCoord(l, r, t, b)
        return p
    end
    ring.corners = {
        { tex = piece(0, c, 0, c), sx = -1, sy = 1 },
        { tex = piece(1 - c, 1, 0, c), sx = 1, sy = 1 },
        { tex = piece(0, c, 1 - c, 1), sx = -1, sy = -1 },
        { tex = piece(1 - c, 1, 1 - c, 1), sx = 1, sy = -1 },
    }
    for _, def in ipairs({ { "TOP", m0, m1, 0, c }, { "BOTTOM", m0, m1, 1 - c, 1 },
        { "LEFT", 0, c, m0, m1 }, { "RIGHT", 1 - c, 1, m0, m1 } }) do
        for i = 1, RING_SEGMENTS do
            ring.edges[#ring.edges + 1] = { side = def[1], i = i, tex = piece(def[2], def[3], def[4], def[5]),
                c0 = NewColor(), c1 = NewColor() }
        end
    end
    return ring
end

local function LayoutSpinRing(ring)
    local o, s = ring.owner, ring.size
    local w, h = o:GetSize()
    if not (w and h and w > 0 and h > 0) then return end
    ring.hw, ring.hh = w / 2, h / 2
    for _, cn in ipairs(ring.corners) do
        local t = cn.tex
        t:ClearAllPoints()
        t:SetSize(s, s)
        local pt = (cn.sy > 0 and "TOP" or "BOTTOM") .. (cn.sx > 0 and "RIGHT" or "LEFT")
        if ring.outside then
            t:SetPoint((cn.sy > 0 and "BOTTOM" or "TOP") .. (cn.sx > 0 and "LEFT" or "RIGHT"), o, pt)
        else
            t:SetPoint(pt, o, pt)
        end
    end
    local inset = ring.outside and 0 or s
    local spanW, spanH = (w - 2 * inset) / RING_SEGMENTS, (h - 2 * inset) / RING_SEGMENTS
    for _, e in ipairs(ring.edges) do
        local t, k = e.tex, e.i - 1
        t:ClearAllPoints()
        if e.side == "TOP" or e.side == "BOTTOM" then
            local x = inset + k * spanW
            t:SetSize(spanW, s)
            if e.side == "TOP" then
                t:SetPoint(ring.outside and "BOTTOMLEFT" or "TOPLEFT", o, "TOPLEFT", x, 0)
            else
                t:SetPoint(ring.outside and "TOPLEFT" or "BOTTOMLEFT", o, "BOTTOMLEFT", x, 0)
            end
            e.x0, e.x1 = x - w / 2, x + spanW - w / 2
            e.y0 = (e.side == "TOP") and h / 2 or -h / 2
            e.y1 = e.y0
        else
            local y = inset + k * spanH
            t:SetSize(s, spanH)
            if e.side == "LEFT" then
                t:SetPoint(ring.outside and "TOPRIGHT" or "TOPLEFT", o, "TOPLEFT", 0, -y)
            else
                t:SetPoint(ring.outside and "TOPLEFT" or "TOPRIGHT", o, "TOPRIGHT", 0, -y)
            end
            e.x0 = (e.side == "LEFT") and -w / 2 or w / 2
            e.x1 = e.x0
            e.y0, e.y1 = h / 2 - y - spanH, h / 2 - y   -- bottom end, top end
        end
    end
end

-- Position along the gradient axis (-1..1 at the farthest corner) and how
-- opaque the gradient is there: clear in the middle, full toward both ends.
local function GradientAt(x, y, hw, hh, dx, dy)
    local s = (x * dx + y * dy) / (math.abs(hw * dx) + math.abs(hh * dy))
    local f = math.min(1, math.max(0, (math.abs(s) - 0.12) / 0.6))
    return s, f * f * (3 - 2 * f)
end

local function PaintSpinRing(ring, angle, toneA, toneB, strength)
    if not ring.hw or ring.hidden then return end
    local dx, dy = math.cos(angle), math.sin(angle)
    local hw, hh = ring.hw, ring.hh
    for _, cn in ipairs(ring.corners) do
        local s, f = GradientAt(cn.sx * hw, cn.sy * hh, hw, hh, dx, dy)
        local c = s < 0 and toneA or toneB
        cn.tex:SetVertexColor(c[1], c[2], c[3], f * strength)
    end
    for _, e in ipairs(ring.edges) do
        local s0, f0 = GradientAt(e.x0, e.y0, hw, hh, dx, dy)
        local s1, f1 = GradientAt(e.x1, e.y1, hw, hh, dx, dy)
        local a, b = s0 < 0 and toneA or toneB, s1 < 0 and toneA or toneB
        e.c0:SetRGBA(a[1], a[2], a[3], f0 * strength)
        e.c1:SetRGBA(b[1], b[2], b[3], f1 * strength)
        local horizontal = e.side == "TOP" or e.side == "BOTTOM"
        SetGradientRGBA(e.tex, horizontal and "HORIZONTAL" or "VERTICAL", e.c0, e.c1)
    end
end

local function SetRingShown(ring, shown)
    ring.hidden = not shown
    for _, cn in ipairs(ring.corners) do cn.tex:SetShown(shown) end
    for _, e in ipairs(ring.edges) do e.tex:SetShown(shown) end
end

-- ---------------------------------------------------------------- cards

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

local function SpinLight(frame, layer, sub, mask)
    local tex = NoSnap(frame:CreateTexture(nil, layer, nil, sub))
    tex:SetTexture(RAMP_TEX, "CLAMP", "CLAMP")
    tex:SetSize(SPIN_SIZE, SPIN_SIZE)
    tex:SetPoint("CENTER", frame, "CENTER")
    if mask then tex:AddMaskTexture(mask) end
    return tex
end

local function ShapeMask(frame, file)
    if not frame.CreateMaskTexture then return nil end
    local mask = frame:CreateMaskTexture()
    mask:SetTexture(file, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    mask:SetAllPoints(frame)
    return mask
end

local function ApplySpin(cell)
    local s = cell.spin
    local angle = SpinAngle(s.phase)
    -- woah: 1 -> 0.75 -> 1
    local scale = 1 - 0.25 * (0.5 - 0.5 * math.cos(2 * math.pi * s.breath))
    local size = SPIN_SIZE * scale
    for i, tex in ipairs(cell.lights) do
        tex:SetRotation(angle + ((i % 2 == 0) and math.pi or 0))
        tex:SetSize(size, size)
    end
    cell.rimA:SetAlpha(s.strength)
    cell.rimB:SetAlpha(s.strength)
    -- .pr-title:hover takes the accent.
    local h, c = s.hover, cell.titleColor
    cell.name:SetTextColor(Lerp(c[1], cell.hoverColor[1], h), Lerp(c[2], cell.hoverColor[2], h),
        Lerp(c[3], cell.hoverColor[3], h))
end

local function Animate(cell, elapsed)
    local s = cell.spin
    local dt = math.min(elapsed or 0, 0.1)
    if s.running then
        s.phase = (s.phase + dt / s.period) % 1
        s.breath = (s.breath + dt / BREATH_PERIOD) % 1
    end
    s.strength = Approach(s.strength, s.strengthTo, dt)
    s.hover = Approach(s.hover, s.hoverTo, dt)
    ApplySpin(cell)
    if not s.running and s.strength == s.strengthTo and s.hover == s.hoverTo then
        cell:SetScript("OnUpdate", nil)
    end
end

-- Targets from the card state; `snap` jumps there (a card reused for another point).
local function Retarget(cell, snap)
    local s = cell.spin
    local full = cell.pressed or cell.checked
    s.strengthTo = (full and 1 or (cell.hovered and 0.65 or 0.5)) * (cell.known and 1 or 0.45)
    s.hoverTo = cell.hovered and 1 or 0
    s.running = (cell.hovered or cell.checked) and true or false
    s.period = cell.hovered and CARD_PERIOD or WINDOW_PERIOD
    if snap then
        s.strength, s.hover = s.strengthTo, s.hoverTo
        ApplySpin(cell)
    end
    if not cell:GetScript("OnUpdate") then cell:SetScript("OnUpdate", Animate) end
end

local function CreateCell(parent)
    local cell = CreateFrame("Button", nil, parent)
    cell:SetSize(CELL_W, CELL_H)
    cell:RegisterForClicks("LeftButtonUp")
    -- The CSS starts every button at the same angle; a small offset per card
    -- keeps a page of them from looking stamped.
    cell.spin = { phase = (#cells * 0.137) % 1, breath = 0, strength = 0.5, strengthTo = 0.5,
        hover = 0, hoverTo = 0, period = CARD_PERIOD }
    cell.titleColor, cell.hoverColor = { 1, 1, 1 }, { 1, 1, 1 }
    local level = cell:GetFrameLevel()

    -- The shapes are solid colors cut by the shape masks: the shape files
    -- only ever load as masks (as plain textures the client drew them green).
    -- .button-border: the dark rim, with the brighter light showing in it.
    local rim = CreateFrame("Frame", nil, cell)
    rim:SetAllPoints(cell)
    rim:SetFrameLevel(level + 1)
    Clip(rim)
    local rimMask = ShapeMask(rim, OUTER_TEX)
    cell.base = rim:CreateTexture(nil, "BACKGROUND")
    cell.base:SetColorTexture(0, 0, 0, 0.33)
    cell.base:SetAllPoints(rim)
    if rimMask then cell.base:AddMaskTexture(rimMask) end
    cell.rimA = SpinLight(rim, "ARTWORK", 0, rimMask)
    cell.rimB = SpinLight(rim, "ARTWORK", 1, rimMask)

    -- .button: the flat key face.
    local face = CreateFrame("Frame", nil, cell)
    face:SetPoint("TOPLEFT", cell, "TOPLEFT", RIM, -RIM)
    face:SetPoint("BOTTOMRIGHT", cell, "BOTTOMRIGHT", -RIM, RIM)
    face:SetFrameLevel(level + 2)
    Clip(face)
    cell.face = face
    local body = face:CreateTexture(nil, "BACKGROUND")
    body:SetColorTexture(BODY[1], BODY[2], BODY[3], 1)
    body:SetAllPoints(face)
    local faceMask = ShapeMask(face, INNER_TEX)
    if faceMask then body:AddMaskTexture(faceMask) end
    cell.lights = { cell.rimA, cell.rimB }

    local content = CreateFrame("Frame", nil, cell)
    content:SetAllPoints(cell)
    content:SetFrameLevel(level + 3)

    -- .pfp: round portrait in the left cap.
    cell.pfp = content:CreateTexture(nil, "BACKGROUND")
    cell.pfp:SetTexture(DISC_TEX)
    cell.pfp:SetSize(PFP, PFP)
    cell.pfp:SetPoint("CENTER", cell, "TOPLEFT", PFP_CENTER, -CELL_H / 2)
    cell.pfp:SetVertexColor(1, 1, 1, 0.07)

    cell.frame = CreateFrame("Frame", nil, content)
    cell.frame:SetSize(PFP - 6, PFP - 6)
    cell.frame:SetPoint("CENTER", cell.pfp, "CENTER")
    cell.model = CreateFrame("PlayerModel", nil, cell.frame)
    cell.model:SetAllPoints(cell.frame)
    cell.model:SetScript("OnModelLoaded", function(self)
        cell.modelLoaded = true
        self:SetPortraitZoom(0.85)
        cell.bigIcon:Hide()
        cell.badge:Show()
    end)
    cell.bigIcon = cell.frame:CreateTexture(nil, "ARTWORK")
    cell.bigIcon:SetSize(PFP - 16, PFP - 16)
    cell.bigIcon:SetPoint("CENTER")

    -- Small bronze boot on the portrait, like the world map pin.
    local badgeHolder = CreateFrame("Frame", nil, cell.frame)
    badgeHolder:SetAllPoints(cell.frame)
    badgeHolder:SetFrameLevel(cell.model:GetFrameLevel() + 2)
    cell.badge = badgeHolder:CreateTexture(nil, "OVERLAY")
    cell.badge:SetSize(BADGE, BADGE)
    cell.badge:SetPoint("CENTER", cell.pfp, "BOTTOMLEFT", 7, 7)

    cell.name = NewText(content)
    cell.name:SetPoint("TOPLEFT", cell, "TOPLEFT", TEXT_LEFT, -13)
    cell.name:SetPoint("RIGHT", cell, "RIGHT", -TEXT_RIGHT, 0)
    cell.name:SetJustifyH("LEFT")
    cell.name:SetWordWrap(false)

    cell.npc = NewText(content)
    cell.npc:SetPoint("TOPLEFT", cell, "TOPLEFT", TEXT_LEFT + 2, -29)
    cell.npc:SetPoint("RIGHT", cell, "RIGHT", -TEXT_RIGHT, 0)
    cell.npc:SetJustifyH("LEFT")
    cell.npc:SetWordWrap(false)

    cell.dist = NewText(content)
    cell.dist:SetPoint("BOTTOMLEFT", cell, "BOTTOMLEFT", TEXT_LEFT + 2, 12)
    cell.dist:SetJustifyH("LEFT")

    cell.time = NewText(content)
    cell.time:SetPoint("BOTTOMRIGHT", cell, "BOTTOMRIGHT", -TEXT_RIGHT - 2, 12)
    cell.time:SetJustifyH("RIGHT")

    cell:SetScript("OnEnter", function(self)
        self.hovered = true
        Retarget(self)
        RowTooltip(self)
    end)
    cell:SetScript("OnLeave", function(self)
        self.hovered, self.pressed = false, false
        Retarget(self)
        GameTooltip:Hide()
    end)
    cell:SetScript("OnMouseDown", function(self, button)
        if button ~= "LeftButton" then return end
        self.pressed = true
        Retarget(self)
    end)
    cell:SetScript("OnMouseUp", function(self)
        self.pressed = false
        Retarget(self)
    end)
    cell:SetScript("OnClick", function(self)
        local node = self.entry and self.entry.node
        if not node then return end
        if activeKey and activeKey == node.key then
            ClearWaypoint(node)
        else
            SetWaypoint(node)
        end
        Mod:RefreshGuide()
        if GameTooltip:IsOwned(self) then RowTooltip(self) end
    end)

    ApplySpin(cell)
    return cell
end

local function StyleCellFonts(cell)
    local size = Mod:GetDB().fontSize or 12
    Mod.SetFont(cell.name, math.max(8, size))
    Mod.SetFont(cell.npc, math.max(7, size - 2))
    Mod.SetFont(cell.dist, math.max(7, size - 2))
    Mod.SetFont(cell.time, math.max(7, size - 2))
end

-- Accent shades of the rim light and text colors.
local function PaintCell(cell, entry)
    local rimA, rimB = Tone(0.35), Tone(0.75)
    cell.rimA:SetVertexColor(rimA[1], rimA[2], rimA[3], 1)
    cell.rimB:SetVertexColor(rimB[1], rimB[2], rimB[3], 1)

    if entry.known then
        cell.titleColor = { 1, 1, 1 }
        cell.hoverColor = Tone(0.2)
        cell.npc:SetTextColor(MUTED[1], MUTED[2], MUTED[3])
    else
        cell.titleColor = { 0.55, 0.56, 0.6 }
        cell.hoverColor = Tone(0.45)
        cell.npc:SetTextColor(0.36, 0.37, 0.4)
    end
    cell.dist:SetTextColor(MUTED[1], MUTED[2], MUTED[3])
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
        local reused = cell.entryKey ~= entry.node.key
        cell.entry = entry
        cell.entryKey = entry.node.key
        cell.known = entry.known

        local npc = UpdatePortrait(cell, entry)
        PaintCell(cell, entry)
        cell.name:SetText(entry.node.name)
        cell.dist:SetText(DistanceLabel(entry))
        if npc and npc.name then
            cell.npc:SetText(npc.name)
        else
            cell.npc:SetText(entry.node.zone or "")
        end
        if entry.flightTime then
            local c = Tone(0.25)
            cell.time:SetText(FM.FormatTime(entry.flightTime))
            cell.time:SetTextColor(c[1], c[2], c[3])
        elseif entry.isCurrent then
            cell.time:SetText(L("You are here"))
            cell.time:SetTextColor(0.39, 0.82, 0.53)   -- #63d188
        else
            cell.time:SetText("")
        end
        cell.checked = activeKey ~= nil and activeKey == entry.node.key
        -- A card now showing another point jumps to its state instead of
        -- fading the previous point's state away.
        Retarget(cell, reused)
        cell:Show()
    end
    for i = shown + 1, #cells do
        cells[i]:Hide()
        cells[i]:SetScript("OnUpdate", nil)
        cells[i].entry = nil
        cells[i].entryKey = nil
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

local function ControlButton(parent, width, height)
    local btn = CreateFrame("Button", nil, parent)
    btn:SetSize(width, height)
    Outlined(btn, 4)
    btn.label = NewText(btn)
    btn.label:SetPoint("CENTER")
    btn.label:SetTextColor(SOFT[1], SOFT[2], SOFT[3])
    btn:SetScript("OnEnter", function(self) SetHover(self, true) end)
    btn:SetScript("OnLeave", function(self) SetHover(self, false) end)
    return btn
end

-- .tab: label, white 7% hover behind it, 2px accent underline when active.
local function CreateTab(parent, key)
    local tab = CreateFrame("Button", nil, parent)
    tab.key = key
    tab:SetHeight(HEADER_H - TAB_ROW)
    tab.hoverBg = Rounded(tab, "BACKGROUND", 0, 6)
    for _, t in ipairs(tab.hoverBg) do t:Hide() end
    Tint(tab.hoverBg, { 1, 1, 1 }, 0.07)
    -- The hover layer stops 8px above the underline (.tab::before bottom: 8px).
    local tl, tr = tab.hoverBg[1], tab.hoverBg[3]
    tl:ClearAllPoints(); tl:SetPoint("TOPLEFT", tab, "TOPLEFT", 0, -2)
    tr:ClearAllPoints(); tr:SetPoint("TOPRIGHT", tab, "TOPRIGHT", 0, -2)
    local bl, br = tab.hoverBg[7], tab.hoverBg[9]
    bl:ClearAllPoints(); bl:SetPoint("BOTTOMLEFT", tab, "BOTTOMLEFT", 0, 8)
    br:ClearAllPoints(); br:SetPoint("BOTTOMRIGHT", tab, "BOTTOMRIGHT", 0, 8)
    tab.label = NewText(tab)
    tab.label:SetPoint("CENTER", tab, "CENTER", 0, 3)
    tab.underline = tab:CreateTexture(nil, "ARTWORK")
    tab.underline:SetTexture(WHITE_TEX)
    tab.underline:SetHeight(2)
    tab.underline:SetPoint("BOTTOMLEFT", tab, "BOTTOMLEFT", 0, 0)
    tab.underline:SetPoint("BOTTOMRIGHT", tab, "BOTTOMRIGHT", 0, 0)
    tab:SetScript("OnEnter", function(self) for _, t in ipairs(self.hoverBg) do t:Show() end end)
    tab:SetScript("OnLeave", function(self) for _, t in ipairs(self.hoverBg) do t:Hide() end end)
    tab:SetScript("OnClick", function(self)
        local gdb = GuideDB()
        gdb.filter = self.key
        gdb.page = 1
        Mod:RefreshGuide()
    end)
    return tab
end

local function UpdateControlLabels()
    local gdb = GuideDB()
    local accent = Tone(0)
    local function chip(btn, text, active)
        btn.label:SetText(text)
        btn:SetWidth(math.ceil(btn.label:GetStringWidth()) + 16)
        local c = active and { 1, 1, 1 } or SOFT
        btn.label:SetTextColor(c[1], c[2], c[3])
        if active then SetOutline(btn, accent, 0.9) else SetOutline(btn, OUTLINE, 1) end
    end
    chip(guide.continentBtn, gdb.continentOnly and L("This continent") or L("All continents"), gdb.continentOnly)
    chip(guide.sortBtn, L(SORT_LABELS[gdb.sort] or "Sort: distance"), false)

    -- Tabs and controls share one row: long translations shrink the tab text.
    local room = (guide.header:GetWidth() or WIDTH) - 10 - guide.sortBtn:GetWidth() - 6
        - guide.continentBtn:GetWidth() - 10
    local fontSize = Mod:GetDB().fontSize or 12
    while true do
        local used = 10
        for i, tab in ipairs(guide.tabs) do
            Mod.SetFont(tab.label, fontSize)
            tab.label:SetText(L(FILTER_LABELS[tab.key]))
            tab:SetWidth(math.ceil(tab.label:GetStringWidth()) + 12)
            used = used + tab:GetWidth() + (i > 1 and 8 or 0)
        end
        if used <= room or fontSize <= 8 then break end
        fontSize = fontSize - 1
    end
    for _, tab in ipairs(guide.tabs) do
        local active = gdb.filter == tab.key
        local c = active and { 1, 1, 1 } or SOFT
        tab.label:SetTextColor(c[1], c[2], c[3])
        tab.underline:SetVertexColor(accent[1], accent[2], accent[3], 1)
        tab.underline:SetShown(active)
    end
end

-- Turning light along the window border (and around it when floating).
local function PaintWindowLight(phase)
    local angle = SpinAngle(phase) - math.rad(45)   -- the card gradient is -45deg
    local strength = 1
    PaintSpinRing(guide.ringBlur, angle, Tone(0), Tone(0.45), 0.4 * strength)
    PaintSpinRing(guide.ringIntense, angle, Tone(0.25), Tone(0.6), 0.75 * strength)
    PaintSpinRing(guide.ringInside, angle, Tone(0.45), Tone(0.8), 0.95 * strength)
end

local function LayoutWindowLight()
    LayoutSpinRing(guide.ringBlur)
    LayoutSpinRing(guide.ringIntense)
    LayoutSpinRing(guide.ringInside)
    PaintWindowLight(guide.lightPhase or 0)
end

function Mod:ApplyGuideStyle()
    if not guide then return end
    local size = self:GetDB().fontSize or 12
    self.SetFont(guide.title, size + 1)
    guide.title:SetText(L("Flight Points"))
    self.SetFont(guide.crumb, size + 1)
    self.SetFont(guide.slash, math.max(7, size - 2))
    self.SetFont(guide.summary, math.max(8, size - 1))
    self.SetFont(guide.nearest, math.max(8, size - 1))
    self.SetFont(guide.empty, size)
    self.SetFont(guide.pageText, math.max(8, size - 1))
    self.SetFont(guide.search, math.max(8, size - 1))
    self.SetFont(guide.search.placeholder, math.max(8, size - 1))
    guide.search.placeholder:SetText(L("Search..."))
    for _, btn in ipairs({ guide.continentBtn, guide.sortBtn, guide.prevBtn, guide.nextBtn }) do
        self.SetFont(btn.label, math.max(8, size - 2))
    end
    if guide:IsShown() then UpdateControlLabels() end
    LayoutWindowLight()
    for _, cell in ipairs(cells) do
        cell.fontSize = nil
    end
end

local function BuildGuide()
    if guide then return guide end

    guide = CreateFrame("Frame", "KT_FlightMasterGuide", UIParent)
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

    -- .spin-blur / .spin-intense around the card, .card-border, then the
    -- light inside the border and the #111215 card 2px in.
    guide.ringBlur = NewSpinRing(guide, "BACKGROUND", -8, 30, true)
    guide.ringIntense = NewSpinRing(guide, "BACKGROUND", -7, 9, true)
    Tint(Rounded(guide, "BACKGROUND", -6, WINDOW_RADIUS), { 0, 0, 0 }, 0.33)
    guide.ringInside = NewSpinRing(guide, "BACKGROUND", -5, WINDOW_RADIUS, false)
    Tint(Rounded(guide, "BACKGROUND", -4, WINDOW_RADIUS - BORDER, BORDER), BODY)

    -- .header: #0b0d10 with a #1d1f23 line under it.
    local header = CreateFrame("Frame", nil, guide)
    header:SetPoint("TOPLEFT", guide, "TOPLEFT", BORDER, -BORDER)
    header:SetPoint("TOPRIGHT", guide, "TOPRIGHT", -BORDER, -BORDER)
    header:SetHeight(HEADER_H)
    Tint(Rounded(header, "BACKGROUND", 0, WINDOW_RADIUS - BORDER, 0, true), HEADER)
    local line = header:CreateTexture(nil, "BORDER")
    line:SetColorTexture(HEADER_LINE[1], HEADER_LINE[2], HEADER_LINE[3], 1)
    line:SetHeight(1)
    line:SetPoint("BOTTOMLEFT", header, "BOTTOMLEFT")
    line:SetPoint("BOTTOMRIGHT", header, "BOTTOMRIGHT")
    guide.header = header

    -- .top-header: icon, breadcrumb, space, search, close.
    local icon = header:CreateTexture(nil, "ARTWORK")
    icon:SetSize(24, 24)
    icon:SetPoint("CENTER", header, "TOPLEFT", 22, -TAB_ROW / 2 - 1)
    ApplyFlightIcon(icon)
    guide.icon = icon

    guide.crumb = NewText(header)
    guide.crumb:SetPoint("LEFT", icon, "RIGHT", 8, 0)
    guide.crumb:SetTextColor(SOFT[1], SOFT[2], SOFT[3])
    guide.crumb:SetText("KullThranUI")
    guide.slash = NewText(header)
    guide.slash:SetPoint("LEFT", guide.crumb, "RIGHT", 6, 0)
    guide.slash:SetTextColor(SOFT[1], SOFT[2], SOFT[3])
    guide.slash:SetText("/")
    guide.title = NewText(header)
    guide.title:SetPoint("LEFT", guide.slash, "RIGHT", 6, 0)
    guide.title:SetTextColor(1, 1, 1)

    local close = ControlButton(header, 24, 24)
    close:SetPoint("CENTER", header, "TOPRIGHT", -22, -TAB_ROW / 2 - 1)
    close.tex = close:CreateTexture(nil, "ARTWORK")
    close.tex:SetSize(12, 12)
    close.tex:SetPoint("CENTER")
    close.tex:SetTexture(ICON_PATH .. "kui-close.png")
    close.tex:SetVertexColor(MUTED[1], MUTED[2], MUTED[3], 1)
    close:SetScript("OnClick", function() guide:Hide() end)
    close:HookScript("OnEnter", function(self) self.tex:SetVertexColor(1, 1, 1, 1) end)
    close:HookScript("OnLeave", function(self) self.tex:SetVertexColor(MUTED[1], MUTED[2], MUTED[3], 1) end)
    guide.closeBtn = close

    local search = CreateFrame("EditBox", nil, header)
    search:SetSize(140, 24)
    search:SetPoint("RIGHT", close, "LEFT", -8, 0)
    Outlined(search, 4)
    search:SetAutoFocus(false)
    search:SetTextInsets(8, 8, 0, 0)
    search:SetFont("Fonts\\FRIZQT__.TTF", 11, "")
    search:SetTextColor(1, 1, 1)
    search:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)
    search:SetScript("OnTextChanged", function() GuideDB().page = 1; Mod:RefreshGuide() end)
    search:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
    search:SetScript("OnEditFocusGained", function(self) SetOutline(self, Tone(0), 0.9) end)
    search:SetScript("OnEditFocusLost", function(self) SetOutline(self, OUTLINE, 1) end)
    search:SetScript("OnEnter", function(self) SetHover(self, true) end)
    search:SetScript("OnLeave", function(self) SetHover(self, false) end)
    search.placeholder = NewText(search)
    search.placeholder:SetPoint("LEFT", search, "LEFT", 8, 0)
    search.placeholder:SetTextColor(MUTED[1], MUTED[2], MUTED[3])
    search:HookScript("OnTextChanged", function(self)
        self.placeholder:SetShown(self:GetText() == "")
    end)
    guide.search = search
    -- The breadcrumb gives way to the search box on narrow windows.
    guide.title:SetPoint("RIGHT", search, "LEFT", -8, 0)
    guide.title:SetJustifyH("LEFT")
    guide.title:SetWordWrap(false)

    -- .btm-header: the filter tabs, then the continent and sort controls.
    guide.tabs = {}
    local prev
    for _, key in ipairs(FILTERS) do
        local tab = CreateTab(header, key)
        if prev then
            tab:SetPoint("BOTTOMLEFT", prev, "BOTTOMRIGHT", 8, 0)
        else
            tab:SetPoint("BOTTOMLEFT", header, "BOTTOMLEFT", 10, 0)
        end
        guide.tabs[#guide.tabs + 1] = tab
        prev = tab
    end

    guide.sortBtn = ControlButton(header, 90, 22)
    guide.sortBtn:SetPoint("BOTTOMRIGHT", header, "BOTTOMRIGHT", -10, 9)
    guide.sortBtn:SetScript("OnClick", function()
        local gdb = GuideDB()
        gdb.sort = NextIn(SORTS, gdb.sort)
        gdb.page = 1
        Mod:RefreshGuide()
    end)
    guide.continentBtn = ControlButton(header, 90, 22)
    guide.continentBtn:SetPoint("RIGHT", guide.sortBtn, "LEFT", -6, 0)
    guide.continentBtn:SetScript("OnClick", function()
        local gdb = GuideDB()
        gdb.continentOnly = not gdb.continentOnly
        gdb.page = 1
        Mod:RefreshGuide()
    end)

    guide.summary = NewText(guide)
    guide.summary:SetPoint("TOPLEFT", guide, "TOPLEFT", 14, -(BORDER + HEADER_H + 9))
    guide.summary:SetPoint("RIGHT", guide, "RIGHT", -14, 0)
    guide.summary:SetJustifyH("LEFT")
    guide.summary:SetWordWrap(false)
    guide.summary:SetTextColor(SOFT[1], SOFT[2], SOFT[3])

    guide.nearest = NewText(guide)
    guide.nearest:SetPoint("TOPLEFT", guide.summary, "BOTTOMLEFT", 0, -4)
    guide.nearest:SetPoint("RIGHT", guide, "RIGHT", -14, 0)
    guide.nearest:SetJustifyH("LEFT")
    guide.nearest:SetWordWrap(false)
    guide.nearest:SetTextColor(MUTED[1], MUTED[2], MUTED[3])

    -- .prs: the 1px #343539 rounded list holding the cards.
    local listBg = CreateFrame("Frame", nil, guide)
    listBg:SetPoint("TOPLEFT", guide, "TOPLEFT", 12, -LIST_TOP)
    listBg:SetPoint("BOTTOMRIGHT", guide, "BOTTOMRIGHT", -12, 10)
    Tint(Rounded(listBg, "BACKGROUND", 0, 6), LIST_LINE)
    Tint(Rounded(listBg, "BACKGROUND", 1, 5, 1), BODY)

    -- Paged grid of flight point cards.
    local grid = CreateFrame("Frame", nil, listBg)
    grid:SetPoint("TOPLEFT", listBg, "TOPLEFT", LIST_INSET, -LIST_INSET)
    grid:SetPoint("BOTTOMRIGHT", listBg, "BOTTOMRIGHT", -LIST_INSET, PAGER_HEIGHT + LIST_INSET)
    grid:SetScript("OnSizeChanged", function() if guide:IsShown() then Mod:RefreshGuide() end end)
    grid:EnableMouseWheel(true)
    grid:SetScript("OnMouseWheel", function(_, delta)
        local gdb = GuideDB()
        gdb.page = (tonumber(gdb.page) or 1) - delta
        Mod:RefreshGuide()
    end)
    guide.grid = grid

    local function PageButton(label, delta)
        local btn = ControlButton(listBg, 28, 20)
        btn.label:SetText(label)
        btn:SetScript("OnClick", function()
            local gdb = GuideDB()
            gdb.page = (tonumber(gdb.page) or 1) + delta
            Mod:RefreshGuide()
        end)
        return btn
    end
    guide.pageText = NewText(listBg)
    guide.pageText:SetPoint("BOTTOM", listBg, "BOTTOM", 0, 10)
    guide.pageText:SetTextColor(SOFT[1], SOFT[2], SOFT[3])
    guide.prevBtn = PageButton("<", -1)
    guide.prevBtn:SetPoint("RIGHT", guide.pageText, "LEFT", -10, 0)
    guide.nextBtn = PageButton(">", 1)
    guide.nextBtn:SetPoint("LEFT", guide.pageText, "RIGHT", 10, 0)

    guide.empty = NewText(listBg)
    guide.empty:SetPoint("TOPLEFT", listBg, "TOPLEFT", 12, -12)
    guide.empty:SetPoint("RIGHT", listBg, "RIGHT", -12, 0)
    guide.empty:SetJustifyH("LEFT")
    guide.empty:SetTextColor(MUTED[1], MUTED[2], MUTED[3])
    guide.empty:Hide()

    -- The window light turns on its own driver, ~30 updates a second.
    local driver = CreateFrame("Frame", nil, guide)
    local acc = 0
    guide.lightPhase = 0
    driver:SetScript("OnUpdate", function(_, elapsed)
        guide.lightPhase = (guide.lightPhase + elapsed / WINDOW_PERIOD) % 1
        acc = acc + elapsed
        if acc < 1 / 30 then return end
        acc = 0
        PaintWindowLight(guide.lightPhase)
    end)

    guide:SetScript("OnSizeChanged", function(self)
        LayoutWindowLight()
        if self:IsShown() then Mod:RefreshGuide() end
    end)
    guide:SetScript("OnShow", function()
        -- The glow around the window would spill over the options page.
        SetRingShown(guide.ringBlur, guide.mode ~= "embedded")
        SetRingShown(guide.ringIntense, guide.mode ~= "embedded")
        LayoutWindowLight()
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

    if activeKey and not ActiveWaypointAlive() then
        activeKey, activeSource, activeNode = nil, nil, nil
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
