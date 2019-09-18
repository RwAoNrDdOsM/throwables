local mod = get_mod("throwables")
local dlc_init = get_mod("dlc_init")

--fassert(dlc_init, "DLC Initilizer must be higher than More Throwables")

-- Replace Localize
local vmf = get_mod("VMF")
mod:hook("Localize", function(func, text_id)
    local str = vmf.quick_localize(mod, text_id)
    if str then return str end
    return func(text_id)
end)

ModDLCSettings = ModDLCSettings or {}
local base_string = "scripts/mods/throwables/DLCSettings/"
local throwable_spears_folder = "throwable_spears/throwable_spears"
ModDLCSettings.throwable_spears = {
    additional_settings = {
        equipment = base_string .. throwable_spears_folder .. "_equipment_settings",
        common = base_string .. throwable_spears_folder .. "_common_settings",
        pickups = base_string .. throwable_spears_folder .. "_pickup_settings"
    }
}

local throwable_daggers = "throwable_daggers/throwable_daggers"
--[[ModDLCSettings.throwable_daggers = {
    additional_settings = {
        equipment = base_string .. throwable_daggers .. "_equipment_settings",
        common = base_string .. throwable_daggers .. "_common_settings",
        pickups = base_string .. throwable_daggers .. "_pickup_settings"
    }
}]]

mod:hook_safe(ProjectileScriptUnitLocomotionExtension, "init", function (self, extension_init_context, unit, extension_init_data)
	self.rotation_speed_max = extension_init_data.rotation_speed_max or 0
	self.rotation_max = extension_init_data.rotation_max or math.huge
	self.rotation_max_set = false
	self.last_rotation = 0
end)

local unit_go_sync_functions = require("scripts/network/game_object_initializers_extractors")
unit_go_sync_functions.initializers.player_projectile_unit = function (unit, unit_name, unit_template, gameobject_functor_context)
	local locomotion_extension = ScriptUnit.extension(unit, "projectile_locomotion_system")
	local angle = locomotion_extension.angle
		local target_vector = locomotion_extension.target_vector
		local initial_position = locomotion_extension.initial_position_boxed:unbox()
		local speed = locomotion_extension.speed
		local gravity_settings = locomotion_extension.gravity_settings
		local trajectory_template_name = locomotion_extension.trajectory_template_name
		local rotation_speed = locomotion_extension.rotation_speed
		local fast_forward_time = -(locomotion_extension.t - Managers.time:time("game"))
		local impact_extension = ScriptUnit.extension(unit, "projectile_impact_system")
		local owner_unit = impact_extension.owner_unit
		local projectile_extension = ScriptUnit.extension(unit, "projectile_system")
		local item_name = projectile_extension.item_name
		local item_template_name = projectile_extension.action_lookup_data.item_template_name
		local action_name = projectile_extension.action_lookup_data.action_name
		local sub_action_name = projectile_extension.action_lookup_data.sub_action_name
		local scale = projectile_extension.scale * 100
		local power_level = projectile_extension.power_level
		local data_table = {
			go_type = NetworkLookup.go_types.player_projectile_unit,
			husk_unit = NetworkLookup.husks[unit_name],
			position = Unit.local_position(unit, 0),
			rotation = Unit.local_rotation(unit, 0),
			angle = angle,
			initial_position = initial_position,
			target_vector = target_vector,
			speed = speed,
			gravity_settings = NetworkLookup.projectile_gravity_settings[gravity_settings],
			trajectory_template_name = NetworkLookup.projectile_templates[trajectory_template_name],
			owner_unit = (Unit.alive(owner_unit) and Managers.state.network:unit_game_object_id(owner_unit)) or 0,
			item_name = NetworkLookup.item_names[item_name],
			item_template_name = NetworkLookup.item_template_names[item_template_name],
			action_name = NetworkLookup.actions[action_name],
			sub_action_name = NetworkLookup.sub_actions[sub_action_name],
			scale = scale,
			fast_forward_time = fast_forward_time,
			rotation_speed = rotation_speed,
			rotation_speed_max = rotation_speed_max,
			rotation_max = rotation_max,
			power_level = power_level
		}	
	return data_table
