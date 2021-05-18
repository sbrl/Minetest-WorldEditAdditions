-- ████████  ██████  ██████  ██    ██ ███████
--    ██    ██    ██ ██   ██ ██    ██ ██
--    ██    ██    ██ ██████  ██    ██ ███████
--    ██    ██    ██ ██   ██ ██    ██      ██
--    ██     ██████  ██   ██  ██████  ███████
local function parse_params_torus(params_text)
	local found, _, major_radius, minor_radius, replace_node = params_text:find("([0-9]+)%s+([0-9]+)%s+([a-z:_\\-]+)")
	
	if found == nil then
		return nil, nil
	end
	
	major_radius = tonumber(major_radius)
	minor_radius = tonumber(minor_radius)
	
	replace_node = worldedit.normalize_nodename(replace_node)
	
	if not replace_node then
		return false, "Error: Invalid replace_node."
	end
	if not major_radius or major_radius < 1 then
		return false, "Error: Invalid major radius (expected integer greater than 0)"
	end
	if #axes > 2 then
		return false, "Error: 2 or less axes must be specified. For example, xy is valid, but xzy is not."
	end
	
	local hollow = parts[5]
	if hollow == "false" then hollow = false end
	
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
		return unpack(values)
	end,
	nodes_needed = function(name, target_node, major_radius, minor_radius)
		return math.ceil(2 * math.pi*math.pi * major_radius * minor_radius*minor_radius)
	end,
	func = function(name, target_node, major_radius, minor_radius, axes, hollow)
		local start_time = worldeditadditions.get_ms_time()
		local replaced = worldeditadditions.torus(worldedit.pos1[name], major_radius, minor_radius, target_node, axes, hollow)
		local time_taken = worldeditadditions.get_ms_time() - start_time
		
		minetest.log("action", name .. " used //torus at " .. worldeditadditions.vector.tostring(worldedit.pos1[name]) .. ", replacing " .. replaced .. " nodes in " .. time_taken .. "s")
		return true, replaced .. " nodes replaced in " .. worldeditadditions.format.human_time(time_taken)
	end
})

-- TODO: This duplicates a lot of code. Perhaps we can trim it down a bit?
worldedit.register_command("hollowtorus", {
	params = "<major_radius> <minor_radius> <replace_node>",
	description = "Creates a 3D hollow torus with a major radius of <major_radius> and a minor radius of <minor_radius> at pos1, made out of <replace_node>.",
	privs = { worldedit = true },
	require_pos = 1,
	parse = function(params_text)
		local values = {parse_params_torus(params_text)}
		return unpack(values)
	end,
	nodes_needed = function(name, target_node, major_radius, minor_radius)
		return math.ceil(2 * math.pi*math.pi * major_radius * minor_radius*minor_radius)
	end,
	func = function(name, target_node, major_radius, minor_radius)
		local start_time = worldeditadditions.get_ms_time()
		local replaced = worldeditadditions.torus(worldedit.pos1[name], major_radius, minor_radius, target_node, true)
		local time_taken = worldeditadditions.get_ms_time() - start_time
		
		minetest.log("action", name .. " used //hollowtorus at " .. worldeditadditions.vector.tostring(worldedit.pos1[name]) .. ", replacing " .. replaced .. " nodes in " .. time_taken .. "s")
		return true, replaced .. " nodes replaced in " .. worldeditadditions.format.human_time(time_taken)
	end
})
