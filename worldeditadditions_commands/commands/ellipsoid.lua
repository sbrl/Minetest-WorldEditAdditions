-- ███████ ██      ██      ██ ██████  ███████  ██████  ██ ██████
-- ██      ██      ██      ██ ██   ██ ██      ██    ██ ██ ██   ██
-- █████   ██      ██      ██ ██████  ███████ ██    ██ ██ ██   ██
-- ██      ██      ██      ██ ██           ██ ██    ██ ██ ██   ██
-- ███████ ███████ ███████ ██ ██      ███████  ██████  ██ ██████
local wea_c = worldeditadditions_core
local Vector3 = wea_c.Vector3

local function parse_params_ellipsoid(params_text)
	local parts = wea_c.split_shell(params_text)
	
	if #parts < 4 then
		return false, "Error: Not enough arguments. Expected \"<rx> <ry> <rz> <replace_node> [h[ollow]]\"."
	end
	
	local radius = minetest.string_to_pos(parts[1].." "..parts[2].." "..parts[3])
	if not radius then
		return false, "Error: 3 radii must be specified."
	end
	radius = Vector3.clone(radius):abs()
	
	local replace_node = worldedit.normalize_nodename(parts[4])
	if not replace_node then
		return false, "Error: Invalid replace_node specified."
	end
	
	local hollow = false
	if parts[5] == "hollow" or parts[5] == "h" then
		hollow = true
	end
	
	return true, replace_node, radius, hollow
end

worldeditadditions_core.register_command("ellipsoid", {
	params = "<rx> <ry> <rz> <replace_node> [h[ollow]]",
	description = "Creates a 3D ellipsoid with a radius of (rx, ry, rz) at pos1, filled with <replace_node>.",
	privs = { worldedit = true },
	require_pos = 1,
	parse = function(params_text)
		local values = {parse_params_ellipsoid(params_text)}
		return wea_c.table.unpack(values)
	end,
	nodes_needed = function(name, target_node, radius)
		return math.ceil(4/3 * math.pi * radius.x * radius.y * radius.z)
	end,
	func = function(name, target_node, radius, hollow)
		local start_time = wea_c.get_ms_time()
		local pos1 = Vector3.clone(worldedit.pos1[name])
		local replaced = worldeditadditions.ellipsoid(pos1, radius, target_node, hollow)
		local time_taken = wea_c.get_ms_time() - start_time
		
		minetest.log("action", name.." used //ellipsoid at "..pos1..", replacing " .. replaced .. " nodes in " .. time_taken .. "s")
		return true, replaced .. " nodes replaced in " .. wea_c.format.human_time(time_taken)
	end
})

-- TODO: This duplicates a lot of code. Perhaps we can trim it down a bit?
worldeditadditions_core.register_command("hollowellipsoid", {
	params = "<rx> <ry> <rz> <replace_node>",
	description = "Creates a 3D hollow ellipsoid with a radius of (rx, ry, rz) at pos1, made out of <replace_node>.",
	privs = { worldedit = true },
	require_pos = 1,
	parse = function(params_text)
		local values = {parse_params_ellipsoid(params_text)}
		return wea_c.table.unpack(values)
	end,
	nodes_needed = function(name, target_node, radius)
		return math.ceil(4/3 * math.pi * radius.x * radius.y * radius.z)
	end,
	func = function(name, target_node, radius)
		local start_time = wea_c.get_ms_time()
		local pos1 = Vector3.clone(worldedit.pos1[name])
		local replaced = worldeditadditions.ellipsoid(pos1, radius, target_node, true)
		local time_taken = wea_c.get_ms_time() - start_time
		
		minetest.log("action", name.." used //hollowellipsoid at "..pos1..", replacing " .. replaced .. " nodes in " .. time_taken .. "s")
		return true, replaced .. " nodes replaced in " .. wea_c.format.human_time(time_taken)
	end
})
