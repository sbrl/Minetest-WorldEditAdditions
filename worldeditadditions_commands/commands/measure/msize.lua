-- ███    ███ ███████ ██ ███████ ███████
-- ████  ████ ██      ██    ███  ██
-- ██ ████ ██ ███████ ██   ███   █████
-- ██  ██  ██      ██ ██  ███    ██
-- ██      ██ ███████ ██ ███████ ███████
local wea = worldeditadditions
worldedit.register_command("msize", {
	params = "",
	description = "Return the length of each axis of current selection.",
	privs = { worldedit = true },
	require_pos = 2,
	parse = function(params_text)
		return true
	end,
	func = function(name, params_text)
		local str = "The dimensions of the current selection are "
		local vec = vector.subtract(worldedit.pos2[name],worldedit.pos1[name])
		wea.vector.abs(vec)
		
		return true, str .. "x: " .. vec.x .. ", y: " .. vec.y .. ", z: " .. vec.z
	end,
})
