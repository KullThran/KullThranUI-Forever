-- Modules/FlightMaster/FlightMaster.lua
-- Flight Master tracker (replaces the Retail-only Dragon Riding module in
-- the Forever workspace): flight duration bar, flight map tooltips and the
-- entry points for the flight point guide.
local _, ns = ...
local KT = LibStub("AceAddon-3.0"):GetAddon("KullThranUI")
local Mod = KT:NewModule("FlightMaster", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0")
local LSM = LibStub("LibSharedMedia-3.0", true)
local FM = ns.FM
local L = FM.L

ns.Mod = Mod

local DEFAULTS = {
    enable = true,
    showBar = true,
    showTaxiTooltip = true,
    openAtTaxi = true,
    hideOppositeFaction = true,
    distanceUnit = "yards",
    width = 280,
    height = 18,
    xOffset = 0,
    yOffset = -150,
    texture = "Melli",
    font = "AAA_ITC_Avant_Garde",
    fontSize = 12,
    fontOutline = "OUTLINE",
    useThemeColor = true,
    barColor = { r = 0.25, g = 0.65, b = 0.95, a = 1 },
    timeDisplay = "remaining",      -- "remaining" or "arrival" (clock time)
    arrivalSound = "READY_CHECK",   -- key of ARRIVAL_SOUNDS or "NONE"
    earlyLandingButton = true,
    shareTimes = true,
    guide = { filter = "ALL", continentOnly = false, sort = "DISTANCE" },
}

local BAR_BG = { 0, 0, 0, 0.6 }
local TAXI_POLL_INTERVAL = 0.2
local PREVIEW_DURATION = 95

-- Sound kits played on landing (looked up by name, numeric IDs as fallback).
local ARRIVAL_SOUNDS = {
    READY_CHECK = { kit = "READY_CHECK", id = 8960 },
    RAID_WARNING = { kit = "RAID_WARNING", id = 8959 },
    QUEST_COMPLETE = { kit = "IG_QUEST_LIST_COMPLETE", id = 878 },
    LEVEL_UP = { kit = "LEVELUP", id = 888 },
}
Mod.ARRIVAL_SOUNDS = ARRIVAL_SOUNDS

local frame, bar, routeText, timeText, sourceText, spark, landBtn
local previewing = false
local previewStart = 0

-- ============================================================================
-- INITIALIZATION
-- ============================================================================

local function ApplyDefaults(target, defaults)
    for k, v in pairs(defaults) do
        if target[k] == nil then
            if type(v) == "table" then
                target[k] = {}
                ApplyDefaults(target[k], v)
            else
                target[k] = v
            end
        elseif type(v) == "table" and type(target[k]) == "table" then
            ApplyDefaults(target[k], v)
        end
    end
end

function Mod:GetDB()
    local profile = KT.db and KT.db.profile
    if not profile then return DEFAULTS end
    profile.flightMaster = profile.flightMaster or {}
    ApplyDefaults(profile.flightMaster, DEFAULTS)
    self.db = profile.flightMaster
    return self.db
end

function Mod:OnInitialize()
    self:GetDB()
end

-- ============================================================================
-- STYLE HELPERS
-- ============================================================================

local function ResolveTexture(name)
    local texture
    if name == "Melli" then
        texture = "Interface\\AddOns\\KullThranUI\\Libraries\\texture\\Melli.tga"
    elseif name == "Melli Dark" then
        texture = "Interface\\AddOns\\KullThranUI\\Libraries\\texture\\MelliDark.tga"
    else
        texture = LSM and LSM.Fetch and LSM:Fetch("statusbar", name, true)
    end
    if not texture or texture == "" then
        texture = "Interface\\Buttons\\WHITE8x8"
    end
    return texture
end

local function ResolveFont(name)
    local path = LSM and LSM.Fetch and LSM:Fetch("font", name, true)
    if not path and KT.ResolveFontPath then
        path = KT:ResolveFontPath()
    end
    return path or KT.FONT_PATH or "Fonts\\FRIZQT__.TTF"
end

function Mod:GetAccentColor()
    local palette = KT.GetStylePalette and KT:GetStylePalette()
    local accent = palette and palette.accent
    if accent then
        return accent.r, accent.g, accent.b
    end
    return KT.C_R or 1, KT.C_G or 0, KT.C_B or 0.33
end

function Mod:GetBarColor()
    local db = self:GetDB()
    if db.useThemeColor ~= false then
        local r, g, b = self:GetAccentColor()
        return r, g, b, 1
    end
    local c = db.barColor or DEFAULTS.barColor
    return c.r, c.g, c.b, c.a or 1
end

local function SetFont(fs, size)
    local db = Mod:GetDB()
    local outline = db.fontOutline
    if outline == "NONE" then outline = "" end
    fs:SetFont(ResolveFont(db.font), size or db.fontSize or 12, outline or "OUTLINE")
    if not fs:GetFont() then
        fs:SetFont("Fonts\\FRIZQT__.TTF", size or db.fontSize or 12, outline or "OUTLINE")
    end
end
Mod.SetFont = SetFont

-- ============================================================================
-- FLIGHT BAR
-- ============================================================================

local function ApplyPosition()
    if not frame then return end
    local db = Mod:GetDB()
    frame:ClearAllPoints()
    frame:SetPoint("TOP", UIParent, "TOP", tonumber(db.xOffset) or 0, tonumber(db.yOffset) or -150)
end

function Mod:RegisterUnlockElement()
    if self.unlockElementRegistered or not KT.RegisterUnlockElement or not frame then
        return
    end

    KT.RegisterUnlockElement("flightmaster_bar", {
        label = "Flight Master",
        group = "Flight Master",
        order = 10,
        getFrame = function() return frame end,
        getSize = function()
            return math.max(frame:GetWidth(), 180), math.max(frame:GetHeight(), 30)
        end,
        getRect = function()
            if not (frame:GetLeft() and frame:GetTop()) then return nil end
            local uiScale = UIParent:GetEffectiveScale()
            local frameScale = frame:GetEffectiveScale()
            return frame:GetLeft() * frameScale / uiScale, frame:GetTop() * frameScale / uiScale,
                math.max(frame:GetWidth() * frameScale / uiScale, 180),
                math.max(frame:GetHeight() * frameScale / uiScale, 30)
        end,
        loadPosition = function()
            local db = Mod:GetDB()
            return { point = "TOP", relativePoint = "TOP", x = db.xOffset or 0, y = db.yOffset or -150 }
        end,
        translateMoverPosition = function(_, pos)
            return {
                point = "TOP",
                relativePoint = "TOP",
                x = (pos.x or 0) + (frame:GetWidth() * 0.5) - (UIParent:GetWidth() * 0.5),
                y = pos.y or -150,
                scale = pos.scale,
            }
        end,
        applyPendingPosition = function(_, pos)
            if not pos then return end
            local db = Mod:GetDB()
            db.xOffset, db.yOffset = pos.x or 0, pos.y or -150
            ApplyPosition()
        end,
        savePosition = function(_, _, _, x, y)
            local db = Mod:GetDB()
            db.xOffset, db.yOffset = x or 0, y or -150
            ApplyPosition()
        end,
        applyPosition = ApplyPosition,
    })
    self.unlockElementRegistered = true
end

function Mod:BuildBar()
    if frame then return frame end
    local db = self:GetDB()

    frame = CreateFrame("Frame", "KT_FlightMasterBar", UIParent)
    frame:SetClampedToScreen(true)
    frame:SetFrameStrata("MEDIUM")
    frame:SetFrameLevel(20)
    frame:EnableMouse(true)
    frame:Hide()

    routeText = frame:CreateFontString(nil, "OVERLAY")
    routeText:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
    routeText:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0)
    routeText:SetJustifyH("CENTER")
    routeText:SetWordWrap(false)

    bar = CreateFrame("StatusBar", nil, frame)
    bar:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 0, 0)
    bar:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
    bar:SetMinMaxValues(0, 1)
    bar:SetValue(0)

    bar.bg = bar:CreateTexture(nil, "BACKGROUND")
    bar.bg:SetAllPoints()

    local border = CreateFrame("Frame", nil, bar, "BackdropTemplate")
    border:SetAllPoints()
    border:SetBackdrop({ edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1 })
    border:SetBackdropBorderColor(0, 0, 0, 1)
    bar.border = border

    spark = bar:CreateTexture(nil, "OVERLAY")
    spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
    spark:SetBlendMode("ADD")
    spark:SetWidth(16)

    sourceText = border:CreateFontString(nil, "OVERLAY")
    sourceText:SetPoint("LEFT", bar, "LEFT", 6, 0)
    sourceText:SetJustifyH("LEFT")

    timeText = border:CreateFontString(nil, "OVERLAY")
    timeText:SetPoint("RIGHT", bar, "RIGHT", -6, 0)
    timeText:SetJustifyH("RIGHT")

    -- Land at the next stop of a multi-hop route.
    landBtn = CreateFrame("Button", nil, frame)
    landBtn:SetSize(22, 22)
    landBtn:SetPoint("LEFT", bar, "RIGHT", 4, 0)
    if KT.NavTabs and KT.NavTabs.StyleButton then
        KT.NavTabs.StyleButton(landBtn, { label = "v", fontSize = 11 })
    end
    landBtn:SetScript("OnClick", function() Mod:RequestEarlyLanding() end)
    landBtn:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
        GameTooltip:AddLine(L("Land at the next stop"), 1, 0.82, 0)
        GameTooltip:AddLine(L("The flight time of this trip will not be recorded."), 0.8, 0.8, 0.8, true)
        GameTooltip:Show()
    end)
    landBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
    landBtn:Hide()

    frame:SetScript("OnMouseUp", function(_, button)
        if button == "RightButton" then
            Mod:ToggleGuide()
        end
    end)
    frame:SetScript("OnEnter", function(self)
        local a = FM.active
        GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
        GameTooltip:AddLine(L("Flight Master"), 1, 0.82, 0)
        if a then
            GameTooltip:AddDoubleLine(a.origin or "?", a.dest or "?", 1, 1, 1, 1, 1, 1)
            if a.expected then
                GameTooltip:AddDoubleLine(L("Flight time"), FM.FormatTime(a.expected) .. " (" .. L(a.source or "unknown") .. ")",
                    0.8, 0.8, 0.8, 1, 1, 1)
            end
        end
        GameTooltip:AddLine(L("Right-click: open guide"), 0.6, 0.6, 0.6)
        GameTooltip:Show()
    end)
    frame:SetScript("OnLeave", function() GameTooltip:Hide() end)

    self:ApplyBarStyle()
    ApplyPosition()
    self:RegisterUnlockElement()
    return frame
