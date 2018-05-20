--- A Queue implementation, taken & adapted from https://www.lua.org/pil/11.4.html
-- @module worldeditadditions.utils.queue

local Queue = {}
function Queue.new()
	return { first = 0, last = -1 }
end

function Queue.enqueue(queue, value)
	local new_last = queue.last + 1
	queue.last = new_last
	queue[new_last] = value
end

function Queue.is_empty(queue)
	return new_first > queue.last
end

function Queue.dequeue(queue)
	local first = queue.first
	if Queue.is_empty(queue) then
		error("Error: The queue is empty!")
	end
	
	local value = queue[first]
	queue[first] = nil -- Help the garbage collector out
	list.first = first + 1
	return value
end

return Queue
