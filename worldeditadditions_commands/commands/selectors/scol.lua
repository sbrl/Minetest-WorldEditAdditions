-- ███████  ██████  ██████  ██
-- ██      ██      ██    ██ ██
-- ███████ ██      ██    ██ ██
--      ██ ██      ██    ██ ██
-- ███████  ██████  ██████  ███████
worldedit.register_command("scol", {
	params = "[<axis1>] <length>",
	description = "Set WorldEdit region position 2 at a set distance along 1 axis.",
	privs = {worldedit=true},
	require_pos = 1,
	parse = function(params_text)
		local wea = worldeditadditions
		local find = wea.split(params_text, "%s", false)
		local ax1, len = find[1], find[table.maxn(find)]
		
		-- If ax1 is bad set to player facing dir
		if ax1 == len  or not ax1:match('[xyz]') then ax1 = "get"
		else ax1 = { wea.getsign(ax1), ax1:gsub('[^xyz]', ''):sub(1, 1) } end
		
		len = tonumber(len)
		-- If len == nill cancel the operation
		if len == nil then
			return false, "No length specified."
		end
		
		return true, ax1, len
	end,
	func = function(name, axis1, len)
		if axis1 == "get" then
			ax1, dir = worldedit.player_axis(name)
			axis1 = {dir,ax1}
		end
		
		local p2 = vector.new(worldedit.pos1[name])
		p2[axis1[2]] = p2[axis1[2]] + tonumber(len) * axis1[1]
		
		worldedit.pos2[name] = p2
		worldedit.mark_pos2(name)
		return true, "position 2 set to " .. minetest.pos_to_string(p2)
	end,
})

-- Tests
-- /multi //fp set1 -63 19 -20 //scol 5

-- lua print(worldedit.player_axis(myname))
-- tonumber(('y1'):gsub('[xyz]',''):sub(1,2))
