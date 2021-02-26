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


function worldeditadditions.average(list)
	if #list == 0 then return 0 end
	return worldeditadditions.sum(list) / #list
end

--- Returns the minetest.get_us_time() in ms
-- @return	float
function worldeditadditions.get_ms_time()
	return minetest.get_us_time() / 1000
end

function worldeditadditions.eta(existing_times, done_count, total_count)
		local max = 100
		local average = worldeditadditions.average(
				worldeditadditions.table_get_last(existing_times, max)
		)
		local times_left = total_count - done_count
		if times_left == 0 then return 0 end
		return average * times_left
end

--- Returns the sign (+ or -) at the beginning of a string if present.
-- @param    str        string    Input string.
-- @param    type    string    The type of value to return. Valid values: "string" (default), "int"
-- @return    string|int        Returns the sign string or signed multiplier (1|-1).
function worldeditadditions.getsign(str, type)
		if not type then type = "string" end
		if not (type == "string" or type == "int") then
			return false, "Error: Unknown type '"..type.."'."
		end
		if str:sub(1, 1) == "-" then
				if type == "int" then return -1
				else return "-" end
		else
				if type == "int" then return 1
				else return "+" end
		end
end
