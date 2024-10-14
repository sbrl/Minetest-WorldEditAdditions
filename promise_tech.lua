--  ██████   ██████    ██████   ███    ███  ██  ███████  ███████ 
--  ██   ██  ██   ██  ██    ██  ████  ████  ██  ██       ██      
--  ██████   ██████   ██    ██  ██ ████ ██  ██  ███████  █████   
--  ██       ██   ██  ██    ██  ██  ██  ██  ██       ██  ██      
--  ██       ██   ██   ██████   ██      ██  ██  ███████  ███████ 

--- Javascript Promises, implemented in Lua
-- In other words, a wrapper to manage asynchronous operations.
-- Due to limitations of Lua, while this Promise API is similar it isn't exactly the same as in JS.

--- @class	worldeditadditions_core.Promise
local Promise = {}
setmetatable(Promise, {__tostring = function(self) return "Promise" end})
Promise.__index = Promise
Promise.__name = "Promise" -- A hack to allow identification in wea.inspect
Promise.__tostring = function(self) return "Promise: " .. self.state end

--- Creates a new Promise instance.
-- @param fn <function>: The function to wrap into a promise.
Promise.new = function(fn)
	-- resolve must be a function
	if type(fn) ~= "function" then
		error("Error (Promise.new): Argument @position 1 (fn) must be a function")
	end
	
	local result = {
		-- State can be "pending", "fulfilled", or "rejected"
		-- Any state other than "pending" means the promise has been settled
		-- and become "locked" enable to be acted on again
		state = "pending",
		-- The force_reject flag is to be used to facilitate non error rejections
		-- If set to true this flag will be passed to child promises
		force_reject = false,
		-- The function to execute when the promise is settled
		fn = fn
	}
	setmetatable(result, Promise)
	
	return result
end



--[[
	*************************
	Local helpers 
	*************************
--]]

--- A dummy function
local f = function(val) end

-- Table tweaks (because this is for Minetest)
--- @class	table
local table = table
-- @diagnostic disable-next-line
if not table.unpack then table.unpack = unpack end
-- @diagnostic disable-next-line
table.join = function(tbl, sep)
	local function fn_iter(tbl,sep,i)
		if i < #tbl then
			return (tostring(tbl[i]) or "").. sep .. fn_iter(tbl,sep,i+1)
		else return (tostring(tbl[i]) or "") end
	end
	return fn_iter(tbl,sep,1)
end

--- Warning wrapper
local warn = warn
if warn then warn("@on")
else warn = minetest and function(...)
		minetest.log("warning", table.concat(arg,"\t"))
	end or print
end

-- A handler for erors where a function is expected
-- @param called_from <string>: The function of Promise that called the error
-- @param position <string>: The position of the argument that caused the error (e.g. "First" or "Second")
-- @param arg_name <string>: The name of the argument that caused the error (e.g. "onFulfilled")
-- @param must_be <string>: The type of the argument that caused the error (e.g. "function" or "function or nil")
-- @param self_problem <bool>: Whether the error is a self-promblem or not (if called_from is supposed to be used with ":" instead of ".")
-- @return <string>: The error/warning message
local function_type_warn = function(called_from, position, arg_name, must_be, self_problem)
	local cat = self_problem and ":" or "."
	local err_str = string.format(
		"Error (Promise%s%s): Argument @position %s (%s) must be a %s",
		cat, called_from, position, arg_name, must_be)
	-- local err_str = "Error (Promise" .. cat .. called_from .. "): " .. position .. " argument (" .. arg_name .. ") must be " .. must_be
	if self_problem then
		err_str = string.format(
			"%s\nAre you using .%s() instead of :%s()?",
			err_str, called_from, called_from)
	end
	return err_str
end

local type_enforce = function(called_from, args)
	local err_str = nil
	for i, arg in ipairs(args) do
		local is_err = true
		for _, should_be in ipairs(arg.should_be) do
			-- First handle metatables
			if type(arg.val) == "table" and type(should_be) == "table" and getmetatable(arg.val) == should_be then
				is_err = false
			elseif type(arg.val) == should_be then
				is_err = false
			end
		end
		if is_err then
			err_str = function_type_warn(called_from, i, arg.name, table.join(arg.should_be, " or "), arg.name == "self" and true or false)
			if arg.error then error(err_str)
			else warn(err_str) end
		end
	end
end



--[[
	*************************
	Instance methods 
	*************************
--]]

