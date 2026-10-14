-- ============================================================================
-- TeleportMenu.lua
-- Modules/TeleportMenu/TeleportMenu.lua (moved from Modules/TeleportMenu.lua)
-- KullThranUI Module — Portal & Teleport Menu (Porter-style, integrated)
-- ============================================================================

local KT  = LibStub("AceAddon-3.0"):GetAddon("KullThranUI")
-- KUI localization helper (resolved at call time; falls back to the raw text)
local function LText(text)
    if type(text) ~= "string" then return text end
    local L = KT and KT.GetLocale and KT:GetLocale()
    if L and L[text] ~= nil then return L[text] end
    return text
end

-- Display name for a menu entry: the client-localized name from the game API,
-- falling back to the English name stored in the entry data. Plain items keep
-- the data name here: an uncached item lookup would send a server query.
local function GetEntryDisplayName(item)
    if type(item) ~= "table" then return "" end
    local id, name = item.id, nil
    if id then
        -- Items borrow the localized name of the spell they cast (nameSpell), so
        -- no item lookup is ever sent to the server.
        local spellID = (item.type == "spell") and id or item.nameSpell
        if spellID and C_Spell and C_Spell.GetSpellName then
            local ok, value = pcall(C_Spell.GetSpellName, spellID)
            if ok then name = value end
        end
    end
    if type(name) ~= "string" or name == "" then name = item.name or "" end
    return name
end

local RACE_IDS = { Worgen = 22, DarkIronDwarf = 34, Vulpera = 35 }

local function GetClassDisplayName(classToken)
    local names = _G.LOCALIZED_CLASS_NAMES_MALE
    return (names and names[classToken]) or tostring(classToken or "")
end

local function GetRaceDisplayName(raceToken)
    local raceID = RACE_IDS[raceToken]
    if raceID and C_CreatureInfo and C_CreatureInfo.GetRaceInfo then
        local ok, info = pcall(C_CreatureInfo.GetRaceInfo, raceID)
        if ok and type(info) == "table" and type(info.raceName) == "string" and info.raceName ~= "" then
            return info.raceName
        end
    end
    return tostring(raceToken or "")
end
local Mod = KT:NewModule("TeleportMenu", "AceEvent-3.0", "AceTimer-3.0", "AceConsole-3.0")
local LDB     = LibStub("LibDataBroker-1.1", true)
local LDBIcon = LibStub("LibDBIcon-1.0", true)
local LSM     = LibStub("LibSharedMedia-3.0", true)

local ICON_PATH = "Interface\\AddOns\\KullThranUI\\Libraries\\texture\\media\\icons\\"

-- ── Globals cache ─────────────────────────────────────────────────────────────
local _G               = _G
local pairs, ipairs, type, tinsert, math_ceil, math_abs = pairs, ipairs, type, table.insert, math.ceil, math.abs
local CreateFrame      = CreateFrame
local InCombatLockdown = InCombatLockdown
local C_Item           = C_Item
local C_Spell          = C_Spell
local C_Timer          = C_Timer
local IsPlayerSpell    = IsPlayerSpell
local UnitClass = UnitClass
local UnitRace  = UnitRace
local GameTooltip = GameTooltip
local UIParent    = UIParent

local function IsSecretValue(value)
    if KT and type(KT.IsSecret) == "function" then
        local ok, result = pcall(KT.IsSecret, value)
        return ok and result == true
    end
    if type(_G.issecretvalue) == "function" then
        local ok, result = pcall(_G.issecretvalue, value)
        return ok and result == true
    end
    return false
end

-- Forever / Camelot catalog. Only teleports that exist in this client are listed
-- (hearthstone, mage teleports and portals, druid, shaman, engineering items).
-- Buttons cast the spell or use the item through a secure macro, like an action
-- bar. Nothing here queries toys, housing, equippable items or items that are not
-- in the client: those requests are not supported by the server and disconnect
-- the player, which is why the original Retail copy had to be replaced.


-- ── Layout constants ──────────────────────────────────────────────────────────
local DEFAULT_SIZE    = 36
local DEFAULT_SPACING = 4
local DEFAULT_COLS    = 10
local SIDEBAR_WIDTH   = 156
local SIDEBAR_TAB_HEIGHT = 38
local SIDEBAR_TAB_GAP = 6
local SIDEBAR_ICON_SIZE = 20
local SIDEBAR_TEXT_SIZE = 11

local KT_FONT = "Interface\\AddOns\\KullThranUI\\Libraries\\font\\AAA_ITC_Avant_Garde.ttf"

-- ── Colour helpers ────────────────────────────────────────────────────────────
local function RGB(r, g, b)   return r / 255, g / 255, b / 255 end
local GOLD_R, GOLD_G, GOLD_B = RGB(255, 200, 50)
local THEME_COLOR_EPSILON = 0.02

local KNOWN_THEME_BORDER_COLORS = {
    { r = 1.00, g = 0.18, b = 0.39, a = 1.00 },
    { r = 0.37, g = 0.84, b = 1.00, a = 1.00 },
    { r = 0.28, g = 0.95, b = 0.62, a = 1.00 },
    { r = 0.66, g = 0.60, b = 1.00, a = 1.00 },
    { r = 1.00, g = 0.74, b = 0.28, a = 1.00 },
    { r = 0.24, g = 0.94, b = 0.90, a = 1.00 },
    { r = 1.00, g = 0.28, b = 0.34, a = 1.00 },
    { r = 1.00, g = 0.86, b = 0.34, a = 1.00 },
    { r = 0.90, g = 0.46, b = 1.00, a = 1.00 },
    { r = 0.70, g = 0.80, b = 0.92, a = 1.00 },
    { r = 0.74, g = 0.96, b = 0.28, a = 1.00 },
}

local function ColorsMatch(a, b)
    if type(a) ~= "table" or type(b) ~= "table" then
        return false
    end

    return math_abs((a.r or 0) - (b.r or 0)) <= THEME_COLOR_EPSILON and
        math_abs((a.g or 0) - (b.g or 0)) <= THEME_COLOR_EPSILON and
        math_abs((a.b or 0) - (b.b or 0)) <= THEME_COLOR_EPSILON and
        math_abs((a.a or 1) - (b.a or 1)) <= THEME_COLOR_EPSILON
end

local function IsKnownThemeBorderColor(color)
    if type(color) ~= "table" then
        return false
    end

    for _, known in ipairs(KNOWN_THEME_BORDER_COLORS) do
        if ColorsMatch(color, known) then
            return true
        end
    end

    return false
end

local function GetThemeBorderColor()
    local palette = KT and KT.GetStylePalette and KT:GetStylePalette() or KT and KT.STYLE_PALETTE or nil
    local border = palette and (palette.border or palette.accent) or nil
    if border then
        return border.r, border.g, border.b, border.a or 1
    end

    return KT.C_R, KT.C_G, KT.C_B, 1
end

local function GetThemeAccentColor()
    local palette = KT and KT.GetStylePalette and KT:GetStylePalette() or KT and KT.STYLE_PALETTE or nil
    local accent = palette and palette.accent or nil
    if accent then
        return accent.r, accent.g, accent.b, accent.a or 1
    end

    return KT.C_R, KT.C_G, KT.C_B, 1
end

local function GetThemeHeaderColor()
    local palette = KT and KT.GetStylePalette and KT:GetStylePalette() or KT and KT.STYLE_PALETTE or nil
    local header = KT and KT.db and KT.db.profile and KT.db.profile.skin and KT.db.profile.skin.headerColor or nil
    local tint = palette and palette.backgroundTint or nil
    local background = palette and palette.background or nil

    if header then
        return header.r, header.g, header.b, header.a or 1
    end
    if tint then
        return tint.r, tint.g, tint.b, math.max(tint.a or 0.16, 0.32)
    end
    if background then
        local ar, ag, ab = GetThemeAccentColor()
        return background.r * 0.72 + ar * 0.28, background.g * 0.72 + ag * 0.28, background.b * 0.72 + ab * 0.28, 0.95
    end

    local ar, ag, ab = GetThemeAccentColor()
    return ar * 0.32, ag * 0.32, ab * 0.32, 0.95
