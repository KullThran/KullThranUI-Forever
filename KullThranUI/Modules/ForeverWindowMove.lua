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
    "WorldStateScoreFrame", "AuctionFrame", "KeyBindingFrame",
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

-- Never made movable. The map protects mouse-button passthrough while its pins
-- are acquired; a movable WorldMapFrame (or its quest log) taints that path and
-- the game blocks Button:SetPassThroughButtons() (same rule as KUIMove on Retail).
Move.excluded = { WorldMapFrame = true, QuestMapFrame = true }

-- The client can return a secret value to tainted code; read it as "not held".
local function KeyDown(query)
    if type(query) ~= "function" then return false end
    local ok, value = pcall(query)
    if not ok or (issecretvalue and issecretvalue(value)) then return false end
    return value == true
end

local function MouseEnabled(frame)
    if type(frame.IsMouseEnabled) ~= "function" then return false end
    local ok, value = pcall(frame.IsMouseEnabled, frame)
    if not ok or (issecretvalue and issecretvalue(value)) then return false end
    return value == true
end

-- Version 1: moving no longer requires SHIFT by default, as with KUIMove on
-- Retail. Older builds stored the old default, so it is cleared once.
local MOVE_DEFAULTS_VERSION = 1

function Move:EnsureDB()
    if not (KT.db and KT.db.profile) then return end
    local db = KT.db.profile.foreverWindowMove
    if not db then db = {}; KT.db.profile.foreverWindowMove = db end
    db.frames = db.frames or {}
    if (tonumber(db.defaultsVersion) or 0) < MOVE_DEFAULTS_VERSION then
        db.requireMoveModifier = false
        db.defaultsVersion = MOVE_DEFAULTS_VERSION
    end
    if db.requireMoveModifier == nil then db.requireMoveModifier = false end
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

-- Unknown or secret answers count as protected.
local function Protected(frame)
    if type(frame.IsProtected) ~= "function" then return true end
    local ok, value = pcall(frame.IsProtected, frame)
    if not ok or (issecretvalue and issecretvalue(value)) then return true end
    return value and true or false
end

-- Placing a protected window is blocked in combat. An unprotected one, like the
-- loot window, still opens in combat; it takes its saved place at once instead of
-- opening where Blizzard puts it and jumping there when combat ends.
function Move:CanApply(name)
    if self.active == false or self:GetSettings(name).disabled then return false end
    return not InCombatLockdown() or not Protected(self.frames[name].frame)
end

-- Frame size relative to UIParent: SetPoint offsets are in the frame's own units.
local function RelativeScale(frame)
    local parentScale = UIParent:GetEffectiveScale()
    local scale = frame:GetEffectiveScale()
    if not parentScale or parentScale <= 0 or not scale or scale <= 0 then return 1 end
    return scale / parentScale
end

-- x/y are the window centre relative to UIParent's centre (the X/Y options).
-- w/h record the window size at that moment, so the window is pinned by its
-- top-left corner: Blizzard resizes windows after placing them (the loot
-- window follows its item count) and a centre anchor made them grow upwards
-- and jump between openings. Older saves lack w/h and take the current size once.
function Move:CompletePosition(frame, pos)
    if pos.w and pos.h then return pos end
    local ratio = RelativeScale(frame)
    pos.w, pos.h = (frame:GetWidth() or 0) * ratio, (frame:GetHeight() or 0) * ratio
    return pos
end

function Move:Apply(name)
    local entry = self.frames[name]
    if not entry or entry.applying or entry.dragging or not self:CanApply(name) then return end
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
        self:CompletePosition(frame, pos)
        local ratio = RelativeScale(frame)
        frame:ClearAllPoints()
        frame:SetPoint("TOPLEFT", UIParent, "CENTER", (pos.x - pos.w / 2) / ratio, (pos.y + pos.h / 2) / ratio)
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
    local ratio = RelativeScale(frame)
    local pos = { x = x * ratio - ux, y = y * ratio - uy,
        w = (frame:GetWidth() or 0) * ratio, h = (frame:GetHeight() or 0) * ratio }
    if self.db.savePosStrategy == "permanent" then self:GetSettings(name).position = pos end
    self.session[name] = self.session[name] or {}
    self.session[name].position = self.db.savePosStrategy ~= "off" and pos or nil
end

function Move:SetPosition(name, x, y)
    if not self.frames[name] or not self:CanChange(name) then return end
    self.db.savePosStrategy = "permanent"
    local cfg = self:GetSettings(name)
    local old = cfg.position
    cfg.position = self:CompletePosition(self.frames[name].frame, { x = x, y = y, w = old and old.w, h = old and old.h })
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

-- Every window back to Blizzard's place and scale, including the ones not created yet.
function Move:ResetAll()
    if InCombatLockdown() then return false end
    local db = self:EnsureDB()
    if not db then return false end
    for _, cfg in pairs(db.frames) do cfg.position, cfg.scale = nil, nil end
    for name in pairs(self.frames or {}) do self:Reset(name) end
    self.session = {}
    return true
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

-- Cursor travel, in UIParent units, that turns a press into a move.
local DRAG_THRESHOLD = 4

local function CursorPosition()
    local x, y = GetCursorPosition()
    local scale = UIParent:GetEffectiveScale()
    if not x or not scale or scale <= 0 then return end
    return x / scale, y / scale
