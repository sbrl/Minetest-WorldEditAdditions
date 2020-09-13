--  ██████  ██    ██ ███████ ██████  ██       █████  ██    ██
-- ██    ██ ██    ██ ██      ██   ██ ██      ██   ██  ██  ██
-- ██    ██ ██    ██ █████   ██████  ██      ███████   ████
-- ██    ██  ██  ██  ██      ██   ██ ██      ██   ██    ██
--  ██████    ████   ███████ ██   ██ ███████ ██   ██    ██
worldedit.register_command("forest", {
	params = "<sapling_a> [<chance_a>] <sapling_b> [<chance_b>] [<sapling_N> [<chance_N>]] ...",
	description = "Plants and grows trees in the defined region according to the given list of sapling names and chances. Saplings are planted using //overlay - so the chances a 1-in-N change of actually planting a sapling at each candidate location. Saplings that fail to grow are subsequently removed (this will affect pre-existing saplings too)",
	privs = { worldedit = true },
	require_pos = 2,
	parse = function(params_text)
		local success, sapling_list = worldeditadditions.parse_weighted_nodes(
			worldeditadditions.split(params_text, "%s+", false),
			false,
			function(name)
				return worldedit.normalize_nodename(
					worldeditadditions.normalise_saplingname(name)
				)
			end
		)
		return success, sapling_list
	end,
	nodes_needed = function(name)
		-- //overlay only modifies up to 1 node per column in the selected region
		local pos1, pos2 = worldedit.sort_pos(worldedit.pos1[name], worldedit.pos2[name])
		return (pos2.x - pos1.x) * (pos2.y - pos1.y)
	end,
	func = function(name, sapling_list)
		local start_time = worldeditadditions.get_ms_time()
		local changes = worldeditadditions.forest(worldedit.pos1[name], worldedit.pos2[name], sapling_list)
		local time_taken = worldeditadditions.get_ms_time() - start_time
		
		minetest.log("action", name .. " used //forest at " .. worldeditadditions.vector.tostring(worldedit.pos1[name]) .. ", replacing " .. changes.updated .. " nodes and skipping " .. changes.skipped_columns .. " columns in " .. time_taken .. "s")
		return true, changes.updated .. " nodes replaced and " .. changes.skipped_columns .. " columns skipped in " .. worldeditadditions.human_time(time_taken)
	end
})
