-- ███████ ██████  ███████  ██████ ████████
-- ██      ██   ██ ██      ██         ██
-- ███████ ██████  █████   ██         ██
--      ██ ██   ██ ██      ██         ██
-- ███████ ██   ██ ███████  ██████    ██
local wea = worldeditadditions
worldedit.register_command("srect", {
	params = "[<axis1> [<axis2>]] <length>",
	description = "Set WorldEdit region position 2 at a set distance along 2 axes.",
	privs = { worldedit = true },
	require_pos = 1,
	parse = function(params_text)
		local vec, tmp = vector.new(0, 0, 0), {}
		local find = wea.split(params_text, "%s", false)
		local ax1, ax2 = (tostring(find[1]):match('[xyz]') or "g"):sub(1,1), (tostring(find[2]):match('[xyz]') or "g"):sub(1,1)
		local sn1, sn2, len  = wea.getsign(find[1]), wea.getsign(find[2]), find[table.maxn(find)]
		
		tmp.len = tonumber(len)
		-- If len == nill cancel the operation
		if not tmp.len then return false, "No length specified." end
		-- If axis is bad send "get" order
		if ax1 == "g" then tmp.get = true
		else vec[ax1] = sn1 * tmp.len end
		if ax2 == "g" then tmp.get = true
		else vec[ax2] = sn2 * tmp.len end
		
		tmp.axes = ax1..","..ax2
		return true, vec, tmp
		-- tmp carries:
		-- The length (len) arguement to the main function for use if "get" is invoked there
		-- The bool value "get" to tell the main function if it needs to populate missing information in vec
		-- The string "axes" to tell the main function what axes are and/or need to be populated if "get" is invoked
	end,
	func = function(name, vec, tmp)
		if tmp.get then
			local ax, dir = wea.player_axis2d(name)
			if not tmp.axes:find("[xz]") then vec[ax] = tmp.len * dir end
			if not tmp.axes:find("y") then vec.y = tmp.len end
		end
		
		local p2 = vector.add(vec,worldedit.pos1[name])
		worldedit.pos2[name] = p2
		worldedit.mark_pos2(name)
		return true, "position 2 set to " .. minetest.pos_to_string(p2)
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
-- lua vec = vector.new(15,-12,17); vec["len"] = 5; vec.get = true; vec2 = vector.add(vector.new(1,1,1),vec) print(vec2.x,vec2.y,vec2.z,vec2.len)
