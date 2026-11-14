-- Embedded adaptation of ForeverAuras 1.3.8; GPL-2.0. See Engine/UPSTREAM.md.
local _, host = ...
host.EmbeddedAuraEngine.Register("KUIAR_Engine", function(...)
-- Modified for ForeverAuras, 2026-09-18.
-- Modifications Copyright (C) 2026 ForeverAuras. Licensed under the GNU GPL v2 (see LICENSE).
--[[ Manual override for the default font and font size until proper options are built ]]

KUIAR_Runtime.defaultFont = "Friz Quadrata TT"
KUIAR_Runtime.defaultFontSize = 12

end)
