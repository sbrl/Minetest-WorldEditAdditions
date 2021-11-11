local Vector3 
if worldeditadditions then
	local wea = worldeditadditions
	Vector3 = dofile(wea.modpath.."/utils/vector3.lua")
else
	Vector3 = require("worldeditadditions.utils.vector3")
end

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
	
	if Vector3.new() == result then
		return false, "Error: Unknown axis_name '"..axis_name.."'."
	end
	
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

--- Parses a relative or absolute axis name into a Vector3 instance.
-- @param	axis_name	string	The axis name to parse.
-- @param	facing_dir	table	The direction the player is facing. Obtain this by calling worldeditadditions.
local function parse_axis_name(axis_name, facing_dir)
	local success, result = parse_relative_axis_name(axis_name, facing_dir)
	if not success then
		success, result = parse_abs_axis_name(axis_name)
	end
	return success, result
end

local function vregion_apply(vpos1, vpos2, offset)
	-- It's a specific axis
	if offset.x < 0 then vpos1.x = vpos1.x + offset.x
	else vpos2.x = vpos2.x + offset.x end
	if offset.y < 0 then vpos1.y = vpos1.y + offset.y
	else vpos2.y = vpos2.y + offset.y end
	if offset.z < 0 then vpos1.z = vpos1.z + offset.z
	else vpos2.z = vpos2.z + offset.z end
	
	return vpos1, vpos2
end

local function in_list(list, str)
	for i,item in ipairs(list) do
		if item == str then return true end
	end
	return false
end

--- Parses a token list of axes and counts into a Vector3.
-- For example, "x 4" would become { x = 4, y = 0, z = 0 }, and "? 4 -z 10"
-- might become { x = 4, y = 0, z = -10 }.
-- Note that the input here needs to be *post split*. wea.split_shell is
-- recommended for this purpose.
-- @param	token_list	string[]	A list of tokens to parse
-- @param	facing_dir	PlayerDir	The direction the player is facing. Returned from wea.player_dir(name).
-- @returns	Vector3,Vector3		A Vector3 pair generated from parsing out the input token list representing the delta change that can be applied to a defined pos1, pos2 region.
local function parse_axes(token_list, facing_dir)
	local mirroring_keywords = {
		"sym", "symmetrical",
		"mirror", "mir",
		"rev", "reverse",
		"true"
	}
	
	if type(token_list) ~= "table" then
		return false, "Error: Expected list of tokens as a table, but found value of type '"..type(token_list).."' instead."
	end
	if type(facing_dir) ~= "table" then
		return false, "Error: Expected facing_dir to be a table, but found value of type '"..type(facing_dir).."' instead."
	end
	
	local vpos1, vpos2 = Vector3.new(), Vector3.new()
	
	if #token_list < 2 then
		return false, "Error: Not enough arguments (at least 2 are required)"
	end
	
	local state = "AXIS"
	local current_axis = nil
	local current_axis_text = nil
	local success
	
	-- for i,token in ipairs(token_list) do
	for i=1,#token_list do
		local token = token_list[i]
		local token_next
		if i < #token_list then token_next = token_list[i + 1] end
		
		if type(token) ~= "string" then
			return false, "Error: Found token of unexpected type '"..type(token).."' at position "..i.."."
		end
		
		-- print("DEBUG i", i, "token", token)
		
		if state == "AXIS" then
			if token == "h" or token == "horizontal" then
				current_axis_text = "horizontal"
				current_axis = Vector3.new(1, 0, 1)
			elseif token == "v" or token == "vertical" then
				current_axis_text = "vertical"
				current_axis = Vector3.new(0, 1, 0)
			elseif not in_list(mirroring_keywords, token) then
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
			
			-- print("DEBUG STATE VALUE offset_this", offset_this)
			
			-- Apply the new offset to the virtual defined region
			if current_axis_text == "horizontal" or current_axis_text == "vertical" then
				-- We're horizonal / vertical
				vpos1 = vpos1 + (offset_this * -1)
				vpos2 = vpos2 + offset_this
			else
				vpos1, vpos2 = vregion_apply(vpos1, vpos2, offset_this)
				-- Handle the extra mirroring keyword
				if in_list(mirroring_keywords, token_next) then
						vpos1, vpos2 = vregion_apply(vpos1, vpos2, offset_this * -1)
				end
			end
			
			state = "AXIS"
		else
			return false, "Error: Failed to parse input due to unknown state '"..tostring(state).."' (this is probably a bug - please report it!)"
		end
	end
	
	return true, vpos1, vpos2
end

return {
	parse_axes = parse_axes,
	parse_axis_name = parse_axis_name,
	parse_abs_axis_name = parse_abs_axis_name,
	parse_relative_axis_name = parse_relative_axis_name
}
