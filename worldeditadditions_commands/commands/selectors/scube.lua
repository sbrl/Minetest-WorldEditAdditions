local wea_c = worldeditadditions_core
local Vector3 = wea_c.Vector3

-- ███████  ██████ ██    ██ ██████  ███████
-- ██      ██      ██    ██ ██   ██ ██
-- ███████ ██      ██    ██ ██████  █████
--      ██ ██      ██    ██ ██   ██ ██
-- ███████  ██████  ██████  ██████  ███████
worldeditadditions_core.register_command("scube", {
	params = "None",
	description = "DEPRECATED: please use //srel instead.",
	privs = { worldedit = true },
	require_pos = 1,
	parse = function(params_text)
		return params_text
	end,
	func = function(name, paramtext)
		return false, "DEPRECATED: please use //srel instead..."
	end,
})

-- Tests
-- /multi //fp set1 -63 19 -20 //scube 5
-- /multi //fp set1 -63 19 -20 //scube z 5
-- /multi //fp set1 -63 19 -20 //scube a z 5
-- /multi //fp set1 -63 19 -20 //scube z a y 5
-- /multi //fp set1 -63 19 -20 //scube -z y a 5
-- /multi //fp set1 -63 19 -20 //scube z z 5
-- /lua print()
