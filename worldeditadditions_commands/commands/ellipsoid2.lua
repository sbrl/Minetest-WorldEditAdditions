-- ███████ ██      ██      ██ ██████  ███████  ██████  ██ ██████
-- ██      ██      ██      ██ ██   ██ ██      ██    ██ ██ ██   ██
-- █████   ██      ██      ██ ██████  ███████ ██    ██ ██ ██   ██
-- ██      ██      ██      ██ ██           ██ ██    ██ ██ ██   ██
-- ███████ ███████ ███████ ██ ██      ███████  ██████  ██ ██████
local wea = worldeditadditions

worldedit.register_command("ellipsoid2", {
	params = "[<replace_node:dirt> [h[ollow]]]",
	description = "Creates am optionally hollow 3D ellipsoid that fills the defined region, filled with <replace_node>.",
	privs = { worldedit = true },
	require_pos = 2,
	parse = function(params_text)
		if not params_text or params_text == "" then
			params_text = "dirt"
		end
		
		local parts = wea.split_shell(params_text)
		
		
		local replace_node = worldedit.normalize_nodename(parts[1])
		if not replace_node then
			return false, "Error: Invalid replace_node specified."
		end
		
		local hollow = false
		if parts[2] == "hollow" or parts[2] == "h" then
			hollow = true
		end
		
		return true, replace_node, hollow
	end,
	nodes_needed = function(name, target_node)
		local pos1, pos2 = worldedit.sort_pos(worldedit.pos1[name], worldedit.pos2[name])
		return math.ceil(4/3 * math.pi * (pos2.x - pos1.x)/2 * (pos2.y - pos1.y)/2 * (pos2.z - pos1.z)/2)
	end,
	func = function(name, target_node, radius, hollow)
		local start_time = wea.get_ms_time()
		local pos1, pos2 = wea.Vector3.sort(worldedit.pos1[name], worldedit.pos2[name])
		
		local replaced = wea.ellipsoid2(
			pos1, pos2,
			target_node,
			hollow
		)
		local time_taken = wea.get_ms_time() - start_time
		
		minetest.log("action", name .. " used //ellipsoid2 at "..pos1.." - "..pos2..", replacing " .. replaced .. " nodes in " .. time_taken .. "s")
		return true, replaced .. " nodes replaced in " .. wea.format.human_time(time_taken)
	end
})
