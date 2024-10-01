local wea_c = worldeditadditions_core
local Vector3 = worldeditadditions.Vector3

-- ███████ ███████ ██   ██ ██ ███████ ████████
-- ██      ██      ██   ██ ██ ██         ██
-- ███████ ███████ ███████ ██ █████      ██
--      ██      ██ ██   ██ ██ ██         ██
-- ███████ ███████ ██   ██ ██ ██         ██

worldeditadditions_core.register_command("sshift", {
	params = "<unified axis syntax>",
	description = "Shift the WorldEdit region in 3 dimensions.",
	privs = { worldedit = true },
	require_pos = 2,
	parse = function(params_text)
		local ret = wea_c.split(params_text)
		if #ret < 1 then return false, "Error: No params found!"
		else return true, ret end
	end,
	func = function(name, params_text)
		local facing = wea_c.player_dir(name)
		local vec, err = wea_c.parse.directions(params_text, facing, true)
		if not vec then return false, err end
		
		local pos1 = vec:add(wea_c.pos.get(name, 1))
		local pos2 = vec:add(wea_c.pos.get(name, 2))
		
		wea_c.pos.set_all(name, {pos1, pos2})
		return true, "Position 1 to "..pos1..", Position 2 to "..pos2
	end,
})

-- Tests
-- //srel front 5 left 3 y 2
