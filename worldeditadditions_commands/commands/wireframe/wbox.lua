-- ██     ██ ██████   ██████  ██   ██
-- ██     ██ ██   ██ ██    ██  ██ ██
-- ██  █  ██ ██████  ██    ██   ███
-- ██ ███ ██ ██   ██ ██    ██  ██ ██
--  ███ ███  ██████   ██████  ██   ██
local wea = worldeditadditions
local v3 = worldeditadditions.Vector3
worldedit.register_command("wbox", {
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
		local delta = v3.subtract(worldedit.pos2[name], worldedit.pos1[name]):abs():add(1)
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
		local _, count = wea.wire_box(worldedit.pos1[name], worldedit.pos2[name], node)
		return _, count .. " nodes set"
	end,
})
