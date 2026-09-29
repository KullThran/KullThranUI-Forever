local addonName, ns = ...
local KT = LibStub("AceAddon-3.0"):GetAddon("KullThranUI")
KT.VisualThemes = KT.VisualThemes or {}

local WHITE = "Interface\\Buttons\\WHITE8X8"
local CLASSIC_SLOT = "Interface\\Buttons\\UI-Quickslot"

local PREVIEW = {
    kui = {
        background = { 0.035, 0.035, 0.045, 1 },
        frame = { 0.12, 0.12, 0.14, 1 },
        health = { 0.72, 0.23, 0.18, 1 },
        power = { 0.12, 0.45, 0.82, 1 },
        border = { 1.00, 0.49, 0.00, 1 },
        roundPortrait = true,
    },
    -- Forever reuses Classic's shape (square portrait, quickslot-style icon
    -- borders) recolored bronze/gold, instead of a separate flat kit.
    forever = {
        background = { 0.055, 0.035, 0.015, 1 },
        frame = { 0.16, 0.10, 0.035, 1 },
        health = { 0.26, 0.62, 0.24, 1 },
        power = { 0.20, 0.38, 0.74, 1 },
        border = { 0.82, 0.65, 0.23, 1 },
        classicSlots = true,
    },
    retail = {
        background = { 0.018, 0.028, 0.055, 1 },
        frame = { 0.06, 0.10, 0.18, 1 },
        health = { 0.12, 0.62, 0.26, 1 },
        power = { 0.10, 0.42, 0.92, 1 },
        border = { 0.20, 0.58, 1.00, 1 },
        hidePortrait = true,
    },
    classic = {
        background = { 0.065, 0.045, 0.020, 1 },
        frame = { 0.18, 0.12, 0.055, 1 },
        health = { 0.18, 0.66, 0.20, 1 },
        power = { 0.12, 0.32, 0.78, 1 },
        border = { 0.92, 0.72, 0.22, 1 },
        classicSlots = true,
    },
}

local function ColorParts(color)
    if color.r or color.g or color.b then
        return color.r or 0, color.g or 0, color.b or 0, color.a or 1
    end
    return color[1] or 0, color[2] or 0, color[3] or 0, color[4] or 1
end

local function Color(texture, color)
    texture:SetColorTexture(ColorParts(color))
end

local function AddEdges(frame, color, size)
    size = size or 1
    frame._themeEdges = frame._themeEdges or {}
    local points = {
        { "TOPLEFT", "TOPRIGHT", true },
        { "BOTTOMLEFT", "BOTTOMRIGHT", true },
        { "TOPLEFT", "BOTTOMLEFT", false },
        { "TOPRIGHT", "BOTTOMRIGHT", false },
    }
    for index, info in ipairs(points) do
        local edge = frame._themeEdges[index] or frame:CreateTexture(nil, "OVERLAY")
        frame._themeEdges[index] = edge
        edge:SetTexture(WHITE)
        edge:ClearAllPoints()
        edge:SetPoint(info[1], frame, info[1])
        edge:SetPoint(info[2], frame, info[2])
        if info[3] then edge:SetHeight(size) else edge:SetWidth(size) end
        edge:SetColorTexture(ColorParts(color))
        edge:Show()
    end
end

local function MakePanel(parent, width, height, point, relative, relativePoint, x, y, fill, border, borderSize)
    local panel = CreateFrame("Frame", nil, parent)
    panel:SetSize(width, height)
    panel:SetPoint(point, relative or parent, relativePoint or point, x or 0, y or 0)
    local bg = panel:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    Color(bg, fill)
    AddEdges(panel, border, borderSize)
    return panel
end

