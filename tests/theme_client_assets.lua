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

    function region:SetParent(newParent) self.parent = newParent end
    function region:GetParent() return self.parent end
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
    function region:SetColorTexture(r, g, b, a) self.colorTexture = { r, g, b, a } end
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
    function region:CreateFontString()
        local fs = NewRegion(self)
        function fs:SetText(text) self.text = text end
        function fs:SetTextColor(r, g, b, a) self.r, self.g, self.b, self.a = r, g, b, a end
        self.lastFontString = fs
        return fs
    end
    function region:GetStatusBarTexture() return self.fill end

    return region
end

_G.CreateFrame = function(_, _, parent) return NewRegion(parent) end
_G.UIParent = NewRegion(nil)
_G.SlashCmdList = {}

_G.C_Texture = {
    GetAtlasInfo = function(atlas)
        if atlas == "UI-HUD-UnitFrame-Target-PortraitOn-Type" then
            return { width = 134, height = 20 }
        end
        if atlas == "UI-HUD-UnitFrame-Player-Portrait-Mask" then
            return {
                width = 64, height = 64, file = "Interface\\Fake\\PlayerPortraitMask",
                leftTexCoord = 0.2, rightTexCoord = 0.8,
                topTexCoord = 0.1, bottomTexCoord = 0.9,
            }
        end
        if atlas == "CircleMask" then
            return {
                width = 64, height = 64, file = "Interface\\Fake\\TargetPortraitMask",
                leftTexCoord = 0.15, rightTexCoord = 0.85,
                topTexCoord = 0.05, bottomTexCoord = 0.95,
            }
        end
        if atlas:find("%-Mask$") then return { width = 132, height = 32 } end
        return {
            width = 198, height = 71, file = "Interface\\Fake\\StockArt",
            leftTexCoord = 0.1, rightTexCoord = 0.9,
            topTexCoord = 0.2, bottomTexCoord = 0.8,
        }
    end,
}

local KT = { VisualThemes = {} }
local mockRenderedTheme = nil
function KT.VisualThemes:GetRenderedTheme() return mockRenderedTheme end
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
    frame.Portrait.backdrop._shapeMask = NewRegion(frame.Portrait.backdrop)
    frame.Portrait.backdrop._2d = NewRegion(frame.Portrait.backdrop)

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
    local castbarBg = NewRegion(frame)
    castbarBg:SetSize(230, 14)
    castbarBg._bgTex = NewRegion(castbarBg)
    castbarBg._ppBorders = { NewRegion(castbarBg), NewRegion(castbarBg), NewRegion(castbarBg), NewRegion(castbarBg) }
    frame.Castbar = NewRegion(castbarBg)
    return frame
end

LoadAssets()

