local wea = worldeditadditions
local v3 = worldeditadditions.Vector3
--- Returns the player's position (at leg level).
-- @param	name	string	The name of the player to return facing direction of.
-- @return	vector	Returns position.
function worldeditadditions.player_vector(name)
	return minetest.get_player_by_name(name):get_pos()
end

--- Returns the player's facing info including relative DIRs.
-- @param	name	string	The name of the player to return facing direction of.
-- @returns	table(vector3+)	xyz raw values and {axis,sign} tables for facing direction and relative direction keys (front, back, left, right, up, down).
function worldeditadditions.player_dir(name)
	local dir = v3.clone(minetest.get_player_by_name(name):get_look_dir())
	local abs = dir:abs()
	-- Facing info
	if abs.x > abs.z then dir.facing = {axis="x",sign=wea.getsign(dir.x)}
	else dir.facing = {axis="z",sign=wea.getsign(dir.z)} end
	-- Set front and back
	dir.front = dir.facing
	dir.back = {axis=dir.facing.axis,sign=dir.facing.sign*-1}
	-- Set left and right
	if dir.facing.axis == "x" then dir.left = {axis="z", sign=dir.facing.sign}
	else dir.left = {axis="x", sign=dir.facing.sign*-1} end
	dir.right = {axis=dir.left.axis,sign=dir.left.sign*-1}
	-- Set up and down
	dir.up = {axis="y",sign=1}
	dir.down = {axis="y",sign=-1}
	return dir
end

-- /lua print(worldeditadditions.vector.tostring(minetest.get_player_by_name(myname):get_look_dir()))

--- DEPRECATED =================================================================
-- TODO: Refactor commands that use the following functions to use player_dir then delete these functions

--- Returns the player's facing direction on the horizontal axes only.
-- @deprecated		Use worldeditadditions.player_dir instead.
-- @param	name	string	The name of the player to return facing direction of.
-- @return	string,int	Returns axis name and sign multiplier.
function worldeditadditions.player_axis2d(name)
	-- minetest.get_player_by_name("singleplayer"):
	local dir = minetest.get_player_by_name(name):get_look_dir()
	local x, z= math.abs(dir.x), math.abs(dir.z)
	if x > z then return "x", dir.x > 0 and 1 or -1
	else return "z", dir.z > 0 and 1 or -1 end
end

--- Returns the axis and sign of the axis to the left of the input axis.
-- @deprecated		Use worldeditadditions.player_dir instead.
-- @param	axis	string	x or z.
-- @param sign	int	Sign multiplier.
-- @return	string,int	Returns axis name and sign multiplier.
function worldeditadditions.axis_left(axis,sign)
	if not axis:match("[xz]") then return false, "Error: Not a horizontal axis!"
	elseif axis == "x" then return true, "z", sign
	else return true, "x", -sign end
end

--- Dehumanize Direction: translates up, down, left, right, front, into xyz based on player orientation.
-- @deprecated		Use worldeditadditions.player_dir instead.
-- @param	name	string	The name of the player to return facing direction of.
-- @param	dir	string	Relative direction to translate.
-- @return	string	Returns axis name and sign multiplier.
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
