local wea_c = worldeditadditions_core
local wea = worldeditadditions
local Vector3 = wea_c.Vector3

--  ██████  ██████  ██    ██ ███    ██ ████████
-- ██      ██    ██ ██    ██ ████   ██    ██
-- ██      ██    ██ ██    ██ ██ ██  ██    ██
-- ██      ██    ██ ██    ██ ██  ██ ██    ██
--  ██████  ██████   ██████  ██   ████    ██
worldeditadditions_core.register_command("count", {
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
		local start_time = wea_c.get_ms_time()
		local pos1, pos2 = Vector3.sort(worldedit.pos1[name], worldedit.pos2[name])
		local success, counts, total = wea.count(
			pos1, pos2,
			true
		)
		if not success then return success, counts end
		
		local result = "\n"..wea_c.format.make_ascii_table(counts).."\n"..
			string.rep("=", 6 + #tostring(total) + 6).."\n"..
			"Total "..total.." nodes\n"
		
		local time_taken = wea_c.get_ms_time() - start_time
		
		
		minetest.log("action", name.." used //count at "..pos1.." - "..pos2..", counting "..total.." nodes in "..wea_c.format.human_time(time_taken))
		return true, result
	end
})
