local weac = worldeditadditions_core
local Vector3 = weac.Vector3

-- From worldedit_hub_helper.
-- Written by me, @sbrl and just lifted :-)
local function calc_rotation_text(rotation)
	if rotation <= math.pi / 4 or rotation >= (7 * math.pi) / 4 then
		return Vector3.new(0, 0, 1)		-- +z
	elseif rotation > math.pi / 4 and rotation <= (3 * math.pi) / 4 then
		return Vector3.new(-1, 0, 0)	-- -x
	elseif rotation > (3 * math.pi) / 4 and rotation <= (5 * math.pi) / 4 then
		return Vector3.new(0, 0, -1)	-- -z
	else
		return Vector3.new(1, 0, 0)		-- +x
	end
end

local function rot_axis_left(axis)
	if axis.x == 1 or axis.x == -1 then
		axis.x, axis.z = 0, axis.x
	elseif axis.z == 1 or axis.z == -1 then
		axis.x, axis.z = -axis.z, 0
	end
	return axis -- CAUTION, this function mutates!
end

--- Parses an axis name into a string.
-- Currently handles:
-- - x/y/z -x/-y/-z
-- - front → downwards pitch
-- - back → upwards pitch
-- - left → rotate around Z to left
-- - right → rotate around Z to right
-- - pitch, yaw, roll - clockwise is considered positive.
-- @param	str				string	The axis to parse, as a single (pre-trimmed) string.
-- @param	[player=nil]	Player	Optional. A Minetest Player object representing the player to make any relative keywords like front-back/pitch/roll/etc relative to in parsing. Defautls to nil, which disables parsing of relatiive terms. Any object passed just needs to support player:get_look_horizontal(): https://github.com/minetest/minetest/blob/master/doc/lua_api.md#player-only-no-op-for-other-objects
-- @returns	bool,Vector3|string			A success bool (false=failure) followed by either an error message (if success=false) or otherwise the axis name, parsed into a Vector3 instance.
local function parse_rotation_axis_name(str, player)
	local vector = Vector3.new(0, 0, 0)
	
	-- At most ONE of these cases is true at a time.
	-- Even if it were possible to handle more than one (which it isn't without quaternions which aren't used in the backend), we would have an undefined ordering problem with the application of such rotations. Rotations ≠ translations in this case!
	if		str:find("x", 1, true)		then vector.x = 1
	elseif	str:find("y", 1, true)		then vector.y = 1
	elseif	str:find("z", 1, true)		then vector.z = 1
	elseif	str:find("left", 1, true)
			or str:find("l$")			then vector.y = -1
	elseif	str:find("right", 1, true)
			or str:find("r$")
			or str:find("yaw")			then vector.y = 1
	elseif type(player) ~= "nil"			then
		local player_rotation_h = calc_rotation_text(player:get_look_horizontal())
		
		-- FRONT BACK
		
		if str:find("front", 1, true)
			or str:find("f$")
			or str:find("pitch", 1, true)	then
			vector = rot_axis_left(player_rotation_h)
		elseif str:find("back", 1, true)
				or str:find("b$")	then
			vector = rot_axis_left(player_rotation_h) * -1
		elseif str:find("roll", 1, true)	then
			vector = player_rotation_h
		else
			return false, "Error: Could not understand rotational axis keyword '"..str.."'."
		end
	else
		return false, "Error: Could not understand rotational axis keyword '" .. str .. "'."
	end
	
	--- Handle negatives
	if str:sub(1, 1) == "-" then
		vector = vector * -1
	end
	
	return true, vector
end


return {
	axis_name = parse_rotation_axis_name
}