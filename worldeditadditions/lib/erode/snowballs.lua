
-- Test command: //multi //fp set1 1312 5 5543 //fp set2 1336 18 5521 //erode//multi //fp set1 1312 5 5543 //fp set2 1336 18 5521 //erode

local function snowball(heightmap, normalmap, heightmap_size, startpos, params)
	local sediment = 0
	local pos = { x = startpos.x, z = startpos.z }
	local pos_prev = { x = pos.x, z = pos.z }
	local velocity = { x = 0, z = 0 }
	local heightmap_length = #heightmap
	
	-- print("[snowball] startpos ("..pos.x..", "..pos.z..")")
	
	for i = 1, params.snowball_max_steps do
		local x = pos.x
		local z = pos.z
		local hi = math.floor(z+0.5)*heightmap_size[1] + math.floor(x+0.5)
		-- Stop if we go out of bounds
		if x < 0 or z < 0
			or x >= heightmap[1]-1 or z >= heightmap[0]-1 then
			-- print("[snowball] hit edge; stopping at ("..x..", "..z.."), (bounds @ "..heightmap_size[1]..", "..heightmap_size[0]..")")
			return
		end
		-- print("[snowball] now at ("..x..", "..z..") (bounds @ "..heightmap_size[1]..", "..heightmap_size[0]..")")
		
		if hi > heightmap_length then print("[snowball] out-of-bounds on the array, hi: "..hi..", heightmap_length: "..heightmap_length) return end
		
		-- print("[snowball] sediment", sediment, "rate_deposit", params.rate_deposit, "normalmap[hi].z", normalmap[hi].z)
		local step_deposit = sediment * params.rate_deposit * normalmap[hi].z
		local step_erode = params.rate_erosion * (1 - normalmap[hi].z) * math.min(1, i*params.scale_iterations)
		
		local step_diff = step_deposit - step_erode
		
		-- Erode / Deposit, but only if we are on a different node than we were in the last step
		if math.floor(pos_prev.x) ~= math.floor(x)
			and math.floor(pos_prev.z) ~= math.floor(z) then
			heightmap[hi] = heightmap[hi] + step_diff
		end
		
		velocity.x = params.friction * velocity.x + normalmap[hi].x * params.speed
		velocity.z = params.friction * velocity.z + normalmap[hi].y * params.speed
		pos_prev.x = x
		pos_prev.z = z
		pos.x = pos.x + velocity.x
		pos.z = pos.z + velocity.z
		sediment = sediment + step_diff
	end
end

--[[
2D erosion algorithm based on snowballs
Note that this *mutates* the given heightmap.
@source https://jobtalle.com/simulating_hydraulic_erosion.html

]]--
function worldeditadditions.erode.snowballs(heightmap, heightmap_size, params)
	-- Apply the default settings
	worldeditadditions.table_apply({
		rate_deposit = 0.03,
		rate_erosion = 0.04,
		friction = 0.07,
		speed = 0.15,
		radius = 0.8,
		snowball_max_steps = 80,
		scale_iterations = 0.04,
		drops_per_cell = 0.4,
		snowball_count = 50000
	}, params)
	
	print("[erode/snowballs] params: "..worldeditadditions.map_stringify(params))
	
	local normals = worldeditadditions.calculate_normals(heightmap, heightmap_size)
	
	for i = 1, params.snowball_count do
		snowball(
			heightmap, normals, heightmap_size,
			{
				x = math.random() * (heightmap_size[1] - 1),
				z = math.random() * (heightmap_size[0] - 1)
			},
			params
		)
	end
	
	-- Round everything to the nearest int, since you can't really have
	-- something like .141592671 of a node
	-- Note that we do this after *all* the erosion is complete
	for i,v in ipairs(heightmap) do
		heightmap[i] = math.floor(heightmap[i] + 0.5)
	end
	
	return true, params.snowball_count.." snowballs simulated"
end
