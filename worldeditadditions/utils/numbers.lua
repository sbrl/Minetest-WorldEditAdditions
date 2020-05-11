-- From http://lua-users.org/wiki/SimpleRound
function worldeditadditions.round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end
