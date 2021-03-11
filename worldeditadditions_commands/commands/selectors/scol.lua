-- ███████  ██████  ██████  ██
-- ██      ██      ██    ██ ██
-- ███████ ██      ██    ██ ██
--      ██ ██      ██    ██ ██
-- ███████  ██████  ██████  ███████
local wea = worldeditadditions
worldedit.register_command("scol", {
	params = "[<axis1>] <length>",
	description = "Set WorldEdit region position 2 at a set distance along 1 axis.",
	privs = {worldedit=true},
	require_pos = 1,
	parse = function(params_text)
		local vec, tmp = vector.new(0, 0, 0), {}
		local find = wea.split(params_text, "%s", false)
		local ax1, sn1, len = (tostring(find[1]):match('[xyz]') or "g"):sub(1,1), wea.getsign(find[1]), find[table.maxn(find)]
		
		tmp.len = tonumber(len)
		-- If len == nil cancel the operation
		if not tmp.len then return false, "No length specified." end
		-- If ax1 is bad send "get" order
		if ax1 == "g" then tmp.get = true
		else vec[ax1] = sn1 * tmp.len end
		
		return true, vec, tmp
		-- tmp carries:
		-- The length (len) arguement to the main function for use if "get" is invoked there
		-- The bool value "get" to tell the main function if it needs to populate missing information in vec
	end,
	func = function(name, vec, tmp)
		if tmp.get then
			local ax, dir = wea.player_axis2d(name)
			vec[ax] = tmp.len * dir
		end
		
		local p2 = vector.add(vec,worldedit.pos1[name])
		worldedit.pos2[name] = p2
		worldedit.mark_pos2(name)
		return true, "position 2 set to " .. minetest.pos_to_string(p2)
	end,
})

-- Tests
-- /multi //fp set1 -63 19 -20 //scol 5

-- lua print(worldedit.player_axis(myname))
-- tonumber(('y1'):gsub('[xyz]',''):sub(1,2))
