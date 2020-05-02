local we_c = worldeditadditions_commands

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
	
	return replace_node, major_radius, minor_radius
end

minetest.register_chatcommand("/torus", {
	params = "<major_radius> <minor_radius> <replace_node>",
	description = "Creates a 3D torus with a major radius of <major_radius> and a minor radius of <minor_radius> at pos1, filled with <replace_node>.",
	privs = { worldedit = true },
	func = we_c.safe_region(function(name, params_text)
		local target_node, major_radius, minor_radius = parse_params_torus(params_text)
		
		if not target_node then
			worldedit.player_notify(name, "Error: Invalid node name.")
			return false
		end
		if not major_radius or not minor_radius then
			worldedit.player_notify(name, "Error: Invalid radius(es).")
			return false
		end
		
		if not worldedit.pos1[name] then
			worldedit.player_notify(name, "Error: No pos1 specified (try //1 or left click with the wand tool)")
		end
		
		local start_time = os.clock()
		local replaced = worldedit.torus(worldedit.pos1[name], major_radius, minor_radius, target_node, false)
		local time_taken = os.clock() - start_time
		
		worldedit.player_notify(name, replaced .. " nodes replaced in " .. time_taken .. "s")
		minetest.log("action", name .. " used //torus at " .. worldeditadditions.vector.tostring(worldedit.pos1[name]) .. ", replacing " .. replaced .. " nodes in " .. time_taken .. "s")
	end, function(name, params_text)
		local target_node, major_radius, minor_radius = parse_params_torus(params_text)
		if not target_node or not major_radius or not minor_radius then
			worldedit.player_notify(name, "Error: Invalid input '" .. params_text .. "'. Try '/help /torus' to learn how to use this command.")
			return 0
		end
		
		return math.ceil(2 * math.pi*math.pi * major_radius * minor_radius*minor_radius)
	end)
})

-- TODO: This duplicates a lot of code. Perhaps we can trim it down a bit?
minetest.register_chatcommand("/hollowtorus", {
	params = "<major_radius> <minor_radius> <replace_node>",
	description = "Creates a 3D hollow torus with a major radius of <major_radius> and a minor radius of <minor_radius> at pos1, made out of <replace_node>.",
	privs = { worldedit = true },
	func = we_c.safe_region(function(name, params_text)
		local target_node, major_radius, minor_radius = parse_params_torus(params_text)
		
		if not target_node then
			worldedit.player_notify(name, "Error: Invalid node name.")
			return false
		end
		if not major_radius or not minor_radius then
			worldedit.player_notify(name, "Error: Invalid radius(es).")
			return false
		end
		
		local start_time = os.clock()
		local replaced = worldedit.torus(worldedit.pos1[name], major_radius, minor_radius, target_node, true)
		local time_taken = os.clock() - start_time
		
		worldedit.player_notify(name, replaced .. " nodes replaced in " .. time_taken .. "s")
		minetest.log("action", name .. " used //hollowtorus at " .. worldeditadditions.vector.tostring(worldedit.pos1[name]) .. ", replacing " .. replaced .. " nodes in " .. time_taken .. "s")
	end, function(name, params_text)
		local target_node, major_radius, minor_radius = parse_params_torus(params_text)
		if not target_node or not major_radius or not minor_radius then
			worldedit.player_notify(name, "Error: Invalid input '" .. params_text .. "'. Try '/help /hollowtorus' to learn how to use this command.")
			return 0
		end
		
		return math.ceil(2 * math.pi*math.pi * major_radius * minor_radius*minor_radius)
	end)
})
