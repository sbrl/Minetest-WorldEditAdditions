local wea_c = worldeditadditions_core
local Vector3 = wea_c.Vector3

--  ██████  ██████  ██████  ███    ██ ███████ ██████      ███████ ███████ ████████
-- ██      ██    ██ ██   ██ ████   ██ ██      ██   ██     ██      ██         ██
-- ██      ██    ██ ██████  ██ ██  ██ █████   ██████      ███████ █████      ██
-- ██      ██    ██ ██   ██ ██  ██ ██ ██      ██   ██          ██ ██         ██
--  ██████  ██████  ██   ██ ██   ████ ███████ ██   ██     ███████ ███████    ██

--- Puts a node at each corner of selection box.
-- @param	pos1	Vector3		The 1st position defining the WorldEdit selection
-- @param	pos2	Vector3		The 2nd positioon defining the WorldEdit selection
-- @param	node	string		Name of the node to place
function worldeditadditions.corner_set(pos1, pos2, node)

    -- z y x is the preferred loop order (because CPU cache I'd guess, since then we're iterating linearly through the data array)
    local counts = {replaced = 0}
    for i, z in pairs({pos1.z, pos2.z}) do
        for j, y in pairs({pos1.y, pos2.y}) do
            for k, x in pairs({pos1.x, pos2.x}) do
                minetest.set_node(Vector3.new(x, y, z), {name = node})
                counts.replaced = counts.replaced + 1
            end
        end
    end

    return true, counts.replaced
end
