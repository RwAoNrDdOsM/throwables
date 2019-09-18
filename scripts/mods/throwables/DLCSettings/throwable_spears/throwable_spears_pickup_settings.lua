local settings = ModDLCSettings.throwable_spears
local base_string = "scripts/mods/throwables/DLCSettings/throwable_spears/"
local base_pickup_definition = {
	only_once = true,
	refill_amount = 1,
	type = "ammo",
	spawn_weighting = 1e-06,
	debug_pickup_category = "throwing_weapons",
	pickup_sound_event = "pickup_ammo",
	outline_distance = "small_pickup",
	consumable_item = true,
	local_pickup_sound = true,
	hud_description = "interaction_ammunition_spear",
	ammo_kind = "thrown",
	can_interact_func = function (interactor_unit, interactable_unit, data)
		local inventory_extension = ScriptUnit.has_extension(interactor_unit, "inventory_system")


		if not inventory_extension then
			return false
		end

		return inventory_extension:has_ammo_consuming_weapon_equipped("throwing_spear")
	end,
	outline_available_func = function (local_player_unit)
		local inventory_extension = ScriptUnit.has_extension(local_player_unit, "inventory_system")

		if not inventory_extension then
			return false
		end

		return inventory_extension:has_ammo_consuming_weapon_equipped("throwing_spear")
	end,
	on_pick_up_func = function (world, interactor_unit, is_server, interactable_unit)
		local peer_id = Network.peer_id()
		local pickup_system = Managers.state.entity:system("pickup_system")

		pickup_system:delete_limited_owned_pickup_unit(peer_id, interactable_unit)
	end
}
local mapping = {
	ammo_we_throwing_spears_skin_01 = {
		unit_template_name = "limited_owned_pickup_projectile_unit",
		unit_name = "units/weapons/player/wpn_we_spear_01/wpn_we_spear_01_3p",
		category = "ammo"
	},
	ammo_we_throwing_spears_skin_02 = {
		unit_template_name = "limited_owned_pickup_projectile_unit",
		unit_name = "units/weapons/player/wpn_we_spear_02/wpn_we_spear_02_3p",
		category = "ammo"
	},
	ammo_we_throwing_spears_skin_03 = {
		unit_template_name = "limited_owned_pickup_projectile_unit",
		unit_name = "units/weapons/player/wpn_we_spear_03/wpn_we_spear_03_3p",
		category = "ammo"
	},
	ammo_we_throwing_spears_skin_03_runed_01 = {
		unit_template_name = "limited_owned_pickup_projectile_unit",
		unit_name = "units/weapons/player/wpn_we_spear_03/wpn_we_spear_03_runed_01_3p",
		category = "ammo"
	},
	ammo_we_throwing_spears_skin_03_runed_02 = {
		unit_template_name = "limited_owned_pickup_projectile_unit",
		unit_name = "units/weapons/player/wpn_we_spear_03/wpn_we_spear_03_runed_01_3p",
		category = "ammo",
		material_settings = WeaponMaterialSettingsTemplates.purple_glow
	},
	ammo_we_throwing_spears_skin_04 = {
		unit_template_name = "limited_owned_pickup_projectile_unit",
		unit_name = "units/weapons/player/wpn_we_spear_04/wpn_we_spear_04_3p",
		category = "ammo"
	},
	ammo_we_throwing_spears_skin_04_runed_01 = {
		unit_template_name = "limited_owned_pickup_projectile_unit",
		unit_name = "units/weapons/player/wpn_we_spear_04/wpn_we_spear_04_runed_01_3p",
		category = "ammo"
	},
	ammo_we_throwing_spears_skin_05 = {
		unit_template_name = "limited_owned_pickup_projectile_unit",
		unit_name = "units/weapons/player/wpn_we_spear_05/wpn_we_spear_05_3p",
		category = "ammo"
	},
	link_ammo_we_throwing_spears_skin_01 = {
		unit_template_name = "limited_owned_pickup_unit",
		unit_name = "units/weapons/player/wpn_we_spear_01/wpn_we_spear_01_3p",
		category = "ammo"
	},
	link_ammo_we_throwing_spears_skin_02 = {
		unit_template_name = "limited_owned_pickup_unit",
		unit_name = "units/weapons/player/wpn_we_spear_02/wpn_we_spear_02_3p",
		category = "ammo"
	},
	link_ammo_we_throwing_spears_skin_03 = {
		unit_template_name = "limited_owned_pickup_unit",
		unit_name = "units/weapons/player/wpn_we_spear_03/wpn_we_spear_03_3p",
		category = "ammo"
	},
	link_ammo_we_throwing_spears_skin_03_runed_01 = {
		unit_template_name = "limited_owned_pickup_unit",
		unit_name = "units/weapons/player/wpn_we_spear_03/wpn_we_spear_03_runed_01_3p",
		category = "ammo"
	},
	link_ammo_we_throwing_spears_skin_03_runed_02 = {
		unit_template_name = "limited_owned_pickup_unit",
		unit_name = "units/weapons/player/wpn_we_spear_03/wpn_we_spear_03_runed_01_3p",
		category = "ammo",
		material_settings = WeaponMaterialSettingsTemplates.purple_glow
	},
	link_ammo_we_throwing_spears_skin_04 = {
		unit_template_name = "limited_owned_pickup_unit",
		unit_name = "units/weapons/player/wpn_we_spear_04/wpn_we_spear_04_3p",
		category = "ammo"
	},
	link_ammo_we_throwing_spears_skin_04_runed_01 = {
		unit_template_name = "limited_owned_pickup_unit",
		unit_name = "units/weapons/player/wpn_we_spear_04/wpn_we_spear_04_runed_01_3p",
		category = "ammo"
	},
	link_ammo_we_throwing_spears_skin_05 = {
		unit_template_name = "limited_owned_pickup_unit",
		unit_name = "units/weapons/player/wpn_we_spear_05/wpn_we_spear_05_3p",
		category = "ammo"
	},
}
settings.pickups = {}

for pickup_name, data in pairs(mapping) do
	if not settings.pickups[data.category] then
		settings.pickups[data.category] = {}
	end

	local category = data.category
	settings.pickups[category][pickup_name] = table.clone(base_pickup_definition)
	settings.pickups[category][pickup_name].unit_name = data.unit_name
	settings.pickups[category][pickup_name].unit_template_name = data.unit_template_name
	if data.material_settings then
		settings.pickups[category][pickup_name].material_settings = data.material_settings
	end
end

return
