local wea_c = worldeditadditions_core
local wea = worldeditadditions
local Vector3 = wea_c.Vector3

--  ██████  ██    ██ ███████ ██████  ██       █████  ██    ██
-- ██    ██ ██    ██ ██      ██   ██ ██      ██   ██  ██  ██
-- ██    ██ ██    ██ █████   ██████  ██      ███████   ████
-- ██    ██  ██  ██  ██      ██   ██ ██      ██   ██    ██
--  ██████    ████   ███████ ██   ██ ███████ ██   ██    ██
worldeditadditions_core.register_command("overlay", {
	params = "<replace_node_a> [<chance_a>] <replace_node_b> [<chance_b>] [<replace_node_N> [<chance_N>]] ...",
	description = "Places <replace_node_a> in the last contiguous air space encountered above the first non-air node. In other words, overlays all top-most nodes in the specified area with <replace_node_a>. Optionally supports a mix of nodes and chances, as in //mix and //replacemix.",
	privs = { worldedit = true },
	require_pos = 2,
	parse = function(params_text)
		local success, node_list = wea_c.parse.weighted_nodes(
			wea_c.split_shell(params_text)
		)
		return success, node_list
	end,
	nodes_needed = function(name)
		-- //overlay only modifies up to 1 node per column in the selected region
		local pos1, pos2 = worldedit.sort_pos(worldedit.pos1[name], worldedit.pos2[name])
		return (pos2.x - pos1.x) * (pos2.y - pos1.y)
	end,
	func = function(name, node_list)
		local start_time = wea_c.get_ms_time()
		local pos1, pos2 = Vector3.sort(worldedit.pos1[name], worldedit.pos2[name])

		local changes = wea.overlay(
			pos1, pos2,
			node_list
		)
		local time_taken = wea_c.get_ms_time() - start_time
		
		minetest.log("action", name .. " used //overlay at " .. pos1 .. " - "..pos2..", replacing " .. changes.updated .. " nodes and skipping " .. changes.skipped_columns .. " columns in " .. time_taken .. "s")
		return true, changes.updated .. " nodes replaced and " .. changes.skipped_columns .. " columns skipped in " .. wea_c.format.human_time(time_taken)
	end
})
