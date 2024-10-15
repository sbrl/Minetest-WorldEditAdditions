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
	on_error_send_all = false,
}

local validate = dofile(wea_c.modpath .. "/utils/notify/validate.lua")
local split = dofile(wea_c.modpath .. "/utils/strings/split.lua")

--- WorldEditAdditions player notification system.
-- @namespace	worldeditadditions_core.notify
local Notify = {}

-- Local send handler
local send = function(name, ntype, message, colour, message_coloured)
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

--- Send a notification of type `ntype`.
--  (Same as `Notify[ntype](name, message)`)
-- @param string	name	The name of the player to send the notification to.
-- @param string	ntype	The type of notification.
-- @param string	message	The message to send.
-- @return	table	The Notify instance.
function Notify.__call(name, ntype, message)
	if ntype ~= "__call" and not Notify[ntype] then
		Notify.error(name, "Invalid notification type: " .. ntype)
		Notify.error(name, "Message: " .. message)
		return false
	end
	Notify[ntype](name, message)
	return true
end

--- Send a custom notification.
-- @param string	name	The name of the player to send the notification to.
-- @param string	ntype	The type of notification.
-- @param string	message	The message to send.
-- @param string	colour	optional): The colour of the notification.
-- @param message_coloured	boolean?	Optional. Whether the message should be coloured.
-- @return	boolean			True if all parameters are valid, false otherwise.
-- @example		Predefined notification types
-- Notify.error(name, message)
-- Notify.errinfo(name, message) -- For verbose errors and stack traces
-- Notify.warn(name, message)
-- Notify.wrninfo(name, message)  -- For verbose warnings and stack traces
-- Notify.ok(name, message)
-- Notify.info(name, message)
function Notify.custom(name, ntype, message, colour, message_coloured)
	if not colour then colour = "#FFFFFF" end
	return send(name, ntype, message, colour, message_coloured)
end


--- Register the aforementioned predefined notification types.
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

return Notify