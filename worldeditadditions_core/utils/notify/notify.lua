--- A player notification system for worldeditadditions.
local wea_c = worldeditadditions_core

-- Helper functions
local set_colour = function(colour, text)
	return minetest.colorize(colour, text)
end

local globalstate = {
	-- Remember to connect Notify.get_player_suppressed in
	-- ..\worldeditadditions_commands\player_notify_suppress.lua
	suppressed_players = {},
	-- Mostly for testing, may make get() and set() for this in future
	on_error_send_all = false,
}

local validate = dofile(wea_c.modpath .. "/utils/notify/validate.lua")
local split = dofile(wea_c.modpath .. "/utils/strings/split.lua")

--- WorldEditAdditions player notification system.
-- @namespace	worldeditadditions_core.notify
local Notify = {}

-- Local send handler
local send = function(name, ntype, message, colour, message_coloured)
	-- Check if notifications are suppressed for the player
	if globalstate.suppressed_players[name] then return false end
	-- Do validation
	local sucess, details = validate.all(name, message, colour)
	-- Report errors if any
	if not sucess then
		if details.name_err then
			-- Send error to all players or log it
			if globalstate.on_error_send_all then
				minetest.chat_send_all(details.name_err)
			else minetest.log("error", details.name_err) end
		elseif not details.message then
			Notify.error(name, "Invalid message: " .. tostring(message) ..
				" is not a string.\n" .. debug.traceback())
		elseif not details.colour then
			Notify.error(name, "Invalid colour: " .. tostring(colour) ..
				"\nMessage: " .. message .. "\n" .. debug.traceback())
		end
		return false
	end
	-- Colour the message if applicable
	if message_coloured then
		local msg = split(message, "\n")
		msg[1] = set_colour(colour, msg[1])
		message = table.concat(msg, "\n")
	end
	-- Create the notification
	local ret = table.concat({
		"[--",set_colour(colour, "WEA :: " .. ntype),
		"--]",message }, " ")
	-- Send the notification
	minetest.chat_send_player(name, ret)
	return true
end

--- Send a notification of type `ntype` (for metatable).
--  (Same as `Notify[ntype](name, message)`)
-- @param string	name	The name of the player to send the notification to.
-- @param string	ntype	The type of notification.
-- @param string	message	The message to send.
-- @return	table	The Notify instance.
local call = function(name, ntype, message)
	if ntype ~= "__call" and not Notify[ntype] then
		Notify.error(name, "Invalid notification type: " .. ntype)
		Notify.error(name, "Message: " .. message)
		return false
	end
	Notify[ntype](name, message)
	return true
end

setmetatable(Notify, {__call = call})

--- Send a custom notification.
-- @param string	name	The name of the player to send the notification to.
-- @param string	ntype	The type of notification.
-- @param string	message	The message to send.
-- @param string	colour	optional): The colour of the notification.
-- @param message_coloured	boolean?	Optional. Whether the message should be coloured.
-- @return	boolean			True if all parameters are valid, false otherwise.
-- @example		Predefined notification types
-- Notify.custom(name, "custom", "This one is magenta!", "#FF00FF", true)
-- Notify.custom(name, "custom", "This one is gold with white text!", "#FFC700")
function Notify.custom(name, ntype, message, colour, message_coloured)
	if not colour then colour = "#FFFFFF" end
	return send(name, ntype, message, colour, message_coloured)
end


--- Register the aforementioned predefined notification types.
-- @param string	name	The name of the player to send the notification to.
-- @param string	message	The message to send.
-- @example
-- Notify.error(name, "multi-line error!\n" .. debug.traceback())
-- Notify.warn(name, "This is the last coloured message type!")
-- Notify.ok(name, "I am ok!")
-- Notify.info(name, "There once was a ship that put to sea...")
do
	local type_colours = {
		error = {"#FF5555", true},
		warn = {"#FFFF55", true},
		ok = {"#55FF55", false},
		info = {"#55B9FF", false},
	}
	for k, v in pairs(type_colours) do
		Notify[k] = function(name, message)
			return send(name, k, message, v[1], v[2])
		end
	end
end

--- Local suppression status handler
-- - @param name <string>: The name of the player to check.
-- - @param suppress <table>: The table of suppressed players.
-- - @return <boolean>: True if the player is not suppressed or
-- - 		-		if the player is clear(ed), false otherwise.
local check_clear_suppressed = function(name, suppress)
	if suppress[name] then
		if type(suppress[name]) == "function" then return false end
		if suppress[name].cancel then
			suppress[name]:cancel()
		else suppress[name] = nil end
	end
	return true
end

--- Suppress a player's notifications.
-- - @param name <string>: The name of the player to suppress.
-- - @param time <number > 1>: The number of seconds to suppress notifications for.
-- -		-		number < 1 immediately removes the suppression.
function Notify.suppress_for_player(name, time)
	local suppress = globalstate.suppress
	-- If the player is already suppressed, cancel it unless it's a function
	if not check_clear_suppressed(name, suppress) then return false end
	if time < 1 then return end
	if not minetest.after then -- Just being paranoid again
		Notify.warn(name, "minetest.after does not exist. THIS SHOULD NOT HAPPEN.")
		Notify.warn(name, "Notifications will not be suppressed. Please open an issue!")
	else suppress[name] = minetest.after(time, Notify.suppress_for_player, name, -1) end
end

--- Suppress a player's notifications while function executes.
function Notify.suppress_for_function(name, func)
	local suppress = globalstate.suppress
	-- If the player is already suppressed, cancel it unless it's a function
	if not check_clear_suppressed(name, suppress) then return false end
	suppress[name] = func
	suppress[name]()
	suppress[name] = nil
end

--- WorldEdit compatibility
-- if worldedit and type(worldedit.player_notify) == "function" then
-- 	worldedit.player_notify = function(name, message, ntype)
-- 		Notify(name, ntype, message)
-- 	end
-- end

return Notify