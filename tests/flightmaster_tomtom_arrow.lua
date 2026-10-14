-- Flight Master guide: clicking a flight point puts a TomTom arrow on it with
-- normalized coordinates, replaces the previous arrow, and reports failure (so the
-- caller can fall back to the native waypoint) when TomTom is missing or errors.
local root = arg[1] or "."
local function read(path)
    local f = assert(io.open(root .. "/" .. path)); local s = f:read("*a"); f:close(); return s
end

local src = read("KullThranUI_DragonRiding/Modules/FlightMaster/FlightMaster_Guide.lua")
local a = assert(src:find("local tomtomWaypoint", 1, true), "arrow helper present")
local b = assert(src:find("local function SetWaypoint", 1, true))
local helper = src:sub(a, b - 1) .. "\nreturn SetTomTomArrow"

local calls
local function newTomTom()
    calls = { added = {}, removed = {}, arrows = {} }
    local tt = { profile = { arrow = { arrival = 12 } } }
    function tt:AddWaypoint(m, x, y, opts)
        local uid = { m, x, y, title = opts.title }
        calls.added[#calls.added + 1] = { uid = uid, m = m, x = x, y = y, opts = opts }
        return uid
    end
    function tt:RemoveWaypoint(uid) calls.removed[#calls.removed + 1] = uid end
    function tt:SetCrazyArrow(uid, dist, title) calls.arrows[#calls.arrows + 1] = { uid = uid, dist = dist, title = title } end
    return tt
end

local env = setmetatable({ pcall = pcall, _G = nil }, { __index = _G })
env._G = env
env.TomTom = newTomTom()
local SetTomTomArrow = assert(loadstring(helper, "arrow"))
setfenv(SetTomTomArrow, env)
SetTomTomArrow = SetTomTomArrow()

local node = { name = "Ariena Stormfeather, Lakeshire", mapID = 1429, x = 0.5, y = 0.25 }

-- 1. First click: waypoint + arrow, normalized coordinates, no chat spam from TomTom.
assert(SetTomTomArrow(node) == true)
local add = calls.added[1]
assert(add.m == 1429 and add.x == 0.5 and add.y == 0.25, "map and normalized coordinates")
assert(add.opts.title == node.name and add.opts.crazy == true and add.opts.persistent == false
    and add.opts.silent == true and add.opts.from == "KullThranUI", "title, crazy arrow, not persistent")
assert(#calls.arrows == 1 and calls.arrows[1].uid == add.uid and calls.arrows[1].dist == 12, "arrow follows the waypoint")
assert(#calls.removed == 0, "nothing to replace on the first click")

-- 2. Second click on another point replaces the previous waypoint.
local first = add.uid
assert(SetTomTomArrow({ name = "Other", mapID = 1429, x = 0.1, y = 0.2 }) == true)
assert(calls.removed[1] == first, "previous arrow removed")
assert(#calls.added == 2)

-- 3. Without TomTom the helper reports failure so the native waypoint is used.
env.TomTom = nil
assert(SetTomTomArrow(node) == false, "no TomTom -> false")

-- 4. A TomTom that errors must not break the click.
env.TomTom = { AddWaypoint = function() error("boom") end }
assert(SetTomTomArrow(node) == false, "erroring TomTom -> false")

print("flightmaster_tomtom_arrow: ok")
