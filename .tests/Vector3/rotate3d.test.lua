local Vector3 = require("worldeditadditions_core.utils.vector3")

describe("Vector3.rotate3d", function()
	it("should work with an origin of (0,0,0) X axis", function()
		local origin = Vector3.new(0, 0, 0)
		local point = Vector3.new(0, 1, 0)
		local rotate = Vector3.new(
			math.rad(180), -- x axis = yz plane
			math.rad(0), -- y axis = xz plane
			math.rad(0)-- z axis = xy plane
		)
		assert.are.same(
			Vector3.new(0, -1, 0),
			Vector3.rotate3d(origin, point, rotate):round_dp(4)
		)
	end)
	it("should work with an origin of (0,0,0) Y axis", function()
		local origin = Vector3.new(0, 0, 0)
		local point = Vector3.new(1, 0, 0)
		local rotate = Vector3.new(
			math.rad(0), -- x axis = yz plane
			math.rad(180), -- y axis = xz plane
			math.rad(0)-- z axis = xy plane
		)
		assert.are.same(
			Vector3.new(-1, 0, 0),
			Vector3.rotate3d(origin, point, rotate):round_dp(4)
		)
	end)
	it("should work with an origin of (0,0,0) Z axis", function()
		local origin = Vector3.new(0, 0, 0)
		local point = Vector3.new(1, 0, 0)
		local rotate = Vector3.new(
			math.rad(0), -- x axis = yz plane
			math.rad(0), -- y axis = xz plane
			math.rad(180)-- z axis = xy plane
		)
		assert.are.same(
			Vector3.new(-1, 0, 0),
			Vector3.rotate3d(origin, point, rotate):round_dp(4)
		)
	end)
	
	
	
	it("should work with a non-zero origin X axis", function()
		local origin = Vector3.new(1, 1, 1)
		local point = Vector3.new(0, 2, 0)
		local rotate = Vector3.new(
			math.rad(180), -- x axis = yz plane
			math.rad(0), -- y axis = xz plane
			math.rad(0)-- z axis = xy plane
		)
		assert.are.same(
			Vector3.new(0, 0, 2),
			Vector3.rotate3d(origin, point, rotate):round_dp(4)
		)
	end)
	it("should work with a non-zero origin Y axis", function()
		local origin = Vector3.new(1, 1, 1)
		local point = Vector3.new(0, 2, 0)
		local rotate = Vector3.new(
			math.rad(0), -- x axis = yz plane
			math.rad(180), -- y axis = xz plane
			math.rad(0)-- z axis = xy plane
		)
		assert.are.same(
			Vector3.new(2, 2, 2),
			Vector3.rotate3d(origin, point, rotate):round_dp(4)
		)
	end)
	it("should work with a non-zero origin Z axis", function()
		local origin = Vector3.new(1, 1, 1)
		local point = Vector3.new(0, 2, 0)
		local rotate = Vector3.new(
			math.rad(0), -- x axis = yz plane
			math.rad(0), -- y axis = xz plane
			math.rad(180)-- z axis = xy plane
		)
		assert.are.same(
			Vector3.new(2, 0, 0),
			Vector3.rotate3d(origin, point, rotate):round_dp(4)
		)
	end)
	it("should work with a non-zero origin Z axis -90 degrees", function()
		local origin = Vector3.new(1, 1, 1)
		local point = Vector3.new(0, 2, 0)
		local rotate = Vector3.new(
			math.rad(0), -- x axis = yz plane
			math.rad(0), -- y axis = xz plane
			math.rad(-90)-- z axis = xy plane
		)
		assert.are.same(
			Vector3.new(2, 2, 0),
			Vector3.rotate3d(origin, point, rotate):round_dp(4)
		)
	end)
	it("should work with multiple axes X Y", function()
		local origin = Vector3.new(0, 0, 0)
		local point = Vector3.new(0, 2, 0)
		local rotate = Vector3.new(
			math.rad(90), -- x axis = yz plane
			math.rad(90), -- y axis = xz plane
			math.rad(0)-- z axis = xy plane
		)
		assert.are.same(
			Vector3.new(2, 0, 0),
			Vector3.rotate3d(origin, point, rotate):round_dp(4)
		)
	end)
	
	
	
	it("should return new Vector3 instances", function()
		local origin = Vector3.new(0, 0, 0)
		local point = Vector3.new(1, 0, 0)
		local rotate = Vector3.new(
			math.rad(0), -- x axis = yz plane
			math.rad(180), -- y axis = xz plane
			math.rad(0)-- z axis = xy plane
		)

		local result = Vector3.rotate3d(origin, point, rotate):round(4)
		assert.are.same(Vector3.new(-1, 0, 0), result)
		
		result.y = 999
		
		assert.are.same(Vector3.new(0, 0, 0), origin)
		assert.are.same(Vector3.new(1, 0, 0), point)
		assert.are.same(Vector3.new(-1, 999, 0), result)
	end)
end)