end

local function GetTeleportBorderColor(db)
    if db and (db.useThemeBorderColor ~= false or db.borderColorOverride ~= true or IsKnownThemeBorderColor(db.borderColor)) then
        return GetThemeAccentColor()
    end

    local border = db and db.borderColor
    if border then
        return border.r or KT.C_R, border.g or KT.C_G, border.b or KT.C_B, border.a or 1
    end

    return GetThemeBorderColor()
end

local function EnsureOuterBorder(frame)
    if not frame or frame._ktOuterBorder then
        return frame and frame._ktOuterBorder or nil
    end

    local border = {}
    border.top = frame:CreateTexture(nil, "OVERLAY")
    border.bottom = frame:CreateTexture(nil, "OVERLAY")
    border.left = frame:CreateTexture(nil, "OVERLAY")
    border.right = frame:CreateTexture(nil, "OVERLAY")

    border.top:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
    border.top:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0)
    border.top:SetHeight(1)

    border.bottom:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 0, 0)
    border.bottom:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
    border.bottom:SetHeight(1)

    border.left:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
    border.left:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 0, 0)
    border.left:SetWidth(1)

    border.right:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0)
    border.right:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
    border.right:SetWidth(1)

    frame._ktOuterBorder = border
    return border
end

local function SetOuterBorderColor(frame, r, g, b, a)
    local border = EnsureOuterBorder(frame)
    if not border then return end

    border.top:SetColorTexture(r, g, b, a or 1)
    border.bottom:SetColorTexture(r, g, b, a or 1)
    border.left:SetColorTexture(r, g, b, a or 1)
    border.right:SetColorTexture(r, g, b, a or 1)
end

local CATEGORY_ICONS = {
    ["Hearthstones"]   = "Interface\\Icons\\INV_Misc_Rune_09",
    ["Class & Racial"] = "Interface\\Icons\\Spell_Arcane_TeleportOrgrimmar",
    ["Items"]          = "Interface\\Icons\\INV_Misc_Bag_07",
}

local function ApplySidebarTabState(tab, state)
    if not tab then return end
    local r, g, b = GetThemeAccentColor()

    if state == "active" then
        tab:SetBackdropColor(r * 0.18, g * 0.18, b * 0.18, 0.98)
        tab:SetBackdropBorderColor(r, g, b, 1)
        tab.text:SetTextColor(1, 1, 1, 1)
        tab.icon:SetVertexColor(1, 1, 1, 1)
        tab.iconBG:SetColorTexture(r * 0.25, g * 0.25, b * 0.25, 0.95)
        tab.activeBar:Show()
    elseif state == "hover" then
        tab:SetBackdropColor(0.16, 0.16, 0.16, 0.98)
        tab:SetBackdropBorderColor(r * 0.55, g * 0.55, b * 0.55, 1)
        tab.text:SetTextColor(0.95, 0.95, 0.95, 1)
        tab.icon:SetVertexColor(1, 1, 1, 1)
        tab.iconBG:SetColorTexture(0.18, 0.18, 0.18, 0.95)
        tab.activeBar:Hide()
    else
        tab:SetBackdropColor(0.10, 0.10, 0.10, 0.95)
        tab:SetBackdropBorderColor(0.22, 0.22, 0.22, 1)
        tab.text:SetTextColor(0.80, 0.80, 0.80, 1)
        tab.icon:SetVertexColor(0.92, 0.92, 0.92, 1)
        tab.iconBG:SetColorTexture(0.14, 0.14, 0.14, 0.95)
        tab.activeBar:Hide()
    end
end

-- ============================================================================
-- DATA
-- ============================================================================

Mod.Categories = {
    "Hearthstones",
    "Class & Racial",
    "Items",
}

-- Entry fields: type ("spell" | "item"), id, name (English fallback), classReq,
-- raceReq, factionReq ("Alliance" | "Horde"), group (sub-header), reagent (item ID
-- whose bag count is shown on the button), nameSpell (spell whose localized name an
-- item entry borrows).
Mod.TeleportData = {
    ["Hearthstones"] = {
        { type = "item", id = 6948, name = "Hearthstone", nameSpell = 8690 },
    },

    ["Class & Racial"] = {
        -- Mage: Teleport (needs a Rune of Teleportation)
        { type = "spell", id = 3561,  name = "Teleport: Stormwind",    classReq = "MAGE", factionReq = "Alliance", group = "Teleports", reagent = 17031 },
        { type = "spell", id = 3562,  name = "Teleport: Ironforge",    classReq = "MAGE", factionReq = "Alliance", group = "Teleports", reagent = 17031 },
        { type = "spell", id = 3565,  name = "Teleport: Darnassus",    classReq = "MAGE", factionReq = "Alliance", group = "Teleports", reagent = 17031 },
        { type = "spell", id = 3567,  name = "Teleport: Orgrimmar",    classReq = "MAGE", factionReq = "Horde",    group = "Teleports", reagent = 17031 },
        { type = "spell", id = 3563,  name = "Teleport: Undercity",    classReq = "MAGE", factionReq = "Horde",    group = "Teleports", reagent = 17031 },
        { type = "spell", id = 3566,  name = "Teleport: Thunder Bluff", classReq = "MAGE", factionReq = "Horde",   group = "Teleports", reagent = 17031 },
        -- Mage: Portal (needs a Rune of Portals)
        { type = "spell", id = 10059, name = "Portal: Stormwind",      classReq = "MAGE", factionReq = "Alliance", group = "Portals", reagent = 17032 },
        { type = "spell", id = 11416, name = "Portal: Ironforge",      classReq = "MAGE", factionReq = "Alliance", group = "Portals", reagent = 17032 },
        { type = "spell", id = 11419, name = "Portal: Darnassus",      classReq = "MAGE", factionReq = "Alliance", group = "Portals", reagent = 17032 },
        { type = "spell", id = 11417, name = "Portal: Orgrimmar",      classReq = "MAGE", factionReq = "Horde",    group = "Portals", reagent = 17032 },
        { type = "spell", id = 11418, name = "Portal: Undercity",      classReq = "MAGE", factionReq = "Horde",    group = "Portals", reagent = 17032 },
        { type = "spell", id = 11420, name = "Portal: Thunder Bluff",  classReq = "MAGE", factionReq = "Horde",    group = "Portals", reagent = 17032 },
        -- Druid / Shaman
        { type = "spell", id = 18960, name = "Teleport: Moonglade",    classReq = "DRUID" },
        { type = "spell", id = 556,   name = "Astral Recall",          classReq = "SHAMAN" },
    },

    ["Items"] = {
        { type = "item", id = 18984, name = "Dimensional Ripper - Everlook" },
        { type = "item", id = 18986, name = "Ultrasafe Transporter: Gadgetzan" },
    },
}

-- ============================================================================
-- INITIALIZATION
-- ============================================================================

