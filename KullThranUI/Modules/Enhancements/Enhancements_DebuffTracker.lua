local _, ns = ...
local KT = ns.KT or _G.KT
local Mod = ns.Enhancements or KT:GetModule("Enhancements", true)
if not Mod then return end

-- Shows which of YOUR OWN debuffs (the ones your class can apply) a hostile
-- target is MISSING.
--
-- Aura reads on enemies are restricted (combat, encounters, challenge mode, PvP):
-- the queries then return nothing, which cannot be told apart from "not there".
-- Every icon therefore has three states:
--   present  readable now, or an aura identified before the restriction that is
--            still alive (checked by instance ID, which is never secret);
--   missing  readable now and not on the target;
--   unknown  restricted and not identified: shown as "?", never as missing.

local DEFAULT_POSITION = { point = "CENTER", relativePoint = "CENTER", x = 270, y = -278 }
local MAX_ICONS = 14

-- The debuffs YOU can put on an enemy, per class. `aura` is the rank 1 spell ID
-- of the debuff (its localized name is resolved at runtime and matched on the
-- target, so every rank counts); `cast` is the spell that has to be in your
-- spellbook for the entry to show (defaults to `aura`). Entries the client or
-- your character do not know are skipped. `own` entries only count when YOU
-- applied them (damage over time, slows); the rest are shared raid debuffs that
-- count whoever applied them.
local CLASS_ENTRIES = {
    WARRIOR = {
        { key = "sunder", aura = 7386 }, { key = "rend", aura = 772, own = true },
        { key = "thunderclap", aura = 6343 }, { key = "demoshout", aura = 1160 },
        { key = "hamstring", aura = 1715, own = true },
    },
    ROGUE = {
        { key = "expose", aura = 8647 }, { key = "rupture", aura = 1943, own = true },
        { key = "garrote", aura = 703, own = true }, { key = "hemorrhage", aura = 16511 },
    },
    HUNTER = {
        { key = "huntersmark", aura = 1130 }, { key = "serpentsting", aura = 1978, own = true },
        { key = "scorpidsting", aura = 3043, own = true }, { key = "concussive", aura = 5116, own = true },
    },
    DRUID = {
        { key = "faerie", aura = 770 }, { key = "moonfire", aura = 8921, own = true },
        { key = "rake", aura = 1822, own = true }, { key = "rip", aura = 1079, own = true },
        { key = "demoroar", aura = 99 },
    },
    WARLOCK = {
        { key = "recklessness", aura = 704 }, { key = "elements", aura = 1490 },
        { key = "agony", aura = 980, own = true }, { key = "weakness", aura = 702 },
        { key = "tongues", aura = 1714 }, { key = "corruption", aura = 172, own = true },
        { key = "immolate", aura = 348, own = true },
    },
    PRIEST = {
        { key = "swpain", aura = 589, own = true }, { key = "holyfire", aura = 14914, own = true },
        { key = "vampiric", aura = 15286 }, { key = "plague", aura = 2944, own = true },
    },
    PALADIN = {
        { key = "wisdom", aura = 20186, cast = 20166 }, { key = "light", aura = 20185, cast = 20165 },
        { key = "crusader", aura = 21183, cast = 21082 }, { key = "justice", aura = 20184, cast = 20164 },
    },
    SHAMAN = {
        { key = "flameshock", aura = 8050, own = true }, { key = "frostshock", aura = 8056, own = true },
        { key = "stormstrike", aura = 17364, own = true },
    },
    MAGE = {
        { key = "firevuln", aura = 22959, cast = 2948 }, { key = "frostbolt", aura = 116, own = true },
    },
}
Mod.DebuffTrackerClassEntries = CLASS_ENTRIES

local container, events, testing, testTimer
local icons = {}
local known = {} -- [entry.key] = aura instance ID identified while readable
Mod.debuffTrackerIcons = icons
local updateQueued

