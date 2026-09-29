local function expect(actual, expected, label)
    if actual ~= expected then
        error(string.format("%s: expected %s, got %s", label, tostring(expected), tostring(actual)))
    end
end

_G.InCombatLockdown = function() return false end
_G.hooksecurefunc = function(obj, method, fn)
    local orig = obj[method]
    obj[method] = function(...)
        if orig then orig(...) end
        fn(...)
    end
end
_G.C_AddOns = { IsAddOnLoaded = function() return false end }

local KT = { modules = {} }
function KT:NewModule(name, ...)
    local m = {}
    self.modules[name] = m
    return m
end
local ace = {}
function ace:GetAddon() return KT end
function _G.LibStub() return ace end

local function NewBar(width)
    local bar = { _width = width }
    function bar:SetWidth(w) self._width = w end
    function bar:GetWidth() return self._width end
    return bar
end

local function NewFrame(name, width, height)
    local f = { _name = name, _width = width, _height = height }
    function f:GetName() return self._name end
    function f:SetWidth(w) self._width = w end
    function f:GetWidth() return self._width end
    function f:SetSize(w, h) self._width, self._height = w, h end
    function f:GetHeight() return self._height end
    function f:GetChildren() end
    function f:HookScript() end
    return f
end

assert(loadfile("KullThranUI/Modules/UnitFramesWidth.lua"))("KullThranUI", {})
local M = KT.modules["UnitFramesWidth"]

-- Regression test: KUIUnitFrames.lua/ThemeClientAssets.lua own Forever's
-- real stock geometry, where Health is deliberately narrower than the frame
-- (a portrait occupies the rest of the 232x100 box). Confirmed live: this
-- module force-reset frame.Health back to the frame's own full width on
-- every PLAYER_TARGET_CHANGED, permanently undoing that real geometry with
-- nothing left to correct it -- the "health text/status icon moves and
-- stays broken" bug. KUI-managed frames must be left alone entirely.
local kuiFrame = NewFrame("KullThranUI_UF_Player", 230.19, 99.22)
kuiFrame.Health = NewBar(125.02)
local kuiResult = M:ApplyWidthToFrame(kuiFrame, "player")
expect(kuiResult, true, "KUI frame apply result")
expect(kuiFrame.Health:GetWidth(), 125.02, "KUI-managed frame's Health width must be left untouched")
expect(kuiFrame:GetWidth(), 230.19, "KUI-managed frame's own width must be left untouched")

-- Third-party/legacy frames are this module's actual intended target: a
-- stale legacy width (181/187, see LEGACY_DEFAULT_WIDTHS) must still get
-- normalized to DESIRED_WIDTH (230), same as before this fix.
local legacyFrame = NewFrame("UUF_Player", 181, 40)
legacyFrame.Health = NewBar(181)
local legacyResult = M:ApplyWidthToFrame(legacyFrame, "player")
expect(legacyResult, true, "legacy frame apply result")
expect(legacyFrame.Health:GetWidth(), 230, "legacy third-party frame's Health width must still be normalized")
expect(legacyFrame:GetWidth(), 230, "legacy third-party frame's own width must still be normalized")

print("unit_frames_width: ok")
