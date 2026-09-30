local addonName, ns = ...
local KT = LibStub("AceAddon-3.0"):GetAddon("KullThranUI")
KT.VisualThemes = KT.VisualThemes or {}

local UNIT_KEYS = { "player", "target", "focus", "pet", "boss" }

local function GetProfile()
    if not (KT.db and KT.db.profile) then return nil end
    KT.db.profile.unitFrames = KT.db.profile.unitFrames or {}
    return KT.db.profile.unitFrames
end

local function SetUnitValues(profile, showPortrait, texture)
    for _, key in ipairs(UNIT_KEYS) do
        profile[key] = type(profile[key]) == "table" and profile[key] or {}
        local unit = profile[key]
        unit.showPortrait = showPortrait
        unit.healthBarTexture = texture
    end
end

local function SetUnitBorderColor(profile, colorR, colorG, colorB)
    for _, key in ipairs(UNIT_KEYS) do
        profile[key] = type(profile[key]) == "table" and profile[key] or {}
        local unit = profile[key]
        unit.borderColor = { r = colorR, g = colorG, b = colorB }
    end
end

-- Explicit user request: player/target default 15% bigger under
-- Retail/Classic/Forever (module's own default frameScale is 100).
local PLAYER_TARGET_FRAME_SCALE = 115
local function SetPlayerTargetScale(profile, scale)
    for _, key in ipairs({ "player", "target" }) do
        profile[key] = type(profile[key]) == "table" and profile[key] or {}
        profile[key].frameScale = scale
    end
end

KT.VisualThemes:RegisterModule("unitframes", {
    isAvailable = function() return GetProfile() ~= nil end,
    getProfile = GetProfile,
    getOwnedPaths = function()
        local paths = {
            "portraitStyle", "darkTheme", "healthBarTexture", "frameArtKit",
            "target.portraitSide",
        }
        for _, key in ipairs(UNIT_KEYS) do
            paths[#paths + 1] = key .. ".showPortrait"
            paths[#paths + 1] = key .. ".healthBarTexture"
            paths[#paths + 1] = key .. ".borderColor.r"
            paths[#paths + 1] = key .. ".borderColor.g"
            paths[#paths + 1] = key .. ".borderColor.b"
        end
        paths[#paths + 1] = "player.showPlayerCastbar"
        paths[#paths + 1] = "player.frameScale"
        paths[#paths + 1] = "target.frameScale"
        return paths
    end,
    seed = function(profile, themeKey, clientFlavor)
        if themeKey == "classic" then
            -- Classic's real stock box (ApplyClassicUnitFrameArt) assumes a
            -- round-clipped portrait, same as Forever's -- Blizzard's real
            -- TargetingFrame portrait is round too. "attached" takes
            -- ApplyDetachedPortraitShape's fast path, which explicitly
            -- REMOVES any mask -- confirmed live: the portrait rendered
            -- fully unmasked and bled outside the ring.
            profile.portraitStyle = "circular"
            profile.darkTheme = false
            profile.healthBarTexture = "Blizzard"
            SetUnitValues(profile, true, "Blizzard")
            SetUnitBorderColor(profile, 0.92, 0.72, 0.22)
            profile.frameArtKit = "classic"
            if profile.target then profile.target.portraitSide = "right" end
            -- showPlayerCastbar defaults to false module-wide -- explicit
            -- user report: cast bars "don't appear" under Classic/Forever.
            -- Real stock geometry anchors the cast bar below Power already
            -- (CreateCastBar); it just never turns on unless the user
            -- opts in manually. Real per-client themes should show it.
            profile.player = profile.player or {}
            profile.player.showPlayerCastbar = true
            SetPlayerTargetScale(profile, PLAYER_TARGET_FRAME_SCALE)
        elseif themeKey == "forever" then
            profile.portraitStyle = "circular"
            profile.darkTheme = true
            profile.healthBarTexture = "Melli Dark"
            SetUnitValues(profile, true, "Melli Dark")
            SetUnitBorderColor(profile, 0.82, 0.65, 0.23)
            profile.frameArtKit = "default"
            if profile.target then profile.target.portraitSide = "right" end
            profile.player = profile.player or {}
            profile.player.showPlayerCastbar = true
            SetPlayerTargetScale(profile, PLAYER_TARGET_FRAME_SCALE)
        elseif themeKey == "retail" then
            profile.portraitStyle = "none"
            profile.darkTheme = false
            profile.healthBarTexture = "Blizzard Raid Bar"
            SetUnitValues(profile, false, "Blizzard Raid Bar")
            SetUnitBorderColor(profile, 0.20, 0.58, 1.00)
            profile.frameArtKit = "default"
            SetPlayerTargetScale(profile, PLAYER_TARGET_FRAME_SCALE)
        else
            profile.portraitStyle = clientFlavor == "forever" and "circular" or "none"
            profile.darkTheme = false
            profile.healthBarTexture = "Melli Reforged"
            SetUnitValues(profile, clientFlavor == "forever", "Melli Reforged")
            if profile.target and clientFlavor == "forever" then profile.target.portraitSide = "right" end
            -- kui: reset the classic-border field to UnitFrames' own default
            -- (KUIUnitFrames.lua defaults: frameArtKit = "default").
            profile.frameArtKit = "default"
        end
    end,
    validate = function(profile, themeKey)
        local valid = { attached = true, detached = true, circular = true, none = true }
        if not valid[profile.portraitStyle] then profile.portraitStyle = "circular" end
        -- The frame kit is part of the visual theme. Repair old slots that
        -- were captured before Classic's real stock frame was added.
        profile.frameArtKit = themeKey == "classic" and "classic" or "default"
    end,
})
