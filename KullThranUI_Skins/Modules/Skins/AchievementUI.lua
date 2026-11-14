local KT = LibStub("AceAddon-3.0"):GetAddon("KullThranUI")
local S = KT:GetModule("Skins")
local _G = _G
local hooksecurefunc = hooksecurefunc
local CreateColor = CreateColor
local pairs, next = pairs, next
local GetAchievementNumCriteria = GetAchievementNumCriteria
local GetAchievementCriteriaInfo = GetAchievementCriteriaInfo
local bit = bit

local SkinAchievementUI
local achievementSkinWatcher

local function ScheduleAchievementSkin()
    if C_Timer and C_Timer.After then
        C_Timer.After(0, function()
            if S:IsWindowEnabled("achievement") and SkinAchievementUI then
                SkinAchievementUI()
            end
        end)
    elseif SkinAchievementUI then
        SkinAchievementUI()
    end
end

local function EnsureAchievementSkinWatcher()
    if achievementSkinWatcher then return end

    achievementSkinWatcher = CreateFrame("Frame")
    local elapsed = 0
    achievementSkinWatcher:SetScript("OnUpdate", function(self, delta)
        elapsed = elapsed + (delta or 0)
        if elapsed < 0.05 then return end
        elapsed = 0

        if _G.AchievementFrame then
            SkinAchievementUI()
            self:SetScript("OnUpdate", nil)
        end
    end)
end

local function PatchAchievementOverridePoints()
    if not S:IsForeverProject() then return end

    local current = _G.AchievementFrame_GetOverridePoints
    if type(current) ~= "function" or current == S._ktAchievementOverrideWrapper then
        return
    end

    local original = current
    local wrapper
    wrapper = function(points, achievementId, ...)
        if achievementId == nil then
            return points or 0
        end
        return original(points, achievementId, ...)
    end

    S._ktAchievementOverrideWrapper = wrapper
    _G.AchievementFrame_GetOverridePoints = wrapper
end

-- Forever's comparison view selects the Summary category as the string
-- "summary", but AchievementFrameComparison_UpdateStatusBars passes its id to
-- GetCategoryNumAchievements, which only takes numbers, and expects
-- ACHIEVEMENT_COMPARISON_SUMMARY_ID (-1) for the summary. Translate the id.
local function PatchComparisonStatusBars()
    if not S:IsForeverProject() then return end

    local current = _G.AchievementFrameComparison_UpdateStatusBars
    if type(current) ~= "function" or current == S._ktComparisonStatusWrapper then
        return
    end

    local wrapper = function(id, ...)
        if id == "summary" then
            id = _G.ACHIEVEMENT_COMPARISON_SUMMARY_ID or -1
        end
        return current(id, ...)
    end

    S._ktComparisonStatusWrapper = wrapper
    _G.AchievementFrameComparison_UpdateStatusBars = wrapper
end

local function EnsureAchievementOverridePointsWatcher()
    if not S:IsForeverProject() or S._ktAchievementOverrideWatcher then return end

    local watcher = CreateFrame("Frame")
    watcher:RegisterEvent("ADDON_LOADED")
    watcher:SetScript("OnEvent", function(_, _, addonName)
        if addonName == "Blizzard_AchievementUI" or addonName == "Blizzard_LegacySystem" then
            PatchAchievementOverridePoints()
            PatchComparisonStatusBars()
            if C_Timer and C_Timer.After then
                C_Timer.After(0, PatchAchievementOverridePoints)
                C_Timer.After(0, PatchComparisonStatusBars)
            end
        end
    end)
    S._ktAchievementOverrideWatcher = watcher
end

if S:IsForeverProject() then
    -- Install the watcher even when the Achievements skin toggle is disabled:
    -- Blizzard_LegacySystem can replace this function during its load pass.
    EnsureAchievementOverridePointsWatcher()
    PatchAchievementOverridePoints()
    PatchComparisonStatusBars()
end

local function SetNativeArtwork(texture, alpha, brightness, desaturation, preserveVisibility)
    -- One Skins darkening (S:ToneNativeArt); a brighter opaque state keeps the
    -- accent step and alpha 0 still hides the art.
    if not texture or S:IsKuiSurfaceRegion(texture) then return end
    if (alpha or 1) <= 0 then
        if texture.SetAlpha then texture:SetAlpha(0) end
        return
    end
    S:ToneNativeArt(texture, (alpha or 1) >= 1 and (brightness or 1) >= 0.6, preserveVisibility)
