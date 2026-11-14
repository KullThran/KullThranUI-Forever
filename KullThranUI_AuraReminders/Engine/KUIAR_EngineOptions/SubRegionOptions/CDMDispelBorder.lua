-- Embedded adaptation of ForeverAuras 1.3.8; GPL-2.0. See Engine/UPSTREAM.md.
local _, host = ...
host.EmbeddedAuraEngine.Register("KUIAR_EngineOptions", function(...)
-- Copyright (C) 2026 ForeverAuras. Part of ForeverAuras, licensed under the GNU GPL v2 (see LICENSE).
if not KUIAR_Runtime.IsLibsOK() then return end
local L = KUIAR_Runtime.L
local _, OptionsPrivate = ...
local function createOptions(parentData, data, index, subIndex)
  local points, areas = {}, {}
  for child in OptionsPrivate.Private.TraverseLeafsOrAura(parentData) do
    Mixin(points, OptionsPrivate.Private.GetAnchorsForData(child, "point"))
    Mixin(areas, OptionsPrivate.Private.GetAnchorsForData(child, "area"))
  end
  -- Border geometry is independent of the dispel icon's anchor and size.
  local options = {
    __title = L["Dispel Type Border %d"]:format(subIndex), __order = 1,
    dispelVisible = {type = "toggle", name = L["Show Border"], order = 1, width = KUIAR_Runtime.normalWidth},
    dispelBorderSize = {type = "range", control = "KUIAR_RuntimeSpinBox", name = L["Thickness"], order = 2,
      min = 1, max = 32, step = 1, width = KUIAR_Runtime.normalWidth},
    dispelBorderOffset = {type = "range", control = "KUIAR_RuntimeSpinBox", name = L["Border Offset"], order = 3,
      softMin = -16, softMax = 32, step = 1, width = KUIAR_Runtime.normalWidth},
  }
  OptionsPrivate.commonOptions.PositionOptionsForSubElement(data, options, 10, areas, points)
  OptionsPrivate.AddUpDownDeleteDuplicate(options, parentData, index, "subcdmdispelborder")
  return options
end
KUIAR_Runtime.RegisterSubRegionOptions("subcdmdispelborder", createOptions, L["Shows a resizable border coloured by dispel type."])

end)
