-- ███    ███ ██████  ████████ ██  ██████
-- ████  ████ ██   ██    ██    ██ ██
-- ██ ████ ██ ██████     ██    ██ ██   ███
-- ██  ██  ██ ██   ██    ██    ██ ██    ██
-- ██      ██ ██   ██    ██    ██  ██████
local wea = worldeditadditions
-- worldeditdebug.register("abschk")
worldedit.register_command("mtrig", {
	params = "",
	description = "Return the length of each axis of current selection.",
	privs = { worldedit = true },
	require_pos = 2,
	parse = function(params_text)
		return true
	end,
	func = function(name, params_text)
		local str = "The measurements of the line pos1,pos2 are Length: "
		local vec = vector.subtract(worldedit.pos2[name],worldedit.pos1[name])
		wea.vector.abs(vec)
		-- Test:
		-- if worldeditdebug.debug["abschk"][name] then
		-- 	-- //debug abschk
		-- 	return false, "Values = " .. worldeditdebug.table_tostring(vec)
		-- end
		local len = wea.Vector3.length(vec)
		str = str..len..", X/Z angle: "..math.atan(vec.z/vec.x).."° h/Y angle: "..math.atan(vec.y/len).."°"
		return true, str
	end,
})
