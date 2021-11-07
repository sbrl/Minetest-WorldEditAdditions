--- Converts input to a value of type Boolean.
-- @param	arg	any	Input to convert
-- @returns	boolean
local function to_boolean(arg)
	local typ = type(arg)
	if typ == "boolean" then return arg
	elseif typ == "number" and arg > 0 then return true
	elseif arg == "false" or arg == "no" then return false
	elseif typ ~= "nil" then return true
	else return false end
end
return to_boolean