function Mod:OnInitialize()
    -- Defaults
    if not KT.db.profile.teleportMenu then
        KT.db.profile.teleportMenu = {
            enable        = true,
            minimap       = { hide = false },
            -- position object deprecated, replaced by anchor/x/y
            anchor        = "CENTER", xOffset = 0, yOffset = 0,
            showCosmetic  = true,
            hiddenItems   = {},
            buttonSize    = DEFAULT_SIZE,
            buttonSpacing = DEFAULT_SPACING,
            columns       = DEFAULT_COLS,
            fontSize      = 10,
            font          = "AAA_ITC_Avant_Garde",
            fontOutline   = "OUTLINE",
            showTooltip   = true,
            showLabels    = true,
            buttonStyle   = "BLIZZARD",
            bgColor       = { r = 0.07, g = 0.07, b = 0.07, a = 0.97 },
            useThemeBorderColor = true,
        }
    end
    
    -- Migration for old 'position' table if present
    if KT.db.profile.teleportMenu.position then
        KT.db.profile.teleportMenu.anchor  = KT.db.profile.teleportMenu.position.point or "CENTER"
        KT.db.profile.teleportMenu.xOffset = KT.db.profile.teleportMenu.position.x or 0
        KT.db.profile.teleportMenu.yOffset = KT.db.profile.teleportMenu.position.y or 0
        KT.db.profile.teleportMenu.position = nil
    end
    self.db = KT.db.profile.teleportMenu
    if self.db.borderColorOverride ~= true then
        self.db.useThemeBorderColor = true
    elseif self.db.useThemeBorderColor == nil then
        self.db.useThemeBorderColor = not self.db.borderColor or IsKnownThemeBorderColor(self.db.borderColor)
    end
    self.activeCategory = "Hearthstones"
    self.buttons        = {}
    self.secureButtons  = {}
    self.pendingCategory = nil
end

function Mod:OnEnable()
    if not self.db.enable then return end

    self:SetupMinimapButton()
    self:ApplyTeleportMinimapButtonStyle()
    C_Timer.After(0.2, function()
        if Mod and Mod.ApplyTeleportMinimapButtonStyle then
            Mod:ApplyTeleportMinimapButtonStyle()
        end
    end)

    self:RegisterEvent("SPELL_UPDATE_COOLDOWN",    "UpdateAllCooldowns")
    self:RegisterEvent("BAG_UPDATE_COOLDOWN",       "UpdateAllCooldowns")
    self:RegisterEvent("ZONE_CHANGED_NEW_AREA",     "OnZoneChanged")
    self:RegisterEvent("PLAYER_ENTERING_WORLD",     "OnEnteringWorld")
    self:RegisterEvent("PLAYER_REGEN_ENABLED",      "OnRegenEnabled")
    self:RegisterEvent("SPELLS_CHANGED",            "OnCollectionChanged")
    self:RegisterEvent("BAG_UPDATE_DELAYED",        "OnCollectionChanged")

    self:RegisterChatCommand("ktteleport", "Toggle")
    self:RegisterChatCommand("porter",     "Toggle")
end

-- Learning a spell or moving an item re-evaluates what is available. Debounced:
-- BAG_UPDATE_DELAYED can fire in bursts, and the rebuild is not free.
function Mod:OnCollectionChanged()
    local f = self.menuFrame
    if self._refreshQueued or not (f and f:IsShown()) then return end
    self._refreshQueued = true
    C_Timer.After(0.3, function()
        Mod._refreshQueued = nil
        if Mod.menuFrame and Mod.menuFrame:IsShown() then
            Mod:ShowCategory(Mod.activeCategory)
        end
    end)
end

function Mod:OnRegenEnabled()
    if self.pendingCategory then
        local category = self.pendingCategory
        self.pendingCategory = nil
        self:ShowCategory(category)
    end
end

-- ============================================================================
-- FRAME CONSTRUCTION
-- ============================================================================


