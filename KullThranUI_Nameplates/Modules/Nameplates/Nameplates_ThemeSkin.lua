-- Nameplates_ThemeSkin.lua
-- Skin visual por tema SOLO para "classic" y "retail". kui/forever no se tocan.
-- Todo son texturas de color solido + gradientes (sin depender de ficheros del cliente).
local addonName, ns = ...
local KT = _G.KullThranUI

local WHITE = "Interface\\Buttons\\WHITE8x8"

-- Estilo de nameplate: preset elegido en Nameplates > General (kui/classic/retail/forever)
-- o, si no hay ninguno, el tema visual activo.
local VALID_STYLE = { kui = true, classic = true, retail = true, forever = true }
function ns.NameplateStyle()
    local st = KullThranUINameplatesDB and KullThranUINameplatesDB.nameplateStyle
    if st and VALID_STYLE[st] then return st end
    local VT = KT and KT.VisualThemes
    return VT and VT.GetRenderedTheme and VT:GetRenderedTheme() or nil
end
local RenderedTheme = ns.NameplateStyle

local function Solid(parent, layer, sub, r, g, b, a)
    local t = parent:CreateTexture(nil, layer, nil, sub or 0)
    t:SetTexture(WHITE)
    t:SetVertexColor(r, g, b, a or 1)
    return t
end

local function Gradient(tex, orient, r1, g1, b1, a1, r2, g2, b2, a2)
    if tex.SetGradient and CreateColor then
        tex:SetGradient(orient, CreateColor(r1, g1, b1, a1), CreateColor(r2, g2, b2, a2))
    end
end

-- Marco fino de 1px (4 lados) alrededor de `bar`.
local function BuildOutline(f, bar, r, g, b, a, inset)
    inset = inset or 0
    local t = Solid(f, "OVERLAY", 6, r, g, b, a)
    t:SetPoint("TOPLEFT", bar, "TOPLEFT", -inset, inset); t:SetPoint("TOPRIGHT", bar, "TOPRIGHT", inset, inset); t:SetHeight(1)
    local bt = Solid(f, "OVERLAY", 6, r, g, b, a)
    bt:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", -inset, -inset); bt:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", inset, -inset); bt:SetHeight(1)
    local l = Solid(f, "OVERLAY", 6, r, g, b, a)
    l:SetPoint("TOPLEFT", bar, "TOPLEFT", -inset, inset); l:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", -inset, -inset); l:SetWidth(1)
    local rr = Solid(f, "OVERLAY", 6, r, g, b, a)
    rr:SetPoint("TOPRIGHT", bar, "TOPRIGHT", inset, inset); rr:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", inset, -inset); rr:SetWidth(1)
    return { t, bt, l, rr }
end