end
unit_go_sync_functions.extractors.player_projectile_unit = function (game_session, go_id, owner_id, unit, gameobject_functor_context)
		local angle = GameSession.game_object_field(game_session, go_id, "angle")
		local target_vector = GameSession.game_object_field(game_session, go_id, "target_vector")
		local initial_position = GameSession.game_object_field(game_session, go_id, "initial_position")
		local speed = GameSession.game_object_field(game_session, go_id, "speed")
		local gravity_settings = GameSession.game_object_field(game_session, go_id, "gravity_settings")
		local trajectory_template_name = GameSession.game_object_field(game_session, go_id, "trajectory_template_name")
		local owner_unit_id = GameSession.game_object_field(game_session, go_id, "owner_unit")
		local item_name_id = GameSession.game_object_field(game_session, go_id, "item_name")
		local item_template_name_id = GameSession.game_object_field(game_session, go_id, "item_template_name")
		local action_name_id = GameSession.game_object_field(game_session, go_id, "action_name")
		local sub_action_name_id = GameSession.game_object_field(game_session, go_id, "sub_action_name")
		local time_initialized = Managers.time:time("game")
		local fast_forward_time = GameSession.game_object_field(game_session, go_id, "fast_forward_time")
		local rotation_speed = GameSession.game_object_field(game_session, go_id, "rotation_speed")
		local rotation_max = GameSession.game_object_field(game_session, go_id, "rotation_max")
		local rotation_speed_max = GameSession.game_object_field(game_session, go_id, "rotation_speed_max")
		local scale = GameSession.game_object_field(game_session, go_id, "scale") / 100
		local item_name = NetworkLookup.item_names[item_name_id]
		local item_template_name = NetworkLookup.item_template_names[item_template_name_id]
		local action_name = NetworkLookup.actions[action_name_id]
		local sub_action_name = NetworkLookup.sub_actions[sub_action_name_id]
		local power_level = GameSession.game_object_field(game_session, go_id, "power_level")
		local owner_unit = (owner_unit_id ~= 0 and Managers.state.unit_storage:unit(owner_unit_id)) or nil
		local extension_init_data = {
			projectile_locomotion_system = {
				is_husk = true,
				angle = angle,
				speed = speed,
				target_vector = target_vector,
				initial_position = initial_position,
				gravity_settings = NetworkLookup.projectile_gravity_settings[gravity_settings],
				trajectory_template_name = NetworkLookup.projectile_templates[trajectory_template_name],
				fast_forward_time = fast_forward_time,
				rotation_speed = rotation_speed,
				rotation_max = rotation_max,
				rotation_speed_max = rotation_speed_max,
			},
			projectile_impact_system = {
				item_name = item_name,
				owner_unit = owner_unit
			},
			projectile_system = {
				item_name = item_name,
				item_template_name = item_template_name,
				action_name = action_name,
				sub_action_name = sub_action_name,
				owner_unit = owner_unit,
				time_initialized = time_initialized,
				scale = scale,
				power_level = power_level
			}
		}
		local action = Weapons[item_template_name].actions[action_name][sub_action_name]
		local projectile_info = action.projectile_info
		local unit_template_name = projectile_info.projectile_unit_template_name or "player_projectile_unit"
		return unit_template_name, extension_init_data
