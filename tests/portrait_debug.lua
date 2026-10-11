local root=arg[1] or "."
_G.KullThranUI={}
_G.SlashCmdList={}
local restricted={}
_G.issecretvalue=function(v) return rawequal(v,restricted) end
_G.GetTime=function() return 42 end
local output={}
local originalPrint=print
_G.print=function(line) output[#output+1]=line end
assert(loadfile(root.."/KullThranUI/Modules/PortraitCameraDebug.lua"))()
local debug=_G.KullThranUI.Portrait3DDebug
local model={GetModelFileID=function() return restricted end,
    GetFacing=function() error("unavailable getter") end,
    GetPosition=function() return 0, .2, -.1 end}
assert(debug.Call(model,"GetModelFileID")=="<restricted>")
assert(debug.Call(model,"GetCamera")=="n/a")
assert(debug.Call(model,"GetFacing"):find("ERROR:",1,true))
assert(debug.Call(model,"GetPosition")=="0,0.2,-0.1")
debug.Record(model,"ignored","target")
assert(#debug.log==0,"debug disabled by default")
SlashCmdList.KTPORTRAITDEBUG("on")
for i=1,100 do debug.Record(model,"model-loaded","target") end
assert(#debug.log==80,"trace has a bounded buffer")
_G.KullThranUI.DebugPortrait3DState=function(unit) return {"snapshot "..unit} end
SlashCmdList.KTPORTRAITDEBUG("dump")
assert(table.concat(output,"\n"):find("snapshot target",1,true),"dump includes Target snapshot")
SlashCmdList.KTPORTRAITDEBUG("off")
debug.Record(model,"ignored","player")
assert(#debug.log==80)
SlashCmdList.KTPORTRAITDEBUG("clear")
assert(#debug.log==0)
local cameraCalls={}
_G.KullThranUI.DebugSetPortraitCamera=function(...) cameraCalls[#cameraCalls+1]={...} end
_G.KullThranUI.DebugProbeRestedGlow=function() cameraCalls.probe=true end
_G.KullThranUI.DebugUnitFrameGlowState=function(unit) return {"glow snapshot "..unit} end
SlashCmdList.KTPORTRAITDEBUG("camera player 69 -2")
assert(cameraCalls[1][1]=="player" and cameraCalls[1][2]==69 and cameraCalls[1][3]==-2)
SlashCmdList.KTPORTRAITDEBUG("camera reset")
assert(cameraCalls[2][1]=="player" and cameraCalls[2][2]==nil)
assert(cameraCalls[3][1]=="target" and cameraCalls[3][2]==nil)
SlashCmdList.KTPORTRAITDEBUG("glow")
assert(cameraCalls.probe and table.concat(output,"\n"):find("glow snapshot target",1,true))
assert(SLASH_KTPORTRAITDEBUG2=="/ktufdebug")
model._ktPortraitAnimalUnit="player"
model._ktPortraitCameraApplied={yaw=0,zoom=1.4,x=0,y=0,viewShift=0}
_G.KullThranUI_UF_Player={Portrait={backdrop={_3d=model}}}
local probes={}
_G.KullThranUI.ApplyPortrait3DCamera=function(value)
    assert(value==model)
    probes[#probes+1]=value._ktDruidDebugAngle or "reset"
end
for _,degrees in ipairs({0,90,180,270}) do
    SlashCmdList.KTPORTRAITDEBUG("druid")
    assert(model._ktDruidDebugAngle==degrees)
end
SlashCmdList.KTPORTRAITDEBUG("druid 69")
assert(model._ktDruidDebugAngle==69)
SlashCmdList.KTPORTRAITDEBUG("druid reset")
assert(model._ktDruidDebugAngle==nil and probes[#probes]=="reset")
assert(table.concat(output,"\n"):find("DRUID immediate",1,true))
_G.print=originalPrint
print("portrait_debug: ok")
