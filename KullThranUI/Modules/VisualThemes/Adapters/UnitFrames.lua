local addonName, ns = ...
local KT = LibStub("AceAddon-3.0"):GetAddon("KullThranUI")
KT.VisualThemes = KT.VisualThemes or {}

local UNIT_KEYS = { "player", "target", "focus", "pet", "boss" }

local function GetProfile()
    if not (KT.db and KT.db.profile) then return nil end
    KT.db.profile.unitFrames = KT.db.profile.unitFrames or {}
    return KT.db.profile.unitFrames
end

local function SetUnitValues(profile, showPortrait, texture, classStyle)
    for _, key in ipairs(UNIT_KEYS) do
        profile[key] = type(profile[key]) == "table" and profile[key] or {}
        local unit = profile[key]
        unit.showPortrait = showPortrait
        unit.healthBarTexture = texture
        unit.classThemeStyle = classStyle
    end
end

KT.VisualThemes:RegisterModule("unitframes", {
    isAvailable = function() return GetProfile() ~= nil end,
    getProfile = GetProfile,
    getOwnedPaths = function()
        local paths = {
            "portraitStyle", "darkTheme", "healthBarTexture",
            "target.portraitSide",
        }
        for _, key in ipairs(UNIT_KEYS) do
            paths[#paths + 1] = key .. ".showPortrait"
            paths[#paths + 1] = key .. ".healthBarTexture"
            paths[#paths + 1] = key .. ".classThemeStyle"
        end
        return paths
    end,
    seed = function(profile, themeKey, clientFlavor)
        if themeKey == "classic" then
            profile.portraitStyle = "attached"
            profile.darkTheme = false
            profile.healthBarTexture = "Blizzard"
            SetUnitValues(profile, true, "Blizzard", "classic")
            if profile.target then profile.target.portraitSide = "left" end
        elseif themeKey == "forever" then
            profile.portraitStyle = "circular"
            profile.darkTheme = true
            profile.healthBarTexture = "Melli Dark"
            SetUnitValues(profile, true, "Melli Dark", "modern")
            if profile.target then profile.target.portraitSide = "right" end
        elseif themeKey == "retail" then
            profile.portraitStyle = "none"
            profile.darkTheme = false
            profile.healthBarTexture = "Blizzard Raid Bar"
            SetUnitValues(profile, false, "Blizzard Raid Bar", "modern")
        else
            profile.portraitStyle = clientFlavor == "forever" and "circular" or "none"
            profile.darkTheme = false
            profile.healthBarTexture = "Melli Reforged"
            SetUnitValues(profile, clientFlavor == "forever", "Melli Reforged", "modern")
            if profile.target and clientFlavor == "forever" then profile.target.portraitSide = "right" end
        end
    end,
    validate = function(profile)
        local valid = { attached = true, detached = true, circular = true, none = true }
        if not valid[profile.portraitStyle] then profile.portraitStyle = "circular" end
    end,
})
