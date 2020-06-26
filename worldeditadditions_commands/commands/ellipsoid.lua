-- ███████ ██      ██      ██ ██████  ███████  ██████  ██ ██████
-- ██      ██      ██      ██ ██   ██ ██      ██    ██ ██ ██   ██
-- █████   ██      ██      ██ ██████  ███████ ██    ██ ██ ██   ██
-- ██      ██      ██      ██ ██           ██ ██    ██ ██ ██   ██
-- ███████ ███████ ███████ ██ ██      ███████  ██████  ██ ██████

local function parse_params_ellipsoid(params_text)
	local found, _, radius_x, radius_y, radius_z, replace_node = params_text:find("([0-9]+)%s+([0-9]+)%s+([0-9]+)%s+([a-z:_\\-]+)")
	
	if found == nil then
		return false, "Invalid syntax"
	end
	
	local radius = {
		x = tonumber(radius_x),
		y = tonumber(radius_y),
		z = tonumber(radius_z)
	}
	
	replace_node = worldedit.normalize_nodename(replace_node)
	if not replace_node then
		worldedit.player_notify(name, "Error: Invalid node name.")
		return false
	end
	if not radius.x or not radius.y or not radius.z then
		worldedit.player_notify(name, "Error: Invalid radius(es).")
		return false
	end
	
	return true, replace_node, radius
end

worldedit.register_command("ellipsoid", {
	params = "<rx> <ry> <rz> <replace_node>",
	description = "Creates a 3D ellipsoid with a radius of (rx, ry, rz) at pos1, filled with <replace_node>.",
	privs = { worldedit = true },
	require_pos = 1,
	parse = function(params_text)
		local values = {parse_params_ellipsoid(params_text)}
		return unpack(values)
	end,
	nodes_needed = function(name, target_node, radius)
		return math.ceil(4/3 * math.pi * radius.x * radius.y * radius.z)
	end,
	func = function(name, target_node, radius)
		local start_time = worldeditadditions.get_ms_time()
		local replaced = worldeditadditions.ellipsoid(worldedit.pos1[name], radius, target_node, false)
		local time_taken = worldeditadditions.get_ms_time() - start_time
		
		minetest.log("action", name .. " used //ellipsoid at " .. worldeditadditions.vector.tostring(worldedit.pos1[name]) .. ", replacing " .. replaced .. " nodes in " .. time_taken .. "s")
		return true, replaced .. " nodes replaced in " .. time_taken .. "s"
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
		return unpack(values)
	end,
	nodes_needed = function(name, target_node, radius)
		return math.ceil(4/3 * math.pi * radius.x * radius.y * radius.z)
	end,
	func = function(name, target_node, radius)
		local start_time = worldeditadditions.get_ms_time()
		local replaced = worldeditadditions.ellipsoid(worldedit.pos1[name], radius, target_node, true)
		local time_taken = worldeditadditions.get_ms_time() - start_time
		
		minetest.log("action", name .. " used //hollowellipsoid at " .. worldeditadditions.vector.tostring(worldedit.pos1[name]) .. ", replacing " .. replaced .. " nodes in " .. time_taken .. "s")
		return true, replaced .. " nodes replaced in " .. time_taken .. "s"
	end
})
