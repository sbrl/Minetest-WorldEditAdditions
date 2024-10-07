-- local wea = worldeditadditions
local wea_c = worldeditadditions_core
local Vector3 = wea_c.Vector3


-- ███████  ███████  ██   ██  ██████   ██  ███    ██  ██   ██ 
-- ██       ██       ██   ██  ██   ██  ██  ████   ██  ██  ██  
-- ███████  ███████  ███████  ██████   ██  ██ ██  ██  █████   
--      ██       ██  ██   ██  ██   ██  ██  ██  ██ ██  ██  ██  
-- ███████  ███████  ██   ██  ██   ██  ██  ██   ████  ██   ██ 


worldeditadditions_core.register_command("sshrink", {
	params = "<unified axis syntax>",
	description = "Shrink selection region",
	privs = { worldedit = true },
	require_pos = 0,
	parse = function(params_text)
		local ret = wea_c.split(params_text)
		if #ret < 1 then return false, "Error: No params found!"
		else return true, ret end
	end,
	func = function(name, params_text)
		local facing = wea_c.player_dir(name)
		local min, max = wea_c.parse.directions(params_text, facing)
		if not min then return false, max end
		
		local pos1 = wea_c.pos.get(name, 1)
		local pos2 = wea_c.pos.get(name, 2)
		
		if not pos2 then wea_c.pos.set(name, 2, pos1)
		else pos1, pos2 = Vector3.sort(pos1, pos2) end
		
		pos1, pos2 = pos1:add(max), pos2:add(min)
		
		wea_c.pos.set_all(name, {pos1, pos2})
		return true, "Position 1 to "..pos1..", Position 2 to "..pos2
	end,
})

-- Tests
-- //srel front 5 left 3 y 2
