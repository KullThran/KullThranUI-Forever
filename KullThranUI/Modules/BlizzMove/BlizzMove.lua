-- Legacy compatibility shim.
-- Forever uses KullThranUI.Modules.UnlockMode as its KUI Move implementation.
-- This file is intentionally inert so stale TOCs cannot instantiate BlizzMove.
local KT = LibStub and LibStub("AceAddon-3.0", true)
KT = KT and KT.GetAddon and KT:GetAddon("KullThranUI", true)
if KT and KT.GetModule then
    local move = KT:GetModule("UnlockMode", true)
    if move then
        KT.KUI_Move = move
    end
end