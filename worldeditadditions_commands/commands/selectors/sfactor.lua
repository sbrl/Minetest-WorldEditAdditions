-- ███████ ███████  █████   ██████ ████████  ██████  ██████
-- ██      ██      ██   ██ ██         ██    ██    ██ ██   ██
-- ███████ █████   ███████ ██         ██    ██    ██ ██████
--      ██ ██      ██   ██ ██         ██    ██    ██ ██   ██
-- ███████ ██      ██   ██  ██████    ██     ██████  ██   ██
local wea = worldeditadditions
worldedit.register_command("sfactor", {
	params = "<mode> <factor> [<target=xz>]",
	description = "Make the length of one or more target axes of the current selection to be multiple(s) of <factor>.",
	privs = { worldedit = true },
	require_pos = 2,
	parse = function(params_text)
		local parts = wea.split(params_text, "%s+", false)
		
		if #parts < 2 then
			return false, "Error: Not enough arguments. Expected \"<mode> <factor> [<target>]\"."
		end
		local mode, fac, targ = unpack(parts)
		local modeSet = wea.makeset {"grow", "shrink", "avg"}
		
		-- Mode parsing
		if mode == "average" then -- If mode is average set to avg
			mode = "avg"
		elseif not modeSet[mode] then -- If mode is invalid throw error
			return false, "Error: Invalid <mode> \""..mode.."\". Expected \"grow\", \"shrink\", or \"average\"/\"avg\"."
		end
		
		-- Factor parsing
		local factest = tonumber(fac)
		if not factest then
			return false, "Error: Invalid <factor> \""..fac.."\". Expected a number."
		elseif factest < 2 then
			return false, "Error: <factor> is too low. Expected a number equal to or greater than 2."
		else
			fac = math.floor(factest+0.5)
		end
		
		-- Target parsing
		if not targ then -- If no target set to default (xz)
			targ = "xz"
		elseif targ:match("[xyz]+") then -- ensure correct target syntax
			targ = table.concat(wea.tochars(targ:match("[xyz]+"),true,true))
		else
			return false, "Error: Invalid <target> \""..targ.."\". Expected \"x\" and or \"y\" and or \"z\"."
		end
		
		return true, mode, fac, targ
	end,
	func = function(name, mode, fac, targ)
		local p1, p2 = vector.new(worldedit.pos1[name]), vector.new(worldedit.pos2[name])
		local delta = vector.subtract(p2,p1) -- local delta equation: Vd(a) = V2(a) - V1(a)
		local _tl = #targ -- Get targ length as a variable incase mode is "average"/"avg"
		local targ = wea.tocharset(targ) -- Break up targ string into set table
		local _m =  0 -- _m is the container to hold the average of the axes in targ
		
		-- set _m to the max, min or mean of the target axes depending on mode (_tl is the length of targ) or base if it exists
		if mode == "avg" then
			for k,v in pairs(targ) do _m = _m + math.abs(delta[k]) end
			_m = _m / _tl
		end
		
		-- Equasion: round(delta[<axis>] / factor) * factor
		local eval = function(int,fac)
			local tmp, abs, neg = int / fac, math.abs(int), int < 0
			
			if mode == "avg" then
				if int > _m then int = math.floor(abs / fac) * fac
				else int = math.ceil(abs / fac) * fac end
			elseif mode == "shrink" then int = math.floor(abs / fac) * fac
			else int = math.ceil(abs / fac) * fac end
			
			if int < fac then int = fac end -- Ensure selection doesn't collapse to 0
			if neg then int = int * -1 end -- Ensure correct facing direction
			return int
		end
		
		for k,v in pairs(targ) do delta[k] = eval(delta[k],fac) end
		
		worldedit.pos2[name] = vector.add(p1,delta)
		worldedit.mark_pos2(name)
		return true, "position 2 set to " .. minetest.pos_to_string(p2)
	end
})
