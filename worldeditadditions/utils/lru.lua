local Queue
if worldeditadditions then
	Queue = dofile(worldeditadditions.modpath.."/utils/queue.lua")
else
	Queue = require("queue")
end

--- A least-recently-used cache implementation.
-- @class
local LRU = {}
LRU.__index = LRU

--- Creates a new LRU cache.
-- Optimal sizes: 8, 16, 32, 64 or any value above
-- @param	max_size=32		number	The maximum number of items to store in the cache.
-- @returns	LRU				A new LRU cache.
function LRU.new(max_size)
	if not max_size then max_size = 32 end
	local result = {
		max_size = max_size,
		cache = {  },
		size = 0,
		queue = Queue.new()
	}
	setmetatable(result, LRU)
	return result
end

--- Determines whether the given key is present in this cache object.
-- Does NOT update the most recently used status of said key.
-- @param	key		string	The key to check.
-- @returns	bool	Whether the given key exists in the cache or not.
function LRU:has(key)
	return self.cache[key] ~= nil
end

--- Gets the value associated with the given key.
-- @param	key		string	The key to retrieve the value for.
-- @returns	any|nil	The value associated with the given key, or nil if it doesn't exist in this cache.
function LRU:get(key)
	if not self.cache[key] then return nil end
	
	-- Put it to the end of the queue
	self.queue:remove_index(self.cache[key].index)
	self.cache[key].index = self.queue:enqueue(key)
	
	return self.cache[key].value
end

--- Adds a given key-value pair to this cache.
-- Note that this might (or might not) result in the eviction of another item.
-- @param	key		string	The key of the item to add.
-- @param	value	any		The value to associate with the given key.
-- @returns nil
function LRU:set(key, value)
	if self.cache[key] ~= nil then
		-- It's already present in the cache - update it
		-- Put it to the end of the queue
		self.queue:remove_index(self.cache[key].index)
		local new_index = self.queue:enqueue(key)
		-- Update the cache entry
		self.cache[key] = {
			value = value,
			index = new_index
		}
	else
		-- It's not in the cache -- add it
		self.cache[key] = { value = value, index = self.queue:enqueue(key) }
		
		self.size = self.size + 1
		if self.size > self.max_size then
			-- The cache is full, delete the oldest item
			local oldest_key = self.queue:dequeue()
			self.cache[oldest_key] = nil
			self.size = self.size - 1
		end
	end
end

return LRU
