local wea = worldeditadditions
local we_c = worldeditadditions_commands
local Vector3 = worldeditadditions.Vector3

local function parse_params_maze(params_text, is_3d)
	if not params_text then params_text = "" end
	params_text = wea.trim(params_text)
	if #params_text == 0 then
		return false, "No arguments specified"
	end
	
	local parts = worldeditadditions.split_shell(params_text)
	
	local replace_node = parts[1]
	local seed = os.time() * math.random()
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
		seed = worldeditadditions.parse.seed(parts[param_index_seed])
	end
	
	replace_node = worldedit.normalize_nodename(replace_node)
	
	if not replace_node then
		return false, "Error: Invalid node name for replace_node"
	end
	if not path_length or path_length < 1 then
		return false, "Error: Invalid path length (it must be a positive integer)"
	end
	if not path_width or path_width < 1 then
		return false, "Error: Invalid path width (it must be a positive integer)"
	end
	if not path_depth or path_depth < 1 then
		return false, "Error: Invalid path depth (it must be a positive integer)"
	end
	
	-- We unconditionally math.floor here because when we tried to test for it directly it was unreliable
	return true, replace_node, seed, math.floor(path_length), math.floor(path_width), math.floor(path_depth)
end



-- ███    ███  █████  ███████ ███████
-- ████  ████ ██   ██    ███  ██
-- ██ ████ ██ ███████   ███   █████
-- ██  ██  ██ ██   ██  ███    ██
-- ██      ██ ██   ██ ███████ ███████

worldedit.register_command("maze", {
	params = "<replace_node> [<path_length> [<path_width> [<seed>]]]",
	description = "Generates a maze covering the currently selected area (must be at least 3x3 on the x,z axes) with replace_node as the walls. Optionally takes a (integer) seed and the path length and width (see the documentation in the worldeditadditions README for more information).",
	privs = { worldedit = true },
	require_pos = 2,
	parse = function(params_text)
		local success, replace_node, seed, path_length, path_width = parse_params_maze(params_text, false)
		return success, replace_node, seed, path_length, path_width
	end,
	nodes_needed = function(name)
		-- Note that we could take in additional parameters from the return value of parse (minue the success bool there), but we don't actually need them here
		return worldedit.volume(worldedit.pos1[name], worldedit.pos2[name])
	end,
	func = function(name, replace_node, seed, path_length, path_width)
		local start_time = wea.get_ms_time()
		
		local pos1, pos2 = Vector3.sort(worldedit.pos1[name], worldedit.pos2[name])
		local replaced = wea.maze2d(
			pos1, pos2,
			replace_node,
			seed,
			path_length, path_width
		)
		
		local time_taken = wea.get_ms_time() - start_time
		
		minetest.log("action", name.." used //maze at "..pos1.." - "..pos2..", replacing "..replaced.." nodes in "..time_taken.."s")
		return true, replaced.." nodes replaced in "..wea.format.human_time(time_taken)
	end
})



-- ███    ███  █████  ███████ ███████     ██████  ██████
-- ████  ████ ██   ██    ███  ██               ██ ██   ██
-- ██ ████ ██ ███████   ███   █████        █████  ██   ██
-- ██  ██  ██ ██   ██  ███    ██               ██ ██   ██
-- ██      ██ ██   ██ ███████ ███████     ██████  ██████

worldedit.register_command("maze3d", {
	params = "<replace_node> [<path_length> [<path_width> [<path_depth> [<seed>]]]]",
	description = "Generates a 3d maze covering the currently selected area (must be at least 3x3x3) with replace_node as the walls. Optionally takes a (integer) seed and the path length, width, and depth (see the documentation in the worldeditadditions README for more information).",
	privs = { worldedit = true },
	require_pos = 2,
	parse = function(params_text)
		local values = {parse_params_maze(params_text, true)}
		return worldeditadditions.table.unpack(values)
	end,
	nodes_needed = function(name)
		return worldedit.volume(worldedit.pos1[name], worldedit.pos2[name])
	end,
	func = function(name, replace_node, seed, path_length, path_width, path_depth)
		local start_time = worldeditadditions.get_ms_time()
		local replaced = worldeditadditions.maze3d(worldedit.pos1[name], worldedit.pos2[name], replace_node, seed, path_length, path_width, path_depth)
		local time_taken = worldeditadditions.get_ms_time() - start_time
		
		
		minetest.log("action", name.." used //maze3d at "..worldeditadditions.vector.tostring(worldedit.pos1[name]).." - "..worldeditadditions.vector.tostring(worldedit.pos2[name])..", replacing "..replaced.." nodes in "..time_taken.."s")
		return true, replaced.." nodes replaced in "..worldeditadditions.format.human_time(time_taken)
	end
})
