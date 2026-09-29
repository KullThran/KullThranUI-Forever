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
                party = { healthTexture = "User Texture", absorbBarTexture = "User Texture" },
                raid = { healthTexture = "User Texture", absorbBarTexture = "User Texture" },
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
expect(KT.db.profile.visualTheme.schemaVersion, 2, "schema migration")
expect(KT.db.profile.visualTheme.active, "kui", "legacy active theme")
expect(KT.db.profile.actionbars.buttonStyle, "SIMPLICITY", "legacy KUI action style")
expect(KT.db.profile.actionbars.buttonShape, "HEXAGON", "legacy KUI action shape")
expect(KT.db.profile.skin.stylePreset, "user_palette", "legacy palette recovery")

expect(KT.VisualThemes:ApplyAll("classic"), true, "apply classic")
expect(KT.db.profile.unitFrames.portraitStyle, "attached", "classic portraits")
expect(KT.db.profile.actionbars.buttonStyle, "BLIZZARD", "classic action style")
expect(KT.db.profile.resourceBars.primary.texture, "Blizzard", "classic resource texture")
expect(KT.db.profile.resourceBars.general.frameArtKit, "classic", "classic resource frame art kit")
expect(KT.db.profile.resourceBars.health.fillR, 0.86, "classic resource health color")
expect(KT.db.profile.castbar.texture, "Blizzard", "classic cast texture")
expect(KT.db.profile.castbar.colorMode, "CUSTOM", "classic cast bar color mode")
expect(KT.db.profile.castbar.color.r, 0.86, "classic cast bar color")
expect(KT.db.profile.castbar.frameArtKit, "classic", "classic cast bar frame art kit")
expect(KT.db.profile.cooldownManager.cdmBars.bars[1].iconShape, "square", "classic CDM shape")
expect(KT.db.profile.cooldownManager.cdmBars.bars[1].frameArtKit, "classic", "classic CDM frame art kit")
expect(_G.KullThranUINameplatesDB_Forever.borderStyle, "simple", "classic nameplate border")
expect(KT.db.profile.partyFrames.party.healthTexture, "Blizzard", "classic party texture")
expect(KT.db.profile.skin.stylePreset, "user_palette", "palette unchanged outside KUI")
expect(KT.db.profile.unitFrames.player.borderColor.r, 0.92, "classic unit border color")
expect(KT.db.profile.unitFrames.frameArtKit, "classic", "classic unit frame art kit")

expect(KT.VisualThemes:ApplyAll("retail"), true, "apply retail")
expect(KT.db.profile.unitFrames.portraitStyle, "none", "retail portraits")
expect(KT.db.profile.resourceBars.primary.texture, "Blizzard Raid Bar", "retail resource texture")
expect(KT.db.profile.resourceBars.general.frameArtKit, "default", "retail resource frame art kit")
expect(KT.db.profile.resourceBars.health.fillR, 0.12, "retail resource health color")
expect(_G.KullThranUINameplatesDB_Forever.borderStyle, "none", "retail nameplate border")
expect(KT.db.profile.unitFrames.player.borderColor.r, 0.20, "retail unit border color")
expect(KT.db.profile.unitFrames.frameArtKit, "default", "retail unit frame art kit")
expect(KT.db.profile.castbar.colorMode, "CUSTOM", "retail cast bar color mode")
expect(KT.db.profile.castbar.color.r, 0.12, "retail cast bar color")
expect(KT.db.profile.castbar.frameArtKit, "default", "retail cast bar frame art kit")
expect(KT.db.profile.cooldownManager.cdmBars.bars[1].frameArtKit, "default", "retail CDM frame art kit")

expect(KT.VisualThemes:ApplyAll("kui"), true, "restore KUI")
expect(KT.db.profile.actionbars.buttonStyle, "SIMPLICITY", "restore action style")
expect(KT.db.profile.actionbars.buttonShape, "HEXAGON", "restore action shape")
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
expect(_G.KullThranUINameplatesDB_Forever.borderStyle, "kullthran", "restore nameplate border")
expect(KT.db.profile.skin.stylePreset, "user_palette", "restore palette")
expect(KT.db.profile.unitFrames.player.classThemeStyle, nil, "kui no longer seeds dead classThemeStyle")
expect(KT.db.profile.unitFrames.player.borderColor.r, 0.55, "restore custom unit border color r")
expect(KT.db.profile.unitFrames.player.borderColor.g, 0.33, "restore custom unit border color g")
expect(KT.db.profile.unitFrames.player.borderColor.b, 0.77, "restore custom unit border color b")
expect(reloads, 3, "successful reload count")

KT.db.profile.partyFrames = nil
KT.db.profile.cooldownManager = nil
expect(KT.VisualThemes:ApplyAll("forever"), true, "apply with disabled modules")
expect(KT.db.profile.partyFrames.party.healthTexture, "Melli Dark", "disabled party theme seed")
expect(KT.db.profile.cooldownManager.cdmBars.bars[1].iconShape, "circle", "disabled CDM theme seed")
expect(KT.VisualThemes:ApplyAll("kui"), true, "restore disabled modules")
expect(KT.db.profile.partyFrames.party.healthTexture, nil, "disabled party KUI restore")
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
expect(reloads, 5, "failed apply reload count")

print("visual theme engine tests passed")