end

local function ApplyAchievementPanelSurface(frame)
    if not (frame and S.ApplyKuiSurface) then return end

    if not frame._ktAchievementBackdrop then
        pcall(S.CreateBackdrop, S, frame, true)
        frame._ktAchievementBackdrop = true
        if frame.backdrop then
            frame.backdrop:SetBackdropColor(0, 0, 0, 0.18)
            frame.backdrop:SetBackdropBorderColor(unpack(S:GetBorderColor()))
        end
    end

    S:ApplyKuiSurface(frame, { level = "inset" })
    if not frame._ktAchievementSurfaceHooked and frame.HookScript then
        frame:HookScript("OnShow", function(self)
            if S:IsWindowEnabled("achievement") then
                S:ApplyKuiSurface(self, { level = "inset" })
            end
        end)
        frame._ktAchievementSurfaceHooked = true
    end
end

local function ApplyAchievementPanelSatin(frame, options)
    -- Keep this helper as the single entry point for the shared KUI texture.
    -- The old satin layer is deliberately not used on Forever or Retail.
    ApplyAchievementPanelSurface(frame)
end

local function SkinAchievementPanel(frame)
    if not frame then return end

    ApplyAchievementPanelSurface(frame)

    local scrollBar = frame.ScrollBar
    if not scrollBar and frame.ScrollBox then scrollBar = frame.ScrollBox.ScrollBar end
    if not scrollBar and frame.ScrollFrame then scrollBar = frame.ScrollFrame.ScrollBar end
    if scrollBar then S:HandleScrollBar(scrollBar) end

    if frame.GetRegions then
        for index = 1, frame:GetNumRegions() do
            local region = select(index, frame:GetRegions())
            if region and region.IsObjectType and region:IsObjectType("FontString") then
                S:HandleFont(region)
            end
        end
    end
end

-- Helper for StatusBars
local function SkinStatusBar(bar)
    if not bar then return end
    S:StripTextures(bar)
    S:CreateBackdrop(bar)
    if bar.SetStatusBarTexture then
        bar:SetStatusBarTexture("Interface\\Buttons\\WHITE8x8")
        bar:GetStatusBarTexture():SetGradient("VERTICAL", CreateColor(0, 0.4, 0, 1), CreateColor(0, 0.6, 0, 1))
    end
end

local function HandleSummaryBar(frame)
    if not frame then return end
    S:StripTextures(frame)
    local bar = frame.StatusBar
    if not bar then return end
    SkinStatusBar(bar)

    local title = bar.Title
    if title then
        S:HandleFont(title)
        title:SetTextColor(1, 1, 1)
        title:ClearAllPoints()
        title:SetPoint("LEFT", bar, "LEFT", 6, 1)
        title:SetJustifyH("LEFT")
    end

    local value = bar.Text
    if value then
        S:HandleFont(value)
        value:ClearAllPoints()
        value:SetPoint("RIGHT", bar, "RIGHT", -5, 1)
        value:SetJustifyH("RIGHT")
    end
end

local function SetupButtonHighlight(button, backdrop)
    if not button then return end
    button:SetHighlightTexture("Interface\\Buttons\\WHITE8x8")
    local highlight = button:GetHighlightTexture()
    if highlight then
        highlight:SetVertexColor(1, 1, 1, 0.2)
        highlight:SetBlendMode("ADD")
        S:SetInside(highlight, backdrop or button)
    end
end

local function SkinCategoryRow(child)
    local button = child.Button
    if not button or button.isSkinned then return end
    S:StripTextures(button)
    S:CreateBackdrop(button)
    local backdrop = button.backdrop
    backdrop:SetBackdropColor(0, 0, 0, 0.16)
    backdrop:SetBackdropBorderColor(0, 0, 0, 1)
    backdrop:SetPoint("TOPLEFT", 0, -1)
    backdrop:SetPoint("BOTTOMRIGHT", 0, 1)
    SetupButtonHighlight(button, backdrop)
    if button.Label then
        S:HandleFont(button.Label)
    end
    button.isSkinned = true
end

local function UpdateAccountString(button)
    local date = button.DateCompleted
    local label = button.Label
    if date and date:IsShown() then
        if button.accountWide then
            label:SetTextColor(0, 0.6, 1)
        else
            label:SetTextColor(0.9, 0.9, 0.9)
        end
    elseif button.accountWide then
        label:SetTextColor(0, 0.3, 0.5)
    else
        label:SetTextColor(0.65, 0.65, 0.65)
    end
