local root = arg[1] or "."
local function read(path)
    local file = assert(io.open(root .. "/" .. path))
    local value = file:read("*a"); file:close(); return value
end
local source = read("KullThranUI_UnitFrames/Modules/KUIUnitFrames/KUIUnitFrames.lua")
local theme, available = "retail", true
local ns = {}
local env = setmetatable({ns = ns, KT = {VisualThemes = {GetRenderedTheme = function() return theme end}},
    C_Texture = {GetAtlasInfo = function() if available then return {width=20,height=16} end end}}, {__index=_G})
local start = assert(source:find("function ns.ApplyGroupLeaderStyle(", 1, true))
local stop = assert(source:find("function ns.UnitInCombat(", start, true))
local run = assert(loadstring(source:sub(start, stop-1))); setfenv(run, env); run()
local tex = {shown=true}
function tex:ClearAllPoints() self.point=nil end
function tex:SetPoint(...) self.point={...} end
function tex:SetSize(w,h) self.w,self.h=w,h end
function tex:SetAtlas(value) self.atlas=value end
function tex:SetTexture(value) self.texture=value; self.atlas=nil end
function tex:SetTexCoord(...) self.coords={...} end
function tex:Hide() self.shown=false end
local portrait = {IsShown=function() return true end}
local health = {}
local frame = {LeaderIndicator=tex,Health=health,Portrait={backdrop=portrait},GetWidth=function() return 464 end}
for _,style in ipairs({"retail","forever"}) do
    theme=style
    tex.shown=true
    ns.RefreshGroupLeaderStyle(frame,"player",false)
    assert(tex.atlas=="UI-HUD-UnitFrame-Player-Group-LeaderIcon")
    assert(tex.w==40 and tex.h==32 and tex.shown)
    assert(tex.point[1]=="TOPLEFT" and tex.point[2]==portrait and tex.point[3]=="TOPRIGHT")
    assert(tex.point[4]==4 and tex.point[5]==18)
    ns.RefreshGroupLeaderStyle(frame,"target",true)
    assert(tex.atlas=="UI-HUD-UnitFrame-Player-Group-GuideIcon")
    assert(tex.point[1]=="TOPRIGHT" and tex.point[3]=="TOPLEFT" and tex.point[4]==-2 and tex.point[5]==22)
    tex.shown=false; ns.RefreshGroupLeaderStyle(frame,"target",false)
    assert(not tex.shown,"layout must not show non-leaders")
end
theme="classic"
ns.RefreshGroupLeaderStyle(frame,"player",false)
assert(tex.atlas==nil and tex.texture=="Interface\\GroupFrame\\UI-Group-LeaderIcon")
assert(tex.w==32 and tex.point[1]=="TOPLEFT" and tex.point[3]=="TOPLEFT" and tex.point[4]==8 and tex.point[5]==4)
ns.RefreshGroupLeaderStyle(frame,"target",false)
assert(tex.point[1]=="TOPRIGHT" and tex.point[3]=="TOPRIGHT" and tex.point[4]==-8)
theme="retail"; available=false
ns.RefreshGroupLeaderStyle(frame,"player",true)
assert(tex.texture=="Interface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES" and tex.coords[2]==0.296875)
frame.Portrait=nil
ns.RefreshGroupLeaderStyle(frame,"target",false)
assert(tex.point[2]==health and tex.point[1]=="BOTTOMRIGHT" and tex.point[3]=="TOPRIGHT")
theme="kui"; tex.shown=true
ns.RefreshGroupLeaderStyle(frame,"target",false)
assert(tex.shown and tex.w==14 and tex.point[2]==health and tex.point[4]==-2 and tex.point[5]==10)
ns.RefreshGroupLeaderStyle(frame,"player",false)
assert(not tex.shown,"KUI player keeps its existing absence of leader crown")
assert(source:find("frame.LeaderIndicator = tex",1,true))
assert(source:find("tex.PostUpdate = function(self, isLeader, isInLFGInstance)",1,true))
local preview=read("KullThranUI_UnitFrames/Modules/KUIUnitFrames/KUI_UnitFrames_Options.lua")
assert(preview:find("ns.ApplyGroupLeaderStyle({Health = frame.health}",1,true))
assert(preview:find("if frame.leaderIcon then frame.leaderIcon:Hide() end",1,true))
print("Group leader styles: passed")
