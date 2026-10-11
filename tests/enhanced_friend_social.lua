-- Run with Lua 5.1 from the repository root.
local function equal(a, b, label)
    assert(a == b, (label or "value") .. ": expected " .. tostring(b) .. ", got " .. tostring(a))
end
local created = 0
local function object(kind)
    local o = { kind = kind or "Frame", alpha = 1, shown = true, scripts = {}, level = 10,
        font = { "Native.ttf", 14, "OUTLINE" }, coords = { 0, 1, 0, 1 }, color = { 1, 1, 1, 1 } }
    function o:SetAlpha(a) self.alpha = a end
    function o:GetAlpha() return self.alpha end
    function o:IsShown() return self.shown end
    function o:Show() self.shown = true end
    function o:Hide() self.shown = false end
    function o:SetAllPoints() end
    function o:GetObjectType() return self.kind end
    function o:IsEnabled() return self.enabled ~= false end
    function o:IsMouseEnabled() return self.mouse ~= false end
    function o:GetSize() return self.width or 100, self.height or 40 end
    function o:SetSize(w,h) self.width=w; self.height=h end
    function o:SetWidth(w) self.width=w end
    function o:SetHeight(h) self.height=h end
    function o:GetWidth() return self.width or 100 end
    function o:GetNumPoints() return #(self.points or {}) end
    function o:GetPoint(i) return unpack(self.points[i]) end
    function o:ClearAllPoints() self.points={} end
    function o:SetPoint(...) self.points=self.points or {};self.points[#self.points+1]={...} end
    function o:SetShown(v) self.shown=v end
    function o:CreateFontString() return object("FontString") end
    function o:GetTextColor() return unpack(self.textColor or {1,1,0,1}) end
    function o:SetTextColor(...) self.textColor={...} end
    function o:SetText(v) self.text=v end
    function o:SetJustifyH(v) self.justifyH=v end
    function o:SetFrameLevel(n) self.level = n end
    function o:GetFrameLevel() return self.level end
    function o:EnableMouse(v) self.mouse = v end
    function o:CreateTexture()
        local region=object("Texture");self.regions=self.regions or {};self.regions[#self.regions+1]=region;return region
    end
    function o:GetRegions() return unpack(self.regions or {}) end
    function o:RegisterEvent(e) self.event = e end
    function o:SetScript(e, fn) self.scripts[e] = fn end
    function o:HookScript(e, fn)
        local old = self.scripts[e]
        self.scripts[e] = function(...) if old then old(...) end; fn(...) end
    end
    function o:GetTexture() return self.texture end
    function o:SetTexture(t) self.texture = t; self.atlas = nil end
    function o:GetAtlas() return self.atlas end
    function o:SetAtlas(t) self.atlas = t end
    function o:GetTexCoord() return unpack(self.coords) end
    function o:SetTexCoord(...) self.coords = { ... } end
    function o:GetVertexColor() return unpack(self.color) end
    function o:SetVertexColor(...) self.color = { ... } end
    function o:SetColorTexture(...) self.colorTexture = { ... } end
    if kind == "FontString" or kind == "EditBox" then
        function o:GetFont() return unpack(self.font) end
        function o:SetFont(...) self.font = { ... }; return true end
    end
    return o
end
function CreateFrame(_, _, parent)
    created = created + 1
    local o = object(); o.parent = parent; return o
end
function hooksecurefunc(o, key, fn)
    local old = o[key]
    o[key] = function(...)
        local result = old(...)
        fn(...)
        return result
    end
end
EventRegistry = { RegisterCallback = function(self, event, fn) self.callback = fn end }
local EFL = { SocialStyle = {} }
for _, variant in ipairs({ "shell", "section", "inset" }) do
    EFL.SocialStyle[variant] = function(frame) frame.variant = variant end
end
EFL.SocialStyle.font = function() return "KUI.ttf" end
function EFL:GetWoWProjectDisplay(game)
    return game.clientProgram == "WoW" and { texture = "Forever.png" } or nil
end
EFL.SocialStyle.layout = { windowWidth=478, windowHeight=640, rootInset=6, navHeight=34, panelGap=6, bodyInset=8, headerHeight=56, footerHeight=28 }
EFL.SocialStyle.text = function() return 1,1,1,1 end
EFL.SocialStyle.accent = function() return 0.6,0.2,0.8,1 end
EFL.SocialStyle.newLabel = function(parent, size) local o=object("FontString");o.font={"KUI.ttf",size,""};o.parent=parent;return o end
EFL.SocialStyle.newButton = function(parent,w,h,text)
 local b=object("Button"); b.parent=parent;b:SetSize(w,h);b.label=EFL.SocialStyle.newLabel(b,11);b.label:SetText(text);return b
end
EFL.SocialStyle.button = function(button, variant)
 button._eflVariant=variant
 button._eflButtonArt=button._eflButtonArt or { base=object("Texture") }
 button._eflOutline=button._eflOutline or { top=object("Texture") }
 if button.label then button.label:SetTextColor(1,1,1,1) end
end
function HideUIPanel(frame) frame:Hide() end
local refreshed = 0
function EFL:Refresh() refreshed = refreshed + 1 end
local Mod = { EnhancedFriendList = EFL }
local ns = { KT = {}, Enhancements = Mod }
assert(loadfile("KullThranUI/Modules/Enhancements/EnhancedFriendList_SocialUI.lua"))("test", ns)
local UI = EFL.SocialUI
UI:Refresh(true) -- SocialUI is not loaded yet.
equal(UI.enabled, true, "lazy load")
local row = object()
row.Background = object("Texture")
row.Name = object("FontString")
row.PartyButton = object("Button")
row.PartyButton.NormalTexture = object("Texture")
row.PartyButton.Icon = object("Texture")
row.PartyButton.Icon.texture = "Invite.png"
local clicks = 0
row.PartyButton.scripts.OnClick = function() clicks = clicks + 1 end
row.GameIconHolder = object()
row.GameIconHolder.Icon = object("Texture")
row.GameIconHolder.Icon.atlas = "native-wow"
row.elementData = { accountInfo = { gameAccountInfo = { clientProgram = "WoW" } } }
function row:Initialize(data)
    self.elementData = data
    self.Background:SetAlpha(1)
    self.GameIconHolder.Icon:SetTexture(data.accountInfo.gameAccountInfo.clientProgram .. ".png")
end
local scroll = object()
scroll.rows = { row }
function scroll:ForEachFrame(fn) for _, r in ipairs(self.rows) do fn(r) end end
function scroll:Update() end
local friends = object()
friends.ScrollBox = scroll
friends.FilterBar = { SearchBar = object("EditBox"), SearchFilterDropdown = object("Button") }
friends.ActionButton = object("Button")
friends.ActionButton.Text = object("FontString")
friends.ActionButton.Left = friends.ActionButton:CreateTexture()
friends.ActionButton.Center = friends.ActionButton:CreateTexture()
friends.ActionButton.Right = friends.ActionButton:CreateTexture()
local data = friends.FilterBar.SearchBar
local searches = 0
data.scripts.OnTextChanged = function() searches = searches + 1 end
local nativeRefreshes = 0
function friends:Refresh(retain) equal(retain, true); nativeRefreshes = nativeRefreshes + 1; row:Initialize(row.elementData) end
local recent = object(); recent.ScrollBox = object()
function recent.ScrollBox:ForEachFrame(fn) fn(row) end
function recent.ScrollBox:Update() end
local tab = object("Button"); tab.tabData={tabOrder=1,tabType=3,tabName="Friends"}; tab.NormalTexture = object("Texture"); tab.Count = object("FontString")
local selects = 0
tab.scripts.OnClick = function() selects = selects + 1 end
local side = object(); side.Border = object(); side.UpdateButton = object("Button")
local root = object()
root:SetSize(410,675)
root.NineSlice = object(); root.NineSlice.alpha = 0.8
root.Bg = object("Texture")
root.CloseButton = object("Button"); root.CloseButton.NormalTexture = object("Texture")
root.CloseButton.NormalTexture.texture = "Close-X.png"
root.selectedTab=3
root.tabDefinitions = { [3] = { contentFrame = friends }, [47] = { contentFrame = recent } }
root.sideWindowFrames = { [22] = side }
root.BattleNetBar = object()
root.BattleNetBar.ControlsContainer = object()
root.BattleNetBar.ControlsContainer.OnlineStatusDropdown = object("Button")
root.BattleNetBar.ControlsContainer.BattleNetMenuButton = object("Button")
root.BattleNetBar.ControlsContainer.PersonalBattleTagDisplay = { DisplayText = object("FontString") }
function root:EnumerateTabs() local done; return function() if not done then done = true; return tab end end end
function root:RefreshTabs() end
function root:RefreshVisuals() end
function root:ShowSideWindow() end
SocialUIFrame = root
UI:Refresh(true)
equal(root.width, 478, "EFL window width")
equal(root.height, 640, "EFL window height")
equal(tab.points[1][3], "LEFT", "navigation moved to bottom")
equal(tab.points[1][2], UI.shell.nav, "native tabs use EFL navigation")
equal(tab.label.text, "Friends", "named navigation")
equal(tab._eflSelected, true, "active tab styled")
equal(friends.points[1][2], UI.shell.body, "content in EFL body")
equal(root.CloseButton.mouse, false, "old close cannot intercept")
equal(friends.ActionButton._eflVariant, "footer", "EFL footer button renderer")
equal(friends.ActionButton.Left.alpha, 0, "stock footer left art hidden")
equal(friends.ActionButton.Center.alpha, 0, "stock footer center art hidden")
equal(friends.ActionButton.Right.alpha, 0, "stock footer right art hidden")
equal(root.NineSlice.alpha, 0, "native border replaced")
equal(row.Name.font[1], "KUI.ttf", "font")
equal(row.Name.font[2], 14, "native font size")
equal(row.GameIconHolder.Icon.texture, "Forever.png", "EFL project")
equal(row.PartyButton.Icon.texture, "Invite.png", "invite icon preserved")
equal(root.CloseButton.NormalTexture.alpha, 1, "close glyph visible")
row.PartyButton.scripts.OnClick(); tab.scripts.OnClick(); data.scripts.OnTextChanged()
equal(clicks, 1); equal(selects, 1); equal(searches, 1)
local count = created
for i = 1, 30 do root:RefreshTabs(); root:RefreshVisuals(); scroll:Update(); UI:Refresh(true) end
equal(created, count, "no repeated underlays")
-- Recycled native card methods were copied before mixin hooks were installed.
row:Initialize({ accountInfo = { gameAccountInfo = { clientProgram = "WoW" } } })
equal(row.Background.alpha, 0, "recycled background")
equal(row.GameIconHolder.Icon.texture, "Forever.png", "recycled project")
row:Initialize({ accountInfo = { gameAccountInfo = { clientProgram = "D3" } } })
equal(row.GameIconHolder.Icon.texture, "D3.png", "other game native icon")
-- TextSizeManager keeps native scale and restores latest native font.
row.Name:SetFont("ScaledNative.ttf", 21, "")
EventRegistry.callback()
equal(row.Name.font[1], "KUI.ttf"); equal(row.Name.font[2], 21)
local spacer = object(); UI:DecorateRow(spacer)
equal(UI.objects[spacer], nil, "spacer stays empty")
local inCombat = true
InCombatLockdown = function() return inCombat end
UI:Disable()
equal(UI.enabled, true, "secure geometry restoration deferred in combat")
equal(UI.pending, true, "combat refresh pending")
equal(root.width, 478, "no native size change during combat")
inCombat = false
UI.pending = nil
UI:Disable()
equal(root.width, 410, "native width restored")
equal(root.height, 675, "native height restored")
equal(UI.shell.shown, false, "EFL shell hidden")
equal(root.CloseButton.mouse, true, "native close restored")
equal(friends.ActionButton.Left.alpha, 1, "stock footer art restored")
equal(friends.ActionButton.Text.textColor[2], 1, "native footer color restored")
equal(tab.label, nil, "native label reference restored")
equal(root.NineSlice.alpha, 0.8, "original alpha restored")
equal(row.Name.font[1], "ScaledNative.ttf", "native font restored")
equal(row.Name.font[2], 21, "scale retained on disable")
equal(row.GameIconHolder.Icon.texture, "D3.png", "current friend restored")
equal(nativeRefreshes, 1, "native data refresh on disable")
for _, state in pairs(UI.objects) do if state.surface then equal(state.surface.shown, false, "surface disabled") end end
root:RefreshVisuals(); scroll:Update()
equal(root.NineSlice.alpha, 0.8, "hooks inert when disabled")
UI:Refresh(true); UI:Disable()
equal(root.NineSlice.alpha, 0.8, "second disable")
UI.eventFrame.scripts.OnEvent()
equal(refreshed, 1, "service status event")
print("enhanced_friend_social: PASS (lazy load, native callbacks, pooling, project icons, text scale, restoration)")

-- Exercise the actual EFL entry points: modern routing must happen before
-- any old FriendsFrame code even if Blizzard_SocialUI isn't loaded yet.
local file = assert(io.open("KullThranUI/Modules/Enhancements/EnhancedFriendList.lua", "rb"))
local source = file:read("*a"):gsub("\r\n", "\n"); file:close()
local function method(name)
    local start = assert(source:find("function EnhancedFriendList:" .. name .. "(", 1, true))
    local finish = source:find("\nend\n", start, true)
    return source:sub(start, assert(finish) + 4)
end
local usesModern, setting = true, true
C_SocialUI = { IsSystemEnabled = function() return usesModern end }
local baseRestored, externalsRestored, legacyDisabled = 0, 0, 0
local runtime = { baseApplied = true, themeHooked = true }
local routed = {}
local facade = { frame = object(), SocialUI = {
    Refresh = function(_, enabled) routed[#routed + 1] = enabled end,
    Disable = function() legacyDisabled = legacyDisabled + 1 end,
} }
function facade:SetBaseFrameState(v) equal(v, false); baseRestored = baseRestored + 1; runtime.baseApplied = false end
function facade:RestoreExternalFrames() externalsRestored = externalsRestored + 1 end
function facade:EnsureEventFrame() end
function facade:RegisterChatCommands() end
function facade:Disable() legacyDisabled = legacyDisabled + 1 end
local env = setmetatable({ EnhancedFriendList = facade, runtime = runtime, KT = {},
    ShouldUseCustomList = function() return setting end,
    GetFriendsFrame = function() error("legacy controller touched") end,
}, { __index = _G })
for _, name in ipairs({ "UsesSocialUI", "RefreshSocialUI", "OnAddonLoaded", "RefreshTheme", "Refresh" }) do
    local chunk = assert(loadstring(method(name))); setfenv(chunk, env); chunk()
end
facade:OnAddonLoaded("Blizzard_SocialUIShared")
equal(routed[1], true); equal(baseRestored, 1); equal(externalsRestored, 1)
equal(facade.frame.shown, false, "legacy overlay suppressed")
facade:Refresh(true); facade:RefreshTheme()
equal(#routed, 3)
setting = false; facade:Refresh(true)
equal(routed[4], false, "profile disable forwarded")
usesModern = false; facade:Refresh(true)
equal(legacyDisabled, 2, "native adapter stops before disabled legacy fallback")
C_SocialUI = nil
equal(facade:UsesSocialUI(), nil, "old client API guard")
print("enhanced_friend_social: PASS (actual EFL controller routing and profile fallback)")
