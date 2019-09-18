local mod = get_mod("throwables")
function table.append_lookup(dest, source)
	local dest_size = #dest

	for i = 1, #source, 1 do
		local lookup = source[i]
		dest_size = dest_size + 1
		dest[dest_size] = lookup
		dest[lookup] = dest_size
		
	end
end

local weapon_template_files_names = {}
ModDLCSettings = ModDLCSettings or {}
for dlc_name, dlc in pairs(ModDLCSettings) do
	if _dlc_name == dlc_name then
		local package_name = dlc.package_name

		if package_name then
			Managers.package:load(package_name, "boot", nil, true)
		end

		local additional_settings = dlc.additional_settings

		if additional_settings then
			for _, settings_path in pairs(additional_settings) do
				_mod:dofile(settings_path)
			end
		end

		local husk_lookup = dlc.husk_lookup

		if husk_lookup then
			table.append_lookup(NetworkLookup.husks, husk_lookup)
		end

		local damage_types = dlc.network_damage_types

		if damage_types then
			table.append(NetworkLookup.damage_types, damage_types)
		end
		
		local file_names = dlc.weapon_skins_file_names

		if file_names then
			for _, file_name in ipairs(file_names) do
				local skin_names = _mod:dofile(file_name)
				table.append_lookup(NetworkLookup.weapon_skins, skin_names)
			end
		end

		local file_names = dlc.item_master_list_file_names

		if file_names then
			for i, file_name in ipairs(file_names) do
				local item_names = _mod:dofile(file_name)
				table.append_lookup(NetworkLookup.item_names, item_names)
			end
		end

		if dlc.weapon_template_file_names then
			table.append(weapon_template_files_names, dlc.weapon_template_file_names)
		end
		
		local default_items = dlc.default_items

		if default_items then
			for item_name, item_data in pairs(default_items) do
				UISettings.default_items[item_name] = item_data
			end
		end
		
		if dlc.inventory_package_list then
			
			table.append_lookup(NetworkLookup.inventory_packages, dlc.inventory_package_list)
		end
		
		local file_names = dlc.damage_profile_template_files_names

		if file_names then
			for _, file_name in ipairs(file_names) do
				local dlc_damage_templates = _mod:dofile(file_name)

				for template_name, template in pairs(dlc_damage_templates) do
					DamageProfileTemplates[template_name] = template
					table.append_lookup(NetworkLookup.damage_profiles, {template_name})
				end
			end
		end
		
		
		local file_names = dlc.power_level_template_files_names

		if file_names then
			for _, file_name in ipairs(file_names) do
				_mod:dofile(file_name)
			end
		end
		
		local file_names = dlc.attack_template_files_names

		if file_names then
			for _, file_name in ipairs(file_names) do
				local attack_templates, damage_types = _mod:dofile(file_name)
				table.append_lookup(NetworkLookup.attack_templates, attack_templates)
				table.merge_recursive(NetworkLookup.damage_types, damage_types)
			end
		end
		
		local projectile_gravity_settings = dlc.projectile_gravity_settings

		if projectile_gravity_settings then
			for name, value in pairs(projectile_gravity_settings) do
				ProjectileGravitySettings[name] = value
				table.append_lookup(NetworkLookup.projectile_gravity_settings, {name})
			end
		end
		
		local projectile_units = dlc.projectile_units

		if projectile_units then
			for name, data in pairs(projectile_units) do
				ProjectileUnits[name] = table.clone(data)
			end
		end
		
		local projectiles = dlc.projectiles

		if projectiles then
			for name, data in pairs(projectiles) do
				Projectiles[name] = table.clone(data)
			end
		end
		
		local spread_templates = dlc.spread_templates

		if spread_templates then
			table.merge_recursive(SpreadTemplates, spread_templates)
		end
		
		local pickups = dlc.pickups

		if pickups then
			table.merge_recursive(Pickups, pickups)
			for name, data in pairs(pickups) do
				for name, data in pairs(data) do
					table.append_lookup(NetworkLookup.pickup_names, {name})
				end
			end
		end

		for group, pickups in pairs(Pickups) do
			local total_spawn_weighting = 0

			for _, settings in pairs(pickups) do
				total_spawn_weighting = total_spawn_weighting + settings.spawn_weighting
			end

			for pickup_name, settings in pairs(pickups) do
				settings.spawn_weighting = settings.spawn_weighting / total_spawn_weighting
				AllPickups[pickup_name] = settings
			end

			NearPickupSpawnChance[group] = NearPickupSpawnChance[group] or 0
		end
	end
