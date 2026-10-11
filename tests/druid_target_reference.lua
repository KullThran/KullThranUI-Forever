local root=arg[1] or "."
_G.KullThranUI={}
assert(loadfile(root.."/KullThranUI/Modules/PortraitCamera.lua"))()
local KT=_G.KullThranUI
local fileID=7749920
local function native()
    local m={}
    function m:GetModelFileID() return self.file or fileID end
    function m:GetCameraPosition() return .98,.65,.64 end
    function m:GetCameraTarget() return .63,.32,.53 end
    function m:SetSize(w,h) self.width,self.height=w,h end
    function m:SetKeepModelOnHide() end
    function m:Hide() self.hidden=true end
    function m:SetScript(event,callback) self.callback=callback end
    function m:ClearModel() self.clears=(self.clears or 0)+1 end
    function m:SetUnit(unit) self.unit=unit;self.file=fileID end
    function m:SetPortraitZoom() end
    function m:SetCamDistanceScale() end
    function m:SetPosition() end
    function m:SetViewTranslation() end
    function m:SetRotation() end
    return m
end
local player=native();player._ktPortraitAnimalUnit="player"
local target=native();target._ktPortraitCameraApplied={yaw=0,zoom=1.4}
_G.KullThranUI_UF_Target={Portrait={backdrop={_3d=target}}}
_G.UnitIsUnit=function(a,b) return a=="player" and b=="target" end
_G.CreateFrame=function() error("Target already provides the correct reference") end
local camera=KT.GetNativeDruidPortraitCamera(player)
assert(camera.source=="target" and camera.zoom==1.4 and camera.cx==.98 and camera.ty==.32)
assert(target._ktPortraitCameraApplied.zoom==1.4,"reading Target must not change its camera")
_G.UnitIsUnit=function() return false end
local auxiliary=native()
_G.CreateFrame=function(kind) assert(kind=="PlayerModel");return auxiliary end
camera=KT.GetNativeDruidPortraitCamera(player)
assert(camera.source=="native-target-reference" and camera.zoom==1)
assert(auxiliary.hidden and auxiliary.unit=="player" and auxiliary.clears==1)
KT.GetNativeDruidPortraitCamera(player)
assert(auxiliary.clears==1,"camera refresh does not reload the reference unnecessarily")
fileID=7749917;KT.GetNativeDruidPortraitCamera(player)
assert(auxiliary.clears==2,"changing cat to bear refreshes the native reference")
print("druid_target_reference: ok")
