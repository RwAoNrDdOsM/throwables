local settings = ModDLCSettings.throwable_spears
local base_string = "scripts/mods/throwables/DLCSettings/throwable_spears/"

settings.item_master_list_file_names = {
	base_string .. "item_master_list_we_throwing_spears"
}
settings.weapon_skins_file_names = {
	base_string .. "weapon_skins_we_throwing_spears"
}
settings.weapon_template_file_names = {
	base_string ..  "we_throwing_spears",
}
settings.default_items = {
	we_throwing_spears = {
        inventory_icon = "icon_wpn_we_spear_01",
        description = "description_default_wood_elf_ww_spear",
        display_name = "display_name_default_wood_elf_ww_throwing_spears"
    },
}
settings.inventory_package_list = {}
settings.damage_profile_template_files_names = {
	base_string .. "damage_profile_templates_dlc_we_throwing_spears"
}
settings.power_level_template_files_names = {
	base_string .. "power_level_templates_dlc_we_throwing_spears"
}
settings.attack_template_files_names = {
	base_string .. "attack_templates_dlc_we_throwing_spears"
}
settings.projectile_gravity_settings = {
	throwing_spears = -9.82
}
settings.projectile_units = {
    we_throwing_spears_skin_01 = {
        dummy_linker_unit_name = "units/weapons/player/wpn_we_spear_01/wpn_we_spear_01_3p",
	    projectile_unit_name = "units/weapons/player/wpn_we_spear_01/wpn_we_spear_01_3p"
    },
	we_throwing_spears_skin_02 = {
        dummy_linker_unit_name = "units/weapons/player/wpn_we_spear_02/wpn_we_spear_02_3p",
	    projectile_unit_name = "units/weapons/player/wpn_we_spear_02/wpn_we_spear_02_3p"
	},
	we_throwing_spears_skin_03 = {
        dummy_linker_unit_name = "units/weapons/player/wpn_we_spear_03/wpn_we_spear_03_3p",
	    projectile_unit_name = "units/weapons/player/wpn_we_spear_03/wpn_we_spear_03_3p"
	},
	we_throwing_spears_skin_03_runed_01 = {
        dummy_linker_unit_name = "units/weapons/player/wpn_we_spear_03/wpn_we_spear_03_runed_01_3p",
	    projectile_unit_name = "units/weapons/player/wpn_we_spear_03/wpn_we_spear_03_runed_01_3p"
    },
	we_throwing_spears_skin_03_runed_02 = {
        dummy_linker_unit_name = "units/weapons/player/wpn_we_spear_03/wpn_we_spear_03_runed_01",
		projectile_unit_name = "units/weapons/player/wpn_we_spear_03/wpn_we_spear_03_runed_01",
		material_settings = WeaponMaterialSettingsTemplates.purple_glow
	},
	we_throwing_spears_skin_04 = {
        dummy_linker_unit_name = "units/weapons/player/wpn_we_spear_04/wpn_we_spear_04_3p",
	    projectile_unit_name = "units/weapons/player/wpn_we_spear_04/wpn_we_spear_04_3p"
	},
	we_throwing_spears_skin_04_runed_01 = {
        dummy_linker_unit_name = "units/weapons/player/wpn_we_spear_04/wpn_we_spear_04_runed_01_3p",
	    projectile_unit_name = "units/weapons/player/wpn_we_spear_04/wpn_we_spear_04_runed_01_3p"
	},
	we_throwing_spears_skin_05 = {
        dummy_linker_unit_name = "units/weapons/player/wpn_we_spear_05/wpn_we_spear_05_3p",
	    projectile_unit_name = "units/weapons/player/wpn_we_spear_05/wpn_we_spear_05_3p"
	},
}
settings.projectiles = {
	throwing_spears = {
		rotation_speed = 30,
		rotation_max = 75,
		static_impact_type = "raycast",
		impact_type = "sphere_sweep",
		trajectory_template_name = "throw_trajectory",
		radius = 0.075,
		--linear_dampening = 0.691,
		indexed = true,
		use_weapon_skin = true,
		gravity_settings = "throwing_spears",
		bounce_angular_velocity = {
			0,
			0,
			0
		},
		--scale = 50,
	}
}
settings.spread_templates = {
	throwing_spears = {
		continuous = {
			still = {
				max_yaw = 0.25,
				max_pitch = 0.25
			},
			moving = {
				max_yaw = 0.25,
				max_pitch = 0.25
			},
			crouch_still = {
				max_yaw = 0.25,
				max_pitch = 0.25
			},
			crouch_moving = {
				max_yaw = 0.25,
				max_pitch = 0.25
			},
			zoomed_still = {
				max_yaw = 0.25,
				max_pitch = 0.25
			},
			zoomed_moving = {
				max_yaw = 0.25,
				max_pitch = 0.25
			},
			zoomed_crouch_still = {
				max_yaw = 0.25,
				max_pitch = 0.25
			},
			zoomed_crouch_moving = {
				max_yaw = 0.25,
				max_pitch = 0.25
			}
		},
		immediate = {
			being_hit = {
				immediate_pitch = 1.4,
				immediate_yaw = 1.4
			},
			shooting = {
				immediate_pitch = 0.5,
				immediate_yaw = 0.5
			}
		}
	}
}

return
