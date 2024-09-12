local wea_c = worldeditadditions_core
local Vector3 = wea_c.Vector3

-- ███████  ██████ ██    ██ ██████  ███████
-- ██      ██      ██    ██ ██   ██ ██
-- ███████ ██      ██    ██ ██████  █████
--      ██ ██      ██    ██ ██   ██ ██
-- ███████  ██████  ██████  ██████  ███████
worldeditadditions_core.register_command("scube", {
	params = "[<axis1> [<axis2> [<axis3>]]] <length>",
	description = "Set WorldEdit region position 2 at a set distance along 3 axes.",
	privs = { worldedit = true },
	require_pos = 1,
	parse = function(params_text)
		-------------------------
	end,
	func = function(name)
		return true, "DEPRECATED: please use //srel instead..."
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
