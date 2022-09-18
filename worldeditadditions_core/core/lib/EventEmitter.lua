
--- A 3-dimensional vector.
-- @class
local EventEmitter = {}
EventEmitter.__index = EventEmitter
EventEmitter.__name = "EventEmitter" -- A hack to allow identification in wea.inspect


function EventEmitter.new()
	local result = {
		events = {}
	}
	setmetatable(result, EventEmitter)
	return result
end

function EventEmitter.addEventListener(this, event_name, func)
	if this.events[event_name] == nil then this.events[event_name] = {} end
	table.insert(this.events[event_name], func)
end
function EventEmitter.on(this, event_name, func)
	return EventEmitter.addEventListener(this, event_name, func)
end

function EventEmitter.removeEventListener(this, event_name, func)
	if this.events[event_name] == nil then return false end
	for index, next_func in ipairs(this.events[event_name]) do
		if next_func == func then
			table.remove(this.events[event_name], index)
			break
		end
	end
end
function EventEmitter.off(this, event_name, func)
	return EventEmitter.removeEventListener(this, event_name, func)
end

function EventEmitter.emit(this, event_name, args)
	if this.events[event_name] == nil then return end
	for index,next_func in ipairs(this.events[event_name]) do
		next_func(args) -- TODO: Move unpack compat to wea_c
	end
	-- TODO: Monitor execution time, log if it's slow? We'll need to move WEA utils over to wea_c first though...
end

function EventEmitter.clear(this, event_name)
	this.events[event_name] = nil
end

return EventEmitter