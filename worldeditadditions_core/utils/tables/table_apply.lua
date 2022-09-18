--- SHALLOW ONLY - applies the values in source to overwrite the equivalent keys in target.
-- Warning: This function mutates target!
-- @param	source	table	The source to take values from
-- @param	target	table	The target to write values to
local function table_apply(source, target)
	for key, value in pairs(source) do
		target[key] = value
	end
end

return table_apply
