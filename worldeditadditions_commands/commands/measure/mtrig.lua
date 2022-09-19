local wea_c = worldeditadditions_core
local Vector3 = wea_c.Vector3


-- ███    ███ ████████ ██████  ██  ██████
-- ████  ████    ██    ██   ██ ██ ██
-- ██ ████ ██    ██    ██████  ██ ██   ███
-- ██  ██  ██    ██    ██   ██ ██ ██    ██
-- ██      ██    ██    ██   ██ ██  ██████

worldeditadditions_core.register_command("mtrig", {
	params = "",
	description = "Return the length of and angles of an imginary line between pos1 and pos2 in the selection.",
	privs = { worldedit = true },
	require_pos = 2,
	parse = function(params_text)
		return true
	end,
	func = function(name, params_text)
		local str = "The measurements of the line from pos1 to pos2 are Length (D): "
		
		local pos1 = Vector3.clone(worldedit.pos2[name])
		local pos2 = Vector3.clone(worldedit.pos1[name])
		
		local vec = (pos2 - pos1):abs()
		local len = vec:length()
		
		str = str..wea_c.round(len, 4)..", ∠XZ: "..
			wea_c.round(math.deg(math.atan(vec.z/vec.x)), 4).."°, ∠DY: "..
			wea_c.round(math.deg(math.asin(vec.y/len)), 4).."°"
		
		return true, str
	end,
})
