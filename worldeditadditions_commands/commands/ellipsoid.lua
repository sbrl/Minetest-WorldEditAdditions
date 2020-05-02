local we_c = worldeditadditions_commands

-- ███████ ██      ██      ██ ██████  ███████  ██████  ██ ██████
-- ██      ██      ██      ██ ██   ██ ██      ██    ██ ██ ██   ██
-- █████   ██      ██      ██ ██████  ███████ ██    ██ ██ ██   ██
-- ██      ██      ██      ██ ██           ██ ██    ██ ██ ██   ██
-- ███████ ███████ ███████ ██ ██      ███████  ██████  ██ ██████

local function parse_params_ellipsoid(params_text)
	local found, _, radius_x, radius_y, radius_z, replace_node = params_text:find("([0-9]+)%s+([0-9]+)%s+([0-9]+)%s+([a-z:_\\-]+)")
	
	if found == nil then
		return nil, nil
	end
	
	local radius = {
		x = tonumber(radius_x),
		y = tonumber(radius_y),
		z = tonumber(radius_z)
	}
	
	replace_node = worldedit.normalize_nodename(replace_node)
	
	return replace_node, radius
end

minetest.register_chatcommand("/ellipsoid", {
	params = "<rx> <ry> <rz> <replace_node>",
	description = "Creates a 3D ellipsoid with a radius of (rx, ry, rz) at pos1, filled with <replace_node>.",
	privs = { worldedit = true },
	func = we_c.safe_region(function(name, params_text)
		local target_node, radius = parse_params_ellipsoid(params_text)
		
		if not target_node then
			worldedit.player_notify(name, "Error: Invalid node name.")
			return false
		end
		if not radius then
			worldedit.player_notify(name, "Error: Invalid radius(es).")
			return false
		end
		
		local start_time = os.clock()
		local replaced = worldedit.ellipsoid(worldedit.pos1[name], radius, target_node, false)
		local time_taken = os.clock() - start_time
		
		worldedit.player_notify(name, replaced .. " nodes replaced in " .. time_taken .. "s")
		minetest.log("action", name .. " used //ellipsoid at " .. worldeditadditions.vector.tostring(worldedit.pos1[name]) .. ", replacing " .. replaced .. " nodes in " .. time_taken .. "s")
	end, function(name, params_text)
		local target_node, radius = parse_params_ellipsoid(params_text)
		if not target_node or not radius then
			worldedit.player_notify(name, "Error: Invalid input '" .. params_text .. "'. Try '/help /ellipsoid' to learn how to use this command.")
			return 0
		end
		
		return math.ceil(4/3 * math.pi * radius.x * radius.y * radius.z)
	end)
})

-- TODO: This duplicates a lot of code. Perhaps we can trim it down a bit?
minetest.register_chatcommand("/hollowellipsoid", {
	params = "<rx> <ry> <rz> <replace_node>",
	description = "Creates a 3D hollow ellipsoid with a radius of (rx, ry, rz) at pos1, made out of <replace_node>.",
	privs = { worldedit = true },
	func = we_c.safe_region(function(name, params_text)
		local target_node, radius = parse_params_ellipsoid(params_text)
		
		if not target_node then
			worldedit.player_notify(name, "Error: Invalid node name.")
			return false
		end
		if not radius then
			worldedit.player_notify(name, "Error: Invalid radius(es).")
			return false
		end
		
		local start_time = os.clock()
		local replaced = worldedit.ellipsoid(worldedit.pos1[name], radius, target_node, true)
		local time_taken = os.clock() - start_time
		
		worldedit.player_notify(name, replaced .. " nodes replaced in " .. time_taken .. "s")
		minetest.log("action", name .. " used //hollowellipsoid at " .. worldeditadditions.vector.tostring(worldedit.pos1[name]) .. ", replacing " .. replaced .. " nodes in " .. time_taken .. "s")
	end, function(name, params_text)
		local target_node, radius = parse_params_ellipsoid(params_text)
		if not target_node or not radius then
			worldedit.player_notify(name, "Error: Invalid input '" .. params_text .. "'. Try '/help /hollowellipsoid' to learn how to use this command.")
			return 0
		end
		
		return math.ceil(4/3 * math.pi * radius.x * radius.y * radius.z)
	end)
})
