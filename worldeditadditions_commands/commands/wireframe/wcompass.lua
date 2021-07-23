-- ██     ██  ██████  ██████  ███    ███ ██████   █████  ███████ ███████
-- ██     ██ ██      ██    ██ ████  ████ ██   ██ ██   ██ ██      ██
-- ██  █  ██ ██      ██    ██ ██ ████ ██ ██████  ███████ ███████ ███████
-- ██ ███ ██ ██      ██    ██ ██  ██  ██ ██      ██   ██      ██      ██
--  ███ ███   ██████  ██████  ██      ██ ██      ██   ██ ███████ ███████
local wea = worldeditadditions
worldedit.register_command("wcompass", {
	params = "<replace_node> [<bead_node>]",
	description = "Creates a compass around pos1 with a single node bead pointing north (+Z).",
	privs = {worldedit=true},
	require_pos = 1,
	parse = function(params_text)
		local parts = wea.split(params_text," ",true)
		local node1 = worldedit.normalize_nodename(parts[1])
		local node2 = worldedit.normalize_nodename(parts[2])
		if not node1 then
			return false, "Invalid <replace_node>: " .. parts[1]
		elseif parts[2] and not node2 then
			return false, "Invalid <bead_node>: " .. parts[2]
		elseif not parts[2] then
			node2 = node1
		end
		return true, node1, node2
	end,
	nodes_needed = function(name)
		local p1, p2, total = worldedit.pos1[name], worldedit.pos2[name], 1
		for k,v in pairs({"x","y","z"}) do
			if p1[v] ~= p2[v] then total = total*2 end
		end
		return total
	end,
	func = function(name, node1, node2)
		local _, count = wea.make_compass(worldedit.pos1[name], node1, node2)
		return _, count .. " nodes set"
	end,
})
