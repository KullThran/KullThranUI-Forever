-- Forever 1.60.1: SocialUI owns navigation, lists, filters and side windows.
-- Decorate those objects; never substitute the legacy FriendsFrame controller.
local _, ns = ...
local KT = (ns and ns.KT) or _G.KT
local Mod = KT and ((ns and ns.Enhancements) or KT:GetModule("Enhancements", true))
local EFL = Mod and Mod.EnhancedFriendList
if not EFL then return end

local UI = { enabled = false, objects = {}, hooks = {} }
EFL.SocialUI = UI

local function InCombat()
    return _G.InCombatLockdown and InCombatLockdown()
end

local function State(object)
    if not object then return end
    local state = UI.objects[object]
    if not state then
        state = {}
        UI.objects[object] = state
    end
    return state
end

local function HideArt(object)
    if not object or not object.SetAlpha then return end
    local state = State(object)
    if state.alpha == nil then state.alpha = object:GetAlpha() end
    object:SetAlpha(0)
end

local function Surface(frame, variant)
    if not frame or not frame.CreateTexture then return end
    local state = State(frame)
    -- A separate underlay can be hidden on disable without stripping native art.
    if not state.surface then
        state.surface = CreateFrame("Frame", nil, frame)
        state.surface:SetAllPoints()
        state.surface:EnableMouse(false)
    end
    state.surface:SetFrameLevel(math.max(0, frame:GetFrameLevel() - 1))
    EFL.SocialStyle[variant or "inset"](state.surface)
    state.surface:Show()
end

local function Font(region)
    if not region or not region.GetFont then return end
    local path, size, flags = region:GetFont()
    if not path or not size then return end
    local state = State(region)
    local custom = EFL.SocialStyle.font()
    -- TextSizeManager can change the native font while this adapter is active.
    -- Remember its latest choice and preserve its current size and flags.
    if path ~= custom and path ~= state.appliedFont then
        state.font = { path, size, flags }
    elseif not state.font then
        state.font = { path, size, flags }
    end
    if region:SetFont(custom, size, flags) then state.appliedFont = custom end
end

local function RememberGeometry(frame)
    if not frame then return end
    local state = State(frame)
    if not state.geometry then
        state.geometry = { points = {}, size = { frame:GetSize() } }
        for i = 1, frame:GetNumPoints() do
            state.geometry.points[i] = { frame:GetPoint(i) }
        end
    end
end

local function Anchor(frame, ...)
    if not frame then return end
    RememberGeometry(frame)
    frame:ClearAllPoints()
    frame:SetPoint(...)
end

local function Size(frame, width, height)
    RememberGeometry(frame)
    frame:SetSize(width, height)
end

local function ShowButtonArt(button, shown)
    for _, group in ipairs({ button._eflButtonArt or {}, button._eflOutline or {} }) do
        for _, region in pairs(group) do region:SetShown(shown) end
    end
end

local function EFLButton(button, variant, tabLabel)
    if not button then return end
    local state = State(button)
    local text = button.Text or button.ButtonText or (button.GetFontString and button:GetFontString())
    -- Hide the complete stock button art, including the three-part footer art.
    -- The EFL textures are tracked separately and must survive subsequent refreshes.
    if button.GetRegions then
        for _, region in ipairs({ button:GetRegions() }) do
            if region:GetObjectType() == "Texture" and not (state.artRegions and state.artRegions[region])
                and (tabLabel or (region ~= button.Icon and region ~= button.ActionIcon)) then
                HideArt(region)
            end
        end
    end
    HideArt(button.NineSlice)
    if not state.buttonStyled then
        state.buttonStyled = true
        state.originalLabel = button.label
        state.originalVariant = button._eflVariant
    end
    if tabLabel then
        if not state.label then state.label = EFL.SocialStyle.newLabel(button, 10, EFL.SocialStyle.text()) end
        state.label:ClearAllPoints()
        state.label:SetPoint("LEFT", 4, 0)
        state.label:SetPoint("RIGHT", -4, 0)
        state.label:SetJustifyH("CENTER")
        state.label:SetText(tabLabel)
        state.label:Show()
        Font(state.label)
        button.label = state.label
    elseif text then
        local labelState = State(text)
        if not labelState.color then labelState.color = { text:GetTextColor() } end
        button.label = text
        Font(text)
    end
    ShowButtonArt(button, true)
    EFL.SocialStyle.button(button, variant)
    state.artRegions = {}
    for _, group in ipairs({ button._eflButtonArt or {}, button._eflOutline or {} }) do
        for _, region in pairs(group) do state.artRegions[region] = true end
    end
    if not state.buttonHooks then
        state.buttonHooks = true
        for event, key in pairs({ OnEnter = "_eflHovered", OnLeave = "_eflHovered", OnMouseDown = "_eflPressed", OnMouseUp = "_eflPressed" }) do
            local active = event == "OnEnter" or event == "OnMouseDown"
            button:HookScript(event, function()
                if UI.enabled then
                    button[key] = active
                    Font(button.label)
                    EFL.SocialStyle.button(button, button._eflVariant)
                end
            end)
        end
        for _, event in ipairs({ "OnEnable", "OnDisable" }) do
            button:HookScript(event, function()
                if UI.enabled then
                    Font(button.label)
                    EFL.SocialStyle.button(button, button._eflVariant)
                end
            end)
        end
    end
