-- Embedded adaptation of ForeverAuras 1.3.8; GPL-2.0. See Engine/UPSTREAM.md.
local _, host = ...
host.EmbeddedAuraEngine.Register("KUIAR_EngineOptions", function(...)
-- Modified for ForeverAuras, 2026-10-23.
-- Modifications Copyright (C) 2026 ForeverAuras. Licensed under the GNU GPL v2 (see LICENSE).
---@type string
local AddonName = ...
---@class Private
local Private = select(2, ...)

local L = KUIAR_Runtime.L

local optionsVersion = "1.3.8"


if optionsVersion ~= KUIAR_Runtime.versionString then
  local message = string.format(L["The KUIAR_Engine Options Addon version %s doesn't match the KUIAR_Engine version %s. If you updated the addon while the game was running, try restarting World of Warcraft. Otherwise try reinstalling KUIAR_Engine"],
                    optionsVersion, KUIAR_Runtime.versionString)
  ---@diagnostic disable-next-line: duplicate-set-field
  KUIAR_Runtime.IsLibsOk = function() return false end
  ---@diagnostic disable-next-line: duplicate-set-field
  KUIAR_Runtime.ToggleOptions = function()
       KUIAR_Runtime.prettyPrint(message)
  end

end

end)
