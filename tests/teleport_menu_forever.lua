-- Teleport Menu (Forever catalog): lists only teleports that exist in the client,
-- filters by class and faction, casts/uses through secure macros only when the
-- spell is learned / the item is in the bags, and never touches toy, housing or
-- equip APIs.
local root = arg[1] or "."
local function read(path)
    local f = assert(io.open(root .. "/" .. path)); local s = f:read("*a"); f:close(); return s
end

local function Widget()
    local w = { shown = true, events = {}, attrs = {} }
    return setmetatable(w, { __index = function(t, k)
        if k == "Show" then return function(self) self.shown = true end end
        if k == "Hide" then return function(self) self.shown = false end end
        if k == "IsShown" then return function(self) return self.shown end end
        if k == "SetShown" then return function(self, v) self.shown = v and true or false end end
        if k == "GetWidth" then return function() return 520 end end
        if k == "GetHeight" then return function() return 400 end end
        if k == "SetText" then return function(self, v) self.text = v end end
        if k == "SetAttribute" then return function(self, n, v) self.attrs[n] = v end end
        if k == "GetAttribute" then return function(self, n) return self.attrs[n] end end
        if k == "SetScript" then return function(self, n, fn) self[n] = fn end end
        if k == "CreateTexture" or k == "CreateFontString" then return function() return Widget() end end
        return function() end
    end })
end

-- Player state the test flips per scenario.
local player = { class = "MAGE", faction = "Alliance", race = "Human", combat = false,
    spells = {}, bags = {} }

