local addonName, ns = ...
local KT = LibStub("AceAddon-3.0"):GetAddon("KullThranUI")
KT.VisualThemes = KT.VisualThemes or {}

-- TEMPORARY debug tool: /ktdebug opens a floating, draggable window with
-- selectable text dumping the CURRENT live state of the player/target
-- frames (not hooked into any apply function -- a chat print and an
-- on-screen marker triggered from inside ApplyForeverUnitFrameArt were both
-- tried first and neither ever appeared, which is itself a real finding:
-- either that code path isn't running at all on this client, or something
-- about this client swallows output from inside it). This reads global
-- frame state directly, independent of whether that function ever ran, so
-- it can't be silenced the same way. Delete this whole block (down to
-- SlashCmdList) once the issue is diagnosed -- not meant to ship on.
local function KTDebugDumpFrame(frame, label)
    if type(frame) ~= "table" then
        return label .. ": frame not found (wrong global name?)\n"
    end
    local health = frame.Health
    return string.format(
        "%s: LeftText=%s RightText=%s CenterText=%s Buffs=%s\n" ..
        "  _ktStockNameText=%s _ktForeverLayoutActive=%s _ktClassicLayoutActive=%s\n" ..
        "  Health=%s (%sx%s) frame=%sx%s\n",
        label,
        tostring(frame.LeftText ~= nil), tostring(frame.RightText ~= nil),
        tostring(frame.CenterText ~= nil), tostring(frame.Buffs ~= nil),
        tostring(frame._ktStockNameText), tostring(frame._ktForeverLayoutActive),
        tostring(frame._ktClassicLayoutActive),
        tostring(health ~= nil),
        tostring(health and health.GetWidth and health:GetWidth()),
        tostring(health and health.GetHeight and health:GetHeight()),
        tostring(frame.GetWidth and frame:GetWidth()),
        tostring(frame.GetHeight and frame:GetHeight())
    )
end


SLASH_KTFOREVERDEBUG1 = "/ktdebug"
SlashCmdList["KTFOREVERDEBUG"] = function()
    -- Printed to normal chat (one message per line) instead of a custom
    -- window, so it lands in KullThranUI_Chat's own history and can be
    -- grabbed with its existing "Copy Chat" dialog, which the user already
    -- has and prefers over a bespoke EditBox.
    local text = KTDebugDumpFrame(_G.KullThranUI_UF_Player, "Player")
        .. KTDebugDumpFrame(_G.KullThranUI_UF_Target, "Target")
    for line in text:gmatch("[^\n]+") do
        print(line)
    end
end

--[[
    ThemeClientAssets.lua

    Shared rendering helpers that draw REAL per-client texture/atlas art onto
    KullThranUI's own custom-built UnitFrame widgets. Rendering TOOLS only --
    no saved-variable reads/writes, no opinion about which theme calls them.

    Classic uses the real fixed-path Blizzard sheet
    Interface\TargetingFrame\UI-TargetingFrame. Player and target use its
    verified 230x99 stock frame samples and exact 232x100 layout rectangles.
    Units without a verified full-frame entry retain the older provisional
    58x58 portrait-only crop; that fallback still requires in-game visual QA.
    Decorative art is seated on a dedicated child frame (see EnsureArtHost),
    because textures created directly on the outer frame render behind its
    child bars and portrait. Its strata and level are resolved from the live
    Health bar on every pass: portrait, art, bars and text therefore remain
    in one local stack even when UnitFrames changes the frame tree's strata.
]]

local PORTRAIT_FRAME_TEXTURE = [[Interface\TargetingFrame\UI-TargetingFrame]]

-- Real circular mask already shipped with (and already used elsewhere by)
-- this addon for its own "circular" portraitStyle -- see KUIUnitFrames.lua's
-- PORTRAIT_MASKS.circle. Reused here as-is so the classic/forever portrait
-- art reads as a clean circle regardless of what its underlying crop/atlas
-- actually contains, per explicit user request (round, not square).
local PORTRAIT_MASK_TEXTURE = [[Interface\AddOns\KullThranUI\Libraries\texture\media\portraits\circle_mask.tga]]