end

function Mod:ApplyBarStyle()
    if not frame then return end
    local db = self:GetDB()
    local width = tonumber(db.width) or 280
    local height = tonumber(db.height) or 18
    local fontSize = tonumber(db.fontSize) or 12

    frame:SetSize(width, height + fontSize + 6)
    bar:SetHeight(height)
    spark:SetHeight(height * 2.2)

    local texture = ResolveTexture(db.texture)
    bar:SetStatusBarTexture(texture)
    bar.bg:SetTexture(texture)
    bar.bg:SetVertexColor(unpack(BAR_BG))
    bar:SetStatusBarColor(self:GetBarColor())

    SetFont(routeText, fontSize)
    SetFont(timeText, math.max(8, fontSize - 1))
    SetFont(sourceText, math.max(8, fontSize - 2))
    routeText:SetTextColor(1, 1, 1)
    timeText:SetTextColor(1, 1, 1)
    sourceText:SetTextColor(0.85, 0.85, 0.85)
end

local function RenderBar(origin, dest, elapsed, expected, source)
    routeText:SetText(string.format("%s  >  %s", origin or "?", dest or "?"))
    sourceText:SetText(L(source or "unknown"))

    if expected and expected > 0 then
        local progress = math.min(elapsed / expected, 1)
        bar:SetValue(progress)
        local remaining = expected - elapsed
        if remaining > 0 and Mod:GetDB().timeDisplay == "arrival" then
            timeText:SetText(string.format(L("Arrives %s"), date("%H:%M", time() + math.floor(remaining + 0.5)))
                .. "  (" .. FM.FormatTime(remaining) .. ")")
        elseif remaining > 0 then
            timeText:SetText(string.format("%s / %s", FM.FormatTime(remaining), FM.FormatTime(expected)))
        else
            timeText:SetText(string.format("%s  +%s", L("Arriving"), FM.FormatTime(-remaining)))
        end
        spark:ClearAllPoints()
        spark:SetPoint("CENTER", bar, "LEFT", bar:GetWidth() * progress, 0)
        spark:SetShown(progress > 0 and progress < 1)
    else
        -- No estimate (unknown coordinates): show elapsed time on a full bar.
        bar:SetValue(1)
        timeText:SetText(FM.FormatTime(elapsed))
        spark:Hide()
    end
