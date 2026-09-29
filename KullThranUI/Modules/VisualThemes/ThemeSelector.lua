local addonName, ns = ...
local KT = LibStub("AceAddon-3.0"):GetAddon("KullThranUI")
KT.VisualThemes = KT.VisualThemes or {}

function KT.VisualThemes:CreateSelector(parent, options)
    options = options or {}
    self:EnsureInitialized()

    local columns = math.max(1, tonumber(options.columns) or 2)
    local compact = options.compact == true
    local startY = tonumber(options.yOffset) or 0
    local gap = compact and 8 or 12
    local containerWidth = tonumber(options.width) or parent:GetWidth() or 200
    if containerWidth < 80 then containerWidth = 200 end

    local cardWidth = math.floor((containerWidth - (gap * (columns - 1))) / columns)
    local order = self:GetThemeOrder()
    local cardHeight = compact and 148 or 208

    for index, themeKey in ipairs(order) do
        local row = math.floor((index - 1) / columns)
        local column = (index - 1) % columns
        local card = self:CreateThemeCard(parent, themeKey, {
            compact = compact,
            width = cardWidth,
        })
        if card then
            card:SetPoint(
                "TOPLEFT",
                parent,
                "TOPLEFT",
                column * (cardWidth + gap),
                -(startY + (row * (cardHeight + gap)))
            )
        end
    end

    local rows = math.ceil(#order / columns)
    return (rows * cardHeight) + ((rows - 1) * gap) + 4
end
