local wea = worldeditadditions
local Vector3 = wea.Vector3

-- Test command: //multi //fp set1 1313 6 5540 //fp set2 1338 17 5521 //erode snowballs

local function snowball(heightmap, normalmap, heightmap_size, startpos, params)
	local sediment = 0
	local pos = { x = startpos.x, z = startpos.z }
	local pos_prev = { x = pos.x, z = pos.z }
	local velocity = {
		x = (math.random() * 2 - 1) * params.init_velocity,
		z = (math.random() * 2 - 1) * params.init_velocity
	}
	local heightmap_length = #heightmap
	
	-- print("[snowball] startpos ("..pos.x..", "..pos.z.."), velocity: ("..velocity.x..", "..velocity.z..")")
	
	local hist_velocity = {}
	
	for i = 1, params.max_steps do
		local x = pos.x
		local z = pos.z
		local hi = math.floor(z+0.5)*heightmap_size.x + math.floor(x+0.5)
		-- Stop if we go out of bounds
		if x < 0 or z < 0
			or x >= heightmap_size.x-1 or z >= heightmap_size.z-1 then
			-- print("[snowball] hit edge; stopping at ("..x..", "..z.."), (bounds @ "..(heightmap_size.x-1)..", "..(heightmap_size.z-1)..")", "x", x, "/", heightmap_size.x-1, "z", z, "/", heightmap_size.z-1)
			return true, i
		end
		
		if #hist_velocity > 0 and i > 5
			and wea.average(hist_velocity) < 0.03 then
			-- print("[snowball] It looks like we've stopped")
			return true, i
		end
		
		if normalmap[hi].y == 1 then return true, i end
		
		if hi > heightmap_length then return false, "Out-of-bounds on the array, hi: "..hi..", heightmap_length: "..heightmap_length end
		
		-- NOTE: We need to decide whether we want to keep the precomputed normals as we have now, or whether we want to dynamically compute them at the time of request.
		-- print("[snowball] sediment", sediment, "rate_deposit", params.rate_deposit, "normalmap[hi].z", normalmap[hi].z)
		local step_deposit = sediment * params.rate_deposit * normalmap[hi].z
		local step_erode = params.rate_erosion * (1 - normalmap[hi].z) * math.min(1, i*params.scale_iterations)
		
		-- Erode / Deposit, but only if we are on a different node than we were in the last step
		if math.floor(pos_prev.x) ~= math.floor(x)
			and math.floor(pos_prev.z) ~= math.floor(z) then
			heightmap[hi] = heightmap[hi] + (step_deposit - step_erode)
		end
		
		velocity.x = params.friction * velocity.x + normalmap[hi].x * params.speed
		velocity.z = params.friction * velocity.z + normalmap[hi].y * params.speed
		
		-- print("[snowball] now at ("..x..", "..z..") velocity "..wea.vector.lengthsquared(velocity)..", sediment "..sediment)
		local new_vel_sq = wea.vector.lengthsquared(velocity)
		if new_vel_sq > 1 then
			-- print("[snowball] velocity squared over 1, normalising")
			velocity = wea.vector.normalize(velocity)
		end
		table.insert(hist_velocity, new_vel_sq)
		if #hist_velocity > params.velocity_hist_count then table.remove(hist_velocity, 1) end
		pos_prev.x = x
		pos_prev.z = z
		pos.x = pos.x + velocity.x
		pos.z = pos.z + velocity.z
		sediment = sediment + (step_erode - step_deposit) -- Needs to be erosion - deposit, which is the opposite to the above
	end
	return true, params.max_steps
end

--[[
2D erosion algorithm based on snowballs
Note that this *mutates* the given heightmap.
@source https://jobtalle.com/simulating_hydraulic_erosion.html

]]--
function wea.erode.snowballs(heightmap_initial, heightmap, heightmap_size, region_height, params_custom)
	local params = {
		rate_deposit = 0.03, -- 0.03
		rate_erosion = 0.04, -- 0.04
		friction = 0.07,
		speed = 1,
		max_steps = 80,
		velocity_hist_count = 3,
		init_velocity = 0.25,
		scale_iterations = 0.04,
		maxdiff = 0.4,
		count = 25000
	}
	-- Apply the custom settings
	wea.table.apply(params_custom, params)
	
	-- print("[erode/snowballs] params: ")
	-- print(wea.format.map(params))
	
	local normals = wea.terrain.calculate_normals(heightmap, heightmap_size)
	
	local stats_steps = {}
	for i = 1, params.count do
		-- print("[snowballs] starting snowball ", i)
		local success, steps = snowball(
			heightmap, normals, heightmap_size,
			{
				x = math.random() * (heightmap_size.x - 1),
				z = math.random() * (heightmap_size.z - 1)
			},
			params
		)
		table.insert(stats_steps, steps)
		
		if not success then return false, "Error: Failed at snowball "..i..":"..steps end
	end
	
	-- print("[snowballs] "..#stats_steps.." snowballs simulated, max "..params.max_steps.." steps, averaged ~"..wea.average(stats_steps).."")
	
	-- Round everything to the nearest int, since you can't really have
	-- something like .141592671 of a node
	-- Note that we do this after *all* the erosion is complete
	local clamp_limit = math.floor(region_height * params.maxdiff + 0.5)
	for i,v in ipairs(heightmap) do
		heightmap[i] = math.floor(heightmap[i] + 0.5)
		if heightmap[i] < 0 then heightmap[i] = 0 end
		-- Limit the distance to params.maxdiff% of the region height
		if math.abs(heightmap_initial[i] - heightmap[i]) > region_height * params.maxdiff then
			if heightmap_initial[i] - heightmap[i] > 0 then
				heightmap[i] = heightmap_initial[i] - clamp_limit
			else
				heightmap[i] = heightmap_initial[i] + clamp_limit
			end
		end
	end
	
	if not params.noconv then
		local success, matrix = wea.get_conv_kernel("gaussian", 3, 3)
		if not success then return success, matrix end
		local matrix_size = Vector3.new(3, 0, 3)
		wea.conv.convolve(
			heightmap, heightmap_size,
			matrix,
			matrix_size
		)
	end
	
	return true, ""..#stats_steps.." snowballs simulated, max "..params.max_steps.." steps (averaged ~"..wea.average(stats_steps).." steps)"
end
