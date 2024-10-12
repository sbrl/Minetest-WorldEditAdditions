--- 
-- @module worldeditadditions_core

-- decodeURIComponent() implementation
-- Ref https://stackoverflow.com/a/78225561/1460422

-- TODO this doesn't work. It replaces \n with %A instead of %0A, though we don't know if that's a problem or not
-- it also doesn't handle quotes even though we've clearly got them in the Lua pattern
local function _escape_char(char)
	print("_escape_char char", char, "result", string.format('%%%0X', string.byte(char)))
	return string.format('%%%0X', string.byte(char))
end

local function escape(uri)
	return (string.gsub(uri, "[^%a%d%-_%.!~%*'%(%);/%?:@&=%+%$,#]", _escape_char))
end

return escape