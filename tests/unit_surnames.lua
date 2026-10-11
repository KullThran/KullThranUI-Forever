local root=arg[1] or "."
local function read(path) local f=assert(io.open(root.."/"..path)); local s=f:read("*a"); f:close(); return s end
local core=read("KullThranUI/KullThranUI.lua")
local a=assert(core:find("-- WoW Forever characters have a surname",1,true))
local b=assert(core:find("-- Profile data is not portable",a,true))
local names,secret={},{}
local function SECRET(s) local v=setmetatable({s=s},{__concat=function() error("concat on secret") end}); secret[v]=true; return v end
local env=setmetatable({KT={IS_FOREVER=true},
 Constants={CharacterNameSeparatorConsts={CHARACTERNAME_SURNAME_SEPARATOR=" "}},
 UnitName=function(u) local n=names[u]; if n then return n[1],n[2] end end,
 issecretvalue=function(v) return secret[v]==true end,
 C_StringUtil={WrapString=function(infix,prefix,suffix)
  local function raw(v) return secret[v] and v.s or v end
  local out=(raw(prefix) or "")..raw(infix)..(raw(suffix) or "")
  if secret[infix] or secret[prefix] or secret[suffix] then return SECRET(out) end
  return out end}},{__index=_G})
env._G=env
local chunk=assert(loadstring(core:sub(a,b-1))); setfenv(chunk,env); chunk()
local KT=env.KT
names.target={"Arthas","Menethil"}; assert(KT:GetUnitDisplayName("target")=="Arthas Menethil")
names.target={"Hogger",nil}; assert(KT:GetUnitDisplayName("target")=="Hogger","NPCs keep their name")
names.target={"Jaina",""}; assert(KT:GetUnitDisplayName("target")=="Jaina","empty surname adds no separator")
local sname=SECRET("Sylvanas"); names.target={sname,SECRET("Windrunner")}
local full=KT:GetUnitDisplayName("target"); assert(secret[full] and full.s=="Sylvanas Windrunner","secret names are joined via WrapString")
env.C_StringUtil=nil; assert(KT:GetUnitDisplayName("target")==sname,"secret name without WrapString falls back to the first name")
names.target={"Thrall","Durotan"}; assert(KT:GetUnitDisplayName("target")=="Thrall Durotan")
assert(KT:GetUnitDisplayName("none")==nil and KT:GetUnitDisplayName(nil)==nil)
KT.IS_FOREVER=false; names.target={"Anduin","Stormrage"}
assert(KT:GetUnitDisplayName("target")=="Anduin","Retail returns the realm second; never append it")
-- Real client detection must work without forcing IS_FOREVER in the test.
-- Extra GetBuildInfo returns must not become the base argument to tonumber.
KT.IS_FOREVER=false
names.target={"Xardas","Guldarovich"}
env.GetBuildInfo=function() return "1.60.1", "70338", "date", 160001, "Forever" end
assert(KT:GetUnitDisplayName("target")=="Xardas Guldarovich")
assert(KT.IS_FOREVER==false,"name rendering does not mutate profile/client flags")
env.GetBuildInfo=function() return "1.60.1", "70338", "date", "16001", "Forever" end
assert(KT:GetUnitDisplayName("target")=="Xardas Guldarovich")
env.GetBuildInfo=function() return "12.1.0", "69933", "date", 120100, "Retail" end
assert(KT:GetUnitDisplayName("target")=="Xardas","Retail never appends realms")
env.GetBuildInfo=nil
local uf=read("KullThranUI_UnitFrames/Modules/KUIUnitFrames/KUIUnitFrames.lua")
assert(uf:find('oUF.Tags.Methods["name"] = function(unit, realUnit)',1,true),"unit frame [name] tag shows the surname")
local np=read("KullThranUI_Nameplates/Modules/Nameplates/Nameplates.lua")
assert(np:find("displayName = core:GetUnitDisplayName(unit)",1,true),"enemy nameplates show the surname")
local fr=read("KullThranUI_Nameplates/Modules/Nameplates/Nameplates_Friendly.lua")
assert(select(2,fr:gsub("[^%w]UnitDisplayName%(unit%)",""))==3,"friendly nameplates show the surname")
print("unit_surnames ok")
