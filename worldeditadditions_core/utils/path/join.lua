--- 
-- @module worldeditadditions_core
local wea_c = worldeditadditions_core

--- Joins the given path segments into a single path with dirsep.
--	@param	...	string	The path fragments to process and join.
--	@return		string	The joined path.
--	@example	Basic usage
--		local path = file_path("C:\\Users", "me", "/Documents/code.lua")
local join = function( ... )
	local path = { ... }
	for i, v in ipairs(path) do path[i] = tostring(v) end
	return ({table.concat(path, wea_c.dirsep)
			:gsub("[/\\]+", wea_c.dirsep)})[1]
end

return join