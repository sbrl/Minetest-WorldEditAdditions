local core = worldeditadditions_core
local Vector3 = core.Vector3

-- ███    ██ ██████  ███████ ███████ 
-- ████   ██ ██   ██ ██      ██      
-- ██ ██  ██ ██   ██ █████   █████   
-- ██  ██ ██ ██   ██ ██      ██      
-- ██   ████ ██████  ███████ ██      
worldeditadditions_core.register_command("ndef", {
	params = "<node_name>",
	description =
	"Prints the current definintion for the given node.",
	privs = {},
	parse = function(params_text)
		params_text = core.trim(params_text)
		if params_text == "" then return false, "No node name specified." end
		
		local node_name = worldedit.normalize_nodename(params_text)
		if not node_name then
			return false, "Error: Unknown node " .. params_text .. "."
		end
		
		return true, node_name
	end,
	nodes_needed = function()
		return 0
	end,
	func = function(_, node_name)
		local node_def = minetest.registered_nodes[node_name]
		if not node_def then return false, "Error: Failed to find definition for node " .. node_name .. "." end
		
		local msg = { node_name, core.inspect(node_def) }
		print(table.concat(msg, " "))
		return true, table.concat(msg, " ")
	end
})
