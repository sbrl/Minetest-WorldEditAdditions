local wea_c = worldeditadditions_core
local Vector3 = wea_c.Vector3

-- ███████ ██       ██████   ██████  ██████  ███████ ██ ██      ██
-- ██      ██      ██    ██ ██    ██ ██   ██ ██      ██ ██      ██
-- █████   ██      ██    ██ ██    ██ ██   ██ █████   ██ ██      ██
-- ██      ██      ██    ██ ██    ██ ██   ██ ██      ██ ██      ██
-- ██      ███████  ██████   ██████  ██████  ██      ██ ███████ ███████
worldeditadditions_core.register_command("floodfill", {
	params = "[<replace_node> [<radius>]]",
	description = "Floods all connected nodes of the same type starting at pos1 with <replace_node> (which defaults to `water_source`), in a sphere with a radius of <radius> (which defaults to 20).",
	privs = { worldedit = true },
	require_pos = 1,
	parse = function(params_text)
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
		
		if not replace_node then
			return false, "Error: Invalid node name."
		end
		
		return true, replace_node, radius
	end,
	nodes_needed = function(name, replace_node, radius)
		-- Volume of a hemisphere
		return math.ceil(((4 * math.pi * (tonumber(radius) ^ 3)) / 3) / 2)
	end,
	func = function(name, replace_node, radius)
		local start_time = wea_c.get_ms_time()
		local pos1 = Vector3.clone(worldedit.pos1[name])
		local nodes_replaced = worldeditadditions.floodfill(
			pos1,
			radius,
			replace_node
		)
		local time_taken = wea_c.get_ms_time() - start_time
		
		if nodes_replaced == false then
			return false, "Error: The search node is the same as the replace node."
		end
		
		minetest.log("action", name.." used //floodfill at "..pos1..", replacing " .. nodes_replaced.." nodes in "..time_taken.."s")
		return true, nodes_replaced.." nodes replaced in "..wea_c.format.human_time(time_taken)
	end
})
