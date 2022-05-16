local wea = worldeditadditions
local Vector3 = wea.Vector3

-- ██████   ██████  ███    ███ ███████
-- ██   ██ ██    ██ ████  ████ ██
-- ██   ██ ██    ██ ██ ████ ██ █████
-- ██   ██ ██    ██ ██  ██  ██ ██
-- ██████   ██████  ██      ██ ███████
worldedit.register_command("metaballs", {
	params = "add <radius> | remove <index> | list | render <replace_node> | clear",
	description = "Defines and creates metaballs. After using the add subcommand to define 1 or more metaballs (uses pos1), the render subcommand can then be used to create the metaballs as nodes.",
	privs = { worldedit = true },
	require_pos = 1,
	parse = function(params_text)
		if not params_text then params_text = "" end
		
		local parts = wea.split_shell(params_text)
		
		if #parts < 1 then
			return false, "Error: Not enough arguments (see /help /dome for usage information)."
		end
		local subcommand = parts[1]
		local subargs = {}
		if subcommand == "add" then
			local radius = tonumber(parts[2])
			if not radius then
				return false, "Error: Invalid radius '"..parts[1].."'. The radius must be a positive integer."
			end
			if radius < 1 then
				return false, "Error: The minimum radius size is 1, but you entered "..tostring(radius).."."
			end
			table.insert(subargs, radius)
		elseif subcommand == "remove" then
			local index = tonumber(parts[2])
			if not index then
				return false, "Error: Invalid index '"..parts[1].."'. The index to remove must be a positive integer."
			end
			if index < 1 then
				return false, "Error: The minimum index size is 1, but you entered "..tostring(index).."."
			end
			table.insert(subargs, index)
		elseif subcommand == "render" then
			local replace_node = worldedit.normalize_nodename(parts[2])
			if not replace_node then
				return false, "Error: Invalid replace_node '"..parts[2].."'."
			end
			table.insert(subargs, replace_node)
		end
		
		return true, subcommand, subargs
	end,
	nodes_needed = function(name, subcommand)
		if subcommand == "render" then
			return worldedit.volume(worldedit.pos1[name], worldedit.pos2[name])
		else
			return 0
		end
	end,
	func = function(name, radius, replace_node, axes, hollow)
		local start_time = wea.get_ms_time()
		
		
		
		
		local time_taken = wea.get_ms_time() - start_time
		
		
		minetest.log("action", name.." used //dome+ at "..pos.." with a radius of "..tostring(radius)..", modifying "..nodes_replaced.." nodes in "..wea.format.human_time(time_taken))
		return true, nodes_replaced.." nodes replaced "..wea.format.human_time(time_taken)
	end
})
