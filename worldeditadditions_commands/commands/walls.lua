-- ██     ██  █████  ██      ██      ███████
-- ██     ██ ██   ██ ██      ██      ██
-- ██  █  ██ ███████ ██      ██      ███████
-- ██ ███ ██ ██   ██ ██      ██           ██
--  ███ ███  ██   ██ ███████ ███████ ███████
worldedit.register_command("walls", {
	params = "[<replace_node=dirt> [<thickness=1>]]",
	description = "Creates vertical walls of <replace_node> around the inside edges of the defined region. Optionally specifies a thickness for the walls to be created (defaults to 1)",
	privs = { worldedit = true },
	require_pos = 2,
	parse = function(params_text)
		if not params_text or params_text == "" then params_text = "dirt" end
		local parts = worldeditadditions.split_shell(params_text)
		
		local target_node
		local thickness = 1
		
		local target_node_raw = table.remove(parts, 1)
		target_node = worldedit.normalize_nodename(target_node_raw)
		if not target_node then
			return false, "Error: Invalid node name '"..target_node_raw.."'."
		end
		
		if #parts > 0 then
			local thickness_raw = table.remove(parts, 1)
			thickness = tonumber(thickness_raw)
			if not thickness then return false, "Error: Invalid thickness value '"..thickness_raw.."'. The thickness value must be a positive integer greater than or equal to 0." end
			if thickness < 1 then return false, "Error: That thickness value '"..thickness_raw.."' is out of range. The thickness value must be a positive integer greater than or equal to 0." end
		end
		
		return true, target_node, math.floor(thickness)
	end,
	nodes_needed = function(name, target_node, thickness)
		-- //overlay only modifies up to 1 node per column in the selected region
		local pos1, pos2 = worldedit.sort_pos(worldedit.pos1[name], worldedit.pos2[name])
		
		local pos3 = {
			x = pos2.x - thickness*2,
			z = pos2.z - thickness*2,
			y = pos2.y }
		
		return worldedit.volume(pos1, pos2) - worldedit.volume(pos1, pos3)
	end,
	func = function(name, target_node, thickness)
		local start_time = worldeditadditions.get_ms_time()
		local success, replaced = worldeditadditions.walls(
			worldedit.pos1[name], worldedit.pos2[name],
			target_node, thickness
		)
		local time_taken = worldeditadditions.get_ms_time() - start_time
		
		minetest.log("action", name .. " used //walls from "..worldeditadditions.vector.tostring(worldedit.pos1[name]).." to "..worldeditadditions.vector.tostring(worldedit.pos1[name])..", replacing " .. replaced .. " nodes in " .. time_taken .. "s")
		return true, replaced .. " nodes replaced in " .. worldeditadditions.format.human_time(time_taken)
	end
})
