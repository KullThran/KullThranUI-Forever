local root=arg[1] or "."
local path,enable,disable
local ns={oUF={AddElement=function(_,_,p,e,d) path,enable,disable=p,e,d end}}
local secret=setmetatable({}, {__eq=function() error("compared a secret GUID") end})
local visible=true
_G.UnitGUID=function() return secret end
_G.issecretvalue=function(v) return v==secret end
_G.UnitIsUnit=function(a,b) return a==b or (a=="target" and b=="player") end
_G.UnitIsConnected=function() return true end
_G.UnitIsVisible=function() return visible end
local model={}
function model:IsObjectType(kind) return kind=="PlayerModel" end
function model:SetUnit(unit) self.loadedUnit=unit;self.loads=(self.loads or 0)+1 end
function model:GetModelFileID() return self.modelID end
function model:ClearModel() self.loadedUnit=nil end
function model:SetModel(value) self.fallback=value end
function model:SetCamDistanceScale() end
function model:SetPortraitZoom() end
function model:SetPosition() end
function model:PostUpdate(unit,changed) self.cameraUnit=unit;self.changed=changed end
function model:Show() self.shown=true end
function model:Hide() self.shown=false end
local frame={unit="target",Portrait=model,events={}}
function frame:RegisterEvent(event,handler) self.events[event]=handler end
function frame:UnregisterEvent(event) self.events[event]=nil end
assert(loadfile(root.."/KullThranUI/Libraries/oUF/elements/portrait.lua"))("Test",ns)
assert(enable(frame,"target"))
path(frame,"UNIT_MODEL_CHANGED","player")
assert(model.loadedUnit=="target" and model.cameraUnit=="target","self-target keeps Target settings")
local loads=model.loads
path(frame,"UNIT_MODEL_CHANGED","party2")
assert(model.loads==loads,"unrelated unit cannot replace Target")
for _,event in ipairs({"PORTRAITS_UPDATED","UPDATE_SHAPESHIFT_FORM"}) do
    frame.events[event](frame,event)
    assert(model.loads>loads and model.cameraUnit=="target","unitless event reloads Target model")
    loads=model.loads
end
visible=false
model:ForceUpdate()
assert(not model.loadedUnit and model.fallback,"unavailable target uses fallback")
visible=true
model:ForceUpdate()
assert(model.loadedUnit=="target","target model restored when available")
path(frame,"OnUpdate","target")
assert(model.cameraUnit=="target","secret GUID does not break 3D polling")
loads=model.loads
model.modelID=nil
path(frame,"OnUpdate","target")
assert(model.loads==loads+1,"lost Target model reloads even at unchanged identity")
model.modelID=123
loads=model.loads
path(frame,"OnUpdate","target")
assert(model.loads==loads,"loaded Target model is retained during polling")
disable(frame)
assert(not model.shown and not frame.events.UPDATE_SHAPESHIFT_FORM,"disable removes model event")
print("portrait_element: ok")
