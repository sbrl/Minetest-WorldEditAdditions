--  ██████  ██████  ██    ██ ███    ██ ████████
-- ██      ██    ██ ██    ██ ████   ██    ██
-- ██      ██    ██ ██    ██ ██ ██  ██    ██
-- ██      ██    ██ ██    ██ ██  ██ ██    ██
--  ██████  ██████   ██████  ██   ████    ██
worldedit.register_command("count", {
	params = "",
	description = "Counts all the nodes in the defined region.",
	privs = { worldedit = true },
	require_pos = 2,
	parse = function(params_text)
		return true
	end,
	nodes_needed = function(name)
		-- We don't actually modify anything, but without returning a
		-- number here safe_region doesn't work
		return worldedit.volume(worldedit.pos1[name], worldedit.pos2[name])
	end,
	func = function(name)
		local start_time = os.clock()
		
		local success, counts, total = worldeditadditions.count(worldedit.pos1[name], worldedit.pos2[name], target_node)
		local result = worldeditadditions.make_ascii_table(counts).."\n"..
			string.rep("=", 6 + #tostring(total) + 6).."\n"..
			"Total "..total.." nodes\n"
		
		local time_taken = os.clock() - start_time
		
		
		minetest.log("action", name.." used //count at "..worldeditadditions.vector.tostring(worldedit.pos1[name]).." - "..worldeditadditions.vector.tostring(worldedit.pos2[name])..", counting "..total.." nodes in "..time_taken.."s")
		return true, result
	end
})
