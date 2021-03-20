-- Returns the player's facing direction on the horizontal axes only.
-- @param	name	string	The name of the player to return facing direction of.
-- @return	Returns axis name and sign multiplier.
function worldeditadditions.player_axis2d(name)
  -- minetest.get_player_by_name("singleplayer"):
	local dir = minetest.get_player_by_name(name):get_look_dir()
	local x, z= math.abs(dir.x), math.abs(dir.z)
	if x > z then return "x", dir.x > 0 and 1 or -1
	else return "z", dir.z > 0 and 1 or -1 end
end

-- Returns the axis and sign of the axis to the left of the input axis.
-- @param	axis	string	x or z.
-- @param sign	int	Sign multiplier.
-- @return	Returns axis name and sign multiplier.
function worldeditadditions.axis_left(axis,sign)
	if not axis:match("[xz]") then return false, "Error: Not a horizontal axis!"
	elseif axis == "x" then return true, "z", sign
	else return true, "x", -sign end
end

--- Dehumanize Direction: translates up, down, left, right, front, into xyz based on player orientation.
-- @param	name	string	The name of the player to return facing direction of.
-- @param	dir	string	Relative direction to translate.
-- @return	Returns axis name and sign multiplier.
function worldeditadditions.dir_to_xyz(name, dir)
	local axfac, drfac = worldeditadditions.player_axis2d(name)
	local _, axlft, drlft = worldeditadditions.axis_left(axfac,drfac)
	if dir:match("front") or dir:match("back") then
		return axfac, dir:match("front") and drfac or -drfac
	elseif dir:match("left") or dir:match("right") then
		return axlft, dir:match("left") and drlft or -drlft
	elseif dir:match("up") or dir:match("down") then
		return "y", dir == "down" and -1 or 1
	else return false, "\"" .. dir .. "\" not a recognized direction! Try: (up | down | left | right | front | back)" end
end

-- Tests
-- /lua print(unpack(worldeditadditions.player_axis2d(myname)))
