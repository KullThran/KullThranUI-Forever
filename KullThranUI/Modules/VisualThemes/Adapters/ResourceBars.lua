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
            "general.texture", "general.frameArtKit",
            "health.texture", "health.borderSize",
            "health.fillR", "health.fillG", "health.fillB",
            "primary.texture", "primary.borderSize",
            "secondary.texture", "secondary.borderSize",
        }
    end,
    seed = function(profile, themeKey)
        -- health/primary/secondary share one texture+borderSize seed (already
        -- true before this task) and now one shared classic-border toggle
        -- (general.frameArtKit): the three sub-bars stack into a single
        -- resource-bar identity, not three independent widgets, so one
        -- switch framing all three is the honest choice -- see audit notes
        -- in ESTUDIO_SELECTOR_ESTILOS_INSTALLER_RETAIL.md section 30.
        --
        -- Only health gets a per-theme accent color: it is the one section
        -- with a real, always-rendered static color field (fillR/fillG/fillB,
        -- confirmed at KUIResourceBars.lua:1770) with no gameplay meaning
        -- attached. primary/secondary default to colorMode == "power" (a
        -- real, currently-accurate class/power-type color -- e.g. mana blue,
        -- rage red) and are left untouched so re-theming doesn't strip that
        -- information from the player.
        local texture, borderSize, frameArtKit
        local healthR, healthG, healthB
        if themeKey == "classic" then
            texture, borderSize, frameArtKit = "Blizzard", 1, "classic"
            healthR, healthG, healthB = 0.86, 0.62, 0.16
        elseif themeKey == "forever" then
            texture, borderSize, frameArtKit = "Melli Dark", 2, "default"
            healthR, healthG, healthB = 0.82, 0.65, 0.23
        elseif themeKey == "retail" then
            texture, borderSize, frameArtKit = "Blizzard Raid Bar", 0, "default"
            healthR, healthG, healthB = 0.12, 0.48, 0.95
        else
            -- kui: reset the classic-border field to ResourceBars' own
            -- default (KUIResourceBars.lua general defaults: frameArtKit = "default").
            texture, borderSize, frameArtKit = "Melli Reforged", 1, "default"
        end
        profile.general = profile.general or {}
        profile.general.texture = texture
        if frameArtKit then profile.general.frameArtKit = frameArtKit end
        for _, key in ipairs({ "health", "primary", "secondary" }) do
            profile[key] = profile[key] or {}
            profile[key].texture = texture
            profile[key].borderSize = borderSize
        end
        if healthR then
            profile.health.fillR, profile.health.fillG, profile.health.fillB = healthR, healthG, healthB
        end
    end,
    validate = function(profile)
        for _, key in ipairs({ "health", "primary", "secondary" }) do
            profile[key] = profile[key] or {}
            profile[key].borderSize = math.max(0, math.min(3, tonumber(profile[key].borderSize) or 1))
        end
    end,
})
