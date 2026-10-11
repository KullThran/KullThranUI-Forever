local root=arg[1] or "."
local function read(rel) local f=assert(io.open(root.."/"..rel));local s=f:read("*a");f:close();return s end
local first,last="Xardas","Guldarovich"
local env=setmetatable({KT={},GetBuildInfo=function() return "1.60.1","70338","date",160001,"Forever" end,
 UnitName=function() return first,last end,issecretvalue=function() return false end}, {__index=_G})
env._G=env
local function run(s) local c=assert(loadstring(s));setfenv(c,env);return c() end
local core=read("KullThranUI/KullThranUI.lua")
local a=assert(core:find("local _, _, _, kuiInterface",1,true))
local b=assert(core:find("-- Profile data is not portable",a,true))
run(core:sub(a,b-1)) -- actual startup and formatter together, no fake Forever flag
assert(not env.KT.IS_FOREVER,"reproduce legacy detection failure without migrating profiles")
assert(env.KT:GetUnitDisplayName("nameplate1")=="Xardas Guldarovich")
local friendly=read("KullThranUI_Nameplates/Modules/Nameplates/Nameplates_Friendly.lua")
env.ns={KT=env.KT};env.IsAccessible=function() return true end
 a=assert(friendly:find("local function UnitDisplayName(unit)",1,true));b=assert(friendly:find("GetGuildInfo = function",a,true))
local display=run(friendly:sub(a,b-1)..'return UnitDisplayName')
env.UnitDisplayName=display
local function fs() return {SetText=function(self,t) self.text=t end} end
local overlay={unit="nameplate1",name=fs()}
env.UnitIsPlayer=function() return true end;env.GetFriendlyPlayerNameTextSize=function() return 12 end
env.StyleStableOverlayFont=function() end
a=assert(friendly:find("UpdateStableOverlayContent = function(overlay)",1,true))
b=assert(friendly:find("    if isPlayer then",a,true))
run(friendly:sub(a,b-1)..'end');env.UpdateStableOverlayContent(overlay)
assert(overlay.name.text=="Xardas Guldarovich","actual player name-only overlay shows surname")
env.FriendlyFrame={}
a=assert(friendly:find("function FriendlyFrame:UpdateName()",1,true));b=assert(friendly:find("    if UnitIsPlayer(unit) then",a,true))
run(friendly:sub(a,b-1)..'end')
local plate=setmetatable({unit="nameplate1",name=fs()},{__index=env.FriendlyFrame})
plate:UpdateName();assert(plate.name.text=="Xardas Guldarovich")
local enemy=read("KullThranUI_Nameplates/Modules/Nameplates/Nameplates.lua")
env.NameplateFrame={};env.SyncPlateUnitToken=function(f) return f.unit end;env.ns._IsSecretValue=function() return false end
a=assert(enemy:find("function NameplateFrame:UpdateName()",1,true));b=assert(enemy:find("local function EstimateTextWidth",a,true))
run(enemy:sub(a,b-1))
local hostile=setmetatable({unit="nameplate1",name=fs()},{__index=env.NameplateFrame})
hostile:UpdateName();assert(hostile.name.text=="Xardas Guldarovich")
first,last="학흑","새성씨"
env.UpdateStableOverlayContent(overlay);plate:UpdateName();hostile:UpdateName()
assert(overlay.name.text=="학흑 새성씨" and plate.name.text==overlay.name.text and hostile.name.text==overlay.name.text)
last=nil;env.UpdateStableOverlayContent(overlay);assert(overlay.name.text==first)
print("PASS: actual startup detection, friendly player name-only overlay, friendly health plates and enemy nameplates render surnames and refresh changed names")
