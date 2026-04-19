
---
-- @module worldeditadditions_core


--- Returns the basename of a filepath.
-- @param	filepath	string	The filepath to process
-- @returns	string		The basename of the given filepath
-- @example Basic usage
-- worldeditadditions_core.basename("/some/path/schematic.mts") -- returns "schematic.mts")
local function basename(filepath)
	local result = string.match(filepath, ".*[\\/]([^%/%\\]*)")
	return result
end

return basename