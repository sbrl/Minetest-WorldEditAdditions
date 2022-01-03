--- Copies a region to another location, potentially overwriting the exiting region.
-- @module worldeditadditions.copy

local wea = worldeditadditions
local Vector3 = wea.Vector3

-- ███    ███  ██████  ██    ██ ███████
-- ████  ████ ██    ██ ██    ██ ██
-- ██ ████ ██ ██    ██ ██    ██ █████
-- ██  ██  ██ ██    ██  ██  ██  ██
-- ██      ██  ██████    ████   ███████

function worldeditadditions.move(source_pos1, source_pos2, target_pos1, target_pos2)
	---
	-- 0: Preamble
	---
	
	source_pos1, source_pos2 = Vector3.sort(source_pos1, source_pos2)
	target_pos1, target_pos2 = Vector3.sort(target_pos1, target_pos2)
	
	local offset = source_pos1:subtract(target_pos1)
	-- {source,target}_pos2 will always have the highest co-ordinates now
	
	local node_id_air = minetest.get_content_id("air")
	
	-- Fetch the nodes in the source area
	local manip_source, area_source = worldedit.manip_helpers.init(source_pos1, source_pos2)
	local data_source = manip_source:get_data()
	
	-- Fetch a manip for the target area
	local manip_target, area_target = worldedit.manip_helpers.init(target_pos1, target_pos2)
	local data_target = manip_target:get_data()
	
	
	---
	-- 1: Perform Copy
	---
	
	-- z y x is the preferred loop order (because CPU cache, since then we're iterating linearly through the data array backwards. This only holds true for little-endian machines however)
	for z = source_pos2.z, source_pos1.z, -1 do
		for y = source_pos2.y, source_pos1.y, -1 do
			for x = source_pos2.x, source_pos1.x, -1 do
				local source = Vector3.new(x, y, z)
				local source_i = area_source:index(x, y, z)
				local target = source:subtract(offset)
				local target_i = area_target:index(target.x, target.y, target.z)
				
				
				data_target[target_i] = data_source[source_i]
				
			end
		end
	end
	
	-- Save the modified nodes back to disk & return
	-- Note that we save the source region *first* to avoid issues with overlap
	
	-- BUG: Voxel Manipulators cover a larger area than the source area if the target position is too close the to the source, then the source will be overwritten by the target by accident.
	
	-- Potential solution:
	-- 1. Grab source & target
	-- 2. Perform copy → target
	-- 3. Save target
	-- 4. Re-grab source
	-- 5. Zero out source, but avoiding touching any nodes that fall within target
	-- 6. Save source
	
	
	---
	-- 2: Save target
	---
	
	worldedit.manip_helpers.finish(manip_target, data_target)
	
	
	---
	-- 3: Re-grab source
	---
	
	manip_source, area_source = worldedit.manip_helpers.init(source_pos1, source_pos2)
	data_source = manip_source:get_data()
	
	
	---
	-- 4: Zero out source, but avoiding touching any nodes that fall within target
	---
	
	for z = source_pos2.z, source_pos1.z, -1 do
		for y = source_pos2.y, source_pos1.y, -1 do
			for x = source_pos2.x, source_pos1.x, -1 do
				local source = Vector3.new(x, y, z)
				local source_i = area_source:index(x, y, z)
				local target = source:subtract(offset)
				local target_i = area_target:index(target.x, target.y, target.z)
				
				if not source:is_contained(target_pos1, target_pos2) then
					data_source[source_i] = node_id_air
				end
			end
		end
	end
	
	
	--- 
	-- 5: Save source
	---
	
	worldedit.manip_helpers.finish(manip_source, data_source)
	
	
	
	---
	-- 6: Finish up and return
	---
	
	return true, worldedit.volume(target_pos1, target_pos2)
end
