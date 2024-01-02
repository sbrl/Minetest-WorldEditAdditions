local wea_c = worldeditadditions_core
local Vector3 = wea_c.Vector3

---
-- @module worldeditadditions

--- Bonemeal command.
-- Applies bonemeal to all nodes with an air bloc above then.
-- @param	strength	number	The strength to apply - see bonemeal:on_use
-- @param	chance		number		Positive integer that represents the chance bonemealing will occur
-- @returns	bool,number,number	1. Whether the command succeeded or not.
-- 								2. The number of nodes actually bonemealed
-- 								3. The number of possible candidates we could have bonemealed
function worldeditadditions.bonemeal(pos1, pos2, strength, chance, nodename_list)
	if not nodename_list then nodename_list = {} end
	pos1, pos2 = Vector3.sort(pos1, pos2)
	-- pos2 will always have the highest co-ordinates now
	
	-- This command requires the bonemeal mod to be installed
	-- We check here too because other mods might call this function directly and bypass the chat command system
	if not minetest.get_modpath("bonemeal") then
		return false, "Bonemeal mod not loaded"
	end
	
	local node_list = wea_c.table.map(nodename_list, function(nodename)
		return minetest.get_content_id(nodename)
	end)
	local node_list_count = #nodename_list
	
	
	-- Fetch the nodes in the specified area
	local manip, area = worldedit.manip_helpers.init(pos1, pos2)
	local data = manip:get_data()
	
	local node_id_air = minetest.get_content_id("air")
	
	-- z y x is the preferred loop order (because CPU cache I'd guess), but that isn't really possible here
	local nodes_bonemealed = 0
	local candidates = 0
	for z = pos2.z, pos1.z, -1 do
		for x = pos2.x, pos1.x, -1 do
			for y = pos2.y, pos1.y, -1 do
				local i = area:index(x, y, z)
				if not wea_c.is_airlike(data[i]) then
					local should_bonemeal = true
					if node_list_count > 0 and not wea_c.table.contains(node_list, data[i]) then
						should_bonemeal = false
					end
					
					
					-- It's not an air node, so let's try to bonemeal it
					
					if should_bonemeal and math.random(0, chance - 1) == 0 then
						bonemeal:on_use(
							Vector3.new(x, y, z),
							strength,
							nil
						)
						nodes_bonemealed = nodes_bonemealed + 1
					end
					
					candidates = candidates + 1
				end
			end
		end
	end
	
	
	-- Save the modified nodes back to disk & return
	-- Note that we do NOT save it back to disk here, because we haven't actually changed anything
	-- We just grabbed the data via manip to allow for rapid node name lookups
	-- worldedit.manip_helpers.finish(manip, data)
	
	return true, nodes_bonemealed, candidates
end