local function L(text)
    local locale = KT.GetLocale and KT:GetLocale()
    local value = locale and locale[text]
    return type(value) == "string" and value ~= "" and value or text
end

local function IsSecret(value)
    if value == nil or not issecretvalue then return false end
    local ok, secret = pcall(issecretvalue, value)
    return ok and secret == true
end

local function Config()
    local db = Mod:GetDB()
    db.debuffTracker = db.debuffTracker or {}
    local c = db.debuffTracker
    if c.iconSize == nil then c.iconSize = 30 end
    if c.spacing == nil then c.spacing = 2 end
    if c.scale == nil then c.scale = 1 end
    if c.growth == nil then c.growth = "RIGHT" end
    if c.showTimers == nil then c.showTimers = true end
    if c.glowMissing == nil then c.glowMissing = true end
    if c.missingAlpha == nil then c.missingAlpha = 0.5 end
    c.hidden = c.hidden or {}
    c.custom = c.custom or {}
    return c
end

local function SpellName(id)
    if not id then return nil end
    if C_Spell and C_Spell.GetSpellName then
        local ok, name = pcall(C_Spell.GetSpellName, id)
        if ok and type(name) == "string" and name ~= "" then return name end
    end
    if GetSpellInfo then
        local ok, name = pcall(GetSpellInfo, id)
        if ok and type(name) == "string" and name ~= "" then return name end
    end
end

local function SpellTexture(id, fallback)
    if id and C_Spell and C_Spell.GetSpellTexture then
        local ok, texture = pcall(C_Spell.GetSpellTexture, id)
        if ok and texture then return texture end
    end
    return fallback or 134400
end

local function SpellKnown(castID, name)
    if castID then
        if IsPlayerSpell then
            local ok, known = pcall(IsPlayerSpell, castID)
            if ok and known then return true end
        end
        if C_SpellBook and C_SpellBook.IsSpellKnown then
            local ok, known = pcall(C_SpellBook.IsSpellKnown, castID)
            if ok and known then return true end
        end
    end
    -- Ranks and talents: a spell found by name is in the spellbook.
    if name and C_Spell and C_Spell.GetSpellInfo then
        local ok, info = pcall(C_Spell.GetSpellInfo, name)
        if ok and info then return true end
    end
    return false
end

-- Your class's debuffs that your character knows, then your own additions.
function Mod:GetDebuffTrackerEntries()
    local config = Config()
    local list = {}
    local _, class = UnitClass("player")
    for _, def in ipairs(CLASS_ENTRIES[class] or {}) do
        local name = SpellName(def.aura)
        if name and SpellKnown(def.cast or def.aura, SpellName(def.cast or def.aura) or name) then
            list[#list + 1] = {
                key = def.key, name = name, spellID = def.aura, own = def.own,
                icon = SpellTexture(def.aura), enabled = config.hidden[def.key] ~= true,
            }
        end
    end
    for index, custom in ipairs(config.custom) do
        local name = custom.id and SpellName(custom.id) or custom.name
        if type(name) == "string" and name ~= "" then
            list[#list + 1] = {
                key = "custom" .. index, name = name, spellID = custom.id, custom = true,
                icon = SpellTexture(custom.id), enabled = true,
            }
        end
    end
    return list
end

