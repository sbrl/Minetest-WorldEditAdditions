

-- 4. Supporting recursive structures.
--
-- The issue here is that the following code will call itself
-- indefinitely and ultimately cause a stack overflow:
-- 
-- local my_t = {}
-- my_t.a = my_t
-- local t_copy = copy2(my_t)
--
-- This happens to both copy1 and copy2, which each try to make
-- a copy of my_t.a, which involves making a copy of my_t.a.a,
-- which involves making a copy of my_t.a.a.a, etc. The
-- recursive table my_t is perfectly legal, and it's possible to
-- make a deep_copy function that can handle this by tracking
-- which tables it has already started to copy.
--
-- Thanks to @mnemnion for pointing out that we should not call
-- setmetatable() until we're doing copying values; otherwise we
-- may accidentally trigger a custom __index() or __newindex()!

--- Deep clones a given table.
-- @source	https://gist.github.com/tylerneylon/81333721109155b2d244
-- @param	obj		table	The table to clone.
-- @returns	table	A deep copy of the given table.
local function deepcopy(obj, seen)
	-- Handle non-tables and previously-seen tables.
	if type(obj) ~= 'table' then return obj end
	if seen and seen[obj] then return seen[obj] end
	
	-- New table; mark it as seen and copy recursively.
	local s = seen or {}
	local res = {}
	s[obj] = res
	for k, v in pairs(obj) do res[deepcopy(k, s)] = deepcopy(v, s) end
	return setmetatable(res, getmetatable(obj))
end

return deepcopy
