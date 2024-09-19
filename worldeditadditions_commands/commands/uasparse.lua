local wea_c = worldeditadditions_core
-- local Vector3 = wea_c.Vector3

-- ██    ██   █████   ███████  ██████    █████   ██████   ███████  ███████ 
-- ██    ██  ██   ██  ██       ██   ██  ██   ██  ██   ██  ██       ██      
-- ██    ██  ███████  ███████  ██████   ███████  ██████   ███████  █████   
-- ██    ██  ██   ██       ██  ██       ██   ██  ██   ██       ██  ██      
--  ██████   ██   ██  ███████  ██       ██   ██  ██   ██  ███████  ███████ 

worldeditadditions_core.register_command("uasparse", {
	params = "<unified axis syntax>",
	description = "Returns min and max vectors for given inputs",
	privs = { worldedit = true },
	-- require_pos = 2,
	parse = function(params_text)
		local ret = wea_c.split(params_text)
		if #ret < 1 then return false, "UASPARSE: No params found!"
		else return true, ret end
	end,
	func = function(name, params_text)
		local facing = wea_c.player_dir(name)
		local min, max = wea_c.parse.directions(params_text, facing)
		if not min then
			return false, max
		else
			return true, "Min: "..min.." Max: "..max 
		end
	end
})
