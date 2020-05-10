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
	if not minor_radius or minor_radius < 1 then
		return false, "Error: Invalid minor radius (expected integer greater than 0)"
	end
	
	return true, replace_node, major_radius, minor_radius
end

worldedit.register_command("torus", {
	params = "<major_radius> <minor_radius> <replace_node>",
	description = "Creates a 3D torus with a major radius of <major_radius> and a minor radius of <minor_radius> at pos1, filled with <replace_node>.",
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
		local start_time = os.clock()
		local replaced = worldeditadditions.torus(worldedit.pos1[name], major_radius, minor_radius, target_node, false)
		local time_taken = os.clock() - start_time
		
		minetest.log("action", name .. " used //torus at " .. worldeditadditions.vector.tostring(worldedit.pos1[name]) .. ", replacing " .. replaced .. " nodes in " .. time_taken .. "s")
		return true, replaced .. " nodes replaced in " .. time_taken .. "s"
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
		local start_time = os.clock()
		local replaced = worldeditadditions.torus(worldedit.pos1[name], major_radius, minor_radius, target_node, true)
		local time_taken = os.clock() - start_time
		
		minetest.log("action", name .. " used //hollowtorus at " .. worldeditadditions.vector.tostring(worldedit.pos1[name]) .. ", replacing " .. replaced .. " nodes in " .. time_taken .. "s")
		return true, replaced .. " nodes replaced in " .. time_taken .. "s"
	end
})
