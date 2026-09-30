local function expect(actual, expected, label)
    if actual ~= expected then
        error(string.format("%s: expected %s, got %s", label, tostring(expected), tostring(actual)))
    end
end

local KT = {
    db = {
        profile = {
            visualTheme = {
                active = "classic",
                requested = "classic",
                schemaVersion = 1,
                modules = {},
                slots = {
                    actionbars = {
                        kui = {
                            buttonStyle = "SIMPLICITY",
                            buttonShape = "HEXAGON",
                        },
                    },
                    skin = {
                        kui = {
                            stylePreset = "user_palette",
                            borderTheme = "CUSTOM",
                            customBorderColor = { r = 0.11, g = 0.22, b = 0.33, a = 1 },
                            kullthranUIColorByClass = false,
                        },
                    },
                },
            },
            unitFrames = {
                portraitStyle = "circular",
                darkTheme = false,
                healthBarTexture = "User Texture",
                player = { showPortrait = true, healthBarTexture = "User Texture", borderColor = { r = 0.55, g = 0.33, b = 0.77 } },
                target = { showPortrait = true, portraitSide = "right", healthBarTexture = "User Texture" },
                focus = { showPortrait = true, healthBarTexture = "User Texture" },
                pet = { showPortrait = true, healthBarTexture = "User Texture" },
                boss = { showPortrait = true, healthBarTexture = "User Texture" },
            },
            actionbars = {
                buttonStyle = "classic",
                buttonShape = "rounded",
            },
            resourceBars = {
                general = { texture = "User Texture", frameArtKit = "user_kit" },
                health = { texture = "User Texture", borderSize = 3, fillR = 0.4, fillG = 0.5, fillB = 0.6 },
                primary = { texture = "User Texture", borderSize = 3 },
                secondary = { texture = "User Texture", borderSize = 3 },
            },
            castbar = {
                texture = "User Texture",
                iconShape = "CIRCLE",
                colorMode = "THEME",
                color = { r = 0.4, g = 0.5, b = 0.6, a = 1 },
                frameArtKit = "user_kit",
            },
            cooldownManager = {
                reskinBorders = true,
                cdmBars = {
                    barDefaults = { iconShape = "diamond", frameArtKit = "user_kit" },
                    bars = {
                        { iconShape = "diamond", borderSize = 3, borderR = 0.1, borderG = 0.2, borderB = 0.3, frameArtKit = "user_kit" },
                    },
                },
            },
            partyFrames = {
                party = { healthTexture = "User Texture", absorbBarTexture = "User Texture", absorbBarColor = { r = 0.4, g = 0.5, b = 0.6 } },
                raid = { healthTexture = "User Texture", absorbBarTexture = "User Texture", absorbBarColor = { r = 0.4, g = 0.5, b = 0.6 } },
            },
            skin = {
                stylePreset = "broken_value",
                borderTheme = "CLASS",
                customBorderColor = { r = 1, g = 0, b = 0, a = 1 },
                kullthranUIColorByClass = true,
            },
        },
    },
    VisualThemes = {},
    messages = {},
}

