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

function worldeditadditions.eta(existing_times, times_total_count)
    local average = worldeditadditions.average(existing_times)
    local times_left = times_total_count - #existing_times
    if times_left == 0 then return 0 end
    return average * times_left
end
