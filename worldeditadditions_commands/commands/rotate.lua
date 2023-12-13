local wea_c = worldeditadditions_core
local Vector3 = wea_c.Vector3


-- ██████   ██████  ████████  █████  ████████ ███████ 
-- ██   ██ ██    ██    ██    ██   ██    ██    ██      
-- ██████  ██    ██    ██    ███████    ██    █████   
-- ██   ██ ██    ██    ██    ██   ██    ██    ██      
-- ██   ██  ██████     ██    ██   ██    ██    ███████ 

worldeditadditions_core.register_command("rotate+", {
	params = "<axis> <degrees> [<axis> <degrees> ...] [origin|o [<pos_number>]]",
	description = "Rotates the defined region arounnd the given axis by the given number of degrees. Angles are NOT limited to 90-degree increments. When multiple axes and angles are specified, these transformations are applied in order. If o [<pos_number>] is specified, then the specific position number (default: 3) is considered a custom rotation origin instead of the centre of the region. CAUTION: Rotating large areas of memory by 45° can be memory intensive!",
	privs = { worldedit = true },
	require_pos = 2,
	parse = function (params_text)
		if not params_text then params_text = "" end
		local parts = wea_c.split_shell(params_text)
		
		print("DEBUG:rotate/parse parts", wea_c.inspect(parts))
		
		local mode_store
		local mode = "AXIS"
		local success, axis_next, angle
		
		local origin = "__AUTO__"
		local rotlist = {}
		
		for i,part in ipairs(parts) do
			if part == "origin" or part == "o" then
				mode_store = mode
				
				-- If the NEXT item is a number, then parse it.
				if i < #parts and tonumber(parts[i+1]) ~= nil then
					mode = "ORIGIN"
				else
					-- If not, then default to pos3 and continue in the original mode
					origin = 3
				end
			elseif mode == "ORIGIN" then
				origin = tonumber(part)
				if not origin or origin < 1 then
					return false, "Error: Expected positive integer as the WorldEditAdditions position that should be considered the origin point for rotation operation."
				end
				origin = math.floor(origin)
				
				mode = mode_store
				mode_store = nil
			elseif mode == "AXIS" then
				success, axis_next = wea_c.parse.axes_rotation.axis_name(part)
				if not success then return success, axis_next end
				mode = "ANGLE"
			elseif mode == "ANGLE" then
				angle = part
				
				-- 1: Determine if radians; strip suffix
				local pos_rad = part:find("ra?d?$")
				if pos_rad then
					angle = angle:sub(1, pos_rad-1)
				end
				
				-- 2: Parse as number
				angle = tonumber(angle)
				if not angle then
					return false, "Error: Expected numerical angle value, but found '"..tostring(part).."'."
				end
				
				-- 3: Convert degrees → radians
				if not pos_rad then
					-- We have degrees! Convert em to radians 'cauuse mathematics
					angle = math.rad(angle)
				end
				
				-- 4: Add to rotlist
				table.insert(rotlist, {
					axis = axis_next,
					rad = angle
				})
				
				-- 5: Change mode and continue
				mode = "AXIS"
			else
				return false, "Error: Unknown parsing mode "..tostring(mode)..". This is a bug."
			end
		end
		
		print("DEBUG:rotate/parse ORIGIN", origin, "rotlist", wea_c.inspect(rotlist))
		
		return true, origin, rotlist
	end,
	nodes_needed = function(name, origin, rotlist)
		-- BUG: .......this is a good question, actually. This naïve is flawed, since if we rotate by e.g. 45° we could end up replacing more nodes than if we rotate by 90° increments. This is further complicated by the allowance of a custom point of origin.
		return Vector3.volume(wea_c.pos.get1(name), wea_c.pos.get2(name)) * 2
	end,
	func = function(name, origin, rotlist)
		local start_time = wea_c.get_ms_time()
		-------------------------------------------------
		local pos_origin = wea_c.pos.get(name, origin)
		local pos1, pos2 = wea_c.pos.get1(name), wea_c.pos.get2(name)
		
		
		local success, stats = worldeditadditions.rotate(
			pos1, pos2,
			pos_origin,
			rotlist
		)
		if not success then return success, stats end
		-------------------------------------------------
		local time_taken = wea_c.get_ms_time() - start_time
		
		
		minetest.log("action", name .. " used //rotate at "..pos1.." - "..pos2.." with origin "..pos_origin..", rotating "..stats.count_rotated.." nodes in "..time_taken.."s")
		return true, stats.count_rotated.." nodes rotated through "..tostring(#rotlist).." rotations in "..wea_c.format.human_time(time_taken)
	end
})
