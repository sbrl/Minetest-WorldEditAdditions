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
local key_instance
if worldeditadditions_core then
	key_instance = dofile(wea_c.modpath.."/utils/parse/key_instance.lua")
	Vector3 = dofile(wea_c.modpath.."/utils/vector3.lua")
else
	Vector3 = require("worldeditadditions_core.utils.vector3")
	key_instance = require("worldeditadditions_core.utils.parse.key_instance")
end


--- Unified Axis Keywords banks
local keywords = {
	-- Compass keywords
	compass = {
		n = "z", north = "z",
		["-n"] = "-z", ["-north"] = "-z",
		s = "-z", south = "-z",
		["-s"] = "z", ["-south"] = "z",
		e = "x", east = "x",
		["-e"] = "-x", ["-east"] = "-x",
		w = "-x", west = "-x",
		["-w"] = "x", ["-west"] = "x",
	},
	
	-- Direction keywords
	dir = {
		["?"] = "front", f = "front",
		facing = "front", front = "front",
		b = "back", back = "back",
		behind = "back", rear = "back",
		l = "left", left = "left",
		r = "right", right = "right",
		u = "up", up = "up",
		d = "down", down = "down",
	},
	
	-- Mirroring keywords
	mirroring = {
		sym = true, symmetrical = true,
		mirror = true, mir = true,
		rev = true, reverse = true,
		["true"] = true
	},
}

--- Initialize parser function container
local parse = {}

--- Processes an axis declaration into ordered xyz format. (Supports axis clumping)
-- For example, "zzy" would become "yz"
-- @param: str: String: Axis declaration to parse
-- @returns: Table|Bool: axis | axes | false
function parse.axis(str)
	local axes, ret = {"x","y","z"}, {}
	for i,v in ipairs(axes) do
		if str:match(v) then table.insert(ret,v) end
	end
	if #ret > 0 and str:match("^[xyz]+$") then
		return ret
	elseif str == "h" then
		return {"x", "z"}
	elseif  str == "v" then
		return {"y"}
	else return false end
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
		return key_instance.new("err", "Error: \""..tostring(str).."\" is not a string.", 404)
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
		return key_instance.new("axis", axes, sign)
	elseif keywords.dir[str] then
		return key_instance.new("dir", keywords.dir[str], sign)
	elseif keywords.mirroring[str] then
		return key_instance.new("rev", "mirroring")
	else return key_instance.new("err", "Error: \""..str.."\" is not a valid axis, direction or keyword.", 422)
	end
end

--- Creates a vector with a length of (@param: value * @param: sign)
--  on each axis in @param: axes.
-- @param: axes: Table: List of axes to set
-- @param: value: Number: length of to set axes
-- @param: sign: Number: sign multiplier for axes
-- @returns: Vector3: processed vector
function parse.vectorize(axes,value,sign)
	local ret = Vector3.new()
	for i,v in ipairs(axes) do
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
	local expected, tmp = 1, {axes = {}, num = 0, sign = 1, mirror = false}
	function tmp:reset() self.axis, self.sign = "", 1 end
	
	for i,v in ipairs(tbl) do
		if v:sub(1,1) == "+" then v = v:sub(2) end
		tmp.num = parse.num(v)
		if expected == 1 then -- Mode 1 of state machine
			-- State machine expects string
			if tmp.num then
				-- If this is a number treat as all axes and add to appropriate vector
				if tmp.num * tmp.sign >= 0 then
					max = max:add(parse.vectorize({"x","y","z"}, tmp.num, tmp.sign))
				else
					min = min:add(parse.vectorize({"x","y","z"}, tmp.num, tmp.sign))
				end
				-- We are still looking for axes so the state machine should remain
				-- in Mode 1 for the next iteration
			else
				-- Else parse.keyword
				local key_inst = parse.keyword(v)
				-- Stop if error and return message
				if key_inst:is_error() then return false, key_inst.entry end
				-- Check key type and process further
				if key_inst.type == "axis" then
					tmp.axes = key_inst.entry
					tmp.sign = key_inst.sign
				elseif key_inst.type == "dir" then
					tmp.axes = {facing[key_inst.entry].axis}
					tmp.sign = facing[key_inst.entry].sign * key_inst.sign
				elseif key_inst.type == "rev" then
					tmp.mirror = true
				else
					-- If key type is error or unknown throw error and stop
					if key_inst.type == "err" then
						return false, key_inst.entry
					else
						return false, "Error: Unknown Key Instance type \""..
						tostring(key_inst.type).."\". Contact the devs!"
					end
				end
				expected = 2 -- Toggle state machine to expect number (Mode 2)
			end
			
		else -- Mode 2 of state machine
			-- State machine expects number
			if tmp.num then
				-- If this is a number process num and add to appropriate vector
				if tmp.num * tmp.sign >= 0 then
					max = max:add(parse.vectorize(tmp.axes, tmp.num, tmp.sign))
				else
					min = min:add(parse.vectorize(tmp.axes, tmp.num, tmp.sign))
				end
				expected = 1 -- Toggle state machine to expect string (Mode 1)
			else
				-- Else throw an error and stop everything
				return false, "Error: Expected number after \""..tostring(tbl[i-1])..
					"\", got \""..tostring(v).."\"."
			end
		end -- End of state machine
		
	end -- End of main for loop
	
	-- Handle Mirroring
	if tmp.mirror and not sum then
		max = max:max(min:abs())
		min = max:multiply(-1)
	end
	
	if sum then return min:add(max)
	else return min, max end
	
end

return {
	keyword = parse.keyword,
	keytable = parse.keytable,
}
