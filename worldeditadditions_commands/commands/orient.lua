local core = worldeditadditions_core
local Vector3 = core.Vector3


-- ██████   ██████  ████████  █████  ████████ ███████ 
-- ██   ██ ██    ██    ██    ██   ██    ██    ██      
-- ██████  ██    ██    ██    ███████    ██    █████   
-- ██   ██ ██    ██    ██    ██   ██    ██    ██      
-- ██   ██  ██████     ██    ██   ██    ██    ███████ 

worldeditadditions_core.register_command("orient+", {
	params = "<axis> <degrees> [<axis> <degrees> ...]",
	description = "Rotates nodes in the defined region around the given axis by the given number of degrees. Angles are not limited to 90-degree increments, but rounding is done at the end of all calculations because rotating blocks by non-cardinal directions is not supported by the Minetest engine. When multiple axes and angles are specified, these transformations are applied in order. Note that some nodes do not have support for orientation.",
	privs = { worldedit = true },
	require_pos = 2,
	parse = function (params_text)
		if not params_text then params_text = "" end
		local parts = core.split_shell(params_text)
		
		print("DEBUG:rotate/parse parts", core.inspect(parts))
		
		local mode_store
		local mode = "AXIS"
		local success, axis_next, angle
		
		-- TODO this rotlist parser is duplicated in the //rotate+ command - deduplicate it.
		local rotlist = {}
		
		for i,part in ipairs(parts) do
			if mode == "AXIS" then
				-- TODO: Somehow move this parsing ----> main func to get player reference to allow for relative stuff
				success, axis_next = core.parse.axes_rotation.axis_name(part)
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
		
		print("DEBUG:orient/parse ROTLIST", core.inspect(rotlist))
		
		return true, rotlist
	end,
	nodes_needed = function(name, _rotlist)
		return Vector3.volume(core.pos.get1(name), core.pos.get2(name))
	end,
	func = function(name, rotlist)
		local start_time = core.get_ms_time()
		-------------------------------------------------
		
		local pos1, pos2 = core.pos.get12(name)
		
		local success, stats = worldeditadditions.orient(
			pos1, pos2,
			rotlist
		)
		if not success then return success, stats end
		
		-------------------------------------------------
		local time_taken = core.get_ms_time() - start_time
		
		
		minetest.log("action", name .. " used //orient at "..pos1.." - "..pos2..", reorienting "..stats.count.." nodes in "..time_taken.."s")
		return true, stats.count.." nodes reoriented through "..tostring(#rotlist).." rotations in "..core.format.human_time(time_taken)
	end
})
