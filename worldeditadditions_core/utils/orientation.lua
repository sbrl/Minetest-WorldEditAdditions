

-- This file is based on code from the screwdriver2 mod and a forum post on the Minetest forums. By @12Me21 and @khonkhortisan
-- Edited by @sbrl
-- Ref https://github.com/12Me21/screwdriver2/blob/master/init.lua#L75-L79
-- Ref https://forum.minetest.net/viewtopic.php?p=73195&sid=1d2d2e4e76ce2ef9c84646481a4b84bc#p73195

local facedir_cycles = {
	x = { { 12, 13, 14, 15 }, { 16, 19, 18, 17 }, { 0, 4, 22, 8 }, { 1, 5, 23, 9 }, { 2, 6, 20, 10 }, { 3, 7, 21, 11 } },
	y = { { 0, 1, 2, 3 }, { 20, 23, 22, 21 }, { 4, 13, 10, 19 }, { 8, 17, 6, 15 }, { 12, 9, 18, 7 }, { 16, 5, 14, 11 } },
	z = { { 4, 5, 6, 7 }, { 8, 11, 10, 9 }, { 0, 16, 20, 12 }, { 1, 17, 21, 13 }, { 2, 18, 22, 14 }, { 3, 19, 23, 15 } },
}
local wallmounted_cycles = {
	x = { 0, 4, 1, 5 },
	y = { 4, 2, 5, 3 },
	z = { 0, 3, 1, 2 },
}

-- We have standardised on radians for other rotation operations, so it wouldn't make sense for the API-facing functions in this file to use a number of times or degrees, as this would be inconsistent
local function convert_normalise_rad(rad)
	local deg = math.deg(rad)
	local times = worldeditadditions_core.round(deg / 90)
	return math.floor(times) -- ensure it's an integer and not e.g. a float 1.0
end

--- Functions to rotate a facedir/wallmounted value around an axis by a certain amount
-- 
-- Code lifted from @12Me21 and @khonkhortisan
-- 
-- Ref <https://github.com/12Me21/screwdriver2/blob/master/init.lua#L75-L79> and <https://forum.minetest.net/viewtopic.php?p=73195&sid=1d2d2e4e76ce2ef9c84646481a4b84bc#p73195>
-- @namespace worldeditadditions_core.orientation

--- Facedir: lower 5 bits used for direction, 0 - 23
-- @param	param2	number	`param2` value to rotate.
-- @param	axis	string	The name of the axis to rotate around. Valid values: `x`, `y`, `z`
-- @param	amount	The number of radians to rotate around the given `axis`. Only right angles are supported (i.e. 90° increments). Any value that isn't a 90° increment will be **rounded**!
-- @returns	number	A new param2 value that is rotated the given number of degrees around the given `axis`
local function facedir(param2, axis, amount_rad)
	local amount = convert_normalise_rad(amount_rad)
	print("DEBUG:core/orientation:facedir AMOUNT rad "..tostring(amount_rad).." norm "..tostring(amount))
	local facedir_this = param2 % 32
	for _, cycle in ipairs(facedir_cycles[axis]) do
		-- Find the current facedir
		-- Minetest adds table.indexof, but I refuse to use it because it returns -1 rather than nil
		for i, fd in ipairs(cycle) do
			if fd == facedir_this then
				return param2 - facedir_this + cycle[1 + (i - 1 + amount) % 4] -- If only Lua didn't use 1 indexing...
			end
		end
	end
	return param2
end

--- Wallmounted: lower 3 bits used, 0 - 5
-- @param	param2	number	`param2` value to rotate.
-- @param	axis	string	The name of the axis to rotate around. Valid values: `x`, `y`, `z`
-- @param	amount	The number of radians to rotate around the given `axis`. Only right angles are supported (i.e. 90° increments). Any value that isn't a 90° increment will be **rounded**!
-- @returns	number	A new param2 value that is rotated the given number of degrees around the given `axis`
local function wallmounted(param2, axis, amount_rad)
	local amount = convert_normalise_rad(amount_rad)
	print("DEBUG:core/orientation:wallmounted AMOUNT rad " .. tostring(amount_rad) .. " norm " .. tostring(amount))

	local wallmounted_this = param2 % 8
	for i, wm in ipairs(wallmounted_cycles[axis]) do
		if wm == wallmounted_this then
			return param2 - wallmounted_this + wallmounted_cycles[axis][1 + (i - 1 + amount) % 4]
		end
	end
	return param2
end

local orientation = {
	facedir = facedir,
	wallmounted = wallmounted,
	-- From the original codebase (linked above):
	--colorfacedir = facedir,
	--colorwallmounted = wallmounted
	-- ...we'll need to know this later
}

return orientation
