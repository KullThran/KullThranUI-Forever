-- Aura Reminders options: the Custom Auras page, the registration of all pages, the two slash commands.
-- Keeps every behaviour the specification flags as a suspected bug. No client difference: ctx.client selects nothing.

local _, ns = ...
local KT = ns.KT or (LibStub and LibStub("AceAddon-3.0"):GetAddon("KullThranUI", true))
if not KT then return end

local M = {}
ns.AuraRemindersPageCustom = M

-- Set by Setup.
local S, P, Reminders, Talents, Cards

-- The selected aura ID: one value per session, never saved.
local selectedID

-- Fields each template record shares, then each template's own. Exact and not localised.
local SHARED_FIELDS = {
    enabled = true, opacity = 1.0, showGlow = false, size = 40, point = "CENTER", relativePoint = "CENTER",
    xOffset = 0, yOffset = 0, loadInstance = "ANY",
}
local TEMPLATE_FIELDS = {
    blank = {
        name = "New Aura", triggerType = "AURA", triggerSpellID = 17, triggerAuraType = "HELPFUL",
        triggerUnit = "player", triggerAuraMissing = false, loadCombat = "ANY",
    },
    defensive = {
        name = "Defensive CD", triggerType = "COOLDOWN", triggerSpellID = 108271, loadCombat = "IN_COMBAT",
    },
    offensive = {
        name = "Offensive Buff", triggerType = "AURA", triggerSpellID = 31884, triggerAuraType = "HELPFUL",
        triggerUnit = "player", triggerAuraMissing = false, loadCombat = "IN_COMBAT",
    },
    debuff = {
        name = "Important Debuff", triggerType = "AURA", triggerSpellID = 0, triggerAuraType = "HARMFUL",
        triggerUnit = "player", triggerAuraMissing = false, loadCombat = "ANY", size = 55, showGlow = true,
    },
}

local function LocalText(text)
    local options = KT.Options
    return options and options.LText and options.LText(text) or text
end

local function newRecord(template)
    local record = {}
    for k, v in pairs(SHARED_FIELDS) do record[k] = v end
    for k, v in pairs(TEMPLATE_FIELDS[template]) do record[k] = v end
    -- Saved in the player's language: the name is shown as written from then on.
    if record.name then record.name = LocalText(record.name) end
    return record
end

-- aura_ followed by the time as text with its point removed. Equal texts replace each other.
local function newAuraID()
    local digits = tostring(GetTime()):gsub("%.", "")
    return "aura_" .. digits
end

-- Page rebuild, then the runtime's update. Each part only when present.
local function Refresh()
    if KT.RefreshPage then KT:RefreshPage(true) end
    local custom = _G.KUIAuraReminders_Custom
    if custom and custom.ForceUpdate then custom:ForceUpdate() end
end

local function templateFontPath()
    return KT.ResolveFontPath and KT:ResolveFontPath() or "Fonts\\FRIZQT__.TTF"
end

-- Accent header over a column.
local function columnHeader(column, localised, y)
    return KT.Widgets:Label(column, S.AccentColorCode() .. localised .. "|r", -y, 14)
end

-----------------------------------------------------------------------------------------------------------------------
-- Left column
-----------------------------------------------------------------------------------------------------------------------

local function buildTemplateButton(column, left, text, description, iconID, template, profile)
    local b = CreateFrame("Button", nil, column)
    b:SetSize(190, 44)
    b:SetPoint("TOPLEFT", 5, -left)
    KT:AddBackdrop(b, 0.08, 0.10, 0.13, 0.9)
    KT:AddBorder(b, 0.2, 0.2, 0.2, 1)

    local icon = b:CreateTexture(nil, "ARTWORK")
    icon:SetSize(28, 28)
    icon:SetPoint("LEFT", b, "LEFT", 8, 0)
    icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    icon:SetTexture(P.Tex(iconID))

    -- Both font strings have a font from their template at creation.
    local label = b:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    label:SetPoint("TOPLEFT", icon, "TOPRIGHT", 8, -2)
    label:SetText(text)
    label:SetFont(templateFontPath(), 12)
    if KT.GetStyleAccentRGB then
        local r, g, bl = KT:GetStyleAccentRGB()
        label:SetTextColor(r, g, bl)
    else
        label:SetTextColor(1, 1, 1)
    end

    local desc = b:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    desc:SetPoint("BOTTOMLEFT", icon, "BOTTOMRIGHT", 8, 2)
    desc:SetText(description)
    desc:SetFont(templateFontPath(), 10)
    desc:SetTextColor(0.5, 0.5, 0.5)

    b:SetScript("OnEnter", function(self) KT:AddBorder(self, 0.5, 0.5, 0.5, 1) end)
    b:SetScript("OnLeave", function(self) KT:AddBorder(self, 0.2, 0.2, 0.2, 1) end)
    b:SetScript("OnClick", function()
        local id = newAuraID()
        profile.customAuras[id] = newRecord(template)
        selectedID = id
        Refresh()
    end)
