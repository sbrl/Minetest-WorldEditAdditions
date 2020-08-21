
local function snowball(heightmap, normalmap, heightmap_size, startpos, params)
	local offset = { -- Random jitter - apparently helps to avoid snowballs from entrenching too much
		x = (math.random() * 2 - 1) * params.radius,
		z = (math.random() * 2 - 1) * params.radius
	}
	local sediment = 0
	local pos = { x = startpos.x, z = startpos.z }
	local pos_prev = { x = pos.x, z = pos.z }
	local velocity = { x = 0, z = 0 }
	local heightmap_length = #heightmap
	
	for i = 1, params.snowball_max_steps do
		local hi = math.floor(pos.z+offset.z+0.5)*heightmap_size[1] + math.floor(pos.x+offset.x+0.5)
		if hi > heightmap_length then break end
		
		-- Stop if we go out of bounds
		if offset.x < 0 or offset.z < 0
			or offset.x >= heightmap[1] or offset.z >= heightmap[0] then
			break
		end
		
		local step_deposit = sediment * params.rate_deposit * normalmap[hi].z
		local step_erode = params.rate_erosion * (1 - normalmap[hi].z) * math.min(1, i*params.scale_iterations)
		
		-- Erode / Deposit, but only if we are on a different node than we were in the last step
		if math.floor(pos_prev.x) ~= math.floor(pos.x)
			and math.floor(pos_prev.z) ~= math.floor(pos.z) then
			heightmap[hi] = heightmap[hi] + (deposit - erosion)
		end
		
		velocity.x = params.friction * velocity.x + normalmap[hi].x * params.speed
		velocity.z = params.friction * velocity.z + normalmap[hi].y * params.speed
		pos_prev.x = pos.x
		pos_prev.z = pos.z
		pos.x = pos.x + velocity.x
		pos.z = pos.z + velocity.z
	end
	
	-- Round everything to the nearest int, since you can't really have
	-- something like .141592671 of a node
	for i,v in ipairs(heightmap) do
		heightmap[i] = math.floor(heightmap[i] + 0.5)
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
	
	local normals = worldeditadditions.calculate_normals(heightmap, heightmap_size)
	
	for i = 1, params.snowball_count do
		snowball(
			heightmap, normals, heightmap_size,
			{ x = math.random() }
		)
	end
end
