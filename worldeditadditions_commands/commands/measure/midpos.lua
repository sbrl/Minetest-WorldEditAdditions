local wea_c = worldeditadditions_core
local Vector3 = wea_c.Vector3


-- ███    ███ ██ ██████  ██████   ██████  ███████
-- ████  ████ ██ ██   ██ ██   ██ ██    ██ ██
-- ██ ████ ██ ██ ██   ██ ██████  ██    ██ ███████
-- ██  ██  ██ ██ ██   ██ ██      ██    ██      ██
-- ██      ██ ██ ██████  ██       ██████  ███████
worldeditadditions_core.register_command("midpos", {
	params = "",
	description = "Return the mid point of current selection.",
	privs = { worldedit = true },
	require_pos = 2,
	parse = function(params_text)
		return true
	end,
	func = function(name, params_text)
		local str = "The centre of the current selection is at "
		
		local pos1 = Vector3.clone(worldedit.pos1[name])
		local pos2 = Vector3.clone(worldedit.pos2[name])
		
		
		local vec = Vector3.mean(pos1, pos2)
		
		return true, str .. wea_c.table.tostring(vec)
	end,
})
