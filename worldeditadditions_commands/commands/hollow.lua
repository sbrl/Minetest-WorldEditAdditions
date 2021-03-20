-- ██   ██  ██████  ██      ██       ██████  ██     ██
-- ██   ██ ██    ██ ██      ██      ██    ██ ██     ██
-- ███████ ██    ██ ██      ██      ██    ██ ██  █  ██
-- ██   ██ ██    ██ ██      ██      ██    ██ ██ ███ ██
-- ██   ██  ██████  ███████ ███████  ██████   ███ ███
worldedit.register_command("hollow", {
	params = "[<wall_thickness>]",
	description = "Replaces nodes inside the defined region with air, but leaving a given number of nodes near the outermost edges alone. In other words, it makes the defined region hollow leaving walls of a given thickness (default: 1)",
	privs = { worldedit = true },
	require_pos = 2,
	parse = function(params_text)
		if not params_text or #params_text == 0 then params_text = "1" end
		
		local wall_thickness = tonumber(params_text)
		
		if not wall_thickness then
			return false, "Error: Unrecognised number '"..params_text.."'."
		end
		
		return true, wall_thickness
	end,
	nodes_needed = function(name, wall_thickness)
		-- //overlay only modifies up to 1 node per column in the selected region
		local pos1, pos2 = worldedit.sort_pos(worldedit.pos1[name], worldedit.pos2[name])
		return worldedit.volume(
			{
				x = pos2.x - wall_thickness,
				y = pos2.y - wall_thickness,
				z = pos2.z - wall_thickness
			},
			{
				x = pos2.x + wall_thickness,
				y = pos2.y + wall_thickness,
				z = pos2.z + wall_thickness
			}
		)
	end,
	func = function(name, wall_thickness)
		local start_time = worldeditadditions.get_ms_time()
		local success, changes = worldeditadditions.hollow(worldedit.pos1[name], worldedit.pos2[name], wall_thickness)
		local time_taken = worldeditadditions.get_ms_time() - start_time
		
		if not success then return success, changes end
		
		minetest.log("action", name .. " used //hollow at " .. worldeditadditions.vector.tostring(worldedit.pos1[name]) .. ", replacing " .. changes.replaced .. " nodes in " .. time_taken .. "s")
		return true, changes.replaced .. " nodes replaced in " .. worldeditadditions.format.human_time(time_taken)
	end
})
