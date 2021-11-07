-- ██     ██ ██ ██████  ███████     ██████   ██████  ██   ██
-- ██     ██ ██ ██   ██ ██          ██   ██ ██    ██  ██ ██
-- ██  █  ██ ██ ██████  █████       ██████  ██    ██   ███
-- ██ ███ ██ ██ ██   ██ ██          ██   ██ ██    ██  ██ ██
--  ███ ███  ██ ██   ██ ███████     ██████   ██████  ██   ██

--- Fills the edges of the selection box with nodes.
-- @param	{Position}	pos1	The 1st position defining the WorldEdit selection
-- @param	{Position}	pos2	The 2nd positioon defining the WorldEdit selection
-- @param	{string}	node	Name of the node to place
local v3 = worldeditadditions.Vector3
function worldeditadditions.wire_box(pos1,pos2,node)
	local node_id_replace = minetest.get_content_id(node)
	local ps1, ps2 = v3.sort(pos1,pos2)
	
	-- Fetch the nodes in the specified area
	local manip, area = worldedit.manip_helpers.init(pos1, pos2)
	local data = manip:get_data()
	
	-- Using three loops to reduce the number of nodes processed
	local counts = { replaced = 0 }
	
	for z = ps1.z,ps2.z do
		for _j,y in pairs({pos1.y,pos2.y}) do
			for _k,x in pairs({pos1.x,pos2.x}) do
				data[area:index(x, y, z)] = node_id_replace
				counts.replaced = counts.replaced + 1
			end
		end
	end
	if math.abs(ps2.y-ps1.y) > 1 then
		for _j,z in pairs({pos1.z,pos2.z}) do
			for y = pos1.y+1,pos2.y-1 do
				for _k,x in pairs({pos1.x,pos2.x}) do
					data[area:index(x, y, z)] = node_id_replace
					counts.replaced = counts.replaced + 1
				end
			end
		end
	end
	if math.abs(ps2.x-ps1.x) > 1 then
		for _j,z in pairs({pos1.z,pos2.z}) do
			for _k,y in pairs({pos1.y,pos2.y}) do
				for x = pos1.x+1,pos2.x-1 do
					data[area:index(x, y, z)] = node_id_replace
					counts.replaced = counts.replaced + 1
				end
			end
		end
	end
	-- Save the modified nodes back to disk & return
	worldedit.manip_helpers.finish(manip, data)
	
	return true, counts.replaced
end
