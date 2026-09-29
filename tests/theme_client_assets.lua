local function expect(actual, expected, label)
    if actual ~= expected then
        error(string.format("%s: expected %s, got %s", label, tostring(expected), tostring(actual)))
    end
end

local function near(actual, expected, label)
    if math.abs(actual - expected) > 0.0001 then
        error(string.format("%s: expected %.4f, got %.4f", label, expected, actual))
    end
end

local function NewRegion(parent)
    local region = {
        parent = parent,
        width = 0,
        height = 0,
        level = 0,
        strata = "LOW",
        shown = true,
        points = {},
        masks = {},
    }

    function region:SetAllPoints(relative) self.allPoints = relative or true end
    function region:ClearAllPoints() self.points = {} end
    function region:SetPoint(...) self.points[#self.points + 1] = { ... } end
    function region:SetSize(width, height) self.width, self.height = width, height end
    function region:SetWidth(width) self.width = width end
    function region:SetHeight(height) self.height = height end
    function region:GetWidth() return self.width end
    function region:GetHeight() return self.height end
    function region:SetFrameStrata(strata) self.strata = strata end
    function region:GetFrameStrata() return self.strata end
    function region:SetFrameLevel(level) self.level = level end
    function region:GetFrameLevel() return self.level end
    function region:EnableMouse(enabled) self.mouseEnabled = enabled end
    function region:Show() self.shown = true end
    function region:Hide() self.shown = false end
    function region:SetAtlas(atlas) self.atlas = atlas end
    function region:SetTexture(texture) self.texture = texture end
    function region:SetTexCoord(...) self.texCoord = { ... } end
    function region:SetSnapToPixelGrid(value) self.snap = value end
    function region:SetTexelSnappingBias(value) self.bias = value end
    function region:AddMaskTexture(mask) self.masks[mask] = true end
    function region:RemoveMaskTexture(mask) self.masks[mask] = nil end
    function region:SetJustifyH(value) self.justify = value end
    function region:GetFont() return self.fontPath, self.fontSize, self.fontFlags end
    function region:SetFont(path, size, flags)
        self.fontPath, self.fontSize, self.fontFlags = path, size, flags
    end
    function region:CreateTexture()
        local texture = NewRegion(self)
        self.lastTexture = texture
        return texture
    end
    function region:CreateMaskTexture()
        local mask = NewRegion(self)
        self.lastMask = mask
        return mask
    end
    function region:GetStatusBarTexture() return self.fill end

    return region
end

_G.CreateFrame = function(_, _, parent) return NewRegion(parent) end
_G.C_Texture = {
    GetAtlasInfo = function(atlas)
        if atlas:find("%-Mask$") then return { width = 132, height = 32 } end
        return { width = 198, height = 71 }
    end,
}

local KT = { VisualThemes = {} }
local ace = {}
function ace:GetAddon() return KT end
function _G.LibStub() return ace end

local function LoadAssets()
    local chunk = assert(loadfile("KullThranUI/Modules/VisualThemes/ThemeClientAssets.lua"))
    chunk("KullThranUI", {})
end

local function MakeBar(frame, level)
    local bar = NewRegion(frame)
    bar.level = level
    bar.fill = NewRegion(bar)
    bar.bg = NewRegion(bar)
    return bar
end

local function MakeText(frame)
    local text = NewRegion(frame)
    text:SetFont("font.ttf", 14, "OUTLINE")
    return text
end

local function MakeUnitFrame()
    local frame = NewRegion(nil)
    frame:SetSize(230, 52)
    frame.Health = MakeBar(frame, 2)
    frame.Power = MakeBar(frame, 3)
    frame.Portrait = { backdrop = NewRegion(frame) }
    frame.Portrait.backdrop:SetSize(62, 62)
    frame.Portrait.backdrop:SetFrameStrata("MEDIUM")
    frame.Portrait.backdrop:SetFrameLevel(50)
    frame._textOverlay = NewRegion(frame.Health)
    frame.LeftText = MakeText(frame._textOverlay)
    frame.RightText = MakeText(frame._textOverlay)
    frame.CenterText = MakeText(frame._textOverlay)
    local absorb = MakeBar(frame.Health, 3)
    frame.HealthPrediction = { damageAbsorb = absorb }
    frame.Buffs = NewRegion(frame)
    frame.Buffs.spacing = 1
    return frame
end

LoadAssets()

local player = MakeUnitFrame()
expect(KT.VisualThemes:ApplyForeverUnitFrameArt(player, player.Portrait.backdrop, "player"), true, "player apply")
local playerScale = 230 / 232
near(player:GetWidth(), 230, "player box width")
near(player:GetHeight(), 100 * playerScale, "player box height")
near(player._ktForeverPortraitArt:GetWidth(), 198 * playerScale, "player visible atlas width")
near(player._ktForeverPortraitArt:GetHeight(), 71 * playerScale, "player visible atlas height")
expect(player._ktForeverArtHost:GetFrameStrata(), "LOW", "art follows bar strata")
expect(player._ktForeverArtHost:GetFrameLevel(), 1, "art below health")
expect(player.Portrait.backdrop:GetFrameLevel(), 0, "portrait below art")
expect(player.Portrait.backdrop._ktStockPortraitAnchor, true, "stock portrait owns its anchor")
near(player.Health:GetWidth(), 124 * playerScale, "player health width")
near(player.Power:GetWidth(), 124 * playerScale, "player power width")
near(player.Health.points[1][4], 85 * playerScale, "player health x")
near(player.Health.points[1][5], -40 * playerScale, "player health y")
near(player.LeftText.points[1][4], 88 * playerScale, "player name x")
near(player.LeftText.points[1][5], -27 * playerScale, "player name y sign")
expect(player.Buffs.points[1][1], "BOTTOMLEFT", "player buffs anchor point")
near(player.Buffs.points[1][4], 88 * playerScale, "player buffs x")
near(player.Buffs.points[1][5], -27 * playerScale, "player buffs y (same tab as name)")
near(player.Buffs:GetWidth(), 96 * playerScale, "player buffs width (tab width)")
near(player.Buffs:GetHeight(), 14 * playerScale, "player buffs height (tab height)")
near(player.Buffs.size, 14 * playerScale, "player buffs icon size")
expect(player.Health.fill.masks[player.Health._ktForeverMask], true, "health fill mask")
expect(player.Health.bg.masks[player.Health._ktForeverMask], true, "health background mask")
expect(player.HealthPrediction.damageAbsorb.fill.masks[player.Health._ktForeverMask], true, "absorb mask")

-- Applying a second time must produce the same geometry, not feed the new
-- Health position back through the portrait and drift the whole box.
expect(KT.VisualThemes:ApplyForeverUnitFrameArt(player, player.Portrait.backdrop, "player"), true, "player reapply")
near(player.Health.points[1][4], 85 * playerScale, "player stable health x")
near(player.Portrait.backdrop.points[1][4], 24 * playerScale, "player stable portrait x")

-- frame._ktStockNameText lets KUIUnitFrames.lua (which has access to the
-- profile's leftTextContent/rightTextContent/centerTextContent) tell this
-- file which FontString actually holds the name, for a profile where that
-- isn't frame.LeftText -- confirmed live as a real bug: the name silently
-- never appeared in the tab for such a profile.
local renamed = MakeUnitFrame()
renamed._ktStockNameText = renamed.RightText
expect(KT.VisualThemes:ApplyForeverUnitFrameArt(renamed, renamed.Portrait.backdrop, "player"), true, "renamed-slot apply")
near(renamed.RightText.points[1][4], 88 * playerScale, "renamed-slot name x lands on the override, not LeftText")
expect(#renamed.LeftText.points, 0, "renamed-slot LeftText left untouched by the tab move")

local target = MakeUnitFrame()
expect(KT.VisualThemes:ApplyForeverUnitFrameArt(target, target.Portrait.backdrop, "target"), true, "target apply")
local targetScale = 230 / 232
near(target.Health:GetWidth(), 126 * targetScale, "target health width")
near(target.Power:GetWidth(), 134 * targetScale, "target power width")
near(target.Portrait.backdrop.points[1][4], -26 * targetScale, "target portrait x")
near(target.LeftText.points[1][5], -26 * targetScale, "target name y sign")

local classic = MakeUnitFrame()
classic:SetSize(282, 52) -- attached KUI width includes its portrait
classic.Health:SetSize(230, 46)
expect(KT.VisualThemes:ApplyClassicUnitFrameArt(classic, classic.Portrait.backdrop, "player"), true, "classic apply")
local classicScale = 230 / 232
expect(classic._ktClassicArtHost:GetFrameStrata(), "LOW", "classic art follows bar strata")
expect(classic._ktClassicArtHost:GetFrameLevel(), 4, "classic art above bars")
expect(classic.Portrait.backdrop:GetFrameLevel(), 1, "classic portrait below bars")
expect(classic.Portrait.backdrop._ktStockPortraitAnchor, true, "classic portrait owns its anchor")
near(classic:GetWidth(), 230, "classic attached width normalization")
near(classic:GetHeight(), 100 * classicScale, "classic box height")
near(classic._ktClassicPortraitArt:GetWidth(), 230 * classicScale, "classic art width")
near(classic._ktClassicPortraitArt:GetHeight(), 99 * classicScale, "classic art height")
near(classic.Health:GetWidth(), 119 * classicScale, "classic health width")
near(classic.Power:GetWidth(), 119 * classicScale, "classic power width")
near(classic.LeftText.points[1][5], 15 * classicScale, "classic name y")

KT.VisualThemes:ClearForeverUnitFrameArt(player)
expect(player._ktForeverPortraitArt.shown, false, "clear art")
expect(player.Health._ktForeverMask.shown, false, "clear health mask")
expect(player.Health.fill.masks[player.Health._ktForeverMask], nil, "detach health mask")
expect(player.Portrait.backdrop._ktStockPortraitAnchor, nil, "clear stock portrait anchor")

print("theme_client_assets: ok")