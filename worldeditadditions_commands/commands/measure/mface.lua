-- ███    ███ ███████  █████   ██████ ███████
-- ████  ████ ██      ██   ██ ██      ██
-- ██ ████ ██ █████   ███████ ██      █████
-- ██  ██  ██ ██      ██   ██ ██      ██
-- ██      ██ ██      ██   ██  ██████ ███████
local wea = worldeditadditions
worldedit.register_command("mface", {
	params = "",
	description = "Return player facing axis.",
	privs = { worldedit = true },
	require_pos = 0,
	parse = function(params_text)
		return true
	end,
	func = function(name, params_text)
		local str = "You are facing "
		local dir = minetest.get_player_by_name(name):get_look_dir()
		
		if math.abs(dir.z) > math.abs(dir.x) then
			if dir.z < 0 then str = str.."-Z"
			else str = str.."Z" end
			if math.abs(dir.x) >= 0.35 then -- Alternate value: 1/3
				if dir.x < 0 then str = str.."-X"
				else str = str.."X" end
			end
		else
			if dir.x < 0 then str = str.."-X"
			else str = str.."X" end
			if math.abs(dir.z) >= 0.35 then -- Alternate value: 1/3
				if dir.z < 0 then str = str.."-Z"
				else str = str.."Z" end
			end
		end
		
		return true, str
	end,
})
