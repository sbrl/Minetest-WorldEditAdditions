local wea_c = worldeditadditions_core
--- Event manager object.
-- @class	worldeditadditions_core.EventEmitter
local EventEmitter = {}
EventEmitter.__index = EventEmitter
EventEmitter.__name = "EventEmitter" -- A hack to allow identification in wea.inspect

--- Create a new event emitter.
-- @param	tbl	table|nil	Optional. A table to base the new EventEmitter object on. EventEmitter will attach ann instance of itself to this object. The 'events' property on the object MUST NOT be set. IT WILL BE OVERWRITTEN!
-- @returns	table	The new EventEmitter object. If a table is passed in, a new table is NOT created.
function EventEmitter.new(tbl)
	if not tbl then tbl = {} end
	tbl.events = {  }
	tbl.debug = false 
	setmetatable(tbl, EventEmitter)
	return tbl
end

--- Add a new listener to the given named event.
-- @param	this		EventEmitter	The EventEmitter instance to add the listener to.
-- @param	event_name	string			The name of the event to listen on.
-- @param	func		function		The callback function to call when the event is emitted. Will be passed a single argument - the object passed as the second argument to .emit().
-- @returns	number		The number of listeners attached to that event.
function EventEmitter.addEventListener(this, event_name, func)
	if this.events[event_name] == nil then this.events[event_name] = {} end
	table.insert(this.events[event_name], func)
	local count = #this.events[event_name]
	if count > 10 then
		minetest.log("warning", count.." listeners registered for event "..event_name..", possible leak? You MUST remove listeners when you're done with them!")
	end
	return count
end
function EventEmitter.on(this, event_name, func)
	return EventEmitter.addEventListener(this, event_name, func)
end

--- Remove an existing listener from the given named event.
-- @param	this		EventEmitter	The EventEmitter instance to remove the listener from.
-- @param	event_name	string			The name of the event to remove from.
-- @param	func		function		The callback function to remove from the list of listeners for the given named event.
-- @return	bool		Whether it was actually removed or not. False means it failed to find the given listener function.
function EventEmitter.removeEventListener(this, event_name, func)
	if this.events[event_name] == nil then return false end
	for index, next_func in ipairs(this.events[event_name]) do
		if next_func == func then
			table.remove(this.events[event_name], index)
			break
		end
	end
	return true
end
function EventEmitter.off(this, event_name, func)
	return EventEmitter.removeEventListener(this, event_name, func)
end

--- Emit an event.
-- @param	this		EventEmitter	The EventEmitter instance to emit the event from.
-- @param	event_name	string			The name of the event to emit.
-- @param	args		table|any		The argument(s) to pass to listener functions. It is strongly advised you pass a table here.
function EventEmitter.emit(this, event_name, args)
	if this.debug then
		listeners = 0
		if this.events[event_name] ~= nil then listeners = #this.events[event_name] end
		print("DEBUG:EventEmitter emit", event_name, "listeners", listeners, "args", wea_c.inspect(args))
	end
	if this.events[event_name] == nil then return end
	
	for index,next_func in ipairs(this.events[event_name]) do
		next_func(args)
	end
	-- TODO: Monitor execution time, log if it's slow? We'll need to move WEA utils over to wea_c first though...
end

--- Clear all listeners from a given event name.
-- @param	this		EventEmitter	The EventEmitter instance to clear listeners from.
-- @param	event_name	string			The name of the event to clear the listeners from.
function EventEmitter.clear(this, event_name)
	this.events[event_name] = nil
end

--- Clear all listeners.
-- @param	this		EventEmitter	The EventEmitter instance to clear listeners from.
function EventEmitter.clear_all(this, event_name)
	this.events = {}
end

return EventEmitter