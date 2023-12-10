local wea_c = worldeditadditions_core
local Vector3 = wea_c.Vector3


-- ██████   ██████  ████████  █████  ████████ ███████ 
-- ██   ██ ██    ██    ██    ██   ██    ██    ██      
-- ██████  ██    ██    ██    ███████    ██    █████   
-- ██   ██ ██    ██    ██    ██   ██    ██    ██      
-- ██   ██  ██████     ██    ██   ██    ██    ███████ 

worldeditadditions_core.register_command("rotate", {
	params = "<axis> <degrees> [<axis> <degrees> ...] [origin|o [<pos_number>]]",
	description = "Rotates the defined region arounnd the given axis by the given number of degrees. Angles are NOT limited to 90-degree increments. When multiple axes and angles are specified, these transformations are applied in order. If o [<pos_number>] is specified, then the specific position number (default: 3) is considered a custom rotation origin instead of the centre of the region. CAUTION: Rotating large areas of memory by 45° can be memory intensive!",
	privs = { worldedit = true },
	require_pos = 2,
	parse = function (params_text)
		if not params_text then params_text = "" end
		local parts = wea_c.split_shell(params_text)
		
		local mode_store
		local mode = "AXIS"
		local success, axis_next, angle
		
		local origin = "__AUTO__"
		local rotlist = {}
		
		for i,part in ipairs(parts) do
			if part == "origin" or part == "o" then
				mode_store = mode
				mode = "ORIGIN"
			elseif mode == "ORIGIN" then
				origin = tonumber(part)
				if not origin or origin < 1 then
					return false, "Error: Expected positive integer as the WorldEditAdditions position that should be considered the origin point for rotation operation."
				end
				origin = math.floor(origin)
				
				mode = mode_store
				mode_store = nil
			elseif mode == "AXIS" then
				axis_next = wea_c.parse.axis_rotation.axis_name(part)
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
		
		return true, origin, rotlist
	end,
	nodes_needed = function(name, times)
		-- TODO: .......this is a good question, actually.
	end,
	func = function(name, origin, rotlist)
		local start_time = wea_c.get_ms_time()

		-- TODO: Do rotation operation here.
		
		local time_taken = wea_c.get_ms_time() - start_time
		
		
		-- TODO: Update logging below. This will obviously crash due to unknown variables right now.
		minetest.log("action", name .. " used //rotate at "..pos1.." - "..pos2.." with origin "..origin..", replacing "..changed.." nodes in "..time_taken.."s")
		return true, changed.." nodes replaced in "..wea_c.format.human_time(time_taken)
	end
})
