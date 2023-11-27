local wea_c = worldeditadditions_core
local Vector3 = wea_c.Vector3


-- ███    ██  ██████  ██████   ██████  ██    ██ ██████  ███████
-- ████   ██ ██       ██   ██ ██    ██ ██    ██ ██   ██ ██     
-- ██ ██  ██ ██   ███ ██████  ██    ██ ██    ██ ██████  ███████
-- ██  ██ ██ ██    ██ ██   ██ ██    ██ ██    ██ ██           ██
-- ██   ████  ██████  ██   ██  ██████   ██████  ██      ███████

worldeditadditions_core.register_command("ngroups", {
	params = "<node_name> [v[erbose]]",
	description =
	"Lists the groups that a given node is a part of. If v or verbose are tagged on the end, then group values are also displayed. See also //nodeapply, which pairs well with this command.",
	privs = {},
	parse = function(params_text)
		local parts = wea_c.split_shell(params_text)
		if #parts == 0 or parts[1] == "" then
			return false, "Error: No node name specified."
		end
		
		local node_name = worldedit.normalize_nodename(parts[1])
		if not node_name then
			return false, "Error: Unknown node "..parts[1].."."
		end
		
		local verbose = false
		if parts[2] == "v" or parts[2] == "verbose" then
			verbose = true
		end
		
		return true, node_name, verbose
	end,
	nodes_needed = function()
		return 0
	end,
	func = function(_, node_name, verbose)
		local node_def = minetest.registered_nodes[node_name]
		if not node_def then return false, "Error: Failed to find definition for node "..node_name.."." end
		
		local msg = { node_name, "∈" }
		for group_name, value in pairs(node_def.groups) do
			local part = group_name
			if verbose then
				part = part.."="..tostring(value)
			end
			table.insert(msg, part)
		end
		
		return true, table.concat(msg, " ")
	end
})
