-- ███████ ██      ██      ██ ██████  ███████  ██████  ██ ██████
-- ██      ██      ██      ██ ██   ██ ██      ██    ██ ██ ██   ██
-- █████   ██      ██      ██ ██████  ███████ ██    ██ ██ ██   ██
-- ██      ██      ██      ██ ██           ██ ██    ██ ██ ██   ██
-- ███████ ███████ ███████ ██ ██      ███████  ██████  ██ ██████
local wea = worldeditadditions
local function parse_params_ellipsoid(params_text)
	local parts = wea.split_shell(params_text)
	
	if #parts < 4 then
		return false, "Error: Not enough arguments. Expected \"<rx> <ry> <rz> <replace_node> [h[ollow]]\"."
	end
	
	local radius = minetest.string_to_pos(parts[1].." "..parts[2].." "..parts[3])
	if not radius then
		return false, "Error: 3 radii must be specified."
	end
	wea.vector.abs(radius)
	
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

worldedit.register_command("ellipsoid", {
	params = "<rx> <ry> <rz> <replace_node> [h[ollow]]",
	description = "Creates a 3D ellipsoid with a radius of (rx, ry, rz) at pos1, filled with <replace_node>.",
	privs = { worldedit = true },
	require_pos = 1,
	parse = function(params_text)
		local values = {parse_params_ellipsoid(params_text)}
		return wea.table.unpack(values)
	end,
	nodes_needed = function(name, target_node, radius)
		return math.ceil(4/3 * math.pi * radius.x * radius.y * radius.z)
	end,
	func = function(name, target_node, radius, hollow)
		local start_time = worldeditadditions.get_ms_time()
		local replaced = worldeditadditions.ellipsoid(worldedit.pos1[name], radius, target_node, hollow)
		local time_taken = worldeditadditions.get_ms_time() - start_time
		
		minetest.log("action", name .. " used //ellipsoid at " .. worldeditadditions.vector.tostring(worldedit.pos1[name]) .. ", replacing " .. replaced .. " nodes in " .. time_taken .. "s")
		return true, replaced .. " nodes replaced in " .. worldeditadditions.format.human_time(time_taken)
	end
})

-- TODO: This duplicates a lot of code. Perhaps we can trim it down a bit?
worldedit.register_command("hollowellipsoid", {
	params = "<rx> <ry> <rz> <replace_node>",
	description = "Creates a 3D hollow ellipsoid with a radius of (rx, ry, rz) at pos1, made out of <replace_node>.",
	privs = { worldedit = true },
	require_pos = 1,
	parse = function(params_text)
		local values = {parse_params_ellipsoid(params_text)}
		return wea.table.unpack(values)
	end,
	nodes_needed = function(name, target_node, radius)
		return math.ceil(4/3 * math.pi * radius.x * radius.y * radius.z)
	end,
	func = function(name, target_node, radius)
		local start_time = worldeditadditions.get_ms_time()
		local replaced = worldeditadditions.ellipsoid(worldedit.pos1[name], radius, target_node, true)
		local time_taken = worldeditadditions.get_ms_time() - start_time
		
		minetest.log("action", name .. " used //hollowellipsoid at " .. worldeditadditions.vector.tostring(worldedit.pos1[name]) .. ", replacing " .. replaced .. " nodes in " .. time_taken .. "s")
		return true, replaced .. " nodes replaced in " .. worldeditadditions.format.human_time(time_taken)
	end
})