function KT.VisualThemes:CreatePreview(parent, themeKey, options)
    options = options or {}
    local kit = PREVIEW[themeKey] or PREVIEW.kui
    local width = math.max(80, tonumber(options.width) or parent:GetWidth() or 140)
    local height = math.max(52, tonumber(options.height) or parent:GetHeight() or 74)

    local stage = CreateFrame("Frame", nil, parent)
    stage:SetSize(width, height)
    if options.point then
        stage:SetPoint(unpack(options.point))
    else
        stage:SetPoint("TOPLEFT")
    end
    if stage.SetClipsChildren then stage:SetClipsChildren(true) end

    local bg = stage:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    Color(bg, kit.background)
    AddEdges(stage, { 0.18, 0.18, 0.20, 1 }, 1)

    local margin = 7
    local portraitSize = math.max(22, math.floor(height * 0.42))
    local unitWidth = width - (margin * 2)
    local portraitGap = kit.hidePortrait and 0 or (portraitSize + 5)
    local barsWidth = unitWidth - portraitGap
    local unitTop = -7

    if not kit.hidePortrait then
        local portrait = MakePanel(stage, portraitSize, portraitSize, "TOPLEFT", stage, "TOPLEFT", margin, unitTop, kit.frame, kit.border, themeKey == "forever" and 2 or 1)
        local icon = portrait:CreateTexture(nil, "ARTWORK")
        icon:SetPoint("TOPLEFT", portrait, "TOPLEFT", 2, -2)
        icon:SetPoint("BOTTOMRIGHT", portrait, "BOTTOMRIGHT", -2, 2)
        icon:SetTexture(134400)
        if kit.roundPortrait and icon.SetMask then
            icon:SetMask("Interface\\CHARACTERFRAME\\TempPortraitAlphaMask")
        end
    end

    local bars = MakePanel(stage, barsWidth, portraitSize, "TOPRIGHT", stage, "TOPRIGHT", -margin, unitTop, kit.frame, kit.border, 1)
    local health = bars:CreateTexture(nil, "ARTWORK")
    health:SetPoint("TOPLEFT", bars, "TOPLEFT", 2, -2)
    health:SetPoint("TOPRIGHT", bars, "TOPRIGHT", -2, -2)
    health:SetHeight(math.max(10, portraitSize - 10))
    Color(health, kit.health)

    local power = bars:CreateTexture(nil, "ARTWORK", nil, 1)
    power:SetPoint("BOTTOMLEFT", bars, "BOTTOMLEFT", 2, 2)
    power:SetPoint("BOTTOMRIGHT", bars, "BOTTOMRIGHT", -2, 2)
    power:SetHeight(5)
    Color(power, kit.power)

    local name = bars:CreateFontString(nil, "OVERLAY")
    name:SetFont(KT.FONT_PATH or "Fonts\\FRIZQT__.TTF", 8, "OUTLINE")
    name:SetPoint("CENTER", health, "CENTER", 0, 0)
    name:SetText(themeKey == "retail" and "PLAYER" or "KULLTHRAN")
    name:SetTextColor(1, 1, 1, 1)

    local slotSize = math.max(14, math.min(22, math.floor(height * 0.27)))
    local slotGap = 3
    local slotY = 6
    local totalSlots = (slotSize * 4) + (slotGap * 3)
    local firstX = math.floor((width - totalSlots) * 0.5)
    local icons = { 135932, 135846, 136096, 136116 }
    for index = 1, 4 do
        local slot = CreateFrame("Frame", nil, stage)
        slot:SetSize(slotSize, slotSize)
        slot:SetPoint("BOTTOMLEFT", stage, "BOTTOMLEFT", firstX + ((index - 1) * (slotSize + slotGap)), slotY)
        local slotBg = slot:CreateTexture(nil, "BACKGROUND")
        slotBg:SetAllPoints()
        if kit.classicSlots then
            slotBg:SetTexture(CLASSIC_SLOT)
            local br, bg_, bb = ColorParts(kit.border)
            slotBg:SetVertexColor(br, bg_, bb, 1)
        else
            Color(slotBg, kit.frame)
        end
        AddEdges(slot, kit.border, themeKey == "forever" and 2 or 1)
        local icon = slot:CreateTexture(nil, "ARTWORK")
        icon:SetPoint("TOPLEFT", slot, "TOPLEFT", 2, -2)
        icon:SetPoint("BOTTOMRIGHT", slot, "BOTTOMRIGHT", -2, 2)
        icon:SetTexture(icons[index])
    end

    stage.themeKey = themeKey
    return stage
