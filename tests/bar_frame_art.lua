local function near(actual, expected, label)
    if math.abs(actual - expected) > 0.0001 then
        error(string.format("%s: expected %.4f, got %.4f", label, expected, actual))
    end
end

local function Region(parent)
    local r = { parent = parent, points = {}, width = 0, height = 0, shown = true }
    function r:SetClipsChildren(v) self.clips = v end
    function r:EnableMouse(v) self.mouse = v end
    function r:SetFrameStrata(v) self.strata = v end
    function r:GetFrameStrata() return self.strata or "LOW" end
    function r:SetFrameLevel(v) self.level = v end
    function r:GetFrameLevel() return self.level or 1 end
    function r:ClearAllPoints() self.points = {} end
    function r:SetPoint(...) self.points[#self.points + 1] = { ... } end
    function r:GetPoint(i) return unpack(self.points[i]) end
    function r:GetNumPoints() return #self.points end
    function r:SetSize(w, h) self.width, self.height = w, h end
    function r:GetSize() return self.width, self.height end
    function r:GetWidth() return self.width end
    function r:SetShown(v) self.shown = v end
    function r:IsShown() return self.shown end
    function r:Hide() self.shown = false end
    function r:SetTexture(v) self.texture = v end
    function r:GetTexture() return self.texture end
    function r:SetTexCoord(...) self.texCoord = { ... } end
    function r:GetTexCoord() return unpack(self.texCoord or { 0, 1, 0, 1 }) end
    function r:GetAtlas() return self.atlas end
    function r:SetVertexColor(...) self.vertex = { ... } end
    function r:CreateTexture()
        self.textureRegion = Region(self)
        return self.textureRegion
    end
    return r
end

_G.KullThranUI = {
    VisualThemes = { GetRenderedTheme = function() return "forever" end },
}
_G.CreateFrame = function(_, _, parent) return Region(parent) end

local ns = {}
assert(loadfile("KullThranUI_UnitFrames/Modules/KUIUnitFrames/KUI_BarFrameArt.lua"))(nil, ns)

local function MakeFrame(unit, shift)
    local frame = Region(nil)
    frame:SetSize(232, 100)
    frame._ktRingHugShift = shift
    frame._ktForeverArtHost = Region(frame)
    frame._ktForeverPortraitArt = Region(frame._ktForeverArtHost)
    frame._ktForeverPortraitArt:SetSize(198, 71)
    frame._ktForeverPortraitArt:SetPoint("CENTER", frame, "CENTER", 0, 0)
    frame._ktForeverPortraitArt:SetTexture("stock")
    frame._ktForeverPortraitArt:SetTexCoord(0, 1, 0, 1)
    frame._ktForeverPortraitArt:Hide()
    ns.BarFrameArt.Update(frame, unit)
    return frame
end

local player = MakeFrame("player", -12)
near(player._ktBarFrameClip.points[1][4], 74, "player clip extends toward portrait")
near(player._ktBarFrameClip.tex:GetWidth(), 129 + 12, "player expands only cropped bar art")
near(player._ktBarFrameClip.tex.texCoord[1], 69 / 198, "player crop excludes portrait pixels")
assert(player._ktBarFrameClip.tex.points[1][1] == "RIGHT", "player keeps outer right edge")

local target = MakeFrame("target", 12)
near(target._ktBarFrameClip.points[2][4], -74, "target clip extends toward portrait")
near(target._ktBarFrameClip.tex:GetWidth(), 129 + 12, "target expands only cropped bar art")
near(target._ktBarFrameClip.tex.texCoord[5], 129 / 198, "target crop excludes portrait pixels")
assert(target._ktBarFrameClip.tex.points[1][1] == "LEFT", "target keeps outer left edge")

target:SetSize(464, 200)
target._ktRingHugShift = 6
target._ktForeverPortraitArt:SetSize(396, 142)
target._ktForeverPortraitArt:SetTexCoord(0.8, 0.3, 0.8, 0.7, 0.2, 0.3, 0.2, 0.7)
ns.BarFrameArt.Update(target, "target")
near(target._ktBarFrameClip.points[2][4], -166, "scaled clip follows scaled bar extension")
near(target._ktBarFrameClip.tex:GetWidth(), 258 + 6, "scaled bar fragment retains outer edge")
near(target._ktBarFrameClip.tex:GetSize(), 264, "mirrored sheet keeps scaled bar width")
near(target._ktBarFrameClip.tex.texCoord[5], 0.8 - 0.6 * 129 / 198, "mirrored sheet crop remains within atlas")

local normal = MakeFrame("player", nil)
near(normal._ktBarFrameClip.points[1][4], 86, "normal clip keeps stock edge")
near(normal._ktBarFrameClip.tex:GetWidth(), 198, "normal art keeps stock width")

player._ktRingHugShift = nil
ns.BarFrameArt.Update(player, "player")
near(player._ktBarFrameClip.tex:GetWidth(), 198, "leaving classification restores full atlas")
near(player._ktBarFrameClip.points[1][4], 86, "leaving classification restores clip")

player._ktForeverPortraitArt.shown = true
ns.BarFrameArt.Update(player, "player")
assert(not player._ktBarFrameClip.shown, "normal portrait art hides classification bar copy")

print("bar_frame_art: ok")
