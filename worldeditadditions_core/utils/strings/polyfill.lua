--[[
Functions that operate on strings that *really* should be present in the Lua
standard library, but somehow aren't.
A good rule of thumb is to ask "does Javascript have a built-in function for
this?". If yes, then your implementation probably belongs here.
]]--

--- Pads str to length len with char from right
-- @source https://snipplr.com/view/13092/strlpad--pad-string-to-the-left
local function str_padend(str, len, char)
	if char == nil then char = ' ' end
	return str .. string.rep(char, len - #str)
end
--- Pads str to length len with char from left
-- Adapted from the above
local function str_padstart(str, len, char)
	if char == nil then char = ' ' end
	return string.rep(char, len - #str) .. str
end

--- Equivalent to string.startsWith in JS
-- @param	str		string	The string to operate on
-- @param	start	number	The start string to look for
-- @returns	bool	Whether start is present at the beginning of str
local function str_starts(str, start)
   return string.sub(str, 1, string.len(start)) == start
end

--- Equivalent to string.endsWith in JS
-- @param	str			string	The string to operate on
-- @param	substr_end	number	The ending string to look for
-- @returns	bool		Whether substr_end is present at the end of str
local function str_ends(str, substr_end)
	return string.sub(str, -string.len(substr_end)) == substr_end
end

--- Trims whitespace from a string from the beginning and the end.
-- From http://lua-users.org/wiki/StringTrim
-- @param	str		string	The string to trim the whitespace from.
-- @returns	string	A copy of the original string with the whitespace trimmed.
local function trim(str)
   return (str:gsub("^%s*(.-)%s*$", "%1"))
end


if worldeditadditions then
	worldeditadditions.str_padend = str_padend
	worldeditadditions.str_padstart = str_padstart
	worldeditadditions.str_starts = str_starts
	worldeditadditions.str_ends = str_ends
	worldeditadditions.trim = trim
else
    return {
        str_padend = str_padend,
        str_padstart = str_padstart,
		str_starts = str_starts,
		str_ends = str_ends,
		trim = trim
    }
end
