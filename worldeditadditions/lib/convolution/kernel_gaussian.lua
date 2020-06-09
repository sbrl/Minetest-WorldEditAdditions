-- Ported from Javascript by Starbeamrainbowlabs
-- Original source: https://github.com/sidorares/gaussian-convolution-kernel/
-- From 
-- the code is taken from https://github.com/mattlockyer/iat455/blob/6493c882f1956703133c1bffa1d7ee9a83741cbe/assignment1/assignment/effects/blur-effect-dyn.js
-- (c) Matt Lockyer, https://github.com/mattlockyer

-- hypotenuse has moved to utils/numbers.lua

--[[
 * Generates a kernel used for the gaussian blur effect.
 *
 * @param dimension is an odd integer
 * @param sigma is the standard deviation used for our gaussian function.
 *
 * @returns an array with dimension^2 number of numbers, all less than or equal
 *	 to 1. Represents our gaussian blur kernel.
]]--
function worldeditadditions.conv.kernel_gaussian(dimension, sigma)
	if not (dimension % 2) or math.floor(dimension) ~= dimension or dimension < 3 then
		return false, "The dimension must be an odd integer greater than or equal to 3"
	end
	local kernel = {};

	local two_sigma_square = 2 * sigma * sigma;
	local centre = (dimension - 1) / 2;
	
	local sum = 0
	for i = 0, dimension-1 do
		for j = 0, dimension-1 do
			local distance = worldeditadditions.hypotenuse(i, j, centre, centre)

			-- The following is an algorithm that came from the gaussian blur
			-- wikipedia page [1].
			--
			-- http://en.wikipedia.org/w/index.php?title=Gaussian_blur&oldid=608793634#Mechanics
			local gaussian = (1 / math.sqrt(
				math.pi * two_sigma_square
			)) * math.exp((-1) * (math.pow(distance, 2) / two_sigma_square));
			
			sum = sum + gaussian
			kernel[i*dimension + j] = gaussian
		end
	end
	
	-- Returns the unit vector of the kernel array.
	for k,v in pairs(kernel) do
		kernel[k] = kernel[k] / sum
	end
	
	return true, kernel
end