end

-- Weapon Stuff
for i = 1, #weapon_template_files_names, 1 do
	local file_name = weapon_template_files_names[i]
	local weapon_templates = dofile(file_name)

	if weapon_templates then
		for template_name, template in pairs(weapon_templates) do
			Weapons[template_name] = template
		end
	end
end

table.clear(weapon_template_files_names)

local checked_templates = {
	bright_wizard = {},
	dwarf_ranger = {},
	empire_soldier = {},
	witch_hunter = {},
	wood_elf = {}
}

for _, item in pairs(ItemMasterList) do
	local slot_type = item.slot_type

	if slot_type == "melee" or slot_type == "ranged" or slot_type == "grenade" or slot_type == "healthkit" or slot_type == "potion" then
		local template_name = item.template or item.temporary_template

		fassert(Weapons[template_name], "Weapon template [\"%s\"] does not exist!", template_name)

		local careers = item.can_wield

		for i = 1, #careers, 1 do
			local career_name = careers[i]
			local career_data = CareerSettings[career_name]
			local profile_name = career_data.profile_name
			local action_names = CareerActionNames[profile_name]

			if checked_templates[profile_name] and not checked_templates[profile_name][template_name] then
				checked_templates[profile_name][template_name] = true
				local template = Weapons[template_name]
				local actions = template.actions

				for j = 1, #action_names, 1 do
					local action_name = action_names[j]
					actions[action_name] = ActionTemplates[action_name]
				end

				actions.action_career_skill = nil
			end
		end
	end
end

local WEAPON_DAMAGE_UNIT_LENGTH_EXTENT = 1.919366
local TAP_ATTACK_BASE_RANGE_OFFSET = 0.6
local HOLD_ATTACK_BASE_RANGE_OFFSET = 0.65

for item_template_name, item_template in pairs(Weapons) do
	item_template.name = item_template_name
	item_template.crosshair_style = item_template.crosshair_style or "dot"
	local attack_meta_data = item_template.attack_meta_data
	local tap_attack_meta_data = attack_meta_data and attack_meta_data.tap_attack
	local hold_attack_meta_data = attack_meta_data and attack_meta_data.hold_attack
	local set_default_tap_attack_range = tap_attack_meta_data and tap_attack_meta_data.max_range == nil
	local set_default_hold_attack_range = hold_attack_meta_data and hold_attack_meta_data.max_range == nil
	local actions = item_template.actions

	for action_name, sub_actions in pairs(actions) do
		for sub_action_name, sub_action_data in pairs(sub_actions) do
			local lookup_data = {
				item_template_name = item_template_name,
				action_name = action_name,
				sub_action_name = sub_action_name
			}
			sub_action_data.lookup_data = lookup_data
			local action_kind = sub_action_data.kind
			local action_assert_func = ActionAssertFuncs[action_kind]

			if action_assert_func then
				action_assert_func(item_template_name, action_name, sub_action_name, sub_action_data)
			end

			if action_name == "action_one" then
				local range_mod = sub_action_data.range_mod or 1

				if set_default_tap_attack_range and string.find(sub_action_name, "light_attack") then
					local current_attack_range = tap_attack_meta_data.max_range or math.huge
					local tap_attack_range = TAP_ATTACK_BASE_RANGE_OFFSET + WEAPON_DAMAGE_UNIT_LENGTH_EXTENT * range_mod
					tap_attack_meta_data.max_range = math.min(current_attack_range, tap_attack_range)
				elseif set_default_hold_attack_range and string.find(sub_action_name, "heavy_attack") then
					local current_attack_range = hold_attack_meta_data.max_range or math.huge
					local hold_attack_range = HOLD_ATTACK_BASE_RANGE_OFFSET + WEAPON_DAMAGE_UNIT_LENGTH_EXTENT * range_mod
					hold_attack_meta_data.max_range = math.min(current_attack_range, hold_attack_range)
				end
			end

			local impact_data = sub_action_data.impact_data

			if impact_data then
				local pickup_settings = impact_data.pickup_settings

				if pickup_settings then
					local link_hit_zones = pickup_settings.link_hit_zones

					if link_hit_zones then
						for i = 1, #link_hit_zones, 1 do
							local hit_zone_name = link_hit_zones[i]
							link_hit_zones[hit_zone_name] = true
						end
					end
				end
			end
		end
	end
