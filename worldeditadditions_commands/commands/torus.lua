-- ████████  ██████  ██████  ██    ██ ███████
--    ██    ██    ██ ██   ██ ██    ██ ██
--    ██    ██    ██ ██████  ██    ██ ███████
--    ██    ██    ██ ██   ██ ██    ██      ██
--    ██     ██████  ██   ██  ██████  ███████
local function parse_params_torus(params_text)
	local parts = worldeditadditions.split_shell(params_text)
	
	if #parts < 1 then
		return false, "Error: No replace_node specified."
	end
	if #parts < 2 then
		return false, "Error: No major radius specified (expected integer greater than 0)."
	end
	if #parts < 3 then
		return false, "Error: No minor radius specified (expected integer greater than 0)."
	end
	
	local major_radius = tonumber(parts[1])
	local minor_radius = tonumber(parts[2])
	local replace_node = worldedit.normalize_nodename(parts[3])
	local axes
	if #parts > 3 then axes = parts[4] end
	if not axes then axes = "xy" end
	
	if major_radius < 1 then
		return false, "Error: The major radius must be greater than 0."
	end
	if minor_radius < 1 then
		return false, "Error: The minor radius must be greater than 0."
	end
	if not replace_node then
		return false, "Error: Invalid node name."
	end
	if axes:find("[^xyz]") then
		return false, "Error: The axes may only contain the letters x, y, and z."
	end
	if #axes > 2 then
		return false, "Error: 2 or less axes must be specified. For example, xy is valid, but xzy is not."
	end
	
	local hollow = false
	if parts[5] == "hollow" or parts[5] == "h" then
		hollow = true
	end
	
	-- Sort the axis names (this is important to ensure we can identify the direction properly)
	if axes == "yx" then axes = "xy" end
	if axes == "zx" then axes = "xz" end
	if axes == "zy" then axes = "yz" end
	
	return true, replace_node, major_radius, minor_radius, axes, hollow
end

worldedit.register_command("torus", {
	params = "<major_radius> <minor_radius> <replace_node> [<axes=xy> [h[ollow]]]",
	description = "Creates a 3D torus with a major radius of <major_radius> and a minor radius of <minor_radius> at pos1, filled with <replace_node>, on axes <axes> (i.e. 2 axis names: xz, zy, etc).",
	privs = { worldedit = true },
	require_pos = 1,
	parse = function(params_text)
		local values = {parse_params_torus(params_text)}
		return worldeditadditions.table.unpack(values)
	end,
	nodes_needed = function(name, target_node, major_radius, minor_radius)
		return math.ceil(2 * math.pi*math.pi * major_radius * minor_radius*minor_radius)
	end,
	func = function(name, target_node, major_radius, minor_radius, axes, hollow)
		local start_time = worldeditadditions.get_ms_time()
		local replaced = worldeditadditions.torus(
			worldedit.pos1[name],
			major_radius, minor_radius,
			target_node,
			axes,
			hollow
		)
		local time_taken = worldeditadditions.get_ms_time() - start_time
		
		minetest.log("action", name .. " used //torus at " .. worldeditadditions.vector.tostring(worldedit.pos1[name]) .. ", replacing " .. replaced .. " nodes in " .. time_taken .. "s")
		return true, replaced .. " nodes replaced in " .. worldeditadditions.format.human_time(time_taken)
	end
})

-- TODO: This duplicates a lot of code. Perhaps we can trim it down a bit?
worldedit.register_command("hollowtorus", {
	params = "<major_radius> <minor_radius> <replace_node> [<axes=xy>]",
	description = "Creates a 3D hollow torus with a major radius of <major_radius> and a minor radius of <minor_radius> at pos1, made out of <replace_node>, on axes <axes> (i.e. 2 axis names: xz, zy, etc).",
	privs = { worldedit = true },
	require_pos = 1,
	parse = function(params_text)
		local values = {parse_params_torus(params_text)}
		return worldeditadditions.table.unpack(values)
	end,
	nodes_needed = function(name, target_node, major_radius, minor_radius)
		return math.ceil(2 * math.pi*math.pi * major_radius * minor_radius*minor_radius)
	end,
	func = function(name, target_node, major_radius, minor_radius, axes)
		local start_time = worldeditadditions.get_ms_time()
		local replaced = worldeditadditions.torus(
			worldedit.pos1[name],
			major_radius, minor_radius,
			target_node,
			axes,
			true -- hollow
		)
		local time_taken = worldeditadditions.get_ms_time() - start_time
		
		minetest.log("action", name .. " used //hollowtorus at " .. worldeditadditions.vector.tostring(worldedit.pos1[name]) .. ", replacing " .. replaced .. " nodes in " .. time_taken .. "s")
		return true, replaced .. " nodes replaced in " .. worldeditadditions.format.human_time(time_taken)
	end
})
