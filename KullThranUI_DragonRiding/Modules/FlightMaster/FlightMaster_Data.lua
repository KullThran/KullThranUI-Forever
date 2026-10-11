-- Modules/FlightMaster/FlightMaster_Data.lua
-- Data layer for the Flight Master tracker: flight point catalog, player
-- distances, measured flight times and flight-in-progress state.
--
-- The Forever client exposes the static taxi catalog through
-- C_TaxiMap.GetTaxiNodesForMap (every node of a map, discovered or not) and
-- the classic flight master API (NumTaxiNodes, TaxiNodeName, ...) while the
-- taxi map is open. There is no flight duration API, so durations are
-- measured from real flights and stored account-wide in KT.db.global; routes
-- that were never flown are estimated from their hop distances and a speed
-- that calibrates itself with every measured flight.
local _, ns = ...

local FM = {}
ns.FM = FM

-- ============================================================================
-- LOCALIZATION
-- ============================================================================

-- Text goes through the KullThranUI locale layer; English is the key and the
-- fallback when a locale has no entry.
function FM.L(text)
    local KT = ns.KT or _G.KT
    local L = KT and KT.GetLocale and KT:GetLocale()
    local value = L and L[text]
    if type(value) == "string" then
        return value
    end
    return text
end
local L = FM.L

-- ============================================================================
-- CONSTANTS
-- ============================================================================

-- Starting speed for estimates, replaced by the measured average (yards per
-- second over the sum of hop distances) after the first recorded flight.
FM.DEFAULT_FLIGHT_SPEED = 30
FM.MIN_RECORDED_FLIGHT = 8          -- seconds; shorter "flights" are glitches
FM.PENDING_TIMEOUT = 20             -- seconds between TakeTaxiNode and boarding
FM.YARDS_TO_METERS = 0.9144
FM.MAP_SCAN_LIMIT = 2500
FM.diag = { roots = 0, mapsQueried = 0, mapsWithNodes = 0, scanned = false }

local FACTION_NEUTRAL, FACTION_HORDE, FACTION_ALLIANCE = 0, 1, 2
local TAXI_STATE_CURRENT = 0
local TAXI_STATE_UNREACHABLE = (Enum and Enum.FlightPathState and Enum.FlightPathState.Unreachable) or 2

local MAP_TYPE_COSMIC = (Enum and Enum.UIMapType and Enum.UIMapType.Cosmic) or 0
local MAP_TYPE_WORLD = (Enum and Enum.UIMapType and Enum.UIMapType.World) or 1
local MAP_TYPE_CONTINENT = (Enum and Enum.UIMapType and Enum.UIMapType.Continent) or 2
local MAP_TYPE_ZONE = (Enum and Enum.UIMapType and Enum.UIMapType.Zone) or 3

-- ============================================================================
-- HELPERS
-- ============================================================================

local function XY(vec)
    if not vec then return nil end
    if vec.GetXY then
        return vec:GetXY()
    end
    return vec.x, vec.y
end

function FM.Key(name)
    if type(name) ~= "string" then return nil end
    name = name:gsub("^%s+", ""):gsub("%s+$", "")
    if name == "" then return nil end
    return name
end

function FM.RouteKey(origin, dest)
    local a, b = FM.Key(origin), FM.Key(dest)
    if not a or not b then return nil end
    return a .. "|" .. b
end

function FM.CharKey()
    local name = UnitName and UnitName("player") or "?"
    local realm = GetRealmName and GetRealmName() or "?"
    return tostring(name) .. " - " .. tostring(realm)
end

function FM.FormatTime(seconds)
    seconds = tonumber(seconds)
    if not seconds then return "--:--" end
    seconds = math.max(0, math.floor(seconds + 0.5))
    local h = math.floor(seconds / 3600)
    local m = math.floor((seconds % 3600) / 60)
    local s = seconds % 60
    if h > 0 then
        return string.format("%d:%02d:%02d", h, m, s)
    end
    return string.format("%d:%02d", m, s)
end

function FM.FormatDistance(yards, unit)
    yards = tonumber(yards)
    if not yards then return "--" end
    local value, suffix = yards, "yd"
    if unit == "meters" then
        value, suffix = yards * FM.YARDS_TO_METERS, "m"
    end
    if value >= 10000 then
        return string.format("%.1fk %s", value / 1000, suffix)
    end
    return string.format("%d %s", math.floor(value + 0.5), suffix)
end

function FM.FactionLabel(faction)
    if faction == FACTION_HORDE then return L("Horde") end
    if faction == FACTION_ALLIANCE then return L("Alliance") end
    return L("Neutral")
end

