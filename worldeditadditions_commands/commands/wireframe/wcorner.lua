local wea_c = worldeditadditions_core
local wea = worldeditadditions
local Vector3 = wea_c.Vector3

-- ██     ██  ██████  ██████  ██████  ███    ██ ███████ ██████
-- ██     ██ ██      ██    ██ ██   ██ ████   ██ ██      ██   ██
-- ██  █  ██ ██      ██    ██ ██████  ██ ██  ██ █████   ██████
-- ██ ███ ██ ██      ██    ██ ██   ██ ██  ██ ██ ██      ██   ██
--  ███ ███   ██████  ██████  ██   ██ ██   ████ ███████ ██   ██

worldeditadditions_core.register_command("wcorner", {
	params = "<replace_node>",
	description = "Set the corners of the current selection to <replace_node>",
	privs = {worldedit=true},
	require_pos = 2,
	parse = function(params_text)
		local node = worldedit.normalize_nodename(params_text)
		if not node then
			return false, "invalid node name: " .. params_text
		end
		return true, node
	end,
	nodes_needed = function(name)
		local p1, p2, total = worldedit.pos1[name], worldedit.pos2[name], 1
		for k,v in pairs({"x","y","z"}) do
			if p1[v] ~= p2[v] then total = total*2 end
		end
		return total
	end,
	func = function(name, node)
		
		local start_time = wea_c.get_ms_time()
		
		local pos1, pos2 = Vector3.sort(worldedit.pos1[name], worldedit.pos2[name])
		local success, count = wea.corner_set(pos1, pos2, node)
		if not success then return success, count end
		
		local time_taken = wea_c.format.human_time(wea_c.get_ms_time() - start_time)
		
		
		
		minetest.log("action", name.." used //wcorner at "..pos1.." - "..pos2..", taking "..time_taken)
		return true, count .. " nodes set in "..time_taken
	end,
})
