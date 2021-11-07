local wea = worldeditadditions
local Vector3 = dofile(wea.modpath.."/utils/vector3.lua")
-- BUG: This does not exist yet - need to merge @VorTechnix's branch first to get it
-- TODO: Uncomment then once it's implemented
-- local parse_axis = dofile(wea.modpath.."/utils/axis.lua")

--- Parses a token list of axes and counts into a Vector3.
-- For example, "x 4" would become { x = 4, y = 0, z = 0 }, and "? 4 -z 10"
-- might become { x = 4, y = 0, z = -10 }.
-- Note that the input here needs to be *pre split*. wea.split_shell is
-- recommended for this purpose.
-- Uses wea.parse.axis for parsing axis names.
-- @param	token_list	string[]	A list of tokens to parse
-- @returns	Vector3		A Vector3 generated from parsing out the input token list.
local function parse_axes(token_list)
	local vector_result = wea.Vector3.new()
	
	if #token_list < 2 then
		return false, "Error: Not enough arguments (at least 2 are required)"
	end
	
	local state = "AXIS"
	local current_axis = nil
	local success
	
	for i,token in ipairs(token_list) do
		if state == "AXIS" then
			success, current_axis = parse_axis(token)
			if not success then return success, current_axis end
			state = "VALUE"
		elseif state == "VALUE" then
			
			local offset_this = tonumber(token)
			if not offset_this then
				return false, "Error: Invalid count value for axis '"..current_axis.."'. Values may only be positive or negative integers."
			end
			
			-- Handle negative axes
			if current_axis:sub(1, 1) == "-" then
				offset_this = -offset_this
				current_axis = current_axis:sub(2, 2)
			end
			
			vector_result[current_axis] = vector_result[current_axis] + offset_this
			
			state = "AXIS"
		else
			return false, "Error: Failed to parse input due to unknown state '"..tostring(state).."' (this is probably a bug - please report it!)"
		end
	end
	
	return vector_result
end

return parse_axes
