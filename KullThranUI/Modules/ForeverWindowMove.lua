local KT = LibStub("AceAddon-3.0"):GetAddon("KullThranUI")
local Move = KT:NewModule("ForeverWindowMove", "AceEvent-3.0")

-- Candidates are discovered by existence, including load-on-demand and custom
-- Forever FrameXML. Never load a Blizzard addon just to populate the options.
Move.catalog = {
    "AddonList", "ArenaFrame", "ArenaRegistrarFrame", "BankFrame", "BattlefieldFrame",
    "CharacterFrame", "ChatConfigFrame", "ChatMenu", "ColorPickerFrame", "DressUpFrame",
    "FriendsFrame", "GameMenuFrame", "GossipFrame", "GuildInviteFrame", "GuildRegistrarFrame",
    "HelpFrame", "InterfaceOptionsFrame", "ItemTextFrame", "LootFrame", "MailFrame",
    "OpenMailFrame", "MerchantFrame", "ModelPreviewFrame", "PetitionFrame", "PetStableFrame",
    "PVPFrame", "PVPParentFrame", "QuestFrame", "QuestLogDetailFrame", "QuestLogFrame",
    "SpellBookFrame", "TabardFrame", "TaxiFrame", "TradeFrame", "TutorialFrame",
    "WorldMapFrame", "WorldStateScoreFrame", "AuctionFrame", "KeyBindingFrame",
    "CalendarFrame", "CalendarCreateEventFrame", "CalendarViewEventFrame", "ChannelFrame",
    "GuildBankFrame", "GuildControlUI", "GuildFrame", "InspectFrame", "LFGParentFrame",
    "LFGFrame", "LFDParentFrame", "LFGDungeonReadyDialog", "MacroFrame", "PVPQueueFrame",
    "StableFrame", "TimeManagerFrame", "TradeSkillFrame", "CraftFrame", "ClassTrainerFrame",
    "AchievementFrame", "PetTalentFrame", "TalentFrame", "PlayerTalentFrame",
    "RaidInfoFrame", "ReadyCheckFrame", "RaidBrowserFrame", "ItemSocketingFrame",
    "BarberShopFrame", "StackSplitFrame", "VideoOptionsFrame", "AudioOptionsFrame",
    "SettingsPanel", "CollectionsJournal", "EncounterJournal", "GuildLogFrame",
    "GuildBankLogFrame", "GuildBankMoneyFrame", "GuildBankWithdrawMoneyFrame",
}
for i = 1, 13 do Move.catalog[#Move.catalog + 1] = "ContainerFrame" .. i end
for i = 1, 4 do Move.catalog[#Move.catalog + 1] = "StaticPopup" .. i end

function Move:EnsureDB()
    if not (KT.db and KT.db.profile) then return end
    local db = KT.db.profile.foreverWindowMove
    if not db then db = {}; KT.db.profile.foreverWindowMove = db end
    db.frames = db.frames or {}
    if db.requireMoveModifier == nil then db.requireMoveModifier = true end
    db.savePosStrategy = db.savePosStrategy or "permanent"
    db.saveScaleStrategy = db.saveScaleStrategy or "permanent"
    self.db = db
    return db
end

function Move:GetSettings(name)
    local db = self:EnsureDB()
    if not db then return end
    db.frames[name] = db.frames[name] or {}
    return db.frames[name]
end

function Move:GetLayout(name)
    local cfg = self:GetSettings(name)
    local session = self.session[name] or {}
    return self.db.savePosStrategy == "permanent" and cfg.position or
        (self.db.savePosStrategy == "session" and session.position or nil),
        self.db.saveScaleStrategy == "permanent" and cfg.scale or session.scale
end

function Move:CanChange(name)
    return self.active ~= false and not InCombatLockdown() and not self:GetSettings(name).disabled
end

function Move:Apply(name)
    local entry = self.frames[name]
    if not entry or entry.applying or entry.dragging or not self:CanChange(name) then return end
    local frame = entry.frame
    local pos, scale = self:GetLayout(name)
    entry.applying = true
    if scale then
        frame:SetScale(scale)
        entry.customScale = true
    elseif entry.customScale then
        frame:SetScale(entry.scale)
        entry.customScale = nil
    end
    if pos then
        frame:ClearAllPoints()
        frame:SetPoint("CENTER", UIParent, "CENTER", pos.x, pos.y)
        entry.customPosition = true
    elseif entry.customPosition then
        frame:ClearAllPoints()
        for _, point in ipairs(entry.points) do frame:SetPoint(unpack(point)) end
        entry.customPosition = nil
    end
    entry.applying = nil
end

function Move:SavePosition(name)
    local frame = self.frames[name].frame
    local x, y = frame:GetCenter()
    local ux, uy = UIParent:GetCenter()
    if not x or not ux then return end
    local ratio = frame:GetEffectiveScale() / UIParent:GetEffectiveScale()
    local pos = { x = x * ratio - ux, y = y * ratio - uy }
    if self.db.savePosStrategy == "permanent" then self:GetSettings(name).position = pos end
    self.session[name] = self.session[name] or {}
    self.session[name].position = self.db.savePosStrategy ~= "off" and pos or nil
end

function Move:SetPosition(name, x, y)
    if not self.frames[name] or not self:CanChange(name) then return end
    self.db.savePosStrategy = "permanent"
    self:GetSettings(name).position = { x = x, y = y }
    self:Apply(name)
end

function Move:SetScale(name, scale)
    if not self.frames[name] or not self:CanChange(name) then return end
    scale = math.max(0.5, math.min(2, tonumber(scale) or 1))
    self.session[name] = self.session[name] or {}
    self.session[name].scale = scale
    if self.db.saveScaleStrategy == "permanent" then self:GetSettings(name).scale = scale end
    self.frames[name].customScale = true
    self.frames[name].frame:SetScale(scale)
end

function Move:Reset(name)
    if InCombatLockdown() then return end
    local entry = self.frames[name]
    local cfg = self:GetSettings(name)
    cfg.position, cfg.scale = nil, nil
    self.session[name] = nil
    if entry then
        entry.applying = true
        entry.frame:SetScale(entry.scale)
        entry.frame:ClearAllPoints()
        for _, point in ipairs(entry.points) do entry.frame:SetPoint(unpack(point)) end
        entry.customPosition, entry.customScale = nil, nil
        entry.applying = nil
    end
end

function Move:SetDisabled(name, disabled)
    if InCombatLockdown() then return end
    if disabled then
        local cfg = self:GetSettings(name)
        local pos, scale, session = cfg.position, cfg.scale, self.session[name]
        self:Reset(name)
        cfg.position, cfg.scale, self.session[name] = pos, scale, session
    end
    self:GetSettings(name).disabled = disabled and true or false
    if not disabled then self:Apply(name) end
end

function Move:RegisterWindow(name, frame)
    if self.frames[name] or not frame or not frame.HookScript or not frame.SetMovable
        or not frame.GetCenter or not frame.SetScale or not frame.GetNumPoints
        or not frame.RegisterForDrag then return end
    if InCombatLockdown() then return end
    local points = {}
    for i = 1, frame:GetNumPoints() do points[i] = { frame:GetPoint(i) } end
    self.frames[name] = { frame = frame, points = points, scale = frame:GetScale() }
    -- An existing title region avoids consuming clicks on the window's controls.
    local handle = frame
    for _, key in ipairs({ "TitleContainer", "TitleFrame", "TitleBg" }) do
        local candidate = frame[key]
        if candidate and type(candidate.HookScript) == "function"
            and type(candidate.EnableMouse) == "function"
            and type(candidate.RegisterForDrag) == "function" then
            handle = candidate
            break
        end
    end
    frame:SetMovable(true)
    frame:SetClampedToScreen(true)
    handle:EnableMouse(true)
    handle:RegisterForDrag("LeftButton")
    handle:HookScript("OnDragStart", function()
        if not self:CanChange(name) or (self.db.requireMoveModifier and not IsShiftKeyDown()) then return end
        self.frames[name].dragging = true
        frame:StartMoving()
    end)
    handle:HookScript("OnDragStop", function()
        if not self.frames[name].dragging then return end
        self.frames[name].dragging = nil
        frame:StopMovingOrSizing()
        if not InCombatLockdown() then self:SavePosition(name) end
    end)
    handle:HookScript("OnMouseUp", function(_, button)
        if button == "RightButton" and IsShiftKeyDown() and self:CanChange(name) then self:Reset(name) end
    end)
    -- Do not steal mouse-wheel handlers from scrollable panels.
    if handle ~= frame and handle.EnableMouseWheel then
        handle:EnableMouseWheel(true)
        handle:HookScript("OnMouseWheel", function(_, delta)
            if IsControlKeyDown() and self:CanChange(name) then self:SetScale(name, frame:GetScale() + delta * 0.05) end
        end)
    end
    frame:HookScript("OnShow", function() self:Apply(name) end)
    frame:HookScript("OnHide", function()
        if self.frames[name].dragging then
            self.frames[name].dragging = nil
            frame:StopMovingOrSizing()
            if not InCombatLockdown() then self:SavePosition(name) end
        end
    end)
    hooksecurefunc(frame, "SetPoint", function() self:Apply(name) end)
    self:Apply(name)
end

function Move:Discover()
    if self.active == false then return end
    self:EnsureDB()
    if not self.db or InCombatLockdown() then return end
    for _, name in ipairs(self.catalog) do self:RegisterWindow(name, _G[name]) end
    -- Forever can add its own panels. Use FrameXML's actual window registries
    -- rather than guessing their names or enumerating HUD/secure unit frames.
    local function registerNative(name)
        if type(name) ~= "string" then return end
        local lower = name:lower()
        if lower:find("kullthran", 1, true) or lower:find("^kui") or lower:find("^kt_") then return end
        self:RegisterWindow(name, _G[name])
    end
    for name in pairs(UIPanelWindows or {}) do registerNative(name) end
    for _, name in ipairs(UISpecialFrames or {}) do registerNative(name) end
end

function Move:Refresh(event)
    if InCombatLockdown() then return end
    if self.profile ~= KT.db.profile or (type(event) == "string" and event:find("^OnProfile")) then
        self.session = {}
        -- Restore the old profile's owned geometry before applying the new one,
        -- including windows disabled in the incoming profile.
        for _, entry in pairs(self.frames) do
            entry.applying = true
            if entry.customScale then entry.frame:SetScale(entry.scale) end
            if entry.customPosition then
                entry.frame:ClearAllPoints()
                for _, point in ipairs(entry.points) do entry.frame:SetPoint(unpack(point)) end
            end
            entry.applying = nil
            entry.customPosition, entry.customScale = nil, nil
        end
        self.profile = KT.db.profile
    end
    self:Discover()
    for name in pairs(self.frames) do self:Apply(name) end
end

function Move:CombatStart()
    for _, entry in pairs(self.frames) do
        if entry.dragging then entry.dragging = nil; entry.frame:StopMovingOrSizing() end
    end
end

function Move:OnInitialize()
    self.frames, self.session = {}, {}
    self.profile = KT.db and KT.db.profile
end

function Move:OnEnable()
    self.active = true
    self:EnsureDB()
    self:RegisterEvent("ADDON_LOADED", "Discover")
    self:RegisterEvent("PLAYER_ENTERING_WORLD", "Refresh")
    self:RegisterEvent("PLAYER_REGEN_ENABLED", "Refresh")
    self:RegisterEvent("PLAYER_REGEN_DISABLED", "CombatStart")
    if KT.db.RegisterCallback then
        KT.db.RegisterCallback(self, "OnProfileChanged", "Refresh")
        KT.db.RegisterCallback(self, "OnProfileCopied", "Refresh")
        KT.db.RegisterCallback(self, "OnProfileReset", "Refresh")
    end
    self:Discover()
end

function Move:OnDisable()
    self.active = false
    if InCombatLockdown() then return end
    for name in pairs(self.frames) do
        local cfg = self:GetSettings(name)
        local pos, scale, session = cfg.position, cfg.scale, self.session[name]
        self:Reset(name)
        cfg.position, cfg.scale, self.session[name] = pos, scale, session
    end
end