end

local function Button(button)
    if not button then return end
    Surface(button, "section")
    -- Keep icons, checked/hover feedback, disabled alpha and click scripts.
    local text = button.Text or button.ButtonText or (button.GetFontString and button:GetFontString())
    -- Close/decline buttons can carry their entire glyph in the normal texture.
    -- Only replace a background when the label/icon exists separately.
    if text or button.Icon or button.ActionIcon then
        local normal = button.NormalTexture or (button.GetNormalTexture and button:GetNormalTexture())
        if normal ~= button.Icon and normal ~= button.ActionIcon then HideArt(normal) end
        HideArt(button.PushedTexture or (button.GetPushedTexture and button:GetPushedTexture()))
    end
    HideArt(button.NineSlice)
    HideArt(button.Background)
    Font(text)
end

local function Shell(frame)
    if not frame then return end
    Surface(frame, "shell")
    for _, key in ipairs({ "NineSlice", "Border", "Bg", "Background", "TopTileStreaks", "TopFade", "BottomFade" }) do
        HideArt(frame[key])
    end
    Font(frame.TitleText or (frame.TitleContainer and frame.TitleContainer.TitleText))
    Font(frame.Title)
end

function UI:CreateShell(root)
    if self.shell then return end
    local style, layout = EFL.SocialStyle, EFL.SocialStyle.layout
    local shell = CreateFrame("Frame", nil, root)
    shell:SetPoint("TOPLEFT", layout.rootInset, -layout.rootInset)
    shell:SetPoint("BOTTOMRIGHT", -layout.rootInset, layout.rootInset)
    shell:SetFrameLevel(root:GetFrameLevel())
    self.shell = shell

    local function Panel(parent, variant)
        local panel = CreateFrame("Frame", nil, parent)
        panel:SetFrameLevel(root:GetFrameLevel())
        style[variant](panel)
        return panel
    end
    shell.nav = Panel(shell, "section")
    shell.nav:SetPoint("BOTTOMLEFT")
    shell.nav:SetPoint("BOTTOMRIGHT")
    shell.nav:SetHeight(layout.navHeight)
    shell.main = Panel(shell, "shell")
    shell.main:SetPoint("TOPLEFT")
    shell.main:SetPoint("TOPRIGHT")
    shell.main:SetPoint("BOTTOMLEFT", shell.nav, "TOPLEFT", 0, layout.panelGap)
    shell.main:SetPoint("BOTTOMRIGHT", shell.nav, "TOPRIGHT", 0, layout.panelGap)
    shell.header = Panel(shell.main, "section")
    shell.header:SetPoint("TOPLEFT", layout.bodyInset, -layout.bodyInset)
    shell.header:SetPoint("TOPRIGHT", -layout.bodyInset, -layout.bodyInset)
    shell.header:SetHeight(layout.headerHeight)
    shell.footer = Panel(shell.main, "section")
    shell.footer:SetPoint("BOTTOMLEFT", layout.bodyInset, layout.bodyInset)
    shell.footer:SetPoint("BOTTOMRIGHT", -layout.bodyInset, layout.bodyInset)
    shell.footer:SetHeight(layout.footerHeight)
    shell.body = Panel(shell.main, "section")
    shell.body:SetPoint("TOPLEFT", shell.header, "BOTTOMLEFT", 0, -layout.bodyInset)
    shell.body:SetPoint("TOPRIGHT", shell.header, "BOTTOMRIGHT", 0, -layout.bodyInset)
    shell.body:SetPoint("BOTTOMLEFT", shell.footer, "TOPLEFT", 0, layout.bodyInset)
    shell.body:SetPoint("BOTTOMRIGHT", shell.footer, "TOPRIGHT", 0, layout.bodyInset)
    shell.iconCard = Panel(shell.header, "inset")
    shell.iconCard:SetPoint("LEFT", 8, 0)
    shell.iconCard:SetSize(48, 36)
    shell.icon = shell.iconCard:CreateTexture(nil, "ARTWORK")
    shell.icon:SetPoint("CENTER")
    shell.icon:SetSize(34, 22)
    shell.icon:SetTexture("Interface\\AddOns\\KullThranUI\\Libraries\\texture\\media\\icons\\EnhancedFriendList\\Friends.png")
    shell.close = style.newButton(shell.header, 22, 22, "", "icon")
    shell.close:SetPoint("RIGHT", -6, 0)
    shell.close.icon = shell.close:CreateTexture(nil, "ARTWORK")
    shell.close.icon:SetPoint("CENTER")
    shell.close.icon:SetSize(9, 9)
    shell.close.icon:SetTexture("Interface\\AddOns\\KullThranUI\\Libraries\\texture\\media\\icons\\EnhancedFriendList\\X.png")
    shell.close:SetScript("OnClick", function() HideUIPanel(root) end)
    shell.edge = shell:CreateTexture(nil, "ARTWORK", nil, 7)
    shell.edge:SetPoint("TOPLEFT", 1, -1)
    shell.edge:SetPoint("TOPRIGHT", -1, -1)
    shell.edge:SetHeight(2)
    shell:Hide()
