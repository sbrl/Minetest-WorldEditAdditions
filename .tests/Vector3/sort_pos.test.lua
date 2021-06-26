local Vector3 = require("worldeditadditions.utils.vector3")

describe("Vector3.sort", function()
	it("should work with positive vectors", function()
		local a = Vector3.new(16, 64, 16)
		local b = Vector3.new(1, 4, 6)
		
		local result_a, result_b = Vector3.sort(a, b)
		assert.are.same(Vector3.new(1, 4, 6), result_a)
		assert.are.same(Vector3.new(16, 64, 16), result_b)
	end)
	it("should work with mixed components", function()
		local a = Vector3.new(16, 1, 16)
		local b = Vector3.new(1, 4, 60)
		
		local result_a, result_b = Vector3.sort(a, b)
		assert.are.same(Vector3.new(1, 1, 16), result_a)
		assert.are.same(Vector3.new(16, 4, 60), result_b)
	end)
	it("should work with negative vectors", function()
		local a = Vector3.new(-9, -16, -25)
		local b = Vector3.new(-3, -6, -2)
		
		local result_a, result_b = Vector3.sort(a, b)
		assert.are.same(Vector3.new(-9, -16, -25), result_a)
		assert.are.same(Vector3.new(-3, -6, -2), result_b)
	end)
	it("should return new Vector3 instances", function()
		local a = Vector3.new(16, 1, 16)
		local b = Vector3.new(1, 4, 60)
		
		local result_a, result_b = Vector3.sort(a, b)
		assert.are.same(Vector3.new(1, 1, 16), result_a)
		assert.are.same(Vector3.new(16, 4, 60), result_b)
		
		result_a.y = 999
		result_b.y = 999
		
		assert.are.same(Vector3.new(16, 1, 16), a)
		assert.are.same(Vector3.new(1, 4, 60), b)
		assert.are.same(Vector3.new(1, 999, 16), result_a)
		assert.are.same(Vector3.new(16, 999, 60), result_b)
	end)
end)
