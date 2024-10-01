local wea_c = worldeditadditions_core
local Vector3 = wea_c.Vector3

-- ███████  ██████  ██████  ██
-- ██      ██      ██    ██ ██
-- ███████ ██      ██    ██ ██
--      ██ ██      ██    ██ ██
-- ███████  ██████  ██████  ███████
worldeditadditions_core.register_command("scol", {
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
-- /multi //fp set1 -63 19 -20 //scol 5

-- lua print(worldedit.player_axis(myname))
-- tonumber(('y1'):gsub('[xyz]',''):sub(1,2))
