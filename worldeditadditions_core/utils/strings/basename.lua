
---
-- @module worldeditadditions_core


--- Returns the basename of a filepath.
-- @param	filepath	string	The filepath to process
-- @returns	string		The basename of the given filepath
-- @example Basic usage
-- worldeditadditions_core.basename("/some/path/schematic.mts") -- returns "schematic.mts")
-- @example Stripping trailing / or \
-- worldeditadditions_core.basename("/some/path/") -- returns "path", since it strips trailing "/" or "\"
local function basename(filepath)
	local result = string.match(filepath, ".*[\\/]([^%/%\\]*)[%/%\\]?")
	return result
end

return basename