end

local function SkinAchievementButton(button)
    if not button.isSkinned then
        S:StripTextures(button, true)
        if button.Background then button.Background:SetAlpha(0) end
        if button.Highlight then button.Highlight:SetAlpha(0) end

        local icon = button.Icon
        if icon and icon.frame then
            icon.frame:Hide()
        end

        for _, field in ipairs({ "Description", "Label", "Reward", "DateCompleted", "HiddenDescription" }) do
            if button[field] then
                S:HandleFont(button[field])
            end
        end

        S:CreateBackdrop(button)
        local backdrop = button.backdrop
        backdrop:SetBackdropColor(0, 0, 0, 0.16)
        backdrop:SetBackdropBorderColor(0, 0, 0, 1)
        backdrop:SetPoint("TOPLEFT", 2, -2)
        backdrop:SetPoint("BOTTOMRIGHT", -2, 2)

        if icon and icon.texture then
            S:HandleIcon(icon.texture)
        end
        if button.Tracked then
            S:HandleCheckBox(button.Tracked)
            button.Tracked:SetSize(20, 20)
        end
        if button.Check then
            button.Check:SetAlpha(0)
        end
        if button.UpdatePlusMinusTexture then
            hooksecurefunc(button, "UpdatePlusMinusTexture", UpdateAccountString)
        end
        button.isSkinned = true
    end

    if button.Description then
        button.Description:SetTextColor(0.9, 0.9, 0.9)
    end
    if button.HiddenDescription then
        button.HiddenDescription:SetTextColor(0.9, 0.9, 0.9)
    end
end

local function StyleAchievementCriteria(objectivesFrame, id)
    if not objectivesFrame or not objectivesFrame.GetCriteria then return end
    local textRow = 0
    for i = 1, GetAchievementNumCriteria(id) do
        local _, criteriaType, completed, _, _, _, flags, assetID = GetAchievementCriteriaInfo(id, i)
        local isMeta = criteriaType == CRITERIA_TYPE_ACHIEVEMENT and assetID
        if not isMeta
            and bit.band(flags, EVALUATION_TREE_FLAG_PROGRESS_BAR) ~= EVALUATION_TREE_FLAG_PROGRESS_BAR then
            textRow = textRow + 1
            local row = objectivesFrame:GetCriteria(textRow)
            if row and row.Name then
                S:HandleFont(row.Name)
                if completed then
                    row.Name:SetTextColor(0, 1, 0)
                else
                    row.Name:SetTextColor(0.6, 0.6, 0.6)
                end
            end
        end
    end
end

