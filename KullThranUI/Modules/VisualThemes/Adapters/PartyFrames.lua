local addonName, ns = ...
local KT = LibStub("AceAddon-3.0"):GetAddon("KullThranUI")
KT.VisualThemes = KT.VisualThemes or {}

local MODES = { "party", "raid", "raid40", "arena", "arenaEnemy", "boss" }

local function GetProfile()
    if not (KT.db and KT.db.profile) then return nil end
    KT.db.profile.partyFrames = KT.db.profile.partyFrames or {}
    return KT.db.profile.partyFrames
end

KT.VisualThemes:RegisterModule("partyframes", {
    isAvailable = function() return GetProfile() ~= nil end,
    getProfile = GetProfile,
    getOwnedPaths = function()
        local paths = {}
        for _, mode in ipairs(MODES) do
            paths[#paths + 1] = mode .. ".healthTexture"
            paths[#paths + 1] = mode .. ".absorbBarTexture"
        end
        return paths
    end,
    seed = function(profile, themeKey)
        local texture
        if themeKey == "classic" then
            texture = "Blizzard"
        elseif themeKey == "forever" then
            texture = "Melli Dark"
        elseif themeKey == "retail" then
            texture = "Blizzard Raid Bar"
        else
            texture = "Melli Reforged"
        end
        for _, mode in ipairs(MODES) do
            profile[mode] = type(profile[mode]) == "table" and profile[mode] or {}
            profile[mode].healthTexture = texture
            profile[mode].absorbBarTexture = texture
        end
    end,
    validate = function() end,
})
