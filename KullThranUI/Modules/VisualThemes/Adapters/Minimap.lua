local addonName, ns = ...
local KT = LibStub("AceAddon-3.0"):GetAddon("KullThranUI")
KT.VisualThemes = KT.VisualThemes or {}

local function GetProfile()
    if not (KT.db and KT.db.profile) then return nil end
    KT.db.profile.minimap = KT.db.profile.minimap or {}
    return KT.db.profile.minimap
end

-- Only forever/classic get a fixed circular identity for now; retail and kui
-- are intentionally left untouched (studied and confirmed with the user,
-- retail port is a later pass once this is validated in Forever).
KT.VisualThemes:RegisterModule("minimap", {
    isAvailable = function() return GetProfile() ~= nil end,
    getProfile = GetProfile,
    getOwnedPaths = function()
        return { "shape", "borderColor" }
    end,
    seed = function(profile, themeKey)
        if themeKey == "forever" then
            profile.shape = "ROUND"
            profile.borderColor = { r = 0.82, g = 0.65, b = 0.23, a = 1 }
        elseif themeKey == "classic" then
            profile.shape = "ROUND"
            profile.borderColor = { r = 0.92, g = 0.72, b = 0.22, a = 1 }
        end
    end,
    validate = function() end,
})
