--- Lua class for reading and writing simple key=value config files.
-- @source Kagi Assistant, edited by @sbrl and contributors
-- @class worldeditadditions_core.io.ConfigFile
ConfigFile = {}
ConfigFile.__index = ConfigFile
ConfigFile.__name = "ConfigFile"

--- Creates a new ConfigFile for a filepath that may or may not exist.
-- @param	filepath	string	The filepath to load the ConfigFile from.
-- @static
function ConfigFile.New(filepath)
	local instance = setmetatable({}, ConfigFile)
	instance.filepath = filepath
	instance.data = {}
	instance:load() -- Load existing config on initialization
	return instance
end

--- Loads the config from file, ignoring blank lines and malformed entries
-- @returns	nil
function ConfigFile:load()
	local file = io.open(self.filepath, "r")
	if not file then return end

	for line in file:lines() do
		line = line:match("^%s*(.-)%s*$")           -- Trim whitespace
		if line ~= "" and not line:match("^#") then -- Ignore empty lines and comments
			local key, value = line:match("^%s*(.-)%s*=%s*(.*)$")
			if key and value then
				self.data[key] = value
			end
		end
	end
	file:close()
end

--- Saves the config back to file, preserving clean format
-- @returns nil
function ConfigFile:save()
	local file = io.open(self.filepath, "w")
	if not file then
		error("Could not open file " .. self.filepath .. " for writing.")
	end

	for key, value in pairs(self.data) do
		file:write(key .. "=" .. value .. "\n")
	end
	file:close()
end

--- Get value by key, with optional default
-- @param	key		string	The key to fetch the value for.
-- @param	default	string	The default value to return if the key wasn't found.
-- @returns	string	The value for the given key, or `default` if it wasn't found.
function ConfigFile:get(key, default)
	return self.data[key] or default
end

--- Set key-value pair
-- @param	key		string	The key to set.
-- @param	value	string	The value to set for the given key.
-- @returns	void
function ConfigFile:set(key, value)
	self.data[key] = tostring(value)
end

return ConfigFile

-- Example usage:
-- local config = ConfigFile:new("config.txt")
-- config:set("username", "alice")
-- print(config:get("username"))
-- config:save()
