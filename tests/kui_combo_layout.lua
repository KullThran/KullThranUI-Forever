local root = arg[1] or "."
local theme = "kui"
local KT = { VisualThemes = { GetRenderedTheme = function() return theme end } }
LibStub = function() return { GetAddon = function() return KT end } end
local ns = {}
assert(loadfile(root .. "/KullThranUI_UnitFrames/Modules/KUIUnitFrames/KUI_ThemeOrnaments.lua"))("test", ns)
local function region(x, y, w, h, scale)
    return {
        IsShown = function() return true end,
        GetCenter = function() return x, y end,
        GetWidth = function() return w end,
        GetHeight = function() return h end,
        GetEffectiveScale = function() return scale end,
    }
end
for _, scale in ipairs({ 0.75, 1, 1.5 }) do
    for _, side in ipairs({ -1, 1 }) do
        local portrait = region(200, 100, 46, 46, scale)
        local frame = region(200 + side * 110, 100, 260, 46, scale)
        frame.Health = region(200 + side * 110, 100, 220, 46, scale)
        frame._kuiLevelText = region(200, 140, 20, 12, scale)
        for count = 1, 10 do
            local row = ns.KUIOrnaments.LayoutRing(frame, portrait, count, 10, true)
            assert(#row == count, "all resource points remain available")
            for i, point in ipairs(row) do
                assert(point[2] - 5 > 23, "point clears health bar and portrait")
                assert(point[2] - 5 > 46, "point clears level number")
                assert(not point.onlyFilled, "extra resource sockets stay visible")
                if i > 1 then
                    assert(point[1] - row[i-1][1] >= 14, "points cannot overlap")
                    assert(point[2] == row[i-1][2], "row stays horizontal on either side")
                end
            end
            assert(math.abs(row[1][1] + row[count][1]) < 0.001, "row centred over portrait")
        end
        for _, stock in ipairs({ "classic", "forever", "retail" }) do
            theme = stock
            local row = ns.KUIOrnaments.LayoutRing(frame, portrait, 5, 10, true)
            assert(row[1][2] ~= row[5][2], "stock style keeps its portrait arc")
        end
        theme = "kui"
    end
end
print("kui_combo_layout: ok")
