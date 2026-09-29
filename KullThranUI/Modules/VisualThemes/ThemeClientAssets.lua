local addonName, ns = ...
local KT = LibStub("AceAddon-3.0"):GetAddon("KullThranUI")
KT.VisualThemes = KT.VisualThemes or {}

--[[
    ThemeClientAssets.lua

    Shared rendering helpers that draw REAL per-client texture/atlas art onto
    KullThranUI's own custom-built UnitFrame widgets. Rendering TOOLS only --
    no saved-variable reads/writes, no opinion about which theme calls them.

    Classic: a real, fixed-path (non-atlas) Blizzard-shipped sheet,
    Interface\TargetingFrame\UI-TargetingFrame, sliced for a portrait/frame
    ring. This is not an atlas name, so it carries none of the
    atlas-substitution risk the Retail theme is blocked on.

    Texture-coordinate derivation for UI-TargetingFrame (PROVISIONAL -- see
    note below): this environment has no running WoW client, so the crop
    below could not be confirmed by eye, and it was derived independently
    (never by reusing another addon's own reverse-engineered pixel values for
    this file). UI-TargetingFrame is assumed to be a 256x128px sheet (the
    common size for this vintage of classic-era Blizzard UI texture sheets);
    the portrait/frame ring piece is assumed to occupy a square region in the
    sheet's top-left corner, sized 58x58px of that 256x128 sheet.
    OUTSTANDING MANUAL QA ITEM: both the assumed sheet dimensions and the
    crop are unverified. They must be checked in-game (apply this to a
    throwaway unit frame, look at it, adjust PORTRAIT_ART_* below if the
    piece looks stretched, cut off, or shows the wrong part of the sheet)
    before this is considered visually correct.

    Both this file's decorative pieces are seated on a dedicated child frame
    (see EnsureArtHost below), not directly on the caller's outer `frame` --
    a Frame's own textures always render behind its child frames, and the
    portrait/health/border widgets this art is meant to sit over are all
    child frames, so a texture created directly on the outer frame would be
    invisible underneath them. The host frame matches CreatePortrait's own
    backdrop STRATA ("MEDIUM") and clears its fixed LEVEL (50, set literally
    at creation in KUIUnitFrames.lua, not derived from the outer frame) with
    an equally fixed, higher level of its own -- a relative offset from the
    outer frame's own level was tried first and confirmed live, via /fstack,
    to sit BELOW that fixed 50 whenever the outer frame's own level is low,
    which let the portrait's own opaque background draw over this art and
    left only its square corners peeking out past the portrait's circular
    mask.
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

-- Strata/level this file's decorative hosts use to draw above the
-- Health/Portrait/border child frames. MEDIUM matches CreatePortrait's own
-- backdrop (KUIUnitFrames.lua: `backdrop:SetFrameStrata("MEDIUM")` /
-- `backdrop:SetFrameLevel(50)`, both fixed absolute values set at creation,
-- not derived from the outer frame) -- an EARLIER version of this file used
-- `frame:GetFrameLevel() + 20`, a RELATIVE offset, which in-game testing
-- showed lands below that fixed 50 whenever the outer frame's own level is
-- low (as confirmed live via /fstack: the art rendered, correctly sized and
-- anchored, but hidden behind the portrait's own opaque background/mask,
-- only its square corners peeking out past the portrait's circular mask).
-- ART_HOST_LEVEL is an absolute level for this same reason -- it must clear
-- Portrait's fixed 50, not just whatever the outer frame's own level is.
local ART_HOST_STRATA = "MEDIUM"
local ART_HOST_LEVEL = 60

--- Creates (once, cached on `frame[cacheKey]`) a child frame positioned to
--- fully cover `frame` and elevated to ART_HOST_STRATA/ART_HOST_LEVEL so
--- textures created on it draw above the outer frame's own child widgets,
--- including the portrait's own fixed-level-50 backdrop.
--- @param frame Frame the unit frame's outer frame (owns the cache)
--- @param cacheKey string the field name this host is cached under on `frame`
--- @return Frame|nil host
local function EnsureArtHost(frame, cacheKey)
    local host = frame[cacheKey]
    if host then return host end

    host = CreateFrame("Frame", nil, frame)
    host:SetAllPoints(frame)
    host:SetFrameStrata(ART_HOST_STRATA)
    host:SetFrameLevel(ART_HOST_LEVEL)
    frame[cacheKey] = host
    return host
end

--- Scales a health/power text FontString's font size by `scale`, from its
--- OWN unscaled base size (cached on the FontString the first time this
--- runs), never from its current size -- reapplying this on every render
--- pass must never compound (shrinking further each time), and the base
--- must survive `scale` changing between calls (e.g. the user adjusting
--- portrait size). Nil-safe; does nothing if `fs` has no font set yet.
local function ScaleForeverBarText(fs, scale)
    if type(fs) ~= "table" or type(fs.GetFont) ~= "function" or type(fs.SetFont) ~= "function" then return end
    local path, currentSize, flags = fs:GetFont()
    if not path or not currentSize then return end
    local base = fs._ktForeverBaseFontSize
    if not base then
        base = currentSize
        fs._ktForeverBaseFontSize = base
    end
    fs:SetFont(path, base * scale, flags)
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

--- Applies the Classic theme's real per-client UnitFrame art: creates (once,
--- cached on `frame`) a portrait/frame ring texture anchored to `unitRegion`
--- (the real portrait region -- pass `frame.Portrait.backdrop` when it
--- exists, falling back to `frame` only when no portrait region exists for
--- this unit) from the real UI-TargetingFrame sheet. Does not touch any
--- health-bar texture choice -- the `classic` theme's own seed already sets
--- a real, correct health bar texture, and retexturing it again here would
--- silently override whatever a user picks while `classic` is active. Safe
--- to call every refresh -- the ring texture is created once and
--- repositioned/shown on repeat calls, never recreated.
--- @param frame Frame the unit frame's outer frame (owns the cache)
--- @param unitRegion Frame|Region the real portrait region to frame
function KT.VisualThemes:ApplyClassicUnitFrameArt(frame, unitRegion)
    if type(frame) ~= "table" or type(frame.CreateTexture) ~= "function" then return end
    if type(unitRegion) ~= "table" then return end

    local host = EnsureArtHost(frame, "_ktClassicArtHost")
    if not host then return end

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
end

--[[
    Forever real UnitFrame art (see ESTUDIO log entries 33-37 for the full
    history -- 5 prior attempts at a "portrait ring" were all wrong, in two
    different ways, before this version):

    1-4. Earlier versions treated the atlas as if it were a small circular
       "portrait ring" -- forcing it into a square, using its raw native
       size, growing the portrait to match it, and a fudge-scaled version of
       that growth. All four were confirmed broken via live screenshots.
    5. The atlas name itself ("ui-hud-unitframe-player-portraiton") was
       never actually wrong -- it's a real, case-insensitive match for
       Blizzard's own `UI-HUD-UnitFrame-Player-PortraitOn`. What was wrong
       was the ASSUMPTION about its shape: this atlas is not a ring at all,
       it's the ENTIRE player-frame art box (232x100px native -- wide and
       short, not square), with the portrait/health-bar/power-bar each
       positioned at fixed offsets INSIDE that box. Fitting a 232x100 image
       into a small square portrait region necessarily produces a thin
       sliver -- confirmed exactly via a live screenshot.
    6. This version uses the real box geometry (FOREVER_FRAME_GEOMETRY
       below): real Blizzard-defined atlas names and their real native
       pixel offsets, both facts about the game client (not anyone's
       original work) identified by reading how these same real atlas
       names and offsets are consumed elsewhere for exactly this purpose,
       for technique/data only -- no code, comment, or identifier from that
       source is reused here. The player/target boxes are the only ones
       with confirmed real geometry; any other unit (focus, pet, boss) has
       no entry in the table and gets no art (ClearForeverUnitFrameArt),
       rather than guessing another wrong shape onto it.
    The box is scaled UNIFORMLY (never distorted) so its own internal
    portrait sub-rect lines up with `unitRegion`'s real on-screen position
    and size -- the ratio between `unitRegion`'s size and the box's known
    portrait sub-size IS the scale factor, applied to both the box's overall
    size and its anchor offset.
    Entry 38 adds the real health/power bar-track rectangles from the same
    real geometry table and re-anchors the frame's ACTUAL Health/Power
    StatusBars to sit inside them (same uniform scale as the box itself),
    after KUIUnitFrames.lua's own normal layout has already positioned them
    for this render pass -- never touching that shared computation itself,
    only re-anchoring its result for forever+player/target. Safe to do
    unconditionally on every apply because a theme switch in this addon
    always goes through a full ReloadUI (confirmed elsewhere in this
    codebase), so there is never a stale Forever-anchored bar left behind
    after switching away -- the next render pass recomputes it fresh before
    this function would run again. Bar-track atlas backgrounds themselves
    (the actual `-Bar-Health`/`-Bar-Mana` art) are still not drawn -- the
    bars are repositioned/resized onto the real rectangle, but keep KUI's
    own fill texture/mask, matching how Classic's health bar already keeps
    the user's own texture choice instead of being overridden.
]]
local FOREVER_FRAME_GEOMETRY = {
    player = {
        w = 232, h = 100,
        art = "UI-HUD-UnitFrame-Player-PortraitOn",
        portrait = { point = "TOPLEFT", x = 24, y = -19, size = 60 },
        health = { x = 85, y = 40, w = 124, h = 20 },
        power = { x = 85, y = 61, w = 124, h = 10 },
    },
    target = {
        w = 232, h = 100,
        art = "UI-HUD-UnitFrame-Target-PortraitOn",
        portrait = { point = "TOPRIGHT", x = -26, y = -19, size = 58 },
        health = { x = 23, y = 40, w = 126, h = 20 },
        power = { x = 23, y = 61, w = 134, h = 10 },
    },
}

--- Converts a geometry entry's `portrait` rect (given corner-relative, as
--- Blizzard's own reference data expresses it -- TOPLEFT for player,
--- TOPRIGHT for target) into its CENTER point in box-local coordinates
--- (measured from the box's own top-left, y increasing downward),
--- regardless of which corner it was expressed from. This is what lets the
--- box be anchored by matching centers instead of assuming a corner.
local function PortraitCenterInBox(geom)
    local p = geom.portrait
    local left = (p.point == "TOPRIGHT") and (geom.w + p.x - p.size) or p.x
    local top = -p.y
    return left + p.size / 2, top + p.size / 2
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

    local host = EnsureArtHost(frame, "_ktForeverArtHost")
    if not host then return end

    local art = frame._ktForeverPortraitArt
    if not art then
        art = host:CreateTexture(nil, "OVERLAY")
        frame._ktForeverPortraitArt = art
    end
    art:SetAtlas(geom.art)

    local targetSize = (unitRegion.GetHeight and unitRegion:GetHeight())
        or (unitRegion.GetWidth and unitRegion:GetWidth())
    local scale = (targetSize and targetSize > 0) and (targetSize / geom.portrait.size) or 1

    -- CENTER-to-CENTER anchoring, not point-to-point: KUI's own portrait can
    -- sit on either side of the frame, on top, attached or detached --
    -- anchoring by a hardcoded corner (assuming the portrait is always
    -- where Blizzard's own reference frame puts it) ignores wherever KUI's
    -- actual portrait really is, and the ring only wraps it by coincidence.
    -- Confirmed live: it did not wrap the portrait correctly. Aligning the
    -- box's own known internal portrait-center with unitRegion's real
    -- CENTER works for every side/attachment, since it never assumes which
    -- corner the portrait is anchored from.
    local portraitCenterX, portraitCenterY = PortraitCenterInBox(geom)
    local boxCenterX, boxCenterY = geom.w / 2, geom.h / 2

    art:ClearAllPoints()
    art:SetSize((info.width or geom.w) * scale, (info.height or geom.h) * scale)
    art:SetPoint("CENTER", unitRegion, "CENTER",
        (boxCenterX - portraitCenterX) * scale, (portraitCenterY - boxCenterY) * scale)
    art:Show()

    -- Re-anchor the REAL health/power bars onto the box's own real
    -- bar-track rectangle (same scale as the box itself), overriding the
    -- position KUIUnitFrames.lua's normal layout just gave them for this
    -- render pass. Only the anchor/size changes -- fill texture, color,
    -- and mask stay whatever the user (or the theme's own seed) chose.
    --
    -- Anchored to `frame`, NOT to `art` (or unitRegion): in some portrait
    -- layouts (portraitSide "top"/detached) KUIUnitFrames.lua itself anchors
    -- frame.Portrait.backdrop relative to frame.Health -- confirmed live via
    -- "Cannot anchor to a region dependent on it" (health -> art ->
    -- unitRegion(=Portrait.backdrop) -> health, a real cycle). `frame` is
    -- always a safe target -- it never depends on its own Health/Portrait
    -- children. `art`'s resolved on-screen position (read once via
    -- GetLeft/GetTop, not a live anchor dependency) supplies the same
    -- origin without creating a new dependency edge.
    local artLeft, artTop = art:GetLeft(), art:GetTop()
    local frameLeft, frameTop = frame.GetLeft and frame:GetLeft(), frame.GetTop and frame:GetTop()
    if artLeft and artTop and frameLeft and frameTop then
        local originX, originY = artLeft - frameLeft, artTop - frameTop
        local health = frame.Health
        if geom.health and type(health) == "table" and health.ClearAllPoints then
            health:ClearAllPoints()
            health:SetPoint("TOPLEFT", frame, "TOPLEFT",
                originX + geom.health.x * scale, originY - geom.health.y * scale)
            health:SetSize(geom.health.w * scale, geom.health.h * scale)
        end
        local power = frame.Power
        if geom.power and type(power) == "table" and power.ClearAllPoints then
            power:ClearAllPoints()
            power:SetPoint("TOPLEFT", frame, "TOPLEFT",
                originX + geom.power.x * scale, originY - geom.power.y * scale)
            power:SetSize(geom.power.w * scale, geom.power.h * scale)
        end

        -- The health bar's own name/value text (frame.LeftText/RightText/
        -- CenterText) tracks frame.Health's new size live -- textOverlay is
        -- SetAllPoints(frame.Health) -- but its FONT SIZE stays whatever the
        -- user configured for the bar's OLD, usually wider, width, and
        -- overlaps once the bar shrinks to the real bar-track's width.
        -- Confirmed via a live screenshot. Scaled down by the same factor.
        ScaleForeverBarText(frame.LeftText, scale)
        ScaleForeverBarText(frame.RightText, scale)
        ScaleForeverBarText(frame.CenterText, scale)
    end

    return true
end

--- Hides (does not destroy) the Forever frame-art box created by
--- ApplyForeverUnitFrameArt, if any. Nil-safe if it was never created.
--- @param frame Frame|Region the unit frame passed to ApplyForeverUnitFrameArt
function KT.VisualThemes:ClearForeverUnitFrameArt(frame)
    if type(frame) ~= "table" then return end
    local art = frame._ktForeverPortraitArt
    if art then
        art:Hide()
    end
end
