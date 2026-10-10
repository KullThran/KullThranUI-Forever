local root=arg[1] or "."
local now,kind,map=1000,"party",33
local dead=false
local callbacks={}
local function widget()
 local w={shown=false,width=271,height=150}
 function w:SetFont(path,size) self.font=path;self.fontSize=size;return true end
 function w:SetText(v) self.text=v end
 function w:SetSize(x,y) self.width=x;self.height=y end
 function w:SetWidth(v) self.width=v end
 function w:SetHeight(v) self.height=v end
 function w:GetWidth() return self.width end
 function w:GetHeight() return self.height end
 function w:Show() self.shown=true end
 function w:Hide() self.shown=false end
 function w:IsShown() return self.shown end
 function w:SetShown(v) self.shown=v end
 function w:SetScript(_,fn) self.callback=fn end
 function w:RegisterEvent() end
 function w:SetPoint(...) self.point={...} end
 function w:ClearAllPoints() self.point=nil end
 function w:CreateFontString() return widget() end
 function w:SetValue(v) self.value=v end
 for _,key in ipairs({"SetFrameStrata","SetBackdropColor","SetScale","SetJustifyH","SetTextColor","SetStatusBarTexture","SetMinMaxValues","SetStatusBarColor"}) do w[key]=function() end end
 return w
end
local db={enable=true,mplusTracker={enabled=true}}
local mod={GetDB=function() return db end}
local kt={FONT_PATH="AvantGarde.ttf",db={profile={}},GetModule=function(_,name) if name=="Enhancements" then return mod end end,
 AddBackdrop=function() end,RegisterMovableElements=function(self,entries) self.mover=entries[1] end,
 RegisterChatCommand=function(_,key,fn) callbacks[key]=fn end,Print=function() end}
local env=setmetatable({KT=kt,GetServerTime=function() return now end,time=function() return now end,
 UIParent={},CreateFrame=widget,GetInstanceInfo=function() return "Test Dungeon",kind,1,"Normal",5,nil,nil,map end,
 UnitGUID=function(unit) if unit=="player" then return "Player-1" end end,
 UnitIsDeadOrGhost=function() return dead end,
 EJ_GetInstanceForMap=function() return 1 end,EJ_GetEncounterInfoByIndex=function(i) return ({"Boss One","Boss Two"})[i] end,
 C_Timer={NewTicker=function(_,fn) return {tick=fn} end,After=function(delay,fn) table.insert(callbacks,{at=now+delay,fn=fn}) end}}, {__index=_G})
local function runTimers()
 table.sort(callbacks,function(a,b) return a.at<b.at end)
 while callbacks[1] do local t=table.remove(callbacks,1);now=math.max(now,t.at);t.fn() end
end
env._G=env
local function load()
 mod.mplusTrackerInitialized=nil;mod.mythicPlusTrackerMoverRegistered=nil;mod.mplusTimer=nil
 local f=assert(io.open(root.."/KullThranUI/Modules/Enhancements/Enhancements_ForeverDungeonTracker.lua"));local s=f:read("*a");f:close()
 local chunk=assert(loadstring(s));setfenv(chunk,env);chunk("KullThranUI",{KT=kt,Enhancements=mod})
 mod:RefreshMythicPlusTracker()
