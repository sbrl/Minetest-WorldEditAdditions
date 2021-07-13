-------------------------------------------------------------------------------
--- A Queue implementation, taken & adapted from https://www.lua.org/pil/11.4.html
-- @submodule worldeditadditions.utils.queue

local Queue = {}
Queue.__index = Queue

function Queue.new()
	result = { first = 0, last = -1, items = {} }
	setmetatable(result, Queue)
	return result
end

function Queue:enqueue(value)
	local new_last = self.last + 1
	self.last = new_last
	self.items[new_last] = value
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

function Queue:dequeue()
	local first = self.first
	if Queue.is_empty(self) then
		error("Error: The self is empty!")
	end
	
	local value = self.items[first]
	self.items[first] = nil -- Help the garbage collector out
	self.first = first + 1
	return value
end

return Queue
