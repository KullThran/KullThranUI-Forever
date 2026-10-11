local root = arg[1] or "."
local f = assert(io.open(root .. "/KullThranUI_UnitFrames/Modules/KUIUnitFrames/KUIUnitFrames.lua"))
local source = f:read("*a"); f:close()
local first = assert(source:find("function ns.PowerSafeUpdateColor(", 1, true))
local last = assert(source:find("local function CreatePowerBar(", first, true))
local ns = {}
local secretValues = {}
local env = setmetatable({ ns = ns, issecretvalue = function(v) return secretValues[v] == true end }, { __index = _G })
local run = assert(loadstring(source:sub(first, last - 1))); setfenv(run, env); run()
local function Color(r, g, b) return { GetRGB = function() return r, g, b end } end
local frame = { unit = "target", colors = { power = { MANA = Color(0, 0, 1), RAGE = Color(1, 0, 0), [1] = Color(1, 0, 0) } } }
local applied
local tex = { SetVertexColor = function(_, ...) applied = { ... } end }
frame.Power = { colorPower = true, GetStatusBarTexture = function() return tex end }
env.UnitPowerType = function() return 1, "RAGE" end
ns.PowerSafeUpdateColor(frame, "x", "target")
assert(applied[1] == 1 and applied[2] == 0, "readable token uses its colour")
-- Secret token and type in combat: no error and never the white default.
local token, ptype = {}, {}
secretValues[token], secretValues[ptype] = true, true
env.UnitPowerType = function() return ptype, token end
applied = nil
assert(pcall(ns.PowerSafeUpdateColor, frame, "x", "target"))
assert(applied and applied[3] == 1, "secret power type falls back to the mana colour instead of white")
-- A failing API call cannot leave the fill uncoloured either.
env.UnitPowerType = function() error("restricted") end
applied = nil
assert(pcall(ns.PowerSafeUpdateColor, frame, "x", "target"))
assert(applied and applied[3] == 1, "erroring UnitPowerType still colours the fill")
-- Alternative power colours given as 0-255 are normalised.
env.UnitPowerType = function() return 10, "ALT", 255, 0, 0 end
applied = nil
ns.PowerSafeUpdateColor(frame, "x", "target")
assert(applied[1] == 1 and applied[2] == 0, "alternative power colour kept")
-- Other units' updates are ignored and PostUpdateColor is still called.
applied = nil
ns.PowerSafeUpdateColor(frame, "x", "player")
assert(applied == nil, "other units ignored")
local post
frame.Power.PostUpdateColor = function() post = true end
env.UnitPowerType = function() return 1, "RAGE" end
ns.PowerSafeUpdateColor(frame, "x", "target")
assert(post, "PostUpdateColor runs")
print("power_color: ok")
