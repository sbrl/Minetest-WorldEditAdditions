local wea_c = worldeditadditions_core

-- From http://lua-users.org/wiki/SimpleRound
function wea_c.round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

function wea_c.hypotenuse(x1, y1, x2, y2)
	local xSquare = (x1 - x2) ^ 2;
	local ySquare = (y1 - y2) ^ 2;
	return math.sqrt(xSquare + ySquare);
end

function wea_c.sum(list)
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
function wea_c.average(list)
	if #list == 0 then return 0 end
	return wea_c.sum(list) / #list
end

--- Finds the minimum value in the given list.
-- @param	list	number[]	The list (table) of numbers to find the minimum value of.
-- @returns	number	The minimum value in the given list.
function wea_c.min(list)
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
function wea_c.max(list)
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
function wea_c.get_ms_time()
	return minetest.get_us_time() / 1000
end

--- Calculates the estimated time remaining from a list of times.
-- Intended to be used where one has a number of works units, and one has a
-- list of how long the most recent units have taken to run.
-- @param	existing_times	number[]	A list of times - in ms - that the most recent work units have taken.
-- @param	done_count		number		The number of work units completed so far.
-- @param	total_count		number		The total number of work units to be completed.
function wea_c.eta(existing_times, done_count, total_count)
	local max = 100
	local average = wea_c.average(
		wea_c.table.get_last(existing_times, max)
	)
	local times_left = total_count - done_count
	if times_left == 0 then return 0 end
	return average * times_left
end

--- Returns the sign (+ or -) at the beginning of a string if present.
-- @param	src	string|int	Input string.
-- @return	string|int	Returns the signed multiplier (1|-1).
function wea_c.getsign(src)
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
function wea_c.clamp(value, min, max)
	if value < min then return min end
	if value > max then return max end
	return value
end

--- Return a sequence of numbers as a list.
-- @example
-- local result = worldeditadditions_core.range(0, 10, 1)
-- -- [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ]
-- @example
-- local result = worldeditadditions_core.range(6, 12, 2)
-- -- [ 6, 8, 10, 12 ]
-- @param	min		number		The minimum value in the sequence.
-- @param	max		number		The maximum value in the sequence.
-- @param	step	number		The value to increment between each value in the sequence.
-- @returns	number[]	The list of numbers.
function wea_c.range(min, max, step)
	local result = {}
	for i = min, max, step do
		table.insert(result, i)
	end
	return result
end

-- For Testing:
-- wea_c = {}
-- print(wea_c.getsign('-y'))
