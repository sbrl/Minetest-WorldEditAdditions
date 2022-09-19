local wea_c = worldeditadditions_core
local Vector3 = wea_c.Vector3


-- ███    ███ ███████ ██ ███████ ███████
-- ████  ████ ██      ██    ███  ██
-- ██ ████ ██ ███████ ██   ███   █████
-- ██  ██  ██      ██ ██  ███    ██
-- ██      ██ ███████ ██ ███████ ███████

worldeditadditions_core.register_command("msize", {
	params = "",
	description = "Return the length of each axis of current selection.",
	privs = { worldedit = true },
	require_pos = 2,
	parse = function(params_text)
		return true
	end,
	func = function(name, params_text)
		local str = "The dimensions of the current selection are "
		
		local pos1 = Vector3.clone(worldedit.pos1[name])
		local pos2 = Vector3.clone(worldedit.pos2[name])
		
		local vec = (pos2 - pos1):abs()
		
		return true, str .. "x: " .. vec.x .. ", y: " .. vec.y .. ", z: " .. vec.z
	end,
})
