--  ██████  ██    ██ ███████ ██████  ██       █████  ██    ██
-- ██    ██ ██    ██ ██      ██   ██ ██      ██   ██  ██  ██
-- ██    ██ ██    ██ █████   ██████  ██      ███████   ████
-- ██    ██  ██  ██  ██      ██   ██ ██      ██   ██    ██
--  ██████    ████   ███████ ██   ██ ███████ ██   ██    ██
worldedit.register_command("overlay", {
	params = "<replace_node_a> [<chance_a>] <replace_node_b> [<chance_b>] [<replace_node_N> [<chance_N>]] ...",
	description = "Places <replace_node_a> in the last contiguous air space encountered above the first non-air node. In other words, overlays all top-most nodes in the specified area with <replace_node_a>. Optionally supports a mix of nodes and chances, as in //mix and //replacemix.",
	privs = { worldedit = true },
	require_pos = 2,
	parse = function(params_text)
		local success, node_list = worldeditadditions.parse.weighted_nodes(
			worldeditadditions.split_shell(params_text)
		)
		return success, node_list
	end,
	nodes_needed = function(name)
		-- //overlay only modifies up to 1 node per column in the selected region
		local pos1, pos2 = worldedit.sort_pos(worldedit.pos1[name], worldedit.pos2[name])
		return (pos2.x - pos1.x) * (pos2.y - pos1.y)
	end,
	func = function(name, node_list)
		local start_time = worldeditadditions.get_ms_time()
		local changes = worldeditadditions.overlay(worldedit.pos1[name], worldedit.pos2[name], node_list)
		local time_taken = worldeditadditions.get_ms_time() - start_time
		
		minetest.log("action", name .. " used //overlay at " .. worldeditadditions.vector.tostring(worldedit.pos1[name]) .. ", replacing " .. changes.updated .. " nodes and skipping " .. changes.skipped_columns .. " columns in " .. time_taken .. "s")
		return true, changes.updated .. " nodes replaced and " .. changes.skipped_columns .. " columns skipped in " .. worldeditadditions.format.human_time(time_taken)
	end
})
