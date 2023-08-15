local json
if minetest == nil then
	json = require("json")
end

-- Set to true to log JSON parsing errors to stderr when NOT running in Minetest's environment.
local log_errors_ext = false

local function do_log_error(msg)
	if log_errors_ext then
		io.stderr:write(msg)
	end
end

local function do_parse_module(source)
	local success, result = pcall(function() return json.decode(source) end)
	-- minetest.parse_json doesn't return error messages, so there's no point in return it here either since we can't use this in Minetest's lua environment due to no require().
	if not success then
		do_log_error("Error parsing JSON: "..result)
		return nil
	end
	return result
end

return function(source)
	if minetest ~= nil then
		return minetest.parse_json(source)
	else
		return do_parse_module(source)
	end
end