end
mod:hook(ProjectileSystem, "spawn_player_projectile", function (func, self, owner_unit, position, rotation, scale, angle, target_vector, speed, item_name, item_template_name, action_name, sub_action_name, fast_forward_time, is_critical_strike, power_level, gaze_settings)
	local action = Weapons[item_template_name].actions[action_name][sub_action_name]
	local projectile_info = action.projectile_info
	if projectile_info.rotation_max then
		local gravity_settings = projectile_info.gravity_settings

		if gaze_settings then
			gravity_settings = projectile_info.gaze_override_gravity_settings or gravity_settings
		end

		local trajectory_template_name = projectile_info.trajectory_template_name
		local linear_dampening = projectile_info.linear_dampening
		local rotation_speed = projectile_info.rotation_speed or 0
		local rotation_max = projectile_info.rotation_max or math.huge
		local rotation_speed_max = projectile_info.rotation_speed_max or 0
		scale = scale / 100
		local min = projectile_info.radius_min
		local max = projectile_info.radius_max
		local radius = projectile_info.radius or (min and max and math.lerp(projectile_info.radius_min, projectile_info.radius_max, scale)) or nil
		local time_initialized = Managers.time:time("game")
		local extension_init_data = {
			projectile_locomotion_system = {
				angle = angle,
				speed = speed,
				initial_position = position,
				target_vector = target_vector,
				gravity_settings = gravity_settings,
				linear_dampening = linear_dampening,
				trajectory_template_name = trajectory_template_name,
				data = {
					owner_unit,
					position,
					rotation,
					scale,
					angle,
					target_vector,
					speed,
					item_name,
					item_template_name,
					action_name,
					sub_action_name
				},
				fast_forward_time = fast_forward_time,
				rotation_speed = rotation_speed,
				rotation_max = rotation_max,
				rotation_speed_max = rotation_speed_max,
			},
			projectile_impact_system = {
				item_name = item_name,
				item_template_name = item_template_name,
				action_name = action_name,
				sub_action_name = sub_action_name,
				owner_unit = owner_unit,
				radius = radius
			},
			projectile_system = {
				item_name = item_name,
				item_template_name = item_template_name,
				action_name = action_name,
				sub_action_name = sub_action_name,
				owner_unit = owner_unit,
				time_initialized = time_initialized,
				scale = scale,
				fast_forward_time = fast_forward_time,
				is_critical_strike = is_critical_strike,
				power_level = power_level
			}
		}
		local projectile_units = self:_get_projectile_units_names(projectile_info, owner_unit)
		local projectile_unit_name = projectile_units.projectile_unit_name
		local projectile_unit = Managers.state.unit_spawner:spawn_network_unit(projectile_unit_name, projectile_info.projectile_unit_template_name or "player_projectile_unit", extension_init_data, position, rotation)

		self:_add_player_projectile_reference(owner_unit, projectile_unit, projectile_info)
	else
		func(self, owner_unit, position, rotation, scale, angle, target_vector, speed, item_name, item_template_name, action_name, sub_action_name, fast_forward_time, is_critical_strike, power_level, gaze_settings)
	end
end)

mod:hook(ProjectileScriptUnitLocomotionExtension, "update", function (func, self, unit, input, _, context, t)
	if self.rotation_max then
		self.life_time = t - self.spawn_time
		self.dt = t - self.t
		self.moved = false

		if self.stopped then
			return
		end

		local position = self._position:unbox()
		self.speed = self.speed - self.dt * self.speed * (1 - self._linear_dampening)
		local life_time = self.life_time
		local speed = self.speed / 100
		local radians = self.radians
		local gravity = self.gravity
		local target_vector = Vector3Box.unbox(self.target_vector_boxed)
		local initial_position = Vector3Box.unbox(self.initial_position_boxed)
		local trajectory_template_name = self.trajectory_template_name
		local is_husk = self.is_husk
		local trajectory = ProjectileTemplates.get_trajectory_template(trajectory_template_name, is_husk)
		local new_position = trajectory.update(speed, radians, gravity, initial_position, target_vector, life_time)
		local velocity = new_position - position
		local direction = Vector3.normalize(velocity)
		local length = Vector3.length(velocity)

		if not NetworkUtils.network_safe_position(new_position) then
			self:stop()

			if not self.is_husk then
				Managers.state.unit_spawner:mark_for_deletion(self.unit)
			end

			return
		end

		if length <= 0.001 then
			return
		end

		local direction_norm = Vector3.normalize(direction)
		local rotation = Quaternion.look(direction_norm)
		
		if self.rotation_speed ~= 0 then
			local left = -Quaternion.right(Quaternion.look(direction_norm, Vector3.up()))
			if self.life_time * self.rotation_speed > math.degrees_to_radians(self.rotation_max) and not self.rotation_max_set then
				self.rotation_max_set = self.life_time
				rotation = Quaternion.multiply(Quaternion.axis_angle(left, self.rotation_max_set * self.rotation_speed), rotation)
			elseif self.rotation_max_set then
					rotation = Quaternion.multiply(Quaternion.axis_angle(left, self.rotation_max_set  * self.rotation_speed), rotation)
			else
				rotation = Quaternion.multiply(Quaternion.axis_angle(left, self.life_time * self.rotation_speed), rotation)
			end
		end

		self:_unit_set_position_rotation(unit, new_position, rotation)
		self._last_position:store(position)
		self._position:store(new_position)
		self.velocity:store(velocity)

		self.moved = true
		self.t = t
		
	else
		func(self, unit, input, _, context, t)
	end
end)