--- Then function for promises
-- @param onFulfilled <function | nil>: The function to call if the promise is fulfilled
-- @param onRejected <function | nil>: The function to call if the promise is rejected
-- @return A promise object containing a table of results
Promise.then_ = function(self, onFulfilled, onRejected)
	type_enforce("then_",{
		{name = "self", val = self, should_be = {Promise}, error = true},
		{name = "onFulfilled", val = onFulfilled, should_be = {"function", "nil"}, error = true},
		{name = "onRejected", val = onRejected, should_be = {"function", "nil"}, error = true},
	})
	-- onFulfilled must be a function or nil
	if onFulfilled == nil then onFulfilled = f end
	-- onRejected must be a function or nil
	if onRejected == nil then onRejected = f end
	-- If self.state is not "pending" then error
	if self.state ~= "pending" then
		return Promise.reject("Error (Promise.then_): Promise is already " .. self.state)
	end
	
	-- Make locals to collect the results of self.fn
	local result = {
		val = nil, 
		force_reject = self.force_reject,
		success = true,
		err = nil
	}
	result.update = function(val, rej)
		if result.val == nil then
			result.val = val
			if rej == true then result.force_reject = true end
		end
	end
	
	-- Local resolve and reject functions
	local _resolve = function(value) result.update(value) end
	local _reject = function(value) result.update(value, true) end
	
	-- Call self.fn
	result.success, result.err = pcall(self.fn, _resolve, _reject)
	
	-- Return a new promise with the results
	if result.success and not result.force_reject then
		onFulfilled(result.val)
		self.state = "fulfilled"
		return Promise.resolve(result.val)
	else
		onRejected(result[1])
		self.state = "rejected"
		return Promise.reject(result.success and result.val or result.err)
	end
end

--[[
tmp = Promise.new(function(resolve, reject)
	-- In 10 seconds call resolve(20)
	setTimeout(10, resolve, 20)
end)

tmp:then_(function(value) print("Value", value) end, function(err) print("Error", err) end)
]]

--- Catch function for promises
-- @param onRejected <function>: The function to call if the promise is rejected
-- @return A promise object
Promise.catch = function(self, onRejected)
	-- onRejected must be a function
	if type(onRejected) ~= "function" then
		function_type_warn("catch", "First", "onRejected", "a function", true)
	end
	
	return Promise.then_(self, nil, onRejected)
end

--- Finally function for promises
-- Can be used to clone the current promise as it does not settle it
-- @param onFinally <function>: The function to call if the promise becomes settled
-- @return A promise object containing the function of the current promise
Promise.finally = function(self, onFinally)
	-- onFinally must be a function
	if type(onFinally) ~= "function" then
		function_type_warn("finally", "First", "onFinally", "a function", true)
	end
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



--[[
	*************************
	Non JS methods 
	*************************
--]]

--- Poke a promise with a debug stick and see what happens
-- Also for those who want a table returned instead of a promise
-- @param promise <promise>: The promise to poke
-- @return boolean, table: true if no error, the settled state and value of the promise
Promise.poke = function(promise)
	local result = {value=nil, state=nil}
	-- Check that the argument is a promise
	if not Promise.is_promise(promise) then
		local _, err = pcall(function_type_warn, "poke", "First", "promise", "a Promise instance")
		result.value = err
		return false, result -- Stop execution and return the error
	end
	
	local set_result_value = function(value) result.value = value end
	-- Operate on the promise based on its state and force_reject flag
	if promise.state ~= "pending" then
		promise:catch(f):catch(set_result_value)
		result.state = promise.state
		return false, result
	elseif promise.force_reject then
		promise:catch(set_result_value)
		result.state = promise.state
	else
		promise:then_(set_result_value, set_result_value)
		result.state = promise.state
	end
	
	return true, result
end



return Promise

--- TESTS
--[[
Promise = require "promise_tech"

tmp = Promise.resolve(5)
tmp:then_(print, nil):then_(print, nil):then_(print, nil)

tmp = Promise.reject(7)
tmp:then_(nil, print):then_(nil, print):then_(nil, print)

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
Vx2 = 0
test():then_(function(value) Vx2 = value end, function(value) print("caught rejection, value", value) end):
	then_(function(value) print("Sqrt is", math.sqrt(value)) end)
if Vx2 ~= 0 then print("Vx2", Vx2) end

-- Security test

tmp = {val = nil, err = nil}
tmp_set = function(val)
	tmp["val"] = val
	print("DEBUG tmp_set val", val)
end
tmp_err = function(err)
	tmp["err"] = err
	print("DEBUG tmp_err err", err)
end

tmp1 = Promise.resolve(3)

tmp1:then_(tmp_set, tmp_err)
-- Prints "DEBUG tmp_set val       3"
print(tmp.val, tmp.err)
-- Prints "3       nil"

tmp1:then_(tmp_set, tmp_err)
-- Prints nothing
print(tmp.val, tmp.err)
-- Still returns "3       nil"
-- But there was no DEBUG print

tmp1:then_(tmp_set, tmp_err):catch(tmp_err)
-- Prints "DEBUG tmp_err err       Error (Promise.then_): Promise is already fulfilled"
print(tmp.val, tmp.err)
-- Prints "3       Error (Promise.then_): Promise is already fulfilled"

Now we get our error: "Error (Promise.then_): Promise is already fulfilled"
This functionality is a safeguard against executing the function of a promise more than once
The promise will simply "short-circuit" the return a new promise with the error without evaluating anything
--]]