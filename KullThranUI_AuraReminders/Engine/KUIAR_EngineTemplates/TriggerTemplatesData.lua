-- Embedded adaptation of ForeverAuras 1.3.8; GPL-2.0. See Engine/UPSTREAM.md.
local _, host = ...
host.EmbeddedAuraEngine.Register("KUIAR_EngineTemplates", function(...)
-- Modified for ForeverAuras; generic templates for the Forever client.
-- Modifications Copyright (C) 2026 ForeverAuras. Licensed under the GNU GPL v2 (see LICENSE).
local _, TemplatePrivate = ...
if not KUIAR_Runtime.IsLibsOK() then return end
local L = KUIAR_Runtime.L
local tinsert = table.insert
local templates = {class = {}, race = {}, general = {title = L["General"], icon = 136116, args = {}}}
-- General Section
tinsert(templates.general.args, {
  title = L["Health"],
  icon = "Interface\\Icons\\inv_alchemy_70_red",
  type = "health"
});
tinsert(templates.general.args, {
  title = L["Cast"],
  icon = 136209,
  type = "cast"
});
tinsert(templates.general.args, {
  title = L["Always Active"],
  icon = "Interface\\AddOns\\KullThranUI_AuraReminders\\Engine\\KUIAR_Engine\\PowerAurasMedia\\Auras\\Aura78",
  triggers = {[1] = { trigger = {
    type = KUIAR_Runtime.GetTriggerCategoryFor("Conditions"),
    event = "Conditions",
    use_alwaystrue = true}}}
});

tinsert(templates.general.args, {
  title = L["Pet alive"],
  icon = "Interface\\Icons\\ability_hunter_pet_raptor",
  triggers = {[1] = { trigger = {
    type = KUIAR_Runtime.GetTriggerCategoryFor("Conditions"),
    event = "Conditions",
    use_HasPet = true}}}
});

tinsert(templates.general.args, {
  title = L["Pet Behavior"],
  icon = "Interface\\Icons\\Ability_hunter_pet_assist",
  triggers = {[1] = { trigger = {
    type = KUIAR_Runtime.GetTriggerCategoryFor("Pet Behavior"),
    event = "Pet Behavior",
    use_behavior = true,
    behavior = "assist"}}}
});


TemplatePrivate.triggerTemplates = templates

end)
