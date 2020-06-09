worldeditadditions.conv = {}

dofile(worldeditadditions.modpath.."/lib/conv/kernels.lua")
dofile(worldeditadditions.modpath.."/lib/conv/kernel_gaussian.lua")

dofile(worldeditadditions.modpath.."/lib/conv/convolve.lua")

--- Creates a new kernel.
-- Note that the gaussian kernel only allows for creating a square kernel.
-- arg is only used by the gaussian kernel as the sigma value (default: 2)
-- @param	name	string	The name of the kernel to create (possible values: box, pascal, gaussian).
-- @param	width	number	The width of the kernel to create (must be an odd integer).
-- @param	height	number	The height of the kernel to create (must be an odd integer).
-- @param	arg		number	The argument to pass when creating the kernel. Currently only used by gaussian kernel as the sigma value.
function worldeditadditions.get_conv_kernel(name, width, height, arg)
	if width % 2 ~= 1 then
		return false, "Error: The width must be an odd integer.";
	end
	if height % 2 ~= 1 then
		return false, "Error: The height must be an odd integer";
	end
	
	if name == "box" then
		return true, worldeditadditions.conv.kernel_box(width, height)
	elseif name == "pascal" then
		return true, worldeditadditions.conv.kernel_pascal(width, height, true)
	elseif name == "gaussian" then
		if width ~= height then
			return false, "Error: When using a gaussian kernel the width and height must be identical."
		end
		-- Default to sigma = 2
		if arg == nil then arg = 2 end
		local success, result = worldeditadditions.conv.kernel_gaussian(width, arg)
		return success, result
	end
	
	return false, "Error: Unknown kernel. Valid values: box, pascal, gaussian"
end


function worldeditadditions.convolve(pos1, pos2, kernel, kernel_size)
	pos1, pos2 = worldedit.sort_pos(pos1, pos2)
	
	local border_size = {}
	border_size[0] = (kernel_size[0]-1) / 2		-- height
	border_size[1] = (kernel_size[1]-1) / 2		-- width
	
	pos1.z = pos1.z - border_size[0]
	pos2.z = pos2.z + border_size[0]
	pos1.x = pos1.x - border_size[1]
	pos2.x = pos2.x + border_size[1]
	
	local manip, area = worldedit.manip_helpers.init(pos1, pos2)
	local data = manip:get_data()
	
	local stats = { added = 0, removed = 0 }
	
	local node_id_air = minetest.get_content_id("air")
	
	local heightmap = worldeditadditions.make_heightmap(pos1, pos2, manip, area, data)
	local heightmap_conv = worldeditadditions.shallowcopy(heightmap)
	
	local heightmap_size = {}
	heightmap_size[0] = (pos2.z - pos1.z) + 1
	heightmap_size[1] = (pos2.x - pos1.x) + 1
	
	worldeditadditions.conv.convolve(
		heightmap_conv,
		heightmap_size,
		kernel,
		kernel_size
	)
	
	-- print("original")
	-- worldeditadditions.print_2d(heightmap, (pos2.z - pos1.z) + 1)
	-- print("transformed")
	-- worldeditadditions.print_2d(heightmap_conv, (pos2.z - pos1.z) + 1)
	-- It seems to be convolving as intended, but something's probably getting lost in translation below
	
	for z = heightmap_size[0], 0, -1 do
		for x = heightmap_size[1], 0, -1 do
			local hi = z*heightmap_size[1] + x
			
			
			local height_old = heightmap[hi]
			local height_new = heightmap_conv[hi]
			-- print("[conv/save] hi", hi, "height_old", heightmap[hi], "height_new", heightmap_conv[hi], "z", z, "x", x, "pos1.y", pos1.y)
			
			-- Lua doesn't have a continue statement :-/
			if height_old == height_new then
				-- noop
			elseif height_new < height_old then
				stats.removed = stats.removed + (height_old - height_new)
				local y = height_new
				while y < height_old do
					local ci = area:index(pos1.x + x, pos1.y + y, pos1.z + z)
					-- print("[conv/save] remove at y", y, "→", pos1.y + y, "current:", minetest.get_name_from_content_id(data[ci]))
					data[ci] = node_id_air
					y = y + 1
				end
			else -- height_new > height_old
				-- We subtract one because the heightmap starts at 1 (i.e. 1 = 1 node in the column), but the selected region is inclusive
				local node_id = data[area:index(pos1.x + x, pos1.y + (height_old - 1), pos1.z + z)]
				-- print("[conv/save] filling with ", node_id, "→", minetest.get_name_from_content_id(node_id))
				
				stats.added = stats.added + (height_new - height_old)
				local y = height_old
				while y < height_new do
					local ci = area:index(pos1.x + x, pos1.y + y, pos1.z + z)
					-- print("[conv/save] add at y", y, "→", pos1.y + y, "current:", minetest.get_name_from_content_id(data[ci]))
					data[ci] = node_id
					y = y + 1
				end
			end
		end
	end
	
	worldedit.manip_helpers.finish(manip, data)
	
	return true, stats
end
