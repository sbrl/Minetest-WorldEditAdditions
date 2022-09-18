--- Sets for lua!
-- local Set = {}
--- Option 1:
-- Set.__index = Set
-- Set.__newindex = function(tbl, key, value)
-- 	if not tbl.__protected[key] then
-- 		rawset(tbl,key,value)
-- 	else
-- 		error("Protected!")
-- 	end
-- end
-- Set.__protected = {
-- 	__protected=true,
-- 	new=true,
-- 	add=true,
-- 	delete=true,
-- 	has=true
-- }

--- Option 2:
local Set = {}
Set.__index = Set
Set.__newindex = function(tbl, key, value)
		rawset(tbl.set,key,value)
end

--- Creates a new set.
-- @param	i	any	Initial values(s) of the set.
-- @returns	Set	A table of keys equal to true.
function Set.new(i)
	local result = {set={}}
	setmetatable(result, Set)
	if type(i) == "table" then
		for k,v in pairs(i) do result[v] = true end
	elseif i then
		result[i] = true
	end
	return result
end
-- a = Set.new({"add","new","thing"})

--- Adds item(s) to set.
-- @param	a	set	Set to manipulate.
-- @param	i	not nil	Values(s) to add.
-- @returns	bool	Success of operation.
function Set.add(a,i)
	if type(i) == "table" then
		for k,v in pairs(i) do a[v] = true end
	else
		a[i] = true
	end
	return true
end

--- Deletes item(s) from set.
-- @param	a	set	Set to manipulate.
-- @param	i	not nil	Values(s) to delete.
-- @returns	bool	Success of operation.
function Set.delete(a,i)
	if type(i) == "table" then
		for k,v in pairs(i) do a[v] = nil end
	else
		a[i] = nil
	end
	return true
end

--- Checks if value(s) are present in set.
-- @param	a	set	Set to inspect.
-- @param	i	not nil	Values(s) to check.
-- @returns	bool	Value(s) are present?
function Set.has(a,i)
	if type(i) == "table" then
		for k,v in pairs(i) do
			if not a[k] then return false end
		end
		return true
	else
		return a[i] ~= nil
	end
end



--  ██████  ██████  ███████ ██████   █████  ████████  ██████  ██████
-- ██    ██ ██   ██ ██      ██   ██ ██   ██    ██    ██    ██ ██   ██
-- ██    ██ ██████  █████   ██████  ███████    ██    ██    ██ ██████
-- ██    ██ ██      ██      ██   ██ ██   ██    ██    ██    ██ ██   ██
--  ██████  ██      ███████ ██   ██ ██   ██    ██     ██████  ██   ██
--
--  ██████  ██    ██ ███████ ██████  ██████  ██ ██████  ███████ ███████
-- ██    ██ ██    ██ ██      ██   ██ ██   ██ ██ ██   ██ ██      ██
-- ██    ██ ██    ██ █████   ██████  ██████  ██ ██   ██ █████   ███████
-- ██    ██  ██  ██  ██      ██   ██ ██   ██ ██ ██   ██ ██           ██
--  ██████    ████   ███████ ██   ██ ██   ██ ██ ██████  ███████ ███████

function Set.__call(i) return Set.new(i) end


-- Main Return:
return Set
