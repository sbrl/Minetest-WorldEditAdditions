local wea_c = worldeditadditions_core
local Vector3 = wea_c.Vector3



-- ██████  ███████ ██    ██  ██████  ██      ██    ██ ███████ 
-- ██   ██ ██      ██    ██ ██    ██ ██      ██    ██ ██      
-- ██████  █████   ██    ██ ██    ██ ██      ██    ██ █████   
-- ██   ██ ██       ██  ██  ██    ██ ██       ██  ██  ██      
-- ██   ██ ███████   ████    ██████  ███████   ████   ███████ 
worldeditadditions_core.register_command("revolve", {
	params = "<times> [<pivot_point_number=last_point>]",
	description = "Creates a number of copies of the defined region rotated at equal intervals.",
	privs = { worldedit = true },
	require_pos = 2,
	parse = function (params_text)
		if not params_text then params_text = "" end
		local parts = wea_c.split_shell(params_text)
		
		if #parts < 1 then
			return false, "Error: No number of times specified. times should be a positive integer greater than 1"
		end
		
		local times = tonumber(parts[1])
		local origin = -1 -- -1 = last point
		
		if not times or times < 2 then
			return false, "Error: Invalid number of times. The value for times must be a positive integer greater than 1."
		end
		
		if #parts > 1 then
			origin = tonumber(parts[2])
			if not origin then
				return false, "Error: Invalid pivot point number. The pivot point number must be a positive integer greater than 2."
			end
			if origin == 1 or origin == 2 then
				return false, "Error: Point numbers 1 and 2 are reserved for defining the region that should be cloned."
			end
		end
		
		return true, times, origin
	end,
	nodes_needed = function(name, times)
		-- TODO: Calculate the bounding box for everything, since we'll be grabbing a VoxelManip for the for entire area and then operating on that
		return worldedit.volume(worldedit.pos1[name], worldedit.pos2[name]) * times
	end,
	func = function(name, times, origin_point_number)
		local start_time = wea_c.get_ms_time()
		local pos1, pos2 = Vector3.sort(worldedit.pos1[name], worldedit.pos2[name])
		
		local pos_count = wea_c.pos.count(name)
		if pos_count < origin_point_number then
			return false, "Error: You only have "..pos_count.." points defined, yet requested the origin/pivot point be point "..origin_point_number.."."
		end
		
		if origin_point_number == -1 then
			origin_point_number = pos_count
		end
		local origin = wea_c.pos.get(name, origin_point_number)
		
		local success, changed = worldeditadditions.revolve(
			pos1, pos2,
			origin,
			times
		)
		if not success then return success, changed end
		
		local time_taken = wea_c.get_ms_time() - start_time
		
		minetest.log("action", name .. " used //revolve at "..pos1.." - "..pos2.." with origin "..origin..", replacing "..changed.." nodes in "..time_taken.."s")
		return true, changed.." nodes replaced in "..wea_c.format.human_time(time_taken)
	end
})
