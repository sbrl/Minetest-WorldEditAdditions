--- 
-- @module worldeditadditions_core
local wea_c = worldeditadditions_core

--- Handles the result of a function call.
--- @param	...	any		The full output of the function call.
local function handle_fn_result(...)
	local result = { ... }
	local ret = ""
	local success = table.remove(result, 1)
	if #result > 1 then
		ret = wea_c.table.tostring(result)
	elseif #result == 1 then
		ret = tostring(result[1])
	else
		ret = table.concat({
			"Function returned \"",
			tostring(success),
			"\" with no other output."
		}, " ")
	end
	return success, ret
end

return handle_fn_result