mockRenderedTheme = "forever"
local player = MakeUnitFrame()
expect(KT.VisualThemes:ApplyForeverUnitFrameArt(player, player.Portrait.backdrop, "player"), true, "player apply")
local playerScale = 230 / 232
near(player:GetWidth(), 230, "player box width")
near(player:GetHeight(), 100 * playerScale, "player box height")
near(player._ktForeverPortraitArt:GetWidth(), 198 * playerScale, "player visible atlas width")
near(player._ktForeverPortraitArt:GetHeight(), 71 * playerScale, "player visible atlas height")
expect(player._ktForeverPortraitArt.atlas, nil, "player raw art does not use SetAtlas")
expect(player._ktForeverPortraitArt.texture, "Interface\\Fake\\StockArt", "player art resolves to the raw sheet file")
expect(player._ktForeverPortraitArt.texCoord[1], 0.1, "player art remains unmirrored")
expect(player._ktForeverPortraitArt.texCoord[2], 0.9, "player art right texcoord remains unmirrored")
expect(player._ktForeverArtHost:GetFrameStrata(), "LOW", "art follows bar strata")
expect(player._ktForeverArtHost:GetFrameLevel(), 1, "art below health")
expect(player.Portrait.backdrop:GetFrameLevel(), 0, "portrait below art")
expect(player.Portrait.backdrop._ktStockPortraitAnchor, true, "stock portrait owns its anchor")
near(player.Health:GetWidth(), 124 * playerScale, "player health width")
near(player.Power:GetWidth(), 124 * playerScale, "player power width")
near(player.Castbar:GetParent():GetWidth(), 124 * playerScale, "player castbar matches real power width")
near(player.Castbar:GetParent():GetHeight(), 10 * playerScale, "player castbar matches real power height (slender, not KUI's generic thickness)")
expect(player.Castbar:GetParent().points[1][2], player.Power, "player castbar re-anchored directly to Power (not via the old healthOff formula)")
expect(player.Castbar:GetParent().points[1][1], "TOPLEFT", "player castbar anchor point")
expect(player.Castbar:GetParent().points[1][3], "BOTTOMLEFT", "player castbar anchor relative point")
expect(player.Castbar:GetParent()._bgTex.colorTexture, nil, "player castbar background untouched (not Classic)")
near(player.Health.points[1][4], 85 * playerScale, "player health x")
near(player.Health.points[1][5], -40 * playerScale, "player health y")
near(player.LeftText.points[1][4], 88 * playerScale, "player name x")
near(player.LeftText.points[1][5], -27 * playerScale, "player name y sign")
expect(player.LeftText:GetParent(), player._ktForeverArtHost, "player name reparented off Health's clipped hierarchy")
expect(player.Buffs.points[1][1], "BOTTOMLEFT", "player buffs anchor point")
near(player.Buffs.points[1][4], 88 * playerScale, "player buffs x")
near(player.Buffs.points[1][5], (-27 + 3) * playerScale, "player buffs y (name tab + gap)")
near(player.Buffs:GetWidth(), 124 * playerScale, "player buffs width (health width)")
near(player.Buffs:GetHeight(), 20 * playerScale, "player buffs height (health height)")
near(player.Buffs.size, 20 * playerScale, "player buffs icon size")
local _, playerLeftFontSize = player.LeftText:GetFont()
near(playerLeftFontSize, 14 * playerScale, "player LeftText font uncapped (20px-tall bar fits it fine)")
expect(player.Health.fill.masks[player.Health._ktForeverMask], true, "health fill mask")
expect(player.Health.bg.masks[player.Health._ktForeverMask], true, "health background mask")
expect(player.HealthPrediction.damageAbsorb.fill.masks[player.Health._ktForeverMask], true, "absorb mask")

-- Modern Rare/Elite art replaces the base portrait ornament. Health/Power
-- must grow only toward the portrait: player extends left while preserving
-- the original right edge, and its masks/prediction grow with the bars.
local playerBaseHealthRight = player.Health.points[1][4] + player.Health:GetWidth()
local playerBasePowerRight = player.Power.points[1][4] + player.Power:GetWidth()
player._ktRingHugShift = -6
expect(KT.VisualThemes:ApplyForeverUnitFrameArt(player, player.Portrait.backdrop, "player"), true,
    "player Rare/Elite bar extension apply")
near(player.Health.points[1][4], 85 * playerScale - 6, "player Rare/Elite health extends toward portrait")
near(player.Health:GetWidth(), 124 * playerScale + 6, "player Rare/Elite health width grows")
near(player.Health.points[1][4] + player.Health:GetWidth(), playerBaseHealthRight,
    "player Rare/Elite health outer edge stays fixed")
near(player.Power.points[1][4] + player.Power:GetWidth(), playerBasePowerRight,
    "player Rare/Elite power outer edge stays fixed")
near(player.Health._ktForeverMask:GetWidth(), 132 * playerScale + 6,
    "player Rare/Elite health mask grows with bar")
near(player.HealthPrediction.damageAbsorb:GetWidth(), 124 * playerScale + 6,
    "player Rare/Elite absorb grows with health")
player._ktRingHugShift = nil

-- Applying a second time must produce the same geometry, not feed the new
-- Health position back through the portrait and drift the whole box.
expect(KT.VisualThemes:ApplyForeverUnitFrameArt(player, player.Portrait.backdrop, "player"), true, "player reapply")
near(player.Health.points[1][4], 85 * playerScale, "player stable health x")
near(player.Portrait.backdrop.points[1][4], 24 * playerScale, "player stable portrait x")

-- PLAYER Rare/Elite borders replace the Forever portrait ornament. The
-- renderer itself must retain that state across late/repeated art passes.
player._ktHideForeverPortraitArt = true
expect(KT.VisualThemes:ApplyForeverUnitFrameArt(player, player.Portrait.backdrop, "player"), true,
    "player Rare/Elite art suppression apply")
expect(player._ktForeverPortraitArt.shown, false, "player Rare/Elite hides Forever art")
expect(player._ktForeverPortraitArtFill.shown, false, "player Rare/Elite hides Forever fill")
expect(player._ktForeverPortraitCornerPatch.shown, false, "player Rare/Elite hides first Forever corner patch")
expect(player._ktForeverPortraitCornerPatch2.shown, false, "player Rare/Elite hides second Forever corner patch")
player._ktHideForeverPortraitArt = false
expect(KT.VisualThemes:ApplyForeverUnitFrameArt(player, player.Portrait.backdrop, "player"), true,
    "player no-border art restoration apply")
