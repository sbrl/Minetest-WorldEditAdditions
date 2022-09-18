local wea_c = worldeditadditions_core
local wea = worldeditadditions
local Vector3 = wea_c.Vector3

local function parse_stage2(name, parts)
	local result = Vector3.new()
	for i,axis_name in ipairs(parts) do
		local success, result_this = wea_c.parse.axis_name(axis_name, wea_c.player_dir(name))
		if not success then return success, result_this end
		
		result = result + result_this
	end
	
	result = result:clamp(Vector3.new(-1, -1, -1), Vector3.new(1, 1,  1))
	
	
	if result.length == 0 then 
		return false, "Refusing to create a dome with no distinct pointing direction."
	end
	
	return true, result
end

-- ██████   ██████  ███    ███ ███████
-- ██   ██ ██    ██ ████  ████ ██
-- ██   ██ ██    ██ ██ ████ ██ █████
-- ██   ██ ██    ██ ██  ██  ██ ██
-- ██████   ██████  ██      ██ ███████
worldeditadditions_core.register_command("dome+", { -- TODO: Make this an override
	params = "<radius> <replace_node> [<pointing_dir:x|y|z|-x|-y|-z|?|front|back|left|right|up|down> ...] [h[ollow]]",
	description = "Creates a dome shape with a specified radius of the defined node, optionally specifying the direction it should be pointing in (defaults to the positive y direction).",
	privs = { worldedit = true },
	require_pos = 1,
	parse = function(params_text)
		if not params_text then params_text = "" end
		
		local parts = wea_c.split_shell(params_text)
		
		if #parts < 2 then
			return false, "Error: Not enough arguments (see /help /dome for usage information)."
		end
		local radius = tonumber(parts[1])
		local replace_node = worldedit.normalize_nodename(parts[2])
		local hollow = false
		
		if not radius then
			return false, "Error: Invalid radius '"..parts[1].."'. The radius must be a positive integer."
		end
		if radius < 1 then
			return false, "Error: The minimum radius size is 1, but you entered "..tostring(radius).."."
		end
		
		if not replace_node then
			return false, "Error: Invalid replace_node '"..parts[1].."'."
		end
		
		if #parts > 2 and (parts[#parts] == "h" or parts[#parts] == "hollow") then 
			hollow = true
			table.remove(parts, #parts)
		end
		local axes = wea_c.table.shallowcopy(parts)
		table.remove(axes, 1)
		table.remove(axes, 1)
		
		if #axes == 0 then
			table.insert(axes, "+y")
		end
		
		return true, radius, replace_node, axes, hollow
	end,
	nodes_needed = function(name, radius)
		return 4/3 * math.pi * radius * radius * radius
	end,
	func = function(name, radius, replace_node, axes, hollow)
		local start_time = wea_c.get_ms_time()
		
		local success_a, pointing_dir = parse_stage2(name, axes)
		if not success_a then return success_a, pointing_dir end
		
		local pos = Vector3.clone(worldedit.pos1[name])

		local success_b, nodes_replaced = wea.dome(
			pos,
			radius,
			replace_node,
			pointing_dir,
			hollow
		)
		if not success_b then return success_b, nodes_replaced end
		
		local time_taken = wea_c.get_ms_time() - start_time
		
		
		minetest.log("action", name.." used //dome+ at "..pos.." with a radius of "..tostring(radius)..", modifying "..nodes_replaced.." nodes in "..wea_c.format.human_time(time_taken))
		return true, nodes_replaced.." nodes replaced "..wea_c.format.human_time(time_taken)
	end
})
