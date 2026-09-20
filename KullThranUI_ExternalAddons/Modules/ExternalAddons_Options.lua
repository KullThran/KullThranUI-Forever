local _, ns = ...

local KT = (ns and ns.KT) or _G.KT or (LibStub("AceAddon-3.0"):GetAddon("KullThranUI", true))
if not KT then
    return
end

local Opt = KT.Options or {}
local Reload = Opt.Reload or function() StaticPopup_Show("KULLTHRANUI_RELOAD") end
local FONT = KT.FONT_PATH or STANDARD_TEXT_FONT
local ICON_BASE = "Interface\\AddOns\\KullThranUI\\Modules\\Installers\\Icons\\"

local EXTERNAL_ADDON_ICONS = {
    Auctionator = "Auctionator.tga",
    OPie = "Opie.tga",
    MiniCC = "KUI.tga",
}

local function GetAddonInfo(addonName)
    if type(addonName) ~= "string" or addonName == "" then
        return nil
    end

    local getter = C_AddOns and C_AddOns.GetAddOnInfo or GetAddOnInfo
    if not getter then
        return nil
    end

    local ok, info = pcall(getter, addonName)
    if not ok or type(info) ~= "string" or info == "" then
        return nil
    end
    return info
end

local function IsAddonEnabledForCurrentCharacter(addonName)
    if C_AddOns and C_AddOns.IsAddOnLoaded and C_AddOns.IsAddOnLoaded(addonName) then
        return true
    end

    if C_AddOns and C_AddOns.GetAddOnEnableState and UnitName then
        local playerName = UnitName("player")
        if playerName then
            local ok, state = pcall(C_AddOns.GetAddOnEnableState, playerName, addonName)
            if ok and (tonumber(state) or 0) > 0 then
                return true
            end
        end
    end

    return false
end

local function IsAddonAvailable(addonName)
    return GetAddonInfo(addonName) ~= nil and IsAddonEnabledForCurrentCharacter(addonName)
end

local function CreateExternalAddonButton(parent, yOffset, addonDef)
    local row = CreateFrame("Frame", nil, parent)
    row:SetSize(parent:GetWidth() - 20, 42)
    row:SetPoint("TOPLEFT", 10, yOffset)

    local btn = CreateFrame("Button", nil, row)
    btn:SetPoint("TOPLEFT", 12, -4)
    btn:SetPoint("BOTTOMRIGHT", -12, 4)
    KT:AddBackdrop(btn, 0.08, 0.08, 0.11, 1)
    KT:AddAccentBorder(btn, 0.5)

    local hover = btn:CreateTexture(nil, "BACKGROUND", nil, 1)
    hover:SetAllPoints()
    hover:SetColorTexture(1, 1, 1, 0)

    local icon = btn:CreateTexture(nil, "ARTWORK")
    icon:SetSize(18, 18)
    icon:SetPoint("LEFT", 10, 0)
    icon:SetTexture(ICON_BASE .. (EXTERNAL_ADDON_ICONS[addonDef.name] or "KUI.tga"))

    local label = btn:CreateFontString(nil, "OVERLAY")
    label:SetFont(FONT, 11, "OUTLINE")
    label:SetText(addonDef.label)
    label:SetTextColor(1, 1, 1, 1)
    label:SetJustifyH("LEFT")
    label:SetPoint("LEFT", icon, "RIGHT", 10, 0)

    local hintText = addonDef.hint
    if not hintText and type(addonDef.slash) == "table" then
        local commands = {}
        for _, command in ipairs(addonDef.slash) do
            commands[#commands + 1] = "/" .. command:gsub("^/", "")
        end
        hintText = table.concat(commands, "  ")
    end
    hintText = hintText or ""

    local hint = btn:CreateFontString(nil, "OVERLAY")
    hint:SetFont(FONT, 10)
    KT:SetAccentTextColor(hint, 0.9)
    hint:SetJustifyH("RIGHT")
    hint:SetText(hintText or "")
    hint:SetPoint("RIGHT", -12, 0)

    label:SetPoint("RIGHT", hint, "LEFT", -12, 0)

    btn:SetScript("OnEnter", function(self)
        KT:AddAccentBorder(self, 0.95)
        hover:SetColorTexture(1, 1, 1, 0.04)
        hint:SetTextColor(1, 1, 1, 1)
    end)
    btn:SetScript("OnLeave", function(self)
        KT:AddAccentBorder(self, 0.5)
        hover:SetColorTexture(1, 1, 1, 0)
        KT:SetAccentTextColor(hint, 0.9)
    end)

    btn:SetScript("OnClick", function()
        KT:OpenExternalAddon(addonDef.name, addonDef.slash, addonDef.ace, nil, addonDef.slashKey)
    end)

    return row, 44
end

KT:RegisterPage("external", "External Addons", 90, function(sc, W)
    local y, h = 0, 0

    _, h = W:SectionHeader(sc, "Integrations", -y); y = y + h
    local db = KT.db.profile

    local function IsAddonEnabledForPlayer(addonName)
        if C_AddOns and C_AddOns.GetAddOnEnableState then
            local playerName = UnitName and UnitName("player")
            if playerName then
                return (C_AddOns.GetAddOnEnableState(playerName, addonName) or 0) > 0
            end
        end
        return C_AddOns and C_AddOns.IsAddOnLoaded and C_AddOns.IsAddOnLoaded(addonName)
    end

    local function ShouldShowUUFIntegration()
        if not IsAddonEnabledForPlayer("UnhaltedUnitFrames") then
            return false
        end

        local uf = db.unitFrames
        local enabled = uf and uf.enable ~= false and uf.enabledFrames
        if not enabled then
            return false
        end

        local hasActiveKUIFrames =
            enabled.player ~= false or
            enabled.target ~= false or
            enabled.focus ~= false or
            enabled.targettarget ~= false or
            enabled.focustarget ~= false or
            enabled.boss ~= false

        return not hasActiveKUIFrames
    end

    if ShouldShowUUFIntegration() then
        _, h = W:Toggle(sc, "External Unit Frames Edit Mode", -y, function() return db.uufIntegration.enable end, function(v) db.uufIntegration.enable = v; Reload() end); y = y + h
    end
    _, h = W:SectionHeader(sc, "Open Addon Config", -y); y = y + h
    _, h = W:Label(sc, "Quick access buttons to supported external addons (only installed addons are shown).", -y, 11); y = y + h

    -- This is only a catalogue of integrations. It must never be treated as
    -- proof that the addon exists in the current client. Forever can expose
    -- the same addon API surface as Retail, so the final list is filtered by
    -- the current character's enabled addons below.
    local externalList = {
        {name="Auctionator", label="Auctionator", slash={"atr"}, ace={"Auctionator"}},
        {name="OPie",        label="OPie",        slash={"opie"}, ace={"OPie"}},
        {name="MiniCC",      label="MiniCC",      slash={"minicc"}, ace={"MiniCC"}},
    }

    local shown = 0
    for _, addon in ipairs(externalList) do
        if IsAddonAvailable(addon.name) then
            _, h = CreateExternalAddonButton(sc, -y, addon); y = y + h
            shown = shown + 1
        end
    end

    if shown == 0 then
        _, h = W:Label(sc, "No supported external addons are installed and enabled for this Forever client.", -y, 11)
        y = y + h
    end

    return y
end)
