worldeditadditions.vector = {}

function worldeditadditions.vector.tostring(v)
	return "(" .. v.x ..", " .. v.y ..", " .. v.z ..")"
end

-- Calculates the length squared of the given vector.
-- @param	v	Vector	The vector to operate on
-- @return	number		The length of the given vector squared
function worldeditadditions.vector.lengthsquared(v)
	return v.x*v.x + v.y*v.y + v.z*v.z
end

--- Normalises the given vector such that its length is 1.
-- Also known as calculating the unit vector.
-- This method does *not* mutate.
-- @param	v	Vector	The vector to calculate from.
-- @return	Vector		A new normalised vector.
function worldeditadditions.vector.normalize(v)
	local length = math.sqrt(worldeditadditions.vector.lengthsquared(v))
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
