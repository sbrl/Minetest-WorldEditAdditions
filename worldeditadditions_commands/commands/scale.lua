local function parse_scale_component(val)
	local result = tonumber(val)
	if result then return true, result end
	if string.find(val, "/") then
		local parts = worldeditadditions.split(val, "/", true)
		local a = tonumber(parts[1])
		local b = tonumber(parts[2])
		if not b then return false, "Invalid number after the forward slash in scale component." end
		if not a then return false, "Invalid number before the forward slash in scale component." end
		return true, a / b
	end
	if string.find(val, "%%") then
		local part = tonumber(string.sub(val, 1, -2))
		if not part then return false, "We thought a scale component was a percentage, but failed to parse percentage as number." end
		return true, part / 100
	end
	return false, "Failed to parse scale component (unrecognised format - we support things like '3', '0.5', '1/10', or '33%' without quotes)."
end

-- ███████  ██████  █████  ██      ███████
-- ██      ██      ██   ██ ██      ██
-- ███████ ██      ███████ ██      █████
--      ██ ██      ██   ██ ██      ██
-- ███████  ██████ ██   ██ ███████ ███████
worldedit.register_command("scale", {
	params = "<axis> <scale_factor> | <factor_x> [<factor_y> <factor_z> [<anchor_x> <anchor_y> <anchor_z>]]",
	description = "Combined scale up / down. Takes either an axis name + a scale factor (e.g. y 3 or -z 2; negative values swap the anchor point for the scale operation), or 3 scale factor values for x, y, and z respectively. In the latter mode, a set of anchors can also be specified, which indicate which size the scale operation should be anchored to.",
	privs = { worldedit = true },
	require_pos = 2,
	parse = function(params_text)
		if not params_text then params_text = "" end
		
		local parts = worldeditadditions.split_shell(params_text)
		
		local scale = vector.new(1, 1, 1)
		local anchor = vector.new(1, 1, 1)
		
		if #parts == 2 then
			if not (parts[1] == "x" or parts[1] == "y" or parts[1] == "z"
				or parts[1] == "-x" or parts[1] == "-y" or parts[1] == "-z") then
				return false, "Error: Got 2 arguments, but the first doesn't look like the name of an axis."
			end
			local axis = parts[1]
			local success, factor = parse_scale_component(parts[2])
			if not success then return success, "Error: Invalid scale factor. Details: "..factor end
			
			if axis:sub(1, 1) == "-" then
				axis = axis:sub(2, 2)
				anchor[axis] = -1
			end
			
			scale[axis] = factor
		elseif #parts >= 3 then
			local success, val = parse_scale_component(parts[1])
			if not success then return false, "Error: x axis scale factor wasn't a number. Details: "..val end
			scale.x = val
			
			success, val = parse_scale_component(parts[2])
			if not success then return false, "Error: y axis scale factor wasn't a number. Details: "..val end
			scale.y = val
			
			success, val = parse_scale_component(parts[3])
			if not success then return false, "Error: z axis scale factor wasn't a number. Details: "..val end
			scale.z = val
		else
			local success, val = parse_scale_component(parts[1])
			if not success then
				return false, "Error: scale factor wasn't a number. Details: "..val
			end
			scale.x = val
			scale.y = val
			scale.z = val
		end
		
		if #parts == 6 then
			local val = tonumber(parts[4])
			if not val then return false, "Error: x axis anchor wasn't a number." end
			anchor.x = val
			val = tonumber(parts[5])
			if not val then return false, "Error: y axis anchor wasn't a number." end
			anchor.y = val
			val = tonumber(parts[6])
			if not val then return false, "Error: z axis anchor wasn't a number." end
			anchor.z = val
		end
		
		if scale.x == 0 then return false, "Error: x scale factor was 0" end
		if scale.y == 0 then return false, "Error: y scale factor was 0" end
		if scale.z == 0 then return false, "Error: z scale factor was 0" end
		
		if anchor.x == 0 then return false, "Error: x axis anchor was 0" end
		if anchor.y == 0 then return false, "Error: y axis anchor was 0" end
		if anchor.z == 0 then return false, "Error: z axis anchor was 0" end
		
		return true, scale, anchor
	end,
	nodes_needed = function(name, scale, anchor)
		local volume = worldedit.volume(worldedit.pos1[name], worldedit.pos2[name])
		local factor = math.ceil(math.abs(scale.x))
			* math.ceil(math.abs(scale.y))
			* math.ceil(math.abs(scale.z))
		return volume * factor
	end,
	func = function(name, scale, anchor)
		-- print("initial scale: "..worldeditadditions.vector.tostring(scale)..", anchor: "..worldeditadditions.vector.tostring(anchor))
		
		
		local start_time = worldeditadditions.get_ms_time()
		
		local success, stats = worldeditadditions.scale(
			worldedit.pos1[name],
			worldedit.pos2[name],
			scale, anchor
		)
		if not success then return success, stats end
		
		worldedit.pos1[name] = stats.pos1
		worldedit.pos2[name] = stats.pos2
		worldedit.marker_update(name)
		
		local time_taken = worldeditadditions.get_ms_time() - start_time
		
		
		minetest.log("action", name.." used //scale at "..worldeditadditions.vector.tostring(worldedit.pos1[name]).." - "..worldeditadditions.vector.tostring(worldedit.pos2[name])..", updating "..stats.updated.." nodes in "..time_taken.."s")
		return true, stats.updated.." nodes updated in " .. worldeditadditions.format.human_time(time_taken)
	end
})
