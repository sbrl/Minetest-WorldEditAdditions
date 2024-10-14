--- A player notification system for worldeditadditions.

-- Helper functions
local set_colour = function(colour, text)
	return minetest.colorize(colour, text)
end

local validate = {
	name = function(name)
		-- Very paranoid is me
		if not minetest.get_player_by_name then return false end
		local player = minetest.get_player_by_name(name)
		return (player and player:is_player()) or false -- Paranoid is me
	end,
	message = function(message) return type(message) == "string" end,
	colour = function(colour)
		return ( type(colour) == "string" and
			colour:match("^#%x+$") and
			(#colour == 4 or #colour == 7) )
	end
}

validate.all = function(name, message, colour)
	return validate.name(name) and
		validate.message(message) and
		validate.colour(colour)
end

local send = function(name, ntype, message, colour, message_coloured)
	-- Do validation
	if not validate.all(name, message, colour) then
		return false
	end
	-- Colour the message if applicable
	if message_coloured then
		message = set_colour(colour, message)
	end
	-- Create the notification
	local ret = table.concat({
		"[--",set_colour(colour, "WEA :: " .. ntype),
		"--]",message }, " ")
	-- Send the notification
	minetest.chat_send_player(name, ret)
	return true
end

-- @class	worldeditadditions_core.notify
local Notify = {}

--- Send a notification of type `ntype`.
--  (Same as `Notify[ntype](name, message)`)
-- @param name <string>: The name of the player to send the notification to.
-- @param ntype <string>: The type of notification.
-- @param message <string>: The message to send.
-- @return <table>: The Notify instance.
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
-- @param name <string>: The name of the player to send the notification to.
-- @param ntype <string>: The type of notification.
-- @param message <string>: The message to send.
-- @param colour <string> (optional): The colour of the notification.
-- @param message_coloured <boolean> (optional): Whether the message should be coloured.
-- @return <boolean>: True if all parameters are valid, false otherwise.
function Notify.custom(name, ntype, message, colour, message_coloured)
	if not colour then colour = "#FFFFFF" end
	return send(name, ntype, message, colour, message_coloured)
end

--- Register predefined notification types.
-- @usage
-- Notify.error(name, message)
-- Notify.warn(name, message)
-- Notify.ok(name, message)
-- Notify.info(name, message)
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