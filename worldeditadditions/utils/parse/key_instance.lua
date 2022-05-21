--- A container for transmitting axis, sign pairs within parsing functions.
-- @class
local key_instance = {}
key_instance.__index = key_instance
key_instance.__name = "Key Instance"

--- Creates a new Key Instance.
-- @param: type: String: Key type (axis, direction, mirroring or error).
-- @param: entry: String: The main content of the key.
-- @param: sign: Int: The signed multiplier of the key (if any).
-- @return: Key Instance: The new Key Instance.
function key_instance.new(type,entry,sign)
	if type == "error" then type = "err" end
	local tbl = {type = type, entry = entry}
	if sign and sign ~= 0 then
		if type == "err" then tbl.code = sign
		else tbl.sign = sign end
	end
	return setmetatable(tbl, key_instance)
end

--- Checks if Key Instance "entry" field is a table.
-- @param: tbl: Key Instance: The Key Instance to check.
-- @return: Bool: Returns true if Key Instance has a non 0 sign value.
function key_instance.entry_table(a)
	if type(a.entry) == "table" then
		return true
	else return false end
end

--- Checks if Key Instance has a signed multiplier.
-- @param: tbl: Key Instance: The Key Instance to check.
-- @return: Bool: Returns true if Key Instance has a non 0 sign value.
function key_instance.has_sign(a)
	if not a.sign or a.sign == 0 then
		return false
	else return true end
end

--- Checks if Key Instance is an error.
-- @param: tbl: Key Instance: The Key Instance to check.
-- @return: Bool: Returns true if Key Instance is an error.
function key_instance.is_error(a)
	if a.type == "err" then return true
	else return false end
end

function key_instance.__tostring(a)
	local function enquote(take)
		if type(take) == "string" then
			return '"'..take..'"'
		else return tostring(take) end
	end
	local ret = "{type = "..enquote(a.type)..", entry = "
	if type(a.entry) == "table" and #a.entry <= 3 then
		ret = ret.."{"
		for _i,v in ipairs(a.entry) do
			ret = ret..enquote(v)..", "
		end
		ret = ret:sub(1,-3).."}"
	else ret = ret..enquote(a.entry) end
	
	if a:is_error() and a.code then ret = ret..", code = "..a.code.."}"
	elseif a:has_sign() then ret = ret..", sign = "..a.sign.."}"
	else ret = ret.."}" end
	return ret
end

return key_instance
