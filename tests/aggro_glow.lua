local root=arg[1] or "."
local f=assert(io.open(root.."/KullThranUI_UnitFrames/Modules/KUIUnitFrames/KUI_AggroGlow.lua"))
local source=f:read("*a");f:close()
local combat={player=true,target=true}
local env=setmetatable({UnitAffectingCombat=function(u) return combat[u] end,
    UnitExists=function() return true end,UnitCanAttack=function() return true end,
    UnitThreatSituation=function() return 0 end},{__index=_G})
local first=assert(source:find("local function HasAggro(",1,true))
local last=assert(source:find("-- El glow",first,true))
local run=assert(loadstring(source:sub(first,last-1).."\nreturn HasAggro"));setfenv(run,env)
local hot=run()
assert(hot("target"),"hostile Target in combat glows without relying on threat values")
combat.target=false
assert(not hot("target"),"idle Target does not glow")
combat.player=false;combat.target=true
assert(not hot("target"),"out-of-combat player does not activate glow")
local function Region(left,right,parent)
    local r={left=left,right=right,parent=parent,points={},shown=true}
    function r:GetLeft() local p=self.points.TOPLEFT;return p and (p[2]:GetLeft()+p[4]) or self.left end
    function r:GetRight() local p=self.points.BOTTOMRIGHT;return p and (p[2]:GetRight()+p[4]) or self.right end
    function r:GetWidth() return self:GetRight()-self:GetLeft() end
    function r:GetFrameStrata() return "LOW" end
    function r:GetFrameLevel() return self.level or 10 end
    function r:GetParent() return self.parent end
    function r:GetChildren() end
    function r:IsShown() return self.shown end
    function r:Show() self.shown=true end
    function r:Hide() self.shown=false end
    function r:SetShown(v) self.shown=v end
    function r:SetFrameLevel(v) self.level=v end
    function r:SetFrameStrata() end
    function r:ClearAllPoints() self.points={} end
    function r:SetPoint(...) local p={...};self.points[p[1]]=p end
    function r:SetAllPoints(other)
        self:SetPoint("TOPLEFT",other,"TOPLEFT",0,0)
        self:SetPoint("BOTTOMRIGHT",other,"BOTTOMRIGHT",0,0)
    end
    function r:GetPoint(i) return unpack(self.points[i==1 and "TOPLEFT" or "BOTTOMRIGHT"]) end
    function r:SetHeight() end
    function r:GetTexture() return 123 end
    return r
end
local copied=0
local overrides={}
env.ns={ClassicRing={sheets={elite="elite",rare="rare",rareelite="rareelite"},
    dragons={elite="dragon_elite",rare="dragon_rare",rareelite="dragon_rareelite"}}}
