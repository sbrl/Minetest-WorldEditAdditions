-- ███████ ███████ ██   ██ ██ ███████ ████████
-- ██      ██      ██   ██ ██ ██         ██
-- ███████ ███████ ███████ ██ █████      ██
--      ██      ██ ██   ██ ██ ██         ██
-- ███████ ███████ ██   ██ ██ ██         ██
local wea = worldeditadditions
local v3 = worldeditadditions.Vector3
local function parse_with_name(name,args)
	local vec, tmp = v3.new(0, 0, 0), {}
	local find, _, i = {}, 0, 0
	repeat
		_, i, tmp.proc = args:find("([%l%s+-]+%d+)%s*", i)
		if tmp.proc:match("[xyz]") then
			tmp.ax = tmp.proc:match("[xyz]")
			tmp.dir = tonumber(tmp.proc:match("[+-]?%d+")) * (tmp.proc:match("-%l+") and -1 or 1)
		else
			tmp.ax, _ = wea.dir_to_xyz(name, tmp.proc:match("%l+"))
			if not tmp.ax then return false, _ end
			tmp.dir = tonumber(tmp.proc:match("[+-]?%d+")) * (tmp.proc:match("-%l+") and -1 or 1) * _
		end
		vec[tmp.ax] = tmp.dir
	until not args:find("([%l%s+-]+%d+)%s*", i)
	return true, vec
end
worldedit.register_command("sshift", {
	params = "<axis1> <distance1> [<axis2> <distance2> [<axis3> <distance3>]]",
	description = "Shift the WorldEdit region in 3 dimensions.",
	privs = { worldedit = true },
	require_pos = 2,
	parse = function(params_text)
		if params_text:match("([%l%s+-]+%d+)") then return true, params_text
		else return false, "No acceptable params found" end
	end,
	func = function(name, params_text)
		local _, vec = parse_with_name(name,params_text)
		if not _ then return false, vec end
		
		local pos1 = vec:add(worldedit.pos1[name])
		worldedit.pos1[name] = pos1
		worldedit.mark_pos1(name)
		
		local pos2 = vec:add(worldedit.pos2[name])
		worldedit.pos2[name] = pos2
		worldedit.mark_pos2(name)
		
		return true, "Region shifted by  " .. (vec.x + vec.y + vec.z) .. " nodes."
	end,
})

-- Tests
-- //srel front 5 left 3 y 2
