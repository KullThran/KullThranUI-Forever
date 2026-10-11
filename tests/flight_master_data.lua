local root = arg[1] or "."

-- Minimal client stubs: two zones on one continent plus one on another.
local now, epoch = 100, 1000000
GetTime = function() return now end
time = function() return epoch end
wipe = function(t) for k in pairs(t) do t[k] = nil end return t end
UnitName = function() return "Tester" end
GetRealmName = function() return "Realm" end
UnitFactionGroup = function() return "Alliance" end
GetLocale = function() return "enUS" end
Enum = { UIMapType = { Cosmic = 0, World = 1, Continent = 2, Zone = 3 } }
CreateVector2D = function(x, y) return { x = x, y = y } end

local MAPS = {
    [947] = { mapID = 947, name = "Azeroth", mapType = 1, parentMapID = 0 },
    [10] = { mapID = 10, name = "Eastern Kingdoms", mapType = 2, parentMapID = 947 },
    [11] = { mapID = 11, name = "Elwynn", mapType = 3, parentMapID = 10 },
    [12] = { mapID = 12, name = "Dun Morogh", mapType = 3, parentMapID = 10 },
    [20] = { mapID = 20, name = "Kalimdor", mapType = 2, parentMapID = 947 },
    [21] = { mapID = 21, name = "Teldrassil", mapType = 3, parentMapID = 20 },
}
-- Each zone spans 1000x1000 yards; continent offset puts zones side by side.
-- Continent maps report a different instance ID than their zones (as the
-- Forever client may); continent membership must still match.
local ORIGIN = { [11] = { 1, 0, 0 }, [12] = { 1, 1000, 0 }, [21] = { 2, 0, 0 }, [10] = { 100, 0, 0 }, [20] = { 200, 0, 0 } }
local NODES = {
    [11] = { { nodeID = 1, name = "Stormwind", position = { x = 0.5, y = 0.5 }, faction = 2, isUndiscovered = false } },
    [12] = { { nodeID = 2, name = "Ironforge", position = { x = 0.5, y = 0.5 }, faction = 2, isUndiscovered = true },
             { nodeID = 3, name = "Thelsamar", position = { x = 0.8, y = 0.5 }, faction = 0, isUndiscovered = true },
             { nodeID = 4, name = "Kargath", position = { x = 0.1, y = 0.1 }, faction = 1, isUndiscovered = true } },
    [21] = { { nodeID = 5, name = "Rut'theran", position = { x = 0.5, y = 0.5 }, faction = 2, isUndiscovered = true } },
    -- Continent view, plus Elwynn wrongly listing Thelsamar (seen in Forever).
    [10] = { { nodeID = 3, name = "Thelsamar", position = { x = 1.8, y = 0.5 }, faction = 0 } },
}
table.insert(NODES[11], { nodeID = 3, name = "Thelsamar", position = { x = 0.9, y = 0.9 }, faction = 0 })
local playerMap, playerPos = 11, { x = 0.5, y = 0.8 }

