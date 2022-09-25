local wea_c = worldeditadditions_core
local Vector3 = wea_c.Vector3

-- ███████ ██████  ██      ██ ███    ██ ███████ 
-- ██      ██   ██ ██      ██ ████   ██ ██      
-- ███████ ██████  ██      ██ ██ ██  ██ █████   
--      ██ ██      ██      ██ ██  ██ ██ ██      
-- ███████ ██      ███████ ██ ██   ████ ███████ 


worldeditadditions_core.register_command("spline", {
	params = "<replace_node> <width_start> [<width_end=width_start> [<steps=3>]]",
	description = "Draws a spline through the defined points. NOTE: Uses the NEW worldeditadditions position system, not the existing WorldEdit one!",
	privs = { worldedit = true },
	require_pos = 3,
	parse = function(params_text)
		local parts = wea_c.split_shell(params_text)
		
		local replace_node
		local width_start
		local width_end
		local steps = 3
		
		if #parts < 1 then
			return false, "Error: The replace_node (e.g. dirt) was not specified."
		end
		if #parts < 2 then
			return false, "Error: The starting width wasn't specified."
		end
		
		replace_node = worldedit.normalize_nodename(parts[1])
		if not replace_node then
			return false, "Error: Unknown node name '"..parts[1].."."
		end
		
		width_start = tonumber(parts[2])
		if not width_start then
			return false, "Error: width_start must be an integer greater than or  equal to 0."
		end
		if width_start < 0 then
			return false, "Error: width_start must be an integer greater than 0, but you passed '"..parts[2].."'."
		end
		
		if #parts >= 3 then
			width_end = tonumber(parts[3])
			if not width_end then
				return false, "Error: width_end must be an integer greater than or  equal to 0."
			end
			if width_end < 0 then
				return false, "Error: width_end must be an integer greater than 0, but you passed '"..parts[3].."'."
			end
		else
			width_end = width_start
		end
		
		if #parts >= 4 then
			steps = tonumber(parts[4])
			if not steps then
				return false, "Error: steps must be an integer greater than or equal to 0."
			end
			if steps < 0 then
				return false, "Error: steps must be an integer greater than or equal to 0, but you passed '"..parts[3].."'."
			end
		end
		
		return true, replace_node, width_start, width_end, steps
	end,
	nodes_needed = function(player_name, _replace_node, _width_start, _width_end, steps)
		if steps > 10 then return "may result in a large number of interpolated points" end
		-- //overlay only modifies up to 1 node per column in the selected region
		local pos1, pos2 = wea_c.pos.get_bounds(player_name)
		return Vector3.volume(pos1, pos2)
	end,
	func = function(player_name, replace_node, width_start, width_end, steps)
		local start_time = wea_c.get_ms_time()
		local pos_list = wea_c.pos.get_all(player_name)
		
		local success, nodes_replaced = worldeditadditions.spline(
			pos_list,
			width_start,
			width_end,
			steps,
			replace_node
		)
		if not success then return success, nodes_replaced end
		local time_taken = wea_c.format.human_time(wea_c.get_ms_time() - start_time)
		
		
		minetest.log("action", player_name.." used //spline with "..#pos_list.." initial points and "..steps.." steps, replacing "..nodes_replaced.." nodes in "..time_taken)
		return true, nodes_replaced.." nodes replaced in "..time_taken
	end
})
