local wea = worldeditadditions

--- Perlin noise generation engine.
-- Original code by Ken Perlin: http://mrl.nyu.edu/~perlin/noise/
-- Port from this StackOverflow answer: https://stackoverflow.com/a/33425812/1460422
-- @class
local Perlin = {}
Perlin.__index = Perlin

Perlin.p = {}
Perlin.permutation = {
	151, 160, 137, 91, 90, 15, 131, 13, 201, 95, 96, 53, 194, 233, 7, 225, 140,
	36, 103, 30, 69, 142, 8, 99, 37, 240, 21, 10, 23, 190, 6, 148, 247, 120,
	234, 75, 0, 26, 197, 62, 94, 252, 219, 203, 117, 35, 11, 32, 57, 177, 33,
	88, 237, 149, 56, 87, 174, 20, 125, 136, 171, 168, 68, 175, 74, 165, 71,
	134, 139, 48, 27, 166, 77, 146, 158, 231, 83, 111, 229, 122, 60, 211, 133,
	230, 220, 105, 92, 41, 55, 46, 245, 40, 244, 102, 143, 54, 65, 25, 63, 161,
	1, 216, 80, 73, 209, 76, 132, 187, 208, 89, 18, 169, 200, 196, 135, 130,
	116, 188, 159, 86, 164, 100, 109, 198, 173, 186, 3, 64, 52, 217, 226, 250,
	124, 123, 5, 202, 38, 147, 118, 126, 255, 82, 85, 212, 207, 206, 59, 227,
	47, 16, 58, 17, 182, 189, 28, 42, 223, 183, 170, 213, 119, 248, 152, 2, 44,
	154, 163, 70, 221, 153, 101, 155, 167, 43, 172, 9, 129, 22, 39, 253, 19,
	98, 108, 110, 79, 113, 224, 232, 178, 185, 112, 104, 218, 246, 97, 228,
	251, 34, 242, 193, 238, 210, 144, 12, 191, 179, 162, 241, 81, 51, 145, 235,
	249, 14, 239, 107, 49, 192, 214, 31, 181, 199, 106, 157, 184, 84, 204, 176,
	115, 121, 50, 45, 127, 4, 150, 254, 138, 236, 205, 93, 222, 114, 67, 29,
	24, 72, 243, 141, 128, 195, 78, 66, 215, 61, 156, 180
}
Perlin.size = 256
Perlin.gx = {}
Perlin.gy = {}
Perlin.randMax = 256

--- Creates a new Perlin instance.
-- @return	Perlin	A new perlin instance.
function Perlin.new()
	local instance = {}
	setmetatable(instance, Perlin)
	instance:load()
	return instance
end

--- Initialises this Perlin instance.
-- Called automatically by the constructor - you do NOT need to call this
-- yourself.
function Perlin:load()
	for i = 1, self.size do
		self.p[i - 1] = self.permutation[i]
		self.p[i + 255] = self.permutation[i]
	end
end

--- Returns a noise value for a given point in 3D space.
-- @param	x	number	The x co-ordinate.
-- @param	y	number	The y co-ordinate.
-- @param	z	number	The z co-ordinate.
-- @returns	number		The calculated noise value.
function Perlin:noise( x, y, z )
	y = y or 0
	z = z or 0
	local xi = wea.bit.band(math.floor(x), 255)
	local yi = wea.bit.band(math.floor(y), 255)
	local zi = wea.bit.band(math.floor(z), 255)
	
	-- print("x", x, "y", y, "z", z, "xi", xi, "yi", yi, "zi", zi)
	-- print("p[xi]", self.p[xi])
	x = x - math.floor(x)
	y = y - math.floor(y)
	z = z - math.floor(z)
	local u = self:fade(x)
	local v = self:fade(y)
	local w = self:fade(z)
	local A = self.p[xi] + yi
	local AA = self.p[A] + zi
	local AB = self.p[A + 1] + zi
	local AAA = self.p[AA]
	local ABA = self.p[AB]
	local AAB = self.p[AA + 1]
	local ABB = self.p[AB + 1]
	
	local B = self.p[xi + 1] + yi
	local BA = self.p[B] + zi
	local BB = self.p[B + 1] + zi
	local BAA = self.p[BA]
	local BBA = self.p[BB]
	local BAB = self.p[BA + 1]
	local BBB = self.p[BB + 1]
	
	-- Add 0.5 to rescale to 0 - 1 instead of -0.5 - +0.5
	return 0.5 + self:lerp(w,
		self:lerp(v,
			self:lerp(u,
				self:grad(AAA,x,y,z),
				self:grad(BAA,x-1,y,z)
			),
			self:lerp(u,
				self:grad(ABA,x,y-1,z),
				self:grad(BBA,x-1,y-1,z)
			)
		),
		self:lerp(v,
			self:lerp(u,
				self:grad(AAB,x,y,z-1), self:grad(BAB,x-1,y,z-1)
			),
			self:lerp(u,
				self:grad(ABB,x,y-1,z-1), self:grad(BBB,x-1,y-1,z-1)
			)
		)
	)
end

function Perlin:fade(t)
	return t * t * t * (t * (t * 6 - 15) + 10)
end

function Perlin:lerp(t, a, b)
	return a + t * (b - a)
end

function Perlin:grad(hash, x, y, z)
	local h = wea.bit.band(hash, 15)
	local u = h < 8 and x or y
	local v = h < 4 and y or ((h == 12 or h == 14) and x or z)
	return ((h and 1) == 0 and u or - u) + ((h and 2) == 0 and v or - v)
end


return Perlin