end

local function BarOnUpdate(self, elapsed)
    self.acc = (self.acc or 0) + elapsed
    if self.acc < 0.1 then return end
    self.acc = 0

    if previewing then
        local t = (GetTime() - previewStart) % (PREVIEW_DURATION + 5)
        RenderBar("Stormwind", "Ironforge", t, PREVIEW_DURATION, "measured")
        if landBtn then landBtn:SetShown(Mod:GetDB().earlyLandingButton ~= false) end
        return
    end

    local a = FM.active
    if not a then
        frame:Hide()
        return
    end
    RenderBar(a.origin, a.dest, GetTime() - a.start, a.expected, a.source)
    if landBtn then landBtn:SetShown(Mod:CanLandEarly()) end
end

function Mod:CanLandEarly()
    local a = FM.active
    return self:GetDB().earlyLandingButton ~= false and a ~= nil and not a.earlyLanding
        and type(a.route) == "table" and #a.route > 2
        and type(_G.TaxiRequestEarlyLanding) == "function"
end

function Mod:RequestEarlyLanding()
    if not self:CanLandEarly() then return end
    FM.active.earlyLanding = true
    pcall(_G.TaxiRequestEarlyLanding)
    if landBtn then landBtn:Hide() end
end

function Mod:PlayArrivalSound()
    local entry = ARRIVAL_SOUNDS[self:GetDB().arrivalSound or "NONE"]
    if not entry or type(PlaySound) ~= "function" then return end
    local kit = SOUNDKIT and SOUNDKIT[entry.kit] or entry.id
    pcall(PlaySound, kit, "Master")
