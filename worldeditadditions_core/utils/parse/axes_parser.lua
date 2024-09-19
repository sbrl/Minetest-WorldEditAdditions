-- ██████   █████  ██████  ███████ ███████      █████  ██   ██ ███████ ███████
-- ██   ██ ██   ██ ██   ██ ██      ██          ██   ██  ██ ██  ██      ██
-- ██████  ███████ ██████  ███████ █████       ███████   ███   █████   ███████
-- ██      ██   ██ ██   ██      ██ ██          ██   ██  ██ ██  ██           ██
-- ██      ██   ██ ██   ██ ███████ ███████     ██   ██ ██   ██ ███████ ███████

-- Error codes: https://kinsta.com/blog/http-status-codes/

--- FOR TESTING ---
local function unpack(tbl)
	if table.unpack then
		return table.unpack(tbl)
	else return unpack(tbl) end
end
---------------

local wea_c = worldeditadditions_core or nil
local Vector3
if worldeditadditions_core then
	Vector3 = dofile(wea_c.modpath.."/utils/vector3.lua")
else
	Vector3 = require("worldeditadditions_core.utils.vector3")
end


--- Unified Axis Syntax banks
local keywords = {
	-- Compass keywords
	compass = {
		["n"] = "z", ["north"] = "z",
		["-n"] = "-z", ["-north"] = "-z",
		["s"] = "-z", ["south"] = "-z",
		["-s"] = "z", ["-south"] = "z",
		["e"] = "x", ["east"] = "x",
		["-e"] = "-x", ["-east"] = "-x",
		["w"] = "-x", ["west"] = "-x",
		["-w"] = "x", ["-west"] = "x",
		["u"] = "y", ["up"] = "y",
		["-u"] = "-y", ["-up"] = "-y",
		["d"] = "-y", ["down"] = "-y",
		["-d"] = "y", ["-down"] = "y",
	},
	
	-- Direction keywords
	dir = {
		["?"] = "front", ["f"] = "front",
		["facing"] = "front", ["front"] = "front",
		["b"] = "back", ["back"] = "back",
		["behind"] = "back", ["rear"] = "back",
		["l"] = "left", ["left"] = "left",
		["r"] = "right", ["right"] = "right",
	},
	
	-- Mirroring keywords
	mirroring = {
		["sym"] = true, ["symmetrical"] = true,
		["mirror"] = true, ["mir"] = true,
		["rev"] = true, ["reverse"] = true,
		["m"] = true, ["true"] = true
	},
}

--- Initialize parser function container
local parse = {}

--- Processes an axis declaration into ordered xyz format. (Supports axis clumping)
-- For example, "zzy" would become "yz"
-- @param: str: String: Axis declaration to parse
-- @returns: Table|Bool: axis | axes | false
function parse.axis(str)
	local ret = { rev={} }
	if str:match("[^hvxyz]") then return false end
	
	for _,v in ipairs({{"x","h"},{"y","v"},{"z","h"}}) do
		if str:match(v[2]) then table.insert(ret.rev,v[1])
			str = str..v[1] end
		if str:match(v[1]) then table.insert(ret,v[1]) end
	end
	
	if #ret.rev < 1 then ret.rev = nil end
	return ret
end

--- Processes an number from a string.
-- @param: str: String: string to parse
-- @returns: Number|Bool: processed number | false
function parse.num(str)
	str = tostring(str) -- To prevent meltdown if str isn't a string
	local num = str:match("^-?%d+%.?%d*$")
	if num then
		return tonumber(num)
	else return false end
end

--- Checks if a string is a valid Unified Axis Syntax. (Supports axis clumping)
-- @param: str: String: Keyword to parse
-- @returns: keyword type, processed keyword content and signed number (or nil)
function parse.keyword(str)
	if type(str) ~= "string" then
		return "err", "Error: \""..tostring(str).."\" is not a string.", 404
	elseif keywords.compass[str] then
		str = keywords.compass[str]
	end
	local sign = 1
	if str:sub(1,1) == "-" then
		sign = -1
		str = str:sub(2)
	end
	
	local axes = parse.axis(str)
	if axes then
		return "axis", axes, sign
	elseif keywords.dir[str] then
		return "dir", keywords.dir[str], sign
	elseif keywords.mirroring[str] then
		return "rev", "mirroring"
	else
		return "err", "Error: \""..str.."\" is not a valid axis, direction or keyword.", 422
	end
end


--- Creates a vector with a length of (@param: value * @param: sign)
--  on each axis in @param: axes.
-- @param: axes: Table: List of axes to set
-- @param: value: Number: length of to set axes
-- @param: sign: Number: sign multiplier for axes
-- @returns: Vector3: processed vector
function parse.vectorize(axes,value,sign)
	-- TODO: Add hv compatability
	local ret = Vector3.new()
	for _,v in ipairs(axes) do
		ret[v] = value * sign
	end
	return ret
end



--- Converts Unified Axis Syntax table into Vector3 instances.
-- @param: tbl: Table: Keyword table to parse
-- @param: facing: Table: Output from worldeditadditions_core.player_dir(name)
-- @param: sum: Bool | String | nil: Return a single vector by summing the 2 output vectors together
-- @returns: Vector3, [Vector3]: returns min, max Vector3 or sum Vector3 (if @param: sum ~= nil)
-- if error: @returns: false, String: error message
function parse.keytable(tbl, facing, sum)
	local min, max, mir= Vector3.new(), Vector3.new(), false
	local neg, pos, v0 = Vector3.new(), Vector3.new(), Vector3.new()
	
	local function update(num) -- Update "min" and "max"
		if num < 0 then
			min, max = min:add(pos:mul(num)), max:add(neg:mul(num))
		else
			min, max = min:add(neg:mul(num)), max:add(pos:mul(num))
		end
		neg, pos = v0:clone(), v0:clone()
	end
	
	local function udir(axes, sign) -- Update "neg" and "pos"
		if axes.rev then udir(axes.rev, -sign) end
		for _, v in ipairs(axes) do
			if sign < 0 then neg[v] = -1
			else pos[v] = 1 end
		end
	end
	
	for i,v in ipairs(tbl) do
		if v:sub(1, 1) == "+" then 
			v = v:sub(2) 
		end
		
		local num = parse.num(v)
		
		-- If we have a dimension add it to output
		-- Else gather direction statements
		if num then
			-- Check for direction vectors
			if neg == v0 and pos == v0 then
				neg, pos = v0:add(-1), v0:add(1)
			end
			update(num)
		else
			local key_type, key_entry, key_sign = parse.keyword(v)
				
				if key_type == "axis" then
					udir(key_entry, key_sign)
				elseif key_type == "dir" then
					udir({facing[key_entry].axis},
						facing[key_entry].sign * key_sign)
				elseif key_type == "rev" then
					mir = true
				else
					return false, key_entry
				end
		end
	end
	
	if mir and not sum then
		max = max:max(min:abs())
		min = max:multiply(-1)
	end
	
	if sum then
		return min:add(max)
	else
		return min, max
	end
end



return {
	keyword = parse.keyword,
	keytable = parse.keytable,
}