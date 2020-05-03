local we_c = worldeditadditions_commands

-- ███    ███  █████  ███████ ███████
-- ████  ████ ██   ██    ███  ██
-- ██ ████ ██ ███████   ███   █████
-- ██  ██  ██ ██   ██  ███    ██
-- ██      ██ ██   ██ ███████ ███████

local function parse_params_maze(params_text, is_3d)
	if not params_text then
		return nil, nil, nil, nil
	end
	
	local parts = we_c.split(params_text, "%s+", false)
	
	local replace_node = parts[1]
	local seed = os.time()
	local path_length = 2
	local path_width = 1
	local path_depth = 1
	
	local param_index_seed = 4
	if is_3d then param_index_seed = 5 end
	
	
	if #parts >= 2 then
		path_length = tonumber(parts[2])
	end
	if #parts >= 3 then
		path_width = tonumber(parts[3])
	end
	if #parts >= 4 and is_3d then
		path_depth = tonumber(parts[4])
	end
	if #parts >= param_index_seed then
		seed = tonumber(parts[param_index_seed])
	end
	
	replace_node = worldedit.normalize_nodename(replace_node)
	
	return replace_node, seed, path_length, path_width, path_depth
end

minetest.register_chatcommand("/maze", {
	params = "<replace_node> [<path_length> [<path_width> [<seed>]]]",
	description = "Generates a maze covering the currently selected area (must be at least 3x3 on the x,z axes) with replace_node as the walls. Optionally takes a (integer) seed and the path length and width (see the documentation in the worldeditadditions README for more information).",
	privs = { worldedit = true },
	func = we_c.safe_region(function(name, params_text)
		local replace_node, seed, path_length, path_width = parse_params_maze(params_text, false)
		
		if not replace_node then
			worldedit.player_notify(name, "Error: Invalid node name.")
			return false
		end
		
		local start_time = os.clock()
		local replaced = worldeditadditions.maze2d(worldedit.pos1[name], worldedit.pos2[name], replace_node, seed, path_length, path_width)
		local time_taken = os.clock() - start_time
		
		worldedit.player_notify(name, replaced .. " nodes replaced in " .. time_taken .. "s")
		minetest.log("action", name .. " used //maze at " .. worldeditadditions.vector.tostring(worldedit.pos1[name]) .. ", replacing " .. replaced .. " nodes in " .. time_taken .. "s")
	end, function(name, params_text)
		local replace_node, seed, has_seed = parse_params_maze(params_text)
		if not params_text then params_text = "" end
		
		if not replace_node then
			worldedit.player_notify(name, "Error: Invalid input '" .. params_text .. "' (specifically the replace node). Try '/help /maze' to learn how to use this command.")
			return 0
		end
		if not seed and has_seed then
			worldedit.player_notify(name, "Error: Invalid input '" .. params_text .. "' (specifically the seed). Try '/help /maze' to learn how to use this command.")
			return 0
		end
		
		local pos1 = worldedit.pos1[name]
		local pos2 = worldedit.pos2[name]
		
		return (pos2.x - pos1.x) * (pos2.y - pos1.y) * (pos1.z - pos2.z)
	end)
})



-- ███    ███  █████  ███████ ███████     ██████  ██████
-- ████  ████ ██   ██    ███  ██               ██ ██   ██
-- ██ ████ ██ ███████   ███   █████        █████  ██   ██
-- ██  ██  ██ ██   ██  ███    ██               ██ ██   ██
-- ██      ██ ██   ██ ███████ ███████     ██████  ██████

minetest.register_chatcommand("/maze3d", {
	params = "<replace_node> [<path_length> [<path_width> [<path_depth> [<seed>]]]]",
	description = "Generates a 3d maze covering the currently selected area (must be at least 3x3x3) with replace_node as the walls. Optionally takes a (integer) seed and the path length, width, and depth (see the documentation in the worldeditadditions README for more information).",
	privs = { worldedit = true },
	func = we_c.safe_region(function(name, params_text)
		local replace_node, seed, path_length, path_width, path_depth = parse_params_maze(params_text, true)
		
		if not replace_node then
			worldedit.player_notify(name, "Error: Invalid node name.")
			return false
		end
		if not seed and has_seed then
			worldedit.player_notify(name, "Error: Invalid seed.")
			return false
		end
		if not seed then seed = os.time() end
		
		local start_time = os.clock()
		local replaced = worldeditadditions.maze3d(worldedit.pos1[name], worldedit.pos2[name], replace_node, seed, path_length, path_width, path_depth)
		local time_taken = os.clock() - start_time
		
		worldedit.player_notify(name, replaced .. " nodes replaced in " .. time_taken .. "s")
		minetest.log("action", name .. " used //maze at " .. worldeditadditions.vector.tostring(worldedit.pos1[name]) .. ", replacing " .. replaced .. " nodes in " .. time_taken .. "s")
	end, function(name, params_text)
		local replace_node, seed, has_seed = parse_params_maze(params_text)
		if not params_text then params_text = "" end
		
		if not replace_node then
			worldedit.player_notify(name, "Error: Invalid input '" .. params_text .. "' (specifically the replace node). Try '/help /maze3d' to learn how to use this command.")
			return 0
		end
		if not seed and has_seed then
			worldedit.player_notify(name, "Error: Invalid input '" .. params_text .. "' (specifically the seed). Try '/help /maze3d' to learn how to use this command.")
			return 0
		end
		
		local pos1 = worldedit.pos1[name]
		local pos2 = worldedit.pos2[name]
		
		return (pos2.x - pos1.x) * (pos2.y - pos1.y) * (pos1.z - pos2.z)
	end)
})