end

function KT.VisualThemes:UpdatePreview(preview, themeKey, options)
    if preview then
        preview:Hide()
        preview:ClearAllPoints()
    end
    local parent = preview and preview:GetParent()
    if not parent then return nil end
    return self:CreatePreview(parent, themeKey, options)
end

function KT.VisualThemes:ReleasePreview(preview)
    if not preview then return end
    preview:Hide()
    preview:ClearAllPoints()
end

function KT.VisualThemes:CreateThemeCard(parent, themeKey, options)
    options = options or {}
    local catalog = self:GetThemeCatalog()
    local theme = catalog[themeKey]
    if not theme then return nil, 0 end

    local compact = options.compact == true
    local width = tonumber(options.width) or 170
    local height = compact and 148 or 208
    local card = CreateFrame("Button", nil, parent)
    card:SetSize(width, height)

    local bg = card:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetColorTexture(0.025, 0.03, 0.04, 0.98)
    AddEdges(card, theme.color, self:GetRenderedTheme() == themeKey and 2 or 1)

    local title = card:CreateFontString(nil, "OVERLAY")
    title:SetFont(KT.FONT_PATH or "Fonts\\FRIZQT__.TTF", compact and 10 or 12, "OUTLINE")
    title:SetPoint("TOP", card, "TOP", 0, -9)
    title:SetText(theme.name)
    title:SetTextColor(theme.color.r, theme.color.g, theme.color.b, 1)

    local subtitle = card:CreateFontString(nil, "OVERLAY")
    subtitle:SetFont(KT.FONT_PATH or "Fonts\\FRIZQT__.TTF", 8, "OUTLINE")
    subtitle:SetPoint("TOP", title, "BOTTOM", 0, -2)
    subtitle:SetText(theme.shortName or "")
    subtitle:SetTextColor(0.55, 0.65, 0.75, 1)

    local previewHost = CreateFrame("Frame", nil, card)
    previewHost:SetPoint("TOPLEFT", card, "TOPLEFT", 8, -39)
    previewHost:SetPoint("TOPRIGHT", card, "TOPRIGHT", -8, -39)
    previewHost:SetHeight(compact and 73 or 92)
    self:CreatePreview(previewHost, themeKey, {
        width = math.max(80, width - 16),
        height = compact and 73 or 92,
    })

    if not compact then
        local description = card:CreateFontString(nil, "OVERLAY")
        description:SetFont(KT.FONT_PATH or "Fonts\\FRIZQT__.TTF", 9)
        description:SetPoint("TOPLEFT", previewHost, "BOTTOMLEFT", 2, -7)
        description:SetPoint("TOPRIGHT", previewHost, "BOTTOMRIGHT", -2, -7)
        description:SetJustifyH("CENTER")
        description:SetText(theme.description or "")
        description:SetTextColor(0.82, 0.84, 0.88, 1)
    end

    local state = card:CreateFontString(nil, "OVERLAY")
    state:SetFont(KT.FONT_PATH or "Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
    state:SetPoint("BOTTOM", card, "BOTTOM", 0, 8)
    if self:GetRenderedTheme() == themeKey then
        state:SetText("IN USE")
        state:SetTextColor(theme.color.r, theme.color.g, theme.color.b, 1)
    else
        state:SetText("APPLY")
        state:SetTextColor(0.92, 0.92, 0.92, 1)
    end

    card:SetScript("OnClick", function()
        KT.VisualThemes:RequestApply(themeKey)
    end)
    card:SetScript("OnEnter", function(self)
        AddEdges(self, { 1, 1, 1, 1 }, 2)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(theme.name)
        GameTooltip:AddLine(theme.description or "", 0.9, 0.9, 0.9, true)
        GameTooltip:Show()
    end)
    card:SetScript("OnLeave", function(self)
        local active = KT.VisualThemes:GetRenderedTheme() == themeKey
        AddEdges(self, theme.color, active and 2 or 1)
        GameTooltip:Hide()
    end)

    return card, height
end
