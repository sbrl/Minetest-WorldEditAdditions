local wea = worldeditadditions
local wea_c = worldeditadditions_core
local Vector3 = wea_c.Vector3

-- ██████   ██████  ███    ███ ███████
-- ██   ██ ██    ██ ████  ████ ██
-- ██   ██ ██    ██ ██ ████ ██ █████
-- ██   ██ ██    ██ ██  ██  ██ ██
-- ██████   ██████  ██      ██ ███████
worldeditadditions_core.register_command("metaball", {
	params = "add <radius> | remove <index> | render <replace_node> [<threshold=1>] | list | clear | volume",
	description = "Defines and creates metaballs. After using the add subcommand to define 1 or more metaballs (uses pos1), the render subcommand can then be used to create the metaballs as nodes.",
	privs = { worldedit = true },
	require_pos = 1,
	parse = function(params_text)
		if not params_text then params_text = "" end
		
		local parts = wea_c.split_shell(params_text)
		
		if #parts < 1 then
			return false, "Error: Not enough arguments (see /help /metaball for usage information)."
		end
		
		local subcommand = parts[1]
		local subargs = {}
		
		if subcommand == "delete" then subcommand = "remove" end
		if subcommand == "deleteall" then subcommand = "clear" end
		if subcommand == "append" then subcommand = "add" end
		if subcommand == "list" then subcommand = "list" end
		if subcommand == "make" then subcommand = "render" end
		if subcommand == "generate" then subcommand = "render" end
		if subcommand == "create" then subcommand = "render" end
		
		if subcommand == "add" then
			if #parts < 2 then
				return false, "Error: Not enough arguments."
			end
			local radius = tonumber(parts[2])
			if not radius then
				return false, "Error: Invalid radius '"..parts[2].."'. The radius must be a positive integer."
			end
			if radius < 1 then
				return false, "Error: The minimum radius size is 1, but you entered "..tostring(radius).."."
			end
			table.insert(subargs, radius)
		elseif subcommand == "remove" then
			if #parts < 2 then
				return false, "Error: Not enough arguments."
			end
			local index = tonumber(parts[2])
			if not index then
				return false, "Error: Invalid index '"..parts[2].."'. The index to remove must be a positive integer."
			end
			if index < 1 then
				return false, "Error: The minimum index size is 1, but you entered "..tostring(index).."."
			end
			table.insert(subargs, index)
		elseif subcommand == "render" then
			if #parts < 2 then
				return false, "Error: Not enough arguments."
			end
			local replace_node = worldedit.normalize_nodename(parts[2])
			local threshold = 1
			
			if not replace_node then
				return false, "Error: Invalid replace_node '"..parts[2].."'."
			end
			
			if #parts >= 3 then
				threshold = tonumber(parts[3])
				if not threshold then
					return false, "Error: The threshold value must be a valid number (a floating-point number is ok)."
				end
			end
			table.insert(subargs, replace_node)
			table.insert(subargs, threshold)
		elseif subcommand ~= "list" and subcommand ~= "clear" and subcommand ~= "volume" then
			return false, "Error: Unknown subcommand '"..parts[1].."'."
		end
		
		return true, subcommand, subargs
	end,
	nodes_needed = function(name, subcommand)
		if subcommand == "render" then
			local success, value = wea.metaballs.volume(name)
			
			if not success then
				worldedit.player_notify(name, value)
				return -1
			end
			
			return value
		else
			return 0
		end
	end,
	func = function(name, subcommand, subargs)
		local start_time = wea_c.get_ms_time()
		local message = ""
		local append_time = false
		if subcommand == "list" then
			local success, list = wea.metaballs.list_pretty(name)
			if not success then return success, list end
			
			message = list
		elseif subcommand == "volume" then
			local success, metaballs_list = wea.metaballs.list(name)
			if not success then return success, metaballs_list end
			local success2, volume = wea.metaballs.volume(name)
			if not success2 then return success2, volume end
			
			message = #metaballs_list.." metaballs will take up to "..tostring(volume).." nodes of space"
		elseif subcommand == "clear" then
			local metaballs_cleared = wea.metaballs.clear(name)
			message = tostring(metaballs_cleared).." metaballs cleared"
		elseif subcommand == "remove" then
			local index = subargs[1]
			
			local success, metaballs_count = wea.metaballs.remove(name, index)
			if not success then return success, metaballs_count end
			
			message = "metaball at index "..tostring(index).." removed - "..tostring(metaballs_count).." metaballs remain"
		elseif subcommand == "add" then
			local pos = Vector3.clone(worldedit.pos1[name]):round()
			local radius = subargs[1]
			
			local success, metaballs_count = wea.metaballs.add(name, pos, radius)
			if not success then return success, metaballs_count end
			
			message = "added metaball at "..pos.." with radius "..tostring(radius).." - "..metaballs_count.." metaballs are now defined"
			append_time = false
		elseif subcommand == "render" then
			local replace_node = subargs[1]
			local threshold = subargs[2]
			
			local success, metaballs = wea.metaballs.list(name)
			if not success then return success, metaballs end
			
			if #metaballs < 2 then
				return false, "Error: At least 2 metaballs must be defined to render them."
			end
			
			local success2, nodes_replaced = wea.metaballs.render(metaballs, replace_node, threshold)
			if not success2 then return success2, nodes_replaced end
			
			message = nodes_replaced.." nodes replaced using "..tostring(#metaballs).." metaballs"
			append_time = true
		end
		
		local time_taken = wea_c.get_ms_time() - start_time
		
		
		if append_time then
			message = message.." in "..wea_c.format.human_time(time_taken)
		end
		
		minetest.log("action", name.." used //metaballs "..subcommand.." in "..wea_c.format.human_time(time_taken))
		return true, message
	end
})
