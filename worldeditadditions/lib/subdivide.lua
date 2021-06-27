-- ███████ ██    ██ ██████  ██████  ██ ██    ██ ██ ██████  ███████
-- ██      ██    ██ ██   ██ ██   ██ ██ ██    ██ ██ ██   ██ ██
-- ███████ ██    ██ ██████  ██   ██ ██ ██    ██ ██ ██   ██ █████
--      ██ ██    ██ ██   ██ ██   ██ ██  ██  ██  ██ ██   ██ ██
-- ███████  ██████  ██████  ██████  ██   ████   ██ ██████  ███████
local wea = worldeditadditions

-- Counts the number of chunks in the given area.
-- Maths is now done properly. Values from this new implementation were tested
-- with 1000 random pos1, pos2, and chunk_size combinations and found to be identical.
local function count_chunks(pos1, pos2, chunk_size)
	-- Assume pos1 & pos2 are sorted
	local dimensions = {
		x = pos2.x - pos1.x + 1,
		y = pos2.y - pos1.y + 1,
		z = pos2.z - pos1.z + 1,
	}
	-- print("[new] dimensions", dimensions.x, dimensions.y, dimensions.z)
	return math.ceil(dimensions.x / chunk_size.x)
		* math.ceil(dimensions.y / chunk_size.y)
		* math.ceil(dimensions.z / chunk_size.z)
end


local function merge_stats(a, b)
	for key,value in pairs(a) do
		if not b[key] then b[key] = 0 end
		b[key] = a[key] + b[key]
	end
end

local function make_stats_obj(state)
	return {
		chunks_total = state.chunks_total,
		chunks_completed = state.chunks_completed,
		chunk_size = state.chunk_size,
		volume_nodes = state.volume_nodes,
		emerge = state.stats_emerge,
		times = state.times,
		eta = state.eta,
		emerge_overhead = state.emerge_overhead
	}
end

local function subdivide_step_complete(state)
	state.times.total = wea.get_ms_time() - state.times.start
	
	state.callback_complete(
		state.pos1,
		state.pos2,
		make_stats_obj(state)
	)
end

local function subdivide_step_beforeload(state)
	state.cpos.z = state.cpos.z - (state.chunk_size.z + 1)
	if state.cpos.z < state.pos1.z then
		state.cpos.z = state.pos2.z
		state.cpos.y = state.cpos.y - (state.chunk_size.y + 1)
		if state.cpos.y < state.pos1.y then
			state.cpos.y = state.pos2.y
			state.cpos.x = state.cpos.x - (state.chunk_size.x + 1)
			if state.cpos.x < state.pos1.x then
				subdivide_step_complete(state)
				return
			end
		end
	end
	
	state.cpos2 = { x = state.cpos.x, y = state.cpos.y, z = state.cpos.z }
	state.cpos1 = {
		x = state.cpos.x - state.chunk_size.x,
		y = state.cpos.y - state.chunk_size.y,
		z = state.cpos.z - state.chunk_size.z
	}
	if state.cpos1.x < state.pos1.x then state.cpos1.x = state.pos1.x end
	if state.cpos1.y < state.pos1.y then state.cpos1.y = state.pos1.y end
	if state.cpos1.z < state.pos1.z then state.cpos1.z = state.pos1.z end
	
	state.times.emerge_last = wea.get_ms_time()
	
	-- print("[BEFORE_EMERGE] c1", wea.vector.tostring(state.cpos1), "c2", wea.vector.tostring(state.cpos2), "volume", worldedit.volume(state.cpos1, state.cpos2))
	worldeditadditions.emerge_area(state.cpos1, state.cpos2, state.__afterload, state)
end

