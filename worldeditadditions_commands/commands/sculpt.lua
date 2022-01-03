local we_c = worldeditadditions_commands
local wea = worldeditadditions
local Vector3 = wea.Vector3

-- ███████  ██████ ██    ██ ██      ██████  ████████
-- ██      ██      ██    ██ ██      ██   ██    ██
-- ███████ ██      ██    ██ ██      ██████     ██
--      ██ ██      ██    ██ ██      ██         ██
-- ███████  ██████  ██████  ███████ ██         ██
worldedit.register_command("sculpt", {
	params = "[<brush_name=default> [<height=5> [<brush_size=10>]]]",
	description = "Applies a sculpting brush to the terrain with a given height. See //sculptlist to list all available brushes. Note that while the brush size is configurable, the actual brush size you end up with may be slightly different to that which you request due to brush size restrictions.",
	privs = { worldedit = true },
	require_pos = 1,
	parse = function(params_text)
		if not params_text or params_text == "" then
			params_text = "circle_soft1"
		end
		
		local parts = wea.split_shell(params_text)
		
		local brush_name = "circle_soft1"
		local height = 5
		local brush_size = 10
		
		if #parts >= 1 then
			brush_name = table.remove(parts, 1)
			if not wea.sculpt.brushes[brush_name] then
				return false, "A brush with the name '"..brush_name.."' doesn't exist. Try using //sculptlist to list all available brushes."
			end
		end
		if #parts >= 1 then
			height = tonumber(table.remove(parts, 1))
			if not height then
				return false, "Invalid height value (must be an integer - negative values lower terrain instead of raising it)"
			end
		end
		if #parts >= 1 then
			brush_size = tonumber(table.remove(parts, 1))
			if not brush_size or brush_size < 1 then
				return false, "Invalid brush size. Brush sizes must be a positive integer."
			end
		end
		
		brush_size = Vector3.new(brush_size, brush_size, 0):floor()
		
		return true, brush_name, math.floor(height), brush_size
	end,
	nodes_needed = function(name, brush_name, height, brush_size)
		local success, brush, size_actual = wea.sculpt.make_brush(brush_name, brush_size)
		if not success then return 0 end
		
		-- This solution allows for brushes with negative values
		-- it also allows for brushes that 'break the rules' and have values
		-- that exceed the -1 to 1 range
		local brush_min = wea.min(brush)
		local brush_max = wea.max(brush)
		local range_nodes = (brush_max * height) - (brush_min * height)
		
		return size_actual.x * size_actual.y * range_nodes
	end,
	func = function(name, brush_name, height, brush_size)
		local start_time = wea.get_ms_time()
		
		local pos1 = wea.Vector3.clone(worldedit.pos1[name])
		local success, stats = wea.sculpt.apply(
			pos1,
			brush_name, height, brush_size
		)
		if not success then return success, stats.added end
		
		local time_taken = wea.get_ms_time() - start_time
		
		minetest.log("action", name .. " used //sculpt at "..pos1..", adding " .. stats.added.." nodes and removing "..stats.removed.." nodes in "..time_taken.."s")
		return true, stats.added.." nodes added and "..stats.removed.." removed in "..wea.format.human_time(time_taken)
	end
})
