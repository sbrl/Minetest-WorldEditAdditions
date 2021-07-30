local wea = worldeditadditions

--- Parses a comma-separated side numbers list out into a list of numbers.
-- @param	list	string	The command separated list to parse.
-- @returns	number[]		A list of side numbers.
local function parse_sides_list(list)
	list = list:gsub("%s", "")	-- Spaces are not permitted
	return wea.table.unique(wea.table.map(
		wea.split(list, ","),
		function(value) return tonumber(value) end
	))
end

function worldeditadditions.erode.river(heightmap_initial, heightmap, heightmap_size, region_height, params_custom)
	local params = {
		steps = 1,				-- Number of rounds/passes of the algorithm to run
		lower_sides = "4,3",	-- Cells with this many adjacent horizontal neighbours that are lower than the current pixel will be removed
		raise_sides = "4,3",		-- Cells with this many adjacect horizontal neighbours that are higher than the current pixel will be filled in
		doraise = true,			-- Whether to do raise operations or not
		dolower = true			-- Whether to do lower operations or not
	}
	-- Apply the custom settings
	wea.table.apply(params_custom, params)
	
	params.lower_sides = parse_sides_list(params.lower_sides)
	params.raise_sides = parse_sides_list(params.raise_sides)
	
	local timings = {}
	local filled = 0
	local removed = 0
	for i=1,params.steps do
		-- print("[DEBUG:river] step ", i)
		-- wea.format.array_2d(heightmap, heightmap_size.x)
		local time_start = wea.get_ms_time()
		
		-- Store up changes to make and make them at the end of the step
		-- This is important, because decisions 
		local fill = { }	-- Indexes to add 1 to
		local remove = { }	-- Indexes to take 1 away from
		
		for z = heightmap_size.z - 1, 0, -1 do
			for x = heightmap_size.x - 1, 0, -1 do
				local hi = z*heightmap_size.x + x
				local thisheight = heightmap[hi]
				-- print("[DEBUG:river] z", z, "x", x, "thisheight", thisheight)
				
				local height_up = heightmap[hi]
				local height_down = heightmap[hi]
				local height_left = heightmap[hi]
				local height_right = heightmap[hi]
				
				if x > 0 then height_left = heightmap[z*heightmap_size.x + x-1] end
				if x < heightmap_size.x - 1 then height_right = heightmap[z*heightmap_size.x + x+1] end
				if z > 0 then height_up = heightmap[(z-1)*heightmap_size.x + x] end
				if z < heightmap_size.z - 1 then height_down = heightmap[(z+1)*heightmap_size.x + x] end
				
				-- Whether this pixel is on the edge
				local isedge = x <= 0
					or z <= 0
					or x >= heightmap_size.x - 1
					or z >= heightmap_size.z - 1
				
				local sides_higher = 0	-- Number of sides higher than this pixel
				local sides_lower = 0	-- Number of sides lower than this pixel
				if not isedge then
					if height_down > thisheight then sides_higher = sides_higher + 1 end
					if height_up > thisheight then sides_higher = sides_higher + 1 end
					if height_left > thisheight then sides_higher = sides_higher + 1 end
					if height_right > thisheight then sides_higher = sides_higher + 1 end
					
					if height_down < thisheight then sides_lower = sides_lower + 1 end
					if height_up < thisheight then sides_lower = sides_lower + 1 end
					if height_left < thisheight then sides_lower = sides_lower + 1 end
					if height_right < thisheight then sides_lower = sides_lower + 1 end
				end
				
				-- Perform an action, but only if we're not on the edge
				-- This is important, as we can't accurately tell how many
				-- adjacent neighbours a pixel on the edge has.
				local action = "none"
				if not isedge then 
					if sides_higher > sides_lower then
						for _,sidecount in ipairs(params.raise_sides) do
							if sidecount == sides_higher then
								action = "fill"
								break
							end
						end
					else
						for _i,sidecount in ipairs(params.lower_sides) do
							if sidecount == sides_lower then
								action = "remove"
								break
							end
						end
					end
				end
				
				
				if action == "fill" and params.doraise then
					table.insert(fill, hi)
					filled = filled + 1
				elseif action == "remove" and params.dolower then
					table.insert(remove, hi)
					removed = removed + 1
				end
				-- print("[DEBUG:river] sides_higher", sides_higher, "sides_lower", sides_lower, "action", action)
				-- wea.format.array_2d(heightmap, heightmap_size.x)
			end
		end
		
		for _i,hi in ipairs(fill) do
			heightmap[hi] = heightmap[hi] + 1
		end
		for _i,hi in ipairs(remove) do
			heightmap[hi] = heightmap[hi] - 1
		end
		
		table.insert(timings, wea.get_ms_time() - time_start)
	end
	
	return true, params.steps.." steps made, raising "..filled.." and lowering "..removed.." columns in "..wea.format.human_time(wea.sum(timings)).." (~"..wea.format.human_time(wea.average(timings)).." per step)"
end
