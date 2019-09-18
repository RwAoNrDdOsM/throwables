local damage_templates = {
	throwing_spear = {
		charge_value = "projectile",
		no_stagger_damage_reduction_ranged = true,
		shield_break = true,
		critical_strike = {
			attack_armor_power_modifer = {
				1.5, --inft
				1.5, -- elites
				0.5, --bosses
				1, -- idk
				0.25, --zerksers
				0.5 --lords
			},
			impact_armor_power_modifer = {
				1,
				1,
				0.75,
				1,
				1,
				0.75
			}
		},
		armor_modifier_near = {
			attack = {
				1,
				1,
				0.75,
				1,
				0.75,
				0.125
			},
			impact = {
				1,
				1,
				0.75,
				1,
				1,
				0.75
			}
		},
		armor_modifier_far = {
			attack = {
				1,
				0.6,
				1,
				1,
				0.75,
				0.25
			},
			impact = {
				1,
				1,
				1,
				1,
				1,
				0.5
			}
		},
		cleave_distribution = {
			attack = 0.01,
			impact = 0.01
		},
		default_target = {
			boost_curve_coefficient_headshot = 1,
			boost_curve_type = "smiter_curve",
			boost_curve_coefficient = 1,
			attack_template = "throwing_spear",
			power_distribution_near = {
				attack = 0.6,
				impact = 0.65
			},
			power_distribution_far = {
				attack = 0.4,
				impact = 0.4
			},
			range_dropoff_settings = {
				dropoff_start = 15,
				dropoff_end = 30
			},
		},
		targets = {},
	},
	throwing_spear_charged = {
		charge_value = "projectile",
		no_stagger_damage_reduction_ranged = true,
		shield_break = true,
		critical_strike = {
			attack_armor_power_modifer = {
				1,
				1,
				1,
				1,
				0.75,
				0.5
			},
			impact_armor_power_modifer = {
				1,
				1,
				1,
				1,
				1,
				0.75
			}
		},
		armor_modifier_near = {
			attack = {
				1,
				0.8,
				1,
				1,
				0.75,
				0.25
			},
			impact = {
				1,
				1,
				1,
				1,
				1,
				0.75
			}
		},
		armor_modifier_far = {
			attack = {
				1,
				0.6,
				1,
				1,
				0.75,
				0.25
			},
			impact = {
				1,
				1,
				1,
				1,
				1,
				0.5
			}
		},
		cleave_distribution = {
			attack = 0.4,
			impact = 0.4
		},
		default_target = {
			boost_curve_coefficient_headshot = 1,
			boost_curve_type = "smiter_curve",
			boost_curve_coefficient = 1,
			attack_template = "throwing_spear",
			power_distribution_near = {
				attack = 0.6,
				impact = 0.65
			},
			power_distribution_far = {
				attack = 0.4,
				impact = 0.4
			},
			range_dropoff_settings = {
				dropoff_start = 15,
				dropoff_end = 30
			},
		},
		targets = {},
	}
}
return damage_templates
