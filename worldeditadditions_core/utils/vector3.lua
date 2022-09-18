--- A 3-dimensional vector.
-- @class
local Vector3 = {}
Vector3.__index = Vector3
Vector3.__name = "Vector3" -- A hack to allow identification in wea.inspect

--- Creates a new Vector3 instance.
-- @param x		number	The x co-ordinate value.
-- @param y		number	The y co-ordinate value.
-- @param z		number	The z co-ordinate value.
function Vector3.new(x, y, z)
	x = x or 0
	y = y or 0
	z = z or 0
	
	local result = {
		x = x,
		y = y,
		z = z
	}
	setmetatable(result, Vector3)
	return result
end

--- Returns a new instance of this vector.
-- @param	a			Vector3		The vector to clone.
-- @returns	Vector3		A new vector whose values are identical to those of the original vector.
function Vector3.clone(a)
	return Vector3.new(a.x, a.y, a.z)
end

--- Adds the specified vectors or numbers together.
-- Returns the result as a new vector.
-- If 1 of the inputs is a number and the other a vector, then the number will
-- be added to each of the components of the vector.
-- @param	a	Vector3|number	The first item to add.
-- @param	a	Vector3|number	The second item to add.
-- @returns	Vector3				The result as a new Vector3 object.
function Vector3.add(a, b)
	if type(a) == "number" then
		return Vector3.new(b.x + a, b.y + a, b.z + a)
	elseif type(b) == "number" then
		return Vector3.new(a.x + b, a.y + b, a.z + b)
	end
	return Vector3.new(a.x + b.x, a.y + b.y, a.z + b.z)
end

--- Subtracts the specified vectors or numbers together.
-- Returns the result as a new vector.
-- If 1 of the inputs is a number and the other a vector, then the number will
-- be subtracted to each of the components of the vector.
-- @param	a	Vector3|number	The first item to subtract.
-- @param	a	Vector3|number	The second item to subtract.
-- @returns	Vector3				The result as a new Vector3 object.
function Vector3.subtract(a, b)
	if type(a) == "number" then
		return Vector3.new(b.x - a, b.y - a, b.z - a)
	elseif type(b) == "number" then
		return Vector3.new(a.x - b, a.y - b, a.z - b)
	end
	return Vector3.new(a.x - b.x, a.y - b.y, a.z - b.z)
end
--- Alias for Vector3.subtract.
function Vector3.sub(a, b) return Vector3.subtract(a, b) end

--- Multiplies the specified vectors or numbers together.
-- Returns the result as a new vector.
-- If 1 of the inputs is a number and the other a vector, then the number will
-- be multiplied to each of the components of the vector.
--
-- If both of the inputs are vectors, then the components are multiplied
-- by each other (NOT the cross product). In other words:
-- a.x * b.x, a.y * b.y, a.z * b.z
--
-- @param	a	Vector3|number	The first item to multiply.
-- @param	a	Vector3|number	The second item to multiply.
-- @returns	Vector3				The result as a new Vector3 object.
function Vector3.multiply(a, b)
	if type(a) == "number" then
		return Vector3.new(b.x * a, b.y * a, b.z * a)
	elseif type(b) == "number" then
		return Vector3.new(a.x * b, a.y * b, a.z * b)
	end
	return Vector3.new(a.x * b.x, a.y * b.y, a.z * b.z)
end
--- Alias for Vector3.multiply.
function Vector3.mul(a, b) return Vector3.multiply(a, b) end

--- Divides the specified vectors or numbers together.
-- Returns the result as a new vector.
-- If 1 of the inputs is a number and the other a vector, then the number will
-- be divided to each of the components of the vector.
-- @param	a	Vector3|number	The first item to divide.
-- @param	a	Vector3|number	The second item to divide.
-- @returns	Vector3				The result as a new Vector3 object.
function Vector3.divide(a, b)
	if type(a) == "number" then
		return Vector3.new(b.x / a, b.y / a, b.z / a)
	elseif type(b) == "number" then
		return Vector3.new(a.x / b, a.y / b, a.z / b)
	end
	return Vector3.new(a.x / b.x, a.y / b.y, a.z / b.z)
end
--- Alias for Vector3.divide.
function Vector3.div(a, b) return Vector3.divide(a, b) end


