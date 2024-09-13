-- local wea = worldeditadditions
local wea_c = worldeditadditions_core
local Vector3 = wea_c.Vector3


-- ███████ ██████  ███████ ██
-- ██      ██   ██ ██      ██
-- ███████ ██████  █████   ██
--      ██ ██   ██ ██      ██
-- ███████ ██   ██ ███████ ███████


worldeditadditions_core.register_command("srel", {
	params = "[<axis1>] <length1> [[<axis2>] <length2> [...]]",
	description = "Set WorldEdit region position 2 relative to position 1 and player facing.",
	privs = { worldedit = true },
	require_pos = 0,
	parse = function(params_text)
		local ret = wea_c.split(params_text)
		if #ret < 1 then return false, "SREL: No params found!"
		else return true, ret end
	end,
	func = function(name, params_text)
		local facing = wea_c.player_dir(name)
		local vec, err = wea_c.parse.directions(params_text, facing, true)
		if not vec then return false, err end
		
		local pos1 = wea_c.pos.get(name, 1)
		local pos2 = pos1:add(vec)
		
		wea_c.pos.clear(name)
		wea_c.pos.set_all(name, {pos1, pos2})
		return true, "Pos1 set to "..pos1..", Pos2 set to "..pos2
	end,
})

-- Tests
-- //srel front 5 left 3 y 2