end

local function buildListRow(column, left, id, conf)
    local selected = id == selectedID
    local name = conf.name or LocalText("Unnamed")
    local b = CreateFrame("Button", nil, column)
    b:SetSize(190, 24)
    b:SetPoint("TOPLEFT", 5, -left)

    local bg = b:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetColorTexture(1, 1, 1, selected and 0.1 or 0.05)

    local text = b:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    text:SetPoint("LEFT", 5, 0)
    text:SetText(selected and ("> " .. name) or name)
    if conf.enabled then
        text:SetTextColor(1, 1, 1)
    else
        text:SetTextColor(0.5, 0.5, 0.5)
    end

    b:SetScript("OnClick", function()
        selectedID = id
        Refresh()
    end)
end

-- Returns the column's used height.
local function buildLeftColumn(column, L, profile)
    local left = 0
    local _, h = columnHeader(column, L("CREATE TEMPLATE"), left)
    left = left + h + 5

    buildTemplateButton(column, left, L("Blank Canvas"), L("Start from scratch"), 134400, "blank", profile)
    left = left + 49
    buildTemplateButton(column, left, L("Defensive CD"), L("Tracks a cooldown"), 108271, "defensive", profile)
    left = left + 49
    buildTemplateButton(column, left, L("Offensive Buff"), L("Tracks your buff"), 31884, "offensive", profile)
    left = left + 49
    buildTemplateButton(column, left, L("Big Debuff"), L("Important warning"), 136116, "debuff", profile)
    left = left + 49
    left = left + 15

    _, h = columnHeader(column, L("YOUR AURAS"), left)
    left = left + h + 5

    local rows = {}
    for id, conf in pairs(profile.customAuras) do
        rows[#rows + 1] = { id = id, conf = conf, name = conf.name or LocalText("Unnamed") }
    end
    table.sort(rows, function(a, b) return a.name < b.name end)
    for _, row in ipairs(rows) do
        buildListRow(column, left, row.id, row.conf)
        left = left + 26
    end
    return left
end

-----------------------------------------------------------------------------------------------------------------------
-- Right column
-----------------------------------------------------------------------------------------------------------------------

local function buildPreview(column, conf)
    local frame = CreateFrame("Frame", nil, column)
    frame:SetSize(56, 56)
    frame:SetPoint("TOP", column, "TOP", 0, -5)
    KT:AddBackdrop(frame, 0.05, 0.07, 0.09, 1)
    KT:AddBorder(frame, 0.4, 0.4, 0.4, 1)
    local tex = frame:CreateTexture(nil, "ARTWORK")
    tex:SetPoint("TOPLEFT", 1, -1)
    tex:SetPoint("BOTTOMRIGHT", -1, 1)
    tex:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    tex:SetTexture(P.Tex(conf.triggerSpellID))
end

-- Builds the editor for one record and returns the column's used height.
local function buildEditor(column, L, profile, id, conf)
    local W = KT.Widgets
    buildPreview(column, conf)
    local right = 70

    local function get(key, fallback)
        if fallback == nil then
            return function() return conf[key] end
        end
        return function() return conf[key] or fallback end
    end
    local function set(key)
        return function(value)
            conf[key] = value
            Refresh()
        end
    end
    local function numberGet(key, empty)
        return function()
            if conf[key] == nil then return empty end
            return tostring(conf[key])
        end
    end
    local function numberSet(key)
        return function(text)
            conf[key] = tonumber(text) or 0
            Refresh()
        end
    end
    -- Each helper places one widget at the running height and grows it by the widget's height and the gap.
    local function grow(gap, _, h)
        right = right + h + gap
    end
    local function label(text, gap)
        grow(gap, columnHeader(column, text, right))
    end
    local function dropdown(text, key, fallback, values, order, gap)
        grow(gap, W:Dropdown(column, text, -right, values, get(key, fallback), set(key), order))
    end
    local function numberInput(text, key, empty, gap)
        grow(gap, W:Input(column, text, -right, numberGet(key, empty), numberSet(key)))
    end
    local function toggle(text, key, gap)
        grow(gap, W:Toggle(column, text, -right, get(key), set(key)))
    end

    grow(10, W:DualRow(column, -right,
        { type = "toggle", text = L("Enabled"), getValue = get("enabled"), setValue = set("enabled") },
        { type = "button", text = L("Delete Aura"), onClick = function()
            profile.customAuras[id] = nil
            selectedID = nil
            Refresh()
        end }))
    grow(15, W:Input(column, L("Aura Name (Internal)"), -right, get("name"), set("name")))

    label(L("TRIGGER"), 5)
    dropdown(L("Trigger Type"), "triggerType", "AURA",
        { AURA = "Aura (Buff/Debuff)", COOLDOWN = "Spell Cooldown" }, { "AURA", "COOLDOWN" }, 5)
    numberInput(L("Spell ID"), "triggerSpellID", "", 5)
    if conf.triggerType == "AURA" then
        grow(5, W:DualRow(column, -right, {
            type = "dropdown", text = L("Unit"),
            values = { player = L("Player"), target = L("Target"), focus = L("Focus"), pet = L("Pet") },
            order = { "player", "target", "focus", "pet" },
            getValue = get("triggerUnit", "player"), setValue = set("triggerUnit"),
        }, {
            type = "dropdown", text = L("Aura Type"),
            values = { HELPFUL = L("Buff"), HARMFUL = L("Debuff") },
            order = { "HELPFUL", "HARMFUL" },
            getValue = get("triggerAuraType", "HELPFUL"), setValue = set("triggerAuraType"),
        }))
        toggle(L("Trigger when Missing"), "triggerAuraMissing", 15)
    elseif conf.triggerType == "COOLDOWN" then
        toggle(L("Trigger when Ready (Not on Cooldown)"), "triggerCooldownReady", 15)
    end

    label(L("LOAD CONDITIONS"), 5)
    dropdown(L("Combat Status"), "loadCombat", "ANY",
        { ANY = "Any", IN_COMBAT = "In Combat", OUT_COMBAT = "Out of Combat" }, { "ANY", "IN_COMBAT", "OUT_COMBAT" }, 5)
    dropdown(L("Instance Type"), "loadInstance", "ANY", {
        ANY = "Any", NONE = "None (World)", PARTY = "Party/Dungeon", RAID = "Raid", ARENA = "Arena", PVP = "Battleground",
    }, { "ANY", "NONE", "PARTY", "RAID", "ARENA", "PVP" }, 5)
    numberInput(L("Talent Spell ID (0 to ignore)"), "loadTalent", "0", 5)
    numberInput(L("Zone Map ID (0 to ignore)"), "loadZoneID", "0", 15)

    label(L("CUSTOM TEXT"), 5)
    dropdown(L("Text Mode"), "customTextType", "NONE",
        { NONE = "None", STATIC = "Static Text", STACKS = "Aura Stacks", DURATION = "Remaining Duration" },
        { "NONE", "STATIC", "STACKS", "DURATION" }, 5)
    if conf.customTextType == "STATIC" then
        grow(5, W:Input(column, L("Static Text Value"), -right, get("customTextValue", ""), set("customTextValue")))
    end
    right = right + 10

    label(L("DISPLAY & STYLE"), 5)
    dropdown(L("Display Style"), "displayStyle", "ICON",
        { ICON = L("Icon (Default)"), TEXT = L("Text Only") }, { "ICON", "TEXT" }, 5)
    grow(5, W:Slider(column, L("Size"), -right, get("size", 40), set("size"), 10, 100, 1, "%d"))
    grow(5, W:Slider(column, L("Opacity"), -right, get("opacity", 1.0), set("opacity"), 0, 1, 0.05, "%.2f"))
    toggle(L("Show Glow Action"), "showGlow", 5)
    grow(5, W:Toggle(column, L("Show Name Label Below"), -right,
        function() return conf.showNameLabel == true end, set("showNameLabel")))
    return right
end

-- Returns the column's used height.
local function buildRightColumn(column, L, profile)
    local conf = selectedID and profile.customAuras[selectedID]
    if conf then
        return buildEditor(column, L, profile, selectedID, conf)
    end
    local _, h = KT.Widgets:Label(column, L("Select or create a Custom Aura to edit its properties."), 0, 12,
        { r = 0.6, g = 0.6, b = 0.6 })
    -- Kept as a suspected bug: the empty state leaks this global.
    _G.rowH = h
    return h + 5
end

-----------------------------------------------------------------------------------------------------------------------
-- Page
-----------------------------------------------------------------------------------------------------------------------

local function BuildPage(_, parent, yOffset)
    local W = KT.Widgets
    local options = KT.Options
    local function L(text)
        if options then return options.LText(text) end
        return text
    end

    -- With no database this raises, as a kept suspected bug.
    local profile = _G._KUIAR_AceDB.profile
    if type(profile.customAuras) ~= "table" then profile.customAuras = {} end

    local y = yOffset
    local _, labelH = W:Label(parent, L("Create standalone custom auras with specific load conditions. They can be freely positioned anywhere on the screen."), -y, 12)
    y = y + labelH + 10

    local custom = _G.KUIAuraReminders_Custom
    local unlockText
    if custom and custom.UnlockMode then
        unlockText = L("Lock Custom Auras")
    else
        unlockText = L("Unlock Custom Auras")
    end
    local _, buttonH = W:Button(parent, unlockText, -y, function()
        local runtime = _G.KUIAuraReminders_Custom
        if not runtime then return end
        runtime:SetUnlockMode(not runtime.UnlockMode)
        Refresh()
    end, 200, nil, nil, "LEFT")
    y = y + buttonH + 10

    local leftColumn = CreateFrame("Frame", nil, parent)
    leftColumn:SetSize(200, 500)
    leftColumn:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, -y)
    local leftH = buildLeftColumn(leftColumn, L, profile)

    local rightColumn = CreateFrame("Frame", nil, parent)
    rightColumn:SetSize(parent:GetWidth() - 220, 500)
    rightColumn:SetPoint("TOPLEFT", parent, "TOPLEFT", 210, -y)
    local rightH = buildRightColumn(rightColumn, L, profile)

    return labelH + 10 + buttonH + 10 + math.max(leftH, rightH)
