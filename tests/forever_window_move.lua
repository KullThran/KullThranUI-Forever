local combat = false
local shift = true
local module
local KT = { db = { profile = {} } }
function KT:NewModule() module = {}; return module end
LibStub = function() return { GetAddon = function() return KT end } end
InCombatLockdown = function() return combat end
IsShiftKeyDown = function() return shift end
IsControlKeyDown = function() return true end
local function frame(x, y)
    local f = { x = x or 0, y = y or 0, scale = 1, points = {{"CENTER", nil, "CENTER", x or 0, y or 0}}, scripts = {} }
    function f:GetCenter() return self.x, self.y end
    function f:GetEffectiveScale() return self.scale end
    function f:GetScale() return self.scale end
    function f:SetScale(s) assert(not combat, "scale changed in combat"); self.scale = s end
    function f:GetNumPoints() return #self.points end
    function f:GetPoint(i) return unpack(self.points[i]) end
    function f:ClearAllPoints() assert(not combat); self.points = {} end
    function f:SetPoint(a, b, c, x, y)
        assert(not combat, "position changed in combat")
        self.points = {{a, b, c, x, y}}; self.x, self.y = x, y
    end
    function f:SetMovable() end
    function f:SetClampedToScreen() end
    function f:EnableMouse() end
    function f:RegisterForDrag() end
    function f:HookScript(name, fn) self.scripts[name] = fn end
    function f:StartMoving() self.moving = true end
    function f:StopMovingOrSizing() self.moving = false end
    return f
end
UIParent = frame()
hooksecurefunc = function(f, name, callback)
    local original = f[name]
    f[name] = function(self, ...) original(self, ...); callback(self, ...) end
end
assert(loadfile("KullThranUI/Modules/ForeverWindowMove.lua"))()
module:OnInitialize()
CharacterFrame = frame(10, 20)
-- A title region can expose scripts without supporting Frame drag methods.
CharacterFrame.TitleContainer = { HookScript=function() error("invalid drag handle selected") end }
CharacterFrame.TitleBg = {}
ForeverCustomPanel = frame(5, 8)
UIPanelWindows = { ForeverCustomPanel = {} }
UISpecialFrames = { "ForeverEscapeDialog" }
ForeverEscapeDialog = frame(4, 6)
module:Discover()
assert(module.frames.ForeverCustomPanel and module.frames.ForeverEscapeDialog)
assert(module.frames.CharacterFrame)
assert(not module.frames.AuctionFrame, "missing frames must not appear")
AuctionFrame = frame(30, 40)
AuctionFrame.TitleContainer = { HookScript=function() error("invalid drag handle selected") end }
AuctionFrame.TitleFrame = frame()
module:Discover()
assert(AuctionFrame.TitleFrame.scripts.OnDragStart, "use a compatible title when available")
AuctionFrame.TitleFrame.scripts.OnDragStart()
assert(AuctionFrame.moving)
AuctionFrame.TitleFrame.scripts.OnDragStop()
assert(not AuctionFrame.moving)
assert(module.frames.AuctionFrame, "late-loaded windows must register")
local scripts = CharacterFrame.scripts
module:Discover()
assert(CharacterFrame.scripts == scripts)
module:SetPosition("CharacterFrame", 200, -80)
assert(CharacterFrame.x == 200 and CharacterFrame.y == -80)
CharacterFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
assert(CharacterFrame.x == 200, "Blizzard relayout should preserve custom position")
module:SetScale("CharacterFrame", 1.25)
assert(KT.db.profile.foreverWindowMove.frames.CharacterFrame.scale == 1.25)
module:SetDisabled("CharacterFrame", true)
assert(CharacterFrame.x == 10 and CharacterFrame.scale == 1)
assert(module:GetSettings("CharacterFrame").position.x == 200, "disable must preserve settings")
module:SetDisabled("CharacterFrame", false)
assert(CharacterFrame.x == 200 and CharacterFrame.scale == 1.25)
shift = false
scripts.OnDragStart()
assert(not CharacterFrame.moving)
shift = true
scripts.OnDragStart()
assert(CharacterFrame.moving)
CharacterFrame.x, CharacterFrame.y = 300, 100
scripts.OnDragStop()
assert(module:GetSettings("CharacterFrame").position.x == 375)
local oldProfile = KT.db.profile
KT.db.profile = {}
module:Refresh()
assert(CharacterFrame.x == 10 and CharacterFrame.y == 20 and CharacterFrame.scale == 1,
    "new profile must restore native layout")
KT.db.profile = oldProfile
module:Refresh()
assert(CharacterFrame.x == 375 and CharacterFrame.scale == 1.25)
combat = true
module:SetPosition("CharacterFrame", 999, 999)
module:SetScale("CharacterFrame", 2)
module:SetDisabled("CharacterFrame", true)
module:Reset("CharacterFrame")
module:Discover()
assert(CharacterFrame.x == 375 and CharacterFrame.scale == 1.25)
combat = false
module.db.savePosStrategy = "session"
module.db.saveScaleStrategy = "session"
module:SetScale("CharacterFrame", 1.4)
CharacterFrame.x, CharacterFrame.y = 50, 60
module:SavePosition("CharacterFrame")
local pos, scale = module:GetLayout("CharacterFrame")
assert(pos.x == 70 and scale == 1.4)
assert(module:GetSettings("CharacterFrame").scale == 1.25, "session must not overwrite permanent scale")
module.db.savePosStrategy = "off"
assert(module:GetLayout("CharacterFrame") == nil)
module:Reset("CharacterFrame")
assert(module:GetSettings("CharacterFrame").position == nil)
assert(CharacterFrame.x == 10 and CharacterFrame.scale == 1)
local file = assert(io.open("KullThranUI/Options.lua", "rb")); local options = file:read("*a"); file:close()
local body = options:match('local function BuildKUIMoveTab(.-)RegisterPage%("general"')
assert(body:find('GetModule("ForeverWindowMove", true)', 1, true))
for _, label in ipairs({"Name Filter", "Frame Positions", "Frame Scales", "X Offset", "Y Offset", "Scale", "Enable moving this window"}) do
    assert(body:find(label, 1, true), "missing embedded control: " .. label)
end
module.db.savePosStrategy = "permanent"
module:SetPosition("CharacterFrame", 120, 90)
module:OnDisable()
assert(CharacterFrame.x == 10 and not module:CanChange("CharacterFrame"))
assert(module:GetSettings("CharacterFrame").position.x == 120)
print("forever_window_move: PASS")
