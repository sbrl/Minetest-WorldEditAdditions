-- ██     ██  ██████  ██████  ██████  ███    ██ ███████ ██████
-- ██     ██ ██      ██    ██ ██   ██ ████   ██ ██      ██   ██
-- ██  █  ██ ██      ██    ██ ██████  ██ ██  ██ █████   ██████
-- ██ ███ ██ ██      ██    ██ ██   ██ ██  ██ ██ ██      ██   ██
--  ███ ███   ██████  ██████  ██   ██ ██   ████ ███████ ██   ██
local wea = worldeditadditions
worldedit.register_command("wcorner", {
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
		local _, count = wea.corner_set(worldedit.pos1[name], worldedit.pos2[name], node)
		return _, count .. " nodes set"
	end,
})