--- Rounds the components of this vector down.
-- @param 	a		Vector3		The vector to operate on.
-- @returns	Vector3	A new instance with the x/y/z components rounded down.
function Vector3.floor(a)
	return Vector3.new(math.floor(a.x), math.floor(a.y), math.floor(a.z))
end
--- Rounds the components of this vector up.
-- @param 	a		Vector3		The vector to operate on.
-- @returns	Vector3	A new instance with the x/y/z components rounded up.
function Vector3.ceil(a)
	return Vector3.new(math.ceil(a.x), math.ceil(a.y), math.ceil(a.z))
end
--- Rounds the components of this vector.
-- @param 	a		Vector3		The vector to operate on.
-- @returns	Vector3	A new instance with the x/y/z components rounded.
function Vector3.round(a)
	return Vector3.new(math.floor(a.x+0.5), math.floor(a.y+0.5), math.floor(a.z+0.5))
end


--- Snaps this Vector3 to an imaginary square grid with the specified sized
-- squares.
-- @param 	a		Vector3		The vector to operate on.
-- @param	number	grid_size	The size of the squares on the imaginary grid to which to snap.
-- @returns	Vector3	A new Vector3 instance snapped to an imaginary grid of the specified size.
function Vector3.snap_to(a, grid_size)
	return (a / grid_size):round() * grid_size
end

--- Returns the area of this vector.
-- In other words, multiplies all the components together and returns a scalar value.
-- @param	a		Vector3		The vector to return the area of.
-- @returns	number	The area of this vector.
function Vector3.area(a)
	return a.x * a.y * a.z
end

--- Returns the scalar length of this vector squared.
-- @param	a		Vector3		The vector to operate on.
-- @returns	number	The length squared of this vector as a scalar value.
function Vector3.length_squared(a)
	return a.x * a.x + a.y * a.y + a.z * a.z
end

--- Square roots each component of this vector.
-- @param	a		Vector3		The vector to operate on.
-- @returns	number	A new vector with each component square rooted.
function Vector3.sqrt(a)
	return Vector3.new(math.sqrt(a.x), math.sqrt(a.y), math.sqrt(a.z))
end

--- Calculates the scalar length of this vector.
-- @param	a		Vector3		The vector to operate on.
-- @returns	number	The length of this vector as a scalar value.
function Vector3.length(a)
	return math.sqrt(a:length_squared())
end

--- Calculates the dot product of this vector and another vector.
-- @param	a		Vector3		The first vector to operate on.
-- @param	a		Vector3		The second vector to operate on.
-- @returns	number	The dot product of this vector as a scalar value.
function Vector3.dot(a, b)
	return a.x * b.x + a.y * b.y + a.z * b.z;
end
--- Alias of Vector3.dot.
function Vector3.dot_product(a, b)
	return Vector3.dot(a, b)
end

--- Determines if 2 vectors are equal to each other.
-- 2 vectors are equal if their values are identical.
-- @param	a		Vector3		The first vector to test.
-- @param	a		Vector3		The second vector to test.
-- @returns	bool	Whether the 2 vectors are equal or not.
function Vector3.equals(a, b)
	return a.x == b.x
		and a.y == b.y
		and a.z == b.z
end

--- Returns a new vector whose length clamped to the given length.
-- The direction in which the vector is pointing is not changed.
-- @param	a		Vector3		The vector to operate on.
-- @returns	Vector3	A new Vector3 instance limited to the specified length.
function Vector3.limit_to(a, length)
	if type(length) ~= "number" then error("Error: Expected number, but found "..type(length)..".") end
	
	if a:length() > length then
		return (a / a:length()) * length
	end
	return a:clone()
end

--- Returns a new vector whose length clamped to the given length.
-- The direction in which the vector is pointing is not changed.
-- @param	a		Vector3		The vector to operate on.
-- @returns	Vector3	A new Vector3 instance limited to the specified length.
function Vector3.set_to(a, length)
	if type(length) ~= "number" then error("Error: Expected number, but found "..type(length)..".") end
	
	return (a / a:length()) * length
end

--- Returns the unit vector of this vector.
-- The unit vector is a vector with a length of 1.
-- Returns a new vector.
-- Does not change the direction of the vector.
-- @param	a		Vector3		The vector to operate on.
-- @returns	Vector3	The unit vector of this vector.
function Vector3.unit(a)
	return a / a:length()
end
--- Alias of Vector3.unit.
function Vector3.normalise(a) return a:unit() end


