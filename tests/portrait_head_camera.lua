local root=arg[1] or "."
_G.KullThranUI={}
assert(loadfile(root.."/KullThranUI/Modules/PortraitCamera.lua"))()
local KT=_G.KullThranUI
local function near(a,b) assert(math.abs(a-b)<.000001,tostring(a).." != "..tostring(b)) end
local camera={.94120013713837,.61768782138824,.62998449802399}
local focus={.62914574146271,.32201227545738,.53176963329315}
KT.GetNativeDruidPortraitCamera=function()
    return {cx=camera[1],cy=camera[2],cz=camera[3],tx=focus[1],ty=focus[2],tz=focus[3],zoom=1.4,source="target"}
end
local model={}
function model:SetCamera(index) self.cameraIndex=index end
function model:SetPortraitZoom(value) self.portraitZoom=value end
function model:SetCamDistanceScale(value) self.distanceScale=value end
function model:SetRotation(value)
    self.rotation=value
    -- The client's native creature camera follows model rotation.
    local c,s=math.cos(value),math.sin(value)
    self.camera={camera[1]*c-camera[2]*s,camera[1]*s+camera[2]*c,camera[3]}
end
function model:SetPosition(...) self.position={...} end
function model:SetViewTranslation(...) self.view={...} end
function model:MakeCurrentCameraCustom() self.custom=true end
function model:SetCameraPosition(...) self.camera={...} end
function model:SetCameraTarget(...) self.focus={...} end
for i=1,3 do
    KT.ApplyAnimalPortraitCamera(model,1.4)
    assert(model._ktPortraitAnimalCamera=="head-rotation-locked-camera-from-target")
    for j=1,3 do near(model.camera[j],camera[j]);near(model.focus[j],focus[j]) end
    assert(model.cameraIndex==0 and model.portraitZoom==1)
    near(model.distanceScale,1/1.4)
    -- The rotated head must remain at the native head focus.
    local c,s=math.cos(model.rotation),math.sin(model.rotation)
    near(focus[1]*c-focus[2]*s+model.position[1],focus[1])
    near(focus[1]*s+focus[2]*c+model.position[2],focus[2])
    near(model.position[3],0)
    -- Change the horizontal viewing side without altering elevation.
    local dx,dy=camera[1]-focus[1],camera[2]-focus[2]
    near(dx*c+dy*s,dx)
    near(-dx*s+dy*c,-dy)
end
model._ktPortraitAnimalMirror=true
model._ktPortraitAnimalUnit="player"
KT.ApplyPortrait3DCamera(model,0,1.4,0,0,0)
near(model.rotation,2*math.atan2(camera[2]-focus[2],camera[1]-focus[1]))
local c,s=math.cos(model.rotation),math.sin(model.rotation)
near(focus[1]*c-focus[2]*s+model.position[1],focus[1])
near(focus[1]*s+focus[2]*c+model.position[2],focus[2])
near(model.view[1],0);near(model.view[2],0)
model._ktDruidDebugAngle=90
KT.ApplyPortrait3DCamera(model,0,1.4,0,0,0)
near(model.rotation,math.pi/2)
local c,s=math.cos(model.rotation),math.sin(model.rotation)
near(focus[1]*c-focus[2]*s+model.position[1],focus[1])
near(focus[1]*s+focus[2]*c+model.position[2],focus[2])
model._ktDruidDebugAngle=nil
local target={SetPortraitZoom=model.SetPortraitZoom,SetCamDistanceScale=model.SetCamDistanceScale,
    SetRotation=model.SetRotation,SetPosition=model.SetPosition,SetViewTranslation=model.SetViewTranslation}
KT.ApplyPortrait3DCamera(target,0,1.4,0,0,0)
near(target.rotation,0);near(target.position[1],0);near(target.position[2],0)
assert(target.cameraIndex==nil and target._ktPortraitAnimalCamera==nil)
KT.GetNativeDruidPortraitCamera=function() return nil end
KT.ApplyAnimalPortraitCamera(model,1.4)
assert(model._ktPortraitAnimalCamera:find("native fallback",1,true))
print("portrait_head_camera: ok")
