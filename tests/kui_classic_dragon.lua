local root = arg[1] or "."
LibStub = function() return { GetAddon = function() return {} end } end
local ns = {}
assert(loadfile(root .. "/KullThranUI_UnitFrames/Modules/KUIUnitFrames/KUI_ThemeOrnaments.lua"))("test", ns)
local function texture(parent)
    local t = { parent = parent }
    function t:GetParent() return self.parent end
    function t:SetTexture(v) self.file = v end
    function t:SetTexCoord(...) self.uv = {...} end
    function t:SetPoint(...) self.point = {...} end
    function t:SetSize(w, h) self.w, self.h = w, h end
    function t:ClearAllPoints() end
    function t:Hide() self.shown = false end
    function t:Show() self.shown = true end
    return t
end
local parent = { CreateTexture = function(self) return texture(self) end }
local CR = { portraitCX = 74.5, portraitCY = 45.5, innerRadius = 35,
    dragons = { elite = "classic_dragon_elite.blp", rare = "classic_dragon_rare.blp" } }
local tex, portrait = texture(parent), {}
for _, scale in ipairs({0.4, 0.6, 1}) do
    for _, kind in ipairs({"elite", "rare"}) do
        assert(ns.KUIOrnaments.FitClassicDragon(tex, portrait, CR, kind, scale, "kui"))
        assert(not tex.shown, "unsuited full crop is hidden")
        assert(#tex._kuiDragonPieces == 43, "bounded, reusable texture slices")
        for i, piece in ipairs(tex._kuiDragonPieces) do
            assert(piece.file == CR.dragons[kind], "retains selected Classic source art")
            assert(piece.shown and piece.w > 0 and piece.h > 0)
            for _, coord in ipairs(piece.uv) do assert(coord >= 0 and coord <= 1) end
            if i >= 3 then
                -- The aperture's inner edge follows the circular KUI rim,
                -- including rows that previously bent around the level socket.
                local dy = 45 + i - 2 + 0.5 - CR.portraitCY
                local innerX = piece.point[4] / scale
                local outerX = innerX + piece.w / scale
                assert(math.abs(outerX^2 + dy^2 - 42^2) < 0.001,
                    "stock level loop cannot extend beyond fitted tail")
                if dy < 35 then
                    assert(math.abs(innerX^2 + dy^2 - 35^2) < 0.001,
                        "tail clears the circular portrait")
                else
                    assert(innerX == 0, "tail ends below the portrait opening")
                end
            end
        end
        local first = tex._kuiDragonPieces[1]
        ns.KUIOrnaments.FitClassicDragon(tex, portrait, CR, kind, scale, "classic")
        assert(not first.shown, "switching style clears fitted overlay")
        ns.KUIOrnaments.FitClassicDragon(tex, portrait, CR, kind, scale, "kui")
        assert(first == tex._kuiDragonPieces[1], "refresh reuses textures")
        ns.KUIOrnaments.HideClassicDragon(tex)
        for _, piece in ipairs(tex._kuiDragonPieces) do assert(not piece.shown) end
    end
end
print("kui_classic_dragon: ok")
