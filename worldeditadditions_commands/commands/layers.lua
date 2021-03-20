--  ██████  ██    ██ ███████ ██████  ██       █████  ██    ██
-- ██    ██ ██    ██ ██      ██   ██ ██      ██   ██  ██  ██
-- ██    ██ ██    ██ █████   ██████  ██      ███████   ████
-- ██    ██  ██  ██  ██      ██   ██ ██      ██   ██    ██
--  ██████    ████   ███████ ██   ██ ███████ ██   ██    ██
worldedit.register_command("layers", {
	params = "[<node_name_1> [<layer_count_1>]] [<node_name_2> [<layer_count_2>]] ...",
	description = "Replaces the topmost non-airlike nodes with layers of the given nodes from top to bottom. Like WorldEdit for MC's //naturalize command. Default: dirt_with_grass dirt 3",
	privs = { worldedit = true },
	require_pos = 2,
	parse = function(params_text)
		if not params_text or params_text == "" then
			params_text = "dirt_with_grass dirt 3"
		end
		
		local success, node_list = worldeditadditions.parse.weighted_nodes(
			worldeditadditions.split(params_text, "%s+", false),
			true
		)
		return success, node_list
	end,
	nodes_needed = function(name)
		return worldedit.volume(worldedit.pos1[name], worldedit.pos2[name])
	end,
	func = function(name, node_list)
		local start_time = worldeditadditions.get_ms_time()
		local changes = worldeditadditions.layers(worldedit.pos1[name], worldedit.pos2[name], node_list)
		local time_taken = worldeditadditions.get_ms_time() - start_time
		
		minetest.log("action", name .. " used //layers at " .. worldeditadditions.vector.tostring(worldedit.pos1[name]) .. ", replacing " .. changes.replaced .. " nodes and skipping " .. changes.skipped_columns .. " columns in " .. time_taken .. "s")
		return true, changes.replaced .. " nodes replaced and " .. changes.skipped_columns .. " columns skipped in " .. worldeditadditions.format.human_time(time_taken)
	end
})