local function subdivide_step_afterload(state_emerge, state_ours)
	-- print("[AFTER_EMERGE] c1", wea.vector.tostring(state_ours.cpos1), "c2", wea.vector.tostring(state_ours.cpos2), "volume", worldedit.volume(state_ours.cpos1, state_ours.cpos2))
	state_ours.times.emerge_last = wea.get_ms_time() - state_ours.times.emerge_last
	table.insert(state_ours.times.emerge, state_ours.times.emerge_last)
	if #state_ours.times.emerge > 25 then
		state_ours.times.emerge = wea.table.get_last(state_ours.times.emerge, 100)
	end
	state_ours.times.emerge_total = state_ours.times.emerge_total + state_ours.times.emerge_last
	
	merge_stats(state_emerge.stats, state_ours.stats_emerge)
	
	state_ours.chunks_completed = state_ours.chunks_completed + 1
	
	local callback_last = wea.get_ms_time()
	state_ours.callback_subblock(
		state_ours.cpos1,
		state_ours.cpos2,
		make_stats_obj(state_ours)
	)
	state_ours.times.callback_last = wea.get_ms_time() - callback_last
	table.insert(state_ours.times.callback, state_ours.times.callback_last)
	
	state_ours.times.step_last = wea.get_ms_time() - state_ours.times.step_start_abs
	table.insert(state_ours.times.steps, state_ours.times.step_last)
	if #state_ours.times.steps > 25 then
		state_ours.times.steps = wea.table.get_last(state_ours.times.steps, 100)
	end
	state_ours.times.steps_total = state_ours.times.steps_total + state_ours.times.step_last
	state_ours.times.step_start_abs = wea.get_ms_time()
	state_ours.eta = wea.eta(
		state_ours.times.steps,
		state_ours.chunks_completed,
		state_ours.chunks_total
	)
	if state_ours.chunks_completed > 0 then
		state_ours.emerge_overhead = state_ours.times.emerge_total / state_ours.times.steps_total
	end
	
	minetest.after(0, state_ours.__beforeload, state_ours)
end

--- Calls the given callback function once for each block in the defined area.
-- This function is asynchronous, as it also uses minetest.emerge_area() to
-- ensure that the blocks are loaded before calling the callback function.
-- The callback functions will be passed the following arguments: pos1, pos2, stats
-- pos1 and pos2 refer to the defined region of just the local block.
-- stats is an table of statistics resembling the following:
-- { chunks_completed, chunks_total, emerge = { ... }, times = { emerge = {}, emerge_last, callback = {}, callback_last, steps = {}, step_last } }
-- The emerge property contains a table that holds a running total of statistics
-- about what Minetest did to emerge the requested blocks in the world.
-- callback_complete is called at the end of the process, and pos1 + pos2 will be set to that of the entire region.
-- @param	{Vector}	pos1		The first position defining the area to emerge.
-- @param	{Vector}	pos2		The second position defining the area to emerge.
-- @param	{Vector}	chunk_size	The size of the chunks to subdivide into.
-- @param	{function}	callback	The callback to call for each block.
-- @param	{function}	callback	The callback to call upon completion.
function worldeditadditions.subdivide(pos1, pos2, chunk_size, callback_subblock, callback_complete)
	pos1, pos2 = worldedit.sort_pos(pos1, pos2)
	local chunks_total = count_chunks(pos1, pos2, chunk_size)
	
	chunk_size.x = chunk_size.x - 1 -- WorldEdit regions are inclusive
	chunk_size.y = chunk_size.y - 1 -- WorldEdit regions are inclusive
	chunk_size.z = chunk_size.z - 1 -- WorldEdit regions are inclusive
	
	local state = {
		pos1 = pos1, pos2 = pos2,
		-- Note that we start 1 over on the Z axis because we increment *before* calling the callback, so if we don't fiddle it here, we'll miss the first chunk
		cpos = { x = pos2.x, y = pos2.y, z = pos2.z + chunk_size.z + 1 },
		-- The size of a single subblock
		chunk_size = chunk_size,
		-- The total number of nodes in the defined region
		volume_nodes = worldedit.volume(pos1, pos2),
		stats_emerge = {},
		times = {
			-- Total time per step
			steps_total = 0,
			steps = {}, step_last = 0, step_start_abs = wea.get_ms_time(),
			-- Time per step spent on mineteest.emerge_area()
			emerge_total = 0,
			emerge = {}, emerge_last = 0,
			-- Timme per step spent running the callback
			callback = {}, callback_last = 0,
			-- The start time (absolute)
			start = wea.get_ms_time(),
			-- The eta (in ms) until we're done
			eta = 0
		},
		-- The percentage of the total time spent so far waiting for Minetest to emerge blocks. Updated every step.
		emerge_overhead = 0,
		-- The total number of chunks
		chunks_total = chunks_total,
		-- The number of chunks processed so far
		chunks_completed = 0,
		callback_subblock = callback_subblock,
		callback_complete = callback_complete,
		
		__beforeload = subdivide_step_beforeload,
		__afterload = subdivide_step_afterload
	}
	
	subdivide_step_beforeload(state)
end
