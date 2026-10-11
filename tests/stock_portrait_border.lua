local root=arg[1] or "."
local f=assert(io.open(root.."/KullThranUI_UnitFrames/Modules/KUIUnitFrames/KUIUnitFrames.lua"))
local source=f:read("*a");f:close()
local first=assert(source:find("local function ApplyDetachedPortraitShape(",1,true))
local last=assert(source:find('    local portraitStyle =',first,true))
local fitted=0
local env=setmetatable({KT={FitStockUFPortraitMask=function() fitted=fitted+1 end},ns={}}, {__index=_G})
local run=assert(loadstring(source:sub(first,last-1).."\nend\nreturn ApplyDetachedPortraitShape"))
setfenv(run,env)
local apply=run()
local function Border() return {shown=true,Hide=function(self) self.shown=false end} end
for _,unit in ipairs({"player","target"}) do
    local backdrop={_ktStockPortraitAnchor=true,_shapeBorderTex=Border(),_sqBorderTexs={Border(),Border()}}
    apply(backdrop,{},unit)
    assert(not backdrop._shapeBorderTex.shown,"generic circular border stays hidden")
    for _,border in ipairs(backdrop._sqBorderTexs) do assert(not border.shown,"square border stays hidden") end
end
assert(fitted==2,"stock masks keep ownership")
print("stock_portrait_border: ok")
