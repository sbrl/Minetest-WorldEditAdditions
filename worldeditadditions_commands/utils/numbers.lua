local we_c = worldeditadditions_commands

-- From http://lua-users.org/wiki/SimpleRound
function we_c.round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end
