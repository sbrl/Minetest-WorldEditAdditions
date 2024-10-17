--- Validation functions for WorldEditAdditions notifications.
-- @internal
-- @namespace worldeditadditions_core.notify.validate

-- Helper functions
local log_error = function(message)
	minetest.log("error", "[-- WEA :: error --] " .. tostring(message) ..
		" " .. debug.traceback())
end

--- Collection of functions to validate various parts of WorldEditAdditions notifications to ensure proper input for player names, messages, and colors.
-- @class	validate
local validate = {}

--- Validate name
-- @param	name	string	The name of the player to validate.
-- @returns			boolean	True if the name is valid, false otherwise. 
validate.name = function(name)
	if type(name) ~= "string" then
		log_error(tostring(name) .. " is a " .. type(name) .. " not a string.\n")
		return false
	elseif not minetest.get_player_by_name then -- Very paranoid is me
		log_error("minetest.get_player_by_name is not a function. THIS SHOULD NEVER HAPPEN.")
		return false
	end
	-- Check if the player exists and is online
	local player = minetest.get_player_by_name(name)
	return (player and player:is_player()) or
		("Player \"" .. name .. "\" is not online or does not exist. " .. debug.traceback())
end

--- Validate message
-- @param	message	string	The message to validate.
-- @returns			boolean	True if the message is a string, false otherwise.
validate.message = function(message) return type(message) == "string" end

--- Validate colour
-- @param	colour	string	The colour to validate.
-- @returns			boolean	True if the colour is valid, false otherwise.
validate.colour = function(colour)
	return ( type(colour) == "string" and
		colour:match("^#%x+$") and
		(#colour == 4 or #colour == 7) )
end

--- Validate all
-- @param	name	string		The name of the player to validate.
-- @param	message	string		The message to validate.
-- @param	colour	string		The colour to validate.
-- @returns	boolean, table|nil	Returns the validation status, followed by details of the failure if bool == false.
-- | Return arg | Meaning |
-- |------------|---------|
-- | `boolean` | True if all parameters are valid, false otherwise. |
-- | `table|nil` | A table containing the fail state of the parameters or nil if player name is invalid. |
validate.all = function(name, message, colour)
	local name_checked = validate.name(name)
	local failed = {
		name = name_checked == true,
		name_err = type(name_checked) == "string" and name_checked,
		message = validate.message(message),
		colour = validate.colour(colour),
	}
	return failed.name and failed.message and failed.colour, failed
end

return validate