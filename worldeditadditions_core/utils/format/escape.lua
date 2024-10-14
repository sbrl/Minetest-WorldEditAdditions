--- 
-- @module worldeditadditions_core

-- decodeURIComponent() implementation
-- Ref https://stackoverflow.com/a/78225561/1460422
-- Adapted by @sbrl to:
--	- Print leading 0 behind escape codes as it should
--	- Also escape ' and #

-- TODO this doesn't work. It replaces \n with %A instead of %0A, though we don't know if that's a problem or not
-- it also doesn't handle quotes even though we've clearly got them in the Lua pattern
local function _escape_char(char)
	print("_escape_char char", char, "result", string.format('%%%02X', string.byte(char)))
	return string.format('%%%02X', string.byte(char))
end

--- Escape the given string for use in a url.
-- In other words, like a space turns into %20.
-- Similar to Javascript's `encodeURIComponent()`.
-- @param	string	str		The string to escape.
-- @returns	string	The escaped string.
local function escape(str)
	return (string.gsub(str, "[^%a%d%-_%.!~%*%(%);/%?:@&=%+%$,]", _escape_char))
end

return escape