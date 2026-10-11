local root = arg[1] or "."
local function read(path)
    local f = assert(io.open(root .. "/" .. path)); local s = f:read("*a"); f:close(); return s
end
local adapter
local KT = { db = { profile = { unitFrames = {
    player = { leftTextContent = "name", rightTextContent = "both", powerPercentText = "none" },
    target = { leftTextContent = "name", rightTextContent = "perhp" },
}, visualTheme = { slots = { unitframes = { classic = {}, kui = {}, retail = {}, forever = {} } } } } },
    VisualThemes = {} }
function KT.VisualThemes:RegisterModule(_, value) adapter = value end
local env = setmetatable({LibStub = function() return {GetAddon = function() return KT end} end}, {__index = _G})
local run = assert(loadstring(read("KullThranUI/Modules/VisualThemes/Adapters/UnitFrames.lua")))
setfenv(run, env); run()
local p = adapter.getProfile()
local slots = KT.db.profile.visualTheme.slots.unitframes
assert(slots.classic["player.leftTextContent"] == "name")
assert(slots.kui["target.rightTextContent"] == "perhp")
for _, theme in ipairs({"retail", "forever"}) do
    p._ktModernNumbersV1 = nil
    adapter.validate(p, theme)
    for _, unit in ipairs({p.player, p.target}) do
        assert(unit.leftTextContent == "perhp" and unit.rightTextContent == "curhp")
        assert(unit.centerTextContent == "name")
        assert(unit.powerPercentText == "right" and unit.powerTextFormat == "curpp")
        assert(unit.powerShowPercent == false)
    end
    p.player.rightTextContent = "none"
    adapter.validate(p, theme)
    assert(p.player.rightTextContent == "curhp", "theme validation repairs stale text settings")
end
adapter.seed(p, "classic", "forever")
assert(p.player.leftTextContent == "name" and p.player.rightTextContent == "both")
assert(p.player.powerPercentText == "none")
local owned = {}; for _, path in ipairs(adapter.getOwnedPaths()) do owned[path] = true end
assert(owned["player.centerTextContent"] and owned["target.powerTextFormat"] and owned._ktModernNumbersV1)
local assets = read("KullThranUI/Modules/VisualThemes/ThemeClientAssets.lua")
local a = assert(assets:find("function KT.VisualThemes:ApplyBlizzardBarText", 1, true))
local b = assert(assets:find("function KT.VisualThemes:ApplyBlizzardNameText", a, true))
local fontEnv = setmetatable({KT = KT}, {__index = _G})
KT.VisualThemes.NativeStockFonts = {TextStatusBarText = {"native-friz.ttf",10,"OUTLINE"}}
function KT.VisualThemes:GetNativeStockFont(name, path, size, flags)
    local native=self.NativeStockFonts[name]
    if native then return unpack(native) end
    return path,size,flags
end
function KT.VisualThemes:GetRenderedTheme() return "retail" end
fontEnv.hooksecurefunc = function(obj, method, hook)
    local original=obj[method]
    obj[method]=function(self,...)
        original(self,...); hook(self,...)
    end
end
run = assert(loadstring(assets:sub(a, b - 1))); setfenv(run, fontEnv); run()
TextStatusBarText = {GetFont = function() return "native-friz.ttf", 10, "OUTLINE" end}
local fs = {_ktBlizzName = {path = "old-name"}}
function fs:SetFont(path, size, flags) self.path, self.size, self.flags = path, size, flags end
function fs:SetTextColor(...) self.color = {...} end
KT.VisualThemes:ApplyBlizzardBarText(fs, 1.5, 15)
assert(fs.path == "native-friz.ttf" and fs.size == 13.5 and fs.flags == "OUTLINE")
assert(not fs._ktBlizzName and fs.color[1] == 1 and fs.color[2] == 1)
fs:SetFont("global-font.ttf", 24, "")
assert(fs.path=="native-friz.ttf" and fs.size==13.5, "generic writes cannot change the stock font")
function KT.VisualThemes:GetRenderedTheme() return "kui" end
fs:SetFont("global-font.ttf", 24, "")
assert(fs.path=="global-font.ttf", "other visual styles retain editable fonts")
local source = read("KullThranUI_UnitFrames/Modules/KUIUnitFrames/KUIUnitFrames.lua")
a = assert(source:find("function ns.UsesModernNumbers()", 1, true))
b = assert(source:find("local POWER_PERCENT_TAG_METHOD", a, true))
local ns, oUF = {}, {Tags = {Methods = {}, Events = {}}}
local tagEnv = setmetatable({ns = ns, KT = KT, oUF = oUF,
    UnitHealth = function() return 1928 end, UnitPower = function() return 100 end,
    UnitPowerType = function() return 3 end,
    BreakUpLargeNumbers = function(n) return n == 1928 and "1,928" or tostring(n) end,
    SMART_POWER_TAG_EVENTS = "UNIT_POWER_UPDATE UNIT_MAXPOWER"}, {__index = _G})
run = assert(loadstring(source:sub(a, b - 1))); setfenv(run, tagEnv); run()
assert(oUF.Tags.Methods["kui-hpfull"]("player") == "1,928")
assert(oUF.Tags.Methods["kui-ppfull"]("target") == "100")
print("stock_numbers: ok")