C_Map = {
    GetMapInfo = function(id) return MAPS[id] end,
    GetBestMapForUnit = function() return playerMap end,
    GetPlayerMapPosition = function() return playerPos end,
    GetMapChildrenInfo = function()
        local out = {}
        for id, info in pairs(MAPS) do if id ~= 947 then out[#out + 1] = info end end
        return out
    end,
    GetMapInfoAtPosition = function(mapID, x, y)
        if mapID == 10 then return x >= 1 and MAPS[12] or MAPS[11] end
    end,
    GetMapPosFromWorldPos = function(cont, world, mapID)
        local o = ORIGIN[mapID]
        return mapID, { x = (world.x - o[2]) / 1000, y = (world.y - o[3]) / 1000 }
    end,
    GetWorldPosFromMapPos = function(mapID, pos)
        local o = ORIGIN[mapID]
        return o[1], { x = o[2] + pos.x * 1000, y = o[3] + pos.y * 1000 }
    end,
}
C_TaxiMap = {
    GetTaxiNodesForMap = function(mapID) return NODES[mapID] or {} end,
    ShouldMapShowTaxiNodes = function() return true end,
}

-- Flight master at Stormwind offering Ironforge through Thelsamar.
local SLOTS = { "Stormwind", "Thelsamar", "Ironforge" }
NumTaxiNodes = function() return #SLOTS end
TaxiNodeName = function(i) return SLOTS[i] end
TaxiNodeGetType = function(i) return i == 1 and "CURRENT" or "REACHABLE" end
GetNumRoutes = function(slot) return slot == 3 and 2 or 1 end
TaxiGetNodeSlot = function(slot, hop, src)
    if slot == 3 then
        if hop == 1 then return src and 1 or 2 end
        return src and 2 or 3
    end
    return src and 1 or slot
end

TaxiNodePosition = function(i) return 0.123 + i / 100, 0.5 end
local KT = { db = { global = {}, profile = {} } }
_G.KT = KT
local ns = { KT = KT }
assert(loadfile(root .. "/KullThranUI_DragonRiding/Modules/FlightMaster/FlightMaster_SeedData.lua"))("test", ns)
assert(loadfile(root .. "/KullThranUI_DragonRiding/Modules/FlightMaster/FlightMaster_NPCData.lua"))("test", ns)
assert(loadfile(root .. "/KullThranUI_DragonRiding/Modules/FlightMaster/FlightMaster_Data.lua"))("test", ns)
-- Fake spawn next to the Stormwind node (world 500,500 on continent 1).
table.insert(ns.FM_NPC_SPAWNS, { 99999, 1, 510, 495, "Test Gryphon Master", "Gryphon Master" })
local FM = ns.FM

-- Catalog: every node, including undiscovered and opposite faction.
local nodes = FM.BuildCatalog(true)
assert(#nodes == 5, "catalog lists all nodes, got " .. #nodes)
-- Nothing is known until a flight master is visited.
assert(not FM.IsKnown(FM.nodesByKey["Stormwind"]))
assert(not FM.IsKnown(FM.nodesByKey["Ironforge"]))
FM.GetKnownSet()["Stormwind"] = true
assert(FM.nodesByKey["Ironforge"].zone == "Dun Morogh")
assert(FM.nodesByKey["Ironforge"].continent == "Eastern Kingdoms")
local thel = FM.nodesByKey["Thelsamar"]
assert(thel.zone == "Dun Morogh" and thel.wx == 1800, "zone from continent position: " .. tostring(thel.zone))
assert(math.abs(thel.x - 0.8) < 1e-6, "zone coordinates recomputed")

-- Seeded flight master NPC matched by position; far nodes get none.
local seedNPC = FM.GetFlightMasterNPC(FM.nodesByKey["Stormwind"])
assert(seedNPC and seedNPC.id == 99999 and seedNPC.title == "Gryphon Master", "seed npc")
assert(FM.GetFlightMasterNPC(FM.nodesByKey["Kargath"]) == nil)

-- Distances in yards; other continents report a reason instead.
local d = FM.DistanceToNode(FM.nodesByKey["Stormwind"])
assert(math.abs(d - 300) < 0.001, "player is 300 yd south of Stormwind")
assert(FM.IsOnPlayerContinent(FM.nodesByKey["Ironforge"]) and FM.IsOnPlayerContinent(FM.nodesByKey["Thelsamar"]))
assert(not FM.IsOnPlayerContinent(FM.nodesByKey["Rut'theran"]))
local nd, reason = FM.DistanceToNode(FM.nodesByKey["Rut'theran"])
assert(nd == nil and reason == "continent")
local nearest, nearestYards = FM.GetNearestKnown()
assert(nearest.name == "Stormwind" and math.abs(nearestYards - 300) < 0.001)

-- Visiting the flight master marks offered nodes as known.
assert(FM.CaptureFlightMaster() == "Stormwind")
FM.BuildCatalog()
assert(FM.IsKnown(FM.nodesByKey["Ironforge"]))
assert(not FM.IsKnown(FM.nodesByKey["Rut'theran"]), "points not offered stay unknown")

-- Route estimate sums hops: SW(500,500) -> Thelsamar(1800,500) -> IF(1500,500).
local route = FM.GetRouteNames(3)
assert(#route == 3 and route[2] == "Thelsamar")
assert(math.abs(FM.GetPathYards(route) - 1600) < 0.001)
-- Preset Classic data wins over the distance estimate (matched by name here,
-- by taxi-map position hash in the client).
local est, source = FM.GetEstimateForSlot(3)
assert(source == "preset" and est == ns.FM_SEED_TIMES.Alliance["43250447"]["50797998"], "preset SW->IF")
assert(FM.GetSeedTime("x", "y", "43250447", "50797998") == est, "hash lookup")
local seed = ns.FM_SEED_TIMES
ns.FM_SEED_TIMES = nil
est, source = FM.GetEstimateForSlot(3)
assert(source == "estimated" and math.abs(est - 1600 / FM.DEFAULT_FLIGHT_SPEED) < 0.001)

-- A real flight is measured, stored and replaces the estimate.
FM.OnTakeTaxiNode(3)
now = 101
local active = FM.StartFlight()
assert(active.origin == "Stormwind" and active.dest == "Ironforge" and active.source == "estimated")
assert(KT.db.global.flightMaster.active["Tester - Realm"], "flight persists across /reload")
now = 181
local duration, recorded = FM.EndFlight()
ns.FM_SEED_TIMES = seed
assert(duration == 80 and recorded, "80 s flight recorded")
assert(KT.db.global.flightMaster.active["Tester - Realm"] == nil)
local measured, msource = FM.GetFlightEstimate("Stormwind", "Ironforge")
assert(msource == "measured" and measured == 80)
local speed, calibrated = FM.GetFlightSpeed()
assert(calibrated and math.abs(speed - 20) < 0.001, "speed calibrates to 1600 yd / 80 s")

-- The return trip and multi-hop routes reuse measured hops.
local back, bsource = FM.GetFlightEstimate("Ironforge", "Stormwind")
assert(bsource == "return trip" and back == 80)
FM.GetStore().timings["Stormwind|Thelsamar"] = { avg = 30, n = 1 }
FM.GetStore().timings["Ironforge|Thelsamar"] = { avg = 25, n = 1 }
local legs, lsource = FM.GetFlightEstimate("Stormwind", "Menethil", { "Stormwind", "Thelsamar", "Ironforge" })
assert(lsource == "measured legs" and legs == 55, "legs " .. tostring(lsource))

-- Times shared by other players fill routes we have not flown.
assert(FM.RecordShared(5, 2, 120) and FM.GetStore().shared["Rut'theran|Ironforge"].avg == 120)
local sh, shsrc = FM.GetFlightEstimate("Rut'theran", "Ironforge")
assert(shsrc == "shared" and sh == 120)
assert(not FM.RecordShared(1, 2, 90), "own measurement wins")
assert(not FM.RecordShared(5, 2, 99999), "absurd times rejected")
local shareable = FM.GetShareableTimings()
assert(#shareable >= 1 and shareable[1][1] and shareable[1][3])

-- An early landing is never recorded.
FM.OnTakeTaxiNode(3); now = 190; FM.StartFlight(); FM.active.earlyLanding = true; now = 230
local _, recEarly = FM.EndFlight()
assert(not recEarly)

-- Interrupted flights far from the average are ignored once data is solid.
FM.GetStore().timings["Stormwind|Ironforge"].n = 3
FM.OnTakeTaxiNode(3); now = 200; FM.StartFlight(); now = 210
local _, rec2 = FM.EndFlight()
assert(not rec2 and FM.GetFlightEstimate("Stormwind", "Ironforge") == 80)

-- Resume after /reload mid-flight.
now = 295; FM.OnTakeTaxiNode(3); now = 300; FM.StartFlight()
FM.active = nil
epoch = epoch + 30; now = 330
local resumed = FM.ResumeFlight()
assert(resumed and resumed.dest == "Ironforge" and math.abs((now - resumed.start) - 30) < 0.001)

assert(FM.FormatTime(80) == "1:20" and FM.FormatTime(3725) == "1:02:05")
assert(FM.FormatDistance(300) == "300 yd" and FM.FormatDistance(1000, "meters") == "914 m")
print("flight_master_data: ok")
