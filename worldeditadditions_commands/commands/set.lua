local wea = worldeditadditions
local core = worldeditadditions_core
local Vector3 = core.Vector3

-- ███████ ███████ ████████
-- ██      ██         ██      █
-- ███████ █████      ██    █████
--      ██ ██         ██      █
-- ███████ ███████    ██
core.register_command("set+", {
	params =
	"[param|param2|p2|light|l] <value>",
	description =
	"Sets the node, param2, or light level to a fixed value in the defined region. Defaults to setting the node. If param2/p2 is specified, the param2 value associated with nodes is set instead. If light/l is specified, the light level is set.",
	privs = { worldedit = true },
	require_pos = 2,
	parse = function(params_text)
		if not params_text or params_text == "" then
			return false, "Error: No arguments specified"
		end
		
		local parts = core.split_shell(params_text)
				
		local mode = "param"
		local value = nil
		
		local possible_modes = { "param", "p", "param2", "p2", "light", "l" }
		
		if core.table.contains(possible_modes, parts[1]) then
			mode = parts[1]
			table.remove(parts, 1)
		end
		value = table.concat(parts, " ")
		
		-- Normalise mode
		if mode == "p" then mode = "param"
		elseif mode == "p2" then mode = "param2"
		elseif mode == "l" then mode = "light" end
		
		if mode == "param" then
			local val_raw = value
			value = worldedit.normalize_nodename(value)
			if not value then return false, tostring(val_raw).." could not be normalised into a valid node name, and the mode was set to 'param'." end
		else
			local val_raw = value
			value = tonumber(value)
			if not value then return false, tostring(val_raw).." does not appear to be a valid number." end
			value = math.floor(value)
		end
		
		return true, mode, value
	end,
	nodes_needed = function(name) -- target_node, target_node_chance, replace_nodes
		return worldedit.volume(worldedit.pos1[name], worldedit.pos2[name])
	end,
	func = function(name, mode, value)
		local start_time = core.get_ms_time()
		local pos1, pos2 = core.pos.get12(name)
		
		local success, stats = wea.set(
			worldedit.pos1[name], worldedit.pos2[name],
			mode,
			value
		)
		if not success then return success, stats end
		
		local time_taken = core.get_ms_time() - start_time


		minetest.log("action",
			name ..
			" used //set+ at "..pos1.." - "..pos2..", affecting "..stats.changed.." nodes in "..time_taken.."s")

		return true, stats.changed.." nodes updated in "..core.format.human_time(time_taken)
	end
})