local function Build(plate, bar, key)
    local f = CreateFrame("Frame", nil, bar)
    f:SetAllPoints(bar)
    f:SetFrameLevel(bar:GetFrameLevel() + 6)
    f.key = key
    f.classic, f.retail = {}, {}

    -- ===== CLASSIC: marco dorado fino (1px) + filete oscuro, brillo glossy sobre el color real =====
    local c = f.classic
    -- Classic real: marco fino dorado/bronce con esquinas REDONDEADAS (escalera de pixeles, radio ~4)
    local function Px(color, corner, x, y, a)
        local t = Solid(f, "OVERLAY", 6, color[1], color[2], color[3], a or 1)
        t:SetSize(1, 1)
        local sx = corner:find("LEFT") and 1 or -1
        local sy = corner:find("TOP") and -1 or 1
        t:SetPoint(corner, bar, corner, sx * x, sy * y)
        c[#c + 1] = t
    end
    local function Line(color, p1, x1, y1, p2, x2, y2, horizontal)
        local t = Solid(f, "OVERLAY", 6, color[1], color[2], color[3], 1)
        t:SetPoint(p1, bar, p1, x1, y1)
        t:SetPoint(p2, bar, p2, x2, y2)
        if horizontal then t:SetHeight(1) else t:SetWidth(1) end
        c[#c + 1] = t
    end
    local BLACK, GOLD = { 0.02, 0.02, 0.02 }, { 0.80, 0.66, 0.38 }
    -- lineas (acortadas para dejar sitio a la curva)
    Line(BLACK, "TOPLEFT", 4, 2, "TOPRIGHT", -4, 2, true)
    Line(BLACK, "BOTTOMLEFT", 4, -2, "BOTTOMRIGHT", -4, -2, true)
    Line(BLACK, "TOPLEFT", -2, -4, "BOTTOMLEFT", -2, 4, false)
    Line(BLACK, "TOPRIGHT", 2, -4, "BOTTOMRIGHT", 2, 4, false)
    Line(GOLD, "TOPLEFT", 3, 1, "TOPRIGHT", -3, 1, true)
    Line(GOLD, "BOTTOMLEFT", 3, -1, "BOTTOMRIGHT", -3, -1, true)
    Line(GOLD, "TOPLEFT", -1, -3, "BOTTOMLEFT", -1, 3, false)
    Line(GOLD, "TOPRIGHT", 1, -3, "BOTTOMRIGHT", 1, 3, false)
    for _, corner in ipairs({ "TOPLEFT", "TOPRIGHT", "BOTTOMLEFT", "BOTTOMRIGHT" }) do
        for _, q in ipairs({ { 2, 0 }, { 1, 1 }, { 0, 2 } }) do Px(GOLD, corner, q[1], q[2]) end
        for _, q in ipairs({ { 0, 0 }, { 1, 0 }, { 0, 1 }, { 2, -1 }, { 3, -2 }, { -1, 2 }, { -2, 3 } }) do
            Px(BLACK, corner, q[1], q[2])
        end
    end
    local cg = Solid(f, "OVERLAY", 3, 1, 1, 1, 1)
    cg:SetPoint("TOPLEFT", bar, "TOPLEFT", 0, 0)
    cg:SetPoint("TOPRIGHT", bar, "TOPRIGHT", 0, 0)
    cg:SetHeight(math.max(2, math.floor((bar:GetHeight() or 10) * 0.5)))
    Gradient(cg, "VERTICAL", 1, 1, 1, 0, 1, 1, 1, 0)       -- Classic original: sin brillo extra
    c.gloss = cg
    local cs = Solid(f, "OVERLAY", 3, 0, 0, 0, 1)
    cs:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", 0, 0)
    cs:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 0, 0)
    cs:SetHeight(math.max(2, math.floor((bar:GetHeight() or 10) * 0.4)))
    Gradient(cs, "VERTICAL", 0, 0, 0, 0, 0, 0, 0, 0)
    c.shade = cs

    -- ===== RETAIL / FOREVER: look Blizzard (borde claro fino, rojo glossy) =====
    local r = f.retail
    -- RETAIL / FOREVER: Blizzard's own nameplate atlases (read from the live client with /ktnpdump).
    --   health: fill "UI-HUD-CoolDownManager-Bar" + background/border "UI-HUD-CoolDownManager-Bar-BG"
    --   cast:   fill "UI-CastingBar-Full-Standard" + background "UI-CastingBar-Background"
    local bgTex = bar:CreateTexture(nil, "BACKGROUND", nil, -7)
    bgTex:SetAtlas(key == "cast" and "UI-CastingBar-Background" or "UI-HUD-CoolDownManager-Bar-BG")
    f.bg = bgTex
    -- El interior del atlas BG de Blizzard es azulado: se cubre con un rojo oscuro bajo el relleno (solo vida).
    if key ~= "cast" then
        local interior = bar:CreateTexture(nil, "BACKGROUND", nil, -6)
        interior:SetAllPoints(bar)
        interior:SetColorTexture(0.16, 0.03, 0.03, 1)
        f.interior = interior
    end
    -- Forever: bronze ring that follows the EXACT silhouette of Blizzard's border:
    -- a solid bronze texture masked by the same atlas, enlarged by PAD px, behind the BG.
    local bronzeTex = bar:CreateTexture(nil, "BACKGROUND", nil, -8)
    bronzeTex:SetTexture(WHITE)
    bronzeTex:SetVertexColor(0.78, 0.55, 0.26, 1)
    local bronzeMask = bar:CreateMaskTexture()
    bronzeMask:SetAtlas(key == "cast" and "UI-CastingBar-Background" or "UI-HUD-CoolDownManager-Bar-BG")
    bronzeTex:AddMaskTexture(bronzeMask)
    f.bronzeMask = bronzeMask
    f.bronze = { bronzeTex }
    local gloss = Solid(f, "OVERLAY", 3, 1, 1, 1, 1)
    gloss:SetPoint("TOPLEFT", bar, "TOPLEFT", 0, 0)
    gloss:SetPoint("TOPRIGHT", bar, "TOPRIGHT", 0, 0)
    gloss:SetHeight(math.max(2, math.floor((bar:GetHeight() or 10) * 0.5)))
    Gradient(gloss, "VERTICAL", 1, 1, 1, 0.02, 1, 1, 1, 0.18)
    r.gloss = gloss
    local shade = Solid(f, "OVERLAY", 3, 0, 0, 0, 1)
    shade:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", 0, 0)
    shade:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 0, 0)
    shade:SetHeight(math.max(2, math.floor((bar:GetHeight() or 10) * 0.4)))
    Gradient(shade, "VERTICAL", 0, 0, 0, 0.28, 0, 0, 0, 0)
    r.shade = shade
    if key == "cast" then
        local g1 = Solid(f, "OVERLAY", 5, 1.00, 0.85, 0.35, 0.8)
        g1:SetPoint("TOPLEFT", bar, "TOPLEFT", 0, 0); g1:SetPoint("TOPRIGHT", bar, "TOPRIGHT", 0, 0); g1:SetHeight(1)
        r[#r + 1] = g1
    end
    return f
end

local function SetShown(list, show)
    for _, t in ipairs(list) do t:SetShown(show) end
    if list.fallback then
        for _, t in ipairs(list.fallback) do t:SetShown(show and not list.blizz) end
    end
    if list.gloss then list.gloss:SetShown(show) end
    if list.shade then list.shade:SetShown(show) end
end

local function SkinBar(plate, bar, bg, field, key, theme)
    if not bar then return end
    local f = plate[field]
    if theme ~= "classic" and theme ~= "retail" and theme ~= "forever" then
        if f then f:Hide() end
        if bg and plate["_skinBG" .. key] then
            local o = plate["_skinBG" .. key]
            bg:SetColorTexture(o[1], o[2], o[3], o[4]); plate["_skinBG" .. key] = nil
        end
        return false
    end
    if not f then f = Build(plate, bar, key); plate[field] = f end
    f:Show()
    SetShown(f.classic, theme == "classic")
    SetShown(f.retail, false)   -- gloss/shade manuales: el atlas de Blizzard ya los trae
    local blizzLook = theme ~= "classic"
    if f.interior then f.interior:SetShown(blizzLook) end
    if f.bg then
        f.bg:SetShown(blizzLook)
        if blizzLook then
            local H = bar:GetHeight() or 12
            f.bg:ClearAllPoints()
            if key == "cast" then
                f.bg:SetAllPoints(bar)
            else
                -- Blizzard: fondo/borde = barra + 0.25H a cada lado en X y 0.28H en Y
                local ex, ey = H * 0.25, H * 0.281
                f.bg:SetPoint("TOPLEFT", bar, "TOPLEFT", -ex, ey)
                f.bg:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", ex, -ey)
            end
        end
    end
    if f.bronze then
        SetShown(f.bronze, theme == "forever")
        if theme == "forever" and f.bg and f.bronzeMask then
            local PAD = 2
            local tex = f.bronze[1]
            for _, o in ipairs({ tex, f.bronzeMask }) do
                o:ClearAllPoints()
                o:SetPoint("TOPLEFT", f.bg, "TOPLEFT", -PAD, PAD)
                o:SetPoint("BOTTOMRIGHT", f.bg, "BOTTOMRIGHT", PAD, -PAD)
            end
        end
    end
    if bg then
        if not plate["_skinBG" .. key] then
            plate["_skinBG" .. key] = (key == "health") and { 0.12, 0.12, 0.12, 1 } or { 0.1, 0.1, 0.1, 0.9 }
        end
        if theme == "classic" then
            bg:SetColorTexture(0.05, 0.05, 0.05, 0.95)       -- resto vacio oscuro (Classic real)
        else
            bg:SetColorTexture(0, 0, 0, 0)                   -- el atlas BG de Blizzard pinta el fondo
        end
    end
    return true
end

function ns.ApplyThemeSkin(plate)
    if not plate or not plate.health then return end
    local theme = RenderedTheme()
    local skinned = SkinBar(plate, plate.health, plate.healthBG, "_skinHealth", "health", theme)
    SkinBar(plate, plate.cast, plate.castBG, "_skinCast", "cast", theme)
    -- el borde generico de KUI se oculta cuando el skin del tema manda
    if skinned then
        if plate.borderFrame then plate.borderFrame:Hide() end
        if plate._simpleBorderFrame then plate._simpleBorderFrame:Hide() end
        if theme == "classic" then
            -- Textura original de las barras de Blizzard Classic (mate, sin brillo)
            plate.health:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
            if plate.cast then pcall(plate.cast.SetStatusBarTexture, plate.cast, "Interface\\TargetingFrame\\UI-StatusBar") end
        else
            pcall(plate.health.SetStatusBarTexture, plate.health, "UI-HUD-CoolDownManager-Bar")
            if plate.cast then pcall(plate.cast.SetStatusBarTexture, plate.cast, "UI-CastingBar-Full-Standard") end
        end
        if theme == "classic" and plate.name then
            local nf, _, nfl = plate.name:GetFont()
            local sz = ((ns.GetEnemyNameTextSize and ns.GetEnemyNameTextSize()) or 10) + 2
            if nf then plate.name:SetFont(nf, sz, nfl or "OUTLINE") end
        end
    elseif plate._skinHealth and plate.ApplyBorderStyle then
        plate:ApplyBorderStyle()
    end
end

function ns.RefreshThemeSkin()
    if not ns.plates then return end
    for _, plate in pairs(ns.plates) do
        ns.ApplyThemeSkin(plate)
        if plate.RefreshPlateState then pcall(plate.RefreshPlateState, plate) end
    end
end

if KT then KT.RefreshNameplateTheme = function() ns.RefreshThemeSkin() end end

-- Classic: el nivel va en una pildora dorada pequena DENTRO del extremo derecho de la barra.
function ns.ApplyThemeLevel(plate)
    local level, health = plate and plate.level, plate and plate.health
    if not (level and health) then return end
    local badge = plate._clBadge
    local th = RenderedTheme()
    if th ~= "classic" then
        level:SetAlpha(1)
        if badge then badge:Hide() end
        local bb = plate._blzBadge
        if th ~= "retail" and th ~= "forever" then
            if bb then bb:Hide() end
            level:SetJustifyH("RIGHT")
            return
        end
        -- Retail/Forever: nivel en BLANCO, sin placa ni textura, dentro de la barra al inicio y tan grande como la barra;
        -- el nombre se desplaza a su derecha (ns.ThemeLevelInset).
        if not bb then
            bb = CreateFrame("Frame", nil, plate)
            bb.txt = bb:CreateFontString(nil, "OVERLAY")
            bb.txt:SetPoint("CENTER", bb, "CENTER", 0, 0)
            bb.txt:SetJustifyH("CENTER")
            plate._blzBadge = bb
        end
        bb:SetFrameLevel(health:GetFrameLevel() + 8)
        local barH = health:GetHeight() or 16
        local size = math.max(8, math.floor(barH * 0.85))
        bb:SetSize(size * 1.4, barH)
        bb:ClearAllPoints()
        bb:SetPoint("LEFT", health, "LEFT", 3, 0)
        local font = level:GetFont()
        if font then bb.txt:SetFont(font, size, "OUTLINE") end
        bb.txt:SetTextColor(1, 1, 1, 1)
        local okT, txt = pcall(level.GetText, level)
        bb.txt:SetText((okT and txt) or "")
        level:SetAlpha(0)
        bb:SetShown(level:IsShown() and true or false)
        return
    end
    if plate._blzBadge then plate._blzBadge:Hide() end
    if not badge then
        badge = CreateFrame("Frame", nil, plate)
        badge:SetFrameLevel(health:GetFrameLevel() + 8)
        local CIRCLE = "Interface\\AddOns\\KullThranUI\\Libraries\\texture\\media\\portraits\\circle_mask.tga"
        -- circle_mask.tga es una MASCARA: se usa como MaskTexture sobre texturas de color solido
        -- (tintarla como textura normal la dejaba negra).
        local function Oval(sub, r, g, b, inset)
            local t = badge:CreateTexture(nil, "BACKGROUND", nil, sub)
            t:SetColorTexture(r, g, b, 1)
            t:SetPoint("TOPLEFT", inset, -inset); t:SetPoint("BOTTOMRIGHT", -inset, inset)
            local m = badge:CreateMaskTexture()
            m:SetTexture(CIRCLE, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
            m:SetPoint("TOPLEFT", inset, -inset); m:SetPoint("BOTTOMRIGHT", -inset, inset)
            t:AddMaskTexture(m)
            return t
        end
        Oval(-3, 0.02, 0.02, 0.02, -1)    -- aro negro
        Oval(-2, 0.85, 0.70, 0.30, 0)     -- placa dorada ovalada
        Oval(-1, 0.05, 0.05, 0.05, 2)     -- interior oscuro (referencia Classic: aro dorado, centro oscuro)
        -- Numero propio sobre la placa (el FontString original queda en otro frame y se perdia)
        badge.txt = badge:CreateFontString(nil, "OVERLAY")
        badge.txt:SetPoint("CENTER", badge, "CENTER", 0, 0)
        badge.txt:SetJustifyH("CENTER")
        plate._clBadge = badge
    end
    local barH = health:GetHeight() or 12
    local size = math.max(9, math.min(13, math.floor(barH * 0.75)))
    local w = math.max(26, size * 2 + 10)
    local bh = barH + 6
    badge:SetSize(w, bh)
    badge:ClearAllPoints()
    badge:SetPoint("LEFT", health, "RIGHT", -8, 0)   -- solapa el extremo derecho de la barra
    local font = level:GetFont()
    if font then badge.txt:SetFont(font, size, "OUTLINE") end
    local okC, cr, cg, cb = pcall(level.GetTextColor, level)
    if okC and cr and not (cr == 0 and cg == 0 and cb == 0) then badge.txt:SetTextColor(cr, cg, cb, 1) else badge.txt:SetTextColor(1, 0.82, 0, 1) end
    local okT, txt = pcall(level.GetText, level)
    badge.txt:SetText((okT and txt) or "")
    level:SetAlpha(0)
    badge:SetShown(level:IsShown() and true or false)
end

-- Espacio que ocupa la placa de nivel interna (Retail/Forever) a la izquierda del nombre.
function ns.ThemeLevelInset(plate)
    local th = RenderedTheme()
    if th ~= "retail" and th ~= "forever" then return 0 end
    local lv, health = plate and plate.level, plate and plate.health
    if not (lv and health and lv:IsShown()) then return 0 end
    local size = math.max(8, math.floor((health:GetHeight() or 16) * 0.85))
    return size * 1.4 + 3
end

-- Altura de barra por tema (solo si el usuario no fijo healthBarHeight).
function ns.ThemeBarHeight()
    local th = RenderedTheme()
    if th == "classic" then return 16 end
    if th == "retail" or th == "forever" then return 23 end
    return nil
end

function ns.ThemeBlizzText()
    local th = RenderedTheme()
    return th == "retail" or th == "forever"
end

-- /ktnpdebug: reports whether Blizzard's NamePlateFullBorderTemplate border was created on the plates.
SLASH_KTNPDEBUG1 = "/ktnpdebug"
SlashCmdList["KTNPDEBUG"] = function()
    local n, withB = 0, 0
    for _, plate in pairs(ns.plates or {}) do
        for _, fld in ipairs({ "_skinHealth", "_skinCast" }) do
            local f = plate[fld]
            if f and f.retail then
                n = n + 1
                if f.retail.blizz then
                    withB = withB + 1
                    if withB == 1 then
                        local b = f.retail.blizz
                        print(("KUI NP: border %.0fx%.0f shown=%s regions=%d"):format(b:GetWidth() or 0, b:GetHeight() or 0, tostring(b:IsShown()), select("#", b:GetRegions())))
                    end
                end
            end
        end
    end
    print(("KUI NP: style=%s skinBars=%d withBlizzBorder=%d"):format(tostring(ns.NameplateStyle()), n, withB))
end

-- /ktnpdump [unit]: copyable dump of the REAL Blizzard nameplate (textures, atlases, texcoords, sizes,
-- anchors) of your target (or the given unit) so our Retail/Forever skin can copy it exactly.
local function SafeStr(v)
    if type(issecretvalue) == "function" and issecretvalue(v) then return "<secret>" end
    if v == nil then return "nil" end
    if type(v) == "number" then return (("%.3f"):format(v):gsub("0+$", ""):gsub("%.$", "")) end
    return tostring(v)
end

local function DumpRegion(rg, indent, out)
    local ok, ot = pcall(rg.GetObjectType, rg)
    if not ok then return end
    local line = indent .. ot
    local nm = rg.GetName and rg:GetName()
    if nm then line = line .. " name=" .. SafeStr(nm) end
    if rg.GetDrawLayer then
        local o1, layer, sub = pcall(rg.GetDrawLayer, rg)
        if o1 then line = line .. (" layer=%s/%s"):format(SafeStr(layer), SafeStr(sub)) end
    end
    if ot == "Texture" or ot == "MaskTexture" then
        local atlas = rg.GetAtlas and select(2, pcall(rg.GetAtlas, rg))
        local tex = rg.GetTexture and select(2, pcall(rg.GetTexture, rg))
        line = line .. (" atlas=%s tex=%s"):format(SafeStr(atlas), SafeStr(tex))
        if rg.GetTexCoord then
            local o2, a, b, c, d, e, f, g, h = pcall(rg.GetTexCoord, rg)
            if o2 then line = line .. (" tc=%s,%s,%s,%s"):format(SafeStr(a), SafeStr(b), SafeStr(g), SafeStr(h)) end
        end
        if rg.GetVertexColor then
            local o3, r, g, b, a = pcall(rg.GetVertexColor, rg)
            if o3 then line = line .. (" vc=%s,%s,%s,%s"):format(SafeStr(r), SafeStr(g), SafeStr(b), SafeStr(a)) end
        end
        if rg.GetBlendMode then line = line .. " blend=" .. SafeStr(select(2, pcall(rg.GetBlendMode, rg))) end
    elseif ot == "FontString" then
        line = line .. " font=" .. SafeStr(select(2, pcall(rg.GetFont, rg)))
    elseif ot == "StatusBar" then
        line = line .. " statusTex=" .. SafeStr(select(2, pcall(function() return rg:GetStatusBarTexture():GetAtlas() or rg:GetStatusBarTexture():GetTexture() end)))
    end
    local ow, w = pcall(rg.GetWidth, rg); local oh, h = pcall(rg.GetHeight, rg)
    line = line .. (" size=%sx%s shown=%s"):format(SafeStr(ow and w), SafeStr(oh and h), SafeStr(select(2, pcall(rg.IsShown, rg))))
    local n = rg.GetNumPoints and select(2, pcall(rg.GetNumPoints, rg)) or 0
    if type(n) == "number" then
        for i = 1, math.min(n, 4) do
            local op, p, rel, rp, x, y = pcall(rg.GetPoint, rg, i)
            if op then
                local relName = rel and rel.GetName and rel:GetName() or (rel and rel.GetObjectType and rel:GetObjectType()) or "nil"
                line = line .. (" [%s>%s:%s %s,%s]"):format(SafeStr(p), SafeStr(relName), SafeStr(rp), SafeStr(x), SafeStr(y))
            end
        end
    end
    out[#out + 1] = line
end

local function DumpFrame(f, indent, out, depth, label)
    if depth > 5 or #out > 400 then return end
    DumpRegion(f, indent .. (label and (label .. ": ") or ""), out)
    if f.GetRegions then
        for _, rg in ipairs({ f:GetRegions() }) do DumpRegion(rg, indent .. "  ", out) end
    end
    if f.GetChildren then
        for _, ch in ipairs({ f:GetChildren() }) do DumpFrame(ch, indent .. "  ", out, depth + 1) end
    end
end

local dumpFrame
SLASH_KTNPDUMP1 = "/ktnpdump"
SlashCmdList["KTNPDUMP"] = function(msg)
    local unit = (msg and msg:match("%S+")) or "target"
    local np = C_NamePlate and C_NamePlate.GetNamePlateForUnit and C_NamePlate.GetNamePlateForUnit(unit)
    if not np then print("KUI NP: no hay nameplate visible para '" .. unit .. "' (selecciona un enemigo con su nameplate en pantalla)") return end
    local out = {}
    local uf = np.UnitFrame or np
    DumpFrame(uf, "", out, 0, "UnitFrame")
    if not dumpFrame then
        dumpFrame = CreateFrame("Frame", "KTNPDumpFrame", UIParent, "BackdropTemplate")
        dumpFrame:SetSize(900, 520)
        dumpFrame:SetPoint("CENTER")
        dumpFrame:SetFrameStrata("DIALOG")
        dumpFrame:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8x8", edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1 })
        dumpFrame:SetBackdropColor(0, 0, 0, 0.92); dumpFrame:SetBackdropBorderColor(0.8, 0.6, 0.2, 1)
        dumpFrame:EnableMouse(true); dumpFrame:SetMovable(true)
        dumpFrame:RegisterForDrag("LeftButton")
        dumpFrame:SetScript("OnDragStart", dumpFrame.StartMoving); dumpFrame:SetScript("OnDragStop", dumpFrame.StopMovingOrSizing)
        local sf = CreateFrame("ScrollFrame", nil, dumpFrame, "UIPanelScrollFrameTemplate")
        sf:SetPoint("TOPLEFT", 10, -10); sf:SetPoint("BOTTOMRIGHT", -30, 36)
        local eb = CreateFrame("EditBox", nil, sf)
        eb:SetMultiLine(true); eb:SetFontObject(ChatFontNormal); eb:SetWidth(850); eb:SetAutoFocus(false)
        eb:SetScript("OnEscapePressed", function() dumpFrame:Hide() end)
        sf:SetScrollChild(eb)
        dumpFrame.eb = eb
        local close = CreateFrame("Button", nil, dumpFrame, "UIPanelButtonTemplate")
        close:SetSize(80, 22); close:SetPoint("BOTTOMRIGHT", -10, 8); close:SetText("Cerrar")
        close:SetScript("OnClick", function() dumpFrame:Hide() end)
        local tip = dumpFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        tip:SetPoint("BOTTOMLEFT", 12, 14); tip:SetText("Ctrl+A, Ctrl+C y pegalo en el chat con Claude")
    end
    dumpFrame.eb:SetText(table.concat(out, "\n"))
    dumpFrame.eb:HighlightText()
    dumpFrame:Show()
    print(("KUI NP: %d lineas volcadas de la nameplate de '%s'"):format(#out, unit))
end

-- Migracion: perfiles que ya tenian sembrados los enemigos en azul (cualquier estilo) o naranja (Forever)
-- los pasan a rojo sin tener que volver a elegir el tema.
local function IsOldEnemyColor(c)
    if type(c) ~= "table" or not (c.r and c.g and c.b) then return false end
    local blue = c.b > c.r + 0.3
    local orange = math.abs(c.r - 0.95) < 0.02 and math.abs(c.g - 0.45) < 0.02 and math.abs(c.b - 0.12) < 0.02
    return blue or orange
end
local migr = CreateFrame("Frame")
migr:RegisterEvent("PLAYER_ENTERING_WORLD")
migr:SetScript("OnEvent", function(self)
    self:UnregisterAllEvents()
    local st = ns.NameplateStyle and ns.NameplateStyle()
    local db = _G.KullThranUINameplatesDB
    if type(db) ~= "table" then return end
    local changed = false
    for _, k in ipairs({ "hostile", "enemyInCombat" }) do
        if IsOldEnemyColor(db[k]) then
            db[k] = (st == "kui") and { r = 0.85, g = 0.10, b = 0.10 } or { r = 1, g = 0, b = 0 }; changed = true
        end
    end
    if changed and ns.RefreshThemeSkin then ns.RefreshThemeSkin() end
end)