end

local item_template_table = {}

for item_template_name, item_template in pairs(Weapons) do
	item_template_table[#item_template_table + 1] = item_template_name

	for action_name, sub_actions in pairs(item_template.actions) do
		if not table.contains(NetworkLookup.actions, action_name) then
			NetworkLookup.actions[#NetworkLookup.actions + 1] = action_name
		end

		for sub_action_name, _ in pairs(sub_actions) do
			if not table.contains(NetworkLookup.sub_actions, sub_action_name) then
				NetworkLookup.sub_actions[#NetworkLookup.sub_actions + 1] = sub_action_name
			end
		end
	end
end
table.append_lookup(NetworkLookup.item_template_names, item_template_table)

--DamageProfileTemplates
for name, damage_profile in pairs(DamageProfileTemplates) do
	if not damage_profile.targets then
		damage_profile.targets = {}
	end

	fassert(damage_profile.default_target, "damage profile [\"%s\"] missing default_target", name)

	if type(damage_profile.critical_strike) == "string" then
		local template = PowerLevelTemplates[damage_profile.critical_strike]

		fassert(template, "damage profile [\"%s\"] has no corresponding template defined in PowerLevelTemplates. Wanted template name is [\"%s\"] ", name, damage_profile.critical_strike)

		damage_profile.critical_strike = template
	end

	if type(damage_profile.cleave_distribution) == "string" then
		local template = PowerLevelTemplates[damage_profile.cleave_distribution]

		fassert(template, "damage profile [\"%s\"] has no corresponding template defined in PowerLevelTemplates. Wanted template name is [\"%s\"] ", name, damage_profile.cleave_distribution)

		damage_profile.cleave_distribution = template
	end

	if type(damage_profile.armor_modifier) == "string" then
		local template = PowerLevelTemplates[damage_profile.armor_modifier]

		fassert(template, "damage profile [\"%s\"] has no corresponding template defined in PowerLevelTemplates. Wanted template name is [\"%s\"] ", name, damage_profile.armor_modifier)

		damage_profile.armor_modifier = template
	end

	if type(damage_profile.default_target) == "string" then
		local template = PowerLevelTemplates[damage_profile.default_target]

		fassert(template, "damage profile [\"%s\"] has no corresponding template defined in PowerLevelTemplates. Wanted template name is [\"%s\"] ", name, damage_profile.default_target)

		damage_profile.default_target = template
	end

	if type(damage_profile.targets) == "string" then
		local template = PowerLevelTemplates[damage_profile.targets]

		fassert(template, "damage profile [\"%s\"] has no corresponding template defined in PowerLevelTemplates. Wanted template name is [\"%s\"] ", name, damage_profile.targets)

		damage_profile.targets = template
	end
end

local no_damage_templates = {}

for name, damage_profile in pairs(DamageProfileTemplates) do
	local no_damage_name = name .. "_no_damage"

	if not DamageProfileTemplates[no_damage_name] then
		local no_damage_template = table.clone(damage_profile)

		if no_damage_template.targets then
			for _, target in ipairs(no_damage_template.targets) do
				if target.power_distribution then
					target.power_distribution.attack = 0
				end
			end
		end

		if no_damage_template.default_target.power_distribution then
			no_damage_template.default_target.power_distribution.attack = 0
		end

		no_damage_templates[no_damage_name] = no_damage_template
	end
end

DamageProfileTemplates = table.merge(DamageProfileTemplates, no_damage_templates)
