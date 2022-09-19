local wea = worldeditadditions
local wea_c = worldeditadditions_core
local Vector3 = wea_c.Vector3


-- ██     ██ ██████   ██████  ██   ██
-- ██     ██ ██   ██ ██    ██  ██ ██
-- ██  █  ██ ██████  ██    ██   ███
-- ██ ███ ██ ██   ██ ██    ██  ██ ██
--  ███ ███  ██████   ██████  ██   ██

worldeditadditions_core.register_command("wbox", {
	params = "<replace_node>",
	description = "Sets the edges of the current selection to <replace_node>",
	privs = {worldedit=true},
	require_pos = 2,
	parse = function(params_text)
		if params_text == "" then
			return false, "Error: too few arguments! Expected: \"<replace_node>\""
		end
		local node = worldedit.normalize_nodename(params_text)
		if not node then
			return false, "invalid node name: " .. params_text
		end
		return true, node
	end,
	nodes_needed = function(name)
		local delta = Vector3.subtract(worldedit.pos2[name], worldedit.pos1[name]):abs():add(1)
		local total, mult, axes = 1, 4, {"x","y","z"}
		for k,v in pairs(axes) do
			if worldedit.pos1[name] ~= worldedit.pos2[name] then total = total*2
			else mult = mult/2 end
		end
		for k,v in pairs(axes) do
			if delta[v] > 2 then total = total + (delta[v] - 2)*mult end
		end
		return total
	end,
	func = function(name, node)
		local start_time = wea_c.get_ms_time()
		
		local pos1, pos2 = Vector3.sort(worldedit.pos1[name], worldedit.pos2[name])
		local success, count = wea.wire_box(pos1, pos2, node)
		if not success then return success, count end
		
		local time_taken = wea_c.format.human_time(wea_c.get_ms_time() - start_time)
		
		
		minetest.log("action", name.." used //wbox at "..pos1.." - "..pos2..", taking "..time_taken)
		return true, count .. " nodes set in "..time_taken
	end,
})
