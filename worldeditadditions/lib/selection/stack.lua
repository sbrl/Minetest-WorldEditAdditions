--- Holds the per-user selection stacks.
worldeditadditions.sstack = {}

local sstack_max = 100

--- Calculates the height of the selection stack for the defined user.
-- If the defined user doesn't yet have a stack, a value of 0 is returned.
-- @param	user	string	The name of the user to count the size of the selection stack for.
-- @return	number	The number of items on the stack for the given user.
function worldeditadditions.scount(name)
	if not worldeditadditions.sstack[name] then
		return 0
	end
	return #worldeditadditions.sstack[name]
end

--- Inserts a selection region onto the stack for the user with the given name.
-- Stacks are per-user.
-- @param	name	string	The name of the user to insert onto.
-- @param	pos1	Vector	Position 1
-- @param	pos2	Vector	Position 2
function worldeditadditions.spush(name, pos1, pos2)
	if not worldeditadditions.sstack[name] then
		worldeditadditions.sstack[name] = {}
	end
	-- Checck the stack height
	if #worldeditadditions.sstack[name] > sstack_max then
		return false, "Error: Selection stack height of "..sstack_max.." would be exceeded by pushing a new selection onto the stack now."
	end
	
	table.insert(worldeditadditions.sstack[name], { pos1, pos2 })
	
	return true
end

--- Pops a selection region off the stack for the given user.
-- Stacks are per-user.
-- @param	name	string	The name of the user to remove a selection region off the stack for.
-- @return bool,Vector|string, Vector	A bool true/false indicating success, followed by either a error message as a string if false or a pair of Vectors for the pos1 and pos2 from the item popped from the stack respectively. 
function worldeditadditions.spop(name)
	if not worldeditadditions.sstack[name] or #worldeditadditions.sstack[name] == 0 then
		return false, "Error: The stack for user "..name.." is empty, so can't remove anything from it."
	end
	
	local item = table.remove(worldeditadditions.sstack[name])
	return true, item[1], item[2]
end
