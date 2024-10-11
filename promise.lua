local inspect = require("worldeditadditions_core.utils.inspect")

--- Javascript Promises, implemented in Lua
-- In other words, a wrapper to manage asynchronous operations.
-- Due to limitations of Lua, while this Promise API is similar it isn't exactly the same as in JS. Most notably is that there is a .run() function you must call AFTER you call .then_() as many times as you need.
-- 
-- Also, .then_() does not return a thenable value but the SAME ORIGINAL promise, as we stack up all functions and then execute them in order once you call .run(). This has the subtle implication that Promise.state is not set to "fulfilled" until ALL functions in the chain have been called.
-- 
-- Additionally, every .then_(function(...) end) MAY return a promise themselves if they wish. These promises WILL be automatically executed when you call .run() on the PARENT promise, as they are considered required for the parent Promise function chain to run to completion.
-- @class	worldeditadditions_core.Promise
local Promise = {}
Promise.__index = Promise
Promise.__name = "Promise" -- A hack to allow identification in wea.inspect

--- Creates a new Promise instance.
-- @param fn 	function	The function to wrap into a promise.
function Promise.new(fn)
	local result = {
		state = "pending",
		fns = { { fn_then_ = fn } }
	}
	setmetatable(result, Promise)
	
	return result
end


------------------------------------------------------------------------

---@diagnostic disable-next-line
local do_unpack = unpack
if not do_unpack then do_unpack = table.unpack end
if not do_unpack then
	error("Error: Failed to find unpack implementation")
end

local function do_run(promise, args, depth, origin_resolve)
	-- print("DO_RUN promise", inspect(promise), "args", inspect(args), "depth", depth, "origin_resolve", origin_resolve)
	---
	-- 0: Termination condition
	---
	if #promise.fns == 0 then
		promise.state = "fulfilled"
		origin_resolve(do_unpack(args))
		return
	end

	---
	-- 1: Sort out inputs
	---
	if args == nil then args = {} end
	local next = table.remove(promise.fns, 1)

	local do_next_fn = function(args_to_pass)
		do_run(promise, args_to_pass, depth + 1, origin_resolve)
	end


	---
	-- 2: Run teh function!
	---
	
	-- (if it's the 1st one in the sequence we treat it specially)
	local results
	if depth == 1 then
		-- This function is the inner one of a promise already.
		-- It has already received arguments, so it expected resolve/reject instead
		next.fn_then_(function(...) -- RESOLVE
			if getmetatable(arg[1]) == Promise then
				promise.state = "rejected"
				error("Error: Returning nested Promises is not currently supported.")
			end

			do_next_fn(arg) -- Execute the next one in the sequence
		end, function(...) -- REJECT
			promise.state = "rejected"
			if type(next.fn_catch_) == "function" then
				next.fn_catch_(do_unpack(arg))
			else
				error(
				"Error: Promise rejected but no catch function present. TODO make this error message more useful and informative.")
				-- If there's no catch registered, throw an error
			end
		end)
	else
		results = { next.fn_then_(do_unpack(args)) }

		---
		-- 3: Handle the aftermath
		---
		if #results == 1 and getmetatable(results[1]) == Promise then
			-- It's a promise!
			-- Calling do_run does NOT cause an infinite loop, because fns[1] is the INNER function that expects to be passed resolve, reject
			do_run(
				results[1], -- The child promise
				{},
				1,
				function(...)
					-- Once this entire subchain is done, do the next function in this chain
					do_next_fn(arg)
				end
			)
		else
			-- Not a promise, carry on
			do_next_fn(results)
		end
	end
end

------------------------------------------------------------------------


-- NOTE: fn_catch support is NOT FULLY IMPLEMENTED yet!
-- Example: It doesn't work when calling non-async .then()s!
function Promise.then_(self, fn_then, fn_catch)
	local step_item = {
		fn_then_ = fn_then,
	}
	if type(fn_catch) == "function" then
		step_item.fn_catch_ = fn_catch
	end
	
	table.insert(self.fns, step_item)
	
	return self
end

--- Executes the function this Promise is wrapping all associated chained functions in sequence.
-- This is a separate method for portability, since Lua does not implement setTimeout which is required to ensure that if an non-async function is wrapped the parent function still has time to call .then_() before it finishes and the associated .then_()ed functions are attached correctly.
-- 
-- WARNING: If you call .then_() AFTER calling .run(), your .then_()ed function may not be called correctly!
-- @returns	Promise	The current promise, for daisy chaining purposes.
function Promise.run(self)
	-- TODO update self.state here
	do_run(self, {}, 1, function(...)
		
	end)
	return self
end




-- return Promise


-- TEST example code, TODO test this

local function test()
	return Promise.new(function(resolve, reject)
		-- TODO do something asyncy here
		print("DEBUG running test function")
		resolve(4)
	end)
end


test()
	:then_(function(val)
		print("DEBUG then #1 VAL", val)
		return val * 2
	end)
	:then_(function(val)
		print("DEBUG then #2 VAL", val)
		return math.sqrt(val)
	end)
	:then_(function(val)
		print("DEBUG then #3 VAL", val)
	end)
	:run()

