local addonName, ns = ...
local KT = LibStub("AceAddon-3.0"):GetAddon("KullThranUI")
KT.VisualThemes = KT.VisualThemes or {}

local function GetProfile()
    if not (KT.db and KT.db.profile) then return nil end
    KT.db.profile.resourceBars = KT.db.profile.resourceBars or {}
    return KT.db.profile.resourceBars
end

KT.VisualThemes:RegisterModule("resourcebars", {
    isAvailable = function() return GetProfile() ~= nil end,
    getProfile = GetProfile,
    getOwnedPaths = function()
        return {
            "general.texture",
            "health.texture", "health.borderSize",
            "primary.texture", "primary.borderSize",
            "secondary.texture", "secondary.borderSize",
        }
    end,
    seed = function(profile, themeKey)
        local texture, borderSize
        if themeKey == "classic" then
            texture, borderSize = "Blizzard", 1
        elseif themeKey == "forever" then
            texture, borderSize = "Melli Dark", 2
        elseif themeKey == "retail" then
            texture, borderSize = "Blizzard Raid Bar", 0
        else
            texture, borderSize = "Melli Reforged", 1
        end
        profile.general = profile.general or {}
        profile.general.texture = texture
        for _, key in ipairs({ "health", "primary", "secondary" }) do
            profile[key] = profile[key] or {}
            profile[key].texture = texture
            profile[key].borderSize = borderSize
        end
    end,
    validate = function(profile)
        for _, key in ipairs({ "health", "primary", "secondary" }) do
            profile[key] = profile[key] or {}
            profile[key].borderSize = math.max(0, math.min(3, tonumber(profile[key].borderSize) or 1))
        end
    end,
})
