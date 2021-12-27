-- From http://lua-users.org/wiki/SimpleRound
function worldeditadditions.round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

function worldeditadditions.hypotenuse(x1, y1, x2, y2)
	local xSquare = math.pow(x1 - x2, 2);
	local ySquare = math.pow(y1 - y2, 2);
	return math.sqrt(xSquare + ySquare);
end

function worldeditadditions.sum(list)
		if #list == 0 then return 0 end
	local sum = 0
	for i,value in ipairs(list) do
		sum = sum + value
	end
		return sum
end

--- Calculates the mean of all the numbers in the given list.
-- @param	list	number[]	The list (table) of numbers to calculate the mean for.
-- @returns	The mean of the numbers in the given table.
function worldeditadditions.average(list)
	if #list == 0 then return 0 end
	return worldeditadditions.sum(list) / #list
end

--- Finds the minimum value in the given list.
-- @param	list	number[]	The list (table) of numbers to find the minimum value of.
-- @returns	number	The minimum value in the given list.
function worldeditadditions.min(list)
	if #list == 0 then return nil end
	local min = nil
	for i,value in pairs(list) do
		if min == nil or min > value then
			min = value
		end
	end
	return min
end

--- Finds the maximum value in the given list.
-- @param	list	number[]	The list (table) of numbers to find the maximum value of.
-- @returns	number	The maximum value in the given list.
function worldeditadditions.max(list)
	if #list == 0 then return nil end
	-- We use pairs() instead of ipairs() here, because then we can support
	-- zero-indexed 1D heightmaps too - and we don't care that the order is
	-- undefined with pairs().
	local max = nil
	for i,value in pairs(list) do
		if max == nil or max < value then
			max = value
		end
	end
	return max
end


--- Returns the minetest.get_us_time() in ms
-- @return	float
function worldeditadditions.get_ms_time()
	return minetest.get_us_time() / 1000
end

--- Calculates the estimated time remaining from a list of times.
-- Intended to be used where one has a number of works units, and one has a
-- list of how long the most recent units have taken to run.
-- @param	existing_times	number[]	A list of times - in ms - that the most recent work units have taken.
-- @param	done_count		number		The number of work units completed so far.
-- @param	total_count		number		The total number of work units to be completed.
function worldeditadditions.eta(existing_times, done_count, total_count)
	local max = 100
	local average = worldeditadditions.average(
		worldeditadditions.table.get_last(existing_times, max)
	)
	local times_left = total_count - done_count
	if times_left == 0 then return 0 end
	return average * times_left
end

--- Returns the sign (+ or -) at the beginning of a string if present.
-- @param	src	string|int	Input string.
-- @return	string|int	Returns the signed multiplier (1|-1).
function worldeditadditions.getsign(src)
	if type(src) == "number" then
		if src < 0 then return -1 else return 1 end
	elseif type(src) ~= "string" then return 1
	else
		if src:match('-') then return -1 else return 1 end
	end
end

--- Clamp a number to ensure it falls within a given range.
-- @param	value	number	The value to clamp.
-- @param	min		number	The minimum allowed value.
-- @param	max		number	The maximum allowed value.
-- @returns	number	The clamped number.
function worldeditadditions.clamp(value, min, max)
	if value < min then return min end
	if value > max then return max end
	return value
end

-- For Testing:
-- worldeditadditions = {}
-- print(worldeditadditions.getsign('-y'))
