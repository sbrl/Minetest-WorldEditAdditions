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


--- Unified Axis Keywords banks
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
		["d"] = "-y", ["down"] = "-y",
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
	local ret = {}
	if str:match("[^hvxyz]") then return false end
	
	if str:match("v") then 
		ret["v"] = true
		str = "y"..str
	end
	if str:match("h") then 
		ret["h"] = true
		str = "xz"..str
	end

	for _,v in ipairs({"x", "y", "z"}) do
		if str:match(v) then table.insert(ret,v) end
	end

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

--- Checks if a string is a valid Unified Axis Keyword. (Supports axis clumping)
-- @param: str: String: Keyword instance to parse
-- @returns: Key Instance: returns keyword type, processed keyword content and signed number (or nil)
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



--- Converts Unified Axis Keyword table into Vector3 instances.
-- @param: tbl: Table: Keyword table to parse
-- @param: facing: Table: Output from worldeditadditions_core.player_dir(name)
-- @param: sum: Bool | String | nil: Return a single vector by summing the 2 output vectors together
-- @returns: Vector3, [Vector3]: returns min, max Vector3s or sum Vector3 (if @param: sum ~= nil)
-- if error: @returns: false, String: error message
function parse.keytable(tbl, facing, sum)
	local min, max = Vector3.new(), Vector3.new()
	local expected = 1
	local tmp = {axes = {}, num = 0, sign = 1, mirror = false}
	
	function tmp:reset() 
		self.axis, self.sign = "", 1 
	end
	
	--- Processes a number and adds it to the min and max vectors.
	-- @param num The number to process.
	-- @param axes The axes to apply the number to.
	-- @param sign The sign of the number.
	local function parseNumber(num, axes, sign)
		if num * sign >= 0 then
			max = max:add(parse.vectorize(axes, num, sign))
		else
			min = min:add(parse.vectorize(axes, num, sign))
		end
	end
	
	for i, v in ipairs(tbl) do
		if v:sub(1, 1) == "+" then 
			v = v:sub(2) 
		end
		
		tmp.num = parse.num(v)
		
		if expected == 1 then
			if tmp.num then
				parseNumber(tmp.num, {"x", "y", "z", h = true, v = true}, tmp.sign)
			else
				local key_type, key_entry, key_sign = parse.keyword(v)
				
				if key_type == "axis" then
					tmp.axes = key_entry
					tmp.sign = key_sign
				elseif key_type == "dir" then
					tmp.axes = {facing[key_entry].axis}
					tmp.sign = facing[key_entry].sign * key_sign
				elseif key_type == "rev" then
					tmp.mirror = true
				else
					return false, key_entry
				end
				
				expected = 2
			end
		else
			if tmp.num then
				parseNumber(tmp.num, tmp.axes, tmp.sign)
				expected = 1
			else
				return false, "Error: Expected number after \""..tostring(tbl[i-1]).."\". Got \""..tostring(v).."\"."
			end
		end
	end
	
	if tmp.mirror and not sum then
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