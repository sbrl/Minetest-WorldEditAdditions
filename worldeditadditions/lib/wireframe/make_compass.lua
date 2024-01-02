local wea_c = worldeditadditions_core
local Vector3 = wea_c.Vector3

---
-- @module worldeditadditions

-- ███    ███  █████  ██   ██ ███████      ██████  ██████  ███    ███ ██████   █████  ███████ ███████
-- ████  ████ ██   ██ ██  ██  ██          ██      ██    ██ ████  ████ ██   ██ ██   ██ ██      ██
-- ██ ████ ██ ███████ █████   █████       ██      ██    ██ ██ ████ ██ ██████  ███████ ███████ ███████
-- ██  ██  ██ ██   ██ ██  ██  ██          ██      ██    ██ ██  ██  ██ ██      ██   ██      ██      ██
-- ██      ██ ██   ██ ██   ██ ███████      ██████  ██████  ██      ██ ██      ██   ██ ███████ ███████

--- Makes a compass with a bead pointing north (+Z).
-- @param	pos1	Vector3	The 1st position defining the WorldEdit selection
-- @param	node1	string	Name of the node to place
-- @param	node2	string	Name of the node of the bead
function worldeditadditions.make_compass(pos1,node1,node2)
	pos1 = Vector3.clone(pos1)
	minetest.set_node(pos1 + Vector3.new(0,1,3), { name = node2 })
	local counts = { replaced = 1 }
	
	-- z y x is the preferred loop order (because CPU cache I'd guess, since then we're iterating linearly through the data array)
	for z = -3,3 do
		if z ~= 0 then
			for k,x in pairs({math.floor(-3/math.abs(z)),0,math.ceil(3/math.abs(z))}) do
				minetest.set_node(Vector3.new(pos1.x+x,pos1.y,pos1.z+z), {name=node1})
				counts.replaced = counts.replaced + 1
			end
		else
			for x = -3,3 do
				minetest.set_node(Vector3.new(pos1.x+x,pos1.y,pos1.z), {name=node1})
				counts.replaced = counts.replaced + 1
			end
		end
	end
	
	return true, counts.replaced
end
