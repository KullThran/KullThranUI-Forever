-- Modules/FlightMaster/FlightMaster_Options.lua
-- Registers the "Flight Master" page in KullThranUI's custom Options menu.
local _, ns = ...
local KT = LibStub("AceAddon-3.0"):GetAddon("KullThranUI", true)
if not KT then return end

local FM = ns.FM
local L = FM.L

local Opt = KT.Options or {}
local Reload = Opt.Reload or function() StaticPopup_Show("KULLTHRANUI_RELOAD") end
local GetFontValues = Opt.GetFontValues
local GetStatusbarValues = Opt.GetStatusbarValues

local function GetMod()
    return KT:GetModule("FlightMaster", true)
end

local function RefreshFlightMaster()
    local M = GetMod()
    if M and M.Refresh then
        M:Refresh()
    end
end

KT:RegisterPage("flightmaster", L("Flight Master"), 60, function(sc, W)
    local y, h = 0, 0
    local M = GetMod()
    local db = M and M:GetDB()
    if not db then
        _, h = W:Label(sc, "|cffFF4444" .. L("Flight Master module not enabled.") .. "|r", -y, 12); y = y + h
        return y
    end

    -- The flight point guide itself, embedded at the top of the page.
    if db.enable ~= false and M.EmbedGuide then
        local holder = CreateFrame("Frame", nil, sc)
        holder:SetPoint("TOPLEFT", sc, "TOPLEFT", 0, -y)
        holder:SetSize((sc:GetWidth() or 660) - 10, 520)
        M:EmbedGuide(holder, holder:GetWidth(), 520)
        y = y + 530
    end

    _, h = W:SectionHeader(sc, L("General"), -y); y = y + h
    _, h = W:Label(sc, L("Flight times are measured on every real flight and shared by all your characters. Routes never flown are estimated from their hop distances."), -y, 11); y = y + h
    _, h = W:Label(sc, L("Use /kfm to open the flight point guide."), -y, 11); y = y + h
    _, h = W:Toggle(sc, L("Enable Module"), -y,
        function() return db.enable ~= false end,
        function(v) db.enable = v; Reload() end); y = y + h
    _, h = W:Toggle(sc, L("Open guide at flight masters"), -y,
        function() return db.openAtTaxi ~= false end,
        function(v) db.openAtTaxi = v end); y = y + h

    _, h = W:SectionHeader(sc, L("Flight Duration Bar"), -y); y = y + h
    _, h = W:Toggle(sc, L("Show flight bar"), -y,
        function() return db.showBar ~= false end,
        function(v) db.showBar = v; RefreshFlightMaster() end); y = y + h
    _, h = W:Toggle(sc, L("Show time on flight map tooltips"), -y,
        function() return db.showTaxiTooltip ~= false end,
        function(v) db.showTaxiTooltip = v end); y = y + h
    _, h = W:Dropdown(sc, L("Time display"), -y,
        { ["remaining"] = L("Remaining"), ["arrival"] = L("Arrival time") },
        function() return db.timeDisplay or "remaining" end,
        function(v) db.timeDisplay = v end); y = y + h
    _, h = W:Dropdown(sc, L("Arrival sound"), -y,
        { ["NONE"] = L("None"), ["READY_CHECK"] = L("Ready check"), ["RAID_WARNING"] = L("Raid warning"),
          ["QUEST_COMPLETE"] = L("Quest complete"), ["LEVEL_UP"] = L("Level up") },
        function() return db.arrivalSound or "READY_CHECK" end,
        function(v) db.arrivalSound = v; if M.PlayArrivalSound then M:PlayArrivalSound() end end); y = y + h
    _, h = W:Toggle(sc, L("Show early landing button"), -y,
        function() return db.earlyLandingButton ~= false end,
        function(v) db.earlyLandingButton = v end); y = y + h
    _, h = W:Button(sc, L("Toggle preview"), -y, function()
        if M.TogglePreview then M:TogglePreview() end
    end); y = y + h
    _, h = W:Slider(sc, L("Width"), -y,
        function() return db.width or 280 end,
        function(v) db.width = v; RefreshFlightMaster() end, 120, 800, 1); y = y + h
    _, h = W:Slider(sc, L("Height"), -y,
        function() return db.height or 18 end,
        function(v) db.height = v; RefreshFlightMaster() end, 6, 60, 1); y = y + h
    _, h = W:Slider(sc, "X Offset", -y,
        function() return db.xOffset or 0 end,
        function(v) db.xOffset = v; RefreshFlightMaster() end, -1000, 1000, 1); y = y + h
    _, h = W:Slider(sc, "Y Offset", -y,
        function() return db.yOffset or -150 end,
        function(v) db.yOffset = v; RefreshFlightMaster() end, -1200, 0, 1); y = y + h

    _, h = W:SectionHeader(sc, L("Appearance"), -y); y = y + h
    if GetStatusbarValues then
        _, h = W:Dropdown(sc, L("Texture"), -y, GetStatusbarValues,
            function() return db.texture or "Melli" end,
            function(v) db.texture = v; RefreshFlightMaster() end); y = y + h
    end
    if GetFontValues then
        _, h = W:Dropdown(sc, L("Font"), -y, GetFontValues,
            function() return db.font or "AAA_ITC_Avant_Garde" end,
            function(v) db.font = v; RefreshFlightMaster() end); y = y + h
    end
    _, h = W:Slider(sc, L("Font Size"), -y,
        function() return db.fontSize or 12 end,
        function(v) db.fontSize = v; RefreshFlightMaster() end, 8, 24, 1); y = y + h
    _, h = W:Dropdown(sc, L("Outline"), -y,
        { ["NONE"] = "None", ["OUTLINE"] = "Thin", ["THICKOUTLINE"] = "Thick" },
        function() return db.fontOutline or "OUTLINE" end,
        function(v) db.fontOutline = v; RefreshFlightMaster() end); y = y + h
    _, h = W:Toggle(sc, L("Use theme color"), -y,
        function() return db.useThemeColor ~= false end,
        function(v) db.useThemeColor = v; RefreshFlightMaster() end); y = y + h
    _, h = W:ColorSwatch(sc, L("Bar color"), -y,
        function()
            local c = db.barColor or { r = 0.25, g = 0.65, b = 0.95, a = 1 }
            return c.r, c.g, c.b, c.a
        end,
        function(r, g, b, a)
            db.useThemeColor = false
            db.barColor = { r = r, g = g, b = b, a = a }
            RefreshFlightMaster()
        end, true); y = y + h

    _, h = W:SectionHeader(sc, L("Flight Point Guide"), -y); y = y + h
    _, h = W:Toggle(sc, L("Hide opposite faction points"), -y,
        function() return db.hideOppositeFaction ~= false end,
        function(v) db.hideOppositeFaction = v; RefreshFlightMaster() end); y = y + h
    _, h = W:Dropdown(sc, L("Distance units"), -y,
        { ["yards"] = L("Yards"), ["meters"] = L("Meters") },
        function() return db.distanceUnit or "yards" end,
        function(v) db.distanceUnit = v; RefreshFlightMaster() end); y = y + h

    _, h = W:SectionHeader(sc, L("Sharing"), -y); y = y + h
    _, h = W:Label(sc, L("Other KullThranUI users in your guild or group send the times they measure, and you send yours."), -y, 11); y = y + h
    _, h = W:Toggle(sc, L("Share flight times with guild and group"), -y,
        function() return db.shareTimes ~= false end,
        function(v) db.shareTimes = v end); y = y + h
    _, h = W:Label(sc, string.format(L("Shared routes received: %d"), FM.CountSharedRoutes()), -y, 11); y = y + h
    _, h = W:Button(sc, L("Send all my times now"), -y, function()
        local n = M.ShareAllTimings and M:ShareAllTimings() or 0
        print("|cff00ccffKullThranUI|r " .. string.format(L("Sent %d flight times."), n))
    end); y = y + h

    _, h = W:SectionHeader(sc, L("Recorded times"), -y); y = y + h
    local speed, calibrated = FM.GetFlightSpeed()
    local speedText = string.format("%.1f yd/s", speed) .. (calibrated and "" or (" (" .. L("default") .. ")"))
    _, h = W:Label(sc, string.format(L("Recorded routes: %d  ·  Calibrated speed: %s"), FM.CountRecordedRoutes(), speedText), -y, 11); y = y + h
    _, h = W:Button(sc, L("Reset recorded flight times"), -y, function()
        FM.ResetTimings()
        if KT.RefreshPage then KT:RefreshPage() end
    end, nil, true); y = y + h

    return y
end, "hud_navigation")
