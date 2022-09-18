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
		local vec, tmp = Vector3.new(0, 0, 0), {}
		local find = wea_c.split(params_text, "%s", false)
		local ax1, ax2, ax3 = (tostring(find[1]):match('[xyz]') or "g"):sub(1,1), (tostring(find[2]):match('[xyz]') or "g"):sub(1,1),
		(tostring(find[3]):match('[xyz]') or "g"):sub(1,1)
		local sn1, sn2, sn3, len  = wea_c.getsign(find[1]), wea_c.getsign(find[2]), wea_c.getsign(find[3]), find[table.maxn(find)]
		
		tmp.len = tonumber(len)
		-- If len is nill cancel the operation
		if not tmp.len then return false, "No length specified." end
		-- If axis is bad send "get" order
		if ax1 == "g" then tmp.get = true
		else vec[ax1] = sn1 * tmp.len end
		if ax2 == "g" then tmp.get = true
		else vec[ax2] = sn2 * tmp.len end
		if ax3 == "g" then tmp.get = true
		else vec[ax3] = sn3 * tmp.len end
		
		tmp.axes = ax1..","..ax2..","..ax3
		return true, vec, tmp
		-- tmp carries:
		-- The length (len) arguement to the main function for use if "get" is invoked there
		-- The bool value "get" to tell the main function if it needs to populate missing information in vec
		-- The string "axes" to tell the main function what axes are and/or need to be populated if "get" is invoked
	end,
	func = function(name, vec, tmp)
		if tmp.get then
			local ax, dir = wea_c.player_axis2d(name)
			local _, left, sn = wea_c.axis_left(ax,dir)
			if not tmp.axes:find("x") then vec.x = tmp.len * (ax == "x" and dir or sn) end
			if not tmp.axes:find("z") then vec.z = tmp.len * (ax == "z" and dir or sn) end
			if not tmp.axes:find("y") then vec.y = tmp.len end
		end
		
		local pos2 = vec + Vector3.clone(worldedit.pos1[name])
		worldedit.pos2[name] = pos2
		worldedit.mark_pos2(name)
		return true, "position 2 set to "..pos2
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