mod:dofile("scripts/mods/throwables/dlc_init")
--dlc_init.dlc_init(mod,"throwable_spears")
if not get_mod("AnyWeapon") then
	mod:dofile("scripts/mods/throwables/crash_prevention")
end

mod:hook_origin(ProjectilePhysicsUnitLocomotionExtension, "init", function (self, extension_init_context, unit, extension_init_data)
	self.unit = unit
	self.physics_world = World.get_data(extension_init_context.world, "physics_world")
	self.owner_unit = extension_init_data.owner_unit
	self.network_position = extension_init_data.network_position
	self.network_rotation = extension_init_data.network_rotation
	self.network_velocity = extension_init_data.network_velocity
	self.network_angular_velocity = extension_init_data.network_angular_velocity
	self.is_server = Managers.player.is_server
	self.is_husk = not self.is_server
	self.stopped = false
	self.dropped = false
	local network_manager = Managers.state.network
	self.game = network_manager:game()
	self.network_manager = network_manager
	local position = AiAnimUtils.position_network_scale(self.network_position)
	local rotation = AiAnimUtils.rotation_network_scale(self.network_rotation)
	local velocity = AiAnimUtils.velocity_network_scale(self.network_velocity)
	local angular_velocity = AiAnimUtils.velocity_network_scale(self.network_angular_velocity)
	mod:pcall(function()
		--[[local physics_actor = Unit.create_actor(unit, "throw", 0)

		Actor.teleport_position(physics_actor, position)
		Actor.teleport_rotation(physics_actor, rotation)
		Actor.set_velocity(physics_actor, velocity)
		Actor.set_angular_velocity(physics_actor, angular_velocity)

		self.physics_actor = physics_actor]]

		for i = 1, Unit.num_actors(unit), 1 do
			local actor = Unit.actor(unit, i)

			if actor and Actor.is_physical(actor) then --and actor ~= physics_actor
				Actor.set_velocity(actor, velocity)
				Actor.set_angular_velocity(actor, angular_velocity)
				self.physics_actor = actor
			end
		end
	end)
end)

local STOP_VELOCITY_THRESHOLD = 0.1
local STOP_TIME_THRESHOLD = 0.5
mod:hook_origin(ProjectilePhysicsUnitLocomotionExtension, "update", function (self, unit, input, dt, context, t)
	if self.stopped then
		return
	end

	if script_data.debug_projectiles then
		local network_manager = self.network_manager
		local go_id = network_manager:unit_game_object_id(unit)
		local game = network_manager:game()

		GameSession.set_game_object_field(game, go_id, "debug_pos", Unit.local_position(unit, 0))
	end

	mod:pcall(function()
		local physics_actor = self.physics_actor
		local current_velocity = Actor.velocity(physics_actor)
		local current_velocity_length = Vector3.length(current_velocity)

		if current_velocity_length > STOP_VELOCITY_THRESHOLD then
			self.stop_time = nil

			return
		end
	end)

	local stop_time = self.stop_time or 0
	stop_time = stop_time + dt
	self.stop_time = stop_time

	if STOP_TIME_THRESHOLD <= stop_time then
		self:stop()
	end
end)

mod:hook_origin(ProjectilePhysicsUnitLocomotionExtension, "stop", function (self)
	self.stopped = true

	mod:pcall(function()Actor.put_to_sleep(self.physics_actor)end)

	local network_manager = self.network_manager
	local go_id = network_manager:unit_game_object_id(self.unit)

	network_manager.network_transmit:send_rpc_clients("rpc_projectile_stopped", go_id)
end)

mod:hook_origin(ProjectilePhysicsUnitLocomotionExtension, "drop", function (self)
	self.dropped = true

	mod:pcall(function()Actor.set_velocity(self.physics_actor, Vector3(0, 0, 0))end)

	local network_manager = self.network_manager
	local go_id = network_manager:unit_game_object_id(self.unit)

	network_manager.network_transmit:send_rpc_clients("rpc_drop_projectile", go_id)
end)