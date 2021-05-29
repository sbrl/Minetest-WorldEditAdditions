local wea = worldeditadditions

--- Parses a comma-separated side numbers list out into a list of numbers.
-- @param	list	string	The command separated list to parse.
-- @returns	number[]		A list of side numbers.
local function parse_sides_list(list)
	list = list:gsub("%s", "")	-- Spaces are not permitted
	return wea.table_unique(wea.table_map(
		wea.split(list, ","),
		function(value) return tonumber(value) end
	))
end

function worldeditadditions.erode.river(heightmap_initial, heightmap, heightmap_size, region_height, params_custom)
	local params = {
		steps = 1,				-- Number of rounds/passes of the algorithm to run
		remove_sides = "0,1",	-- Cells with this many adjacent horizontal neighbours will be removed
		fill_sides = "4,3"		-- Cells with this many adjaect horizontal neighbours will be filled in
	}
	-- Apply the custom settings
	wea.table_apply(params_custom, params)
	
	params.remove_sides = parse_sides_list(params.remove_sides)
	params.fill_sides = parse_sides_list(params.fill_sides)
	
	local timings = {}
	local filled = 0
	local removed = 0
	for i=1,params.steps do
		local time_start = wea.get_ms_time()
		
		for z = heightmap_size.z - 1, 0, -1 do
			for x = heightmap_size.x - 1, 0, -1 do
				local hi = z*heightmap_size.x + x
				local thisheight = heightmap[hi]
				
				local sides = 0
				local adjacent_heights = { }
				if x > 0 then
					table.insert(adjacent_heights, heightmap[z*heightmap_size.x + x-1])
					if heightmap[z*heightmap_size.x + x-1] >= thisheight then
						sides = sides + 1
					end
				end
				if x < heightmap_size.x - 1 then
					table.insert(adjacent_heights, heightmap[z*heightmap_size.x + x+1])
					if heightmap[z*heightmap_size.x + x+1] >= thisheight then
						sides = sides + 1
					end
				end
				if z > 0 then
					table.insert(adjacent_heights, heightmap[(z-1)*heightmap_size.x + x])
					if heightmap[(z-1)*heightmap_size.x + x] >= thisheight then
						sides = sides + 1
					end
				end
				if z < heightmap_size.z - 1 then
					table.insert(adjacent_heights, heightmap[(z+1)*heightmap_size.x + x])
					if heightmap[(z+1)*heightmap_size.x + x] >= thisheight then
						sides = sides + 1
					end
				end
				
				local action = "none"
				for i,sidecount in ipairs(params.fill_sides) do
					if sidecount == sides then
						action = "fill"
						break
					end
				end
				for i,sidecount in ipairs(params.remove_sides) do
					if sidecount == sides then
						action = "remove"
						break
					end
				end
				
				if action == "fill" then
					heightmap[hi] = heightmap[hi] + 1
					filled = filled + 1
				elseif action == "remove" then
					heightmap[hi] = heightmap[hi] - 1
					removed = removed + 1
				end
			end
		end
		
		table.insert(timings, wea.get_ms_time() - time_start)
	end
	
	return true, params.steps.." steps made, raising "..filled.." and lowering "..removed.." columns in "..wea.format.human_time(wea.sum(timings)).." (~"..wea.format.human_time(wea.average(timings)).." per step)"
end
