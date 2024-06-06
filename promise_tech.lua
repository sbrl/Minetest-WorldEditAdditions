--- Javascript Promises, implemented in Lua
-- In other words, a wrapper to manage asynchronous operations.
-- Due to limitations of Lua, while this Promise API is similar it isn't exactly the same as in JS.
-- 
-- Also, .then_() does not return a thenable value but the SAME ORIGINAL promise, as we stack up all functions and then execute them in order once you call .run(). This has the subtle implication that Promise.state is not set to "fulfilled" until ALL functions in the chain have been called.
-- 
-- Additionally, every .then_(function(...) end) MAY return a promise themselves if they wish. These promises WILL be automatically executed when you call .run() on the PARENT promise, as they are considered required for the parent Promise function chain to run to completion.
-- @class	worldeditadditions_core.Promise
local Promise = {}
Promise.__index = Promise
Promise.__name = "Promise" -- A hack to allow identification in wea.inspect

--- Creates a new Promise instance.
-- @param fn <function>: The function to wrap into a promise.
Promise.new = function(fn)
	-- resolve must be a function
	if type(fn) ~= "function" then
		error("Error (Promise.new): First argument (fn) must be a function")
	end
	
	local result = {
		state = "pending",
		force_reject = false,
		fn = fn
	}
	setmetatable(result, Promise)
	
	return result
end


--[[
	*************************
	Instance methods 
	*************************
--]]

--- A dummy function
local f = function(val) end

--- Then function for promises
-- @param onFulfilled <function>: The function to call if the promise is fulfilled
-- @param onRejected <function>: The function to call if the promise is rejected
-- @return A promise object containing a table of results
Promise.then_ = function(self, onFulfilled, onRejected)
	-- onFulfilled must be a function or nil
	if onFulfilled == nil then onFulfilled = f
	elseif type(onFulfilled) ~= "function" then
		error("Error (Promise.then_): First argument (onFulfilled) must be a function or nil")
	end
	-- onRejected must be a function or nil
	if onRejected == nil then onRejected = f
	elseif type(onRejected) ~= "function" then
		error("Error (Promise.then_): Second argument (onRejected) must be a function or nil")
	end
	-- If self.state is not "pending" then error
	if self.state ~= "pending" then
		error("Error (Promise.then_): Promise is already " .. self.state)
	end
	
	-- Make locals to collect the results of self.fn
	local result, force_reject = {nil}, self.force_reject
	
	-- Local resolve and reject functions
	local _resolve = function(value) result[1] = value end
	local _reject = function(value)
		result[1] = value
		force_reject = true
	end
	
	-- Call self.fn
	local success, err = pcall(self.fn, _resolve, _reject)
	
	-- Return a new promise with the results
	if success and not force_reject then
		onFulfilled(result[1])
		return Promise.resolve(result[1])
	else
		onRejected(result[1])
		return Promise.reject(success and result[1] or err)
	end
end

--- Catch function for promises
-- @param onRejected <function>: The function to call if the promise is rejected
-- @return A promise object
Promise.catch = function(self, onRejected)
	-- onRejected must be a function
	if type(onRejected) ~= "function" then
		error("Error (Promise.catch): First argument (onRejected) must be a function")
	end
	
	return Promise.then_(self, nil, onRejected)
end

--- Finally function for promises
-- @param onFinally <function>: The function to call if the promise becomes settled
-- @return A promise object
Promise.finally = function(self, onFinally)
	onFinally()
	return Promise.new(self.fn)
end

--[[
	*************************
	Static methods 
	*************************
--]]

--- Resolve function for promises
-- @param value <any>: The value to resolve the promise with
-- @return A promise object
Promise.resolve = function(value)
	return Promise.new(function(resolve, reject)
		resolve(value)
	end)
end

--- Reject function for promises
-- @param value <any>: The value to reject the promise with
-- @return A promise object
Promise.reject = function(value)
	local promise = Promise.new(function(resolve, reject)
		reject(value)
	end)
	promise.force_reject = true
	return promise
end

-- TODO: Implement static methods (all, any, race etc.)


return Promise

--- TESTS
--[[
Promise = require "promise_tech"

tmp = Promise.resolve(5)
tmp:then_(print, nil)

tmp = Promise.reject(7)
tmp:then_(nil, print)

--- BIG TESTS

function test()
  return Promise.new(function(resolve, reject)
    local value = math.random() -- imagine this was async
    if value > 0.5 then
      reject(value)
    else
      resolve(value)
    end
  end)
end

function do_if_passes(val)
  print("I passed!")
  print("My value was " .. tostring(val))
end

function do_if_fails(err)
  print("I failed!")
  print("My error was " .. tostring(err))
end

test():then_(do_if_passes, do_if_fails)
]]