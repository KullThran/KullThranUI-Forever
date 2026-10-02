local function expect(actual, expected, label)
    if actual ~= expected then
        error(string.format('%s: expected %s, got %s', label, tostring(expected), tostring(actual)))
    end
end

local profile = {
    barGlows = {},
    specProfiles = {
        frost = { barGlows = { usableVisibility = { cooldowns = { barMode = 'usable_shift', spells = {} } } } },
    },
}
local usable = {}
local insufficient = {}
local cooldown = {}
local gcd = {}
local charges = {}
local recharging = {}
local ticker
_G.KT = { _unlockActive = false }
_G.issecretvalue = function() return false end
_G.C_Spell = {
    IsSpellUsable = function(id) return usable[id] == true, insufficient[id] == true end,
    GetSpellCooldown = function(id) return { isOnGCD = gcd[id] == true } end,
    GetSpellCooldownDuration = function(id) return cooldown[id] and {} or nil end,
    GetSpellChargeDuration = function(id) return recharging[id] and {} or nil end,
    GetSpellCharges = function(id) return charges[id] end,
}
_G.C_SpellBook = {
    FindSpellOverrideByID = function(id) return id == 100 and 101 or id end,
}
_G.C_Timer = {
    After = function(_, fn) fn() end,
    NewTicker = function(_, fn)
        ticker = { callback = fn, cancelled = false }
        function ticker:Cancel() self.cancelled = true end
        return ticker
    end,
}
_G.CreateFrame = function()
    local frame = {}
    function frame:RegisterEvent() end
    function frame:RegisterUnitEvent() end
    function frame:SetScript(_, fn) self.onEvent = fn end
    return frame
end

local function Icon(baseID, liveID)
    local icon = { _baseSpellID = baseID, _spellID = liveID, alpha = 1 }
    function icon:SetAlpha(alpha) self.alpha = alpha end
    function icon:IsShown() return true end
    icon._cooldown = {}
    function icon._cooldown:SetDrawSwipe(value) icon.drawSwipe = value end
    function icon._cooldown:SetHideCountdownNumbers(value) icon.hideDuration = value end
    function icon._cooldown:SetDrawEdge(value) icon.drawEdge = value end
    icon._tex = { SetDesaturation = function(_, value) icon.desaturation = value end }
    icon._chargeText = { Hide = function() icon.chargeTextHidden = true end }
    return icon
end

local first = Icon(100, 101)
local second = Icon(200, 200)
local layouts = 0
local ns = {
    KUI_CDM = { db = { profile = profile } },
    cdmBarIcons = { cooldowns = { first, second } },
    cdmBarFrames = { cooldowns = { IsShown = function() return true end, GetAlpha = function() return 0.4 end } },
    barDataByKey = { cooldowns = { showCooldownText = true } },
    LayoutCDMBar = function() layouts = layouts + 1 end,
}

assert(loadfile('KullThranUI_CooldownManager/Modules/KUICooldownManager/KUICdmUsableVisibility.lua'))('KullThranUI_CooldownManager', ns)

ns.SetCDMUsableVisibilityMode('cooldowns', 100, 'usable', 'spell')
expect(first.alpha, 0, 'base ID rule hides transformed spell')
expect(first._kuiUsableShiftHidden, false, 'plain mode preserves slot')
expect(second.alpha, 1, 'spell rule leaves other icon alone')
expect(ticker ~= nil, true, 'rules start evaluator ticker')

usable[101] = true
ns.EvaluateCDMUsableVisibility()
expect(first.alpha, 1, 'usable transformed spell becomes visible')

usable[101], insufficient[101] = false, true
ns.EvaluateCDMUsableVisibility()
expect(first.alpha, 1, 'low resources do not hide otherwise usable spell')
usable[101], insufficient[101], cooldown[101] = true, false, true
ns.EvaluateCDMUsableVisibility()
expect(first.alpha, 0, 'until usable also requires cooldown ready')
cooldown[101] = false

charges[200] = { currentCharges = 1, maxCharges = 2 }
recharging[200] = true
ns.SetCDMCooldownStateModifier('cooldowns', 200, 'hide_swipe_charges', true, 'spell')
expect(second.drawSwipe, false, 'charge modifier hides recharge swipe')
ns.SetCDMCooldownStateModifier('cooldowns', 200, 'hide_duration_charges', true, 'spell')
expect(second.hideDuration, true, 'charge modifier hides recharge duration')
ns.SetCDMUsableVisibilityMode('cooldowns', 200, 'hidden_cd_ready', 'spell')
expect(second.alpha, 1, 'recharging charge spell is on cooldown')
ns.SetCDMCooldownStateModifier('cooldowns', 200, 'stay_hidden_while_charges_remain', true, 'spell')
expect(second.alpha, 0, 'charge modifier keeps CD-ready mode hidden while charges remain')
ns.SetCDMCooldownStateModifier('cooldowns', 200, 'stay_hidden_while_charges_remain', false, 'spell')
expect(second.alpha, 1, 'disabling charge modifier restores icon')

cooldown[200], insufficient[200] = true, true
ns.SetCDMCooldownStateModifier('cooldowns', 200, 'keep_colored_on_cd', true, 'spell')
expect(second.desaturation, nil, 'keep colored preserves insufficient-resource feedback')
insufficient[200] = false
ns.EvaluateCDMUsableVisibility()
expect(second.desaturation, 0, 'keep colored removes cooldown desaturation')
cooldown[200] = false

usable[101] = false
ns.SetCDMUsableVisibilityMode('cooldowns', 100, 'usable_shift', 'spell')
expect(first._kuiUsableShiftHidden, true, 'shift mode removes slot')
local hiddenLayouts = layouts
usable[101] = true
ns.EvaluateCDMUsableVisibility()
expect(first._kuiUsableShiftHidden, false, 'slot returns when spell is usable')
expect(layouts, hiddenLayouts + 1, 'shift state change relayouts bar')

cooldown[101] = true
ns.SetCDMUsableVisibilityMode('cooldowns', 100, 'lower_alpha_on_cd', 'spell')
expect(first.alpha, 0.5, 'lower alpha mode dims on cooldown')
cooldown[101] = false

usable[101], usable[200] = false, false
ns.SetCDMUsableVisibilityMode('cooldowns', 100, 'usable_shift', 'bar_all_specs')
expect(profile.barGlows.usableVisibility.cooldowns, nil, 'all-spec scope clears current override')
expect(profile.specProfiles.frost.barGlows.usableVisibility.cooldowns, nil, 'all-spec scope clears saved override')
expect(first.alpha, 0, 'all-spec rule affects first icon')
expect(second.alpha, 0, 'all-spec rule affects whole bar')

ns.SetCDMUsableVisibilityMode('cooldowns', 100, 'always', 'spell')
expect(first.alpha, 1, 'spell rule overrides all-spec bar rule')
expect(second.alpha, 0, 'bar fallback remains for other icon')

ns._nativeCDMFrameData = { [first] = true }
usable[101] = true
ns.EvaluateCDMUsableVisibility()
expect(first.alpha, 0.4, 'native icon restores bar alpha')

print('cdm usable visibility tests passed')
