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
    invisible underneath them. The host frame matches the same STRATA
    ("MEDIUM") and a comfortably higher LEVEL this codebase's own Portrait
    widget already uses for the identical reason (see this file's own
    "Portrait strata and level set at creation (MEDIUM/50) -- always above
    LOW frame" comment in KUIUnitFrames.lua) -- a documented, existing fact
    about this codebase, not a guess.
]]

local PORTRAIT_FRAME_TEXTURE = [[Interface\TargetingFrame\UI-TargetingFrame]]

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
-- Health/Portrait/border child frames. MEDIUM matches the Portrait widget's
-- own documented strata; the level offset only needs to clear
-- BuildBorderFrame's unifiedBorder (frame:GetFrameLevel() + 10) within that
-- same strata, which +20 comfortably does.
local ART_HOST_STRATA = "MEDIUM"
local ART_HOST_LEVEL_OFFSET = 20

--- Creates (once, cached on `frame[cacheKey]`) a child frame positioned to
--- fully cover `frame` and elevated to ART_HOST_STRATA/ART_HOST_LEVEL_OFFSET
--- so textures created on it draw above the outer frame's own child widgets.
--- @param frame Frame the unit frame's outer frame (owns the cache)
--- @param cacheKey string the field name this host is cached under on `frame`
--- @return Frame|nil host
local function EnsureArtHost(frame, cacheKey)
    local host = frame[cacheKey]
    if host then return host end

    host = CreateFrame("Frame", nil, frame)
    host:SetAllPoints(frame)
    host:SetFrameStrata(ART_HOST_STRATA)
    host:SetFrameLevel(frame:GetFrameLevel() + ART_HOST_LEVEL_OFFSET)
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
]]
local FOREVER_PORTRAIT_ATLAS = "ui-hud-unitframe-player-portraiton"

--- Applies the Forever theme's real per-client UnitFrame art: creates
--- (once, cached on `frame`) a portrait ring texture anchored to
--- `unitRegion` (the real portrait region -- same convention as
--- ApplyClassicUnitFrameArt) from a real Forever-native atlas piece, gated
--- on that atlas name actually resolving in this client. Falls back to
--- ClearForeverUnitFrameArt (i.e. today's already-shipped fixed-accent-color
--- look, with no ring) when the atlas name doesn't resolve, rather than
--- erroring or half-applying.
--- @param frame Frame the unit frame's outer frame (owns the cache)
--- @param unitRegion Frame|Region the real portrait region to frame
function KT.VisualThemes:ApplyForeverUnitFrameArt(frame, unitRegion)
    if type(frame) ~= "table" or type(frame.CreateTexture) ~= "function" then return end
    if type(unitRegion) ~= "table" then return end

    if not (C_Texture and C_Texture.GetAtlasInfo and C_Texture.GetAtlasInfo(FOREVER_PORTRAIT_ATLAS)) then
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

    SeatSquareArt(art, unitRegion)
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
