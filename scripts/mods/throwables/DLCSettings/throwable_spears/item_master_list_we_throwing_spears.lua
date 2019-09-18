ItemMasterList.we_throwing_spears = {
	template = "we_throwing_spears_template",
	ammo_unit = "units/weapons/player/wpn_we_spear_01/wpn_we_spear_01",
	display_name = "we_spear_skin_01_name",
	is_ammo_weapon = true,
	skin_combination_table = "we_throwing_spears_skins",
	slot_type = "ranged",
	link_pickup_template_name = "link_ammo_we_throwing_spears_skin_01",
	hud_icon = "weapon_generic_icon_falken",
	item_type = "we_throwing_spears",
	trait_table_name = "ranged_ammo",
	description = "we_spear_skin_01_description",
	rarity = "plentiful",
	right_hand_unit = "units/weapons/player/wpn_invisible_weapon",
	inventory_icon = "icon_wpn_we_spear_01",
	pickup_template_name = "ammo_we_throwing_spears_skin_01",
	has_power_level = true,
	property_table_name = "ranged",
	projectile_units_template = "we_throwing_spears_skin_01",
	can_wield = {
		"we_shade",
		"we_maidenguard",
	}
}


--[[ItemMasterList.we_spear = {
	description = "we_spear_skin_01_description",
	rarity = "plentiful",
	right_hand_unit = "units/weapons/player/wpn_we_spear_01/wpn_we_spear_01",
	hud_icon = "weapon_generic_icon_hammer2h",
	skin_combination_table = "we_spear_skins",
	slot_type = "melee",
	inventory_icon = "icon_wpn_we_spear_01",
	display_name = "we_spear_skin_01_name",
	has_power_level = true,
	template = "two_handed_spears_elf_template_1",
	property_table_name = "melee",
	item_type = "we_2h_spear",
	trait_table_name = "melee",
	can_wield = {
		"we_shade",
		"we_maidenguard",
		"we_waywatcher"
	}
}]]
local item_names = {
	"we_throwing_spears",
}
local damage_types = {
	"we_throwing_spears",
}

return item_names, damage_types