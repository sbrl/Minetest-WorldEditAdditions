
--- Applies the given noise field to the given heightmap.
-- Mutates the given heightmap.
-- @param	heightmap		number[]			A table of ZERO indexed numbers representing the heghtmap - see worldeditadditions.make_heightmap().
-- @param	noise			number[]			An table identical in structure to the heightmap containing the noise values to apply.
-- @param	heightmap_size	{x:number,z:number}	A 2d vector representing the size of the heightmap.
-- @param	region_height	number				The height of the defined region.
-- @param	apply_mode		string				The apply mode to use to apply the noise to the heightmap.
-- @returns	bool[,string]	A boolean value representing whether the application was successful or not. If false, then an error message as a string is also returned describing the error that occurred.
function worldeditadditions.noise.apply_2d(heightmap, noise, heightmap_size, region_height, apply_mode)
	if type(apply_mode) ~= "string" then
		return false, "Error: Expected string value for apply_mode, but received value of type "..type(apply_mode)
	end
	
	local percent = tonumber(apply_mode:match("^(%d+)%%$"))
	
	for z = heightmap_size.z - 1, 0, -1 do
		for x = heightmap_size.x - 1, 0, -1 do
			local i = (z * heightmap_size.x) + x
			
			if apply_mode == "add" then
				heightmap[i] = heightmap[i] + noise[i]
			elseif apply_mode == "multiply" then
				heightmap[i] = heightmap[i] * noise[i]
			elseif percent then
				-- Rescale from 0 - 1 to -1 - +1
				local rescaled = (noise[i] * 2) - 1
				-- Rescale to match the percentage specified
				rescaled = rescaled * region_height * percent
				heightmap[i] = rescaled
			else
				return false, "Error: Unknown apply mode '"..apply_mode.."'"
			end
		end
	end
	
	return true
end