end

-- Older clients answer 1/nil; a secret value reads as released.
local function LeftButtonDown()
    if type(IsMouseButtonDown) ~= "function" then return false end
    local ok, value = pcall(IsMouseButtonDown, "LeftButton")
    if not ok or (issecretvalue and issecretvalue(value)) then return false end
    return value == true or value == 1
end

function Move:CancelPress(entry)
    if self.pressed ~= entry then return end
    self.pressed = nil
    if self.pressDriver then self.pressDriver:SetScript("OnUpdate", nil) end
end

function Move:WatchPress(entry)
    local x, y = CursorPosition()
    if not x then return end
    entry.pressX, entry.pressY = x, y
    self.pressed = entry
    self.pressDriver = self.pressDriver or CreateFrame("Frame")
    self.pressDriver:SetScript("OnUpdate", function()
        local pressed = self.pressed
        if not pressed or not LeftButtonDown() or InCombatLockdown() then
            self:CancelPress(pressed)
            return
        end
        local cx, cy = CursorPosition()
        if cx and (math.abs(cx - pressed.pressX) >= DRAG_THRESHOLD or math.abs(cy - pressed.pressY) >= DRAG_THRESHOLD) then
            self:CancelPress(pressed)
            pressed.startMoving()
        end
    end)
end

function Move:RegisterWindow(name, frame)
    if self.excluded[name] or self.frames[name] or not frame or not frame.HookScript or not frame.SetMovable
        or not frame.GetCenter or not frame.SetScale or not frame.GetNumPoints
        or not frame.EnableMouse then return end
    if InCombatLockdown() then return end
    local points = {}
    for i = 1, frame:GetNumPoints() do points[i] = { frame:GetPoint(i) } end
    local entry = { frame = frame, points = points, scale = frame:GetScale() }
    self.frames[name] = entry
    -- The title region is always a handle; it never covers the window's controls.
    local handle = frame
    for _, key in ipairs({ "TitleContainer", "TitleFrame", "TitleBg" }) do
        local candidate = frame[key]
        if candidate and type(candidate.HookScript) == "function"
            and type(candidate.EnableMouse) == "function" then
            handle = candidate
            break
        end
    end
    -- Like KUIMove on Retail, a press on the window body also moves it. Clicks on
    -- its buttons do not reach the body. A body that ignores the mouse is left
    -- click-through.
    local bodyIsHandle = handle ~= frame and MouseEnabled(frame)
    frame:SetMovable(true)
    frame:SetClampedToScreen(true)
    handle:EnableMouse(true)

    local function stopMoving()
        if not entry.dragging then return end
        entry.dragging = nil
        frame:StopMovingOrSizing()
        local x, y = frame:GetCenter()
        local moved = not (x and entry.startX) or math.abs(x - entry.startX) > 0.5 or math.abs(y - entry.startY) > 0.5
        entry.startX, entry.startY = nil, nil
        -- A plain click leaves the window where the client placed it.
        if moved and not InCombatLockdown() then self:SavePosition(name) end
    end
    entry.startMoving = function()
        if entry.dragging or not frame:IsShown() or not self:CanChange(name) then return end
        entry.startX, entry.startY = frame:GetCenter()
        entry.dragging = true
        -- The profile owns the position; keep the client's own layout cache out of it.
        local userPlaced = frame.IsUserPlaced and frame:IsUserPlaced()
        if issecretvalue and issecretvalue(userPlaced) then userPlaced = false end
        frame:StartMoving()
        if frame.SetUserPlaced then frame:SetUserPlaced(userPlaced == true) end
    end
    -- The move starts once the held cursor travels a few pixels. A plain click
    -- (for example on the gap a looted item leaves in the loot window) never
    -- moves the window or saves a position.
    local function onMouseDown(_, button)
        if button ~= "LeftButton" or entry.dragging or not self:CanChange(name) then return end
        if self.db.requireMoveModifier and not KeyDown(IsShiftKeyDown) then return end
        self:WatchPress(entry)
    end
    local function onMouseUp(_, button)
        if button == "LeftButton" then
            self:CancelPress(entry)
            stopMoving()
        elseif button == "RightButton" and KeyDown(IsShiftKeyDown) and self:CanChange(name) then
            self:Reset(name)
        end
    end
    handle:HookScript("OnMouseDown", onMouseDown)
    handle:HookScript("OnMouseUp", onMouseUp)
    if bodyIsHandle then
        frame:HookScript("OnMouseDown", onMouseDown)
        frame:HookScript("OnMouseUp", onMouseUp)
    end
    -- Do not steal mouse-wheel handlers from scrollable panels.
    if handle ~= frame and handle.EnableMouseWheel then
        handle:EnableMouseWheel(true)
        handle:HookScript("OnMouseWheel", function(_, delta)
            if KeyDown(IsControlKeyDown) and self:CanChange(name) then self:SetScale(name, frame:GetScale() + delta * 0.05) end
        end)
    end
    frame:HookScript("OnShow", function() self:Apply(name) end)
    frame:HookScript("OnHide", function() self:CancelPress(entry); stopMoving() end)
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
    self:CancelPress(self.pressed)
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