end

function Mod:UpdateBarVisibility()
    local db = self:GetDB()
    if not db.enable then
        if frame then frame:Hide() end
        return
    end
    if previewing or (FM.active and db.showBar ~= false) then
        self:BuildBar()
        frame:SetScript("OnUpdate", BarOnUpdate)
        frame.acc = 1
        frame:Show()
    elseif frame then
        frame:Hide()
        frame:SetScript("OnUpdate", nil)
    end
end

function Mod:TogglePreview(force)
    if force ~= nil then
        previewing = force and true or false
    else
        previewing = not previewing
    end
    previewStart = GetTime()
    self:UpdateBarVisibility()
    return previewing
end

function Mod:IsPreviewing()
    return previewing
end

-- ============================================================================
-- FLIGHT DETECTION
-- ============================================================================

local function OnTaxiPoll()
    local onTaxi = UnitOnTaxi and UnitOnTaxi("player")
    if onTaxi and not FM.active then
        FM.StartFlight()
        Mod:UpdateBarVisibility()
    elseif not onTaxi and FM.active then
        local duration, recorded, flight = FM.EndFlight()
        Mod:UpdateBarVisibility()
        if flight and not flight.earlyLanding and duration and duration >= FM.MIN_RECORDED_FLIGHT then
            Mod:PlayArrivalSound()
        end
        if recorded and flight and Mod.ShareFlight then
            Mod:ShareFlight(flight, duration)
        end
        if recorded and flight and Mod.guideFrame and Mod.guideFrame:IsShown() and Mod.RefreshGuide then
            Mod:RefreshGuide()
        end
    end

    if FM.pending and GetTime() - (FM.pending.requestedAt or 0) > FM.PENDING_TIMEOUT then
        FM.pending = nil
    end
    if not onTaxi and not FM.pending and not FM.active and Mod.taxiTicker then
        Mod.taxiTicker:Cancel()
        Mod.taxiTicker = nil
    end