end

-----------------------------------------------------------------------------------------------------------------------
-- Registration
-----------------------------------------------------------------------------------------------------------------------

local function onSlash()
    local inCombat = _G.InCombatLockdown
    if inCombat and inCombat() then return end
    KT:ShowModule("KUIAuraReminders")
end

local function Register()
    if not KT.RegisterModule then return end
    local Pages = S.Pages

    KT:RegisterModule("KUIAuraReminders", {
        title = S.LText("Aura Readiness"),
        description = S.LText("Prepare group buffs, class upkeep and consumables from one KUI workspace."),
        pages = { Pages.CONTROL, Pages.GROUP, Pages.CLASS, Pages.CONSUMABLES, Pages.TALENTS, Pages.CUSTOM_AURAS },
        buildNavigation = Cards and Cards.BuildNavigation,
        hasPreview = function(name)
            return name == Pages.CONTROL or name == Pages.GROUP or name == Pages.CLASS or name == Pages.CONSUMABLES
        end,
        buildPage = function(name, parent, y)
            if name == Pages.CONTROL or name == Pages.GROUP or name == Pages.CLASS or name == Pages.CONSUMABLES then
                return Reminders.BuildPage(name, parent, y)
            elseif name == Pages.TALENTS then
                return Talents.BuildPage(name, parent, y)
            elseif name == Pages.CUSTOM_AURAS then
                return BuildPage(name, parent, y)
            end
            return nil
        end,
        getHeaderBuilder = function(name)
            if name == Pages.CONTROL then return P.HeaderBuilder end
            return nil
        end,
        onPageCacheRestore = function(name)
            if name == Pages.CONTROL then P.RestoreControlPreview() end
        end,
        onShow = function()
            local hide = _G._KUIAR_HideAllIcons
            if hide then hide() end
        end,
        onHide = function()
            local refresh = _G._KUIAR_RequestRefresh
            if refresh then refresh() end
        end,
        onReset = function()
            local db = _G._KUIAR_AceDB
            if db then db:ResetProfile() end
            local refresh = _G._KUIAR_RequestRefresh
            if refresh then refresh() end
        end,
    })

    -- Half a second lets the runtime create its movers first.
    C_Timer.After(0.5, function()
        local registerUnlock = _G._KUIAR_RegisterUnlock
        if registerUnlock then registerUnlock() end
    end)

    _G.SLASH_KUIAR1 = "/kuiar"
    _G.SLASH_KUIAR2 = "/kuir"
    SlashCmdList.KUIAR = onSlash
end

function M.Setup(ctx)
    if not ctx or (ctx.client ~= "retail" and ctx.client ~= "forever") then
        error("AuraRemindersPageCustom.Setup: ctx.client must be \"retail\" or \"forever\"", 2)
    end
    S, P, Reminders, Talents, Cards = ctx.Widgets, ctx.Preview, ctx.Reminders, ctx.Talents, ctx.Cards
    M.BuildPage = BuildPage
    M.Register = Register
end