local function PlayerFactionCode()
    local group = UnitFactionGroup and UnitFactionGroup("player")
    if group == "Horde" then return FACTION_HORDE end
    if group == "Alliance" then return FACTION_ALLIANCE end
    return nil
end
FM.PlayerFactionCode = PlayerFactionCode

-- ============================================================================
-- SAVED DATA (KT.db.global.flightMaster)
-- ============================================================================

-- Always resolve through KT.db: the Forever client can swap the SavedVariables
-- table after load, so cached sub-table references could go stale.
local memoryFallback = {}

function FM.GetStore()
    local KT = ns.KT or _G.KT
    local global = KT and KT.db and KT.db.global
    local store
    if type(global) == "table" then
        global.flightMaster = global.flightMaster or {}
        store = global.flightMaster
    else
        store = memoryFallback
    end
    store.timings = store.timings or {}
    store.discovered = store.discovered or {}
    store.known = store.known or {}
    store.active = store.active or {}
    store.calib = store.calib or { yards = 0, seconds = 0, samples = 0 }
    store.npcs = store.npcs or {}
    store.shared = store.shared or {}
    return store
end

function FM.GetKnownSet()
    local store = FM.GetStore()
    local key = FM.CharKey()
    -- v2: known points come only from flight master visits. Older sets also
    -- trusted the map API's discovery flag and unreachable nodes, so they are
    -- rebuilt on the next visit.
    if store.knownVersion ~= 2 then
        store.knownVersion = 2
        wipe(store.known)
    end
    store.known[key] = store.known[key] or {}
    return store.known[key]
end

function FM.GetFlightSpeed()
    local calib = FM.GetStore().calib
    if (calib.samples or 0) > 0 and (calib.seconds or 0) > 0 and (calib.yards or 0) > 0 then
        return calib.yards / calib.seconds, true
    end
    return FM.DEFAULT_FLIGHT_SPEED, false
end

function FM.CountRecordedRoutes()
    local n = 0
    for _ in pairs(FM.GetStore().timings) do n = n + 1 end
    return n
end

function FM.CountSharedRoutes()
    local n = 0
    for _ in pairs(FM.GetStore().shared) do n = n + 1 end
    return n
end

function FM.ResetTimings()
    local store = FM.GetStore()
    wipe(store.timings)
    wipe(store.shared)
    store.calib = { yards = 0, seconds = 0, samples = 0 }
end

-- ============================================================================
-- CATALOG
-- ============================================================================

FM.nodes = {}        -- array of node records
FM.nodesByKey = {}   -- name key -> node
local catalogBuilt = false

function FM.Invalidate()
    catalogBuilt = false
end

local function SafeCall(fn, ...)
    if type(fn) ~= "function" then return nil end
    local ok, a, b, c, d = pcall(fn, ...)
    if ok then return a, b, c, d end
    return nil
end

local function GetMapInfo(mapID)
    return C_Map and SafeCall(C_Map.GetMapInfo, mapID)
end