local created = {}
local forbidden = {}
local function Forbid(name)
    return function() forbidden[#forbidden + 1] = name end
end

local KT = {}
function KT:GetLocale() return {} end
local Mod = {}
function Mod:RegisterEvent() end
function Mod:RegisterChatCommand() end
function KT:NewModule() return Mod end
KT.db = { profile = {} }

local tooltip = { lines = {} }
function tooltip:SetOwner() self.lines = {} end
function tooltip:SetSpellByID(id) self.lines[#self.lines + 1] = "spell:" .. id end
function tooltip:SetItemByID(id) self.lines[#self.lines + 1] = "item:" .. id end
function tooltip:AddLine(t) self.lines[#self.lines + 1] = t end
function tooltip:Show() end
function tooltip:Hide() end

local libs = { ["AceAddon-3.0"] = { GetAddon = function() return KT end } }
local env = setmetatable({
    KT = KT, GameTooltip = tooltip, UIParent = Widget(),
    LibStub = function(name) return libs[name] end,
    CreateFrame = function(kind, name) local f = Widget(); created[#created + 1] = f; return f end,
    InCombatLockdown = function() return player.combat end,
    UnitClass = function() return "x", player.class end,
    UnitRace = function() return "x", player.race end,
    UnitFactionGroup = function() return player.faction end,
    IsPlayerSpell = function(id) return player.spells[id] == true end,
    C_Spell = {
        GetSpellInfo = function(id) return { name = "Spell" .. id, iconID = 100 + id } end,
        GetSpellName = function(id) return "Spell" .. id end,
        GetSpellCooldown = function() return { startTime = 0, duration = 0 } end,
    },
    C_Item = {
        GetItemCount = function(id) return player.bags[id] or 0 end,
        GetItemCooldown = function() return 0, 0 end,
        GetItemInfoInstant = function(id) return id, "t", "s", "e", 200 + id end,
        IsItemDataCachedByID = function() return false end,
    },
    C_Timer = { After = function() end },
    -- Retail-only / unsupported on the server: any call fails the test.
    C_ToyBox = setmetatable({}, { __index = function() return Forbid("C_ToyBox") end }),
    PlayerHasToy = Forbid("PlayerHasToy"),
    C_Housing = setmetatable({}, { __index = function() return Forbid("C_Housing") end }),
    EquipItemByName = Forbid("EquipItemByName"),
    select = select, ipairs = ipairs, pairs = pairs, type = type, pcall = pcall, tonumber = tonumber,
    tostring = tostring, string = string, table = table, math = math, setmetatable = setmetatable,
    unpack = unpack, next = next,
}, { __index = _G })
env._G = env

local chunk = assert(loadstring(read("KullThranUI_TeleportMenu/Modules/TeleportMenu/TeleportMenu.lua"), "TeleportMenu"))
setfenv(chunk, env)
chunk("KullThranUI_TeleportMenu", {})

-- Static catalog sanity: nothing from the Retail copy is left.
local cats = {}
for _, c in ipairs(Mod.Categories) do cats[c] = true end
assert(cats.Hearthstones and cats["Class & Racial"] and cats.Items and not cats.Toys and not cats.Dungeons
    and not cats.Raids and not cats.Delves and #Mod.Categories == 3, "only the three vanilla categories exist")
for cat, list in pairs(Mod.TeleportData) do
    for _, entry in ipairs(list) do
        assert(entry.type == "spell" or entry.type == "item", cat .. ": no toy/housing entries")
        assert(not entry.equippable and not entry.cosmetic, cat .. ": no equip/cosmetic entries")
    end
end

-- A fake window with what ShowCategory touches.
local frame = { content = Widget(), scroll = Widget(), countLabel = Widget(), contentOuter = Widget(), tabs = {} }
function Mod:CreateMenuFrame() return frame end
Mod.db = { buttonSize = 36, buttonSpacing = 4, columns = 10, showLabels = true, showTooltip = true }
Mod.buttons, Mod.secureButtons, Mod.groupHeaders = {}, {}, {}

local function shownButtons()
    local out = {}
    for _, b in ipairs(Mod.secureButtons) do if b.shown then out[#out + 1] = b end end
    return out
end

-- 1. Alliance mage, two teleports learned, 3 runes in the bags.
player.spells = { [3561] = true, [10059] = true }
player.bags = { [17031] = 3, [6948] = 1 }
Mod:ShowCategory("Class & Racial")
local btns = shownButtons()
assert(#btns == 6, "Alliance mage sees 3 teleports + 3 portals, got " .. #btns)
local macros = {}
for _, b in ipairs(btns) do macros[b.data.id] = b.attrs.macrotext end
assert(macros[3561] == "/cast Spell3561" and macros[10059] == "/cast Spell10059", "learned spells cast by macro")
assert(macros[3562] == nil, "an unlearned spell has no action")
assert(btns[1].attrs.type == "macro", "learned spell button is a macro button")
assert(frame.countLabel.text:find("6 teleports") and frame.countLabel.text:find("2 available"), frame.countLabel.text)
assert(#Mod.groupHeaders == 2, "Teleports and Portals headers")
assert(btns[1].count.text == 3, "reagent count shown on the button")

-- 2. Horde shaman: Astral Recall only.
player.class, player.faction, player.spells = "SHAMAN", "Horde", { [556] = true }
Mod:ShowCategory("Class & Racial")
btns = shownButtons()
assert(#btns == 1 and btns[1].data.id == 556 and btns[1].attrs.macrotext == "/cast Spell556", "shaman sees Astral Recall")

-- 3. Hearthstone is a /use item macro only while it is in the bags.
Mod:ShowCategory("Hearthstones")
btns = shownButtons()
assert(#btns == 1 and btns[1].attrs.macrotext == "/use item:6948", "hearthstone uses the item")
player.bags[6948] = nil
Mod:ShowCategory("Hearthstones")
btns = shownButtons()
assert(btns[1].attrs.type == nil, "item not in the bags is not actionable")

-- 4. Horde mage never sees Alliance portals.
player.class, player.faction = "MAGE", "Horde"
Mod:ShowCategory("Class & Racial")
for _, b in ipairs(shownButtons()) do
    assert(b.data.factionReq ~= "Alliance", "no Alliance entries for a Horde mage")
end

-- 5. In combat nothing is rebuilt (secure attributes cannot change).
player.combat = true
local before = #shownButtons()
Mod:ShowCategory("Items")
assert(Mod.pendingCategory == "Items" and #shownButtons() == before, "combat defers the rebuild")

assert(#forbidden == 0, "unsupported API called: " .. table.concat(forbidden, ", "))
print("teleport_menu_forever: ok")
