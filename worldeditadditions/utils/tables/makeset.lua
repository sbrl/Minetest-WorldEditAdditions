--- Creates a table that stores data in keys.
-- @source	https://riptutorial.com/lua/example/13407/search-for-an-item-in-a-list
-- @param	list	table	The table of values to convert to keys.
-- @return	table	The table of (key => true) pairs.
local function makeset(list)
	local set = {}
	for _, l in ipairs(list) do
		set[l] = true
	end
	return set
end

return makeset
