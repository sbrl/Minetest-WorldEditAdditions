
local wea_c = worldeditadditions_core
local Vector3 = wea_c.Vector3

-- ███    ███  ██████  ██    ██ ███████
-- ████  ████ ██    ██ ██    ██ ██
-- ██ ████ ██ ██    ██ ██    ██ █████
-- ██  ██  ██ ██    ██  ██  ██  ██
-- ██      ██  ██████    ████   ███████

--- Moves a region to another location, overwriting any nodes at the target location.
-- @param	source_pos1		Vector3		pos1 of the source region to move.
-- @param	source_pos2		Vector3		pos2 of the source region to move.
-- @param	target_pos1		Vector3		pos1 of the target region to move to.
-- @param	target_pos2		Vector3		pos2 of the target region to move to.
-- @param	airapply=false	bool		Whether to only replace target nodes that are air-like, leaving those that are not air-like. If false, then all target nodes are replaced regardless of whether they are air-like nodes or not.
-- **Caution:** If true, then **nodes in the source region will be removed and replaced with air, even if they are unable to be placed in the target location!**
-- @returns	bool,numbers	1. Whether the move operation was successful or not
-- 							2. The total number of nodes actually placed in the target region.
function worldeditadditions.move(source_pos1, source_pos2, target_pos1, target_pos2, airapply)
	---
	-- 0: Preamble
	---
	
	if airapply == nil then airapply = false end
	source_pos1, source_pos2 = Vector3.sort(source_pos1, source_pos2)
	target_pos1, target_pos2 = Vector3.sort(target_pos1, target_pos2)
	
	local offset = source_pos1:subtract(target_pos1)
	-- {source,target}_pos2 will always have the highest co-ordinates now
	
	local node_id_air = minetest.get_content_id("air")
	
	-- Fetch the nodes in the source area
	local manip_source, area_source = worldedit.manip_helpers.init(source_pos1, source_pos2)
	local data_source = manip_source:get_data()
	local data_source_param2 = manip_source:get_param2_data()
	
	-- Fetch a manip for the target area
	local manip_target, area_target = worldedit.manip_helpers.init(target_pos1, target_pos2)
	local data_target = manip_target:get_data()
	local data_target_param2 = manip_target:get_param2_data()
	
	
	---
	-- 1: Perform Copy
	---
	
	-- z y x is the preferred loop order (because CPU cache, since then we're iterating linearly through the data array backwards. This only holds true for little-endian machines however)
	local total_placed = 0
	for z = source_pos2.z, source_pos1.z, -1 do
		for y = source_pos2.y, source_pos1.y, -1 do
			for x = source_pos2.x, source_pos1.x, -1 do
				local source = Vector3.new(x, y, z)
				local source_i = area_source:index(x, y, z)
				local target = source:subtract(offset)
				local target_i = area_target:index(target.x, target.y, target.z)
				
				local should_replace = true
				if airapply then
					should_replace = wea_c.is_airlike(data_target[target_i])
				end
				if should_replace then
					data_target[target_i] = data_source[source_i]
					data_target_param2[target_i] = data_source_param2[source_i]
					total_placed = total_placed + 1
				end
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
	manip_target:set_param2_data(data_target_param2)
	worldedit.manip_helpers.finish(manip_target, data_target)
	
	
	---
	-- 3: Re-grab source
	---
	
	manip_source, area_source = worldedit.manip_helpers.init(source_pos1, source_pos2)
	data_source = manip_source:get_data()
	data_source_param2 = manip_source:get_param2_data()
	
	
	---
	-- 4: Zero out source, but avoiding touching any nodes that fall within target
	---
	
	for z = source_pos2.z, source_pos1.z, -1 do
		for y = source_pos2.y, source_pos1.y, -1 do
			for x = source_pos2.x, source_pos1.x, -1 do
				local source = Vector3.new(x, y, z)
				local source_i = area_source:index(x, y, z)
				local target = source:subtract(offset)
				
				if not source:is_contained(target_pos1, target_pos2) then
					data_source[source_i] = node_id_air
					data_source_param2[source_i] = 0
				end
			end
		end
	end
	
	
	--- 
	-- 5: Save source
	---
	
	manip_source:set_param2_data(data_source_param2)
	worldedit.manip_helpers.finish(manip_source, data_source)
	
	
	
	---
	-- 6: Finish up and return
	---
	
	return true, total_placed
end
