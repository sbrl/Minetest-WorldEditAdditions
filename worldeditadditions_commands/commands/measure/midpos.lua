-- ███    ███ ██ ██████  ██████   ██████  ███████
-- ████  ████ ██ ██   ██ ██   ██ ██    ██ ██
-- ██ ████ ██ ██ ██   ██ ██████  ██    ██ ███████
-- ██  ██  ██ ██ ██   ██ ██      ██    ██      ██
-- ██      ██ ██ ██████  ██       ██████  ███████
local wea = worldeditadditions
worldedit.register_command("midpos", {
	params = "",
	description = "Return the mid point of current selection.",
	privs = { worldedit = true },
	require_pos = 2,
	parse = function(params_text)
		return true
	end,
	func = function(name, params_text)
		local str = "The centre of the current selection is at "
		local vec = wea.vector.mean(worldedit.pos1[name],worldedit.pos2[name])
		
		return true, str .. wea.table.tostring(vec)
	end,
})