end
load()
assert(mod.mplusTrackerFrame.shown and db.mplusTracker.dungeonRun.started==1000)
now=1120;mod.mplusTimer.tick();assert(mod.mplusTrackerFrame.timer.text=="2:00")
local function event(name,...) mod.foreverDungeonEvents.callback(nil,name,...) end
-- Failed attempts do not mark kills; successful kills have elapsed splits.
event("ENCOUNTER_END",1,"Boss One",1,5,0);assert(not db.mplusTracker.dungeonRun.bosses[1].killed)
event("ENCOUNTER_END",1,"Boss One",1,5,1);assert(db.mplusTracker.dungeonRun.bosses[1].split==120)
-- Repeated notifications and a reload must not count the same death twice.
dead=true;event("PLAYER_DEAD");event("UNIT_HEALTH","player");assert(db.mplusTracker.dungeonRun.deaths==1)
load();event("UNIT_HEALTH","player");assert(db.mplusTracker.dungeonRun.deaths==1)
assert(mod.mplusTrackerFrame.timer.text=="2:00")
now=1180;event("BOSS_KILL",2,"Boss Two");assert(db.mplusTracker.dungeonRun.completed)
now=1280;mod.mplusTimer.tick();mod:RefreshMythicPlusTracker();assert(mod.mplusTrackerFrame.timer.text=="3:00")
-- A completed run can be explicitly restarted; leaving pauses, returning resumes.
callbacks.ktdungeon("reset");now=1300;kind="none";event("PLAYER_ENTERING_WORLD");assert(not mod.mplusTrackerFrame.shown)
now=1400;kind="party";event("PLAYER_ENTERING_WORLD");assert(mod.mplusTrackerFrame.timer.text=="0:20")
-- Raid and outdoor areas never start a run; a different map starts fresh.
kind="raid";event("PLAYER_ENTERING_WORLD");assert(not mod.mplusTrackerFrame.shown)
map=34;kind="party";event("PLAYER_ENTERING_WORLD");assert(db.mplusTracker.dungeonRun.elapsed==0)
-- Test mode is temporary and does not write the current run to SavedVariables.
local saved=db.mplusTracker.dungeonRun
callbacks.ktdungeon("test");assert(db.mplusTracker.dungeonRun==saved)
callbacks.ktdungeon("stop");assert(db.mplusTracker.dungeonRun==saved)
-- No journal: report observed bosses, do not invent a total or finish prematurely.
env.EJ_GetInstanceForMap=nil;map=35;event("PLAYER_ENTERING_WORLD")
event("ENCOUNTER_END",3,"Observed Boss",1,5,1)
assert(db.mplusTracker.dungeonRun.total==0 and not db.mplusTracker.dungeonRun.completed)
callbacks.ktdungeon("finish");assert(db.mplusTracker.dungeonRun.completed)
-- Unlock Mode updates both stores and reapplies the saved anchor.
kt.mover.savePosition(nil,"TOPLEFT","CENTER",333,-222)
mod:ApplyMythicPlusTrackerPosition();assert(mod.mplusTrackerFrame.point[4]==333)
-- A profile switch does not leak another profile's run.
db={enable=true,mplusTracker={enabled=true}};mod:RefreshMythicPlusTracker();assert(db.mplusTracker.dungeonRun.started==now)
-- Nameplate health spam is ignored before any instance lookup.
local lookups,info=0,env.GetInstanceInfo
env.GetInstanceInfo=function(...) lookups=lookups+1;return info(...) end
event("UNIT_HEALTH","nameplate7");assert(lookups==0)
env.GetInstanceInfo=info
-- Secret payloads (names, ids, party GUIDs) never raise errors or count.
local secret=setmetatable({},{__eq=function() error("compared a secret value") end})
env.issecretvalue=function(v) return v==nil and false or rawequal(v,secret) end
local before=db.mplusTracker.dungeonRun.deaths
env.UnitGUID=function(unit) if unit=="player" then return "Player-1" end return secret end
event("ENCOUNTER_END",secret,secret,1,5,1);event("UNIT_HEALTH","party1")
assert(db.mplusTracker.dungeonRun.deaths==before)
env.UnitGUID=function(unit) if unit=="player" then return "Player-1" end end;env.issecretvalue=nil
-- The journal is found through the player's UI map and matched by encounter ID,
-- so a kill is recorded even when the event name differs from the journal.
env.C_Map={GetBestMapForUnit=function() return 2000 end}
env.EJ_GetInstanceForMap=function(id) if id==2000 then return 77 end end
local selected
env.EJ_SelectInstance=function(j) selected=j end
env.EJ_GetEncounterInfoByIndex=function(i,j) if j==77 and selected==77 and i<=2 then return ({"Lord A","Lady B"})[i],nil,nil,nil,nil,nil,500+i end end
map=36;event("PLAYER_ENTERING_WORLD");runTimers()
assert(db.mplusTracker.dungeonRun.total==2 and db.mplusTracker.dungeonRun.bosses[2].id==502)
event("ENCOUNTER_END",502,"Localized Name",1,5,1);assert(db.mplusTracker.dungeonRun.bosses[2].killed)
event("ENCOUNTER_END",501,"Lord A",1,5,1);assert(db.mplusTracker.dungeonRun.completed)
-- A run entered before the journal answered picks up the boss list later.
env.EJ_GetInstanceForMap=nil;map=37;event("PLAYER_ENTERING_WORLD");assert(db.mplusTracker.dungeonRun.total==0)
env.EJ_GetInstanceForMap=function(id) if id==2000 then return 77 end end;runTimers()
assert(db.mplusTracker.dungeonRun.total==2 and not db.mplusTracker.dungeonRun.completed)
-- The simulation plays kills, a death and completion without saving anything.
saved=db.mplusTracker.dungeonRun
callbacks.ktdungeon("sim 2");assert(mod.mplusTrackerFrame.shown and mod.mplusTrackerFrame.title.text=="Simulated Dungeon")
runTimers();assert(mod.mplusTrackerFrame.details.text:find("Completed",1,true) and mod.mplusTrackerFrame.details.text:find("1 Deaths",1,true))
assert(mod.mplusTrackerFrame.progressText.text=="Bosses: 3 / 3" and db.mplusTracker.dungeonRun==saved)
callbacks.ktdungeon("stop");assert(mod.mplusTrackerFrame.title.text=="Test Dungeon")
local status=mod:GetDungeonTrackerStatus();assert(status.enabled and status.kind=="party" and status.shown)
-- Navigation must retain timer selection; the old Forever redirect removed it.
local file=assert(io.open(root.."/KullThranUI/Modules/Enhancements/Enhancements_Options.lua"))
local options=file:read("*a"):gsub("\r\n","\n");file:close()
local a=assert(options:find("local function GetActiveCategory()",1,true))
local b=assert(options:find("local function GetSystemSectionState",a,true))
local nav=assert(loadstring(options:sub(a,b-1).."return GetActiveCategory, SetActiveCategory"))
local uiDB={};setfenv(nav,{DB=function() return uiDB end})
local get,set=nav();set("timer");assert(get()=="timer" and uiDB.ui.activeEnhancementCategory=="timer")
-- Earlier builds saved enabled=false into every profile. The timer is on by
-- default and the one-time migration turns it back on, keeping later choices.
local function enhancementsDB(profile)
 local stub;stub=setmetatable({},{__index=function() return stub end,__call=function() return stub end})
 local m={};local k={IS_FOREVER=true,db={profile=profile},GetModule=function() end,NewModule=function() return m end}
 local e=setmetatable({KT=k,type=type,pairs=pairs,ipairs=ipairs},{__index=function(_,key) local v=_G[key];if v~=nil then return v end;return stub end})
 e._G=e
 local h=assert(io.open(root.."/KullThranUI/Modules/Enhancements/Enhancements.lua"));local src=h:read("*a");h:close()
 local c=assert(loadstring(src));setfenv(c,e);c("KullThranUI",{KT=k});return m:GetDB()
end
assert(enhancementsDB({}).mplusTracker.enabled==true)
local old={enhancements={mplusTracker={enabled=false}}}
assert(enhancementsDB(old).mplusTracker.enabled==true)
old.enhancements.mplusTracker.enabled=false;assert(enhancementsDB(old).mplusTracker.enabled==false)
print("PASS: Forever dungeon lifecycle, reload, boss splits, deaths, completion, pause/resume, preview isolation, mover, profile switch, secret payloads, journal lookup, simulation and default migration")
