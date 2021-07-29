-- ███████ ██████  ███████ ██
-- ██      ██   ██ ██      ██
-- ███████ ██████  █████   ██
--      ██ ██   ██ ██      ██
-- ███████ ██   ██ ███████ ███████
local wea = worldeditadditions
local function parse_with_name(name,args)
	local vec, tmp = vector.new(0, 0, 0), {}
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
worldedit.register_command("srel", {
	params = "<axis1> <length1> [<axis2> <length2> [<axis3> <length3>]]",
	description = "Set WorldEdit region position 2 at set distances along 3 axes.",
	privs = { worldedit = true },
	require_pos = 0,
	parse = function(params_text)
		if params_text:match("([%l%s+-]+%d+)") then return true, params_text
		else return false, "No acceptable params found" end
	end,
	func = function(name, params_text)
		local ret = ""
		local _, vec = parse_with_name(name,params_text)
		if not _ then return false, vec end
		
		if not worldedit.pos1[name] then
			local pos = vector.add(wea.player_vector(name), vector.new(0.5,-0.5,0.5))
			wea.vector.floor(pos)
			worldedit.pos1[name] = pos
			worldedit.mark_pos1(name)
			ret = "position 1 set to " .. minetest.pos_to_string(pos) .. ", "
		end
		
		local p2 = vector.add(vec,worldedit.pos1[name])
		worldedit.pos2[name] = p2
		worldedit.mark_pos2(name)
		return true, ret .. "position 2 set to " .. minetest.pos_to_string(p2)
	end,
})

-- Tests
-- //srel front 5 left 3 y 2
