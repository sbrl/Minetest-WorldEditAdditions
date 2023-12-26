local weac = worldeditadditions_core
local wea = worldeditadditions
local weacmd = worldeditadditions_commands
local Vector3 = weac.Vector3



-- ███████ ██████  ███████ ███████ ██████  
-- ██      ██   ██ ██      ██      ██   ██ 
-- ███████ ██████  █████   █████   ██   ██ 
--      ██ ██      ██      ██      ██   ██ 
-- ███████ ██      ███████ ███████ ██████  
worldeditadditions_core.register_command("speed", {
	params = "[<value=1>]",
	description =
	"Changes your movement speed. A value of 1 = normal speed. Prepend + or - to add or subtract a given amount from the current value.",
	privs = { worldedit = true },
	require_pos = 0,
	parse = function(params_text)
		if not params_text or params_text == "" then
			params_text = "1"
		end
		
		local speed
		local mode = "absolute"
		
		params_text = weac.trim(params_text)
		
		if params_text:sub(1,1) == "+" or params_text:sub(1,1) == "-" then
			mode = "relative"
		end
		
		speed = tonumber(params_text)
		
		if not speed then return false, "Error: Invalid speed value. The speed value must be a number." end
		
		print("DEBUG:speed/parse PARAMS_TEXT", params_text, "MODE", mode, "SPEED", speed)
		
		return true, mode, speed
	end,
	nodes_needed = function(name)
		return 0
	end,
	func = function(name, mode, speed)
		local start_time = weac.get_ms_time()
		
		print("DEBUG:speed NAME", name, "MODE", mode, "SPEED", speed)
		
		local player = minetest.get_player_by_name(name)
		
		if mode == "absolute" then
			player:set_physics_override({
				speed = speed,
				climb_speed = speed
			})
		elseif mode == "relative" then
			local overrides = player:get_physics_override()
			local src_speed = overrides.speed or 1
			local src_climb_speed = overrides.climb_speed or 1
			player:set_physics_override({
				speed = src_speed + speed,
				climb_speed = src_climb_speed + speed
			})
		else
			return false, "Error: Unknown adjustment mode '"..tostring(mode).."'. This is a bug."
		end
		
		local overrides_after = player:get_physics_override()
		
		local time_taken = weac.get_ms_time() - start_time

		return true, "Movement speed is now x"..tostring(overrides_after.speed).."."
	end
})
