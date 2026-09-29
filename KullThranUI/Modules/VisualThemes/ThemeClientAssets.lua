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
    ring, plus Interface\TargetingFrame\UI-StatusBar for the health bar fill
    (the same file already used elsewhere in this addon for the "Blizzard"
    statusbar texture). Neither is an atlas name, so neither carries the
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
]]

local HEALTHBAR_TEXTURE = [[Interface\TargetingFrame\UI-StatusBar]]
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

--- Applies the Classic theme's real per-client UnitFrame art: retextures
--- `healthBarTexture` with the real vanilla-era status bar fill, and
--- creates (once, cached on `frame`) a portrait/frame ring texture on
--- `unitRegion` from the real UI-TargetingFrame sheet. Safe to call every
--- refresh -- the ring texture is created once and repositioned/shown on
--- repeat calls, never recreated.
--- @param frame Frame|Region the unit frame's outer frame (owns the cache)
--- @param unitRegion Frame|Region the portrait/backdrop region to frame
--- @param healthBarTexture Texture the health bar's fill texture object
function KT.VisualThemes:ApplyClassicUnitFrameArt(frame, unitRegion, healthBarTexture)
    if type(frame) ~= "table" or type(frame.CreateTexture) ~= "function" then return end
    if type(unitRegion) ~= "table" then return end
    if type(healthBarTexture) ~= "table" or type(healthBarTexture.SetTexture) ~= "function" then return end

    healthBarTexture:SetTexture(HEALTHBAR_TEXTURE)

    local art = frame._ktClassicPortraitArt
    if not art then
        art = frame:CreateTexture(nil, "OVERLAY")
        art:SetTexture(PORTRAIT_FRAME_TEXTURE)
        art:SetTexCoord(PORTRAIT_ART_TEXCOORD[1], PORTRAIT_ART_TEXCOORD[2], PORTRAIT_ART_TEXCOORD[3], PORTRAIT_ART_TEXCOORD[4])
        frame._ktClassicPortraitArt = art
    end

    art:ClearAllPoints()
    art:SetAllPoints(unitRegion)
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
