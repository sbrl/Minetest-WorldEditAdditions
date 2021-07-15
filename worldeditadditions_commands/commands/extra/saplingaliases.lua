-- ███████  █████  ██████  ██      ██ ███    ██  ██████   █████  ██      ██  █████  ███████ ███████ ███████
-- ██      ██   ██ ██   ██ ██      ██ ████   ██ ██       ██   ██ ██      ██ ██   ██ ██      ██      ██
-- ███████ ███████ ██████  ██      ██ ██ ██  ██ ██   ███ ███████ ██      ██ ███████ ███████ █████   ███████
--      ██ ██   ██ ██      ██      ██ ██  ██ ██ ██    ██ ██   ██ ██      ██ ██   ██      ██ ██           ██
-- ███████ ██   ██ ██      ███████ ██ ██   ████  ██████  ██   ██ ███████ ██ ██   ██ ███████ ███████ ███████
minetest.register_chatcommand("/saplingaliases", {
	params = "[aliases|all_saplings]",
	description = "Lists all the currently registered sapling aliases (default). A single argument is taken as the mode of operation. Current modes: aliases (default; as described previously), all_saplings (lists all node names with the group \"sapling\")",
	privs = { worldedit = true },
	func = function(name, params_text)
		if name == nil then return end
		if params_text == "" or not params_text then
			params_text = "aliases"
		end
		
		local msg = {}
		
		if params_text == "aliases" then
			table.insert(msg, "Currently registered aliases:\n")
			local aliases = worldeditadditions.get_all_sapling_aliases()
			local display = {}
			for node_name, alias in pairs(aliases) do
				table.insert(display, { node_name, alias })
			end
			table.sort(display, function(a, b) return a[2] < b[2] end)
			table.insert(msg, worldeditadditions.format.make_ascii_table(display))
		elseif params_text == "all_saplings" then
			local results = worldeditadditions.registered_nodes_by_group("sapling")
			table.insert(msg, "Sapling-like nodes:\n")
			local str = table.concat(results, "\n")
			table.insert(msg, str)
		else
			table.insert(msg, "Unknown mode '")
			table.insert(msg, params_text)
			table.insert(msg, "' (valid modes: aliases, all_saplings).")
		end
		worldedit.player_notify(name, table.concat(msg))
	end
})
