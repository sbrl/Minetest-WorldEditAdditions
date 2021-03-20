-- ███████ ██ ██      ██       ██████  █████  ██    ██ ███████ ███████
-- ██      ██ ██      ██      ██      ██   ██ ██    ██ ██      ██
-- █████   ██ ██      ██      ██      ███████ ██    ██ █████   ███████
-- ██      ██ ██      ██      ██      ██   ██  ██  ██  ██           ██
-- ██      ██ ███████ ███████  ██████ ██   ██   ████   ███████ ███████
worldedit.register_command("fillcaves", {
	params = "[<node_name>]",
	description = "Fills in all airlike nodes beneath the first non-airlike node detected in each column.",
	privs = { worldedit = true },
	require_pos = 2,
	parse = function (params_text)
		if params_text == "" then
			params_text = "stone"
		end
		local replace_node = worldedit.normalize_nodename(params_text)
		if not replace_node then
			return false, "Error: Invalid node name."
		end
		
		return true, replace_node
	end,
	nodes_needed = function(name)
		return worldedit.volume(worldedit.pos1[name], worldedit.pos2[name])
	end,
	func = function(name, replace_node)
		local start_time = worldeditadditions.get_ms_time()
		
		local success, stats = worldeditadditions.fillcaves(worldedit.pos1[name], worldedit.pos2[name], replace_node)
		if not success then return success, stats end
		
		local time_taken = worldeditadditions.get_ms_time() - start_time
		
		minetest.log("action", name .. " used //fillcaves at " .. worldeditadditions.vector.tostring(worldedit.pos1[name]) .. ", replacing " .. stats.replaced .. " nodes in " .. time_taken .. "s")
		return true, stats.replaced .. " nodes replaced in " .. worldeditadditions.format.human_time(time_taken)
	end
})
