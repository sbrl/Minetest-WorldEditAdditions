local we_c = worldeditadditions_commands

-- ███████ ██       ██████   ██████  ██████  ███████ ██ ██      ██
-- ██      ██      ██    ██ ██    ██ ██   ██ ██      ██ ██      ██
-- █████   ██      ██    ██ ██    ██ ██   ██ █████   ██ ██      ██
-- ██      ██      ██    ██ ██    ██ ██   ██ ██      ██ ██      ██
-- ██      ███████  ██████   ██████  ██████  ██      ██ ███████ ███████

local function parse_params_floodfill(params_text)
	if not params_text then params_text = "" end
	local found, _, replace_node, radius = params_text:find("([a-z:_\\-]+)%s+([0-9]+)")
	
	if found == nil then
		found, _, replace_node = params_text:find("([a-z:_\\-]+)")
		radius = 20
	end
	if found == nil then
		replace_node = "default:water_source"
	end
	radius = tonumber(radius)
	
	replace_node = worldedit.normalize_nodename(replace_node)
	
	return replace_node, radius
end

minetest.register_chatcommand("/floodfill", {
	params = "[<replace_node> [<radius>]]",
	description = "Floods all connected nodes of the same type starting at pos1 with <replace_node> (which defaults to `water_source`), in a sphere with a radius of <radius> (which defaults to 20).",
	privs = { worldedit = true },
	func = we_c.safe_region(function(name, params_text)
		local replace_node, radius = parse_params_floodfill(params_text)
		
		if not replace_node then
			worldedit.player_notify(name, "Error: Invalid node name.")
			return false
		end
		
		if not worldedit.pos1[name] then
			worldedit.player_notify(name, "Error: No pos1 defined.")
			return false
		end
		
		local start_time = os.clock()
		local nodes_replaced = worldedit.floodfill(worldedit.pos1[name], radius, replace_node)
		local time_taken = os.clock() - start_time
		
		if nodes_replaced == false then
			worldedit.player_notify(name, "Error: The search node is the same as the replace node.")
			return false
		end
		
		worldedit.player_notify(name, nodes_replaced .. " nodes replaced in " .. time_taken .. "s")
		minetest.log("action", name .. " used //floodfill at " .. worldeditadditions.vector.tostring(worldedit.pos1[name]) .. ", replacing " .. nodes_replaced .. " nodes in " .. time_taken .. "s")
	end, function(name, params_text)
		local replace_node, radius = parse_params_floodfill(params_text)
		
		if not worldedit.pos1[name] then
			return 0 -- The actual command will send the error message to the client
		end
		-- Volume of a hemisphere
		return math.ceil(((4 * math.pi * (tonumber(radius) ^ 3)) / 3) / 2)
	end)
})