expect(player._ktForeverPortraitArt.shown, true, "player no-border restores Forever art")
expect(player._ktForeverPortraitArtFill.shown, true, "player no-border restores Forever fill")
expect(player._ktForeverPortraitCornerPatch.shown, false, "player no-border keeps inactive Forever corner hidden")
expect(player._ktForeverPortraitCornerPatch2.shown, true, "player no-border restores active Forever corner")

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
near(target.Health:GetWidth(), 124 * targetScale, "target health width (mirrored player values)")
near(target.Power:GetWidth(), 124 * targetScale, "target power width (mirrored player values)")
near(target.Portrait.backdrop.points[1][4], -24 * targetScale, "target portrait x (mirrored player values)")
near(target.LeftText.points[1][5], -27 * targetScale, "target name y (matches player, box only flips horizontally)")
-- Explicit user request: target reuses player's own atlas (which has the
-- decorative corner point target's own atlas lacks), mirrored via
-- SetTexture+SetTexCoord -- SetAtlas can't flip on its own.
expect(target._ktForeverPortraitArt.atlas, nil, "target art no longer uses plain SetAtlas")
expect(target._ktForeverPortraitArt.texture, "Interface\\Fake\\StockArt", "target art resolves to player's real sheet file")
expect(target._ktForeverPortraitArt.texCoord[1], 0.9, "target art texcoord left/right swapped (mirrored)")
expect(target._ktForeverPortraitArt.texCoord[2], 0.1, "target art texcoord left/right swapped (mirrored)")

-- Target is the exact mirror: keep the left/outer edge fixed and extend both
-- bars plus their masks to the right, underneath the modern classification ring.
local targetBaseHealthX = target.Health.points[1][4]
local targetBasePowerX = target.Power.points[1][4]
target._ktRingHugShift = 6
expect(KT.VisualThemes:ApplyForeverUnitFrameArt(target, target.Portrait.backdrop, "target"), true,
    "target Rare/Elite bar extension apply")
near(target.Health.points[1][4], targetBaseHealthX, "target Rare/Elite health outer edge stays fixed")
near(target.Power.points[1][4], targetBasePowerX, "target Rare/Elite power outer edge stays fixed")
near(target.Health:GetWidth(), 124 * targetScale + 6, "target Rare/Elite health width grows")
near(target.Power:GetWidth(), 124 * targetScale + 6, "target Rare/Elite power width grows")
near(target.Power._ktForeverMask:GetWidth(), 132 * targetScale + 6,
    "target Rare/Elite power mask grows with bar")

-- Retail uses each unit's real native mask, seated exactly on the portrait
-- with no generic 5px expansion. Neither MaskTexture is ever mirrored.
mockRenderedTheme = "retail"
local retailPlayer = MakeUnitFrame()
expect(KT.VisualThemes:ApplyForeverUnitFrameArt(retailPlayer, retailPlayer.Portrait.backdrop, "player"), true, "retail player apply")
expect(retailPlayer.Portrait.backdrop._shapeMask.texture, "Interface\\Fake\\PlayerPortraitMask", "retail player uses real portrait mask file")
expect(retailPlayer.Portrait.backdrop._shapeMask.texCoord[1], 0.2, "retail player mask remains unmirrored")
expect(retailPlayer.Portrait.backdrop._shapeMask.texCoord[2], 0.8, "retail player mask right texcoord")
near(retailPlayer.Portrait.backdrop._ktStockPortraitMaskExpand, 0, "retail player mask does not extend above frame art")
near(retailPlayer.Portrait.backdrop._shapeMask.points[1][4], 0, "retail player mask top-left x is flush")
near(retailPlayer.Portrait.backdrop._shapeMask.points[1][5], 0, "retail player mask top-left y is flush")

-- Explicit user correction: Retail's target no longer has its own native
-- geometry/atlas -- it mirrors player's atlas exactly like Forever's target
-- does (RETAIL_FRAME_GEOMETRY and the separate "-Type" strip art were both
-- removed), so the override substitutes the real Retail pixels for that
-- same shared atlas name, and the mask/geometry expectations match
-- Forever's target, not a target-native box.
local retailTarget = MakeUnitFrame()
expect(KT.VisualThemes:ApplyForeverUnitFrameArt(retailTarget, retailTarget.Portrait.backdrop, "target"), true, "retail target apply")
expect(retailTarget.Portrait.backdrop._shapeMask.texture, "Interface\\AddOns\\KullThranUI\\Libraries\\texture\\media\\portraits\\circle_mask.tga",
    "retail target falls back to the plain round mask (never mirrored)")
