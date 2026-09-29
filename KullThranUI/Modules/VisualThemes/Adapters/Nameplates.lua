local addonName, ns = ...
local KT = LibStub("AceAddon-3.0"):GetAddon("KullThranUI")
KT.VisualThemes = KT.VisualThemes or {}

local function GetProfile()
    local profile = _G.KullThranUINameplatesDB_Forever or _G.KullThranUINameplatesDB
    if type(profile) ~= "table" then
        if not (KT.db and KT.db.profile) then return nil end
        profile = {}
        _G.KullThranUINameplatesDB_Forever = profile
        _G.KullThranUINameplatesDB = profile
    end
    return profile
end

KT.VisualThemes:RegisterModule("nameplates", {
    isAvailable = function() return GetProfile() ~= nil end,
    getProfile = GetProfile,
    getOwnedPaths = function()
        return {
            "healthBarTexture", "friendlyPlayerHealthTexture", "friendlyNPCHealthTexture",
            "castBarTexture", "borderStyle", "borderColor", "targetGlowStyle",
        }
    end,
    seed = function(profile, themeKey)
        if themeKey == "classic" then
            profile.healthBarTexture = "Blizzard"
            profile.friendlyPlayerHealthTexture = "Blizzard"
            profile.friendlyNPCHealthTexture = "Blizzard"
            profile.castBarTexture = "Blizzard"
            profile.borderStyle = "simple"
            profile.borderColor = { r = 0.28, g = 0.18, b = 0.07 }
            profile.targetGlowStyle = "vibrant"
        elseif themeKey == "forever" then
            profile.healthBarTexture = "Melli Dark"
            profile.friendlyPlayerHealthTexture = "Melli Dark"
            profile.friendlyNPCHealthTexture = "Melli Dark"
            profile.castBarTexture = "Melli Dark"
            profile.borderStyle = "kullthran"
            profile.borderColor = { r = 0.82, g = 0.65, b = 0.23 }
            profile.targetGlowStyle = "kullthranui"
        elseif themeKey == "retail" then
            profile.healthBarTexture = "Blizzard Raid Bar"
            profile.friendlyPlayerHealthTexture = "Blizzard Raid Bar"
            profile.friendlyNPCHealthTexture = "Blizzard Raid Bar"
            profile.castBarTexture = "Blizzard Raid Bar"
            profile.borderStyle = "none"
            profile.borderColor = { r = 0.03, g = 0.05, b = 0.09 }
            profile.targetGlowStyle = "none"
        else
            profile.healthBarTexture = "Melli Reforged"
            profile.friendlyPlayerHealthTexture = "Melli Reforged"
            profile.friendlyNPCHealthTexture = "Melli Reforged"
            profile.castBarTexture = "Melli Reforged"
            profile.borderStyle = "kullthran"
            profile.borderColor = { r = 0.067, g = 0.067, b = 0.067 }
            profile.targetGlowStyle = "kullthranui"
        end
    end,
    validate = function(profile)
        local valid = { kullthran = true, simple = true, none = true }
        if not valid[profile.borderStyle] then profile.borderStyle = "kullthran" end
        local glowStyles = { kullthranui = true, vibrant = true, none = true }
        if not glowStyles[profile.targetGlowStyle] then profile.targetGlowStyle = "kullthranui" end
    end,
})