end

function Mod:StartTaxiPolling()
    if self.taxiTicker then return end
    self.taxiTicker = C_Timer.NewTicker(TAXI_POLL_INTERVAL, OnTaxiPoll)
end

function Mod:HandleTaxiStateEvent()
    self:StartTaxiPolling()
    OnTaxiPoll()
end

function Mod:PLAYER_ENTERING_WORLD()
    if UnitOnTaxi and UnitOnTaxi("player") then
        if not FM.active then
            FM.ResumeFlight()
        end
        self:StartTaxiPolling()
    elseif FM.active then
        -- Landed during a loading screen: let the poll close it normally.
        self:StartTaxiPolling()
    else
        -- Landed while logged out: the saved flight cannot be timed.
        FM.DiscardFlight()
    end
    self:UpdateBarVisibility()
    FM.Invalidate()
end

function Mod:TAXIMAP_OPENED()
    FM.CaptureFlightMaster()
    self:HookFlightMapTooltips()
    if self:GetDB().openAtTaxi ~= false and self.ShowGuideAtTaxi then
        -- Wait a frame so the flight map is shown and can be used as anchor.
        C_Timer.After(0, function()
            if FM.taxiSlots then self:ShowGuideAtTaxi() end
        end)
    elseif self.guideFrame and self.guideFrame:IsShown() and self.RefreshGuide then
        self:RefreshGuide()
    end
end

function Mod:TAXIMAP_CLOSED()
    FM.ReleaseFlightMaster()
    if self.HideGuideFromTaxi then self:HideGuideFromTaxi() end
    if self.guideFrame and self.guideFrame:IsShown() and self.RefreshGuide then
        self:RefreshGuide()
    end
end

function Mod:OnTakeTaxiNode(slot)
    if not self:GetDB().enable then return end
    FM.OnTakeTaxiNode(slot)
    self:StartTaxiPolling()
end

-- ============================================================================
-- FLIGHT MAP TOOLTIPS
-- ============================================================================

local function AddEstimateToTooltip(slot)
    if not Mod:GetDB().showTaxiTooltip then return end
    if not slot or (TaxiNodeGetType and TaxiNodeGetType(slot) == "CURRENT") then return end
    local seconds, source, _, dest = FM.GetEstimateForSlot(slot)
    if seconds then
        GameTooltip:AddDoubleLine(L("Flight time"), string.format("%s (%s)", FM.FormatTime(seconds), L(source)),
            1, 0.82, 0, 1, 1, 1)
    end
    FM.BuildCatalog()
    local node = dest and FM.nodesByKey[FM.Key(dest)]
    local yards = node and FM.DistanceToNode(node)
    if yards then
        GameTooltip:AddDoubleLine(L("Distance"), FM.FormatDistance(yards, Mod:GetDB().distanceUnit),
            1, 0.82, 0, 1, 1, 1)
    end
    GameTooltip:Show()
end

function Mod:HookFlightMapTooltips()
    if not self.hookedTaxiButtons and type(_G.TaxiNodeOnButtonEnter) == "function" then
        hooksecurefunc("TaxiNodeOnButtonEnter", function(button)
            AddEstimateToTooltip(button and button.GetID and button:GetID())
        end)
        self.hookedTaxiButtons = true
    end
    local pinMixin = _G.FlightMap_FlightPointPinMixin
    if not self.hookedFlightMapPins and type(pinMixin) == "table" and pinMixin.OnMouseEnter then
        hooksecurefunc(pinMixin, "OnMouseEnter", function(pin)
            AddEstimateToTooltip(pin and pin.taxiNodeData and pin.taxiNodeData.slotIndex)
        end)
        self.hookedFlightMapPins = true
    end
end

function Mod:ADDON_LOADED(_, addonName)
    if addonName == "Blizzard_FlightMap" then
        self:HookFlightMapTooltips()
    end
end

