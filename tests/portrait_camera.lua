local root = arg[1] or "."
_G.KullThranUI = {}
_G.UnitClass = function() error("camera must not infer model orientation from class") end
_G.GetShapeshiftForm = function() error("camera must not infer model orientation from form index") end
assert(loadfile(root .. "/KullThranUI/Modules/PortraitCamera.lua"))()
local KT = _G.KullThranUI
local function near(a,b) assert(math.abs(a-b)<.0001, tostring(a).." != "..tostring(b)) end
near(KT.Portrait3DYaw("player","left",nil,false,0),0)
for _,unit in ipairs({"player","target"}) do
    local _, zoom=KT.Portrait3DYaw(unit,"left",nil,false,0)
    near(zoom,1.12)
end
local _, petZoom=KT.Portrait3DYaw("pet","left",nil,false,0)
near(petZoom,1)
near(KT.Portrait3DYaw("target","right",nil,false,0),math.rad(291))
near(KT.Portrait3DYaw("player","left","flipped",false,0),math.rad(291))
near(KT.Portrait3DYaw("target","right","normal",false,0),0)
near(KT.Portrait3DYaw("player","left",nil,false,30),math.rad(30))
_G.UnitClass=function() return "Druid","DRUID" end
_G.UnitIsUnit=function(a,b) return a==b or (a=="target" and b=="player") end
for _,form in ipairs({1,5,4}) do
    _G.GetShapeshiftFormID=function() return form end
    local file=form==5 and 7749917 or 7749920
    local formModel={GetModelFileID=function() return file end}
    local playerYaw,_,_,shift=KT.Portrait3DYaw("player","left",nil,false,0,formModel)
    local targetYaw,_,_,targetShift=KT.Portrait3DYaw("target","right",nil,false,0,formModel)
    near(playerYaw,0)
    assert(formModel._ktPortraitAnimalMirror==false,"Target restores native camera ownership")
    near(targetYaw,0)
    near(shift,0)
    near(targetShift,0)
end
_G.GetShapeshiftFormID=nil
_G.UnitClass=function() return "Warrior","WARRIOR" end
local npc={GetModelFileID=function() return 999999 end}
local human={GetModelFileID=function() return 7478487 end}
near(KT.Portrait3DYaw("target","right",nil,false,0,npc),0)
near(KT.Portrait3DYaw("target","right",nil,false,0,human),math.rad(291))
near(KT.Portrait3DYaw("target","right",nil,false,20,npc),math.rad(20))
local model,calls={},{}
for _,method in ipairs({"SetFacing","SetRotation","SetViewTranslation","SetCamera","SetPortraitZoom","SetCamDistanceScale","SetPosition"}) do
    model[method]=function(self,...)
        self[method.."Value"]={...};calls[#calls+1]=method
    end
end
KT.ApplyPortrait3DCamera(model,math.rad(291),1.25,.2,-.1)
assert(model.SetFacingValue==nil,"modern model uses SetRotation")
near(model.SetRotationValue[1],math.rad(291))
assert(model.SetRotationValue[2]==false,"rotation preserves portrait camera mode")
near(model.SetViewTranslationValue[1],15)
near(model.SetCamDistanceScaleValue[1],.8)
near(model.SetPositionValue[2],.2)
assert(model.SetCameraValue==nil and calls[#calls]=="SetRotation","preserve the loaded portrait camera pivot")
KT.ApplyPortrait3DCamera(model,0,1,0,0)
near(model.SetRotationValue[1],0)
near(model.SetViewTranslationValue[1],0)
near(model.SetPositionValue[2],0)
near(model.SetPositionValue[3],0)
model.SetRotation=nil
KT.ApplyPortrait3DCamera(model,0,1,0,0)
near(model.SetFacingValue[1],0)
print("portrait_camera: ok")
