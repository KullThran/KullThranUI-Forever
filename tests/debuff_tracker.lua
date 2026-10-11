local root = arg[1] or "."
local f = assert(io.open(root .. "/KullThranUI/Modules/Enhancements/Enhancements_DebuffTracker.lua"))
local source = f:read("*a"):gsub("\r\n", "\n"); f:close()

-- Minimal frame stub: every method is a no-op except visibility/alpha/desaturation.
local function Stub()
    local o = { shown = true, alpha = 1 }
    return setmetatable(o, { __index = function(t, k)
        if k == "Show" then return function(self) self.shown = true end end
        if k == "Hide" then return function(self) self.shown = false end end
        if k == "SetShown" then return function(self, v) self.shown = v and true or false end end
        if k == "IsShown" then return function(self) return self.shown end end
        if k == "SetAlpha" then return function(self, v) self.alpha = v end end
        if k == "SetDesaturated" then return function(self, v) self.desaturated = v end end
        if k == "SetText" then return function(self, v) self.text = v end end
        if k == "SetCooldown" then return function(self, s, d) self.cooldownSet = d end end
        if k == "Clear" then return function(self) self.cooldownSet = nil end end
        if k == "GetWidth" then return function() return 30 end end
        return function(self) return Stub() end
    end })
end

local state = { secret = false, aura = nil, instance = nil, instanceAlive = false, target = true }
local env = setmetatable({
    CreateFrame = function() return Stub() end,
    UIParent = Stub(), GetTime = function() return 100 end,
    UnitExists = function() return state.target end,
    UnitCanAttack = function() return true end,
    UnitIsDeadOrGhost = function() return false end,
    UnitClass = function() return "Warrior", "WARRIOR" end,
    IsPlayerSpell = function(id) return id ~= 772 end,
    IsInRaid = function() return false end, IsInGroup = function() return false end,
    strtrim = function(s) return (s:gsub("^%s+", ""):gsub("%s+$", "")) end,
    wipe = function(t) for k in pairs(t) do t[k] = nil end return t end,
    C_Timer = { After = function(_, fn) fn() end, NewTimer = function() return { Cancel = function() end } end },
    C_Spell = {
        GetSpellName = function(id) return ({ [7386] = "Sunder Armor", [772] = "Rend", [8647] = "Expose Armor" })[id] end,
        GetSpellTexture = function() return 1 end,
    },
    C_Secrets = {
        ShouldSpellAuraBeSecret = function() return state.secret end,
        ShouldAurasBeSecret = function() return state.secret end,
    },
    C_UnitAuras = {
        GetAuraDataBySpellName = function(_, name)
            if state.secret then return nil end
            return state.aura and name == "Sunder Armor" and state.aura or nil
        end,
        GetAuraDataByAuraInstanceID = function(_, id)
            if state.instanceAlive and id == state.instance then return { auraInstanceID = id } end
        end,
        GetAuraDuration = function() return nil end,
    },
}, { __index = _G })
local Mod = { db = { debuffTracker = { enabled = true } } }
function Mod:GetDB() return self.db end
env.ns = { Enhancements = Mod }
env.KT = {
    GetModule = function() return nil end, GetLocale = function() return nil end, Print = function() end,
    RegisterChatCommand = function() end, RegisterMovableElements = function() end,
    db = { profile = { editMode = { frames = {} } } }, FONT_PATH = "x",
}
env.ns.KT = env.KT
local chunk = assert(loadstring(source))
setfenv(chunk, env)
chunk(nil, env.ns)

Mod:InitializeDebuffTracker()
local icons = Mod.debuffTrackerIcons
local function Refresh() Mod:RefreshDebuffTracker() end

-- Only the player's own class and known spells: Sunder Armor shows, Rend is not
-- learned and Expose Armor belongs to rogues.
Refresh()
assert(icons[1] and icons[1]:IsShown() and not (icons[2] and icons[2]:IsShown()), "only known debuffs of your own class may show")

-- Readable and absent: missing (desaturated, glowing).
state.aura = nil; Refresh()
assert(icons[1].tex.desaturated == true and icons[1].glow:IsShown(), "absent debuff must show as missing")
assert(not icons[1].unknown:IsShown())

-- Readable and present: normal, no glow.
state.aura = { auraInstanceID = 7, duration = 30, expirationTime = 130, applications = 3 }; Refresh()
assert(icons[1].tex.desaturated == false and not icons[1].glow:IsShown() and icons[1].alpha == 1, "present debuff must look active")
assert(icons[1].cooldown.cooldownSet == 30 and icons[1].count.text == "3")

-- Restriction starts: the identified instance keeps the icon active.
state.secret = true; state.instance = 7; state.instanceAlive = true; Refresh()
assert(icons[1].tex.desaturated == false, "identified aura must stay present in combat")

-- The identified aura is gone while restricted: never claim it is missing.
state.instanceAlive = false; Refresh()
assert(icons[1].unknown:IsShown() and not icons[1].glow:IsShown(), "unverifiable state must show a question mark")

-- Restricted and never identified: unknown, not missing.
state.target = true
Refresh()
assert(icons[1].unknown:IsShown() and icons[1].tex.desaturated == true)

-- Restriction ends: readable again.
state.secret = false; state.aura = nil; Refresh()
assert(not icons[1].unknown:IsShown() and icons[1].glow:IsShown())

-- No target: the tracker stays visible, icons idle (dimmed, no glow, no question mark).
state.target = false; Refresh()
assert(Mod.debuffTrackerFrame:IsShown(), "the tracker must stay on screen without a target")
assert(icons[1]:IsShown() and icons[1].alpha <= 0.4 and not icons[1].glow:IsShown() and not icons[1].unknown:IsShown())
print("PASS: debuff tracker states (present, missing, unknown), restriction handling, own-class filter and idle display without a target")
