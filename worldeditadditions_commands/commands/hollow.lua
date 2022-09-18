local wea_c = worldeditadditions_core
local Vector3 = wea_c.Vector3

-- ██   ██  ██████  ██      ██       ██████  ██     ██
-- ██   ██ ██    ██ ██      ██      ██    ██ ██     ██
-- ███████ ██    ██ ██      ██      ██    ██ ██  █  ██
-- ██   ██ ██    ██ ██      ██      ██    ██ ██ ███ ██
-- ██   ██  ██████  ███████ ███████  ██████   ███ ███
worldeditadditions_core.register_command("hollow", {
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
		local pos1, pos2 = Vector3.sort(worldedit.pos1[name], worldedit.pos2[name])
		return worldedit.volume(
			{
				x = pos2.x - wall_thickness,
				y = pos2.y - wall_thickness,
				z = pos2.z - wall_thickness
			},
			{
				x = pos1.x + wall_thickness,
				y = pos1.y + wall_thickness,
				z = pos1.z + wall_thickness
			}
		)
	end,
	func = function(name, wall_thickness)
		local start_time = wea_c.get_ms_time()
		local pos1, pos2 = Vector3.sort(worldedit.pos1[name], worldedit.pos2[name])

		local success, changes = worldeditadditions.hollow(
			pos1, pos2,
			wall_thickness
		)
		local time_taken = wea_c.get_ms_time() - start_time
		
		if not success then return success, changes end
		
		minetest.log("action", name .. " used //hollow at "..pos1.." - "..pos2..", replacing " .. changes.replaced .. " nodes in " .. time_taken .. "s")
		return true, changes.replaced .. " nodes replaced in " .. wea_c.format.human_time(time_taken)
	end
})