env.LayoutRestGlow=function() return false end
env.CloneTexture=function(g,i,src,pool,host,file)
    copied=copied+1
    if file then
        overrides[#overrides+1]=file
        assert(pool==g.ringClones and host==g.ringClip,"isolated dragon bypasses bar clipping")
        assert(src==g.testArt,"dragon retains stock sheet geometry")
    end
    pool=pool or g.clones
    pool[i]=pool[i] or Region(0,200)
    pool[i]:Show()
    return true
end
first=assert(source:find("local function Layout(",1,true))
last=assert(source:find("local function UpdateUnit(",first,true))
run=assert(loadstring(source:sub(first,last-1).."\nreturn Layout"));setfenv(run,env)
local layout=run()
for _,unit in ipairs({"player","target"}) do
    local frame=Region(0,200);frame.unit=unit
    local bd=unit=="target" and Region(140,200) or Region(0,60)
    frame.Portrait={backdrop=bd}
    frame.Health=unit=="target" and Region(0,140) or Region(60,200)
    frame._ktClassicPortraitArt=Region(0,200,frame)
    frame._kuiIndicatorOverlay=Region(0,200)
    frame._kuiLevelOverlay=Region(0,200)
    frame._kuiLevelRingHost=Region(0,200)
    local g=Region(0,200);g.clip=Region(0,200);g.top=Region(0,200);g.overlay=Region(0,200)
    g.rings={};g.clones={};g.ringClones={};g.ringClip=Region(0,200)
    g.testArt=frame._ktClassicPortraitArt
    copied=0
    layout(frame,g)
    assert(copied==1,"missing Forever art cannot skip Classic decoration")
    frame._kuiClassificationPortraitRing=Region(bd:GetLeft(),bd:GetRight(),frame._kuiIndicatorOverlay)
    local stableLevel=g:GetFrameLevel()
    for i=1,100 do layout(frame,g) end
    assert(g:GetFrameLevel()==stableLevel,"glow refresh cannot raise its own layer repeatedly")
    copied=0;g.resting=true;layout(frame,g)
    assert(copied==2, "fallback copies each art source once without saturated outlines")
    g.resting=false
    assert(frame._kuiIndicatorOverlay:GetFrameLevel()>g:GetFrameLevel(),"PvP circles stay above glow")
    assert(frame._kuiLevelRingHost:GetFrameLevel()>g:GetFrameLevel(),"level ring stays above glow")
    assert(g.clip:GetRight()>g.clip:GetLeft(),"glow clip keeps a visible portrait area")
    if unit=="target" then assert(g.clip:GetLeft()==frame.Health:GetRight(),"Target clips at right edge of bars")
    else assert(g.clip:GetRight()==frame.Health:GetLeft(),"Player clips at left edge of bars") end
    for _,kind in ipairs({"elite","rare","rareelite"}) do
        frame._ktClassicSheetPath=kind
        copied=0;overrides={};layout(frame,g)
        assert(copied==3 and overrides[1]=="dragon_"..kind,"all Classic classifications get their isolated glow")
        assert(g.ringClip:GetLeft()==-6 and g.ringClip:GetRight()==206,"head and tail keep full sheet bounds on both sides")
        if unit=="target" then assert(g.clip:GetLeft()==frame.Health:GetRight())
        else assert(g.clip:GetRight()==frame.Health:GetLeft()) end
    end
    frame._ktClassicSheetPath=nil;layout(frame,g)
    assert(not g.ringClones[2]:IsShown(),"classification removal hides old dragon glow")
    frame._ktClassicSheetPath="elite";frame._ktClassicPortraitArt:Hide();layout(frame,g)
    assert(not g.ringClones[2]:IsShown(),"hidden Classic art cannot leave a dragon glow behind")
    frame._ktClassicPortraitArt:Show()
    env.LayoutRestGlow=function() return true end
    layout(frame,g)
    assert(g.clonesUsed==0 and not g.ringClones[2]:IsShown(),"native resting glow clears aggro dragon copies")
    env.LayoutRestGlow=function() return false end
end
-- Exercise the actual texture copier: override only the image, retaining the
-- stock sheet's mirrored UVs, anchors, scale and pulsing overlay parent.
first=assert(source:find("local function CloneTexture(",1,true))
last=assert(source:find("local function Build(",first,true))
env.PAD=0;env.KT={}
run=assert(loadstring(source:sub(first,last-1).."\nreturn CloneTexture"));setfenv(run,env)
local clone=run()
for _,unit in ipairs({"player","target"}) do
    local coords=unit=="player" and {1,0,1,.78125,.09375,0,.09375,.78125}
        or {.09375,0,.09375,.78125,1,0,1,.78125}
    local parent={GetEffectiveScale=function() return 2 end}
    local art={GetParent=function() return parent end,GetNumPoints=function() return 1 end,
        GetPoint=function() return "TOPLEFT",parent,"TOPLEFT",3,-4 end,
        GetSize=function() return 232,100 end,GetTexCoord=function() return unpack(coords) end,
        GetAtlas=function() return "unused-stock-atlas" end,GetTexture=function() return "stock-sheet" end}
    local dst=Region(0,200)
    function dst:SetBlendMode(v) self.blend=v end
    function dst:SetTexture(v) self.file=v end
    function dst:SetAtlas() error("override must bypass source atlas") end
    function dst:SetDesaturated(v) self.desaturated=v end
    function dst:SetTexCoord(...) self.coords={...} end
    function dst:SetSize(w,h) self.w,self.h=w,h end
    function dst:SetVertexColor(...) self.color={...} end
    local host={CreateTexture=function() return dst end}
    local g={GetEffectiveScale=function() return 1 end,color={1,.12,.12}}
    local pool={}
    assert(clone(g,1,art,pool,host,"isolated-dragon"))
    assert(dst.file=="isolated-dragon" and pool[1]==dst and dst.desaturated and dst.blend=="BLEND")
    assert(dst.w==464 and dst.h==200 and dst.points.TOPLEFT[4]==6 and dst.points.TOPLEFT[5]==-8,
        "dragon copy retains stock art size and compensates scale")
    for i,v in ipairs(coords) do assert(dst.coords[i]==v,"mirrored sheet coordinates stay unchanged") end
    assert(dst.color[1]==1 and dst.color[2]==.12 and dst.color[3]==.12,"whole dragon uses aggro tint")
end
print("aggro_glow: ok")