function Mod:AddDebuffTrackerCustom(text)
    text = type(text) == "string" and strtrim(text) or ""
    if text == "" then return false end
    local config = Config()
    if #config.custom >= 6 then return false end
    local id = tonumber(text)
    local name = id and SpellName(id) or text
    if not name then return false end
    for _, custom in ipairs(config.custom) do
        if (custom.id and custom.id == id) or (not custom.id and custom.name == name) then return false end
    end
    config.custom[#config.custom + 1] = { id = id, name = (not id) and name or nil }
    self:RefreshDebuffTracker()
    return true
end

function Mod:ClearDebuffTrackerCustom()
    Config().custom = {}
    self:RefreshDebuffTracker()
end

-- True while aura queries about this spell would return secret values.
local function AuraSecretNow(entry)
    if not C_Secrets then return false end
    if entry.spellID and C_Secrets.ShouldSpellAuraBeSecret then
        local ok, value = pcall(C_Secrets.ShouldSpellAuraBeSecret, entry.spellID)
        if ok then return value == true end
    end
    if C_Secrets.ShouldAurasBeSecret then
        local ok, value = pcall(C_Secrets.ShouldAurasBeSecret)
        if ok then return value == true end
    end
    return false
end

local function ReadAura(name, own)
    local filter = own and "HARMFUL|PLAYER" or "HARMFUL"
    if C_UnitAuras and C_UnitAuras.GetAuraDataBySpellName then
        local ok, aura = pcall(C_UnitAuras.GetAuraDataBySpellName, "target", name, filter)
        if ok then return aura end
        return nil
    end
    if C_UnitAuras and C_UnitAuras.GetAuraDataByIndex then
        for index = 1, 40 do
            local ok, aura = pcall(C_UnitAuras.GetAuraDataByIndex, "target", index, filter)
            if not ok or not aura then return nil end
            if not IsSecret(aura.name) and aura.name == name then return aura end
        end
    end
end

-- Returns state, aura (when readable) and the aura instance ID (when known).
local function Evaluate(entry)
    if AuraSecretNow(entry) then
        local id = known[entry.key]
        if id and C_UnitAuras and C_UnitAuras.GetAuraDataByAuraInstanceID then
            local ok, data = pcall(C_UnitAuras.GetAuraDataByAuraInstanceID, "target", id)
            if ok and data then return "present", nil, id end
        end
        known[entry.key] = nil
        return "unknown"
    end
    local aura = ReadAura(entry.name, entry.own)
    if aura then
        known[entry.key] = aura.auraInstanceID
        return "present", aura, aura.auraInstanceID
    end
    known[entry.key] = nil
    return "missing"
end

local function BuildIcon(parent)
    local icon = CreateFrame("Frame", nil, parent)
    icon.border = icon:CreateTexture(nil, "BACKGROUND")
    icon.border:SetAllPoints()
    icon.border:SetColorTexture(0, 0, 0, 1)
    icon.tex = icon:CreateTexture(nil, "ARTWORK")
    icon.tex:SetPoint("TOPLEFT", 1, -1)
    icon.tex:SetPoint("BOTTOMRIGHT", -1, 1)
    icon.tex:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    icon.cooldown = CreateFrame("Cooldown", nil, icon, "CooldownFrameTemplate")
    icon.cooldown:SetAllPoints(icon.tex)
    icon.cooldown:SetDrawEdge(false)
    icon.glow = icon:CreateTexture(nil, "OVERLAY")
    icon.glow:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")
    icon.glow:SetBlendMode("ADD")
    icon.glow:SetVertexColor(0.9, 0.05, 0.05, 1)
    icon.glow:SetPoint("CENTER")
    icon.glow:Hide()
    icon.pulse = icon.glow:CreateAnimationGroup()
    icon.pulse:SetLooping("BOUNCE")
    local alpha = icon.pulse:CreateAnimation("Alpha")
    alpha:SetFromAlpha(1)
    alpha:SetToAlpha(0.25)
    alpha:SetDuration(0.6)
    -- A font string needs its font before any SetText, so set it at creation.
    local font = KT.FONT_PATH or "Fonts\\FRIZQT__.TTF"
    icon.count = icon:CreateFontString(nil, "OVERLAY")
    icon.count:SetFont(font, 12, "OUTLINE")
    icon.count:SetPoint("BOTTOMRIGHT", -1, 1)
    icon.unknown = icon:CreateFontString(nil, "OVERLAY")
    icon.unknown:SetFont(font, 16, "OUTLINE")
    icon.unknown:SetPoint("CENTER", 0, 0)
    icon.unknown:SetText("?")
    icon.unknown:Hide()
    return icon
end

local function Build()
    if container then return container end
    container = CreateFrame("Frame", "KullThranUIForeverDebuffTracker", UIParent)
    container:SetFrameStrata("MEDIUM")
    container:SetSize(30, 30)
    container:Hide()
    Mod.debuffTrackerFrame = container
    return container
end

local function StyleIcon(icon, config)
    local size = config.iconSize
    icon:SetSize(size, size)
    icon.glow:SetSize(size * 1.7, size * 1.7)
    local font = KT.FONT_PATH or "Fonts\\FRIZQT__.TTF"
    if not icon.count:SetFont(font, math.max(9, math.floor(size * 0.42)), "OUTLINE") then
        icon.count:SetFont("Fonts\\FRIZQT__.TTF", math.max(9, math.floor(size * 0.42)), "OUTLINE")
    end
    if not icon.unknown:SetFont(font, math.max(12, math.floor(size * 0.6)), "OUTLINE") then
        icon.unknown:SetFont("Fonts\\FRIZQT__.TTF", math.max(12, math.floor(size * 0.6)), "OUTLINE")
    end
    icon.cooldown:SetHideCountdownNumbers(not config.showTimers)
end

local function SetCooldown(icon, aura, instanceID)
    local cooldown = icon.cooldown
    if aura and not IsSecret(aura.expirationTime) and not IsSecret(aura.duration)
        and aura.duration and aura.duration > 0 and aura.expirationTime then
        cooldown:SetCooldown(aura.expirationTime - aura.duration, aura.duration)
        return
    end
    if instanceID and C_UnitAuras and C_UnitAuras.GetAuraDuration and cooldown.SetCooldownFromDurationObject then
        local ok, duration = pcall(C_UnitAuras.GetAuraDuration, "target", instanceID)
        if ok and duration then
            if pcall(cooldown.SetCooldownFromDurationObject, cooldown, duration) then return end
        end
    end
    cooldown:Clear()
end

local function SetCount(icon, aura, instanceID)
    local text
    if aura and not IsSecret(aura.applications) then
        if aura.applications and aura.applications > 1 then text = tostring(aura.applications) end
    elseif instanceID and C_UnitAuras and C_UnitAuras.GetAuraApplicationDisplayCount then
        local ok, value = pcall(C_UnitAuras.GetAuraApplicationDisplayCount, "target", instanceID, 2)
        if ok then text = value end
    end
    if text then icon.count:SetText(text) else icon.count:SetText("") end
end

local function Render(icon, entry, state, aura, instanceID, config)
    icon.tex:SetTexture(entry.icon)
    StyleIcon(icon, config)
    icon.glow:Hide()
    icon.pulse:Stop()
    icon.unknown:Hide()
    if state == "present" then
        icon.tex:SetDesaturated(false)
        icon:SetAlpha(1)
        SetCooldown(icon, aura, instanceID)
        SetCount(icon, aura, instanceID)
    elseif state == "missing" then
        icon.tex:SetDesaturated(true)
        icon:SetAlpha(config.missingAlpha)
        icon.cooldown:Clear()
        icon.count:SetText("")
        if config.glowMissing then icon.glow:Show(); icon.pulse:Play() end
    else
        icon.tex:SetDesaturated(true)
        icon:SetAlpha(0.7)
        icon.cooldown:Clear()
        icon.count:SetText("")
        icon.unknown:Show()
    end
end

local function Layout(shown, config)
    local size, gap = config.iconSize, config.spacing
    local horizontal = config.growth == "RIGHT" or config.growth == "LEFT"
    local count = math.max(1, shown)
    local total = count * size + (count - 1) * gap
    container:SetSize(horizontal and total or size, horizontal and size or total)
    local index = 0
    for _, icon in ipairs(icons) do
        if icon:IsShown() then
            icon:ClearAllPoints()
            local offset = index * (size + gap)
            if config.growth == "RIGHT" then icon:SetPoint("LEFT", container, "LEFT", offset, 0)
            elseif config.growth == "LEFT" then icon:SetPoint("RIGHT", container, "RIGHT", -offset, 0)
            elseif config.growth == "DOWN" then icon:SetPoint("TOP", container, "TOP", 0, -offset)
            else icon:SetPoint("BOTTOM", container, "BOTTOM", 0, offset) end
            index = index + 1
        end
    end
end

local function TargetUsable()
    if not UnitExists("target") then return false end
    local attackable = UnitCanAttack("player", "target")
    if IsSecret(attackable) or not attackable then return false end
    local dead = UnitIsDeadOrGhost("target")
    return not IsSecret(dead) and not dead
end

local TEST_STATES = { "present", "missing", "unknown" }

local function Update()
    updateQueued = nil
    if not container then return end
    local config = Config()
    if not config.enabled and not testing then
        container:Hide()
        return
    end
    local entries = Mod:GetDebuffTrackerEntries()
    local active = {}
    if testing then
        for _, entry in ipairs(entries) do if entry.enabled then active[#active + 1] = entry end end
    elseif TargetUsable() then
        for _, entry in ipairs(entries) do
            if entry.enabled then active[#active + 1] = entry end
        end
    end
    local shown = 0
    for index = 1, math.min(#active, MAX_ICONS) do
        local entry = active[index]
        icons[index] = icons[index] or BuildIcon(container)
        local icon = icons[index]
        icon:Show()
        shown = shown + 1
        if testing then
            Render(icon, entry, TEST_STATES[(index - 1) % 3 + 1], nil, nil, config)
            if (index - 1) % 3 == 0 then icon.cooldown:SetCooldown(GetTime(), 30) end
        else
            local state, aura, instanceID = Evaluate(entry)
            Render(icon, entry, state, aura, instanceID, config)
        end
    end
    for index = shown + 1, #icons do icons[index]:Hide() end
    Layout(shown, config)
    container:SetShown(shown > 0)
end

local function QueueUpdate()
    if updateQueued then return end
    updateQueued = true
    if C_Timer and C_Timer.After then C_Timer.After(0, Update) else Update() end
end

function Mod:ApplyDebuffTrackerPosition()
    local frame = Build()
    local um = KT:GetModule("UnlockMode", true)
    if um and um.pendingPositions and um.pendingPositions.ENH_DEBUFF_TRACKER then return end
    local edit = KT.db.profile.editMode
    local p = edit and edit.frames and edit.frames.ENH_DEBUFF_TRACKER or Config().position or DEFAULT_POSITION
    frame:ClearAllPoints()
    frame:SetPoint(p.point or "CENTER", UIParent, p.relativePoint or p.point or "CENTER", p.x or 0, p.y or 0)
    frame:SetScale(Config().scale)
end

function Mod:RegisterDebuffTrackerMover()
    if self.debuffTrackerMoverRegistered then return end
    self.debuffTrackerMoverRegistered = true
    KT:RegisterMovableElements({{
        key = "ENH_DEBUFF_TRACKER", label = L("Debuff Tracker"), group = "Enhancements",
        getFrame = Build, getSize = function() local f = Build(); return f:GetWidth(), f:GetHeight() end,
        isHidden = function() return false end,
        loadPosition = function() return Config().position or DEFAULT_POSITION end,
        savePosition = function(_, point, relativePoint, x, y)
            local p = { point = point, relativePoint = relativePoint, x = x, y = y }
            Config().position = p
            KT.db.profile.editMode = KT.db.profile.editMode or { frames = {} }
            KT.db.profile.editMode.frames = KT.db.profile.editMode.frames or {}
            KT.db.profile.editMode.frames.ENH_DEBUFF_TRACKER = p
        end,
        applyPosition = function() Mod:ApplyDebuffTrackerPosition() end,
        applyPendingPosition = function(_, p)
            local f = Build()
            f:ClearAllPoints()
            f:SetPoint(p.point, UIParent, p.relativePoint or p.point, p.x, p.y)
        end,
    }})
end

function Mod:InitializeDebuffTracker()
    if self.debuffTrackerInitialized then return end
    self.debuffTrackerInitialized = true
    Build()
    events = CreateFrame("Frame")
    for _, event in ipairs({ "PLAYER_TARGET_CHANGED", "SPELLS_CHANGED", "PLAYER_ENTERING_WORLD",
        "PLAYER_REGEN_DISABLED", "PLAYER_REGEN_ENABLED", "ADDON_RESTRICTION_STATE_CHANGED", "UNIT_FLAGS" }) do
        pcall(events.RegisterEvent, events, event)
    end
    pcall(events.RegisterUnitEvent, events, "UNIT_AURA", "target")
    events:SetScript("OnEvent", function(_, event)
        if event == "PLAYER_TARGET_CHANGED" then
            wipe(known)
        end
        QueueUpdate()
    end)
    -- Restriction states can flip without any aura event: re-check twice a second.
    local elapsed = 0
    container:SetScript("OnUpdate", function(_, step)
        elapsed = elapsed + step
        if elapsed < 0.5 then return end
        elapsed = 0
        if not testing and container:IsShown() then Update() end
    end)
    self:RegisterDebuffTrackerMover()
    self:ApplyDebuffTrackerPosition()
    QueueUpdate()
end

function Mod:RefreshDebuffTracker()
    local config = Config()
    if config.enabled and not self.debuffTrackerInitialized then
        self:InitializeDebuffTracker()
    end
    if not container then return end
    self:ApplyDebuffTrackerPosition()
    -- Icons are rebuilt from the saved settings; the entry list may have changed.
    Update()
end

function Mod:RunDebuffTrackerTest()
    if not self.debuffTrackerInitialized then self:InitializeDebuffTracker() end
    testing = true
    if testTimer and testTimer.Cancel then testTimer:Cancel() end
    if C_Timer and C_Timer.NewTimer then
        testTimer = C_Timer.NewTimer(25, function() Mod:StopDebuffTrackerTest() end)
    end
    self:ApplyDebuffTrackerPosition()
    Update()
end

function Mod:StopDebuffTrackerTest()
    testing = false
    if testTimer and testTimer.Cancel then testTimer:Cancel() end
    testTimer = nil
    Update()
end

local SECRECY = { [0] = "NeverSecret", [1] = "AlwaysSecret", [2] = "ContextuallySecret" }
KT:RegisterChatCommand("ktdebuffs", function(message)
    local command = (message or ""):lower():match("^%s*(%S*)")
    if command == "test" then
        Mod:RunDebuffTrackerTest()
    elseif command == "stop" then
        Mod:StopDebuffTrackerTest()
    elseif command == "diag" then
        local restricted = C_Secrets and C_Secrets.HasSecretRestrictions and C_Secrets.HasSecretRestrictions()
        local aurasSecret = C_Secrets and C_Secrets.ShouldAurasBeSecret and C_Secrets.ShouldAurasBeSecret()
        KT:Print(string.format(L("Debuff Tracker: restrictions %s, auras secret now %s"),
            tostring(restricted), tostring(aurasSecret)))
        for _, entry in ipairs(Mod:GetDebuffTrackerEntries()) do
            local level = "?"
            if entry.spellID and C_Secrets and C_Secrets.GetSpellAuraSecrecy then
                local ok, value = pcall(C_Secrets.GetSpellAuraSecrecy, entry.spellID)
                if ok then level = SECRECY[value] or tostring(value) end
            end
            KT:Print(string.format(L("Debuff Tracker: %s (%s) secrecy %s, secret now %s"),
                entry.name, tostring(entry.spellID or "-"), level, tostring(AuraSecretNow(entry))))
        end
    else
        KT:Print(L("Debuff Tracker commands: /ktdebuffs test | stop | diag"))
    end
end)
