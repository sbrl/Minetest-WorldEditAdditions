local wea_c = worldeditadditions_core
local Vector3 = wea_c.Vector3

-- ██      ██ ███    ██ ███████
-- ██      ██ ████   ██ ██
-- ██      ██ ██ ██  ██ █████
-- ██      ██ ██  ██ ██ ██
-- ███████ ██ ██   ████ ███████
worldeditadditions_core.register_command("line", {
	params = "[<replace_node> [<radius>]]",
	description = "Draws a line of a given radius (default: 1) from pos1 to pos2 in the given node (default: dirt).",
	privs = { worldedit = true },
	require_pos = 1,
	parse = function(params_text)
		if not params_text then params_text = "" end
		local found, _, replace_node, radius = params_text:find("([a-z:_\\-]+)%s+([0-9.]+)")
		
		if found == nil then
			found, _, replace_node = params_text:find("([a-z:_\\-]+)")
			radius = 1
		end
		if found == nil then
			replace_node = "default:dirt"
		end
		radius = tonumber(radius)
		
		replace_node = worldedit.normalize_nodename(replace_node)
		
		if not replace_node then
			return false, "Error: Invalid node name '"..replace_node.."'."
		end
		
		return true, replace_node, radius
	end,
	nodes_needed = function(name, replace_node, radius)
		-- Volume of a hemisphere
		return math.ceil(math.pi
			* radius * radius
			* (Vector3.clone(worldedit.pos2[name]) - Vector3.clone(worldedit.pos1[name])):length()
			) -- Volume of a cylinder
	end,
	func = function(name, replace_node, radius)
		local start_time = wea_c.get_ms_time()
		-- Can't  sort here because the start & ending points matter
		local pos1 = Vector3.clone(worldedit.pos1[name])
		local pos2 = Vector3.clone(worldedit.pos2[name])
		
		local success, stats = worldeditadditions.line(
			pos1, pos2,
			radius,
			replace_node
		)
		local time_taken = wea_c.get_ms_time() - start_time
		
		if success == false then return false, stats end
		
		minetest.log("action", name.." used //line from "..pos1.." to "..pos2..", replacing "..stats.replaced.." nodes in "..time_taken.."s")
		return true, stats.replaced.." nodes replaced in "..wea_c.format.human_time(time_taken)
	end
})
