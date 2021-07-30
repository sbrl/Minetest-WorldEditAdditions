-- ██      ██ ███    ██ ███████
-- ██      ██ ████   ██ ██
-- ██      ██ ██ ██  ██ █████
-- ██      ██ ██  ██ ██ ██
-- ███████ ██ ██   ████ ███████
worldedit.register_command("line", {
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
			* vector.distance(
				vector.new(worldedit.pos1[name]),
				vector.new(worldedit.pos2[name])
			)) -- Volume of a cylinder
	end,
	func = function(name, replace_node, radius)
		local start_time = worldeditadditions.get_ms_time()
		local success, stats = worldeditadditions.line(worldedit.pos1[name], worldedit.pos2[name], radius, replace_node)
		local time_taken = worldeditadditions.get_ms_time() - start_time
		
		if success == false then return false, stats end
		
		minetest.log("action", name .. " used //line at " .. worldeditadditions.vector.tostring(worldedit.pos1[name]) .. ", replacing " .. stats.replaced .. " nodes in " .. time_taken .. "s")
		return true, stats.replaced .. " nodes replaced in " .. worldeditadditions.format.human_time(time_taken)
	end
})
