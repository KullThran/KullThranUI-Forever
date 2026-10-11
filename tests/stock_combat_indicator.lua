local root = arg[1] or "."
local f = assert(io.open(root .. "/KullThranUI_UnitFrames/Modules/KUIUnitFrames/KUIUnitFrames.lua"))
local source = f:read("*a"); f:close()
local theme = "kui"
local ns = { IsStockStyle = function()
    return theme == "retail" or theme == "forever" or theme == "classic"
end }
local indicator = { shown = true }
function indicator:Hide() self.shown = false end
local callback = assert(source:match('combat%.PostUpdate = (function%(self%)%s+if ns%.IsStockStyle%(%) then self:Hide%(%) end%s+end)'))
local run = assert(loadstring("return " .. callback))
setfenv(run, {ns = ns})
indicator.PostUpdate = run()
for _, style in ipairs({"retail", "forever", "classic", "kui"}) do
    theme = style
    -- Simulate oUF showing the generic indicator on UNIT_FLAGS.
    indicator.shown = true
    indicator:PostUpdate(true)
    assert(indicator.shown == (style == "kui"), "UNIT_FLAGS cannot resurrect KUI combat art in " .. style)
end
local first = assert(source:find('    local combatStyle = NormalizeCombatIndicatorStyle(playerDB.combatIndicatorStyle)',1,true))
local last = assert(source:find('    if frame._updateRestingIndicatorLayout then',first,true))
local frame = {CombatIndicator = indicator, enabled = true}
function frame:IsElementEnabled() return self.enabled end
function frame:DisableElement() self.enabled = false end
function frame:EnableElement() self.enabled = true end
function indicator:ForceUpdate() self.shown = true; self:PostUpdate(true) end
run = assert(loadstring(source:sub(first,last-1)))
setfenv(run, {ns=ns, frame=frame, playerDB={}, NormalizeCombatIndicatorStyle=function() return "standard" end})
for _, style in ipairs({"retail", "forever", "classic", "kui"}) do
    theme = style
    run()
    assert(frame.enabled == (style == "kui"), "refresh enables KUI combat only in KUI Style")
    assert(indicator.shown == (style == "kui"), "refresh restores visibility when returning to KUI Style")
end
assert(source:find('combatIcon:SetPoint("CENTER", frame._kuiLevelCircle, "CENTER", 0, 0)',1,true),
    "Blizzard icon overlays the level circle, without inheriting the number's text nudge")
print("stock_combat_indicator: ok")
