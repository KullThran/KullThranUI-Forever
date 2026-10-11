local root = arg[1] or "."
local f = assert(io.open(root .. "/KullThranUI_UnitFrames/Modules/KUIUnitFrames/KUIUnitFrames.lua"))
local source = f:read("*a"); f:close()
local first = assert(source:find("function ns.UpdatePowerBackground(", 1, true))
local last = assert(source:find("-- The native boss sheet's circular opening", first, true))
local capacity = 0
local ns = { SafeCall = function(fn, ...) return fn(...) end }
local env = setmetatable({ ns = ns, UnitPowerMax = function() return capacity end }, {__index = _G})
local run = assert(loadstring(source:sub(first, last-1))); setfenv(run, env); run()
local function texture()
    return { SetAlpha = function(self, a) self.alpha = a end,
        SetColorTexture = function(self, ...) self.color = {...} end }
end
local power = {bg = texture(), fill = texture()}
function power:GetStatusBarTexture() return self.fill end
ns.UpdatePowerBackground(power, "target", {})
assert(power.fill.alpha == 0 and power.bg.alpha == 0, "resource-less NPC cannot paint a white fill")
capacity = 100
ns.UpdatePowerBackground(power, "target", {powerBarOpacity = 75})
assert(power.fill.alpha == .75 and power.bg.alpha == .75, "switching to a caster restores opacity")
assert(power.bg.color[1] == 17/255, "hostility must not lighten the background")
capacity = 0
ns.UpdatePowerBackground(power, "player", {})
assert(power.fill.alpha == 1, "player resource transitions are preserved")
capacity = 100
ns.UpdatePowerBackground(power, "target", {powerBarOpacity=.5, customPowerBgColor={r=.2,g=.3,b=.4}})
assert(power.bg.alpha == .5 and power.bg.color[2] == .3, "custom background and opacity survive updates")
env.issecretvalue = function() return true end
capacity = 0
ns.UpdatePowerBackground(power, "target", {})
assert(power.fill.alpha == 1, "secret power capacity is not interpreted as empty")
-- A resource-less NPC seen out of combat stays empty when its capacity turns secret in combat,
-- until the target selection changes.
env.issecretvalue = nil
ns.powerTargetSerial = 5
capacity = 0
ns.UpdatePowerBackground(power, "target", {})
env.issecretvalue = function() return true end
ns.UpdatePowerBackground(power, "target", {})
assert(power.fill.alpha == 0, "secret capacity keeps the no-resource state learned out of combat")
ns.powerTargetSerial = 6
ns.UpdatePowerBackground(power, "target", {})
assert(power.fill.alpha == 1, "a new target selection forgets it")
env.issecretvalue = nil
-- Atlas application must preserve the configured power texture and leave
-- subsequent target changes free to use oUF's resource colour.
first = assert(source:find("ns.AtlasFill = {}", 1, true))
last = assert(source:find("local function ApplyHealthBarTexture", first, true))
run = assert(loadstring(source:sub(first, last-1))); setfenv(run, env); run()
power._kuiAtlasFill = true
power.texture = "configured-shared-texture"
function power:SetStatusBarTexture(t) self.texture = t end
ns.AtlasFill.Apply(nil, power, "target", {})
assert(power.texture == "configured-shared-texture" and power._kuiAtlasFill == nil,
    "decorative atlases cannot force Power white or retain a stale resource atlas")
-- Exercise the actual texture/opacity refresh after a zero-resource update.
-- Previously these paths restored a pale background and made the fill visible
-- until the next UNIT_POWER event.
env.db = {profile={target={powerBarOpacity=75}}}
env.healthBarTextures={ ["Melli Dark"]="pale-health-background" }
env.ResolveSharedTexturePath=function() return "shared-bar-texture" end
env.UnsnapTex=function() end
local owner={unit="target",Power=power}
function power:GetParent() return owner end
function power:SetStatusBarTexture(path) self.texture=path;self.fill.alpha=1 end
function power.bg:SetTexture(path) self.path=path end
function power.bg:SetVertexColor(...) self.vertex={...} end
local health={bg=texture(),fill=texture()}
function health:GetParent() return owner end
function health:SetStatusBarTexture(path) self.texture=path end
function health:GetStatusBarTexture() return self.fill end
health.bg.SetTexture=power.bg.SetTexture
health.bg.SetVertexColor=power.bg.SetVertexColor
first=assert(source:find("local function ApplyHealthBarTexture(",1,true))
last=assert(source:find("--  Bar Fill Opacity",first,true))
run=assert(loadstring(source:sub(first,last-1).."\nreturn ApplyHealthBarTexture"));setfenv(run,env)
local applyTexture=run()
capacity=0
applyTexture(health,"target")
assert(power.fill.alpha==0 and power.bg.alpha==0,"texture refresh cannot revive empty resource")
assert(power.bg.path~="pale-health-background","Power cannot inherit pale Health background")
first=assert(source:find("local function ApplyPowerBarAlpha(",1,true))
last=assert(source:find("--  Dark Mode",first,true))
run=assert(loadstring(source:sub(first,last-1).."\nreturn ApplyPowerBarAlpha"));setfenv(run,env)
local applyOpacity=run()
power.fill.alpha,power.bg.alpha=1,1
applyOpacity(power,"target")
assert(power.fill.alpha==0 and power.bg.alpha==0,"opacity refresh cannot revive empty resource")
capacity=100
applyTexture(health,"target")
applyOpacity(power,"target")
assert(power.fill.alpha==.75 and power.bg.alpha==.75,"caster restores configured opacity")
assert(power.bg.color[1]==17/255,"caster keeps the dark background")
print("power_background: ok")