end

function UI:LayoutShell(root)
    self:CreateShell(root)
    local shell, style, layout = self.shell, EFL.SocialStyle, EFL.SocialStyle.layout
    Size(root, layout.windowWidth, layout.windowHeight)
    for panel, variant in pairs({ [shell.main] = "shell", [shell.header] = "section", [shell.footer] = "section", [shell.body] = "section", [shell.nav] = "section", [shell.iconCard] = "inset" }) do
        panel:SetFrameLevel(root:GetFrameLevel())
        style[variant](panel)
    end
    shell:SetFrameLevel(root:GetFrameLevel())
    shell.icon:SetVertexColor(style.accent())
    shell.edge:SetColorTexture(style.accent())
    style.button(shell.close, "icon")
    shell:Show()
    -- Keep all native controls in their original parents. Only change anchors;
    -- their services, callbacks, selection and secure raid children stay intact.
    local bar = root.BattleNetBar
    if bar then
        Anchor(bar, "TOPLEFT", shell.header, "TOPLEFT", 62, -10)
        bar:SetPoint("BOTTOMRIGHT", shell.header, "BOTTOMRIGHT", -34, 10)
        local controls = bar.ControlsContainer
        if controls and controls.OnlineStatusDropdown then
            Anchor(controls.OnlineStatusDropdown, "LEFT", controls, "LEFT", 4, 0)
        end
    end
    HideArt(root.TitleContainer)
    if root.CloseButton then
        HideArt(root.CloseButton)
        local state = State(root.CloseButton)
        if state.mouse == nil then state.mouse = root.CloseButton:IsMouseEnabled() end
        root.CloseButton:EnableMouse(false)
    end
    for _, definition in pairs(root.tabDefinitions or {}) do
        local frame = definition.contentFrame
        if frame then
            Anchor(frame, "TOPLEFT", shell.body, "TOPLEFT", 6, -6)
            frame:SetPoint("BOTTOMRIGHT", shell.footer, "BOTTOMRIGHT", -6, 0)
            if frame.ActionButton then Anchor(frame.ActionButton, "CENTER", shell.footer, "CENTER", 0, 0) end
        end
    end
    local tabs = {}
    if root.EnumerateTabs then
        for tab in root:EnumerateTabs() do tabs[#tabs + 1] = tab end
    end
    table.sort(tabs, function(a, b) return (a.tabData and a.tabData.tabOrder or 0) < (b.tabData and b.tabData.tabOrder or 0) end)
    local width = math.max(1, (layout.windowWidth - 2 * layout.rootInset - 12 - math.max(0, #tabs - 1) * 4) / math.max(1, #tabs))
    for index, tab in ipairs(tabs) do
        Anchor(tab, "LEFT", shell.nav, "LEFT", 6 + (index - 1) * (width + 4), 0)
        Size(tab, width, 24)
        HideArt(tab.Icon)
        tab._eflSelected = tab.tabData and tab.tabData.tabType == root.selectedTab
        EFLButton(tab, "nav", tab.tabData and tab.tabData.tabName or "")
        -- Keep Blizzard's notification animation, with rectangular EFL art.
        -- Its alpha animation would otherwise revive the old gold side-tab rim.
        if tab.TabGlow then
            local glow = tab.TabGlow
            local state = State(glow)
            if not state.icon then
                state.icon = { texture = glow:GetTexture(), atlas = glow:GetAtlas(), coords = { glow:GetTexCoord() }, color = { glow:GetVertexColor() } }
            end
            Anchor(glow, "TOPLEFT", tab, "TOPLEFT", 1, -1)
            glow:SetPoint("BOTTOMRIGHT", tab, "BOTTOMRIGHT", -1, 1)
            glow:SetTexture("Interface\\Buttons\\WHITE8X8")
            glow:SetTexCoord(0, 1, 0, 1)
            glow:SetVertexColor(style.accent(0.16))
        end
        -- The counter still belongs to Blizzard and remains live.
        if tab.Count then
            Anchor(tab.Count, "TOPRIGHT", tab, "TOPRIGHT", -3, -2)
            Font(tab.Count)
        end
    end
    for _, window in pairs(root.sideWindowFrames or {}) do
        Anchor(window, "TOPLEFT", root, "TOPRIGHT", 6, 0)
    end
end

function UI:DecorateRow(row)
    if not self.enabled or not row then return end
    -- Tree lists include spacer frames, which must remain empty.
    if not (row.Background or row.ButtonText or row.Name or row.Text or row.name) then return end
    self:HookMethod(row, "Initialize", function() self:DecorateRow(row) end)
    self:HookMethod(row, "Init", function() self:DecorateRow(row) end)
    self:HookMethod(row, "LayoutScaledContent", function() self:DecorateRow(row) end)
    Surface(row, row.ButtonText and "section" or "inset")
    HideArt(row.Background)
    for _, key in ipairs({ "FriendName", "Name", "Level", "Class", "Location", "MostRecentInteraction", "RequestTimestamp", "FriendType", "ButtonText", "Text", "MemberName", "QueueName", "name", "difficulty", "reset", "extended" }) do
        Font(row[key])
    end
    for _, regions in ipairs({ row.Members or {}, row.Queues or {} }) do
        for _, region in ipairs(regions) do Font(region) end
    end
    for _, key in ipairs({ "PartyButton", "AcceptButton", "RAFSummonButton" }) do Button(row[key]) end

    -- Use EFL's existing project resolver in the native icon slot, respecting
    -- RAF priority and native online/project restrictions. Do not cover presence.
    local holder = row.GameIconHolder
    local data = row.elementData
    local game = data and data.accountInfo and data.accountInfo.gameAccountInfo
    if holder and holder.Icon and holder:IsShown() and game then
        local project = EFL:GetWoWProjectDisplay(game)
        if project then
            local icon = holder.Icon
            local state = State(icon)
            if not state.icon then
                state.icon = { texture = icon:GetTexture(), atlas = icon:GetAtlas(), coords = { icon:GetTexCoord() }, color = { icon:GetVertexColor() } }
            end
            icon:SetTexture(project.texture)
            icon:SetTexCoord(0, 1, 0, 1)
            local color = project.color or { 1, 1, 1, 1 }
            icon:SetVertexColor(unpack(color))
        end
    end
end

function UI:HookMethod(object, method, callback)
    if not object or type(object[method]) ~= "function" then return end
    local hooks = self.hooks[object]
    if not hooks then hooks = {}; self.hooks[object] = hooks end
    if hooks[method] then return end
    hooks[method] = true
    hooksecurefunc(object, method, callback)
end

function UI:DecorateList(frame)
    if not frame then return end
    local filter = frame.FilterBar
    if filter then
        Surface(filter)
        Button(filter.SearchFilterDropdown)
        if filter.SearchBar then
            Surface(filter.SearchBar)
            HideArt(filter.SearchBar.NineSlice)
            Font(filter.SearchBar)
            Font(filter.SearchBar.Instructions)
        end
    end
    EFLButton(frame.ActionButton, "footer")
    Font(frame.FriendsDisabledText)
    HideArt(frame.TopDivider)
    HideArt(frame.BottomDivider)
    local scroll = frame.ScrollBox
    if scroll and scroll.ForEachFrame then
        self:HookMethod(scroll, "Update", function()
            if self.enabled then scroll:ForEachFrame(function(row) self:DecorateRow(row) end) end
        end)
        scroll:ForEachFrame(function(row) self:DecorateRow(row) end)
    end
    if frame.RealIDWarning then
        Button(frame.RealIDWarning.ContinueButton)
    end
end

function UI:DecorateWindow(frame)
    Shell(frame)
    self:DecorateList(frame)
    for _, key in ipairs({ "UpdateButton", "CancelButton", "BlockButton", "UnblockButton", "CloseButton", "ExtendButton", "SendButton", "SendRequestButton" }) do Button(frame[key]) end
    for _, key in ipairs({ "TopInset", "BottomInset", "TopInsetEdge", "BottomInsetEdge" }) do HideArt(frame[key]) end
    if frame.EditBox then Surface(frame.EditBox); Font(frame.EditBox); Font(frame.EditBox.PromptText) end
    if frame.Header then Font(frame.Header.HeaderText) end
    Font(frame.Text)
end

function UI:DecorateDialogs()
    for _, name in ipairs({ "FriendsFriendsFrame", "AddFriendFrame", "BattleNetInviteFrame" }) do
        local frame = _G[name]
        if frame then
            self:DecorateWindow(frame)
            self:HookMethod(frame, "Layout", function() if self.enabled then self:DecorateDialogs() end end)
            -- AddFriend's info and entry pages use nested layout containers.
            local function StylePage(page)
                if not page then return end
                Button(page.OkayButton)
                local edit = page.EditBoxContainer
                if edit then
                    Button(edit.AcceptButton); Button(edit.CancelButton)
                    if edit.NameEditBox then
                        Surface(edit.NameEditBox)
                        HideArt(edit.NameEditBox.Left); HideArt(edit.NameEditBox.Right)
                        HideArt(_G.AddFriendNameEditBoxMiddle)
                        Font(edit.NameEditBox)
                    end
                    Font(edit.RequestInfoText)
                end
                Font(page.TitleContainer and page.TitleContainer.Title)
                local container = page.InfoContainer or page.OptionsContainer
                if container then
                    Font(container.OrLabel)
                    for _, key in ipairs({ "LeftTextContainer", "RightTextContainer" }) do
                        local text = container[key]
                        if text then Font(text.Title); Font(text.Description) end
                    end
                end
            end
            StylePage(frame.InfoFrame); StylePage(frame.EntryFrame)
            Font(frame.InviteText); Font(frame.InviteeName); Font(frame.InfoText)
            Button(frame.FriendsDropdown)
        end
    end
end

function UI:Apply()
    local root = _G.SocialUIFrame
    if not self.enabled or not root then return end
    -- SocialUI can contain the secure raid roster. Defer geometry changes.
    if InCombat() then self.pending = true; return end
    Shell(root)
    self:LayoutShell(root)
    -- The portrait is decoration; status, BattleTag copy, menu and close remain.
    HideArt(root.PortraitContainer)
    local bar = root.BattleNetBar
    if bar then
        Surface(bar, "section")
        HideArt(bar.Background)
        local controls = bar.ControlsContainer
        if controls then
            HideArt(controls.BattleNetBackground)
            Button(controls.OnlineStatusDropdown)
            Button(controls.BattleNetMenuButton)
            local tag = controls.PersonalBattleTagDisplay
            if tag then HideArt(tag.BattleNetBackground); Font(tag.DisplayText) end
        end
    end
    -- Iterate definitions, not hardcoded tab indexes or availability assumptions.
    for _, definition in pairs(root.tabDefinitions or {}) do
        self:DecorateList(definition.contentFrame)
        local frame = definition.contentFrame
        if frame then
            Button(frame.RaidInfoButton); Button(frame.ConvertToRaidButton)
            Font(frame.RaidDescription)
        end
    end
    for _, frame in pairs(root.sideWindowFrames or {}) do self:DecorateWindow(frame) end
    -- This dialog lives outside SocialUIFrame and is loaded with FriendsFrame.
    self:DecorateDialogs()
end

function UI:InstallHooks(root)
    for _, method in ipairs({ "RefreshTabs", "RefreshVisuals", "SetActiveContentFrame", "ShowSideWindow", "CreateContentFramesForSupportedTabs" }) do
        self:HookMethod(root, method, function() self:Apply() end)
    end
    -- Cards are pooled. Their Initialize methods run before selection/scrollbox
    -- updates, including refreshes which don't call ScrollBox:Update.
    for _, name in ipairs({ "FriendsListSocialCardMixin", "RecentAlliesSocialCardMixin", "FriendRequestsListSocialCardMixin", "SocialUIScrollableHeaderMixin" }) do
        self:HookMethod(_G[name], "Initialize", function(row) self:DecorateRow(row) end)
    end
    if not self.hooks[root] or not self.hooks[root].onShow then
        self.hooks[root] = self.hooks[root] or {}
        self.hooks[root].onShow = true
        root:HookScript("OnShow", function() self:Apply() end)
    end
    if _G.EventRegistry and not self.textScaleHook then
        self.textScaleHook = true
        EventRegistry:RegisterCallback("TextSizeManager.OnTextScaleUpdated", function() self:Apply() end, self)
    end
end

function UI:Disable()
    if not self.enabled then return end
    if InCombat() then self.pending = true; return end
    self.enabled = false
    if self.shell then self.shell:Hide() end
    for object, state in pairs(self.objects) do
        if state.surface then state.surface:Hide() end
        if state.alpha ~= nil then object:SetAlpha(state.alpha) end
        if state.mouse ~= nil then object:EnableMouse(state.mouse) end
        if state.geometry then
            object:ClearAllPoints()
            object:SetSize(unpack(state.geometry.size))
            for _, point in ipairs(state.geometry.points) do object:SetPoint(unpack(point)) end
        end
        if state.color then object:SetTextColor(unpack(state.color)) end
        if state.buttonStyled then
            ShowButtonArt(object, false)
            if state.label then state.label:Hide() end
            object.label = state.originalLabel
            object._eflVariant = state.originalVariant
            object._eflSelected, object._eflHovered, object._eflPressed = nil, nil, nil
        end
        if state.font then
            local _, size = object:GetFont()
            object:SetFont(state.font[1], size or state.font[2], state.font[3])
        end
        if state.icon then
            if state.icon.atlas then object:SetAtlas(state.icon.atlas) else object:SetTexture(state.icon.texture) end
            object:SetTexCoord(unpack(state.icon.coords))
            object:SetVertexColor(unpack(state.icon.color))
        end
        state.alpha, state.font, state.icon, state.appliedFont = nil, nil, nil, nil
        state.mouse, state.geometry, state.color, state.buttonStyled = nil, nil, nil, nil
    end
    -- Reinitialize pooled data after restoring art: a recycled icon may belong
    -- to a different friend now. Blizzard refreshes the current account/selection.
    local root = _G.SocialUIFrame
    if root then
        if root.RefreshTabs then root:RefreshTabs() end
        if root.RefreshVisuals then root:RefreshVisuals() end
        if root.InitializeSideWindowAnchoring then root:InitializeSideWindowAnchoring() end
        if root:IsShown() and _G.UpdateUIPanelPositions and not (_G.InCombatLockdown and InCombatLockdown()) then
            UpdateUIPanelPositions(root)
        end
    end
    for _, definition in pairs(root and root.tabDefinitions or {}) do
        local frame = definition.contentFrame
        if frame and frame.Refresh and frame:IsShown() then frame:Refresh(true) end
    end
end

function UI:Refresh(enabled)
    if InCombat() then self.pending = true; return end
    if not enabled then self:Disable(); return end
    self.enabled = true
    local root = _G.SocialUIFrame
    if root then self:InstallHooks(root); self:Apply() end
end

-- The service can switch between SocialUI and legacy FriendsFrame in-session.
-- ADDON_LOADED is already forwarded by Enhancements, including lazy loading.
UI.eventFrame = CreateFrame("Frame")
UI.eventFrame:RegisterEvent("SOCIAL_UI_SYSTEM_STATUS_UPDATED")
UI.eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
UI.eventFrame:SetScript("OnEvent", function(_, event)
    if event == "PLAYER_REGEN_ENABLED" and not UI.pending then return end
    UI.pending = nil
    EFL:Refresh(true)
end)