expect(retailTarget.Portrait.backdrop._shapeMask.texCoord[1], 0, "retail target mask texcoord reset left")
expect(retailTarget.Portrait.backdrop._shapeMask.texCoord[2], 1, "retail target mask texcoord reset right")
near(retailTarget.Portrait.backdrop._ktStockPortraitMaskExpand, 0, "retail target mask does not extend above frame art")
near(retailTarget.Portrait.backdrop.points[1][4], -24 * targetScale, "retail target portrait x (mirrored player values)")
near(retailTarget.Portrait.backdrop.points[1][5], -19 * targetScale, "retail target portrait y (mirrored player values)")
near(retailTarget.Health:GetWidth(), 124 * targetScale, "retail target health width (mirrored player values)")
near(retailTarget.Power:GetWidth(), 124 * targetScale, "retail target power width (mirrored player values)")
expect(retailTarget.Health._ktForeverMask.atlas, "UI-HUD-UnitFrame-Player-PortraitOn-Bar-Health-Mask", "retail target reuses player's health mask")
expect(retailTarget.Power._ktForeverMask.atlas, "UI-HUD-UnitFrame-Player-PortraitOn-Bar-Mana-Mask", "retail target reuses player's power mask")
near(retailTarget.LeftText.points[1][4], 48 * targetScale, "retail target name x (mirrored player values)")
near(retailTarget.LeftText.points[1][5], -27 * targetScale, "retail target name y (mirrored player values)")
expect(retailTarget._ktRetailTargetTypeArt, nil, "retail target no longer draws a separate type-strip art (removed, never verified)")
expect(retailTarget._ktForeverPortraitArt.atlas, nil, "retail target raw art does not use remapped SetAtlas")
expect(retailTarget._ktForeverPortraitArt.texture, 4631591, "retail target uses the real Retail unit-frame sheet (same as player's)")
near(retailTarget._ktForeverPortraitArt:GetWidth(), 198 * targetScale, "retail target atlas width (player's real atlas size)")
near(retailTarget._ktForeverPortraitArt:GetHeight(), 71 * targetScale, "retail target atlas height (player's real atlas size)")
near(retailTarget._ktForeverPortraitArt.texCoord[1], 199 / 1024, "retail target atlas left/right swapped (mirrored)")
near(retailTarget._ktForeverPortraitArt.texCoord[2], 1 / 1024, "retail target atlas left/right swapped (mirrored)")
near(retailTarget._ktForeverPortraitArt.texCoord[3], 87 / 512, "retail target atlas top coordinate")
near(retailTarget._ktForeverPortraitArt.texCoord[4], 158 / 512, "retail target atlas bottom coordinate")
expect(#retailTarget.Portrait.backdrop._2d.points, 0, "retail target leaves the live portrait coordinates untouched")
KT.VisualThemes:ClearForeverUnitFrameArt(retailTarget)
expect(retailTarget._ktForeverPortraitArt.shown, false, "retail target art clears normally")
mockRenderedTheme = "classic"
local classic = MakeUnitFrame()
classic:SetSize(282, 52) -- attached KUI width includes its portrait
classic.Health:SetSize(230, 46)
classic.Portrait.backdrop._shapeBorderTex = NewRegion(classic.Portrait.backdrop)
expect(KT.VisualThemes:ApplyClassicUnitFrameArt(classic, classic.Portrait.backdrop, "player"), true, "classic apply")
local classicScale = 1
expect(classic._ktClassicArtHost:GetFrameStrata(), "LOW", "classic art follows bar strata")
expect(classic._ktClassicArtHost:GetFrameLevel(), 4, "classic art above bars")
expect(classic.Portrait.backdrop:GetFrameLevel(), 1, "classic portrait below bars")
expect(classic.Portrait.backdrop._ktStockPortraitAnchor, true, "classic portrait owns its anchor")
expect(classic.Portrait.backdrop._shapeBorderTex.shown, false, "classic hides KUI circular portrait border")
near(classic:GetWidth(), 232, "classic native width normalization")
near(classic:GetHeight(), 100 * classicScale, "classic box height")
near(classic._ktClassicPortraitArt:GetWidth(), 232 * classicScale, "classic art width")
near(classic._ktClassicPortraitArt:GetHeight(), 100 * classicScale, "classic art height")
near(classic._ktClassicPortraitArt.texCoord[1], 1, "classic player art left texcoord")
near(classic._ktClassicPortraitArt.texCoord[2], 0.09375, "classic player art right texcoord")
near(classic.Health:GetWidth(), 119 * classicScale, "classic health width")
near(classic.Power:GetWidth(), 119 * classicScale, "classic power width")
near(classic.Castbar:GetParent():GetWidth(), 119 * classicScale, "classic castbar matches real power width")
near(classic.Castbar:GetParent():GetHeight(), 12 * classicScale, "classic castbar matches real power height (slender, not KUI's generic thickness)")
expect(classic.Castbar:GetParent().points[1][2], classic.Power, "classic castbar re-anchored directly to Power (not via the old healthOff formula)")
near(classic.Castbar:GetParent()._bgTex.colorTexture[1], 0.20, "classic castbar gets its own bronze background")
near(classic.Castbar:GetParent()._ppBorders[1].colorTexture[1], 0.92, "classic castbar gets its own bronze border")
near(classic.LeftText.points[1][5], 19 * classicScale, "classic name y")
near(classic.Portrait.backdrop.points[1][4], 42 * classicScale, "classic player portrait x")
near(classic.Portrait.backdrop.points[1][5], -12 * classicScale, "classic player portrait y")
near(classic.Portrait.backdrop:GetWidth(), 64 * classicScale, "classic player portrait fits the stock aperture")
near(classic.Health.points[1][4], 106 * classicScale, "classic health x")
near(classic.Health.points[1][5], -41 * classicScale, "classic health y")
near(classic.Buffs.points[1][4], 116 * classicScale, "classic player buffs align with the name tab")
local _, classicLeftFontSize = classic.LeftText:GetFont()
near(classicLeftFontSize, 12 * classicScale * 0.65, "classic LeftText font capped to its real 12px-tall bar")
expect(classic.LeftText:GetParent(), classic._ktClassicArtHost, "classic name reparented off Health's clipped hierarchy")

local classicTarget = MakeUnitFrame()
classicTarget:SetSize(282, 52)
classicTarget.Health:SetSize(230, 46)
expect(KT.VisualThemes:ApplyClassicUnitFrameArt(classicTarget, classicTarget.Portrait.backdrop, "target"), true, "classic target apply")
near(classicTarget._ktClassicPortraitArt:GetWidth(), 232, "classic target art width")
near(classicTarget._ktClassicPortraitArt:GetHeight(), 100, "classic target art height")
near(classicTarget._ktClassicPortraitArt.texCoord[1], 0.09375, "classic target art left texcoord")
near(classicTarget._ktClassicPortraitArt.texCoord[2], 1, "classic target art right texcoord")
expect(classicTarget.Portrait.backdrop.points[1][1], "TOPRIGHT", "classic target portrait point")
near(classicTarget.Portrait.backdrop.points[1][4], -42, "classic target portrait x")
near(classicTarget.Portrait.backdrop:GetWidth(), 64, "classic target portrait fits the stock aperture")
near(classicTarget.Health.points[1][4], 7, "classic target health x")
near(classicTarget.Health.points[1][5], -41, "classic target health y")
near(classicTarget.LeftText.points[1][4], -50, "classic target name x")
near(classicTarget.LeftText.points[1][5], 19, "classic target name y")
near(classicTarget.Buffs.points[1][4], 16, "classic target buffs align with the name tab")

-- ApplyClassicFrameArt clears stale Forever surfaces after seating Classic.
-- That cleanup must not release Classic's stock portrait ownership, otherwise
-- KUI's next circular refresh reanchors the portrait and restores its ring.
KT.VisualThemes:ClearForeverUnitFrameArt(classic)
expect(classic.Portrait.backdrop._ktStockPortraitAnchor, true,
    "clearing Forever preserves Classic stock portrait ownership")
expect(classic.Portrait.backdrop._shapeBorderTex.shown, false,
    "clearing Forever does not restore KUI circular portrait border")
near(classic.Portrait.backdrop.points[1][4], 42,
    "clearing Forever preserves Classic portrait position")

KT.VisualThemes:ClearForeverUnitFrameArt(player)
expect(player._ktForeverPortraitArt.shown, false, "clear art")
expect(player.Health._ktForeverMask.shown, false, "clear health mask")
expect(player.Health.fill.masks[player.Health._ktForeverMask], nil, "detach health mask")
expect(player.Portrait.backdrop._ktStockPortraitAnchor, nil, "clear stock portrait anchor")

print("theme_client_assets: ok")
