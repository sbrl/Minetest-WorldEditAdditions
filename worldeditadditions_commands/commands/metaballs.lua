local wea = worldeditadditions
local Vector3 = wea.Vector3

-- ██████   ██████  ███    ███ ███████
-- ██   ██ ██    ██ ████  ████ ██
-- ██   ██ ██    ██ ██ ████ ██ █████
-- ██   ██ ██    ██ ██  ██  ██ ██
-- ██████   ██████  ██      ██ ███████
worldedit.register_command("metaballs", {
	params = "add <radius> | remove <index> | list | render <replace_node> [<threshold=1>] | clear",
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
		
		if subcommand == "delete" then subcommand = "remove" end
		if subcommand == "deleteall" then subcommand = "clear" end
		if subcommand == "append" then subcommand = "add" end
		if subcommand == "list" then subcommand = "list" end
		if subcommand == "make" then subcommand = "render" end
		if subcommand == "generate" then subcommand = "render" end
		if subcommand == "create" then subcommand = "render" end
		
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
		elseif subcommand ~= "list" and subcommand ~= "clear" then
			return false, "Error: Unknown subcommand '"..parts[1].."'."
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
	func = function(name, subcommand, subargs)
		local start_time = wea.get_ms_time()
		local message = ""
		local append_time = true
		if subcommand == "list" then
			local success, list = wea.metaballs.list_pretty(name)
			if not success then return success, list end
			
			message = list
			append_time = false
		elseif subcommand == "clear" then
			local success, metaballs_cleared = wea.metaballs.clear(name)
			if not success then return success, metaballs_cleared end
			
			message = tostring(metaballs_cleared).." cleared"
		elseif subcommand == "remove" then
			local index = subargs[1]
			
			local success, metaballs_count = wea.metaballs.remove(name, index)
			if not success then return success, metaballs_count end
			
			message = "metaball at index "..tostring(index).." removed - "..metaballs_count.." metaballs remain"
		elseif subcommand == "add" then
			local pos = Vector3.clone(worldedit.pos1[name])
			local radius = subargs[1]
			
			local success, metaballs_count = wea.metaballs.add(name, pos, radius)
			if not success then return success, metaballs_count end
			
			message = "added metaball at "..pos.." with radius "..tostring(radius).." - "..metaballs_count.." metaballs are now defined"
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
		end
		
		local time_taken = wea.get_ms_time() - start_time
		
		
		if append_time then
			message = message.." in "..wea.format.human_time(time_taken)
		end
		
		minetest.log("action", name.." used //metaballs "..subcommand.." in "..wea.format.human_time(time_taken))
		return true, message
	end
})