function KT:GetModule() return nil end
function KT:Print(message) self.messages[#self.messages + 1] = message end

local ace = {}
function ace:GetAddon() return KT end
function _G.LibStub() return ace end

_G.KullThranUINameplatesDB_Forever = {
    healthBarTexture = "User Texture",
    friendlyPlayerHealthTexture = "User Texture",
    friendlyNPCHealthTexture = "User Texture",
    castBarTexture = "User Texture",
    borderStyle = "kullthran",
    borderColor = { r = 0.1, g = 0.1, b = 0.1 },
    targetGlowStyle = "kullthranui",
}
_G.KullThranUINameplatesDB = _G.KullThranUINameplatesDB_Forever
_G.WOW_PROJECT_ID = 16
_G.WOW_PROJECT_MAINLINE = 1
_G.InCombatLockdown = function() return false end

local reloads = 0
_G.ReloadUI = function() reloads = reloads + 1 end
_G.StaticPopupDialogs = {}

local function loadAddonFile(path)
    local chunk = assert(loadfile(path))
    return chunk("KullThranUI", {})
end

loadAddonFile("KullThranUI/Modules/VisualThemes/ThemeCatalog.lua")
loadAddonFile("KullThranUI/Modules/VisualThemes/ThemeSlots.lua")
loadAddonFile("KullThranUI/Modules/VisualThemes/ThemeRegistry.lua")
loadAddonFile("KullThranUI/Modules/VisualThemes/ThemeEngine.lua")
loadAddonFile("KullThranUI/Modules/VisualThemes/Adapters/UnitFrames.lua")
loadAddonFile("KullThranUI/Modules/VisualThemes/Adapters/ActionBars.lua")
loadAddonFile("KullThranUI/Modules/VisualThemes/Adapters/ResourceBars.lua")
loadAddonFile("KullThranUI/Modules/VisualThemes/Adapters/CastBar.lua")
loadAddonFile("KullThranUI/Modules/VisualThemes/Adapters/CooldownManager.lua")
loadAddonFile("KullThranUI/Modules/VisualThemes/Adapters/Nameplates.lua")
loadAddonFile("KullThranUI/Modules/VisualThemes/Adapters/PartyFrames.lua")
loadAddonFile("KullThranUI/Modules/VisualThemes/Adapters/Skin.lua")

KT.VisualThemes:EnsureInitialized()
expect(KT.db.profile.visualTheme.schemaVersion, 3, "schema migration")
expect(KT.db.profile.visualTheme.active, "kui", "legacy active theme")
expect(KT.db.profile.actionbars.buttonStyle, "SIMPLICITY", "legacy KUI action style")
expect(KT.db.profile.actionbars.buttonShape, "HEXAGON", "legacy KUI action shape")
expect(KT.db.profile.skin.stylePreset, "user_palette", "legacy palette recovery")

expect(KT.VisualThemes:ApplyAll("classic"), true, "apply classic")
expect(KT.db.profile.unitFrames.portraitStyle, "circular", "classic portraits")
expect(KT.db.profile.unitFrames.target.portraitSide, "right", "classic target portrait side")
expect(KT.db.profile.actionbars.buttonStyle, "BLIZZARD", "classic action style")
expect(KT.db.profile.actionbars.frameArtKit, "classic", "classic action frame art kit")
expect(KT.db.profile.resourceBars.primary.texture, "Blizzard", "classic resource texture")
expect(KT.db.profile.resourceBars.general.frameArtKit, "classic", "classic resource frame art kit")
expect(KT.db.profile.resourceBars.health.fillR, 0.86, "classic resource health color")
expect(KT.db.profile.castbar.texture, "Blizzard", "classic cast texture")
expect(KT.db.profile.castbar.colorMode, "CUSTOM", "classic cast bar color mode")
expect(KT.db.profile.castbar.color.r, 0.86, "classic cast bar color")
expect(KT.db.profile.castbar.frameArtKit, "classic", "classic cast bar frame art kit")
expect(KT.db.profile.cooldownManager.cdmBars.bars[1].iconShape, "square", "classic CDM shape")
expect(KT.db.profile.cooldownManager.cdmBars.bars[1].frameArtKit, "classic", "classic CDM frame art kit")
expect(KT.db.profile.cooldownManager.cdmBars.barDefaults.frameArtKit, "classic", "classic CDM barDefaults frame art kit")
expect(_G.KullThranUINameplatesDB_Forever.borderStyle, "simple", "classic nameplate border")
expect(_G.KullThranUINameplatesDB_Forever.borderColor.r, 0.28, "classic nameplate border color r")
expect(_G.KullThranUINameplatesDB_Forever.targetGlowStyle, "vibrant", "classic nameplate target glow style")
expect(_G.KullThranUINameplatesDB_Forever.healthBarTexture, "Blizzard", "classic nameplate health texture")
expect(KT.db.profile.partyFrames.party.healthTexture, "Blizzard", "classic party texture")
expect(KT.db.profile.partyFrames.party.absorbBarColor.r, 0.86, "classic party absorb color r")
expect(KT.db.profile.partyFrames.raid.absorbBarColor.r, 0.86, "classic raid absorb color r")
expect(KT.db.profile.skin.stylePreset, "user_palette", "palette unchanged outside KUI")
expect(KT.db.profile.unitFrames.player.borderColor.r, 0.92, "classic unit border color")
expect(KT.db.profile.unitFrames.frameArtKit, "classic", "classic unit frame art kit")
expect(KT.db.profile.unitFrames.player.frameScale, 115, "classic player frame scale +15%")
expect(KT.db.profile.unitFrames.target.frameScale, 115, "classic target frame scale +15%")

expect(KT.VisualThemes:ApplyAll("retail"), true, "apply retail")
expect(KT.db.profile.unitFrames.portraitStyle, "none", "retail portraits")
expect(KT.db.profile.actionbars.frameArtKit, "retail", "retail action frame art kit")
expect(KT.db.profile.resourceBars.primary.texture, "Blizzard Raid Bar", "retail resource texture")
expect(KT.db.profile.resourceBars.general.frameArtKit, "default", "retail resource frame art kit")
expect(KT.db.profile.resourceBars.health.fillR, 0.12, "retail resource health color")
expect(_G.KullThranUINameplatesDB_Forever.borderStyle, "none", "retail nameplate border")
expect(_G.KullThranUINameplatesDB_Forever.borderColor.r, 0.03, "retail nameplate border color r")
expect(_G.KullThranUINameplatesDB_Forever.targetGlowStyle, "none", "retail nameplate target glow style")
expect(_G.KullThranUINameplatesDB_Forever.healthBarTexture, "Blizzard Raid Bar", "retail nameplate health texture")
expect(KT.db.profile.unitFrames.player.borderColor.r, 0.20, "retail unit border color")
expect(KT.db.profile.partyFrames.party.absorbBarColor.r, 0.12, "retail party absorb color r")
expect(KT.db.profile.unitFrames.frameArtKit, "default", "retail unit frame art kit")
expect(KT.db.profile.castbar.colorMode, "CUSTOM", "retail cast bar color mode")
expect(KT.db.profile.castbar.color.r, 0.12, "retail cast bar color")
expect(KT.db.profile.castbar.frameArtKit, "default", "retail cast bar frame art kit")
expect(KT.db.profile.cooldownManager.cdmBars.bars[1].frameArtKit, "default", "retail CDM frame art kit")
expect(KT.db.profile.cooldownManager.cdmBars.barDefaults.frameArtKit, "default", "retail CDM barDefaults frame art kit")
expect(KT.db.profile.unitFrames.player.frameScale, 115, "retail player frame scale +15%")
expect(KT.db.profile.unitFrames.target.frameScale, 115, "retail target frame scale +15%")

expect(KT.VisualThemes:ApplyAll("kui"), true, "restore KUI")
expect(KT.db.profile.actionbars.buttonStyle, "SIMPLICITY", "restore action style")
expect(KT.db.profile.actionbars.buttonShape, "HEXAGON", "restore action shape")
expect(KT.db.profile.actionbars.frameArtKit, "default", "restore action frame art kit")
expect(KT.db.profile.unitFrames.healthBarTexture, "User Texture", "restore unit texture")
expect(KT.db.profile.resourceBars.primary.texture, "User Texture", "restore resource texture")
expect(KT.db.profile.resourceBars.general.frameArtKit, "user_kit", "restore resource frame art kit")
expect(KT.db.profile.resourceBars.health.fillR, 0.4, "restore resource health color r")
expect(KT.db.profile.resourceBars.health.fillG, 0.5, "restore resource health color g")
expect(KT.db.profile.resourceBars.health.fillB, 0.6, "restore resource health color b")
expect(KT.db.profile.castbar.texture, "User Texture", "restore cast texture")
expect(KT.db.profile.castbar.colorMode, "THEME", "restore cast bar color mode")
expect(KT.db.profile.castbar.color.r, 0.4, "restore cast bar color")
expect(KT.db.profile.castbar.frameArtKit, "user_kit", "restore cast bar frame art kit")
expect(KT.db.profile.cooldownManager.cdmBars.bars[1].iconShape, "diamond", "restore CDM shape")
expect(KT.db.profile.cooldownManager.cdmBars.bars[1].frameArtKit, "user_kit", "restore CDM frame art kit")
expect(KT.db.profile.cooldownManager.cdmBars.barDefaults.frameArtKit, "user_kit", "restore CDM barDefaults frame art kit")
expect(_G.KullThranUINameplatesDB_Forever.borderStyle, "kullthran", "restore nameplate border")
expect(_G.KullThranUINameplatesDB_Forever.borderColor.r, 0.1, "restore nameplate border color r")
expect(_G.KullThranUINameplatesDB_Forever.targetGlowStyle, "kullthranui", "restore nameplate target glow style")
expect(_G.KullThranUINameplatesDB_Forever.healthBarTexture, "User Texture", "restore nameplate health texture")
expect(KT.db.profile.skin.stylePreset, "user_palette", "restore palette")
expect(KT.db.profile.unitFrames.player.classThemeStyle, nil, "kui no longer seeds dead classThemeStyle")
expect(KT.db.profile.partyFrames.party.absorbBarColor.r, 0.4, "restore custom party absorb color r")
expect(KT.db.profile.partyFrames.party.absorbBarColor.g, 0.5, "restore custom party absorb color g")
expect(KT.db.profile.partyFrames.party.absorbBarColor.b, 0.6, "restore custom party absorb color b")
expect(KT.db.profile.unitFrames.player.borderColor.r, 0.55, "restore custom unit border color r")
expect(KT.db.profile.unitFrames.player.borderColor.g, 0.33, "restore custom unit border color g")
expect(KT.db.profile.unitFrames.player.borderColor.b, 0.77, "restore custom unit border color b")
expect(reloads, 3, "successful reload count")

KT.db.profile.partyFrames = nil
KT.db.profile.cooldownManager = nil
expect(KT.VisualThemes:ApplyAll("forever"), true, "apply with disabled modules")
expect(KT.db.profile.partyFrames.party.healthTexture, "Melli Dark", "disabled party theme seed")
expect(KT.db.profile.partyFrames.party.absorbBarColor.r, 0.82, "disabled party absorb color seed")
expect(KT.db.profile.cooldownManager.cdmBars.bars[1].iconShape, "circle", "disabled CDM theme seed")
expect(_G.KullThranUINameplatesDB_Forever.borderStyle, "kullthran", "forever nameplate border")
expect(_G.KullThranUINameplatesDB_Forever.borderColor.r, 0.82, "forever nameplate border color r")
expect(_G.KullThranUINameplatesDB_Forever.targetGlowStyle, "kullthranui", "forever nameplate target glow style")
expect(_G.KullThranUINameplatesDB_Forever.healthBarTexture, "Melli Dark", "forever nameplate health texture")
expect(KT.VisualThemes:ApplyAll("kui"), true, "restore disabled modules")
expect(KT.db.profile.partyFrames.party.healthTexture, nil, "disabled party KUI restore")
expect(KT.db.profile.partyFrames.party.absorbBarColor.r, nil, "disabled party absorb color KUI restore")
expect(KT.db.profile.cooldownManager.cdmBars.bars[1].iconShape, "none", "disabled CDM KUI restore")
expect(reloads, 5, "disabled-module reload count")

KT.db.profile.visualTheme.active = "forever"
KT.db.profile.visualTheme.requested = "forever"
KT.db.profile.visualTheme.applied.actionbars = nil
KT.db.profile.actionbars.buttonShape = "NONE"
expect(KT.VisualThemes:ApplyCurrentThemeToModule("actionbars"), true, "late actionbars apply")
expect(KT.db.profile.actionbars.buttonStyle, "SIMPLICITY", "late actionbars style")
expect(KT.db.profile.actionbars.buttonShape, "CIRCLE", "late actionbars shape")
KT.db.profile.visualTheme.active = "kui"
KT.db.profile.visualTheme.requested = "kui"
KT.db.profile.visualTheme.applied.actionbars = nil
expect(KT.VisualThemes:ApplyCurrentThemeToModule("actionbars"), true, "late actionbars KUI restore")
expect(KT.db.profile.actionbars.buttonShape, "HEXAGON", "late actionbars restored shape")

-- Regression-lock: ActionBars buttonShape whitelist matches ActionBars_Options.lua
-- Valid shapes per ActionBars_Options.lua lines 217-223: NONE, CIRCLE, CSQUARE, HEXAGON, DIAMOND, SHIELD
local abAdapter = KT.VisualThemes:GetModuleAdapter("actionbars")
for _, validShape in ipairs({"NONE", "CIRCLE", "CSQUARE", "HEXAGON", "DIAMOND", "SHIELD"}) do
    local testProfile = { buttonStyle = "KUI", buttonShape = validShape }
    abAdapter.validate(testProfile)
    expect(testProfile.buttonShape, validShape, "actionbars shape " .. validShape .. " passes validation")
end
-- Test that invalid shape gets reset to NONE
local testProfile = { buttonStyle = "KUI", buttonShape = "INVALID", frameArtKit = "invalid" }
abAdapter.validate(testProfile)
expect(testProfile.buttonShape, "NONE", "actionbars invalid shape resets to NONE")
expect(testProfile.frameArtKit, "default", "actionbars invalid frame art resets to default")

-- kui must reset the classic-border field even when no kui slot exists
-- (e.g. a module whose profile did not exist yet when the user left kui and
-- was later late-applied under classic). Round-trip: classic -> kui with the
-- kui slots removed, so seed("kui") is what runs.
expect(KT.VisualThemes:ApplyAll("classic"), true, "apply classic for kui frameArtKit reset")
expect(KT.db.profile.unitFrames.frameArtKit, "classic", "pre-reset unit frame art kit")
expect(KT.db.profile.castbar.frameArtKit, "classic", "pre-reset cast bar frame art kit")
expect(KT.db.profile.resourceBars.general.frameArtKit, "classic", "pre-reset resource frame art kit")
expect(KT.db.profile.cooldownManager.cdmBars.barDefaults.frameArtKit, "classic", "pre-reset CDM barDefaults frame art kit")
for _, moduleKey in ipairs({ "unitframes", "castbar", "resourcebars", "cooldownmanager" }) do
    KT.db.profile.visualTheme.slots[moduleKey].kui = nil
end
expect(KT.VisualThemes:ApplyAll("kui"), true, "kui seed without kui slot")
expect(KT.db.profile.unitFrames.frameArtKit, "default", "kui seed resets unit frame art kit")
expect(KT.db.profile.castbar.frameArtKit, "default", "kui seed resets cast bar frame art kit")
expect(KT.db.profile.resourceBars.general.frameArtKit, "default", "kui seed resets resource frame art kit")
expect(KT.db.profile.cooldownManager.cdmBars.barDefaults.frameArtKit, "default", "kui seed resets CDM barDefaults frame art kit")
expect(KT.db.profile.cooldownManager.cdmBars.bars[1].frameArtKit, "default", "kui seed resets CDM bar frame art kit")
expect(reloads, 7, "kui frameArtKit reset reload count")

local failing = { value = "stable" }
KT.VisualThemes:RegisterModule("failure_probe", {
    getProfile = function() return failing end,
    getOwnedPaths = function() return { "value" } end,
    seed = function(profile)
        profile.value = "changed"
        error("intentional failure")
    end,
})

expect(KT.VisualThemes:ApplyAll("forever"), false, "failed apply result")
expect(KT.db.profile.visualTheme.active, "kui", "failed apply active theme")
expect(KT.db.profile.actionbars.buttonStyle, "SIMPLICITY", "failed apply rollback")
expect(failing.value, "stable", "failed adapter rollback")
expect(reloads, 7, "failed apply reload count")

-- Schema 2 -> 3: a profile saved before the honest-rendering pass. Active
-- theme is forever, module profiles look like the OLD forever seed left
-- them (no frameArtKit, the user's own borderColor/fillRGB/absorbBarColor),
-- and the slots were saved with the OLD owned-path lists.
do
    -- Unregister the intentional-failure probe so the round trip below can apply.
    local registry, order = KT.VisualThemes:GetAllAdapters()
    registry.failure_probe = nil
    for index = #order, 1, -1 do
        if order[index] == "failure_probe" then table.remove(order, index) end
    end
end
KT.db.profile.visualTheme = {
    active = "forever",
    requested = "forever",
    schemaVersion = 2,
    modules = {},
    applied = { unitframes = "forever", castbar = "forever", resourcebars = "forever", cooldownmanager = "forever", partyframes = "forever" },
    slots = {
        castbar = {
            kui = { texture = "User Texture", iconShape = "CIRCLE", colorMode = "THEME", color = { r = 0.4, g = 0.5, b = 0.6, a = 1 } },
            classic = { texture = "User Classic Texture", iconShape = "SQUARE", colorMode = "CUSTOM", color = { r = 0.5, g = 0.5, b = 0.5, a = 1 } },
        },
        unitframes = {
            kui = { portraitStyle = "circular", darkTheme = false, healthBarTexture = "User Texture", ["player.healthBarTexture"] = "User Texture" },
        },
    },
}
KT.db.profile.unitFrames = {
    portraitStyle = "circular", darkTheme = true, healthBarTexture = "Melli Dark",
    player = { showPortrait = true, healthBarTexture = "Melli Dark", borderColor = { r = 0.55, g = 0.33, b = 0.77 } },
    target = { showPortrait = true, portraitSide = "right", healthBarTexture = "Melli Dark" },
}
KT.db.profile.resourceBars = {
    general = { texture = "Melli Dark" },
    health = { texture = "Melli Dark", borderSize = 2, fillR = 0.4, fillG = 0.5, fillB = 0.6 },
    primary = { texture = "Melli Dark", borderSize = 2 },
    secondary = { texture = "Melli Dark", borderSize = 2 },
}
KT.db.profile.cooldownManager = { reskinBorders = true, cdmBars = { barDefaults = { iconShape = "circle" }, bars = { { iconShape = "circle", borderSize = 2 } } } }
KT.db.profile.partyFrames = { party = { healthTexture = "Melli Dark", absorbBarTexture = "Melli Dark", absorbBarColor = { r = 0.4, g = 0.5, b = 0.6 } } }
local savedCastbar = { texture = "User Forever Texture", iconShape = "CIRCLE", colorMode = "CUSTOM", color = { r = 0.82, g = 0.65, b = 0.23, a = 1 } }
KT.db.profile.castbar = nil -- CastBar addon not loaded yet at first init

KT.VisualThemes:EnsureInitialized()
local migrated = KT.db.profile.visualTheme
expect(migrated.schemaVersion, 3, "schema 2 -> 3 version")
expect(migrated.active, "forever", "schema 3 migration keeps active theme")
expect(migrated.requested, "forever", "schema 3 migration keeps requested theme")
expect(migrated.applied.unitframes, "forever", "schema 3 migration keeps applied state")
expect(KT.db.profile.unitFrames.frameArtKit, "default", "schema 3 backfills forever unit frame art kit")
expect(KT.db.profile.unitFrames.player.borderColor.r, 0.82, "schema 3 backfills forever unit border color")
expect(KT.db.profile.unitFrames.healthBarTexture, "Melli Dark", "schema 3 leaves other unit paths alone")
expect(KT.db.profile.resourceBars.general.frameArtKit, "default", "schema 3 backfills forever resource frame art kit")
expect(KT.db.profile.resourceBars.health.fillR, 0.82, "schema 3 backfills forever resource health color")
expect(KT.db.profile.cooldownManager.cdmBars.barDefaults.frameArtKit, "default", "schema 3 backfills CDM barDefaults frame art kit")
expect(KT.db.profile.cooldownManager.cdmBars.bars[1].frameArtKit, "default", "schema 3 backfills CDM bar frame art kit")
expect(KT.db.profile.cooldownManager.cdmBars.bars[1].borderSize, 2, "schema 3 leaves other CDM paths alone")
expect(KT.db.profile.partyFrames.party.absorbBarColor.r, 0.82, "schema 3 backfills forever party absorb color")
expect(migrated.pendingPathMigration.castbar, true, "unavailable castbar stays pending")
-- kui slot gains the user's own pre-schema-3 values for the new paths only.
local kuiUnitSlot = migrated.slots.unitframes.kui
expect(kuiUnitSlot["player.borderColor.r"], 0.55, "schema 3 kui slot keeps user border color")
expect(kuiUnitSlot.healthBarTexture, "User Texture", "schema 3 kui slot existing value untouched")

KT.db.profile.castbar = savedCastbar -- CastBar addon loads later
KT.VisualThemes:EnsureInitialized()
expect(migrated.pendingPathMigration, nil, "late castbar migration clears pending")
expect(KT.db.profile.castbar.frameArtKit, "default", "late castbar backfills forever frame art kit")
expect(KT.db.profile.castbar.texture, "User Forever Texture", "late castbar keeps active-theme customization")
local classicCastSlot = migrated.slots.castbar.classic
expect(classicCastSlot.texture, "User Classic Texture", "other theme slot texture untouched")
expect(classicCastSlot.color.r, 0.5, "other theme slot color untouched")
expect(classicCastSlot.iconShape, "SQUARE", "other theme slot shape untouched")
expect(classicCastSlot.frameArtKit, "classic", "other theme slot gains its own missing frame art kit")
expect(migrated.slots.castbar.kui.texture, "User Texture", "castbar kui slot texture untouched")
expect(migrated.slots.castbar.kui.frameArtKit, "default", "castbar kui slot gains default frame art kit")

-- Round trip after migration: kui shows the user's own values, classic
-- shows its border with the user's saved classic customization.
expect(KT.VisualThemes:ApplyAll("kui"), true, "post-migration kui")
expect(KT.db.profile.unitFrames.player.borderColor.r, 0.55, "post-migration kui unit border color")
expect(KT.db.profile.unitFrames.frameArtKit, "default", "post-migration kui unit frame art kit")
expect(KT.db.profile.castbar.texture, "User Texture", "post-migration kui cast texture")
expect(KT.db.profile.castbar.frameArtKit, "default", "post-migration kui cast frame art kit")
expect(KT.VisualThemes:ApplyAll("classic"), true, "post-migration classic")
expect(KT.db.profile.castbar.frameArtKit, "classic", "post-migration classic cast border")
expect(KT.db.profile.castbar.texture, "User Classic Texture", "post-migration classic keeps user slot")

print("visual theme engine tests passed")