-- Assumed source sheet dimensions, in pixels. See derivation note above.
local PORTRAIT_ART_SHEET_WIDTH = 256
local PORTRAIT_ART_SHEET_HEIGHT = 128

-- Assumed portrait/frame ring crop, in source-sheet pixels, top-left corner.
local PORTRAIT_ART_CROP_W = 58
local PORTRAIT_ART_CROP_H = 58

-- Texture-coordinate rectangle for the portrait/frame ring piece, as a 0..1
-- fraction of the sheet: { left, right, top, bottom }.
local PORTRAIT_ART_TEXCOORD = {
    0,
    PORTRAIT_ART_CROP_W / PORTRAIT_ART_SHEET_WIDTH,
    0,
    PORTRAIT_ART_CROP_H / PORTRAIT_ART_SHEET_HEIGHT,
}

local CLASSIC_FRAME_GEOMETRY = {
    player = {
        w = 232, h = 100,
        art = { l = 1, r = 0.1015625, t = 0.0078125, b = 0.78125, w = 230, h = 99, x = -18.5, y = -4 },
        portrait = { point = "TOPLEFT", x = 24, y = -16, size = 64 },
        health = { x = 90, y = 45, w = 119, h = 12 },
        power = { x = 90, y = 56, w = 119, h = 12 },
        name = { point = "CENTER", x = 34, y = 15, w = 100, justify = "CENTER" },
    },
    target = {
        w = 232, h = 100,
        art = { l = 0.1015625, r = 1, t = 0.0078125, b = 0.78125, w = 230, h = 99, x = 18.5, y = -4 },
        portrait = { point = "TOPRIGHT", x = -24, y = -16, size = 64 },
        health = { x = 23, y = 45, w = 119, h = 12 },
        power = { x = 23, y = 56, w = 119, h = 12 },
        name = { point = "CENTER", x = -34, y = 15, w = 100, justify = "CENTER" },
    },
}
--- Creates (once, cached on `frame[cacheKey]`) a child frame positioned to
--- fully cover `frame`. Its actual strata/level is resolved by
--- SyncArtLayers from the live Health bar; hardcoded strata are incorrect
--- here because UnitFrames can move the whole tree to another strata.
--- @param frame Frame the unit frame's outer frame (owns the cache)
--- @param cacheKey string the field name this host is cached under on `frame`
--- @return Frame|nil host
local function EnsureArtHost(frame, cacheKey)
    local host = frame[cacheKey]
    if host then return host end

    host = CreateFrame("Frame", nil, frame)
    host:SetAllPoints(frame)
    host:EnableMouse(false)
    host._kuiThemeArtHost = true
    frame[cacheKey] = host
    return host
end

--- Keeps the stock-art stack internally ordered without assuming a global
--- strata or an absolute frame level. The intended order is:
--- portrait -> frame art -> bars -> text. Classic's opaque window frame is
--- the one exception: its art belongs immediately above the bars.
local function SyncArtLayers(frame, host, artAboveBars)
    local health = frame and frame.Health
    if not (health and host) then return end

    local strata = (health.GetFrameStrata and health:GetFrameStrata())
        or (frame.GetFrameStrata and frame:GetFrameStrata())
        or "LOW"
    local healthLevel = (health.GetFrameLevel and health:GetFrameLevel()) or 2
    local power = frame.Power
    local powerLevel = (power and power.GetFrameLevel and power:GetFrameLevel()) or healthLevel
    local topBarLevel = math.max(healthLevel, powerLevel)
    local artLevel = artAboveBars and (topBarLevel + 1) or math.max(0, healthLevel - 1)

    host:SetFrameStrata(strata)
    host:SetFrameLevel(artLevel)

    local portrait = frame.Portrait and frame.Portrait.backdrop
    if portrait then
        portrait:SetFrameStrata(strata)
        portrait:SetFrameLevel(math.max(0, math.min(healthLevel, artLevel) - 1))
    end

    local textOverlay = frame._textOverlay
    if textOverlay then
        textOverlay:SetFrameStrata(strata)
        textOverlay:SetFrameLevel(math.max(topBarLevel + 12, artLevel + 1))
    end
