local we_c = worldeditadditions_commands

--  ██████  ██    ██ ███████ ██████  ██       █████  ██    ██
-- ██    ██ ██    ██ ██      ██   ██ ██      ██   ██  ██  ██
-- ██    ██ ██    ██ █████   ██████  ██      ███████   ████
-- ██    ██  ██  ██  ██      ██   ██ ██      ██   ██    ██
--  ██████    ████   ███████ ██   ██ ███████ ██   ██    ██

minetest.register_chatcommand("/overlay", {
	params = "<replace_node>",
	description = "Places <replace_node> in the last contiguous air space encountered above the first non-air node. In other words, overlays all top-most nodes in the specified area with <replace_node>.",
	privs = { worldedit = true },
	func = we_c.safe_region(function(name, params_text)
		local target_node = worldedit.normalize_nodename(params_text)
		
		if not target_node then
			worldedit.player_notify(name, "Error: Invalid node name.")
			return false
		end
		
		local start_time = os.clock()
		local changes = worldedit.overlay(worldedit.pos1[name], worldedit.pos2[name], target_node)
		local time_taken = os.clock() - start_time
		
		worldedit.player_notify(name, changes.updated .. " nodes replaced and " .. changes.skipped_columns .. " columns skipped in " .. time_taken .. "s")
		minetest.log("action", name .. " used //overlay at " .. worldeditadditions.vector.tostring(worldedit.pos1[name]) .. ", replacing " .. changes.updated .. " nodes and skipping " .. changes.skipped_columns .. " columns in " .. time_taken .. "s")
	end, function(name, params_text)
		if not worldedit.normalize_nodename(params_text) then
			worldedit.player_notify(name, "Error: Invalid node name '" .. params_text .. "'.")
			return 0
		end
		
		local pos1 = worldedit.pos1[name]
		local pos2 = worldedit.pos2[name]
		pos1, pos2 = worldedit.sort_pos(pos1, pos2)
		
		local vol = vector.subtract(pos2, pos1)
		
		return vol.x*vol.z
	end)
})
