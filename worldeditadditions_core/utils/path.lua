--- A path manipulation class.
-- @class	worldeditadditions_core.Path
local path = {}

-- Helper functions
local check = function( ... )
	for _, v in ipairs( {...} ) do
		if type(v) ~= "string" then
			return false, tostring(v) .. " is not a string."
		end
	end
	return true
end

--- The directory separator on the current host system
--	@value string
path.sep = "/"
if package and package.config then
	path.sep = package.config:sub(1,1)
end

--- Format string into path
--	@param	str	string	The string to process
--	@return		string|false, string?	The formatted path string or
--				false and an error message.
--	@example	Basic usage
--		local path = path.norm("C:\\Users\\me\\".."/Documents//code.lua")
path.norm = function( str )
	local ok, err = check(str)
	if not ok then return false, err end
	return ({str:gsub("[/\\]+", path.sep)})[1]
end

--- Joins the given path segments into a single path with dirsep.
--	@param	...	string	The path fragments to process and join.
--	@return		string|false, string?	The joined path or
--				false and an error message.
--	@example	Basic usage
--		local path = file_path("C:\\Users", "me", "/Documents/code.lua")
path.join = function( ... )
	local ok, err = check( ... )
	if not ok then return false, err end
	local pathlets = { ... }
	return path.norm(table.concat(pathlets, path.sep))
end

local Path = {}
Path.__name = "Path" --  A hack to allow easier identification
Path.__index = Path
Path.__call = function(self, ...)
	return self.join(...)
end

return setmetatable(path, Path)