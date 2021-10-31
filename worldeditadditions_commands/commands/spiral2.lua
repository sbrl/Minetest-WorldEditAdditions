
local wea = worldeditadditions
local Vector3 = wea.Vector3

worldedit.register_command("spiral2", {
	params = "[<circle|square>] [<replace_node=dirt> [<interval=3> [<acceleration=0>] ] ]",
	description = "Generates a spiral that fills the defined region using the specified replace node. The spiral is either square (default) or circular in shape. The interval specifies the distance between the walls of the spiral, and the acceleration specifies how quickly this value should increase.",
	privs = { worldedit = true },
	require_pos = 2,
	parse = function(params_text)
		if not params_text then params_text = "" end
		params_text = wea.trim(params_text)
		if params_text == "" then return true, "square", "dirt", 3, 0 end
		
		local parts = wea.split_shell(params_text)
		
		local mode = "square"
		local target_node = "dirt"
		local target_node_found = false
		local interval = 3
		local acceleration = 0
	
		if parts[1] ~= "circle" and parts[1] ~= "square" then
			target_node = parts[1]
			target_node_found = true
			table.remove(parts, 1)
		else
			mode = parts[1]
			table.remove(parts, 1)
		end
		
		if #parts >= 1 and not target_node_found then
			target_node = parts[1]
			table.remove(parts, 1)
		end
		if #parts >= 1 then
			interval = tonumber(parts[1])
			if not interval then
				return false, "Error: Invalid interval value '"..tostring(parts[1]).."'. Interval values must be integers."
			end
			table.remove(parts, 1)
		end
		if #parts >= 1 then
			acceleration = tonumber(parts[1])
			if not acceleration then
				return false, "Error: Invalid acceleration value '"..tostring(parts[1]).."'. Acceleration values must be integers."
			end
			table.remove(parts, 1)
		end
		
		local target_node_norm = worldedit.normalize_nodename(target_node)
		if not target_node_norm then
			return false, "Error: Unknown node '"..tostring(target_node).."'."
		end
		
		return true, mode, target_node_norm, interval, acceleration
	end,
	nodes_needed = function(name)
		return worldedit.volume(worldedit.pos1[name], worldedit.pos2[name])
	end,
	func = function(name, mode, target_node, interval, acceleration)
		local start_time = wea.get_ms_time()
		
		local pos1, pos2 = Vector3.sort(worldedit.pos1[name], worldedit.pos2[name])
		
		local success, count
		
		if mode == "circle" then
			success, count = wea.spiral_circle(
				pos1, pos2,
				target_node,
				interval, acceleration
			)
			if not success then return success, count end
		else
			success, count = wea.spiral_square(
				pos1, pos2,
				target_node,
				interval, acceleration
			)
			if not success then return success, count end
		end
		local time_taken = wea.get_ms_time() - start_time
		
		minetest.log("action", name .. " used //spiral at "..pos1.." - "..pos2..", adding " .. count .. " nodes in " .. time_taken .. "s")
		return true, count .. " nodes replaced in " .. wea.format.human_time(time_taken)
	end
})