SkinAchievementUI = function()
    EnsureAchievementSkinWatcher()
    if not S:IsWindowEnabled("achievement") then return end

    -- Blizzard bug: the comparison summary arrives as "summary" (see above).
    PatchComparisonStatusBars()

    -- Forever replaces this function while Blizzard_LegacySystem loads, so
    -- install it now and reapply it after either Achievement addon finishes.
    EnsureAchievementOverridePointsWatcher()
    PatchAchievementOverridePoints()

    local AchievementFrame = _G.AchievementFrame
    if not AchievementFrame then return end
    S:HandlePortraitFrame(AchievementFrame)
    ApplyAchievementPanelSatin(AchievementFrame, {
        inset = 10, baseAlpha = 0.17, sheenAlpha = 0.055, edgeAlpha = 0.12,
    })

    -- Forever's achievement window can expose different child names from the
    -- Retail frame. Skin every available content panel through the shared KUI
    -- surface before applying the legacy-specific controls below.
    local panels = {
        _G.AchievementFrameCategories,
        _G.AchievementFrameAchievements,
        _G.AchievementFrameSummary,
        _G.AchievementFrameStats,
        _G.AchievementFrameComparison,
        AchievementFrame.Categories,
        AchievementFrame.Achievements,
        AchievementFrame.Summary,
        AchievementFrame.Stats,
        AchievementFrame.Comparison,
        AchievementFrame.Content,
        AchievementFrame.ContentFrame,
        AchievementFrame.Panel,
    }
    for _, panel in ipairs(panels) do
        SkinAchievementPanel(panel)
    end

    if not AchievementFrame._ktAchievementSkinShowHooked and AchievementFrame.HookScript then
        AchievementFrame:HookScript("OnShow", ScheduleAchievementSkin)
        AchievementFrame._ktAchievementSkinShowHooked = true
    end

    -- The castle hall art is a child frame that covers the whole shell and
    -- hides the KUI surface; remove it so the texture shows through. The frame
    -- name differs across builds, so also scan direct children.
    local function KillAchievementHall()
        local hall = _G.AchievementFrame
        if not hall then return end
        if hall.Background then
            S:Kill(hall.Background)
        end
        if _G.AchievementFrameBackground then
            S:Kill(_G.AchievementFrameBackground)
        end
        if hall.GetChildren then
            for _, child in ipairs({ hall:GetChildren() }) do
                local name = child.GetName and child:GetName() or ""
                if name:find("Background", 1, true) then
                    S:Kill(child)
                end
            end
        end
    end
    KillAchievementHall()
    if not AchievementFrame._ktHallKilled then
        AchievementFrame:HookScript("OnShow", KillAchievementHall)
        AchievementFrame._ktHallKilled = true
    end

    -- Keep the large native artwork visible under the neutral satin surface.
    for i = 1, AchievementFrame:GetNumRegions() do
        local r = select(i, AchievementFrame:GetRegions())
        if r and r.IsObjectType and r:IsObjectType("Texture") then
            local drawLayer = r.GetDrawLayer and r:GetDrawLayer()
            if drawLayer == "BACKGROUND" then
                SetNativeArtwork(r, 0.10, 0.74, 0.10)
            elseif drawLayer == "BORDER" then
                SetNativeArtwork(r, 0.12, 0.66, 0.16)
            end
        end
    end

    if AchievementFrame.Header then
        -- Header engraving remains visible but stays behind the content.
        for i = 1, AchievementFrame.Header:GetNumRegions() do
            local r = select(i, AchievementFrame.Header:GetRegions())
            if r and r.IsObjectType and r:IsObjectType("Texture") then
                SetNativeArtwork(r, 0.12, 0.72, 0.12)
            end
        end
        if AchievementFrame.Header.Title then AchievementFrame.Header.Title:Hide() end
        if AchievementFrame.Header.Points then 
            AchievementFrame.Header.Points:ClearAllPoints()
            AchievementFrame.Header.Points:SetPoint("TOP", AchievementFrame, "TOP", 0, -5) 
            S:HandleFont(AchievementFrame.Header.Points)
        end
    end

    if AchievementFrame.SearchBox then
        S:HandleEditBox(AchievementFrame.SearchBox)
        AchievementFrame.SearchBox:ClearAllPoints()
        AchievementFrame.SearchBox:SetPoint("TOPRIGHT", AchievementFrame, "TOPRIGHT", -25, -25)
    end

    if _G.AchievementFrameFilterDropdown then
        S:HandleDropDownBox(_G.AchievementFrameFilterDropdown)
        _G.AchievementFrameFilterDropdown:ClearAllPoints()
        _G.AchievementFrameFilterDropdown:SetPoint("RIGHT", AchievementFrame.SearchBox, "LEFT", -5, 0)
    end

    for i = 1, 3 do
        local tab = _G["AchievementFrameTab"..i]
        if tab then S:HandleTab(tab) end
    end

    -- Categories
    if _G.AchievementFrameCategories then
        ApplyAchievementPanelSatin(_G.AchievementFrameCategories)

        for i = 1, _G.AchievementFrameCategories:GetNumRegions() do
            local r = select(i, _G.AchievementFrameCategories:GetRegions())
            if r and r.IsObjectType and r:IsObjectType("Texture") then
                SetNativeArtwork(r, 0.10, 0.70, 0.12)
            end
        end
        if _G.AchievementFrameCategories.ScrollBar then
            S:HandleScrollBar(_G.AchievementFrameCategories.ScrollBar)
        end
        
        local categories = _G.AchievementFrameCategories
        local categoryBox = categories and categories.ScrollBox
        if categoryBox and not categoryBox._ktAchievementSkinHooked then
            hooksecurefunc(categoryBox, "Update", function(box)
                box:ForEachFrame(SkinCategoryRow)
            end)
            categoryBox._ktAchievementSkinHooked = true
        end
    end

    -- Achievements
    if _G.AchievementFrameAchievements then
        ApplyAchievementPanelSatin(_G.AchievementFrameAchievements)

        for i = 1, _G.AchievementFrameAchievements:GetNumRegions() do
            local r = select(i, _G.AchievementFrameAchievements:GetRegions())
            if r and r.IsObjectType and r:IsObjectType("Texture") then
                SetNativeArtwork(r, 0.10, 0.70, 0.12)
            end
        end
        if _G.AchievementFrameAchievements.ScrollBar then
            S:HandleScrollBar(_G.AchievementFrameAchievements.ScrollBar)
        end
        
        if _G.AchievementFrameAchievements.ScrollBox and not _G.AchievementFrameAchievements.ScrollBox._ktAchievementSkinHooked then
            hooksecurefunc(_G.AchievementFrameAchievements.ScrollBox, "Update", function(self)
                self:ForEachFrame(SkinAchievementButton)
            end)
            _G.AchievementFrameAchievements.ScrollBox._ktAchievementSkinHooked = true
        end
    end

    -- Summary
    if _G.AchievementFrameSummary then
        ApplyAchievementPanelSatin(_G.AchievementFrameSummary)

        for i = 1, _G.AchievementFrameSummary:GetNumRegions() do
            local r = select(i, _G.AchievementFrameSummary:GetRegions())
            if r and r.IsObjectType and r:IsObjectType("Texture") then
                SetNativeArtwork(r, 0.10, 0.72, 0.10)
            end
        end
        
        if _G.AchievementFrameSummaryCategoriesHeaderTitle then
            S:HandleFont(_G.AchievementFrameSummaryCategoriesHeaderTitle)
            _G.AchievementFrameSummaryCategoriesHeaderTitle:SetTextColor(1, 1, 1)
        end
        if _G.AchievementFrameSummaryAchievementsHeaderTitle then
            S:HandleFont(_G.AchievementFrameSummaryAchievementsHeaderTitle)
            _G.AchievementFrameSummaryAchievementsHeaderTitle:SetTextColor(1, 1, 1)
        end

        for i = 1, 12 do
            local name = "AchievementFrameSummaryCategoriesCategory"..i
            local bu = _G[name]
            if bu then
                SkinStatusBar(bu)
                if bu.Label then 
                    S:HandleFont(bu.Label)
                    bu.Label:SetTextColor(1, 1, 1) 
                    bu.Label:ClearAllPoints()
                    bu.Label:SetPoint("LEFT", bu, "LEFT", 6, 1)
                    bu.Label:SetJustifyH("LEFT")
                end
                if bu.Text then 
                    S:HandleFont(bu.Text)
                    bu.Text:ClearAllPoints()
                    bu.Text:SetPoint("RIGHT", bu, "RIGHT", -5, 1)
                    bu.Text:SetJustifyH("RIGHT")
                end
                if _G[name.."ButtonHighlight"] then _G[name.."ButtonHighlight"]:SetAlpha(0) end
            end
        end
        if _G.AchievementFrameSummaryCategoriesStatusBar then
            SkinStatusBar(_G.AchievementFrameSummaryCategoriesStatusBar)
            local bar = _G.AchievementFrameSummaryCategoriesStatusBar
            if bar.Title then 
                S:HandleFont(bar.Title)
                bar.Title:ClearAllPoints()
                bar.Title:SetPoint("LEFT", bar, "LEFT", 6, 1)
            end
            if bar.Text then 
                S:HandleFont(bar.Text)
                bar.Text:ClearAllPoints()
                bar.Text:SetPoint("RIGHT", bar, "RIGHT", -5, 1)
            end
        end

        if _G.AchievementFrameSummary_UpdateAchievements and not S._ktAchievementSummaryUpdateHooked then
            hooksecurefunc("AchievementFrameSummary_UpdateAchievements", function()
            for i = 1, _G.ACHIEVEMENTUI_MAX_SUMMARY_ACHIEVEMENTS or 4 do
                local button = _G["AchievementFrameSummaryAchievement"..i]
                if button then
                    if not button.isSkinned then
                        S:StripTextures(button, true)
                        S:CreateBackdrop(button)
                        button.backdrop:SetBackdropColor(0, 0, 0, 0.16)
                        button.backdrop:SetBackdropBorderColor(0, 0, 0, 1)
                        button.backdrop:SetPoint("TOPLEFT", 2, -2)
                        button.backdrop:SetPoint("BOTTOMRIGHT", -2, 2)
                        
                        if button.Icon then
                            if button.Icon.frame then button.Icon.frame:Hide() end
                            if button.Icon.texture then 
                                S:HandleIcon(button.Icon.texture)
                            end
                        end
                        
                        if button.Label then S:HandleFont(button.Label) end
                        if button.Description then S:HandleFont(button.Description) end
                        if button.DateCompleted then S:HandleFont(button.DateCompleted) end
                        
                        button.isSkinned = true
                    end
                    
                    if button.Label then button.Label:SetTextColor(1, 1, 1) end
                    if button.Description then button.Description:SetTextColor(0.9, 0.9, 0.9) end
                end
            end
        end)
            S._ktAchievementSummaryUpdateHooked = true
        end
    end
    
    -- Stats
    if _G.AchievementFrameStats then
        ApplyAchievementPanelSatin(_G.AchievementFrameStats)

        for i = 1, _G.AchievementFrameStats:GetNumRegions() do
            local r = select(i, _G.AchievementFrameStats:GetRegions())
            if r and r.IsObjectType and r:IsObjectType("Texture") then
                SetNativeArtwork(r, 0.10, 0.70, 0.12)
            end
        end
        if _G.AchievementFrameStats.ScrollBar then
            S:HandleScrollBar(_G.AchievementFrameStats.ScrollBar)
        end
        if _G.AchievementFrameStats.ScrollBox then
             hooksecurefunc(_G.AchievementFrameStats.ScrollBox, "Update", function(self)
                self:ForEachFrame(function(child)
                    if not child.isSkinned then
                        S:StripTextures(child)
                        S:CreateBackdrop(child)
                        child.backdrop:SetBackdropColor(0, 0, 0, 0.16)
                        child.backdrop:SetBackdropBorderColor(0, 0, 0, 1)
                        child.backdrop:SetPoint("TOPLEFT", 2, -S.mult)
                        child.backdrop:SetPoint("BOTTOMRIGHT", 4, S.mult)
                        SetupButtonHighlight(child, child.backdrop)
                        if child.Text then S:HandleFont(child.Text) end
                        if child.Value then S:HandleFont(child.Value) end
                        child.isSkinned = true
                    end
                end)
            end)
        end
    end
    
    -- Comparison
    if _G.AchievementFrameComparison then
        local Comparison = _G.AchievementFrameComparison
        ApplyAchievementPanelSatin(Comparison)

        for i = 1, Comparison:GetNumRegions() do
            local r = select(i, Comparison:GetRegions())
            if r and r.IsObjectType and r:IsObjectType("Texture") then
                SetNativeArtwork(r, 0.10, 0.70, 0.12)
            end
        end
        if Comparison.Summary then
            HandleSummaryBar(Comparison.Summary.Player)
            HandleSummaryBar(Comparison.Summary.Friend)
        end
        if Comparison.AchievementContainer and Comparison.AchievementContainer.ScrollBar then
            S:HandleScrollBar(Comparison.AchievementContainer.ScrollBar)
        end
        if Comparison.StatContainer and Comparison.StatContainer.ScrollBar then
            S:HandleScrollBar(Comparison.StatContainer.ScrollBar)
        end
        if _G.AchievementFrameComparisonHeader then
             S:StripTextures(_G.AchievementFrameComparisonHeader)
             S:CreateBackdrop(_G.AchievementFrameComparisonHeader)
             _G.AchievementFrameComparisonHeader.backdrop:SetBackdropBorderColor(0, 0, 0, 1)
             _G.AchievementFrameComparisonHeader.backdrop:SetPoint("TOPLEFT", 20, -20)
             _G.AchievementFrameComparisonHeader.backdrop:SetPoint("BOTTOMRIGHT", -28, -5)
        end
    end

    -- Criteria Text Color (Black text issue)
    if _G.AchievementObjectives_DisplayCriteria and not S._ktAchievementCriteriaHooked then
        hooksecurefunc("AchievementObjectives_DisplayCriteria", StyleAchievementCriteria)
        S._ktAchievementCriteriaHooked = true
    end

    if achievementSkinWatcher then
        achievementSkinWatcher:SetScript("OnUpdate", nil)
    end
end

S:RegisterWindow("achievement", { addon = "Blizzard_AchievementUI", name = "Blizzard_AchievementUI", label = "Achievements", apply = SkinAchievementUI })
if S:IsForeverProject() then
    -- Forever keeps legacy UI load boundaries separate from Retail. Register
    -- this callback there as well when the compatibility system exposes the
    -- achievement frame through its own addon boundary.
    S:RegisterWindow("achievement", { addon = "Blizzard_LegacySystem", name = "Blizzard_LegacySystem", label = "Achievements", apply = SkinAchievementUI })
end
