-- Embedded adaptation of ForeverAuras 1.3.8; GPL-2.0. See Engine/UPSTREAM.md.
local _, host = ...
host.EmbeddedAuraEngine.Register("KUIAR_EngineOptions", function(...)
-- Modified for ForeverAuras, 2026-09-18.
-- Modifications Copyright (C) 2026 ForeverAuras. Licensed under the GNU GPL v2 (see LICENSE).
if not KUIAR_Runtime.IsLibsOK() then return end
---@type string
local AddonName = ...
---@class OptionsPrivate
local OptionsPrivate = select(2, ...)

local L = KUIAR_Runtime.L
local parsePrefix = OptionsPrivate.commonOptions.parsePrefix
local flattenRegionOptions = OptionsPrivate.commonOptions.flattenRegionOptions

function OptionsPrivate.GetGroupOptions(data)
  local regionOption;
  local id = data.id
  if (OptionsPrivate.Private.regionOptions[data.regionType]) then
    regionOption = OptionsPrivate.Private.regionOptions[data.regionType].create(id, data);
  else
    regionOption = {
      [data.regionType] = {
        __title = "|cFFFFFF00" .. data.regionType,
        __order = 1,
        unsupported = {
          type = "description",
          name = L["This region of type \"%s\" is not supported."]:format(data.regionType)
        }
      };
    };
  end

  local  groupOptions = {
    type = "group",
    name = L["Group Options"],
    order = 0,
    get = function(info)
      local base, property = parsePrefix(info[#info], data);
      if not base then
        return nil
      end
      if(info.type == "color") then
        base[property] = base[property] or {};
        local c = base[property];
        return c[1], c[2], c[3], c[4];
      else
        return base[property];
      end
    end,
    set = function(info, v, g, b, a)
      local base, property = parsePrefix(info[#info], data, true);
      if(info.type == "color") then
        base[property] = base[property] or {};
        local c = base[property];
        c[1], c[2], c[3], c[4] = v, g, b, a;
      elseif(info.type == "toggle") then
        base[property] = v;
      else
        base[property] = (v ~= "" and v) or nil;
      end
      KUIAR_Runtime.Add(data);
      KUIAR_Runtime.UpdateThumbnail(data);
      OptionsPrivate.ResetMoverSizer();
    end,
    hidden = function() return false end,
    disabled = function() return false end,
    args = flattenRegionOptions(regionOption, true);
  }

  return groupOptions
end

end)
