local wea_c = worldeditadditions_core

--- Interpolates between the 2 given points
-- @param	a		Vector3|number		The starting point.
-- @param	b		Vector3|number		The ending point.
-- @param	time	number				The percentage between 0 and 1 to interpolate to.
-- @returns	Vector3|number				The interpolated point.
local function linear_interpolate(a, b, time)
	return ((b - a) * time) + a
end

--- Chaikin curve smoothing implementation.
-- This algorithm works by taking a list of points that define a segmented line,
-- and then interpolating between them to smooth the line.
-- @source Ported from https://git.starbeamrainbowlabs.com/sbrl-GitLab/Chaikin-Generator/src/branch/master/ChaikinGenerator/ChaikinCurve.cs
-- @param	arr_pos		Vector3[]	A list of points to interpolate.
-- @param	steps		number		The number of interpolatioon passes to do.
-- @returns	Vector3[]	A (longer) list of interpolated points.
local function chaikin(arr_pos, steps)
	
	local result = wea_c.table.shallowcopy(arr_pos)
	for pass = 1, steps do
		local pos_start = result[1]
		local pos_end = result[#result]
				
		for i = 1,#result-1,2 do
			result[i] = linear_interpolate(result[i], result[i+1], 0.25)
			table.insert(result, i+1, linear_interpolate(result[i], result[i+2]))
		end
		-- table.remove(result, #result-1) -- In the original, but I don't know why
		
		-- Keep the starting & ending positions the same
		result[1] = pos_start
		result[#result] = pos_end
	end
	
	return result
end

return {
	chaikin = chaikin,
	linear_interpolate = linear_interpolate
}