--- Return a vector that is amount distance towards b from a.
-- @param	a		Vector3		The vector to move from.
-- @param	b		Vector3		The vector to move towards.
-- @param	amount	number		The amount to move.
function Vector3.move_towards(a, b, amount)
	return a + (b - a):limit_to(amount)
end

--- Returns the value of the minimum component of the vector.
-- Returns a scalar value.
-- @param	a		Vector3		The vector to operate on.
-- @returns	number	The value of the minimum component of the vector.
function Vector3.min_component(a)
	return math.min(a.x, a.y, a.z)
end

--- Returns the value of the maximum component of the vector.
-- Returns a scalar value.
-- @param	a		Vector3		The vector to operate on.
-- @returns	number	The value of the maximum component of the vector.
function Vector3.max_component(a)
	return math.max(a.x, a.y, a.z)
end

--- Returns the absolute form of this vector.
-- In other words, it removes the minus sign from all components of the vector.
-- @param	a		Vector3		The vector to operate on.
-- @returns	Vector3	The absolute form of the given vector.
function Vector3.abs(a)
	return Vector3.new(math.abs(a.x), math.abs(a.y), math.abs(a.z))
end

--- Sorts the components of the given vectors.
-- pos1 will contain the minimum values, and pos2 the maximum values.
-- Returns 2 new vectors.
-- Note that for this specific function
-- the vectors provided do not *have* to be instances of Vector3.
-- It is only required that they have the keys x, y, and z.
-- Vector3 instances are always returned.
-- This enables convenient ingesting of positions from outside.
-- @param	pos1	Vector3		The first vector to operate on.
-- @param	pos2	Vector3		The second vector to operate on.
-- @returns	Vector3,Vector3		The 2 sorted vectors (min, max).
function Vector3.sort(pos1, pos2)
	local pos1_new = Vector3.clone(pos1) -- This way we can accept non-Vector3 instances
	local pos2_new = Vector3.clone(pos2) -- This way we can accept non-Vector3 instances
	if pos1_new.x > pos2_new.x then
		pos1_new.x, pos2_new.x = pos2_new.x, pos1_new.x
	end
	if pos1_new.y > pos2_new.y then
		pos1_new.y, pos2_new.y = pos2_new.y, pos1_new.y
	end
	if pos1_new.z > pos2_new.z then
		pos1_new.z, pos2_new.z = pos2_new.z, pos1_new.z
	end
	return pos1_new, pos2_new
end

--- Determines if this vector is contained within the region defined by the given vectors.
-- @param	a		Vector3		The target vector to check.
-- @param	pos1	Vector3		pos1 of the defined region.
-- @param	pos2	Vector3		pos2 of the defined region.
-- @return	boolean	Whether the given target is contained within the defined worldedit region.
function Vector3.is_contained(target, pos1, pos2)
	local pos1, pos2 = Vector3.sort(pos1, pos2)
	
	return pos1.x <= target.x
		and pos1.y <= target.y
		and pos1.z <= target.z
		and pos2.x >= target.x
		and pos2.y >= target.y
		and pos2.z >= target.z
end

--- Clamps the given point to fall within the region defined by 2 points.
-- @param	a		Vector3		The target vector to clamp.
-- @param	pos1	Vector3	pos1 of the defined region.
-- @param	pos2	Vector3	pos2 of the defined region.
-- @returns	Vector3	The target vector, clamped to fall within the defined region.
function Vector3.clamp(a, pos1, pos2)
	pos1, pos2 = Vector3.sort(pos1, pos2)
	
	return Vector3.min(Vector3.max(a, pos1), pos2)
end


--- Expands the defined region to include the given point.
-- @param	target	Vector3	The target vector to include.
-- @param	pos1	Vector3	pos1 of the defined region.
-- @param	pos2	Vector3	pos2 of the defined region.
-- @returns	Vector3,Vector3		2 vectors that represent the expand_region.
function Vector3.expand_region(target, pos1, pos2)
	local pos1, pos2 = Vector3.sort(pos1, pos2)
	
	if target.x < pos1.x then pos1.x = target.x end
	if target.y < pos1.y then pos1.y = target.y end
	if target.z < pos1.z then pos1.z = target.z end
	
	if target.x > pos2.x then pos2.x = target.x end
	if target.y > pos2.y then pos2.y = target.y end
	if target.z > pos2.z then pos2.z = target.z end
	
	return pos1, pos2