function Mod:CreateMenuFrame()
    if self.menuFrame then return self.menuFrame end
    local accentR, accentG, accentB = GetThemeAccentColor()
    local headerR, headerG, headerB, headerA = GetThemeHeaderColor()

    -- ── Outer frame ───────────────────────────────────────────────────────────
    local f = CreateFrame("Frame", "KT_TeleportMenuFrame", UIParent, "BackdropTemplate")
    f:SetSize(660, 500)
    f:SetPoint("CENTER")
    f:SetFrameStrata("DIALOG")
    f:EnableMouse(true)
    f:SetMovable(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop",  f.StopMovingOrSizing)
    f:SetClampedToScreen(true)
    f:Hide()

    self:ApplyFrameStyle(f)

    -- ── Header bar ────────────────────────────────────────────────────────────
    local header = f:CreateTexture(nil, "BACKGROUND")
    header:SetPoint("TOPLEFT",  f, "TOPLEFT",  1, -1)
    header:SetPoint("TOPRIGHT", f, "TOPRIGHT", -1, -1)
    header:SetHeight(32)
    header:SetColorTexture(headerR, headerG, headerB, headerA)
    f.header = header

    local headerGlow = f:CreateTexture(nil, "BORDER")
    headerGlow:SetPoint("TOPLEFT", header, "TOPLEFT", 0, 0)
    headerGlow:SetPoint("BOTTOMRIGHT", header, "BOTTOMRIGHT", 0, 0)
    headerGlow:SetColorTexture(accentR, accentG, accentB, 0.08)
    f.headerGlow = headerGlow

    local title = f:CreateFontString(nil, "OVERLAY")
    title:SetFont(KT_FONT, 14, "OUTLINE")
    title:SetPoint("LEFT", 12, 0)
    title:SetPoint("TOP",  f, "TOP", 0, -9)
    title:SetText(LText("Portal & Teleport"))

    -- ── Separator under header ────────────────────────────────────────────────
    local sep = f:CreateTexture(nil, "BACKGROUND")
    sep:SetPoint("TOPLEFT",  f, "TOPLEFT",  1, -33)
    sep:SetPoint("TOPRIGHT", f, "TOPRIGHT", -1, -33)
    sep:SetHeight(1)
    sep:SetColorTexture(accentR, accentG, accentB, 0.8)
    f.headerSeparator = sep

    -- ── Close button ──────────────────────────────────────────────────────────
    local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", -2, -2)
    close:SetSize(28, 28)
    f.closeBtn = close

    -- ── Settings toggle (gear icon) ───────────────────────────────────────────
    local gear = CreateFrame("Button", nil, f, "BackdropTemplate")
    gear:SetSize(22, 22)
    gear:SetPoint("TOPRIGHT", close, "TOPLEFT", -4, 0)
    local gearTex = gear:CreateTexture(nil, "ARTWORK")
    gearTex:SetAllPoints()
    gearTex:SetTexture(ICON_PATH .. "Config.png")
    gear:SetScript("OnClick",   function()
        if KT.OpenMenu then KT:OpenMenu("teleportmenu") end
    end)
    gear:SetScript("OnEnter",   function(s)
        GameTooltip:SetOwner(s, "ANCHOR_LEFT")
        GameTooltip:AddLine(LText("Teleport Menu Settings"), 1, 1, 1)
        GameTooltip:Show()
    end)
    gear:SetScript("OnLeave",   function() GameTooltip:Hide() end)
    f.gearBtn = gear
    gearTex:SetTexture('Interface\\AddOns\\KullThranUI\\Libraries\\texture\\media\\icons\\ConfigOptionsIcons\\Engranaje.png')
    gearTex:ClearAllPoints()
    gearTex:SetPoint('CENTER', gear, 'CENTER', 0, 0)
    gearTex:SetSize(18, 18)
    gearTex:SetVertexColor(accentR, accentG, accentB, 1)
    f.gearIcon = gearTex

    -- ── Left sidebar: category list ───────────────────────────────────────────
    local sidebar = CreateFrame("Frame", nil, f, "BackdropTemplate")
    sidebar:SetPoint("TOPLEFT",    f, "TOPLEFT", 1, -34)
    sidebar:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 1, 1)
    sidebar:SetWidth(SIDEBAR_WIDTH)
    sidebar:SetBackdrop({
        bgFile   = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        edgeSize = 1,
    })
    sidebar:SetBackdropColor(0.05, 0.05, 0.05, 0.95)
    sidebar:SetBackdropBorderColor(accentR * 0.4, accentG * 0.4, accentB * 0.4, 1)

    f.tabs = {}
    local tabY = -10
    for _, cat in ipairs(Mod.Categories) do
        local tab = CreateFrame("Button", nil, sidebar, "BackdropTemplate")
        tab:SetHeight(SIDEBAR_TAB_HEIGHT)
        tab:SetPoint("LEFT",  sidebar, "LEFT",  8, 0)
        tab:SetPoint("RIGHT", sidebar, "RIGHT", -8, 0)
        tab:SetPoint("TOP",   sidebar, "TOP", 0, tabY)
        tab:SetBackdrop({
            bgFile   = "Interface\\Buttons\\WHITE8x8",
            edgeFile = "Interface\\Buttons\\WHITE8x8",
            edgeSize = 1,
        })
        tab.activeBar = tab:CreateTexture(nil, "BORDER")
        tab.activeBar:SetPoint("TOPLEFT", tab, "TOPLEFT", 0, -1)
        tab.activeBar:SetPoint("BOTTOMLEFT", tab, "BOTTOMLEFT", 0, 1)
        tab.activeBar:SetWidth(3)
        tab.activeBar:SetColorTexture(accentR, accentG, accentB, 1)
        tab.activeBar:Hide()

        tab.iconBG = tab:CreateTexture(nil, "BACKGROUND")
        tab.iconBG:SetSize(SIDEBAR_ICON_SIZE + 8, SIDEBAR_ICON_SIZE + 8)
        tab.iconBG:SetPoint("LEFT", 9, 0)

        local ico = tab:CreateTexture(nil, "ARTWORK")
        ico:SetSize(SIDEBAR_ICON_SIZE, SIDEBAR_ICON_SIZE)
        ico:SetPoint("LEFT", 13, 0)
        ico:SetTexture(CATEGORY_ICONS[cat] or "Interface\\Icons\\Inv_misc_note_01")
        ico:SetTexCoord(0.08, 0.92, 0.08, 0.92)
        tab.icon = ico

        local txt = tab:CreateFontString(nil, "OVERLAY")
        txt:SetFont(KT_FONT, SIDEBAR_TEXT_SIZE, "OUTLINE")
        txt:SetPoint("LEFT",  ico, "RIGHT", 8, 0)
        txt:SetPoint("RIGHT", tab, "RIGHT", -8, 0)
        txt:SetJustifyH("LEFT")
        txt:SetJustifyV("MIDDLE")
        txt:SetWordWrap(false)
        txt:SetText(LText(cat))
        tab.text = txt

        tab.category = cat
        tab:SetScript("OnClick", function()
            Mod.activeCategory = cat
            Mod:ShowCategory(cat)
        end)
        tab:SetScript("OnEnter", function(s)
            if s.category ~= Mod.activeCategory then
                ApplySidebarTabState(s, "hover")
            end
        end)
        tab:SetScript("OnLeave", function(s)
            if s.category ~= Mod.activeCategory then
                ApplySidebarTabState(s, "inactive")
            end
        end)
        ApplySidebarTabState(tab, "inactive")

        tinsert(f.tabs, tab)
        tabY = tabY - (SIDEBAR_TAB_HEIGHT + SIDEBAR_TAB_GAP)
    end
    f.sidebar = sidebar

    -- ── Sidebar separator ─────────────────────────────────────────────────────
    local vsep = f:CreateTexture(nil, "BACKGROUND")
    vsep:SetPoint("TOPLEFT",    sidebar, "TOPRIGHT",    0, 0)
    vsep:SetPoint("BOTTOMLEFT", sidebar, "BOTTOMRIGHT", 0, 0)
    vsep:SetWidth(1)
    vsep:SetColorTexture(accentR, accentG, accentB, 0.5)
    f.sidebarSeparator = vsep

    -- ── Content area ──────────────────────────────────────────────────────────
    local contentOuter = CreateFrame("Frame", nil, f)
    contentOuter:SetPoint("TOPLEFT",    sidebar, "TOPRIGHT", 8,  -6)
    contentOuter:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT",  -8,  8)
    f.contentOuter = contentOuter

    -- Item count label
    local countLabel = contentOuter:CreateFontString(nil, "OVERLAY")
    countLabel:SetFont(KT_FONT, 9, "OUTLINE")
    countLabel:SetPoint("BOTTOMRIGHT", contentOuter, "BOTTOMRIGHT", -2, 2)
    countLabel:SetTextColor(0.6, 0.6, 0.6, 1)
    f.countLabel = countLabel

    -- ScrollFrame
    local scroll = CreateFrame("ScrollFrame", "KT_TeleportScroll", contentOuter, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT",     contentOuter, "TOPLEFT",  0,   0)
    scroll:SetPoint("BOTTOMRIGHT", contentOuter, "BOTTOMRIGHT", -20, 14)

    local content = CreateFrame("Frame", nil, scroll)
    content:SetSize(1, 1)
    scroll:SetScrollChild(content)
    self:ApplyScrollBarStyle(scroll, contentOuter)
    f.content  = content
    f.scroll   = scroll

    self.menuFrame = f
    return f
end

-- ============================================================================
-- STYLING
-- ============================================================================
function Mod:ApplyFrameStyle(f)
    if not f then return end
    local bg = self.db.bgColor or { r=0.07, g=0.07, b=0.07, a=0.97 }
    local bcr, bcg, bcb, bca = GetTeleportBorderColor(self.db)
    f:SetBackdrop({
        bgFile   = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        edgeSize = 1,
        insets   = { left = 0, right = 0, top = 0, bottom = 0 },
    })
    f:SetBackdropColor(bg.r, bg.g, bg.b, bg.a)
    f:SetBackdropBorderColor(0, 0, 0, 0)
    SetOuterBorderColor(f, bcr, bcg, bcb, bca)
end

function Mod:SetScrollBarVisualState(scrollbar, state)
    if not scrollbar then return end
    local thumb = scrollbar.ThumbTexture or (scrollbar.GetThumbTexture and scrollbar:GetThumbTexture())
    if not thumb then return end

    local r, g, b = GetThemeAccentColor()
    local borderAlpha, glowAlpha = 0.75, 0.10

    if state == "hover" then
        r = math.min(r + 0.10, 1)
        g = math.min(g + 0.10, 1)
        b = math.min(b + 0.10, 1)
        borderAlpha, glowAlpha = 0.95, 0.18
    elseif state == "drag" then
        r = math.min(r + 0.18, 1)
        g = math.min(g + 0.18, 1)
        b = math.min(b + 0.18, 1)
        borderAlpha, glowAlpha = 1, 0.28
    end

    thumb:SetTexture("Interface\\Buttons\\WHITE8x8")
    thumb:SetVertexColor(r, g, b, 0.95)

    if scrollbar.thumbFrame then
        if KT.AddBackdrop then KT:AddBackdrop(scrollbar.thumbFrame, 0.02, 0.02, 0.03, 0.88) end
        if KT.AddBorder then KT:AddBorder(scrollbar.thumbFrame, r, g, b, borderAlpha) end
    end
    if scrollbar.thumbGlow then
        scrollbar.thumbGlow:SetColorTexture(r, g, b, glowAlpha)
    end
end

function Mod:ApplyScrollBarStyle(scroll, contentOuter)
    if not scroll then return end
    local accentR, accentG, accentB = GetThemeAccentColor()

    local scrollbar = scroll.ScrollBar or (scroll.GetName and _G[scroll:GetName() .. "ScrollBar"])
    if not scrollbar or scrollbar._ktStyled then return end
    scrollbar._ktStyled = true

    scrollbar:ClearAllPoints()
    scrollbar:SetPoint("TOPRIGHT", contentOuter, "TOPRIGHT", -2, -2)
    scrollbar:SetPoint("BOTTOMRIGHT", contentOuter, "BOTTOMRIGHT", -2, 18)
    scrollbar:SetWidth(14)

    for _, regionName in ipairs({
        "Track", "Top", "Bottom", "Middle", "BG", "Background", "Back",
        "TopImage", "BottomImage", "MiddleImage",
    }) do
        local region = scrollbar[regionName]
        if region then
            if region.Hide then region:Hide() end
            if region.SetAlpha then region:SetAlpha(0) end
        end
    end

    if scrollbar.ScrollUpButton then
        scrollbar.ScrollUpButton:Hide()
        scrollbar.ScrollUpButton:SetHeight(0.01)
    end
    if scrollbar.ScrollDownButton then
        scrollbar.ScrollDownButton:Hide()
        scrollbar.ScrollDownButton:SetHeight(0.01)
    end

    if scrollbar.SetThumbTexture then
        scrollbar:SetThumbTexture("Interface\\Buttons\\WHITE8x8")
    end

    local thumb = scrollbar.ThumbTexture or (scrollbar.GetThumbTexture and scrollbar:GetThumbTexture())
    if thumb then
        thumb:SetWidth(6)
        thumb:SetTexture("Interface\\Buttons\\WHITE8x8")
    end

    scrollbar.trackFrame = scrollbar.trackFrame or CreateFrame("Frame", nil, scrollbar, "BackdropTemplate")
    scrollbar.trackFrame:SetFrameLevel(scrollbar:GetFrameLevel() - 1)
    scrollbar.trackFrame:ClearAllPoints()
    scrollbar.trackFrame:SetPoint("TOPLEFT", scrollbar, "TOPLEFT", 2, -2)
    scrollbar.trackFrame:SetPoint("BOTTOMRIGHT", scrollbar, "BOTTOMRIGHT", -2, 2)
    if KT.AddBackdrop then KT:AddBackdrop(scrollbar.trackFrame, 0.01, 0.01, 0.02, 0.94) end
    if KT.AddBorder then KT:AddBorder(scrollbar.trackFrame, accentR * 0.45, accentG * 0.45, accentB * 0.45, 0.95) end

    scrollbar.trackLine = scrollbar.trackLine or scrollbar.trackFrame:CreateTexture(nil, "ARTWORK")
    scrollbar.trackLine:ClearAllPoints()
    scrollbar.trackLine:SetPoint("TOP", scrollbar.trackFrame, "TOP", 0, -3)
    scrollbar.trackLine:SetPoint("BOTTOM", scrollbar.trackFrame, "BOTTOM", 0, 3)
    scrollbar.trackLine:SetWidth(1)
    scrollbar.trackLine:SetColorTexture(accentR, accentG, accentB, 0.24)

    scrollbar.thumbFrame = scrollbar.thumbFrame or CreateFrame("Frame", nil, scrollbar, "BackdropTemplate")
    scrollbar.thumbFrame:SetFrameLevel(scrollbar:GetFrameLevel() + 6)
    scrollbar.thumbGlow = scrollbar.thumbGlow or scrollbar.thumbFrame:CreateTexture(nil, "BACKGROUND")
    scrollbar.thumbGlow:SetAllPoints()

    local function UpdateThumbFrame()
        local currentThumb = scrollbar.ThumbTexture or (scrollbar.GetThumbTexture and scrollbar:GetThumbTexture())
        if not currentThumb then return end
        scrollbar.thumbFrame:ClearAllPoints()
        scrollbar.thumbFrame:SetPoint("TOPLEFT", currentThumb, "TOPLEFT", -2, 2)
        scrollbar.thumbFrame:SetPoint("BOTTOMRIGHT", currentThumb, "BOTTOMRIGHT", 2, -2)
    end

    UpdateThumbFrame()
    self:SetScrollBarVisualState(scrollbar, "normal")

    if not scrollbar._ktHooksInstalled then
        scrollbar._ktHooksInstalled = true
        scrollbar:HookScript("OnValueChanged", UpdateThumbFrame)
        scrollbar:HookScript("OnSizeChanged", UpdateThumbFrame)
        scrollbar:HookScript("OnEnter", function(sb)
            if not sb._ktDragging then
                Mod:SetScrollBarVisualState(sb, "hover")
            end
        end)
        scrollbar:HookScript("OnLeave", function(sb)
            if not sb._ktDragging then
                Mod:SetScrollBarVisualState(sb, "normal")
            end
        end)
        scrollbar:HookScript("OnMouseDown", function(sb)
            sb._ktDragging = true
            Mod:SetScrollBarVisualState(sb, "drag")
        end)
        scrollbar:HookScript("OnMouseUp", function(sb)
            sb._ktDragging = nil
            if sb:IsMouseOver() then
                Mod:SetScrollBarVisualState(sb, "hover")
            else
                Mod:SetScrollBarVisualState(sb, "normal")
            end
        end)
    end
end

function Mod:RefreshThemeColors()
    local f = self.menuFrame
    if not f then return end

    local r, g, b = GetThemeAccentColor()
    local _, _, _, borderAlpha = GetTeleportBorderColor(self.db)

    -- Repaint the outer frame too, because the menu frame is reused between
    -- the standalone window and the embedded options preview.
    if f.SetBackdropColor then
        local bg = self.db.bgColor or { r = 0.07, g = 0.07, b = 0.07, a = 0.97 }
        f:SetBackdropColor(bg.r, bg.g, bg.b, bg.a)
        f:SetBackdropBorderColor(0, 0, 0, 0)
    end
    SetOuterBorderColor(f, r, g, b, borderAlpha or 1)

    if f.header then
        local hr, hg, hb, ha = GetThemeHeaderColor()
        f.header:SetColorTexture(hr, hg, hb, ha)
    end
    if f.headerGlow then
        f.headerGlow:SetColorTexture(r, g, b, 0.08)
    end
    if f.headerSeparator then
        f.headerSeparator:SetColorTexture(r, g, b, 0.8)
    end
    if f.gearIcon then
        f.gearIcon:SetVertexColor(r, g, b, 1)
    end
    if f.sidebar then
        f.sidebar:SetBackdropBorderColor(r * 0.4, g * 0.4, b * 0.4, 1)
    end
    if f.sidebarSeparator then
        f.sidebarSeparator:SetColorTexture(r, g, b, 0.5)
    end

    for _, tab in ipairs(f.tabs or {}) do
        if tab.activeBar then
            tab.activeBar:SetColorTexture(r, g, b, 1)
        end
        ApplySidebarTabState(tab, tab.category == self.activeCategory and "active" or "inactive")
    end

    local scrollbar = f.scroll and (f.scroll.ScrollBar or (f.scroll.GetName and _G[f.scroll:GetName() .. "ScrollBar"])) or nil
    if scrollbar then
        if scrollbar.trackFrame and KT.AddBorder then
            KT:AddBorder(scrollbar.trackFrame, r * 0.45, g * 0.45, b * 0.45, 0.95)
        end
        if scrollbar.trackLine then
            scrollbar.trackLine:SetColorTexture(r, g, b, 0.24)
        end

        local state = "normal"
        if scrollbar._ktDragging then
            state = "drag"
        elseif scrollbar.IsMouseOver and scrollbar:IsMouseOver() then
            state = "hover"
        end
        self:SetScrollBarVisualState(scrollbar, state)
    end
end

-- ============================================================================
-- CATEGORY DISPLAY
-- ============================================================================

function Mod:ShowCategory(category)
    category = category or self.activeCategory or "Hearthstones"
    if InCombatLockdown() then
        self.pendingCategory = category
        return
    end

    local frame = self:CreateMenuFrame()
    local content = frame.content

    frame.scroll:Show()
    frame.countLabel:Show()

    self.buttons = {}
    self.secureButtons = self.secureButtons or {}
    for _, btn in ipairs(self.secureButtons) do btn:Hide() end
    self.groupHeaders = self.groupHeaders or {}
    for _, header in ipairs(self.groupHeaders) do header:Hide() end

    for _, tab in ipairs(frame.tabs) do
        if tab.category == category then
            ApplySidebarTabState(tab, "active")
        else
            ApplySidebarTabState(tab, "inactive")
        end
    end

    local list = Mod.TeleportData[category]
    if not list then return end

    local playerClass = select(2, UnitClass("player"))
    local _, playerRace = UnitRace("player")
    local playerFaction = UnitFactionGroup and UnitFactionGroup("player")
    local validItems = {}

    for _, item in ipairs(list) do
        local show = true
        if item.classReq and item.classReq ~= playerClass then show = false end
        if item.raceReq and item.raceReq ~= playerRace then show = false end
        if item.factionReq and playerFaction and item.factionReq ~= playerFaction then show = false end
        if show then
            tinsert(validItems, item)
        end
    end

    local bSize = self.db.buttonSize or DEFAULT_SIZE
    local bSpace = self.db.buttonSpacing or DEFAULT_SPACING
    local bCols = self.db.columns or DEFAULT_COLS
    local showLabels = self.db.showLabels ~= false
    local labelHeight = showLabels and 24 or 0
    local cellW = math.max(bSize, 64)
    local cellH = bSize + labelHeight
    local availableW = 0
    if frame.contentOuter and frame.contentOuter.GetWidth then
        availableW = frame.contentOuter:GetWidth()
    end
    if not availableW or availableW <= 10 then
        availableW = (frame.GetWidth and frame:GetWidth() or 660) - 170
    end
    availableW = math.max(100, availableW - 8)
    local maxCols = math.max(1, math.floor((availableW + bSpace) / (cellW + bSpace)))
    bCols = math.min(bCols, maxCols)
    local totalWidth = bCols * (cellW + bSpace) - bSpace
    local availableCount = 0

    local function BagCount(itemID)
        local fn = (C_Item and C_Item.GetItemCount) or _G.GetItemCount
        local ok, n = pcall(fn, itemID)
        return (ok and tonumber(n)) or 0
    end

    -- Spells: learned. Items: in the bags. Both are local checks, no server query.
    local function IsTeleportAvailable(item)
        if item.type == "spell" then
            local ok, known = pcall(IsPlayerSpell, item.id)
            return ok and known == true
        end
        return BagCount(item.id) > 0
    end

    local function AcquireGroupHeader(index)
        local header = self.groupHeaders[index]
        if not header then
            local lineR, lineG, lineB = GetThemeAccentColor()
            header = CreateFrame("Frame", nil, content)
            header.text = header:CreateFontString(nil, "OVERLAY")
            header.text:SetFont(KT_FONT, 11, "OUTLINE")
            header.text:SetPoint("LEFT", header, "LEFT", 0, 0)
            header.text:SetJustifyH("LEFT")
            header.line = header:CreateTexture(nil, "ARTWORK")
            header.line:SetHeight(1)
            header.line:SetColorTexture(lineR, lineG, lineB, 0.5)
            self.groupHeaders[index] = header
        end
        return header
    end

    local function ShowTooltip(s)
        local data = s.data
        if Mod.db.showTooltip == false or not data then return end
        GameTooltip:SetOwner(s, "ANCHOR_RIGHT")
        if data.type == "spell" then
            GameTooltip:SetSpellByID(data.id)
        else
            -- Only a cached item can be shown without asking the server.
            local cached = C_Item and C_Item.IsItemDataCachedByID and C_Item.IsItemDataCachedByID(data.id)
            if cached then
                GameTooltip:SetItemByID(data.id)
            else
                GameTooltip:AddLine(GetEntryDisplayName(data), 1, 1, 1)
            end
        end
        if data.classReq then
            GameTooltip:AddLine(string.format(LText("Class: %s"), GetClassDisplayName(data.classReq)), 0.7, 0.7, 0.7)
        end
        if data.raceReq then
            GameTooltip:AddLine(string.format(LText("Race: %s"), GetRaceDisplayName(data.raceReq)), 0.7, 0.7, 0.7)
        end
        if data.reagent then
            GameTooltip:AddLine(string.format(LText("Reagent: %d"), BagCount(data.reagent)), 0.7, 0.7, 0.7)
        end
        GameTooltip:AddLine(" ")
        if s.isAvailable then
            GameTooltip:AddLine(LText(data.type == "spell" and "Click to cast" or "Click to use"), 0.3, 1, 0.3)
        else
            GameTooltip:AddLine(LText(data.type == "spell" and "Not learned yet" or "Not in your bags"), 0.6, 0.6, 0.6)
        end
        GameTooltip:Show()
    end

    local function ApplyButtonItem(index, item, x, y)
        local btn = self.secureButtons[index]
        if not btn then
            btn = CreateFrame("Button", "KT_TeleportSecureBtn" .. index, content, "SecureActionButtonTemplate,BackdropTemplate")
            btn:SetBackdrop({
                bgFile   = "Interface\\Buttons\\WHITE8x8",
                edgeFile = "Interface\\Buttons\\WHITE8x8",
                edgeSize = 1,
            })
            btn:SetBackdropColor(0.06, 0.06, 0.06, 0.9)
            btn:SetBackdropBorderColor(0.15, 0.15, 0.15, 1)

            btn.icon = btn:CreateTexture(nil, "ARTWORK")
            btn.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

            btn.dimmer = btn:CreateTexture(nil, "OVERLAY")
            btn.dimmer:SetColorTexture(0, 0, 0, 0.5)
            btn.dimmer:Hide()

            btn.cooldown = CreateFrame("Cooldown", nil, btn, "CooldownFrameTemplate")
            btn.cooldown:SetDrawEdge(true)

            btn.nameLabel = btn:CreateFontString(nil, "OVERLAY")
            btn.nameLabel:SetPoint("TOPLEFT", btn, "TOPLEFT", 0, -bSize - 2)
            btn.nameLabel:SetPoint("TOPRIGHT", btn, "TOPRIGHT", 0, -bSize - 2)
            btn.nameLabel:SetJustifyH("CENTER")
            btn.nameLabel:SetJustifyV("TOP")
            btn.nameLabel:SetWordWrap(true)
            btn.nameLabel:SetTextColor(0.85, 0.85, 0.85, 1)
            btn.nameLabel:SetSpacing(0)

            -- Reagent count (bottom-right of the icon).
            btn.count = btn:CreateFontString(nil, "OVERLAY")
            btn.count:SetFont(KT_FONT, 10, "OUTLINE")
            btn.count:Hide()

            btn:SetScript("OnEnter", function(s)
                ShowTooltip(s)
                local hoverR, hoverG, hoverB = GetThemeAccentColor()
                s:SetBackdropBorderColor(hoverR, hoverG, hoverB, 1)
            end)
            btn:SetScript("OnLeave", function(s)
                GameTooltip:Hide()
                s:SetBackdropBorderColor(0.15, 0.15, 0.15, 1)
            end)

            -- Both edges, so it respects the "cast on key down" setting.
            btn:RegisterForClicks("LeftButtonDown", "LeftButtonUp")
            self.secureButtons[index] = btn
        end

        btn:SetSize(cellW, cellH)
        btn:SetParent(content)
        btn:Show()
        btn:ClearAllPoints()
        btn:SetPoint("TOPLEFT", content, "TOPLEFT", x, y)
        btn.icon:ClearAllPoints()
        btn.icon:SetPoint("TOP", btn, "TOP", 0, 0)
        btn.icon:SetSize(bSize, bSize)
        btn.dimmer:ClearAllPoints()
        btn.dimmer:SetPoint("TOP", btn, "TOP", 0, 0)
        btn.dimmer:SetSize(bSize, bSize)
        btn.cooldown:ClearAllPoints()
        btn.cooldown:SetPoint("TOP", btn, "TOP", 0, 0)
        btn.cooldown:SetSize(bSize, bSize)
        btn.cooldown:Clear()
        btn.count:ClearAllPoints()
        btn.count:SetPoint("BOTTOMRIGHT", btn.icon, "BOTTOMRIGHT", -1, 2)

        btn.spellID, btn.itemID = nil, nil
        btn.data = item
        btn:SetAttribute("type", nil)
        btn:SetAttribute("macrotext", nil)

        local font = (self.db.font and LSM and LSM:Fetch("font", self.db.font)) or KT_FONT
        local outline = self.db.fontOutline
        if not outline or outline == "NONE" then
            outline = "OUTLINE"
        end
        btn.nameLabel:SetFont(font, self.db.fontSize or 10, outline)
        btn.nameLabel:SetText(GetEntryDisplayName(item))
        btn.nameLabel:SetWidth(cellW)
        btn.nameLabel:SetHeight(labelHeight > 0 and labelHeight or 1)
        if showLabels then btn.nameLabel:Show() else btn.nameLabel:Hide() end

        local macro
        if item.type == "spell" then
            local info = C_Spell and C_Spell.GetSpellInfo and C_Spell.GetSpellInfo(item.id)
            btn.icon:SetTexture(info and info.iconID or 134400)
            btn.spellID = item.id
            local spellName = info and info.name
            if type(spellName) == "string" and spellName ~= "" then
                macro = "/cast " .. spellName
            end
        else
            -- Static client data: the icon comes without a server query.
            local ok, _, _, _, _, instantIcon = pcall(C_Item.GetItemInfoInstant, item.id)
            btn.icon:SetTexture((ok and instantIcon) or 134400)
            btn.itemID = item.id
            macro = "/use item:" .. item.id
        end

        local available = IsTeleportAvailable(item)
        btn.isAvailable = available
        if available then
            availableCount = availableCount + 1
            btn.icon:SetVertexColor(1, 1, 1, 1)
            btn.nameLabel:SetTextColor(0.85, 0.85, 0.85, 1)
            if macro then
                btn:SetAttribute("type", "macro")
                btn:SetAttribute("macrotext", macro)
            end
        else
            btn.icon:SetVertexColor(0.40, 0.40, 0.40, 1)
            btn.nameLabel:SetTextColor(0.55, 0.55, 0.55, 1)
        end

        if item.reagent then
            local n = BagCount(item.reagent)
            btn.count:SetText(n)
            if n > 0 then btn.count:SetTextColor(1, 1, 1, 1) else btn.count:SetTextColor(1, 0.25, 0.25, 1) end
            btn.count:Show()
        else
            btn.count:Hide()
        end

        self.buttons[index] = btn
    end

    -- Group by sub-header, in order of first appearance. Entries without a group
    -- fall under "Other" only when some other entry has one.
    local groups, byLabel, anyLabel = {}, {}, false
    for _, item in ipairs(validItems) do
        local key = item.group or false
        local group = byLabel[key]
        if not group then
            group = { label = item.group, items = {} }
            byLabel[key] = group
            groups[#groups + 1] = group
        end
        if item.group then anyLabel = true end
        tinsert(group.items, item)
    end

    local buttonIndex, headerIndex, cursorY = 1, 1, 0
    for _, group in ipairs(groups) do
        local label = group.label or (anyLabel and "Other") or nil
        if label then
            local header = AcquireGroupHeader(headerIndex)
            header:SetParent(content)
            header:ClearAllPoints()
            header:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -cursorY)
            header:SetSize(totalWidth, 18)
            header.text:SetText(LText(label))
            header.text:SetTextColor(1, 0.82, 0.25, 1)
            header.line:ClearAllPoints()
            header.line:SetPoint("LEFT", header.text, "RIGHT", 8, 0)
            header.line:SetPoint("RIGHT", header, "RIGHT", 0, 0)
            header.line:SetPoint("CENTER", header, "CENTER", 0, 0)
            header:Show()
            headerIndex = headerIndex + 1
            cursorY = cursorY + 24
        end

        local col, row = 0, 0
        for _, item in ipairs(group.items) do
            ApplyButtonItem(buttonIndex, item, col * (cellW + bSpace), -cursorY - row * (cellH + bSpace))
            buttonIndex = buttonIndex + 1
            col = col + 1
            if col >= bCols then
                col = 0
                row = row + 1
            end
        end
        cursorY = cursorY + math_ceil(#group.items / bCols) * (cellH + bSpace) + 10
    end

    content:SetSize(totalWidth, math.max(1, cursorY))
    frame.countLabel:SetText(string.format(LText("%d teleports  ·  %d available"), #validItems, availableCount))
    self:UpdateAllCooldowns()
end

-- ============================================================================
-- COOLDOWNS
-- ============================================================================

function Mod:UpdateAllCooldowns()
    for _, btn in ipairs(self.buttons) do
        if btn:IsShown() then
            local start, duration
            if btn.spellID then
                local cd = C_Spell.GetSpellCooldown(btn.spellID)
                if cd then start, duration = cd.startTime, cd.duration end
            elseif btn.itemID then
                start, duration = C_Item.GetItemCooldown(btn.itemID)
            end

            local durationIsSecret = IsSecretValue(duration)
            local cooldownActive = false
            if start and duration then
                if durationIsSecret then
                    -- Forever may return a secret duration. It is valid to pass
                    -- it to the Cooldown widget, but not to compare it here.
                    cooldownActive = true
                else
                    local ok, positive = pcall(function()
                        return duration > 0
                    end)
                    cooldownActive = ok and positive == true
                end
            end

            if cooldownActive then
                local ok = pcall(btn.cooldown.SetCooldown, btn.cooldown, start, duration)
                if ok then
                    -- With a secret duration we cannot safely infer whether
                    -- the cooldown is active, so let the Cooldown widget draw
                    -- it and avoid a permanently stuck custom dimmer.
                    if durationIsSecret then
                        btn.dimmer:Hide()
                    else
                        btn.dimmer:Show()
                    end
                else
                    btn.cooldown:Clear()
                    btn.dimmer:Hide()
                end
            else
                btn.cooldown:Clear()
                btn.dimmer:Hide()
            end
        end
    end
end

-- ============================================================================
-- EVENT HANDLERS
-- ============================================================================

function Mod:OnZoneChanged()
    self:UpdateAllCooldowns()
end

function Mod:OnEnteringWorld()
    self:ApplyTeleportMinimapButtonStyle()
    C_Timer.After(0.1, function()
        if Mod and Mod.ApplyTeleportMinimapButtonStyle then
            Mod:ApplyTeleportMinimapButtonStyle()
        end
    end)
    self:UpdateAllCooldowns()
end

-- ============================================================================
-- TOGGLE / REFRESH
-- ============================================================================


function Mod:Toggle()
    local f = self:CreateMenuFrame()

    if f:GetParent() ~= UIParent then
        f:SetParent(UIParent)
        f:SetClampedToScreen(true)
        f:SetFrameStrata("FULLSCREEN_DIALOG")
        f:SetFrameLevel(20)
        f:SetMovable(true)
        f:RegisterForDrag("LeftButton")
        f:ClearAllPoints()
        f:SetPoint(
            self.db.anchor or "CENTER",
            UIParent, "CENTER",
            self.db.xOffset or 0,
            self.db.yOffset or 0
        )
        f._ktEmbedded = nil
        if f._ktEmbeddedCloseButtons then
            for button in pairs(f._ktEmbeddedCloseButtons) do
                if button then
                    button:Show()
                end
            end
        end
        if f.closeBtn then
            f.closeBtn:Show()
        end
        if f.gearBtn then
            f.gearBtn:Show()
        end
        f:Show()
        self:ShowCategory(self.activeCategory or "Hearthstones")
    elseif f:IsShown() then
        f:Hide()
    else
        f:Show()
        self:ShowCategory(self.activeCategory or "Hearthstones")
    end
end

function Mod:Refresh()
    if InCombatLockdown() then
        self.pendingCategory = self.activeCategory or "Hearthstones"
        return
    end

    self:ApplyTeleportMinimapButtonStyle()

    if self.menuFrame then
        self:ApplyFrameStyle(self.menuFrame)
        self:RefreshThemeColors()
        self:ShowCategory(self.activeCategory)
    end
end

-- ============================================================================
-- MINIMAP BUTTON
-- ============================================================================

function Mod:ApplyTeleportMinimapButtonStyle()
    if not Minimap then return end

    local iconPath = 'Interface\\AddOns\\KullThranUI\\Libraries\\texture\\media\\icons\\extra\\PortalMinimapIconCustom.png'
    local broker = LDB and LDB.GetDataObjectByName and LDB:GetDataObjectByName('KT_Teleport')
    if broker then
        broker.icon = iconPath
        broker.text = 'KullThranUI - Teleport Menu'
        broker.OnTooltipShow = function(tooltip)
            tooltip:AddLine(LText('KullThranUI - Teleport Menu'))
            tooltip:AddLine(LText('Left-click: open/close'), 1, 1, 1)
            tooltip:AddLine(LText('Right-click: settings'), 1, 1, 1)
        end
    end

    self.db.minimap = self.db.minimap or {}
    self.db.minimap.hide = false
    self.db.minimap.lock = true
    if LDBIcon and LDBIcon.Show then
        LDBIcon:Show('KT_Teleport')
    end
    if LDBIcon and LDBIcon.Lock then
        LDBIcon:Lock('KT_Teleport')
    end

    local button = (LDBIcon and LDBIcon:GetMinimapButton('KT_Teleport')) or self.nativeMinimapButton
    if not button then return end

    button._ktMenuLabel = 'KullThranUI - Teleport Menu'
    -- This button sits outside Minimap's bounds; UIParent prevents its mouse
    -- region and artwork from being clipped by the minimap or its overlays.
    button:SetParent(UIParent)
    -- Match the 22x22 Friends/Guild minimap launchers.
    button:SetSize(22, 22)
    button:SetScale(1)
    button:SetAlpha(1)
    button:EnableMouse(true)
    button:Show()
    -- The Minimap module stacks this icon with the Friends/Guild/KUI launchers on the
    -- side chosen in its options; the old fixed anchor is the fallback.
    local minimapModule = KT:GetModule('Minimap', true)
    if minimapModule and minimapModule.LayoutSideIcons and minimapModule.db then
        minimapModule:LayoutSideIcons()
    else
        button:ClearAllPoints()
        button:SetPoint('BOTTOMRIGHT', Minimap, 'BOTTOMLEFT', 0, 0)
    end
    button:SetFrameStrata('HIGH')
    button:SetFrameLevel(51)

    if not button._ktModernBackground then
        local background = button:CreateTexture(nil, 'BACKGROUND')
        background:SetAllPoints()
        background:SetColorTexture(0.012, 0.012, 0.016, 0.96)
        button._ktModernBackground = background

        button._ktModernEdges = {}
        for index = 1, 4 do
            local edge = button:CreateTexture(nil, 'BORDER')
            button._ktModernEdges[index] = edge
        end
        button._ktModernEdges[1]:SetPoint('TOPLEFT')
        button._ktModernEdges[1]:SetPoint('TOPRIGHT')
        button._ktModernEdges[1]:SetHeight(1)
        button._ktModernEdges[2]:SetPoint('BOTTOMLEFT')
        button._ktModernEdges[2]:SetPoint('BOTTOMRIGHT')
        button._ktModernEdges[2]:SetHeight(1)
        button._ktModernEdges[3]:SetPoint('TOPLEFT')
        button._ktModernEdges[3]:SetPoint('BOTTOMLEFT')
        button._ktModernEdges[3]:SetWidth(1)
        button._ktModernEdges[4]:SetPoint('TOPRIGHT')
        button._ktModernEdges[4]:SetPoint('BOTTOMRIGHT')
        button._ktModernEdges[4]:SetWidth(1)
    end

    for _, edge in ipairs(button._ktModernEdges or {}) do
        edge:Hide()
    end

    if button.icon then
        button.icon:SetAlpha(0)
        button.icon:Hide()
    end
    if not button._ktPortalIcon then
        button._ktPortalIcon = button:CreateTexture(nil, 'ARTWORK', nil, 1)
    end
    button._ktPortalIcon:SetTexture(iconPath)
    button._ktPortalIcon:ClearAllPoints()
    button._ktPortalIcon:SetPoint('CENTER', button, 'CENTER', 0, 0)
    button._ktPortalIcon:SetSize(16, 16)
    button._ktPortalIcon:SetTexCoord(0, 1, 0, 1)
    button._ktPortalIcon:SetVertexColor(1, 1, 1, 1)
    button._ktPortalIcon:Show()
    if button.border then button.border:Hide() end
    if button.background then button.background:Hide() end
    if button.overlay then button.overlay:Hide() end
    -- LibDBIcon dresses its buttons with a gold tracking ring + round dark disc whose field
    -- names change between versions: hide every texture region that is not ours (keep the
    -- hover highlight), so no decorative circle is left around the portal icon.
    local keep = {
        [button._ktPortalIcon] = true, [button._ktModernBackground] = true,
        [button.GetHighlightTexture and button:GetHighlightTexture() or false] = true,
    }
    for _, region in ipairs({ button:GetRegions() }) do
        if not keep[region] and region.GetObjectType and region:GetObjectType() == 'Texture' then
            region:Hide()
            region:SetAlpha(0)
        end
    end
end

function Mod:SetupMinimapButton()
    if not LDB or not LDBIcon then
        local button = self.nativeMinimapButton or _G.KT_TeleportNativeButton
        if not button then
            button = CreateFrame('Button', 'KT_TeleportNativeButton', UIParent)
            button:RegisterForClicks('LeftButtonUp', 'RightButtonUp')
            button.icon = button:CreateTexture(nil, 'ARTWORK')
            button.icon:SetAllPoints()
            button:SetScript('OnClick', function(_, mouseButton)
                if mouseButton == 'LeftButton' then
                    Mod:Toggle()
                elseif mouseButton == 'RightButton' and KT.OpenMenu then
                    Mod:Toggle()
                    KT:OpenMenu('teleportmenu')
                end
            end)
            button:SetScript('OnEnter', function(owner)
                GameTooltip:SetOwner(owner, 'ANCHOR_RIGHT')
                GameTooltip:AddLine(LText('KullThranUI - Teleport Menu'))
                GameTooltip:AddLine(LText('Left-click: open/close'), 1, 1, 1)
                GameTooltip:AddLine(LText('Right-click: settings'), 1, 1, 1)
                GameTooltip:Show()
            end)
            button:SetScript('OnLeave', function() GameTooltip:Hide() end)
        end
        self.nativeMinimapButton = button
        self:ApplyTeleportMinimapButtonStyle()
        return
    end

    local broker = LDB:NewDataObject("KT_Teleport", {
        type  = "launcher",
        text  = "Teleport",
        icon  = "Interface\\Icons\\Spell_Arcane_TeleportStormwind",
        OnClick = function(_, button)
            if button == "LeftButton" then
                Mod:Toggle()
            elseif button == "RightButton" and KT.OpenMenu then
                Mod:Toggle()
                KT:OpenMenu("teleportmenu")
            end
        end,
        OnTooltipShow = function(tt)
            tt:AddLine(LText("KullThran — Teleport Menu"))
            tt:AddLine(LText("Left-click: open/close"), 1, 1, 1)
            tt:AddLine(LText("Right-click: settings"),  1, 1, 1)
        end,
    })
    LDBIcon:Register("KT_Teleport", broker, self.db.minimap)
end
