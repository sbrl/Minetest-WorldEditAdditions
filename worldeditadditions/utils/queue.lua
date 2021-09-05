-------------------------------------------------------------------------------
--- A Queue implementation
-- Taken & adapted from https://www.lua.org/pil/11.4.html
-- @submodule worldeditadditions.utils.queue
-- @class
local Queue = {}
Queue.__index = Queue

--- Creates a new queue instance.
-- @returns	Queue
function Queue.new()
	local result = { first = 0, last = -1, items = {} }
	setmetatable(result, Queue)
	return result
end

--- Adds a new value to the end of the queue.
-- @param	value	any		The new value to add to the end of the queue.
-- @returns	number	The index of the value that was added to the queue.
function Queue:enqueue(value)
	local new_last = self.last + 1
	self.last = new_last
	self.items[new_last] = value
	return new_last
end

--- Determines whether a  given value is present in this queue or not.
-- @param	value	any		The value to check.
-- @returns	bool	Whether the given value exists in the queue or not.
function Queue:contains(value)
	for i=self.first,self.last do
		if self.items[i] == value then
			return true
		end
	end
	return false
end

--- Returns whether the queue is empty or not.
-- @returns	bool	Whether the queue is empty or not.
function Queue:is_empty()
	return self.first > self.last
end

--- Removes the item with the given index from the queue.
-- Item indexes do not change as the items in a queue are added and removed.
-- @param		number		The index of the item to remove from the queue.
-- @returns		nil
function Queue:remove_index(index)
	self.items[index] = nil
end

--- Dequeues an item from the front of the queue.
-- @returns		any|nil		Returns the item at the front of the queue, or nil if no items are currently enqueued. 
function Queue:dequeue()
	if Queue.is_empty(self) then
		error("Error: The self is empty!")
	end
	
	local first = self.first
	-- Find the next non-nil item
	local value
	while value == nil do
		if first > self.last then return nil end
		value = self.items[first]
		self.items[first] = nil -- Help the garbage collector out
		first = first + 1
	end
	self.first = first
	return value
end


return Queue
