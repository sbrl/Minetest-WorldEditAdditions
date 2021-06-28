-- ███████ ███    ███  █████  ██   ██ ███████
-- ██      ████  ████ ██   ██ ██  ██  ██
-- ███████ ██ ████ ██ ███████ █████   █████
--      ██ ██  ██  ██ ██   ██ ██  ██  ██
-- ███████ ██      ██ ██   ██ ██   ██ ███████
local wea = worldeditadditions
worldedit.register_command("smake", {
	params = "<operation:odd|even|equal> <mode:grow|shrink|average> [<target=xyz> [<base>]]",
	description = "Make one or more axes of the current selection odd, even, or equal to another.",
	privs = { worldedit = true },
	require_pos = 2,
	parse = function(params_text)
		-- Split params_text, check for missing arguments and fill in empty spots
		local parts = wea.split(params_text, "%s+", false)
		if #parts < 2 then
			return false, "Error: Not enough arguments. Expected \"<operation> <mode> [<target=xyz> [<base>]]\"."
		else
			for i=3,4 do if not parts[i] then parts[i] = false end end
		end
		
		-- Initialize local variables and sets
		local oper, mode, targ, base = wea.table.unpack(parts)
		local operSet, modeSet = wea.table.makeset {"equal", "odd", "even"}, wea.table.makeset {"grow", "shrink", "avg"}
		
		-- Main Logic
		-- Check base if base is present and if so valid.
		if base then
			if base:match("[xyz]") then -- ensure correct base syntax
				base = base:match("[xyz]")
			else
				return false, "Error: Invalid base \""..base.."\". Expected \"x\", \"y\" or \"z\"."
			end
		end
		
		-- Resolve target then mode (in that order incase mode is target).
		if not targ then -- If no target set to default (xz)
			targ = "xz"
		elseif targ:match("[xyz]+") then -- ensure correct target syntax
			targ = table.concat(wea.tochars(targ:match("[xyz]+"),true,true))
		else
			return false, "Error: Invalid <target> \""..targ.."\". Expected \"x\" and or \"y\" and or \"z\"."
		end
		
		if mode == "average" then -- If mode is average set to avg
			mode = "avg"
		elseif mode:match("[xyz]+") then -- If target is actually base set vars to correct values.
			base, targ, mode = targ:sub(1,1), table.concat(wea.tochars(mode:match("[xyz]+"),true,true)), false
		elseif not modeSet[mode] and not base then -- If mode is invalid and base isn't present throw error
			return false, "Error: Invalid <mode> \""..mode.."\". Expected \"grow\", \"shrink\", or \"average\"/\"avg\"."
		end
		
		if base then
			if oper ~= "equal" then base = false -- If operation isn't equalize we don't need <base>
			elseif targ:match(base) then -- Else check that base is not in target and return error if it is
				return false, "Error: <base> ("..base..") cannot be included in <target> ("..targ..")."
			end
		end
		
		-- Check if operator is valid
		if not operSet[oper] then
			return false, "Error: Invalid operator \""..oper.."\". Expected \"odd\", \"even\" or \"equal\"."
		end
		
		return true, oper, mode, targ, base
	end,
	func = function(name, oper, mode, targ, base)
		local p1, p2 = vector.new(worldedit.pos1[name]), vector.new(worldedit.pos2[name])
		local eval = function() end -- Declare eval placeholder function to edit later
		
		local delta = vector.subtract(p2,p1) -- local delta equation: Vd(a) = V2(a) - V1(a)
		local _tl = #targ -- Get targ length as a variable incase mode is "average"/"avg"
		local targ = wea.tocharset(targ) -- Break up targ string into set table
		local _m =  0 -- _m is the container to hold the max, min or average (depending on the mode) of the axes in targ
		
		-- set _m to the max, min or mean of the target axes depending on mode or base if it exists
		if base then _m = delta[base]
		elseif mode == "avg" then
			for k,v in pairs(targ) do _m = _m + math.abs(delta[k]) end
			_m = _m / _tl
		elseif mode == "grow" then
			for k,v in pairs(targ) do if math.abs(delta[k]) > _m then _m = math.abs(delta[k]) end end
		else
			-- Take output of next(targ), put it in a table, wrap the table in brackets to force evlauation so that
			-- we can call the first element of that table to serve as the key for a call to delta.
			_m = delta[({next(targ)})[1]]
			for k,v in pairs(targ) do if math.abs(delta[k]) < _m then _m = math.abs(delta[k]) end end
		end
		
		if oper == "even" then
			eval = function(int)
				local tmp, abs, neg = int / 2, math.abs(int), int < 0
				if math.floor(tmp) ~= tmp then
					if mode == "avg" then
						if int > _m then int = abs - 1
						else int = abs + 1 end
					elseif mode == "shrink" and abs > 0 then int = abs - 1
					else int = abs + 1 end
				end
				if neg then int = int * -1 end -- Ensure correct facing direction
				return int
			end
		elseif oper == "odd" then
			eval = function(int)
				local tmp, abs, neg = int / 2, math.abs(int), int < 0
				if math.floor(tmp) == tmp then
					if mode == "avg" then
						if int > _m then int = abs - 1
						else int = abs + 1 end
					elseif mode == "shrink" and abs > 0 then int = abs - 1
					else int = abs + 1 end
				end
				if neg then int = int * -1 end
				return int
			end
		else -- Case: oper == "equal"
			eval = function(int)
				-- Bug: shrink sets pos2 to pos1
				if int < 0 then return _m * -1
				else return _m end
			end
		end
		
		for k,v in pairs(targ) do delta[k] = eval(delta[k]) end
		
		worldedit.pos2[name] = vector.add(p1,delta)
		worldedit.mark_pos2(name)
		return true, "position 2 set to " .. minetest.pos_to_string(p2)
	end
})
