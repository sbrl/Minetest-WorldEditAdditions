-- ███    ███ ████████ ██████  ██  ██████
-- ████  ████    ██    ██   ██ ██ ██
-- ██ ████ ██    ██    ██████  ██ ██   ███
-- ██  ██  ██    ██    ██   ██ ██ ██    ██
-- ██      ██    ██    ██   ██ ██  ██████
local wea = worldeditadditions
local v3 = worldeditadditions.Vector3
worldedit.register_command("mtrig", {
	params = "",
	description = "Return the length of each axis of current selection.",
	privs = { worldedit = true },
	require_pos = 2,
	parse = function(params_text)
		return true
	end,
	func = function(name, params_text)
		local str = "The measurements of the line pos1,pos2 are Length (D): "
		local vec = v3.subtract(worldedit.pos2[name],worldedit.pos1[name]):abs()
		local len = vec:length()
		str = str..len..", ∠XZ: "..math.deg(math.atan(vec.z/vec.x)).."° ∠DY: "..math.deg(math.asin(vec.y/len)).."°"
		return true, str
	end,
})
