local Vector3 = require("worldeditadditions.utils.vector3")

describe("Vector3.max", function()
	it("should work with positive vectors", function()
		local a = Vector3.new(16, 64, 16)
		local b = Vector3.new(1, 4, 6)
		
		assert.are.same(
			Vector3.new(16, 64, 16),
			Vector3.max(a, b)
		)
	end)
	it("should work with mixed components", function()
		local a = Vector3.new(16, 1, 16)
		local b = Vector3.new(1, 4, 60)
		
		assert.are.same(
			Vector3.new(16, 4, 60),
			Vector3.max(a, b)
		)
	end)
	it("should work with scalar numbers", function()
		local a = Vector3.new(16, 1, 16)
		local b = 2
		
		assert.are.same(
			Vector3.new(16, 2, 16),
			Vector3.max(a, b)
		)
	end)
	it("should work with scalar numbers both ways around", function()
		local a = Vector3.new(16, 1, 16)
		local b = 2
		
		assert.are.same(
			Vector3.new(16, 2, 16),
			Vector3.max(b, a)
		)
	end)
	it("should work with negative vectors", function()
		local a = Vector3.new(-9, -16, -25)
		local b = Vector3.new(-3, -6, -2)
		
		assert.are.same(
			Vector3.new(-3, -6, -2),
			Vector3.max(a, b)
		)
	end)
	it("should return new Vector3 instances", function()
		local a = Vector3.new(16, 1, 16)
		local b = Vector3.new(1, 4, 60)
		
		local result = Vector3.max(a, b)
		assert.are.same(Vector3.new(16, 4, 60), result)
		
		result.y = 999
		
		assert.are.same(Vector3.new(16, 1, 16), a)
		assert.are.same(Vector3.new(1, 4, 60), b)
		assert.are.same(Vector3.new(16, 999, 60), result)
	end)
end)
