local wea_c = worldeditadditions_core
local Vector3 = wea_c.Vector3

-- ███████ ██████  ███████  ██████ ████████
-- ██      ██   ██ ██      ██         ██
-- ███████ ██████  █████   ██         ██
--      ██ ██   ██ ██      ██         ██
-- ███████ ██   ██ ███████  ██████    ██
worldeditadditions_core.register_command("srect", {
	params = "None",
	description = "Deprecated.",
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
-- /multi //fp set1 -63 19 -20 //srect 5
-- /multi //fp set1 -63 19 -20 //srect z 5
-- /multi //fp set1 -63 19 -20 //srect a z 5
-- /multi //fp set1 -63 19 -20 //srect z a 5
-- /multi //fp set1 -63 19 -20 //srect -z 5
-- /multi //fp set1 -63 19 -20 //srect a -x 5
-- /multi //fp set1 -63 19 -20 //srect -x -a 5
-- lua vec = Vector3.new(15,-12,17); vec["len"] = 5; vec.get = true; vec2 = Vector3.new(1,1,1) + vec; print(vec2.x,vec2.y,vec2.z,vec2.len)
