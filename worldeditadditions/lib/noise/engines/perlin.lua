local wea = worldeditadditions

-- original code by Ken Perlin: http://mrl.nyu.edu/~perlin/noise/
-- Port from this StackOverflow answer: https://stackoverflow.com/a/33425812/1460422


local function BitAND(a, b) --Bitwise and
	local p, c = 1, 0
	while a > 0 and b > 0 do
		local ra, rb = a%2, b%2
		if ra + rb > 1 then c = c + p end
		a, b, p = (a - ra) / 2, (b - rb) / 2, p * 2
	end
	return c
end

local function fade(t)
	return t * t * t * (t * (t * 6 - 15) + 10)
end

local function lerp(t, a, b)
	return a + t * (b - a)
end

local function grad(hash, x, y, z)
	local h = BitAND(hash, 15)
	local u = h < 8 and x or y
	local v = h < 4 and y or ((h == 12 or h == 14) and x or z)
	return ((h and 1) == 0 and u or - u) + ((h and 2) == 0 and v or - v)
end


wea.noise.perlin = {}
wea.noise.perlin.p = {}
wea.noise.perlin.permutation = {
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
wea.noise.perlin.size = 256
wea.noise.perlin.gx = {}
wea.noise.perlin.gy = {}
wea.noise.perlin.randMax = 256

--- Creates a new perlin instance.
-- @return	perlin	A new perlin instance.
function wea.noise.perlin.new()
	local instance = {}
	setmetatable(instance, wea.noise.perlin)
	instance:load()
	return instance
end

function wea.noise.perlin:load()
	for i = 1, self.size do
		self.p[i] = self.permutation[i]
		self.p[255 + i] = self.p[i]
	end
end

function wea.noise.perlin:noise( x, y, z )
	local X = BitAND(math.floor(x), 255) + 1
	local Y = BitAND(math.floor(y), 255) + 1
	local Z = BitAND(math.floor(z), 255) + 1

	x = x - math.floor(x)
	y = y - math.floor(y)
	z = z - math.floor(z)
	local u = fade(x)
	local v = fade(y)
	local w = fade(z)
	local A = self.p[X] + Y
	local AA = self.p[A] + Z
	local AB = self.p[A + 1] + Z
	local B = self.p[X + 1] + Y
	local BA = self.p[B] + Z
	local BB = self.p[B + 1] + Z

	return lerp(w, lerp(v, lerp(u, grad(self.p[AA ], x, y, z ),
		grad(self.p[BA ], x - 1, y, z )),
		lerp(u, grad(self.p[AB ], x, y - 1, z ),
	grad(self.p[BB ], x - 1, y - 1, z ))),
	lerp(v, lerp(u, grad(self.p[AA + 1], x, y, z - 1),
		grad(self.p[BA + 1], x - 1, y, z - 1)),
		lerp(u, grad(self.p[AB + 1], x, y - 1, z - 1),
	grad(self.p[BB + 1], x - 1, y - 1, z - 1))))
end
