local wea = worldeditadditions
local Vector3 = wea.Vector3

--- Applies the given brush at the given x/z position to the given heightmap.
-- Important: Where a Vector3 is mentioned in the parameter list, it reall MUST
-- be a Vector3 instance.
-- Also important: Remember that the position there is RELATIVE TO THE HEIGHTMAP'S origin (0, 0) and is on the X and Z axes!
-- @param	brush			table	The ZERO-indexed brush to apply. Values should be normalised to be between 0 and 1.
-- @param	brush_size		Vector3	The size of the brush on the x/y axes.
-- @pram	height			number	The multiplier to apply to each brush pixel value just before applying it. Negative values are allowed - this will cause a subtraction operation instead of an addition.
-- @param	position		Vector3	The position RELATIVE TO THE HEIGHTMAP on the x/z coordinates to centre the brush application on.
-- @param	heightmap		table	The heightmap to apply the brush to. See worldeditadditions.make_heightmap for how to obtain one of these.
-- @param	heightmap_size	Vector3	The size of the aforementioned heightmap. See worldeditadditions.make_heightmap for more information.
-- @returns	true,number,number|false,string		If the operation was not successful, then false followed by an error message as a string is returned. If it was successful however, 3 values are returned: true, then the number of nodes added, then the number of nodes removed.
local function apply_heightmap(brush, brush_size, height, position, heightmap, heightmap_size)
	-- Convert brush_size to match the scheme used in the heightmap
	brush_size = brush_size:clone()
	brush_size.z = brush_size.y
	brush_size.y = 0
	
	local brush_radius = (brush_size/2):ceil() - 1
	local pos_start = (position - brush_radius)
		:clamp(Vector3.new(0, 0, 0), heightmap_size)
	local pos_end = (pos_start + brush_size)
		:clamp(Vector3.new(0, 0, 0), heightmap_size)
	
	local added = 0
	local removed = 0
	
	-- Iterate over the heightmap and apply the brush
	-- Note that we do not iterate over the brush, because we don't know if the
	-- brush actually fits inside the region.... O.o
	for z = pos_end.z - 1, pos_start.z, -1 do
		for x = pos_end.x - 1, pos_start.x, -1 do
			local hi = z*heightmap_size.x + x
			local pos_brush = Vector3.new(x, 0, z) - pos_start
			local bi = pos_brush.z*brush_size.x + pos_brush.x
			
			local adjustment = math.floor(brush[bi]*height)
			if adjustment > 0 then
				added = added + adjustment
			elseif adjustment < 0 then
				removed = removed + math.abs(adjustment)
			end
			
			heightmap[hi] = heightmap[hi] + adjustment
		end
	end
	
	return true, added, removed
end


return apply_heightmap
