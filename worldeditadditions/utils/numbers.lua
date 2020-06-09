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
