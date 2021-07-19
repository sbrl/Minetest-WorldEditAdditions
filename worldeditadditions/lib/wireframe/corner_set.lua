--  ██████  ██████  ██████  ███    ██ ███████ ██████      ███████ ███████ ████████
-- ██      ██    ██ ██   ██ ████   ██ ██      ██   ██     ██      ██         ██
-- ██      ██    ██ ██████  ██ ██  ██ █████   ██████      ███████ █████      ██
-- ██      ██    ██ ██   ██ ██  ██ ██ ██      ██   ██          ██ ██         ██
--  ██████  ██████  ██   ██ ██   ████ ███████ ██   ██     ███████ ███████    ██

--- Puts a node at each corner of selection box.
-- @param	{Position}	pos1	The 1st position defining the WorldEdit selection
-- @param	{Position}	pos2	The 2nd positioon defining the WorldEdit selection
-- @param	{string}	node	Name of the node to place
function worldeditadditions.corner_set(pos1,pos2,node)
	
	-- z y x is the preferred loop order (because CPU cache I'd guess, since then we're iterating linearly through the data array)
	local counts = { replaced = 0 }
	for k,z in pairs({pos1.z,pos2.z}) do
		for k,y in pairs({pos1.y,pos2.y}) do
			for k,x in pairs({pos1.x,pos2.x}) do
				minetest.set_node(vector.new(x,y,z), {name=node})
				counts.replaced = counts.replaced + 1
			end
		end
	end
	
	return true, counts.replaced
end
-- function worldeditadditions.corner_set(pos1,pos2,node)
-- 	local node_id_replace = minetest.get_content_id(node)
--
-- 	-- Fetch the nodes in the specified area
-- 	local manip, area = worldedit.manip_helpers.init(pos1, pos2)
-- 	local data = manip:get_data()
--
-- 	-- z y x is the preferred loop order (because CPU cache I'd guess, since then we're iterating linearly through the data array)
-- 	local counts = { replaced = 0 }
-- 	for k,z in pairs({pos1.z,pos2.z}) do
-- 		for k,y in pairs({pos1.y,pos2.y}) do
-- 			for k,x in pairs({pos1.x,pos2.x}) do
-- 				data[area:index(x, y, z)] = node_id_replace
-- 				counts.replaced = counts.replaced + 1
-- 			end
-- 		end
-- 	end
-- 	-- Save the modified nodes back to disk & return
-- 	worldedit.manip_helpers.finish(manip, data)
--
-- 	return true, counts.replaced
-- end