end
--- Scales a health/power text FontString's font size by `scale`, from its
--- OWN unscaled base size (cached on the FontString the first time this
--- runs), never from its current size -- reapplying this on every render
--- pass must never compound (shrinking further each time), and the base
--- must survive `scale` changing between calls (e.g. the user adjusting
--- portrait size). Nil-safe; does nothing if `fs` has no font set yet.
local function ScaleStockBarText(fs, scale)
    if type(fs) ~= "table" or type(fs.GetFont) ~= "function" or type(fs.SetFont) ~= "function" then return end
    local path, currentSize, flags = fs:GetFont()
    if not path or not currentSize then return end
    local base = fs._ktStockBaseFontSize
    if not base then
        base = currentSize
        fs._ktStockBaseFontSize = base
    end
    fs:SetFont(path, base * scale, flags)
end

--- Shrinks a FontString's font size further, on top of whatever it already
--- is, only when its CURRENT rendered text actually overflows `maxWidth` --
--- e.g. a long character name that doesn't fit the real name tab's real
--- width even at the theme's normal uniform scale. Never grows text back;
--- a short name at the normal scale is left alone. Nil-safe/no-op if the
--- FontString has no text or font yet, or if it already fits.
local function FitTextToWidth(fs, maxWidth)
    if type(fs) ~= "table" or type(fs.GetStringWidth) ~= "function" then return end
    if type(fs.GetFont) ~= "function" or type(fs.SetFont) ~= "function" then return end
    if not maxWidth or maxWidth <= 0 then return end
    local width = fs:GetStringWidth()
    if not width or width <= 0 or width <= maxWidth then return end
    local path, size, flags = fs:GetFont()
    if not path or not size then return end
    fs:SetFont(path, math.max(6, size * (maxWidth / width)), flags)
end

local function ResolveStockScale(frame, geom)
    local width = frame.GetWidth and frame:GetWidth()
    local height = frame.GetHeight and frame:GetHeight()
    local desiredWidth = width

    -- KUI's attached layout adds the portrait width to the outer frame.
    -- Before the stock pass its aspect ratio therefore differs sharply from
    -- the stock box; in that state the configured Health width is the stable
    -- width control shared by attached, circular and portrait-free presets.
    local health = frame.Health
    local healthWidth = health and health.GetWidth and health:GetWidth()
    local ratio = (width and width > 0 and height) and (height / width) or nil
    local stockRatio = geom.h / geom.w
    if ratio and math.abs(ratio - stockRatio) > 0.05
        and healthWidth and healthWidth > 0 then
        desiredWidth = healthWidth
    end

    return (desiredWidth and desiredWidth > 0) and (desiredWidth / geom.w) or 1
