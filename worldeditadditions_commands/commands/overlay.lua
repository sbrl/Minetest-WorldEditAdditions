--  ██████  ██    ██ ███████ ██████  ██       █████  ██    ██
-- ██    ██ ██    ██ ██      ██   ██ ██      ██   ██  ██  ██
-- ██    ██ ██    ██ █████   ██████  ██      ███████   ████
-- ██    ██  ██  ██  ██      ██   ██ ██      ██   ██    ██
--  ██████    ████   ███████ ██   ██ ███████ ██   ██    ██
worldedit.register_command("overlay", {
	params = "<replace_node>",
	description = "Places <replace_node> in the last contiguous air space encountered above the first non-air node. In other words, overlays all top-most nodes in the specified area with <replace_node>.",
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
		return (pos2.x - pos1.x) * (pos2.y - pos1.y)
	end,
	func = function(name, target_node)
		local start_time = os.clock()
		local changes = worldeditadditions.overlay(worldedit.pos1[name], worldedit.pos2[name], target_node)
		local time_taken = os.clock() - start_time
		
		minetest.log("action", name .. " used //overlay at " .. worldeditadditions.vector.tostring(worldedit.pos1[name]) .. ", replacing " .. changes.updated .. " nodes and skipping " .. changes.skipped_columns .. " columns in " .. time_taken .. "s")
		return true, changes.updated .. " nodes replaced and " .. changes.skipped_columns .. " columns skipped in " .. time_taken .. "s"
	end
})
