--- If the settings object for the given player name doesn't exist, it is created.
-- @param	name	The name of the player to ensure has a settings object.
local function settings_init(name)
	if worldeditadditions.farwand.player_data[name] == nil then
		minetest.log("INFO", "Initialising settings for "..name)
		worldeditadditions.farwand.player_data[name] = {
			maxdist = 1000,
			skip_liquid = true
		}
	end
end

--- Gets a given farwand setting for the given player name.
-- @param	string	name			The name of the player to get the setting for.
-- @param	string	setting_name	The name of the setting to fetch.
-- @return	any		The value of the setting.
function worldeditadditions.farwand.setting_get(name, setting_name)
	if setting_name == nil then return nil end
	settings_init(name)
	return worldeditadditions.farwand.player_data[name][setting_name]
end

--- Sets a given farwand setting for the given player name to the given value.
-- @param	string	name			The name of the player to set the setting for.
-- @param	string	setting_name	The name of the setting to set.
-- @param	any		setting_value	The value to set the setting to.
-- @return	bool	Whether setting the setting was successful or not.
function worldeditadditions.farwand.setting_set(name, setting_name, setting_value)
	if setting_name == nil then return false end
	settings_init(name)
	worldeditadditions.farwand.player_data[name][setting_name] = setting_value
	return true
end
