-- ███████ ██████  ███████  ██████ ████████
-- ██      ██   ██ ██      ██         ██
-- ███████ ██████  █████   ██         ██
--      ██ ██   ██ ██      ██         ██
-- ███████ ██   ██ ███████  ██████    ██
-- local -- TODO: set this to local once development is finished
function parse_params_srect(params_text)
	local wea = worldeditadditions
	local find = wea.split(params_text, "%s", false)
	local ax1, ax2, len = find[1], find[2], find[table.maxn(find)]
	
	-- If ax1 is bad set to player facing dir
	if ax1 == len  or not ax1:match('[xyz]') then ax1 = "get"
	else
		local success, value = wea.getsign(ax1, "int")
		if not success then return success, value
		else ax1 = { value, ax1:gsub('[^xyz]',''):sub(1,1) }
		end
	end
	-- If ax2 is bad set to +y
	if not ax2 or ax2 == len or not ax2:match('[xyz]') then ax2 = "y" end
	local success, value = wea.getsign(ax2, "int")
	if not success then return success, value end
	ax2 = { value, ax2:gsub('[^xyz]',''):sub(1,1) }
	
	len = tonumber(len)
	-- If len == nill cancel the operation
	if len == nil then
		return false, "No length specified."
	end
	
	return true, ax1, ax2, len
end
worldedit.register_command("srect", {
	params = "[<axis1> [<axis2>]] <length>",
	description = "Set WorldEdit region position 2 at a set distance along 2 axes.",
	privs = {worldedit=true},
	require_pos = 1,
	parse = function(params_text)
		local values = {parse_params_srect(params_text)}
		return unpack(values)
	end,
	func = function(name, axis1, axis2, len)
		if axis1 == "get" then axis1 = worldeditadditions.player_axis2d(name) end
		
		local p2 = vector.new(worldedit.pos1[name])
		
		p2[axis1[2]] = p2[axis1[2]] + tonumber(len) * axis1[1]
		p2[axis2[2]] = p2[axis2[2]] + tonumber(len) * axis2[1]
		
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