end

--- Returns the mean (average) of 2 positions.
-- In other words, returns the centre of 2 points.
-- @param	pos1	Vector3|number	pos1 of the defined region.
-- @param	pos2	Vector3|number	pos2 of the defined region.
-- @param	target	Vector3	Centre coordinates.
function Vector3.mean(pos1, pos2)
	return (pos1 + pos2) / 2
end


--- Returns a vector of the min components of 2 vectors.
-- @param	pos1	Vector3|number	The first vector to operate on.
-- @param	pos2	Vector3|number	The second vector to operate on.
-- @return	Vector3	The minimum values from the input vectors
function Vector3.min(pos1, pos2)
	if type(pos1) == "number" then
		pos1 = Vector3.new(pos1, pos1, pos1)
	end
	if type(pos2) == "number" then
		pos2 = Vector3.new(pos2, pos2, pos2)
	end
	return Vector3.new(
		math.min(pos1.x, pos2.x),
		math.min(pos1.y, pos2.y),
		math.min(pos1.z, pos2.z)
	)
end

--- Returns a vector of the max values of 2 vectors.
-- @param	pos1	Vector3		The first vector to operate on.
-- @param	pos2	Vector3		The second vector to operate on.
-- @return	Vector3		The maximum values from the input vectors.
function Vector3.max(pos1, pos2)
	if type(pos1) == "number" then
		pos1 = Vector3.new(pos1, pos1, pos1)
	end
	if type(pos2) == "number" then
		pos2 = Vector3.new(pos2, pos2, pos2)
	end
	return Vector3.new(
		math.max(pos1.x, pos2.x),
		math.max(pos1.y, pos2.y),
		math.max(pos1.z, pos2.z)
	)
end

--- Given 2 angles and a length, return a Vector3 pointing in that direction.
-- Consider a sphere, with the 2 angles defining a point on the sphere's surface.
-- This function returns that point as a Vector3.
-- @source	https://math.stackexchange.com/a/1881767/221181
-- @param	angle_x		number	The X angle.
-- @param	angle_y		number	The Y angle.
-- @param	length		number	The radius of the sphere in question.
-- @returns	Vector3		The point on the sphere defined by the aforementioned parameters.
function Vector3.fromBearing(angle_x, angle_y, length)
	return Vector3.new( -- X and Y swapped
		length * math.cos(angle_x),
		length * math.sin(angle_x) * math.sin(angle_y),
		length * math.sin(angle_x) * math.cos(angle_y)
	)
end



--  ██████  ██████  ███████ ██████   █████  ████████  ██████  ██████
-- ██    ██ ██   ██ ██      ██   ██ ██   ██    ██    ██    ██ ██   ██
-- ██    ██ ██████  █████   ██████  ███████    ██    ██    ██ ██████
-- ██    ██ ██      ██      ██   ██ ██   ██    ██    ██    ██ ██   ██
--  ██████  ██      ███████ ██   ██ ██   ██    ██     ██████  ██   ██
--
--  ██████  ██    ██ ███████ ██████  ██████  ██ ██████  ███████ ███████
-- ██    ██ ██    ██ ██      ██   ██ ██   ██ ██ ██   ██ ██      ██
-- ██    ██ ██    ██ █████   ██████  ██████  ██ ██   ██ █████   ███████
-- ██    ██  ██  ██  ██      ██   ██ ██   ██ ██ ██   ██ ██           ██
--  ██████    ████   ███████ ██   ██ ██   ██ ██ ██████  ███████ ███████

function Vector3.__call(x, y, z) return Vector3.new(x, y, z) end

function Vector3.__add(a, b)
	return Vector3.add(a, b)
end

function Vector3.__sub(a, b)
	return Vector3.sub(a, b)
end

function Vector3.__mul(a, b)
	return Vector3.mul(a, b)
end

function Vector3.__div(a, b)
	return Vector3.divide(a, b)
end

function Vector3.__eq(a, b)
	return Vector3.equals(a, b)
end

--- Returns the current Vector3 as a string.
function Vector3.__tostring(a)
	return "("..a.x..", "..a.y..", "..a.z..")"
end

function Vector3.__concat(a, b)
	if type(a) ~= "string" then a = tostring(a) end
	if type(b) ~= "string" then b = tostring(b) end
	return a .. b
end


return Vector3
