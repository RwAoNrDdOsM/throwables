return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`throwables` mod must be lower than Vermintide Mod Framework in your launcher's load order.")

		new_mod("throwables", {
			mod_script       = "scripts/mods/throwables/throwables",
			mod_data         = "scripts/mods/throwables/throwables_data",
			mod_localization = "scripts/mods/throwables/throwables_localization",
		})
	end,
	packages = {
		"resource_packages/throwables/throwables",
	},
}
