worldeditadditions.vector = {}

function worldeditadditions.vector.tostring(v)
	if not v then return "(nil)" end
	return "(" .. v.x ..", " .. v.y ..", " .. v.z ..")"
end

-- Calculates the length squared of the given vector.
-- @param	v	Vector	The vector to operate on
-- @return	number		The length of the given vector squared
function worldeditadditions.vector.lengthsquared(v)
	if not v.y then return v.x*v.x + v.z*v.z end
	return v.x*v.x + v.y*v.y + v.z*v.z
end

--- Normalises the given vector such that its length is 1.
-- Also known as calculating the unit vector.
-- This method does *not* mutate.
-- @param	v	Vector	The vector to calculate from.
-- @return	Vector		A new normalised vector.
function worldeditadditions.vector.normalize(v)
	local length = math.sqrt(worldeditadditions.vector.lengthsquared(v))
	if not v.y then return {
		x = v.x / length,
		z = v.z / length
	} end
	return {
		x = v.x / length,
		y = v.y / length,
		z = v.z / length
	}
end

--- Rounds the values in a vector down.
-- Warning: This MUTATES the given vector!
-- @param	v	Vector	The vector to operate on
function worldeditadditions.vector.floor(v)
	v.x = math.floor(v.x)
	-- Some vectors are 2d, but on the x / z axes
	if v.y then v.y = math.floor(v.y) end
	-- Some vectors are 2d
	if v.z then v.z = math.floor(v.z) end
end

--- Determines if the target point is contained within the defined worldedit region.
-- @param	pos1	Vector	pos1 of the defined region.
-- @param	pos2	Vector	pos2 of the defined region.
-- @param	target	Vector	The target vector to check.
-- @return	boolean	Whether the given target is contained within the defined worldedit region.
function worldeditadditions.vector.is_contained(pos1, pos2, target)
	local pos1, pos2 = worldedit.sort_pos(pos1, pos2)
	return pos1.x >= target.x
		and pos1.y >= target.y
		and pos1.z >= target.z
		and pos2.x <= target.x
		and pos2.y <= target.y
		and pos2.z <= target.z
end

--- Expands the defined region to include the given point.
-- @param	pos1	Vector	pos1 of the defined region.
-- @param	pos2	Vector	pos2 of the defined region.
-- @param	target	Vector	The target vector to include.
function worldeditadditions.vector.expand_region(pos1, pos2, target)
	local pos1, pos2 = worldedit.sort_pos(pos1, pos2)
	
	if target.x < pos1.x then pos1.x = target.x end
	if target.y < pos1.y then pos1.y = target.y end
	if target.z < pos1.z then pos1.z = target.z end
	
	if target.x > pos2.x then pos2.x = target.x end
	if target.y > pos2.y then pos2.y = target.y end
	if target.z > pos2.z then pos2.z = target.z end
	
	return pos1, pos2
end
