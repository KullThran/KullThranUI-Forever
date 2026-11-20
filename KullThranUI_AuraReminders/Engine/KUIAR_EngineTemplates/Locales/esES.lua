-- Embedded adaptation of ForeverAuras 1.3.8; GPL-2.0. See Engine/UPSTREAM.md.
local _, host = ...
host.EmbeddedAuraEngine.Register("KUIAR_EngineTemplates", function(...)
-- Modified for ForeverAuras, 2026-09-18.
if not KUIAR_Runtime.IsLibsOK() then return end

if (GAME_LOCALE or GetLocale()) ~= "esES" then
  return
end

local L = KUIAR_Runtime.L

-- Upstream CurseForge localization directive, not used here: localization(locale="esES", format="lua_additive_table", namespace="ForeverAuras / Templates")@

end)
