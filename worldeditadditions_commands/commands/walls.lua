-- ██     ██  █████  ██      ██      ███████
-- ██     ██ ██   ██ ██      ██      ██
-- ██  █  ██ ███████ ██      ██      ███████
-- ██ ███ ██ ██   ██ ██      ██           ██
--  ███ ███  ██   ██ ███████ ███████ ███████
worldedit.register_command("walls", {
	params = "<replace_node>",
	description = "Creates vertical walls of <replace_node> around the inside edges of the defined region.",
	privs = { worldedit = true },
	require_pos = 2,
	parse = function(params_text)
		local target_node = worldedit.normalize_nodename(params_text)
		if not target_node then
			return false, "Error: Invalid node name"
		end
		return true, target_node
	end,
	nodes_needed = function(name)
		-- //overlay only modifies up to 1 node per column in the selected region
		local pos1, pos2 = worldedit.sort_pos(worldedit.pos1[name], worldedit.pos2[name])
		
		local pos3 = { x = pos2.x - 2, z = pos2.z - 2, y = pos2.y }
		
		return worldedit.volume(pos1, pos2) - worldedit.volume(pos1, pos3)
	end,
	func = function(name, target_node)
		local start_time = worldeditadditions.get_ms_time()
		local success, replaced = worldeditadditions.walls(worldedit.pos1[name], worldedit.pos2[name], target_node)
		local time_taken = worldeditadditions.get_ms_time() - start_time
		
		minetest.log("action", name .. " used //walls from "..worldeditadditions.vector.tostring(worldedit.pos1[name]).." to "..worldeditadditions.vector.tostring(worldedit.pos1[name])..", replacing " .. replaced .. " nodes in " .. time_taken .. "s")
		return true, replaced .. " nodes replaced in " .. worldeditadditions.format.human_time(time_taken)
	end
})
