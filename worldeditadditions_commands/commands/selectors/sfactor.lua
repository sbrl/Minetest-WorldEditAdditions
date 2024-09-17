local wea = worldeditadditions
local wea_c = worldeditadditions_core
local Vector3 = wea_c.Vector3


-- ███████ ███████  █████   ██████ ████████  ██████  ██████
-- ██      ██      ██   ██ ██         ██    ██    ██ ██   ██
-- ███████ █████   ███████ ██         ██    ██    ██ ██████
--      ██ ██      ██   ██ ██         ██    ██    ██ ██   ██
-- ███████ ██      ██   ██  ██████    ██     ██████  ██   ██
worldeditadditions_core.register_command("sfactor", {
	params = "None",
	description = "Deprecated.",
	privs = { worldedit = true },
	require_pos = 1,
	parse = function(params_text)
		return params_text
	end,
	func = function(name, paramtext)
		return false, "DEPRECATED: please use //grow or //shrink instead..."
	end
})
