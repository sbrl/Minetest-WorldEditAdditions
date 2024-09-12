local wea_c = worldeditadditions_core
local Vector3 = wea_c.Vector3

-- ███████  ██████  ██████  ██
-- ██      ██      ██    ██ ██
-- ███████ ██      ██    ██ ██
--      ██ ██      ██    ██ ██
-- ███████  ██████  ██████  ███████
worldeditadditions_core.register_command("scol", {
	params = "[<axis1>] <length>",
	description = "Set WorldEdit region position 2 at a set distance along 1 axis.",
	privs = {worldedit=true},
	require_pos = 1,
	parse = function(params_text)
		-------------------------
	end,
	func = function(name)
		return true, "DEPRECATED: please use //srel instead..."
	end,
})

-- Tests
-- /multi //fp set1 -63 19 -20 //scol 5

-- lua print(worldedit.player_axis(myname))
-- tonumber(('y1'):gsub('[xyz]',''):sub(1,2))
