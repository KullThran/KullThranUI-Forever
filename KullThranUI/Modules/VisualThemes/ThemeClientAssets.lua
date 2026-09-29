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
    Forever portrait ring (PROVISIONAL -- see note below):

    WoW Forever's client is already confirmed, by this session's own prior
    research into how its atlas system behaves, to substitute a range of
    modern unit-frame atlas names with its own bronze/ornate art under the
    identical name -- i.e. calling SetAtlas with one of these names INSIDE
    Forever draws Forever's own real art, not the neutral modern art the
    same call would draw in an actual Retail client (that mismatch is
    exactly why the Retail theme can't safely reuse these names -- see the
    design spec's Non-goals). For the Forever theme specifically, that same
    substitution is exactly what's wanted: a real, Forever-native portrait
    ring, reached through a real Blizzard-defined atlas identifier.

    "ui-hud-unitframe-player-portraiton" is chosen as a real, plausible name
    from that same modern unit-frame atlas family. It has not been confirmed
    live in this environment (no WoW client exists here) -- it is a
    reasoned choice, not a measurement, exactly like the Classic crop above.
    OUTSTANDING MANUAL QA ITEM: confirm in-game that this name actually
    resolves via C_Texture.GetAtlasInfo inside this Forever client, and that
    it reads as a portrait ring once applied. If it doesn't resolve, the
    guard below already falls back to today's already-correct fixed-accent
    look silently -- nothing breaks either way, but the ring simply won't
    show until the name is corrected post-QA.

    Sizing (fixed after live testing): an earlier version forced this piece
    into a square matching the portrait container's own size, which visibly
    warped it -- an atlas piece has its own real native pixel dimensions,
    reported by C_Texture.GetAtlasInfo's `width`/`height` fields, and
    stretching it to an unrelated external size distorts it. This now sizes
    the texture to the atlas's own native width/height and centers it on
    `unitRegion`, rather than forcing any external size onto it.
]]
local FOREVER_PORTRAIT_ATLAS = "ui-hud-unitframe-player-portraiton"

--- Applies the Forever theme's real per-client UnitFrame art: creates
--- (once, cached on `frame`) a portrait ring texture centered on
--- `unitRegion` (the real portrait region -- same convention as
--- ApplyClassicUnitFrameArt) from a real Forever-native atlas piece, sized
--- to that atlas's own native pixel dimensions (never stretched to fit
--- `unitRegion`), gated on the atlas name actually resolving in this
--- client. Falls back to ClearForeverUnitFrameArt (i.e. today's
--- already-shipped fixed-accent-color look, with no ring) when the atlas
--- name doesn't resolve, rather than erroring or half-applying.
--- @param frame Frame the unit frame's outer frame (owns the cache)
--- @param unitRegion Frame|Region the real portrait region to center on
function KT.VisualThemes:ApplyForeverUnitFrameArt(frame, unitRegion)
    if type(frame) ~= "table" or type(frame.CreateTexture) ~= "function" then return end
    if type(unitRegion) ~= "table" then return end

    local info = C_Texture and C_Texture.GetAtlasInfo and C_Texture.GetAtlasInfo(FOREVER_PORTRAIT_ATLAS)
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
    art:SetAtlas(FOREVER_PORTRAIT_ATLAS)

    art:ClearAllPoints()
    if info.width and info.height and info.width > 0 and info.height > 0 then
        art:SetSize(info.width, info.height)
    end
    art:SetPoint("CENTER", unitRegion, "CENTER", 0, 0)
    art:Show()
end

--- Hides (does not destroy) the Forever portrait ring created by
--- ApplyForeverUnitFrameArt, if any. Nil-safe if it was never created.
--- @param frame Frame|Region the unit frame passed to ApplyForeverUnitFrameArt
function KT.VisualThemes:ClearForeverUnitFrameArt(frame)
    if type(frame) ~= "table" then return end
    local art = frame._ktForeverPortraitArt
    if art then
        art:Hide()
    end
end
