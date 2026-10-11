local root=arg[1] or "."
local f=assert(io.open(root.."/KullThranUI_UnitFrames/Modules/KUIUnitFrames/KUIUnitFrames.lua"))
local source=f:read("*a");f:close()
local function region()
    local r={shown=false}
    function r:ClearAllPoints() self.point=nil end
    function r:SetPoint(...) self.point={...} end
    function r:SetWidth(v) self.width=v end
    function r:SetJustifyH(v) self.justify=v end
    function r:SetParent(v) self.parent=v end
    function r:SetAlpha(v) self.alpha=v end
    function r:Show() self.shown=true end
    function r:Hide() self.shown=false end
    return r
end
local KT, ns={}, {UsesModernNumbers=function() return true end}
local settings={leftTextContent="perhp",rightTextContent="curhp",centerTextContent="name",frameWidth=181}
local env=setmetatable({KT=KT,ns=ns,GetSettingsForUnit=function() return settings end,
    db={profile={portraitStyle="circular"}},SetFSFont=function() end,ApplyClassColor=function() end,
    EstimateUFTextWidth=function() return 30 end,PP={Point=function(fs,...) fs:SetPoint(...) end,
    Width=function(fs,w) fs:SetWidth(w) end}}, {__index=_G})
local a=assert(source:find("local function BuildTextPositioner(",1,true))
local b=assert(source:find("local function AnchorNoPortraitClassificationIndicator",a,true))
local run=assert(loadstring(source:sub(a,b-1).."\nreturn BuildTextPositioner"));setfenv(run,env)
local positioner=run()
local left,right,center=region(),region(),region()
local health={GetWidth=function() return 180 end}
positioner(left,right,center,"player",health,{"name","both","none"},true)(settings)
assert(left.shown and right.shown and center.shown, "the name tab must coexist with both health values")
a=assert(source:find("function KT:ApplyStockUFHealthTextGeometry(",1,true))
b=assert(source:find("local function ApplyClassicFrameArt(",a,true))
run=assert(loadstring(source:sub(a,b-1)));setfenv(run,env);run()
local overlay={}
left.parent={name="old-name-art-host"}
local frame={LeftText=left,RightText=right,CenterText=center,Health=health,_textOverlay=overlay}
KT:ApplyStockUFHealthTextGeometry(frame,"player")
assert(left.point[1]=="LEFT" and left.point[2]==health and left.justify=="LEFT")
assert(right.point[1]=="RIGHT" and right.point[2]==health and right.justify=="RIGHT")
assert(left.width==86 and right.width==86)
assert(left.parent==overlay and right.parent==overlay, "both numbers return to the layer above Health")
assert(center.shown, "the separately seated name survives the health geometry pass")
print("stock_number_layout: ok")