end
--- Sizes and anchors `art` as a SQUARE centered on `unitRegion`, instead of
--- stretching it to whatever rect `unitRegion` happens to have. A portrait
--- ring/frame piece reads as distorted the moment its container isn't
--- exactly square, and `unitRegion` (a real unit frame's portrait container)
--- is not guaranteed to be -- forcing a square derived from its own height
--- (falling back to width if height isn't available) and centering on it is
--- robust regardless of the container's actual shape or any layout timing
--- around when this is first called.
--- @param art Texture the texture to size/anchor
--- @param unitRegion Frame|Region the region to center the square art on
local function SeatSquareArt(art, unitRegion)
    art:ClearAllPoints()
    local size = unitRegion.GetHeight and unitRegion:GetHeight()
    if not size or size <= 0 then
        size = (unitRegion.GetWidth and unitRegion:GetWidth()) or 0
    end
    if size and size > 0 then
        art:SetSize(size, size)
        art:SetPoint("CENTER", unitRegion, "CENTER", 0, 0)
    else
        -- unitRegion has no usable size yet (e.g. not laid out this pass) --
        -- fall back to the previous stretch-to-fill behavior rather than
        -- leaving art with a stale or zero size.
        art:SetAllPoints(unitRegion)
    end
end

local function SeatStockPortrait(unitRegion, frame, portrait, scale)
    unitRegion._ktStockPortraitAnchor = true
    unitRegion._ktStockPortraitMaskExpand = 5 * scale
    if unitRegion._shapeBorderTex then unitRegion._shapeBorderTex:Hide() end
    unitRegion:ClearAllPoints()
    unitRegion:SetPoint(portrait.point, frame, portrait.point,
        portrait.x * scale, portrait.y * scale)
    unitRegion:SetSize(portrait.size * scale, portrait.size * scale)
    if unitRegion._shapeMask then
        local expand = unitRegion._ktStockPortraitMaskExpand
        unitRegion._shapeMask:ClearAllPoints()
        unitRegion._shapeMask:SetPoint("TOPLEFT", unitRegion, "TOPLEFT", -expand, expand)
        unitRegion._shapeMask:SetPoint("BOTTOMRIGHT", unitRegion, "BOTTOMRIGHT", expand, -expand)
    end
end

local function ReleaseStockPortrait(frame)
    local backdrop = frame and frame.Portrait and frame.Portrait.backdrop
    if backdrop then backdrop._ktStockPortraitAnchor = nil end
end
--- Creates (once, cached on `host[cacheKey]`) a circular mask matching
--- PORTRAIT_MASK_TEXTURE and applies it to `art`, then keeps the mask
--- anchored to `art`'s current rect (SetAllPoints tracks `art` live, so this
--- is safe to call every refresh even after SeatSquareArt resizes `art`).
--- @param art Texture the texture to mask circular
--- @param host Frame the frame the mask texture is created on
--- @param cacheKey string the field name this mask is cached under on `host`
local function ApplyCircleMask(art, host, cacheKey)
    local mask = host[cacheKey]
    if not mask then
        mask = host:CreateMaskTexture()
        mask:SetTexture(PORTRAIT_MASK_TEXTURE, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
        host[cacheKey] = mask
        art:AddMaskTexture(mask)
    end
    mask:ClearAllPoints()
    mask:SetAllPoints(art)
end

--- Applies the Classic theme's verified player/target stock box from the
--- real UI-TargetingFrame sheet. The outer box, portrait, health, power and
--- name all share one uniform scale; KUI keeps ownership of bar fills and
--- gameplay behavior. Units without verified full geometry retain the older
--- portrait-only fallback.
--- @param frame Frame the unit frame's outer frame
--- @param unitRegion Frame|Region the portrait region
--- @param unit string|nil unit key
function KT.VisualThemes:ApplyClassicUnitFrameArt(frame, unitRegion, unit)
    if type(frame) ~= "table" or type(frame.CreateTexture) ~= "function" then return end
    if type(unitRegion) ~= "table" then return end

    local host = EnsureArtHost(frame, "_ktClassicArtHost")
    if not host then return end

    local geom = unit and CLASSIC_FRAME_GEOMETRY[unit]
    if not geom then
        -- Verified full-frame geometry currently exists only for player and
        -- target. Other units keep the earlier portrait-only fallback.
        SyncArtLayers(frame, host, true)
        local art = frame._ktClassicPortraitArt
        if not art then
            art = host:CreateTexture(nil, "OVERLAY")
            art:SetTexture(PORTRAIT_FRAME_TEXTURE)
            art:SetTexCoord(PORTRAIT_ART_TEXCOORD[1], PORTRAIT_ART_TEXCOORD[2], PORTRAIT_ART_TEXCOORD[3], PORTRAIT_ART_TEXCOORD[4])
            frame._ktClassicPortraitArt = art
        end
        SeatSquareArt(art, unitRegion)
        ApplyCircleMask(art, host, "_ktClassicPortraitMask")
        art:Show()
        return
    end

    local scale = ResolveStockScale(frame, geom)

    frame:SetSize(geom.w * scale, geom.h * scale)
    SyncArtLayers(frame, host, true)

    local art = frame._ktClassicPortraitArt
    if not art then
        art = host:CreateTexture(nil, "BACKGROUND")
        frame._ktClassicPortraitArt = art
    end
    local artGeom = geom.art
    art:SetTexture(PORTRAIT_FRAME_TEXTURE)
    art:SetTexCoord(artGeom.l, artGeom.r, artGeom.t, artGeom.b)
    art:ClearAllPoints()
    art:SetPoint("CENTER", frame, "CENTER", artGeom.x * scale, artGeom.y * scale)
    art:SetSize(artGeom.w * scale, artGeom.h * scale)
    art:Show()

    local portrait = geom.portrait
    SeatStockPortrait(unitRegion, frame, portrait, scale)

    local health = frame.Health
    if health then
        health:ClearAllPoints()
        health:SetPoint("TOPLEFT", frame, "TOPLEFT",
            geom.health.x * scale, -geom.health.y * scale)
        health:SetSize(geom.health.w * scale, geom.health.h * scale)
        health._xOffset = geom.health.x * scale
        health._rightInset = (geom.w - geom.health.x - geom.health.w) * scale
        health._topOffset = geom.health.y * scale
        local absorb = frame.HealthPrediction and frame.HealthPrediction.damageAbsorb
        if absorb and absorb.SetSize then
            absorb:SetSize(geom.health.w * scale, geom.health.h * scale)
        end
    end

    local power = frame.Power
    if power then
        power:ClearAllPoints()
        power:SetPoint("TOPLEFT", frame, "TOPLEFT",
            geom.power.x * scale, -geom.power.y * scale)
        power:SetSize(geom.power.w * scale, geom.power.h * scale)
    end

    -- Whichever FontString actually holds "name" content is a per-profile
    -- choice resolved by KUIUnitFrames.lua (which has access to `settings`)
    -- and handed over via frame._ktStockNameText -- falling back to
    -- frame.LeftText, KUI's own default assignment, when that isn't set
    -- (e.g. in the test harness, or before KUIUnitFrames.lua resolves it).
    local nameText = frame._ktStockNameText or frame.LeftText
    if nameText and geom.name then
        nameText:ClearAllPoints()
        nameText:SetPoint(geom.name.point, frame, geom.name.point,
            geom.name.x * scale, geom.name.y * scale)
        if nameText.SetWidth then nameText:SetWidth(geom.name.w * scale) end
        if nameText.SetJustifyH then nameText:SetJustifyH(geom.name.justify) end
    end

    ScaleStockBarText(frame.LeftText, scale)
    ScaleStockBarText(frame.RightText, scale)
    ScaleStockBarText(frame.CenterText, scale)
    frame._ktClassicLayoutActive = true
    return true
end
--- Hides (does not destroy) the Classic portrait/frame art created by
--- ApplyClassicUnitFrameArt, if any. Nil-safe if it was never created.
--- @param frame Frame|Region the unit frame passed to ApplyClassicUnitFrameArt
function KT.VisualThemes:ClearClassicUnitFrameArt(frame)
    if type(frame) ~= "table" then return end
    local art = frame._ktClassicPortraitArt
    if art then
        art:Hide()
    end
    ReleaseStockPortrait(frame)
    frame._ktClassicLayoutActive = nil
end

--[[
    Forever stock UnitFrame art.

    The atlas is the visible artwork inside a 232x100 layout box; it is not
    itself the box. Player and target use fixed portrait, health, power and
    name rectangles in that coordinate space. One uniform scale is applied
    to all of them, the real atlas is centred at its native visible size, and
    the stock masks shape KUI's existing bar textures without replacing their
    colors or fills.

    Only player and target have verified geometry. Other units deliberately
    keep KUI's normal rendering instead of receiving guessed artwork.
]]

local FOREVER_FRAME_GEOMETRY = {
    player = {
        w = 232, h = 100,
        art = "UI-HUD-UnitFrame-Player-PortraitOn",
        portrait = { point = "TOPLEFT", x = 24, y = -19, size = 60 },
        health = {
            x = 85, y = 40, w = 124, h = 20,
            mask = "UI-HUD-UnitFrame-Player-PortraitOn-Bar-Health-Mask",
            mx = -2, my = 6,
        },
        power = {
            x = 85, y = 61, w = 124, h = 10,
            mask = "UI-HUD-UnitFrame-Player-PortraitOn-Bar-Mana-Mask",
            mx = -2, my = 2,
        },
        name = { x = 88, y = -27, w = 96, h = 14 },
    },
    target = {
        w = 232, h = 100,
        art = "UI-HUD-UnitFrame-Target-PortraitOn",
        -- EXPERIMENTAL, unverified: live QA reported target's box art not
        -- filling the portrait ring and not reading as mirrored the other
        -- way. The code never manually flips either unit -- it trusts each
        -- real atlas to already be correctly mirrored (this is how
        -- EllesmereUI itself uses these same two atlases, unflipped). If
        -- Forever's client substitutes its own bronze art under this name
        -- without keeping a distinct, correctly-mirrored target variant,
        -- forcing a flip here could fix it -- or, if Forever's substituted
        -- art is already mirrored, this would flip it the WRONG way. Only
        -- in-game verification can tell which; revert this one field to
        -- `false` if the result looks worse, not better.
        mirror = true,
        portrait = { point = "TOPRIGHT", x = -26, y = -19, size = 58 },
        health = {
            x = 23, y = 40, w = 126, h = 20,
            mask = "UI-HUD-UnitFrame-Target-PortraitOn-Bar-Health-Mask",
            mx = -1, my = 6,
        },
        power = {
            x = 23, y = 61, w = 134, h = 10,
            mask = "UI-HUD-UnitFrame-Target-PortraitOn-Bar-Mana-Mask",
            mx = -61, my = 3,
        },
        name = { x = 30, y = -26, w = 120, h = 14 },
    },
}

local function UnsnapTexture(texture)
    if not texture then return end
    if texture.SetSnapToPixelGrid then texture:SetSnapToPixelGrid(false) end
    if texture.SetTexelSnappingBias then texture:SetTexelSnappingBias(0) end
end

local function SeatMaskOnTexture(texture, mask)
    if not (texture and mask and texture.AddMaskTexture) then return end
    if texture.RemoveMaskTexture then
        pcall(texture.RemoveMaskTexture, texture, mask)
    end
    texture:AddMaskTexture(mask)
end

local function ApplyForeverBarMask(bar, geom, scale)
    if not (bar and geom and geom.mask and C_Texture and C_Texture.GetAtlasInfo) then return end
    local info = C_Texture.GetAtlasInfo(geom.mask)
    if not info then return end

    local mask = bar._ktForeverMask
    if not mask then
        mask = bar:CreateMaskTexture()
        bar._ktForeverMask = mask
    end
    mask:SetAtlas(geom.mask, true)
    mask:Show()
    UnsnapTexture(mask)
    mask:ClearAllPoints()
    mask:SetPoint("TOPLEFT", bar, "TOPLEFT", (geom.mx or 0) * scale, (geom.my or 0) * scale)
    if info.width and info.height then
        mask:SetSize(info.width * scale, info.height * scale)
    end

    SeatMaskOnTexture(bar.GetStatusBarTexture and bar:GetStatusBarTexture(), mask)
    SeatMaskOnTexture(bar.bg, mask)
end

local function ResizeHealthPrediction(frame, width, height)
    local absorb = frame.HealthPrediction and frame.HealthPrediction.damageAbsorb
    if not absorb then return end
    if absorb.SetSize then absorb:SetSize(width, height) end
    local mask = frame.Health and frame.Health._ktForeverMask
    if mask and absorb.GetStatusBarTexture then
        SeatMaskOnTexture(absorb:GetStatusBarTexture(), mask)
    end
end
--- Applies the Forever theme's real per-client UnitFrame art: creates
--- (once, cached on `frame`) the real player/target frame-art box texture,
--- scaled and anchored so its own known internal portrait sub-rect lines up
--- with `unitRegion`'s real on-screen position and size, gated on both
--- `unit` having a known real geometry entry and the atlas name actually
--- resolving in this client. Falls back to ClearForeverUnitFrameArt (no
--- art -- today's already-shipped fixed-accent-color look) for any other
--- unit or when the atlas doesn't resolve, rather than guessing.
--- @param frame Frame the unit frame's outer frame (owns the cache)
--- @param unitRegion Frame|Region the real portrait region to align the box's internal portrait to
--- @param unit string|nil the unit key ("player"/"target"); any other value clears
--- @return boolean|nil true when the real box art was actually drawn (the caller can use this to hide its own generic border, now redundant); nil otherwise
function KT.VisualThemes:ApplyForeverUnitFrameArt(frame, unitRegion, unit)
    if type(frame) ~= "table" or type(frame.CreateTexture) ~= "function" then return end
    if type(unitRegion) ~= "table" then return end

    local geom = unit and FOREVER_FRAME_GEOMETRY[unit]
    if not geom then
        self:ClearForeverUnitFrameArt(frame)
        return
    end

    local info = C_Texture and C_Texture.GetAtlasInfo and C_Texture.GetAtlasInfo(geom.art)
    if not info then
        self:ClearForeverUnitFrameArt(frame)
        return
    end

    -- The same stock-box scale resolver is shared with Classic, so attached
    -- and circular layouts interpret the configured width identically.
    local scale = ResolveStockScale(frame, geom)

    frame:SetSize(geom.w * scale, geom.h * scale)

    local host = EnsureArtHost(frame, "_ktForeverArtHost")
    if not host then return end
    SyncArtLayers(frame, host, false)

    local art = frame._ktForeverPortraitArt
    if not art then
        art = host:CreateTexture(nil, "BACKGROUND")
        UnsnapTexture(art)
        frame._ktForeverPortraitArt = art
    end
    -- SetAtlas alone can't be flipped (its own SetTexCoord addresses the
    -- atlas's normalized sub-rect, not the sheet -- see EllesmereUI's own
    -- documented reason for resolving to the real file first). geom.mirror
    -- is EXPERIMENTAL (see the comment on FOREVER_FRAME_GEOMETRY.target).
    if geom.mirror and info.leftTexCoord and info.rightTexCoord
        and info.topTexCoord and info.bottomTexCoord and (info.file or info.filename) then
        art:SetTexture(info.file or info.filename)
        art:SetTexCoord(info.rightTexCoord, info.leftTexCoord, info.topTexCoord, info.bottomTexCoord)
    else
        art:SetAtlas(geom.art)
    end
    art:ClearAllPoints()
    art:SetPoint("CENTER", host, "CENTER", 0, 0)
    art:SetSize((info.width or geom.w) * scale, (info.height or geom.h) * scale)
    art:Show()

    -- The outer frame is now the stable stock box. Portrait and bars are all
    -- siblings anchored to that same box, so no element depends on Health
    -- while Health is being repositioned (the previous portrait -> art ->
    -- health feedback loop could drift on every refresh).
    local portrait = geom.portrait
    SeatStockPortrait(unitRegion, frame, portrait, scale)

    local health = frame.Health
    if geom.health and type(health) == "table" and health.ClearAllPoints then
        health:ClearAllPoints()
        health:SetPoint("TOPLEFT", frame, "TOPLEFT",
            geom.health.x * scale, -geom.health.y * scale)
        health:SetSize(geom.health.w * scale, geom.health.h * scale)
        health._xOffset = geom.health.x * scale
        health._rightInset = (geom.w - geom.health.x - geom.health.w) * scale
        health._topOffset = geom.health.y * scale
        ApplyForeverBarMask(health, geom.health, scale)
        ResizeHealthPrediction(frame, geom.health.w * scale, geom.health.h * scale)
    end

    local power = frame.Power
    if geom.power and type(power) == "table" and power.ClearAllPoints then
        power:ClearAllPoints()
        power:SetPoint("TOPLEFT", frame, "TOPLEFT",
            geom.power.x * scale, -geom.power.y * scale)
        power:SetSize(geom.power.w * scale, geom.power.h * scale)
        ApplyForeverBarMask(power, geom.power, scale)
    end

    -- Whichever FontString actually holds "name" content is a per-profile
    -- choice resolved by KUIUnitFrames.lua (which has access to `settings`)
    -- and handed over via frame._ktStockNameText -- falling back to
    -- frame.LeftText, KUI's own default assignment, when that isn't set
    -- (e.g. in the test harness, or before KUIUnitFrames.lua resolves it).
    local nameText = frame._ktStockNameText or frame.LeftText
    if geom.name and type(nameText) == "table" and nameText.ClearAllPoints then
        local point = geom.name.point or "TOPLEFT"
        nameText:ClearAllPoints()
        nameText:SetPoint(point, frame, point,
            geom.name.x * scale, geom.name.y * scale)
        if nameText.SetWidth then nameText:SetWidth(geom.name.w * scale) end
        if nameText.SetJustifyH then nameText:SetJustifyH(geom.name.justify or "LEFT") end
    end

    ScaleStockBarText(frame.LeftText, scale)
    ScaleStockBarText(frame.RightText, scale)
    ScaleStockBarText(frame.CenterText, scale)
    -- Explicit user rule: a name long enough to overflow the real tab's
    -- real width shrinks further, on top of the uniform theme scale above,
    -- rather than spilling past the tab or overlapping the buffs below it.
    -- Must target the SAME object just positioned in the tab (`nameText`,
    -- which may be RightText/CenterText, not always LeftText) -- fitting
    -- frame.LeftText unconditionally here was a real bug when the two
    -- differ (that FontString was never moved, so fitting it did nothing
    -- useful and left the actual tab text unfitted).
    if geom.name then
        FitTextToWidth(nameText, geom.name.w * scale)
    end

    -- Buffs move into the same real name tab, per explicit user request --
    -- Forever-only for now (Classic/Retail keep their existing Health-bar-
    -- relative anchor untouched). Anchored so the icon ROW's bottom edge
    -- sits on the tab's own top edge, growing upward from it -- the tab
    -- itself is the name's real rect, not the buffs' rect, so buffs sit
    -- immediately above it rather than overlapping the name text.
    local buffs = frame.Buffs
    if geom.name and type(buffs) == "table" and buffs.ClearAllPoints then
        local tabW = geom.name.w * scale
        local iconSize = math.max(8, geom.name.h * scale)
        local gap = buffs.spacing or 1
        buffs:ClearAllPoints()
        buffs:SetPoint("BOTTOMLEFT", frame, "TOPLEFT",
            geom.name.x * scale, geom.name.y * scale)
        buffs:SetSize(tabW, iconSize)
        buffs.size = iconSize
        buffs.spacing = gap
        buffs["size-x"] = math.max(1, math.floor((tabW + gap) / (iconSize + gap)))
        if buffs.ForceUpdate then buffs:ForceUpdate() end
    end

    frame._ktForeverLayoutActive = true
    return true
end
--- Hides (does not destroy) the Forever frame-art box created by
--- ApplyForeverUnitFrameArt, if any. Nil-safe if it was never created.
--- @param frame Frame|Region the unit frame passed to ApplyForeverUnitFrameArt
function KT.VisualThemes:ClearForeverUnitFrameArt(frame)
    if type(frame) ~= "table" then return end
    local art = frame._ktForeverPortraitArt
    if art then art:Hide() end

    local function ClearBarMask(bar)
        local mask = bar and bar._ktForeverMask
        if not mask then return end
        local fill = bar.GetStatusBarTexture and bar:GetStatusBarTexture()
        if fill and fill.RemoveMaskTexture then pcall(fill.RemoveMaskTexture, fill, mask) end
        if bar.bg and bar.bg.RemoveMaskTexture then pcall(bar.bg.RemoveMaskTexture, bar.bg, mask) end
        mask:Hide()
    end

    ClearBarMask(frame.Health)
    ClearBarMask(frame.Power)
    local absorb = frame.HealthPrediction and frame.HealthPrediction.damageAbsorb
    local healthMask = frame.Health and frame.Health._ktForeverMask
    local absorbFill = absorb and absorb.GetStatusBarTexture and absorb:GetStatusBarTexture()
    if healthMask and absorbFill and absorbFill.RemoveMaskTexture then
        pcall(absorbFill.RemoveMaskTexture, absorbFill, healthMask)
    end
    ReleaseStockPortrait(frame)
    frame._ktForeverLayoutActive = nil
end
