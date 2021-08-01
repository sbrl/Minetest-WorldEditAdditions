-------------------------------------------------------------------------------
--- A Queue implementation, taken & adapted from https://www.lua.org/pil/11.4.html
-- @submodule worldeditadditions.utils.queue

local Queue = {}
Queue.__index = Queue

function Queue.new()
	local result = { first = 0, last = -1, items = {} }
	setmetatable(result, Queue)
	return result
end

function Queue:enqueue(value)
	local new_last = self.last + 1
	self.last = new_last
	self.items[new_last] = value
	return new_last
end

function Queue:contains(value)
	for i=self.first,self.last do
		if self.items[i] == value then
			return true
		end
	end
	return false
end

function Queue:is_empty()
	return self.first > self.last
end

function Queue:remove_index(index)
	self.items[index] = nil
end

function Queue:dequeue()
	if Queue.is_empty(self) then
		error("Error: The self is empty!")
	end
	
	local first = self.first
	-- Find the next non-nil item
	local value
	while value == nil do
		if first >= self.last then return nil end
		value = self.items[first]
		self.items[first] = nil -- Help the garbage collector out
		first = first + 1
	end
	self.first = first
	return value
end

return Queue
