local addonName, ns = ...
local KT = LibStub("AceAddon-3.0"):GetAddon("KullThranUI")
KT.VisualThemes = KT.VisualThemes or {}

local function GetProfile()
    if not (KT.db and KT.db.profile) then return nil end
    KT.db.profile.skin = KT.db.profile.skin or {}
    return KT.db.profile.skin
end

KT.VisualThemes:RegisterModule("skin", {
    isAvailable = function() return GetProfile() ~= nil end,
    getProfile = GetProfile,
    getOwnedPaths = function()
        return {
            "borderTheme", "borderThemeBeforeClass", "customBorderColor", "kullthranUIColorByClass",
            "accentColor.r", "accentColor.g", "accentColor.b", "accentColor.a",
        }
    end,
    seed = function(profile, themeKey)
        if themeKey == "classic" then
            profile.borderTheme = "CUSTOM"
            profile.borderThemeBeforeClass = "CUSTOM"
            profile.customBorderColor = { r = 0.86, g = 0.62, b = 0.16, a = 1 }
            profile.kullthranUIColorByClass = false
        elseif themeKey == "forever" then
            profile.borderTheme = "CUSTOM"
            profile.borderThemeBeforeClass = "CUSTOM"
            profile.customBorderColor = { r = 0.82, g = 0.65, b = 0.23, a = 1 }
            -- Explicit user request: Forever's accent should default to
            -- bronze. borderTheme="CUSTOM" already makes GetStylePalette()
            -- use customBorderColor for the effective accent, but the raw
            -- accentColor (the base value CUSTOM overrides, and what a
            -- plain "custom accent color" picker would show) was left at
            -- whatever it was before -- set it to the same bronze so both
            -- read consistently.
            profile.accentColor = { r = 0.82, g = 0.65, b = 0.23, a = 1 }
            profile.kullthranUIColorByClass = false
        elseif themeKey == "retail" then
            profile.borderTheme = "CLASS"
            profile.borderThemeBeforeClass = "KULLTHRAN"
            profile.kullthranUIColorByClass = true
        else
            profile.borderTheme = "KULLTHRAN"
            profile.borderThemeBeforeClass = "KULLTHRAN"
            profile.kullthranUIColorByClass = false
        end
    end,
    validate = function(profile)
        local valid = { KULLTHRAN = true, CLASS = true, CUSTOM = true }
        if not valid[profile.borderTheme] then profile.borderTheme = "KULLTHRAN" end
    end,
})