-- Walks up from the player's map to the top-most World/Cosmic map so the
-- catalog covers every continent of the current client.
local function FindRootMaps()
    local roots, seen = {}, {}
    local function add(id)
        if id and not seen[id] and GetMapInfo(id) then
            seen[id] = true
            roots[#roots + 1] = id
        end
    end

    local mapID = C_Map and SafeCall(C_Map.GetBestMapForUnit, "player")
    local guard = 0
    while mapID and guard < 12 do
        guard = guard + 1
        local info = GetMapInfo(mapID)
        if not info then break end
        if info.mapType == MAP_TYPE_WORLD or info.mapType == MAP_TYPE_COSMIC
            or not info.parentMapID or info.parentMapID == 0 then
            add(mapID)
            break
        end
        mapID = info.parentMapID
    end

    -- Seeds for when the player position is unavailable (loading screens,
    -- instances). Invalid IDs are ignored by GetMapInfo.
    add(947)  -- Azeroth
    add(946)  -- Cosmic
    return roots
end

local function GetWorldPos(mapID, x, y)
    if not (C_Map and C_Map.GetWorldPosFromMapPos and CreateVector2D and x and y) then
        return nil
    end
    local continentID, worldPos = SafeCall(C_Map.GetWorldPosFromMapPos, mapID, CreateVector2D(x, y))
    if not continentID or not worldPos then return nil end
    local wx, wy = XY(worldPos)
    if not wx or not wy then return nil end
    return continentID, wx, wy
end
FM.GetWorldPos = GetWorldPos

local function ContinentNameForMap(mapID)
    local guard = 0
    while mapID and guard < 12 do
        guard = guard + 1
        local info = GetMapInfo(mapID)
        if not info then return nil end
        if info.mapType == MAP_TYPE_CONTINENT then
            return info.name, mapID
        end
        mapID = info.parentMapID
    end
    return nil
end

local function AddOrMergeNode(rec)
    local key = FM.Key(rec.name)
    if not key then return end
    local existing = FM.nodesByKey[key]
    if not existing then
        if rec.mapType == MAP_TYPE_CONTINENT then
            rec.cmap, rec.cx, rec.cy = rec.mapID, rec.x, rec.y
        end
        rec.key = key
        FM.nodes[#FM.nodes + 1] = rec
        FM.nodesByKey[key] = rec
        return
    end
    -- Zone: prefer the zone map listing the fewest nodes. Some Forever zone
    -- maps return nodes of the whole continent, which would mislabel them.
    local better = rec.mapType == MAP_TYPE_ZONE and (existing.mapType ~= MAP_TYPE_ZONE
        or (rec.listSize or math.huge) < (existing.listSize or math.huge))
    local worldFromContinent = existing.worldFromContinent
    local cID, cwx, cwy = existing.continentID, existing.wx, existing.wy
    if better then
        for k, v in pairs(rec) do
            if k ~= "key" and k ~= "isUndiscovered" then existing[k] = v end
        end
    end
    if rec.isUndiscovered == false then
        existing.isUndiscovered = false
    end
    -- World position: the continent map projection is the reliable one.
    if rec.mapType == MAP_TYPE_CONTINENT then
        existing.cmap, existing.cx, existing.cy = rec.mapID, rec.x, rec.y
    end
    if rec.mapType == MAP_TYPE_CONTINENT and rec.wx then
        existing.continentID, existing.wx, existing.wy = rec.continentID, rec.wx, rec.wy
        existing.worldFromContinent = true
    elseif worldFromContinent then
        existing.continentID, existing.wx, existing.wy = cID, cwx, cwy
        existing.worldFromContinent = true
    elseif not existing.wx and rec.wx then
        existing.continentID, existing.wx, existing.wy = rec.continentID, rec.wx, rec.wy
    end
end

function FM.BuildCatalog(force)
    if catalogBuilt and not force then return FM.nodes end
    wipe(FM.nodes)
    wipe(FM.nodesByKey)

    FM.diag = { roots = 0, mapsQueried = 0, mapsWithNodes = 0, scanned = false }
    local getForMap = C_TaxiMap and C_TaxiMap.GetTaxiNodesForMap
    if type(getForMap) == "function" and C_Map and C_Map.GetMapChildrenInfo then
        local maps, seenMaps = {}, {}
        local function addMap(info)
            if info and info.mapID and not seenMaps[info.mapID]
                and (info.mapType == MAP_TYPE_ZONE or info.mapType == MAP_TYPE_CONTINENT) then
                seenMaps[info.mapID] = true
                maps[#maps + 1] = info
            end
        end
        for _, rootID in ipairs(FindRootMaps()) do
            FM.diag.roots = FM.diag.roots + 1
            for _, mapType in ipairs({ MAP_TYPE_ZONE, MAP_TYPE_CONTINENT }) do
                for _, info in ipairs(SafeCall(C_Map.GetMapChildrenInfo, rootID, mapType, true) or {}) do
                    addMap(info)
                end
            end
        end
        -- Fallback when the map tree is unavailable: probe map IDs directly.
        if #maps == 0 then
            FM.diag.scanned = true
            for mapID = 1, FM.MAP_SCAN_LIMIT do
                local info = GetMapInfo(mapID)
                if info then
                    info.mapID = info.mapID or mapID
                    addMap(info)
                end
            end
        end

        for _, mapInfo in ipairs(maps) do
            do
                local list = SafeCall(getForMap, mapInfo.mapID)
                FM.diag.mapsQueried = FM.diag.mapsQueried + 1
                if type(list) == "table" and #list > 0 then
                    FM.diag.mapsWithNodes = FM.diag.mapsWithNodes + 1
                end
                if type(list) == "table" then
                    local continentName, contMap = ContinentNameForMap(mapInfo.mapID)
                    for _, node in ipairs(list) do
                        local x, y = XY(node.position)
                        local continentID, wx, wy = GetWorldPos(mapInfo.mapID, x, y)
                        AddOrMergeNode({
                            nodeID = node.nodeID,
                            name = node.name,
                            faction = node.faction or FACTION_NEUTRAL,
                            atlasName = node.atlasName,
                            isUndiscovered = node.isUndiscovered == true,
                            mapID = mapInfo.mapID,
                            mapType = mapInfo.mapType,
                            zone = mapInfo.name,
                            continent = continentName or mapInfo.name,
                            x = x, y = y,
                            continentID = continentID, wx = wx, wy = wy,
                            listSize = #list,
                            contMap = contMap,
                            worldFromContinent = mapInfo.mapType == MAP_TYPE_CONTINENT or nil,
                        })
                    end
                end
            end
        end
    end

    -- The zone a node really sits in, from its continent map position.
    if C_Map and C_Map.GetMapInfoAtPosition then
        for _, node in ipairs(FM.nodes) do
            if node.cmap and node.cx and node.cy then
                local info = SafeCall(C_Map.GetMapInfoAtPosition, node.cmap, node.cx, node.cy)
                if info and info.mapType == MAP_TYPE_ZONE and info.mapID ~= node.mapID then
                    node.zone = info.name or node.zone
                    node.mapID, node.mapType = info.mapID, MAP_TYPE_ZONE
                    node.x, node.y = nil, nil
                    if node.wx and C_Map.GetMapPosFromWorldPos then
                        -- Returns uiMapID, mapPosition.
                        local _, pos = SafeCall(C_Map.GetMapPosFromWorldPos, node.continentID,
                            CreateVector2D and CreateVector2D(node.wx, node.wy) or { x = node.wx, y = node.wy }, info.mapID)
                        node.x, node.y = XY(pos)
                    end
                end
            end
        end
    end

    -- Nodes seen at flight masters fill gaps the static catalog may have.
    for key, rec in pairs(FM.GetStore().discovered) do
        if not FM.nodesByKey[key] then
            AddOrMergeNode({
                nodeID = rec.nodeID,
                name = rec.name or key,
                faction = rec.faction or FACTION_NEUTRAL,
                isUndiscovered = false,
                mapID = rec.mapID,
                zone = rec.zone,
                continent = rec.continent,
                x = rec.x, y = rec.y,
                continentID = rec.continentID, wx = rec.wx, wy = rec.wy,
            })
        end
    end

    catalogBuilt = true
    return FM.nodes
end

function FM.IsKnown(node)
    if not node then return false end
    -- The map API's discovery flag is account-wide in Forever, so only the
    -- per-character set filled at flight masters counts.
    return FM.GetKnownSet()[node.key] == true
end

-- ============================================================================
-- PLAYER POSITION / DISTANCES
-- ============================================================================

local posCache = { t = -1 }

function FM.GetPlayerWorldPos()
    local now = GetTime()
    if now - posCache.t < 0.25 then
        return posCache.continentID, posCache.x, posCache.y, posCache.mapID, posCache.contMap
    end
    posCache.t = now
    posCache.continentID, posCache.x, posCache.y, posCache.mapID, posCache.contMap = nil, nil, nil, nil, nil

    local mapID = C_Map and SafeCall(C_Map.GetBestMapForUnit, "player")
    if not mapID then return nil end
    -- Project through the continent map, like the catalog does, so player
    -- and node positions share one frame.
    local _, contMap = ContinentNameForMap(mapID)
    local continentID, wx, wy
    if contMap then
        local cx, cy = XY(SafeCall(C_Map.GetPlayerMapPosition, contMap, "player"))
        if cx then continentID, wx, wy = GetWorldPos(contMap, cx, cy) end
    end
    if not continentID then
        local px, py = XY(SafeCall(C_Map.GetPlayerMapPosition, mapID, "player"))
        if not px then return nil end
        continentID, wx, wy = GetWorldPos(mapID, px, py)
    end
    if not continentID then return nil end
    posCache.continentID, posCache.x, posCache.y, posCache.mapID = continentID, wx, wy, mapID
    posCache.contMap = contMap
    return continentID, wx, wy, mapID, contMap
end

-- Same continent: by continent map when both sides know it, else by the
-- instance ID the world projection reported.
function FM.SameContinent(node, continentID, contMap)
    if not node then return false end
    if node.contMap and contMap then return node.contMap == contMap end
    return node.continentID ~= nil and node.continentID == continentID
end

function FM.IsOnPlayerContinent(node)
    local continentID, _, _, _, contMap = FM.GetPlayerWorldPos()
    if not continentID then return true end
    return FM.SameContinent(node, continentID, contMap)
end

local function NodeDistance(a, b)
    if not (a and b and a.wx and b.wx and FM.SameContinent(a, b.continentID, b.contMap)) then
        return nil
    end
    local dx, dy = a.wx - b.wx, a.wy - b.wy
    return math.sqrt(dx * dx + dy * dy)
end
FM.NodeDistance = NodeDistance

-- Returns yards, or nil plus a reason ("continent" / "position").
function FM.DistanceToNode(node)
    local continentID, x, y, _, contMap = FM.GetPlayerWorldPos()
    if not continentID then return nil, "position" end
    if not (node and node.wx) then return nil, "position" end
    if not FM.SameContinent(node, continentID, contMap) then return nil, "continent" end
    local dx, dy = node.wx - x, node.wy - y
    return math.sqrt(dx * dx + dy * dy)
end

function FM.GetNearestKnown()
    local best, bestDist
    for _, node in ipairs(FM.BuildCatalog()) do
        if FM.IsKnown(node) then
            local d = FM.DistanceToNode(node)
            if d and (not bestDist or d < bestDist) then
                best, bestDist = node, d
            end
        end
    end
    return best, bestDist
end

-- ============================================================================
-- FLIGHT MASTER CAPTURE
-- ============================================================================

local function GetTaxiMapIDCompat()
    if type(GetTaxiMapID) == "function" then
        return SafeCall(GetTaxiMapID)
    end
end

local function RememberDiscovered(name, info)
    local key = FM.Key(name)
    if not key then return end
    local store = FM.GetStore()
    local rec = store.discovered[key] or {}
    rec.name = name
    for k, v in pairs(info or {}) do
        if v ~= nil then rec[k] = v end
    end
    store.discovered[key] = rec
end

-- Called on TAXIMAP_OPENED: marks every node the flight master offers as
-- known for this character and remembers which node is the current one.
function FM.CaptureFlightMaster()
    local known = FM.GetKnownSet()
    local current
    local slots = {}
    local taxiMapID = GetTaxiMapIDCompat()

    if taxiMapID and C_TaxiMap and C_TaxiMap.GetAllTaxiNodes then
        local list = SafeCall(C_TaxiMap.GetAllTaxiNodes, taxiMapID)
        if type(list) == "table" then
            local zoneInfo = GetMapInfo(taxiMapID)
            for _, node in ipairs(list) do
                local key = FM.Key(node.name)
                if key and not node.isMapLayerTransition and node.state ~= TAXI_STATE_UNREACHABLE then
                    known[key] = true
                    if node.state == TAXI_STATE_CURRENT then
                        current = node.name
                    elseif node.slotIndex then
                        slots[key] = node.slotIndex
                    end
                    local x, y = XY(node.position)
                    local continentID, wx, wy = GetWorldPos(taxiMapID, x, y)
                    RememberDiscovered(node.name, {
                        nodeID = node.nodeID,
                        mapID = taxiMapID,
                        continent = ContinentNameForMap(taxiMapID) or (zoneInfo and zoneInfo.name),
                        continentID = continentID, wx = wx, wy = wy,
                    })
                end
            end
        end
    end

    if type(NumTaxiNodes) == "function" and type(TaxiNodeName) == "function" then
        for i = 1, (NumTaxiNodes() or 0) do
            local name = TaxiNodeName(i)
            local kind = TaxiNodeGetType and TaxiNodeGetType(i)
            local key = FM.Key(name)
            if key and kind ~= "NONE" then
                known[key] = true
                if kind == "CURRENT" then
                    current = name
                elseif not slots[key] then
                    slots[key] = i
                end
                if not FM.GetStore().discovered[key] then
                    RememberDiscovered(name, {})
                end
            end
        end
    end

    FM.currentNode = current
    FM.taxiSlots = slots
    FM.RememberFlightMasterNPC(current)
    FM.Invalidate()
    return current
end

-- Flight master NPC of a node, learned on each visit (shared by all
-- characters). Returns { id = creatureID, name = npcName } or nil.
function FM.CreatureIDFromGUID(guid)
    if type(guid) ~= "string" then return nil end
    local kind, _, _, _, _, id = strsplit("-", guid)
    if kind == "Creature" then return tonumber(id) end
end

function FM.RememberFlightMasterNPC(nodeName)
    local key = FM.Key(nodeName)
    if not key or type(UnitGUID) ~= "function" then return end
    local id = FM.CreatureIDFromGUID(UnitGUID("npc"))
    if not id then return end
    FM.GetStore().npcs[key] = { id = id, name = UnitName and UnitName("npc") or nil }
end

-- Nearest Classic flight master spawn to a node (within NPC_MATCH_YARDS).
-- Both axis orders are tried so the match holds whichever way the client
-- reports world coordinates.
local NPC_MATCH_YARDS = 60
local seedNPCCache = {}

local function FindSeedNPC(node)
    local spawns = ns.FM_NPC_SPAWNS
    if type(spawns) ~= "table" or not (node.wx and node.wy) then return nil end
    local best, bestD
    for _, s in ipairs(spawns) do
        -- Spawns use instance 0/1; skip the check if the client reports
        -- something else for this node.
        local cid = node.continentID
        if cid == nil or (cid ~= 0 and cid ~= 1) or cid == s[2] then
            local d1 = (s[3] - node.wx) ^ 2 + (s[4] - node.wy) ^ 2
            local d2 = (s[3] - node.wy) ^ 2 + (s[4] - node.wx) ^ 2
            local d = math.min(d1, d2)
            if not bestD or d < bestD then best, bestD = s, d end
        end
    end
    if best and bestD <= NPC_MATCH_YARDS ^ 2 then
        return { id = best[1], name = best[5], title = best[6], display = best[7], seed = true }
    end
end

function FM.GetFlightMasterNPC(node)
    local key = node and (node.key or FM.Key(node.name))
    if not key then return nil end
    local cached = seedNPCCache[key]
    if cached == nil then
        cached = FindSeedNPC(node) or false
        seedNPCCache[key] = cached
    end
    local captured = FM.GetStore().npcs[key]
    if captured then
        -- Keep the seed's title and display when it is the same creature.
        if cached and cached.id == captured.id then
            return { id = captured.id, name = captured.name or cached.name,
                title = cached.title, display = cached.display }
        end
        return captured
    end
    return cached or nil
end

function FM.ReleaseFlightMaster()
    FM.taxiSlots = nil
end

function FM.GetCurrentTaxiSlot()
    if type(NumTaxiNodes) == "function" and type(TaxiNodeGetType) == "function" then
        for i = 1, (NumTaxiNodes() or 0) do
            if TaxiNodeGetType(i) == "CURRENT" then return i end
        end
    end
end

function FM.GetCurrentTaxiNodeName()
    if type(NumTaxiNodes) == "function" and type(TaxiNodeGetType) == "function" then
        for i = 1, (NumTaxiNodes() or 0) do
            if TaxiNodeGetType(i) == "CURRENT" then
                return TaxiNodeName(i)
            end
        end
    end
    return FM.currentNode
end

-- Ordered node names from the current flight master to the given slot.
function FM.GetRouteNames(slot)
    local names = {}
    local hops = type(GetNumRoutes) == "function" and GetNumRoutes(slot) or 0
    if hops and hops > 0 and type(TaxiGetNodeSlot) == "function" then
        for hop = 1, hops do
            local src = TaxiGetNodeSlot(slot, hop, true)
            local dst = TaxiGetNodeSlot(slot, hop, false)
            if hop == 1 and src then names[#names + 1] = TaxiNodeName(src) end
            if dst then names[#names + 1] = TaxiNodeName(dst) end
        end
    end
    if #names < 2 then
        names = { FM.GetCurrentTaxiNodeName(), TaxiNodeName(slot) }
    end
    return names
end

-- Sum of straight hop distances; nil when any hop lacks coordinates.
function FM.GetPathYards(names)
    if type(names) ~= "table" or #names < 2 then return nil end
    FM.BuildCatalog()
    local total = 0
    for i = 1, #names - 1 do
        local a = FM.nodesByKey[FM.Key(names[i])]
        local b = FM.nodesByKey[FM.Key(names[i + 1])]
        local d = NodeDistance(a, b)
        if not d then return nil end
        total = total + d
    end
    return total
end

-- Returns seconds, source ("measured" / "estimated") or nil.
-- ============================================================================
-- PRESET CLASSIC TIMES (FlightMaster_SeedData.lua)
-- ============================================================================

-- Same key Flight Timer Classic uses: the node position on the taxi map.
function FM.TaxiHash(slot)
    if not slot or type(TaxiNodePosition) ~= "function" then return nil end
    local x = TaxiNodePosition(slot)
    if not x then return nil end
    return tostring(math.floor(x * 100000000))
end

local function BaseName(name)
    return type(name) == "string" and (name:match("^[^,]+") or name):gsub("%s+$", "") or nil
end

local seedHashesByName
local function SeedHashesForName(name)
    if not seedHashesByName then
        seedHashesByName = {}
        for hash, seedName in pairs(ns.FM_SEED_NAMES or {}) do
            seedHashesByName[seedName] = seedHashesByName[seedName] or {}
            table.insert(seedHashesByName[seedName], hash)
        end
    end
    return seedHashesByName[BaseName(name) or ""] or {}
end

function FM.GetSeedTime(origin, dest, originHash, destHash)
    local faction = UnitFactionGroup and UnitFactionGroup("player")
    local times = ns.FM_SEED_TIMES and faction and ns.FM_SEED_TIMES[faction]
    if not times then return nil end
    if originHash and destHash and times[originHash] and times[originHash][destHash] then
        return times[originHash][destHash]
    end
    -- Positions can differ between clients; fall back to English names.
    for _, a in ipairs(SeedHashesForName(origin)) do
        for _, b in ipairs(SeedHashesForName(dest)) do
            if times[a] and times[a][b] then return times[a][b] end
        end
    end
    return nil
end

function FM.GetFlightEstimate(origin, dest, routeNames, originHash, destHash)
    local key = FM.RouteKey(origin, dest)
    local timing = key and FM.GetStore().timings[key]
    if timing and tonumber(timing.avg) then
        return timing.avg, "measured", timing
    end
    -- Times shared by other players running KullThranUI.
    local shared = key and FM.GetStore().shared[key]
    if shared and tonumber(shared.avg) then
        return shared.avg, "shared", shared
    end
    -- The return trip flies the same path.
    local back = FM.RouteKey(dest, origin)
    local backTiming = back and FM.GetStore().timings[back]
    if backTiming and tonumber(backTiming.avg) then
        return backTiming.avg, "return trip"
    end
    local legs = FM.GetLegsTime(routeNames)
    if legs then
        return legs, "measured legs"
    end
    local preset = FM.GetSeedTime(origin, dest, originHash, destHash)
    if preset then
        return preset, "preset"
    end
    local yards = FM.GetPathYards(routeNames or { origin, dest })
    if yards and yards > 0 then
        local speed = FM.GetFlightSpeed()
        return yards / speed, "estimated"
    end
    return nil
end

-- Multi-hop route made only of hops already flown (either direction).
function FM.GetLegsTime(routeNames)
    if type(routeNames) ~= "table" or #routeNames < 3 then return nil end
    local timings, total = FM.GetStore().timings, 0
    for i = 1, #routeNames - 1 do
        local t = timings[FM.RouteKey(routeNames[i], routeNames[i + 1]) or ""]
            or timings[FM.RouteKey(routeNames[i + 1], routeNames[i]) or ""]
        if not (t and tonumber(t.avg)) then return nil end
        total = total + t.avg
    end
    return total > 0 and total or nil
end

function FM.GetEstimateForSlot(slot)
    if not slot or type(TaxiNodeName) ~= "function" then return nil end
    local dest = TaxiNodeName(slot)
    local origin = FM.GetCurrentTaxiNodeName()
    if not origin or not dest or origin == dest then return nil end
    local route = FM.GetRouteNames(slot)
    local seconds, source = FM.GetFlightEstimate(origin, dest, route,
        FM.TaxiHash(FM.GetCurrentTaxiSlot()), FM.TaxiHash(slot))
    return seconds, source, origin, dest, route
end

-- ============================================================================
-- FLIGHT TRACKING
-- ============================================================================

FM.pending = nil
FM.active = nil

function FM.OnTakeTaxiNode(slot)
    local seconds, source, origin, dest, route = FM.GetEstimateForSlot(slot)
    dest = dest or (type(TaxiNodeName) == "function" and TaxiNodeName(slot))
    if not dest then return end
    FM.pending = {
        origin = origin or FM.GetCurrentTaxiNodeName(),
        dest = dest,
        route = route,
        expected = seconds,
        source = source,
        pathYards = FM.GetPathYards(route),
        requestedAt = GetTime(),
    }
end

local function PersistActive(active)
    local store = FM.GetStore()
    local key = FM.CharKey()
    if not active then
        store.active[key] = nil
        return
    end
    store.active[key] = {
        origin = active.origin,
        dest = active.dest,
        expected = active.expected,
        source = active.source,
        pathYards = active.pathYards,
        startEpoch = active.startEpoch,
    }
end

function FM.StartFlight()
    local p = FM.pending
    FM.pending = nil
    if p and GetTime() - (p.requestedAt or 0) > FM.PENDING_TIMEOUT then
        p = nil
    end
    FM.active = {
        origin = p and p.origin,
        dest = p and p.dest,
        expected = p and p.expected,
        source = p and p.source or "unknown",
        pathYards = p and p.pathYards,
        route = p and p.route,
        start = GetTime(),
        startEpoch = time(),
    }
    PersistActive(FM.active)
    return FM.active
end

-- Restores a flight that was in progress across /reload or a relog.
function FM.ResumeFlight()
    local saved = FM.GetStore().active[FM.CharKey()]
    if not saved or not saved.startEpoch then return nil end
    local elapsed = time() - saved.startEpoch
    local limit = (tonumber(saved.expected) or 900) + 300
    if elapsed < 0 or elapsed > limit then
        PersistActive(nil)
        return nil
    end
    FM.active = {
        origin = saved.origin,
        dest = saved.dest,
        expected = saved.expected,
        source = saved.source or "unknown",
        pathYards = saved.pathYards,
        start = GetTime() - elapsed,
        startEpoch = saved.startEpoch,
        resumed = true,
    }
    return FM.active
end

local function RecordTiming(origin, dest, duration, pathYards, expected, source)
    local key = FM.RouteKey(origin, dest)
    if not key or duration < FM.MIN_RECORDED_FLIGHT then return false end

    local store = FM.GetStore()
    local timing = store.timings[key]
    -- A landing far from the measured average means the flight was cut
    -- short (dismount, disconnect); ignore it instead of skewing the data.
    if timing and timing.avg and (timing.n or 0) >= 2 then
        local ratio = duration / timing.avg
        if ratio < 0.6 or ratio > 1.6 then return false end
    elseif source and source ~= "measured" and expected and expected > 0 then
        local ratio = duration / expected
        if ratio < 0.25 or ratio > 4 then return false end
    end

    if not timing then
        timing = { avg = duration, n = 1 }
    else
        local weight = math.min(timing.n or 1, 4)
        timing.avg = (timing.avg * weight + duration) / (weight + 1)
        timing.n = (timing.n or 1) + 1
    end
    timing.last = duration
    timing.best = math.min(timing.best or duration, duration)
    timing.at = time()
    store.timings[key] = timing

    if pathYards and pathYards > 0 then
        local calib = store.calib
        calib.yards = (calib.yards or 0) + pathYards
        calib.seconds = (calib.seconds or 0) + duration
        calib.samples = (calib.samples or 0) + 1
    end
    return true
end

function FM.DiscardFlight()
    FM.active = nil
    PersistActive(nil)
end

function FM.EndFlight()
    local a = FM.active
    FM.active = nil
    PersistActive(nil)
    if not a then return nil end
    local duration = GetTime() - (a.start or GetTime())
    if a.resumed then
        duration = time() - (a.startEpoch or time())
    end
    -- An early landing ends the flight short of the destination.
    local recorded = false
    if not a.earlyLanding then
        recorded = RecordTiming(a.origin, a.dest, duration, a.pathYards, a.expected, a.source)
    end
    return duration, recorded, a
end

-- ============================================================================
-- SHARED TIMES (addon messages between KullThranUI users)
-- ============================================================================

FM.SHARED_MIN, FM.SHARED_MAX = 8, 1800

function FM.NodeByID(nodeID)
    nodeID = tonumber(nodeID)
    if not nodeID then return nil end
    for _, node in ipairs(FM.BuildCatalog()) do
        if node.nodeID == nodeID then return node end
    end
end

-- Stores a time another player measured. Returns true when accepted.
function FM.RecordShared(originID, destID, seconds)
    seconds = tonumber(seconds)
    if not seconds or seconds < FM.SHARED_MIN or seconds > FM.SHARED_MAX then return false end
    local o, d = FM.NodeByID(originID), FM.NodeByID(destID)
    local key = o and d and FM.RouteKey(o.name, d.name)
    if not key or o == d then return false end
    local store = FM.GetStore()
    -- Our own measurement is always preferred.
    if store.timings[key] then return false end
    local t = store.shared[key]
    if t and tonumber(t.avg) then
        local ratio = seconds / t.avg
        if (t.n or 1) >= 2 and (ratio < 0.6 or ratio > 1.6) then return false end
        local weight = math.min(t.n or 1, 8)
        t.avg = (t.avg * weight + seconds) / (weight + 1)
        t.n = (t.n or 1) + 1
    else
        store.shared[key] = { avg = seconds, n = 1 }
    end
    return true
end

-- Own measured routes as { originID, destID, seconds } for sharing.
function FM.GetShareableTimings()
    local out = {}
    FM.BuildCatalog()
    for key, timing in pairs(FM.GetStore().timings) do
        local a, b = key:match("^(.-)|(.+)$")
        local o, d = a and FM.nodesByKey[a], b and FM.nodesByKey[b]
        if o and d and o.nodeID and d.nodeID and tonumber(timing.avg) then
            out[#out + 1] = { o.nodeID, d.nodeID, math.floor(timing.avg + 0.5) }
        end
    end
    return out
end

function FM.GetTimingsFor(nodeKey)
    local to, from = {}, {}
    for key, timing in pairs(FM.GetStore().timings) do
        local a, b = key:match("^(.-)|(.+)$")
        if b == nodeKey then to[#to + 1] = { other = a, timing = timing } end
        if a == nodeKey then from[#from + 1] = { other = b, timing = timing } end
    end
    table.sort(to, function(x, y) return x.timing.avg < y.timing.avg end)
    table.sort(from, function(x, y) return x.timing.avg < y.timing.avg end)
    return to, from
end