-- ============================================================================
-- LIFECYCLE
-- ============================================================================

function Mod:OnEnable()
    local db = self:GetDB()
    if not db.enable then return end

    if not self:IsHooked("TakeTaxiNode") and type(_G.TakeTaxiNode) == "function" then
        self:SecureHook("TakeTaxiNode", "OnTakeTaxiNode")
    end
    self:HookFlightMapTooltips()

    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    if self.InitSync then self:InitSync() end
    self:RegisterEvent("TAXIMAP_OPENED")
    self:RegisterEvent("TAXIMAP_CLOSED")
    self:RegisterEvent("ADDON_LOADED")
    self:RegisterEvent("PLAYER_CONTROL_LOST", "HandleTaxiStateEvent")
    self:RegisterEvent("PLAYER_CONTROL_GAINED", "HandleTaxiStateEvent")
    self:RegisterEvent("ZONE_CHANGED_NEW_AREA", function() FM.Invalidate() end)

    self:PLAYER_ENTERING_WORLD()
end

function Mod:OnDisable()
    self:UnregisterAllEvents()
    self:UnhookAll()
    self.hookedTaxiButtons, self.hookedFlightMapPins = nil, nil
    if self.taxiTicker then
        self.taxiTicker:Cancel()
        self.taxiTicker = nil
    end
    previewing = false
    if frame then frame:Hide() end
    if self.guideFrame then self.guideFrame:Hide() end
end

function Mod:Refresh()
    self:GetDB()
    self:ApplyBarStyle()
    ApplyPosition()
    self:UpdateBarVisibility()
    if self.ApplyGuideStyle then self:ApplyGuideStyle() end
    if self.guideFrame and self.guideFrame:IsShown() and self.RefreshGuide then
        self:RefreshGuide()
    end
end

-- ============================================================================
-- SLASH COMMANDS
-- ============================================================================

SLASH_KULLTHRANUIFLIGHTMASTER1 = "/kfm"
SLASH_KULLTHRANUIFLIGHTMASTER2 = "/kflight"
SlashCmdList["KULLTHRANUIFLIGHTMASTER"] = function(msg)
    msg = (msg or ""):lower():gsub("^%s+", ""):gsub("%s+$", "")
    if msg == "preview" then
        Mod:TogglePreview()
    elseif msg == "debug" then
        local nodes = FM.BuildCatalog(true)
        local d = FM.diag or {}
        local mapID = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
        local discovered = 0
        for _ in pairs(FM.GetStore().discovered) do discovered = discovered + 1 end
        local known, npcs = 0, 0
        for _, node in ipairs(nodes) do
            if FM.IsKnown(node) then known = known + 1 end
            if FM.GetFlightMasterNPC(node) then npcs = npcs + 1 end
        end
        print(string.format("|cff00ccffKullThranUI|r FlightMaster: nodes=%d known=%d npcs=%d map=%s roots=%d mapsQueried=%d mapsWithNodes=%d scanned=%s discovered=%d taxiAPI=%s",
            #nodes, known, npcs, tostring(mapID), d.roots or 0, d.mapsQueried or 0, d.mapsWithNodes or 0, tostring(d.scanned),
            discovered, tostring(C_TaxiMap and C_TaxiMap.GetTaxiNodesForMap ~= nil)))
        local pc, px, py, pmap, pcont = FM.GetPlayerWorldPos()
        print(string.format("  player: cont=%s contMap=%s map=%s wx=%s wy=%s", tostring(pc), tostring(pcont), tostring(pmap),
            tostring(px and math.floor(px)), tostring(py and math.floor(py))))
        local sample = nodes[1]
        if sample then
            print(string.format("  sample: %s cont=%s contMap=%s wx=%s wy=%s", tostring(sample.name), tostring(sample.continentID), tostring(sample.contMap),
                tostring(sample.wx and math.floor(sample.wx)), tostring(sample.wy and math.floor(sample.wy))))
        end
    elseif msg == "reset" then
        FM.ResetTimings()
        print("|cff00ccffKullThranUI|r " .. L("Reset recorded flight times"))
    else
        Mod:ToggleGuide()
    end
end
