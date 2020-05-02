local we_c = worldeditadditions_commands

-- ███    ███  █████  ███████ ███████
-- ████  ████ ██   ██    ███  ██
-- ██ ████ ██ ███████   ███   █████
-- ██  ██  ██ ██   ██  ███    ██
-- ██      ██ ██   ██ ███████ ███████

local function parse_params_maze(params_text)
	if not params_text then
		return nil, nil, nil
	end
	local found, _, replace_node, seed_text = params_text:find("([a-z:_\\-]+)%s+([0-9]+)")
	
	local has_seed = true
	
	if found == nil then
		has_seed = false 
		replace_node = params_text
	end
	
	local seed = tonumber(seed_text)
	
	replace_node = worldedit.normalize_nodename(replace_node)
	
	return replace_node, seed, has_seed
end

minetest.register_chatcommand("/maze", {
	params = "<replace_node> [<seed>]",
	description = "Generates a maze covering the currently selected area (must be at least 3x3 on the x,z axes) with replace_node as the walls. Optionally takes a (integer) seed.",
	privs = { worldedit = true },
	func = we_c.safe_region(function(name, params_text)
		local replace_node, seed, has_seed = parse_params_maze(params_text)
		
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
		local replaced = worldedit.maze(worldedit.pos1[name], worldedit.pos2[name], replace_node, seed)
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
	params = "<replace_node> [<seed>]",
	description = "Generates a 3d maze covering the currently selected area (must be at least 3x3x3) with replace_node as the walls. Optionally takes a (integer) seed.",
	privs = { worldedit = true },
	func = we_c.safe_region(function(name, params_text)
		local replace_node, seed, has_seed = parse_params_maze(params_text)
		
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
		local replaced = worldedit.maze3d(worldedit.pos1[name], worldedit.pos2[name], replace_node, seed)
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
