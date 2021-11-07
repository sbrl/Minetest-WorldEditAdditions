local wea = worldeditadditions
local Vector3 = dofile(wea.modpath.."/utils/vector3.lua")


--[[
parse_axes("6",name) == return Vector3.new(6,6,6), Vector3.new(-6,-6,-6)
parse_axes("h 4",name) == return Vector3.new(4,0,4), Vector3.new(-4,0,-4)
parse_axes("v 4",name) == return Vector3.new(0,4,0), Vector3.new(0,-4,0)
parse_axes("-x 4 z 3 5",name) == return Vector3.new(0,0,3), Vector3.new(-4,0,-5)
parse_axes("x -10 y 14 true",name) == return Vector3.new(0,14,0), Vector3.new(-10,-14,0)
parse_axes("x -10 y 14 r",name) == return Vector3.new(0,14,0), Vector3.new(-10,-14,0)
parse_axes("x -10 y 14 rev",name) == return Vector3.new(0,14,0), Vector3.new(-10,-14,0)

-- Assuming player is facing +Z (north)
parse_axes("front 4 y 2 r",name) == return Vector3.new(0,2,4), Vector3.new(0,-2,0)
parse_axes("right 4 y 2 r",name) == return Vector3.new(0,2,0), Vector3.new(-4,-2,0)
]]--

--- Parses an absolute axis name to a Vector3 instance.
-- @example
-- local v3instance = parse_abs_axis_name("-x")
-- -- v3instance will now be equal to Vector3.new(-1, 0, 0)
-- @param	axis_name	string	The axis name to parse.
-- @returns	bool,Vector3|string	A bool success value, followed by the resulting Vector3 instance (if succeeded) or an error message string (if failed).
local function parse_abs_axis_name(axis_name)
	if type(axis_name) ~= "string" then
		return false, "Error: Expected axis_name to be of type string, but found value of type '"..type(axis_name).."' instead."
	end
	
	local result = Vector3.new()
	if axis_name:match("-x") then result.x = -1
	elseif axis_name:match("x") then result.x = 1 end
	if axis_name:match("-y") then result.y = -1
	elseif axis_name:match("y") then result.y = 1 end
	if axis_name:match("-z") then result.z = -1
	elseif axis_name:match("z") then result.z = 1 end
	
	return true, result
end

-- Parses a relative axis name (e.g. "front", "back", etc) to an absolute
-- Vector3 instance.
-- @param	axis_name	string		The axis name to parse.
-- @param	player_name	PlayerDir	The directional information that the parsing should be relative to.
-- @returns	bool,Vector3|string	A bool success value, followed by the resulting Vector3 instance (if succeeded) or an error message string (if failed).
local function parse_relative_axis_name(axis_name, facing_dir)
	if type(axis_name) ~= "string" then
		return false, "Error: Expected axis_name to be of type string, value was of type '"..type(axis_name).."' instead."
	end
	
	local dir
	local flip = Vector3.new(-1, -1, -1)
	
	if axis_name == "?"							then dir = facing_dir.front	end
	if axis_name == "front"	or axis_name == "f"	then dir = facing_dir.front	end
	if axis_name == "back"	or axis_name == "b"	then dir = facing_dir.back	end
	if axis_name == "left"	or axis_name == "l"	then dir = facing_dir.left	end
	if axis_name == "right" or axis_name == "r"	then dir = facing_dir.right end
	if axis_name == "up"	or axis_name == "u"	then dir = facing_dir.up	end
	if axis_name == "down"	or axis_name == "d"	then dir = facing_dir.down	end
	
	if not dir then return false, "Error: Unknown axis name '"..axis_name.."'. Valid values: ?, front, f, back, b, left, l, right, r, up, u, down, d." end
	
	axis_name = (dir.sign < 0 and "-" or "")..dir.axis
	local success, result = parse_abs_axis_name(axis_name)
	if not success then return success, result end
	
	return true, result
end

local function parse_axis_name(axis_name, facing_dir)
	local success, result = parse_relative_axis_name(axis_name, facing_dir)
	if not success then
		success, result = parse_abs_axis_name(axis_name)
	end
	return success, result
end

--- Parses a token list of axes and counts into a Vector3.
-- For example, "x 4" would become { x = 4, y = 0, z = 0 }, and "? 4 -z 10"
-- might become { x = 4, y = 0, z = -10 }.
-- Note that the input here needs to be *pre split*. wea.split_shell is
-- recommended for this purpose.
-- Uses wea.parse.axis for parsing axis names.
-- @param	token_list	string[]	A list of tokens to parse
-- @param	facing_dir	PlayerDir	The direction the player is facing. Returned from wea.player_dir(name).
-- @returns	Vector3,Vector3		A Vector3 pair generated from parsing out the input token list representing the delta change that can be applied to a defined pos1, pos2 region.
local function parse_axes(token_list, facing_dir)
	local pos1, pos2 = Vector3.new(), Vector3.new()
	
	if #token_list < 2 then
		return false, "Error: Not enough arguments (at least 2 are required)"
	end
	
	local state = "AXIS"
	local current_axis = nil
	local current_axis_text = nil
	local success
	
	for i,token in ipairs(token_list) do
		if state == "AXIS" then
			if token == "h" or "horizontal" then
				current_axis_text = "horizontal"
				current_axis = Vector3.new(1, 0, 1)
			elseif token == "v" or token == "vertical" then
				current_axis_text = "vertical"
				current_axis = Vector3.new(0, 1, 0)
			else
				current_axis_text = token
				success, current_axis = parse_axis_name(token, facing_dir)
				if not success then return success, current_axis end
			end
			state = "VALUE"
		elseif state == "VALUE" then
			local offset_this = tonumber(token)
			if not offset_this then
				return false, "Error: Invalid count value '"..tostring(token).."' for axis '"..current_axis_text.."'. Values may only be positive or negative integers."
			end
			
			offset_this = current_axis * offset_this
			
			-- Apply the new offset to the virtual defined region
			if current_axis_text == "horizontal" or current_axis_text == "vertical" then
				-- We're horizonal / vertical
				pos1 = pos1 + (offset_this * -1)
				pos2 = pos2 + offset_this
			else
				-- It's a specific axis
				if offset_this.x < 0 then pos1.x = pos1.x + offset_this.x
				else pos2.x = pos2.x + offset_this.x end
				if offset_this.y < 0 then pos1.y = pos1.y + offset_this.y
				else pos2.y = pos2.y + offset_this.y end
				if offset_this.z < 0 then pos1.z = pos1.z + offset_this.z
				else pos2.z = pos2.z + offset_this.z end
			end
			
			state = "AXIS"
		else
			return false, "Error: Failed to parse input due to unknown state '"..tostring(state).."' (this is probably a bug - please report it!)"
		end
	end
	
	return true, pos1, pos2
end

return parse_axes
